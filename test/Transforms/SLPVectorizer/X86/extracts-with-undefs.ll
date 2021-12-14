; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu | FileCheck %s

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BODY:%.*]]
; CHECK:       body:
; CHECK-NEXT:    [[PHI1:%.*]] = phi double [ 0.000000e+00, [[ENTRY:%.*]] ], [ 0.000000e+00, [[BODY]] ]
; CHECK-NEXT:    [[PHI2:%.*]] = phi double [ 0.000000e+00, [[ENTRY]] ], [ 0.000000e+00, [[BODY]] ]
; CHECK-NEXT:    [[MUL_I478_I:%.*]] = fmul fast double [[PHI1]], 0.000000e+00
; CHECK-NEXT:    [[MUL7_I485_I:%.*]] = fmul fast double undef, 0.000000e+00
; CHECK-NEXT:    [[ADD8_I_I:%.*]] = fadd fast double [[MUL_I478_I]], [[MUL7_I485_I]]
; CHECK-NEXT:    [[CMP42_I:%.*]] = fcmp fast ole double [[ADD8_I_I]], 0.000000e+00
; CHECK-NEXT:    br i1 false, label [[BODY]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    br i1 false, label [[IF_THEN135_I:%.*]], label [[IF_END209_I:%.*]]
; CHECK:       if.then135.i:
; CHECK-NEXT:    [[CMP145_I:%.*]] = fcmp fast olt double [[PHI1]], 0.000000e+00
; CHECK-NEXT:    [[CMP152_I:%.*]] = fcmp fast olt double [[PHI2]], 0.000000e+00
; CHECK-NEXT:    [[TMP0:%.*]] = insertelement <2 x i1> <i1 poison, i1 false>, i1 [[CMP152_I]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = select <2 x i1> [[TMP0]], <2 x double> zeroinitializer, <2 x double> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast <2 x double> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = fmul fast <2 x double> [[TMP2]], zeroinitializer
; CHECK-NEXT:    [[TMP4:%.*]] = fadd fast <2 x double> [[TMP3]], zeroinitializer
; CHECK-NEXT:    br label [[IF_END209_I]]
; CHECK:       if.end209.i:
; CHECK-NEXT:    [[TMP5:%.*]] = phi <2 x double> [ [[TMP4]], [[IF_THEN135_I]] ], [ zeroinitializer, [[EXIT]] ]
; CHECK-NEXT:    ret void
;
entry:
  br label %body

body:
  %phi1 = phi double [ 0.000000e+00, %entry ], [ 0.000000e+00, %body ]
  %phi2 = phi double [ 0.000000e+00, %entry ], [ 0.000000e+00, %body ]
  %mul.i478.i = fmul fast double %phi1, 0.000000e+00
  %mul7.i485.i = fmul fast double undef, 0.000000e+00
  %add8.i.i = fadd fast double %mul.i478.i, %mul7.i485.i
  %cmp42.i = fcmp fast ole double %add8.i.i, 0.000000e+00
  br i1 false, label %body, label %exit

exit:
  br i1 false, label %if.then135.i, label %if.end209.i

if.then135.i:
  %cmp145.i = fcmp fast olt double %phi1, 0.000000e+00
  %0 = select i1 false, double 0.000000e+00, double 0.000000e+00
  %cmp152.i = fcmp fast olt double %phi2, 0.000000e+00
  %1 = select i1 %cmp152.i, double 0.000000e+00, double 0.000000e+00
  %mul166.i = fmul fast double 0.000000e+00, %0
  %mul177.i = fmul fast double %mul166.i, 0.000000e+00
  %add178.i = fadd fast double %mul177.i, 0.000000e+00
  %mul181.i = fmul fast double 0.000000e+00, %1
  %mul182.i = fmul fast double %mul181.i, 0.000000e+00
  %add183.i = fadd fast double %mul182.i, 0.000000e+00
  br label %if.end209.i

if.end209.i:
  %drdys.1.i = phi double [ %add183.i, %if.then135.i ], [ 0.000000e+00, %exit ]
  %dbdxs.1.i = phi double [ %add178.i, %if.then135.i ], [ 0.000000e+00, %exit ]
  ret void
}
