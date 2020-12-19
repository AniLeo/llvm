; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=hawaii < %s | FileCheck -check-prefixes=GCN,CI %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=fiji < %s | FileCheck -check-prefixes=GCN,VI %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefixes=GCN,GFX9 %s

define double @v_trig_preop_f64(double %a, i32 %b) {
; GCN-LABEL: v_trig_preop_f64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_trig_preop_f64 v[0:1], v[0:1], v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %result = call double @llvm.amdgcn.trig.preop.f64(double %a, i32 %b)
  ret double %result
}

define double @v_trig_preop_f64_imm(double %a, i32 %b) {
; GCN-LABEL: v_trig_preop_f64_imm:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_trig_preop_f64 v[0:1], v[0:1], 7
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %result = call double @llvm.amdgcn.trig.preop.f64(double %a, i32 7)
  ret double %result
}

define amdgpu_kernel void @s_trig_preop_f64(double %a, i32 %b) {
; CI-LABEL: s_trig_preop_f64:
; CI:       ; %bb.0:
; CI-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; CI-NEXT:    s_load_dword s2, s[4:5], 0x2
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    v_mov_b32_e32 v0, s2
; CI-NEXT:    v_trig_preop_f64 v[0:1], s[0:1], v0
; CI-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; CI-NEXT:    s_waitcnt vmcnt(0)
; CI-NEXT:    s_endpgm
;
; VI-LABEL: s_trig_preop_f64:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; VI-NEXT:    s_load_dword s2, s[4:5], 0x8
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v0, s2
; VI-NEXT:    v_trig_preop_f64 v[0:1], s[0:1], v0
; VI-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0)
; VI-NEXT:    s_endpgm
;
; GFX9-LABEL: s_trig_preop_f64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; GFX9-NEXT:    s_load_dword s2, s[4:5], 0x8
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    v_trig_preop_f64 v[0:1], s[0:1], v0
; GFX9-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_endpgm
  %result = call double @llvm.amdgcn.trig.preop.f64(double %a, i32 %b)
  store volatile double %result, double* undef
  ret void
}

define amdgpu_kernel void @s_trig_preop_f64_imm(double %a, i32 %b) {
; GCN-LABEL: s_trig_preop_f64_imm:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[4:5], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_trig_preop_f64 v[0:1], s[0:1], 7
; GCN-NEXT:    flat_store_dwordx2 v[0:1], v[0:1]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_endpgm
  %result = call double @llvm.amdgcn.trig.preop.f64(double %a, i32 7)
  store volatile double %result, double* undef
  ret void
}

declare double @llvm.amdgcn.trig.preop.f64(double, i32) #0

attributes #0 = { nounwind readnone speculatable }
