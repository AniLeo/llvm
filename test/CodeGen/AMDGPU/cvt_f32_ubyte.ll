; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-- -mcpu=tahiti -verify-machineinstrs < %s | FileCheck %s -allow-deprecated-dag-overlap -check-prefixes=GCN,SI
; RUN: llc -mtriple=amdgcn-- -mcpu=tonga -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck %s -allow-deprecated-dag-overlap -check-prefixes=GCN,VI

declare i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
declare i32 @llvm.amdgcn.workitem.id.y() nounwind readnone

define amdgpu_kernel void @load_i8_to_f32(float addrspace(1)* noalias %out, i8 addrspace(1)* noalias %in) nounwind {
; SI-LABEL: load_i8_to_f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_ubyte v0, v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: load_i8_to_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_ubyte v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i8, i8 addrspace(1)* %in, i32 %tid
  %load = load i8, i8 addrspace(1)* %gep, align 1
  %cvt = uitofp i8 %load to float
  store float %cvt, float addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @load_v2i8_to_v2f32(<2 x float> addrspace(1)* noalias %out, <2 x i8> addrspace(1)* noalias %in) nounwind {
; SI-LABEL: load_v2i8_to_v2f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_ushort v0, v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v0
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: load_v2i8_to_v2f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_ushort v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v0
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr <2 x i8>, <2 x i8> addrspace(1)* %in, i32 %tid
  %load = load <2 x i8>, <2 x i8> addrspace(1)* %gep, align 2
  %cvt = uitofp <2 x i8> %load to <2 x float>
  store <2 x float> %cvt, <2 x float> addrspace(1)* %out, align 16
  ret void
}

define amdgpu_kernel void @load_v3i8_to_v3f32(<3 x float> addrspace(1)* noalias %out, <3 x i8> addrspace(1)* noalias %in) nounwind {
; SI-LABEL: load_v3i8_to_v3f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_dword v2, v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v2
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v2
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v2
; SI-NEXT:    buffer_store_dword v2, off, s[4:7], 0 offset:8
; SI-NEXT:    buffer_store_dwordx2 v[0:1], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: load_v3i8_to_v3f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v0
; VI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v0
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    buffer_store_dwordx3 v[0:2], off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr <3 x i8>, <3 x i8> addrspace(1)* %in, i32 %tid
  %load = load <3 x i8>, <3 x i8> addrspace(1)* %gep, align 4
  %cvt = uitofp <3 x i8> %load to <3 x float>
  store <3 x float> %cvt, <3 x float> addrspace(1)* %out, align 16
  ret void
}

define amdgpu_kernel void @load_v4i8_to_v4f32(<4 x float> addrspace(1)* noalias %out, <4 x i8> addrspace(1)* noalias %in) nounwind {
; SI-LABEL: load_v4i8_to_v4f32:
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
; SI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v0
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v0
; SI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v0
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: load_v4i8_to_v4f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v0
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v0
; VI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v0
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr <4 x i8>, <4 x i8> addrspace(1)* %in, i32 %tid
  %load = load <4 x i8>, <4 x i8> addrspace(1)* %gep, align 4
  %cvt = uitofp <4 x i8> %load to <4 x float>
  store <4 x float> %cvt, <4 x float> addrspace(1)* %out, align 16
  ret void
}

; This should not be adding instructions to shift into the correct
; position in the word for the component.

; FIXME: Packing bytes
define amdgpu_kernel void @load_v4i8_to_v4f32_unaligned(<4 x float> addrspace(1)* noalias %out, <4 x i8> addrspace(1)* noalias %in) nounwind {
; SI-LABEL: load_v4i8_to_v4f32_unaligned:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_ubyte v4, v[0:1], s[0:3], 0 addr64
; SI-NEXT:    buffer_load_ubyte v2, v[0:1], s[0:3], 0 addr64 offset:1
; SI-NEXT:    buffer_load_ubyte v3, v[0:1], s[0:3], 0 addr64 offset:2
; SI-NEXT:    buffer_load_ubyte v0, v[0:1], s[0:3], 0 addr64 offset:3
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(2)
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v1, v2
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshlrev_b32_e32 v0, 8, v0
; SI-NEXT:    v_or_b32_e32 v0, v0, v3
; SI-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; SI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v0
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v0
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v4
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: load_v4i8_to_v4f32_unaligned:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v2, vcc, 1, v0
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v4, vcc, 2, v0
; VI-NEXT:    v_addc_u32_e32 v5, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v6, vcc, 3, v0
; VI-NEXT:    v_addc_u32_e32 v7, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_ubyte v8, v[2:3]
; VI-NEXT:    flat_load_ubyte v2, v[4:5]
; VI-NEXT:    flat_load_ubyte v3, v[6:7]
; VI-NEXT:    flat_load_ubyte v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(3) lgkmcnt(3)
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v1, v8
; VI-NEXT:    s_waitcnt vmcnt(2) lgkmcnt(2)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v2, v2
; VI-NEXT:    s_waitcnt vmcnt(1) lgkmcnt(1)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v3, v3
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr <4 x i8>, <4 x i8> addrspace(1)* %in, i32 %tid
  %load = load <4 x i8>, <4 x i8> addrspace(1)* %gep, align 1
  %cvt = uitofp <4 x i8> %load to <4 x float>
  store <4 x float> %cvt, <4 x float> addrspace(1)* %out, align 16
  ret void
}

; FIXME: Need to handle non-uniform case for function below (load without gep).
; Instructions still emitted to repack bytes for add use.
define amdgpu_kernel void @load_v4i8_to_v4f32_2_uses(<4 x float> addrspace(1)* noalias %out, <4 x i8> addrspace(1)* noalias %out2, <4 x i8> addrspace(1)* noalias %in) nounwind {
; SI-LABEL: load_v4i8_to_v4f32_2_uses:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0xb
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xd
; SI-NEXT:    s_mov_b32 s11, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s11
; SI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_dword v4, v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s10, -1
; SI-NEXT:    s_mov_b32 s6, s10
; SI-NEXT:    s_mov_b32 s7, s11
; SI-NEXT:    s_movk_i32 s12, 0xff
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshrrev_b32_e32 v5, 16, v4
; SI-NEXT:    v_lshrrev_b32_e32 v6, 24, v4
; SI-NEXT:    v_and_b32_e32 v7, 0xff00, v4
; SI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v4
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v4
; SI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v4
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v4
; SI-NEXT:    v_add_i32_e32 v4, vcc, 9, v4
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_waitcnt expcnt(0)
; SI-NEXT:    v_and_b32_e32 v0, s12, v4
; SI-NEXT:    v_add_i32_e32 v2, vcc, 9, v5
; SI-NEXT:    v_or_b32_e32 v0, v7, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 8, v6
; SI-NEXT:    v_and_b32_e32 v2, s12, v2
; SI-NEXT:    v_add_i32_e32 v0, vcc, 0x900, v0
; SI-NEXT:    v_or_b32_e32 v1, v1, v2
; SI-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; SI-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; SI-NEXT:    v_or_b32_e32 v0, v1, v0
; SI-NEXT:    v_add_i32_e32 v0, vcc, 0x9000000, v0
; SI-NEXT:    buffer_store_dword v0, off, s[8:11], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: load_v4i8_to_v4f32_2_uses:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[8:9], s[0:1], 0x2c
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s11, 0xf000
; VI-NEXT:    s_mov_b32 s10, -1
; VI-NEXT:    s_mov_b32 s6, s10
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v5, v[0:1]
; VI-NEXT:    v_mov_b32_e32 v4, 9
; VI-NEXT:    s_mov_b32 s7, s11
; VI-NEXT:    s_movk_i32 s0, 0x900
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_lshrrev_b32_e32 v6, 24, v5
; VI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v5
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v5
; VI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v5
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v5
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; VI-NEXT:    v_and_b32_e32 v7, 0xffffff00, v5
; VI-NEXT:    v_add_u16_e32 v8, 9, v5
; VI-NEXT:    v_add_u16_sdwa v4, v5, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; VI-NEXT:    v_lshlrev_b16_e32 v1, 8, v6
; VI-NEXT:    v_or_b32_sdwa v0, v7, v8 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; VI-NEXT:    v_or_b32_sdwa v1, v1, v4 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:BYTE_0
; VI-NEXT:    v_mov_b32_e32 v2, s0
; VI-NEXT:    v_add_u16_e32 v0, s0, v0
; VI-NEXT:    v_add_u16_sdwa v1, v1, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_or_b32_e32 v0, v0, v1
; VI-NEXT:    buffer_store_dword v0, off, s[8:11], 0
; VI-NEXT:    s_endpgm
  %tid.x = call i32 @llvm.amdgcn.workitem.id.x()
  %in.ptr = getelementptr <4 x i8>, <4 x i8> addrspace(1)* %in, i32 %tid.x
  %load = load <4 x i8>, <4 x i8> addrspace(1)* %in.ptr, align 4
  %cvt = uitofp <4 x i8> %load to <4 x float>
  store <4 x float> %cvt, <4 x float> addrspace(1)* %out, align 16
  %add = add <4 x i8> %load, <i8 9, i8 9, i8 9, i8 9> ; Second use of %load
  store <4 x i8> %add, <4 x i8> addrspace(1)* %out2, align 4
  ret void
}

; Make sure this doesn't crash.
define amdgpu_kernel void @load_v7i8_to_v7f32(<7 x float> addrspace(1)* noalias %out, <7 x i8> addrspace(1)* noalias %in) nounwind {
; SI-LABEL: load_v7i8_to_v7f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_ubyte v2, v[0:1], s[0:3], 0 addr64 offset:5
; SI-NEXT:    buffer_load_ubyte v3, v[0:1], s[0:3], 0 addr64 offset:6
; SI-NEXT:    buffer_load_ubyte v4, v[0:1], s[0:3], 0 addr64
; SI-NEXT:    buffer_load_ubyte v5, v[0:1], s[0:3], 0 addr64 offset:1
; SI-NEXT:    buffer_load_ubyte v6, v[0:1], s[0:3], 0 addr64 offset:2
; SI-NEXT:    buffer_load_ubyte v7, v[0:1], s[0:3], 0 addr64 offset:3
; SI-NEXT:    buffer_load_ubyte v8, v[0:1], s[0:3], 0 addr64 offset:4
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(4)
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v4
; SI-NEXT:    s_waitcnt vmcnt(3)
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v1, v5
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v5, v2
; SI-NEXT:    s_waitcnt vmcnt(1)
; SI-NEXT:    v_lshlrev_b32_e32 v7, 8, v7
; SI-NEXT:    v_or_b32_e32 v2, v7, v6
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v4, v8
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v8, v3
; SI-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; SI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v2
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v2
; SI-NEXT:    buffer_store_dword v8, off, s[4:7], 0 offset:24
; SI-NEXT:    buffer_store_dwordx2 v[4:5], off, s[4:7], 0 offset:16
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: load_v7i8_to_v7f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v2, vcc, 3, v0
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v4, vcc, 2, v0
; VI-NEXT:    v_addc_u32_e32 v5, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v6, vcc, 6, v0
; VI-NEXT:    v_addc_u32_e32 v7, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v8, vcc, 4, v0
; VI-NEXT:    v_addc_u32_e32 v9, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v10, vcc, 5, v0
; VI-NEXT:    v_addc_u32_e32 v11, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v12, vcc, 1, v0
; VI-NEXT:    v_addc_u32_e32 v13, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_ubyte v6, v[6:7]
; VI-NEXT:    flat_load_ubyte v7, v[8:9]
; VI-NEXT:    flat_load_ubyte v8, v[10:11]
; VI-NEXT:    flat_load_ubyte v9, v[12:13]
; VI-NEXT:    flat_load_ubyte v0, v[0:1]
; VI-NEXT:    flat_load_ubyte v1, v[2:3]
; VI-NEXT:    flat_load_ubyte v2, v[4:5]
; VI-NEXT:    s_waitcnt vmcnt(6) lgkmcnt(6)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v6, v6
; VI-NEXT:    s_waitcnt vmcnt(5) lgkmcnt(5)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v4, v7
; VI-NEXT:    s_waitcnt vmcnt(4) lgkmcnt(4)
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v5, v8
; VI-NEXT:    s_waitcnt vmcnt(2) lgkmcnt(2)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    s_waitcnt vmcnt(1) lgkmcnt(1)
; VI-NEXT:    v_lshlrev_b32_e32 v3, 8, v1
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_or_b32_sdwa v2, v3, v2 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v2
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v1, v9
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v2
; VI-NEXT:    buffer_store_dwordx3 v[4:6], off, s[4:7], 0 offset:16
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr <7 x i8>, <7 x i8> addrspace(1)* %in, i32 %tid
  %load = load <7 x i8>, <7 x i8> addrspace(1)* %gep, align 1
  %cvt = uitofp <7 x i8> %load to <7 x float>
  store <7 x float> %cvt, <7 x float> addrspace(1)* %out, align 16
  ret void
}

define amdgpu_kernel void @load_v8i8_to_v8f32(<8 x float> addrspace(1)* noalias %out, <8 x i8> addrspace(1)* noalias %in) nounwind {
; SI-LABEL: load_v8i8_to_v8f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_dwordx2 v[7:8], v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v7
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v7
; SI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v7
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v7
; SI-NEXT:    v_cvt_f32_ubyte3_e32 v7, v8
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v6, v8
; SI-NEXT:    v_cvt_f32_ubyte1_e32 v5, v8
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v4, v8
; SI-NEXT:    buffer_store_dwordx4 v[4:7], off, s[4:7], 0 offset:16
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: load_v8i8_to_v8f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 3, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dwordx2 v[7:8], v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v7
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v7
; VI-NEXT:    v_cvt_f32_ubyte1_e32 v1, v7
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v7
; VI-NEXT:    v_cvt_f32_ubyte3_e32 v7, v8
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v6, v8
; VI-NEXT:    v_cvt_f32_ubyte1_e32 v5, v8
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v4, v8
; VI-NEXT:    buffer_store_dwordx4 v[4:7], off, s[4:7], 0 offset:16
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr <8 x i8>, <8 x i8> addrspace(1)* %in, i32 %tid
  %load = load <8 x i8>, <8 x i8> addrspace(1)* %gep, align 8
  %cvt = uitofp <8 x i8> %load to <8 x float>
  store <8 x float> %cvt, <8 x float> addrspace(1)* %out, align 16
  ret void
}

define amdgpu_kernel void @i8_zext_inreg_i32_to_f32(float addrspace(1)* noalias %out, i32 addrspace(1)* noalias %in) nounwind {
; SI-LABEL: i8_zext_inreg_i32_to_f32:
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
; SI-NEXT:    v_add_i32_e32 v0, vcc, 2, v0
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: i8_zext_inreg_i32_to_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_add_u32_e32 v0, vcc, 2, v0
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i32, i32 addrspace(1)* %in, i32 %tid
  %load = load i32, i32 addrspace(1)* %gep, align 4
  %add = add i32 %load, 2
  %inreg = and i32 %add, 255
  %cvt = uitofp i32 %inreg to float
  store float %cvt, float addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @i8_zext_inreg_hi1_to_f32(float addrspace(1)* noalias %out, i32 addrspace(1)* noalias %in) nounwind {
; SI-LABEL: i8_zext_inreg_hi1_to_f32:
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
; SI-NEXT:    v_cvt_f32_ubyte1_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: i8_zext_inreg_hi1_to_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte1_e32 v0, v0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i32, i32 addrspace(1)* %in, i32 %tid
  %load = load i32, i32 addrspace(1)* %gep, align 4
  %inreg = and i32 %load, 65280
  %shr = lshr i32 %inreg, 8
  %cvt = uitofp i32 %shr to float
  store float %cvt, float addrspace(1)* %out, align 4
  ret void
}

; We don't get these ones because of the zext, but instcombine removes
; them so it shouldn't really matter.
define amdgpu_kernel void @i8_zext_i32_to_f32(float addrspace(1)* noalias %out, i8 addrspace(1)* noalias %in) nounwind {
; SI-LABEL: i8_zext_i32_to_f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_ubyte v0, v[0:1], s[0:3], 0 addr64
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: i8_zext_i32_to_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_ubyte v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i8, i8 addrspace(1)* %in, i32 %tid
  %load = load i8, i8 addrspace(1)* %gep, align 1
  %ext = zext i8 %load to i32
  %cvt = uitofp i32 %ext to float
  store float %cvt, float addrspace(1)* %out, align 4
  ret void
}

define amdgpu_kernel void @v4i8_zext_v4i32_to_v4f32(<4 x float> addrspace(1)* noalias %out, <4 x i8> addrspace(1)* noalias %in) nounwind {
; SI-LABEL: v4i8_zext_v4i32_to_v4f32:
; SI:       ; %bb.0:
; SI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x9
; SI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xb
; SI-NEXT:    s_mov_b32 s7, 0xf000
; SI-NEXT:    s_mov_b32 s2, 0
; SI-NEXT:    s_mov_b32 s3, s7
; SI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    buffer_load_ubyte v4, v[0:1], s[0:3], 0 addr64
; SI-NEXT:    buffer_load_ubyte v2, v[0:1], s[0:3], 0 addr64 offset:1
; SI-NEXT:    buffer_load_ubyte v3, v[0:1], s[0:3], 0 addr64 offset:2
; SI-NEXT:    buffer_load_ubyte v0, v[0:1], s[0:3], 0 addr64 offset:3
; SI-NEXT:    s_mov_b32 s6, -1
; SI-NEXT:    s_waitcnt vmcnt(2)
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v1, v2
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_lshlrev_b32_e32 v0, 8, v0
; SI-NEXT:    v_or_b32_e32 v0, v0, v3
; SI-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; SI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v0
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v0
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v4
; SI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: v4i8_zext_v4i32_to_v4f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v2, vcc, 3, v0
; VI-NEXT:    v_addc_u32_e32 v3, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v4, vcc, 2, v0
; VI-NEXT:    v_addc_u32_e32 v5, vcc, 0, v1, vcc
; VI-NEXT:    v_add_u32_e32 v6, vcc, 1, v0
; VI-NEXT:    v_addc_u32_e32 v7, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_ubyte v2, v[2:3]
; VI-NEXT:    flat_load_ubyte v3, v[4:5]
; VI-NEXT:    flat_load_ubyte v4, v[6:7]
; VI-NEXT:    flat_load_ubyte v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(3) lgkmcnt(3)
; VI-NEXT:    v_lshlrev_b32_e32 v1, 8, v2
; VI-NEXT:    s_waitcnt vmcnt(2) lgkmcnt(2)
; VI-NEXT:    v_or_b32_sdwa v1, v1, v3 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; VI-NEXT:    v_cvt_f32_ubyte3_e32 v3, v1
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v2, v1
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v1, v4
; VI-NEXT:    buffer_store_dwordx4 v[0:3], off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr <4 x i8>, <4 x i8> addrspace(1)* %in, i32 %tid
  %load = load <4 x i8>, <4 x i8> addrspace(1)* %gep, align 1
  %ext = zext <4 x i8> %load to <4 x i32>
  %cvt = uitofp <4 x i32> %ext to <4 x float>
  store <4 x float> %cvt, <4 x float> addrspace(1)* %out, align 16
  ret void
}

define amdgpu_kernel void @extract_byte0_to_f32(float addrspace(1)* noalias %out, i32 addrspace(1)* noalias %in) nounwind {
; SI-LABEL: extract_byte0_to_f32:
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
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: extract_byte0_to_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v0, v0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i32, i32 addrspace(1)* %in, i32 %tid
  %val = load i32, i32 addrspace(1)* %gep
  %and = and i32 %val, 255
  %cvt = uitofp i32 %and to float
  store float %cvt, float addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @extract_byte1_to_f32(float addrspace(1)* noalias %out, i32 addrspace(1)* noalias %in) nounwind {
; SI-LABEL: extract_byte1_to_f32:
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
; SI-NEXT:    v_cvt_f32_ubyte1_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: extract_byte1_to_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte1_e32 v0, v0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i32, i32 addrspace(1)* %in, i32 %tid
  %val = load i32, i32 addrspace(1)* %gep
  %srl = lshr i32 %val, 8
  %and = and i32 %srl, 255
  %cvt = uitofp i32 %and to float
  store float %cvt, float addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @extract_byte2_to_f32(float addrspace(1)* noalias %out, i32 addrspace(1)* noalias %in) nounwind {
; SI-LABEL: extract_byte2_to_f32:
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
; SI-NEXT:    v_cvt_f32_ubyte2_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: extract_byte2_to_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte2_e32 v0, v0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i32, i32 addrspace(1)* %in, i32 %tid
  %val = load i32, i32 addrspace(1)* %gep
  %srl = lshr i32 %val, 16
  %and = and i32 %srl, 255
  %cvt = uitofp i32 %and to float
  store float %cvt, float addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @extract_byte3_to_f32(float addrspace(1)* noalias %out, i32 addrspace(1)* noalias %in) nounwind {
; SI-LABEL: extract_byte3_to_f32:
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
; SI-NEXT:    v_cvt_f32_ubyte3_e32 v0, v0
; SI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: extract_byte3_to_f32:
; VI:       ; %bb.0:
; VI-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; VI-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x2c
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s7, 0xf000
; VI-NEXT:    s_mov_b32 s6, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s1
; VI-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v0, v[0:1]
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_cvt_f32_ubyte3_e32 v0, v0
; VI-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; VI-NEXT:    s_endpgm
  %tid = call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr i32, i32 addrspace(1)* %in, i32 %tid
  %val = load i32, i32 addrspace(1)* %gep
  %srl = lshr i32 %val, 24
  %and = and i32 %srl, 255
  %cvt = uitofp i32 %and to float
  store float %cvt, float addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @cvt_ubyte0_or_multiuse(i32 addrspace(1)* %in, float addrspace(1)* %out) {
; SI-LABEL: cvt_ubyte0_or_multiuse:
; SI:       ; %bb.0: ; %bb
; SI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; SI-NEXT:    s_mov_b32 s3, 0xf000
; SI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; SI-NEXT:    v_mov_b32_e32 v1, 0
; SI-NEXT:    s_mov_b32 s2, -1
; SI-NEXT:    s_waitcnt lgkmcnt(0)
; SI-NEXT:    s_mov_b32 s0, s6
; SI-NEXT:    s_mov_b32 s1, s7
; SI-NEXT:    s_mov_b32 s6, 0
; SI-NEXT:    s_mov_b32 s7, s3
; SI-NEXT:    buffer_load_dword v0, v[0:1], s[4:7], 0 addr64
; SI-NEXT:    s_waitcnt vmcnt(0)
; SI-NEXT:    v_or_b32_e32 v0, 0x80000001, v0
; SI-NEXT:    v_cvt_f32_ubyte0_e32 v1, v0
; SI-NEXT:    v_add_f32_e32 v0, v0, v1
; SI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; SI-NEXT:    s_endpgm
;
; VI-LABEL: cvt_ubyte0_or_multiuse:
; VI:       ; %bb.0: ; %bb
; VI-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; VI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; VI-NEXT:    s_mov_b32 s3, 0xf000
; VI-NEXT:    s_mov_b32 s2, -1
; VI-NEXT:    s_waitcnt lgkmcnt(0)
; VI-NEXT:    v_mov_b32_e32 v1, s5
; VI-NEXT:    v_add_u32_e32 v0, vcc, s4, v0
; VI-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; VI-NEXT:    flat_load_dword v0, v[0:1]
; VI-NEXT:    s_mov_b32 s0, s6
; VI-NEXT:    s_mov_b32 s1, s7
; VI-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; VI-NEXT:    v_or_b32_e32 v0, 0x80000001, v0
; VI-NEXT:    v_cvt_f32_ubyte0_e32 v1, v0
; VI-NEXT:    v_add_f32_e32 v0, v0, v1
; VI-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; VI-NEXT:    s_endpgm
bb:
  %lid = tail call i32 @llvm.amdgcn.workitem.id.x()
  %gep = getelementptr inbounds i32, i32 addrspace(1)* %in, i32 %lid
  %load = load i32, i32 addrspace(1)* %gep
  %or = or i32 %load, -2147483647
  %and = and i32 %or, 255
  %uitofp = uitofp i32 %and to float
  %cast = bitcast i32 %or to float
  %add = fadd float %cast, %uitofp
  store float %add, float addrspace(1)* %out
  ret void
}
