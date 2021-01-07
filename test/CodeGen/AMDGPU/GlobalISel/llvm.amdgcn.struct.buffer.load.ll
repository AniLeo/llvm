; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx810 -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck %s

; Natural mapping
define amdgpu_ps float @struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORD_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.struct.buffer.load.f32(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret float %val
}

; Natural mapping
define amdgpu_ps <2 x float> @struct_buffer_load_v2f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_v2f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORDX2_BOTHEN:%[0-9]+]]:vreg_64 = BUFFER_LOAD_DWORDX2_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 8 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX2_BOTHEN]].sub0
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX2_BOTHEN]].sub1
  ; CHECK:   $vgpr0 = COPY [[COPY7]]
  ; CHECK:   $vgpr1 = COPY [[COPY8]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  %val = call <2 x float> @llvm.amdgcn.struct.buffer.load.v2f32(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret <2 x float> %val
}

; Natural mapping
define amdgpu_ps <3 x float> @struct_buffer_load_v3f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_v3f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORDX3_BOTHEN:%[0-9]+]]:vreg_96 = BUFFER_LOAD_DWORDX3_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 12 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX3_BOTHEN]].sub0
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX3_BOTHEN]].sub1
  ; CHECK:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX3_BOTHEN]].sub2
  ; CHECK:   $vgpr0 = COPY [[COPY7]]
  ; CHECK:   $vgpr1 = COPY [[COPY8]]
  ; CHECK:   $vgpr2 = COPY [[COPY9]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1, implicit $vgpr2
  %val = call <3 x float> @llvm.amdgcn.struct.buffer.load.v3f32(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret <3 x float> %val
}

; Natural mapping
define amdgpu_ps <4 x float> @struct_buffer_load_v4f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_v4f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORDX4_BOTHEN:%[0-9]+]]:vreg_128 = BUFFER_LOAD_DWORDX4_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 16 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX4_BOTHEN]].sub0
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX4_BOTHEN]].sub1
  ; CHECK:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX4_BOTHEN]].sub2
  ; CHECK:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX4_BOTHEN]].sub3
  ; CHECK:   $vgpr0 = COPY [[COPY7]]
  ; CHECK:   $vgpr1 = COPY [[COPY8]]
  ; CHECK:   $vgpr2 = COPY [[COPY9]]
  ; CHECK:   $vgpr3 = COPY [[COPY10]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1, implicit $vgpr2, implicit $vgpr3
  %val = call <4 x float> @llvm.amdgcn.struct.buffer.load.v4f32(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret <4 x float> %val
}

; Natural mapping
define amdgpu_ps float @struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_vindex0(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_vindex0
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY6]], %subreg.sub0, [[COPY4]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORD_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY5]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.struct.buffer.load.f32(<4 x i32> %rsrc, i32 0, i32 %voffset, i32 %soffset, i32 0)
  ret float %val
}

; Natural mapping
define amdgpu_ps float @struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_voffset_add4095(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset.base, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_voffset_add4095
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORD_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 4095, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7" + 4095, align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %voffset = add i32 %voffset.base, 4095
  %val = call float @llvm.amdgcn.struct.buffer.load.f32(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret float %val
}

define amdgpu_ps float @struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_soffset_64(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset) {
  ; CHECK-LABEL: name: struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_soffset_64
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 64
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORD_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[S_MOV_B32_]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.struct.buffer.load.f32(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 64, i32 0)
  ret float %val
}

; Need to legalize all reg operands
define amdgpu_ps float @struct_buffer_load_f32__vgpr_rsrc__sgpr_vindex__sgpr_voffset__vgpr_soffset(<4 x i32> %rsrc, i32 inreg %vindex, i32 inreg %voffset, i32 %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_f32__vgpr_rsrc__sgpr_vindex__sgpr_voffset__vgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   successors: %bb.2(0x80000000)
  ; CHECK:   liveins: $sgpr2, $sgpr3, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; CHECK:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[COPY4]]
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[COPY5]]
  ; CHECK:   [[COPY9:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; CHECK:   [[COPY10:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; CHECK:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; CHECK: bb.2:
  ; CHECK:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub0, implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub1, implicit $exec
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; CHECK:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY9]], implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub0, implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub1, implicit $exec
  ; CHECK:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; CHECK:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY10]], implicit $exec
  ; CHECK:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; CHECK:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; CHECK:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY6]], implicit $exec
  ; CHECK:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY6]], implicit $exec
  ; CHECK:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U32_e64_]], [[S_AND_B64_]], implicit-def $scc
  ; CHECK:   [[REG_SEQUENCE4:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY7]], %subreg.sub0, [[COPY8]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORD_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_BOTHEN [[REG_SEQUENCE4]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; CHECK: bb.3:
  ; CHECK:   successors: %bb.4(0x80000000)
  ; CHECK:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; CHECK: bb.4:
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.struct.buffer.load.f32(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret float %val
}

define amdgpu_ps float @struct_buffer_load_i8_zext__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_i8_zext__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_UBYTE_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_UBYTE_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 1 from custom "TargetCustom7", addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_UBYTE_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call i8 @llvm.amdgcn.struct.buffer.load.i8(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  %ext = zext i8 %val to i32
  %cast = bitcast i32 %ext to float
  ret float %cast
}

define amdgpu_ps float @struct_buffer_load_i8_sext__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_i8_sext__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_UBYTE_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_UBYTE_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 1 from custom "TargetCustom7", addrspace 4)
  ; CHECK:   [[V_BFE_I32_e64_:%[0-9]+]]:vgpr_32 = V_BFE_I32_e64 [[BUFFER_LOAD_UBYTE_BOTHEN]], 0, 8, implicit $exec
  ; CHECK:   $vgpr0 = COPY [[V_BFE_I32_e64_]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call i8 @llvm.amdgcn.struct.buffer.load.i8(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  %ext = sext i8 %val to i32
  %cast = bitcast i32 %ext to float
  ret float %cast
}

define amdgpu_ps float @struct_buffer_load_i16_zext__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_i16_zext__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_USHORT_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_USHORT_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_USHORT_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call i16 @llvm.amdgcn.struct.buffer.load.i16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  %ext = zext i16 %val to i32
  %cast = bitcast i32 %ext to float
  ret float %cast
}

define amdgpu_ps float @struct_buffer_load_i16_sext__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_i16_sext__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_USHORT_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_USHORT_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[V_BFE_I32_e64_:%[0-9]+]]:vgpr_32 = V_BFE_I32_e64 [[BUFFER_LOAD_USHORT_BOTHEN]], 0, 16, implicit $exec
  ; CHECK:   $vgpr0 = COPY [[V_BFE_I32_e64_]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call i16 @llvm.amdgcn.struct.buffer.load.i16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  %ext = sext i16 %val to i32
  %cast = bitcast i32 %ext to float
  ret float %cast
}

; Natural mapping
define amdgpu_ps half @struct_buffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_USHORT_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_USHORT_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_USHORT_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call half @llvm.amdgcn.struct.buffer.load.f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret half %val
}

; Natural mapping
define amdgpu_ps <2 x half> @struct_buffer_load_v2f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_v2f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORD_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call <2 x half> @llvm.amdgcn.struct.buffer.load.v2f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret <2 x half> %val
}

; FIXME: Crashes
; define amdgpu_ps <3 x half> @struct_buffer_load_v3f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
;   %val = call <3 x half> @llvm.amdgcn.struct.buffer.load.v3f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
;   ret <3 x half> %val
; }

; Natural mapping
define amdgpu_ps <4 x half> @struct_buffer_load_v4f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_v4f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORDX2_BOTHEN:%[0-9]+]]:vreg_64 = BUFFER_LOAD_DWORDX2_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 8 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX2_BOTHEN]].sub0
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_LOAD_DWORDX2_BOTHEN]].sub1
  ; CHECK:   $vgpr0 = COPY [[COPY7]]
  ; CHECK:   $vgpr1 = COPY [[COPY8]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  %val = call <4 x half> @llvm.amdgcn.struct.buffer.load.v4f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret <4 x half> %val
}

; Natural mapping + glc
define amdgpu_ps float @struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_glc(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_load_f32__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_glc
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[BUFFER_LOAD_DWORD_BOTHEN:%[0-9]+]]:vgpr_32 = BUFFER_LOAD_DWORD_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 1, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "TargetCustom7", align 1, addrspace 4)
  ; CHECK:   $vgpr0 = COPY [[BUFFER_LOAD_DWORD_BOTHEN]]
  ; CHECK:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call float @llvm.amdgcn.struct.buffer.load.f32(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 1)
  ret float %val
}

declare i8 @llvm.amdgcn.struct.buffer.load.i8(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare i16 @llvm.amdgcn.struct.buffer.load.i16(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare float @llvm.amdgcn.struct.buffer.load.f32(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare <2 x float> @llvm.amdgcn.struct.buffer.load.v2f32(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare <3 x float> @llvm.amdgcn.struct.buffer.load.v3f32(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare <4 x float> @llvm.amdgcn.struct.buffer.load.v4f32(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare half @llvm.amdgcn.struct.buffer.load.f16(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare <2 x half> @llvm.amdgcn.struct.buffer.load.v2f16(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare <3 x half> @llvm.amdgcn.struct.buffer.load.v3f16(<4 x i32>, i32, i32, i32, i32 immarg) #0
declare <4 x half> @llvm.amdgcn.struct.buffer.load.v4f16(<4 x i32>, i32, i32, i32, i32 immarg) #0

attributes #0 = { nounwind readonly }
