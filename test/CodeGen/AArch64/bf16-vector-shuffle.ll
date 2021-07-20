; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-eabi -mattr=+bf16 | FileCheck %s

; bfloat16x4_t test_vcreate_bf16(uint64_t a) { return vcreate_bf16(a); }
define <4 x bfloat> @test_vcreate_bf16(i64 %a) nounwind {
; CHECK-LABEL: test_vcreate_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fmov d0, x0
; CHECK-NEXT:    ret
entry:
  %0 = bitcast i64 %a to <4 x bfloat>
  ret <4 x bfloat> %0
}

; bfloat16x4_t test_vdup_n_bf16(bfloat16_t v) { return vdup_n_bf16(v); }
define <4 x bfloat> @test_vdup_n_bf16(bfloat %v) nounwind {
; CHECK-LABEL: test_vdup_n_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $h0 killed $h0 def $q0
; CHECK-NEXT:    dup v0.4h, v0.h[0]
; CHECK-NEXT:    ret
entry:
  %vecinit.i = insertelement <4 x bfloat> undef, bfloat %v, i32 0
  %vecinit3.i = shufflevector <4 x bfloat> %vecinit.i, <4 x bfloat> undef, <4 x i32> zeroinitializer
  ret <4 x bfloat> %vecinit3.i
}

; bfloat16x8_t test_vdupq_n_bf16(bfloat16_t v) { return vdupq_n_bf16(v); }
define <8 x bfloat> @test_vdupq_n_bf16(bfloat %v) nounwind {
; CHECK-LABEL: test_vdupq_n_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $h0 killed $h0 def $q0
; CHECK-NEXT:    dup v0.8h, v0.h[0]
; CHECK-NEXT:    ret
entry:
  %vecinit.i = insertelement <8 x bfloat> undef, bfloat %v, i32 0
  %vecinit7.i = shufflevector <8 x bfloat> %vecinit.i, <8 x bfloat> undef, <8 x i32> zeroinitializer
  ret <8 x bfloat> %vecinit7.i
}

; bfloat16x4_t test_vdup_lane_bf16(bfloat16x4_t v) { return vdup_lane_bf16(v, 1); }
define <4 x bfloat> @test_vdup_lane_bf16(<4 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vdup_lane_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    dup v0.4h, v0.h[1]
; CHECK-NEXT:    ret
entry:
  %lane = shufflevector <4 x bfloat> %v, <4 x bfloat> undef, <4 x i32> <i32 1, i32 1, i32 1, i32 1>
  ret <4 x bfloat> %lane
}

; bfloat16x8_t test_vdupq_lane_bf16(bfloat16x4_t v) { return vdupq_lane_bf16(v, 1); }
define <8 x bfloat> @test_vdupq_lane_bf16(<4 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vdupq_lane_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    dup v0.8h, v0.h[1]
; CHECK-NEXT:    ret
entry:
  %lane = shufflevector <4 x bfloat> %v, <4 x bfloat> undef, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  ret <8 x bfloat> %lane
}

; bfloat16x4_t test_vdup_laneq_bf16(bfloat16x8_t v) { return vdup_laneq_bf16(v, 7); }
define <4 x bfloat> @test_vdup_laneq_bf16(<8 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vdup_laneq_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    dup v0.4h, v0.h[7]
; CHECK-NEXT:    ret
entry:
  %lane = shufflevector <8 x bfloat> %v, <8 x bfloat> undef, <4 x i32> <i32 7, i32 7, i32 7, i32 7>
  ret <4 x bfloat> %lane
}

; bfloat16x8_t test_vdupq_laneq_bf16(bfloat16x8_t v) { return vdupq_laneq_bf16(v, 7); }
define <8 x bfloat> @test_vdupq_laneq_bf16(<8 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vdupq_laneq_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    dup v0.8h, v0.h[7]
; CHECK-NEXT:    ret
entry:
  %lane = shufflevector <8 x bfloat> %v, <8 x bfloat> undef, <8 x i32> <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>
  ret <8 x bfloat> %lane
}

; bfloat16x8_t test_vcombine_bf16(bfloat16x4_t low, bfloat16x4_t high) { return vcombine_bf16(low, high); }
define <8 x bfloat> @test_vcombine_bf16(<4 x bfloat> %low, <4 x bfloat> %high) nounwind {
; CHECK-LABEL: test_vcombine_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    mov v0.d[1], v1.d[0]
; CHECK-NEXT:    ret
entry:
  %shuffle.i = shufflevector <4 x bfloat> %low, <4 x bfloat> %high, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x bfloat> %shuffle.i
}

; bfloat16x4_t test_vget_high_bf16(bfloat16x8_t a) { return vget_high_bf16(a); }
define <4 x bfloat> @test_vget_high_bf16(<8 x bfloat> %a) nounwind {
; CHECK-LABEL: test_vget_high_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ext v0.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
entry:
  %shuffle.i = shufflevector <8 x bfloat> %a, <8 x bfloat> undef, <4 x i32> <i32 4, i32 5, i32 6, i32 7>
  ret <4 x bfloat> %shuffle.i
}

; bfloat16x4_t test_vget_low_bf16(bfloat16x8_t a) { return vget_low_bf16(a); }
define <4 x bfloat> @test_vget_low_bf16(<8 x bfloat> %a) nounwind {
; CHECK-LABEL: test_vget_low_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
entry:
  %shuffle.i = shufflevector <8 x bfloat> %a, <8 x bfloat> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x bfloat> %shuffle.i
}

; bfloat16_t test_vget_lane_bf16(bfloat16x4_t v) { return vget_lane_bf16(v, 1); }
define bfloat @test_vget_lane_bf16(<4 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vget_lane_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov h0, v0.h[1]
; CHECK-NEXT:    ret
entry:
  %vget_lane = extractelement <4 x bfloat> %v, i32 1
  ret bfloat %vget_lane
}

; bfloat16_t test_vgetq_lane_bf16(bfloat16x8_t v) { return vgetq_lane_bf16(v, 7); }
define bfloat @test_vgetq_lane_bf16(<8 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vgetq_lane_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov h0, v0.h[7]
; CHECK-NEXT:    ret
entry:
  %vgetq_lane = extractelement <8 x bfloat> %v, i32 7
  ret bfloat %vgetq_lane
}

; bfloat16x4_t test_vset_lane_bf16(bfloat16_t a, bfloat16x4_t v) { return vset_lane_bf16(a, v, 1); }
define <4 x bfloat> @test_vset_lane_bf16(bfloat %a, <4 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vset_lane_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    // kill: def $h0 killed $h0 def $q0
; CHECK-NEXT:    mov v1.h[1], v0.h[0]
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
entry:
  %vset_lane = insertelement <4 x bfloat> %v, bfloat %a, i32 1
  ret <4 x bfloat> %vset_lane
}

; bfloat16x8_t test_vsetq_lane_bf16(bfloat16_t a, bfloat16x8_t v) { return vsetq_lane_bf16(a, v, 7); }
define <8 x bfloat> @test_vsetq_lane_bf16(bfloat %a, <8 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vsetq_lane_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $h0 killed $h0 def $q0
; CHECK-NEXT:    mov v1.h[7], v0.h[0]
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
entry:
  %vset_lane = insertelement <8 x bfloat> %v, bfloat %a, i32 7
  ret <8 x bfloat> %vset_lane
}

; bfloat16_t test_vduph_lane_bf16(bfloat16x4_t v) { return vduph_lane_bf16(v, 1); }
define bfloat @test_vduph_lane_bf16(<4 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vduph_lane_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov h0, v0.h[1]
; CHECK-NEXT:    ret
entry:
  %vget_lane = extractelement <4 x bfloat> %v, i32 1
  ret bfloat %vget_lane
}

; bfloat16_t test_vduph_laneq_bf16(bfloat16x8_t v) { return vduph_laneq_bf16(v, 7); }
define bfloat @test_vduph_laneq_bf16(<8 x bfloat> %v) nounwind {
; CHECK-LABEL: test_vduph_laneq_bf16:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov h0, v0.h[7]
; CHECK-NEXT:    ret
entry:
  %vgetq_lane = extractelement <8 x bfloat> %v, i32 7
  ret bfloat %vgetq_lane
}

; vcopy_lane_bf16(a, 1, b, 3);
define <4 x bfloat> @test_vcopy_lane_bf16_v1(<4 x bfloat> %a, <4 x bfloat> %b) nounwind {
; CHECK-LABEL: test_vcopy_lane_bf16_v1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    mov v0.h[1], v1.h[3]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
entry:
  %vset_lane = shufflevector <4 x bfloat> %a, <4 x bfloat> %b, <4 x i32> <i32 0, i32 7, i32 2, i32 3>
  ret <4 x bfloat> %vset_lane
}

; vcopy_lane_bf16(a, 2, b, 0);
define <4 x bfloat> @test_vcopy_lane_bf16_v2(<4 x bfloat> %a, <4 x bfloat> %b) nounwind {
; CHECK-LABEL: test_vcopy_lane_bf16_v2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    mov v0.h[2], v1.h[0]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
entry:
  %vset_lane = shufflevector <4 x bfloat> %a, <4 x bfloat> %b, <4 x i32> <i32 0, i32 1, i32 4, i32 3>
  ret <4 x bfloat> %vset_lane
}

; vcopyq_lane_bf16(a, 0, b, 2);
define <8 x bfloat> @test_vcopyq_lane_bf16_v1(<8 x bfloat> %a, <4 x bfloat> %b) nounwind {
; CHECK-LABEL: test_vcopyq_lane_bf16_v1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    mov v0.h[0], v1.h[2]
; CHECK-NEXT:    ret
entry:
  %0 = shufflevector <4 x bfloat> %b, <4 x bfloat> undef, <8 x i32> <i32 undef, i32 undef, i32 2, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %vset_lane = shufflevector <8 x bfloat> %a, <8 x bfloat> %0, <8 x i32> <i32 10, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x bfloat> %vset_lane
}

; vcopyq_lane_bf16(a, 6, b, 0);
define <8 x bfloat> @test_vcopyq_lane_bf16_v2(<8 x bfloat> %a, <4 x bfloat> %b) nounwind {
; CHECK-LABEL: test_vcopyq_lane_bf16_v2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d1 killed $d1 def $q1
; CHECK-NEXT:    mov v0.h[6], v1.h[0]
; CHECK-NEXT:    ret
entry:
  %0 = shufflevector <4 x bfloat> %b, <4 x bfloat> undef, <8 x i32> <i32 0, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %vset_lane = shufflevector <8 x bfloat> %a, <8 x bfloat> %0, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 8, i32 7>
  ret <8 x bfloat> %vset_lane
}

; vcopy_laneq_bf16(a, 0, b, 7);
define <4 x bfloat> @test_vcopy_laneq_bf16_v1(<4 x bfloat> %a, <8 x bfloat> %b) nounwind {
; CHECK-LABEL: test_vcopy_laneq_bf16_v1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov v0.h[0], v1.h[7]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
entry:
  %vgetq_lane = extractelement <8 x bfloat> %b, i32 7
  %vset_lane = insertelement <4 x bfloat> %a, bfloat %vgetq_lane, i32 0
  ret <4 x bfloat> %vset_lane
}

; vcopy_laneq_bf16(a, 3, b, 4);
define <4 x bfloat> @test_vcopy_laneq_bf16_v2(<4 x bfloat> %a, <8 x bfloat> %b) nounwind {
; CHECK-LABEL: test_vcopy_laneq_bf16_v2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov v0.h[3], v1.h[4]
; CHECK-NEXT:    // kill: def $d0 killed $d0 killed $q0
; CHECK-NEXT:    ret
entry:
  %vgetq_lane = extractelement <8 x bfloat> %b, i32 4
  %vset_lane = insertelement <4 x bfloat> %a, bfloat %vgetq_lane, i32 3
  ret <4 x bfloat> %vset_lane
}

; vcopyq_laneq_bf16(a, 3, b, 7);
define <8 x bfloat> @test_vcopyq_laneq_bf16_v1(<8 x bfloat> %a, <8 x bfloat> %b) nounwind {
; CHECK-LABEL: test_vcopyq_laneq_bf16_v1:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov v0.h[3], v1.h[7]
; CHECK-NEXT:    ret
entry:
  %vset_lane = shufflevector <8 x bfloat> %a, <8 x bfloat> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 15, i32 4, i32 5, i32 6, i32 7>
  ret <8 x bfloat> %vset_lane
}

; vcopyq_laneq_bf16(a, 6, b, 2);
define <8 x bfloat> @test_vcopyq_laneq_bf16_v2(<8 x bfloat> %a, <8 x bfloat> %b) nounwind {
; CHECK-LABEL: test_vcopyq_laneq_bf16_v2:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov v0.h[6], v1.h[2]
; CHECK-NEXT:    ret
entry:
  %vset_lane = shufflevector <8 x bfloat> %a, <8 x bfloat> %b, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 10, i32 7>
  ret <8 x bfloat> %vset_lane
}
