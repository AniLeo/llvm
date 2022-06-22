; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -passes='print<cost-model>' 2>&1 -disable-output -S -mtriple=riscv64 -mattr=+v | FileCheck %s

define void @unsupported_fp_ops(<vscale x 4 x float> %vec, i32 %extraarg) {
; CHECK-LABEL: 'unsupported_fp_ops'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %sin = call <vscale x 4 x float> @llvm.sin.nxv4f32(<vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %cos = call <vscale x 4 x float> @llvm.cos.nxv4f32(<vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %pow = call <vscale x 4 x float> @llvm.pow.nxv4f32(<vscale x 4 x float> %vec, <vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %powi = call <vscale x 4 x float> @llvm.powi.nxv4f32.i32(<vscale x 4 x float> %vec, i32 %extraarg)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %exp = call <vscale x 4 x float> @llvm.exp.nxv4f32(<vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %exp2 = call <vscale x 4 x float> @llvm.exp2.nxv4f32(<vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %log = call <vscale x 4 x float> @llvm.log.nxv4f32(<vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %log2 = call <vscale x 4 x float> @llvm.log2.nxv4f32(<vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %log10 = call <vscale x 4 x float> @llvm.log10.nxv4f32(<vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %rint = call <vscale x 4 x float> @llvm.rint.nxv4f32(<vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %nearbyint = call <vscale x 4 x float> @llvm.nearbyint.nxv4f32(<vscale x 4 x float> %vec)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;

  %sin = call <vscale x 4 x float> @llvm.sin.nxv4f32(<vscale x 4 x float> %vec)
  %cos = call <vscale x 4 x float> @llvm.cos.nxv4f32(<vscale x 4 x float> %vec)
  %pow = call <vscale x 4 x float> @llvm.pow.nxv4f32(<vscale x 4 x float> %vec, <vscale x 4 x float> %vec)
  %powi = call <vscale x 4 x float> @llvm.powi.nxv4f32.i32(<vscale x 4 x float> %vec, i32 %extraarg)
  %exp = call <vscale x 4 x float> @llvm.exp.nxv4f32(<vscale x 4 x float> %vec)
  %exp2 = call <vscale x 4 x float> @llvm.exp2.nxv4f32(<vscale x 4 x float> %vec)
  %log = call <vscale x 4 x float> @llvm.log.nxv4f32(<vscale x 4 x float> %vec)
  %log2 = call <vscale x 4 x float> @llvm.log2.nxv4f32(<vscale x 4 x float> %vec)
  %log10 = call <vscale x 4 x float> @llvm.log10.nxv4f32(<vscale x 4 x float> %vec)
  %rint = call <vscale x 4 x float> @llvm.rint.nxv4f32(<vscale x 4 x float> %vec)
  %nearbyint = call <vscale x 4 x float> @llvm.nearbyint.nxv4f32(<vscale x 4 x float> %vec)
  ret void
}

define void @powi(<vscale x 4 x float> %vec) {
; CHECK-LABEL: 'powi'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 14 for instruction: %powi = call <vscale x 4 x float> @llvm.powi.nxv4f32.i32(<vscale x 4 x float> %vec, i32 42)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %powi = call <vscale x 4 x float> @llvm.powi.nxv4f32.i32(<vscale x 4 x float> %vec, i32 42)
  ret void
}

define void @fshr(<vscale x 1 x i32> %a, <vscale x 1 x i32> %b, <vscale x 1 x i32> %c) {
; CHECK-LABEL: 'fshr'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %1 = call <vscale x 1 x i32> @llvm.fshr.nxv1i32(<vscale x 1 x i32> %a, <vscale x 1 x i32> %b, <vscale x 1 x i32> %c)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  call <vscale x 1 x i32> @llvm.fshr.nxv4i32(<vscale x 1 x i32> %a, <vscale x 1 x i32> %b, <vscale x 1 x i32> %c)
  ret void
}

define void @fshl(<vscale x 1 x i32> %a, <vscale x 1 x i32> %b, <vscale x 1 x i32> %c) {
; CHECK-LABEL: 'fshl'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 7 for instruction: %1 = call <vscale x 1 x i32> @llvm.fshl.nxv1i32(<vscale x 1 x i32> %a, <vscale x 1 x i32> %b, <vscale x 1 x i32> %c)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  call <vscale x 1 x i32> @llvm.fshl.nxv4i32(<vscale x 1 x i32> %a, <vscale x 1 x i32> %b, <vscale x 1 x i32> %c)
  ret void
}

declare <vscale x 1 x i32> @llvm.fshr.nxv4i32(<vscale x 1 x i32> %a, <vscale x 1 x i32> %b, <vscale x 1 x i32> %c)
declare <vscale x 1 x i32> @llvm.fshl.nxv4i32(<vscale x 1 x i32> %a, <vscale x 1 x i32> %b, <vscale x 1 x i32> %c)


declare <vscale x 4 x float> @llvm.sin.nxv4f32(<vscale x 4 x float>)
declare <vscale x 4 x float> @llvm.cos.nxv4f32(<vscale x 4 x float>)
declare <vscale x 4 x float> @llvm.pow.nxv4f32(<vscale x 4 x float>, <vscale x 4 x float>)
declare <vscale x 4 x float> @llvm.powi.nxv4f32.i32(<vscale x 4 x float>, i32)
declare <vscale x 4 x float> @llvm.exp.nxv4f32(<vscale x 4 x float>)
declare <vscale x 4 x float> @llvm.exp2.nxv4f32(<vscale x 4 x float>)
declare <vscale x 4 x float> @llvm.log.nxv4f32(<vscale x 4 x float>)
declare <vscale x 4 x float> @llvm.log2.nxv4f32(<vscale x 4 x float>)
declare <vscale x 4 x float> @llvm.log10.nxv4f32(<vscale x 4 x float>)
declare <vscale x 4 x float> @llvm.rint.nxv4f32(<vscale x 4 x float>)
declare <vscale x 4 x float> @llvm.nearbyint.nxv4f32(<vscale x 4 x float>)
