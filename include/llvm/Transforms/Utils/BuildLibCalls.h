//===- BuildLibCalls.h - Utility builder for libcalls -----------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file exposes an interface to build some C language libcalls for
// optimization passes that need to call the various functions.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_TRANSFORMS_UTILS_BUILDLIBCALLS_H
#define LLVM_TRANSFORMS_UTILS_BUILDLIBCALLS_H

#include "llvm/Analysis/TargetLibraryInfo.h"

namespace llvm {
  class Value;
  class DataLayout;
  class IRBuilderBase;

  /// Analyze the name and prototype of the given function and set any
  /// applicable attributes.
  /// If the library function is unavailable, this doesn't modify it.
  ///
  /// Returns true if any attributes were set and false otherwise.
  bool inferLibFuncAttributes(Function &F, const TargetLibraryInfo &TLI);
  bool inferLibFuncAttributes(Module *M, StringRef Name, const TargetLibraryInfo &TLI);

  /// Check whether the overloaded floating point function
  /// corresponding to \a Ty is available.
  bool hasFloatFn(const TargetLibraryInfo *TLI, Type *Ty,
                  LibFunc DoubleFn, LibFunc FloatFn, LibFunc LongDoubleFn);

  /// Get the name of the overloaded floating point function
  /// corresponding to \a Ty.
  StringRef getFloatFnName(const TargetLibraryInfo *TLI, Type *Ty,
                           LibFunc DoubleFn, LibFunc FloatFn,
                           LibFunc LongDoubleFn);

  /// Return V if it is an i8*, otherwise cast it to i8*.
  Value *castToCStr(Value *V, IRBuilderBase &B);

  /// Emit a call to the strlen function to the builder, for the specified
  /// pointer. Ptr is required to be some pointer type, and the return value has
  /// 'intptr_t' type.
  Value *emitStrLen(Value *Ptr, IRBuilderBase &B, const DataLayout &DL,
                    const TargetLibraryInfo *TLI);

  /// Emit a call to the strdup function to the builder, for the specified
  /// pointer. Ptr is required to be some pointer type, and the return value has
  /// 'i8*' type.
  Value *emitStrDup(Value *Ptr, IRBuilderBase &B, const TargetLibraryInfo *TLI);

  /// Emit a call to the strnlen function to the builder, for the specified
  /// pointer. Ptr is required to be some pointer type, MaxLen must be of size_t
  /// type, and the return value has 'intptr_t' type.
  Value *emitStrNLen(Value *Ptr, Value *MaxLen, IRBuilderBase &B,
                     const DataLayout &DL, const TargetLibraryInfo *TLI);

  /// Emit a call to the strchr function to the builder, for the specified
  /// pointer and character. Ptr is required to be some pointer type, and the
  /// return value has 'i8*' type.
  Value *emitStrChr(Value *Ptr, char C, IRBuilderBase &B,
                    const TargetLibraryInfo *TLI);

  /// Emit a call to the strncmp function to the builder.
  Value *emitStrNCmp(Value *Ptr1, Value *Ptr2, Value *Len, IRBuilderBase &B,
                     const DataLayout &DL, const TargetLibraryInfo *TLI);

  /// Emit a call to the strcpy function to the builder, for the specified
  /// pointer arguments.
  Value *emitStrCpy(Value *Dst, Value *Src, IRBuilderBase &B,
                    const TargetLibraryInfo *TLI);

  /// Emit a call to the stpcpy function to the builder, for the specified
  /// pointer arguments.
  Value *emitStpCpy(Value *Dst, Value *Src, IRBuilderBase &B,
                    const TargetLibraryInfo *TLI);

  /// Emit a call to the strncpy function to the builder, for the specified
  /// pointer arguments and length.
  Value *emitStrNCpy(Value *Dst, Value *Src, Value *Len, IRBuilderBase &B,
                     const TargetLibraryInfo *TLI);

  /// Emit a call to the stpncpy function to the builder, for the specified
  /// pointer arguments and length.
  Value *emitStpNCpy(Value *Dst, Value *Src, Value *Len, IRBuilderBase &B,
                     const TargetLibraryInfo *TLI);

  /// Emit a call to the __memcpy_chk function to the builder. This expects that
  /// the Len and ObjSize have type 'intptr_t' and Dst/Src are pointers.
  Value *emitMemCpyChk(Value *Dst, Value *Src, Value *Len, Value *ObjSize,
                       IRBuilderBase &B, const DataLayout &DL,
                       const TargetLibraryInfo *TLI);

  /// Emit a call to the memchr function. This assumes that Ptr is a pointer,
  /// Val is an i32 value, and Len is an 'intptr_t' value.
  Value *emitMemChr(Value *Ptr, Value *Val, Value *Len, IRBuilderBase &B,
                    const DataLayout &DL, const TargetLibraryInfo *TLI);

  /// Emit a call to the memcmp function.
  Value *emitMemCmp(Value *Ptr1, Value *Ptr2, Value *Len, IRBuilderBase &B,
                    const DataLayout &DL, const TargetLibraryInfo *TLI);

  /// Emit a call to the bcmp function.
  Value *emitBCmp(Value *Ptr1, Value *Ptr2, Value *Len, IRBuilderBase &B,
                  const DataLayout &DL, const TargetLibraryInfo *TLI);

  /// Emit a call to the memccpy function.
  Value *emitMemCCpy(Value *Ptr1, Value *Ptr2, Value *Val, Value *Len,
                     IRBuilderBase &B, const TargetLibraryInfo *TLI);

  /// Emit a call to the snprintf function.
  Value *emitSNPrintf(Value *Dest, Value *Size, Value *Fmt,
                      ArrayRef<Value *> Args, IRBuilderBase &B,
                      const TargetLibraryInfo *TLI);

  /// Emit a call to the sprintf function.
  Value *emitSPrintf(Value *Dest, Value *Fmt, ArrayRef<Value *> VariadicArgs,
                     IRBuilderBase &B, const TargetLibraryInfo *TLI);

  /// Emit a call to the strcat function.
  Value *emitStrCat(Value *Dest, Value *Src, IRBuilderBase &B,
                    const TargetLibraryInfo *TLI);

  /// Emit a call to the strlcpy function.
  Value *emitStrLCpy(Value *Dest, Value *Src, Value *Size, IRBuilderBase &B,
                     const TargetLibraryInfo *TLI);

  /// Emit a call to the strlcat function.
  Value *emitStrLCat(Value *Dest, Value *Src, Value *Size, IRBuilderBase &B,
                     const TargetLibraryInfo *TLI);

  /// Emit a call to the strncat function.
  Value *emitStrNCat(Value *Dest, Value *Src, Value *Size, IRBuilderBase &B,
                     const TargetLibraryInfo *TLI);

  /// Emit a call to the vsnprintf function.
  Value *emitVSNPrintf(Value *Dest, Value *Size, Value *Fmt, Value *VAList,
                       IRBuilderBase &B, const TargetLibraryInfo *TLI);

  /// Emit a call to the vsprintf function.
  Value *emitVSPrintf(Value *Dest, Value *Fmt, Value *VAList, IRBuilderBase &B,
                      const TargetLibraryInfo *TLI);

  /// Emit a call to the unary function named 'Name' (e.g.  'floor'). This
  /// function is known to take a single of type matching 'Op' and returns one
  /// value with the same type. If 'Op' is a long double, 'l' is added as the
  /// suffix of name, if 'Op' is a float, we add a 'f' suffix.
  Value *emitUnaryFloatFnCall(Value *Op, StringRef Name, IRBuilderBase &B,
                              const AttributeList &Attrs);

  /// Emit a call to the unary function DoubleFn, FloatFn or LongDoubleFn,
  /// depending of the type of Op.
  Value *emitUnaryFloatFnCall(Value *Op, const TargetLibraryInfo *TLI,
                              LibFunc DoubleFn, LibFunc FloatFn,
                              LibFunc LongDoubleFn, IRBuilderBase &B,
                              const AttributeList &Attrs);

  /// Emit a call to the binary function named 'Name' (e.g. 'fmin'). This
  /// function is known to take type matching 'Op1' and 'Op2' and return one
  /// value with the same type. If 'Op1/Op2' are long double, 'l' is added as
  /// the suffix of name, if 'Op1/Op2' are float, we add a 'f' suffix.
  Value *emitBinaryFloatFnCall(Value *Op1, Value *Op2, StringRef Name,
                               IRBuilderBase &B, const AttributeList &Attrs);

  /// Emit a call to the binary function DoubleFn, FloatFn or LongDoubleFn,
  /// depending of the type of Op1.
  Value *emitBinaryFloatFnCall(Value *Op1, Value *Op2,
                               const TargetLibraryInfo *TLI, LibFunc DoubleFn,
                               LibFunc FloatFn, LibFunc LongDoubleFn,
                               IRBuilderBase &B, const AttributeList &Attrs);

  /// Emit a call to the putchar function. This assumes that Char is an integer.
  Value *emitPutChar(Value *Char, IRBuilderBase &B,
                     const TargetLibraryInfo *TLI);

  /// Emit a call to the puts function. This assumes that Str is some pointer.
  Value *emitPutS(Value *Str, IRBuilderBase &B, const TargetLibraryInfo *TLI);

  /// Emit a call to the fputc function. This assumes that Char is an i32, and
  /// File is a pointer to FILE.
  Value *emitFPutC(Value *Char, Value *File, IRBuilderBase &B,
                   const TargetLibraryInfo *TLI);

  /// Emit a call to the fputs function. Str is required to be a pointer and
  /// File is a pointer to FILE.
  Value *emitFPutS(Value *Str, Value *File, IRBuilderBase &B,
                   const TargetLibraryInfo *TLI);

  /// Emit a call to the fwrite function. This assumes that Ptr is a pointer,
  /// Size is an 'intptr_t', and File is a pointer to FILE.
  Value *emitFWrite(Value *Ptr, Value *Size, Value *File, IRBuilderBase &B,
                    const DataLayout &DL, const TargetLibraryInfo *TLI);

  /// Emit a call to the malloc function.
  Value *emitMalloc(Value *Num, IRBuilderBase &B, const DataLayout &DL,
                    const TargetLibraryInfo *TLI);

  /// Emit a call to the calloc function.
  Value *emitCalloc(Value *Num, Value *Size, const AttributeList &Attrs,
                    IRBuilderBase &B, const TargetLibraryInfo &TLI);
}

#endif
