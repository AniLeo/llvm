; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=i686-unknown-linux-gnu             < %s | FileCheck %s   --check-prefixes=X86,NOBMI-X86
; RUN: llc -mtriple=i686-unknown-linux-gnu -mattr=+bmi < %s | FileCheck %s   --check-prefixes=X86,BMI-X86
; RUN: llc -mtriple=x86_64-unknown-linux-gnu             < %s | FileCheck %s --check-prefixes=X64,NOBMI-X64
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+bmi < %s | FileCheck %s --check-prefixes=X64,BMI-X64

; Fold
;   ptr - (ptr & mask)
; To
;   ptr & (~mask)
;
; This needs to be a backend-level fold because only by now pointers
; are just registers; in middle-end IR this can only be done via @llvm.ptrmask()
; intrinsic which is not sufficiently widely-spread yet.
;
; https://bugs.llvm.org/show_bug.cgi?id=44448

; The basic positive tests

define i32 @t0_32(i32 %ptr, i32 %mask) nounwind {
; NOBMI-X86-LABEL: t0_32:
; NOBMI-X86:       # %bb.0:
; NOBMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; NOBMI-X86-NEXT:    notl %eax
; NOBMI-X86-NEXT:    andl {{[0-9]+}}(%esp), %eax
; NOBMI-X86-NEXT:    retl
;
; BMI-X86-LABEL: t0_32:
; BMI-X86:       # %bb.0:
; BMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; BMI-X86-NEXT:    andnl {{[0-9]+}}(%esp), %eax, %eax
; BMI-X86-NEXT:    retl
;
; NOBMI-X64-LABEL: t0_32:
; NOBMI-X64:       # %bb.0:
; NOBMI-X64-NEXT:    movl %esi, %eax
; NOBMI-X64-NEXT:    notl %eax
; NOBMI-X64-NEXT:    andl %edi, %eax
; NOBMI-X64-NEXT:    retq
;
; BMI-X64-LABEL: t0_32:
; BMI-X64:       # %bb.0:
; BMI-X64-NEXT:    andnl %edi, %esi, %eax
; BMI-X64-NEXT:    retq
  %bias = and i32 %ptr, %mask
  %r = sub i32 %ptr, %bias
  ret i32 %r
}
define i64 @t1_64(i64 %ptr, i64 %mask) nounwind {
; NOBMI-X86-LABEL: t1_64:
; NOBMI-X86:       # %bb.0:
; NOBMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; NOBMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; NOBMI-X86-NEXT:    notl %eax
; NOBMI-X86-NEXT:    andl {{[0-9]+}}(%esp), %eax
; NOBMI-X86-NEXT:    notl %edx
; NOBMI-X86-NEXT:    andl {{[0-9]+}}(%esp), %edx
; NOBMI-X86-NEXT:    retl
;
; BMI-X86-LABEL: t1_64:
; BMI-X86:       # %bb.0:
; BMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; BMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; BMI-X86-NEXT:    andnl {{[0-9]+}}(%esp), %eax, %eax
; BMI-X86-NEXT:    andnl {{[0-9]+}}(%esp), %ecx, %edx
; BMI-X86-NEXT:    retl
;
; NOBMI-X64-LABEL: t1_64:
; NOBMI-X64:       # %bb.0:
; NOBMI-X64-NEXT:    movq %rsi, %rax
; NOBMI-X64-NEXT:    notq %rax
; NOBMI-X64-NEXT:    andq %rdi, %rax
; NOBMI-X64-NEXT:    retq
;
; BMI-X64-LABEL: t1_64:
; BMI-X64:       # %bb.0:
; BMI-X64-NEXT:    andnq %rdi, %rsi, %rax
; BMI-X64-NEXT:    retq
  %bias = and i64 %ptr, %mask
  %r = sub i64 %ptr, %bias
  ret i64 %r
}

define i32 @t2_commutative(i32 %ptr, i32 %mask) nounwind {
; NOBMI-X86-LABEL: t2_commutative:
; NOBMI-X86:       # %bb.0:
; NOBMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; NOBMI-X86-NEXT:    notl %eax
; NOBMI-X86-NEXT:    andl {{[0-9]+}}(%esp), %eax
; NOBMI-X86-NEXT:    retl
;
; BMI-X86-LABEL: t2_commutative:
; BMI-X86:       # %bb.0:
; BMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; BMI-X86-NEXT:    andnl {{[0-9]+}}(%esp), %eax, %eax
; BMI-X86-NEXT:    retl
;
; NOBMI-X64-LABEL: t2_commutative:
; NOBMI-X64:       # %bb.0:
; NOBMI-X64-NEXT:    movl %esi, %eax
; NOBMI-X64-NEXT:    notl %eax
; NOBMI-X64-NEXT:    andl %edi, %eax
; NOBMI-X64-NEXT:    retq
;
; BMI-X64-LABEL: t2_commutative:
; BMI-X64:       # %bb.0:
; BMI-X64-NEXT:    andnl %edi, %esi, %eax
; BMI-X64-NEXT:    retq
  %bias = and i32 %mask, %ptr ; swapped
  %r = sub i32 %ptr, %bias
  ret i32 %r
}

; Extra use tests

define i32 @n3_extrause1(i32 %ptr, i32 %mask, i32* %bias_storage) nounwind {
; X86-LABEL: n3_extrause1:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    andl %eax, %edx
; X86-NEXT:    movl %edx, (%ecx)
; X86-NEXT:    subl %edx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: n3_extrause1:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl %edi, %esi
; X64-NEXT:    movl %esi, (%rdx)
; X64-NEXT:    subl %esi, %eax
; X64-NEXT:    retq
  %bias = and i32 %ptr, %mask ; has extra uses, can't fold
  store i32 %bias, i32* %bias_storage
  %r = sub i32 %ptr, %bias
  ret i32 %r
}

; Negative tests

define i32 @n4_different_ptrs(i32 %ptr0, i32 %ptr1, i32 %mask) nounwind {
; X86-LABEL: n4_different_ptrs:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: n4_different_ptrs:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl %edx, %esi
; X64-NEXT:    subl %esi, %eax
; X64-NEXT:    retq
  %bias = and i32 %ptr1, %mask ; not %ptr0
  %r = sub i32 %ptr0, %bias ; not %ptr1
  ret i32 %r
}
define i32 @n5_different_ptrs_commutative(i32 %ptr0, i32 %ptr1, i32 %mask) nounwind {
; X86-LABEL: n5_different_ptrs_commutative:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    andl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: n5_different_ptrs_commutative:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    andl %edx, %esi
; X64-NEXT:    subl %esi, %eax
; X64-NEXT:    retq
  %bias = and i32 %mask, %ptr1 ; swapped, not %ptr0
  %r = sub i32 %ptr0, %bias ; not %ptr1
  ret i32 %r
}

define i32 @n6_not_lowbit_mask(i32 %ptr, i32 %mask) nounwind {
; NOBMI-X86-LABEL: n6_not_lowbit_mask:
; NOBMI-X86:       # %bb.0:
; NOBMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; NOBMI-X86-NEXT:    notl %eax
; NOBMI-X86-NEXT:    andl {{[0-9]+}}(%esp), %eax
; NOBMI-X86-NEXT:    retl
;
; BMI-X86-LABEL: n6_not_lowbit_mask:
; BMI-X86:       # %bb.0:
; BMI-X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; BMI-X86-NEXT:    andnl {{[0-9]+}}(%esp), %eax, %eax
; BMI-X86-NEXT:    retl
;
; NOBMI-X64-LABEL: n6_not_lowbit_mask:
; NOBMI-X64:       # %bb.0:
; NOBMI-X64-NEXT:    movl %esi, %eax
; NOBMI-X64-NEXT:    notl %eax
; NOBMI-X64-NEXT:    andl %edi, %eax
; NOBMI-X64-NEXT:    retq
;
; BMI-X64-LABEL: n6_not_lowbit_mask:
; BMI-X64:       # %bb.0:
; BMI-X64-NEXT:    andnl %edi, %esi, %eax
; BMI-X64-NEXT:    retq
  %bias = and i32 %ptr, %mask
  %r = sub i32 %ptr, %bias
  ret i32 %r
}

define i32 @n7_sub_is_not_commutative(i32 %ptr, i32 %mask) nounwind {
; X86-LABEL: n7_sub_is_not_commutative:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    andl %ecx, %eax
; X86-NEXT:    subl %ecx, %eax
; X86-NEXT:    retl
;
; X64-LABEL: n7_sub_is_not_commutative:
; X64:       # %bb.0:
; X64-NEXT:    movl %esi, %eax
; X64-NEXT:    andl %edi, %eax
; X64-NEXT:    subl %edi, %eax
; X64-NEXT:    retq
  %bias = and i32 %ptr, %mask
  %r = sub i32 %bias, %ptr ; wrong order
  ret i32 %r
}
