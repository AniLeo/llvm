; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

define i32 @fold_srem_positive_odd(i32 %x) {
; CHECK-LABEL: fold_srem_positive_odd:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #37253
; CHECK-NEXT:    movk w8, #44150, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x8, x8, #32
; CHECK-NEXT:    add w8, w8, w0
; CHECK-NEXT:    asr w9, w8, #6
; CHECK-NEXT:    add w8, w9, w8, lsr #31
; CHECK-NEXT:    mov w9, #95
; CHECK-NEXT:    msub w0, w8, w9, w0
; CHECK-NEXT:    ret
  %1 = srem i32 %x, 95
  ret i32 %1
}


define i32 @fold_srem_positive_even(i32 %x) {
; CHECK-LABEL: fold_srem_positive_even:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #36849
; CHECK-NEXT:    movk w8, #15827, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #40
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    mov w9, #1060
; CHECK-NEXT:    msub w0, w8, w9, w0
; CHECK-NEXT:    ret
  %1 = srem i32 %x, 1060
  ret i32 %1
}


define i32 @fold_srem_negative_odd(i32 %x) {
; CHECK-LABEL: fold_srem_negative_odd:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #65445
; CHECK-NEXT:    movk w8, #42330, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #40
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    mov w9, #-723
; CHECK-NEXT:    msub w0, w8, w9, w0
; CHECK-NEXT:    ret
  %1 = srem i32 %x, -723
  ret i32 %1
}


define i32 @fold_srem_negative_even(i32 %x) {
; CHECK-LABEL: fold_srem_negative_even:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #62439
; CHECK-NEXT:    movk w8, #64805, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x9, x8, #63
; CHECK-NEXT:    asr x8, x8, #40
; CHECK-NEXT:    add w8, w8, w9
; CHECK-NEXT:    mov w9, #-22981
; CHECK-NEXT:    msub w0, w8, w9, w0
; CHECK-NEXT:    ret
  %1 = srem i32 %x, -22981
  ret i32 %1
}


; Don't fold if we can combine srem with sdiv.
define i32 @combine_srem_sdiv(i32 %x) {
; CHECK-LABEL: combine_srem_sdiv:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #37253
; CHECK-NEXT:    movk w8, #44150, lsl #16
; CHECK-NEXT:    smull x8, w0, w8
; CHECK-NEXT:    lsr x8, x8, #32
; CHECK-NEXT:    add w8, w8, w0
; CHECK-NEXT:    asr w9, w8, #6
; CHECK-NEXT:    add w8, w9, w8, lsr #31
; CHECK-NEXT:    mov w9, #95
; CHECK-NEXT:    msub w9, w8, w9, w0
; CHECK-NEXT:    add w0, w9, w8
; CHECK-NEXT:    ret
  %1 = srem i32 %x, 95
  %2 = sdiv i32 %x, 95
  %3 = add i32 %1, %2
  ret i32 %3
}

; Don't fold for divisors that are a power of two.
define i32 @dont_fold_srem_power_of_two(i32 %x) {
; CHECK-LABEL: dont_fold_srem_power_of_two:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #63 // =63
; CHECK-NEXT:    cmp w0, #0 // =0
; CHECK-NEXT:    csel w8, w8, w0, lt
; CHECK-NEXT:    and w8, w8, #0xffffffc0
; CHECK-NEXT:    sub w0, w0, w8
; CHECK-NEXT:    ret
  %1 = srem i32 %x, 64
  ret i32 %1
}

; Don't fold if the divisor is one.
define i32 @dont_fold_srem_one(i32 %x) {
; CHECK-LABEL: dont_fold_srem_one:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    ret
  %1 = srem i32 %x, 1
  ret i32 %1
}

; Don't fold if the divisor is 2^31.
define i32 @dont_fold_srem_i32_smax(i32 %x) {
; CHECK-LABEL: dont_fold_srem_i32_smax:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #2147483647
; CHECK-NEXT:    add w8, w0, w8
; CHECK-NEXT:    cmp w0, #0 // =0
; CHECK-NEXT:    csel w8, w8, w0, lt
; CHECK-NEXT:    and w8, w8, #0x80000000
; CHECK-NEXT:    add w0, w0, w8
; CHECK-NEXT:    ret
  %1 = srem i32 %x, 2147483648
  ret i32 %1
}

; Don't fold i64 srem
define i64 @dont_fold_srem_i64(i64 %x) {
; CHECK-LABEL: dont_fold_srem_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #58849
; CHECK-NEXT:    movk x8, #48148, lsl #16
; CHECK-NEXT:    movk x8, #33436, lsl #32
; CHECK-NEXT:    movk x8, #21399, lsl #48
; CHECK-NEXT:    smulh x8, x0, x8
; CHECK-NEXT:    asr x9, x8, #5
; CHECK-NEXT:    add x8, x9, x8, lsr #63
; CHECK-NEXT:    mov w9, #98
; CHECK-NEXT:    msub x0, x8, x9, x0
; CHECK-NEXT:    ret
  %1 = srem i64 %x, 98
  ret i64 %1
}
