//===- Local.h - Functions to perform local transformations -----*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This family of functions perform various local transformations to the
// program.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_ANALYSIS_UTILS_LOCAL_H
#define LLVM_ANALYSIS_UTILS_LOCAL_H

#include "llvm/IR/DataLayout.h"
#include "llvm/IR/GetElementPtrTypeIterator.h"

namespace llvm {

/// Given a getelementptr instruction/constantexpr, emit the code necessary to
/// compute the offset from the base pointer (without adding in the base
/// pointer). Return the result as a signed integer of intptr size.
/// When NoAssumptions is true, no assumptions about index computation not
/// overflowing is made.
template <typename IRBuilderTy>
Value *EmitGEPOffset(IRBuilderTy *Builder, const DataLayout &DL, User *GEP,
                     bool NoAssumptions = false) {
  GEPOperator *GEPOp = cast<GEPOperator>(GEP);
  Type *IntPtrTy = DL.getIntPtrType(GEP->getType());
  Value *Result = Constant::getNullValue(IntPtrTy);

  // If the GEP is inbounds, we know that none of the addressing operations will
  // overflow in an unsigned sense.
  bool isInBounds = GEPOp->isInBounds() && !NoAssumptions;

  // Build a mask for high order bits.
  unsigned IntPtrWidth = IntPtrTy->getScalarType()->getIntegerBitWidth();
  uint64_t PtrSizeMask =
      std::numeric_limits<uint64_t>::max() >> (64 - IntPtrWidth);

  gep_type_iterator GTI = gep_type_begin(GEP);
  for (User::op_iterator i = GEP->op_begin() + 1, e = GEP->op_end(); i != e;
       ++i, ++GTI) {
    Value *Op = *i;
    uint64_t Size = DL.getTypeAllocSize(GTI.getIndexedType()) & PtrSizeMask;
    if (Constant *OpC = dyn_cast<Constant>(Op)) {
      if (OpC->isZeroValue())
        continue;

      // Handle a struct index, which adds its field offset to the pointer.
      if (StructType *STy = GTI.getStructTypeOrNull()) {
        uint64_t OpValue = OpC->getUniqueInteger().getZExtValue();
        Size = DL.getStructLayout(STy)->getElementOffset(OpValue);

        if (Size)
          Result = Builder->CreateAdd(Result, ConstantInt::get(IntPtrTy, Size),
                                      GEP->getName()+".offs");
        continue;
      }

      // Splat the constant if needed.
      if (IntPtrTy->isVectorTy() && !OpC->getType()->isVectorTy())
        OpC = ConstantVector::getSplat(IntPtrTy->getVectorNumElements(), OpC);

      Constant *Scale = ConstantInt::get(IntPtrTy, Size);
      Constant *OC = ConstantExpr::getIntegerCast(OpC, IntPtrTy, true /*SExt*/);
      Scale = ConstantExpr::getMul(OC, Scale, isInBounds/*NUW*/);
      // Emit an add instruction.
      Result = Builder->CreateAdd(Result, Scale, GEP->getName()+".offs");
      continue;
    }

    // Splat the index if needed.
    if (IntPtrTy->isVectorTy() && !Op->getType()->isVectorTy())
      Op = Builder->CreateVectorSplat(IntPtrTy->getVectorNumElements(), Op);

    // Convert to correct type.
    if (Op->getType() != IntPtrTy)
      Op = Builder->CreateIntCast(Op, IntPtrTy, true, Op->getName()+".c");
    if (Size != 1) {
      // We'll let instcombine(mul) convert this to a shl if possible.
      Op = Builder->CreateMul(Op, ConstantInt::get(IntPtrTy, Size),
                              GEP->getName()+".idx", isInBounds /*NUW*/);
    }

    // Emit an add instruction.
    Result = Builder->CreateAdd(Op, Result, GEP->getName()+".offs");
  }
  return Result;
}

}

#endif // LLVM_TRANSFORMS_UTILS_LOCAL_H
