; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define float @powf_expf(float %x, float %y) {
; CHECK-LABEL: @powf_expf(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP:%.*]] = call fast float @llvm.exp.f32(float [[MUL]])
; CHECK-NEXT:    ret float [[EXP]]
;
  %call = call fast float @expf(float %x) nounwind readnone
  %pow = call fast float @llvm.pow.f32(float %call, float %y)
  ret float %pow
}

define float @powf_expf_libcall(float %x, float %y) {
; CHECK-LABEL: @powf_expf_libcall(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXPF:%.*]] = call fast float @expf(float [[MUL]])
; CHECK-NEXT:    ret float [[EXPF]]
;
  %call = call fast float @expf(float %x)
  %pow = call fast float @powf(float %call, float %y)
  ret float %pow
}

define double @pow_exp(double %x, double %y) {
; CHECK-LABEL: @pow_exp(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP:%.*]] = call fast double @llvm.exp.f64(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP]]
;
  %call = call fast double @exp(double %x) nounwind readnone
  %pow = call fast double @llvm.pow.f64(double %call, double %y)
  ret double %pow
}

define double @pow_exp_not_intrinsic(double %x, double %y) {
; CHECK-LABEL: @pow_exp_not_intrinsic(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP:%.*]] = call fast double @llvm.exp.f64(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP]]
;
  %call = call fast double @exp(double %x) nounwind readnone
  %pow = call fast double @pow(double %call, double %y) nounwind readnone
  ret double %pow
}

define fp128 @powl_expl(fp128 %x, fp128 %y) {
; CHECK-LABEL: @powl_expl(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast fp128 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP:%.*]] = call fast fp128 @llvm.exp.f128(fp128 [[MUL]])
; CHECK-NEXT:    ret fp128 [[EXP]]
;
  %call = call fast fp128 @expl(fp128 %x) nounwind readnone
  %pow = call fast fp128 @llvm.pow.f128(fp128 %call, fp128 %y)
  ret fp128 %pow
}

define fp128 @powl_expl_not_fast(fp128 %x, fp128 %y) {
; CHECK-LABEL: @powl_expl_not_fast(
; CHECK-NEXT:    [[CALL:%.*]] = call fp128 @expl(fp128 [[X:%.*]])
; CHECK-NEXT:    [[POW:%.*]] = call fast fp128 @llvm.pow.f128(fp128 [[CALL]], fp128 [[Y:%.*]])
; CHECK-NEXT:    ret fp128 [[POW]]
;
  %call = call fp128 @expl(fp128 %x)
  %pow = call fast fp128 @llvm.pow.f128(fp128 %call, fp128 %y)
  ret fp128 %pow
}

define float @powf_exp2f(float %x, float %y) {
; CHECK-LABEL: @powf_exp2f(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP2:%.*]] = call fast float @llvm.exp2.f32(float [[MUL]])
; CHECK-NEXT:    ret float [[EXP2]]
;
  %call = call fast float @exp2f(float %x) nounwind readnone
  %pow = call fast float @llvm.pow.f32(float %call, float %y)
  ret float %pow
}

define float @powf_exp2f_not_intrinsic(float %x, float %y) {
; CHECK-LABEL: @powf_exp2f_not_intrinsic(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP2:%.*]] = call fast float @llvm.exp2.f32(float [[MUL]])
; CHECK-NEXT:    ret float [[EXP2]]
;
  %call = call fast float @exp2f(float %x) nounwind readnone
  %pow = call fast float @powf(float %call, float %y) nounwind readnone
  ret float %pow
}

define double @pow_exp2(double %x, double %y) {
; CHECK-LABEL: @pow_exp2(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP2:%.*]] = call fast double @llvm.exp2.f64(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP2]]
;
  %call = call fast double @exp2(double %x) nounwind readnone
  %pow = call fast double @llvm.pow.f64(double %call, double %y)
  ret double %pow
}

define double @pow_exp2_libcall(double %x, double %y) {
; CHECK-LABEL: @pow_exp2_libcall(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP2:%.*]] = call fast double @exp2(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP2]]
;
  %call = call fast double @exp2(double %x)
  %pow = call fast double @pow(double %call, double %y)
  ret double %pow
}

define fp128 @powl_exp2l(fp128 %x, fp128 %y) {
; CHECK-LABEL: @powl_exp2l(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast fp128 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[EXP2:%.*]] = call fast fp128 @llvm.exp2.f128(fp128 [[MUL]])
; CHECK-NEXT:    ret fp128 [[EXP2]]
;
  %call = call fast fp128 @exp2l(fp128 %x) nounwind readnone
  %pow = call fast fp128 @llvm.pow.f128(fp128 %call, fp128 %y)
  ret fp128 %pow
}

define fp128 @powl_exp2l_not_fast(fp128 %x, fp128 %y) {
; CHECK-LABEL: @powl_exp2l_not_fast(
; CHECK-NEXT:    [[CALL:%.*]] = call fp128 @exp2l(fp128 [[X:%.*]])
; CHECK-NEXT:    [[POW:%.*]] = call fast fp128 @llvm.pow.f128(fp128 [[CALL]], fp128 [[Y:%.*]])
; CHECK-NEXT:    ret fp128 [[POW]]
;
  %call = call fp128 @exp2l(fp128 %x)
  %pow = call fast fp128 @llvm.pow.f128(fp128 %call, fp128 %y)
  ret fp128 %pow
}

; TODO: exp10() is not widely enabled by many targets yet.

define float @powf_exp10f(float %x, float %y) {
; CHECK-LABEL: @powf_exp10f(
; CHECK-NEXT:    [[CALL:%.*]] = call fast float @exp10f(float [[X:%.*]]) #1
; CHECK-NEXT:    [[POW:%.*]] = call fast float @llvm.pow.f32(float [[CALL]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[POW]]
;
  %call = call fast float @exp10f(float %x) nounwind readnone
  %pow = call fast float @llvm.pow.f32(float %call, float %y)
  ret float %pow
}

define double @pow_exp10(double %x, double %y) {
; CHECK-LABEL: @pow_exp10(
; CHECK-NEXT:    [[CALL:%.*]] = call fast double @exp10(double [[X:%.*]]) #1
; CHECK-NEXT:    [[POW:%.*]] = call fast double @llvm.pow.f64(double [[CALL]], double [[Y:%.*]])
; CHECK-NEXT:    ret double [[POW]]
;
  %call = call fast double @exp10(double %x) nounwind readnone
  %pow = call fast double @llvm.pow.f64(double %call, double %y)
  ret double %pow
}

define fp128 @pow_exp10l(fp128 %x, fp128 %y) {
; CHECK-LABEL: @pow_exp10l(
; CHECK-NEXT:    [[CALL:%.*]] = call fast fp128 @exp10l(fp128 [[X:%.*]]) #1
; CHECK-NEXT:    [[POW:%.*]] = call fast fp128 @llvm.pow.f128(fp128 [[CALL]], fp128 [[Y:%.*]])
; CHECK-NEXT:    ret fp128 [[POW]]
;
  %call = call fast fp128 @exp10l(fp128 %x) nounwind readnone
  %pow = call fast fp128 @llvm.pow.f128(fp128 %call, fp128 %y)
  ret fp128 %pow
}

define float @reuse_fast(float %x, float %y, float * %p) {
; CHECK-LABEL: @reuse_fast(
; CHECK-NEXT:    [[EXP:%.*]] = call fast float @expf(float [[X:%.*]])
; CHECK-NEXT:    [[POW:%.*]] = call fast float @powf(float [[EXP]], float [[Y:%.*]])
; CHECK-NEXT:    store float [[EXP]], float* [[P:%.*]], align 4
; CHECK-NEXT:    ret float [[POW]]
;
  %exp = call fast float @expf(float %x)
  %pow = call fast float @powf(float %exp, float %y)
  store float %exp, float *%p, align 4
  ret float %pow
}

define fp128 @reuse_libcall(fp128 %x, fp128 %y, fp128 * %p) {
; CHECK-LABEL: @reuse_libcall(
; CHECK-NEXT:    [[EXP:%.*]] = call fp128 @expl(fp128 [[X:%.*]])
; CHECK-NEXT:    [[POW:%.*]] = call fp128 @powl(fp128 [[EXP]], fp128 [[Y:%.*]])
; CHECK-NEXT:    store fp128 [[EXP]], fp128* [[P:%.*]], align 16
; CHECK-NEXT:    ret fp128 [[POW]]
;
  %exp = call fp128 @expl(fp128 %x)
  %pow = call fp128 @powl(fp128 %exp, fp128 %y)
  store fp128 %exp, fp128 *%p, align 16
  ret fp128 %pow
}

define double @function_pointer(double ()* %fptr, double %p1) {
; CHECK-LABEL: @function_pointer(
; CHECK-NEXT:    [[CALL1:%.*]] = call fast double [[FPTR:%.*]]()
; CHECK-NEXT:    [[POW:%.*]] = call fast double @llvm.pow.f64(double [[CALL1]], double [[P1:%.*]])
; CHECK-NEXT:    ret double [[POW]]
;
  %call1 = call fast double %fptr()
  %pow = call fast double @llvm.pow.f64(double %call1, double %p1)
  ret double %pow
}

; pow(C,x) -> exp2(log2(C)*x)

declare void @use_d(double)
declare void @use_f(float)

define double @pow_ok_base(double %e) {
; CHECK-LABEL: @pow_ok_base(
; Do not change 0xBFE0776{{.*}} to the exact constant, see PR42740
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn double [[E:%.*]], 0xBFE0776{{.*}}
; CHECK-NEXT:    [[EXP2:%.*]] = call nnan ninf afn double @exp2(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP2]]
;
  %call = tail call afn nnan ninf double @pow(double 0x3FE6666666666666, double %e)
  ret double %call
}

define double @pow_ok_base_fast(double %e) {
; CHECK-LABEL: @pow_ok_base_fast(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fast double [[E:%.*]], 0xBFE0776{{.*}}
; CHECK-NEXT:    [[EXP2:%.*]] = call fast double @exp2(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP2]]
;
  %call = tail call fast double @pow(double 0x3FE6666666666666, double %e)
  ret double %call
}

define double @pow_ok_base2(double %e) {
; CHECK-LABEL: @pow_ok_base2(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn double [[E:%.*]], 0x4010952{{.*}}
; CHECK-NEXT:    [[EXP2:%.*]] = call nnan ninf afn double @exp2(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP2]]
;
  %call = tail call afn nnan ninf double @pow(double 1.770000e+01, double %e)
  ret double %call
}

define double @pow_ok_base3(double %e) {
; CHECK-LABEL: @pow_ok_base3(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn double [[E:%.*]], 0x400AB0B5{{.*}}
; CHECK-NEXT:    [[EXP2:%.*]] = call nnan ninf afn double @exp2(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP2]]
;
  %call = tail call afn nnan ninf double @pow(double 1.010000e+01, double %e)
  ret double %call
}

define double @pow_ok_ten_base(double %e) {
; CHECK-LABEL: @pow_ok_ten_base(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn double [[E:%.*]], 0x400A934F{{.*}}
; CHECK-NEXT:    [[EXP2:%.*]] = call nnan ninf afn double @exp2(double [[MUL]])
; CHECK-NEXT:    ret double [[EXP2]]
;
  %call = tail call afn nnan ninf double @pow(double 1.000000e+01, double %e)
  ret double %call
}

define double @pow_ok_denorm_base(double %e) {
; CHECK-LABEL: @pow_ok_denorm_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn double @pow(double 0xFFFFFFFF, double [[E:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call afn nnan ninf double @pow(double 0x00000000FFFFFFFF, double %e)
  ret double %call
}

define float @powf_ok_base(float %e) {
; CHECK-LABEL: @powf_ok_base(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn float [[E:%.*]], 0xBFE07762{{.*}}
; CHECK-NEXT:    [[EXP2F:%.*]] = call nnan ninf afn float @exp2f(float [[MUL]])
; CHECK-NEXT:    ret float [[EXP2F]]
;
  %call = tail call afn nnan ninf float @powf(float 0x3FE6666660000000, float %e)
  ret float %call
}

define float @powf_ok_base2(float %e) {
; CHECK-LABEL: @powf_ok_base2(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn float [[E:%.*]], 0x4010952{{.*}}
; CHECK-NEXT:    [[EXP2F:%.*]] = call nnan ninf afn float @exp2f(float [[MUL]])
; CHECK-NEXT:    ret float [[EXP2F]]
;
  %call = tail call afn nnan ninf float @powf(float 0x4031B33340000000, float %e)
  ret float %call
}

define float @powf_ok_base3(float %e) {
; CHECK-LABEL: @powf_ok_base3(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn float [[E:%.*]], 0x400AB0B5{{.*}}
; CHECK-NEXT:    [[EXP2F:%.*]] = call nnan ninf afn float @exp2f(float [[MUL]])
; CHECK-NEXT:    ret float [[EXP2F]]
;
  %call = tail call afn nnan ninf float @powf(float 0x4024333340000000, float %e)
  ret float %call
}

define float @powf_ok_ten_base(float %e) {
; CHECK-LABEL: @powf_ok_ten_base(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn float [[E:%.*]], 0x400A934{{.*}}
; CHECK-NEXT:    [[EXP2F:%.*]] = call nnan ninf afn float @exp2f(float [[MUL]])
; CHECK-NEXT:    ret float [[EXP2F]]
;
  %call = tail call afn nnan ninf float @powf(float 1.000000e+01, float %e)
  ret float %call
}

define float @powf_ok_denorm_base(float %e) {
; CHECK-LABEL: @powf_ok_denorm_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn float @powf(float 0x3780000000000000, float [[E:%.*]])
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = tail call afn nnan ninf float @powf(float 0x3780000000000000, float %e)
  ret float %call
}

; Negative tests

define double @pow_zero_base(double %e) {
; CHECK-LABEL: @pow_zero_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn double @pow(double 0.000000e+00, double [[E:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call afn nnan ninf double @pow(double 0.000000e+00, double %e)
  ret double %call
}

define double @pow_zero_base2(double %e) {
; CHECK-LABEL: @pow_zero_base2(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn double @pow(double -0.000000e+00, double [[E:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call afn nnan ninf double @pow(double -0.000000e+00, double %e)
  ret double %call
}

define double @pow_inf_base(double %e) {
; CHECK-LABEL: @pow_inf_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn double @pow(double 0x7FF0000000000000, double [[E:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call afn nnan ninf double @pow(double 0x7FF0000000000000, double %e)
  ret double %call
}

define double @pow_nan_base(double %e) {
; CHECK-LABEL: @pow_nan_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn double @pow(double 0x7FF8000000000000, double [[E:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call afn nnan ninf double @pow(double 0x7FF8000000000000, double %e)
  ret double %call
}

define double @pow_negative_base(double %e) {
; CHECK-LABEL: @pow_negative_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn double @pow(double -4.000000e+00, double [[E:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call afn nnan ninf double @pow(double -4.000000e+00, double %e)
  ret double %call
}

define double @pow_multiuse(double %e) {
; CHECK-LABEL: @pow_multiuse(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn double [[E:%.*]], 0x4002934{{.*}}
; CHECK-NEXT:    [[EXP2:%.*]] = call nnan ninf afn double @exp2(double [[MUL]])
; CHECK-NEXT:    tail call void @use_d(double [[EXP2]])
; CHECK-NEXT:    ret double [[EXP2]]
;
  %call = tail call afn nnan ninf double @pow(double 5.000000e+00, double %e)
  tail call void @use_d(double %call)
  ret double %call
}

define double @pow_ok_base_no_afn(double %e) {
; CHECK-LABEL: @pow_ok_base_no_afn(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf double @pow(double 0x3FE6666666666666, double [[E:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call nnan ninf double @pow(double 0x3FE6666666666666, double %e)
  ret double %call
}

define double @pow_ok_base_no_nnan(double %e) {
; CHECK-LABEL: @pow_ok_base_no_nnan(
; CHECK-NEXT:    [[CALL:%.*]] = tail call ninf afn double @pow(double 0x3FE6666666666666, double [[E:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call afn ninf double @pow(double 0x3FE6666666666666, double %e)
  ret double %call
}

define double @pow_ok_base_no_ninf(double %e) {
; CHECK-LABEL: @pow_ok_base_no_ninf(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan afn double @pow(double 0x3FE6666666666666, double [[E:%.*]])
; CHECK-NEXT:    ret double [[CALL]]
;
  %call = tail call afn nnan double @pow(double 0x3FE6666666666666, double %e)
  ret double %call
}

define float @powf_zero_base(float %e) {
; CHECK-LABEL: @powf_zero_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn float @powf(float 0.000000e+00, float [[E:%.*]])
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = tail call afn nnan ninf float @powf(float 0.000000e+00, float %e)
  ret float %call
}

define float @powf_zero_base2(float %e) {
; CHECK-LABEL: @powf_zero_base2(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn float @powf(float -0.000000e+00, float [[E:%.*]])
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = tail call afn nnan ninf float @powf(float -0.000000e+00, float %e)
  ret float %call
}

define float @powf_inf_base(float %e) {
; CHECK-LABEL: @powf_inf_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn float @powf(float 0x7FF0000000000000, float [[E:%.*]])
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = tail call afn nnan ninf float @powf(float 0x7FF0000000000000, float %e)
  ret float %call
}

define float @powf_nan_base(float %e) {
; CHECK-LABEL: @powf_nan_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn float @powf(float 0x7FF8000000000000, float [[E:%.*]])
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = tail call afn nnan ninf float @powf(float 0x7FF8000000000000, float %e)
  ret float %call
}

define float @powf_negative_base(float %e) {
; CHECK-LABEL: @powf_negative_base(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn float @powf(float -4.000000e+00, float [[E:%.*]])
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = tail call afn nnan ninf float @powf(float -4.000000e+00, float %e)
  ret float %call
}

define float @powf_multiuse(float %e) {
; CHECK-LABEL: @powf_multiuse(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan ninf afn float [[E:%.*]], 0x4002934{{.*}}
; CHECK-NEXT:    [[EXP2F:%.*]] = call nnan ninf afn float @exp2f(float [[MUL]])
; CHECK-NEXT:    tail call void @use_f(float [[EXP2F]])
; CHECK-NEXT:    ret float [[EXP2F]]
;
  %call = tail call afn nnan ninf float @powf(float 5.000000e+00, float %e)
  tail call void @use_f(float %call)
  ret float %call
}

define float @powf_ok_base_no_afn(float %e) {
; CHECK-LABEL: @powf_ok_base_no_afn(
; CHECK-NEXT:    [[CALL:%.*]] = tail call float @powf(float 0x3FE6666660000000, float [[E:%.*]])
; CHECK-NEXT:    ret float [[CALL]]
;
  %call = tail call float @powf(float 0x3FE6666660000000, float %e)
  ret float %call
}

define fp128 @powl_long_dbl_no_fold(fp128 %e) {
; CHECK-LABEL: @powl_long_dbl_no_fold(
; CHECK-NEXT:    [[CALL:%.*]] = tail call nnan ninf afn fp128 @powl(fp128 0xL00000000000000005001000000000000, fp128 [[E:%.*]])
; CHECK-NEXT:    ret fp128 [[CALL]]
;
  %call = tail call afn nnan ninf fp128 @powl(fp128 0xL00000000000000005001000000000000, fp128 %e)
  ret fp128 %call
}

declare float @expf(float)
declare double @exp(double)
declare fp128 @expl(fp128)
declare float @exp2f(float)
declare double @exp2(double)
declare fp128 @exp2l(fp128)
declare float @exp10f(float)
declare double @exp10(double)
declare fp128 @exp10l(fp128)
declare float @powf(float, float)
declare double @pow(double, double)
declare fp128 @powl(fp128, fp128)
declare float @llvm.pow.f32(float, float)
declare double @llvm.pow.f64(double, double)
declare fp128 @llvm.pow.f128(fp128, fp128)
