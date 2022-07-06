; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx700 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX7 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx801 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX8 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX900 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx906 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX906 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX10 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1100 -amdgpu-enable-delay-alu=0 -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX10 %s

define amdgpu_ps i32 @scalar_xnor_i32_one_use(i32 inreg %a, i32 inreg %b) {
; GCN-LABEL: scalar_xnor_i32_one_use:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_xnor_b32 s0, s0, s1
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: scalar_xnor_i32_one_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_xnor_b32 s0, s0, s1
; GFX10-NEXT:    ; return to shader part epilog
entry:
  %xor = xor i32 %a, %b
  %r0.val = xor i32 %xor, -1
  ret i32 %r0.val
}

; FIXME: fails to match
define amdgpu_ps i32 @scalar_xnor_v2i16_one_use(<2 x i16> inreg %a, <2 x i16> inreg %b) {
; GFX7-LABEL: scalar_xnor_v2i16_one_use:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_lshl_b32 s1, s1, 16
; GFX7-NEXT:    s_and_b32 s0, s0, 0xffff
; GFX7-NEXT:    s_or_b32 s0, s1, s0
; GFX7-NEXT:    s_lshl_b32 s1, s3, 16
; GFX7-NEXT:    s_and_b32 s2, s2, 0xffff
; GFX7-NEXT:    s_or_b32 s1, s1, s2
; GFX7-NEXT:    s_xor_b32 s0, s0, s1
; GFX7-NEXT:    s_xor_b32 s0, s0, -1
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: scalar_xnor_v2i16_one_use:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_mov_b32 s2, 0xffff
; GFX8-NEXT:    s_xor_b32 s0, s0, s1
; GFX8-NEXT:    s_mov_b32 s3, s2
; GFX8-NEXT:    s_lshr_b32 s1, s0, 16
; GFX8-NEXT:    s_and_b32 s0, s0, 0xffff
; GFX8-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GFX8-NEXT:    s_lshl_b32 s1, s1, 16
; GFX8-NEXT:    s_and_b32 s0, s0, 0xffff
; GFX8-NEXT:    s_or_b32 s0, s1, s0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX900-LABEL: scalar_xnor_v2i16_one_use:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_xor_b32 s0, s0, s1
; GFX900-NEXT:    s_xor_b32 s0, s0, -1
; GFX900-NEXT:    ; return to shader part epilog
;
; GFX906-LABEL: scalar_xnor_v2i16_one_use:
; GFX906:       ; %bb.0: ; %entry
; GFX906-NEXT:    s_xor_b32 s0, s0, s1
; GFX906-NEXT:    s_xor_b32 s0, s0, -1
; GFX906-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: scalar_xnor_v2i16_one_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_xor_b32 s0, s0, s1
; GFX10-NEXT:    s_xor_b32 s0, s0, -1
; GFX10-NEXT:    ; return to shader part epilog
entry:
  %xor = xor <2 x i16> %a, %b
  %r0.val = xor <2 x i16> %xor, <i16 -1, i16 -1>
  %cast = bitcast <2 x i16> %r0.val to i32
  ret i32 %cast
}

define amdgpu_ps <2 x i32> @scalar_xnor_i32_mul_use(i32 inreg %a, i32 inreg %b) {
; GCN-LABEL: scalar_xnor_i32_mul_use:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_xor_b32 s1, s0, s1
; GCN-NEXT:    s_not_b32 s2, s1
; GCN-NEXT:    s_add_i32 s1, s1, s0
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: scalar_xnor_i32_mul_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_xor_b32 s1, s0, s1
; GFX10-NEXT:    s_not_b32 s2, s1
; GFX10-NEXT:    s_add_i32 s1, s1, s0
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    ; return to shader part epilog
entry:
  %xor = xor i32 %a, %b
  %r0.val = xor i32 %xor, -1
  %r1.val = add i32 %xor, %a
  %ins0 = insertelement <2 x i32> undef, i32 %r0.val, i32 0
  %ins1 = insertelement <2 x i32> %ins0, i32 %r1.val, i32 1
  ret <2 x i32> %ins1
}

define amdgpu_ps i64 @scalar_xnor_i64_one_use(i64 inreg %a, i64 inreg %b) {
; GCN-LABEL: scalar_xnor_i64_one_use:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_xnor_b64 s[0:1], s[0:1], s[2:3]
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: scalar_xnor_i64_one_use:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_xnor_b64 s[0:1], s[0:1], s[2:3]
; GFX10-NEXT:    ; return to shader part epilog
  %xor = xor i64 %a, %b
  %r0.val = xor i64 %xor, -1
  ret i64 %r0.val
}

; FIXME: fails to match
define amdgpu_ps i64 @scalar_xnor_v4i16_one_use(<4 x i16> inreg %a, <4 x i16> inreg %b) {
; GFX7-LABEL: scalar_xnor_v4i16_one_use:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_lshl_b32 s1, s1, 16
; GFX7-NEXT:    s_and_b32 s0, s0, 0xffff
; GFX7-NEXT:    s_or_b32 s0, s1, s0
; GFX7-NEXT:    s_lshl_b32 s1, s3, 16
; GFX7-NEXT:    s_and_b32 s2, s2, 0xffff
; GFX7-NEXT:    s_or_b32 s1, s1, s2
; GFX7-NEXT:    s_lshl_b32 s2, s5, 16
; GFX7-NEXT:    s_and_b32 s3, s4, 0xffff
; GFX7-NEXT:    s_or_b32 s2, s2, s3
; GFX7-NEXT:    s_lshl_b32 s3, s7, 16
; GFX7-NEXT:    s_and_b32 s4, s6, 0xffff
; GFX7-NEXT:    s_or_b32 s3, s3, s4
; GFX7-NEXT:    s_mov_b32 s4, -1
; GFX7-NEXT:    s_mov_b32 s5, s4
; GFX7-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GFX7-NEXT:    s_xor_b64 s[0:1], s[0:1], s[4:5]
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: scalar_xnor_v4i16_one_use:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_mov_b32 s4, 0xffff
; GFX8-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GFX8-NEXT:    s_mov_b32 s5, s4
; GFX8-NEXT:    s_lshr_b32 s3, s0, 16
; GFX8-NEXT:    s_and_b32 s2, s0, 0xffff
; GFX8-NEXT:    s_lshr_b32 s7, s1, 16
; GFX8-NEXT:    s_and_b32 s6, s1, 0xffff
; GFX8-NEXT:    s_xor_b64 s[0:1], s[2:3], s[4:5]
; GFX8-NEXT:    s_xor_b64 s[2:3], s[6:7], s[4:5]
; GFX8-NEXT:    s_lshl_b32 s1, s1, 16
; GFX8-NEXT:    s_and_b32 s0, s0, 0xffff
; GFX8-NEXT:    s_or_b32 s0, s1, s0
; GFX8-NEXT:    s_lshl_b32 s1, s3, 16
; GFX8-NEXT:    s_and_b32 s2, s2, 0xffff
; GFX8-NEXT:    s_or_b32 s1, s1, s2
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX900-LABEL: scalar_xnor_v4i16_one_use:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    s_mov_b32 s4, -1
; GFX900-NEXT:    s_mov_b32 s5, s4
; GFX900-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GFX900-NEXT:    s_xor_b64 s[0:1], s[0:1], s[4:5]
; GFX900-NEXT:    ; return to shader part epilog
;
; GFX906-LABEL: scalar_xnor_v4i16_one_use:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_mov_b32 s4, -1
; GFX906-NEXT:    s_mov_b32 s5, s4
; GFX906-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GFX906-NEXT:    s_xor_b64 s[0:1], s[0:1], s[4:5]
; GFX906-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: scalar_xnor_v4i16_one_use:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s4, -1
; GFX10-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GFX10-NEXT:    s_mov_b32 s5, s4
; GFX10-NEXT:    s_xor_b64 s[0:1], s[0:1], s[4:5]
; GFX10-NEXT:    ; return to shader part epilog
  %xor = xor <4 x i16> %a, %b
  %ret = xor <4 x i16> %xor, <i16 -1, i16 -1, i16 -1, i16 -1>
  %cast = bitcast <4 x i16> %ret to i64
  ret i64 %cast
}

define amdgpu_ps <2 x i64> @scalar_xnor_i64_mul_use(i64 inreg %a, i64 inreg %b) {
; GCN-LABEL: scalar_xnor_i64_mul_use:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_xor_b64 s[2:3], s[0:1], s[2:3]
; GCN-NEXT:    s_not_b64 s[4:5], s[2:3]
; GCN-NEXT:    s_add_u32 s2, s2, s0
; GCN-NEXT:    s_addc_u32 s3, s3, s1
; GCN-NEXT:    s_mov_b32 s0, s4
; GCN-NEXT:    s_mov_b32 s1, s5
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: scalar_xnor_i64_mul_use:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_xor_b64 s[2:3], s[0:1], s[2:3]
; GFX10-NEXT:    s_not_b64 s[4:5], s[2:3]
; GFX10-NEXT:    s_add_u32 s2, s2, s0
; GFX10-NEXT:    s_addc_u32 s3, s3, s1
; GFX10-NEXT:    s_mov_b32 s0, s4
; GFX10-NEXT:    s_mov_b32 s1, s5
; GFX10-NEXT:    ; return to shader part epilog
  %xor = xor i64 %a, %b
  %r0.val = xor i64 %xor, -1
  %r1.val = add i64 %xor, %a
  %ins0 = insertelement <2 x i64> undef, i64 %r0.val, i32 0
  %ins1 = insertelement <2 x i64> %ins0, i64 %r1.val, i32 1
  ret <2 x i64> %ins1
}

define i32 @vector_xnor_i32_one_use(i32 %a, i32 %b) {
; GFX7-LABEL: vector_xnor_i32_one_use:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX7-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: vector_xnor_i32_one_use:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX8-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX900-LABEL: vector_xnor_i32_one_use:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX900-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX900-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX900-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: vector_xnor_i32_one_use:
; GFX906:       ; %bb.0: ; %entry
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_xnor_b32_e32 v0, v0, v1
; GFX906-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: vector_xnor_i32_one_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_xor3_b32 v0, v0, v1, -1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
entry:
  %xor = xor i32 %a, %b
  %r = xor i32 %xor, -1
  ret i32 %r
}

define i64 @vector_xnor_i64_one_use(i64 %a, i64 %b) {
; GCN-LABEL: vector_xnor_i64_one_use:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_xor_b32_e32 v0, v0, v2
; GCN-NEXT:    v_xor_b32_e32 v1, v1, v3
; GCN-NEXT:    v_xor_b32_e32 v0, -1, v0
; GCN-NEXT:    v_xor_b32_e32 v1, -1, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: vector_xnor_i64_one_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_xor_b32_e32 v0, v0, v2
; GFX10-NEXT:    v_xor_b32_e32 v1, v1, v3
; GFX10-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX10-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
entry:
  %xor = xor i64 %a, %b
  %r = xor i64 %xor, -1
  ret i64 %r
}

define amdgpu_ps float @xnor_s_v_i32_one_use(i32 inreg %s, i32 %v) {
; GFX7-LABEL: xnor_s_v_i32_one_use:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX7-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: xnor_s_v_i32_one_use:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX8-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX900-LABEL: xnor_s_v_i32_one_use:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX900-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX900-NEXT:    ; return to shader part epilog
;
; GFX906-LABEL: xnor_s_v_i32_one_use:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    v_xnor_b32_e32 v0, s0, v0
; GFX906-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xnor_s_v_i32_one_use:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_xor3_b32 v0, s0, v0, -1
; GFX10-NEXT:    ; return to shader part epilog
  %xor = xor i32 %s, %v
  %d = xor i32 %xor, -1
  %cast = bitcast i32 %d to float
  ret float %cast
}

define amdgpu_ps float @xnor_v_s_i32_one_use(i32 inreg %s, i32 %v) {
; GFX7-LABEL: xnor_v_s_i32_one_use:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX7-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: xnor_v_s_i32_one_use:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX8-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX900-LABEL: xnor_v_s_i32_one_use:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX900-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX900-NEXT:    ; return to shader part epilog
;
; GFX906-LABEL: xnor_v_s_i32_one_use:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    v_xnor_b32_e64 v0, v0, s0
; GFX906-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xnor_v_s_i32_one_use:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_xor3_b32 v0, v0, s0, -1
; GFX10-NEXT:    ; return to shader part epilog
  %xor = xor i32 %v, %s
  %d = xor i32 %xor, -1
  %cast = bitcast i32 %d to float
  ret float %cast
}

define amdgpu_ps <2 x float> @xnor_i64_s_v_one_use(i64 inreg %a, i64 %b64) {
; GFX7-LABEL: xnor_i64_s_v_one_use:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    v_lshl_b64 v[0:1], v[0:1], 29
; GFX7-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX7-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX7-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX7-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: xnor_i64_s_v_one_use:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    v_lshlrev_b64 v[0:1], 29, v[0:1]
; GFX8-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX8-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX900-LABEL: xnor_i64_s_v_one_use:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    v_lshlrev_b64 v[0:1], 29, v[0:1]
; GFX900-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX900-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX900-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX900-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX900-NEXT:    ; return to shader part epilog
;
; GFX906-LABEL: xnor_i64_s_v_one_use:
; GFX906:       ; %bb.0: ; %entry
; GFX906-NEXT:    v_lshlrev_b64 v[0:1], 29, v[0:1]
; GFX906-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX906-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX906-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX906-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX906-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xnor_i64_s_v_one_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    v_lshlrev_b64 v[0:1], 29, v[0:1]
; GFX10-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX10-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX10-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX10-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX10-NEXT:    ; return to shader part epilog
entry:
  %b = shl i64 %b64, 29
  %xor = xor i64 %a, %b
  %r0.val = xor i64 %xor, -1
  %cast = bitcast i64 %r0.val to <2 x float>
  ret <2 x float> %cast
}

define amdgpu_ps <2 x float> @xnor_i64_v_s_one_use(i64 inreg %a, i64 %b64) {
; GFX7-LABEL: xnor_i64_v_s_one_use:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    v_lshl_b64 v[0:1], v[0:1], 29
; GFX7-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX7-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX7-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX7-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: xnor_i64_v_s_one_use:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_lshlrev_b64 v[0:1], 29, v[0:1]
; GFX8-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX8-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX900-LABEL: xnor_i64_v_s_one_use:
; GFX900:       ; %bb.0:
; GFX900-NEXT:    v_lshlrev_b64 v[0:1], 29, v[0:1]
; GFX900-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX900-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX900-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX900-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX900-NEXT:    ; return to shader part epilog
;
; GFX906-LABEL: xnor_i64_v_s_one_use:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    v_lshlrev_b64 v[0:1], 29, v[0:1]
; GFX906-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX906-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX906-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX906-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX906-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: xnor_i64_v_s_one_use:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_lshlrev_b64 v[0:1], 29, v[0:1]
; GFX10-NEXT:    v_xor_b32_e32 v0, s0, v0
; GFX10-NEXT:    v_xor_b32_e32 v1, s1, v1
; GFX10-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX10-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX10-NEXT:    ; return to shader part epilog
  %b = shl i64 %b64, 29
  %xor = xor i64 %b, %a
  %r0.val = xor i64 %xor, -1
  %cast = bitcast i64 %r0.val to <2 x float>
  ret <2 x float> %cast
}

define i32 @vector_xor_na_b_i32_one_use(i32 %a, i32 %b) {
; GFX7-LABEL: vector_xor_na_b_i32_one_use:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX7-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: vector_xor_na_b_i32_one_use:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX8-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX900-LABEL: vector_xor_na_b_i32_one_use:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX900-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX900-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX900-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: vector_xor_na_b_i32_one_use:
; GFX906:       ; %bb.0: ; %entry
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_xnor_b32_e32 v0, v0, v1
; GFX906-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: vector_xor_na_b_i32_one_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_xor3_b32 v0, v0, -1, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
entry:
  %na = xor i32 %a, -1
  %r = xor i32 %na, %b
  ret i32 %r
}

define i32 @vector_xor_a_nb_i32_one_use(i32 %a, i32 %b) {
; GFX7-LABEL: vector_xor_a_nb_i32_one_use:
; GFX7:       ; %bb.0: ; %entry
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX7-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: vector_xor_a_nb_i32_one_use:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX8-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX900-LABEL: vector_xor_a_nb_i32_one_use:
; GFX900:       ; %bb.0: ; %entry
; GFX900-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX900-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX900-NEXT:    v_xor_b32_e32 v0, v0, v1
; GFX900-NEXT:    s_setpc_b64 s[30:31]
;
; GFX906-LABEL: vector_xor_a_nb_i32_one_use:
; GFX906:       ; %bb.0: ; %entry
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_xnor_b32_e32 v0, v1, v0
; GFX906-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: vector_xor_a_nb_i32_one_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_xor3_b32 v0, v1, -1, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
entry:
  %nb = xor i32 %b, -1
  %r = xor i32 %a, %nb
  ret i32 %r
}

define amdgpu_ps <2 x i32> @scalar_xor_a_nb_i64_one_use(i64 inreg %a, i64 inreg %b) {
; GCN-LABEL: scalar_xor_a_nb_i64_one_use:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_not_b64 s[2:3], s[2:3]
; GCN-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: scalar_xor_a_nb_i64_one_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_not_b64 s[2:3], s[2:3]
; GFX10-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GFX10-NEXT:    ; return to shader part epilog
entry:
  %nb = xor i64 %b, -1
  %r0.val = xor i64 %a, %nb
  %cast = bitcast i64 %r0.val to <2 x i32>
  ret <2 x i32> %cast
}

define amdgpu_ps <2 x i32> @scalar_xor_na_b_i64_one_use(i64 inreg %a, i64 inreg %b) {
; GCN-LABEL: scalar_xor_na_b_i64_one_use:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_not_b64 s[0:1], s[0:1]
; GCN-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: scalar_xor_na_b_i64_one_use:
; GFX10:       ; %bb.0: ; %entry
; GFX10-NEXT:    s_not_b64 s[0:1], s[0:1]
; GFX10-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GFX10-NEXT:    ; return to shader part epilog
entry:
  %na = xor i64 %a, -1
  %r0.val = xor i64 %na, %b
  %cast = bitcast i64 %r0.val to <2 x i32>
  ret <2 x i32> %cast
}
