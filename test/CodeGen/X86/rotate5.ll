; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown | FileCheck %s --check-prefixes=X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefixes=X64

; Ensure that the (pre-extended) shift amount type is wide enough to take any mask.
define void @PR56859() {
; X86-LABEL: PR56859:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl (%eax), %ecx
; X86-NEXT:    testl %ecx, %ecx
; X86-NEXT:    setne %al
; X86-NEXT:    movl $1, %edx
; X86-NEXT:    # kill: def $cl killed $cl killed $ecx
; X86-NEXT:    shrl %cl, %edx
; X86-NEXT:    btsl %eax, %edx
; X86-NEXT:    movl %edx, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: PR56859:
; X64:       # %bb.0: # %entry
; X64-NEXT:    movl (%rax), %ecx
; X64-NEXT:    testl %ecx, %ecx
; X64-NEXT:    setne %al
; X64-NEXT:    movl $1, %edx
; X64-NEXT:    # kill: def $cl killed $cl killed $ecx
; X64-NEXT:    shrl %cl, %edx
; X64-NEXT:    btsl %eax, %edx
; X64-NEXT:    movl %edx, (%rax)
; X64-NEXT:    retq
entry:
  %0 = load i32, ptr undef, align 4
  %tobool = icmp ne i32 %0, 0
  %lor.ext = zext i1 %tobool to i32
  %shr = lshr i32 1, %0
  %shl = shl i32 1, %lor.ext
  %or = or i32 %shl, %shr
  store i32 %or, ptr undef, align 4
  ret void
}
