; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK,X86-64
; RUN: llc < %s -mtriple=i686-unknown-unknown -verify-machineinstrs | FileCheck %s --check-prefixes=CHECK,X86-32

; Make sure that flags are properly preserved despite atomic optimizations.

define i32 @atomic_and_flags_1(i8* %p, i32 %a, i32 %b) {
  ; Generate flags value, and use it.
; X86-64-LABEL: atomic_and_flags_1:
; X86-64:       # %bb.0:
; X86-64-NEXT:    cmpl %edx, %esi
; X86-64-NEXT:    je .LBB0_1
; X86-64-NEXT:  # %bb.3: # %L2
; X86-64-NEXT:    movl $2, %eax
; X86-64-NEXT:    retq
; X86-64-NEXT:  .LBB0_1: # %L1
; X86-64-NEXT:    incb (%rdi)
; X86-64-NEXT:    cmpl %edx, %esi
; X86-64-NEXT:    je .LBB0_4
; X86-64-NEXT:  # %bb.2: # %L4
; X86-64-NEXT:    movl $4, %eax
; X86-64-NEXT:    retq
; X86-64-NEXT:  .LBB0_4: # %L3
; X86-64-NEXT:    movl $3, %eax
; X86-64-NEXT:    retq
;
; X86-32-LABEL: atomic_and_flags_1:
; X86-32:       # %bb.0:
; X86-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-32-NEXT:    cmpl %eax, %ecx
; X86-32-NEXT:    je .LBB0_1
; X86-32-NEXT:  # %bb.3: # %L2
; X86-32-NEXT:    movl $2, %eax
; X86-32-NEXT:    retl
; X86-32-NEXT:  .LBB0_1: # %L1
; X86-32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-32-NEXT:    incb (%edx)
; X86-32-NEXT:    cmpl %eax, %ecx
; X86-32-NEXT:    je .LBB0_4
; X86-32-NEXT:  # %bb.2: # %L4
; X86-32-NEXT:    movl $4, %eax
; X86-32-NEXT:    retl
; X86-32-NEXT:  .LBB0_4: # %L3
; X86-32-NEXT:    movl $3, %eax
; X86-32-NEXT:    retl
  %cmp = icmp eq i32 %a, %b
  br i1 %cmp, label %L1, label %L2

L1:
  ; The following pattern will get folded.

  %1 = load atomic i8, i8* %p seq_cst, align 1
  %2 = add i8 %1, 1 ; This forces the INC instruction to be generated.
  store atomic i8 %2, i8* %p release, align 1

  ; Use the comparison result again. We need to rematerialize the comparison
  ; somehow. This test checks that cmpl gets emitted again, but any
  ; rematerialization would work (the optimizer used to clobber the flags with
  ; the add).

  br i1 %cmp, label %L3, label %L4

L2:
  ret i32 2

L3:
  ret i32 3

L4:
  ret i32 4
}

; Same as above, but using 2 as immediate to avoid the INC instruction.
define i32 @atomic_and_flags_2(i8* %p, i32 %a, i32 %b) {
; X86-64-LABEL: atomic_and_flags_2:
; X86-64:       # %bb.0:
; X86-64-NEXT:    cmpl %edx, %esi
; X86-64-NEXT:    je .LBB1_1
; X86-64-NEXT:  # %bb.3: # %L2
; X86-64-NEXT:    movl $2, %eax
; X86-64-NEXT:    retq
; X86-64-NEXT:  .LBB1_1: # %L1
; X86-64-NEXT:    addb $2, (%rdi)
; X86-64-NEXT:    cmpl %edx, %esi
; X86-64-NEXT:    je .LBB1_4
; X86-64-NEXT:  # %bb.2: # %L4
; X86-64-NEXT:    movl $4, %eax
; X86-64-NEXT:    retq
; X86-64-NEXT:  .LBB1_4: # %L3
; X86-64-NEXT:    movl $3, %eax
; X86-64-NEXT:    retq
;
; X86-32-LABEL: atomic_and_flags_2:
; X86-32:       # %bb.0:
; X86-32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-32-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-32-NEXT:    cmpl %eax, %ecx
; X86-32-NEXT:    je .LBB1_1
; X86-32-NEXT:  # %bb.3: # %L2
; X86-32-NEXT:    movl $2, %eax
; X86-32-NEXT:    retl
; X86-32-NEXT:  .LBB1_1: # %L1
; X86-32-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-32-NEXT:    addb $2, (%edx)
; X86-32-NEXT:    cmpl %eax, %ecx
; X86-32-NEXT:    je .LBB1_4
; X86-32-NEXT:  # %bb.2: # %L4
; X86-32-NEXT:    movl $4, %eax
; X86-32-NEXT:    retl
; X86-32-NEXT:  .LBB1_4: # %L3
; X86-32-NEXT:    movl $3, %eax
; X86-32-NEXT:    retl
  %cmp = icmp eq i32 %a, %b
  br i1 %cmp, label %L1, label %L2
L1:
  %1 = load atomic i8, i8* %p seq_cst, align 1
  %2 = add i8 %1, 2
  store atomic i8 %2, i8* %p release, align 1

  br i1 %cmp, label %L3, label %L4
L2:
  ret i32 2
L3:
  ret i32 3
L4:
  ret i32 4
}
