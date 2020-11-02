; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=bonaire -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GCN,CI %s
; RUN: llc -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GCN,GFX9 %s

declare i32 @llvm.amdgcn.workitem.id.x() #0

@lds.obj = addrspace(3) global [256 x i32] undef, align 4

define amdgpu_kernel void @write_ds_sub0_offset0_global() #0 {
; CI-LABEL: write_ds_sub0_offset0_global:
; CI:       ; %bb.0: ; %entry
; CI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; CI-NEXT:    v_sub_i32_e32 v0, vcc, lds.obj@abs32@lo, v0
; CI-NEXT:    v_mov_b32_e32 v1, 0x7b
; CI-NEXT:    s_mov_b32 m0, -1
; CI-NEXT:    ds_write_b32 v0, v1 offset:12
; CI-NEXT:    s_endpgm
;
; GFX9-LABEL: write_ds_sub0_offset0_global:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, lds.obj@abs32@lo, v0
; GFX9-NEXT:    v_mov_b32_e32 v1, 0x7b
; GFX9-NEXT:    ds_write_b32 v0, v1 offset:12
; GFX9-NEXT:    s_endpgm
entry:
  %x.i = call i32 @llvm.amdgcn.workitem.id.x() #1
  %sub1 = sub i32 0, %x.i
  %tmp0 = getelementptr [256 x i32], [256 x i32] addrspace(3)* @lds.obj, i32 0, i32 %sub1
  %arrayidx = getelementptr inbounds i32, i32 addrspace(3)* %tmp0, i32 3
  store i32 123, i32 addrspace(3)* %arrayidx
  ret void
}

define amdgpu_kernel void @write_ds_sub0_offset0_global_clamp_bit(float %dummy.val) #0 {
; CI-LABEL: write_ds_sub0_offset0_global_clamp_bit:
; CI:       ; %bb.0: ; %entry
; CI-NEXT:    s_load_dword s0, s[0:1], 0x9
; CI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; CI-NEXT:    v_sub_i32_e32 v0, vcc, lds.obj@abs32@lo, v0
; CI-NEXT:    s_mov_b64 vcc, 0
; CI-NEXT:    v_mov_b32_e32 v2, 0x7b
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    v_mov_b32_e32 v1, s0
; CI-NEXT:    s_mov_b32 s0, 0
; CI-NEXT:    v_div_fmas_f32 v1, v1, v1, v1
; CI-NEXT:    s_mov_b32 m0, -1
; CI-NEXT:    s_mov_b32 s3, 0xf000
; CI-NEXT:    s_mov_b32 s2, -1
; CI-NEXT:    s_mov_b32 s1, s0
; CI-NEXT:    ds_write_b32 v0, v2 offset:12
; CI-NEXT:    buffer_store_dword v1, off, s[0:3], 0
; CI-NEXT:    s_endpgm
;
; GFX9-LABEL: write_ds_sub0_offset0_global_clamp_bit:
; GFX9:       ; %bb.0: ; %entry
; GFX9-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX9-NEXT:    s_mov_b64 vcc, 0
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, lds.obj@abs32@lo, v0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    v_div_fmas_f32 v2, v1, v1, v1
; GFX9-NEXT:    v_mov_b32_e32 v1, 0x7b
; GFX9-NEXT:    ds_write_b32 v0, v1 offset:12
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    global_store_dword v[0:1], v2, off
; GFX9-NEXT:    s_endpgm
entry:
  %x.i = call i32 @llvm.amdgcn.workitem.id.x() #1
  %sub1 = sub i32 0, %x.i
  %tmp0 = getelementptr [256 x i32], [256 x i32] addrspace(3)* @lds.obj, i32 0, i32 %sub1
  %arrayidx = getelementptr inbounds i32, i32 addrspace(3)* %tmp0, i32 3
  store i32 123, i32 addrspace(3)* %arrayidx
  %fmas = call float @llvm.amdgcn.div.fmas.f32(float %dummy.val, float %dummy.val, float %dummy.val, i1 false)
  store volatile float %fmas, float addrspace(1)* null
  ret void
}

define amdgpu_kernel void @add_x_shl_neg_to_sub_max_offset() #1 {
; CI-LABEL: add_x_shl_neg_to_sub_max_offset:
; CI:       ; %bb.0:
; CI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; CI-NEXT:    v_sub_i32_e32 v0, vcc, 0, v0
; CI-NEXT:    v_mov_b32_e32 v1, 13
; CI-NEXT:    s_mov_b32 m0, -1
; CI-NEXT:    ds_write_b8 v0, v1 offset:65535
; CI-NEXT:    s_endpgm
;
; GFX9-LABEL: add_x_shl_neg_to_sub_max_offset:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0, v0
; GFX9-NEXT:    v_mov_b32_e32 v1, 13
; GFX9-NEXT:    ds_write_b8 v0, v1 offset:65535
; GFX9-NEXT:    s_endpgm
  %x.i = call i32 @llvm.amdgcn.workitem.id.x() #0
  %neg = sub i32 0, %x.i
  %shl = shl i32 %neg, 2
  %add = add i32 65535, %shl
  %ptr = inttoptr i32 %add to i8 addrspace(3)*
  store i8 13, i8 addrspace(3)* %ptr
  ret void
}

define amdgpu_kernel void @add_x_shl_neg_to_sub_max_offset_p1() #1 {
; CI-LABEL: add_x_shl_neg_to_sub_max_offset_p1:
; CI:       ; %bb.0:
; CI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; CI-NEXT:    v_sub_i32_e32 v0, vcc, 0x10000, v0
; CI-NEXT:    v_mov_b32_e32 v1, 13
; CI-NEXT:    s_mov_b32 m0, -1
; CI-NEXT:    ds_write_b8 v0, v1
; CI-NEXT:    s_endpgm
;
; GFX9-LABEL: add_x_shl_neg_to_sub_max_offset_p1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0x10000, v0
; GFX9-NEXT:    v_mov_b32_e32 v1, 13
; GFX9-NEXT:    ds_write_b8 v0, v1
; GFX9-NEXT:    s_endpgm
  %x.i = call i32 @llvm.amdgcn.workitem.id.x() #0
  %neg = sub i32 0, %x.i
  %shl = shl i32 %neg, 2
  %add = add i32 65536, %shl
  %ptr = inttoptr i32 %add to i8 addrspace(3)*
  store i8 13, i8 addrspace(3)* %ptr
  ret void
}

define amdgpu_kernel void @add_x_shl_neg_to_sub_multi_use() #1 {
; CI-LABEL: add_x_shl_neg_to_sub_multi_use:
; CI:       ; %bb.0:
; CI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; CI-NEXT:    v_sub_i32_e32 v0, vcc, 0, v0
; CI-NEXT:    v_mov_b32_e32 v1, 13
; CI-NEXT:    s_mov_b32 m0, -1
; CI-NEXT:    ds_write_b32 v0, v1 offset:123
; CI-NEXT:    ds_write_b32 v0, v1 offset:456
; CI-NEXT:    s_endpgm
;
; GFX9-LABEL: add_x_shl_neg_to_sub_multi_use:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0, v0
; GFX9-NEXT:    v_mov_b32_e32 v1, 13
; GFX9-NEXT:    ds_write_b32 v0, v1 offset:123
; GFX9-NEXT:    ds_write_b32 v0, v1 offset:456
; GFX9-NEXT:    s_endpgm
  %x.i = call i32 @llvm.amdgcn.workitem.id.x() #0
  %neg = sub i32 0, %x.i
  %shl = shl i32 %neg, 2
  %add0 = add i32 123, %shl
  %add1 = add i32 456, %shl
  %ptr0 = inttoptr i32 %add0 to i32 addrspace(3)*
  store volatile i32 13, i32 addrspace(3)* %ptr0
  %ptr1 = inttoptr i32 %add1 to i32 addrspace(3)*
  store volatile i32 13, i32 addrspace(3)* %ptr1
  ret void
}

define amdgpu_kernel void @add_x_shl_neg_to_sub_multi_use_same_offset() #1 {
; CI-LABEL: add_x_shl_neg_to_sub_multi_use_same_offset:
; CI:       ; %bb.0:
; CI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; CI-NEXT:    v_sub_i32_e32 v0, vcc, 0, v0
; CI-NEXT:    v_mov_b32_e32 v1, 13
; CI-NEXT:    s_mov_b32 m0, -1
; CI-NEXT:    ds_write_b32 v0, v1 offset:123
; CI-NEXT:    ds_write_b32 v0, v1 offset:123
; CI-NEXT:    s_endpgm
;
; GFX9-LABEL: add_x_shl_neg_to_sub_multi_use_same_offset:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0, v0
; GFX9-NEXT:    v_mov_b32_e32 v1, 13
; GFX9-NEXT:    ds_write_b32 v0, v1 offset:123
; GFX9-NEXT:    ds_write_b32 v0, v1 offset:123
; GFX9-NEXT:    s_endpgm
  %x.i = call i32 @llvm.amdgcn.workitem.id.x() #0
  %neg = sub i32 0, %x.i
  %shl = shl i32 %neg, 2
  %add = add i32 123, %shl
  %ptr = inttoptr i32 %add to i32 addrspace(3)*
  store volatile i32 13, i32 addrspace(3)* %ptr
  store volatile i32 13, i32 addrspace(3)* %ptr
  ret void
}

define amdgpu_kernel void @add_x_shl_neg_to_sub_misaligned_i64_max_offset() #1 {
; CI-LABEL: add_x_shl_neg_to_sub_misaligned_i64_max_offset:
; CI:       ; %bb.0:
; CI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; CI-NEXT:    v_sub_i32_e32 v0, vcc, 0, v0
; CI-NEXT:    v_mov_b32_e32 v1, 0x7b
; CI-NEXT:    v_mov_b32_e32 v2, 0
; CI-NEXT:    s_mov_b32 m0, -1
; CI-NEXT:    ds_write2_b32 v0, v1, v2 offset0:254 offset1:255
; CI-NEXT:    s_endpgm
;
; GFX9-LABEL: add_x_shl_neg_to_sub_misaligned_i64_max_offset:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0, v0
; GFX9-NEXT:    v_mov_b32_e32 v1, 0x7b
; GFX9-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-NEXT:    ds_write2_b32 v0, v1, v2 offset0:254 offset1:255
; GFX9-NEXT:    s_endpgm
  %x.i = call i32 @llvm.amdgcn.workitem.id.x() #0
  %neg = sub i32 0, %x.i
  %shl = shl i32 %neg, 2
  %add = add i32 1019, %shl
  %ptr = inttoptr i32 %add to i64 addrspace(3)*
  store i64 123, i64 addrspace(3)* %ptr, align 4
  ret void
}

define amdgpu_kernel void @add_x_shl_neg_to_sub_misaligned_i64_max_offset_clamp_bit(float %dummy.val) #1 {
; CI-LABEL: add_x_shl_neg_to_sub_misaligned_i64_max_offset_clamp_bit:
; CI:       ; %bb.0:
; CI-NEXT:    s_load_dword s0, s[0:1], 0x9
; CI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; CI-NEXT:    v_sub_i32_e32 v0, vcc, 0, v0
; CI-NEXT:    s_mov_b64 vcc, 0
; CI-NEXT:    v_mov_b32_e32 v2, 0x7b
; CI-NEXT:    s_waitcnt lgkmcnt(0)
; CI-NEXT:    v_mov_b32_e32 v1, s0
; CI-NEXT:    s_mov_b32 s0, 0
; CI-NEXT:    v_div_fmas_f32 v1, v1, v1, v1
; CI-NEXT:    v_mov_b32_e32 v3, 0
; CI-NEXT:    s_mov_b32 m0, -1
; CI-NEXT:    s_mov_b32 s3, 0xf000
; CI-NEXT:    s_mov_b32 s2, -1
; CI-NEXT:    s_mov_b32 s1, s0
; CI-NEXT:    ds_write2_b32 v0, v2, v3 offset0:254 offset1:255
; CI-NEXT:    buffer_store_dword v1, off, s[0:3], 0
; CI-NEXT:    s_endpgm
;
; GFX9-LABEL: add_x_shl_neg_to_sub_misaligned_i64_max_offset_clamp_bit:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dword s0, s[0:1], 0x24
; GFX9-NEXT:    s_mov_b64 vcc, 0
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0, v0
; GFX9-NEXT:    v_mov_b32_e32 v3, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    v_div_fmas_f32 v2, v1, v1, v1
; GFX9-NEXT:    v_mov_b32_e32 v1, 0x7b
; GFX9-NEXT:    ds_write2_b32 v0, v1, v3 offset0:254 offset1:255
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    v_mov_b32_e32 v1, 0
; GFX9-NEXT:    global_store_dword v[0:1], v2, off
; GFX9-NEXT:    s_endpgm
  %x.i = call i32 @llvm.amdgcn.workitem.id.x() #0
  %neg = sub i32 0, %x.i
  %shl = shl i32 %neg, 2
  %add = add i32 1019, %shl
  %ptr = inttoptr i32 %add to i64 addrspace(3)*
  store i64 123, i64 addrspace(3)* %ptr, align 4
  %fmas = call float @llvm.amdgcn.div.fmas.f32(float %dummy.val, float %dummy.val, float %dummy.val, i1 false)
  store volatile float %fmas, float addrspace(1)* null
  ret void
}

define amdgpu_kernel void @add_x_shl_neg_to_sub_misaligned_i64_max_offset_p1() #1 {
; CI-LABEL: add_x_shl_neg_to_sub_misaligned_i64_max_offset_p1:
; CI:       ; %bb.0:
; CI-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; CI-NEXT:    v_sub_i32_e32 v0, vcc, 0x3fc, v0
; CI-NEXT:    v_mov_b32_e32 v1, 0x7b
; CI-NEXT:    v_mov_b32_e32 v2, 0
; CI-NEXT:    s_mov_b32 m0, -1
; CI-NEXT:    ds_write2_b32 v0, v1, v2 offset1:1
; CI-NEXT:    s_endpgm
;
; GFX9-LABEL: add_x_shl_neg_to_sub_misaligned_i64_max_offset_p1:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_lshlrev_b32_e32 v0, 2, v0
; GFX9-NEXT:    v_sub_u32_e32 v0, 0x3fc, v0
; GFX9-NEXT:    v_mov_b32_e32 v1, 0x7b
; GFX9-NEXT:    v_mov_b32_e32 v2, 0
; GFX9-NEXT:    ds_write2_b32 v0, v1, v2 offset1:1
; GFX9-NEXT:    s_endpgm
  %x.i = call i32 @llvm.amdgcn.workitem.id.x() #0
  %neg = sub i32 0, %x.i
  %shl = shl i32 %neg, 2
  %add = add i32 1020, %shl
  %ptr = inttoptr i32 %add to i64 addrspace(3)*
  store i64 123, i64 addrspace(3)* %ptr, align 4
  ret void
}

declare float @llvm.amdgcn.div.fmas.f32(float, float, float, i1)

attributes #0 = { nounwind readnone }
attributes #1 = { nounwind }
attributes #2 = { nounwind convergent }
