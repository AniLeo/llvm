; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=thumbv7-apple-darwin | FileCheck %s --check-prefixes=ALL,V01
; RUN: llc < %s -mtriple=thumbv7-apple-darwin -arm-default-it | FileCheck %s --check-prefixes=ALL,V01
; RUN: llc < %s -mtriple=thumbv8 -arm-no-restrict-it | FileCheck %s --check-prefixes=ALL,V23,V2
; RUN: llc < %s -mtriple=thumbv8 -arm-no-restrict-it -enable-tail-merge=0 | FileCheck %s --check-prefixes=ALL,V23,V3

define i32 @t1(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; ALL-LABEL: t1:
; ALL:       @ %bb.0:
; ALL-NEXT:    cmp r2, #7
; ALL-NEXT:    ittee ne
; ALL-NEXT:    cmpne r2, #1
; ALL-NEXT:    addne r0, r1
; ALL-NEXT:    addeq r0, r1
; ALL-NEXT:    addeq r0, #1
; ALL-NEXT:    bx lr
	switch i32 %c, label %cond_next [
		 i32 1, label %cond_true
		 i32 7, label %cond_true
	]

cond_true:
	%tmp12 = add i32 %a, 1
	%tmp1518 = add i32 %tmp12, %b
	ret i32 %tmp1518

cond_next:
	%tmp15 = add i32 %b, %a
	ret i32 %tmp15
}

define i32 @t2(i32 %a, i32 %b) nounwind {
; V01-LABEL: t2:
; V01:       @ %bb.0: @ %entry
; V01-NEXT:    cmp r0, r1
; V01-NEXT:    it eq
; V01-NEXT:    bxeq lr
; V01-NEXT:  LBB1_1: @ %bb
; V01-NEXT:    @ =>This Inner Loop Header: Depth=1
; V01-NEXT:    cmp r0, r1
; V01-NEXT:    ite gt
; V01-NEXT:    subgt r0, r0, r1
; V01-NEXT:    suble r1, r1, r0
; V01-NEXT:    cmp r1, r0
; V01-NEXT:    bne LBB1_1
; V01-NEXT:  @ %bb.2: @ %bb17
; V01-NEXT:    bx lr
;
; V2-LABEL: t2:
; V2:       @ %bb.0: @ %entry
; V2-NEXT:    cmp r0, r1
; V2-NEXT:    it eq
; V2-NEXT:    bxeq lr
; V2-NEXT:  .LBB1_1: @ %bb
; V2-NEXT:    @ =>This Inner Loop Header: Depth=1
; V2-NEXT:    cmp r0, r1
; V2-NEXT:    ite gt
; V2-NEXT:    subgt r0, r0, r1
; V2-NEXT:    suble r1, r1, r0
; V2-NEXT:    cmp r1, r0
; V2-NEXT:    bne .LBB1_1
; V2-NEXT:  @ %bb.2: @ %bb17
; V2-NEXT:    bx lr
;
; V3-LABEL: t2:
; V3:       @ %bb.0: @ %entry
; V3-NEXT:    cmp r0, r1
; V3-NEXT:    it eq
; V3-NEXT:    bxeq lr
; V3-NEXT:  .LBB1_1: @ %bb
; V3-NEXT:    @ =>This Inner Loop Header: Depth=1
; V3-NEXT:    cmp r0, r1
; V3-NEXT:    ite le
; V3-NEXT:    suble r1, r1, r0
; V3-NEXT:    subgt r0, r0, r1
; V3-NEXT:    cmp r1, r0
; V3-NEXT:    bne .LBB1_1
; V3-NEXT:  @ %bb.2: @ %bb17
; V3-NEXT:    bx lr
entry:
	%tmp1434 = icmp eq i32 %a, %b		; <i1> [#uses=1]
	br i1 %tmp1434, label %bb17, label %bb.outer

bb.outer:		; preds = %cond_false, %entry
	%b_addr.021.0.ph = phi i32 [ %b, %entry ], [ %tmp10, %cond_false ]		; <i32> [#uses=5]
	%a_addr.026.0.ph = phi i32 [ %a, %entry ], [ %a_addr.026.0, %cond_false ]		; <i32> [#uses=1]
	br label %bb

bb:		; preds = %cond_true, %bb.outer
	%indvar = phi i32 [ 0, %bb.outer ], [ %indvar.next, %cond_true ]		; <i32> [#uses=2]
	%tmp. = sub i32 0, %b_addr.021.0.ph		; <i32> [#uses=1]
	%tmp.40 = mul i32 %indvar, %tmp.		; <i32> [#uses=1]
	%a_addr.026.0 = add i32 %tmp.40, %a_addr.026.0.ph		; <i32> [#uses=6]
	%tmp3 = icmp sgt i32 %a_addr.026.0, %b_addr.021.0.ph		; <i1> [#uses=1]
	br i1 %tmp3, label %cond_true, label %cond_false

cond_true:		; preds = %bb
	%tmp7 = sub i32 %a_addr.026.0, %b_addr.021.0.ph		; <i32> [#uses=2]
	%tmp1437 = icmp eq i32 %tmp7, %b_addr.021.0.ph		; <i1> [#uses=1]
	%indvar.next = add i32 %indvar, 1		; <i32> [#uses=1]
	br i1 %tmp1437, label %bb17, label %bb

cond_false:		; preds = %bb
	%tmp10 = sub i32 %b_addr.021.0.ph, %a_addr.026.0		; <i32> [#uses=2]
	%tmp14 = icmp eq i32 %a_addr.026.0, %tmp10		; <i1> [#uses=1]
	br i1 %tmp14, label %bb17, label %bb.outer

bb17:		; preds = %cond_false, %cond_true, %entry
	%a_addr.026.1 = phi i32 [ %a, %entry ], [ %tmp7, %cond_true ], [ %a_addr.026.0, %cond_false ]		; <i32> [#uses=1]
	ret i32 %a_addr.026.1
}

define i32 @t2_nomerge(i32 %a, i32 %b) nounwind {
; V01-LABEL: t2_nomerge:
; V01:       @ %bb.0: @ %entry
; V01-NEXT:    cmp r0, r1
; V01-NEXT:    it eq
; V01-NEXT:    bxeq lr
; V01-NEXT:  LBB2_1: @ %bb
; V01-NEXT:    @ =>This Inner Loop Header: Depth=1
; V01-NEXT:    cmp r0, r1
; V01-NEXT:    ble LBB2_3
; V01-NEXT:  @ %bb.2: @ %cond_true
; V01-NEXT:    @ in Loop: Header=BB2_1 Depth=1
; V01-NEXT:    subs r0, r0, r1
; V01-NEXT:    cmp r1, r0
; V01-NEXT:    bne LBB2_1
; V01-NEXT:    b LBB2_4
; V01-NEXT:  LBB2_3: @ %cond_false
; V01-NEXT:    @ in Loop: Header=BB2_1 Depth=1
; V01-NEXT:    subs r1, r1, r0
; V01-NEXT:    cmp r0, #0
; V01-NEXT:    bne LBB2_1
; V01-NEXT:  LBB2_4: @ %bb17
; V01-NEXT:    bx lr
;
; V2-LABEL: t2_nomerge:
; V2:       @ %bb.0: @ %entry
; V2-NEXT:    cmp r0, r1
; V2-NEXT:    it eq
; V2-NEXT:    bxeq lr
; V2-NEXT:  .LBB2_1: @ %bb
; V2-NEXT:    @ =>This Inner Loop Header: Depth=1
; V2-NEXT:    cmp r0, r1
; V2-NEXT:    ble .LBB2_3
; V2-NEXT:  @ %bb.2: @ %cond_true
; V2-NEXT:    @ in Loop: Header=BB2_1 Depth=1
; V2-NEXT:    subs r0, r0, r1
; V2-NEXT:    cmp r1, r0
; V2-NEXT:    bne .LBB2_1
; V2-NEXT:    b .LBB2_4
; V2-NEXT:  .LBB2_3: @ %cond_false
; V2-NEXT:    @ in Loop: Header=BB2_1 Depth=1
; V2-NEXT:    subs r1, r1, r0
; V2-NEXT:    cmp r0, #0
; V2-NEXT:    bne .LBB2_1
; V2-NEXT:  .LBB2_4: @ %bb17
; V2-NEXT:    bx lr
;
; V3-LABEL: t2_nomerge:
; V3:       @ %bb.0: @ %entry
; V3-NEXT:    cmp r0, r1
; V3-NEXT:    beq .LBB2_4
; V3-NEXT:    b .LBB2_2
; V3-NEXT:  .LBB2_1: @ %cond_true
; V3-NEXT:    @ in Loop: Header=BB2_2 Depth=1
; V3-NEXT:    subs r0, r0, r1
; V3-NEXT:    cmp r1, r0
; V3-NEXT:    it eq
; V3-NEXT:    bxeq lr
; V3-NEXT:  .LBB2_2: @ %bb
; V3-NEXT:    @ =>This Inner Loop Header: Depth=1
; V3-NEXT:    cmp r0, r1
; V3-NEXT:    bgt .LBB2_1
; V3-NEXT:  @ %bb.3: @ %cond_false
; V3-NEXT:    @ in Loop: Header=BB2_2 Depth=1
; V3-NEXT:    subs r1, r1, r0
; V3-NEXT:    cmp r0, #0
; V3-NEXT:    bne .LBB2_2
; V3-NEXT:  .LBB2_4: @ %bb17
; V3-NEXT:    bx lr
entry:
	%tmp1434 = icmp eq i32 %a, %b		; <i1> [#uses=1]
	br i1 %tmp1434, label %bb17, label %bb.outer

bb.outer:		; preds = %cond_false, %entry
	%b_addr.021.0.ph = phi i32 [ %b, %entry ], [ %tmp10, %cond_false ]		; <i32> [#uses=5]
	%a_addr.026.0.ph = phi i32 [ %a, %entry ], [ %a_addr.026.0, %cond_false ]		; <i32> [#uses=1]
	br label %bb

bb:		; preds = %cond_true, %bb.outer
	%indvar = phi i32 [ 0, %bb.outer ], [ %indvar.next, %cond_true ]		; <i32> [#uses=2]
	%tmp. = sub i32 0, %b_addr.021.0.ph		; <i32> [#uses=1]
	%tmp.40 = mul i32 %indvar, %tmp.		; <i32> [#uses=1]
	%a_addr.026.0 = add i32 %tmp.40, %a_addr.026.0.ph		; <i32> [#uses=6]
	%tmp3 = icmp sgt i32 %a_addr.026.0, %b_addr.021.0.ph		; <i1> [#uses=1]
	br i1 %tmp3, label %cond_true, label %cond_false

cond_true:		; preds = %bb
	%tmp7 = sub i32 %a_addr.026.0, %b_addr.021.0.ph		; <i32> [#uses=2]
	%tmp1437 = icmp eq i32 %tmp7, %b_addr.021.0.ph		; <i1> [#uses=1]
	%indvar.next = add i32 %indvar, 1		; <i32> [#uses=1]
	br i1 %tmp1437, label %bb17, label %bb

cond_false:		; preds = %bb
	%tmp10 = sub i32 %b_addr.021.0.ph, %a_addr.026.0		; <i32> [#uses=2]
	%tmp14 = icmp eq i32 %b_addr.021.0.ph, %tmp10		; <i1> [#uses=1]
	br i1 %tmp14, label %bb17, label %bb.outer

bb17:		; preds = %cond_false, %cond_true, %entry
	%a_addr.026.1 = phi i32 [ %a, %entry ], [ %tmp7, %cond_true ], [ %a_addr.026.0, %cond_false ]		; <i32> [#uses=1]
	ret i32 %a_addr.026.1
}

@x = external global i32*		; <i32**> [#uses=1]

define void @foo(i32 %a) nounwind {
; V01-LABEL: foo:
; V01:       @ %bb.0: @ %entry
; V01-NEXT:    movw r1, :lower16:(L_x$non_lazy_ptr-(LPC3_0+4))
; V01-NEXT:    movt r1, :upper16:(L_x$non_lazy_ptr-(LPC3_0+4))
; V01-NEXT:  LPC3_0:
; V01-NEXT:    add r1, pc
; V01-NEXT:    ldr r1, [r1]
; V01-NEXT:    ldr r1, [r1]
; V01-NEXT:    str r0, [r1]
; V01-NEXT:    bx lr
;
; V23-LABEL: foo:
; V23:       @ %bb.0: @ %entry
; V23-NEXT:    movw r1, :lower16:x
; V23-NEXT:    movt r1, :upper16:x
; V23-NEXT:    ldr r1, [r1]
; V23-NEXT:    str r0, [r1]
; V23-NEXT:    bx lr
entry:
	%tmp = load i32*, i32** @x		; <i32*> [#uses=1]
	store i32 %a, i32* %tmp
	ret void
}

define void @t3(i32 %a, i32 %b) nounwind {
; V01-LABEL: t3:
; V01:       @ %bb.0: @ %entry
; V01-NEXT:    cmp r0, #11
; V01-NEXT:    it lt
; V01-NEXT:    bxlt lr
; V01-NEXT:  LBB4_1: @ %cond_true
; V01-NEXT:    str lr, [sp, #-4]!
; V01-NEXT:    mov r0, r1
; V01-NEXT:    bl _foo
; V01-NEXT:    ldr lr, [sp], #4
; V01-NEXT:    bx lr
;
; V23-LABEL: t3:
; V23:       @ %bb.0: @ %entry
; V23-NEXT:    cmp r0, #11
; V23-NEXT:    it lt
; V23-NEXT:    bxlt lr
; V23-NEXT:  .LBB4_1: @ %cond_true
; V23-NEXT:    push {r7, lr}
; V23-NEXT:    mov r0, r1
; V23-NEXT:    bl foo
; V23-NEXT:    pop {r7, pc}
entry:
	%tmp1 = icmp sgt i32 %a, 10		; <i1> [#uses=1]
	br i1 %tmp1, label %cond_true, label %UnifiedReturnBlock

cond_true:		; preds = %entry
	call void @foo( i32 %b )
	ret void

UnifiedReturnBlock:		; preds = %entry
	ret void
}
