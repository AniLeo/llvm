//===- AArch64InstructionSelector.cpp ----------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the InstructionSelector class for
/// AArch64.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "AArch64InstructionSelector.h"
#include "AArch64InstrInfo.h"
#include "AArch64RegisterBankInfo.h"
#include "AArch64RegisterInfo.h"
#include "AArch64Subtarget.h"
#include "AArch64TargetMachine.h"
#include "MCTargetDesc/AArch64AddressingModes.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"

#define DEBUG_TYPE "aarch64-isel"

using namespace llvm;

#ifndef LLVM_BUILD_GLOBAL_ISEL
#error "You shouldn't build this"
#endif

#include "AArch64GenGlobalISel.inc"

AArch64InstructionSelector::AArch64InstructionSelector(
    const AArch64TargetMachine &TM, const AArch64Subtarget &STI,
    const AArch64RegisterBankInfo &RBI)
  : InstructionSelector(), TM(TM), STI(STI), TII(*STI.getInstrInfo()),
      TRI(*STI.getRegisterInfo()), RBI(RBI) {}

// FIXME: This should be target-independent, inferred from the types declared
// for each class in the bank.
static const TargetRegisterClass *
getRegClassForTypeOnBank(LLT Ty, const RegisterBank &RB,
                         const RegisterBankInfo &RBI) {
  if (RB.getID() == AArch64::GPRRegBankID) {
    if (Ty.getSizeInBits() <= 32)
      return &AArch64::GPR32RegClass;
    if (Ty.getSizeInBits() == 64)
      return &AArch64::GPR64RegClass;
    return nullptr;
  }

  if (RB.getID() == AArch64::FPRRegBankID) {
    if (Ty.getSizeInBits() == 32)
      return &AArch64::FPR32RegClass;
    if (Ty.getSizeInBits() == 64)
      return &AArch64::FPR64RegClass;
    if (Ty.getSizeInBits() == 128)
      return &AArch64::FPR128RegClass;
    return nullptr;
  }

  return nullptr;
}

/// Check whether \p I is a currently unsupported binary operation:
/// - it has an unsized type
/// - an operand is not a vreg
/// - all operands are not in the same bank
/// These are checks that should someday live in the verifier, but right now,
/// these are mostly limitations of the aarch64 selector.
static bool unsupportedBinOp(const MachineInstr &I,
                             const AArch64RegisterBankInfo &RBI,
                             const MachineRegisterInfo &MRI,
                             const AArch64RegisterInfo &TRI) {
  LLT Ty = MRI.getType(I.getOperand(0).getReg());
  if (!Ty.isValid()) {
    DEBUG(dbgs() << "Generic binop register should be typed\n");
    return true;
  }

  const RegisterBank *PrevOpBank = nullptr;
  for (auto &MO : I.operands()) {
    // FIXME: Support non-register operands.
    if (!MO.isReg()) {
      DEBUG(dbgs() << "Generic inst non-reg operands are unsupported\n");
      return true;
    }

    // FIXME: Can generic operations have physical registers operands? If
    // so, this will need to be taught about that, and we'll need to get the
    // bank out of the minimal class for the register.
    // Either way, this needs to be documented (and possibly verified).
    if (!TargetRegisterInfo::isVirtualRegister(MO.getReg())) {
      DEBUG(dbgs() << "Generic inst has physical register operand\n");
      return true;
    }

    const RegisterBank *OpBank = RBI.getRegBank(MO.getReg(), MRI, TRI);
    if (!OpBank) {
      DEBUG(dbgs() << "Generic register has no bank or class\n");
      return true;
    }

    if (PrevOpBank && OpBank != PrevOpBank) {
      DEBUG(dbgs() << "Generic inst operands have different banks\n");
      return true;
    }
    PrevOpBank = OpBank;
  }
  return false;
}

/// Select the AArch64 opcode for the basic binary operation \p GenericOpc
/// (such as G_OR or G_SDIV), appropriate for the register bank \p RegBankID
/// and of size \p OpSize.
/// \returns \p GenericOpc if the combination is unsupported.
static unsigned selectBinaryOp(unsigned GenericOpc, unsigned RegBankID,
                               unsigned OpSize) {
  switch (RegBankID) {
  case AArch64::GPRRegBankID:
    if (OpSize <= 32) {
      assert((OpSize == 32 || (GenericOpc != TargetOpcode::G_SDIV &&
                               GenericOpc != TargetOpcode::G_UDIV &&
                               GenericOpc != TargetOpcode::G_LSHR &&
                               GenericOpc != TargetOpcode::G_ASHR)) &&
             "operation should have been legalized before now");

      switch (GenericOpc) {
      case TargetOpcode::G_OR:
        return AArch64::ORRWrr;
      case TargetOpcode::G_XOR:
        return AArch64::EORWrr;
      case TargetOpcode::G_AND:
        return AArch64::ANDWrr;
      case TargetOpcode::G_SUB:
        return AArch64::SUBWrr;
      case TargetOpcode::G_SHL:
        return AArch64::LSLVWr;
      case TargetOpcode::G_LSHR:
        return AArch64::LSRVWr;
      case TargetOpcode::G_ASHR:
        return AArch64::ASRVWr;
      case TargetOpcode::G_SDIV:
        return AArch64::SDIVWr;
      case TargetOpcode::G_UDIV:
        return AArch64::UDIVWr;
      default:
        return GenericOpc;
      }
    } else if (OpSize == 64) {
      switch (GenericOpc) {
      case TargetOpcode::G_OR:
        return AArch64::ORRXrr;
      case TargetOpcode::G_XOR:
        return AArch64::EORXrr;
      case TargetOpcode::G_AND:
        return AArch64::ANDXrr;
      case TargetOpcode::G_GEP:
        return AArch64::ADDXrr;
      case TargetOpcode::G_SUB:
        return AArch64::SUBXrr;
      case TargetOpcode::G_SHL:
        return AArch64::LSLVXr;
      case TargetOpcode::G_LSHR:
        return AArch64::LSRVXr;
      case TargetOpcode::G_ASHR:
        return AArch64::ASRVXr;
      case TargetOpcode::G_SDIV:
        return AArch64::SDIVXr;
      case TargetOpcode::G_UDIV:
        return AArch64::UDIVXr;
      default:
        return GenericOpc;
      }
    }
  case AArch64::FPRRegBankID:
    switch (OpSize) {
    case 32:
      switch (GenericOpc) {
      case TargetOpcode::G_FADD:
        return AArch64::FADDSrr;
      case TargetOpcode::G_FSUB:
        return AArch64::FSUBSrr;
      case TargetOpcode::G_FMUL:
        return AArch64::FMULSrr;
      case TargetOpcode::G_FDIV:
        return AArch64::FDIVSrr;
      default:
        return GenericOpc;
      }
    case 64:
      switch (GenericOpc) {
      case TargetOpcode::G_FADD:
        return AArch64::FADDDrr;
      case TargetOpcode::G_FSUB:
        return AArch64::FSUBDrr;
      case TargetOpcode::G_FMUL:
        return AArch64::FMULDrr;
      case TargetOpcode::G_FDIV:
        return AArch64::FDIVDrr;
      case TargetOpcode::G_OR:
        return AArch64::ORRv8i8;
      default:
        return GenericOpc;
      }
    }
  };
  return GenericOpc;
}

/// Select the AArch64 opcode for the G_LOAD or G_STORE operation \p GenericOpc,
/// appropriate for the (value) register bank \p RegBankID and of memory access
/// size \p OpSize.  This returns the variant with the base+unsigned-immediate
/// addressing mode (e.g., LDRXui).
/// \returns \p GenericOpc if the combination is unsupported.
static unsigned selectLoadStoreUIOp(unsigned GenericOpc, unsigned RegBankID,
                                    unsigned OpSize) {
  const bool isStore = GenericOpc == TargetOpcode::G_STORE;
  switch (RegBankID) {
  case AArch64::GPRRegBankID:
    switch (OpSize) {
    case 8:
      return isStore ? AArch64::STRBBui : AArch64::LDRBBui;
    case 16:
      return isStore ? AArch64::STRHHui : AArch64::LDRHHui;
    case 32:
      return isStore ? AArch64::STRWui : AArch64::LDRWui;
    case 64:
      return isStore ? AArch64::STRXui : AArch64::LDRXui;
    }
  case AArch64::FPRRegBankID:
    switch (OpSize) {
    case 8:
      return isStore ? AArch64::STRBui : AArch64::LDRBui;
    case 16:
      return isStore ? AArch64::STRHui : AArch64::LDRHui;
    case 32:
      return isStore ? AArch64::STRSui : AArch64::LDRSui;
    case 64:
      return isStore ? AArch64::STRDui : AArch64::LDRDui;
    }
  };
  return GenericOpc;
}

static bool selectCopy(MachineInstr &I, const TargetInstrInfo &TII,
                       MachineRegisterInfo &MRI, const TargetRegisterInfo &TRI,
                       const RegisterBankInfo &RBI) {

  unsigned DstReg = I.getOperand(0).getReg();
  if (TargetRegisterInfo::isPhysicalRegister(DstReg)) {
    assert(I.isCopy() && "Generic operators do not allow physical registers");
    return true;
  }

  const RegisterBank &RegBank = *RBI.getRegBank(DstReg, MRI, TRI);
  const unsigned DstSize = MRI.getType(DstReg).getSizeInBits();
  unsigned SrcReg = I.getOperand(1).getReg();
  const unsigned SrcSize = RBI.getSizeInBits(SrcReg, MRI, TRI);
  (void)SrcSize;
  assert((!TargetRegisterInfo::isPhysicalRegister(SrcReg) || I.isCopy()) &&
         "No phys reg on generic operators");
  assert(
      (DstSize == SrcSize ||
       // Copies are a mean to setup initial types, the number of
       // bits may not exactly match.
       (TargetRegisterInfo::isPhysicalRegister(SrcReg) &&
        DstSize <= RBI.getSizeInBits(SrcReg, MRI, TRI)) ||
       // Copies are a mean to copy bits around, as long as we are
       // on the same register class, that's fine. Otherwise, that
       // means we need some SUBREG_TO_REG or AND & co.
       (((DstSize + 31) / 32 == (SrcSize + 31) / 32) && DstSize > SrcSize)) &&
      "Copy with different width?!");
  assert((DstSize <= 64 || RegBank.getID() == AArch64::FPRRegBankID) &&
         "GPRs cannot get more than 64-bit width values");
  const TargetRegisterClass *RC = nullptr;

  if (RegBank.getID() == AArch64::FPRRegBankID) {
    if (DstSize <= 32)
      RC = &AArch64::FPR32RegClass;
    else if (DstSize <= 64)
      RC = &AArch64::FPR64RegClass;
    else if (DstSize <= 128)
      RC = &AArch64::FPR128RegClass;
    else {
      DEBUG(dbgs() << "Unexpected bitcast size " << DstSize << '\n');
      return false;
    }
  } else {
    assert(RegBank.getID() == AArch64::GPRRegBankID &&
           "Bitcast for the flags?");
    RC =
        DstSize <= 32 ? &AArch64::GPR32allRegClass : &AArch64::GPR64allRegClass;
  }

  // No need to constrain SrcReg. It will get constrained when
  // we hit another of its use or its defs.
  // Copies do not have constraints.
  if (!RBI.constrainGenericRegister(DstReg, *RC, MRI)) {
    DEBUG(dbgs() << "Failed to constrain " << TII.getName(I.getOpcode())
                 << " operand\n");
    return false;
  }
  I.setDesc(TII.get(AArch64::COPY));
  return true;
}

static unsigned selectFPConvOpc(unsigned GenericOpc, LLT DstTy, LLT SrcTy) {
  if (!DstTy.isScalar() || !SrcTy.isScalar())
    return GenericOpc;

  const unsigned DstSize = DstTy.getSizeInBits();
  const unsigned SrcSize = SrcTy.getSizeInBits();

  switch (DstSize) {
  case 32:
    switch (SrcSize) {
    case 32:
      switch (GenericOpc) {
      case TargetOpcode::G_SITOFP:
        return AArch64::SCVTFUWSri;
      case TargetOpcode::G_UITOFP:
        return AArch64::UCVTFUWSri;
      case TargetOpcode::G_FPTOSI:
        return AArch64::FCVTZSUWSr;
      case TargetOpcode::G_FPTOUI:
        return AArch64::FCVTZUUWSr;
      default:
        return GenericOpc;
      }
    case 64:
      switch (GenericOpc) {
      case TargetOpcode::G_SITOFP:
        return AArch64::SCVTFUXSri;
      case TargetOpcode::G_UITOFP:
        return AArch64::UCVTFUXSri;
      case TargetOpcode::G_FPTOSI:
        return AArch64::FCVTZSUWDr;
      case TargetOpcode::G_FPTOUI:
        return AArch64::FCVTZUUWDr;
      default:
        return GenericOpc;
      }
    default:
      return GenericOpc;
    }
  case 64:
    switch (SrcSize) {
    case 32:
      switch (GenericOpc) {
      case TargetOpcode::G_SITOFP:
        return AArch64::SCVTFUWDri;
      case TargetOpcode::G_UITOFP:
        return AArch64::UCVTFUWDri;
      case TargetOpcode::G_FPTOSI:
        return AArch64::FCVTZSUXSr;
      case TargetOpcode::G_FPTOUI:
        return AArch64::FCVTZUUXSr;
      default:
        return GenericOpc;
      }
    case 64:
      switch (GenericOpc) {
      case TargetOpcode::G_SITOFP:
        return AArch64::SCVTFUXDri;
      case TargetOpcode::G_UITOFP:
        return AArch64::UCVTFUXDri;
      case TargetOpcode::G_FPTOSI:
        return AArch64::FCVTZSUXDr;
      case TargetOpcode::G_FPTOUI:
        return AArch64::FCVTZUUXDr;
      default:
        return GenericOpc;
      }
    default:
      return GenericOpc;
    }
  default:
    return GenericOpc;
  };
  return GenericOpc;
}

static AArch64CC::CondCode changeICMPPredToAArch64CC(CmpInst::Predicate P) {
  switch (P) {
  default:
    llvm_unreachable("Unknown condition code!");
  case CmpInst::ICMP_NE:
    return AArch64CC::NE;
  case CmpInst::ICMP_EQ:
    return AArch64CC::EQ;
  case CmpInst::ICMP_SGT:
    return AArch64CC::GT;
  case CmpInst::ICMP_SGE:
    return AArch64CC::GE;
  case CmpInst::ICMP_SLT:
    return AArch64CC::LT;
  case CmpInst::ICMP_SLE:
    return AArch64CC::LE;
  case CmpInst::ICMP_UGT:
    return AArch64CC::HI;
  case CmpInst::ICMP_UGE:
    return AArch64CC::HS;
  case CmpInst::ICMP_ULT:
    return AArch64CC::LO;
  case CmpInst::ICMP_ULE:
    return AArch64CC::LS;
  }
}

static void changeFCMPPredToAArch64CC(CmpInst::Predicate P,
                                      AArch64CC::CondCode &CondCode,
                                      AArch64CC::CondCode &CondCode2) {
  CondCode2 = AArch64CC::AL;
  switch (P) {
  default:
    llvm_unreachable("Unknown FP condition!");
  case CmpInst::FCMP_OEQ:
    CondCode = AArch64CC::EQ;
    break;
  case CmpInst::FCMP_OGT:
    CondCode = AArch64CC::GT;
    break;
  case CmpInst::FCMP_OGE:
    CondCode = AArch64CC::GE;
    break;
  case CmpInst::FCMP_OLT:
    CondCode = AArch64CC::MI;
    break;
  case CmpInst::FCMP_OLE:
    CondCode = AArch64CC::LS;
    break;
  case CmpInst::FCMP_ONE:
    CondCode = AArch64CC::MI;
    CondCode2 = AArch64CC::GT;
    break;
  case CmpInst::FCMP_ORD:
    CondCode = AArch64CC::VC;
    break;
  case CmpInst::FCMP_UNO:
    CondCode = AArch64CC::VS;
    break;
  case CmpInst::FCMP_UEQ:
    CondCode = AArch64CC::EQ;
    CondCode2 = AArch64CC::VS;
    break;
  case CmpInst::FCMP_UGT:
    CondCode = AArch64CC::HI;
    break;
  case CmpInst::FCMP_UGE:
    CondCode = AArch64CC::PL;
    break;
  case CmpInst::FCMP_ULT:
    CondCode = AArch64CC::LT;
    break;
  case CmpInst::FCMP_ULE:
    CondCode = AArch64CC::LE;
    break;
  case CmpInst::FCMP_UNE:
    CondCode = AArch64CC::NE;
    break;
  }
}

bool AArch64InstructionSelector::select(MachineInstr &I) const {
  assert(I.getParent() && "Instruction should be in a basic block!");
  assert(I.getParent()->getParent() && "Instruction should be in a function!");

  MachineBasicBlock &MBB = *I.getParent();
  MachineFunction &MF = *MBB.getParent();
  MachineRegisterInfo &MRI = MF.getRegInfo();

  unsigned Opcode = I.getOpcode();
  if (!isPreISelGenericOpcode(I.getOpcode())) {
    // Certain non-generic instructions also need some special handling.

    if (Opcode ==  TargetOpcode::LOAD_STACK_GUARD)
      return constrainSelectedInstRegOperands(I, TII, TRI, RBI);

    if (Opcode == TargetOpcode::PHI) {
      const unsigned DefReg = I.getOperand(0).getReg();
      const LLT DefTy = MRI.getType(DefReg);

      const TargetRegisterClass *DefRC = nullptr;
      if (TargetRegisterInfo::isPhysicalRegister(DefReg)) {
        DefRC = TRI.getRegClass(DefReg);
      } else {
        const RegClassOrRegBank &RegClassOrBank =
            MRI.getRegClassOrRegBank(DefReg);

        DefRC = RegClassOrBank.dyn_cast<const TargetRegisterClass *>();
        if (!DefRC) {
          if (!DefTy.isValid()) {
            DEBUG(dbgs() << "PHI operand has no type, not a gvreg?\n");
            return false;
          }
          const RegisterBank &RB = *RegClassOrBank.get<const RegisterBank *>();
          DefRC = getRegClassForTypeOnBank(DefTy, RB, RBI);
          if (!DefRC) {
            DEBUG(dbgs() << "PHI operand has unexpected size/bank\n");
            return false;
          }
        }
      }

      return RBI.constrainGenericRegister(DefReg, *DefRC, MRI);
    }

    if (I.isCopy())
      return selectCopy(I, TII, MRI, TRI, RBI);

    return true;
  }


  if (I.getNumOperands() != I.getNumExplicitOperands()) {
    DEBUG(dbgs() << "Generic instruction has unexpected implicit operands\n");
    return false;
  }

  if (selectImpl(I))
    return true;

  LLT Ty =
      I.getOperand(0).isReg() ? MRI.getType(I.getOperand(0).getReg()) : LLT{};

  switch (Opcode) {
  case TargetOpcode::G_BRCOND: {
    if (Ty.getSizeInBits() > 32) {
      // We shouldn't need this on AArch64, but it would be implemented as an
      // EXTRACT_SUBREG followed by a TBNZW because TBNZX has no encoding if the
      // bit being tested is < 32.
      DEBUG(dbgs() << "G_BRCOND has type: " << Ty
                   << ", expected at most 32-bits");
      return false;
    }

    const unsigned CondReg = I.getOperand(0).getReg();
    MachineBasicBlock *DestMBB = I.getOperand(1).getMBB();

    auto MIB = BuildMI(MBB, I, I.getDebugLoc(), TII.get(AArch64::TBNZW))
                   .addUse(CondReg)
                   .addImm(/*bit offset=*/0)
                   .addMBB(DestMBB);

    I.eraseFromParent();
    return constrainSelectedInstRegOperands(*MIB.getInstr(), TII, TRI, RBI);
  }

  case TargetOpcode::G_FCONSTANT:
  case TargetOpcode::G_CONSTANT: {
    const bool isFP = Opcode == TargetOpcode::G_FCONSTANT;

    const LLT s32 = LLT::scalar(32);
    const LLT s64 = LLT::scalar(64);
    const LLT p0 = LLT::pointer(0, 64);

    const unsigned DefReg = I.getOperand(0).getReg();
    const LLT DefTy = MRI.getType(DefReg);
    const unsigned DefSize = DefTy.getSizeInBits();
    const RegisterBank &RB = *RBI.getRegBank(DefReg, MRI, TRI);

    // FIXME: Redundant check, but even less readable when factored out.
    if (isFP) {
      if (Ty != s32 && Ty != s64) {
        DEBUG(dbgs() << "Unable to materialize FP " << Ty
                     << " constant, expected: " << s32 << " or " << s64
                     << '\n');
        return false;
      }

      if (RB.getID() != AArch64::FPRRegBankID) {
        DEBUG(dbgs() << "Unable to materialize FP " << Ty
                     << " constant on bank: " << RB << ", expected: FPR\n");
        return false;
      }
    } else {
      if (Ty != s32 && Ty != s64 && Ty != p0) {
        DEBUG(dbgs() << "Unable to materialize integer " << Ty
                     << " constant, expected: " << s32 << ", " << s64 << ", or "
                     << p0 << '\n');
        return false;
      }

      if (RB.getID() != AArch64::GPRRegBankID) {
        DEBUG(dbgs() << "Unable to materialize integer " << Ty
                     << " constant on bank: " << RB << ", expected: GPR\n");
        return false;
      }
    }

    const unsigned MovOpc =
        DefSize == 32 ? AArch64::MOVi32imm : AArch64::MOVi64imm;

    I.setDesc(TII.get(MovOpc));

    if (isFP) {
      const TargetRegisterClass &GPRRC =
          DefSize == 32 ? AArch64::GPR32RegClass : AArch64::GPR64RegClass;
      const TargetRegisterClass &FPRRC =
          DefSize == 32 ? AArch64::FPR32RegClass : AArch64::FPR64RegClass;

      const unsigned DefGPRReg = MRI.createVirtualRegister(&GPRRC);
      MachineOperand &RegOp = I.getOperand(0);
      RegOp.setReg(DefGPRReg);

      BuildMI(MBB, std::next(I.getIterator()), I.getDebugLoc(),
              TII.get(AArch64::COPY))
          .addDef(DefReg)
          .addUse(DefGPRReg);

      if (!RBI.constrainGenericRegister(DefReg, FPRRC, MRI)) {
        DEBUG(dbgs() << "Failed to constrain G_FCONSTANT def operand\n");
        return false;
      }

      MachineOperand &ImmOp = I.getOperand(1);
      // FIXME: Is going through int64_t always correct?
      ImmOp.ChangeToImmediate(
          ImmOp.getFPImm()->getValueAPF().bitcastToAPInt().getZExtValue());
    } else {
      uint64_t Val = I.getOperand(1).getCImm()->getZExtValue();
      I.getOperand(1).ChangeToImmediate(Val);
    }

    constrainSelectedInstRegOperands(I, TII, TRI, RBI);
    return true;
  }

  case TargetOpcode::G_FRAME_INDEX: {
    // allocas and G_FRAME_INDEX are only supported in addrspace(0).
    if (Ty != LLT::pointer(0, 64)) {
      DEBUG(dbgs() << "G_FRAME_INDEX pointer has type: " << Ty
            << ", expected: " << LLT::pointer(0, 64) << '\n');
      return false;
    }

    I.setDesc(TII.get(AArch64::ADDXri));

    // MOs for a #0 shifted immediate.
    I.addOperand(MachineOperand::CreateImm(0));
    I.addOperand(MachineOperand::CreateImm(0));

    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }

  case TargetOpcode::G_GLOBAL_VALUE: {
    auto GV = I.getOperand(1).getGlobal();
    if (GV->isThreadLocal()) {
      // FIXME: we don't support TLS yet.
      return false;
    }
    unsigned char OpFlags = STI.ClassifyGlobalReference(GV, TM);
    if (OpFlags & AArch64II::MO_GOT) {
      I.setDesc(TII.get(AArch64::LOADgot));
      I.getOperand(1).setTargetFlags(OpFlags);
    } else {
      I.setDesc(TII.get(AArch64::MOVaddr));
      I.getOperand(1).setTargetFlags(OpFlags | AArch64II::MO_PAGE);
      MachineInstrBuilder MIB(MF, I);
      MIB.addGlobalAddress(GV, I.getOperand(1).getOffset(),
                           OpFlags | AArch64II::MO_PAGEOFF | AArch64II::MO_NC);
    }
    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }

  case TargetOpcode::G_LOAD:
  case TargetOpcode::G_STORE: {
    LLT MemTy = Ty;
    LLT PtrTy = MRI.getType(I.getOperand(1).getReg());

    if (PtrTy != LLT::pointer(0, 64)) {
      DEBUG(dbgs() << "Load/Store pointer has type: " << PtrTy
                   << ", expected: " << LLT::pointer(0, 64) << '\n');
      return false;
    }

#ifndef NDEBUG
    // Sanity-check the pointer register.
    const unsigned PtrReg = I.getOperand(1).getReg();
    const RegisterBank &PtrRB = *RBI.getRegBank(PtrReg, MRI, TRI);
    assert(PtrRB.getID() == AArch64::GPRRegBankID &&
           "Load/Store pointer operand isn't a GPR");
    assert(MRI.getType(PtrReg).isPointer() &&
           "Load/Store pointer operand isn't a pointer");
#endif

    const unsigned ValReg = I.getOperand(0).getReg();
    const RegisterBank &RB = *RBI.getRegBank(ValReg, MRI, TRI);

    const unsigned NewOpc =
        selectLoadStoreUIOp(I.getOpcode(), RB.getID(), MemTy.getSizeInBits());
    if (NewOpc == I.getOpcode())
      return false;

    I.setDesc(TII.get(NewOpc));

    I.addOperand(MachineOperand::CreateImm(0));
    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }

  case TargetOpcode::G_MUL: {
    // Reject the various things we don't support yet.
    if (unsupportedBinOp(I, RBI, MRI, TRI))
      return false;

    const unsigned DefReg = I.getOperand(0).getReg();
    const RegisterBank &RB = *RBI.getRegBank(DefReg, MRI, TRI);

    if (RB.getID() != AArch64::GPRRegBankID) {
      DEBUG(dbgs() << "G_MUL on bank: " << RB << ", expected: GPR\n");
      return false;
    }

    unsigned ZeroReg;
    unsigned NewOpc;
    if (Ty.isScalar() && Ty.getSizeInBits() <= 32) {
      NewOpc = AArch64::MADDWrrr;
      ZeroReg = AArch64::WZR;
    } else if (Ty == LLT::scalar(64)) {
      NewOpc = AArch64::MADDXrrr;
      ZeroReg = AArch64::XZR;
    } else {
      DEBUG(dbgs() << "G_MUL has type: " << Ty << ", expected: "
                   << LLT::scalar(32) << " or " << LLT::scalar(64) << '\n');
      return false;
    }

    I.setDesc(TII.get(NewOpc));

    I.addOperand(MachineOperand::CreateReg(ZeroReg, /*isDef=*/false));

    // Now that we selected an opcode, we need to constrain the register
    // operands to use appropriate classes.
    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }

  case TargetOpcode::G_FADD:
  case TargetOpcode::G_FSUB:
  case TargetOpcode::G_FMUL:
  case TargetOpcode::G_FDIV:

  case TargetOpcode::G_OR:
  case TargetOpcode::G_XOR:
  case TargetOpcode::G_AND:
  case TargetOpcode::G_SHL:
  case TargetOpcode::G_LSHR:
  case TargetOpcode::G_ASHR:
  case TargetOpcode::G_SDIV:
  case TargetOpcode::G_UDIV:
  case TargetOpcode::G_SUB:
  case TargetOpcode::G_GEP: {
    // Reject the various things we don't support yet.
    if (unsupportedBinOp(I, RBI, MRI, TRI))
      return false;

    const unsigned OpSize = Ty.getSizeInBits();

    const unsigned DefReg = I.getOperand(0).getReg();
    const RegisterBank &RB = *RBI.getRegBank(DefReg, MRI, TRI);

    const unsigned NewOpc = selectBinaryOp(I.getOpcode(), RB.getID(), OpSize);
    if (NewOpc == I.getOpcode())
      return false;

    I.setDesc(TII.get(NewOpc));
    // FIXME: Should the type be always reset in setDesc?

    // Now that we selected an opcode, we need to constrain the register
    // operands to use appropriate classes.
    return constrainSelectedInstRegOperands(I, TII, TRI, RBI);
  }

  case TargetOpcode::G_PTRTOINT:
  case TargetOpcode::G_TRUNC: {
    const LLT DstTy = MRI.getType(I.getOperand(0).getReg());
    const LLT SrcTy = MRI.getType(I.getOperand(1).getReg());

    const unsigned DstReg = I.getOperand(0).getReg();
    const unsigned SrcReg = I.getOperand(1).getReg();

    const RegisterBank &DstRB = *RBI.getRegBank(DstReg, MRI, TRI);
    const RegisterBank &SrcRB = *RBI.getRegBank(SrcReg, MRI, TRI);

    if (DstRB.getID() != SrcRB.getID()) {
      DEBUG(dbgs() << "G_TRUNC input/output on different banks\n");
      return false;
    }

    if (DstRB.getID() == AArch64::GPRRegBankID) {
      const TargetRegisterClass *DstRC =
          getRegClassForTypeOnBank(DstTy, DstRB, RBI);
      if (!DstRC)
        return false;

      const TargetRegisterClass *SrcRC =
          getRegClassForTypeOnBank(SrcTy, SrcRB, RBI);
      if (!SrcRC)
        return false;

      if (!RBI.constrainGenericRegister(SrcReg, *SrcRC, MRI) ||
          !RBI.constrainGenericRegister(DstReg, *DstRC, MRI)) {
        DEBUG(dbgs() << "Failed to constrain G_TRUNC\n");
        return false;
      }

      if (DstRC == SrcRC) {
        // Nothing to be done
      } else if (DstRC == &AArch64::GPR32RegClass &&
                 SrcRC == &AArch64::GPR64RegClass) {
        I.getOperand(1).setSubReg(AArch64::sub_32);
      } else {
        return false;
      }

      I.setDesc(TII.get(TargetOpcode::COPY));
      return true;
    } else if (DstRB.getID() == AArch64::FPRRegBankID) {
      if (DstTy == LLT::vector(4, 16) && SrcTy == LLT::vector(4, 32)) {
        I.setDesc(TII.get(AArch64::XTNv4i16));
        constrainSelectedInstRegOperands(I, TII, TRI, RBI);
        return true;
      }
    }

    return false;
  }

  case TargetOpcode::G_ANYEXT: {
    const unsigned DstReg = I.getOperand(0).getReg();
    const unsigned SrcReg = I.getOperand(1).getReg();

    const RegisterBank &RBDst = *RBI.getRegBank(DstReg, MRI, TRI);
    if (RBDst.getID() != AArch64::GPRRegBankID) {
      DEBUG(dbgs() << "G_ANYEXT on bank: " << RBDst << ", expected: GPR\n");
      return false;
    }

    const RegisterBank &RBSrc = *RBI.getRegBank(SrcReg, MRI, TRI);
    if (RBSrc.getID() != AArch64::GPRRegBankID) {
      DEBUG(dbgs() << "G_ANYEXT on bank: " << RBSrc << ", expected: GPR\n");
      return false;
    }

    const unsigned DstSize = MRI.getType(DstReg).getSizeInBits();

    if (DstSize == 0) {
      DEBUG(dbgs() << "G_ANYEXT operand has no size, not a gvreg?\n");
      return false;
    }

    if (DstSize != 64 && DstSize > 32) {
      DEBUG(dbgs() << "G_ANYEXT to size: " << DstSize
                   << ", expected: 32 or 64\n");
      return false;
    }
    // At this point G_ANYEXT is just like a plain COPY, but we need
    // to explicitly form the 64-bit value if any.
    if (DstSize > 32) {
      unsigned ExtSrc = MRI.createVirtualRegister(&AArch64::GPR64allRegClass);
      BuildMI(MBB, I, I.getDebugLoc(), TII.get(AArch64::SUBREG_TO_REG))
          .addDef(ExtSrc)
          .addImm(0)
          .addUse(SrcReg)
          .addImm(AArch64::sub_32);
      I.getOperand(1).setReg(ExtSrc);
    }
    return selectCopy(I, TII, MRI, TRI, RBI);
  }

  case TargetOpcode::G_ZEXT:
  case TargetOpcode::G_SEXT: {
    unsigned Opcode = I.getOpcode();
    const LLT DstTy = MRI.getType(I.getOperand(0).getReg()),
              SrcTy = MRI.getType(I.getOperand(1).getReg());
    const bool isSigned = Opcode == TargetOpcode::G_SEXT;
    const unsigned DefReg = I.getOperand(0).getReg();
    const unsigned SrcReg = I.getOperand(1).getReg();
    const RegisterBank &RB = *RBI.getRegBank(DefReg, MRI, TRI);

    if (RB.getID() != AArch64::GPRRegBankID) {
      DEBUG(dbgs() << TII.getName(I.getOpcode()) << " on bank: " << RB
                   << ", expected: GPR\n");
      return false;
    }

    MachineInstr *ExtI;
    if (DstTy == LLT::scalar(64)) {
      // FIXME: Can we avoid manually doing this?
      if (!RBI.constrainGenericRegister(SrcReg, AArch64::GPR32RegClass, MRI)) {
        DEBUG(dbgs() << "Failed to constrain " << TII.getName(Opcode)
                     << " operand\n");
        return false;
      }

      const unsigned SrcXReg =
          MRI.createVirtualRegister(&AArch64::GPR64RegClass);
      BuildMI(MBB, I, I.getDebugLoc(), TII.get(AArch64::SUBREG_TO_REG))
          .addDef(SrcXReg)
          .addImm(0)
          .addUse(SrcReg)
          .addImm(AArch64::sub_32);

      const unsigned NewOpc = isSigned ? AArch64::SBFMXri : AArch64::UBFMXri;
      ExtI = BuildMI(MBB, I, I.getDebugLoc(), TII.get(NewOpc))
                 .addDef(DefReg)
                 .addUse(SrcXReg)
                 .addImm(0)
                 .addImm(SrcTy.getSizeInBits() - 1);
    } else if (DstTy.isScalar() && DstTy.getSizeInBits() <= 32) {
      const unsigned NewOpc = isSigned ? AArch64::SBFMWri : AArch64::UBFMWri;
      ExtI = BuildMI(MBB, I, I.getDebugLoc(), TII.get(NewOpc))
                 .addDef(DefReg)
                 .addUse(SrcReg)
                 .addImm(0)
                 .addImm(SrcTy.getSizeInBits() - 1);
    } else {
      return false;
    }

    constrainSelectedInstRegOperands(*ExtI, TII, TRI, RBI);

    I.eraseFromParent();
    return true;
  }

  case TargetOpcode::G_SITOFP:
  case TargetOpcode::G_UITOFP:
  case TargetOpcode::G_FPTOSI:
  case TargetOpcode::G_FPTOUI: {
    const LLT DstTy = MRI.getType(I.getOperand(0).getReg()),
              SrcTy = MRI.getType(I.getOperand(1).getReg());
    const unsigned NewOpc = selectFPConvOpc(Opcode, DstTy, SrcTy);
    if (NewOpc == Opcode)
      return false;

    I.setDesc(TII.get(NewOpc));
    constrainSelectedInstRegOperands(I, TII, TRI, RBI);

    return true;
  }


  case TargetOpcode::G_INTTOPTR:
  case TargetOpcode::G_BITCAST:
    return selectCopy(I, TII, MRI, TRI, RBI);

  case TargetOpcode::G_FPEXT: {
    if (MRI.getType(I.getOperand(0).getReg()) != LLT::scalar(64)) {
      DEBUG(dbgs() << "G_FPEXT to type " << Ty
                   << ", expected: " << LLT::scalar(64) << '\n');
      return false;
    }

    if (MRI.getType(I.getOperand(1).getReg()) != LLT::scalar(32)) {
      DEBUG(dbgs() << "G_FPEXT from type " << Ty
                   << ", expected: " << LLT::scalar(32) << '\n');
      return false;
    }

    const unsigned DefReg = I.getOperand(0).getReg();
    const RegisterBank &RB = *RBI.getRegBank(DefReg, MRI, TRI);

    if (RB.getID() != AArch64::FPRRegBankID) {
      DEBUG(dbgs() << "G_FPEXT on bank: " << RB << ", expected: FPR\n");
      return false;
    }

    I.setDesc(TII.get(AArch64::FCVTDSr));
    constrainSelectedInstRegOperands(I, TII, TRI, RBI);

    return true;
  }

  case TargetOpcode::G_FPTRUNC: {
    if (MRI.getType(I.getOperand(0).getReg()) != LLT::scalar(32)) {
      DEBUG(dbgs() << "G_FPTRUNC to type " << Ty
                   << ", expected: " << LLT::scalar(32) << '\n');
      return false;
    }

    if (MRI.getType(I.getOperand(1).getReg()) != LLT::scalar(64)) {
      DEBUG(dbgs() << "G_FPTRUNC from type " << Ty
                   << ", expected: " << LLT::scalar(64) << '\n');
      return false;
    }

    const unsigned DefReg = I.getOperand(0).getReg();
    const RegisterBank &RB = *RBI.getRegBank(DefReg, MRI, TRI);

    if (RB.getID() != AArch64::FPRRegBankID) {
      DEBUG(dbgs() << "G_FPTRUNC on bank: " << RB << ", expected: FPR\n");
      return false;
    }

    I.setDesc(TII.get(AArch64::FCVTSDr));
    constrainSelectedInstRegOperands(I, TII, TRI, RBI);

    return true;
  }

  case TargetOpcode::G_SELECT: {
    if (MRI.getType(I.getOperand(1).getReg()) != LLT::scalar(1)) {
      DEBUG(dbgs() << "G_SELECT cond has type: " << Ty
                   << ", expected: " << LLT::scalar(1) << '\n');
      return false;
    }

    const unsigned CondReg = I.getOperand(1).getReg();
    const unsigned TReg = I.getOperand(2).getReg();
    const unsigned FReg = I.getOperand(3).getReg();

    unsigned CSelOpc = 0;

    if (Ty == LLT::scalar(32)) {
      CSelOpc = AArch64::CSELWr;
    } else if (Ty == LLT::scalar(64) || Ty == LLT::pointer(0, 64)) {
      CSelOpc = AArch64::CSELXr;
    } else {
      return false;
    }

    MachineInstr &TstMI =
        *BuildMI(MBB, I, I.getDebugLoc(), TII.get(AArch64::ANDSWri))
             .addDef(AArch64::WZR)
             .addUse(CondReg)
             .addImm(AArch64_AM::encodeLogicalImmediate(1, 32));

    MachineInstr &CSelMI = *BuildMI(MBB, I, I.getDebugLoc(), TII.get(CSelOpc))
                                .addDef(I.getOperand(0).getReg())
                                .addUse(TReg)
                                .addUse(FReg)
                                .addImm(AArch64CC::NE);

    constrainSelectedInstRegOperands(TstMI, TII, TRI, RBI);
    constrainSelectedInstRegOperands(CSelMI, TII, TRI, RBI);

    I.eraseFromParent();
    return true;
  }
  case TargetOpcode::G_ICMP: {
    if (Ty != LLT::scalar(1)) {
      DEBUG(dbgs() << "G_ICMP result has type: " << Ty
                   << ", expected: " << LLT::scalar(1) << '\n');
      return false;
    }

    unsigned CmpOpc = 0;
    unsigned ZReg = 0;

    LLT CmpTy = MRI.getType(I.getOperand(2).getReg());
    if (CmpTy == LLT::scalar(32)) {
      CmpOpc = AArch64::SUBSWrr;
      ZReg = AArch64::WZR;
    } else if (CmpTy == LLT::scalar(64) || CmpTy.isPointer()) {
      CmpOpc = AArch64::SUBSXrr;
      ZReg = AArch64::XZR;
    } else {
      return false;
    }

    // CSINC increments the result by one when the condition code is false.
    // Therefore, we have to invert the predicate to get an increment by 1 when
    // the predicate is true.
    const AArch64CC::CondCode invCC =
        changeICMPPredToAArch64CC(CmpInst::getInversePredicate(
            (CmpInst::Predicate)I.getOperand(1).getPredicate()));

    MachineInstr &CmpMI = *BuildMI(MBB, I, I.getDebugLoc(), TII.get(CmpOpc))
                               .addDef(ZReg)
                               .addUse(I.getOperand(2).getReg())
                               .addUse(I.getOperand(3).getReg());

    MachineInstr &CSetMI =
        *BuildMI(MBB, I, I.getDebugLoc(), TII.get(AArch64::CSINCWr))
             .addDef(I.getOperand(0).getReg())
             .addUse(AArch64::WZR)
             .addUse(AArch64::WZR)
             .addImm(invCC);

    constrainSelectedInstRegOperands(CmpMI, TII, TRI, RBI);
    constrainSelectedInstRegOperands(CSetMI, TII, TRI, RBI);

    I.eraseFromParent();
    return true;
  }

  case TargetOpcode::G_FCMP: {
    if (Ty != LLT::scalar(1)) {
      DEBUG(dbgs() << "G_FCMP result has type: " << Ty
                   << ", expected: " << LLT::scalar(1) << '\n');
      return false;
    }

    unsigned CmpOpc = 0;
    LLT CmpTy = MRI.getType(I.getOperand(2).getReg());
    if (CmpTy == LLT::scalar(32)) {
      CmpOpc = AArch64::FCMPSrr;
    } else if (CmpTy == LLT::scalar(64)) {
      CmpOpc = AArch64::FCMPDrr;
    } else {
      return false;
    }

    // FIXME: regbank

    AArch64CC::CondCode CC1, CC2;
    changeFCMPPredToAArch64CC(
        (CmpInst::Predicate)I.getOperand(1).getPredicate(), CC1, CC2);

    MachineInstr &CmpMI = *BuildMI(MBB, I, I.getDebugLoc(), TII.get(CmpOpc))
                               .addUse(I.getOperand(2).getReg())
                               .addUse(I.getOperand(3).getReg());

    const unsigned DefReg = I.getOperand(0).getReg();
    unsigned Def1Reg = DefReg;
    if (CC2 != AArch64CC::AL)
      Def1Reg = MRI.createVirtualRegister(&AArch64::GPR32RegClass);

    MachineInstr &CSetMI =
        *BuildMI(MBB, I, I.getDebugLoc(), TII.get(AArch64::CSINCWr))
             .addDef(Def1Reg)
             .addUse(AArch64::WZR)
             .addUse(AArch64::WZR)
             .addImm(getInvertedCondCode(CC1));

    if (CC2 != AArch64CC::AL) {
      unsigned Def2Reg = MRI.createVirtualRegister(&AArch64::GPR32RegClass);
      MachineInstr &CSet2MI =
          *BuildMI(MBB, I, I.getDebugLoc(), TII.get(AArch64::CSINCWr))
               .addDef(Def2Reg)
               .addUse(AArch64::WZR)
               .addUse(AArch64::WZR)
               .addImm(getInvertedCondCode(CC2));
      MachineInstr &OrMI =
          *BuildMI(MBB, I, I.getDebugLoc(), TII.get(AArch64::ORRWrr))
               .addDef(DefReg)
               .addUse(Def1Reg)
               .addUse(Def2Reg);
      constrainSelectedInstRegOperands(OrMI, TII, TRI, RBI);
      constrainSelectedInstRegOperands(CSet2MI, TII, TRI, RBI);
    }

    constrainSelectedInstRegOperands(CmpMI, TII, TRI, RBI);
    constrainSelectedInstRegOperands(CSetMI, TII, TRI, RBI);

    I.eraseFromParent();
    return true;
  }
  }

  return false;
}
