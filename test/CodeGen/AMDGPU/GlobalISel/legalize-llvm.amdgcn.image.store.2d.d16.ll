; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tonga -stop-after=legalizer -global-isel-abort=0 -o - %s | FileCheck -check-prefix=UNPACKED %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx810 -stop-after=legalizer -global-isel-abort=0 -o - %s | FileCheck -check-prefix=GFX81 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -stop-after=legalizer -global-isel-abort=0 -o - %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -stop-after=legalizer -global-isel-abort=0 -o - %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_ps void @image_store_f16(<8 x i32> inreg %rsrc, i32 %s, i32 %t, half %data) {
  ; UNPACKED-LABEL: name: image_store_f16
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; UNPACKED:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; UNPACKED:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; UNPACKED:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; UNPACKED:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; UNPACKED:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; UNPACKED:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; UNPACKED:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; UNPACKED:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; UNPACKED:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; UNPACKED:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY10]](s32)
  ; UNPACKED:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; UNPACKED:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[TRUNC]](s16), 1, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (s16) into custom "ImageResource")
  ; UNPACKED:   S_ENDPGM 0
  ; GFX81-LABEL: name: image_store_f16
  ; GFX81: bb.1 (%ir-block.0):
  ; GFX81:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX81:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX81:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX81:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX81:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX81:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX81:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX81:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX81:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX81:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX81:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX81:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX81:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX81:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY10]](s32)
  ; GFX81:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX81:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[TRUNC]](s16), 1, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (s16) into custom "ImageResource")
  ; GFX81:   S_ENDPGM 0
  ; GFX9-LABEL: name: image_store_f16
  ; GFX9: bb.1 (%ir-block.0):
  ; GFX9:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX9:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX9:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX9:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX9:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX9:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX9:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX9:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX9:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX9:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX9:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX9:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX9:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX9:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY10]](s32)
  ; GFX9:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX9:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[TRUNC]](s16), 1, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (s16) into custom "ImageResource")
  ; GFX9:   S_ENDPGM 0
  ; GFX10-LABEL: name: image_store_f16
  ; GFX10: bb.1 (%ir-block.0):
  ; GFX10:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX10:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX10:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY10]](s32)
  ; GFX10:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX10:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[TRUNC]](s16), 1, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (s16) into custom "ImageResource")
  ; GFX10:   S_ENDPGM 0
  call void @llvm.amdgcn.image.store.2d.f16.i32(half %data, i32 1, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v2f16(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <2 x half> %in) {
  ; UNPACKED-LABEL: name: image_store_v2f16
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; UNPACKED:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; UNPACKED:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; UNPACKED:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; UNPACKED:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; UNPACKED:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; UNPACKED:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; UNPACKED:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; UNPACKED:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; UNPACKED:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; UNPACKED:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; UNPACKED:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; UNPACKED:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; UNPACKED:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; UNPACKED:   [[BUILD_VECTOR2:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[BITCAST]](s32), [[LSHR]](s32)
  ; UNPACKED:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<2 x s32>), 3, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<2 x s16>) into custom "ImageResource")
  ; UNPACKED:   S_ENDPGM 0
  ; GFX81-LABEL: name: image_store_v2f16
  ; GFX81: bb.1 (%ir-block.0):
  ; GFX81:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX81:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX81:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX81:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX81:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX81:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX81:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX81:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX81:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX81:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX81:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX81:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX81:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX81:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX81:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; GFX81:   [[DEF:%[0-9]+]]:_(s32) = G_IMPLICIT_DEF
  ; GFX81:   [[BUILD_VECTOR2:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[BITCAST]](s32), [[DEF]](s32)
  ; GFX81:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<2 x s32>), 3, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<2 x s16>) into custom "ImageResource")
  ; GFX81:   S_ENDPGM 0
  ; GFX9-LABEL: name: image_store_v2f16
  ; GFX9: bb.1 (%ir-block.0):
  ; GFX9:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX9:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX9:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX9:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX9:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX9:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX9:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX9:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX9:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX9:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX9:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX9:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX9:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX9:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX9:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[COPY10]](<2 x s16>), 3, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<2 x s16>) into custom "ImageResource")
  ; GFX9:   S_ENDPGM 0
  ; GFX10-LABEL: name: image_store_v2f16
  ; GFX10: bb.1 (%ir-block.0):
  ; GFX10:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX10:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX10:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX10:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[COPY10]](<2 x s16>), 3, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<2 x s16>) into custom "ImageResource")
  ; GFX10:   S_ENDPGM 0
  call void @llvm.amdgcn.image.store.2d.v2f16.i32(<2 x half> %in, i32 3, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v3f16(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <3 x half> %in) {
  ; UNPACKED-LABEL: name: image_store_v3f16
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; UNPACKED:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; UNPACKED:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; UNPACKED:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; UNPACKED:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; UNPACKED:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; UNPACKED:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; UNPACKED:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; UNPACKED:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; UNPACKED:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; UNPACKED:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; UNPACKED:   [[DEF:%[0-9]+]]:_(<2 x s16>) = G_IMPLICIT_DEF
  ; UNPACKED:   [[CONCAT_VECTORS:%[0-9]+]]:_(<6 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>), [[DEF]](<2 x s16>)
  ; UNPACKED:   [[BITCAST:%[0-9]+]]:_(s96) = G_BITCAST [[CONCAT_VECTORS]](<6 x s16>)
  ; UNPACKED:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32), [[UV2:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[BITCAST]](s96)
  ; UNPACKED:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; UNPACKED:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[UV]], [[C]](s32)
  ; UNPACKED:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; UNPACKED:   [[BUILD_VECTOR2:%[0-9]+]]:_(<3 x s32>) = G_BUILD_VECTOR [[UV]](s32), [[LSHR]](s32), [[UV1]](s32)
  ; UNPACKED:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<3 x s32>), 7, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<3 x s16>) into custom "ImageResource", align 8)
  ; UNPACKED:   S_ENDPGM 0
  ; GFX81-LABEL: name: image_store_v3f16
  ; GFX81: bb.1 (%ir-block.0):
  ; GFX81:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX81:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX81:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX81:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX81:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX81:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX81:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX81:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX81:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX81:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX81:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX81:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX81:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX81:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX81:   [[DEF:%[0-9]+]]:_(<2 x s16>) = G_IMPLICIT_DEF
  ; GFX81:   [[CONCAT_VECTORS:%[0-9]+]]:_(<6 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>), [[DEF]](<2 x s16>)
  ; GFX81:   [[BITCAST:%[0-9]+]]:_(s96) = G_BITCAST [[CONCAT_VECTORS]](<6 x s16>)
  ; GFX81:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32), [[UV2:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[BITCAST]](s96)
  ; GFX81:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; GFX81:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[UV]], [[C]](s32)
  ; GFX81:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX81:   [[C1:%[0-9]+]]:_(s32) = G_CONSTANT i32 65535
  ; GFX81:   [[AND:%[0-9]+]]:_(s32) = G_AND [[UV]], [[C1]]
  ; GFX81:   [[AND1:%[0-9]+]]:_(s32) = G_AND [[LSHR]], [[C1]]
  ; GFX81:   [[SHL:%[0-9]+]]:_(s32) = G_SHL [[AND1]], [[C]](s32)
  ; GFX81:   [[OR:%[0-9]+]]:_(s32) = G_OR [[AND]], [[SHL]]
  ; GFX81:   [[BITCAST1:%[0-9]+]]:_(<2 x s16>) = G_BITCAST [[OR]](s32)
  ; GFX81:   [[AND2:%[0-9]+]]:_(s32) = G_AND [[UV1]], [[C1]]
  ; GFX81:   [[C2:%[0-9]+]]:_(s32) = G_CONSTANT i32 0
  ; GFX81:   [[SHL1:%[0-9]+]]:_(s32) = G_SHL [[C2]], [[C]](s32)
  ; GFX81:   [[OR1:%[0-9]+]]:_(s32) = G_OR [[AND2]], [[SHL1]]
  ; GFX81:   [[BITCAST2:%[0-9]+]]:_(<2 x s16>) = G_BITCAST [[OR1]](s32)
  ; GFX81:   [[OR2:%[0-9]+]]:_(s32) = G_OR [[C2]], [[SHL1]]
  ; GFX81:   [[BITCAST3:%[0-9]+]]:_(<2 x s16>) = G_BITCAST [[OR2]](s32)
  ; GFX81:   [[CONCAT_VECTORS1:%[0-9]+]]:_(<6 x s16>) = G_CONCAT_VECTORS [[BITCAST1]](<2 x s16>), [[BITCAST2]](<2 x s16>), [[BITCAST3]](<2 x s16>)
  ; GFX81:   [[BITCAST4:%[0-9]+]]:_(<3 x s32>) = G_BITCAST [[CONCAT_VECTORS1]](<6 x s16>)
  ; GFX81:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BITCAST4]](<3 x s32>), 7, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<3 x s16>) into custom "ImageResource", align 8)
  ; GFX81:   S_ENDPGM 0
  ; GFX9-LABEL: name: image_store_v3f16
  ; GFX9: bb.1 (%ir-block.0):
  ; GFX9:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX9:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX9:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX9:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX9:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX9:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX9:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX9:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX9:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX9:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX9:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX9:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX9:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX9:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX9:   [[DEF:%[0-9]+]]:_(<2 x s16>) = G_IMPLICIT_DEF
  ; GFX9:   [[CONCAT_VECTORS:%[0-9]+]]:_(<6 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>), [[DEF]](<2 x s16>)
  ; GFX9:   [[BITCAST:%[0-9]+]]:_(s96) = G_BITCAST [[CONCAT_VECTORS]](<6 x s16>)
  ; GFX9:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32), [[UV2:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[BITCAST]](s96)
  ; GFX9:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; GFX9:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[UV]], [[C]](s32)
  ; GFX9:   [[BUILD_VECTOR_TRUNC:%[0-9]+]]:_(<2 x s16>) = G_BUILD_VECTOR_TRUNC [[UV]](s32), [[LSHR]](s32)
  ; GFX9:   [[DEF1:%[0-9]+]]:_(s32) = G_IMPLICIT_DEF
  ; GFX9:   [[BUILD_VECTOR_TRUNC1:%[0-9]+]]:_(<2 x s16>) = G_BUILD_VECTOR_TRUNC [[UV1]](s32), [[DEF1]](s32)
  ; GFX9:   [[CONCAT_VECTORS1:%[0-9]+]]:_(<6 x s16>) = G_CONCAT_VECTORS [[BUILD_VECTOR_TRUNC]](<2 x s16>), [[BUILD_VECTOR_TRUNC1]](<2 x s16>), [[DEF]](<2 x s16>)
  ; GFX9:   [[UV3:%[0-9]+]]:_(<3 x s16>), [[UV4:%[0-9]+]]:_(<3 x s16>) = G_UNMERGE_VALUES [[CONCAT_VECTORS1]](<6 x s16>)
  ; GFX9:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX9:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[UV3]](<3 x s16>), 7, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<3 x s16>) into custom "ImageResource", align 8)
  ; GFX9:   S_ENDPGM 0
  ; GFX10-LABEL: name: image_store_v3f16
  ; GFX10: bb.1 (%ir-block.0):
  ; GFX10:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX10:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX10:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX10:   [[DEF:%[0-9]+]]:_(<2 x s16>) = G_IMPLICIT_DEF
  ; GFX10:   [[CONCAT_VECTORS:%[0-9]+]]:_(<6 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>), [[DEF]](<2 x s16>)
  ; GFX10:   [[BITCAST:%[0-9]+]]:_(s96) = G_BITCAST [[CONCAT_VECTORS]](<6 x s16>)
  ; GFX10:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32), [[UV2:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[BITCAST]](s96)
  ; GFX10:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; GFX10:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[UV]], [[C]](s32)
  ; GFX10:   [[BUILD_VECTOR_TRUNC:%[0-9]+]]:_(<2 x s16>) = G_BUILD_VECTOR_TRUNC [[UV]](s32), [[LSHR]](s32)
  ; GFX10:   [[DEF1:%[0-9]+]]:_(s32) = G_IMPLICIT_DEF
  ; GFX10:   [[BUILD_VECTOR_TRUNC1:%[0-9]+]]:_(<2 x s16>) = G_BUILD_VECTOR_TRUNC [[UV1]](s32), [[DEF1]](s32)
  ; GFX10:   [[CONCAT_VECTORS1:%[0-9]+]]:_(<6 x s16>) = G_CONCAT_VECTORS [[BUILD_VECTOR_TRUNC]](<2 x s16>), [[BUILD_VECTOR_TRUNC1]](<2 x s16>), [[DEF]](<2 x s16>)
  ; GFX10:   [[UV3:%[0-9]+]]:_(<3 x s16>), [[UV4:%[0-9]+]]:_(<3 x s16>) = G_UNMERGE_VALUES [[CONCAT_VECTORS1]](<6 x s16>)
  ; GFX10:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX10:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[UV3]](<3 x s16>), 7, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<3 x s16>) into custom "ImageResource", align 8)
  ; GFX10:   S_ENDPGM 0
  call void @llvm.amdgcn.image.store.2d.v3f16.i32(<3 x half> %in, i32 7, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v4f16(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <4 x half> %in) {
  ; UNPACKED-LABEL: name: image_store_v4f16
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; UNPACKED:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; UNPACKED:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; UNPACKED:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; UNPACKED:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; UNPACKED:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; UNPACKED:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; UNPACKED:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; UNPACKED:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; UNPACKED:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; UNPACKED:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; UNPACKED:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; UNPACKED:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; UNPACKED:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; UNPACKED:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; UNPACKED:   [[BITCAST1:%[0-9]+]]:_(s32) = G_BITCAST [[COPY11]](<2 x s16>)
  ; UNPACKED:   [[LSHR1:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST1]], [[C]](s32)
  ; UNPACKED:   [[BUILD_VECTOR2:%[0-9]+]]:_(<4 x s32>) = G_BUILD_VECTOR [[BITCAST]](s32), [[LSHR]](s32), [[BITCAST1]](s32), [[LSHR1]](s32)
  ; UNPACKED:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<4 x s32>), 15, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<4 x s16>) into custom "ImageResource")
  ; UNPACKED:   S_ENDPGM 0
  ; GFX81-LABEL: name: image_store_v4f16
  ; GFX81: bb.1 (%ir-block.0):
  ; GFX81:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX81:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX81:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX81:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX81:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX81:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX81:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX81:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX81:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX81:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX81:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX81:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX81:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX81:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX81:   [[CONCAT_VECTORS:%[0-9]+]]:_(<4 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>)
  ; GFX81:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX81:   [[BITCAST:%[0-9]+]]:_(<2 x s32>) = G_BITCAST [[CONCAT_VECTORS]](<4 x s16>)
  ; GFX81:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[BITCAST]](<2 x s32>)
  ; GFX81:   [[DEF:%[0-9]+]]:_(s32) = G_IMPLICIT_DEF
  ; GFX81:   [[BUILD_VECTOR2:%[0-9]+]]:_(<4 x s32>) = G_BUILD_VECTOR [[UV]](s32), [[UV1]](s32), [[DEF]](s32), [[DEF]](s32)
  ; GFX81:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<4 x s32>), 15, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<4 x s16>) into custom "ImageResource")
  ; GFX81:   S_ENDPGM 0
  ; GFX9-LABEL: name: image_store_v4f16
  ; GFX9: bb.1 (%ir-block.0):
  ; GFX9:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX9:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX9:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX9:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX9:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX9:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX9:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX9:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX9:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX9:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX9:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX9:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX9:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX9:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX9:   [[CONCAT_VECTORS:%[0-9]+]]:_(<4 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>)
  ; GFX9:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX9:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[CONCAT_VECTORS]](<4 x s16>), 15, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<4 x s16>) into custom "ImageResource")
  ; GFX9:   S_ENDPGM 0
  ; GFX10-LABEL: name: image_store_v4f16
  ; GFX10: bb.1 (%ir-block.0):
  ; GFX10:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX10:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX10:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX10:   [[CONCAT_VECTORS:%[0-9]+]]:_(<4 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>)
  ; GFX10:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX10:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[CONCAT_VECTORS]](<4 x s16>), 15, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<4 x s16>) into custom "ImageResource")
  ; GFX10:   S_ENDPGM 0
  call void @llvm.amdgcn.image.store.2d.v4f16.i32(<4 x half> %in, i32 15, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

declare void @llvm.amdgcn.image.store.2d.f16.i32(half, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.2d.v2f16.i32(<2 x half>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.2d.v3f16.i32(<3 x half>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.2d.v4f16.i32(<4 x half>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind writeonly }
