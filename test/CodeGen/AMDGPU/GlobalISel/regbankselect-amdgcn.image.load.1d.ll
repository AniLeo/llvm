; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -stop-after=regbankselect -regbankselect-fast -o - %s | FileCheck %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -stop-after=regbankselect -regbankselect-greedy -o - %s | FileCheck %s

; Natural mapping
define amdgpu_ps void @load_1d_vgpr_vaddr__sgpr_srsrc(<8 x i32> inreg %rsrc, i32 %s) {
  ; CHECK-LABEL: name: load_1d_vgpr_vaddr__sgpr_srsrc
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr(s32) = COPY $sgpr6
  ; CHECK:   [[COPY5:%[0-9]+]]:sgpr(s32) = COPY $sgpr7
  ; CHECK:   [[COPY6:%[0-9]+]]:sgpr(s32) = COPY $sgpr8
  ; CHECK:   [[COPY7:%[0-9]+]]:sgpr(s32) = COPY $sgpr9
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; CHECK:   [[INT:%[0-9]+]]:vgpr(<4 x s32>) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY8]](s32), [[BUILD_VECTOR]](<8 x s32>), 0, 0 :: (dereferenceable load 16 from custom "TargetCustom8")
  ; CHECK:   [[COPY9:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; CHECK:   G_STORE [[INT]](<4 x s32>), [[COPY9]](p1) :: (store 16 into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; CHECK:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Copy needed for VGPR argument
define amdgpu_ps void @load_1d_sgpr_vaddr__sgpr_srsrc(<8 x i32> inreg %rsrc, i32 inreg %s) {
  ; CHECK-LABEL: name: load_1d_sgpr_vaddr__sgpr_srsrc
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $sgpr7, $sgpr8, $sgpr9, $sgpr10
  ; CHECK:   [[COPY:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sgpr(s32) = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sgpr(s32) = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sgpr(s32) = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:sgpr(s32) = COPY $sgpr6
  ; CHECK:   [[COPY5:%[0-9]+]]:sgpr(s32) = COPY $sgpr7
  ; CHECK:   [[COPY6:%[0-9]+]]:sgpr(s32) = COPY $sgpr8
  ; CHECK:   [[COPY7:%[0-9]+]]:sgpr(s32) = COPY $sgpr9
  ; CHECK:   [[COPY8:%[0-9]+]]:sgpr(s32) = COPY $sgpr10
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; CHECK:   [[COPY9:%[0-9]+]]:vgpr(s32) = COPY [[COPY8]](s32)
  ; CHECK:   [[INT:%[0-9]+]]:vgpr(<4 x s32>) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY9]](s32), [[BUILD_VECTOR]](<8 x s32>), 0, 0 :: (dereferenceable load 16 from custom "TargetCustom8")
  ; CHECK:   [[COPY10:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; CHECK:   G_STORE [[INT]](<4 x s32>), [[COPY10]](p1) :: (store 16 into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; CHECK:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Waterfall loop needed for rsrc
define amdgpu_ps void @load_1d_vgpr_vaddr__vgpr_srsrc(<8 x i32> %rsrc, i32 %s) {
  ; CHECK-LABEL: name: load_1d_vgpr_vaddr__vgpr_srsrc
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   successors: %bb.2(0x80000000)
  ; CHECK:   liveins: $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7, $vgpr8
  ; CHECK:   [[COPY:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:vgpr(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:vgpr(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:vgpr(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr(s32) = COPY $vgpr4
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr(s32) = COPY $vgpr5
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr(s32) = COPY $vgpr6
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr(s32) = COPY $vgpr7
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr(s32) = COPY $vgpr8
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:vgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; CHECK:   [[DEF1:%[0-9]+]]:vgpr(<4 x s32>) = G_IMPLICIT_DEF
  ; CHECK:   [[DEF2:%[0-9]+]]:sreg_64_xexec = IMPLICIT_DEF
  ; CHECK:   [[UV:%[0-9]+]]:vreg_64(s64), [[UV1:%[0-9]+]]:vreg_64(s64), [[UV2:%[0-9]+]]:vreg_64(s64), [[UV3:%[0-9]+]]:vreg_64(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; CHECK:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; CHECK: bb.2:
  ; CHECK:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK:   [[PHI:%[0-9]+]]:sreg_64_xexec = PHI [[DEF2]], %bb.1, %19, %bb.2
  ; CHECK:   [[PHI1:%[0-9]+]]:vgpr(<4 x s32>) = G_PHI [[DEF1]](<4 x s32>), %bb.1, %12(<4 x s32>), %bb.2
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
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32), [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32), [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32), [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; CHECK:   [[INT:%[0-9]+]]:vgpr(<4 x s32>) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY8]](s32), [[BUILD_VECTOR1]](<8 x s32>), 0, 0 :: (dereferenceable load 16 from custom "TargetCustom8")
  ; CHECK:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_2]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; CHECK: bb.3:
  ; CHECK:   successors: %bb.4(0x80000000)
  ; CHECK:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; CHECK: bb.4:
  ; CHECK:   [[COPY9:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; CHECK:   G_STORE [[INT]](<4 x s32>), [[COPY9]](p1) :: (store 16 into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; CHECK:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

; Waterfall loop needed for rsrc, copy needed for vaddr
define amdgpu_ps void @load_1d_sgpr_vaddr__vgpr_srsrc(<8 x i32> %rsrc, i32 inreg %s) {
  ; CHECK-LABEL: name: load_1d_sgpr_vaddr__vgpr_srsrc
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   successors: %bb.2(0x80000000)
  ; CHECK:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7
  ; CHECK:   [[COPY:%[0-9]+]]:vgpr(s32) = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:vgpr(s32) = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:vgpr(s32) = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:vgpr(s32) = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr(s32) = COPY $vgpr4
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr(s32) = COPY $vgpr5
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr(s32) = COPY $vgpr6
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr(s32) = COPY $vgpr7
  ; CHECK:   [[COPY8:%[0-9]+]]:sgpr(s32) = COPY $sgpr2
  ; CHECK:   [[BUILD_VECTOR:%[0-9]+]]:vgpr(<8 x s32>) = G_BUILD_VECTOR [[COPY]](s32), [[COPY1]](s32), [[COPY2]](s32), [[COPY3]](s32), [[COPY4]](s32), [[COPY5]](s32), [[COPY6]](s32), [[COPY7]](s32)
  ; CHECK:   [[DEF:%[0-9]+]]:sgpr(p1) = G_IMPLICIT_DEF
  ; CHECK:   [[COPY9:%[0-9]+]]:vgpr(s32) = COPY [[COPY8]](s32)
  ; CHECK:   [[DEF1:%[0-9]+]]:vgpr(<4 x s32>) = G_IMPLICIT_DEF
  ; CHECK:   [[DEF2:%[0-9]+]]:sreg_64_xexec = IMPLICIT_DEF
  ; CHECK:   [[UV:%[0-9]+]]:vreg_64(s64), [[UV1:%[0-9]+]]:vreg_64(s64), [[UV2:%[0-9]+]]:vreg_64(s64), [[UV3:%[0-9]+]]:vreg_64(s64) = G_UNMERGE_VALUES [[BUILD_VECTOR]](<8 x s32>)
  ; CHECK:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; CHECK: bb.2:
  ; CHECK:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK:   [[PHI:%[0-9]+]]:sreg_64_xexec = PHI [[DEF2]], %bb.1, %20, %bb.2
  ; CHECK:   [[PHI1:%[0-9]+]]:vgpr(<4 x s32>) = G_PHI [[DEF1]](<4 x s32>), %bb.1, %12(<4 x s32>), %bb.2
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
  ; CHECK:   [[BUILD_VECTOR1:%[0-9]+]]:sgpr(<8 x s32>) = G_BUILD_VECTOR [[V_READFIRSTLANE_B32_]](s32), [[V_READFIRSTLANE_B32_1]](s32), [[V_READFIRSTLANE_B32_2]](s32), [[V_READFIRSTLANE_B32_3]](s32), [[V_READFIRSTLANE_B32_4]](s32), [[V_READFIRSTLANE_B32_5]](s32), [[V_READFIRSTLANE_B32_6]](s32), [[V_READFIRSTLANE_B32_7]](s32)
  ; CHECK:   [[INT:%[0-9]+]]:vgpr(<4 x s32>) = G_INTRINSIC_W_SIDE_EFFECTS intrinsic(@llvm.amdgcn.image.load.1d), 15, [[COPY9]](s32), [[BUILD_VECTOR1]](<8 x s32>), 0, 0 :: (dereferenceable load 16 from custom "TargetCustom8")
  ; CHECK:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_2]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; CHECK: bb.3:
  ; CHECK:   successors: %bb.4(0x80000000)
  ; CHECK:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; CHECK: bb.4:
  ; CHECK:   [[COPY10:%[0-9]+]]:vgpr(p1) = COPY [[DEF]](p1)
  ; CHECK:   G_STORE [[INT]](<4 x s32>), [[COPY10]](p1) :: (store 16 into `<4 x float> addrspace(1)* undef`, addrspace 1)
  ; CHECK:   S_ENDPGM 0
  %v = call <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 15, i32 %s, <8 x i32> %rsrc, i32 0, i32 0)
  store <4 x float> %v, <4 x float> addrspace(1)* undef
  ret void
}

declare <4 x float> @llvm.amdgcn.image.load.1d.v4f32.i32(i32 immarg, i32, <8 x i32>, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
