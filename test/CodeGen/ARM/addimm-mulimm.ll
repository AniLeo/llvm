; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv6-none-eabi %s -o - | FileCheck %s --check-prefixes=CHECK-ARM,CHECK-ARMV6
; RUN: llc -mtriple=armv7a-none-eabi %s -o - | FileCheck %s --check-prefixes=CHECK-ARM,CHECK-ARMV7
; RUN: llc -mtriple=thumbv6m-none-eabi %s -o - | FileCheck %s --check-prefixes=CHECK-THUMB,CHECK-THUMBV6M
; RUN: llc -mtriple=thumbv7m-none-eabi %s -o - | FileCheck %s --check-prefixes=CHECK-THUMB,CHECK-THUMBV7M

define i32 @fold_add19_mul11_i32(i32 %a) {
; CHECK-ARM-LABEL: fold_add19_mul11_i32:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    mov r1, #11
; CHECK-ARM-NEXT:    mul r0, r0, r1
; CHECK-ARM-NEXT:    add r0, r0, #209
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: fold_add19_mul11_i32:
; CHECK-THUMB:       @ %bb.0:
; CHECK-THUMB-NEXT:    movs r1, #11
; CHECK-THUMB-NEXT:    muls r0, r1, r0
; CHECK-THUMB-NEXT:    adds r0, #209
; CHECK-THUMB-NEXT:    bx lr
  %b = add i32 %a, 19
  %c = mul i32 %b, 11
  ret i32 %c
}

define i16 @fold_add19_mul11_i16(i16 %a) {
; CHECK-ARM-LABEL: fold_add19_mul11_i16:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    mov r1, #11
; CHECK-ARM-NEXT:    mul r0, r0, r1
; CHECK-ARM-NEXT:    add r0, r0, #209
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: fold_add19_mul11_i16:
; CHECK-THUMB:       @ %bb.0:
; CHECK-THUMB-NEXT:    movs r1, #11
; CHECK-THUMB-NEXT:    muls r0, r1, r0
; CHECK-THUMB-NEXT:    adds r0, #209
; CHECK-THUMB-NEXT:    bx lr
  %b = add i16 %a, 19
  %c = mul i16 %b, 11
  ret i16 %c
}

define i32 @fold_sub19_mul11_i32(i32 %a) {
; CHECK-ARM-LABEL: fold_sub19_mul11_i32:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    mov r1, #11
; CHECK-ARM-NEXT:    mul r0, r0, r1
; CHECK-ARM-NEXT:    sub r0, r0, #209
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: fold_sub19_mul11_i32:
; CHECK-THUMB:       @ %bb.0:
; CHECK-THUMB-NEXT:    movs r1, #11
; CHECK-THUMB-NEXT:    muls r0, r1, r0
; CHECK-THUMB-NEXT:    subs r0, #209
; CHECK-THUMB-NEXT:    bx lr
  %b = add i32 %a, -19
  %c = mul i32 %b, 11
  ret i32 %c
}

define i16 @fold_sub19_mul11_i16(i16 %a) {
; CHECK-ARM-LABEL: fold_sub19_mul11_i16:
; CHECK-ARM:       @ %bb.0:
; CHECK-ARM-NEXT:    mov r1, #11
; CHECK-ARM-NEXT:    mul r0, r0, r1
; CHECK-ARM-NEXT:    sub r0, r0, #209
; CHECK-ARM-NEXT:    bx lr
;
; CHECK-THUMB-LABEL: fold_sub19_mul11_i16:
; CHECK-THUMB:       @ %bb.0:
; CHECK-THUMB-NEXT:    movs r1, #11
; CHECK-THUMB-NEXT:    muls r0, r1, r0
; CHECK-THUMB-NEXT:    subs r0, #209
; CHECK-THUMB-NEXT:    bx lr
  %b = add i16 %a, -19
  %c = mul i16 %b, 11
  ret i16 %c
}

define i32 @fold_add301_mul19_i32(i32 %a) {
; CHECK-ARMV6-LABEL: fold_add301_mul19_i32:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mov r1, #87
; CHECK-ARMV6-NEXT:    mov r2, #19
; CHECK-ARMV6-NEXT:    orr r1, r1, #5632
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_add301_mul19_i32:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    movw r1, #5719
; CHECK-ARMV7-NEXT:    mov r2, #19
; CHECK-ARMV7-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_add301_mul19_i32:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #19
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI4_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI4_0:
; CHECK-THUMBV6M-NEXT:    .long 5719 @ 0x1657
;
; CHECK-THUMBV7M-LABEL: fold_add301_mul19_i32:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movw r1, #5719
; CHECK-THUMBV7M-NEXT:    movs r2, #19
; CHECK-THUMBV7M-NEXT:    mla r0, r0, r2, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i32 %a, 301
  %c = mul i32 %b, 19
  ret i32 %c
}

define i16 @fold_add301_mul19_i16(i16 %a) {
; CHECK-ARMV6-LABEL: fold_add301_mul19_i16:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mov r1, #87
; CHECK-ARMV6-NEXT:    mov r2, #19
; CHECK-ARMV6-NEXT:    orr r1, r1, #5632
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_add301_mul19_i16:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    movw r1, #5719
; CHECK-ARMV7-NEXT:    mov r2, #19
; CHECK-ARMV7-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_add301_mul19_i16:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #19
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI5_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI5_0:
; CHECK-THUMBV6M-NEXT:    .long 5719 @ 0x1657
;
; CHECK-THUMBV7M-LABEL: fold_add301_mul19_i16:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movw r1, #5719
; CHECK-THUMBV7M-NEXT:    movs r2, #19
; CHECK-THUMBV7M-NEXT:    mla r0, r0, r2, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i16 %a, 301
  %c = mul i16 %b, 19
  ret i16 %c
}

define i32 @fold_sub301_mul19_i32(i32 %a) {
; CHECK-ARMV6-LABEL: fold_sub301_mul19_i32:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mvn r1, #86
; CHECK-ARMV6-NEXT:    mov r2, #19
; CHECK-ARMV6-NEXT:    sub r1, r1, #5632
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_sub301_mul19_i32:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    mov r1, #19
; CHECK-ARMV7-NEXT:    mul r0, r0, r1
; CHECK-ARMV7-NEXT:    movw r1, #5719
; CHECK-ARMV7-NEXT:    sub r0, r0, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_sub301_mul19_i32:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #19
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI6_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI6_0:
; CHECK-THUMBV6M-NEXT:    .long 4294961577 @ 0xffffe9a9
;
; CHECK-THUMBV7M-LABEL: fold_sub301_mul19_i32:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movs r1, #19
; CHECK-THUMBV7M-NEXT:    muls r0, r1, r0
; CHECK-THUMBV7M-NEXT:    movw r1, #5719
; CHECK-THUMBV7M-NEXT:    subs r0, r0, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i32 %a, -301
  %c = mul i32 %b, 19
  ret i32 %c
}

define i16 @fold_sub301_mul19_i16(i16 %a) {
; CHECK-ARMV6-LABEL: fold_sub301_mul19_i16:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mvn r1, #86
; CHECK-ARMV6-NEXT:    mov r2, #19
; CHECK-ARMV6-NEXT:    sub r1, r1, #5632
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_sub301_mul19_i16:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    mov r1, #19
; CHECK-ARMV7-NEXT:    mul r0, r0, r1
; CHECK-ARMV7-NEXT:    movw r1, #5719
; CHECK-ARMV7-NEXT:    sub r0, r0, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_sub301_mul19_i16:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #19
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI7_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI7_0:
; CHECK-THUMBV6M-NEXT:    .long 4294961577 @ 0xffffe9a9
;
; CHECK-THUMBV7M-LABEL: fold_sub301_mul19_i16:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movs r1, #19
; CHECK-THUMBV7M-NEXT:    muls r0, r1, r0
; CHECK-THUMBV7M-NEXT:    movw r1, #5719
; CHECK-THUMBV7M-NEXT:    subs r0, r0, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i16 %a, -301
  %c = mul i16 %b, 19
  ret i16 %c
}

define i32 @fold_add251_mul253_i32(i32 %a) {
; CHECK-ARMV6-LABEL: fold_add251_mul253_i32:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mov r1, #15
; CHECK-ARMV6-NEXT:    mov r2, #253
; CHECK-ARMV6-NEXT:    orr r1, r1, #63488
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_add251_mul253_i32:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    movw r1, #63503
; CHECK-ARMV7-NEXT:    mov r2, #253
; CHECK-ARMV7-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_add251_mul253_i32:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #253
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI8_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI8_0:
; CHECK-THUMBV6M-NEXT:    .long 63503 @ 0xf80f
;
; CHECK-THUMBV7M-LABEL: fold_add251_mul253_i32:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movw r1, #63503
; CHECK-THUMBV7M-NEXT:    movs r2, #253
; CHECK-THUMBV7M-NEXT:    mla r0, r0, r2, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i32 %a, 251
  %c = mul i32 %b, 253
  ret i32 %c
}

define i16 @fold_add251_mul253_i16(i16 %a) {
; CHECK-ARMV6-LABEL: fold_add251_mul253_i16:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mvn r1, #2032
; CHECK-ARMV6-NEXT:    mov r2, #253
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_add251_mul253_i16:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    mov r1, #253
; CHECK-ARMV7-NEXT:    mul r0, r0, r1
; CHECK-ARMV7-NEXT:    movw r1, #2033
; CHECK-ARMV7-NEXT:    sub r0, r0, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_add251_mul253_i16:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #253
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI9_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI9_0:
; CHECK-THUMBV6M-NEXT:    .long 4294965263 @ 0xfffff80f
;
; CHECK-THUMBV7M-LABEL: fold_add251_mul253_i16:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movs r1, #253
; CHECK-THUMBV7M-NEXT:    muls r0, r1, r0
; CHECK-THUMBV7M-NEXT:    subw r0, r0, #2033
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i16 %a, 251
  %c = mul i16 %b, 253
  ret i16 %c
}

define i32 @fold_sub251_mul253_i32(i32 %a) {
; CHECK-ARMV6-LABEL: fold_sub251_mul253_i32:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mvn r1, #14
; CHECK-ARMV6-NEXT:    mov r2, #253
; CHECK-ARMV6-NEXT:    sub r1, r1, #63488
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_sub251_mul253_i32:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    mov r1, #253
; CHECK-ARMV7-NEXT:    mul r0, r0, r1
; CHECK-ARMV7-NEXT:    movw r1, #63503
; CHECK-ARMV7-NEXT:    sub r0, r0, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_sub251_mul253_i32:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #253
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI10_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI10_0:
; CHECK-THUMBV6M-NEXT:    .long 4294903793 @ 0xffff07f1
;
; CHECK-THUMBV7M-LABEL: fold_sub251_mul253_i32:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movs r1, #253
; CHECK-THUMBV7M-NEXT:    muls r0, r1, r0
; CHECK-THUMBV7M-NEXT:    movw r1, #63503
; CHECK-THUMBV7M-NEXT:    subs r0, r0, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i32 %a, -251
  %c = mul i32 %b, 253
  ret i32 %c
}

define i16 @fold_sub251_mul253_i16(i16 %a) {
; CHECK-ARMV6-LABEL: fold_sub251_mul253_i16:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mov r1, #241
; CHECK-ARMV6-NEXT:    mov r2, #253
; CHECK-ARMV6-NEXT:    orr r1, r1, #1792
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_sub251_mul253_i16:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    movw r1, #2033
; CHECK-ARMV7-NEXT:    mov r2, #253
; CHECK-ARMV7-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_sub251_mul253_i16:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #253
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI11_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI11_0:
; CHECK-THUMBV6M-NEXT:    .long 2033 @ 0x7f1
;
; CHECK-THUMBV7M-LABEL: fold_sub251_mul253_i16:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movs r1, #253
; CHECK-THUMBV7M-NEXT:    muls r0, r1, r0
; CHECK-THUMBV7M-NEXT:    addw r0, r0, #2033
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i16 %a, -251
  %c = mul i16 %b, 253
  ret i16 %c
}

define i32 @fold_add251_mul353_i32(i32 %a) {
; CHECK-ARMV6-LABEL: fold_add251_mul353_i32:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mov r2, #97
; CHECK-ARMV6-NEXT:    ldr r1, .LCPI12_0
; CHECK-ARMV6-NEXT:    orr r2, r2, #256
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
; CHECK-ARMV6-NEXT:    .p2align 2
; CHECK-ARMV6-NEXT:  @ %bb.1:
; CHECK-ARMV6-NEXT:  .LCPI12_0:
; CHECK-ARMV6-NEXT:    .long 88603 @ 0x15a1b
;
; CHECK-ARMV7-LABEL: fold_add251_mul353_i32:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    movw r1, #23067
; CHECK-ARMV7-NEXT:    movw r2, #353
; CHECK-ARMV7-NEXT:    movt r1, #1
; CHECK-ARMV7-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_add251_mul353_i32:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #255
; CHECK-THUMBV6M-NEXT:    adds r1, #98
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI12_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI12_0:
; CHECK-THUMBV6M-NEXT:    .long 88603 @ 0x15a1b
;
; CHECK-THUMBV7M-LABEL: fold_add251_mul353_i32:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movw r1, #23067
; CHECK-THUMBV7M-NEXT:    movw r2, #353
; CHECK-THUMBV7M-NEXT:    movt r1, #1
; CHECK-THUMBV7M-NEXT:    mla r0, r0, r2, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i32 %a, 251
  %c = mul i32 %b, 353
  ret i32 %c
}

define i16 @fold_add251_mul353_i16(i16 %a) {
; CHECK-ARMV6-LABEL: fold_add251_mul353_i16:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mov r2, #97
; CHECK-ARMV6-NEXT:    mov r1, #27
; CHECK-ARMV6-NEXT:    orr r2, r2, #256
; CHECK-ARMV6-NEXT:    orr r1, r1, #23040
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_add251_mul353_i16:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    movw r1, #23067
; CHECK-ARMV7-NEXT:    movw r2, #353
; CHECK-ARMV7-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_add251_mul353_i16:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #255
; CHECK-THUMBV6M-NEXT:    adds r1, #98
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI13_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI13_0:
; CHECK-THUMBV6M-NEXT:    .long 23067 @ 0x5a1b
;
; CHECK-THUMBV7M-LABEL: fold_add251_mul353_i16:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movw r1, #23067
; CHECK-THUMBV7M-NEXT:    movw r2, #353
; CHECK-THUMBV7M-NEXT:    mla r0, r0, r2, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i16 %a, 251
  %c = mul i16 %b, 353
  ret i16 %c
}

define i32 @fold_sub251_mul353_i32(i32 %a) {
; CHECK-ARMV6-LABEL: fold_sub251_mul353_i32:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mov r2, #97
; CHECK-ARMV6-NEXT:    ldr r1, .LCPI14_0
; CHECK-ARMV6-NEXT:    orr r2, r2, #256
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
; CHECK-ARMV6-NEXT:    .p2align 2
; CHECK-ARMV6-NEXT:  @ %bb.1:
; CHECK-ARMV6-NEXT:  .LCPI14_0:
; CHECK-ARMV6-NEXT:    .long 4294878693 @ 0xfffea5e5
;
; CHECK-ARMV7-LABEL: fold_sub251_mul353_i32:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    movw r1, #42469
; CHECK-ARMV7-NEXT:    movw r2, #353
; CHECK-ARMV7-NEXT:    movt r1, #65534
; CHECK-ARMV7-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_sub251_mul353_i32:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #255
; CHECK-THUMBV6M-NEXT:    adds r1, #98
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI14_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI14_0:
; CHECK-THUMBV6M-NEXT:    .long 4294878693 @ 0xfffea5e5
;
; CHECK-THUMBV7M-LABEL: fold_sub251_mul353_i32:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movw r1, #42469
; CHECK-THUMBV7M-NEXT:    movw r2, #353
; CHECK-THUMBV7M-NEXT:    movt r1, #65534
; CHECK-THUMBV7M-NEXT:    mla r0, r0, r2, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i32 %a, -251
  %c = mul i32 %b, 353
  ret i32 %c
}

define i16 @fold_sub251_mul353_i16(i16 %a) {
; CHECK-ARMV6-LABEL: fold_sub251_mul353_i16:
; CHECK-ARMV6:       @ %bb.0:
; CHECK-ARMV6-NEXT:    mov r2, #97
; CHECK-ARMV6-NEXT:    mvn r1, #26
; CHECK-ARMV6-NEXT:    orr r2, r2, #256
; CHECK-ARMV6-NEXT:    sub r1, r1, #23040
; CHECK-ARMV6-NEXT:    mla r0, r0, r2, r1
; CHECK-ARMV6-NEXT:    bx lr
;
; CHECK-ARMV7-LABEL: fold_sub251_mul353_i16:
; CHECK-ARMV7:       @ %bb.0:
; CHECK-ARMV7-NEXT:    movw r1, #353
; CHECK-ARMV7-NEXT:    mul r0, r0, r1
; CHECK-ARMV7-NEXT:    movw r1, #23067
; CHECK-ARMV7-NEXT:    sub r0, r0, r1
; CHECK-ARMV7-NEXT:    bx lr
;
; CHECK-THUMBV6M-LABEL: fold_sub251_mul353_i16:
; CHECK-THUMBV6M:       @ %bb.0:
; CHECK-THUMBV6M-NEXT:    movs r1, #255
; CHECK-THUMBV6M-NEXT:    adds r1, #98
; CHECK-THUMBV6M-NEXT:    muls r1, r0, r1
; CHECK-THUMBV6M-NEXT:    ldr r0, .LCPI15_0
; CHECK-THUMBV6M-NEXT:    adds r0, r1, r0
; CHECK-THUMBV6M-NEXT:    bx lr
; CHECK-THUMBV6M-NEXT:    .p2align 2
; CHECK-THUMBV6M-NEXT:  @ %bb.1:
; CHECK-THUMBV6M-NEXT:  .LCPI15_0:
; CHECK-THUMBV6M-NEXT:    .long 4294944229 @ 0xffffa5e5
;
; CHECK-THUMBV7M-LABEL: fold_sub251_mul353_i16:
; CHECK-THUMBV7M:       @ %bb.0:
; CHECK-THUMBV7M-NEXT:    movw r1, #353
; CHECK-THUMBV7M-NEXT:    muls r0, r1, r0
; CHECK-THUMBV7M-NEXT:    movw r1, #23067
; CHECK-THUMBV7M-NEXT:    subs r0, r0, r1
; CHECK-THUMBV7M-NEXT:    bx lr
  %b = add i16 %a, -251
  %c = mul i16 %b, 353
  ret i16 %c
}
