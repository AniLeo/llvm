; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s

declare i32 @external_function(i32)

define i32 @test_call_external(i32 %a) nounwind {
; RV32I-LABEL: test_call_external:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    lui a1, %hi(external_function)
; RV32I-NEXT:    addi a1, a1, %lo(external_function)
; RV32I-NEXT:    jalr ra, a1, 0
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    jalr zero, ra, 0
  %1 = call i32 @external_function(i32 %a)
  ret i32 %1
}

define i32 @defined_function(i32 %a) nounwind {
; RV32I-LABEL: defined_function:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    addi a0, a0, 1
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    jalr zero, ra, 0
  %1 = add i32 %a, 1
  ret i32 %1
}

define i32 @test_call_defined(i32 %a) nounwind {
; RV32I-LABEL: test_call_defined:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    lui a1, %hi(defined_function)
; RV32I-NEXT:    addi a1, a1, %lo(defined_function)
; RV32I-NEXT:    jalr ra, a1, 0
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    jalr zero, ra, 0
  %1 = call i32 @defined_function(i32 %a) nounwind
  ret i32 %1
}

define i32 @test_call_indirect(i32 (i32)* %a, i32 %b) nounwind {
; RV32I-LABEL: test_call_indirect:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    addi a2, a0, 0
; RV32I-NEXT:    addi a0, a1, 0
; RV32I-NEXT:    jalr ra, a2, 0
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    jalr zero, ra, 0
  %1 = call i32 %a(i32 %b)
  ret i32 %1
}

; Ensure that calls to fastcc functions aren't rejected. Such calls may be
; introduced when compiling with optimisation.

define fastcc i32 @fastcc_function(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: fastcc_function:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    jalr zero, ra, 0
 %1 = add i32 %a, %b
 ret i32 %1
}

define i32 @test_call_fastcc(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: test_call_fastcc:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    sw s1, 4(sp)
; RV32I-NEXT:    addi s0, sp, 16
; RV32I-NEXT:    addi s1, a0, 0
; RV32I-NEXT:    lui a0, %hi(fastcc_function)
; RV32I-NEXT:    addi a2, a0, %lo(fastcc_function)
; RV32I-NEXT:    addi a0, s1, 0
; RV32I-NEXT:    jalr ra, a2, 0
; RV32I-NEXT:    addi a0, s1, 0
; RV32I-NEXT:    lw s1, 4(sp)
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    jalr zero, ra, 0
  %1 = call fastcc i32 @fastcc_function(i32 %a, i32 %b)
  ret i32 %a
}
