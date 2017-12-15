; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I

; These IR sequences will generate ISD::ROTL and ISD::ROTR nodes, that the
; RISC-V backend must be able to select

define i32 @rotl(i32 %x, i32 %y) {
; RV32I-LABEL: rotl:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    addi a2, zero, 32
; RV32I-NEXT:    sub a2, a2, a1
; RV32I-NEXT:    sll a1, a0, a1
; RV32I-NEXT:    srl a0, a0, a2
; RV32I-NEXT:    or a0, a1, a0
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %z = sub i32 32, %y
  %b = shl i32 %x, %y
  %c = lshr i32 %x, %z
  %d = or i32 %b, %c
  ret i32 %d
}

define i32 @rotr(i32 %x, i32 %y) {
; RV32I-LABEL: rotr:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    addi a2, zero, 32
; RV32I-NEXT:    sub a2, a2, a1
; RV32I-NEXT:    srl a1, a0, a1
; RV32I-NEXT:    sll a0, a0, a2
; RV32I-NEXT:    or a0, a1, a0
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %z = sub i32 32, %y
  %b = lshr i32 %x, %y
  %c = shl i32 %x, %z
  %d = or i32 %b, %c
  ret i32 %d
}
