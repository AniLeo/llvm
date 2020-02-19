; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx906 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX906 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1011 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX10 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx1012 -verify-machineinstrs < %s | FileCheck -check-prefixes=GCN,GFX10 %s

define i32 @v_udot8(i32 %a, i32 %b, i32 %c) {
; GFX906-LABEL: v_udot8:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_dot8_u32_u4 v0, v0, v1, v2
; GFX906-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_udot8:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_dot8_u32_u4 v0, v0, v1, v2
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %r = call i32 @llvm.amdgcn.udot8(i32 %a, i32 %b, i32 %c, i1 false)
  ret i32 %r
}

define i32 @v_udot8_clamp(i32 %a, i32 %b, i32 %c) {
; GFX906-LABEL: v_udot8_clamp:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_dot8_u32_u4 v0, v0, v1, v2 clamp
; GFX906-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_udot8_clamp:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_dot8_u32_u4 v0, v0, v1, v2 clamp
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %r = call i32 @llvm.amdgcn.udot8(i32 %a, i32 %b, i32 %c, i1 true)
  ret i32 %r
}

; FIXME: Fix argument do not let these casts expand
; define i32 @v_udot8_cast_v8i4(<8 x i4> %a, <8 x i4> %b, i32 %c) {
;   %a.cast = bitcast <8 x i4> %a to i32
;   %b.cast = bitcast <8 x i4> %b to i32
;   %r = call i32 @llvm.amdgcn.udot8(i32 %a.cast, i32 %b.cast, i32 %c, i1 false)
;   ret i32 %r
; }

define i32 @v_udot8_fnegf32_a(float %a, i32 %b, i32 %c) {
; GFX906-LABEL: v_udot8_fnegf32_a:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_xor_b32_e32 v0, 0x80000000, v0
; GFX906-NEXT:    v_dot8_u32_u4 v0, v0, v1, v2
; GFX906-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_udot8_fnegf32_a:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_xor_b32_e32 v0, 0x80000000, v0
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    v_dot8_u32_u4 v0, v0, v1, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg float %a
  %cast.neg.a = bitcast float %neg.a to i32
  %r = call i32 @llvm.amdgcn.udot8(i32 %cast.neg.a, i32 %b, i32 %c, i1 false)
  ret i32 %r
}

define i32 @v_udot8_fnegv2f16_a(<2 x half> %a, i32 %b, i32 %c) {
; GFX906-LABEL: v_udot8_fnegv2f16_a:
; GFX906:       ; %bb.0:
; GFX906-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX906-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX906-NEXT:    v_dot8_u32_u4 v0, v0, v1, v2
; GFX906-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_udot8_fnegv2f16_a:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    v_dot8_u32_u4 v0, v0, v1, v2
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <2 x half> %a
  %cast.neg.a = bitcast <2 x half> %neg.a to i32
  %r = call i32 @llvm.amdgcn.udot8(i32 %cast.neg.a, i32 %b, i32 %c, i1 false)
  ret i32 %r
}

declare i32 @llvm.amdgcn.udot8(i32, i32, i32, i1 immarg) #0

attributes #0 = { nounwind readnone speculatable }
