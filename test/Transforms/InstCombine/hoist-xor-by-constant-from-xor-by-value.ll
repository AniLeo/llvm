; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare i8 @gen8()
declare void @use8(i8)

@a = global i8 17

define i8 @t0_scalar(i8 %x, i8 %y) {
; CHECK-LABEL: @t0_scalar(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[TMP1]], 42
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = xor i8 %x, 42
  %r = xor i8 %i0, %y
  ret i8 %r
}

define <2 x i8> @t1_splatvec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t1_splatvec(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor <2 x i8> [[TMP1]], <i8 42, i8 42>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %i0 = xor <2 x i8> %x, <i8 42, i8 42>
  %r = xor <2 x i8> %i0, %y
  ret <2 x i8> %r
}
define <2 x i8> @t2_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t2_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor <2 x i8> [[TMP1]], <i8 42, i8 24>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %i0 = xor <2 x i8> %x, <i8 42, i8 24>
  %r = xor <2 x i8> %i0, %y
  ret <2 x i8> %r
}
define <2 x i8> @t3_vec_undef(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @t3_vec_undef(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor <2 x i8> [[TMP1]], <i8 42, i8 undef>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %i0 = xor <2 x i8> %x, <i8 42, i8 undef>
  %r = xor <2 x i8> %i0, %y
  ret <2 x i8> %r
}

define i8 @t4_extrause(i8 %x, i8 %y) {
; CHECK-LABEL: @t4_extrause(
; CHECK-NEXT:    [[I0:%.*]] = xor i8 [[X:%.*]], 42
; CHECK-NEXT:    call void @use8(i8 [[I0]])
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[I0]], [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = xor i8 %x, 42
  call void @use8(i8 %i0)
  %r = xor i8 %i0, %y
  ret i8 %r
}

define i8 @t5_commutativity(i8 %x) {
; CHECK-LABEL: @t5_commutativity(
; CHECK-NEXT:    [[Y:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[Y]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[TMP1]], 42
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = xor i8 %x, 42
  %y = call i8 @gen8()
  %r = xor i8 %y, %i0
  ret i8 %r
}

@global_constant = internal global i32 0, align 4
@global_constant2 = internal global i32 0, align 4

define i8 @constantexpr(i8 %or) local_unnamed_addr #0 {
; CHECK-LABEL: @constantexpr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[OR:%.*]], xor (i8 ptrtoint (i32* @global_constant to i8), i8 ptrtoint (i32* @global_constant2 to i8))
; CHECK-NEXT:    ret i8 [[R]]
;
entry:
  %r = xor i8 %or, xor (i8 xor (i8 ptrtoint (i32* @global_constant to i8), i8 -1), i8 xor (i8 ptrtoint (i32* @global_constant2 to i8), i8 -1))
  ret i8 %r
}
