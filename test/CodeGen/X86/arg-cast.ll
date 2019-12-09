; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; This should compile to movl $2147483647, %eax + andl only.
; RUN: llc < %s | FileCheck %s
; rdar://5736574

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"
target triple = "i686-apple-darwin8"

define i32 @foo(double %x) nounwind  {
; CHECK-LABEL: foo:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl $2147483647, %eax ## imm = 0x7FFFFFFF
; CHECK-NEXT:    andl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    retl
entry:
	%x15 = bitcast double %x to i64		; <i64> [#uses=1]
	%tmp713 = lshr i64 %x15, 32		; <i64> [#uses=1]
	%tmp714 = trunc i64 %tmp713 to i32		; <i32> [#uses=1]
	%tmp8 = and i32 %tmp714, 2147483647		; <i32> [#uses=1]
	ret i32 %tmp8
}

