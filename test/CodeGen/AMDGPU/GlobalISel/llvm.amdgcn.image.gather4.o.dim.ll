; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tahiti -o - %s | FileCheck -check-prefix=GFX6 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -o - %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_ps <4 x float> @gather4_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %s, float %t) {
; GFX6-LABEL: gather4_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b64 s[14:15], exec
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    s_wqm_b64 exec, exec
; GFX6-NEXT:    s_and_b64 exec, exec, s[14:15]
; GFX6-NEXT:    image_gather4_o v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s1, exec_lo
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10-NEXT:    s_and_b32 exec_lo, exec_lo, s1
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_o v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.o.2d.v4f32.f32(i32 1, i32 %offset, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %zcompare, float %s, float %t) {
; GFX6-LABEL: gather4_c_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b64 s[14:15], exec
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    s_wqm_b64 exec, exec
; GFX6-NEXT:    s_and_b64 exec, exec, s[14:15]
; GFX6-NEXT:    image_gather4_c_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_c_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s1, exec_lo
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10-NEXT:    s_and_b32 exec_lo, exec_lo, s1
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_c_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.o.2d.v4f32.f32(i32 1, i32 %offset, float %zcompare, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_cl_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %s, float %t, float %clamp) {
; GFX6-LABEL: gather4_cl_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b64 s[14:15], exec
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    s_wqm_b64 exec, exec
; GFX6-NEXT:    s_and_b64 exec, exec, s[14:15]
; GFX6-NEXT:    image_gather4_cl_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_cl_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s1, exec_lo
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10-NEXT:    s_and_b32 exec_lo, exec_lo, s1
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_cl_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.cl.o.2d.v4f32.f32(i32 1, i32 %offset, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_cl_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %zcompare, float %s, float %t, float %clamp) {
; GFX6-LABEL: gather4_c_cl_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b64 s[14:15], exec
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    s_wqm_b64 exec, exec
; GFX6-NEXT:    s_and_b64 exec, exec, s[14:15]
; GFX6-NEXT:    image_gather4_c_cl_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_c_cl_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s1, exec_lo
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10-NEXT:    s_and_b32 exec_lo, exec_lo, s1
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_c_cl_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.cl.o.2d.v4f32.f32(i32 1, i32 %offset, float %zcompare, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_b_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %bias, float %s, float %t) {
; GFX6-LABEL: gather4_b_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b64 s[14:15], exec
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    s_wqm_b64 exec, exec
; GFX6-NEXT:    s_and_b64 exec, exec, s[14:15]
; GFX6-NEXT:    image_gather4_b_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_b_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s1, exec_lo
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10-NEXT:    s_and_b32 exec_lo, exec_lo, s1
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_b_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.b.o.2d.v4f32.f32.f32(i32 1, i32 %offset, float %bias, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_b_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %bias, float %zcompare, float %s, float %t) {
; GFX6-LABEL: gather4_c_b_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b64 s[14:15], exec
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    s_wqm_b64 exec, exec
; GFX6-NEXT:    s_and_b64 exec, exec, s[14:15]
; GFX6-NEXT:    image_gather4_c_b_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_c_b_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s1, exec_lo
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10-NEXT:    s_and_b32 exec_lo, exec_lo, s1
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_c_b_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.b.o.2d.v4f32.f32.f32(i32 1, i32 %offset, float %bias, float %zcompare, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_b_cl_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %bias, float %s, float %t, float %clamp) {
; GFX6-LABEL: gather4_b_cl_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    image_gather4_b_cl_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_b_cl_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_b_cl_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.b.cl.o.2d.v4f32.f32.f32(i32 1, i32 %offset, float %bias, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_b_cl_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %bias, float %zcompare, float %s, float %t, float %clamp) {
; GFX6-LABEL: gather4_c_b_cl_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b64 s[14:15], exec
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    s_wqm_b64 exec, exec
; GFX6-NEXT:    s_and_b64 exec, exec, s[14:15]
; GFX6-NEXT:    image_gather4_c_b_cl_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_c_b_cl_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s1, exec_lo
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10-NEXT:    s_and_b32 exec_lo, exec_lo, s1
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_c_b_cl_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.b.cl.o.2d.v4f32.f32.f32(i32 1, i32 %offset, float %bias, float %zcompare, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_l_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %s, float %t, float %lod) {
; GFX6-LABEL: gather4_l_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    image_gather4_l_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_l_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_l_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.l.o.2d.v4f32.f32(i32 1, i32 %offset, float %s, float %t, float %lod, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_l_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %zcompare, float %s, float %t, float %lod) {
; GFX6-LABEL: gather4_c_l_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    image_gather4_c_l_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_c_l_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_c_l_o v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.l.o.2d.v4f32.f32(i32 1, i32 %offset, float %zcompare, float %s, float %t, float %lod, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_lz_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %s, float %t) {
; GFX6-LABEL: gather4_lz_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    image_gather4_lz_o v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_lz_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_lz_o v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.lz.o.2d.v4f32.f32(i32 1, i32 %offset, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_lz_o_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, i32 %offset, float %zcompare, float %s, float %t) {
; GFX6-LABEL: gather4_c_lz_o_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    s_mov_b32 s8, s10
; GFX6-NEXT:    s_mov_b32 s9, s11
; GFX6-NEXT:    s_mov_b32 s10, s12
; GFX6-NEXT:    s_mov_b32 s11, s13
; GFX6-NEXT:    image_gather4_c_lz_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: gather4_c_lz_o_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    s_mov_b32 s8, s10
; GFX10-NEXT:    s_mov_b32 s9, s11
; GFX10-NEXT:    s_mov_b32 s10, s12
; GFX10-NEXT:    s_mov_b32 s11, s13
; GFX10-NEXT:    image_gather4_c_lz_o v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.lz.o.2d.v4f32.f32(i32 1, i32 %offset, float %zcompare, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

declare <4 x float> @llvm.amdgcn.image.gather4.o.2d.v4f32.f32(i32 immarg, i32, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.cl.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.cl.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.b.o.2d.v4f32.f32.f32(i32 immarg, i32, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.b.o.2d.v4f32.f32.f32(i32 immarg, i32, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.b.cl.o.2d.v4f32.f32.f32(i32 immarg, i32, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.b.cl.o.2d.v4f32.f32.f32(i32 immarg, i32, float, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.l.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.l.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.lz.o.2d.v4f32.f32(i32 immarg, i32, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.lz.o.2d.v4f32.f32(i32 immarg, i32, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
