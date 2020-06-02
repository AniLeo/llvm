; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin9.2.2 -mattr=+sse2,-sse4.1 | FileCheck %s --check-prefix=X32
; RUN: llc < %s -mtriple=x86_64-apple-darwin9.2.2 -mattr=+sse2,-sse4.1 | FileCheck %s --check-prefix=X64

define <8 x float> @f(<8 x float> %a, i32 %b) nounwind  {
; X32-LABEL: f:
; X32:       ## %bb.0: ## %entry
; X32-NEXT:    subl $44, %esp
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    andl $7, %eax
; X32-NEXT:    movaps %xmm1, {{[0-9]+}}(%esp)
; X32-NEXT:    movaps %xmm0, (%esp)
; X32-NEXT:    movl $1084227584, (%esp,%eax,4) ## imm = 0x40A00000
; X32-NEXT:    movaps (%esp), %xmm0
; X32-NEXT:    movaps {{[0-9]+}}(%esp), %xmm1
; X32-NEXT:    addl $44, %esp
; X32-NEXT:    retl
;
; X64-LABEL: f:
; X64:       ## %bb.0: ## %entry
; X64-NEXT:    ## kill: def $edi killed $edi def $rdi
; X64-NEXT:    movaps %xmm1, -{{[0-9]+}}(%rsp)
; X64-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; X64-NEXT:    andl $7, %edi
; X64-NEXT:    movl $1084227584, -40(%rsp,%rdi,4) ## imm = 0x40A00000
; X64-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm0
; X64-NEXT:    movaps -{{[0-9]+}}(%rsp), %xmm1
; X64-NEXT:    retq
entry:
  %vecins = insertelement <8 x float> %a, float 5.000000e+00, i32 %b
  ret <8 x float> %vecins
}
