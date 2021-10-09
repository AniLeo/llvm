; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-unknown < %s | FileCheck %s --check-prefix=CHECK

; We are looking for the following pattern here:
;   (X & (C l>> Y)) ==/!= 0
; It may be optimal to hoist the constant:
;   ((X << Y) & C) ==/!= 0

;------------------------------------------------------------------------------;
; A few scalar test
;------------------------------------------------------------------------------;

; i8 scalar

define i1 @scalar_i8_signbit_eq(i8 %x, i8 %y) nounwind {
; CHECK-LABEL: scalar_i8_signbit_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    tst w8, #0x80
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i8 128, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_lowestbit_eq(i8 %x, i8 %y) nounwind {
; CHECK-LABEL: scalar_i8_lowestbit_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i8 1, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_bitsinmiddle_eq(i8 %x, i8 %y) nounwind {
; CHECK-LABEL: scalar_i8_bitsinmiddle_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    tst w8, #0x18
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i8 24, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 0
  ret i1 %res
}

; i16 scalar

define i1 @scalar_i16_signbit_eq(i16 %x, i16 %y) nounwind {
; CHECK-LABEL: scalar_i16_signbit_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    tst w8, #0x8000
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i16 32768, %y
  %t1 = and i16 %t0, %x
  %res = icmp eq i16 %t1, 0
  ret i1 %res
}

define i1 @scalar_i16_lowestbit_eq(i16 %x, i16 %y) nounwind {
; CHECK-LABEL: scalar_i16_lowestbit_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i16 1, %y
  %t1 = and i16 %t0, %x
  %res = icmp eq i16 %t1, 0
  ret i1 %res
}

define i1 @scalar_i16_bitsinmiddle_eq(i16 %x, i16 %y) nounwind {
; CHECK-LABEL: scalar_i16_bitsinmiddle_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    tst w8, #0xff0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i16 4080, %y
  %t1 = and i16 %t0, %x
  %res = icmp eq i16 %t1, 0
  ret i1 %res
}

; i32 scalar

define i1 @scalar_i32_signbit_eq(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: scalar_i32_signbit_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    tst w8, #0x80000000
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i32 2147483648, %y
  %t1 = and i32 %t0, %x
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

define i1 @scalar_i32_lowestbit_eq(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: scalar_i32_lowestbit_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i32 1, %y
  %t1 = and i32 %t0, %x
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

define i1 @scalar_i32_bitsinmiddle_eq(i32 %x, i32 %y) nounwind {
; CHECK-LABEL: scalar_i32_bitsinmiddle_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    tst w8, #0xffff00
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i32 16776960, %y
  %t1 = and i32 %t0, %x
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

; i64 scalar

define i1 @scalar_i64_signbit_eq(i64 %x, i64 %y) nounwind {
; CHECK-LABEL: scalar_i64_signbit_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl x8, x0, x1
; CHECK-NEXT:    tst x8, #0x8000000000000000
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i64 9223372036854775808, %y
  %t1 = and i64 %t0, %x
  %res = icmp eq i64 %t1, 0
  ret i1 %res
}

define i1 @scalar_i64_lowestbit_eq(i64 %x, i64 %y) nounwind {
; CHECK-LABEL: scalar_i64_lowestbit_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl x8, x0, x1
; CHECK-NEXT:    tst x8, #0x1
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i64 1, %y
  %t1 = and i64 %t0, %x
  %res = icmp eq i64 %t1, 0
  ret i1 %res
}

define i1 @scalar_i64_bitsinmiddle_eq(i64 %x, i64 %y) nounwind {
; CHECK-LABEL: scalar_i64_bitsinmiddle_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl x8, x0, x1
; CHECK-NEXT:    tst x8, #0xffffffff0000
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i64 281474976645120, %y
  %t1 = and i64 %t0, %x
  %res = icmp eq i64 %t1, 0
  ret i1 %res
}

;------------------------------------------------------------------------------;
; A few trivial vector tests
;------------------------------------------------------------------------------;

define <4 x i1> @vec_4xi32_splat_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: vec_4xi32_splat_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v2.4s, #1
; CHECK-NEXT:    ushl v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    and v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %t0 = lshr <4 x i32> <i32 1, i32 1, i32 1, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %res
}

define <4 x i1> @vec_4xi32_nonsplat_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: vec_4xi32_nonsplat_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, .LCPI13_0
; CHECK-NEXT:    neg v1.4s, v1.4s
; CHECK-NEXT:    ldr q2, [x8, :lo12:.LCPI13_0]
; CHECK-NEXT:    ushl v1.4s, v2.4s, v1.4s
; CHECK-NEXT:    and v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %t0 = lshr <4 x i32> <i32 0, i32 1, i32 16776960, i32 2147483648>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %res
}

define <4 x i1> @vec_4xi32_nonsplat_undef0_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: vec_4xi32_nonsplat_undef0_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v2.4s, #1
; CHECK-NEXT:    ushl v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    and v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %t0 = lshr <4 x i32> <i32 1, i32 1, i32 undef, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 0, i32 0>
  ret <4 x i1> %res
}
define <4 x i1> @vec_4xi32_nonsplat_undef1_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: vec_4xi32_nonsplat_undef1_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v2.4s, #1
; CHECK-NEXT:    neg v1.4s, v1.4s
; CHECK-NEXT:    ushl v1.4s, v2.4s, v1.4s
; CHECK-NEXT:    and v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %t0 = lshr <4 x i32> <i32 1, i32 1, i32 1, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 undef, i32 0>
  ret <4 x i1> %res
}
define <4 x i1> @vec_4xi32_nonsplat_undef2_eq(<4 x i32> %x, <4 x i32> %y) nounwind {
; CHECK-LABEL: vec_4xi32_nonsplat_undef2_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    movi v2.4s, #1
; CHECK-NEXT:    neg v1.4s, v1.4s
; CHECK-NEXT:    ushl v1.4s, v2.4s, v1.4s
; CHECK-NEXT:    and v0.16b, v1.16b, v0.16b
; CHECK-NEXT:    cmeq v0.4s, v0.4s, #0
; CHECK-NEXT:    xtn v0.4h, v0.4s
; CHECK-NEXT:    ret
  %t0 = lshr <4 x i32> <i32 1, i32 1, i32 undef, i32 1>, %y
  %t1 = and <4 x i32> %t0, %x
  %res = icmp eq <4 x i32> %t1, <i32 0, i32 0, i32 undef, i32 0>
  ret <4 x i1> %res
}

;------------------------------------------------------------------------------;
; A special tests
;------------------------------------------------------------------------------;

define i1 @scalar_i8_signbit_ne(i8 %x, i8 %y) nounwind {
; CHECK-LABEL: scalar_i8_signbit_ne:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsl w8, w0, w1
; CHECK-NEXT:    ubfx w0, w8, #7, #1
; CHECK-NEXT:    ret
  %t0 = lshr i8 128, %y
  %t1 = and i8 %t0, %x
  %res = icmp ne i8 %t1, 0 ;  we are perfectly happy with 'ne' predicate
  ret i1 %res
}

;------------------------------------------------------------------------------;
; What if X is a constant too?
;------------------------------------------------------------------------------;

define i1 @scalar_i32_x_is_const_eq(i32 %y) nounwind {
; CHECK-LABEL: scalar_i32_x_is_const_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #43605
; CHECK-NEXT:    movk w8, #43605, lsl #16
; CHECK-NEXT:    lsr w8, w8, w0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i32 2857740885, %y
  %t1 = and i32 %t0, 1
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}
define i1 @scalar_i32_x_is_const2_eq(i32 %y) nounwind {
; CHECK-LABEL: scalar_i32_x_is_const2_eq:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #1
; CHECK-NEXT:    lsr w8, w8, w0
; CHECK-NEXT:    cmp w8, #0
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i32 1, %y
  %t1 = and i32 %t0, 2857740885
  %res = icmp eq i32 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_bitsinmiddle_slt(i8 %x, i8 %y) nounwind {
; CHECK-LABEL: scalar_i8_bitsinmiddle_slt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    ret
  %t0 = lshr i8 24, %y
  %t1 = and i8 %t0, %x
  %res = icmp slt i8 %t1, 0
  ret i1 %res
}

define i1 @scalar_i8_signbit_eq_with_nonzero(i8 %x, i8 %y) nounwind {
; CHECK-LABEL: scalar_i8_signbit_eq_with_nonzero:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #128
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsr w8, w8, w1
; CHECK-NEXT:    and w8, w8, w0
; CHECK-NEXT:    cmp w8, #1
; CHECK-NEXT:    cset w0, eq
; CHECK-NEXT:    ret
  %t0 = lshr i8 128, %y
  %t1 = and i8 %t0, %x
  %res = icmp eq i8 %t1, 1 ; should be comparing with 0
  ret i1 %res
}
