; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s

@gi = external global i32

define i32 @constraint_r(i32 %a) {
; RV32I-LABEL: constraint_r:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, %hi(gi)
; RV32I-NEXT:    lw a1, %lo(gi)(a1)
; RV32I-NEXT:    #APP
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    #NO_APP
; RV32I-NEXT:    ret
  %1 = load i32, i32* @gi
  %2 = tail call i32 asm "add $0, $1, $2", "=r,r,r"(i32 %a, i32 %1)
  ret i32 %2
}

define i32 @constraint_i(i32 %a) {
; RV32I-LABEL: constraint_i:
; RV32I:       # %bb.0:
; RV32I-NEXT:    #APP
; RV32I-NEXT:    addi a0, a0, 113
; RV32I-NEXT:    #NO_APP
; RV32I-NEXT:    ret
  %1 = load i32, i32* @gi
  %2 = tail call i32 asm "addi $0, $1, $2", "=r,r,i"(i32 %a, i32 113)
  ret i32 %2
}

define void @constraint_m(i32* %a) {
; RV32I-LABEL: constraint_m:
; RV32I:       # %bb.0:
; RV32I-NEXT:    #APP
; RV32I-NEXT:    #NO_APP
; RV32I-NEXT:    ret
  call void asm sideeffect "", "=*m"(i32* %a)
  ret void
}

define i32 @constraint_m2(i32* %a) {
; RV32I-LABEL: constraint_m2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    #APP
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    #NO_APP
; RV32I-NEXT:    ret
  %1 = tail call i32 asm "lw $0, $1", "=r,*m"(i32* %a) nounwind
  ret i32 %1
}

; TODO: expend tests for more complex constraints, out of range immediates etc
