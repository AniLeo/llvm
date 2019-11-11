; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV32I %s
; RUN: llc -mtriple=riscv32 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV32IM %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV64I %s
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV64IM %s

define i32 @fold_srem_positive_odd(i32 %x) nounwind {
; RV32I-LABEL: fold_srem_positive_odd:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    call __modsi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: fold_srem_positive_odd:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 706409
; RV32IM-NEXT:    addi a1, a1, 389
; RV32IM-NEXT:    mulh a1, a0, a1
; RV32IM-NEXT:    add a1, a1, a0
; RV32IM-NEXT:    srli a2, a1, 31
; RV32IM-NEXT:    srai a1, a1, 6
; RV32IM-NEXT:    add a1, a1, a2
; RV32IM-NEXT:    addi a2, zero, 95
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: fold_srem_positive_odd:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp)
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    call __moddi3
; RV64I-NEXT:    ld ra, 8(sp)
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: fold_srem_positive_odd:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    sext.w a0, a0
; RV64IM-NEXT:    lui a1, 1045903
; RV64IM-NEXT:    addiw a1, a1, -733
; RV64IM-NEXT:    slli a1, a1, 15
; RV64IM-NEXT:    addi a1, a1, 1035
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, -905
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, -1767
; RV64IM-NEXT:    mulh a1, a0, a1
; RV64IM-NEXT:    add a1, a1, a0
; RV64IM-NEXT:    srli a2, a1, 63
; RV64IM-NEXT:    srai a1, a1, 6
; RV64IM-NEXT:    add a1, a1, a2
; RV64IM-NEXT:    addi a2, zero, 95
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    sub a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %x, 95
  ret i32 %1
}


define i32 @fold_srem_positive_even(i32 %x) nounwind {
; RV32I-LABEL: fold_srem_positive_even:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    addi a1, zero, 1060
; RV32I-NEXT:    call __modsi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: fold_srem_positive_even:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 253241
; RV32IM-NEXT:    addi a1, a1, -15
; RV32IM-NEXT:    mulh a1, a0, a1
; RV32IM-NEXT:    srli a2, a1, 31
; RV32IM-NEXT:    srai a1, a1, 8
; RV32IM-NEXT:    add a1, a1, a2
; RV32IM-NEXT:    addi a2, zero, 1060
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: fold_srem_positive_even:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp)
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    addi a1, zero, 1060
; RV64I-NEXT:    call __moddi3
; RV64I-NEXT:    ld ra, 8(sp)
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: fold_srem_positive_even:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    sext.w a0, a0
; RV64IM-NEXT:    lui a1, 506482
; RV64IM-NEXT:    addiw a1, a1, -31
; RV64IM-NEXT:    slli a1, a1, 13
; RV64IM-NEXT:    addi a1, a1, 711
; RV64IM-NEXT:    slli a1, a1, 19
; RV64IM-NEXT:    addi a1, a1, 1979
; RV64IM-NEXT:    mulh a1, a0, a1
; RV64IM-NEXT:    srli a2, a1, 63
; RV64IM-NEXT:    srai a1, a1, 9
; RV64IM-NEXT:    add a1, a1, a2
; RV64IM-NEXT:    addi a2, zero, 1060
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    sub a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %x, 1060
  ret i32 %1
}


define i32 @fold_srem_negative_odd(i32 %x) nounwind {
; RV32I-LABEL: fold_srem_negative_odd:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    addi a1, zero, -723
; RV32I-NEXT:    call __modsi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: fold_srem_negative_odd:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 677296
; RV32IM-NEXT:    addi a1, a1, -91
; RV32IM-NEXT:    mulh a1, a0, a1
; RV32IM-NEXT:    srli a2, a1, 31
; RV32IM-NEXT:    srai a1, a1, 8
; RV32IM-NEXT:    add a1, a1, a2
; RV32IM-NEXT:    addi a2, zero, -723
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: fold_srem_negative_odd:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp)
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    addi a1, zero, -723
; RV64I-NEXT:    call __moddi3
; RV64I-NEXT:    ld ra, 8(sp)
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: fold_srem_negative_odd:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    sext.w a0, a0
; RV64IM-NEXT:    lui a1, 4781
; RV64IM-NEXT:    addiw a1, a1, 2045
; RV64IM-NEXT:    slli a1, a1, 13
; RV64IM-NEXT:    addi a1, a1, 1371
; RV64IM-NEXT:    slli a1, a1, 13
; RV64IM-NEXT:    addi a1, a1, -11
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, -1355
; RV64IM-NEXT:    mulh a1, a0, a1
; RV64IM-NEXT:    sub a1, a1, a0
; RV64IM-NEXT:    srli a2, a1, 63
; RV64IM-NEXT:    srai a1, a1, 9
; RV64IM-NEXT:    add a1, a1, a2
; RV64IM-NEXT:    addi a2, zero, -723
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    sub a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %x, -723
  ret i32 %1
}


define i32 @fold_srem_negative_even(i32 %x) nounwind {
; RV32I-LABEL: fold_srem_negative_even:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    lui a1, 1048570
; RV32I-NEXT:    addi a1, a1, 1595
; RV32I-NEXT:    call __modsi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: fold_srem_negative_even:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 1036895
; RV32IM-NEXT:    addi a1, a1, 999
; RV32IM-NEXT:    mulh a1, a0, a1
; RV32IM-NEXT:    srli a2, a1, 31
; RV32IM-NEXT:    srai a1, a1, 8
; RV32IM-NEXT:    add a1, a1, a2
; RV32IM-NEXT:    lui a2, 1048570
; RV32IM-NEXT:    addi a2, a2, 1595
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: fold_srem_negative_even:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp)
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    lui a1, 1048570
; RV64I-NEXT:    addiw a1, a1, 1595
; RV64I-NEXT:    call __moddi3
; RV64I-NEXT:    ld ra, 8(sp)
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: fold_srem_negative_even:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    sext.w a0, a0
; RV64IM-NEXT:    lui a1, 1036895
; RV64IM-NEXT:    addiw a1, a1, 999
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, 11
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, -523
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, -481
; RV64IM-NEXT:    mulh a1, a0, a1
; RV64IM-NEXT:    srli a2, a1, 63
; RV64IM-NEXT:    srai a1, a1, 12
; RV64IM-NEXT:    add a1, a1, a2
; RV64IM-NEXT:    lui a2, 1048570
; RV64IM-NEXT:    addiw a2, a2, 1595
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    sub a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %x, -22981
  ret i32 %1
}


; Don't fold if we can combine srem with sdiv.
define i32 @combine_srem_sdiv(i32 %x) nounwind {
; RV32I-LABEL: combine_srem_sdiv:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    sw s0, 8(sp)
; RV32I-NEXT:    sw s1, 4(sp)
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    call __modsi3
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    call __divsi3
; RV32I-NEXT:    add a0, s1, a0
; RV32I-NEXT:    lw s1, 4(sp)
; RV32I-NEXT:    lw s0, 8(sp)
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: combine_srem_sdiv:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 706409
; RV32IM-NEXT:    addi a1, a1, 389
; RV32IM-NEXT:    mulh a1, a0, a1
; RV32IM-NEXT:    add a1, a1, a0
; RV32IM-NEXT:    srli a2, a1, 31
; RV32IM-NEXT:    srai a1, a1, 6
; RV32IM-NEXT:    add a1, a1, a2
; RV32IM-NEXT:    addi a2, zero, 95
; RV32IM-NEXT:    mul a2, a1, a2
; RV32IM-NEXT:    sub a0, a0, a2
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: combine_srem_sdiv:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp)
; RV64I-NEXT:    sd s0, 16(sp)
; RV64I-NEXT:    sd s1, 8(sp)
; RV64I-NEXT:    sext.w s0, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call __moddi3
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call __divdi3
; RV64I-NEXT:    addw a0, s1, a0
; RV64I-NEXT:    ld s1, 8(sp)
; RV64I-NEXT:    ld s0, 16(sp)
; RV64I-NEXT:    ld ra, 24(sp)
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: combine_srem_sdiv:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    sext.w a1, a0
; RV64IM-NEXT:    lui a2, 1045903
; RV64IM-NEXT:    addiw a2, a2, -733
; RV64IM-NEXT:    slli a2, a2, 15
; RV64IM-NEXT:    addi a2, a2, 1035
; RV64IM-NEXT:    slli a2, a2, 12
; RV64IM-NEXT:    addi a2, a2, -905
; RV64IM-NEXT:    slli a2, a2, 12
; RV64IM-NEXT:    addi a2, a2, -1767
; RV64IM-NEXT:    mulh a2, a1, a2
; RV64IM-NEXT:    add a1, a2, a1
; RV64IM-NEXT:    srli a2, a1, 63
; RV64IM-NEXT:    srai a1, a1, 6
; RV64IM-NEXT:    add a1, a1, a2
; RV64IM-NEXT:    addi a2, zero, 95
; RV64IM-NEXT:    mul a2, a1, a2
; RV64IM-NEXT:    sub a0, a0, a2
; RV64IM-NEXT:    addw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %x, 95
  %2 = sdiv i32 %x, 95
  %3 = add i32 %1, %2
  ret i32 %3
}

; Don't fold for divisors that are a power of two.
define i32 @dont_fold_srem_power_of_two(i32 %x) nounwind {
; RV32I-LABEL: dont_fold_srem_power_of_two:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    srli a1, a1, 26
; RV32I-NEXT:    add a1, a0, a1
; RV32I-NEXT:    andi a1, a1, -64
; RV32I-NEXT:    sub a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: dont_fold_srem_power_of_two:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    srai a1, a0, 31
; RV32IM-NEXT:    srli a1, a1, 26
; RV32IM-NEXT:    add a1, a0, a1
; RV32IM-NEXT:    andi a1, a1, -64
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: dont_fold_srem_power_of_two:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sext.w a1, a0
; RV64I-NEXT:    srli a1, a1, 57
; RV64I-NEXT:    andi a1, a1, 63
; RV64I-NEXT:    add a1, a0, a1
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    slli a2, a2, 32
; RV64I-NEXT:    addi a2, a2, -64
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: dont_fold_srem_power_of_two:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    sext.w a1, a0
; RV64IM-NEXT:    srli a1, a1, 57
; RV64IM-NEXT:    andi a1, a1, 63
; RV64IM-NEXT:    add a1, a0, a1
; RV64IM-NEXT:    addi a2, zero, 1
; RV64IM-NEXT:    slli a2, a2, 32
; RV64IM-NEXT:    addi a2, a2, -64
; RV64IM-NEXT:    and a1, a1, a2
; RV64IM-NEXT:    subw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %x, 64
  ret i32 %1
}

; Don't fold if the divisor is one.
define i32 @dont_fold_srem_one(i32 %x) nounwind {
; CHECK-LABEL: dont_fold_srem_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mv a0, zero
; CHECK-NEXT:    ret
  %1 = srem i32 %x, 1
  ret i32 %1
}

; Don't fold if the divisor is 2^31.
define i32 @dont_fold_srem_i32_smax(i32 %x) nounwind {
; RV32I-LABEL: dont_fold_srem_i32_smax:
; RV32I:       # %bb.0:
; RV32I-NEXT:    srai a1, a0, 31
; RV32I-NEXT:    srli a1, a1, 1
; RV32I-NEXT:    add a1, a0, a1
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: dont_fold_srem_i32_smax:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    srai a1, a0, 31
; RV32IM-NEXT:    srli a1, a1, 1
; RV32IM-NEXT:    add a1, a0, a1
; RV32IM-NEXT:    lui a2, 524288
; RV32IM-NEXT:    and a1, a1, a2
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: dont_fold_srem_i32_smax:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sext.w a1, a0
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    addiw a2, a2, -1
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    add a1, a0, a1
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    slli a2, a2, 31
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    addw a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: dont_fold_srem_i32_smax:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    sext.w a1, a0
; RV64IM-NEXT:    srli a1, a1, 32
; RV64IM-NEXT:    lui a2, 524288
; RV64IM-NEXT:    addiw a2, a2, -1
; RV64IM-NEXT:    and a1, a1, a2
; RV64IM-NEXT:    add a1, a0, a1
; RV64IM-NEXT:    addi a2, zero, 1
; RV64IM-NEXT:    slli a2, a2, 31
; RV64IM-NEXT:    and a1, a1, a2
; RV64IM-NEXT:    addw a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i32 %x, 2147483648
  ret i32 %1
}

; Don't fold i64 srem
define i64 @dont_fold_srem_i64(i64 %x) nounwind {
; RV32I-LABEL: dont_fold_srem_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp)
; RV32I-NEXT:    addi a2, zero, 98
; RV32I-NEXT:    mv a3, zero
; RV32I-NEXT:    call __moddi3
; RV32I-NEXT:    lw ra, 12(sp)
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: dont_fold_srem_i64:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -16
; RV32IM-NEXT:    sw ra, 12(sp)
; RV32IM-NEXT:    addi a2, zero, 98
; RV32IM-NEXT:    mv a3, zero
; RV32IM-NEXT:    call __moddi3
; RV32IM-NEXT:    lw ra, 12(sp)
; RV32IM-NEXT:    addi sp, sp, 16
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: dont_fold_srem_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp)
; RV64I-NEXT:    addi a1, zero, 98
; RV64I-NEXT:    call __moddi3
; RV64I-NEXT:    ld ra, 8(sp)
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: dont_fold_srem_i64:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lui a1, 2675
; RV64IM-NEXT:    addiw a1, a1, -251
; RV64IM-NEXT:    slli a1, a1, 13
; RV64IM-NEXT:    addi a1, a1, 1839
; RV64IM-NEXT:    slli a1, a1, 13
; RV64IM-NEXT:    addi a1, a1, 167
; RV64IM-NEXT:    slli a1, a1, 13
; RV64IM-NEXT:    addi a1, a1, 1505
; RV64IM-NEXT:    mulh a1, a0, a1
; RV64IM-NEXT:    srli a2, a1, 63
; RV64IM-NEXT:    srai a1, a1, 5
; RV64IM-NEXT:    add a1, a1, a2
; RV64IM-NEXT:    addi a2, zero, 98
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    sub a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = srem i64 %x, 98
  ret i64 %1
}
