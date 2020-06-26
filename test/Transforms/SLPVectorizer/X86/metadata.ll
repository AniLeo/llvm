; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

define void @test1(double* %a, double* %b, double* %c) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast double* [[A:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x double>, <2 x double>* [[TMP0]], align 8, !tbaa !0
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast double* [[B:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <2 x double>, <2 x double>* [[TMP2]], align 8, !tbaa !0
; CHECK-NEXT:    [[TMP4:%.*]] = fmul <2 x double> [[TMP1]], [[TMP3]], !fpmath !4
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast double* [[C:%.*]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP4]], <2 x double>* [[TMP5]], align 8, !tbaa !0
; CHECK-NEXT:    ret void
;
entry:
  %i0 = load double, double* %a, align 8, !tbaa !4
  %i1 = load double, double* %b, align 8, !tbaa !4
  %mul = fmul double %i0, %i1, !fpmath !0
  %arrayidx3 = getelementptr inbounds double, double* %a, i64 1
  %i3 = load double, double* %arrayidx3, align 8, !tbaa !4
  %arrayidx4 = getelementptr inbounds double, double* %b, i64 1
  %i4 = load double, double* %arrayidx4, align 8, !tbaa !4
  %mul5 = fmul double %i3, %i4, !fpmath !0
  store double %mul, double* %c, align 8, !tbaa !4
  %arrayidx5 = getelementptr inbounds double, double* %c, i64 1
  store double %mul5, double* %arrayidx5, align 8, !tbaa !4
  ret void
}

define void @test2(double* %a, double* %b, i8* %e) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast double* [[A:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x double>, <2 x double>* [[TMP0]], align 8, !tbaa !0
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast double* [[B:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP3:%.*]] = load <2 x double>, <2 x double>* [[TMP2]], align 8, !tbaa !0
; CHECK-NEXT:    [[TMP4:%.*]] = fmul <2 x double> [[TMP1]], [[TMP3]], !fpmath !5
; CHECK-NEXT:    [[C:%.*]] = bitcast i8* [[E:%.*]] to double*
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast double* [[C]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP4]], <2 x double>* [[TMP5]], align 8, !tbaa !0
; CHECK-NEXT:    ret void
;
entry:
  %i0 = load double, double* %a, align 8, !tbaa !4
  %i1 = load double, double* %b, align 8, !tbaa !4
  %mul = fmul double %i0, %i1, !fpmath !1
  %arrayidx3 = getelementptr inbounds double, double* %a, i64 1
  %i3 = load double, double* %arrayidx3, align 8, !tbaa !4
  %arrayidx4 = getelementptr inbounds double, double* %b, i64 1
  %i4 = load double, double* %arrayidx4, align 8, !tbaa !4
  %mul5 = fmul double %i3, %i4, !fpmath !1
  %c = bitcast i8* %e to double*
  store double %mul, double* %c, align 8, !tbaa !4
  %carrayidx5 = getelementptr inbounds i8, i8* %e, i64 8
  %arrayidx5 = bitcast i8* %carrayidx5 to double*
  store double %mul5, double* %arrayidx5, align 8, !tbaa !4
  ret void
}

;CHECK-DAG: !0 = !{[[TYPEC:!.*]], [[TYPEC]], i64 0}
;CHECK-DAG: !4 = !{float 5.000000e+00}
;CHECK-DAG: !5 = !{float 2.500000e+00}
!0 = !{ float 5.0 }
!1 = !{ float 2.5 }
!2 = !{!"Simple C/C++ TBAA"}
!3 = !{!"omnipotent char", !2}
!4 = !{!"double", !3}
