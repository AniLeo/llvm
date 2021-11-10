; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=tahiti -verify-machineinstrs < %s | FileCheck -enable-var-scope --check-prefix=GFX6 %s
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=fiji -verify-machineinstrs < %s | FileCheck -enable-var-scope --check-prefix=GFX8 %s
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -enable-var-scope --check-prefix=GFX9 %s
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -enable-var-scope --check-prefix=GFX10 %s

define amdgpu_kernel void @sin_f16(half addrspace(1)* %r, half addrspace(1)* %a) {
; GFX6-LABEL: sin_f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b32 s6, -1
; GFX6-NEXT:    s_mov_b32 s10, s6
; GFX6-NEXT:    s_mov_b32 s11, s7
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s8, s2
; GFX6-NEXT:    s_mov_b32 s9, s3
; GFX6-NEXT:    buffer_load_ushort v0, off, s[8:11], 0
; GFX6-NEXT:    s_mov_b32 s4, s0
; GFX6-NEXT:    s_mov_b32 s5, s1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_mul_f32_e32 v0, 0x3e22f983, v0
; GFX6-NEXT:    v_fract_f32_e32 v0, v0
; GFX6-NEXT:    v_sin_f32_e32 v0, v0
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    buffer_store_short v0, off, s[4:7], 0
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: sin_f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    flat_load_ushort v0, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_mul_f16_e32 v0, 0.15915494, v0
; GFX8-NEXT:    v_fract_f16_e32 v0, v0
; GFX8-NEXT:    v_sin_f16_e32 v2, v0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    flat_store_short v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: sin_f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_ushort v1, v0, s[2:3]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mul_f16_e32 v1, 0.15915494, v1
; GFX9-NEXT:    v_sin_f16_e32 v1, v1
; GFX9-NEXT:    global_store_short v0, v1, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: sin_f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_load_ushort v1, v0, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mul_f16_e32 v1, 0.15915494, v1
; GFX10-NEXT:    v_sin_f16_e32 v1, v1
; GFX10-NEXT:    global_store_short v0, v1, s[0:1]
; GFX10-NEXT:    s_endpgm
  %a.val = load half, half addrspace(1)* %a
  %r.val = call half @llvm.sin.f16(half %a.val)
  store half %r.val, half addrspace(1)* %r
  ret void
}

define amdgpu_kernel void @sin_v2f16(<2 x half> addrspace(1)* %r, <2 x half> addrspace(1)* %a) {
; GFX6-LABEL: sin_v2f16:
; GFX6:       ; %bb.0:
; GFX6-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x9
; GFX6-NEXT:    s_mov_b32 s7, 0xf000
; GFX6-NEXT:    s_mov_b32 s6, -1
; GFX6-NEXT:    s_mov_b32 s10, s6
; GFX6-NEXT:    s_mov_b32 s11, s7
; GFX6-NEXT:    s_waitcnt lgkmcnt(0)
; GFX6-NEXT:    s_mov_b32 s8, s2
; GFX6-NEXT:    s_mov_b32 s9, s3
; GFX6-NEXT:    buffer_load_dword v0, off, s[8:11], 0
; GFX6-NEXT:    s_mov_b32 s2, 0x3e22f983
; GFX6-NEXT:    s_mov_b32 s4, s0
; GFX6-NEXT:    s_mov_b32 s5, s1
; GFX6-NEXT:    s_waitcnt vmcnt(0)
; GFX6-NEXT:    v_cvt_f32_f16_e32 v1, v0
; GFX6-NEXT:    v_lshrrev_b32_e32 v0, 16, v0
; GFX6-NEXT:    v_cvt_f32_f16_e32 v0, v0
; GFX6-NEXT:    v_mul_f32_e32 v1, s2, v1
; GFX6-NEXT:    v_fract_f32_e32 v1, v1
; GFX6-NEXT:    v_mul_f32_e32 v0, s2, v0
; GFX6-NEXT:    v_fract_f32_e32 v0, v0
; GFX6-NEXT:    v_sin_f32_e32 v0, v0
; GFX6-NEXT:    v_sin_f32_e32 v1, v1
; GFX6-NEXT:    v_cvt_f16_f32_e32 v0, v0
; GFX6-NEXT:    v_cvt_f16_f32_e32 v1, v1
; GFX6-NEXT:    v_lshlrev_b32_e32 v0, 16, v0
; GFX6-NEXT:    v_or_b32_e32 v0, v1, v0
; GFX6-NEXT:    buffer_store_dword v0, off, s[4:7], 0
; GFX6-NEXT:    s_endpgm
;
; GFX8-LABEL: sin_v2f16:
; GFX8:       ; %bb.0:
; GFX8-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX8-NEXT:    s_waitcnt lgkmcnt(0)
; GFX8-NEXT:    v_mov_b32_e32 v0, s2
; GFX8-NEXT:    v_mov_b32_e32 v1, s3
; GFX8-NEXT:    flat_load_dword v0, v[0:1]
; GFX8-NEXT:    v_mov_b32_e32 v1, 0x3118
; GFX8-NEXT:    s_waitcnt vmcnt(0)
; GFX8-NEXT:    v_mul_f16_sdwa v1, v0, v1 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; GFX8-NEXT:    v_mul_f16_e32 v0, 0.15915494, v0
; GFX8-NEXT:    v_fract_f16_e32 v1, v1
; GFX8-NEXT:    v_fract_f16_e32 v0, v0
; GFX8-NEXT:    v_sin_f16_sdwa v2, v1 dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:DWORD
; GFX8-NEXT:    v_sin_f16_e32 v3, v0
; GFX8-NEXT:    v_mov_b32_e32 v0, s0
; GFX8-NEXT:    v_mov_b32_e32 v1, s1
; GFX8-NEXT:    v_or_b32_e32 v2, v3, v2
; GFX8-NEXT:    flat_store_dword v[0:1], v2
; GFX8-NEXT:    s_endpgm
;
; GFX9-LABEL: sin_v2f16:
; GFX9:       ; %bb.0:
; GFX9-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX9-NEXT:    v_mov_b32_e32 v0, 0
; GFX9-NEXT:    v_mov_b32_e32 v2, 0x3118
; GFX9-NEXT:    s_waitcnt lgkmcnt(0)
; GFX9-NEXT:    global_load_dword v1, v0, s[2:3]
; GFX9-NEXT:    s_waitcnt vmcnt(0)
; GFX9-NEXT:    v_mul_f16_e32 v3, 0.15915494, v1
; GFX9-NEXT:    v_mul_f16_sdwa v1, v1, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; GFX9-NEXT:    v_sin_f16_e32 v2, v3
; GFX9-NEXT:    v_sin_f16_e32 v1, v1
; GFX9-NEXT:    v_pack_b32_f16 v1, v2, v1
; GFX9-NEXT:    global_store_dword v0, v1, s[0:1]
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: sin_v2f16:
; GFX10:       ; %bb.0:
; GFX10-NEXT:    s_load_dwordx4 s[0:3], s[0:1], 0x24
; GFX10-NEXT:    v_mov_b32_e32 v0, 0
; GFX10-NEXT:    v_mov_b32_e32 v2, 0x3118
; GFX10-NEXT:    s_waitcnt lgkmcnt(0)
; GFX10-NEXT:    global_load_dword v1, v0, s[2:3]
; GFX10-NEXT:    s_waitcnt vmcnt(0)
; GFX10-NEXT:    v_mul_f16_e32 v3, 0.15915494, v1
; GFX10-NEXT:    v_mul_f16_sdwa v1, v1, v2 dst_sel:DWORD dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; GFX10-NEXT:    v_sin_f16_e32 v2, v3
; GFX10-NEXT:    v_sin_f16_e32 v1, v1
; GFX10-NEXT:    v_pack_b32_f16 v1, v2, v1
; GFX10-NEXT:    global_store_dword v0, v1, s[0:1]
; GFX10-NEXT:    s_endpgm
  %a.val = load <2 x half>, <2 x half> addrspace(1)* %a
  %r.val = call <2 x half> @llvm.sin.v2f16(<2 x half> %a.val)
  store <2 x half> %r.val, <2 x half> addrspace(1)* %r
  ret void
}

declare half @llvm.sin.f16(half %a)
declare <2 x half> @llvm.sin.v2f16(<2 x half> %a)
