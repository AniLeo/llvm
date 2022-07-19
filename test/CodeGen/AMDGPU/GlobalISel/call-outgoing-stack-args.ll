; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs -o - %s | FileCheck -enable-var-scope -check-prefix=MUBUF %s
; RUN: llc -global-isel -mattr=+enable-flat-scratch -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 -verify-machineinstrs -o - %s | FileCheck -enable-var-scope -check-prefix=FLATSCR %s

; Test end-to-end codegen for outgoing arguments passed on the
; stack. This test is likely redundant when all DAG and GlobalISel
; tests are unified.

declare hidden void @external_void_func_v16i32_v16i32_v4i32(<16 x i32>, <16 x i32>, <4 x i32>) #0
declare hidden void @external_void_func_byval([16 x i32] addrspace(5)* byval([16 x i32])) #0

define amdgpu_kernel void @kernel_caller_stack() {
; MUBUF-LABEL: kernel_caller_stack:
; MUBUF:       ; %bb.0:
; MUBUF-NEXT:    s_add_u32 flat_scratch_lo, s4, s7
; MUBUF-NEXT:    s_addc_u32 flat_scratch_hi, s5, 0
; MUBUF-NEXT:    s_add_u32 s0, s0, s7
; MUBUF-NEXT:    s_mov_b32 s32, 0
; MUBUF-NEXT:    s_addc_u32 s1, s1, 0
; MUBUF-NEXT:    v_mov_b32_e32 v0, 9
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], s32 offset:4
; MUBUF-NEXT:    v_mov_b32_e32 v0, 10
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], s32 offset:8
; MUBUF-NEXT:    v_mov_b32_e32 v0, 11
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], s32 offset:12
; MUBUF-NEXT:    v_mov_b32_e32 v0, 12
; MUBUF-NEXT:    s_getpc_b64 s[4:5]
; MUBUF-NEXT:    s_add_u32 s4, s4, external_void_func_v16i32_v16i32_v4i32@rel32@lo+4
; MUBUF-NEXT:    s_addc_u32 s5, s5, external_void_func_v16i32_v16i32_v4i32@rel32@hi+12
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], s32 offset:16
; MUBUF-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; MUBUF-NEXT:    s_endpgm
;
; FLATSCR-LABEL: kernel_caller_stack:
; FLATSCR:       ; %bb.0:
; FLATSCR-NEXT:    s_add_u32 flat_scratch_lo, s0, s3
; FLATSCR-NEXT:    s_mov_b32 s32, 0
; FLATSCR-NEXT:    s_addc_u32 flat_scratch_hi, s1, 0
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 9
; FLATSCR-NEXT:    scratch_store_dword off, v0, s32 offset:4
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 10
; FLATSCR-NEXT:    scratch_store_dword off, v0, s32 offset:8
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 11
; FLATSCR-NEXT:    scratch_store_dword off, v0, s32 offset:12
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 12
; FLATSCR-NEXT:    s_getpc_b64 s[0:1]
; FLATSCR-NEXT:    s_add_u32 s0, s0, external_void_func_v16i32_v16i32_v4i32@rel32@lo+4
; FLATSCR-NEXT:    s_addc_u32 s1, s1, external_void_func_v16i32_v16i32_v4i32@rel32@hi+12
; FLATSCR-NEXT:    scratch_store_dword off, v0, s32 offset:16
; FLATSCR-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; FLATSCR-NEXT:    s_endpgm
  call void @external_void_func_v16i32_v16i32_v4i32(<16 x i32> undef, <16 x i32> undef, <4 x i32> <i32 9, i32 10, i32 11, i32 12>)
  ret void
}

define amdgpu_kernel void @kernel_caller_byval() {
; MUBUF-LABEL: kernel_caller_byval:
; MUBUF:       ; %bb.0:
; MUBUF-NEXT:    s_add_u32 flat_scratch_lo, s4, s7
; MUBUF-NEXT:    s_addc_u32 flat_scratch_hi, s5, 0
; MUBUF-NEXT:    s_add_u32 s0, s0, s7
; MUBUF-NEXT:    s_addc_u32 s1, s1, 0
; MUBUF-NEXT:    v_mov_b32_e32 v0, 0
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:8
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:12
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:16
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:20
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:24
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:28
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:32
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:36
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:40
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:44
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:48
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:52
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:56
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:60
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:64
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:68
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:72
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:76
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:80
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:84
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:88
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:92
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:96
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:100
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:104
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:108
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:112
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:116
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:120
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:124
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:128
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], 0 offset:132
; MUBUF-NEXT:    buffer_load_dword v0, off, s[0:3], 0 offset:8
; MUBUF-NEXT:    s_nop 0
; MUBUF-NEXT:    buffer_load_dword v1, off, s[0:3], 0 offset:12
; MUBUF-NEXT:    buffer_load_dword v2, off, s[0:3], 0 offset:16
; MUBUF-NEXT:    buffer_load_dword v3, off, s[0:3], 0 offset:20
; MUBUF-NEXT:    buffer_load_dword v4, off, s[0:3], 0 offset:24
; MUBUF-NEXT:    buffer_load_dword v5, off, s[0:3], 0 offset:28
; MUBUF-NEXT:    buffer_load_dword v6, off, s[0:3], 0 offset:32
; MUBUF-NEXT:    buffer_load_dword v7, off, s[0:3], 0 offset:36
; MUBUF-NEXT:    buffer_load_dword v8, off, s[0:3], 0 offset:40
; MUBUF-NEXT:    buffer_load_dword v9, off, s[0:3], 0 offset:44
; MUBUF-NEXT:    buffer_load_dword v10, off, s[0:3], 0 offset:48
; MUBUF-NEXT:    buffer_load_dword v11, off, s[0:3], 0 offset:52
; MUBUF-NEXT:    buffer_load_dword v12, off, s[0:3], 0 offset:56
; MUBUF-NEXT:    buffer_load_dword v13, off, s[0:3], 0 offset:60
; MUBUF-NEXT:    buffer_load_dword v14, off, s[0:3], 0 offset:64
; MUBUF-NEXT:    buffer_load_dword v15, off, s[0:3], 0 offset:68
; MUBUF-NEXT:    s_movk_i32 s32, 0x1400
; MUBUF-NEXT:    s_getpc_b64 s[4:5]
; MUBUF-NEXT:    s_add_u32 s4, s4, external_void_func_byval@rel32@lo+4
; MUBUF-NEXT:    s_addc_u32 s5, s5, external_void_func_byval@rel32@hi+12
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], s32
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v1, off, s[0:3], s32 offset:4
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v2, off, s[0:3], s32 offset:8
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v3, off, s[0:3], s32 offset:12
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v4, off, s[0:3], s32 offset:16
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v5, off, s[0:3], s32 offset:20
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v6, off, s[0:3], s32 offset:24
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v7, off, s[0:3], s32 offset:28
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v8, off, s[0:3], s32 offset:32
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v9, off, s[0:3], s32 offset:36
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v10, off, s[0:3], s32 offset:40
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v11, off, s[0:3], s32 offset:44
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v12, off, s[0:3], s32 offset:48
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v13, off, s[0:3], s32 offset:52
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v14, off, s[0:3], s32 offset:56
; MUBUF-NEXT:    s_waitcnt vmcnt(15)
; MUBUF-NEXT:    buffer_store_dword v15, off, s[0:3], s32 offset:60
; MUBUF-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; MUBUF-NEXT:    s_endpgm
;
; FLATSCR-LABEL: kernel_caller_byval:
; FLATSCR:       ; %bb.0:
; FLATSCR-NEXT:    s_add_u32 flat_scratch_lo, s0, s3
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 0
; FLATSCR-NEXT:    s_addc_u32 flat_scratch_hi, s1, 0
; FLATSCR-NEXT:    v_mov_b32_e32 v1, 0
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], vcc_hi offset:8
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s33 offset:72
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], vcc_hi offset:16
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s33 offset:80
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], vcc_hi offset:24
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s33 offset:88
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], vcc_hi offset:32
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s33 offset:96
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], vcc_hi offset:40
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s33 offset:104
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], vcc_hi offset:48
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s33 offset:112
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], vcc_hi offset:56
; FLATSCR-NEXT:    s_mov_b32 vcc_hi, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s33 offset:120
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], vcc_hi offset:64
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s33 offset:128
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_load_dwordx2 v[0:1], off, s33 offset:8
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_load_dwordx2 v[2:3], off, s33 offset:16
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_load_dwordx2 v[4:5], off, s33 offset:24
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_load_dwordx2 v[6:7], off, s33 offset:32
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_load_dwordx2 v[8:9], off, s33 offset:40
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_load_dwordx2 v[10:11], off, s33 offset:48
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_load_dwordx2 v[12:13], off, s33 offset:56
; FLATSCR-NEXT:    s_mov_b32 s33, 0
; FLATSCR-NEXT:    scratch_load_dwordx2 v[14:15], off, s33 offset:64
; FLATSCR-NEXT:    s_movk_i32 s32, 0x50
; FLATSCR-NEXT:    s_getpc_b64 s[0:1]
; FLATSCR-NEXT:    s_add_u32 s0, s0, external_void_func_byval@rel32@lo+4
; FLATSCR-NEXT:    s_addc_u32 s1, s1, external_void_func_byval@rel32@hi+12
; FLATSCR-NEXT:    s_waitcnt vmcnt(7)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s32
; FLATSCR-NEXT:    s_waitcnt vmcnt(7)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[2:3], s32 offset:8
; FLATSCR-NEXT:    s_waitcnt vmcnt(7)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[4:5], s32 offset:16
; FLATSCR-NEXT:    s_waitcnt vmcnt(7)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[6:7], s32 offset:24
; FLATSCR-NEXT:    s_waitcnt vmcnt(7)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[8:9], s32 offset:32
; FLATSCR-NEXT:    s_waitcnt vmcnt(7)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[10:11], s32 offset:40
; FLATSCR-NEXT:    s_waitcnt vmcnt(7)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[12:13], s32 offset:48
; FLATSCR-NEXT:    s_waitcnt vmcnt(7)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[14:15], s32 offset:56
; FLATSCR-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; FLATSCR-NEXT:    s_endpgm
  %alloca = alloca [16 x i32], align 4, addrspace(5)
  %cast = bitcast [16 x i32] addrspace(5)* %alloca to i8 addrspace(5)*
  call void @llvm.memset.p5i8.i32(i8 addrspace(5)* align 4 %cast, i8 0, i32 128, i1 false)
  call void @external_void_func_byval([16 x i32] addrspace(5)* byval([16 x i32]) %alloca)
  ret void
}

define void @func_caller_stack() {
; MUBUF-LABEL: func_caller_stack:
; MUBUF:       ; %bb.0:
; MUBUF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; MUBUF-NEXT:    s_or_saveexec_b64 s[4:5], -1
; MUBUF-NEXT:    buffer_store_dword v40, off, s[0:3], s32 ; 4-byte Folded Spill
; MUBUF-NEXT:    s_mov_b64 exec, s[4:5]
; MUBUF-NEXT:    v_writelane_b32 v40, s33, 2
; MUBUF-NEXT:    s_mov_b32 s33, s32
; MUBUF-NEXT:    s_addk_i32 s32, 0x400
; MUBUF-NEXT:    v_mov_b32_e32 v0, 9
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], s32 offset:4
; MUBUF-NEXT:    v_mov_b32_e32 v0, 10
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], s32 offset:8
; MUBUF-NEXT:    v_mov_b32_e32 v0, 11
; MUBUF-NEXT:    v_writelane_b32 v40, s30, 0
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], s32 offset:12
; MUBUF-NEXT:    v_mov_b32_e32 v0, 12
; MUBUF-NEXT:    v_writelane_b32 v40, s31, 1
; MUBUF-NEXT:    buffer_store_dword v0, off, s[0:3], s32 offset:16
; MUBUF-NEXT:    s_getpc_b64 s[4:5]
; MUBUF-NEXT:    s_add_u32 s4, s4, external_void_func_v16i32_v16i32_v4i32@rel32@lo+4
; MUBUF-NEXT:    s_addc_u32 s5, s5, external_void_func_v16i32_v16i32_v4i32@rel32@hi+12
; MUBUF-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; MUBUF-NEXT:    v_readlane_b32 s31, v40, 1
; MUBUF-NEXT:    v_readlane_b32 s30, v40, 0
; MUBUF-NEXT:    s_addk_i32 s32, 0xfc00
; MUBUF-NEXT:    v_readlane_b32 s33, v40, 2
; MUBUF-NEXT:    s_or_saveexec_b64 s[4:5], -1
; MUBUF-NEXT:    buffer_load_dword v40, off, s[0:3], s32 ; 4-byte Folded Reload
; MUBUF-NEXT:    s_mov_b64 exec, s[4:5]
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    s_setpc_b64 s[30:31]
;
; FLATSCR-LABEL: func_caller_stack:
; FLATSCR:       ; %bb.0:
; FLATSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLATSCR-NEXT:    s_or_saveexec_b64 s[0:1], -1
; FLATSCR-NEXT:    scratch_store_dword off, v40, s32 ; 4-byte Folded Spill
; FLATSCR-NEXT:    s_mov_b64 exec, s[0:1]
; FLATSCR-NEXT:    v_writelane_b32 v40, s33, 2
; FLATSCR-NEXT:    s_mov_b32 s33, s32
; FLATSCR-NEXT:    s_add_i32 s32, s32, 16
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 9
; FLATSCR-NEXT:    scratch_store_dword off, v0, s32 offset:4
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 10
; FLATSCR-NEXT:    scratch_store_dword off, v0, s32 offset:8
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 11
; FLATSCR-NEXT:    v_writelane_b32 v40, s30, 0
; FLATSCR-NEXT:    scratch_store_dword off, v0, s32 offset:12
; FLATSCR-NEXT:    v_mov_b32_e32 v0, 12
; FLATSCR-NEXT:    v_writelane_b32 v40, s31, 1
; FLATSCR-NEXT:    scratch_store_dword off, v0, s32 offset:16
; FLATSCR-NEXT:    s_getpc_b64 s[0:1]
; FLATSCR-NEXT:    s_add_u32 s0, s0, external_void_func_v16i32_v16i32_v4i32@rel32@lo+4
; FLATSCR-NEXT:    s_addc_u32 s1, s1, external_void_func_v16i32_v16i32_v4i32@rel32@hi+12
; FLATSCR-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; FLATSCR-NEXT:    v_readlane_b32 s31, v40, 1
; FLATSCR-NEXT:    v_readlane_b32 s30, v40, 0
; FLATSCR-NEXT:    s_add_i32 s32, s32, -16
; FLATSCR-NEXT:    v_readlane_b32 s33, v40, 2
; FLATSCR-NEXT:    s_or_saveexec_b64 s[0:1], -1
; FLATSCR-NEXT:    scratch_load_dword v40, off, s32 ; 4-byte Folded Reload
; FLATSCR-NEXT:    s_mov_b64 exec, s[0:1]
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    s_setpc_b64 s[30:31]
  call void @external_void_func_v16i32_v16i32_v4i32(<16 x i32> undef, <16 x i32> undef, <4 x i32> <i32 9, i32 10, i32 11, i32 12>)
  ret void
}

define void @func_caller_byval([16 x i32] addrspace(5)* %argptr) {
; MUBUF-LABEL: func_caller_byval:
; MUBUF:       ; %bb.0:
; MUBUF-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; MUBUF-NEXT:    s_or_saveexec_b64 s[4:5], -1
; MUBUF-NEXT:    buffer_store_dword v40, off, s[0:3], s32 ; 4-byte Folded Spill
; MUBUF-NEXT:    s_mov_b64 exec, s[4:5]
; MUBUF-NEXT:    buffer_load_dword v1, v0, s[0:3], 0 offen
; MUBUF-NEXT:    buffer_load_dword v2, v0, s[0:3], 0 offen offset:4
; MUBUF-NEXT:    v_writelane_b32 v40, s33, 2
; MUBUF-NEXT:    s_mov_b32 s33, s32
; MUBUF-NEXT:    s_addk_i32 s32, 0x400
; MUBUF-NEXT:    v_writelane_b32 v40, s30, 0
; MUBUF-NEXT:    v_writelane_b32 v40, s31, 1
; MUBUF-NEXT:    s_getpc_b64 s[4:5]
; MUBUF-NEXT:    s_add_u32 s4, s4, external_void_func_byval@rel32@lo+4
; MUBUF-NEXT:    s_addc_u32 s5, s5, external_void_func_byval@rel32@hi+12
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v1, off, s[0:3], s32
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v2, off, s[0:3], s32 offset:4
; MUBUF-NEXT:    buffer_load_dword v1, v0, s[0:3], 0 offen offset:8
; MUBUF-NEXT:    s_nop 0
; MUBUF-NEXT:    buffer_load_dword v2, v0, s[0:3], 0 offen offset:12
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v1, off, s[0:3], s32 offset:8
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v2, off, s[0:3], s32 offset:12
; MUBUF-NEXT:    buffer_load_dword v1, v0, s[0:3], 0 offen offset:16
; MUBUF-NEXT:    s_nop 0
; MUBUF-NEXT:    buffer_load_dword v2, v0, s[0:3], 0 offen offset:20
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v1, off, s[0:3], s32 offset:16
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v2, off, s[0:3], s32 offset:20
; MUBUF-NEXT:    buffer_load_dword v1, v0, s[0:3], 0 offen offset:24
; MUBUF-NEXT:    s_nop 0
; MUBUF-NEXT:    buffer_load_dword v2, v0, s[0:3], 0 offen offset:28
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v1, off, s[0:3], s32 offset:24
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v2, off, s[0:3], s32 offset:28
; MUBUF-NEXT:    buffer_load_dword v1, v0, s[0:3], 0 offen offset:32
; MUBUF-NEXT:    s_nop 0
; MUBUF-NEXT:    buffer_load_dword v2, v0, s[0:3], 0 offen offset:36
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v1, off, s[0:3], s32 offset:32
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v2, off, s[0:3], s32 offset:36
; MUBUF-NEXT:    buffer_load_dword v1, v0, s[0:3], 0 offen offset:40
; MUBUF-NEXT:    s_nop 0
; MUBUF-NEXT:    buffer_load_dword v2, v0, s[0:3], 0 offen offset:44
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v1, off, s[0:3], s32 offset:40
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v2, off, s[0:3], s32 offset:44
; MUBUF-NEXT:    buffer_load_dword v1, v0, s[0:3], 0 offen offset:48
; MUBUF-NEXT:    s_nop 0
; MUBUF-NEXT:    buffer_load_dword v2, v0, s[0:3], 0 offen offset:52
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v1, off, s[0:3], s32 offset:48
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v2, off, s[0:3], s32 offset:52
; MUBUF-NEXT:    buffer_load_dword v1, v0, s[0:3], 0 offen offset:56
; MUBUF-NEXT:    s_nop 0
; MUBUF-NEXT:    buffer_load_dword v2, v0, s[0:3], 0 offen offset:60
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v1, off, s[0:3], s32 offset:56
; MUBUF-NEXT:    s_waitcnt vmcnt(1)
; MUBUF-NEXT:    buffer_store_dword v2, off, s[0:3], s32 offset:60
; MUBUF-NEXT:    s_swappc_b64 s[30:31], s[4:5]
; MUBUF-NEXT:    v_readlane_b32 s31, v40, 1
; MUBUF-NEXT:    v_readlane_b32 s30, v40, 0
; MUBUF-NEXT:    s_addk_i32 s32, 0xfc00
; MUBUF-NEXT:    v_readlane_b32 s33, v40, 2
; MUBUF-NEXT:    s_or_saveexec_b64 s[4:5], -1
; MUBUF-NEXT:    buffer_load_dword v40, off, s[0:3], s32 ; 4-byte Folded Reload
; MUBUF-NEXT:    s_mov_b64 exec, s[4:5]
; MUBUF-NEXT:    s_waitcnt vmcnt(0)
; MUBUF-NEXT:    s_setpc_b64 s[30:31]
;
; FLATSCR-LABEL: func_caller_byval:
; FLATSCR:       ; %bb.0:
; FLATSCR-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLATSCR-NEXT:    s_or_saveexec_b64 s[0:1], -1
; FLATSCR-NEXT:    scratch_store_dword off, v40, s32 ; 4-byte Folded Spill
; FLATSCR-NEXT:    s_mov_b64 exec, s[0:1]
; FLATSCR-NEXT:    scratch_load_dwordx2 v[1:2], v0, off
; FLATSCR-NEXT:    v_writelane_b32 v40, s33, 2
; FLATSCR-NEXT:    s_mov_b32 s33, s32
; FLATSCR-NEXT:    s_add_i32 s32, s32, 16
; FLATSCR-NEXT:    v_writelane_b32 v40, s30, 0
; FLATSCR-NEXT:    v_writelane_b32 v40, s31, 1
; FLATSCR-NEXT:    s_getpc_b64 s[0:1]
; FLATSCR-NEXT:    s_add_u32 s0, s0, external_void_func_byval@rel32@lo+4
; FLATSCR-NEXT:    s_addc_u32 s1, s1, external_void_func_byval@rel32@hi+12
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[1:2], s32
; FLATSCR-NEXT:    scratch_load_dwordx2 v[1:2], v0, off offset:8
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[1:2], s32 offset:8
; FLATSCR-NEXT:    scratch_load_dwordx2 v[1:2], v0, off offset:16
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[1:2], s32 offset:16
; FLATSCR-NEXT:    scratch_load_dwordx2 v[1:2], v0, off offset:24
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[1:2], s32 offset:24
; FLATSCR-NEXT:    scratch_load_dwordx2 v[1:2], v0, off offset:32
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[1:2], s32 offset:32
; FLATSCR-NEXT:    scratch_load_dwordx2 v[1:2], v0, off offset:40
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[1:2], s32 offset:40
; FLATSCR-NEXT:    scratch_load_dwordx2 v[1:2], v0, off offset:48
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[1:2], s32 offset:48
; FLATSCR-NEXT:    scratch_load_dwordx2 v[0:1], v0, off offset:56
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    scratch_store_dwordx2 off, v[0:1], s32 offset:56
; FLATSCR-NEXT:    s_swappc_b64 s[30:31], s[0:1]
; FLATSCR-NEXT:    v_readlane_b32 s31, v40, 1
; FLATSCR-NEXT:    v_readlane_b32 s30, v40, 0
; FLATSCR-NEXT:    s_add_i32 s32, s32, -16
; FLATSCR-NEXT:    v_readlane_b32 s33, v40, 2
; FLATSCR-NEXT:    s_or_saveexec_b64 s[0:1], -1
; FLATSCR-NEXT:    scratch_load_dword v40, off, s32 ; 4-byte Folded Reload
; FLATSCR-NEXT:    s_mov_b64 exec, s[0:1]
; FLATSCR-NEXT:    s_waitcnt vmcnt(0)
; FLATSCR-NEXT:    s_setpc_b64 s[30:31]
  %cast = bitcast [16 x i32] addrspace(5)* %argptr to i8 addrspace(5)*
  call void @external_void_func_byval([16 x i32] addrspace(5)* byval([16 x i32]) %argptr)
  ret void
}

declare void @llvm.memset.p5i8.i32(i8 addrspace(5)* nocapture writeonly, i8, i32, i1 immarg) #1

attributes #0 = { nounwind "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" }
attributes #1 = { argmemonly nofree nounwind willreturn writeonly }
