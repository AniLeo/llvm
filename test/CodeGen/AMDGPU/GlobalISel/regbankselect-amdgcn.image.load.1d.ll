; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -stop-after=regbankselect -regbankselect-fast -o - %s | FileCheck -check-prefix=FAST %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -stop-after=regbankselect -regbankselect-greedy -o - %s | FileCheck -check-prefix=GREEDY %s

; Natural mapping
define amdgpu_ps void @load_1d_vgpr_vaddr__sgpr_srsrc(<8 x i32> inreg %rsrc, i32 %s) {
  ; FAST-LABEL: name: load_1d_vgpr_vaddr__sgpr_srsrc
  ; FAST: bb.1 (%ir-block.0):
  ; FAST-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   [[COPY:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; FAST-NEXT:   [[COPY1:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; FAST-NEXT:   [[COPY2:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; FAST-NEXT:   [[COPY3:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; FAST-NEXT:   [[COPY4:%[0-9]+]]:sgpr(s32) = COPY $sgpr6
  ; FAST-NEXT:   [[COPY5:%[0-9]+]]:sgpr(s32) = COPY $sgpr7
  ; FAST-NEXT:   [[COPY6:%[0-9]+]]:sgpr(s32) = COPY $sgpr8
  ; FAST-NEXT:   [[COPY7:%[0-9]+]]:sgpr(s32) = COPY $sgpr9
  ; FAST-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; FAST-NEXT:   [[COPY8:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; FAST-NEXT:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; FAST-NEXT:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:vgpr(<4 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY8]](s32), [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (<4 x s32>) from custom "ImageResource")
  ; FAST-NEXT:   [[COPY9:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; FAST-NEXT:   G_STORE [[AMDGPU_INTRIN_IMAGE_LOAD]](<4 x s32>), [[COPY9]](p1) :: (store (<4 x s32>) into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; FAST-NEXT:   S_ENDPGM 0
  ; GREEDY-LABEL: name: load_1d_vgpr_vaddr__sgpr_srsrc
  ; GREEDY: bb.1 (%ir-block.0):
  ; GREEDY-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   [[COPY:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; GREEDY-NEXT:   [[COPY1:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; GREEDY-NEXT:   [[COPY2:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; GREEDY-NEXT:   [[COPY3:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; GREEDY-NEXT:   [[COPY4:%[0-9]+]]:sgpr(s32) = COPY $sgpr6
  ; GREEDY-NEXT:   [[COPY5:%[0-9]+]]:sgpr(s32) = COPY $sgpr7
  ; GREEDY-NEXT:   [[COPY6:%[0-9]+]]:sgpr(s32) = COPY $sgpr8
  ; GREEDY-NEXT:   [[COPY7:%[0-9]+]]:sgpr(s32) = COPY $sgpr9
  ; GREEDY-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GREEDY-NEXT:   [[COPY8:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; GREEDY-NEXT:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; GREEDY-NEXT:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:vgpr(<4 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY8]](s32), [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (<4 x s32>) from custom "ImageResource")
  ; GREEDY-NEXT:   [[COPY9:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; GREEDY-NEXT:   G_STORE [[AMDGPU_INTRIN_IMAGE_LOAD]](<4 x s32>), [[COPY9]](p1) :: (store (<4 x s32>) into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; GREEDY-NEXT:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Copy needed for VGPR argument
define amdgpu_ps void @load_1d_sgpr_vaddr__sgpr_srsrc(<8 x i32> inreg %rsrc, i32 inreg %s) {
  ; FAST-LABEL: name: load_1d_sgpr_vaddr__sgpr_srsrc
  ; FAST: bb.1 (%ir-block.0):
  ; FAST-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $sgpr10
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   [[COPY:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; FAST-NEXT:   [[COPY1:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; FAST-NEXT:   [[COPY2:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; FAST-NEXT:   [[COPY3:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; FAST-NEXT:   [[COPY4:%[0-9]+]]:sgpr(s32) = COPY $sgpr6
  ; FAST-NEXT:   [[COPY5:%[0-9]+]]:sgpr(s32) = COPY $sgpr7
  ; FAST-NEXT:   [[COPY6:%[0-9]+]]:sgpr(s32) = COPY $sgpr8
  ; FAST-NEXT:   [[COPY7:%[0-9]+]]:sgpr(s32) = COPY $sgpr9
  ; FAST-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; FAST-NEXT:   [[COPY8:%[0-9]+]]:sgpr(s32) = COPY $sgpr10
  ; FAST-NEXT:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; FAST-NEXT:   [[COPY9:%[0-9]+]]:vgpr(s32) = COPY [[COPY8]](s32)
  ; FAST-NEXT:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:vgpr(<4 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY9]](s32), [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (<4 x s32>) from custom "ImageResource")
  ; FAST-NEXT:   [[COPY10:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; FAST-NEXT:   G_STORE [[AMDGPU_INTRIN_IMAGE_LOAD]](<4 x s32>), [[COPY10]](p1) :: (store (<4 x s32>) into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; FAST-NEXT:   S_ENDPGM 0
  ; GREEDY-LABEL: name: load_1d_sgpr_vaddr__sgpr_srsrc
  ; GREEDY: bb.1 (%ir-block.0):
  ; GREEDY-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $sgpr10
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   [[COPY:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; GREEDY-NEXT:   [[COPY1:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; GREEDY-NEXT:   [[COPY2:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; GREEDY-NEXT:   [[COPY3:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; GREEDY-NEXT:   [[COPY4:%[0-9]+]]:sgpr(s32) = COPY $sgpr6
  ; GREEDY-NEXT:   [[COPY5:%[0-9]+]]:sgpr(s32) = COPY $sgpr7
  ; GREEDY-NEXT:   [[COPY6:%[0-9]+]]:sgpr(s32) = COPY $sgpr8
  ; GREEDY-NEXT:   [[COPY7:%[0-9]+]]:sgpr(s32) = COPY $sgpr9
  ; GREEDY-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GREEDY-NEXT:   [[COPY8:%[0-9]+]]:sgpr(s32) = COPY $sgpr10
  ; GREEDY-NEXT:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; GREEDY-NEXT:   [[COPY9:%[0-9]+]]:vgpr(s32) = COPY [[COPY8]](s32)
  ; GREEDY-NEXT:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:vgpr(<4 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY9]](s32), [[BUILD_VECTOR]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (<4 x s32>) from custom "ImageResource")
  ; GREEDY-NEXT:   [[COPY10:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; GREEDY-NEXT:   G_STORE [[AMDGPU_INTRIN_IMAGE_LOAD]](<4 x s32>), [[COPY10]](p1) :: (store (<4 x s32>) into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; GREEDY-NEXT:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Waterfall loop needed for rsrc
define amdgpu_ps void @load_1d_vgpr_vaddr__vgpr_srsrc(<8 x i32> %rsrc, i32 %s) {
  ; FAST-LABEL: name: load_1d_vgpr_vaddr__vgpr_srsrc
  ; FAST: bb.1 (%ir-block.0):
  ; FAST-NEXT:   successors: %bb.2(0x80000000)
  ; FAST-NEXT:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7, $vgpr8
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   [[COPY:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; FAST-NEXT:   [[COPY1:%[0-9]+]]:vgpr(s32) = COPY $vgpr1
  ; FAST-NEXT:   [[COPY2:%[0-9]+]]:vgpr(s32) = COPY $vgpr2
  ; FAST-NEXT:   [[COPY3:%[0-9]+]]:vgpr(s32) = COPY $vgpr3
  ; FAST-NEXT:   [[COPY4:%[0-9]+]]:vgpr(s32) = COPY $vgpr4
  ; FAST-NEXT:   [[COPY5:%[0-9]+]]:vgpr(s32) = COPY $vgpr5
  ; FAST-NEXT:   [[COPY6:%[0-9]+]]:vgpr(s32) = COPY $vgpr6
  ; FAST-NEXT:   [[COPY7:%[0-9]+]]:vgpr(s32) = COPY $vgpr7
  ; FAST-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:vgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; FAST-NEXT:   [[COPY8:%[0-9]+]]:vgpr(s32) = COPY $vgpr8
  ; FAST-NEXT:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; FAST-NEXT:   [[DEF1:%[0-9]+]]:sreg_64_xexec = IMPLICIT_DEF
  ; FAST-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64_xexec = S_MOV_B64 $exec
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT: bb.2:
  ; FAST-NEXT:   successors: %bb.3(0x80000000)
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   [[PHI:%[0-9]+]]:sreg_64_xexec = PHI [[DEF1]], %bb.1, %17, %bb.3
  ; FAST-NEXT:   [[UV:%[0-9]+]]:vgpr_32(s32), [[UV1:%[0-9]+]]:vgpr_32(s32), [[UV2:%[0-9]+]]:vgpr_32(s32), [[UV3:%[0-9]+]]:vgpr_32(s32), [[UV4:%[0-9]+]]:vgpr_32(s32), [[UV5:%[0-9]+]]:vgpr_32(s32), [[UV6:%[0-9]+]]:vgpr_32(s32), [[UV7:%[0-9]+]]:vgpr_32(s32) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV1]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV2]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV3]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV4]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_5:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV5]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_6:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV6]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_7:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV7]](s32), implicit $exec
  ; FAST-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32), [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32), [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32), [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; FAST-NEXT:   [[UV8:%[0-9]+]]:vgpr(s64), [[UV9:%[0-9]+]]:vgpr(s64), [[UV10:%[0-9]+]]:vgpr(s64), [[UV11:%[0-9]+]]:vgpr(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; FAST-NEXT:   [[UV12:%[0-9]+]]:sgpr(s64), [[UV13:%[0-9]+]]:sgpr(s64), [[UV14:%[0-9]+]]:sgpr(s64), [[UV15:%[0-9]+]]:sgpr(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR1]](<8 x s32>)
  ; FAST-NEXT:   [[ICMP:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV12]](s64), [[UV8]]
  ; FAST-NEXT:   [[ICMP1:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV13]](s64), [[UV9]]
  ; FAST-NEXT:   [[AND:%[0-9]+]]:vcc(s1) = G_AND [[ICMP]], [[ICMP1]]
  ; FAST-NEXT:   [[ICMP2:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV14]](s64), [[UV10]]
  ; FAST-NEXT:   [[AND1:%[0-9]+]]:vcc(s1) = G_AND [[AND]], [[ICMP2]]
  ; FAST-NEXT:   [[ICMP3:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV15]](s64), [[UV11]]
  ; FAST-NEXT:   [[AND2:%[0-9]+]]:vcc(s1) = G_AND [[AND1]], [[ICMP3]]
  ; FAST-NEXT:   [[INT:%[0-9]+]]:sreg_64_xexec(s64) = G_INTRINSIC intrinsic(@llvm.amdgcn.ballot), [[AND2]](s1)
  ; FAST-NEXT:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[INT]](s64), implicit-def $exec, implicit-def $scc, implicit $exec
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT: bb.3:
  ; FAST-NEXT:   successors: %bb.4(0x40000000), %bb.2(0x40000000)
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:vgpr(<4 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY8]](s32), [[BUILD_VECTOR1]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (<4 x s32>) from custom "ImageResource")
  ; FAST-NEXT:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; FAST-NEXT:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT: bb.4:
  ; FAST-NEXT:   successors: %bb.5(0x80000000)
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   $exec = S_MOV_B64_term [[S_MOV_B64_]]
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT: bb.5:
  ; FAST-NEXT:   [[COPY9:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; FAST-NEXT:   G_STORE [[AMDGPU_INTRIN_IMAGE_LOAD]](<4 x s32>), [[COPY9]](p1) :: (store (<4 x s32>) into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; FAST-NEXT:   S_ENDPGM 0
  ; GREEDY-LABEL: name: load_1d_vgpr_vaddr__vgpr_srsrc
  ; GREEDY: bb.1 (%ir-block.0):
  ; GREEDY-NEXT:   successors: %bb.2(0x80000000)
  ; GREEDY-NEXT:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7, $vgpr8
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   [[COPY:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; GREEDY-NEXT:   [[COPY1:%[0-9]+]]:vgpr(s32) = COPY $vgpr1
  ; GREEDY-NEXT:   [[COPY2:%[0-9]+]]:vgpr(s32) = COPY $vgpr2
  ; GREEDY-NEXT:   [[COPY3:%[0-9]+]]:vgpr(s32) = COPY $vgpr3
  ; GREEDY-NEXT:   [[COPY4:%[0-9]+]]:vgpr(s32) = COPY $vgpr4
  ; GREEDY-NEXT:   [[COPY5:%[0-9]+]]:vgpr(s32) = COPY $vgpr5
  ; GREEDY-NEXT:   [[COPY6:%[0-9]+]]:vgpr(s32) = COPY $vgpr6
  ; GREEDY-NEXT:   [[COPY7:%[0-9]+]]:vgpr(s32) = COPY $vgpr7
  ; GREEDY-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:vgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GREEDY-NEXT:   [[COPY8:%[0-9]+]]:vgpr(s32) = COPY $vgpr8
  ; GREEDY-NEXT:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; GREEDY-NEXT:   [[DEF1:%[0-9]+]]:sreg_64_xexec = IMPLICIT_DEF
  ; GREEDY-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64_xexec = S_MOV_B64 $exec
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT: bb.2:
  ; GREEDY-NEXT:   successors: %bb.3(0x80000000)
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   [[PHI:%[0-9]+]]:sreg_64_xexec = PHI [[DEF1]], %bb.1, %17, %bb.3
  ; GREEDY-NEXT:   [[UV:%[0-9]+]]:vgpr_32(s32), [[UV1:%[0-9]+]]:vgpr_32(s32), [[UV2:%[0-9]+]]:vgpr_32(s32), [[UV3:%[0-9]+]]:vgpr_32(s32), [[UV4:%[0-9]+]]:vgpr_32(s32), [[UV5:%[0-9]+]]:vgpr_32(s32), [[UV6:%[0-9]+]]:vgpr_32(s32), [[UV7:%[0-9]+]]:vgpr_32(s32) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV1]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV2]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV3]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV4]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_5:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV5]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_6:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV6]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_7:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV7]](s32), implicit $exec
  ; GREEDY-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32), [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32), [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32), [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; GREEDY-NEXT:   [[UV8:%[0-9]+]]:vgpr(s64), [[UV9:%[0-9]+]]:vgpr(s64), [[UV10:%[0-9]+]]:vgpr(s64), [[UV11:%[0-9]+]]:vgpr(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; GREEDY-NEXT:   [[UV12:%[0-9]+]]:sgpr(s64), [[UV13:%[0-9]+]]:sgpr(s64), [[UV14:%[0-9]+]]:sgpr(s64), [[UV15:%[0-9]+]]:sgpr(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR1]](<8 x s32>)
  ; GREEDY-NEXT:   [[ICMP:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV12]](s64), [[UV8]]
  ; GREEDY-NEXT:   [[ICMP1:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV13]](s64), [[UV9]]
  ; GREEDY-NEXT:   [[AND:%[0-9]+]]:vcc(s1) = G_AND [[ICMP]], [[ICMP1]]
  ; GREEDY-NEXT:   [[ICMP2:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV14]](s64), [[UV10]]
  ; GREEDY-NEXT:   [[AND1:%[0-9]+]]:vcc(s1) = G_AND [[AND]], [[ICMP2]]
  ; GREEDY-NEXT:   [[ICMP3:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV15]](s64), [[UV11]]
  ; GREEDY-NEXT:   [[AND2:%[0-9]+]]:vcc(s1) = G_AND [[AND1]], [[ICMP3]]
  ; GREEDY-NEXT:   [[INT:%[0-9]+]]:sreg_64_xexec(s64) = G_INTRINSIC intrinsic(@llvm.amdgcn.ballot), [[AND2]](s1)
  ; GREEDY-NEXT:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[INT]](s64), implicit-def $exec, implicit-def $scc, implicit $exec
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT: bb.3:
  ; GREEDY-NEXT:   successors: %bb.4(0x40000000), %bb.2(0x40000000)
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:vgpr(<4 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY8]](s32), [[BUILD_VECTOR1]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (<4 x s32>) from custom "ImageResource")
  ; GREEDY-NEXT:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; GREEDY-NEXT:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT: bb.4:
  ; GREEDY-NEXT:   successors: %bb.5(0x80000000)
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   $exec = S_MOV_B64_term [[S_MOV_B64_]]
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT: bb.5:
  ; GREEDY-NEXT:   [[COPY9:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; GREEDY-NEXT:   G_STORE [[AMDGPU_INTRIN_IMAGE_LOAD]](<4 x s32>), [[COPY9]](p1) :: (store (<4 x s32>) into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; GREEDY-NEXT:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Waterfall loop needed for rsrc, copy needed for vaddr
define amdgpu_ps void @load_1d_sgpr_vaddr__vgpr_srsrc(<8 x i32> %rsrc, i32 inreg %s) {
  ; FAST-LABEL: name: load_1d_sgpr_vaddr__vgpr_srsrc
  ; FAST: bb.1 (%ir-block.0):
  ; FAST-NEXT:   successors: %bb.2(0x80000000)
  ; FAST-NEXT:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   [[COPY:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; FAST-NEXT:   [[COPY1:%[0-9]+]]:vgpr(s32) = COPY $vgpr1
  ; FAST-NEXT:   [[COPY2:%[0-9]+]]:vgpr(s32) = COPY $vgpr2
  ; FAST-NEXT:   [[COPY3:%[0-9]+]]:vgpr(s32) = COPY $vgpr3
  ; FAST-NEXT:   [[COPY4:%[0-9]+]]:vgpr(s32) = COPY $vgpr4
  ; FAST-NEXT:   [[COPY5:%[0-9]+]]:vgpr(s32) = COPY $vgpr5
  ; FAST-NEXT:   [[COPY6:%[0-9]+]]:vgpr(s32) = COPY $vgpr6
  ; FAST-NEXT:   [[COPY7:%[0-9]+]]:vgpr(s32) = COPY $vgpr7
  ; FAST-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:vgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; FAST-NEXT:   [[COPY8:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; FAST-NEXT:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; FAST-NEXT:   [[COPY9:%[0-9]+]]:vgpr(s32) = COPY [[COPY8]](s32)
  ; FAST-NEXT:   [[DEF1:%[0-9]+]]:sreg_64_xexec = IMPLICIT_DEF
  ; FAST-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64_xexec = S_MOV_B64 $exec
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT: bb.2:
  ; FAST-NEXT:   successors: %bb.3(0x80000000)
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   [[PHI:%[0-9]+]]:sreg_64_xexec = PHI [[DEF1]], %bb.1, %18, %bb.3
  ; FAST-NEXT:   [[UV:%[0-9]+]]:vgpr_32(s32), [[UV1:%[0-9]+]]:vgpr_32(s32), [[UV2:%[0-9]+]]:vgpr_32(s32), [[UV3:%[0-9]+]]:vgpr_32(s32), [[UV4:%[0-9]+]]:vgpr_32(s32), [[UV5:%[0-9]+]]:vgpr_32(s32), [[UV6:%[0-9]+]]:vgpr_32(s32), [[UV7:%[0-9]+]]:vgpr_32(s32) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV1]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV2]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV3]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV4]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_5:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV5]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_6:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV6]](s32), implicit $exec
  ; FAST-NEXT:   [[V_READFIRSTLANE_B32_7:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV7]](s32), implicit $exec
  ; FAST-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32), [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32), [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32), [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; FAST-NEXT:   [[UV8:%[0-9]+]]:vgpr(s64), [[UV9:%[0-9]+]]:vgpr(s64), [[UV10:%[0-9]+]]:vgpr(s64), [[UV11:%[0-9]+]]:vgpr(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; FAST-NEXT:   [[UV12:%[0-9]+]]:sgpr(s64), [[UV13:%[0-9]+]]:sgpr(s64), [[UV14:%[0-9]+]]:sgpr(s64), [[UV15:%[0-9]+]]:sgpr(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR1]](<8 x s32>)
  ; FAST-NEXT:   [[ICMP:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV12]](s64), [[UV8]]
  ; FAST-NEXT:   [[ICMP1:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV13]](s64), [[UV9]]
  ; FAST-NEXT:   [[AND:%[0-9]+]]:vcc(s1) = G_AND [[ICMP]], [[ICMP1]]
  ; FAST-NEXT:   [[ICMP2:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV14]](s64), [[UV10]]
  ; FAST-NEXT:   [[AND1:%[0-9]+]]:vcc(s1) = G_AND [[AND]], [[ICMP2]]
  ; FAST-NEXT:   [[ICMP3:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV15]](s64), [[UV11]]
  ; FAST-NEXT:   [[AND2:%[0-9]+]]:vcc(s1) = G_AND [[AND1]], [[ICMP3]]
  ; FAST-NEXT:   [[INT:%[0-9]+]]:sreg_64_xexec(s64) = G_INTRINSIC intrinsic(@llvm.amdgcn.ballot), [[AND2]](s1)
  ; FAST-NEXT:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[INT]](s64), implicit-def $exec, implicit-def $scc, implicit $exec
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT: bb.3:
  ; FAST-NEXT:   successors: %bb.4(0x40000000), %bb.2(0x40000000)
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:vgpr(<4 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY9]](s32), [[BUILD_VECTOR1]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (<4 x s32>) from custom "ImageResource")
  ; FAST-NEXT:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; FAST-NEXT:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT: bb.4:
  ; FAST-NEXT:   successors: %bb.5(0x80000000)
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT:   $exec = S_MOV_B64_term [[S_MOV_B64_]]
  ; FAST-NEXT: {{  $}}
  ; FAST-NEXT: bb.5:
  ; FAST-NEXT:   [[COPY10:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; FAST-NEXT:   G_STORE [[AMDGPU_INTRIN_IMAGE_LOAD]](<4 x s32>), [[COPY10]](p1) :: (store (<4 x s32>) into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; FAST-NEXT:   S_ENDPGM 0
  ; GREEDY-LABEL: name: load_1d_sgpr_vaddr__vgpr_srsrc
  ; GREEDY: bb.1 (%ir-block.0):
  ; GREEDY-NEXT:   successors: %bb.2(0x80000000)
  ; GREEDY-NEXT:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   [[COPY:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; GREEDY-NEXT:   [[COPY1:%[0-9]+]]:vgpr(s32) = COPY $vgpr1
  ; GREEDY-NEXT:   [[COPY2:%[0-9]+]]:vgpr(s32) = COPY $vgpr2
  ; GREEDY-NEXT:   [[COPY3:%[0-9]+]]:vgpr(s32) = COPY $vgpr3
  ; GREEDY-NEXT:   [[COPY4:%[0-9]+]]:vgpr(s32) = COPY $vgpr4
  ; GREEDY-NEXT:   [[COPY5:%[0-9]+]]:vgpr(s32) = COPY $vgpr5
  ; GREEDY-NEXT:   [[COPY6:%[0-9]+]]:vgpr(s32) = COPY $vgpr6
  ; GREEDY-NEXT:   [[COPY7:%[0-9]+]]:vgpr(s32) = COPY $vgpr7
  ; GREEDY-NEXT:   [[BUILD_VECTOR:%[0-9]+]]:vgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; GREEDY-NEXT:   [[COPY8:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; GREEDY-NEXT:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; GREEDY-NEXT:   [[COPY9:%[0-9]+]]:vgpr(s32) = COPY [[COPY8]](s32)
  ; GREEDY-NEXT:   [[DEF1:%[0-9]+]]:sreg_64_xexec = IMPLICIT_DEF
  ; GREEDY-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64_xexec = S_MOV_B64 $exec
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT: bb.2:
  ; GREEDY-NEXT:   successors: %bb.3(0x80000000)
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   [[PHI:%[0-9]+]]:sreg_64_xexec = PHI [[DEF1]], %bb.1, %18, %bb.3
  ; GREEDY-NEXT:   [[UV:%[0-9]+]]:vgpr_32(s32), [[UV1:%[0-9]+]]:vgpr_32(s32), [[UV2:%[0-9]+]]:vgpr_32(s32), [[UV3:%[0-9]+]]:vgpr_32(s32), [[UV4:%[0-9]+]]:vgpr_32(s32), [[UV5:%[0-9]+]]:vgpr_32(s32), [[UV6:%[0-9]+]]:vgpr_32(s32), [[UV7:%[0-9]+]]:vgpr_32(s32) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV1]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV2]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV3]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV4]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_5:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV5]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_6:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV6]](s32), implicit $exec
  ; GREEDY-NEXT:   [[V_READFIRSTLANE_B32_7:%[0-9]+]]:sreg_32(s32) = V_READFIRSTLANE_B32 [[UV7]](s32), implicit $exec
  ; GREEDY-NEXT:   [[BUILD_VECTOR1:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32), [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32), [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32), [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; GREEDY-NEXT:   [[UV8:%[0-9]+]]:vgpr(s64), [[UV9:%[0-9]+]]:vgpr(s64), [[UV10:%[0-9]+]]:vgpr(s64), [[UV11:%[0-9]+]]:vgpr(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; GREEDY-NEXT:   [[UV12:%[0-9]+]]:sgpr(s64), [[UV13:%[0-9]+]]:sgpr(s64), [[UV14:%[0-9]+]]:sgpr(s64), [[UV15:%[0-9]+]]:sgpr(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR1]](<8 x s32>)
  ; GREEDY-NEXT:   [[ICMP:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV12]](s64), [[UV8]]
  ; GREEDY-NEXT:   [[ICMP1:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV13]](s64), [[UV9]]
  ; GREEDY-NEXT:   [[AND:%[0-9]+]]:vcc(s1) = G_AND [[ICMP]], [[ICMP1]]
  ; GREEDY-NEXT:   [[ICMP2:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV14]](s64), [[UV10]]
  ; GREEDY-NEXT:   [[AND1:%[0-9]+]]:vcc(s1) = G_AND [[AND]], [[ICMP2]]
  ; GREEDY-NEXT:   [[ICMP3:%[0-9]+]]:vcc(s1) = G_ICMP intpred(eq), [[UV15]](s64), [[UV11]]
  ; GREEDY-NEXT:   [[AND2:%[0-9]+]]:vcc(s1) = G_AND [[AND1]], [[ICMP3]]
  ; GREEDY-NEXT:   [[INT:%[0-9]+]]:sreg_64_xexec(s64) = G_INTRINSIC intrinsic(@llvm.amdgcn.ballot), [[AND2]](s1)
  ; GREEDY-NEXT:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[INT]](s64), implicit-def $exec, implicit-def $scc, implicit $exec
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT: bb.3:
  ; GREEDY-NEXT:   successors: %bb.4(0x40000000), %bb.2(0x40000000)
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   [[AMDGPU_INTRIN_IMAGE_LOAD:%[0-9]+]]:vgpr(<4 x s32>) = G_AMDGPU_INTRIN_IMAGE_LOAD intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY9]](s32), [[BUILD_VECTOR1]](<8 x s32>), 0, 0, 0 :: (dereferenceable load (<4 x s32>) from custom "ImageResource")
  ; GREEDY-NEXT:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; GREEDY-NEXT:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT: bb.4:
  ; GREEDY-NEXT:   successors: %bb.5(0x80000000)
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT:   $exec = S_MOV_B64_term [[S_MOV_B64_]]
  ; GREEDY-NEXT: {{  $}}
  ; GREEDY-NEXT: bb.5:
  ; GREEDY-NEXT:   [[COPY10:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; GREEDY-NEXT:   G_STORE [[AMDGPU_INTRIN_IMAGE_LOAD]](<4 x s32>), [[COPY10]](p1) :: (store (<4 x s32>) into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; GREEDY-NEXT:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

declare <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
