; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV32I %s
; RUN: llc -mtriple=riscv32 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV32IM %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV64I %s
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=CHECK,RV64IM %s

define i32 @fold_urem_positive_odd(i32 %x) nounwind {
; RV32I-LABEL: fold_urem_positive_odd:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    call __umodsi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: fold_urem_positive_odd:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 364242
; RV32IM-NEXT:    addi a1, a1, 777
; RV32IM-NEXT:    mulhu a1, a0, a1
; RV32IM-NEXT:    sub a2, a0, a1
; RV32IM-NEXT:    srli a2, a2, 1
; RV32IM-NEXT:    add a1, a2, a1
; RV32IM-NEXT:    srli a1, a1, 6
; RV32IM-NEXT:    addi a2, zero, 95
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: fold_urem_positive_odd:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    call __umoddi3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: fold_urem_positive_odd:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    lui a1, 1423
; RV64IM-NEXT:    addiw a1, a1, -733
; RV64IM-NEXT:    slli a1, a1, 15
; RV64IM-NEXT:    addi a1, a1, 1035
; RV64IM-NEXT:    slli a1, a1, 13
; RV64IM-NEXT:    addi a1, a1, -1811
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, 561
; RV64IM-NEXT:    mulhu a1, a0, a1
; RV64IM-NEXT:    sub a2, a0, a1
; RV64IM-NEXT:    srli a2, a2, 1
; RV64IM-NEXT:    add a1, a2, a1
; RV64IM-NEXT:    srli a1, a1, 6
; RV64IM-NEXT:    addi a2, zero, 95
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    sub a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %x, 95
  ret i32 %1
}


define i32 @fold_urem_positive_even(i32 %x) nounwind {
; RV32I-LABEL: fold_urem_positive_even:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi a1, zero, 1060
; RV32I-NEXT:    call __umodsi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: fold_urem_positive_even:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 1012964
; RV32IM-NEXT:    addi a1, a1, -61
; RV32IM-NEXT:    mulhu a1, a0, a1
; RV32IM-NEXT:    srli a1, a1, 10
; RV32IM-NEXT:    addi a2, zero, 1060
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: fold_urem_positive_even:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    addi a1, zero, 1060
; RV64I-NEXT:    call __umoddi3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: fold_urem_positive_even:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    lui a1, 1048020
; RV64IM-NEXT:    addiw a1, a1, -1793
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, 139
; RV64IM-NEXT:    slli a1, a1, 14
; RV64IM-NEXT:    addi a1, a1, 1793
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, -139
; RV64IM-NEXT:    mulhu a1, a0, a1
; RV64IM-NEXT:    srli a1, a1, 10
; RV64IM-NEXT:    addi a2, zero, 1060
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    sub a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %x, 1060
  ret i32 %1
}


; Don't fold if we can combine urem with udiv.
define i32 @combine_urem_udiv(i32 %x) nounwind {
; RV32I-LABEL: combine_urem_udiv:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    call __umodsi3@plt
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    addi a1, zero, 95
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    call __udivsi3@plt
; RV32I-NEXT:    add a0, s1, a0
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: combine_urem_udiv:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    lui a1, 364242
; RV32IM-NEXT:    addi a1, a1, 777
; RV32IM-NEXT:    mulhu a1, a0, a1
; RV32IM-NEXT:    sub a2, a0, a1
; RV32IM-NEXT:    srli a2, a2, 1
; RV32IM-NEXT:    add a1, a2, a1
; RV32IM-NEXT:    srli a1, a1, 6
; RV32IM-NEXT:    addi a2, zero, 95
; RV32IM-NEXT:    mul a2, a1, a2
; RV32IM-NEXT:    sub a0, a0, a2
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: combine_urem_udiv:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli s0, a0, 32
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call __umoddi3@plt
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    addi a1, zero, 95
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call __udivdi3@plt
; RV64I-NEXT:    add a0, s1, a0
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: combine_urem_udiv:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    srli a0, a0, 32
; RV64IM-NEXT:    lui a1, 1423
; RV64IM-NEXT:    addiw a1, a1, -733
; RV64IM-NEXT:    slli a1, a1, 15
; RV64IM-NEXT:    addi a1, a1, 1035
; RV64IM-NEXT:    slli a1, a1, 13
; RV64IM-NEXT:    addi a1, a1, -1811
; RV64IM-NEXT:    slli a1, a1, 12
; RV64IM-NEXT:    addi a1, a1, 561
; RV64IM-NEXT:    mulhu a1, a0, a1
; RV64IM-NEXT:    sub a2, a0, a1
; RV64IM-NEXT:    srli a2, a2, 1
; RV64IM-NEXT:    add a1, a2, a1
; RV64IM-NEXT:    srli a1, a1, 6
; RV64IM-NEXT:    addi a2, zero, 95
; RV64IM-NEXT:    mul a2, a1, a2
; RV64IM-NEXT:    sub a0, a0, a2
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i32 %x, 95
  %2 = udiv i32 %x, 95
  %3 = add i32 %1, %2
  ret i32 %3
}

; Don't fold for divisors that are a power of two.
define i32 @dont_fold_urem_power_of_two(i32 %x) nounwind {
; CHECK-LABEL: dont_fold_urem_power_of_two:
; CHECK:       # %bb.0:
; CHECK-NEXT:    andi a0, a0, 63
; CHECK-NEXT:    ret
  %1 = urem i32 %x, 64
  ret i32 %1
}

; Don't fold if the divisor is one.
define i32 @dont_fold_urem_one(i32 %x) nounwind {
; CHECK-LABEL: dont_fold_urem_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    mv a0, zero
; CHECK-NEXT:    ret
  %1 = urem i32 %x, 1
  ret i32 %1
}

; Don't fold if the divisor is 2^32.
define i32 @dont_fold_urem_i32_umax(i32 %x) nounwind {
; CHECK-LABEL: dont_fold_urem_i32_umax:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %1 = urem i32 %x, 4294967296
  ret i32 %1
}

; Don't fold i64 urem
define i64 @dont_fold_urem_i64(i64 %x) nounwind {
; RV32I-LABEL: dont_fold_urem_i64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    addi a2, zero, 98
; RV32I-NEXT:    mv a3, zero
; RV32I-NEXT:    call __umoddi3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IM-LABEL: dont_fold_urem_i64:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    addi sp, sp, -16
; RV32IM-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IM-NEXT:    addi a2, zero, 98
; RV32IM-NEXT:    mv a3, zero
; RV32IM-NEXT:    call __umoddi3@plt
; RV32IM-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IM-NEXT:    addi sp, sp, 16
; RV32IM-NEXT:    ret
;
; RV64I-LABEL: dont_fold_urem_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi a1, zero, 98
; RV64I-NEXT:    call __umoddi3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IM-LABEL: dont_fold_urem_i64:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    srli a1, a0, 1
; RV64IM-NEXT:    lui a2, 2675
; RV64IM-NEXT:    addiw a2, a2, -251
; RV64IM-NEXT:    slli a2, a2, 13
; RV64IM-NEXT:    addi a2, a2, 1839
; RV64IM-NEXT:    slli a2, a2, 13
; RV64IM-NEXT:    addi a2, a2, 167
; RV64IM-NEXT:    slli a2, a2, 13
; RV64IM-NEXT:    addi a2, a2, 1505
; RV64IM-NEXT:    mulhu a1, a1, a2
; RV64IM-NEXT:    srli a1, a1, 4
; RV64IM-NEXT:    addi a2, zero, 98
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    sub a0, a0, a1
; RV64IM-NEXT:    ret
  %1 = urem i64 %x, 98
  ret i64 %1
}
