; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

declare void @use(i8)
declare void @use16(i16)

define i1 @testi16i8(i16 %add) {
; CHECK-LABEL: @testi16i8(
; CHECK-NEXT:    [[TMP1:%.*]] = add i16 [[ADD:%.*]], 128
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp ult i16 [[TMP1]], 256
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i16 %add, 8
  %conv.i = trunc i16 %sh to i8
  %conv1.i = trunc i16 %add to i8
  %shr2.i = ashr i8 %conv1.i, 7
  %cmp.not.i = icmp eq i8 %shr2.i, %conv.i
  ret i1 %cmp.not.i
}

define i1 @testi16i8_com(i16 %add) {
; CHECK-LABEL: @testi16i8_com(
; CHECK-NEXT:    [[TMP1:%.*]] = add i16 [[ADD:%.*]], 128
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp ult i16 [[TMP1]], 256
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i16 %add, 8
  %conv.i = trunc i16 %sh to i8
  %conv1.i = trunc i16 %add to i8
  %shr2.i = ashr i8 %conv1.i, 7
  %cmp.not.i = icmp eq i8 %conv.i, %shr2.i
  ret i1 %cmp.not.i
}

define i1 @testi16i8_ne(i16 %add) {
; CHECK-LABEL: @testi16i8_ne(
; CHECK-NEXT:    [[TMP1:%.*]] = add i16 [[ADD:%.*]], 128
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp ugt i16 [[TMP1]], 255
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i16 %add, 8
  %conv.i = trunc i16 %sh to i8
  %conv1.i = trunc i16 %add to i8
  %shr2.i = ashr i8 %conv1.i, 7
  %cmp.not.i = icmp ne i8 %shr2.i, %conv.i
  ret i1 %cmp.not.i
}

define i1 @testi16i8_ne_com(i16 %add) {
; CHECK-LABEL: @testi16i8_ne_com(
; CHECK-NEXT:    [[TMP1:%.*]] = add i16 [[ADD:%.*]], 128
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp ugt i16 [[TMP1]], 255
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i16 %add, 8
  %conv.i = trunc i16 %sh to i8
  %conv1.i = trunc i16 %add to i8
  %shr2.i = ashr i8 %conv1.i, 7
  %cmp.not.i = icmp ne i8 %conv.i, %shr2.i
  ret i1 %cmp.not.i
}

define i1 @testi64i32(i64 %add) {
; CHECK-LABEL: @testi64i32(
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[ADD:%.*]], 2147483648
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp ult i64 [[TMP1]], 4294967296
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i64 %add, 32
  %conv.i = trunc i64 %sh to i32
  %conv1.i = trunc i64 %add to i32
  %shr2.i = ashr i32 %conv1.i, 31
  %cmp.not.i = icmp eq i32 %shr2.i, %conv.i
  ret i1 %cmp.not.i
}

define i1 @testi64i32_ne(i64 %add) {
; CHECK-LABEL: @testi64i32_ne(
; CHECK-NEXT:    [[TMP1:%.*]] = add i64 [[ADD:%.*]], 2147483648
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp ugt i64 [[TMP1]], 4294967295
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i64 %add, 32
  %conv.i = trunc i64 %sh to i32
  %conv1.i = trunc i64 %add to i32
  %shr2.i = ashr i32 %conv1.i, 31
  %cmp.not.i = icmp ne i32 %shr2.i, %conv.i
  ret i1 %cmp.not.i
}

; Negative tests

define i1 @testi32i8(i32 %add) {
; CHECK-LABEL: @testi32i8(
; CHECK-NEXT:    [[SH:%.*]] = lshr i32 [[ADD:%.*]], 8
; CHECK-NEXT:    [[CONV_I:%.*]] = trunc i32 [[SH]] to i8
; CHECK-NEXT:    [[CONV1_I:%.*]] = trunc i32 [[ADD]] to i8
; CHECK-NEXT:    [[SHR2_I:%.*]] = ashr i8 [[CONV1_I]], 7
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp eq i8 [[SHR2_I]], [[CONV_I]]
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i32 %add, 8
  %conv.i = trunc i32 %sh to i8
  %conv1.i = trunc i32 %add to i8
  %shr2.i = ashr i8 %conv1.i, 7
  %cmp.not.i = icmp eq i8 %shr2.i, %conv.i
  ret i1 %cmp.not.i
}

define i1 @wrongimm1(i16 %add) {
; CHECK-LABEL: @wrongimm1(
; CHECK-NEXT:    [[SH:%.*]] = lshr i16 [[ADD:%.*]], 7
; CHECK-NEXT:    [[CONV_I:%.*]] = trunc i16 [[SH]] to i8
; CHECK-NEXT:    [[CONV1_I:%.*]] = trunc i16 [[ADD]] to i8
; CHECK-NEXT:    [[SHR2_I:%.*]] = ashr i8 [[CONV1_I]], 7
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp eq i8 [[SHR2_I]], [[CONV_I]]
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i16 %add, 7
  %conv.i = trunc i16 %sh to i8
  %conv1.i = trunc i16 %add to i8
  %shr2.i = ashr i8 %conv1.i, 7
  %cmp.not.i = icmp eq i8 %shr2.i, %conv.i
  ret i1 %cmp.not.i
}

define i1 @wrongimm2(i16 %add) {
; CHECK-LABEL: @wrongimm2(
; CHECK-NEXT:    [[SH:%.*]] = lshr i16 [[ADD:%.*]], 8
; CHECK-NEXT:    [[CONV_I:%.*]] = trunc i16 [[SH]] to i8
; CHECK-NEXT:    [[CONV1_I:%.*]] = trunc i16 [[ADD]] to i8
; CHECK-NEXT:    [[SHR2_I:%.*]] = ashr i8 [[CONV1_I]], 6
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp eq i8 [[SHR2_I]], [[CONV_I]]
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i16 %add, 8
  %conv.i = trunc i16 %sh to i8
  %conv1.i = trunc i16 %add to i8
  %shr2.i = ashr i8 %conv1.i, 6
  %cmp.not.i = icmp eq i8 %shr2.i, %conv.i
  ret i1 %cmp.not.i
}

define i1 @slt(i64 %add) {
; CHECK-LABEL: @slt(
; CHECK-NEXT:    [[SH:%.*]] = lshr i64 [[ADD:%.*]], 32
; CHECK-NEXT:    [[CONV_I:%.*]] = trunc i64 [[SH]] to i32
; CHECK-NEXT:    [[CONV1_I:%.*]] = trunc i64 [[ADD]] to i32
; CHECK-NEXT:    [[SHR2_I:%.*]] = ashr i32 [[CONV1_I]], 31
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp slt i32 [[SHR2_I]], [[CONV_I]]
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i64 %add, 32
  %conv.i = trunc i64 %sh to i32
  %conv1.i = trunc i64 %add to i32
  %shr2.i = ashr i32 %conv1.i, 31
  %cmp.not.i = icmp slt i32 %shr2.i, %conv.i
  ret i1 %cmp.not.i
}

; Use checks

define i1 @extrause_a(i16 %add) {
; CHECK-LABEL: @extrause_a(
; CHECK-NEXT:    [[CONV1_I:%.*]] = trunc i16 [[ADD:%.*]] to i8
; CHECK-NEXT:    [[SHR2_I:%.*]] = ashr i8 [[CONV1_I]], 7
; CHECK-NEXT:    [[TMP1:%.*]] = add i16 [[ADD]], 128
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp ult i16 [[TMP1]], 256
; CHECK-NEXT:    call void @use(i8 [[SHR2_I]])
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i16 %add, 8
  %conv.i = trunc i16 %sh to i8
  %conv1.i = trunc i16 %add to i8
  %shr2.i = ashr i8 %conv1.i, 7
  %cmp.not.i = icmp eq i8 %shr2.i, %conv.i
  call void @use(i8 %shr2.i)
  ret i1 %cmp.not.i
}

define i1 @extrause_l(i16 %add) {
; CHECK-LABEL: @extrause_l(
; CHECK-NEXT:    [[SH:%.*]] = lshr i16 [[ADD:%.*]], 8
; CHECK-NEXT:    [[CONV_I:%.*]] = trunc i16 [[SH]] to i8
; CHECK-NEXT:    [[TMP1:%.*]] = add i16 [[ADD]], 128
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp ult i16 [[TMP1]], 256
; CHECK-NEXT:    call void @use(i8 [[CONV_I]])
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i16 %add, 8
  %conv.i = trunc i16 %sh to i8
  %conv1.i = trunc i16 %add to i8
  %shr2.i = ashr i8 %conv1.i, 7
  %cmp.not.i = icmp eq i8 %shr2.i, %conv.i
  call void @use(i8 %conv.i)
  ret i1 %cmp.not.i
}

define i1 @extrause_la(i16 %add) {
; CHECK-LABEL: @extrause_la(
; CHECK-NEXT:    [[SH:%.*]] = lshr i16 [[ADD:%.*]], 8
; CHECK-NEXT:    [[CONV_I:%.*]] = trunc i16 [[SH]] to i8
; CHECK-NEXT:    [[CONV1_I:%.*]] = trunc i16 [[ADD]] to i8
; CHECK-NEXT:    [[SHR2_I:%.*]] = ashr i8 [[CONV1_I]], 7
; CHECK-NEXT:    [[CMP_NOT_I:%.*]] = icmp eq i8 [[SHR2_I]], [[CONV_I]]
; CHECK-NEXT:    call void @use(i8 [[SHR2_I]])
; CHECK-NEXT:    call void @use(i8 [[CONV_I]])
; CHECK-NEXT:    ret i1 [[CMP_NOT_I]]
;
  %sh = lshr i16 %add, 8
  %conv.i = trunc i16 %sh to i8
  %conv1.i = trunc i16 %add to i8
  %shr2.i = ashr i8 %conv1.i, 7
  %cmp.not.i = icmp eq i8 %shr2.i, %conv.i
  call void @use(i8 %shr2.i)
  call void @use(i8 %conv.i)
  ret i1 %cmp.not.i
}
