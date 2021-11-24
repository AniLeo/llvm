; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx902 -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s
; RUN: llc -march=amdgcn -mcpu=gfx1030 -amdgpu-enable-flat-scratch -verify-machineinstrs < %s | FileCheck -check-prefix=GCN-SCRATCH %s

define amdgpu_kernel void @vector_clause(<4 x i32> addrspace(1)* noalias nocapture readonly %arg, <4 x i32> addrspace(1)* noalias nocapture %arg1) {
; GCN-LABEL: vector_clause:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GCN-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x2c
; GCN-NEXT:    v_lshlrev_b32_e32 v16, 4, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    global_load_dwordx4 v[0:3], v16, s[2:3]
; GCN-NEXT:    global_load_dwordx4 v[4:7], v16, s[2:3] offset:16
; GCN-NEXT:    global_load_dwordx4 v[8:11], v16, s[2:3] offset:32
; GCN-NEXT:    global_load_dwordx4 v[12:15], v16, s[2:3] offset:48
; GCN-NEXT:    s_waitcnt vmcnt(3)
; GCN-NEXT:    global_store_dwordx4 v16, v[0:3], s[4:5]
; GCN-NEXT:    s_waitcnt vmcnt(3)
; GCN-NEXT:    global_store_dwordx4 v16, v[4:7], s[4:5] offset:16
; GCN-NEXT:    s_waitcnt vmcnt(3)
; GCN-NEXT:    global_store_dwordx4 v16, v[8:11], s[4:5] offset:32
; GCN-NEXT:    s_waitcnt vmcnt(3)
; GCN-NEXT:    global_store_dwordx4 v16, v[12:15], s[4:5] offset:48
; GCN-NEXT:    s_endpgm
;
; GCN-SCRATCH-LABEL: vector_clause:
; GCN-SCRATCH:       ; %bb.0: ; %bb
; GCN-SCRATCH-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GCN-SCRATCH-NEXT:    v_lshlrev_b32_e32 v16, 4, v0
; GCN-SCRATCH-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; GCN-SCRATCH-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-SCRATCH-NEXT:    s_clause 0x3
; GCN-SCRATCH-NEXT:    global_load_dwordx4 v[0:3], v16, s[2:3]
; GCN-SCRATCH-NEXT:    global_load_dwordx4 v[4:7], v16, s[2:3] offset:16
; GCN-SCRATCH-NEXT:    global_load_dwordx4 v[8:11], v16, s[2:3] offset:32
; GCN-SCRATCH-NEXT:    global_load_dwordx4 v[12:15], v16, s[2:3] offset:48
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(3)
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v16, v[0:3], s[0:1]
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(2)
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v16, v[4:7], s[0:1] offset:16
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(1)
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v16, v[8:11], s[0:1] offset:32
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0)
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v16, v[12:15], s[0:1] offset:48
; GCN-SCRATCH-NEXT:    s_endpgm
bb:
  %tmp = tail call i32 @llvm.amdgcn.workitem.id.x()
  %tmp2 = zext i32 %tmp to i64
  %tmp3 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg, i64 %tmp2
  %tmp4 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp3, align 16
  %tmp5 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg1, i64 %tmp2
  %tmp6 = add nuw nsw i64 %tmp2, 1
  %tmp7 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg, i64 %tmp6
  %tmp8 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp7, align 16
  %tmp9 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg1, i64 %tmp6
  %tmp10 = add nuw nsw i64 %tmp2, 2
  %tmp11 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg, i64 %tmp10
  %tmp12 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp11, align 16
  %tmp13 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg1, i64 %tmp10
  %tmp14 = add nuw nsw i64 %tmp2, 3
  %tmp15 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg, i64 %tmp14
  %tmp16 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp15, align 16
  %tmp17 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg1, i64 %tmp14
  store <4 x i32> %tmp4, <4 x i32> addrspace(1)* %tmp5, align 16
  store <4 x i32> %tmp8, <4 x i32> addrspace(1)* %tmp9, align 16
  store <4 x i32> %tmp12, <4 x i32> addrspace(1)* %tmp13, align 16
  store <4 x i32> %tmp16, <4 x i32> addrspace(1)* %tmp17, align 16
  ret void
}

define amdgpu_kernel void @scalar_clause(<4 x i32> addrspace(1)* noalias nocapture readonly %arg, <4 x i32> addrspace(1)* noalias nocapture %arg1) {
; GCN-LABEL: scalar_clause:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_load_dwordx2 s[16:17], s[0:1], 0x24
; GCN-NEXT:    s_load_dwordx2 s[18:19], s[0:1], 0x2c
; GCN-NEXT:    v_mov_b32_e32 v12, 0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_load_dwordx4 s[0:3], s[16:17], 0x0
; GCN-NEXT:    s_load_dwordx4 s[4:7], s[16:17], 0x10
; GCN-NEXT:    s_load_dwordx4 s[8:11], s[16:17], 0x20
; GCN-NEXT:    s_load_dwordx4 s[12:15], s[16:17], 0x30
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    v_mov_b32_e32 v1, s1
; GCN-NEXT:    v_mov_b32_e32 v2, s2
; GCN-NEXT:    v_mov_b32_e32 v3, s3
; GCN-NEXT:    v_mov_b32_e32 v4, s4
; GCN-NEXT:    v_mov_b32_e32 v8, s8
; GCN-NEXT:    v_mov_b32_e32 v5, s5
; GCN-NEXT:    v_mov_b32_e32 v6, s6
; GCN-NEXT:    v_mov_b32_e32 v7, s7
; GCN-NEXT:    v_mov_b32_e32 v9, s9
; GCN-NEXT:    v_mov_b32_e32 v10, s10
; GCN-NEXT:    v_mov_b32_e32 v11, s11
; GCN-NEXT:    global_store_dwordx4 v12, v[0:3], s[18:19]
; GCN-NEXT:    global_store_dwordx4 v12, v[4:7], s[18:19] offset:16
; GCN-NEXT:    global_store_dwordx4 v12, v[8:11], s[18:19] offset:32
; GCN-NEXT:    v_mov_b32_e32 v0, s12
; GCN-NEXT:    v_mov_b32_e32 v1, s13
; GCN-NEXT:    v_mov_b32_e32 v2, s14
; GCN-NEXT:    v_mov_b32_e32 v3, s15
; GCN-NEXT:    global_store_dwordx4 v12, v[0:3], s[18:19] offset:48
; GCN-NEXT:    s_endpgm
;
; GCN-SCRATCH-LABEL: scalar_clause:
; GCN-SCRATCH:       ; %bb.0: ; %bb
; GCN-SCRATCH-NEXT:    s_clause 0x1
; GCN-SCRATCH-NEXT:    s_load_dwordx2 s[12:13], s[0:1], 0x24
; GCN-SCRATCH-NEXT:    s_load_dwordx2 s[16:17], s[0:1], 0x2c
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v16, 0
; GCN-SCRATCH-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-SCRATCH-NEXT:    s_clause 0x3
; GCN-SCRATCH-NEXT:    s_load_dwordx4 s[0:3], s[12:13], 0x0
; GCN-SCRATCH-NEXT:    s_load_dwordx4 s[4:7], s[12:13], 0x10
; GCN-SCRATCH-NEXT:    s_load_dwordx4 s[8:11], s[12:13], 0x20
; GCN-SCRATCH-NEXT:    s_load_dwordx4 s[12:15], s[12:13], 0x30
; GCN-SCRATCH-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v0, s0
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v1, s1
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v2, s2
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v3, s3
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v4, s4
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v5, s5
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v6, s6
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v7, s7
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v8, s8
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v9, s9
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v10, s10
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v11, s11
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v12, s12
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v13, s13
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v14, s14
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v15, s15
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v16, v[0:3], s[16:17]
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v16, v[4:7], s[16:17] offset:16
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v16, v[8:11], s[16:17] offset:32
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v16, v[12:15], s[16:17] offset:48
; GCN-SCRATCH-NEXT:    s_endpgm
bb:
  %tmp = load <4 x i32>, <4 x i32> addrspace(1)* %arg, align 16
  %tmp2 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg, i64 1
  %tmp3 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp2, align 16
  %tmp4 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg1, i64 1
  %tmp5 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg, i64 2
  %tmp6 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp5, align 16
  %tmp7 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg1, i64 2
  %tmp8 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg, i64 3
  %tmp9 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp8, align 16
  %tmp10 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg1, i64 3
  store <4 x i32> %tmp, <4 x i32> addrspace(1)* %arg1, align 16
  store <4 x i32> %tmp3, <4 x i32> addrspace(1)* %tmp4, align 16
  store <4 x i32> %tmp6, <4 x i32> addrspace(1)* %tmp7, align 16
  store <4 x i32> %tmp9, <4 x i32> addrspace(1)* %tmp10, align 16
  ret void
}

define void @mubuf_clause(<4 x i32> addrspace(5)* noalias nocapture readonly %arg, <4 x i32> addrspace(5)* noalias nocapture %arg1) {
; GCN-LABEL: mubuf_clause:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_and_b32_e32 v2, 0x3ff, v2
; GCN-NEXT:    v_lshlrev_b32_e32 v2, 4, v2
; GCN-NEXT:    v_add_u32_e32 v0, v0, v2
; GCN-NEXT:    buffer_load_dword v3, v0, s[0:3], 0 offen
; GCN-NEXT:    buffer_load_dword v4, v0, s[0:3], 0 offen offset:4
; GCN-NEXT:    buffer_load_dword v5, v0, s[0:3], 0 offen offset:8
; GCN-NEXT:    buffer_load_dword v6, v0, s[0:3], 0 offen offset:12
; GCN-NEXT:    buffer_load_dword v7, v0, s[0:3], 0 offen offset:16
; GCN-NEXT:    buffer_load_dword v8, v0, s[0:3], 0 offen offset:20
; GCN-NEXT:    buffer_load_dword v9, v0, s[0:3], 0 offen offset:24
; GCN-NEXT:    buffer_load_dword v10, v0, s[0:3], 0 offen offset:28
; GCN-NEXT:    buffer_load_dword v11, v0, s[0:3], 0 offen offset:32
; GCN-NEXT:    buffer_load_dword v12, v0, s[0:3], 0 offen offset:36
; GCN-NEXT:    buffer_load_dword v13, v0, s[0:3], 0 offen offset:40
; GCN-NEXT:    buffer_load_dword v14, v0, s[0:3], 0 offen offset:44
; GCN-NEXT:    buffer_load_dword v15, v0, s[0:3], 0 offen offset:48
; GCN-NEXT:    buffer_load_dword v16, v0, s[0:3], 0 offen offset:52
; GCN-NEXT:    buffer_load_dword v17, v0, s[0:3], 0 offen offset:56
; GCN-NEXT:    s_nop 0
; GCN-NEXT:    buffer_load_dword v0, v0, s[0:3], 0 offen offset:60
; GCN-NEXT:    v_add_u32_e32 v1, v1, v2
; GCN-NEXT:    s_waitcnt vmcnt(12)
; GCN-NEXT:    buffer_store_dword v6, v1, s[0:3], 0 offen offset:12
; GCN-NEXT:    buffer_store_dword v5, v1, s[0:3], 0 offen offset:8
; GCN-NEXT:    buffer_store_dword v4, v1, s[0:3], 0 offen offset:4
; GCN-NEXT:    buffer_store_dword v3, v1, s[0:3], 0 offen
; GCN-NEXT:    s_waitcnt vmcnt(12)
; GCN-NEXT:    buffer_store_dword v10, v1, s[0:3], 0 offen offset:28
; GCN-NEXT:    buffer_store_dword v9, v1, s[0:3], 0 offen offset:24
; GCN-NEXT:    buffer_store_dword v8, v1, s[0:3], 0 offen offset:20
; GCN-NEXT:    buffer_store_dword v7, v1, s[0:3], 0 offen offset:16
; GCN-NEXT:    s_waitcnt vmcnt(12)
; GCN-NEXT:    buffer_store_dword v14, v1, s[0:3], 0 offen offset:44
; GCN-NEXT:    buffer_store_dword v13, v1, s[0:3], 0 offen offset:40
; GCN-NEXT:    buffer_store_dword v12, v1, s[0:3], 0 offen offset:36
; GCN-NEXT:    buffer_store_dword v11, v1, s[0:3], 0 offen offset:32
; GCN-NEXT:    s_waitcnt vmcnt(12)
; GCN-NEXT:    buffer_store_dword v0, v1, s[0:3], 0 offen offset:60
; GCN-NEXT:    buffer_store_dword v17, v1, s[0:3], 0 offen offset:56
; GCN-NEXT:    buffer_store_dword v16, v1, s[0:3], 0 offen offset:52
; GCN-NEXT:    buffer_store_dword v15, v1, s[0:3], 0 offen offset:48
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GCN-SCRATCH-LABEL: mubuf_clause:
; GCN-SCRATCH:       ; %bb.0: ; %bb
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-SCRATCH-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-SCRATCH-NEXT:    v_and_b32_e32 v2, 0x3ff, v2
; GCN-SCRATCH-NEXT:    v_lshlrev_b32_e32 v18, 4, v2
; GCN-SCRATCH-NEXT:    v_add_nc_u32_e32 v0, v0, v18
; GCN-SCRATCH-NEXT:    s_clause 0x3
; GCN-SCRATCH-NEXT:    scratch_load_dwordx4 v[2:5], v0, off
; GCN-SCRATCH-NEXT:    scratch_load_dwordx4 v[6:9], v0, off offset:16
; GCN-SCRATCH-NEXT:    scratch_load_dwordx4 v[10:13], v0, off offset:32
; GCN-SCRATCH-NEXT:    scratch_load_dwordx4 v[14:17], v0, off offset:48
; GCN-SCRATCH-NEXT:    v_add_nc_u32_e32 v0, v1, v18
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(3)
; GCN-SCRATCH-NEXT:    scratch_store_dwordx4 v0, v[2:5], off
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(2)
; GCN-SCRATCH-NEXT:    scratch_store_dwordx4 v0, v[6:9], off offset:16
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(1)
; GCN-SCRATCH-NEXT:    scratch_store_dwordx4 v0, v[10:13], off offset:32
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0)
; GCN-SCRATCH-NEXT:    scratch_store_dwordx4 v0, v[14:17], off offset:48
; GCN-SCRATCH-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-SCRATCH-NEXT:    s_setpc_b64 s[30:31]
bb:
  %tmp = tail call i32 @llvm.amdgcn.workitem.id.x()
  %tmp2 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(5)* %arg, i32 %tmp
  %tmp3 = load <4 x i32>, <4 x i32> addrspace(5)* %tmp2, align 16
  %tmp4 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(5)* %arg1, i32 %tmp
  %tmp5 = add nuw nsw i32 %tmp, 1
  %tmp6 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(5)* %arg, i32 %tmp5
  %tmp7 = load <4 x i32>, <4 x i32> addrspace(5)* %tmp6, align 16
  %tmp8 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(5)* %arg1, i32 %tmp5
  %tmp9 = add nuw nsw i32 %tmp, 2
  %tmp10 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(5)* %arg, i32 %tmp9
  %tmp11 = load <4 x i32>, <4 x i32> addrspace(5)* %tmp10, align 16
  %tmp12 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(5)* %arg1, i32 %tmp9
  %tmp13 = add nuw nsw i32 %tmp, 3
  %tmp14 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(5)* %arg, i32 %tmp13
  %tmp15 = load <4 x i32>, <4 x i32> addrspace(5)* %tmp14, align 16
  %tmp16 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(5)* %arg1, i32 %tmp13
  store <4 x i32> %tmp3, <4 x i32> addrspace(5)* %tmp4, align 16
  store <4 x i32> %tmp7, <4 x i32> addrspace(5)* %tmp8, align 16
  store <4 x i32> %tmp11, <4 x i32> addrspace(5)* %tmp12, align 16
  store <4 x i32> %tmp15, <4 x i32> addrspace(5)* %tmp16, align 16
  ret void
}

define amdgpu_kernel void @vector_clause_indirect(i64 addrspace(1)* noalias nocapture readonly %arg, <4 x i32> addrspace(1)* noalias nocapture readnone %arg1, <4 x i32> addrspace(1)* noalias nocapture %arg2) {
; GCN-LABEL: vector_clause_indirect:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GCN-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x34
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    global_load_dwordx2 v[8:9], v0, s[2:3]
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    global_load_dwordx4 v[0:3], v[8:9], off
; GCN-NEXT:    global_load_dwordx4 v[4:7], v[8:9], off offset:16
; GCN-NEXT:    v_mov_b32_e32 v8, 0
; GCN-NEXT:    s_waitcnt vmcnt(1)
; GCN-NEXT:    global_store_dwordx4 v8, v[0:3], s[4:5]
; GCN-NEXT:    s_waitcnt vmcnt(1)
; GCN-NEXT:    global_store_dwordx4 v8, v[4:7], s[4:5] offset:16
; GCN-NEXT:    s_endpgm
;
; GCN-SCRATCH-LABEL: vector_clause_indirect:
; GCN-SCRATCH:       ; %bb.0: ; %bb
; GCN-SCRATCH-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x24
; GCN-SCRATCH-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; GCN-SCRATCH-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v8, 0
; GCN-SCRATCH-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-SCRATCH-NEXT:    global_load_dwordx2 v[4:5], v0, s[2:3]
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0)
; GCN-SCRATCH-NEXT:    s_clause 0x1
; GCN-SCRATCH-NEXT:    global_load_dwordx4 v[0:3], v[4:5], off
; GCN-SCRATCH-NEXT:    global_load_dwordx4 v[4:7], v[4:5], off offset:16
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(1)
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v8, v[0:3], s[0:1]
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0)
; GCN-SCRATCH-NEXT:    global_store_dwordx4 v8, v[4:7], s[0:1] offset:16
; GCN-SCRATCH-NEXT:    s_endpgm
bb:
  %tmp = tail call i32 @llvm.amdgcn.workitem.id.x()
  %tmp3 = zext i32 %tmp to i64
  %tmp4 = getelementptr inbounds i64, i64 addrspace(1)* %arg, i64 %tmp3
  %tmp5 = bitcast i64 addrspace(1)* %tmp4 to <4 x i32> addrspace(1)* addrspace(1)*
  %tmp6 = load <4 x i32> addrspace(1)*, <4 x i32> addrspace(1)* addrspace(1)* %tmp5, align 8
  %tmp7 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp6, align 16
  %tmp8 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %tmp6, i64 1
  %tmp9 = load <4 x i32>, <4 x i32> addrspace(1)* %tmp8, align 16
  store <4 x i32> %tmp7, <4 x i32> addrspace(1)* %arg2, align 16
  %tmp10 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(1)* %arg2, i64 1
  store <4 x i32> %tmp9, <4 x i32> addrspace(1)* %tmp10, align 16
  ret void
}

define void @load_global_d16_hi(i16 addrspace(1)* %in, i16 %reg, <2 x i16> addrspace(1)* %out) {
; GCN-LABEL: load_global_d16_hi:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v5, v2
; GCN-NEXT:    global_load_short_d16_hi v5, v[0:1], off
; GCN-NEXT:    s_nop 0
; GCN-NEXT:    global_load_short_d16_hi v2, v[0:1], off offset:64
; GCN-NEXT:    s_waitcnt vmcnt(1)
; GCN-NEXT:    global_store_dword v[3:4], v5, off
; GCN-NEXT:    s_waitcnt vmcnt(1)
; GCN-NEXT:    global_store_dword v[3:4], v2, off offset:128
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GCN-SCRATCH-LABEL: load_global_d16_hi:
; GCN-SCRATCH:       ; %bb.0: ; %entry
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-SCRATCH-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v5, v2
; GCN-SCRATCH-NEXT:    s_clause 0x1
; GCN-SCRATCH-NEXT:    global_load_short_d16_hi v5, v[0:1], off
; GCN-SCRATCH-NEXT:    global_load_short_d16_hi v2, v[0:1], off offset:64
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(1)
; GCN-SCRATCH-NEXT:    global_store_dword v[3:4], v5, off
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0)
; GCN-SCRATCH-NEXT:    global_store_dword v[3:4], v2, off offset:128
; GCN-SCRATCH-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-SCRATCH-NEXT:    s_setpc_b64 s[30:31]
entry:
  %gep = getelementptr inbounds i16, i16 addrspace(1)* %in, i64 32
  %load1 = load i16, i16 addrspace(1)* %in
  %load2 = load i16, i16 addrspace(1)* %gep
  %build0 = insertelement <2 x i16> undef, i16 %reg, i32 0
  %build1 = insertelement <2 x i16> %build0, i16 %load1, i32 1
  store <2 x i16> %build1, <2 x i16> addrspace(1)* %out
  %build2 = insertelement <2 x i16> undef, i16 %reg, i32 0
  %build3 = insertelement <2 x i16> %build2, i16 %load2, i32 1
  %gep2 = getelementptr inbounds <2 x i16>, <2 x i16> addrspace(1)* %out, i64 32
  store <2 x i16> %build3, <2 x i16> addrspace(1)* %gep2
  ret void
}

define void @load_global_d16_lo(i16 addrspace(1)* %in, i32 %reg, <2 x i16> addrspace(1)* %out) {
; GCN-LABEL: load_global_d16_lo:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v5, v2
; GCN-NEXT:    global_load_short_d16 v5, v[0:1], off
; GCN-NEXT:    s_nop 0
; GCN-NEXT:    global_load_short_d16 v2, v[0:1], off offset:64
; GCN-NEXT:    s_waitcnt vmcnt(1)
; GCN-NEXT:    global_store_dword v[3:4], v5, off
; GCN-NEXT:    s_waitcnt vmcnt(1)
; GCN-NEXT:    global_store_dword v[3:4], v2, off offset:128
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GCN-SCRATCH-LABEL: load_global_d16_lo:
; GCN-SCRATCH:       ; %bb.0: ; %entry
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-SCRATCH-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v5, v2
; GCN-SCRATCH-NEXT:    s_clause 0x1
; GCN-SCRATCH-NEXT:    global_load_short_d16 v5, v[0:1], off
; GCN-SCRATCH-NEXT:    global_load_short_d16 v2, v[0:1], off offset:64
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(1)
; GCN-SCRATCH-NEXT:    global_store_dword v[3:4], v5, off
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0)
; GCN-SCRATCH-NEXT:    global_store_dword v[3:4], v2, off offset:128
; GCN-SCRATCH-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-SCRATCH-NEXT:    s_setpc_b64 s[30:31]
entry:
  %gep = getelementptr inbounds i16, i16 addrspace(1)* %in, i64 32
  %reg.bc1 = bitcast i32 %reg to <2 x i16>
  %reg.bc2 = bitcast i32 %reg to <2 x i16>
  %load1 = load i16, i16 addrspace(1)* %in
  %load2 = load i16, i16 addrspace(1)* %gep
  %build1 = insertelement <2 x i16> %reg.bc1, i16 %load1, i32 0
  %build2 = insertelement <2 x i16> %reg.bc2, i16 %load2, i32 0
  %gep2 = getelementptr inbounds <2 x i16>, <2 x i16> addrspace(1)* %out, i64 32
  store <2 x i16> %build1, <2 x i16> addrspace(1)* %out
  store <2 x i16> %build2, <2 x i16> addrspace(1)* %gep2
  ret void
}

define amdgpu_kernel void @flat_scratch_load(float %a, float %b, <8 x i32> %desc) {
; GCN-LABEL: flat_scratch_load:
; GCN:       ; %bb.0: ; %.entry
; GCN-NEXT:    s_mov_b32 s16, SCRATCH_RSRC_DWORD0
; GCN-NEXT:    s_mov_b32 s17, SCRATCH_RSRC_DWORD1
; GCN-NEXT:    s_mov_b32 s18, -1
; GCN-NEXT:    s_load_dwordx2 s[12:13], s[0:1], 0x24
; GCN-NEXT:    s_load_dwordx8 s[4:11], s[0:1], 0x44
; GCN-NEXT:    s_mov_b32 s19, 0xe00000
; GCN-NEXT:    s_add_u32 s16, s16, s3
; GCN-NEXT:    s_addc_u32 s17, s17, 0
; GCN-NEXT:    v_mov_b32_e32 v0, 0x40b00000
; GCN-NEXT:    buffer_store_dword v0, off, s[16:19], 0 offset:4
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_brev_b32 s0, 1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s12
; GCN-NEXT:    s_mov_b32 s3, 0
; GCN-NEXT:    s_mov_b32 s1, s0
; GCN-NEXT:    s_mov_b32 s2, s0
; GCN-NEXT:    v_mov_b32_e32 v1, s13
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    buffer_load_dword v2, off, s[16:19], 0 offset:4
; GCN-NEXT:    s_nop 0
; GCN-NEXT:    image_sample v0, v[0:1], s[4:11], s[0:3] dmask:0x1
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v0, v2, v0
; GCN-NEXT:    exp mrt0 v0, off, off, off done vm
; GCN-NEXT:    s_endpgm
;
; GCN-SCRATCH-LABEL: flat_scratch_load:
; GCN-SCRATCH:       ; %bb.0: ; %.entry
; GCN-SCRATCH-NEXT:    s_add_u32 s2, s2, s5
; GCN-SCRATCH-NEXT:    s_addc_u32 s3, s3, 0
; GCN-SCRATCH-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
; GCN-SCRATCH-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
; GCN-SCRATCH-NEXT:    s_clause 0x1
; GCN-SCRATCH-NEXT:    s_load_dwordx2 s[10:11], s[0:1], 0x24
; GCN-SCRATCH-NEXT:    s_load_dwordx8 s[0:7], s[0:1], 0x44
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v0, 0x40b00000
; GCN-SCRATCH-NEXT:    s_brev_b32 s8, 1
; GCN-SCRATCH-NEXT:    s_mov_b32 s9, s8
; GCN-SCRATCH-NEXT:    scratch_store_dword off, v0, off offset:4
; GCN-SCRATCH-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-SCRATCH-NEXT:    ;;#ASMSTART
; GCN-SCRATCH-NEXT:    ;;#ASMEND
; GCN-SCRATCH-NEXT:    scratch_load_dword v2, off, off offset:4
; GCN-SCRATCH-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v0, s10
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v1, s11
; GCN-SCRATCH-NEXT:    s_mov_b32 s11, 0
; GCN-SCRATCH-NEXT:    s_mov_b32 s10, s8
; GCN-SCRATCH-NEXT:    image_sample v0, v[0:1], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0)
; GCN-SCRATCH-NEXT:    v_add_f32_e32 v0, v2, v0
; GCN-SCRATCH-NEXT:    exp mrt0 v0, off, off, off done vm
; GCN-SCRATCH-NEXT:    s_endpgm
.entry:
  %alloca = alloca float, align 4, addrspace(5)
  store volatile float 5.5, float addrspace(5)* %alloca
  call void asm sideeffect "", ""()
  ; There was a bug with flat scratch instructions that do not not use any address registers (ST mode).
  ; To trigger, the scratch_load has to be immediately before the image_sample in MIR.
  %load = load float, float addrspace(5)* %alloca
  %val = call <2 x float> @llvm.amdgcn.image.sample.2d.v2f32.f32(i32 9, float %a, float %b, <8 x i32> %desc, <4 x i32> <i32 -2147483648, i32 -2147483648, i32 -2147483648, i32 0>, i1 false, i32 0, i32 0)
  %val0 = extractelement <2 x float> %val, i32 0
  %valadd = fadd float %load, %val0
  call void @llvm.amdgcn.exp.f32(i32 immarg 0, i32 immarg 1, float %valadd, float undef, float undef, float undef, i1 immarg true, i1 immarg true)
  ret void
}

define amdgpu_kernel void @flat_scratch_load_clause(float %a, float %b, <8 x i32> %desc) {
; GCN-LABEL: flat_scratch_load_clause:
; GCN:       ; %bb.0: ; %.entry
; GCN-NEXT:    s_mov_b32 s4, SCRATCH_RSRC_DWORD0
; GCN-NEXT:    s_mov_b32 s5, SCRATCH_RSRC_DWORD1
; GCN-NEXT:    s_mov_b32 s6, -1
; GCN-NEXT:    s_mov_b32 s7, 0xe00000
; GCN-NEXT:    s_add_u32 s4, s4, s3
; GCN-NEXT:    s_addc_u32 s5, s5, 0
; GCN-NEXT:    v_mov_b32_e32 v0, 0x40b00000
; GCN-NEXT:    buffer_store_dword v0, off, s[4:7], 0 offset:4
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, 0x40d00000
; GCN-NEXT:    buffer_store_dword v0, off, s[4:7], 0 offset:8
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    ;;#ASMSTART
; GCN-NEXT:    ;;#ASMEND
; GCN-NEXT:    buffer_load_dword v0, off, s[4:7], 0 offset:4
; GCN-NEXT:    buffer_load_dword v1, off, s[4:7], 0 offset:8
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v0, v0, v1
; GCN-NEXT:    exp mrt0 v0, off, off, off done vm
; GCN-NEXT:    s_endpgm
;
; GCN-SCRATCH-LABEL: flat_scratch_load_clause:
; GCN-SCRATCH:       ; %bb.0: ; %.entry
; GCN-SCRATCH-NEXT:    s_add_u32 s2, s2, s5
; GCN-SCRATCH-NEXT:    s_addc_u32 s3, s3, 0
; GCN-SCRATCH-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_LO), s2
; GCN-SCRATCH-NEXT:    s_setreg_b32 hwreg(HW_REG_FLAT_SCR_HI), s3
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v0, 0x40b00000
; GCN-SCRATCH-NEXT:    v_mov_b32_e32 v1, 0x40d00000
; GCN-SCRATCH-NEXT:    scratch_store_dword off, v0, off offset:4
; GCN-SCRATCH-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-SCRATCH-NEXT:    scratch_store_dword off, v1, off offset:8
; GCN-SCRATCH-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-SCRATCH-NEXT:    ;;#ASMSTART
; GCN-SCRATCH-NEXT:    ;;#ASMEND
; GCN-SCRATCH-NEXT:    s_clause 0x1
; GCN-SCRATCH-NEXT:    scratch_load_dword v0, off, off offset:4
; GCN-SCRATCH-NEXT:    scratch_load_dword v1, off, off offset:8
; GCN-SCRATCH-NEXT:    s_waitcnt vmcnt(0)
; GCN-SCRATCH-NEXT:    v_add_f32_e32 v0, v0, v1
; GCN-SCRATCH-NEXT:    exp mrt0 v0, off, off, off done vm
; GCN-SCRATCH-NEXT:    s_endpgm
.entry:
  %alloca = alloca float, align 4, addrspace(5)
  %alloca2 = alloca float, align 4, addrspace(5)
  store volatile float 5.5, float addrspace(5)* %alloca
  store volatile float 6.5, float addrspace(5)* %alloca2
  call void asm sideeffect "", ""()
  %load0 = load float, float addrspace(5)* %alloca
  %load1 = load float, float addrspace(5)* %alloca2
  %valadd = fadd float %load0, %load1
  call void @llvm.amdgcn.exp.f32(i32 immarg 0, i32 immarg 1, float %valadd, float undef, float undef, float undef, i1 immarg true, i1 immarg true)
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x()
declare void @llvm.amdgcn.exp.f32(i32 immarg, i32 immarg, float, float, float, float, i1 immarg, i1 immarg)
declare <2 x float> @llvm.amdgcn.image.sample.2d.v2f32.f32(i32 immarg, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg)
