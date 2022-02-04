; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine %s -S -o - | FileCheck %s

; ((X - Y) - Z)  -->  X - (Y + Z)  because we prefer add's.

declare void @use8(i8)

; Basic test
define i8 @t0(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[R:%.*]] = sub i8 [[X:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 %x, %y
  %r = sub i8 %i0, %z
  ret i8 %r
}

; No flags are propagated
define i8 @t1_flags(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @t1_flags(
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[R:%.*]] = sub i8 [[X:%.*]], [[TMP1]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %o0 = sub nuw nsw i8 %x, %y
  %r = sub nuw nsw i8 %o0, %z
  ret i8 %r
}

; The inner sub must have single use.
define i8 @n2(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[I0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[I0]])
; CHECK-NEXT:    [[R:%.*]] = sub i8 [[I0]], [[Z:%.*]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 %x, %y ; extra use
  call void @use8(i8 %i0)
  %r = sub i8 %i0, %z
  ret i8 %r
}

; What if some operand is constant?

define i8 @t3_c0(i8 %y, i8 %z) {
; CHECK-LABEL: @t3_c0(
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[R:%.*]] = sub i8 42, [[TMP1]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 42, %y
  %r = sub i8 %i0, %z
  ret i8 %r
}

define i8 @t4_c1(i8 %x, i8 %z) {
; CHECK-LABEL: @t4_c1(
; CHECK-NEXT:    [[I0:%.*]] = add i8 [[X:%.*]], -42
; CHECK-NEXT:    [[R:%.*]] = sub i8 [[I0]], [[Z:%.*]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 %x, 42
  %r = sub i8 %i0, %z
  ret i8 %r
}

define i8 @t5_c2(i8 %x, i8 %y) {
; CHECK-LABEL: @t5_c2(
; CHECK-NEXT:    [[I0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = add i8 [[I0]], -42
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 %x, %y
  %r = sub i8 %i0, 42
  ret i8 %r
}

; What if some operand is constant and there was extra use?

define i8 @t6_c0_extrause(i8 %y, i8 %z) {
; CHECK-LABEL: @t6_c0_extrause(
; CHECK-NEXT:    [[I0:%.*]] = sub i8 42, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[I0]])
; CHECK-NEXT:    [[R:%.*]] = sub i8 [[I0]], [[Z:%.*]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 42, %y
  call void @use8(i8 %i0)
  %r = sub i8 %i0, %z
  ret i8 %r
}

define i8 @t7_c1_extrause(i8 %x, i8 %z) {
; CHECK-LABEL: @t7_c1_extrause(
; CHECK-NEXT:    [[I0:%.*]] = add i8 [[X:%.*]], -42
; CHECK-NEXT:    call void @use8(i8 [[I0]])
; CHECK-NEXT:    [[R:%.*]] = sub i8 [[I0]], [[Z:%.*]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 %x, 42
  call void @use8(i8 %i0)
  %r = sub i8 %i0, %z
  ret i8 %r
}

define i8 @t8_c2_extrause(i8 %x, i8 %y) {
; CHECK-LABEL: @t8_c2_extrause(
; CHECK-NEXT:    [[I0:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[I0]])
; CHECK-NEXT:    [[R:%.*]] = add i8 [[I0]], -42
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 %x, %y
  call void @use8(i8 %i0)
  %r = sub i8 %i0, 42
  ret i8 %r
}

; What if two operands are constants?

define i8 @t9_c0_c2(i8 %y, i8 %z) {
; CHECK-LABEL: @t9_c0_c2(
; CHECK-NEXT:    [[R:%.*]] = sub i8 18, [[Y:%.*]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 42, %y
  %r = sub i8 %i0, 24
  ret i8 %r
}

define i8 @t10_c1_c2(i8 %x, i8 %z) {
; CHECK-LABEL: @t10_c1_c2(
; CHECK-NEXT:    [[R:%.*]] = add i8 [[X:%.*]], -66
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 %x, 42
  %r = sub i8 %i0, 24
  ret i8 %r
}

; What if two operands are constants and there was extra use?

define i8 @t11_c0_c2_extrause(i8 %y, i8 %z) {
; CHECK-LABEL: @t11_c0_c2_extrause(
; CHECK-NEXT:    [[I0:%.*]] = sub i8 42, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[I0]])
; CHECK-NEXT:    [[R:%.*]] = sub i8 18, [[Y]]
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 42, %y
  call void @use8(i8 %i0)
  %r = sub i8 %i0, 24
  ret i8 %r
}

define i8 @t12_c1_c2_exrause(i8 %x, i8 %z) {
; CHECK-LABEL: @t12_c1_c2_exrause(
; CHECK-NEXT:    [[I0:%.*]] = add i8 [[X:%.*]], -42
; CHECK-NEXT:    call void @use8(i8 [[I0]])
; CHECK-NEXT:    [[R:%.*]] = add i8 [[X]], -66
; CHECK-NEXT:    ret i8 [[R]]
;
  %i0 = sub i8 %x, 42
  call void @use8(i8 %i0)
  %r = sub i8 %i0, 24
  ret i8 %r
}

; PR49870
@g0 = external global i8, align 1
@g1 = external global i8, align 1
define i32 @constantexpr0(i32 %x, i8* %y) unnamed_addr {
; CHECK-LABEL: @constantexpr0(
; CHECK-NEXT:    [[I0:%.*]] = add i32 [[X:%.*]], ptrtoint (i8* @g0 to i32)
; CHECK-NEXT:    [[R:%.*]] = sub i32 0, [[I0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = add i32 %x, ptrtoint (i8* @g0 to i32)
  %r = sub i32 0, %i0
  ret i32 %r
}
define i32 @constantexpr1(i32 %x, i8* %y) unnamed_addr {
; CHECK-LABEL: @constantexpr1(
; CHECK-NEXT:    [[I0:%.*]] = add i32 [[X:%.*]], 42
; CHECK-NEXT:    [[R:%.*]] = sub i32 ptrtoint (i8* @g1 to i32), [[I0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = add i32 %x, 42
  %r = sub i32 ptrtoint (i8* @g1 to i32), %i0
  ret i32 %r
}
define i32 @constantexpr2(i32 %x, i8* %y) unnamed_addr {
; CHECK-LABEL: @constantexpr2(
; CHECK-NEXT:    [[I0:%.*]] = add i32 [[X:%.*]], ptrtoint (i8* @g0 to i32)
; CHECK-NEXT:    [[R:%.*]] = sub i32 ptrtoint (i8* @g1 to i32), [[I0]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = add i32 %x, ptrtoint (i8* @g0 to i32)
  %r = sub i32 ptrtoint (i8* @g1 to i32), %i0
  ret i32 %r
}

define i64 @pr49870(i64 %x) {
; CHECK-LABEL: @pr49870(
; CHECK-NEXT:    [[I0:%.*]] = xor i64 [[X:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = add i64 [[I0]], ptrtoint (i8* @g0 to i64)
; CHECK-NEXT:    ret i64 [[R]]
;
  %i0 = xor i64 %x, -1
  %r = add i64 %i0, ptrtoint (i8* @g0 to i64)
  ret i64 %r
}
