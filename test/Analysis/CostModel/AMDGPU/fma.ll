; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx1010 -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=FAST,SLOWF64 %s
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx90a -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=FAST,FASTF64 %s
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx900 -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=FAST,SLOWF64 %s
; RUN: opt -passes='print<cost-model>' 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa < %s | FileCheck -check-prefixes=SLOW %s
; RUN: opt -passes='print<cost-model>' -cost-kind=code-size 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx1010 -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=FAST-SIZE,SLOWF64-SIZE %s
; RUN: opt -passes='print<cost-model>' -cost-kind=code-size 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx90a -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=FAST-SIZE,FASTF64-SIZE %s
; RUN: opt -passes='print<cost-model>' -cost-kind=code-size 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx900 -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=FAST-SIZE,SLOWF64-SIZE %s
; RUN: opt -passes='print<cost-model>' -cost-kind=code-size 2>&1 -disable-output -mtriple=amdgcn-unknown-amdhsa < %s | FileCheck -check-prefixes=SLOW-SIZE %s
; END.

define amdgpu_kernel void @fma_f32() #0 {
; SLOWF64-LABEL: 'fma_f32'
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f32 = call float @llvm.fma.f32(float undef, float undef, float undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2f32 = call <2 x float> @llvm.fma.v2f32(<2 x float> undef, <2 x float> undef, <2 x float> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v3f32 = call <3 x float> @llvm.fma.v3f32(<3 x float> undef, <3 x float> undef, <3 x float> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v4f32 = call <4 x float> @llvm.fma.v4f32(<4 x float> undef, <4 x float> undef, <4 x float> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %v5f32 = call <5 x float> @llvm.fma.v5f32(<5 x float> undef, <5 x float> undef, <5 x float> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v8f32 = call <8 x float> @llvm.fma.v8f32(<8 x float> undef, <8 x float> undef, <8 x float> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 96 for instruction: %v9f32 = call <9 x float> @llvm.fma.v9f32(<9 x float> undef, <9 x float> undef, <9 x float> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; FASTF64-LABEL: 'fma_f32'
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f32 = call float @llvm.fma.f32(float undef, float undef, float undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f32 = call <2 x float> @llvm.fma.v2f32(<2 x float> undef, <2 x float> undef, <2 x float> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v3f32 = call <3 x float> @llvm.fma.v3f32(<3 x float> undef, <3 x float> undef, <3 x float> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f32 = call <4 x float> @llvm.fma.v4f32(<4 x float> undef, <4 x float> undef, <4 x float> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v5f32 = call <5 x float> @llvm.fma.v5f32(<5 x float> undef, <5 x float> undef, <5 x float> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v8f32 = call <8 x float> @llvm.fma.v8f32(<8 x float> undef, <8 x float> undef, <8 x float> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %v9f32 = call <9 x float> @llvm.fma.v9f32(<9 x float> undef, <9 x float> undef, <9 x float> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; SLOW-LABEL: 'fma_f32'
; SLOW-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %f32 = call float @llvm.fma.f32(float undef, float undef, float undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v2f32 = call <2 x float> @llvm.fma.v2f32(<2 x float> undef, <2 x float> undef, <2 x float> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %v3f32 = call <3 x float> @llvm.fma.v3f32(<3 x float> undef, <3 x float> undef, <3 x float> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v4f32 = call <4 x float> @llvm.fma.v4f32(<4 x float> undef, <4 x float> undef, <4 x float> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 20 for instruction: %v5f32 = call <5 x float> @llvm.fma.v5f32(<5 x float> undef, <5 x float> undef, <5 x float> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v8f32 = call <8 x float> @llvm.fma.v8f32(<8 x float> undef, <8 x float> undef, <8 x float> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 192 for instruction: %v9f32 = call <9 x float> @llvm.fma.v9f32(<9 x float> undef, <9 x float> undef, <9 x float> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; SLOWF64-SIZE-LABEL: 'fma_f32'
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f32 = call float @llvm.fma.f32(float undef, float undef, float undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2f32 = call <2 x float> @llvm.fma.v2f32(<2 x float> undef, <2 x float> undef, <2 x float> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v3f32 = call <3 x float> @llvm.fma.v3f32(<3 x float> undef, <3 x float> undef, <3 x float> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v4f32 = call <4 x float> @llvm.fma.v4f32(<4 x float> undef, <4 x float> undef, <4 x float> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %v5f32 = call <5 x float> @llvm.fma.v5f32(<5 x float> undef, <5 x float> undef, <5 x float> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v8f32 = call <8 x float> @llvm.fma.v8f32(<8 x float> undef, <8 x float> undef, <8 x float> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 96 for instruction: %v9f32 = call <9 x float> @llvm.fma.v9f32(<9 x float> undef, <9 x float> undef, <9 x float> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; FASTF64-SIZE-LABEL: 'fma_f32'
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f32 = call float @llvm.fma.f32(float undef, float undef, float undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f32 = call <2 x float> @llvm.fma.v2f32(<2 x float> undef, <2 x float> undef, <2 x float> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v3f32 = call <3 x float> @llvm.fma.v3f32(<3 x float> undef, <3 x float> undef, <3 x float> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f32 = call <4 x float> @llvm.fma.v4f32(<4 x float> undef, <4 x float> undef, <4 x float> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v5f32 = call <5 x float> @llvm.fma.v5f32(<5 x float> undef, <5 x float> undef, <5 x float> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v8f32 = call <8 x float> @llvm.fma.v8f32(<8 x float> undef, <8 x float> undef, <8 x float> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %v9f32 = call <9 x float> @llvm.fma.v9f32(<9 x float> undef, <9 x float> undef, <9 x float> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; SLOW-SIZE-LABEL: 'fma_f32'
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f32 = call float @llvm.fma.f32(float undef, float undef, float undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2f32 = call <2 x float> @llvm.fma.v2f32(<2 x float> undef, <2 x float> undef, <2 x float> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v3f32 = call <3 x float> @llvm.fma.v3f32(<3 x float> undef, <3 x float> undef, <3 x float> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v4f32 = call <4 x float> @llvm.fma.v4f32(<4 x float> undef, <4 x float> undef, <4 x float> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %v5f32 = call <5 x float> @llvm.fma.v5f32(<5 x float> undef, <5 x float> undef, <5 x float> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v8f32 = call <8 x float> @llvm.fma.v8f32(<8 x float> undef, <8 x float> undef, <8 x float> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 96 for instruction: %v9f32 = call <9 x float> @llvm.fma.v9f32(<9 x float> undef, <9 x float> undef, <9 x float> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %f32 = call float @llvm.fma.f32(float undef, float undef, float undef) #1
  %v2f32 = call <2 x float> @llvm.fma.v2f32(<2 x float> undef, <2 x float> undef, <2 x float> undef) #1
  %v3f32 = call <3 x float> @llvm.fma.v3f32(<3 x float> undef, <3 x float> undef, <3 x float> undef) #1
  %v4f32 = call <4 x float> @llvm.fma.v4f32(<4 x float> undef, <4 x float> undef, <4 x float> undef) #1
  %v5f32 = call <5 x float> @llvm.fma.v5f32(<5 x float> undef, <5 x float> undef, <5 x float> undef) #1
  %v8f32 = call <8 x float> @llvm.fma.v8f32(<8 x float> undef, <8 x float> undef, <8 x float> undef) #1
  %v9f32 = call <9 x float> @llvm.fma.v9f32(<9 x float> undef, <9 x float> undef, <9 x float> undef) #1
  ret void
}

define amdgpu_kernel void @fma_f64() #0 {
; SLOWF64-LABEL: 'fma_f64'
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f64 = call double @llvm.fma.f64(double undef, double undef, double undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2f64 = call <2 x double> @llvm.fma.v2f64(<2 x double> undef, <2 x double> undef, <2 x double> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v3f64 = call <3 x double> @llvm.fma.v3f64(<3 x double> undef, <3 x double> undef, <3 x double> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v4f64 = call <4 x double> @llvm.fma.v4f64(<4 x double> undef, <4 x double> undef, <4 x double> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %v5f64 = call <5 x double> @llvm.fma.v5f64(<5 x double> undef, <5 x double> undef, <5 x double> undef) #2
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; FASTF64-LABEL: 'fma_f64'
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f64 = call double @llvm.fma.f64(double undef, double undef, double undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f64 = call <2 x double> @llvm.fma.v2f64(<2 x double> undef, <2 x double> undef, <2 x double> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3f64 = call <3 x double> @llvm.fma.v3f64(<3 x double> undef, <3 x double> undef, <3 x double> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f64 = call <4 x double> @llvm.fma.v4f64(<4 x double> undef, <4 x double> undef, <4 x double> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %v5f64 = call <5 x double> @llvm.fma.v5f64(<5 x double> undef, <5 x double> undef, <5 x double> undef) #2
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; SLOW-LABEL: 'fma_f64'
; SLOW-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %f64 = call double @llvm.fma.f64(double undef, double undef, double undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v2f64 = call <2 x double> @llvm.fma.v2f64(<2 x double> undef, <2 x double> undef, <2 x double> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %v3f64 = call <3 x double> @llvm.fma.v3f64(<3 x double> undef, <3 x double> undef, <3 x double> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v4f64 = call <4 x double> @llvm.fma.v4f64(<4 x double> undef, <4 x double> undef, <4 x double> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 96 for instruction: %v5f64 = call <5 x double> @llvm.fma.v5f64(<5 x double> undef, <5 x double> undef, <5 x double> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; SLOWF64-SIZE-LABEL: 'fma_f64'
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f64 = call double @llvm.fma.f64(double undef, double undef, double undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2f64 = call <2 x double> @llvm.fma.v2f64(<2 x double> undef, <2 x double> undef, <2 x double> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v3f64 = call <3 x double> @llvm.fma.v3f64(<3 x double> undef, <3 x double> undef, <3 x double> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v4f64 = call <4 x double> @llvm.fma.v4f64(<4 x double> undef, <4 x double> undef, <4 x double> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %v5f64 = call <5 x double> @llvm.fma.v5f64(<5 x double> undef, <5 x double> undef, <5 x double> undef) #2
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; FASTF64-SIZE-LABEL: 'fma_f64'
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f64 = call double @llvm.fma.f64(double undef, double undef, double undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f64 = call <2 x double> @llvm.fma.v2f64(<2 x double> undef, <2 x double> undef, <2 x double> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3f64 = call <3 x double> @llvm.fma.v3f64(<3 x double> undef, <3 x double> undef, <3 x double> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f64 = call <4 x double> @llvm.fma.v4f64(<4 x double> undef, <4 x double> undef, <4 x double> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 24 for instruction: %v5f64 = call <5 x double> @llvm.fma.v5f64(<5 x double> undef, <5 x double> undef, <5 x double> undef) #2
; FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; SLOW-SIZE-LABEL: 'fma_f64'
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f64 = call double @llvm.fma.f64(double undef, double undef, double undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2f64 = call <2 x double> @llvm.fma.v2f64(<2 x double> undef, <2 x double> undef, <2 x double> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v3f64 = call <3 x double> @llvm.fma.v3f64(<3 x double> undef, <3 x double> undef, <3 x double> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v4f64 = call <4 x double> @llvm.fma.v4f64(<4 x double> undef, <4 x double> undef, <4 x double> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 48 for instruction: %v5f64 = call <5 x double> @llvm.fma.v5f64(<5 x double> undef, <5 x double> undef, <5 x double> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %f64 = call double @llvm.fma.f64(double undef, double undef, double undef) #1
  %v2f64 = call <2 x double> @llvm.fma.v2f64(<2 x double> undef, <2 x double> undef, <2 x double> undef) #1
  %v3f64 = call <3 x double> @llvm.fma.v3f64(<3 x double> undef, <3 x double> undef, <3 x double> undef) #1
  %v4f64 = call <4 x double> @llvm.fma.v4f64(<4 x double> undef, <4 x double> undef, <4 x double> undef) #1
  %v5f64 = call <5 x double> @llvm.fma.v5f64(<5 x double> undef, <5 x double> undef, <5 x double> undef) #1
  ret void
}

define amdgpu_kernel void @fma_f16() #0 {
; FAST-LABEL: 'fma_f16'
; FAST-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f16 = call half @llvm.fma.f16(half undef, half undef, half undef) #2
; FAST-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f16 = call <2 x half> @llvm.fma.v2f16(<2 x half> undef, <2 x half> undef, <2 x half> undef) #2
; FAST-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v3f16 = call <3 x half> @llvm.fma.v3f16(<3 x half> undef, <3 x half> undef, <3 x half> undef) #2
; FAST-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f16 = call <4 x half> @llvm.fma.v4f16(<4 x half> undef, <4 x half> undef, <4 x half> undef) #2
; FAST-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v5f16 = call <5 x half> @llvm.fma.v5f16(<5 x half> undef, <5 x half> undef, <5 x half> undef) #2
; FAST-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v16f16 = call <16 x half> @llvm.fma.v16f16(<16 x half> undef, <16 x half> undef, <16 x half> undef) #2
; FAST-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %v17f16 = call <17 x half> @llvm.fma.v17f16(<17 x half> undef, <17 x half> undef, <17 x half> undef) #2
; FAST-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; SLOW-LABEL: 'fma_f16'
; SLOW-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %f16 = call half @llvm.fma.f16(half undef, half undef, half undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v2f16 = call <2 x half> @llvm.fma.v2f16(<2 x half> undef, <2 x half> undef, <2 x half> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v3f16 = call <3 x half> @llvm.fma.v3f16(<3 x half> undef, <3 x half> undef, <3 x half> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v4f16 = call <4 x half> @llvm.fma.v4f16(<4 x half> undef, <4 x half> undef, <4 x half> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v5f16 = call <5 x half> @llvm.fma.v5f16(<5 x half> undef, <5 x half> undef, <5 x half> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %v16f16 = call <16 x half> @llvm.fma.v16f16(<16 x half> undef, <16 x half> undef, <16 x half> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 136 for instruction: %v17f16 = call <17 x half> @llvm.fma.v17f16(<17 x half> undef, <17 x half> undef, <17 x half> undef) #2
; SLOW-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; FAST-SIZE-LABEL: 'fma_f16'
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f16 = call half @llvm.fma.f16(half undef, half undef, half undef) #2
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f16 = call <2 x half> @llvm.fma.v2f16(<2 x half> undef, <2 x half> undef, <2 x half> undef) #2
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v3f16 = call <3 x half> @llvm.fma.v3f16(<3 x half> undef, <3 x half> undef, <3 x half> undef) #2
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f16 = call <4 x half> @llvm.fma.v4f16(<4 x half> undef, <4 x half> undef, <4 x half> undef) #2
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v5f16 = call <5 x half> @llvm.fma.v5f16(<5 x half> undef, <5 x half> undef, <5 x half> undef) #2
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v16f16 = call <16 x half> @llvm.fma.v16f16(<16 x half> undef, <16 x half> undef, <16 x half> undef) #2
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 64 for instruction: %v17f16 = call <17 x half> @llvm.fma.v17f16(<17 x half> undef, <17 x half> undef, <17 x half> undef) #2
; FAST-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; SLOW-SIZE-LABEL: 'fma_f16'
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f16 = call half @llvm.fma.f16(half undef, half undef, half undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2f16 = call <2 x half> @llvm.fma.v2f16(<2 x half> undef, <2 x half> undef, <2 x half> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v3f16 = call <3 x half> @llvm.fma.v3f16(<3 x half> undef, <3 x half> undef, <3 x half> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v4f16 = call <4 x half> @llvm.fma.v4f16(<4 x half> undef, <4 x half> undef, <4 x half> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %v5f16 = call <5 x half> @llvm.fma.v5f16(<5 x half> undef, <5 x half> undef, <5 x half> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %v16f16 = call <16 x half> @llvm.fma.v16f16(<16 x half> undef, <16 x half> undef, <16 x half> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 68 for instruction: %v17f16 = call <17 x half> @llvm.fma.v17f16(<17 x half> undef, <17 x half> undef, <17 x half> undef) #2
; SLOW-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %f16 = call half @llvm.fma.f16(half undef, half undef, half undef) #1
  %v2f16 = call <2 x half> @llvm.fma.v2f16(<2 x half> undef, <2 x half> undef, <2 x half> undef) #1
  %v3f16 = call <3 x half> @llvm.fma.v3f16(<3 x half> undef, <3 x half> undef, <3 x half> undef) #1
  %v4f16 = call <4 x half> @llvm.fma.v4f16(<4 x half> undef, <4 x half> undef, <4 x half> undef) #1
  %v5f16 = call <5 x half> @llvm.fma.v5f16(<5 x half> undef, <5 x half> undef, <5 x half> undef) #1
  %v16f16 = call <16 x half> @llvm.fma.v16f16(<16 x half> undef, <16 x half> undef, <16 x half> undef) #1
  %v17f16 = call <17 x half> @llvm.fma.v17f16(<17 x half> undef, <17 x half> undef, <17 x half> undef) #1
  ret void
}

declare float @llvm.fma.f32(float, float, float) #1
declare <2 x float> @llvm.fma.v2f32(<2 x float>, <2 x float>, <2 x float>) #1
declare <3 x float> @llvm.fma.v3f32(<3 x float>, <3 x float>, <3 x float>) #1
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>) #1
declare <5 x float> @llvm.fma.v5f32(<5 x float>, <5 x float>, <5 x float>) #1
declare <8 x float> @llvm.fma.v8f32(<8 x float>, <8 x float>, <8 x float>) #1
declare <9 x float> @llvm.fma.v9f32(<9 x float>, <9 x float>, <9 x float>) #1

declare double @llvm.fma.f64(double, double, double) #1
declare <2 x double> @llvm.fma.v2f64(<2 x double>, <2 x double>, <2 x double>) #1
declare <3 x double> @llvm.fma.v3f64(<3 x double>, <3 x double>, <3 x double>) #1
declare <4 x double> @llvm.fma.v4f64(<4 x double>, <4 x double>, <4 x double>) #1
declare <5 x double> @llvm.fma.v5f64(<5 x double>, <5 x double>, <5 x double>) #1

declare half @llvm.fma.f16(half, half, half) #1
declare <2 x half> @llvm.fma.v2f16(<2 x half>, <2 x half>, <2 x half>) #1
declare <3 x half> @llvm.fma.v3f16(<3 x half>, <3 x half>, <3 x half>) #1
declare <4 x half> @llvm.fma.v4f16(<4 x half>, <4 x half>, <4 x half>) #1
declare <5 x half> @llvm.fma.v5f16(<5 x half>, <5 x half>, <5 x half>) #1
declare <16 x half> @llvm.fma.v16f16(<16 x half>, <16 x half>, <16 x half>) #1
declare <17 x half> @llvm.fma.v17f16(<17 x half>, <17 x half>, <17 x half>) #1

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }
