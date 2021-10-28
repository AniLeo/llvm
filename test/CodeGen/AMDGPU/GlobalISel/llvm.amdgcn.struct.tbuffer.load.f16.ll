; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx810 -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck -check-prefix=PACKED %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx1010 -mattr=+wavefrontsize64 -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck -check-prefix=PACKED %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck -check-prefix=UNPACKED %s

define amdgpu_ps half @struct_tbuffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; PACKED-LABEL: name: struct_tbuffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; PACKED:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_BOTHEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (s16), align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_BOTHEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; UNPACKED-LABEL: name: struct_tbuffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; UNPACKED:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_BOTHEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_gfx80_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (s16), align 1, addrspace 4)
  ; UNPACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_BOTHEN]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call half @llvm.amdgcn.struct.tbuffer.load.f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret half %val
}

define amdgpu_ps <2 x half> @struct_tbuffer_load_v2f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; PACKED-LABEL: name: struct_tbuffer_load_v2f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; PACKED:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_XY_BOTHEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_XY_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (<2 x s16>), align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_XY_BOTHEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; UNPACKED-LABEL: name: struct_tbuffer_load_v2f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; UNPACKED:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_XY_gfx80_BOTHEN:%[0-9]+]]:vreg_64 = TBUFFER_LOAD_FORMAT_D16_XY_gfx80_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (<2 x s16>), align 1, addrspace 4)
  ; UNPACKED:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XY_gfx80_BOTHEN]].sub0
  ; UNPACKED:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XY_gfx80_BOTHEN]].sub1
  ; UNPACKED:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; UNPACKED:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY7]], [[COPY9]], implicit $exec
  ; UNPACKED:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_1:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY8]], [[COPY10]], implicit $exec
  ; UNPACKED:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 16
  ; UNPACKED:   [[COPY11:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; UNPACKED:   [[V_LSHLREV_B32_e64_:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 [[COPY11]], [[V_AND_B32_e64_1]], implicit $exec
  ; UNPACKED:   [[V_OR_B32_e64_:%[0-9]+]]:vgpr_32 = V_OR_B32_e64 [[V_AND_B32_e64_]], [[V_LSHLREV_B32_e64_]], implicit $exec
  ; UNPACKED:   $vgpr0 = COPY [[V_OR_B32_e64_]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call <2 x half> @llvm.amdgcn.struct.tbuffer.load.v2f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret <2 x half> %val
}

; FIXME: Crashes
; define amdgpu_ps <3 x half> @struct_tbuffer_load_v3f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
;   %val = call <3 x half> @llvm.amdgcn.struct.tbuffer.load.v3f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 78, i32 0)
;   ret <3 x half> %val
; }

define amdgpu_ps <4 x half> @struct_tbuffer_load_v4f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset, i32 inreg %soffset) {
  ; PACKED-LABEL: name: struct_tbuffer_load_v4f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; PACKED:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_XYZW_BOTHEN:%[0-9]+]]:vreg_64 = TBUFFER_LOAD_FORMAT_D16_XYZW_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (<4 x s16>), align 1, addrspace 4)
  ; PACKED:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_BOTHEN]].sub0
  ; PACKED:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_BOTHEN]].sub1
  ; PACKED:   $vgpr0 = COPY [[COPY7]]
  ; PACKED:   $vgpr1 = COPY [[COPY8]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  ; UNPACKED-LABEL: name: struct_tbuffer_load_v4f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; UNPACKED:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN:%[0-9]+]]:vreg_128 = TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (<4 x s16>), align 1, addrspace 4)
  ; UNPACKED:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN]].sub0
  ; UNPACKED:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN]].sub1
  ; UNPACKED:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN]].sub2
  ; UNPACKED:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN]].sub3
  ; UNPACKED:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; UNPACKED:   [[COPY11:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY7]], [[COPY11]], implicit $exec
  ; UNPACKED:   [[COPY12:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_1:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY8]], [[COPY12]], implicit $exec
  ; UNPACKED:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 16
  ; UNPACKED:   [[COPY13:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; UNPACKED:   [[V_LSHLREV_B32_e64_:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 [[COPY13]], [[V_AND_B32_e64_1]], implicit $exec
  ; UNPACKED:   [[V_OR_B32_e64_:%[0-9]+]]:vgpr_32 = V_OR_B32_e64 [[V_AND_B32_e64_]], [[V_LSHLREV_B32_e64_]], implicit $exec
  ; UNPACKED:   [[COPY14:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_2:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY9]], [[COPY14]], implicit $exec
  ; UNPACKED:   [[COPY15:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_3:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY10]], [[COPY15]], implicit $exec
  ; UNPACKED:   [[COPY16:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; UNPACKED:   [[V_LSHLREV_B32_e64_1:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 [[COPY16]], [[V_AND_B32_e64_3]], implicit $exec
  ; UNPACKED:   [[V_OR_B32_e64_1:%[0-9]+]]:vgpr_32 = V_OR_B32_e64 [[V_AND_B32_e64_2]], [[V_LSHLREV_B32_e64_1]], implicit $exec
  ; UNPACKED:   $vgpr0 = COPY [[V_OR_B32_e64_]]
  ; UNPACKED:   $vgpr1 = COPY [[V_OR_B32_e64_1]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  %val = call <4 x half> @llvm.amdgcn.struct.tbuffer.load.v4f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret <4 x half> %val
}

define amdgpu_ps half @struct_tbuffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_vindex0(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; PACKED-LABEL: name: struct_tbuffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_vindex0
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; PACKED:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; PACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY6]], %subreg.sub0, [[COPY4]], %subreg.sub1
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_BOTHEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (s16), align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_BOTHEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; UNPACKED-LABEL: name: struct_tbuffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_vindex0
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 0
  ; UNPACKED:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY6]], %subreg.sub0, [[COPY4]], %subreg.sub1
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_BOTHEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_gfx80_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (s16), align 1, addrspace 4)
  ; UNPACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_BOTHEN]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call half @llvm.amdgcn.struct.tbuffer.load.f16(<4 x i32> %rsrc, i32 0, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret half %val
}

define amdgpu_ps <4 x half> @struct_tbuffer_load_v4f16__vgpr_rsrc__sgpr_vindex__sgpr_voffset__vgpr_soffset(<4 x i32> %rsrc, i32 inreg %vindex, i32 inreg %voffset, i32 %soffset) {
  ; PACKED-LABEL: name: struct_tbuffer_load_v4f16__vgpr_rsrc__sgpr_vindex__sgpr_voffset__vgpr_soffset
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   successors: %bb.2(0x80000000)
  ; PACKED:   liveins: $sgpr2, $sgpr3, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; PACKED:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; PACKED:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; PACKED:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; PACKED:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[COPY4]]
  ; PACKED:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[COPY5]]
  ; PACKED:   [[COPY9:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; PACKED:   [[COPY10:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; PACKED:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; PACKED: bb.2:
  ; PACKED:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; PACKED:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub0, implicit $exec
  ; PACKED:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub1, implicit $exec
  ; PACKED:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; PACKED:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY9]], implicit $exec
  ; PACKED:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub0, implicit $exec
  ; PACKED:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub1, implicit $exec
  ; PACKED:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; PACKED:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY10]], implicit $exec
  ; PACKED:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; PACKED:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; PACKED:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY6]], implicit $exec
  ; PACKED:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY6]], implicit $exec
  ; PACKED:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U32_e64_]], [[S_AND_B64_]], implicit-def $scc
  ; PACKED:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; PACKED:   [[REG_SEQUENCE4:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY7]], %subreg.sub0, [[COPY8]], %subreg.sub1
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_XYZW_BOTHEN:%[0-9]+]]:vreg_64 = TBUFFER_LOAD_FORMAT_D16_XYZW_BOTHEN [[REG_SEQUENCE4]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (<4 x s16>), align 1, addrspace 4)
  ; PACKED:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; PACKED:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; PACKED: bb.3:
  ; PACKED:   successors: %bb.4(0x80000000)
  ; PACKED:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; PACKED: bb.4:
  ; PACKED:   [[COPY11:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_BOTHEN]].sub0
  ; PACKED:   [[COPY12:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_BOTHEN]].sub1
  ; PACKED:   $vgpr0 = COPY [[COPY11]]
  ; PACKED:   $vgpr1 = COPY [[COPY12]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  ; UNPACKED-LABEL: name: struct_tbuffer_load_v4f16__vgpr_rsrc__sgpr_vindex__sgpr_voffset__vgpr_soffset
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   successors: %bb.2(0x80000000)
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; UNPACKED:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; UNPACKED:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; UNPACKED:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; UNPACKED:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[COPY4]]
  ; UNPACKED:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[COPY5]]
  ; UNPACKED:   [[COPY9:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; UNPACKED:   [[COPY10:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; UNPACKED:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; UNPACKED: bb.2:
  ; UNPACKED:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; UNPACKED:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub0, implicit $exec
  ; UNPACKED:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY9]].sub1, implicit $exec
  ; UNPACKED:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; UNPACKED:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY9]], implicit $exec
  ; UNPACKED:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub0, implicit $exec
  ; UNPACKED:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY10]].sub1, implicit $exec
  ; UNPACKED:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; UNPACKED:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY10]], implicit $exec
  ; UNPACKED:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; UNPACKED:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; UNPACKED:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY6]], implicit $exec
  ; UNPACKED:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY6]], implicit $exec
  ; UNPACKED:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U32_e64_]], [[S_AND_B64_]], implicit-def $scc
  ; UNPACKED:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; UNPACKED:   [[REG_SEQUENCE4:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY7]], %subreg.sub0, [[COPY8]], %subreg.sub1
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN:%[0-9]+]]:vreg_128 = TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN [[REG_SEQUENCE4]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (<4 x s16>), align 1, addrspace 4)
  ; UNPACKED:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; UNPACKED:   SI_WATERFALL_LOOP %bb.2, implicit $exec
  ; UNPACKED: bb.3:
  ; UNPACKED:   successors: %bb.4(0x80000000)
  ; UNPACKED:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; UNPACKED: bb.4:
  ; UNPACKED:   [[COPY11:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN]].sub0
  ; UNPACKED:   [[COPY12:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN]].sub1
  ; UNPACKED:   [[COPY13:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN]].sub2
  ; UNPACKED:   [[COPY14:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_BOTHEN]].sub3
  ; UNPACKED:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; UNPACKED:   [[COPY15:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY11]], [[COPY15]], implicit $exec
  ; UNPACKED:   [[COPY16:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_1:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY12]], [[COPY16]], implicit $exec
  ; UNPACKED:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 16
  ; UNPACKED:   [[COPY17:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; UNPACKED:   [[V_LSHLREV_B32_e64_:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 [[COPY17]], [[V_AND_B32_e64_1]], implicit $exec
  ; UNPACKED:   [[V_OR_B32_e64_:%[0-9]+]]:vgpr_32 = V_OR_B32_e64 [[V_AND_B32_e64_]], [[V_LSHLREV_B32_e64_]], implicit $exec
  ; UNPACKED:   [[COPY18:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_2:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY13]], [[COPY18]], implicit $exec
  ; UNPACKED:   [[COPY19:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_3:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY14]], [[COPY19]], implicit $exec
  ; UNPACKED:   [[COPY20:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; UNPACKED:   [[V_LSHLREV_B32_e64_1:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 [[COPY20]], [[V_AND_B32_e64_3]], implicit $exec
  ; UNPACKED:   [[V_OR_B32_e64_1:%[0-9]+]]:vgpr_32 = V_OR_B32_e64 [[V_AND_B32_e64_2]], [[V_LSHLREV_B32_e64_1]], implicit $exec
  ; UNPACKED:   $vgpr0 = COPY [[V_OR_B32_e64_]]
  ; UNPACKED:   $vgpr1 = COPY [[V_OR_B32_e64_1]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  %val = call <4 x half> @llvm.amdgcn.struct.tbuffer.load.v4f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret <4 x half> %val
}

define amdgpu_ps half @struct_tbuffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_voffset_add4095(<4 x i32> inreg %rsrc, i32 %vindex, i32 %voffset.base, i32 inreg %soffset) {
  ; PACKED-LABEL: name: struct_tbuffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_voffset_add4095
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; PACKED:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_BOTHEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 4095, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (s16), align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_BOTHEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; UNPACKED-LABEL: name: struct_tbuffer_load_f16__sgpr_rsrc__vgpr_vindex__vgpr_voffset__sgpr_soffset_voffset_add4095
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0, $vgpr1
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; UNPACKED:   [[COPY6:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[REG_SEQUENCE1:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY4]], %subreg.sub0, [[COPY5]], %subreg.sub1
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_BOTHEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_gfx80_BOTHEN [[REG_SEQUENCE1]], [[REG_SEQUENCE]], [[COPY6]], 4095, 78, 0, 0, 0, implicit $exec :: (dereferenceable load (s16), align 1, addrspace 4)
  ; UNPACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_BOTHEN]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %voffset = add i32 %voffset.base, 4095
  %val = call half @llvm.amdgcn.struct.tbuffer.load.f16(<4 x i32> %rsrc, i32 %vindex, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret half %val
}

declare half @llvm.amdgcn.struct.tbuffer.load.f16(<4 x i32>, i32, i32, i32, i32 immarg, i32 immarg) #0
declare <2 x half> @llvm.amdgcn.struct.tbuffer.load.v2f16(<4 x i32>, i32, i32, i32, i32 immarg, i32 immarg) #0
declare <3 x half> @llvm.amdgcn.struct.tbuffer.load.v3f16(<4 x i32>, i32, i32, i32, i32 immarg, i32 immarg) #0
declare <4 x half> @llvm.amdgcn.struct.tbuffer.load.v4f16(<4 x i32>, i32, i32, i32, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
