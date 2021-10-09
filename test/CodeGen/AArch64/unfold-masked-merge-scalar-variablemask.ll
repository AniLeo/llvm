; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=37104

define i8 @out8(i8 %x, i8 %y, i8 %mask) {
; CHECK-LABEL: out8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w1, w2
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %mx = and i8 %x, %mask
  %notmask = xor i8 %mask, -1
  %my = and i8 %y, %notmask
  %r = or i8 %mx, %my
  ret i8 %r
}

define i16 @out16(i16 %x, i16 %y, i16 %mask) {
; CHECK-LABEL: out16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w1, w2
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %mx = and i16 %x, %mask
  %notmask = xor i16 %mask, -1
  %my = and i16 %y, %notmask
  %r = or i16 %mx, %my
  ret i16 %r
}

define i32 @out32(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: out32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w1, w2
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %mx = and i32 %x, %mask
  %notmask = xor i32 %mask, -1
  %my = and i32 %y, %notmask
  %r = or i32 %mx, %my
  ret i32 %r
}

define i64 @out64(i64 %x, i64 %y, i64 %mask) {
; CHECK-LABEL: out64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic x8, x1, x2
; CHECK-NEXT:    and x9, x0, x2
; CHECK-NEXT:    orr x0, x9, x8
; CHECK-NEXT:    ret
  %mx = and i64 %x, %mask
  %notmask = xor i64 %mask, -1
  %my = and i64 %y, %notmask
  %r = or i64 %mx, %my
  ret i64 %r
}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Should be the same as the previous one.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

define i8 @in8(i8 %x, i8 %y, i8 %mask) {
; CHECK-LABEL: in8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w1, w2
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %n0 = xor i8 %x, %y
  %n1 = and i8 %n0, %mask
  %r = xor i8 %n1, %y
  ret i8 %r
}

define i16 @in16(i16 %x, i16 %y, i16 %mask) {
; CHECK-LABEL: in16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w1, w2
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %n0 = xor i16 %x, %y
  %n1 = and i16 %n0, %mask
  %r = xor i16 %n1, %y
  ret i16 %r
}

define i32 @in32(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w1, w2
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}

define i64 @in64(i64 %x, i64 %y, i64 %mask) {
; CHECK-LABEL: in64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic x8, x1, x2
; CHECK-NEXT:    and x9, x0, x2
; CHECK-NEXT:    orr x0, x9, x8
; CHECK-NEXT:    ret
  %n0 = xor i64 %x, %y
  %n1 = and i64 %n0, %mask
  %r = xor i64 %n1, %y
  ret i64 %r
}
; ============================================================================ ;
; Commutativity tests.
; ============================================================================ ;
define i32 @in_commutativity_0_0_1(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_commutativity_0_0_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w1, w2
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0 ; swapped
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_commutativity_0_1_0(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_commutativity_0_1_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w1, w2
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %y, %n1 ; swapped
  ret i32 %r
}
define i32 @in_commutativity_0_1_1(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_commutativity_0_1_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w1, w2
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0 ; swapped
  %r = xor i32 %y, %n1 ; swapped
  ret i32 %r
}
define i32 @in_commutativity_1_0_0(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_commutativity_1_0_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    bic w9, w0, w2
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %x ; %x instead of %y
  ret i32 %r
}
define i32 @in_commutativity_1_0_1(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_commutativity_1_0_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    bic w9, w0, w2
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0 ; swapped
  %r = xor i32 %n1, %x ; %x instead of %y
  ret i32 %r
}
define i32 @in_commutativity_1_1_0(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_commutativity_1_1_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    bic w9, w0, w2
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %x, %n1 ; swapped, %x instead of %y
  ret i32 %r
}
define i32 @in_commutativity_1_1_1(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_commutativity_1_1_1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    bic w9, w0, w2
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0 ; swapped
  %r = xor i32 %x, %n1 ; swapped, %x instead of %y
  ret i32 %r
}
; ============================================================================ ;
; Y is an 'and' too.
; ============================================================================ ;
define i32 @in_complex_y0(i32 %x, i32 %y_hi, i32 %y_low, i32 %mask) {
; CHECK-LABEL: in_complex_y0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    and w9, w0, w3
; CHECK-NEXT:    bic w8, w8, w3
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %y = and i32 %y_hi, %y_low
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_complex_y1(i32 %x, i32 %y_hi, i32 %y_low, i32 %mask) {
; CHECK-LABEL: in_complex_y1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    and w9, w0, w3
; CHECK-NEXT:    bic w8, w8, w3
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %y = and i32 %y_hi, %y_low
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %y, %n1
  ret i32 %r
}
; ============================================================================ ;
; M is an 'xor' too.
; ============================================================================ ;
define i32 @in_complex_m0(i32 %x, i32 %y, i32 %m_a, i32 %m_b) {
; CHECK-LABEL: in_complex_m0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor w8, w2, w3
; CHECK-NEXT:    bic w9, w1, w8
; CHECK-NEXT:    and w8, w0, w8
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_complex_m1(i32 %x, i32 %y, i32 %m_a, i32 %m_b) {
; CHECK-LABEL: in_complex_m1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor w8, w2, w3
; CHECK-NEXT:    bic w9, w1, w8
; CHECK-NEXT:    and w8, w0, w8
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0
  %r = xor i32 %n1, %y
  ret i32 %r
}
; ============================================================================ ;
; Both Y and M are complex.
; ============================================================================ ;
define i32 @in_complex_y0_m0(i32 %x, i32 %y_hi, i32 %y_low, i32 %m_a, i32 %m_b) {
; CHECK-LABEL: in_complex_y0_m0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    eor w9, w3, w4
; CHECK-NEXT:    bic w8, w8, w9
; CHECK-NEXT:    and w9, w0, w9
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %y = and i32 %y_hi, %y_low
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_complex_y1_m0(i32 %x, i32 %y_hi, i32 %y_low, i32 %m_a, i32 %m_b) {
; CHECK-LABEL: in_complex_y1_m0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    eor w9, w3, w4
; CHECK-NEXT:    bic w8, w8, w9
; CHECK-NEXT:    and w9, w0, w9
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %y = and i32 %y_hi, %y_low
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %y, %n1
  ret i32 %r
}
define i32 @in_complex_y0_m1(i32 %x, i32 %y_hi, i32 %y_low, i32 %m_a, i32 %m_b) {
; CHECK-LABEL: in_complex_y0_m1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    eor w9, w3, w4
; CHECK-NEXT:    bic w8, w8, w9
; CHECK-NEXT:    and w9, w0, w9
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %y = and i32 %y_hi, %y_low
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_complex_y1_m1(i32 %x, i32 %y_hi, i32 %y_low, i32 %m_a, i32 %m_b) {
; CHECK-LABEL: in_complex_y1_m1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w1, w2
; CHECK-NEXT:    eor w9, w3, w4
; CHECK-NEXT:    bic w8, w8, w9
; CHECK-NEXT:    and w9, w0, w9
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %y = and i32 %y_hi, %y_low
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0
  %r = xor i32 %y, %n1
  ret i32 %r
}
; ============================================================================ ;
; Various cases with %x and/or %y being a constant
; ============================================================================ ;
define i32 @out_constant_varx_mone(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: out_constant_varx_mone:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w2, w0
; CHECK-NEXT:    orn w0, w8, w2
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %mx = and i32 %mask, %x
  %my = and i32 %notmask, -1
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @in_constant_varx_mone(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_constant_varx_mone:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w2, w0
; CHECK-NEXT:    mvn w0, w8
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, -1 ; %x
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, -1
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @out_constant_varx_mone_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: out_constant_varx_mone_invmask:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w0, w0, w2
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %mx = and i32 %notmask, %x
  %my = and i32 %mask, -1
  %r = or i32 %mx, %my
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @in_constant_varx_mone_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_constant_varx_mone_invmask:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn w8, w0
; CHECK-NEXT:    bic w8, w8, w2
; CHECK-NEXT:    mvn w0, w8
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %n0 = xor i32 %x, -1 ; %x
  %n1 = and i32 %n0, %notmask
  %r = xor i32 %n1, -1
  ret i32 %r
}
define i32 @out_constant_varx_42(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: out_constant_varx_42:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    and w9, w2, w0
; CHECK-NEXT:    bic w8, w8, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %mx = and i32 %mask, %x
  %my = and i32 %notmask, 42
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @in_constant_varx_42(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_constant_varx_42:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    bic w8, w8, w2
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, 42 ; %x
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, 42
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @out_constant_varx_42_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: out_constant_varx_42_invmask:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    bic w9, w0, w2
; CHECK-NEXT:    and w8, w2, w8
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %mx = and i32 %notmask, %x
  %my = and i32 %mask, 42
  %r = or i32 %mx, %my
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @in_constant_varx_42_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_constant_varx_42_invmask:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    bic w9, w0, w2
; CHECK-NEXT:    and w8, w2, w8
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %n0 = xor i32 %x, 42 ; %x
  %n1 = and i32 %n0, %notmask
  %r = xor i32 %n1, 42
  ret i32 %r
}
define i32 @out_constant_mone_vary(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: out_constant_mone_vary:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w0, w1, w2
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %mx = and i32 %mask, -1
  %my = and i32 %notmask, %y
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @in_constant_mone_vary(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_constant_mone_vary:
; CHECK:       // %bb.0:
; CHECK-NEXT:    bic w8, w2, w1
; CHECK-NEXT:    eor w0, w8, w1
; CHECK-NEXT:    ret
  %n0 = xor i32 -1, %y ; %x
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @out_constant_mone_vary_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: out_constant_mone_vary_invmask:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w2, w1
; CHECK-NEXT:    orn w0, w8, w2
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %mx = and i32 %notmask, -1
  %my = and i32 %mask, %y
  %r = or i32 %mx, %my
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @in_constant_mone_vary_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_constant_mone_vary_invmask:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mvn w8, w1
; CHECK-NEXT:    bic w8, w8, w2
; CHECK-NEXT:    eor w0, w8, w1
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %n0 = xor i32 -1, %y ; %x
  %n1 = and i32 %n0, %notmask
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @out_constant_42_vary(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: out_constant_42_vary:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    bic w9, w1, w2
; CHECK-NEXT:    and w8, w2, w8
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %mx = and i32 %mask, 42
  %my = and i32 %notmask, %y
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @in_constant_42_vary(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_constant_42_vary:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    bic w9, w1, w2
; CHECK-NEXT:    and w8, w2, w8
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %n0 = xor i32 42, %y ; %x
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @out_constant_42_vary_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: out_constant_42_vary_invmask:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    and w9, w2, w1
; CHECK-NEXT:    bic w8, w8, w2
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %mx = and i32 %notmask, 42
  %my = and i32 %mask, %y
  %r = or i32 %mx, %my
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @in_constant_42_vary_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: in_constant_42_vary_invmask:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #42
; CHECK-NEXT:    and w9, w1, w2
; CHECK-NEXT:    bic w8, w8, w2
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %notmask = xor i32 %mask, -1
  %n0 = xor i32 42, %y ; %x
  %n1 = and i32 %n0, %notmask
  %r = xor i32 %n1, %y
  ret i32 %r
}
; ============================================================================ ;
; Negative tests. Should not be folded.
; ============================================================================ ;
; Multi-use tests.
declare void @use32(i32) nounwind
define i32 @in_multiuse_A(i32 %x, i32 %y, i32 %z, i32 %mask) nounwind {
; CHECK-LABEL: in_multiuse_A:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-32]! // 8-byte Folded Spill
; CHECK-NEXT:    eor w8, w0, w1
; CHECK-NEXT:    stp x20, x19, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    and w20, w8, w3
; CHECK-NEXT:    mov w19, w1
; CHECK-NEXT:    mov w0, w20
; CHECK-NEXT:    bl use32
; CHECK-NEXT:    eor w0, w20, w19
; CHECK-NEXT:    ldp x20, x19, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp], #32 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  call void @use32(i32 %n1)
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_multiuse_B(i32 %x, i32 %y, i32 %z, i32 %mask) nounwind {
; CHECK-LABEL: in_multiuse_B:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-32]! // 8-byte Folded Spill
; CHECK-NEXT:    eor w0, w0, w1
; CHECK-NEXT:    stp x20, x19, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    mov w19, w1
; CHECK-NEXT:    and w20, w0, w3
; CHECK-NEXT:    bl use32
; CHECK-NEXT:    eor w0, w20, w19
; CHECK-NEXT:    ldp x20, x19, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp], #32 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  call void @use32(i32 %n0)
  %r = xor i32 %n1, %y
  ret i32 %r
}
; Various bad variants
define i32 @n0_badmask(i32 %x, i32 %y, i32 %mask, i32 %mask2) {
; CHECK-LABEL: n0_badmask:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, w2
; CHECK-NEXT:    bic w9, w1, w3
; CHECK-NEXT:    orr w0, w8, w9
; CHECK-NEXT:    ret
  %mx = and i32 %x, %mask
  %notmask = xor i32 %mask2, -1 ; %mask2 instead of %mask
  %my = and i32 %y, %notmask
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @n0_badxor(i32 %x, i32 %y, i32 %mask) {
; CHECK-LABEL: n0_badxor:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor w8, w2, #0x1
; CHECK-NEXT:    and w9, w0, w2
; CHECK-NEXT:    and w8, w1, w8
; CHECK-NEXT:    orr w0, w9, w8
; CHECK-NEXT:    ret
  %mx = and i32 %x, %mask
  %notmask = xor i32 %mask, 1 ; instead of -1
  %my = and i32 %y, %notmask
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @n1_thirdvar(i32 %x, i32 %y, i32 %z, i32 %mask) {
; CHECK-LABEL: n1_thirdvar:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor w8, w0, w1
; CHECK-NEXT:    and w8, w8, w3
; CHECK-NEXT:    eor w0, w8, w2
; CHECK-NEXT:    ret
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %z ; instead of %y
  ret i32 %r
}
