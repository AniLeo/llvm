; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -analyze -cost-model < %s | FileCheck %s
; RUN: opt -analyze -cost-model -mcpu=neoverse-v1 < %s | FileCheck %s --check-prefix=CHECK-VSCALE-2
; RUN: opt -analyze -cost-model -mcpu=neoverse-n2 < %s | FileCheck %s --check-prefix=CHECK-VSCALE-1
; RUN: opt -analyze -cost-model -mcpu=cortex-a510 < %s | FileCheck %s --check-prefix=CHECK-VSCALE-1

target triple="aarch64--linux-gnu"

define void @masked_scatters(<vscale x 4 x i1> %nxv4i1mask, <vscale x 8 x i1> %nxv8i1mask, <4 x i1> %v4i1mask, <1 x i1> %v1i1mask, <vscale x 1 x i1> %nxv1i1mask) #0 {
; CHECK-LABEL: 'masked_scatters'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4i32.nxv4p0i32(<vscale x 4 x i32> undef, <vscale x 4 x i32*> undef, i32 0, <vscale x 4 x i1> %nxv4i1mask)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv8i32.nxv8p0i32(<vscale x 8 x i32> undef, <vscale x 8 x i32*> undef, i32 0, <vscale x 8 x i1> %nxv8i1mask)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: call void @llvm.masked.scatter.nxv1i64.nxv1p0i64(<vscale x 1 x i64> undef, <vscale x 1 x i64*> undef, i32 0, <vscale x 1 x i1> %nxv1i1mask)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-VSCALE-2-LABEL: 'masked_scatters'
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4i32.nxv4p0i32(<vscale x 4 x i32> undef, <vscale x 4 x i32*> undef, i32 0, <vscale x 4 x i1> %nxv4i1mask)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv8i32.nxv8p0i32(<vscale x 8 x i32> undef, <vscale x 8 x i32*> undef, i32 0, <vscale x 8 x i1> %nxv8i1mask)
; CHECK-VSCALE-2-NEXT:  Cost Model: Invalid cost for instruction: call void @llvm.masked.scatter.nxv1i64.nxv1p0i64(<vscale x 1 x i64> undef, <vscale x 1 x i64*> undef, i32 0, <vscale x 1 x i1> %nxv1i1mask)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-VSCALE-1-LABEL: 'masked_scatters'
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.nxv4i32.nxv4p0i32(<vscale x 4 x i32> undef, <vscale x 4 x i32*> undef, i32 0, <vscale x 4 x i1> %nxv4i1mask)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv8i32.nxv8p0i32(<vscale x 8 x i32> undef, <vscale x 8 x i32*> undef, i32 0, <vscale x 8 x i1> %nxv8i1mask)
; CHECK-VSCALE-1-NEXT:  Cost Model: Invalid cost for instruction: call void @llvm.masked.scatter.nxv1i64.nxv1p0i64(<vscale x 1 x i64> undef, <vscale x 1 x i64*> undef, i32 0, <vscale x 1 x i1> %nxv1i1mask)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  call void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32> undef, <vscale x 4 x i32*> undef, i32 0, <vscale x 4 x i1> %nxv4i1mask)
  call void @llvm.masked.scatter.nxv8i32(<vscale x 8 x i32> undef, <vscale x 8 x i32*> undef, i32 0, <vscale x 8 x i1> %nxv8i1mask)
  call void @llvm.masked.scatter.nxv1i64(<vscale x 1 x i64> undef, <vscale x 1 x i64*> undef, i32 0, <vscale x 1 x i1> %nxv1i1mask)
  ret void
}

define void @masked_scatters_tune_generic(<vscale x 4 x i1> %nxv4i1mask, <vscale x 8 x i1> %nxv8i1mask, <4 x i1> %v4i1mask, <1 x i1> %v1i1mask, <vscale x 1 x i1> %nxv1i1mask) #1 {
; CHECK-LABEL: 'masked_scatters_tune_generic'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4i32.nxv4p0i32(<vscale x 4 x i32> undef, <vscale x 4 x i32*> undef, i32 0, <vscale x 4 x i1> %nxv4i1mask)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv8i32.nxv8p0i32(<vscale x 8 x i32> undef, <vscale x 8 x i32*> undef, i32 0, <vscale x 8 x i1> %nxv8i1mask)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: call void @llvm.masked.scatter.nxv1i64.nxv1p0i64(<vscale x 1 x i64> undef, <vscale x 1 x i64*> undef, i32 0, <vscale x 1 x i1> %nxv1i1mask)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-VSCALE-2-LABEL: 'masked_scatters_tune_generic'
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4i32.nxv4p0i32(<vscale x 4 x i32> undef, <vscale x 4 x i32*> undef, i32 0, <vscale x 4 x i1> %nxv4i1mask)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv8i32.nxv8p0i32(<vscale x 8 x i32> undef, <vscale x 8 x i32*> undef, i32 0, <vscale x 8 x i1> %nxv8i1mask)
; CHECK-VSCALE-2-NEXT:  Cost Model: Invalid cost for instruction: call void @llvm.masked.scatter.nxv1i64.nxv1p0i64(<vscale x 1 x i64> undef, <vscale x 1 x i64*> undef, i32 0, <vscale x 1 x i1> %nxv1i1mask)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-VSCALE-1-LABEL: 'masked_scatters_tune_generic'
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4i32.nxv4p0i32(<vscale x 4 x i32> undef, <vscale x 4 x i32*> undef, i32 0, <vscale x 4 x i1> %nxv4i1mask)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv8i32.nxv8p0i32(<vscale x 8 x i32> undef, <vscale x 8 x i32*> undef, i32 0, <vscale x 8 x i1> %nxv8i1mask)
; CHECK-VSCALE-1-NEXT:  Cost Model: Invalid cost for instruction: call void @llvm.masked.scatter.nxv1i64.nxv1p0i64(<vscale x 1 x i64> undef, <vscale x 1 x i64*> undef, i32 0, <vscale x 1 x i1> %nxv1i1mask)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  call void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32> undef, <vscale x 4 x i32*> undef, i32 0, <vscale x 4 x i1> %nxv4i1mask)
  call void @llvm.masked.scatter.nxv8i32(<vscale x 8 x i32> undef, <vscale x 8 x i32*> undef, i32 0, <vscale x 8 x i1> %nxv8i1mask)
  call void @llvm.masked.scatter.nxv1i64(<vscale x 1 x i64> undef, <vscale x 1 x i64*> undef, i32 0, <vscale x 1 x i1> %nxv1i1mask)
  ret void
}

define void @masked_scatters_no_vscale_range() #2 {
; CHECK-LABEL: 'masked_scatters_no_vscale_range'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4f64.nxv4p0f64(<vscale x 4 x double> undef, <vscale x 4 x double*> undef, i32 1, <vscale x 4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.nxv2f64.nxv2p0f64(<vscale x 2 x double> undef, <vscale x 2 x double*> undef, i32 1, <vscale x 2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv8f32.nxv8p0f32(<vscale x 8 x float> undef, <vscale x 8 x float*> undef, i32 1, <vscale x 8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4f32.nxv4p0f32(<vscale x 4 x float> undef, <vscale x 4 x float*> undef, i32 1, <vscale x 4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.nxv2f32.nxv2p0f32(<vscale x 2 x float> undef, <vscale x 2 x float*> undef, i32 1, <vscale x 2 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: call void @llvm.masked.scatter.nxv16i16.nxv16p0i16(<vscale x 16 x i16> undef, <vscale x 16 x i16*> undef, i32 1, <vscale x 16 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv8i16.nxv8p0i16(<vscale x 8 x i16> undef, <vscale x 8 x i16*> undef, i32 1, <vscale x 8 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4i16.nxv4p0i16(<vscale x 4 x i16> undef, <vscale x 4 x i16*> undef, i32 1, <vscale x 4 x i1> undef)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-VSCALE-2-LABEL: 'masked_scatters_no_vscale_range'
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4f64.nxv4p0f64(<vscale x 4 x double> undef, <vscale x 4 x double*> undef, i32 1, <vscale x 4 x i1> undef)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.nxv2f64.nxv2p0f64(<vscale x 2 x double> undef, <vscale x 2 x double*> undef, i32 1, <vscale x 2 x i1> undef)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv8f32.nxv8p0f32(<vscale x 8 x float> undef, <vscale x 8 x float*> undef, i32 1, <vscale x 8 x i1> undef)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4f32.nxv4p0f32(<vscale x 4 x float> undef, <vscale x 4 x float*> undef, i32 1, <vscale x 4 x i1> undef)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.nxv2f32.nxv2p0f32(<vscale x 2 x float> undef, <vscale x 2 x float*> undef, i32 1, <vscale x 2 x i1> undef)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: call void @llvm.masked.scatter.nxv16i16.nxv16p0i16(<vscale x 16 x i16> undef, <vscale x 16 x i16*> undef, i32 1, <vscale x 16 x i1> undef)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv8i16.nxv8p0i16(<vscale x 8 x i16> undef, <vscale x 8 x i16*> undef, i32 1, <vscale x 8 x i1> undef)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv4i16.nxv4p0i16(<vscale x 4 x i16> undef, <vscale x 4 x i16*> undef, i32 1, <vscale x 4 x i1> undef)
; CHECK-VSCALE-2-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-VSCALE-1-LABEL: 'masked_scatters_no_vscale_range'
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.nxv4f64.nxv4p0f64(<vscale x 4 x double> undef, <vscale x 4 x double*> undef, i32 1, <vscale x 4 x i1> undef)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: call void @llvm.masked.scatter.nxv2f64.nxv2p0f64(<vscale x 2 x double> undef, <vscale x 2 x double*> undef, i32 1, <vscale x 2 x i1> undef)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv8f32.nxv8p0f32(<vscale x 8 x float> undef, <vscale x 8 x float*> undef, i32 1, <vscale x 8 x i1> undef)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.nxv4f32.nxv4p0f32(<vscale x 4 x float> undef, <vscale x 4 x float*> undef, i32 1, <vscale x 4 x i1> undef)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: call void @llvm.masked.scatter.nxv2f32.nxv2p0f32(<vscale x 2 x float> undef, <vscale x 2 x float*> undef, i32 1, <vscale x 2 x i1> undef)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: call void @llvm.masked.scatter.nxv16i16.nxv16p0i16(<vscale x 16 x i16> undef, <vscale x 16 x i16*> undef, i32 1, <vscale x 16 x i1> undef)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: call void @llvm.masked.scatter.nxv8i16.nxv8p0i16(<vscale x 8 x i16> undef, <vscale x 8 x i16*> undef, i32 1, <vscale x 8 x i1> undef)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: call void @llvm.masked.scatter.nxv4i16.nxv4p0i16(<vscale x 4 x i16> undef, <vscale x 4 x i16*> undef, i32 1, <vscale x 4 x i1> undef)
; CHECK-VSCALE-1-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  call void @llvm.masked.scatter.nxv4f64(<vscale x 4 x double> undef, <vscale x 4 x double*> undef, i32 1, <vscale x 4 x i1> undef)
  call void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double> undef, <vscale x 2 x double*> undef, i32 1, <vscale x 2 x i1> undef)

  call void @llvm.masked.scatter.nxv8f32(<vscale x 8 x float> undef, <vscale x 8 x float*> undef, i32 1, <vscale x 8 x i1> undef)
  call void @llvm.masked.scatter.nxv4f32(<vscale x 4 x float> undef, <vscale x 4 x float*> undef, i32 1, <vscale x 4 x i1> undef)
  call void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float> undef, <vscale x 2 x float*> undef, i32 1, <vscale x 2 x i1> undef)

  call void @llvm.masked.scatter.nxv16i16(<vscale x 16 x i16> undef, <vscale x 16 x i16*> undef, i32 1, <vscale x 16 x i1> undef)
  call void @llvm.masked.scatter.nxv8i16(<vscale x 8 x i16> undef, <vscale x 8 x i16*> undef, i32 1, <vscale x 8 x i1> undef)
  call void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16> undef, <vscale x 4 x i16*> undef, i32 1, <vscale x 4 x i1> undef)

  ret void
}

attributes #0 = { "target-features"="+sve" vscale_range(0, 8) }
attributes #1 = { "target-features"="+sve" vscale_range(0, 16) "tune-cpu"="generic" }
attributes #2 = { "target-features"="+sve" }

declare void @llvm.masked.scatter.nxv4i32(<vscale x 4 x i32>, <vscale x 4 x i32*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv8i32(<vscale x 8 x i32>, <vscale x 8 x i32*>, i32, <vscale x 8 x i1>)
declare void @llvm.masked.scatter.nxv1i64(<vscale x 1 x i64>, <vscale x 1 x i64*>, i32, <vscale x 1 x i1>)
declare void @llvm.masked.scatter.nxv4f64(<vscale x 4 x double>, <vscale x 4 x double*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv2f64(<vscale x 2 x double>, <vscale x 2 x double*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv8f32(<vscale x 8 x float>, <vscale x 8 x float*>, i32, <vscale x 8 x i1>)
declare void @llvm.masked.scatter.nxv4f32(<vscale x 4 x float>, <vscale x 4 x float*>, i32, <vscale x 4 x i1>)
declare void @llvm.masked.scatter.nxv2f32(<vscale x 2 x float>, <vscale x 2 x float*>, i32, <vscale x 2 x i1>)
declare void @llvm.masked.scatter.nxv16i16(<vscale x 16 x i16>, <vscale x 16 x i16*>, i32, <vscale x 16 x i1>)
declare void @llvm.masked.scatter.nxv8i16(<vscale x 8 x i16>, <vscale x 8 x i16*>, i32, <vscale x 8 x i1>)
declare void @llvm.masked.scatter.nxv4i16(<vscale x 4 x i16>, <vscale x 4 x i16*>, i32, <vscale x 4 x i1>)
