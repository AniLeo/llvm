; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s
; RUN: llc -march=amdgcn -verify-machineinstrs -O0 < %s | FileCheck -check-prefix=GCN_DBG %s

define amdgpu_kernel void @test_loop(float addrspace(3)* %ptr, i32 %n) nounwind {
; GCN-LABEL: test_loop:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dword s2, s[0:1], 0xa
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_eq_u32 s2, -1
; GCN-NEXT:    s_cbranch_scc1 .LBB0_3
; GCN-NEXT:  ; %bb.1: ; %for.body.preheader
; GCN-NEXT:    s_load_dword s0, s[0:1], 0x9
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_addk_i32 s0, 0x80
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    s_and_b64 s[0:1], exec, -1
; GCN-NEXT:    s_mov_b32 m0, -1
; GCN-NEXT:  .LBB0_2: ; %for.body
; GCN-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    ds_read_b32 v1, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    ds_write_b32 v0, v1
; GCN-NEXT:    v_add_i32_e32 v0, vcc, 4, v0
; GCN-NEXT:    s_mov_b64 vcc, s[0:1]
; GCN-NEXT:    s_cbranch_vccnz .LBB0_2
; GCN-NEXT:  .LBB0_3: ; %for.exit
; GCN-NEXT:    s_endpgm
;
; GCN_DBG-LABEL: test_loop:
; GCN_DBG:       ; %bb.0: ; %entry
; GCN_DBG-NEXT:    s_load_dword s2, s[0:1], 0x9
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_writelane_b32 v2, s2, 0
; GCN_DBG-NEXT:    s_load_dword s1, s[0:1], 0xa
; GCN_DBG-NEXT:    s_mov_b32 s0, 0
; GCN_DBG-NEXT:    s_mov_b32 s2, -1
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    s_cmp_lg_u32 s1, s2
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 1
; GCN_DBG-NEXT:    s_cbranch_scc1 .LBB0_2
; GCN_DBG-NEXT:  ; %bb.1: ; %for.exit
; GCN_DBG-NEXT:    s_endpgm
; GCN_DBG-NEXT:  .LBB0_2: ; %for.body
; GCN_DBG-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN_DBG-NEXT:    v_readlane_b32 s0, v2, 1
; GCN_DBG-NEXT:    v_readlane_b32 s2, v2, 0
; GCN_DBG-NEXT:    s_mov_b32 s1, 2
; GCN_DBG-NEXT:    s_lshl_b32 s1, s0, s1
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s2
; GCN_DBG-NEXT:    s_mov_b32 s2, 0x80
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s2
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_read_b32 v0, v0
; GCN_DBG-NEXT:    s_mov_b32 s2, 1.0
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_add_f32_e64 v1, v0, s2
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_write_b32 v0, v1
; GCN_DBG-NEXT:    s_mov_b32 s1, 1
; GCN_DBG-NEXT:    s_add_i32 s0, s0, s1
; GCN_DBG-NEXT:    s_mov_b64 s[2:3], -1
; GCN_DBG-NEXT:    s_and_b64 vcc, exec, s[2:3]
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 1
; GCN_DBG-NEXT:    s_cbranch_vccnz .LBB0_2
; GCN_DBG-NEXT:  ; %bb.3: ; %DummyReturnBlock
; GCN_DBG-NEXT:    s_endpgm
entry:
  %cmp = icmp eq i32 %n, -1
  br i1 %cmp, label %for.exit, label %for.body

for.exit:
  ret void

for.body:
  %indvar = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %tmp = add i32 %indvar, 32
  %arrayidx = getelementptr float, float addrspace(3)* %ptr, i32 %tmp
  %vecload = load float, float addrspace(3)* %arrayidx, align 4
  %add = fadd float %vecload, 1.0
  store float %add, float addrspace(3)* %arrayidx, align 8
  %inc = add i32 %indvar, 1
  br label %for.body
}

define amdgpu_kernel void @loop_const_true(float addrspace(3)* %ptr, i32 %n) nounwind {
; GCN-LABEL: loop_const_true:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dword s0, s[0:1], 0x9
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_addk_i32 s0, 0x80
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    s_mov_b32 m0, -1
; GCN-NEXT:  .LBB1_1: ; %for.body
; GCN-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    ds_read_b32 v1, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    ds_write_b32 v0, v1
; GCN-NEXT:    v_add_i32_e32 v0, vcc, 4, v0
; GCN-NEXT:    s_branch .LBB1_1
;
; GCN_DBG-LABEL: loop_const_true:
; GCN_DBG:       ; %bb.0: ; %entry
; GCN_DBG-NEXT:    s_load_dword s0, s[0:1], 0x9
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 0
; GCN_DBG-NEXT:    s_mov_b32 s0, 0
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 1
; GCN_DBG-NEXT:    s_branch .LBB1_2
; GCN_DBG-NEXT:  .LBB1_1: ; %for.exit
; GCN_DBG-NEXT:    s_endpgm
; GCN_DBG-NEXT:  .LBB1_2: ; %for.body
; GCN_DBG-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN_DBG-NEXT:    v_readlane_b32 s0, v2, 1
; GCN_DBG-NEXT:    v_readlane_b32 s2, v2, 0
; GCN_DBG-NEXT:    s_mov_b32 s1, 2
; GCN_DBG-NEXT:    s_lshl_b32 s1, s0, s1
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s2
; GCN_DBG-NEXT:    s_mov_b32 s2, 0x80
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s2
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_read_b32 v0, v0
; GCN_DBG-NEXT:    s_mov_b32 s2, 1.0
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_add_f32_e64 v1, v0, s2
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_write_b32 v0, v1
; GCN_DBG-NEXT:    s_mov_b32 s1, 1
; GCN_DBG-NEXT:    s_add_i32 s0, s0, s1
; GCN_DBG-NEXT:    s_mov_b64 s[2:3], 0
; GCN_DBG-NEXT:    s_and_b64 vcc, exec, s[2:3]
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 1
; GCN_DBG-NEXT:    s_cbranch_vccnz .LBB1_1
; GCN_DBG-NEXT:    s_branch .LBB1_2
entry:
  br label %for.body

for.exit:
  ret void

for.body:
  %indvar = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %tmp = add i32 %indvar, 32
  %arrayidx = getelementptr float, float addrspace(3)* %ptr, i32 %tmp
  %vecload = load float, float addrspace(3)* %arrayidx, align 4
  %add = fadd float %vecload, 1.0
  store float %add, float addrspace(3)* %arrayidx, align 8
  %inc = add i32 %indvar, 1
  br i1 true, label %for.body, label %for.exit
}

define amdgpu_kernel void @loop_const_false(float addrspace(3)* %ptr, i32 %n) nounwind {
; GCN-LABEL: loop_const_false:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dword s0, s[0:1], 0x9
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    s_mov_b32 m0, -1
; GCN-NEXT:    ds_read_b32 v1, v0 offset:128
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    ds_write_b32 v0, v1 offset:128
; GCN-NEXT:    s_endpgm
;
; GCN_DBG-LABEL: loop_const_false:
; GCN_DBG:       ; %bb.0: ; %entry
; GCN_DBG-NEXT:    s_load_dword s0, s[0:1], 0x9
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 0
; GCN_DBG-NEXT:    s_mov_b32 s0, 0
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 1
; GCN_DBG-NEXT:    s_branch .LBB2_2
; GCN_DBG-NEXT:  .LBB2_1: ; %for.exit
; GCN_DBG-NEXT:    s_endpgm
; GCN_DBG-NEXT:  .LBB2_2: ; %for.body
; GCN_DBG-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN_DBG-NEXT:    v_readlane_b32 s0, v2, 1
; GCN_DBG-NEXT:    v_readlane_b32 s2, v2, 0
; GCN_DBG-NEXT:    s_mov_b32 s1, 2
; GCN_DBG-NEXT:    s_lshl_b32 s1, s0, s1
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s2
; GCN_DBG-NEXT:    s_mov_b32 s2, 0x80
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s2
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_read_b32 v0, v0
; GCN_DBG-NEXT:    s_mov_b32 s2, 1.0
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_add_f32_e64 v1, v0, s2
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_write_b32 v0, v1
; GCN_DBG-NEXT:    s_mov_b32 s1, 1
; GCN_DBG-NEXT:    s_add_i32 s0, s0, s1
; GCN_DBG-NEXT:    s_mov_b64 s[2:3], -1
; GCN_DBG-NEXT:    s_and_b64 vcc, exec, s[2:3]
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 1
; GCN_DBG-NEXT:    s_cbranch_vccnz .LBB2_1
; GCN_DBG-NEXT:    s_branch .LBB2_2
entry:
  br label %for.body

for.exit:
  ret void

; XXX - Should there be an S_ENDPGM?
for.body:
  %indvar = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %tmp = add i32 %indvar, 32
  %arrayidx = getelementptr float, float addrspace(3)* %ptr, i32 %tmp
  %vecload = load float, float addrspace(3)* %arrayidx, align 4
  %add = fadd float %vecload, 1.0
  store float %add, float addrspace(3)* %arrayidx, align 8
  %inc = add i32 %indvar, 1
  br i1 false, label %for.body, label %for.exit
}

define amdgpu_kernel void @loop_const_undef(float addrspace(3)* %ptr, i32 %n) nounwind {
; GCN-LABEL: loop_const_undef:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dword s0, s[0:1], 0x9
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, s0
; GCN-NEXT:    s_mov_b32 m0, -1
; GCN-NEXT:    ds_read_b32 v1, v0 offset:128
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    ds_write_b32 v0, v1 offset:128
; GCN-NEXT:    s_endpgm
;
; GCN_DBG-LABEL: loop_const_undef:
; GCN_DBG:       ; %bb.0: ; %entry
; GCN_DBG-NEXT:    s_load_dword s0, s[0:1], 0x9
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 0
; GCN_DBG-NEXT:    s_mov_b32 s0, 0
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 1
; GCN_DBG-NEXT:    s_branch .LBB3_2
; GCN_DBG-NEXT:  .LBB3_1: ; %for.exit
; GCN_DBG-NEXT:    s_endpgm
; GCN_DBG-NEXT:  .LBB3_2: ; %for.body
; GCN_DBG-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN_DBG-NEXT:    v_readlane_b32 s0, v2, 1
; GCN_DBG-NEXT:    v_readlane_b32 s2, v2, 0
; GCN_DBG-NEXT:    s_mov_b32 s1, 2
; GCN_DBG-NEXT:    s_lshl_b32 s1, s0, s1
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s2
; GCN_DBG-NEXT:    s_mov_b32 s2, 0x80
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s2
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_read_b32 v0, v0
; GCN_DBG-NEXT:    s_mov_b32 s2, 1.0
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_add_f32_e64 v1, v0, s2
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_write_b32 v0, v1
; GCN_DBG-NEXT:    s_mov_b32 s1, 1
; GCN_DBG-NEXT:    s_add_i32 s0, s0, s1
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 1
; GCN_DBG-NEXT:    s_cbranch_scc1 .LBB3_1
; GCN_DBG-NEXT:    s_branch .LBB3_2
entry:
  br label %for.body

for.exit:
  ret void

; XXX - Should there be an s_endpgm?
for.body:
  %indvar = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %tmp = add i32 %indvar, 32
  %arrayidx = getelementptr float, float addrspace(3)* %ptr, i32 %tmp
  %vecload = load float, float addrspace(3)* %arrayidx, align 4
  %add = fadd float %vecload, 1.0
  store float %add, float addrspace(3)* %arrayidx, align 8
  %inc = add i32 %indvar, 1
  br i1 undef, label %for.body, label %for.exit
}

define amdgpu_kernel void @loop_arg_0(float addrspace(3)* %ptr, i32 %n) nounwind {
; GCN-LABEL: loop_arg_0:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    s_mov_b32 m0, -1
; GCN-NEXT:    ds_read_u8 v0, v0
; GCN-NEXT:    s_load_dword s2, s[0:1], 0x9
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_readfirstlane_b32 s0, v0
; GCN-NEXT:    s_bitcmp1_b32 s0, 0
; GCN-NEXT:    s_cselect_b64 s[0:1], -1, 0
; GCN-NEXT:    s_addk_i32 s2, 0x80
; GCN-NEXT:    s_xor_b64 s[0:1], s[0:1], -1
; GCN-NEXT:    v_mov_b32_e32 v0, s2
; GCN-NEXT:    s_and_b64 s[0:1], exec, s[0:1]
; GCN-NEXT:  .LBB4_1: ; %for.body
; GCN-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    ds_read_b32 v1, v0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v1, 1.0, v1
; GCN-NEXT:    ds_write_b32 v0, v1
; GCN-NEXT:    v_add_i32_e32 v0, vcc, 4, v0
; GCN-NEXT:    s_mov_b64 vcc, s[0:1]
; GCN-NEXT:    s_cbranch_vccz .LBB4_1
; GCN-NEXT:  ; %bb.2: ; %for.exit
; GCN-NEXT:    s_endpgm
;
; GCN_DBG-LABEL: loop_arg_0:
; GCN_DBG:       ; %bb.0: ; %entry
; GCN_DBG-NEXT:    s_load_dword s0, s[0:1], 0x9
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 0
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, 0
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    ds_read_u8 v0, v0
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_readfirstlane_b32 s0, v0
; GCN_DBG-NEXT:    s_and_b32 s0, 1, s0
; GCN_DBG-NEXT:    s_cmp_eq_u32 s0, 1
; GCN_DBG-NEXT:    s_cselect_b64 s[0:1], -1, 0
; GCN_DBG-NEXT:    s_mov_b64 s[2:3], -1
; GCN_DBG-NEXT:    s_xor_b64 s[0:1], s[0:1], s[2:3]
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 1
; GCN_DBG-NEXT:    v_writelane_b32 v2, s1, 2
; GCN_DBG-NEXT:    s_mov_b32 s0, 0
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 3
; GCN_DBG-NEXT:    s_branch .LBB4_2
; GCN_DBG-NEXT:  .LBB4_1: ; %for.exit
; GCN_DBG-NEXT:    s_endpgm
; GCN_DBG-NEXT:  .LBB4_2: ; %for.body
; GCN_DBG-NEXT:    ; =>This Inner Loop Header: Depth=1
; GCN_DBG-NEXT:    v_readlane_b32 s0, v2, 3
; GCN_DBG-NEXT:    v_readlane_b32 s2, v2, 1
; GCN_DBG-NEXT:    v_readlane_b32 s3, v2, 2
; GCN_DBG-NEXT:    v_readlane_b32 s4, v2, 0
; GCN_DBG-NEXT:    s_mov_b32 s1, 2
; GCN_DBG-NEXT:    s_lshl_b32 s1, s0, s1
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s4
; GCN_DBG-NEXT:    s_mov_b32 s4, 0x80
; GCN_DBG-NEXT:    s_add_i32 s1, s1, s4
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_read_b32 v0, v0
; GCN_DBG-NEXT:    s_mov_b32 s4, 1.0
; GCN_DBG-NEXT:    s_waitcnt lgkmcnt(0)
; GCN_DBG-NEXT:    v_add_f32_e64 v1, v0, s4
; GCN_DBG-NEXT:    s_mov_b32 m0, -1
; GCN_DBG-NEXT:    v_mov_b32_e32 v0, s1
; GCN_DBG-NEXT:    ds_write_b32 v0, v1
; GCN_DBG-NEXT:    s_mov_b32 s1, 1
; GCN_DBG-NEXT:    s_add_i32 s0, s0, s1
; GCN_DBG-NEXT:    s_and_b64 vcc, exec, s[2:3]
; GCN_DBG-NEXT:    v_writelane_b32 v2, s0, 3
; GCN_DBG-NEXT:    s_cbranch_vccnz .LBB4_1
; GCN_DBG-NEXT:    s_branch .LBB4_2
entry:
  %cond = load volatile i1, i1 addrspace(3)* null
  br label %for.body

for.exit:
  ret void

for.body:
  %indvar = phi i32 [ %inc, %for.body ], [ 0, %entry ]
  %tmp = add i32 %indvar, 32
  %arrayidx = getelementptr float, float addrspace(3)* %ptr, i32 %tmp
  %vecload = load float, float addrspace(3)* %arrayidx, align 4
  %add = fadd float %vecload, 1.0
  store float %add, float addrspace(3)* %arrayidx, align 8
  %inc = add i32 %indvar, 1
  br i1 %cond, label %for.body, label %for.exit
}
