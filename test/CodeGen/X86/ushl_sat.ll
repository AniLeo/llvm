; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i686 -mattr=cmov | FileCheck %s --check-prefix=X86

declare  i4  @llvm.ushl.sat.i4   (i4,  i4)
declare  i8  @llvm.ushl.sat.i8   (i8,  i8)
declare  i15 @llvm.ushl.sat.i15  (i15, i15)
declare  i16 @llvm.ushl.sat.i16  (i16, i16)
declare  i18 @llvm.ushl.sat.i18  (i18, i18)
declare  i32 @llvm.ushl.sat.i32  (i32, i32)
declare  i64 @llvm.ushl.sat.i64  (i64, i64)

define i16 @func(i16 %x, i16 %y) nounwind {
; X64-LABEL: func:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll %cl, %eax
; X64-NEXT:    movzwl %ax, %edx
; X64-NEXT:    movl %edx, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrl %cl, %eax
; X64-NEXT:    cmpw %ax, %di
; X64-NEXT:    movl $65535, %eax # imm = 0xFFFF
; X64-NEXT:    cmovel %edx, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shll %cl, %edx
; X86-NEXT:    movzwl %dx, %edx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shrl %cl, %esi
; X86-NEXT:    cmpw %si, %ax
; X86-NEXT:    movl $65535, %eax # imm = 0xFFFF
; X86-NEXT:    cmovel %edx, %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %tmp = call i16 @llvm.ushl.sat.i16(i16 %x, i16 %y)
  ret i16 %tmp
}

define i16 @func2(i8 %x, i8 %y) nounwind {
; X64-LABEL: func2:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movsbl %dil, %eax
; X64-NEXT:    addl %eax, %eax
; X64-NEXT:    movl %eax, %edx
; X64-NEXT:    shll %cl, %edx
; X64-NEXT:    movzwl %dx, %edx
; X64-NEXT:    movl %edx, %esi
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrl %cl, %esi
; X64-NEXT:    cmpw %si, %ax
; X64-NEXT:    movl $65535, %eax # imm = 0xFFFF
; X64-NEXT:    cmovel %edx, %eax
; X64-NEXT:    cwtl
; X64-NEXT:    shrl %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func2:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movsbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    addl %eax, %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shll %cl, %edx
; X86-NEXT:    movzwl %dx, %edx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shrl %cl, %esi
; X86-NEXT:    cmpw %si, %ax
; X86-NEXT:    movl $65535, %eax # imm = 0xFFFF
; X86-NEXT:    cmovel %edx, %eax
; X86-NEXT:    cwtl
; X86-NEXT:    shrl %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %x2 = sext i8 %x to i15
  %y2 = sext i8 %y to i15
  %tmp = call i15 @llvm.ushl.sat.i15(i15 %x2, i15 %y2)
  %tmp2 = sext i15 %tmp to i16
  ret i16 %tmp2
}

define i16 @func3(i15 %x, i8 %y) nounwind {
; X64-LABEL: func3:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    shll $7, %ecx
; X64-NEXT:    addl %edi, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shll %cl, %eax
; X64-NEXT:    movzwl %ax, %eax
; X64-NEXT:    movl %eax, %edx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrl %cl, %edx
; X64-NEXT:    cmpw %dx, %di
; X64-NEXT:    movl $65535, %ecx # imm = 0xFFFF
; X64-NEXT:    cmovel %eax, %ecx
; X64-NEXT:    movswl %cx, %eax
; X64-NEXT:    shrl %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func3:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    shll $7, %ecx
; X86-NEXT:    addl %eax, %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shll %cl, %edx
; X86-NEXT:    movzwl %dx, %edx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    # kill: def $cl killed $cl killed $ecx
; X86-NEXT:    shrl %cl, %esi
; X86-NEXT:    cmpw %si, %ax
; X86-NEXT:    movl $65535, %eax # imm = 0xFFFF
; X86-NEXT:    cmovel %edx, %eax
; X86-NEXT:    cwtl
; X86-NEXT:    shrl %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %y2 = sext i8 %y to i15
  %y3 = shl i15 %y2, 7
  %tmp = call i15 @llvm.ushl.sat.i15(i15 %x, i15 %y3)
  %tmp2 = sext i15 %tmp to i16
  ret i16 %tmp2
}

define i4 @func4(i4 %x, i4 %y) nounwind {
; X64-LABEL: func4:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    andb $15, %cl
; X64-NEXT:    shlb $4, %dil
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlb %cl, %al
; X64-NEXT:    movzbl %al, %edx
; X64-NEXT:    movl %edx, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrb %cl, %al
; X64-NEXT:    cmpb %al, %dil
; X64-NEXT:    movl $255, %eax
; X64-NEXT:    cmovel %edx, %eax
; X64-NEXT:    shrb $4, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func4:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    andb $15, %cl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    shlb $4, %al
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shlb %cl, %dl
; X86-NEXT:    movzbl %dl, %esi
; X86-NEXT:    shrb %cl, %dl
; X86-NEXT:    cmpb %dl, %al
; X86-NEXT:    movl $255, %eax
; X86-NEXT:    cmovel %esi, %eax
; X86-NEXT:    shrb $4, %al
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %tmp = call i4 @llvm.ushl.sat.i4(i4 %x, i4 %y)
  ret i4 %tmp
}

define i64 @func5(i64 %x, i64 %y) nounwind {
; X64-LABEL: func5:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rcx
; X64-NEXT:    movq %rdi, %rdx
; X64-NEXT:    shlq %cl, %rdx
; X64-NEXT:    movq %rdx, %rax
; X64-NEXT:    # kill: def $cl killed $cl killed $rcx
; X64-NEXT:    shrq %cl, %rax
; X64-NEXT:    cmpq %rax, %rdi
; X64-NEXT:    movq $-1, %rax
; X64-NEXT:    cmoveq %rdx, %rax
; X64-NEXT:    retq
;
; X86-LABEL: func5:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %edi, %esi
; X86-NEXT:    shll %cl, %esi
; X86-NEXT:    shldl %cl, %edi, %edx
; X86-NEXT:    xorl %ebx, %ebx
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    cmovnel %esi, %edx
; X86-NEXT:    cmovnel %ebx, %esi
; X86-NEXT:    movl %edx, %ebp
; X86-NEXT:    shrl %cl, %ebp
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    cmovel %ebp, %ebx
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    shrdl %cl, %edx, %eax
; X86-NEXT:    testb $32, %cl
; X86-NEXT:    cmovnel %ebp, %eax
; X86-NEXT:    xorl %edi, %eax
; X86-NEXT:    xorl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    orl %eax, %ebx
; X86-NEXT:    movl $-1, %eax
; X86-NEXT:    cmovnel %eax, %esi
; X86-NEXT:    cmovnel %eax, %edx
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
  %tmp = call i64 @llvm.ushl.sat.i64(i64 %x, i64 %y)
  ret i64 %tmp
}

define i18 @func6(i16 %x, i16 %y) nounwind {
; X64-LABEL: func6:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movswl %di, %eax
; X64-NEXT:    shll $14, %eax
; X64-NEXT:    movl %eax, %edx
; X64-NEXT:    shll %cl, %edx
; X64-NEXT:    movl %edx, %esi
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrl %cl, %esi
; X64-NEXT:    cmpl %esi, %eax
; X64-NEXT:    movl $-1, %eax
; X64-NEXT:    cmovel %edx, %eax
; X64-NEXT:    shrl $14, %eax
; X64-NEXT:    retq
;
; X86-LABEL: func6:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movswl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    shll $14, %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shll %cl, %edx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shrl %cl, %esi
; X86-NEXT:    cmpl %esi, %eax
; X86-NEXT:    movl $-1, %eax
; X86-NEXT:    cmovel %edx, %eax
; X86-NEXT:    shrl $14, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %x2 = sext i16 %x to i18
  %y2 = sext i16 %y to i18
  %tmp = call i18 @llvm.ushl.sat.i18(i18 %x2, i18 %y2)
  ret i18 %tmp
}

define i32 @func7(i32 %x, i32 %y) nounwind {
; X64-LABEL: func7:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %edx
; X64-NEXT:    shll %cl, %edx
; X64-NEXT:    movl %edx, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrl %cl, %eax
; X64-NEXT:    cmpl %eax, %edi
; X64-NEXT:    movl $-1, %eax
; X64-NEXT:    cmovel %edx, %eax
; X64-NEXT:    retq
;
; X86-LABEL: func7:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shll %cl, %edx
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    shrl %cl, %esi
; X86-NEXT:    cmpl %esi, %eax
; X86-NEXT:    movl $-1, %eax
; X86-NEXT:    cmovel %edx, %eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %tmp = call i32 @llvm.ushl.sat.i32(i32 %x, i32 %y)
  ret i32 %tmp
}

define i8 @func8(i8 %x, i8 %y) nounwind {
; X64-LABEL: func8:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %ecx
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    shlb %cl, %al
; X64-NEXT:    movzbl %al, %edx
; X64-NEXT:    movl %edx, %eax
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrb %cl, %al
; X64-NEXT:    cmpb %al, %dil
; X64-NEXT:    movl $255, %eax
; X64-NEXT:    cmovel %edx, %eax
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: func8:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    shlb %cl, %dl
; X86-NEXT:    movzbl %dl, %esi
; X86-NEXT:    shrb %cl, %dl
; X86-NEXT:    cmpb %dl, %al
; X86-NEXT:    movl $255, %eax
; X86-NEXT:    cmovel %esi, %eax
; X86-NEXT:    # kill: def $al killed $al killed $eax
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %tmp = call i8 @llvm.ushl.sat.i8(i8 %x, i8 %y)
  ret i8 %tmp
}
