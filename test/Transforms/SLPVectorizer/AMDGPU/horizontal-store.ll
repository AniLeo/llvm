; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -slp-vectorizer -S -slp-threshold=-100 -slp-vectorize-hor-store -dce | FileCheck %s --check-prefix=GFX9

@arr = local_unnamed_addr global [32 x i32] zeroinitializer, align 16
@arr64 = local_unnamed_addr global [32 x i64] zeroinitializer, align 16
@var = global i32 zeroinitializer, align 8
@var64 = global i64 zeroinitializer, align 8

@farr = local_unnamed_addr global [32 x float] zeroinitializer, align 16
@fvar = global float zeroinitializer, align 8

@darr = local_unnamed_addr global [32 x double] zeroinitializer, align 16
@dvar = global double zeroinitializer, align 8

; Tests whether the min/max reduction pattern is vectorized if SLP starts at the store.
define i32 @smaxv6() {
; GFX9-LABEL: @smaxv6(
; GFX9-NEXT:    [[TMP1:%.*]] = load <2 x i32>, <2 x i32>* bitcast ([32 x i32]* @arr to <2 x i32>*), align 16
; GFX9-NEXT:    [[TMP2:%.*]] = extractelement <2 x i32> [[TMP1]], i32 0
; GFX9-NEXT:    [[TMP3:%.*]] = extractelement <2 x i32> [[TMP1]], i32 1
; GFX9-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[TMP2]], [[TMP3]]
; GFX9-NEXT:    [[SELECT1:%.*]] = select i1 [[CMP1]], i32 [[TMP2]], i32 [[TMP3]]
; GFX9-NEXT:    [[TMP4:%.*]] = load <4 x i32>, <4 x i32>* bitcast (i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 2) to <4 x i32>*), align 8
; GFX9-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <4 x i32> [[TMP4]], <4 x i32> poison, <4 x i32> <i32 2, i32 3, i32 undef, i32 undef>
; GFX9-NEXT:    [[RDX_MINMAX_CMP:%.*]] = icmp sgt <4 x i32> [[TMP4]], [[RDX_SHUF]]
; GFX9-NEXT:    [[RDX_MINMAX_SELECT:%.*]] = select <4 x i1> [[RDX_MINMAX_CMP]], <4 x i32> [[TMP4]], <4 x i32> [[RDX_SHUF]]
; GFX9-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <4 x i32> [[RDX_MINMAX_SELECT]], <4 x i32> poison, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
; GFX9-NEXT:    [[RDX_MINMAX_CMP2:%.*]] = icmp sgt <4 x i32> [[RDX_MINMAX_SELECT]], [[RDX_SHUF1]]
; GFX9-NEXT:    [[RDX_MINMAX_SELECT3:%.*]] = select <4 x i1> [[RDX_MINMAX_CMP2]], <4 x i32> [[RDX_MINMAX_SELECT]], <4 x i32> [[RDX_SHUF1]]
; GFX9-NEXT:    [[TMP5:%.*]] = extractelement <4 x i32> [[RDX_MINMAX_SELECT3]], i32 0
; GFX9-NEXT:    [[OP_EXTRA:%.*]] = icmp sgt i32 [[TMP5]], [[SELECT1]]
; GFX9-NEXT:    [[OP_EXTRA4:%.*]] = select i1 [[OP_EXTRA]], i32 [[TMP5]], i32 [[SELECT1]]
; GFX9-NEXT:    [[STORE_SELECT:%.*]] = select i1 [[CMP1]], i32 3, i32 4
; GFX9-NEXT:    store i32 [[STORE_SELECT]], i32* @var, align 8
; GFX9-NEXT:    ret i32 [[OP_EXTRA4]]
;
  %load1 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 0), align 16
  %load2 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 1), align 4
  %cmp1 = icmp sgt i32 %load1, %load2
  %select1 = select i1 %cmp1, i32 %load1, i32 %load2

  %load3 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 2), align 8
  %cmp2 = icmp sgt i32 %select1, %load3
  %select2 = select i1 %cmp2, i32 %select1, i32 %load3

  %load4 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 3), align 4
  %cmp3 = icmp sgt i32 %select2, %load4
  %select3 = select i1 %cmp3, i32 %select2, i32 %load4

  %load5 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 4), align 16
  %cmp4 = icmp sgt i32 %select3, %load5
  %select4 = select i1 %cmp4, i32 %select3, i32 %load5

  %load6 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 5), align 4
  %cmp5 = icmp sgt i32 %select4, %load6
  %select5 = select i1 %cmp5, i32 %select4, i32 %load6

  %store-select = select i1 %cmp1, i32 3, i32 4
  store i32 %store-select, i32* @var, align 8
  ret i32 %select5
}

define i64 @sminv6() {
; GFX9-LABEL: @sminv6(
; GFX9-NEXT:    [[TMP1:%.*]] = load <2 x i64>, <2 x i64>* bitcast ([32 x i64]* @arr64 to <2 x i64>*), align 16
; GFX9-NEXT:    [[TMP2:%.*]] = extractelement <2 x i64> [[TMP1]], i32 0
; GFX9-NEXT:    [[TMP3:%.*]] = extractelement <2 x i64> [[TMP1]], i32 1
; GFX9-NEXT:    [[CMP1:%.*]] = icmp slt i64 [[TMP2]], [[TMP3]]
; GFX9-NEXT:    [[SELECT1:%.*]] = select i1 [[CMP1]], i64 [[TMP2]], i64 [[TMP3]]
; GFX9-NEXT:    [[TMP4:%.*]] = load <4 x i64>, <4 x i64>* bitcast (i64* getelementptr inbounds ([32 x i64], [32 x i64]* @arr64, i64 0, i64 2) to <4 x i64>*), align 16
; GFX9-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <4 x i64> [[TMP4]], <4 x i64> poison, <4 x i32> <i32 2, i32 3, i32 undef, i32 undef>
; GFX9-NEXT:    [[RDX_MINMAX_CMP:%.*]] = icmp slt <4 x i64> [[TMP4]], [[RDX_SHUF]]
; GFX9-NEXT:    [[RDX_MINMAX_SELECT:%.*]] = select <4 x i1> [[RDX_MINMAX_CMP]], <4 x i64> [[TMP4]], <4 x i64> [[RDX_SHUF]]
; GFX9-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <4 x i64> [[RDX_MINMAX_SELECT]], <4 x i64> poison, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
; GFX9-NEXT:    [[RDX_MINMAX_CMP2:%.*]] = icmp slt <4 x i64> [[RDX_MINMAX_SELECT]], [[RDX_SHUF1]]
; GFX9-NEXT:    [[RDX_MINMAX_SELECT3:%.*]] = select <4 x i1> [[RDX_MINMAX_CMP2]], <4 x i64> [[RDX_MINMAX_SELECT]], <4 x i64> [[RDX_SHUF1]]
; GFX9-NEXT:    [[TMP5:%.*]] = extractelement <4 x i64> [[RDX_MINMAX_SELECT3]], i32 0
; GFX9-NEXT:    [[OP_EXTRA:%.*]] = icmp slt i64 [[TMP5]], [[SELECT1]]
; GFX9-NEXT:    [[OP_EXTRA4:%.*]] = select i1 [[OP_EXTRA]], i64 [[TMP5]], i64 [[SELECT1]]
; GFX9-NEXT:    [[STORE_SELECT:%.*]] = select i1 [[CMP1]], i64 3, i64 4
; GFX9-NEXT:    store i64 [[STORE_SELECT]], i64* @var64, align 8
; GFX9-NEXT:    ret i64 [[OP_EXTRA4]]
;
  %load1 = load i64, i64* getelementptr inbounds ([32 x i64], [32 x i64]* @arr64, i64 0, i64 0), align 16
  %load2 = load i64, i64* getelementptr inbounds ([32 x i64], [32 x i64]* @arr64, i64 0, i64 1), align 8
  %cmp1 = icmp slt i64 %load1, %load2
  %select1 = select i1 %cmp1, i64 %load1, i64 %load2

  %load3 = load i64, i64* getelementptr inbounds ([32 x i64], [32 x i64]* @arr64, i64 0, i64 2), align 16
  %cmp2 = icmp slt i64 %select1, %load3
  %select2 = select i1 %cmp2, i64 %select1, i64 %load3

  %load4 = load i64, i64* getelementptr inbounds ([32 x i64], [32 x i64]* @arr64, i64 0, i64 3), align 8
  %cmp3 = icmp slt i64 %select2, %load4
  %select3 = select i1 %cmp3, i64 %select2, i64 %load4

  %load5 = load i64, i64* getelementptr inbounds ([32 x i64], [32 x i64]* @arr64, i64 0, i64 4), align 16
  %cmp4 = icmp slt i64 %select3, %load5
  %select4 = select i1 %cmp4, i64 %select3, i64 %load5

  %load6 = load i64, i64* getelementptr inbounds ([32 x i64], [32 x i64]* @arr64, i64 0, i64 5), align 8
  %cmp5 = icmp slt i64 %select4, %load6
  %select5 = select i1 %cmp5, i64 %select4, i64 %load6

  %store-select = select i1 %cmp1, i64 3, i64 4
  store i64 %store-select, i64* @var64, align 8
  ret i64 %select5
}

; FIXME: Use fmaxnum intrinsics to match what InstCombine creates for fcmp+select
; with fastmath on the select.
define float @fmaxv6() {
; GFX9-LABEL: @fmaxv6(
; GFX9-NEXT:    [[TMP1:%.*]] = load <2 x float>, <2 x float>* bitcast ([32 x float]* @farr to <2 x float>*), align 16
; GFX9-NEXT:    [[TMP2:%.*]] = extractelement <2 x float> [[TMP1]], i32 0
; GFX9-NEXT:    [[TMP3:%.*]] = extractelement <2 x float> [[TMP1]], i32 1
; GFX9-NEXT:    [[CMP1:%.*]] = fcmp fast ogt float [[TMP2]], [[TMP3]]
; GFX9-NEXT:    [[SELECT1:%.*]] = select i1 [[CMP1]], float [[TMP2]], float [[TMP3]]
; GFX9-NEXT:    [[LOAD3:%.*]] = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 2), align 8
; GFX9-NEXT:    [[CMP2:%.*]] = fcmp fast ogt float [[SELECT1]], [[LOAD3]]
; GFX9-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP2]], float [[SELECT1]], float [[LOAD3]]
; GFX9-NEXT:    [[LOAD4:%.*]] = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 3), align 4
; GFX9-NEXT:    [[CMP3:%.*]] = fcmp fast ogt float [[SELECT2]], [[LOAD4]]
; GFX9-NEXT:    [[SELECT3:%.*]] = select i1 [[CMP3]], float [[SELECT2]], float [[LOAD4]]
; GFX9-NEXT:    [[LOAD5:%.*]] = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 4), align 16
; GFX9-NEXT:    [[CMP4:%.*]] = fcmp fast ogt float [[SELECT3]], [[LOAD5]]
; GFX9-NEXT:    [[SELECT4:%.*]] = select i1 [[CMP4]], float [[SELECT3]], float [[LOAD5]]
; GFX9-NEXT:    [[LOAD6:%.*]] = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 5), align 4
; GFX9-NEXT:    [[CMP5:%.*]] = fcmp fast ogt float [[SELECT4]], [[LOAD6]]
; GFX9-NEXT:    [[SELECT5:%.*]] = select i1 [[CMP5]], float [[SELECT4]], float [[LOAD6]]
; GFX9-NEXT:    [[STORE_SELECT:%.*]] = select i1 [[CMP1]], float 3.000000e+00, float 4.000000e+00
; GFX9-NEXT:    store float [[STORE_SELECT]], float* @fvar, align 8
; GFX9-NEXT:    ret float [[SELECT5]]
;
  %load1 = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 0), align 16
  %load2 = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 1), align 4
  %cmp1 = fcmp fast ogt float %load1, %load2
  %select1 = select i1 %cmp1, float %load1, float %load2

  %load3 = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 2), align 8
  %cmp2 = fcmp fast ogt float %select1, %load3
  %select2 = select i1 %cmp2, float %select1, float %load3

  %load4 = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 3), align 4
  %cmp3 = fcmp fast ogt float %select2, %load4
  %select3 = select i1 %cmp3, float %select2, float %load4

  %load5 = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 4), align 16
  %cmp4 = fcmp fast ogt float %select3, %load5
  %select4 = select i1 %cmp4, float %select3, float %load5

  %load6 = load float, float* getelementptr inbounds ([32 x float], [32 x float]* @farr, i64 0, i64 5), align 4
  %cmp5 = fcmp fast ogt float %select4, %load6
  %select5 = select i1 %cmp5, float %select4, float %load6

  %store-select = select i1 %cmp1, float 3.0, float 4.0
  store float %store-select, float* @fvar, align 8
  ret float %select5
}

; FIXME: Use fmaxnum intrinsics to match what InstCombine creates for fcmp+select
; with fastmath on the select.
define double @dminv6() {
; GFX9-LABEL: @dminv6(
; GFX9-NEXT:    [[TMP1:%.*]] = load <2 x double>, <2 x double>* bitcast ([32 x double]* @darr to <2 x double>*), align 16
; GFX9-NEXT:    [[TMP2:%.*]] = extractelement <2 x double> [[TMP1]], i32 0
; GFX9-NEXT:    [[TMP3:%.*]] = extractelement <2 x double> [[TMP1]], i32 1
; GFX9-NEXT:    [[CMP1:%.*]] = fcmp fast olt double [[TMP2]], [[TMP3]]
; GFX9-NEXT:    [[SELECT1:%.*]] = select i1 [[CMP1]], double [[TMP2]], double [[TMP3]]
; GFX9-NEXT:    [[LOAD3:%.*]] = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 2), align 8
; GFX9-NEXT:    [[CMP2:%.*]] = fcmp fast olt double [[SELECT1]], [[LOAD3]]
; GFX9-NEXT:    [[SELECT2:%.*]] = select i1 [[CMP2]], double [[SELECT1]], double [[LOAD3]]
; GFX9-NEXT:    [[LOAD4:%.*]] = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 3), align 4
; GFX9-NEXT:    [[CMP3:%.*]] = fcmp fast olt double [[SELECT2]], [[LOAD4]]
; GFX9-NEXT:    [[SELECT3:%.*]] = select i1 [[CMP3]], double [[SELECT2]], double [[LOAD4]]
; GFX9-NEXT:    [[LOAD5:%.*]] = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 4), align 16
; GFX9-NEXT:    [[CMP4:%.*]] = fcmp fast olt double [[SELECT3]], [[LOAD5]]
; GFX9-NEXT:    [[SELECT4:%.*]] = select i1 [[CMP4]], double [[SELECT3]], double [[LOAD5]]
; GFX9-NEXT:    [[LOAD6:%.*]] = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 5), align 4
; GFX9-NEXT:    [[CMP5:%.*]] = fcmp fast olt double [[SELECT4]], [[LOAD6]]
; GFX9-NEXT:    [[SELECT5:%.*]] = select i1 [[CMP5]], double [[SELECT4]], double [[LOAD6]]
; GFX9-NEXT:    [[STORE_SELECT:%.*]] = select i1 [[CMP1]], double 3.000000e+00, double 4.000000e+00
; GFX9-NEXT:    store double [[STORE_SELECT]], double* @dvar, align 8
; GFX9-NEXT:    ret double [[SELECT5]]
;
  %load1 = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 0), align 16
  %load2 = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 1), align 4
  %cmp1 = fcmp fast olt double %load1, %load2
  %select1 = select i1 %cmp1, double %load1, double %load2

  %load3 = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 2), align 8
  %cmp2 = fcmp fast olt double %select1, %load3
  %select2 = select i1 %cmp2, double %select1, double %load3

  %load4 = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 3), align 4
  %cmp3 = fcmp fast olt double %select2, %load4
  %select3 = select i1 %cmp3, double %select2, double %load4

  %load5 = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 4), align 16
  %cmp4 = fcmp fast olt double %select3, %load5
  %select4 = select i1 %cmp4, double %select3, double %load5

  %load6 = load double, double* getelementptr inbounds ([32 x double], [32 x double]* @darr, i64 0, i64 5), align 4
  %cmp5 = fcmp fast olt double %select4, %load6
  %select5 = select i1 %cmp5, double %select4, double %load6

  %store-select = select i1 %cmp1, double 3.0, double 4.0
  store double %store-select, double* @dvar, align 8
  ret double %select5
}

define i32 @smax_wdiff_valuenum(i32, i32 %v1) {
; GFX9-LABEL: @smax_wdiff_valuenum(
; GFX9-NEXT:    [[VLOAD:%.*]] = load <2 x i32>, <2 x i32>* bitcast ([32 x i32]* @arr to <2 x i32>*), align 16
; GFX9-NEXT:    [[ELT1:%.*]] = extractelement <2 x i32> [[VLOAD]], i32 0
; GFX9-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[ELT1]], [[V1:%.*]]
; GFX9-NEXT:    [[EX0:%.*]] = extractelement <2 x i32> [[VLOAD]], i32 0
; GFX9-NEXT:    [[SELECT1:%.*]] = select i1 [[CMP1]], i32 [[EX0]], i32 [[V1]]
; GFX9-NEXT:    [[TMP2:%.*]] = load <4 x i32>, <4 x i32>* bitcast (i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 2) to <4 x i32>*), align 8
; GFX9-NEXT:    [[RDX_SHUF:%.*]] = shufflevector <4 x i32> [[TMP2]], <4 x i32> poison, <4 x i32> <i32 2, i32 3, i32 undef, i32 undef>
; GFX9-NEXT:    [[RDX_MINMAX_CMP:%.*]] = icmp sgt <4 x i32> [[TMP2]], [[RDX_SHUF]]
; GFX9-NEXT:    [[RDX_MINMAX_SELECT:%.*]] = select <4 x i1> [[RDX_MINMAX_CMP]], <4 x i32> [[TMP2]], <4 x i32> [[RDX_SHUF]]
; GFX9-NEXT:    [[RDX_SHUF1:%.*]] = shufflevector <4 x i32> [[RDX_MINMAX_SELECT]], <4 x i32> poison, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
; GFX9-NEXT:    [[RDX_MINMAX_CMP2:%.*]] = icmp sgt <4 x i32> [[RDX_MINMAX_SELECT]], [[RDX_SHUF1]]
; GFX9-NEXT:    [[RDX_MINMAX_SELECT3:%.*]] = select <4 x i1> [[RDX_MINMAX_CMP2]], <4 x i32> [[RDX_MINMAX_SELECT]], <4 x i32> [[RDX_SHUF1]]
; GFX9-NEXT:    [[TMP3:%.*]] = extractelement <4 x i32> [[RDX_MINMAX_SELECT3]], i32 0
; GFX9-NEXT:    [[OP_EXTRA:%.*]] = icmp sgt i32 [[TMP3]], [[SELECT1]]
; GFX9-NEXT:    [[OP_EXTRA4:%.*]] = select i1 [[OP_EXTRA]], i32 [[TMP3]], i32 [[SELECT1]]
; GFX9-NEXT:    [[STOREVAL:%.*]] = select i1 [[CMP1]], i32 3, i32 4
; GFX9-NEXT:    store i32 [[STOREVAL]], i32* @var, align 8
; GFX9-NEXT:    ret i32 [[OP_EXTRA4]]
;
  %vload = load <2 x i32>, <2 x i32>* bitcast ([32 x i32]* @arr to <2 x i32>*), align 16
  %elt1 = extractelement <2 x i32> %vload, i32 0
  %cmp1 = icmp sgt i32 %elt1, %v1
  %ex0 = extractelement <2 x i32> %vload, i32 0
  %select1 = select i1 %cmp1, i32 %ex0, i32 %v1

  %load3 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 2), align 8
  %cmp2 = icmp sgt i32 %select1, %load3
  %select2 = select i1 %cmp2, i32 %select1, i32 %load3

  %load4 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 3), align 4
  %cmp3 = icmp sgt i32 %select2, %load4
  %select3 = select i1 %cmp3, i32 %select2, i32 %load4

  %load5 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 4), align 16
  %cmp4 = icmp sgt i32 %select3, %load5
  %select4 = select i1 %cmp4, i32 %select3, i32 %load5

  %load6 = load i32, i32* getelementptr inbounds ([32 x i32], [32 x i32]* @arr, i64 0, i64 5), align 4
  %cmp5 = icmp sgt i32 %select4, %load6
  %select5 = select i1 %cmp5, i32 %select4, i32 %load6

  %storeval = select i1 %cmp1, i32 3, i32 4
  store i32 %storeval, i32* @var, align 8
  ret i32 %select5
}
