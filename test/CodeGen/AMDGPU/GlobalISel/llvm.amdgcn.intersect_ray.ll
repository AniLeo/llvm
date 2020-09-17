; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1030 -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

; uint4 llvm.amdgcn.image.bvh.intersect.ray.i32.v4f32(uint node_ptr, float ray_extent, float4 ray_origin, float4 ray_dir, float4 ray_inv_dir, uint4 texture_descr)
; uint4 llvm.amdgcn.image.bvh.intersect.ray.i32.v4f16(uint node_ptr, float ray_extent, float4 ray_origin, half4 ray_dir, half4 ray_inv_dir, uint4 texture_descr)
; uint4 llvm.amdgcn.image.bvh.intersect.ray.i64.v4f32(ulong node_ptr, float ray_extent, float4 ray_origin, float4 ray_dir, float4 ray_inv_dir, uint4 texture_descr)
; uint4 llvm.amdgcn.image.bvh.intersect.ray.i64.v4f16(ulong node_ptr, float ray_extent, float4 ray_origin, half4 ray_dir, half4 ray_inv_dir, uint4 texture_descr)

declare <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i32.v4f32(i32, float, <4 x float>, <4 x float>, <4 x float>, <4 x i32>)
declare <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i32.v4f16(i32, float, <4 x float>, <4 x half>, <4 x half>, <4 x i32>)
declare <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i64.v4f32(i64, float, <4 x float>, <4 x float>, <4 x float>, <4 x i32>)
declare <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i64.v4f16(i64, float, <4 x float>, <4 x half>, <4 x half>, <4 x i32>)

define amdgpu_ps <4 x float> @image_bvh_intersect_ray(i32 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x float> %ray_dir, <4 x float> %ray_inv_dir, <4 x i32> inreg %tdescr) {
; GCN-LABEL: image_bvh_intersect_ray:
; GCN:       ; %bb.0:
; GCN-NEXT:    image_bvh_intersect_ray v[0:3], [v0, v1, v2, v3, v4, v6, v7, v8, v10, v11, v12], s[0:3]
; GCN-NEXT:    ; implicit-def: $vcc_hi
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %v = call <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i32.v4f32(i32 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x float> %ray_dir, <4 x float> %ray_inv_dir, <4 x i32> %tdescr)
  %r = bitcast <4 x i32> %v to <4 x float>
  ret <4 x float> %r
}

define amdgpu_ps <4 x float> @image_bvh_intersect_ray_a16(i32 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x half> %ray_dir, <4 x half> %ray_inv_dir, <4 x i32> inreg %tdescr) {
; GCN-LABEL: image_bvh_intersect_ray_a16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s4, 0xffff
; GCN-NEXT:    v_lshrrev_b32_e32 v5, 16, v6
; GCN-NEXT:    v_and_b32_e32 v10, s4, v8
; GCN-NEXT:    v_lshrrev_b32_e32 v8, 16, v8
; GCN-NEXT:    v_and_b32_e32 v9, s4, v9
; GCN-NEXT:    ; implicit-def: $vcc_hi
; GCN-NEXT:    v_lshlrev_b32_e32 v5, 16, v5
; GCN-NEXT:    v_lshlrev_b32_e32 v10, 16, v10
; GCN-NEXT:    v_and_or_b32 v5, v6, s4, v5
; GCN-NEXT:    v_and_or_b32 v6, v7, s4, v10
; GCN-NEXT:    v_lshl_or_b32 v7, v9, 16, v8
; GCN-NEXT:    image_bvh_intersect_ray v[0:3], v[0:7], s[0:3] a16
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %v = call <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i32.v4f16(i32 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x half> %ray_dir, <4 x half> %ray_inv_dir, <4 x i32> %tdescr)
  %r = bitcast <4 x i32> %v to <4 x float>
  ret <4 x float> %r
}

define amdgpu_ps <4 x float> @image_bvh64_intersect_ray(i64 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x float> %ray_dir, <4 x float> %ray_inv_dir, <4 x i32> inreg %tdescr) {
; GCN-LABEL: image_bvh64_intersect_ray:
; GCN:       ; %bb.0:
; GCN-NEXT:    image_bvh64_intersect_ray v[0:3], [v0, v1, v2, v3, v4, v5, v7, v8, v9, v11, v12, v13], s[0:3]
; GCN-NEXT:    ; implicit-def: $vcc_hi
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %v = call <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i64.v4f32(i64 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x float> %ray_dir, <4 x float> %ray_inv_dir, <4 x i32> %tdescr)
  %r = bitcast <4 x i32> %v to <4 x float>
  ret <4 x float> %r
}

define amdgpu_ps <4 x float> @image_bvh64_intersect_ray_a16(i64 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x half> %ray_dir, <4 x half> %ray_inv_dir, <4 x i32> inreg %tdescr) {
; GCN-LABEL: image_bvh64_intersect_ray_a16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s4, 0xffff
; GCN-NEXT:    v_lshrrev_b32_e32 v6, 16, v7
; GCN-NEXT:    v_and_b32_e32 v11, s4, v9
; GCN-NEXT:    v_lshrrev_b32_e32 v9, 16, v9
; GCN-NEXT:    v_and_b32_e32 v10, s4, v10
; GCN-NEXT:    ; implicit-def: $vcc_hi
; GCN-NEXT:    v_lshlrev_b32_e32 v6, 16, v6
; GCN-NEXT:    v_lshlrev_b32_e32 v11, 16, v11
; GCN-NEXT:    v_and_or_b32 v6, v7, s4, v6
; GCN-NEXT:    v_and_or_b32 v7, v8, s4, v11
; GCN-NEXT:    v_lshl_or_b32 v8, v10, 16, v9
; GCN-NEXT:    image_bvh64_intersect_ray v[0:3], v[0:15], s[0:3] a16
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    ; return to shader part epilog
  %v = call <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i64.v4f16(i64 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x half> %ray_dir, <4 x half> %ray_inv_dir, <4 x i32> %tdescr)
  %r = bitcast <4 x i32> %v to <4 x float>
  ret <4 x float> %r
}

define amdgpu_ps <4 x float> @image_bvh_intersect_ray_vgpr_descr(i32 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x float> %ray_dir, <4 x float> %ray_inv_dir, <4 x i32> %tdescr) {
; GCN-LABEL: image_bvh_intersect_ray_vgpr_descr:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s1, exec_lo
; GCN-NEXT:    ; implicit-def: $vcc_hi
; GCN-NEXT:  BB4_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s4, v14
; GCN-NEXT:    v_readfirstlane_b32 s5, v15
; GCN-NEXT:    v_readfirstlane_b32 s6, v16
; GCN-NEXT:    v_readfirstlane_b32 s7, v17
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc_lo, s[4:5], v[14:15]
; GCN-NEXT:    v_cmp_eq_u64_e64 s0, s[6:7], v[16:17]
; GCN-NEXT:    s_nop 2
; GCN-NEXT:    image_bvh_intersect_ray v[18:21], [v0, v1, v2, v3, v4, v6, v7, v8, v10, v11, v12], s[4:7]
; GCN-NEXT:    s_and_b32 s0, s0, vcc_lo
; GCN-NEXT:    s_and_saveexec_b32 s0, s0
; GCN-NEXT:    s_xor_b32 exec_lo, exec_lo, s0
; GCN-NEXT:    s_cbranch_execnz BB4_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b32 exec_lo, s1
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, v18
; GCN-NEXT:    v_mov_b32_e32 v1, v19
; GCN-NEXT:    v_mov_b32_e32 v2, v20
; GCN-NEXT:    v_mov_b32_e32 v3, v21
; GCN-NEXT:    ; return to shader part epilog
  %v = call <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i32.v4f32(i32 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x float> %ray_dir, <4 x float> %ray_inv_dir, <4 x i32> %tdescr)
  %r = bitcast <4 x i32> %v to <4 x float>
  ret <4 x float> %r
}

define amdgpu_ps <4 x float> @image_bvh_intersect_ray_a16_vgpr_descr(i32 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x half> %ray_dir, <4 x half> %ray_inv_dir, <4 x i32> %tdescr) {
; GCN-LABEL: image_bvh_intersect_ray_a16_vgpr_descr:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s0, 0xffff
; GCN-NEXT:    v_lshrrev_b32_e32 v5, 16, v6
; GCN-NEXT:    v_and_b32_e32 v14, s0, v8
; GCN-NEXT:    v_lshrrev_b32_e32 v8, 16, v8
; GCN-NEXT:    v_and_b32_e32 v15, s0, v9
; GCN-NEXT:    s_mov_b32 s1, exec_lo
; GCN-NEXT:    v_lshlrev_b32_e32 v5, 16, v5
; GCN-NEXT:    v_lshlrev_b32_e32 v14, 16, v14
; GCN-NEXT:    ; implicit-def: $vcc_hi
; GCN-NEXT:    v_lshl_or_b32 v15, v15, 16, v8
; GCN-NEXT:    v_and_or_b32 v9, v6, s0, v5
; GCN-NEXT:    v_and_or_b32 v14, v7, s0, v14
; GCN-NEXT:  BB5_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s4, v10
; GCN-NEXT:    v_readfirstlane_b32 s5, v11
; GCN-NEXT:    v_readfirstlane_b32 s6, v12
; GCN-NEXT:    v_readfirstlane_b32 s7, v13
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc_lo, s[4:5], v[10:11]
; GCN-NEXT:    v_cmp_eq_u64_e64 s0, s[6:7], v[12:13]
; GCN-NEXT:    s_nop 2
; GCN-NEXT:    image_bvh_intersect_ray v[5:8], [v0, v1, v2, v3, v4, v9, v14, v15], s[4:7] a16
; GCN-NEXT:    s_and_b32 s0, s0, vcc_lo
; GCN-NEXT:    s_and_saveexec_b32 s0, s0
; GCN-NEXT:    s_xor_b32 exec_lo, exec_lo, s0
; GCN-NEXT:    s_cbranch_execnz BB5_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b32 exec_lo, s1
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, v5
; GCN-NEXT:    v_mov_b32_e32 v1, v6
; GCN-NEXT:    v_mov_b32_e32 v2, v7
; GCN-NEXT:    v_mov_b32_e32 v3, v8
; GCN-NEXT:    ; return to shader part epilog
  %v = call <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i32.v4f16(i32 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x half> %ray_dir, <4 x half> %ray_inv_dir, <4 x i32> %tdescr)
  %r = bitcast <4 x i32> %v to <4 x float>
  ret <4 x float> %r
}

define amdgpu_ps <4 x float> @image_bvh64_intersect_ray_vgpr_descr(i64 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x float> %ray_dir, <4 x float> %ray_inv_dir, <4 x i32> %tdescr) {
; GCN-LABEL: image_bvh64_intersect_ray_vgpr_descr:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s1, exec_lo
; GCN-NEXT:    ; implicit-def: $vcc_hi
; GCN-NEXT:  BB6_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s4, v15
; GCN-NEXT:    v_readfirstlane_b32 s5, v16
; GCN-NEXT:    v_readfirstlane_b32 s6, v17
; GCN-NEXT:    v_readfirstlane_b32 s7, v18
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc_lo, s[4:5], v[15:16]
; GCN-NEXT:    v_cmp_eq_u64_e64 s0, s[6:7], v[17:18]
; GCN-NEXT:    s_nop 2
; GCN-NEXT:    image_bvh64_intersect_ray v[19:22], [v0, v1, v2, v3, v4, v5, v7, v8, v9, v11, v12, v13], s[4:7]
; GCN-NEXT:    s_and_b32 s0, s0, vcc_lo
; GCN-NEXT:    s_and_saveexec_b32 s0, s0
; GCN-NEXT:    s_xor_b32 exec_lo, exec_lo, s0
; GCN-NEXT:    s_cbranch_execnz BB6_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b32 exec_lo, s1
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, v19
; GCN-NEXT:    v_mov_b32_e32 v1, v20
; GCN-NEXT:    v_mov_b32_e32 v2, v21
; GCN-NEXT:    v_mov_b32_e32 v3, v22
; GCN-NEXT:    ; return to shader part epilog
  %v = call <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i64.v4f32(i64 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x float> %ray_dir, <4 x float> %ray_inv_dir, <4 x i32> %tdescr)
  %r = bitcast <4 x i32> %v to <4 x float>
  ret <4 x float> %r
}

define amdgpu_ps <4 x float> @image_bvh64_intersect_ray_a16_vgpr_descr(i64 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x half> %ray_dir, <4 x half> %ray_inv_dir, <4 x i32> %tdescr) {
; GCN-LABEL: image_bvh64_intersect_ray_a16_vgpr_descr:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s0, 0xffff
; GCN-NEXT:    v_lshrrev_b32_e32 v6, 16, v7
; GCN-NEXT:    v_and_b32_e32 v15, s0, v9
; GCN-NEXT:    v_lshrrev_b32_e32 v9, 16, v9
; GCN-NEXT:    v_and_b32_e32 v16, s0, v10
; GCN-NEXT:    s_mov_b32 s1, exec_lo
; GCN-NEXT:    v_lshlrev_b32_e32 v6, 16, v6
; GCN-NEXT:    v_lshlrev_b32_e32 v15, 16, v15
; GCN-NEXT:    ; implicit-def: $vcc_hi
; GCN-NEXT:    v_lshl_or_b32 v16, v16, 16, v9
; GCN-NEXT:    v_and_or_b32 v10, v7, s0, v6
; GCN-NEXT:    v_and_or_b32 v15, v8, s0, v15
; GCN-NEXT:  BB7_1: ; =>This Inner Loop Header: Depth=1
; GCN-NEXT:    v_readfirstlane_b32 s4, v11
; GCN-NEXT:    v_readfirstlane_b32 s5, v12
; GCN-NEXT:    v_readfirstlane_b32 s6, v13
; GCN-NEXT:    v_readfirstlane_b32 s7, v14
; GCN-NEXT:    v_cmp_eq_u64_e32 vcc_lo, s[4:5], v[11:12]
; GCN-NEXT:    v_cmp_eq_u64_e64 s0, s[6:7], v[13:14]
; GCN-NEXT:    s_nop 2
; GCN-NEXT:    image_bvh64_intersect_ray v[6:9], [v0, v1, v2, v3, v4, v5, v10, v15, v16], s[4:7] a16
; GCN-NEXT:    s_and_b32 s0, s0, vcc_lo
; GCN-NEXT:    s_and_saveexec_b32 s0, s0
; GCN-NEXT:    s_xor_b32 exec_lo, exec_lo, s0
; GCN-NEXT:    s_cbranch_execnz BB7_1
; GCN-NEXT:  ; %bb.2:
; GCN-NEXT:    s_mov_b32 exec_lo, s1
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_mov_b32_e32 v0, v6
; GCN-NEXT:    v_mov_b32_e32 v1, v7
; GCN-NEXT:    v_mov_b32_e32 v2, v8
; GCN-NEXT:    v_mov_b32_e32 v3, v9
; GCN-NEXT:    ; return to shader part epilog
  %v = call <4 x i32> @llvm.amdgcn.image.bvh.intersect.ray.i64.v4f16(i64 %node_ptr, float %ray_extent, <4 x float> %ray_origin, <4 x half> %ray_dir, <4 x half> %ray_inv_dir, <4 x i32> %tdescr)
  %r = bitcast <4 x i32> %v to <4 x float>
  ret <4 x float> %r
}
