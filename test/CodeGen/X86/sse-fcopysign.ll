; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X64

;
; Library Functions
;

define float @tst1(float %a, float %b) nounwind {
; X32-LABEL: tst1:
; X32:       # %bb.0:
; X32-NEXT:    subl $8, %esp
; X32-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32-NEXT:    movss %xmm1, {{[0-9]+}}(%esp)
; X32-NEXT:    movss %xmm0, (%esp)
; X32-NEXT:    calll copysignf
; X32-NEXT:    addl $8, %esp
; X32-NEXT:    retl
;
; X64-LABEL: tst1:
; X64:       # %bb.0:
; X64-NEXT:    movaps %xmm0, %xmm2
; X64-NEXT:    movaps %xmm1, %xmm0
; X64-NEXT:    movaps %xmm2, %xmm1
; X64-NEXT:    jmp copysignf # TAILCALL
  %tmp = tail call float @copysignf( float %b, float %a )
  ret float %tmp
}

define double @tst2(double %a, float %b, float %c) nounwind {
; X32-LABEL: tst2:
; X32:       # %bb.0:
; X32-NEXT:    subl $16, %esp
; X32-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X32-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32-NEXT:    addss {{[0-9]+}}(%esp), %xmm1
; X32-NEXT:    cvtss2sd %xmm1, %xmm1
; X32-NEXT:    movsd %xmm0, (%esp)
; X32-NEXT:    movsd %xmm1, {{[0-9]+}}(%esp)
; X32-NEXT:    calll copysign
; X32-NEXT:    addl $16, %esp
; X32-NEXT:    retl
;
; X64-LABEL: tst2:
; X64:       # %bb.0:
; X64-NEXT:    addss %xmm2, %xmm1
; X64-NEXT:    cvtss2sd %xmm1, %xmm1
; X64-NEXT:    jmp copysign # TAILCALL
  %tmp1 = fadd float %b, %c
  %tmp2 = fpext float %tmp1 to double
  %tmp = tail call double @copysign( double %a, double %tmp2 )
  ret double %tmp
}

declare dso_local float @copysignf(float, float)
declare dso_local double @copysign(double, double)

;
; LLVM Intrinsic
;

define float @int1(float %a, float %b) nounwind {
; X32-LABEL: int1:
; X32:       # %bb.0:
; X32-NEXT:    pushl %eax
; X32-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-NEXT:    andps {{\.LCPI[0-9]+_[0-9]+}}, %xmm0
; X32-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32-NEXT:    andps {{\.LCPI[0-9]+_[0-9]+}}, %xmm1
; X32-NEXT:    orps %xmm0, %xmm1
; X32-NEXT:    movss %xmm1, (%esp)
; X32-NEXT:    flds (%esp)
; X32-NEXT:    popl %eax
; X32-NEXT:    retl
;
; X64-LABEL: int1:
; X64:       # %bb.0:
; X64-NEXT:    andps {{.*}}(%rip), %xmm0
; X64-NEXT:    andps {{.*}}(%rip), %xmm1
; X64-NEXT:    orps %xmm1, %xmm0
; X64-NEXT:    retq
  %tmp = tail call float @llvm.copysign.f32( float %b, float %a )
  ret float %tmp
}

define double @int2(double %a, float %b, float %c) nounwind {
; X32-LABEL: int2:
; X32:       # %bb.0:
; X32-NEXT:    pushl %ebp
; X32-NEXT:    movl %esp, %ebp
; X32-NEXT:    andl $-8, %esp
; X32-NEXT:    subl $8, %esp
; X32-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-NEXT:    addss 20(%ebp), %xmm0
; X32-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; X32-NEXT:    andps {{\.LCPI[0-9]+_[0-9]+}}, %xmm1
; X32-NEXT:    cvtss2sd %xmm0, %xmm0
; X32-NEXT:    andps {{\.LCPI[0-9]+_[0-9]+}}, %xmm0
; X32-NEXT:    orps %xmm1, %xmm0
; X32-NEXT:    movlps %xmm0, (%esp)
; X32-NEXT:    fldl (%esp)
; X32-NEXT:    movl %ebp, %esp
; X32-NEXT:    popl %ebp
; X32-NEXT:    retl
;
; X64-LABEL: int2:
; X64:       # %bb.0:
; X64-NEXT:    addss %xmm2, %xmm1
; X64-NEXT:    cvtss2sd %xmm1, %xmm1
; X64-NEXT:    andps {{.*}}(%rip), %xmm1
; X64-NEXT:    andps {{.*}}(%rip), %xmm0
; X64-NEXT:    orps %xmm1, %xmm0
; X64-NEXT:    retq
  %tmp1 = fadd float %b, %c
  %tmp2 = fpext float %tmp1 to double
  %tmp = tail call double @llvm.copysign.f64( double %a, double %tmp2 )
  ret double %tmp
}

define float @cst1() nounwind {
; X32-LABEL: cst1:
; X32:       # %bb.0:
; X32-NEXT:    fld1
; X32-NEXT:    fchs
; X32-NEXT:    retl
;
; X64-LABEL: cst1:
; X64:       # %bb.0:
; X64-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X64-NEXT:    retq
  %tmp = tail call float @llvm.copysign.f32( float 1.0, float -2.0 )
  ret float %tmp
}

define double @cst2() nounwind {
; X32-LABEL: cst2:
; X32:       # %bb.0:
; X32-NEXT:    fldz
; X32-NEXT:    fchs
; X32-NEXT:    retl
;
; X64-LABEL: cst2:
; X64:       # %bb.0:
; X64-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X64-NEXT:    retq
  %tmp1 = fadd float -1.0, -1.0
  %tmp2 = fpext float %tmp1 to double
  %tmp = tail call double @llvm.copysign.f64( double 0.0, double %tmp2 )
  ret double %tmp
}

declare dso_local float     @llvm.copysign.f32(float  %Mag, float  %Sgn)
declare dso_local double    @llvm.copysign.f64(double %Mag, double %Sgn)
