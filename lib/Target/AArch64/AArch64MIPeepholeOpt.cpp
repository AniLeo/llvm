//===- AArch64MIPeepholeOpt.cpp - AArch64 MI peephole optimization pass ---===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass performs below peephole optimizations on MIR level.
//
// 1. MOVi32imm + ANDWrr ==> ANDWri + ANDWri
//    MOVi64imm + ANDXrr ==> ANDXri + ANDXri
//
// 2. MOVi32imm + ADDWrr ==> ADDWRi + ADDWRi
//    MOVi64imm + ADDXrr ==> ANDXri + ANDXri
//
// 3. MOVi32imm + SUBWrr ==> SUBWRi + SUBWRi
//    MOVi64imm + SUBXrr ==> SUBXri + SUBXri
//
//    The mov pseudo instruction could be expanded to multiple mov instructions
//    later. In this case, we could try to split the constant  operand of mov
//    instruction into two immediates which can be directly encoded into
//    *Wri/*Xri instructions. It makes two AND/ADD/SUB instructions instead of
//    multiple `mov` + `and/add/sub` instructions.
//
// 4. Remove redundant ORRWrs which is generated by zero-extend.
//
//    %3:gpr32 = ORRWrs $wzr, %2, 0
//    %4:gpr64 = SUBREG_TO_REG 0, %3, %subreg.sub_32
//
//    If AArch64's 32-bit form of instruction defines the source operand of
//    ORRWrs, we can remove the ORRWrs because the upper 32 bits of the source
//    operand are set to zero.
//
//===----------------------------------------------------------------------===//

#include "AArch64ExpandImm.h"
#include "AArch64InstrInfo.h"
#include "MCTargetDesc/AArch64AddressingModes.h"
#include "llvm/ADT/Optional.h"
#include "llvm/ADT/SetVector.h"
#include "llvm/CodeGen/MachineDominators.h"
#include "llvm/CodeGen/MachineLoopInfo.h"

using namespace llvm;

#define DEBUG_TYPE "aarch64-mi-peephole-opt"

namespace {

struct AArch64MIPeepholeOpt : public MachineFunctionPass {
  static char ID;

  AArch64MIPeepholeOpt() : MachineFunctionPass(ID) {
    initializeAArch64MIPeepholeOptPass(*PassRegistry::getPassRegistry());
  }

  const AArch64InstrInfo *TII;
  const AArch64RegisterInfo *TRI;
  MachineLoopInfo *MLI;
  MachineRegisterInfo *MRI;

  using OpcodePair = std::pair<unsigned, unsigned>;
  template <typename T>
  using SplitAndOpcFunc =
      std::function<Optional<OpcodePair>(T, unsigned, T &, T &)>;
  using BuildMIFunc =
      std::function<void(MachineInstr &, OpcodePair, unsigned, unsigned,
                         Register, Register, Register)>;

  /// For instructions where an immediate operand could be split into two
  /// separate immediate instructions, use the splitTwoPartImm two handle the
  /// optimization.
  ///
  /// To implement, the following function types must be passed to
  /// splitTwoPartImm. A SplitAndOpcFunc must be implemented that determines if
  /// splitting the immediate is valid and returns the associated new opcode. A
  /// BuildMIFunc must be implemented to build the two immediate instructions.
  ///
  /// Example Pattern (where IMM would require 2+ MOV instructions):
  ///     %dst = <Instr>rr %src IMM [...]
  /// becomes:
  ///     %tmp = <Instr>ri %src (encode half IMM) [...]
  ///     %dst = <Instr>ri %tmp (encode half IMM) [...]
  template <typename T>
  bool splitTwoPartImm(MachineInstr &MI,
                       SplitAndOpcFunc<T> SplitAndOpc, BuildMIFunc BuildInstr);

  bool checkMovImmInstr(MachineInstr &MI, MachineInstr *&MovMI,
                        MachineInstr *&SubregToRegMI);

  template <typename T>
  bool visitADDSUB(unsigned PosOpc, unsigned NegOpc, MachineInstr &MI);
  template <typename T>
  bool visitADDSSUBS(OpcodePair PosOpcs, OpcodePair NegOpcs, MachineInstr &MI);

  template <typename T>
  bool visitAND(unsigned Opc, MachineInstr &MI);
  bool visitORR(MachineInstr &MI);
  bool runOnMachineFunction(MachineFunction &MF) override;

  StringRef getPassName() const override {
    return "AArch64 MI Peephole Optimization pass";
  }

  void getAnalysisUsage(AnalysisUsage &AU) const override {
    AU.setPreservesCFG();
    AU.addRequired<MachineLoopInfo>();
    MachineFunctionPass::getAnalysisUsage(AU);
  }
};

char AArch64MIPeepholeOpt::ID = 0;

} // end anonymous namespace

INITIALIZE_PASS(AArch64MIPeepholeOpt, "aarch64-mi-peephole-opt",
                "AArch64 MI Peephole Optimization", false, false)

template <typename T>
static bool splitBitmaskImm(T Imm, unsigned RegSize, T &Imm1Enc, T &Imm2Enc) {
  T UImm = static_cast<T>(Imm);
  if (AArch64_AM::isLogicalImmediate(UImm, RegSize))
    return false;

  // If this immediate can be handled by one instruction, do not split it.
  SmallVector<AArch64_IMM::ImmInsnModel, 4> Insn;
  AArch64_IMM::expandMOVImm(UImm, RegSize, Insn);
  if (Insn.size() == 1)
    return false;

  // The bitmask immediate consists of consecutive ones.  Let's say there is
  // constant 0b00000000001000000000010000000000 which does not consist of
  // consecutive ones. We can split it in to two bitmask immediate like
  // 0b00000000001111111111110000000000 and 0b11111111111000000000011111111111.
  // If we do AND with these two bitmask immediate, we can see original one.
  unsigned LowestBitSet = countTrailingZeros(UImm);
  unsigned HighestBitSet = Log2_64(UImm);

  // Create a mask which is filled with one from the position of lowest bit set
  // to the position of highest bit set.
  T NewImm1 = (static_cast<T>(2) << HighestBitSet) -
              (static_cast<T>(1) << LowestBitSet);
  // Create a mask which is filled with one outside the position of lowest bit
  // set and the position of highest bit set.
  T NewImm2 = UImm | ~NewImm1;

  // If the split value is not valid bitmask immediate, do not split this
  // constant.
  if (!AArch64_AM::isLogicalImmediate(NewImm2, RegSize))
    return false;

  Imm1Enc = AArch64_AM::encodeLogicalImmediate(NewImm1, RegSize);
  Imm2Enc = AArch64_AM::encodeLogicalImmediate(NewImm2, RegSize);
  return true;
}

template <typename T>
bool AArch64MIPeepholeOpt::visitAND(
    unsigned Opc, MachineInstr &MI) {
  // Try below transformation.
  //
  // MOVi32imm + ANDWrr ==> ANDWri + ANDWri
  // MOVi64imm + ANDXrr ==> ANDXri + ANDXri
  //
  // The mov pseudo instruction could be expanded to multiple mov instructions
  // later. Let's try to split the constant operand of mov instruction into two
  // bitmask immediates. It makes only two AND instructions intead of multiple
  // mov + and instructions.

  return splitTwoPartImm<T>(
      MI,
      [Opc](T Imm, unsigned RegSize, T &Imm0, T &Imm1) -> Optional<OpcodePair> {
        if (splitBitmaskImm(Imm, RegSize, Imm0, Imm1))
          return std::make_pair(Opc, Opc);
        return None;
      },
      [&TII = TII](MachineInstr &MI, OpcodePair Opcode, unsigned Imm0,
                   unsigned Imm1, Register SrcReg, Register NewTmpReg,
                   Register NewDstReg) {
        DebugLoc DL = MI.getDebugLoc();
        MachineBasicBlock *MBB = MI.getParent();
        BuildMI(*MBB, MI, DL, TII->get(Opcode.first), NewTmpReg)
            .addReg(SrcReg)
            .addImm(Imm0);
        BuildMI(*MBB, MI, DL, TII->get(Opcode.second), NewDstReg)
            .addReg(NewTmpReg)
            .addImm(Imm1);
      });
}

bool AArch64MIPeepholeOpt::visitORR(MachineInstr &MI) {
  // Check this ORR comes from below zero-extend pattern.
  //
  // def : Pat<(i64 (zext GPR32:$src)),
  //           (SUBREG_TO_REG (i32 0), (ORRWrs WZR, GPR32:$src, 0), sub_32)>;
  if (MI.getOperand(3).getImm() != 0)
    return false;

  if (MI.getOperand(1).getReg() != AArch64::WZR)
    return false;

  MachineInstr *SrcMI = MRI->getUniqueVRegDef(MI.getOperand(2).getReg());
  if (!SrcMI)
    return false;

  // From https://developer.arm.com/documentation/dui0801/b/BABBGCAC
  //
  // When you use the 32-bit form of an instruction, the upper 32 bits of the
  // source registers are ignored and the upper 32 bits of the destination
  // register are set to zero.
  //
  // If AArch64's 32-bit form of instruction defines the source operand of
  // zero-extend, we do not need the zero-extend. Let's check the MI's opcode is
  // real AArch64 instruction and if it is not, do not process the opcode
  // conservatively.
  if (SrcMI->getOpcode() == TargetOpcode::COPY &&
      SrcMI->getOperand(1).getReg().isVirtual()) {
    const TargetRegisterClass *RC =
        MRI->getRegClass(SrcMI->getOperand(1).getReg());

    // A COPY from an FPR will become a FMOVSWr, so do so now so that we know
    // that the upper bits are zero.
    if (RC != &AArch64::FPR32RegClass &&
        ((RC != &AArch64::FPR64RegClass && RC != &AArch64::FPR128RegClass) ||
         SrcMI->getOperand(1).getSubReg() != AArch64::ssub))
      return false;
    Register CpySrc = SrcMI->getOperand(1).getReg();
    if (SrcMI->getOperand(1).getSubReg() == AArch64::ssub) {
      CpySrc = MRI->createVirtualRegister(&AArch64::FPR32RegClass);
      BuildMI(*SrcMI->getParent(), SrcMI, SrcMI->getDebugLoc(),
              TII->get(TargetOpcode::COPY), CpySrc)
          .add(SrcMI->getOperand(1));
    }
    BuildMI(*SrcMI->getParent(), SrcMI, SrcMI->getDebugLoc(),
            TII->get(AArch64::FMOVSWr), SrcMI->getOperand(0).getReg())
        .addReg(CpySrc);
    SrcMI->eraseFromParent();
  }
  else if (SrcMI->getOpcode() <= TargetOpcode::GENERIC_OP_END)
    return false;

  Register DefReg = MI.getOperand(0).getReg();
  Register SrcReg = MI.getOperand(2).getReg();
  MRI->replaceRegWith(DefReg, SrcReg);
  MRI->clearKillFlags(SrcReg);
  LLVM_DEBUG(dbgs() << "Removed: " << MI << "\n");
  MI.eraseFromParent();

  return true;
}

template <typename T>
static bool splitAddSubImm(T Imm, unsigned RegSize, T &Imm0, T &Imm1) {
  // The immediate must be in the form of ((imm0 << 12) + imm1), in which both
  // imm0 and imm1 are non-zero 12-bit unsigned int.
  if ((Imm & 0xfff000) == 0 || (Imm & 0xfff) == 0 ||
      (Imm & ~static_cast<T>(0xffffff)) != 0)
    return false;

  // The immediate can not be composed via a single instruction.
  SmallVector<AArch64_IMM::ImmInsnModel, 4> Insn;
  AArch64_IMM::expandMOVImm(Imm, RegSize, Insn);
  if (Insn.size() == 1)
    return false;

  // Split Imm into (Imm0 << 12) + Imm1;
  Imm0 = (Imm >> 12) & 0xfff;
  Imm1 = Imm & 0xfff;
  return true;
}

template <typename T>
bool AArch64MIPeepholeOpt::visitADDSUB(
    unsigned PosOpc, unsigned NegOpc, MachineInstr &MI) {
  // Try below transformation.
  //
  // MOVi32imm + ADDWrr ==> ADDWri + ADDWri
  // MOVi64imm + ADDXrr ==> ADDXri + ADDXri
  //
  // MOVi32imm + SUBWrr ==> SUBWri + SUBWri
  // MOVi64imm + SUBXrr ==> SUBXri + SUBXri
  //
  // The mov pseudo instruction could be expanded to multiple mov instructions
  // later. Let's try to split the constant operand of mov instruction into two
  // legal add/sub immediates. It makes only two ADD/SUB instructions intead of
  // multiple `mov` + `and/sub` instructions.

  return splitTwoPartImm<T>(
      MI,
      [PosOpc, NegOpc](T Imm, unsigned RegSize, T &Imm0,
                       T &Imm1) -> Optional<OpcodePair> {
        if (splitAddSubImm(Imm, RegSize, Imm0, Imm1))
          return std::make_pair(PosOpc, PosOpc);
        if (splitAddSubImm(-Imm, RegSize, Imm0, Imm1))
          return std::make_pair(NegOpc, NegOpc);
        return None;
      },
      [&TII = TII](MachineInstr &MI, OpcodePair Opcode, unsigned Imm0,
                   unsigned Imm1, Register SrcReg, Register NewTmpReg,
                   Register NewDstReg) {
        DebugLoc DL = MI.getDebugLoc();
        MachineBasicBlock *MBB = MI.getParent();
        BuildMI(*MBB, MI, DL, TII->get(Opcode.first), NewTmpReg)
            .addReg(SrcReg)
            .addImm(Imm0)
            .addImm(12);
        BuildMI(*MBB, MI, DL, TII->get(Opcode.second), NewDstReg)
            .addReg(NewTmpReg)
            .addImm(Imm1)
            .addImm(0);
      });
}

template <typename T>
bool AArch64MIPeepholeOpt::visitADDSSUBS(
    OpcodePair PosOpcs, OpcodePair NegOpcs, MachineInstr &MI) {
  // Try the same transformation as ADDSUB but with additional requirement
  // that the condition code usages are only for Equal and Not Equal
  return splitTwoPartImm<T>(
      MI,
      [PosOpcs, NegOpcs, &MI, &TRI = TRI, &MRI = MRI](
          T Imm, unsigned RegSize, T &Imm0, T &Imm1) -> Optional<OpcodePair> {
        OpcodePair OP;
        if (splitAddSubImm(Imm, RegSize, Imm0, Imm1))
          OP = PosOpcs;
        else if (splitAddSubImm(-Imm, RegSize, Imm0, Imm1))
          OP = NegOpcs;
        else
          return None;
        // Check conditional uses last since it is expensive for scanning
        // proceeding instructions
        MachineInstr &SrcMI = *MRI->getUniqueVRegDef(MI.getOperand(1).getReg());
        Optional<UsedNZCV> NZCVUsed = examineCFlagsUse(SrcMI, MI, *TRI);
        if (!NZCVUsed || NZCVUsed->C || NZCVUsed->V)
          return None;
        return OP;
      },
      [&TII = TII](MachineInstr &MI, OpcodePair Opcode, unsigned Imm0,
                   unsigned Imm1, Register SrcReg, Register NewTmpReg,
                   Register NewDstReg) {
        DebugLoc DL = MI.getDebugLoc();
        MachineBasicBlock *MBB = MI.getParent();
        BuildMI(*MBB, MI, DL, TII->get(Opcode.first), NewTmpReg)
            .addReg(SrcReg)
            .addImm(Imm0)
            .addImm(12);
        BuildMI(*MBB, MI, DL, TII->get(Opcode.second), NewDstReg)
            .addReg(NewTmpReg)
            .addImm(Imm1)
            .addImm(0);
      });
}

// Checks if the corresponding MOV immediate instruction is applicable for
// this peephole optimization.
bool AArch64MIPeepholeOpt::checkMovImmInstr(MachineInstr &MI,
                                            MachineInstr *&MovMI,
                                            MachineInstr *&SubregToRegMI) {
  // Check whether current MBB is in loop and the AND is loop invariant.
  MachineBasicBlock *MBB = MI.getParent();
  MachineLoop *L = MLI->getLoopFor(MBB);
  if (L && !L->isLoopInvariant(MI))
    return false;

  // Check whether current MI's operand is MOV with immediate.
  MovMI = MRI->getUniqueVRegDef(MI.getOperand(2).getReg());
  if (!MovMI)
    return false;

  // If it is SUBREG_TO_REG, check its operand.
  SubregToRegMI = nullptr;
  if (MovMI->getOpcode() == TargetOpcode::SUBREG_TO_REG) {
    SubregToRegMI = MovMI;
    MovMI = MRI->getUniqueVRegDef(MovMI->getOperand(2).getReg());
    if (!MovMI)
      return false;
  }

  if (MovMI->getOpcode() != AArch64::MOVi32imm &&
      MovMI->getOpcode() != AArch64::MOVi64imm)
    return false;

  // If the MOV has multiple uses, do not split the immediate because it causes
  // more instructions.
  if (!MRI->hasOneUse(MovMI->getOperand(0).getReg()))
    return false;
  if (SubregToRegMI && !MRI->hasOneUse(SubregToRegMI->getOperand(0).getReg()))
    return false;

  // It is OK to perform this peephole optimization.
  return true;
}

template <typename T>
bool AArch64MIPeepholeOpt::splitTwoPartImm(
    MachineInstr &MI,
    SplitAndOpcFunc<T> SplitAndOpc, BuildMIFunc BuildInstr) {
  unsigned RegSize = sizeof(T) * 8;
  assert((RegSize == 32 || RegSize == 64) &&
         "Invalid RegSize for legal immediate peephole optimization");

  // Perform several essential checks against current MI.
  MachineInstr *MovMI, *SubregToRegMI;
  if (!checkMovImmInstr(MI, MovMI, SubregToRegMI))
    return false;

  // Split the immediate to Imm0 and Imm1, and calculate the Opcode.
  T Imm = static_cast<T>(MovMI->getOperand(1).getImm()), Imm0, Imm1;
  // For the 32 bit form of instruction, the upper 32 bits of the destination
  // register are set to zero. If there is SUBREG_TO_REG, set the upper 32 bits
  // of Imm to zero. This is essential if the Immediate value was a negative
  // number since it was sign extended when we assign to the 64-bit Imm.
  if (SubregToRegMI)
    Imm &= 0xFFFFFFFF;
  OpcodePair Opcode;
  if (auto R = SplitAndOpc(Imm, RegSize, Imm0, Imm1))
    Opcode = R.getValue();
  else
    return false;

  // Create new MIs using the first and second opcodes. Opcodes might differ for
  // flag setting operations that should only set flags on second instruction.
  // NewTmpReg = Opcode.first SrcReg Imm0
  // NewDstReg = Opcode.second NewTmpReg Imm1

  // Determine register classes for destinations and register operands
  MachineFunction *MF = MI.getMF();
  const TargetRegisterClass *FirstInstrDstRC =
      TII->getRegClass(TII->get(Opcode.first), 0, TRI, *MF);
  const TargetRegisterClass *FirstInstrOperandRC =
      TII->getRegClass(TII->get(Opcode.first), 1, TRI, *MF);
  const TargetRegisterClass *SecondInstrDstRC =
      (Opcode.first == Opcode.second)
          ? FirstInstrDstRC
          : TII->getRegClass(TII->get(Opcode.second), 0, TRI, *MF);
  const TargetRegisterClass *SecondInstrOperandRC =
      (Opcode.first == Opcode.second)
          ? FirstInstrOperandRC
          : TII->getRegClass(TII->get(Opcode.second), 1, TRI, *MF);

  // Get old registers destinations and new register destinations
  Register DstReg = MI.getOperand(0).getReg();
  Register SrcReg = MI.getOperand(1).getReg();
  Register NewTmpReg = MRI->createVirtualRegister(FirstInstrDstRC);
  // In the situation that DstReg is not Virtual (likely WZR or XZR), we want to
  // reuse that same destination register.
  Register NewDstReg = DstReg.isVirtual()
                           ? MRI->createVirtualRegister(SecondInstrDstRC)
                           : DstReg;

  // Constrain registers based on their new uses
  MRI->constrainRegClass(SrcReg, FirstInstrOperandRC);
  MRI->constrainRegClass(NewTmpReg, SecondInstrOperandRC);
  if (DstReg != NewDstReg)
    MRI->constrainRegClass(NewDstReg, MRI->getRegClass(DstReg));

  // Call the delegating operation to build the instruction
  BuildInstr(MI, Opcode, Imm0, Imm1, SrcReg, NewTmpReg, NewDstReg);

  // replaceRegWith changes MI's definition register. Keep it for SSA form until
  // deleting MI. Only if we made a new destination register.
  if (DstReg != NewDstReg) {
    MRI->replaceRegWith(DstReg, NewDstReg);
    MI.getOperand(0).setReg(DstReg);
  }

  // Record the MIs need to be removed.
  MI.eraseFromParent();
  if (SubregToRegMI)
    SubregToRegMI->eraseFromParent();
  MovMI->eraseFromParent();

  return true;
}

bool AArch64MIPeepholeOpt::runOnMachineFunction(MachineFunction &MF) {
  if (skipFunction(MF.getFunction()))
    return false;

  TII = static_cast<const AArch64InstrInfo *>(MF.getSubtarget().getInstrInfo());
  TRI = static_cast<const AArch64RegisterInfo *>(
      MF.getSubtarget().getRegisterInfo());
  MLI = &getAnalysis<MachineLoopInfo>();
  MRI = &MF.getRegInfo();

  assert(MRI->isSSA() && "Expected to be run on SSA form!");

  bool Changed = false;

  for (MachineBasicBlock &MBB : MF) {
    for (MachineInstr &MI : make_early_inc_range(MBB)) {
      switch (MI.getOpcode()) {
      default:
        break;
      case AArch64::ANDWrr:
        Changed = visitAND<uint32_t>(AArch64::ANDWri, MI);
        break;
      case AArch64::ANDXrr:
        Changed = visitAND<uint64_t>(AArch64::ANDXri, MI);
        break;
      case AArch64::ORRWrs:
        Changed = visitORR(MI);
        break;
      case AArch64::ADDWrr:
        Changed = visitADDSUB<uint32_t>(AArch64::ADDWri, AArch64::SUBWri, MI);
        break;
      case AArch64::SUBWrr:
        Changed = visitADDSUB<uint32_t>(AArch64::SUBWri, AArch64::ADDWri, MI);
        break;
      case AArch64::ADDXrr:
        Changed = visitADDSUB<uint64_t>(AArch64::ADDXri, AArch64::SUBXri, MI);
        break;
      case AArch64::SUBXrr:
        Changed = visitADDSUB<uint64_t>(AArch64::SUBXri, AArch64::ADDXri, MI);
        break;
      case AArch64::ADDSWrr:
        Changed = visitADDSSUBS<uint32_t>({AArch64::ADDWri, AArch64::ADDSWri},
                                          {AArch64::SUBWri, AArch64::SUBSWri},
                                          MI);
        break;
      case AArch64::SUBSWrr:
        Changed = visitADDSSUBS<uint32_t>({AArch64::SUBWri, AArch64::SUBSWri},
                                          {AArch64::ADDWri, AArch64::ADDSWri},
                                          MI);
        break;
      case AArch64::ADDSXrr:
        Changed = visitADDSSUBS<uint64_t>({AArch64::ADDXri, AArch64::ADDSXri},
                                          {AArch64::SUBXri, AArch64::SUBSXri},
                                          MI);
        break;
      case AArch64::SUBSXrr:
        Changed = visitADDSSUBS<uint64_t>({AArch64::SUBXri, AArch64::SUBSXri},
                                          {AArch64::ADDXri, AArch64::ADDSXri},
                                          MI);
        break;
      }
    }
  }

  return Changed;
}

FunctionPass *llvm::createAArch64MIPeepholeOptPass() {
  return new AArch64MIPeepholeOpt();
}
