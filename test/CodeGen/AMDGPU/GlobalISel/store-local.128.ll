; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck --check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=hawaii -verify-machineinstrs < %s | FileCheck --check-prefix=GFX7 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck --check-prefix=GFX10 %s

; FIXME:
; XUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=tahiti -verify-machineinstrs < %s | FileCheck --check-prefix=GFX6 %s

define amdgpu_kernel void @store_lds_v4i32(<4 x i32> addrspace(3)* %out, <4 x i32> %x) {
; GFX9-LABEL: store_lds_v4i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX9-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s4
; GFX9-NEXT:    v_mov_b32_e32 v1, s5
; GFX9-NEXT:    v_mov_b32_e32 v2, s6
; GFX9-NEXT:    v_mov_b32_e32 v3, s7
; GFX9-NEXT:    v_mov_b32_e32 v4, s2
; GFX9-NEXT:    ds_write_b128 v4, v[0:3]
; GFX9-NEXT:    s_endpgm
;
; GFX7-LABEL: store_lds_v4i32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x4
; GFX7-NEXT:    s_load_dword s0, s[0:1], 0x0
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    v_mov_b32_e32 v1, s5
; GFX7-NEXT:    v_mov_b32_e32 v2, s6
; GFX7-NEXT:    v_mov_b32_e32 v3, s7
; GFX7-NEXT:    v_mov_b32_e32 v4, s0
; GFX7-NEXT:    ds_write_b128 v4, v[0:3]
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: store_lds_v4i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s4
; GFX10-NEXT:    v_mov_b32_e32 v1, s5
; GFX10-NEXT:    v_mov_b32_e32 v2, s6
; GFX10-NEXT:    v_mov_b32_e32 v3, s7
; GFX10-NEXT:    v_mov_b32_e32 v4, s2
; GFX10-NEXT:    ds_write_b128 v4, v[0:3]
; GFX10-NEXT:    s_endpgm
  store <4 x i32> %x, <4 x i32> addrspace(3)* %out
  ret void
}

define amdgpu_kernel void @store_lds_v4i32_align1(<4 x i32> addrspace(3)* %out, <4 x i32> %x) {
; GFX9-LABEL: store_lds_v4i32_align1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX9-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX9-NEXT:    s_bfe_u32 s0, 8, 0x100000
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_bfe_u32 s3, s4, 0x100000
; GFX9-NEXT:    v_mov_b32_e32 v0, s4
; GFX9-NEXT:    s_lshr_b32 s3, s3, s0
; GFX9-NEXT:    v_mov_b32_e32 v1, s2
; GFX9-NEXT:    s_lshr_b32 s1, s4, 16
; GFX9-NEXT:    ds_write_b8 v1, v0
; GFX9-NEXT:    v_mov_b32_e32 v0, s3
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:1
; GFX9-NEXT:    s_lshr_b32 s2, s1, s0
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:2
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    s_bfe_u32 s2, s5, 0x100000
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:3
; GFX9-NEXT:    s_lshr_b32 s2, s2, s0
; GFX9-NEXT:    v_mov_b32_e32 v0, s5
; GFX9-NEXT:    s_lshr_b32 s1, s5, 16
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:4
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:5
; GFX9-NEXT:    s_lshr_b32 s2, s1, s0
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:6
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    s_bfe_u32 s2, s6, 0x100000
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:7
; GFX9-NEXT:    s_lshr_b32 s2, s2, s0
; GFX9-NEXT:    v_mov_b32_e32 v0, s6
; GFX9-NEXT:    s_lshr_b32 s1, s6, 16
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:8
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:9
; GFX9-NEXT:    s_lshr_b32 s2, s1, s0
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:10
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    s_bfe_u32 s2, s7, 0x100000
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:11
; GFX9-NEXT:    s_lshr_b32 s2, s2, s0
; GFX9-NEXT:    v_mov_b32_e32 v0, s7
; GFX9-NEXT:    s_lshr_b32 s1, s7, 16
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:12
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:13
; GFX9-NEXT:    s_lshr_b32 s0, s1, s0
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:14
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    ds_write_b8 v1, v0 offset:15
; GFX9-NEXT:    s_endpgm
;
; GFX7-LABEL: store_lds_v4i32_align1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x4
; GFX7-NEXT:    s_load_dword s0, s[0:1], 0x0
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_bfe_u32 s2, s4, 0x80008
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    v_mov_b32_e32 v1, s0
; GFX7-NEXT:    s_lshr_b32 s1, s4, 16
; GFX7-NEXT:    ds_write_b8 v1, v0
; GFX7-NEXT:    v_mov_b32_e32 v0, s2
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:1
; GFX7-NEXT:    s_lshr_b32 s0, s4, 24
; GFX7-NEXT:    v_mov_b32_e32 v0, s1
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:2
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:3
; GFX7-NEXT:    s_bfe_u32 s1, s5, 0x80008
; GFX7-NEXT:    v_mov_b32_e32 v0, s5
; GFX7-NEXT:    s_lshr_b32 s0, s5, 16
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:4
; GFX7-NEXT:    v_mov_b32_e32 v0, s1
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:5
; GFX7-NEXT:    s_lshr_b32 s1, s5, 24
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:6
; GFX7-NEXT:    v_mov_b32_e32 v0, s1
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:7
; GFX7-NEXT:    s_bfe_u32 s1, s6, 0x80008
; GFX7-NEXT:    v_mov_b32_e32 v0, s6
; GFX7-NEXT:    s_lshr_b32 s0, s6, 16
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:8
; GFX7-NEXT:    v_mov_b32_e32 v0, s1
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:9
; GFX7-NEXT:    s_lshr_b32 s1, s6, 24
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:10
; GFX7-NEXT:    v_mov_b32_e32 v0, s1
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:11
; GFX7-NEXT:    s_bfe_u32 s1, s7, 0x80008
; GFX7-NEXT:    v_mov_b32_e32 v0, s7
; GFX7-NEXT:    s_lshr_b32 s0, s7, 16
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:12
; GFX7-NEXT:    v_mov_b32_e32 v0, s1
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:13
; GFX7-NEXT:    s_lshr_b32 s1, s7, 24
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:14
; GFX7-NEXT:    v_mov_b32_e32 v0, s1
; GFX7-NEXT:    ds_write_b8 v1, v0 offset:15
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: store_lds_v4i32_align1:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_bfe_u32 s0, 8, 0x100000
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_bfe_u32 s3, s4, 0x100000
; GFX10-NEXT:    s_lshr_b32 s1, s4, 16
; GFX10-NEXT:    v_mov_b32_e32 v0, s4
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    s_lshr_b32 s2, s5, 16
; GFX10-NEXT:    s_bfe_u32 s4, s5, 0x100000
; GFX10-NEXT:    v_mov_b32_e32 v2, s5
; GFX10-NEXT:    s_lshr_b32 s3, s3, s0
; GFX10-NEXT:    s_lshr_b32 s5, s6, 16
; GFX10-NEXT:    s_bfe_u32 s8, s6, 0x100000
; GFX10-NEXT:    v_mov_b32_e32 v3, s6
; GFX10-NEXT:    s_lshr_b32 s6, s1, s0
; GFX10-NEXT:    v_mov_b32_e32 v4, s1
; GFX10-NEXT:    s_lshr_b32 s1, s4, s0
; GFX10-NEXT:    s_lshr_b32 s4, s2, s0
; GFX10-NEXT:    v_mov_b32_e32 v6, s3
; GFX10-NEXT:    v_mov_b32_e32 v7, s6
; GFX10-NEXT:    v_mov_b32_e32 v5, s2
; GFX10-NEXT:    s_lshr_b32 s2, s8, s0
; GFX10-NEXT:    v_mov_b32_e32 v8, s1
; GFX10-NEXT:    v_mov_b32_e32 v9, s4
; GFX10-NEXT:    ds_write_b8 v1, v0
; GFX10-NEXT:    ds_write_b8 v1, v2 offset:4
; GFX10-NEXT:    ds_write_b8 v1, v4 offset:2
; GFX10-NEXT:    ds_write_b8 v1, v6 offset:1
; GFX10-NEXT:    ds_write_b8 v1, v7 offset:3
; GFX10-NEXT:    ds_write_b8 v1, v8 offset:5
; GFX10-NEXT:    ds_write_b8 v1, v5 offset:6
; GFX10-NEXT:    v_mov_b32_e32 v0, s5
; GFX10-NEXT:    v_mov_b32_e32 v10, s2
; GFX10-NEXT:    s_lshr_b32 s1, s5, s0
; GFX10-NEXT:    ds_write_b8 v1, v9 offset:7
; GFX10-NEXT:    ds_write_b8 v1, v3 offset:8
; GFX10-NEXT:    ds_write_b8 v1, v10 offset:9
; GFX10-NEXT:    ds_write_b8 v1, v0 offset:10
; GFX10-NEXT:    v_mov_b32_e32 v0, s1
; GFX10-NEXT:    s_bfe_u32 s1, s7, 0x100000
; GFX10-NEXT:    s_lshr_b32 s2, s7, 16
; GFX10-NEXT:    s_lshr_b32 s1, s1, s0
; GFX10-NEXT:    v_mov_b32_e32 v2, s7
; GFX10-NEXT:    v_mov_b32_e32 v3, s1
; GFX10-NEXT:    s_lshr_b32 s0, s2, s0
; GFX10-NEXT:    v_mov_b32_e32 v4, s2
; GFX10-NEXT:    v_mov_b32_e32 v5, s0
; GFX10-NEXT:    ds_write_b8 v1, v0 offset:11
; GFX10-NEXT:    ds_write_b8 v1, v2 offset:12
; GFX10-NEXT:    ds_write_b8 v1, v3 offset:13
; GFX10-NEXT:    ds_write_b8 v1, v4 offset:14
; GFX10-NEXT:    ds_write_b8 v1, v5 offset:15
; GFX10-NEXT:    s_endpgm
  store <4 x i32> %x, <4 x i32> addrspace(3)* %out, align 1
  ret void
}

define amdgpu_kernel void @store_lds_v4i32_align2(<4 x i32> addrspace(3)* %out, <4 x i32> %x) {
; GFX9-LABEL: store_lds_v4i32_align2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX9-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_lshr_b32 s0, s4, 16
; GFX9-NEXT:    v_mov_b32_e32 v0, s4
; GFX9-NEXT:    v_mov_b32_e32 v1, s2
; GFX9-NEXT:    ds_write_b16 v1, v0
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    ds_write_b16 v1, v0 offset:2
; GFX9-NEXT:    s_lshr_b32 s0, s5, 16
; GFX9-NEXT:    v_mov_b32_e32 v0, s5
; GFX9-NEXT:    ds_write_b16 v1, v0 offset:4
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    ds_write_b16 v1, v0 offset:6
; GFX9-NEXT:    s_lshr_b32 s0, s6, 16
; GFX9-NEXT:    v_mov_b32_e32 v0, s6
; GFX9-NEXT:    ds_write_b16 v1, v0 offset:8
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    ds_write_b16 v1, v0 offset:10
; GFX9-NEXT:    s_lshr_b32 s0, s7, 16
; GFX9-NEXT:    v_mov_b32_e32 v0, s7
; GFX9-NEXT:    ds_write_b16 v1, v0 offset:12
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    ds_write_b16 v1, v0 offset:14
; GFX9-NEXT:    s_endpgm
;
; GFX7-LABEL: store_lds_v4i32_align2:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x4
; GFX7-NEXT:    s_load_dword s0, s[0:1], 0x0
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    s_lshr_b32 s1, s4, 16
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    v_mov_b32_e32 v1, s0
; GFX7-NEXT:    ds_write_b16 v1, v0
; GFX7-NEXT:    v_mov_b32_e32 v0, s1
; GFX7-NEXT:    ds_write_b16 v1, v0 offset:2
; GFX7-NEXT:    s_lshr_b32 s0, s5, 16
; GFX7-NEXT:    v_mov_b32_e32 v0, s5
; GFX7-NEXT:    ds_write_b16 v1, v0 offset:4
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    ds_write_b16 v1, v0 offset:6
; GFX7-NEXT:    s_lshr_b32 s0, s6, 16
; GFX7-NEXT:    v_mov_b32_e32 v0, s6
; GFX7-NEXT:    ds_write_b16 v1, v0 offset:8
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    ds_write_b16 v1, v0 offset:10
; GFX7-NEXT:    s_lshr_b32 s0, s7, 16
; GFX7-NEXT:    v_mov_b32_e32 v0, s7
; GFX7-NEXT:    ds_write_b16 v1, v0 offset:12
; GFX7-NEXT:    v_mov_b32_e32 v0, s0
; GFX7-NEXT:    ds_write_b16 v1, v0 offset:14
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: store_lds_v4i32_align2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s4
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    v_mov_b32_e32 v2, s5
; GFX10-NEXT:    s_lshr_b32 s0, s4, 16
; GFX10-NEXT:    v_mov_b32_e32 v3, s6
; GFX10-NEXT:    s_lshr_b32 s1, s5, 16
; GFX10-NEXT:    s_lshr_b32 s2, s6, 16
; GFX10-NEXT:    s_lshr_b32 s3, s7, 16
; GFX10-NEXT:    v_mov_b32_e32 v4, s7
; GFX10-NEXT:    v_mov_b32_e32 v5, s0
; GFX10-NEXT:    v_mov_b32_e32 v6, s1
; GFX10-NEXT:    v_mov_b32_e32 v7, s2
; GFX10-NEXT:    v_mov_b32_e32 v8, s3
; GFX10-NEXT:    ds_write_b16 v1, v0
; GFX10-NEXT:    ds_write_b16 v1, v2 offset:4
; GFX10-NEXT:    ds_write_b16 v1, v3 offset:8
; GFX10-NEXT:    ds_write_b16 v1, v4 offset:12
; GFX10-NEXT:    ds_write_b16 v1, v5 offset:2
; GFX10-NEXT:    ds_write_b16 v1, v6 offset:6
; GFX10-NEXT:    ds_write_b16 v1, v7 offset:10
; GFX10-NEXT:    ds_write_b16 v1, v8 offset:14
; GFX10-NEXT:    s_endpgm
  store <4 x i32> %x, <4 x i32> addrspace(3)* %out, align 2
  ret void
}

define amdgpu_kernel void @store_lds_v4i32_align4(<4 x i32> addrspace(3)* %out, <4 x i32> %x) {
; GFX9-LABEL: store_lds_v4i32_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX9-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s4
; GFX9-NEXT:    v_mov_b32_e32 v1, s2
; GFX9-NEXT:    v_mov_b32_e32 v2, s5
; GFX9-NEXT:    v_mov_b32_e32 v3, s6
; GFX9-NEXT:    ds_write2_b32 v1, v0, v2 offset1:1
; GFX9-NEXT:    v_mov_b32_e32 v0, s7
; GFX9-NEXT:    ds_write2_b32 v1, v3, v0 offset0:2 offset1:3
; GFX9-NEXT:    s_endpgm
;
; GFX7-LABEL: store_lds_v4i32_align4:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x4
; GFX7-NEXT:    s_load_dword s0, s[0:1], 0x0
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    v_mov_b32_e32 v1, s0
; GFX7-NEXT:    v_mov_b32_e32 v2, s5
; GFX7-NEXT:    ds_write2_b32 v1, v0, v2 offset1:1
; GFX7-NEXT:    v_mov_b32_e32 v0, s6
; GFX7-NEXT:    v_mov_b32_e32 v2, s7
; GFX7-NEXT:    ds_write2_b32 v1, v0, v2 offset0:2 offset1:3
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: store_lds_v4i32_align4:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s4
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    v_mov_b32_e32 v2, s5
; GFX10-NEXT:    v_mov_b32_e32 v3, s6
; GFX10-NEXT:    v_mov_b32_e32 v4, s7
; GFX10-NEXT:    ds_write2_b32 v1, v0, v2 offset1:1
; GFX10-NEXT:    ds_write2_b32 v1, v3, v4 offset0:2 offset1:3
; GFX10-NEXT:    s_endpgm
  store <4 x i32> %x, <4 x i32> addrspace(3)* %out, align 4
  ret void
}

define amdgpu_kernel void @store_lds_v4i32_align8(<4 x i32> addrspace(3)* %out, <4 x i32> %x) {
; GFX9-LABEL: store_lds_v4i32_align8:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX9-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s4
; GFX9-NEXT:    v_mov_b32_e32 v1, s5
; GFX9-NEXT:    v_mov_b32_e32 v2, s6
; GFX9-NEXT:    v_mov_b32_e32 v3, s7
; GFX9-NEXT:    v_mov_b32_e32 v4, s2
; GFX9-NEXT:    ds_write2_b64 v4, v[0:1], v[2:3] offset1:1
; GFX9-NEXT:    s_endpgm
;
; GFX7-LABEL: store_lds_v4i32_align8:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x4
; GFX7-NEXT:    s_load_dword s0, s[0:1], 0x0
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    v_mov_b32_e32 v1, s5
; GFX7-NEXT:    v_mov_b32_e32 v2, s6
; GFX7-NEXT:    v_mov_b32_e32 v3, s7
; GFX7-NEXT:    v_mov_b32_e32 v4, s0
; GFX7-NEXT:    ds_write2_b64 v4, v[0:1], v[2:3] offset1:1
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: store_lds_v4i32_align8:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s4
; GFX10-NEXT:    v_mov_b32_e32 v1, s2
; GFX10-NEXT:    v_mov_b32_e32 v2, s5
; GFX10-NEXT:    v_mov_b32_e32 v3, s6
; GFX10-NEXT:    v_mov_b32_e32 v4, s7
; GFX10-NEXT:    ds_write2_b32 v1, v0, v2 offset1:1
; GFX10-NEXT:    ds_write2_b32 v1, v3, v4 offset0:2 offset1:3
; GFX10-NEXT:    s_endpgm
  store <4 x i32> %x, <4 x i32> addrspace(3)* %out, align 8
  ret void
}

define amdgpu_kernel void @store_lds_v4i32_align16(<4 x i32> addrspace(3)* %out, <4 x i32> %x) {
; GFX9-LABEL: store_lds_v4i32_align16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX9-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s4
; GFX9-NEXT:    v_mov_b32_e32 v1, s5
; GFX9-NEXT:    v_mov_b32_e32 v2, s6
; GFX9-NEXT:    v_mov_b32_e32 v3, s7
; GFX9-NEXT:    v_mov_b32_e32 v4, s2
; GFX9-NEXT:    ds_write_b128 v4, v[0:3]
; GFX9-NEXT:    s_endpgm
;
; GFX7-LABEL: store_lds_v4i32_align16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x4
; GFX7-NEXT:    s_load_dword s0, s[0:1], 0x0
; GFX7-NEXT:    s_mov_b32 m0, -1
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, s4
; GFX7-NEXT:    v_mov_b32_e32 v1, s5
; GFX7-NEXT:    v_mov_b32_e32 v2, s6
; GFX7-NEXT:    v_mov_b32_e32 v3, s7
; GFX7-NEXT:    v_mov_b32_e32 v4, s0
; GFX7-NEXT:    ds_write_b128 v4, v[0:3]
; GFX7-NEXT:    s_endpgm
;
; GFX10-LABEL: store_lds_v4i32_align16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_clause 0x1
; GFX10-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x10
; GFX10-NEXT:    s_load_dword s2, s[0:1], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s4
; GFX10-NEXT:    v_mov_b32_e32 v1, s5
; GFX10-NEXT:    v_mov_b32_e32 v2, s6
; GFX10-NEXT:    v_mov_b32_e32 v3, s7
; GFX10-NEXT:    v_mov_b32_e32 v4, s2
; GFX10-NEXT:    ds_write_b128 v4, v[0:3]
; GFX10-NEXT:    s_endpgm
  store <4 x i32> %x, <4 x i32> addrspace(3)* %out, align 16
  ret void
}
