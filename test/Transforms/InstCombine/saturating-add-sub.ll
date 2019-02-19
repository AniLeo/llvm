; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

;
; Saturating addition.
;

declare i8 @llvm.uadd.sat.i8(i8, i8)
declare i8 @llvm.sadd.sat.i8(i8, i8)
declare <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8>, <2 x i8>)
declare <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8>, <2 x i8>)

; Constant uadd argument is canonicalized to the right.
define i8 @test_scalar_uadd_canonical(i8 %a) {
; CHECK-LABEL: @test_scalar_uadd_canonical(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.uadd.sat.i8(i8 [[A:%.*]], i8 10)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.uadd.sat.i8(i8 10, i8 %a)
  ret i8 %x
}

define <2 x i8> @test_vector_uadd_canonical(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_uadd_canonical(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 10, i8 20>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> <i8 10, i8 20>, <2 x i8> %a)
  ret <2 x i8> %x
}

; Constant sadd argument is canonicalized to the right.
define i8 @test_scalar_sadd_canonical(i8 %a) {
; CHECK-LABEL: @test_scalar_sadd_canonical(
; CHECK-NEXT:    [[X:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 -10)
; CHECK-NEXT:    ret i8 [[X]]
;
  %x = call i8 @llvm.sadd.sat.i8(i8 -10, i8 %a)
  ret i8 %x
}

define <2 x i8> @test_vector_sadd_canonical(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_sadd_canonical(
; CHECK-NEXT:    [[X:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 10, i8 -20>)
; CHECK-NEXT:    ret <2 x i8> [[X]]
;
  %x = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 10, i8 -20>, <2 x i8> %a)
  ret <2 x i8> %x
}

; Can combine uadds with constant operands.
define i8 @test_scalar_uadd_combine(i8 %a) {
; CHECK-LABEL: @test_scalar_uadd_combine(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.uadd.sat.i8(i8 [[A:%.*]], i8 30)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %x1 = call i8 @llvm.uadd.sat.i8(i8 %a, i8 10)
  %x2 = call i8 @llvm.uadd.sat.i8(i8 %x1, i8 20)
  ret i8 %x2
}

define <2 x i8> @test_vector_uadd_combine(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_uadd_combine(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 30, i8 30>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %x1 = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 10, i8 10>)
  %x2 = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %x1, <2 x i8> <i8 20, i8 20>)
  ret <2 x i8> %x2
}

; This could simplify, but currently doesn't.
define <2 x i8> @test_vector_uadd_combine_non_splat(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_uadd_combine_non_splat(
; CHECK-NEXT:    [[X1:%.*]] = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 10, i8 20>)
; CHECK-NEXT:    [[X2:%.*]] = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> [[X1]], <2 x i8> <i8 30, i8 40>)
; CHECK-NEXT:    ret <2 x i8> [[X2]]
;
  %x1 = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 10, i8 20>)
  %x2 = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %x1, <2 x i8> <i8 30, i8 40>)
  ret <2 x i8> %x2
}

; Can combine uadds even if they overflow.
define i8 @test_scalar_uadd_overflow(i8 %a) {
; CHECK-LABEL: @test_scalar_uadd_overflow(
; CHECK-NEXT:    ret i8 -1
;
  %y1 = call i8 @llvm.uadd.sat.i8(i8 %a, i8 100)
  %y2 = call i8 @llvm.uadd.sat.i8(i8 %y1, i8 200)
  ret i8 %y2
}

define <2 x i8> @test_vector_uadd_overflow(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_uadd_overflow(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %y1 = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 100, i8 100>)
  %y2 = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %y1, <2 x i8> <i8 200, i8 200>)
  ret <2 x i8> %y2
}

; Can combine sadds if sign matches.
define i8 @test_scalar_sadd_both_positive(i8 %a) {
; CHECK-LABEL: @test_scalar_sadd_both_positive(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 30)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %z1 = call i8 @llvm.sadd.sat.i8(i8 %a, i8 10)
  %z2 = call i8 @llvm.sadd.sat.i8(i8 %z1, i8 20)
  ret i8 %z2
}

define <2 x i8> @test_vector_sadd_both_positive(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_sadd_both_positive(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 30, i8 30>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %z1 = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 10, i8 10>)
  %z2 = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %z1, <2 x i8> <i8 20, i8 20>)
  ret <2 x i8> %z2
}

define i8 @test_scalar_sadd_both_negative(i8 %a) {
; CHECK-LABEL: @test_scalar_sadd_both_negative(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 -30)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %u1 = call i8 @llvm.sadd.sat.i8(i8 %a, i8 -10)
  %u2 = call i8 @llvm.sadd.sat.i8(i8 %u1, i8 -20)
  ret i8 %u2
}

define <2 x i8> @test_vector_sadd_both_negative(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_sadd_both_negative(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 -30, i8 -30>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %u1 = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 -10, i8 -10>)
  %u2 = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %u1, <2 x i8> <i8 -20, i8 -20>)
  ret <2 x i8> %u2
}

; Can't combine sadds if constants have different sign.
define i8 @test_scalar_sadd_different_sign(i8 %a) {
; CHECK-LABEL: @test_scalar_sadd_different_sign(
; CHECK-NEXT:    [[V1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 10)
; CHECK-NEXT:    [[V2:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[V1]], i8 -20)
; CHECK-NEXT:    ret i8 [[V2]]
;
  %v1 = call i8 @llvm.sadd.sat.i8(i8 %a, i8 10)
  %v2 = call i8 @llvm.sadd.sat.i8(i8 %v1, i8 -20)
  ret i8 %v2
}

; Can't combine sadds if they overflow.
define i8 @test_scalar_sadd_overflow(i8 %a) {
; CHECK-LABEL: @test_scalar_sadd_overflow(
; CHECK-NEXT:    [[W1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 100)
; CHECK-NEXT:    [[W2:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[W1]], i8 100)
; CHECK-NEXT:    ret i8 [[W2]]
;
  %w1 = call i8 @llvm.sadd.sat.i8(i8 %a, i8 100)
  %w2 = call i8 @llvm.sadd.sat.i8(i8 %w1, i8 100)
  ret i8 %w2
}

; neg uadd neg always overflows.
define i8 @test_scalar_uadd_neg_neg(i8 %a) {
; CHECK-LABEL: @test_scalar_uadd_neg_neg(
; CHECK-NEXT:    ret i8 -1
;
  %a_neg = or i8 %a, -128
  %r = call i8 @llvm.uadd.sat.i8(i8 %a_neg, i8 -10)
  ret i8 %r
}

define <2 x i8> @test_vector_uadd_neg_neg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_uadd_neg_neg(
; CHECK-NEXT:    ret <2 x i8> <i8 -1, i8 -1>
;
  %a_neg = or <2 x i8> %a, <i8 -128, i8 -128>
  %r = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %a_neg, <2 x i8> <i8 -10, i8 -20>)
  ret <2 x i8> %r
}

; nneg uadd nneg never overflows.
define i8 @test_scalar_uadd_nneg_nneg(i8 %a) {
; CHECK-LABEL: @test_scalar_uadd_nneg_nneg(
; CHECK-NEXT:    [[A_NNEG:%.*]] = and i8 [[A:%.*]], 127
; CHECK-NEXT:    [[R:%.*]] = add nuw i8 [[A_NNEG]], 10
; CHECK-NEXT:    ret i8 [[R]]
;
  %a_nneg = and i8 %a, 127
  %r = call i8 @llvm.uadd.sat.i8(i8 %a_nneg, i8 10)
  ret i8 %r
}

define <2 x i8> @test_vector_uadd_nneg_nneg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_uadd_nneg_nneg(
; CHECK-NEXT:    [[A_NNEG:%.*]] = and <2 x i8> [[A:%.*]], <i8 127, i8 127>
; CHECK-NEXT:    [[R:%.*]] = add nuw <2 x i8> [[A_NNEG]], <i8 10, i8 20>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a_nneg = and <2 x i8> %a, <i8 127, i8 127>
  %r = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %a_nneg, <2 x i8> <i8 10, i8 20>)
  ret <2 x i8> %r
}

; neg uadd nneg might overflow.
define i8 @test_scalar_uadd_neg_nneg(i8 %a) {
; CHECK-LABEL: @test_scalar_uadd_neg_nneg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or i8 [[A:%.*]], -128
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.uadd.sat.i8(i8 [[A_NEG]], i8 10)
; CHECK-NEXT:    ret i8 [[R]]
;
  %a_neg = or i8 %a, -128
  %r = call i8 @llvm.uadd.sat.i8(i8 %a_neg, i8 10)
  ret i8 %r
}

define <2 x i8> @test_vector_uadd_neg_nneg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_uadd_neg_nneg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or <2 x i8> [[A:%.*]], <i8 -128, i8 -128>
; CHECK-NEXT:    [[R:%.*]] = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> [[A_NEG]], <2 x i8> <i8 10, i8 20>)
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a_neg = or <2 x i8> %a, <i8 -128, i8 -128>
  %r = call <2 x i8> @llvm.uadd.sat.v2i8(<2 x i8> %a_neg, <2 x i8> <i8 10, i8 20>)
  ret <2 x i8> %r
}

; neg sadd nneg never overflows.
define i8 @test_scalar_sadd_neg_nneg(i8 %a) {
; CHECK-LABEL: @test_scalar_sadd_neg_nneg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or i8 [[A:%.*]], -128
; CHECK-NEXT:    [[R:%.*]] = add nsw i8 [[A_NEG]], 10
; CHECK-NEXT:    ret i8 [[R]]
;
  %a_neg = or i8 %a, -128
  %r = call i8 @llvm.sadd.sat.i8(i8 %a_neg, i8 10)
  ret i8 %r
}

define <2 x i8> @test_vector_sadd_neg_nneg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_sadd_neg_nneg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or <2 x i8> [[A:%.*]], <i8 -128, i8 -128>
; CHECK-NEXT:    [[R:%.*]] = add nsw <2 x i8> [[A_NEG]], <i8 10, i8 20>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a_neg = or <2 x i8> %a, <i8 -128, i8 -128>
  %r = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %a_neg, <2 x i8> <i8 10, i8 20>)
  ret <2 x i8> %r
}

; nneg sadd neg never overflows.
define i8 @test_scalar_sadd_nneg_neg(i8 %a) {
; CHECK-LABEL: @test_scalar_sadd_nneg_neg(
; CHECK-NEXT:    [[A_NNEG:%.*]] = and i8 [[A:%.*]], 127
; CHECK-NEXT:    [[R:%.*]] = add nsw i8 [[A_NNEG]], -10
; CHECK-NEXT:    ret i8 [[R]]
;
  %a_nneg = and i8 %a, 127
  %r = call i8 @llvm.sadd.sat.i8(i8 %a_nneg, i8 -10)
  ret i8 %r
}

define <2 x i8> @test_vector_sadd_nneg_neg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_sadd_nneg_neg(
; CHECK-NEXT:    [[A_NNEG:%.*]] = and <2 x i8> [[A:%.*]], <i8 127, i8 127>
; CHECK-NEXT:    [[R:%.*]] = add nsw <2 x i8> [[A_NNEG]], <i8 -10, i8 -20>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a_nneg = and <2 x i8> %a, <i8 127, i8 127>
  %r = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %a_nneg, <2 x i8> <i8 -10, i8 -20>)
  ret <2 x i8> %r
}

; neg sadd neg might overflow.
define i8 @test_scalar_sadd_neg_neg(i8 %a) {
; CHECK-LABEL: @test_scalar_sadd_neg_neg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or i8 [[A:%.*]], -128
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A_NEG]], i8 -10)
; CHECK-NEXT:    ret i8 [[R]]
;
  %a_neg = or i8 %a, -128
  %r = call i8 @llvm.sadd.sat.i8(i8 %a_neg, i8 -10)
  ret i8 %r
}

define <2 x i8> @test_vector_sadd_neg_neg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_sadd_neg_neg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or <2 x i8> [[A:%.*]], <i8 -128, i8 -128>
; CHECK-NEXT:    [[R:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A_NEG]], <2 x i8> <i8 -10, i8 -20>)
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a_neg = or <2 x i8> %a, <i8 -128, i8 -128>
  %r = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> %a_neg, <2 x i8> <i8 -10, i8 -20>)
  ret <2 x i8> %r
}

;
; Saturating subtraction.
;

declare i8 @llvm.usub.sat.i8(i8, i8)
declare i8 @llvm.ssub.sat.i8(i8, i8)
declare <2 x i8> @llvm.usub.sat.v2i8(<2 x i8>, <2 x i8>)
declare <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8>, <2 x i8>)

; Cannot canonicalize usub to uadd.
define i8 @test_scalar_usub_canonical(i8 %a) {
; CHECK-LABEL: @test_scalar_usub_canonical(
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.usub.sat.i8(i8 [[A:%.*]], i8 10)
; CHECK-NEXT:    ret i8 [[R]]
;
  %r = call i8 @llvm.usub.sat.i8(i8 %a, i8 10)
  ret i8 %r
}

; Canonicalize ssub to sadd.
define i8 @test_scalar_ssub_canonical(i8 %a) {
; CHECK-LABEL: @test_scalar_ssub_canonical(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 -10)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %r = call i8 @llvm.ssub.sat.i8(i8 %a, i8 10)
  ret i8 %r
}

define <2 x i8> @test_vector_ssub_canonical(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_ssub_canonical(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 -10, i8 -10>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %r = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 10, i8 10>)
  ret <2 x i8> %r
}

define <2 x i8> @test_vector_ssub_canonical_min_non_splat(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_ssub_canonical_min_non_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 -10, i8 10>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %r = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 10, i8 -10>)
  ret <2 x i8> %r
}

; Cannot canonicalize signed min.
define i8 @test_scalar_ssub_canonical_min(i8 %a) {
; CHECK-LABEL: @test_scalar_ssub_canonical_min(
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.ssub.sat.i8(i8 [[A:%.*]], i8 -128)
; CHECK-NEXT:    ret i8 [[R]]
;
  %r = call i8 @llvm.ssub.sat.i8(i8 %a, i8 -128)
  ret i8 %r
}

define <2 x i8> @test_vector_ssub_canonical_min(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_ssub_canonical_min(
; CHECK-NEXT:    [[R:%.*]] = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 -128, i8 -10>)
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %r = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 -128, i8 -10>)
  ret <2 x i8> %r
}

; Can combine usubs with constant operands.
define i8 @test_scalar_usub_combine(i8 %a) {
; CHECK-LABEL: @test_scalar_usub_combine(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.usub.sat.i8(i8 [[A:%.*]], i8 30)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %x1 = call i8 @llvm.usub.sat.i8(i8 %a, i8 10)
  %x2 = call i8 @llvm.usub.sat.i8(i8 %x1, i8 20)
  ret i8 %x2
}

define <2 x i8> @test_vector_usub_combine(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_usub_combine(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 30, i8 30>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %x1 = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 10, i8 10>)
  %x2 = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %x1, <2 x i8> <i8 20, i8 20>)
  ret <2 x i8> %x2
}

; This could simplify, but currently doesn't.
define <2 x i8> @test_vector_usub_combine_non_splat(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_usub_combine_non_splat(
; CHECK-NEXT:    [[X1:%.*]] = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 10, i8 20>)
; CHECK-NEXT:    [[X2:%.*]] = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> [[X1]], <2 x i8> <i8 30, i8 40>)
; CHECK-NEXT:    ret <2 x i8> [[X2]]
;
  %x1 = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 10, i8 20>)
  %x2 = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %x1, <2 x i8> <i8 30, i8 40>)
  ret <2 x i8> %x2
}

; Can combine usubs even if they overflow.
define i8 @test_scalar_usub_overflow(i8 %a) {
; CHECK-LABEL: @test_scalar_usub_overflow(
; CHECK-NEXT:    ret i8 0
;
  %y1 = call i8 @llvm.usub.sat.i8(i8 %a, i8 100)
  %y2 = call i8 @llvm.usub.sat.i8(i8 %y1, i8 200)
  ret i8 %y2
}

define <2 x i8> @test_vector_usub_overflow(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_usub_overflow(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %y1 = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 100, i8 100>)
  %y2 = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %y1, <2 x i8> <i8 200, i8 200>)
  ret <2 x i8> %y2
}

; Can combine ssubs if sign matches.
define i8 @test_scalar_ssub_both_positive(i8 %a) {
; CHECK-LABEL: @test_scalar_ssub_both_positive(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 -30)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %z1 = call i8 @llvm.ssub.sat.i8(i8 %a, i8 10)
  %z2 = call i8 @llvm.ssub.sat.i8(i8 %z1, i8 20)
  ret i8 %z2
}

define <2 x i8> @test_vector_ssub_both_positive(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_ssub_both_positive(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 -30, i8 -30>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %z1 = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 10, i8 10>)
  %z2 = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %z1, <2 x i8> <i8 20, i8 20>)
  ret <2 x i8> %z2
}

define i8 @test_scalar_ssub_both_negative(i8 %a) {
; CHECK-LABEL: @test_scalar_ssub_both_negative(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 30)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %u1 = call i8 @llvm.ssub.sat.i8(i8 %a, i8 -10)
  %u2 = call i8 @llvm.ssub.sat.i8(i8 %u1, i8 -20)
  ret i8 %u2
}

define <2 x i8> @test_vector_ssub_both_negative(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_ssub_both_negative(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 30, i8 30>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %u1 = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a, <2 x i8> <i8 -10, i8 -10>)
  %u2 = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %u1, <2 x i8> <i8 -20, i8 -20>)
  ret <2 x i8> %u2
}

; Can't combine ssubs if constants have different sign.
define i8 @test_scalar_ssub_different_sign(i8 %a) {
; CHECK-LABEL: @test_scalar_ssub_different_sign(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 -10)
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[TMP1]], i8 20)
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %v1 = call i8 @llvm.ssub.sat.i8(i8 %a, i8 10)
  %v2 = call i8 @llvm.ssub.sat.i8(i8 %v1, i8 -20)
  ret i8 %v2
}

; Can combine sadd and ssub with appropriate signs.
define i8 @test_scalar_sadd_ssub(i8 %a) {
; CHECK-LABEL: @test_scalar_sadd_ssub(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 30)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %v1 = call i8 @llvm.sadd.sat.i8(i8 10, i8 %a)
  %v2 = call i8 @llvm.ssub.sat.i8(i8 %v1, i8 -20)
  ret i8 %v2
}

define <2 x i8> @test_vector_sadd_ssub(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_sadd_ssub(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A:%.*]], <2 x i8> <i8 -30, i8 -30>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %v1 = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> <i8 -10, i8 -10>, <2 x i8> %a)
  %v2 = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %v1, <2 x i8> <i8 20, i8 20>)
  ret <2 x i8> %v2
}

; Can't combine ssubs if they overflow.
define i8 @test_scalar_ssub_overflow(i8 %a) {
; CHECK-LABEL: @test_scalar_ssub_overflow(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A:%.*]], i8 -100)
; CHECK-NEXT:    [[TMP2:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[TMP1]], i8 -100)
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %w1 = call i8 @llvm.ssub.sat.i8(i8 %a, i8 100)
  %w2 = call i8 @llvm.ssub.sat.i8(i8 %w1, i8 100)
  ret i8 %w2
}

; nneg usub neg always overflows.
define i8 @test_scalar_usub_nneg_neg(i8 %a) {
; CHECK-LABEL: @test_scalar_usub_nneg_neg(
; CHECK-NEXT:    ret i8 0
;
  %a_nneg = and i8 %a, 127
  %r = call i8 @llvm.usub.sat.i8(i8 %a_nneg, i8 -10)
  ret i8 %r
}

define <2 x i8> @test_vector_usub_nneg_neg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_usub_nneg_neg(
; CHECK-NEXT:    ret <2 x i8> zeroinitializer
;
  %a_nneg = and <2 x i8> %a, <i8 127, i8 127>
  %r = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a_nneg, <2 x i8> <i8 -10, i8 -20>)
  ret <2 x i8> %r
}

; neg usub nneg never overflows.
define i8 @test_scalar_usub_neg_nneg(i8 %a) {
; CHECK-LABEL: @test_scalar_usub_neg_nneg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or i8 [[A:%.*]], -128
; CHECK-NEXT:    [[R:%.*]] = add i8 [[A_NEG]], -10
; CHECK-NEXT:    ret i8 [[R]]
;
  %a_neg = or i8 %a, -128
  %r = call i8 @llvm.usub.sat.i8(i8 %a_neg, i8 10)
  ret i8 %r
}

define <2 x i8> @test_vector_usub_neg_nneg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_usub_neg_nneg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or <2 x i8> [[A:%.*]], <i8 -128, i8 -128>
; CHECK-NEXT:    [[R:%.*]] = add <2 x i8> [[A_NEG]], <i8 -10, i8 -20>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a_neg = or <2 x i8> %a, <i8 -128, i8 -128>
  %r = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a_neg, <2 x i8> <i8 10, i8 20>)
  ret <2 x i8> %r
}

; nneg usub nneg never may overflow.
define i8 @test_scalar_usub_nneg_nneg(i8 %a) {
; CHECK-LABEL: @test_scalar_usub_nneg_nneg(
; CHECK-NEXT:    [[A_NNEG:%.*]] = and i8 [[A:%.*]], 127
; CHECK-NEXT:    [[R:%.*]] = call i8 @llvm.usub.sat.i8(i8 [[A_NNEG]], i8 10)
; CHECK-NEXT:    ret i8 [[R]]
;
  %a_nneg = and i8 %a, 127
  %r = call i8 @llvm.usub.sat.i8(i8 %a_nneg, i8 10)
  ret i8 %r
}

define <2 x i8> @test_vector_usub_nneg_nneg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_usub_nneg_nneg(
; CHECK-NEXT:    [[A_NNEG:%.*]] = and <2 x i8> [[A:%.*]], <i8 127, i8 127>
; CHECK-NEXT:    [[R:%.*]] = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> [[A_NNEG]], <2 x i8> <i8 10, i8 20>)
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a_nneg = and <2 x i8> %a, <i8 127, i8 127>
  %r = call <2 x i8> @llvm.usub.sat.v2i8(<2 x i8> %a_nneg, <2 x i8> <i8 10, i8 20>)
  ret <2 x i8> %r
}

; neg ssub neg never overflows.
define i8 @test_scalar_ssub_neg_neg(i8 %a) {
; CHECK-LABEL: @test_scalar_ssub_neg_neg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or i8 [[A:%.*]], -128
; CHECK-NEXT:    [[R:%.*]] = add nsw i8 [[A_NEG]], 10
; CHECK-NEXT:    ret i8 [[R]]
;
  %a_neg = or i8 %a, -128
  %r = call i8 @llvm.ssub.sat.i8(i8 %a_neg, i8 -10)
  ret i8 %r
}

define <2 x i8> @test_vector_ssub_neg_neg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_ssub_neg_neg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or <2 x i8> [[A:%.*]], <i8 -128, i8 -128>
; CHECK-NEXT:    [[R:%.*]] = add nsw <2 x i8> [[A_NEG]], <i8 10, i8 20>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a_neg = or <2 x i8> %a, <i8 -128, i8 -128>
  %r = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a_neg, <2 x i8> <i8 -10, i8 -20>)
  ret <2 x i8> %r
}

; nneg ssub nneg never overflows.
define i8 @test_scalar_ssub_nneg_nneg(i8 %a) {
; CHECK-LABEL: @test_scalar_ssub_nneg_nneg(
; CHECK-NEXT:    [[A_NNEG:%.*]] = and i8 [[A:%.*]], 127
; CHECK-NEXT:    [[R:%.*]] = add nsw i8 [[A_NNEG]], -10
; CHECK-NEXT:    ret i8 [[R]]
;
  %a_nneg = and i8 %a, 127
  %r = call i8 @llvm.ssub.sat.i8(i8 %a_nneg, i8 10)
  ret i8 %r
}

define <2 x i8> @test_vector_ssub_nneg_nneg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_ssub_nneg_nneg(
; CHECK-NEXT:    [[A_NNEG:%.*]] = and <2 x i8> [[A:%.*]], <i8 127, i8 127>
; CHECK-NEXT:    [[R:%.*]] = add nsw <2 x i8> [[A_NNEG]], <i8 -10, i8 -20>
; CHECK-NEXT:    ret <2 x i8> [[R]]
;
  %a_nneg = and <2 x i8> %a, <i8 127, i8 127>
  %r = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a_nneg, <2 x i8> <i8 10, i8 20>)
  ret <2 x i8> %r
}

; neg ssub nneg may overflow.
define i8 @test_scalar_ssub_neg_nneg(i8 %a) {
; CHECK-LABEL: @test_scalar_ssub_neg_nneg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or i8 [[A:%.*]], -128
; CHECK-NEXT:    [[TMP1:%.*]] = call i8 @llvm.sadd.sat.i8(i8 [[A_NEG]], i8 -10)
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %a_neg = or i8 %a, -128
  %r = call i8 @llvm.ssub.sat.i8(i8 %a_neg, i8 10)
  ret i8 %r
}

define <2 x i8> @test_vector_ssub_neg_nneg(<2 x i8> %a) {
; CHECK-LABEL: @test_vector_ssub_neg_nneg(
; CHECK-NEXT:    [[A_NEG:%.*]] = or <2 x i8> [[A:%.*]], <i8 -128, i8 -128>
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i8> @llvm.sadd.sat.v2i8(<2 x i8> [[A_NEG]], <2 x i8> <i8 -10, i8 -20>)
; CHECK-NEXT:    ret <2 x i8> [[TMP1]]
;
  %a_neg = or <2 x i8> %a, <i8 -128, i8 -128>
  %r = call <2 x i8> @llvm.ssub.sat.v2i8(<2 x i8> %a_neg, <2 x i8> <i8 10, i8 20>)
  ret <2 x i8> %r
}

; Raw IR tests

define i32 @uadd_sat(i32 %x, i32 %y) {
; CHECK-LABEL: @uadd_sat(
; CHECK-NEXT:    [[A:%.*]] = add i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[A]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 -1, i32 [[A]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %notx = xor i32 %x, -1
  %a = add i32 %y, %x
  %c = icmp ult i32 %notx, %y
  %r = select i1 %c, i32 -1, i32 %a
  ret i32 %r
}

define i32 @uadd_sat_commute_add(i32 %xp, i32 %y) {
; CHECK-LABEL: @uadd_sat_commute_add(
; CHECK-NEXT:    [[X:%.*]] = urem i32 42, [[XP:%.*]]
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[A]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 -1, i32 [[A]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %x = urem i32 42, %xp ; thwart complexity-based-canonicalization
  %notx = xor i32 %x, -1
  %a = add i32 %x, %y
  %c = icmp ult i32 %notx, %y
  %r = select i1 %c, i32 -1, i32 %a
  ret i32 %r
}

define i32 @uadd_sat_ugt(i32 %x, i32 %yp) {
; CHECK-LABEL: @uadd_sat_ugt(
; CHECK-NEXT:    [[Y:%.*]] = sdiv i32 [[YP:%.*]], 2442
; CHECK-NEXT:    [[A:%.*]] = add i32 [[Y]], [[X:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[A]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 -1, i32 [[A]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %y = sdiv i32 %yp, 2442 ; thwart complexity-based-canonicalization
  %notx = xor i32 %x, -1
  %a = add i32 %y, %x
  %c = icmp ugt i32 %y, %notx
  %r = select i1 %c, i32 -1, i32 %a
  ret i32 %r
}

define <2 x i32> @uadd_sat_ugt_commute_add(<2 x i32> %xp, <2 x i32> %yp) {
; CHECK-LABEL: @uadd_sat_ugt_commute_add(
; CHECK-NEXT:    [[Y:%.*]] = sdiv <2 x i32> [[YP:%.*]], <i32 2442, i32 4242>
; CHECK-NEXT:    [[X:%.*]] = srem <2 x i32> <i32 42, i32 43>, [[XP:%.*]]
; CHECK-NEXT:    [[A:%.*]] = add <2 x i32> [[X]], [[Y]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult <2 x i32> [[A]], [[Y]]
; CHECK-NEXT:    [[TMP2:%.*]] = select <2 x i1> [[TMP1]], <2 x i32> <i32 -1, i32 -1>, <2 x i32> [[A]]
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %y = sdiv <2 x i32> %yp, <i32 2442, i32 4242> ; thwart complexity-based-canonicalization
  %x = srem <2 x i32> <i32 42, i32 43>, %xp     ; thwart complexity-based-canonicalization
  %notx = xor <2 x i32> %x, <i32 -1, i32 -1>
  %a = add <2 x i32> %x, %y
  %c = icmp ugt <2 x i32> %y, %notx
  %r = select <2 x i1> %c, <2 x i32> <i32 -1, i32 -1>, <2 x i32> %a
  ret <2 x i32> %r
}

define i32 @uadd_sat_commute_select(i32 %x, i32 %yp) {
; CHECK-LABEL: @uadd_sat_commute_select(
; CHECK-NEXT:    [[Y:%.*]] = sdiv i32 [[YP:%.*]], 2442
; CHECK-NEXT:    [[NOTX:%.*]] = xor i32 [[X:%.*]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[Y]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[Y]], [[NOTX]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 -1
; CHECK-NEXT:    ret i32 [[R]]
;
  %y = sdiv i32 %yp, 2442 ; thwart complexity-based-canonicalization
  %notx = xor i32 %x, -1
  %a = add i32 %y, %x
  %c = icmp ult i32 %y, %notx
  %r = select i1 %c, i32 %a, i32 -1
  ret i32 %r
}

define i32 @uadd_sat_commute_select_commute_add(i32 %xp, i32 %yp) {
; CHECK-LABEL: @uadd_sat_commute_select_commute_add(
; CHECK-NEXT:    [[X:%.*]] = urem i32 42, [[XP:%.*]]
; CHECK-NEXT:    [[Y:%.*]] = sdiv i32 [[YP:%.*]], 2442
; CHECK-NEXT:    [[NOTX:%.*]] = xor i32 [[X]], -1
; CHECK-NEXT:    [[A:%.*]] = add nsw i32 [[X]], [[Y]]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[Y]], [[NOTX]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 -1
; CHECK-NEXT:    ret i32 [[R]]
;
  %x = urem i32 42, %xp ; thwart complexity-based-canonicalization
  %y = sdiv i32 %yp, 2442 ; thwart complexity-based-canonicalization
  %notx = xor i32 %x, -1
  %a = add i32 %x, %y
  %c = icmp ult i32 %y, %notx
  %r = select i1 %c, i32 %a, i32 -1
  ret i32 %r
}

define <2 x i32> @uadd_sat_commute_select_ugt(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @uadd_sat_commute_select_ugt(
; CHECK-NEXT:    [[NOTX:%.*]] = xor <2 x i32> [[X:%.*]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[A:%.*]] = add <2 x i32> [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = icmp ugt <2 x i32> [[NOTX]], [[Y]]
; CHECK-NEXT:    [[R:%.*]] = select <2 x i1> [[C]], <2 x i32> [[A]], <2 x i32> <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %notx = xor <2 x i32> %x, <i32 -1, i32 -1>
  %a = add <2 x i32> %y, %x
  %c = icmp ugt <2 x i32> %notx, %y
  %r = select <2 x i1> %c, <2 x i32> %a, <2 x i32> <i32 -1, i32 -1>
  ret <2 x i32> %r
}

define i32 @uadd_sat_commute_select_ugt_commute_add(i32 %xp, i32 %y) {
; CHECK-LABEL: @uadd_sat_commute_select_ugt_commute_add(
; CHECK-NEXT:    [[X:%.*]] = srem i32 42, [[XP:%.*]]
; CHECK-NEXT:    [[NOTX:%.*]] = xor i32 [[X]], -1
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[NOTX]], [[Y]]
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 -1
; CHECK-NEXT:    ret i32 [[R]]
;
  %x = srem i32 42, %xp   ; thwart complexity-based-canonicalization
  %notx = xor i32 %x, -1
  %a = add i32 %x, %y
  %c = icmp ugt i32 %notx, %y
  %r = select i1 %c, i32 %a, i32 -1
  ret i32 %r
}

; Negative test - make sure we have a -1 in the select.

define i32 @not_uadd_sat(i32 %x, i32 %y) {
; CHECK-LABEL: @not_uadd_sat(
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], -2
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[X]], 1
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = add i32 %x, -2
  %c = icmp ugt i32 %x, 1
  %r = select i1 %c, i32 %a, i32 %y
  ret i32 %r
}

; Negative test - make sure the predicate is 'ult'.

define i32 @not_uadd_sat2(i32 %x, i32 %y) {
; CHECK-LABEL: @not_uadd_sat2(
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], -2
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[X]], 1
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 [[A]], i32 -1
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = add i32 %x, -2
  %c = icmp ugt i32 %x, 1
  %r = select i1 %c, i32 %a, i32 -1
  ret i32 %r
}

define i32 @uadd_sat_constant(i32 %x) {
; CHECK-LABEL: @uadd_sat_constant(
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], 42
; CHECK-NEXT:    [[C:%.*]] = icmp ugt i32 [[X]], -43
; CHECK-NEXT:    [[R:%.*]] = select i1 [[C]], i32 -1, i32 [[A]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = add i32 %x, 42
  %c = icmp ugt i32 %x, -43
  %r = select i1 %c, i32 -1, i32 %a
  ret i32 %r
}

define i32 @uadd_sat_constant_commute(i32 %x) {
; CHECK-LABEL: @uadd_sat_constant_commute(
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], 42
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[X]], -43
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 -1, i32 [[A]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %a = add i32 %x, 42
  %c = icmp ult i32 %x, -43
  %r = select i1 %c, i32 %a, i32 -1
  ret i32 %r
}

define <4 x i32> @uadd_sat_constant_vec(<4 x i32> %x) {
; CHECK-LABEL: @uadd_sat_constant_vec(
; CHECK-NEXT:    [[A:%.*]] = add <4 x i32> [[X:%.*]], <i32 42, i32 42, i32 42, i32 42>
; CHECK-NEXT:    [[C:%.*]] = icmp ugt <4 x i32> [[X]], <i32 -43, i32 -43, i32 -43, i32 -43>
; CHECK-NEXT:    [[R:%.*]] = select <4 x i1> [[C]], <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> [[A]]
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %a = add <4 x i32> %x, <i32 42, i32 42, i32 42, i32 42>
  %c = icmp ugt <4 x i32> %x, <i32 -43, i32 -43, i32 -43, i32 -43>
  %r = select <4 x i1> %c, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> %a
  ret <4 x i32> %r
}

define <4 x i32> @uadd_sat_constant_vec_commute(<4 x i32> %x) {
; CHECK-LABEL: @uadd_sat_constant_vec_commute(
; CHECK-NEXT:    [[A:%.*]] = add <4 x i32> [[X:%.*]], <i32 42, i32 42, i32 42, i32 42>
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt <4 x i32> [[X]], <i32 -43, i32 -43, i32 -43, i32 -43>
; CHECK-NEXT:    [[TMP2:%.*]] = select <4 x i1> [[TMP1]], <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> [[A]]
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %a = add <4 x i32> %x, <i32 42, i32 42, i32 42, i32 42>
  %c = icmp ult <4 x i32> %x, <i32 -43, i32 -43, i32 -43, i32 -43>
  %r = select <4 x i1> %c, <4 x i32> %a, <4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %r
}

define <4 x i32> @uadd_sat_constant_vec_commute_undefs(<4 x i32> %x) {
; CHECK-LABEL: @uadd_sat_constant_vec_commute_undefs(
; CHECK-NEXT:    [[A:%.*]] = add <4 x i32> [[X:%.*]], <i32 42, i32 42, i32 42, i32 undef>
; CHECK-NEXT:    [[C:%.*]] = icmp ult <4 x i32> [[X]], <i32 -43, i32 -43, i32 undef, i32 -43>
; CHECK-NEXT:    [[R:%.*]] = select <4 x i1> [[C]], <4 x i32> [[A]], <4 x i32> <i32 -1, i32 undef, i32 -1, i32 -1>
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %a = add <4 x i32> %x, <i32 42, i32 42, i32 42, i32 undef>
  %c = icmp ult <4 x i32> %x, <i32 -43, i32 -43, i32 undef, i32 -43>
  %r = select <4 x i1> %c, <4 x i32> %a, <4 x i32> <i32 -1, i32 undef, i32 -1, i32 -1>
  ret <4 x i32> %r
}

