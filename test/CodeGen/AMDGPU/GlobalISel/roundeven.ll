; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=tahiti < %s | FileCheck -check-prefix=GFX6 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=hawaii < %s | FileCheck -check-prefix=GFX7 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=fiji < %s | FileCheck -check-prefix=GFX8 %s
; RUN: llc -global-isel -march=amdgcn -mcpu=gfx900 < %s | FileCheck -check-prefix=GFX9 %s

define float @v_roundeven_f32(float %x) {
; GFX6-LABEL: v_roundeven_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_rndne_f32_e32 v0, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_f32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_rndne_f32_e32 v0, v0
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f32_e32 v0, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f32_e32 v0, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %roundeven = call float @llvm.roundeven.f32(float %x)
  ret float %roundeven
}

define <2 x float> @v_roundeven_v2f32(<2 x float> %x) {
; GFX6-LABEL: v_roundeven_v2f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_rndne_f32_e32 v0, v0
; GFX6-NEXT:    v_rndne_f32_e32 v1, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_v2f32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_rndne_f32_e32 v0, v0
; GFX7-NEXT:    v_rndne_f32_e32 v1, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_v2f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f32_e32 v0, v0
; GFX8-NEXT:    v_rndne_f32_e32 v1, v1
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_v2f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f32_e32 v0, v0
; GFX9-NEXT:    v_rndne_f32_e32 v1, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %roundeven = call <2 x float> @llvm.roundeven.v2f32(<2 x float> %x)
  ret <2 x float> %roundeven
}

define <3 x float> @v_roundeven_v3f32(<3 x float> %x) {
; GFX6-LABEL: v_roundeven_v3f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_rndne_f32_e32 v0, v0
; GFX6-NEXT:    v_rndne_f32_e32 v1, v1
; GFX6-NEXT:    v_rndne_f32_e32 v2, v2
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_v3f32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_rndne_f32_e32 v0, v0
; GFX7-NEXT:    v_rndne_f32_e32 v1, v1
; GFX7-NEXT:    v_rndne_f32_e32 v2, v2
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_v3f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f32_e32 v0, v0
; GFX8-NEXT:    v_rndne_f32_e32 v1, v1
; GFX8-NEXT:    v_rndne_f32_e32 v2, v2
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_v3f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f32_e32 v0, v0
; GFX9-NEXT:    v_rndne_f32_e32 v1, v1
; GFX9-NEXT:    v_rndne_f32_e32 v2, v2
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %roundeven = call <3 x float> @llvm.roundeven.v3f32(<3 x float> %x)
  ret <3 x float> %roundeven
}

define <4 x float> @v_roundeven_v4f32(<4 x float> %x) {
; GFX6-LABEL: v_roundeven_v4f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_rndne_f32_e32 v0, v0
; GFX6-NEXT:    v_rndne_f32_e32 v1, v1
; GFX6-NEXT:    v_rndne_f32_e32 v2, v2
; GFX6-NEXT:    v_rndne_f32_e32 v3, v3
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_v4f32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_rndne_f32_e32 v0, v0
; GFX7-NEXT:    v_rndne_f32_e32 v1, v1
; GFX7-NEXT:    v_rndne_f32_e32 v2, v2
; GFX7-NEXT:    v_rndne_f32_e32 v3, v3
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_v4f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f32_e32 v0, v0
; GFX8-NEXT:    v_rndne_f32_e32 v1, v1
; GFX8-NEXT:    v_rndne_f32_e32 v2, v2
; GFX8-NEXT:    v_rndne_f32_e32 v3, v3
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_v4f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f32_e32 v0, v0
; GFX9-NEXT:    v_rndne_f32_e32 v1, v1
; GFX9-NEXT:    v_rndne_f32_e32 v2, v2
; GFX9-NEXT:    v_rndne_f32_e32 v3, v3
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %roundeven = call <4 x float> @llvm.roundeven.v4f32(<4 x float> %x)
  ret <4 x float> %roundeven
}

define half @v_roundeven_f16(half %x) {
; GFX6-LABEL: v_roundeven_f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_rndne_f32_e32 v0, v0
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_f16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX7-NEXT:    v_rndne_f32_e32 v0, v0
; GFX7-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f16_e32 v0, v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f16_e32 v0, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %roundeven = call half @llvm.roundeven.f16(half %x)
  ret half %roundeven
}

define <2 x half> @v_roundeven_v2f16(<2 x half> %x) {
; GFX6-LABEL: v_roundeven_v2f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v0
; GFX6-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v2, v0
; GFX6-NEXT:    v_rndne_f32_e32 v0, v1
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_rndne_f32_e32 v1, v2
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_v2f16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_cvt_f32_f16_e32 v1, v0
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX7-NEXT:    v_cvt_f32_f16_e32 v2, v0
; GFX7-NEXT:    v_rndne_f32_e32 v0, v1
; GFX7-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX7-NEXT:    v_rndne_f32_e32 v1, v2
; GFX7-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_v2f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f16_e32 v1, v0
; GFX8-NEXT:    v_rndne_f16_sdwa v0, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v2, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v1, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_v2f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f16_e32 v1, v0
; GFX9-NEXT:    v_rndne_f16_sdwa v0, v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-NEXT:    v_mov_b32_e32 v2, 0xffff
; GFX9-NEXT:    v_and_or_b32 v0, v1, v2, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %roundeven = call <2 x half> @llvm.roundeven.v2f16(<2 x half> %x)
  ret <2 x half> %roundeven
}

define <2 x half> @v_roundeven_v2f16_fneg(<2 x half> %x) {
; GFX6-LABEL: v_roundeven_v2f16_fneg:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v0
; GFX6-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v2, v0
; GFX6-NEXT:    v_rndne_f32_e32 v0, v1
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_rndne_f32_e32 v1, v2
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_v2f16_fneg:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX7-NEXT:    v_cvt_f32_f16_e32 v1, v0
; GFX7-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX7-NEXT:    v_cvt_f32_f16_e32 v2, v0
; GFX7-NEXT:    v_rndne_f32_e32 v0, v1
; GFX7-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX7-NEXT:    v_rndne_f32_e32 v1, v2
; GFX7-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_v2f16_fneg:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX8-NEXT:    v_rndne_f16_e32 v1, v0
; GFX8-NEXT:    v_rndne_f16_sdwa v0, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v2, 16
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v1, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_v2f16_fneg:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_xor_b32_e32 v0, 0x80008000, v0
; GFX9-NEXT:    v_rndne_f16_e32 v1, v0
; GFX9-NEXT:    v_rndne_f16_sdwa v0, v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-NEXT:    v_mov_b32_e32 v2, 0xffff
; GFX9-NEXT:    v_and_or_b32 v0, v1, v2, v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %x.fneg = fneg <2 x half> %x
  %roundeven = call <2 x half> @llvm.roundeven.v2f16(<2 x half> %x.fneg)
  ret <2 x half> %roundeven
}

define <4 x half> @v_roundeven_v4f16(<4 x half> %x) {
; GFX6-LABEL: v_roundeven_v4f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX6-NEXT:    v_cvt_f32_f16_e32 v2, v2
; GFX6-NEXT:    v_cvt_f32_f16_e32 v3, v3
; GFX6-NEXT:    v_rndne_f32_e32 v0, v0
; GFX6-NEXT:    v_rndne_f32_e32 v1, v1
; GFX6-NEXT:    v_rndne_f32_e32 v2, v2
; GFX6-NEXT:    v_rndne_f32_e32 v3, v3
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    v_cvt_f16_f32_e32 v2, v2
; GFX6-NEXT:    v_cvt_f16_f32_e32 v3, v3
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_v4f16:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX7-NEXT:    v_cvt_f32_f16_e32 v1, v1
; GFX7-NEXT:    v_cvt_f32_f16_e32 v2, v2
; GFX7-NEXT:    v_cvt_f32_f16_e32 v3, v3
; GFX7-NEXT:    v_rndne_f32_e32 v0, v0
; GFX7-NEXT:    v_rndne_f32_e32 v1, v1
; GFX7-NEXT:    v_rndne_f32_e32 v2, v2
; GFX7-NEXT:    v_rndne_f32_e32 v3, v3
; GFX7-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX7-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX7-NEXT:    v_cvt_f16_f32_e32 v2, v2
; GFX7-NEXT:    v_cvt_f16_f32_e32 v3, v3
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_v4f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f16_e32 v2, v0
; GFX8-NEXT:    v_rndne_f16_e32 v3, v1
; GFX8-NEXT:    v_rndne_f16_sdwa v0, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX8-NEXT:    v_mov_b32_e32 v4, 16
; GFX8-NEXT:    v_rndne_f16_sdwa v1, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX8-NEXT:    v_lshlrev_b32_sdwa v0, v4, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_lshlrev_b32_sdwa v1, v4, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:DWORD src1_sel:WORD_0
; GFX8-NEXT:    v_or_b32_sdwa v0, v2, v0 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    v_or_b32_sdwa v1, v3, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_0 src1_sel:DWORD
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_v4f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f16_e32 v2, v0
; GFX9-NEXT:    v_rndne_f16_e32 v3, v1
; GFX9-NEXT:    v_rndne_f16_sdwa v0, v0 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-NEXT:    v_mov_b32_e32 v4, 0xffff
; GFX9-NEXT:    v_rndne_f16_sdwa v1, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1
; GFX9-NEXT:    v_and_or_b32 v0, v2, v4, v0
; GFX9-NEXT:    v_and_or_b32 v1, v3, v4, v1
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %roundeven = call <4 x half> @llvm.roundeven.v4f16(<4 x half> %x)
  ret <4 x half> %roundeven
}


define float @v_roundeven_f32_fabs(float %x) {
; GFX6-LABEL: v_roundeven_f32_fabs:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_rndne_f32_e64 v0, |v0|
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_f32_fabs:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_rndne_f32_e64 v0, |v0|
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_f32_fabs:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f32_e64 v0, |v0|
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_f32_fabs:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f32_e64 v0, |v0|
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %fabs.x = call float @llvm.fabs.f32(float %x)
  %roundeven = call float @llvm.roundeven.f32(float %fabs.x)
  ret float %roundeven
}

define amdgpu_ps float @s_roundeven_f32(float inreg %x) {
; GFX6-LABEL: s_roundeven_f32:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    v_rndne_f32_e32 v0, s0
; GFX6-NEXT:    ; return to shader part epilog
;
; GFX7-LABEL: s_roundeven_f32:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    v_rndne_f32_e32 v0, s0
; GFX7-NEXT:    ; return to shader part epilog
;
; GFX8-LABEL: s_roundeven_f32:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    v_rndne_f32_e32 v0, s0
; GFX8-NEXT:    ; return to shader part epilog
;
; GFX9-LABEL: s_roundeven_f32:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    v_rndne_f32_e32 v0, s0
; GFX9-NEXT:    ; return to shader part epilog
  %roundeven = call float @llvm.roundeven.f32(float %x)
  ret float %roundeven
}

define float @v_roundeven_f32_fneg(float %x) {
; GFX6-LABEL: v_roundeven_f32_fneg:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_rndne_f32_e64 v0, -v0
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_f32_fneg:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_rndne_f32_e64 v0, -v0
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_f32_fneg:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f32_e64 v0, -v0
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_f32_fneg:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f32_e64 v0, -v0
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %neg.x = fneg float %x
  %roundeven = call float @llvm.roundeven.f32(float %neg.x)
  ret float %roundeven
}

define double @v_roundeven_f64(double %x) {
; GFX6-LABEL: v_roundeven_f64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_and_b32_e32 v3, 0x80000000, v1
; GFX6-NEXT:    v_mov_b32_e32 v2, 0
; GFX6-NEXT:    v_or_b32_e32 v3, 0x43300000, v3
; GFX6-NEXT:    v_add_f64 v[4:5], v[0:1], v[2:3]
; GFX6-NEXT:    s_mov_b32 s4, -1
; GFX6-NEXT:    s_mov_b32 s5, 0x432fffff
; GFX6-NEXT:    v_add_f64 v[2:3], v[4:5], -v[2:3]
; GFX6-NEXT:    v_cmp_gt_f64_e64 vcc, |v[0:1]|, s[4:5]
; GFX6-NEXT:    v_cndmask_b32_e32 v0, v2, v0, vcc
; GFX6-NEXT:    v_cndmask_b32_e32 v1, v3, v1, vcc
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_f64:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_rndne_f64_e32 v[0:1], v[0:1]
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_f64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f64_e32 v[0:1], v[0:1]
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_f64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f64_e32 v[0:1], v[0:1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %roundeven = call double @llvm.roundeven.f64(double %x)
  ret double %roundeven
}

define double @v_roundeven_f64_fneg(double %x) {
; GFX6-LABEL: v_roundeven_f64_fneg:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    v_xor_b32_e32 v2, 0x80000000, v1
; GFX6-NEXT:    v_and_b32_e32 v4, 0x80000000, v2
; GFX6-NEXT:    v_mov_b32_e32 v3, 0
; GFX6-NEXT:    v_or_b32_e32 v4, 0x43300000, v4
; GFX6-NEXT:    v_add_f64 v[5:6], -v[0:1], v[3:4]
; GFX6-NEXT:    v_mov_b32_e32 v1, v0
; GFX6-NEXT:    s_mov_b32 s4, -1
; GFX6-NEXT:    s_mov_b32 s5, 0x432fffff
; GFX6-NEXT:    v_add_f64 v[3:4], v[5:6], -v[3:4]
; GFX6-NEXT:    v_cmp_gt_f64_e64 vcc, |v[1:2]|, s[4:5]
; GFX6-NEXT:    v_cndmask_b32_e32 v0, v3, v0, vcc
; GFX6-NEXT:    v_cndmask_b32_e32 v1, v4, v2, vcc
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_f64_fneg:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_rndne_f64_e64 v[0:1], -v[0:1]
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_f64_fneg:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f64_e64 v[0:1], -v[0:1]
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_f64_fneg:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f64_e64 v[0:1], -v[0:1]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %neg.x = fneg double %x
  %roundeven = call double @llvm.roundeven.f64(double %neg.x)
  ret double %roundeven
}

define <2 x double> @v_roundeven_v2f64(<2 x double> %x) {
; GFX6-LABEL: v_roundeven_v2f64:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX6-NEXT:    s_brev_b32 s6, 1
; GFX6-NEXT:    s_mov_b32 s7, 0x43300000
; GFX6-NEXT:    v_and_b32_e32 v5, s6, v1
; GFX6-NEXT:    v_mov_b32_e32 v4, 0
; GFX6-NEXT:    v_or_b32_e32 v5, s7, v5
; GFX6-NEXT:    v_add_f64 v[6:7], v[0:1], v[4:5]
; GFX6-NEXT:    s_mov_b32 s4, -1
; GFX6-NEXT:    s_mov_b32 s5, 0x432fffff
; GFX6-NEXT:    v_add_f64 v[5:6], v[6:7], -v[4:5]
; GFX6-NEXT:    v_cmp_gt_f64_e64 vcc, |v[0:1]|, s[4:5]
; GFX6-NEXT:    v_cndmask_b32_e32 v0, v5, v0, vcc
; GFX6-NEXT:    v_and_b32_e32 v5, s6, v3
; GFX6-NEXT:    v_or_b32_e32 v5, s7, v5
; GFX6-NEXT:    v_add_f64 v[7:8], v[2:3], v[4:5]
; GFX6-NEXT:    v_cndmask_b32_e32 v1, v6, v1, vcc
; GFX6-NEXT:    v_add_f64 v[4:5], v[7:8], -v[4:5]
; GFX6-NEXT:    v_cmp_gt_f64_e64 vcc, |v[2:3]|, s[4:5]
; GFX6-NEXT:    v_cndmask_b32_e32 v2, v4, v2, vcc
; GFX6-NEXT:    v_cndmask_b32_e32 v3, v5, v3, vcc
; GFX6-NEXT:    s_setpc_b64 s[30:31]
;
; GFX7-LABEL: v_roundeven_v2f64:
; GFX7:       ; %bb.0:
; GFX7-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX7-NEXT:    v_rndne_f64_e32 v[0:1], v[0:1]
; GFX7-NEXT:    v_rndne_f64_e32 v[2:3], v[2:3]
; GFX7-NEXT:    s_setpc_b64 s[30:31]
;
; GFX8-LABEL: v_roundeven_v2f64:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX8-NEXT:    v_rndne_f64_e32 v[0:1], v[0:1]
; GFX8-NEXT:    v_rndne_f64_e32 v[2:3], v[2:3]
; GFX8-NEXT:    s_setpc_b64 s[30:31]
;
; GFX9-LABEL: v_roundeven_v2f64:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX9-NEXT:    v_rndne_f64_e32 v[0:1], v[0:1]
; GFX9-NEXT:    v_rndne_f64_e32 v[2:3], v[2:3]
; GFX9-NEXT:    s_setpc_b64 s[30:31]
  %roundeven = call <2 x double> @llvm.roundeven.v2f64(<2 x double> %x)
  ret <2 x double> %roundeven
}

declare half @llvm.roundeven.f16(half) #0
declare <2 x half> @llvm.roundeven.v2f16(<2 x half>) #0
declare <4 x half> @llvm.roundeven.v4f16(<4 x half>) #0

declare float @llvm.roundeven.f32(float) #0
declare <2 x float> @llvm.roundeven.v2f32(<2 x float>) #0
declare <3 x float> @llvm.roundeven.v3f32(<3 x float>) #0
declare <4 x float> @llvm.roundeven.v4f32(<4 x float>) #0

declare double @llvm.roundeven.f64(double) #0
declare <2 x double> @llvm.roundeven.v2f64(<2 x double>) #0

declare half @llvm.fabs.f16(half) #0
declare float @llvm.fabs.f32(float) #0

attributes #0 = { nounwind readnone speculatable willreturn }
