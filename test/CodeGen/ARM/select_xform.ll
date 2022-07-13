; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm-- -mcpu=cortex-a8 | FileCheck %s -check-prefixes=CHECK,ARM
; RUN: llc < %s -mtriple=thumb-- -mcpu=cortex-a8 | FileCheck %s -check-prefixes=CHECK,T2
; rdar://8662825

define i32 @t1(i32 %a, i32 %b, i32 %c) nounwind {
; ARM-LABEL: t1:
; ARM:       @ %bb.0:
; ARM-NEXT:    mov r0, r1
; ARM-NEXT:    cmp r2, #10
; ARM-NEXT:    suble r0, r0, #-2147483647
; ARM-NEXT:    bx lr
;
; T2-LABEL: t1:
; T2:       @ %bb.0:
; T2-NEXT:    mov r0, r1
; T2-NEXT:    mvn r1, #-2147483648
; T2-NEXT:    cmp r2, #10
; T2-NEXT:    it le
; T2-NEXT:    addle r0, r1
; T2-NEXT:    bx lr
  %tmp1 = icmp sgt i32 %c, 10
  %tmp2 = select i1 %tmp1, i32 0, i32 2147483647
  %tmp3 = add i32 %tmp2, %b
  ret i32 %tmp3
}

define i32 @t2(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; ARM-LABEL: t2:
; ARM:       @ %bb.0:
; ARM-NEXT:    mov r0, r1
; ARM-NEXT:    cmp r2, #10
; ARM-NEXT:    suble r0, r0, #10
; ARM-NEXT:    bx lr
;
; T2-LABEL: t2:
; T2:       @ %bb.0:
; T2-NEXT:    mov r0, r1
; T2-NEXT:    cmp r2, #10
; T2-NEXT:    it le
; T2-NEXT:    suble r0, #10
; T2-NEXT:    bx lr
  %tmp1 = icmp sgt i32 %c, 10
  %tmp2 = select i1 %tmp1, i32 0, i32 10
  %tmp3 = sub i32 %b, %tmp2
  ret i32 %tmp3
}

define i32 @t3(i32 %a, i32 %b, i32 %x, i32 %y) nounwind {
; ARM-LABEL: t3:
; ARM:       @ %bb.0:
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    andge r3, r3, r2
; ARM-NEXT:    mov r0, r3
; ARM-NEXT:    bx lr
;
; T2-LABEL: t3:
; T2:       @ %bb.0:
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it ge
; T2-NEXT:    andge r3, r2
; T2-NEXT:    mov r0, r3
; T2-NEXT:    bx lr
  %cond = icmp slt i32 %a, %b
  %z = select i1 %cond, i32 -1, i32 %x
  %s = and i32 %z, %y
 ret i32 %s
}

define i32 @t4(i32 %a, i32 %b, i32 %x, i32 %y) nounwind {
; ARM-LABEL: t4:
; ARM:       @ %bb.0:
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    orrge r3, r3, r2
; ARM-NEXT:    mov r0, r3
; ARM-NEXT:    bx lr
;
; T2-LABEL: t4:
; T2:       @ %bb.0:
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it ge
; T2-NEXT:    orrge r3, r2
; T2-NEXT:    mov r0, r3
; T2-NEXT:    bx lr
  %cond = icmp slt i32 %a, %b
  %z = select i1 %cond, i32 0, i32 %x
  %s = or i32 %z, %y
 ret i32 %s
}

define i32 @t5(i32 %a, i32 %b, i32 %c) nounwind {
; ARM-LABEL: t5:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    orreq r2, r2, #1
; ARM-NEXT:    mov r0, r2
; ARM-NEXT:    bx lr
;
; T2-LABEL: t5:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it eq
; T2-NEXT:    orreq r2, r2, #1
; T2-NEXT:    mov r0, r2
; T2-NEXT:    bx lr
entry:
  %tmp1 = icmp eq i32 %a, %b
  %tmp2 = zext i1 %tmp1 to i32
  %tmp3 = or i32 %tmp2, %c
  ret i32 %tmp3
}

define i32 @t6(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; ARM-LABEL: t6:
; ARM:       @ %bb.0:
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    eorlt r3, r3, r2
; ARM-NEXT:    mov r0, r3
; ARM-NEXT:    bx lr
;
; T2-LABEL: t6:
; T2:       @ %bb.0:
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it lt
; T2-NEXT:    eorlt r3, r2
; T2-NEXT:    mov r0, r3
; T2-NEXT:    bx lr
  %cond = icmp slt i32 %a, %b
  %tmp1 = select i1 %cond, i32 %c, i32 0
  %tmp2 = xor i32 %tmp1, %d
  ret i32 %tmp2
}

define i32 @t7(i32 %a, i32 %b, i32 %c) nounwind {
; ARM-LABEL: t7:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    andeq r2, r2, r2, lsl #1
; ARM-NEXT:    mov r0, r2
; ARM-NEXT:    bx lr
;
; T2-LABEL: t7:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it eq
; T2-NEXT:    andeq.w r2, r2, r2, lsl #1
; T2-NEXT:    mov r0, r2
; T2-NEXT:    bx lr
entry:
  %tmp1 = shl i32 %c, 1
  %cond = icmp eq i32 %a, %b
  %tmp2 = select i1 %cond, i32 %tmp1, i32 -1
  %tmp3 = and i32 %c, %tmp2
  ret i32 %tmp3
}

; Fold ORRri into movcc.
define i32 @t8(i32 %a, i32 %b) nounwind {
; ARM-LABEL: t8:
; ARM:       @ %bb.0:
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    orrge r0, r1, #1
; ARM-NEXT:    bx lr
;
; T2-LABEL: t8:
; T2:       @ %bb.0:
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it ge
; T2-NEXT:    orrge r0, r1, #1
; T2-NEXT:    bx lr
  %x = or i32 %b, 1
  %cond = icmp slt i32 %a, %b
  %tmp1 = select i1 %cond, i32 %a, i32 %x
  ret i32 %tmp1
}

; Fold ANDrr into movcc.
define i32 @t9(i32 %a, i32 %b, i32 %c) nounwind {
; ARM-LABEL: t9:
; ARM:       @ %bb.0:
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    andge r0, r1, r2
; ARM-NEXT:    bx lr
;
; T2-LABEL: t9:
; T2:       @ %bb.0:
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it ge
; T2-NEXT:    andge.w r0, r1, r2
; T2-NEXT:    bx lr
  %x = and i32 %b, %c
  %cond = icmp slt i32 %a, %b
  %tmp1 = select i1 %cond, i32 %a, i32 %x
  ret i32 %tmp1
}

; Fold EORrs into movcc.
define i32 @t10(i32 %a, i32 %b, i32 %c, i32 %d) nounwind {
; ARM-LABEL: t10:
; ARM:       @ %bb.0:
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    eorge r0, r1, r2, lsl #7
; ARM-NEXT:    bx lr
;
; T2-LABEL: t10:
; T2:       @ %bb.0:
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it ge
; T2-NEXT:    eorge.w r0, r1, r2, lsl #7
; T2-NEXT:    bx lr
  %s = shl i32 %c, 7
  %x = xor i32 %b, %s
  %cond = icmp slt i32 %a, %b
  %tmp1 = select i1 %cond, i32 %a, i32 %x
  ret i32 %tmp1
}

; Fold ORRri into movcc, reversing the condition.
define i32 @t11(i32 %a, i32 %b) nounwind {
; ARM-LABEL: t11:
; ARM:       @ %bb.0:
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    orrlt r0, r1, #1
; ARM-NEXT:    bx lr
;
; T2-LABEL: t11:
; T2:       @ %bb.0:
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it lt
; T2-NEXT:    orrlt r0, r1, #1
; T2-NEXT:    bx lr
  %x = or i32 %b, 1
  %cond = icmp slt i32 %a, %b
  %tmp1 = select i1 %cond, i32 %x, i32 %a
  ret i32 %tmp1
}

; Fold ADDri12 into movcc
define i32 @t12(i32 %a, i32 %b) nounwind {
; ARM-LABEL: t12:
; ARM:       @ %bb.0:
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    movw r2, #3000
; ARM-NEXT:    addge r0, r1, r2
; ARM-NEXT:    bx lr
;
; T2-LABEL: t12:
; T2:       @ %bb.0:
; T2-NEXT:    cmp r0, r1
; T2-NEXT:    it ge
; T2-NEXT:    addwge r0, r1, #3000
; T2-NEXT:    bx lr
  %x = add i32 %b, 3000
  %cond = icmp slt i32 %a, %b
  %tmp1 = select i1 %cond, i32 %a, i32 %x
  ret i32 %tmp1
}

; Handle frame index operands.
define void @pr13628() nounwind uwtable align 2 {
; ARM-LABEL: pr13628:
; ARM:       @ %bb.0:
; ARM-NEXT:    push {r11, lr}
; ARM-NEXT:    sub sp, sp, #256
; ARM-NEXT:    ldrb r1, [r0]
; ARM-NEXT:    mov r0, sp
; ARM-NEXT:    cmp r1, #0
; ARM-NEXT:    moveq r0, r1
; ARM-NEXT:    bl bar
; ARM-NEXT:    add sp, sp, #256
; ARM-NEXT:    pop {r11, pc}
;
; T2-LABEL: pr13628:
; T2:       @ %bb.0:
; T2-NEXT:    push {r7, lr}
; T2-NEXT:    sub sp, #256
; T2-NEXT:    ldrb r1, [r0]
; T2-NEXT:    mov r0, sp
; T2-NEXT:    cmp r1, #0
; T2-NEXT:    it eq
; T2-NEXT:    moveq r0, r1
; T2-NEXT:    bl bar
; T2-NEXT:    add sp, #256
; T2-NEXT:    pop {r7, pc}
  %x3 = alloca i8, i32 256, align 8
  %x4 = load i8, i8* undef, align 1
  %x5 = icmp ne i8 %x4, 0
  %x6 = select i1 %x5, i8* %x3, i8* null
  call void @bar(i8* %x6) nounwind
  ret void
}
declare void @bar(i8*)

; Fold zext i1 into predicated add
define i32 @t13(i32 %c, i32 %a) nounwind readnone ssp {
; ARM-LABEL: t13:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmp r1, #10
; ARM-NEXT:    addgt r0, r0, #1
; ARM-NEXT:    bx lr
;
; T2-LABEL: t13:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    cmp r1, #10
; T2-NEXT:    it gt
; T2-NEXT:    addgt r0, #1
; T2-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 10
  %conv = zext i1 %cmp to i32
  %add = add i32 %conv, %c
  ret i32 %add
}

; Fold sext i1 into predicated sub
define i32 @t14(i32 %c, i32 %a) nounwind readnone ssp {
; ARM-LABEL: t14:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmp r1, #10
; ARM-NEXT:    subgt r0, r0, #1
; ARM-NEXT:    bx lr
;
; T2-LABEL: t14:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    cmp r1, #10
; T2-NEXT:    it gt
; T2-NEXT:    subgt r0, #1
; T2-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %a, 10
  %conv = sext i1 %cmp to i32
  %add = add i32 %conv, %c
  ret i32 %add
}

; Fold the xor into the select.
define i32 @t15(i32 %p) {
; ARM-LABEL: t15:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    mov r1, #3
; ARM-NEXT:    cmp r0, #8
; ARM-NEXT:    movwgt r1, #0
; ARM-NEXT:    mov r0, r1
; ARM-NEXT:    bx lr
;
; T2-LABEL: t15:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    movs r1, #3
; T2-NEXT:    cmp r0, #8
; T2-NEXT:    it gt
; T2-NEXT:    movgt r1, #0
; T2-NEXT:    mov r0, r1
; T2-NEXT:    bx lr
entry:
  %cmp = icmp sgt i32 %p, 8
  %a = select i1 %cmp, i32 1, i32 2
  %xor = xor i32 %a, 1
  ret i32 %xor
}

define i32 @t16(i32 %x, i32 %y) {
; ARM-LABEL: t16:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmp r0, #0
; ARM-NEXT:    mov r2, #2
; ARM-NEXT:    movweq r2, #5
; ARM-NEXT:    mov r0, #4
; ARM-NEXT:    cmp r1, #0
; ARM-NEXT:    movweq r0, #3
; ARM-NEXT:    and r0, r0, r2
; ARM-NEXT:    bx lr
;
; T2-LABEL: t16:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    cmp r0, #0
; T2-NEXT:    mov.w r2, #2
; T2-NEXT:    mov.w r0, #4
; T2-NEXT:    it eq
; T2-NEXT:    moveq r2, #5
; T2-NEXT:    cmp r1, #0
; T2-NEXT:    it eq
; T2-NEXT:    moveq r0, #3
; T2-NEXT:    ands r0, r2
; T2-NEXT:    bx lr
entry:
  %cmp = icmp eq i32 %x, 0
  %cond = select i1 %cmp, i32 5, i32 2
  %cmp1 = icmp eq i32 %y, 0
  %cond2 = select i1 %cmp1, i32 3, i32 4
  %and = and i32 %cond2, %cond
  ret i32 %and
}

define i32 @t17(i32 %x, i32 %y) #0 {
; ARM-LABEL: t17:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmn r0, #1
; ARM-NEXT:    mov r2, #2
; ARM-NEXT:    movweq r2, #5
; ARM-NEXT:    mov r0, #4
; ARM-NEXT:    cmn r1, #1
; ARM-NEXT:    movweq r0, #3
; ARM-NEXT:    and r0, r0, r2
; ARM-NEXT:    bx lr
;
; T2-LABEL: t17:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    adds r0, #1
; T2-NEXT:    mov.w r0, #2
; T2-NEXT:    it eq
; T2-NEXT:    moveq r0, #5
; T2-NEXT:    adds r1, #1
; T2-NEXT:    mov.w r1, #4
; T2-NEXT:    it eq
; T2-NEXT:    moveq r1, #3
; T2-NEXT:    ands r0, r1
; T2-NEXT:    bx lr
entry:
  %cmp = icmp eq i32 %x, -1
  %cond = select i1 %cmp, i32 5, i32 2
  %cmp1 = icmp eq i32 %y, -1
  %cond2 = select i1 %cmp1, i32 3, i32 4
  %and = and i32 %cond2, %cond
  ret i32 %and
}

define i32 @t18(i32 %x, i32 %y) #0 {
; ARM-LABEL: t18:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    mov r1, #2
; ARM-NEXT:    cmp r0, #0
; ARM-NEXT:    movwne r1, #5
; ARM-NEXT:    mov r2, #4
; ARM-NEXT:    cmn r0, #1
; ARM-NEXT:    movwne r2, #3
; ARM-NEXT:    and r0, r2, r1
; ARM-NEXT:    bx lr
;
; T2-LABEL: t18:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    movs r1, #2
; T2-NEXT:    cmp r0, #0
; T2-NEXT:    it ne
; T2-NEXT:    movne r1, #5
; T2-NEXT:    adds r0, #1
; T2-NEXT:    mov.w r0, #4
; T2-NEXT:    it ne
; T2-NEXT:    movne r0, #3
; T2-NEXT:    ands r0, r1
; T2-NEXT:    bx lr
entry:
  %cmp = icmp ne i32 %x, 0
  %cond = select i1 %cmp, i32 5, i32 2
  %cmp1 = icmp ne i32 %x, -1
  %cond2 = select i1 %cmp1, i32 3, i32 4
  %and = and i32 %cond2, %cond
  ret i32 %and
}

define i32 @t19(i32 %x, i32 %y) #0 {
; ARM-LABEL: t19:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmp r0, #0
; ARM-NEXT:    mov r2, #2
; ARM-NEXT:    movwne r2, #5
; ARM-NEXT:    mov r0, #4
; ARM-NEXT:    cmp r1, #0
; ARM-NEXT:    movwne r0, #3
; ARM-NEXT:    orr r0, r0, r2
; ARM-NEXT:    bx lr
;
; T2-LABEL: t19:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    cmp r0, #0
; T2-NEXT:    mov.w r2, #2
; T2-NEXT:    mov.w r0, #4
; T2-NEXT:    it ne
; T2-NEXT:    movne r2, #5
; T2-NEXT:    cmp r1, #0
; T2-NEXT:    it ne
; T2-NEXT:    movne r0, #3
; T2-NEXT:    orrs r0, r2
; T2-NEXT:    bx lr
entry:
  %cmp = icmp ne i32 %x, 0
  %cond = select i1 %cmp, i32 5, i32 2
  %cmp1 = icmp ne i32 %y, 0
  %cond2 = select i1 %cmp1, i32 3, i32 4
  %or = or i32 %cond2, %cond
  ret i32 %or
}

define i32 @t20(i32 %x, i32 %y) #0 {
; ARM-LABEL: t20:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmn r0, #1
; ARM-NEXT:    mov r2, #2
; ARM-NEXT:    movwne r2, #5
; ARM-NEXT:    mov r0, #4
; ARM-NEXT:    cmn r1, #1
; ARM-NEXT:    movwne r0, #3
; ARM-NEXT:    orr r0, r0, r2
; ARM-NEXT:    bx lr
;
; T2-LABEL: t20:
; T2:       @ %bb.0: @ %entry
; T2-NEXT:    adds r0, #1
; T2-NEXT:    mov.w r0, #2
; T2-NEXT:    it ne
; T2-NEXT:    movne r0, #5
; T2-NEXT:    adds r1, #1
; T2-NEXT:    mov.w r1, #4
; T2-NEXT:    it ne
; T2-NEXT:    movne r1, #3
; T2-NEXT:    orrs r0, r1
; T2-NEXT:    bx lr
entry:
  %cmp = icmp ne i32 %x, -1
  %cond = select i1 %cmp, i32 5, i32 2
  %cmp1 = icmp ne i32 %y, -1
  %cond2 = select i1 %cmp1, i32 3, i32 4
  %or = or i32 %cond2, %cond
  ret i32 %or
}

define  <2 x i32> @t21(<2 x i32> %lhs, <2 x i32> %rhs) {
; CHECK-LABEL: t21:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r2, r3
; CHECK-NEXT:    vmov d17, r0, r1
; CHECK-NEXT:    vceq.i32 d16, d17, d16
; CHECK-NEXT:    vmov.i32 d17, #0x1
; CHECK-NEXT:    veor d16, d16, d17
; CHECK-NEXT:    vshl.i32 d16, d16, #31
; CHECK-NEXT:    vshr.s32 d16, d16, #31
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    bx lr
  %tst = icmp eq <2 x i32> %lhs, %rhs
  %ntst = xor <2 x i1> %tst, <i1 1 , i1 undef>
  %btst = sext <2 x i1> %ntst to <2 x i32>
  ret <2 x i32> %btst
}
