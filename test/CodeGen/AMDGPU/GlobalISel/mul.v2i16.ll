; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-amd-amdhsa -mcpu=fiji < %s | FileCheck -check-prefix=GFX8 %s

define <2 x i16> @v_mul_v2i16(<2 x i16> %a, <2 x i16> %b) {
; GFX9-LABEL: v_mul_v2i16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_lo_u16 v0, v0, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_v2i16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_mul_lo_u16_e32 v2, v0, v1
; GFX8-NEXT:    v_mul_lo_u16_sdwa v0, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_or_b32_e32 v0, v2, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
  %mul = mul <2 x i16> %a, %b
  ret <2 x i16> %mul
}

define <2 x i16> @v_mul_v2i16_fneg_lhs(<2 x half> %a, <2 x i16> %b) {
; GFX9-LABEL: v_mul_v2i16_fneg_lhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_lo_u16 v0, v0, v1 neg_lo:[1,0] neg_hi:[1,0]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_v2i16_fneg_lhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX8-NEXT:    v_mul_lo_u16_e32 v2, v0, v1
; GFX8-NEXT:    v_mul_lo_u16_sdwa v0, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_or_b32_e32 v0, v2, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <2 x half> %a
  %cast.neg.a = bitcast <2 x half> %neg.a to <2 x i16>
  %mul = mul <2 x i16> %cast.neg.a, %b
  ret <2 x i16> %mul
}

define <2 x i16> @v_mul_v2i16_fneg_rhs(<2 x i16> %a, <2 x half> %b) {
; GFX9-LABEL: v_mul_v2i16_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_lo_u16 v0, v0, v1 neg_lo:[0,1] neg_hi:[0,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_v2i16_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v1, 0x80008000, v1
; GFX8-NEXT:    v_mul_lo_u16_e32 v2, v0, v1
; GFX8-NEXT:    v_mul_lo_u16_sdwa v0, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_or_b32_e32 v0, v2, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
  %neg.b = fneg <2 x half> %b
  %cast.neg.b = bitcast <2 x half> %neg.b to <2 x i16>
  %mul = mul <2 x i16> %a, %cast.neg.b
  ret <2 x i16> %mul
}

define <2 x i16> @v_mul_v2i16_fneg_lhs_fneg_rhs(<2 x half> %a, <2 x half> %b) {
; GFX9-LABEL: v_mul_v2i16_fneg_lhs_fneg_rhs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_pk_mul_lo_u16 v0, v0, v1 neg_lo:[1,1] neg_hi:[1,1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_mul_v2i16_fneg_lhs_fneg_rhs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    s_mov_b32 s4, 0x80008000
; GFX8-NEXT:    v_xor_b32_e32 v0, s4, v0
; GFX8-NEXT:    v_xor_b32_e32 v1, s4, v1
; GFX8-NEXT:    v_mul_lo_u16_e32 v2, v0, v1
; GFX8-NEXT:    v_mul_lo_u16_sdwa v0, v0, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; GFX8-NEXT:    v_or_b32_e32 v0, v2, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
  %neg.a = fneg <2 x half> %a
  %neg.b = fneg <2 x half> %b
  %cast.neg.a = bitcast <2 x half> %neg.a to <2 x i16>
  %cast.neg.b = bitcast <2 x half> %neg.b to <2 x i16>
  %mul = mul <2 x i16> %cast.neg.a, %cast.neg.b
  ret <2 x i16> %mul
}
