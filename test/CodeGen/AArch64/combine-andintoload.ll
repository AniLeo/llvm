; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-eabi -o - | FileCheck %s
; RUN: llc < %s -mtriple=aarch64_be-none-eabi -o - | FileCheck %s --check-prefix=CHECKBE

define i64 @load32_and16_and(i32* %p, i64 %y) {
; CHECK-LABEL: load32_and16_and:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrh w8, [x0]
; CHECK-NEXT:    and w0, w1, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load32_and16_and:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrh w8, [x0, #2]
; CHECKBE-NEXT:    and w0, w1, w8
; CHECKBE-NEXT:    ret
  %x = load i32, i32* %p, align 4
  %xz = zext i32 %x to i64
  %ym = and i64 %y, 65535
  %r = and i64 %ym, %xz
  ret i64 %r
}

define i64 @load32_and16_andr(i32* %p, i64 %y) {
; CHECK-LABEL: load32_and16_andr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrh w8, [x0]
; CHECK-NEXT:    and w0, w1, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load32_and16_andr:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrh w8, [x0, #2]
; CHECKBE-NEXT:    and w0, w1, w8
; CHECKBE-NEXT:    ret
  %x = load i32, i32* %p, align 4
  %xz = zext i32 %x to i64
  %a = and i64 %y, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load32_and16_and_sext(i32* %p, i64 %y) {
; CHECK-LABEL: load32_and16_and_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrh w8, [x0]
; CHECK-NEXT:    and w0, w1, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load32_and16_and_sext:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrh w8, [x0, #2]
; CHECKBE-NEXT:    and w0, w1, w8
; CHECKBE-NEXT:    ret
  %x = load i32, i32* %p, align 4
  %xz = sext i32 %x to i64
  %a = and i64 %y, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load32_and16_or(i32* %p, i64 %y) {
; CHECK-LABEL: load32_and16_or:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrh w8, [x0]
; CHECK-NEXT:    and w9, w1, #0xffff
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load32_and16_or:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrh w8, [x0, #2]
; CHECKBE-NEXT:    and w9, w1, #0xffff
; CHECKBE-NEXT:    orr w0, w9, w8
; CHECKBE-NEXT:    ret
  %x = load i32, i32* %p, align 4
  %xz = zext i32 %x to i64
  %a = or i64 %y, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load32_and16_orr(i32* %p, i64 %y) {
; CHECK-LABEL: load32_and16_orr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    and x9, x1, #0xffff
; CHECK-NEXT:    orr x0, x9, x8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load32_and16_orr:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldr w8, [x0]
; CHECKBE-NEXT:    and x9, x1, #0xffff
; CHECKBE-NEXT:    orr x0, x9, x8
; CHECKBE-NEXT:    ret
  %x = load i32, i32* %p, align 4
  %xz = zext i32 %x to i64
  %ym = and i64 %y, 65535
  %r = or i64 %ym, %xz
  ret i64 %r
}

define i64 @load32_and16_xorm1(i32* %p) {
; CHECK-LABEL: load32_and16_xorm1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    mvn w8, w8
; CHECK-NEXT:    and x0, x8, #0xffff
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load32_and16_xorm1:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldr w8, [x0]
; CHECKBE-NEXT:    mvn w8, w8
; CHECKBE-NEXT:    and x0, x8, #0xffff
; CHECKBE-NEXT:    ret
  %x = load i32, i32* %p, align 4
  %xz = zext i32 %x to i64
  %a = xor i64 %xz, -1
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load64_and16(i64* %p, i128 %y) {
; CHECK-LABEL: load64_and16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrh w8, [x0]
; CHECK-NEXT:    and x0, x2, x8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load64_and16:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrh w8, [x0, #6]
; CHECKBE-NEXT:    and x0, x3, x8
; CHECKBE-NEXT:    ret
  %x = load i64, i64* %p, align 4
  %xz = zext i64 %x to i128
  %a = and i128 %y, %xz
  %t = trunc i128 %a to i64
  %r = and i64 %t, 65535
  ret i64 %r
}

define i64 @load16_and16(i16* %p, i64 %y) {
; CHECK-LABEL: load16_and16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrh w8, [x0]
; CHECK-NEXT:    and x0, x1, x8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load16_and16:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrh w8, [x0]
; CHECKBE-NEXT:    and x0, x1, x8
; CHECKBE-NEXT:    ret
  %x = load i16, i16* %p, align 4
  %xz = zext i16 %x to i64
  %a = and i64 %y, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load16_and8(i16* %p, i64 %y) {
; CHECK-LABEL: load16_and8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrb w8, [x0]
; CHECK-NEXT:    and w0, w1, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load16_and8:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrb w8, [x0, #1]
; CHECKBE-NEXT:    and w0, w1, w8
; CHECKBE-NEXT:    ret
  %x = load i16, i16* %p, align 4
  %xz = zext i16 %x to i64
  %a = and i64 %y, %xz
  %r = and i64 %a, 255
  ret i64 %r
}

define i64 @load16_and7(i16* %p, i64 %y) {
; CHECK-LABEL: load16_and7:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrh w8, [x0]
; CHECK-NEXT:    and w8, w1, w8
; CHECK-NEXT:    and x0, x8, #0x7f
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load16_and7:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrh w8, [x0]
; CHECKBE-NEXT:    and w8, w1, w8
; CHECKBE-NEXT:    and x0, x8, #0x7f
; CHECKBE-NEXT:    ret
  %x = load i16, i16* %p, align 4
  %xz = zext i16 %x to i64
  %a = and i64 %y, %xz
  %r = and i64 %a, 127
  ret i64 %r
}

define i64 @load8_and16(i8* %p, i64 %y) {
; CHECK-LABEL: load8_and16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrb w8, [x0]
; CHECK-NEXT:    and x0, x1, x8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load8_and16:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrb w8, [x0]
; CHECKBE-NEXT:    and x0, x1, x8
; CHECKBE-NEXT:    ret
  %x = load i8, i8* %p, align 4
  %xz = zext i8 %x to i64
  %a = and i64 %y, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load8_and16_zext(i8* %p, i8 %y) {
; CHECK-LABEL: load8_and16_zext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrb w8, [x0]
; CHECK-NEXT:    and w0, w1, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load8_and16_zext:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrb w8, [x0]
; CHECKBE-NEXT:    and w0, w1, w8
; CHECKBE-NEXT:    ret
  %x = load i8, i8* %p, align 4
  %xz = zext i8 %x to i64
  %yz = zext i8 %y to i64
  %a = and i64 %yz, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load8_and16_sext(i8* %p, i8 %y) {
; CHECK-LABEL: load8_and16_sext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrb w8, [x0]
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    and x0, x1, x8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load8_and16_sext:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrb w8, [x0]
; CHECKBE-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECKBE-NEXT:    and x0, x1, x8
; CHECKBE-NEXT:    ret
  %x = load i8, i8* %p, align 4
  %xz = zext i8 %x to i64
  %yz = sext i8 %y to i64
  %a = and i64 %yz, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load8_and16_or(i8* %p, i64 %y) {
; CHECK-LABEL: load8_and16_or:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrb w8, [x0]
; CHECK-NEXT:    orr w8, w1, w8
; CHECK-NEXT:    and x0, x8, #0xffff
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load8_and16_or:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrb w8, [x0]
; CHECKBE-NEXT:    orr w8, w1, w8
; CHECKBE-NEXT:    and x0, x8, #0xffff
; CHECKBE-NEXT:    ret
  %x = load i8, i8* %p, align 4
  %xz = zext i8 %x to i64
  %a = or i64 %y, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load16_and8_manyext(i16* %p, i32 %y) {
; CHECK-LABEL: load16_and8_manyext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrb w8, [x0]
; CHECK-NEXT:    and w0, w1, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load16_and8_manyext:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrb w8, [x0, #1]
; CHECKBE-NEXT:    and w0, w1, w8
; CHECKBE-NEXT:    ret
  %x = load i16, i16* %p, align 4
  %xz = zext i16 %x to i32
  %a = and i32 %y, %xz
  %az = zext i32 %a to i64
  %r = and i64 %az, 255
  ret i64 %r
}

define i64 @multiple_load(i16* %p, i32* %q) {
; CHECK-LABEL: multiple_load:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrb w8, [x0]
; CHECK-NEXT:    ldrb w9, [x1]
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: multiple_load:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrb w8, [x0, #1]
; CHECKBE-NEXT:    ldrb w9, [x1, #3]
; CHECKBE-NEXT:    and w0, w9, w8
; CHECKBE-NEXT:    ret
  %x = load i16, i16* %p, align 4
  %xz = zext i16 %x to i64
  %y = load i32, i32* %q, align 4
  %yz = zext i32 %y to i64
  %a = and i64 %yz, %xz
  %r = and i64 %a, 255
  ret i64 %r
}

define i64 @multiple_load_or(i16* %p, i32* %q) {
; CHECK-LABEL: multiple_load_or:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrb w8, [x0]
; CHECK-NEXT:    ldrb w9, [x1]
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: multiple_load_or:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrb w8, [x0, #1]
; CHECKBE-NEXT:    ldrb w9, [x1, #3]
; CHECKBE-NEXT:    orr w0, w9, w8
; CHECKBE-NEXT:    ret
  %x = load i16, i16* %p, align 4
  %xz = zext i16 %x to i64
  %y = load i32, i32* %q, align 4
  %yz = zext i32 %y to i64
  %a = or i64 %yz, %xz
  %r = and i64 %a, 255
  ret i64 %r
}

define i64 @load32_and16_zexty(i32* %p, i32 %y) {
; CHECK-LABEL: load32_and16_zexty:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrh w8, [x0]
; CHECK-NEXT:    and w9, w1, #0xffff
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load32_and16_zexty:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrh w8, [x0, #2]
; CHECKBE-NEXT:    and w9, w1, #0xffff
; CHECKBE-NEXT:    orr w0, w9, w8
; CHECKBE-NEXT:    ret
  %x = load i32, i32* %p, align 4
  %xz = zext i32 %x to i64
  %yz = zext i32 %y to i64
  %a = or i64 %yz, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}

define i64 @load32_and16_sexty(i32* %p, i32 %y) {
; CHECK-LABEL: load32_and16_sexty:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldrh w8, [x0]
; CHECK-NEXT:    and w9, w1, #0xffff
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
;
; CHECKBE-LABEL: load32_and16_sexty:
; CHECKBE:       // %bb.0:
; CHECKBE-NEXT:    ldrh w8, [x0, #2]
; CHECKBE-NEXT:    and w9, w1, #0xffff
; CHECKBE-NEXT:    orr w0, w9, w8
; CHECKBE-NEXT:    ret
  %x = load i32, i32* %p, align 4
  %xz = zext i32 %x to i64
  %yz = sext i32 %y to i64
  %a = or i64 %yz, %xz
  %r = and i64 %a, 65535
  ret i64 %r
}
