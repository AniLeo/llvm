; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=fiji -verify-machineinstrs | FileCheck -check-prefix=VI %s
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx900 -verify-machineinstrs | FileCheck -check-prefix=GFX9 %s
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx1010 -verify-machineinstrs | FileCheck -check-prefix=GFX10 %s
; RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx1100 -amdgpu-enable-delay-alu=0 -verify-machineinstrs | FileCheck -check-prefix=GFX10 %s

; ===================================================================================
; V_LSHL_ADD_U32
; ===================================================================================

define amdgpu_ps float @shl_add(i32 %a, i32 %b, i32 %c) {
; VI-LABEL: shl_add:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, v1, v0
; VI-NEXT:    v_add_u32_e32 v0, vcc, v0, v2
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_add:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_add_u32 v0, v0, v1, v2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: shl_add:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_lshl_add_u32 v0, v0, v1, v2
; GFX10-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, %b
  %result = add i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

; ThreeOp instruction variant not used due to Constant Bus Limitations
define amdgpu_ps float @shl_add_vgpr_a(i32 %a, i32 inreg %b, i32 inreg %c) {
; VI-LABEL: shl_add_vgpr_a:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, s2, v0
; VI-NEXT:    v_add_u32_e32 v0, vcc, s3, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_add_vgpr_a:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, s2, v0
; GFX9-NEXT:    v_add_u32_e32 v0, s3, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: shl_add_vgpr_a:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_lshl_add_u32 v0, v0, s2, s3
; GFX10-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, %b
  %result = add i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_add_vgpr_all(i32 %a, i32 %b, i32 %c) {
; VI-LABEL: shl_add_vgpr_all:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, v1, v0
; VI-NEXT:    v_add_u32_e32 v0, vcc, v0, v2
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_add_vgpr_all:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_add_u32 v0, v0, v1, v2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: shl_add_vgpr_all:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_lshl_add_u32 v0, v0, v1, v2
; GFX10-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, %b
  %result = add i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_add_vgpr_ab(i32 %a, i32 %b, i32 inreg %c) {
; VI-LABEL: shl_add_vgpr_ab:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, v1, v0
; VI-NEXT:    v_add_u32_e32 v0, vcc, s2, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_add_vgpr_ab:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_add_u32 v0, v0, v1, s2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: shl_add_vgpr_ab:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_lshl_add_u32 v0, v0, v1, s2
; GFX10-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, %b
  %result = add i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @shl_add_vgpr_const(i32 %a, i32 %b) {
; VI-LABEL: shl_add_vgpr_const:
; VI:       ; %bb.0:
; VI-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; VI-NEXT:    v_add_u32_e32 v0, vcc, v0, v1
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: shl_add_vgpr_const:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshl_add_u32 v0, v0, 3, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: shl_add_vgpr_const:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_lshl_add_u32 v0, v0, 3, v1
; GFX10-NEXT:    ; return to shader part epilog
  %x = shl i32 %a, 3
  %result = add i32 %x, %b
  %bc = bitcast i32 %result to float
  ret float %bc
}
