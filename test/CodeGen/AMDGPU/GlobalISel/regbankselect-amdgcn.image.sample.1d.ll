; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -stop-after=regbankselect -regbankselect-fast -o - %s | FileCheck %s
; XUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -stop-after=regbankselect -regbankselect-greedy -o - %s | FileCheck %s

; Natural mapping
define amdgpu_ps void @sample_1d_vgpr_vaddr__sgpr_rsrc__sgpr_samp(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float %s) {
  ; CHECK-LABEL: name: sample_1d_vgpr_vaddr__sgpr_rsrc__sgpr_samp
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $sgpr10, $sgpr11, $sgpr12, $sgpr13, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr(s32) = COPY $sgpr6
  ; CHECK:   [[COPY5:%[0-9]+]]:sgpr(s32) = COPY $sgpr7
  ; CHECK:   [[COPY6:%[0-9]+]]:sgpr(s32) = COPY $sgpr8
  ; CHECK:   [[COPY7:%[0-9]+]]:sgpr(s32) = COPY $sgpr9
  ; CHECK:   [[COPY8:%[0-9]+]]:sgpr(s32) = COPY $sgpr10
  ; CHECK:   [[COPY9:%[0-9]+]]:sgpr(s32) = COPY $sgpr11
  ; CHECK:   [[COPY10:%[0-9]+]]:sgpr(s32) = COPY $sgpr12
  ; CHECK:   [[COPY11:%[0-9]+]]:sgpr(s32) = COPY $sgpr13
  ; CHECK:   [[COPY12:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:sgpr(<4 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32), [[COPY10]](s32), [[COPY11]](s32)
  ; CHECK:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; CHECK:   [[INT:%[0-9]+]]:vgpr(<4 x s32>) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.image.sample.1d), 15, [[COPY12]](s32), [[BUILD_VECTOR]](<8 x s32>), [[BUILD_VECTOR1]](<4 x s32>), 0, 0, 0 :: (dereferenceable load 16 from custom "TargetCustom8")
  ; CHECK:   [[COPY13:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; CHECK:   G_STORE [[INT]](<4 x s32>), [[COPY13]](p1) :: (store 16 into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; CHECK:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.sample.1d.v4f32.f32(i32 15, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Copy required for VGPR input
define amdgpu_ps void @sample_1d_sgpr_vaddr__sgpr_rsrc__sgpr_samp(<8 x i32> inreg %rsrc, <4 x i32> inreg %samp, float inreg %s) {
  ; CHECK-LABEL: name: sample_1d_sgpr_vaddr__sgpr_rsrc__sgpr_samp
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $sgpr10, $sgpr11, $sgpr12, $sgpr13, $sgpr14
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr(s32) = COPY $sgpr6
  ; CHECK:   [[COPY5:%[0-9]+]]:sgpr(s32) = COPY $sgpr7
  ; CHECK:   [[COPY6:%[0-9]+]]:sgpr(s32) = COPY $sgpr8
  ; CHECK:   [[COPY7:%[0-9]+]]:sgpr(s32) = COPY $sgpr9
  ; CHECK:   [[COPY8:%[0-9]+]]:sgpr(s32) = COPY $sgpr10
  ; CHECK:   [[COPY9:%[0-9]+]]:sgpr(s32) = COPY $sgpr11
  ; CHECK:   [[COPY10:%[0-9]+]]:sgpr(s32) = COPY $sgpr12
  ; CHECK:   [[COPY11:%[0-9]+]]:sgpr(s32) = COPY $sgpr13
  ; CHECK:   [[COPY12:%[0-9]+]]:sgpr(s32) = COPY $sgpr14
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:sgpr(<4 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32), [[COPY10]](s32), [[COPY11]](s32)
  ; CHECK:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; CHECK:   [[COPY13:%[0-9]+]]:vgpr(s32) = COPY [[COPY12]](s32)
  ; CHECK:   [[INT:%[0-9]+]]:vgpr(<4 x s32>) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.image.sample.1d), 15, [[COPY13]](s32), [[BUILD_VECTOR]](<8 x s32>), [[BUILD_VECTOR1]](<4 x s32>), 0, 0, 0 :: (dereferenceable load 16 from custom "TargetCustom8")
  ; CHECK:   [[COPY14:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; CHECK:   G_STORE [[INT]](<4 x s32>), [[COPY14]](p1) :: (store 16 into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; CHECK:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.sample.1d.v4f32.f32(i32 15, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Waterfall loop for rsrc
define amdgpu_ps void @sample_1d_vgpr_vaddr__vgpr_rsrc__sgpr_samp(<8 x i32> %rsrc, <4 x i32> inreg %samp, float %s) {
  ; CHECK-LABEL: name: sample_1d_vgpr_vaddr__vgpr_rsrc__sgpr_samp
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   successors: %bb.2(0x80000000)
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7, $vgpr8
  ; CHECK:   [[COPY:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:vgpr(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:vgpr(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:vgpr(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr(s32) = COPY $vgpr4
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr(s32) = COPY $vgpr5
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr(s32) = COPY $vgpr6
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr(s32) = COPY $vgpr7
  ; CHECK:   [[COPY8:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; CHECK:   [[COPY9:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; CHECK:   [[COPY10:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; CHECK:   [[COPY11:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; CHECK:   [[COPY12:%[0-9]+]]:vgpr(s32) = COPY $vgpr8
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:vgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:sgpr(<4 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32), [[COPY10]](s32), [[COPY11]](s32)
  ; CHECK:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; CHECK:   [[DEF1:%[0-9]+]]:vgpr(<4 x s32>) = G_IMPLICIT_DEF
  ; CHECK:   [[DEF2:%[0-9]+]]:sreg_64_xexec = IMPLICIT_DEF
  ; CHECK:   [[UV:%[0-9]+]]:vreg_64(s64), [[UV1:%[0-9]+]]:vreg_64(s64), [[UV2:%[0-9]+]]:vreg_64(s64), [[UV3:%[0-9]+]]:vreg_64(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; CHECK:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; CHECK: bb.2:
  ; CHECK:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK:   [[PHI:%[0-9]+]]:sreg_64_xexec = PHI [[DEF2]], %bb.1, %24, %bb.2
  ; CHECK:   [[PHI1:%[0-9]+]]:vgpr(<4 x s32>) = G_PHI [[DEF1]](<4 x s32>), %bb.1, %17(<4 x s32>), %bb.2
  ; CHECK:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV]].sub1(s64), implicit $exec
  ; CHECK:   [[MV:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV]](s64), [[UV]](s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV1]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV1]].sub1(s64), implicit $exec
  ; CHECK:   [[MV1:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV1]](s64), [[UV1]](s64), implicit $exec
  ; CHECK:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; CHECK:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV2]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_5:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV2]].sub1(s64), implicit $exec
  ; CHECK:   [[MV2:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_2:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV2]](s64), [[UV2]](s64), implicit $exec
  ; CHECK:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_2]], [[S_AND_B64_]], implicit-def $scc
  ; CHECK:   [[V_READFIRSTLANE_B32_6:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV3]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_7:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV3]].sub1(s64), implicit $exec
  ; CHECK:   [[MV3:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_3:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV3]](s64), [[UV3]](s64), implicit $exec
  ; CHECK:   [[S_AND_B64_2:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_3]], [[S_AND_B64_1]], implicit-def $scc
  ; CHECK:   [[BUILD_VECTOR2:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32), [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32), [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32), [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; CHECK:   [[INT:%[0-9]+]]:vgpr(<4 x s32>) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.image.sample.1d), 15, [[COPY12]](s32), [[BUILD_VECTOR2]](<8 x s32>), [[BUILD_VECTOR1]](<4 x s32>), 0, 0, 0 :: (dereferenceable load 16 from custom "TargetCustom8")
  ; CHECK:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_2]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; CHECK: bb.3:
  ; CHECK:   successors: %bb.4(0x80000000)
  ; CHECK:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; CHECK: bb.4:
  ; CHECK:   [[COPY13:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; CHECK:   G_STORE [[INT]](<4 x s32>), [[COPY13]](p1) :: (store 16 into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; CHECK:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.sample.1d.v4f32.f32(i32 15, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Waterfall loop for sampler
define amdgpu_ps void @sample_1d_vgpr_vaddr__sgpr_rsrc__vgpr_samp(<8 x i32> inreg %rsrc, <4 x i32> %samp, float %s) {
  ; CHECK-LABEL: name: sample_1d_vgpr_vaddr__sgpr_rsrc__vgpr_samp
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   successors: %bb.2(0x80000000)
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr(s32) = COPY $sgpr6
  ; CHECK:   [[COPY5:%[0-9]+]]:sgpr(s32) = COPY $sgpr7
  ; CHECK:   [[COPY6:%[0-9]+]]:sgpr(s32) = COPY $sgpr8
  ; CHECK:   [[COPY7:%[0-9]+]]:sgpr(s32) = COPY $sgpr9
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; CHECK:   [[COPY9:%[0-9]+]]:vgpr(s32) = COPY $vgpr1
  ; CHECK:   [[COPY10:%[0-9]+]]:vgpr(s32) = COPY $vgpr2
  ; CHECK:   [[COPY11:%[0-9]+]]:vgpr(s32) = COPY $vgpr3
  ; CHECK:   [[COPY12:%[0-9]+]]:vgpr(s32) = COPY $vgpr4
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:vgpr(<4 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32), [[COPY10]](s32), [[COPY11]](s32)
  ; CHECK:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; CHECK:   [[DEF1:%[0-9]+]]:vgpr(<4 x s32>) = G_IMPLICIT_DEF
  ; CHECK:   [[DEF2:%[0-9]+]]:sreg_64_xexec = IMPLICIT_DEF
  ; CHECK:   [[UV:%[0-9]+]]:vreg_64(s64), [[UV1:%[0-9]+]]:vreg_64(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR1]](<4 x s32>)
  ; CHECK:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; CHECK: bb.2:
  ; CHECK:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK:   [[PHI:%[0-9]+]]:sreg_64_xexec = PHI [[DEF2]], %bb.1, %24, %bb.2
  ; CHECK:   [[PHI1:%[0-9]+]]:vgpr(<4 x s32>) = G_PHI [[DEF1]](<4 x s32>), %bb.1, %17(<4 x s32>), %bb.2
  ; CHECK:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV]].sub1(s64), implicit $exec
  ; CHECK:   [[MV:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV]](s64), [[UV]](s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV1]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV1]].sub1(s64), implicit $exec
  ; CHECK:   [[MV1:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV1]](s64), [[UV1]](s64), implicit $exec
  ; CHECK:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; CHECK:   [[BUILD_VECTOR2:%[0-9]+]]:sgpr(<4 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32), [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32)
  ; CHECK:   [[INT:%[0-9]+]]:vgpr(<4 x s32>) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.image.sample.1d), 15, [[COPY12]](s32), [[BUILD_VECTOR]](<8 x s32>), [[BUILD_VECTOR2]](<4 x s32>), 0, 0, 0 :: (dereferenceable load 16 from custom "TargetCustom8")
  ; CHECK:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; CHECK: bb.3:
  ; CHECK:   successors: %bb.4(0x80000000)
  ; CHECK:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; CHECK: bb.4:
  ; CHECK:   [[COPY13:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; CHECK:   G_STORE [[INT]](<4 x s32>), [[COPY13]](p1) :: (store 16 into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; CHECK:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.sample.1d.v4f32.f32(i32 15, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Waterfall loop for rsrc and sampler
define amdgpu_ps void @sample_1d_vgpr_vaddr__vgpr_rsrc__vgpr_samp(<8 x i32> %rsrc, <4 x i32> %samp, float %s) {
  ; CHECK-LABEL: name: sample_1d_vgpr_vaddr__vgpr_rsrc__vgpr_samp
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   successors: %bb.2(0x80000000)
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7, $vgpr8, $vgpr9, $vgpr10, $vgpr11, $vgpr12
  ; CHECK:   [[COPY:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:vgpr(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:vgpr(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:vgpr(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr(s32) = COPY $vgpr4
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr(s32) = COPY $vgpr5
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr(s32) = COPY $vgpr6
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr(s32) = COPY $vgpr7
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr(s32) = COPY $vgpr8
  ; CHECK:   [[COPY9:%[0-9]+]]:vgpr(s32) = COPY $vgpr9
  ; CHECK:   [[COPY10:%[0-9]+]]:vgpr(s32) = COPY $vgpr10
  ; CHECK:   [[COPY11:%[0-9]+]]:vgpr(s32) = COPY $vgpr11
  ; CHECK:   [[COPY12:%[0-9]+]]:vgpr(s32) = COPY $vgpr12
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:vgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:vgpr(<4 x s32>) = G_BUILD_VECTOR [[COPY8]](s32), [[COPY9]](s32), [[COPY10]](s32), [[COPY11]](s32)
  ; CHECK:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; CHECK:   [[DEF1:%[0-9]+]]:vgpr(<4 x s32>) = G_IMPLICIT_DEF
  ; CHECK:   [[DEF2:%[0-9]+]]:sreg_64_xexec = IMPLICIT_DEF
  ; CHECK:   [[UV:%[0-9]+]]:vreg_64(s64), [[UV1:%[0-9]+]]:vreg_64(s64), [[UV2:%[0-9]+]]:vreg_64(s64), [[UV3:%[0-9]+]]:vreg_64(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; CHECK:   [[UV4:%[0-9]+]]:vreg_64(s64), [[UV5:%[0-9]+]]:vreg_64(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR1]](<4 x s32>)
  ; CHECK:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; CHECK: bb.2:
  ; CHECK:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK:   [[PHI:%[0-9]+]]:sreg_64_xexec = PHI [[DEF2]], %bb.1, %24, %bb.2
  ; CHECK:   [[PHI1:%[0-9]+]]:vgpr(<4 x s32>) = G_PHI [[DEF1]](<4 x s32>), %bb.1, %17(<4 x s32>), %bb.2
  ; CHECK:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV]].sub1(s64), implicit $exec
  ; CHECK:   [[MV:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV]](s64), [[UV]](s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV1]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV1]].sub1(s64), implicit $exec
  ; CHECK:   [[MV1:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV1]](s64), [[UV1]](s64), implicit $exec
  ; CHECK:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; CHECK:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV2]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_5:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV2]].sub1(s64), implicit $exec
  ; CHECK:   [[MV2:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_2:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV2]](s64), [[UV2]](s64), implicit $exec
  ; CHECK:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_2]], [[S_AND_B64_]], implicit-def $scc
  ; CHECK:   [[V_READFIRSTLANE_B32_6:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV3]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_7:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV3]].sub1(s64), implicit $exec
  ; CHECK:   [[MV3:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_3:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV3]](s64), [[UV3]](s64), implicit $exec
  ; CHECK:   [[S_AND_B64_2:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_3]], [[S_AND_B64_1]], implicit-def $scc
  ; CHECK:   [[BUILD_VECTOR2:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32), [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32), [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32), [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; CHECK:   [[V_READFIRSTLANE_B32_8:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV4]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_9:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV4]].sub1(s64), implicit $exec
  ; CHECK:   [[MV4:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_8]](s32), [[V_READFIRSTLANE_B32_9]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_4:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV4]](s64), [[UV4]](s64), implicit $exec
  ; CHECK:   [[S_AND_B64_3:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_4]], [[S_AND_B64_2]], implicit-def $scc
  ; CHECK:   [[V_READFIRSTLANE_B32_10:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV5]].sub0(s64), implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_11:%[0-9]+]]:sreg_32_xm0(s32) = V_READFIRSTLANE_B32 [[UV5]].sub1(s64), implicit $exec
  ; CHECK:   [[MV5:%[0-9]+]]:sreg_64_xexec(s64) = G_MERGE_VALUES [[V_READFIRSTLANE_B32_10]](s32), [[V_READFIRSTLANE_B32_11]](s32)
  ; CHECK:   [[V_CMP_EQ_U64_e64_5:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[MV5]](s64), [[UV5]](s64), implicit $exec
  ; CHECK:   [[S_AND_B64_4:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_5]], [[S_AND_B64_3]], implicit-def $scc
  ; CHECK:   [[BUILD_VECTOR3:%[0-9]+]]:sgpr(<4 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_8]](s32), [[V_READFIRSTLANE_B32_9]](s32), [[V_READFIRSTLANE_B32_10]](s32), [[V_READFIRSTLANE_B32_11]](s32)
  ; CHECK:   [[INT:%[0-9]+]]:vgpr(<4 x s32>) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.image.sample.1d), 15, [[COPY12]](s32), [[BUILD_VECTOR2]](<8 x s32>), [[BUILD_VECTOR3]](<4 x s32>), 0, 0, 0 :: (dereferenceable load 16 from custom "TargetCustom8")
  ; CHECK:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_4]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; CHECK: bb.3:
  ; CHECK:   successors: %bb.4(0x80000000)
  ; CHECK:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; CHECK: bb.4:
  ; CHECK:   [[COPY13:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; CHECK:   G_STORE [[INT]](<4 x s32>), [[COPY13]](p1) :: (store 16 into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; CHECK:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.sample.1d.v4f32.f32(i32 15, float %s, <8 x i32> %rsrc, <4 x i32> %samp, i1 false, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

declare <4 x float> @llvm.amdgcn.image.sample.1d.v4f32.f32(i32 immarg, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
