; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=armv7-apple-ios -mcpu=cortex-a8 | FileCheck %s -check-prefix=A8
; RUN: llc < %s -mtriple=armv7-apple-ios -mcpu=swift     | FileCheck %s -check-prefix=SWIFT
; rdar://8402126

@x = external global i32*		; <i32**> [#uses=1]

define void @foo(i32 %a) "frame-pointer"="all" {
; A8-LABEL: foo:
; A8:       @ %bb.0: @ %entry
; A8-NEXT:    movw r1, :lower16:(L_x$non_lazy_ptr-(LPC0_0+8))
; A8-NEXT:    movt r1, :upper16:(L_x$non_lazy_ptr-(LPC0_0+8))
; A8-NEXT:  LPC0_0:
; A8-NEXT:    ldr r1, [pc, r1]
; A8-NEXT:    ldr r1, [r1]
; A8-NEXT:    str r0, [r1]
; A8-NEXT:    bx lr
;
; SWIFT-LABEL: foo:
; SWIFT:       @ %bb.0: @ %entry
; SWIFT-NEXT:    movw r1, :lower16:(L_x$non_lazy_ptr-(LPC0_0+8))
; SWIFT-NEXT:    movt r1, :upper16:(L_x$non_lazy_ptr-(LPC0_0+8))
; SWIFT-NEXT:  LPC0_0:
; SWIFT-NEXT:    ldr r1, [pc, r1]
; SWIFT-NEXT:    ldr r1, [r1]
; SWIFT-NEXT:    str r0, [r1]
; SWIFT-NEXT:    bx lr
entry:
	%tmp = load i32*, i32** @x		; <i32*> [#uses=1]
	store i32 %a, i32* %tmp
	ret void
}

define i32 @t1(i32 %a, i32 %b) "frame-pointer"="all" {
; A8-LABEL: t1:
; A8:       @ %bb.0: @ %entry
; A8-NEXT:    cmp r0, #11
; A8-NEXT:    movlt r0, #1
; A8-NEXT:    bxlt lr
; A8-NEXT:  LBB1_1: @ %cond_true
; A8-NEXT:    push {r7, lr}
; A8-NEXT:    mov r7, sp
; A8-NEXT:    mov r0, r1
; A8-NEXT:    bl _foo
; A8-NEXT:    mov r0, #0
; A8-NEXT:    pop {r7, pc}
;
; SWIFT-LABEL: t1:
; SWIFT:       @ %bb.0: @ %entry
; SWIFT-NEXT:    cmp r0, #11
; SWIFT-NEXT:    movlt r0, #1
; SWIFT-NEXT:    bxlt lr
; SWIFT-NEXT:  LBB1_1: @ %cond_true
; SWIFT-NEXT:    push {r7, lr}
; SWIFT-NEXT:    mov r7, sp
; SWIFT-NEXT:    mov r0, r1
; SWIFT-NEXT:    bl _foo
; SWIFT-NEXT:    mov r0, #0
; SWIFT-NEXT:    pop {r7, pc}
entry:
	%tmp1 = icmp sgt i32 %a, 10		; <i1> [#uses=1]
	br i1 %tmp1, label %cond_true, label %UnifiedReturnBlock

cond_true:		; preds = %entry
	tail call void @foo( i32 %b )
	ret i32 0

UnifiedReturnBlock:		; preds = %entry
	ret i32 1
}
