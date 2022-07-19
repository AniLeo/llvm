; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mtriple=i686-unknown-unknown | FileCheck %s --check-prefix=X86
; RUN: llc < %s -verify-machineinstrs -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=X64

declare i8 @llvm.abs.i8(i8, i1)
declare i16 @llvm.abs.i16(i16, i1)
declare i24 @llvm.abs.i24(i24, i1)
declare i32 @llvm.abs.i32(i32, i1)
declare i64 @llvm.abs.i64(i64, i1)
declare i128 @llvm.abs.i128(i128, i1)

define i8 @neg_abs_i8(i8 %x) nounwind {
; X86-LABEL: neg_abs_i8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    xorb %al, %cl
; X86-NEXT:    subb %cl, %al
; X86-NEXT:    retl
;
; X64-LABEL: neg_abs_i8:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarb $7, %al
; X64-NEXT:    xorb %al, %dil
; X64-NEXT:    subb %dil, %al
; X64-NEXT:    retq
  %abs = tail call i8 @llvm.abs.i8(i8 %x, i1 true)
  %neg = sub nsw i8 0, %abs
  ret i8 %neg
}

define i16 @neg_abs_i16(i16 %x) nounwind {
; X86-LABEL: neg_abs_i16:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movswl %cx, %eax
; X86-NEXT:    sarl $15, %eax
; X86-NEXT:    xorl %eax, %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: neg_abs_i16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    negw %ax
; X64-NEXT:    cmovnsw %di, %ax
; X64-NEXT:    retq
  %abs = tail call i16 @llvm.abs.i16(i16 %x, i1 true)
  %neg = sub nsw i16 0, %abs
  ret i16 %neg
}

define i32 @neg_abs_i32(i32 %x) nounwind {
; X86-LABEL: neg_abs_i32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    sarl $31, %eax
; X86-NEXT:    xorl %eax, %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: neg_abs_i32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    negl %eax
; X64-NEXT:    cmovnsl %edi, %eax
; X64-NEXT:    retq
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 true)
  %neg = sub nsw i32 0, %abs
  ret i32 %neg
}

define i64 @neg_abs_i64(i64 %x) nounwind {
; X86-LABEL: neg_abs_i64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    sarl $31, %edx
; X86-NEXT:    xorl %edx, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    xorl %edx, %esi
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    subl %esi, %eax
; X86-NEXT:    sbbl %ecx, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
;
; X64-LABEL: neg_abs_i64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    negq %rax
; X64-NEXT:    cmovnsq %rdi, %rax
; X64-NEXT:    retq
  %abs = tail call i64 @llvm.abs.i64(i64 %x, i1 true)
  %neg = sub nsw i64 0, %abs
  ret i64 %neg
}

define i128 @neg_abs_i128(i128 %x) nounwind {
; X86-LABEL: neg_abs_i128:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    sarl $31, %ecx
; X86-NEXT:    xorl %ecx, %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    xorl %ecx, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    xorl %ecx, %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    xorl %ecx, %ebx
; X86-NEXT:    movl %ecx, %ebp
; X86-NEXT:    subl %ebx, %ebp
; X86-NEXT:    movl %ecx, %ebx
; X86-NEXT:    sbbl %edi, %ebx
; X86-NEXT:    movl %ecx, %edi
; X86-NEXT:    sbbl %esi, %edi
; X86-NEXT:    sbbl %edx, %ecx
; X86-NEXT:    movl %ebp, (%eax)
; X86-NEXT:    movl %ebx, 4(%eax)
; X86-NEXT:    movl %edi, 8(%eax)
; X86-NEXT:    movl %ecx, 12(%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl $4
;
; X64-LABEL: neg_abs_i128:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rdx
; X64-NEXT:    sarq $63, %rdx
; X64-NEXT:    xorq %rdx, %rsi
; X64-NEXT:    xorq %rdx, %rdi
; X64-NEXT:    movq %rdx, %rax
; X64-NEXT:    subq %rdi, %rax
; X64-NEXT:    sbbq %rsi, %rdx
; X64-NEXT:    retq
  %abs = tail call i128 @llvm.abs.i128(i128 %x, i1 true)
  %neg = sub nsw i128 0, %abs
  ret i128 %neg
}

define i8 @sub_abs_i8(i8 %x, i8 %y) nounwind {
; X86-LABEL: sub_abs_i8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    xorb %al, %cl
; X86-NEXT:    subb %cl, %al
; X86-NEXT:    addb {{[0-9]+}}(%esp), %al
; X86-NEXT:    retl
;
; X64-LABEL: sub_abs_i8:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    sarb $7, %al
; X64-NEXT:    xorb %al, %dil
; X64-NEXT:    subb %dil, %al
; X64-NEXT:    addb %sil, %al
; X64-NEXT:    retq
  %abs = tail call i8 @llvm.abs.i8(i8 %x, i1 false)
  %neg = sub nsw i8 %y, %abs
  ret i8 %neg
}

define i16 @sub_abs_i16(i16 %x, i16 %y) nounwind {
; X86-LABEL: sub_abs_i16:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movswl %cx, %eax
; X86-NEXT:    sarl $15, %eax
; X86-NEXT:    xorl %eax, %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    # kill: def $ax killed $ax killed $eax
; X86-NEXT:    retl
;
; X64-LABEL: sub_abs_i16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    negw %ax
; X64-NEXT:    cmovnsw %di, %ax
; X64-NEXT:    addl %esi, %eax
; X64-NEXT:    # kill: def $ax killed $ax killed $eax
; X64-NEXT:    retq
  %abs = tail call i16 @llvm.abs.i16(i16 %x, i1 false)
  %neg = sub i16 %y, %abs
  ret i16 %neg
}

define i32 @sub_abs_i32(i32 %x, i32 %y) nounwind {
; X86-LABEL: sub_abs_i32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    sarl $31, %eax
; X86-NEXT:    xorl %eax, %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    addl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    retl
;
; X64-LABEL: sub_abs_i32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    negl %eax
; X64-NEXT:    cmovnsl %edi, %eax
; X64-NEXT:    addl %esi, %eax
; X64-NEXT:    retq
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 false)
  %neg = sub i32 %y, %abs
  ret i32 %neg
}

define i64 @sub_abs_i64(i64 %x, i64 %y) nounwind {
; X86-LABEL: sub_abs_i64:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %esi
; X86-NEXT:    sarl $31, %esi
; X86-NEXT:    xorl %esi, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    xorl %esi, %edi
; X86-NEXT:    subl %esi, %edi
; X86-NEXT:    sbbl %esi, %ecx
; X86-NEXT:    subl %edi, %eax
; X86-NEXT:    sbbl %ecx, %edx
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl
;
; X64-LABEL: sub_abs_i64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    negq %rax
; X64-NEXT:    cmovnsq %rdi, %rax
; X64-NEXT:    addq %rsi, %rax
; X64-NEXT:    retq
  %abs = tail call i64 @llvm.abs.i64(i64 %x, i1 false)
  %neg = sub i64 %y, %abs
  ret i64 %neg
}

define i128 @sub_abs_i128(i128 %x, i128 %y) nounwind {
; X86-LABEL: sub_abs_i128:
; X86:       # %bb.0:
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %eax, %edx
; X86-NEXT:    sarl $31, %edx
; X86-NEXT:    xorl %edx, %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    xorl %edx, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    xorl %edx, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    xorl %edx, %edi
; X86-NEXT:    subl %edx, %edi
; X86-NEXT:    sbbl %edx, %esi
; X86-NEXT:    sbbl %edx, %ecx
; X86-NEXT:    sbbl %edx, %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    subl %edi, %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    sbbl %esi, %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    sbbl %ecx, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    sbbl %eax, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl %edx, (%eax)
; X86-NEXT:    movl %edi, 4(%eax)
; X86-NEXT:    movl %esi, 8(%eax)
; X86-NEXT:    movl %ecx, 12(%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    retl $4
;
; X64-LABEL: sub_abs_i128:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdx, %rax
; X64-NEXT:    movq %rsi, %rdx
; X64-NEXT:    sarq $63, %rdx
; X64-NEXT:    xorq %rdx, %rsi
; X64-NEXT:    xorq %rdx, %rdi
; X64-NEXT:    subq %rdx, %rdi
; X64-NEXT:    sbbq %rdx, %rsi
; X64-NEXT:    subq %rdi, %rax
; X64-NEXT:    sbbq %rsi, %rcx
; X64-NEXT:    movq %rcx, %rdx
; X64-NEXT:    retq
  %abs = tail call i128 @llvm.abs.i128(i128 %x, i1 false)
  %neg = sub i128 %y, %abs
  ret i128 %neg
}
