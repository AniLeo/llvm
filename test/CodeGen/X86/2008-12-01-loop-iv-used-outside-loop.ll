; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin |  FileCheck %s
; The inner loop should use [reg] addressing, not [reg+reg] addressing.
; rdar://6403965

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"
target triple = "i386-apple-darwin9.5"

define i8* @test(i8* %Q, i32* %L) nounwind {
; CHECK-LABEL: test:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    jmp LBB0_2
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB0_1: ## %bb
; CHECK-NEXT:    ## in Loop: Header=BB0_2 Depth=1
; CHECK-NEXT:    incl %eax
; CHECK-NEXT:  LBB0_2: ## %bb1
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movzbl (%eax), %ecx
; CHECK-NEXT:    cmpl $12, %ecx
; CHECK-NEXT:    je LBB0_1
; CHECK-NEXT:  ## %bb.3: ## %bb1
; CHECK-NEXT:    ## in Loop: Header=BB0_2 Depth=1
; CHECK-NEXT:    cmpl $42, %ecx
; CHECK-NEXT:    je LBB0_1
; CHECK-NEXT:  ## %bb.4: ## %bb3
; CHECK-NEXT:    movb $4, 2(%eax)
; CHECK-NEXT:    retl
entry:
	br label %bb1

bb:		; preds = %bb1, %bb1
	%indvar.next = add i32 %P.0.rec, 1		; <i32> [#uses=1]
	br label %bb1

bb1:		; preds = %bb, %entry
	%P.0.rec = phi i32 [ 0, %entry ], [ %indvar.next, %bb ]		; <i32> [#uses=3]
	%P.0 = getelementptr i8, i8* %Q, i32 %P.0.rec		; <i8*> [#uses=2]
	%0 = load i8, i8* %P.0, align 1		; <i8> [#uses=1]
	switch i8 %0, label %bb3 [
		i8 12, label %bb
		i8 42, label %bb
	]

bb3:		; preds = %bb1
	%P.0.sum = add i32 %P.0.rec, 2		; <i32> [#uses=1]
	%1 = getelementptr i8, i8* %Q, i32 %P.0.sum		; <i8*> [#uses=1]
	store i8 4, i8* %1, align 1
	ret i8* %P.0
}
