; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx906 -verify-machineinstrs < %s | FileCheck %s

; This example used to produce a verifier error resulting from the
; register coalescer leaving behind a false live interval when a live
; out copy introduced new liveness for a subregister.

define <3 x float> @liveout_undef_subrange(<3 x float> %arg) {
; CHECK-LABEL: liveout_undef_subrange:
; CHECK:       ; %bb.0: ; %bb
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_add_f32_e32 v3, v2, v2
; CHECK-NEXT:    v_add_f32_e32 v1, v1, v1
; CHECK-NEXT:    v_add_f32_e32 v0, v0, v0
; CHECK-NEXT:  BB0_1: ; %bb1
; CHECK-NEXT:    ; =>This Loop Header: Depth=1
; CHECK-NEXT:    ; Child Loop BB0_2 Depth 2
; CHECK-NEXT:    s_mov_b64 s[4:5], 0
; CHECK-NEXT:  BB0_2: ; %bb1
; CHECK-NEXT:    ; Parent Loop BB0_1 Depth=1
; CHECK-NEXT:    ; => This Inner Loop Header: Depth=2
; CHECK-NEXT:    v_cmp_neq_f32_e32 vcc, 0, v2
; CHECK-NEXT:    s_or_b64 s[4:5], vcc, s[4:5]
; CHECK-NEXT:    s_andn2_b64 exec, exec, s[4:5]
; CHECK-NEXT:    s_cbranch_execnz BB0_2
; CHECK-NEXT:  ; %bb.3: ; %bb2
; CHECK-NEXT:    ; in Loop: Header=BB0_1 Depth=1
; CHECK-NEXT:    s_or_b64 exec, exec, s[4:5]
; CHECK-NEXT:    v_mul_f32_e32 v2, v3, v2
; CHECK-NEXT:    s_branch BB0_1
bb:
  br label %bb1

bb1:                                              ; preds = %bb3, %bb
  %i = phi <3 x float> [ %arg, %bb ], [ %i11, %bb3 ]
  %i2 = extractelement <3 x float> %i, i64 2
  %i3 = fmul float %i2, 1.000000e+00
  %i4 = fmul nsz <3 x float> %arg, <float 2.000000e+00, float 2.000000e+00, float 2.000000e+00>
  %i5 = insertelement <3 x float> undef, float %i3, i32 0
  %i6 = shufflevector <3 x float> %i5, <3 x float> undef, <3 x i32> zeroinitializer
  %i7 = fmul <3 x float> %i4, %i6
  %i8 = fcmp oeq float %i3, 0.000000e+00
  br i1 %i8, label %bb3, label %bb2

bb2:                                              ; preds = %bb1
  br label %bb3

bb3:                                             ; preds = %bb2, %bb1
  %i11 = phi <3 x float> [ %i7, %bb2 ], [ %i, %bb1 ]
  br label %bb1
}
