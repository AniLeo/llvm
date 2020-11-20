; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux -mattr=-avx | FileCheck %s -check-prefix=X64
; Win64 has not supported byval yet.
; RUN: llc < %s -mtriple=i686-- -mattr=-avx | FileCheck %s -check-prefix=X86

%struct.s = type { i64, i64, i64, i64, i64, i64, i64, i64,
                   i64, i64, i64, i64, i64, i64, i64, i64,
                   i64 }

define void @g(i64 %a, i64 %b, i64 %c) nounwind {
; X64-LABEL: g:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rbx
; X64-NEXT:    subq $288, %rsp # imm = 0x120
; X64-NEXT:    movq %rdi, {{[0-9]+}}(%rsp)
; X64-NEXT:    movq %rsi, {{[0-9]+}}(%rsp)
; X64-NEXT:    movq %rdx, {{[0-9]+}}(%rsp)
; X64-NEXT:    leaq {{[0-9]+}}(%rsp), %rbx
; X64-NEXT:    movl $17, %ecx
; X64-NEXT:    movq %rsp, %rdi
; X64-NEXT:    movq %rbx, %rsi
; X64-NEXT:    rep;movsq (%rsi), %es:(%rdi)
; X64-NEXT:    callq f
; X64-NEXT:    movl $17, %ecx
; X64-NEXT:    movq %rsp, %rdi
; X64-NEXT:    movq %rbx, %rsi
; X64-NEXT:    rep;movsq (%rsi), %es:(%rdi)
; X64-NEXT:    callq f
; X64-NEXT:    addq $288, %rsp # imm = 0x120
; X64-NEXT:    popq %rbx
; X64-NEXT:    retq
;
; X86-LABEL: g:
; X86:       # %bb.0: # %entry
; X86-NEXT:    pushl %ebp
; X86-NEXT:    movl %esp, %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    andl $-16, %esp
; X86-NEXT:    subl $288, %esp # imm = 0x120
; X86-NEXT:    movl 12(%ebp), %eax
; X86-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; X86-NEXT:    movl 8(%ebp), %eax
; X86-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; X86-NEXT:    movl 20(%ebp), %eax
; X86-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; X86-NEXT:    movl 16(%ebp), %eax
; X86-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; X86-NEXT:    movl 28(%ebp), %eax
; X86-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; X86-NEXT:    movl 24(%ebp), %eax
; X86-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; X86-NEXT:    leal {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    movl $34, %ecx
; X86-NEXT:    movl %esp, %edi
; X86-NEXT:    movl %ebx, %esi
; X86-NEXT:    rep;movsl (%esi), %es:(%edi)
; X86-NEXT:    calll f
; X86-NEXT:    movl $34, %ecx
; X86-NEXT:    movl %esp, %edi
; X86-NEXT:    movl %ebx, %esi
; X86-NEXT:    rep;movsl (%esi), %es:(%edi)
; X86-NEXT:    calll f
; X86-NEXT:    leal -12(%ebp), %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
entry:
	%d = alloca %struct.s, align 16
	%tmp = getelementptr %struct.s, %struct.s* %d, i32 0, i32 0
	store i64 %a, i64* %tmp, align 16
	%tmp2 = getelementptr %struct.s, %struct.s* %d, i32 0, i32 1
	store i64 %b, i64* %tmp2, align 16
	%tmp4 = getelementptr %struct.s, %struct.s* %d, i32 0, i32 2
	store i64 %c, i64* %tmp4, align 16
	call void @f(%struct.s* byval(%struct.s) %d)
	call void @f(%struct.s* byval(%struct.s) %d)
	ret void
}

declare void @f(%struct.s* byval(%struct.s))
