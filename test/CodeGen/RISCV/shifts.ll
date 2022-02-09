; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

; Basic shift support is tested as part of ALU.ll. This file ensures that
; shifts which may not be supported natively are lowered properly.

declare i64 @llvm.fshr.i64(i64, i64, i64)
declare i128 @llvm.fshr.i128(i128, i128, i128)

define i64 @lshr64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: lshr64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a3, a2, -32
; RV32I-NEXT:    bltz a3, .LBB0_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    srl a0, a1, a3
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB0_2:
; RV32I-NEXT:    srl a0, a0, a2
; RV32I-NEXT:    li a3, 31
; RV32I-NEXT:    sub a3, a3, a2
; RV32I-NEXT:    slli a4, a1, 1
; RV32I-NEXT:    sll a3, a4, a3
; RV32I-NEXT:    or a0, a0, a3
; RV32I-NEXT:    srl a1, a1, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: lshr64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    ret
  %1 = lshr i64 %a, %b
  ret i64 %1
}

define i64 @lshr64_minsize(i64 %a, i64 %b) minsize nounwind {
; RV32I-LABEL: lshr64_minsize:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __lshrdi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: lshr64_minsize:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srl a0, a0, a1
; RV64I-NEXT:    ret
  %1 = lshr i64 %a, %b
  ret i64 %1
}

define i64 @ashr64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: ashr64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a3, a2, -32
; RV32I-NEXT:    bltz a3, .LBB2_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sra a0, a1, a3
; RV32I-NEXT:    srai a1, a1, 31
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB2_2:
; RV32I-NEXT:    srl a0, a0, a2
; RV32I-NEXT:    li a3, 31
; RV32I-NEXT:    sub a3, a3, a2
; RV32I-NEXT:    slli a4, a1, 1
; RV32I-NEXT:    sll a3, a4, a3
; RV32I-NEXT:    or a0, a0, a3
; RV32I-NEXT:    sra a1, a1, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: ashr64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sra a0, a0, a1
; RV64I-NEXT:    ret
  %1 = ashr i64 %a, %b
  ret i64 %1
}

define i64 @ashr64_minsize(i64 %a, i64 %b) minsize nounwind {
; RV32I-LABEL: ashr64_minsize:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __ashrdi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: ashr64_minsize:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sra a0, a0, a1
; RV64I-NEXT:    ret
  %1 = ashr i64 %a, %b
  ret i64 %1
}

define i64 @shl64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: shl64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi a3, a2, -32
; RV32I-NEXT:    bltz a3, .LBB4_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sll a1, a0, a3
; RV32I-NEXT:    li a0, 0
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    sll a1, a1, a2
; RV32I-NEXT:    li a3, 31
; RV32I-NEXT:    sub a3, a3, a2
; RV32I-NEXT:    srli a4, a0, 1
; RV32I-NEXT:    srl a3, a4, a3
; RV32I-NEXT:    or a1, a1, a3
; RV32I-NEXT:    sll a0, a0, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: shl64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sll a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i64 %a, %b
  ret i64 %1
}

define i64 @shl64_minsize(i64 %a, i64 %b) minsize nounwind {
; RV32I-LABEL: shl64_minsize:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __ashldi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: shl64_minsize:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sll a0, a0, a1
; RV64I-NEXT:    ret
  %1 = shl i64 %a, %b
  ret i64 %1
}

define i128 @lshr128(i128 %a, i128 %b) nounwind {
; RV32I-LABEL: lshr128:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a2, 0(a2)
; RV32I-NEXT:    lw a5, 8(a1)
; RV32I-NEXT:    lw a4, 12(a1)
; RV32I-NEXT:    neg a6, a2
; RV32I-NEXT:    li a3, 64
; RV32I-NEXT:    li t2, 31
; RV32I-NEXT:    li a7, 32
; RV32I-NEXT:    sub t1, a7, a2
; RV32I-NEXT:    sll t0, a5, a6
; RV32I-NEXT:    bltz t1, .LBB6_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv t6, t0
; RV32I-NEXT:    j .LBB6_3
; RV32I-NEXT:  .LBB6_2:
; RV32I-NEXT:    sll a6, a4, a6
; RV32I-NEXT:    sub a7, a3, a2
; RV32I-NEXT:    sub a7, t2, a7
; RV32I-NEXT:    srli t3, a5, 1
; RV32I-NEXT:    srl a7, t3, a7
; RV32I-NEXT:    or t6, a6, a7
; RV32I-NEXT:  .LBB6_3:
; RV32I-NEXT:    lw t5, 4(a1)
; RV32I-NEXT:    addi a6, a2, -32
; RV32I-NEXT:    bgez a6, .LBB6_5
; RV32I-NEXT:  # %bb.4:
; RV32I-NEXT:    srl a7, t5, a2
; RV32I-NEXT:    or t6, t6, a7
; RV32I-NEXT:  .LBB6_5:
; RV32I-NEXT:    addi t4, a2, -96
; RV32I-NEXT:    addi t3, a2, -64
; RV32I-NEXT:    bltz t4, .LBB6_7
; RV32I-NEXT:  # %bb.6:
; RV32I-NEXT:    li a7, 0
; RV32I-NEXT:    bgeu a2, a3, .LBB6_8
; RV32I-NEXT:    j .LBB6_9
; RV32I-NEXT:  .LBB6_7:
; RV32I-NEXT:    srl a7, a4, t3
; RV32I-NEXT:    bltu a2, a3, .LBB6_9
; RV32I-NEXT:  .LBB6_8:
; RV32I-NEXT:    mv t6, a7
; RV32I-NEXT:  .LBB6_9:
; RV32I-NEXT:    mv a7, t5
; RV32I-NEXT:    beqz a2, .LBB6_11
; RV32I-NEXT:  # %bb.10:
; RV32I-NEXT:    mv a7, t6
; RV32I-NEXT:  .LBB6_11:
; RV32I-NEXT:    lw a1, 0(a1)
; RV32I-NEXT:    sub t2, t2, a2
; RV32I-NEXT:    bltz a6, .LBB6_13
; RV32I-NEXT:  # %bb.12:
; RV32I-NEXT:    srl t5, t5, a6
; RV32I-NEXT:    bltz t1, .LBB6_14
; RV32I-NEXT:    j .LBB6_15
; RV32I-NEXT:  .LBB6_13:
; RV32I-NEXT:    srl t6, a1, a2
; RV32I-NEXT:    slli t5, t5, 1
; RV32I-NEXT:    sll t5, t5, t2
; RV32I-NEXT:    or t5, t6, t5
; RV32I-NEXT:    bgez t1, .LBB6_15
; RV32I-NEXT:  .LBB6_14:
; RV32I-NEXT:    or t5, t5, t0
; RV32I-NEXT:  .LBB6_15:
; RV32I-NEXT:    slli t0, a4, 1
; RV32I-NEXT:    bltz t4, .LBB6_17
; RV32I-NEXT:  # %bb.16:
; RV32I-NEXT:    srl t1, a4, t4
; RV32I-NEXT:    bgeu a2, a3, .LBB6_18
; RV32I-NEXT:    j .LBB6_19
; RV32I-NEXT:  .LBB6_17:
; RV32I-NEXT:    li t1, 95
; RV32I-NEXT:    sub t1, t1, a2
; RV32I-NEXT:    sll t1, t0, t1
; RV32I-NEXT:    srl t3, a5, t3
; RV32I-NEXT:    or t1, t3, t1
; RV32I-NEXT:    bltu a2, a3, .LBB6_19
; RV32I-NEXT:  .LBB6_18:
; RV32I-NEXT:    mv t5, t1
; RV32I-NEXT:  .LBB6_19:
; RV32I-NEXT:    bnez a2, .LBB6_22
; RV32I-NEXT:  # %bb.20:
; RV32I-NEXT:    bltz a6, .LBB6_23
; RV32I-NEXT:  .LBB6_21:
; RV32I-NEXT:    srl a5, a4, a6
; RV32I-NEXT:    bgeu a2, a3, .LBB6_24
; RV32I-NEXT:    j .LBB6_25
; RV32I-NEXT:  .LBB6_22:
; RV32I-NEXT:    mv a1, t5
; RV32I-NEXT:    bgez a6, .LBB6_21
; RV32I-NEXT:  .LBB6_23:
; RV32I-NEXT:    srl a5, a5, a2
; RV32I-NEXT:    sll t0, t0, t2
; RV32I-NEXT:    or a5, a5, t0
; RV32I-NEXT:    bltu a2, a3, .LBB6_25
; RV32I-NEXT:  .LBB6_24:
; RV32I-NEXT:    li a5, 0
; RV32I-NEXT:  .LBB6_25:
; RV32I-NEXT:    bltz a6, .LBB6_27
; RV32I-NEXT:  # %bb.26:
; RV32I-NEXT:    li a4, 0
; RV32I-NEXT:    bgeu a2, a3, .LBB6_28
; RV32I-NEXT:    j .LBB6_29
; RV32I-NEXT:  .LBB6_27:
; RV32I-NEXT:    srl a4, a4, a2
; RV32I-NEXT:    bltu a2, a3, .LBB6_29
; RV32I-NEXT:  .LBB6_28:
; RV32I-NEXT:    li a4, 0
; RV32I-NEXT:  .LBB6_29:
; RV32I-NEXT:    sw a4, 12(a0)
; RV32I-NEXT:    sw a5, 8(a0)
; RV32I-NEXT:    sw a1, 0(a0)
; RV32I-NEXT:    sw a7, 4(a0)
; RV32I-NEXT:    ret
;
; RV64I-LABEL: lshr128:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a3, a2, -64
; RV64I-NEXT:    bltz a3, .LBB6_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    srl a0, a1, a3
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB6_2:
; RV64I-NEXT:    srl a0, a0, a2
; RV64I-NEXT:    li a3, 63
; RV64I-NEXT:    sub a3, a3, a2
; RV64I-NEXT:    slli a4, a1, 1
; RV64I-NEXT:    sll a3, a4, a3
; RV64I-NEXT:    or a0, a0, a3
; RV64I-NEXT:    srl a1, a1, a2
; RV64I-NEXT:    ret
  %1 = lshr i128 %a, %b
  ret i128 %1
}

define i128 @ashr128(i128 %a, i128 %b) nounwind {
; RV32I-LABEL: ashr128:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw s0, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    lw a2, 0(a2)
; RV32I-NEXT:    lw a5, 8(a1)
; RV32I-NEXT:    lw a4, 12(a1)
; RV32I-NEXT:    neg a6, a2
; RV32I-NEXT:    li a3, 64
; RV32I-NEXT:    li t3, 31
; RV32I-NEXT:    li a7, 32
; RV32I-NEXT:    sub t2, a7, a2
; RV32I-NEXT:    sll t1, a5, a6
; RV32I-NEXT:    bltz t2, .LBB7_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv s0, t1
; RV32I-NEXT:    j .LBB7_3
; RV32I-NEXT:  .LBB7_2:
; RV32I-NEXT:    sll a6, a4, a6
; RV32I-NEXT:    sub a7, a3, a2
; RV32I-NEXT:    sub a7, t3, a7
; RV32I-NEXT:    srli t0, a5, 1
; RV32I-NEXT:    srl a7, t0, a7
; RV32I-NEXT:    or s0, a6, a7
; RV32I-NEXT:  .LBB7_3:
; RV32I-NEXT:    lw t6, 4(a1)
; RV32I-NEXT:    addi a6, a2, -32
; RV32I-NEXT:    bgez a6, .LBB7_5
; RV32I-NEXT:  # %bb.4:
; RV32I-NEXT:    srl a7, t6, a2
; RV32I-NEXT:    or s0, s0, a7
; RV32I-NEXT:  .LBB7_5:
; RV32I-NEXT:    addi t4, a2, -64
; RV32I-NEXT:    addi t5, a2, -96
; RV32I-NEXT:    srai a7, a4, 31
; RV32I-NEXT:    bltz t5, .LBB7_7
; RV32I-NEXT:  # %bb.6:
; RV32I-NEXT:    mv t0, a7
; RV32I-NEXT:    bgeu a2, a3, .LBB7_8
; RV32I-NEXT:    j .LBB7_9
; RV32I-NEXT:  .LBB7_7:
; RV32I-NEXT:    sra t0, a4, t4
; RV32I-NEXT:    bltu a2, a3, .LBB7_9
; RV32I-NEXT:  .LBB7_8:
; RV32I-NEXT:    mv s0, t0
; RV32I-NEXT:  .LBB7_9:
; RV32I-NEXT:    mv t0, t6
; RV32I-NEXT:    beqz a2, .LBB7_11
; RV32I-NEXT:  # %bb.10:
; RV32I-NEXT:    mv t0, s0
; RV32I-NEXT:  .LBB7_11:
; RV32I-NEXT:    lw a1, 0(a1)
; RV32I-NEXT:    sub t3, t3, a2
; RV32I-NEXT:    bltz a6, .LBB7_13
; RV32I-NEXT:  # %bb.12:
; RV32I-NEXT:    srl t6, t6, a6
; RV32I-NEXT:    bltz t2, .LBB7_14
; RV32I-NEXT:    j .LBB7_15
; RV32I-NEXT:  .LBB7_13:
; RV32I-NEXT:    srl s0, a1, a2
; RV32I-NEXT:    slli t6, t6, 1
; RV32I-NEXT:    sll t6, t6, t3
; RV32I-NEXT:    or t6, s0, t6
; RV32I-NEXT:    bgez t2, .LBB7_15
; RV32I-NEXT:  .LBB7_14:
; RV32I-NEXT:    or t6, t6, t1
; RV32I-NEXT:  .LBB7_15:
; RV32I-NEXT:    slli t1, a4, 1
; RV32I-NEXT:    bltz t5, .LBB7_17
; RV32I-NEXT:  # %bb.16:
; RV32I-NEXT:    sra t2, a4, t5
; RV32I-NEXT:    bgeu a2, a3, .LBB7_18
; RV32I-NEXT:    j .LBB7_19
; RV32I-NEXT:  .LBB7_17:
; RV32I-NEXT:    li t2, 95
; RV32I-NEXT:    sub t2, t2, a2
; RV32I-NEXT:    sll t2, t1, t2
; RV32I-NEXT:    srl t4, a5, t4
; RV32I-NEXT:    or t2, t4, t2
; RV32I-NEXT:    bltu a2, a3, .LBB7_19
; RV32I-NEXT:  .LBB7_18:
; RV32I-NEXT:    mv t6, t2
; RV32I-NEXT:  .LBB7_19:
; RV32I-NEXT:    bnez a2, .LBB7_22
; RV32I-NEXT:  # %bb.20:
; RV32I-NEXT:    bltz a6, .LBB7_23
; RV32I-NEXT:  .LBB7_21:
; RV32I-NEXT:    sra a5, a4, a6
; RV32I-NEXT:    bgeu a2, a3, .LBB7_24
; RV32I-NEXT:    j .LBB7_25
; RV32I-NEXT:  .LBB7_22:
; RV32I-NEXT:    mv a1, t6
; RV32I-NEXT:    bgez a6, .LBB7_21
; RV32I-NEXT:  .LBB7_23:
; RV32I-NEXT:    srl a5, a5, a2
; RV32I-NEXT:    sll t1, t1, t3
; RV32I-NEXT:    or a5, a5, t1
; RV32I-NEXT:    bltu a2, a3, .LBB7_25
; RV32I-NEXT:  .LBB7_24:
; RV32I-NEXT:    mv a5, a7
; RV32I-NEXT:  .LBB7_25:
; RV32I-NEXT:    bltz a6, .LBB7_27
; RV32I-NEXT:  # %bb.26:
; RV32I-NEXT:    mv a4, a7
; RV32I-NEXT:    bgeu a2, a3, .LBB7_28
; RV32I-NEXT:    j .LBB7_29
; RV32I-NEXT:  .LBB7_27:
; RV32I-NEXT:    sra a4, a4, a2
; RV32I-NEXT:    bltu a2, a3, .LBB7_29
; RV32I-NEXT:  .LBB7_28:
; RV32I-NEXT:    mv a4, a7
; RV32I-NEXT:  .LBB7_29:
; RV32I-NEXT:    sw a4, 12(a0)
; RV32I-NEXT:    sw a5, 8(a0)
; RV32I-NEXT:    sw a1, 0(a0)
; RV32I-NEXT:    sw t0, 4(a0)
; RV32I-NEXT:    lw s0, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: ashr128:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a3, a2, -64
; RV64I-NEXT:    bltz a3, .LBB7_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    sra a0, a1, a3
; RV64I-NEXT:    srai a1, a1, 63
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB7_2:
; RV64I-NEXT:    srl a0, a0, a2
; RV64I-NEXT:    li a3, 63
; RV64I-NEXT:    sub a3, a3, a2
; RV64I-NEXT:    slli a4, a1, 1
; RV64I-NEXT:    sll a3, a4, a3
; RV64I-NEXT:    or a0, a0, a3
; RV64I-NEXT:    sra a1, a1, a2
; RV64I-NEXT:    ret
  %1 = ashr i128 %a, %b
  ret i128 %1
}

define i128 @shl128(i128 %a, i128 %b) nounwind {
; RV32I-LABEL: shl128:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a2, 0(a2)
; RV32I-NEXT:    lw a5, 4(a1)
; RV32I-NEXT:    lw a4, 0(a1)
; RV32I-NEXT:    neg a6, a2
; RV32I-NEXT:    li a3, 64
; RV32I-NEXT:    li t2, 31
; RV32I-NEXT:    li a7, 32
; RV32I-NEXT:    sub t1, a7, a2
; RV32I-NEXT:    srl t0, a5, a6
; RV32I-NEXT:    bltz t1, .LBB8_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv t6, t0
; RV32I-NEXT:    j .LBB8_3
; RV32I-NEXT:  .LBB8_2:
; RV32I-NEXT:    srl a6, a4, a6
; RV32I-NEXT:    sub a7, a3, a2
; RV32I-NEXT:    sub a7, t2, a7
; RV32I-NEXT:    slli t3, a5, 1
; RV32I-NEXT:    sll a7, t3, a7
; RV32I-NEXT:    or t6, a6, a7
; RV32I-NEXT:  .LBB8_3:
; RV32I-NEXT:    lw t5, 8(a1)
; RV32I-NEXT:    addi a6, a2, -32
; RV32I-NEXT:    bgez a6, .LBB8_5
; RV32I-NEXT:  # %bb.4:
; RV32I-NEXT:    sll a7, t5, a2
; RV32I-NEXT:    or t6, t6, a7
; RV32I-NEXT:  .LBB8_5:
; RV32I-NEXT:    addi t4, a2, -96
; RV32I-NEXT:    addi t3, a2, -64
; RV32I-NEXT:    bltz t4, .LBB8_7
; RV32I-NEXT:  # %bb.6:
; RV32I-NEXT:    li a7, 0
; RV32I-NEXT:    bgeu a2, a3, .LBB8_8
; RV32I-NEXT:    j .LBB8_9
; RV32I-NEXT:  .LBB8_7:
; RV32I-NEXT:    sll a7, a4, t3
; RV32I-NEXT:    bltu a2, a3, .LBB8_9
; RV32I-NEXT:  .LBB8_8:
; RV32I-NEXT:    mv t6, a7
; RV32I-NEXT:  .LBB8_9:
; RV32I-NEXT:    mv a7, t5
; RV32I-NEXT:    beqz a2, .LBB8_11
; RV32I-NEXT:  # %bb.10:
; RV32I-NEXT:    mv a7, t6
; RV32I-NEXT:  .LBB8_11:
; RV32I-NEXT:    lw a1, 12(a1)
; RV32I-NEXT:    sub t2, t2, a2
; RV32I-NEXT:    bltz a6, .LBB8_13
; RV32I-NEXT:  # %bb.12:
; RV32I-NEXT:    sll t5, t5, a6
; RV32I-NEXT:    bltz t1, .LBB8_14
; RV32I-NEXT:    j .LBB8_15
; RV32I-NEXT:  .LBB8_13:
; RV32I-NEXT:    sll t6, a1, a2
; RV32I-NEXT:    srli t5, t5, 1
; RV32I-NEXT:    srl t5, t5, t2
; RV32I-NEXT:    or t5, t6, t5
; RV32I-NEXT:    bgez t1, .LBB8_15
; RV32I-NEXT:  .LBB8_14:
; RV32I-NEXT:    or t5, t5, t0
; RV32I-NEXT:  .LBB8_15:
; RV32I-NEXT:    srli t0, a4, 1
; RV32I-NEXT:    bltz t4, .LBB8_17
; RV32I-NEXT:  # %bb.16:
; RV32I-NEXT:    sll t1, a4, t4
; RV32I-NEXT:    bgeu a2, a3, .LBB8_18
; RV32I-NEXT:    j .LBB8_19
; RV32I-NEXT:  .LBB8_17:
; RV32I-NEXT:    li t1, 95
; RV32I-NEXT:    sub t1, t1, a2
; RV32I-NEXT:    srl t1, t0, t1
; RV32I-NEXT:    sll t3, a5, t3
; RV32I-NEXT:    or t1, t3, t1
; RV32I-NEXT:    bltu a2, a3, .LBB8_19
; RV32I-NEXT:  .LBB8_18:
; RV32I-NEXT:    mv t5, t1
; RV32I-NEXT:  .LBB8_19:
; RV32I-NEXT:    bnez a2, .LBB8_22
; RV32I-NEXT:  # %bb.20:
; RV32I-NEXT:    bltz a6, .LBB8_23
; RV32I-NEXT:  .LBB8_21:
; RV32I-NEXT:    sll a5, a4, a6
; RV32I-NEXT:    bgeu a2, a3, .LBB8_24
; RV32I-NEXT:    j .LBB8_25
; RV32I-NEXT:  .LBB8_22:
; RV32I-NEXT:    mv a1, t5
; RV32I-NEXT:    bgez a6, .LBB8_21
; RV32I-NEXT:  .LBB8_23:
; RV32I-NEXT:    sll a5, a5, a2
; RV32I-NEXT:    srl t0, t0, t2
; RV32I-NEXT:    or a5, a5, t0
; RV32I-NEXT:    bltu a2, a3, .LBB8_25
; RV32I-NEXT:  .LBB8_24:
; RV32I-NEXT:    li a5, 0
; RV32I-NEXT:  .LBB8_25:
; RV32I-NEXT:    bltz a6, .LBB8_27
; RV32I-NEXT:  # %bb.26:
; RV32I-NEXT:    li a4, 0
; RV32I-NEXT:    bgeu a2, a3, .LBB8_28
; RV32I-NEXT:    j .LBB8_29
; RV32I-NEXT:  .LBB8_27:
; RV32I-NEXT:    sll a4, a4, a2
; RV32I-NEXT:    bltu a2, a3, .LBB8_29
; RV32I-NEXT:  .LBB8_28:
; RV32I-NEXT:    li a4, 0
; RV32I-NEXT:  .LBB8_29:
; RV32I-NEXT:    sw a4, 0(a0)
; RV32I-NEXT:    sw a5, 4(a0)
; RV32I-NEXT:    sw a1, 12(a0)
; RV32I-NEXT:    sw a7, 8(a0)
; RV32I-NEXT:    ret
;
; RV64I-LABEL: shl128:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a3, a2, -64
; RV64I-NEXT:    bltz a3, .LBB8_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    sll a1, a0, a3
; RV64I-NEXT:    li a0, 0
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB8_2:
; RV64I-NEXT:    sll a1, a1, a2
; RV64I-NEXT:    li a3, 63
; RV64I-NEXT:    sub a3, a3, a2
; RV64I-NEXT:    srli a4, a0, 1
; RV64I-NEXT:    srl a3, a4, a3
; RV64I-NEXT:    or a1, a1, a3
; RV64I-NEXT:    sll a0, a0, a2
; RV64I-NEXT:    ret
  %1 = shl i128 %a, %b
  ret i128 %1
}

define i64 @fshr64_minsize(i64 %a, i64 %b) minsize nounwind {
; RV32I-LABEL: fshr64_minsize:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a4, a2, 32
; RV32I-NEXT:    mv a3, a0
; RV32I-NEXT:    beqz a4, .LBB9_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a3, a1
; RV32I-NEXT:  .LBB9_2:
; RV32I-NEXT:    srl a5, a3, a2
; RV32I-NEXT:    beqz a4, .LBB9_4
; RV32I-NEXT:  # %bb.3:
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:  .LBB9_4:
; RV32I-NEXT:    slli a0, a1, 1
; RV32I-NEXT:    not a4, a2
; RV32I-NEXT:    sll a0, a0, a4
; RV32I-NEXT:    or a0, a0, a5
; RV32I-NEXT:    srl a1, a1, a2
; RV32I-NEXT:    slli a2, a3, 1
; RV32I-NEXT:    sll a2, a2, a4
; RV32I-NEXT:    or a1, a2, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fshr64_minsize:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srl a2, a0, a1
; RV64I-NEXT:    neg a1, a1
; RV64I-NEXT:    sll a0, a0, a1
; RV64I-NEXT:    or a0, a2, a0
; RV64I-NEXT:    ret
  %res = tail call i64 @llvm.fshr.i64(i64 %a, i64 %a, i64 %b)
  ret i64 %res
}

define i128 @fshr128_minsize(i128 %a, i128 %b) minsize nounwind {
; RV32I-LABEL: fshr128_minsize:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lw a3, 8(a1)
; RV32I-NEXT:    lw t2, 0(a1)
; RV32I-NEXT:    lw a2, 0(a2)
; RV32I-NEXT:    lw a7, 4(a1)
; RV32I-NEXT:    lw a1, 12(a1)
; RV32I-NEXT:    andi t1, a2, 64
; RV32I-NEXT:    mv t0, a7
; RV32I-NEXT:    mv a4, t2
; RV32I-NEXT:    beqz t1, .LBB10_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv t0, a1
; RV32I-NEXT:    mv a4, a3
; RV32I-NEXT:  .LBB10_2:
; RV32I-NEXT:    andi a6, a2, 32
; RV32I-NEXT:    mv a5, a4
; RV32I-NEXT:    bnez a6, .LBB10_13
; RV32I-NEXT:  # %bb.3:
; RV32I-NEXT:    bnez t1, .LBB10_14
; RV32I-NEXT:  .LBB10_4:
; RV32I-NEXT:    beqz a6, .LBB10_6
; RV32I-NEXT:  .LBB10_5:
; RV32I-NEXT:    mv t0, a3
; RV32I-NEXT:  .LBB10_6:
; RV32I-NEXT:    slli t3, t0, 1
; RV32I-NEXT:    not t2, a2
; RV32I-NEXT:    beqz t1, .LBB10_8
; RV32I-NEXT:  # %bb.7:
; RV32I-NEXT:    mv a1, a7
; RV32I-NEXT:  .LBB10_8:
; RV32I-NEXT:    srl a7, a5, a2
; RV32I-NEXT:    sll t1, t3, t2
; RV32I-NEXT:    srl t0, t0, a2
; RV32I-NEXT:    beqz a6, .LBB10_10
; RV32I-NEXT:  # %bb.9:
; RV32I-NEXT:    mv a3, a1
; RV32I-NEXT:  .LBB10_10:
; RV32I-NEXT:    or a7, t1, a7
; RV32I-NEXT:    slli t1, a3, 1
; RV32I-NEXT:    sll t1, t1, t2
; RV32I-NEXT:    or t0, t1, t0
; RV32I-NEXT:    srl a3, a3, a2
; RV32I-NEXT:    beqz a6, .LBB10_12
; RV32I-NEXT:  # %bb.11:
; RV32I-NEXT:    mv a1, a4
; RV32I-NEXT:  .LBB10_12:
; RV32I-NEXT:    slli a4, a1, 1
; RV32I-NEXT:    sll a4, a4, t2
; RV32I-NEXT:    or a3, a4, a3
; RV32I-NEXT:    srl a1, a1, a2
; RV32I-NEXT:    slli a2, a5, 1
; RV32I-NEXT:    sll a2, a2, t2
; RV32I-NEXT:    or a1, a2, a1
; RV32I-NEXT:    sw a1, 12(a0)
; RV32I-NEXT:    sw a3, 8(a0)
; RV32I-NEXT:    sw t0, 4(a0)
; RV32I-NEXT:    sw a7, 0(a0)
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB10_13:
; RV32I-NEXT:    mv a5, t0
; RV32I-NEXT:    beqz t1, .LBB10_4
; RV32I-NEXT:  .LBB10_14:
; RV32I-NEXT:    mv a3, t2
; RV32I-NEXT:    bnez a6, .LBB10_5
; RV32I-NEXT:    j .LBB10_6
;
; RV64I-LABEL: fshr128_minsize:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a4, a2, 64
; RV64I-NEXT:    mv a3, a0
; RV64I-NEXT:    beqz a4, .LBB10_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a3, a1
; RV64I-NEXT:  .LBB10_2:
; RV64I-NEXT:    srl a5, a3, a2
; RV64I-NEXT:    beqz a4, .LBB10_4
; RV64I-NEXT:  # %bb.3:
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:  .LBB10_4:
; RV64I-NEXT:    slli a0, a1, 1
; RV64I-NEXT:    not a4, a2
; RV64I-NEXT:    sll a0, a0, a4
; RV64I-NEXT:    or a0, a0, a5
; RV64I-NEXT:    srl a1, a1, a2
; RV64I-NEXT:    slli a2, a3, 1
; RV64I-NEXT:    sll a2, a2, a4
; RV64I-NEXT:    or a1, a2, a1
; RV64I-NEXT:    ret
  %res = tail call i128 @llvm.fshr.i128(i128 %a, i128 %a, i128 %b)
  ret i128 %res
}
