; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tahiti -verify-machineinstrs < %s | FileCheck -check-prefix=GFX6 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -verify-machineinstrs < %s | FileCheck -check-prefix=GFX8 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_ps <4 x float> @getresinfo_1d(<8 x i32> inreg %rsrc, i32 %mip) {
; GFX6-LABEL: getresinfo_1d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_1d:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.getresinfo.1d.v4f32.i32(i32 15, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @getresinfo_2d(<8 x i32> inreg %rsrc, i32 %mip) {
; GFX6-LABEL: getresinfo_2d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_2d:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.getresinfo.2d.v4f32.i32(i32 15, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @getresinfo_3d(<8 x i32> inreg %rsrc, i32 %mip) {
; GFX6-LABEL: getresinfo_3d:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_3d:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_3d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_3D unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.getresinfo.3d.v4f32.i32(i32 15, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @getresinfo_cube(<8 x i32> inreg %rsrc, i32 %mip) {
; GFX6-LABEL: getresinfo_cube:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm da
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_cube:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm da
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_cube:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_CUBE unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.getresinfo.cube.v4f32.i32(i32 15, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @getresinfo_1darray(<8 x i32> inreg %rsrc, i32 %mip) {
; GFX6-LABEL: getresinfo_1darray:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm da
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_1darray:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm da
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_1darray:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D_ARRAY unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.getresinfo.1darray.v4f32.i32(i32 15, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @getresinfo_2darray(<8 x i32> inreg %rsrc, i32 %mip) {
; GFX6-LABEL: getresinfo_2darray:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm da
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_2darray:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm da
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_2darray:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D_ARRAY unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.getresinfo.2darray.v4f32.i32(i32 15, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @getresinfo_2dmsaa(<8 x i32> inreg %rsrc, i32 %mip) {
; GFX6-LABEL: getresinfo_2dmsaa:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_2dmsaa:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_2dmsaa:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.getresinfo.2dmsaa.v4f32.i32(i32 15, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @getresinfo_2darraymsaa(<8 x i32> inreg %rsrc, i32 %mip) {
; GFX6-LABEL: getresinfo_2darraymsaa:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm da
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_2darraymsaa:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf unorm da
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_2darraymsaa:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:3], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA_ARRAY unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %v = call <4 x float> @llvm.amdgcn.image.getresinfo.2darraymsaa.v4f32.i32(i32 15, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <3 x float> @getresinfo_dmask7(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %mip) {
; GFX6-LABEL: getresinfo_dmask7:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:2], v0, s[0:7] dmask:0x7 unorm
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_dmask7:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:2], v0, s[0:7] dmask:0x7 unorm
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_dmask7:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:2], v0, s[0:7] dmask:0x7 dim:SQ_RSRC_IMG_1D unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %r = call <3 x float> @llvm.amdgcn.image.getresinfo.1d.v3f32.i32(i32 7, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <3 x float> %r
}

define amdgpu_ps <2 x float> @getresinfo_dmask3(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %mip) {
; GFX6-LABEL: getresinfo_dmask3:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v[0:1], v0, s[0:7] dmask:0x3 unorm
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_dmask3:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v[0:1], v0, s[0:7] dmask:0x3 unorm
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_dmask3:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v[0:1], v0, s[0:7] dmask:0x3 dim:SQ_RSRC_IMG_1D unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %r = call <2 x float> @llvm.amdgcn.image.getresinfo.1d.v2f32.i32(i32 3, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <2 x float> %r
}

define amdgpu_ps float @getresinfo_dmask1(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %mip) {
; GFX6-LABEL: getresinfo_dmask1:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    s_mov_b32 s0, s2
; GFX6-NEXT:    s_mov_b32 s1, s3
; GFX6-NEXT:    s_mov_b32 s2, s4
; GFX6-NEXT:    s_mov_b32 s3, s5
; GFX6-NEXT:    s_mov_b32 s4, s6
; GFX6-NEXT:    s_mov_b32 s5, s7
; GFX6-NEXT:    s_mov_b32 s6, s8
; GFX6-NEXT:    s_mov_b32 s7, s9
; GFX6-NEXT:    image_get_resinfo v0, v0, s[0:7] dmask:0x1 unorm
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_dmask1:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    s_mov_b32 s0, s2
; GFX8-NEXT:    s_mov_b32 s1, s3
; GFX8-NEXT:    s_mov_b32 s2, s4
; GFX8-NEXT:    s_mov_b32 s3, s5
; GFX8-NEXT:    s_mov_b32 s4, s6
; GFX8-NEXT:    s_mov_b32 s5, s7
; GFX8-NEXT:    s_mov_b32 s6, s8
; GFX8-NEXT:    s_mov_b32 s7, s9
; GFX8-NEXT:    image_get_resinfo v0, v0, s[0:7] dmask:0x1 unorm
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_dmask1:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_get_resinfo v0, v0, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D unorm
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %r = call float @llvm.amdgcn.image.getresinfo.1d.f32.i32(i32 1, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret float %r
}

define amdgpu_ps <4 x float> @getresinfo_dmask0(<8 x i32> inreg %rsrc, <4 x float> %vdata, i32 %mip) {
; GFX6-LABEL: getresinfo_dmask0:
; GFX6:       ; %bb.0: ; %main_body
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: getresinfo_dmask0:
; GFX8:       ; %bb.0: ; %main_body
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: getresinfo_dmask0:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; return to shader part epilog
main_body:
  %r = call <4 x float> @llvm.amdgcn.image.getresinfo.1d.v4f32.i32(i32 0, i32 %mip, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %r
}

declare <4 x float> @llvm.amdgcn.image.getresinfo.1d.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare <3 x float> @llvm.amdgcn.image.getresinfo.1d.v3f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare <2 x float> @llvm.amdgcn.image.getresinfo.1d.v2f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare float @llvm.amdgcn.image.getresinfo.1d.f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare <4 x float> @llvm.amdgcn.image.getresinfo.2d.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare <4 x float> @llvm.amdgcn.image.getresinfo.3d.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare <4 x float> @llvm.amdgcn.image.getresinfo.cube.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare <4 x float> @llvm.amdgcn.image.getresinfo.1darray.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare <4 x float> @llvm.amdgcn.image.getresinfo.2darray.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare <4 x float> @llvm.amdgcn.image.getresinfo.2dmsaa.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1
declare <4 x float> @llvm.amdgcn.image.getresinfo.2darraymsaa.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
