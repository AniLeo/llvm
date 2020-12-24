; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -vector-combine -S -mtriple=hexagon-- | FileCheck %s --check-prefixes=CHECK

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; This would crash because TTI returns "0" for vector length.

define <4 x float> @load_f32_insert_v4f32(float* align 16 dereferenceable(16) %p) {
; CHECK-LABEL: @load_f32_insert_v4f32(
; CHECK-NEXT:    [[S:%.*]] = load float, float* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> poison, float [[S]], i32 0
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %s = load float, float* %p, align 4
  %r = insertelement <4 x float> poison, float %s, i32 0
  ret <4 x float> %r
}
