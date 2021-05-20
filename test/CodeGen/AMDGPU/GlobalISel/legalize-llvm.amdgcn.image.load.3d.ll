; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tahiti -stop-after=legalizer -o - %s | FileCheck -check-prefix=GFX6 %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -stop-after=legalizer -o - %s | FileCheck -check-prefix=GFX10NSA %s

define amdgpu_ps float @image_load_3d_f32(<8 x i32> inreg %rsrc, i32 %s, i32 %t, i32 %r) {
  ; GFX6-LABEL: name: image_load_3d_f32
  ; GFX6: bb.1 (%ir-block.0):
  ; GFX6:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX6:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX6:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX6:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX6:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX6:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX6:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX6:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX6:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX6:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX6:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX6:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX6:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX6:   [[BUILD_VECTOR1:%[0-9]+]]:_(<3 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32), [[COPY10]](s32)
  ; GFX6:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:_(s32) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.3d), 1, [[BUILD_VECTOR1]](<3 x s32>), $noreg, $noreg, [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (s32) from custom "ImageResource")
  ; GFX6:   $vgpr0 = COPY [[AMDGPU_INTRIN_IMAGE_LOAD]](s32)
  ; GFX6:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; GFX10NSA-LABEL: name: image_load_3d_f32
  ; GFX10NSA: bb.1 (%ir-block.0):
  ; GFX10NSA:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX10NSA:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10NSA:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10NSA:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10NSA:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10NSA:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10NSA:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10NSA:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10NSA:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10NSA:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10NSA:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10NSA:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10NSA:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX10NSA:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:_(s32) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.3d), 1, [[COPY8]](s32), [[COPY9]](s32), [[COPY10]](s32), [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (s32) from custom "ImageResource")
  ; GFX10NSA:   $vgpr0 = COPY [[AMDGPU_INTRIN_IMAGE_LOAD]](s32)
  ; GFX10NSA:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %tex = call float @llvm.amdgcn.image.load.3d.f32.i32(i32 1, i32 %s, i32 %t, i32 %r, <8 x i32> %rsrc, i32 0, i32 0)
  ret float %tex
}

define amdgpu_ps float @image_load_3d_tfe_f32(<8 x i32> inreg %rsrc, i32 %s, i32 %t, i32 %r) {
  ; GFX6-LABEL: name: image_load_3d_tfe_f32
  ; GFX6: bb.1 (%ir-block.0):
  ; GFX6:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX6:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX6:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX6:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX6:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX6:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX6:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX6:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX6:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX6:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX6:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX6:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX6:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX6:   [[DEF:%[0-9]+]]:_(p1) = G_IMPLICIT_DEF
  ; GFX6:   [[BUILD_VECTOR1:%[0-9]+]]:_(<3 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32), [[COPY10]](s32)
  ; GFX6:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:_(<2 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.3d), 1, [[BUILD_VECTOR1]](<3 x s32>), $noreg, $noreg, [[BUILD_VECTOR]](<8 x s32>), 1, 0, 0 :: (dereferenceable load (s32) from custom "ImageResource")
  ; GFX6:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[AMDGPU_INTRIN_IMAGE_LOAD]](<2 x s32>)
  ; GFX6:   G_STORE [[UV1]](s32), [[DEF]](p1) :: (store (s32) into `i32 addrspace(1)* undef`, addrspace 1)
  ; GFX6:   $vgpr0 = COPY [[UV]](s32)
  ; GFX6:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; GFX10NSA-LABEL: name: image_load_3d_tfe_f32
  ; GFX10NSA: bb.1 (%ir-block.0):
  ; GFX10NSA:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2
  ; GFX10NSA:   [[COPY:%[0-9]+]]:_(s32) = COPY $sgpr2
  ; GFX10NSA:   [[COPY1:%[0-9]+]]:_(s32) = COPY $sgpr3
  ; GFX10NSA:   [[COPY2:%[0-9]+]]:_(s32) = COPY $sgpr4
  ; GFX10NSA:   [[COPY3:%[0-9]+]]:_(s32) = COPY $sgpr5
  ; GFX10NSA:   [[COPY4:%[0-9]+]]:_(s32) = COPY $sgpr6
  ; GFX10NSA:   [[COPY5:%[0-9]+]]:_(s32) = COPY $sgpr7
  ; GFX10NSA:   [[COPY6:%[0-9]+]]:_(s32) = COPY $sgpr8
  ; GFX10NSA:   [[COPY7:%[0-9]+]]:_(s32) = COPY $sgpr9
  ; GFX10NSA:   [[BUILD_VECTOR:%[0-9]+]]:_(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GFX10NSA:   [[COPY8:%[0-9]+]]:_(s32) = COPY $vgpr0
  ; GFX10NSA:   [[COPY9:%[0-9]+]]:_(s32) = COPY $vgpr1
  ; GFX10NSA:   [[COPY10:%[0-9]+]]:_(s32) = COPY $vgpr2
  ; GFX10NSA:   [[DEF:%[0-9]+]]:_(p1) = G_IMPLICIT_DEF
  ; GFX10NSA:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:_(<2 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.3d), 1, [[COPY8]](s32), [[COPY9]](s32), [[COPY10]](s32), [[BUILD_VECTOR]](<8 x s32>), 1, 0, 0 :: (dereferenceable load (s32) from custom "ImageResource")
  ; GFX10NSA:   [[UV:%[0-9]+]]:_(s32), [[UV1:%[0-9]+]]:_(s32) = G_UNMERGE_VALUES [[AMDGPU_INTRIN_IMAGE_LOAD]](<2 x s32>)
  ; GFX10NSA:   G_STORE [[UV1]](s32), [[DEF]](p1) :: (store (s32) into `i32 addrspace(1)* undef`, addrspace 1)
  ; GFX10NSA:   $vgpr0 = COPY [[UV]](s32)
  ; GFX10NSA:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call { float, i32 } @llvm.amdgcn.image.load.3d.sl_f32i32s.i32(i32 1, i32 %s, i32 %t, i32 %r, <8 x i32> %rsrc, i32 1, i32 0)
  %tex = extractvalue { float, i32 } %val, 0
  %tfe = extractvalue { float, i32 } %val, 1
  store i32 %tfe, i32 addrspace(1)* undef
  ret float %tex
}

declare float @llvm.amdgcn.image.load.3d.f32.i32(i32 immarg, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0
declare { float, i32 } @llvm.amdgcn.image.load.3d.sl_f32i32s.i32(i32 immarg, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
