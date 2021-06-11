; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=+sse2 | FileCheck %s --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-- -mattr=+avx  | FileCheck %s --check-prefix=AVX

define <4 x float> @fadd_op1_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fadd_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    addss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fadd <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @load_fadd_op1_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fadd_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    addss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fadd_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vaddss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fadd <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @fsub_op0_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fsub_op0_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    subss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_op0_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vsubss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fsub <4 x float> <float 42.0, float undef, float undef, float undef>, %v
  ret <4 x float> %b
}

define <4 x float> @load_fsub_op0_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fsub_op0_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    subss (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fsub_op0_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vsubss (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fsub <4 x float> <float 42.0, float undef, float undef, float undef>, %v
  ret <4 x float> %b
}

define <4 x float> @fmul_op1_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fmul_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    mulss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fmul <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @load_fmul_op1_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fmul_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    mulss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fmul_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vmulss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fmul <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @fdiv_op1_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fdiv_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    divss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vdivss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fdiv <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @load_fdiv_op1_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fdiv_op1_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    divss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op1_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fdiv <4 x float> %v, <float 42.0, float undef, float undef, float undef>
  ret <4 x float> %b
}

define <4 x float> @fdiv_op0_constant_v4f32(float %x) nounwind {
; SSE-LABEL: fdiv_op0_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    divss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op0_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fdiv <4 x float> <float 42.0, float undef, float undef, float undef>, %v
  ret <4 x float> %b
}

define <4 x float> @load_fdiv_op0_constant_v4f32(float* %p) nounwind {
; SSE-LABEL: load_fdiv_op0_constant_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    divss (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op0_constant_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivss (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load float, float* %p
  %v = insertelement <4 x float> undef, float %x, i32 0
  %b = fdiv <4 x float> <float 42.0, float undef, float undef, float undef>, %v
  ret <4 x float> %b
}

define <4 x double> @fadd_op1_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fadd_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fadd <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @load_fadd_op1_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fadd_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    addsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fadd_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vaddsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fadd <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @fsub_op0_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fsub_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    subsd %xmm0, %xmm1
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubsd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fsub <4 x double> <double 42.0, double undef, double undef, double undef>, %v
  ret <4 x double> %b
}

define <4 x double> @load_fsub_op0_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fsub_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    subsd (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fsub_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vsubsd (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fsub <4 x double> <double 42.0, double undef, double undef, double undef>, %v
  ret <4 x double> %b
}

define <4 x double> @fmul_op1_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fmul_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    mulsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fmul <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @load_fmul_op1_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fmul_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    mulsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fmul_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vmulsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fmul <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @fdiv_op1_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fdiv_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    divsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vdivsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @load_fdiv_op1_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fdiv_op1_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    divsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op1_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vdivsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> %v, <double 42.0, double undef, double undef, double undef>
  ret <4 x double> %b
}

define <4 x double> @fdiv_op0_constant_v4f64(double %x) nounwind {
; SSE-LABEL: fdiv_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    divsd %xmm0, %xmm1
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vdivsd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> <double 42.0, double undef, double undef, double undef>, %v
  ret <4 x double> %b
}

define <4 x double> @load_fdiv_op0_constant_v4f64(double* %p) nounwind {
; SSE-LABEL: load_fdiv_op0_constant_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    divsd (%rdi), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: load_fdiv_op0_constant_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    vdivsd (%rdi), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x = load double, double* %p
  %v = insertelement <4 x double> undef, double %x, i32 0
  %b = fdiv <4 x double> <double 42.0, double undef, double undef, double undef>, %v
  ret <4 x double> %b
}

define <2 x double> @fadd_splat_splat_v2f64(<2 x double> %vx, <2 x double> %vy) {
; SSE-LABEL: fadd_splat_splat_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addsd %xmm1, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_splat_splat_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    retq
  %splatx = shufflevector <2 x double> %vx, <2 x double> undef, <2 x i32> zeroinitializer
  %splaty = shufflevector <2 x double> %vy, <2 x double> undef, <2 x i32> zeroinitializer
  %r = fadd <2 x double> %splatx, %splaty
  ret <2 x double> %r
}

define <4 x double> @fsub_splat_splat_v4f64(double %x, double %y) {
; SSE-LABEL: fsub_splat_splat_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    subsd %xmm1, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    movapd %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_splat_splat_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double %x, i32 0
  %vy = insertelement <4 x double> undef, double %y, i32 0
  %splatx = shufflevector <4 x double> %vx, <4 x double> undef, <4 x i32> zeroinitializer
  %splaty = shufflevector <4 x double> %vy, <4 x double> undef, <4 x i32> zeroinitializer
  %r = fsub <4 x double> %splatx, %splaty
  ret <4 x double> %r
}

define <4 x float> @fmul_splat_splat_v4f32(<4 x float> %vx, <4 x float> %vy) {
; SSE-LABEL: fmul_splat_splat_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    mulss %xmm1, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_splat_splat_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    retq
  %splatx = shufflevector <4 x float> %vx, <4 x float> undef, <4 x i32> zeroinitializer
  %splaty = shufflevector <4 x float> %vy, <4 x float> undef, <4 x i32> zeroinitializer
  %r = fmul fast <4 x float> %splatx, %splaty
  ret <4 x float> %r
}

define <8 x float> @fdiv_splat_splat_v8f32(<8 x float> %vx, <8 x float> %vy) {
; SSE-LABEL: fdiv_splat_splat_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    divss %xmm2, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_splat_splat_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vdivss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %splatx = shufflevector <8 x float> %vx, <8 x float> undef, <8 x i32> zeroinitializer
  %splaty = shufflevector <8 x float> %vy, <8 x float> undef, <8 x i32> zeroinitializer
  %r = fdiv fast <8 x float> %splatx, %splaty
  ret <8 x float> %r
}

; Negative test - splat of non-zero indexes (still sink the splat).

define <2 x double> @fadd_splat_splat_nonzero_v2f64(<2 x double> %vx, <2 x double> %vy) {
; SSE-LABEL: fadd_splat_splat_nonzero_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1,1]
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_splat_splat_nonzero_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilpd {{.*#+}} xmm0 = xmm0[1,1]
; AVX-NEXT:    retq
  %splatx = shufflevector <2 x double> %vx, <2 x double> undef, <2 x i32> <i32 1, i32 1>
  %splaty = shufflevector <2 x double> %vy, <2 x double> undef, <2 x i32> <i32 1, i32 1>
  %r = fadd <2 x double> %splatx, %splaty
  ret <2 x double> %r
}

; Negative test - splat of non-zero index and mismatched indexes.

define <2 x double> @fadd_splat_splat_mismatch_v2f64(<2 x double> %vx, <2 x double> %vy) {
; SSE-LABEL: fadd_splat_splat_mismatch_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    unpckhpd {{.*#+}} xmm1 = xmm1[1,1]
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_splat_splat_mismatch_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vpermilpd {{.*#+}} xmm1 = xmm1[1,1]
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %splatx = shufflevector <2 x double> %vx, <2 x double> undef, <2 x i32> <i32 0, i32 0>
  %splaty = shufflevector <2 x double> %vy, <2 x double> undef, <2 x i32> <i32 1, i32 1>
  %r = fadd <2 x double> %splatx, %splaty
  ret <2 x double> %r
}

; Negative test - non-splat.

define <2 x double> @fadd_splat_nonsplat_v2f64(<2 x double> %vx, <2 x double> %vy) {
; SSE-LABEL: fadd_splat_nonsplat_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    addpd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_splat_nonsplat_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %splatx = shufflevector <2 x double> %vx, <2 x double> undef, <2 x i32> <i32 0, i32 0>
  %splaty = shufflevector <2 x double> %vy, <2 x double> undef, <2 x i32> <i32 0, i32 1>
  %r = fadd <2 x double> %splatx, %splaty
  ret <2 x double> %r
}

; Negative test - non-FP.

define <2 x i64> @add_splat_splat_v2i64(<2 x i64> %vx, <2 x i64> %vy) {
; SSE-LABEL: add_splat_splat_v2i64:
; SSE:       # %bb.0:
; SSE-NEXT:    paddq %xmm1, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,1,0,1]
; SSE-NEXT:    retq
;
; AVX-LABEL: add_splat_splat_v2i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,1,0,1]
; AVX-NEXT:    retq
  %splatx = shufflevector <2 x i64> %vx, <2 x i64> undef, <2 x i32> <i32 0, i32 0>
  %splaty = shufflevector <2 x i64> %vy, <2 x i64> undef, <2 x i32> <i32 0, i32 0>
  %r = add <2 x i64> %splatx, %splaty
  ret <2 x i64> %r
}

define <2 x double> @fadd_splat_const_op1_v2f64(<2 x double> %vx) {
; SSE-LABEL: fadd_splat_const_op1_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: fadd_splat_const_op1_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    retq
  %splatx = shufflevector <2 x double> %vx, <2 x double> undef, <2 x i32> zeroinitializer
  %r = fadd <2 x double> %splatx, <double 42.0, double 42.0>
  ret <2 x double> %r
}

define <4 x double> @fsub_const_op0_splat_v4f64(double %x) {
; SSE-LABEL: fsub_const_op0_splat_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    subsd %xmm0, %xmm1
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0,0]
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fsub_const_op0_splat_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubsd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double 8.0, i32 0
  %vy = insertelement <4 x double> undef, double %x, i32 0
  %splatx = shufflevector <4 x double> %vx, <4 x double> undef, <4 x i32> zeroinitializer
  %splaty = shufflevector <4 x double> %vy, <4 x double> undef, <4 x i32> zeroinitializer
  %r = fsub <4 x double> %splatx, %splaty
  ret <4 x double> %r
}

define <4 x float> @fmul_splat_const_op1_v4f32(<4 x float> %vx, <4 x float> %vy) {
; SSE-LABEL: fmul_splat_const_op1_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    mulss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: fmul_splat_const_op1_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    retq
  %splatx = shufflevector <4 x float> %vx, <4 x float> undef, <4 x i32> zeroinitializer
  %r = fmul fast <4 x float> %splatx, <float 17.0, float 17.0, float 17.0, float 17.0>
  ret <4 x float> %r
}

define <8 x float> @fdiv_splat_const_op0_v8f32(<8 x float> %vy) {
; SSE-LABEL: fdiv_splat_const_op0_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    divss %xmm0, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_splat_const_op0_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %splatx = shufflevector <8 x float> <float 4.5, float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0>, <8 x float> undef, <8 x i32> zeroinitializer
  %splaty = shufflevector <8 x float> %vy, <8 x float> undef, <8 x i32> zeroinitializer
  %r = fdiv fast <8 x float> %splatx, %splaty
  ret <8 x float> %r
}

define <8 x float> @fdiv_const_op1_splat_v8f32(<8 x float> %vx) {
; SSE-LABEL: fdiv_const_op1_splat_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    divss %xmm1, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: fdiv_const_op1_splat_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vdivss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %splatx = shufflevector <8 x float> %vx, <8 x float> undef, <8 x i32> zeroinitializer
  %splaty = shufflevector <8 x float> <float 0.0, float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0>, <8 x float> undef, <8 x i32> zeroinitializer
  %r = fdiv fast <8 x float> %splatx, %splaty
  ret <8 x float> %r
}

define <2 x double> @splat0_fadd_v2f64(<2 x double> %vx, <2 x double> %vy) {
; SSE-LABEL: splat0_fadd_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addsd %xmm1, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fadd_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    retq
  %b = fadd <2 x double> %vx, %vy
  %r = shufflevector <2 x double> %b, <2 x double> undef, <2 x i32> zeroinitializer
  ret <2 x double> %r
}

define <4 x double> @splat0_fsub_v4f64(double %x, double %y) {
; SSE-LABEL: splat0_fsub_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    subsd %xmm1, %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    movapd %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fsub_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double %x, i32 0
  %vy = insertelement <4 x double> undef, double %y, i32 0
  %b = fsub <4 x double> %vx, %vy
  %r = shufflevector <4 x double> %b, <4 x double> undef, <4 x i32> zeroinitializer
  ret <4 x double> %r
}

define <4 x float> @splat0_fmul_v4f32(<4 x float> %vx, <4 x float> %vy) {
; SSE-LABEL: splat0_fmul_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    mulss %xmm1, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fmul_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    retq
  %b = fmul fast <4 x float> %vx, %vy
  %r = shufflevector <4 x float> %b, <4 x float> undef, <4 x i32> zeroinitializer
  ret <4 x float> %r
}

define <8 x float> @splat0_fdiv_v8f32(<8 x float> %vx, <8 x float> %vy) {
; SSE-LABEL: splat0_fdiv_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    divss %xmm2, %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fdiv_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vdivss %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %b = fdiv fast <8 x float> %vx, %vy
  %r = shufflevector <8 x float> %b, <8 x float> undef, <8 x i32> zeroinitializer
  ret <8 x float> %r
}

define <2 x double> @splat0_fadd_const_op1_v2f64(<2 x double> %vx) {
; SSE-LABEL: splat0_fadd_const_op1_v2f64:
; SSE:       # %bb.0:
; SSE-NEXT:    addsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    unpcklpd {{.*#+}} xmm0 = xmm0[0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fadd_const_op1_v2f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vaddsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    retq
  %b = fadd <2 x double> %vx, <double 42.0, double 12.0>
  %r = shufflevector <2 x double> %b, <2 x double> undef, <2 x i32> zeroinitializer
  ret <2 x double> %r
}

define <4 x double> @splat0_fsub_const_op0_v4f64(double %x) {
; SSE-LABEL: splat0_fsub_const_op0_v4f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    subsd %xmm0, %xmm1
; SSE-NEXT:    unpcklpd {{.*#+}} xmm1 = xmm1[0,0]
; SSE-NEXT:    movapd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fsub_const_op0_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; AVX-NEXT:    vsubsd %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %vx = insertelement <4 x double> undef, double %x, i32 0
  %b = fsub <4 x double> <double -42.0, double 42.0, double 0.0, double 1.0>, %vx
  %r = shufflevector <4 x double> %b, <4 x double> undef, <4 x i32> zeroinitializer
  ret <4 x double> %r
}

define <4 x float> @splat0_fmul_const_op1_v4f32(<4 x float> %vx) {
; SSE-LABEL: splat0_fmul_const_op1_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    mulss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fmul_const_op1_v4f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    retq
  %b = fmul fast <4 x float> %vx, <float 6.0, float -1.0, float 1.0, float 7.0>
  %r = shufflevector <4 x float> %b, <4 x float> undef, <4 x i32> zeroinitializer
  ret <4 x float> %r
}

define <8 x float> @splat0_fdiv_const_op1_v8f32(<8 x float> %vx) {
; SSE-LABEL: splat0_fdiv_const_op1_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fdiv_const_op1_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %b = fdiv fast <8 x float> %vx, <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0>
  %r = shufflevector <8 x float> %b, <8 x float> undef, <8 x i32> zeroinitializer
  ret <8 x float> %r
}

define <8 x float> @splat0_fdiv_const_op0_v8f32(<8 x float> %vx) {
; SSE-LABEL: splat0_fdiv_const_op0_v8f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    divss %xmm0, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0,0,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: splat0_fdiv_const_op0_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm0, %ymm0
; AVX-NEXT:    retq
  %b = fdiv fast <8 x float> <float 1.0, float 2.0, float 3.0, float 4.0, float 5.0, float 6.0, float 7.0, float 8.0>, %vx
  %r = shufflevector <8 x float> %b, <8 x float> undef, <8 x i32> zeroinitializer
  ret <8 x float> %r
}

define <4 x float> @multi_use_binop(<4 x float> %x, <4 x float> %y) {
; SSE-LABEL: multi_use_binop:
; SSE:       # %bb.0:
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; SSE-NEXT:    shufps {{.*#+}} xmm0 = xmm0[0,0,0,0]
; SSE-NEXT:    addps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: multi_use_binop:
; AVX:       # %bb.0:
; AVX-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX-NEXT:    vpermilps {{.*#+}} xmm1 = xmm0[0,0,0,0]
; AVX-NEXT:    vmovddup {{.*#+}} xmm0 = xmm0[0,0]
; AVX-NEXT:    vaddps %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %mul = fmul <4 x float> %x, %y
  %mul0 = shufflevector <4 x float> %mul, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 undef, i32 0>
  %mul1 = shufflevector <4 x float> %mul, <4 x float> undef, <4 x i32> <i32 undef, i32 undef, i32 undef, i32 1>
  %r = fadd <4 x float> %mul0, %mul1
  ret <4 x float> %r
}
