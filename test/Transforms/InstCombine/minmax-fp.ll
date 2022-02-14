; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine < %s | FileCheck %s

; This is the canonical form for a type-changing min/max.
define double @t1(float %a) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp oge float [[A:%.*]], 5.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[DOTINV]], float 5.000000e+00, float [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = fpext float [[TMP1]] to double
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = fcmp ult float %a, 5.0
  %2 = select i1 %1, float %a, float 5.0
  %3 = fpext float %2 to double
  ret double %3
}

; Check this is converted into canonical form, as above.
define double @t2(float %a) {
; CHECK-LABEL: @t2(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp oge float [[A:%.*]], 5.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[DOTINV]], float 5.000000e+00, float [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = fpext float [[TMP1]] to double
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = fcmp ult float %a, 5.0
  %2 = fpext float %a to double
  %3 = select i1 %1, double %2, double 5.0
  ret double %3
}

; Same again, with trunc.
define float @t4(double %a) {
; CHECK-LABEL: @t4(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp oge double [[A:%.*]], 5.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[DOTINV]], double 5.000000e+00, double [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = fptrunc double [[TMP1]] to float
; CHECK-NEXT:    ret float [[TMP2]]
;
  %1 = fcmp ult double %a, 5.0
  %2 = fptrunc double %a to float
  %3 = select i1 %1, float %2, float 5.0
  ret float %3
}

; different values, should not be converted.
define double @t5(float %a) {
; CHECK-LABEL: @t5(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ult float [[A:%.*]], 5.000000e+00
; CHECK-NEXT:    [[TMP2:%.*]] = fpext float [[A]] to double
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], double [[TMP2]], double 5.001000e+00
; CHECK-NEXT:    ret double [[TMP3]]
;
  %1 = fcmp ult float %a, 5.0
  %2 = fpext float %a to double
  %3 = select i1 %1, double %2, double 5.001
  ret double %3
}

; From IEEE754: "Comparisons shall ignore the sign of zero (so +0 = -0)."
; So the compare constant may be treated as +0.0, and we sink the fpext.

define double @t6(float %a) {
; CHECK-LABEL: @t6(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp oge float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[DOTINV]], float 0.000000e+00, float [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = fpext float [[TMP1]] to double
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = fcmp ult float %a, -0.0
  %2 = fpext float %a to double
  %3 = select i1 %1, double %2, double 0.0
  ret double %3
}

; From IEEE754: "Comparisons shall ignore the sign of zero (so +0 = -0)."
; So the compare constant may be treated as -0.0, and we sink the fpext.

define double @t7(float %a) {
; CHECK-LABEL: @t7(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp oge float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[DOTINV]], float -0.000000e+00, float [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = fpext float [[TMP1]] to double
; CHECK-NEXT:    ret double [[TMP2]]
;
  %1 = fcmp ult float %a, 0.0
  %2 = fpext float %a to double
  %3 = select i1 %1, double %2, double -0.0
  ret double %3
}

; min(min(x, 0.0), 0.0) --> min(x, 0.0)

define float @fmin_fmin_zero_mismatch(float %x) {
; CHECK-LABEL: @fmin_fmin_zero_mismatch(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp olt float [[X:%.*]], 0.000000e+00
; CHECK-NEXT:    [[MIN2:%.*]] = select i1 [[TMP1]], float [[X]], float 0.000000e+00
; CHECK-NEXT:    ret float [[MIN2]]
;
  %cmp1 = fcmp olt float %x, -0.0
  %min1 = select i1 %cmp1, float %x, float 0.0
  %cmp2 = fcmp olt float %min1, 0.0
  %min2 = select i1 %cmp2, float %min1, float 0.0
  ret float %min2
}

; max(max(x, -0.0), -0.0) --> max(x, -0.0)

define float @fmax_fmax_zero_mismatch(float %x) {
; CHECK-LABEL: @fmax_fmax_zero_mismatch(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ogt float [[X:%.*]], -0.000000e+00
; CHECK-NEXT:    [[MAX11:%.*]] = select i1 [[TMP1]], float [[X]], float -0.000000e+00
; CHECK-NEXT:    ret float [[MAX11]]
;
  %cmp1 = fcmp ogt float %x, 0.0
  %max1 = select i1 %cmp1, float %x, float -0.0
  %cmp2 = fcmp ogt float 0.0, %max1
  %max2 = select i1 %cmp2, float -0.0, float %max1
  ret float %max2
}

define i64 @t8(float %a) {
; CHECK-LABEL: @t8(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp oge float [[A:%.*]], 5.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[DOTINV]], float 5.000000e+00, float [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = fptoui float [[TMP1]] to i64
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %1 = fcmp ult float %a, 5.0
  %2 = fptoui float %a to i64
  %3 = select i1 %1, i64 %2, i64 5
  ret i64 %3
}

define i8 @t9(float %a) {
; CHECK-LABEL: @t9(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp oge float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[DOTINV]], float 0.000000e+00, float [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = fptosi float [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %1 = fcmp ult float %a, 0.0
  %2 = fptosi float %a to i8
  %3 = select i1 %1, i8 %2, i8 0
  ret i8 %3
}

  ; Either operand could be NaN, but fast modifier applied.
define i8 @t11(float %a, float %b) {
; CHECK-LABEL: @t11(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp fast oge float [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select fast i1 [[DOTINV]], float [[A]], float [[B]]
; CHECK-NEXT:    [[TMP2:%.*]] = fptosi float [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %1 = fcmp fast ult float %b, %a
  %2 = fptosi float %a to i8
  %3 = fptosi float %b to i8
  %4 = select i1 %1, i8 %3, i8 %2
  ret i8 %4
}

; Either operand could be NaN, but nnan modifier applied.
define i8 @t12(float %a, float %b) {
; CHECK-LABEL: @t12(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp nnan oge float [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select nnan i1 [[DOTINV]], float [[A]], float [[B]]
; CHECK-NEXT:    [[TMP2:%.*]] = fptosi float [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %1 = fcmp nnan ult float %b, %a
  %2 = fptosi float %a to i8
  %3 = fptosi float %b to i8
  %4 = select i1 %1, i8 %3, i8 %2
  ret i8 %4
}

; Float and int values do not match.
define i8 @t13(float %a) {
; CHECK-LABEL: @t13(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ult float [[A:%.*]], 1.500000e+00
; CHECK-NEXT:    [[TMP2:%.*]] = fptosi float [[A]] to i8
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i8 [[TMP2]], i8 1
; CHECK-NEXT:    ret i8 [[TMP3]]
;
  %1 = fcmp ult float %a, 1.5
  %2 = fptosi float %a to i8
  %3 = select i1 %1, i8 %2, i8 1
  ret i8 %3
}

; %a could be -0.0, but it doesn't matter because the conversion to int is the same for 0.0 or -0.0.
define i8 @t14(float %a) {
; CHECK-LABEL: @t14(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp oge float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[DOTINV]], float 0.000000e+00, float [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = fptosi float [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %1 = fcmp ule float %a, 0.0
  %2 = fptosi float %a to i8
  %3 = select i1 %1, i8 %2, i8 0
  ret i8 %3
}

define i8 @t14_commute(float %a) {
; CHECK-LABEL: @t14_commute(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ogt float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], float [[A]], float 0.000000e+00
; CHECK-NEXT:    [[TMP3:%.*]] = fptosi float [[TMP2]] to i8
; CHECK-NEXT:    ret i8 [[TMP3]]
;
  %1 = fcmp ule float %a, 0.0
  %2 = fptosi float %a to i8
  %3 = select i1 %1, i8 0, i8 %2
  ret i8 %3
}

define i8 @t15(float %a) {
; CHECK-LABEL: @t15(
; CHECK-NEXT:    [[DOTINV:%.*]] = fcmp nsz oge float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = select nsz i1 [[DOTINV]], float 0.000000e+00, float [[A]]
; CHECK-NEXT:    [[TMP2:%.*]] = fptosi float [[TMP1]] to i8
; CHECK-NEXT:    ret i8 [[TMP2]]
;
  %1 = fcmp nsz ule float %a, 0.0
  %2 = fptosi float %a to i8
  %3 = select i1 %1, i8 %2, i8 0
  ret i8 %3
}

define double @t16(i32 %x) {
; CHECK-LABEL: @t16(
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[X:%.*]], 0
; CHECK-NEXT:    [[CST:%.*]] = sitofp i32 [[X]] to double
; CHECK-NEXT:    [[SEL:%.*]] = select i1 [[CMP]], double [[CST]], double 5.000000e-01
; CHECK-NEXT:    ret double [[SEL]]
;
  %cmp = icmp sgt i32 %x, 0
  %cst = sitofp i32 %x to double
  %sel = select i1 %cmp, double %cst, double 5.000000e-01
  ret double %sel
}

define double @t17(i32 %x) {
; CHECK-LABEL: @t17(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.smax.i32(i32 [[X:%.*]], i32 2)
; CHECK-NEXT:    [[TMP2:%.*]] = sitofp i32 [[TMP1]] to double
; CHECK-NEXT:    ret double [[TMP2]]
;
  %cmp = icmp sgt i32 %x, 2
  %cst = sitofp i32 %x to double
  %sel = select i1 %cmp, double %cst, double 2.0
  ret double %sel
}

define float @fneg_fmax(float %x, float %y) {
; CHECK-LABEL: @fneg_fmax(
; CHECK-NEXT:    [[COND:%.*]] = fcmp nnan olt float [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[MAX_V:%.*]] = select i1 [[COND]], float [[X]], float [[Y]]
; CHECK-NEXT:    [[MAX:%.*]] = fneg float [[MAX_V]]
; CHECK-NEXT:    ret float [[MAX]]
;
  %n1 = fneg float %x
  %n2 = fneg float %y
  %cond = fcmp nnan ogt float %n1, %n2
  %max = select i1 %cond, float %n1, float %n2
  ret float %max
}

define <2 x float> @fsub_fmax(<2 x float> %x, <2 x float> %y) {
; CHECK-LABEL: @fsub_fmax(
; CHECK-NEXT:    [[COND_INV:%.*]] = fcmp nnan nsz ogt <2 x float> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select nnan nsz <2 x i1> [[COND_INV]], <2 x float> [[Y]], <2 x float> [[X]]
; CHECK-NEXT:    [[MAX:%.*]] = fneg <2 x float> [[TMP1]]
; CHECK-NEXT:    ret <2 x float> [[MAX]]
;
  %n1 = fsub <2 x float> <float -0.0, float -0.0>, %x
  %n2 = fsub <2 x float> <float -0.0, float -0.0>, %y
  %cond = fcmp nsz nnan uge <2 x float> %n1, %n2
  %max = select <2 x i1> %cond, <2 x float> %n1, <2 x float> %n2
  ret <2 x float> %max
}

define <2 x double> @fsub_fmin(<2 x double> %x, <2 x double> %y) {
; CHECK-LABEL: @fsub_fmin(
; CHECK-NEXT:    [[COND:%.*]] = fcmp nnan ogt <2 x double> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[MAX_V:%.*]] = select <2 x i1> [[COND]], <2 x double> [[X]], <2 x double> [[Y]]
; CHECK-NEXT:    [[MAX:%.*]] = fneg <2 x double> [[MAX_V]]
; CHECK-NEXT:    ret <2 x double> [[MAX]]
;
  %n1 = fsub <2 x double> <double -0.0, double -0.0>, %x
  %n2 = fsub <2 x double> <double -0.0, double -0.0>, %y
  %cond = fcmp nnan olt <2 x double> %n1, %n2
  %max = select <2 x i1> %cond, <2 x double> %n1, <2 x double> %n2
  ret <2 x double> %max
}

define double @fneg_fmin(double %x, double %y) {
; CHECK-LABEL: @fneg_fmin(
; CHECK-NEXT:    [[COND_INV:%.*]] = fcmp nnan nsz olt double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = select nnan nsz i1 [[COND_INV]], double [[Y]], double [[X]]
; CHECK-NEXT:    [[MAX:%.*]] = fneg double [[TMP1]]
; CHECK-NEXT:    ret double [[MAX]]
;
  %n1 = fneg double %x
  %n2 = fneg double %y
  %cond = fcmp nsz nnan ule double %n1, %n2
  %max = select i1 %cond, double %n1, double %n2
  ret double %max
}

define float @maxnum_ogt_fmf_on_select(float %a, float %b) {
; CHECK-LABEL: @maxnum_ogt_fmf_on_select(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz float @llvm.maxnum.f32(float [[A:%.*]], float [[B:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %cond = fcmp ogt float %a, %b
  %f = select nnan nsz i1 %cond, float %a, float %b
  ret float %f
}

define <2 x float> @maxnum_oge_fmf_on_select(<2 x float> %a, <2 x float> %b) {
; CHECK-LABEL: @maxnum_oge_fmf_on_select(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan ninf nsz <2 x float> @llvm.maxnum.v2f32(<2 x float> [[A:%.*]], <2 x float> [[B:%.*]])
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %cond = fcmp oge <2 x float> %a, %b
  %f = select ninf nnan nsz <2 x i1> %cond, <2 x float> %a, <2 x float> %b
  ret <2 x float> %f
}

define float @maxnum_ogt_fmf_on_fcmp(float %a, float %b) {
; CHECK-LABEL: @maxnum_ogt_fmf_on_fcmp(
; CHECK-NEXT:    [[COND:%.*]] = fcmp nnan nsz ogt float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[F:%.*]] = select i1 [[COND]], float [[A]], float [[B]]
; CHECK-NEXT:    ret float [[F]]
;
  %cond = fcmp nnan nsz ogt float %a, %b
  %f = select i1 %cond, float %a, float %b
  ret float %f
}

define <2 x float> @maxnum_oge_fmf_on_fcmp(<2 x float> %a, <2 x float> %b) {
; CHECK-LABEL: @maxnum_oge_fmf_on_fcmp(
; CHECK-NEXT:    [[COND:%.*]] = fcmp nnan ninf nsz oge <2 x float> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[F:%.*]] = select <2 x i1> [[COND]], <2 x float> [[A]], <2 x float> [[B]]
; CHECK-NEXT:    ret <2 x float> [[F]]
;
  %cond = fcmp ninf nnan nsz oge <2 x float> %a, %b
  %f = select <2 x i1> %cond, <2 x float> %a, <2 x float> %b
  ret <2 x float> %f
}

define float @maxnum_no_nsz(float %a, float %b) {
; CHECK-LABEL: @maxnum_no_nsz(
; CHECK-NEXT:    [[COND:%.*]] = fcmp ogt float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[F:%.*]] = select nnan i1 [[COND]], float [[A]], float [[B]]
; CHECK-NEXT:    ret float [[F]]
;
  %cond = fcmp ogt float %a, %b
  %f = select nnan i1 %cond, float %a, float %b
  ret float %f
}

define float @maxnum_no_nnan(float %a, float %b) {
; CHECK-LABEL: @maxnum_no_nnan(
; CHECK-NEXT:    [[COND:%.*]] = fcmp oge float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[F:%.*]] = select nsz i1 [[COND]], float [[A]], float [[B]]
; CHECK-NEXT:    ret float [[F]]
;
  %cond = fcmp oge float %a, %b
  %f = select nsz i1 %cond, float %a, float %b
  ret float %f
}

define float @minnum_olt_fmf_on_select(float %a, float %b) {
; CHECK-LABEL: @minnum_olt_fmf_on_select(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan nsz float @llvm.minnum.f32(float [[A:%.*]], float [[B:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %cond = fcmp olt float %a, %b
  %f = select nnan nsz i1 %cond, float %a, float %b
  ret float %f
}

define <2 x float> @minnum_ole_fmf_on_select(<2 x float> %a, <2 x float> %b) {
; CHECK-LABEL: @minnum_ole_fmf_on_select(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan ninf nsz <2 x float> @llvm.minnum.v2f32(<2 x float> [[A:%.*]], <2 x float> [[B:%.*]])
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %cond = fcmp ole <2 x float> %a, %b
  %f = select ninf nnan nsz <2 x i1> %cond, <2 x float> %a, <2 x float> %b
  ret <2 x float> %f
}

define float @minnum_olt_fmf_on_fcmp(float %a, float %b) {
; CHECK-LABEL: @minnum_olt_fmf_on_fcmp(
; CHECK-NEXT:    [[COND:%.*]] = fcmp nnan nsz olt float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[F:%.*]] = select i1 [[COND]], float [[A]], float [[B]]
; CHECK-NEXT:    ret float [[F]]
;
  %cond = fcmp nnan nsz olt float %a, %b
  %f = select i1 %cond, float %a, float %b
  ret float %f
}

define <2 x float> @minnum_ole_fmf_on_fcmp(<2 x float> %a, <2 x float> %b) {
; CHECK-LABEL: @minnum_ole_fmf_on_fcmp(
; CHECK-NEXT:    [[COND:%.*]] = fcmp nnan ninf nsz ole <2 x float> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[F:%.*]] = select <2 x i1> [[COND]], <2 x float> [[A]], <2 x float> [[B]]
; CHECK-NEXT:    ret <2 x float> [[F]]
;
  %cond = fcmp ninf nnan nsz ole <2 x float> %a, %b
  %f = select <2 x i1> %cond, <2 x float> %a, <2 x float> %b
  ret <2 x float> %f
}

define float @minnum_no_nsz(float %a, float %b) {
; CHECK-LABEL: @minnum_no_nsz(
; CHECK-NEXT:    [[COND:%.*]] = fcmp olt float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[F:%.*]] = select nnan i1 [[COND]], float [[A]], float [[B]]
; CHECK-NEXT:    ret float [[F]]
;
  %cond = fcmp olt float %a, %b
  %f = select nnan i1 %cond, float %a, float %b
  ret float %f
}

define float @minnum_no_nnan(float %a, float %b) {
; CHECK-LABEL: @minnum_no_nnan(
; CHECK-NEXT:    [[COND:%.*]] = fcmp ole float [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[F:%.*]] = select nsz i1 [[COND]], float [[A]], float [[B]]
; CHECK-NEXT:    ret float [[F]]
;
  %cond = fcmp ole float %a, %b
  %f = select nsz i1 %cond, float %a, float %b
  ret float %f
}
