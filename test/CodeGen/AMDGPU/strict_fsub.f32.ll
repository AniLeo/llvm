; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 < %s | FileCheck -check-prefix=GCN %s
; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 < %s | FileCheck -check-prefix=GFX10 %s

define float @v_constained_fsub_f32_fpexcept_strict(float %x, float %y) #0 {
; GCN-LABEL: v_constained_fsub_f32_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_f32_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e32 v0, v0, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call float @llvm.experimental.constrained.fsub.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define float @v_constained_fsub_f32_fpexcept_ignore(float %x, float %y) #0 {
; GCN-LABEL: v_constained_fsub_f32_fpexcept_ignore:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_f32_fpexcept_ignore:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e32 v0, v0, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call float @llvm.experimental.constrained.fsub.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret float %val
}

define float @v_constained_fsub_f32_fpexcept_maytrap(float %x, float %y) #0 {
; GCN-LABEL: v_constained_fsub_f32_fpexcept_maytrap:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e32 v0, v0, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_f32_fpexcept_maytrap:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e32 v0, v0, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call float @llvm.experimental.constrained.fsub.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
  ret float %val
}

define <2 x float> @v_constained_fsub_v2f32_fpexcept_strict(<2 x float> %x, <2 x float> %y) #0 {
; GCN-LABEL: v_constained_fsub_v2f32_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e32 v0, v0, v2
; GCN-NEXT:    v_sub_f32_e32 v1, v1, v3
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_v2f32_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e32 v0, v0, v2
; GFX10-NEXT:    v_sub_f32_e32 v1, v1, v3
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float> %x, <2 x float> %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <2 x float> %val
}

define <2 x float> @v_constained_fsub_v2f32_fpexcept_ignore(<2 x float> %x, <2 x float> %y) #0 {
; GCN-LABEL: v_constained_fsub_v2f32_fpexcept_ignore:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e32 v0, v0, v2
; GCN-NEXT:    v_sub_f32_e32 v1, v1, v3
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_v2f32_fpexcept_ignore:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e32 v0, v0, v2
; GFX10-NEXT:    v_sub_f32_e32 v1, v1, v3
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float> %x, <2 x float> %y, metadata !"round.tonearest", metadata !"fpexcept.ignore")
  ret <2 x float> %val
}

define <2 x float> @v_constained_fsub_v2f32_fpexcept_maytrap(<2 x float> %x, <2 x float> %y) #0 {
; GCN-LABEL: v_constained_fsub_v2f32_fpexcept_maytrap:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e32 v0, v0, v2
; GCN-NEXT:    v_sub_f32_e32 v1, v1, v3
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_v2f32_fpexcept_maytrap:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e32 v0, v0, v2
; GFX10-NEXT:    v_sub_f32_e32 v1, v1, v3
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float> %x, <2 x float> %y, metadata !"round.tonearest", metadata !"fpexcept.maytrap")
  ret <2 x float> %val
}

define <3 x float> @v_constained_fsub_v3f32_fpexcept_strict(<3 x float> %x, <3 x float> %y) #0 {
; GCN-LABEL: v_constained_fsub_v3f32_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e32 v0, v0, v3
; GCN-NEXT:    v_sub_f32_e32 v1, v1, v4
; GCN-NEXT:    v_sub_f32_e32 v2, v2, v5
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_v3f32_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e32 v0, v0, v3
; GFX10-NEXT:    v_sub_f32_e32 v1, v1, v4
; GFX10-NEXT:    v_sub_f32_e32 v2, v2, v5
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %val = call <3 x float> @llvm.experimental.constrained.fsub.v3f32(<3 x float> %x, <3 x float> %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret <3 x float> %val
}

define amdgpu_ps float @s_constained_fsub_f32_fpexcept_strict(float inreg %x, float inreg %y) #0 {
; GCN-LABEL: s_constained_fsub_f32_fpexcept_strict:
; GCN:       ; %bb.0:
; GCN-NEXT:    v_mov_b32_e32 v0, s3
; GCN-NEXT:    v_sub_f32_e32 v0, s2, v0
; GCN-NEXT:    ; return to shader part epilog
;
; GFX10-LABEL: s_constained_fsub_f32_fpexcept_strict:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    v_sub_f32_e64 v0, s2, s3
; GFX10-NEXT:    ; return to shader part epilog
  %val = call float @llvm.experimental.constrained.fsub.f32(float %x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define float @v_constained_fsub_f32_fpexcept_strict_fabs_lhs(float %x, float %y) #0 {
; GCN-LABEL: v_constained_fsub_f32_fpexcept_strict_fabs_lhs:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e64 v0, |v0|, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_f32_fpexcept_strict_fabs_lhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e64 v0, |v0|, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fabs.x = call float @llvm.fabs.f32(float %x)
  %val = call float @llvm.experimental.constrained.fsub.f32(float %fabs.x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define float @v_constained_fsub_f32_fpexcept_strict_fabs_rhs(float %x, float %y) #0 {
; GCN-LABEL: v_constained_fsub_f32_fpexcept_strict_fabs_rhs:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e64 v0, v0, |v1|
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_f32_fpexcept_strict_fabs_rhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e64 v0, v0, |v1|
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fabs.y = call float @llvm.fabs.f32(float %y)
  %val = call float @llvm.experimental.constrained.fsub.f32(float %x, float %fabs.y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

define float @v_constained_fsub_f32_fpexcept_strict_fneg_fabs_lhs(float %x, float %y) #0 {
; GCN-LABEL: v_constained_fsub_f32_fpexcept_strict_fneg_fabs_lhs:
; GCN:       ; %bb.0:
; GCN-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GCN-NEXT:    v_sub_f32_e64 v0, -|v0|, v1
; GCN-NEXT:    s_setpc_b64 s[30:31]
;
; GFX10-LABEL: v_constained_fsub_f32_fpexcept_strict_fneg_fabs_lhs:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; GFX10-NEXT:    s_waitcnt_vscnt null, 0x0
; GFX10-NEXT:    v_sub_f32_e64 v0, -|v0|, v1
; GFX10-NEXT:    s_setpc_b64 s[30:31]
  %fabs.x = call float @llvm.fabs.f32(float %x)
  %neg.fabs.x = fneg float %fabs.x
  %val = call float @llvm.experimental.constrained.fsub.f32(float %neg.fabs.x, float %y, metadata !"round.tonearest", metadata !"fpexcept.strict")
  ret float %val
}

declare float @llvm.fabs.f32(float) #1
declare float @llvm.experimental.constrained.fsub.f32(float, float, metadata, metadata) #1
declare <2 x float> @llvm.experimental.constrained.fsub.v2f32(<2 x float>, <2 x float>, metadata, metadata) #1
declare <3 x float> @llvm.experimental.constrained.fsub.v3f32(<3 x float>, <3 x float>, metadata, metadata) #1

attributes #0 = { strictfp }
attributes #1 = { inaccessiblememonly nounwind willreturn }
