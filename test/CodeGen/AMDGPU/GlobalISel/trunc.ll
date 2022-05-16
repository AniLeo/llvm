; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=bonaire -verify-machineinstrs < %s | FileCheck -check-prefix=GFX7 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=tonga -verify-machineinstrs < %s | FileCheck -check-prefix=GFX8 %s

define i16 @v_trunc_i32_to_i16(i32 %src) {
; GFX7-LABEL: v_trunc_i32_to_i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_trunc_i32_to_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
  %trunc = trunc i32 %src to i16
  ret i16 %trunc
}

define amdgpu_ps i16 @s_trunc_i32_to_i16(i32 inreg %src) {
; GFX7-LABEL: s_trunc_i32_to_i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_trunc_i32_to_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    ; return to shader part epilog
  %trunc = trunc i32 %src to i16
  ret i16 %trunc
}

define i16 @v_trunc_i64_to_i16(i64 %src) {
; GFX7-LABEL: v_trunc_i64_to_i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_trunc_i64_to_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
  %trunc = trunc i64 %src to i16
  ret i16 %trunc
}

define amdgpu_ps i16 @s_trunc_i64_to_i16(i64 inreg %src) {
; GFX7-LABEL: s_trunc_i64_to_i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_trunc_i64_to_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    ; return to shader part epilog
  %trunc = trunc i64 %src to i16
  ret i16 %trunc
}

define amdgpu_ps i16 @s_trunc_i128_to_i16(i128 inreg %src) {
; GFX7-LABEL: s_trunc_i128_to_i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_trunc_i128_to_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    ; return to shader part epilog
  %trunc = trunc i128 %src to i16
  ret i16 %trunc
}

define i16 @v_trunc_i128_to_i16(i128 %src) {
; GFX7-LABEL: v_trunc_i128_to_i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_trunc_i128_to_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
  %trunc = trunc i128 %src to i16
  ret i16 %trunc
}

define i32 @v_trunc_v2i32_to_v2i16(<2 x i32> %src) {
; GFX7-LABEL: v_trunc_v2i32_to_v2i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX7-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX7-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_trunc_v2i32_to_v2i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_sdwa v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PRESERVE src0_sel:WORD_0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
  %trunc = trunc <2 x i32> %src to <2 x i16>
  %cast = bitcast <2 x i16> %trunc to i32
  ret i32 %cast
}

define amdgpu_ps i32 @s_trunc_v2i32_to_v2i16(<2 x i32> inreg %src) {
; GFX7-LABEL: s_trunc_v2i32_to_v2i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_lshl_b32 s1, s1, 16
; GFX7-NEXT:    s_and_b32 s0, s0, 0xffff
; GFX7-NEXT:    s_or_b32 s0, s1, s0
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_trunc_v2i32_to_v2i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_lshl_b32 s1, s1, 16
; GFX8-NEXT:    s_and_b32 s0, s0, 0xffff
; GFX8-NEXT:    s_or_b32 s0, s1, s0
; GFX8-NEXT:    ; return to shader part epilog
  %trunc = trunc <2 x i32> %src to <2 x i16>
  %cast = bitcast <2 x i16> %trunc to i32
  ret i32 %cast
}

; ; FIXME: G_INSERT mishandled
; define <2 x i32> @v_trunc_v3i32_to_v3i16(<3 x i32> %src) {
;   %trunc = trunc <3 x i32> %src to <3 x i16>
;   %ext = shufflevector <3 x i16> %trunc, <3 x i16> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
;   %cast = bitcast <4 x i16> %ext to <2 x i32>
;   ret <2 x i32> %cast
; }

; ; FIXME: G_INSERT mishandled
; define amdgpu_ps <2 x i32> @s_trunc_v3i32_to_v3i16(<3 x i32> inreg %src) {
;   %trunc = trunc <3 x i32> %src to <3 x i16>
;   %ext = shufflevector <3 x i16> %trunc, <3 x i16> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
;   %cast = bitcast <4 x i16> %ext to <2 x i32>
;   ret <2 x i32> %cast
; }

define <2 x i32> @v_trunc_v4i32_to_v4i16(<4 x i32> %src) {
; GFX7-LABEL: v_trunc_v4i32_to_v4i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX7-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX7-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 16, v3
; GFX7-NEXT:    v_and_b32_e32 v2, 0xffff, v2
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_trunc_v4i32_to_v4i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_sdwa v2, v3 dst_sel:WORD_1 dst_unused:UNUSED_PRESERVE src0_sel:WORD_0
; GFX8-NEXT:    v_mov_b32_sdwa v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PRESERVE src0_sel:WORD_0
; GFX8-NEXT:    v_mov_b32_e32 v1, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
  %trunc = trunc <4 x i32> %src to <4 x i16>
  %cast = bitcast <4 x i16> %trunc to <2 x i32>
  ret <2 x i32> %cast
}

define amdgpu_ps <2 x i32> @s_trunc_v4i32_to_v4i16(<4 x i32> inreg %src) {
; GFX7-LABEL: s_trunc_v4i32_to_v4i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_lshl_b32 s1, s1, 16
; GFX7-NEXT:    s_and_b32 s0, s0, 0xffff
; GFX7-NEXT:    s_or_b32 s0, s1, s0
; GFX7-NEXT:    s_lshl_b32 s1, s3, 16
; GFX7-NEXT:    s_and_b32 s2, s2, 0xffff
; GFX7-NEXT:    s_or_b32 s1, s1, s2
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_trunc_v4i32_to_v4i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_lshl_b32 s1, s1, 16
; GFX8-NEXT:    s_and_b32 s0, s0, 0xffff
; GFX8-NEXT:    s_or_b32 s0, s1, s0
; GFX8-NEXT:    s_lshl_b32 s1, s3, 16
; GFX8-NEXT:    s_and_b32 s2, s2, 0xffff
; GFX8-NEXT:    s_or_b32 s1, s1, s2
; GFX8-NEXT:    ; return to shader part epilog
  %trunc = trunc <4 x i32> %src to <4 x i16>
  %cast = bitcast <4 x i16> %trunc to <2 x i32>
  ret <2 x i32> %cast
}
