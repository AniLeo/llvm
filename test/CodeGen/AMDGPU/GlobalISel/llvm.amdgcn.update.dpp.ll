; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=tonga -amdgpu-dpp-combine=false -verify-machineinstrs < %s | FileCheck -check-prefix=GFX8 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 -amdgpu-dpp-combine=false -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_kernel void @dpp_test(i32 addrspace(1)* %out, i32 %in1, i32 %in2) {
; GFX8-LABEL: dpp_test:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v2, s0
; GFX8-NEXT:    v_mov_b32_e32 v0, s1
; GFX8-NEXT:    s_nop 1
; GFX8-NEXT:    v_mov_b32_dpp v2, v0 quad_perm:[1,0,0,0] row_mask:0x1 bank_mask:0x1
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: dpp_test:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; GFX10-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v2, s2
; GFX10-NEXT:    v_mov_b32_e32 v0, s3
; GFX10-NEXT:    v_mov_b32_dpp v2, v0 quad_perm:[1,0,0,0] row_mask:0x1 bank_mask:0x1
; GFX10-NEXT:    v_mov_b32_e32 v0, s0
; GFX10-NEXT:    v_mov_b32_e32 v1, s1
; GFX10-NEXT:    global_store_dword v[0:1], v2, off
; GFX10-NEXT:    s_endpgm
  %tmp0 = call i32 @llvm.amdgcn.update.dpp.i32(i32 %in1, i32 %in2, i32 1, i32 1, i32 1, i1 false)
  store i32 %tmp0, i32 addrspace(1)* %out
  ret void
}
define amdgpu_kernel void @update_dpp64_test(i64 addrspace(1)* %arg, i64 %in1, i64 %in2) {
; GFX8-LABEL: update_dpp64_test:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; GFX8-NEXT:    v_lshlrev_b64 v[0:1], 3, v[0:1]
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v3, s1
; GFX8-NEXT:    v_mov_b32_e32 v2, s0
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, v2, v0
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, v3, v1, vcc
; GFX8-NEXT:    flat_load_dwordx2 v[2:3], v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v5, s3
; GFX8-NEXT:    v_mov_b32_e32 v4, s2
; GFX8-NEXT:    s_nop 0
; GFX8-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_dpp v5, v3 quad_perm:[1,0,0,0] row_mask:0x1 bank_mask:0x1
; GFX8-NEXT:    v_mov_b32_dpp v4, v2 quad_perm:[1,0,0,0] row_mask:0x1 bank_mask:0x1
; GFX8-NEXT:    flat_store_dwordx2 v[0:1], v[4:5]
; GFX8-NEXT:    s_endpgm
;
; GFX10-LABEL: update_dpp64_test:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    v_lshlrev_b64 v[0:1], 3, v[0:1]
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v3, s1
; GFX10-NEXT:    v_mov_b32_e32 v2, s0
; GFX10-NEXT:    v_mov_b32_e32 v5, s3
; GFX10-NEXT:    v_mov_b32_e32 v4, s2
; GFX10-NEXT:    v_add_co_u32_e64 v6, vcc_lo, v2, v0
; GFX10-NEXT:    v_add_co_ci_u32_e32 v7, vcc_lo, v3, v1, vcc_lo
; GFX10-NEXT:    global_load_dwordx2 v[2:3], v[6:7], off
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mov_b32_dpp v4, v2 quad_perm:[1,0,0,0] row_mask:0x1 bank_mask:0x1
; GFX10-NEXT:    v_mov_b32_dpp v5, v3 quad_perm:[1,0,0,0] row_mask:0x1 bank_mask:0x1
; GFX10-NEXT:    global_store_dwordx2 v[6:7], v[4:5], off
; GFX10-NEXT:    s_endpgm
  %id = tail call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr inbounds i64, i64 addrspace(1)* %arg, i32 %id
  %load = load i64, i64 addrspace(1)* %gep
  %tmp0 = call i64 @llvm.amdgcn.update.dpp.i64(i64 %in1, i64 %load, i32 1, i32 1, i32 1, i1 false) #1
  store i64 %tmp0, i64 addrspace(1)* %gep
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #0
declare i32 @llvm.amdgcn.update.dpp.i32(i32, i32, i32 immarg, i32 immarg, i32 immarg, i1 immarg) #1
declare i64 @llvm.amdgcn.update.dpp.i64(i64, i64, i32 immarg, i32 immarg, i32 immarg, i1 immarg) #1

attributes #0 = { nounwind readnone speculatable }
attributes #1 = { convergent nounwind readnone }
