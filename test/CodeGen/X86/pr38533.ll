; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown | FileCheck %s

; This test makes sure that a vector that needs to be promoted that is bitcasted to fp16 is legalized correctly without causing a width mismatch.
define void @constant_fold_vector_to_half() {
; CHECK-LABEL: constant_fold_vector_to_half:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movw $16384, (%rax) # imm = 0x4000
; CHECK-NEXT:    retq
  store volatile half bitcast (<4 x i4> <i4 0, i4 0, i4 0, i4 4> to half), half* undef
  ret void
}

; Similarly this makes sure that the opposite bitcast of the above is also legalized without crashing.
define void @pr38533_2(half %x) {
; CHECK-LABEL: pr38533_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    callq __gnu_f2h_ieee
; CHECK-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movzwl {{[0-9]+}}(%rsp), %eax
; CHECK-NEXT:    movw %ax, (%rax)
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    retq
  %a = bitcast half %x to <4 x i4>
  store volatile <4 x i4> %a, <4 x i4>* undef
  ret void
}
