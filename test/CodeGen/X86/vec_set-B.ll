; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-unknown -mattr=+sse2 | FileCheck %s

; These should both generate something like this:
;_test3:
;	movl	$1234567, %eax
;	andl	4(%esp), %eax
;	movd	%eax, %xmm0
;	ret

define <2 x i64> @test3(i64 %arg) nounwind {
; CHECK-LABEL: test3:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl $1234567, %eax # imm = 0x12D687
; CHECK-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movd %eax, %xmm0
; CHECK-NEXT:    retl
  %A = and i64 %arg, 1234567
  %B = insertelement <2 x i64> zeroinitializer, i64 %A, i32 0
  ret <2 x i64> %B
}

define <2 x i64> @test2(i64 %arg) nounwind {
; CHECK-LABEL: test2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl $1234567, %eax # imm = 0x12D687
; CHECK-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movd %eax, %xmm0
; CHECK-NEXT:    retl
  %A = and i64 %arg, 1234567
  %B = insertelement <2 x i64> undef, i64 %A, i32 0
  ret <2 x i64> %B
}

