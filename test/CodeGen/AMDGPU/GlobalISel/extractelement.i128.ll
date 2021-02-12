; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX8 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=hawaii -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX7 %s

define amdgpu_ps i128 @extractelement_sgpr_v4i128_sgpr_idx(<4 x i128> addrspace(4)* inreg %ptr, i32 inreg %idx) {
; GCN-LABEL: extractelement_sgpr_v4i128_sgpr_idx:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx16 s[8:23], s[2:3], 0x0
; GCN-NEXT:    s_lshl_b32 m0, s4, 1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_movrels_b64 s[0:1], s[8:9]
; GCN-NEXT:    s_movrels_b64 s[2:3], s[10:11]
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i128>, <4 x i128> addrspace(4)* %ptr
  %element = extractelement <4 x i128> %vector, i32 %idx
  ret i128 %element
}

define amdgpu_ps i128 @extractelement_vgpr_v4i128_sgpr_idx(<4 x i128> addrspace(1)* %ptr, i32 inreg %idx) {
; GFX9-LABEL: extractelement_vgpr_v4i128_sgpr_idx:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    global_load_dwordx4 v[2:5], v[0:1], off
; GFX9-NEXT:    global_load_dwordx4 v[6:9], v[0:1], off offset:16
; GFX9-NEXT:    global_load_dwordx4 v[10:13], v[0:1], off offset:32
; GFX9-NEXT:    global_load_dwordx4 v[14:17], v[0:1], off offset:48
; GFX9-NEXT:    s_lshl_b32 s0, s2, 1
; GFX9-NEXT:    s_lshl_b32 s2, s0, 1
; GFX9-NEXT:    s_set_gpr_idx_on s2, gpr_idx(SRC0)
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, v2
; GFX9-NEXT:    v_mov_b32_e32 v1, v3
; GFX9-NEXT:    v_mov_b32_e32 v18, v2
; GFX9-NEXT:    v_mov_b32_e32 v3, v3
; GFX9-NEXT:    s_set_gpr_idx_off
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    v_readfirstlane_b32 s1, v1
; GFX9-NEXT:    v_readfirstlane_b32 s2, v18
; GFX9-NEXT:    v_readfirstlane_b32 s3, v3
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: extractelement_vgpr_v4i128_sgpr_idx:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_add_u32_e32 v6, vcc, 16, v0
; GFX8-NEXT:    v_addc_u32_e32 v7, vcc, 0, v1, vcc
; GFX8-NEXT:    v_add_u32_e32 v10, vcc, 32, v0
; GFX8-NEXT:    v_addc_u32_e32 v11, vcc, 0, v1, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[2:5], v[0:1]
; GFX8-NEXT:    flat_load_dwordx4 v[6:9], v[6:7]
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, 48, v0
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[10:13], v[10:11]
; GFX8-NEXT:    flat_load_dwordx4 v[14:17], v[0:1]
; GFX8-NEXT:    s_lshl_b32 s0, s2, 1
; GFX8-NEXT:    s_lshl_b32 m0, s0, 1
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_movrels_b32_e32 v1, v3
; GFX8-NEXT:    v_movrels_b32_e32 v0, v2
; GFX8-NEXT:    v_mov_b32_e32 v3, v1
; GFX8-NEXT:    v_mov_b32_e32 v2, v0
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    v_readfirstlane_b32 s2, v2
; GFX8-NEXT:    v_readfirstlane_b32 s3, v3
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: extractelement_vgpr_v4i128_sgpr_idx:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[2:5], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    buffer_load_dwordx4 v[6:9], v[0:1], s[4:7], 0 addr64 offset:16
; GFX7-NEXT:    buffer_load_dwordx4 v[10:13], v[0:1], s[4:7], 0 addr64 offset:32
; GFX7-NEXT:    buffer_load_dwordx4 v[14:17], v[0:1], s[4:7], 0 addr64 offset:48
; GFX7-NEXT:    s_lshl_b32 s0, s2, 1
; GFX7-NEXT:    s_lshl_b32 m0, s0, 1
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_movrels_b32_e32 v1, v3
; GFX7-NEXT:    v_movrels_b32_e32 v0, v2
; GFX7-NEXT:    v_mov_b32_e32 v3, v1
; GFX7-NEXT:    v_mov_b32_e32 v2, v0
; GFX7-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-NEXT:    v_readfirstlane_b32 s1, v1
; GFX7-NEXT:    v_readfirstlane_b32 s2, v2
; GFX7-NEXT:    v_readfirstlane_b32 s3, v3
; GFX7-NEXT:    ; return to shader part epilog
  %vector = load <4 x i128>, <4 x i128> addrspace(1)* %ptr
  %element = extractelement <4 x i128> %vector, i32 %idx
  ret i128 %element
}

define i128 @extractelement_vgpr_v4i128_vgpr_idx(<4 x i128> addrspace(1)* %ptr, i32 %idx) {
; GFX9-LABEL: extractelement_vgpr_v4i128_vgpr_idx:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_lshlrev_b32_e32 v16, 1, v2
; GFX9-NEXT:    global_load_dwordx4 v[2:5], v[0:1], off
; GFX9-NEXT:    global_load_dwordx4 v[6:9], v[0:1], off offset:16
; GFX9-NEXT:    v_add_u32_e32 v17, 1, v16
; GFX9-NEXT:    v_cmp_eq_u32_e64 s[4:5], 1, v16
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v17
; GFX9-NEXT:    v_cmp_eq_u32_e64 s[6:7], 6, v16
; GFX9-NEXT:    v_cmp_eq_u32_e64 s[8:9], 7, v16
; GFX9-NEXT:    s_waitcnt vmcnt(1)
; GFX9-NEXT:    v_cndmask_b32_e64 v10, v2, v4, s[4:5]
; GFX9-NEXT:    v_cndmask_b32_e64 v11, v3, v5, s[4:5]
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v4, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v3, v5, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v16
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_cndmask_b32_e32 v4, v10, v6, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v5, v11, v7, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v17
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v6, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v3, v7, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v16
; GFX9-NEXT:    v_cndmask_b32_e32 v4, v4, v8, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v5, v5, v9, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v17
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v8, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v3, v9, vcc
; GFX9-NEXT:    global_load_dwordx4 v[8:11], v[0:1], off offset:32
; GFX9-NEXT:    global_load_dwordx4 v[12:15], v[0:1], off offset:48
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v16
; GFX9-NEXT:    v_cmp_eq_u32_e64 s[4:5], 7, v17
; GFX9-NEXT:    s_waitcnt vmcnt(1)
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v4, v8, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v1, v5, v9, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v17
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v8, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v3, v9, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v16
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v0, v10, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v1, v1, v11, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v17
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v10, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v3, v11, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 6, v17
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v12, vcc
; GFX9-NEXT:    v_cndmask_b32_e64 v0, v0, v12, s[6:7]
; GFX9-NEXT:    v_cndmask_b32_e64 v1, v1, v13, s[6:7]
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v3, v13, vcc
; GFX9-NEXT:    v_cndmask_b32_e64 v0, v0, v14, s[8:9]
; GFX9-NEXT:    v_cndmask_b32_e64 v1, v1, v15, s[8:9]
; GFX9-NEXT:    v_cndmask_b32_e64 v2, v2, v14, s[4:5]
; GFX9-NEXT:    v_cndmask_b32_e64 v3, v3, v15, s[4:5]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i128_vgpr_idx:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_add_u32_e32 v3, vcc, 16, v0
; GFX8-NEXT:    v_addc_u32_e32 v4, vcc, 0, v1, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[8:11], v[0:1]
; GFX8-NEXT:    flat_load_dwordx4 v[4:7], v[3:4]
; GFX8-NEXT:    v_lshlrev_b32_e32 v16, 1, v2
; GFX8-NEXT:    v_add_u32_e32 v17, vcc, 1, v16
; GFX8-NEXT:    v_cmp_eq_u32_e64 s[4:5], 1, v16
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v17
; GFX8-NEXT:    v_cmp_eq_u32_e64 s[6:7], 6, v16
; GFX8-NEXT:    v_cmp_eq_u32_e64 s[8:9], 7, v16
; GFX8-NEXT:    s_waitcnt vmcnt(1)
; GFX8-NEXT:    v_cndmask_b32_e64 v2, v8, v10, s[4:5]
; GFX8-NEXT:    v_cndmask_b32_e64 v3, v9, v11, s[4:5]
; GFX8-NEXT:    v_cndmask_b32_e32 v8, v8, v10, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v9, v9, v11, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v16
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v2, v4, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v3, v3, v5, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v17
; GFX8-NEXT:    v_cndmask_b32_e32 v4, v8, v4, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v5, v9, v5, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v16
; GFX8-NEXT:    v_cndmask_b32_e32 v18, v2, v6, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v19, v3, v7, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v17
; GFX8-NEXT:    v_cndmask_b32_e32 v4, v4, v6, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v5, v5, v7, vcc
; GFX8-NEXT:    v_add_u32_e32 v2, vcc, 32, v0
; GFX8-NEXT:    v_addc_u32_e32 v3, vcc, 0, v1, vcc
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, 48, v0
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[8:11], v[2:3]
; GFX8-NEXT:    flat_load_dwordx4 v[12:15], v[0:1]
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v16
; GFX8-NEXT:    v_cmp_eq_u32_e64 s[4:5], 7, v17
; GFX8-NEXT:    s_waitcnt vmcnt(1)
; GFX8-NEXT:    v_cndmask_b32_e32 v0, v18, v8, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v1, v19, v9, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v17
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v4, v8, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v3, v5, v9, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v16
; GFX8-NEXT:    v_cndmask_b32_e32 v0, v0, v10, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v1, v1, v11, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v17
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v2, v10, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v3, v3, v11, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 6, v17
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v2, v12, vcc
; GFX8-NEXT:    v_cndmask_b32_e64 v0, v0, v12, s[6:7]
; GFX8-NEXT:    v_cndmask_b32_e64 v1, v1, v13, s[6:7]
; GFX8-NEXT:    v_cndmask_b32_e32 v3, v3, v13, vcc
; GFX8-NEXT:    v_cndmask_b32_e64 v0, v0, v14, s[8:9]
; GFX8-NEXT:    v_cndmask_b32_e64 v1, v1, v15, s[8:9]
; GFX8-NEXT:    v_cndmask_b32_e64 v2, v2, v14, s[4:5]
; GFX8-NEXT:    v_cndmask_b32_e64 v3, v3, v15, s[4:5]
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i128_vgpr_idx:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s10, 0
; GFX7-NEXT:    s_mov_b32 s11, 0xf000
; GFX7-NEXT:    s_mov_b64 s[8:9], 0
; GFX7-NEXT:    v_lshlrev_b32_e32 v16, 1, v2
; GFX7-NEXT:    buffer_load_dwordx4 v[2:5], v[0:1], s[8:11], 0 addr64
; GFX7-NEXT:    buffer_load_dwordx4 v[6:9], v[0:1], s[8:11], 0 addr64 offset:16
; GFX7-NEXT:    v_add_i32_e32 v17, vcc, 1, v16
; GFX7-NEXT:    v_cmp_eq_u32_e64 s[4:5], 1, v16
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v17
; GFX7-NEXT:    v_cmp_eq_u32_e64 s[6:7], 6, v16
; GFX7-NEXT:    s_waitcnt vmcnt(1)
; GFX7-NEXT:    v_cndmask_b32_e64 v10, v2, v4, s[4:5]
; GFX7-NEXT:    v_cndmask_b32_e64 v11, v3, v5, s[4:5]
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v4, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v3, v5, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v16
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_cndmask_b32_e32 v4, v10, v6, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v5, v11, v7, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v17
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v6, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v3, v7, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v16
; GFX7-NEXT:    v_cndmask_b32_e32 v4, v4, v8, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v5, v5, v9, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v17
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v8, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v3, v9, vcc
; GFX7-NEXT:    buffer_load_dwordx4 v[8:11], v[0:1], s[8:11], 0 addr64 offset:32
; GFX7-NEXT:    buffer_load_dwordx4 v[12:15], v[0:1], s[8:11], 0 addr64 offset:48
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v16
; GFX7-NEXT:    v_cmp_eq_u32_e64 s[4:5], 7, v17
; GFX7-NEXT:    v_cmp_eq_u32_e64 s[8:9], 7, v16
; GFX7-NEXT:    s_waitcnt vmcnt(1)
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v4, v8, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v1, v5, v9, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v17
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v8, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v3, v9, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v16
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v0, v10, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v1, v1, v11, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v17
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v10, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v3, v11, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 6, v17
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v12, vcc
; GFX7-NEXT:    v_cndmask_b32_e64 v0, v0, v12, s[6:7]
; GFX7-NEXT:    v_cndmask_b32_e64 v1, v1, v13, s[6:7]
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v3, v13, vcc
; GFX7-NEXT:    v_cndmask_b32_e64 v0, v0, v14, s[8:9]
; GFX7-NEXT:    v_cndmask_b32_e64 v1, v1, v15, s[8:9]
; GFX7-NEXT:    v_cndmask_b32_e64 v2, v2, v14, s[4:5]
; GFX7-NEXT:    v_cndmask_b32_e64 v3, v3, v15, s[4:5]
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i128>, <4 x i128> addrspace(1)* %ptr
  %element = extractelement <4 x i128> %vector, i32 %idx
  ret i128 %element
}

define amdgpu_ps i128 @extractelement_sgpr_v4i128_vgpr_idx(<4 x i128> addrspace(4)* inreg %ptr, i32 %idx) {
; GFX9-LABEL: extractelement_sgpr_v4i128_vgpr_idx:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx16 s[0:15], s[2:3], 0x0
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; GFX9-NEXT:    v_add_u32_e32 v19, 1, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    v_mov_b32_e32 v2, s1
; GFX9-NEXT:    v_mov_b32_e32 v3, s2
; GFX9-NEXT:    v_mov_b32_e32 v4, s3
; GFX9-NEXT:    v_mov_b32_e32 v5, s4
; GFX9-NEXT:    v_mov_b32_e32 v6, s5
; GFX9-NEXT:    v_cndmask_b32_e32 v17, v1, v3, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v18, v2, v4, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v0
; GFX9-NEXT:    v_mov_b32_e32 v7, s6
; GFX9-NEXT:    v_mov_b32_e32 v8, s7
; GFX9-NEXT:    v_cndmask_b32_e32 v17, v17, v5, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v18, v18, v6, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v0
; GFX9-NEXT:    v_mov_b32_e32 v9, s8
; GFX9-NEXT:    v_mov_b32_e32 v10, s9
; GFX9-NEXT:    v_cndmask_b32_e32 v17, v17, v7, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v18, v18, v8, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v0
; GFX9-NEXT:    v_mov_b32_e32 v11, s10
; GFX9-NEXT:    v_mov_b32_e32 v12, s11
; GFX9-NEXT:    v_cndmask_b32_e32 v17, v17, v9, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v18, v18, v10, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v0
; GFX9-NEXT:    v_mov_b32_e32 v13, s12
; GFX9-NEXT:    v_mov_b32_e32 v14, s13
; GFX9-NEXT:    v_cndmask_b32_e32 v17, v17, v11, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v18, v18, v12, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 6, v0
; GFX9-NEXT:    v_cndmask_b32_e32 v17, v17, v13, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v18, v18, v14, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v19
; GFX9-NEXT:    v_cndmask_b32_e32 v1, v1, v3, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v4, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e64 s[0:1], 2, v19
; GFX9-NEXT:    v_mov_b32_e32 v15, s14
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 7, v0
; GFX9-NEXT:    v_mov_b32_e32 v16, s15
; GFX9-NEXT:    v_cndmask_b32_e64 v1, v1, v5, s[0:1]
; GFX9-NEXT:    v_cndmask_b32_e64 v2, v2, v6, s[0:1]
; GFX9-NEXT:    v_cmp_eq_u32_e64 s[0:1], 3, v19
; GFX9-NEXT:    v_cndmask_b32_e64 v3, v1, v7, s[0:1]
; GFX9-NEXT:    v_cndmask_b32_e32 v0, v17, v15, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v1, v18, v16, vcc
; GFX9-NEXT:    v_cndmask_b32_e64 v2, v2, v8, s[0:1]
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v19
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v3, v9, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v10, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v19
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v3, v11, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v2, v12, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 6, v19
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v3, v13, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v4, v2, v14, vcc
; GFX9-NEXT:    v_cmp_eq_u32_e32 vcc, 7, v19
; GFX9-NEXT:    v_cndmask_b32_e32 v2, v3, v15, vcc
; GFX9-NEXT:    v_cndmask_b32_e32 v3, v4, v16, vcc
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    v_readfirstlane_b32 s1, v1
; GFX9-NEXT:    v_readfirstlane_b32 s2, v2
; GFX9-NEXT:    v_readfirstlane_b32 s3, v3
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: extractelement_sgpr_v4i128_vgpr_idx:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx16 s[0:15], s[2:3], 0x0
; GFX8-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v1, s0
; GFX8-NEXT:    v_mov_b32_e32 v3, s2
; GFX8-NEXT:    v_mov_b32_e32 v2, s1
; GFX8-NEXT:    v_mov_b32_e32 v4, s3
; GFX8-NEXT:    v_mov_b32_e32 v5, s4
; GFX8-NEXT:    v_mov_b32_e32 v6, s5
; GFX8-NEXT:    v_cndmask_b32_e32 v17, v1, v3, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v18, v2, v4, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v0
; GFX8-NEXT:    v_mov_b32_e32 v7, s6
; GFX8-NEXT:    v_mov_b32_e32 v8, s7
; GFX8-NEXT:    v_cndmask_b32_e32 v17, v17, v5, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v18, v18, v6, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v0
; GFX8-NEXT:    v_mov_b32_e32 v9, s8
; GFX8-NEXT:    v_mov_b32_e32 v10, s9
; GFX8-NEXT:    v_cndmask_b32_e32 v17, v17, v7, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v18, v18, v8, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v0
; GFX8-NEXT:    v_mov_b32_e32 v11, s10
; GFX8-NEXT:    v_mov_b32_e32 v12, s11
; GFX8-NEXT:    v_cndmask_b32_e32 v17, v17, v9, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v18, v18, v10, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v0
; GFX8-NEXT:    v_mov_b32_e32 v13, s12
; GFX8-NEXT:    v_mov_b32_e32 v14, s13
; GFX8-NEXT:    v_cndmask_b32_e32 v17, v17, v11, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v18, v18, v12, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 6, v0
; GFX8-NEXT:    v_cndmask_b32_e32 v17, v17, v13, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v18, v18, v14, vcc
; GFX8-NEXT:    v_add_u32_e32 v19, vcc, 1, v0
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v19
; GFX8-NEXT:    v_cndmask_b32_e32 v1, v1, v3, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v2, v4, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e64 s[0:1], 2, v19
; GFX8-NEXT:    v_mov_b32_e32 v15, s14
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 7, v0
; GFX8-NEXT:    v_mov_b32_e32 v16, s15
; GFX8-NEXT:    v_cndmask_b32_e64 v1, v1, v5, s[0:1]
; GFX8-NEXT:    v_cndmask_b32_e64 v2, v2, v6, s[0:1]
; GFX8-NEXT:    v_cmp_eq_u32_e64 s[0:1], 3, v19
; GFX8-NEXT:    v_cndmask_b32_e64 v3, v1, v7, s[0:1]
; GFX8-NEXT:    v_cndmask_b32_e32 v0, v17, v15, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v1, v18, v16, vcc
; GFX8-NEXT:    v_cndmask_b32_e64 v2, v2, v8, s[0:1]
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v19
; GFX8-NEXT:    v_cndmask_b32_e32 v3, v3, v9, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v2, v10, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v19
; GFX8-NEXT:    v_cndmask_b32_e32 v3, v3, v11, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v2, v12, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 6, v19
; GFX8-NEXT:    v_cndmask_b32_e32 v3, v3, v13, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v4, v2, v14, vcc
; GFX8-NEXT:    v_cmp_eq_u32_e32 vcc, 7, v19
; GFX8-NEXT:    v_cndmask_b32_e32 v2, v3, v15, vcc
; GFX8-NEXT:    v_cndmask_b32_e32 v3, v4, v16, vcc
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    v_readfirstlane_b32 s2, v2
; GFX8-NEXT:    v_readfirstlane_b32 s3, v3
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: extractelement_sgpr_v4i128_vgpr_idx:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_load_dwordx16 s[0:15], s[2:3], 0x0
; GFX7-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v0
; GFX7-NEXT:    s_waitcnt lgkmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v1, s0
; GFX7-NEXT:    v_mov_b32_e32 v3, s2
; GFX7-NEXT:    v_mov_b32_e32 v2, s1
; GFX7-NEXT:    v_mov_b32_e32 v4, s3
; GFX7-NEXT:    v_mov_b32_e32 v5, s4
; GFX7-NEXT:    v_mov_b32_e32 v6, s5
; GFX7-NEXT:    v_cndmask_b32_e32 v17, v1, v3, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v18, v2, v4, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 2, v0
; GFX7-NEXT:    v_mov_b32_e32 v7, s6
; GFX7-NEXT:    v_mov_b32_e32 v8, s7
; GFX7-NEXT:    v_cndmask_b32_e32 v17, v17, v5, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v18, v18, v6, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 3, v0
; GFX7-NEXT:    v_mov_b32_e32 v9, s8
; GFX7-NEXT:    v_mov_b32_e32 v10, s9
; GFX7-NEXT:    v_cndmask_b32_e32 v17, v17, v7, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v18, v18, v8, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v0
; GFX7-NEXT:    v_mov_b32_e32 v11, s10
; GFX7-NEXT:    v_mov_b32_e32 v12, s11
; GFX7-NEXT:    v_cndmask_b32_e32 v17, v17, v9, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v18, v18, v10, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v0
; GFX7-NEXT:    v_mov_b32_e32 v13, s12
; GFX7-NEXT:    v_mov_b32_e32 v14, s13
; GFX7-NEXT:    v_cndmask_b32_e32 v17, v17, v11, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v18, v18, v12, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 6, v0
; GFX7-NEXT:    v_cndmask_b32_e32 v17, v17, v13, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v18, v18, v14, vcc
; GFX7-NEXT:    v_add_i32_e32 v19, vcc, 1, v0
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 1, v19
; GFX7-NEXT:    v_cndmask_b32_e32 v1, v1, v3, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v4, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e64 s[0:1], 2, v19
; GFX7-NEXT:    v_mov_b32_e32 v15, s14
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 7, v0
; GFX7-NEXT:    v_mov_b32_e32 v16, s15
; GFX7-NEXT:    v_cndmask_b32_e64 v1, v1, v5, s[0:1]
; GFX7-NEXT:    v_cndmask_b32_e64 v2, v2, v6, s[0:1]
; GFX7-NEXT:    v_cmp_eq_u32_e64 s[0:1], 3, v19
; GFX7-NEXT:    v_cndmask_b32_e64 v3, v1, v7, s[0:1]
; GFX7-NEXT:    v_cndmask_b32_e32 v0, v17, v15, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v1, v18, v16, vcc
; GFX7-NEXT:    v_cndmask_b32_e64 v2, v2, v8, s[0:1]
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 4, v19
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v3, v9, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v10, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 5, v19
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v3, v11, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v2, v12, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 6, v19
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v3, v13, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v4, v2, v14, vcc
; GFX7-NEXT:    v_cmp_eq_u32_e32 vcc, 7, v19
; GFX7-NEXT:    v_cndmask_b32_e32 v2, v3, v15, vcc
; GFX7-NEXT:    v_cndmask_b32_e32 v3, v4, v16, vcc
; GFX7-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-NEXT:    v_readfirstlane_b32 s1, v1
; GFX7-NEXT:    v_readfirstlane_b32 s2, v2
; GFX7-NEXT:    v_readfirstlane_b32 s3, v3
; GFX7-NEXT:    ; return to shader part epilog
  %vector = load <4 x i128>, <4 x i128> addrspace(4)* %ptr
  %element = extractelement <4 x i128> %vector, i32 %idx
  ret i128 %element
}

define amdgpu_ps i128 @extractelement_sgpr_v4i128_idx0(<4 x i128> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v4i128_idx0:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx16 s[0:15], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i128>, <4 x i128> addrspace(4)* %ptr
  %element = extractelement <4 x i128> %vector, i32 0
  ret i128 %element
}

define amdgpu_ps i128 @extractelement_sgpr_v4i128_idx1(<4 x i128> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v4i128_idx1:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx16 s[0:15], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s0, s4
; GCN-NEXT:    s_mov_b32 s1, s5
; GCN-NEXT:    s_mov_b32 s2, s6
; GCN-NEXT:    s_mov_b32 s3, s7
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i128>, <4 x i128> addrspace(4)* %ptr
  %element = extractelement <4 x i128> %vector, i32 1
  ret i128 %element
}

define amdgpu_ps i128 @extractelement_sgpr_v4i128_idx2(<4 x i128> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v4i128_idx2:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx16 s[0:15], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s0, s8
; GCN-NEXT:    s_mov_b32 s1, s9
; GCN-NEXT:    s_mov_b32 s2, s10
; GCN-NEXT:    s_mov_b32 s3, s11
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i128>, <4 x i128> addrspace(4)* %ptr
  %element = extractelement <4 x i128> %vector, i32 2
  ret i128 %element
}

define amdgpu_ps i128 @extractelement_sgpr_v4i128_idx3(<4 x i128> addrspace(4)* inreg %ptr) {
; GCN-LABEL: extractelement_sgpr_v4i128_idx3:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_load_dwordx16 s[0:15], s[2:3], 0x0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s0, s12
; GCN-NEXT:    s_mov_b32 s1, s13
; GCN-NEXT:    s_mov_b32 s2, s14
; GCN-NEXT:    s_mov_b32 s3, s15
; GCN-NEXT:    ; return to shader part epilog
  %vector = load <4 x i128>, <4 x i128> addrspace(4)* %ptr
  %element = extractelement <4 x i128> %vector, i32 3
  ret i128 %element
}

define i128 @extractelement_vgpr_v4i128_idx0(<4 x i128> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v4i128_idx0:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[0:3], v[0:1], off
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i128_idx0:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i128_idx0:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[4:7], 0 addr64
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i128>, <4 x i128> addrspace(1)* %ptr
  %element = extractelement <4 x i128> %vector, i32 0
  ret i128 %element
}

define i128 @extractelement_vgpr_v4i128_idx1(<4 x i128> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v4i128_idx1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[4:7], v[0:1], off offset:16
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, v4
; GFX9-NEXT:    v_mov_b32_e32 v1, v5
; GFX9-NEXT:    v_mov_b32_e32 v2, v6
; GFX9-NEXT:    v_mov_b32_e32 v3, v7
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i128_idx1:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, 16, v0
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[4:7], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, v4
; GFX8-NEXT:    v_mov_b32_e32 v1, v5
; GFX8-NEXT:    v_mov_b32_e32 v2, v6
; GFX8-NEXT:    v_mov_b32_e32 v3, v7
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i128_idx1:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[4:7], v[0:1], s[4:7], 0 addr64 offset:16
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, v4
; GFX7-NEXT:    v_mov_b32_e32 v1, v5
; GFX7-NEXT:    v_mov_b32_e32 v2, v6
; GFX7-NEXT:    v_mov_b32_e32 v3, v7
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i128>, <4 x i128> addrspace(1)* %ptr
  %element = extractelement <4 x i128> %vector, i32 1
  ret i128 %element
}

define i128 @extractelement_vgpr_v4i128_idx2(<4 x i128> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v4i128_idx2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[8:11], v[0:1], off offset:32
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, v8
; GFX9-NEXT:    v_mov_b32_e32 v1, v9
; GFX9-NEXT:    v_mov_b32_e32 v2, v10
; GFX9-NEXT:    v_mov_b32_e32 v3, v11
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i128_idx2:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, 32, v0
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[8:11], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, v8
; GFX8-NEXT:    v_mov_b32_e32 v1, v9
; GFX8-NEXT:    v_mov_b32_e32 v2, v10
; GFX8-NEXT:    v_mov_b32_e32 v3, v11
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i128_idx2:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[8:11], v[0:1], s[4:7], 0 addr64 offset:32
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, v8
; GFX7-NEXT:    v_mov_b32_e32 v1, v9
; GFX7-NEXT:    v_mov_b32_e32 v2, v10
; GFX7-NEXT:    v_mov_b32_e32 v3, v11
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i128>, <4 x i128> addrspace(1)* %ptr
  %element = extractelement <4 x i128> %vector, i32 2
  ret i128 %element
}

define i128 @extractelement_vgpr_v4i128_idx3(<4 x i128> addrspace(1)* %ptr) {
; GFX9-LABEL: extractelement_vgpr_v4i128_idx3:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    global_load_dwordx4 v[12:15], v[0:1], off offset:48
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, v12
; GFX9-NEXT:    v_mov_b32_e32 v1, v13
; GFX9-NEXT:    v_mov_b32_e32 v2, v14
; GFX9-NEXT:    v_mov_b32_e32 v3, v15
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: extractelement_vgpr_v4i128_idx3:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, 48, v0
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[12:15], v[0:1]
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, v12
; GFX8-NEXT:    v_mov_b32_e32 v1, v13
; GFX8-NEXT:    v_mov_b32_e32 v2, v14
; GFX8-NEXT:    v_mov_b32_e32 v3, v15
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: extractelement_vgpr_v4i128_idx3:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    s_mov_b32 s6, 0
; GFX7-NEXT:    s_mov_b32 s7, 0xf000
; GFX7-NEXT:    s_mov_b64 s[4:5], 0
; GFX7-NEXT:    buffer_load_dwordx4 v[12:15], v[0:1], s[4:7], 0 addr64 offset:48
; GFX7-NEXT:    s_waitcnt vmcnt(0)
; GFX7-NEXT:    v_mov_b32_e32 v0, v12
; GFX7-NEXT:    v_mov_b32_e32 v1, v13
; GFX7-NEXT:    v_mov_b32_e32 v2, v14
; GFX7-NEXT:    v_mov_b32_e32 v3, v15
; GFX7-NEXT:    s_setpc_b64 s[30:31]
  %vector = load <4 x i128>, <4 x i128> addrspace(1)* %ptr
  %element = extractelement <4 x i128> %vector, i32 3
  ret i128 %element
}
