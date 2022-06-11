; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc --mtriple aarch64 < %s | FileCheck %s

define float @faddp_2xfloat(<2 x float> %a) {
; CHECK-LABEL: faddp_2xfloat:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x float> %a, <2 x float> undef, <2 x i32> <i32 1, i32 undef>
  %0 = fadd <2 x float> %a, %shift
  %1 = extractelement <2 x float> %0, i32 0
  ret float %1
}

define float @faddp_4xfloat(<4 x float> %a) {
; CHECK-LABEL: faddp_4xfloat:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <4 x float> %a, <4 x float> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
  %0 = fadd <4 x float> %a, %shift
  %1 = extractelement <4 x float> %0, i32 0
  ret float %1
}

define float @faddp_4xfloat_commute(<4 x float> %a) {
; CHECK-LABEL: faddp_4xfloat_commute:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <4 x float> %a, <4 x float> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
  %0 = fadd <4 x float> %shift, %a
  %1 = extractelement <4 x float> %0, i32 0
  ret float %1
}

define float @faddp_2xfloat_commute(<2 x float> %a) {
; CHECK-LABEL: faddp_2xfloat_commute:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x float> %a, <2 x float> undef, <2 x i32> <i32 1, i32 undef>
  %0 = fadd <2 x float> %shift, %a
  %1 = extractelement <2 x float> %0, i32 0
  ret float %1
}

define double @faddp_2xdouble(<2 x double> %a) {
; CHECK-LABEL: faddp_2xdouble:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp d0, v0.2d
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x double> %a, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  %0 = fadd <2 x double> %a, %shift
  %1 = extractelement <2 x double> %0, i32 0
  ret double %1
}

define double @faddp_2xdouble_commute(<2 x double> %a) {
; CHECK-LABEL: faddp_2xdouble_commute:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp d0, v0.2d
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x double> %a, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  %0 = fadd <2 x double> %shift, %a
  %1 = extractelement <2 x double> %0, i32 0
  ret double %1
}

define i64 @addp_2xi64(<2 x i64> %a) {
; CHECK-LABEL: addp_2xi64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    addp d0, v0.2d
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x i64> %a, <2 x i64> undef, <2 x i32> <i32 1, i32 undef>
  %0 = add <2 x i64> %a, %shift
  %1 = extractelement <2 x i64> %0, i32 0
  ret i64 %1
}

define i64 @addp_2xi64_commute(<2 x i64> %a) {
; CHECK-LABEL: addp_2xi64_commute:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    addp d0, v0.2d
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x i64> %a, <2 x i64> undef, <2 x i32> <i32 1, i32 undef>
  %0 = add <2 x i64> %shift, %a
  %1 = extractelement <2 x i64> %0, i32 0
  ret i64 %1
}

define float @faddp_2xfloat_strict(<2 x float> %a) #0 {
; CHECK-LABEL: faddp_2xfloat_strict:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x float> %a, <2 x float> undef, <2 x i32> <i32 1, i32 undef>
  %0 = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %a, <2 x float> %shift, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  %1 = extractelement <2 x float> %0, i32 0
  ret float %1
}

define float @faddp_4xfloat_strict(<4 x float> %a) #0 {
; CHECK-LABEL: faddp_4xfloat_strict:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <4 x float> %a, <4 x float> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
  %0 = call <4 x float> @llvm.experimental.constrained.fadd.v4f32(<4 x float> %a, <4 x float> %shift, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  %1 = extractelement <4 x float> %0, i32 0
  ret float %1
}

define float @faddp_4xfloat_commute_strict(<4 x float> %a) #0 {
; CHECK-LABEL: faddp_4xfloat_commute_strict:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <4 x float> %a, <4 x float> undef, <4 x i32> <i32 1, i32 undef, i32 undef, i32 undef>
  %0 = call <4 x float> @llvm.experimental.constrained.fadd.v4f32(<4 x float> %shift, <4 x float> %a, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  %1 = extractelement <4 x float> %0, i32 0
  ret float %1
}

define float @faddp_2xfloat_commute_strict(<2 x float> %a) #0 {
; CHECK-LABEL: faddp_2xfloat_commute_strict:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    faddp s0, v0.2s
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x float> %a, <2 x float> undef, <2 x i32> <i32 1, i32 undef>
  %0 = call <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float> %shift, <2 x float> %a, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  %1 = extractelement <2 x float> %0, i32 0
  ret float %1
}

define double @faddp_2xdouble_strict(<2 x double> %a) #0 {
; CHECK-LABEL: faddp_2xdouble_strict:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp d0, v0.2d
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x double> %a, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  %0 = call <2 x double> @llvm.experimental.constrained.fadd.v2f64(<2 x double> %a, <2 x double> %shift, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  %1 = extractelement <2 x double> %0, i32 0
  ret double %1
}

define double @faddp_2xdouble_commute_strict(<2 x double> %a) #0 {
; CHECK-LABEL: faddp_2xdouble_commute_strict:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp d0, v0.2d
; CHECK-NEXT:    ret
entry:
  %shift = shufflevector <2 x double> %a, <2 x double> undef, <2 x i32> <i32 1, i32 undef>
  %0 = call <2 x double> @llvm.experimental.constrained.fadd.v2f64(<2 x double> %shift, <2 x double> %a, metadata !"round.tonearest", metadata !"fpexcept.strict") #0
  %1 = extractelement <2 x double> %0, i32 0
  ret double %1
}


define <2 x double> @addp_v2f64(<2 x double> %a) {
; CHECK-LABEL: addp_v2f64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    fadd v0.2d, v1.2d, v0.2d
; CHECK-NEXT:    ret
entry:
  %s = shufflevector <2 x double> %a, <2 x double> poison, <2 x i32> <i32 1, i32 0>
  %b = fadd reassoc <2 x double> %s, %a
  ret <2 x double> %b
}

define <4 x double> @addp_v4f64(<4 x double> %a) {
; CHECK-LABEL: addp_v4f64:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp v1.2d, v0.2d, v1.2d
; CHECK-NEXT:    dup v0.2d, v1.d[0]
; CHECK-NEXT:    dup v1.2d, v1.d[1]
; CHECK-NEXT:    ret
entry:
  %s = shufflevector <4 x double> %a, <4 x double> poison, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  %b = fadd reassoc <4 x double> %s, %a
  ret <4 x double> %b
}

define <4 x float> @addp_v4f32(<4 x float> %a) {
; CHECK-LABEL: addp_v4f32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    rev64 v1.4s, v0.4s
; CHECK-NEXT:    fadd v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
entry:
  %s = shufflevector <4 x float> %a, <4 x float> poison, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  %b = fadd reassoc <4 x float> %s, %a
  ret <4 x float> %b
}

define <8 x float> @addp_v8f32(<8 x float> %a) {
; CHECK-LABEL: addp_v8f32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    rev64 v2.4s, v0.4s
; CHECK-NEXT:    rev64 v3.4s, v1.4s
; CHECK-NEXT:    fadd v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    fadd v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    ret
entry:
  %s = shufflevector <8 x float> %a, <8 x float> poison, <8 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6>
  %b = fadd <8 x float> %s, %a
  ret <8 x float> %b
}

define <8 x float> @addp_v8f32_slow(<8 x float> %a) {
; CHECK-LABEL: addp_v8f32_slow:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    zip1 v0.4s, v1.4s, v1.4s
; CHECK-NEXT:    zip2 v1.4s, v1.4s, v1.4s
; CHECK-NEXT:    ret
entry:
  %s = shufflevector <8 x float> %a, <8 x float> poison, <8 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6>
  %b = fadd reassoc <8 x float> %s, %a
  ret <8 x float> %b
}

define <16 x float> @addp_v16f32(<16 x float> %a) {
; CHECK-LABEL: addp_v16f32:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    faddp v3.4s, v2.4s, v3.4s
; CHECK-NEXT:    faddp v1.4s, v0.4s, v1.4s
; CHECK-NEXT:    zip1 v2.4s, v3.4s, v3.4s
; CHECK-NEXT:    zip1 v0.4s, v1.4s, v1.4s
; CHECK-NEXT:    zip2 v1.4s, v1.4s, v1.4s
; CHECK-NEXT:    zip2 v3.4s, v3.4s, v3.4s
; CHECK-NEXT:    ret
entry:
  %s = shufflevector <16 x float> %a, <16 x float> poison, <16 x i32> <i32 1, i32 0, i32 3, i32 2, i32 5, i32 4, i32 7, i32 6, i32 9, i32 8, i32 11, i32 10, i32 13, i32 12, i32 15, i32 14>
  %b = fadd reassoc <16 x float> %s, %a
  ret <16 x float> %b
}


attributes #0 = { strictfp }

declare <2 x float> @llvm.experimental.constrained.fadd.v2f32(<2 x float>, <2 x float>, metadata, metadata)
declare <4 x float> @llvm.experimental.constrained.fadd.v4f32(<4 x float>, <4 x float>, metadata, metadata)
declare <2 x double> @llvm.experimental.constrained.fadd.v2f64(<2 x double>, <2 x double>, metadata, metadata)
