; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

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

; Signed zero, should not be converted
define double @t6(float %a) {
; CHECK-LABEL: @t6(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ult float [[A:%.*]], -0.000000e+00
; CHECK-NEXT:    [[TMP2:%.*]] = fpext float [[A]] to double
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], double [[TMP2]], double 0.000000e+00
; CHECK-NEXT:    ret double [[TMP3]]
;
  %1 = fcmp ult float %a, -0.0
  %2 = fpext float %a to double
  %3 = select i1 %1, double %2, double 0.0
  ret double %3
}

; Signed zero, should not be converted
define double @t7(float %a) {
; CHECK-LABEL: @t7(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ult float [[A:%.*]], 0.000000e+00
; CHECK-NEXT:    [[TMP2:%.*]] = fpext float [[A]] to double
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], double [[TMP2]], double -0.000000e+00
; CHECK-NEXT:    ret double [[TMP3]]
;
  %1 = fcmp ult float %a, 0.0
  %2 = fpext float %a to double
  %3 = select i1 %1, double %2, double -0.0
  ret double %3
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
; CHECK-NEXT:    [[DOTV:%.*]] = select i1 [[DOTINV]], float [[A]], float [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = fptosi float [[DOTV]] to i8
; CHECK-NEXT:    ret i8 [[TMP1]]
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
; CHECK-NEXT:    [[DOTV:%.*]] = select i1 [[DOTINV]], float [[A]], float [[B]]
; CHECK-NEXT:    [[TMP1:%.*]] = fptosi float [[DOTV]] to i8
; CHECK-NEXT:    ret i8 [[TMP1]]
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
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[DOTINV]], float 0.000000e+00, float [[A]]
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
; CHECK-NEXT:    [[TMP1:%.*]] = icmp sgt i32 [[X:%.*]], 2
; CHECK-NEXT:    [[SEL1:%.*]] = select i1 [[TMP1]], i32 [[X]], i32 2
; CHECK-NEXT:    [[TMP2:%.*]] = sitofp i32 [[SEL1]] to double
; CHECK-NEXT:    ret double [[TMP2]]
;
  %cmp = icmp sgt i32 %x, 2
  %cst = sitofp i32 %x to double
  %sel = select i1 %cmp, double %cst, double 2.0
  ret double %sel
}

