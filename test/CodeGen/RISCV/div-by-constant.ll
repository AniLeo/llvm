; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=RV32,RV32IM %s
; RUN: llc -mtriple=riscv32 -mattr=+m,+zba,+zbb \
; RUN:    -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=RV32,RV32IMZB %s
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=RV64,RV64IM %s
; RUN: llc -mtriple=riscv64 -mattr=+m,+zba,+zbb \
; RUN:   -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefixes=RV64,RV64IMZB %s

; Test that there is a single shift after the mul and no addition.
define i32 @udiv_constant_no_add(i32 %a) nounwind {
; RV32-LABEL: udiv_constant_no_add:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a1, 838861
; RV32-NEXT:    addi a1, a1, -819
; RV32-NEXT:    mulhu a0, a0, a1
; RV32-NEXT:    srli a0, a0, 2
; RV32-NEXT:    ret
;
; RV64IM-LABEL: udiv_constant_no_add:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 32
; RV64IM-NEXT:    lui a1, 838861
; RV64IM-NEXT:    addiw a1, a1, -819
; RV64IM-NEXT:    slli a1, a1, 32
; RV64IM-NEXT:    mulhu a0, a0, a1
; RV64IM-NEXT:    srli a0, a0, 34
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: udiv_constant_no_add:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    zext.w a0, a0
; RV64IMZB-NEXT:    lui a1, 838861
; RV64IMZB-NEXT:    addiw a1, a1, -819
; RV64IMZB-NEXT:    zext.w a1, a1
; RV64IMZB-NEXT:    mul a0, a0, a1
; RV64IMZB-NEXT:    srli a0, a0, 34
; RV64IMZB-NEXT:    ret
  %1 = udiv i32 %a, 5
  ret i32 %1
}

; This constant requires a sub, shrli, add sequence after the mul.
define i32 @udiv_constant_add(i32 %a) nounwind {
; RV32-LABEL: udiv_constant_add:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a1, 149797
; RV32-NEXT:    addi a1, a1, -1755
; RV32-NEXT:    mulhu a1, a0, a1
; RV32-NEXT:    sub a0, a0, a1
; RV32-NEXT:    srli a0, a0, 1
; RV32-NEXT:    add a0, a0, a1
; RV32-NEXT:    srli a0, a0, 2
; RV32-NEXT:    ret
;
; RV64IM-LABEL: udiv_constant_add:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 32
; RV64IM-NEXT:    lui a2, 149797
; RV64IM-NEXT:    addiw a2, a2, -1755
; RV64IM-NEXT:    slli a2, a2, 32
; RV64IM-NEXT:    mulhu a1, a1, a2
; RV64IM-NEXT:    srli a1, a1, 32
; RV64IM-NEXT:    subw a0, a0, a1
; RV64IM-NEXT:    srliw a0, a0, 1
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    srli a0, a0, 2
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: udiv_constant_add:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    zext.w a1, a0
; RV64IMZB-NEXT:    lui a2, 149797
; RV64IMZB-NEXT:    addiw a2, a2, -1755
; RV64IMZB-NEXT:    mul a1, a1, a2
; RV64IMZB-NEXT:    srli a1, a1, 32
; RV64IMZB-NEXT:    subw a0, a0, a1
; RV64IMZB-NEXT:    srliw a0, a0, 1
; RV64IMZB-NEXT:    add a0, a0, a1
; RV64IMZB-NEXT:    srli a0, a0, 2
; RV64IMZB-NEXT:    ret
  %1 = udiv i32 %a, 7
  ret i32 %1
}

define i64 @udiv64_constant_no_add(i64 %a) nounwind {
; RV32-LABEL: udiv64_constant_no_add:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    li a2, 5
; RV32-NEXT:    li a3, 0
; RV32-NEXT:    call __udivdi3@plt
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: udiv64_constant_no_add:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a1, %hi(.LCPI2_0)
; RV64-NEXT:    ld a1, %lo(.LCPI2_0)(a1)
; RV64-NEXT:    mulhu a0, a0, a1
; RV64-NEXT:    srli a0, a0, 2
; RV64-NEXT:    ret
  %1 = udiv i64 %a, 5
  ret i64 %1
}

define i64 @udiv64_constant_add(i64 %a) nounwind {
; RV32-LABEL: udiv64_constant_add:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    li a2, 7
; RV32-NEXT:    li a3, 0
; RV32-NEXT:    call __udivdi3@plt
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: udiv64_constant_add:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a1, %hi(.LCPI3_0)
; RV64-NEXT:    ld a1, %lo(.LCPI3_0)(a1)
; RV64-NEXT:    mulhu a1, a0, a1
; RV64-NEXT:    sub a0, a0, a1
; RV64-NEXT:    srli a0, a0, 1
; RV64-NEXT:    add a0, a0, a1
; RV64-NEXT:    srli a0, a0, 2
; RV64-NEXT:    ret
  %1 = udiv i64 %a, 7
  ret i64 %1
}

define i8 @udiv8_constant_no_add(i8 %a) nounwind {
; RV32-LABEL: udiv8_constant_no_add:
; RV32:       # %bb.0:
; RV32-NEXT:    andi a0, a0, 255
; RV32-NEXT:    li a1, 205
; RV32-NEXT:    mul a0, a0, a1
; RV32-NEXT:    srli a0, a0, 10
; RV32-NEXT:    ret
;
; RV64-LABEL: udiv8_constant_no_add:
; RV64:       # %bb.0:
; RV64-NEXT:    andi a0, a0, 255
; RV64-NEXT:    li a1, 205
; RV64-NEXT:    mul a0, a0, a1
; RV64-NEXT:    srli a0, a0, 10
; RV64-NEXT:    ret
  %1 = udiv i8 %a, 5
  ret i8 %1
}

define i8 @udiv8_constant_add(i8 %a) nounwind {
; RV32IM-LABEL: udiv8_constant_add:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    andi a1, a0, 255
; RV32IM-NEXT:    li a2, 37
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    srli a1, a1, 8
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    slli a0, a0, 24
; RV32IM-NEXT:    srli a0, a0, 25
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    srli a0, a0, 2
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: udiv8_constant_add:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    andi a1, a0, 255
; RV32IMZB-NEXT:    sh3add a2, a1, a1
; RV32IMZB-NEXT:    sh2add a1, a2, a1
; RV32IMZB-NEXT:    srli a1, a1, 8
; RV32IMZB-NEXT:    sub a0, a0, a1
; RV32IMZB-NEXT:    slli a0, a0, 24
; RV32IMZB-NEXT:    srli a0, a0, 25
; RV32IMZB-NEXT:    add a0, a0, a1
; RV32IMZB-NEXT:    srli a0, a0, 2
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: udiv8_constant_add:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    andi a1, a0, 255
; RV64IM-NEXT:    li a2, 37
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    srli a1, a1, 8
; RV64IM-NEXT:    subw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 56
; RV64IM-NEXT:    srli a0, a0, 57
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    srli a0, a0, 2
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: udiv8_constant_add:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    andi a1, a0, 255
; RV64IMZB-NEXT:    sh3add a2, a1, a1
; RV64IMZB-NEXT:    sh2add a1, a2, a1
; RV64IMZB-NEXT:    srli a1, a1, 8
; RV64IMZB-NEXT:    subw a0, a0, a1
; RV64IMZB-NEXT:    slli a0, a0, 56
; RV64IMZB-NEXT:    srli a0, a0, 57
; RV64IMZB-NEXT:    add a0, a0, a1
; RV64IMZB-NEXT:    srli a0, a0, 2
; RV64IMZB-NEXT:    ret
  %1 = udiv i8 %a, 7
  ret i8 %1
}

define i16 @udiv16_constant_no_add(i16 %a) nounwind {
; RV32IM-LABEL: udiv16_constant_no_add:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a0, a0, 16
; RV32IM-NEXT:    lui a1, 838864
; RV32IM-NEXT:    mulhu a0, a0, a1
; RV32IM-NEXT:    srli a0, a0, 18
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: udiv16_constant_no_add:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    zext.h a0, a0
; RV32IMZB-NEXT:    lui a1, 13
; RV32IMZB-NEXT:    addi a1, a1, -819
; RV32IMZB-NEXT:    mul a0, a0, a1
; RV32IMZB-NEXT:    srli a0, a0, 18
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: udiv16_constant_no_add:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    lui a1, 52429
; RV64IM-NEXT:    slli a1, a1, 4
; RV64IM-NEXT:    slli a0, a0, 48
; RV64IM-NEXT:    mulhu a0, a0, a1
; RV64IM-NEXT:    srli a0, a0, 18
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: udiv16_constant_no_add:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    zext.h a0, a0
; RV64IMZB-NEXT:    lui a1, 13
; RV64IMZB-NEXT:    addiw a1, a1, -819
; RV64IMZB-NEXT:    mul a0, a0, a1
; RV64IMZB-NEXT:    srli a0, a0, 18
; RV64IMZB-NEXT:    ret
  %1 = udiv i16 %a, 5
  ret i16 %1
}

define i16 @udiv16_constant_add(i16 %a) nounwind {
; RV32IM-LABEL: udiv16_constant_add:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 16
; RV32IM-NEXT:    lui a2, 149808
; RV32IM-NEXT:    mulhu a1, a1, a2
; RV32IM-NEXT:    srli a1, a1, 16
; RV32IM-NEXT:    sub a0, a0, a1
; RV32IM-NEXT:    slli a0, a0, 16
; RV32IM-NEXT:    srli a0, a0, 17
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    srli a0, a0, 2
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: udiv16_constant_add:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    zext.h a1, a0
; RV32IMZB-NEXT:    lui a2, 2
; RV32IMZB-NEXT:    addi a2, a2, 1171
; RV32IMZB-NEXT:    mul a1, a1, a2
; RV32IMZB-NEXT:    srli a1, a1, 16
; RV32IMZB-NEXT:    sub a0, a0, a1
; RV32IMZB-NEXT:    slli a0, a0, 16
; RV32IMZB-NEXT:    srli a0, a0, 17
; RV32IMZB-NEXT:    add a0, a0, a1
; RV32IMZB-NEXT:    srli a0, a0, 2
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: udiv16_constant_add:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 48
; RV64IM-NEXT:    lui a2, 149808
; RV64IM-NEXT:    mulhu a1, a1, a2
; RV64IM-NEXT:    srli a1, a1, 16
; RV64IM-NEXT:    subw a0, a0, a1
; RV64IM-NEXT:    slli a0, a0, 48
; RV64IM-NEXT:    srli a0, a0, 49
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    srli a0, a0, 2
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: udiv16_constant_add:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    zext.h a1, a0
; RV64IMZB-NEXT:    lui a2, 2
; RV64IMZB-NEXT:    addiw a2, a2, 1171
; RV64IMZB-NEXT:    mul a1, a1, a2
; RV64IMZB-NEXT:    srli a1, a1, 16
; RV64IMZB-NEXT:    subw a0, a0, a1
; RV64IMZB-NEXT:    slli a0, a0, 48
; RV64IMZB-NEXT:    srli a0, a0, 49
; RV64IMZB-NEXT:    add a0, a0, a1
; RV64IMZB-NEXT:    srli a0, a0, 2
; RV64IMZB-NEXT:    ret
  %1 = udiv i16 %a, 7
  ret i16 %1
}

; Test the simplest case a srli and an add after the mul. No srai.
define i32 @sdiv_constant_no_srai(i32 %a) nounwind {
; RV32-LABEL: sdiv_constant_no_srai:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a1, 349525
; RV32-NEXT:    addi a1, a1, 1366
; RV32-NEXT:    mulh a0, a0, a1
; RV32-NEXT:    srli a1, a0, 31
; RV32-NEXT:    add a0, a0, a1
; RV32-NEXT:    ret
;
; RV64-LABEL: sdiv_constant_no_srai:
; RV64:       # %bb.0:
; RV64-NEXT:    sext.w a0, a0
; RV64-NEXT:    lui a1, 349525
; RV64-NEXT:    addiw a1, a1, 1366
; RV64-NEXT:    mul a0, a0, a1
; RV64-NEXT:    srli a1, a0, 63
; RV64-NEXT:    srli a0, a0, 32
; RV64-NEXT:    addw a0, a0, a1
; RV64-NEXT:    ret
  %1 = sdiv i32 %a, 3
  ret i32 %1
}

; This constant requires an srai between the mul and the add.
define i32 @sdiv_constant_srai(i32 %a) nounwind {
; RV32-LABEL: sdiv_constant_srai:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a1, 419430
; RV32-NEXT:    addi a1, a1, 1639
; RV32-NEXT:    mulh a0, a0, a1
; RV32-NEXT:    srli a1, a0, 31
; RV32-NEXT:    srai a0, a0, 1
; RV32-NEXT:    add a0, a0, a1
; RV32-NEXT:    ret
;
; RV64-LABEL: sdiv_constant_srai:
; RV64:       # %bb.0:
; RV64-NEXT:    sext.w a0, a0
; RV64-NEXT:    lui a1, 419430
; RV64-NEXT:    addiw a1, a1, 1639
; RV64-NEXT:    mul a0, a0, a1
; RV64-NEXT:    srli a1, a0, 63
; RV64-NEXT:    srai a0, a0, 33
; RV64-NEXT:    add a0, a0, a1
; RV64-NEXT:    ret
  %1 = sdiv i32 %a, 5
  ret i32 %1
}

; This constant requires an add and an srai after the mul.
define i32 @sdiv_constant_add_srai(i32 %a) nounwind {
; RV32-LABEL: sdiv_constant_add_srai:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a1, 599186
; RV32-NEXT:    addi a1, a1, 1171
; RV32-NEXT:    mulh a1, a0, a1
; RV32-NEXT:    add a0, a1, a0
; RV32-NEXT:    srli a1, a0, 31
; RV32-NEXT:    srai a0, a0, 2
; RV32-NEXT:    add a0, a0, a1
; RV32-NEXT:    ret
;
; RV64-LABEL: sdiv_constant_add_srai:
; RV64:       # %bb.0:
; RV64-NEXT:    sext.w a1, a0
; RV64-NEXT:    lui a2, 599186
; RV64-NEXT:    addiw a2, a2, 1171
; RV64-NEXT:    mul a1, a1, a2
; RV64-NEXT:    srli a1, a1, 32
; RV64-NEXT:    addw a0, a1, a0
; RV64-NEXT:    srliw a1, a0, 31
; RV64-NEXT:    sraiw a0, a0, 2
; RV64-NEXT:    add a0, a0, a1
; RV64-NEXT:    ret
  %1 = sdiv i32 %a, 7
  ret i32 %1
}

; This constant requires a sub and an srai after the mul.
define i32 @sdiv_constant_sub_srai(i32 %a) nounwind {
; RV32-LABEL: sdiv_constant_sub_srai:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a1, 449390
; RV32-NEXT:    addi a1, a1, -1171
; RV32-NEXT:    mulh a1, a0, a1
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    srli a1, a0, 31
; RV32-NEXT:    srai a0, a0, 2
; RV32-NEXT:    add a0, a0, a1
; RV32-NEXT:    ret
;
; RV64-LABEL: sdiv_constant_sub_srai:
; RV64:       # %bb.0:
; RV64-NEXT:    sext.w a1, a0
; RV64-NEXT:    lui a2, 449390
; RV64-NEXT:    addiw a2, a2, -1171
; RV64-NEXT:    mul a1, a1, a2
; RV64-NEXT:    srli a1, a1, 32
; RV64-NEXT:    subw a0, a1, a0
; RV64-NEXT:    srliw a1, a0, 31
; RV64-NEXT:    sraiw a0, a0, 2
; RV64-NEXT:    add a0, a0, a1
; RV64-NEXT:    ret
  %1 = sdiv i32 %a, -7
  ret i32 %1
}

define i64 @sdiv64_constant_no_srai(i64 %a) nounwind {
; RV32-LABEL: sdiv64_constant_no_srai:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    li a2, 3
; RV32-NEXT:    li a3, 0
; RV32-NEXT:    call __divdi3@plt
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: sdiv64_constant_no_srai:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a1, %hi(.LCPI12_0)
; RV64-NEXT:    ld a1, %lo(.LCPI12_0)(a1)
; RV64-NEXT:    mulh a0, a0, a1
; RV64-NEXT:    srli a1, a0, 63
; RV64-NEXT:    add a0, a0, a1
; RV64-NEXT:    ret
  %1 = sdiv i64 %a, 3
  ret i64 %1
}

define i64 @sdiv64_constant_srai(i64 %a) nounwind {
; RV32-LABEL: sdiv64_constant_srai:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    li a2, 5
; RV32-NEXT:    li a3, 0
; RV32-NEXT:    call __divdi3@plt
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: sdiv64_constant_srai:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a1, %hi(.LCPI13_0)
; RV64-NEXT:    ld a1, %lo(.LCPI13_0)(a1)
; RV64-NEXT:    mulh a0, a0, a1
; RV64-NEXT:    srli a1, a0, 63
; RV64-NEXT:    srai a0, a0, 1
; RV64-NEXT:    add a0, a0, a1
; RV64-NEXT:    ret
  %1 = sdiv i64 %a, 5
  ret i64 %1
}

define i64 @sdiv64_constant_add_srai(i64 %a) nounwind {
; RV32-LABEL: sdiv64_constant_add_srai:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    li a2, 15
; RV32-NEXT:    li a3, 0
; RV32-NEXT:    call __divdi3@plt
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: sdiv64_constant_add_srai:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a1, %hi(.LCPI14_0)
; RV64-NEXT:    ld a1, %lo(.LCPI14_0)(a1)
; RV64-NEXT:    mulh a1, a0, a1
; RV64-NEXT:    add a0, a1, a0
; RV64-NEXT:    srli a1, a0, 63
; RV64-NEXT:    srai a0, a0, 3
; RV64-NEXT:    add a0, a0, a1
; RV64-NEXT:    ret
  %1 = sdiv i64 %a, 15
  ret i64 %1
}

define i64 @sdiv64_constant_sub_srai(i64 %a) nounwind {
; RV32-LABEL: sdiv64_constant_sub_srai:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    li a2, -3
; RV32-NEXT:    li a3, -1
; RV32-NEXT:    call __divdi3@plt
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: sdiv64_constant_sub_srai:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a1, %hi(.LCPI15_0)
; RV64-NEXT:    ld a1, %lo(.LCPI15_0)(a1)
; RV64-NEXT:    mulh a1, a0, a1
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    srli a1, a0, 63
; RV64-NEXT:    srai a0, a0, 1
; RV64-NEXT:    add a0, a0, a1
; RV64-NEXT:    ret
  %1 = sdiv i64 %a, -3
  ret i64 %1
}

define i8 @sdiv8_constant_no_srai(i8 %a) nounwind {
; RV32IM-LABEL: sdiv8_constant_no_srai:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a0, a0, 24
; RV32IM-NEXT:    srai a0, a0, 24
; RV32IM-NEXT:    li a1, 86
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    srli a1, a0, 8
; RV32IM-NEXT:    srli a0, a0, 15
; RV32IM-NEXT:    andi a0, a0, 1
; RV32IM-NEXT:    add a0, a1, a0
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: sdiv8_constant_no_srai:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    sext.b a0, a0
; RV32IMZB-NEXT:    li a1, 86
; RV32IMZB-NEXT:    mul a0, a0, a1
; RV32IMZB-NEXT:    srli a1, a0, 8
; RV32IMZB-NEXT:    srli a0, a0, 15
; RV32IMZB-NEXT:    andi a0, a0, 1
; RV32IMZB-NEXT:    add a0, a1, a0
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: sdiv8_constant_no_srai:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 56
; RV64IM-NEXT:    srai a0, a0, 56
; RV64IM-NEXT:    li a1, 86
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    srli a1, a0, 8
; RV64IM-NEXT:    srli a0, a0, 15
; RV64IM-NEXT:    andi a0, a0, 1
; RV64IM-NEXT:    add a0, a1, a0
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: sdiv8_constant_no_srai:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    sext.b a0, a0
; RV64IMZB-NEXT:    li a1, 86
; RV64IMZB-NEXT:    mul a0, a0, a1
; RV64IMZB-NEXT:    srli a1, a0, 8
; RV64IMZB-NEXT:    srli a0, a0, 15
; RV64IMZB-NEXT:    andi a0, a0, 1
; RV64IMZB-NEXT:    add a0, a1, a0
; RV64IMZB-NEXT:    ret
  %1 = sdiv i8 %a, 3
  ret i8 %1
}

define i8 @sdiv8_constant_srai(i8 %a) nounwind {
; RV32IM-LABEL: sdiv8_constant_srai:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a0, a0, 24
; RV32IM-NEXT:    srai a0, a0, 24
; RV32IM-NEXT:    li a1, 103
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    srai a1, a0, 9
; RV32IM-NEXT:    srli a0, a0, 15
; RV32IM-NEXT:    andi a0, a0, 1
; RV32IM-NEXT:    add a0, a1, a0
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: sdiv8_constant_srai:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    sext.b a0, a0
; RV32IMZB-NEXT:    li a1, 103
; RV32IMZB-NEXT:    mul a0, a0, a1
; RV32IMZB-NEXT:    srai a1, a0, 9
; RV32IMZB-NEXT:    srli a0, a0, 15
; RV32IMZB-NEXT:    andi a0, a0, 1
; RV32IMZB-NEXT:    add a0, a1, a0
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: sdiv8_constant_srai:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 56
; RV64IM-NEXT:    srai a0, a0, 56
; RV64IM-NEXT:    li a1, 103
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    srai a1, a0, 9
; RV64IM-NEXT:    srli a0, a0, 15
; RV64IM-NEXT:    andi a0, a0, 1
; RV64IM-NEXT:    add a0, a1, a0
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: sdiv8_constant_srai:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    sext.b a0, a0
; RV64IMZB-NEXT:    li a1, 103
; RV64IMZB-NEXT:    mul a0, a0, a1
; RV64IMZB-NEXT:    srai a1, a0, 9
; RV64IMZB-NEXT:    srli a0, a0, 15
; RV64IMZB-NEXT:    andi a0, a0, 1
; RV64IMZB-NEXT:    add a0, a1, a0
; RV64IMZB-NEXT:    ret
  %1 = sdiv i8 %a, 5
  ret i8 %1
}

define i8 @sdiv8_constant_add_srai(i8 %a) nounwind {
; RV32IM-LABEL: sdiv8_constant_add_srai:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 24
; RV32IM-NEXT:    srai a1, a1, 24
; RV32IM-NEXT:    li a2, -109
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    srli a1, a1, 8
; RV32IM-NEXT:    add a0, a1, a0
; RV32IM-NEXT:    slli a0, a0, 24
; RV32IM-NEXT:    srli a1, a0, 31
; RV32IM-NEXT:    srai a0, a0, 26
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: sdiv8_constant_add_srai:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    sext.b a1, a0
; RV32IMZB-NEXT:    li a2, -109
; RV32IMZB-NEXT:    mul a1, a1, a2
; RV32IMZB-NEXT:    srli a1, a1, 8
; RV32IMZB-NEXT:    add a0, a1, a0
; RV32IMZB-NEXT:    slli a0, a0, 24
; RV32IMZB-NEXT:    srli a1, a0, 31
; RV32IMZB-NEXT:    srai a0, a0, 26
; RV32IMZB-NEXT:    add a0, a0, a1
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: sdiv8_constant_add_srai:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 56
; RV64IM-NEXT:    srai a1, a1, 56
; RV64IM-NEXT:    li a2, -109
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    srli a1, a1, 8
; RV64IM-NEXT:    addw a0, a1, a0
; RV64IM-NEXT:    slli a0, a0, 56
; RV64IM-NEXT:    srli a1, a0, 63
; RV64IM-NEXT:    srai a0, a0, 58
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: sdiv8_constant_add_srai:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    sext.b a1, a0
; RV64IMZB-NEXT:    li a2, -109
; RV64IMZB-NEXT:    mul a1, a1, a2
; RV64IMZB-NEXT:    srli a1, a1, 8
; RV64IMZB-NEXT:    addw a0, a1, a0
; RV64IMZB-NEXT:    slli a0, a0, 56
; RV64IMZB-NEXT:    srli a1, a0, 63
; RV64IMZB-NEXT:    srai a0, a0, 58
; RV64IMZB-NEXT:    add a0, a0, a1
; RV64IMZB-NEXT:    ret
  %1 = sdiv i8 %a, 7
  ret i8 %1
}

define i8 @sdiv8_constant_sub_srai(i8 %a) nounwind {
; RV32IM-LABEL: sdiv8_constant_sub_srai:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 24
; RV32IM-NEXT:    srai a1, a1, 24
; RV32IM-NEXT:    li a2, 109
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    srli a1, a1, 8
; RV32IM-NEXT:    sub a0, a1, a0
; RV32IM-NEXT:    slli a0, a0, 24
; RV32IM-NEXT:    srli a1, a0, 31
; RV32IM-NEXT:    srai a0, a0, 26
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: sdiv8_constant_sub_srai:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    sext.b a1, a0
; RV32IMZB-NEXT:    li a2, 109
; RV32IMZB-NEXT:    mul a1, a1, a2
; RV32IMZB-NEXT:    srli a1, a1, 8
; RV32IMZB-NEXT:    sub a0, a1, a0
; RV32IMZB-NEXT:    slli a0, a0, 24
; RV32IMZB-NEXT:    srli a1, a0, 31
; RV32IMZB-NEXT:    srai a0, a0, 26
; RV32IMZB-NEXT:    add a0, a0, a1
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: sdiv8_constant_sub_srai:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 56
; RV64IM-NEXT:    srai a1, a1, 56
; RV64IM-NEXT:    li a2, 109
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    srli a1, a1, 8
; RV64IM-NEXT:    subw a0, a1, a0
; RV64IM-NEXT:    slli a0, a0, 56
; RV64IM-NEXT:    srli a1, a0, 63
; RV64IM-NEXT:    srai a0, a0, 58
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: sdiv8_constant_sub_srai:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    sext.b a1, a0
; RV64IMZB-NEXT:    li a2, 109
; RV64IMZB-NEXT:    mul a1, a1, a2
; RV64IMZB-NEXT:    srli a1, a1, 8
; RV64IMZB-NEXT:    subw a0, a1, a0
; RV64IMZB-NEXT:    slli a0, a0, 56
; RV64IMZB-NEXT:    srli a1, a0, 63
; RV64IMZB-NEXT:    srai a0, a0, 58
; RV64IMZB-NEXT:    add a0, a0, a1
; RV64IMZB-NEXT:    ret
  %1 = sdiv i8 %a, -7
  ret i8 %1
}

define i16 @sdiv16_constant_no_srai(i16 %a) nounwind {
; RV32IM-LABEL: sdiv16_constant_no_srai:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a0, a0, 16
; RV32IM-NEXT:    srai a0, a0, 16
; RV32IM-NEXT:    lui a1, 5
; RV32IM-NEXT:    addi a1, a1, 1366
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    srli a1, a0, 31
; RV32IM-NEXT:    srli a0, a0, 16
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: sdiv16_constant_no_srai:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    sext.h a0, a0
; RV32IMZB-NEXT:    lui a1, 5
; RV32IMZB-NEXT:    addi a1, a1, 1366
; RV32IMZB-NEXT:    mul a0, a0, a1
; RV32IMZB-NEXT:    srli a1, a0, 31
; RV32IMZB-NEXT:    srli a0, a0, 16
; RV32IMZB-NEXT:    add a0, a0, a1
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: sdiv16_constant_no_srai:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 48
; RV64IM-NEXT:    srai a0, a0, 48
; RV64IM-NEXT:    lui a1, 5
; RV64IM-NEXT:    addiw a1, a1, 1366
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    srliw a1, a0, 31
; RV64IM-NEXT:    srli a0, a0, 16
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: sdiv16_constant_no_srai:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    sext.h a0, a0
; RV64IMZB-NEXT:    lui a1, 5
; RV64IMZB-NEXT:    addiw a1, a1, 1366
; RV64IMZB-NEXT:    mul a0, a0, a1
; RV64IMZB-NEXT:    srliw a1, a0, 31
; RV64IMZB-NEXT:    srli a0, a0, 16
; RV64IMZB-NEXT:    add a0, a0, a1
; RV64IMZB-NEXT:    ret
  %1 = sdiv i16 %a, 3
  ret i16 %1
}

define i16 @sdiv16_constant_srai(i16 %a) nounwind {
; RV32IM-LABEL: sdiv16_constant_srai:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a0, a0, 16
; RV32IM-NEXT:    srai a0, a0, 16
; RV32IM-NEXT:    lui a1, 6
; RV32IM-NEXT:    addi a1, a1, 1639
; RV32IM-NEXT:    mul a0, a0, a1
; RV32IM-NEXT:    srli a1, a0, 31
; RV32IM-NEXT:    srai a0, a0, 17
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: sdiv16_constant_srai:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    sext.h a0, a0
; RV32IMZB-NEXT:    lui a1, 6
; RV32IMZB-NEXT:    addi a1, a1, 1639
; RV32IMZB-NEXT:    mul a0, a0, a1
; RV32IMZB-NEXT:    srli a1, a0, 31
; RV32IMZB-NEXT:    srai a0, a0, 17
; RV32IMZB-NEXT:    add a0, a0, a1
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: sdiv16_constant_srai:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a0, a0, 48
; RV64IM-NEXT:    srai a0, a0, 48
; RV64IM-NEXT:    lui a1, 6
; RV64IM-NEXT:    addiw a1, a1, 1639
; RV64IM-NEXT:    mul a0, a0, a1
; RV64IM-NEXT:    srliw a1, a0, 31
; RV64IM-NEXT:    srai a0, a0, 17
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: sdiv16_constant_srai:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    sext.h a0, a0
; RV64IMZB-NEXT:    lui a1, 6
; RV64IMZB-NEXT:    addiw a1, a1, 1639
; RV64IMZB-NEXT:    mul a0, a0, a1
; RV64IMZB-NEXT:    srliw a1, a0, 31
; RV64IMZB-NEXT:    srai a0, a0, 17
; RV64IMZB-NEXT:    add a0, a0, a1
; RV64IMZB-NEXT:    ret
  %1 = sdiv i16 %a, 5
  ret i16 %1
}

define i16 @sdiv16_constant_add_srai(i16 %a) nounwind {
; RV32IM-LABEL: sdiv16_constant_add_srai:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 16
; RV32IM-NEXT:    srai a1, a1, 16
; RV32IM-NEXT:    lui a2, 1048569
; RV32IM-NEXT:    addi a2, a2, -1911
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    srli a1, a1, 16
; RV32IM-NEXT:    add a0, a1, a0
; RV32IM-NEXT:    slli a0, a0, 16
; RV32IM-NEXT:    srli a1, a0, 31
; RV32IM-NEXT:    srai a0, a0, 19
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: sdiv16_constant_add_srai:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    sext.h a1, a0
; RV32IMZB-NEXT:    lui a2, 1048569
; RV32IMZB-NEXT:    addi a2, a2, -1911
; RV32IMZB-NEXT:    mul a1, a1, a2
; RV32IMZB-NEXT:    srli a1, a1, 16
; RV32IMZB-NEXT:    add a0, a1, a0
; RV32IMZB-NEXT:    slli a0, a0, 16
; RV32IMZB-NEXT:    srli a1, a0, 31
; RV32IMZB-NEXT:    srai a0, a0, 19
; RV32IMZB-NEXT:    add a0, a0, a1
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: sdiv16_constant_add_srai:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 48
; RV64IM-NEXT:    srai a1, a1, 48
; RV64IM-NEXT:    lui a2, 1048569
; RV64IM-NEXT:    addiw a2, a2, -1911
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    srli a1, a1, 16
; RV64IM-NEXT:    addw a0, a1, a0
; RV64IM-NEXT:    slli a0, a0, 48
; RV64IM-NEXT:    srli a1, a0, 63
; RV64IM-NEXT:    srai a0, a0, 51
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: sdiv16_constant_add_srai:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    sext.h a1, a0
; RV64IMZB-NEXT:    lui a2, 1048569
; RV64IMZB-NEXT:    addiw a2, a2, -1911
; RV64IMZB-NEXT:    mul a1, a1, a2
; RV64IMZB-NEXT:    srli a1, a1, 16
; RV64IMZB-NEXT:    addw a0, a1, a0
; RV64IMZB-NEXT:    slli a0, a0, 48
; RV64IMZB-NEXT:    srli a1, a0, 63
; RV64IMZB-NEXT:    srai a0, a0, 51
; RV64IMZB-NEXT:    add a0, a0, a1
; RV64IMZB-NEXT:    ret
  %1 = sdiv i16 %a, 15
  ret i16 %1
}

define i16 @sdiv16_constant_sub_srai(i16 %a) nounwind {
; RV32IM-LABEL: sdiv16_constant_sub_srai:
; RV32IM:       # %bb.0:
; RV32IM-NEXT:    slli a1, a0, 16
; RV32IM-NEXT:    srai a1, a1, 16
; RV32IM-NEXT:    lui a2, 7
; RV32IM-NEXT:    addi a2, a2, 1911
; RV32IM-NEXT:    mul a1, a1, a2
; RV32IM-NEXT:    srli a1, a1, 16
; RV32IM-NEXT:    sub a0, a1, a0
; RV32IM-NEXT:    slli a0, a0, 16
; RV32IM-NEXT:    srli a1, a0, 31
; RV32IM-NEXT:    srai a0, a0, 19
; RV32IM-NEXT:    add a0, a0, a1
; RV32IM-NEXT:    ret
;
; RV32IMZB-LABEL: sdiv16_constant_sub_srai:
; RV32IMZB:       # %bb.0:
; RV32IMZB-NEXT:    sext.h a1, a0
; RV32IMZB-NEXT:    lui a2, 7
; RV32IMZB-NEXT:    addi a2, a2, 1911
; RV32IMZB-NEXT:    mul a1, a1, a2
; RV32IMZB-NEXT:    srli a1, a1, 16
; RV32IMZB-NEXT:    sub a0, a1, a0
; RV32IMZB-NEXT:    slli a0, a0, 16
; RV32IMZB-NEXT:    srli a1, a0, 31
; RV32IMZB-NEXT:    srai a0, a0, 19
; RV32IMZB-NEXT:    add a0, a0, a1
; RV32IMZB-NEXT:    ret
;
; RV64IM-LABEL: sdiv16_constant_sub_srai:
; RV64IM:       # %bb.0:
; RV64IM-NEXT:    slli a1, a0, 48
; RV64IM-NEXT:    srai a1, a1, 48
; RV64IM-NEXT:    lui a2, 7
; RV64IM-NEXT:    addiw a2, a2, 1911
; RV64IM-NEXT:    mul a1, a1, a2
; RV64IM-NEXT:    srli a1, a1, 16
; RV64IM-NEXT:    subw a0, a1, a0
; RV64IM-NEXT:    slli a0, a0, 48
; RV64IM-NEXT:    srli a1, a0, 63
; RV64IM-NEXT:    srai a0, a0, 51
; RV64IM-NEXT:    add a0, a0, a1
; RV64IM-NEXT:    ret
;
; RV64IMZB-LABEL: sdiv16_constant_sub_srai:
; RV64IMZB:       # %bb.0:
; RV64IMZB-NEXT:    sext.h a1, a0
; RV64IMZB-NEXT:    lui a2, 7
; RV64IMZB-NEXT:    addiw a2, a2, 1911
; RV64IMZB-NEXT:    mul a1, a1, a2
; RV64IMZB-NEXT:    srli a1, a1, 16
; RV64IMZB-NEXT:    subw a0, a1, a0
; RV64IMZB-NEXT:    slli a0, a0, 48
; RV64IMZB-NEXT:    srli a1, a0, 63
; RV64IMZB-NEXT:    srai a0, a0, 51
; RV64IMZB-NEXT:    add a0, a0, a1
; RV64IMZB-NEXT:    ret
  %1 = sdiv i16 %a, -15
  ret i16 %1
}
