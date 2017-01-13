//===- AArch64RegisterBankInfo.cpp -------------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the RegisterBankInfo class for
/// AArch64.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "AArch64RegisterBankInfo.h"
#include "AArch64InstrInfo.h" // For XXXRegClassID.
#include "llvm/CodeGen/LowLevelType.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/GlobalISel/RegisterBank.h"
#include "llvm/CodeGen/GlobalISel/RegisterBankInfo.h"
#include "llvm/Target/TargetRegisterInfo.h"
#include "llvm/Target/TargetSubtargetInfo.h"

// This file will be TableGen'ed at some point.
#include "AArch64GenRegisterBankInfo.def"

using namespace llvm;

#ifndef LLVM_BUILD_GLOBAL_ISEL
#error "You shouldn't build this"
#endif

AArch64GenRegisterBankInfo::AArch64GenRegisterBankInfo()
    : RegisterBankInfo(RegBanks, AArch64::NumRegisterBanks) {}

AArch64RegisterBankInfo::AArch64RegisterBankInfo(const TargetRegisterInfo &TRI)
    : AArch64GenRegisterBankInfo() {
  static bool AlreadyInit = false;
  // We have only one set of register banks, whatever the subtarget
  // is. Therefore, the initialization of the RegBanks table should be
  // done only once. Indeed the table of all register banks
  // (AArch64::RegBanks) is unique in the compiler. At some point, it
  // will get tablegen'ed and the whole constructor becomes empty.
  if (AlreadyInit)
    return;
  AlreadyInit = true;

  const RegisterBank &RBGPR = getRegBank(AArch64::GPRRegBankID);
  (void)RBGPR;
  assert(&AArch64::GPRRegBank == &RBGPR &&
         "The order in RegBanks is messed up");

  const RegisterBank &RBFPR = getRegBank(AArch64::FPRRegBankID);
  (void)RBFPR;
  assert(&AArch64::FPRRegBank == &RBFPR &&
         "The order in RegBanks is messed up");

  const RegisterBank &RBCCR = getRegBank(AArch64::CCRRegBankID);
  (void)RBCCR;
  assert(&AArch64::CCRRegBank == &RBCCR &&
         "The order in RegBanks is messed up");

  // The GPR register bank is fully defined by all the registers in
  // GR64all + its subclasses.
  assert(RBGPR.covers(*TRI.getRegClass(AArch64::GPR32RegClassID)) &&
         "Subclass not added?");
  assert(RBGPR.getSize() == 64 && "GPRs should hold up to 64-bit");

  // The FPR register bank is fully defined by all the registers in
  // GR64all + its subclasses.
  assert(RBFPR.covers(*TRI.getRegClass(AArch64::QQRegClassID)) &&
         "Subclass not added?");
  assert(RBFPR.covers(*TRI.getRegClass(AArch64::FPR64RegClassID)) &&
         "Subclass not added?");
  assert(RBFPR.getSize() == 512 &&
         "FPRs should hold up to 512-bit via QQQQ sequence");

  assert(RBCCR.covers(*TRI.getRegClass(AArch64::CCRRegClassID)) &&
         "Class not added?");
  assert(RBCCR.getSize() == 32 && "CCR should hold up to 32-bit");

  // Check that the TableGen'ed like file is in sync we our expectations.
  // First, the Idx.
  assert(checkPartialMappingIdx(PMI_FirstGPR, PMI_LastGPR,
                                {PMI_GPR32, PMI_GPR64}) &&
         "PartialMappingIdx's are incorrectly ordered");
  assert(checkPartialMappingIdx(
             PMI_FirstFPR, PMI_LastFPR,
             {PMI_FPR32, PMI_FPR64, PMI_FPR128, PMI_FPR256, PMI_FPR512}) &&
         "PartialMappingIdx's are incorrectly ordered");
// Now, the content.
// Check partial mapping.
#define CHECK_PARTIALMAP(Idx, ValStartIdx, ValLength, RB)                      \
  do {                                                                         \
    assert(                                                                    \
        checkPartialMap(PartialMappingIdx::Idx, ValStartIdx, ValLength, RB) && \
        #Idx " is incorrectly initialized");                                   \
  } while (0)

  CHECK_PARTIALMAP(PMI_GPR32, 0, 32, RBGPR);
  CHECK_PARTIALMAP(PMI_GPR64, 0, 64, RBGPR);
  CHECK_PARTIALMAP(PMI_FPR32, 0, 32, RBFPR);
  CHECK_PARTIALMAP(PMI_FPR64, 0, 64, RBFPR);
  CHECK_PARTIALMAP(PMI_FPR128, 0, 128, RBFPR);
  CHECK_PARTIALMAP(PMI_FPR256, 0, 256, RBFPR);
  CHECK_PARTIALMAP(PMI_FPR512, 0, 512, RBFPR);

// Check value mapping.
#define CHECK_VALUEMAP_IMPL(RBName, Size, Offset)                              \
  do {                                                                         \
    assert(checkValueMapImpl(PartialMappingIdx::PMI_##RBName##Size,            \
                             PartialMappingIdx::PMI_First##RBName, Size,       \
                             Offset) &&                                        \
           #RBName #Size " " #Offset " is incorrectly initialized");           \
  } while (0)

#define CHECK_VALUEMAP(RBName, Size) CHECK_VALUEMAP_IMPL(RBName, Size, 0)

  CHECK_VALUEMAP(GPR, 32);
  CHECK_VALUEMAP(GPR, 64);
  CHECK_VALUEMAP(FPR, 32);
  CHECK_VALUEMAP(FPR, 64);
  CHECK_VALUEMAP(FPR, 128);
  CHECK_VALUEMAP(FPR, 256);
  CHECK_VALUEMAP(FPR, 512);

// Check the value mapping for 3-operands instructions where all the operands
// map to the same value mapping.
#define CHECK_VALUEMAP_3OPS(RBName, Size)                                      \
  do {                                                                         \
    CHECK_VALUEMAP_IMPL(RBName, Size, 0);                                      \
    CHECK_VALUEMAP_IMPL(RBName, Size, 1);                                      \
    CHECK_VALUEMAP_IMPL(RBName, Size, 2);                                      \
  } while (0)

  CHECK_VALUEMAP_3OPS(GPR, 32);
  CHECK_VALUEMAP_3OPS(GPR, 64);
  CHECK_VALUEMAP_3OPS(FPR, 32);
  CHECK_VALUEMAP_3OPS(FPR, 64);
  CHECK_VALUEMAP_3OPS(FPR, 128);
  CHECK_VALUEMAP_3OPS(FPR, 256);
  CHECK_VALUEMAP_3OPS(FPR, 512);

#define CHECK_VALUEMAP_CROSSREGCPY(RBNameDst, RBNameSrc, Size)                 \
  do {                                                                         \
    unsigned PartialMapDstIdx = PMI_##RBNameDst##Size - PMI_Min;               \
    unsigned PartialMapSrcIdx = PMI_##RBNameSrc##Size - PMI_Min;               \
    (void)PartialMapDstIdx;                                                    \
    (void)PartialMapSrcIdx;                                                    \
    const ValueMapping *Map =                                                  \
        AArch64::getCopyMapping(PMI_First##RBNameDst == PMI_FirstGPR,          \
                                PMI_First##RBNameSrc == PMI_FirstGPR, Size);   \
    (void)Map;                                                                 \
    assert(Map[0].BreakDown ==                                                 \
               &AArch64GenRegisterBankInfo::PartMappings[PartialMapDstIdx] &&  \
           Map[0].NumBreakDowns == 1 && #RBNameDst #Size                       \
           " Dst is incorrectly initialized");                                 \
    assert(Map[1].BreakDown ==                                                 \
               &AArch64GenRegisterBankInfo::PartMappings[PartialMapSrcIdx] &&  \
           Map[1].NumBreakDowns == 1 && #RBNameSrc #Size                       \
           " Src is incorrectly initialized");                                 \
                                                                               \
  } while (0)

  CHECK_VALUEMAP_CROSSREGCPY(GPR, GPR, 32);
  CHECK_VALUEMAP_CROSSREGCPY(GPR, FPR, 32);
  CHECK_VALUEMAP_CROSSREGCPY(GPR, GPR, 64);
  CHECK_VALUEMAP_CROSSREGCPY(GPR, FPR, 64);
  CHECK_VALUEMAP_CROSSREGCPY(FPR, FPR, 32);
  CHECK_VALUEMAP_CROSSREGCPY(FPR, GPR, 32);
  CHECK_VALUEMAP_CROSSREGCPY(FPR, FPR, 64);
  CHECK_VALUEMAP_CROSSREGCPY(FPR, GPR, 64);

  assert(verify(TRI) && "Invalid register bank information");
}

unsigned AArch64RegisterBankInfo::copyCost(const RegisterBank &A,
                                           const RegisterBank &B,
                                           unsigned Size) const {
  // What do we do with different size?
  // copy are same size.
  // Will introduce other hooks for different size:
  // * extract cost.
  // * build_sequence cost.

  // Copy from (resp. to) GPR to (resp. from) FPR involves FMOV.
  // FIXME: This should be deduced from the scheduling model.
  if (&A == &AArch64::GPRRegBank && &B == &AArch64::FPRRegBank)
    // FMOVXDr or FMOVWSr.
    return 5;
  if (&A == &AArch64::FPRRegBank && &B == &AArch64::GPRRegBank)
    // FMOVDXr or FMOVSWr.
    return 4;

  return RegisterBankInfo::copyCost(A, B, Size);
}

const RegisterBank &AArch64RegisterBankInfo::getRegBankFromRegClass(
    const TargetRegisterClass &RC) const {
  switch (RC.getID()) {
  case AArch64::FPR8RegClassID:
  case AArch64::FPR16RegClassID:
  case AArch64::FPR32RegClassID:
  case AArch64::FPR64RegClassID:
  case AArch64::FPR128RegClassID:
  case AArch64::FPR128_loRegClassID:
  case AArch64::DDRegClassID:
  case AArch64::DDDRegClassID:
  case AArch64::DDDDRegClassID:
  case AArch64::QQRegClassID:
  case AArch64::QQQRegClassID:
  case AArch64::QQQQRegClassID:
    return getRegBank(AArch64::FPRRegBankID);
  case AArch64::GPR32commonRegClassID:
  case AArch64::GPR32RegClassID:
  case AArch64::GPR32spRegClassID:
  case AArch64::GPR32sponlyRegClassID:
  case AArch64::GPR32allRegClassID:
  case AArch64::GPR64commonRegClassID:
  case AArch64::GPR64RegClassID:
  case AArch64::GPR64spRegClassID:
  case AArch64::GPR64sponlyRegClassID:
  case AArch64::GPR64allRegClassID:
  case AArch64::tcGPR64RegClassID:
  case AArch64::WSeqPairsClassRegClassID:
  case AArch64::XSeqPairsClassRegClassID:
    return getRegBank(AArch64::GPRRegBankID);
  case AArch64::CCRRegClassID:
    return getRegBank(AArch64::CCRRegBankID);
  default:
    llvm_unreachable("Register class not supported");
  }
}

RegisterBankInfo::InstructionMappings
AArch64RegisterBankInfo::getInstrAlternativeMappings(
    const MachineInstr &MI) const {
  const MachineFunction &MF = *MI.getParent()->getParent();
  const TargetSubtargetInfo &STI = MF.getSubtarget();
  const TargetRegisterInfo &TRI = *STI.getRegisterInfo();
  const MachineRegisterInfo &MRI = MF.getRegInfo();

  switch (MI.getOpcode()) {
  case TargetOpcode::G_OR: {
    // 32 and 64-bit or can be mapped on either FPR or
    // GPR for the same cost.
    unsigned Size = getSizeInBits(MI.getOperand(0).getReg(), MRI, TRI);
    if (Size != 32 && Size != 64)
      break;

    // If the instruction has any implicit-defs or uses,
    // do not mess with it.
    if (MI.getNumOperands() != 3)
      break;
    InstructionMappings AltMappings;
    InstructionMapping GPRMapping(
        /*ID*/ 1, /*Cost*/ 1, AArch64::getValueMapping(PMI_FirstGPR, Size),
        /*NumOperands*/ 3);
    InstructionMapping FPRMapping(
        /*ID*/ 2, /*Cost*/ 1, AArch64::getValueMapping(PMI_FirstFPR, Size),
        /*NumOperands*/ 3);

    AltMappings.emplace_back(std::move(GPRMapping));
    AltMappings.emplace_back(std::move(FPRMapping));
    return AltMappings;
  }
  case TargetOpcode::G_BITCAST: {
    unsigned Size = getSizeInBits(MI.getOperand(0).getReg(), MRI, TRI);
    if (Size != 32 && Size != 64)
      break;

    // If the instruction has any implicit-defs or uses,
    // do not mess with it.
    if (MI.getNumOperands() != 2)
      break;

    InstructionMappings AltMappings;
    InstructionMapping GPRMapping(
        /*ID*/ 1, /*Cost*/ 1,
        AArch64::getCopyMapping(/*DstIsGPR*/ true, /*SrcIsGPR*/ true, Size),
        /*NumOperands*/ 2);
    InstructionMapping FPRMapping(
        /*ID*/ 2, /*Cost*/ 1,
        AArch64::getCopyMapping(/*DstIsGPR*/ false, /*SrcIsGPR*/ false, Size),
        /*NumOperands*/ 2);
    InstructionMapping GPRToFPRMapping(
        /*ID*/ 3,
        /*Cost*/ copyCost(AArch64::GPRRegBank, AArch64::FPRRegBank, Size),
        AArch64::getCopyMapping(/*DstIsGPR*/ false, /*SrcIsGPR*/ true, Size),
        /*NumOperands*/ 2);
    InstructionMapping FPRToGPRMapping(
        /*ID*/ 3,
        /*Cost*/ copyCost(AArch64::GPRRegBank, AArch64::FPRRegBank, Size),
        AArch64::getCopyMapping(/*DstIsGPR*/ true, /*SrcIsGPR*/ false, Size),
        /*NumOperands*/ 2);

    AltMappings.emplace_back(std::move(GPRMapping));
    AltMappings.emplace_back(std::move(FPRMapping));
    AltMappings.emplace_back(std::move(GPRToFPRMapping));
    AltMappings.emplace_back(std::move(FPRToGPRMapping));
    return AltMappings;
  }
  case TargetOpcode::G_LOAD: {
    unsigned Size = getSizeInBits(MI.getOperand(0).getReg(), MRI, TRI);
    if (Size != 64)
      break;

    // If the instruction has any implicit-defs or uses,
    // do not mess with it.
    if (MI.getNumOperands() != 2)
      break;

    InstructionMappings AltMappings;
    InstructionMapping GPRMapping(
        /*ID*/ 1, /*Cost*/ 1,
        getOperandsMapping({AArch64::getValueMapping(PMI_FirstGPR, Size),
                            // Addresses are GPR 64-bit.
                            AArch64::getValueMapping(PMI_FirstGPR, 64)}),
        /*NumOperands*/ 2);
    InstructionMapping FPRMapping(
        /*ID*/ 2, /*Cost*/ 1,
        getOperandsMapping({AArch64::getValueMapping(PMI_FirstFPR, Size),
                            // Addresses are GPR 64-bit.
                            AArch64::getValueMapping(PMI_FirstGPR, 64)}),
        /*NumOperands*/ 2);

    AltMappings.emplace_back(std::move(GPRMapping));
    AltMappings.emplace_back(std::move(FPRMapping));
    return AltMappings;
  }
  default:
    break;
  }
  return RegisterBankInfo::getInstrAlternativeMappings(MI);
}

void AArch64RegisterBankInfo::applyMappingImpl(
    const OperandsMapper &OpdMapper) const {
  switch (OpdMapper.getMI().getOpcode()) {
  case TargetOpcode::G_OR:
  case TargetOpcode::G_BITCAST:
  case TargetOpcode::G_LOAD: {
    // Those ID must match getInstrAlternativeMappings.
    assert((OpdMapper.getInstrMapping().getID() >= 1 &&
            OpdMapper.getInstrMapping().getID() <= 4) &&
           "Don't know how to handle that ID");
    return applyDefaultMapping(OpdMapper);
  }
  default:
    llvm_unreachable("Don't know how to handle that operation");
  }
}

/// Returns whether opcode \p Opc is a pre-isel generic floating-point opcode,
/// having only floating-point operands.
static bool isPreISelGenericFloatingPointOpcode(unsigned Opc) {
  switch (Opc) {
  case TargetOpcode::G_FADD:
  case TargetOpcode::G_FSUB:
  case TargetOpcode::G_FMUL:
  case TargetOpcode::G_FDIV:
  case TargetOpcode::G_FCONSTANT:
  case TargetOpcode::G_FPEXT:
  case TargetOpcode::G_FPTRUNC:
    return true;
  }
  return false;
}

RegisterBankInfo::InstructionMapping
AArch64RegisterBankInfo::getSameKindOfOperandsMapping(const MachineInstr &MI) {
  const unsigned Opc = MI.getOpcode();
  const MachineFunction &MF = *MI.getParent()->getParent();
  const MachineRegisterInfo &MRI = MF.getRegInfo();

  unsigned NumOperands = MI.getNumOperands();
  assert(NumOperands <= 3 &&
         "This code is for instructions with 3 or less operands");

  LLT Ty = MRI.getType(MI.getOperand(0).getReg());
  unsigned Size = Ty.getSizeInBits();
  bool IsFPR = Ty.isVector() || isPreISelGenericFloatingPointOpcode(Opc);

#ifndef NDEBUG
  // Make sure all the operands are using similar size and type.
  // Should probably be checked by the machine verifier.
  // This code won't catch cases where the number of lanes is
  // different between the operands.
  // If we want to go to that level of details, it is probably
  // best to check that the types are the same, period.
  // Currently, we just check that the register banks are the same
  // for each types.
  for (unsigned Idx = 1; Idx != NumOperands; ++Idx) {
    LLT OpTy = MRI.getType(MI.getOperand(Idx).getReg());
    assert(AArch64::getRegBankBaseIdxOffset(OpTy.getSizeInBits()) ==
               AArch64::getRegBankBaseIdxOffset(Size) &&
           "Operand has incompatible size");
    bool OpIsFPR = OpTy.isVector() || isPreISelGenericFloatingPointOpcode(Opc);
    (void)OpIsFPR;
    assert(IsFPR == OpIsFPR && "Operand has incompatible type");
  }
#endif // End NDEBUG.

  PartialMappingIdx RBIdx = IsFPR ? PMI_FirstFPR : PMI_FirstGPR;

  return InstructionMapping{DefaultMappingID, 1,
                            AArch64::getValueMapping(RBIdx, Size), NumOperands};
}

RegisterBankInfo::InstructionMapping
AArch64RegisterBankInfo::getInstrMapping(const MachineInstr &MI) const {
  const unsigned Opc = MI.getOpcode();
  const MachineFunction &MF = *MI.getParent()->getParent();
  const MachineRegisterInfo &MRI = MF.getRegInfo();

  // Try the default logic for non-generic instructions that are either copies
  // or already have some operands assigned to banks.
  if (!isPreISelGenericOpcode(Opc)) {
    RegisterBankInfo::InstructionMapping Mapping = getInstrMappingImpl(MI);
    if (Mapping.isValid())
      return Mapping;
  }

  switch (Opc) {
    // G_{F|S|U}REM are not listed because they are not legal.
    // Arithmetic ops.
  case TargetOpcode::G_ADD:
  case TargetOpcode::G_SUB:
  case TargetOpcode::G_GEP:
  case TargetOpcode::G_MUL:
  case TargetOpcode::G_SDIV:
  case TargetOpcode::G_UDIV:
    // Bitwise ops.
  case TargetOpcode::G_AND:
  case TargetOpcode::G_OR:
  case TargetOpcode::G_XOR:
    // Shifts.
  case TargetOpcode::G_SHL:
  case TargetOpcode::G_LSHR:
  case TargetOpcode::G_ASHR:
    // Floating point ops.
  case TargetOpcode::G_FADD:
  case TargetOpcode::G_FSUB:
  case TargetOpcode::G_FMUL:
  case TargetOpcode::G_FDIV:
    return getSameKindOfOperandsMapping(MI);
  case TargetOpcode::G_BITCAST: {
    LLT DstTy = MRI.getType(MI.getOperand(0).getReg());
    LLT SrcTy = MRI.getType(MI.getOperand(1).getReg());
    unsigned Size = DstTy.getSizeInBits();
    bool DstIsGPR = !DstTy.isVector();
    bool SrcIsGPR = !SrcTy.isVector();
    const RegisterBank &DstRB =
        DstIsGPR ? AArch64::GPRRegBank : AArch64::FPRRegBank;
    const RegisterBank &SrcRB =
        SrcIsGPR ? AArch64::GPRRegBank : AArch64::FPRRegBank;
    return InstructionMapping{DefaultMappingID, copyCost(DstRB, SrcRB, Size),
                              AArch64::getCopyMapping(DstIsGPR, SrcIsGPR, Size),
                              /*NumOperands*/ 2};
  }
  case TargetOpcode::G_SEQUENCE:
    // FIXME: support this, but the generic code is really not going to do
    // anything sane.
    return InstructionMapping();
  default:
    break;
  }

  unsigned NumOperands = MI.getNumOperands();

  // Track the size and bank of each register.  We don't do partial mappings.
  SmallVector<unsigned, 4> OpSize(NumOperands);
  SmallVector<PartialMappingIdx, 4> OpRegBankIdx(NumOperands);
  for (unsigned Idx = 0; Idx < NumOperands; ++Idx) {
    auto &MO = MI.getOperand(Idx);
    if (!MO.isReg())
      continue;

    LLT Ty = MRI.getType(MO.getReg());
    OpSize[Idx] = Ty.getSizeInBits();

    // As a top-level guess, vectors go in FPRs, scalars and pointers in GPRs.
    // For floating-point instructions, scalars go in FPRs.
    if (Ty.isVector() || isPreISelGenericFloatingPointOpcode(Opc))
      OpRegBankIdx[Idx] = PMI_FirstFPR;
    else
      OpRegBankIdx[Idx] = PMI_FirstGPR;
  }

  unsigned Cost = 1;
  // Some of the floating-point instructions have mixed GPR and FPR operands:
  // fine-tune the computed mapping.
  switch (Opc) {
  case TargetOpcode::G_SITOFP:
  case TargetOpcode::G_UITOFP: {
    OpRegBankIdx = {PMI_FirstFPR, PMI_FirstGPR};
    break;
  }
  case TargetOpcode::G_FPTOSI:
  case TargetOpcode::G_FPTOUI: {
    OpRegBankIdx = {PMI_FirstGPR, PMI_FirstFPR};
    break;
  }
  case TargetOpcode::G_FCMP: {
    OpRegBankIdx = {PMI_FirstGPR,
                    /* Predicate */ PMI_None, PMI_FirstFPR, PMI_FirstFPR};
    break;
  }
  case TargetOpcode::G_BITCAST: {
    // This is going to be a cross register bank copy and this is expensive.
    if (OpRegBankIdx[0] != OpRegBankIdx[1])
      Cost = copyCost(
          *AArch64GenRegisterBankInfo::PartMappings[OpRegBankIdx[0]].RegBank,
          *AArch64GenRegisterBankInfo::PartMappings[OpRegBankIdx[1]].RegBank,
          OpSize[0]);
    break;
  }
  case TargetOpcode::G_LOAD: {
    // Loading in vector unit is slightly more expensive.
    // This is actually only true for the LD1R and co instructions,
    // but anyway for the fast mode this number does not matter and
    // for the greedy mode the cost of the cross bank copy will
    // offset this number.
    // FIXME: Should be derived from the scheduling model.
    if (OpRegBankIdx[0] >= PMI_FirstFPR)
      Cost = 2;
  }
  }

  // Finally construct the computed mapping.
  RegisterBankInfo::InstructionMapping Mapping =
      InstructionMapping{DefaultMappingID, Cost, nullptr, NumOperands};
  SmallVector<const ValueMapping *, 8> OpdsMapping(NumOperands);
  for (unsigned Idx = 0; Idx < NumOperands; ++Idx)
    if (MI.getOperand(Idx).isReg())
      OpdsMapping[Idx] =
          AArch64::getValueMapping(OpRegBankIdx[Idx], OpSize[Idx]);

  Mapping.setOperandsMapping(getOperandsMapping(OpdsMapping));
  return Mapping;
}
