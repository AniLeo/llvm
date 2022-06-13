; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -global-isel=0 -march=amdgcn -mcpu=gfx1100 -verify-machineinstrs < %s | FileCheck %s -check-prefixes=GFX11,GFX11-SDAG
; RUN: llc -global-isel=1 -march=amdgcn -mcpu=gfx1100 -verify-machineinstrs < %s | FileCheck %s -check-prefixes=GFX11,GFX11-GISEL

declare void @llvm.amdgcn.exp.row.i32(i32, i32, i32, i32, i32, i32, i1, i32)
declare void @llvm.amdgcn.exp.row.f32(i32, i32, float, float, float, float, i1, i32)
declare i32 @llvm.amdgcn.workitem.id.x()

define amdgpu_kernel void @undef_i32() #0 {
; GFX11-LABEL: undef_i32:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_mov_b32 m0, 0
; GFX11-NEXT:    exp pos0 off, off, off, off row_en
; GFX11-NEXT:    exp pos1 off, off, off, off done row_en
; GFX11-NEXT:    s_endpgm
  call void @llvm.amdgcn.exp.row.i32(i32 12, i32 0, i32 undef, i32 undef, i32 undef, i32 undef, i1 false, i32 0)
  call void @llvm.amdgcn.exp.row.i32(i32 13, i32 0, i32 undef, i32 undef, i32 undef, i32 undef, i1 true, i32 0)
  ret void
}

define amdgpu_kernel void @undef_f32() #0 {
; GFX11-LABEL: undef_f32:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_mov_b32 m0, 0
; GFX11-NEXT:    exp pos0 off, off, off, off row_en
; GFX11-NEXT:    exp pos1 off, off, off, off done row_en
; GFX11-NEXT:    s_endpgm
  call void @llvm.amdgcn.exp.row.f32(i32 12, i32 0, float undef, float undef, float undef, float undef, i1 false, i32 0)
  call void @llvm.amdgcn.exp.row.f32(i32 13, i32 0, float undef, float undef, float undef, float undef, i1 true, i32 0)
  ret void
}

define amdgpu_kernel void @zero_i32() #0 {
; GFX11-LABEL: zero_i32:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    v_mov_b32_e32 v0, 0
; GFX11-NEXT:    s_mov_b32 m0, 0
; GFX11-NEXT:    exp pos0 v0, v0, v0, off row_en
; GFX11-NEXT:    exp pos1 v0, v0, v0, off done row_en
; GFX11-NEXT:    s_endpgm
  call void @llvm.amdgcn.exp.row.i32(i32 12, i32 7, i32 0, i32 0, i32 0, i32 undef, i1 false, i32 0)
  call void @llvm.amdgcn.exp.row.i32(i32 13, i32 7, i32 0, i32 0, i32 0, i32 undef, i1 true, i32 0)
  ret void
}

define amdgpu_kernel void @one_f32() #0 {
; GFX11-LABEL: one_f32:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    v_mov_b32_e32 v0, 1.0
; GFX11-NEXT:    s_mov_b32 m0, 0
; GFX11-NEXT:    exp pos0 v0, v0, v0, off row_en
; GFX11-NEXT:    exp pos1 v0, v0, v0, off done row_en
; GFX11-NEXT:    s_endpgm
  call void @llvm.amdgcn.exp.row.f32(i32 12, i32 7, float 1.0, float 1.0, float 1.0, float undef, i1 false, i32 0)
  call void @llvm.amdgcn.exp.row.f32(i32 13, i32 7, float 1.0, float 1.0, float 1.0, float undef, i1 true, i32 0)
  ret void
}

define amdgpu_kernel void @id_i32() #0 {
; GFX11-LABEL: id_i32:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_mov_b32 m0, 0
; GFX11-NEXT:    exp pos0 v0, off, off, off done row_en
; GFX11-NEXT:    s_endpgm
  %id = call i32 @llvm.amdgcn.workitem.id.x()
  call void @llvm.amdgcn.exp.row.i32(i32 12, i32 1, i32 %id, i32 undef, i32 undef, i32 undef, i1 true, i32 0)
  ret void
}

define amdgpu_kernel void @id_arg_i32(i32 %row) #0 {
; GFX11-LABEL: id_arg_i32:
; GFX11:       ; %bb.0:
; GFX11-NEXT:    s_load_b32 s0, s[0:1], 0x24
; GFX11-NEXT:    s_waitcnt lgkmcnt(0)
; GFX11-NEXT:    s_mov_b32 m0, s0
; GFX11-NEXT:    exp pos0 v0, off, off, off done row_en
; GFX11-NEXT:    s_endpgm
  %id = call i32 @llvm.amdgcn.workitem.id.x()
  call void @llvm.amdgcn.exp.row.i32(i32 12, i32 1, i32 %id, i32 undef, i32 undef, i32 undef, i1 true, i32 %row)
  ret void
}

; Divergent row number just causes a readfirstlane for now.
define amdgpu_kernel void @id_row_i32() #0 {
; GFX11-SDAG-LABEL: id_row_i32:
; GFX11-SDAG:       ; %bb.0:
; GFX11-SDAG-NEXT:    v_readfirstlane_b32 s0, v0
; GFX11-SDAG-NEXT:    v_mov_b32_e32 v0, 0x63
; GFX11-SDAG-NEXT:    s_mov_b32 m0, s0
; GFX11-SDAG-NEXT:    exp pos0 v0, off, off, off done row_en
; GFX11-SDAG-NEXT:    s_endpgm
;
; GFX11-GISEL-LABEL: id_row_i32:
; GFX11-GISEL:       ; %bb.0:
; GFX11-GISEL-NEXT:    v_mov_b32_e32 v1, 0x63
; GFX11-GISEL-NEXT:    v_readfirstlane_b32 m0, v0
; GFX11-GISEL-NEXT:    exp pos0 v1, off, off, off done row_en
; GFX11-GISEL-NEXT:    s_endpgm
  %id = call i32 @llvm.amdgcn.workitem.id.x()
  call void @llvm.amdgcn.exp.row.i32(i32 12, i32 1, i32 99, i32 undef, i32 undef, i32 undef, i1 true, i32 %id)
  ret void
}
