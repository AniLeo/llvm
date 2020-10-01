; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use(<2 x i1>)
declare void @use2(i1)

define i32 @select_xor_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp2(
; CHECK-NEXT:    [[A_NOT:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A_NOT]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

define i32 @select_xor_icmp_meta(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp_meta(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]], !prof !0
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y, !prof !0
  ret i32 %C
}

define i32 @select_mul_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_mul_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = mul i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_add_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_add_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = add i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_or_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_or_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = or i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_and_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], -1
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, -1
  %B = and i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define <2 x i8> @select_xor_icmp_vec(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_xor_icmp_vec(
; CHECK-NEXT:    [[A:%.*]] = icmp eq <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[C:%.*]] = select <2 x i1> [[A]], <2 x i8> [[Z:%.*]], <2 x i8> [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %A = icmp eq <2 x i8>  %x, <i8 0, i8 0>
  %B = xor <2 x i8>  %x, %z
  %C = select <2 x i1>  %A, <2 x i8>  %B, <2 x i8>  %y
  ret <2 x i8>  %C
}

define <2 x i8> @select_xor_icmp_vec_use(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_xor_icmp_vec_use(
; CHECK-NEXT:    [[A:%.*]] = icmp ne <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    call void @use(<2 x i1> [[A]])
; CHECK-NEXT:    [[C:%.*]] = select <2 x i1> [[A]], <2 x i8> [[Y:%.*]], <2 x i8> [[Z:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %A = icmp ne <2 x i8>  %x, <i8 0, i8 0>
  call void @use(<2 x i1> %A)
  %B = xor <2 x i8>  %x, %z
  %C = select <2 x i1>  %A, <2 x i8>  %y, <2 x i8>  %B
  ret <2 x i8>  %C
}

define i32 @select_xor_inv_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_inv_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = xor i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_inv_icmp2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_inv_icmp2(
; CHECK-NEXT:    [[A:%.*]] = icmp ne i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @use2(i1 [[A]])
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Y:%.*]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  call void @use2(i1 %A) ; thwart predicate canonicalization
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

define float @select_fadd_fcmp(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Z:%.*]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -0.0
  %B = fadd nsz float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; This is logically equivalent to the previous test - fcmp ignores the sign of 0.0.

define float @select_fadd_fcmp_poszero(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_poszero(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Z:%.*]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 0.0
  %B = fadd nsz float %z, %x
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fadd_fcmp_2(float %x, float %y, float %v) {
; CHECK-LABEL: @select_fadd_fcmp_2(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[Z:%.*]] = fadd float [[V:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[Z]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, -0.0
  %z = fadd float %v, 0.0 ; cannot produce -0.0
  %B = fadd float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; This is logically equivalent to the previous test - fcmp ignores the sign of 0.0.

define float @select_fadd_fcmp_2_poszero(float %x, float %y, float %v) {
; CHECK-LABEL: @select_fadd_fcmp_2_poszero(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[Z:%.*]] = fadd float [[V:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[Z]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, 0.0
  %z = fadd float %v, 0.0 ; cannot produce -0.0
  %B = fadd float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

define float @select_fadd_fcmp_3(float %x, float %y) {
; CHECK-LABEL: @select_fadd_fcmp_3(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float 6.000000e+00
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, -0.0
  %B = fadd float 6.0, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; This is logically equivalent to the previous test - fcmp ignores the sign of 0.0.

define float @select_fadd_fcmp_3_poszero(float %x, float %y) {
; CHECK-LABEL: @select_fadd_fcmp_3_poszero(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float 6.000000e+00
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, 0.0
  %B = fadd float 6.0, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

define float @select_fadd_fcmp_4(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_4(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[Z:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, -0.0
  %B = fadd nsz float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; This is logically equivalent to the previous test - fcmp ignores the sign of 0.0.

define float @select_fadd_fcmp_4_poszero(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_4_poszero(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[Z:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, 0.0
  %B = fadd nsz float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

define float @select_fadd_fcmp_5(float %x, float %y, float %v) {
; CHECK-LABEL: @select_fadd_fcmp_5(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[Z:%.*]] = fadd float [[V:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Z]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -0.0
  %z = fadd float %v, 0.0 ; cannot produce -0.0
  %B = fadd float %z, %x
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; This is logically equivalent to the previous test - fcmp ignores the sign of 0.0.

define float @select_fadd_fcmp_5_poszero(float %x, float %y, float %v) {
; CHECK-LABEL: @select_fadd_fcmp_5_poszero(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[Z:%.*]] = fadd float [[V:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Z]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 0.0
  %z = fadd float %v, 0.0 ; cannot produce -0.0
  %B = fadd float %z, %x
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fadd_fcmp_6(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_6(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float 6.000000e+00, float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -0.0
  %B = fadd float %x, 6.0
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; This is logically equivalent to the previous test - fcmp ignores the sign of 0.0.

define float @select_fadd_fcmp_6_poszero(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_6_poszero(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float 6.000000e+00, float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 0.0
  %B = fadd float %x, 6.0
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fmul_fcmp(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fmul_fcmp(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 1.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Z:%.*]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 1.0
  %B = fmul nsz float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fsub_fcmp(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fsub_fcmp(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Z:%.*]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 0.0
  %B = fsub nsz float %z, %x
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; This is logically equivalent to the previous test - fcmp ignores the sign of 0.0.

define float @select_fsub_fcmp_negzero(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fsub_fcmp_negzero(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Z:%.*]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -0.0
  %B = fsub nsz float %z, %x
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fdiv_fcmp(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fdiv_fcmp(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 1.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Z:%.*]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 1.0
  %B = fdiv nsz float %z, %x
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define i32 @select_sub_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = sub i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sub_icmp_2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp_2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @use2(i1 [[A]])
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  call void @use2(i1 %A)
  %B = sub i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sub_icmp_3(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp_3(
; CHECK-NEXT:    [[A:%.*]] = icmp ne i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @use2(i1 [[A]])
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Y:%.*]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  call void @use2(i1 %A)
  %B = sub i32 %z, %x
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

define <2 x i8> @select_sub_icmp_vec(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_sub_icmp_vec(
; CHECK-NEXT:    [[A:%.*]] = icmp eq <2 x i8> [[X:%.*]], zeroinitializer
; CHECK-NEXT:    [[C:%.*]] = select <2 x i1> [[A]], <2 x i8> [[Z:%.*]], <2 x i8> [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %A = icmp eq <2 x i8>  %x, <i8 0, i8 0>
  %B = sub <2 x i8>  %z, %x
  %C = select <2 x i1>  %A, <2 x i8>  %B, <2 x i8>  %y
  ret <2 x i8>  %C
}

define i32 @select_shl_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_shl_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp ne i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @use2(i1 [[A]])
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Y:%.*]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  call void @use2(i1 %A) ; thwart predicate canonicalization
  %B = shl i32 %z, %x
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

define i32 @select_lshr_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_lshr_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = lshr i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_ashr_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_ashr_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp ne i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @use2(i1 [[A]])
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Y:%.*]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  call void @use2(i1 %A) ; thwart predicate canonicalization
  %B = ashr i32 %z, %x
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

define i32 @select_udiv_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_udiv_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Z:%.*]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = udiv i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sdiv_icmp(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sdiv_icmp(
; CHECK-NEXT:    [[A:%.*]] = icmp ne i32 [[X:%.*]], 1
; CHECK-NEXT:    call void @use2(i1 [[A]])
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[Y:%.*]], i32 [[Z:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 1
  call void @use2(i1 %A) ; thwart predicate canonicalization
  %B = sdiv i32 %z, %x
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

; Negative tests
define i32 @select_xor_icmp_bad_1(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_xor_icmp_bad_1(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[K:%.*]]
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, %k
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp_bad_2(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_xor_icmp_bad_2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[K:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = xor i32 %k, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp_bad_3(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp_bad_3(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 3
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_fcmp_bad_4(i32 %x, i32 %y, i32 %z, float %k) {
; CHECK-LABEL: @select_xor_fcmp_bad_4(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[K:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = fcmp oeq float %k, 0.0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp_bad_5(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp_bad_5(
; CHECK-NEXT:    [[A_NOT:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A_NOT]], i32 [[Y:%.*]], i32 [[B]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_xor_icmp_bad_6(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_xor_icmp_bad_6(
; CHECK-NEXT:    [[A_NOT:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = xor i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A_NOT]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 1
  %B = xor i32 %x, %z
  %C = select i1 %A, i32 %y, i32 %B
  ret i32 %C
}

define <2 x i8> @select_xor_icmp_vec_bad(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_xor_icmp_vec_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq <2 x i8> [[X:%.*]], <i8 5, i8 3>
; CHECK-NEXT:    [[B:%.*]] = xor <2 x i8> [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select <2 x i1> [[A]], <2 x i8> [[B]], <2 x i8> [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %A = icmp eq <2 x i8>  %x, <i8 5, i8 3>
  %B = xor <2 x i8>  %x, %z
  %C = select <2 x i1>  %A, <2 x i8>  %B, <2 x i8>  %y
  ret <2 x i8>  %C
}

; Folding this would only be legal if we sanitized undef to 0.
define <2 x i8> @select_xor_icmp_vec_undef(<2 x i8> %x, <2 x i8> %y, <2 x i8> %z) {
; CHECK-LABEL: @select_xor_icmp_vec_undef(
; CHECK-NEXT:    [[A:%.*]] = icmp eq <2 x i8> [[X:%.*]], <i8 0, i8 undef>
; CHECK-NEXT:    [[B:%.*]] = xor <2 x i8> [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select <2 x i1> [[A]], <2 x i8> [[B]], <2 x i8> [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i8> [[C]]
;
  %A = icmp eq <2 x i8>  %x, <i8 0, i8 undef>
  %B = xor <2 x i8>  %x, %z
  %C = select <2 x i1>  %A, <2 x i8>  %B, <2 x i8>  %y
  ret <2 x i8>  %C
}

define i32 @select_mul_icmp_bad(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_mul_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = mul i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 3
  %B = mul i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_add_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_add_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = add i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = add i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_and_icmp_zero(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_and_icmp_zero(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 0, i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = and i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_or_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_or_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = or i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 3
  %B = or i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

; Invalid identity constant for FP op
define float @select_fadd_fcmp_bad(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], -1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd nsz float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -1.0
  %B = fadd nsz float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; Invalid comparison type
define float @select_fadd_fcmp_bad_2(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad_2(
; CHECK-NEXT:    [[A:%.*]] = fcmp ueq float [[X:%.*]], -1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp ueq float %x, -1.0
  %B = fadd float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; Invalid comparison type
define float @select_fadd_fcmp_bad_3(float %x, float %y, float %z, float %k) {
; CHECK-LABEL: @select_fadd_fcmp_bad_3(
; CHECK-NEXT:    [[A:%.*]] = fcmp one float [[X:%.*]], [[K:%.*]]
; CHECK-NEXT:    [[B:%.*]] = fadd float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[B]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp one float %x, %k
  %B = fadd float %x, %z
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; Invalid order of operands of select
define float @select_fadd_fcmp_bad_4(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad_4(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, -0.0
  %B = fadd float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; Invalid comparison type
define float @select_fadd_fcmp_bad_5(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad_5(
; CHECK-NEXT:    [[A:%.*]] = fcmp one float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd nsz float [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[B]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp one float %x, -0.0
  %B = fadd nsz float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; Invalid order of operands of select
define float @select_fadd_fcmp_bad_6(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad_6(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd nsz float [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[B]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -0.0
  %B = fadd nsz float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; Do not transform if we have signed zeros and if Z is possibly negative zero
define float @select_fadd_fcmp_bad_7(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad_7(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -0.0
  %B = fadd float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; Invalid comparison type
define float @select_fadd_fcmp_bad_8(float %x, float %y, float %v) {
; CHECK-LABEL: @select_fadd_fcmp_bad_8(
; CHECK-NEXT:    [[A:%.*]] = fcmp one float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[Z:%.*]] = fadd float [[V:%.*]], -1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[Z]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[B]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp one float %x, -0.0
  %z = fadd float %v, -1.0
  %B = fadd float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; Invalid comparison type
define float @select_fadd_fcmp_bad_9(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad_9(
; CHECK-NEXT:    [[A:%.*]] = fcmp one float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd nsz float [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[B]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp one float %x, -0.0
  %B = fadd nsz float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; Invalid comparison type
define float @select_fadd_fcmp_bad_10(float %x, float %y, float %v) {
; CHECK-LABEL: @select_fadd_fcmp_bad_10(
; CHECK-NEXT:    [[A:%.*]] = fcmp one float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[Z:%.*]] = fadd float [[V:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[Z]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[B]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp one float %x, -0.0
  %z = fadd float %v, 0.0 ; cannot produce -0.0
  %B = fadd float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; Do not transform if Z is possibly negative zero
define float @select_fadd_fcmp_bad_11(float %x, float %y, float %v) {
; CHECK-LABEL: @select_fadd_fcmp_bad_11(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[Z:%.*]] = fadd float [[V:%.*]], -1.000000e+00
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[Z]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, -0.0
  %z = fadd float %v, -1.0
  %B = fadd nsz float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; Do not transform if we have signed zeros and if Z is possibly negative zero
define float @select_fadd_fcmp_bad_12(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad_12(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd float [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[B]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, -0.0
  %B = fadd float %z, %x
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; Invalid order of operands of select
define float @select_fadd_fcmp_bad_13(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad_13(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd nsz float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[B]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, -0.0
  %B = fadd nsz float %x, %z
  %C = select i1 %A, float %y, float %B
  ret float %C
}

; Invalid identity constant for FP op
define float @select_fadd_fcmp_bad_14(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fadd_fcmp_bad_14(
; CHECK-NEXT:    [[A:%.*]] = fcmp une float [[X:%.*]], -1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fadd nsz float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[Y:%.*]], float [[B]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp une float %x, -1.0
  %B = fadd nsz float %x, %z
  %C = select i1 %A, float %y, float %B
  ret float %C
}

define float @select_fmul_fcmp_bad(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fmul_fcmp_bad(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 3.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fmul nsz float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 3.0
  %B = fmul nsz float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fmul_fcmp_bad_2(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fmul_fcmp_bad_2(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fmul float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 1.0
  %B = fmul float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fmul_icmp_bad(float %x, float %y, float %z, i32 %k) {
; CHECK-LABEL: @select_fmul_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[K:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = fmul float [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = icmp eq i32 %k, 0
  %B = fmul float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fmul_icmp_bad_2(float %x, float %y, float %z, i32 %k) {
; CHECK-LABEL: @select_fmul_icmp_bad_2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[K:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = fmul nsz float [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = icmp eq i32 %k, 0
  %B = fmul nsz float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fdiv_fcmp_bad(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fdiv_fcmp_bad(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fdiv float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 1.0
  %B = fdiv float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fdiv_fcmp_bad_2(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fdiv_fcmp_bad_2(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 3.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fdiv nsz float [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 3.0
  %B = fdiv nsz float %x, %z
  %C = select i1 %A, float %B, float %y
  ret float %C
}

; The transform is not valid when x = -0.0 and z = -0.0
; (optimized code would return -0.0, but this returns +0.0).

define float @select_fsub_fcmp_bad(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fsub_fcmp_bad(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fsub float [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 0.0
  %B = fsub float %z, %x
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define float @select_fsub_fcmp_bad_2(float %x, float %y, float %z) {
; CHECK-LABEL: @select_fsub_fcmp_bad_2(
; CHECK-NEXT:    [[A:%.*]] = fcmp oeq float [[X:%.*]], 1.000000e+00
; CHECK-NEXT:    [[B:%.*]] = fsub nsz float [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], float [[B]], float [[Y:%.*]]
; CHECK-NEXT:    ret float [[C]]
;
  %A = fcmp oeq float %x, 1.0
  %B = fsub nsz float %z, %x
  %C = select i1 %A, float %B, float %y
  ret float %C
}

define i32 @select_sub_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = sub i32 [[X]], [[Z:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = sub i32 %x, %z
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sub_icmp_bad_2(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp_bad_2(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = sub i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = sub i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sub_icmp_bad_3(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp_bad_3(
; CHECK-NEXT:    [[A:%.*]] = icmp ne i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @use2(i1 [[A]])
; CHECK-NEXT:    [[B:%.*]] = sub i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  call void @use2(i1 %A)
  %B = sub i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sub_icmp_4(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sub_icmp_4(
; CHECK-NEXT:    [[A:%.*]] = icmp ne i32 [[X:%.*]], 0
; CHECK-NEXT:    call void @use2(i1 [[A]])
; CHECK-NEXT:    [[B:%.*]] = sub i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp ne i32 %x, 0
  call void @use2(i1 %A)
  %B = sub i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sub_icmp_bad_4(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_sub_icmp_bad_4(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[B:%.*]] = sub i32 [[Z:%.*]], [[K:%.*]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 0
  %B = sub i32 %z, %k
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sub_icmp_bad_5(i32 %x, i32 %y, i32 %z, i32 %k) {
; CHECK-LABEL: @select_sub_icmp_bad_5(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], [[K:%.*]]
; CHECK-NEXT:    [[B:%.*]] = sub i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, %k
  %B = sub i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_shl_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_shl_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = shl i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = shl i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_lshr_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_lshr_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = lshr i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = lshr i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_ashr_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_ashr_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 1
; CHECK-NEXT:    [[B:%.*]] = ashr i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 1
  %B = ashr i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_udiv_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_udiv_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = udiv i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 3
  %B = udiv i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

define i32 @select_sdiv_icmp_bad(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @select_sdiv_icmp_bad(
; CHECK-NEXT:    [[A:%.*]] = icmp eq i32 [[X:%.*]], 3
; CHECK-NEXT:    [[B:%.*]] = sdiv i32 [[Z:%.*]], [[X]]
; CHECK-NEXT:    [[C:%.*]] = select i1 [[A]], i32 [[B]], i32 [[Y:%.*]]
; CHECK-NEXT:    ret i32 [[C]]
;
  %A = icmp eq i32 %x, 3
  %B = sdiv i32 %z, %x
  %C = select i1 %A, i32 %B, i32 %y
  ret i32 %C
}

!0 = !{!"branch_weights", i32 2, i32 10}
