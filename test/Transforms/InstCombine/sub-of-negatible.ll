; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S | FileCheck %s

declare void @use8(i8)

; Constant can be freely negated.
define i8 @t0(i8 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[T0:%.*]] = add i8 [[X:%.*]], 42
; CHECK-NEXT:    ret i8 [[T0]]
;
  %t0 = sub i8 %x, -42
  ret i8 %t0
}

; Negation can be negated for free
define i8 @t1(i8 %x, i8 %y) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = add i8 [[X:%.*]], [[Y]]
; CHECK-NEXT:    ret i8 [[T1]]
;
  %t0 = sub i8 0, %y
  call void @use8(i8 %t0)
  %t1 = sub i8 %x, %t0
  ret i8 %t1
}

; Shift-left can be negated if all uses can be updated
define i8 @t2(i8 %x, i8 %y) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -42, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = sub i8 [[X:%.*]], [[T0]]
; CHECK-NEXT:    ret i8 [[T1]]
;
  %t0 = shl i8 -42, %y
  %t1 = sub i8 %x, %t0
  ret i8 %t1
}
define i8 @n2(i8 %x, i8 %y) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -42, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = sub i8 [[X:%.*]], [[T0]]
; CHECK-NEXT:    ret i8 [[T1]]
;
  %t0 = shl i8 -42, %y
  call void @use8(i8 %t0)
  %t1 = sub i8 %x, %t0
  ret i8 %t1
}
define i8 @t3(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @t3(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = shl i8 [[T0]], [[Y:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = sub i8 [[X:%.*]], [[T1]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = sub i8 0, %z
  call void @use8(i8 %t0)
  %t1 = shl i8 %t0, %y
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}
define i8 @n3(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @n3(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = shl i8 [[T0]], [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = sub i8 [[X:%.*]], [[T1]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = sub i8 0, %z
  call void @use8(i8 %t0)
  %t1 = shl i8 %t0, %y
  call void @use8(i8 %t1)
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}

; Select can be negated if all it's operands can be negated and all the users of select can be updated
define i8 @t4(i8 %x, i1 %y) {
; CHECK-LABEL: @t4(
; CHECK-NEXT:    [[T0:%.*]] = select i1 [[Y:%.*]], i8 -42, i8 44
; CHECK-NEXT:    [[T1:%.*]] = sub i8 [[X:%.*]], [[T0]]
; CHECK-NEXT:    ret i8 [[T1]]
;
  %t0 = select i1 %y, i8 -42, i8 44
  %t1 = sub i8 %x, %t0
  ret i8 %t1
}
define i8 @n4(i8 %x, i1 %y) {
; CHECK-LABEL: @n4(
; CHECK-NEXT:    [[T0:%.*]] = select i1 [[Y:%.*]], i8 -42, i8 44
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = sub i8 [[X:%.*]], [[T0]]
; CHECK-NEXT:    ret i8 [[T1]]
;
  %t0 = select i1 %y, i8 -42, i8 44
  call void @use8(i8 %t0)
  %t1 = sub i8 %x, %t0
  ret i8 %t1
}
define i8 @n5(i8 %x, i1 %y, i8 %z) {
; CHECK-LABEL: @n5(
; CHECK-NEXT:    [[T0:%.*]] = select i1 [[Y:%.*]], i8 -42, i8 [[Z:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = sub i8 [[X:%.*]], [[T0]]
; CHECK-NEXT:    ret i8 [[T1]]
;
  %t0 = select i1 %y, i8 -42, i8 %z
  %t1 = sub i8 %x, %t0
  ret i8 %t1
}
define i8 @t6(i8 %x, i1 %y, i8 %z) {
; CHECK-LABEL: @t6(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = select i1 [[Y:%.*]], i8 -42, i8 [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = sub i8 [[X:%.*]], [[T1]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = sub i8 0, %z
  call void @use8(i8 %t0)
  %t1 = select i1 %y, i8 -42, i8 %t0
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}
define i8 @t7(i8 %x, i1 %y, i8 %z) {
; CHECK-LABEL: @t7(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 1, [[Z:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = select i1 [[Y:%.*]], i8 0, i8 [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = sub i8 [[X:%.*]], [[T1]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = shl i8 1, %z
  %t1 = select i1 %y, i8 0, i8 %t0
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}
define i8 @n8(i8 %x, i1 %y, i8 %z) {
; CHECK-LABEL: @n8(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 1, [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = select i1 [[Y:%.*]], i8 0, i8 [[T0]]
; CHECK-NEXT:    [[T2:%.*]] = sub i8 [[X:%.*]], [[T1]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = shl i8 1, %z
  call void @use8(i8 %t0)
  %t1 = select i1 %y, i8 0, i8 %t0
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}

; Subtraction can be negated if the first operand can be negated
; x - (y - z) -> x - y + z -> x + (-y) + z
define i8 @t9(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @t9(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T11:%.*]] = add i8 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[T2:%.*]] = add i8 [[T11]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = sub i8 0, %z
  call void @use8(i8 %t0)
  %t1 = sub i8 %t0, %y
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}
define i8 @n10(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @n10(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = sub i8 [[T0]], [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = sub i8 [[X:%.*]], [[T1]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = sub i8 0, %z
  call void @use8(i8 %t0)
  %t1 = sub i8 %t0, %y
  call void @use8(i8 %t1)
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}
define i8 @n11(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @n11(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = add i8 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    [[T2:%.*]] = sub i8 [[X:%.*]], [[T1]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = sub i8 0, %z
  call void @use8(i8 %t0)
  %t1 = sub i8 %y, %t0
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}

; Addition can be negated if both operands can be negated
; x - (y + z) -> x - y - z -> x + ((-y) + (-z)))
define i8 @t12(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @t12(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = sub i8 0, [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y]], [[Z]]
; CHECK-NEXT:    [[T3:%.*]] = add i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[T3]]
;
  %t0 = sub i8 0, %y
  call void @use8(i8 %t0)
  %t1 = sub i8 0, %z
  call void @use8(i8 %t1)
  %t2 = add i8 %t0, %t1
  %t3 = sub i8 %x, %t2
  ret i8 %t3
}
define i8 @n13(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @n13(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T11:%.*]] = sub i8 [[Y]], [[Z:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = add i8 [[T11]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = sub i8 0, %y
  call void @use8(i8 %t0)
  %t1 = add i8 %t0, %z
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}
define i8 @n14(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @n14(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = sub i8 0, [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y]], [[Z]]
; CHECK-NEXT:    [[T2:%.*]] = sub i8 0, [[TMP1]]
; CHECK-NEXT:    call void @use8(i8 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = add i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[T3]]
;
  %t0 = sub i8 0, %y
  call void @use8(i8 %t0)
  %t1 = sub i8 0, %z
  call void @use8(i8 %t1)
  %t2 = add i8 %t0, %t1
  call void @use8(i8 %t2)
  %t3 = sub i8 %x, %t2
  ret i8 %t3
}

; Multiplication can be negated if either one of operands can be negated
; x - (y * z) -> x + ((-y) * z) or  x + ((-z) * y)
define i8 @t15(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @t15(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[TMP1:%.*]] = mul i8 [[Z:%.*]], [[Y]]
; CHECK-NEXT:    [[T2:%.*]] = add i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = sub i8 0, %y
  call void @use8(i8 %t0)
  %t1 = mul i8 %t0, %z
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}
define i8 @n16(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: @n16(
; CHECK-NEXT:    [[T0:%.*]] = sub i8 0, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = mul i8 [[T0]], [[Z:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = sub i8 [[X:%.*]], [[T1]]
; CHECK-NEXT:    ret i8 [[T2]]
;
  %t0 = sub i8 0, %y
  call void @use8(i8 %t0)
  %t1 = mul i8 %t0, %z
  call void @use8(i8 %t1)
  %t2 = sub i8 %x, %t1
  ret i8 %t2
}
