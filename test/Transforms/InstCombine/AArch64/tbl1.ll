; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"
target triple = "aarch64-arm-none-eabi"

; Turning a table lookup intrinsic into a shuffle vector instruction
; can be beneficial. If the mask used for the lookup is the constant
; vector {7,6,5,4,3,2,1,0}, then the back-end generates rev64
; instructions instead.

define <8 x i8> @tbl1_8x8(<16 x i8> %vec) {
; CHECK-LABEL: @tbl1_8x8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = shufflevector <16 x i8> [[VEC:%.*]], <16 x i8> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    ret <8 x i8> [[TMP0]]
;
entry:
  %tbl1 = call <8 x i8> @llvm.aarch64.neon.tbl1.v8i8(<16 x i8> %vec, <8 x i8> <i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>)
  ret <8 x i8> %tbl1
}

; Bail the optimization if a mask index is out of range.
define <8 x i8> @tbl1_8x8_out_of_range(<16 x i8> %vec) {
; CHECK-LABEL: @tbl1_8x8_out_of_range(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TBL1:%.*]] = call <8 x i8> @llvm.aarch64.neon.tbl1.v8i8(<16 x i8> [[VEC:%.*]], <8 x i8> <i8 8, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>)
; CHECK-NEXT:    ret <8 x i8> [[TBL1]]
;
entry:
  %tbl1 = call <8 x i8> @llvm.aarch64.neon.tbl1.v8i8(<16 x i8> %vec, <8 x i8> <i8 8, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>)
  ret <8 x i8> %tbl1
}

; Bail the optimization if the size of the return vector is not 8 elements.
define <16 x i8> @tbl1_16x8(<16 x i8> %vec) {
; CHECK-LABEL: @tbl1_16x8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TBL1:%.*]] = call <16 x i8> @llvm.aarch64.neon.tbl1.v16i8(<16 x i8> [[VEC:%.*]], <16 x i8> <i8 15, i8 14, i8 13, i8 12, i8 11, i8 10, i8 9, i8 8, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>)
; CHECK-NEXT:    ret <16 x i8> [[TBL1]]
;
entry:
  %tbl1 = call <16 x i8> @llvm.aarch64.neon.tbl1.v16i8(<16 x i8> %vec, <16 x i8> <i8 15, i8 14, i8 13, i8 12, i8 11, i8 10, i8 9, i8 8, i8 7, i8 6, i8 5, i8 4, i8 3, i8 2, i8 1, i8 0>)
  ret <16 x i8> %tbl1
}

; Bail the optimization if the elements of the return vector are not of type i8.
define <8 x i16> @tbl1_8x16(<16 x i8> %vec) {
; CHECK-LABEL: @tbl1_8x16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TBL1:%.*]] = call <8 x i16> @llvm.aarch64.neon.tbl1.v8i16(<16 x i8> [[VEC:%.*]], <8 x i16> <i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7>)
; CHECK-NEXT:    ret <8 x i16> [[TBL1]]
;
entry:
  %tbl1 = call <8 x i16> @llvm.aarch64.neon.tbl1.v8i16(<16 x i8> %vec, <8 x i16> <i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7>)
  ret <8 x i16> %tbl1
}

; The type <8 x i16> is not a valid return type for this intrinsic,
; but we want to test that the optimization won't trigger for vector
; elements of type different than i8.
declare <8 x i16> @llvm.aarch64.neon.tbl1.v8i16(<16 x i8>, <8 x i16>)

declare <8 x i8> @llvm.aarch64.neon.tbl1.v8i8(<16 x i8>, <8 x i8>)
declare <16 x i8> @llvm.aarch64.neon.tbl1.v16i8(<16 x i8>, <16 x i8>)
