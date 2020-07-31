; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tahiti < %s | FileCheck -check-prefixes=GCN,GFX6 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 < %s | FileCheck -check-prefixes=GCN,GFX9 %s

define amdgpu_ps i32 @s_andn2_i32(i32 inreg %src0, i32 inreg %src1) {
; GCN-LABEL: s_andn2_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_andn2_b32 s0, s2, s3
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i32 %src1, -1
  %and = and i32 %src0, %not.src1
  ret i32 %and
}

define amdgpu_ps i32 @s_andn2_i32_commute(i32 inreg %src0, i32 inreg %src1) {
; GCN-LABEL: s_andn2_i32_commute:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_andn2_b32 s0, s2, s3
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i32 %src1, -1
  %and = and i32 %not.src1, %src0
  ret i32 %and
}

define amdgpu_ps { i32, i32 } @s_andn2_i32_multi_use(i32 inreg %src0, i32 inreg %src1) {
; GCN-LABEL: s_andn2_i32_multi_use:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_not_b32 s1, s3
; GCN-NEXT:    s_andn2_b32 s0, s2, s3
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i32 %src1, -1
  %and = and i32 %src0, %not.src1
  %insert.0 = insertvalue { i32, i32 } undef, i32 %and, 0
  %insert.1 = insertvalue { i32, i32 } %insert.0, i32 %not.src1, 1
  ret { i32, i32 } %insert.1
}

define amdgpu_ps { i32, i32 } @s_andn2_i32_multi_foldable_use(i32 inreg %src0, i32 inreg %src1, i32 inreg %src2) {
; GCN-LABEL: s_andn2_i32_multi_foldable_use:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_andn2_b32 s0, s2, s4
; GCN-NEXT:    s_andn2_b32 s1, s3, s4
; GCN-NEXT:    ; return to shader part epilog
  %not.src2 = xor i32 %src2, -1
  %and0 = and i32 %src0, %not.src2
  %and1 = and i32 %src1, %not.src2
  %insert.0 = insertvalue { i32, i32 } undef, i32 %and0, 0
  %insert.1 = insertvalue { i32, i32 } %insert.0, i32 %and1, 1
  ret { i32, i32 } %insert.1
}

define i32 @v_andn2_i32(i32 %src0, i32 %src1) {
; GCN-LABEL: v_andn2_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_xor_b32_e32 v1, -1, v1
; GCN-NEXT:    v_and_b32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %not.src1 = xor i32 %src1, -1
  %and = and i32 %src0, %not.src1
  ret i32 %and
}

define amdgpu_ps float @v_andn2_i32_sv(i32 inreg %src0, i32 %src1) {
; GCN-LABEL: v_andn2_i32_sv:
; GCN:       ; %bb.0:
; GCN-NEXT:    v_xor_b32_e32 v0, -1, v0
; GCN-NEXT:    v_and_b32_e32 v0, s2, v0
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i32 %src1, -1
  %and = and i32 %src0, %not.src1
  %cast = bitcast i32 %and to float
  ret float %cast
}

define amdgpu_ps float @v_andn2_i32_vs(i32 %src0, i32 inreg %src1) {
; GCN-LABEL: v_andn2_i32_vs:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_not_b32 s0, s2
; GCN-NEXT:    v_and_b32_e32 v0, s0, v0
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i32 %src1, -1
  %and = and i32 %src0, %not.src1
  %cast = bitcast i32 %and to float
  ret float %cast
}

define amdgpu_ps i64 @s_andn2_i64(i64 inreg %src0, i64 inreg %src1) {
; GCN-LABEL: s_andn2_i64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_andn2_b64 s[0:1], s[2:3], s[4:5]
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i64 %src1, -1
  %and = and i64 %src0, %not.src1
  ret i64 %and
}

define amdgpu_ps i64 @s_andn2_i64_commute(i64 inreg %src0, i64 inreg %src1) {
; GCN-LABEL: s_andn2_i64_commute:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_andn2_b64 s[0:1], s[2:3], s[4:5]
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i64 %src1, -1
  %and = and i64 %not.src1, %src0
  ret i64 %and
}

define amdgpu_ps { i64, i64 } @s_andn2_i64_multi_foldable_use(i64 inreg %src0, i64 inreg %src1, i64 inreg %src2) {
; GCN-LABEL: s_andn2_i64_multi_foldable_use:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_andn2_b64 s[0:1], s[2:3], s[6:7]
; GCN-NEXT:    s_andn2_b64 s[2:3], s[4:5], s[6:7]
; GCN-NEXT:    ; return to shader part epilog
  %not.src2 = xor i64 %src2, -1
  %and0 = and i64 %src0, %not.src2
  %and1 = and i64 %src1, %not.src2
  %insert.0 = insertvalue { i64, i64 } undef, i64 %and0, 0
  %insert.1 = insertvalue { i64, i64 } %insert.0, i64 %and1, 1
  ret { i64, i64 } %insert.1
}

define amdgpu_ps { i64, i64 } @s_andn2_i64_multi_use(i64 inreg %src0, i64 inreg %src1) {
; GCN-LABEL: s_andn2_i64_multi_use:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_not_b64 s[6:7], s[4:5]
; GCN-NEXT:    s_andn2_b64 s[0:1], s[2:3], s[4:5]
; GCN-NEXT:    s_mov_b32 s2, s6
; GCN-NEXT:    s_mov_b32 s3, s7
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i64 %src1, -1
  %and = and i64 %src0, %not.src1
  %insert.0 = insertvalue { i64, i64 } undef, i64 %and, 0
  %insert.1 = insertvalue { i64, i64 } %insert.0, i64 %not.src1, 1
  ret { i64, i64 } %insert.1
}

define i64 @v_andn2_i64(i64 %src0, i64 %src1) {
; GCN-LABEL: v_andn2_i64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_xor_b32_e32 v2, -1, v2
; GCN-NEXT:    v_xor_b32_e32 v3, -1, v3
; GCN-NEXT:    v_and_b32_e32 v0, v0, v2
; GCN-NEXT:    v_and_b32_e32 v1, v1, v3
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %not.src1 = xor i64 %src1, -1
  %and = and i64 %src0, %not.src1
  ret i64 %and
}

define amdgpu_ps <2 x float> @v_andn2_i64_sv(i64 inreg %src0, i64 %src1) {
; GCN-LABEL: v_andn2_i64_sv:
; GCN:       ; %bb.0:
; GCN-NEXT:    v_xor_b32_e32 v0, -1, v0
; GCN-NEXT:    v_xor_b32_e32 v1, -1, v1
; GCN-NEXT:    v_and_b32_e32 v0, s2, v0
; GCN-NEXT:    v_and_b32_e32 v1, s3, v1
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i64 %src1, -1
  %and = and i64 %src0, %not.src1
  %cast = bitcast i64 %and to <2 x float>
  ret <2 x float> %cast
}

define amdgpu_ps <2 x float> @v_andn2_i64_vs(i64 %src0, i64 inreg %src1) {
; GCN-LABEL: v_andn2_i64_vs:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_not_b64 s[0:1], s[2:3]
; GCN-NEXT:    v_and_b32_e32 v0, s0, v0
; GCN-NEXT:    v_and_b32_e32 v1, s1, v1
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i64 %src1, -1
  %and = and i64 %src0, %not.src1
  %cast = bitcast i64 %and to <2 x float>
  ret <2 x float> %cast
}

define amdgpu_ps <2 x i32> @s_andn2_v2i32(<2 x i32> inreg %src0, <2 x i32> inreg %src1) {
; GCN-LABEL: s_andn2_v2i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s0, -1
; GCN-NEXT:    s_mov_b32 s1, s0
; GCN-NEXT:    s_xor_b64 s[0:1], s[4:5], s[0:1]
; GCN-NEXT:    s_and_b64 s[0:1], s[2:3], s[0:1]
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor <2 x i32> %src1, <i32 -1, i32 -1>
  %and = and <2 x i32> %src0, %not.src1
  ret <2 x i32> %and
}

define amdgpu_ps <2 x i32> @s_andn2_v2i32_commute(<2 x i32> inreg %src0, <2 x i32> inreg %src1) {
; GCN-LABEL: s_andn2_v2i32_commute:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_mov_b32 s0, -1
; GCN-NEXT:    s_mov_b32 s1, s0
; GCN-NEXT:    s_xor_b64 s[0:1], s[4:5], s[0:1]
; GCN-NEXT:    s_and_b64 s[0:1], s[0:1], s[2:3]
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor <2 x i32> %src1, <i32 -1, i32 -1>
  %and = and <2 x i32> %not.src1, %src0
  ret <2 x i32> %and
}

define amdgpu_ps i16 @s_andn2_i16(i16 inreg %src0, i16 inreg %src1) {
; GFX6-LABEL: s_andn2_i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_andn2_b32 s0, s2, s3
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s0, 0xffff
; GFX9-NEXT:    s_and_b32 s1, s3, s0
; GFX9-NEXT:    s_xor_b32 s0, s1, s0
; GFX9-NEXT:    s_and_b32 s0, s2, s0
; GFX9-NEXT:    s_bfe_u32 s0, s0, 0x100000
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor i16 %src1, -1
  %and = and i16 %src0, %not.src1
  ret i16 %and
}

define amdgpu_ps i16 @s_andn2_i16_commute(i16 inreg %src0, i16 inreg %src1) {
; GFX6-LABEL: s_andn2_i16_commute:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_andn2_b32 s0, s2, s3
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_i16_commute:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s0, 0xffff
; GFX9-NEXT:    s_and_b32 s1, s3, s0
; GFX9-NEXT:    s_xor_b32 s0, s1, s0
; GFX9-NEXT:    s_and_b32 s0, s0, s2
; GFX9-NEXT:    s_bfe_u32 s0, s0, 0x100000
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor i16 %src1, -1
  %and = and i16 %not.src1, %src0
  ret i16 %and
}

define amdgpu_ps { i16, i16 } @s_andn2_i16_multi_use(i16 inreg %src0, i16 inreg %src1) {
; GFX6-LABEL: s_andn2_i16_multi_use:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_xor_b32 s1, s3, -1
; GFX6-NEXT:    s_andn2_b32 s0, s2, s3
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_i16_multi_use:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s0, 0xffff
; GFX9-NEXT:    s_and_b32 s1, s3, s0
; GFX9-NEXT:    s_xor_b32 s1, s1, s0
; GFX9-NEXT:    s_and_b32 s0, s2, s1
; GFX9-NEXT:    s_bfe_u32 s0, s0, 0x100000
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor i16 %src1, -1
  %and = and i16 %src0, %not.src1
  %insert.0 = insertvalue { i16, i16 } undef, i16 %and, 0
  %insert.1 = insertvalue { i16, i16 } %insert.0, i16 %not.src1, 1
  ret { i16, i16 } %insert.1
}

define amdgpu_ps { i16, i16 } @s_andn2_i16_multi_foldable_use(i16 inreg %src0, i16 inreg %src1, i16 inreg %src2) {
; GFX6-LABEL: s_andn2_i16_multi_foldable_use:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_andn2_b32 s0, s2, s4
; GFX6-NEXT:    s_andn2_b32 s1, s3, s4
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_i16_multi_foldable_use:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s1, 0xffff
; GFX9-NEXT:    s_and_b32 s0, s4, s1
; GFX9-NEXT:    s_xor_b32 s0, s0, s1
; GFX9-NEXT:    s_and_b32 s2, s2, s1
; GFX9-NEXT:    s_and_b32 s4, s0, s1
; GFX9-NEXT:    s_and_b32 s1, s3, s1
; GFX9-NEXT:    s_and_b32 s0, s2, s4
; GFX9-NEXT:    s_and_b32 s1, s1, s4
; GFX9-NEXT:    ; return to shader part epilog
  %not.src2 = xor i16 %src2, -1
  %and0 = and i16 %src0, %not.src2
  %and1 = and i16 %src1, %not.src2
  %insert.0 = insertvalue { i16, i16 } undef, i16 %and0, 0
  %insert.1 = insertvalue { i16, i16 } %insert.0, i16 %and1, 1
  ret { i16, i16 } %insert.1
}

define i16 @v_andn2_i16(i16 %src0, i16 %src1) {
; GCN-LABEL: v_andn2_i16:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_xor_b32_e32 v1, -1, v1
; GCN-NEXT:    v_and_b32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
  %not.src1 = xor i16 %src1, -1
  %and = and i16 %src0, %not.src1
  ret i16 %and
}

define amdgpu_ps float @v_andn2_i16_sv(i16 inreg %src0, i16 %src1) {
; GCN-LABEL: v_andn2_i16_sv:
; GCN:       ; %bb.0:
; GCN-NEXT:    v_xor_b32_e32 v0, -1, v0
; GCN-NEXT:    v_and_b32_e32 v0, s2, v0
; GCN-NEXT:    v_bfe_u32 v0, v0, 0, 16
; GCN-NEXT:    ; return to shader part epilog
  %not.src1 = xor i16 %src1, -1
  %and = and i16 %src0, %not.src1
  %zext = zext i16 %and to i32
  %cast.zext = bitcast i32 %zext to float
  ret float %cast.zext
}

define amdgpu_ps float @v_andn2_i16_vs(i16 %src0, i16 inreg %src1) {
; GFX6-LABEL: v_andn2_i16_vs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_xor_b32 s0, s2, -1
; GFX6-NEXT:    v_and_b32_e32 v0, s0, v0
; GFX6-NEXT:    v_bfe_u32 v0, v0, 0, 16
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: v_andn2_i16_vs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s0, 0xffff
; GFX9-NEXT:    s_and_b32 s1, s2, s0
; GFX9-NEXT:    s_xor_b32 s0, s1, s0
; GFX9-NEXT:    v_and_b32_e32 v0, s0, v0
; GFX9-NEXT:    v_bfe_u32 v0, v0, 0, 16
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor i16 %src1, -1
  %and = and i16 %src0, %not.src1
  %zext = zext i16 %and to i32
  %cast.zext = bitcast i32 %zext to float
  ret float %cast.zext
}

define amdgpu_ps i32 @s_andn2_v2i16(<2 x i16> inreg %src0, <2 x i16> inreg %src1) {
; GFX6-LABEL: s_andn2_v2i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s1, 0xffff
; GFX6-NEXT:    s_and_b32 s2, s2, s1
; GFX6-NEXT:    s_lshl_b32 s0, s3, 16
; GFX6-NEXT:    s_or_b32 s0, s0, s2
; GFX6-NEXT:    s_lshl_b32 s2, s5, 16
; GFX6-NEXT:    s_and_b32 s1, s4, s1
; GFX6-NEXT:    s_or_b32 s1, s2, s1
; GFX6-NEXT:    s_xor_b32 s1, s1, -1
; GFX6-NEXT:    s_and_b32 s0, s0, s1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_v2i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_xor_b32 s0, s3, -1
; GFX9-NEXT:    s_and_b32 s0, s2, s0
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor <2 x i16> %src1, <i16 -1, i16 -1>
  %and = and <2 x i16> %src0, %not.src1
  %cast = bitcast <2 x i16> %and to i32
  ret i32 %cast
}

define amdgpu_ps i32 @s_andn2_v2i16_commute(<2 x i16> inreg %src0, <2 x i16> inreg %src1) {
; GFX6-LABEL: s_andn2_v2i16_commute:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s1, 0xffff
; GFX6-NEXT:    s_and_b32 s2, s2, s1
; GFX6-NEXT:    s_lshl_b32 s0, s3, 16
; GFX6-NEXT:    s_or_b32 s0, s0, s2
; GFX6-NEXT:    s_lshl_b32 s2, s5, 16
; GFX6-NEXT:    s_and_b32 s1, s4, s1
; GFX6-NEXT:    s_or_b32 s1, s2, s1
; GFX6-NEXT:    s_xor_b32 s1, s1, -1
; GFX6-NEXT:    s_and_b32 s0, s1, s0
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_v2i16_commute:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_xor_b32 s0, s3, -1
; GFX9-NEXT:    s_and_b32 s0, s0, s2
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor <2 x i16> %src1, <i16 -1, i16 -1>
  %and = and <2 x i16> %not.src1, %src0
  %cast = bitcast <2 x i16> %and to i32
  ret i32 %cast
}

define amdgpu_ps { i32, i32 } @s_andn2_v2i16_multi_use(<2 x i16> inreg %src0, <2 x i16> inreg %src1) {
; GFX6-LABEL: s_andn2_v2i16_multi_use:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s1, 0xffff
; GFX6-NEXT:    s_and_b32 s2, s2, s1
; GFX6-NEXT:    s_lshl_b32 s0, s3, 16
; GFX6-NEXT:    s_or_b32 s0, s0, s2
; GFX6-NEXT:    s_lshl_b32 s2, s5, 16
; GFX6-NEXT:    s_and_b32 s1, s4, s1
; GFX6-NEXT:    s_or_b32 s1, s2, s1
; GFX6-NEXT:    s_xor_b32 s1, s1, -1
; GFX6-NEXT:    s_and_b32 s0, s0, s1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_v2i16_multi_use:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_xor_b32 s1, s3, -1
; GFX9-NEXT:    s_and_b32 s0, s2, s1
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor <2 x i16> %src1, <i16 -1, i16 -1>
  %and = and <2 x i16> %src0, %not.src1

  %cast.0 = bitcast <2 x i16> %and to i32
  %cast.1 = bitcast <2 x i16> %not.src1 to i32
  %insert.0 = insertvalue { i32, i32 } undef, i32 %cast.0, 0
  %insert.1 = insertvalue { i32, i32 } %insert.0, i32 %cast.1, 1
  ret { i32, i32 } %insert.1
}

define amdgpu_ps { i32, i32 } @s_andn2_v2i16_multi_foldable_use(<2 x i16> inreg %src0, <2 x i16> inreg %src1, <2 x i16> inreg %src2) {
; GFX6-LABEL: s_andn2_v2i16_multi_foldable_use:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s1, 0xffff
; GFX6-NEXT:    s_lshl_b32 s0, s3, 16
; GFX6-NEXT:    s_and_b32 s2, s2, s1
; GFX6-NEXT:    s_or_b32 s0, s0, s2
; GFX6-NEXT:    s_and_b32 s3, s4, s1
; GFX6-NEXT:    s_lshl_b32 s2, s5, 16
; GFX6-NEXT:    s_or_b32 s2, s2, s3
; GFX6-NEXT:    s_lshl_b32 s3, s7, 16
; GFX6-NEXT:    s_and_b32 s1, s6, s1
; GFX6-NEXT:    s_or_b32 s1, s3, s1
; GFX6-NEXT:    s_xor_b32 s1, s1, -1
; GFX6-NEXT:    s_and_b32 s0, s0, s1
; GFX6-NEXT:    s_and_b32 s1, s2, s1
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_v2i16_multi_foldable_use:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_xor_b32 s1, s4, -1
; GFX9-NEXT:    s_and_b32 s0, s2, s1
; GFX9-NEXT:    s_and_b32 s1, s3, s1
; GFX9-NEXT:    ; return to shader part epilog
  %not.src2 = xor <2 x i16> %src2, <i16 -1, i16 -1>
  %and0 = and <2 x i16> %src0, %not.src2
  %and1 = and <2 x i16> %src1, %not.src2

  %cast.0 = bitcast <2 x i16> %and0 to i32
  %cast.1 = bitcast <2 x i16> %and1 to i32
  %insert.0 = insertvalue { i32, i32 } undef, i32 %cast.0, 0
  %insert.1 = insertvalue { i32, i32 } %insert.0, i32 %cast.1, 1
  ret { i32, i32 } %insert.1
}

define <2 x i16> @v_andn2_v2i16(<2 x i16> %src0, <2 x i16> %src1) {
; GFX6-LABEL: v_andn2_v2i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_and_b32_e32 v0, v0, v4
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v3
; GFX6-NEXT:    v_and_b32_e32 v2, v2, v4
; GFX6-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX6-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX6-NEXT:    v_and_b32_e32 v0, v0, v1
; GFX6-NEXT:    v_lshrrev_b32_e32 v1, 16, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_andn2_v2i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_xor_b32_e32 v1, -1, v1
; GFX9-NEXT:    v_and_b32_e32 v0, v0, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %not.src1 = xor <2 x i16> %src1, <i16 -1, i16 -1>
  %and = and <2 x i16> %src0, %not.src1
  ret <2 x i16> %and
}

; FIXME:
; define amdgpu_ps i48 @s_andn2_v3i16(<3 x i16> inreg %src0, <3 x i16> inreg %src1) {
;   %not.src1 = xor <3 x i16> %src1, <i16 -1, i16 -1, i16 -1>
;   %and = and <3 x i16> %src0, %not.src1
;   %cast = bitcast <3 x i16> %and to i48
;   ret i48 %cast
; }

; define amdgpu_ps i48 @s_andn2_v3i16_commute(<3 x i16> inreg %src0, <3 x i16> inreg %src1) {
;   %not.src1 = xor <3 x i16> %src1, <i16 -1, i16 -1, i16 -1>
;   %and = and <3 x i16> %not.src1, %src0
;   %cast = bitcast <3 x i16> %and to i48
;   ret i48 %cast
; }

; define amdgpu_ps { i48, i48 } @s_andn2_v3i16_multi_use(<3 x i16> inreg %src0, <3 x i16> inreg %src1) {
;   %not.src1 = xor <3 x i16> %src1, <i16 -1, i16 -1, i16 -1>
;   %and = and <3 x i16> %src0, %not.src1

;   %cast.0 = bitcast <3 x i16> %and to i48
;   %cast.1 = bitcast <3 x i16> %not.src1 to i48
;   %insert.0 = insertvalue { i48, i48 } undef, i48 %cast.0, 0
;   %insert.1 = insertvalue { i48, i48 } %insert.0, i48 %cast.1, 1
;   ret { i48, i48 } %insert.1
; }

; define <3 x i16> @v_andn2_v3i16(<3 x i16> %src0, <3 x i16> %src1) {
;   %not.src1 = xor <3 x i16> %src1, <i16 -1, i16 -1, i16 -11>
;   %and = and <3 x i16> %src0, %not.src1
;   ret <3 x i16> %and
; }

define amdgpu_ps i64 @s_andn2_v4i16(<4 x i16> inreg %src0, <4 x i16> inreg %src1) {
; GFX6-LABEL: s_andn2_v4i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_lshl_b32 s0, s3, 16
; GFX6-NEXT:    s_mov_b32 s3, 0xffff
; GFX6-NEXT:    s_and_b32 s1, s2, s3
; GFX6-NEXT:    s_or_b32 s0, s0, s1
; GFX6-NEXT:    s_and_b32 s2, s4, s3
; GFX6-NEXT:    s_lshl_b32 s1, s5, 16
; GFX6-NEXT:    s_or_b32 s1, s1, s2
; GFX6-NEXT:    s_and_b32 s4, s6, s3
; GFX6-NEXT:    s_lshl_b32 s2, s7, 16
; GFX6-NEXT:    s_or_b32 s2, s2, s4
; GFX6-NEXT:    s_lshl_b32 s4, s9, 16
; GFX6-NEXT:    s_and_b32 s3, s8, s3
; GFX6-NEXT:    s_or_b32 s3, s4, s3
; GFX6-NEXT:    s_mov_b32 s4, -1
; GFX6-NEXT:    s_mov_b32 s5, s4
; GFX6-NEXT:    s_xor_b64 s[2:3], s[2:3], s[4:5]
; GFX6-NEXT:    s_and_b64 s[0:1], s[0:1], s[2:3]
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_v4i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s0, -1
; GFX9-NEXT:    s_mov_b32 s1, s0
; GFX9-NEXT:    s_xor_b64 s[0:1], s[4:5], s[0:1]
; GFX9-NEXT:    s_and_b64 s[0:1], s[2:3], s[0:1]
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor <4 x i16> %src1, <i16 -1, i16 -1, i16 -1, i16 -1>
  %and = and <4 x i16> %src0, %not.src1
  %cast = bitcast <4 x i16> %and to i64
  ret i64 %cast
}

define amdgpu_ps i64 @s_andn2_v4i16_commute(<4 x i16> inreg %src0, <4 x i16> inreg %src1) {
; GFX6-LABEL: s_andn2_v4i16_commute:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_lshl_b32 s0, s3, 16
; GFX6-NEXT:    s_mov_b32 s3, 0xffff
; GFX6-NEXT:    s_and_b32 s1, s2, s3
; GFX6-NEXT:    s_or_b32 s0, s0, s1
; GFX6-NEXT:    s_and_b32 s2, s4, s3
; GFX6-NEXT:    s_lshl_b32 s1, s5, 16
; GFX6-NEXT:    s_or_b32 s1, s1, s2
; GFX6-NEXT:    s_and_b32 s4, s6, s3
; GFX6-NEXT:    s_lshl_b32 s2, s7, 16
; GFX6-NEXT:    s_or_b32 s2, s2, s4
; GFX6-NEXT:    s_lshl_b32 s4, s9, 16
; GFX6-NEXT:    s_and_b32 s3, s8, s3
; GFX6-NEXT:    s_or_b32 s3, s4, s3
; GFX6-NEXT:    s_mov_b32 s4, -1
; GFX6-NEXT:    s_mov_b32 s5, s4
; GFX6-NEXT:    s_xor_b64 s[2:3], s[2:3], s[4:5]
; GFX6-NEXT:    s_and_b64 s[0:1], s[2:3], s[0:1]
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_v4i16_commute:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s0, -1
; GFX9-NEXT:    s_mov_b32 s1, s0
; GFX9-NEXT:    s_xor_b64 s[0:1], s[4:5], s[0:1]
; GFX9-NEXT:    s_and_b64 s[0:1], s[0:1], s[2:3]
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor <4 x i16> %src1, <i16 -1, i16 -1, i16 -1, i16 -1>
  %and = and <4 x i16> %not.src1, %src0
  %cast = bitcast <4 x i16> %and to i64
  ret i64 %cast
}

define amdgpu_ps { i64, i64 } @s_andn2_v4i16_multi_use(<4 x i16> inreg %src0, <4 x i16> inreg %src1) {
; GFX6-LABEL: s_andn2_v4i16_multi_use:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_lshl_b32 s0, s3, 16
; GFX6-NEXT:    s_mov_b32 s3, 0xffff
; GFX6-NEXT:    s_and_b32 s1, s2, s3
; GFX6-NEXT:    s_or_b32 s0, s0, s1
; GFX6-NEXT:    s_and_b32 s2, s4, s3
; GFX6-NEXT:    s_lshl_b32 s1, s5, 16
; GFX6-NEXT:    s_or_b32 s1, s1, s2
; GFX6-NEXT:    s_and_b32 s4, s6, s3
; GFX6-NEXT:    s_lshl_b32 s2, s7, 16
; GFX6-NEXT:    s_or_b32 s2, s2, s4
; GFX6-NEXT:    s_lshl_b32 s4, s9, 16
; GFX6-NEXT:    s_and_b32 s3, s8, s3
; GFX6-NEXT:    s_or_b32 s3, s4, s3
; GFX6-NEXT:    s_mov_b32 s4, -1
; GFX6-NEXT:    s_mov_b32 s5, s4
; GFX6-NEXT:    s_xor_b64 s[2:3], s[2:3], s[4:5]
; GFX6-NEXT:    s_and_b64 s[0:1], s[0:1], s[2:3]
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_v4i16_multi_use:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s0, -1
; GFX9-NEXT:    s_mov_b32 s1, s0
; GFX9-NEXT:    s_xor_b64 s[4:5], s[4:5], s[0:1]
; GFX9-NEXT:    s_and_b64 s[0:1], s[2:3], s[4:5]
; GFX9-NEXT:    s_mov_b32 s2, s4
; GFX9-NEXT:    s_mov_b32 s3, s5
; GFX9-NEXT:    ; return to shader part epilog
  %not.src1 = xor <4 x i16> %src1, <i16 -1, i16 -1, i16 -1, i16 -1>
  %and = and <4 x i16> %src0, %not.src1

  %cast.0 = bitcast <4 x i16> %and to i64
  %cast.1 = bitcast <4 x i16> %not.src1 to i64
  %insert.0 = insertvalue { i64, i64 } undef, i64 %cast.0, 0
  %insert.1 = insertvalue { i64, i64 } %insert.0, i64 %cast.1, 1
  ret { i64, i64 } %insert.1
}

define amdgpu_ps { i64, i64 } @s_andn2_v4i16_multi_foldable_use(<4 x i16> inreg %src0, <4 x i16> inreg %src1, <4 x i16> inreg %src2) {
; GFX6-LABEL: s_andn2_v4i16_multi_foldable_use:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_mov_b32 s14, 0xffff
; GFX6-NEXT:    s_lshl_b32 s0, s3, 16
; GFX6-NEXT:    s_and_b32 s1, s2, s14
; GFX6-NEXT:    s_or_b32 s0, s0, s1
; GFX6-NEXT:    s_lshl_b32 s1, s5, 16
; GFX6-NEXT:    s_and_b32 s2, s4, s14
; GFX6-NEXT:    s_or_b32 s1, s1, s2
; GFX6-NEXT:    s_and_b32 s3, s6, s14
; GFX6-NEXT:    s_lshl_b32 s2, s7, 16
; GFX6-NEXT:    s_or_b32 s2, s2, s3
; GFX6-NEXT:    s_lshl_b32 s3, s9, 16
; GFX6-NEXT:    s_and_b32 s4, s8, s14
; GFX6-NEXT:    s_or_b32 s3, s3, s4
; GFX6-NEXT:    s_lshl_b32 s4, s11, 16
; GFX6-NEXT:    s_and_b32 s5, s10, s14
; GFX6-NEXT:    s_or_b32 s4, s4, s5
; GFX6-NEXT:    s_lshl_b32 s5, s13, 16
; GFX6-NEXT:    s_and_b32 s6, s12, s14
; GFX6-NEXT:    s_or_b32 s5, s5, s6
; GFX6-NEXT:    s_mov_b32 s6, -1
; GFX6-NEXT:    s_mov_b32 s7, s6
; GFX6-NEXT:    s_xor_b64 s[4:5], s[4:5], s[6:7]
; GFX6-NEXT:    s_and_b64 s[0:1], s[0:1], s[4:5]
; GFX6-NEXT:    s_and_b64 s[2:3], s[2:3], s[4:5]
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_andn2_v4i16_multi_foldable_use:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_mov_b32 s0, -1
; GFX9-NEXT:    s_mov_b32 s1, s0
; GFX9-NEXT:    s_xor_b64 s[6:7], s[6:7], s[0:1]
; GFX9-NEXT:    s_and_b64 s[0:1], s[2:3], s[6:7]
; GFX9-NEXT:    s_and_b64 s[2:3], s[4:5], s[6:7]
; GFX9-NEXT:    ; return to shader part epilog
  %not.src2 = xor <4 x i16> %src2, <i16 -1, i16 -1, i16 -1, i16 -1>
  %and0 = and <4 x i16> %src0, %not.src2
  %and1 = and <4 x i16> %src1, %not.src2

  %cast.0 = bitcast <4 x i16> %and0 to i64
  %cast.1 = bitcast <4 x i16> %and1 to i64
  %insert.0 = insertvalue { i64, i64 } undef, i64 %cast.0, 0
  %insert.1 = insertvalue { i64, i64 } %insert.0, i64 %cast.1, 1
  ret { i64, i64 } %insert.1
}

define <4 x i16> @v_andn2_v4i16(<4 x i16> %src0, <4 x i16> %src1) {
; GFX6-LABEL: v_andn2_v4i16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_mov_b32_e32 v8, 0xffff
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v1
; GFX6-NEXT:    v_and_b32_e32 v0, v0, v8
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    v_lshlrev_b32_e32 v1, 16, v3
; GFX6-NEXT:    v_and_b32_e32 v2, v2, v8
; GFX6-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX6-NEXT:    v_and_b32_e32 v3, v4, v8
; GFX6-NEXT:    v_lshlrev_b32_e32 v2, 16, v5
; GFX6-NEXT:    v_or_b32_e32 v2, v2, v3
; GFX6-NEXT:    v_lshlrev_b32_e32 v3, 16, v7
; GFX6-NEXT:    v_and_b32_e32 v4, v6, v8
; GFX6-NEXT:    v_or_b32_e32 v3, v3, v4
; GFX6-NEXT:    v_xor_b32_e32 v2, -1, v2
; GFX6-NEXT:    v_xor_b32_e32 v3, -1, v3
; GFX6-NEXT:    v_and_b32_e32 v0, v0, v2
; GFX6-NEXT:    v_and_b32_e32 v2, v1, v3
; GFX6-NEXT:    v_lshrrev_b32_e32 v1, 16, v0
; GFX6-NEXT:    v_lshrrev_b32_e32 v3, 16, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_andn2_v4i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_xor_b32_e32 v2, -1, v2
; GFX9-NEXT:    v_xor_b32_e32 v3, -1, v3
; GFX9-NEXT:    v_and_b32_e32 v0, v0, v2
; GFX9-NEXT:    v_and_b32_e32 v1, v1, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %not.src1 = xor <4 x i16> %src1, <i16 -1, i16 -1, i16 -1, i16 -1>
  %and = and <4 x i16> %src0, %not.src1
  ret <4 x i16> %and
}
