; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=arm -type-promotion -verify -disable-type-promotion=false -S %s -o - | FileCheck %s

; Test to check that ARMCodeGenPrepare doesn't optimised away sign extends.
define i16 @test_signed_load(i16* %ptr) {
; CHECK-LABEL: @test_signed_load(
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, i16* [[PTR:%.*]]
; CHECK-NEXT:    [[CONV0:%.*]] = zext i16 [[LOAD]] to i32
; CHECK-NEXT:    [[CONV1:%.*]] = sext i16 [[LOAD]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[CONV0]], [[CONV1]]
; CHECK-NEXT:    [[CONV2:%.*]] = zext i1 [[CMP]] to i16
; CHECK-NEXT:    ret i16 [[CONV2]]
;
  %load = load i16, i16* %ptr
  %conv0 = zext i16 %load to i32
  %conv1 = sext i16 %load to i32
  %cmp = icmp eq i32 %conv0, %conv1
  %conv2 = zext i1 %cmp to i16
  ret i16 %conv2
}

; Don't allow sign bit generating opcodes.
define i16 @test_ashr(i16 zeroext %arg) {
; CHECK-LABEL: @test_ashr(
; CHECK-NEXT:    [[ASHR:%.*]] = ashr i16 [[ARG:%.*]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[ASHR]], 0
; CHECK-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i16
; CHECK-NEXT:    ret i16 [[CONV]]
;
  %ashr = ashr i16 %arg, 1
  %cmp = icmp eq i16 %ashr, 0
  %conv = zext i1 %cmp to i16
  ret i16 %conv
}

define i16 @test_sdiv(i16 zeroext %arg) {
; CHECK-LABEL: @test_sdiv(
; CHECK-NEXT:    [[SDIV:%.*]] = sdiv i16 [[ARG:%.*]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i16 [[SDIV]], 0
; CHECK-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i16
; CHECK-NEXT:    ret i16 [[CONV]]
;
  %sdiv = sdiv i16 %arg, 2
  %cmp = icmp ne i16 %sdiv, 0
  %conv = zext i1 %cmp to i16
  ret i16 %conv
}

define i16 @test_srem(i16 zeroext %arg) {
; CHECK-LABEL: @test_srem(
; CHECK-NEXT:    [[SREM:%.*]] = srem i16 [[ARG:%.*]], 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i16 [[SREM]], 0
; CHECK-NEXT:    [[CONV:%.*]] = zext i1 [[CMP]] to i16
; CHECK-NEXT:    ret i16 [[CONV]]
;
  %srem = srem i16 %arg, 4
  %cmp = icmp ne i16 %srem, 0
  %conv = zext i1 %cmp to i16
  ret i16 %conv
}

define i32 @test_signext_b(i8* %ptr, i8 signext %arg) {
; CHECK-LABEL: @test_signext_b(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i8 [[ARG:%.*]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, i8* [[PTR:%.*]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = zext i8 [[TMP1]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw nsw i32 [[TMP2]], [[TMP0]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[TMP3]], 128
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[CMP]], i32 42, i32 20894
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  %0 = load i8, i8* %ptr, align 1
  %1 = add nuw nsw i8 %0, %arg
  %cmp = icmp ult i8 %1, 128
  %res = select i1 %cmp, i32 42, i32 20894
  ret i32 %res
}

define i32 @test_signext_b_ult_slt(i8* %ptr, i8 signext %arg) {
; CHECK-LABEL: @test_signext_b_ult_slt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i8 [[ARG:%.*]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = load i8, i8* [[PTR:%.*]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = zext i8 [[TMP1]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw nsw i32 [[TMP2]], [[TMP0]]
; CHECK-NEXT:    [[TMP4:%.*]] = trunc i32 [[TMP3]] to i8
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i8 [[TMP4]], 126
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp ule i32 [[TMP3]], [[TMP0]]
; CHECK-NEXT:    [[OR:%.*]] = and i1 [[CMP]], [[CMP_1]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[OR]], i32 42, i32 57
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  %0 = load i8, i8* %ptr, align 1
  %1 = add nuw nsw i8 %0, %arg
  %cmp = icmp sle i8 %1, 126
  %cmp.1 = icmp ule i8 %1, %arg
  %or = and i1 %cmp, %cmp.1
  %res = select i1 %or, i32 42, i32 57
  ret i32 %res
}

define i32 @test_signext_h(i16* %ptr, i16 signext %arg) {
; CHECK-LABEL: @test_signext_h(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i16 [[ARG:%.*]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = load i16, i16* [[PTR:%.*]], align 1
; CHECK-NEXT:    [[TMP2:%.*]] = zext i16 [[TMP1]] to i32
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw nsw i32 [[TMP2]], [[TMP0]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[TMP3]], 32768
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[CMP]], i32 42, i32 20894
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  %0 = load i16, i16* %ptr, align 1
  %1 = add nuw nsw i16 %0, %arg
  %cmp = icmp ult i16 %1, 32768
  %res = select i1 %cmp, i32 42, i32 20894
  ret i32 %res
}

