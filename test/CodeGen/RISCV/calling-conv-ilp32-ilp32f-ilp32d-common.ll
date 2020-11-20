; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I-FPELIM %s
; RUN: llc -mtriple=riscv32 -mattr=+f -target-abi ilp32f \
; RUN:    -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I-FPELIM %s
; RUN: llc -mtriple=riscv32 -mattr=+d -target-abi ilp32d \
; RUN:    -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I-FPELIM %s
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -frame-pointer=all < %s \
; RUN:   | FileCheck -check-prefix=RV32I-WITHFP %s
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -frame-pointer=all \
; RUN:   -mattr=+f -target-abi ilp32f < %s \
; RUN:   | FileCheck -check-prefix=RV32I-WITHFP %s
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -frame-pointer=all \
; RUN:   -mattr=+d -target-abi ilp32d < %s \
; RUN:   | FileCheck -check-prefix=RV32I-WITHFP %s

; This file contains tests that should have identical output for the ilp32,
; ilp32f, and ilp32d ABIs. i.e. where no arguments are passed according to
; the floating point ABI. As well as calling convention details, we check that
; ra and fp are consistently stored to fp-4 and fp-8.

; Check that on RV32, i64 is passed in a pair of registers. Unlike
; the convention for varargs, this need not be an aligned pair.

define i32 @callee_i64_in_regs(i32 %a, i64 %b) nounwind {
; RV32I-FPELIM-LABEL: callee_i64_in_regs:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    add a0, a0, a1
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_i64_in_regs:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    add a0, a0, a1
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %b_trunc = trunc i64 %b to i32
  %1 = add i32 %a, %b_trunc
  ret i32 %1
}

define i32 @caller_i64_in_regs() nounwind {
; RV32I-FPELIM-LABEL: caller_i64_in_regs:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -16
; RV32I-FPELIM-NEXT:    sw ra, 12(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 1
; RV32I-FPELIM-NEXT:    addi a1, zero, 2
; RV32I-FPELIM-NEXT:    mv a2, zero
; RV32I-FPELIM-NEXT:    call callee_i64_in_regs
; RV32I-FPELIM-NEXT:    lw ra, 12(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 16
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_i64_in_regs:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    addi a0, zero, 1
; RV32I-WITHFP-NEXT:    addi a1, zero, 2
; RV32I-WITHFP-NEXT:    mv a2, zero
; RV32I-WITHFP-NEXT:    call callee_i64_in_regs
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %1 = call i32 @callee_i64_in_regs(i32 1, i64 2)
  ret i32 %1
}

; Check that the stack is used once the GPRs are exhausted

define i32 @callee_many_scalars(i8 %a, i16 %b, i32 %c, i64 %d, i32 %e, i32 %f, i64 %g, i32 %h) nounwind {
; RV32I-FPELIM-LABEL: callee_many_scalars:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    lw t0, 4(sp)
; RV32I-FPELIM-NEXT:    lw t1, 0(sp)
; RV32I-FPELIM-NEXT:    andi t2, a0, 255
; RV32I-FPELIM-NEXT:    lui a0, 16
; RV32I-FPELIM-NEXT:    addi a0, a0, -1
; RV32I-FPELIM-NEXT:    and a0, a1, a0
; RV32I-FPELIM-NEXT:    add a0, t2, a0
; RV32I-FPELIM-NEXT:    add a0, a0, a2
; RV32I-FPELIM-NEXT:    xor a1, a4, t1
; RV32I-FPELIM-NEXT:    xor a2, a3, a7
; RV32I-FPELIM-NEXT:    or a1, a2, a1
; RV32I-FPELIM-NEXT:    seqz a1, a1
; RV32I-FPELIM-NEXT:    add a0, a1, a0
; RV32I-FPELIM-NEXT:    add a0, a0, a5
; RV32I-FPELIM-NEXT:    add a0, a0, a6
; RV32I-FPELIM-NEXT:    add a0, a0, t0
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_many_scalars:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    lw t0, 4(s0)
; RV32I-WITHFP-NEXT:    lw t1, 0(s0)
; RV32I-WITHFP-NEXT:    andi t2, a0, 255
; RV32I-WITHFP-NEXT:    lui a0, 16
; RV32I-WITHFP-NEXT:    addi a0, a0, -1
; RV32I-WITHFP-NEXT:    and a0, a1, a0
; RV32I-WITHFP-NEXT:    add a0, t2, a0
; RV32I-WITHFP-NEXT:    add a0, a0, a2
; RV32I-WITHFP-NEXT:    xor a1, a4, t1
; RV32I-WITHFP-NEXT:    xor a2, a3, a7
; RV32I-WITHFP-NEXT:    or a1, a2, a1
; RV32I-WITHFP-NEXT:    seqz a1, a1
; RV32I-WITHFP-NEXT:    add a0, a1, a0
; RV32I-WITHFP-NEXT:    add a0, a0, a5
; RV32I-WITHFP-NEXT:    add a0, a0, a6
; RV32I-WITHFP-NEXT:    add a0, a0, t0
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %a_ext = zext i8 %a to i32
  %b_ext = zext i16 %b to i32
  %1 = add i32 %a_ext, %b_ext
  %2 = add i32 %1, %c
  %3 = icmp eq i64 %d, %g
  %4 = zext i1 %3 to i32
  %5 = add i32 %4, %2
  %6 = add i32 %5, %e
  %7 = add i32 %6, %f
  %8 = add i32 %7, %h
  ret i32 %8
}

define i32 @caller_many_scalars() nounwind {
; RV32I-FPELIM-LABEL: caller_many_scalars:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -16
; RV32I-FPELIM-NEXT:    sw ra, 12(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 8
; RV32I-FPELIM-NEXT:    sw a0, 4(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 1
; RV32I-FPELIM-NEXT:    addi a1, zero, 2
; RV32I-FPELIM-NEXT:    addi a2, zero, 3
; RV32I-FPELIM-NEXT:    addi a3, zero, 4
; RV32I-FPELIM-NEXT:    addi a5, zero, 5
; RV32I-FPELIM-NEXT:    addi a6, zero, 6
; RV32I-FPELIM-NEXT:    addi a7, zero, 7
; RV32I-FPELIM-NEXT:    sw zero, 0(sp)
; RV32I-FPELIM-NEXT:    mv a4, zero
; RV32I-FPELIM-NEXT:    call callee_many_scalars
; RV32I-FPELIM-NEXT:    lw ra, 12(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 16
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_many_scalars:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    addi a0, zero, 8
; RV32I-WITHFP-NEXT:    sw a0, 4(sp)
; RV32I-WITHFP-NEXT:    addi a0, zero, 1
; RV32I-WITHFP-NEXT:    addi a1, zero, 2
; RV32I-WITHFP-NEXT:    addi a2, zero, 3
; RV32I-WITHFP-NEXT:    addi a3, zero, 4
; RV32I-WITHFP-NEXT:    addi a5, zero, 5
; RV32I-WITHFP-NEXT:    addi a6, zero, 6
; RV32I-WITHFP-NEXT:    addi a7, zero, 7
; RV32I-WITHFP-NEXT:    sw zero, 0(sp)
; RV32I-WITHFP-NEXT:    mv a4, zero
; RV32I-WITHFP-NEXT:    call callee_many_scalars
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %1 = call i32 @callee_many_scalars(i8 1, i16 2, i32 3, i64 4, i32 5, i32 6, i64 7, i32 8)
  ret i32 %1
}


; Check that i128 and fp128 are passed indirectly

define i32 @callee_large_scalars(i128 %a, fp128 %b) nounwind {
; RV32I-FPELIM-LABEL: callee_large_scalars:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    lw a6, 0(a1)
; RV32I-FPELIM-NEXT:    lw a7, 0(a0)
; RV32I-FPELIM-NEXT:    lw a4, 4(a1)
; RV32I-FPELIM-NEXT:    lw a5, 12(a1)
; RV32I-FPELIM-NEXT:    lw a2, 12(a0)
; RV32I-FPELIM-NEXT:    lw a3, 4(a0)
; RV32I-FPELIM-NEXT:    lw a1, 8(a1)
; RV32I-FPELIM-NEXT:    lw a0, 8(a0)
; RV32I-FPELIM-NEXT:    xor a2, a2, a5
; RV32I-FPELIM-NEXT:    xor a3, a3, a4
; RV32I-FPELIM-NEXT:    or a2, a3, a2
; RV32I-FPELIM-NEXT:    xor a0, a0, a1
; RV32I-FPELIM-NEXT:    xor a1, a7, a6
; RV32I-FPELIM-NEXT:    or a0, a1, a0
; RV32I-FPELIM-NEXT:    or a0, a0, a2
; RV32I-FPELIM-NEXT:    seqz a0, a0
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_large_scalars:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    lw a6, 0(a1)
; RV32I-WITHFP-NEXT:    lw a7, 0(a0)
; RV32I-WITHFP-NEXT:    lw a4, 4(a1)
; RV32I-WITHFP-NEXT:    lw a5, 12(a1)
; RV32I-WITHFP-NEXT:    lw a2, 12(a0)
; RV32I-WITHFP-NEXT:    lw a3, 4(a0)
; RV32I-WITHFP-NEXT:    lw a1, 8(a1)
; RV32I-WITHFP-NEXT:    lw a0, 8(a0)
; RV32I-WITHFP-NEXT:    xor a2, a2, a5
; RV32I-WITHFP-NEXT:    xor a3, a3, a4
; RV32I-WITHFP-NEXT:    or a2, a3, a2
; RV32I-WITHFP-NEXT:    xor a0, a0, a1
; RV32I-WITHFP-NEXT:    xor a1, a7, a6
; RV32I-WITHFP-NEXT:    or a0, a1, a0
; RV32I-WITHFP-NEXT:    or a0, a0, a2
; RV32I-WITHFP-NEXT:    seqz a0, a0
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %b_bitcast = bitcast fp128 %b to i128
  %1 = icmp eq i128 %a, %b_bitcast
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @caller_large_scalars() nounwind {
; RV32I-FPELIM-LABEL: caller_large_scalars:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -48
; RV32I-FPELIM-NEXT:    sw ra, 44(sp)
; RV32I-FPELIM-NEXT:    lui a0, 524272
; RV32I-FPELIM-NEXT:    sw a0, 12(sp)
; RV32I-FPELIM-NEXT:    sw zero, 8(sp)
; RV32I-FPELIM-NEXT:    sw zero, 4(sp)
; RV32I-FPELIM-NEXT:    sw zero, 0(sp)
; RV32I-FPELIM-NEXT:    sw zero, 36(sp)
; RV32I-FPELIM-NEXT:    sw zero, 32(sp)
; RV32I-FPELIM-NEXT:    sw zero, 28(sp)
; RV32I-FPELIM-NEXT:    addi a2, zero, 1
; RV32I-FPELIM-NEXT:    addi a0, sp, 24
; RV32I-FPELIM-NEXT:    mv a1, sp
; RV32I-FPELIM-NEXT:    sw a2, 24(sp)
; RV32I-FPELIM-NEXT:    call callee_large_scalars
; RV32I-FPELIM-NEXT:    lw ra, 44(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 48
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_large_scalars:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -48
; RV32I-WITHFP-NEXT:    sw ra, 44(sp)
; RV32I-WITHFP-NEXT:    sw s0, 40(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 48
; RV32I-WITHFP-NEXT:    lui a0, 524272
; RV32I-WITHFP-NEXT:    sw a0, -36(s0)
; RV32I-WITHFP-NEXT:    sw zero, -40(s0)
; RV32I-WITHFP-NEXT:    sw zero, -44(s0)
; RV32I-WITHFP-NEXT:    sw zero, -48(s0)
; RV32I-WITHFP-NEXT:    sw zero, -12(s0)
; RV32I-WITHFP-NEXT:    sw zero, -16(s0)
; RV32I-WITHFP-NEXT:    sw zero, -20(s0)
; RV32I-WITHFP-NEXT:    addi a2, zero, 1
; RV32I-WITHFP-NEXT:    addi a0, s0, -24
; RV32I-WITHFP-NEXT:    addi a1, s0, -48
; RV32I-WITHFP-NEXT:    sw a2, -24(s0)
; RV32I-WITHFP-NEXT:    call callee_large_scalars
; RV32I-WITHFP-NEXT:    lw s0, 40(sp)
; RV32I-WITHFP-NEXT:    lw ra, 44(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 48
; RV32I-WITHFP-NEXT:    ret
  %1 = call i32 @callee_large_scalars(i128 1, fp128 0xL00000000000000007FFF000000000000)
  ret i32 %1
}

; Check that arguments larger than 2*xlen are handled correctly when their
; address is passed on the stack rather than in memory

; Must keep define on a single line due to an update_llc_test_checks.py limitation
define i32 @callee_large_scalars_exhausted_regs(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e, i32 %f, i32 %g, i128 %h, i32 %i, fp128 %j) nounwind {
; RV32I-FPELIM-LABEL: callee_large_scalars_exhausted_regs:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    lw a0, 4(sp)
; RV32I-FPELIM-NEXT:    lw a6, 0(a0)
; RV32I-FPELIM-NEXT:    lw t0, 0(a7)
; RV32I-FPELIM-NEXT:    lw a3, 4(a0)
; RV32I-FPELIM-NEXT:    lw a4, 12(a0)
; RV32I-FPELIM-NEXT:    lw a5, 12(a7)
; RV32I-FPELIM-NEXT:    lw a1, 4(a7)
; RV32I-FPELIM-NEXT:    lw a0, 8(a0)
; RV32I-FPELIM-NEXT:    lw a2, 8(a7)
; RV32I-FPELIM-NEXT:    xor a4, a5, a4
; RV32I-FPELIM-NEXT:    xor a1, a1, a3
; RV32I-FPELIM-NEXT:    or a1, a1, a4
; RV32I-FPELIM-NEXT:    xor a0, a2, a0
; RV32I-FPELIM-NEXT:    xor a2, t0, a6
; RV32I-FPELIM-NEXT:    or a0, a2, a0
; RV32I-FPELIM-NEXT:    or a0, a0, a1
; RV32I-FPELIM-NEXT:    seqz a0, a0
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_large_scalars_exhausted_regs:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    lw a0, 4(s0)
; RV32I-WITHFP-NEXT:    lw a6, 0(a0)
; RV32I-WITHFP-NEXT:    lw t0, 0(a7)
; RV32I-WITHFP-NEXT:    lw a3, 4(a0)
; RV32I-WITHFP-NEXT:    lw a4, 12(a0)
; RV32I-WITHFP-NEXT:    lw a5, 12(a7)
; RV32I-WITHFP-NEXT:    lw a1, 4(a7)
; RV32I-WITHFP-NEXT:    lw a0, 8(a0)
; RV32I-WITHFP-NEXT:    lw a2, 8(a7)
; RV32I-WITHFP-NEXT:    xor a4, a5, a4
; RV32I-WITHFP-NEXT:    xor a1, a1, a3
; RV32I-WITHFP-NEXT:    or a1, a1, a4
; RV32I-WITHFP-NEXT:    xor a0, a2, a0
; RV32I-WITHFP-NEXT:    xor a2, t0, a6
; RV32I-WITHFP-NEXT:    or a0, a2, a0
; RV32I-WITHFP-NEXT:    or a0, a0, a1
; RV32I-WITHFP-NEXT:    seqz a0, a0
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %j_bitcast = bitcast fp128 %j to i128
  %1 = icmp eq i128 %h, %j_bitcast
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @caller_large_scalars_exhausted_regs() nounwind {
; RV32I-FPELIM-LABEL: caller_large_scalars_exhausted_regs:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -64
; RV32I-FPELIM-NEXT:    sw ra, 60(sp)
; RV32I-FPELIM-NEXT:    addi a0, sp, 16
; RV32I-FPELIM-NEXT:    sw a0, 4(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 9
; RV32I-FPELIM-NEXT:    sw a0, 0(sp)
; RV32I-FPELIM-NEXT:    lui a0, 524272
; RV32I-FPELIM-NEXT:    sw a0, 28(sp)
; RV32I-FPELIM-NEXT:    sw zero, 24(sp)
; RV32I-FPELIM-NEXT:    sw zero, 20(sp)
; RV32I-FPELIM-NEXT:    sw zero, 16(sp)
; RV32I-FPELIM-NEXT:    sw zero, 52(sp)
; RV32I-FPELIM-NEXT:    sw zero, 48(sp)
; RV32I-FPELIM-NEXT:    sw zero, 44(sp)
; RV32I-FPELIM-NEXT:    addi t0, zero, 8
; RV32I-FPELIM-NEXT:    addi a0, zero, 1
; RV32I-FPELIM-NEXT:    addi a1, zero, 2
; RV32I-FPELIM-NEXT:    addi a2, zero, 3
; RV32I-FPELIM-NEXT:    addi a3, zero, 4
; RV32I-FPELIM-NEXT:    addi a4, zero, 5
; RV32I-FPELIM-NEXT:    addi a5, zero, 6
; RV32I-FPELIM-NEXT:    addi a6, zero, 7
; RV32I-FPELIM-NEXT:    addi a7, sp, 40
; RV32I-FPELIM-NEXT:    sw t0, 40(sp)
; RV32I-FPELIM-NEXT:    call callee_large_scalars_exhausted_regs
; RV32I-FPELIM-NEXT:    lw ra, 60(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 64
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_large_scalars_exhausted_regs:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -64
; RV32I-WITHFP-NEXT:    sw ra, 60(sp)
; RV32I-WITHFP-NEXT:    sw s0, 56(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 64
; RV32I-WITHFP-NEXT:    addi a0, s0, -48
; RV32I-WITHFP-NEXT:    sw a0, 4(sp)
; RV32I-WITHFP-NEXT:    addi a0, zero, 9
; RV32I-WITHFP-NEXT:    sw a0, 0(sp)
; RV32I-WITHFP-NEXT:    lui a0, 524272
; RV32I-WITHFP-NEXT:    sw a0, -36(s0)
; RV32I-WITHFP-NEXT:    sw zero, -40(s0)
; RV32I-WITHFP-NEXT:    sw zero, -44(s0)
; RV32I-WITHFP-NEXT:    sw zero, -48(s0)
; RV32I-WITHFP-NEXT:    sw zero, -12(s0)
; RV32I-WITHFP-NEXT:    sw zero, -16(s0)
; RV32I-WITHFP-NEXT:    sw zero, -20(s0)
; RV32I-WITHFP-NEXT:    addi t0, zero, 8
; RV32I-WITHFP-NEXT:    addi a0, zero, 1
; RV32I-WITHFP-NEXT:    addi a1, zero, 2
; RV32I-WITHFP-NEXT:    addi a2, zero, 3
; RV32I-WITHFP-NEXT:    addi a3, zero, 4
; RV32I-WITHFP-NEXT:    addi a4, zero, 5
; RV32I-WITHFP-NEXT:    addi a5, zero, 6
; RV32I-WITHFP-NEXT:    addi a6, zero, 7
; RV32I-WITHFP-NEXT:    addi a7, s0, -24
; RV32I-WITHFP-NEXT:    sw t0, -24(s0)
; RV32I-WITHFP-NEXT:    call callee_large_scalars_exhausted_regs
; RV32I-WITHFP-NEXT:    lw s0, 56(sp)
; RV32I-WITHFP-NEXT:    lw ra, 60(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 64
; RV32I-WITHFP-NEXT:    ret
  %1 = call i32 @callee_large_scalars_exhausted_regs(
      i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i128 8, i32 9,
      fp128 0xL00000000000000007FFF000000000000)
  ret i32 %1
}

; Ensure that libcalls generated in the middle-end obey the calling convention

define i32 @caller_mixed_scalar_libcalls(i64 %a) nounwind {
; RV32I-FPELIM-LABEL: caller_mixed_scalar_libcalls:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -32
; RV32I-FPELIM-NEXT:    sw ra, 28(sp)
; RV32I-FPELIM-NEXT:    mv a2, a1
; RV32I-FPELIM-NEXT:    mv a1, a0
; RV32I-FPELIM-NEXT:    addi a0, sp, 8
; RV32I-FPELIM-NEXT:    call __floatditf
; RV32I-FPELIM-NEXT:    lw a0, 8(sp)
; RV32I-FPELIM-NEXT:    lw ra, 28(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 32
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_mixed_scalar_libcalls:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -32
; RV32I-WITHFP-NEXT:    sw ra, 28(sp)
; RV32I-WITHFP-NEXT:    sw s0, 24(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 32
; RV32I-WITHFP-NEXT:    mv a2, a1
; RV32I-WITHFP-NEXT:    mv a1, a0
; RV32I-WITHFP-NEXT:    addi a0, s0, -24
; RV32I-WITHFP-NEXT:    call __floatditf
; RV32I-WITHFP-NEXT:    lw a0, -24(s0)
; RV32I-WITHFP-NEXT:    lw s0, 24(sp)
; RV32I-WITHFP-NEXT:    lw ra, 28(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 32
; RV32I-WITHFP-NEXT:    ret
  %1 = sitofp i64 %a to fp128
  %2 = bitcast fp128 %1 to i128
  %3 = trunc i128 %2 to i32
  ret i32 %3
}

; Check passing of coerced integer arrays

%struct.small = type { i32, i32* }

define i32 @callee_small_coerced_struct([2 x i32] %a.coerce) nounwind {
; RV32I-FPELIM-LABEL: callee_small_coerced_struct:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    xor a0, a0, a1
; RV32I-FPELIM-NEXT:    seqz a0, a0
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_small_coerced_struct:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    xor a0, a0, a1
; RV32I-WITHFP-NEXT:    seqz a0, a0
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %1 = extractvalue [2 x i32] %a.coerce, 0
  %2 = extractvalue [2 x i32] %a.coerce, 1
  %3 = icmp eq i32 %1, %2
  %4 = zext i1 %3 to i32
  ret i32 %4
}

define i32 @caller_small_coerced_struct() nounwind {
; RV32I-FPELIM-LABEL: caller_small_coerced_struct:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -16
; RV32I-FPELIM-NEXT:    sw ra, 12(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 1
; RV32I-FPELIM-NEXT:    addi a1, zero, 2
; RV32I-FPELIM-NEXT:    call callee_small_coerced_struct
; RV32I-FPELIM-NEXT:    lw ra, 12(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 16
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_small_coerced_struct:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    addi a0, zero, 1
; RV32I-WITHFP-NEXT:    addi a1, zero, 2
; RV32I-WITHFP-NEXT:    call callee_small_coerced_struct
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %1 = call i32 @callee_small_coerced_struct([2 x i32] [i32 1, i32 2])
  ret i32 %1
}

; Check large struct arguments, which are passed byval

%struct.large = type { i32, i32, i32, i32 }

define i32 @callee_large_struct(%struct.large* byval(%struct.large) align 4 %a) nounwind {
; RV32I-FPELIM-LABEL: callee_large_struct:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    lw a1, 0(a0)
; RV32I-FPELIM-NEXT:    lw a0, 12(a0)
; RV32I-FPELIM-NEXT:    add a0, a1, a0
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_large_struct:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    lw a1, 0(a0)
; RV32I-WITHFP-NEXT:    lw a0, 12(a0)
; RV32I-WITHFP-NEXT:    add a0, a1, a0
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %1 = getelementptr inbounds %struct.large, %struct.large* %a, i32 0, i32 0
  %2 = getelementptr inbounds %struct.large, %struct.large* %a, i32 0, i32 3
  %3 = load i32, i32* %1
  %4 = load i32, i32* %2
  %5 = add i32 %3, %4
  ret i32 %5
}

define i32 @caller_large_struct() nounwind {
; RV32I-FPELIM-LABEL: caller_large_struct:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -48
; RV32I-FPELIM-NEXT:    sw ra, 44(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 1
; RV32I-FPELIM-NEXT:    sw a0, 24(sp)
; RV32I-FPELIM-NEXT:    addi a1, zero, 2
; RV32I-FPELIM-NEXT:    sw a1, 28(sp)
; RV32I-FPELIM-NEXT:    addi a2, zero, 3
; RV32I-FPELIM-NEXT:    sw a2, 32(sp)
; RV32I-FPELIM-NEXT:    addi a3, zero, 4
; RV32I-FPELIM-NEXT:    sw a3, 36(sp)
; RV32I-FPELIM-NEXT:    sw a0, 8(sp)
; RV32I-FPELIM-NEXT:    sw a1, 12(sp)
; RV32I-FPELIM-NEXT:    sw a2, 16(sp)
; RV32I-FPELIM-NEXT:    sw a3, 20(sp)
; RV32I-FPELIM-NEXT:    addi a0, sp, 8
; RV32I-FPELIM-NEXT:    call callee_large_struct
; RV32I-FPELIM-NEXT:    lw ra, 44(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 48
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_large_struct:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -48
; RV32I-WITHFP-NEXT:    sw ra, 44(sp)
; RV32I-WITHFP-NEXT:    sw s0, 40(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 48
; RV32I-WITHFP-NEXT:    addi a0, zero, 1
; RV32I-WITHFP-NEXT:    sw a0, -24(s0)
; RV32I-WITHFP-NEXT:    addi a1, zero, 2
; RV32I-WITHFP-NEXT:    sw a1, -20(s0)
; RV32I-WITHFP-NEXT:    addi a2, zero, 3
; RV32I-WITHFP-NEXT:    sw a2, -16(s0)
; RV32I-WITHFP-NEXT:    addi a3, zero, 4
; RV32I-WITHFP-NEXT:    sw a3, -12(s0)
; RV32I-WITHFP-NEXT:    sw a0, -40(s0)
; RV32I-WITHFP-NEXT:    sw a1, -36(s0)
; RV32I-WITHFP-NEXT:    sw a2, -32(s0)
; RV32I-WITHFP-NEXT:    sw a3, -28(s0)
; RV32I-WITHFP-NEXT:    addi a0, s0, -40
; RV32I-WITHFP-NEXT:    call callee_large_struct
; RV32I-WITHFP-NEXT:    lw s0, 40(sp)
; RV32I-WITHFP-NEXT:    lw ra, 44(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 48
; RV32I-WITHFP-NEXT:    ret
  %ls = alloca %struct.large, align 4
  %1 = bitcast %struct.large* %ls to i8*
  %a = getelementptr inbounds %struct.large, %struct.large* %ls, i32 0, i32 0
  store i32 1, i32* %a
  %b = getelementptr inbounds %struct.large, %struct.large* %ls, i32 0, i32 1
  store i32 2, i32* %b
  %c = getelementptr inbounds %struct.large, %struct.large* %ls, i32 0, i32 2
  store i32 3, i32* %c
  %d = getelementptr inbounds %struct.large, %struct.large* %ls, i32 0, i32 3
  store i32 4, i32* %d
  %2 = call i32 @callee_large_struct(%struct.large* byval(%struct.large) align 4 %ls)
  ret i32 %2
}

; Check 2x*xlen values are aligned appropriately when passed on the stack
; Must keep define on a single line due to an update_llc_test_checks.py limitation
define i32 @callee_aligned_stack(i32 %a, i32 %b, fp128 %c, i32 %d, i32 %e, i64 %f, i32 %g, i32 %h, i64 %i, i32 %j, [2 x i32] %k) nounwind {
; The i64 should be 8-byte aligned on the stack, but the two-element array
; should only be 4-byte aligned
; RV32I-FPELIM-LABEL: callee_aligned_stack:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    lw a0, 0(a2)
; RV32I-FPELIM-NEXT:    lw a1, 20(sp)
; RV32I-FPELIM-NEXT:    lw a2, 0(sp)
; RV32I-FPELIM-NEXT:    lw a3, 8(sp)
; RV32I-FPELIM-NEXT:    lw a4, 16(sp)
; RV32I-FPELIM-NEXT:    add a0, a0, a7
; RV32I-FPELIM-NEXT:    add a0, a0, a2
; RV32I-FPELIM-NEXT:    add a0, a0, a3
; RV32I-FPELIM-NEXT:    add a0, a0, a4
; RV32I-FPELIM-NEXT:    add a0, a0, a1
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_aligned_stack:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    lw a0, 0(a2)
; RV32I-WITHFP-NEXT:    lw a1, 20(s0)
; RV32I-WITHFP-NEXT:    lw a2, 0(s0)
; RV32I-WITHFP-NEXT:    lw a3, 8(s0)
; RV32I-WITHFP-NEXT:    lw a4, 16(s0)
; RV32I-WITHFP-NEXT:    add a0, a0, a7
; RV32I-WITHFP-NEXT:    add a0, a0, a2
; RV32I-WITHFP-NEXT:    add a0, a0, a3
; RV32I-WITHFP-NEXT:    add a0, a0, a4
; RV32I-WITHFP-NEXT:    add a0, a0, a1
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %1 = bitcast fp128 %c to i128
  %2 = trunc i128 %1 to i32
  %3 = add i32 %2, %g
  %4 = add i32 %3, %h
  %5 = trunc i64 %i to i32
  %6 = add i32 %4, %5
  %7 = add i32 %6, %j
  %8 = extractvalue [2 x i32] %k, 0
  %9 = add i32 %7, %8
  ret i32 %9
}

define void @caller_aligned_stack() nounwind {
; The i64 should be 8-byte aligned on the stack, but the two-element array
; should only be 4-byte aligned
; RV32I-FPELIM-LABEL: caller_aligned_stack:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -64
; RV32I-FPELIM-NEXT:    sw ra, 60(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 19
; RV32I-FPELIM-NEXT:    sw a0, 24(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 18
; RV32I-FPELIM-NEXT:    sw a0, 20(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 17
; RV32I-FPELIM-NEXT:    sw a0, 16(sp)
; RV32I-FPELIM-NEXT:    sw zero, 12(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 16
; RV32I-FPELIM-NEXT:    sw a0, 8(sp)
; RV32I-FPELIM-NEXT:    addi a0, zero, 15
; RV32I-FPELIM-NEXT:    sw a0, 0(sp)
; RV32I-FPELIM-NEXT:    lui a0, 262153
; RV32I-FPELIM-NEXT:    addi a0, a0, 491
; RV32I-FPELIM-NEXT:    sw a0, 44(sp)
; RV32I-FPELIM-NEXT:    lui a0, 545260
; RV32I-FPELIM-NEXT:    addi a0, a0, -1967
; RV32I-FPELIM-NEXT:    sw a0, 40(sp)
; RV32I-FPELIM-NEXT:    lui a0, 964690
; RV32I-FPELIM-NEXT:    addi a0, a0, -328
; RV32I-FPELIM-NEXT:    sw a0, 36(sp)
; RV32I-FPELIM-NEXT:    lui a0, 335544
; RV32I-FPELIM-NEXT:    addi t0, a0, 1311
; RV32I-FPELIM-NEXT:    lui a0, 688509
; RV32I-FPELIM-NEXT:    addi a5, a0, -2048
; RV32I-FPELIM-NEXT:    addi a0, zero, 1
; RV32I-FPELIM-NEXT:    addi a1, zero, 11
; RV32I-FPELIM-NEXT:    addi a2, sp, 32
; RV32I-FPELIM-NEXT:    addi a3, zero, 12
; RV32I-FPELIM-NEXT:    addi a4, zero, 13
; RV32I-FPELIM-NEXT:    addi a6, zero, 4
; RV32I-FPELIM-NEXT:    addi a7, zero, 14
; RV32I-FPELIM-NEXT:    sw t0, 32(sp)
; RV32I-FPELIM-NEXT:    call callee_aligned_stack
; RV32I-FPELIM-NEXT:    lw ra, 60(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 64
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_aligned_stack:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -64
; RV32I-WITHFP-NEXT:    sw ra, 60(sp)
; RV32I-WITHFP-NEXT:    sw s0, 56(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 64
; RV32I-WITHFP-NEXT:    addi a0, zero, 19
; RV32I-WITHFP-NEXT:    sw a0, 24(sp)
; RV32I-WITHFP-NEXT:    addi a0, zero, 18
; RV32I-WITHFP-NEXT:    sw a0, 20(sp)
; RV32I-WITHFP-NEXT:    addi a0, zero, 17
; RV32I-WITHFP-NEXT:    sw a0, 16(sp)
; RV32I-WITHFP-NEXT:    sw zero, 12(sp)
; RV32I-WITHFP-NEXT:    addi a0, zero, 16
; RV32I-WITHFP-NEXT:    sw a0, 8(sp)
; RV32I-WITHFP-NEXT:    addi a0, zero, 15
; RV32I-WITHFP-NEXT:    sw a0, 0(sp)
; RV32I-WITHFP-NEXT:    lui a0, 262153
; RV32I-WITHFP-NEXT:    addi a0, a0, 491
; RV32I-WITHFP-NEXT:    sw a0, -20(s0)
; RV32I-WITHFP-NEXT:    lui a0, 545260
; RV32I-WITHFP-NEXT:    addi a0, a0, -1967
; RV32I-WITHFP-NEXT:    sw a0, -24(s0)
; RV32I-WITHFP-NEXT:    lui a0, 964690
; RV32I-WITHFP-NEXT:    addi a0, a0, -328
; RV32I-WITHFP-NEXT:    sw a0, -28(s0)
; RV32I-WITHFP-NEXT:    lui a0, 335544
; RV32I-WITHFP-NEXT:    addi t0, a0, 1311
; RV32I-WITHFP-NEXT:    lui a0, 688509
; RV32I-WITHFP-NEXT:    addi a5, a0, -2048
; RV32I-WITHFP-NEXT:    addi a0, zero, 1
; RV32I-WITHFP-NEXT:    addi a1, zero, 11
; RV32I-WITHFP-NEXT:    addi a2, s0, -32
; RV32I-WITHFP-NEXT:    addi a3, zero, 12
; RV32I-WITHFP-NEXT:    addi a4, zero, 13
; RV32I-WITHFP-NEXT:    addi a6, zero, 4
; RV32I-WITHFP-NEXT:    addi a7, zero, 14
; RV32I-WITHFP-NEXT:    sw t0, -32(s0)
; RV32I-WITHFP-NEXT:    call callee_aligned_stack
; RV32I-WITHFP-NEXT:    lw s0, 56(sp)
; RV32I-WITHFP-NEXT:    lw ra, 60(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 64
; RV32I-WITHFP-NEXT:    ret
  %1 = call i32 @callee_aligned_stack(i32 1, i32 11,
    fp128 0xLEB851EB851EB851F400091EB851EB851, i32 12, i32 13,
    i64 20000000000, i32 14, i32 15, i64 16, i32 17,
    [2 x i32] [i32 18, i32 19])
  ret void
}

; Check return of 2x xlen scalars

define i64 @callee_small_scalar_ret() nounwind {
; RV32I-FPELIM-LABEL: callee_small_scalar_ret:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    lui a0, 466866
; RV32I-FPELIM-NEXT:    addi a0, a0, 1677
; RV32I-FPELIM-NEXT:    addi a1, zero, 287
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_small_scalar_ret:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    lui a0, 466866
; RV32I-WITHFP-NEXT:    addi a0, a0, 1677
; RV32I-WITHFP-NEXT:    addi a1, zero, 287
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  ret i64 1234567898765
}

define i32 @caller_small_scalar_ret() nounwind {
; RV32I-FPELIM-LABEL: caller_small_scalar_ret:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -16
; RV32I-FPELIM-NEXT:    sw ra, 12(sp)
; RV32I-FPELIM-NEXT:    call callee_small_scalar_ret
; RV32I-FPELIM-NEXT:    lui a2, 56
; RV32I-FPELIM-NEXT:    addi a2, a2, 580
; RV32I-FPELIM-NEXT:    xor a1, a1, a2
; RV32I-FPELIM-NEXT:    lui a2, 200614
; RV32I-FPELIM-NEXT:    addi a2, a2, 647
; RV32I-FPELIM-NEXT:    xor a0, a0, a2
; RV32I-FPELIM-NEXT:    or a0, a0, a1
; RV32I-FPELIM-NEXT:    seqz a0, a0
; RV32I-FPELIM-NEXT:    lw ra, 12(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 16
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_small_scalar_ret:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    call callee_small_scalar_ret
; RV32I-WITHFP-NEXT:    lui a2, 56
; RV32I-WITHFP-NEXT:    addi a2, a2, 580
; RV32I-WITHFP-NEXT:    xor a1, a1, a2
; RV32I-WITHFP-NEXT:    lui a2, 200614
; RV32I-WITHFP-NEXT:    addi a2, a2, 647
; RV32I-WITHFP-NEXT:    xor a0, a0, a2
; RV32I-WITHFP-NEXT:    or a0, a0, a1
; RV32I-WITHFP-NEXT:    seqz a0, a0
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %1 = call i64 @callee_small_scalar_ret()
  %2 = icmp eq i64 987654321234567, %1
  %3 = zext i1 %2 to i32
  ret i32 %3
}

; Check return of 2x xlen structs

define %struct.small @callee_small_struct_ret() nounwind {
; RV32I-FPELIM-LABEL: callee_small_struct_ret:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi a0, zero, 1
; RV32I-FPELIM-NEXT:    mv a1, zero
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_small_struct_ret:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    addi a0, zero, 1
; RV32I-WITHFP-NEXT:    mv a1, zero
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  ret %struct.small { i32 1, i32* null }
}

define i32 @caller_small_struct_ret() nounwind {
; RV32I-FPELIM-LABEL: caller_small_struct_ret:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -16
; RV32I-FPELIM-NEXT:    sw ra, 12(sp)
; RV32I-FPELIM-NEXT:    call callee_small_struct_ret
; RV32I-FPELIM-NEXT:    add a0, a0, a1
; RV32I-FPELIM-NEXT:    lw ra, 12(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 16
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_small_struct_ret:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    call callee_small_struct_ret
; RV32I-WITHFP-NEXT:    add a0, a0, a1
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %1 = call %struct.small @callee_small_struct_ret()
  %2 = extractvalue %struct.small %1, 0
  %3 = extractvalue %struct.small %1, 1
  %4 = ptrtoint i32* %3 to i32
  %5 = add i32 %2, %4
  ret i32 %5
}

; Check return of >2x xlen scalars

define fp128 @callee_large_scalar_ret() nounwind {
; RV32I-FPELIM-LABEL: callee_large_scalar_ret:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    lui a1, 524272
; RV32I-FPELIM-NEXT:    sw a1, 12(a0)
; RV32I-FPELIM-NEXT:    sw zero, 8(a0)
; RV32I-FPELIM-NEXT:    sw zero, 4(a0)
; RV32I-FPELIM-NEXT:    sw zero, 0(a0)
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_large_scalar_ret:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    lui a1, 524272
; RV32I-WITHFP-NEXT:    sw a1, 12(a0)
; RV32I-WITHFP-NEXT:    sw zero, 8(a0)
; RV32I-WITHFP-NEXT:    sw zero, 4(a0)
; RV32I-WITHFP-NEXT:    sw zero, 0(a0)
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  ret fp128 0xL00000000000000007FFF000000000000
}

define void @caller_large_scalar_ret() nounwind {
; RV32I-FPELIM-LABEL: caller_large_scalar_ret:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -32
; RV32I-FPELIM-NEXT:    sw ra, 28(sp)
; RV32I-FPELIM-NEXT:    mv a0, sp
; RV32I-FPELIM-NEXT:    call callee_large_scalar_ret
; RV32I-FPELIM-NEXT:    lw ra, 28(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 32
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_large_scalar_ret:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -32
; RV32I-WITHFP-NEXT:    sw ra, 28(sp)
; RV32I-WITHFP-NEXT:    sw s0, 24(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 32
; RV32I-WITHFP-NEXT:    addi a0, s0, -32
; RV32I-WITHFP-NEXT:    call callee_large_scalar_ret
; RV32I-WITHFP-NEXT:    lw s0, 24(sp)
; RV32I-WITHFP-NEXT:    lw ra, 28(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 32
; RV32I-WITHFP-NEXT:    ret
  %1 = call fp128 @callee_large_scalar_ret()
  ret void
}

; Check return of >2x xlen structs

define void @callee_large_struct_ret(%struct.large* noalias sret %agg.result) nounwind {
; RV32I-FPELIM-LABEL: callee_large_struct_ret:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi a1, zero, 1
; RV32I-FPELIM-NEXT:    sw a1, 0(a0)
; RV32I-FPELIM-NEXT:    addi a1, zero, 2
; RV32I-FPELIM-NEXT:    sw a1, 4(a0)
; RV32I-FPELIM-NEXT:    addi a1, zero, 3
; RV32I-FPELIM-NEXT:    sw a1, 8(a0)
; RV32I-FPELIM-NEXT:    addi a1, zero, 4
; RV32I-FPELIM-NEXT:    sw a1, 12(a0)
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: callee_large_struct_ret:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -16
; RV32I-WITHFP-NEXT:    sw ra, 12(sp)
; RV32I-WITHFP-NEXT:    sw s0, 8(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 16
; RV32I-WITHFP-NEXT:    addi a1, zero, 1
; RV32I-WITHFP-NEXT:    sw a1, 0(a0)
; RV32I-WITHFP-NEXT:    addi a1, zero, 2
; RV32I-WITHFP-NEXT:    sw a1, 4(a0)
; RV32I-WITHFP-NEXT:    addi a1, zero, 3
; RV32I-WITHFP-NEXT:    sw a1, 8(a0)
; RV32I-WITHFP-NEXT:    addi a1, zero, 4
; RV32I-WITHFP-NEXT:    sw a1, 12(a0)
; RV32I-WITHFP-NEXT:    lw s0, 8(sp)
; RV32I-WITHFP-NEXT:    lw ra, 12(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 16
; RV32I-WITHFP-NEXT:    ret
  %a = getelementptr inbounds %struct.large, %struct.large* %agg.result, i32 0, i32 0
  store i32 1, i32* %a, align 4
  %b = getelementptr inbounds %struct.large, %struct.large* %agg.result, i32 0, i32 1
  store i32 2, i32* %b, align 4
  %c = getelementptr inbounds %struct.large, %struct.large* %agg.result, i32 0, i32 2
  store i32 3, i32* %c, align 4
  %d = getelementptr inbounds %struct.large, %struct.large* %agg.result, i32 0, i32 3
  store i32 4, i32* %d, align 4
  ret void
}

define i32 @caller_large_struct_ret() nounwind {
; RV32I-FPELIM-LABEL: caller_large_struct_ret:
; RV32I-FPELIM:       # %bb.0:
; RV32I-FPELIM-NEXT:    addi sp, sp, -32
; RV32I-FPELIM-NEXT:    sw ra, 28(sp)
; RV32I-FPELIM-NEXT:    addi a0, sp, 8
; RV32I-FPELIM-NEXT:    call callee_large_struct_ret
; RV32I-FPELIM-NEXT:    lw a0, 8(sp)
; RV32I-FPELIM-NEXT:    lw a1, 20(sp)
; RV32I-FPELIM-NEXT:    add a0, a0, a1
; RV32I-FPELIM-NEXT:    lw ra, 28(sp)
; RV32I-FPELIM-NEXT:    addi sp, sp, 32
; RV32I-FPELIM-NEXT:    ret
;
; RV32I-WITHFP-LABEL: caller_large_struct_ret:
; RV32I-WITHFP:       # %bb.0:
; RV32I-WITHFP-NEXT:    addi sp, sp, -32
; RV32I-WITHFP-NEXT:    sw ra, 28(sp)
; RV32I-WITHFP-NEXT:    sw s0, 24(sp)
; RV32I-WITHFP-NEXT:    addi s0, sp, 32
; RV32I-WITHFP-NEXT:    addi a0, s0, -24
; RV32I-WITHFP-NEXT:    call callee_large_struct_ret
; RV32I-WITHFP-NEXT:    lw a0, -24(s0)
; RV32I-WITHFP-NEXT:    lw a1, -12(s0)
; RV32I-WITHFP-NEXT:    add a0, a0, a1
; RV32I-WITHFP-NEXT:    lw s0, 24(sp)
; RV32I-WITHFP-NEXT:    lw ra, 28(sp)
; RV32I-WITHFP-NEXT:    addi sp, sp, 32
; RV32I-WITHFP-NEXT:    ret
  %1 = alloca %struct.large
  call void @callee_large_struct_ret(%struct.large* sret %1)
  %2 = getelementptr inbounds %struct.large, %struct.large* %1, i32 0, i32 0
  %3 = load i32, i32* %2
  %4 = getelementptr inbounds %struct.large, %struct.large* %1, i32 0, i32 3
  %5 = load i32, i32* %4
  %6 = add i32 %3, %5
  ret i32 %6
}
