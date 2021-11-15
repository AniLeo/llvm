; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu %s -o - \
; RUN:     | FileCheck --check-prefix=OUTPUT_ATT %s
; RUN: llc -mtriple=x86_64-unknown-linux-gnu %s -x86-asm-syntax=intel -o - \
; RUN:     | FileCheck --check-prefix=OUTPUT_INTEL %s

define void @f() {
; OUTPUT_ATT-LABEL: f:
; OUTPUT_ATT:       # %bb.0:
; OUTPUT_ATT-NEXT:    #APP
; OUTPUT_ATT-NEXT:    movq %rbx, %rax
; OUTPUT_ATT-NEXT:    #NO_APP
; OUTPUT_ATT-NEXT:    retq
;
; OUTPUT_INTEL-LABEL: f:
; OUTPUT_INTEL:       # %bb.0:
; OUTPUT_INTEL-NEXT:    #APP
; OUTPUT_INTEL-NEXT:    mov rax, rbx
; OUTPUT_INTEL-NEXT:    #NO_APP
; OUTPUT_INTEL-NEXT:    ret
  call void asm sideeffect "$(movq %rbx, %rax $|mov rax, rbx$)", "~{dirflag},~{fpsr},~{flags}"()

  ret void
}
