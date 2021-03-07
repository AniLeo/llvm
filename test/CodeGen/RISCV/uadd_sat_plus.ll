; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv32 -mattr=+m | FileCheck %s --check-prefix=RV32I
; RUN: llc < %s -mtriple=riscv64 -mattr=+m | FileCheck %s --check-prefix=RV64I
; RUN: llc < %s -mtriple=riscv32 -mattr=+m,+experimental-zbb | FileCheck %s --check-prefix=RV32IZbb
; RUN: llc < %s -mtriple=riscv64 -mattr=+m,+experimental-zbb | FileCheck %s --check-prefix=RV64IZbb

declare i4 @llvm.uadd.sat.i4(i4, i4)
declare i8 @llvm.uadd.sat.i8(i8, i8)
declare i16 @llvm.uadd.sat.i16(i16, i16)
declare i32 @llvm.uadd.sat.i32(i32, i32)
declare i64 @llvm.uadd.sat.i64(i64, i64)

define i32 @func32(i32 %x, i32 %y, i32 %z) nounwind {
; RV32I-LABEL: func32:
; RV32I:       # %bb.0:
; RV32I-NEXT:    mv a3, a0
; RV32I-NEXT:    mul a0, a1, a2
; RV32I-NEXT:    add a1, a3, a0
; RV32I-NEXT:    addi a0, zero, -1
; RV32I-NEXT:    bltu a1, a3, .LBB0_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:  .LBB0_2:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    mul a1, a1, a2
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    addi a1, zero, 1
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    addi a1, a1, -1
; RV64I-NEXT:    bltu a0, a1, .LBB0_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB0_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func32:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    mul a1, a1, a2
; RV32IZbb-NEXT:    not a2, a1
; RV32IZbb-NEXT:    minu a0, a0, a2
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func32:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    slli a0, a0, 32
; RV64IZbb-NEXT:    srli a0, a0, 32
; RV64IZbb-NEXT:    mul a1, a1, a2
; RV64IZbb-NEXT:    slli a1, a1, 32
; RV64IZbb-NEXT:    srli a1, a1, 32
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    addi a1, zero, 1
; RV64IZbb-NEXT:    slli a1, a1, 32
; RV64IZbb-NEXT:    addi a1, a1, -1
; RV64IZbb-NEXT:    minu a0, a0, a1
; RV64IZbb-NEXT:    ret
  %a = mul i32 %y, %z
  %tmp = call i32 @llvm.uadd.sat.i32(i32 %x, i32 %a)
  ret i32 %tmp
}

define i64 @func64(i64 %x, i64 %y, i64 %z) nounwind {
; RV32I-LABEL: func64:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a3, a1, a5
; RV32I-NEXT:    add a2, a0, a4
; RV32I-NEXT:    sltu a4, a2, a0
; RV32I-NEXT:    add a3, a3, a4
; RV32I-NEXT:    beq a3, a1, .LBB1_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    sltu a4, a3, a1
; RV32I-NEXT:  .LBB1_2:
; RV32I-NEXT:    addi a0, zero, -1
; RV32I-NEXT:    addi a1, zero, -1
; RV32I-NEXT:    bnez a4, .LBB1_4
; RV32I-NEXT:  # %bb.3:
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    mv a1, a3
; RV32I-NEXT:  .LBB1_4:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    add a2, a0, a2
; RV64I-NEXT:    addi a0, zero, -1
; RV64I-NEXT:    bltu a2, a1, .LBB1_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:  .LBB1_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func64:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    add a3, a1, a5
; RV32IZbb-NEXT:    add a2, a0, a4
; RV32IZbb-NEXT:    sltu a4, a2, a0
; RV32IZbb-NEXT:    add a3, a3, a4
; RV32IZbb-NEXT:    beq a3, a1, .LBB1_2
; RV32IZbb-NEXT:  # %bb.1:
; RV32IZbb-NEXT:    sltu a4, a3, a1
; RV32IZbb-NEXT:  .LBB1_2:
; RV32IZbb-NEXT:    addi a0, zero, -1
; RV32IZbb-NEXT:    addi a1, zero, -1
; RV32IZbb-NEXT:    bnez a4, .LBB1_4
; RV32IZbb-NEXT:  # %bb.3:
; RV32IZbb-NEXT:    mv a0, a2
; RV32IZbb-NEXT:    mv a1, a3
; RV32IZbb-NEXT:  .LBB1_4:
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func64:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    not a1, a2
; RV64IZbb-NEXT:    minu a0, a0, a1
; RV64IZbb-NEXT:    add a0, a0, a2
; RV64IZbb-NEXT:    ret
  %a = mul i64 %y, %z
  %tmp = call i64 @llvm.uadd.sat.i64(i64 %x, i64 %z)
  ret i64 %tmp
}

define i16 @func16(i16 %x, i16 %y, i16 %z) nounwind {
; RV32I-LABEL: func16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 16
; RV32I-NEXT:    addi a3, a3, -1
; RV32I-NEXT:    and a0, a0, a3
; RV32I-NEXT:    mul a1, a1, a2
; RV32I-NEXT:    and a1, a1, a3
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    bltu a0, a3, .LBB2_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB2_2:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a3, 16
; RV64I-NEXT:    addiw a3, a3, -1
; RV64I-NEXT:    and a0, a0, a3
; RV64I-NEXT:    mul a1, a1, a2
; RV64I-NEXT:    and a1, a1, a3
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    bltu a0, a3, .LBB2_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB2_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func16:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    zext.h a0, a0
; RV32IZbb-NEXT:    mul a1, a1, a2
; RV32IZbb-NEXT:    zext.h a1, a1
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    lui a1, 16
; RV32IZbb-NEXT:    addi a1, a1, -1
; RV32IZbb-NEXT:    minu a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func16:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    zext.h a0, a0
; RV64IZbb-NEXT:    mul a1, a1, a2
; RV64IZbb-NEXT:    zext.h a1, a1
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    lui a1, 16
; RV64IZbb-NEXT:    addiw a1, a1, -1
; RV64IZbb-NEXT:    minu a0, a0, a1
; RV64IZbb-NEXT:    ret
  %a = mul i16 %y, %z
  %tmp = call i16 @llvm.uadd.sat.i16(i16 %x, i16 %a)
  ret i16 %tmp
}

define i8 @func8(i8 %x, i8 %y, i8 %z) nounwind {
; RV32I-LABEL: func8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a0, a0, 255
; RV32I-NEXT:    mul a1, a1, a2
; RV32I-NEXT:    andi a1, a1, 255
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    addi a1, zero, 255
; RV32I-NEXT:    bltu a0, a1, .LBB3_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    addi a0, zero, 255
; RV32I-NEXT:  .LBB3_2:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a0, a0, 255
; RV64I-NEXT:    mul a1, a1, a2
; RV64I-NEXT:    andi a1, a1, 255
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    addi a1, zero, 255
; RV64I-NEXT:    bltu a0, a1, .LBB3_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    addi a0, zero, 255
; RV64I-NEXT:  .LBB3_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func8:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    andi a0, a0, 255
; RV32IZbb-NEXT:    mul a1, a1, a2
; RV32IZbb-NEXT:    andi a1, a1, 255
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    addi a1, zero, 255
; RV32IZbb-NEXT:    minu a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func8:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    andi a0, a0, 255
; RV64IZbb-NEXT:    mul a1, a1, a2
; RV64IZbb-NEXT:    andi a1, a1, 255
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    addi a1, zero, 255
; RV64IZbb-NEXT:    minu a0, a0, a1
; RV64IZbb-NEXT:    ret
  %a = mul i8 %y, %z
  %tmp = call i8 @llvm.uadd.sat.i8(i8 %x, i8 %a)
  ret i8 %tmp
}

define i4 @func4(i4 %x, i4 %y, i4 %z) nounwind {
; RV32I-LABEL: func4:
; RV32I:       # %bb.0:
; RV32I-NEXT:    andi a0, a0, 15
; RV32I-NEXT:    mul a1, a1, a2
; RV32I-NEXT:    andi a1, a1, 15
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    addi a1, zero, 15
; RV32I-NEXT:    bltu a0, a1, .LBB4_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    addi a0, zero, 15
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func4:
; RV64I:       # %bb.0:
; RV64I-NEXT:    andi a0, a0, 15
; RV64I-NEXT:    mul a1, a1, a2
; RV64I-NEXT:    andi a1, a1, 15
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    addi a1, zero, 15
; RV64I-NEXT:    bltu a0, a1, .LBB4_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    addi a0, zero, 15
; RV64I-NEXT:  .LBB4_2:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func4:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    andi a0, a0, 15
; RV32IZbb-NEXT:    mul a1, a1, a2
; RV32IZbb-NEXT:    andi a1, a1, 15
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    addi a1, zero, 15
; RV32IZbb-NEXT:    minu a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func4:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    andi a0, a0, 15
; RV64IZbb-NEXT:    mul a1, a1, a2
; RV64IZbb-NEXT:    andi a1, a1, 15
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    addi a1, zero, 15
; RV64IZbb-NEXT:    minu a0, a0, a1
; RV64IZbb-NEXT:    ret
  %a = mul i4 %y, %z
  %tmp = call i4 @llvm.uadd.sat.i4(i4 %x, i4 %a)
  ret i4 %tmp
}
