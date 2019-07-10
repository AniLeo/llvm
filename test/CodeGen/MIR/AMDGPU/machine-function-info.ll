; RUN: llc -mtriple=amdgcn-mesa-mesa3d -mcpu=tahiti -stop-after finalize-isel -o %t.mir %s
; RUN: llc -run-pass=none -verify-machineinstrs %t.mir -o - | FileCheck %s

; Test that SIMachineFunctionInfo can be round trip serialized through
; MIR.

@lds = addrspace(3) global [512 x float] undef, align 4

; CHECK-LABEL: {{^}}name: kernel
; CHECK: machineFunctionInfo:
; CHECK-NEXT: explicitKernArgSize: 128
; CHECK-NEXT: maxKernArgAlign: 64
; CHECK-NEXT: ldsSize: 0
; CHECK-NEXT: isEntryFunction: true
; CHECK-NEXT: noSignedZerosFPMath: false
; CHECK-NEXT: memoryBound: false
; CHECK-NEXT: waveLimiter: false
; CHECK-NEXT: scratchRSrcReg:  '$sgpr96_sgpr97_sgpr98_sgpr99'
; CHECK-NEXT: scratchWaveOffsetReg: '$sgpr101'
; CHECK-NEXT: frameOffsetReg:  '$sgpr101'
; CHECK-NEXT: stackPtrOffsetReg: '$sgpr101'
; CHECK-NEXT: argumentInfo:
; CHECK-NEXT: privateSegmentBuffer: { reg: '$sgpr0_sgpr1_sgpr2_sgpr3' }
; CHECK-NEXT: kernargSegmentPtr: { reg: '$sgpr4_sgpr5' }
; CHECK-NEXT: workGroupIDX: { reg: '$sgpr6' }
; CHECK-NEXT: privateSegmentWaveByteOffset: { reg: '$sgpr7' }
; CHECK-NEXT: workItemIDX: { reg: '$vgpr0' }
; CHECK-NEXT: mode:
; CHECK-NEXT: ieee: true
; CHECK-NEXT: dx10-clamp: true
; CHECK-NEXT: body:
define amdgpu_kernel void @kernel(i32 %arg0, i64 %arg1, <16 x i32> %arg2) {
  %gep = getelementptr inbounds [512 x float], [512 x float] addrspace(3)* @lds, i32 0, i32 %arg0
  store float 0.0, float addrspace(3)* %gep, align 4
  ret void
}

; CHECK-LABEL: {{^}}name: ps_shader
; CHECK: machineFunctionInfo:
; CHECK-NEXT: explicitKernArgSize: 0
; CHECK-NEXT: maxKernArgAlign: 0
; CHECK-NEXT: ldsSize: 0
; CHECK-NEXT: isEntryFunction: true
; CHECK-NEXT: noSignedZerosFPMath: false
; CHECK-NEXT: memoryBound: false
; CHECK-NEXT: waveLimiter: false
; CHECK-NEXT: scratchRSrcReg:  '$sgpr96_sgpr97_sgpr98_sgpr99'
; CHECK-NEXT: scratchWaveOffsetReg: '$sgpr101'
; CHECK-NEXT: frameOffsetReg:  '$sgpr101'
; CHECK-NEXT: stackPtrOffsetReg: '$sgpr101'
; CHECK-NEXT: argumentInfo:
; CHECK-NEXT: privateSegmentWaveByteOffset: { reg: '$sgpr3' }
; CHECK-NEXT: implicitBufferPtr: { reg: '$sgpr0_sgpr1' }
; CHECK-NEXT: mode:
; CHECK-NEXT: ieee: false
; CHECK-NEXT: dx10-clamp: true
; CHECK-NEXT: body:
define amdgpu_ps void @ps_shader(i32 %arg0, i32 inreg %arg1) {
  ret void
}

; CHECK-LABEL: {{^}}name: function
; CHECK: machineFunctionInfo:
; CHECK-NEXT: explicitKernArgSize: 0
; CHECK-NEXT: maxKernArgAlign: 0
; CHECK-NEXT: ldsSize: 0
; CHECK-NEXT: isEntryFunction: false
; CHECK-NEXT: noSignedZerosFPMath: false
; CHECK-NEXT: memoryBound: false
; CHECK-NEXT: waveLimiter: false
; CHECK-NEXT: scratchRSrcReg: '$sgpr0_sgpr1_sgpr2_sgpr3'
; CHECK-NEXT: scratchWaveOffsetReg: '$sgpr33'
; CHECK-NEXT: frameOffsetReg: '$sgpr34'
; CHECK-NEXT: stackPtrOffsetReg: '$sgpr32'
; CHECK-NEXT: argumentInfo:
; CHECK-NEXT: privateSegmentBuffer: { reg: '$sgpr0_sgpr1_sgpr2_sgpr3' }
; CHECK-NEXT: privateSegmentWaveByteOffset: { reg: '$sgpr33' }
; CHECK-NEXT: mode:
; CHECK-NEXT: ieee: true
; CHECK-NEXT: dx10-clamp: true
; CHECK-NEXT: body:
define void @function() {
  ret void
}

; CHECK-LABEL: {{^}}name: function_nsz
; CHECK: machineFunctionInfo:
; CHECK-NEXT: explicitKernArgSize: 0
; CHECK-NEXT: maxKernArgAlign: 0
; CHECK-NEXT: ldsSize: 0
; CHECK-NEXT: isEntryFunction: false
; CHECK-NEXT: noSignedZerosFPMath: true
; CHECK-NEXT: memoryBound: false
; CHECK-NEXT: waveLimiter: false
; CHECK-NEXT: scratchRSrcReg: '$sgpr0_sgpr1_sgpr2_sgpr3'
; CHECK-NEXT: scratchWaveOffsetReg: '$sgpr33'
; CHECK-NEXT: frameOffsetReg: '$sgpr34'
; CHECK-NEXT: stackPtrOffsetReg: '$sgpr32'
; CHECK-NEXT: argumentInfo:
; CHECK-NEXT: privateSegmentBuffer: { reg: '$sgpr0_sgpr1_sgpr2_sgpr3' }
; CHECK-NEXT: privateSegmentWaveByteOffset: { reg: '$sgpr33' }
; CHECK-NEXT: mode:
; CHECK-NEXT: ieee: true
; CHECK-NEXT: dx10-clamp: true
; CHECK-NEXT: body:
define void @function_nsz() #0 {
  ret void
}

; CHECK-LABEL: {{^}}name: function_dx10_clamp_off
; CHECK: mode:
; CHECK-NEXT: ieee: true
; CHECK-NEXT: dx10-clamp: false
define void @function_dx10_clamp_off() #1 {
  ret void
}

; CHECK-LABEL: {{^}}name: function_ieee_off
; CHECK: mode:
; CHECK-NEXT: ieee: false
; CHECK-NEXT: dx10-clamp: true
define void @function_ieee_off() #2 {
  ret void
}

; CHECK-LABEL: {{^}}name: function_ieee_off_dx10_clamp_off
; CHECK: mode:
; CHECK-NEXT: ieee: false
; CHECK-NEXT: dx10-clamp: false
define void @function_ieee_off_dx10_clamp_off() #3 {
  ret void
}

attributes #0 = { "no-signed-zeros-fp-math" = "true" }

attributes #1 = { "amdgpu-dx10-clamp" = "false" }
attributes #2 = { "amdgpu-ieee" = "false" }
attributes #3 = { "amdgpu-dx10-clamp" = "false" "amdgpu-ieee" = "false" }
