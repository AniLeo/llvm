; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -amdgpu-load-store-vectorizer=0 -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,DEFAULTSIZE %s
; RUN: llc -global-isel -amdgpu-load-store-vectorizer=0 -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs -amdgpu-assume-dynamic-stack-object-size=1024 < %s | FileCheck -check-prefixes=GCN,ASSUME1024 %s

; FIXME: Generated test checks do not check metadata at the end of the
; function, so this also includes manually added checks.

; Test that we can select a statically sized alloca outside of the
; entry block.

; FIXME: FunctionLoweringInfo unhelpfully doesn't preserve an
; alignment less than the stack alignment.
define amdgpu_kernel void @kernel_non_entry_block_static_alloca_uniformly_reached_align4(i32 addrspace(1)* %out, i32 %arg.cond0, i32 %arg.cond1, i32 %in) {
; GCN-LABEL: kernel_non_entry_block_static_alloca_uniformly_reached_align4:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_add_u32 flat_scratch_lo, s6, s9
; GCN-NEXT:    s_load_dword s6, s[4:5], 0x8
; GCN-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; GCN-NEXT:    s_add_u32 s0, s0, s9
; GCN-NEXT:    s_addc_u32 s1, s1, 0
; GCN-NEXT:    s_movk_i32 s32, 0x400
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_lg_u32 s6, 0
; GCN-NEXT:    s_cselect_b32 s6, 1, 0
; GCN-NEXT:    s_and_b32 s6, s6, 1
; GCN-NEXT:    s_cmp_lg_u32 s6, 0
; GCN-NEXT:    s_mov_b32 s33, 0
; GCN-NEXT:    s_cbranch_scc1 BB0_3
; GCN-NEXT:  ; %bb.1: ; %bb.0
; GCN-NEXT:    s_load_dword s6, s[4:5], 0xc
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_lg_u32 s6, 0
; GCN-NEXT:    s_cselect_b32 s6, 1, 0
; GCN-NEXT:    s_and_b32 s6, s6, 1
; GCN-NEXT:    s_cmp_lg_u32 s6, 0
; GCN-NEXT:    s_cbranch_scc1 BB0_3
; GCN-NEXT:  ; %bb.2: ; %bb.1
; GCN-NEXT:    s_load_dwordx2 s[6:7], s[4:5], 0x0
; GCN-NEXT:    s_load_dword s4, s[4:5], 0x10
; GCN-NEXT:    s_add_u32 s5, s32, 0x1000
; GCN-NEXT:    s_add_u32 s8, s5, 4
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    v_mov_b32_e32 v2, s5
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshl_b32 s4, s4, 2
; GCN-NEXT:    buffer_store_dword v1, v2, s[0:3], 0 offen
; GCN-NEXT:    v_mov_b32_e32 v2, 1
; GCN-NEXT:    v_mov_b32_e32 v3, s8
; GCN-NEXT:    s_add_u32 s4, s5, s4
; GCN-NEXT:    buffer_store_dword v2, v3, s[0:3], 0 offen
; GCN-NEXT:    v_mov_b32_e32 v2, s4
; GCN-NEXT:    buffer_load_dword v2, v2, s[0:3], 0 offen
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_add_u32_e32 v0, v2, v0
; GCN-NEXT:    global_store_dword v1, v0, s[6:7]
; GCN-NEXT:  BB0_3: ; %bb.2
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    global_store_dword v[0:1], v0, off
; GCN-NEXT:    s_endpgm

entry:
  %cond0 = icmp eq i32 %arg.cond0, 0
  br i1 %cond0, label %bb.0, label %bb.2

bb.0:
  %alloca = alloca [16 x i32], align 4, addrspace(5)
  %gep0 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 0
  %gep1 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 1
  %cond1 = icmp eq i32 %arg.cond1, 0
  br i1 %cond1, label %bb.1, label %bb.2

bb.1:
  ; Use the alloca outside of the defining block.
  store i32 0, i32 addrspace(5)* %gep0
  store i32 1, i32 addrspace(5)* %gep1
  %gep2 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 %in
  %load = load i32, i32 addrspace(5)* %gep2
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %add = add i32 %load, %tid
  store i32 %add, i32 addrspace(1)* %out
  br label %bb.2

bb.2:
  store volatile i32 0, i32 addrspace(1)* undef
  ret void
}
; DEFAULTSIZE: .amdhsa_private_segment_fixed_size 4112
; DEFAULTSIZE: ; ScratchSize: 4112

; ASSUME1024: .amdhsa_private_segment_fixed_size 1040
; ASSUME1024: ; ScratchSize: 1040

define amdgpu_kernel void @kernel_non_entry_block_static_alloca_uniformly_reached_align64(i32 addrspace(1)* %out, i32 %arg.cond, i32 %in) {
; GCN-LABEL: kernel_non_entry_block_static_alloca_uniformly_reached_align64:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_add_u32 flat_scratch_lo, s6, s9
; GCN-NEXT:    s_load_dword s6, s[4:5], 0x8
; GCN-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; GCN-NEXT:    s_add_u32 s0, s0, s9
; GCN-NEXT:    s_addc_u32 s1, s1, 0
; GCN-NEXT:    s_movk_i32 s32, 0x1000
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_lg_u32 s6, 0
; GCN-NEXT:    s_cselect_b32 s6, 1, 0
; GCN-NEXT:    s_and_b32 s6, s6, 1
; GCN-NEXT:    s_cmp_lg_u32 s6, 0
; GCN-NEXT:    s_mov_b32 s33, 0
; GCN-NEXT:    s_cbranch_scc1 BB1_2
; GCN-NEXT:  ; %bb.1: ; %bb.0
; GCN-NEXT:    s_load_dwordx2 s[6:7], s[4:5], 0x0
; GCN-NEXT:    s_load_dword s4, s[4:5], 0xc
; GCN-NEXT:    s_add_u32 s5, s32, 0x1000
; GCN-NEXT:    s_and_b32 s5, s5, 0xfffff000
; GCN-NEXT:    s_add_u32 s8, s5, 4
; GCN-NEXT:    v_mov_b32_e32 v1, 0
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_lshl_b32 s4, s4, 2
; GCN-NEXT:    v_mov_b32_e32 v2, s5
; GCN-NEXT:    buffer_store_dword v1, v2, s[0:3], 0 offen
; GCN-NEXT:    v_mov_b32_e32 v2, 1
; GCN-NEXT:    v_mov_b32_e32 v3, s8
; GCN-NEXT:    s_add_u32 s4, s5, s4
; GCN-NEXT:    buffer_store_dword v2, v3, s[0:3], 0 offen
; GCN-NEXT:    v_mov_b32_e32 v2, s4
; GCN-NEXT:    buffer_load_dword v2, v2, s[0:3], 0 offen
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_add_u32_e32 v0, v2, v0
; GCN-NEXT:    global_store_dword v1, v0, s[6:7]
; GCN-NEXT:  BB1_2: ; %bb.1
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    global_store_dword v[0:1], v0, off
; GCN-NEXT:    s_endpgm
entry:
  %cond = icmp eq i32 %arg.cond, 0
  br i1 %cond, label %bb.0, label %bb.1

bb.0:
  %alloca = alloca [16 x i32], align 64, addrspace(5)
  %gep0 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 0
  %gep1 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 1
  store i32 0, i32 addrspace(5)* %gep0
  store i32 1, i32 addrspace(5)* %gep1
  %gep2 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 %in
  %load = load i32, i32 addrspace(5)* %gep2
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %add = add i32 %load, %tid
  store i32 %add, i32 addrspace(1)* %out
  br label %bb.1

bb.1:
  store volatile i32 0, i32 addrspace(1)* undef
  ret void
}

; DEFAULTSIZE: .amdhsa_private_segment_fixed_size 4160
; DEFAULTSIZE: ; ScratchSize: 4160

; ASSUME1024: .amdhsa_private_segment_fixed_size 1088
; ASSUME1024: ; ScratchSize: 1088


define void @func_non_entry_block_static_alloca_align4(i32 addrspace(1)* %out, i32 %arg.cond0, i32 %arg.cond1, i32 %in) {
; GCN-LABEL: func_non_entry_block_static_alloca_align4:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_mov_b32 s8, s33
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v2
; GCN-NEXT:    s_mov_b32 s33, s32
; GCN-NEXT:    s_add_u32 s32, s32, 0x400
; GCN-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; GCN-NEXT:    s_cbranch_execz BB2_3
; GCN-NEXT:  ; %bb.1: ; %bb.0
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v3
; GCN-NEXT:    s_and_b64 exec, exec, vcc
; GCN-NEXT:    s_cbranch_execz BB2_3
; GCN-NEXT:  ; %bb.2: ; %bb.1
; GCN-NEXT:    s_add_u32 s6, s32, 0x1000
; GCN-NEXT:    v_mov_b32_e32 v2, 0
; GCN-NEXT:    v_mov_b32_e32 v3, s6
; GCN-NEXT:    s_add_u32 s7, s6, 4
; GCN-NEXT:    buffer_store_dword v2, v3, s[0:3], 0 offen
; GCN-NEXT:    v_mov_b32_e32 v2, 1
; GCN-NEXT:    v_mov_b32_e32 v3, s7
; GCN-NEXT:    buffer_store_dword v2, v3, s[0:3], 0 offen
; GCN-NEXT:    v_lshlrev_b32_e32 v2, 2, v4
; GCN-NEXT:    v_add_u32_e32 v2, s6, v2
; GCN-NEXT:    buffer_load_dword v2, v2, s[0:3], 0 offen
; GCN-NEXT:    v_and_b32_e32 v3, 0x3ff, v5
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_add_u32_e32 v2, v2, v3
; GCN-NEXT:    global_store_dword v[0:1], v2, off
; GCN-NEXT:  BB2_3: ; %bb.2
; GCN-NEXT:    s_or_b64 exec, exec, s[4:5]
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    global_store_dword v[0:1], v0, off
; GCN-NEXT:    s_sub_u32 s32, s32, 0x400
; GCN-NEXT:    s_mov_b32 s33, s8
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]

entry:
  %cond0 = icmp eq i32 %arg.cond0, 0
  br i1 %cond0, label %bb.0, label %bb.2

bb.0:
  %alloca = alloca [16 x i32], align 4, addrspace(5)
  %gep0 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 0
  %gep1 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 1
  %cond1 = icmp eq i32 %arg.cond1, 0
  br i1 %cond1, label %bb.1, label %bb.2

bb.1:
  ; Use the alloca outside of the defining block.
  store i32 0, i32 addrspace(5)* %gep0
  store i32 1, i32 addrspace(5)* %gep1
  %gep2 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 %in
  %load = load i32, i32 addrspace(5)* %gep2
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %add = add i32 %load, %tid
  store i32 %add, i32 addrspace(1)* %out
  br label %bb.2

bb.2:
  store volatile i32 0, i32 addrspace(1)* undef
  ret void
}

define void @func_non_entry_block_static_alloca_align64(i32 addrspace(1)* %out, i32 %arg.cond, i32 %in) {
; GCN-LABEL: func_non_entry_block_static_alloca_align64:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_add_u32 s4, s32, 0xfc0
; GCN-NEXT:    s_mov_b32 s8, s33
; GCN-NEXT:    s_and_b32 s33, s4, 0xfffff000
; GCN-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v2
; GCN-NEXT:    s_add_u32 s32, s32, 0x2000
; GCN-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; GCN-NEXT:    s_cbranch_execz BB3_2
; GCN-NEXT:  ; %bb.1: ; %bb.0
; GCN-NEXT:    s_add_u32 s6, s32, 0x1000
; GCN-NEXT:    s_and_b32 s6, s6, 0xfffff000
; GCN-NEXT:    s_add_u32 s7, s6, 4
; GCN-NEXT:    v_mov_b32_e32 v2, 0
; GCN-NEXT:    v_mov_b32_e32 v5, s6
; GCN-NEXT:    buffer_store_dword v2, v5, s[0:3], 0 offen
; GCN-NEXT:    v_mov_b32_e32 v2, 1
; GCN-NEXT:    v_mov_b32_e32 v5, s7
; GCN-NEXT:    buffer_store_dword v2, v5, s[0:3], 0 offen
; GCN-NEXT:    v_lshlrev_b32_e32 v2, 2, v3
; GCN-NEXT:    v_add_u32_e32 v2, s6, v2
; GCN-NEXT:    buffer_load_dword v2, v2, s[0:3], 0 offen
; GCN-NEXT:    v_and_b32_e32 v3, 0x3ff, v4
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_add_u32_e32 v2, v2, v3
; GCN-NEXT:    global_store_dword v[0:1], v2, off
; GCN-NEXT:  BB3_2: ; %bb.1
; GCN-NEXT:    s_or_b64 exec, exec, s[4:5]
; GCN-NEXT:    v_mov_b32_e32 v0, 0
; GCN-NEXT:    global_store_dword v[0:1], v0, off
; GCN-NEXT:    s_sub_u32 s32, s32, 0x2000
; GCN-NEXT:    s_mov_b32 s33, s8
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_setpc_b64 s[30:31]
entry:
  %cond = icmp eq i32 %arg.cond, 0
  br i1 %cond, label %bb.0, label %bb.1

bb.0:
  %alloca = alloca [16 x i32], align 64, addrspace(5)
  %gep0 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 0
  %gep1 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 1
  store i32 0, i32 addrspace(5)* %gep0
  store i32 1, i32 addrspace(5)* %gep1
  %gep2 = getelementptr [16 x i32], [16 x i32] addrspace(5)* %alloca, i32 0, i32 %in
  %load = load i32, i32 addrspace(5)* %gep2
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %add = add i32 %load, %tid
  store i32 %add, i32 addrspace(1)* %out
  br label %bb.1

bb.1:
  store volatile i32 0, i32 addrspace(1)* undef
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #0

attributes #0 = { nounwind readnone speculatable }
