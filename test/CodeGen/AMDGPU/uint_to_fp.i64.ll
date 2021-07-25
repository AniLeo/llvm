; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX6 %s
; RUN: llc -march=amdgcn -mcpu=tonga -verify-machineinstrs < %s | FileCheck --check-prefixes=GFX8 %s

; FIXME: This should be merged with uint_to_fp.ll, but s_uint_to_fp_v2i64 crashes on r600

define amdgpu_kernel void @s_uint_to_fp_i64_to_f16(half addrspace(1)* %out, i64 %in) #0 {
; GFX6-LABEL: s_uint_to_fp_i64_to_f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_flbit_i32_b32 s8, s3
; GFX6-NEXT:    s_mov_b32 s6, -1
; GFX6-NEXT:    s_mov_b32 s4, s0
; GFX6-NEXT:    s_mov_b32 s5, s1
; GFX6-NEXT:    v_mov_b32_e32 v0, s8
; GFX6-NEXT:    v_cmp_ne_u32_e64 vcc, s3, 0
; GFX6-NEXT:    v_cndmask_b32_e32 v2, 32, v0, vcc
; GFX6-NEXT:    v_lshl_b64 v[0:1], s[2:3], v2
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX6-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, 32, v2
; GFX6-NEXT:    v_ldexp_f32_e32 v0, v0, v1
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    buffer_store_short v0, off, s[4:7], 0
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: s_uint_to_fp_i64_to_f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_flbit_i32_b32 s4, s3
; GFX8-NEXT:    s_cmp_lg_u32 s3, 0
; GFX8-NEXT:    s_cselect_b32 s6, s4, 32
; GFX8-NEXT:    s_lshl_b64 s[2:3], s[2:3], s6
; GFX8-NEXT:    v_cmp_ne_u32_e64 s[4:5], s2, 0
; GFX8-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; GFX8-NEXT:    v_or_b32_e32 v0, s3, v0
; GFX8-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX8-NEXT:    s_sub_i32 s2, 32, s6
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    v_ldexp_f32 v0, v0, s2
; GFX8-NEXT:    v_cvt_f16_f32_e32 v2, v0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    flat_store_short v[0:1], v2
; GFX8-NEXT:    s_endpgm
  %result = uitofp i64 %in to half
  store half %result, half addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @v_uint_to_fp_i64_to_f16(half addrspace(1)* %out, i64 addrspace(1)* %in) #0 {
; GFX6-LABEL: v_uint_to_fp_i64_to_f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 3, v0
; GFX6-NEXT:    v_mov_b32_e32 v2, 0
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_mov_b64 s[4:5], s[2:3]
; GFX6-NEXT:    buffer_load_dwordx2 v[3:4], v[1:2], s[4:7], 0 addr64
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 1, v0
; GFX6-NEXT:    s_mov_b64 s[2:3], s[6:7]
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    v_ffbh_u32_e32 v0, v4
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v4
; GFX6-NEXT:    v_cndmask_b32_e32 v0, 32, v0, vcc
; GFX6-NEXT:    v_lshl_b64 v[3:4], v[3:4], v0
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v3
; GFX6-NEXT:    v_cndmask_b32_e64 v3, 0, 1, vcc
; GFX6-NEXT:    v_or_b32_e32 v3, v4, v3
; GFX6-NEXT:    v_cvt_f32_u32_e32 v3, v3
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, 32, v0
; GFX6-NEXT:    v_ldexp_f32_e32 v0, v3, v0
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    buffer_store_short v0, v[1:2], s[0:3], 0 addr64
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: v_uint_to_fp_i64_to_f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    v_lshlrev_b32_e32 v1, 3, v0
; GFX8-NEXT:    v_mov_b32_e32 v3, 0
; GFX8-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v2, s3
; GFX8-NEXT:    v_add_u32_e32 v1, vcc, s2, v1
; GFX8-NEXT:    v_addc_u32_e32 v2, vcc, v2, v3, vcc
; GFX8-NEXT:    flat_load_dwordx2 v[1:2], v[1:2]
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_ffbh_u32_e32 v4, v2
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v2
; GFX8-NEXT:    v_cndmask_b32_e32 v4, 32, v4, vcc
; GFX8-NEXT:    v_lshlrev_b64 v[1:2], v4, v[1:2]
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v1
; GFX8-NEXT:    v_cndmask_b32_e64 v1, 0, 1, vcc
; GFX8-NEXT:    v_or_b32_e32 v1, v2, v1
; GFX8-NEXT:    v_cvt_f32_u32_e32 v1, v1
; GFX8-NEXT:    v_sub_u32_e32 v4, vcc, 32, v4
; GFX8-NEXT:    v_mov_b32_e32 v2, s1
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; GFX8-NEXT:    v_ldexp_f32 v1, v1, v4
; GFX8-NEXT:    v_cvt_f16_f32_e32 v4, v1
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, v2, v3, vcc
; GFX8-NEXT:    flat_store_short v[0:1], v4
; GFX8-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %in.gep = getelementptr i64, i64 addrspace(1)* %in, i32 %tid
  %out.gep = getelementptr half, half addrspace(1)* %out, i32 %tid
  %val = load i64, i64 addrspace(1)* %in.gep
  %result = uitofp i64 %val to half
  store half %result, half addrspace(1)* %out.gep
  ret void
}

define amdgpu_kernel void @s_uint_to_fp_i64_to_f32(float addrspace(1)* %out, i64 %in) #0 {
; GFX6-LABEL: s_uint_to_fp_i64_to_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_flbit_i32_b32 s8, s3
; GFX6-NEXT:    s_mov_b32 s6, -1
; GFX6-NEXT:    s_mov_b32 s4, s0
; GFX6-NEXT:    s_mov_b32 s5, s1
; GFX6-NEXT:    v_mov_b32_e32 v0, s8
; GFX6-NEXT:    v_cmp_ne_u32_e64 vcc, s3, 0
; GFX6-NEXT:    v_cndmask_b32_e32 v2, 32, v0, vcc
; GFX6-NEXT:    v_lshl_b64 v[0:1], s[2:3], v2
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX6-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX6-NEXT:    v_sub_i32_e32 v1, vcc, 32, v2
; GFX6-NEXT:    v_ldexp_f32_e32 v0, v0, v1
; GFX6-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: s_uint_to_fp_i64_to_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_flbit_i32_b32 s4, s3
; GFX8-NEXT:    s_cmp_lg_u32 s3, 0
; GFX8-NEXT:    s_cselect_b32 s6, s4, 32
; GFX8-NEXT:    s_lshl_b64 s[2:3], s[2:3], s6
; GFX8-NEXT:    v_cmp_ne_u32_e64 s[4:5], s2, 0
; GFX8-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; GFX8-NEXT:    v_or_b32_e32 v0, s3, v0
; GFX8-NEXT:    v_cvt_f32_u32_e32 v2, v0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    s_sub_i32 s0, 32, s6
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    v_ldexp_f32 v2, v2, s0
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
  %result = uitofp i64 %in to float
  store float %result, float addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @v_uint_to_fp_i64_to_f32(float addrspace(1)* %out, i64 addrspace(1)* %in) #0 {
; GFX6-LABEL: v_uint_to_fp_i64_to_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 3, v0
; GFX6-NEXT:    v_mov_b32_e32 v2, 0
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_mov_b64 s[4:5], s[2:3]
; GFX6-NEXT:    buffer_load_dwordx2 v[3:4], v[1:2], s[4:7], 0 addr64
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 2, v0
; GFX6-NEXT:    s_mov_b64 s[2:3], s[6:7]
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    v_ffbh_u32_e32 v0, v4
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v4
; GFX6-NEXT:    v_cndmask_b32_e32 v0, 32, v0, vcc
; GFX6-NEXT:    v_lshl_b64 v[3:4], v[3:4], v0
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v3
; GFX6-NEXT:    v_cndmask_b32_e64 v3, 0, 1, vcc
; GFX6-NEXT:    v_or_b32_e32 v3, v4, v3
; GFX6-NEXT:    v_cvt_f32_u32_e32 v3, v3
; GFX6-NEXT:    v_sub_i32_e32 v0, vcc, 32, v0
; GFX6-NEXT:    v_ldexp_f32_e32 v0, v3, v0
; GFX6-NEXT:    buffer_store_dword v0, v[1:2], s[0:3], 0 addr64
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: v_uint_to_fp_i64_to_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    v_lshlrev_b32_e32 v1, 3, v0
; GFX8-NEXT:    v_mov_b32_e32 v3, 0
; GFX8-NEXT:    v_lshlrev_b32_e32 v4, 2, v0
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v2, s3
; GFX8-NEXT:    v_add_u32_e32 v1, vcc, s2, v1
; GFX8-NEXT:    v_addc_u32_e32 v2, vcc, v2, v3, vcc
; GFX8-NEXT:    flat_load_dwordx2 v[1:2], v[1:2]
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_ffbh_u32_e32 v0, v2
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v2
; GFX8-NEXT:    v_cndmask_b32_e32 v5, 32, v0, vcc
; GFX8-NEXT:    v_lshlrev_b64 v[0:1], v5, v[1:2]
; GFX8-NEXT:    v_mov_b32_e32 v2, s1
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX8-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX8-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX8-NEXT:    v_cvt_f32_u32_e32 v6, v0
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, s0, v4
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, v2, v3, vcc
; GFX8-NEXT:    v_sub_u32_e32 v2, vcc, 32, v5
; GFX8-NEXT:    v_ldexp_f32 v2, v6, v2
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %in.gep = getelementptr i64, i64 addrspace(1)* %in, i32 %tid
  %out.gep = getelementptr float, float addrspace(1)* %out, i32 %tid
  %val = load i64, i64 addrspace(1)* %in.gep
  %result = uitofp i64 %val to float
  store float %result, float addrspace(1)* %out.gep
  ret void
}

define amdgpu_kernel void @s_uint_to_fp_v2i64_to_v2f32(<2 x float> addrspace(1)* %out, <2 x i64> %in) #0{
; GFX6-LABEL: s_uint_to_fp_v2i64_to_v2f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0xd
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_flbit_i32_b32 s8, s7
; GFX6-NEXT:    s_flbit_i32_b32 s9, s5
; GFX6-NEXT:    v_mov_b32_e32 v0, s8
; GFX6-NEXT:    v_cmp_ne_u32_e64 vcc, s7, 0
; GFX6-NEXT:    v_cndmask_b32_e32 v2, 32, v0, vcc
; GFX6-NEXT:    v_mov_b32_e32 v0, s9
; GFX6-NEXT:    v_cmp_ne_u32_e64 vcc, s5, 0
; GFX6-NEXT:    v_cndmask_b32_e32 v4, 32, v0, vcc
; GFX6-NEXT:    v_lshl_b64 v[0:1], s[6:7], v2
; GFX6-NEXT:    v_sub_i32_e32 v5, vcc, 32, v2
; GFX6-NEXT:    v_lshl_b64 v[2:3], s[4:5], v4
; GFX6-NEXT:    v_sub_i32_e32 v4, vcc, 32, v4
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX6-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v2
; GFX6-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    v_or_b32_e32 v1, v3, v2
; GFX6-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_u32_e32 v2, v1
; GFX6-NEXT:    v_ldexp_f32_e32 v1, v0, v5
; GFX6-NEXT:    v_ldexp_f32_e32 v0, v2, v4
; GFX6-NEXT:    buffer_store_dwordx2 v[0:1], off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: s_uint_to_fp_v2i64_to_v2f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_flbit_i32_b32 s2, s7
; GFX8-NEXT:    s_cmp_lg_u32 s7, 0
; GFX8-NEXT:    s_cselect_b32 s9, s2, 32
; GFX8-NEXT:    s_lshl_b64 s[2:3], s[6:7], s9
; GFX8-NEXT:    s_sub_i32 s9, 32, s9
; GFX8-NEXT:    v_cmp_ne_u32_e64 s[6:7], s2, 0
; GFX8-NEXT:    s_flbit_i32_b32 s8, s5
; GFX8-NEXT:    s_cmp_lg_u32 s5, 0
; GFX8-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[6:7]
; GFX8-NEXT:    s_cselect_b32 s6, s8, 32
; GFX8-NEXT:    v_or_b32_e32 v0, s3, v0
; GFX8-NEXT:    s_lshl_b64 s[2:3], s[4:5], s6
; GFX8-NEXT:    v_cmp_ne_u32_e64 s[4:5], s2, 0
; GFX8-NEXT:    v_cndmask_b32_e64 v1, 0, 1, s[4:5]
; GFX8-NEXT:    v_or_b32_e32 v1, s3, v1
; GFX8-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX8-NEXT:    v_cvt_f32_u32_e32 v2, v1
; GFX8-NEXT:    s_sub_i32 s2, 32, s6
; GFX8-NEXT:    v_ldexp_f32 v1, v0, s9
; GFX8-NEXT:    v_ldexp_f32 v0, v2, s2
; GFX8-NEXT:    v_mov_b32_e32 v3, s1
; GFX8-NEXT:    v_mov_b32_e32 v2, s0
; GFX8-NEXT:    flat_store_dwordx2 v[2:3], v[0:1]
; GFX8-NEXT:    s_endpgm
  %result = uitofp <2 x i64> %in to <2 x float>
  store <2 x float> %result, <2 x float> addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @v_uint_to_fp_v4i64_to_v4f32(<4 x float> addrspace(1)* %out, <4 x i64> addrspace(1)* %in) #0 {
; GFX6-LABEL: v_uint_to_fp_v4i64_to_v4f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    v_lshlrev_b32_e32 v8, 5, v0
; GFX6-NEXT:    v_mov_b32_e32 v9, 0
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_mov_b64 s[4:5], s[2:3]
; GFX6-NEXT:    buffer_load_dwordx4 v[1:4], v[8:9], s[4:7], 0 addr64 offset:16
; GFX6-NEXT:    buffer_load_dwordx4 v[5:8], v[8:9], s[4:7], 0 addr64
; GFX6-NEXT:    v_lshlrev_b32_e32 v10, 4, v0
; GFX6-NEXT:    v_mov_b32_e32 v11, v9
; GFX6-NEXT:    s_mov_b64 s[2:3], s[6:7]
; GFX6-NEXT:    s_waitcnt vmcnt(1)
; GFX6-NEXT:    v_ffbh_u32_e32 v0, v4
; GFX6-NEXT:    v_ffbh_u32_e32 v9, v2
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    v_ffbh_u32_e32 v12, v8
; GFX6-NEXT:    v_ffbh_u32_e32 v13, v6
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v4
; GFX6-NEXT:    v_cndmask_b32_e32 v0, 32, v0, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v2
; GFX6-NEXT:    v_cndmask_b32_e32 v9, 32, v9, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v8
; GFX6-NEXT:    v_cndmask_b32_e32 v12, 32, v12, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v6
; GFX6-NEXT:    v_cndmask_b32_e32 v13, 32, v13, vcc
; GFX6-NEXT:    v_lshl_b64 v[3:4], v[3:4], v0
; GFX6-NEXT:    v_sub_i32_e32 v14, vcc, 32, v0
; GFX6-NEXT:    v_lshl_b64 v[0:1], v[1:2], v9
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, 32, v9
; GFX6-NEXT:    v_lshl_b64 v[7:8], v[7:8], v12
; GFX6-NEXT:    v_sub_i32_e32 v9, vcc, 32, v12
; GFX6-NEXT:    v_lshl_b64 v[5:6], v[5:6], v13
; GFX6-NEXT:    v_sub_i32_e32 v12, vcc, 32, v13
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v3
; GFX6-NEXT:    v_cndmask_b32_e64 v3, 0, 1, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX6-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v7
; GFX6-NEXT:    v_cndmask_b32_e64 v7, 0, 1, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v5
; GFX6-NEXT:    v_cndmask_b32_e64 v5, 0, 1, vcc
; GFX6-NEXT:    v_or_b32_e32 v3, v4, v3
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    v_or_b32_e32 v1, v8, v7
; GFX6-NEXT:    v_or_b32_e32 v4, v6, v5
; GFX6-NEXT:    v_cvt_f32_u32_e32 v3, v3
; GFX6-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_u32_e32 v1, v1
; GFX6-NEXT:    v_cvt_f32_u32_e32 v4, v4
; GFX6-NEXT:    v_ldexp_f32_e32 v3, v3, v14
; GFX6-NEXT:    v_ldexp_f32_e32 v2, v0, v2
; GFX6-NEXT:    v_ldexp_f32_e32 v1, v1, v9
; GFX6-NEXT:    v_ldexp_f32_e32 v0, v4, v12
; GFX6-NEXT:    buffer_store_dwordx4 v[0:3], v[10:11], s[0:3], 0 addr64
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: v_uint_to_fp_v4i64_to_v4f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    v_lshlrev_b32_e32 v1, 5, v0
; GFX8-NEXT:    v_mov_b32_e32 v10, 0
; GFX8-NEXT:    v_lshlrev_b32_e32 v0, 4, v0
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v2, s3
; GFX8-NEXT:    v_add_u32_e32 v5, vcc, s2, v1
; GFX8-NEXT:    v_addc_u32_e32 v6, vcc, v2, v10, vcc
; GFX8-NEXT:    v_add_u32_e32 v1, vcc, 16, v5
; GFX8-NEXT:    v_addc_u32_e32 v2, vcc, 0, v6, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[1:4], v[1:2]
; GFX8-NEXT:    flat_load_dwordx4 v[5:8], v[5:6]
; GFX8-NEXT:    v_add_u32_e32 v9, vcc, s0, v0
; GFX8-NEXT:    v_mov_b32_e32 v11, s1
; GFX8-NEXT:    v_addc_u32_e32 v10, vcc, v11, v10, vcc
; GFX8-NEXT:    s_waitcnt vmcnt(1)
; GFX8-NEXT:    v_ffbh_u32_e32 v12, v4
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_ffbh_u32_e32 v0, v8
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v8
; GFX8-NEXT:    v_cndmask_b32_e32 v0, 32, v0, vcc
; GFX8-NEXT:    v_ffbh_u32_e32 v11, v6
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v6
; GFX8-NEXT:    v_cndmask_b32_e32 v11, 32, v11, vcc
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v4
; GFX8-NEXT:    v_cndmask_b32_e32 v12, 32, v12, vcc
; GFX8-NEXT:    v_ffbh_u32_e32 v13, v2
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v2
; GFX8-NEXT:    v_cndmask_b32_e32 v13, 32, v13, vcc
; GFX8-NEXT:    v_lshlrev_b64 v[7:8], v0, v[7:8]
; GFX8-NEXT:    v_sub_u32_e32 v14, vcc, 32, v0
; GFX8-NEXT:    v_lshlrev_b64 v[5:6], v11, v[5:6]
; GFX8-NEXT:    v_lshlrev_b64 v[3:4], v12, v[3:4]
; GFX8-NEXT:    v_lshlrev_b64 v[0:1], v13, v[1:2]
; GFX8-NEXT:    v_sub_u32_e32 v11, vcc, 32, v11
; GFX8-NEXT:    v_sub_u32_e32 v12, vcc, 32, v12
; GFX8-NEXT:    v_sub_u32_e32 v2, vcc, 32, v13
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v7
; GFX8-NEXT:    v_cndmask_b32_e64 v7, 0, 1, vcc
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v5
; GFX8-NEXT:    v_cndmask_b32_e64 v5, 0, 1, vcc
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v3
; GFX8-NEXT:    v_cndmask_b32_e64 v3, 0, 1, vcc
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX8-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX8-NEXT:    v_or_b32_e32 v3, v4, v3
; GFX8-NEXT:    v_or_b32_e32 v5, v6, v5
; GFX8-NEXT:    v_or_b32_e32 v7, v8, v7
; GFX8-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX8-NEXT:    v_cvt_f32_u32_e32 v1, v7
; GFX8-NEXT:    v_cvt_f32_u32_e32 v3, v3
; GFX8-NEXT:    v_cvt_f32_u32_e32 v4, v5
; GFX8-NEXT:    v_cvt_f32_u32_e32 v5, v0
; GFX8-NEXT:    v_ldexp_f32 v1, v1, v14
; GFX8-NEXT:    v_ldexp_f32 v3, v3, v12
; GFX8-NEXT:    v_ldexp_f32 v0, v4, v11
; GFX8-NEXT:    v_ldexp_f32 v2, v5, v2
; GFX8-NEXT:    flat_store_dwordx4 v[9:10], v[0:3]
; GFX8-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %in.gep = getelementptr <4 x i64>, <4 x i64> addrspace(1)* %in, i32 %tid
  %out.gep = getelementptr <4 x float>, <4 x float> addrspace(1)* %out, i32 %tid
  %value = load <4 x i64>, <4 x i64> addrspace(1)* %in.gep
  %result = uitofp <4 x i64> %value to <4 x float>
  store <4 x float> %result, <4 x float> addrspace(1)* %out.gep
  ret void
}

define amdgpu_kernel void @s_uint_to_fp_v2i64_to_v2f16(<2 x half> addrspace(1)* %out, <2 x i64> %in) #0{
; GFX6-LABEL: s_uint_to_fp_v2i64_to_v2f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0xd
; GFX6-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s3, 0xf000
; GFX6-NEXT:    s_mov_b32 s2, -1
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_flbit_i32_b32 s8, s7
; GFX6-NEXT:    s_flbit_i32_b32 s9, s5
; GFX6-NEXT:    v_mov_b32_e32 v0, s8
; GFX6-NEXT:    v_cmp_ne_u32_e64 vcc, s7, 0
; GFX6-NEXT:    v_cndmask_b32_e32 v2, 32, v0, vcc
; GFX6-NEXT:    v_mov_b32_e32 v0, s9
; GFX6-NEXT:    v_cmp_ne_u32_e64 vcc, s5, 0
; GFX6-NEXT:    v_cndmask_b32_e32 v4, 32, v0, vcc
; GFX6-NEXT:    v_lshl_b64 v[0:1], s[6:7], v2
; GFX6-NEXT:    v_sub_i32_e32 v5, vcc, 32, v2
; GFX6-NEXT:    v_lshl_b64 v[2:3], s[4:5], v4
; GFX6-NEXT:    v_sub_i32_e32 v4, vcc, 32, v4
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX6-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v2
; GFX6-NEXT:    v_cndmask_b32_e64 v2, 0, 1, vcc
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    v_or_b32_e32 v1, v3, v2
; GFX6-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_u32_e32 v1, v1
; GFX6-NEXT:    v_ldexp_f32_e32 v0, v0, v5
; GFX6-NEXT:    v_ldexp_f32_e32 v1, v1, v4
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: s_uint_to_fp_v2i64_to_v2f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x34
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_flbit_i32_b32 s2, s7
; GFX8-NEXT:    s_cmp_lg_u32 s7, 0
; GFX8-NEXT:    s_cselect_b32 s9, s2, 32
; GFX8-NEXT:    s_lshl_b64 s[2:3], s[6:7], s9
; GFX8-NEXT:    s_sub_i32 s9, 32, s9
; GFX8-NEXT:    v_cmp_ne_u32_e64 s[6:7], s2, 0
; GFX8-NEXT:    s_flbit_i32_b32 s8, s5
; GFX8-NEXT:    s_cmp_lg_u32 s5, 0
; GFX8-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[6:7]
; GFX8-NEXT:    s_cselect_b32 s6, s8, 32
; GFX8-NEXT:    v_or_b32_e32 v0, s3, v0
; GFX8-NEXT:    s_lshl_b64 s[2:3], s[4:5], s6
; GFX8-NEXT:    v_cmp_ne_u32_e64 s[4:5], s2, 0
; GFX8-NEXT:    v_cndmask_b32_e64 v1, 0, 1, s[4:5]
; GFX8-NEXT:    v_or_b32_e32 v1, s3, v1
; GFX8-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX8-NEXT:    v_cvt_f32_u32_e32 v1, v1
; GFX8-NEXT:    s_sub_i32 s2, 32, s6
; GFX8-NEXT:    v_ldexp_f32 v0, v0, s9
; GFX8-NEXT:    v_ldexp_f32 v1, v1, s2
; GFX8-NEXT:    v_cvt_f16_f32_sdwa v0, v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD
; GFX8-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX8-NEXT:    v_or_b32_e32 v2, v1, v0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
  %result = uitofp <2 x i64> %in to <2 x half>
  store <2 x half> %result, <2 x half> addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @v_uint_to_fp_v4i64_to_v4f16(<4 x half> addrspace(1)* %out, <4 x i64> addrspace(1)* %in) #0 {
; GFX6-LABEL: v_uint_to_fp_v4i64_to_v4f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b32 s6, 0
; GFX6-NEXT:    v_lshlrev_b32_e32 v8, 5, v0
; GFX6-NEXT:    v_mov_b32_e32 v9, 0
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_mov_b64 s[4:5], s[2:3]
; GFX6-NEXT:    buffer_load_dwordx4 v[1:4], v[8:9], s[4:7], 0 addr64 offset:16
; GFX6-NEXT:    buffer_load_dwordx4 v[5:8], v[8:9], s[4:7], 0 addr64
; GFX6-NEXT:    v_lshlrev_b32_e32 v10, 3, v0
; GFX6-NEXT:    v_mov_b32_e32 v11, v9
; GFX6-NEXT:    s_mov_b64 s[2:3], s[6:7]
; GFX6-NEXT:    s_waitcnt vmcnt(1)
; GFX6-NEXT:    v_ffbh_u32_e32 v0, v4
; GFX6-NEXT:    v_ffbh_u32_e32 v9, v2
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    v_ffbh_u32_e32 v12, v8
; GFX6-NEXT:    v_ffbh_u32_e32 v13, v6
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v4
; GFX6-NEXT:    v_cndmask_b32_e32 v0, 32, v0, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v2
; GFX6-NEXT:    v_cndmask_b32_e32 v9, 32, v9, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v8
; GFX6-NEXT:    v_cndmask_b32_e32 v12, 32, v12, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v6
; GFX6-NEXT:    v_cndmask_b32_e32 v13, 32, v13, vcc
; GFX6-NEXT:    v_lshl_b64 v[3:4], v[3:4], v0
; GFX6-NEXT:    v_sub_i32_e32 v14, vcc, 32, v0
; GFX6-NEXT:    v_lshl_b64 v[0:1], v[1:2], v9
; GFX6-NEXT:    v_sub_i32_e32 v2, vcc, 32, v9
; GFX6-NEXT:    v_lshl_b64 v[7:8], v[7:8], v12
; GFX6-NEXT:    v_sub_i32_e32 v9, vcc, 32, v12
; GFX6-NEXT:    v_lshl_b64 v[5:6], v[5:6], v13
; GFX6-NEXT:    v_sub_i32_e32 v12, vcc, 32, v13
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v3
; GFX6-NEXT:    v_cndmask_b32_e64 v3, 0, 1, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX6-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v7
; GFX6-NEXT:    v_cndmask_b32_e64 v7, 0, 1, vcc
; GFX6-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v5
; GFX6-NEXT:    v_cndmask_b32_e64 v5, 0, 1, vcc
; GFX6-NEXT:    v_or_b32_e32 v3, v4, v3
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    v_or_b32_e32 v1, v8, v7
; GFX6-NEXT:    v_or_b32_e32 v4, v6, v5
; GFX6-NEXT:    v_cvt_f32_u32_e32 v3, v3
; GFX6-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_u32_e32 v1, v1
; GFX6-NEXT:    v_cvt_f32_u32_e32 v4, v4
; GFX6-NEXT:    v_ldexp_f32_e32 v3, v3, v14
; GFX6-NEXT:    v_ldexp_f32_e32 v0, v0, v2
; GFX6-NEXT:    v_ldexp_f32_e32 v1, v1, v9
; GFX6-NEXT:    v_ldexp_f32_e32 v2, v4, v12
; GFX6-NEXT:    v_cvt_f16_f32_e32 v3, v3
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    v_cvt_f16_f32_e32 v2, v2
; GFX6-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX6-NEXT:    v_lshlrev_b32_e32 v4, 16, v1
; GFX6-NEXT:    v_or_b32_e32 v1, v0, v3
; GFX6-NEXT:    v_or_b32_e32 v0, v2, v4
; GFX6-NEXT:    buffer_store_dwordx2 v[0:1], v[10:11], s[0:3], 0 addr64
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: v_uint_to_fp_v4i64_to_v4f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    v_lshlrev_b32_e32 v1, 5, v0
; GFX8-NEXT:    v_mov_b32_e32 v9, 0
; GFX8-NEXT:    v_lshlrev_b32_e32 v10, 3, v0
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v2, s3
; GFX8-NEXT:    v_add_u32_e32 v5, vcc, s2, v1
; GFX8-NEXT:    v_addc_u32_e32 v6, vcc, v2, v9, vcc
; GFX8-NEXT:    v_add_u32_e32 v1, vcc, 16, v5
; GFX8-NEXT:    v_addc_u32_e32 v2, vcc, 0, v6, vcc
; GFX8-NEXT:    flat_load_dwordx4 v[1:4], v[1:2]
; GFX8-NEXT:    flat_load_dwordx4 v[5:8], v[5:6]
; GFX8-NEXT:    v_mov_b32_e32 v11, s1
; GFX8-NEXT:    s_waitcnt vmcnt(1)
; GFX8-NEXT:    v_ffbh_u32_e32 v13, v4
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_ffbh_u32_e32 v0, v8
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v8
; GFX8-NEXT:    v_cndmask_b32_e32 v0, 32, v0, vcc
; GFX8-NEXT:    v_ffbh_u32_e32 v12, v6
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v6
; GFX8-NEXT:    v_cndmask_b32_e32 v12, 32, v12, vcc
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v4
; GFX8-NEXT:    v_cndmask_b32_e32 v13, 32, v13, vcc
; GFX8-NEXT:    v_ffbh_u32_e32 v14, v2
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v2
; GFX8-NEXT:    v_cndmask_b32_e32 v14, 32, v14, vcc
; GFX8-NEXT:    v_lshlrev_b64 v[7:8], v0, v[7:8]
; GFX8-NEXT:    v_sub_u32_e32 v15, vcc, 32, v0
; GFX8-NEXT:    v_lshlrev_b64 v[5:6], v12, v[5:6]
; GFX8-NEXT:    v_lshlrev_b64 v[3:4], v13, v[3:4]
; GFX8-NEXT:    v_lshlrev_b64 v[0:1], v14, v[1:2]
; GFX8-NEXT:    v_sub_u32_e32 v12, vcc, 32, v12
; GFX8-NEXT:    v_sub_u32_e32 v13, vcc, 32, v13
; GFX8-NEXT:    v_sub_u32_e32 v2, vcc, 32, v14
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v7
; GFX8-NEXT:    v_cndmask_b32_e64 v7, 0, 1, vcc
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v5
; GFX8-NEXT:    v_cndmask_b32_e64 v5, 0, 1, vcc
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v3
; GFX8-NEXT:    v_cndmask_b32_e64 v3, 0, 1, vcc
; GFX8-NEXT:    v_cmp_ne_u32_e32 vcc, 0, v0
; GFX8-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX8-NEXT:    v_or_b32_e32 v3, v4, v3
; GFX8-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX8-NEXT:    v_or_b32_e32 v7, v8, v7
; GFX8-NEXT:    v_or_b32_e32 v5, v6, v5
; GFX8-NEXT:    v_cvt_f32_u32_e32 v1, v7
; GFX8-NEXT:    v_cvt_f32_u32_e32 v4, v5
; GFX8-NEXT:    v_cvt_f32_u32_e32 v3, v3
; GFX8-NEXT:    v_cvt_f32_u32_e32 v0, v0
; GFX8-NEXT:    v_ldexp_f32 v1, v1, v15
; GFX8-NEXT:    v_ldexp_f32 v4, v4, v12
; GFX8-NEXT:    v_ldexp_f32 v3, v3, v13
; GFX8-NEXT:    v_ldexp_f32 v0, v0, v2
; GFX8-NEXT:    v_cvt_f16_f32_e32 v5, v0
; GFX8-NEXT:    v_cvt_f16_f32_sdwa v3, v3 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD
; GFX8-NEXT:    v_cvt_f16_f32_sdwa v2, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD
; GFX8-NEXT:    v_cvt_f16_f32_e32 v4, v4
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, s0, v10
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, v11, v9, vcc
; GFX8-NEXT:    v_or_b32_e32 v3, v5, v3
; GFX8-NEXT:    v_or_b32_e32 v2, v4, v2
; GFX8-NEXT:    flat_store_dwordx2 v[0:1], v[2:3]
; GFX8-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %in.gep = getelementptr <4 x i64>, <4 x i64> addrspace(1)* %in, i32 %tid
  %out.gep = getelementptr <4 x half>, <4 x half> addrspace(1)* %out, i32 %tid
  %value = load <4 x i64>, <4 x i64> addrspace(1)* %in.gep
  %result = uitofp <4 x i64> %value to <4 x half>
  store <4 x half> %result, <4 x half> addrspace(1)* %out.gep
  ret void
}

declare i32 @llvm.amdgcn.workitem.id.x() #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
