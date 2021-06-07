; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse2 | FileCheck %s --check-prefix=X64

define double @f1(double %a) {
; X86-LABEL: f1:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    mulsd {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    movsd %xmm0, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl
;
; X64-LABEL: f1:
; X64:       # %bb.0:
; X64-NEXT:    mulsd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = fadd fast double %a, %a
  %2 = fadd fast double %a, %a
  %3 = fadd fast double %1, %2
  ret double %3
}

define double @f2(double %a) {
; X86-LABEL: f2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X86-NEXT:    addsd %xmm0, %xmm0
; X86-NEXT:    movapd %xmm0, %xmm1
; X86-NEXT:    #ARITH_FENCE
; X86-NEXT:    addsd %xmm0, %xmm1
; X86-NEXT:    movsd %xmm1, (%esp)
; X86-NEXT:    fldl (%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl
;
; X64-LABEL: f2:
; X64:       # %bb.0:
; X64-NEXT:    addsd %xmm0, %xmm0
; X64-NEXT:    movapd %xmm0, %xmm1
; X64-NEXT:    #ARITH_FENCE
; X64-NEXT:    addsd %xmm0, %xmm1
; X64-NEXT:    movapd %xmm1, %xmm0
; X64-NEXT:    retq
  %1 = fadd fast double %a, %a
  %t = call double @llvm.arithmetic.fence.f64(double %1)
  %2 = fadd fast double %a, %a
  %3 = fadd fast double %t, %2
  ret double %3
}

define <2 x float> @f3(<2 x float> %a) {
; X86-LABEL: f3:
; X86:       # %bb.0:
; X86-NEXT:    mulps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: f3:
; X64:       # %bb.0:
; X64-NEXT:    mulps {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; X64-NEXT:    retq
  %1 = fadd fast <2 x float> %a, %a
  %2 = fadd fast <2 x float> %a, %a
  %3 = fadd fast <2 x float> %1, %2
  ret <2 x float> %3
}

define <2 x float> @f4(<2 x float> %a) {
; X86-LABEL: f4:
; X86:       # %bb.0:
; X86-NEXT:    addps %xmm0, %xmm0
; X86-NEXT:    movaps %xmm0, %xmm1
; X86-NEXT:    #ARITH_FENCE
; X86-NEXT:    addps %xmm0, %xmm1
; X86-NEXT:    movaps %xmm1, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: f4:
; X64:       # %bb.0:
; X64-NEXT:    addps %xmm0, %xmm0
; X64-NEXT:    movaps %xmm0, %xmm1
; X64-NEXT:    #ARITH_FENCE
; X64-NEXT:    addps %xmm0, %xmm1
; X64-NEXT:    movaps %xmm1, %xmm0
; X64-NEXT:    retq
  %1 = fadd fast <2 x float> %a, %a
  %t = call <2 x float> @llvm.arithmetic.fence.v2f32(<2 x float> %1)
  %2 = fadd fast <2 x float> %a, %a
  %3 = fadd fast <2 x float> %t, %2
  ret <2 x float> %3
}

define <8 x float> @f5(<8 x float> %a) {
; X86-LABEL: f5:
; X86:       # %bb.0:
; X86-NEXT:    movaps {{.*#+}} xmm2 = [4.0E+0,4.0E+0,4.0E+0,4.0E+0]
; X86-NEXT:    mulps %xmm2, %xmm0
; X86-NEXT:    mulps %xmm2, %xmm1
; X86-NEXT:    retl
;
; X64-LABEL: f5:
; X64:       # %bb.0:
; X64-NEXT:    movaps {{.*#+}} xmm2 = [4.0E+0,4.0E+0,4.0E+0,4.0E+0]
; X64-NEXT:    mulps %xmm2, %xmm0
; X64-NEXT:    mulps %xmm2, %xmm1
; X64-NEXT:    retq
  %1 = fadd fast <8 x float> %a, %a
  %2 = fadd fast <8 x float> %a, %a
  %3 = fadd fast <8 x float> %1, %2
  ret <8 x float> %3
}

define <8 x float> @f6(<8 x float> %a) {
; X86-LABEL: f6:
; X86:       # %bb.0:
; X86-NEXT:    addps %xmm0, %xmm0
; X86-NEXT:    addps %xmm1, %xmm1
; X86-NEXT:    movaps %xmm1, %xmm2
; X86-NEXT:    #ARITH_FENCE
; X86-NEXT:    movaps %xmm0, %xmm3
; X86-NEXT:    #ARITH_FENCE
; X86-NEXT:    addps %xmm0, %xmm3
; X86-NEXT:    addps %xmm1, %xmm2
; X86-NEXT:    movaps %xmm3, %xmm0
; X86-NEXT:    movaps %xmm2, %xmm1
; X86-NEXT:    retl
;
; X64-LABEL: f6:
; X64:       # %bb.0:
; X64-NEXT:    addps %xmm0, %xmm0
; X64-NEXT:    addps %xmm1, %xmm1
; X64-NEXT:    movaps %xmm1, %xmm2
; X64-NEXT:    #ARITH_FENCE
; X64-NEXT:    movaps %xmm0, %xmm3
; X64-NEXT:    #ARITH_FENCE
; X64-NEXT:    addps %xmm0, %xmm3
; X64-NEXT:    addps %xmm1, %xmm2
; X64-NEXT:    movaps %xmm3, %xmm0
; X64-NEXT:    movaps %xmm2, %xmm1
; X64-NEXT:    retq
  %1 = fadd fast <8 x float> %a, %a
  %t = call <8 x float> @llvm.arithmetic.fence.v8f32(<8 x float> %1)
  %2 = fadd fast <8 x float> %a, %a
  %3 = fadd fast <8 x float> %t, %2
  ret <8 x float> %3
}

declare float @llvm.arithmetic.fence.f32(float)
declare double @llvm.arithmetic.fence.f64(double)
declare <2 x float> @llvm.arithmetic.fence.v2f32(<2 x float>)
declare <8 x float> @llvm.arithmetic.fence.v8f32(<8 x float>)
