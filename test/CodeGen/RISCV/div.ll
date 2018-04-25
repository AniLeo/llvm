; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv32 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IM %s

define i32 @udiv(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: udiv:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    call __udivsi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: udiv:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    divu a0, a0, a1
; RV32IM-NEXT:    ret
  %1 = udiv i32 %a, %b
  ret i32 %1
}

define i32 @udiv_constant(i32 %a) nounwind {
; RV32I-LABEL: udiv_constant:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    addi a1, zero, 5
; RV32I-NEXT:    call __udivsi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: udiv_constant:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 838861
; RV32IM-NEXT:    addi a1, a1, -819
; RV32IM-NEXT:    mulhu a0, a0, a1
; RV32IM-NEXT:    srli a0, a0, 2
; RV32IM-NEXT:    ret
  %1 = udiv i32 %a, 5
  ret i32 %1
}

define i32 @udiv_pow2(i32 %a) nounwind {
; RV32I-LABEL: udiv_pow2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srli a0, a0, 3
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: udiv_pow2:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    srli a0, a0, 3
; RV32IM-NEXT:    ret
  %1 = udiv i32 %a, 8
  ret i32 %1
}

define i64 @udiv64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: udiv64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    call __udivdi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: udiv64:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -16
; RV32IM-NEXT:    sw ra, 12(sp)
; RV32IM-NEXT:    call __udivdi3
; RV32IM-NEXT:    lw ra, 12(sp)
; RV32IM-NEXT:    addi sp, sp, 16
; RV32IM-NEXT:    ret
  %1 = udiv i64 %a, %b
  ret i64 %1
}

define i64 @udiv64_constant(i64 %a) nounwind {
; RV32I-LABEL: udiv64_constant:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    addi a2, zero, 5
; RV32I-NEXT:    mv a3, zero
; RV32I-NEXT:    call __udivdi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: udiv64_constant:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -16
; RV32IM-NEXT:    sw ra, 12(sp)
; RV32IM-NEXT:    addi a2, zero, 5
; RV32IM-NEXT:    mv a3, zero
; RV32IM-NEXT:    call __udivdi3
; RV32IM-NEXT:    lw ra, 12(sp)
; RV32IM-NEXT:    addi sp, sp, 16
; RV32IM-NEXT:    ret
  %1 = udiv i64 %a, 5
  ret i64 %1
}

define i32 @sdiv(i32 %a, i32 %b) nounwind {
; RV32I-LABEL: sdiv:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    call __divsi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: sdiv:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    div a0, a0, a1
; RV32IM-NEXT:    ret
  %1 = sdiv i32 %a, %b
  ret i32 %1
}

define i32 @sdiv_constant(i32 %a) nounwind {
; RV32I-LABEL: sdiv_constant:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    addi a1, zero, 5
; RV32I-NEXT:    call __divsi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: sdiv_constant:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 419430
; RV32IM-NEXT:    addi a1, a1, 1639
; RV32IM-NEXT:    mulh a0, a0, a1
; RV32IM-NEXT:    srli a1, a0, 31
; RV32IM-NEXT:    srai a0, a0, 1
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
  %1 = sdiv i32 %a, 5
  ret i32 %1
}

define i32 @sdiv_pow2(i32 %a) nounwind {
; RV32I-LABEL: sdiv_pow2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    srli a1, a1, 29
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    srai a0, a0, 3
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: sdiv_pow2:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    srai a1, a0, 31
; RV32IM-NEXT:    srli a1, a1, 29
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    srai a0, a0, 3
; RV32IM-NEXT:    ret
  %1 = sdiv i32 %a, 8
  ret i32 %1
}

define i64 @sdiv64(i64 %a, i64 %b) nounwind {
; RV32I-LABEL: sdiv64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    call __divdi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: sdiv64:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -16
; RV32IM-NEXT:    sw ra, 12(sp)
; RV32IM-NEXT:    call __divdi3
; RV32IM-NEXT:    lw ra, 12(sp)
; RV32IM-NEXT:    addi sp, sp, 16
; RV32IM-NEXT:    ret
  %1 = sdiv i64 %a, %b
  ret i64 %1
}

define i64 @sdiv64_constant(i64 %a) nounwind {
; RV32I-LABEL: sdiv64_constant:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    addi a2, zero, 5
; RV32I-NEXT:    mv a3, zero
; RV32I-NEXT:    call __divdi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: sdiv64_constant:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -16
; RV32IM-NEXT:    sw ra, 12(sp)
; RV32IM-NEXT:    addi a2, zero, 5
; RV32IM-NEXT:    mv a3, zero
; RV32IM-NEXT:    call __divdi3
; RV32IM-NEXT:    lw ra, 12(sp)
; RV32IM-NEXT:    addi sp, sp, 16
; RV32IM-NEXT:    ret
  %1 = sdiv i64 %a, 5
  ret i64 %1
}
