; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv7a-none-none-eabi -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK7A
; RUN: llc -mtriple=thumbv6m-none-none-eabi -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK6M
; RUN: llc -mtriple=thumbv7m-none-none-eabi -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK7M
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK81M

define i32 @xori64i32(i64 %a) {
; CHECK7A-LABEL: xori64i32:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    mvn r0, #-2147483648
; CHECK7A-NEXT:    eor r0, r0, r1, asr #31
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: xori64i32:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    asrs r1, r1, #31
; CHECK6M-NEXT:    ldr r0, .LCPI0_0
; CHECK6M-NEXT:    eors r0, r1
; CHECK6M-NEXT:    bx lr
; CHECK6M-NEXT:    .p2align 2
; CHECK6M-NEXT:  @ %bb.1:
; CHECK6M-NEXT:  .LCPI0_0:
; CHECK6M-NEXT:    .long 2147483647 @ 0x7fffffff
;
; CHECK7M-LABEL: xori64i32:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    mvn r0, #-2147483648
; CHECK7M-NEXT:    eor.w r0, r0, r1, asr #31
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: xori64i32:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    mvn r0, #-2147483648
; CHECK81M-NEXT:    eor.w r0, r0, r1, asr #31
; CHECK81M-NEXT:    bx lr
  %shr4 = ashr i64 %a, 63
  %conv5 = trunc i64 %shr4 to i32
  %xor = xor i32 %conv5, 2147483647
  ret i32 %xor
}

define i64 @selecti64i64(i64 %a) {
; CHECK7A-LABEL: selecti64i64:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    mvn r0, #-2147483648
; CHECK7A-NEXT:    eor r0, r0, r1, asr #31
; CHECK7A-NEXT:    asr r1, r1, #31
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: selecti64i64:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    asrs r1, r1, #31
; CHECK6M-NEXT:    ldr r0, .LCPI1_0
; CHECK6M-NEXT:    eors r0, r1
; CHECK6M-NEXT:    bx lr
; CHECK6M-NEXT:    .p2align 2
; CHECK6M-NEXT:  @ %bb.1:
; CHECK6M-NEXT:  .LCPI1_0:
; CHECK6M-NEXT:    .long 2147483647 @ 0x7fffffff
;
; CHECK7M-LABEL: selecti64i64:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    mvn r0, #-2147483648
; CHECK7M-NEXT:    eor.w r0, r0, r1, asr #31
; CHECK7M-NEXT:    asrs r1, r1, #31
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: selecti64i64:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    mvn r0, #-2147483648
; CHECK81M-NEXT:    eor.w r0, r0, r1, asr #31
; CHECK81M-NEXT:    asrs r1, r1, #31
; CHECK81M-NEXT:    bx lr
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}

define i32 @selecti64i32(i64 %a) {
; CHECK7A-LABEL: selecti64i32:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    mvn r0, #-2147483648
; CHECK7A-NEXT:    eor r0, r0, r1, asr #31
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: selecti64i32:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    ldr r0, .LCPI2_0
; CHECK6M-NEXT:    cmp r1, #0
; CHECK6M-NEXT:    bge .LBB2_2
; CHECK6M-NEXT:  @ %bb.1:
; CHECK6M-NEXT:    adds r0, r0, #1
; CHECK6M-NEXT:  .LBB2_2:
; CHECK6M-NEXT:    bx lr
; CHECK6M-NEXT:    .p2align 2
; CHECK6M-NEXT:  @ %bb.3:
; CHECK6M-NEXT:  .LCPI2_0:
; CHECK6M-NEXT:    .long 2147483647 @ 0x7fffffff
;
; CHECK7M-LABEL: selecti64i32:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    mvn r0, #-2147483648
; CHECK7M-NEXT:    eor.w r0, r0, r1, asr #31
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: selecti64i32:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    mvn r0, #-2147483648
; CHECK81M-NEXT:    eor.w r0, r0, r1, asr #31
; CHECK81M-NEXT:    bx lr
  %c = icmp sgt i64 %a, -1
  %s = select i1 %c, i32 2147483647, i32 -2147483648
  ret i32 %s
}

define i64 @selecti32i64(i32 %a) {
; CHECK7A-LABEL: selecti32i64:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    mvn r1, #-2147483648
; CHECK7A-NEXT:    eor r2, r1, r0, asr #31
; CHECK7A-NEXT:    asr r1, r0, #31
; CHECK7A-NEXT:    mov r0, r2
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: selecti32i64:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    asrs r1, r0, #31
; CHECK6M-NEXT:    ldr r0, .LCPI3_0
; CHECK6M-NEXT:    eors r0, r1
; CHECK6M-NEXT:    bx lr
; CHECK6M-NEXT:    .p2align 2
; CHECK6M-NEXT:  @ %bb.1:
; CHECK6M-NEXT:  .LCPI3_0:
; CHECK6M-NEXT:    .long 2147483647 @ 0x7fffffff
;
; CHECK7M-LABEL: selecti32i64:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    mvn r1, #-2147483648
; CHECK7M-NEXT:    eor.w r2, r1, r0, asr #31
; CHECK7M-NEXT:    asrs r1, r0, #31
; CHECK7M-NEXT:    mov r0, r2
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: selecti32i64:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    mvn r1, #-2147483648
; CHECK81M-NEXT:    eor.w r2, r1, r0, asr #31
; CHECK81M-NEXT:    asrs r1, r0, #31
; CHECK81M-NEXT:    mov r0, r2
; CHECK81M-NEXT:    bx lr
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i64 2147483647, i64 -2147483648
  ret i64 %s
}



define i8 @xori32i8(i32 %a) {
; CHECK7A-LABEL: xori32i8:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    mov r1, #84
; CHECK7A-NEXT:    eor r0, r1, r0, asr #31
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: xori32i8:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    asrs r1, r0, #31
; CHECK6M-NEXT:    movs r0, #84
; CHECK6M-NEXT:    eors r0, r1
; CHECK6M-NEXT:    bx lr
;
; CHECK7M-LABEL: xori32i8:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    movs r1, #84
; CHECK7M-NEXT:    eor.w r0, r1, r0, asr #31
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: xori32i8:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    movs r1, #84
; CHECK81M-NEXT:    eor.w r0, r1, r0, asr #31
; CHECK81M-NEXT:    bx lr
  %shr4 = ashr i32 %a, 31
  %conv5 = trunc i32 %shr4 to i8
  %xor = xor i8 %conv5, 84
  ret i8 %xor
}

define i32 @selecti32i32(i32 %a) {
; CHECK7A-LABEL: selecti32i32:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    mov r1, #84
; CHECK7A-NEXT:    eor r0, r1, r0, asr #31
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: selecti32i32:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    asrs r1, r0, #31
; CHECK6M-NEXT:    movs r0, #84
; CHECK6M-NEXT:    eors r0, r1
; CHECK6M-NEXT:    bx lr
;
; CHECK7M-LABEL: selecti32i32:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    movs r1, #84
; CHECK7M-NEXT:    eor.w r0, r1, r0, asr #31
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: selecti32i32:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    movs r1, #84
; CHECK81M-NEXT:    eor.w r0, r1, r0, asr #31
; CHECK81M-NEXT:    bx lr
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i8 @selecti32i8(i32 %a) {
; CHECK7A-LABEL: selecti32i8:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    mov r1, #84
; CHECK7A-NEXT:    eor r0, r1, r0, asr #31
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: selecti32i8:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    asrs r1, r0, #31
; CHECK6M-NEXT:    movs r0, #84
; CHECK6M-NEXT:    eors r0, r1
; CHECK6M-NEXT:    bx lr
;
; CHECK7M-LABEL: selecti32i8:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    movs r1, #84
; CHECK7M-NEXT:    eor.w r0, r1, r0, asr #31
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: selecti32i8:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    movs r1, #84
; CHECK81M-NEXT:    eor.w r0, r1, r0, asr #31
; CHECK81M-NEXT:    bx lr
  %c = icmp sgt i32 %a, -1
  %s = select i1 %c, i8 84, i8 -85
  ret i8 %s
}

define i32 @selecti8i32(i8 %a) {
; CHECK7A-LABEL: selecti8i32:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    sxtb r0, r0
; CHECK7A-NEXT:    mov r1, #84
; CHECK7A-NEXT:    eor r0, r1, r0, asr #7
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: selecti8i32:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    sxtb r0, r0
; CHECK6M-NEXT:    asrs r1, r0, #7
; CHECK6M-NEXT:    movs r0, #84
; CHECK6M-NEXT:    eors r0, r1
; CHECK6M-NEXT:    bx lr
;
; CHECK7M-LABEL: selecti8i32:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    sxtb r0, r0
; CHECK7M-NEXT:    movs r1, #84
; CHECK7M-NEXT:    eor.w r0, r1, r0, asr #7
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: selecti8i32:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    sxtb r0, r0
; CHECK81M-NEXT:    movs r1, #84
; CHECK81M-NEXT:    eor.w r0, r1, r0, asr #7
; CHECK81M-NEXT:    bx lr
  %c = icmp sgt i8 %a, -1
  %s = select i1 %c, i32 84, i32 -85
  ret i32 %s
}

define i32 @icmpasreq(i32 %input, i32 %a, i32 %b) {
; CHECK7A-LABEL: icmpasreq:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    cmp r0, #0
; CHECK7A-NEXT:    movpl r1, r2
; CHECK7A-NEXT:    mov r0, r1
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: icmpasreq:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    cmp r0, #0
; CHECK6M-NEXT:    bmi .LBB8_2
; CHECK6M-NEXT:  @ %bb.1:
; CHECK6M-NEXT:    mov r1, r2
; CHECK6M-NEXT:  .LBB8_2:
; CHECK6M-NEXT:    mov r0, r1
; CHECK6M-NEXT:    bx lr
;
; CHECK7M-LABEL: icmpasreq:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    cmp r0, #0
; CHECK7M-NEXT:    it pl
; CHECK7M-NEXT:    movpl r1, r2
; CHECK7M-NEXT:    mov r0, r1
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: icmpasreq:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    cmp r0, #0
; CHECK81M-NEXT:    csel r0, r1, r2, mi
; CHECK81M-NEXT:    bx lr
  %sh = ashr i32 %input, 31
  %c = icmp eq i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @icmpasrne(i32 %input, i32 %a, i32 %b) {
; CHECK7A-LABEL: icmpasrne:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    cmn r0, #1
; CHECK7A-NEXT:    movle r1, r2
; CHECK7A-NEXT:    mov r0, r1
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: icmpasrne:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    cmp r0, #0
; CHECK6M-NEXT:    bge .LBB9_2
; CHECK6M-NEXT:  @ %bb.1:
; CHECK6M-NEXT:    mov r1, r2
; CHECK6M-NEXT:  .LBB9_2:
; CHECK6M-NEXT:    mov r0, r1
; CHECK6M-NEXT:    bx lr
;
; CHECK7M-LABEL: icmpasrne:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    cmp.w r0, #-1
; CHECK7M-NEXT:    it le
; CHECK7M-NEXT:    movle r1, r2
; CHECK7M-NEXT:    mov r0, r1
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: icmpasrne:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    cmp.w r0, #-1
; CHECK81M-NEXT:    csel r0, r1, r2, gt
; CHECK81M-NEXT:    bx lr
  %sh = ashr i32 %input, 31
  %c = icmp ne i32 %sh, -1
  %s = select i1 %c, i32 %a, i32 %b
  ret i32 %s
}

define i32 @oneusecmp(i32 %a, i32 %b, i32 %d) {
; CHECK7A-LABEL: oneusecmp:
; CHECK7A:       @ %bb.0:
; CHECK7A-NEXT:    cmp r0, #0
; CHECK7A-NEXT:    movmi r1, r2
; CHECK7A-NEXT:    mov r2, #127
; CHECK7A-NEXT:    eor r0, r2, r0, asr #31
; CHECK7A-NEXT:    add r0, r0, r1
; CHECK7A-NEXT:    bx lr
;
; CHECK6M-LABEL: oneusecmp:
; CHECK6M:       @ %bb.0:
; CHECK6M-NEXT:    cmp r0, #0
; CHECK6M-NEXT:    bmi .LBB10_2
; CHECK6M-NEXT:  @ %bb.1:
; CHECK6M-NEXT:    mov r2, r1
; CHECK6M-NEXT:  .LBB10_2:
; CHECK6M-NEXT:    asrs r0, r0, #31
; CHECK6M-NEXT:    movs r1, #127
; CHECK6M-NEXT:    eors r1, r0
; CHECK6M-NEXT:    adds r0, r1, r2
; CHECK6M-NEXT:    bx lr
;
; CHECK7M-LABEL: oneusecmp:
; CHECK7M:       @ %bb.0:
; CHECK7M-NEXT:    cmp r0, #0
; CHECK7M-NEXT:    it mi
; CHECK7M-NEXT:    movmi r1, r2
; CHECK7M-NEXT:    movs r2, #127
; CHECK7M-NEXT:    eor.w r0, r2, r0, asr #31
; CHECK7M-NEXT:    add r0, r1
; CHECK7M-NEXT:    bx lr
;
; CHECK81M-LABEL: oneusecmp:
; CHECK81M:       @ %bb.0:
; CHECK81M-NEXT:    cmp r0, #0
; CHECK81M-NEXT:    csel r1, r2, r1, mi
; CHECK81M-NEXT:    movs r2, #127
; CHECK81M-NEXT:    eor.w r0, r2, r0, asr #31
; CHECK81M-NEXT:    add r0, r1
; CHECK81M-NEXT:    bx lr
  %c = icmp sle i32 %a, -1
  %s = select i1 %c, i32 -128, i32 127
  %s2 = select i1 %c, i32 %d, i32 %b
  %x = add i32 %s, %s2
  ret i32 %x
}
