; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_ps <4 x float> @load_2darraymsaa_v4f32_xyzw(<8 x i32> inreg %rsrc, i16 %s, i16 %t, i16 %slice, i16 %fragid) {
; GFX9-LABEL: load_2darraymsaa_v4f32_xyzw:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NEXT:    v_and_or_b32 v0, v0, v4, v1
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 16, v3
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    v_and_or_b32 v1, v2, v4, v1
; GFX9-NEXT:    image_load v[0:3], v[0:1], s[0:7] dmask:0xf unorm a16 da
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: load_2darraymsaa_v4f32_xyzw:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    v_and_or_b32 v0, v0, v4, v1
; GFX10-NEXT:    v_and_or_b32 v1, v2, v4, v3
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    image_load v[0:3], v[0:1], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA_ARRAY unorm a16
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    ; return to shader part epilog
  %v = call <4 x float> @llvm.amdgcn.image.load.2darraymsaa.v4f32.i16(i32 15, i16 %s, i16 %t, i16 %slice, i16 %fragid, <8 x i32> %rsrc, i32 0, i32 0)
  ret <4 x float> %v
}

define amdgpu_ps <4 x float> @load_2darraymsaa_v4f32_xyzw_tfe(<8 x i32> inreg %rsrc, i32 addrspace(1)* inreg %out, i16 %s, i16 %t, i16 %slice, i16 %fragid) {
; GFX9-LABEL: load_2darraymsaa_v4f32_xyzw_tfe:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NEXT:    v_and_or_b32 v0, v0, v4, v1
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 16, v3
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    v_and_or_b32 v1, v2, v4, v1
; GFX9-NEXT:    image_load v[0:4], v[0:1], s[0:7] dmask:0xf unorm a16 tfe da
; GFX9-NEXT:    v_mov_b32_e32 v5, 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    global_store_dword v5, v4, s[10:11]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: load_2darraymsaa_v4f32_xyzw_tfe:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    v_and_or_b32 v0, v0, v4, v1
; GFX10-NEXT:    v_and_or_b32 v1, v2, v4, v3
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    v_mov_b32_e32 v5, 0
; GFX10-NEXT:    image_load v[0:4], v[0:1], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA_ARRAY unorm a16 tfe
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    global_store_dword v5, v4, s[10:11]
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    ; return to shader part epilog
  %v = call { <4 x float>, i32 } @llvm.amdgcn.image.load.2darraymsaa.sl_v4f32i32s.i16(i32 15, i16 %s, i16 %t, i16 %slice, i16 %fragid, <8 x i32> %rsrc, i32 1, i32 0)
  %v.vec = extractvalue { <4 x float>, i32 } %v, 0
  %v.err = extractvalue { <4 x float>, i32 } %v, 1
  store i32 %v.err, i32 addrspace(1)* %out, align 4
  ret <4 x float> %v.vec
}

define amdgpu_ps <4 x float> @load_2darraymsaa_v4f32_xyzw_tfe_lwe(<8 x i32> inreg %rsrc, i32 addrspace(1)* inreg %out, i16 %s, i16 %t, i16 %slice, i16 %fragid) {
; GFX9-LABEL: load_2darraymsaa_v4f32_xyzw_tfe_lwe:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX9-NEXT:    v_and_or_b32 v0, v0, v4, v1
; GFX9-NEXT:    v_lshlrev_b32_e32 v1, 16, v3
; GFX9-NEXT:    s_mov_b32 s0, s2
; GFX9-NEXT:    s_mov_b32 s1, s3
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    s_mov_b32 s4, s6
; GFX9-NEXT:    s_mov_b32 s5, s7
; GFX9-NEXT:    s_mov_b32 s6, s8
; GFX9-NEXT:    s_mov_b32 s7, s9
; GFX9-NEXT:    v_and_or_b32 v1, v2, v4, v1
; GFX9-NEXT:    image_load v[0:4], v[0:1], s[0:7] dmask:0xf unorm a16 tfe lwe da
; GFX9-NEXT:    v_mov_b32_e32 v5, 0
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    global_store_dword v5, v4, s[10:11]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: load_2darraymsaa_v4f32_xyzw_tfe_lwe:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX10-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX10-NEXT:    v_lshlrev_b32_e32 v3, 16, v3
; GFX10-NEXT:    s_mov_b32 s0, s2
; GFX10-NEXT:    s_mov_b32 s1, s3
; GFX10-NEXT:    s_mov_b32 s2, s4
; GFX10-NEXT:    v_and_or_b32 v0, v0, v4, v1
; GFX10-NEXT:    v_and_or_b32 v1, v2, v4, v3
; GFX10-NEXT:    s_mov_b32 s3, s5
; GFX10-NEXT:    s_mov_b32 s4, s6
; GFX10-NEXT:    s_mov_b32 s5, s7
; GFX10-NEXT:    s_mov_b32 s6, s8
; GFX10-NEXT:    s_mov_b32 s7, s9
; GFX10-NEXT:    v_mov_b32_e32 v5, 0
; GFX10-NEXT:    image_load v[0:4], v[0:1], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D_MSAA_ARRAY unorm a16 tfe lwe
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    global_store_dword v5, v4, s[10:11]
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    ; return to shader part epilog
  %v = call { <4 x float>, i32 } @llvm.amdgcn.image.load.2darraymsaa.sl_v4f32i32s.i16(i32 15, i16 %s, i16 %t, i16 %slice, i16 %fragid, <8 x i32> %rsrc, i32 3, i32 0)
  %v.vec = extractvalue { <4 x float>, i32 } %v, 0
  %v.err = extractvalue { <4 x float>, i32 } %v, 1
  store i32 %v.err, i32 addrspace(1)* %out, align 4
  ret <4 x float> %v.vec
}

declare <4 x float> @llvm.amdgcn.image.load.2darraymsaa.v4f32.i16(i32 immarg, i16, i16, i16, i16, <8 x i32>, i32 immarg, i32 immarg) #0
declare { <4 x float>, i32 } @llvm.amdgcn.image.load.2darraymsaa.sl_v4f32i32s.i16(i32 immarg, i16, i16, i16, i16, <8 x i32>, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
