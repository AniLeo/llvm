; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1030 < %s | FileCheck -check-prefixes=GCN,SDAG %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1030 < %s | FileCheck -check-prefixes=GCN,GISEL %s

define float @v_fma(float %a, float %b, float %c)  {
; GCN-LABEL: v_fma:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-NEXT:    v_fmac_legacy_f32_e64 v2, v0, v1
; GCN-NEXT:    v_mov_b32_e32 v0, v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %fma = call float @llvm.amdgcn.fma.legacy(float %a, float %b, float %c)
  ret float %fma
}

define float @v_fabs_fma(float %a, float %b, float %c)  {
; GCN-LABEL: v_fabs_fma:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-NEXT:    v_fma_legacy_f32 v0, |v0|, v1, v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %fabs.a = call float @llvm.fabs.f32(float %a)
  %fma = call float @llvm.amdgcn.fma.legacy(float %fabs.a, float %b, float %c)
  ret float %fma
}

define float @v_fneg_fabs_fma(float %a, float %b, float %c)  {
; GCN-LABEL: v_fneg_fabs_fma:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-NEXT:    v_fma_legacy_f32 v0, v0, -|v1|, v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %fabs.b = call float @llvm.fabs.f32(float %b)
  %neg.fabs.b = fneg float %fabs.b
  %fma = call float @llvm.amdgcn.fma.legacy(float %a, float %neg.fabs.b, float %c)
  ret float %fma
}

define float @v_fneg_fma(float %a, float %b, float %c)  {
; GCN-LABEL: v_fneg_fma:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    s_waitcnt_vscnt null, 0x0
; GCN-NEXT:    v_fma_legacy_f32 v0, v0, v1, -v2
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %neg.c = fneg float %c
  %fma = call float @llvm.amdgcn.fma.legacy(float %a, float %b, float %neg.c)
  ret float %fma
}

define amdgpu_ps <{ i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float }> @main(<4 x i32> addrspace(6)* inreg noalias align 32 dereferenceable(18446744073709551615) %arg, <8 x i32> addrspace(6)* inreg noalias align 32 dereferenceable(18446744073709551615) %arg1, <4 x i32> addrspace(6)* inreg noalias align 32 dereferenceable(18446744073709551615) %arg2, <8 x i32> addrspace(6)* inreg noalias align 32 dereferenceable(18446744073709551615) %arg3, i32 inreg %arg4, i32 inreg %arg5, <2 x i32> %arg6, <2 x i32> %arg7, <2 x i32> %arg8, <3 x i32> %arg9, <2 x i32> %arg10, <2 x i32> %arg11, <2 x i32> %arg12, <3 x float> %arg13, float %arg14, float %arg15, float %arg16, float %arg17, i32 %arg18, i32 %arg19, float %arg20, i32 %arg21) #0 {
; SDAG-LABEL: main:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    s_mov_b32 s16, exec_lo
; SDAG-NEXT:    v_mov_b32_e32 v14, v2
; SDAG-NEXT:    s_mov_b32 s0, s5
; SDAG-NEXT:    s_wqm_b32 exec_lo, exec_lo
; SDAG-NEXT:    s_mov_b32 s1, 0
; SDAG-NEXT:    s_mov_b32 m0, s7
; SDAG-NEXT:    s_clause 0x1
; SDAG-NEXT:    s_load_dwordx8 s[8:15], s[0:1], 0x400
; SDAG-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x430
; SDAG-NEXT:    v_interp_p1_f32_e32 v2, v0, attr0.x
; SDAG-NEXT:    v_interp_p1_f32_e32 v3, v0, attr0.y
; SDAG-NEXT:    s_mov_b32 s4, s6
; SDAG-NEXT:    v_interp_p2_f32_e32 v2, v1, attr0.x
; SDAG-NEXT:    v_interp_p2_f32_e32 v3, v1, attr0.y
; SDAG-NEXT:    s_and_b32 exec_lo, exec_lo, s16
; SDAG-NEXT:    s_waitcnt lgkmcnt(0)
; SDAG-NEXT:    image_sample v[7:10], v[2:3], s[8:15], s[0:3] dmask:0xf dim:SQ_RSRC_IMG_2D
; SDAG-NEXT:    v_mov_b32_e32 v4, -1.0
; SDAG-NEXT:    v_mov_b32_e32 v5, -1.0
; SDAG-NEXT:    s_waitcnt vmcnt(0)
; SDAG-NEXT:    v_fmac_legacy_f32_e64 v4, v7, 2.0
; SDAG-NEXT:    v_fmac_legacy_f32_e64 v5, v8, 2.0
; SDAG-NEXT:    v_mov_b32_e32 v2, v9
; SDAG-NEXT:    v_mov_b32_e32 v3, v10
; SDAG-NEXT:    v_mov_b32_e32 v0, v4
; SDAG-NEXT:    v_mov_b32_e32 v1, v5
; SDAG-NEXT:    ; return to shader part epilog
;
; GISEL-LABEL: main:
; GISEL:       ; %bb.0:
; GISEL-NEXT:    s_mov_b32 s16, exec_lo
; GISEL-NEXT:    s_mov_b32 s4, s6
; GISEL-NEXT:    s_mov_b32 m0, s7
; GISEL-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GISEL-NEXT:    s_add_u32 s0, s5, 0x400
; GISEL-NEXT:    s_mov_b32 s1, 0
; GISEL-NEXT:    v_interp_p1_f32_e32 v3, v0, attr0.y
; GISEL-NEXT:    s_load_dwordx8 s[8:15], s[0:1], 0x0
; GISEL-NEXT:    s_add_u32 s0, s5, 0x430
; GISEL-NEXT:    v_mov_b32_e32 v14, v2
; GISEL-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x0
; GISEL-NEXT:    v_interp_p1_f32_e32 v2, v0, attr0.x
; GISEL-NEXT:    v_interp_p2_f32_e32 v3, v1, attr0.y
; GISEL-NEXT:    v_interp_p2_f32_e32 v2, v1, attr0.x
; GISEL-NEXT:    s_and_b32 exec_lo, exec_lo, s16
; GISEL-NEXT:    s_waitcnt lgkmcnt(0)
; GISEL-NEXT:    image_sample v[7:10], v[2:3], s[8:15], s[0:3] dmask:0xf dim:SQ_RSRC_IMG_2D
; GISEL-NEXT:    v_mov_b32_e32 v4, -1.0
; GISEL-NEXT:    v_mov_b32_e32 v5, -1.0
; GISEL-NEXT:    s_waitcnt vmcnt(0)
; GISEL-NEXT:    v_fmac_legacy_f32_e64 v4, v7, 2.0
; GISEL-NEXT:    v_fmac_legacy_f32_e64 v5, v8, 2.0
; GISEL-NEXT:    v_mov_b32_e32 v2, v9
; GISEL-NEXT:    v_mov_b32_e32 v3, v10
; GISEL-NEXT:    v_mov_b32_e32 v0, v4
; GISEL-NEXT:    v_mov_b32_e32 v1, v5
; GISEL-NEXT:    ; return to shader part epilog
  %i = bitcast <2 x i32> %arg7 to <2 x float>
  %i22 = extractelement <2 x float> %i, i32 0
  %i23 = extractelement <2 x float> %i, i32 1
  %i24 = call nsz arcp float @llvm.amdgcn.interp.p1(float %i22, i32 0, i32 0, i32 %arg5)
  %i25 = call nsz arcp float @llvm.amdgcn.interp.p2(float %i24, float %i23, i32 0, i32 0, i32 %arg5)
  %i26 = call nsz arcp float @llvm.amdgcn.interp.p1(float %i22, i32 1, i32 0, i32 %arg5)
  %i27 = call nsz arcp float @llvm.amdgcn.interp.p2(float %i26, float %i23, i32 1, i32 0, i32 %arg5)
  %i28 = getelementptr inbounds <8 x i32>, <8 x i32> addrspace(6)* %arg3, i32 32, !amdgpu.uniform !0
  %i29 = load <8 x i32>, <8 x i32> addrspace(6)* %i28, align 32, !invariant.load !0
  %i30 = bitcast <8 x i32> addrspace(6)* %arg3 to <4 x i32> addrspace(6)*
  %i31 = getelementptr inbounds <4 x i32>, <4 x i32> addrspace(6)* %i30, i32 67, !amdgpu.uniform !0
  %i32 = load <4 x i32>, <4 x i32> addrspace(6)* %i31, align 16, !invariant.load !0
  %i33 = call nsz arcp <4 x float> @llvm.amdgcn.image.sample.2d.v4f32.f32(i32 15, float %i25, float %i27, <8 x i32> %i29, <4 x i32> %i32, i1 false, i32 0, i32 0)
  %i34 = extractelement <4 x float> %i33, i32 0
  %i35 = call nsz arcp float @llvm.amdgcn.fma.legacy(float %i34, float 2.000000e+00, float -1.000000e+00)
  %i36 = extractelement <4 x float> %i33, i32 1
  %i37 = call nsz arcp float @llvm.amdgcn.fma.legacy(float %i36, float 2.000000e+00, float -1.000000e+00)
  %i38 = extractelement <4 x float> %i33, i32 2
  %i39 = extractelement <4 x float> %i33, i32 3
  %i40 = insertvalue <{ i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float }> undef, i32 %arg4, 4
  %i41 = insertvalue <{ i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float }> %i40, float %i35, 5
  %i42 = insertvalue <{ i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float }> %i41, float %i37, 6
  %i43 = insertvalue <{ i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float }> %i42, float %i38, 7
  %i44 = insertvalue <{ i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float }> %i43, float %i39, 8
  %i45 = insertvalue <{ i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float }> %i44, float %arg20, 19
  ret <{ i32, i32, i32, i32, i32, float, float, float, float, float, float, float, float, float, float, float, float, float, float, float }> %i45
}

declare float @llvm.amdgcn.fma.legacy(float, float, float)
declare <4 x float> @llvm.amdgcn.image.sample.2d.v4f32.f32(i32 immarg, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg)
declare float @llvm.amdgcn.interp.p1(float, i32 immarg, i32 immarg, i32)
declare float @llvm.amdgcn.interp.p2(float, float, i32 immarg, i32 immarg, i32)
declare float @llvm.fabs.f32(float)

!0 = !{}
