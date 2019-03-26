//=- WebAssemblyISelLowering.cpp - WebAssembly DAG Lowering Implementation -==//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// This file implements the WebAssemblyTargetLowering class.
///
//===----------------------------------------------------------------------===//

#include "WebAssemblyISelLowering.h"
#include "MCTargetDesc/WebAssemblyMCTargetDesc.h"
#include "WebAssemblyMachineFunctionInfo.h"
#include "WebAssemblySubtarget.h"
#include "WebAssemblyTargetMachine.h"
#include "llvm/CodeGen/Analysis.h"
#include "llvm/CodeGen/CallingConvLower.h"
#include "llvm/CodeGen/MachineInstrBuilder.h"
#include "llvm/CodeGen/MachineJumpTableInfo.h"
#include "llvm/CodeGen/MachineModuleInfo.h"
#include "llvm/CodeGen/MachineRegisterInfo.h"
#include "llvm/CodeGen/SelectionDAG.h"
#include "llvm/CodeGen/WasmEHFuncInfo.h"
#include "llvm/IR/DiagnosticInfo.h"
#include "llvm/IR/DiagnosticPrinter.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Intrinsics.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Target/TargetOptions.h"
using namespace llvm;

#define DEBUG_TYPE "wasm-lower"

WebAssemblyTargetLowering::WebAssemblyTargetLowering(
    const TargetMachine &TM, const WebAssemblySubtarget &STI)
    : TargetLowering(TM), Subtarget(&STI) {
  auto MVTPtr = Subtarget->hasAddr64() ? MVT::i64 : MVT::i32;

  // Booleans always contain 0 or 1.
  setBooleanContents(ZeroOrOneBooleanContent);
  // Except in SIMD vectors
  setBooleanVectorContents(ZeroOrNegativeOneBooleanContent);
  // WebAssembly does not produce floating-point exceptions on normal floating
  // point operations.
  setHasFloatingPointExceptions(false);
  // We don't know the microarchitecture here, so just reduce register pressure.
  setSchedulingPreference(Sched::RegPressure);
  // Tell ISel that we have a stack pointer.
  setStackPointerRegisterToSaveRestore(
      Subtarget->hasAddr64() ? WebAssembly::SP64 : WebAssembly::SP32);
  // Set up the register classes.
  addRegisterClass(MVT::i32, &WebAssembly::I32RegClass);
  addRegisterClass(MVT::i64, &WebAssembly::I64RegClass);
  addRegisterClass(MVT::f32, &WebAssembly::F32RegClass);
  addRegisterClass(MVT::f64, &WebAssembly::F64RegClass);
  if (Subtarget->hasSIMD128()) {
    addRegisterClass(MVT::v16i8, &WebAssembly::V128RegClass);
    addRegisterClass(MVT::v8i16, &WebAssembly::V128RegClass);
    addRegisterClass(MVT::v4i32, &WebAssembly::V128RegClass);
    addRegisterClass(MVT::v4f32, &WebAssembly::V128RegClass);
  }
  if (Subtarget->hasUnimplementedSIMD128()) {
    addRegisterClass(MVT::v2i64, &WebAssembly::V128RegClass);
    addRegisterClass(MVT::v2f64, &WebAssembly::V128RegClass);
  }
  // Compute derived properties from the register classes.
  computeRegisterProperties(Subtarget->getRegisterInfo());

  setOperationAction(ISD::GlobalAddress, MVTPtr, Custom);
  setOperationAction(ISD::ExternalSymbol, MVTPtr, Custom);
  setOperationAction(ISD::JumpTable, MVTPtr, Custom);
  setOperationAction(ISD::BlockAddress, MVTPtr, Custom);
  setOperationAction(ISD::BRIND, MVT::Other, Custom);

  // Take the default expansion for va_arg, va_copy, and va_end. There is no
  // default action for va_start, so we do that custom.
  setOperationAction(ISD::VASTART, MVT::Other, Custom);
  setOperationAction(ISD::VAARG, MVT::Other, Expand);
  setOperationAction(ISD::VACOPY, MVT::Other, Expand);
  setOperationAction(ISD::VAEND, MVT::Other, Expand);

  for (auto T : {MVT::f32, MVT::f64, MVT::v4f32, MVT::v2f64}) {
    // Don't expand the floating-point types to constant pools.
    setOperationAction(ISD::ConstantFP, T, Legal);
    // Expand floating-point comparisons.
    for (auto CC : {ISD::SETO, ISD::SETUO, ISD::SETUEQ, ISD::SETONE,
                    ISD::SETULT, ISD::SETULE, ISD::SETUGT, ISD::SETUGE})
      setCondCodeAction(CC, T, Expand);
    // Expand floating-point library function operators.
    for (auto Op :
         {ISD::FSIN, ISD::FCOS, ISD::FSINCOS, ISD::FPOW, ISD::FREM, ISD::FMA})
      setOperationAction(Op, T, Expand);
    // Note supported floating-point library function operators that otherwise
    // default to expand.
    for (auto Op :
         {ISD::FCEIL, ISD::FFLOOR, ISD::FTRUNC, ISD::FNEARBYINT, ISD::FRINT})
      setOperationAction(Op, T, Legal);
    // Support minimum and maximum, which otherwise default to expand.
    setOperationAction(ISD::FMINIMUM, T, Legal);
    setOperationAction(ISD::FMAXIMUM, T, Legal);
    // WebAssembly currently has no builtin f16 support.
    setOperationAction(ISD::FP16_TO_FP, T, Expand);
    setOperationAction(ISD::FP_TO_FP16, T, Expand);
    setLoadExtAction(ISD::EXTLOAD, T, MVT::f16, Expand);
    setTruncStoreAction(T, MVT::f16, Expand);
  }

  // Expand unavailable integer operations.
  for (auto Op :
       {ISD::BSWAP, ISD::SMUL_LOHI, ISD::UMUL_LOHI, ISD::MULHS, ISD::MULHU,
        ISD::SDIVREM, ISD::UDIVREM, ISD::SHL_PARTS, ISD::SRA_PARTS,
        ISD::SRL_PARTS, ISD::ADDC, ISD::ADDE, ISD::SUBC, ISD::SUBE}) {
    for (auto T : {MVT::i32, MVT::i64})
      setOperationAction(Op, T, Expand);
    if (Subtarget->hasSIMD128())
      for (auto T : {MVT::v16i8, MVT::v8i16, MVT::v4i32})
        setOperationAction(Op, T, Expand);
    if (Subtarget->hasUnimplementedSIMD128())
      setOperationAction(Op, MVT::v2i64, Expand);
  }

  // SIMD-specific configuration
  if (Subtarget->hasSIMD128()) {
    // Support saturating add for i8x16 and i16x8
    for (auto Op : {ISD::SADDSAT, ISD::UADDSAT})
      for (auto T : {MVT::v16i8, MVT::v8i16})
        setOperationAction(Op, T, Legal);

    // Custom lower BUILD_VECTORs to minimize number of replace_lanes
    for (auto T : {MVT::v16i8, MVT::v8i16, MVT::v4i32, MVT::v4f32})
      setOperationAction(ISD::BUILD_VECTOR, T, Custom);
    if (Subtarget->hasUnimplementedSIMD128())
      for (auto T : {MVT::v2i64, MVT::v2f64})
        setOperationAction(ISD::BUILD_VECTOR, T, Custom);

    // We have custom shuffle lowering to expose the shuffle mask
    for (auto T : {MVT::v16i8, MVT::v8i16, MVT::v4i32, MVT::v4f32})
      setOperationAction(ISD::VECTOR_SHUFFLE, T, Custom);
    if (Subtarget->hasUnimplementedSIMD128())
      for (auto T: {MVT::v2i64, MVT::v2f64})
        setOperationAction(ISD::VECTOR_SHUFFLE, T, Custom);

    // Custom lowering since wasm shifts must have a scalar shift amount
    for (auto Op : {ISD::SHL, ISD::SRA, ISD::SRL}) {
      for (auto T : {MVT::v16i8, MVT::v8i16, MVT::v4i32})
        setOperationAction(Op, T, Custom);
      if (Subtarget->hasUnimplementedSIMD128())
        setOperationAction(Op, MVT::v2i64, Custom);
    }

    // Custom lower lane accesses to expand out variable indices
    for (auto Op : {ISD::EXTRACT_VECTOR_ELT, ISD::INSERT_VECTOR_ELT}) {
      for (auto T : {MVT::v16i8, MVT::v8i16, MVT::v4i32, MVT::v4f32})
        setOperationAction(Op, T, Custom);
      if (Subtarget->hasUnimplementedSIMD128())
        for (auto T : {MVT::v2i64, MVT::v2f64})
          setOperationAction(Op, T, Custom);
    }

    // There is no i64x2.mul instruction
    setOperationAction(ISD::MUL, MVT::v2i64, Expand);

    // There are no vector select instructions
    for (auto Op : {ISD::VSELECT, ISD::SELECT_CC, ISD::SELECT}) {
      for (auto T : {MVT::v16i8, MVT::v8i16, MVT::v4i32, MVT::v4f32})
        setOperationAction(Op, T, Expand);
      if (Subtarget->hasUnimplementedSIMD128())
        for (auto T : {MVT::v2i64, MVT::v2f64})
          setOperationAction(Op, T, Expand);
    }

    // Expand integer operations supported for scalars but not SIMD
    for (auto Op : {ISD::CTLZ, ISD::CTTZ, ISD::CTPOP, ISD::SDIV, ISD::UDIV,
                    ISD::SREM, ISD::UREM, ISD::ROTL, ISD::ROTR}) {
      for (auto T : {MVT::v16i8, MVT::v8i16, MVT::v4i32})
        setOperationAction(Op, T, Expand);
      if (Subtarget->hasUnimplementedSIMD128())
        setOperationAction(Op, MVT::v2i64, Expand);
    }

    // Expand float operations supported for scalars but not SIMD
    for (auto Op : {ISD::FCEIL, ISD::FFLOOR, ISD::FTRUNC, ISD::FNEARBYINT,
                    ISD::FCOPYSIGN}) {
      setOperationAction(Op, MVT::v4f32, Expand);
      if (Subtarget->hasUnimplementedSIMD128())
        setOperationAction(Op, MVT::v2f64, Expand);
    }

    // Expand additional SIMD ops that V8 hasn't implemented yet
    if (!Subtarget->hasUnimplementedSIMD128()) {
      setOperationAction(ISD::FSQRT, MVT::v4f32, Expand);
      setOperationAction(ISD::FDIV, MVT::v4f32, Expand);
    }
  }

  // As a special case, these operators use the type to mean the type to
  // sign-extend from.
  setOperationAction(ISD::SIGN_EXTEND_INREG, MVT::i1, Expand);
  if (!Subtarget->hasSignExt()) {
    // Sign extends are legal only when extending a vector extract
    auto Action = Subtarget->hasSIMD128() ? Custom : Expand;
    for (auto T : {MVT::i8, MVT::i16, MVT::i32})
      setOperationAction(ISD::SIGN_EXTEND_INREG, T, Action);
  }
  for (auto T : MVT::integer_vector_valuetypes())
    setOperationAction(ISD::SIGN_EXTEND_INREG, T, Expand);

  // Dynamic stack allocation: use the default expansion.
  setOperationAction(ISD::STACKSAVE, MVT::Other, Expand);
  setOperationAction(ISD::STACKRESTORE, MVT::Other, Expand);
  setOperationAction(ISD::DYNAMIC_STACKALLOC, MVTPtr, Expand);

  setOperationAction(ISD::FrameIndex, MVT::i32, Custom);
  setOperationAction(ISD::CopyToReg, MVT::Other, Custom);

  // Expand these forms; we pattern-match the forms that we can handle in isel.
  for (auto T : {MVT::i32, MVT::i64, MVT::f32, MVT::f64})
    for (auto Op : {ISD::BR_CC, ISD::SELECT_CC})
      setOperationAction(Op, T, Expand);

  // We have custom switch handling.
  setOperationAction(ISD::BR_JT, MVT::Other, Custom);

  // WebAssembly doesn't have:
  //  - Floating-point extending loads.
  //  - Floating-point truncating stores.
  //  - i1 extending loads.
  //  - extending/truncating SIMD loads/stores
  setLoadExtAction(ISD::EXTLOAD, MVT::f64, MVT::f32, Expand);
  setTruncStoreAction(MVT::f64, MVT::f32, Expand);
  for (auto T : MVT::integer_valuetypes())
    for (auto Ext : {ISD::EXTLOAD, ISD::ZEXTLOAD, ISD::SEXTLOAD})
      setLoadExtAction(Ext, T, MVT::i1, Promote);
  if (Subtarget->hasSIMD128()) {
    for (auto T : {MVT::v16i8, MVT::v8i16, MVT::v4i32, MVT::v2i64, MVT::v4f32,
                   MVT::v2f64}) {
      for (auto MemT : MVT::vector_valuetypes()) {
        if (MVT(T) != MemT) {
          setTruncStoreAction(T, MemT, Expand);
          for (auto Ext : {ISD::EXTLOAD, ISD::ZEXTLOAD, ISD::SEXTLOAD})
            setLoadExtAction(Ext, T, MemT, Expand);
        }
      }
    }
  }

  // Don't do anything clever with build_pairs
  setOperationAction(ISD::BUILD_PAIR, MVT::i64, Expand);

  // Trap lowers to wasm unreachable
  setOperationAction(ISD::TRAP, MVT::Other, Legal);

  // Exception handling intrinsics
  setOperationAction(ISD::INTRINSIC_WO_CHAIN, MVT::Other, Custom);
  setOperationAction(ISD::INTRINSIC_VOID, MVT::Other, Custom);

  setMaxAtomicSizeInBitsSupported(64);

  if (Subtarget->hasBulkMemory()) {
    // Use memory.copy and friends over multiple loads and stores
    MaxStoresPerMemcpy = 1;
    MaxStoresPerMemcpyOptSize = 1;
    MaxStoresPerMemmove = 1;
    MaxStoresPerMemmoveOptSize = 1;
    MaxStoresPerMemset = 1;
    MaxStoresPerMemsetOptSize = 1;
  }
}

TargetLowering::AtomicExpansionKind
WebAssemblyTargetLowering::shouldExpandAtomicRMWInIR(AtomicRMWInst *AI) const {
  // We have wasm instructions for these
  switch (AI->getOperation()) {
  case AtomicRMWInst::Add:
  case AtomicRMWInst::Sub:
  case AtomicRMWInst::And:
  case AtomicRMWInst::Or:
  case AtomicRMWInst::Xor:
  case AtomicRMWInst::Xchg:
    return AtomicExpansionKind::None;
  default:
    break;
  }
  return AtomicExpansionKind::CmpXChg;
}

FastISel *WebAssemblyTargetLowering::createFastISel(
    FunctionLoweringInfo &FuncInfo, const TargetLibraryInfo *LibInfo) const {
  return WebAssembly::createFastISel(FuncInfo, LibInfo);
}

MVT WebAssemblyTargetLowering::getScalarShiftAmountTy(const DataLayout & /*DL*/,
                                                      EVT VT) const {
  unsigned BitWidth = NextPowerOf2(VT.getSizeInBits() - 1);
  if (BitWidth > 1 && BitWidth < 8)
    BitWidth = 8;

  if (BitWidth > 64) {
    // The shift will be lowered to a libcall, and compiler-rt libcalls expect
    // the count to be an i32.
    BitWidth = 32;
    assert(BitWidth >= Log2_32_Ceil(VT.getSizeInBits()) &&
           "32-bit shift counts ought to be enough for anyone");
  }

  MVT Result = MVT::getIntegerVT(BitWidth);
  assert(Result != MVT::INVALID_SIMPLE_VALUE_TYPE &&
         "Unable to represent scalar shift amount type");
  return Result;
}

// Lower an fp-to-int conversion operator from the LLVM opcode, which has an
// undefined result on invalid/overflow, to the WebAssembly opcode, which
// traps on invalid/overflow.
static MachineBasicBlock *LowerFPToInt(MachineInstr &MI, DebugLoc DL,
                                       MachineBasicBlock *BB,
                                       const TargetInstrInfo &TII,
                                       bool IsUnsigned, bool Int64,
                                       bool Float64, unsigned LoweredOpcode) {
  MachineRegisterInfo &MRI = BB->getParent()->getRegInfo();

  unsigned OutReg = MI.getOperand(0).getReg();
  unsigned InReg = MI.getOperand(1).getReg();

  unsigned Abs = Float64 ? WebAssembly::ABS_F64 : WebAssembly::ABS_F32;
  unsigned FConst = Float64 ? WebAssembly::CONST_F64 : WebAssembly::CONST_F32;
  unsigned LT = Float64 ? WebAssembly::LT_F64 : WebAssembly::LT_F32;
  unsigned GE = Float64 ? WebAssembly::GE_F64 : WebAssembly::GE_F32;
  unsigned IConst = Int64 ? WebAssembly::CONST_I64 : WebAssembly::CONST_I32;
  unsigned Eqz = WebAssembly::EQZ_I32;
  unsigned And = WebAssembly::AND_I32;
  int64_t Limit = Int64 ? INT64_MIN : INT32_MIN;
  int64_t Substitute = IsUnsigned ? 0 : Limit;
  double CmpVal = IsUnsigned ? -(double)Limit * 2.0 : -(double)Limit;
  auto &Context = BB->getParent()->getFunction().getContext();
  Type *Ty = Float64 ? Type::getDoubleTy(Context) : Type::getFloatTy(Context);

  const BasicBlock *LLVMBB = BB->getBasicBlock();
  MachineFunction *F = BB->getParent();
  MachineBasicBlock *TrueMBB = F->CreateMachineBasicBlock(LLVMBB);
  MachineBasicBlock *FalseMBB = F->CreateMachineBasicBlock(LLVMBB);
  MachineBasicBlock *DoneMBB = F->CreateMachineBasicBlock(LLVMBB);

  MachineFunction::iterator It = ++BB->getIterator();
  F->insert(It, FalseMBB);
  F->insert(It, TrueMBB);
  F->insert(It, DoneMBB);

  // Transfer the remainder of BB and its successor edges to DoneMBB.
  DoneMBB->splice(DoneMBB->begin(), BB, std::next(MI.getIterator()), BB->end());
  DoneMBB->transferSuccessorsAndUpdatePHIs(BB);

  BB->addSuccessor(TrueMBB);
  BB->addSuccessor(FalseMBB);
  TrueMBB->addSuccessor(DoneMBB);
  FalseMBB->addSuccessor(DoneMBB);

  unsigned Tmp0, Tmp1, CmpReg, EqzReg, FalseReg, TrueReg;
  Tmp0 = MRI.createVirtualRegister(MRI.getRegClass(InReg));
  Tmp1 = MRI.createVirtualRegister(MRI.getRegClass(InReg));
  CmpReg = MRI.createVirtualRegister(&WebAssembly::I32RegClass);
  EqzReg = MRI.createVirtualRegister(&WebAssembly::I32RegClass);
  FalseReg = MRI.createVirtualRegister(MRI.getRegClass(OutReg));
  TrueReg = MRI.createVirtualRegister(MRI.getRegClass(OutReg));

  MI.eraseFromParent();
  // For signed numbers, we can do a single comparison to determine whether
  // fabs(x) is within range.
  if (IsUnsigned) {
    Tmp0 = InReg;
  } else {
    BuildMI(BB, DL, TII.get(Abs), Tmp0).addReg(InReg);
  }
  BuildMI(BB, DL, TII.get(FConst), Tmp1)
      .addFPImm(cast<ConstantFP>(ConstantFP::get(Ty, CmpVal)));
  BuildMI(BB, DL, TII.get(LT), CmpReg).addReg(Tmp0).addReg(Tmp1);

  // For unsigned numbers, we have to do a separate comparison with zero.
  if (IsUnsigned) {
    Tmp1 = MRI.createVirtualRegister(MRI.getRegClass(InReg));
    unsigned SecondCmpReg =
        MRI.createVirtualRegister(&WebAssembly::I32RegClass);
    unsigned AndReg = MRI.createVirtualRegister(&WebAssembly::I32RegClass);
    BuildMI(BB, DL, TII.get(FConst), Tmp1)
        .addFPImm(cast<ConstantFP>(ConstantFP::get(Ty, 0.0)));
    BuildMI(BB, DL, TII.get(GE), SecondCmpReg).addReg(Tmp0).addReg(Tmp1);
    BuildMI(BB, DL, TII.get(And), AndReg).addReg(CmpReg).addReg(SecondCmpReg);
    CmpReg = AndReg;
  }

  BuildMI(BB, DL, TII.get(Eqz), EqzReg).addReg(CmpReg);

  // Create the CFG diamond to select between doing the conversion or using
  // the substitute value.
  BuildMI(BB, DL, TII.get(WebAssembly::BR_IF)).addMBB(TrueMBB).addReg(EqzReg);
  BuildMI(FalseMBB, DL, TII.get(LoweredOpcode), FalseReg).addReg(InReg);
  BuildMI(FalseMBB, DL, TII.get(WebAssembly::BR)).addMBB(DoneMBB);
  BuildMI(TrueMBB, DL, TII.get(IConst), TrueReg).addImm(Substitute);
  BuildMI(*DoneMBB, DoneMBB->begin(), DL, TII.get(TargetOpcode::PHI), OutReg)
      .addReg(FalseReg)
      .addMBB(FalseMBB)
      .addReg(TrueReg)
      .addMBB(TrueMBB);

  return DoneMBB;
}

MachineBasicBlock *WebAssemblyTargetLowering::EmitInstrWithCustomInserter(
    MachineInstr &MI, MachineBasicBlock *BB) const {
  const TargetInstrInfo &TII = *Subtarget->getInstrInfo();
  DebugLoc DL = MI.getDebugLoc();

  switch (MI.getOpcode()) {
  default:
    llvm_unreachable("Unexpected instr type to insert");
  case WebAssembly::FP_TO_SINT_I32_F32:
    return LowerFPToInt(MI, DL, BB, TII, false, false, false,
                        WebAssembly::I32_TRUNC_S_F32);
  case WebAssembly::FP_TO_UINT_I32_F32:
    return LowerFPToInt(MI, DL, BB, TII, true, false, false,
                        WebAssembly::I32_TRUNC_U_F32);
  case WebAssembly::FP_TO_SINT_I64_F32:
    return LowerFPToInt(MI, DL, BB, TII, false, true, false,
                        WebAssembly::I64_TRUNC_S_F32);
  case WebAssembly::FP_TO_UINT_I64_F32:
    return LowerFPToInt(MI, DL, BB, TII, true, true, false,
                        WebAssembly::I64_TRUNC_U_F32);
  case WebAssembly::FP_TO_SINT_I32_F64:
    return LowerFPToInt(MI, DL, BB, TII, false, false, true,
                        WebAssembly::I32_TRUNC_S_F64);
  case WebAssembly::FP_TO_UINT_I32_F64:
    return LowerFPToInt(MI, DL, BB, TII, true, false, true,
                        WebAssembly::I32_TRUNC_U_F64);
  case WebAssembly::FP_TO_SINT_I64_F64:
    return LowerFPToInt(MI, DL, BB, TII, false, true, true,
                        WebAssembly::I64_TRUNC_S_F64);
  case WebAssembly::FP_TO_UINT_I64_F64:
    return LowerFPToInt(MI, DL, BB, TII, true, true, true,
                        WebAssembly::I64_TRUNC_U_F64);
    llvm_unreachable("Unexpected instruction to emit with custom inserter");
  }
}

const char *
WebAssemblyTargetLowering::getTargetNodeName(unsigned Opcode) const {
  switch (static_cast<WebAssemblyISD::NodeType>(Opcode)) {
  case WebAssemblyISD::FIRST_NUMBER:
    break;
#define HANDLE_NODETYPE(NODE)                                                  \
  case WebAssemblyISD::NODE:                                                   \
    return "WebAssemblyISD::" #NODE;
#include "WebAssemblyISD.def"
#undef HANDLE_NODETYPE
  }
  return nullptr;
}

std::pair<unsigned, const TargetRegisterClass *>
WebAssemblyTargetLowering::getRegForInlineAsmConstraint(
    const TargetRegisterInfo *TRI, StringRef Constraint, MVT VT) const {
  // First, see if this is a constraint that directly corresponds to a
  // WebAssembly register class.
  if (Constraint.size() == 1) {
    switch (Constraint[0]) {
    case 'r':
      assert(VT != MVT::iPTR && "Pointer MVT not expected here");
      if (Subtarget->hasSIMD128() && VT.isVector()) {
        if (VT.getSizeInBits() == 128)
          return std::make_pair(0U, &WebAssembly::V128RegClass);
      }
      if (VT.isInteger() && !VT.isVector()) {
        if (VT.getSizeInBits() <= 32)
          return std::make_pair(0U, &WebAssembly::I32RegClass);
        if (VT.getSizeInBits() <= 64)
          return std::make_pair(0U, &WebAssembly::I64RegClass);
      }
      break;
    default:
      break;
    }
  }

  return TargetLowering::getRegForInlineAsmConstraint(TRI, Constraint, VT);
}

bool WebAssemblyTargetLowering::isCheapToSpeculateCttz() const {
  // Assume ctz is a relatively cheap operation.
  return true;
}

bool WebAssemblyTargetLowering::isCheapToSpeculateCtlz() const {
  // Assume clz is a relatively cheap operation.
  return true;
}

bool WebAssemblyTargetLowering::isLegalAddressingMode(const DataLayout &DL,
                                                      const AddrMode &AM,
                                                      Type *Ty, unsigned AS,
                                                      Instruction *I) const {
  // WebAssembly offsets are added as unsigned without wrapping. The
  // isLegalAddressingMode gives us no way to determine if wrapping could be
  // happening, so we approximate this by accepting only non-negative offsets.
  if (AM.BaseOffs < 0)
    return false;

  // WebAssembly has no scale register operands.
  if (AM.Scale != 0)
    return false;

  // Everything else is legal.
  return true;
}

bool WebAssemblyTargetLowering::allowsMisalignedMemoryAccesses(
    EVT /*VT*/, unsigned /*AddrSpace*/, unsigned /*Align*/, bool *Fast) const {
  // WebAssembly supports unaligned accesses, though it should be declared
  // with the p2align attribute on loads and stores which do so, and there
  // may be a performance impact. We tell LLVM they're "fast" because
  // for the kinds of things that LLVM uses this for (merging adjacent stores
  // of constants, etc.), WebAssembly implementations will either want the
  // unaligned access or they'll split anyway.
  if (Fast)
    *Fast = true;
  return true;
}

bool WebAssemblyTargetLowering::isIntDivCheap(EVT VT,
                                              AttributeList Attr) const {
  // The current thinking is that wasm engines will perform this optimization,
  // so we can save on code size.
  return true;
}

EVT WebAssemblyTargetLowering::getSetCCResultType(const DataLayout &DL,
                                                  LLVMContext &C,
                                                  EVT VT) const {
  if (VT.isVector())
    return VT.changeVectorElementTypeToInteger();

  return TargetLowering::getSetCCResultType(DL, C, VT);
}

bool WebAssemblyTargetLowering::getTgtMemIntrinsic(IntrinsicInfo &Info,
                                                   const CallInst &I,
                                                   MachineFunction &MF,
                                                   unsigned Intrinsic) const {
  switch (Intrinsic) {
  case Intrinsic::wasm_atomic_notify:
    Info.opc = ISD::INTRINSIC_W_CHAIN;
    Info.memVT = MVT::i32;
    Info.ptrVal = I.getArgOperand(0);
    Info.offset = 0;
    Info.align = 4;
    // atomic.notify instruction does not really load the memory specified with
    // this argument, but MachineMemOperand should either be load or store, so
    // we set this to a load.
    // FIXME Volatile isn't really correct, but currently all LLVM atomic
    // instructions are treated as volatiles in the backend, so we should be
    // consistent. The same applies for wasm_atomic_wait intrinsics too.
    Info.flags = MachineMemOperand::MOVolatile | MachineMemOperand::MOLoad;
    return true;
  case Intrinsic::wasm_atomic_wait_i32:
    Info.opc = ISD::INTRINSIC_W_CHAIN;
    Info.memVT = MVT::i32;
    Info.ptrVal = I.getArgOperand(0);
    Info.offset = 0;
    Info.align = 4;
    Info.flags = MachineMemOperand::MOVolatile | MachineMemOperand::MOLoad;
    return true;
  case Intrinsic::wasm_atomic_wait_i64:
    Info.opc = ISD::INTRINSIC_W_CHAIN;
    Info.memVT = MVT::i64;
    Info.ptrVal = I.getArgOperand(0);
    Info.offset = 0;
    Info.align = 8;
    Info.flags = MachineMemOperand::MOVolatile | MachineMemOperand::MOLoad;
    return true;
  default:
    return false;
  }
}

//===----------------------------------------------------------------------===//
// WebAssembly Lowering private implementation.
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
// Lowering Code
//===----------------------------------------------------------------------===//

static void fail(const SDLoc &DL, SelectionDAG &DAG, const char *Msg) {
  MachineFunction &MF = DAG.getMachineFunction();
  DAG.getContext()->diagnose(
      DiagnosticInfoUnsupported(MF.getFunction(), Msg, DL.getDebugLoc()));
}

// Test whether the given calling convention is supported.
static bool callingConvSupported(CallingConv::ID CallConv) {
  // We currently support the language-independent target-independent
  // conventions. We don't yet have a way to annotate calls with properties like
  // "cold", and we don't have any call-clobbered registers, so these are mostly
  // all handled the same.
  return CallConv == CallingConv::C || CallConv == CallingConv::Fast ||
         CallConv == CallingConv::Cold ||
         CallConv == CallingConv::PreserveMost ||
         CallConv == CallingConv::PreserveAll ||
         CallConv == CallingConv::CXX_FAST_TLS;
}

SDValue
WebAssemblyTargetLowering::LowerCall(CallLoweringInfo &CLI,
                                     SmallVectorImpl<SDValue> &InVals) const {
  SelectionDAG &DAG = CLI.DAG;
  SDLoc DL = CLI.DL;
  SDValue Chain = CLI.Chain;
  SDValue Callee = CLI.Callee;
  MachineFunction &MF = DAG.getMachineFunction();
  auto Layout = MF.getDataLayout();

  CallingConv::ID CallConv = CLI.CallConv;
  if (!callingConvSupported(CallConv))
    fail(DL, DAG,
         "WebAssembly doesn't support language-specific or target-specific "
         "calling conventions yet");
  if (CLI.IsPatchPoint)
    fail(DL, DAG, "WebAssembly doesn't support patch point yet");

  // WebAssembly doesn't currently support explicit tail calls. If they are
  // required, fail. Otherwise, just disable them.
  if ((CallConv == CallingConv::Fast && CLI.IsTailCall &&
       MF.getTarget().Options.GuaranteedTailCallOpt) ||
      (CLI.CS && CLI.CS.isMustTailCall()))
    fail(DL, DAG, "WebAssembly doesn't support tail call yet");
  CLI.IsTailCall = false;

  SmallVectorImpl<ISD::InputArg> &Ins = CLI.Ins;
  if (Ins.size() > 1)
    fail(DL, DAG, "WebAssembly doesn't support more than 1 returned value yet");

  SmallVectorImpl<ISD::OutputArg> &Outs = CLI.Outs;
  SmallVectorImpl<SDValue> &OutVals = CLI.OutVals;
  unsigned NumFixedArgs = 0;
  for (unsigned I = 0; I < Outs.size(); ++I) {
    const ISD::OutputArg &Out = Outs[I];
    SDValue &OutVal = OutVals[I];
    if (Out.Flags.isNest())
      fail(DL, DAG, "WebAssembly hasn't implemented nest arguments");
    if (Out.Flags.isInAlloca())
      fail(DL, DAG, "WebAssembly hasn't implemented inalloca arguments");
    if (Out.Flags.isInConsecutiveRegs())
      fail(DL, DAG, "WebAssembly hasn't implemented cons regs arguments");
    if (Out.Flags.isInConsecutiveRegsLast())
      fail(DL, DAG, "WebAssembly hasn't implemented cons regs last arguments");
    if (Out.Flags.isByVal() && Out.Flags.getByValSize() != 0) {
      auto &MFI = MF.getFrameInfo();
      int FI = MFI.CreateStackObject(Out.Flags.getByValSize(),
                                     Out.Flags.getByValAlign(),
                                     /*isSS=*/false);
      SDValue SizeNode =
          DAG.getConstant(Out.Flags.getByValSize(), DL, MVT::i32);
      SDValue FINode = DAG.getFrameIndex(FI, getPointerTy(Layout));
      Chain = DAG.getMemcpy(
          Chain, DL, FINode, OutVal, SizeNode, Out.Flags.getByValAlign(),
          /*isVolatile*/ false, /*AlwaysInline=*/false,
          /*isTailCall*/ false, MachinePointerInfo(), MachinePointerInfo());
      OutVal = FINode;
    }
    // Count the number of fixed args *after* legalization.
    NumFixedArgs += Out.IsFixed;
  }

  bool IsVarArg = CLI.IsVarArg;
  auto PtrVT = getPointerTy(Layout);

  // Analyze operands of the call, assigning locations to each operand.
  SmallVector<CCValAssign, 16> ArgLocs;
  CCState CCInfo(CallConv, IsVarArg, MF, ArgLocs, *DAG.getContext());

  if (IsVarArg) {
    // Outgoing non-fixed arguments are placed in a buffer. First
    // compute their offsets and the total amount of buffer space needed.
    for (unsigned I = NumFixedArgs; I < Outs.size(); ++I) {
      const ISD::OutputArg &Out = Outs[I];
      SDValue &Arg = OutVals[I];
      EVT VT = Arg.getValueType();
      assert(VT != MVT::iPTR && "Legalized args should be concrete");
      Type *Ty = VT.getTypeForEVT(*DAG.getContext());
      unsigned Align = std::max(Out.Flags.getOrigAlign(),
                                Layout.getABITypeAlignment(Ty));
      unsigned Offset = CCInfo.AllocateStack(Layout.getTypeAllocSize(Ty),
                                             Align);
      CCInfo.addLoc(CCValAssign::getMem(ArgLocs.size(), VT.getSimpleVT(),
                                        Offset, VT.getSimpleVT(),
                                        CCValAssign::Full));
    }
  }

  unsigned NumBytes = CCInfo.getAlignedCallFrameSize();

  SDValue FINode;
  if (IsVarArg && NumBytes) {
    // For non-fixed arguments, next emit stores to store the argument values
    // to the stack buffer at the offsets computed above.
    int FI = MF.getFrameInfo().CreateStackObject(NumBytes,
                                                 Layout.getStackAlignment(),
                                                 /*isSS=*/false);
    unsigned ValNo = 0;
    SmallVector<SDValue, 8> Chains;
    for (SDValue Arg :
         make_range(OutVals.begin() + NumFixedArgs, OutVals.end())) {
      assert(ArgLocs[ValNo].getValNo() == ValNo &&
             "ArgLocs should remain in order and only hold varargs args");
      unsigned Offset = ArgLocs[ValNo++].getLocMemOffset();
      FINode = DAG.getFrameIndex(FI, getPointerTy(Layout));
      SDValue Add = DAG.getNode(ISD::ADD, DL, PtrVT, FINode,
                                DAG.getConstant(Offset, DL, PtrVT));
      Chains.push_back(
          DAG.getStore(Chain, DL, Arg, Add,
                       MachinePointerInfo::getFixedStack(MF, FI, Offset), 0));
    }
    if (!Chains.empty())
      Chain = DAG.getNode(ISD::TokenFactor, DL, MVT::Other, Chains);
  } else if (IsVarArg) {
    FINode = DAG.getIntPtrConstant(0, DL);
  }

  if (Callee->getOpcode() == ISD::GlobalAddress) {
    // If the callee is a GlobalAddress node (quite common, every direct call
    // is) turn it into a TargetGlobalAddress node so that LowerGlobalAddress
    // doesn't at MO_GOT which is not needed for direct calls.
    GlobalAddressSDNode* GA = cast<GlobalAddressSDNode>(Callee);
    Callee = DAG.getTargetGlobalAddress(GA->getGlobal(), DL,
                                        getPointerTy(DAG.getDataLayout()),
                                        GA->getOffset());
    Callee = DAG.getNode(WebAssemblyISD::Wrapper, DL,
                         getPointerTy(DAG.getDataLayout()), Callee);
  }

  // Compute the operands for the CALLn node.
  SmallVector<SDValue, 16> Ops;
  Ops.push_back(Chain);
  Ops.push_back(Callee);

  // Add all fixed arguments. Note that for non-varargs calls, NumFixedArgs
  // isn't reliable.
  Ops.append(OutVals.begin(),
             IsVarArg ? OutVals.begin() + NumFixedArgs : OutVals.end());
  // Add a pointer to the vararg buffer.
  if (IsVarArg)
    Ops.push_back(FINode);

  SmallVector<EVT, 8> InTys;
  for (const auto &In : Ins) {
    assert(!In.Flags.isByVal() && "byval is not valid for return values");
    assert(!In.Flags.isNest() && "nest is not valid for return values");
    if (In.Flags.isInAlloca())
      fail(DL, DAG, "WebAssembly hasn't implemented inalloca return values");
    if (In.Flags.isInConsecutiveRegs())
      fail(DL, DAG, "WebAssembly hasn't implemented cons regs return values");
    if (In.Flags.isInConsecutiveRegsLast())
      fail(DL, DAG,
           "WebAssembly hasn't implemented cons regs last return values");
    // Ignore In.getOrigAlign() because all our arguments are passed in
    // registers.
    InTys.push_back(In.VT);
  }
  InTys.push_back(MVT::Other);
  SDVTList InTyList = DAG.getVTList(InTys);
  SDValue Res =
      DAG.getNode(Ins.empty() ? WebAssemblyISD::CALL0 : WebAssemblyISD::CALL1,
                  DL, InTyList, Ops);
  if (Ins.empty()) {
    Chain = Res;
  } else {
    InVals.push_back(Res);
    Chain = Res.getValue(1);
  }

  return Chain;
}

bool WebAssemblyTargetLowering::CanLowerReturn(
    CallingConv::ID /*CallConv*/, MachineFunction & /*MF*/, bool /*IsVarArg*/,
    const SmallVectorImpl<ISD::OutputArg> &Outs,
    LLVMContext & /*Context*/) const {
  // WebAssembly can't currently handle returning tuples.
  return Outs.size() <= 1;
}

SDValue WebAssemblyTargetLowering::LowerReturn(
    SDValue Chain, CallingConv::ID CallConv, bool /*IsVarArg*/,
    const SmallVectorImpl<ISD::OutputArg> &Outs,
    const SmallVectorImpl<SDValue> &OutVals, const SDLoc &DL,
    SelectionDAG &DAG) const {
  assert(Outs.size() <= 1 && "WebAssembly can only return up to one value");
  if (!callingConvSupported(CallConv))
    fail(DL, DAG, "WebAssembly doesn't support non-C calling conventions");

  SmallVector<SDValue, 4> RetOps(1, Chain);
  RetOps.append(OutVals.begin(), OutVals.end());
  Chain = DAG.getNode(WebAssemblyISD::RETURN, DL, MVT::Other, RetOps);

  // Record the number and types of the return values.
  for (const ISD::OutputArg &Out : Outs) {
    assert(!Out.Flags.isByVal() && "byval is not valid for return values");
    assert(!Out.Flags.isNest() && "nest is not valid for return values");
    assert(Out.IsFixed && "non-fixed return value is not valid");
    if (Out.Flags.isInAlloca())
      fail(DL, DAG, "WebAssembly hasn't implemented inalloca results");
    if (Out.Flags.isInConsecutiveRegs())
      fail(DL, DAG, "WebAssembly hasn't implemented cons regs results");
    if (Out.Flags.isInConsecutiveRegsLast())
      fail(DL, DAG, "WebAssembly hasn't implemented cons regs last results");
  }

  return Chain;
}

SDValue WebAssemblyTargetLowering::LowerFormalArguments(
    SDValue Chain, CallingConv::ID CallConv, bool IsVarArg,
    const SmallVectorImpl<ISD::InputArg> &Ins, const SDLoc &DL,
    SelectionDAG &DAG, SmallVectorImpl<SDValue> &InVals) const {
  if (!callingConvSupported(CallConv))
    fail(DL, DAG, "WebAssembly doesn't support non-C calling conventions");

  MachineFunction &MF = DAG.getMachineFunction();
  auto *MFI = MF.getInfo<WebAssemblyFunctionInfo>();

  // Set up the incoming ARGUMENTS value, which serves to represent the liveness
  // of the incoming values before they're represented by virtual registers.
  MF.getRegInfo().addLiveIn(WebAssembly::ARGUMENTS);

  for (const ISD::InputArg &In : Ins) {
    if (In.Flags.isInAlloca())
      fail(DL, DAG, "WebAssembly hasn't implemented inalloca arguments");
    if (In.Flags.isNest())
      fail(DL, DAG, "WebAssembly hasn't implemented nest arguments");
    if (In.Flags.isInConsecutiveRegs())
      fail(DL, DAG, "WebAssembly hasn't implemented cons regs arguments");
    if (In.Flags.isInConsecutiveRegsLast())
      fail(DL, DAG, "WebAssembly hasn't implemented cons regs last arguments");
    // Ignore In.getOrigAlign() because all our arguments are passed in
    // registers.
    InVals.push_back(In.Used ? DAG.getNode(WebAssemblyISD::ARGUMENT, DL, In.VT,
                                           DAG.getTargetConstant(InVals.size(),
                                                                 DL, MVT::i32))
                             : DAG.getUNDEF(In.VT));

    // Record the number and types of arguments.
    MFI->addParam(In.VT);
  }

  // Varargs are copied into a buffer allocated by the caller, and a pointer to
  // the buffer is passed as an argument.
  if (IsVarArg) {
    MVT PtrVT = getPointerTy(MF.getDataLayout());
    unsigned VarargVreg =
        MF.getRegInfo().createVirtualRegister(getRegClassFor(PtrVT));
    MFI->setVarargBufferVreg(VarargVreg);
    Chain = DAG.getCopyToReg(
        Chain, DL, VarargVreg,
        DAG.getNode(WebAssemblyISD::ARGUMENT, DL, PtrVT,
                    DAG.getTargetConstant(Ins.size(), DL, MVT::i32)));
    MFI->addParam(PtrVT);
  }

  // Record the number and types of arguments and results.
  SmallVector<MVT, 4> Params;
  SmallVector<MVT, 4> Results;
  computeSignatureVTs(MF.getFunction().getFunctionType(), MF.getFunction(),
                      DAG.getTarget(), Params, Results);
  for (MVT VT : Results)
    MFI->addResult(VT);
  // TODO: Use signatures in WebAssemblyMachineFunctionInfo too and unify
  // the param logic here with ComputeSignatureVTs
  assert(MFI->getParams().size() == Params.size() &&
         std::equal(MFI->getParams().begin(), MFI->getParams().end(),
                    Params.begin()));

  return Chain;
}

//===----------------------------------------------------------------------===//
//  Custom lowering hooks.
//===----------------------------------------------------------------------===//

SDValue WebAssemblyTargetLowering::LowerOperation(SDValue Op,
                                                  SelectionDAG &DAG) const {
  SDLoc DL(Op);
  switch (Op.getOpcode()) {
  default:
    llvm_unreachable("unimplemented operation lowering");
    return SDValue();
  case ISD::FrameIndex:
    return LowerFrameIndex(Op, DAG);
  case ISD::GlobalAddress:
    return LowerGlobalAddress(Op, DAG);
  case ISD::ExternalSymbol:
    return LowerExternalSymbol(Op, DAG);
  case ISD::JumpTable:
    return LowerJumpTable(Op, DAG);
  case ISD::BR_JT:
    return LowerBR_JT(Op, DAG);
  case ISD::VASTART:
    return LowerVASTART(Op, DAG);
  case ISD::BlockAddress:
  case ISD::BRIND:
    fail(DL, DAG, "WebAssembly hasn't implemented computed gotos");
    return SDValue();
  case ISD::RETURNADDR: // Probably nothing meaningful can be returned here.
    fail(DL, DAG, "WebAssembly hasn't implemented __builtin_return_address");
    return SDValue();
  case ISD::FRAMEADDR:
    return LowerFRAMEADDR(Op, DAG);
  case ISD::CopyToReg:
    return LowerCopyToReg(Op, DAG);
  case ISD::EXTRACT_VECTOR_ELT:
  case ISD::INSERT_VECTOR_ELT:
    return LowerAccessVectorElement(Op, DAG);
  case ISD::INTRINSIC_VOID:
  case ISD::INTRINSIC_WO_CHAIN:
  case ISD::INTRINSIC_W_CHAIN:
    return LowerIntrinsic(Op, DAG);
  case ISD::SIGN_EXTEND_INREG:
    return LowerSIGN_EXTEND_INREG(Op, DAG);
  case ISD::BUILD_VECTOR:
    return LowerBUILD_VECTOR(Op, DAG);
  case ISD::VECTOR_SHUFFLE:
    return LowerVECTOR_SHUFFLE(Op, DAG);
  case ISD::SHL:
  case ISD::SRA:
  case ISD::SRL:
    return LowerShift(Op, DAG);
  }
}

SDValue WebAssemblyTargetLowering::LowerCopyToReg(SDValue Op,
                                                  SelectionDAG &DAG) const {
  SDValue Src = Op.getOperand(2);
  if (isa<FrameIndexSDNode>(Src.getNode())) {
    // CopyToReg nodes don't support FrameIndex operands. Other targets select
    // the FI to some LEA-like instruction, but since we don't have that, we
    // need to insert some kind of instruction that can take an FI operand and
    // produces a value usable by CopyToReg (i.e. in a vreg). So insert a dummy
    // local.copy between Op and its FI operand.
    SDValue Chain = Op.getOperand(0);
    SDLoc DL(Op);
    unsigned Reg = cast<RegisterSDNode>(Op.getOperand(1))->getReg();
    EVT VT = Src.getValueType();
    SDValue Copy(DAG.getMachineNode(VT == MVT::i32 ? WebAssembly::COPY_I32
                                                   : WebAssembly::COPY_I64,
                                    DL, VT, Src),
                 0);
    return Op.getNode()->getNumValues() == 1
               ? DAG.getCopyToReg(Chain, DL, Reg, Copy)
               : DAG.getCopyToReg(Chain, DL, Reg, Copy,
                                  Op.getNumOperands() == 4 ? Op.getOperand(3)
                                                           : SDValue());
  }
  return SDValue();
}

SDValue WebAssemblyTargetLowering::LowerFrameIndex(SDValue Op,
                                                   SelectionDAG &DAG) const {
  int FI = cast<FrameIndexSDNode>(Op)->getIndex();
  return DAG.getTargetFrameIndex(FI, Op.getValueType());
}

SDValue WebAssemblyTargetLowering::LowerFRAMEADDR(SDValue Op,
                                                  SelectionDAG &DAG) const {
  // Non-zero depths are not supported by WebAssembly currently. Use the
  // legalizer's default expansion, which is to return 0 (what this function is
  // documented to do).
  if (Op.getConstantOperandVal(0) > 0)
    return SDValue();

  DAG.getMachineFunction().getFrameInfo().setFrameAddressIsTaken(true);
  EVT VT = Op.getValueType();
  unsigned FP =
      Subtarget->getRegisterInfo()->getFrameRegister(DAG.getMachineFunction());
  return DAG.getCopyFromReg(DAG.getEntryNode(), SDLoc(Op), FP, VT);
}

SDValue WebAssemblyTargetLowering::LowerGlobalAddress(SDValue Op,
                                                      SelectionDAG &DAG) const {
  SDLoc DL(Op);
  const auto *GA = cast<GlobalAddressSDNode>(Op);
  EVT VT = Op.getValueType();
  assert(GA->getTargetFlags() == 0 &&
         "Unexpected target flags on generic GlobalAddressSDNode");
  if (GA->getAddressSpace() != 0)
    fail(DL, DAG, "WebAssembly only expects the 0 address space");

  unsigned Flags = 0;
  if (isPositionIndependent()) {
    const GlobalValue *GV = GA->getGlobal();
    if (getTargetMachine().shouldAssumeDSOLocal(*GV->getParent(), GV)) {
      MachineFunction &MF = DAG.getMachineFunction();
      MVT PtrVT = getPointerTy(MF.getDataLayout());
      const char *BaseName;
      if (GV->getValueType()->isFunctionTy())
        BaseName = MF.createExternalSymbolName("__table_base");
      else
        BaseName = MF.createExternalSymbolName("__memory_base");
      SDValue BaseAddr =
          DAG.getNode(WebAssemblyISD::Wrapper, DL, PtrVT,
                      DAG.getTargetExternalSymbol(BaseName, PtrVT));

      SDValue SymAddr = DAG.getNode(
          WebAssemblyISD::WrapperPIC, DL, VT,
          DAG.getTargetGlobalAddress(GA->getGlobal(), DL, VT, GA->getOffset()));

      return DAG.getNode(ISD::ADD, DL, VT, BaseAddr, SymAddr);
    } else {
      Flags |= WebAssemblyII::MO_GOT;
    }
  }

  return DAG.getNode(WebAssemblyISD::Wrapper, DL, VT,
                     DAG.getTargetGlobalAddress(GA->getGlobal(), DL, VT,
                                                GA->getOffset(), Flags));
}

SDValue
WebAssemblyTargetLowering::LowerExternalSymbol(SDValue Op,
                                               SelectionDAG &DAG) const {
  SDLoc DL(Op);
  const auto *ES = cast<ExternalSymbolSDNode>(Op);
  EVT VT = Op.getValueType();
  assert(ES->getTargetFlags() == 0 &&
         "Unexpected target flags on generic ExternalSymbolSDNode");
  // Set the TargetFlags to MO_SYMBOL_FUNCTION which indicates that this is a
  // "function" symbol rather than a data symbol. We do this unconditionally
  // even though we don't know anything about the symbol other than its name,
  // because all external symbols used in target-independent SelectionDAG code
  // are for functions.
  return DAG.getNode(
      WebAssemblyISD::Wrapper, DL, VT,
      DAG.getTargetExternalSymbol(ES->getSymbol(), VT,
                                  WebAssemblyII::MO_SYMBOL_FUNCTION));
}

SDValue WebAssemblyTargetLowering::LowerJumpTable(SDValue Op,
                                                  SelectionDAG &DAG) const {
  // There's no need for a Wrapper node because we always incorporate a jump
  // table operand into a BR_TABLE instruction, rather than ever
  // materializing it in a register.
  const JumpTableSDNode *JT = cast<JumpTableSDNode>(Op);
  return DAG.getTargetJumpTable(JT->getIndex(), Op.getValueType(),
                                JT->getTargetFlags());
}

SDValue WebAssemblyTargetLowering::LowerBR_JT(SDValue Op,
                                              SelectionDAG &DAG) const {
  SDLoc DL(Op);
  SDValue Chain = Op.getOperand(0);
  const auto *JT = cast<JumpTableSDNode>(Op.getOperand(1));
  SDValue Index = Op.getOperand(2);
  assert(JT->getTargetFlags() == 0 && "WebAssembly doesn't set target flags");

  SmallVector<SDValue, 8> Ops;
  Ops.push_back(Chain);
  Ops.push_back(Index);

  MachineJumpTableInfo *MJTI = DAG.getMachineFunction().getJumpTableInfo();
  const auto &MBBs = MJTI->getJumpTables()[JT->getIndex()].MBBs;

  // Add an operand for each case.
  for (auto MBB : MBBs)
    Ops.push_back(DAG.getBasicBlock(MBB));

  // TODO: For now, we just pick something arbitrary for a default case for now.
  // We really want to sniff out the guard and put in the real default case (and
  // delete the guard).
  Ops.push_back(DAG.getBasicBlock(MBBs[0]));

  return DAG.getNode(WebAssemblyISD::BR_TABLE, DL, MVT::Other, Ops);
}

SDValue WebAssemblyTargetLowering::LowerVASTART(SDValue Op,
                                                SelectionDAG &DAG) const {
  SDLoc DL(Op);
  EVT PtrVT = getPointerTy(DAG.getMachineFunction().getDataLayout());

  auto *MFI = DAG.getMachineFunction().getInfo<WebAssemblyFunctionInfo>();
  const Value *SV = cast<SrcValueSDNode>(Op.getOperand(2))->getValue();

  SDValue ArgN = DAG.getCopyFromReg(DAG.getEntryNode(), DL,
                                    MFI->getVarargBufferVreg(), PtrVT);
  return DAG.getStore(Op.getOperand(0), DL, ArgN, Op.getOperand(1),
                      MachinePointerInfo(SV), 0);
}

SDValue WebAssemblyTargetLowering::LowerIntrinsic(SDValue Op,
                                                  SelectionDAG &DAG) const {
  MachineFunction &MF = DAG.getMachineFunction();
  unsigned IntNo;
  switch (Op.getOpcode()) {
  case ISD::INTRINSIC_VOID:
  case ISD::INTRINSIC_W_CHAIN:
    IntNo = cast<ConstantSDNode>(Op.getOperand(1))->getZExtValue();
    break;
  case ISD::INTRINSIC_WO_CHAIN:
    IntNo = cast<ConstantSDNode>(Op.getOperand(0))->getZExtValue();
    break;
  default:
    llvm_unreachable("Invalid intrinsic");
  }
  SDLoc DL(Op);

  switch (IntNo) {
  default:
    return SDValue(); // Don't custom lower most intrinsics.

  case Intrinsic::wasm_lsda: {
    EVT VT = Op.getValueType();
    const TargetLowering &TLI = DAG.getTargetLoweringInfo();
    MVT PtrVT = TLI.getPointerTy(DAG.getDataLayout());
    auto &Context = MF.getMMI().getContext();
    MCSymbol *S = Context.getOrCreateSymbol(Twine("GCC_except_table") +
                                            Twine(MF.getFunctionNumber()));
    return DAG.getNode(WebAssemblyISD::Wrapper, DL, VT,
                       DAG.getMCSymbol(S, PtrVT));
  }

  case Intrinsic::wasm_throw: {
    // We only support C++ exceptions for now
    int Tag = cast<ConstantSDNode>(Op.getOperand(2).getNode())->getZExtValue();
    if (Tag != CPP_EXCEPTION)
      llvm_unreachable("Invalid tag!");
    const TargetLowering &TLI = DAG.getTargetLoweringInfo();
    MVT PtrVT = TLI.getPointerTy(DAG.getDataLayout());
    const char *SymName = MF.createExternalSymbolName("__cpp_exception");
    SDValue SymNode =
        DAG.getNode(WebAssemblyISD::Wrapper, DL, PtrVT,
                    DAG.getTargetExternalSymbol(
                        SymName, PtrVT, WebAssemblyII::MO_SYMBOL_EVENT));
    return DAG.getNode(WebAssemblyISD::THROW, DL,
                       MVT::Other, // outchain type
                       {
                           Op.getOperand(0), // inchain
                           SymNode,          // exception symbol
                           Op.getOperand(3)  // thrown value
                       });
  }
  }
}

SDValue
WebAssemblyTargetLowering::LowerSIGN_EXTEND_INREG(SDValue Op,
                                                  SelectionDAG &DAG) const {
  // If sign extension operations are disabled, allow sext_inreg only if operand
  // is a vector extract. SIMD does not depend on sign extension operations, but
  // allowing sext_inreg in this context lets us have simple patterns to select
  // extract_lane_s instructions. Expanding sext_inreg everywhere would be
  // simpler in this file, but would necessitate large and brittle patterns to
  // undo the expansion and select extract_lane_s instructions.
  assert(!Subtarget->hasSignExt() && Subtarget->hasSIMD128());
  if (Op.getOperand(0).getOpcode() == ISD::EXTRACT_VECTOR_ELT)
    return Op;
  // Otherwise expand
  return SDValue();
}

SDValue WebAssemblyTargetLowering::LowerBUILD_VECTOR(SDValue Op,
                                                     SelectionDAG &DAG) const {
  SDLoc DL(Op);
  const EVT VecT = Op.getValueType();
  const EVT LaneT = Op.getOperand(0).getValueType();
  const size_t Lanes = Op.getNumOperands();
  auto IsConstant = [](const SDValue &V) {
    return V.getOpcode() == ISD::Constant || V.getOpcode() == ISD::ConstantFP;
  };

  // Find the most common operand, which is approximately the best to splat
  using Entry = std::pair<SDValue, size_t>;
  SmallVector<Entry, 16> ValueCounts;
  size_t NumConst = 0, NumDynamic = 0;
  for (const SDValue &Lane : Op->op_values()) {
    if (Lane.isUndef()) {
      continue;
    } else if (IsConstant(Lane)) {
      NumConst++;
    } else {
      NumDynamic++;
    }
    auto CountIt = std::find_if(ValueCounts.begin(), ValueCounts.end(),
                                [&Lane](Entry A) { return A.first == Lane; });
    if (CountIt == ValueCounts.end()) {
      ValueCounts.emplace_back(Lane, 1);
    } else {
      CountIt->second++;
    }
  }
  auto CommonIt =
      std::max_element(ValueCounts.begin(), ValueCounts.end(),
                       [](Entry A, Entry B) { return A.second < B.second; });
  assert(CommonIt != ValueCounts.end() && "Unexpected all-undef build_vector");
  SDValue SplatValue = CommonIt->first;
  size_t NumCommon = CommonIt->second;

  // If v128.const is available, consider using it instead of a splat
  if (Subtarget->hasUnimplementedSIMD128()) {
    // {i32,i64,f32,f64}.const opcode, and value
    const size_t ConstBytes = 1 + std::max(size_t(4), 16 / Lanes);
    // SIMD prefix and opcode
    const size_t SplatBytes = 2;
    const size_t SplatConstBytes = SplatBytes + ConstBytes;
    // SIMD prefix, opcode, and lane index
    const size_t ReplaceBytes = 3;
    const size_t ReplaceConstBytes = ReplaceBytes + ConstBytes;
    // SIMD prefix, v128.const opcode, and 128-bit value
    const size_t VecConstBytes = 18;
    // Initial v128.const and a replace_lane for each non-const operand
    const size_t ConstInitBytes = VecConstBytes + NumDynamic * ReplaceBytes;
    // Initial splat and all necessary replace_lanes
    const size_t SplatInitBytes =
        IsConstant(SplatValue)
            // Initial constant splat
            ? (SplatConstBytes +
               // Constant replace_lanes
               (NumConst - NumCommon) * ReplaceConstBytes +
               // Dynamic replace_lanes
               (NumDynamic * ReplaceBytes))
            // Initial dynamic splat
            : (SplatBytes +
               // Constant replace_lanes
               (NumConst * ReplaceConstBytes) +
               // Dynamic replace_lanes
               (NumDynamic - NumCommon) * ReplaceBytes);
    if (ConstInitBytes < SplatInitBytes) {
      // Create build_vector that will lower to initial v128.const
      SmallVector<SDValue, 16> ConstLanes;
      for (const SDValue &Lane : Op->op_values()) {
        if (IsConstant(Lane)) {
          ConstLanes.push_back(Lane);
        } else if (LaneT.isFloatingPoint()) {
          ConstLanes.push_back(DAG.getConstantFP(0, DL, LaneT));
        } else {
          ConstLanes.push_back(DAG.getConstant(0, DL, LaneT));
        }
      }
      SDValue Result = DAG.getBuildVector(VecT, DL, ConstLanes);
      // Add replace_lane instructions for non-const lanes
      for (size_t I = 0; I < Lanes; ++I) {
        const SDValue &Lane = Op->getOperand(I);
        if (!Lane.isUndef() && !IsConstant(Lane))
          Result = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, VecT, Result, Lane,
                               DAG.getConstant(I, DL, MVT::i32));
      }
      return Result;
    }
  }
  // Use a splat for the initial vector
  SDValue Result = DAG.getSplatBuildVector(VecT, DL, SplatValue);
  // Add replace_lane instructions for other values
  for (size_t I = 0; I < Lanes; ++I) {
    const SDValue &Lane = Op->getOperand(I);
    if (Lane != SplatValue)
      Result = DAG.getNode(ISD::INSERT_VECTOR_ELT, DL, VecT, Result, Lane,
                           DAG.getConstant(I, DL, MVT::i32));
  }
  return Result;
}

SDValue
WebAssemblyTargetLowering::LowerVECTOR_SHUFFLE(SDValue Op,
                                               SelectionDAG &DAG) const {
  SDLoc DL(Op);
  ArrayRef<int> Mask = cast<ShuffleVectorSDNode>(Op.getNode())->getMask();
  MVT VecType = Op.getOperand(0).getSimpleValueType();
  assert(VecType.is128BitVector() && "Unexpected shuffle vector type");
  size_t LaneBytes = VecType.getVectorElementType().getSizeInBits() / 8;

  // Space for two vector args and sixteen mask indices
  SDValue Ops[18];
  size_t OpIdx = 0;
  Ops[OpIdx++] = Op.getOperand(0);
  Ops[OpIdx++] = Op.getOperand(1);

  // Expand mask indices to byte indices and materialize them as operands
  for (int M : Mask) {
    for (size_t J = 0; J < LaneBytes; ++J) {
      // Lower undefs (represented by -1 in mask) to zero
      uint64_t ByteIndex = M == -1 ? 0 : (uint64_t)M * LaneBytes + J;
      Ops[OpIdx++] = DAG.getConstant(ByteIndex, DL, MVT::i32);
    }
  }

  return DAG.getNode(WebAssemblyISD::SHUFFLE, DL, Op.getValueType(), Ops);
}

SDValue
WebAssemblyTargetLowering::LowerAccessVectorElement(SDValue Op,
                                                    SelectionDAG &DAG) const {
  // Allow constant lane indices, expand variable lane indices
  SDNode *IdxNode = Op.getOperand(Op.getNumOperands() - 1).getNode();
  if (isa<ConstantSDNode>(IdxNode) || IdxNode->isUndef())
    return Op;
  else
    // Perform default expansion
    return SDValue();
}

static SDValue unrollVectorShift(SDValue Op, SelectionDAG &DAG) {
  EVT LaneT = Op.getSimpleValueType().getVectorElementType();
  // 32-bit and 64-bit unrolled shifts will have proper semantics
  if (LaneT.bitsGE(MVT::i32))
    return DAG.UnrollVectorOp(Op.getNode());
  // Otherwise mask the shift value to get proper semantics from 32-bit shift
  SDLoc DL(Op);
  SDValue ShiftVal = Op.getOperand(1);
  uint64_t MaskVal = LaneT.getSizeInBits() - 1;
  SDValue MaskedShiftVal = DAG.getNode(
      ISD::AND,                    // mask opcode
      DL, ShiftVal.getValueType(), // masked value type
      ShiftVal,                    // original shift value operand
      DAG.getConstant(MaskVal, DL, ShiftVal.getValueType()) // mask operand
  );

  return DAG.UnrollVectorOp(
      DAG.getNode(Op.getOpcode(),        // original shift opcode
                  DL, Op.getValueType(), // original return type
                  Op.getOperand(0),      // original vector operand,
                  MaskedShiftVal         // new masked shift value operand
                  )
          .getNode());
}

SDValue WebAssemblyTargetLowering::LowerShift(SDValue Op,
                                              SelectionDAG &DAG) const {
  SDLoc DL(Op);

  // Only manually lower vector shifts
  assert(Op.getSimpleValueType().isVector());

  // Expand all vector shifts until V8 fixes its implementation
  // TODO: remove this once V8 is fixed
  if (!Subtarget->hasUnimplementedSIMD128())
    return unrollVectorShift(Op, DAG);

  // Unroll non-splat vector shifts
  BuildVectorSDNode *ShiftVec;
  SDValue SplatVal;
  if (!(ShiftVec = dyn_cast<BuildVectorSDNode>(Op.getOperand(1).getNode())) ||
      !(SplatVal = ShiftVec->getSplatValue()))
    return unrollVectorShift(Op, DAG);

  // All splats except i64x2 const splats are handled by patterns
  auto *SplatConst = dyn_cast<ConstantSDNode>(SplatVal);
  if (!SplatConst || Op.getSimpleValueType() != MVT::v2i64)
    return Op;

  // i64x2 const splats are custom lowered to avoid unnecessary wraps
  unsigned Opcode;
  switch (Op.getOpcode()) {
  case ISD::SHL:
    Opcode = WebAssemblyISD::VEC_SHL;
    break;
  case ISD::SRA:
    Opcode = WebAssemblyISD::VEC_SHR_S;
    break;
  case ISD::SRL:
    Opcode = WebAssemblyISD::VEC_SHR_U;
    break;
  default:
    llvm_unreachable("unexpected opcode");
  }
  APInt Shift = SplatConst->getAPIntValue().zextOrTrunc(32);
  return DAG.getNode(Opcode, DL, Op.getValueType(), Op.getOperand(0),
                     DAG.getConstant(Shift, DL, MVT::i32));
}

//===----------------------------------------------------------------------===//
//                          WebAssembly Optimization Hooks
//===----------------------------------------------------------------------===//
