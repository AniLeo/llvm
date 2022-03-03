; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -slp-vectorizer -mtriple=aarch64--linux-gnu -mcpu=generic < %s | FileCheck %s
; RUN: opt -S -slp-vectorizer -mtriple=aarch64-apple-ios -mcpu=cyclone < %s | FileCheck %s
; Currently disabled for a few subtargets (e.g. Kryo):
; RUN: opt -S -slp-vectorizer -mtriple=aarch64--linux-gnu -mcpu=kryo < %s | FileCheck --check-prefix=NO_SLP %s
; RUN: opt -S -slp-vectorizer -mtriple=aarch64--linux-gnu -mcpu=generic -slp-min-reg-size=128 < %s | FileCheck --check-prefix=NO_SLP %s

define void @f(float* %r, float* %w) {
; CHECK-LABEL: @f(
; CHECK-NEXT:    [[R0:%.*]] = getelementptr inbounds float, float* [[R:%.*]], i64 0
; CHECK-NEXT:    [[R1:%.*]] = getelementptr inbounds float, float* [[R]], i64 1
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast float* [[R0]] to <2 x float>*
; CHECK-NEXT:    [[TMP2:%.*]] = load <2 x float>, <2 x float>* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP3:%.*]] = fadd <2 x float> [[TMP2]], [[TMP2]]
; CHECK-NEXT:    [[W0:%.*]] = getelementptr inbounds float, float* [[W:%.*]], i64 0
; CHECK-NEXT:    [[W1:%.*]] = getelementptr inbounds float, float* [[W]], i64 1
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast float* [[W0]] to <2 x float>*
; CHECK-NEXT:    store <2 x float> [[TMP3]], <2 x float>* [[TMP4]], align 4
; CHECK-NEXT:    ret void
;
; NO_SLP-LABEL: @f(
; NO_SLP-NEXT:    [[R0:%.*]] = getelementptr inbounds float, float* [[R:%.*]], i64 0
; NO_SLP-NEXT:    [[R1:%.*]] = getelementptr inbounds float, float* [[R]], i64 1
; NO_SLP-NEXT:    [[F0:%.*]] = load float, float* [[R0]], align 4
; NO_SLP-NEXT:    [[F1:%.*]] = load float, float* [[R1]], align 4
; NO_SLP-NEXT:    [[ADD0:%.*]] = fadd float [[F0]], [[F0]]
; NO_SLP-NEXT:    [[ADD1:%.*]] = fadd float [[F1]], [[F1]]
; NO_SLP-NEXT:    [[W0:%.*]] = getelementptr inbounds float, float* [[W:%.*]], i64 0
; NO_SLP-NEXT:    [[W1:%.*]] = getelementptr inbounds float, float* [[W]], i64 1
; NO_SLP-NEXT:    store float [[ADD0]], float* [[W0]], align 4
; NO_SLP-NEXT:    store float [[ADD1]], float* [[W1]], align 4
; NO_SLP-NEXT:    ret void
;
  %r0 = getelementptr inbounds float, float* %r, i64 0
  %r1 = getelementptr inbounds float, float* %r, i64 1
  %f0 = load float, float* %r0
  %f1 = load float, float* %r1
  %add0 = fadd float %f0, %f0
  %add1 = fadd float %f1, %f1
  %w0 = getelementptr inbounds float, float* %w, i64 0
  %w1 = getelementptr inbounds float, float* %w, i64 1
  store float %add0, float* %w0
  store float %add1, float* %w1
  ret void
}
