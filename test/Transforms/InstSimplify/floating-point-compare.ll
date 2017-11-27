; NOTE: Assertions have been autogenerated by update_test_checks.py
; RUN: opt < %s -instsimplify -S | FileCheck %s

; Infinity

define i1 @inf0(double %arg) {
; CHECK-LABEL: @inf0(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp ogt double %arg, 0x7FF0000000000000
  ret i1 %tmp
}

define i1 @inf1(double %arg) {
; CHECK-LABEL: @inf1(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp ule double %arg, 0x7FF0000000000000
  ret i1 %tmp
}

; Negative infinity

define i1 @ninf0(double %arg) {
; CHECK-LABEL: @ninf0(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp olt double %arg, 0xFFF0000000000000
  ret i1 %tmp
}

define i1 @ninf1(double %arg) {
; CHECK-LABEL: @ninf1(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp uge double %arg, 0xFFF0000000000000
  ret i1 %tmp
}

; NaNs

define i1 @nan0(double %arg) {
; CHECK-LABEL: @nan0(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp ord double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan1(double %arg) {
; CHECK-LABEL: @nan1(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp oeq double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan2(double %arg) {
; CHECK-LABEL: @nan2(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp olt double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan3(double %arg) {
; CHECK-LABEL: @nan3(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp uno double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan4(double %arg) {
; CHECK-LABEL: @nan4(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp une double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nan5(double %arg) {
; CHECK-LABEL: @nan5(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp ult double %arg, 0x7FF00000FFFFFFFF
  ret i1 %tmp
}

; Negative NaN.

define i1 @nnan0(double %arg) {
; CHECK-LABEL: @nnan0(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp ord double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan1(double %arg) {
; CHECK-LABEL: @nnan1(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp oeq double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan2(double %arg) {
; CHECK-LABEL: @nnan2(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp olt double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan3(double %arg) {
; CHECK-LABEL: @nnan3(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp uno double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan4(double %arg) {
; CHECK-LABEL: @nnan4(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp une double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

define i1 @nnan5(double %arg) {
; CHECK-LABEL: @nnan5(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp ult double %arg, 0xFFF00000FFFFFFFF
  ret i1 %tmp
}

; Negative zero.

define i1 @nzero0() {
; CHECK-LABEL: @nzero0(
; CHECK-NEXT:    ret i1 true
;
  %tmp = fcmp oeq double 0.0, -0.0
  ret i1 %tmp
}

define i1 @nzero1() {
; CHECK-LABEL: @nzero1(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp ogt double 0.0, -0.0
  ret i1 %tmp
}

; No enlightenment here.

define i1 @one_with_self(double %arg) {
; CHECK-LABEL: @one_with_self(
; CHECK-NEXT:    ret i1 false
;
  %tmp = fcmp one double %arg, %arg
  ret i1 %tmp
}

; These tests choose arbitrarily between float and double,
; and between uge and olt, to give reasonble coverage
; without combinatorial explosion.

declare float @llvm.fabs.f32(float)
declare double @llvm.fabs.f64(double)
declare <2 x double> @llvm.fabs.v2f64(<2 x double>)
declare float @llvm.sqrt.f32(float)
declare double @llvm.powi.f64(double,i32)
declare float @llvm.exp.f32(float)
declare float @llvm.minnum.f32(float, float)
declare float @llvm.maxnum.f32(float, float)
declare double @llvm.exp2.f64(double)
declare float @llvm.fma.f32(float,float,float)

declare void @expect_equal(i1,i1)

define i1 @orderedLessZeroTree(float,float,float,float) {
; CHECK-LABEL: @orderedLessZeroTree(
; CHECK-NEXT:    ret i1 true
;
  %square = fmul float %0, %0
  %abs = call float @llvm.fabs.f32(float %1)
  %sqrt = call float @llvm.sqrt.f32(float %2)
  %fma = call float @llvm.fma.f32(float %3, float %3, float %sqrt)
  %div = fdiv float %square, %abs
  %rem = frem float %sqrt, %fma
  %add = fadd float %div, %rem
  %uge = fcmp uge float %add, 0.000000e+00
  ret i1 %uge
}

define i1 @orderedLessZeroExpExt(float) {
; CHECK-LABEL: @orderedLessZeroExpExt(
; CHECK-NEXT:    ret i1 true
;
  %a = call float @llvm.exp.f32(float %0)
  %b = fpext float %a to double
  %uge = fcmp uge double %b, 0.000000e+00
  ret i1 %uge
}

define i1 @orderedLessZeroExp2Trunc(double) {
; CHECK-LABEL: @orderedLessZeroExp2Trunc(
; CHECK-NEXT:    ret i1 false
;
  %a = call double @llvm.exp2.f64(double %0)
  %b = fptrunc double %a to float
  %olt = fcmp olt float %b, 0.000000e+00
  ret i1 %olt
}

define i1 @orderedLessZeroPowi(double,double) {
; CHECK-LABEL: @orderedLessZeroPowi(
; CHECK-NEXT:    ret i1 false
;
  ; Even constant exponent
  %a = call double @llvm.powi.f64(double %0, i32 2)
  %square = fmul double %1, %1
  ; Odd constant exponent with provably non-negative base
  %b = call double @llvm.powi.f64(double %square, i32 3)
  %c = fadd double %a, %b
  %olt = fcmp olt double %b, 0.000000e+00
  ret i1 %olt
}

define i1 @orderedLessZeroUIToFP(i32) {
; CHECK-LABEL: @orderedLessZeroUIToFP(
; CHECK-NEXT:    ret i1 true
;
  %a = uitofp i32 %0 to float
  %uge = fcmp uge float %a, 0.000000e+00
  ret i1 %uge
}

define i1 @orderedLessZeroSelect(float, float) {
; CHECK-LABEL: @orderedLessZeroSelect(
; CHECK-NEXT:    ret i1 true
;
  %a = call float @llvm.exp.f32(float %0)
  %b = call float @llvm.fabs.f32(float %1)
  %c = fcmp olt float %0, %1
  %d = select i1 %c, float %a, float %b
  %e = fadd float %d, 1.0
  %uge = fcmp uge float %e, 0.000000e+00
  ret i1 %uge
}

define i1 @orderedLessZeroMinNum(float, float) {
; CHECK-LABEL: @orderedLessZeroMinNum(
; CHECK-NEXT:    ret i1 true
;
  %a = call float @llvm.exp.f32(float %0)
  %b = call float @llvm.fabs.f32(float %1)
  %c = call float @llvm.minnum.f32(float %a, float %b)
  %uge = fcmp uge float %c, 0.000000e+00
  ret i1 %uge
}

define i1 @orderedLessZeroMaxNum(float, float) {
; CHECK-LABEL: @orderedLessZeroMaxNum(
; CHECK-NEXT:    ret i1 true
;
  %a = call float @llvm.exp.f32(float %0)
  %b = call float @llvm.maxnum.f32(float %a, float %1)
  %uge = fcmp uge float %b, 0.000000e+00
  ret i1 %uge
}

define i1 @known_positive_olt_with_negative_constant(double %a) {
; CHECK-LABEL: @known_positive_olt_with_negative_constant(
; CHECK-NEXT:    [[CALL:%.*]] = call double @llvm.fabs.f64(double %a)
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt double [[CALL]], -1.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp olt double %call, -1.0
  ret i1 %cmp
}

define <2 x i1> @known_positive_ole_with_negative_constant_splat_vec(<2 x double> %a) {
; CHECK-LABEL: @known_positive_ole_with_negative_constant_splat_vec(
; CHECK-NEXT:    [[CALL:%.*]] = call <2 x double> @llvm.fabs.v2f64(<2 x double> %a)
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ole <2 x double> [[CALL]], <double -2.000000e+00, double -2.000000e+00>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %call = call <2 x double> @llvm.fabs.v2f64(<2 x double> %a)
  %cmp = fcmp ole <2 x double> %call, <double -2.0, double -2.0>
  ret <2 x i1> %cmp
}

define i1 @known_positive_ugt_with_negative_constant(double %a) {
; CHECK-LABEL: @known_positive_ugt_with_negative_constant(
; CHECK-NEXT:    [[CALL:%.*]] = call double @llvm.fabs.f64(double %a)
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ugt double [[CALL]], -3.000000e+00
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %call = call double @llvm.fabs.f64(double %a)
  %cmp = fcmp ugt double %call, -3.0
  ret i1 %cmp
}

define <2 x i1> @known_positive_uge_with_negative_constant_splat_vec(<2 x double> %a) {
; CHECK-LABEL: @known_positive_uge_with_negative_constant_splat_vec(
; CHECK-NEXT:    [[CALL:%.*]] = call <2 x double> @llvm.fabs.v2f64(<2 x double> %a)
; CHECK-NEXT:    [[CMP:%.*]] = fcmp uge <2 x double> [[CALL]], <double -4.000000e+00, double -4.000000e+00>
; CHECK-NEXT:    ret <2 x i1> [[CMP]]
;
  %call = call <2 x double> @llvm.fabs.v2f64(<2 x double> %a)
  %cmp = fcmp uge <2 x double> %call, <double -4.0, double -4.0>
  ret <2 x i1> %cmp
}

define i1 @nonans1(double %in1, double %in2) {
; CHECK-LABEL: @nonans1(
; CHECK-NEXT:    ret i1 false
;
  %cmp = fcmp nnan uno double %in1, %in2
  ret i1 %cmp
}

define i1 @nonans2(double %in1, double %in2) {
; CHECK-LABEL: @nonans2(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp nnan ord double %in1, %in2
  ret i1 %cmp
}

define <2 x i1> @orderedCompareWithNaNVector(<2 x double> %A) {
; CHECK-LABEL: @orderedCompareWithNaNVector(
; CHECK-NEXT:    ret <2 x i1> zeroinitializer
;
  %cmp = fcmp olt <2 x double> %A, <double 0xFFFFFFFFFFFFFFFF, double 0xFFFFFFFFFFFFFFFF>
  ret <2 x i1> %cmp
}

