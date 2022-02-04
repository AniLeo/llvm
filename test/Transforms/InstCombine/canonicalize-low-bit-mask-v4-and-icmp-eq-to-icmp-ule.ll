; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=38123

; Pattern:
;   x & ((-1 << y) >> y) == x
; Should be transformed into:
;   x u<= ((-1 << y) >> y)

; This pattern is uncanonical, but we can not canonicalize it due to extra uses.

declare void @use8(i8)
declare void @use2i8(<2 x i8>)
declare void @use3i8(<3 x i8>)

; ============================================================================ ;
; Basic positive tests
; ============================================================================ ;

define i1 @p0(i8 %x, i8 %y) {
; CHECK-LABEL: @p0(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = lshr i8 %t0, %y
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

; ============================================================================ ;
; Vector tests
; ============================================================================ ;

define <2 x i1> @p1_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @p1_vec(
; CHECK-NEXT:    [[T0:%.*]] = shl <2 x i8> <i8 -1, i8 -1>, [[Y:%.*]]
; CHECK-NEXT:    call void @use2i8(<2 x i8> [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr <2 x i8> [[T0]], [[Y]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge <2 x i8> [[T1]], [[X:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[TMP1]]
;
  %t0 = shl <2 x i8> <i8 -1, i8 -1>, %y
  call void @use2i8(<2 x i8> %t0)
  %t1 = lshr <2 x i8> %t0, %y
  %t2 = and <2 x i8> %t1, %x
  %ret = icmp eq <2 x i8> %t2, %x
  ret <2 x i1> %ret
}

define <3 x i1> @p2_vec_undef0(<3 x i8> %x, <3 x i8> %y) {
; CHECK-LABEL: @p2_vec_undef0(
; CHECK-NEXT:    [[T0:%.*]] = shl <3 x i8> <i8 -1, i8 undef, i8 -1>, [[Y:%.*]]
; CHECK-NEXT:    call void @use3i8(<3 x i8> [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr <3 x i8> [[T0]], [[Y]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge <3 x i8> [[T1]], [[X:%.*]]
; CHECK-NEXT:    ret <3 x i1> [[TMP1]]
;
  %t0 = shl <3 x i8> <i8 -1, i8 undef, i8 -1>, %y
  call void @use3i8(<3 x i8> %t0)
  %t1 = lshr <3 x i8> %t0, %y
  %t2 = and <3 x i8> %t1, %x
  %ret = icmp eq <3 x i8> %t2, %x
  ret <3 x i1> %ret
}

; ============================================================================ ;
; Commutativity tests.
; ============================================================================ ;

declare i8 @gen8()

define i1 @c0(i8 %y) {
; CHECK-LABEL: @c0(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y]]
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i8 [[X]], [[T1]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = lshr i8 %t0, %y
  %x = call i8 @gen8()
  %t2 = and i8 %x, %t1 ; swapped order
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @c1(i8 %y) {
; CHECK-LABEL: @c1(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y]]
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i8 [[X]], [[T1]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = lshr i8 %t0, %y
  %x = call i8 @gen8()
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %x, %t2 ; swapped order
  ret i1 %ret
}

define i1 @c2(i8 %y) {
; CHECK-LABEL: @c2(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y]]
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i8 [[X]], [[T1]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = lshr i8 %t0, %y
  %x = call i8 @gen8()
  %t2 = and i8 %x, %t1 ; swapped order
  %ret = icmp eq i8 %x, %t2 ; swapped order
  ret i1 %ret
}

; ============================================================================ ;
; One-use tests. We don't care about multi-uses here.
; ============================================================================ ;

define i1 @oneuse0(i8 %x, i8 %y) {
; CHECK-LABEL: @oneuse0(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y]]
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0) ; needed anyway
  %t1 = lshr i8 %t0, %y
  call void @use8(i8 %t1)
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @oneuse1(i8 %x, i8 %y) {
; CHECK-LABEL: @oneuse1(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y]]
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T2]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[T1]], [[X]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0) ; needed anyway
  %t1 = lshr i8 %t0, %y
  %t2 = and i8 %t1, %x
  call void @use8(i8 %t2)
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @oneuse2(i8 %x, i8 %y) {
; CHECK-LABEL: @oneuse2(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y]]
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T2]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[T1]], [[X]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = lshr i8 %t0, %y
  call void @use8(i8 %t1)
  %t2 = and i8 %t1, %x
  call void @use8(i8 %t2)
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

; ============================================================================ ;
; Negative tests
; ============================================================================ ;

define i1 @n0(i8 %x, i8 %y, i8 %notx) {
; CHECK-LABEL: @n0(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y]]
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = icmp eq i8 [[T2]], [[NOTX:%.*]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = lshr i8 %t0, %y
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %notx ; not %x
  ret i1 %ret
}

define i1 @n1(i8 %x, i8 %y) {
; CHECK-LABEL: @n1(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y]]
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = icmp eq i8 [[T2]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %t0 = shl i8 1, %y ; not -1
  call void @use8(i8 %t0)
  %t1 = lshr i8 %t0, %y
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @n2(i8 %x, i8 %y1, i8 %y2) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y1:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = lshr i8 [[T0]], [[Y2:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = icmp eq i8 [[T2]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %t0 = shl i8 -1, %y1 ; not %y2
  call void @use8(i8 %t0)
  %t1 = lshr i8 %t0, %y2 ; not %y1
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}
