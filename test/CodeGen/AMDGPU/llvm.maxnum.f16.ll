; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=tahiti -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GCN,SI,SIVI %s
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=fiji -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GCN,VI,GFX89,SIVI %s
; RUN: llc -amdgpu-scalarize-global-loads=false -march=amdgcn -mcpu=gfx900 -mattr=-flat-for-global -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefixes=GCN,GFX9,GFX89 %s

declare half @llvm.maxnum.f16(half %a, half %b)
declare <2 x half> @llvm.maxnum.v2f16(<2 x half> %a, <2 x half> %b)
declare <3 x half> @llvm.maxnum.v3f16(<3 x half> %a, <3 x half> %b)
declare <4 x half> @llvm.maxnum.v4f16(<4 x half> %a, <4 x half> %b)

; GCN-LABEL: {{^}}maxnum_f16:
; GCN: buffer_load_ushort v[[A_F16:[0-9]+]]
; GCN: buffer_load_ushort v[[B_F16:[0-9]+]]
; SI:  v_cvt_f32_f16_e32 v[[A_F32:[0-9]+]], v[[A_F16]]
; SI:  v_cvt_f32_f16_e32 v[[B_F32:[0-9]+]], v[[B_F16]]
; SI:  v_max_f32_e32 v[[R_F32:[0-9]+]], v[[A_F32]], v[[B_F32]]
; SI:  v_cvt_f16_f32_e32 v[[R_F16:[0-9]+]], v[[R_F32]]
; GFX89: v_max_f16_e32 v[[R_F16:[0-9]+]], v[[A_F16]], v[[B_F16]]
; GCN: buffer_store_short v[[R_F16]]
; GCN: s_endpgm
define amdgpu_kernel void @maxnum_f16(
    half addrspace(1)* %r,
    half addrspace(1)* %a,
    half addrspace(1)* %b) {
entry:
  %a.val = load half, half addrspace(1)* %a
  %b.val = load half, half addrspace(1)* %b
  %r.val = call half @llvm.maxnum.f16(half %a.val, half %b.val)
  store half %r.val, half addrspace(1)* %r
  ret void
}

; GCN-LABEL: {{^}}maxnum_f16_imm_a:
; GCN: buffer_load_ushort v[[B_F16:[0-9]+]]
; SI:  v_cvt_f32_f16_e32 v[[B_F32:[0-9]+]], v[[B_F16]]
; SI:  v_max_f32_e32 v[[R_F32:[0-9]+]], 0x40400000, v[[B_F32]]
; SI:  v_cvt_f16_f32_e32 v[[R_F16:[0-9]+]], v[[R_F32]]
; GFX89: v_max_f16_e32 v[[R_F16:[0-9]+]], 0x4200, v[[B_F16]]
; GCN: buffer_store_short v[[R_F16]]
; GCN: s_endpgm
define amdgpu_kernel void @maxnum_f16_imm_a(
    half addrspace(1)* %r,
    half addrspace(1)* %b) {
entry:
  %b.val = load half, half addrspace(1)* %b
  %r.val = call half @llvm.maxnum.f16(half 3.0, half %b.val)
  store half %r.val, half addrspace(1)* %r
  ret void
}

; GCN-LABEL: {{^}}maxnum_f16_imm_b:
; GCN: buffer_load_ushort v[[A_F16:[0-9]+]]
; SI:  v_cvt_f32_f16_e32 v[[A_F32:[0-9]+]], v[[A_F16]]
; SI:  v_max_f32_e32 v[[R_F32:[0-9]+]], 4.0, v[[A_F32]]
; SI:  v_cvt_f16_f32_e32 v[[R_F16:[0-9]+]], v[[R_F32]]
; GFX89: v_max_f16_e32 v[[R_F16:[0-9]+]], 4.0, v[[A_F16]]
; GCN: buffer_store_short v[[R_F16]]
; GCN: s_endpgm
define amdgpu_kernel void @maxnum_f16_imm_b(
    half addrspace(1)* %r,
    half addrspace(1)* %a) {
entry:
  %a.val = load half, half addrspace(1)* %a
  %r.val = call half @llvm.maxnum.f16(half %a.val, half 4.0)
  store half %r.val, half addrspace(1)* %r
  ret void
}

; GCN-LABEL: {{^}}maxnum_v2f16:
; GCN: buffer_load_dword v[[A_V2_F16:[0-9]+]]
; GCN: buffer_load_dword v[[B_V2_F16:[0-9]+]]

; SI:  v_cvt_f32_f16_e32 v[[A_F32_0:[0-9]+]], v[[A_V2_F16]]
; SI: v_lshrrev_b32_e32 v[[A_F16_1:[0-9]+]], 16, v[[A_V2_F16]]
; SI:  v_cvt_f32_f16_e32 v[[B_F32_0:[0-9]+]], v[[B_V2_F16]]
; SI: v_lshrrev_b32_e32 v[[B_F16_1:[0-9]+]], 16, v[[B_V2_F16]]

; SI:  v_cvt_f32_f16_e32 v[[A_F32_1:[0-9]+]], v[[A_F16_1]]
; SI:  v_cvt_f32_f16_e32 v[[B_F32_1:[0-9]+]], v[[B_F16_1]]
; SI:  v_max_f32_e32 v[[R_F32_0:[0-9]+]], v[[A_F32_0]], v[[B_F32_0]]
; SI-DAG: v_max_f32_e32 v[[R_F32_1:[0-9]+]], v[[A_F32_1]], v[[B_F32_1]]
; SI-DAG: v_cvt_f16_f32_e32 v[[R_F16_0:[0-9]+]], v[[R_F32_0]]
; SI-DAG: v_cvt_f16_f32_e32 v[[R_F16_1:[0-9]+]], v[[R_F32_1]]
; SI:     v_lshlrev_b32_e32 v[[R_F16_HI:[0-9]+]], 16, v[[R_F16_1]]
; SI-NOT: and
; SI: v_or_b32_e32 v[[R_V2_F16:[0-9]+]], v[[R_F16_0]], v[[R_F16_HI]]

; VI-DAG: v_max_f16_e32 v[[R_F16_0:[0-9]+]], v[[A_V2_F16]], v[[B_V2_F16]]
; VI-DAG: v_max_f16_sdwa v[[R_F16_1:[0-9]+]], v[[A_V2_F16]], v[[B_V2_F16]] dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:WORD_1
; VI-NOT: and
; VI:    v_or_b32_e32 v[[R_V2_F16:[0-9]+]], v[[R_F16_0]], v[[R_F16_1]]

; GFX9: v_pk_max_f16 v[[R_V2_F16:[0-9]+]], v[[A_V2_F16]], v[[B_V2_F16]]

; GCN: buffer_store_dword v[[R_V2_F16]]
; GCN: s_endpgm
define amdgpu_kernel void @maxnum_v2f16(
    <2 x half> addrspace(1)* %r,
    <2 x half> addrspace(1)* %a,
    <2 x half> addrspace(1)* %b) {
entry:
  %a.val = load <2 x half>, <2 x half> addrspace(1)* %a
  %b.val = load <2 x half>, <2 x half> addrspace(1)* %b
  %r.val = call <2 x half> @llvm.maxnum.v2f16(<2 x half> %a.val, <2 x half> %b.val)
  store <2 x half> %r.val, <2 x half> addrspace(1)* %r
  ret void
}

; GCN-LABEL: {{^}}maxnum_v2f16_imm_a:
; GCN-DAG: buffer_load_dword v[[B_V2_F16:[0-9]+]]
; SI:  v_cvt_f32_f16_e32 v[[B_F32_0:[0-9]+]], v[[B_V2_F16]]
; SI:  v_lshrrev_b32_e32 v[[B_F16_1:[0-9]+]], 16, v[[B_V2_F16]]
; SI:  v_cvt_f32_f16_e32 v[[B_F32_1:[0-9]+]], v[[B_F16_1]]
; SI:  v_max_f32_e32 v[[R_F32_0:[0-9]+]], 0x40400000, v[[B_F32_0]]
; SI:  v_cvt_f16_f32_e32 v[[R_F16_0:[0-9]+]], v[[R_F32_0]]
; SI:  v_max_f32_e32 v[[R_F32_1:[0-9]+]], 4.0, v[[B_F32_1]]
; SI:  v_cvt_f16_f32_e32 v[[R_F16_1:[0-9]+]], v[[R_F32_1]]
; VI-DAG:  v_mov_b32_e32 [[CONST4:v[0-9]+]], 0x4400
; VI-DAG:  v_max_f16_sdwa v[[R_F16_HI:[0-9]+]], v[[B_V2_F16]], [[CONST4]] dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; VI-DAG:  v_max_f16_e32 v[[R_F16_0:[0-9]+]], 0x4200, v[[B_V2_F16]]

; SI-DAG: v_lshlrev_b32_e32 v[[R_F16_HI:[0-9]+]], 16, v[[R_F16_1]]
; SIVI-NOT: and
; SIVI:  v_or_b32_e32 v[[R_V2_F16:[0-9]+]], v[[R_F16_0]], v[[R_F16_HI]]


; GFX9: s_mov_b32 [[K:s[0-9]+]], 0x44004200
; GFX9: v_pk_max_f16 v[[R_V2_F16:[0-9]+]], v[[B_V2_F16]], [[K]]

; GCN: buffer_store_dword v[[R_V2_F16]]
; GCN: s_endpgm
define amdgpu_kernel void @maxnum_v2f16_imm_a(
    <2 x half> addrspace(1)* %r,
    <2 x half> addrspace(1)* %b) {
entry:
  %b.val = load <2 x half>, <2 x half> addrspace(1)* %b
  %r.val = call <2 x half> @llvm.maxnum.v2f16(<2 x half> <half 3.0, half 4.0>, <2 x half> %b.val)
  store <2 x half> %r.val, <2 x half> addrspace(1)* %r
  ret void
}

; GCN-LABEL: {{^}}maxnum_v2f16_imm_b:
; GCN-DAG: buffer_load_dword v[[A_V2_F16:[0-9]+]]
; SI:  v_cvt_f32_f16_e32 v[[A_F32_0:[0-9]+]], v[[A_V2_F16]]
; SI:  v_lshrrev_b32_e32 v[[A_F16_1:[0-9]+]], 16, v[[A_V2_F16]]
; SI:  v_cvt_f32_f16_e32 v[[A_F32_1:[0-9]+]], v[[A_F16_1]]
; SI:  v_max_f32_e32 v[[R_F32_0:[0-9]+]], 4.0, v[[A_F32_0]]
; SI:  v_cvt_f16_f32_e32 v[[R_F16_0:[0-9]+]], v[[R_F32_0]]
; SI:  v_max_f32_e32 v[[R_F32_1:[0-9]+]], 0x40400000, v[[A_F32_1]]
; SI:  v_cvt_f16_f32_e32 v[[R_F16_1:[0-9]+]], v[[R_F32_1]]

; VI-DAG:  v_mov_b32_e32 [[CONST3:v[0-9]+]], 0x4200
; VI-DAG:  v_max_f16_sdwa v[[R_F16_HI:[0-9]+]], v[[A_V2_F16]], [[CONST3]] dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; VI-DAG:  v_max_f16_e32 v[[R_F16_0:[0-9]+]], 4.0, v[[A_V2_F16]]

; SI-DAG: v_lshlrev_b32_e32 v[[R_F16_HI:[0-9]+]], 16, v[[R_F16_1]]


; SIVI-NOT: and
; SIVI: v_or_b32_e32 v[[R_V2_F16:[0-9]+]], v[[R_F16_0]], v[[R_F16_HI]]

; GFX9: s_mov_b32 [[K:s[0-9]+]], 0x42004400
; GFX9: v_pk_max_f16 v[[R_V2_F16:[0-9]+]], v[[A_V2_F16]], [[K]]

; GCN: buffer_store_dword v[[R_V2_F16]]
; GCN: s_endpgm
define amdgpu_kernel void @maxnum_v2f16_imm_b(
    <2 x half> addrspace(1)* %r,
    <2 x half> addrspace(1)* %a) {
entry:
  %a.val = load <2 x half>, <2 x half> addrspace(1)* %a
  %r.val = call <2 x half> @llvm.maxnum.v2f16(<2 x half> %a.val, <2 x half> <half 4.0, half 3.0>)
  store <2 x half> %r.val, <2 x half> addrspace(1)* %r
  ret void
}

; FIXME: Scalarize with undef half
; GCN-LABEL: {{^}}maxnum_v3f16:
; GFX9: v_pk_max_f16
; GFX9: v_pk_max_f16
define amdgpu_kernel void @maxnum_v3f16(
    <3 x half> addrspace(1)* %r,
    <3 x half> addrspace(1)* %a,
    <3 x half> addrspace(1)* %b) {
entry:
  %a.val = load <3 x half>, <3 x half> addrspace(1)* %a
  %b.val = load <3 x half>, <3 x half> addrspace(1)* %b
  %r.val = call <3 x half> @llvm.maxnum.v3f16(<3 x half> %a.val, <3 x half> %b.val)
  store <3 x half> %r.val, <3 x half> addrspace(1)* %r
  ret void
}

; GCN-LABEL: {{^}}maxnum_v4f16:
; GFX89: buffer_load_dwordx2 v{{\[}}[[A_LO:[0-9]+]]:[[A_HI:[0-9]+]]{{\]}}
; GFX89: buffer_load_dwordx2 v{{\[}}[[B_LO:[0-9]+]]:[[B_HI:[0-9]+]]{{\]}}
; GFX9-DAG: v_pk_max_f16 v[[MAX_LO:[0-9]+]], v[[A_LO]], v[[B_LO]]
; GFX9-DAG: v_pk_max_f16 v[[MAX_HI:[0-9]+]], v[[A_HI]], v[[B_HI]]
; GFX9: buffer_store_dwordx2 v{{\[}}[[MAX_LO]]:[[MAX_HI]]{{\]}}
define amdgpu_kernel void @maxnum_v4f16(
    <4 x half> addrspace(1)* %r,
    <4 x half> addrspace(1)* %a,
    <4 x half> addrspace(1)* %b) {
entry:
  %a.val = load <4 x half>, <4 x half> addrspace(1)* %a
  %b.val = load <4 x half>, <4 x half> addrspace(1)* %b
  %r.val = call <4 x half> @llvm.maxnum.v4f16(<4 x half> %a.val, <4 x half> %b.val)
  store <4 x half> %r.val, <4 x half> addrspace(1)* %r
  ret void
}

; GCN-LABEL: {{^}}fmax_v4f16_imm_a:
; GFX89-DAG: buffer_load_dwordx2 v{{\[}}[[A_LO:[0-9]+]]:[[A_HI:[0-9]+]]{{\]}}
; GFX9-DAG: s_mov_b32 [[K1:s[0-9]+]], 0x44004200
; GFX9-DAG: s_mov_b32 [[K0:s[0-9]+]], 0x40004800

; GFX9-DAG: v_pk_max_f16 v[[MAX_LO:[0-9]+]], v[[A_LO]], [[K0]]
; GFX9-DAG: v_pk_max_f16 v[[MAX_HI:[0-9]+]], v[[A_HI]], [[K1]]
; GFX9: buffer_store_dwordx2 v{{\[}}[[MAX_LO]]:[[MAX_HI]]{{\]}}

; VI-DAG: v_mov_b32_e32 [[K2:v[0-9]+]], 0x4000
; VI-DAG: v_mov_b32_e32 [[K4:v[0-9]+]], 0x4400

; VI-DAG: v_max_f16_sdwa v[[MAX_HI_HI:[0-9]+]], v[[A_HI]], [[K4]] dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; VI-DAG: v_max_f16_e32 v[[MAX_HI_LO:[0-9]+]], 0x4200, v[[A_HI]]
; VI-DAG: v_max_f16_sdwa v[[MAX_LO_HI:[0-9]+]], v[[A_LO]], [[K2]] dst_sel:WORD_1 dst_unused:UNUSED_PAD src0_sel:WORD_1 src1_sel:DWORD
; VI-DAG: v_max_f16_e32 v[[MAX_LO_LO:[0-9]+]], 0x4800, v[[A_LO]]

; VI-DAG: v_or_b32_e32 v[[OR0:[0-9]+]], v[[MAX_LO_LO]], v[[MAX_LO_HI]]
; VI-DAG: v_or_b32_e32 v[[OR1:[0-9]+]], v[[MAX_HI_LO]], v[[MAX_HI_HI]]

; VI: buffer_store_dwordx2 v{{\[}}[[OR0]]:[[OR1]]{{\]}}
define amdgpu_kernel void @fmax_v4f16_imm_a(
    <4 x half> addrspace(1)* %r,
    <4 x half> addrspace(1)* %b) {
entry:
  %b.val = load <4 x half>, <4 x half> addrspace(1)* %b
  %r.val = call <4 x half> @llvm.maxnum.v4f16(<4 x half> <half 8.0, half 2.0, half 3.0, half 4.0>, <4 x half> %b.val)
  store <4 x half> %r.val, <4 x half> addrspace(1)* %r
  ret void
}
