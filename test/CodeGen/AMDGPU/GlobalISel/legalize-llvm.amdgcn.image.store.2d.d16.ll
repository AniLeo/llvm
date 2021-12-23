; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tonga -stop-after=legalizer -o - %s | FileCheck -check-prefix=UNPACKED %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx810 -stop-after=legalizer -o - %s | FileCheck -check-prefix=GFX81 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx900 -stop-after=legalizer -o - %s | FileCheck -check-prefix=GFX9 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -stop-after=legalizer -o - %s | FileCheck -check-prefix=GFX10 %s

define amdgpu_ps void @image_store_f16(<8 x i32> inreg %rsrc, i32 %s, i32 %t, half %data) {
  ; UNPACKED-LABEL: name: image_store_f16
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; UNPACKED-NEXT: {{  $}}
  ; UNPACKED-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; UNPACKED-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; UNPACKED-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; UNPACKED-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; UNPACKED-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; UNPACKED-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; UNPACKED-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; UNPACKED-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; UNPACKED-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; UNPACKED-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; UNPACKED-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; UNPACKED-NEXT:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; UNPACKED-NEXT:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY10]](s32)
  ; UNPACKED-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; UNPACKED-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[TRUNC]](s16), 1, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (s16) into custom "ImageResource")
  ; UNPACKED-NEXT:   S_ENDPGM 0
  ; GFX81-LABEL: name: image_store_f16
  ; GFX81: bb.1 (%ir-block.0):
  ; GFX81-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX81-NEXT: {{  $}}
  ; GFX81-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX81-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX81-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX81-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX81-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX81-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX81-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX81-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX81-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX81-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX81-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX81-NEXT:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX81-NEXT:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY10]](s32)
  ; GFX81-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX81-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[TRUNC]](s16), 1, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (s16) into custom "ImageResource")
  ; GFX81-NEXT:   S_ENDPGM 0
  ; GFX9-LABEL: name: image_store_f16
  ; GFX9: bb.1 (%ir-block.0):
  ; GFX9-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX9-NEXT: {{  $}}
  ; GFX9-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX9-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX9-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX9-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX9-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX9-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX9-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX9-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX9-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX9-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX9-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX9-NEXT:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX9-NEXT:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY10]](s32)
  ; GFX9-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX9-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[TRUNC]](s16), 1, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (s16) into custom "ImageResource")
  ; GFX9-NEXT:   S_ENDPGM 0
  ; GFX10-LABEL: name: image_store_f16
  ; GFX10: bb.1 (%ir-block.0):
  ; GFX10-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX10-NEXT: {{  $}}
  ; GFX10-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10-NEXT:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX10-NEXT:   [[TRUNC:%[0-9]+]]:_(s16) = G_TRUNC [[COPY10]](s32)
  ; GFX10-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX10-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[TRUNC]](s16), 1, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (s16) into custom "ImageResource")
  ; GFX10-NEXT:   S_ENDPGM 0
  call void @llvm.amdgcn.image.store.2d.f16.i32(half %data, i32 1, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v2f16(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <2 x half> %in) {
  ; UNPACKED-LABEL: name: image_store_v2f16
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; UNPACKED-NEXT: {{  $}}
  ; UNPACKED-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; UNPACKED-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; UNPACKED-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; UNPACKED-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; UNPACKED-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; UNPACKED-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; UNPACKED-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; UNPACKED-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; UNPACKED-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; UNPACKED-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; UNPACKED-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; UNPACKED-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; UNPACKED-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; UNPACKED-NEXT:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; UNPACKED-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; UNPACKED-NEXT:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; UNPACKED-NEXT:   [[BUILD_VECTOR2:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[BITCAST]](s32), [[LSHR]](s32)
  ; UNPACKED-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<2 x s32>), 3, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<2 x s16>) into custom "ImageResource")
  ; UNPACKED-NEXT:   S_ENDPGM 0
  ; GFX81-LABEL: name: image_store_v2f16
  ; GFX81: bb.1 (%ir-block.0):
  ; GFX81-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX81-NEXT: {{  $}}
  ; GFX81-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX81-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX81-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX81-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX81-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX81-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX81-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX81-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX81-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX81-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX81-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX81-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX81-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX81-NEXT:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; GFX81-NEXT:   [[DEF:%[0-9]+]]:_(s32) = G_IMPLICIT_DEF
  ; GFX81-NEXT:   [[BUILD_VECTOR2:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[BITCAST]](s32), [[DEF]](s32)
  ; GFX81-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<2 x s32>), 3, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<2 x s16>) into custom "ImageResource")
  ; GFX81-NEXT:   S_ENDPGM 0
  ; GFX9-LABEL: name: image_store_v2f16
  ; GFX9: bb.1 (%ir-block.0):
  ; GFX9-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX9-NEXT: {{  $}}
  ; GFX9-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX9-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX9-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX9-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX9-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX9-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX9-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX9-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX9-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX9-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX9-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX9-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX9-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX9-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[COPY10]](<2 x s16>), 3, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<2 x s16>) into custom "ImageResource")
  ; GFX9-NEXT:   S_ENDPGM 0
  ; GFX10-LABEL: name: image_store_v2f16
  ; GFX10: bb.1 (%ir-block.0):
  ; GFX10-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX10-NEXT: {{  $}}
  ; GFX10-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX10-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX10-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[COPY10]](<2 x s16>), 3, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<2 x s16>) into custom "ImageResource")
  ; GFX10-NEXT:   S_ENDPGM 0
  call void @llvm.amdgcn.image.store.2d.v2f16.i32(<2 x half> %in, i32 3, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v3f16(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <3 x half> %in) {
  ; UNPACKED-LABEL: name: image_store_v3f16
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; UNPACKED-NEXT: {{  $}}
  ; UNPACKED-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; UNPACKED-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; UNPACKED-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; UNPACKED-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; UNPACKED-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; UNPACKED-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; UNPACKED-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; UNPACKED-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; UNPACKED-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; UNPACKED-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; UNPACKED-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; UNPACKED-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; UNPACKED-NEXT:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; UNPACKED-NEXT:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; UNPACKED-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; UNPACKED-NEXT:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; UNPACKED-NEXT:   [[BITCAST1:%[0-9]+]]:_(s32) = G_BITCAST [[COPY11]](<2 x s16>)
  ; UNPACKED-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; UNPACKED-NEXT:   [[BUILD_VECTOR2:%[0-9]+]]:_(<3 x s32>) = G_BUILD_VECTOR [[BITCAST]](s32), [[LSHR]](s32), [[BITCAST1]](s32)
  ; UNPACKED-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<3 x s32>), 7, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<3 x s16>) into custom "ImageResource", align 8)
  ; UNPACKED-NEXT:   S_ENDPGM 0
  ; GFX81-LABEL: name: image_store_v3f16
  ; GFX81: bb.1 (%ir-block.0):
  ; GFX81-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX81-NEXT: {{  $}}
  ; GFX81-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX81-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX81-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX81-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX81-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX81-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX81-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX81-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX81-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX81-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX81-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX81-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX81-NEXT:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX81-NEXT:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; GFX81-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; GFX81-NEXT:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; GFX81-NEXT:   [[BITCAST1:%[0-9]+]]:_(s32) = G_BITCAST [[COPY11]](<2 x s16>)
  ; GFX81-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX81-NEXT:   [[C1:%[0-9]+]]:_(s32) = G_CONSTANT i32 65535
  ; GFX81-NEXT:   [[AND:%[0-9]+]]:_(s32) = G_AND [[BITCAST]], [[C1]]
  ; GFX81-NEXT:   [[AND1:%[0-9]+]]:_(s32) = G_AND [[LSHR]], [[C1]]
  ; GFX81-NEXT:   [[SHL:%[0-9]+]]:_(s32) = G_SHL [[AND1]], [[C]](s32)
  ; GFX81-NEXT:   [[OR:%[0-9]+]]:_(s32) = G_OR [[AND]], [[SHL]]
  ; GFX81-NEXT:   [[BITCAST2:%[0-9]+]]:_(<2 x s16>) = G_BITCAST [[OR]](s32)
  ; GFX81-NEXT:   [[AND2:%[0-9]+]]:_(s32) = G_AND [[BITCAST1]], [[C1]]
  ; GFX81-NEXT:   [[C2:%[0-9]+]]:_(s32) = G_CONSTANT i32 0
  ; GFX81-NEXT:   [[SHL1:%[0-9]+]]:_(s32) = G_SHL [[C2]], [[C]](s32)
  ; GFX81-NEXT:   [[OR1:%[0-9]+]]:_(s32) = G_OR [[AND2]], [[SHL1]]
  ; GFX81-NEXT:   [[BITCAST3:%[0-9]+]]:_(<2 x s16>) = G_BITCAST [[OR1]](s32)
  ; GFX81-NEXT:   [[OR2:%[0-9]+]]:_(s32) = G_OR [[C2]], [[SHL1]]
  ; GFX81-NEXT:   [[BITCAST4:%[0-9]+]]:_(<2 x s16>) = G_BITCAST [[OR2]](s32)
  ; GFX81-NEXT:   [[CONCAT_VECTORS:%[0-9]+]]:_(<6 x s16>) = G_CONCAT_VECTORS [[BITCAST2]](<2 x s16>), [[BITCAST3]](<2 x s16>), [[BITCAST4]](<2 x s16>)
  ; GFX81-NEXT:   [[BITCAST5:%[0-9]+]]:_(<3 x s32>) = G_BITCAST [[CONCAT_VECTORS]](<6 x s16>)
  ; GFX81-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BITCAST5]](<3 x s32>), 7, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<3 x s16>) into custom "ImageResource", align 8)
  ; GFX81-NEXT:   S_ENDPGM 0
  ; GFX9-LABEL: name: image_store_v3f16
  ; GFX9: bb.1 (%ir-block.0):
  ; GFX9-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX9-NEXT: {{  $}}
  ; GFX9-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX9-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX9-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX9-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX9-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX9-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX9-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX9-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX9-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX9-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX9-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX9-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX9-NEXT:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX9-NEXT:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; GFX9-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; GFX9-NEXT:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; GFX9-NEXT:   [[BITCAST1:%[0-9]+]]:_(s32) = G_BITCAST [[COPY11]](<2 x s16>)
  ; GFX9-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX9-NEXT:   [[BUILD_VECTOR_TRUNC:%[0-9]+]]:_(<2 x s16>) = G_BUILD_VECTOR_TRUNC [[BITCAST]](s32), [[LSHR]](s32)
  ; GFX9-NEXT:   [[DEF:%[0-9]+]]:_(s32) = G_IMPLICIT_DEF
  ; GFX9-NEXT:   [[BUILD_VECTOR_TRUNC1:%[0-9]+]]:_(<2 x s16>) = G_BUILD_VECTOR_TRUNC [[BITCAST1]](s32), [[DEF]](s32)
  ; GFX9-NEXT:   [[CONCAT_VECTORS:%[0-9]+]]:_(<4 x s16>) = G_CONCAT_VECTORS [[BUILD_VECTOR_TRUNC]](<2 x s16>), [[BUILD_VECTOR_TRUNC1]](<2 x s16>)
  ; GFX9-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[CONCAT_VECTORS]](<4 x s16>), 7, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<3 x s16>) into custom "ImageResource", align 8)
  ; GFX9-NEXT:   S_ENDPGM 0
  ; GFX10-LABEL: name: image_store_v3f16
  ; GFX10: bb.1 (%ir-block.0):
  ; GFX10-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX10-NEXT: {{  $}}
  ; GFX10-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX10-NEXT:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX10-NEXT:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; GFX10-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; GFX10-NEXT:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; GFX10-NEXT:   [[BITCAST1:%[0-9]+]]:_(s32) = G_BITCAST [[COPY11]](<2 x s16>)
  ; GFX10-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX10-NEXT:   [[BUILD_VECTOR_TRUNC:%[0-9]+]]:_(<2 x s16>) = G_BUILD_VECTOR_TRUNC [[BITCAST]](s32), [[LSHR]](s32)
  ; GFX10-NEXT:   [[DEF:%[0-9]+]]:_(s32) = G_IMPLICIT_DEF
  ; GFX10-NEXT:   [[BUILD_VECTOR_TRUNC1:%[0-9]+]]:_(<2 x s16>) = G_BUILD_VECTOR_TRUNC [[BITCAST1]](s32), [[DEF]](s32)
  ; GFX10-NEXT:   [[CONCAT_VECTORS:%[0-9]+]]:_(<4 x s16>) = G_CONCAT_VECTORS [[BUILD_VECTOR_TRUNC]](<2 x s16>), [[BUILD_VECTOR_TRUNC1]](<2 x s16>)
  ; GFX10-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[CONCAT_VECTORS]](<4 x s16>), 7, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<3 x s16>) into custom "ImageResource", align 8)
  ; GFX10-NEXT:   S_ENDPGM 0
  call void @llvm.amdgcn.image.store.2d.v3f16.i32(<3 x half> %in, i32 7, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

define amdgpu_ps void @image_store_v4f16(<8 x i32> inreg %rsrc, i32 %s, i32 %t, <4 x half> %in) {
  ; UNPACKED-LABEL: name: image_store_v4f16
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; UNPACKED-NEXT: {{  $}}
  ; UNPACKED-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; UNPACKED-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; UNPACKED-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; UNPACKED-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; UNPACKED-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; UNPACKED-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; UNPACKED-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; UNPACKED-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; UNPACKED-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; UNPACKED-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; UNPACKED-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; UNPACKED-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; UNPACKED-NEXT:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; UNPACKED-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; UNPACKED-NEXT:   [[BITCAST:%[0-9]+]]:_(s32) = G_BITCAST [[COPY10]](<2 x s16>)
  ; UNPACKED-NEXT:   [[C:%[0-9]+]]:_(s32) = G_CONSTANT i32 16
  ; UNPACKED-NEXT:   [[LSHR:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST]], [[C]](s32)
  ; UNPACKED-NEXT:   [[BITCAST1:%[0-9]+]]:_(s32) = G_BITCAST [[COPY11]](<2 x s16>)
  ; UNPACKED-NEXT:   [[LSHR1:%[0-9]+]]:_(s32) = G_LSHR [[BITCAST1]], [[C]](s32)
  ; UNPACKED-NEXT:   [[BUILD_VECTOR2:%[0-9]+]]:_(<4 x s32>) = G_BUILD_VECTOR [[BITCAST]](s32), [[LSHR]](s32), [[BITCAST1]](s32), [[LSHR1]](s32)
  ; UNPACKED-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<4 x s32>), 15, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<4 x s16>) into custom "ImageResource")
  ; UNPACKED-NEXT:   S_ENDPGM 0
  ; GFX81-LABEL: name: image_store_v4f16
  ; GFX81: bb.1 (%ir-block.0):
  ; GFX81-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX81-NEXT: {{  $}}
  ; GFX81-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX81-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX81-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX81-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX81-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX81-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX81-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX81-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX81-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX81-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX81-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX81-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX81-NEXT:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX81-NEXT:   [[CONCAT_VECTORS:%[0-9]+]]:_(<4 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>)
  ; GFX81-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX81-NEXT:   [[BITCAST:%[0-9]+]]:_(<2 x s32>) = G_BITCAST [[CONCAT_VECTORS]](<4 x s16>)
  ; GFX81-NEXT:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[BITCAST]](<2 x s32>)
  ; GFX81-NEXT:   [[DEF:%[0-9]+]]:_(s32) = G_IMPLICIT_DEF
  ; GFX81-NEXT:   [[BUILD_VECTOR2:%[0-9]+]]:_(<4 x s32>) = G_BUILD_VECTOR [[UV]](s32), [[UV1]](s32), [[DEF]](s32), [[DEF]](s32)
  ; GFX81-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[BUILD_VECTOR2]](<4 x s32>), 15, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<4 x s16>) into custom "ImageResource")
  ; GFX81-NEXT:   S_ENDPGM 0
  ; GFX9-LABEL: name: image_store_v4f16
  ; GFX9: bb.1 (%ir-block.0):
  ; GFX9-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX9-NEXT: {{  $}}
  ; GFX9-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX9-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX9-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX9-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX9-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX9-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX9-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX9-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX9-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX9-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX9-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX9-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX9-NEXT:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX9-NEXT:   [[CONCAT_VECTORS:%[0-9]+]]:_(<4 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>)
  ; GFX9-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX9-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[CONCAT_VECTORS]](<4 x s16>), 15, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<4 x s16>) into custom "ImageResource")
  ; GFX9-NEXT:   S_ENDPGM 0
  ; GFX10-LABEL: name: image_store_v4f16
  ; GFX10: bb.1 (%ir-block.0):
  ; GFX10-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; GFX10-NEXT: {{  $}}
  ; GFX10-NEXT:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10-NEXT:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10-NEXT:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10-NEXT:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10-NEXT:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10-NEXT:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10-NEXT:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10-NEXT:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10-NEXT:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10-NEXT:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10-NEXT:   [[COPY10:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr2
  ; GFX10-NEXT:   [[COPY11:%[0-9]+]]:_(<2 x s16>) = COPY $vgpr3
  ; GFX10-NEXT:   [[CONCAT_VECTORS:%[0-9]+]]:_(<4 x s16>) = G_CONCAT_VECTORS [[COPY10]](<2 x s16>), [[COPY11]](<2 x s16>)
  ; GFX10-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:_(<2 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32)
  ; GFX10-NEXT:   G_AMDGPU_INTRIN_IMAGE_STORE intrinsic(@llvm.amdgcn.image.store.2d), [[CONCAT_VECTORS]](<4 x s16>), 15, [[BUILD_VECTOR1]](<2 x s32>), $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable store (<4 x s16>) into custom "ImageResource")
  ; GFX10-NEXT:   S_ENDPGM 0
  call void @llvm.amdgcn.image.store.2d.v4f16.i32(<4 x half> %in, i32 15, i32 %s, i32 %t, <8 x i32> %rsrc, i32 0, i32 0)
  ret void
}

declare void @llvm.amdgcn.image.store.2d.f16.i32(half, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.2d.v2f16.i32(<2 x half>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.2d.v3f16.i32(<3 x half>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare void @llvm.amdgcn.image.store.2d.v4f16.i32(<4 x half>, i32 immarg, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind writeonly }
