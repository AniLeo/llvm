; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+mmx,+sse2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+mmx,+sse2 | FileCheck %s --check-prefix=X64

define double @mmx_zero(double, double, double, double) nounwind {
; X86-LABEL: mmx_zero:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    movq 8(%ebp), %mm0
; X86-NEXT:    movq 16(%ebp), %mm5
; X86-NEXT:    movq %mm5, (%esp) # 8-byte Spill
; X86-NEXT:    movq %mm0, %mm3
; X86-NEXT:    paddd %mm5, %mm3
; X86-NEXT:    pxor %mm1, %mm1
; X86-NEXT:    movq %mm3, %mm6
; X86-NEXT:    pmuludq %mm1, %mm6
; X86-NEXT:    movq 24(%ebp), %mm4
; X86-NEXT:    movq %mm6, %mm2
; X86-NEXT:    paddd %mm4, %mm2
; X86-NEXT:    paddw %mm2, %mm0
; X86-NEXT:    movq %mm5, %mm1
; X86-NEXT:    paddw %mm0, %mm1
; X86-NEXT:    movq 32(%ebp), %mm5
; X86-NEXT:    movq %mm1, %mm7
; X86-NEXT:    pmuludq %mm5, %mm7
; X86-NEXT:    paddw %mm4, %mm7
; X86-NEXT:    paddw %mm7, %mm5
; X86-NEXT:    paddw %mm5, %mm2
; X86-NEXT:    paddw %mm2, %mm0
; X86-NEXT:    paddw %mm6, %mm0
; X86-NEXT:    pmuludq %mm3, %mm0
; X86-NEXT:    paddw {{\.LCPI.*}}, %mm0
; X86-NEXT:    paddw %mm1, %mm0
; X86-NEXT:    pmuludq %mm7, %mm0
; X86-NEXT:    pmuludq (%esp), %mm0 # 8-byte Folded Reload
; X86-NEXT:    paddw %mm5, %mm0
; X86-NEXT:    paddw %mm2, %mm0
; X86-NEXT:    movq2dq %mm0, %xmm0
; X86-NEXT:    movsd %xmm0, {{[0-9]+}}(%esp)
; X86-NEXT:    fldl {{[0-9]+}}(%esp)
; X86-NEXT:    movl %ebp, %esp
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
;
; X64-LABEL: mmx_zero:
; X64:       # %bb.0:
; X64-NEXT:    movdq2q %xmm0, %mm0
; X64-NEXT:    movdq2q %xmm1, %mm5
; X64-NEXT:    movq %mm5, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %mm0, %mm3
; X64-NEXT:    paddd %mm5, %mm3
; X64-NEXT:    pxor %mm1, %mm1
; X64-NEXT:    movq %mm3, %mm6
; X64-NEXT:    pmuludq %mm1, %mm6
; X64-NEXT:    movdq2q %xmm2, %mm4
; X64-NEXT:    movq %mm6, %mm2
; X64-NEXT:    paddd %mm4, %mm2
; X64-NEXT:    paddw %mm2, %mm0
; X64-NEXT:    movq %mm5, %mm1
; X64-NEXT:    paddw %mm0, %mm1
; X64-NEXT:    movdq2q %xmm3, %mm5
; X64-NEXT:    movq %mm1, %mm7
; X64-NEXT:    pmuludq %mm5, %mm7
; X64-NEXT:    paddw %mm4, %mm7
; X64-NEXT:    paddw %mm7, %mm5
; X64-NEXT:    paddw %mm5, %mm2
; X64-NEXT:    paddw %mm2, %mm0
; X64-NEXT:    paddw %mm6, %mm0
; X64-NEXT:    pmuludq %mm3, %mm0
; X64-NEXT:    paddw {{\.LCPI.*}}, %mm0
; X64-NEXT:    paddw %mm1, %mm0
; X64-NEXT:    pmuludq %mm7, %mm0
; X64-NEXT:    pmuludq {{[-0-9]+}}(%r{{[sb]}}p), %mm0 # 8-byte Folded Reload
; X64-NEXT:    paddw %mm5, %mm0
; X64-NEXT:    paddw %mm2, %mm0
; X64-NEXT:    movq2dq %mm0, %xmm0
; X64-NEXT:    retq
  %5 = bitcast double %0 to x86_mmx
  %6 = bitcast double %1 to x86_mmx
  %7 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %5, x86_mmx %6)
  %8 = tail call x86_mmx @llvm.x86.mmx.pmulu.dq(x86_mmx %7, x86_mmx bitcast (double 0.000000e+00 to x86_mmx))
  %9 = bitcast double %2 to x86_mmx
  %10 = tail call x86_mmx @llvm.x86.mmx.padd.d(x86_mmx %8, x86_mmx %9)
  %11 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %5, x86_mmx %10)
  %12 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %6, x86_mmx %11)
  %13 = bitcast double %3 to x86_mmx
  %14 = tail call x86_mmx @llvm.x86.mmx.pmulu.dq(x86_mmx %12, x86_mmx %13)
  %15 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %14, x86_mmx %9)
  %16 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %15, x86_mmx %13)
  %17 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %16, x86_mmx %10)
  %18 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %17, x86_mmx %11)
  %19 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %18, x86_mmx %8)
  %20 = tail call x86_mmx @llvm.x86.mmx.pmulu.dq(x86_mmx %19, x86_mmx %7)
  %21 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %20, x86_mmx bitcast (double 0.000000e+00 to x86_mmx))
  %22 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %21, x86_mmx %12)
  %23 = tail call x86_mmx @llvm.x86.mmx.pmulu.dq(x86_mmx %22, x86_mmx %15)
  %24 = tail call x86_mmx @llvm.x86.mmx.pmulu.dq(x86_mmx %23, x86_mmx %6)
  %25 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %24, x86_mmx %16)
  %26 = tail call x86_mmx @llvm.x86.mmx.padd.w(x86_mmx %25, x86_mmx %17)
  %27 = bitcast x86_mmx %26 to double
  ret double %27
}

declare x86_mmx @llvm.x86.mmx.padd.d(x86_mmx, x86_mmx)
declare x86_mmx @llvm.x86.mmx.padd.w(x86_mmx, x86_mmx)
declare x86_mmx @llvm.x86.mmx.pmulu.dq(x86_mmx, x86_mmx)
