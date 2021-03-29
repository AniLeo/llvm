; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-mesa3d -mcpu=fiji -verify-machineinstrs < %s | FileCheck -check-prefix=VI %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-mesa3d -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-mesa3d -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s

; ===================================================================================
; V_ADD_LSHL_U32
; ===================================================================================

define amdgpu_ps float @add_shl(i32 %a, i32 %b, i32 %c) {
; VI-LABEL: add_shl:
; VI:       ; %bb.0:
; VI-NEXT:    v_add_u32_e32 v0, vcc, v0, v1
; VI-NEXT:    v_lshlrev_b32_e32 v0, v2, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: add_shl:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_add_lshl_u32 v0, v0, v1, v2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: add_shl:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_add_lshl_u32 v0, v0, v1, v2
; GFX10-NEXT:    ; return to shader part epilog
  %x = add i32 %a, %b
  %result = shl i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @add_shl_vgpr_c(i32 inreg %a, i32 inreg %b, i32 %c) {
; VI-LABEL: add_shl_vgpr_c:
; VI:       ; %bb.0:
; VI-NEXT:    s_add_i32 s2, s2, s3
; VI-NEXT:    v_lshlrev_b32_e64 v0, v0, s2
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: add_shl_vgpr_c:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_add_i32 s2, s2, s3
; GFX9-NEXT:    v_lshlrev_b32_e64 v0, v0, s2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: add_shl_vgpr_c:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_add_i32 s2, s2, s3
; GFX10-NEXT:    v_lshlrev_b32_e64 v0, v0, s2
; GFX10-NEXT:    ; return to shader part epilog
  %x = add i32 %a, %b
  %result = shl i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @add_shl_vgpr_ac(i32 %a, i32 inreg %b, i32 %c) {
; VI-LABEL: add_shl_vgpr_ac:
; VI:       ; %bb.0:
; VI-NEXT:    v_add_u32_e32 v0, vcc, s2, v0
; VI-NEXT:    v_lshlrev_b32_e32 v0, v1, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: add_shl_vgpr_ac:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_add_lshl_u32 v0, v0, s2, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: add_shl_vgpr_ac:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_add_lshl_u32 v0, v0, s2, v1
; GFX10-NEXT:    ; return to shader part epilog
  %x = add i32 %a, %b
  %result = shl i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @add_shl_vgpr_const(i32 %a, i32 %b) {
; VI-LABEL: add_shl_vgpr_const:
; VI:       ; %bb.0:
; VI-NEXT:    v_add_u32_e32 v0, vcc, v0, v1
; VI-NEXT:    v_lshlrev_b32_e32 v0, 9, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: add_shl_vgpr_const:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_add_lshl_u32 v0, v0, v1, 9
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: add_shl_vgpr_const:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_add_lshl_u32 v0, v0, v1, 9
; GFX10-NEXT:    ; return to shader part epilog
  %x = add i32 %a, %b
  %result = shl i32 %x, 9
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @add_shl_vgpr_const_inline_const(i32 %a) {
; VI-LABEL: add_shl_vgpr_const_inline_const:
; VI:       ; %bb.0:
; VI-NEXT:    v_add_u32_e32 v0, vcc, 0x3f4, v0
; VI-NEXT:    v_lshlrev_b32_e32 v0, 9, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: add_shl_vgpr_const_inline_const:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v1, 0x3f4
; GFX9-NEXT:    v_add_lshl_u32 v0, v0, v1, 9
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: add_shl_vgpr_const_inline_const:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_add_lshl_u32 v0, 0x3f4, v0, 9
; GFX10-NEXT:    ; return to shader part epilog
  %x = add i32 %a, 1012
  %result = shl i32 %x, 9
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @add_shl_vgpr_inline_const_x2(i32 %a) {
; VI-LABEL: add_shl_vgpr_inline_const_x2:
; VI:       ; %bb.0:
; VI-NEXT:    v_add_u32_e32 v0, vcc, 3, v0
; VI-NEXT:    v_lshlrev_b32_e32 v0, 9, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: add_shl_vgpr_inline_const_x2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_add_lshl_u32 v0, v0, 3, 9
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: add_shl_vgpr_inline_const_x2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_add_lshl_u32 v0, v0, 3, 9
; GFX10-NEXT:    ; return to shader part epilog
  %x = add i32 %a, 3
  %result = shl i32 %x, 9
  %bc = bitcast i32 %result to float
  ret float %bc
}
