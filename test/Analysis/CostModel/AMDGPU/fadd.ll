; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -cost-model -analyze -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx90a  -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=FASTF16,GFX90A-FASTF64 %s
; RUN: opt -cost-model -analyze -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx900  -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=NOPACKEDF32,FASTF16,FASTF64 %s
; RUN: opt -cost-model -analyze -mtriple=amdgcn-unknown-amdhsa -mattr=-half-rate-64-ops < %s | FileCheck -check-prefixes=NOPACKEDF32,SLOWF64 %s
; RUN: opt -cost-model -cost-kind=code-size -analyze -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx90a  -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=FASTF16-SIZE,GFX90A-FASTF64-SIZE %s
; RUN: opt -cost-model -cost-kind=code-size -analyze -mtriple=amdgcn-unknown-amdhsa -mcpu=gfx900  -mattr=+half-rate-64-ops < %s | FileCheck -check-prefixes=NOPACKEDF32-SIZE,FASTF16-SIZE %s
; RUN: opt -cost-model -cost-kind=code-size -analyze -mtriple=amdgcn-unknown-amdhsa -mattr=-half-rate-64-ops < %s | FileCheck -check-prefixes=NOPACKEDF32-SIZE,SLOWF64-SIZE %s
; END.

define amdgpu_kernel void @fadd_f32() #0 {
; GFX90A-FASTF64-LABEL: 'fadd_f32'
; GFX90A-FASTF64-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f32 = fadd float undef, undef
; GFX90A-FASTF64-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32 = fadd <2 x float> undef, undef
; GFX90A-FASTF64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v3f32 = fadd <3 x float> undef, undef
; GFX90A-FASTF64-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v5f32 = fadd <5 x float> undef, undef
; GFX90A-FASTF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; NOPACKEDF32-LABEL: 'fadd_f32'
; NOPACKEDF32-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f32 = fadd float undef, undef
; NOPACKEDF32-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f32 = fadd <2 x float> undef, undef
; NOPACKEDF32-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3f32 = fadd <3 x float> undef, undef
; NOPACKEDF32-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %v5f32 = fadd <5 x float> undef, undef
; NOPACKEDF32-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; GFX90A-FASTF64-SIZE-LABEL: 'fadd_f32'
; GFX90A-FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f32 = fadd float undef, undef
; GFX90A-FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f32 = fadd <2 x float> undef, undef
; GFX90A-FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v3f32 = fadd <3 x float> undef, undef
; GFX90A-FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v5f32 = fadd <5 x float> undef, undef
; GFX90A-FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; NOPACKEDF32-SIZE-LABEL: 'fadd_f32'
; NOPACKEDF32-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f32 = fadd float undef, undef
; NOPACKEDF32-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f32 = fadd <2 x float> undef, undef
; NOPACKEDF32-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3f32 = fadd <3 x float> undef, undef
; NOPACKEDF32-SIZE-NEXT:  Cost Model: Found an estimated cost of 5 for instruction: %v5f32 = fadd <5 x float> undef, undef
; NOPACKEDF32-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %f32 = fadd float undef, undef
  %v2f32 = fadd <2 x float> undef, undef
  %v3f32 = fadd <3 x float> undef, undef
  %v5f32 = fadd <5 x float> undef, undef
  ret void
}

define amdgpu_kernel void @fadd_f64() #0 {
; GFX90A-FASTF64-LABEL: 'fadd_f64'
; GFX90A-FASTF64-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f64 = fadd double undef, undef
; GFX90A-FASTF64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f64 = fadd <2 x double> undef, undef
; GFX90A-FASTF64-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3f64 = fadd <3 x double> undef, undef
; GFX90A-FASTF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; FASTF64-LABEL: 'fadd_f64'
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f64 = fadd double undef, undef
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2f64 = fadd <2 x double> undef, undef
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v3f64 = fadd <3 x double> undef, undef
; FASTF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; SLOWF64-LABEL: 'fadd_f64'
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %f64 = fadd double undef, undef
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %v2f64 = fadd <2 x double> undef, undef
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 12 for instruction: %v3f64 = fadd <3 x double> undef, undef
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; GFX90A-FASTF64-SIZE-LABEL: 'fadd_f64'
; GFX90A-FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f64 = fadd double undef, undef
; GFX90A-FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f64 = fadd <2 x double> undef, undef
; GFX90A-FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v3f64 = fadd <3 x double> undef, undef
; GFX90A-FASTF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; NOPACKEDF32-SIZE-LABEL: 'fadd_f64'
; NOPACKEDF32-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f64 = fadd double undef, undef
; NOPACKEDF32-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2f64 = fadd <2 x double> undef, undef
; NOPACKEDF32-SIZE-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %v3f64 = fadd <3 x double> undef, undef
; NOPACKEDF32-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %f64 = fadd double undef, undef
  %v2f64 = fadd <2 x double> undef, undef
  %v3f64 = fadd <3 x double> undef, undef
  ret void
}

define amdgpu_kernel void @fadd_f16() #0 {
; FASTF16-LABEL: 'fadd_f16'
; FASTF16-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f16 = fadd half undef, undef
; FASTF16-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f16 = fadd <2 x half> undef, undef
; FASTF16-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v3f16 = fadd <3 x half> undef, undef
; FASTF16-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v4f16 = fadd <4 x half> undef, undef
; FASTF16-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; SLOWF64-LABEL: 'fadd_f16'
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f16 = fadd half undef, undef
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f16 = fadd <2 x half> undef, undef
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v3f16 = fadd <3 x half> undef, undef
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f16 = fadd <4 x half> undef, undef
; SLOWF64-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: ret void
;
; FASTF16-SIZE-LABEL: 'fadd_f16'
; FASTF16-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f16 = fadd half undef, undef
; FASTF16-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2f16 = fadd <2 x half> undef, undef
; FASTF16-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v3f16 = fadd <3 x half> undef, undef
; FASTF16-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v4f16 = fadd <4 x half> undef, undef
; FASTF16-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; SLOWF64-SIZE-LABEL: 'fadd_f16'
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f16 = fadd half undef, undef
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2f16 = fadd <2 x half> undef, undef
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v3f16 = fadd <3 x half> undef, undef
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v4f16 = fadd <4 x half> undef, undef
; SLOWF64-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %f16 = fadd half undef, undef
  %v2f16 = fadd <2 x half> undef, undef
  %v3f16 = fadd <3 x half> undef, undef
  %v4f16 = fadd <4 x half> undef, undef
  ret void
}

attributes #0 = { nounwind }
