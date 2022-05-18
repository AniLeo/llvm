; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -mcpu=core-avx2 -mtriple=x86_64-unknown-linux-gnu -slp-threshold=-2 < %s | FileCheck %s

; This test checks for a case when a horizontal reduction of floating-point
; adds may look profitable, but is not because it eliminates generation of
; floating-point FMAs that would be more profitable.

; FIXME: We generate a horizontal reduction today.

define void @hr() {
; CHECK-LABEL: @hr(
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[PHI0:%.*]] = phi double [ 0.000000e+00, [[TMP0:%.*]] ], [ [[OP_RDX:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[CVT0:%.*]] = uitofp i16 0 to double
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x double> <double poison, double 0.000000e+00, double 0.000000e+00, double 0.000000e+00>, double [[CVT0]], i32 0
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast <4 x double> zeroinitializer, [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = call fast double @llvm.vector.reduce.fadd.v4f64(double -0.000000e+00, <4 x double> [[TMP2]])
; CHECK-NEXT:    [[OP_RDX]] = fadd fast double [[TMP3]], [[PHI0]]
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %loop

loop:
  %phi0 = phi double [ 0.000000e+00, %0 ], [ %add3, %loop ]
  %cvt0 = uitofp i16 0 to double
  %mul0 = fmul fast double 0.000000e+00, %cvt0
  %add0 = fadd fast double %mul0, %phi0
  %mul1 = fmul fast double 0.000000e+00, 0.000000e+00
  %add1 = fadd fast double %mul1, %add0
  %mul2 = fmul fast double 0.000000e+00, 0.000000e+00
  %add2 = fadd fast double %mul2, %add1
  %mul3 = fmul fast double 0.000000e+00, 0.000000e+00
  %add3 = fadd fast double %mul3, %add2
  br i1 true, label %exit, label %loop

exit:
  ret void
}

; This test checks for a case when either a horizontal reduction of
; floating-point adds, or vectorizing a tree of floating-point multiplies,
; may look profitable; but both are not because this eliminates generation
; of floating-point FMAs that would be more profitable.

; FIXME: We generate a horizontal reduction today, and if that's disabled, we
; still vectorize some of the multiplies.

define double @hr_or_mul() {
; CHECK-LABEL: @hr_or_mul(
; CHECK-NEXT:    [[CVT0:%.*]] = uitofp i16 3 to double
; CHECK-NEXT:    [[TMP1:%.*]] = insertelement <4 x double> poison, double [[CVT0]], i32 0
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <4 x double> [[TMP1]], <4 x double> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[TMP2:%.*]] = fmul fast <4 x double> <double 7.000000e+00, double -4.300000e+01, double 2.200000e-02, double 9.500000e+00>, [[SHUFFLE]]
; CHECK-NEXT:    [[TMP3:%.*]] = call fast double @llvm.vector.reduce.fadd.v4f64(double -0.000000e+00, <4 x double> [[TMP2]])
; CHECK-NEXT:    [[OP_RDX:%.*]] = fadd fast double [[TMP3]], [[CVT0]]
; CHECK-NEXT:    ret double [[OP_RDX]]
;
  %cvt0 = uitofp i16 3 to double
  %mul0 = fmul fast double 7.000000e+00, %cvt0
  %add0 = fadd fast double %mul0, %cvt0
  %mul1 = fmul fast double -4.300000e+01, %cvt0
  %add1 = fadd fast double %mul1, %add0
  %mul2 = fmul fast double 2.200000e-02, %cvt0
  %add2 = fadd fast double %mul2, %add1
  %mul3 = fmul fast double 9.500000e+00, %cvt0
  %add3 = fadd fast double %mul3, %add2
  ret double %add3
}
