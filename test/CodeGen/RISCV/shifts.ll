; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I

; Basic shift support is tested as part of ALU.ll. This file ensures that
; shifts which may not be supported natively are lowered properly.

define i64 @lshr64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: lshr64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    call __lshrdi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = lshr i64 %a, %b
  ret i64 %1
}

define i64 @ashr64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: ashr64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    call __ashrdi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = ashr i64 %a, %b
  ret i64 %1
}

define i64 @shl64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: shl64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    call __ashldi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
  %1 = shl i64 %a, %b
  ret i64 %1
}
