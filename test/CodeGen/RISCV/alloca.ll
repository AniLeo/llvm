; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I

declare void @notdead(i8*)

; These tests must ensure the stack pointer is restored using the frame
; pointer

define void @simple_alloca(i32 %n) nounwind {
; RV32I-LABEL: simple_alloca:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    addi a0, a0, 15
; RV32I-NEXT:    andi a0, a0, -16
; RV32I-NEXT:    sub a0, sp, a0
; RV32I-NEXT:    mv sp, a0
; RV32I-NEXT:    lui a1, %hi(notdead)
; RV32I-NEXT:    addi a1, a1, %lo(notdead)
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    addi sp, s0, -16
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = alloca i8, i32 %n
  call void @notdead(i8* %1)
  ret void
}

declare i8* @llvm.stacksave()
declare void @llvm.stackrestore(i8*)

define void @scoped_alloca(i32 %n) nounwind {
; RV32I-LABEL: scoped_alloca:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    sw s1, 4(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    mv s1, sp
; RV32I-NEXT:    addi a0, a0, 15
; RV32I-NEXT:    andi a0, a0, -16
; RV32I-NEXT:    sub a0, sp, a0
; RV32I-NEXT:    mv sp, a0
; RV32I-NEXT:    lui a1, %hi(notdead)
; RV32I-NEXT:    addi a1, a1, %lo(notdead)
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    mv sp, s1
; RV32I-NEXT:    addi sp, s0, -16
; RV32I-NEXT:    lw s1, 4(sp)
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %sp = call i8* @llvm.stacksave()
  %addr = alloca i8, i32 %n
  call void @notdead(i8* %addr)
  call void @llvm.stackrestore(i8* %sp)
  ret void
}
