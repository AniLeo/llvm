; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s
; rdar://6806252

define i64 @test(ptr %tmp13) nounwind {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %while.cond
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movl (%rdi), %eax
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %while.end
; CHECK-NEXT:    shrl %eax
; CHECK-NEXT:    retq
entry:
	br label %while.cond

while.cond:		; preds = %while.cond, %entry
	%tmp15 = load i32, ptr %tmp13		; <i32> [#uses=2]
	%bf.lo = lshr i32 %tmp15, 1		; <i32> [#uses=1]
	%bf.lo.cleared = and i32 %bf.lo, 2147483647		; <i32> [#uses=1]
	%conv = zext i32 %bf.lo.cleared to i64		; <i64> [#uses=1]
	%bf.lo.cleared25 = and i32 %tmp15, 1		; <i32> [#uses=1]
	%tobool = icmp ne i32 %bf.lo.cleared25, 0		; <i1> [#uses=1]
	br i1 %tobool, label %while.cond, label %while.end

while.end:		; preds = %while.cond
	ret i64 %conv
}
