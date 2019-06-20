; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
;RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=fiji -verify-machineinstrs | FileCheck -check-prefix=VI %s
;RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx900 -verify-machineinstrs | FileCheck -check-prefix=GFX9 %s
;RUN: llc < %s -mtriple=amdgcn-amd-mesa3d -mcpu=gfx1010 -verify-machineinstrs | FileCheck -check-prefix=GFX10 %s

; ===================================================================================
; V_AND_OR_B32
; ===================================================================================

define amdgpu_ps float @and_or(i32 %a, i32 %b, i32 %c) {
; VI-LABEL: and_or:
; VI:       ; %bb.0:
; VI-NEXT:    v_and_b32_e32 v0, v0, v1
; VI-NEXT:    v_or_b32_e32 v0, v0, v2
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: and_or:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_and_or_b32 v0, v0, v1, v2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: and_or:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_and_or_b32 v0, v0, v1, v2
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = and i32 %a, %b
  %result = or i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

; ThreeOp instruction variant not used due to Constant Bus Limitations
define amdgpu_ps float @and_or_vgpr_b(i32 inreg %a, i32 %b, i32 inreg %c) {
; VI-LABEL: and_or_vgpr_b:
; VI:       ; %bb.0:
; VI-NEXT:    v_and_b32_e32 v0, s2, v0
; VI-NEXT:    v_or_b32_e32 v0, s3, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: and_or_vgpr_b:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_and_b32_e32 v0, s2, v0
; GFX9-NEXT:    v_or_b32_e32 v0, s3, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: and_or_vgpr_b:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_and_or_b32 v0, s2, v0, s3
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = and i32 %a, %b
  %result = or i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @and_or_vgpr_ab(i32 %a, i32 %b, i32 inreg %c) {
; VI-LABEL: and_or_vgpr_ab:
; VI:       ; %bb.0:
; VI-NEXT:    v_and_b32_e32 v0, v0, v1
; VI-NEXT:    v_or_b32_e32 v0, s2, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: and_or_vgpr_ab:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_and_or_b32 v0, v0, v1, s2
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: and_or_vgpr_ab:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_and_or_b32 v0, v0, v1, s2
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = and i32 %a, %b
  %result = or i32 %x, %c
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @and_or_vgpr_const(i32 %a, i32 %b) {
; VI-LABEL: and_or_vgpr_const:
; VI:       ; %bb.0:
; VI-NEXT:    v_and_b32_e32 v0, 4, v0
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: and_or_vgpr_const:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_and_or_b32 v0, v0, 4, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: and_or_vgpr_const:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_and_or_b32 v0, v0, 4, v1
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = and i32 4, %a
  %result = or i32 %x, %b
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @and_or_vgpr_const_inline_const(i32 %a) {
; VI-LABEL: and_or_vgpr_const_inline_const:
; VI:       ; %bb.0:
; VI-NEXT:    v_and_b32_e32 v0, 20, v0
; VI-NEXT:    v_or_b32_e32 v0, 0x808, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: and_or_vgpr_const_inline_const:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v1, 0x808
; GFX9-NEXT:    v_and_or_b32 v0, v0, 20, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: and_or_vgpr_const_inline_const:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_and_or_b32 v0, v0, 20, 0x808
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = and i32 20, %a
  %result = or i32 %x, 2056
  %bc = bitcast i32 %result to float
  ret float %bc
}

define amdgpu_ps float @and_or_vgpr_inline_const_x2(i32 %a) {
; VI-LABEL: and_or_vgpr_inline_const_x2:
; VI:       ; %bb.0:
; VI-NEXT:    v_and_b32_e32 v0, 4, v0
; VI-NEXT:    v_or_b32_e32 v0, 1, v0
; VI-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: and_or_vgpr_inline_const_x2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_and_or_b32 v0, v0, 4, 1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: and_or_vgpr_inline_const_x2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_and_or_b32 v0, v0, 4, 1
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    ; return to shader part epilog
  %x = and i32 4, %a
  %result = or i32 %x, 1
  %bc = bitcast i32 %result to float
  ret float %bc
}
