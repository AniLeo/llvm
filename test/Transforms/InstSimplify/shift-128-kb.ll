; NOTE: Assertions have been autogenerated by update_test_checks.py
; RUN: opt -S -passes=instsimplify < %s | FileCheck %s

target datalayout = "E-m:e-i64:64-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

define zeroext i1 @_Z10isNegativemj(i64 %Val, i32 zeroext %IntegerBitWidth) {
; CHECK-LABEL: @_Z10isNegativemj(
; CHECK:         [[CONV:%.*]] = zext i32 %IntegerBitWidth to i64
; CHECK-NEXT:    [[SUB:%.*]] = sub i64 128, [[CONV]]
; CHECK-NEXT:    [[CONV1:%.*]] = trunc i64 [[SUB]] to i32
; CHECK-NEXT:    [[CONV2:%.*]] = zext i64 %Val to i128
; CHECK-NEXT:    [[SH_PROM:%.*]] = zext i32 [[CONV1]] to i128
; CHECK-NEXT:    [[SHL:%.*]] = shl i128 [[CONV2]], [[SH_PROM]]
; CHECK-NEXT:    [[SHR:%.*]] = ashr i128 [[SHL]], [[SH_PROM]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i128 [[SHR]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
entry:
  %conv = zext i32 %IntegerBitWidth to i64
  %sub = sub i64 128, %conv
  %conv1 = trunc i64 %sub to i32
  %conv2 = zext i64 %Val to i128
  %sh_prom = zext i32 %conv1 to i128
  %shl = shl i128 %conv2, %sh_prom
  %shr = ashr i128 %shl, %sh_prom
  %cmp = icmp slt i128 %shr, 0
  ret i1 %cmp
}

