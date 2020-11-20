; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux -mattr=-avx | FileCheck %s -check-prefix=X64
; Win64 has not supported byval yet.
; RUN: llc < %s -mtriple=i686-- -mattr=-avx | FileCheck %s -check-prefix=X86

%struct.s = type { i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8, i8, i8, i8, i8, i8, i8, i8,
                   i8 }


define void @g(i8 signext  %a1, i8 signext  %a2, i8 signext  %a3, i8 signext  %a4, i8 signext  %a5, i8 signext  %a6) nounwind {
; X64-LABEL: g:
; X64:       # %bb.0: # %entry
; X64-NEXT:    pushq %rbx
; X64-NEXT:    subq $272, %rsp # imm = 0x110
; X64-NEXT:    movb %dil, {{[0-9]+}}(%rsp)
; X64-NEXT:    movb %sil, {{[0-9]+}}(%rsp)
; X64-NEXT:    movb %dl, {{[0-9]+}}(%rsp)
; X64-NEXT:    movb %cl, {{[0-9]+}}(%rsp)
; X64-NEXT:    movb %r8b, {{[0-9]+}}(%rsp)
; X64-NEXT:    movb %r9b, {{[0-9]+}}(%rsp)
; X64-NEXT:    leaq {{[0-9]+}}(%rsp), %rbx
; X64-NEXT:    movl $16, %ecx
; X64-NEXT:    movq %rsp, %rdi
; X64-NEXT:    movq %rbx, %rsi
; X64-NEXT:    rep;movsq (%rsi), %es:(%rdi)
; X64-NEXT:    movb {{[0-9]+}}(%rsp), %al
; X64-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; X64-NEXT:    callq f
; X64-NEXT:    movl $16, %ecx
; X64-NEXT:    movq %rsp, %rdi
; X64-NEXT:    movq %rbx, %rsi
; X64-NEXT:    rep;movsq (%rsi), %es:(%rdi)
; X64-NEXT:    movb {{[0-9]+}}(%rsp), %al
; X64-NEXT:    movb %al, {{[0-9]+}}(%rsp)
; X64-NEXT:    callq f
; X64-NEXT:    addq $272, %rsp # imm = 0x110
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
; X86-NEXT:    andl $-8, %esp
; X86-NEXT:    subl $272, %esp # imm = 0x110
; X86-NEXT:    movb 28(%ebp), %al
; X86-NEXT:    movb 24(%ebp), %cl
; X86-NEXT:    movb 20(%ebp), %dl
; X86-NEXT:    movb 16(%ebp), %ah
; X86-NEXT:    movb 12(%ebp), %ch
; X86-NEXT:    movb 8(%ebp), %dh
; X86-NEXT:    movb %dh, {{[0-9]+}}(%esp)
; X86-NEXT:    movb %ch, {{[0-9]+}}(%esp)
; X86-NEXT:    movb %ah, {{[0-9]+}}(%esp)
; X86-NEXT:    movb %dl, {{[0-9]+}}(%esp)
; X86-NEXT:    movb %cl, {{[0-9]+}}(%esp)
; X86-NEXT:    movb %al, {{[0-9]+}}(%esp)
; X86-NEXT:    leal {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    movl $32, %ecx
; X86-NEXT:    movl %esp, %edi
; X86-NEXT:    movl %ebx, %esi
; X86-NEXT:    rep;movsl (%esi), %es:(%edi)
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movb %al, {{[0-9]+}}(%esp)
; X86-NEXT:    calll f
; X86-NEXT:    movl $32, %ecx
; X86-NEXT:    movl %esp, %edi
; X86-NEXT:    movl %ebx, %esi
; X86-NEXT:    rep;movsl (%esi), %es:(%edi)
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movb %al, {{[0-9]+}}(%esp)
; X86-NEXT:    calll f
; X86-NEXT:    leal -12(%ebp), %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl
entry:
        %a = alloca %struct.s
        %tmp = getelementptr %struct.s, %struct.s* %a, i32 0, i32 0
        store i8 %a1, i8* %tmp, align 8
        %tmp2 = getelementptr %struct.s, %struct.s* %a, i32 0, i32 1
        store i8 %a2, i8* %tmp2, align 8
        %tmp4 = getelementptr %struct.s, %struct.s* %a, i32 0, i32 2
        store i8 %a3, i8* %tmp4, align 8
        %tmp6 = getelementptr %struct.s, %struct.s* %a, i32 0, i32 3
        store i8 %a4, i8* %tmp6, align 8
        %tmp8 = getelementptr %struct.s, %struct.s* %a, i32 0, i32 4
        store i8 %a5, i8* %tmp8, align 8
        %tmp10 = getelementptr %struct.s, %struct.s* %a, i32 0, i32 5
        store i8 %a6, i8* %tmp10, align 8
        call void @f(%struct.s* byval(%struct.s) %a)
        call void @f(%struct.s* byval(%struct.s) %a)
        ret void
}

declare void @f(%struct.s* byval(%struct.s))
