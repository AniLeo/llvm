; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

define signext i16 @t()   {
; CHECK-LABEL: t:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movswl 0, %eax
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    retl
entry:
	%tmp180 = load i16, ptr null, align 2		; <i16> [#uses=3]
	%tmp180181 = sext i16 %tmp180 to i32		; <i32> [#uses=1]
	%tmp185 = icmp slt i16 %tmp180, 0		; <i1> [#uses=1]
	br i1 %tmp185, label %cond_true188, label %cond_next245

cond_true188:		; preds = %entry
	%tmp195196 = trunc i16 %tmp180 to i8		; <i8> [#uses=0]
	ret i16 0

cond_next245:		; preds = %entry
	%tmp256 = and i32 %tmp180181, 15		; <i32> [#uses=0]
	ret i16 0
}
