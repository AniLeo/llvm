//===----- BPFMISimplifyPatchable.cpp - MI Simplify Patchable Insts -------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This pass targets a subset of instructions like below
//    ld_imm64 r1, @global
//    ldd r2, r1, 0
//    add r3, struct_base_reg, r2
//
// Here @global should represent an AMA (abstruct member access).
// Such an access is subject to bpf load time patching. After this pass, the
// code becomes
//    ld_imm64 r1, @global
//    add r3, struct_base_reg, r1
//
// Eventually, at BTF output stage, a relocation record will be generated
// for ld_imm64 which should be replaced later by bpf loader:
//    r1 = <calculated field_info>
//    add r3, struct_base_reg, r1
//
//===----------------------------------------------------------------------===//

#include "BPF.h"
#include "BPFCORE.h"
#include "BPFInstrInfo.h"
#include "BPFTargetMachine.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/Support/Debug.h"

using namespace llvm;

#define DEBUG_TYPE "bpf-mi-simplify-patchable"

namespace {

struct BPFMISimplifyPatchable : public MachineFunctionPass {

  static char ID;
  const BPFInstrInfo *TII;
  MachineFunction *MF;

  BPFMISimplifyPatchable() : MachineFunctionPass(ID) {
    initializeBPFMISimplifyPatchablePass(*PassRegistry::getPassRegistry());
  }

private:
  // Initialize class variables.
  void initialize(MachineFunction &MFParm);

  bool removeLD(void);
  void processCandidate(MachineRegisterInfo *MRI, MachineBasicBlock &MBB,
                        MachineInstr &MI, Register &SrcReg, Register &DstReg,
                        const GlobalValue *GVal);
  void processDstReg(MachineRegisterInfo *MRI, Register &DstReg,
                     Register &SrcReg, const GlobalValue *GVal,
                     bool doSrcRegProp);
  void processInst(MachineRegisterInfo *MRI, MachineInstr *Inst,
                   MachineOperand *RelocOp, const GlobalValue *GVal);
  void checkADDrr(MachineRegisterInfo *MRI, MachineOperand *RelocOp,
                  const GlobalValue *GVal);
  void checkShift(MachineRegisterInfo *MRI, MachineBasicBlock &MBB,
                  MachineOperand *RelocOp, const GlobalValue *GVal,
                  unsigned Opcode);

public:
  // Main entry point for this pass.
  bool runOnMachineFunction(MachineFunction &MF) override {
    if (skipFunction(MF.getFunction()))
      return false;

    initialize(MF);
    return removeLD();
  }
};

// Initialize class variables.
void BPFMISimplifyPatchable::initialize(MachineFunction &MFParm) {
  MF = &MFParm;
  TII = MF->getSubtarget<BPFSubtarget>().getInstrInfo();
  LLVM_DEBUG(dbgs() << "*** BPF simplify patchable insts pass ***\n\n");
}

void BPFMISimplifyPatchable::checkADDrr(MachineRegisterInfo *MRI,
    MachineOperand *RelocOp, const GlobalValue *GVal) {
  const MachineInstr *Inst = RelocOp->getParent();
  const MachineOperand *Op1 = &Inst->getOperand(1);
  const MachineOperand *Op2 = &Inst->getOperand(2);
  const MachineOperand *BaseOp = (RelocOp == Op1) ? Op2 : Op1;

  // Go through all uses of %1 as in %1 = ADD_rr %2, %3
  const MachineOperand Op0 = Inst->getOperand(0);
  auto Begin = MRI->use_begin(Op0.getReg()), End = MRI->use_end();
  decltype(End) NextI;
  for (auto I = Begin; I != End; I = NextI) {
    NextI = std::next(I);
    // The candidate needs to have a unique definition.
    if (!MRI->getUniqueVRegDef(I->getReg()))
      continue;

    MachineInstr *DefInst = I->getParent();
    unsigned Opcode = DefInst->getOpcode();
    unsigned COREOp;
    if (Opcode == BPF::LDB || Opcode == BPF::LDH || Opcode == BPF::LDW ||
        Opcode == BPF::LDD || Opcode == BPF::STB || Opcode == BPF::STH ||
        Opcode == BPF::STW || Opcode == BPF::STD)
      COREOp = BPF::CORE_MEM;
    else if (Opcode == BPF::LDB32 || Opcode == BPF::LDH32 ||
             Opcode == BPF::LDW32 || Opcode == BPF::STB32 ||
             Opcode == BPF::STH32 || Opcode == BPF::STW32)
      COREOp = BPF::CORE_ALU32_MEM;
    else
      continue;

    // It must be a form of %1 = *(type *)(%2 + 0) or *(type *)(%2 + 0) = %1.
    const MachineOperand &ImmOp = DefInst->getOperand(2);
    if (!ImmOp.isImm() || ImmOp.getImm() != 0)
      continue;

    BuildMI(*DefInst->getParent(), *DefInst, DefInst->getDebugLoc(), TII->get(COREOp))
        .add(DefInst->getOperand(0)).addImm(Opcode).add(*BaseOp)
        .addGlobalAddress(GVal);
    DefInst->eraseFromParent();
  }
}

void BPFMISimplifyPatchable::checkShift(MachineRegisterInfo *MRI,
    MachineBasicBlock &MBB, MachineOperand *RelocOp, const GlobalValue *GVal,
    unsigned Opcode) {
  // Relocation operand should be the operand #2.
  MachineInstr *Inst = RelocOp->getParent();
  if (RelocOp != &Inst->getOperand(2))
    return;

  BuildMI(MBB, *Inst, Inst->getDebugLoc(), TII->get(BPF::CORE_SHIFT))
      .add(Inst->getOperand(0)).addImm(Opcode)
      .add(Inst->getOperand(1)).addGlobalAddress(GVal);
  Inst->eraseFromParent();
}

void BPFMISimplifyPatchable::processCandidate(MachineRegisterInfo *MRI,
    MachineBasicBlock &MBB, MachineInstr &MI, Register &SrcReg,
    Register &DstReg, const GlobalValue *GVal) {
  if (MRI->getRegClass(DstReg) == &BPF::GPR32RegClass) {
    // We can optimize such a pattern:
    //  %1:gpr = LD_imm64 @"llvm.s:0:4$0:2"
    //  %2:gpr32 = LDW32 %1:gpr, 0
    //  %3:gpr = SUBREG_TO_REG 0, %2:gpr32, %subreg.sub_32
    //  %4:gpr = ADD_rr %0:gpr, %3:gpr
    //  or similar patterns below for non-alu32 case.
    auto Begin = MRI->use_begin(DstReg), End = MRI->use_end();
    decltype(End) NextI;
    for (auto I = Begin; I != End; I = NextI) {
      NextI = std::next(I);
      if (!MRI->getUniqueVRegDef(I->getReg()))
        continue;

      unsigned Opcode = I->getParent()->getOpcode();
      if (Opcode == BPF::SUBREG_TO_REG) {
        Register TmpReg = I->getParent()->getOperand(0).getReg();
        processDstReg(MRI, TmpReg, DstReg, GVal, false);
      }
    }

    BuildMI(MBB, MI, MI.getDebugLoc(), TII->get(BPF::COPY), DstReg)
        .addReg(SrcReg, 0, BPF::sub_32);
    return;
  }

  // All uses of DstReg replaced by SrcReg
  processDstReg(MRI, DstReg, SrcReg, GVal, true);
}

void BPFMISimplifyPatchable::processDstReg(MachineRegisterInfo *MRI,
    Register &DstReg, Register &SrcReg, const GlobalValue *GVal,
    bool doSrcRegProp) {
  auto Begin = MRI->use_begin(DstReg), End = MRI->use_end();
  decltype(End) NextI;
  for (auto I = Begin; I != End; I = NextI) {
    NextI = std::next(I);
    if (doSrcRegProp)
      I->setReg(SrcReg);

    // The candidate needs to have a unique definition.
    if (MRI->getUniqueVRegDef(I->getReg()))
      processInst(MRI, I->getParent(), &*I, GVal);
  }
}

// Check to see whether we could do some optimization
// to attach relocation to downstream dependent instructions.
// Two kinds of patterns are recognized below:
// Pattern 1:
//   %1 = LD_imm64 @"llvm.b:0:4$0:1"  <== patch_imm = 4
//   %2 = LDD %1, 0  <== this insn will be removed
//   %3 = ADD_rr %0, %2
//   %4 = LDW[32] %3, 0 OR STW[32] %4, %3, 0
//   The `%4 = ...` will be transformed to
//      CORE_[ALU32_]MEM(%4, mem_opcode, %0, @"llvm.b:0:4$0:1")
//   and later on, BTF emit phase will translate to
//      %4 = LDW[32] %0, 4 STW[32] %4, %0, 4
//   and attach a relocation to it.
// Pattern 2:
//    %15 = LD_imm64 @"llvm.t:5:63$0:2" <== relocation type 5
//    %16 = LDD %15, 0   <== this insn will be removed
//    %17 = SRA_rr %14, %16
//    The `%17 = ...` will be transformed to
//       %17 = CORE_SHIFT(SRA_ri, %14, @"llvm.t:5:63$0:2")
//    and later on, BTF emit phase will translate to
//       %r4 = SRA_ri %r4, 63
void BPFMISimplifyPatchable::processInst(MachineRegisterInfo *MRI,
    MachineInstr *Inst, MachineOperand *RelocOp, const GlobalValue *GVal) {
  unsigned Opcode = Inst->getOpcode();
  if (Opcode == BPF::ADD_rr)
    checkADDrr(MRI, RelocOp, GVal);
  else if (Opcode == BPF::SLL_rr)
    checkShift(MRI, *Inst->getParent(), RelocOp, GVal, BPF::SLL_ri);
  else if (Opcode == BPF::SRA_rr)
    checkShift(MRI, *Inst->getParent(), RelocOp, GVal, BPF::SRA_ri);
  else if (Opcode == BPF::SRL_rr)
    checkShift(MRI, *Inst->getParent(), RelocOp, GVal, BPF::SRL_ri);
}

/// Remove unneeded Load instructions.
bool BPFMISimplifyPatchable::removeLD() {
  MachineRegisterInfo *MRI = &MF->getRegInfo();
  MachineInstr *ToErase = nullptr;
  bool Changed = false;

  for (MachineBasicBlock &MBB : *MF) {
    for (MachineInstr &MI : MBB) {
      if (ToErase) {
        ToErase->eraseFromParent();
        ToErase = nullptr;
      }

      // Ensure the register format is LOAD <reg>, <reg>, 0
      if (MI.getOpcode() != BPF::LDD && MI.getOpcode() != BPF::LDW &&
          MI.getOpcode() != BPF::LDH && MI.getOpcode() != BPF::LDB &&
          MI.getOpcode() != BPF::LDW32 && MI.getOpcode() != BPF::LDH32 &&
          MI.getOpcode() != BPF::LDB32)
        continue;

      if (!MI.getOperand(0).isReg() || !MI.getOperand(1).isReg())
        continue;

      if (!MI.getOperand(2).isImm() || MI.getOperand(2).getImm())
        continue;

      Register DstReg = MI.getOperand(0).getReg();
      Register SrcReg = MI.getOperand(1).getReg();

      MachineInstr *DefInst = MRI->getUniqueVRegDef(SrcReg);
      if (!DefInst)
        continue;

      bool IsCandidate = false;
      const GlobalValue *GVal = nullptr;
      if (DefInst->getOpcode() == BPF::LD_imm64) {
        const MachineOperand &MO = DefInst->getOperand(1);
        if (MO.isGlobal()) {
          GVal = MO.getGlobal();
          auto *GVar = dyn_cast<GlobalVariable>(GVal);
          if (GVar) {
            // Global variables representing structure offset or
            // patchable extern globals.
            if (GVar->hasAttribute(BPFCoreSharedInfo::AmaAttr)) {
              assert(MI.getOperand(2).getImm() == 0);
              IsCandidate = true;
            }
          }
        }
      }

      if (!IsCandidate)
        continue;

      processCandidate(MRI, MBB, MI, SrcReg, DstReg, GVal);

      ToErase = &MI;
      Changed = true;
    }
  }

  return Changed;
}

} // namespace

INITIALIZE_PASS(BPFMISimplifyPatchable, DEBUG_TYPE,
                "BPF PreEmit SimplifyPatchable", false, false)

char BPFMISimplifyPatchable::ID = 0;
FunctionPass *llvm::createBPFMISimplifyPatchablePass() {
  return new BPFMISimplifyPatchable();
}
