; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s

declare float @llvm.pow.f32(float, float)
declare <4 x float> @llvm.pow.v4f32(<4 x float>, <4 x float>)

declare double @llvm.pow.f64(double, double)
declare <2 x double> @llvm.pow.v2f64(<2 x double>, <2 x double>)

define float @pow_f32_one_fourth_fmf(float %x) nounwind {
; CHECK-LABEL: pow_f32_one_fourth_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rsqrtss %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm0, %xmm2
; CHECK-NEXT:    mulss %xmm1, %xmm2
; CHECK-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; CHECK-NEXT:    movaps %xmm2, %xmm4
; CHECK-NEXT:    mulss %xmm3, %xmm4
; CHECK-NEXT:    mulss %xmm1, %xmm2
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    addss %xmm1, %xmm2
; CHECK-NEXT:    mulss %xmm4, %xmm2
; CHECK-NEXT:    xorps %xmm4, %xmm4
; CHECK-NEXT:    cmpeqss %xmm4, %xmm0
; CHECK-NEXT:    andnps %xmm2, %xmm0
; CHECK-NEXT:    xorps %xmm2, %xmm2
; CHECK-NEXT:    rsqrtss %xmm0, %xmm2
; CHECK-NEXT:    movaps %xmm0, %xmm5
; CHECK-NEXT:    mulss %xmm2, %xmm5
; CHECK-NEXT:    mulss %xmm5, %xmm3
; CHECK-NEXT:    mulss %xmm2, %xmm5
; CHECK-NEXT:    addss %xmm1, %xmm5
; CHECK-NEXT:    mulss %xmm3, %xmm5
; CHECK-NEXT:    cmpeqss %xmm4, %xmm0
; CHECK-NEXT:    andnps %xmm5, %xmm0
; CHECK-NEXT:    retq
  %r = call nsz ninf afn float @llvm.pow.f32(float %x, float 2.5e-01)
  ret float %r
}

define double @pow_f64_one_fourth_fmf(double %x) nounwind {
; CHECK-LABEL: pow_f64_one_fourth_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sqrtsd %xmm0, %xmm0
; CHECK-NEXT:    sqrtsd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %r = call nsz ninf afn double @llvm.pow.f64(double %x, double 2.5e-01)
  ret double %r
}

define <4 x float> @pow_v4f32_one_fourth_fmf(<4 x float> %x) nounwind {
; CHECK-LABEL: pow_v4f32_one_fourth_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    rsqrtps %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm0, %xmm2
; CHECK-NEXT:    mulps %xmm1, %xmm2
; CHECK-NEXT:    movaps {{.*#+}} xmm3 = [-5.000000e-01,-5.000000e-01,-5.000000e-01,-5.000000e-01]
; CHECK-NEXT:    movaps %xmm2, %xmm4
; CHECK-NEXT:    mulps %xmm3, %xmm4
; CHECK-NEXT:    mulps %xmm1, %xmm2
; CHECK-NEXT:    movaps {{.*#+}} xmm1 = [-3.000000e+00,-3.000000e+00,-3.000000e+00,-3.000000e+00]
; CHECK-NEXT:    addps %xmm1, %xmm2
; CHECK-NEXT:    mulps %xmm4, %xmm2
; CHECK-NEXT:    xorps %xmm4, %xmm4
; CHECK-NEXT:    cmpneqps %xmm4, %xmm0
; CHECK-NEXT:    andps %xmm2, %xmm0
; CHECK-NEXT:    rsqrtps %xmm0, %xmm2
; CHECK-NEXT:    movaps %xmm0, %xmm5
; CHECK-NEXT:    mulps %xmm2, %xmm5
; CHECK-NEXT:    mulps %xmm5, %xmm3
; CHECK-NEXT:    mulps %xmm2, %xmm5
; CHECK-NEXT:    addps %xmm1, %xmm5
; CHECK-NEXT:    mulps %xmm3, %xmm5
; CHECK-NEXT:    cmpneqps %xmm4, %xmm0
; CHECK-NEXT:    andps %xmm5, %xmm0
; CHECK-NEXT:    retq
  %r = call fast <4 x float> @llvm.pow.v4f32(<4 x float> %x, <4 x float> <float 2.5e-1, float 2.5e-1, float 2.5e-01, float 2.5e-01>)
  ret <4 x float> %r
}

define <2 x double> @pow_v2f64_one_fourth_fmf(<2 x double> %x) nounwind {
; CHECK-LABEL: pow_v2f64_one_fourth_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    sqrtpd %xmm0, %xmm0
; CHECK-NEXT:    sqrtpd %xmm0, %xmm0
; CHECK-NEXT:    retq
  %r = call fast <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double 2.5e-1, double 2.5e-1>)
  ret <2 x double> %r
}

define float @pow_f32_one_fourth_not_enough_fmf(float %x) nounwind {
; CHECK-LABEL: pow_f32_one_fourth_not_enough_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    jmp powf # TAILCALL
  %r = call afn ninf float @llvm.pow.f32(float %x, float 2.5e-01)
  ret float %r
}

define double @pow_f64_one_fourth_not_enough_fmf(double %x) nounwind {
; CHECK-LABEL: pow_f64_one_fourth_not_enough_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    jmp pow # TAILCALL
  %r = call nsz ninf double @llvm.pow.f64(double %x, double 2.5e-01)
  ret double %r
}

define <4 x float> @pow_v4f32_one_fourth_not_enough_fmf(<4 x float> %x) nounwind {
; CHECK-LABEL: pow_v4f32_one_fourth_not_enough_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $56, %rsp
; CHECK-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[3,1,2,3]
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    callq powf
; CHECK-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    callq powf
; CHECK-NEXT:    unpcklps (%rsp), %xmm0 # 16-byte Folded Reload
; CHECK-NEXT:    # xmm0 = xmm0[0],mem[0],xmm0[1],mem[1]
; CHECK-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    callq powf
; CHECK-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm0 # 16-byte Reload
; CHECK-NEXT:    shufps {{.*#+}} xmm0 = xmm0[1,1,2,3]
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    callq powf
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    unpcklps {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1]
; CHECK-NEXT:    unpcklpd (%rsp), %xmm1 # 16-byte Folded Reload
; CHECK-NEXT:    # xmm1 = xmm1[0],mem[0]
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    addq $56, %rsp
; CHECK-NEXT:    retq
  %r = call afn nsz <4 x float> @llvm.pow.v4f32(<4 x float> %x, <4 x float> <float 2.5e-1, float 2.5e-1, float 2.5e-01, float 2.5e-01>)
  ret <4 x float> %r
}

define <2 x double> @pow_v2f64_one_fourth_not_enough_fmf(<2 x double> %x) nounwind {
; CHECK-LABEL: pow_v2f64_one_fourth_not_enough_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $40, %rsp
; CHECK-NEXT:    movaps %xmm0, (%rsp) # 16-byte Spill
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    callq pow
; CHECK-NEXT:    movaps %xmm0, {{[-0-9]+}}(%r{{[sb]}}p) # 16-byte Spill
; CHECK-NEXT:    movaps (%rsp), %xmm0 # 16-byte Reload
; CHECK-NEXT:    movhlps {{.*#+}} xmm0 = xmm0[1,1]
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    callq pow
; CHECK-NEXT:    movaps {{[-0-9]+}}(%r{{[sb]}}p), %xmm1 # 16-byte Reload
; CHECK-NEXT:    movlhps {{.*#+}} xmm1 = xmm1[0],xmm0[0]
; CHECK-NEXT:    movaps %xmm1, %xmm0
; CHECK-NEXT:    addq $40, %rsp
; CHECK-NEXT:    retq
  %r = call nsz nnan reassoc <2 x double> @llvm.pow.v2f64(<2 x double> %x, <2 x double> <double 2.5e-1, double 2.5e-1>)
  ret <2 x double> %r
}

define float @pow_f32_one_third_fmf(float %x) nounwind {
; CHECK-LABEL: pow_f32_one_third_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    jmp powf # TAILCALL
  %one = uitofp i32 1 to float
  %three = uitofp i32 3 to float
  %exp = fdiv float %one, %three
  %r = call nsz nnan ninf afn float @llvm.pow.f32(float %x, float %exp)
  ret float %r
}

define double @pow_f64_one_third_fmf(double %x) nounwind {
; CHECK-LABEL: pow_f64_one_third_fmf:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    jmp pow # TAILCALL
  %one = uitofp i32 1 to double
  %three = uitofp i32 3 to double
  %exp = fdiv double %one, %three
  %r = call nsz nnan ninf afn double @llvm.pow.f64(double %x, double %exp)
  ret double %r
}

