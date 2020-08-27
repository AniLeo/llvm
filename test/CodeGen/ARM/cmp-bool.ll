; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv7a < %s | FileCheck %s --check-prefix=ARM
; RUN: llc -mtriple=armv6m < %s | FileCheck %s --check-prefix=THUMB
; RUN: llc -mtriple=armv7m < %s | FileCheck %s --check-prefix=THUMB2

define void @bool_eq(i1 zeroext %a, i1 zeroext %b, void ()* nocapture %c) nounwind {
; ARM-LABEL: bool_eq:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    bxne lr
; ARM-NEXT:  .LBB0_1: @ %if.then
; ARM-NEXT:    bx r2
;
; THUMB-LABEL: bool_eq:
; THUMB:       @ %bb.0: @ %entry
; THUMB-NEXT:    push {r7, lr}
; THUMB-NEXT:    cmp r0, r1
; THUMB-NEXT:    bne .LBB0_2
; THUMB-NEXT:  @ %bb.1: @ %if.then
; THUMB-NEXT:    blx r2
; THUMB-NEXT:  .LBB0_2: @ %if.end
; THUMB-NEXT:    pop {r7, pc}
;
; THUMB2-LABEL: bool_eq:
; THUMB2:       @ %bb.0: @ %entry
; THUMB2-NEXT:    cmp r0, r1
; THUMB2-NEXT:    it ne
; THUMB2-NEXT:    bxne lr
; THUMB2-NEXT:  .LBB0_1: @ %if.then
; THUMB2-NEXT:    bx r2
entry:
  %0 = xor i1 %a, %b
  br i1 %0, label %if.end, label %if.then

if.then:
  tail call void %c() #1
  br label %if.end

if.end:
  ret void
}

define void @bool_ne(i1 zeroext %a, i1 zeroext %b, void ()* nocapture %c) nounwind {
; ARM-LABEL: bool_ne:
; ARM:       @ %bb.0: @ %entry
; ARM-NEXT:    cmp r0, r1
; ARM-NEXT:    bxeq lr
; ARM-NEXT:  .LBB1_1: @ %if.then
; ARM-NEXT:    bx r2
;
; THUMB-LABEL: bool_ne:
; THUMB:       @ %bb.0: @ %entry
; THUMB-NEXT:    push {r7, lr}
; THUMB-NEXT:    cmp r0, r1
; THUMB-NEXT:    beq .LBB1_2
; THUMB-NEXT:  @ %bb.1: @ %if.then
; THUMB-NEXT:    blx r2
; THUMB-NEXT:  .LBB1_2: @ %if.end
; THUMB-NEXT:    pop {r7, pc}
;
; THUMB2-LABEL: bool_ne:
; THUMB2:       @ %bb.0: @ %entry
; THUMB2-NEXT:    cmp r0, r1
; THUMB2-NEXT:    it eq
; THUMB2-NEXT:    bxeq lr
; THUMB2-NEXT:  .LBB1_1: @ %if.then
; THUMB2-NEXT:    bx r2
entry:
  %cmp = xor i1 %a, %b
  br i1 %cmp, label %if.then, label %if.end

if.then:
  tail call void %c() #1
  br label %if.end

if.end:
  ret void
}
