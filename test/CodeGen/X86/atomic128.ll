; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-macosx10.9 -verify-machineinstrs -mattr=cx16 | FileCheck %s
; RUN: llc < %s -mtriple=i386-linux-gnu -verify-machineinstrs -mattr=cx16 | FileCheck %s -check-prefixes=CHECK32
; RUN: llc < %s -mtriple=i386-linux-gnu -verify-machineinstrs -mattr=-cx16 | FileCheck %s -check-prefixes=CHECK32

@var = global i128 0

; Due to the scheduling right after isel for cmpxchg and given the
; machine scheduler and copy coalescer do not mess up with physical
; register live-ranges, we end up with a useless copy.
define i128 @val_compare_and_swap(ptr %p, i128 %oldval, i128 %newval) {
; CHECK-LABEL: val_compare_and_swap:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rcx, %rbx
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: val_compare_and_swap:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %edi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 12
; CHECK32-NEXT:    subl $20, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -12
; CHECK32-NEXT:    .cfi_offset %edi, -8
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_val_compare_and_swap_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $44, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -44
; CHECK32-NEXT:    movl (%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK32-NEXT:    movl %edi, 8(%esi)
; CHECK32-NEXT:    movl %edx, 12(%esi)
; CHECK32-NEXT:    movl %eax, (%esi)
; CHECK32-NEXT:    movl %ecx, 4(%esi)
; CHECK32-NEXT:    movl %esi, %eax
; CHECK32-NEXT:    addl $20, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 12
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %edi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl $4
  %pair = cmpxchg ptr %p, i128 %oldval, i128 %newval acquire acquire
  %val = extractvalue { i128, i1 } %pair, 0
  ret i128 %val
}

@cmpxchg16b_global = external dso_local global { i128, i128 }, align 16

;; Make sure we retain the offset of the global variable.
define void @cmpxchg16b_global_with_offset() nounwind {
; CHECK-LABEL: cmpxchg16b_global_with_offset:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    xorl %ebx, %ebx
; CHECK-NEXT:    lock cmpxchg16b _cmpxchg16b_global+16(%rip)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: cmpxchg16b_global_with_offset:
; CHECK32:       # %bb.0: # %entry
; CHECK32-NEXT:    subl $36, %esp
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    pushl $cmpxchg16b_global+16
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    calll __sync_val_compare_and_swap_16
; CHECK32-NEXT:    addl $72, %esp
; CHECK32-NEXT:    retl
entry:
  %0 = load atomic i128, ptr getelementptr inbounds ({i128, i128}, ptr @cmpxchg16b_global, i64 0, i32 1) acquire, align 16
  ret void
}

define void @fetch_and_nand(ptr %p, i128 %bits) {
; CHECK-LABEL: fetch_and_nand:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB2_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    andq %r8, %rcx
; CHECK-NEXT:    movq %rax, %rbx
; CHECK-NEXT:    andq %rsi, %rbx
; CHECK-NEXT:    notq %rbx
; CHECK-NEXT:    notq %rcx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB2_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    movq %rax, _var(%rip)
; CHECK-NEXT:    movq %rdx, _var+8(%rip)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: fetch_and_nand:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    subl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -8
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_fetch_and_nand_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $28, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -28
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    movl %esi, var+8
; CHECK32-NEXT:    movl %edx, var+12
; CHECK32-NEXT:    movl %eax, var
; CHECK32-NEXT:    movl %ecx, var+4
; CHECK32-NEXT:    addl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl
  %val = atomicrmw nand ptr %p, i128 %bits release
  store i128 %val, ptr @var, align 16
  ret void
}

define void @fetch_and_or(ptr %p, i128 %bits) {
; CHECK-LABEL: fetch_and_or:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB3_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rax, %rbx
; CHECK-NEXT:    orq %rsi, %rbx
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    orq %r8, %rcx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB3_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    movq %rax, _var(%rip)
; CHECK-NEXT:    movq %rdx, _var+8(%rip)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: fetch_and_or:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    subl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -8
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_fetch_and_or_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $28, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -28
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    movl %esi, var+8
; CHECK32-NEXT:    movl %edx, var+12
; CHECK32-NEXT:    movl %eax, var
; CHECK32-NEXT:    movl %ecx, var+4
; CHECK32-NEXT:    addl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl
  %val = atomicrmw or ptr %p, i128 %bits seq_cst
  store i128 %val, ptr @var, align 16
  ret void
}

define void @fetch_and_add(ptr %p, i128 %bits) {
; CHECK-LABEL: fetch_and_add:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB4_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rax, %rbx
; CHECK-NEXT:    addq %rsi, %rbx
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    adcq %r8, %rcx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB4_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    movq %rax, _var(%rip)
; CHECK-NEXT:    movq %rdx, _var+8(%rip)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: fetch_and_add:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    subl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -8
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_fetch_and_add_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $28, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -28
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    movl %esi, var+8
; CHECK32-NEXT:    movl %edx, var+12
; CHECK32-NEXT:    movl %eax, var
; CHECK32-NEXT:    movl %ecx, var+4
; CHECK32-NEXT:    addl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl
  %val = atomicrmw add ptr %p, i128 %bits seq_cst
  store i128 %val, ptr @var, align 16
  ret void
}

define void @fetch_and_sub(ptr %p, i128 %bits) {
; CHECK-LABEL: fetch_and_sub:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB5_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movq %rax, %rbx
; CHECK-NEXT:    subq %rsi, %rbx
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    sbbq %r8, %rcx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB5_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    movq %rax, _var(%rip)
; CHECK-NEXT:    movq %rdx, _var+8(%rip)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: fetch_and_sub:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    subl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -8
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_fetch_and_sub_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $28, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -28
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    movl %esi, var+8
; CHECK32-NEXT:    movl %edx, var+12
; CHECK32-NEXT:    movl %eax, var
; CHECK32-NEXT:    movl %ecx, var+4
; CHECK32-NEXT:    addl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl
  %val = atomicrmw sub ptr %p, i128 %bits seq_cst
  store i128 %val, ptr @var, align 16
  ret void
}

define void @fetch_and_min(ptr %p, i128 %bits) {
; CHECK-LABEL: fetch_and_min:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB6_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpq %rax, %rsi
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    sbbq %rdx, %rcx
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    cmovgeq %rdx, %rcx
; CHECK-NEXT:    movq %rsi, %rbx
; CHECK-NEXT:    cmovgeq %rax, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB6_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    movq %rax, _var(%rip)
; CHECK-NEXT:    movq %rdx, _var+8(%rip)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: fetch_and_min:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    subl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -8
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_fetch_and_min_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $28, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -28
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    movl %esi, var+8
; CHECK32-NEXT:    movl %edx, var+12
; CHECK32-NEXT:    movl %eax, var
; CHECK32-NEXT:    movl %ecx, var+4
; CHECK32-NEXT:    addl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl
  %val = atomicrmw min ptr %p, i128 %bits seq_cst
  store i128 %val, ptr @var, align 16
  ret void
}

define void @fetch_and_max(ptr %p, i128 %bits) {
; CHECK-LABEL: fetch_and_max:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB7_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpq %rax, %rsi
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    sbbq %rdx, %rcx
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    cmovlq %rdx, %rcx
; CHECK-NEXT:    movq %rsi, %rbx
; CHECK-NEXT:    cmovlq %rax, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB7_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    movq %rax, _var(%rip)
; CHECK-NEXT:    movq %rdx, _var+8(%rip)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: fetch_and_max:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    subl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -8
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_fetch_and_max_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $28, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -28
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    movl %esi, var+8
; CHECK32-NEXT:    movl %edx, var+12
; CHECK32-NEXT:    movl %eax, var
; CHECK32-NEXT:    movl %ecx, var+4
; CHECK32-NEXT:    addl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl
  %val = atomicrmw max ptr %p, i128 %bits seq_cst
  store i128 %val, ptr @var, align 16
  ret void
}

define void @fetch_and_umin(ptr %p, i128 %bits) {
; CHECK-LABEL: fetch_and_umin:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB8_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpq %rax, %rsi
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    sbbq %rdx, %rcx
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    cmovaeq %rdx, %rcx
; CHECK-NEXT:    movq %rsi, %rbx
; CHECK-NEXT:    cmovaeq %rax, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB8_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    movq %rax, _var(%rip)
; CHECK-NEXT:    movq %rdx, _var+8(%rip)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: fetch_and_umin:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    subl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -8
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_fetch_and_umin_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $28, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -28
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    movl %esi, var+8
; CHECK32-NEXT:    movl %edx, var+12
; CHECK32-NEXT:    movl %eax, var
; CHECK32-NEXT:    movl %ecx, var+4
; CHECK32-NEXT:    addl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl
  %val = atomicrmw umin ptr %p, i128 %bits seq_cst
  store i128 %val, ptr @var, align 16
  ret void
}

define void @fetch_and_umax(ptr %p, i128 %bits) {
; CHECK-LABEL: fetch_and_umax:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %r8
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB9_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpq %rax, %rsi
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    sbbq %rdx, %rcx
; CHECK-NEXT:    movq %r8, %rcx
; CHECK-NEXT:    cmovbq %rdx, %rcx
; CHECK-NEXT:    movq %rsi, %rbx
; CHECK-NEXT:    cmovbq %rax, %rbx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB9_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    movq %rax, _var(%rip)
; CHECK-NEXT:    movq %rdx, _var+8(%rip)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: fetch_and_umax:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    subl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -8
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_fetch_and_umax_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $28, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -28
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    movl %esi, var+8
; CHECK32-NEXT:    movl %edx, var+12
; CHECK32-NEXT:    movl %eax, var
; CHECK32-NEXT:    movl %ecx, var+4
; CHECK32-NEXT:    addl $24, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl
  %val = atomicrmw umax ptr %p, i128 %bits seq_cst
  store i128 %val, ptr @var, align 16
  ret void
}

define i128 @atomic_load_seq_cst(ptr %p) {
; CHECK-LABEL: atomic_load_seq_cst:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    xorl %ebx, %ebx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: atomic_load_seq_cst:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %edi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 12
; CHECK32-NEXT:    subl $20, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -12
; CHECK32-NEXT:    .cfi_offset %edi, -8
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_val_compare_and_swap_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $44, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -44
; CHECK32-NEXT:    movl (%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK32-NEXT:    movl %edi, 8(%esi)
; CHECK32-NEXT:    movl %edx, 12(%esi)
; CHECK32-NEXT:    movl %eax, (%esi)
; CHECK32-NEXT:    movl %ecx, 4(%esi)
; CHECK32-NEXT:    movl %esi, %eax
; CHECK32-NEXT:    addl $20, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 12
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %edi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl $4
   %r = load atomic i128, ptr %p seq_cst, align 16
   ret i128 %r
}

define i128 @atomic_load_relaxed(ptr %p) {
; CHECK-LABEL: atomic_load_relaxed:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    xorl %ebx, %ebx
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: atomic_load_relaxed:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    pushl %edi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    pushl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 12
; CHECK32-NEXT:    subl $20, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 32
; CHECK32-NEXT:    .cfi_offset %esi, -12
; CHECK32-NEXT:    .cfi_offset %edi, -8
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK32-NEXT:    subl $8, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 8
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl $0
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_val_compare_and_swap_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $44, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -44
; CHECK32-NEXT:    movl (%esp), %eax
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK32-NEXT:    movl {{[0-9]+}}(%esp), %edi
; CHECK32-NEXT:    movl %edi, 8(%esi)
; CHECK32-NEXT:    movl %edx, 12(%esi)
; CHECK32-NEXT:    movl %eax, (%esi)
; CHECK32-NEXT:    movl %ecx, 4(%esi)
; CHECK32-NEXT:    movl %esi, %eax
; CHECK32-NEXT:    addl $20, %esp
; CHECK32-NEXT:    .cfi_def_cfa_offset 12
; CHECK32-NEXT:    popl %esi
; CHECK32-NEXT:    .cfi_def_cfa_offset 8
; CHECK32-NEXT:    popl %edi
; CHECK32-NEXT:    .cfi_def_cfa_offset 4
; CHECK32-NEXT:    retl $4
   %r = load atomic i128, ptr %p monotonic, align 16
   ret i128 %r
}

define void @atomic_store_seq_cst(ptr %p, i128 %in) {
; CHECK-LABEL: atomic_store_seq_cst:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    movq %rsi, %rbx
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB12_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB12_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: atomic_store_seq_cst:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    subl $36, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 36
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_lock_test_and_set_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $56, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -56
; CHECK32-NEXT:    retl
   store atomic i128 %in, ptr %p seq_cst, align 16
   ret void
}

define void @atomic_store_release(ptr %p, i128 %in) {
; CHECK-LABEL: atomic_store_release:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    movq %rsi, %rbx
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB13_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB13_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: atomic_store_release:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    subl $36, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 36
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_lock_test_and_set_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $56, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -56
; CHECK32-NEXT:    retl
   store atomic i128 %in, ptr %p release, align 16
   ret void
}

define void @atomic_store_relaxed(ptr %p, i128 %in) {
; CHECK-LABEL: atomic_store_relaxed:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset %rbx, -16
; CHECK-NEXT:    movq %rdx, %rcx
; CHECK-NEXT:    movq %rsi, %rbx
; CHECK-NEXT:    movq (%rdi), %rax
; CHECK-NEXT:    movq 8(%rdi), %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  LBB14_1: ## %atomicrmw.start
; CHECK-NEXT:    ## =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    lock cmpxchg16b (%rdi)
; CHECK-NEXT:    jne LBB14_1
; CHECK-NEXT:  ## %bb.2: ## %atomicrmw.end
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    retq
;
; CHECK32-LABEL: atomic_store_relaxed:
; CHECK32:       # %bb.0:
; CHECK32-NEXT:    subl $36, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 36
; CHECK32-NEXT:    leal {{[0-9]+}}(%esp), %eax
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    pushl %eax
; CHECK32-NEXT:    .cfi_adjust_cfa_offset 4
; CHECK32-NEXT:    calll __sync_lock_test_and_set_16
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -4
; CHECK32-NEXT:    addl $56, %esp
; CHECK32-NEXT:    .cfi_adjust_cfa_offset -56
; CHECK32-NEXT:    retl
   store atomic i128 %in, ptr %p unordered, align 16
   ret void
}


