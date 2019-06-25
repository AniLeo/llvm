; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s --check-prefix=X64

; Test coverage for matchAddressRecursively's MUL handling

; Based off:
; struct A {
;   int m_ints[5];
;   int m_bar();
; };
; struct {
;   A* m_data;
; } c;
; void foo(bool b, int i) {
;   if (b)
;     return;
;   int j = c.m_data[i + 1].m_bar();
;   foo(false, j);
; }

%struct.A = type { [5 x i32] }

define void @foo(i1 zeroext, i32) nounwind {
; X86-LABEL: foo:
; X86:       # %bb.0:
; X86-NEXT:    cmpb $0, {{[0-9]+}}(%esp)
; X86-NEXT:    je .LBB0_1
; X86-NEXT:  # %bb.3:
; X86-NEXT:    retl
; X86-NEXT:  .LBB0_1: # %.preheader
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    .p2align 4, 0x90
; X86-NEXT:  .LBB0_2: # =>This Inner Loop Header: Depth=1
; X86-NEXT:    leal (%eax,%eax,4), %eax
; X86-NEXT:    leal 20(,%eax,4), %eax
; X86-NEXT:    pushl %eax
; X86-NEXT:    calll bar
; X86-NEXT:    addl $4, %esp
; X86-NEXT:    jmp .LBB0_2
;
; X64-LABEL: foo:
; X64:       # %bb.0:
; X64-NEXT:    pushq %rax
; X64-NEXT:    testl %edi, %edi
; X64-NEXT:    je .LBB0_1
; X64-NEXT:  # %bb.3:
; X64-NEXT:    popq %rax
; X64-NEXT:    retq
; X64-NEXT:  .LBB0_1: # %.preheader
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    .p2align 4, 0x90
; X64-NEXT:  .LBB0_2: # =>This Inner Loop Header: Depth=1
; X64-NEXT:    incl %eax
; X64-NEXT:    cltq
; X64-NEXT:    shlq $2, %rax
; X64-NEXT:    leaq (%rax,%rax,4), %rdi
; X64-NEXT:    callq bar
; X64-NEXT:    jmp .LBB0_2
  br i1 %0, label %9, label %3

  %4 = phi i32 [ %8, %3 ], [ %1, %2 ]
  %5 = add nsw i32 %4, 1
  %6 = sext i32 %5 to i64
  %7 = getelementptr inbounds %struct.A, %struct.A* null, i64 %6
  %8 = tail call i32 @bar(%struct.A* %7)
  br label %3

  ret void
}

declare i32 @bar(%struct.A*)
