; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=X64

; Check that we recognize this idiom for rotation too:
;    a << (b & (OpSize-1)) | a >> ((0 - b) & (OpSize-1))

define i32 @rotate_left_32(i32 %a, i32 %b) {
; X86-LABEL: rotate_left_32:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    roll %cl, %eax
; X86-NEXT:    retl
;
; X64-LABEL: rotate_left_32:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    roll %cl, %eax
; X64-NEXT:    retq
  %and = and i32 %b, 31
  %shl = shl i32 %a, %and
  %t0 = sub i32 0, %b
  %and3 = and i32 %t0, 31
  %shr = lshr i32 %a, %and3
  %or = or i32 %shl, %shr
  ret i32 %or
}

define i32 @rotate_right_32(i32 %a, i32 %b) {
; X86-LABEL: rotate_right_32:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rorl %cl, %eax
; X86-NEXT:    retl
;
; X64-LABEL: rotate_right_32:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rorl %cl, %eax
; X64-NEXT:    retq
  %and = and i32 %b, 31
  %shl = lshr i32 %a, %and
  %t0 = sub i32 0, %b
  %and3 = and i32 %t0, 31
  %shr = shl i32 %a, %and3
  %or = or i32 %shl, %shr
  ret i32 %or
}

define i64 @rotate_left_64(i64 %a, i64 %b) {
; X86-LABEL: rotate_left_64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    pushl %edi
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    pushl %esi
; X86-NEXT:    .cfi_def_cfa_offset 16
; X86-NEXT:    .cfi_offset %esi, -16
; X86-NEXT:    .cfi_offset %edi, -12
; X86-NEXT:    .cfi_offset %ebx, -8
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    shll %cl, %eax
; X86-NEXT:    movl %edi, %edx
; X86-NEXT:    shldl %cl, %esi, %edx
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB2_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    xorl %eax, %eax
; X86-NEXT:  .LBB2_2:
; X86-NEXT:    negb %cl
; X86-NEXT:    movl %edi, %ebx
; X86-NEXT:    shrl %cl, %ebx
; X86-NEXT:    shrdl %cl, %edi, %esi
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB2_4
; X86-NEXT:  # %bb.3:
; X86-NEXT:    movl %ebx, %esi
; X86-NEXT:    xorl %ebx, %ebx
; X86-NEXT:  .LBB2_4:
; X86-NEXT:    orl %ebx, %edx
; X86-NEXT:    orl %esi, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    popl %edi
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    popl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: rotate_left_64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rcx
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    # kill: def $cl killed $cl killed $rcx
; X64-NEXT:    rolq %cl, %rax
; X64-NEXT:    retq
  %and = and i64 %b, 63
  %shl = shl i64 %a, %and
  %t0 = sub i64 0, %b
  %and3 = and i64 %t0, 63
  %shr = lshr i64 %a, %and3
  %or = or i64 %shl, %shr
  ret i64 %or
}

define i64 @rotate_right_64(i64 %a, i64 %b) {
; X86-LABEL: rotate_right_64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    pushl %edi
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    pushl %esi
; X86-NEXT:    .cfi_def_cfa_offset 16
; X86-NEXT:    .cfi_offset %esi, -16
; X86-NEXT:    .cfi_offset %edi, -12
; X86-NEXT:    .cfi_offset %ebx, -8
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %esi, %edx
; X86-NEXT:    shrl %cl, %edx
; X86-NEXT:    movl %edi, %eax
; X86-NEXT:    shrdl %cl, %esi, %eax
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB3_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:  .LBB3_2:
; X86-NEXT:    negb %cl
; X86-NEXT:    movl %edi, %ebx
; X86-NEXT:    shll %cl, %ebx
; X86-NEXT:    shldl %cl, %edi, %esi
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB3_4
; X86-NEXT:  # %bb.3:
; X86-NEXT:    movl %ebx, %esi
; X86-NEXT:    xorl %ebx, %ebx
; X86-NEXT:  .LBB3_4:
; X86-NEXT:    orl %esi, %edx
; X86-NEXT:    orl %ebx, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    popl %edi
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    popl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: rotate_right_64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rcx
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    # kill: def $cl killed $cl killed $rcx
; X64-NEXT:    rorq %cl, %rax
; X64-NEXT:    retq
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
; X86-LABEL: rotate_left_m32:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    roll %cl, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: rotate_left_m32:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    roll %cl, (%rdi)
; X64-NEXT:    retq
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
; X86-LABEL: rotate_right_m32:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rorl %cl, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: rotate_right_m32:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rorl %cl, (%rdi)
; X64-NEXT:    retq
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
; X86-LABEL: rotate_left_m64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    pushl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    pushl %edi
; X86-NEXT:    .cfi_def_cfa_offset 16
; X86-NEXT:    pushl %esi
; X86-NEXT:    .cfi_def_cfa_offset 20
; X86-NEXT:    .cfi_offset %esi, -20
; X86-NEXT:    .cfi_offset %edi, -16
; X86-NEXT:    .cfi_offset %ebx, -12
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl (%eax), %edx
; X86-NEXT:    movl 4(%eax), %ebx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shll %cl, %esi
; X86-NEXT:    movl %ebx, %edi
; X86-NEXT:    shldl %cl, %edx, %edi
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB6_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %esi, %edi
; X86-NEXT:    xorl %esi, %esi
; X86-NEXT:  .LBB6_2:
; X86-NEXT:    negb %cl
; X86-NEXT:    movl %ebx, %ebp
; X86-NEXT:    shrl %cl, %ebp
; X86-NEXT:    shrdl %cl, %ebx, %edx
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB6_4
; X86-NEXT:  # %bb.3:
; X86-NEXT:    movl %ebp, %edx
; X86-NEXT:    xorl %ebp, %ebp
; X86-NEXT:  .LBB6_4:
; X86-NEXT:    orl %ebp, %edi
; X86-NEXT:    orl %edx, %esi
; X86-NEXT:    movl %edi, 4(%eax)
; X86-NEXT:    movl %esi, (%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    .cfi_def_cfa_offset 16
; X86-NEXT:    popl %edi
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    popl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: rotate_left_m64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rcx
; X64-NEXT:    # kill: def $cl killed $cl killed $rcx
; X64-NEXT:    rolq %cl, (%rdi)
; X64-NEXT:    retq
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
; X86-LABEL: rotate_right_m64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    pushl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    pushl %edi
; X86-NEXT:    .cfi_def_cfa_offset 16
; X86-NEXT:    pushl %esi
; X86-NEXT:    .cfi_def_cfa_offset 20
; X86-NEXT:    .cfi_offset %esi, -20
; X86-NEXT:    .cfi_offset %edi, -16
; X86-NEXT:    .cfi_offset %ebx, -12
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl (%eax), %ebx
; X86-NEXT:    movl 4(%eax), %esi
; X86-NEXT:    movl %esi, %edx
; X86-NEXT:    shrl %cl, %edx
; X86-NEXT:    movl %ebx, %edi
; X86-NEXT:    shrdl %cl, %esi, %edi
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB7_2
; X86-NEXT:  # %bb.1:
; X86-NEXT:    movl %edx, %edi
; X86-NEXT:    xorl %edx, %edx
; X86-NEXT:  .LBB7_2:
; X86-NEXT:    negb %cl
; X86-NEXT:    movl %ebx, %ebp
; X86-NEXT:    shll %cl, %ebp
; X86-NEXT:    shldl %cl, %ebx, %esi
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    je .LBB7_4
; X86-NEXT:  # %bb.3:
; X86-NEXT:    movl %ebp, %esi
; X86-NEXT:    xorl %ebp, %ebp
; X86-NEXT:  .LBB7_4:
; X86-NEXT:    orl %esi, %edx
; X86-NEXT:    orl %ebp, %edi
; X86-NEXT:    movl %edx, 4(%eax)
; X86-NEXT:    movl %edi, (%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    .cfi_def_cfa_offset 16
; X86-NEXT:    popl %edi
; X86-NEXT:    .cfi_def_cfa_offset 12
; X86-NEXT:    popl %ebx
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 4
; X86-NEXT:    retl
;
; X64-LABEL: rotate_right_m64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rcx
; X64-NEXT:    # kill: def $cl killed $cl killed $rcx
; X64-NEXT:    rorq %cl, (%rdi)
; X64-NEXT:    retq
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
; X86-LABEL: rotate_left_8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    rolb %cl, %al
; X86-NEXT:    retl
;
; X64-LABEL: rotate_left_8:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rolb %cl, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
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
; X86-LABEL: rotate_right_8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    rorb %cl, %al
; X86-NEXT:    retl
;
; X64-LABEL: rotate_right_8:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rorb %cl, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
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
; X86-LABEL: rotate_left_16:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rolw %cl, %ax
; X86-NEXT:    retl
;
; X64-LABEL: rotate_left_16:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rolw %cl, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
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
; X86-LABEL: rotate_right_16:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rorw %cl, %ax
; X86-NEXT:    retl
;
; X64-LABEL: rotate_right_16:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rorw %cl, %ax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
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
; X86-LABEL: rotate_left_m8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rolb %cl, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: rotate_left_m8:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rolb %cl, (%rdi)
; X64-NEXT:    retq
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
; X86-LABEL: rotate_right_m8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rorb %cl, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: rotate_right_m8:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rorb %cl, (%rdi)
; X64-NEXT:    retq
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
; X86-LABEL: rotate_left_m16:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rolw %cl, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: rotate_left_m16:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rolw %cl, (%rdi)
; X64-NEXT:    retq
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
; X86-LABEL: rotate_right_m16:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    rorw %cl, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: rotate_right_m16:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    rorw %cl, (%rdi)
; X64-NEXT:    retq
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

define i32 @rotate_demanded_bits(i32, i32) {
; X86-LABEL: rotate_demanded_bits:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    andb $30, %cl
; X86-NEXT:    roll %cl, %eax
; X86-NEXT:    retl
;
; X64-LABEL: rotate_demanded_bits:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $30, %cl
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    roll %cl, %eax
; X64-NEXT:    retq
  %3 = and i32 %1, 30
  %4 = shl i32 %0, %3
  %5 = sub nsw i32 0, %3
  %6 = and i32 %5, 30
  %7 = lshr i32 %0, %6
  %8 = or i32 %7, %4
  ret i32 %8
}

define i32 @rotate_demanded_bits_2(i32, i32) {
; X86-LABEL: rotate_demanded_bits_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    andb $23, %cl
; X86-NEXT:    roll %cl, %eax
; X86-NEXT:    retl
;
; X64-LABEL: rotate_demanded_bits_2:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andb $23, %cl
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    roll %cl, %eax
; X64-NEXT:    retq
  %3 = and i32 %1, 23
  %4 = shl i32 %0, %3
  %5 = sub nsw i32 0, %3
  %6 = and i32 %5, 31
  %7 = lshr i32 %0, %6
  %8 = or i32 %7, %4
  ret i32 %8
}

define i32 @rotate_demanded_bits_3(i32, i32) {
; X86-LABEL: rotate_demanded_bits_3:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    addb %cl, %cl
; X86-NEXT:    andb $30, %cl
; X86-NEXT:    roll %cl, %eax
; X86-NEXT:    retl
;
; X64-LABEL: rotate_demanded_bits_3:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    addb %cl, %cl
; X64-NEXT:    andb $30, %cl
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    roll %cl, %eax
; X64-NEXT:    retq
  %3 = shl i32 %1, 1
  %4 = and i32 %3, 30
  %5 = shl i32 %0, %4
  %6 = sub i32 0, %3
  %7 = and i32 %6, 30
  %8 = lshr i32 %0, %7
  %9 = or i32 %5, %8
  ret i32 %9
}
