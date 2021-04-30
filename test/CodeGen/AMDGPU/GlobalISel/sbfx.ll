; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=fiji -o - < %s | FileCheck --check-prefix=GCN %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx900 -o - < %s | FileCheck --check-prefix=GCN %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdpal -mcpu=gfx1010 -o - < %s | FileCheck --check-prefix=GFX10 %s

; Test vector signed bitfield extract.
define signext i8 @v_ashr_i8_i32(i32 %value) {
; GCN-LABEL: v_ashr_i8_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_bfe_i32 v0, v0, 4, 8
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_ashr_i8_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_bfe_i32 v0, v0, 4, 8
; GFX10-NEXT:    s_setpc_b64 s[30:31]
 %1 = ashr i32 %value, 4
 %2 = trunc i32 %1 to i8
 ret i8 %2
}

define signext i16 @v_ashr_i16_i32(i32 %value) {
; GCN-LABEL: v_ashr_i16_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_bfe_i32 v0, v0, 9, 16
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_ashr_i16_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_bfe_i32 v0, v0, 9, 16
; GFX10-NEXT:    s_setpc_b64 s[30:31]
 %1 = ashr i32 %value, 9
 %2 = trunc i32 %1 to i16
 ret i16 %2
}

define signext i8 @v_lshr_i8_i32(i32 %value) {
; GCN-LABEL: v_lshr_i8_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_bfe_i32 v0, v0, 4, 8
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_lshr_i8_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_bfe_i32 v0, v0, 4, 8
; GFX10-NEXT:    s_setpc_b64 s[30:31]
 %1 = lshr i32 %value, 4
 %2 = trunc i32 %1 to i8
 ret i8 %2
}

define signext i16 @v_lshr_i16_i32(i32 %value) {
; GCN-LABEL: v_lshr_i16_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_bfe_i32 v0, v0, 9, 16
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_lshr_i16_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_bfe_i32 v0, v0, 9, 16
; GFX10-NEXT:    s_setpc_b64 s[30:31]
 %1 = lshr i32 %value, 9
 %2 = trunc i32 %1 to i16
 ret i16 %2
}

; Test vector bitfield extract for 64-bits.
define i64 @v_ashr_i64(i64 %value) {
; GCN-LABEL: v_ashr_i64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_ashrrev_i64 v[0:1], 10, v[0:1]
; GCN-NEXT:    v_bfe_i32 v0, v0, 0, 4
; GCN-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_ashr_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_ashrrev_i64 v[0:1], 10, v[0:1]
; GFX10-NEXT:    v_bfe_i32 v0, v0, 0, 4
; GFX10-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
 %1 = ashr i64 %value, 10
 %2 = shl i64 %1, 60
 %3 = ashr i64 %2, 60
 ret i64 %3
}

define i64 @v_lshr_i64(i64 %value) {
; GCN-LABEL: v_lshr_i64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_ashrrev_i64 v[0:1], 10, v[0:1]
; GCN-NEXT:    v_bfe_i32 v0, v0, 0, 4
; GCN-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_lshr_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_ashrrev_i64 v[0:1], 10, v[0:1]
; GFX10-NEXT:    v_bfe_i32 v0, v0, 0, 4
; GFX10-NEXT:    v_ashrrev_i32_e32 v1, 31, v0
; GFX10-NEXT:    s_setpc_b64 s[30:31]
 %1 = lshr i64 %value, 10
 %2 = shl i64 %1, 60
 %3 = ashr i64 %2, 60
 ret i64 %3
}

; Test scalar signed bitfield extract.
define amdgpu_ps signext i8 @s_ashr_i8_i32(i32 inreg %value) {
; GCN-LABEL: s_ashr_i8_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_bfe_i32 s0, s0, 0x80004
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_ashr_i8_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_bfe_i32 s0, s0, 0x80004
; GFX10-NEXT:    ; return to shader part epilog
 %1 = ashr i32 %value, 4
 %2 = trunc i32 %1 to i8
 ret i8 %2
}

define amdgpu_ps signext i16 @s_ashr_i16_i32(i32 inreg %value) {
; GCN-LABEL: s_ashr_i16_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_bfe_i32 s0, s0, 0x100009
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_ashr_i16_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_bfe_i32 s0, s0, 0x100009
; GFX10-NEXT:    ; return to shader part epilog
 %1 = ashr i32 %value, 9
 %2 = trunc i32 %1 to i16
 ret i16 %2
}

define amdgpu_ps signext i8 @s_lshr_i8_i32(i32 inreg %value) {
; GCN-LABEL: s_lshr_i8_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_bfe_i32 s0, s0, 0x80004
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_lshr_i8_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_bfe_i32 s0, s0, 0x80004
; GFX10-NEXT:    ; return to shader part epilog
 %1 = lshr i32 %value, 4
 %2 = trunc i32 %1 to i8
 ret i8 %2
}

define amdgpu_ps signext i16 @s_lshr_i16_i32(i32 inreg %value) {
; GCN-LABEL: s_lshr_i16_i32:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_bfe_i32 s0, s0, 0x100009
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_lshr_i16_i32:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_bfe_i32 s0, s0, 0x100009
; GFX10-NEXT:    ; return to shader part epilog
 %1 = lshr i32 %value, 9
 %2 = trunc i32 %1 to i16
 ret i16 %2
}

; Test scalar bitfield extract for 64-bits.
define amdgpu_ps i64 @s_ashr_i64(i64 inreg %value) {
; GCN-LABEL: s_ashr_i64:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_bfe_i64 s[0:1], s[0:1], 0x40001
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_ashr_i64:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_bfe_i64 s[0:1], s[0:1], 0x40001
; GFX10-NEXT:    ; return to shader part epilog
 %1 = ashr i64 %value, 1
 %2 = shl i64 %1, 60
 %3 = ashr i64 %2, 60
 ret i64 %3
}
