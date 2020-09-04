; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tahiti -o - %s | FileCheck -check-prefix=GCN %s

define amdgpu_ps <4 x float> @sample_l_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %lod) {
; GCN-LABEL: sample_l_1d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_sample_lz v[0:3], v0, s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.l.1d.v4f32.f32(i32 15, float %s, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_l_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t, float %lod) {
; GCN-LABEL: sample_l_2d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_sample_lz v[0:3], v[0:1], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.l.2d.v4f32.f32(i32 15, float %s, float %t, float -0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_l_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, float %s, float %lod) {
; GCN-LABEL: sample_c_l_1d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_sample_c_lz v[0:3], v[0:1], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.l.1d.v4f32.f32(i32 15, float %zcompare, float %s, float -2.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_l_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, float %s, float %t, float %lod) {
; GCN-LABEL: sample_c_l_2d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_sample_c_lz v[0:3], v[0:2], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.l.2d.v4f32.f32(i32 15, float %zcompare, float %s, float %t, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_l_o_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %s, float %lod) {
; GCN-LABEL: sample_l_o_1d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_sample_lz_o v[0:3], v[0:1], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.l.o.1d.v4f32.f32(i32 15, i32 %offset, float %s, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_l_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %s, float %t, float %lod) {
; GCN-LABEL: sample_l_o_2d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_sample_lz_o v[0:3], v[0:2], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.l.o.2d.v4f32.f32(i32 15, i32 %offset, float %s, float %t, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_l_o_1d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %zcompare, float %s, float %lod) {
; GCN-LABEL: sample_c_l_o_1d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_sample_c_lz_o v[0:3], v[0:2], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.l.o.1d.v4f32.f32(i32 15, i32 %offset, float %zcompare, float %s, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @sample_c_l_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %zcompare, float %s, float %t, float %lod) {
; GCN-LABEL: sample_c_l_o_2d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_sample_c_lz_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.sample.c.l.o.2d.v4f32.f32(i32 15, i32 %offset, float %zcompare, float %s, float %t, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_l_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t, float %lod) {
; GCN-LABEL: gather4_l_2d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_gather4_lz v[0:3], v[0:1], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.l.2d.v4f32.f32(i32 15, float %s, float %t, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_l_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, float %s, float %t, float %lod) {
; GCN-LABEL: gather4_c_l_2d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_gather4_c_lz v[0:3], v[0:2], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.l.2d.v4f32.f32(i32 15, float %zcompare, float %s, float %t, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_l_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %s, float %t, float %lod) {
; GCN-LABEL: gather4_l_o_2d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_gather4_lz_o v[0:3], v[0:2], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.l.o.2d.v4f32.f32(i32 15, i32 %offset, float %s, float %t, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_l_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %zcompare, float %s, float %t, float %lod) {
; GCN-LABEL: gather4_c_l_o_2d:
; GCN:       ; %bb.0: ; %main_body
; GCN-NEXT:    s_mov_b32 s0, s2
; GCN-NEXT:    s_mov_b32 s1, s3
; GCN-NEXT:    s_mov_b32 s2, s4
; GCN-NEXT:    s_mov_b32 s3, s5
; GCN-NEXT:    s_mov_b32 s4, s6
; GCN-NEXT:    s_mov_b32 s5, s7
; GCN-NEXT:    s_mov_b32 s6, s8
; GCN-NEXT:    s_mov_b32 s7, s9
; GCN-NEXT:    s_mov_b32 s8, s10
; GCN-NEXT:    s_mov_b32 s9, s11
; GCN-NEXT:    s_mov_b32 s10, s12
; GCN-NEXT:    s_mov_b32 s11, s13
; GCN-NEXT:    image_gather4_c_lz_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0xf
; GCN-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.l.o.2d.v4f32.f32(i32 15, i32 %offset, float %zcompare, float %s, float %t, float 0.000000e+00, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

declare <4 x float> @llvm.amdgcn.image.sample.l.1d.v4f32.f32(i32 immarg, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.sample.l.2d.v4f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.sample.c.l.1d.v4f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.sample.c.l.2d.v4f32.f32(i32 immarg, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.sample.l.o.1d.v4f32.f32(i32 immarg, i32, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.sample.l.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.sample.c.l.o.1d.v4f32.f32(i32 immarg, i32, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.sample.c.l.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.l.2d.v4f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.l.2d.v4f32.f32(i32 immarg, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.l.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.l.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
