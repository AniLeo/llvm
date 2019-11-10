; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=CHECK,X64

define i1 @t32_3_1(i32 %X) nounwind {
; X86-LABEL: t32_3_1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-1431655765, %edx # imm = 0xAAAAAAAB
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl %edx
; X86-NEXT:    leal (%edx,%edx,2), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $1, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_3_1:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $2863311531, %ecx # imm = 0xAAAAAAAB
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $33, %rcx
; X64-NEXT:    leal (%rcx,%rcx,2), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $1, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 3
  %cmp = icmp eq i32 %urem, 1
  ret i1 %cmp
}

define i1 @t32_3_2(i32 %X) nounwind {
; X86-LABEL: t32_3_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-1431655765, %edx # imm = 0xAAAAAAAB
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl %edx
; X86-NEXT:    leal (%edx,%edx,2), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $2, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_3_2:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $2863311531, %ecx # imm = 0xAAAAAAAB
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $33, %rcx
; X64-NEXT:    leal (%rcx,%rcx,2), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $2, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 3
  %cmp = icmp eq i32 %urem, 2
  ret i1 %cmp
}


define i1 @t32_5_1(i32 %X) nounwind {
; X86-LABEL: t32_5_1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-858993459, %edx # imm = 0xCCCCCCCD
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $2, %edx
; X86-NEXT:    leal (%edx,%edx,4), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $1, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_5_1:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $3435973837, %ecx # imm = 0xCCCCCCCD
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    leal (%rcx,%rcx,4), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $1, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 5
  %cmp = icmp eq i32 %urem, 1
  ret i1 %cmp
}

define i1 @t32_5_2(i32 %X) nounwind {
; X86-LABEL: t32_5_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-858993459, %edx # imm = 0xCCCCCCCD
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $2, %edx
; X86-NEXT:    leal (%edx,%edx,4), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $2, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_5_2:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $3435973837, %ecx # imm = 0xCCCCCCCD
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    leal (%rcx,%rcx,4), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $2, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 5
  %cmp = icmp eq i32 %urem, 2
  ret i1 %cmp
}

define i1 @t32_5_3(i32 %X) nounwind {
; X86-LABEL: t32_5_3:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-858993459, %edx # imm = 0xCCCCCCCD
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $2, %edx
; X86-NEXT:    leal (%edx,%edx,4), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $3, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_5_3:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $3435973837, %ecx # imm = 0xCCCCCCCD
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    leal (%rcx,%rcx,4), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $3, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 5
  %cmp = icmp eq i32 %urem, 3
  ret i1 %cmp
}

define i1 @t32_5_4(i32 %X) nounwind {
; X86-LABEL: t32_5_4:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-858993459, %edx # imm = 0xCCCCCCCD
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl $2, %edx
; X86-NEXT:    leal (%edx,%edx,4), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $4, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_5_4:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $3435973837, %ecx # imm = 0xCCCCCCCD
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    leal (%rcx,%rcx,4), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $4, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 5
  %cmp = icmp eq i32 %urem, 4
  ret i1 %cmp
}


define i1 @t32_6_1(i32 %X) nounwind {
; X86-LABEL: t32_6_1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-1431655765, %edx # imm = 0xAAAAAAAB
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl %edx
; X86-NEXT:    andl $-2, %edx
; X86-NEXT:    leal (%edx,%edx,2), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $1, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_6_1:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $2863311531, %ecx # imm = 0xAAAAAAAB
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    addl %ecx, %ecx
; X64-NEXT:    leal (%rcx,%rcx,2), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $1, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 6
  %cmp = icmp eq i32 %urem, 1
  ret i1 %cmp
}

define i1 @t32_6_2(i32 %X) nounwind {
; X86-LABEL: t32_6_2:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-1431655765, %edx # imm = 0xAAAAAAAB
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl %edx
; X86-NEXT:    andl $-2, %edx
; X86-NEXT:    leal (%edx,%edx,2), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $2, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_6_2:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $2863311531, %ecx # imm = 0xAAAAAAAB
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    addl %ecx, %ecx
; X64-NEXT:    leal (%rcx,%rcx,2), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $2, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 6
  %cmp = icmp eq i32 %urem, 2
  ret i1 %cmp
}

define i1 @t32_6_3(i32 %X) nounwind {
; X86-LABEL: t32_6_3:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-1431655765, %edx # imm = 0xAAAAAAAB
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl %edx
; X86-NEXT:    andl $-2, %edx
; X86-NEXT:    leal (%edx,%edx,2), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $3, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_6_3:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $2863311531, %ecx # imm = 0xAAAAAAAB
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    addl %ecx, %ecx
; X64-NEXT:    leal (%rcx,%rcx,2), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $3, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 6
  %cmp = icmp eq i32 %urem, 3
  ret i1 %cmp
}

define i1 @t32_6_4(i32 %X) nounwind {
; X86-LABEL: t32_6_4:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-1431655765, %edx # imm = 0xAAAAAAAB
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl %edx
; X86-NEXT:    andl $-2, %edx
; X86-NEXT:    leal (%edx,%edx,2), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $4, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_6_4:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $2863311531, %ecx # imm = 0xAAAAAAAB
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    addl %ecx, %ecx
; X64-NEXT:    leal (%rcx,%rcx,2), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $4, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 6
  %cmp = icmp eq i32 %urem, 4
  ret i1 %cmp
}

define i1 @t32_6_5(i32 %X) nounwind {
; X86-LABEL: t32_6_5:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl $-1431655765, %edx # imm = 0xAAAAAAAB
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    mull %edx
; X86-NEXT:    shrl %edx
; X86-NEXT:    andl $-2, %edx
; X86-NEXT:    leal (%edx,%edx,2), %eax
; X86-NEXT:    subl %eax, %ecx
; X86-NEXT:    cmpl $5, %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t32_6_5:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    movl $2863311531, %ecx # imm = 0xAAAAAAAB
; X64-NEXT:    imulq %rax, %rcx
; X64-NEXT:    shrq $34, %rcx
; X64-NEXT:    addl %ecx, %ecx
; X64-NEXT:    leal (%rcx,%rcx,2), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpl $5, %edi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i32 %X, 6
  %cmp = icmp eq i32 %urem, 5
  ret i1 %cmp
}

;-------------------------------------------------------------------------------
; Other widths.

define i1 @t16_3_2(i16 %X) nounwind {
; X86-LABEL: t16_3_2:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    imull $43691, %eax, %ecx # imm = 0xAAAB
; X86-NEXT:    shrl $17, %ecx
; X86-NEXT:    leal (%ecx,%ecx,2), %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    cmpw $2, %ax
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t16_3_2:
; X64:       # %bb.0:
; X64-NEXT:    movzwl %di, %eax
; X64-NEXT:    imull $43691, %eax, %eax # imm = 0xAAAB
; X64-NEXT:    shrl $17, %eax
; X64-NEXT:    leal (%rax,%rax,2), %eax
; X64-NEXT:    subl %eax, %edi
; X64-NEXT:    cmpw $2, %di
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i16 %X, 3
  %cmp = icmp eq i16 %urem, 2
  ret i1 %cmp
}

define i1 @t8_3_2(i8 %X) nounwind {
; X86-LABEL: t8_3_2:
; X86:       # %bb.0:
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    imull $171, %eax, %ecx
; X86-NEXT:    shrl $9, %ecx
; X86-NEXT:    leal (%ecx,%ecx,2), %ecx
; X86-NEXT:    subb %cl, %al
; X86-NEXT:    cmpb $2, %al
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X64-LABEL: t8_3_2:
; X64:       # %bb.0:
; X64-NEXT:    movzbl %dil, %eax
; X64-NEXT:    imull $171, %eax, %ecx
; X64-NEXT:    shrl $9, %ecx
; X64-NEXT:    leal (%rcx,%rcx,2), %ecx
; X64-NEXT:    subb %cl, %al
; X64-NEXT:    cmpb $2, %al
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i8 %X, 3
  %cmp = icmp eq i8 %urem, 2
  ret i1 %cmp
}

define i1 @t64_3_2(i64 %X) nounwind {
; X86-LABEL: t64_3_2:
; X86:       # %bb.0:
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    pushl $0
; X86-NEXT:    pushl $3
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-NEXT:    calll __umoddi3
; X86-NEXT:    addl $16, %esp
; X86-NEXT:    xorl $2, %eax
; X86-NEXT:    orl %edx, %eax
; X86-NEXT:    sete %al
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    retl
;
; X64-LABEL: t64_3_2:
; X64:       # %bb.0:
; X64-NEXT:    movabsq $-6148914691236517205, %rcx # imm = 0xAAAAAAAAAAAAAAAB
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    mulq %rcx
; X64-NEXT:    shrq %rdx
; X64-NEXT:    leaq (%rdx,%rdx,2), %rax
; X64-NEXT:    subq %rax, %rdi
; X64-NEXT:    cmpq $2, %rdi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
  %urem = urem i64 %X, 3
  %cmp = icmp eq i64 %urem, 2
  ret i1 %cmp
}
