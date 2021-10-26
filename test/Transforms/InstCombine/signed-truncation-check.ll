; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; General pattern:
;   X & Y
;
; Where Y is checking that all the high bits (covered by a mask 4294967168)
; are uniform, i.e.  %arg & 4294967168  can be either  4294967168  or  0
; Pattern can be one of:
;   %t = add        i32 %arg,    128
;   %r = icmp   ult i32 %t,      256
; Or
;   %t0 = shl       i32 %arg,    24
;   %t1 = ashr      i32 %t0,     24
;   %r  = icmp  eq  i32 %t1,     %arg
; Or
;   %t0 = trunc     i32 %arg  to i8
;   %t1 = sext      i8  %t0   to i32
;   %r  = icmp  eq  i32 %t1,     %arg
; This pattern is a signed truncation check.
;
; And X is checking that some bit in that same mask is zero.
; I.e. can be one of:
;   %r = icmp sgt i32   %arg,    -1
; Or
;   %t = and      i32   %arg,    2147483648
;   %r = icmp eq  i32   %t,      0
;
; Since we are checking that all the bits in that mask are the same,
; and a particular bit is zero, what we are really checking is that all the
; masked bits are zero.
; So this should be transformed to:
;   %r = icmp ult i32 %arg, 128

; ============================================================================ ;
; Basic positive test
; ============================================================================ ;

define i1 @positive_with_signbit(i32 %arg) {
; CHECK-LABEL: @positive_with_signbit(
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = and i1 %t1, %t3
  ret i1 %t4
}

define i1 @positive_with_signbit_logical(i32 %arg) {
; CHECK-LABEL: @positive_with_signbit_logical(
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = select i1 %t1, i1 %t3, i1 false
  ret i1 %t4
}

define i1 @positive_with_mask(i32 %arg) {
; CHECK-LABEL: @positive_with_mask(
; CHECK-NEXT:    [[T5_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T5_SIMPLIFIED]]
;
  %t1 = and i32 %arg, 1107296256
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @positive_with_mask_logical(i32 %arg) {
; CHECK-LABEL: @positive_with_mask_logical(
; CHECK-NEXT:    [[T5_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T5_SIMPLIFIED]]
;
  %t1 = and i32 %arg, 1107296256
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @positive_with_icmp(i32 %arg) {
; CHECK-LABEL: @positive_with_icmp(
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %t1 = icmp ult i32 %arg, 512
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = and i1 %t1, %t3
  ret i1 %t4
}

define i1 @positive_with_icmp_logical(i32 %arg) {
; CHECK-LABEL: @positive_with_icmp_logical(
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %t1 = icmp ult i32 %arg, 512
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = select i1 %t1, i1 %t3, i1 false
  ret i1 %t4
}

; Still the same
define i1 @positive_with_aggressive_icmp(i32 %arg) {
; CHECK-LABEL: @positive_with_aggressive_icmp(
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %t1 = icmp ult i32 %arg, 128
  %t2 = add i32 %arg, 256
  %t3 = icmp ult i32 %t2, 512
  %t4 = and i1 %t1, %t3
  ret i1 %t4
}

define i1 @positive_with_aggressive_icmp_logical(i32 %arg) {
; CHECK-LABEL: @positive_with_aggressive_icmp_logical(
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %t1 = icmp ult i32 %arg, 128
  %t2 = add i32 %arg, 256
  %t3 = icmp ult i32 %t2, 512
  %t4 = select i1 %t1, i1 %t3, i1 false
  ret i1 %t4
}

; I'm sure there is a bunch more patterns possible :/

; This used to trigger an assert, because the icmp's are not direct
; operands of the and.
define i1 @positive_with_extra_and(i32 %arg, i1 %z) {
; CHECK-LABEL: @positive_with_extra_and(
; CHECK-NEXT:    [[T5_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    [[TMP1:%.*]] = and i1 [[T5_SIMPLIFIED]], [[Z:%.*]]
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = and i1 %t1, %z
  %t5 = and i1 %t3, %t4
  ret i1 %t5
}

define i1 @positive_with_extra_and_logical(i32 %arg, i1 %z) {
; CHECK-LABEL: @positive_with_extra_and_logical(
; CHECK-NEXT:    [[DOTSIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    [[T5:%.*]] = select i1 [[DOTSIMPLIFIED]], i1 [[Z:%.*]], i1 false
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = select i1 %t1, i1 %z, i1 false
  %t5 = select i1 %t3, i1 %t4, i1 false
  ret i1 %t5
}

; ============================================================================ ;
; Vector tests
; ============================================================================ ;

define <2 x i1> @positive_vec_splat(<2 x i32> %arg) {
; CHECK-LABEL: @positive_vec_splat(
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult <2 x i32> [[ARG:%.*]], <i32 128, i32 128>
; CHECK-NEXT:    ret <2 x i1> [[T4_SIMPLIFIED]]
;
  %t1 = icmp sgt <2 x i32> %arg, <i32 -1, i32 -1>
  %t2 = add <2 x i32> %arg, <i32 128, i32 128>
  %t3 = icmp ult <2 x i32> %t2, <i32 256, i32 256>
  %t4 = and <2 x i1> %t1, %t3
  ret <2 x i1> %t4
}

define <2 x i1> @positive_vec_nonsplat(<2 x i32> %arg) {
; CHECK-LABEL: @positive_vec_nonsplat(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt <2 x i32> [[ARG:%.*]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[T2:%.*]] = add <2 x i32> [[ARG]], <i32 128, i32 256>
; CHECK-NEXT:    [[T3:%.*]] = icmp ult <2 x i32> [[T2]], <i32 256, i32 512>
; CHECK-NEXT:    [[T4:%.*]] = and <2 x i1> [[T1]], [[T3]]
; CHECK-NEXT:    ret <2 x i1> [[T4]]
;
  %t1 = icmp sgt <2 x i32> %arg, <i32 -1, i32 -1>
  %t2 = add <2 x i32> %arg, <i32 128, i32 256>
  %t3 = icmp ult <2 x i32> %t2, <i32 256, i32 512>
  %t4 = and <2 x i1> %t1, %t3
  ret <2 x i1> %t4
}

define <3 x i1> @positive_vec_undef0(<3 x i32> %arg) {
; CHECK-LABEL: @positive_vec_undef0(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt <3 x i32> [[ARG:%.*]], <i32 -1, i32 undef, i32 -1>
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[ARG]], <i32 128, i32 128, i32 128>
; CHECK-NEXT:    [[T3:%.*]] = icmp ult <3 x i32> [[T2]], <i32 256, i32 256, i32 256>
; CHECK-NEXT:    [[T4:%.*]] = and <3 x i1> [[T1]], [[T3]]
; CHECK-NEXT:    ret <3 x i1> [[T4]]
;
  %t1 = icmp sgt <3 x i32> %arg, <i32 -1, i32 undef, i32 -1>
  %t2 = add <3 x i32> %arg, <i32 128, i32 128, i32 128>
  %t3 = icmp ult <3 x i32> %t2, <i32 256, i32 256, i32 256>
  %t4 = and <3 x i1> %t1, %t3
  ret <3 x i1> %t4
}

define <3 x i1> @positive_vec_undef1(<3 x i32> %arg) {
; CHECK-LABEL: @positive_vec_undef1(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt <3 x i32> [[ARG:%.*]], <i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[ARG]], <i32 128, i32 undef, i32 128>
; CHECK-NEXT:    [[T3:%.*]] = icmp ult <3 x i32> [[T2]], <i32 256, i32 256, i32 256>
; CHECK-NEXT:    [[T4:%.*]] = and <3 x i1> [[T1]], [[T3]]
; CHECK-NEXT:    ret <3 x i1> [[T4]]
;
  %t1 = icmp sgt <3 x i32> %arg, <i32 -1, i32 -1, i32 -1>
  %t2 = add <3 x i32> %arg, <i32 128, i32 undef, i32 128>
  %t3 = icmp ult <3 x i32> %t2, <i32 256, i32 256, i32 256>
  %t4 = and <3 x i1> %t1, %t3
  ret <3 x i1> %t4
}

define <3 x i1> @positive_vec_undef2(<3 x i32> %arg) {
; CHECK-LABEL: @positive_vec_undef2(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt <3 x i32> [[ARG:%.*]], <i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[ARG]], <i32 128, i32 128, i32 128>
; CHECK-NEXT:    [[T3:%.*]] = icmp ult <3 x i32> [[T2]], <i32 256, i32 undef, i32 256>
; CHECK-NEXT:    [[T4:%.*]] = and <3 x i1> [[T1]], [[T3]]
; CHECK-NEXT:    ret <3 x i1> [[T4]]
;
  %t1 = icmp sgt <3 x i32> %arg, <i32 -1, i32 -1, i32 -1>
  %t2 = add <3 x i32> %arg, <i32 128, i32 128, i32 128>
  %t3 = icmp ult <3 x i32> %t2, <i32 256, i32 undef, i32 256>
  %t4 = and <3 x i1> %t1, %t3
  ret <3 x i1> %t4
}

define <3 x i1> @positive_vec_undef3(<3 x i32> %arg) {
; CHECK-LABEL: @positive_vec_undef3(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt <3 x i32> [[ARG:%.*]], <i32 -1, i32 undef, i32 -1>
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[ARG]], <i32 128, i32 undef, i32 128>
; CHECK-NEXT:    [[T3:%.*]] = icmp ult <3 x i32> [[T2]], <i32 256, i32 256, i32 256>
; CHECK-NEXT:    [[T4:%.*]] = and <3 x i1> [[T1]], [[T3]]
; CHECK-NEXT:    ret <3 x i1> [[T4]]
;
  %t1 = icmp sgt <3 x i32> %arg, <i32 -1, i32 undef, i32 -1>
  %t2 = add <3 x i32> %arg, <i32 128, i32 undef, i32 128>
  %t3 = icmp ult <3 x i32> %t2, <i32 256, i32 256, i32 256>
  %t4 = and <3 x i1> %t1, %t3
  ret <3 x i1> %t4
}

define <3 x i1> @positive_vec_undef4(<3 x i32> %arg) {
; CHECK-LABEL: @positive_vec_undef4(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt <3 x i32> [[ARG:%.*]], <i32 -1, i32 undef, i32 -1>
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[ARG]], <i32 128, i32 128, i32 128>
; CHECK-NEXT:    [[T3:%.*]] = icmp ult <3 x i32> [[T2]], <i32 256, i32 undef, i32 256>
; CHECK-NEXT:    [[T4:%.*]] = and <3 x i1> [[T1]], [[T3]]
; CHECK-NEXT:    ret <3 x i1> [[T4]]
;
  %t1 = icmp sgt <3 x i32> %arg, <i32 -1, i32 undef, i32 -1>
  %t2 = add <3 x i32> %arg, <i32 128, i32 128, i32 128>
  %t3 = icmp ult <3 x i32> %t2, <i32 256, i32 undef, i32 256>
  %t4 = and <3 x i1> %t1, %t3
  ret <3 x i1> %t4
}

define <3 x i1> @positive_vec_undef5(<3 x i32> %arg) {
; CHECK-LABEL: @positive_vec_undef5(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt <3 x i32> [[ARG:%.*]], <i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[ARG]], <i32 128, i32 undef, i32 128>
; CHECK-NEXT:    [[T3:%.*]] = icmp ult <3 x i32> [[T2]], <i32 256, i32 undef, i32 256>
; CHECK-NEXT:    [[T4:%.*]] = and <3 x i1> [[T1]], [[T3]]
; CHECK-NEXT:    ret <3 x i1> [[T4]]
;
  %t1 = icmp sgt <3 x i32> %arg, <i32 -1, i32 -1, i32 -1>
  %t2 = add <3 x i32> %arg, <i32 128, i32 undef, i32 128>
  %t3 = icmp ult <3 x i32> %t2, <i32 256, i32 undef, i32 256>
  %t4 = and <3 x i1> %t1, %t3
  ret <3 x i1> %t4
}

define <3 x i1> @positive_vec_undef6(<3 x i32> %arg) {
; CHECK-LABEL: @positive_vec_undef6(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt <3 x i32> [[ARG:%.*]], <i32 -1, i32 undef, i32 -1>
; CHECK-NEXT:    [[T2:%.*]] = add <3 x i32> [[ARG]], <i32 128, i32 undef, i32 128>
; CHECK-NEXT:    [[T3:%.*]] = icmp ult <3 x i32> [[T2]], <i32 256, i32 undef, i32 256>
; CHECK-NEXT:    [[T4:%.*]] = and <3 x i1> [[T1]], [[T3]]
; CHECK-NEXT:    ret <3 x i1> [[T4]]
;
  %t1 = icmp sgt <3 x i32> %arg, <i32 -1, i32 undef, i32 -1>
  %t2 = add <3 x i32> %arg, <i32 128, i32 undef, i32 128>
  %t3 = icmp ult <3 x i32> %t2, <i32 256, i32 undef, i32 256>
  %t4 = and <3 x i1> %t1, %t3
  ret <3 x i1> %t4
}

; ============================================================================ ;
; Commutativity tests.
; ============================================================================ ;

declare i32 @gen32()

define i1 @commutative() {
; CHECK-LABEL: @commutative(
; CHECK-NEXT:    [[ARG:%.*]] = call i32 @gen32()
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %arg = call i32 @gen32()
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = and i1 %t3, %t1 ; swapped order
  ret i1 %t4
}

define i1 @commutative_logical() {
; CHECK-LABEL: @commutative_logical(
; CHECK-NEXT:    [[ARG:%.*]] = call i32 @gen32()
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %arg = call i32 @gen32()
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = select i1 %t3, i1 %t1, i1 false ; swapped order
  ret i1 %t4
}

define i1 @commutative_with_icmp() {
; CHECK-LABEL: @commutative_with_icmp(
; CHECK-NEXT:    [[ARG:%.*]] = call i32 @gen32()
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %arg = call i32 @gen32()
  %t1 = icmp ult i32 %arg, 512
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = and i1 %t3, %t1 ; swapped order
  ret i1 %t4
}

define i1 @commutative_with_icmp_logical() {
; CHECK-LABEL: @commutative_with_icmp_logical(
; CHECK-NEXT:    [[ARG:%.*]] = call i32 @gen32()
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %arg = call i32 @gen32()
  %t1 = icmp ult i32 %arg, 512
  %t2 = add i32 %arg, 128
  %t3 = icmp ult i32 %t2, 256
  %t4 = select i1 %t3, i1 %t1, i1 false ; swapped order
  ret i1 %t4
}

; ============================================================================ ;
; Truncations.
; ============================================================================ ;

define i1 @positive_trunc_signbit(i32 %arg) {
; CHECK-LABEL: @positive_trunc_signbit(
; CHECK-NEXT:    [[T5_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T5_SIMPLIFIED]]
;
  %t1 = trunc i32 %arg to i8
  %t2 = icmp sgt i8 %t1, -1
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @positive_trunc_signbit_logical(i32 %arg) {
; CHECK-LABEL: @positive_trunc_signbit_logical(
; CHECK-NEXT:    [[T5_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG:%.*]], 128
; CHECK-NEXT:    ret i1 [[T5_SIMPLIFIED]]
;
  %t1 = trunc i32 %arg to i8
  %t2 = icmp sgt i8 %t1, -1
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @positive_trunc_base(i32 %arg) {
; CHECK-LABEL: @positive_trunc_base(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[ARG:%.*]], 65408
; CHECK-NEXT:    [[T5_SIMPLIFIED:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[T5_SIMPLIFIED]]
;
  %t1 = trunc i32 %arg to i16
  %t2 = icmp sgt i16 %t1, -1
  %t3 = add i16 %t1, 128
  %t4 = icmp ult i16 %t3, 256
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @positive_trunc_base_logical(i32 %arg) {
; CHECK-LABEL: @positive_trunc_base_logical(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[ARG:%.*]], 65408
; CHECK-NEXT:    [[T5_SIMPLIFIED:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    ret i1 [[T5_SIMPLIFIED]]
;
  %t1 = trunc i32 %arg to i16
  %t2 = icmp sgt i16 %t1, -1
  %t3 = add i16 %t1, 128
  %t4 = icmp ult i16 %t3, 256
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @positive_different_trunc_both(i32 %arg) {
; CHECK-LABEL: @positive_different_trunc_both(
; CHECK-NEXT:    [[T1:%.*]] = trunc i32 [[ARG:%.*]] to i15
; CHECK-NEXT:    [[T2:%.*]] = icmp sgt i15 [[T1]], -1
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[ARG]] to i16
; CHECK-NEXT:    [[T4:%.*]] = add i16 [[T3]], 128
; CHECK-NEXT:    [[T5:%.*]] = icmp ult i16 [[T4]], 256
; CHECK-NEXT:    [[T6:%.*]] = and i1 [[T2]], [[T5]]
; CHECK-NEXT:    ret i1 [[T6]]
;
  %t1 = trunc i32 %arg to i15
  %t2 = icmp sgt i15 %t1, -1
  %t3 = trunc i32 %arg to i16
  %t4 = add i16 %t3, 128
  %t5 = icmp ult i16 %t4, 256
  %t6 = and i1 %t2, %t5
  ret i1 %t6
}

define i1 @positive_different_trunc_both_logical(i32 %arg) {
; CHECK-LABEL: @positive_different_trunc_both_logical(
; CHECK-NEXT:    [[T1:%.*]] = trunc i32 [[ARG:%.*]] to i15
; CHECK-NEXT:    [[T2:%.*]] = icmp sgt i15 [[T1]], -1
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[ARG]] to i16
; CHECK-NEXT:    [[T4:%.*]] = add i16 [[T3]], 128
; CHECK-NEXT:    [[T5:%.*]] = icmp ult i16 [[T4]], 256
; CHECK-NEXT:    [[T6:%.*]] = select i1 [[T2]], i1 [[T5]], i1 false
; CHECK-NEXT:    ret i1 [[T6]]
;
  %t1 = trunc i32 %arg to i15
  %t2 = icmp sgt i15 %t1, -1
  %t3 = trunc i32 %arg to i16
  %t4 = add i16 %t3, 128
  %t5 = icmp ult i16 %t4, 256
  %t6 = select i1 %t2, i1 %t5, i1 false
  ret i1 %t6
}

; ============================================================================ ;
; One-use tests.
;
; We will only produce one instruction, so we do not care about one-use.
; But, we *could* handle more patterns that we weren't able to canonicalize
; because of extra-uses.
; ============================================================================ ;

declare void @use32(i32)
declare void @use8(i8)
declare void @use1(i1)

define i1 @oneuse_with_signbit(i32 %arg) {
; CHECK-LABEL: @oneuse_with_signbit(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    call void @use1(i1 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = icmp ult i32 [[T2]], 256
; CHECK-NEXT:    call void @use1(i1 [[T3]])
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %t1 = icmp sgt i32 %arg, -1
  call void @use1(i1 %t1)
  %t2 = add i32 %arg, 128
  call void @use32(i32 %t2)
  %t3 = icmp ult i32 %t2, 256
  call void @use1(i1 %t3)
  %t4 = and i1 %t1, %t3
  ret i1 %t4
}

define i1 @oneuse_with_signbit_logical(i32 %arg) {
; CHECK-LABEL: @oneuse_with_signbit_logical(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    call void @use1(i1 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    call void @use32(i32 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = icmp ult i32 [[T2]], 256
; CHECK-NEXT:    call void @use1(i1 [[T3]])
; CHECK-NEXT:    [[T4_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG]], 128
; CHECK-NEXT:    ret i1 [[T4_SIMPLIFIED]]
;
  %t1 = icmp sgt i32 %arg, -1
  call void @use1(i1 %t1)
  %t2 = add i32 %arg, 128
  call void @use32(i32 %t2)
  %t3 = icmp ult i32 %t2, 256
  call void @use1(i1 %t3)
  %t4 = select i1 %t1, i1 %t3, i1 false
  ret i1 %t4
}

define i1 @oneuse_with_mask(i32 %arg) {
; CHECK-LABEL: @oneuse_with_mask(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], 603979776
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    call void @use1(i1 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    call void @use1(i1 [[T4]])
; CHECK-NEXT:    [[T5_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG]], 128
; CHECK-NEXT:    ret i1 [[T5_SIMPLIFIED]]
;
  %t1 = and i32 %arg, 603979776 ; some bit within the target 4294967168 mask.
  call void @use32(i32 %t1)
  %t2 = icmp eq i32 %t1, 0
  call void @use1(i1 %t2)
  %t3 = add i32 %arg, 128
  call void @use32(i32 %t3)
  %t4 = icmp ult i32 %t3, 256
  call void @use1(i1 %t4)
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @oneuse_with_mask_logical(i32 %arg) {
; CHECK-LABEL: @oneuse_with_mask_logical(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], 603979776
; CHECK-NEXT:    call void @use32(i32 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    call void @use1(i1 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    call void @use1(i1 [[T4]])
; CHECK-NEXT:    [[T5_SIMPLIFIED:%.*]] = icmp ult i32 [[ARG]], 128
; CHECK-NEXT:    ret i1 [[T5_SIMPLIFIED]]
;
  %t1 = and i32 %arg, 603979776 ; some bit within the target 4294967168 mask.
  call void @use32(i32 %t1)
  %t2 = icmp eq i32 %t1, 0
  call void @use1(i1 %t2)
  %t3 = add i32 %arg, 128
  call void @use32(i32 %t3)
  %t4 = icmp ult i32 %t3, 256
  call void @use1(i1 %t4)
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @oneuse_shl_ashr(i32 %arg) {
; CHECK-LABEL: @oneuse_shl_ashr(
; CHECK-NEXT:    [[T1:%.*]] = trunc i32 [[ARG:%.*]] to i8
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = icmp sgt i8 [[T1]], -1
; CHECK-NEXT:    call void @use1(i1 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[ARG]], 24
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = ashr exact i32 [[T3]], 24
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = icmp eq i32 [[T4]], [[ARG]]
; CHECK-NEXT:    call void @use1(i1 [[T5]])
; CHECK-NEXT:    [[T6:%.*]] = and i1 [[T2]], [[T5]]
; CHECK-NEXT:    ret i1 [[T6]]
;
  %t1 = trunc i32 %arg to i8
  call void @use8(i8 %t1)
  %t2 = icmp sgt i8 %t1, -1
  call void @use1(i1 %t2)
  %t3 = shl i32 %arg, 24
  call void @use32(i32 %t3)
  %t4 = ashr i32 %t3, 24
  call void @use32(i32 %t4)
  %t5 = icmp eq i32 %t4, %arg
  call void @use1(i1 %t5)
  %t6 = and i1 %t2, %t5
  ret i1 %t6
}

define i1 @oneuse_shl_ashr_logical(i32 %arg) {
; CHECK-LABEL: @oneuse_shl_ashr_logical(
; CHECK-NEXT:    [[T1:%.*]] = trunc i32 [[ARG:%.*]] to i8
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = icmp sgt i8 [[T1]], -1
; CHECK-NEXT:    call void @use1(i1 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = shl i32 [[ARG]], 24
; CHECK-NEXT:    call void @use32(i32 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = ashr exact i32 [[T3]], 24
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = icmp eq i32 [[T4]], [[ARG]]
; CHECK-NEXT:    call void @use1(i1 [[T5]])
; CHECK-NEXT:    [[T6:%.*]] = select i1 [[T2]], i1 [[T5]], i1 false
; CHECK-NEXT:    ret i1 [[T6]]
;
  %t1 = trunc i32 %arg to i8
  call void @use8(i8 %t1)
  %t2 = icmp sgt i8 %t1, -1
  call void @use1(i1 %t2)
  %t3 = shl i32 %arg, 24
  call void @use32(i32 %t3)
  %t4 = ashr i32 %t3, 24
  call void @use32(i32 %t4)
  %t5 = icmp eq i32 %t4, %arg
  call void @use1(i1 %t5)
  %t6 = select i1 %t2, i1 %t5, i1 false
  ret i1 %t6
}

define zeroext i1 @oneuse_trunc_sext(i32 %arg) {
; CHECK-LABEL: @oneuse_trunc_sext(
; CHECK-NEXT:    [[T1:%.*]] = trunc i32 [[ARG:%.*]] to i8
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = icmp sgt i8 [[T1]], -1
; CHECK-NEXT:    call void @use1(i1 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[ARG]] to i8
; CHECK-NEXT:    call void @use8(i8 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = sext i8 [[T3]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = icmp eq i32 [[T4]], [[ARG]]
; CHECK-NEXT:    call void @use1(i1 [[T5]])
; CHECK-NEXT:    [[T6:%.*]] = and i1 [[T2]], [[T5]]
; CHECK-NEXT:    ret i1 [[T6]]
;
  %t1 = trunc i32 %arg to i8
  call void @use8(i8 %t1)
  %t2 = icmp sgt i8 %t1, -1
  call void @use1(i1 %t2)
  %t3 = trunc i32 %arg to i8
  call void @use8(i8 %t3)
  %t4 = sext i8 %t3 to i32
  call void @use32(i32 %t4)
  %t5 = icmp eq i32 %t4, %arg
  call void @use1(i1 %t5)
  %t6 = and i1 %t2, %t5
  ret i1 %t6
}

define zeroext i1 @oneuse_trunc_sext_logical(i32 %arg) {
; CHECK-LABEL: @oneuse_trunc_sext_logical(
; CHECK-NEXT:    [[T1:%.*]] = trunc i32 [[ARG:%.*]] to i8
; CHECK-NEXT:    call void @use8(i8 [[T1]])
; CHECK-NEXT:    [[T2:%.*]] = icmp sgt i8 [[T1]], -1
; CHECK-NEXT:    call void @use1(i1 [[T2]])
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[ARG]] to i8
; CHECK-NEXT:    call void @use8(i8 [[T3]])
; CHECK-NEXT:    [[T4:%.*]] = sext i8 [[T3]] to i32
; CHECK-NEXT:    call void @use32(i32 [[T4]])
; CHECK-NEXT:    [[T5:%.*]] = icmp eq i32 [[T4]], [[ARG]]
; CHECK-NEXT:    call void @use1(i1 [[T5]])
; CHECK-NEXT:    [[T6:%.*]] = select i1 [[T2]], i1 [[T5]], i1 false
; CHECK-NEXT:    ret i1 [[T6]]
;
  %t1 = trunc i32 %arg to i8
  call void @use8(i8 %t1)
  %t2 = icmp sgt i8 %t1, -1
  call void @use1(i1 %t2)
  %t3 = trunc i32 %arg to i8
  call void @use8(i8 %t3)
  %t4 = sext i8 %t3 to i32
  call void @use32(i32 %t4)
  %t5 = icmp eq i32 %t4, %arg
  call void @use1(i1 %t5)
  %t6 = select i1 %t2, i1 %t5, i1 false
  ret i1 %t6
}

; ============================================================================ ;
; Negative tests
; ============================================================================ ;

define i1 @negative_not_arg(i32 %arg, i32 %arg2) {
; CHECK-LABEL: @negative_not_arg(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[ARG2:%.*]], 128
; CHECK-NEXT:    [[T3:%.*]] = icmp ult i32 [[T2]], 256
; CHECK-NEXT:    [[T4:%.*]] = and i1 [[T1]], [[T3]]
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg2, 128 ; not %arg
  %t3 = icmp ult i32 %t2, 256
  %t4 = and i1 %t1, %t3
  ret i1 %t4
}

define i1 @negative_not_arg_logical(i32 %arg, i32 %arg2) {
; CHECK-LABEL: @negative_not_arg_logical(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[ARG2:%.*]], 128
; CHECK-NEXT:    [[T3:%.*]] = icmp ult i32 [[T2]], 256
; CHECK-NEXT:    [[T4:%.*]] = select i1 [[T1]], i1 [[T3]], i1 false
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg2, 128 ; not %arg
  %t3 = icmp ult i32 %t2, 256
  %t4 = select i1 %t1, i1 %t3, i1 false
  ret i1 %t4
}

define i1 @negative_trunc_not_arg(i32 %arg, i32 %arg2) {
; CHECK-LABEL: @negative_trunc_not_arg(
; CHECK-NEXT:    [[T1:%.*]] = trunc i32 [[ARG:%.*]] to i8
; CHECK-NEXT:    [[T2:%.*]] = icmp sgt i8 [[T1]], -1
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG2:%.*]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = trunc i32 %arg to i8
  %t2 = icmp sgt i8 %t1, -1
  %t3 = add i32 %arg2, 128 ; not %arg
  %t4 = icmp ult i32 %t3, 256
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @negative_trunc_not_arg_logical(i32 %arg, i32 %arg2) {
; CHECK-LABEL: @negative_trunc_not_arg_logical(
; CHECK-NEXT:    [[T1:%.*]] = trunc i32 [[ARG:%.*]] to i8
; CHECK-NEXT:    [[T2:%.*]] = icmp sgt i8 [[T1]], -1
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG2:%.*]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = select i1 [[T2]], i1 [[T4]], i1 false
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = trunc i32 %arg to i8
  %t2 = icmp sgt i8 %t1, -1
  %t3 = add i32 %arg2, 128 ; not %arg
  %t4 = icmp ult i32 %t3, 256
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @positive_with_mask_not_arg(i32 %arg, i32 %arg2) {
; CHECK-LABEL: @positive_with_mask_not_arg(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], 1140850688
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG2:%.*]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = and i32 %arg, 1140850688
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg2, 128 ; not %arg
  %t4 = icmp ult i32 %t3, 256
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @positive_with_mask_not_arg_logical(i32 %arg, i32 %arg2) {
; CHECK-LABEL: @positive_with_mask_not_arg_logical(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], 1140850688
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG2:%.*]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = select i1 [[T2]], i1 [[T4]], i1 false
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = and i32 %arg, 1140850688
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg2, 128 ; not %arg
  %t4 = icmp ult i32 %t3, 256
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @negative_with_nonuniform_bad_mask(i32 %arg) {
; CHECK-LABEL: @negative_with_nonuniform_bad_mask(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], 1711276033
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = and i32 %arg, 1711276033 ; lowest bit is set
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @negative_with_nonuniform_bad_mask_logical(i32 %arg) {
; CHECK-LABEL: @negative_with_nonuniform_bad_mask_logical(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], 1711276033
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = and i32 %arg, 1711276033 ; lowest bit is set
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @negative_with_uniform_bad_mask(i32 %arg) {
; CHECK-LABEL: @negative_with_uniform_bad_mask(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], -16777152
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = and i32 %arg, 4278190144 ; 7'th bit is set
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @negative_with_uniform_bad_mask_logical(i32 %arg) {
; CHECK-LABEL: @negative_with_uniform_bad_mask_logical(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], -16777152
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = and i32 %arg, 4278190144 ; 7'th bit is set
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @negative_with_wrong_mask(i32 %arg) {
; CHECK-LABEL: @negative_with_wrong_mask(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], 1
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = and i32 %arg, 1 ; not even checking the right mask
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @negative_with_wrong_mask_logical(i32 %arg) {
; CHECK-LABEL: @negative_with_wrong_mask_logical(
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[ARG:%.*]], 1
; CHECK-NEXT:    [[T2:%.*]] = icmp eq i32 [[T1]], 0
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = and i32 %arg, 1 ; not even checking the right mask
  %t2 = icmp eq i32 %t1, 0
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @negative_not_less_than(i32 %arg) {
; CHECK-LABEL: @negative_not_less_than(
; CHECK-NEXT:    ret i1 false
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 256 ; should be less than 256
  %t3 = icmp ult i32 %t2, 256
  %t4 = and i1 %t1, %t3
  ret i1 %t4
}

define i1 @negative_not_less_than_logical(i32 %arg) {
; CHECK-LABEL: @negative_not_less_than_logical(
; CHECK-NEXT:    ret i1 false
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 256 ; should be less than 256
  %t3 = icmp ult i32 %t2, 256
  %t4 = select i1 %t1, i1 %t3, i1 false
  ret i1 %t4
}

define i1 @negative_not_power_of_two(i32 %arg) {
; CHECK-LABEL: @negative_not_power_of_two(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[ARG]], 255
; CHECK-NEXT:    [[T3:%.*]] = icmp ult i32 [[T2]], 256
; CHECK-NEXT:    [[T4:%.*]] = and i1 [[T1]], [[T3]]
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 255 ; should be power of two
  %t3 = icmp ult i32 %t2, 256
  %t4 = and i1 %t1, %t3
  ret i1 %t4
}

define i1 @negative_not_power_of_two_logical(i32 %arg) {
; CHECK-LABEL: @negative_not_power_of_two_logical(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[ARG]], 255
; CHECK-NEXT:    [[T3:%.*]] = icmp ult i32 [[T2]], 256
; CHECK-NEXT:    [[T4:%.*]] = and i1 [[T1]], [[T3]]
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 255 ; should be power of two
  %t3 = icmp ult i32 %t2, 256
  %t4 = select i1 %t1, i1 %t3, i1 false
  ret i1 %t4
}

define i1 @negative_not_next_power_of_two(i32 %arg) {
; CHECK-LABEL: @negative_not_next_power_of_two(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[ARG]], 64
; CHECK-NEXT:    [[T3:%.*]] = icmp ult i32 [[T2]], 256
; CHECK-NEXT:    [[T4:%.*]] = and i1 [[T1]], [[T3]]
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 64 ; should be 256 >> 1
  %t3 = icmp ult i32 %t2, 256
  %t4 = and i1 %t1, %t3
  ret i1 %t4
}

define i1 @negative_not_next_power_of_two_logical(i32 %arg) {
; CHECK-LABEL: @negative_not_next_power_of_two_logical(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    [[T2:%.*]] = add i32 [[ARG]], 64
; CHECK-NEXT:    [[T3:%.*]] = icmp ult i32 [[T2]], 256
; CHECK-NEXT:    [[T4:%.*]] = and i1 [[T1]], [[T3]]
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t1 = icmp sgt i32 %arg, -1
  %t2 = add i32 %arg, 64 ; should be 256 >> 1
  %t3 = icmp ult i32 %t2, 256
  %t4 = select i1 %t1, i1 %t3, i1 false
  ret i1 %t4
}

; I don't think this can be folded, at least not into single instruction.
define i1 @two_signed_truncation_checks(i32 %arg) {
; CHECK-LABEL: @two_signed_truncation_checks(
; CHECK-NEXT:    [[T1:%.*]] = add i32 [[ARG:%.*]], 512
; CHECK-NEXT:    [[T2:%.*]] = icmp ult i32 [[T1]], 1024
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = add i32 %arg, 512
  %t2 = icmp ult i32 %t1, 1024
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = and i1 %t2, %t4
  ret i1 %t5
}

define i1 @two_signed_truncation_checks_logical(i32 %arg) {
; CHECK-LABEL: @two_signed_truncation_checks_logical(
; CHECK-NEXT:    [[T1:%.*]] = add i32 [[ARG:%.*]], 512
; CHECK-NEXT:    [[T2:%.*]] = icmp ult i32 [[T1]], 1024
; CHECK-NEXT:    [[T3:%.*]] = add i32 [[ARG]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i32 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T2]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = add i32 %arg, 512
  %t2 = icmp ult i32 %t1, 1024
  %t3 = add i32 %arg, 128
  %t4 = icmp ult i32 %t3, 256
  %t5 = select i1 %t2, i1 %t4, i1 false
  ret i1 %t5
}

define i1 @bad_trunc_stc(i32 %arg) {
; CHECK-LABEL: @bad_trunc_stc(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    [[T2:%.*]] = trunc i32 [[ARG]] to i16
; CHECK-NEXT:    [[T3:%.*]] = add i16 [[T2]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i16 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = and i1 [[T1]], [[T4]]
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = icmp sgt i32 %arg, -1 ; checks a bit outside of the i16
  %t2 = trunc i32 %arg to i16
  %t3 = add i16 %t2, 128
  %t4 = icmp ult i16 %t3, 256
  %t5 = and i1 %t1, %t4
  ret i1 %t5
}

define i1 @bad_trunc_stc_logical(i32 %arg) {
; CHECK-LABEL: @bad_trunc_stc_logical(
; CHECK-NEXT:    [[T1:%.*]] = icmp sgt i32 [[ARG:%.*]], -1
; CHECK-NEXT:    [[T2:%.*]] = trunc i32 [[ARG]] to i16
; CHECK-NEXT:    [[T3:%.*]] = add i16 [[T2]], 128
; CHECK-NEXT:    [[T4:%.*]] = icmp ult i16 [[T3]], 256
; CHECK-NEXT:    [[T5:%.*]] = select i1 [[T1]], i1 [[T4]], i1 false
; CHECK-NEXT:    ret i1 [[T5]]
;
  %t1 = icmp sgt i32 %arg, -1 ; checks a bit outside of the i16
  %t2 = trunc i32 %arg to i16
  %t3 = add i16 %t2, 128
  %t4 = icmp ult i16 %t3, 256
  %t5 = select i1 %t1, i1 %t4, i1 false
  ret i1 %t5
}
