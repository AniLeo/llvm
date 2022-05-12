; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-- | FileCheck %s

declare { i128, i1 } @llvm.uadd.with.overflow.i128(i128, i128)
declare   i128       @llvm.uadd.sat.i128(i128, i128)

declare { i128, i1 } @llvm.usub.with.overflow.i128(i128, i128)
declare   i128       @llvm.usub.sat.i128(i128, i128)

declare { i128, i1 } @llvm.umul.with.overflow.i128(i128, i128)
declare   i128       @llvm.umul.sat.i128(i128, i128)

declare { i128, i1 } @llvm.sadd.with.overflow.i128(i128, i128)
declare   i128       @llvm.sadd.sat.i128(i128, i128)

declare { i128, i1 } @llvm.ssub.with.overflow.i128(i128, i128)
declare   i128       @llvm.ssub.sat.i128(i128, i128)

declare { i128, i1 } @llvm.smul.with.overflow.i128(i128, i128)
declare   i128       @llvm.smul.sat.i128(i128, i128)

define i128 @u128_add(i128 %x, i128 %y) {
; CHECK-LABEL: u128_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x0, x0, x2
; CHECK-NEXT:    adc x1, x1, x3
; CHECK-NEXT:    ret
  %1 = add i128 %x, %y
  ret i128 %1
}

define { i128, i8 } @u128_checked_add(i128 %x, i128 %y) {
; CHECK-LABEL: u128_checked_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x0, x0, x2
; CHECK-NEXT:    adcs x1, x1, x3
; CHECK-NEXT:    cset w8, hs
; CHECK-NEXT:    eor w2, w8, #0x1
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.uadd.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i8
  %6 = insertvalue { i128, i8 } undef, i128 %2, 0
  %7 = insertvalue { i128, i8 } %6, i8 %5, 1
  ret { i128, i8 } %7
}

define { i128, i8 } @u128_overflowing_add(i128 %x, i128 %y) {
; CHECK-LABEL: u128_overflowing_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x0, x0, x2
; CHECK-NEXT:    adcs x1, x1, x3
; CHECK-NEXT:    cset w2, hs
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.uadd.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = zext i1 %3 to i8
  %5 = insertvalue { i128, i8 } undef, i128 %2, 0
  %6 = insertvalue { i128, i8 } %5, i8 %4, 1
  ret { i128, i8 } %6
}

define i128 @u128_saturating_add(i128 %x, i128 %y) {
; CHECK-LABEL: u128_saturating_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x8, x0, x2
; CHECK-NEXT:    adcs x9, x1, x3
; CHECK-NEXT:    cset w10, hs
; CHECK-NEXT:    cmp w10, #0
; CHECK-NEXT:    csinv x0, x8, xzr, eq
; CHECK-NEXT:    csinv x1, x9, xzr, eq
; CHECK-NEXT:    ret
  %1 = tail call i128 @llvm.uadd.sat.i128(i128 %x, i128 %y)
  ret i128 %1
}

define i128 @u128_sub(i128 %x, i128 %y) {
; CHECK-LABEL: u128_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x0, x0, x2
; CHECK-NEXT:    sbc x1, x1, x3
; CHECK-NEXT:    ret
  %1 = sub i128 %x, %y
  ret i128 %1
}

define { i128, i8 } @u128_checked_sub(i128 %x, i128 %y) {
; CHECK-LABEL: u128_checked_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x0, x0, x2
; CHECK-NEXT:    sbcs x1, x1, x3
; CHECK-NEXT:    cset w8, lo
; CHECK-NEXT:    eor w2, w8, #0x1
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.usub.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i8
  %6 = insertvalue { i128, i8 } undef, i128 %2, 0
  %7 = insertvalue { i128, i8 } %6, i8 %5, 1
  ret { i128, i8 } %7
}

define { i128, i8 } @u128_overflowing_sub(i128 %x, i128 %y) {
; CHECK-LABEL: u128_overflowing_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x0, x0, x2
; CHECK-NEXT:    sbcs x1, x1, x3
; CHECK-NEXT:    cset w2, lo
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.usub.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = zext i1 %3 to i8
  %5 = insertvalue { i128, i8 } undef, i128 %2, 0
  %6 = insertvalue { i128, i8 } %5, i8 %4, 1
  ret { i128, i8 } %6
}

define i128 @u128_saturating_sub(i128 %x, i128 %y) {
; CHECK-LABEL: u128_saturating_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x8, x0, x2
; CHECK-NEXT:    sbcs x9, x1, x3
; CHECK-NEXT:    cset w10, lo
; CHECK-NEXT:    cmp w10, #0
; CHECK-NEXT:    csel x0, xzr, x8, ne
; CHECK-NEXT:    csel x1, xzr, x9, ne
; CHECK-NEXT:    ret
  %1 = tail call i128 @llvm.usub.sat.i128(i128 %x, i128 %y)
  ret i128 %1
}

define i128 @i128_add(i128 %x, i128 %y) {
; CHECK-LABEL: i128_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x0, x0, x2
; CHECK-NEXT:    adc x1, x1, x3
; CHECK-NEXT:    ret
  %1 = add i128 %x, %y
  ret i128 %1
}

define { i128, i8 } @i128_checked_add(i128 %x, i128 %y) {
; CHECK-LABEL: i128_checked_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x0, x0, x2
; CHECK-NEXT:    adcs x1, x1, x3
; CHECK-NEXT:    cset w8, vs
; CHECK-NEXT:    eor w2, w8, #0x1
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.sadd.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i8
  %6 = insertvalue { i128, i8 } undef, i128 %2, 0
  %7 = insertvalue { i128, i8 } %6, i8 %5, 1
  ret { i128, i8 } %7
}

define { i128, i8 } @i128_overflowing_add(i128 %x, i128 %y) {
; CHECK-LABEL: i128_overflowing_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x0, x0, x2
; CHECK-NEXT:    adcs x1, x1, x3
; CHECK-NEXT:    cset w2, vs
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.sadd.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = zext i1 %3 to i8
  %5 = insertvalue { i128, i8 } undef, i128 %2, 0
  %6 = insertvalue { i128, i8 } %5, i8 %4, 1
  ret { i128, i8 } %6
}

define i128 @i128_saturating_add(i128 %x, i128 %y) {
; CHECK-LABEL: i128_saturating_add:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adds x8, x0, x2
; CHECK-NEXT:    adcs x9, x1, x3
; CHECK-NEXT:    asr x10, x9, #63
; CHECK-NEXT:    cset w11, vs
; CHECK-NEXT:    cmp w11, #0
; CHECK-NEXT:    eor x11, x10, #0x8000000000000000
; CHECK-NEXT:    csel x0, x10, x8, ne
; CHECK-NEXT:    csel x1, x11, x9, ne
; CHECK-NEXT:    ret
  %1 = tail call i128 @llvm.sadd.sat.i128(i128 %x, i128 %y)
  ret i128 %1
}

define i128 @i128_sub(i128 %x, i128 %y) {
; CHECK-LABEL: i128_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x0, x0, x2
; CHECK-NEXT:    sbc x1, x1, x3
; CHECK-NEXT:    ret
  %1 = sub i128 %x, %y
  ret i128 %1
}

define { i128, i8 } @i128_checked_sub(i128 %x, i128 %y) {
; CHECK-LABEL: i128_checked_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x0, x0, x2
; CHECK-NEXT:    sbcs x1, x1, x3
; CHECK-NEXT:    cset w8, vs
; CHECK-NEXT:    eor w2, w8, #0x1
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.ssub.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i8
  %6 = insertvalue { i128, i8 } undef, i128 %2, 0
  %7 = insertvalue { i128, i8 } %6, i8 %5, 1
  ret { i128, i8 } %7
}

define { i128, i8 } @i128_overflowing_sub(i128 %x, i128 %y) {
; CHECK-LABEL: i128_overflowing_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x0, x0, x2
; CHECK-NEXT:    sbcs x1, x1, x3
; CHECK-NEXT:    cset w2, vs
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.ssub.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = zext i1 %3 to i8
  %5 = insertvalue { i128, i8 } undef, i128 %2, 0
  %6 = insertvalue { i128, i8 } %5, i8 %4, 1
  ret { i128, i8 } %6
}

define i128 @i128_saturating_sub(i128 %x, i128 %y) {
; CHECK-LABEL: i128_saturating_sub:
; CHECK:       // %bb.0:
; CHECK-NEXT:    subs x8, x0, x2
; CHECK-NEXT:    sbcs x9, x1, x3
; CHECK-NEXT:    asr x10, x9, #63
; CHECK-NEXT:    cset w11, vs
; CHECK-NEXT:    cmp w11, #0
; CHECK-NEXT:    eor x11, x10, #0x8000000000000000
; CHECK-NEXT:    csel x0, x10, x8, ne
; CHECK-NEXT:    csel x1, x11, x9, ne
; CHECK-NEXT:    ret
  %1 = tail call i128 @llvm.ssub.sat.i128(i128 %x, i128 %y)
  ret i128 %1
}

define i128 @u128_mul(i128 %x, i128 %y) {
; CHECK-LABEL: u128_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umulh x8, x0, x2
; CHECK-NEXT:    madd x8, x0, x3, x8
; CHECK-NEXT:    mul x0, x0, x2
; CHECK-NEXT:    madd x1, x1, x2, x8
; CHECK-NEXT:    ret
  %1 = mul i128 %x, %y
  ret i128 %1
}

define { i128, i8 } @u128_checked_mul(i128 %x, i128 %y) {
; CHECK-LABEL: u128_checked_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mul x8, x3, x0
; CHECK-NEXT:    umulh x9, x0, x2
; CHECK-NEXT:    madd x8, x1, x2, x8
; CHECK-NEXT:    umulh x10, x1, x2
; CHECK-NEXT:    adds x8, x9, x8
; CHECK-NEXT:    cset w9, hs
; CHECK-NEXT:    cmp x1, #0
; CHECK-NEXT:    ccmp x3, #0, #4, ne
; CHECK-NEXT:    mov x1, x8
; CHECK-NEXT:    ccmp xzr, x10, #0, eq
; CHECK-NEXT:    umulh x10, x3, x0
; CHECK-NEXT:    mul x0, x0, x2
; CHECK-NEXT:    ccmp xzr, x10, #0, eq
; CHECK-NEXT:    cset w10, ne
; CHECK-NEXT:    orr w9, w10, w9
; CHECK-NEXT:    eor w2, w9, #0x1
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.umul.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i8
  %6 = insertvalue { i128, i8 } undef, i128 %2, 0
  %7 = insertvalue { i128, i8 } %6, i8 %5, 1
  ret { i128, i8 } %7
}

define { i128, i8 } @u128_overflowing_mul(i128 %x, i128 %y) {
; CHECK-LABEL: u128_overflowing_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mul x8, x3, x0
; CHECK-NEXT:    umulh x9, x0, x2
; CHECK-NEXT:    madd x8, x1, x2, x8
; CHECK-NEXT:    umulh x10, x1, x2
; CHECK-NEXT:    adds x8, x9, x8
; CHECK-NEXT:    cset w9, hs
; CHECK-NEXT:    cmp x1, #0
; CHECK-NEXT:    ccmp x3, #0, #4, ne
; CHECK-NEXT:    mov x1, x8
; CHECK-NEXT:    ccmp xzr, x10, #0, eq
; CHECK-NEXT:    umulh x10, x3, x0
; CHECK-NEXT:    mul x0, x0, x2
; CHECK-NEXT:    ccmp xzr, x10, #0, eq
; CHECK-NEXT:    cset w10, ne
; CHECK-NEXT:    orr w2, w10, w9
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.umul.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = zext i1 %3 to i8
  %5 = insertvalue { i128, i8 } undef, i128 %2, 0
  %6 = insertvalue { i128, i8 } %5, i8 %4, 1
  ret { i128, i8 } %6
}

define i128 @u128_saturating_mul(i128 %x, i128 %y) {
; CHECK-LABEL: u128_saturating_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mul x8, x3, x0
; CHECK-NEXT:    umulh x9, x0, x2
; CHECK-NEXT:    madd x8, x1, x2, x8
; CHECK-NEXT:    umulh x10, x1, x2
; CHECK-NEXT:    adds x8, x9, x8
; CHECK-NEXT:    cset w9, hs
; CHECK-NEXT:    cmp x1, #0
; CHECK-NEXT:    ccmp x3, #0, #4, ne
; CHECK-NEXT:    ccmp xzr, x10, #0, eq
; CHECK-NEXT:    umulh x10, x3, x0
; CHECK-NEXT:    ccmp xzr, x10, #0, eq
; CHECK-NEXT:    cset w10, ne
; CHECK-NEXT:    orr w9, w10, w9
; CHECK-NEXT:    mul x10, x0, x2
; CHECK-NEXT:    cmp w9, #0
; CHECK-NEXT:    csinv x0, x10, xzr, eq
; CHECK-NEXT:    csinv x1, x8, xzr, eq
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.umul.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = select i1 %3, i128 -1, i128 %2
  ret i128 %4
}

define i128 @i128_mul(i128 %x, i128 %y) {
; CHECK-LABEL: i128_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    umulh x8, x0, x2
; CHECK-NEXT:    madd x8, x0, x3, x8
; CHECK-NEXT:    mul x0, x0, x2
; CHECK-NEXT:    madd x1, x1, x2, x8
; CHECK-NEXT:    ret
  %1 = mul i128 %x, %y
  ret i128 %1
}

define { i128, i8 } @i128_checked_mul(i128 %x, i128 %y) {
; CHECK-LABEL: i128_checked_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x30, xzr, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    add x4, sp, #8
; CHECK-NEXT:    bl __muloti4
; CHECK-NEXT:    ldr x8, [sp, #8]
; CHECK-NEXT:    cmp x8, #0
; CHECK-NEXT:    cset w2, eq
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.smul.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = xor i1 %3, true
  %5 = zext i1 %4 to i8
  %6 = insertvalue { i128, i8 } undef, i128 %2, 0
  %7 = insertvalue { i128, i8 } %6, i8 %5, 1
  ret { i128, i8 } %7
}

define { i128, i8 } @i128_overflowing_mul(i128 %x, i128 %y) {
; CHECK-LABEL: i128_overflowing_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x30, xzr, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    add x4, sp, #8
; CHECK-NEXT:    bl __muloti4
; CHECK-NEXT:    ldr x8, [sp, #8]
; CHECK-NEXT:    cmp x8, #0
; CHECK-NEXT:    cset w2, ne
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.smul.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = zext i1 %3 to i8
  %5 = insertvalue { i128, i8 } undef, i128 %2, 0
  %6 = insertvalue { i128, i8 } %5, i8 %4, 1
  ret { i128, i8 } %6
}

define i128 @i128_saturating_mul(i128 %x, i128 %y) {
; CHECK-LABEL: i128_saturating_mul:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-32]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    stp x20, x19, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w20, -16
; CHECK-NEXT:    .cfi_offset w30, -32
; CHECK-NEXT:    add x4, sp, #8
; CHECK-NEXT:    mov x19, x3
; CHECK-NEXT:    mov x20, x1
; CHECK-NEXT:    str xzr, [sp, #8]
; CHECK-NEXT:    bl __muloti4
; CHECK-NEXT:    ldr x8, [sp, #8]
; CHECK-NEXT:    eor x9, x19, x20
; CHECK-NEXT:    ldp x20, x19, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    asr x9, x9, #63
; CHECK-NEXT:    eor x10, x9, #0x7fffffffffffffff
; CHECK-NEXT:    cmp x8, #0
; CHECK-NEXT:    csinv x0, x0, x9, eq
; CHECK-NEXT:    csel x1, x10, x1, ne
; CHECK-NEXT:    ldr x30, [sp], #32 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %1 = tail call { i128, i1 } @llvm.smul.with.overflow.i128(i128 %x, i128 %y)
  %2 = extractvalue { i128, i1 } %1, 0
  %3 = extractvalue { i128, i1 } %1, 1
  %4 = xor i128 %y, %x
  %5 = icmp sgt i128 %4, -1
  %6 = select i1 %5, i128 170141183460469231731687303715884105727, i128 -170141183460469231731687303715884105728
  %7 = select i1 %3, i128 %6, i128 %2
  ret i128 %7
}
