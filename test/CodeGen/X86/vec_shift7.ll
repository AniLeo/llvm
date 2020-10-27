; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -mtriple=x86_64-unknown -mattr=+sse2 | FileCheck %s --check-prefixes=CHECK,X64

; Verify that we don't fail when shift by zero is encountered.

define i64 @test1(<2 x i64> %a) {
; X86-LABEL: test1:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movd %xmm0, %eax
; X86-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[1,1,1,1]
; X86-NEXT:    movd %xmm0, %edx
; X86-NEXT:    retl
;
; X64-LABEL: test1:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movq %xmm0, %rax
; X64-NEXT:    retq
entry:
 %c = shl <2 x i64> %a, <i64 0, i64 2>
 %d = extractelement <2 x i64> %c, i32 0
 ret i64 %d
}
