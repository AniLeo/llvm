; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; PR4374

define float @test1(float %x, float %y) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[T1:%.*]] = fsub float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fneg float [[T1]]
; CHECK-NEXT:    ret float [[T2]]
;
  %t1 = fsub float %x, %y
  %t2 = fsub float -0.0, %t1
  ret float %t2
}

define float @test1_unary(float %x, float %y) {
; CHECK-LABEL: @test1_unary(
; CHECK-NEXT:    [[T1:%.*]] = fsub float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fneg float [[T1]]
; CHECK-NEXT:    ret float [[T2]]
;
  %t1 = fsub float %x, %y
  %t2 = fneg float %t1
  ret float %t2
}

; Can't do anything with the test above because -0.0 - 0.0 = -0.0, but if we have nsz:
; -(X - Y) --> Y - X

define float @neg_sub_nsz(float %x, float %y) {
; CHECK-LABEL: @neg_sub_nsz(
; CHECK-NEXT:    [[T2:%.*]] = fsub nsz float [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret float [[T2]]
;
  %t1 = fsub float %x, %y
  %t2 = fsub nsz float -0.0, %t1
  ret float %t2
}

define float @unary_neg_sub_nsz(float %x, float %y) {
; CHECK-LABEL: @unary_neg_sub_nsz(
; CHECK-NEXT:    [[T2:%.*]] = fsub nsz float [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    ret float [[T2]]
;
  %t1 = fsub float %x, %y
  %t2 = fneg nsz float %t1
  ret float %t2
}

; If the subtract has another use, we don't do the transform (even though it
; doesn't increase the IR instruction count) because we assume that fneg is
; easier to analyze and generally cheaper than generic fsub.

declare void @use(float)
declare void @use2(float, double)

define float @neg_sub_nsz_extra_use(float %x, float %y) {
; CHECK-LABEL: @neg_sub_nsz_extra_use(
; CHECK-NEXT:    [[T1:%.*]] = fsub float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fneg nsz float [[T1]]
; CHECK-NEXT:    call void @use(float [[T1]])
; CHECK-NEXT:    ret float [[T2]]
;
  %t1 = fsub float %x, %y
  %t2 = fsub nsz float -0.0, %t1
  call void @use(float %t1)
  ret float %t2
}

define float @unary_neg_sub_nsz_extra_use(float %x, float %y) {
; CHECK-LABEL: @unary_neg_sub_nsz_extra_use(
; CHECK-NEXT:    [[T1:%.*]] = fsub float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fneg nsz float [[T1]]
; CHECK-NEXT:    call void @use(float [[T1]])
; CHECK-NEXT:    ret float [[T2]]
;
  %t1 = fsub float %x, %y
  %t2 = fneg nsz float %t1
  call void @use(float %t1)
  ret float %t2
}

; With nsz: Z - (X - Y) --> Z + (Y - X)

define float @sub_sub_nsz(float %x, float %y, float %z) {
; CHECK-LABEL: @sub_sub_nsz(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub nsz float [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fadd nsz float [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[T2]]
;
  %t1 = fsub float %x, %y
  %t2 = fsub nsz float %z, %t1
  ret float %t2
}

; With nsz and reassoc: Y - ((X * 5) + Y) --> X * -5

define float @sub_add_neg_x(float %x, float %y) {
; CHECK-LABEL: @sub_add_neg_x(
; CHECK-NEXT:    [[R:%.*]] = fmul reassoc nsz float [[X:%.*]], -5.000000e+00
; CHECK-NEXT:    ret float [[R]]
;
  %mul = fmul float %x, 5.000000e+00
  %add = fadd float %mul, %y
  %r = fsub nsz reassoc float %y, %add
  ret float %r
}

; Same as above: if 'Z' is not -0.0, swap fsub operands and convert to fadd.

define float @sub_sub_known_not_negzero(float %x, float %y) {
; CHECK-LABEL: @sub_sub_known_not_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub float [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fadd float [[TMP1]], 4.200000e+01
; CHECK-NEXT:    ret float [[T2]]
;
  %t1 = fsub float %x, %y
  %t2 = fsub float 42.0, %t1
  ret float %t2
}

; <rdar://problem/7530098>

define double @test2(double %x, double %y) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[T1:%.*]] = fadd double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fsub double [[X]], [[T1]]
; CHECK-NEXT:    ret double [[T2]]
;
  %t1 = fadd double %x, %y
  %t2 = fsub double %x, %t1
  ret double %t2
}

; X - C --> X + (-C)

define float @constant_op1(float %x, float %y) {
; CHECK-LABEL: @constant_op1(
; CHECK-NEXT:    [[R:%.*]] = fadd float [[X:%.*]], -4.200000e+01
; CHECK-NEXT:    ret float [[R]]
;
  %r = fsub float %x, 42.0
  ret float %r
}

define <2 x float> @constant_op1_vec(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @constant_op1_vec(
; CHECK-NEXT:    [[R:%.*]] = fadd <2 x float> [[X:%.*]], <float -4.200000e+01, float 4.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %r = fsub <2 x float> %x, <float 42.0, float -42.0>
  ret <2 x float> %r
}

define <2 x float> @constant_op1_vec_undef(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @constant_op1_vec_undef(
; CHECK-NEXT:    [[R:%.*]] = fadd <2 x float> [[X:%.*]], <float undef, float 4.200000e+01>
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %r = fsub <2 x float> %x, <float undef, float -42.0>
  ret <2 x float> %r
}

; X - (-Y) --> X + Y

define float @neg_op1(float %x, float %y) {
; CHECK-LABEL: @neg_op1(
; CHECK-NEXT:    [[R:%.*]] = fadd float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %negy = fsub float -0.0, %y
  %r = fsub float %x, %negy
  ret float %r
}

define float @unary_neg_op1(float %x, float %y) {
; CHECK-LABEL: @unary_neg_op1(
; CHECK-NEXT:    [[R:%.*]] = fadd float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %negy = fneg float %y
  %r = fsub float %x, %negy
  ret float %r
}

define <2 x float> @neg_op1_vec(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @neg_op1_vec(
; CHECK-NEXT:    [[R:%.*]] = fadd <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %negy = fsub <2 x float> <float -0.0, float -0.0>, %y
  %r = fsub <2 x float> %x, %negy
  ret <2 x float> %r
}

define <2 x float> @unary_neg_op1_vec(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @unary_neg_op1_vec(
; CHECK-NEXT:    [[R:%.*]] = fadd <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %negy = fneg <2 x float> %y
  %r = fsub <2 x float> %x, %negy
  ret <2 x float> %r
}

define <2 x float> @neg_op1_vec_undef(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @neg_op1_vec_undef(
; CHECK-NEXT:    [[R:%.*]] = fadd <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %negy = fsub <2 x float> <float -0.0, float undef>, %y
  %r = fsub <2 x float> %x, %negy
  ret <2 x float> %r
}

; Similar to above - but look through fpext/fptrunc casts to find the fneg.

define double @neg_ext_op1(float %a, double %b) {
; CHECK-LABEL: @neg_ext_op1(
; CHECK-NEXT:    [[TMP1:%.*]] = fpext float [[A:%.*]] to double
; CHECK-NEXT:    [[T3:%.*]] = fadd double [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret double [[T3]]
;
  %t1 = fsub float -0.0, %a
  %t2 = fpext float %t1 to double
  %t3 = fsub double %b, %t2
  ret double %t3
}

define double @unary_neg_ext_op1(float %a, double %b) {
; CHECK-LABEL: @unary_neg_ext_op1(
; CHECK-NEXT:    [[TMP1:%.*]] = fpext float [[A:%.*]] to double
; CHECK-NEXT:    [[T3:%.*]] = fadd double [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret double [[T3]]
;
  %t1 = fneg float %a
  %t2 = fpext float %t1 to double
  %t3 = fsub double %b, %t2
  ret double %t3
}

; Verify that vectors work too.

define <2 x float> @neg_trunc_op1(<2 x double> %a, <2 x float> %b) {
; CHECK-LABEL: @neg_trunc_op1(
; CHECK-NEXT:    [[TMP1:%.*]] = fptrunc <2 x double> [[A:%.*]] to <2 x float>
; CHECK-NEXT:    [[T3:%.*]] = fadd <2 x float> [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret <2 x float> [[T3]]
;
  %t1 = fsub <2 x double> <double -0.0, double -0.0>, %a
  %t2 = fptrunc <2 x double> %t1 to <2 x float>
  %t3 = fsub <2 x float> %b, %t2
  ret <2 x float> %t3
}

define <2 x float> @unary_neg_trunc_op1(<2 x double> %a, <2 x float> %b) {
; CHECK-LABEL: @unary_neg_trunc_op1(
; CHECK-NEXT:    [[TMP1:%.*]] = fptrunc <2 x double> [[A:%.*]] to <2 x float>
; CHECK-NEXT:    [[T3:%.*]] = fadd <2 x float> [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret <2 x float> [[T3]]
;
  %t1 = fneg <2 x double> %a
  %t2 = fptrunc <2 x double> %t1 to <2 x float>
  %t3 = fsub <2 x float> %b, %t2
  ret <2 x float> %t3
}

; No FMF needed, but they should propagate to the fadd.

define double @neg_ext_op1_fast(float %a, double %b) {
; CHECK-LABEL: @neg_ext_op1_fast(
; CHECK-NEXT:    [[TMP1:%.*]] = fpext float [[A:%.*]] to double
; CHECK-NEXT:    [[T3:%.*]] = fadd fast double [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret double [[T3]]
;
  %t1 = fsub float -0.0, %a
  %t2 = fpext float %t1 to double
  %t3 = fsub fast double %b, %t2
  ret double %t3
}

define double @unary_neg_ext_op1_fast(float %a, double %b) {
; CHECK-LABEL: @unary_neg_ext_op1_fast(
; CHECK-NEXT:    [[TMP1:%.*]] = fpext float [[A:%.*]] to double
; CHECK-NEXT:    [[T3:%.*]] = fadd fast double [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret double [[T3]]
;
  %t1 = fneg float %a
  %t2 = fpext float %t1 to double
  %t3 = fsub fast double %b, %t2
  ret double %t3
}

; Extra use should prevent the transform.

define float @neg_ext_op1_extra_use(half %a, float %b) {
; CHECK-LABEL: @neg_ext_op1_extra_use(
; CHECK-NEXT:    [[T1:%.*]] = fneg half [[A:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fpext half [[T1]] to float
; CHECK-NEXT:    [[T3:%.*]] = fsub float [[B:%.*]], [[T2]]
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[T3]]
;
  %t1 = fsub half -0.0, %a
  %t2 = fpext half %t1 to float
  %t3 = fsub float %b, %t2
  call void @use(float %t2)
  ret float %t3
}

define float @unary_neg_ext_op1_extra_use(half %a, float %b) {
; CHECK-LABEL: @unary_neg_ext_op1_extra_use(
; CHECK-NEXT:    [[T1:%.*]] = fneg half [[A:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fpext half [[T1]] to float
; CHECK-NEXT:    [[T3:%.*]] = fsub float [[B:%.*]], [[T2]]
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[T3]]
;
  %t1 = fneg half %a
  %t2 = fpext half %t1 to float
  %t3 = fsub float %b, %t2
  call void @use(float %t2)
  ret float %t3
}

; One-use fptrunc is always hoisted above fneg, so the corresponding
; multi-use bug for fptrunc isn't visible with a fold starting from
; the last fsub.

define float @neg_trunc_op1_extra_use(double %a, float %b) {
; CHECK-LABEL: @neg_trunc_op1_extra_use(
; CHECK-NEXT:    [[TMP1:%.*]] = fptrunc double [[A:%.*]] to float
; CHECK-NEXT:    [[T2:%.*]] = fneg float [[TMP1]]
; CHECK-NEXT:    [[T3:%.*]] = fadd float [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[T3]]
;
  %t1 = fsub double -0.0, %a
  %t2 = fptrunc double %t1 to float
  %t3 = fsub float %b, %t2
  call void @use(float %t2)
  ret float %t3
}

define float @unary_neg_trunc_op1_extra_use(double %a, float %b) {
; CHECK-LABEL: @unary_neg_trunc_op1_extra_use(
; CHECK-NEXT:    [[TMP1:%.*]] = fptrunc double [[A:%.*]] to float
; CHECK-NEXT:    [[T2:%.*]] = fneg float [[TMP1]]
; CHECK-NEXT:    [[T3:%.*]] = fadd float [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    call void @use(float [[T2]])
; CHECK-NEXT:    ret float [[T3]]
;
  %t1 = fneg double %a
  %t2 = fptrunc double %t1 to float
  %t3 = fsub float %b, %t2
  call void @use(float %t2)
  ret float %t3
}

; Extra uses should prevent the transform.

define float @neg_trunc_op1_extra_uses(double %a, float %b) {
; CHECK-LABEL: @neg_trunc_op1_extra_uses(
; CHECK-NEXT:    [[T1:%.*]] = fneg double [[A:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fptrunc double [[T1]] to float
; CHECK-NEXT:    [[T3:%.*]] = fsub float [[B:%.*]], [[T2]]
; CHECK-NEXT:    call void @use2(float [[T2]], double [[T1]])
; CHECK-NEXT:    ret float [[T3]]
;
  %t1 = fsub double -0.0, %a
  %t2 = fptrunc double %t1 to float
  %t3 = fsub float %b, %t2
  call void @use2(float %t2, double %t1)
  ret float %t3
}

define float @unary_neg_trunc_op1_extra_uses(double %a, float %b) {
; CHECK-LABEL: @unary_neg_trunc_op1_extra_uses(
; CHECK-NEXT:    [[T1:%.*]] = fneg double [[A:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = fptrunc double [[T1]] to float
; CHECK-NEXT:    [[T3:%.*]] = fsub float [[B:%.*]], [[T2]]
; CHECK-NEXT:    call void @use2(float [[T2]], double [[T1]])
; CHECK-NEXT:    ret float [[T3]]
;
  %t1 = fneg double %a
  %t2 = fptrunc double %t1 to float
  %t3 = fsub float %b, %t2
  call void @use2(float %t2, double %t1)
  ret float %t3
}

; Don't negate a constant expression to form fadd and induce infinite looping:
; https://bugs.llvm.org/show_bug.cgi?id=37605

@b = external global i16, align 1

define float @PR37605(float %conv) {
; CHECK-LABEL: @PR37605(
; CHECK-NEXT:    [[SUB:%.*]] = fsub float [[CONV:%.*]], bitcast (i32 ptrtoint (i16* @b to i32) to float)
; CHECK-NEXT:    ret float [[SUB]]
;
  %sub = fsub float %conv, bitcast (i32 ptrtoint (i16* @b to i32) to float)
  ret float %sub
}

define double @fsub_fdiv_fneg1(double %x, double %y, double %z) {
; CHECK-LABEL: @fsub_fdiv_fneg1(
; CHECK-NEXT:    [[TMP1:%.*]] = fdiv double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd double [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret double [[R]]
;
  %neg = fsub double -0.000000e+00, %x
  %div = fdiv double %neg, %y
  %r = fsub double %z, %div
  ret double %r
}

define <2 x double> @fsub_fdiv_fneg2(<2 x double> %x, <2 x double> %y, <2 x double> %z) {
; CHECK-LABEL: @fsub_fdiv_fneg2(
; CHECK-NEXT:    [[TMP1:%.*]] = fdiv <2 x double> [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd <2 x double> [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %neg = fsub <2 x double> <double -0.0, double -0.0>, %x
  %div = fdiv <2 x double> %y, %neg
  %r = fsub <2 x double> %z, %div
  ret <2 x double> %r
}

define double @fsub_fmul_fneg1(double %x, double %y, double %z) {
; CHECK-LABEL: @fsub_fmul_fneg1(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd double [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret double [[R]]
;
  %neg = fsub double -0.000000e+00, %x
  %mul = fmul double %neg, %y
  %r = fsub double %z, %mul
  ret double %r
}

define double @fsub_fmul_fneg2(double %x, double %y, double %z) {
; CHECK-LABEL: @fsub_fmul_fneg2(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd double [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret double [[R]]
;
  %neg = fsub double -0.000000e+00, %x
  %mul = fmul double %y, %neg
  %r = fsub double %z, %mul
  ret double %r
}

define float @fsub_fdiv_fneg1_extra_use(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fdiv_fneg1_extra_use(
; CHECK-NEXT:    [[NEG:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    [[DIV:%.*]] = fdiv float [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(float [[DIV]])
; CHECK-NEXT:    [[R:%.*]] = fsub float [[Z:%.*]], [[DIV]]
; CHECK-NEXT:    ret float [[R]]
;
  %neg = fsub float -0.000000e+00, %x
  %div = fdiv float %neg, %y
  call void @use(float %div)
  %r = fsub float %z, %div
  ret float %r
}

define float @fsub_fdiv_fneg2_extra_use(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fdiv_fneg2_extra_use(
; CHECK-NEXT:    [[NEG:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    [[DIV:%.*]] = fdiv float [[Y:%.*]], [[NEG]]
; CHECK-NEXT:    call void @use(float [[DIV]])
; CHECK-NEXT:    [[R:%.*]] = fsub float [[Z:%.*]], [[DIV]]
; CHECK-NEXT:    ret float [[R]]
;
  %neg = fsub float -0.000000e+00, %x
  %div = fdiv float %y, %neg
  call void @use(float %div)
  %r = fsub float %z, %div
  ret float %r
}

declare void @use_vec(<2 x float>)

define <2 x float> @fsub_fmul_fneg1_extra_use(<2 x float> %x, <2 x float> %y, <2 x float> %z) {
; CHECK-LABEL: @fsub_fmul_fneg1_extra_use(
; CHECK-NEXT:    [[NEG:%.*]] = fneg <2 x float> [[X:%.*]]
; CHECK-NEXT:    [[MUL:%.*]] = fmul <2 x float> [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    call void @use_vec(<2 x float> [[MUL]])
; CHECK-NEXT:    [[R:%.*]] = fsub <2 x float> [[Z:%.*]], [[MUL]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %neg = fsub <2 x float> <float -0.0, float -0.0>, %x
  %mul = fmul <2 x float> %neg, %y
  call void @use_vec(<2 x float> %mul)
  %r = fsub <2 x float> %z, %mul
  ret <2 x float> %r
}

define float @fsub_fmul_fneg2_extra_use(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fmul_fneg2_extra_use(
; CHECK-NEXT:    [[NEG:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    [[MUL:%.*]] = fmul float [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(float [[MUL]])
; CHECK-NEXT:    [[R:%.*]] = fsub float [[Z:%.*]], [[MUL]]
; CHECK-NEXT:    ret float [[R]]
;
  %neg = fsub float -0.000000e+00, %x
  %mul = fmul float %y, %neg
  call void @use(float %mul)
  %r = fsub float %z, %mul
  ret float %r
}

define float @fsub_fdiv_fneg1_extra_use2(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fdiv_fneg1_extra_use2(
; CHECK-NEXT:    [[NEG:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    call void @use(float [[NEG]])
; CHECK-NEXT:    [[TMP1:%.*]] = fdiv float [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd float [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %neg = fsub float -0.000000e+00, %x
  call void @use(float %neg)
  %div = fdiv float %neg, %y
  %r = fsub float %z, %div
  ret float %r
}

define float @fsub_fdiv_fneg2_extra_use2(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fdiv_fneg2_extra_use2(
; CHECK-NEXT:    [[NEG:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    call void @use(float [[NEG]])
; CHECK-NEXT:    [[TMP1:%.*]] = fdiv float [[Y:%.*]], [[X]]
; CHECK-NEXT:    [[R:%.*]] = fadd float [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %neg = fsub float -0.000000e+00, %x
  call void @use(float %neg)
  %div = fdiv float %y, %neg
  %r = fsub float %z, %div
  ret float %r
}

define <2 x float> @fsub_fmul_fneg1_extra_use2(<2 x float> %x, <2 x float> %y, <2 x float> %z) {
; CHECK-LABEL: @fsub_fmul_fneg1_extra_use2(
; CHECK-NEXT:    [[NEG:%.*]] = fneg <2 x float> [[X:%.*]]
; CHECK-NEXT:    call void @use_vec(<2 x float> [[NEG]])
; CHECK-NEXT:    [[TMP1:%.*]] = fmul <2 x float> [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd <2 x float> [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %neg = fsub <2 x float> <float -0.0, float -0.0>, %x
  call void @use_vec(<2 x float> %neg)
  %mul = fmul <2 x float> %neg, %y
  %r = fsub <2 x float> %z, %mul
  ret <2 x float> %r
}

define float @fsub_fmul_fneg2_extra_use2(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fmul_fneg2_extra_use2(
; CHECK-NEXT:    [[NEG:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    call void @use(float [[NEG]])
; CHECK-NEXT:    [[TMP1:%.*]] = fmul float [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fadd float [[TMP1]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[R]]
;
  %neg = fsub float -0.000000e+00, %x
  call void @use(float %neg)
  %mul = fmul float %y, %neg
  %r = fsub float %z, %mul
  ret float %r
}

define float @fsub_fdiv_fneg1_extra_use3(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fdiv_fneg1_extra_use3(
; CHECK-NEXT:    [[NEG:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    call void @use(float [[NEG]])
; CHECK-NEXT:    [[DIV:%.*]] = fdiv float [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(float [[DIV]])
; CHECK-NEXT:    [[R:%.*]] = fsub float [[Z:%.*]], [[DIV]]
; CHECK-NEXT:    ret float [[R]]
;
  %neg = fsub float -0.000000e+00, %x
  call void @use(float %neg)
  %div = fdiv float %neg, %y
  call void @use(float %div)
  %r = fsub float %z, %div
  ret float %r
}

define float @fsub_fdiv_fneg2_extra_use3(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fdiv_fneg2_extra_use3(
; CHECK-NEXT:    [[NEG:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    call void @use(float [[NEG]])
; CHECK-NEXT:    [[DIV:%.*]] = fdiv float [[Y:%.*]], [[NEG]]
; CHECK-NEXT:    call void @use(float [[DIV]])
; CHECK-NEXT:    [[R:%.*]] = fsub float [[Z:%.*]], [[DIV]]
; CHECK-NEXT:    ret float [[R]]
;
  %neg = fsub float -0.000000e+00, %x
  call void @use(float %neg)
  %div = fdiv float %y, %neg
  call void @use(float %div)
  %r = fsub float %z, %div
  ret float %r
}

define <2 x float> @fsub_fmul_fneg1_extra_use3(<2 x float> %x, <2 x float> %y, <2 x float> %z) {
; CHECK-LABEL: @fsub_fmul_fneg1_extra_use3(
; CHECK-NEXT:    [[NEG:%.*]] = fneg <2 x float> [[X:%.*]]
; CHECK-NEXT:    call void @use_vec(<2 x float> [[NEG]])
; CHECK-NEXT:    [[MUL:%.*]] = fmul <2 x float> [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    call void @use_vec(<2 x float> [[MUL]])
; CHECK-NEXT:    [[R:%.*]] = fsub <2 x float> [[Z:%.*]], [[MUL]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %neg = fsub <2 x float> <float -0.0, float -0.0>, %x
  call void @use_vec(<2 x float> %neg)
  %mul = fmul <2 x float> %neg, %y
  call void @use_vec(<2 x float> %mul)
  %r = fsub <2 x float> %z, %mul
  ret <2 x float> %r
}

define float @fsub_fmul_fneg2_extra_use3(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fmul_fneg2_extra_use3(
; CHECK-NEXT:    [[NEG:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    call void @use(float [[NEG]])
; CHECK-NEXT:    [[MUL:%.*]] = fmul float [[NEG]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(float [[MUL]])
; CHECK-NEXT:    [[R:%.*]] = fsub float [[Z:%.*]], [[MUL]]
; CHECK-NEXT:    ret float [[R]]
;
  %neg = fsub float -0.000000e+00, %x
  call void @use(float %neg)
  %mul = fmul float %y, %neg
  call void @use(float %mul)
  %r = fsub float %z, %mul
  ret float %r
}

; Negative test - can't reassociate without FMF.

define float @fsub_fsub(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fsub(
; CHECK-NEXT:    [[XY:%.*]] = fsub float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XYZ:%.*]] = fsub float [[XY]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[XYZ]]
;
  %xy = fsub float %x, %y
  %xyz = fsub float %xy, %z
  ret float %xyz
}

; Negative test - can't reassociate without enough FMF.

define float @fsub_fsub_nsz(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fsub_nsz(
; CHECK-NEXT:    [[XY:%.*]] = fsub float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XYZ:%.*]] = fsub nsz float [[XY]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[XYZ]]
;
  %xy = fsub float %x, %y
  %xyz = fsub nsz float %xy, %z
  ret float %xyz
}

; Negative test - can't reassociate without enough FMF.

define float @fsub_fsub_reassoc(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fsub_reassoc(
; CHECK-NEXT:    [[XY:%.*]] = fsub float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[XYZ:%.*]] = fsub reassoc float [[XY]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[XYZ]]
;
  %xy = fsub float %x, %y
  %xyz = fsub reassoc float %xy, %z
  ret float %xyz
}

define float @fsub_fsub_nsz_reassoc(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fsub_nsz_reassoc(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz float [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[XYZ:%.*]] = fsub reassoc nsz float [[X:%.*]], [[TMP1]]
; CHECK-NEXT:    ret float [[XYZ]]
;
  %xy = fsub float %x, %y
  %xyz = fsub nsz reassoc float %xy, %z
  ret float %xyz
}

define <2 x double> @fsub_fsub_fast_vec(<2 x double> %x, <2 x double> %y, <2 x double> %z) {
; CHECK-LABEL: @fsub_fsub_fast_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd fast <2 x double> [[Y:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[XYZ:%.*]] = fsub fast <2 x double> [[X:%.*]], [[TMP1]]
; CHECK-NEXT:    ret <2 x double> [[XYZ]]
;
  %xy = fsub fast <2 x double> %x, %y
  %xyz = fsub fast reassoc <2 x double> %xy, %z
  ret <2 x double> %xyz
}

; Negative test - don't reassociate and increase instructions.

define float @fsub_fsub_nsz_reassoc_extra_use(float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fsub_nsz_reassoc_extra_use(
; CHECK-NEXT:    [[XY:%.*]] = fsub float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(float [[XY]])
; CHECK-NEXT:    [[XYZ:%.*]] = fsub reassoc nsz float [[XY]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[XYZ]]
;
  %xy = fsub float %x, %y
  call void @use(float %xy)
  %xyz = fsub nsz reassoc float %xy, %z
  ret float %xyz
}

define float @fneg_fsub(float %x, float %y) {
; CHECK-LABEL: @fneg_fsub(
; CHECK-NEXT:    [[NEGX:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    [[SUB:%.*]] = fsub float [[NEGX]], [[Y:%.*]]
; CHECK-NEXT:    ret float [[SUB]]
;
  %negx = fneg float %x
  %sub = fsub float %negx, %y
  ret float %sub
}

define float @fneg_fsub_nsz(float %x, float %y) {
; CHECK-LABEL: @fneg_fsub_nsz(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd nsz float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SUB:%.*]] = fneg nsz float [[TMP1]]
; CHECK-NEXT:    ret float [[SUB]]
;
  %negx = fneg float %x
  %sub = fsub nsz float %negx, %y
  ret float %sub
}

define float @fake_fneg_fsub_fast(float %x, float %y) {
; CHECK-LABEL: @fake_fneg_fsub_fast(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd fast float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SUB:%.*]] = fneg fast float [[TMP1]]
; CHECK-NEXT:    ret float [[SUB]]
;
  %negx = fsub float -0.0, %x
  %sub = fsub fast float %negx, %y
  ret float %sub
}

define float @fake_fneg_fsub_fast_extra_use(float %x, float %y) {
; CHECK-LABEL: @fake_fneg_fsub_fast_extra_use(
; CHECK-NEXT:    [[NEGX:%.*]] = fneg float [[X:%.*]]
; CHECK-NEXT:    call void @use(float [[NEGX]])
; CHECK-NEXT:    [[SUB:%.*]] = fsub fast float [[NEGX]], [[Y:%.*]]
; CHECK-NEXT:    ret float [[SUB]]
;
  %negx = fsub float -0.0, %x
  call void @use(float %negx)
  %sub = fsub fast float %negx, %y
  ret float %sub
}

define <2 x float> @fake_fneg_fsub_vec(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @fake_fneg_fsub_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd nsz <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[SUB:%.*]] = fneg nsz <2 x float> [[TMP1]]
; CHECK-NEXT:    ret <2 x float> [[SUB]]
;
  %negx = fsub <2 x float> <float -0.0, float -0.0>, %x
  %sub = fsub nsz <2 x float> %negx, %y
  ret <2 x float> %sub
}

define float @fneg_fsub_constant(float %x) {
; CHECK-LABEL: @fneg_fsub_constant(
; CHECK-NEXT:    [[SUB:%.*]] = fsub nsz float -4.200000e+01, [[X:%.*]]
; CHECK-NEXT:    ret float [[SUB]]
;
  %negx = fneg float %x
  %sub = fsub nsz float %negx, 42.0
  ret float %sub
}

; ((w-x) + y) - z --> (w+y) - (x+z)

define float @fsub_fadd_fsub_reassoc(float %w, float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fadd_fsub_reassoc(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz float [[W:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fadd reassoc nsz float [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[S2:%.*]] = fsub reassoc nsz float [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret float [[S2]]
;
  %s1 = fsub reassoc nsz float %w, %x
  %a = fadd reassoc nsz float %s1, %y
  %s2 = fsub reassoc nsz float %a, %z
  ret float %s2
}

; FMF on the last op is enough to do the transform; vectors work too.

define <2 x float> @fsub_fadd_fsub_reassoc_commute(<2 x float> %w, <2 x float> %x, <2 x float> %y, <2 x float> %z) {
; CHECK-LABEL: @fsub_fadd_fsub_reassoc_commute(
; CHECK-NEXT:    [[D:%.*]] = fdiv <2 x float> [[Y:%.*]], <float 4.200000e+01, float -4.200000e+01>
; CHECK-NEXT:    [[TMP1:%.*]] = fadd fast <2 x float> [[D]], [[W:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fadd fast <2 x float> [[X:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[S2:%.*]] = fsub fast <2 x float> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x float> [[S2]]
;
  %d = fdiv <2 x float> %y, <float 42.0, float -42.0> ; thwart complexity-based canonicalization
  %s1 = fsub <2 x float> %w, %x
  %a = fadd <2 x float> %d, %s1
  %s2 = fsub fast <2 x float> %a, %z
  ret <2 x float> %s2
}

; (v-w) + (x-y) - z --> (v+x) - (w+y+z)

define float @fsub_fadd_fsub_reassoc_twice(float %v, float %w, float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fadd_fsub_reassoc_twice(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd reassoc nsz float [[W:%.*]], [[Z:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = fadd reassoc nsz float [[X:%.*]], [[V:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = fadd reassoc nsz float [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    [[S3:%.*]] = fsub reassoc nsz float [[TMP2]], [[TMP3]]
; CHECK-NEXT:    ret float [[S3]]
;
  %s1 = fsub reassoc nsz float %v, %w
  %s2 = fsub reassoc nsz float %x, %y
  %a = fadd reassoc nsz float %s1, %s2
  %s3 = fsub reassoc nsz float %a, %z
  ret float %s3
}

; negative test - FMF

define float @fsub_fadd_fsub_not_reassoc(float %w, float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fadd_fsub_not_reassoc(
; CHECK-NEXT:    [[S1:%.*]] = fsub fast float [[W:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[A:%.*]] = fadd fast float [[S1]], [[Y:%.*]]
; CHECK-NEXT:    [[S2:%.*]] = fsub nsz float [[A]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[S2]]
;
  %s1 = fsub fast float %w, %x
  %a = fadd fast float %s1, %y
  %s2 = fsub nsz float %a, %z
  ret float %s2
}

; negative test - uses

define float @fsub_fadd_fsub_reassoc_use1(float %w, float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fadd_fsub_reassoc_use1(
; CHECK-NEXT:    [[S1:%.*]] = fsub fast float [[W:%.*]], [[X:%.*]]
; CHECK-NEXT:    call void @use(float [[S1]])
; CHECK-NEXT:    [[A:%.*]] = fadd fast float [[S1]], [[Y:%.*]]
; CHECK-NEXT:    [[S2:%.*]] = fsub fast float [[A]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[S2]]
;
  %s1 = fsub fast float %w, %x
  call void @use(float %s1)
  %a = fadd fast float %s1, %y
  %s2 = fsub fast float %a, %z
  ret float %s2
}

; negative test - uses

define float @fsub_fadd_fsub_reassoc_use2(float %w, float %x, float %y, float %z) {
; CHECK-LABEL: @fsub_fadd_fsub_reassoc_use2(
; CHECK-NEXT:    [[S1:%.*]] = fsub fast float [[W:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[A:%.*]] = fadd fast float [[S1]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(float [[A]])
; CHECK-NEXT:    [[S2:%.*]] = fsub fast float [[A]], [[Z:%.*]]
; CHECK-NEXT:    ret float [[S2]]
;
  %s1 = fsub fast float %w, %x
  %a = fadd fast float %s1, %y
  call void @use(float %a)
  %s2 = fsub fast float %a, %z
  ret float %s2
}

define float @fmul_c1(float %x, float %y) {
; CHECK-LABEL: @fmul_c1(
; CHECK-NEXT:    [[M:%.*]] = fmul float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    [[R:%.*]] = fsub float [[Y:%.*]], [[M]]
; CHECK-NEXT:    ret float [[R]]
;
  %m = fmul float %x, 42.0
  %r = fsub float %y, %m
  ret float %r
}

define <2 x float> @fmul_c1_fmf(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @fmul_c1_fmf(
; CHECK-NEXT:    [[M:%.*]] = fmul ninf nsz <2 x float> [[X:%.*]], <float 4.200000e+01, float 5.000000e-01>
; CHECK-NEXT:    [[R:%.*]] = fsub <2 x float> [[Y:%.*]], [[M]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %m = fmul ninf nsz <2 x float> %x, <float 42.0, float 0.5>
  %r = fsub <2 x float> %y, %m
  ret <2 x float> %r
}

define float @fmul_c1_use(float %x, float %y) {
; CHECK-LABEL: @fmul_c1_use(
; CHECK-NEXT:    [[M:%.*]] = fmul float [[X:%.*]], 4.200000e+01
; CHECK-NEXT:    call void @use(float [[M]])
; CHECK-NEXT:    [[R:%.*]] = fsub float [[Y:%.*]], [[M]]
; CHECK-NEXT:    ret float [[R]]
;
  %m = fmul float %x, 42.0
  call void @use(float %m)
  %r = fsub float %y, %m
  ret float %r
}

define half @fdiv_c0(half %x, half %y) {
; CHECK-LABEL: @fdiv_c0(
; CHECK-NEXT:    [[M:%.*]] = fdiv half 0xH4700, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fsub half [[Y:%.*]], [[M]]
; CHECK-NEXT:    ret half [[R]]
;
  %m = fdiv half 7.0, %x
  %r = fsub half %y, %m
  ret half %r
}

define double @fdiv_c0_fmf(double %x, double %y) {
; CHECK-LABEL: @fdiv_c0_fmf(
; CHECK-NEXT:    [[M:%.*]] = fdiv double 7.000000e+00, [[X:%.*]]
; CHECK-NEXT:    [[R:%.*]] = fsub reassoc nnan double [[Y:%.*]], [[M]]
; CHECK-NEXT:    ret double [[R]]
;
  %m = fdiv double 7.0, %x
  %r = fsub reassoc nnan double %y, %m
  ret double %r
}

define <2 x float> @fdiv_c1(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @fdiv_c1(
; CHECK-NEXT:    [[M:%.*]] = fdiv <2 x float> [[X:%.*]], <float 4.270000e+02, float -0.000000e+00>
; CHECK-NEXT:    [[R:%.*]] = fsub <2 x float> [[Y:%.*]], [[M]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %m = fdiv <2 x float> %x, <float 427.0, float -0.0>
  %r = fsub <2 x float> %y, %m
  ret <2 x float> %r
}

define float @fdiv_c1_fmf(float %x, float %y) {
; CHECK-LABEL: @fdiv_c1_fmf(
; CHECK-NEXT:    [[M:%.*]] = fdiv nnan float [[X:%.*]], 4.270000e+02
; CHECK-NEXT:    [[R:%.*]] = fsub reassoc float [[Y:%.*]], [[M]]
; CHECK-NEXT:    ret float [[R]]
;
  %m = fdiv nnan float %x, 427.0
  %r = fsub reassoc float %y, %m
  ret float %r
}

define <2 x float> @fdiv_c1_use(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @fdiv_c1_use(
; CHECK-NEXT:    [[M:%.*]] = fdiv <2 x float> [[X:%.*]], <float 4.270000e+02, float -0.000000e+00>
; CHECK-NEXT:    call void @use_vec(<2 x float> [[M]])
; CHECK-NEXT:    [[R:%.*]] = fsub <2 x float> [[Y:%.*]], [[M]]
; CHECK-NEXT:    ret <2 x float> [[R]]
;
  %m = fdiv <2 x float> %x, <float 427.0, float -0.0>
  call void @use_vec(<2 x float> %m)
  %r = fsub <2 x float> %y, %m
  ret <2 x float> %r
}
