; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=tonga -stop-after=instruction-select -o - %s | FileCheck %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx810 -stop-after=instruction-select -o - %s | FileCheck %s

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_f32(<4 x i32> inreg %rsrc, float %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_f32
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
  ; CHECK:   BUFFER_STORE_FORMAT_X_OFFEN_exact [[COPY4]], [[COPY5]], [[REG_SEQUENCE]], [[COPY6]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 4 into custom "BufferResource", align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  call void @llvm.amdgcn.raw.buffer.store.format.f32(float %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__voffset_4095__sgpr_soffset_f32(<4 x i32> inreg %rsrc, float %val, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__voffset_4095__sgpr_soffset_f32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   BUFFER_STORE_FORMAT_X_OFFSET_exact [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 4095, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 4 into custom "BufferResource" + 4095, align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  call void @llvm.amdgcn.raw.buffer.store.format.f32(float %val, <4 x i32> %rsrc, i32 4095, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32(<4 x i32> inreg %rsrc, <2 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY7:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   BUFFER_STORE_FORMAT_XY_OFFEN_exact [[REG_SEQUENCE1]], [[COPY6]], [[REG_SEQUENCE]], [[COPY7]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 8 into custom "BufferResource", align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  call void @llvm.amdgcn.raw.buffer.store.format.v2f32(<2 x float> %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v3f32(<4 x i32> inreg %rsrc, <3 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v3f32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK:   [[COPY8:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_96 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1, [[COPY6]], %subreg.sub2
  ; CHECK:   BUFFER_STORE_FORMAT_XYZ_OFFEN_exact [[REG_SEQUENCE1]], [[COPY7]], [[REG_SEQUENCE]], [[COPY8]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 12 into custom "BufferResource", align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  call void @llvm.amdgcn.raw.buffer.store.format.v3f32(<3 x float> %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v4f32(<4 x i32> inreg %rsrc, <4 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v4f32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; CHECK:   [[COPY9:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1, [[COPY6]], %subreg.sub2, [[COPY7]], %subreg.sub3
  ; CHECK:   BUFFER_STORE_FORMAT_XYZW_OFFEN_exact [[REG_SEQUENCE1]], [[COPY8]], [[REG_SEQUENCE]], [[COPY9]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 16 into custom "BufferResource", align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  call void @llvm.amdgcn.raw.buffer.store.format.v4f32(<4 x float> %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__vgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v4f32(<4 x i32> %rsrc, <4 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__vgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v4f32
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   successors: %bb.2(0x80000000)
  ; CHECK:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7, $vgpr8
  ; CHECK:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr5
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr6
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr7
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY $vgpr8
  ; CHECK:   [[COPY9:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1, [[COPY6]], %subreg.sub2, [[COPY7]], %subreg.sub3
  ; CHECK:   [[COPY10:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; CHECK:   [[COPY11:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; CHECK:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; CHECK: bb.2:
  ; CHECK:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub0, implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub1, implicit $exec
  ; CHECK:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; CHECK:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY10]], implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY11]].sub0, implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY11]].sub1, implicit $exec
  ; CHECK:   [[REG_SEQUENCE3:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; CHECK:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE3]], [[COPY11]], implicit $exec
  ; CHECK:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; CHECK:   [[REG_SEQUENCE4:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; CHECK:   BUFFER_STORE_FORMAT_XYZW_OFFEN_exact [[REG_SEQUENCE1]], [[COPY8]], [[REG_SEQUENCE4]], [[COPY9]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 16 into custom "BufferResource", align 1, addrspace 4)
  ; CHECK:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; CHECK: bb.3:
  ; CHECK:   successors: %bb.4(0x80000000)
  ; CHECK:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; CHECK: bb.4:
  ; CHECK:   S_ENDPGM 0
  call void @llvm.amdgcn.raw.buffer.store.format.v4f32(<4 x float> %val, <4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_soffset4095(<4 x i32> inreg %rsrc, <2 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_soffset4095
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 4095
  ; CHECK:   BUFFER_STORE_FORMAT_XY_OFFEN_exact [[REG_SEQUENCE1]], [[COPY6]], [[REG_SEQUENCE]], [[S_MOV_B32_]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 8 into custom "BufferResource", align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  call void @llvm.amdgcn.raw.buffer.store.format.v2f32(<2 x float> %val, <4 x i32> %rsrc, i32 %voffset, i32 4095, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_soffset4096(<4 x i32> inreg %rsrc, <2 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_soffset4096
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 4096
  ; CHECK:   BUFFER_STORE_FORMAT_XY_OFFEN_exact [[REG_SEQUENCE1]], [[COPY6]], [[REG_SEQUENCE]], [[S_MOV_B32_]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 8 into custom "BufferResource", align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  call void @llvm.amdgcn.raw.buffer.store.format.v2f32(<2 x float> %val, <4 x i32> %rsrc, i32 %voffset, i32 4096, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_voffset_add_16(<4 x i32> inreg %rsrc, <2 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_voffset_add_16
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY7:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   BUFFER_STORE_FORMAT_XY_OFFEN_exact [[REG_SEQUENCE1]], [[COPY6]], [[REG_SEQUENCE]], [[COPY7]], 16, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 8 into custom "BufferResource" + 16, align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  %voffset.add = add i32 %voffset, 16
  call void @llvm.amdgcn.raw.buffer.store.format.v2f32(<2 x float> %val, <4 x i32> %rsrc, i32 %voffset.add, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_voffset_add_4095(<4 x i32> inreg %rsrc, <2 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_voffset_add_4095
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY7:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   BUFFER_STORE_FORMAT_XY_OFFEN_exact [[REG_SEQUENCE1]], [[COPY6]], [[REG_SEQUENCE]], [[COPY7]], 4095, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 8 into custom "BufferResource" + 4095, align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  %voffset.add = add i32 %voffset, 4095
  call void @llvm.amdgcn.raw.buffer.store.format.v2f32(<2 x float> %val, <4 x i32> %rsrc, i32 %voffset.add, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps void @raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_voffset_add_4096(<4 x i32> inreg %rsrc, <2 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__sgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v2f32_voffset_add_4096
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2
  ; CHECK:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY7:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; CHECK:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 4096
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; CHECK:   %13:vgpr_32, dead %17:sreg_64_xexec = V_ADD_CO_U32_e64 [[COPY6]], [[COPY8]], 0, implicit $exec
  ; CHECK:   BUFFER_STORE_FORMAT_XY_OFFEN_exact [[REG_SEQUENCE1]], %13, [[REG_SEQUENCE]], [[COPY7]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 8 into custom "BufferResource" + 4096, align 1, addrspace 4)
  ; CHECK:   S_ENDPGM 0
  %voffset.add = add i32 %voffset, 4096
  call void @llvm.amdgcn.raw.buffer.store.format.v2f32(<2 x float> %val, <4 x i32> %rsrc, i32 %voffset.add, i32 %soffset, i32 0)
  ret void
}


; Check what happens with offset add inside a waterfall loop
define amdgpu_ps void @raw_buffer_store_format__vgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v4f32_add_4096(<4 x i32> %rsrc, <4 x float> %val, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: raw_buffer_store_format__vgpr_rsrc__vgpr_val__vgpr_voffset__sgpr_soffset_v4f32_add_4096
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK:   successors: %bb.2(0x80000000)
  ; CHECK:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4, $vgpr5, $vgpr6, $vgpr7, $vgpr8
  ; CHECK:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; CHECK:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr5
  ; CHECK:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr6
  ; CHECK:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr7
  ; CHECK:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY $vgpr8
  ; CHECK:   [[COPY9:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; CHECK:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1, [[COPY6]], %subreg.sub2, [[COPY7]], %subreg.sub3
  ; CHECK:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 4096
  ; CHECK:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; CHECK:   %15:vgpr_32, dead %35:sreg_64_xexec = V_ADD_CO_U32_e64 [[COPY8]], [[COPY10]], 0, implicit $exec
  ; CHECK:   [[COPY11:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; CHECK:   [[COPY12:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; CHECK:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; CHECK: bb.2:
  ; CHECK:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; CHECK:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY11]].sub0, implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY11]].sub1, implicit $exec
  ; CHECK:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; CHECK:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY11]], implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY12]].sub0, implicit $exec
  ; CHECK:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY12]].sub1, implicit $exec
  ; CHECK:   [[REG_SEQUENCE3:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; CHECK:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE3]], [[COPY12]], implicit $exec
  ; CHECK:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; CHECK:   [[REG_SEQUENCE4:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; CHECK:   BUFFER_STORE_FORMAT_XYZW_OFFEN_exact [[REG_SEQUENCE1]], %15, [[REG_SEQUENCE4]], [[COPY9]], 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable store 16 into custom "BufferResource" + 4096, align 1, addrspace 4)
  ; CHECK:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; CHECK: bb.3:
  ; CHECK:   successors: %bb.4(0x80000000)
  ; CHECK:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; CHECK: bb.4:
  ; CHECK:   S_ENDPGM 0
  %voffset.add = add i32 %voffset, 4096
  call void @llvm.amdgcn.raw.buffer.store.format.v4f32(<4 x float> %val, <4 x i32> %rsrc, i32 %voffset.add, i32 %soffset, i32 0)
  ret void
}

declare void @llvm.amdgcn.raw.buffer.store.format.f32(float, <4 x i32>, i32, i32, i32 immarg)
declare void @llvm.amdgcn.raw.buffer.store.format.v2f32(<2 x float>, <4 x i32>, i32, i32, i32 immarg)
declare void @llvm.amdgcn.raw.buffer.store.format.v3f32(<3 x float>, <4 x i32>, i32, i32, i32 immarg)
declare void @llvm.amdgcn.raw.buffer.store.format.v4f32(<4 x float>, <4 x i32>, i32, i32, i32 immarg)
