; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=hawaii -o - %s | FileCheck -check-prefix=GFX7 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=fiji -o - %s | FileCheck -check-prefix=GFX8 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 -o - %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx1010 -o - %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_ps i32 @s_bswap_i32(i32 inreg %src) {
; GFX7-LABEL: s_bswap_i32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    v_alignbit_b32 v0, s0, s0, 8
; GFX7-NEXT:    v_alignbit_b32 v1, s0, s0, 24
; GFX7-NEXT:    s_mov_b32 s0, 0xff00ff
; GFX7-NEXT:    v_bfi_b32 v0, s0, v1, v0
; GFX7-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_bswap_i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    s_mov_b32 s0, 0x10203
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s0
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_bswap_i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    s_mov_b32 s0, 0x10203
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s0
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_bswap_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_perm_b32 v0, 0, s0, 0x10203
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    ; return to shader part epilog
  %bswap = call i32 @llvm.bswap.i32(i32 %src)
  ret i32 %bswap
}

define i32 @v_bswap_i32(i32 %src) {
; GFX7-LABEL: v_bswap_i32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_alignbit_b32 v1, v0, v0, 8
; GFX7-NEXT:    v_alignbit_b32 v0, v0, v0, 24
; GFX7-NEXT:    s_mov_b32 s4, 0xff00ff
; GFX7-NEXT:    v_bfi_b32 v0, s4, v0, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bswap_i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x10203
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_bswap_i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0x10203
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bswap_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_perm_b32 v0, 0, v0, 0x10203
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %bswap = call i32 @llvm.bswap.i32(i32 %src)
  ret i32 %bswap
}

define amdgpu_ps <2 x i32> @s_bswap_v2i32(<2 x i32> inreg %src) {
; GFX7-LABEL: s_bswap_v2i32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    v_alignbit_b32 v0, s0, s0, 8
; GFX7-NEXT:    v_alignbit_b32 v1, s0, s0, 24
; GFX7-NEXT:    s_mov_b32 s0, 0xff00ff
; GFX7-NEXT:    v_bfi_b32 v0, s0, v1, v0
; GFX7-NEXT:    v_alignbit_b32 v1, s1, s1, 8
; GFX7-NEXT:    v_alignbit_b32 v2, s1, s1, 24
; GFX7-NEXT:    v_bfi_b32 v1, s0, v2, v1
; GFX7-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-NEXT:    v_readfirstlane_b32 s1, v1
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_bswap_v2i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    s_mov_b32 s0, 0x10203
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s0
; GFX8-NEXT:    v_perm_b32 v1, 0, v1, s0
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_bswap_v2i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    s_mov_b32 s0, 0x10203
; GFX9-NEXT:    v_mov_b32_e32 v1, s1
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s0
; GFX9-NEXT:    v_perm_b32 v1, 0, v1, s0
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    v_readfirstlane_b32 s1, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_bswap_v2i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s2, 0x10203
; GFX10-NEXT:    v_perm_b32 v0, 0, s0, s2
; GFX10-NEXT:    v_perm_b32 v1, 0, s1, s2
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    v_readfirstlane_b32 s1, v1
; GFX10-NEXT:    ; return to shader part epilog
  %bswap = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %src)
  ret <2 x i32> %bswap
}

define <2 x i32> @v_bswap_v2i32(<2 x i32> %src) {
; GFX7-LABEL: v_bswap_v2i32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_alignbit_b32 v2, v0, v0, 8
; GFX7-NEXT:    v_alignbit_b32 v0, v0, v0, 24
; GFX7-NEXT:    s_mov_b32 s4, 0xff00ff
; GFX7-NEXT:    v_bfi_b32 v0, s4, v0, v2
; GFX7-NEXT:    v_alignbit_b32 v2, v1, v1, 8
; GFX7-NEXT:    v_alignbit_b32 v1, v1, v1, 24
; GFX7-NEXT:    v_bfi_b32 v1, s4, v1, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bswap_v2i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x10203
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX8-NEXT:    v_perm_b32 v1, 0, v1, s4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_bswap_v2i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0x10203
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX9-NEXT:    v_perm_b32 v1, 0, v1, s4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bswap_v2i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_mov_b32 s4, 0x10203
; GFX10-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX10-NEXT:    v_perm_b32 v1, 0, v1, s4
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %bswap = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %src)
  ret <2 x i32> %bswap
}

define amdgpu_ps i64 @s_bswap_i64(i64 inreg %src) {
; GFX7-LABEL: s_bswap_i64:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    v_alignbit_b32 v0, s1, s1, 8
; GFX7-NEXT:    v_alignbit_b32 v1, s1, s1, 24
; GFX7-NEXT:    s_mov_b32 s1, 0xff00ff
; GFX7-NEXT:    v_bfi_b32 v0, s1, v1, v0
; GFX7-NEXT:    v_alignbit_b32 v1, s0, s0, 8
; GFX7-NEXT:    v_alignbit_b32 v2, s0, s0, 24
; GFX7-NEXT:    v_bfi_b32 v1, s1, v2, v1
; GFX7-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-NEXT:    v_readfirstlane_b32 s1, v1
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_bswap_i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s1
; GFX8-NEXT:    s_mov_b32 s1, 0x10203
; GFX8-NEXT:    v_mov_b32_e32 v1, s0
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s1
; GFX8-NEXT:    v_perm_b32 v1, 0, v1, s1
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_bswap_i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    s_mov_b32 s1, 0x10203
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s1
; GFX9-NEXT:    v_perm_b32 v1, 0, v1, s1
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    v_readfirstlane_b32 s1, v1
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_bswap_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s2, 0x10203
; GFX10-NEXT:    v_perm_b32 v0, 0, s1, s2
; GFX10-NEXT:    v_perm_b32 v1, 0, s0, s2
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    v_readfirstlane_b32 s1, v1
; GFX10-NEXT:    ; return to shader part epilog
  %bswap = call i64 @llvm.bswap.i64(i64 %src)
  ret i64 %bswap
}

define i64 @v_bswap_i64(i64 %src) {
; GFX7-LABEL: v_bswap_i64:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_alignbit_b32 v2, v1, v1, 8
; GFX7-NEXT:    v_alignbit_b32 v1, v1, v1, 24
; GFX7-NEXT:    s_mov_b32 s4, 0xff00ff
; GFX7-NEXT:    v_bfi_b32 v2, s4, v1, v2
; GFX7-NEXT:    v_alignbit_b32 v1, v0, v0, 8
; GFX7-NEXT:    v_alignbit_b32 v0, v0, v0, 24
; GFX7-NEXT:    v_bfi_b32 v1, s4, v0, v1
; GFX7-NEXT:    v_mov_b32_e32 v0, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bswap_i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x10203
; GFX8-NEXT:    v_perm_b32 v2, 0, v1, s4
; GFX8-NEXT:    v_perm_b32 v1, 0, v0, s4
; GFX8-NEXT:    v_mov_b32_e32 v0, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_bswap_i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0x10203
; GFX9-NEXT:    v_perm_b32 v2, 0, v1, s4
; GFX9-NEXT:    v_perm_b32 v1, 0, v0, s4
; GFX9-NEXT:    v_mov_b32_e32 v0, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bswap_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_mov_b32 s4, 0x10203
; GFX10-NEXT:    v_perm_b32 v2, 0, v1, s4
; GFX10-NEXT:    v_perm_b32 v1, 0, v0, s4
; GFX10-NEXT:    v_mov_b32_e32 v0, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %bswap = call i64 @llvm.bswap.i64(i64 %src)
  ret i64 %bswap
}

define amdgpu_ps <2 x i64> @s_bswap_v2i64(<2 x i64> inreg %src) {
; GFX7-LABEL: s_bswap_v2i64:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    v_alignbit_b32 v0, s1, s1, 8
; GFX7-NEXT:    v_alignbit_b32 v1, s1, s1, 24
; GFX7-NEXT:    s_mov_b32 s1, 0xff00ff
; GFX7-NEXT:    v_bfi_b32 v0, s1, v1, v0
; GFX7-NEXT:    v_alignbit_b32 v1, s0, s0, 8
; GFX7-NEXT:    v_alignbit_b32 v2, s0, s0, 24
; GFX7-NEXT:    v_bfi_b32 v1, s1, v2, v1
; GFX7-NEXT:    v_alignbit_b32 v2, s3, s3, 8
; GFX7-NEXT:    v_alignbit_b32 v3, s3, s3, 24
; GFX7-NEXT:    v_bfi_b32 v2, s1, v3, v2
; GFX7-NEXT:    v_alignbit_b32 v3, s2, s2, 8
; GFX7-NEXT:    v_alignbit_b32 v4, s2, s2, 24
; GFX7-NEXT:    v_bfi_b32 v3, s1, v4, v3
; GFX7-NEXT:    v_readfirstlane_b32 s0, v0
; GFX7-NEXT:    v_readfirstlane_b32 s1, v1
; GFX7-NEXT:    v_readfirstlane_b32 s2, v2
; GFX7-NEXT:    v_readfirstlane_b32 s3, v3
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_bswap_v2i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s1
; GFX8-NEXT:    s_mov_b32 s1, 0x10203
; GFX8-NEXT:    v_mov_b32_e32 v1, s0
; GFX8-NEXT:    v_mov_b32_e32 v2, s3
; GFX8-NEXT:    v_mov_b32_e32 v3, s2
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s1
; GFX8-NEXT:    v_perm_b32 v1, 0, v1, s1
; GFX8-NEXT:    v_perm_b32 v2, 0, v2, s1
; GFX8-NEXT:    v_perm_b32 v3, 0, v3, s1
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    v_readfirstlane_b32 s1, v1
; GFX8-NEXT:    v_readfirstlane_b32 s2, v2
; GFX8-NEXT:    v_readfirstlane_b32 s3, v3
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_bswap_v2i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s1
; GFX9-NEXT:    s_mov_b32 s1, 0x10203
; GFX9-NEXT:    v_mov_b32_e32 v1, s0
; GFX9-NEXT:    v_mov_b32_e32 v2, s3
; GFX9-NEXT:    v_mov_b32_e32 v3, s2
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s1
; GFX9-NEXT:    v_perm_b32 v1, 0, v1, s1
; GFX9-NEXT:    v_perm_b32 v2, 0, v2, s1
; GFX9-NEXT:    v_perm_b32 v3, 0, v3, s1
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    v_readfirstlane_b32 s1, v1
; GFX9-NEXT:    v_readfirstlane_b32 s2, v2
; GFX9-NEXT:    v_readfirstlane_b32 s3, v3
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_bswap_v2i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_mov_b32 s4, 0x10203
; GFX10-NEXT:    v_perm_b32 v0, 0, s1, s4
; GFX10-NEXT:    v_perm_b32 v1, 0, s0, s4
; GFX10-NEXT:    v_perm_b32 v2, 0, s3, s4
; GFX10-NEXT:    v_perm_b32 v3, 0, s2, s4
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    v_readfirstlane_b32 s1, v1
; GFX10-NEXT:    v_readfirstlane_b32 s2, v2
; GFX10-NEXT:    v_readfirstlane_b32 s3, v3
; GFX10-NEXT:    ; return to shader part epilog
  %bswap = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %src)
  ret <2 x i64> %bswap
}

define <2 x i64> @v_bswap_v2i64(<2 x i64> %src) {
; GFX7-LABEL: v_bswap_v2i64:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_alignbit_b32 v4, v1, v1, 8
; GFX7-NEXT:    v_alignbit_b32 v1, v1, v1, 24
; GFX7-NEXT:    s_mov_b32 s4, 0xff00ff
; GFX7-NEXT:    v_bfi_b32 v4, s4, v1, v4
; GFX7-NEXT:    v_alignbit_b32 v1, v0, v0, 8
; GFX7-NEXT:    v_alignbit_b32 v0, v0, v0, 24
; GFX7-NEXT:    v_bfi_b32 v1, s4, v0, v1
; GFX7-NEXT:    v_alignbit_b32 v0, v3, v3, 8
; GFX7-NEXT:    v_alignbit_b32 v3, v3, v3, 24
; GFX7-NEXT:    v_bfi_b32 v5, s4, v3, v0
; GFX7-NEXT:    v_alignbit_b32 v0, v2, v2, 8
; GFX7-NEXT:    v_alignbit_b32 v2, v2, v2, 24
; GFX7-NEXT:    v_bfi_b32 v3, s4, v2, v0
; GFX7-NEXT:    v_mov_b32_e32 v0, v4
; GFX7-NEXT:    v_mov_b32_e32 v2, v5
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bswap_v2i64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x10203
; GFX8-NEXT:    v_perm_b32 v4, 0, v1, s4
; GFX8-NEXT:    v_perm_b32 v5, 0, v3, s4
; GFX8-NEXT:    v_perm_b32 v1, 0, v0, s4
; GFX8-NEXT:    v_perm_b32 v3, 0, v2, s4
; GFX8-NEXT:    v_mov_b32_e32 v0, v4
; GFX8-NEXT:    v_mov_b32_e32 v2, v5
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_bswap_v2i64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0x10203
; GFX9-NEXT:    v_perm_b32 v4, 0, v1, s4
; GFX9-NEXT:    v_perm_b32 v5, 0, v3, s4
; GFX9-NEXT:    v_perm_b32 v1, 0, v0, s4
; GFX9-NEXT:    v_perm_b32 v3, 0, v2, s4
; GFX9-NEXT:    v_mov_b32_e32 v0, v4
; GFX9-NEXT:    v_mov_b32_e32 v2, v5
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bswap_v2i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_mov_b32 s4, 0x10203
; GFX10-NEXT:    v_perm_b32 v4, 0, v1, s4
; GFX10-NEXT:    v_perm_b32 v5, 0, v3, s4
; GFX10-NEXT:    v_perm_b32 v1, 0, v0, s4
; GFX10-NEXT:    v_perm_b32 v3, 0, v2, s4
; GFX10-NEXT:    v_mov_b32_e32 v0, v4
; GFX10-NEXT:    v_mov_b32_e32 v2, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %bswap = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %src)
  ret <2 x i64> %bswap
}

define amdgpu_ps i16 @s_bswap_i16(i16 inreg %src) {
; GFX7-LABEL: s_bswap_i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_lshl_b32 s1, s0, 8
; GFX7-NEXT:    s_bfe_u32 s0, s0, 0x80008
; GFX7-NEXT:    s_or_b32 s0, s0, s1
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_bswap_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    s_mov_b32 s0, 0xc0c0001
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s0
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_bswap_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    s_mov_b32 s0, 0xc0c0001
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s0
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_bswap_i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_perm_b32 v0, 0, s0, 0xc0c0001
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    ; return to shader part epilog
  %bswap = call i16 @llvm.bswap.i16(i16 %src)
  ret i16 %bswap
}

define i16 @v_bswap_i16(i16 %src) {
; GFX7-LABEL: v_bswap_i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 8, v0
; GFX7-NEXT:    v_bfe_u32 v0, v0, 8, 8
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bswap_i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0xc0c0001
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_bswap_i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0xc0c0001
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bswap_i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_perm_b32 v0, 0, v0, 0xc0c0001
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %bswap = call i16 @llvm.bswap.i16(i16 %src)
  ret i16 %bswap
}

define amdgpu_ps i32 @s_bswap_v2i16(<2 x i16> inreg %src) {
; GFX7-LABEL: s_bswap_v2i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_mov_b32 s3, 0x80008
; GFX7-NEXT:    s_lshl_b32 s2, s0, 8
; GFX7-NEXT:    s_bfe_u32 s0, s0, s3
; GFX7-NEXT:    s_or_b32 s0, s0, s2
; GFX7-NEXT:    s_lshl_b32 s2, s1, 8
; GFX7-NEXT:    s_bfe_u32 s1, s1, s3
; GFX7-NEXT:    s_or_b32 s1, s1, s2
; GFX7-NEXT:    s_bfe_u32 s1, s1, 0x100000
; GFX7-NEXT:    s_bfe_u32 s0, s0, 0x100000
; GFX7-NEXT:    s_lshl_b32 s1, s1, 16
; GFX7-NEXT:    s_or_b32 s0, s0, s1
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_bswap_v2i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    s_mov_b32 s0, 0x2030001
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s0
; GFX8-NEXT:    v_readfirstlane_b32 s0, v0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_bswap_v2i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_mov_b32_e32 v0, s0
; GFX9-NEXT:    s_mov_b32 s0, 0x2030001
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s0
; GFX9-NEXT:    v_readfirstlane_b32 s0, v0
; GFX9-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_bswap_v2i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_perm_b32 v0, 0, s0, 0x2030001
; GFX10-NEXT:    v_readfirstlane_b32 s0, v0
; GFX10-NEXT:    ; return to shader part epilog
  %bswap = call <2 x i16> @llvm.bswap.v2i16(<2 x i16> %src)
  %cast = bitcast <2 x i16> %bswap to i32
  ret i32 %cast
}

define i32 @v_bswap_i16_zext_to_i32(i16 %src) {
; GFX7-LABEL: v_bswap_i16_zext_to_i32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 8, v0
; GFX7-NEXT:    v_bfe_u32 v0, v0, 8, 8
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    v_bfe_u32 v0, v0, 0, 16
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bswap_i16_zext_to_i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0xc0c0001
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_bswap_i16_zext_to_i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0xc0c0001
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bswap_i16_zext_to_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_perm_b32 v0, 0, v0, 0xc0c0001
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %bswap = call i16 @llvm.bswap.i16(i16 %src)
  %zext = zext i16 %bswap to i32
  ret i32 %zext
}

define i32 @v_bswap_i16_sext_to_i32(i16 %src) {
; GFX7-LABEL: v_bswap_i16_sext_to_i32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_lshlrev_b32_e32 v1, 8, v0
; GFX7-NEXT:    v_bfe_u32 v0, v0, 8, 8
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v1
; GFX7-NEXT:    v_bfe_i32 v0, v0, 0, 16
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bswap_i16_sext_to_i32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0xc0c0001
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX8-NEXT:    v_bfe_i32 v0, v0, 0, 16
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_bswap_i16_sext_to_i32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0xc0c0001
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX9-NEXT:    v_bfe_i32 v0, v0, 0, 16
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bswap_i16_sext_to_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_perm_b32 v0, 0, v0, 0xc0c0001
; GFX10-NEXT:    v_bfe_i32 v0, v0, 0, 16
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %bswap = call i16 @llvm.bswap.i16(i16 %src)
  %zext = sext i16 %bswap to i32
  ret i32 %zext
}

define <2 x i16> @v_bswap_v2i16(<2 x i16> %src) {
; GFX7-LABEL: v_bswap_v2i16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 8, v0
; GFX7-NEXT:    v_bfe_u32 v0, v0, 8, 8
; GFX7-NEXT:    v_or_b32_e32 v0, v0, v2
; GFX7-NEXT:    v_lshlrev_b32_e32 v2, 8, v1
; GFX7-NEXT:    v_bfe_u32 v1, v1, 8, 8
; GFX7-NEXT:    v_or_b32_e32 v1, v1, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bswap_v2i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x2030001
; GFX8-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_bswap_v2i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0x2030001
; GFX9-NEXT:    v_perm_b32 v0, 0, v0, s4
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bswap_v2i16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_perm_b32 v0, 0, v0, 0x2030001
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %bswap = call <2 x i16> @llvm.bswap.v2i16(<2 x i16> %src)
  ret <2 x i16> %bswap
}

; FIXME
; define <3 x i16> @v_bswap_v3i16(<3 x i16> %src) {
;   %bswap = call <3 x i16> @llvm.bswap.v3i16(<3 x i16> %ext.src)
;   ret <3 x i16> %bswap
; }

define i64 @v_bswap_i48(i64 %src) {
; GFX7-LABEL: v_bswap_i48:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_alignbit_b32 v2, v1, v1, 8
; GFX7-NEXT:    v_alignbit_b32 v1, v1, v1, 24
; GFX7-NEXT:    s_mov_b32 s4, 0xff00ff
; GFX7-NEXT:    v_bfi_b32 v1, s4, v1, v2
; GFX7-NEXT:    v_alignbit_b32 v2, v0, v0, 8
; GFX7-NEXT:    v_alignbit_b32 v0, v0, v0, 24
; GFX7-NEXT:    v_bfi_b32 v2, s4, v0, v2
; GFX7-NEXT:    v_lshr_b64 v[0:1], v[1:2], 16
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_bswap_i48:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x10203
; GFX8-NEXT:    v_perm_b32 v1, 0, v1, s4
; GFX8-NEXT:    v_perm_b32 v2, 0, v0, s4
; GFX8-NEXT:    v_lshrrev_b64 v[0:1], 16, v[1:2]
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_bswap_i48:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    s_mov_b32 s4, 0x10203
; GFX9-NEXT:    v_perm_b32 v1, 0, v1, s4
; GFX9-NEXT:    v_perm_b32 v2, 0, v0, s4
; GFX9-NEXT:    v_lshrrev_b64 v[0:1], 16, v[1:2]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_bswap_i48:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    s_mov_b32 s4, 0x10203
; GFX10-NEXT:    v_perm_b32 v1, 0, v1, s4
; GFX10-NEXT:    v_perm_b32 v2, 0, v0, s4
; GFX10-NEXT:    v_lshrrev_b64 v[0:1], 16, v[1:2]
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %trunc = trunc i64 %src to i48
  %bswap = call i48 @llvm.bswap.i48(i48 %trunc)
  %zext = zext i48 %bswap to i64
  ret i64 %zext
}

declare i16 @llvm.bswap.i16(i16) #1
declare <2 x i16> @llvm.bswap.v2i16(<2 x i16>) #1
declare <3 x i16> @llvm.bswap.v3i16(<3 x i16>) #1
declare i32 @llvm.bswap.i32(i32) #1
declare <2 x i32> @llvm.bswap.v2i32(<2 x i32>) #1
declare i64 @llvm.bswap.i64(i64) #1
declare <2 x i64> @llvm.bswap.v2i64(<2 x i64>) #1
declare i48 @llvm.bswap.i48(i48) #1

attributes #0 = { convergent nounwind readnone }
attributes #1 = { nounwind readnone speculatable willreturn }
