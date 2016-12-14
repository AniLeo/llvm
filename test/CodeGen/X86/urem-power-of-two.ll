; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

; The easy case: a constant power-of-2 divisor.

define i64 @const_pow_2(i64 %x) {
; CHECK-LABEL: const_pow_2:
; CHECK:       # BB#0:
; CHECK-NEXT:    andl $31, %edi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
;
  %urem = urem i64 %x, 32
  ret i64 %urem
}

; A left-shifted power-of-2 divisor. Use a weird type for wider coverage.

define i25 @shift_left_pow_2(i25 %x, i25 %y) {
; CHECK-LABEL: shift_left_pow_2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl $1, %eax
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    shll %cl, %eax
; CHECK-NEXT:    addl $33554431, %eax # imm = 0x1FFFFFF
; CHECK-NEXT:    andl %edi, %eax
; CHECK-NEXT:    retq
;
  %shl = shl i25 1, %y
  %urem = urem i25 %x, %shl
  ret i25 %urem
}

; A logically right-shifted sign bit is a power-of-2 or UB.

define i16 @shift_right_pow_2(i16 %x, i16 %y) {
; CHECK-LABEL: shift_right_pow_2:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl $32768, %eax # imm = 0x8000
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    shrl %cl, %eax
; CHECK-NEXT:    decl %eax
; CHECK-NEXT:    andl %edi, %eax
; CHECK-NEXT:    # kill: %AX<def> %AX<kill> %EAX<kill>
; CHECK-NEXT:    retq
;
  %shr = lshr i16 -32768, %y
  %urem = urem i16 %x, %shr
  ret i16 %urem
}

; FIXME: A zero divisor would be UB, so this could be reduced to an 'and' with 3.

define i8 @and_pow_2(i8 %x, i8 %y) {
; CHECK-LABEL: and_pow_2:
; CHECK:       # BB#0:
; CHECK-NEXT:    andb $4, %sil
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    # kill: %EAX<def> %EAX<kill> %AX<def>
; CHECK-NEXT:    divb %sil
; CHECK-NEXT:    movzbl %ah, %eax # NOREX
; CHECK-NEXT:    # kill: %AL<def> %AL<kill> %EAX<kill>
; CHECK-NEXT:    retq
;
  %and = and i8 %y, 4
  %urem = urem i8 %x, %and
  ret i8 %urem
}

; A vector splat constant divisor should get the same treatment as a scalar.

define <4 x i32> @vec_const_pow_2(<4 x i32> %x) {
; CHECK-LABEL: vec_const_pow_2:
; CHECK:       # BB#0:
; CHECK-NEXT:    andps {{.*}}(%rip), %xmm0
; CHECK-NEXT:    retq
;
  %urem = urem <4 x i32> %x, <i32 16, i32 16, i32 16, i32 16>
  ret <4 x i32> %urem
}

