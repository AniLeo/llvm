; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin -mcpu=corei7 | FileCheck %s
; PR3457
; rdar://6548010

define void @foo(double* nocapture %P) nounwind {
; CHECK-LABEL: foo:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    subl $24, %esp
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    calll _test
; CHECK-NEXT:    fstpl {{[0-9]+}}(%esp)
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd %xmm0, (%esp) ## 8-byte Spill
; CHECK-NEXT:    calll _test
; CHECK-NEXT:    fstpl {{[0-9]+}}(%esp)
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd (%esp), %xmm1 ## 8-byte Reload
; CHECK-NEXT:    ## xmm1 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm1
; CHECK-NEXT:    mulsd %xmm0, %xmm0
; CHECK-NEXT:    addsd %xmm1, %xmm0
; CHECK-NEXT:    movsd %xmm0, (%esi)
; CHECK-NEXT:    addl $24, %esp
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    retl
entry:
	%0 = tail call double (...) @test() nounwind		; <double> [#uses=2]
	%1 = tail call double (...) @test() nounwind		; <double> [#uses=2]
	%2 = fmul double %0, %0		; <double> [#uses=1]
	%3 = fmul double %1, %1		; <double> [#uses=1]
	%4 = fadd double %2, %3		; <double> [#uses=1]
	store double %4, double* %P, align 8
	ret void
}

declare double @test(...)
