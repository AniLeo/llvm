; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -march=amdgcn -mcpu=hawaii -stop-after=instruction-select -verify-machineinstrs < %s | FileCheck -check-prefix=GCN %s

define amdgpu_ps float @softwqm_f32(float %val) {
  ; GCN-LABEL: name: softwqm_f32
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   liveins: $vgpr0
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN-NEXT:   [[SOFT_WQM:%[0-9]+]]:vgpr_32 = SOFT_WQM [[COPY]], implicit $exec
  ; GCN-NEXT:   $vgpr0 = COPY [[SOFT_WQM]]
  ; GCN-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %ret = call float @llvm.amdgcn.softwqm.f32(float %val)
  ret float %ret
}

define amdgpu_ps float @softwqm_v2f16(float %arg) {
  ; GCN-LABEL: name: softwqm_v2f16
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   liveins: $vgpr0
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN-NEXT:   [[SOFT_WQM:%[0-9]+]]:vgpr_32 = SOFT_WQM [[COPY]], implicit $exec
  ; GCN-NEXT:   $vgpr0 = COPY [[SOFT_WQM]]
  ; GCN-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = bitcast float %arg to <2 x half>
  %ret = call <2 x half> @llvm.amdgcn.softwqm.v2f16(<2 x half> %val)
  %bc = bitcast <2 x half> %ret to float
  ret float %bc
}

define amdgpu_ps <2 x float> @softwqm_f64(double %val) {
  ; GCN-LABEL: name: softwqm_f64
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   liveins: $vgpr0, $vgpr1
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GCN-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:vreg_64 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1
  ; GCN-NEXT:   [[SOFT_WQM:%[0-9]+]]:vreg_64 = SOFT_WQM [[REG_SEQUENCE]], implicit $exec
  ; GCN-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY [[SOFT_WQM]].sub0
  ; GCN-NEXT:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY [[SOFT_WQM]].sub1
  ; GCN-NEXT:   $vgpr0 = COPY [[COPY2]]
  ; GCN-NEXT:   $vgpr1 = COPY [[COPY3]]
  ; GCN-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  %ret = call double @llvm.amdgcn.softwqm.f64(double %val)
  %bitcast = bitcast double %ret to <2 x float>
  ret <2 x float> %bitcast
}

; TODO
; define amdgpu_ps float @softwqm_i1_vcc(float %val) {
;   %vcc = fcmp oeq float %val, 0.0
;   %ret = call i1 @llvm.amdgcn.softwqm.i1(i1 %vcc)
;   %select = select i1 %ret, float 1.0, float 0.0
;   ret float %select
; }

define amdgpu_ps <3 x float> @softwqm_v3f32(<3 x float> %val) {
  ; GCN-LABEL: name: softwqm_v3f32
  ; GCN: bb.1 (%ir-block.0):
  ; GCN-NEXT:   liveins: $vgpr0, $vgpr1, $vgpr2
  ; GCN-NEXT: {{  $}}
  ; GCN-NEXT:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; GCN-NEXT:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; GCN-NEXT:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; GCN-NEXT:   [[REG_SEQUENCE:%[0-9]+]]:vreg_96 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2
  ; GCN-NEXT:   [[SOFT_WQM:%[0-9]+]]:vreg_96 = SOFT_WQM [[REG_SEQUENCE]], implicit $exec
  ; GCN-NEXT:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY [[SOFT_WQM]].sub0
  ; GCN-NEXT:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY [[SOFT_WQM]].sub1
  ; GCN-NEXT:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY [[SOFT_WQM]].sub2
  ; GCN-NEXT:   $vgpr0 = COPY [[COPY3]]
  ; GCN-NEXT:   $vgpr1 = COPY [[COPY4]]
  ; GCN-NEXT:   $vgpr2 = COPY [[COPY5]]
  ; GCN-NEXT:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1, implicit $vgpr2
  %ret = call <3 x float> @llvm.amdgcn.softwqm.v3f32(<3 x float> %val)
  ret <3 x float> %ret
}

declare i1 @llvm.amdgcn.softwqm.i1(i1) #0
declare float @llvm.amdgcn.softwqm.f32(float) #0
declare <2 x half> @llvm.amdgcn.softwqm.v2f16(<2 x half>) #0
declare <3 x float> @llvm.amdgcn.softwqm.v3f32(<3 x float>) #0
declare double @llvm.amdgcn.softwqm.f64(double) #0

attributes #0 = { nounwind readnone speculatable }
