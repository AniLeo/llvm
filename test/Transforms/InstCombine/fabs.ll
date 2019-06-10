; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -mtriple=x86_64-unknown-linux-gnu < %s -instcombine -S | FileCheck %s

; Make sure libcalls are replaced with intrinsic calls.

declare float @llvm.fabs.f32(float)
declare double @llvm.fabs.f64(double)
declare fp128 @llvm.fabs.f128(fp128)

declare float @fabsf(float)
declare double @fabs(double)
declare fp128 @fabsl(fp128)
declare float @llvm.fma.f32(float, float, float)
declare float @llvm.fmuladd.f32(float, float, float)

define float @replace_fabs_call_f32(float %x) {
; CHECK-LABEL: @replace_fabs_call_f32(
; CHECK-NEXT:    [[FABSF:%.*]] = call float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[FABSF]]
;
  %fabsf = tail call float @fabsf(float %x)
  ret float %fabsf
}

define double @replace_fabs_call_f64(double %x) {
; CHECK-LABEL: @replace_fabs_call_f64(
; CHECK-NEXT:    [[FABS:%.*]] = call double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[FABS]]
;
  %fabs = tail call double @fabs(double %x)
  ret double %fabs
}

define fp128 @replace_fabs_call_f128(fp128 %x) {
; CHECK-LABEL: @replace_fabs_call_f128(
; CHECK-NEXT:    [[FABSL:%.*]] = call fp128 @llvm.fabs.f128(fp128 [[X:%.*]])
; CHECK-NEXT:    ret fp128 [[FABSL]]
;
  %fabsl = tail call fp128 @fabsl(fp128 %x)
  ret fp128 %fabsl
}

; Make sure fast math flags are preserved when replacing the libcall.
define float @fmf_replace_fabs_call_f32(float %x) {
; CHECK-LABEL: @fmf_replace_fabs_call_f32(
; CHECK-NEXT:    [[FABSF:%.*]] = call nnan float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[FABSF]]
;
  %fabsf = tail call nnan float @fabsf(float %x)
  ret float %fabsf
}

; Make sure all intrinsic calls are eliminated when the input is known
; positive.

; The fabs cannot be eliminated because %x may be a NaN

define float @square_fabs_intrinsic_f32(float %x) {
; CHECK-LABEL: @square_fabs_intrinsic_f32(
; CHECK-NEXT:    [[MUL:%.*]] = fmul float [[X:%.*]], [[X]]
; CHECK-NEXT:    [[FABSF:%.*]] = tail call float @llvm.fabs.f32(float [[MUL]])
; CHECK-NEXT:    ret float [[FABSF]]
;
  %mul = fmul float %x, %x
  %fabsf = tail call float @llvm.fabs.f32(float %mul)
  ret float %fabsf
}

define double @square_fabs_intrinsic_f64(double %x) {
; CHECK-LABEL: @square_fabs_intrinsic_f64(
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[X:%.*]], [[X]]
; CHECK-NEXT:    [[FABS:%.*]] = tail call double @llvm.fabs.f64(double [[MUL]])
; CHECK-NEXT:    ret double [[FABS]]
;
  %mul = fmul double %x, %x
  %fabs = tail call double @llvm.fabs.f64(double %mul)
  ret double %fabs
}

define fp128 @square_fabs_intrinsic_f128(fp128 %x) {
; CHECK-LABEL: @square_fabs_intrinsic_f128(
; CHECK-NEXT:    [[MUL:%.*]] = fmul fp128 [[X:%.*]], [[X]]
; CHECK-NEXT:    [[FABSL:%.*]] = tail call fp128 @llvm.fabs.f128(fp128 [[MUL]])
; CHECK-NEXT:    ret fp128 [[FABSL]]
;
  %mul = fmul fp128 %x, %x
  %fabsl = tail call fp128 @llvm.fabs.f128(fp128 %mul)
  ret fp128 %fabsl
}

define float @square_nnan_fabs_intrinsic_f32(float %x) {
; CHECK-LABEL: @square_nnan_fabs_intrinsic_f32(
; CHECK-NEXT:    [[MUL:%.*]] = fmul nnan float [[X:%.*]], [[X]]
; CHECK-NEXT:    ret float [[MUL]]
;
  %mul = fmul nnan float %x, %x
  %fabsf = call float @llvm.fabs.f32(float %mul)
  ret float %fabsf
}

; Shrinking a library call to a smaller type should not be inhibited by nor inhibit the square optimization.

define float @square_fabs_shrink_call1(float %x) {
; CHECK-LABEL: @square_fabs_shrink_call1(
; CHECK-NEXT:    [[TMP1:%.*]] = fmul float [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TRUNC:%.*]] = call float @llvm.fabs.f32(float [[TMP1]])
; CHECK-NEXT:    ret float [[TRUNC]]
;
  %ext = fpext float %x to double
  %sq = fmul double %ext, %ext
  %fabs = call double @fabs(double %sq)
  %trunc = fptrunc double %fabs to float
  ret float %trunc
}

define float @square_fabs_shrink_call2(float %x) {
; CHECK-LABEL: @square_fabs_shrink_call2(
; CHECK-NEXT:    [[SQ:%.*]] = fmul float [[X:%.*]], [[X]]
; CHECK-NEXT:    [[TRUNC:%.*]] = call float @llvm.fabs.f32(float [[SQ]])
; CHECK-NEXT:    ret float [[TRUNC]]
;
  %sq = fmul float %x, %x
  %ext = fpext float %sq to double
  %fabs = call double @fabs(double %ext)
  %trunc = fptrunc double %fabs to float
  ret float %trunc
}

define float @fabs_select_constant_negative_positive(i32 %c) {
; CHECK-LABEL: @fabs_select_constant_negative_positive(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[FABS:%.*]] = select i1 [[CMP]], float 1.000000e+00, float 2.000000e+00
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float -1.0, float 2.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define float @fabs_select_constant_positive_negative(i32 %c) {
; CHECK-LABEL: @fabs_select_constant_positive_negative(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[FABS:%.*]] = select i1 [[CMP]], float 1.000000e+00, float 2.000000e+00
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float 1.0, float -2.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define float @fabs_select_constant_negative_negative(i32 %c) {
; CHECK-LABEL: @fabs_select_constant_negative_negative(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[FABS:%.*]] = select i1 [[CMP]], float 1.000000e+00, float 2.000000e+00
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float -1.0, float -2.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define float @fabs_select_constant_neg0(i32 %c) {
; CHECK-LABEL: @fabs_select_constant_neg0(
; CHECK-NEXT:    ret float 0.000000e+00
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float -0.0, float 0.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

define float @fabs_select_var_constant_negative(i32 %c, float %x) {
; CHECK-LABEL: @fabs_select_var_constant_negative(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C:%.*]], 0
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], float [[X:%.*]], float -1.000000e+00
; CHECK-NEXT:    [[FABS:%.*]] = call float @llvm.fabs.f32(float [[SELECT]])
; CHECK-NEXT:    ret float [[FABS]]
;
  %cmp = icmp eq i32 %c, 0
  %select = select i1 %cmp, float %x, float -1.0
  %fabs = call float @llvm.fabs.f32(float %select)
  ret float %fabs
}

; The fabs cannot be eliminated because %x may be a NaN

define float @square_fma_fabs_intrinsic_f32(float %x) {
; CHECK-LABEL: @square_fma_fabs_intrinsic_f32(
; CHECK-NEXT:    [[FMA:%.*]] = call float @llvm.fma.f32(float [[X:%.*]], float [[X]], float 1.000000e+00)
; CHECK-NEXT:    [[FABSF:%.*]] = call float @llvm.fabs.f32(float [[FMA]])
; CHECK-NEXT:    ret float [[FABSF]]
;
  %fma = call float @llvm.fma.f32(float %x, float %x, float 1.0)
  %fabsf = call float @llvm.fabs.f32(float %fma)
  ret float %fabsf
}

; The fabs cannot be eliminated because %x may be a NaN

define float @square_nnan_fma_fabs_intrinsic_f32(float %x) {
; CHECK-LABEL: @square_nnan_fma_fabs_intrinsic_f32(
; CHECK-NEXT:    [[FMA:%.*]] = call nnan float @llvm.fma.f32(float [[X:%.*]], float [[X]], float 1.000000e+00)
; CHECK-NEXT:    ret float [[FMA]]
;
  %fma = call nnan float @llvm.fma.f32(float %x, float %x, float 1.0)
  %fabsf = call float @llvm.fabs.f32(float %fma)
  ret float %fabsf
}

define float @square_fmuladd_fabs_intrinsic_f32(float %x) {
; CHECK-LABEL: @square_fmuladd_fabs_intrinsic_f32(
; CHECK-NEXT:    [[FMULADD:%.*]] = call float @llvm.fmuladd.f32(float [[X:%.*]], float [[X]], float 1.000000e+00)
; CHECK-NEXT:    [[FABSF:%.*]] = call float @llvm.fabs.f32(float [[FMULADD]])
; CHECK-NEXT:    ret float [[FABSF]]
;
  %fmuladd = call float @llvm.fmuladd.f32(float %x, float %x, float 1.0)
  %fabsf = call float @llvm.fabs.f32(float %fmuladd)
  ret float %fabsf
}

define float @square_nnan_fmuladd_fabs_intrinsic_f32(float %x) {
; CHECK-LABEL: @square_nnan_fmuladd_fabs_intrinsic_f32(
; CHECK-NEXT:    [[FMULADD:%.*]] = call nnan float @llvm.fmuladd.f32(float [[X:%.*]], float [[X]], float 1.000000e+00)
; CHECK-NEXT:    ret float [[FMULADD]]
;
  %fmuladd = call nnan float @llvm.fmuladd.f32(float %x, float %x, float 1.0)
  %fabsf = call float @llvm.fabs.f32(float %fmuladd)
  ret float %fabsf
}

; Don't introduce a second fpext

define double @multi_use_fabs_fpext(float %x) {
; CHECK-LABEL: @multi_use_fabs_fpext(
; CHECK-NEXT:    [[FPEXT:%.*]] = fpext float [[X:%.*]] to double
; CHECK-NEXT:    [[FABS:%.*]] = call double @llvm.fabs.f64(double [[FPEXT]])
; CHECK-NEXT:    store volatile double [[FPEXT]], double* undef, align 8
; CHECK-NEXT:    ret double [[FABS]]
;
  %fpext = fpext float %x to double
  %fabs = call double @llvm.fabs.f64(double %fpext)
  store volatile double %fpext, double* undef
  ret double %fabs
}

; Negative test for the fabs folds below: we require nnan, so
; we won't always clear the sign bit of a NaN value.

define double @select_fcmp_ole_zero(double %x) {
; CHECK-LABEL: @select_fcmp_ole_zero(
; CHECK-NEXT:    [[LEZERO:%.*]] = fcmp ole double [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[NEGX:%.*]] = fsub double 0.000000e+00, [[X]]
; CHECK-NEXT:    [[FABS:%.*]] = select i1 [[LEZERO]], double [[NEGX]], double [[X]]
; CHECK-NEXT:    ret double [[FABS]]
;
  %lezero = fcmp ole double %x, 0.0
  %negx = fsub double 0.0, %x
  %fabs = select i1 %lezero, double %negx, double %x
  ret double %fabs
}

; X <= 0.0 ? (0.0 - X) : X --> fabs(X)

define double @select_fcmp_nnan_ole_zero(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_ole_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %lezero = fcmp ole double %x, 0.0
  %negx = fsub nnan double 0.0, %x
  %fabs = select i1 %lezero, double %negx, double %x
  ret double %fabs
}

; Negative test - wrong predicate.

define double @select_fcmp_nnan_olt_zero(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_olt_zero(
; CHECK-NEXT:    [[LEZERO:%.*]] = fcmp olt double [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[NEGX:%.*]] = fsub nnan double 0.000000e+00, [[X]]
; CHECK-NEXT:    [[FABS:%.*]] = select i1 [[LEZERO]], double [[NEGX]], double [[X]]
; CHECK-NEXT:    ret double [[FABS]]
;
  %lezero = fcmp olt double %x, 0.0
  %negx = fsub nnan double 0.0, %x
  %fabs = select i1 %lezero, double %negx, double %x
  ret double %fabs
}

; X <= -0.0 ? (0.0 - X) : X --> fabs(X)

define <2 x float> @select_fcmp_nnan_ole_negzero(<2 x float> %x) {
; CHECK-LABEL: @select_fcmp_nnan_ole_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan <2 x float> @llvm.fabs.v2f32(<2 x float> [[X:%.*]])
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %lezero = fcmp ole <2 x float> %x, <float -0.0, float -0.0>
  %negx = fsub nnan <2 x float> <float 0.0, float undef>, %x
  %fabs = select <2 x i1> %lezero, <2 x float> %negx, <2 x float> %x
  ret <2 x float> %fabs
}

; X > 0.0 ? X : (0.0 - X) --> fabs(X)

define fp128 @select_fcmp_nnan_ogt_zero(fp128 %x) {
; CHECK-LABEL: @select_fcmp_nnan_ogt_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan fp128 @llvm.fabs.f128(fp128 [[X:%.*]])
; CHECK-NEXT:    ret fp128 [[TMP1]]
;
  %gtzero = fcmp ogt fp128 %x, zeroinitializer
  %negx = fsub nnan fp128 zeroinitializer, %x
  %fabs = select i1 %gtzero, fp128 %x, fp128 %negx
  ret fp128 %fabs
}

; X > -0.0 ? X : (0.0 - X) --> fabs(X)

define half @select_fcmp_nnan_ogt_negzero(half %x) {
; CHECK-LABEL: @select_fcmp_nnan_ogt_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan half @llvm.fabs.f16(half [[X:%.*]])
; CHECK-NEXT:    ret half [[TMP1]]
;
  %gtzero = fcmp ogt half %x, -0.0
  %negx = fsub nnan half 0.0, %x
  %fabs = select i1 %gtzero, half %x, half %negx
  ret half %fabs
}

; Negative test - wrong predicate.

define half @select_fcmp_nnan_oge_negzero(half %x) {
; CHECK-LABEL: @select_fcmp_nnan_oge_negzero(
; CHECK-NEXT:    [[GTZERO:%.*]] = fcmp oge half [[X:%.*]], 0xH0000
; CHECK-NEXT:    [[NEGX:%.*]] = fsub nnan half 0xH0000, [[X]]
; CHECK-NEXT:    [[FABS:%.*]] = select i1 [[GTZERO]], half [[X]], half [[NEGX]]
; CHECK-NEXT:    ret half [[FABS]]
;
  %gtzero = fcmp oge half %x, -0.0
  %negx = fsub nnan half 0.0, %x
  %fabs = select i1 %gtzero, half %x, half %negx
  ret half %fabs
}

; X < 0.0 ? -X : X --> fabs(X)

define double @select_fcmp_nnan_nsz_olt_zero(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_olt_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %ltzero = fcmp olt double %x, 0.0
  %negx = fsub nnan nsz double -0.0, %x
  %fabs = select i1 %ltzero, double %negx, double %x
  ret double %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define double @select_fcmp_nnan_nsz_ult_zero(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ult_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %ltzero = fcmp ult double %x, 0.0
  %negx = fsub nnan nsz double -0.0, %x
  %fabs = select i1 %ltzero, double %negx, double %x
  ret double %fabs
}

define double @select_fcmp_nnan_nsz_olt_zero_unary_fneg(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_olt_zero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %ltzero = fcmp olt double %x, 0.0
  %negx = fneg nnan nsz double %x
  %fabs = select i1 %ltzero, double %negx, double %x
  ret double %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define double @select_fcmp_nnan_nsz_ult_zero_unary_fneg(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ult_zero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %ltzero = fcmp ult double %x, 0.0
  %negx = fneg nnan nsz double %x
  %fabs = select i1 %ltzero, double %negx, double %x
  ret double %fabs
}

; X < -0.0 ? -X : X --> fabs(X)

define float @select_fcmp_nnan_nsz_olt_negzero(float %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_olt_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan ninf nsz float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %ltzero = fcmp olt float %x, -0.0
  %negx = fsub nnan ninf nsz float -0.0, %x
  %fabs = select i1 %ltzero, float %negx, float %x
  ret float %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define float @select_fcmp_nnan_nsz_ult_negzero(float %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ult_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan ninf nsz float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %ltzero = fcmp ult float %x, -0.0
  %negx = fsub nnan ninf nsz float -0.0, %x
  %fabs = select i1 %ltzero, float %negx, float %x
  ret float %fabs
}

define float @select_fcmp_nnan_nsz_olt_negzero_unary_fneg(float %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_olt_negzero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan ninf nsz float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %ltzero = fcmp olt float %x, -0.0
  %negx = fneg nnan ninf nsz float %x
  %fabs = select i1 %ltzero, float %negx, float %x
  ret float %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define float @select_fcmp_nnan_nsz_ult_negzero_unary_fneg(float %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ult_negzero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan ninf nsz float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %ltzero = fcmp ult float %x, -0.0
  %negx = fneg nnan ninf nsz float %x
  %fabs = select i1 %ltzero, float %negx, float %x
  ret float %fabs
}

; X <= 0.0 ? -X : X --> fabs(X)

define double @select_fcmp_nnan_nsz_ole_zero(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ole_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %lezero = fcmp ole double %x, 0.0
  %negx = fsub fast double -0.0, %x
  %fabs = select i1 %lezero, double %negx, double %x
  ret double %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define double @select_fcmp_nnan_nsz_ule_zero(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ule_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %lezero = fcmp ule double %x, 0.0
  %negx = fsub fast double -0.0, %x
  %fabs = select i1 %lezero, double %negx, double %x
  ret double %fabs
}

define double @select_fcmp_nnan_nsz_ole_zero_unary_fneg(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ole_zero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %lezero = fcmp ole double %x, 0.0
  %negx = fneg fast double %x
  %fabs = select i1 %lezero, double %negx, double %x
  ret double %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define double @select_fcmp_nnan_nsz_ule_zero_unary_fneg(double %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ule_zero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast double @llvm.fabs.f64(double [[X:%.*]])
; CHECK-NEXT:    ret double [[TMP1]]
;
  %lezero = fcmp ule double %x, 0.0
  %negx = fneg fast double %x
  %fabs = select i1 %lezero, double %negx, double %x
  ret double %fabs
}

; X <= -0.0 ? -X : X --> fabs(X)

define float @select_fcmp_nnan_nsz_ole_negzero(float %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ole_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %lezero = fcmp ole float %x, -0.0
  %negx = fsub nnan nsz float -0.0, %x
  %fabs = select i1 %lezero, float %negx, float %x
  ret float %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define float @select_fcmp_nnan_nsz_ule_negzero(float %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ule_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %lezero = fcmp ule float %x, -0.0
  %negx = fsub nnan nsz float -0.0, %x
  %fabs = select i1 %lezero, float %negx, float %x
  ret float %fabs
}

define float @select_fcmp_nnan_nsz_ole_negzero_unary_fneg(float %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ole_negzero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %lezero = fcmp ole float %x, -0.0
  %negx = fneg nnan nsz float %x
  %fabs = select i1 %lezero, float %negx, float %x
  ret float %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define float @select_fcmp_nnan_nsz_ule_negzero_unary_fneg(float %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ule_negzero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz float @llvm.fabs.f32(float [[X:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %lezero = fcmp ule float %x, -0.0
  %negx = fneg nnan nsz float %x
  %fabs = select i1 %lezero, float %negx, float %x
  ret float %fabs
}

; X > 0.0 ? X : (0.0 - X) --> fabs(X)

define <2 x float> @select_fcmp_nnan_nsz_ogt_zero(<2 x float> %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ogt_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz arcp <2 x float> @llvm.fabs.v2f32(<2 x float> [[X:%.*]])
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %gtzero = fcmp ogt <2 x float> %x, zeroinitializer
  %negx = fsub nnan nsz arcp <2 x float> <float -0.0, float -0.0>, %x
  %fabs = select <2 x i1> %gtzero, <2 x float> %x, <2 x float> %negx
  ret <2 x float> %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define <2 x float> @select_fcmp_nnan_nsz_ugt_zero(<2 x float> %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ugt_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz arcp <2 x float> @llvm.fabs.v2f32(<2 x float> [[X:%.*]])
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %gtzero = fcmp ugt <2 x float> %x, zeroinitializer
  %negx = fsub nnan nsz arcp <2 x float> <float -0.0, float -0.0>, %x
  %fabs = select <2 x i1> %gtzero, <2 x float> %x, <2 x float> %negx
  ret <2 x float> %fabs
}

define <2 x float> @select_fcmp_nnan_nsz_ogt_zero_unary_fneg(<2 x float> %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ogt_zero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz arcp <2 x float> @llvm.fabs.v2f32(<2 x float> [[X:%.*]])
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %gtzero = fcmp ogt <2 x float> %x, zeroinitializer
  %negx = fneg nnan nsz arcp <2 x float> %x
  %fabs = select <2 x i1> %gtzero, <2 x float> %x, <2 x float> %negx
  ret <2 x float> %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define <2 x float> @select_fcmp_nnan_nsz_ugt_zero_unary_fneg(<2 x float> %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ugt_zero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz arcp <2 x float> @llvm.fabs.v2f32(<2 x float> [[X:%.*]])
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %gtzero = fcmp ugt <2 x float> %x, zeroinitializer
  %negx = fneg nnan nsz arcp <2 x float> %x
  %fabs = select <2 x i1> %gtzero, <2 x float> %x, <2 x float> %negx
  ret <2 x float> %fabs
}

; X > -0.0 ? X : (0.0 - X) --> fabs(X)

define half @select_fcmp_nnan_nsz_ogt_negzero(half %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ogt_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast half @llvm.fabs.f16(half [[X:%.*]])
; CHECK-NEXT:    ret half [[TMP1]]
;
  %gtzero = fcmp ogt half %x, -0.0
  %negx = fsub fast half 0.0, %x
  %fabs = select i1 %gtzero, half %x, half %negx
  ret half %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define half @select_fcmp_nnan_nsz_ugt_negzero(half %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_ugt_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast half @llvm.fabs.f16(half [[X:%.*]])
; CHECK-NEXT:    ret half [[TMP1]]
;
  %gtzero = fcmp ugt half %x, -0.0
  %negx = fsub fast half 0.0, %x
  %fabs = select i1 %gtzero, half %x, half %negx
  ret half %fabs
}

; X > 0.0 ? X : (0.0 - X) --> fabs(X)

define <2 x double> @select_fcmp_nnan_nsz_oge_zero(<2 x double> %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_oge_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call reassoc nnan nsz <2 x double> @llvm.fabs.v2f64(<2 x double> [[X:%.*]])
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %gezero = fcmp oge <2 x double> %x, zeroinitializer
  %negx = fsub nnan nsz reassoc <2 x double> <double -0.0, double -0.0>, %x
  %fabs = select <2 x i1> %gezero, <2 x double> %x, <2 x double> %negx
  ret <2 x double> %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define <2 x double> @select_fcmp_nnan_nsz_uge_zero(<2 x double> %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_uge_zero(
; CHECK-NEXT:    [[TMP1:%.*]] = call reassoc nnan nsz <2 x double> @llvm.fabs.v2f64(<2 x double> [[X:%.*]])
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %gezero = fcmp uge <2 x double> %x, zeroinitializer
  %negx = fsub nnan nsz reassoc <2 x double> <double -0.0, double -0.0>, %x
  %fabs = select <2 x i1> %gezero, <2 x double> %x, <2 x double> %negx
  ret <2 x double> %fabs
}

define <2 x double> @select_fcmp_nnan_nsz_oge_zero_unary_fneg(<2 x double> %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_oge_zero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call reassoc nnan nsz <2 x double> @llvm.fabs.v2f64(<2 x double> [[X:%.*]])
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %gezero = fcmp oge <2 x double> %x, zeroinitializer
  %negx = fneg nnan nsz reassoc <2 x double> %x
  %fabs = select <2 x i1> %gezero, <2 x double> %x, <2 x double> %negx
  ret <2 x double> %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define <2 x double> @select_fcmp_nnan_nsz_uge_zero_unary_fneg(<2 x double> %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_uge_zero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call reassoc nnan nsz <2 x double> @llvm.fabs.v2f64(<2 x double> [[X:%.*]])
; CHECK-NEXT:    ret <2 x double> [[TMP1]]
;
  %gezero = fcmp uge <2 x double> %x, zeroinitializer
  %negx = fneg nnan nsz reassoc <2 x double> %x
  %fabs = select <2 x i1> %gezero, <2 x double> %x, <2 x double> %negx
  ret <2 x double> %fabs
}

; X > -0.0 ? X : (0.0 - X) --> fabs(X)

define half @select_fcmp_nnan_nsz_oge_negzero(half %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_oge_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz half @llvm.fabs.f16(half [[X:%.*]])
; CHECK-NEXT:    ret half [[TMP1]]
;
  %gezero = fcmp oge half %x, -0.0
  %negx = fsub nnan nsz half -0.0, %x
  %fabs = select i1 %gezero, half %x, half %negx
  ret half %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define half @select_fcmp_nnan_nsz_uge_negzero(half %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_uge_negzero(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz half @llvm.fabs.f16(half [[X:%.*]])
; CHECK-NEXT:    ret half [[TMP1]]
;
  %gezero = fcmp uge half %x, -0.0
  %negx = fsub nnan nsz half -0.0, %x
  %fabs = select i1 %gezero, half %x, half %negx
  ret half %fabs
}

define half @select_fcmp_nnan_nsz_oge_negzero_unary_fneg(half %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_oge_negzero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz half @llvm.fabs.f16(half [[X:%.*]])
; CHECK-NEXT:    ret half [[TMP1]]
;
  %gezero = fcmp oge half %x, -0.0
  %negx = fneg nnan nsz half %x
  %fabs = select i1 %gezero, half %x, half %negx
  ret half %fabs
}

; Repeat with unordered predicate - nnan allows us to treat ordered/unordered identically.

define half @select_fcmp_nnan_nsz_uge_negzero_unary_fneg(half %x) {
; CHECK-LABEL: @select_fcmp_nnan_nsz_uge_negzero_unary_fneg(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz half @llvm.fabs.f16(half [[X:%.*]])
; CHECK-NEXT:    ret half [[TMP1]]
;
  %gezero = fcmp uge half %x, -0.0
  %negx = fneg nnan nsz half %x
  %fabs = select i1 %gezero, half %x, half %negx
  ret half %fabs
}
