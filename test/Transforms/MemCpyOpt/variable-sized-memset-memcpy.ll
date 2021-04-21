; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -memcpyopt -S -enable-memcpyopt-memoryssa=0 | FileCheck %s
; RUN: opt < %s -memcpyopt -S -enable-memcpyopt-memoryssa=1 -verify-memoryssa | FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define void @test(i8* %src, i8 %c, i64 %size) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[DST1:%.*]] = alloca i8, i64 [[SIZE:%.*]], align 1
; CHECK-NEXT:    [[DST2:%.*]] = alloca i8, i64 [[SIZE]], align 1
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[DST1]], i8 [[C:%.*]], i64 [[SIZE]], i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[DST2]], i8 [[C]], i64 [[SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  %dst1 = alloca i8, i64 %size
  %dst2 = alloca i8, i64 %size
  call void @llvm.memset.p0i8.i64(i8* align 8 %dst1, i8 %c, i64 %size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %dst2, i8* align 8 %dst1, i64 %size, i1 false)

  ret void
}

; Differing sizes, so left as it is.
define void @negative_test(i8* %src, i8 %c, i64 %size1, i64 %size2) {
; CHECK-LABEL: @negative_test(
; CHECK-NEXT:    [[DST1:%.*]] = alloca i8, i64 [[SIZE1:%.*]], align 1
; CHECK-NEXT:    [[DST2:%.*]] = alloca i8, i64 [[SIZE2:%.*]], align 1
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[DST1]], i8 [[C:%.*]], i64 [[SIZE1]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[DST2]], i8* align 8 [[DST1]], i64 [[SIZE2]], i1 false)
; CHECK-NEXT:    ret void
;
  %dst1 = alloca i8, i64 %size1
  %dst2 = alloca i8, i64 %size2
  call void @llvm.memset.p0i8.i64(i8* align 8 %dst1, i8 %c, i64 %size1, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %dst2, i8* align 8 %dst1, i64 %size2, i1 false)

  ret void
}

declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)
