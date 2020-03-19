; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=powerpc64le-unknown-linux-gnu -simplifycfg -enable-unsafe-fp-math -S | \
; RUN: FileCheck %s

; This case is copied from test/Transforms/SimplifyCFG/AArch64/
; Function Attrs: nounwind
define double @_Z3fooRdS_S_S_(double* dereferenceable(8) %x, double* dereferenceable(8) %y, double* dereferenceable(8) %a) {
; CHECK-LABEL: @_Z3fooRdS_S_S_(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load double, double* [[Y:%.*]], align 8
; CHECK-NEXT:    [[CMP:%.*]] = fcmp oeq double [[TMP0]], 0.000000e+00
; CHECK-NEXT:    [[TMP1:%.*]] = load double, double* [[X:%.*]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load double, double* [[A:%.*]], align 8
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast double [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[MUL:%.*]] = fadd fast double 1.000000e+00, [[TMP3]]
; CHECK-NEXT:    store double [[MUL]], double* [[Y]], align 8
; CHECK-NEXT:    br label [[IF_END:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    [[MUL1:%.*]] = fmul fast double [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[SUB1:%.*]] = fsub fast double [[MUL1]], [[TMP0]]
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr double, double* [[Y]], i32 1
; CHECK-NEXT:    store double [[SUB1]], double* [[GEP1]], align 8
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP4:%.*]] = load double, double* [[Y]], align 8
; CHECK-NEXT:    [[CMP2:%.*]] = fcmp oeq double [[TMP4]], 2.000000e+00
; CHECK-NEXT:    [[TMP5:%.*]] = load double, double* [[X]], align 8
; CHECK-NEXT:    br i1 [[CMP2]], label [[IF_THEN2:%.*]], label [[IF_ELSE2:%.*]]
; CHECK:       if.then2:
; CHECK-NEXT:    [[TMP6:%.*]] = load double, double* [[A]], align 8
; CHECK-NEXT:    [[TMP7:%.*]] = fmul fast double [[TMP5]], 3.000000e+00
; CHECK-NEXT:    [[MUL2:%.*]] = fsub fast double [[TMP6]], [[TMP7]]
; CHECK-NEXT:    store double [[MUL2]], double* [[Y]], align 8
; CHECK-NEXT:    br label [[IF_END2:%.*]]
; CHECK:       if.else2:
; CHECK-NEXT:    [[MUL3:%.*]] = fmul fast double [[TMP5]], 3.000000e+00
; CHECK-NEXT:    [[NEG:%.*]] = fsub fast double 0.000000e+00, [[MUL3]]
; CHECK-NEXT:    [[SUB2:%.*]] = fsub fast double [[NEG]], 3.000000e+00
; CHECK-NEXT:    store double [[SUB2]], double* [[Y]], align 8
; CHECK-NEXT:    br label [[IF_END2]]
; CHECK:       if.end2:
; CHECK-NEXT:    [[TMP8:%.*]] = load double, double* [[X]], align 8
; CHECK-NEXT:    [[TMP9:%.*]] = load double, double* [[Y]], align 8
; CHECK-NEXT:    [[ADD:%.*]] = fadd fast double [[TMP8]], [[TMP9]]
; CHECK-NEXT:    [[TMP10:%.*]] = load double, double* [[A]], align 8
; CHECK-NEXT:    [[ADD2:%.*]] = fadd fast double [[ADD]], [[TMP10]]
; CHECK-NEXT:    ret double [[ADD2]]
;
entry:
  %0 = load double, double* %y, align 8
  %cmp = fcmp oeq double %0, 0.000000e+00
  %1 = load double, double* %x, align 8
  br i1 %cmp, label %if.then, label %if.else

; fadd (const, (fmul x, y))
if.then:                                          ; preds = %entry
  %2 = load double, double* %a, align 8
  %3 = fmul fast double %1, %2
  %mul = fadd fast double 1.000000e+00, %3
  store double %mul, double* %y, align 8
  br label %if.end

; fsub ((fmul x, y), z)
if.else:                                          ; preds = %entry
  %4 = load double, double* %a, align 8
  %mul1 = fmul fast double %1, %4
  %sub1 = fsub fast double %mul1, %0
  %gep1 = getelementptr double, double* %y, i32 1
  store double %sub1, double* %gep1, align 8
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %5 = load double, double* %y, align 8
  %cmp2 = fcmp oeq double %5, 2.000000e+00
  %6 = load double, double* %x, align 8
  br i1 %cmp2, label %if.then2, label %if.else2

; fsub (x, (fmul y, z))
if.then2:                                         ; preds = %entry
  %7 = load double, double* %a, align 8
  %8 = fmul fast double %6, 3.0000000e+00
  %mul2 = fsub fast double %7, %8
  store double %mul2, double* %y, align 8
  br label %if.end2

; fsub (fneg((fmul x, y)), const)
if.else2:                                         ; preds = %entry
  %mul3 = fmul fast double %6, 3.0000000e+00
  %neg = fsub fast double 0.0000000e+00, %mul3
  %sub2 = fsub fast double %neg, 3.0000000e+00
  store double %sub2, double* %y, align 8
  br label %if.end2

if.end2:                                           ; preds = %if.else, %if.then
  %9 = load double, double* %x, align 8
  %10 = load double, double* %y, align 8
  %add = fadd fast double %9, %10
  %11 = load double, double* %a, align 8
  %add2 = fadd fast double %add, %11
  ret double %add2
}
