//===- lib/CodeGen/MachineInstr.cpp ---------------------------------------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// Methods common to all machine instructions.
//
//===----------------------------------------------------------------------===//

#include "llvm/CodeGen/MachineInstr.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/FoldingSet.h"
#include "llvm/ADT/Hashing.h"
#include "llvm/ADT/None.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/Analysis/Loads.h"
#include "llvm/Analysis/MemoryLocation.h"
#include "llvm/CodeGen/GlobalISel/RegisterBank.h"
#include "llvm/CodeGen/MachineBasicBlock.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineInstrBundle.h"
#include "llvm/CodeGen/MachineMemOperand.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineOperand.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/PseudoSourceValue.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DebugInfoMetadata.h"
#include "llvm/IR/DebugLoc.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/InlineAsm.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Metadata.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/ModuleSlotTracker.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Value.h"
#include "llvm/MC/MCInstrDesc.h"
#include "llvm/MC/MCRegisterInfo.h"
#include "llvm/MC/MCSymbol.h"
#include "llvm/Support/Casting.h"
#include "llvm/Support/CommandLine.h"
#include "llvm/Support/Compiler.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/LowLevelTypeImpl.h"
#include "llvm/Support/MathExtras.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetInstrInfo.h"
#include "llvm/Target/TargetIntrinsicInfo.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetRegisterInfo.h"
#include "llvm/Target/TargetSubtargetInfo.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <iterator>
#include <utility>

using namespace llvm;

static cl::opt<int> PrintRegMaskNumRegs(
    "print-regmask-num-regs",
    cl::desc("Number of registers to limit to when "
             "printing regmask operands in IR dumps. "
             "unlimited = -1"),
    cl::init(32), cl::Hidden);

//===----------------------------------------------------------------------===//
// MachineOperand Implementation
//===----------------------------------------------------------------------===//

void MachineOperand::setReg(unsigned Reg) {
  if (getReg() == Reg) return; // No change.

  // Otherwise, we have to change the register.  If this operand is embedded
  // into a machine function, we need to update the old and new register's
  // use/def lists.
  if (MachineInstr *MI = getParent())
    if (MachineBasicBlock *MBB = MI->getParent())
      if (MachineFunction *MF = MBB->getParent()) {
        MachineRegisterInfo &MRI = MF->getRegInfo();
        MRI.removeRegOperandFromUseList(this);
        SmallContents.RegNo = Reg;
        MRI.addRegOperandToUseList(this);
        return;
      }

  // Otherwise, just change the register, no problem.  :)
  SmallContents.RegNo = Reg;
}

void MachineOperand::substVirtReg(unsigned Reg, unsigned SubIdx,
                                  const TargetRegisterInfo &TRI) {
  assert(TargetRegisterInfo::isVirtualRegister(Reg));
  if (SubIdx && getSubReg())
    SubIdx = TRI.composeSubRegIndices(SubIdx, getSubReg());
  setReg(Reg);
  if (SubIdx)
    setSubReg(SubIdx);
}

void MachineOperand::substPhysReg(unsigned Reg, const TargetRegisterInfo &TRI) {
  assert(TargetRegisterInfo::isPhysicalRegister(Reg));
  if (getSubReg()) {
    Reg = TRI.getSubReg(Reg, getSubReg());
    // Note that getSubReg() may return 0 if the sub-register doesn't exist.
    // That won't happen in legal code.
    setSubReg(0);
    if (isDef())
      setIsUndef(false);
  }
  setReg(Reg);
}

/// Change a def to a use, or a use to a def.
void MachineOperand::setIsDef(bool Val) {
  assert(isReg() && "Wrong MachineOperand accessor");
  assert((!Val || !isDebug()) && "Marking a debug operation as def");
  if (IsDef == Val)
    return;
  // MRI may keep uses and defs in different list positions.
  if (MachineInstr *MI = getParent())
    if (MachineBasicBlock *MBB = MI->getParent())
      if (MachineFunction *MF = MBB->getParent()) {
        MachineRegisterInfo &MRI = MF->getRegInfo();
        MRI.removeRegOperandFromUseList(this);
        IsDef = Val;
        MRI.addRegOperandToUseList(this);
        return;
      }
  IsDef = Val;
}

// If this operand is currently a register operand, and if this is in a
// function, deregister the operand from the register's use/def list.
void MachineOperand::removeRegFromUses() {
  if (!isReg() || !isOnRegUseList())
    return;

  if (MachineInstr *MI = getParent()) {
    if (MachineBasicBlock *MBB = MI->getParent()) {
      if (MachineFunction *MF = MBB->getParent())
        MF->getRegInfo().removeRegOperandFromUseList(this);
    }
  }
}

/// ChangeToImmediate - Replace this operand with a new immediate operand of
/// the specified value.  If an operand is known to be an immediate already,
/// the setImm method should be used.
void MachineOperand::ChangeToImmediate(int64_t ImmVal) {
  assert((!isReg() || !isTied()) && "Cannot change a tied operand into an imm");

  removeRegFromUses();

  OpKind = MO_Immediate;
  Contents.ImmVal = ImmVal;
}

void MachineOperand::ChangeToFPImmediate(const ConstantFP *FPImm) {
  assert((!isReg() || !isTied()) && "Cannot change a tied operand into an imm");

  removeRegFromUses();

  OpKind = MO_FPImmediate;
  Contents.CFP = FPImm;
}

void MachineOperand::ChangeToES(const char *SymName, unsigned char TargetFlags) {
  assert((!isReg() || !isTied()) &&
         "Cannot change a tied operand into an external symbol");

  removeRegFromUses();

  OpKind = MO_ExternalSymbol;
  Contents.OffsetedInfo.Val.SymbolName = SymName;
  setOffset(0); // Offset is always 0.
  setTargetFlags(TargetFlags);
}

void MachineOperand::ChangeToMCSymbol(MCSymbol *Sym) {
  assert((!isReg() || !isTied()) &&
         "Cannot change a tied operand into an MCSymbol");

  removeRegFromUses();

  OpKind = MO_MCSymbol;
  Contents.Sym = Sym;
}

void MachineOperand::ChangeToFrameIndex(int Idx) {
  assert((!isReg() || !isTied()) &&
         "Cannot change a tied operand into a FrameIndex");

  removeRegFromUses();

  OpKind = MO_FrameIndex;
  setIndex(Idx);
}

void MachineOperand::ChangeToTargetIndex(unsigned Idx, int64_t Offset,
                                         unsigned char TargetFlags) {
  assert((!isReg() || !isTied()) &&
         "Cannot change a tied operand into a FrameIndex");

  removeRegFromUses();

  OpKind = MO_TargetIndex;
  setIndex(Idx);
  setOffset(Offset);
  setTargetFlags(TargetFlags);
}

/// ChangeToRegister - Replace this operand with a new register operand of
/// the specified value.  If an operand is known to be an register already,
/// the setReg method should be used.
void MachineOperand::ChangeToRegister(unsigned Reg, bool isDef, bool isImp,
                                      bool isKill, bool isDead, bool isUndef,
                                      bool isDebug) {
  MachineRegisterInfo *RegInfo = nullptr;
  if (MachineInstr *MI = getParent())
    if (MachineBasicBlock *MBB = MI->getParent())
      if (MachineFunction *MF = MBB->getParent())
        RegInfo = &MF->getRegInfo();
  // If this operand is already a register operand, remove it from the
  // register's use/def lists.
  bool WasReg = isReg();
  if (RegInfo && WasReg)
    RegInfo->removeRegOperandFromUseList(this);

  // Change this to a register and set the reg#.
  OpKind = MO_Register;
  SmallContents.RegNo = Reg;
  SubReg_TargetFlags = 0;
  IsDef = isDef;
  IsImp = isImp;
  IsKill = isKill;
  IsDead = isDead;
  IsUndef = isUndef;
  IsInternalRead = false;
  IsEarlyClobber = false;
  IsDebug = isDebug;
  // Ensure isOnRegUseList() returns false.
  Contents.Reg.Prev = nullptr;
  // Preserve the tie when the operand was already a register.
  if (!WasReg)
    TiedTo = 0;

  // If this operand is embedded in a function, add the operand to the
  // register's use/def list.
  if (RegInfo)
    RegInfo->addRegOperandToUseList(this);
}

/// isIdenticalTo - Return true if this operand is identical to the specified
/// operand. Note that this should stay in sync with the hash_value overload
/// below.
bool MachineOperand::isIdenticalTo(const MachineOperand &Other) const {
  if (getType() != Other.getType() ||
      getTargetFlags() != Other.getTargetFlags())
    return false;

  switch (getType()) {
  case MachineOperand::MO_Register:
    return getReg() == Other.getReg() && isDef() == Other.isDef() &&
           getSubReg() == Other.getSubReg();
  case MachineOperand::MO_Immediate:
    return getImm() == Other.getImm();
  case MachineOperand::MO_CImmediate:
    return getCImm() == Other.getCImm();
  case MachineOperand::MO_FPImmediate:
    return getFPImm() == Other.getFPImm();
  case MachineOperand::MO_MachineBasicBlock:
    return getMBB() == Other.getMBB();
  case MachineOperand::MO_FrameIndex:
    return getIndex() == Other.getIndex();
  case MachineOperand::MO_ConstantPoolIndex:
  case MachineOperand::MO_TargetIndex:
    return getIndex() == Other.getIndex() && getOffset() == Other.getOffset();
  case MachineOperand::MO_JumpTableIndex:
    return getIndex() == Other.getIndex();
  case MachineOperand::MO_GlobalAddress:
    return getGlobal() == Other.getGlobal() && getOffset() == Other.getOffset();
  case MachineOperand::MO_ExternalSymbol:
    return strcmp(getSymbolName(), Other.getSymbolName()) == 0 &&
           getOffset() == Other.getOffset();
  case MachineOperand::MO_BlockAddress:
    return getBlockAddress() == Other.getBlockAddress() &&
           getOffset() == Other.getOffset();
  case MachineOperand::MO_RegisterMask:
  case MachineOperand::MO_RegisterLiveOut: {
    // Shallow compare of the two RegMasks
    const uint32_t *RegMask = getRegMask();
    const uint32_t *OtherRegMask = Other.getRegMask();
    if (RegMask == OtherRegMask)
      return true;

    // Calculate the size of the RegMask
    const MachineFunction *MF = getParent()->getParent()->getParent();
    const TargetRegisterInfo *TRI = MF->getSubtarget().getRegisterInfo();
    unsigned RegMaskSize = (TRI->getNumRegs() + 31) / 32;

    // Deep compare of the two RegMasks
    return std::equal(RegMask, RegMask + RegMaskSize, OtherRegMask);
  }
  case MachineOperand::MO_MCSymbol:
    return getMCSymbol() == Other.getMCSymbol();
  case MachineOperand::MO_CFIIndex:
    return getCFIIndex() == Other.getCFIIndex();
  case MachineOperand::MO_Metadata:
    return getMetadata() == Other.getMetadata();
  case MachineOperand::MO_IntrinsicID:
    return getIntrinsicID() == Other.getIntrinsicID();
  case MachineOperand::MO_Predicate:
    return getPredicate() == Other.getPredicate();
  }
  llvm_unreachable("Invalid machine operand type");
}

// Note: this must stay exactly in sync with isIdenticalTo above.
hash_code llvm::hash_value(const MachineOperand &MO) {
  switch (MO.getType()) {
  case MachineOperand::MO_Register:
    // Register operands don't have target flags.
    return hash_combine(MO.getType(), MO.getReg(), MO.getSubReg(), MO.isDef());
  case MachineOperand::MO_Immediate:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getImm());
  case MachineOperand::MO_CImmediate:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getCImm());
  case MachineOperand::MO_FPImmediate:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getFPImm());
  case MachineOperand::MO_MachineBasicBlock:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getMBB());
  case MachineOperand::MO_FrameIndex:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getIndex());
  case MachineOperand::MO_ConstantPoolIndex:
  case MachineOperand::MO_TargetIndex:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getIndex(),
                        MO.getOffset());
  case MachineOperand::MO_JumpTableIndex:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getIndex());
  case MachineOperand::MO_ExternalSymbol:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getOffset(),
                        MO.getSymbolName());
  case MachineOperand::MO_GlobalAddress:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getGlobal(),
                        MO.getOffset());
  case MachineOperand::MO_BlockAddress:
    return hash_combine(MO.getType(), MO.getTargetFlags(),
                        MO.getBlockAddress(), MO.getOffset());
  case MachineOperand::MO_RegisterMask:
  case MachineOperand::MO_RegisterLiveOut:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getRegMask());
  case MachineOperand::MO_Metadata:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getMetadata());
  case MachineOperand::MO_MCSymbol:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getMCSymbol());
  case MachineOperand::MO_CFIIndex:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getCFIIndex());
  case MachineOperand::MO_IntrinsicID:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getIntrinsicID());
  case MachineOperand::MO_Predicate:
    return hash_combine(MO.getType(), MO.getTargetFlags(), MO.getPredicate());
  }
  llvm_unreachable("Invalid machine operand type");
}

void MachineOperand::print(raw_ostream &OS, const TargetRegisterInfo *TRI,
                           const TargetIntrinsicInfo *IntrinsicInfo) const {
  ModuleSlotTracker DummyMST(nullptr);
  print(OS, DummyMST, TRI, IntrinsicInfo);
}

void MachineOperand::print(raw_ostream &OS, ModuleSlotTracker &MST,
                           const TargetRegisterInfo *TRI,
                           const TargetIntrinsicInfo *IntrinsicInfo) const {
  switch (getType()) {
  case MachineOperand::MO_Register:
    OS << PrintReg(getReg(), TRI, getSubReg());

    if (isDef() || isKill() || isDead() || isImplicit() || isUndef() ||
        isInternalRead() || isEarlyClobber() || isTied()) {
      OS << '<';
      bool NeedComma = false;
      if (isDef()) {
        if (NeedComma) OS << ',';
        if (isEarlyClobber())
          OS << "earlyclobber,";
        if (isImplicit())
          OS << "imp-";
        OS << "def";
        NeedComma = true;
        // <def,read-undef> only makes sense when getSubReg() is set.
        // Don't clutter the output otherwise.
        if (isUndef() && getSubReg())
          OS << ",read-undef";
      } else if (isImplicit()) {
        OS << "imp-use";
        NeedComma = true;
      }

      if (isKill()) {
        if (NeedComma) OS << ',';
        OS << "kill";
        NeedComma = true;
      }
      if (isDead()) {
        if (NeedComma) OS << ',';
        OS << "dead";
        NeedComma = true;
      }
      if (isUndef() && isUse()) {
        if (NeedComma) OS << ',';
        OS << "undef";
        NeedComma = true;
      }
      if (isInternalRead()) {
        if (NeedComma) OS << ',';
        OS << "internal";
        NeedComma = true;
      }
      if (isTied()) {
        if (NeedComma) OS << ',';
        OS << "tied";
        if (TiedTo != 15)
          OS << unsigned(TiedTo - 1);
      }
      OS << '>';
    }
    break;
  case MachineOperand::MO_Immediate:
    OS << getImm();
    break;
  case MachineOperand::MO_CImmediate:
    getCImm()->getValue().print(OS, false);
    break;
  case MachineOperand::MO_FPImmediate:
    if (getFPImm()->getType()->isFloatTy()) {
      OS << getFPImm()->getValueAPF().convertToFloat();
    } else if (getFPImm()->getType()->isHalfTy()) {
      APFloat APF = getFPImm()->getValueAPF();
      bool Unused;
      APF.convert(APFloat::IEEEsingle(), APFloat::rmNearestTiesToEven, &Unused);
      OS << "half " << APF.convertToFloat();
    } else if (getFPImm()->getType()->isFP128Ty()) {
      APFloat APF = getFPImm()->getValueAPF();
      SmallString<16> Str;
      getFPImm()->getValueAPF().toString(Str);
      OS << "quad " << Str;
    } else if (getFPImm()->getType()->isX86_FP80Ty()) {
      APFloat APF = getFPImm()->getValueAPF();
      OS << "x86_fp80 0xK";
      APInt API = APF.bitcastToAPInt();
      OS << format_hex_no_prefix(API.getHiBits(16).getZExtValue(), 4,
                                 /*Upper=*/true);
      OS << format_hex_no_prefix(API.getLoBits(64).getZExtValue(), 16,
                                 /*Upper=*/true);
    } else {
      OS << getFPImm()->getValueAPF().convertToDouble();
    }
    break;
  case MachineOperand::MO_MachineBasicBlock:
    OS << "<BB#" << getMBB()->getNumber() << ">";
    break;
  case MachineOperand::MO_FrameIndex:
    OS << "<fi#" << getIndex() << '>';
    break;
  case MachineOperand::MO_ConstantPoolIndex:
    OS << "<cp#" << getIndex();
    if (getOffset()) OS << "+" << getOffset();
    OS << '>';
    break;
  case MachineOperand::MO_TargetIndex:
    OS << "<ti#" << getIndex();
    if (getOffset()) OS << "+" << getOffset();
    OS << '>';
    break;
  case MachineOperand::MO_JumpTableIndex:
    OS << "<jt#" << getIndex() << '>';
    break;
  case MachineOperand::MO_GlobalAddress:
    OS << "<ga:";
    getGlobal()->printAsOperand(OS, /*PrintType=*/false, MST);
    if (getOffset()) OS << "+" << getOffset();
    OS << '>';
    break;
  case MachineOperand::MO_ExternalSymbol:
    OS << "<es:" << getSymbolName();
    if (getOffset()) OS << "+" << getOffset();
    OS << '>';
    break;
  case MachineOperand::MO_BlockAddress:
    OS << '<';
    getBlockAddress()->printAsOperand(OS, /*PrintType=*/false, MST);
    if (getOffset()) OS << "+" << getOffset();
    OS << '>';
    break;
  case MachineOperand::MO_RegisterMask: {
    unsigned NumRegsInMask = 0;
    unsigned NumRegsEmitted = 0;
    OS << "<regmask";
    for (unsigned i = 0; i < TRI->getNumRegs(); ++i) {
      unsigned MaskWord = i / 32;
      unsigned MaskBit = i % 32;
      if (getRegMask()[MaskWord] & (1 << MaskBit)) {
        if (PrintRegMaskNumRegs < 0 ||
            NumRegsEmitted <= static_cast<unsigned>(PrintRegMaskNumRegs)) {
          OS << " " << PrintReg(i, TRI);
          NumRegsEmitted++;
        }
        NumRegsInMask++;
      }
    }
    if (NumRegsEmitted != NumRegsInMask)
      OS << " and " << (NumRegsInMask - NumRegsEmitted) << " more...";
    OS << ">";
    break;
  }
  case MachineOperand::MO_RegisterLiveOut:
    OS << "<regliveout>";
    break;
  case MachineOperand::MO_Metadata:
    OS << '<';
    getMetadata()->printAsOperand(OS, MST);
    OS << '>';
    break;
  case MachineOperand::MO_MCSymbol:
    OS << "<MCSym=" << *getMCSymbol() << '>';
    break;
  case MachineOperand::MO_CFIIndex:
    OS << "<call frame instruction>";
    break;
  case MachineOperand::MO_IntrinsicID: {
    Intrinsic::ID ID = getIntrinsicID();
    if (ID < Intrinsic::num_intrinsics)
      OS << "<intrinsic:@" << Intrinsic::getName(ID, None) << '>';
    else if (IntrinsicInfo)
      OS << "<intrinsic:@" << IntrinsicInfo->getName(ID) << '>';
    else
      OS << "<intrinsic:" << ID << '>';
    break;
  }
  case MachineOperand::MO_Predicate: {
    auto Pred = static_cast<CmpInst::Predicate>(getPredicate());
    OS << '<' << (CmpInst::isIntPredicate(Pred) ? "intpred" : "floatpred")
       << CmpInst::getPredicateName(Pred) << '>';
    break;
  }
  }
  if (unsigned TF = getTargetFlags())
    OS << "[TF=" << TF << ']';
}

#if !defined(NDEBUG) || defined(LLVM_ENABLE_DUMP)
LLVM_DUMP_METHOD void MachineOperand::dump() const {
  dbgs() << *this << '\n';
}
#endif

//===----------------------------------------------------------------------===//
// MachineMemOperand Implementation
//===----------------------------------------------------------------------===//

/// getAddrSpace - Return the LLVM IR address space number that this pointer
/// points into.
unsigned MachinePointerInfo::getAddrSpace() const {
  if (V.isNull() || V.is<const PseudoSourceValue*>()) return 0;
  return cast<PointerType>(V.get<const Value*>()->getType())->getAddressSpace();
}

/// isDereferenceable - Return true if V is always dereferenceable for 
/// Offset + Size byte.
bool MachinePointerInfo::isDereferenceable(unsigned Size, LLVMContext &C,
                                           const DataLayout &DL) const {
  if (!V.is<const Value*>())
    return false;

  const Value *BasePtr = V.get<const Value*>();
  if (BasePtr == nullptr)
    return false;

  return isDereferenceableAndAlignedPointer(
      BasePtr, 1, APInt(DL.getPointerSizeInBits(), Offset + Size), DL);
}

/// getConstantPool - Return a MachinePointerInfo record that refers to the
/// constant pool.
MachinePointerInfo MachinePointerInfo::getConstantPool(MachineFunction &MF) {
  return MachinePointerInfo(MF.getPSVManager().getConstantPool());
}

/// getFixedStack - Return a MachinePointerInfo record that refers to the
/// the specified FrameIndex.
MachinePointerInfo MachinePointerInfo::getFixedStack(MachineFunction &MF,
                                                     int FI, int64_t Offset) {
  return MachinePointerInfo(MF.getPSVManager().getFixedStack(FI), Offset);
}

MachinePointerInfo MachinePointerInfo::getJumpTable(MachineFunction &MF) {
  return MachinePointerInfo(MF.getPSVManager().getJumpTable());
}

MachinePointerInfo MachinePointerInfo::getGOT(MachineFunction &MF) {
  return MachinePointerInfo(MF.getPSVManager().getGOT());
}

MachinePointerInfo MachinePointerInfo::getStack(MachineFunction &MF,
                                                int64_t Offset,
                                                uint8_t ID) {
  return MachinePointerInfo(MF.getPSVManager().getStack(), Offset,ID);
}

MachineMemOperand::MachineMemOperand(MachinePointerInfo ptrinfo, Flags f,
                                     uint64_t s, unsigned int a,
                                     const AAMDNodes &AAInfo,
                                     const MDNode *Ranges,
                                     SyncScope::ID SSID,
                                     AtomicOrdering Ordering,
                                     AtomicOrdering FailureOrdering)
    : PtrInfo(ptrinfo), Size(s), FlagVals(f), BaseAlignLog2(Log2_32(a) + 1),
      AAInfo(AAInfo), Ranges(Ranges) {
  assert((PtrInfo.V.isNull() || PtrInfo.V.is<const PseudoSourceValue*>() ||
          isa<PointerType>(PtrInfo.V.get<const Value*>()->getType())) &&
         "invalid pointer value");
  assert(getBaseAlignment() == a && "Alignment is not a power of 2!");
  assert((isLoad() || isStore()) && "Not a load/store!");

  AtomicInfo.SSID = static_cast<unsigned>(SSID);
  assert(getSyncScopeID() == SSID && "Value truncated");
  AtomicInfo.Ordering = static_cast<unsigned>(Ordering);
  assert(getOrdering() == Ordering && "Value truncated");
  AtomicInfo.FailureOrdering = static_cast<unsigned>(FailureOrdering);
  assert(getFailureOrdering() == FailureOrdering && "Value truncated");
}

/// Profile - Gather unique data for the object.
///
void MachineMemOperand::Profile(FoldingSetNodeID &ID) const {
  ID.AddInteger(getOffset());
  ID.AddInteger(Size);
  ID.AddPointer(getOpaqueValue());
  ID.AddInteger(getFlags());
  ID.AddInteger(getBaseAlignment());
}

void MachineMemOperand::refineAlignment(const MachineMemOperand *MMO) {
  // The Value and Offset may differ due to CSE. But the flags and size
  // should be the same.
  assert(MMO->getFlags() == getFlags() && "Flags mismatch!");
  assert(MMO->getSize() == getSize() && "Size mismatch!");

  if (MMO->getBaseAlignment() >= getBaseAlignment()) {
    // Update the alignment value.
    BaseAlignLog2 = Log2_32(MMO->getBaseAlignment()) + 1;
    // Also update the base and offset, because the new alignment may
    // not be applicable with the old ones.
    PtrInfo = MMO->PtrInfo;
  }
}

/// getAlignment - Return the minimum known alignment in bytes of the
/// actual memory reference.
uint64_t MachineMemOperand::getAlignment() const {
  return MinAlign(getBaseAlignment(), getOffset());
}

void MachineMemOperand::print(raw_ostream &OS) const {
  ModuleSlotTracker DummyMST(nullptr);
  print(OS, DummyMST);
}
void MachineMemOperand::print(raw_ostream &OS, ModuleSlotTracker &MST) const {
  assert((isLoad() || isStore()) &&
         "SV has to be a load, store or both.");

  if (isVolatile())
    OS << "Volatile ";

  if (isLoad())
    OS << "LD";
  if (isStore())
    OS << "ST";
  OS << getSize();

  // Print the address information.
  OS << "[";
  if (const Value *V = getValue())
    V->printAsOperand(OS, /*PrintType=*/false, MST);
  else if (const PseudoSourceValue *PSV = getPseudoValue())
    PSV->printCustom(OS);
  else
    OS << "<unknown>";

  unsigned AS = getAddrSpace();
  if (AS != 0)
    OS << "(addrspace=" << AS << ')';

  // If the alignment of the memory reference itself differs from the alignment
  // of the base pointer, print the base alignment explicitly, next to the base
  // pointer.
  if (getBaseAlignment() != getAlignment())
    OS << "(align=" << getBaseAlignment() << ")";

  if (getOffset() != 0)
    OS << "+" << getOffset();
  OS << "]";

  // Print the alignment of the reference.
  if (getBaseAlignment() != getAlignment() || getBaseAlignment() != getSize())
    OS << "(align=" << getAlignment() << ")";

  // Print TBAA info.
  if (const MDNode *TBAAInfo = getAAInfo().TBAA) {
    OS << "(tbaa=";
    if (TBAAInfo->getNumOperands() > 0)
      TBAAInfo->getOperand(0)->printAsOperand(OS, MST);
    else
      OS << "<unknown>";
    OS << ")";
  }

  // Print AA scope info.
  if (const MDNode *ScopeInfo = getAAInfo().Scope) {
    OS << "(alias.scope=";
    if (ScopeInfo->getNumOperands() > 0)
      for (unsigned i = 0, ie = ScopeInfo->getNumOperands(); i != ie; ++i) {
        ScopeInfo->getOperand(i)->printAsOperand(OS, MST);
        if (i != ie-1)
          OS << ",";
      }
    else
      OS << "<unknown>";
    OS << ")";
  }

  // Print AA noalias scope info.
  if (const MDNode *NoAliasInfo = getAAInfo().NoAlias) {
    OS << "(noalias=";
    if (NoAliasInfo->getNumOperands() > 0)
      for (unsigned i = 0, ie = NoAliasInfo->getNumOperands(); i != ie; ++i) {
        NoAliasInfo->getOperand(i)->printAsOperand(OS, MST);
        if (i != ie-1)
          OS << ",";
      }
    else
      OS << "<unknown>";
    OS << ")";
  }

  if (isNonTemporal())
    OS << "(nontemporal)";
  if (isDereferenceable())
    OS << "(dereferenceable)";
  if (isInvariant())
    OS << "(invariant)";
  if (getFlags() & MOTargetFlag1)
    OS << "(flag1)";
  if (getFlags() & MOTargetFlag2)
    OS << "(flag2)";
  if (getFlags() & MOTargetFlag3)
    OS << "(flag3)";
}

//===----------------------------------------------------------------------===//
// MachineInstr Implementation
//===----------------------------------------------------------------------===//

void MachineInstr::addImplicitDefUseOperands(MachineFunction &MF) {
  if (MCID->ImplicitDefs)
    for (const MCPhysReg *ImpDefs = MCID->getImplicitDefs(); *ImpDefs;
           ++ImpDefs)
      addOperand(MF, MachineOperand::CreateReg(*ImpDefs, true, true));
  if (MCID->ImplicitUses)
    for (const MCPhysReg *ImpUses = MCID->getImplicitUses(); *ImpUses;
           ++ImpUses)
      addOperand(MF, MachineOperand::CreateReg(*ImpUses, false, true));
}

/// MachineInstr ctor - This constructor creates a MachineInstr and adds the
/// implicit operands. It reserves space for the number of operands specified by
/// the MCInstrDesc.
MachineInstr::MachineInstr(MachineFunction &MF, const MCInstrDesc &tid,
                           DebugLoc dl, bool NoImp)
    : MCID(&tid), debugLoc(std::move(dl)) {
  assert(debugLoc.hasTrivialDestructor() && "Expected trivial destructor");

  // Reserve space for the expected number of operands.
  if (unsigned NumOps = MCID->getNumOperands() +
    MCID->getNumImplicitDefs() + MCID->getNumImplicitUses()) {
    CapOperands = OperandCapacity::get(NumOps);
    Operands = MF.allocateOperandArray(CapOperands);
  }

  if (!NoImp)
    addImplicitDefUseOperands(MF);
}

/// MachineInstr ctor - Copies MachineInstr arg exactly
///
MachineInstr::MachineInstr(MachineFunction &MF, const MachineInstr &MI)
    : MCID(&MI.getDesc()), NumMemRefs(MI.NumMemRefs), MemRefs(MI.MemRefs),
      debugLoc(MI.getDebugLoc()) {
  assert(debugLoc.hasTrivialDestructor() && "Expected trivial destructor");

  CapOperands = OperandCapacity::get(MI.getNumOperands());
  Operands = MF.allocateOperandArray(CapOperands);

  // Copy operands.
  for (const MachineOperand &MO : MI.operands())
    addOperand(MF, MO);

  // Copy all the sensible flags.
  setFlags(MI.Flags);
}

/// getRegInfo - If this instruction is embedded into a MachineFunction,
/// return the MachineRegisterInfo object for the current function, otherwise
/// return null.
MachineRegisterInfo *MachineInstr::getRegInfo() {
  if (MachineBasicBlock *MBB = getParent())
    return &MBB->getParent()->getRegInfo();
  return nullptr;
}

/// RemoveRegOperandsFromUseLists - Unlink all of the register operands in
/// this instruction from their respective use lists.  This requires that the
/// operands already be on their use lists.
void MachineInstr::RemoveRegOperandsFromUseLists(MachineRegisterInfo &MRI) {
  for (MachineOperand &MO : operands())
    if (MO.isReg())
      MRI.removeRegOperandFromUseList(&MO);
}

/// AddRegOperandsToUseLists - Add all of the register operands in
/// this instruction from their respective use lists.  This requires that the
/// operands not be on their use lists yet.
void MachineInstr::AddRegOperandsToUseLists(MachineRegisterInfo &MRI) {
  for (MachineOperand &MO : operands())
    if (MO.isReg())
      MRI.addRegOperandToUseList(&MO);
}

void MachineInstr::addOperand(const MachineOperand &Op) {
  MachineBasicBlock *MBB = getParent();
  assert(MBB && "Use MachineInstrBuilder to add operands to dangling instrs");
  MachineFunction *MF = MBB->getParent();
  assert(MF && "Use MachineInstrBuilder to add operands to dangling instrs");
  addOperand(*MF, Op);
}

/// Move NumOps MachineOperands from Src to Dst, with support for overlapping
/// ranges. If MRI is non-null also update use-def chains.
static void moveOperands(MachineOperand *Dst, MachineOperand *Src,
                         unsigned NumOps, MachineRegisterInfo *MRI) {
  if (MRI)
    return MRI->moveOperands(Dst, Src, NumOps);

  // MachineOperand is a trivially copyable type so we can just use memmove.
  std::memmove(Dst, Src, NumOps * sizeof(MachineOperand));
}

/// addOperand - Add the specified operand to the instruction.  If it is an
/// implicit operand, it is added to the end of the operand list.  If it is
/// an explicit operand it is added at the end of the explicit operand list
/// (before the first implicit operand).
void MachineInstr::addOperand(MachineFunction &MF, const MachineOperand &Op) {
  assert(MCID && "Cannot add operands before providing an instr descriptor");

  // Check if we're adding one of our existing operands.
  if (&Op >= Operands && &Op < Operands + NumOperands) {
    // This is unusual: MI->addOperand(MI->getOperand(i)).
    // If adding Op requires reallocating or moving existing operands around,
    // the Op reference could go stale. Support it by copying Op.
    MachineOperand CopyOp(Op);
    return addOperand(MF, CopyOp);
  }

  // Find the insert location for the new operand.  Implicit registers go at
  // the end, everything else goes before the implicit regs.
  //
  // FIXME: Allow mixed explicit and implicit operands on inline asm.
  // InstrEmitter::EmitSpecialNode() is marking inline asm clobbers as
  // implicit-defs, but they must not be moved around.  See the FIXME in
  // InstrEmitter.cpp.
  unsigned OpNo = getNumOperands();
  bool isImpReg = Op.isReg() && Op.isImplicit();
  if (!isImpReg && !isInlineAsm()) {
    while (OpNo && Operands[OpNo-1].isReg() && Operands[OpNo-1].isImplicit()) {
      --OpNo;
      assert(!Operands[OpNo].isTied() && "Cannot move tied operands");
    }
  }

#ifndef NDEBUG
  bool isMetaDataOp = Op.getType() == MachineOperand::MO_Metadata;
  // OpNo now points as the desired insertion point.  Unless this is a variadic
  // instruction, only implicit regs are allowed beyond MCID->getNumOperands().
  // RegMask operands go between the explicit and implicit operands.
  assert((isImpReg || Op.isRegMask() || MCID->isVariadic() ||
          OpNo < MCID->getNumOperands() || isMetaDataOp) &&
         "Trying to add an operand to a machine instr that is already done!");
#endif

  MachineRegisterInfo *MRI = getRegInfo();

  // Determine if the Operands array needs to be reallocated.
  // Save the old capacity and operand array.
  OperandCapacity OldCap = CapOperands;
  MachineOperand *OldOperands = Operands;
  if (!OldOperands || OldCap.getSize() == getNumOperands()) {
    CapOperands = OldOperands ? OldCap.getNext() : OldCap.get(1);
    Operands = MF.allocateOperandArray(CapOperands);
    // Move the operands before the insertion point.
    if (OpNo)
      moveOperands(Operands, OldOperands, OpNo, MRI);
  }

  // Move the operands following the insertion point.
  if (OpNo != NumOperands)
    moveOperands(Operands + OpNo + 1, OldOperands + OpNo, NumOperands - OpNo,
                 MRI);
  ++NumOperands;

  // Deallocate the old operand array.
  if (OldOperands != Operands && OldOperands)
    MF.deallocateOperandArray(OldCap, OldOperands);

  // Copy Op into place. It still needs to be inserted into the MRI use lists.
  MachineOperand *NewMO = new (Operands + OpNo) MachineOperand(Op);
  NewMO->ParentMI = this;

  // When adding a register operand, tell MRI about it.
  if (NewMO->isReg()) {
    // Ensure isOnRegUseList() returns false, regardless of Op's status.
    NewMO->Contents.Reg.Prev = nullptr;
    // Ignore existing ties. This is not a property that can be copied.
    NewMO->TiedTo = 0;
    // Add the new operand to MRI, but only for instructions in an MBB.
    if (MRI)
      MRI->addRegOperandToUseList(NewMO);
    // The MCID operand information isn't accurate until we start adding
    // explicit operands. The implicit operands are added first, then the
    // explicits are inserted before them.
    if (!isImpReg) {
      // Tie uses to defs as indicated in MCInstrDesc.
      if (NewMO->isUse()) {
        int DefIdx = MCID->getOperandConstraint(OpNo, MCOI::TIED_TO);
        if (DefIdx != -1)
          tieOperands(DefIdx, OpNo);
      }
      // If the register operand is flagged as early, mark the operand as such.
      if (MCID->getOperandConstraint(OpNo, MCOI::EARLY_CLOBBER) != -1)
        NewMO->setIsEarlyClobber(true);
    }
  }
}

/// RemoveOperand - Erase an operand  from an instruction, leaving it with one
/// fewer operand than it started with.
///
void MachineInstr::RemoveOperand(unsigned OpNo) {
  assert(OpNo < getNumOperands() && "Invalid operand number");
  untieRegOperand(OpNo);

#ifndef NDEBUG
  // Moving tied operands would break the ties.
  for (unsigned i = OpNo + 1, e = getNumOperands(); i != e; ++i)
    if (Operands[i].isReg())
      assert(!Operands[i].isTied() && "Cannot move tied operands");
#endif

  MachineRegisterInfo *MRI = getRegInfo();
  if (MRI && Operands[OpNo].isReg())
    MRI->removeRegOperandFromUseList(Operands + OpNo);

  // Don't call the MachineOperand destructor. A lot of this code depends on
  // MachineOperand having a trivial destructor anyway, and adding a call here
  // wouldn't make it 'destructor-correct'.

  if (unsigned N = NumOperands - 1 - OpNo)
    moveOperands(Operands + OpNo, Operands + OpNo + 1, N, MRI);
  --NumOperands;
}

/// addMemOperand - Add a MachineMemOperand to the machine instruction.
/// This function should be used only occasionally. The setMemRefs function
/// is the primary method for setting up a MachineInstr's MemRefs list.
void MachineInstr::addMemOperand(MachineFunction &MF,
                                 MachineMemOperand *MO) {
  mmo_iterator OldMemRefs = MemRefs;
  unsigned OldNumMemRefs = NumMemRefs;

  unsigned NewNum = NumMemRefs + 1;
  mmo_iterator NewMemRefs = MF.allocateMemRefsArray(NewNum);

  std::copy(OldMemRefs, OldMemRefs + OldNumMemRefs, NewMemRefs);
  NewMemRefs[NewNum - 1] = MO;
  setMemRefs(NewMemRefs, NewMemRefs + NewNum);
}

/// Check to see if the MMOs pointed to by the two MemRefs arrays are
/// identical.
static bool hasIdenticalMMOs(const MachineInstr &MI1, const MachineInstr &MI2) {
  auto I1 = MI1.memoperands_begin(), E1 = MI1.memoperands_end();
  auto I2 = MI2.memoperands_begin(), E2 = MI2.memoperands_end();
  if ((E1 - I1) != (E2 - I2))
    return false;
  for (; I1 != E1; ++I1, ++I2) {
    if (**I1 != **I2)
      return false;
  }
  return true;
}

std::pair<MachineInstr::mmo_iterator, unsigned>
MachineInstr::mergeMemRefsWith(const MachineInstr& Other) {

  // If either of the incoming memrefs are empty, we must be conservative and
  // treat this as if we've exhausted our space for memrefs and dropped them.
  if (memoperands_empty() || Other.memoperands_empty())
    return std::make_pair(nullptr, 0);

  // If both instructions have identical memrefs, we don't need to merge them.
  // Since many instructions have a single memref, and we tend to merge things
  // like pairs of loads from the same location, this catches a large number of
  // cases in practice.
  if (hasIdenticalMMOs(*this, Other))
    return std::make_pair(MemRefs, NumMemRefs);

  // TODO: consider uniquing elements within the operand lists to reduce
  // space usage and fall back to conservative information less often.
  size_t CombinedNumMemRefs = NumMemRefs + Other.NumMemRefs;

  // If we don't have enough room to store this many memrefs, be conservative
  // and drop them.  Otherwise, we'd fail asserts when trying to add them to
  // the new instruction.
  if (CombinedNumMemRefs != uint8_t(CombinedNumMemRefs))
    return std::make_pair(nullptr, 0);

  MachineFunction *MF = getParent()->getParent();
  mmo_iterator MemBegin = MF->allocateMemRefsArray(CombinedNumMemRefs);
  mmo_iterator MemEnd = std::copy(memoperands_begin(), memoperands_end(),
                                  MemBegin);
  MemEnd = std::copy(Other.memoperands_begin(), Other.memoperands_end(),
                     MemEnd);
  assert(MemEnd - MemBegin == (ptrdiff_t)CombinedNumMemRefs &&
         "missing memrefs");

  return std::make_pair(MemBegin, CombinedNumMemRefs);
}

bool MachineInstr::hasPropertyInBundle(unsigned Mask, QueryType Type) const {
  assert(!isBundledWithPred() && "Must be called on bundle header");
  for (MachineBasicBlock::const_instr_iterator MII = getIterator();; ++MII) {
    if (MII->getDesc().getFlags() & Mask) {
      if (Type == AnyInBundle)
        return true;
    } else {
      if (Type == AllInBundle && !MII->isBundle())
        return false;
    }
    // This was the last instruction in the bundle.
    if (!MII->isBundledWithSucc())
      return Type == AllInBundle;
  }
}

bool MachineInstr::isIdenticalTo(const MachineInstr &Other,
                                 MICheckType Check) const {
  // If opcodes or number of operands are not the same then the two
  // instructions are obviously not identical.
  if (Other.getOpcode() != getOpcode() ||
      Other.getNumOperands() != getNumOperands())
    return false;

  if (isBundle()) {
    // We have passed the test above that both instructions have the same
    // opcode, so we know that both instructions are bundles here. Let's compare
    // MIs inside the bundle.
    assert(Other.isBundle() && "Expected that both instructions are bundles.");
    MachineBasicBlock::const_instr_iterator I1 = getIterator();
    MachineBasicBlock::const_instr_iterator I2 = Other.getIterator();
    // Loop until we analysed the last intruction inside at least one of the
    // bundles.
    while (I1->isBundledWithSucc() && I2->isBundledWithSucc()) {
      ++I1;
      ++I2;
      if (!I1->isIdenticalTo(*I2, Check))
        return false;
    }
    // If we've reached the end of just one of the two bundles, but not both,
    // the instructions are not identical.
    if (I1->isBundledWithSucc() || I2->isBundledWithSucc())
      return false;
  }

  // Check operands to make sure they match.
  for (unsigned i = 0, e = getNumOperands(); i != e; ++i) {
    const MachineOperand &MO = getOperand(i);
    const MachineOperand &OMO = Other.getOperand(i);
    if (!MO.isReg()) {
      if (!MO.isIdenticalTo(OMO))
        return false;
      continue;
    }

    // Clients may or may not want to ignore defs when testing for equality.
    // For example, machine CSE pass only cares about finding common
    // subexpressions, so it's safe to ignore virtual register defs.
    if (MO.isDef()) {
      if (Check == IgnoreDefs)
        continue;
      else if (Check == IgnoreVRegDefs) {
        if (TargetRegisterInfo::isPhysicalRegister(MO.getReg()) ||
            TargetRegisterInfo::isPhysicalRegister(OMO.getReg()))
          if (MO.getReg() != OMO.getReg())
            return false;
      } else {
        if (!MO.isIdenticalTo(OMO))
          return false;
        if (Check == CheckKillDead && MO.isDead() != OMO.isDead())
          return false;
      }
    } else {
      if (!MO.isIdenticalTo(OMO))
        return false;
      if (Check == CheckKillDead && MO.isKill() != OMO.isKill())
        return false;
    }
  }
  // If DebugLoc does not match then two dbg.values are not identical.
  if (isDebugValue())
    if (getDebugLoc() && Other.getDebugLoc() &&
        getDebugLoc() != Other.getDebugLoc())
      return false;
  return true;
}

MachineInstr *MachineInstr::removeFromParent() {
  assert(getParent() && "Not embedded in a basic block!");
  return getParent()->remove(this);
}

MachineInstr *MachineInstr::removeFromBundle() {
  assert(getParent() && "Not embedded in a basic block!");
  return getParent()->remove_instr(this);
}

void MachineInstr::eraseFromParent() {
  assert(getParent() && "Not embedded in a basic block!");
  getParent()->erase(this);
}

void MachineInstr::eraseFromParentAndMarkDBGValuesForRemoval() {
  assert(getParent() && "Not embedded in a basic block!");
  MachineBasicBlock *MBB = getParent();
  MachineFunction *MF = MBB->getParent();
  assert(MF && "Not embedded in a function!");

  MachineInstr *MI = (MachineInstr *)this;
  MachineRegisterInfo &MRI = MF->getRegInfo();

  for (const MachineOperand &MO : MI->operands()) {
    if (!MO.isReg() || !MO.isDef())
      continue;
    unsigned Reg = MO.getReg();
    if (!TargetRegisterInfo::isVirtualRegister(Reg))
      continue;
    MRI.markUsesInDebugValueAsUndef(Reg);
  }
  MI->eraseFromParent();
}

void MachineInstr::eraseFromBundle() {
  assert(getParent() && "Not embedded in a basic block!");
  getParent()->erase_instr(this);
}

/// getNumExplicitOperands - Returns the number of non-implicit operands.
///
unsigned MachineInstr::getNumExplicitOperands() const {
  unsigned NumOperands = MCID->getNumOperands();
  if (!MCID->isVariadic())
    return NumOperands;

  for (unsigned i = NumOperands, e = getNumOperands(); i != e; ++i) {
    const MachineOperand &MO = getOperand(i);
    if (!MO.isReg() || !MO.isImplicit())
      NumOperands++;
  }
  return NumOperands;
}

void MachineInstr::bundleWithPred() {
  assert(!isBundledWithPred() && "MI is already bundled with its predecessor");
  setFlag(BundledPred);
  MachineBasicBlock::instr_iterator Pred = getIterator();
  --Pred;
  assert(!Pred->isBundledWithSucc() && "Inconsistent bundle flags");
  Pred->setFlag(BundledSucc);
}

void MachineInstr::bundleWithSucc() {
  assert(!isBundledWithSucc() && "MI is already bundled with its successor");
  setFlag(BundledSucc);
  MachineBasicBlock::instr_iterator Succ = getIterator();
  ++Succ;
  assert(!Succ->isBundledWithPred() && "Inconsistent bundle flags");
  Succ->setFlag(BundledPred);
}

void MachineInstr::unbundleFromPred() {
  assert(isBundledWithPred() && "MI isn't bundled with its predecessor");
  clearFlag(BundledPred);
  MachineBasicBlock::instr_iterator Pred = getIterator();
  --Pred;
  assert(Pred->isBundledWithSucc() && "Inconsistent bundle flags");
  Pred->clearFlag(BundledSucc);
}

void MachineInstr::unbundleFromSucc() {
  assert(isBundledWithSucc() && "MI isn't bundled with its successor");
  clearFlag(BundledSucc);
  MachineBasicBlock::instr_iterator Succ = getIterator();
  ++Succ;
  assert(Succ->isBundledWithPred() && "Inconsistent bundle flags");
  Succ->clearFlag(BundledPred);
}

bool MachineInstr::isStackAligningInlineAsm() const {
  if (isInlineAsm()) {
    unsigned ExtraInfo = getOperand(InlineAsm::MIOp_ExtraInfo).getImm();
    if (ExtraInfo & InlineAsm::Extra_IsAlignStack)
      return true;
  }
  return false;
}

InlineAsm::AsmDialect MachineInstr::getInlineAsmDialect() const {
  assert(isInlineAsm() && "getInlineAsmDialect() only works for inline asms!");
  unsigned ExtraInfo = getOperand(InlineAsm::MIOp_ExtraInfo).getImm();
  return InlineAsm::AsmDialect((ExtraInfo & InlineAsm::Extra_AsmDialect) != 0);
}

int MachineInstr::findInlineAsmFlagIdx(unsigned OpIdx,
                                       unsigned *GroupNo) const {
  assert(isInlineAsm() && "Expected an inline asm instruction");
  assert(OpIdx < getNumOperands() && "OpIdx out of range");

  // Ignore queries about the initial operands.
  if (OpIdx < InlineAsm::MIOp_FirstOperand)
    return -1;

  unsigned Group = 0;
  unsigned NumOps;
  for (unsigned i = InlineAsm::MIOp_FirstOperand, e = getNumOperands(); i < e;
       i += NumOps) {
    const MachineOperand &FlagMO = getOperand(i);
    // If we reach the implicit register operands, stop looking.
    if (!FlagMO.isImm())
      return -1;
    NumOps = 1 + InlineAsm::getNumOperandRegisters(FlagMO.getImm());
    if (i + NumOps > OpIdx) {
      if (GroupNo)
        *GroupNo = Group;
      return i;
    }
    ++Group;
  }
  return -1;
}

const DILocalVariable *MachineInstr::getDebugVariable() const {
  assert(isDebugValue() && "not a DBG_VALUE");
  return cast<DILocalVariable>(getOperand(2).getMetadata());
}

const DIExpression *MachineInstr::getDebugExpression() const {
  assert(isDebugValue() && "not a DBG_VALUE");
  return cast<DIExpression>(getOperand(3).getMetadata());
}

const TargetRegisterClass*
MachineInstr::getRegClassConstraint(unsigned OpIdx,
                                    const TargetInstrInfo *TII,
                                    const TargetRegisterInfo *TRI) const {
  assert(getParent() && "Can't have an MBB reference here!");
  assert(getParent()->getParent() && "Can't have an MF reference here!");
  const MachineFunction &MF = *getParent()->getParent();

  // Most opcodes have fixed constraints in their MCInstrDesc.
  if (!isInlineAsm())
    return TII->getRegClass(getDesc(), OpIdx, TRI, MF);

  if (!getOperand(OpIdx).isReg())
    return nullptr;

  // For tied uses on inline asm, get the constraint from the def.
  unsigned DefIdx;
  if (getOperand(OpIdx).isUse() && isRegTiedToDefOperand(OpIdx, &DefIdx))
    OpIdx = DefIdx;

  // Inline asm stores register class constraints in the flag word.
  int FlagIdx = findInlineAsmFlagIdx(OpIdx);
  if (FlagIdx < 0)
    return nullptr;

  unsigned Flag = getOperand(FlagIdx).getImm();
  unsigned RCID;
  if ((InlineAsm::getKind(Flag) == InlineAsm::Kind_RegUse ||
       InlineAsm::getKind(Flag) == InlineAsm::Kind_RegDef ||
       InlineAsm::getKind(Flag) == InlineAsm::Kind_RegDefEarlyClobber) &&
      InlineAsm::hasRegClassConstraint(Flag, RCID))
    return TRI->getRegClass(RCID);

  // Assume that all registers in a memory operand are pointers.
  if (InlineAsm::getKind(Flag) == InlineAsm::Kind_Mem)
    return TRI->getPointerRegClass(MF);

  return nullptr;
}

const TargetRegisterClass *MachineInstr::getRegClassConstraintEffectForVReg(
    unsigned Reg, const TargetRegisterClass *CurRC, const TargetInstrInfo *TII,
    const TargetRegisterInfo *TRI, bool ExploreBundle) const {
  // Check every operands inside the bundle if we have
  // been asked to.
  if (ExploreBundle)
    for (ConstMIBundleOperands OpndIt(*this); OpndIt.isValid() && CurRC;
         ++OpndIt)
      CurRC = OpndIt->getParent()->getRegClassConstraintEffectForVRegImpl(
          OpndIt.getOperandNo(), Reg, CurRC, TII, TRI);
  else
    // Otherwise, just check the current operands.
    for (unsigned i = 0, e = NumOperands; i < e && CurRC; ++i)
      CurRC = getRegClassConstraintEffectForVRegImpl(i, Reg, CurRC, TII, TRI);
  return CurRC;
}

const TargetRegisterClass *MachineInstr::getRegClassConstraintEffectForVRegImpl(
    unsigned OpIdx, unsigned Reg, const TargetRegisterClass *CurRC,
    const TargetInstrInfo *TII, const TargetRegisterInfo *TRI) const {
  assert(CurRC && "Invalid initial register class");
  // Check if Reg is constrained by some of its use/def from MI.
  const MachineOperand &MO = getOperand(OpIdx);
  if (!MO.isReg() || MO.getReg() != Reg)
    return CurRC;
  // If yes, accumulate the constraints through the operand.
  return getRegClassConstraintEffect(OpIdx, CurRC, TII, TRI);
}

const TargetRegisterClass *MachineInstr::getRegClassConstraintEffect(
    unsigned OpIdx, const TargetRegisterClass *CurRC,
    const TargetInstrInfo *TII, const TargetRegisterInfo *TRI) const {
  const TargetRegisterClass *OpRC = getRegClassConstraint(OpIdx, TII, TRI);
  const MachineOperand &MO = getOperand(OpIdx);
  assert(MO.isReg() &&
         "Cannot get register constraints for non-register operand");
  assert(CurRC && "Invalid initial register class");
  if (unsigned SubIdx = MO.getSubReg()) {
    if (OpRC)
      CurRC = TRI->getMatchingSuperRegClass(CurRC, OpRC, SubIdx);
    else
      CurRC = TRI->getSubClassWithSubReg(CurRC, SubIdx);
  } else if (OpRC)
    CurRC = TRI->getCommonSubClass(CurRC, OpRC);
  return CurRC;
}

/// Return the number of instructions inside the MI bundle, not counting the
/// header instruction.
unsigned MachineInstr::getBundleSize() const {
  MachineBasicBlock::const_instr_iterator I = getIterator();
  unsigned Size = 0;
  while (I->isBundledWithSucc()) {
    ++Size;
    ++I;
  }
  return Size;
}

/// Returns true if the MachineInstr has an implicit-use operand of exactly
/// the given register (not considering sub/super-registers).
bool MachineInstr::hasRegisterImplicitUseOperand(unsigned Reg) const {
  for (unsigned i = 0, e = getNumOperands(); i != e; ++i) {
    const MachineOperand &MO = getOperand(i);
    if (MO.isReg() && MO.isUse() && MO.isImplicit() && MO.getReg() == Reg)
      return true;
  }
  return false;
}

/// findRegisterUseOperandIdx() - Returns the MachineOperand that is a use of
/// the specific register or -1 if it is not found. It further tightens
/// the search criteria to a use that kills the register if isKill is true.
int MachineInstr::findRegisterUseOperandIdx(
    unsigned Reg, bool isKill, const TargetRegisterInfo *TRI) const {
  for (unsigned i = 0, e = getNumOperands(); i != e; ++i) {
    const MachineOperand &MO = getOperand(i);
    if (!MO.isReg() || !MO.isUse())
      continue;
    unsigned MOReg = MO.getReg();
    if (!MOReg)
      continue;
    if (MOReg == Reg || (TRI && TargetRegisterInfo::isPhysicalRegister(MOReg) &&
                         TargetRegisterInfo::isPhysicalRegister(Reg) &&
                         TRI->isSubRegister(MOReg, Reg)))
      if (!isKill || MO.isKill())
        return i;
  }
  return -1;
}

/// readsWritesVirtualRegister - Return a pair of bools (reads, writes)
/// indicating if this instruction reads or writes Reg. This also considers
/// partial defines.
std::pair<bool,bool>
MachineInstr::readsWritesVirtualRegister(unsigned Reg,
                                         SmallVectorImpl<unsigned> *Ops) const {
  bool PartDef = false; // Partial redefine.
  bool FullDef = false; // Full define.
  bool Use = false;

  for (unsigned i = 0, e = getNumOperands(); i != e; ++i) {
    const MachineOperand &MO = getOperand(i);
    if (!MO.isReg() || MO.getReg() != Reg)
      continue;
    if (Ops)
      Ops->push_back(i);
    if (MO.isUse())
      Use |= !MO.isUndef();
    else if (MO.getSubReg() && !MO.isUndef())
      // A partial <def,undef> doesn't count as reading the register.
      PartDef = true;
    else
      FullDef = true;
  }
  // A partial redefine uses Reg unless there is also a full define.
  return std::make_pair(Use || (PartDef && !FullDef), PartDef || FullDef);
}

/// findRegisterDefOperandIdx() - Returns the operand index that is a def of
/// the specified register or -1 if it is not found. If isDead is true, defs
/// that are not dead are skipped. If TargetRegisterInfo is non-null, then it
/// also checks if there is a def of a super-register.
int
MachineInstr::findRegisterDefOperandIdx(unsigned Reg, bool isDead, bool Overlap,
                                        const TargetRegisterInfo *TRI) const {
  bool isPhys = TargetRegisterInfo::isPhysicalRegister(Reg);
  for (unsigned i = 0, e = getNumOperands(); i != e; ++i) {
    const MachineOperand &MO = getOperand(i);
    // Accept regmask operands when Overlap is set.
    // Ignore them when looking for a specific def operand (Overlap == false).
    if (isPhys && Overlap && MO.isRegMask() && MO.clobbersPhysReg(Reg))
      return i;
    if (!MO.isReg() || !MO.isDef())
      continue;
    unsigned MOReg = MO.getReg();
    bool Found = (MOReg == Reg);
    if (!Found && TRI && isPhys &&
        TargetRegisterInfo::isPhysicalRegister(MOReg)) {
      if (Overlap)
        Found = TRI->regsOverlap(MOReg, Reg);
      else
        Found = TRI->isSubRegister(MOReg, Reg);
    }
    if (Found && (!isDead || MO.isDead()))
      return i;
  }
  return -1;
}

/// findFirstPredOperandIdx() - Find the index of the first operand in the
/// operand list that is used to represent the predicate. It returns -1 if
/// none is found.
int MachineInstr::findFirstPredOperandIdx() const {
  // Don't call MCID.findFirstPredOperandIdx() because this variant
  // is sometimes called on an instruction that's not yet complete, and
  // so the number of operands is less than the MCID indicates. In
  // particular, the PTX target does this.
  const MCInstrDesc &MCID = getDesc();
  if (MCID.isPredicable()) {
    for (unsigned i = 0, e = getNumOperands(); i != e; ++i)
      if (MCID.OpInfo[i].isPredicate())
        return i;
  }

  return -1;
}

// MachineOperand::TiedTo is 4 bits wide.
const unsigned TiedMax = 15;

/// tieOperands - Mark operands at DefIdx and UseIdx as tied to each other.
///
/// Use and def operands can be tied together, indicated by a non-zero TiedTo
/// field. TiedTo can have these values:
///
/// 0:              Operand is not tied to anything.
/// 1 to TiedMax-1: Tied to getOperand(TiedTo-1).
/// TiedMax:        Tied to an operand >= TiedMax-1.
///
/// The tied def must be one of the first TiedMax operands on a normal
/// instruction. INLINEASM instructions allow more tied defs.
///
void MachineInstr::tieOperands(unsigned DefIdx, unsigned UseIdx) {
  MachineOperand &DefMO = getOperand(DefIdx);
  MachineOperand &UseMO = getOperand(UseIdx);
  assert(DefMO.isDef() && "DefIdx must be a def operand");
  assert(UseMO.isUse() && "UseIdx must be a use operand");
  assert(!DefMO.isTied() && "Def is already tied to another use");
  assert(!UseMO.isTied() && "Use is already tied to another def");

  if (DefIdx < TiedMax)
    UseMO.TiedTo = DefIdx + 1;
  else {
    // Inline asm can use the group descriptors to find tied operands, but on
    // normal instruction, the tied def must be within the first TiedMax
    // operands.
    assert(isInlineAsm() && "DefIdx out of range");
    UseMO.TiedTo = TiedMax;
  }

  // UseIdx can be out of range, we'll search for it in findTiedOperandIdx().
  DefMO.TiedTo = std::min(UseIdx + 1, TiedMax);
}

/// Given the index of a tied register operand, find the operand it is tied to.
/// Defs are tied to uses and vice versa. Returns the index of the tied operand
/// which must exist.
unsigned MachineInstr::findTiedOperandIdx(unsigned OpIdx) const {
  const MachineOperand &MO = getOperand(OpIdx);
  assert(MO.isTied() && "Operand isn't tied");

  // Normally TiedTo is in range.
  if (MO.TiedTo < TiedMax)
    return MO.TiedTo - 1;

  // Uses on normal instructions can be out of range.
  if (!isInlineAsm()) {
    // Normal tied defs must be in the 0..TiedMax-1 range.
    if (MO.isUse())
      return TiedMax - 1;
    // MO is a def. Search for the tied use.
    for (unsigned i = TiedMax - 1, e = getNumOperands(); i != e; ++i) {
      const MachineOperand &UseMO = getOperand(i);
      if (UseMO.isReg() && UseMO.isUse() && UseMO.TiedTo == OpIdx + 1)
        return i;
    }
    llvm_unreachable("Can't find tied use");
  }

  // Now deal with inline asm by parsing the operand group descriptor flags.
  // Find the beginning of each operand group.
  SmallVector<unsigned, 8> GroupIdx;
  unsigned OpIdxGroup = ~0u;
  unsigned NumOps;
  for (unsigned i = InlineAsm::MIOp_FirstOperand, e = getNumOperands(); i < e;
       i += NumOps) {
    const MachineOperand &FlagMO = getOperand(i);
    assert(FlagMO.isImm() && "Invalid tied operand on inline asm");
    unsigned CurGroup = GroupIdx.size();
    GroupIdx.push_back(i);
    NumOps = 1 + InlineAsm::getNumOperandRegisters(FlagMO.getImm());
    // OpIdx belongs to this operand group.
    if (OpIdx > i && OpIdx < i + NumOps)
      OpIdxGroup = CurGroup;
    unsigned TiedGroup;
    if (!InlineAsm::isUseOperandTiedToDef(FlagMO.getImm(), TiedGroup))
      continue;
    // Operands in this group are tied to operands in TiedGroup which must be
    // earlier. Find the number of operands between the two groups.
    unsigned Delta = i - GroupIdx[TiedGroup];

    // OpIdx is a use tied to TiedGroup.
    if (OpIdxGroup == CurGroup)
      return OpIdx - Delta;

    // OpIdx is a def tied to this use group.
    if (OpIdxGroup == TiedGroup)
      return OpIdx + Delta;
  }
  llvm_unreachable("Invalid tied operand on inline asm");
}

/// clearKillInfo - Clears kill flags on all operands.
///
void MachineInstr::clearKillInfo() {
  for (MachineOperand &MO : operands()) {
    if (MO.isReg() && MO.isUse())
      MO.setIsKill(false);
  }
}

void MachineInstr::substituteRegister(unsigned FromReg,
                                      unsigned ToReg,
                                      unsigned SubIdx,
                                      const TargetRegisterInfo &RegInfo) {
  if (TargetRegisterInfo::isPhysicalRegister(ToReg)) {
    if (SubIdx)
      ToReg = RegInfo.getSubReg(ToReg, SubIdx);
    for (MachineOperand &MO : operands()) {
      if (!MO.isReg() || MO.getReg() != FromReg)
        continue;
      MO.substPhysReg(ToReg, RegInfo);
    }
  } else {
    for (MachineOperand &MO : operands()) {
      if (!MO.isReg() || MO.getReg() != FromReg)
        continue;
      MO.substVirtReg(ToReg, SubIdx, RegInfo);
    }
  }
}

/// isSafeToMove - Return true if it is safe to move this instruction. If
/// SawStore is set to true, it means that there is a store (or call) between
/// the instruction's location and its intended destination.
bool MachineInstr::isSafeToMove(AliasAnalysis *AA, bool &SawStore) const {
  // Ignore stuff that we obviously can't move.
  //
  // Treat volatile loads as stores. This is not strictly necessary for
  // volatiles, but it is required for atomic loads. It is not allowed to move
  // a load across an atomic load with Ordering > Monotonic.
  if (mayStore() || isCall() ||
      (mayLoad() && hasOrderedMemoryRef())) {
    SawStore = true;
    return false;
  }

  if (isPosition() || isDebugValue() || isTerminator() ||
      hasUnmodeledSideEffects())
    return false;

  // See if this instruction does a load.  If so, we have to guarantee that the
  // loaded value doesn't change between the load and the its intended
  // destination. The check for isInvariantLoad gives the targe the chance to
  // classify the load as always returning a constant, e.g. a constant pool
  // load.
  if (mayLoad() && !isDereferenceableInvariantLoad(AA))
    // Otherwise, this is a real load.  If there is a store between the load and
    // end of block, we can't move it.
    return !SawStore;

  return true;
}

bool MachineInstr::mayAlias(AliasAnalysis *AA, MachineInstr &Other,
                            bool UseTBAA) {
  const MachineFunction *MF = getParent()->getParent();
  const TargetInstrInfo *TII = MF->getSubtarget().getInstrInfo();
  const MachineFrameInfo &MFI = MF->getFrameInfo();

  // If neither instruction stores to memory, they can't alias in any
  // meaningful way, even if they read from the same address.
  if (!mayStore() && !Other.mayStore())
    return false;

  // Let the target decide if memory accesses cannot possibly overlap.
  if (TII->areMemAccessesTriviallyDisjoint(*this, Other, AA))
    return false;

  // FIXME: Need to handle multiple memory operands to support all targets.
  if (!hasOneMemOperand() || !Other.hasOneMemOperand())
    return true;

  MachineMemOperand *MMOa = *memoperands_begin();
  MachineMemOperand *MMOb = *Other.memoperands_begin();

  // The following interface to AA is fashioned after DAGCombiner::isAlias
  // and operates with MachineMemOperand offset with some important
  // assumptions:
  //   - LLVM fundamentally assumes flat address spaces.
  //   - MachineOperand offset can *only* result from legalization and
  //     cannot affect queries other than the trivial case of overlap
  //     checking.
  //   - These offsets never wrap and never step outside
  //     of allocated objects.
  //   - There should never be any negative offsets here.
  //
  // FIXME: Modify API to hide this math from "user"
  // Even before we go to AA we can reason locally about some
  // memory objects. It can save compile time, and possibly catch some
  // corner cases not currently covered.

  int64_t OffsetA = MMOa->getOffset();
  int64_t OffsetB = MMOb->getOffset();

  int64_t MinOffset = std::min(OffsetA, OffsetB);
  int64_t WidthA = MMOa->getSize();
  int64_t WidthB = MMOb->getSize();
  const Value *ValA = MMOa->getValue();
  const Value *ValB = MMOb->getValue();
  bool SameVal = (ValA && ValB && (ValA == ValB));
  if (!SameVal) {
    const PseudoSourceValue *PSVa = MMOa->getPseudoValue();
    const PseudoSourceValue *PSVb = MMOb->getPseudoValue();
    if (PSVa && ValB && !PSVa->mayAlias(&MFI))
      return false;
    if (PSVb && ValA && !PSVb->mayAlias(&MFI))
      return false;
    if (PSVa && PSVb && (PSVa == PSVb))
      SameVal = true;
  }

  if (SameVal) {
    int64_t MaxOffset = std::max(OffsetA, OffsetB);
    int64_t LowWidth = (MinOffset == OffsetA) ? WidthA : WidthB;
    return (MinOffset + LowWidth > MaxOffset);
  }

  if (!AA)
    return true;

  if (!ValA || !ValB)
    return true;

  assert((OffsetA >= 0) && "Negative MachineMemOperand offset");
  assert((OffsetB >= 0) && "Negative MachineMemOperand offset");

  int64_t Overlapa = WidthA + OffsetA - MinOffset;
  int64_t Overlapb = WidthB + OffsetB - MinOffset;

  AliasResult AAResult = AA->alias(
      MemoryLocation(ValA, Overlapa,
                     UseTBAA ? MMOa->getAAInfo() : AAMDNodes()),
      MemoryLocation(ValB, Overlapb,
                     UseTBAA ? MMOb->getAAInfo() : AAMDNodes()));

  return (AAResult != NoAlias);
}

/// hasOrderedMemoryRef - Return true if this instruction may have an ordered
/// or volatile memory reference, or if the information describing the memory
/// reference is not available. Return false if it is known to have no ordered
/// memory references.
bool MachineInstr::hasOrderedMemoryRef() const {
  // An instruction known never to access memory won't have a volatile access.
  if (!mayStore() &&
      !mayLoad() &&
      !isCall() &&
      !hasUnmodeledSideEffects())
    return false;

  // Otherwise, if the instruction has no memory reference information,
  // conservatively assume it wasn't preserved.
  if (memoperands_empty())
    return true;

  // Check if any of our memory operands are ordered.
  return llvm::any_of(memoperands(), [](const MachineMemOperand *MMO) {
    return !MMO->isUnordered();
  });
}

/// isDereferenceableInvariantLoad - Return true if this instruction will never
/// trap and is loading from a location whose value is invariant across a run of
/// this function.
bool MachineInstr::isDereferenceableInvariantLoad(AliasAnalysis *AA) const {
  // If the instruction doesn't load at all, it isn't an invariant load.
  if (!mayLoad())
    return false;

  // If the instruction has lost its memoperands, conservatively assume that
  // it may not be an invariant load.
  if (memoperands_empty())
    return false;

  const MachineFrameInfo &MFI = getParent()->getParent()->getFrameInfo();

  for (MachineMemOperand *MMO : memoperands()) {
    if (MMO->isVolatile()) return false;
    if (MMO->isStore()) return false;
    if (MMO->isInvariant() && MMO->isDereferenceable())
      continue;

    // A load from a constant PseudoSourceValue is invariant.
    if (const PseudoSourceValue *PSV = MMO->getPseudoValue())
      if (PSV->isConstant(&MFI))
        continue;

    if (const Value *V = MMO->getValue()) {
      // If we have an AliasAnalysis, ask it whether the memory is constant.
      if (AA &&
          AA->pointsToConstantMemory(
              MemoryLocation(V, MMO->getSize(), MMO->getAAInfo())))
        continue;
    }

    // Otherwise assume conservatively.
    return false;
  }

  // Everything checks out.
  return true;
}

/// isConstantValuePHI - If the specified instruction is a PHI that always
/// merges together the same virtual register, return the register, otherwise
/// return 0.
unsigned MachineInstr::isConstantValuePHI() const {
  if (!isPHI())
    return 0;
  assert(getNumOperands() >= 3 &&
         "It's illegal to have a PHI without source operands");

  unsigned Reg = getOperand(1).getReg();
  for (unsigned i = 3, e = getNumOperands(); i < e; i += 2)
    if (getOperand(i).getReg() != Reg)
      return 0;
  return Reg;
}

bool MachineInstr::hasUnmodeledSideEffects() const {
  if (hasProperty(MCID::UnmodeledSideEffects))
    return true;
  if (isInlineAsm()) {
    unsigned ExtraInfo = getOperand(InlineAsm::MIOp_ExtraInfo).getImm();
    if (ExtraInfo & InlineAsm::Extra_HasSideEffects)
      return true;
  }

  return false;
}

bool MachineInstr::isLoadFoldBarrier() const {
  return mayStore() || isCall() || hasUnmodeledSideEffects();
}

/// allDefsAreDead - Return true if all the defs of this instruction are dead.
///
bool MachineInstr::allDefsAreDead() const {
  for (const MachineOperand &MO : operands()) {
    if (!MO.isReg() || MO.isUse())
      continue;
    if (!MO.isDead())
      return false;
  }
  return true;
}

/// copyImplicitOps - Copy implicit register operands from specified
/// instruction to this instruction.
void MachineInstr::copyImplicitOps(MachineFunction &MF,
                                   const MachineInstr &MI) {
  for (unsigned i = MI.getDesc().getNumOperands(), e = MI.getNumOperands();
       i != e; ++i) {
    const MachineOperand &MO = MI.getOperand(i);
    if ((MO.isReg() && MO.isImplicit()) || MO.isRegMask())
      addOperand(MF, MO);
  }
}

#if !defined(NDEBUG) || defined(LLVM_ENABLE_DUMP)
LLVM_DUMP_METHOD void MachineInstr::dump() const {
  dbgs() << "  ";
  print(dbgs());
}
#endif

void MachineInstr::print(raw_ostream &OS, bool SkipOpers, bool SkipDebugLoc,
                         const TargetInstrInfo *TII) const {
  const Module *M = nullptr;
  if (const MachineBasicBlock *MBB = getParent())
    if (const MachineFunction *MF = MBB->getParent())
      M = MF->getFunction()->getParent();

  ModuleSlotTracker MST(M);
  print(OS, MST, SkipOpers, SkipDebugLoc, TII);
}

void MachineInstr::print(raw_ostream &OS, ModuleSlotTracker &MST,
                         bool SkipOpers, bool SkipDebugLoc,
                         const TargetInstrInfo *TII) const {
  // We can be a bit tidier if we know the MachineFunction.
  const MachineFunction *MF = nullptr;
  const TargetRegisterInfo *TRI = nullptr;
  const MachineRegisterInfo *MRI = nullptr;
  const TargetIntrinsicInfo *IntrinsicInfo = nullptr;

  if (const MachineBasicBlock *MBB = getParent()) {
    MF = MBB->getParent();
    if (MF) {
      MRI = &MF->getRegInfo();
      TRI = MF->getSubtarget().getRegisterInfo();
      if (!TII)
        TII = MF->getSubtarget().getInstrInfo();
      IntrinsicInfo = MF->getTarget().getIntrinsicInfo();
    }
  }

  // Save a list of virtual registers.
  SmallVector<unsigned, 8> VirtRegs;

  // Print explicitly defined operands on the left of an assignment syntax.
  unsigned StartOp = 0, e = getNumOperands();
  for (; StartOp < e && getOperand(StartOp).isReg() &&
         getOperand(StartOp).isDef() &&
         !getOperand(StartOp).isImplicit();
       ++StartOp) {
    if (StartOp != 0) OS << ", ";
    getOperand(StartOp).print(OS, MST, TRI, IntrinsicInfo);
    unsigned Reg = getOperand(StartOp).getReg();
    if (TargetRegisterInfo::isVirtualRegister(Reg)) {
      VirtRegs.push_back(Reg);
      LLT Ty = MRI ? MRI->getType(Reg) : LLT{};
      if (Ty.isValid())
        OS << '(' << Ty << ')';
    }
  }

  if (StartOp != 0)
    OS << " = ";

  // Print the opcode name.
  if (TII)
    OS << TII->getName(getOpcode());
  else
    OS << "UNKNOWN";

  if (SkipOpers)
    return;

  // Print the rest of the operands.
  bool FirstOp = true;
  unsigned AsmDescOp = ~0u;
  unsigned AsmOpCount = 0;

  if (isInlineAsm() && e >= InlineAsm::MIOp_FirstOperand) {
    // Print asm string.
    OS << " ";
    getOperand(InlineAsm::MIOp_AsmString).print(OS, MST, TRI);

    // Print HasSideEffects, MayLoad, MayStore, IsAlignStack
    unsigned ExtraInfo = getOperand(InlineAsm::MIOp_ExtraInfo).getImm();
    if (ExtraInfo & InlineAsm::Extra_HasSideEffects)
      OS << " [sideeffect]";
    if (ExtraInfo & InlineAsm::Extra_MayLoad)
      OS << " [mayload]";
    if (ExtraInfo & InlineAsm::Extra_MayStore)
      OS << " [maystore]";
    if (ExtraInfo & InlineAsm::Extra_IsConvergent)
      OS << " [isconvergent]";
    if (ExtraInfo & InlineAsm::Extra_IsAlignStack)
      OS << " [alignstack]";
    if (getInlineAsmDialect() == InlineAsm::AD_ATT)
      OS << " [attdialect]";
    if (getInlineAsmDialect() == InlineAsm::AD_Intel)
      OS << " [inteldialect]";

    StartOp = AsmDescOp = InlineAsm::MIOp_FirstOperand;
    FirstOp = false;
  }

  for (unsigned i = StartOp, e = getNumOperands(); i != e; ++i) {
    const MachineOperand &MO = getOperand(i);

    if (MO.isReg() && TargetRegisterInfo::isVirtualRegister(MO.getReg()))
      VirtRegs.push_back(MO.getReg());

    if (FirstOp) FirstOp = false; else OS << ",";
    OS << " ";
    if (i < getDesc().NumOperands) {
      const MCOperandInfo &MCOI = getDesc().OpInfo[i];
      if (MCOI.isPredicate())
        OS << "pred:";
      if (MCOI.isOptionalDef())
        OS << "opt:";
    }
    if (isDebugValue() && MO.isMetadata()) {
      // Pretty print DBG_VALUE instructions.
      auto *DIV = dyn_cast<DILocalVariable>(MO.getMetadata());
      if (DIV && !DIV->getName().empty())
        OS << "!\"" << DIV->getName() << '\"';
      else
        MO.print(OS, MST, TRI);
    } else if (TRI && (isInsertSubreg() || isRegSequence() ||
                       (isSubregToReg() && i == 3)) && MO.isImm()) {
      OS << TRI->getSubRegIndexName(MO.getImm());
    } else if (i == AsmDescOp && MO.isImm()) {
      // Pretty print the inline asm operand descriptor.
      OS << '$' << AsmOpCount++;
      unsigned Flag = MO.getImm();
      switch (InlineAsm::getKind(Flag)) {
      case InlineAsm::Kind_RegUse:             OS << ":[reguse"; break;
      case InlineAsm::Kind_RegDef:             OS << ":[regdef"; break;
      case InlineAsm::Kind_RegDefEarlyClobber: OS << ":[regdef-ec"; break;
      case InlineAsm::Kind_Clobber:            OS << ":[clobber"; break;
      case InlineAsm::Kind_Imm:                OS << ":[imm"; break;
      case InlineAsm::Kind_Mem:                OS << ":[mem"; break;
      default: OS << ":[??" << InlineAsm::getKind(Flag); break;
      }

      unsigned RCID = 0;
      if (!InlineAsm::isImmKind(Flag) && !InlineAsm::isMemKind(Flag) &&
          InlineAsm::hasRegClassConstraint(Flag, RCID)) {
        if (TRI) {
          OS << ':' << TRI->getRegClassName(TRI->getRegClass(RCID));
        } else
          OS << ":RC" << RCID;
      }

      if (InlineAsm::isMemKind(Flag)) {
        unsigned MCID = InlineAsm::getMemoryConstraintID(Flag);
        switch (MCID) {
        case InlineAsm::Constraint_es: OS << ":es"; break;
        case InlineAsm::Constraint_i:  OS << ":i"; break;
        case InlineAsm::Constraint_m:  OS << ":m"; break;
        case InlineAsm::Constraint_o:  OS << ":o"; break;
        case InlineAsm::Constraint_v:  OS << ":v"; break;
        case InlineAsm::Constraint_Q:  OS << ":Q"; break;
        case InlineAsm::Constraint_R:  OS << ":R"; break;
        case InlineAsm::Constraint_S:  OS << ":S"; break;
        case InlineAsm::Constraint_T:  OS << ":T"; break;
        case InlineAsm::Constraint_Um: OS << ":Um"; break;
        case InlineAsm::Constraint_Un: OS << ":Un"; break;
        case InlineAsm::Constraint_Uq: OS << ":Uq"; break;
        case InlineAsm::Constraint_Us: OS << ":Us"; break;
        case InlineAsm::Constraint_Ut: OS << ":Ut"; break;
        case InlineAsm::Constraint_Uv: OS << ":Uv"; break;
        case InlineAsm::Constraint_Uy: OS << ":Uy"; break;
        case InlineAsm::Constraint_X:  OS << ":X"; break;
        case InlineAsm::Constraint_Z:  OS << ":Z"; break;
        case InlineAsm::Constraint_ZC: OS << ":ZC"; break;
        case InlineAsm::Constraint_Zy: OS << ":Zy"; break;
        default: OS << ":?"; break;
        }
      }

      unsigned TiedTo = 0;
      if (InlineAsm::isUseOperandTiedToDef(Flag, TiedTo))
        OS << " tiedto:$" << TiedTo;

      OS << ']';

      // Compute the index of the next operand descriptor.
      AsmDescOp += 1 + InlineAsm::getNumOperandRegisters(Flag);
    } else
      MO.print(OS, MST, TRI);
  }

  bool HaveSemi = false;
  const unsigned PrintableFlags = FrameSetup | FrameDestroy;
  if (Flags & PrintableFlags) {
    if (!HaveSemi) {
      OS << ";";
      HaveSemi = true;
    }
    OS << " flags: ";

    if (Flags & FrameSetup)
      OS << "FrameSetup";

    if (Flags & FrameDestroy)
      OS << "FrameDestroy";
  }

  if (!memoperands_empty()) {
    if (!HaveSemi) {
      OS << ";";
      HaveSemi = true;
    }

    OS << " mem:";
    for (mmo_iterator i = memoperands_begin(), e = memoperands_end();
         i != e; ++i) {
      (*i)->print(OS, MST);
      if (std::next(i) != e)
        OS << " ";
    }
  }

  // Print the regclass of any virtual registers encountered.
  if (MRI && !VirtRegs.empty()) {
    if (!HaveSemi) {
      OS << ";";
      HaveSemi = true;
    }
    for (unsigned i = 0; i != VirtRegs.size(); ++i) {
      const RegClassOrRegBank &RC = MRI->getRegClassOrRegBank(VirtRegs[i]);
      if (!RC)
        continue;
      // Generic virtual registers do not have register classes.
      if (RC.is<const RegisterBank *>())
        OS << " " << RC.get<const RegisterBank *>()->getName();
      else
        OS << " "
           << TRI->getRegClassName(RC.get<const TargetRegisterClass *>());
      OS << ':' << PrintReg(VirtRegs[i]);
      for (unsigned j = i+1; j != VirtRegs.size();) {
        if (MRI->getRegClassOrRegBank(VirtRegs[j]) != RC) {
          ++j;
          continue;
        }
        if (VirtRegs[i] != VirtRegs[j])
          OS << "," << PrintReg(VirtRegs[j]);
        VirtRegs.erase(VirtRegs.begin()+j);
      }
    }
  }

  // Print debug location information.
  if (isDebugValue() && getOperand(e - 2).isMetadata()) {
    if (!HaveSemi)
      OS << ";";
    auto *DV = cast<DILocalVariable>(getOperand(e - 2).getMetadata());
    OS << " line no:" <<  DV->getLine();
    if (auto *InlinedAt = debugLoc->getInlinedAt()) {
      DebugLoc InlinedAtDL(InlinedAt);
      if (InlinedAtDL && MF) {
        OS << " inlined @[ ";
        InlinedAtDL.print(OS);
        OS << " ]";
      }
    }
    if (isIndirectDebugValue())
      OS << " indirect";
  } else if (SkipDebugLoc) {
    return;
  } else if (debugLoc && MF) {
    if (!HaveSemi)
      OS << ";";
    OS << " dbg:";
    debugLoc.print(OS);
  }

  OS << '\n';
}

bool MachineInstr::addRegisterKilled(unsigned IncomingReg,
                                     const TargetRegisterInfo *RegInfo,
                                     bool AddIfNotFound) {
  bool isPhysReg = TargetRegisterInfo::isPhysicalRegister(IncomingReg);
  bool hasAliases = isPhysReg &&
    MCRegAliasIterator(IncomingReg, RegInfo, false).isValid();
  bool Found = false;
  SmallVector<unsigned,4> DeadOps;
  for (unsigned i = 0, e = getNumOperands(); i != e; ++i) {
    MachineOperand &MO = getOperand(i);
    if (!MO.isReg() || !MO.isUse() || MO.isUndef())
      continue;

    // DEBUG_VALUE nodes do not contribute to code generation and should
    // always be ignored. Failure to do so may result in trying to modify
    // KILL flags on DEBUG_VALUE nodes.
    if (MO.isDebug())
      continue;

    unsigned Reg = MO.getReg();
    if (!Reg)
      continue;

    if (Reg == IncomingReg) {
      if (!Found) {
        if (MO.isKill())
          // The register is already marked kill.
          return true;
        if (isPhysReg && isRegTiedToDefOperand(i))
          // Two-address uses of physregs must not be marked kill.
          return true;
        MO.setIsKill();
        Found = true;
      }
    } else if (hasAliases && MO.isKill() &&
               TargetRegisterInfo::isPhysicalRegister(Reg)) {
      // A super-register kill already exists.
      if (RegInfo->isSuperRegister(IncomingReg, Reg))
        return true;
      if (RegInfo->isSubRegister(IncomingReg, Reg))
        DeadOps.push_back(i);
    }
  }

  // Trim unneeded kill operands.
  while (!DeadOps.empty()) {
    unsigned OpIdx = DeadOps.back();
    if (getOperand(OpIdx).isImplicit())
      RemoveOperand(OpIdx);
    else
      getOperand(OpIdx).setIsKill(false);
    DeadOps.pop_back();
  }

  // If not found, this means an alias of one of the operands is killed. Add a
  // new implicit operand if required.
  if (!Found && AddIfNotFound) {
    addOperand(MachineOperand::CreateReg(IncomingReg,
                                         false /*IsDef*/,
                                         true  /*IsImp*/,
                                         true  /*IsKill*/));
    return true;
  }
  return Found;
}

void MachineInstr::clearRegisterKills(unsigned Reg,
                                      const TargetRegisterInfo *RegInfo) {
  if (!TargetRegisterInfo::isPhysicalRegister(Reg))
    RegInfo = nullptr;
  for (MachineOperand &MO : operands()) {
    if (!MO.isReg() || !MO.isUse() || !MO.isKill())
      continue;
    unsigned OpReg = MO.getReg();
    if ((RegInfo && RegInfo->regsOverlap(Reg, OpReg)) || Reg == OpReg)
      MO.setIsKill(false);
  }
}

bool MachineInstr::addRegisterDead(unsigned Reg,
                                   const TargetRegisterInfo *RegInfo,
                                   bool AddIfNotFound) {
  bool isPhysReg = TargetRegisterInfo::isPhysicalRegister(Reg);
  bool hasAliases = isPhysReg &&
    MCRegAliasIterator(Reg, RegInfo, false).isValid();
  bool Found = false;
  SmallVector<unsigned,4> DeadOps;
  for (unsigned i = 0, e = getNumOperands(); i != e; ++i) {
    MachineOperand &MO = getOperand(i);
    if (!MO.isReg() || !MO.isDef())
      continue;
    unsigned MOReg = MO.getReg();
    if (!MOReg)
      continue;

    if (MOReg == Reg) {
      MO.setIsDead();
      Found = true;
    } else if (hasAliases && MO.isDead() &&
               TargetRegisterInfo::isPhysicalRegister(MOReg)) {
      // There exists a super-register that's marked dead.
      if (RegInfo->isSuperRegister(Reg, MOReg))
        return true;
      if (RegInfo->isSubRegister(Reg, MOReg))
        DeadOps.push_back(i);
    }
  }

  // Trim unneeded dead operands.
  while (!DeadOps.empty()) {
    unsigned OpIdx = DeadOps.back();
    if (getOperand(OpIdx).isImplicit())
      RemoveOperand(OpIdx);
    else
      getOperand(OpIdx).setIsDead(false);
    DeadOps.pop_back();
  }

  // If not found, this means an alias of one of the operands is dead. Add a
  // new implicit operand if required.
  if (Found || !AddIfNotFound)
    return Found;

  addOperand(MachineOperand::CreateReg(Reg,
                                       true  /*IsDef*/,
                                       true  /*IsImp*/,
                                       false /*IsKill*/,
                                       true  /*IsDead*/));
  return true;
}

void MachineInstr::clearRegisterDeads(unsigned Reg) {
  for (MachineOperand &MO : operands()) {
    if (!MO.isReg() || !MO.isDef() || MO.getReg() != Reg)
      continue;
    MO.setIsDead(false);
  }
}

void MachineInstr::setRegisterDefReadUndef(unsigned Reg, bool IsUndef) {
  for (MachineOperand &MO : operands()) {
    if (!MO.isReg() || !MO.isDef() || MO.getReg() != Reg || MO.getSubReg() == 0)
      continue;
    MO.setIsUndef(IsUndef);
  }
}

void MachineInstr::addRegisterDefined(unsigned Reg,
                                      const TargetRegisterInfo *RegInfo) {
  if (TargetRegisterInfo::isPhysicalRegister(Reg)) {
    MachineOperand *MO = findRegisterDefOperand(Reg, false, RegInfo);
    if (MO)
      return;
  } else {
    for (const MachineOperand &MO : operands()) {
      if (MO.isReg() && MO.getReg() == Reg && MO.isDef() &&
          MO.getSubReg() == 0)
        return;
    }
  }
  addOperand(MachineOperand::CreateReg(Reg,
                                       true  /*IsDef*/,
                                       true  /*IsImp*/));
}

void MachineInstr::setPhysRegsDeadExcept(ArrayRef<unsigned> UsedRegs,
                                         const TargetRegisterInfo &TRI) {
  bool HasRegMask = false;
  for (MachineOperand &MO : operands()) {
    if (MO.isRegMask()) {
      HasRegMask = true;
      continue;
    }
    if (!MO.isReg() || !MO.isDef()) continue;
    unsigned Reg = MO.getReg();
    if (!TargetRegisterInfo::isPhysicalRegister(Reg)) continue;
    // If there are no uses, including partial uses, the def is dead.
    if (llvm::none_of(UsedRegs,
                      [&](unsigned Use) { return TRI.regsOverlap(Use, Reg); }))
      MO.setIsDead();
  }

  // This is a call with a register mask operand.
  // Mask clobbers are always dead, so add defs for the non-dead defines.
  if (HasRegMask)
    for (ArrayRef<unsigned>::iterator I = UsedRegs.begin(), E = UsedRegs.end();
         I != E; ++I)
      addRegisterDefined(*I, &TRI);
}

unsigned
MachineInstrExpressionTrait::getHashValue(const MachineInstr* const &MI) {
  // Build up a buffer of hash code components.
  SmallVector<size_t, 8> HashComponents;
  HashComponents.reserve(MI->getNumOperands() + 1);
  HashComponents.push_back(MI->getOpcode());
  for (const MachineOperand &MO : MI->operands()) {
    if (MO.isReg() && MO.isDef() &&
        TargetRegisterInfo::isVirtualRegister(MO.getReg()))
      continue;  // Skip virtual register defs.

    HashComponents.push_back(hash_value(MO));
  }
  return hash_combine_range(HashComponents.begin(), HashComponents.end());
}

void MachineInstr::emitError(StringRef Msg) const {
  // Find the source location cookie.
  unsigned LocCookie = 0;
  const MDNode *LocMD = nullptr;
  for (unsigned i = getNumOperands(); i != 0; --i) {
    if (getOperand(i-1).isMetadata() &&
        (LocMD = getOperand(i-1).getMetadata()) &&
        LocMD->getNumOperands() != 0) {
      if (const ConstantInt *CI =
              mdconst::dyn_extract<ConstantInt>(LocMD->getOperand(0))) {
        LocCookie = CI->getZExtValue();
        break;
      }
    }
  }

  if (const MachineBasicBlock *MBB = getParent())
    if (const MachineFunction *MF = MBB->getParent())
      return MF->getMMI().getModule()->getContext().emitError(LocCookie, Msg);
  report_fatal_error(Msg);
}

MachineInstrBuilder llvm::BuildMI(MachineFunction &MF, const DebugLoc &DL,
                                  const MCInstrDesc &MCID, bool IsIndirect,
                                  unsigned Reg, const MDNode *Variable,
                                  const MDNode *Expr) {
  assert(isa<DILocalVariable>(Variable) && "not a variable");
  assert(cast<DIExpression>(Expr)->isValid() && "not an expression");
  assert(cast<DILocalVariable>(Variable)->isValidLocationForIntrinsic(DL) &&
         "Expected inlined-at fields to agree");
  if (IsIndirect)
    return BuildMI(MF, DL, MCID)
        .addReg(Reg, RegState::Debug)
        .addImm(0U)
        .addMetadata(Variable)
        .addMetadata(Expr);
  else
    return BuildMI(MF, DL, MCID)
        .addReg(Reg, RegState::Debug)
        .addReg(0U, RegState::Debug)
        .addMetadata(Variable)
        .addMetadata(Expr);
}

MachineInstrBuilder llvm::BuildMI(MachineBasicBlock &BB,
                                  MachineBasicBlock::iterator I,
                                  const DebugLoc &DL, const MCInstrDesc &MCID,
                                  bool IsIndirect, unsigned Reg,
                                  const MDNode *Variable, const MDNode *Expr) {
  assert(isa<DILocalVariable>(Variable) && "not a variable");
  assert(cast<DIExpression>(Expr)->isValid() && "not an expression");
  MachineFunction &MF = *BB.getParent();
  MachineInstr *MI = BuildMI(MF, DL, MCID, IsIndirect, Reg, Variable, Expr);
  BB.insert(I, MI);
  return MachineInstrBuilder(MF, MI);
}

MachineInstr *llvm::buildDbgValueForSpill(MachineBasicBlock &BB,
                                          MachineBasicBlock::iterator I,
                                          const MachineInstr &Orig,
                                          int FrameIndex) {
  const MDNode *Var = Orig.getDebugVariable();
  const auto *Expr = cast_or_null<DIExpression>(Orig.getDebugExpression());
  bool IsIndirect = Orig.isIndirectDebugValue();
  if (IsIndirect)
    assert(Orig.getOperand(1).getImm() == 0 && "DBG_VALUE with nonzero offset");
  DebugLoc DL = Orig.getDebugLoc();
  assert(cast<DILocalVariable>(Var)->isValidLocationForIntrinsic(DL) &&
         "Expected inlined-at fields to agree");
  // If the DBG_VALUE already was a memory location, add an extra
  // DW_OP_deref. Otherwise just turning this from a register into a
  // memory/indirect location is sufficient.
  if (IsIndirect)
    Expr = DIExpression::prepend(Expr, DIExpression::WithDeref);
  return BuildMI(BB, I, DL, Orig.getDesc())
      .addFrameIndex(FrameIndex)
      .addImm(0U)
      .addMetadata(Var)
      .addMetadata(Expr);
}
