; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown -verify-machineinstrs | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686-unknown -verify-machineinstrs | FileCheck %s --check-prefix=X86

; This test is targeted at 64-bit mode. It used to crash due to the creation of an EXTRACT_SUBREG after the peephole pass had ran.
define void @f() {
; X64-LABEL: f:
; X64:       # %bb.0: # %BB
; X64-NEXT:    pushq %rbp
; X64-NEXT:    .cfi_def_cfa_offset 16
; X64-NEXT:    pushq %r14
; X64-NEXT:    .cfi_def_cfa_offset 24
; X64-NEXT:    pushq %rbx
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    subq $16, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 48
; X64-NEXT:    .cfi_offset %rbx, -32
; X64-NEXT:    .cfi_offset %r14, -24
; X64-NEXT:    .cfi_offset %rbp, -16
; X64-NEXT:    movzbl {{[0-9]+}}(%rsp), %ebx
; X64-NEXT:    movq %rbx, %rcx
; X64-NEXT:    shlq $62, %rcx
; X64-NEXT:    sarq $62, %rcx
; X64-NEXT:    movq (%rsp), %r14
; X64-NEXT:    movb (%rax), %bpl
; X64-NEXT:    xorl %edi, %edi
; X64-NEXT:    xorl %esi, %esi
; X64-NEXT:    movq %r14, %rdx
; X64-NEXT:    callq __modti3
; X64-NEXT:    andl $3, %edx
; X64-NEXT:    cmpq %rax, %r14
; X64-NEXT:    sbbq %rdx, %rbx
; X64-NEXT:    setb %sil
; X64-NEXT:    setae %bl
; X64-NEXT:    testb %al, %al
; X64-NEXT:    setne %dl
; X64-NEXT:    setne (%rax)
; X64-NEXT:    movzbl %bpl, %eax
; X64-NEXT:    xorl %ecx, %ecx
; X64-NEXT:    subb %sil, %cl
; X64-NEXT:    # kill: def $eax killed $eax def $ax
; X64-NEXT:    divb %al
; X64-NEXT:    negb %bl
; X64-NEXT:    cmpb %al, %al
; X64-NEXT:    setle %al
; X64-NEXT:    negb %al
; X64-NEXT:    cbtw
; X64-NEXT:    idivb %bl
; X64-NEXT:    movsbl %ah, %eax
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    andl $1, %eax
; X64-NEXT:    shlq $4, %rax
; X64-NEXT:    negq %rax
; X64-NEXT:    negb %dl
; X64-NEXT:    leaq -16(%rsp,%rax), %rax
; X64-NEXT:    movq %rax, (%rax)
; X64-NEXT:    movl %ecx, %eax
; X64-NEXT:    cbtw
; X64-NEXT:    idivb %dl
; X64-NEXT:    movsbl %ah, %eax
; X64-NEXT:    andb $1, %al
; X64-NEXT:    movb %al, (%rax)
; X64-NEXT:    addq $16, %rsp
; X64-NEXT:    .cfi_def_cfa_offset 32
; X64-NEXT:    popq %rbx
; X64-NEXT:    .cfi_def_cfa_offset 24
; X64-NEXT:    popq %r14
; X64-NEXT:    .cfi_def_cfa_offset 16
; X64-NEXT:    popq %rbp
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
;
; X86-LABEL: f:
; X86:       # %bb.0: # %BB
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $48, %esp
; X86-NEXT:    .cfi_offset %esi, -20
; X86-NEXT:    .cfi_offset %edi, -16
; X86-NEXT:    .cfi_offset %ebx, -12
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    shll $30, %eax
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    sarl $30, %ecx
; X86-NEXT:    sarl $31, %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    movb (%eax), %dl
; X86-NEXT:    movb %dl, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    leal {{[0-9]+}}(%esp), %edx
; X86-NEXT:    pushl %eax
; X86-NEXT:    pushl %ecx
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl %edx
; X86-NEXT:    calll __modti3
; X86-NEXT:    addl $32, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    andl $3, %eax
; X86-NEXT:    xorl %ecx, %ecx
; X86-NEXT:    cmpl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    sbbl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    sbbl %eax, %esi
; X86-NEXT:    sbbl $0, %ecx
; X86-NEXT:    setae %dl
; X86-NEXT:    sbbb %cl, %cl
; X86-NEXT:    testb %al, %al
; X86-NEXT:    setne %ch
; X86-NEXT:    setne (%eax)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %dh # 1-byte Reload
; X86-NEXT:    movzbl %dh, %eax
; X86-NEXT:    # kill: def $eax killed $eax def $ax
; X86-NEXT:    divb %dh
; X86-NEXT:    negb %ch
; X86-NEXT:    negb %dl
; X86-NEXT:    cmpb %al, %al
; X86-NEXT:    setle %al
; X86-NEXT:    negb %al
; X86-NEXT:    cbtw
; X86-NEXT:    idivb %dl
; X86-NEXT:    movsbl %ah, %eax
; X86-NEXT:    movzbl %al, %eax
; X86-NEXT:    andl $1, %eax
; X86-NEXT:    negl %eax
; X86-NEXT:    leal (%eax,%eax,2), %eax
; X86-NEXT:    leal -4(%esp,%eax,4), %eax
; X86-NEXT:    movl %eax, (%eax)
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    cbtw
; X86-NEXT:    idivb %ch
; X86-NEXT:    movsbl %ah, %eax
; X86-NEXT:    andb $1, %al
; X86-NEXT:    movb %al, (%eax)
; X86-NEXT:    leal -12(%ebp), %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl
BB:
  %A30 = alloca i66
  %L17 = load i66, i66* %A30
  %B20 = and i66 %L17, -1
  %G2 = getelementptr i66, i66* %A30, i1 true
  %L10 = load i8, i8* undef
  %B6 = udiv i8 %L10, %L10
  %C15 = icmp eq i8 undef, 0
  %B8 = srem i66 0, %B20
  %C2 = icmp ule i66 %B8, %B20
  %B5 = or i8 0, %B6
  %C19 = icmp uge i1 false, %C2
  %C1 = icmp sle i8 undef, %B5
  %B37 = srem i1 %C1, %C2
  %C7 = icmp uge i1 false, %C15
  store i1 %C7, i1* undef
  %G6 = getelementptr i66, i66* %G2, i1 %B37
  store i66* %G6, i66** undef
  %B30 = srem i1 %C19, %C7
  store i1 %B30, i1* undef
  ret void
}

; Similar to above, but bitwidth adjusted to target 32-bit mode. This also shows that we didn't constrain the register class when extracting a subreg.
define void @g() {
; X64-LABEL: g:
; X64:       # %bb.0: # %BB
; X64-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; X64-NEXT:    movzbl -{{[0-9]+}}(%rsp), %esi
; X64-NEXT:    shlq $32, %rsi
; X64-NEXT:    orq %rax, %rsi
; X64-NEXT:    movq %rsi, %rdi
; X64-NEXT:    shlq $30, %rdi
; X64-NEXT:    sarq $30, %rdi
; X64-NEXT:    movb (%rax), %al
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    # kill: def $eax killed $eax def $ax
; X64-NEXT:    divb (%rax)
; X64-NEXT:    movl %eax, %r8d
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    xorl %edx, %edx
; X64-NEXT:    idivq %rdi
; X64-NEXT:    movabsq $17179869183, %rax # imm = 0x3FFFFFFFF
; X64-NEXT:    andq %rdx, %rax
; X64-NEXT:    testb %al, %al
; X64-NEXT:    setne %dil
; X64-NEXT:    setne (%rax)
; X64-NEXT:    cmpq %rsi, %rax
; X64-NEXT:    seta %dl
; X64-NEXT:    setbe %cl
; X64-NEXT:    negb %cl
; X64-NEXT:    cmpb %r8b, %al
; X64-NEXT:    setle %al
; X64-NEXT:    negb %al
; X64-NEXT:    cbtw
; X64-NEXT:    idivb %cl
; X64-NEXT:    movsbl %ah, %eax
; X64-NEXT:    movzbl %al, %eax
; X64-NEXT:    andl $1, %eax
; X64-NEXT:    shlq $3, %rax
; X64-NEXT:    negq %rax
; X64-NEXT:    negb %dil
; X64-NEXT:    negb %dl
; X64-NEXT:    leaq -16(%rsp,%rax), %rax
; X64-NEXT:    movq %rax, (%rax)
; X64-NEXT:    movl %edx, %eax
; X64-NEXT:    cbtw
; X64-NEXT:    idivb %dil
; X64-NEXT:    movsbl %ah, %eax
; X64-NEXT:    andb $1, %al
; X64-NEXT:    movb %al, (%rax)
; X64-NEXT:    retq
;
; X86-LABEL: g:
; X86:       # %bb.0: # %BB
; X86-NEXT:    pushl %ebp
; X86-NEXT:    .cfi_def_cfa_offset 8
; X86-NEXT:    .cfi_offset %ebp, -8
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    .cfi_def_cfa_register %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $16, %esp
; X86-NEXT:    .cfi_offset %esi, -20
; X86-NEXT:    .cfi_offset %edi, -16
; X86-NEXT:    .cfi_offset %ebx, -12
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl %esi, %ecx
; X86-NEXT:    shll $30, %ecx
; X86-NEXT:    sarl $30, %ecx
; X86-NEXT:    movl (%esp), %edi
; X86-NEXT:    movb (%eax), %al
; X86-NEXT:    movzbl %al, %eax
; X86-NEXT:    # kill: def $eax killed $eax def $ax
; X86-NEXT:    divb (%eax)
; X86-NEXT:    movl %eax, %ebx
; X86-NEXT:    pushl %ecx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $0
; X86-NEXT:    calll __moddi3
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    andl $3, %edx
; X86-NEXT:    testb %al, %al
; X86-NEXT:    setne (%eax)
; X86-NEXT:    cmpl %eax, %edi
; X86-NEXT:    sbbl %edx, %esi
; X86-NEXT:    setae %dl
; X86-NEXT:    sbbb %cl, %cl
; X86-NEXT:    testb %al, %al
; X86-NEXT:    setne %ch
; X86-NEXT:    negb %dl
; X86-NEXT:    cmpb %bl, %al
; X86-NEXT:    setle %al
; X86-NEXT:    negb %al
; X86-NEXT:    cbtw
; X86-NEXT:    idivb %dl
; X86-NEXT:    movsbl %ah, %eax
; X86-NEXT:    movzbl %al, %eax
; X86-NEXT:    andl $1, %eax
; X86-NEXT:    shll $3, %eax
; X86-NEXT:    negl %eax
; X86-NEXT:    negb %ch
; X86-NEXT:    leal -8(%esp,%eax), %eax
; X86-NEXT:    movl %eax, (%eax)
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    cbtw
; X86-NEXT:    idivb %ch
; X86-NEXT:    movsbl %ah, %eax
; X86-NEXT:    andb $1, %al
; X86-NEXT:    movb %al, (%eax)
; X86-NEXT:    leal -12(%ebp), %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    .cfi_def_cfa %esp, 4
; X86-NEXT:    retl
BB:
  %A30 = alloca i34
  %L17 = load i34, i34* %A30
  %B20 = and i34 %L17, -1
  %G2 = getelementptr i34, i34* %A30, i1 true
  %L10 = load volatile i8, i8* undef
  %L11 = load volatile i8, i8* undef
  %B6 = udiv i8 %L10, %L11
  %C15 = icmp eq i8 undef, 0
  %B8 = srem i34 0, %B20
  %C2 = icmp ule i34 %B8, %B20
  %B5 = or i8 0, %B6
  %C19 = icmp uge i1 false, %C2
  %C1 = icmp sle i8 undef, %B5
  %B37 = srem i1 %C1, %C2
  %C7 = icmp uge i1 false, %C15
  store i1 %C7, i1* undef
  %G6 = getelementptr i34, i34* %G2, i1 %B37
  store i34* %G6, i34** undef
  %B30 = srem i1 %C19, %C7
  store i1 %B30, i1* undef
  ret void
}
