; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i386-linux-gnu -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=32-ALL,32-GOOD-RA
; RUN: llc -mtriple=i386-linux-gnu -verify-machineinstrs -pre-RA-sched=fast %s -o - | FileCheck %s --check-prefixes=32-ALL,32-FAST-RA

; RUN: llc -mtriple=x86_64-linux-gnu -verify-machineinstrs %s -o - | FileCheck %s --check-prefixes=64-ALL,64-GOOD-RA
; RUN: llc -mtriple=x86_64-linux-gnu -verify-machineinstrs -pre-RA-sched=fast %s -o - | FileCheck %s --check-prefixes=64-ALL,64-FAST-RA
; RUN: llc -mtriple=x86_64-linux-gnu -verify-machineinstrs -mattr=+sahf %s -o - | FileCheck %s --check-prefixes=64-ALL,64-GOOD-RA-SAHF
; RUN: llc -mtriple=x86_64-linux-gnu -verify-machineinstrs -mattr=+sahf -pre-RA-sched=fast %s -o - | FileCheck %s --check-prefixes=64-ALL,64-FAST-RA-SAHF
; RUN: llc -mtriple=x86_64-linux-gnu -verify-machineinstrs -mcpu=corei7 %s -o - | FileCheck %s --check-prefixes=64-ALL,64-GOOD-RA-SAHF

declare i32 @foo()
declare i32 @bar(i64)

; In the following case when using fast scheduling we get a long chain of
; EFLAGS save/restore due to a sequence of:
; cmpxchg8b (implicit-def eflags)
; eax = copy eflags
; adjcallstackdown32
; ...
; use of eax
; During PEI the adjcallstackdown32 is replaced with the subl which
; clobbers eflags, effectively interfering in the liveness interval. However,
; we then promote these copies into independent conditions in GPRs that avoids
; repeated saving and restoring logic and can be trivially managed by the
; register allocator.
define i64 @test_intervening_call(i64* %foo, i64 %bar, i64 %baz) nounwind {
; 32-GOOD-RA-LABEL: test_intervening_call:
; 32-GOOD-RA:       # %bb.0: # %entry
; 32-GOOD-RA-NEXT:    pushl %ebx
; 32-GOOD-RA-NEXT:    pushl %esi
; 32-GOOD-RA-NEXT:    pushl %eax
; 32-GOOD-RA-NEXT:    movl {{[0-9]+}}(%esp), %eax
; 32-GOOD-RA-NEXT:    movl {{[0-9]+}}(%esp), %edx
; 32-GOOD-RA-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; 32-GOOD-RA-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; 32-GOOD-RA-NEXT:    movl {{[0-9]+}}(%esp), %esi
; 32-GOOD-RA-NEXT:    lock cmpxchg8b (%esi)
; 32-GOOD-RA-NEXT:    setne %bl
; 32-GOOD-RA-NEXT:    subl $8, %esp
; 32-GOOD-RA-NEXT:    pushl %edx
; 32-GOOD-RA-NEXT:    pushl %eax
; 32-GOOD-RA-NEXT:    calll bar
; 32-GOOD-RA-NEXT:    addl $16, %esp
; 32-GOOD-RA-NEXT:    testb $-1, %bl
; 32-GOOD-RA-NEXT:    jne .LBB0_3
; 32-GOOD-RA-NEXT:  # %bb.1: # %t
; 32-GOOD-RA-NEXT:    movl $42, %eax
; 32-GOOD-RA-NEXT:    jmp .LBB0_2
; 32-GOOD-RA-NEXT:  .LBB0_3: # %f
; 32-GOOD-RA-NEXT:    xorl %eax, %eax
; 32-GOOD-RA-NEXT:  .LBB0_2: # %t
; 32-GOOD-RA-NEXT:    xorl %edx, %edx
; 32-GOOD-RA-NEXT:    addl $4, %esp
; 32-GOOD-RA-NEXT:    popl %esi
; 32-GOOD-RA-NEXT:    popl %ebx
; 32-GOOD-RA-NEXT:    retl
;
; 32-FAST-RA-LABEL: test_intervening_call:
; 32-FAST-RA:       # %bb.0: # %entry
; 32-FAST-RA-NEXT:    pushl %ebx
; 32-FAST-RA-NEXT:    pushl %esi
; 32-FAST-RA-NEXT:    pushl %eax
; 32-FAST-RA-NEXT:    movl {{[0-9]+}}(%esp), %esi
; 32-FAST-RA-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; 32-FAST-RA-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; 32-FAST-RA-NEXT:    movl {{[0-9]+}}(%esp), %eax
; 32-FAST-RA-NEXT:    movl {{[0-9]+}}(%esp), %edx
; 32-FAST-RA-NEXT:    lock cmpxchg8b (%esi)
; 32-FAST-RA-NEXT:    setne %bl
; 32-FAST-RA-NEXT:    subl $8, %esp
; 32-FAST-RA-NEXT:    pushl %edx
; 32-FAST-RA-NEXT:    pushl %eax
; 32-FAST-RA-NEXT:    calll bar
; 32-FAST-RA-NEXT:    addl $16, %esp
; 32-FAST-RA-NEXT:    testb $-1, %bl
; 32-FAST-RA-NEXT:    jne .LBB0_3
; 32-FAST-RA-NEXT:  # %bb.1: # %t
; 32-FAST-RA-NEXT:    movl $42, %eax
; 32-FAST-RA-NEXT:    jmp .LBB0_2
; 32-FAST-RA-NEXT:  .LBB0_3: # %f
; 32-FAST-RA-NEXT:    xorl %eax, %eax
; 32-FAST-RA-NEXT:  .LBB0_2: # %t
; 32-FAST-RA-NEXT:    xorl %edx, %edx
; 32-FAST-RA-NEXT:    addl $4, %esp
; 32-FAST-RA-NEXT:    popl %esi
; 32-FAST-RA-NEXT:    popl %ebx
; 32-FAST-RA-NEXT:    retl
;
; 64-ALL-LABEL: test_intervening_call:
; 64-ALL:       # %bb.0: # %entry
; 64-ALL-NEXT:    pushq %rbx
; 64-ALL-NEXT:    movq %rsi, %rax
; 64-ALL-NEXT:    lock cmpxchgq %rdx, (%rdi)
; 64-ALL-NEXT:    setne %bl
; 64-ALL-NEXT:    movq %rax, %rdi
; 64-ALL-NEXT:    callq bar
; 64-ALL-NEXT:    testb $-1, %bl
; 64-ALL-NEXT:    jne .LBB0_2
; 64-ALL-NEXT:  # %bb.1: # %t
; 64-ALL-NEXT:    movl $42, %eax
; 64-ALL-NEXT:    popq %rbx
; 64-ALL-NEXT:    retq
; 64-ALL-NEXT:  .LBB0_2: # %f
; 64-ALL-NEXT:    xorl %eax, %eax
; 64-ALL-NEXT:    popq %rbx
; 64-ALL-NEXT:    retq
entry:
  %cx = cmpxchg i64* %foo, i64 %bar, i64 %baz seq_cst seq_cst
  %v = extractvalue { i64, i1 } %cx, 0
  %p = extractvalue { i64, i1 } %cx, 1
  call i32 @bar(i64 %v)
  br i1 %p, label %t, label %f

t:
  ret i64 42

f:
  ret i64 0
}

; Interesting in producing a clobber without any function calls.
define i32 @test_control_flow(i32* %p, i32 %i, i32 %j) nounwind {
; 32-ALL-LABEL: test_control_flow:
; 32-ALL:       # %bb.0: # %entry
; 32-ALL-NEXT:    movl {{[0-9]+}}(%esp), %eax
; 32-ALL-NEXT:    cmpl {{[0-9]+}}(%esp), %eax
; 32-ALL-NEXT:    jle .LBB1_6
; 32-ALL-NEXT:  # %bb.1: # %loop_start
; 32-ALL-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; 32-ALL-NEXT:    .p2align 4, 0x90
; 32-ALL-NEXT:  .LBB1_2: # %while.condthread-pre-split.i
; 32-ALL-NEXT:    # =>This Loop Header: Depth=1
; 32-ALL-NEXT:    # Child Loop BB1_3 Depth 2
; 32-ALL-NEXT:    movl (%ecx), %edx
; 32-ALL-NEXT:    .p2align 4, 0x90
; 32-ALL-NEXT:  .LBB1_3: # %while.cond.i
; 32-ALL-NEXT:    # Parent Loop BB1_2 Depth=1
; 32-ALL-NEXT:    # => This Inner Loop Header: Depth=2
; 32-ALL-NEXT:    movl %edx, %eax
; 32-ALL-NEXT:    xorl %edx, %edx
; 32-ALL-NEXT:    testl %eax, %eax
; 32-ALL-NEXT:    je .LBB1_3
; 32-ALL-NEXT:  # %bb.4: # %while.body.i
; 32-ALL-NEXT:    # in Loop: Header=BB1_2 Depth=1
; 32-ALL-NEXT:    lock cmpxchgl %eax, (%ecx)
; 32-ALL-NEXT:    jne .LBB1_2
; 32-ALL-NEXT:  # %bb.5:
; 32-ALL-NEXT:    xorl %eax, %eax
; 32-ALL-NEXT:  .LBB1_6: # %cond.end
; 32-ALL-NEXT:    retl
;
; 64-ALL-LABEL: test_control_flow:
; 64-ALL:       # %bb.0: # %entry
; 64-ALL-NEXT:    cmpl %edx, %esi
; 64-ALL-NEXT:    jle .LBB1_5
; 64-ALL-NEXT:    .p2align 4, 0x90
; 64-ALL-NEXT:  .LBB1_1: # %while.condthread-pre-split.i
; 64-ALL-NEXT:    # =>This Loop Header: Depth=1
; 64-ALL-NEXT:    # Child Loop BB1_2 Depth 2
; 64-ALL-NEXT:    movl (%rdi), %ecx
; 64-ALL-NEXT:    .p2align 4, 0x90
; 64-ALL-NEXT:  .LBB1_2: # %while.cond.i
; 64-ALL-NEXT:    # Parent Loop BB1_1 Depth=1
; 64-ALL-NEXT:    # => This Inner Loop Header: Depth=2
; 64-ALL-NEXT:    movl %ecx, %eax
; 64-ALL-NEXT:    xorl %ecx, %ecx
; 64-ALL-NEXT:    testl %eax, %eax
; 64-ALL-NEXT:    je .LBB1_2
; 64-ALL-NEXT:  # %bb.3: # %while.body.i
; 64-ALL-NEXT:    # in Loop: Header=BB1_1 Depth=1
; 64-ALL-NEXT:    lock cmpxchgl %eax, (%rdi)
; 64-ALL-NEXT:    jne .LBB1_1
; 64-ALL-NEXT:  # %bb.4:
; 64-ALL-NEXT:    xorl %esi, %esi
; 64-ALL-NEXT:  .LBB1_5: # %cond.end
; 64-ALL-NEXT:    movl %esi, %eax
; 64-ALL-NEXT:    retq
entry:
  %cmp = icmp sgt i32 %i, %j
  br i1 %cmp, label %loop_start, label %cond.end

loop_start:
  br label %while.condthread-pre-split.i

while.condthread-pre-split.i:
  %.pr.i = load i32, i32* %p, align 4
  br label %while.cond.i

while.cond.i:
  %0 = phi i32 [ %.pr.i, %while.condthread-pre-split.i ], [ 0, %while.cond.i ]
  %tobool.i = icmp eq i32 %0, 0
  br i1 %tobool.i, label %while.cond.i, label %while.body.i

while.body.i:
  %.lcssa = phi i32 [ %0, %while.cond.i ]
  %1 = cmpxchg i32* %p, i32 %.lcssa, i32 %.lcssa seq_cst seq_cst
  %2 = extractvalue { i32, i1 } %1, 1
  br i1 %2, label %cond.end.loopexit, label %while.condthread-pre-split.i

cond.end.loopexit:
  br label %cond.end

cond.end:
  %cond = phi i32 [ %i, %entry ], [ 0, %cond.end.loopexit ]
  ret i32 %cond
}

; This one is an interesting case because CMOV doesn't have a chain
; operand. Naive attempts to limit cmpxchg EFLAGS use are likely to fail here.
define i32 @test_feed_cmov(i32* %addr, i32 %desired, i32 %new) nounwind {
; 32-GOOD-RA-LABEL: test_feed_cmov:
; 32-GOOD-RA:       # %bb.0: # %entry
; 32-GOOD-RA-NEXT:    pushl %ebx
; 32-GOOD-RA-NEXT:    pushl %esi
; 32-GOOD-RA-NEXT:    pushl %eax
; 32-GOOD-RA-NEXT:    movl {{[0-9]+}}(%esp), %eax
; 32-GOOD-RA-NEXT:    movl {{[0-9]+}}(%esp), %esi
; 32-GOOD-RA-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; 32-GOOD-RA-NEXT:    lock cmpxchgl %esi, (%ecx)
; 32-GOOD-RA-NEXT:    sete %bl
; 32-GOOD-RA-NEXT:    calll foo
; 32-GOOD-RA-NEXT:    testb $-1, %bl
; 32-GOOD-RA-NEXT:    jne .LBB2_2
; 32-GOOD-RA-NEXT:  # %bb.1: # %entry
; 32-GOOD-RA-NEXT:    movl %eax, %esi
; 32-GOOD-RA-NEXT:  .LBB2_2: # %entry
; 32-GOOD-RA-NEXT:    movl %esi, %eax
; 32-GOOD-RA-NEXT:    addl $4, %esp
; 32-GOOD-RA-NEXT:    popl %esi
; 32-GOOD-RA-NEXT:    popl %ebx
; 32-GOOD-RA-NEXT:    retl
;
; 32-FAST-RA-LABEL: test_feed_cmov:
; 32-FAST-RA:       # %bb.0: # %entry
; 32-FAST-RA-NEXT:    pushl %ebx
; 32-FAST-RA-NEXT:    pushl %esi
; 32-FAST-RA-NEXT:    pushl %eax
; 32-FAST-RA-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; 32-FAST-RA-NEXT:    movl {{[0-9]+}}(%esp), %esi
; 32-FAST-RA-NEXT:    movl {{[0-9]+}}(%esp), %eax
; 32-FAST-RA-NEXT:    lock cmpxchgl %esi, (%ecx)
; 32-FAST-RA-NEXT:    sete %bl
; 32-FAST-RA-NEXT:    calll foo
; 32-FAST-RA-NEXT:    testb $-1, %bl
; 32-FAST-RA-NEXT:    jne .LBB2_2
; 32-FAST-RA-NEXT:  # %bb.1: # %entry
; 32-FAST-RA-NEXT:    movl %eax, %esi
; 32-FAST-RA-NEXT:  .LBB2_2: # %entry
; 32-FAST-RA-NEXT:    movl %esi, %eax
; 32-FAST-RA-NEXT:    addl $4, %esp
; 32-FAST-RA-NEXT:    popl %esi
; 32-FAST-RA-NEXT:    popl %ebx
; 32-FAST-RA-NEXT:    retl
;
; 64-ALL-LABEL: test_feed_cmov:
; 64-ALL:       # %bb.0: # %entry
; 64-ALL-NEXT:    pushq %rbp
; 64-ALL-NEXT:    pushq %rbx
; 64-ALL-NEXT:    pushq %rax
; 64-ALL-NEXT:    movl %edx, %ebx
; 64-ALL-NEXT:    movl %esi, %eax
; 64-ALL-NEXT:    lock cmpxchgl %edx, (%rdi)
; 64-ALL-NEXT:    sete %bpl
; 64-ALL-NEXT:    callq foo
; 64-ALL-NEXT:    testb $-1, %bpl
; 64-ALL-NEXT:    cmovnel %ebx, %eax
; 64-ALL-NEXT:    addq $8, %rsp
; 64-ALL-NEXT:    popq %rbx
; 64-ALL-NEXT:    popq %rbp
; 64-ALL-NEXT:    retq
entry:
  %res = cmpxchg i32* %addr, i32 %desired, i32 %new seq_cst seq_cst
  %success = extractvalue { i32, i1 } %res, 1

  %rhs = call i32 @foo()

  %ret = select i1 %success, i32 %new, i32 %rhs
  ret i32 %ret
}
