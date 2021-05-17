; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn--amdpal -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN -enable-var-scope %s
; RUN: llc -global-isel -mtriple=amdgcn--amdpal -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN -enable-var-scope %s

; Callee with SGPR and VGPR arguments
define hidden amdgpu_gfx float @callee(float %v.arg0, float inreg %s.arg1) {
; GCN-LABEL: callee:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v0, s4, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %add = fadd float %v.arg0, %s.arg1
  ret float %add
}

define amdgpu_gfx float @caller(float %arg0) {
; GCN-LABEL: caller:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v0, 1.0, v0
; GCN-NEXT:    s_mov_b32 s4, 2.0
; GCN-NEXT:    s_getpc_b64 s[6:7]
; GCN-NEXT:    s_add_u32 s6, s6, callee@rel32@lo+4
; GCN-NEXT:    s_addc_u32 s7, s7, callee@rel32@hi+12
; GCN-NEXT:    s_setpc_b64 s[6:7]
  %add = fadd float %arg0, 1.0
  %call = tail call amdgpu_gfx float @callee(float %add, float 2.0)
  ret float %call
}
