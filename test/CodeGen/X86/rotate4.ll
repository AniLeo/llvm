; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s

; Check that we recognize this idiom for rotation too:
;    a << (b & (OpSize-1)) | a >> ((0 - b) & (OpSize-1))

define i32 @rotate_left_32(i32 %a, i32 %b) {
; CHECK-LABEL: rotate_left_32:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    roll %cl, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %and = and i32 %b, 31
  %shl = shl i32 %a, %and
  %t0 = sub i32 0, %b
  %and3 = and i32 %t0, 31
  %shr = lshr i32 %a, %and3
  %or = or i32 %shl, %shr
  ret i32 %or
}

define i32 @rotate_right_32(i32 %a, i32 %b) {
; CHECK-LABEL: rotate_right_32:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rorl %cl, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %and = and i32 %b, 31
  %shl = lshr i32 %a, %and
  %t0 = sub i32 0, %b
  %and3 = and i32 %t0, 31
  %shr = shl i32 %a, %and3
  %or = or i32 %shl, %shr
  ret i32 %or
}

define i64 @rotate_left_64(i64 %a, i64 %b) {
; CHECK-LABEL: rotate_left_64:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rolq %cl, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %and = and i64 %b, 63
  %shl = shl i64 %a, %and
  %t0 = sub i64 0, %b
  %and3 = and i64 %t0, 63
  %shr = lshr i64 %a, %and3
  %or = or i64 %shl, %shr
  ret i64 %or
}

define i64 @rotate_right_64(i64 %a, i64 %b) {
; CHECK-LABEL: rotate_right_64:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rorq %cl, %rdi
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    retq
  %and = and i64 %b, 63
  %shl = lshr i64 %a, %and
  %t0 = sub i64 0, %b
  %and3 = and i64 %t0, 63
  %shr = shl i64 %a, %and3
  %or = or i64 %shl, %shr
  ret i64 %or
}

; Also check mem operand.

define void @rotate_left_m32(i32 *%pa, i32 %b) {
; CHECK-LABEL: rotate_left_m32:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    roll %cl, (%rdi)
; CHECK-NEXT:    retq
  %a = load i32, i32* %pa, align 16
  %and = and i32 %b, 31
  %shl = shl i32 %a, %and
  %t0 = sub i32 0, %b
  %and3 = and i32 %t0, 31
  %shr = lshr i32 %a, %and3
  %or = or i32 %shl, %shr
  store i32 %or, i32* %pa, align 32
  ret void
}

define void @rotate_right_m32(i32 *%pa, i32 %b) {
; CHECK-LABEL: rotate_right_m32:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rorl %cl, (%rdi)
; CHECK-NEXT:    retq
  %a = load i32, i32* %pa, align 16
  %and = and i32 %b, 31
  %shl = lshr i32 %a, %and
  %t0 = sub i32 0, %b
  %and3 = and i32 %t0, 31
  %shr = shl i32 %a, %and3
  %or = or i32 %shl, %shr
  store i32 %or, i32* %pa, align 32
  ret void
}

define void @rotate_left_m64(i64 *%pa, i64 %b) {
; CHECK-LABEL: rotate_left_m64:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rolq %cl, (%rdi)
; CHECK-NEXT:    retq
  %a = load i64, i64* %pa, align 16
  %and = and i64 %b, 63
  %shl = shl i64 %a, %and
  %t0 = sub i64 0, %b
  %and3 = and i64 %t0, 63
  %shr = lshr i64 %a, %and3
  %or = or i64 %shl, %shr
  store i64 %or, i64* %pa, align 64
  ret void
}

define void @rotate_right_m64(i64 *%pa, i64 %b) {
; CHECK-LABEL: rotate_right_m64:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rorq %cl, (%rdi)
; CHECK-NEXT:    retq
  %a = load i64, i64* %pa, align 16
  %and = and i64 %b, 63
  %shl = lshr i64 %a, %and
  %t0 = sub i64 0, %b
  %and3 = and i64 %t0, 63
  %shr = shl i64 %a, %and3
  %or = or i64 %shl, %shr
  store i64 %or, i64* %pa, align 64
  ret void
}

; The next 8 tests include masks of the narrow width shift amounts that should be eliminated.
; These patterns are produced by instcombine after r310509.

define i8 @rotate_left_8(i8 %x, i32 %amount) {
; CHECK-LABEL: rotate_left_8:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rolb %cl, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %amt = trunc i32 %amount to i8
  %sub = sub i8 0, %amt
  %maskamt = and i8 %amt, 7
  %masksub = and i8 %sub, 7
  %shl = shl i8 %x, %maskamt
  %shr = lshr i8 %x, %masksub
  %or = or i8 %shl, %shr
  ret i8 %or
}

define i8 @rotate_right_8(i8 %x, i32 %amount) {
; CHECK-LABEL: rotate_right_8:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rorb %cl, %dil
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %amt = trunc i32 %amount to i8
  %sub = sub i8 0, %amt
  %maskamt = and i8 %amt, 7
  %masksub = and i8 %sub, 7
  %shr = lshr i8 %x, %maskamt
  %shl = shl i8 %x, %masksub
  %or = or i8 %shr, %shl
  ret i8 %or
}

define i16 @rotate_left_16(i16 %x, i32 %amount) {
; CHECK-LABEL: rotate_left_16:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rolw %cl, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %amt = trunc i32 %amount to i16
  %sub = sub i16 0, %amt
  %maskamt = and i16 %amt, 15
  %masksub = and i16 %sub, 15
  %shl = shl i16 %x, %maskamt
  %shr = lshr i16 %x, %masksub
  %or = or i16 %shl, %shr
  ret i16 %or
}

define i16 @rotate_right_16(i16 %x, i32 %amount) {
; CHECK-LABEL: rotate_right_16:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rorw %cl, %di
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %amt = trunc i32 %amount to i16
  %sub = sub i16 0, %amt
  %maskamt = and i16 %amt, 15
  %masksub = and i16 %sub, 15
  %shr = lshr i16 %x, %maskamt
  %shl = shl i16 %x, %masksub
  %or = or i16 %shr, %shl
  ret i16 %or
}

define void @rotate_left_m8(i8* %p, i32 %amount) {
; CHECK-LABEL: rotate_left_m8:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rolb %cl, (%rdi)
; CHECK-NEXT:    retq
  %x = load i8, i8* %p, align 1
  %amt = trunc i32 %amount to i8
  %sub = sub i8 0, %amt
  %maskamt = and i8 %amt, 7
  %masksub = and i8 %sub, 7
  %shl = shl i8 %x, %maskamt
  %shr = lshr i8 %x, %masksub
  %or = or i8 %shl, %shr
  store i8 %or, i8* %p, align 1
  ret void
}

define void @rotate_right_m8(i8* %p, i32 %amount) {
; CHECK-LABEL: rotate_right_m8:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rorb %cl, (%rdi)
; CHECK-NEXT:    retq
  %x = load i8, i8* %p, align 1
  %amt = trunc i32 %amount to i8
  %sub = sub i8 0, %amt
  %maskamt = and i8 %amt, 7
  %masksub = and i8 %sub, 7
  %shl = shl i8 %x, %masksub
  %shr = lshr i8 %x, %maskamt
  %or = or i8 %shl, %shr
  store i8 %or, i8* %p, align 1
  ret void
}

define void @rotate_left_m16(i16* %p, i32 %amount) {
; CHECK-LABEL: rotate_left_m16:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rolw %cl, (%rdi)
; CHECK-NEXT:    retq
  %x = load i16, i16* %p, align 1
  %amt = trunc i32 %amount to i16
  %sub = sub i16 0, %amt
  %maskamt = and i16 %amt, 15
  %masksub = and i16 %sub, 15
  %shl = shl i16 %x, %maskamt
  %shr = lshr i16 %x, %masksub
  %or = or i16 %shl, %shr
  store i16 %or, i16* %p, align 1
  ret void
}

define void @rotate_right_m16(i16* %p, i32 %amount) {
; CHECK-LABEL: rotate_right_m16:
; CHECK:       # BB#0:
; CHECK-NEXT:    movl %esi, %ecx
; CHECK-NEXT:    rorw %cl, (%rdi)
; CHECK-NEXT:    retq
  %x = load i16, i16* %p, align 1
  %amt = trunc i32 %amount to i16
  %sub = sub i16 0, %amt
  %maskamt = and i16 %amt, 15
  %masksub = and i16 %sub, 15
  %shl = shl i16 %x, %masksub
  %shr = lshr i16 %x, %maskamt
  %or = or i16 %shl, %shr
  store i16 %or, i16* %p, align 1
  ret void
}

