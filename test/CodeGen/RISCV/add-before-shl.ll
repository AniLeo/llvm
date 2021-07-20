; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs --riscv-no-aliases < %s \
; RUN:   | FileCheck -check-prefixes=RV32I %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs --riscv-no-aliases < %s \
; RUN:   | FileCheck -check-prefixes=RV64I %s
; RUN: llc -mtriple=riscv32 -mattr=+c -verify-machineinstrs --riscv-no-aliases \
; RUN:   < %s | FileCheck -check-prefixes=RV32C %s
; RUN: llc -mtriple=riscv64 -mattr=+c -verify-machineinstrs --riscv-no-aliases \
; RUN:   < %s | FileCheck -check-prefixes=RV64C %s

; These test that constant adds are not moved after shifts by DAGCombine,
; if the constant is cheaper to materialise before it has been shifted.

define signext i32 @add_small_const(i32 signext %a) nounwind {
; RV32I-LABEL: add_small_const:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 1
; RV32I-NEXT:    slli a0, a0, 24
; RV32I-NEXT:    srai a0, a0, 24
; RV32I-NEXT:    jalr zero, 0(ra)
;
; RV64I-LABEL: add_small_const:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 1
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srai a0, a0, 56
; RV64I-NEXT:    jalr zero, 0(ra)
;
; RV32C-LABEL: add_small_const:
; RV32C:       # %bb.0:
; RV32C-NEXT:    c.addi a0, 1
; RV32C-NEXT:    c.slli a0, 24
; RV32C-NEXT:    c.srai a0, 24
; RV32C-NEXT:    c.jr ra
;
; RV64C-LABEL: add_small_const:
; RV64C:       # %bb.0:
; RV64C-NEXT:    c.addi a0, 1
; RV64C-NEXT:    c.slli a0, 56
; RV64C-NEXT:    c.srai a0, 56
; RV64C-NEXT:    c.jr ra
  %1 = add i32 %a, 1
  %2 = shl i32 %1, 24
  %3 = ashr i32 %2, 24
  ret i32 %3
}

define signext i32 @add_large_const(i32 signext %a) nounwind {
; RV32I-LABEL: add_large_const:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 16
; RV32I-NEXT:    lui a1, 65520
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    srai a0, a0, 16
; RV32I-NEXT:    jalr zero, 0(ra)
;
; RV64I-LABEL: add_large_const:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    slli a0, a0, 48
; RV64I-NEXT:    srai a0, a0, 48
; RV64I-NEXT:    jalr zero, 0(ra)
;
; RV32C-LABEL: add_large_const:
; RV32C:       # %bb.0:
; RV32C-NEXT:    c.slli a0, 16
; RV32C-NEXT:    lui a1, 65520
; RV32C-NEXT:    c.add a0, a1
; RV32C-NEXT:    c.srai a0, 16
; RV32C-NEXT:    c.jr ra
;
; RV64C-LABEL: add_large_const:
; RV64C:       # %bb.0:
; RV64C-NEXT:    c.lui a1, 1
; RV64C-NEXT:    c.addiw a1, -1
; RV64C-NEXT:    c.add a0, a1
; RV64C-NEXT:    c.slli a0, 48
; RV64C-NEXT:    c.srai a0, 48
; RV64C-NEXT:    c.jr ra
  %1 = add i32 %a, 4095
  %2 = shl i32 %1, 16
  %3 = ashr i32 %2, 16
  ret i32 %3
}

define signext i32 @add_huge_const(i32 signext %a) nounwind {
; RV32I-LABEL: add_huge_const:
; RV32I:       # %bb.0:
; RV32I-NEXT:    slli a0, a0, 16
; RV32I-NEXT:    lui a1, 524272
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    srai a0, a0, 16
; RV32I-NEXT:    jalr zero, 0(ra)
;
; RV64I-LABEL: add_huge_const:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 8
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    slli a0, a0, 48
; RV64I-NEXT:    srai a0, a0, 48
; RV64I-NEXT:    jalr zero, 0(ra)
;
; RV32C-LABEL: add_huge_const:
; RV32C:       # %bb.0:
; RV32C-NEXT:    c.slli a0, 16
; RV32C-NEXT:    lui a1, 524272
; RV32C-NEXT:    c.add a0, a1
; RV32C-NEXT:    c.srai a0, 16
; RV32C-NEXT:    c.jr ra
;
; RV64C-LABEL: add_huge_const:
; RV64C:       # %bb.0:
; RV64C-NEXT:    c.lui a1, 8
; RV64C-NEXT:    c.addiw a1, -1
; RV64C-NEXT:    c.add a0, a1
; RV64C-NEXT:    c.slli a0, 48
; RV64C-NEXT:    c.srai a0, 48
; RV64C-NEXT:    c.jr ra
  %1 = add i32 %a, 32767
  %2 = shl i32 %1, 16
  %3 = ashr i32 %2, 16
  ret i32 %3
}

define signext i24 @add_non_machine_type(i24 signext %a) nounwind {
; RV32I-LABEL: add_non_machine_type:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a0, a0, 256
; RV32I-NEXT:    slli a0, a0, 20
; RV32I-NEXT:    srai a0, a0, 8
; RV32I-NEXT:    jalr zero, 0(ra)
;
; RV64I-LABEL: add_non_machine_type:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a0, a0, 256
; RV64I-NEXT:    slli a0, a0, 52
; RV64I-NEXT:    srai a0, a0, 40
; RV64I-NEXT:    jalr zero, 0(ra)
;
; RV32C-LABEL: add_non_machine_type:
; RV32C:       # %bb.0:
; RV32C-NEXT:    addi a0, a0, 256
; RV32C-NEXT:    c.slli a0, 20
; RV32C-NEXT:    c.srai a0, 8
; RV32C-NEXT:    c.jr ra
;
; RV64C-LABEL: add_non_machine_type:
; RV64C:       # %bb.0:
; RV64C-NEXT:    addi a0, a0, 256
; RV64C-NEXT:    c.slli a0, 52
; RV64C-NEXT:    c.srai a0, 40
; RV64C-NEXT:    c.jr ra
  %1 = add i24 %a, 256
  %2 = shl i24 %1, 12
  ret i24 %2
}

define i128 @add_wide_operand(i128 %a) nounwind {
; RV32I-LABEL: add_wide_operand:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a2, 0(a1)
; RV32I-NEXT:    lw a3, 4(a1)
; RV32I-NEXT:    lw a6, 12(a1)
; RV32I-NEXT:    lw a1, 8(a1)
; RV32I-NEXT:    srli a5, a2, 29
; RV32I-NEXT:    slli a4, a3, 3
; RV32I-NEXT:    or a4, a4, a5
; RV32I-NEXT:    srli a3, a3, 29
; RV32I-NEXT:    slli a5, a1, 3
; RV32I-NEXT:    or a3, a5, a3
; RV32I-NEXT:    srli a1, a1, 29
; RV32I-NEXT:    slli a5, a6, 3
; RV32I-NEXT:    or a1, a5, a1
; RV32I-NEXT:    slli a2, a2, 3
; RV32I-NEXT:    lui a5, 128
; RV32I-NEXT:    add a1, a1, a5
; RV32I-NEXT:    sw a2, 0(a0)
; RV32I-NEXT:    sw a3, 8(a0)
; RV32I-NEXT:    sw a4, 4(a0)
; RV32I-NEXT:    sw a1, 12(a0)
; RV32I-NEXT:    jalr zero, 0(ra)
;
; RV64I-LABEL: add_wide_operand:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a2, a0, 61
; RV64I-NEXT:    slli a1, a1, 3
; RV64I-NEXT:    or a1, a1, a2
; RV64I-NEXT:    slli a0, a0, 3
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    slli a2, a2, 51
; RV64I-NEXT:    add a1, a1, a2
; RV64I-NEXT:    jalr zero, 0(ra)
;
; RV32C-LABEL: add_wide_operand:
; RV32C:       # %bb.0:
; RV32C-NEXT:    c.lw a2, 0(a1)
; RV32C-NEXT:    c.lw a3, 4(a1)
; RV32C-NEXT:    lw a6, 12(a1)
; RV32C-NEXT:    c.lw a1, 8(a1)
; RV32C-NEXT:    srli a5, a2, 29
; RV32C-NEXT:    slli a4, a3, 3
; RV32C-NEXT:    c.or a4, a5
; RV32C-NEXT:    c.srli a3, 29
; RV32C-NEXT:    slli a5, a1, 3
; RV32C-NEXT:    c.or a3, a5
; RV32C-NEXT:    c.srli a1, 29
; RV32C-NEXT:    slli a5, a6, 3
; RV32C-NEXT:    c.or a1, a5
; RV32C-NEXT:    c.slli a2, 3
; RV32C-NEXT:    lui a5, 128
; RV32C-NEXT:    c.add a1, a5
; RV32C-NEXT:    c.sw a2, 0(a0)
; RV32C-NEXT:    c.sw a3, 8(a0)
; RV32C-NEXT:    c.sw a4, 4(a0)
; RV32C-NEXT:    c.sw a1, 12(a0)
; RV32C-NEXT:    c.jr ra
;
; RV64C-LABEL: add_wide_operand:
; RV64C:       # %bb.0:
; RV64C-NEXT:    srli a2, a0, 61
; RV64C-NEXT:    c.slli a1, 3
; RV64C-NEXT:    c.or a1, a2
; RV64C-NEXT:    c.slli a0, 3
; RV64C-NEXT:    c.li a2, 1
; RV64C-NEXT:    c.slli a2, 51
; RV64C-NEXT:    c.add a1, a2
; RV64C-NEXT:    c.jr ra
  %1 = add i128 %a, 5192296858534827628530496329220096
  %2 = shl i128 %1, 3
  ret i128 %2
}
