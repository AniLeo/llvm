; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- -mattr=+sse2,-mmx | FileCheck %s

; Test that turning off mmx doesn't turn off sse

define void @test1(<2 x double>* %r, <2 x double>* %A, double %B) nounwind  {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movaps (%ecx), %xmm0
; CHECK-NEXT:    movlps {{.*#+}} xmm0 = mem[0,1],xmm0[2,3]
; CHECK-NEXT:    movaps %xmm0, (%eax)
; CHECK-NEXT:    retl
	%tmp3 = load <2 x double>, <2 x double>* %A, align 16
	%tmp7 = insertelement <2 x double> undef, double %B, i32 0
	%tmp9 = shufflevector <2 x double> %tmp3, <2 x double> %tmp7, <2 x i32> < i32 2, i32 1 >
	store <2 x double> %tmp9, <2 x double>* %r, align 16
	ret void
}
