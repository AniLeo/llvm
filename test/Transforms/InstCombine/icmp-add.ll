; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use(i32)

; PR1949

define i1 @test1(i32 %a) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[A:%.*]], -5
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = add i32 %a, 4
  %c = icmp ult i32 %b, 4
  ret i1 %c
}

define <2 x i1> @test1vec(<2 x i32> %a) {
; CHECK-LABEL: @test1vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ugt <2 x i32> [[A:%.*]], <i32 -5, i32 -5>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = add <2 x i32> %a, <i32 4, i32 4>
  %c = icmp ult <2 x i32> %b, <i32 4, i32 4>
  ret <2 x i1> %c
}

define i1 @test2(i32 %a) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[A:%.*]], 4
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = sub i32 %a, 4
  %c = icmp ugt i32 %b, -5
  ret i1 %c
}

define <2 x i1> @test2vec(<2 x i32> %a) {
; CHECK-LABEL: @test2vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ult <2 x i32> [[A:%.*]], <i32 4, i32 4>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = sub <2 x i32> %a, <i32 4, i32 4>
  %c = icmp ugt <2 x i32> %b, <i32 -5, i32 -5>
  ret <2 x i1> %c
}

define i1 @test3(i32 %a) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[A:%.*]], 2147483643
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = add i32 %a, 4
  %c = icmp slt i32 %b, 2147483652
  ret i1 %c
}

define <2 x i1> @test3vec(<2 x i32> %a) {
; CHECK-LABEL: @test3vec(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt <2 x i32> [[A:%.*]], <i32 2147483643, i32 2147483643>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = add <2 x i32> %a, <i32 4, i32 4>
  %c = icmp slt <2 x i32> %b, <i32 2147483652, i32 2147483652>
  ret <2 x i1> %c
}

define i1 @test4(i32 %a) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[A:%.*]], -4
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = add i32 %a, 2147483652
  %c = icmp sge i32 %b, 4
  ret i1 %c
}

define { i32, i1 } @test4multiuse(i32 %a) {
; CHECK-LABEL: @test4multiuse(
; CHECK-NEXT:    [[B:%.*]] = add nsw i32 [[A:%.*]], -2147483644
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[A]], 2147483640
; CHECK-NEXT:    [[TMP:%.*]] = insertvalue { i32, i1 } undef, i32 [[B]], 0
; CHECK-NEXT:    [[RES:%.*]] = insertvalue { i32, i1 } [[TMP]], i1 [[C]], 1
; CHECK-NEXT:    ret { i32, i1 } [[RES]]
;

  %b = add nsw i32 %a, -2147483644
  %c = icmp slt i32 %b, -4

  %tmp = insertvalue { i32, i1 } undef, i32 %b, 0
  %res = insertvalue { i32, i1 } %tmp, i1 %c, 1

  ret { i32, i1 } %res
}

define <2 x i1> @test4vec(<2 x i32> %a) {
; CHECK-LABEL: @test4vec(
; CHECK-NEXT:    [[C:%.*]] = icmp slt <2 x i32> [[A:%.*]], <i32 -4, i32 -4>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = add <2 x i32> %a, <i32 2147483652, i32 2147483652>
  %c = icmp sge <2 x i32> %b, <i32 4, i32 4>
  ret <2 x i1> %c
}

; icmp Pred (add nsw X, C2), C --> icmp Pred X, (C - C2), when C - C2 does not overflow.
; This becomes equality because it's at the limit.

define i1 @nsw_slt1(i8 %a) {
; CHECK-LABEL: @nsw_slt1(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i8 [[A:%.*]], -128
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = add nsw i8 %a, 100
  %c = icmp slt i8 %b, -27
  ret i1 %c
}

define <2 x i1> @nsw_slt1_splat_vec(<2 x i8> %a) {
; CHECK-LABEL: @nsw_slt1_splat_vec(
; CHECK-NEXT:    [[C:%.*]] = icmp eq <2 x i8> [[A:%.*]], <i8 -128, i8 -128>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = add nsw <2 x i8> %a, <i8 100, i8 100>
  %c = icmp slt <2 x i8> %b, <i8 -27, i8 -27>
  ret <2 x i1> %c
}

; icmp Pred (add nsw X, C2), C --> icmp Pred X, (C - C2), when C - C2 does not overflow.
; This becomes equality because it's at the limit.

define i1 @nsw_slt2(i8 %a) {
; CHECK-LABEL: @nsw_slt2(
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[A:%.*]], 127
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = add nsw i8 %a, -100
  %c = icmp slt i8 %b, 27
  ret i1 %c
}

define <2 x i1> @nsw_slt2_splat_vec(<2 x i8> %a) {
; CHECK-LABEL: @nsw_slt2_splat_vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ne <2 x i8> [[A:%.*]], <i8 127, i8 127>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = add nsw <2 x i8> %a, <i8 -100, i8 -100>
  %c = icmp slt <2 x i8> %b, <i8 27, i8 27>
  ret <2 x i1> %c
}

; icmp Pred (add nsw X, C2), C --> icmp Pred X, (C - C2), when C - C2 does not overflow.
; Less than the limit, so the predicate doesn't change.

define i1 @nsw_slt3(i8 %a) {
; CHECK-LABEL: @nsw_slt3(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[A:%.*]], -126
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = add nsw i8 %a, 100
  %c = icmp slt i8 %b, -26
  ret i1 %c
}

; icmp Pred (add nsw X, C2), C --> icmp Pred X, (C - C2), when C - C2 does not overflow.
; Less than the limit, so the predicate doesn't change.

define i1 @nsw_slt4(i8 %a) {
; CHECK-LABEL: @nsw_slt4(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i8 [[A:%.*]], 126
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = add nsw i8 %a, -100
  %c = icmp slt i8 %b, 26
  ret i1 %c
}

; icmp Pred (add nsw X, C2), C --> icmp Pred X, (C - C2), when C - C2 does not overflow.
; Try sgt to make sure that works too.

define i1 @nsw_sgt1(i8 %a) {
; CHECK-LABEL: @nsw_sgt1(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i8 [[A:%.*]], 127
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = add nsw i8 %a, -100
  %c = icmp sgt i8 %b, 26
  ret i1 %c
}

define <2 x i1> @nsw_sgt1_splat_vec(<2 x i8> %a) {
; CHECK-LABEL: @nsw_sgt1_splat_vec(
; CHECK-NEXT:    [[C:%.*]] = icmp eq <2 x i8> [[A:%.*]], <i8 127, i8 127>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = add nsw <2 x i8> %a, <i8 -100, i8 -100>
  %c = icmp sgt <2 x i8> %b, <i8 26, i8 26>
  ret <2 x i1> %c
}

define i1 @nsw_sgt2(i8 %a) {
; CHECK-LABEL: @nsw_sgt2(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i8 [[A:%.*]], -126
; CHECK-NEXT:    ret i1 [[C]]
;
  %b = add nsw i8 %a, 100
  %c = icmp sgt i8 %b, -26
  ret i1 %c
}

define <2 x i1> @nsw_sgt2_splat_vec(<2 x i8> %a) {
; CHECK-LABEL: @nsw_sgt2_splat_vec(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt <2 x i8> [[A:%.*]], <i8 -126, i8 -126>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = add nsw <2 x i8> %a, <i8 100, i8 100>
  %c = icmp sgt <2 x i8> %b, <i8 -26, i8 -26>
  ret <2 x i1> %c
}

; icmp Pred (add nsw X, C2), C --> icmp Pred X, (C - C2), when C - C2 does not overflow.
; Comparison with 0 doesn't need special-casing.

define i1 @slt_zero_add_nsw(i32 %a) {
; CHECK-LABEL: @slt_zero_add_nsw(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[A:%.*]], -1
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %add = add nsw i32 %a, 1
  %cmp = icmp slt i32 %add, 0
  ret i1 %cmp
}

; The same fold should work with vectors.

define <2 x i1> @slt_zero_add_nsw_splat_vec(<2 x i8> %a) {
; CHECK-LABEL: @slt_zero_add_nsw_splat_vec(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt <2 x i8> [[A:%.*]], <i8 -1, i8 -1>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %add = add nsw <2 x i8> %a, <i8 1, i8 1>
  %cmp = icmp slt <2 x i8> %add, zeroinitializer
  ret <2 x i1> %cmp
}

; Test the edges - instcombine should not interfere with simplification to constants.
; Constant subtraction does not overflow, but this is false.

define i1 @nsw_slt3_ov_no(i8 %a) {
; CHECK-LABEL: @nsw_slt3_ov_no(
; CHECK-NEXT:    ret i1 false
;
  %b = add nsw i8 %a, 100
  %c = icmp slt i8 %b, -28
  ret i1 %c
}

; Test the edges - instcombine should not interfere with simplification to constants.
; Constant subtraction overflows. This is false.

define i1 @nsw_slt4_ov(i8 %a) {
; CHECK-LABEL: @nsw_slt4_ov(
; CHECK-NEXT:    ret i1 false
;
  %b = add nsw i8 %a, 100
  %c = icmp slt i8 %b, -29
  ret i1 %c
}

; Test the edges - instcombine should not interfere with simplification to constants.
; Constant subtraction overflows. This is true.

define i1 @nsw_slt5_ov(i8 %a) {
; CHECK-LABEL: @nsw_slt5_ov(
; CHECK-NEXT:    ret i1 true
;
  %b = add nsw i8 %a, -100
  %c = icmp slt i8 %b, 28
  ret i1 %c
}

; InstCombine should not thwart this opportunity to simplify completely.

define i1 @slt_zero_add_nsw_signbit(i8 %x) {
; CHECK-LABEL: @slt_zero_add_nsw_signbit(
; CHECK-NEXT:    ret i1 true
;
  %y = add nsw i8 %x, -128
  %z = icmp slt i8 %y, 0
  ret i1 %z
}

; InstCombine should not thwart this opportunity to simplify completely.

define i1 @slt_zero_add_nuw_signbit(i8 %x) {
; CHECK-LABEL: @slt_zero_add_nuw_signbit(
; CHECK-NEXT:    ret i1 true
;
  %y = add nuw i8 %x, 128
  %z = icmp slt i8 %y, 0
  ret i1 %z
}

define i1 @reduce_add_ult(i32 %in) {
; CHECK-LABEL: @reduce_add_ult(
; CHECK-NEXT:    [[A18:%.*]] = icmp ult i32 [[IN:%.*]], 9
; CHECK-NEXT:    ret i1 [[A18]]
;
  %a6 = add nuw i32 %in, 3
  %a18 = icmp ult i32 %a6, 12
  ret i1 %a18
}

define i1 @reduce_add_ugt(i32 %in) {
; CHECK-LABEL: @reduce_add_ugt(
; CHECK-NEXT:    [[A18:%.*]] = icmp ugt i32 [[IN:%.*]], 9
; CHECK-NEXT:    ret i1 [[A18]]
;
  %a6 = add nuw i32 %in, 3
  %a18 = icmp ugt i32 %a6, 12
  ret i1 %a18
}

define i1 @reduce_add_ule(i32 %in) {
; CHECK-LABEL: @reduce_add_ule(
; CHECK-NEXT:    [[A18:%.*]] = icmp ult i32 [[IN:%.*]], 10
; CHECK-NEXT:    ret i1 [[A18]]
;
  %a6 = add nuw i32 %in, 3
  %a18 = icmp ule i32 %a6, 12
  ret i1 %a18
}

define i1 @reduce_add_uge(i32 %in) {
; CHECK-LABEL: @reduce_add_uge(
; CHECK-NEXT:    [[A18:%.*]] = icmp ugt i32 [[IN:%.*]], 8
; CHECK-NEXT:    ret i1 [[A18]]
;
  %a6 = add nuw i32 %in, 3
  %a18 = icmp uge i32 %a6, 12
  ret i1 %a18
}

define i1 @ult_add_ssubov(i32 %in) {
; CHECK-LABEL: @ult_add_ssubov(
; CHECK-NEXT:    ret i1 false
;
  %a6 = add nuw i32 %in, 71
  %a18 = icmp ult i32 %a6, 3
  ret i1 %a18
}

define i1 @ult_add_nonuw(i8 %in) {
; CHECK-LABEL: @ult_add_nonuw(
; CHECK-NEXT:    [[A6:%.*]] = add i8 [[IN:%.*]], 71
; CHECK-NEXT:    [[A18:%.*]] = icmp ult i8 [[A6]], 12
; CHECK-NEXT:    ret i1 [[A18]]
;
  %a6 = add i8 %in, 71
  %a18 = icmp ult i8 %a6, 12
  ret i1 %a18
}

define i1 @uge_add_nonuw(i32 %in) {
; CHECK-LABEL: @uge_add_nonuw(
; CHECK-NEXT:    [[A6:%.*]] = add i32 [[IN:%.*]], 3
; CHECK-NEXT:    [[A18:%.*]] = icmp ugt i32 [[A6]], 11
; CHECK-NEXT:    ret i1 [[A18]]
;
  %a6 = add i32 %in, 3
  %a18 = icmp uge i32 %a6, 12
  ret i1 %a18
}

; Test unsigned add overflow patterns. The div ops are only here to
; thwart complexity based canonicalization of the operand order.

define i1 @op_ugt_sum_commute1(i8 %p1, i8 %p2) {
; CHECK-LABEL: @op_ugt_sum_commute1(
; CHECK-NEXT:    [[X:%.*]] = sdiv i8 42, [[P1:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = sdiv i8 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[X]], -1
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i8 [[Y]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %x = sdiv i8 42, %p1
  %y = sdiv i8 42, %p2
  %a = add i8 %x, %y
  %c = icmp ugt i8 %x, %a
  ret i1 %c
}

define <2 x i1> @op_ugt_sum_vec_commute2(<2 x i8> %p1, <2 x i8> %p2) {
; CHECK-LABEL: @op_ugt_sum_vec_commute2(
; CHECK-NEXT:    [[X:%.*]] = sdiv <2 x i8> <i8 42, i8 -42>, [[P1:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = sdiv <2 x i8> <i8 42, i8 -42>, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i8> [[X]], <i8 -1, i8 -1>
; CHECK-NEXT:    [[C:%.*]] = icmp ugt <2 x i8> [[Y]], [[TMP1]]
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %x = sdiv <2 x i8> <i8 42, i8 -42>, %p1
  %y = sdiv <2 x i8> <i8 42, i8 -42>, %p2
  %a = add <2 x i8> %y, %x
  %c = icmp ugt <2 x i8> %x, %a
  ret <2 x i1> %c
}

define i1 @sum_ugt_op_uses(i8 %p1, i8 %p2, i8* %p3) {
; CHECK-LABEL: @sum_ugt_op_uses(
; CHECK-NEXT:    [[X:%.*]] = sdiv i8 42, [[P1:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = sdiv i8 42, [[P2:%.*]]
; CHECK-NEXT:    [[A:%.*]] = add nsw i8 [[X]], [[Y]]
; CHECK-NEXT:    store i8 [[A]], i8* [[P3:%.*]], align 1
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i8 [[X]], [[A]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %x = sdiv i8 42, %p1
  %y = sdiv i8 42, %p2
  %a = add i8 %x, %y
  store i8 %a, i8* %p3
  %c = icmp ugt i8 %x, %a
  ret i1 %c
}

define <2 x i1> @sum_ult_op_vec_commute1(<2 x i8> %p1, <2 x i8> %p2) {
; CHECK-LABEL: @sum_ult_op_vec_commute1(
; CHECK-NEXT:    [[X:%.*]] = sdiv <2 x i8> <i8 42, i8 -42>, [[P1:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = sdiv <2 x i8> <i8 -42, i8 42>, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i8> [[X]], <i8 -1, i8 -1>
; CHECK-NEXT:    [[C:%.*]] = icmp ugt <2 x i8> [[Y]], [[TMP1]]
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %x = sdiv <2 x i8> <i8 42, i8 -42>, %p1
  %y = sdiv <2 x i8> <i8 -42, i8 42>, %p2
  %a = add <2 x i8> %x, %y
  %c = icmp ult <2 x i8> %a, %x
  ret <2 x i1> %c
}

define i1 @sum_ult_op_commute2(i8 %p1, i8 %p2) {
; CHECK-LABEL: @sum_ult_op_commute2(
; CHECK-NEXT:    [[X:%.*]] = sdiv i8 42, [[P1:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = sdiv i8 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i8 [[X]], -1
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i8 [[Y]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %x = sdiv i8 42, %p1
  %y = sdiv i8 42, %p2
  %a = add i8 %y, %x
  %c = icmp ult i8 %a, %x
  ret i1 %c
}

define i1 @sum_ult_op_uses(i8 %x, i8 %y, i8* %p) {
; CHECK-LABEL: @sum_ult_op_uses(
; CHECK-NEXT:    [[A:%.*]] = add i8 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    store i8 [[A]], i8* [[P:%.*]], align 1
; CHECK-NEXT:    [[C:%.*]] = icmp ult i8 [[A]], [[X]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %a = add i8 %y, %x
  store i8 %a, i8* %p
  %c = icmp ult i8 %a, %x
  ret i1 %c
}

; X + Z >s Y + Z -> X > Y if there is no overflow.
define i1 @common_op_nsw(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @common_op_nsw(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %lhs = add nsw i32 %x, %z
  %rhs = add nsw i32 %y, %z
  %c = icmp sgt i32 %lhs, %rhs
  ret i1 %c
}

define i1 @common_op_nsw_extra_uses(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @common_op_nsw_extra_uses(
; CHECK-NEXT:    [[LHS:%.*]] = add nsw i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    call void @use(i32 [[LHS]])
; CHECK-NEXT:    [[RHS:%.*]] = add nsw i32 [[Y:%.*]], [[Z]]
; CHECK-NEXT:    call void @use(i32 [[RHS]])
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %lhs = add nsw i32 %x, %z
  call void @use(i32 %lhs)
  %rhs = add nsw i32 %y, %z
  call void @use(i32 %rhs)
  %c = icmp sgt i32 %lhs, %rhs
  ret i1 %c
}

; X + Z >u Z + Y -> X > Y if there is no overflow.
define i1 @common_op_nuw(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @common_op_nuw(
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %lhs = add nuw i32 %x, %z
  %rhs = add nuw i32 %z, %y
  %c = icmp ugt i32 %lhs, %rhs
  ret i1 %c
}

define i1 @common_op_nuw_extra_uses(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @common_op_nuw_extra_uses(
; CHECK-NEXT:    [[LHS:%.*]] = add nuw i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    call void @use(i32 [[LHS]])
; CHECK-NEXT:    [[RHS:%.*]] = add nuw i32 [[Z]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(i32 [[RHS]])
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %lhs = add nuw i32 %x, %z
  call void @use(i32 %lhs)
  %rhs = add nuw i32 %z, %y
  call void @use(i32 %rhs)
  %c = icmp ugt i32 %lhs, %rhs
  ret i1 %c
}

define i1 @common_op_nsw_commute(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @common_op_nsw_commute(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %lhs = add nsw i32 %z, %x
  %rhs = add nsw i32 %y, %z
  %c = icmp slt i32 %lhs, %rhs
  ret i1 %c
}

define i1 @common_op_nuw_commute(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @common_op_nuw_commute(
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %lhs = add nuw i32 %z, %x
  %rhs = add nuw i32 %z, %y
  %c = icmp ult i32 %lhs, %rhs
  ret i1 %c
}

; X + Y > X -> Y > 0 if there is no overflow.
define i1 @common_op_test29(i32 %x, i32 %y) {
; CHECK-LABEL: @common_op_test29(
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %lhs = add nsw i32 %x, %y
  %c = icmp sgt i32 %lhs, %x
  ret i1 %c
}

; X + Y > X -> Y > 0 if there is no overflow.
define i1 @sum_nuw(i32 %x, i32 %y) {
; CHECK-LABEL: @sum_nuw(
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %lhs = add nuw i32 %x, %y
  %c = icmp ugt i32 %lhs, %x
  ret i1 %c
}

; X > X + Y -> 0 > Y if there is no overflow.
define i1 @sum_nsw_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @sum_nsw_commute(
; CHECK-NEXT:    [[C:%.*]] = icmp slt i32 [[Y:%.*]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %rhs = add nsw i32 %x, %y
  %c = icmp sgt i32 %x, %rhs
  ret i1 %c
}

; X > X + Y -> 0 > Y if there is no overflow.
define i1 @sum_nuw_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @sum_nuw_commute(
; CHECK-NEXT:    ret i1 false
;
  %rhs = add nuw i32 %x, %y
  %c = icmp ugt i32 %x, %rhs
  ret i1 %c
}

; PR2698 - https://bugs.llvm.org/show_bug.cgi?id=2698

declare void @use1(i1)
declare void @use8(i8)

define void @bzip1(i8 %a, i8 %b, i8 %x) {
; CHECK-LABEL: @bzip1(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[CMP]])
; CHECK-NEXT:    ret void
;
  %add1 = add i8 %a, %x
  %add2 = add i8 %b, %x
  %cmp = icmp eq i8 %add1, %add2
  call void @use1(i1 %cmp)
  ret void
}

define void @bzip2(i8 %a, i8 %b, i8 %x) {
; CHECK-LABEL: @bzip2(
; CHECK-NEXT:    [[ADD1:%.*]] = add i8 [[A:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], [[B:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[CMP]])
; CHECK-NEXT:    call void @use8(i8 [[ADD1]])
; CHECK-NEXT:    ret void
;
  %add1 = add i8 %a, %x
  %add2 = add i8 %b, %x
  %cmp = icmp eq i8 %add1, %add2
  call void @use1(i1 %cmp)
  call void @use8(i8 %add1)
  ret void
}

define <2 x i1> @icmp_eq_add_undef(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_add_undef(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[A:%.*]], <i32 5, i32 undef>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %add = add <2 x i32> %a, <i32 5, i32 undef>
  %cmp = icmp eq <2 x i32> %add, <i32 10, i32 10>
  ret <2 x i1> %cmp
}

define <2 x i1> @icmp_eq_add_non_splat(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_add_non_splat(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[A:%.*]], <i32 5, i32 4>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %add = add <2 x i32> %a, <i32 5, i32 6>
  %cmp = icmp eq <2 x i32> %add, <i32 10, i32 10>
  ret <2 x i1> %cmp
}

define <2 x i1> @icmp_eq_add_undef2(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_add_undef2(
; CHECK-NEXT:    [[ADD:%.*]] = add <2 x i32> [[A:%.*]], <i32 5, i32 5>
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[ADD]], <i32 10, i32 undef>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %add = add <2 x i32> %a, <i32 5, i32 5>
  %cmp = icmp eq <2 x i32> %add, <i32 10, i32 undef>
  ret <2 x i1> %cmp
}

define <2 x i1> @icmp_eq_add_non_splat2(<2 x i32> %a) {
; CHECK-LABEL: @icmp_eq_add_non_splat2(
; CHECK-NEXT:    [[ADD:%.*]] = add <2 x i32> [[A:%.*]], <i32 5, i32 5>
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <2 x i32> [[ADD]], <i32 10, i32 11>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %add = add <2 x i32> %a, <i32 5, i32 5>
  %cmp = icmp eq <2 x i32> %add, <i32 10, i32 11>
  ret <2 x i1> %cmp
}

define i1 @without_nsw_nuw(i8 %x, i8 %y) {
; CHECK-LABEL: @without_nsw_nuw(
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[X:%.*]], 2
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i8 [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[TOBOOL]]
;
  %t1 = add i8 %x, 37
  %t2 = add i8 %y, 35
  %tobool = icmp eq i8 %t2, %t1
  ret i1 %tobool
}

define i1 @with_nsw_nuw(i8 %x, i8 %y) {
; CHECK-LABEL: @with_nsw_nuw(
; CHECK-NEXT:    [[TMP1:%.*]] = add nuw nsw i8 [[X:%.*]], 2
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i8 [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[TOBOOL]]
;
  %t1 = add nsw nuw i8 %x, 37
  %t2 = add i8 %y, 35
  %tobool = icmp eq i8 %t2, %t1
  ret i1 %tobool
}

define i1 @with_nsw_large(i8 %x, i8 %y) {
; CHECK-LABEL: @with_nsw_large(
; CHECK-NEXT:    [[TMP1:%.*]] = add nsw i8 [[X:%.*]], 2
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i8 [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[TOBOOL]]
;
  %t1 = add nsw i8 %x, 37
  %t2 = add i8 %y, 35
  %tobool = icmp eq i8 %t2, %t1
  ret i1 %tobool
}

define i1 @with_nsw_small(i8 %x, i8 %y) {
; CHECK-LABEL: @with_nsw_small(
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y:%.*]], 2
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[TOBOOL]]
;
  %t1 = add nsw i8 %x, 35
  %t2 = add i8 %y, 37
  %tobool = icmp eq i8 %t2, %t1
  ret i1 %tobool
}

define i1 @with_nuw_large(i8 %x, i8 %y) {
; CHECK-LABEL: @with_nuw_large(
; CHECK-NEXT:    [[TMP1:%.*]] = add nuw i8 [[X:%.*]], 2
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i8 [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[TOBOOL]]
;
  %t1 = add nuw i8 %x, 37
  %t2 = add i8 %y, 35
  %tobool = icmp eq i8 %t2, %t1
  ret i1 %tobool
}

define i1 @with_nuw_small(i8 %x, i8 %y) {
; CHECK-LABEL: @with_nuw_small(
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[Y:%.*]], 2
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i8 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    ret i1 [[TOBOOL]]
;
  %t1 = add nuw i8 %x, 35
  %t2 = add i8 %y, 37
  %tobool = icmp eq i8 %t2, %t1
  ret i1 %tobool
}

define i1 @with_nuw_large_negative(i8 %x, i8 %y) {
; CHECK-LABEL: @with_nuw_large_negative(
; CHECK-NEXT:    [[TMP1:%.*]] = add i8 [[X:%.*]], -2
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i8 [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[TOBOOL]]
;
  %t1 = add nuw i8 %x, -37
  %t2 = add i8 %y, -35
  %tobool = icmp eq i8 %t2, %t1
  ret i1 %tobool
}

define i1 @ugt_offset(i8 %a) {
; CHECK-LABEL: @ugt_offset(
; CHECK-NEXT:    [[T:%.*]] = add i8 [[A:%.*]], 124
; CHECK-NEXT:    [[OV:%.*]] = icmp ugt i8 [[T]], -5
; CHECK-NEXT:    ret i1 [[OV]]
;
  %t = add i8 %a, 124
  %ov = icmp ugt i8 %t, 251
  ret i1 %ov
}

define i1 @ugt_offset_use(i32 %a) {
; CHECK-LABEL: @ugt_offset_use(
; CHECK-NEXT:    [[T:%.*]] = add i32 [[A:%.*]], 42
; CHECK-NEXT:    call void @use(i32 [[T]])
; CHECK-NEXT:    [[OV:%.*]] = icmp ugt i32 [[T]], -2147483607
; CHECK-NEXT:    ret i1 [[OV]]
;
  %t = add i32 %a, 42
  call void @use(i32 %t)
  %ov = icmp ugt i32 %t, 2147483689
  ret i1 %ov
}

define <2 x i1> @ugt_offset_splat(<2 x i5> %a) {
; CHECK-LABEL: @ugt_offset_splat(
; CHECK-NEXT:    [[T:%.*]] = add <2 x i5> [[A:%.*]], <i5 9, i5 9>
; CHECK-NEXT:    [[OV:%.*]] = icmp ugt <2 x i5> [[T]], <i5 -8, i5 -8>
; CHECK-NEXT:    ret <2 x i1> [[OV]]
;
  %t = add <2 x i5> %a, <i5 9, i5 9>
  %ov = icmp ugt <2 x i5> %t, <i5 24, i5 24>
  ret <2 x i1> %ov
}

define i1 @ugt_wrong_offset(i8 %a) {
; CHECK-LABEL: @ugt_wrong_offset(
; CHECK-NEXT:    [[T:%.*]] = add i8 [[A:%.*]], 123
; CHECK-NEXT:    [[OV:%.*]] = icmp ugt i8 [[T]], -5
; CHECK-NEXT:    ret i1 [[OV]]
;
  %t = add i8 %a, 123
  %ov = icmp ugt i8 %t, 251
  ret i1 %ov
}
