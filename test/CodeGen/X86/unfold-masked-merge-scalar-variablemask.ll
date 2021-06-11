; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=-bmi < %s | FileCheck %s --check-prefix=CHECK-NOBMI
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+bmi < %s | FileCheck %s --check-prefix=CHECK-BMI
; https://bugs.llvm.org/show_bug.cgi?id=37104

define i8 @out8(i8 %x, i8 %y, i8 %mask) {
; CHECK-NOBMI-LABEL: out8:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edx, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %edi
; CHECK-NOBMI-NEXT:    notb %al
; CHECK-NOBMI-NEXT:    andb %sil, %al
; CHECK-NOBMI-NEXT:    orb %dil, %al
; CHECK-NOBMI-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out8:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    notb %al
; CHECK-BMI-NEXT:    andb %sil, %al
; CHECK-BMI-NEXT:    orb %dil, %al
; CHECK-BMI-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-BMI-NEXT:    retq
  %mx = and i8 %x, %mask
  %notmask = xor i8 %mask, -1
  %my = and i8 %y, %notmask
  %r = or i8 %mx, %my
  ret i8 %r
}

define i16 @out16(i16 %x, i16 %y, i16 %mask) {
; CHECK-NOBMI-LABEL: out16:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edx, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %edi
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    andl %esi, %eax
; CHECK-NOBMI-NEXT:    orl %edi, %eax
; CHECK-NOBMI-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out16:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-BMI-NEXT:    retq
  %mx = and i16 %x, %mask
  %notmask = xor i16 %mask, -1
  %my = and i16 %y, %notmask
  %r = or i16 %mx, %my
  ret i16 %r
}

define i32 @out32(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: out32:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edx, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %edi
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    andl %esi, %eax
; CHECK-NOBMI-NEXT:    orl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out32:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %mx = and i32 %x, %mask
  %notmask = xor i32 %mask, -1
  %my = and i32 %y, %notmask
  %r = or i32 %mx, %my
  ret i32 %r
}

define i64 @out64(i64 %x, i64 %y, i64 %mask) {
; CHECK-NOBMI-LABEL: out64:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movq %rdx, %rax
; CHECK-NOBMI-NEXT:    andq %rdx, %rdi
; CHECK-NOBMI-NEXT:    notq %rax
; CHECK-NOBMI-NEXT:    andq %rsi, %rax
; CHECK-NOBMI-NEXT:    orq %rdi, %rax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out64:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andq %rdx, %rdi
; CHECK-BMI-NEXT:    andnq %rsi, %rdx, %rax
; CHECK-BMI-NEXT:    orq %rdi, %rax
; CHECK-BMI-NEXT:    retq
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
; CHECK-NOBMI-LABEL: in8:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in8:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i8 %x, %y
  %n1 = and i8 %n0, %mask
  %r = xor i8 %n1, %y
  ret i8 %r
}

define i16 @in16(i16 %x, i16 %y, i16 %mask) {
; CHECK-NOBMI-LABEL: in16:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in16:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i16 %x, %y
  %n1 = and i16 %n0, %mask
  %r = xor i16 %n1, %y
  ret i16 %r
}

define i32 @in32(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in32:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in32:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}

define i64 @in64(i64 %x, i64 %y, i64 %mask) {
; CHECK-NOBMI-LABEL: in64:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movq %rdi, %rax
; CHECK-NOBMI-NEXT:    xorq %rsi, %rax
; CHECK-NOBMI-NEXT:    andq %rdx, %rax
; CHECK-NOBMI-NEXT:    xorq %rsi, %rax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in64:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnq %rsi, %rdx, %rax
; CHECK-BMI-NEXT:    andq %rdx, %rdi
; CHECK-BMI-NEXT:    orq %rdi, %rax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i64 %x, %y
  %n1 = and i64 %n0, %mask
  %r = xor i64 %n1, %y
  ret i64 %r
}
; ============================================================================ ;
; Commutativity tests.
; ============================================================================ ;
define i32 @in_commutativity_0_0_1(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_commutativity_0_0_1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_commutativity_0_0_1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0 ; swapped
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_commutativity_0_1_0(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_commutativity_0_1_0:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_commutativity_0_1_0:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %y, %n1 ; swapped
  ret i32 %r
}
define i32 @in_commutativity_0_1_1(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_commutativity_0_1_1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_commutativity_0_1_1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0 ; swapped
  %r = xor i32 %y, %n1 ; swapped
  ret i32 %r
}
define i32 @in_commutativity_1_0_0(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_commutativity_1_0_0:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_commutativity_1_0_0:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %edi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    orl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %x ; %x instead of %y
  ret i32 %r
}
define i32 @in_commutativity_1_0_1(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_commutativity_1_0_1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_commutativity_1_0_1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %edi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    orl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0 ; swapped
  %r = xor i32 %n1, %x ; %x instead of %y
  ret i32 %r
}
define i32 @in_commutativity_1_1_0(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_commutativity_1_1_0:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_commutativity_1_1_0:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %edi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    orl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %x, %n1 ; swapped, %x instead of %y
  ret i32 %r
}
define i32 @in_commutativity_1_1_1(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_commutativity_1_1_1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_commutativity_1_1_1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %edi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    orl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0 ; swapped
  %r = xor i32 %x, %n1 ; swapped, %x instead of %y
  ret i32 %r
}
; ============================================================================ ;
; Y is an 'and' too.
; ============================================================================ ;
define i32 @in_complex_y0(i32 %x, i32 %y_hi, i32 %y_low, i32 %mask) {
; CHECK-NOBMI-LABEL: in_complex_y0:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %esi
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %ecx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_y0:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    andl %ecx, %edi
; CHECK-BMI-NEXT:    andnl %esi, %ecx, %eax
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %y = and i32 %y_hi, %y_low
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_complex_y1(i32 %x, i32 %y_hi, i32 %y_low, i32 %mask) {
; CHECK-NOBMI-LABEL: in_complex_y1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %esi
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %ecx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_y1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    andl %ecx, %edi
; CHECK-BMI-NEXT:    andnl %esi, %ecx, %eax
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
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
; CHECK-NOBMI-LABEL: in_complex_m0:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %ecx, %edx
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_m0:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    xorl %ecx, %edx
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edi, %edx
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_complex_m1(i32 %x, i32 %y, i32 %m_a, i32 %m_b) {
; CHECK-NOBMI-LABEL: in_complex_m1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %ecx, %edx
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_m1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    xorl %ecx, %edx
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl %edi, %edx
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
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
; CHECK-NOBMI-LABEL: in_complex_y0_m0:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %esi
; CHECK-NOBMI-NEXT:    xorl %r8d, %ecx
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %ecx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_y0_m0:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    xorl %r8d, %ecx
; CHECK-BMI-NEXT:    andnl %esi, %ecx, %eax
; CHECK-BMI-NEXT:    andl %edi, %ecx
; CHECK-BMI-NEXT:    orl %ecx, %eax
; CHECK-BMI-NEXT:    retq
  %y = and i32 %y_hi, %y_low
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_complex_y1_m0(i32 %x, i32 %y_hi, i32 %y_low, i32 %m_a, i32 %m_b) {
; CHECK-NOBMI-LABEL: in_complex_y1_m0:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %esi
; CHECK-NOBMI-NEXT:    xorl %r8d, %ecx
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %ecx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_y1_m0:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    xorl %r8d, %ecx
; CHECK-BMI-NEXT:    andnl %esi, %ecx, %eax
; CHECK-BMI-NEXT:    andl %edi, %ecx
; CHECK-BMI-NEXT:    orl %ecx, %eax
; CHECK-BMI-NEXT:    retq
  %y = and i32 %y_hi, %y_low
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %y, %n1
  ret i32 %r
}
define i32 @in_complex_y0_m1(i32 %x, i32 %y_hi, i32 %y_low, i32 %m_a, i32 %m_b) {
; CHECK-NOBMI-LABEL: in_complex_y0_m1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %esi
; CHECK-NOBMI-NEXT:    xorl %r8d, %ecx
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %ecx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_y0_m1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    xorl %r8d, %ecx
; CHECK-BMI-NEXT:    andnl %esi, %ecx, %eax
; CHECK-BMI-NEXT:    andl %edi, %ecx
; CHECK-BMI-NEXT:    orl %ecx, %eax
; CHECK-BMI-NEXT:    retq
  %y = and i32 %y_hi, %y_low
  %mask = xor i32 %m_a, %m_b
  %n0 = xor i32 %x, %y
  %n1 = and i32 %mask, %n0
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_complex_y1_m1(i32 %x, i32 %y_hi, i32 %y_low, i32 %m_a, i32 %m_b) {
; CHECK-NOBMI-LABEL: in_complex_y1_m1:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %esi
; CHECK-NOBMI-NEXT:    xorl %r8d, %ecx
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %ecx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_complex_y1_m1:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    xorl %r8d, %ecx
; CHECK-BMI-NEXT:    andnl %esi, %ecx, %eax
; CHECK-BMI-NEXT:    andl %edi, %ecx
; CHECK-BMI-NEXT:    orl %ecx, %eax
; CHECK-BMI-NEXT:    retq
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
; CHECK-NOBMI-LABEL: out_constant_varx_mone:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    notl %edx
; CHECK-NOBMI-NEXT:    orl %edx, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out_constant_varx_mone:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edi, %eax
; CHECK-BMI-NEXT:    andl %edx, %eax
; CHECK-BMI-NEXT:    notl %edx
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %mx = and i32 %mask, %x
  %my = and i32 %notmask, -1
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @in_constant_varx_mone(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_constant_varx_mone:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constant_varx_mone:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %edx, %edi, %eax
; CHECK-BMI-NEXT:    notl %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, -1 ; %x
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, -1
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @out_constant_varx_mone_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: out_constant_varx_mone_invmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    orl %edx, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out_constant_varx_mone_invmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edi, %eax
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %mx = and i32 %notmask, %x
  %my = and i32 %mask, -1
  %r = or i32 %mx, %my
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @in_constant_varx_mone_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_constant_varx_mone_invmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    notl %edx
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constant_varx_mone_invmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    notl %edx
; CHECK-BMI-NEXT:    andnl %edx, %edi, %eax
; CHECK-BMI-NEXT:    notl %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %n0 = xor i32 %x, -1 ; %x
  %n1 = and i32 %n0, %notmask
  %r = xor i32 %n1, -1
  ret i32 %r
}
define i32 @out_constant_varx_42(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: out_constant_varx_42:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    andl %edx, %edi
; CHECK-NOBMI-NEXT:    movl %edx, %eax
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    andl $42, %eax
; CHECK-NOBMI-NEXT:    orl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out_constant_varx_42:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    movl %edx, %eax
; CHECK-BMI-NEXT:    notl %eax
; CHECK-BMI-NEXT:    andl $42, %eax
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %mx = and i32 %mask, %x
  %my = and i32 %notmask, 42
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @in_constant_varx_42(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_constant_varx_42:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl $42, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl $42, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constant_varx_42:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %edx, %edi, %eax
; CHECK-BMI-NEXT:    orl $42, %edx
; CHECK-BMI-NEXT:    andnl %edx, %eax, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, 42 ; %x
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, 42
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @out_constant_varx_42_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: out_constant_varx_42_invmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edx, %eax
; CHECK-NOBMI-NEXT:    movl %edx, %ecx
; CHECK-NOBMI-NEXT:    notl %ecx
; CHECK-NOBMI-NEXT:    andl %edi, %ecx
; CHECK-NOBMI-NEXT:    andl $42, %eax
; CHECK-NOBMI-NEXT:    orl %ecx, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out_constant_varx_42_invmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %edi, %edx, %eax
; CHECK-BMI-NEXT:    andl $42, %edx
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %mx = and i32 %notmask, %x
  %my = and i32 %mask, 42
  %r = or i32 %mx, %my
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @in_constant_varx_42_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_constant_varx_42_invmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    notl %edx
; CHECK-NOBMI-NEXT:    xorl $42, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl $42, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constant_varx_42_invmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    notl %edx
; CHECK-BMI-NEXT:    andnl %edx, %edi, %eax
; CHECK-BMI-NEXT:    orl $42, %edx
; CHECK-BMI-NEXT:    andnl %edx, %eax, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %n0 = xor i32 %x, 42 ; %x
  %n1 = and i32 %n0, %notmask
  %r = xor i32 %n1, 42
  ret i32 %r
}
define i32 @out_constant_mone_vary(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: out_constant_mone_vary:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    orl %edx, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out_constant_mone_vary:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %esi, %eax
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %mx = and i32 %mask, -1
  %my = and i32 %notmask, %y
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @in_constant_mone_vary(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_constant_mone_vary:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constant_mone_vary:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %edx, %esi, %eax
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 -1, %y ; %x
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @out_constant_mone_vary_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: out_constant_mone_vary_invmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    notl %edx
; CHECK-NOBMI-NEXT:    orl %edx, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out_constant_mone_vary_invmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %esi, %eax
; CHECK-BMI-NEXT:    andl %edx, %eax
; CHECK-BMI-NEXT:    notl %edx
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %mx = and i32 %notmask, -1
  %my = and i32 %mask, %y
  %r = or i32 %mx, %my
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @in_constant_mone_vary_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_constant_mone_vary_invmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    notl %edx
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constant_mone_vary_invmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    notl %edx
; CHECK-BMI-NEXT:    andnl %edx, %esi, %eax
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %n0 = xor i32 -1, %y ; %x
  %n1 = and i32 %n0, %notmask
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @out_constant_42_vary(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: out_constant_42_vary:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edx, %eax
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    andl $42, %edx
; CHECK-NOBMI-NEXT:    andl %esi, %eax
; CHECK-NOBMI-NEXT:    orl %edx, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out_constant_42_vary:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl $42, %edx
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %mx = and i32 %mask, 42
  %my = and i32 %notmask, %y
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @in_constant_42_vary(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_constant_42_vary:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    xorl $42, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constant_42_vary:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andnl %esi, %edx, %eax
; CHECK-BMI-NEXT:    andl $42, %edx
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 42, %y ; %x
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %y
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @out_constant_42_vary_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: out_constant_42_vary_invmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    notl %edx
; CHECK-NOBMI-NEXT:    andl $42, %edx
; CHECK-NOBMI-NEXT:    orl %edx, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: out_constant_42_vary_invmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %esi, %eax
; CHECK-BMI-NEXT:    andl %edx, %eax
; CHECK-BMI-NEXT:    notl %edx
; CHECK-BMI-NEXT:    andl $42, %edx
; CHECK-BMI-NEXT:    orl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %notmask = xor i32 %mask, -1
  %mx = and i32 %notmask, 42
  %my = and i32 %mask, %y
  %r = or i32 %mx, %my
  ret i32 %r
}
; This is not a canonical form. Testing for completeness only.
define i32 @in_constant_42_vary_invmask(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: in_constant_42_vary_invmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    notl %edx
; CHECK-NOBMI-NEXT:    movl %esi, %eax
; CHECK-NOBMI-NEXT:    xorl $42, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_constant_42_vary_invmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %esi
; CHECK-BMI-NEXT:    notl %eax
; CHECK-BMI-NEXT:    andl $42, %eax
; CHECK-BMI-NEXT:    orl %esi, %eax
; CHECK-BMI-NEXT:    retq
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
; CHECK-NOBMI-LABEL: in_multiuse_A:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    pushq %rbp
; CHECK-NOBMI-NEXT:    pushq %rbx
; CHECK-NOBMI-NEXT:    pushq %rax
; CHECK-NOBMI-NEXT:    movl %esi, %ebx
; CHECK-NOBMI-NEXT:    movl %edi, %ebp
; CHECK-NOBMI-NEXT:    xorl %esi, %ebp
; CHECK-NOBMI-NEXT:    andl %ecx, %ebp
; CHECK-NOBMI-NEXT:    movl %ebp, %edi
; CHECK-NOBMI-NEXT:    callq use32@PLT
; CHECK-NOBMI-NEXT:    xorl %ebx, %ebp
; CHECK-NOBMI-NEXT:    movl %ebp, %eax
; CHECK-NOBMI-NEXT:    addq $8, %rsp
; CHECK-NOBMI-NEXT:    popq %rbx
; CHECK-NOBMI-NEXT:    popq %rbp
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_multiuse_A:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    pushq %rbp
; CHECK-BMI-NEXT:    pushq %rbx
; CHECK-BMI-NEXT:    pushq %rax
; CHECK-BMI-NEXT:    movl %esi, %ebx
; CHECK-BMI-NEXT:    movl %edi, %ebp
; CHECK-BMI-NEXT:    xorl %esi, %ebp
; CHECK-BMI-NEXT:    andl %ecx, %ebp
; CHECK-BMI-NEXT:    movl %ebp, %edi
; CHECK-BMI-NEXT:    callq use32@PLT
; CHECK-BMI-NEXT:    xorl %ebx, %ebp
; CHECK-BMI-NEXT:    movl %ebp, %eax
; CHECK-BMI-NEXT:    addq $8, %rsp
; CHECK-BMI-NEXT:    popq %rbx
; CHECK-BMI-NEXT:    popq %rbp
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  call void @use32(i32 %n1)
  %r = xor i32 %n1, %y
  ret i32 %r
}
define i32 @in_multiuse_B(i32 %x, i32 %y, i32 %z, i32 %mask) nounwind {
; CHECK-NOBMI-LABEL: in_multiuse_B:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    pushq %rbp
; CHECK-NOBMI-NEXT:    pushq %rbx
; CHECK-NOBMI-NEXT:    pushq %rax
; CHECK-NOBMI-NEXT:    movl %ecx, %ebx
; CHECK-NOBMI-NEXT:    movl %esi, %ebp
; CHECK-NOBMI-NEXT:    xorl %esi, %edi
; CHECK-NOBMI-NEXT:    andl %edi, %ebx
; CHECK-NOBMI-NEXT:    callq use32@PLT
; CHECK-NOBMI-NEXT:    xorl %ebp, %ebx
; CHECK-NOBMI-NEXT:    movl %ebx, %eax
; CHECK-NOBMI-NEXT:    addq $8, %rsp
; CHECK-NOBMI-NEXT:    popq %rbx
; CHECK-NOBMI-NEXT:    popq %rbp
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: in_multiuse_B:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    pushq %rbp
; CHECK-BMI-NEXT:    pushq %rbx
; CHECK-BMI-NEXT:    pushq %rax
; CHECK-BMI-NEXT:    movl %ecx, %ebx
; CHECK-BMI-NEXT:    movl %esi, %ebp
; CHECK-BMI-NEXT:    xorl %esi, %edi
; CHECK-BMI-NEXT:    andl %edi, %ebx
; CHECK-BMI-NEXT:    callq use32@PLT
; CHECK-BMI-NEXT:    xorl %ebp, %ebx
; CHECK-BMI-NEXT:    movl %ebx, %eax
; CHECK-BMI-NEXT:    addq $8, %rsp
; CHECK-BMI-NEXT:    popq %rbx
; CHECK-BMI-NEXT:    popq %rbp
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  call void @use32(i32 %n0)
  %r = xor i32 %n1, %y
  ret i32 %r
}
; Various bad variants
define i32 @n0_badmask(i32 %x, i32 %y, i32 %mask, i32 %mask2) {
; CHECK-NOBMI-LABEL: n0_badmask:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %ecx, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %edi
; CHECK-NOBMI-NEXT:    notl %eax
; CHECK-NOBMI-NEXT:    andl %esi, %eax
; CHECK-NOBMI-NEXT:    orl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: n0_badmask:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    andnl %esi, %ecx, %eax
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %mx = and i32 %x, %mask
  %notmask = xor i32 %mask2, -1 ; %mask2 instead of %mask
  %my = and i32 %y, %notmask
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @n0_badxor(i32 %x, i32 %y, i32 %mask) {
; CHECK-NOBMI-LABEL: n0_badxor:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edx, %eax
; CHECK-NOBMI-NEXT:    andl %edx, %edi
; CHECK-NOBMI-NEXT:    xorl $1, %eax
; CHECK-NOBMI-NEXT:    andl %esi, %eax
; CHECK-NOBMI-NEXT:    orl %edi, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: n0_badxor:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edx, %eax
; CHECK-BMI-NEXT:    andl %edx, %edi
; CHECK-BMI-NEXT:    xorl $1, %eax
; CHECK-BMI-NEXT:    andl %esi, %eax
; CHECK-BMI-NEXT:    orl %edi, %eax
; CHECK-BMI-NEXT:    retq
  %mx = and i32 %x, %mask
  %notmask = xor i32 %mask, 1 ; instead of -1
  %my = and i32 %y, %notmask
  %r = or i32 %mx, %my
  ret i32 %r
}
define i32 @n1_thirdvar(i32 %x, i32 %y, i32 %z, i32 %mask) {
; CHECK-NOBMI-LABEL: n1_thirdvar:
; CHECK-NOBMI:       # %bb.0:
; CHECK-NOBMI-NEXT:    movl %edi, %eax
; CHECK-NOBMI-NEXT:    xorl %esi, %eax
; CHECK-NOBMI-NEXT:    andl %ecx, %eax
; CHECK-NOBMI-NEXT:    xorl %edx, %eax
; CHECK-NOBMI-NEXT:    retq
;
; CHECK-BMI-LABEL: n1_thirdvar:
; CHECK-BMI:       # %bb.0:
; CHECK-BMI-NEXT:    movl %edi, %eax
; CHECK-BMI-NEXT:    xorl %esi, %eax
; CHECK-BMI-NEXT:    andl %ecx, %eax
; CHECK-BMI-NEXT:    xorl %edx, %eax
; CHECK-BMI-NEXT:    retq
  %n0 = xor i32 %x, %y
  %n1 = and i32 %n0, %mask
  %r = xor i32 %n1, %z ; instead of %y
  ret i32 %r
}
