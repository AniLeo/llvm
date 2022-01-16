; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=tahiti -amdgpu-load-store-vectorizer=0 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX6 %s

define i32 @v_bfe_i32_arg_arg_arg(i32 %src0, i32 %src1, i32 %src2) #0 {
; GFX6-LABEL: v_bfe_i32_arg_arg_arg:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_bfe_i32 v0, v0, v1, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 %src0, i32 %src1, i32 %src2)
  ret i32 %bfe_i32
}

define amdgpu_ps i32 @s_bfe_i32_arg_arg_arg(i32 inreg %src0, i32 inreg %src1, i32 inreg %src2) #0 {
; GFX6-LABEL: s_bfe_i32_arg_arg_arg:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_and_b32 s1, s1, 63
; GFX6-NEXT:    s_lshl_b32 s2, s2, 16
; GFX6-NEXT:    s_or_b32 s1, s1, s2
; GFX6-NEXT:    s_bfe_i32 s0, s0, s1
; GFX6-NEXT:    ; return to shader part epilog
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 %src0, i32 %src1, i32 %src2)
  ret i32 %bfe_i32
}

; TODO: Need to expand this
; define i64 @v_bfe_i64_arg_arg_arg(i64 %src0, i32 %src1, i32 %src2) #0 {
;   %bfe_i64 = call i32 @llvm.amdgcn.sbfe.i64(i32 %src0, i32 %src1, i32 %src2)
;   ret i64 %bfe_i64
; }

define amdgpu_ps i64 @s_bfe_i64_arg_arg_arg(i64 inreg %src0, i32 inreg %src1, i32 inreg %src2) #0 {
; GFX6-LABEL: s_bfe_i64_arg_arg_arg:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_and_b32 s2, s2, 63
; GFX6-NEXT:    s_lshl_b32 s3, s3, 16
; GFX6-NEXT:    s_or_b32 s2, s2, s3
; GFX6-NEXT:    s_bfe_i64 s[0:1], s[0:1], s2
; GFX6-NEXT:    ; return to shader part epilog
  %bfe_i32 = call i64 @llvm.amdgcn.sbfe.i64(i64 %src0, i32 %src1, i32 %src2)
  ret i64 %bfe_i32
}

define amdgpu_kernel void @bfe_i32_arg_arg_imm(i32 addrspace(1)* %out, i32 %src0, i32 %src1) #0 {
; GFX6-LABEL: bfe_i32_arg_arg_imm:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dword s3, s[0:1], 0x3
; GFX6-NEXT:    s_load_dword s4, s[0:1], 0x2
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_and_b32 s3, s3, 63
; GFX6-NEXT:    s_or_b32 s3, s3, 0x7b0000
; GFX6-NEXT:    s_bfe_i32 s3, s4, s3
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 %src0, i32 %src1, i32 123)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_arg_imm_arg(i32 addrspace(1)* %out, i32 %src0, i32 %src2) #0 {
; GFX6-LABEL: bfe_i32_arg_imm_arg:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dword s3, s[0:1], 0x3
; GFX6-NEXT:    s_load_dword s4, s[0:1], 0x2
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_lshl_b32 s3, s3, 16
; GFX6-NEXT:    s_or_b32 s3, 59, s3
; GFX6-NEXT:    s_bfe_i32 s3, s4, s3
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 %src0, i32 123, i32 %src2)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_imm_arg_arg(i32 addrspace(1)* %out, i32 %src1, i32 %src2) #0 {
; GFX6-LABEL: bfe_i32_imm_arg_arg:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dword s3, s[0:1], 0x2
; GFX6-NEXT:    s_load_dword s4, s[0:1], 0x3
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_and_b32 s3, s3, 63
; GFX6-NEXT:    s_lshl_b32 s4, s4, 16
; GFX6-NEXT:    s_or_b32 s3, s3, s4
; GFX6-NEXT:    s_bfe_i32 s3, 0x7b, s3
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 123, i32 %src1, i32 %src2)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @v_bfe_print_arg(i32 addrspace(1)* %out, i32 addrspace(1)* %src0) #0 {
; GFX6-LABEL: v_bfe_print_arg:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x80002
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %load = load i32, i32 addrspace(1)* %src0, align 4
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 %load, i32 2, i32 8)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_arg_0_width_reg_offset(i32 addrspace(1)* %out, i32 %src0, i32 %src1) #0 {
; GFX6-LABEL: bfe_i32_arg_0_width_reg_offset:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dword s3, s[0:1], 0x3
; GFX6-NEXT:    s_load_dword s4, s[0:1], 0x2
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_and_b32 s3, s3, 63
; GFX6-NEXT:    s_bfe_i32 s3, s4, s3
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_u32 = call i32 @llvm.amdgcn.sbfe.i32(i32 %src0, i32 %src1, i32 0)
  store i32 %bfe_u32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_arg_0_width_imm_offset(i32 addrspace(1)* %out, i32 %src0, i32 %src1) #0 {
; GFX6-LABEL: bfe_i32_arg_0_width_imm_offset:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dword s3, s[0:1], 0x2
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 8
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_u32 = call i32 @llvm.amdgcn.sbfe.i32(i32 %src0, i32 8, i32 0)
  store i32 %bfe_u32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_test_6(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_i32_test_6:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_lshl_b32 s3, s3, 31
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x1f0001
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %shl = shl i32 %x, 31
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %shl, i32 1, i32 31)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_test_7(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_i32_test_7:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_lshl_b32 s3, s3, 31
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x1f0000
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %shl = shl i32 %x, 31
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %shl, i32 0, i32 31)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_test_8(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_i32_test_8:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_lshl_b32 s3, s3, 31
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x1001f
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %shl = shl i32 %x, 31
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %shl, i32 31, i32 1)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_test_9(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_i32_test_9:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x1001f
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %x, i32 31, i32 1)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_test_10(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_i32_test_10:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x1f0001
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %x, i32 1, i32 31)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_test_11(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_i32_test_11:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x180008
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %x, i32 8, i32 24)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_test_12(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_i32_test_12:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x80018
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %x, i32 24, i32 8)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_test_13(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_i32_test_13:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_ashr_i32 s3, s3, 31
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x1001f
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %shl = ashr i32 %x, 31
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %shl, i32 31, i32 1)
  store i32 %bfe, i32 addrspace(1)* %out, align 4 ret void
}

define amdgpu_kernel void @bfe_i32_test_14(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_i32_test_14:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_lshr_b32 s3, s3, 31
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x1001f
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %shl = lshr i32 %x, 31
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %shl, i32 31, i32 1)
  store i32 %bfe, i32 addrspace(1)* %out, align 4 ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_0(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_0:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_bfe_i32 s2, 0, 0
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 0, i32 0, i32 0)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_1(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_1:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_bfe_i32 s2, 0x302e, 0
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 12334, i32 0, i32 0)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_2(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_2:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_bfe_i32 s2, 0, 0x10000
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 0, i32 0, i32 1)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_3(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_3:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_bfe_i32 s2, 1, 0x10000
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 1, i32 0, i32 1)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_4(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_4:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_bfe_i32 s2, -1, 0x10000
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 4294967295, i32 0, i32 1)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_5(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_5:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x10007
; GFX6-NEXT:    s_bfe_i32 s2, 0x80, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 128, i32 7, i32 1)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_6(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_6:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x80000
; GFX6-NEXT:    s_bfe_i32 s2, 0x80, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 128, i32 0, i32 8)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_7(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_7:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x80000
; GFX6-NEXT:    s_bfe_i32 s2, 0x7f, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 127, i32 0, i32 8)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_8(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_8:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x80006
; GFX6-NEXT:    s_bfe_i32 s2, 0x7f, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 127, i32 6, i32 8)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_9(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_9:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x80010
; GFX6-NEXT:    s_bfe_i32 s2, 0x10000, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 65536, i32 16, i32 8)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_10(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_10:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x100010
; GFX6-NEXT:    s_bfe_i32 s2, 0xffff, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 65535, i32 16, i32 16)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_11(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_11:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x40004
; GFX6-NEXT:    s_bfe_i32 s2, 0xa0, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 160, i32 4, i32 4)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_12(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_12:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x1001f
; GFX6-NEXT:    s_bfe_i32 s2, 0xa0, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 160, i32 31, i32 1)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_13(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_13:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x100010
; GFX6-NEXT:    s_bfe_i32 s2, 0x1fffe, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 131070, i32 16, i32 16)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_14(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_14:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x1e0002
; GFX6-NEXT:    s_bfe_i32 s2, 0xa0, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 160, i32 2, i32 30)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_15(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_15:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x1c0004
; GFX6-NEXT:    s_bfe_i32 s2, 0xa0, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 160, i32 4, i32 28)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_16(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_bfe_i32 s2, -1, 0x70001
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 4294967295, i32 1, i32 7)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_17(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_17:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x1f0001
; GFX6-NEXT:    s_bfe_i32 s2, 0xff, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 255, i32 1, i32 31)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_i32_constant_fold_test_18(i32 addrspace(1)* %out) #0 {
; GFX6-LABEL: bfe_i32_constant_fold_test_18:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, 0x1001f
; GFX6-NEXT:    s_bfe_i32 s2, 0xff, s2
; GFX6-NEXT:    v_mov_b32_e32 v0, s2
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %bfe_i32 = call i32 @llvm.amdgcn.sbfe.i32(i32 255, i32 31, i32 1)
  store i32 %bfe_i32, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_sext_in_reg_i24(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: bfe_sext_in_reg_i24:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x180000
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x180000
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %x, i32 0, i32 24)
  %shl = shl i32 %bfe, 8
  %ashr = ashr i32 %shl, 8
  store i32 %ashr, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @simplify_demanded_bfe_sdiv(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: simplify_demanded_bfe_sdiv:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_rcp_iflag_f32_e32 v0, 2.0
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s6, -1
; GFX6-NEXT:    v_mul_f32_e32 v0, 0x4f7ffffe, v0
; GFX6-NEXT:    v_cvt_u32_f32_e32 v0, v0
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    v_mul_lo_u32 v1, -2, v0
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s2, s2, 0x100001
; GFX6-NEXT:    s_ashr_i32 s3, s2, 31
; GFX6-NEXT:    v_mul_hi_u32 v1, v0, v1
; GFX6-NEXT:    s_add_i32 s2, s2, s3
; GFX6-NEXT:    s_xor_b32 s2, s2, s3
; GFX6-NEXT:    v_add_i32_e32 v0, vcc, v0, v1
; GFX6-NEXT:    v_mul_hi_u32 v0, s2, v0
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 1, v0
; GFX6-NEXT:    v_add_i32_e32 v2, vcc, 1, v0
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, s2, v1
; GFX6-NEXT:    v_cmp_le_u32_e32 vcc, 2, v1
; GFX6-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; GFX6-NEXT:    v_subrev_i32_e64 v2, s[0:1], 2, v1
; GFX6-NEXT:    v_cndmask_b32_e32 v1, v1, v2, vcc
; GFX6-NEXT:    v_add_i32_e32 v2, vcc, 1, v0
; GFX6-NEXT:    v_cmp_le_u32_e32 vcc, 2, v1
; GFX6-NEXT:    v_cndmask_b32_e32 v0, v0, v2, vcc
; GFX6-NEXT:    v_xor_b32_e32 v0, s3, v0
; GFX6-NEXT:    v_subrev_i32_e32 v0, vcc, s3, v0
; GFX6-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX6-NEXT:    s_endpgm
  %src = load i32, i32 addrspace(1)* %in, align 4
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %src, i32 1, i32 16)
  %div = sdiv i32 %bfe, 2
  store i32 %div, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_0_width(i32 addrspace(1)* %out, i32 addrspace(1)* %ptr) #0 {
; GFX6-LABEL: bfe_0_width:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 8
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %load = load i32, i32 addrspace(1)* %ptr, align 4
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %load, i32 8, i32 0)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_8_bfe_8(i32 addrspace(1)* %out, i32 addrspace(1)* %ptr) #0 {
; GFX6-LABEL: bfe_8_bfe_8:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_mov_b32 s4, 0x80000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, s4
; GFX6-NEXT:    s_bfe_i32 s3, s3, s4
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %load = load i32, i32 addrspace(1)* %ptr, align 4
  %bfe0 = call i32 @llvm.amdgcn.sbfe.i32(i32 %load, i32 0, i32 8)
  %bfe1 = call i32 @llvm.amdgcn.sbfe.i32(i32 %bfe0, i32 0, i32 8)
  store i32 %bfe1, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @bfe_8_bfe_16(i32 addrspace(1)* %out, i32 addrspace(1)* %ptr) #0 {
; GFX6-LABEL: bfe_8_bfe_16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x80000
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x100000
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %load = load i32, i32 addrspace(1)* %ptr, align 4
  %bfe0 = call i32 @llvm.amdgcn.sbfe.i32(i32 %load, i32 0, i32 8)
  %bfe1 = call i32 @llvm.amdgcn.sbfe.i32(i32 %bfe0, i32 0, i32 16)
  store i32 %bfe1, i32 addrspace(1)* %out, align 4
  ret void
}

; This really should be folded into 1
define amdgpu_kernel void @bfe_16_bfe_8(i32 addrspace(1)* %out, i32 addrspace(1)* %ptr) #0 {
; GFX6-LABEL: bfe_16_bfe_8:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x100000
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x80000
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %load = load i32, i32 addrspace(1)* %ptr, align 4
  %bfe0 = call i32 @llvm.amdgcn.sbfe.i32(i32 %load, i32 0, i32 16)
  %bfe1 = call i32 @llvm.amdgcn.sbfe.i32(i32 %bfe0, i32 0, i32 8)
  store i32 %bfe1, i32 addrspace(1)* %out, align 4
  ret void
}

; Make sure there isn't a redundant BFE
define amdgpu_kernel void @sext_in_reg_i8_to_i32_bfe(i32 addrspace(1)* %out, i32 %a, i32 %b) #0 {
; GFX6-LABEL: sext_in_reg_i8_to_i32_bfe:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dword s3, s[0:1], 0x2
; GFX6-NEXT:    s_load_dword s4, s[0:1], 0x3
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_add_i32 s3, s3, s4
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x80000
; GFX6-NEXT:    s_sext_i32_i8 s3, s3
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %c = add i32 %a, %b ; add to prevent folding into extload
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %c, i32 0, i32 8)
  %shl = shl i32 %bfe, 24
  %ashr = ashr i32 %shl, 24
  store i32 %ashr, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @sext_in_reg_i8_to_i32_bfe_wrong(i32 addrspace(1)* %out, i32 %a, i32 %b) #0 {
; GFX6-LABEL: sext_in_reg_i8_to_i32_bfe_wrong:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dword s3, s[0:1], 0x2
; GFX6-NEXT:    s_load_dword s4, s[0:1], 0x3
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_add_i32 s3, s3, s4
; GFX6-NEXT:    s_bfe_i32 s3, s3, 8
; GFX6-NEXT:    s_sext_i32_i8 s3, s3
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %c = add i32 %a, %b ; add to prevent folding into extload
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %c, i32 8, i32 0)
  %shl = shl i32 %bfe, 24
  %ashr = ashr i32 %shl, 24
  store i32 %ashr, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @sextload_i8_to_i32_bfe(i32 addrspace(1)* %out, i8 addrspace(1)* %ptr) #0 {
; GFX6-LABEL: sextload_i8_to_i32_bfe:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x2
; GFX6-NEXT:    s_mov_b32 s6, -1
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_load_sbyte v0, off, s[4:7], 0
; GFX6-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x0
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    v_bfe_i32 v0, v0, 0, 8
; GFX6-NEXT:    v_bfe_i32 v0, v0, 0, 8
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX6-NEXT:    s_endpgm
  %load = load i8, i8 addrspace(1)* %ptr, align 1
  %sext = sext i8 %load to i32
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %sext, i32 0, i32 8)
  %shl = shl i32 %bfe, 24
  %ashr = ashr i32 %shl, 24
  store i32 %ashr, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @sextload_i8_to_i32_bfe_0(i32 addrspace(1)* %out, i8 addrspace(1)* %ptr) #0 {
; GFX6-LABEL: sextload_i8_to_i32_bfe_0:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x2
; GFX6-NEXT:    s_mov_b32 s6, -1
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_load_sbyte v0, off, s[4:7], 0
; GFX6-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x0
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    v_bfe_i32 v0, v0, 8, 0
; GFX6-NEXT:    v_bfe_i32 v0, v0, 0, 8
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX6-NEXT:    s_endpgm
  %load = load i8, i8 addrspace(1)* %ptr, align 1
  %sext = sext i8 %load to i32
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %sext, i32 8, i32 0)
  %shl = shl i32 %bfe, 24
  %ashr = ashr i32 %shl, 24
  store i32 %ashr, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @sext_in_reg_i1_bfe_offset_0(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: sext_in_reg_i1_bfe_offset_0:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x10000
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x10000
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %shl = shl i32 %x, 31
  %shr = ashr i32 %shl, 31
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %shr, i32 0, i32 1)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @sext_in_reg_i1_bfe_offset_1(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: sext_in_reg_i1_bfe_offset_1:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x20000
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x10001
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %shl = shl i32 %x, 30
  %shr = ashr i32 %shl, 30
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %shr, i32 1, i32 1)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @sext_in_reg_i2_bfe_offset_1(i32 addrspace(1)* %out, i32 addrspace(1)* %in) #0 {
; GFX6-LABEL: sext_in_reg_i2_bfe_offset_1:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_load_dword s3, s[2:3], 0x0
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x0
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x20000
; GFX6-NEXT:    s_bfe_i32 s3, s3, 0x20001
; GFX6-NEXT:    v_mov_b32_e32 v0, s3
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
  %x = load i32, i32 addrspace(1)* %in, align 4
  %shl = shl i32 %x, 30
  %shr = ashr i32 %shl, 30
  %bfe = call i32 @llvm.amdgcn.sbfe.i32(i32 %shr, i32 1, i32 2)
  store i32 %bfe, i32 addrspace(1)* %out, align 4
  ret void
}

declare i32 @llvm.amdgcn.sbfe.i32(i32, i32, i32) #1
declare i64 @llvm.amdgcn.sbfe.i64(i64, i32, i32) #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
