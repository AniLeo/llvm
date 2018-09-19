; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=38123

; Pattern:
;   x & ~(-1 << y) == x
; Should be transformed into:
;   x u<= ~(-1 << y)
; That is then later transformed into:
;   (x >> y) == 0

; ============================================================================ ;
; Basic positive tests
; ============================================================================ ;

define i1 @p0(i8 %x, i8 %y) {
; CHECK-LABEL: @p0(
; CHECK-NEXT:    [[X_HIGHBITS:%.*]] = lshr i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8 [[X_HIGHBITS]], 0
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  %t1 = xor i8 %t0, -1
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

; ============================================================================ ;
; Vector tests
; ============================================================================ ;

define <2 x i1> @p1_vec(<2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @p1_vec(
; CHECK-NEXT:    [[X_HIGHBITS:%.*]] = lshr <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i8> [[X_HIGHBITS]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[TMP1]]
;
  %t0 = shl <2 x i8> <i8 -1, i8 -1>, %y
  %t1 = xor <2 x i8> %t0, <i8 -1, i8 -1>
  %t2 = and <2 x i8> %t1, %x
  %ret = icmp eq <2 x i8> %t2, %x
  ret <2 x i1> %ret
}

define <3 x i1> @p2_vec_undef0(<3 x i8> %x, <3 x i8> %y) {
; CHECK-LABEL: @p2_vec_undef0(
; CHECK-NEXT:    [[X_HIGHBITS:%.*]] = lshr <3 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <3 x i8> [[X_HIGHBITS]], zeroinitializer
; CHECK-NEXT:    ret <3 x i1> [[TMP1]]
;
  %t0 = shl <3 x i8> <i8 -1, i8 undef, i8 -1>, %y
  %t1 = xor <3 x i8> %t0, <i8 -1, i8 -1, i8 -1>
  %t2 = and <3 x i8> %t1, %x
  %ret = icmp eq <3 x i8> %t2, %x
  ret <3 x i1> %ret
}

define <3 x i1> @p3_vec_undef0(<3 x i8> %x, <3 x i8> %y) {
; CHECK-LABEL: @p3_vec_undef0(
; CHECK-NEXT:    [[X_HIGHBITS:%.*]] = lshr <3 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <3 x i8> [[X_HIGHBITS]], zeroinitializer
; CHECK-NEXT:    ret <3 x i1> [[TMP1]]
;
  %t0 = shl <3 x i8> <i8 -1, i8 -1, i8 -1>, %y
  %t1 = xor <3 x i8> %t0, <i8 -1, i8 undef, i8 -1>
  %t2 = and <3 x i8> %t1, %x
  %ret = icmp eq <3 x i8> %t2, %x
  ret <3 x i1> %ret
}

define <3 x i1> @p4_vec_undef2(<3 x i8> %x, <3 x i8> %y) {
; CHECK-LABEL: @p4_vec_undef2(
; CHECK-NEXT:    [[X_HIGHBITS:%.*]] = lshr <3 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <3 x i8> [[X_HIGHBITS]], zeroinitializer
; CHECK-NEXT:    ret <3 x i1> [[TMP1]]
;
  %t0 = shl <3 x i8> <i8 -1, i8 undef, i8 -1>, %y
  %t1 = xor <3 x i8> %t0, <i8 -1, i8 undef, i8 -1>
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
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[X_HIGHBITS:%.*]] = lshr i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8 [[X_HIGHBITS]], 0
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  %t1 = xor i8 %t0, -1
  %x = call i8 @gen8()
  %t2 = and i8 %x, %t1 ; swapped order
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @c1(i8 %y) {
; CHECK-LABEL: @c1(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[X_HIGHBITS:%.*]] = lshr i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8 [[X_HIGHBITS]], 0
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  %t1 = xor i8 %t0, -1
  %x = call i8 @gen8()
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %x, %t2 ; swapped order
  ret i1 %ret
}

define i1 @c2(i8 %y) {
; CHECK-LABEL: @c2(
; CHECK-NEXT:    [[X:%.*]] = call i8 @gen8()
; CHECK-NEXT:    [[X_HIGHBITS:%.*]] = lshr i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8 [[X_HIGHBITS]], 0
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  %t1 = xor i8 %t0, -1
  %x = call i8 @gen8()
  %t2 = and i8 %x, %t1 ; swapped order
  %ret = icmp eq i8 %x, %t2 ; swapped order
  ret i1 %ret
}

; ============================================================================ ;
; One-use tests. We don't care about multi-uses here.
; ============================================================================ ;

declare void @use8(i8)

define i1 @oneuse0(i8 %x, i8 %y) {
; CHECK-LABEL: @oneuse0(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[X_HIGHBITS:%.*]] = lshr i8 [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8 [[X_HIGHBITS]], 0
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = xor i8 %t0, -1
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @oneuse1(i8 %x, i8 %y) {
; CHECK-LABEL: @oneuse1(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = xor i8 [[T0]], -1
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  %t1 = xor i8 %t0, -1
  call void @use8(i8 %t1)
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @oneuse2(i8 %x, i8 %y) {
; CHECK-LABEL: @oneuse2(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = xor i8 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T2]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[T1]], [[X]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  %t1 = xor i8 %t0, -1
  %t2 = and i8 %t1, %x
  call void @use8(i8 %t2)
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @oneuse3(i8 %x, i8 %y) {
; CHECK-LABEL: @oneuse3(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = xor i8 [[T0]], -1
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = xor i8 %t0, -1
  call void @use8(i8 %t1)
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @oneuse4(i8 %x, i8 %y) {
; CHECK-LABEL: @oneuse4(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = xor i8 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T2]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[T1]], [[X]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = xor i8 %t0, -1
  %t2 = and i8 %t1, %x
  call void @use8(i8 %t2)
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @oneuse5(i8 %x, i8 %y) {
; CHECK-LABEL: @oneuse5(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T0]])
; CHECK-NEXT:    [[T1:%.*]] = xor i8 [[T0]], -1
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    call void @use8(i8 [[T2]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp uge i8 [[T1]], [[X]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t0 = shl i8 -1, %y
  call void @use8(i8 %t0)
  %t1 = xor i8 %t0, -1
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
; CHECK-NEXT:    [[T1:%.*]] = xor i8 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = icmp eq i8 [[T2]], [[NOTX:%.*]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %t0 = shl i8 -1, %y
  %t1 = xor i8 %t0, -1
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %notx ; not %x
  ret i1 %ret
}

define i1 @n1(i8 %x, i8 %y) {
; CHECK-LABEL: @n1(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 1, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = xor i8 [[T0]], -1
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = icmp eq i8 [[T2]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %t0 = shl i8 1, %y ; not -1
  %t1 = xor i8 %t0, -1
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}

define i1 @n2(i8 %x, i8 %y) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[T0:%.*]] = shl i8 -1, [[Y:%.*]]
; CHECK-NEXT:    [[T1:%.*]] = xor i8 [[T0]], 1
; CHECK-NEXT:    [[T2:%.*]] = and i8 [[T1]], [[X:%.*]]
; CHECK-NEXT:    [[RET:%.*]] = icmp eq i8 [[T2]], [[X]]
; CHECK-NEXT:    ret i1 [[RET]]
;
  %t0 = shl i8 -1, %y
  %t1 = xor i8 %t0, 1 ; not -1
  %t2 = and i8 %t1, %x
  %ret = icmp eq i8 %t2, %x
  ret i1 %ret
}
