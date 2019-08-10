; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -reassociate -gvn -S < %s | FileCheck %s

; (x + 0.1234 * y) * (x + -0.1234 * y) -> (x + 0.1234 * y) * (x - 0.1234 * y)
define double @test1(double %x, double %y) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[Y:%.*]], 1.234000e-01
; CHECK-NEXT:    [[ADD:%.*]] = fadd double [[X:%.*]], [[MUL]]
; CHECK-NEXT:    [[ADD21:%.*]] = fsub double [[X]], [[MUL]]
; CHECK-NEXT:    [[MUL3:%.*]] = fmul double [[ADD]], [[ADD21]]
; CHECK-NEXT:    ret double [[MUL3]]
;
  %mul = fmul double 1.234000e-01, %y
  %add = fadd double %mul, %x
  %mul1 = fmul double -1.234000e-01, %y
  %add2 = fadd double %mul1, %x
  %mul3 = fmul double %add, %add2
  ret double %mul3
}

; (x + -0.1234 * y) * (x + -0.1234 * y) -> (x - 0.1234 * y) * (x - 0.1234 * y)
define double @test2(double %x, double %y) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[Y:%.*]], 1.234000e-01
; CHECK-NEXT:    [[ADD1:%.*]] = fsub double [[X:%.*]], [[MUL]]
; CHECK-NEXT:    [[MUL3:%.*]] = fmul double [[ADD1]], [[ADD1]]
; CHECK-NEXT:    ret double [[MUL3]]
;
  %mul = fmul double %y, -1.234000e-01
  %add = fadd double %mul, %x
  %mul1 = fmul double %y, -1.234000e-01
  %add2 = fadd double %mul1, %x
  %mul3 = fmul double %add, %add2
  ret double %mul3
}

; (x + 0.1234 * y) * (x - -0.1234 * y) -> (x + 0.1234 * y) * (x + 0.1234 * y)
define double @test3(double %x, double %y) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[Y:%.*]], 1.234000e-01
; CHECK-NEXT:    [[ADD:%.*]] = fadd double [[X:%.*]], [[MUL]]
; CHECK-NEXT:    [[MUL3:%.*]] = fmul double [[ADD]], [[ADD]]
; CHECK-NEXT:    ret double [[MUL3]]
;
  %mul = fmul double %y, 1.234000e-01
  %add = fadd double %mul, %x
  %mul1 = fmul double %y, -1.234000e-01
  %add2 = fsub double %x, %mul1
  %mul3 = fmul double %add, %add2
  ret double %mul3
}

; Canonicalize (x - -0.1234 * y)
define double @test5(double %x, double %y) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[Y:%.*]], 1.234000e-01
; CHECK-NEXT:    [[SUB1:%.*]] = fadd double [[X:%.*]], [[MUL]]
; CHECK-NEXT:    ret double [[SUB1]]
;
  %mul = fmul double -1.234000e-01, %y
  %sub = fsub double %x, %mul
  ret double %sub
}

; Don't modify (-0.1234 * y - x)
define double @test6(double %x, double %y) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[Y:%.*]], -1.234000e-01
; CHECK-NEXT:    [[SUB:%.*]] = fsub double [[MUL]], [[X:%.*]]
; CHECK-NEXT:    ret double [[SUB]]
;
  %mul = fmul double -1.234000e-01, %y
  %sub = fsub double %mul, %x
  ret double %sub
}

; Canonicalize (-0.1234 * y + x) -> (x - 0.1234 * y)
define double @test7(double %x, double %y) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[Y:%.*]], 1.234000e-01
; CHECK-NEXT:    [[ADD1:%.*]] = fsub double [[X:%.*]], [[MUL]]
; CHECK-NEXT:    ret double [[ADD1]]
;
  %mul = fmul double -1.234000e-01, %y
  %add = fadd double %mul, %x
  ret double %add
}

; Canonicalize (y * -0.1234 + x) -> (x - 0.1234 * y)
define double @test8(double %x, double %y) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[MUL:%.*]] = fmul double [[Y:%.*]], 1.234000e-01
; CHECK-NEXT:    [[ADD1:%.*]] = fsub double [[X:%.*]], [[MUL]]
; CHECK-NEXT:    ret double [[ADD1]]
;
  %mul = fmul double %y, -1.234000e-01
  %add = fadd double %mul, %x
  ret double %add
}

; Canonicalize (x - -0.1234 / y)
define double @test9(double %x, double %y) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[DIV:%.*]] = fdiv double 1.234000e-01, [[Y:%.*]]
; CHECK-NEXT:    [[SUB1:%.*]] = fadd double [[X:%.*]], [[DIV]]
; CHECK-NEXT:    ret double [[SUB1]]
;
  %div = fdiv double -1.234000e-01, %y
  %sub = fsub double %x, %div
  ret double %sub
}

; Don't modify (-0.1234 / y - x)
define double @test10(double %x, double %y) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[DIV:%.*]] = fdiv double -1.234000e-01, [[Y:%.*]]
; CHECK-NEXT:    [[SUB:%.*]] = fsub double [[DIV]], [[X:%.*]]
; CHECK-NEXT:    ret double [[SUB]]
;
  %div = fdiv double -1.234000e-01, %y
  %sub = fsub double %div, %x
  ret double %sub
}

; Canonicalize (-0.1234 / y + x) -> (x - 0.1234 / y)
define double @test11(double %x, double %y) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[DIV:%.*]] = fdiv double 1.234000e-01, [[Y:%.*]]
; CHECK-NEXT:    [[ADD1:%.*]] = fsub double [[X:%.*]], [[DIV]]
; CHECK-NEXT:    ret double [[ADD1]]
;
  %div = fdiv double -1.234000e-01, %y
  %add = fadd double %div, %x
  ret double %add
}

; Canonicalize (y / -0.1234 + x) -> (x - y / 0.1234)
define double @test12(double %x, double %y) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[DIV:%.*]] = fdiv double [[Y:%.*]], 1.234000e-01
; CHECK-NEXT:    [[ADD1:%.*]] = fsub double [[X:%.*]], [[DIV]]
; CHECK-NEXT:    ret double [[ADD1]]
;
  %div = fdiv double %y, -1.234000e-01
  %add = fadd double %div, %x
  ret double %add
}

; Don't create an NSW violation
define i4 @test13(i4 %x) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[MUL:%.*]] = mul nsw i4 [[X:%.*]], -2
; CHECK-NEXT:    [[ADD:%.*]] = add i4 [[MUL]], 3
; CHECK-NEXT:    ret i4 [[ADD]]
;
  %mul = mul nsw i4 %x, -2
  %add = add i4 %mul, 3
  ret i4 %add
}

; This tests used to cause an infinite loop where we would loop between
; canonicalizing the negated constant (i.e., (X + Y*-5.0) -> (X - Y*5.0)) and
; breaking up a subtract (i.e., (X - Y*5.0) -> X + (0 - Y*5.0)). To break the
; cycle, we don't canonicalize the negative constant if we're going to later
; break up the subtract.
;
; Check to make sure we don't canonicalize
;   (%pow2*-5.0 + %sub) -> (%sub - %pow2*5.0)
; as we would later break up this subtract causing a cycle.

define double @pr34078(double %A) {
; CHECK-LABEL: @pr34078(
; CHECK-NEXT:    [[SUB:%.*]] = fsub fast double 1.000000e+00, [[A:%.*]]
; CHECK-NEXT:    [[POW2:%.*]] = fmul double [[A]], [[A]]
; CHECK-NEXT:    [[MUL5_NEG:%.*]] = fmul fast double [[POW2]], -5.000000e-01
; CHECK-NEXT:    [[SUB1:%.*]] = fadd fast double [[MUL5_NEG]], [[SUB]]
; CHECK-NEXT:    [[FACTOR:%.*]] = fmul fast double [[SUB1]], 2.000000e+00
; CHECK-NEXT:    ret double [[FACTOR]]
;
  %sub = fsub fast double 1.000000e+00, %A
  %pow2 = fmul double %A, %A
  %mul5 = fmul fast double %pow2, 5.000000e-01
  %sub1 = fsub fast double %sub, %mul5
  %add = fadd fast double %sub1, %sub1
  ret double %add
}

define double @fadd_fmul_neg_const1(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_fmul_neg_const1(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[B:%.*]], 3.000000e+00
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[MUL0]], [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fsub double [[A:%.*]], [[MUL1]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %mul0 = fmul double %b, -3.0
  %mul1 = fmul double %mul0, %c
  %add = fadd double %mul1, %a
  ret double %add
}

define double @fadd_fmul_neg_const2(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_fmul_neg_const2(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[A:%.*]], 3.000000e+00
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[MUL0]], [[B:%.*]]
; CHECK-NEXT:    [[MUL2:%.*]] = fmul double [[MUL1]], 4.000000e+00
; CHECK-NEXT:    [[ADD:%.*]] = fadd double [[A]], [[MUL2]]
; CHECK-NEXT:    ret double [[ADD]]
;
  %mul0 = fmul double %a, -3.0
  %mul1 = fmul double %mul0, %b
  %mul2 = fmul double %mul1, -4.0
  %add = fadd double %mul2, %a
  ret double %add
}

define double @fadd_fmul_neg_const3(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_fmul_neg_const3(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[A:%.*]], 3.000000e+00
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[MUL0]], [[B:%.*]]
; CHECK-NEXT:    [[MUL2:%.*]] = fmul double [[MUL1]], 4.000000e+00
; CHECK-NEXT:    [[MUL3:%.*]] = fmul double [[MUL2]], 5.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = fsub double [[C:%.*]], [[MUL3]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %mul0 = fmul double %a, -3.0
  %mul1 = fmul double %mul0, %b
  %mul2 = fmul double %mul1, -4.0
  %mul3 = fmul double %mul2, -5.0
  %add = fadd double %mul3, %c
  ret double %add
}

define double @fsub_fmul_neg_const1(double %a, double %b, double %c) {
; CHECK-LABEL: @fsub_fmul_neg_const1(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[B:%.*]], 3.000000e+00
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[MUL0]], [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fadd double [[A:%.*]], [[MUL1]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %mul0 = fmul double %b, -3.0
  %mul1 = fmul double %mul0, %c
  %sub = fsub double %a, %mul1
  ret double %sub
}

define double @fsub_fmul_neg_const2(double %a, double %b, double %c) {
; CHECK-LABEL: @fsub_fmul_neg_const2(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[A:%.*]], 3.000000e+00
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[MUL0]], [[B:%.*]]
; CHECK-NEXT:    [[MUL2:%.*]] = fmul double [[MUL1]], 4.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = fadd double [[A]], [[MUL2]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %mul0 = fmul double %a, -3.0
  %mul1 = fmul double %mul0, %b
  %mul2 = fmul double %mul1, 4.0
  %sub = fsub double %a, %mul2
  ret double %sub
}

define double @fsub_fmul_neg_const3(double %a, double %b, double %c) {
; CHECK-LABEL: @fsub_fmul_neg_const3(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[A:%.*]], 3.000000e+00
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[MUL0]], [[B:%.*]]
; CHECK-NEXT:    [[MUL2:%.*]] = fmul double [[MUL1]], 4.000000e+00
; CHECK-NEXT:    [[MUL3:%.*]] = fmul double [[MUL2]], 5.000000e+00
; CHECK-NEXT:    [[SUB:%.*]] = fsub double [[C:%.*]], [[MUL3]]
; CHECK-NEXT:    ret double [[SUB]]
;
  %mul0 = fmul double %a, 3.0
  %mul1 = fmul double %mul0, %b
  %mul2 = fmul double %mul1, -4.0
  %mul3 = fmul double %mul2, -5.0
  %sub = fsub double %c, %mul3
  ret double %sub
}

define double @fadd_fdiv_neg_const1(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_fdiv_neg_const1(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double [[B:%.*]], 3.000000e+00
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[DIV0]], [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fsub double [[A:%.*]], [[DIV1]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %div0 = fdiv double %b, -3.0
  %div1 = fdiv double %div0, %c
  %add = fadd double %div1, %a
  ret double %add
}

define double @fadd_fdiv_neg_const2(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_fdiv_neg_const2(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double 3.000000e+00, [[A:%.*]]
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[DIV0]], [[B:%.*]]
; CHECK-NEXT:    [[DIV2:%.*]] = fdiv double [[DIV1]], 7.000000e+00
; CHECK-NEXT:    [[ADD:%.*]] = fadd double [[A]], [[DIV2]]
; CHECK-NEXT:    ret double [[ADD]]
;
  %div0 = fdiv double -3.0, %a
  %div1 = fdiv double %div0, %b
  %div2 = fdiv double %div1, -7.0
  %add = fadd double %div2, %a
  ret double %add
}

define double @fadd_fdiv_neg_const3(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_fdiv_neg_const3(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double [[A:%.*]], 3.000000e+00
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[DIV0]], [[B:%.*]]
; CHECK-NEXT:    [[DIV2:%.*]] = fdiv double 4.000000e+00, [[DIV1]]
; CHECK-NEXT:    [[DIV3:%.*]] = fdiv double [[DIV2]], 5.000000e+00
; CHECK-NEXT:    [[ADD:%.*]] = fadd double [[C:%.*]], [[DIV3]]
; CHECK-NEXT:    ret double [[ADD]]
;
  %div0 = fdiv double %a, -3.0
  %div1 = fdiv double %div0, %b
  %div2 = fdiv double -4.0, %div1
  %div3 = fdiv double %div2, 5.0
  %add = fadd double %div3, %c
  ret double %add
}

define double @fsub_fdiv_neg_const1(double %a, double %b, double %c) {
; CHECK-LABEL: @fsub_fdiv_neg_const1(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double [[B:%.*]], 3.000000e+00
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[DIV0]], [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fadd double [[A:%.*]], [[DIV1]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %div0 = fdiv double %b, -3.0
  %div1 = fdiv double %div0, %c
  %sub = fsub double %a, %div1
  ret double %sub
}

define double @fsub_fdiv_neg_const2(double %a, double %b, double %c) {
; CHECK-LABEL: @fsub_fdiv_neg_const2(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double 3.000000e+00, [[A:%.*]]
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[DIV0]], [[B:%.*]]
; CHECK-NEXT:    [[DIV2:%.*]] = fdiv double [[DIV1]], 7.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = fadd double [[A]], [[DIV2]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %div0 = fdiv double -3.0, %a
  %div1 = fdiv double %div0, %b
  %div2 = fdiv double %div1, 7.0
  %sub = fsub double %a, %div2
  ret double %sub
}

define double @fsub_fdiv_neg_const3(double %a, double %b, double %c) {
; CHECK-LABEL: @fsub_fdiv_neg_const3(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double 3.000000e+00, [[A:%.*]]
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[DIV0]], [[B:%.*]]
; CHECK-NEXT:    [[DIV2:%.*]] = fdiv double [[DIV1]], 7.000000e+00
; CHECK-NEXT:    [[DIV3:%.*]] = fdiv double 5.000000e+00, [[DIV2]]
; CHECK-NEXT:    [[TMP1:%.*]] = fadd double [[C:%.*]], [[DIV3]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %div0 = fdiv double -3.0, %a
  %div1 = fdiv double %div0, %b
  %div2 = fdiv double %div1, -7.0
  %div3 = fdiv double -5.0, %div2
  %sub = fsub double %c, %div3
  ret double %sub
}

define double @fadd_mix_neg_const1(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_mix_neg_const1(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[B:%.*]], 3.000000e+00
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[MUL0]], [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fsub double [[A:%.*]], [[DIV1]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %mul0 = fmul double %b, -3.0
  %div1 = fdiv double %mul0, %c
  %add = fadd double %div1, %a
  ret double %add
}

define double @fadd_mix_neg_const2(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_mix_neg_const2(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double 3.000000e+00, [[A:%.*]]
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[DIV0]], [[B:%.*]]
; CHECK-NEXT:    [[DIV2:%.*]] = fdiv double [[MUL1]], 5.000000e+00
; CHECK-NEXT:    [[ADD:%.*]] = fadd double [[A]], [[DIV2]]
; CHECK-NEXT:    ret double [[ADD]]
;
  %div0 = fdiv double -3.0, %a
  %mul1 = fmul double %div0, %b
  %div2 = fdiv double %mul1, -5.0
  %add = fadd double %div2, %a
  ret double %add
}

define double @fadd_mix_neg_const3(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_mix_neg_const3(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[A:%.*]], 3.000000e+00
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[MUL0]], [[B:%.*]]
; CHECK-NEXT:    [[MUL2:%.*]] = fmul double [[DIV1]], 4.000000e+00
; CHECK-NEXT:    [[DIV3:%.*]] = fdiv double [[MUL2]], 5.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = fsub double [[C:%.*]], [[DIV3]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %mul0 = fmul double %a, -3.0
  %div1 = fdiv double %mul0, %b
  %mul2 = fmul double -4.0, %div1
  %div3 = fdiv double %mul2, -5.0
  %add = fadd double %div3, %c
  ret double %add
}

define double @fsub_mix_neg_const1(double %a, double %b, double %c) {
; CHECK-LABEL: @fsub_mix_neg_const1(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double [[B:%.*]], 3.000000e+00
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[DIV0]], [[C:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = fadd double [[A:%.*]], [[MUL1]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %div0 = fdiv double %b, -3.0
  %mul1 = fmul double %div0, %c
  %sub = fsub double %a, %mul1
  ret double %sub
}
define double @fsub_mix_neg_const2(double %a, double %b, double %c) {
; CHECK-LABEL: @fsub_mix_neg_const2(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[A:%.*]], 3.000000e+00
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[MUL0]], [[B:%.*]]
; CHECK-NEXT:    [[MUL2:%.*]] = fmul double [[DIV1]], 5.000000e+00
; CHECK-NEXT:    [[SUB:%.*]] = fsub double [[A]], [[MUL2]]
; CHECK-NEXT:    ret double [[SUB]]
;
  %mul0 = fmul double -3.0, %a
  %div1 = fdiv double %mul0, %b
  %mul2 = fmul double %div1, -5.0
  %sub = fsub double %a, %mul2
  ret double %sub
}

define double @fsub_mix_neg_const3(double %a, double %b, double %c) {
; CHECK-LABEL: @fsub_mix_neg_const3(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double 3.000000e+00, [[A:%.*]]
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[DIV0]], [[B:%.*]]
; CHECK-NEXT:    [[DIV2:%.*]] = fdiv double [[MUL1]], 7.000000e+00
; CHECK-NEXT:    [[MUL3:%.*]] = fmul double [[DIV2]], 5.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = fadd double [[C:%.*]], [[MUL3]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %div0 = fdiv double -3.0, %a
  %mul1 = fmul double %div0, %b
  %div2 = fdiv double %mul1, -7.0
  %mul3 = fmul double -5.0, %div2
  %sub = fsub double %c, %mul3
  ret double %sub
}

define double @fadd_both_ops_mix_neg_const1(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_both_ops_mix_neg_const1(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[B:%.*]], -3.000000e+00
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[MUL0]], [[C:%.*]]
; CHECK-NEXT:    [[MUL2:%.*]] = fmul double [[A:%.*]], 4.000000e+00
; CHECK-NEXT:    [[DIV3:%.*]] = fdiv double [[MUL2]], [[C]]
; CHECK-NEXT:    [[TMP1:%.*]] = fsub double [[DIV1]], [[DIV3]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %mul0 = fmul double %b, -3.0
  %div1 = fdiv double %mul0, %c
  %mul2 = fmul double %a, -4.0
  %div3 = fdiv double %mul2, %c
  %add = fadd double %div1, %div3
  ret double %add
}

define double @fadd_both_ops_mix_neg_const2(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_both_ops_mix_neg_const2(
; CHECK-NEXT:    [[DIV0:%.*]] = fdiv double 3.000000e+00, [[A:%.*]]
; CHECK-NEXT:    [[MUL1:%.*]] = fmul double [[DIV0]], [[B:%.*]]
; CHECK-NEXT:    [[DIV2:%.*]] = fdiv double [[MUL1]], 7.000000e+00
; CHECK-NEXT:    [[DIV3:%.*]] = fdiv double 5.000000e+00, [[C:%.*]]
; CHECK-NEXT:    [[MUL4:%.*]] = fmul double [[B]], [[DIV3]]
; CHECK-NEXT:    [[DIV5:%.*]] = fdiv double [[MUL4]], 6.000000e+00
; CHECK-NEXT:    [[ADD:%.*]] = fadd double [[DIV2]], [[DIV5]]
; CHECK-NEXT:    ret double [[ADD]]
;
  %div0 = fdiv double -3.0, %a
  %mul1 = fmul double %div0, %b
  %div2 = fdiv double %mul1, -7.0
  %div3 = fdiv double -5.0, %c
  %mul4 = fmul double %div3, %b
  %div5 = fdiv double %mul4, -6.0
  %add = fadd double %div2, %div5
  ret double %add
}

define double @fadd_both_opsmix_neg_const3(double %a, double %b, double %c) {
; CHECK-LABEL: @fadd_both_opsmix_neg_const3(
; CHECK-NEXT:    [[MUL0:%.*]] = fmul double [[A:%.*]], -3.000000e+00
; CHECK-NEXT:    [[DIV1:%.*]] = fdiv double [[MUL0]], [[B:%.*]]
; CHECK-NEXT:    [[MUL2:%.*]] = fmul double [[DIV1]], -4.000000e+00
; CHECK-NEXT:    [[DIV3:%.*]] = fdiv double [[MUL2]], -5.000000e+00
; CHECK-NEXT:    [[MUL4:%.*]] = fmul double [[C:%.*]], 6.000000e+00
; CHECK-NEXT:    [[DIV5:%.*]] = fdiv double [[MUL4]], [[B]]
; CHECK-NEXT:    [[MUL6:%.*]] = fmul double [[DIV5]], 7.000000e+00
; CHECK-NEXT:    [[MUL7:%.*]] = fdiv double [[MUL6]], 9.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = fsub double [[DIV3]], [[MUL7]]
; CHECK-NEXT:    ret double [[TMP1]]
;
  %mul0 = fmul double %a, -3.0
  %div1 = fdiv double %mul0, %b
  %mul2 = fmul double -4.0, %div1
  %div3 = fdiv double %mul2, -5.0
  %mul4 = fmul double %c, -6.0
  %div5 = fdiv double %mul4, %b
  %mul6 = fmul double -7.0, %div5
  %mul7 = fdiv double %mul6, -9.0
  %add = fadd double %div3, %mul7
  ret double %add
}
