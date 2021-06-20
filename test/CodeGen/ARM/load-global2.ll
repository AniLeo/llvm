; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; PR35221. Test that external global address is not reloaded from GOT in each BB.
; RUN: llc < %s -mtriple=armv7-linux-gnueabi -relocation-model=pic | FileCheck %s -check-prefix=LINUX-PIC

@x = external global i8, align 1

define signext i8 @foo() {
; LINUX-PIC-LABEL: foo:
; LINUX-PIC:       @ %bb.0: @ %entry
; LINUX-PIC-NEXT:    .save {r4, lr}
; LINUX-PIC-NEXT:    push {r4, lr}
; LINUX-PIC-NEXT:    ldr r4, .LCPI0_0
; LINUX-PIC-NEXT:  .LPC0_0:
; LINUX-PIC-NEXT:    ldr r4, [pc, r4]
; LINUX-PIC-NEXT:    ldrb r0, [r4]
; LINUX-PIC-NEXT:    cmp r0, #0
; LINUX-PIC-NEXT:    movne r0, #0
; LINUX-PIC-NEXT:    popne {r4, pc}
; LINUX-PIC-NEXT:  .LBB0_1: @ %bb1
; LINUX-PIC-NEXT:    bl bar
; LINUX-PIC-NEXT:    ldrsb r0, [r4]
; LINUX-PIC-NEXT:    pop {r4, pc}
; LINUX-PIC-NEXT:    .p2align 2
; LINUX-PIC-NEXT:  @ %bb.2:
; LINUX-PIC-NEXT:  .LCPI0_0:
; LINUX-PIC-NEXT:  .Ltmp0:
; LINUX-PIC-NEXT:    .long x(GOT_PREL)-((.LPC0_0+8)-.Ltmp0)
entry:
  %0 = load i8, i8* @x
  %tobool = icmp eq i8 %0, 0
  br i1 %tobool, label %bb1, label %bb2

bb1:
  call void @bar()
; No more pc-relative loads! Reuse r[[B]].
  %1 = load i8, i8* @x
  ret i8 %1

bb2:
  ret i8 0
}

declare void @bar()


