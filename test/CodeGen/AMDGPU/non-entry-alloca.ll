; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=DEFAULTSIZE,MUBUF %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs -amdgpu-assume-dynamic-stack-object-size=1024 < %s | FileCheck -check-prefixes=ASSUME1024,MUBUF %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs -amdgpu-enable-flat-scratch < %s | FileCheck -check-prefixes=DEFAULTSIZE,FLATSCR %s
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs -amdgpu-enable-flat-scratch -amdgpu-assume-dynamic-stack-object-size=1024 < %s | FileCheck -check-prefixes=ASSUME1024,FLATSCR %s

; FIXME: Generated test checks do not check metadata at the end of the
; function, so this also includes manually added checks.

; Test that we can select a statically sized alloca outside of the
; entry block.

; FIXME: FunctionLoweringInfo unhelpfully doesn't preserve an
; alignment less than the stack alignment.
define amdgpu_kernel void @kernel_non_entry_block_static_alloca_uniformly_reached_align4(i32 addrspace(1)* %out, i32 %arg.cond0, i32 %arg.cond1, i32 %in) {
; MUBUF-LABEL: kernel_non_entry_block_static_alloca_uniformly_reached_align4:
; MUBUF:       ; %bb.0: ; %entry
; MUBUF-NEXT:    s_add_u32 flat_scratch_lo, s6, s9
; MUBUF-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; MUBUF-NEXT:    s_add_u32 s0, s0, s9
; MUBUF-NEXT:    s_load_dwordx4 s[8:11], s[4:5], 0x8
; MUBUF-NEXT:    s_addc_u32 s1, s1, 0
; MUBUF-NEXT:    s_movk_i32 s32, 0x400
; MUBUF-NEXT:    s_mov_b32 s33, 0
; MUBUF-NEXT:    s_waitcnt lgkmcnt(0)
; MUBUF-NEXT:    s_cmp_lg_u32 s8, 0
; MUBUF-NEXT:    s_cbranch_scc1 BB0_3
; MUBUF-NEXT:  ; %bb.1: ; %bb.0
; MUBUF-NEXT:    s_cmp_lg_u32 s9, 0
; MUBUF-NEXT:    s_cbranch_scc1 BB0_3
; MUBUF-NEXT:  ; %bb.2: ; %bb.1
; MUBUF-NEXT:    s_add_i32 s6, s32, 0x1000
; MUBUF-NEXT:    s_lshl_b32 s7, s10, 2
; MUBUF-NEXT:    s_mov_b32 s32, s6
; MUBUF-NEXT:    v_mov_b32_e32 v2, s6
; MUBUF-NEXT:    v_mov_b32_e32 v1, 0
; MUBUF-NEXT:    v_mov_b32_e32 v3, 1
; MUBUF-NEXT:    s_add_i32 s6, s6, s7
; MUBUF-NEXT:    buffer_store_dword v1, v2, s[0:3], 0 offen
; MUBUF-NEXT:    buffer_store_dword v3, v2, s[0:3], 0 offen offset:4
; MUBUF-NEXT:    v_mov_b32_e32 v2, s6
; MUBUF-NEXT:    buffer_load_dword v2, v2, s[0:3], 0 offen
; MUBUF-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    v_add_u32_e32 v0, v2, v0
; MUBUF-NEXT:    s_waitcnt lgkmcnt(0)
; MUBUF-NEXT:    global_store_dword v1, v0, s[4:5]
; MUBUF-NEXT:  BB0_3: ; %bb.2
; MUBUF-NEXT:    v_mov_b32_e32 v0, 0
; MUBUF-NEXT:    global_store_dword v[0:1], v0, off
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    s_endpgm
;
; FLATSCR-LABEL: kernel_non_entry_block_static_alloca_uniformly_reached_align4:
; FLATSCR:       ; %bb.0: ; %entry
; FLATSCR-NEXT:    s_add_u32 flat_scratch_lo, s2, s5
; FLATSCR-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x8
; FLATSCR-NEXT:    s_addc_u32 flat_scratch_hi, s3, 0
; FLATSCR-NEXT:    s_mov_b32 s32, 16
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    s_waitcnt lgkmcnt(0)
; FLATSCR-NEXT:    s_cmp_lg_u32 s4, 0
; FLATSCR-NEXT:    s_cbranch_scc1 BB0_3
; FLATSCR-NEXT:  ; %bb.1: ; %bb.0
; FLATSCR-NEXT:    s_cmp_lg_u32 s5, 0
; FLATSCR-NEXT:    s_cbranch_scc1 BB0_3
; FLATSCR-NEXT:  ; %bb.2: ; %bb.1
; FLATSCR-NEXT:    s_mov_b32 s2, s32
; FLATSCR-NEXT:    s_movk_i32 s3, 0x1000
; FLATSCR-NEXT:    s_add_i32 s4, s2, s3
; FLATSCR-NEXT:    v_mov_b32_e32 v1, 0
; FLATSCR-NEXT:    v_mov_b32_e32 v2, 1
; FLATSCR-NEXT:    s_add_u32 s2, s2, s3
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[1:2], s2
; FLATSCR-NEXT:    s_lshl_b32 s2, s6, 2
; FLATSCR-NEXT:    s_mov_b32 s32, s4
; FLATSCR-NEXT:    s_add_i32 s4, s4, s2
; FLATSCR-NEXT:    scratch_load_dword v2, off, s4
; FLATSCR-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    v_add_u32_e32 v0, v2, v0
; FLATSCR-NEXT:    s_waitcnt lgkmcnt(0)
; FLATSCR-NEXT:    global_store_dword v1, v0, s[0:1]
; FLATSCR-NEXT:  BB0_3: ; %bb.2
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 0
; FLATSCR-NEXT:    global_store_dword v[0:1], v0, off
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    s_endpgm

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
; MUBUF-LABEL: kernel_non_entry_block_static_alloca_uniformly_reached_align64:
; MUBUF:       ; %bb.0: ; %entry
; MUBUF-NEXT:    s_add_u32 flat_scratch_lo, s6, s9
; MUBUF-NEXT:    s_addc_u32 flat_scratch_hi, s7, 0
; MUBUF-NEXT:    s_load_dwordx2 s[6:7], s[4:5], 0x8
; MUBUF-NEXT:    s_add_u32 s0, s0, s9
; MUBUF-NEXT:    s_addc_u32 s1, s1, 0
; MUBUF-NEXT:    s_movk_i32 s32, 0x1000
; MUBUF-NEXT:    s_mov_b32 s33, 0
; MUBUF-NEXT:    s_waitcnt lgkmcnt(0)
; MUBUF-NEXT:    s_cmp_lg_u32 s6, 0
; MUBUF-NEXT:    s_cbranch_scc1 BB1_2
; MUBUF-NEXT:  ; %bb.1: ; %bb.0
; MUBUF-NEXT:    s_add_i32 s6, s32, 0x1000
; MUBUF-NEXT:    s_and_b32 s6, s6, 0xfffff000
; MUBUF-NEXT:    s_lshl_b32 s7, s7, 2
; MUBUF-NEXT:    s_mov_b32 s32, s6
; MUBUF-NEXT:    v_mov_b32_e32 v2, s6
; MUBUF-NEXT:    v_mov_b32_e32 v1, 0
; MUBUF-NEXT:    v_mov_b32_e32 v3, 1
; MUBUF-NEXT:    s_add_i32 s6, s6, s7
; MUBUF-NEXT:    buffer_store_dword v1, v2, s[0:3], 0 offen
; MUBUF-NEXT:    buffer_store_dword v3, v2, s[0:3], 0 offen offset:4
; MUBUF-NEXT:    v_mov_b32_e32 v2, s6
; MUBUF-NEXT:    buffer_load_dword v2, v2, s[0:3], 0 offen
; MUBUF-NEXT:    s_load_dwordx2 s[4:5], s[4:5], 0x0
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    v_add_u32_e32 v0, v2, v0
; MUBUF-NEXT:    s_waitcnt lgkmcnt(0)
; MUBUF-NEXT:    global_store_dword v1, v0, s[4:5]
; MUBUF-NEXT:  BB1_2: ; %bb.1
; MUBUF-NEXT:    v_mov_b32_e32 v0, 0
; MUBUF-NEXT:    global_store_dword v[0:1], v0, off
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    s_endpgm
;
; FLATSCR-LABEL: kernel_non_entry_block_static_alloca_uniformly_reached_align64:
; FLATSCR:       ; %bb.0: ; %entry
; FLATSCR-NEXT:    s_add_u32 flat_scratch_lo, s2, s5
; FLATSCR-NEXT:    s_addc_u32 flat_scratch_hi, s3, 0
; FLATSCR-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x8
; FLATSCR-NEXT:    s_mov_b32 s32, 64
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    s_waitcnt lgkmcnt(0)
; FLATSCR-NEXT:    s_cmp_lg_u32 s2, 0
; FLATSCR-NEXT:    s_cbranch_scc1 BB1_2
; FLATSCR-NEXT:  ; %bb.1: ; %bb.0
; FLATSCR-NEXT:    s_add_i32 s2, s32, 0x1000
; FLATSCR-NEXT:    s_and_b32 s2, s2, 0xfffff000
; FLATSCR-NEXT:    v_mov_b32_e32 v1, 0
; FLATSCR-NEXT:    v_mov_b32_e32 v2, 1
; FLATSCR-NEXT:    s_lshl_b32 s3, s3, 2
; FLATSCR-NEXT:    s_mov_b32 s32, s2
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[1:2], s2
; FLATSCR-NEXT:    s_add_i32 s2, s2, s3
; FLATSCR-NEXT:    scratch_load_dword v2, off, s2
; FLATSCR-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    v_add_u32_e32 v0, v2, v0
; FLATSCR-NEXT:    s_waitcnt lgkmcnt(0)
; FLATSCR-NEXT:    global_store_dword v1, v0, s[0:1]
; FLATSCR-NEXT:  BB1_2: ; %bb.1
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 0
; FLATSCR-NEXT:    global_store_dword v[0:1], v0, off
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    s_endpgm
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
; MUBUF-LABEL: func_non_entry_block_static_alloca_align4:
; MUBUF:       ; %bb.0: ; %entry
; MUBUF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; MUBUF-NEXT:    s_mov_b32 s7, s33
; MUBUF-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v2
; MUBUF-NEXT:    s_mov_b32 s33, s32
; MUBUF-NEXT:    s_add_u32 s32, s32, 0x400
; MUBUF-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; MUBUF-NEXT:    s_cbranch_execz BB2_3
; MUBUF-NEXT:  ; %bb.1: ; %bb.0
; MUBUF-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v3
; MUBUF-NEXT:    s_and_b64 exec, exec, vcc
; MUBUF-NEXT:    s_cbranch_execz BB2_3
; MUBUF-NEXT:  ; %bb.2: ; %bb.1
; MUBUF-NEXT:    s_add_i32 s6, s32, 0x1000
; MUBUF-NEXT:    v_mov_b32_e32 v2, 0
; MUBUF-NEXT:    v_mov_b32_e32 v3, s6
; MUBUF-NEXT:    buffer_store_dword v2, v3, s[0:3], 0 offen
; MUBUF-NEXT:    v_mov_b32_e32 v2, 1
; MUBUF-NEXT:    buffer_store_dword v2, v3, s[0:3], 0 offen offset:4
; MUBUF-NEXT:    v_lshl_add_u32 v2, v4, 2, s6
; MUBUF-NEXT:    buffer_load_dword v2, v2, s[0:3], 0 offen
; MUBUF-NEXT:    v_and_b32_e32 v3, 0x3ff, v31
; MUBUF-NEXT:    s_mov_b32 s32, s6
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    v_add_u32_e32 v2, v2, v3
; MUBUF-NEXT:    global_store_dword v[0:1], v2, off
; MUBUF-NEXT:  BB2_3: ; %bb.2
; MUBUF-NEXT:    s_or_b64 exec, exec, s[4:5]
; MUBUF-NEXT:    v_mov_b32_e32 v0, 0
; MUBUF-NEXT:    global_store_dword v[0:1], v0, off
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    s_sub_u32 s32, s32, 0x400
; MUBUF-NEXT:    s_mov_b32 s33, s7
; MUBUF-NEXT:    s_setpc_b64 s[30:31]
;
; FLATSCR-LABEL: func_non_entry_block_static_alloca_align4:
; FLATSCR:       ; %bb.0: ; %entry
; FLATSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLATSCR-NEXT:    s_mov_b32 s5, s33
; FLATSCR-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v2
; FLATSCR-NEXT:    s_mov_b32 s33, s32
; FLATSCR-NEXT:    s_add_u32 s32, s32, 16
; FLATSCR-NEXT:    s_and_saveexec_b64 s[0:1], vcc
; FLATSCR-NEXT:    s_cbranch_execz BB2_3
; FLATSCR-NEXT:  ; %bb.1: ; %bb.0
; FLATSCR-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v3
; FLATSCR-NEXT:    s_and_b64 exec, exec, vcc
; FLATSCR-NEXT:    s_cbranch_execz BB2_3
; FLATSCR-NEXT:  ; %bb.2: ; %bb.1
; FLATSCR-NEXT:    s_mov_b32 s2, s32
; FLATSCR-NEXT:    s_movk_i32 s3, 0x1000
; FLATSCR-NEXT:    s_add_i32 s4, s2, s3
; FLATSCR-NEXT:    v_mov_b32_e32 v2, 0
; FLATSCR-NEXT:    v_mov_b32_e32 v3, 1
; FLATSCR-NEXT:    s_add_u32 s2, s2, s3
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[2:3], s2
; FLATSCR-NEXT:    v_lshl_add_u32 v2, v4, 2, s4
; FLATSCR-NEXT:    scratch_load_dword v2, v2, off
; FLATSCR-NEXT:    v_and_b32_e32 v3, 0x3ff, v31
; FLATSCR-NEXT:    s_mov_b32 s32, s4
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    v_add_u32_e32 v2, v2, v3
; FLATSCR-NEXT:    global_store_dword v[0:1], v2, off
; FLATSCR-NEXT:  BB2_3: ; %bb.2
; FLATSCR-NEXT:    s_or_b64 exec, exec, s[0:1]
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 0
; FLATSCR-NEXT:    global_store_dword v[0:1], v0, off
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    s_sub_u32 s32, s32, 16
; FLATSCR-NEXT:    s_mov_b32 s33, s5
; FLATSCR-NEXT:    s_setpc_b64 s[30:31]

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
; MUBUF-LABEL: func_non_entry_block_static_alloca_align64:
; MUBUF:       ; %bb.0: ; %entry
; MUBUF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; MUBUF-NEXT:    s_mov_b32 s7, s33
; MUBUF-NEXT:    s_add_u32 s33, s32, 0xfc0
; MUBUF-NEXT:    s_and_b32 s33, s33, 0xfffff000
; MUBUF-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v2
; MUBUF-NEXT:    s_add_u32 s32, s32, 0x2000
; MUBUF-NEXT:    s_and_saveexec_b64 s[4:5], vcc
; MUBUF-NEXT:    s_cbranch_execz BB3_2
; MUBUF-NEXT:  ; %bb.1: ; %bb.0
; MUBUF-NEXT:    s_add_i32 s6, s32, 0x1000
; MUBUF-NEXT:    s_and_b32 s6, s6, 0xfffff000
; MUBUF-NEXT:    v_mov_b32_e32 v2, 0
; MUBUF-NEXT:    v_mov_b32_e32 v4, s6
; MUBUF-NEXT:    buffer_store_dword v2, v4, s[0:3], 0 offen
; MUBUF-NEXT:    v_mov_b32_e32 v2, 1
; MUBUF-NEXT:    buffer_store_dword v2, v4, s[0:3], 0 offen offset:4
; MUBUF-NEXT:    v_lshl_add_u32 v2, v3, 2, s6
; MUBUF-NEXT:    buffer_load_dword v2, v2, s[0:3], 0 offen
; MUBUF-NEXT:    v_and_b32_e32 v3, 0x3ff, v31
; MUBUF-NEXT:    s_mov_b32 s32, s6
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    v_add_u32_e32 v2, v2, v3
; MUBUF-NEXT:    global_store_dword v[0:1], v2, off
; MUBUF-NEXT:  BB3_2: ; %bb.1
; MUBUF-NEXT:    s_or_b64 exec, exec, s[4:5]
; MUBUF-NEXT:    v_mov_b32_e32 v0, 0
; MUBUF-NEXT:    global_store_dword v[0:1], v0, off
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    s_sub_u32 s32, s32, 0x2000
; MUBUF-NEXT:    s_mov_b32 s33, s7
; MUBUF-NEXT:    s_setpc_b64 s[30:31]
;
; FLATSCR-LABEL: func_non_entry_block_static_alloca_align64:
; FLATSCR:       ; %bb.0: ; %entry
; FLATSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLATSCR-NEXT:    s_mov_b32 s3, s33
; FLATSCR-NEXT:    s_add_u32 s33, s32, 63
; FLATSCR-NEXT:    s_andn2_b32 s33, s33, 63
; FLATSCR-NEXT:    v_cmp_eq_u32_e32 vcc, 0, v2
; FLATSCR-NEXT:    s_add_u32 s32, s32, 0x80
; FLATSCR-NEXT:    s_and_saveexec_b64 s[0:1], vcc
; FLATSCR-NEXT:    s_cbranch_execz BB3_2
; FLATSCR-NEXT:  ; %bb.1: ; %bb.0
; FLATSCR-NEXT:    s_add_i32 s2, s32, 0x1000
; FLATSCR-NEXT:    s_and_b32 s2, s2, 0xfffff000
; FLATSCR-NEXT:    v_mov_b32_e32 v4, 0
; FLATSCR-NEXT:    v_mov_b32_e32 v5, 1
; FLATSCR-NEXT:    v_lshl_add_u32 v2, v3, 2, s2
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[4:5], s2
; FLATSCR-NEXT:    scratch_load_dword v2, v2, off
; FLATSCR-NEXT:    v_and_b32_e32 v3, 0x3ff, v31
; FLATSCR-NEXT:    s_mov_b32 s32, s2
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    v_add_u32_e32 v2, v2, v3
; FLATSCR-NEXT:    global_store_dword v[0:1], v2, off
; FLATSCR-NEXT:  BB3_2: ; %bb.1
; FLATSCR-NEXT:    s_or_b64 exec, exec, s[0:1]
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 0
; FLATSCR-NEXT:    global_store_dword v[0:1], v0, off
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    s_sub_u32 s32, s32, 0x80
; FLATSCR-NEXT:    s_mov_b32 s33, s3
; FLATSCR-NEXT:    s_setpc_b64 s[30:31]
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
