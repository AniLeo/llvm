//===- AMDGPULegalizerInfo.cpp -----------------------------------*- C++ -*-==//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
/// \file
/// This file implements the targeting of the Machinelegalizer class for
/// AMDGPU.
/// \todo This should be generated by TableGen.
//===----------------------------------------------------------------------===//

#include "AMDGPU.h"
#include "AMDGPULegalizerInfo.h"
#include "AMDGPUTargetMachine.h"
#include "llvm/CodeGen/TargetOpcodes.h"
#include "llvm/CodeGen/ValueTypes.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Type.h"
#include "llvm/Support/Debug.h"

using namespace llvm;
using namespace LegalizeActions;

AMDGPULegalizerInfo::AMDGPULegalizerInfo(const GCNSubtarget &ST,
                                         const GCNTargetMachine &TM) {
  using namespace TargetOpcode;

  auto GetAddrSpacePtr = [&TM](unsigned AS) {
    return LLT::pointer(AS, TM.getPointerSizeInBits(AS));
  };

  const LLT S1 = LLT::scalar(1);
  const LLT S32 = LLT::scalar(32);
  const LLT S64 = LLT::scalar(64);
  const LLT S512 = LLT::scalar(512);

  const LLT V2S16 = LLT::vector(2, 16);

  const LLT V2S32 = LLT::vector(2, 32);
  const LLT V3S32 = LLT::vector(3, 32);
  const LLT V4S32 = LLT::vector(4, 32);
  const LLT V5S32 = LLT::vector(5, 32);
  const LLT V6S32 = LLT::vector(6, 32);
  const LLT V7S32 = LLT::vector(7, 32);
  const LLT V8S32 = LLT::vector(8, 32);
  const LLT V9S32 = LLT::vector(9, 32);
  const LLT V10S32 = LLT::vector(10, 32);
  const LLT V11S32 = LLT::vector(11, 32);
  const LLT V12S32 = LLT::vector(12, 32);
  const LLT V13S32 = LLT::vector(13, 32);
  const LLT V14S32 = LLT::vector(14, 32);
  const LLT V15S32 = LLT::vector(15, 32);
  const LLT V16S32 = LLT::vector(16, 32);

  const LLT V2S64 = LLT::vector(2, 64);
  const LLT V3S64 = LLT::vector(3, 64);
  const LLT V4S64 = LLT::vector(4, 64);
  const LLT V5S64 = LLT::vector(5, 64);
  const LLT V6S64 = LLT::vector(6, 64);
  const LLT V7S64 = LLT::vector(7, 64);
  const LLT V8S64 = LLT::vector(8, 64);

  std::initializer_list<LLT> AllS32Vectors =
    {V2S32, V3S32, V4S32, V5S32, V6S32, V7S32, V8S32,
     V9S32, V10S32, V11S32, V12S32, V13S32, V14S32, V15S32, V16S32};
  std::initializer_list<LLT> AllS64Vectors =
    {V2S64, V3S64, V4S64, V5S64, V6S64, V7S64, V8S64};

  const LLT GlobalPtr = GetAddrSpacePtr(AMDGPUAS::GLOBAL_ADDRESS);
  const LLT ConstantPtr = GetAddrSpacePtr(AMDGPUAS::CONSTANT_ADDRESS);
  const LLT LocalPtr = GetAddrSpacePtr(AMDGPUAS::LOCAL_ADDRESS);
  const LLT FlatPtr = GetAddrSpacePtr(AMDGPUAS::FLAT_ADDRESS);
  const LLT PrivatePtr = GetAddrSpacePtr(AMDGPUAS::PRIVATE_ADDRESS);

  const LLT CodePtr = FlatPtr;

  const LLT AddrSpaces[] = {
    GlobalPtr,
    ConstantPtr,
    LocalPtr,
    FlatPtr,
    PrivatePtr
  };

  setAction({G_ADD, S32}, Legal);
  setAction({G_ASHR, S32}, Legal);
  setAction({G_SUB, S32}, Legal);
  setAction({G_MUL, S32}, Legal);

  // FIXME: 64-bit ones only legal for scalar
  getActionDefinitionsBuilder({G_AND, G_OR, G_XOR})
    .legalFor({S32, S1, S64, V2S32});

  getActionDefinitionsBuilder({G_UADDO, G_SADDO, G_USUBO, G_SSUBO,
                               G_UADDE, G_SADDE, G_USUBE, G_SSUBE})
    .legalFor({{S32, S1}});

  setAction({G_BITCAST, V2S16}, Legal);
  setAction({G_BITCAST, 1, S32}, Legal);

  setAction({G_BITCAST, S32}, Legal);
  setAction({G_BITCAST, 1, V2S16}, Legal);

  getActionDefinitionsBuilder(G_FCONSTANT)
    .legalFor({S32, S64});

  // G_IMPLICIT_DEF is a no-op so we can make it legal for any value type that
  // can fit in a register.
  // FIXME: We need to legalize several more operations before we can add
  // a test case for size > 512.
  getActionDefinitionsBuilder(G_IMPLICIT_DEF)
    .legalIf([=](const LegalityQuery &Query) {
        return Query.Types[0].getSizeInBits() <= 512;
    })
    .clampScalar(0, S1, S512);

  getActionDefinitionsBuilder(G_CONSTANT)
    .legalFor({S1, S32, S64});

  // FIXME: i1 operands to intrinsics should always be legal, but other i1
  // values may not be legal.  We need to figure out how to distinguish
  // between these two scenarios.
  setAction({G_CONSTANT, S1}, Legal);

  setAction({G_FRAME_INDEX, PrivatePtr}, Legal);

  getActionDefinitionsBuilder(
    { G_FADD, G_FMUL, G_FNEG, G_FABS, G_FMA})
    .legalFor({S32, S64});

  getActionDefinitionsBuilder(G_FPTRUNC)
    .legalFor({{S32, S64}});

  // Use actual fsub instruction
  setAction({G_FSUB, S32}, Legal);

  // Must use fadd + fneg
  setAction({G_FSUB, S64}, Lower);

  setAction({G_FCMP, S1}, Legal);
  setAction({G_FCMP, 1, S32}, Legal);
  setAction({G_FCMP, 1, S64}, Legal);

  setAction({G_ZEXT, S64}, Legal);
  setAction({G_ZEXT, 1, S32}, Legal);

  setAction({G_SEXT, S64}, Legal);
  setAction({G_SEXT, 1, S32}, Legal);

  setAction({G_ANYEXT, S64}, Legal);
  setAction({G_ANYEXT, 1, S32}, Legal);

  setAction({G_FPTOSI, S32}, Legal);
  setAction({G_FPTOSI, 1, S32}, Legal);

  setAction({G_SITOFP, S32}, Legal);
  setAction({G_SITOFP, 1, S32}, Legal);

  setAction({G_UITOFP, S32}, Legal);
  setAction({G_UITOFP, 1, S32}, Legal);

  setAction({G_FPTOUI, S32}, Legal);
  setAction({G_FPTOUI, 1, S32}, Legal);

  setAction({G_FPOW, S32}, Legal);
  setAction({G_FEXP2, S32}, Legal);
  setAction({G_FLOG2, S32}, Legal);

  getActionDefinitionsBuilder({G_INTRINSIC_TRUNC, G_INTRINSIC_ROUND})
    .legalFor({S32, S64});

  for (LLT PtrTy : AddrSpaces) {
    LLT IdxTy = LLT::scalar(PtrTy.getSizeInBits());
    setAction({G_GEP, PtrTy}, Legal);
    setAction({G_GEP, 1, IdxTy}, Legal);
  }

  setAction({G_BLOCK_ADDR, CodePtr}, Legal);

  setAction({G_ICMP, S1}, Legal);
  setAction({G_ICMP, 1, S32}, Legal);

  setAction({G_CTLZ, S32}, Legal);
  setAction({G_CTLZ_ZERO_UNDEF, S32}, Legal);
  setAction({G_CTTZ, S32}, Legal);
  setAction({G_CTTZ_ZERO_UNDEF, S32}, Legal);
  setAction({G_BSWAP, S32}, Legal);
  setAction({G_CTPOP, S32}, Legal);

  getActionDefinitionsBuilder(G_INTTOPTR)
    .legalIf([](const LegalityQuery &Query) {
      return true;
    });

  getActionDefinitionsBuilder(G_PTRTOINT)
    .legalIf([](const LegalityQuery &Query) {
      return true;
    });

  getActionDefinitionsBuilder({G_LOAD, G_STORE})
    .legalIf([=, &ST](const LegalityQuery &Query) {
        const LLT &Ty0 = Query.Types[0];

        // TODO: Decompose private loads into 4-byte components.
        // TODO: Illegal flat loads on SI
        switch (Ty0.getSizeInBits()) {
        case 32:
        case 64:
        case 128:
          return true;

        case 96:
          // XXX hasLoadX3
          return (ST.getGeneration() >= AMDGPUSubtarget::SEA_ISLANDS);

        case 256:
        case 512:
          // TODO: constant loads
        default:
          return false;
        }
      });


  auto &Atomics = getActionDefinitionsBuilder(
    {G_ATOMICRMW_XCHG, G_ATOMICRMW_ADD, G_ATOMICRMW_SUB,
     G_ATOMICRMW_AND, G_ATOMICRMW_OR, G_ATOMICRMW_XOR,
     G_ATOMICRMW_MAX, G_ATOMICRMW_MIN, G_ATOMICRMW_UMAX,
     G_ATOMICRMW_UMIN, G_ATOMIC_CMPXCHG})
    .legalFor({{S32, GlobalPtr}, {S32, LocalPtr},
               {S64, GlobalPtr}, {S64, LocalPtr}});
  if (ST.hasFlatAddressSpace()) {
    Atomics.legalFor({{S32, FlatPtr}, {S64, FlatPtr}});
  }

  setAction({G_SELECT, S32}, Legal);
  setAction({G_SELECT, 1, S1}, Legal);

  setAction({G_SHL, S32}, Legal);


  // FIXME: When RegBankSelect inserts copies, it will only create new
  // registers with scalar types.  This means we can end up with
  // G_LOAD/G_STORE/G_GEP instruction with scalar types for their pointer
  // operands.  In assert builds, the instruction selector will assert
  // if it sees a generic instruction which isn't legal, so we need to
  // tell it that scalar types are legal for pointer operands
  setAction({G_GEP, S64}, Legal);

  for (unsigned Op : {G_EXTRACT_VECTOR_ELT, G_INSERT_VECTOR_ELT}) {
    getActionDefinitionsBuilder(Op)
      .legalIf([=](const LegalityQuery &Query) {
          const LLT &VecTy = Query.Types[1];
          const LLT &IdxTy = Query.Types[2];
          return VecTy.getSizeInBits() % 32 == 0 &&
            VecTy.getSizeInBits() <= 512 &&
            IdxTy.getSizeInBits() == 32;
        });
  }

  // FIXME: Doesn't handle extract of illegal sizes.
  getActionDefinitionsBuilder({G_EXTRACT, G_INSERT})
    .legalIf([=](const LegalityQuery &Query) {
        const LLT &Ty0 = Query.Types[0];
        const LLT &Ty1 = Query.Types[1];
        return (Ty0.getSizeInBits() % 32 == 0) &&
               (Ty1.getSizeInBits() % 32 == 0);
      });

  getActionDefinitionsBuilder(G_BUILD_VECTOR)
    .legalForCartesianProduct(AllS32Vectors, {S32})
    .legalForCartesianProduct(AllS64Vectors, {S64})
    .clampNumElements(0, V16S32, V16S32)
    .clampNumElements(0, V2S64, V8S64)
    .minScalarSameAs(1, 0);

  // Merge/Unmerge
  for (unsigned Op : {G_MERGE_VALUES, G_UNMERGE_VALUES}) {
    unsigned BigTyIdx = Op == G_MERGE_VALUES ? 0 : 1;
    unsigned LitTyIdx = Op == G_MERGE_VALUES ? 1 : 0;

    getActionDefinitionsBuilder(Op)
      .legalIf([=](const LegalityQuery &Query) {
          const LLT &BigTy = Query.Types[BigTyIdx];
          const LLT &LitTy = Query.Types[LitTyIdx];
          return BigTy.getSizeInBits() % 32 == 0 &&
                 LitTy.getSizeInBits() % 32 == 0 &&
                 BigTy.getSizeInBits() <= 512;
        })
      // Any vectors left are the wrong size. Scalarize them.
      .fewerElementsIf([](const LegalityQuery &Query) { return true; },
                       [](const LegalityQuery &Query) {
                         return std::make_pair(
                           0, Query.Types[0].getElementType());
                       })
      .fewerElementsIf([](const LegalityQuery &Query) { return true; },
                       [](const LegalityQuery &Query) {
                         return std::make_pair(
                           1, Query.Types[1].getElementType());
                       });

  }

  computeTables();
  verify(*ST.getInstrInfo());
}
