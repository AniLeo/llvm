; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=tahiti -verify-machineinstrs | FileCheck %s --check-prefixes=FUNC,SI
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=tonga -mattr=-flat-for-global -verify-machineinstrs | FileCheck %s --check-prefixes=FUNC,FLAT,TONGA
; RUN: llc < %s -mtriple=amdgcn-- -mcpu=fiji -mattr=-flat-for-global -verify-machineinstrs | FileCheck %s --check-prefixes=FUNC,FLAT,VI

declare i32 @llvm.amdgcn.workitem.id.x() #1

declare i16 @llvm.bitreverse.i16(i16) #1
declare i32 @llvm.bitreverse.i32(i32) #1
declare i64 @llvm.bitreverse.i64(i64) #1

declare <2 x i32> @llvm.bitreverse.v2i32(<2 x i32>) #1
declare <4 x i32> @llvm.bitreverse.v4i32(<4 x i32>) #1

declare <2 x i64> @llvm.bitreverse.v2i64(<2 x i64>) #1
declare <4 x i64> @llvm.bitreverse.v4i64(<4 x i64>) #1

define amdgpu_kernel void @s_brev_i16(i16 addrspace(1)* noalias %out, i16 %val) #0 {
; SI-LABEL: s_brev_i16:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dword s0, s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_brev_b32 s0, s0
; SI-NEXT:    s_lshr_b32 s0, s0, 16
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    buffer_store_short v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: s_brev_i16:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dword s0, s[0:1], 0x2c
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    s_brev_b32 s0, s0
; FLAT-NEXT:    s_lshr_b32 s0, s0, 16
; FLAT-NEXT:    v_mov_b32_e32 v0, s0
; FLAT-NEXT:    buffer_store_short v0, off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
  %brev = call i16 @llvm.bitreverse.i16(i16 %val) #1
  store i16 %brev, i16 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @v_brev_i16(i16 addrspace(1)* noalias %out, i16 addrspace(1)* noalias %valptr) #0 {
; SI-LABEL: v_brev_i16:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_mov_b32 s2, s6
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_ushort v0, off, s[0:3], 0
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_bfrev_b32_e32 v0, v0
; SI-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; SI-NEXT:    buffer_store_short v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: v_brev_i16:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    s_mov_b32 s2, s6
; FLAT-NEXT:    s_mov_b32 s3, s7
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    buffer_load_ushort v0, off, s[0:3], 0
; FLAT-NEXT:    s_waitcnt vmcnt(0)
; FLAT-NEXT:    v_bfrev_b32_e32 v0, v0
; FLAT-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; FLAT-NEXT:    buffer_store_short v0, off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
  %val = load i16, i16 addrspace(1)* %valptr
  %brev = call i16 @llvm.bitreverse.i16(i16 %val) #1
  store i16 %brev, i16 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @s_brev_i32(i32 addrspace(1)* noalias %out, i32 %val) #0 {
; SI-LABEL: s_brev_i32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dword s0, s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_brev_b32 s0, s0
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: s_brev_i32:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dword s0, s[0:1], 0x2c
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    s_brev_b32 s0, s0
; FLAT-NEXT:    v_mov_b32_e32 v0, s0
; FLAT-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
  %brev = call i32 @llvm.bitreverse.i32(i32 %val) #1
  store i32 %brev, i32 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @v_brev_i32(i32 addrspace(1)* noalias %out, i32 addrspace(1)* noalias %valptr) #0 {
; SI-LABEL: v_brev_i32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_dword v0, v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_bfrev_b32_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: v_brev_i32:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; FLAT-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    v_mov_b32_e32 v1, s1
; FLAT-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; FLAT-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; FLAT-NEXT:    flat_load_dword v0, v[0:1]
; FLAT-NEXT:    s_waitcnt vmcnt(0)
; FLAT-NEXT:    v_bfrev_b32_e32 v0, v0
; FLAT-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i32, i32 addrspace(1)* %valptr, i32 %tid
  %val = load i32, i32 addrspace(1)* %gep
  %brev = call i32 @llvm.bitreverse.i32(i32 %val) #1
  store i32 %brev, i32 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @s_brev_v2i32(<2 x i32> addrspace(1)* noalias %out, <2 x i32> %val) #0 {
; SI-LABEL: s_brev_v2i32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_brev_b32 s1, s1
; SI-NEXT:    s_brev_b32 s0, s0
; SI-NEXT:    v_mov_b32_e32 v0, s0
; SI-NEXT:    v_mov_b32_e32 v1, s1
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: s_brev_v2i32:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    s_brev_b32 s1, s1
; FLAT-NEXT:    s_brev_b32 s0, s0
; FLAT-NEXT:    v_mov_b32_e32 v0, s0
; FLAT-NEXT:    v_mov_b32_e32 v1, s1
; FLAT-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
  %brev = call <2 x i32> @llvm.bitreverse.v2i32(<2 x i32> %val) #1
  store <2 x i32> %brev, <2 x i32> addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @v_brev_v2i32(<2 x i32> addrspace(1)* noalias %out, <2 x i32> addrspace(1)* noalias %valptr) #0 {
; SI-LABEL: v_brev_v2i32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_dwordx2 v[0:1], v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_bfrev_b32_e32 v1, v1
; SI-NEXT:    v_bfrev_b32_e32 v0, v0
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: v_brev_v2i32:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; FLAT-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    v_mov_b32_e32 v1, s1
; FLAT-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; FLAT-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; FLAT-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; FLAT-NEXT:    s_waitcnt vmcnt(0)
; FLAT-NEXT:    v_bfrev_b32_e32 v1, v1
; FLAT-NEXT:    v_bfrev_b32_e32 v0, v0
; FLAT-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr <2 x i32>, <2 x i32> addrspace(1)* %valptr, i32 %tid
  %val = load <2 x i32>, <2 x i32> addrspace(1)* %gep
  %brev = call <2 x i32> @llvm.bitreverse.v2i32(<2 x i32> %val) #1
  store <2 x i32> %brev, <2 x i32> addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @s_brev_i64(i64 addrspace(1)* noalias %out, i64 %val) #0 {
; SI-LABEL: s_brev_i64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s4, 0xff00ff
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_alignbit_b32 v0, s2, s2, 8
; SI-NEXT:    v_alignbit_b32 v1, s2, s2, 24
; SI-NEXT:    v_alignbit_b32 v2, s3, s3, 8
; SI-NEXT:    v_alignbit_b32 v3, s3, s3, 24
; SI-NEXT:    v_bfi_b32 v4, s4, v1, v0
; SI-NEXT:    s_mov_b32 s2, 0xf0f0f0f
; SI-NEXT:    v_bfi_b32 v2, s4, v3, v2
; SI-NEXT:    v_and_b32_e32 v1, s2, v4
; SI-NEXT:    v_and_b32_e32 v0, s2, v2
; SI-NEXT:    s_mov_b32 s2, 0xf0f0f0f0
; SI-NEXT:    v_and_b32_e32 v3, s2, v4
; SI-NEXT:    v_and_b32_e32 v2, s2, v2
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 4
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 4
; SI-NEXT:    s_mov_b32 s2, 0x33333333
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    v_and_b32_e32 v1, s2, v3
; SI-NEXT:    v_and_b32_e32 v0, s2, v2
; SI-NEXT:    s_mov_b32 s2, 0xcccccccc
; SI-NEXT:    v_and_b32_e32 v3, s2, v3
; SI-NEXT:    v_and_b32_e32 v2, s2, v2
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 2
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 2
; SI-NEXT:    s_mov_b32 s2, 0x55555555
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    v_and_b32_e32 v1, s2, v3
; SI-NEXT:    v_and_b32_e32 v0, s2, v2
; SI-NEXT:    s_mov_b32 s2, 0xaaaaaaaa
; SI-NEXT:    v_and_b32_e32 v3, s2, v3
; SI-NEXT:    v_and_b32_e32 v2, s2, v2
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 1
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 1
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    v_or_b32_e32 v0, v2, v0
; SI-NEXT:    v_or_b32_e32 v1, v3, v1
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: s_brev_i64:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x2c
; FLAT-NEXT:    v_mov_b32_e32 v0, 0x10203
; FLAT-NEXT:    s_mov_b32 s4, 0xf0f0f0f
; FLAT-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    v_perm_b32 v2, 0, s2, v0
; FLAT-NEXT:    v_perm_b32 v4, 0, s3, v0
; FLAT-NEXT:    s_mov_b32 s2, 0xf0f0f0f0
; FLAT-NEXT:    v_and_b32_e32 v1, s4, v2
; FLAT-NEXT:    v_and_b32_e32 v0, s4, v4
; FLAT-NEXT:    v_and_b32_e32 v3, s2, v2
; FLAT-NEXT:    v_and_b32_e32 v2, s2, v4
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 4, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 4, v[2:3]
; FLAT-NEXT:    s_mov_b32 s2, 0x33333333
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    v_and_b32_e32 v1, s2, v3
; FLAT-NEXT:    v_and_b32_e32 v0, s2, v2
; FLAT-NEXT:    s_mov_b32 s2, 0xcccccccc
; FLAT-NEXT:    v_and_b32_e32 v3, s2, v3
; FLAT-NEXT:    v_and_b32_e32 v2, s2, v2
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 2, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 2, v[2:3]
; FLAT-NEXT:    s_mov_b32 s2, 0x55555555
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    v_and_b32_e32 v1, s2, v3
; FLAT-NEXT:    v_and_b32_e32 v0, s2, v2
; FLAT-NEXT:    s_mov_b32 s2, 0xaaaaaaaa
; FLAT-NEXT:    v_and_b32_e32 v3, s2, v3
; FLAT-NEXT:    v_and_b32_e32 v2, s2, v2
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 1, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 1, v[2:3]
; FLAT-NEXT:    s_mov_b32 s3, 0xf000
; FLAT-NEXT:    s_mov_b32 s2, -1
; FLAT-NEXT:    v_or_b32_e32 v0, v2, v0
; FLAT-NEXT:    v_or_b32_e32 v1, v3, v1
; FLAT-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; FLAT-NEXT:    s_endpgm
  %brev = call i64 @llvm.bitreverse.i64(i64 %val) #1
  store i64 %brev, i64 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @v_brev_i64(i64 addrspace(1)* noalias %out, i64 addrspace(1)* noalias %valptr) #0 {
; SI-LABEL: v_brev_i64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_dwordx2 v[0:1], v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s0, 0xff00ff
; SI-NEXT:    s_mov_b32 s1, 0xf0f0f0f
; SI-NEXT:    s_mov_b32 s2, 0xf0f0f0f0
; SI-NEXT:    s_mov_b32 s3, 0x33333333
; SI-NEXT:    s_mov_b32 s6, 0xcccccccc
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_alignbit_b32 v2, v0, v0, 8
; SI-NEXT:    v_alignbit_b32 v0, v0, v0, 24
; SI-NEXT:    v_alignbit_b32 v3, v1, v1, 8
; SI-NEXT:    v_alignbit_b32 v1, v1, v1, 24
; SI-NEXT:    v_bfi_b32 v2, s0, v0, v2
; SI-NEXT:    v_bfi_b32 v4, s0, v1, v3
; SI-NEXT:    v_and_b32_e32 v1, s1, v2
; SI-NEXT:    v_and_b32_e32 v0, s1, v4
; SI-NEXT:    v_and_b32_e32 v3, s2, v2
; SI-NEXT:    v_and_b32_e32 v2, s2, v4
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 4
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 4
; SI-NEXT:    s_mov_b32 s0, 0x55555555
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_and_b32_e32 v1, s3, v3
; SI-NEXT:    v_and_b32_e32 v0, s3, v2
; SI-NEXT:    v_and_b32_e32 v3, s6, v3
; SI-NEXT:    v_and_b32_e32 v2, s6, v2
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 2
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 2
; SI-NEXT:    s_mov_b32 s1, 0xaaaaaaaa
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_and_b32_e32 v1, s0, v3
; SI-NEXT:    v_and_b32_e32 v0, s0, v2
; SI-NEXT:    v_and_b32_e32 v3, s1, v3
; SI-NEXT:    v_and_b32_e32 v2, s1, v2
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 1
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 1
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    v_or_b32_e32 v1, v3, v1
; SI-NEXT:    v_or_b32_e32 v0, v2, v0
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: v_brev_i64:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; FLAT-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; FLAT-NEXT:    s_mov_b32 s2, 0xf0f0f0f0
; FLAT-NEXT:    s_mov_b32 s3, 0x33333333
; FLAT-NEXT:    s_mov_b32 s6, 0xcccccccc
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    v_mov_b32_e32 v1, s1
; FLAT-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; FLAT-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; FLAT-NEXT:    flat_load_dwordx2 v[0:1], v[0:1]
; FLAT-NEXT:    s_mov_b32 s0, 0x10203
; FLAT-NEXT:    s_mov_b32 s1, 0xf0f0f0f
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_waitcnt vmcnt(0)
; FLAT-NEXT:    v_perm_b32 v2, 0, v0, s0
; FLAT-NEXT:    v_perm_b32 v4, 0, v1, s0
; FLAT-NEXT:    v_and_b32_e32 v1, s1, v2
; FLAT-NEXT:    v_and_b32_e32 v0, s1, v4
; FLAT-NEXT:    v_and_b32_e32 v3, s2, v2
; FLAT-NEXT:    v_and_b32_e32 v2, s2, v4
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 4, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 4, v[2:3]
; FLAT-NEXT:    s_mov_b32 s0, 0x55555555
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    v_and_b32_e32 v1, s3, v3
; FLAT-NEXT:    v_and_b32_e32 v0, s3, v2
; FLAT-NEXT:    v_and_b32_e32 v3, s6, v3
; FLAT-NEXT:    v_and_b32_e32 v2, s6, v2
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 2, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 2, v[2:3]
; FLAT-NEXT:    s_mov_b32 s1, 0xaaaaaaaa
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    v_and_b32_e32 v1, s0, v3
; FLAT-NEXT:    v_and_b32_e32 v0, s0, v2
; FLAT-NEXT:    v_and_b32_e32 v3, s1, v3
; FLAT-NEXT:    v_and_b32_e32 v2, s1, v2
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 1, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 1, v[2:3]
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    v_or_b32_e32 v1, v3, v1
; FLAT-NEXT:    v_or_b32_e32 v0, v2, v0
; FLAT-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i64, i64 addrspace(1)* %valptr, i32 %tid
  %val = load i64, i64 addrspace(1)* %gep
  %brev = call i64 @llvm.bitreverse.i64(i64 %val) #1
  store i64 %brev, i64 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @s_brev_v2i64(<2 x i64> addrspace(1)* noalias %out, <2 x i64> %val) #0 {
; SI-LABEL: s_brev_v2i64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s8, 0xff00ff
; SI-NEXT:    s_mov_b32 s9, 0x33333333
; SI-NEXT:    s_mov_b32 s10, 0xcccccccc
; SI-NEXT:    s_mov_b32 s11, 0x55555555
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    v_alignbit_b32 v0, s2, s2, 8
; SI-NEXT:    v_alignbit_b32 v1, s2, s2, 24
; SI-NEXT:    v_bfi_b32 v3, s8, v1, v0
; SI-NEXT:    v_alignbit_b32 v2, s3, s3, 8
; SI-NEXT:    v_alignbit_b32 v0, s3, s3, 24
; SI-NEXT:    s_mov_b32 s2, 0xf0f0f0f
; SI-NEXT:    v_bfi_b32 v2, s8, v0, v2
; SI-NEXT:    s_mov_b32 s3, 0xf0f0f0f0
; SI-NEXT:    v_and_b32_e32 v0, s2, v2
; SI-NEXT:    v_and_b32_e32 v1, s2, v3
; SI-NEXT:    v_and_b32_e32 v2, s3, v2
; SI-NEXT:    v_and_b32_e32 v3, s3, v3
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 4
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 4
; SI-NEXT:    v_alignbit_b32 v4, s0, s0, 8
; SI-NEXT:    v_alignbit_b32 v5, s0, s0, 24
; SI-NEXT:    v_bfi_b32 v7, s8, v5, v4
; SI-NEXT:    v_alignbit_b32 v4, s1, s1, 8
; SI-NEXT:    v_alignbit_b32 v5, s1, s1, 24
; SI-NEXT:    v_bfi_b32 v6, s8, v5, v4
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    v_and_b32_e32 v0, s9, v2
; SI-NEXT:    v_and_b32_e32 v1, s9, v3
; SI-NEXT:    v_and_b32_e32 v4, s2, v6
; SI-NEXT:    v_and_b32_e32 v5, s2, v7
; SI-NEXT:    v_and_b32_e32 v2, s10, v2
; SI-NEXT:    v_and_b32_e32 v3, s10, v3
; SI-NEXT:    v_and_b32_e32 v6, s3, v6
; SI-NEXT:    v_and_b32_e32 v7, s3, v7
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 2
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 2
; SI-NEXT:    v_lshl_b64 v[4:5], v[4:5], 4
; SI-NEXT:    v_lshr_b64 v[6:7], v[6:7], 4
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    v_or_b32_e32 v6, v6, v4
; SI-NEXT:    v_or_b32_e32 v7, v7, v5
; SI-NEXT:    s_mov_b32 s12, 0xaaaaaaaa
; SI-NEXT:    v_and_b32_e32 v0, s11, v2
; SI-NEXT:    v_and_b32_e32 v1, s11, v3
; SI-NEXT:    v_and_b32_e32 v4, s9, v6
; SI-NEXT:    v_and_b32_e32 v5, s9, v7
; SI-NEXT:    v_and_b32_e32 v2, s12, v2
; SI-NEXT:    v_and_b32_e32 v3, s12, v3
; SI-NEXT:    v_and_b32_e32 v6, s10, v6
; SI-NEXT:    v_and_b32_e32 v7, s10, v7
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 1
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 1
; SI-NEXT:    v_lshl_b64 v[4:5], v[4:5], 2
; SI-NEXT:    v_lshr_b64 v[6:7], v[6:7], 2
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_or_b32_e32 v0, v6, v4
; SI-NEXT:    v_or_b32_e32 v7, v7, v5
; SI-NEXT:    v_and_b32_e32 v5, s11, v7
; SI-NEXT:    v_and_b32_e32 v4, s11, v0
; SI-NEXT:    v_and_b32_e32 v6, s12, v0
; SI-NEXT:    v_and_b32_e32 v7, s12, v7
; SI-NEXT:    v_lshl_b64 v[4:5], v[4:5], 1
; SI-NEXT:    v_lshr_b64 v[6:7], v[6:7], 1
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    v_or_b32_e32 v0, v6, v4
; SI-NEXT:    v_or_b32_e32 v1, v7, v5
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: s_brev_v2i64:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x34
; FLAT-NEXT:    v_mov_b32_e32 v4, 0x10203
; FLAT-NEXT:    s_mov_b32 s8, 0xf0f0f0f
; FLAT-NEXT:    s_mov_b32 s9, 0xcccccccc
; FLAT-NEXT:    s_mov_b32 s10, 0x55555555
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    v_perm_b32 v3, 0, s2, v4
; FLAT-NEXT:    v_perm_b32 v2, 0, s3, v4
; FLAT-NEXT:    s_mov_b32 s2, 0xf0f0f0f0
; FLAT-NEXT:    v_and_b32_e32 v0, s8, v2
; FLAT-NEXT:    v_and_b32_e32 v1, s8, v3
; FLAT-NEXT:    v_and_b32_e32 v2, s2, v2
; FLAT-NEXT:    v_and_b32_e32 v3, s2, v3
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 4, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 4, v[2:3]
; FLAT-NEXT:    v_perm_b32 v7, 0, s0, v4
; FLAT-NEXT:    v_perm_b32 v6, 0, s1, v4
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    s_mov_b32 s3, 0x33333333
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    v_and_b32_e32 v0, s3, v2
; FLAT-NEXT:    v_and_b32_e32 v1, s3, v3
; FLAT-NEXT:    v_and_b32_e32 v4, s8, v6
; FLAT-NEXT:    v_and_b32_e32 v5, s8, v7
; FLAT-NEXT:    v_and_b32_e32 v2, s9, v2
; FLAT-NEXT:    v_and_b32_e32 v3, s9, v3
; FLAT-NEXT:    v_and_b32_e32 v6, s2, v6
; FLAT-NEXT:    v_and_b32_e32 v7, s2, v7
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 2, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 2, v[2:3]
; FLAT-NEXT:    v_lshlrev_b64 v[4:5], 4, v[4:5]
; FLAT-NEXT:    v_lshrrev_b64 v[6:7], 4, v[6:7]
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    v_or_b32_e32 v6, v6, v4
; FLAT-NEXT:    v_or_b32_e32 v7, v7, v5
; FLAT-NEXT:    s_mov_b32 s11, 0xaaaaaaaa
; FLAT-NEXT:    v_and_b32_e32 v0, s10, v2
; FLAT-NEXT:    v_and_b32_e32 v1, s10, v3
; FLAT-NEXT:    v_and_b32_e32 v4, s3, v6
; FLAT-NEXT:    v_and_b32_e32 v5, s3, v7
; FLAT-NEXT:    v_and_b32_e32 v2, s11, v2
; FLAT-NEXT:    v_and_b32_e32 v3, s11, v3
; FLAT-NEXT:    v_and_b32_e32 v6, s9, v6
; FLAT-NEXT:    v_and_b32_e32 v7, s9, v7
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 1, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 1, v[2:3]
; FLAT-NEXT:    v_lshlrev_b64 v[4:5], 2, v[4:5]
; FLAT-NEXT:    v_lshrrev_b64 v[6:7], 2, v[6:7]
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    v_or_b32_e32 v0, v6, v4
; FLAT-NEXT:    v_or_b32_e32 v7, v7, v5
; FLAT-NEXT:    v_and_b32_e32 v5, s10, v7
; FLAT-NEXT:    v_and_b32_e32 v4, s10, v0
; FLAT-NEXT:    v_and_b32_e32 v6, s11, v0
; FLAT-NEXT:    v_and_b32_e32 v7, s11, v7
; FLAT-NEXT:    v_lshlrev_b64 v[4:5], 1, v[4:5]
; FLAT-NEXT:    v_lshrrev_b64 v[6:7], 1, v[6:7]
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    v_or_b32_e32 v0, v6, v4
; FLAT-NEXT:    v_or_b32_e32 v1, v7, v5
; FLAT-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
  %brev = call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %val) #1
  store <2 x i64> %brev, <2 x i64> addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @v_brev_v2i64(<2 x i64> addrspace(1)* noalias %out, <2 x i64> addrspace(1)* noalias %valptr) #0 {
; SI-LABEL: v_brev_v2i64:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 4, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_dwordx4 v[0:3], v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s0, 0xff00ff
; SI-NEXT:    s_mov_b32 s1, 0xf0f0f0f
; SI-NEXT:    s_mov_b32 s2, 0xf0f0f0f0
; SI-NEXT:    s_mov_b32 s3, 0x33333333
; SI-NEXT:    s_mov_b32 s8, 0xcccccccc
; SI-NEXT:    s_mov_b32 s9, 0x55555555
; SI-NEXT:    s_mov_b32 s10, 0xaaaaaaaa
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_alignbit_b32 v4, v2, v2, 8
; SI-NEXT:    v_alignbit_b32 v2, v2, v2, 24
; SI-NEXT:    v_alignbit_b32 v5, v3, v3, 8
; SI-NEXT:    v_alignbit_b32 v6, v0, v0, 8
; SI-NEXT:    v_alignbit_b32 v0, v0, v0, 24
; SI-NEXT:    v_alignbit_b32 v7, v1, v1, 8
; SI-NEXT:    v_alignbit_b32 v1, v1, v1, 24
; SI-NEXT:    v_alignbit_b32 v3, v3, v3, 24
; SI-NEXT:    v_bfi_b32 v2, s0, v2, v4
; SI-NEXT:    v_bfi_b32 v4, s0, v3, v5
; SI-NEXT:    v_bfi_b32 v6, s0, v0, v6
; SI-NEXT:    v_bfi_b32 v8, s0, v1, v7
; SI-NEXT:    v_and_b32_e32 v1, s1, v2
; SI-NEXT:    v_and_b32_e32 v0, s1, v4
; SI-NEXT:    v_and_b32_e32 v3, s2, v2
; SI-NEXT:    v_and_b32_e32 v2, s2, v4
; SI-NEXT:    v_and_b32_e32 v5, s1, v6
; SI-NEXT:    v_and_b32_e32 v4, s1, v8
; SI-NEXT:    v_and_b32_e32 v7, s2, v6
; SI-NEXT:    v_and_b32_e32 v6, s2, v8
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 4
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 4
; SI-NEXT:    v_lshl_b64 v[4:5], v[4:5], 4
; SI-NEXT:    v_lshr_b64 v[6:7], v[6:7], 4
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_or_b32_e32 v7, v7, v5
; SI-NEXT:    v_or_b32_e32 v6, v6, v4
; SI-NEXT:    v_and_b32_e32 v1, s3, v3
; SI-NEXT:    v_and_b32_e32 v0, s3, v2
; SI-NEXT:    v_and_b32_e32 v5, s3, v7
; SI-NEXT:    v_and_b32_e32 v4, s3, v6
; SI-NEXT:    v_and_b32_e32 v3, s8, v3
; SI-NEXT:    v_and_b32_e32 v2, s8, v2
; SI-NEXT:    v_and_b32_e32 v7, s8, v7
; SI-NEXT:    v_and_b32_e32 v6, s8, v6
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 2
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 2
; SI-NEXT:    v_lshl_b64 v[4:5], v[4:5], 2
; SI-NEXT:    v_lshr_b64 v[6:7], v[6:7], 2
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_or_b32_e32 v7, v7, v5
; SI-NEXT:    v_or_b32_e32 v6, v6, v4
; SI-NEXT:    v_and_b32_e32 v1, s9, v3
; SI-NEXT:    v_and_b32_e32 v0, s9, v2
; SI-NEXT:    v_and_b32_e32 v5, s9, v7
; SI-NEXT:    v_and_b32_e32 v4, s9, v6
; SI-NEXT:    v_and_b32_e32 v3, s10, v3
; SI-NEXT:    v_and_b32_e32 v2, s10, v2
; SI-NEXT:    v_and_b32_e32 v7, s10, v7
; SI-NEXT:    v_and_b32_e32 v6, s10, v6
; SI-NEXT:    v_lshl_b64 v[0:1], v[0:1], 1
; SI-NEXT:    v_lshr_b64 v[2:3], v[2:3], 1
; SI-NEXT:    v_lshl_b64 v[4:5], v[4:5], 1
; SI-NEXT:    v_lshr_b64 v[6:7], v[6:7], 1
; SI-NEXT:    v_or_b32_e32 v3, v3, v1
; SI-NEXT:    v_or_b32_e32 v2, v2, v0
; SI-NEXT:    v_or_b32_e32 v1, v7, v5
; SI-NEXT:    v_or_b32_e32 v0, v6, v4
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; FLAT-LABEL: v_brev_v2i64:
; FLAT:       ; %bb.0:
; FLAT-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; FLAT-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; FLAT-NEXT:    v_lshlrev_b32_e32 v0, 4, v0
; FLAT-NEXT:    s_mov_b32 s2, 0xf0f0f0f0
; FLAT-NEXT:    s_mov_b32 s3, 0x33333333
; FLAT-NEXT:    s_mov_b32 s8, 0xcccccccc
; FLAT-NEXT:    s_waitcnt lgkmcnt(0)
; FLAT-NEXT:    v_mov_b32_e32 v1, s1
; FLAT-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; FLAT-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; FLAT-NEXT:    flat_load_dwordx4 v[0:3], v[0:1]
; FLAT-NEXT:    s_mov_b32 s0, 0x10203
; FLAT-NEXT:    s_mov_b32 s1, 0xf0f0f0f
; FLAT-NEXT:    s_mov_b32 s9, 0x55555555
; FLAT-NEXT:    s_mov_b32 s10, 0xaaaaaaaa
; FLAT-NEXT:    s_mov_b32 s7, 0xf000
; FLAT-NEXT:    s_mov_b32 s6, -1
; FLAT-NEXT:    s_waitcnt vmcnt(0)
; FLAT-NEXT:    v_perm_b32 v6, 0, v0, s0
; FLAT-NEXT:    v_perm_b32 v4, 0, v3, s0
; FLAT-NEXT:    v_perm_b32 v2, 0, v2, s0
; FLAT-NEXT:    v_perm_b32 v8, 0, v1, s0
; FLAT-NEXT:    v_and_b32_e32 v1, s1, v2
; FLAT-NEXT:    v_and_b32_e32 v0, s1, v4
; FLAT-NEXT:    v_and_b32_e32 v3, s2, v2
; FLAT-NEXT:    v_and_b32_e32 v2, s2, v4
; FLAT-NEXT:    v_and_b32_e32 v5, s1, v6
; FLAT-NEXT:    v_and_b32_e32 v4, s1, v8
; FLAT-NEXT:    v_and_b32_e32 v7, s2, v6
; FLAT-NEXT:    v_and_b32_e32 v6, s2, v8
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 4, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 4, v[2:3]
; FLAT-NEXT:    v_lshlrev_b64 v[4:5], 4, v[4:5]
; FLAT-NEXT:    v_lshrrev_b64 v[6:7], 4, v[6:7]
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    v_or_b32_e32 v7, v7, v5
; FLAT-NEXT:    v_or_b32_e32 v6, v6, v4
; FLAT-NEXT:    v_and_b32_e32 v1, s3, v3
; FLAT-NEXT:    v_and_b32_e32 v0, s3, v2
; FLAT-NEXT:    v_and_b32_e32 v5, s3, v7
; FLAT-NEXT:    v_and_b32_e32 v4, s3, v6
; FLAT-NEXT:    v_and_b32_e32 v3, s8, v3
; FLAT-NEXT:    v_and_b32_e32 v2, s8, v2
; FLAT-NEXT:    v_and_b32_e32 v7, s8, v7
; FLAT-NEXT:    v_and_b32_e32 v6, s8, v6
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 2, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 2, v[2:3]
; FLAT-NEXT:    v_lshlrev_b64 v[4:5], 2, v[4:5]
; FLAT-NEXT:    v_lshrrev_b64 v[6:7], 2, v[6:7]
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    v_or_b32_e32 v7, v7, v5
; FLAT-NEXT:    v_or_b32_e32 v6, v6, v4
; FLAT-NEXT:    v_and_b32_e32 v1, s9, v3
; FLAT-NEXT:    v_and_b32_e32 v0, s9, v2
; FLAT-NEXT:    v_and_b32_e32 v5, s9, v7
; FLAT-NEXT:    v_and_b32_e32 v4, s9, v6
; FLAT-NEXT:    v_and_b32_e32 v3, s10, v3
; FLAT-NEXT:    v_and_b32_e32 v2, s10, v2
; FLAT-NEXT:    v_and_b32_e32 v7, s10, v7
; FLAT-NEXT:    v_and_b32_e32 v6, s10, v6
; FLAT-NEXT:    v_lshlrev_b64 v[0:1], 1, v[0:1]
; FLAT-NEXT:    v_lshrrev_b64 v[2:3], 1, v[2:3]
; FLAT-NEXT:    v_lshlrev_b64 v[4:5], 1, v[4:5]
; FLAT-NEXT:    v_lshrrev_b64 v[6:7], 1, v[6:7]
; FLAT-NEXT:    v_or_b32_e32 v3, v3, v1
; FLAT-NEXT:    v_or_b32_e32 v2, v2, v0
; FLAT-NEXT:    v_or_b32_e32 v1, v7, v5
; FLAT-NEXT:    v_or_b32_e32 v0, v6, v4
; FLAT-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; FLAT-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr <2 x i64> , <2 x i64> addrspace(1)* %valptr, i32 %tid
  %val = load <2 x i64>, <2 x i64> addrspace(1)* %gep
  %brev = call <2 x i64> @llvm.bitreverse.v2i64(<2 x i64> %val) #1
  store <2 x i64> %brev, <2 x i64> addrspace(1)* %out
  ret void
}

define float @missing_truncate_promote_bitreverse(i32 %arg) {
; SI-LABEL: missing_truncate_promote_bitreverse:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; SI-NEXT:    v_bfrev_b32_e32 v0, v0
; SI-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; SI-NEXT:    v_cvt_f32_f16_e32 v0, v0
; SI-NEXT:    s_setpc_b64 s[30:31]
;
; FLAT-LABEL: missing_truncate_promote_bitreverse:
; FLAT:       ; %bb.0: ; %bb
; FLAT-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; FLAT-NEXT:    v_bfrev_b32_e32 v0, v0
; FLAT-NEXT:    v_cvt_f32_f16_sdwa v0, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; FLAT-NEXT:    s_setpc_b64 s[30:31]
bb:
  %tmp = trunc i32 %arg to i16
  %tmp1 = call i16 @llvm.bitreverse.i16(i16 %tmp)
  %tmp2 = bitcast i16 %tmp1 to half
  %tmp3 = fpext half %tmp2 to float
  ret float %tmp3
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
