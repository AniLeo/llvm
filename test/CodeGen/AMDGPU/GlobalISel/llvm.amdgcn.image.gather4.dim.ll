; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tahiti -o - %s | FileCheck -check-prefix=GFX6 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -o - %s | FileCheck -check-prefix=GFX10NSA %s

define amdgpu_ps <4 x float> @gather4_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t) {
; GFX6-LABEL: gather4_2d:
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
; GFX6-NEXT:    image_gather4 v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4 v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.2d.v4f32.f32(i32 1, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_cube(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t, float %face) {
; GFX6-LABEL: gather4_cube:
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
; GFX6-NEXT:    image_gather4 v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 da
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_cube:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4 v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_CUBE
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.cube.v4f32.f32(i32 1, float %s, float %t, float %face, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_2darray(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t, float %slice) {
; GFX6-LABEL: gather4_2darray:
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
; GFX6-NEXT:    image_gather4 v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 da
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_2darray:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4 v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D_ARRAY
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.2darray.v4f32.f32(i32 1, float %s, float %t, float %slice, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, float %s, float %t) {
; GFX6-LABEL: gather4_c_2d:
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
; GFX6-NEXT:    image_gather4_c v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_c_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4_c v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.2d.v4f32.f32(i32 1, float %zcompare, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t, float %clamp) {
; GFX6-LABEL: gather4_cl_2d:
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
; GFX6-NEXT:    image_gather4_cl v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_cl_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4_cl v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.cl.2d.v4f32.f32(i32 1, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, float %s, float %t, float %clamp) {
; GFX6-LABEL: gather4_c_cl_2d:
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
; GFX6-NEXT:    image_gather4_c_cl v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_c_cl_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4_c_cl v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.cl.2d.v4f32.f32(i32 1, float %zcompare, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_b_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %bias, float %s, float %t) {
; GFX6-LABEL: gather4_b_2d:
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
; GFX6-NEXT:    image_gather4_b v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_b_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4_b v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.b.2d.v4f32.f32.f32(i32 1, float %bias, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_b_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %bias, float %zcompare, float %s, float %t) {
; GFX6-LABEL: gather4_c_b_2d:
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
; GFX6-NEXT:    image_gather4_c_b v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_c_b_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4_c_b v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.b.2d.v4f32.f32.f32(i32 1, float %bias, float %zcompare, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_b_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %bias, float %s, float %t, float %clamp) {
; GFX6-LABEL: gather4_b_cl_2d:
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
; GFX6-NEXT:    image_gather4_b_cl v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_b_cl_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4_b_cl v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.b.cl.2d.v4f32.f32.f32(i32 1, float %bias, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_b_cl_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %bias, float %zcompare, float %s, float %t, float %clamp) {
; GFX6-LABEL: gather4_c_b_cl_2d:
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
; GFX6-NEXT:    image_gather4_c_b_cl v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_c_b_cl_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4_c_b_cl v[0:3], v[0:7], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.b.cl.2d.v4f32.f32.f32(i32 1, float %bias, float %zcompare, float %s, float %t, float %clamp, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_l_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t, float %lod) {
; GFX6-LABEL: gather4_l_2d:
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
; GFX6-NEXT:    image_gather4_l v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_l_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    image_gather4_l v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.l.2d.v4f32.f32(i32 1, float %s, float %t, float %lod, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_l_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, float %s, float %t, float %lod) {
; GFX6-LABEL: gather4_c_l_2d:
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
; GFX6-NEXT:    image_gather4_c_l v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_c_l_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    image_gather4_c_l v[0:3], v[0:3], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.l.2d.v4f32.f32(i32 1, float %zcompare, float %s, float %t, float %lod, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_lz_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t) {
; GFX6-LABEL: gather4_lz_2d:
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
; GFX6-NEXT:    image_gather4_lz v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_lz_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    image_gather4_lz v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.lz.2d.v4f32.f32(i32 1, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_c_lz_2d(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %zcompare, float %s, float %t) {
; GFX6-LABEL: gather4_c_lz_2d:
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
; GFX6-NEXT:    image_gather4_c_lz v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_c_lz_2d:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    image_gather4_c_lz v[0:3], v[0:2], s[0:7], s[8:11] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.c.lz.2d.v4f32.f32(i32 1, float %zcompare, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_2d_dmask_2(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t) {
; GFX6-LABEL: gather4_2d_dmask_2:
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
; GFX6-NEXT:    image_gather4 v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x2
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_2d_dmask_2:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4 v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x2 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.2d.v4f32.f32(i32 2, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_2d_dmask_4(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t) {
; GFX6-LABEL: gather4_2d_dmask_4:
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
; GFX6-NEXT:    image_gather4 v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x4
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_2d_dmask_4:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4 v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x4 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.2d.v4f32.f32(i32 4, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @gather4_2d_dmask_8(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s, float %t) {
; GFX6-LABEL: gather4_2d_dmask_8:
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
; GFX6-NEXT:    image_gather4 v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x8
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX10NSA-LABEL: gather4_2d_dmask_8:
; GFX10NSA:       ; %bb.0: ; %main_body
; GFX10NSA-NEXT:    s_mov_b32 s0, s2
; GFX10NSA-NEXT:    s_mov_b32 s1, s3
; GFX10NSA-NEXT:    s_mov_b32 s2, s4
; GFX10NSA-NEXT:    s_mov_b32 s3, s5
; GFX10NSA-NEXT:    s_mov_b32 s4, s6
; GFX10NSA-NEXT:    s_mov_b32 s5, s7
; GFX10NSA-NEXT:    s_mov_b32 s6, s8
; GFX10NSA-NEXT:    s_mov_b32 s7, s9
; GFX10NSA-NEXT:    s_mov_b32 s8, s10
; GFX10NSA-NEXT:    s_mov_b32 s9, s11
; GFX10NSA-NEXT:    s_mov_b32 s14, exec_lo
; GFX10NSA-NEXT:    s_mov_b32 s10, s12
; GFX10NSA-NEXT:    s_mov_b32 s11, s13
; GFX10NSA-NEXT:    ; implicit-def: $vcc_hi
; GFX10NSA-NEXT:    s_wqm_b32 exec_lo, exec_lo
; GFX10NSA-NEXT:    s_and_b32 exec_lo, exec_lo, s14
; GFX10NSA-NEXT:    image_gather4 v[0:3], v[0:1], s[0:7], s[8:11] dmask:0x8 dim:SQ_RSRC_IMG_2D
; GFX10NSA-NEXT:    s_waitcnt vmcnt(0)
; GFX10NSA-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.gather4.2d.v4f32.f32(i32 8, float %s, float %t, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  ret <4 x float> %v
}

declare <4 x float> @llvm.amdgcn.image.gather4.2d.v4f32.f32(i32 immarg, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.cube.v4f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.2darray.v4f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.2d.v4f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.cl.2d.v4f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.cl.2d.v4f32.f32(i32 immarg, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.b.2d.v4f32.f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.b.2d.v4f32.f32.f32(i32 immarg, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.b.cl.2d.v4f32.f32.f32(i32 immarg, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.b.cl.2d.v4f32.f32.f32(i32 immarg, float, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.l.2d.v4f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.l.2d.v4f32.f32(i32 immarg, float, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.lz.2d.v4f32.f32(i32 immarg, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.image.gather4.c.lz.2d.v4f32.f32(i32 immarg, float, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
