; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX10 %s

define amdgpu_ps <4 x float> @sample_d_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dsdv, float %s) {
; GFX10-LABEL: sample_d_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v3, 0xffff
; GFX10-NEXT:    s_lshl_b32 s12, s0, 16
; GFX10-NEXT:    v_and_or_b32 v0, v0, v3, s12
; GFX10-NEXT:    v_and_or_b32 v1, v1, v3, s12
; GFX10-NEXT:    image_sample_d_g16 v[0:3], v[0:2], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.d.1d.v4f32.f16.f32(i32 15, half %dsdh, half %dsdv, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_d_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t) {
; GFX10-LABEL: sample_d_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v6, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX10-NEXT:    v_and_or_b32 v0, v0, v6, v1
; GFX10-NEXT:    v_and_or_b32 v1, v2, v6, v3
; GFX10-NEXT:    image_sample_d_g16 v[0:3], [v0, v1, v4, v5], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.d.2d.v4f32.f16.f32(i32 15, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_d_3d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dtdh, half %drdh, half %dsdv, half %dtdv, half %drdv, float %s, float %t, float %r) {
; GFX10-LABEL: sample_d_3d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v9, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX10-NEXT:    v_lshlrev_b32_e32 v4, 16, v4
; GFX10-NEXT:    s_lshl_b32 s12, s0, 16
; GFX10-NEXT:    v_and_or_b32 v0, v0, v9, v1
; GFX10-NEXT:    v_and_or_b32 v1, v2, v9, s12
; GFX10-NEXT:    v_and_or_b32 v2, v3, v9, v4
; GFX10-NEXT:    v_and_or_b32 v3, v5, v9, s12
; GFX10-NEXT:    image_sample_d_g16 v[0:3], [v0, v1, v2, v3, v6, v7, v8], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_3D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.d.3d.v4f32.f16.f32(i32 15, half %dsdh, half %dtdh, half %drdh, half %dsdv, half %dtdv, half %drdv, float %s, float %t, float %r, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_d_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dsdv, float %s) {
; GFX10-LABEL: sample_c_d_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-NEXT:    s_lshl_b32 s12, s0, 16
; GFX10-NEXT:    v_and_or_b32 v1, v1, v4, s12
; GFX10-NEXT:    v_and_or_b32 v2, v2, v4, s12
; GFX10-NEXT:    image_sample_c_d_g16 v[0:3], v[0:3], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.d.1d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dsdv, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_d_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t) {
; GFX10-LABEL: sample_c_d_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v7, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; GFX10-NEXT:    v_lshlrev_b32_e32 v4, 16, v4
; GFX10-NEXT:    v_and_or_b32 v1, v1, v7, v2
; GFX10-NEXT:    v_and_or_b32 v2, v3, v7, v4
; GFX10-NEXT:    image_sample_c_d_g16 v[0:3], [v0, v1, v2, v5, v6], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.d.2d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_d_cl_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dsdv, float %s, float %clamp) {
; GFX10-LABEL: sample_d_cl_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-NEXT:    s_lshl_b32 s12, s0, 16
; GFX10-NEXT:    v_and_or_b32 v0, v0, v4, s12
; GFX10-NEXT:    v_and_or_b32 v1, v1, v4, s12
; GFX10-NEXT:    image_sample_d_cl_g16 v[0:3], v[0:3], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.d.cl.1d.v4f32.f16.f32(i32 15, half %dsdh, half %dsdv, float %s, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_d_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp) {
; GFX10-LABEL: sample_d_cl_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v7, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX10-NEXT:    v_and_or_b32 v0, v0, v7, v1
; GFX10-NEXT:    v_and_or_b32 v1, v2, v7, v3
; GFX10-NEXT:    image_sample_d_cl_g16 v[0:3], [v0, v1, v4, v5, v6], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.d.cl.2d.v4f32.f16.f32(i32 15, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_d_cl_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dsdv, float %s, float %clamp) {
; GFX10-LABEL: sample_c_d_cl_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v5, 0xffff
; GFX10-NEXT:    s_lshl_b32 s12, s0, 16
; GFX10-NEXT:    v_and_or_b32 v1, v1, v5, s12
; GFX10-NEXT:    v_and_or_b32 v2, v2, v5, s12
; GFX10-NEXT:    image_sample_c_d_cl_g16 v[0:3], v[0:4], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.d.cl.1d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dsdv, float %s, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_d_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp) {
; GFX10-LABEL: sample_c_d_cl_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v8, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; GFX10-NEXT:    v_lshlrev_b32_e32 v4, 16, v4
; GFX10-NEXT:    v_and_or_b32 v1, v1, v8, v2
; GFX10-NEXT:    v_and_or_b32 v2, v3, v8, v4
; GFX10-NEXT:    image_sample_c_d_cl_g16 v[0:3], [v0, v1, v2, v5, v6, v7], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.d.cl.2d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_cd_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dsdv, float %s) {
; GFX10-LABEL: sample_cd_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v3, 0xffff
; GFX10-NEXT:    s_lshl_b32 s12, s0, 16
; GFX10-NEXT:    v_and_or_b32 v0, v0, v3, s12
; GFX10-NEXT:    v_and_or_b32 v1, v1, v3, s12
; GFX10-NEXT:    image_sample_cd_g16 v[0:3], v[0:2], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.cd.1d.v4f32.f16.f32(i32 15, half %dsdh, half %dsdv, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_cd_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t) {
; GFX10-LABEL: sample_cd_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v6, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX10-NEXT:    v_and_or_b32 v0, v0, v6, v1
; GFX10-NEXT:    v_and_or_b32 v1, v2, v6, v3
; GFX10-NEXT:    image_sample_cd_g16 v[0:3], [v0, v1, v4, v5], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.cd.2d.v4f32.f16.f32(i32 15, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_cd_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dsdv, float %s) {
; GFX10-LABEL: sample_c_cd_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-NEXT:    s_lshl_b32 s12, s0, 16
; GFX10-NEXT:    v_and_or_b32 v1, v1, v4, s12
; GFX10-NEXT:    v_and_or_b32 v2, v2, v4, s12
; GFX10-NEXT:    image_sample_c_cd_g16 v[0:3], v[0:3], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.cd.1d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dsdv, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_cd_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t) {
; GFX10-LABEL: sample_c_cd_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v7, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; GFX10-NEXT:    v_lshlrev_b32_e32 v4, 16, v4
; GFX10-NEXT:    v_and_or_b32 v1, v1, v7, v2
; GFX10-NEXT:    v_and_or_b32 v2, v3, v7, v4
; GFX10-NEXT:    image_sample_c_cd_g16 v[0:3], [v0, v1, v2, v5, v6], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.cd.2d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_cd_cl_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dsdv, float %s, float %clamp) {
; GFX10-LABEL: sample_cd_cl_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-NEXT:    s_lshl_b32 s12, s0, 16
; GFX10-NEXT:    v_and_or_b32 v0, v0, v4, s12
; GFX10-NEXT:    v_and_or_b32 v1, v1, v4, s12
; GFX10-NEXT:    image_sample_cd_cl_g16 v[0:3], v[0:3], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.cd.cl.1d.v4f32.f16.f32(i32 15, half %dsdh, half %dsdv, float %s, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_cd_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp) {
; GFX10-LABEL: sample_cd_cl_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v7, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX10-NEXT:    v_and_or_b32 v0, v0, v7, v1
; GFX10-NEXT:    v_and_or_b32 v1, v2, v7, v3
; GFX10-NEXT:    image_sample_cd_cl_g16 v[0:3], [v0, v1, v4, v5, v6], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.cd.cl.2d.v4f32.f16.f32(i32 15, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_cd_cl_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dsdv, float %s, float %clamp) {
; GFX10-LABEL: sample_c_cd_cl_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v5, 0xffff
; GFX10-NEXT:    s_lshl_b32 s12, s0, 16
; GFX10-NEXT:    v_and_or_b32 v1, v1, v5, s12
; GFX10-NEXT:    v_and_or_b32 v2, v2, v5, s12
; GFX10-NEXT:    image_sample_c_cd_cl_g16 v[0:3], v[0:4], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_1D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.cd.cl.1d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dsdv, float %s, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_cd_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp) {
; GFX10-LABEL: sample_c_cd_cl_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v8, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v2, 16, v2
; GFX10-NEXT:    v_lshlrev_b32_e32 v4, 16, v4
; GFX10-NEXT:    v_and_or_b32 v1, v1, v8, v2
; GFX10-NEXT:    v_and_or_b32 v2, v3, v8, v4
; GFX10-NEXT:    image_sample_c_cd_cl_g16 v[0:3], [v0, v1, v2, v5, v6, v7], s[0:7], s[8:11] dmask:0xf dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.cd.cl.2d.v4f32.f16.f32(i32 15, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps float @sample_c_d_o_2darray_V1(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %slice) {
; GFX10-LABEL: sample_c_d_o_2darray_V1:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v9, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX10-NEXT:    v_lshlrev_b32_e32 v5, 16, v5
; GFX10-NEXT:    v_and_or_b32 v2, v2, v9, v3
; GFX10-NEXT:    v_and_or_b32 v3, v4, v9, v5
; GFX10-NEXT:    image_sample_c_d_o_g16 v0, [v0, v1, v2, v3, v6, v7, v8], s[0:7], s[8:11] dmask:0x4 dim:SQ_RSRC_IMG_2D_ARRAY
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call float @llvm.amdgcn.image.sample.c.d.o.2darray.f16.f32.f32(i32 4, i32 %offset, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %slice, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret float %v
}

define amdgpu_ps <2 x float> @sample_c_d_o_2darray_V2(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %slice) {
; GFX10-LABEL: sample_c_d_o_2darray_V2:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    v_mov_b32_e32 v9, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX10-NEXT:    v_lshlrev_b32_e32 v5, 16, v5
; GFX10-NEXT:    v_and_or_b32 v2, v2, v9, v3
; GFX10-NEXT:    v_and_or_b32 v3, v4, v9, v5
; GFX10-NEXT:    image_sample_c_d_o_g16 v[0:1], [v0, v1, v2, v3, v6, v7, v8], s[0:7], s[8:11] dmask:0x6 dim:SQ_RSRC_IMG_2D_ARRAY
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <2 x float> @llvm.amdgcn.image.sample.c.d.o.2darray.v2f32.f16.f32(i32 6, i32 %offset, float %zcompare, half %dsdh, half %dtdh, half %dsdv, half %dtdv, float %s, float %t, float %slice, <8 x i32> %rsrc, <4 x i32> %samp, i1 0, i32 0, i32 0)
  ret <2 x float> %v
}

declare <4 x float> @llvm.amdgcn.image.sample.d.1d.v4f32.f16.f32(i32, half, half, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.d.2d.v4f32.f16.f32(i32, half, half, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.d.3d.v4f32.f16.f32(i32, half, half, half, half, half, half, float, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.d.1d.v4f32.f16.f32(i32, float, half, half, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.d.2d.v4f32.f16.f32(i32, float, half, half, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.d.cl.1d.v4f32.f16.f32(i32, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.d.cl.2d.v4f32.f16.f32(i32, half, half, half, half, float, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.d.cl.1d.v4f32.f16.f32(i32, float, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.d.cl.2d.v4f32.f16.f32(i32, float, half, half, half, half, float, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1

declare <4 x float> @llvm.amdgcn.image.sample.cd.1d.v4f32.f16.f32(i32, half, half, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.cd.2d.v4f32.f16.f32(i32, half, half, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.cd.1d.v4f32.f16.f32(i32, float, half, half, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.cd.2d.v4f32.f16.f32(i32, float, half, half, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.cd.cl.1d.v4f32.f16.f32(i32, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.cd.cl.2d.v4f32.f16.f32(i32, half, half, half, half, float, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.cd.cl.1d.v4f32.f16.f32(i32, float, half, half, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <4 x float> @llvm.amdgcn.image.sample.c.cd.cl.2d.v4f32.f16.f32(i32, float, half, half, half, half, float, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1

declare float @llvm.amdgcn.image.sample.c.d.o.2darray.f16.f32.f32(i32, i32, float, half, half, half, half, float, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1
declare <2 x float> @llvm.amdgcn.image.sample.c.d.o.2darray.v2f32.f16.f32(i32, i32, float, half, half, half, half, float, float, float, <8 x i32>, <4 x i32>, i1, i32, i32) #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }
attributes #2 = { nounwind readnone }
