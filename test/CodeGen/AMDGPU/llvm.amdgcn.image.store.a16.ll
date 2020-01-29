; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx900 -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX9 %s
; RUN: llc -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -check-prefixes=GFX10 %s

define amdgpu_ps void @store_f32_1d(<8 x i32> inreg %rsrc, <2 x i16> %coords, <4 x float> %val) {
; GFX9-LABEL: store_f32_1d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x1 unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_f32_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_1D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords, i32 0
  call void @llvm.amdgcn.image.store.1d.v4f32.i16(<4 x float> %val, i32 1, i16 %x, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_v2f32_1d(<8 x i32> inreg %rsrc, <2 x i16> %coords, <4 x float> %val) {
; GFX9-LABEL: store_v2f32_1d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x3 unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_v2f32_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x3 dim:SQ_RSRC_IMG_1D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords, i32 0
  call void @llvm.amdgcn.image.store.1d.v4f32.i16(<4 x float> %val, i32 3, i16 %x, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_v3f32_1d(<8 x i32> inreg %rsrc, <2 x i16> %coords, <4 x float> %val) {
; GFX9-LABEL: store_v3f32_1d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x7 unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_v3f32_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x7 dim:SQ_RSRC_IMG_1D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords, i32 0
  call void @llvm.amdgcn.image.store.1d.v4f32.i16(<4 x float> %val, i32 7, i16 %x, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_v4f32_1d(<8 x i32> inreg %rsrc, <2 x i16> %coords, <4 x float> %val) {
; GFX9-LABEL: store_v4f32_1d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0xf unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_v4f32_1d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_1D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords, i32 0
  call void @llvm.amdgcn.image.store.1d.v4f32.i16(<4 x float> %val, i32 15, i16 %x, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_f32_2d(<8 x i32> inreg %rsrc, <2 x i16> %coords, <4 x float> %val) {
; GFX9-LABEL: store_f32_2d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x1 unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_f32_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_2D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords, i32 0
  %y = extractelement <2 x i16> %coords, i32 1
  call void @llvm.amdgcn.image.store.2d.v4f32.i16(<4 x float> %val, i32 1, i16 %x, i16 %y, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_v2f32_2d(<8 x i32> inreg %rsrc, <2 x i16> %coords, <4 x float> %val) {
; GFX9-LABEL: store_v2f32_2d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x3 unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_v2f32_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x3 dim:SQ_RSRC_IMG_2D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords, i32 0
  %y = extractelement <2 x i16> %coords, i32 1
  call void @llvm.amdgcn.image.store.2d.v4f32.i16(<4 x float> %val, i32 3, i16 %x, i16 %y, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_v3f32_2d(<8 x i32> inreg %rsrc, <2 x i16> %coords, <4 x float> %val) {
; GFX9-LABEL: store_v3f32_2d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x7 unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_v3f32_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0x7 dim:SQ_RSRC_IMG_2D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords, i32 0
  %y = extractelement <2 x i16> %coords, i32 1
  call void @llvm.amdgcn.image.store.2d.v4f32.i16(<4 x float> %val, i32 7, i16 %x, i16 %y, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_v4f32_2d(<8 x i32> inreg %rsrc, <2 x i16> %coords, <4 x float> %val) {
; GFX9-LABEL: store_v4f32_2d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0xf unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_v4f32_2d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[1:4], v0, s[0:7] dmask:0xf dim:SQ_RSRC_IMG_2D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords, i32 0
  %y = extractelement <2 x i16> %coords, i32 1
  call void @llvm.amdgcn.image.store.2d.v4f32.i16(<4 x float> %val, i32 15, i16 %x, i16 %y, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_f32_3d(<8 x i32> inreg %rsrc, <2 x i16> %coords_lo, <2 x i16> %coords_hi, <4 x float> %val) {
; GFX9-LABEL: store_f32_3d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x1 unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_f32_3d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x1 dim:SQ_RSRC_IMG_3D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords_lo, i32 0
  %y = extractelement <2 x i16> %coords_lo, i32 1
  %z = extractelement <2 x i16> %coords_hi, i32 0
  call void @llvm.amdgcn.image.store.3d.v4f32.i16(<4 x float> %val, i32 1, i16 %x, i16 %y, i16 %z, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_v2f32_3d(<8 x i32> inreg %rsrc, <2 x i16> %coords_lo, <2 x i16> %coords_hi, <4 x float> %val) {
; GFX9-LABEL: store_v2f32_3d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x3 unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_v2f32_3d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x3 dim:SQ_RSRC_IMG_3D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords_lo, i32 0
  %y = extractelement <2 x i16> %coords_lo, i32 1
  %z = extractelement <2 x i16> %coords_hi, i32 0
  call void @llvm.amdgcn.image.store.3d.v4f32.i16(<4 x float> %val, i32 3, i16 %x, i16 %y, i16 %z, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_v3f32_3d(<8 x i32> inreg %rsrc, <2 x i16> %coords_lo, <2 x i16> %coords_hi, <4 x float> %val) {
; GFX9-LABEL: store_v3f32_3d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x7 unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_v3f32_3d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0x7 dim:SQ_RSRC_IMG_3D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords_lo, i32 0
  %y = extractelement <2 x i16> %coords_lo, i32 1
  %z = extractelement <2 x i16> %coords_hi, i32 0
  call void @llvm.amdgcn.image.store.3d.v4f32.i16(<4 x float> %val, i32 7, i16 %x, i16 %y, i16 %z, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @store_v4f32_3d(<8 x i32> inreg %rsrc, <2 x i16> %coords_lo, <2 x i16> %coords_hi, <4 x float> %val) {
; GFX9-LABEL: store_v4f32_3d:
; GFX9:       ; %bb.0: ; %main_body
; GFX9-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0xf unorm a16
; GFX9-NEXT:    s_endpgm
;
; GFX10-LABEL: store_v4f32_3d:
; GFX10:       ; %bb.0: ; %main_body
; GFX10-NEXT:    ; implicit-def: $vcc_hi
; GFX10-NEXT:    image_store v[2:5], v[0:1], s[0:7] dmask:0xf dim:SQ_RSRC_IMG_3D unorm a16
; GFX10-NEXT:    s_endpgm
main_body:
  %x = extractelement <2 x i16> %coords_lo, i32 0
  %y = extractelement <2 x i16> %coords_lo, i32 1
  %z = extractelement <2 x i16> %coords_hi, i32 0
  call void @llvm.amdgcn.image.store.3d.v4f32.i16(<4 x float> %val, i32 15, i16 %x, i16 %y, i16 %z, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

declare void @llvm.amdgcn.image.store.1d.v4f32.i16(<4 x float>, i32, i16, <8 x i32>, i32, i32) #2
declare void @llvm.amdgcn.image.store.2d.v4f32.i16(<4 x float>, i32, i16, i16, <8 x i32>, i32, i32) #2
declare void @llvm.amdgcn.image.store.3d.v4f32.i16(<4 x float>, i32, i16, i16, i16, <8 x i32>, i32, i32) #2

attributes #0 = { nounwind }
attributes #1 = { nounwind readonly }
