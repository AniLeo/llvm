; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s

declare void @use(i8)

define i8 @add_and_xor(i8 %x, i8 %y) {
; CHECK-LABEL: add_and_xor:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %xor = xor i8 %x, -1
  %and = and i8 %xor, %y
  %add = add i8 %and, %x
  ret i8 %add
}

define i8 @add_and_xor_wrong_const(i8 %x, i8 %y) {
; CHECK-LABEL: add_and_xor_wrong_const:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    xorb $-2, %al
; CHECK-NEXT:    andb %sil, %al
; CHECK-NEXT:    addb %dil, %al
; CHECK-NEXT:    retq
  %xor = xor i8 %x, -2
  %and = and i8 %xor, %y
  %add = add i8 %and, %x
  ret i8 %add
}

define i8 @add_and_xor_wrong_op(i8 %x, i8 %y, i8 %z) {
; CHECK-LABEL: add_and_xor_wrong_op:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $edx killed $edx def $rdx
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    notb %dl
; CHECK-NEXT:    andb %sil, %dl
; CHECK-NEXT:    leal (%rdx,%rdi), %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %xor = xor i8 %z, -1
  %and = and i8 %xor, %y
  %add = add i8 %and, %x
  ret i8 %add
}

define i8 @add_and_xor_commuted1(i8 %x, i8 %y) {
; CHECK-LABEL: add_and_xor_commuted1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %xor = xor i8 %x, -1
  %and = and i8 %y, %xor
  %add = add i8 %and, %x
  ret i8 %add
}

define i8 @add_and_xor_commuted2(i8 %x, i8 %y) {
; CHECK-LABEL: add_and_xor_commuted2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %xor = xor i8 %x, -1
  %and = and i8 %xor, %y
  %add = add i8 %x, %and
  ret i8 %add
}

define i8 @add_and_xor_commuted3(i8 %x, i8 %y) {
; CHECK-LABEL: add_and_xor_commuted3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
  %xor = xor i8 %x, -1
  %and = and i8 %y, %xor
  %add = add i8 %x, %and
  ret i8 %add
}

define i8 @add_and_xor_extra_use(i8 %x, i8 %y) nounwind {
; CHECK-LABEL: add_and_xor_extra_use:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    pushq %r14
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    movl %esi, %ebx
; CHECK-NEXT:    movl %edi, %r14d
; CHECK-NEXT:    movl %r14d, %eax
; CHECK-NEXT:    notb %al
; CHECK-NEXT:    movzbl %al, %ebp
; CHECK-NEXT:    movl %ebp, %edi
; CHECK-NEXT:    callq use@PLT
; CHECK-NEXT:    andb %bl, %bpl
; CHECK-NEXT:    movzbl %bpl, %edi
; CHECK-NEXT:    callq use@PLT
; CHECK-NEXT:    orb %r14b, %bl
; CHECK-NEXT:    movl %ebx, %eax
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %r14
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
  %xor = xor i8 %x, -1
  call void @use(i8 %xor)
  %and = and i8 %xor, %y
  call void @use(i8 %and)
  %add = add i8 %and, %x
  ret i8 %add
}

define i64 @add_and_xor_const(i64 %x) {
; CHECK-LABEL: add_and_xor_const:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    orq $1, %rax
; CHECK-NEXT:    retq
  %xor = xor i64 %x, -1
  %and = and i64 %xor, 1
  %add = add i64 %and, %x
  ret i64 %add
}

define i64 @add_and_xor_const_wrong_op(i64 %x, i64 %y) {
; CHECK-LABEL: add_and_xor_const_wrong_op:
; CHECK:       # %bb.0:
; CHECK-NEXT:    notl %esi
; CHECK-NEXT:    andl $1, %esi
; CHECK-NEXT:    leaq (%rsi,%rdi), %rax
; CHECK-NEXT:    retq
  %xor = xor i64 %y, -1
  %and = and i64 %xor, 1
  %add = add i64 %and, %x
  ret i64 %add
}

define i64 @add_and_xor_const_explicit_trunc(i64 %x) {
; CHECK-LABEL: add_and_xor_const_explicit_trunc:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    orq $1, %rax
; CHECK-NEXT:    retq
  %trunc = trunc i64 %x to i32
  %xor = xor i32 %trunc, -1
  %ext = sext i32 %xor to i64
  %and = and i64 %ext, 1
  %add = add i64 %and, %x
  ret i64 %add
}

define i64 @add_and_xor_const_explicit_trunc_wrong_mask(i64 %x) {
; CHECK-LABEL: add_and_xor_const_explicit_trunc_wrong_mask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    notl %eax
; CHECK-NEXT:    movslq %eax, %rcx
; CHECK-NEXT:    movabsq $4294967297, %rax # imm = 0x100000001
; CHECK-NEXT:    andq %rcx, %rax
; CHECK-NEXT:    addq %rdi, %rax
; CHECK-NEXT:    retq
  %trunc = trunc i64 %x to i32
  %xor = xor i32 %trunc, -1
  %ext = sext i32 %xor to i64
  %and = and i64 %ext, 4294967297
  %add = add i64 %and, %x
  ret i64 %add
}

define i8* @gep_and_xor(i8* %a, i64 %m) {
; CHECK-LABEL: gep_and_xor:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    orq %rsi, %rax
; CHECK-NEXT:    retq
  %old = ptrtoint i8* %a to i64
  %old.not = and i64 %old, %m
  %offset = xor i64 %old.not, %m
  %p = getelementptr i8, i8* %a, i64 %offset
  ret i8* %p
}

define i8* @gep_and_xor_const(i8* %a) {
; CHECK-LABEL: gep_and_xor_const:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    orq $1, %rax
; CHECK-NEXT:    retq
  %old = ptrtoint i8* %a to i64
  %old.not = and i64 %old, 1
  %offset = xor i64 %old.not, 1
  %p = getelementptr i8, i8* %a, i64 %offset
  ret i8* %p
}
