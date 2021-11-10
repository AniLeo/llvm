; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=verde -verify-machineinstrs < %s | FileCheck --check-prefix=GCN %s
; RUN: llc -march=amdgcn -mcpu=tonga -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX8 %s
; RUN: llc -march=amdgcn -mcpu=gfx900 -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX9 %s

declare i32 @llvm.amdgcn.workitem.id.x() nounwind readnone
declare i32 @llvm.amdgcn.workitem.id.y() nounwind readnone

define amdgpu_kernel void @anyext_i1_i32(i32 addrspace(1)* %out, i32 %cond) #0 {
; GCN-LABEL: anyext_i1_i32:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dword s4, s[0:1], 0xb
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x9
; GCN-NEXT:    s_mov_b32 s3, 0xf000
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_cmp_lg_u32 s4, 0
; GCN-NEXT:    s_cselect_b64 s[4:5], -1, 0
; GCN-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; GCN-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GCN-NEXT:    s_endpgm
;
; GFX8-LABEL: anyext_i1_i32:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dword s4, s[0:1], 0x2c
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x24
; GFX8-NEXT:    s_mov_b32 s3, 0xf000
; GFX8-NEXT:    s_mov_b32 s2, -1
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    s_cmp_eq_u32 s4, 0
; GFX8-NEXT:    s_cselect_b64 s[4:5], -1, 0
; GFX8-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[4:5]
; GFX8-NEXT:    v_not_b32_e32 v0, v0
; GFX8-NEXT:    v_and_b32_e32 v0, 1, v0
; GFX8-NEXT:    buffer_store_dword v0, off, s[0:3], 0
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: anyext_i1_i32:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dword s2, s[0:1], 0x2c
; GFX9-NEXT:    s_load_dwordx2 s[4:5], s[0:1], 0x24
; GFX9-NEXT:    s_mov_b32 s7, 0xf000
; GFX9-NEXT:    s_mov_b32 s6, -1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    s_cmp_eq_u32 s2, 0
; GFX9-NEXT:    s_cselect_b64 s[0:1], -1, 0
; GFX9-NEXT:    v_cndmask_b32_e64 v0, 0, 1, s[0:1]
; GFX9-NEXT:    v_not_b32_e32 v0, v0
; GFX9-NEXT:    v_and_b32_e32 v0, 1, v0
; GFX9-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX9-NEXT:    s_endpgm
entry:
  %tmp = icmp eq i32 %cond, 0
  %tmp1 = zext i1 %tmp to i8
  %tmp2 = xor i8 %tmp1, -1
  %tmp3 = and i8 %tmp2, 1
  %tmp4 = zext i8 %tmp3 to i32
  store i32 %tmp4, i32 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @s_anyext_i16_i32(i32 addrspace(1)* %out, i16 addrspace(1)* %a, i16 addrspace(1)* %b) #0 {
; GCN-LABEL: s_anyext_i16_i32:
; GCN:       ; %bb.0: ; %entry
; GCN-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x9
; GCN-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0xd
; GCN-NEXT:    s_mov_b32 s11, 0xf000
; GCN-NEXT:    s_mov_b32 s14, 0
; GCN-NEXT:    s_mov_b32 s15, s11
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_mov_b64 s[12:13], s[6:7]
; GCN-NEXT:    v_lshlrev_b32_e32 v2, 1, v0
; GCN-NEXT:    v_mov_b32_e32 v3, 0
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 1, v1
; GCN-NEXT:    s_mov_b64 s[2:3], s[14:15]
; GCN-NEXT:    v_mov_b32_e32 v1, v3
; GCN-NEXT:    buffer_load_ushort v2, v[2:3], s[12:15], 0 addr64
; GCN-NEXT:    buffer_load_ushort v0, v[0:1], s[0:3], 0 addr64
; GCN-NEXT:    s_mov_b32 s10, -1
; GCN-NEXT:    s_mov_b32 s8, s4
; GCN-NEXT:    s_mov_b32 s9, s5
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_add_i32_e32 v0, vcc, v2, v0
; GCN-NEXT:    v_not_b32_e32 v0, v0
; GCN-NEXT:    v_and_b32_e32 v0, 1, v0
; GCN-NEXT:    buffer_store_dword v0, off, s[8:11], 0
; GCN-NEXT:    s_endpgm
;
; GFX8-LABEL: s_anyext_i16_i32:
; GFX8:       ; %bb.0: ; %entry
; GFX8-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX8-NEXT:    s_load_dwordx2 s[0:1], s[0:1], 0x34
; GFX8-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v3, s7
; GFX8-NEXT:    v_add_u32_e32 v2, vcc, s6, v0
; GFX8-NEXT:    v_addc_u32_e32 v3, vcc, 0, v3, vcc
; GFX8-NEXT:    v_lshlrev_b32_e32 v0, 1, v1
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    v_add_u32_e32 v0, vcc, s0, v0
; GFX8-NEXT:    v_addc_u32_e32 v1, vcc, 0, v1, vcc
; GFX8-NEXT:    flat_load_ushort v2, v[2:3]
; GFX8-NEXT:    flat_load_ushort v0, v[0:1]
; GFX8-NEXT:    s_mov_b32 s7, 0xf000
; GFX8-NEXT:    s_mov_b32 s6, -1
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_add_u16_e32 v0, v2, v0
; GFX8-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX8-NEXT:    v_and_b32_e32 v0, 1, v0
; GFX8-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX8-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: s_anyext_i16_i32:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dwordx4 s[4:7], s[0:1], 0x24
; GFX9-NEXT:    s_load_dwordx2 s[2:3], s[0:1], 0x34
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 1, v0
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 1, v1
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_ushort v2, v0, s[6:7]
; GFX9-NEXT:    global_load_ushort v3, v1, s[2:3]
; GFX9-NEXT:    s_mov_b32 s7, 0xf000
; GFX9-NEXT:    s_mov_b32 s6, -1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_add_u16_e32 v0, v2, v3
; GFX9-NEXT:    v_xor_b32_e32 v0, -1, v0
; GFX9-NEXT:    v_and_b32_e32 v0, 1, v0
; GFX9-NEXT:    v_and_b32_e32 v0, 0xffff, v0
; GFX9-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX9-NEXT:    s_endpgm
entry:
  %tid.x = call i32 @llvm.amdgcn.workitem.id.x()
  %tid.y = call i32 @llvm.amdgcn.workitem.id.y()
  %a.ptr = getelementptr i16, i16 addrspace(1)* %a, i32 %tid.x
  %b.ptr = getelementptr i16, i16 addrspace(1)* %b, i32 %tid.y
  %a.l = load i16, i16 addrspace(1)* %a.ptr
  %b.l = load i16, i16 addrspace(1)* %b.ptr
  %tmp = add i16 %a.l, %b.l
  %tmp1 = trunc i16 %tmp to i8
  %tmp2 = xor i8 %tmp1, -1
  %tmp3 = and i8 %tmp2, 1
  %tmp4 = zext i8 %tmp3 to i32
  store i32 %tmp4, i32 addrspace(1)* %out
  ret void
}

define amdgpu_kernel void @anyext_v2i16_to_v2i32() #0 {
; GCN-LABEL: anyext_v2i16_to_v2i32:
; GCN:       ; %bb.0: ; %bb
; GCN-NEXT:    s_mov_b32 s3, 0xf000
; GCN-NEXT:    s_mov_b32 s2, -1
; GCN-NEXT:    buffer_load_ushort v0, off, s[0:3], 0
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_and_b32_e32 v0, 0x8000, v0
; GCN-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; GCN-NEXT:    v_cmp_eq_f32_e32 vcc, 0, v0
; GCN-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GCN-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; GCN-NEXT:    s_endpgm
;
; GFX8-LABEL: anyext_v2i16_to_v2i32:
; GFX8:       ; %bb.0: ; %bb
; GFX8-NEXT:    s_mov_b32 s3, 0xf000
; GFX8-NEXT:    s_mov_b32 s2, -1
; GFX8-NEXT:    buffer_load_ushort v0, off, s[0:3], 0
; GFX8-NEXT:    v_mov_b32_e32 v1, 0x8000
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_and_b32_sdwa v0, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:DWORD
; GFX8-NEXT:    v_cmp_eq_f32_e32 vcc, 0, v0
; GFX8-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX8-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: anyext_v2i16_to_v2i32:
; GFX9:       ; %bb.0: ; %bb
; GFX9-NEXT:    global_load_short_d16_hi v0, v[0:1], off
; GFX9-NEXT:    v_mov_b32_e32 v1, 0xffff
; GFX9-NEXT:    s_mov_b32 s3, 0xf000
; GFX9-NEXT:    s_mov_b32 s2, -1
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_and_b32_e32 v0, 0x80008000, v0
; GFX9-NEXT:    v_bfi_b32 v0, v1, 0, v0
; GFX9-NEXT:    v_cmp_eq_f32_e32 vcc, 0, v0
; GFX9-NEXT:    v_cndmask_b32_e64 v0, 0, 1, vcc
; GFX9-NEXT:    buffer_store_byte v0, off, s[0:3], 0
; GFX9-NEXT:    s_endpgm
bb:
  %tmp = load i16, i16 addrspace(1)* undef, align 2
  %tmp2 = insertelement <2 x i16> undef, i16 %tmp, i32 1
  %tmp4 = and <2 x i16> %tmp2, <i16 -32768, i16 -32768>
  %tmp5 = zext <2 x i16> %tmp4 to <2 x i32>
  %tmp6 = shl nuw <2 x i32> %tmp5, <i32 16, i32 16>
  %tmp7 = or <2 x i32> zeroinitializer, %tmp6
  %tmp8 = bitcast <2 x i32> %tmp7 to <2 x float>
  %tmp10 = fcmp oeq <2 x float> %tmp8, zeroinitializer
  %tmp11 = zext <2 x i1> %tmp10 to <2 x i8>
  %tmp12 = extractelement <2 x i8> %tmp11, i32 1
  store i8 %tmp12, i8 addrspace(1)* undef, align 1
  ret void
}

attributes #0 = { nounwind }
