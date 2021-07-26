; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=fiji -verify-machineinstrs -o - %s | FileCheck -check-prefix=GFX8 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 -verify-machineinstrs -o - %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs -o - %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_kernel void @constant_load_i8_align4(i8 addrspace (1)* %out, i8 addrspace(4)* %in) #0 {
; GFX8-LABEL: constant_load_i8_align4:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v2, s2
; GFX8-NEXT:    flat_store_byte v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: constant_load_i8_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    global_store_byte v1, v0, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: constant_load_i8_align4:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    global_store_byte v1, v0, s[0:1]
; GFX10-NEXT:    s_endpgm
  %ld = load i8, i8 addrspace(4)* %in, align 4
  store i8 %ld, i8 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @constant_load_i16_align4(i16 addrspace (1)* %out, i16 addrspace(4)* %in) #0 {
; GFX8-LABEL: constant_load_i16_align4:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v2, s2
; GFX8-NEXT:    flat_store_short v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: constant_load_i16_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    global_store_short v1, v0, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: constant_load_i16_align4:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    global_store_short v1, v0, s[0:1]
; GFX10-NEXT:    s_endpgm
  %ld = load i16, i16 addrspace(4)* %in, align 4
  store i16 %ld, i16 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @sextload_i8_to_i32_align4(i32 addrspace(1)* %out, i8 addrspace(1)* %in) #0 {
; GFX8-LABEL: sextload_i8_to_i32_align4:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_sext_i32_i8 s2, s2
; GFX8-NEXT:    v_mov_b32_e32 v2, s2
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: sextload_i8_to_i32_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_sext_i32_i8 s2, s2
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    global_store_dword v1, v0, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: sextload_i8_to_i32_align4:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_sext_i32_i8 s2, s2
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    global_store_dword v1, v0, s[0:1]
; GFX10-NEXT:    s_endpgm
  %load = load i8, i8 addrspace(1)* %in, align 4
  %sext = sext i8 %load to i32
  store i32 %sext, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @sextload_i16_to_i32_align4(i32 addrspace(1)* %out, i16 addrspace(1)* %in) #0 {
; GFX8-LABEL: sextload_i16_to_i32_align4:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_sext_i32_i16 s2, s2
; GFX8-NEXT:    v_mov_b32_e32 v2, s2
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: sextload_i16_to_i32_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_sext_i32_i16 s2, s2
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    global_store_dword v1, v0, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: sextload_i16_to_i32_align4:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_sext_i32_i16 s2, s2
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    global_store_dword v1, v0, s[0:1]
; GFX10-NEXT:    s_endpgm
  %load = load i16, i16 addrspace(1)* %in, align 4
  %sext = sext i16 %load to i32
  store i32 %sext, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @zextload_i8_to_i32_align4(i32 addrspace(1)* %out, i8 addrspace(1)* %in) #0 {
; GFX8-LABEL: zextload_i8_to_i32_align4:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_and_b32 s2, s2, 0xff
; GFX8-NEXT:    v_mov_b32_e32 v2, s2
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: zextload_i8_to_i32_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_and_b32 s2, s2, 0xff
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    global_store_dword v1, v0, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: zextload_i8_to_i32_align4:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_and_b32 s2, s2, 0xff
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    global_store_dword v1, v0, s[0:1]
; GFX10-NEXT:    s_endpgm
  %load = load i8, i8 addrspace(1)* %in, align 4
  %zext = zext i8 %load to i32
  store i32 %zext, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @zextload_i16_to_i32_align4(i32 addrspace(1)* %out, i16 addrspace(1)* %in) #0 {
; GFX8-LABEL: zextload_i16_to_i32_align4:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_and_b32 s2, s2, 0xffff
; GFX8-NEXT:    v_mov_b32_e32 v2, s2
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: zextload_i16_to_i32_align4:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_and_b32 s2, s2, 0xffff
; GFX9-NEXT:    v_mov_b32_e32 v0, s2
; GFX9-NEXT:    global_store_dword v1, v0, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: zextload_i16_to_i32_align4:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v1, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_load_dword s2, s[2:3], 0x0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    s_and_b32 s2, s2, 0xffff
; GFX10-NEXT:    v_mov_b32_e32 v0, s2
; GFX10-NEXT:    global_store_dword v1, v0, s[0:1]
; GFX10-NEXT:    s_endpgm
  %load = load i16, i16 addrspace(1)* %in, align 4
  %zext = zext i16 %load to i32
  store i32 %zext, i32 addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @constant_load_i8_align2(i8 addrspace(1)* %out, i8 addrspace(1)* %in) #0 {
; GFX8-LABEL: constant_load_i8_align2:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    flat_load_ubyte v2, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    flat_store_byte v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: constant_load_i8_align2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_ubyte v1, v0, s[2:3]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    global_store_byte v0, v1, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: constant_load_i8_align2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_load_ubyte v1, v0, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    global_store_byte v0, v1, s[0:1]
; GFX10-NEXT:    s_endpgm
  %load = load i8, i8 addrspace(1)* %in, align 2
  store i8 %load, i8 addrspace(1)* %out, align 2
  ret void
}

define amdgpu_kernel void @constant_load_i16_align2(i16 addrspace(1)* %out, i16 addrspace(1)* %in) #0 {
; GFX8-LABEL: constant_load_i16_align2:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    flat_load_ushort v2, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    flat_store_short v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: constant_load_i16_align2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_ushort v1, v0, s[2:3]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    global_store_short v0, v1, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: constant_load_i16_align2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_load_ushort v1, v0, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    global_store_short v0, v1, s[0:1]
; GFX10-NEXT:    s_endpgm
  %load = load i16, i16 addrspace(1)* %in, align 2
  store i16 %load, i16 addrspace(1)* %out, align 2
  ret void
}

define amdgpu_kernel void @constant_sextload_i8_align2(i32 addrspace(1)* %out, i8 addrspace(1)* %in) #0 {
; GFX8-LABEL: constant_sextload_i8_align2:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    flat_load_sbyte v2, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    s_add_u32 s2, s0, 2
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_addc_u32 s3, s1, 0
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    flat_store_short v[0:1], v2
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_lshrrev_b32_e32 v3, 16, v2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    flat_store_short v[0:1], v3
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: constant_sextload_i8_align2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_sbyte v1, v0, s[2:3]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v2, 16, v1
; GFX9-NEXT:    global_store_short v0, v1, s[0:1]
; GFX9-NEXT:    global_store_short v0, v2, s[0:1] offset:2
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: constant_sextload_i8_align2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_load_sbyte v1, v0, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_lshrrev_b32_e32 v2, 16, v1
; GFX10-NEXT:    global_store_short v0, v1, s[0:1]
; GFX10-NEXT:    global_store_short v0, v2, s[0:1] offset:2
; GFX10-NEXT:    s_endpgm
  %load = load i8, i8 addrspace(1)* %in, align 2
  %sextload = sext i8 %load to i32
  store i32 %sextload, i32 addrspace(1)* %out, align 2
  ret void
}

define amdgpu_kernel void @constant_zextload_i8_align2(i32 addrspace(1)* %out, i8 addrspace(1)* %in) #0 {
; GFX8-LABEL: constant_zextload_i8_align2:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    flat_load_ubyte v2, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    s_add_u32 s2, s0, 2
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_addc_u32 s3, s1, 0
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    flat_store_short v[0:1], v2
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_lshrrev_b32_e32 v3, 16, v2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    flat_store_short v[0:1], v3
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: constant_zextload_i8_align2:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_ubyte v1, v0, s[2:3]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_lshrrev_b32_e32 v2, 16, v1
; GFX9-NEXT:    global_store_short v0, v1, s[0:1]
; GFX9-NEXT:    global_store_short v0, v2, s[0:1] offset:2
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: constant_zextload_i8_align2:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_load_ubyte v1, v0, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_lshrrev_b32_e32 v2, 16, v1
; GFX10-NEXT:    global_store_short v0, v1, s[0:1]
; GFX10-NEXT:    global_store_short v0, v2, s[0:1] offset:2
; GFX10-NEXT:    s_endpgm
  %load = load i8, i8 addrspace(1)* %in, align 2
  %zextload = zext i8 %load to i32
  store i32 %zextload, i32 addrspace(1)* %out, align 2
  ret void
}

attributes #0 = { nounwind }
