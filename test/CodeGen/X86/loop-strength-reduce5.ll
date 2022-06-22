; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

@X = weak global i16 0		; <ptr> [#uses=1]
@Y = weak global i16 0		; <ptr> [#uses=1]

define void @foo(i32 %N) nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    testl %eax, %eax
; CHECK-NEXT:    jle .LBB0_3
; CHECK-NEXT:  # %bb.1: # %bb.preheader
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_2: # %bb
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movw %dx, X
; CHECK-NEXT:    movw %cx, Y
; CHECK-NEXT:    incl %edx
; CHECK-NEXT:    addl $4, %ecx
; CHECK-NEXT:    cmpl %edx, %eax
; CHECK-NEXT:    jne .LBB0_2
; CHECK-NEXT:  .LBB0_3: # %return
; CHECK-NEXT:    retl
entry:
	%tmp1019 = icmp sgt i32 %N, 0		; <i1> [#uses=1]
	br i1 %tmp1019, label %bb, label %return

bb:		; preds = %bb, %entry
	%i.014.0 = phi i32 [ 0, %entry ], [ %indvar.next, %bb ]		; <i32> [#uses=2]
	%tmp1 = trunc i32 %i.014.0 to i16		; <i16> [#uses=2]
	store volatile i16 %tmp1, ptr @X, align 2
	%tmp34 = shl i16 %tmp1, 2		; <i16> [#uses=1]
	store volatile i16 %tmp34, ptr @Y, align 2
	%indvar.next = add i32 %i.014.0, 1		; <i32> [#uses=2]
	%exitcond = icmp eq i32 %indvar.next, %N		; <i1> [#uses=1]
	br i1 %exitcond, label %return, label %bb

return:		; preds = %bb, %entry
	ret void
}
