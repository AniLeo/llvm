; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=+sse4.2 | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+sse4.2 | FileCheck %s --check-prefix=X64

; Test bit convert that requires widening in the operand.

define i32 @return_v2hi() nounwind {
; X86-LABEL: return_v2hi:
; X86:       ## %bb.0: ## %entry
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:    retl
;
; X64-LABEL: return_v2hi:
; X64:       ## %bb.0: ## %entry
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    retq
entry:
	%retval12 = bitcast <2 x i16> zeroinitializer to i32		; <i32> [#uses=1]
	ret i32 %retval12
}
