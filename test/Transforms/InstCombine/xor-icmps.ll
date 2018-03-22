; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i1 @eq_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @eq_zero(
; CHECK-NEXT:    [[I0:%.*]] = icmp eq i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp eq i4 %x, 0
  %i1 = icmp eq i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @ne_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @ne_zero(
; CHECK-NEXT:    [[I0:%.*]] = icmp ne i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp ne i4 %x, 0
  %i1 = icmp ne i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @eq_ne_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @eq_ne_zero(
; CHECK-NEXT:    [[I0:%.*]] = icmp eq i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp eq i4 %x, 0
  %i1 = icmp ne i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @slt_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @slt_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i4 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %i0 = icmp slt i4 %x, 0
  %i1 = icmp slt i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

; Don't increase the instruction count.

declare void @use(i1)

define i1 @slt_zero_extra_uses(i4 %x, i4 %y) {
; CHECK-LABEL: @slt_zero_extra_uses(
; CHECK-NEXT:    [[I0:%.*]] = icmp slt i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp slt i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    call void @use(i1 [[I0]])
; CHECK-NEXT:    call void @use(i1 [[I1]])
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp slt i4 %x, 0
  %i1 = icmp slt i4 %y, 0
  %r = xor i1 %i0, %i1
  call void @use(i1 %i0)
  call void @use(i1 %i1)
  ret i1 %r
}

define i1 @sgt_zero(i4 %x, i4 %y) {
; CHECK-LABEL: @sgt_zero(
; CHECK-NEXT:    [[I0:%.*]] = icmp sgt i4 [[X:%.*]], 0
; CHECK-NEXT:    [[I1:%.*]] = icmp sgt i4 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[I0]], [[I1]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %i0 = icmp sgt i4 %x, 0
  %i1 = icmp sgt i4 %y, 0
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @sgt_minus1(i4 %x, i4 %y) {
; CHECK-LABEL: @sgt_minus1(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i4 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %i0 = icmp sgt i4 %x, -1
  %i1 = icmp sgt i4 %y, -1
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define i1 @slt_zero_sgt_minus1(i4 %x, i4 %y) {
; CHECK-LABEL: @slt_zero_sgt_minus1(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt i4 [[TMP1]], -1
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %i0 = icmp slt i4 %x, 0
  %i1 = icmp sgt i4 %y, -1
  %r = xor i1 %i0, %i1
  ret i1 %r
}

define <2 x i1> @sgt_minus1_slt_zero_sgt(<2 x i4> %x, <2 x i4> %y) {
; CHECK-LABEL: @sgt_minus1_slt_zero_sgt(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i4> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt <2 x i4> [[TMP1]], <i4 -1, i4 -1>
; CHECK-NEXT:    ret <2 x i1> [[TMP2]]
;
  %i1 = icmp sgt <2 x i4> %x, <i4 -1, i4 -1>
  %i0 = icmp slt <2 x i4> %y, zeroinitializer
  %r = xor <2 x i1> %i0, %i1
  ret <2 x i1> %r
}

; Don't try (crash) if the operand types don't match.

define i1 @different_type_cmp_ops(i32 %x, i64 %y) {
; CHECK-LABEL: @different_type_cmp_ops(
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[X:%.*]], 0
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i64 [[Y:%.*]], 0
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %cmp1 = icmp slt i32 %x, 0
  %cmp2 = icmp slt i64 %y, 0
  %r = xor i1 %cmp1, %cmp2
  ret i1 %r
}

define i1 @test13(i8 %A, i8 %B) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %C = icmp ult i8 %A, %B
  %D = icmp ugt i8 %A, %B
  %E = xor i1 %C, %D
  ret i1 %E
}

define i1 @test14(i8 %A, i8 %B) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    ret i1 true
;
  %C = icmp eq i8 %A, %B
  %D = icmp ne i8 %B, %A
  %E = xor i1 %C, %D
  ret i1 %E
}

