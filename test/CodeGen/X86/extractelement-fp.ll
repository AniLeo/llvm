; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx2,fma | FileCheck %s --check-prefixes=CHECK,X64
; RUN: llc < %s -mtriple=i686-- -mattr=avx2,fma | FileCheck %s --check-prefixes=CHECK,X86

define float @fneg_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: fneg_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; X64-NEXT:    vxorps %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: fneg_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; X86-NEXT:    vxorps %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = fneg <4 x float> %x
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fneg_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: fneg_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vmovddup {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0]
; X64-NEXT:    # xmm1 = mem[0,0]
; X64-NEXT:    vxorps %xmm1, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fneg_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vmovddup {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0]
; X86-NEXT:    # xmm1 = mem[0,0]
; X86-NEXT:    vxorps %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovlps %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = fneg <4 x double> %x
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @fadd_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: fadd_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: fadd_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = fadd <4 x float> %x, %y
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fadd_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: fadd_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fadd_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = fadd <4 x double> %x, %y
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @fsub_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: fsub_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: fsub_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vsubss %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = fsub <4 x float> %x, %y
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fsub_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: fsub_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fsub_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vsubsd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = fsub <4 x double> %x, %y
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @fmul_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: fmul_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: fmul_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = fmul <4 x float> %x, %y
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fmul_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: fmul_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vmulsd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fmul_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vmulsd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = fmul <4 x double> %x, %y
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @fdiv_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: fdiv_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vdivss %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: fdiv_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vdivss %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = fdiv <4 x float> %x, %y
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fdiv_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: fdiv_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vdivsd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fdiv_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vdivsd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = fdiv <4 x double> %x, %y
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @frem_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: frem_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    jmp fmodf@PLT # TAILCALL
;
; X86-LABEL: frem_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vmovss %xmm1, {{[0-9]+}}(%esp)
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    calll fmodf
; X86-NEXT:    addl $8, %esp
; X86-NEXT:    retl
  %v = frem <4 x float> %x, %y
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @frem_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: frem_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; X64-NEXT:    # kill: def $xmm1 killed $xmm1 killed $ymm1
; X64-NEXT:    vzeroupper
; X64-NEXT:    jmp fmod@PLT # TAILCALL
;
; X86-LABEL: frem_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    vmovlhps {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; X86-NEXT:    vmovups %xmm0, (%esp)
; X86-NEXT:    vzeroupper
; X86-NEXT:    calll fmod
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    retl
  %v = frem <4 x double> %x, %y
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define i1 @fcmp_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; CHECK-LABEL: fcmp_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vucomiss %xmm1, %xmm0
; CHECK-NEXT:    seta %al
; CHECK-NEXT:    ret{{[l|q]}}
  %v = fcmp ogt <4 x float> %x, %y
  %r = extractelement <4 x i1> %v, i32 0
  ret i1 %r
}

define i1 @fcmp_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; CHECK-LABEL: fcmp_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vucomisd %xmm0, %xmm1
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    ret{{[l|q]}}
  %v = fcmp ugt <4 x double> %x, %y
  %r = extractelement <4 x i1> %v, i32 0
  ret i1 %r
}

; If we do the fcmp transform late, make sure we have the right types.
; https://bugs.chromium.org/p/oss-fuzz/issues/detail?id=13700

define void @extsetcc(<4 x float> %x) {
; X64-LABEL: extsetcc:
; X64:       # %bb.0:
; X64-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X64-NEXT:    vucomiss %xmm1, %xmm0
; X64-NEXT:    setb (%rax)
; X64-NEXT:    retq
;
; X86-LABEL: extsetcc:
; X86:       # %bb.0:
; X86-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X86-NEXT:    vucomiss %xmm1, %xmm0
; X86-NEXT:    setb (%eax)
; X86-NEXT:    retl
  %cmp = fcmp ult <4 x float> %x, zeroinitializer
  %sext = sext <4 x i1> %cmp to <4 x i32>
  %e = extractelement <4 x i1> %cmp, i1 0
  store i1 %e, i1* undef
  ret void
}

; This used to crash by creating a setcc with an i64 condition on a 32-bit target.
define <3 x double> @extvselectsetcc_crash(<2 x double> %x) {
; X64-LABEL: extvselectsetcc_crash:
; X64:       # %bb.0:
; X64-NEXT:    vcmpeqpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm1
; X64-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X64-NEXT:    vandpd %xmm2, %xmm1, %xmm1
; X64-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; X64-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,3,3]
; X64-NEXT:    retq
;
; X86-LABEL: extvselectsetcc_crash:
; X86:       # %bb.0:
; X86-NEXT:    vcmpeqpd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm1
; X86-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X86-NEXT:    vandpd %xmm2, %xmm1, %xmm1
; X86-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; X86-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,3,3]
; X86-NEXT:    retl
  %cmp = fcmp oeq <2 x double> %x, <double 5.0, double 5.0>
  %s = select <2 x i1> %cmp, <2 x double> <double 1.0, double undef>, <2 x double> <double 0.0, double undef>
  %r = shufflevector <2 x double> %s, <2 x double> %x, <3 x i32> <i32 0, i32 2, i32 3>
  ret <3 x double> %r
}

define float @select_fcmp_v4f32(<4 x float> %x, <4 x float> %y, <4 x float> %z, <4 x float> %w) nounwind {
; X64-LABEL: select_fcmp_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vcmpneq_oqss %xmm1, %xmm0, %xmm0
; X64-NEXT:    vblendvps %xmm0, %xmm2, %xmm3, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: select_fcmp_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-16, %esp
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    vmovaps 8(%ebp), %xmm3
; X86-NEXT:    vcmpneq_oqss %xmm1, %xmm0, %xmm0
; X86-NEXT:    vblendvps %xmm0, %xmm2, %xmm3, %xmm0
; X86-NEXT:    vmovss %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    flds {{[0-9]+}}(%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %c = fcmp one <4 x float> %x, %y
  %s = select <4 x i1> %c, <4 x float> %z, <4 x float> %w
  %r = extractelement <4 x float> %s, i32 0
  ret float %r
}

define double @select_fcmp_v4f64(<4 x double> %x, <4 x double> %y, <4 x double> %z, <4 x double> %w) nounwind {
; X64-LABEL: select_fcmp_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vcmpnltsd %xmm0, %xmm1, %xmm0
; X64-NEXT:    vblendvpd %xmm0, %xmm2, %xmm3, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: select_fcmp_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-32, %esp
; X86-NEXT:    subl $32, %esp
; X86-NEXT:    vcmpnltsd %xmm0, %xmm1, %xmm0
; X86-NEXT:    vmovsd {{.*#+}} xmm1 = mem[0],zero
; X86-NEXT:    vblendvpd %xmm0, %xmm2, %xmm1, %xmm0
; X86-NEXT:    vmovlpd %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    fldl {{[0-9]+}}(%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %c = fcmp ule <4 x double> %x, %y
  %s = select <4 x i1> %c, <4 x double> %z, <4 x double> %w
  %r = extractelement <4 x double> %s, i32 0
  ret double %r
}

define float @fsqrt_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: fsqrt_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: fsqrt_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.sqrt.v4f32(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fsqrt_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: fsqrt_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fsqrt_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.sqrt.v4f64(<4 x double> %x)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @fsin_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: fsin_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    jmp sinf@PLT # TAILCALL
;
; X86-LABEL: fsin_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    calll sinf
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.sin.v4f32(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fsin_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: fsin_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    jmp sin@PLT # TAILCALL
;
; X86-LABEL: fsin_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vmovlps %xmm0, (%esp)
; X86-NEXT:    vzeroupper
; X86-NEXT:    calll sin
; X86-NEXT:    addl $8, %esp
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.sin.v4f64(<4 x double> %x)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @fma_v4f32(<4 x float> %x, <4 x float> %y, <4 x float> %z) nounwind {
; X64-LABEL: fma_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vfmadd213ss {{.*#+}} xmm0 = (xmm1 * xmm0) + xmm2
; X64-NEXT:    retq
;
; X86-LABEL: fma_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vfmadd213ss {{.*#+}} xmm0 = (xmm1 * xmm0) + xmm2
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.fma.v4f32(<4 x float> %x, <4 x float> %y, <4 x float> %z)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fma_v4f64(<4 x double> %x, <4 x double> %y, <4 x double> %z) nounwind {
; X64-LABEL: fma_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vfmadd213sd {{.*#+}} xmm0 = (xmm1 * xmm0) + xmm2
; X64-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fma_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vfmadd213sd {{.*#+}} xmm1 = (xmm0 * xmm1) + xmm2
; X86-NEXT:    vmovsd %xmm1, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.fma.v4f64(<4 x double> %x, <4 x double> %y, <4 x double> %z)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @fabs_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: fabs_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastss {{.*#+}} xmm1 = [NaN,NaN,NaN,NaN]
; X64-NEXT:    vandps %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: fabs_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vbroadcastss {{.*#+}} xmm1 = [NaN,NaN,NaN,NaN]
; X86-NEXT:    vandps %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.fabs.v4f32(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fabs_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: fabs_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fabs_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    vmovlps %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.fabs.v4f64(<4 x double> %x)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @fmaxnum_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: fmaxnum_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vmaxss %xmm0, %xmm1, %xmm2
; X64-NEXT:    vcmpunordss %xmm0, %xmm0, %xmm0
; X64-NEXT:    vblendvps %xmm0, %xmm1, %xmm2, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: fmaxnum_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vmaxss %xmm0, %xmm1, %xmm2
; X86-NEXT:    vcmpunordss %xmm0, %xmm0, %xmm0
; X86-NEXT:    vblendvps %xmm0, %xmm1, %xmm2, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.maxnum.v4f32(<4 x float> %x, <4 x float> %y)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fmaxnum_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: fmaxnum_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vmaxsd %xmm0, %xmm1, %xmm2
; X64-NEXT:    vcmpunordsd %xmm0, %xmm0, %xmm0
; X64-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fmaxnum_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vmaxsd %xmm0, %xmm1, %xmm2
; X86-NEXT:    vcmpunordsd %xmm0, %xmm0, %xmm0
; X86-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; X86-NEXT:    vmovlpd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.maxnum.v4f64(<4 x double> %x, <4 x double> %y)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @fminnum_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: fminnum_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vminss %xmm0, %xmm1, %xmm2
; X64-NEXT:    vcmpunordss %xmm0, %xmm0, %xmm0
; X64-NEXT:    vblendvps %xmm0, %xmm1, %xmm2, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: fminnum_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vminss %xmm0, %xmm1, %xmm2
; X86-NEXT:    vcmpunordss %xmm0, %xmm0, %xmm0
; X86-NEXT:    vblendvps %xmm0, %xmm1, %xmm2, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.minnum.v4f32(<4 x float> %x, <4 x float> %y)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @fminnum_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: fminnum_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vminsd %xmm0, %xmm1, %xmm2
; X64-NEXT:    vcmpunordsd %xmm0, %xmm0, %xmm0
; X64-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: fminnum_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vminsd %xmm0, %xmm1, %xmm2
; X86-NEXT:    vcmpunordsd %xmm0, %xmm0, %xmm0
; X86-NEXT:    vblendvpd %xmm0, %xmm1, %xmm2, %xmm0
; X86-NEXT:    vmovlpd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.minnum.v4f64(<4 x double> %x, <4 x double> %y)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

;define float @fmaximum_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
;  %v = call <4 x float> @llvm.maximum.v4f32(<4 x float> %x, <4 x float> %y)
;  %r = extractelement <4 x float> %v, i32 0
;  ret float %r
;}

;define double @fmaximum_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
;  %v = call <4 x double> @llvm.maximum.v4f64(<4 x double> %x, <4 x double> %y)
;  %r = extractelement <4 x double> %v, i32 0
;  ret double %r
;}

;define float @fminimum_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
;  %v = call <4 x float> @llvm.minimum.v4f32(<4 x float> %x, <4 x float> %y)
;  %r = extractelement <4 x float> %v, i32 0
;  ret float %r
;}

;define double @fminimum_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
;  %v = call <4 x double> @llvm.minimum.v4f64(<4 x double> %x, <4 x double> %y)
;  %r = extractelement <4 x double> %v, i32 0
;  ret double %r
;}

define float @maxps_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: maxps_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vmaxss %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: maxps_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vmaxss %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %cmp = fcmp ogt <4 x float> %x, %y
  %v = select <4 x i1> %cmp, <4 x float> %x, <4 x float> %y
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @maxpd_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: maxpd_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vmaxsd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: maxpd_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vmaxsd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %cmp = fcmp ogt <4 x double> %x, %y
  %v = select <4 x i1> %cmp, <4 x double> %x, <4 x double> %y
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @minps_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: minps_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vminss %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: minps_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vminss %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %cmp = fcmp olt <4 x float> %x, %y
  %v = select <4 x i1> %cmp, <4 x float> %x, <4 x float> %y
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @minpd_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: minpd_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: minpd_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vminsd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %cmp = fcmp olt <4 x double> %x, %y
  %v = select <4 x i1> %cmp, <4 x double> %x, <4 x double> %y
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @copysign_v4f32(<4 x float> %x, <4 x float> %y) nounwind {
; X64-LABEL: copysign_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastss {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; X64-NEXT:    vandps %xmm2, %xmm1, %xmm1
; X64-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; X64-NEXT:    vandps %xmm2, %xmm0, %xmm0
; X64-NEXT:    vorps %xmm1, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: copysign_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vbroadcastss {{.*#+}} xmm2 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; X86-NEXT:    vandps %xmm2, %xmm1, %xmm1
; X86-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; X86-NEXT:    vandps %xmm2, %xmm0, %xmm0
; X86-NEXT:    vorps %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.copysign.v4f32(<4 x float> %x, <4 x float> %y)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @copysign_v4f64(<4 x double> %x, <4 x double> %y) nounwind {
; X64-LABEL: copysign_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm1, %xmm1
; X64-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; X64-NEXT:    vorps %xmm1, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: copysign_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1, %xmm1
; X86-NEXT:    vandps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm0
; X86-NEXT:    vorps %xmm1, %xmm0, %xmm0
; X86-NEXT:    vmovlps %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.copysign.v4f64(<4 x double> %x, <4 x double> %y)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @floor_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: floor_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vroundss $9, %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: floor_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vroundss $9, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.floor.v4f32(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @floor_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: floor_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vroundsd $9, %xmm0, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: floor_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vroundsd $9, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.floor.v4f64(<4 x double> %x)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @ceil_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: ceil_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vroundss $10, %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: ceil_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vroundss $10, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.ceil.v4f32(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @ceil_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: ceil_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vroundsd $10, %xmm0, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: ceil_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vroundsd $10, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.ceil.v4f64(<4 x double> %x)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @trunc_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: trunc_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vroundss $11, %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: trunc_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vroundss $11, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.trunc.v4f32(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @trunc_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: trunc_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vroundsd $11, %xmm0, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: trunc_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vroundsd $11, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.trunc.v4f64(<4 x double> %x)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @rint_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: rint_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vroundss $4, %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: rint_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vroundss $4, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.rint.v4f32(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @rint_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: rint_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vroundsd $4, %xmm0, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: rint_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vroundsd $4, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.rint.v4f64(<4 x double> %x)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @nearbyint_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: nearbyint_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vroundss $12, %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: nearbyint_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vroundss $12, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.nearbyint.v4f32(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @nearbyint_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: nearbyint_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vroundsd $12, %xmm0, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: nearbyint_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vroundsd $12, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.nearbyint.v4f64(<4 x double> %x)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @round_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: round_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; X64-NEXT:    vandps %xmm1, %xmm0, %xmm1
; X64-NEXT:    vbroadcastss {{.*#+}} xmm2 = [4.9999997E-1,4.9999997E-1,4.9999997E-1,4.9999997E-1]
; X64-NEXT:    vorps %xmm2, %xmm1, %xmm1
; X64-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; X64-NEXT:    vroundss $11, %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: round_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; X86-NEXT:    vandps %xmm1, %xmm0, %xmm1
; X86-NEXT:    vbroadcastss {{.*#+}} xmm2 = [4.9999997E-1,4.9999997E-1,4.9999997E-1,4.9999997E-1]
; X86-NEXT:    vorps %xmm2, %xmm1, %xmm1
; X86-NEXT:    vaddss %xmm1, %xmm0, %xmm0
; X86-NEXT:    vroundss $11, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.round.v4f32(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define double @round_v4f64(<4 x double> %x) nounwind {
; X64-LABEL: round_v4f64:
; X64:       # %bb.0:
; X64-NEXT:    vandpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm1
; X64-NEXT:    vmovddup {{.*#+}} xmm2 = [4.9999999999999994E-1,4.9999999999999994E-1]
; X64-NEXT:    # xmm2 = mem[0,0]
; X64-NEXT:    vorpd %xmm2, %xmm1, %xmm1
; X64-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; X64-NEXT:    vroundsd $11, %xmm0, %xmm0, %xmm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: round_v4f64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    vandpd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0, %xmm1
; X86-NEXT:    vmovddup {{.*#+}} xmm2 = [4.9999999999999994E-1,4.9999999999999994E-1]
; X86-NEXT:    # xmm2 = mem[0,0]
; X86-NEXT:    vorpd %xmm2, %xmm1, %xmm1
; X86-NEXT:    vaddsd %xmm1, %xmm0, %xmm0
; X86-NEXT:    vroundsd $11, %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <4 x double> @llvm.round.v4f64(<4 x double> %x)
  %r = extractelement <4 x double> %v, i32 0
  ret double %r
}

define float @rcp_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: rcp_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vrcpss %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: rcp_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vrcpss %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.x86.sse.rcp.ps(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define float @rcp_v8f32(<8 x float> %x) nounwind {
; X64-LABEL: rcp_v8f32:
; X64:       # %bb.0:
; X64-NEXT:    vrcpps %ymm0, %ymm0
; X64-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: rcp_v8f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vrcpps %ymm0, %ymm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <8 x float> @llvm.x86.avx.rcp.ps.256(<8 x float> %x)
  %r = extractelement <8 x float> %v, i32 0
  ret float %r
}

define float @rsqrt_v4f32(<4 x float> %x) nounwind {
; X64-LABEL: rsqrt_v4f32:
; X64:       # %bb.0:
; X64-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm0
; X64-NEXT:    retq
;
; X86-LABEL: rsqrt_v4f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    retl
  %v = call <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float> %x)
  %r = extractelement <4 x float> %v, i32 0
  ret float %r
}

define float @rsqrt_v8f32(<8 x float> %x) nounwind {
; X64-LABEL: rsqrt_v8f32:
; X64:       # %bb.0:
; X64-NEXT:    vrsqrtps %ymm0, %ymm0
; X64-NEXT:    # kill: def $xmm0 killed $xmm0 killed $ymm0
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
;
; X86-LABEL: rsqrt_v8f32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %eax
; X86-NEXT:    vrsqrtps %ymm0, %ymm0
; X86-NEXT:    vmovss %xmm0, (%esp)
; X86-NEXT:    flds (%esp)
; X86-NEXT:    popl %eax
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
  %v = call <8 x float> @llvm.x86.avx.rsqrt.ps.256(<8 x float> %x)
  %r = extractelement <8 x float> %v, i32 0
  ret float %r
}

declare <4 x float> @llvm.sqrt.v4f32(<4 x float>)
declare <4 x double> @llvm.sqrt.v4f64(<4 x double>)
declare <4 x float> @llvm.sin.v4f32(<4 x float>)
declare <4 x double> @llvm.sin.v4f64(<4 x double>)
declare <4 x float> @llvm.fma.v4f32(<4 x float>, <4 x float>, <4 x float>)
declare <4 x double> @llvm.fma.v4f64(<4 x double>, <4 x double>, <4 x double>)
declare <4 x float> @llvm.fabs.v4f32(<4 x float>)
declare <4 x double> @llvm.fabs.v4f64(<4 x double>)
declare <4 x float> @llvm.maxnum.v4f32(<4 x float>, <4 x float>)
declare <4 x double> @llvm.maxnum.v4f64(<4 x double>, <4 x double>)
declare <4 x float> @llvm.minnum.v4f32(<4 x float>, <4 x float>)
declare <4 x double> @llvm.minnum.v4f64(<4 x double>, <4 x double>)
declare <4 x float> @llvm.maximum.v4f32(<4 x float>, <4 x float>)
declare <4 x double> @llvm.maximum.v4f64(<4 x double>, <4 x double>)
declare <4 x float> @llvm.minimum.v4f32(<4 x float>, <4 x float>)
declare <4 x double> @llvm.minimum.v4f64(<4 x double>, <4 x double>)
declare <4 x float> @llvm.copysign.v4f32(<4 x float>, <4 x float>)
declare <4 x double> @llvm.copysign.v4f64(<4 x double>, <4 x double>)
declare <4 x float> @llvm.floor.v4f32(<4 x float>)
declare <4 x double> @llvm.floor.v4f64(<4 x double>)
declare <4 x float> @llvm.ceil.v4f32(<4 x float>)
declare <4 x double> @llvm.ceil.v4f64(<4 x double>)
declare <4 x float> @llvm.trunc.v4f32(<4 x float>)
declare <4 x double> @llvm.trunc.v4f64(<4 x double>)
declare <4 x float> @llvm.rint.v4f32(<4 x float>)
declare <4 x double> @llvm.rint.v4f64(<4 x double>)
declare <4 x float> @llvm.nearbyint.v4f32(<4 x float>)
declare <4 x double> @llvm.nearbyint.v4f64(<4 x double>)
declare <4 x float> @llvm.round.v4f32(<4 x float>)
declare <4 x double> @llvm.round.v4f64(<4 x double>)

declare <4 x float> @llvm.x86.sse.rcp.ps(<4 x float>)
declare <8 x float> @llvm.x86.avx.rcp.ps.256(<8 x float>)
declare <4 x float> @llvm.x86.sse.rsqrt.ps(<4 x float>)
declare <8 x float> @llvm.x86.avx.rsqrt.ps.256(<8 x float>)
