; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck %s


; Natural mapping
define amdgpu_ps float @struct_buffer_atomic_cmpswap_i32__vgpr_val__vgpr_cmp__sgpr_rsrc__vgpr_voffset__sgpr_soffset(i32 %val, i32 %cmp, <4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_atomic_cmpswap_i32__vgpr_val__vgpr_cmp__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY2]], %subreg.sub0, [[COPY3]], %subreg.sub1, [[COPY4]], %subreg.sub2, [[COPY5]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY6]], %subreg.sub0, [[COPY7]], %subreg.sub1
  ; CHECK-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_ATOMIC_CMPSWAP_BOTHEN_RTN:%[0-9]+]]:vreg_64 = BUFFER_ATOMIC_CMPSWAP_BOTHEN_RTN [[REG_SEQUENCE2]], [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY8]], 0, 1, implicit $exec :: (volatile dereferenceable load store (s32), align 1, addrspace 4)
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_ATOMIC_CMPSWAP_BOTHEN_RTN]].sub0
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY9]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %ret = call i32 @llvm.amdgcn.struct.buffer.atomic.cmpswap.i32(i32 %val, i32 %cmp, <4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  %cast = bitcast i32 %ret to float
  ret float %cast
}

; Natural mapping
define amdgpu_ps void @struct_buffer_atomic_cmpswap_noret_i32__vgpr_val__vgpr_cmp__sgpr_rsrc__vgpr_voffset__sgpr_soffset(i32 %val, i32 %cmp, <4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_atomic_cmpswap_noret_i32__vgpr_val__vgpr_cmp__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY2]], %subreg.sub0, [[COPY3]], %subreg.sub1, [[COPY4]], %subreg.sub2, [[COPY5]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY6]], %subreg.sub0, [[COPY7]], %subreg.sub1
  ; CHECK-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1
  ; CHECK-NEXT:   BUFFER_ATOMIC_CMPSWAP_BOTHEN [[REG_SEQUENCE2]], [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY8]], 0, 0, implicit $exec :: (volatile dereferenceable load store (s32), align 1, addrspace 4)
  ; CHECK-NEXT:   S_ENDPGM 0
  %ret = call i32 @llvm.amdgcn.struct.buffer.atomic.cmpswap.i32(i32 %val, i32 %cmp, <4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

; All operands need legalization
define amdgpu_ps float @struct_buffer_atomic_cmpswap_i32__sgpr_val__sgpr_cmp__vgpr_rsrc__sgpr_voffset__vgpr_soffset(i32 inreg %val, i32 inreg %cmp, <4 x i32> %rsrc, i32 inreg %vindex, i32 inreg %voffset, i32 %soffset) {
  ; CHECK-LABEL: name: struct_buffer_atomic_cmpswap_i32__sgpr_val__sgpr_cmp__vgpr_rsrc__sgpr_voffset__vgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   successors: %bb.2(0x80000000)
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY2]], %subreg.sub0, [[COPY3]], %subreg.sub1, [[COPY4]], %subreg.sub2, [[COPY5]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[COPY1]]
  ; CHECK-NEXT:   [[COPY11:%[0-9]+]]:vgpr_32 = COPY [[COPY6]]
  ; CHECK-NEXT:   [[COPY12:%[0-9]+]]:vgpr_32 = COPY [[COPY7]]
  ; CHECK-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64_xexec = S_MOV_B64 $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2:
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY13:%[0-9]+]]:vgpr_32 = COPY [[REG_SEQUENCE]].sub0
  ; CHECK-NEXT:   [[COPY14:%[0-9]+]]:vgpr_32 = COPY [[REG_SEQUENCE]].sub1
  ; CHECK-NEXT:   [[COPY15:%[0-9]+]]:vgpr_32 = COPY [[REG_SEQUENCE]].sub2
  ; CHECK-NEXT:   [[COPY16:%[0-9]+]]:vgpr_32 = COPY [[REG_SEQUENCE]].sub3
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY13]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY14]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY15]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY16]], implicit $exec
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY17:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; CHECK-NEXT:   [[COPY18:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; CHECK-NEXT:   [[COPY19:%[0-9]+]]:sreg_64 = COPY [[REG_SEQUENCE1]].sub0_sub1
  ; CHECK-NEXT:   [[COPY20:%[0-9]+]]:sreg_64 = COPY [[REG_SEQUENCE1]].sub2_sub3
  ; CHECK-NEXT:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[COPY19]], [[COPY17]], implicit $exec
  ; CHECK-NEXT:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[COPY20]], [[COPY18]], implicit $exec
  ; CHECK-NEXT:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_]], [[V_CMP_EQ_U64_e64_1]], implicit-def dead $scc
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY8]], implicit $exec
  ; CHECK-NEXT:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY8]], implicit $exec
  ; CHECK-NEXT:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[S_AND_B64_]], [[V_CMP_EQ_U32_e64_]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3:
  ; CHECK-NEXT:   successors: %bb.4(0x40000000), %bb.2(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY11]], %subreg.sub0, [[COPY12]], %subreg.sub1
  ; CHECK-NEXT:   [[REG_SEQUENCE3:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY9]], %subreg.sub0, [[COPY10]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_ATOMIC_CMPSWAP_BOTHEN_RTN:%[0-9]+]]:vreg_64 = BUFFER_ATOMIC_CMPSWAP_BOTHEN_RTN [[REG_SEQUENCE3]], [[REG_SEQUENCE2]], [[REG_SEQUENCE1]], [[V_READFIRSTLANE_B32_4]], 0, 1, implicit $exec :: (volatile dereferenceable load store (s32), align 1, addrspace 4)
  ; CHECK-NEXT:   [[COPY21:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_ATOMIC_CMPSWAP_BOTHEN_RTN]].sub0
  ; CHECK-NEXT:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK-NEXT:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.4:
  ; CHECK-NEXT:   successors: %bb.5(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   $exec = S_MOV_B64_term [[S_MOV_B64_]]
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.5:
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY21]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %ret = call i32 @llvm.amdgcn.struct.buffer.atomic.cmpswap.i32(i32 %val, i32 %cmp, <4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  %cast = bitcast i32 %ret to float
  ret float %cast
}

; All operands need legalization
define amdgpu_ps void @struct_buffer_atomic_cmpswap_i32_noret__sgpr_val__sgpr_cmp__vgpr_rsrc__sgpr_voffset__vgpr_soffset(i32 inreg %val, i32 inreg %cmp, <4 x i32> %rsrc, i32 inreg %vindex, i32 inreg %voffset, i32 %soffset) {
  ; CHECK-LABEL: name: struct_buffer_atomic_cmpswap_i32_noret__sgpr_val__sgpr_cmp__vgpr_rsrc__sgpr_voffset__vgpr_soffset
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   successors: %bb.2(0x80000000)
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY2]], %subreg.sub0, [[COPY3]], %subreg.sub1, [[COPY4]], %subreg.sub2, [[COPY5]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[COPY]]
  ; CHECK-NEXT:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[COPY1]]
  ; CHECK-NEXT:   [[COPY11:%[0-9]+]]:vgpr_32 = COPY [[COPY6]]
  ; CHECK-NEXT:   [[COPY12:%[0-9]+]]:vgpr_32 = COPY [[COPY7]]
  ; CHECK-NEXT:   [[S_MOV_B64_:%[0-9]+]]:sreg_64_xexec = S_MOV_B64 $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.2:
  ; CHECK-NEXT:   successors: %bb.3(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY13:%[0-9]+]]:vgpr_32 = COPY [[REG_SEQUENCE]].sub0
  ; CHECK-NEXT:   [[COPY14:%[0-9]+]]:vgpr_32 = COPY [[REG_SEQUENCE]].sub1
  ; CHECK-NEXT:   [[COPY15:%[0-9]+]]:vgpr_32 = COPY [[REG_SEQUENCE]].sub2
  ; CHECK-NEXT:   [[COPY16:%[0-9]+]]:vgpr_32 = COPY [[REG_SEQUENCE]].sub3
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY13]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY14]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY15]], implicit $exec
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY16]], implicit $exec
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY17:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; CHECK-NEXT:   [[COPY18:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; CHECK-NEXT:   [[COPY19:%[0-9]+]]:sreg_64 = COPY [[REG_SEQUENCE1]].sub0_sub1
  ; CHECK-NEXT:   [[COPY20:%[0-9]+]]:sreg_64 = COPY [[REG_SEQUENCE1]].sub2_sub3
  ; CHECK-NEXT:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[COPY19]], [[COPY17]], implicit $exec
  ; CHECK-NEXT:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[COPY20]], [[COPY18]], implicit $exec
  ; CHECK-NEXT:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_]], [[V_CMP_EQ_U64_e64_1]], implicit-def dead $scc
  ; CHECK-NEXT:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32 = V_READFIRSTLANE_B32 [[COPY8]], implicit $exec
  ; CHECK-NEXT:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY8]], implicit $exec
  ; CHECK-NEXT:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[S_AND_B64_]], [[V_CMP_EQ_U32_e64_]], implicit-def dead $scc
  ; CHECK-NEXT:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.3:
  ; CHECK-NEXT:   successors: %bb.4(0x40000000), %bb.2(0x40000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY11]], %subreg.sub0, [[COPY12]], %subreg.sub1
  ; CHECK-NEXT:   [[REG_SEQUENCE3:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY9]], %subreg.sub0, [[COPY10]], %subreg.sub1
  ; CHECK-NEXT:   BUFFER_ATOMIC_CMPSWAP_BOTHEN [[REG_SEQUENCE3]], [[REG_SEQUENCE2]], [[REG_SEQUENCE1]], [[V_READFIRSTLANE_B32_4]], 0, 0, implicit $exec :: (volatile dereferenceable load store (s32), align 1, addrspace 4)
  ; CHECK-NEXT:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; CHECK-NEXT:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.4:
  ; CHECK-NEXT:   successors: %bb.5(0x80000000)
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   $exec = S_MOV_B64_term [[S_MOV_B64_]]
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT: bb.5:
  ; CHECK-NEXT:   S_ENDPGM 0
  %ret = call i32 @llvm.amdgcn.struct.buffer.atomic.cmpswap.i32(i32 %val, i32 %cmp, <4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  ret void
}

define amdgpu_ps float @struct_buffer_atomic_cmpswap_i32__vgpr_val__vgpr_cmp__sgpr_rsrc__vgpr_voffset__sgpr_soffset_voffset_add4095(i32 %val, i32 %cmp, <4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset.base, i32 inreg %soffset) {
  ; CHECK-LABEL: name: struct_buffer_atomic_cmpswap_i32__vgpr_val__vgpr_cmp__sgpr_rsrc__vgpr_voffset__sgpr_soffset_voffset_add4095
  ; CHECK: bb.1 (%ir-block.0):
  ; CHECK-NEXT:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1, $vgpr2, $vgpr3
  ; CHECK-NEXT: {{  $}}
  ; CHECK-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; CHECK-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; CHECK-NEXT:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; CHECK-NEXT:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; CHECK-NEXT:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; CHECK-NEXT:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; CHECK-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY2]], %subreg.sub0, [[COPY3]], %subreg.sub1, [[COPY4]], %subreg.sub2, [[COPY5]], %subreg.sub3
  ; CHECK-NEXT:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; CHECK-NEXT:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; CHECK-NEXT:   [[COPY8:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; CHECK-NEXT:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY6]], %subreg.sub0, [[COPY7]], %subreg.sub1
  ; CHECK-NEXT:   [[REG_SEQUENCE2:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1
  ; CHECK-NEXT:   [[BUFFER_ATOMIC_CMPSWAP_BOTHEN_RTN:%[0-9]+]]:vreg_64 = BUFFER_ATOMIC_CMPSWAP_BOTHEN_RTN [[REG_SEQUENCE2]], [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY8]], 4095, 1, implicit $exec :: (volatile dereferenceable load store (s32), align 1, addrspace 4)
  ; CHECK-NEXT:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[BUFFER_ATOMIC_CMPSWAP_BOTHEN_RTN]].sub0
  ; CHECK-NEXT:   $vgpr0 = COPY [[COPY9]]
  ; CHECK-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %voffset = add i32 %voffset.base, 4095
  %ret = call i32 @llvm.amdgcn.struct.buffer.atomic.cmpswap.i32(i32 %val, i32 %cmp, <4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 0)
  %cast = bitcast i32 %ret to float
  ret float %cast
}

declare i32 @llvm.amdgcn.struct.buffer.atomic.cmpswap.i32(i32, i32, <4 x i32>, i32, i32, i32, i32 immarg) #0
declare i64 @llvm.amdgcn.struct.buffer.atomic.cmpswap.i64(i64, i64, <4 x i32>, i32, i32, i32, i32 immarg) #0

attributes #0 = { nounwind }
