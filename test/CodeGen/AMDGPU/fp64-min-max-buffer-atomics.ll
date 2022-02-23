; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=amdgcn -mcpu=verde -verify-machineinstrs | FileCheck %s -check-prefix=SI
; RUN: llc < %s -march=amdgcn -mcpu=hawaii -verify-machineinstrs | FileCheck %s  -check-prefix=GFX7
; RUN: llc < %s -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs | FileCheck %s -check-prefix=GFX10
; RUN: llc < %s -march=amdgcn -mcpu=gfx1030 -verify-machineinstrs | FileCheck %s -check-prefix=GFX1030

; RUN: llc < %s -global-isel -march=amdgcn -mcpu=verde -verify-machineinstrs | FileCheck %s -check-prefix=G_SI
; RUN: llc < %s -global-isel -march=amdgcn -mcpu=hawaii -verify-machineinstrs | FileCheck %s  -check-prefix=G_GFX7
; RUN: llc < %s -global-isel -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs | FileCheck %s -check-prefix=G_GFX10
; RUN: llc < %s -global-isel -march=amdgcn -mcpu=gfx1030 -verify-machineinstrs | FileCheck %s -check-prefix=G_GFX1030

declare double @llvm.amdgcn.raw.buffer.atomic.fmin.f64(double, <4 x i32>, i32, i32, i32 immarg)
declare double @llvm.amdgcn.raw.buffer.atomic.fmax.f64(double, <4 x i32>, i32, i32, i32 immarg)


define amdgpu_kernel void @raw_buffer_atomic_min_noret_f64(<4 x i32> inreg %rsrc, double %data, i32 %vindex) {
; SI-LABEL: raw_buffer_atomic_min_noret_f64:
; SI:       ; %bb.0: ; %main_body
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; SI-NEXT:    s_load_dword s6, s[0:1], 0xf
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s4
; SI-NEXT:    v_mov_b32_e32 v1, s5
; SI-NEXT:    v_mov_b32_e32 v2, s6
; SI-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen
; SI-NEXT:    s_endpgm
;
; GFX7-LABEL: raw_buffer_atomic_min_noret_f64:
; GFX7:       ; %bb.0: ; %main_body
; GFX7-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; GFX7-NEXT:    s_load_dword s6, s[0:1], 0xf
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    v_mov_b32_e32 v1, s5
; GFX7-NEXT:    v_mov_b32_e32 v2, s6
; GFX7-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: raw_buffer_atomic_min_noret_f64:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_clause 0x2
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    s_load_dword s8, s[0:1], 0x3c
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-NEXT:    v_mov_b32_e32 v2, s8
; GFX10-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[4:7], 0 offen
; GFX10-NEXT:    s_endpgm
;
; GFX1030-LABEL: raw_buffer_atomic_min_noret_f64:
; GFX1030:       ; %bb.0: ; %main_body
; GFX1030-NEXT:    s_clause 0x2
; GFX1030-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x34
; GFX1030-NEXT:    s_load_dword s6, s[0:1], 0x3c
; GFX1030-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX1030-NEXT:    s_waitcnt lgkmcnt(0)
; GFX1030-NEXT:    v_mov_b32_e32 v0, s4
; GFX1030-NEXT:    v_mov_b32_e32 v1, s5
; GFX1030-NEXT:    v_mov_b32_e32 v2, s6
; GFX1030-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen
; GFX1030-NEXT:    s_endpgm
;
; G_SI-LABEL: raw_buffer_atomic_min_noret_f64:
; G_SI:       ; %bb.0: ; %main_body
; G_SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; G_SI-NEXT:    s_load_dword s6, s[0:1], 0xf
; G_SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; G_SI-NEXT:    s_waitcnt lgkmcnt(0)
; G_SI-NEXT:    v_mov_b32_e32 v0, s4
; G_SI-NEXT:    v_mov_b32_e32 v1, s5
; G_SI-NEXT:    v_mov_b32_e32 v2, s6
; G_SI-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_SI-NEXT:    s_endpgm
;
; G_GFX7-LABEL: raw_buffer_atomic_min_noret_f64:
; G_GFX7:       ; %bb.0: ; %main_body
; G_GFX7-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; G_GFX7-NEXT:    s_load_dword s6, s[0:1], 0xf
; G_GFX7-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; G_GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; G_GFX7-NEXT:    v_mov_b32_e32 v0, s4
; G_GFX7-NEXT:    v_mov_b32_e32 v1, s5
; G_GFX7-NEXT:    v_mov_b32_e32 v2, s6
; G_GFX7-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX7-NEXT:    s_endpgm
;
; G_GFX10-LABEL: raw_buffer_atomic_min_noret_f64:
; G_GFX10:       ; %bb.0: ; %main_body
; G_GFX10-NEXT:    s_clause 0x2
; G_GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; G_GFX10-NEXT:    s_load_dword s8, s[0:1], 0x3c
; G_GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; G_GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; G_GFX10-NEXT:    v_mov_b32_e32 v0, s2
; G_GFX10-NEXT:    v_mov_b32_e32 v1, s3
; G_GFX10-NEXT:    v_mov_b32_e32 v2, s8
; G_GFX10-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[4:7], 0 offen glc
; G_GFX10-NEXT:    s_endpgm
;
; G_GFX1030-LABEL: raw_buffer_atomic_min_noret_f64:
; G_GFX1030:       ; %bb.0: ; %main_body
; G_GFX1030-NEXT:    s_clause 0x2
; G_GFX1030-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x34
; G_GFX1030-NEXT:    s_load_dword s6, s[0:1], 0x3c
; G_GFX1030-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; G_GFX1030-NEXT:    s_waitcnt lgkmcnt(0)
; G_GFX1030-NEXT:    v_mov_b32_e32 v0, s4
; G_GFX1030-NEXT:    v_mov_b32_e32 v1, s5
; G_GFX1030-NEXT:    v_mov_b32_e32 v2, s6
; G_GFX1030-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX1030-NEXT:    s_endpgm
main_body:
  %ret = call double @llvm.amdgcn.raw.buffer.atomic.fmin.f64(double %data, <4 x i32> %rsrc, i32 %vindex, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_min_rtn_f64(<4 x i32> inreg %rsrc, double %data, i32 %vindex) {
; SI-LABEL: raw_buffer_atomic_min_rtn_f64:
; SI:       ; %bb.0: ; %main_body
; SI-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; SI-NEXT:    s_mov_b32 m0, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    ds_write_b64 v0, v[0:1]
; SI-NEXT:    s_endpgm
;
; GFX7-LABEL: raw_buffer_atomic_min_rtn_f64:
; GFX7:       ; %bb.0: ; %main_body
; GFX7-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    ds_write_b64 v0, v[0:1]
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: raw_buffer_atomic_min_rtn_f64:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ds_write_b64 v0, v[0:1]
; GFX10-NEXT:    s_endpgm
;
; GFX1030-LABEL: raw_buffer_atomic_min_rtn_f64:
; GFX1030:       ; %bb.0: ; %main_body
; GFX1030-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; GFX1030-NEXT:    s_waitcnt vmcnt(0)
; GFX1030-NEXT:    ds_write_b64 v0, v[0:1]
; GFX1030-NEXT:    s_endpgm
;
; G_SI-LABEL: raw_buffer_atomic_min_rtn_f64:
; G_SI:       ; %bb.0: ; %main_body
; G_SI-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_SI-NEXT:    s_mov_b32 m0, -1
; G_SI-NEXT:    s_waitcnt vmcnt(0)
; G_SI-NEXT:    ds_write_b64 v0, v[0:1]
; G_SI-NEXT:    s_endpgm
;
; G_GFX7-LABEL: raw_buffer_atomic_min_rtn_f64:
; G_GFX7:       ; %bb.0: ; %main_body
; G_GFX7-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX7-NEXT:    s_mov_b32 m0, -1
; G_GFX7-NEXT:    s_waitcnt vmcnt(0)
; G_GFX7-NEXT:    ds_write_b64 v0, v[0:1]
; G_GFX7-NEXT:    s_endpgm
;
; G_GFX10-LABEL: raw_buffer_atomic_min_rtn_f64:
; G_GFX10:       ; %bb.0: ; %main_body
; G_GFX10-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX10-NEXT:    s_waitcnt vmcnt(0)
; G_GFX10-NEXT:    ds_write_b64 v0, v[0:1]
; G_GFX10-NEXT:    s_endpgm
;
; G_GFX1030-LABEL: raw_buffer_atomic_min_rtn_f64:
; G_GFX1030:       ; %bb.0: ; %main_body
; G_GFX1030-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX1030-NEXT:    s_waitcnt vmcnt(0)
; G_GFX1030-NEXT:    ds_write_b64 v0, v[0:1]
; G_GFX1030-NEXT:    s_endpgm
main_body:
  %ret = call double @llvm.amdgcn.raw.buffer.atomic.fmin.f64(double %data, <4 x i32> %rsrc, i32 %vindex, i32 0, i32 0)
  store double %ret, double addrspace(3)* undef
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_min_rtn_f64_off4_slc(<4 x i32> inreg %rsrc, double %data, i32 %vindex, double addrspace(3)* %out) {
; SI-LABEL: raw_buffer_atomic_min_rtn_f64_off4_slc:
; SI:       ; %bb.0: ; %main_body
; SI-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; SI-NEXT:    s_mov_b32 m0, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    ds_write_b64 v3, v[0:1]
; SI-NEXT:    s_endpgm
;
; GFX7-LABEL: raw_buffer_atomic_min_rtn_f64_off4_slc:
; GFX7:       ; %bb.0: ; %main_body
; GFX7-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    ds_write_b64 v3, v[0:1]
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: raw_buffer_atomic_min_rtn_f64_off4_slc:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ds_write_b64 v3, v[0:1]
; GFX10-NEXT:    s_endpgm
;
; GFX1030-LABEL: raw_buffer_atomic_min_rtn_f64_off4_slc:
; GFX1030:       ; %bb.0: ; %main_body
; GFX1030-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; GFX1030-NEXT:    s_waitcnt vmcnt(0)
; GFX1030-NEXT:    ds_write_b64 v3, v[0:1]
; GFX1030-NEXT:    s_endpgm
;
; G_SI-LABEL: raw_buffer_atomic_min_rtn_f64_off4_slc:
; G_SI:       ; %bb.0: ; %main_body
; G_SI-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; G_SI-NEXT:    s_mov_b32 m0, -1
; G_SI-NEXT:    s_waitcnt vmcnt(0)
; G_SI-NEXT:    ds_write_b64 v3, v[0:1]
; G_SI-NEXT:    s_endpgm
;
; G_GFX7-LABEL: raw_buffer_atomic_min_rtn_f64_off4_slc:
; G_GFX7:       ; %bb.0: ; %main_body
; G_GFX7-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; G_GFX7-NEXT:    s_mov_b32 m0, -1
; G_GFX7-NEXT:    s_waitcnt vmcnt(0)
; G_GFX7-NEXT:    ds_write_b64 v3, v[0:1]
; G_GFX7-NEXT:    s_endpgm
;
; G_GFX10-LABEL: raw_buffer_atomic_min_rtn_f64_off4_slc:
; G_GFX10:       ; %bb.0: ; %main_body
; G_GFX10-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; G_GFX10-NEXT:    s_waitcnt vmcnt(0)
; G_GFX10-NEXT:    ds_write_b64 v3, v[0:1]
; G_GFX10-NEXT:    s_endpgm
;
; G_GFX1030-LABEL: raw_buffer_atomic_min_rtn_f64_off4_slc:
; G_GFX1030:       ; %bb.0: ; %main_body
; G_GFX1030-NEXT:    buffer_atomic_fmin_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; G_GFX1030-NEXT:    s_waitcnt vmcnt(0)
; G_GFX1030-NEXT:    ds_write_b64 v3, v[0:1]
; G_GFX1030-NEXT:    s_endpgm
main_body:
  %ret = call double @llvm.amdgcn.raw.buffer.atomic.fmin.f64(double %data, <4 x i32> %rsrc, i32 %vindex, i32 4, i32 2)
  store double %ret, double addrspace(3)* %out, align 8
  ret void
}

define amdgpu_kernel void @raw_buffer_atomic_max_noret_f64(<4 x i32> inreg %rsrc, double %data, i32 %vindex) {
; SI-LABEL: raw_buffer_atomic_max_noret_f64:
; SI:       ; %bb.0: ; %main_body
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; SI-NEXT:    s_load_dword s6, s[0:1], 0xf
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s4
; SI-NEXT:    v_mov_b32_e32 v1, s5
; SI-NEXT:    v_mov_b32_e32 v2, s6
; SI-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen
; SI-NEXT:    s_endpgm
;
; GFX7-LABEL: raw_buffer_atomic_max_noret_f64:
; GFX7:       ; %bb.0: ; %main_body
; GFX7-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; GFX7-NEXT:    s_load_dword s6, s[0:1], 0xf
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    v_mov_b32_e32 v1, s5
; GFX7-NEXT:    v_mov_b32_e32 v2, s6
; GFX7-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: raw_buffer_atomic_max_noret_f64:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_clause 0x2
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    s_load_dword s8, s[0:1], 0x3c
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-NEXT:    v_mov_b32_e32 v2, s8
; GFX10-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[4:7], 0 offen
; GFX10-NEXT:    s_endpgm
;
; GFX1030-LABEL: raw_buffer_atomic_max_noret_f64:
; GFX1030:       ; %bb.0: ; %main_body
; GFX1030-NEXT:    s_clause 0x2
; GFX1030-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x34
; GFX1030-NEXT:    s_load_dword s6, s[0:1], 0x3c
; GFX1030-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX1030-NEXT:    s_waitcnt lgkmcnt(0)
; GFX1030-NEXT:    v_mov_b32_e32 v0, s4
; GFX1030-NEXT:    v_mov_b32_e32 v1, s5
; GFX1030-NEXT:    v_mov_b32_e32 v2, s6
; GFX1030-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen
; GFX1030-NEXT:    s_endpgm
;
; G_SI-LABEL: raw_buffer_atomic_max_noret_f64:
; G_SI:       ; %bb.0: ; %main_body
; G_SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; G_SI-NEXT:    s_load_dword s6, s[0:1], 0xf
; G_SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; G_SI-NEXT:    s_waitcnt lgkmcnt(0)
; G_SI-NEXT:    v_mov_b32_e32 v0, s4
; G_SI-NEXT:    v_mov_b32_e32 v1, s5
; G_SI-NEXT:    v_mov_b32_e32 v2, s6
; G_SI-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_SI-NEXT:    s_endpgm
;
; G_GFX7-LABEL: raw_buffer_atomic_max_noret_f64:
; G_GFX7:       ; %bb.0: ; %main_body
; G_GFX7-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; G_GFX7-NEXT:    s_load_dword s6, s[0:1], 0xf
; G_GFX7-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; G_GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; G_GFX7-NEXT:    v_mov_b32_e32 v0, s4
; G_GFX7-NEXT:    v_mov_b32_e32 v1, s5
; G_GFX7-NEXT:    v_mov_b32_e32 v2, s6
; G_GFX7-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX7-NEXT:    s_endpgm
;
; G_GFX10-LABEL: raw_buffer_atomic_max_noret_f64:
; G_GFX10:       ; %bb.0: ; %main_body
; G_GFX10-NEXT:    s_clause 0x2
; G_GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; G_GFX10-NEXT:    s_load_dword s8, s[0:1], 0x3c
; G_GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; G_GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; G_GFX10-NEXT:    v_mov_b32_e32 v0, s2
; G_GFX10-NEXT:    v_mov_b32_e32 v1, s3
; G_GFX10-NEXT:    v_mov_b32_e32 v2, s8
; G_GFX10-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[4:7], 0 offen glc
; G_GFX10-NEXT:    s_endpgm
;
; G_GFX1030-LABEL: raw_buffer_atomic_max_noret_f64:
; G_GFX1030:       ; %bb.0: ; %main_body
; G_GFX1030-NEXT:    s_clause 0x2
; G_GFX1030-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x34
; G_GFX1030-NEXT:    s_load_dword s6, s[0:1], 0x3c
; G_GFX1030-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; G_GFX1030-NEXT:    s_waitcnt lgkmcnt(0)
; G_GFX1030-NEXT:    v_mov_b32_e32 v0, s4
; G_GFX1030-NEXT:    v_mov_b32_e32 v1, s5
; G_GFX1030-NEXT:    v_mov_b32_e32 v2, s6
; G_GFX1030-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX1030-NEXT:    s_endpgm
main_body:
  %ret = call double @llvm.amdgcn.raw.buffer.atomic.fmax.f64(double %data, <4 x i32> %rsrc, i32 %vindex, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_atomic_max_rtn_f64(<4 x i32> inreg %rsrc, double %data, i32 %vindex) {
; SI-LABEL: raw_buffer_atomic_max_rtn_f64:
; SI:       ; %bb.0: ; %main_body
; SI-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; SI-NEXT:    s_mov_b32 m0, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    ds_write_b64 v0, v[0:1]
; SI-NEXT:    s_endpgm
;
; GFX7-LABEL: raw_buffer_atomic_max_rtn_f64:
; GFX7:       ; %bb.0: ; %main_body
; GFX7-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    ds_write_b64 v0, v[0:1]
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: raw_buffer_atomic_max_rtn_f64:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ds_write_b64 v0, v[0:1]
; GFX10-NEXT:    s_endpgm
;
; GFX1030-LABEL: raw_buffer_atomic_max_rtn_f64:
; GFX1030:       ; %bb.0: ; %main_body
; GFX1030-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; GFX1030-NEXT:    s_waitcnt vmcnt(0)
; GFX1030-NEXT:    ds_write_b64 v0, v[0:1]
; GFX1030-NEXT:    s_endpgm
;
; G_SI-LABEL: raw_buffer_atomic_max_rtn_f64:
; G_SI:       ; %bb.0: ; %main_body
; G_SI-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_SI-NEXT:    s_mov_b32 m0, -1
; G_SI-NEXT:    s_waitcnt vmcnt(0)
; G_SI-NEXT:    ds_write_b64 v0, v[0:1]
; G_SI-NEXT:    s_endpgm
;
; G_GFX7-LABEL: raw_buffer_atomic_max_rtn_f64:
; G_GFX7:       ; %bb.0: ; %main_body
; G_GFX7-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX7-NEXT:    s_mov_b32 m0, -1
; G_GFX7-NEXT:    s_waitcnt vmcnt(0)
; G_GFX7-NEXT:    ds_write_b64 v0, v[0:1]
; G_GFX7-NEXT:    s_endpgm
;
; G_GFX10-LABEL: raw_buffer_atomic_max_rtn_f64:
; G_GFX10:       ; %bb.0: ; %main_body
; G_GFX10-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX10-NEXT:    s_waitcnt vmcnt(0)
; G_GFX10-NEXT:    ds_write_b64 v0, v[0:1]
; G_GFX10-NEXT:    s_endpgm
;
; G_GFX1030-LABEL: raw_buffer_atomic_max_rtn_f64:
; G_GFX1030:       ; %bb.0: ; %main_body
; G_GFX1030-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 0 offen glc
; G_GFX1030-NEXT:    s_waitcnt vmcnt(0)
; G_GFX1030-NEXT:    ds_write_b64 v0, v[0:1]
; G_GFX1030-NEXT:    s_endpgm
main_body:
  %ret = call double @llvm.amdgcn.raw.buffer.atomic.fmax.f64(double %data, <4 x i32> %rsrc, i32 %vindex, i32 0, i32 0)
  store double %ret, double addrspace(3)* undef
  ret void
}

define amdgpu_kernel void @raw_buffer_atomic_max_rtn_f64_off4_slc(<4 x i32> inreg %rsrc, double %data, i32 %vindex, double addrspace(3)* %out) {
; SI-LABEL: raw_buffer_atomic_max_rtn_f64_off4_slc:
; SI:       ; %bb.0: ; %main_body
; SI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0xd
; SI-NEXT:    s_load_dword s8, s[0:1], 0xf
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_load_dword s0, s[0:1], 0x10
; SI-NEXT:    s_mov_b32 m0, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_mov_b32_e32 v0, s2
; SI-NEXT:    v_mov_b32_e32 v1, s3
; SI-NEXT:    v_mov_b32_e32 v2, s8
; SI-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[4:7], 4 offen glc slc
; SI-NEXT:    v_mov_b32_e32 v2, s0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    ds_write_b64 v2, v[0:1]
; SI-NEXT:    s_endpgm
;
; GFX7-LABEL: raw_buffer_atomic_max_rtn_f64_off4_slc:
; GFX7:       ; %bb.0: ; %main_body
; GFX7-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; GFX7-NEXT:    s_load_dwordx2 s[6:7], s[0:1], 0xf
; GFX7-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    v_mov_b32_e32 v1, s5
; GFX7-NEXT:    v_mov_b32_e32 v2, s6
; GFX7-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; GFX7-NEXT:    v_mov_b32_e32 v2, s7
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    ds_write_b64 v2, v[0:1]
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: raw_buffer_atomic_max_rtn_f64_off4_slc:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_clause 0x2
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX10-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x3c
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    v_mov_b32_e32 v1, s3
; GFX10-NEXT:    v_mov_b32_e32 v2, s8
; GFX10-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[4:7], 4 offen glc slc
; GFX10-NEXT:    v_mov_b32_e32 v2, s9
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ds_write_b64 v2, v[0:1]
; GFX10-NEXT:    s_endpgm
;
; GFX1030-LABEL: raw_buffer_atomic_max_rtn_f64_off4_slc:
; GFX1030:       ; %bb.0: ; %main_body
; GFX1030-NEXT:    s_clause 0x2
; GFX1030-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x34
; GFX1030-NEXT:    s_load_dwordx2 s[6:7], s[0:1], 0x3c
; GFX1030-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX1030-NEXT:    s_waitcnt lgkmcnt(0)
; GFX1030-NEXT:    v_mov_b32_e32 v0, s4
; GFX1030-NEXT:    v_mov_b32_e32 v1, s5
; GFX1030-NEXT:    v_mov_b32_e32 v2, s6
; GFX1030-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; GFX1030-NEXT:    v_mov_b32_e32 v2, s7
; GFX1030-NEXT:    s_waitcnt vmcnt(0)
; GFX1030-NEXT:    ds_write_b64 v2, v[0:1]
; GFX1030-NEXT:    s_endpgm
;
; G_SI-LABEL: raw_buffer_atomic_max_rtn_f64_off4_slc:
; G_SI:       ; %bb.0: ; %main_body
; G_SI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0xd
; G_SI-NEXT:    s_load_dword s8, s[0:1], 0xf
; G_SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; G_SI-NEXT:    s_load_dword s0, s[0:1], 0x10
; G_SI-NEXT:    s_mov_b32 m0, -1
; G_SI-NEXT:    s_waitcnt lgkmcnt(0)
; G_SI-NEXT:    v_mov_b32_e32 v0, s2
; G_SI-NEXT:    v_mov_b32_e32 v1, s3
; G_SI-NEXT:    v_mov_b32_e32 v2, s8
; G_SI-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[4:7], 4 offen glc slc
; G_SI-NEXT:    v_mov_b32_e32 v2, s0
; G_SI-NEXT:    s_waitcnt vmcnt(0)
; G_SI-NEXT:    ds_write_b64 v2, v[0:1]
; G_SI-NEXT:    s_endpgm
;
; G_GFX7-LABEL: raw_buffer_atomic_max_rtn_f64_off4_slc:
; G_GFX7:       ; %bb.0: ; %main_body
; G_GFX7-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0xd
; G_GFX7-NEXT:    s_load_dwordx2 s[6:7], s[0:1], 0xf
; G_GFX7-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; G_GFX7-NEXT:    s_mov_b32 m0, -1
; G_GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; G_GFX7-NEXT:    v_mov_b32_e32 v0, s4
; G_GFX7-NEXT:    v_mov_b32_e32 v1, s5
; G_GFX7-NEXT:    v_mov_b32_e32 v2, s6
; G_GFX7-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; G_GFX7-NEXT:    v_mov_b32_e32 v2, s7
; G_GFX7-NEXT:    s_waitcnt vmcnt(0)
; G_GFX7-NEXT:    ds_write_b64 v2, v[0:1]
; G_GFX7-NEXT:    s_endpgm
;
; G_GFX10-LABEL: raw_buffer_atomic_max_rtn_f64_off4_slc:
; G_GFX10:       ; %bb.0: ; %main_body
; G_GFX10-NEXT:    s_clause 0x2
; G_GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; G_GFX10-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x3c
; G_GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; G_GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; G_GFX10-NEXT:    v_mov_b32_e32 v0, s2
; G_GFX10-NEXT:    v_mov_b32_e32 v1, s3
; G_GFX10-NEXT:    v_mov_b32_e32 v2, s8
; G_GFX10-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[4:7], 4 offen glc slc
; G_GFX10-NEXT:    v_mov_b32_e32 v2, s9
; G_GFX10-NEXT:    s_waitcnt vmcnt(0)
; G_GFX10-NEXT:    ds_write_b64 v2, v[0:1]
; G_GFX10-NEXT:    s_endpgm
;
; G_GFX1030-LABEL: raw_buffer_atomic_max_rtn_f64_off4_slc:
; G_GFX1030:       ; %bb.0: ; %main_body
; G_GFX1030-NEXT:    s_clause 0x2
; G_GFX1030-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x34
; G_GFX1030-NEXT:    s_load_dwordx2 s[6:7], s[0:1], 0x3c
; G_GFX1030-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; G_GFX1030-NEXT:    s_waitcnt lgkmcnt(0)
; G_GFX1030-NEXT:    v_mov_b32_e32 v0, s4
; G_GFX1030-NEXT:    v_mov_b32_e32 v1, s5
; G_GFX1030-NEXT:    v_mov_b32_e32 v2, s6
; G_GFX1030-NEXT:    buffer_atomic_fmax_x2 v[0:1], v2, s[0:3], 4 offen glc slc
; G_GFX1030-NEXT:    v_mov_b32_e32 v2, s7
; G_GFX1030-NEXT:    s_waitcnt vmcnt(0)
; G_GFX1030-NEXT:    ds_write_b64 v2, v[0:1]
; G_GFX1030-NEXT:    s_endpgm
main_body:
  %ret = call double @llvm.amdgcn.raw.buffer.atomic.fmax.f64(double %data, <4 x i32> %rsrc, i32 %vindex, i32 4, i32 2)
  store double %ret, double addrspace(3)* %out, align 8
  ret void
}
