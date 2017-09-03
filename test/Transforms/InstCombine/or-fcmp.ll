; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i1 @fcmp_uno_nonzero(float %x, float %y) {
; CHECK-LABEL: @fcmp_uno_nonzero(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uno float %x, %y
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp1 = fcmp uno float %x, 1.0
  %cmp2 = fcmp uno float %y, 2.0
  %or = or i1 %cmp1, %cmp2
  ret i1 %or
}

define <3 x i1> @fcmp_uno_nonzero_vec(<3 x float> %x, <3 x float> %y) {
; CHECK-LABEL: @fcmp_uno_nonzero_vec(
; CHECK-NEXT:    [[CMP1:%.*]] = fcmp uno <3 x float> %x, <float 1.000000e+00, float 2.000000e+00, float 3.000000e+00>
; CHECK-NEXT:    [[CMP2:%.*]] = fcmp uno <3 x float> %y, <float 3.000000e+00, float 2.000000e+00, float 1.000000e+00>
; CHECK-NEXT:    [[OR:%.*]] = or <3 x i1> [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret <3 x i1> [[OR]]
;
  %cmp1 = fcmp uno <3 x float> %x, <float 1.0, float 2.0, float 3.0>
  %cmp2 = fcmp uno <3 x float> %y, <float 3.0, float 2.0, float 1.0>
  %or = or <3 x i1> %cmp1, %cmp2
  ret <3 x i1> %or
}

define i1 @auto_gen_0(double %a, double %b) {
; CHECK-LABEL: @auto_gen_0(
; CHECK-NEXT:    ret i1 false
;
  %cmp = fcmp false double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_1(double %a, double %b) {
; CHECK-LABEL: @auto_gen_1(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp oeq double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp oeq double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_2(double %a, double %b) {
; CHECK-LABEL: @auto_gen_2(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp oeq double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp oeq double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_3(double %a, double %b) {
; CHECK-LABEL: @auto_gen_3(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ogt double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp ogt double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_4(double %a, double %b) {
; CHECK-LABEL: @auto_gen_4(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp oge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ogt double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_5(double %a, double %b) {
; CHECK-LABEL: @auto_gen_5(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ogt double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ogt double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_6(double %a, double %b) {
; CHECK-LABEL: @auto_gen_6(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp oge double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp oge double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_7(double %a, double %b) {
; CHECK-LABEL: @auto_gen_7(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp oge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp oge double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_8(double %a, double %b) {
; CHECK-LABEL: @auto_gen_8(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp oge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp oge double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_9(double %a, double %b) {
; CHECK-LABEL: @auto_gen_9(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp oge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp oge double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_10(double %a, double %b) {
; CHECK-LABEL: @auto_gen_10(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp olt double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp olt double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_11(double %a, double %b) {
; CHECK-LABEL: @auto_gen_11(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ole double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp olt double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_12(double %a, double %b) {
; CHECK-LABEL: @auto_gen_12(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp one double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp olt double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_13(double %a, double %b) {
; CHECK-LABEL: @auto_gen_13(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp olt double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_14(double %a, double %b) {
; CHECK-LABEL: @auto_gen_14(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp olt double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp olt double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_15(double %a, double %b) {
; CHECK-LABEL: @auto_gen_15(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ole double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp ole double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_16(double %a, double %b) {
; CHECK-LABEL: @auto_gen_16(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ole double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ole double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_17(double %a, double %b) {
; CHECK-LABEL: @auto_gen_17(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ole double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_18(double %a, double %b) {
; CHECK-LABEL: @auto_gen_18(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ole double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_19(double %a, double %b) {
; CHECK-LABEL: @auto_gen_19(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ole double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ole double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_20(double %a, double %b) {
; CHECK-LABEL: @auto_gen_20(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ole double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ole double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_21(double %a, double %b) {
; CHECK-LABEL: @auto_gen_21(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp one double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp one double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_22(double %a, double %b) {
; CHECK-LABEL: @auto_gen_22(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp one double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_23(double %a, double %b) {
; CHECK-LABEL: @auto_gen_23(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp one double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp one double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_24(double %a, double %b) {
; CHECK-LABEL: @auto_gen_24(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp one double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_25(double %a, double %b) {
; CHECK-LABEL: @auto_gen_25(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp one double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp one double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_26(double %a, double %b) {
; CHECK-LABEL: @auto_gen_26(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp one double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_27(double %a, double %b) {
; CHECK-LABEL: @auto_gen_27(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp one double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp one double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_28(double %a, double %b) {
; CHECK-LABEL: @auto_gen_28(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp ord double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_29(double %a, double %b) {
; CHECK-LABEL: @auto_gen_29(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ord double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_30(double %a, double %b) {
; CHECK-LABEL: @auto_gen_30(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ord double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_31(double %a, double %b) {
; CHECK-LABEL: @auto_gen_31(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ord double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_32(double %a, double %b) {
; CHECK-LABEL: @auto_gen_32(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ord double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_33(double %a, double %b) {
; CHECK-LABEL: @auto_gen_33(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ord double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_34(double %a, double %b) {
; CHECK-LABEL: @auto_gen_34(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ord double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_35(double %a, double %b) {
; CHECK-LABEL: @auto_gen_35(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ord double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ord double %a, %b
  %cmp1 = fcmp ord double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_36(double %a, double %b) {
; CHECK-LABEL: @auto_gen_36(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ueq double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp ueq double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_37(double %a, double %b) {
; CHECK-LABEL: @auto_gen_37(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ueq double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ueq double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_38(double %a, double %b) {
; CHECK-LABEL: @auto_gen_38(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ueq double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_39(double %a, double %b) {
; CHECK-LABEL: @auto_gen_39(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ueq double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_40(double %a, double %b) {
; CHECK-LABEL: @auto_gen_40(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ueq double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_41(double %a, double %b) {
; CHECK-LABEL: @auto_gen_41(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ueq double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_42(double %a, double %b) {
; CHECK-LABEL: @auto_gen_42(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ueq double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_43(double %a, double %b) {
; CHECK-LABEL: @auto_gen_43(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ueq double %a, %b
  %cmp1 = fcmp ord double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_44(double %a, double %b) {
; CHECK-LABEL: @auto_gen_44(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ueq double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ueq double %a, %b
  %cmp1 = fcmp ueq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_45(double %a, double %b) {
; CHECK-LABEL: @auto_gen_45(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ugt double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_46(double %a, double %b) {
; CHECK-LABEL: @auto_gen_46(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_47(double %a, double %b) {
; CHECK-LABEL: @auto_gen_47(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ugt double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_48(double %a, double %b) {
; CHECK-LABEL: @auto_gen_48(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_49(double %a, double %b) {
; CHECK-LABEL: @auto_gen_49(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_50(double %a, double %b) {
; CHECK-LABEL: @auto_gen_50(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_51(double %a, double %b) {
; CHECK-LABEL: @auto_gen_51(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_52(double %a, double %b) {
; CHECK-LABEL: @auto_gen_52(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp ord double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_53(double %a, double %b) {
; CHECK-LABEL: @auto_gen_53(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp ueq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_54(double %a, double %b) {
; CHECK-LABEL: @auto_gen_54(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ugt double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ugt double %a, %b
  %cmp1 = fcmp ugt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_55(double %a, double %b) {
; CHECK-LABEL: @auto_gen_55(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_56(double %a, double %b) {
; CHECK-LABEL: @auto_gen_56(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_57(double %a, double %b) {
; CHECK-LABEL: @auto_gen_57(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_58(double %a, double %b) {
; CHECK-LABEL: @auto_gen_58(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_59(double %a, double %b) {
; CHECK-LABEL: @auto_gen_59(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_60(double %a, double %b) {
; CHECK-LABEL: @auto_gen_60(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_61(double %a, double %b) {
; CHECK-LABEL: @auto_gen_61(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_62(double %a, double %b) {
; CHECK-LABEL: @auto_gen_62(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp ord double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_63(double %a, double %b) {
; CHECK-LABEL: @auto_gen_63(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp ueq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_64(double %a, double %b) {
; CHECK-LABEL: @auto_gen_64(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp ugt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_65(double %a, double %b) {
; CHECK-LABEL: @auto_gen_65(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uge double %a, %b
  %cmp1 = fcmp uge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_66(double %a, double %b) {
; CHECK-LABEL: @auto_gen_66(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ult double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_67(double %a, double %b) {
; CHECK-LABEL: @auto_gen_67(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_68(double %a, double %b) {
; CHECK-LABEL: @auto_gen_68(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_69(double %a, double %b) {
; CHECK-LABEL: @auto_gen_69(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_70(double %a, double %b) {
; CHECK-LABEL: @auto_gen_70(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ult double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_71(double %a, double %b) {
; CHECK-LABEL: @auto_gen_71(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_72(double %a, double %b) {
; CHECK-LABEL: @auto_gen_72(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_73(double %a, double %b) {
; CHECK-LABEL: @auto_gen_73(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp ord double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_74(double %a, double %b) {
; CHECK-LABEL: @auto_gen_74(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp ueq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_75(double %a, double %b) {
; CHECK-LABEL: @auto_gen_75(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp ugt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_76(double %a, double %b) {
; CHECK-LABEL: @auto_gen_76(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp uge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_77(double %a, double %b) {
; CHECK-LABEL: @auto_gen_77(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ult double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ult double %a, %b
  %cmp1 = fcmp ult double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_78(double %a, double %b) {
; CHECK-LABEL: @auto_gen_78(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_79(double %a, double %b) {
; CHECK-LABEL: @auto_gen_79(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_80(double %a, double %b) {
; CHECK-LABEL: @auto_gen_80(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_81(double %a, double %b) {
; CHECK-LABEL: @auto_gen_81(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_82(double %a, double %b) {
; CHECK-LABEL: @auto_gen_82(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_83(double %a, double %b) {
; CHECK-LABEL: @auto_gen_83(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_84(double %a, double %b) {
; CHECK-LABEL: @auto_gen_84(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_85(double %a, double %b) {
; CHECK-LABEL: @auto_gen_85(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp ord double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_86(double %a, double %b) {
; CHECK-LABEL: @auto_gen_86(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp ueq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_87(double %a, double %b) {
; CHECK-LABEL: @auto_gen_87(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp ugt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_88(double %a, double %b) {
; CHECK-LABEL: @auto_gen_88(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp uge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_89(double %a, double %b) {
; CHECK-LABEL: @auto_gen_89(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp ult double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_90(double %a, double %b) {
; CHECK-LABEL: @auto_gen_90(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp ule double %a, %b
  %cmp1 = fcmp ule double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_91(double %a, double %b) {
; CHECK-LABEL: @auto_gen_91(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_92(double %a, double %b) {
; CHECK-LABEL: @auto_gen_92(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_93(double %a, double %b) {
; CHECK-LABEL: @auto_gen_93(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_94(double %a, double %b) {
; CHECK-LABEL: @auto_gen_94(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_95(double %a, double %b) {
; CHECK-LABEL: @auto_gen_95(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_96(double %a, double %b) {
; CHECK-LABEL: @auto_gen_96(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_97(double %a, double %b) {
; CHECK-LABEL: @auto_gen_97(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_98(double %a, double %b) {
; CHECK-LABEL: @auto_gen_98(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp ord double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_99(double %a, double %b) {
; CHECK-LABEL: @auto_gen_99(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp ueq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_100(double %a, double %b) {
; CHECK-LABEL: @auto_gen_100(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp ugt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_101(double %a, double %b) {
; CHECK-LABEL: @auto_gen_101(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp uge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_102(double %a, double %b) {
; CHECK-LABEL: @auto_gen_102(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp ult double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_103(double %a, double %b) {
; CHECK-LABEL: @auto_gen_103(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp ule double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_104(double %a, double %b) {
; CHECK-LABEL: @auto_gen_104(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp une double %a, %b
  %cmp1 = fcmp une double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_105(double %a, double %b) {
; CHECK-LABEL: @auto_gen_105(
; CHECK-NEXT:    [[CMP:%.*]] = fcmp uno double %a, %b
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_106(double %a, double %b) {
; CHECK-LABEL: @auto_gen_106(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ueq double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_107(double %a, double %b) {
; CHECK-LABEL: @auto_gen_107(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ugt double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_108(double %a, double %b) {
; CHECK-LABEL: @auto_gen_108(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_109(double %a, double %b) {
; CHECK-LABEL: @auto_gen_109(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ult double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_110(double %a, double %b) {
; CHECK-LABEL: @auto_gen_110(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_111(double %a, double %b) {
; CHECK-LABEL: @auto_gen_111(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_112(double %a, double %b) {
; CHECK-LABEL: @auto_gen_112(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp ord double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_113(double %a, double %b) {
; CHECK-LABEL: @auto_gen_113(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ueq double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp ueq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_114(double %a, double %b) {
; CHECK-LABEL: @auto_gen_114(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ugt double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp ugt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_115(double %a, double %b) {
; CHECK-LABEL: @auto_gen_115(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uge double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp uge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_116(double %a, double %b) {
; CHECK-LABEL: @auto_gen_116(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ult double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp ult double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_117(double %a, double %b) {
; CHECK-LABEL: @auto_gen_117(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp ule double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp ule double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_118(double %a, double %b) {
; CHECK-LABEL: @auto_gen_118(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp une double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp une double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_119(double %a, double %b) {
; CHECK-LABEL: @auto_gen_119(
; CHECK-NEXT:    [[TMP1:%.*]] = fcmp uno double %a, %b
; CHECK-NEXT:    ret i1 [[TMP1]]
;
  %cmp = fcmp uno double %a, %b
  %cmp1 = fcmp uno double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_120(double %a, double %b) {
; CHECK-LABEL: @auto_gen_120(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp false double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_121(double %a, double %b) {
; CHECK-LABEL: @auto_gen_121(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp oeq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_122(double %a, double %b) {
; CHECK-LABEL: @auto_gen_122(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp ogt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_123(double %a, double %b) {
; CHECK-LABEL: @auto_gen_123(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp oge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_124(double %a, double %b) {
; CHECK-LABEL: @auto_gen_124(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp olt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_125(double %a, double %b) {
; CHECK-LABEL: @auto_gen_125(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp ole double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_126(double %a, double %b) {
; CHECK-LABEL: @auto_gen_126(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp one double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_127(double %a, double %b) {
; CHECK-LABEL: @auto_gen_127(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp ord double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_128(double %a, double %b) {
; CHECK-LABEL: @auto_gen_128(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp ueq double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_129(double %a, double %b) {
; CHECK-LABEL: @auto_gen_129(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp ugt double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_130(double %a, double %b) {
; CHECK-LABEL: @auto_gen_130(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp uge double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_131(double %a, double %b) {
; CHECK-LABEL: @auto_gen_131(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp ult double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_132(double %a, double %b) {
; CHECK-LABEL: @auto_gen_132(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp ule double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_133(double %a, double %b) {
; CHECK-LABEL: @auto_gen_133(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp une double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_134(double %a, double %b) {
; CHECK-LABEL: @auto_gen_134(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp uno double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}

define i1 @auto_gen_135(double %a, double %b) {
; CHECK-LABEL: @auto_gen_135(
; CHECK-NEXT:    ret i1 true
;
  %cmp = fcmp true double %a, %b
  %cmp1 = fcmp true double %a, %b
  %retval = or i1 %cmp, %cmp1
  ret i1 %retval
}
