; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=hawaii -stop-after=instruction-select -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

define amdgpu_ps float @wqm_f32(float %val) {
  ; GCN-LABEL: name: wqm_f32
  ; GCN: bb.1 (%ir-block.0):
  ; GCN:   liveins: $vgpr0
  ; GCN:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN:   [[WQM:%[0-9]+]]:vgpr_32 = WQM [[COPY]], implicit $exec
  ; GCN:   $vgpr0 = COPY [[WQM]]
  ; GCN:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %ret = call float @llvm.amdgcn.wqm.f32(float %val)
  ret float %ret
}

define amdgpu_ps float @wqm_v2f16(float %arg) {
  ; GCN-LABEL: name: wqm_v2f16
  ; GCN: bb.1 (%ir-block.0):
  ; GCN:   liveins: $vgpr0
  ; GCN:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN:   [[WQM:%[0-9]+]]:vgpr_32 = WQM [[COPY]], implicit $exec
  ; GCN:   $vgpr0 = COPY [[WQM]]
  ; GCN:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = bitcast float %arg to <2 x half>
  %ret = call <2 x half> @llvm.amdgcn.wqm.v2f16(<2 x half> %val)
  %bc = bitcast <2 x half> %ret to float
  ret float %bc
}

define amdgpu_ps <2 x float> @wqm_f64(double %val) {
  ; GCN-LABEL: name: wqm_f64
  ; GCN: bb.1 (%ir-block.0):
  ; GCN:   liveins: $vgpr0, $vgpr1
  ; GCN:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GCN:   [[REG_SEQUENCE:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1
  ; GCN:   [[WQM:%[0-9]+]]:vreg_64 = WQM [[REG_SEQUENCE]], implicit $exec
  ; GCN:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY [[WQM]].sub0
  ; GCN:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY [[WQM]].sub1
  ; GCN:   $vgpr0 = COPY [[COPY2]]
  ; GCN:   $vgpr1 = COPY [[COPY3]]
  ; GCN:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  %ret = call double @llvm.amdgcn.wqm.f64(double %val)
  %bitcast = bitcast double %ret to <2 x float>
  ret <2 x float> %bitcast
}

; TODO
; define amdgpu_ps float @wqm_i1_vcc(float %val) {
;   %vcc = fcmp oeq float %val, 0.0
;   %ret = call i1 @llvm.amdgcn.wqm.i1(i1 %vcc)
;   %select = select i1 %ret, float 1.0, float 0.0
;   ret float %select
; }

define amdgpu_ps <3 x float> @wqm_v3f32(<3 x float> %val) {
  ; GCN-LABEL: name: wqm_v3f32
  ; GCN: bb.1 (%ir-block.0):
  ; GCN:   liveins: $vgpr0, $vgpr1, $vgpr2
  ; GCN:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GCN:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; GCN:   [[REG_SEQUENCE:%[0-9]+]]:vreg_96 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2
  ; GCN:   [[WQM:%[0-9]+]]:vreg_96 = WQM [[REG_SEQUENCE]], implicit $exec
  ; GCN:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY [[WQM]].sub0
  ; GCN:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY [[WQM]].sub1
  ; GCN:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY [[WQM]].sub2
  ; GCN:   $vgpr0 = COPY [[COPY3]]
  ; GCN:   $vgpr1 = COPY [[COPY4]]
  ; GCN:   $vgpr2 = COPY [[COPY5]]
  ; GCN:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1, implicit $vgpr2
  %ret = call <3 x float> @llvm.amdgcn.wqm.v3f32(<3 x float> %val)
  ret <3 x float> %ret
}

declare i1 @llvm.amdgcn.wqm.i1(i1) #0
declare float @llvm.amdgcn.wqm.f32(float) #0
declare <2 x half> @llvm.amdgcn.wqm.v2f16(<2 x half>) #0
declare <3 x float> @llvm.amdgcn.wqm.v3f32(<3 x float>) #0
declare double @llvm.amdgcn.wqm.f64(double) #0

attributes #0 = { nounwind readnone speculatable }
