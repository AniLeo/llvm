; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s

@x = local_unnamed_addr global fp128 0xL00000000000000007FFF000000000000, align 16
@y = local_unnamed_addr global fp128 0xL00000000000000007FFF000000000000, align 16

; Besides anything else, these tests help verify that libcall ABI lowering
; works correctly

define i32 @test_load_and_cmp() nounwind {
; RV32I-LABEL: test_load_and_cmp:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -48
; RV32I-NEXT:    sw ra, 44(sp)
; RV32I-NEXT:    lui a0, %hi(y+12)
; RV32I-NEXT:    addi a0, a0, %lo(y+12)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 20(sp)
; RV32I-NEXT:    lui a0, %hi(y+8)
; RV32I-NEXT:    addi a0, a0, %lo(y+8)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 16(sp)
; RV32I-NEXT:    lui a0, %hi(y+4)
; RV32I-NEXT:    addi a0, a0, %lo(y+4)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 12(sp)
; RV32I-NEXT:    lui a0, %hi(y)
; RV32I-NEXT:    addi a0, a0, %lo(y)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 8(sp)
; RV32I-NEXT:    lui a0, %hi(x+12)
; RV32I-NEXT:    addi a0, a0, %lo(x+12)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 36(sp)
; RV32I-NEXT:    lui a0, %hi(x+8)
; RV32I-NEXT:    addi a0, a0, %lo(x+8)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 32(sp)
; RV32I-NEXT:    lui a0, %hi(x+4)
; RV32I-NEXT:    addi a0, a0, %lo(x+4)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 28(sp)
; RV32I-NEXT:    lui a0, %hi(x)
; RV32I-NEXT:    addi a0, a0, %lo(x)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 24(sp)
; RV32I-NEXT:    lui a0, %hi(__netf2)
; RV32I-NEXT:    addi a2, a0, %lo(__netf2)
; RV32I-NEXT:    addi a0, sp, 24
; RV32I-NEXT:    addi a1, sp, 8
; RV32I-NEXT:    jalr a2
; RV32I-NEXT:    xor a0, a0, zero
; RV32I-NEXT:    snez a0, a0
; RV32I-NEXT:    lw ra, 44(sp)
; RV32I-NEXT:    addi sp, sp, 48
; RV32I-NEXT:    ret
  %1 = load fp128, fp128* @x, align 16
  %2 = load fp128, fp128* @y, align 16
  %cmp = fcmp une fp128 %1, %2
  %3 = zext i1 %cmp to i32
  ret i32 %3
}

define i32 @test_add_and_fptosi() nounwind {
; RV32I-LABEL: test_add_and_fptosi:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -80
; RV32I-NEXT:    sw ra, 76(sp)
; RV32I-NEXT:    lui a0, %hi(y+12)
; RV32I-NEXT:    addi a0, a0, %lo(y+12)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 36(sp)
; RV32I-NEXT:    lui a0, %hi(y+8)
; RV32I-NEXT:    addi a0, a0, %lo(y+8)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 32(sp)
; RV32I-NEXT:    lui a0, %hi(y+4)
; RV32I-NEXT:    addi a0, a0, %lo(y+4)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 28(sp)
; RV32I-NEXT:    lui a0, %hi(y)
; RV32I-NEXT:    addi a0, a0, %lo(y)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 24(sp)
; RV32I-NEXT:    lui a0, %hi(x+12)
; RV32I-NEXT:    addi a0, a0, %lo(x+12)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 52(sp)
; RV32I-NEXT:    lui a0, %hi(x+8)
; RV32I-NEXT:    addi a0, a0, %lo(x+8)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 48(sp)
; RV32I-NEXT:    lui a0, %hi(x+4)
; RV32I-NEXT:    addi a0, a0, %lo(x+4)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 44(sp)
; RV32I-NEXT:    lui a0, %hi(x)
; RV32I-NEXT:    addi a0, a0, %lo(x)
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    sw a0, 40(sp)
; RV32I-NEXT:    lui a0, %hi(__addtf3)
; RV32I-NEXT:    addi a3, a0, %lo(__addtf3)
; RV32I-NEXT:    addi a0, sp, 56
; RV32I-NEXT:    addi a1, sp, 40
; RV32I-NEXT:    addi a2, sp, 24
; RV32I-NEXT:    jalr a3
; RV32I-NEXT:    lw a0, 68(sp)
; RV32I-NEXT:    sw a0, 20(sp)
; RV32I-NEXT:    lw a0, 64(sp)
; RV32I-NEXT:    sw a0, 16(sp)
; RV32I-NEXT:    lw a0, 60(sp)
; RV32I-NEXT:    sw a0, 12(sp)
; RV32I-NEXT:    lw a0, 56(sp)
; RV32I-NEXT:    sw a0, 8(sp)
; RV32I-NEXT:    lui a0, %hi(__fixtfsi)
; RV32I-NEXT:    addi a1, a0, %lo(__fixtfsi)
; RV32I-NEXT:    addi a0, sp, 8
; RV32I-NEXT:    jalr a1
; RV32I-NEXT:    lw ra, 76(sp)
; RV32I-NEXT:    addi sp, sp, 80
; RV32I-NEXT:    ret
  %1 = load fp128, fp128* @x, align 16
  %2 = load fp128, fp128* @y, align 16
  %3 = fadd fp128 %1, %2
  %4 = fptosi fp128 %3 to i32
  ret i32 %4
}
