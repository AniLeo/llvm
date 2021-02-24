; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv32 -mattr=+m | FileCheck %s --check-prefix=RV32I
; RUN: llc < %s -mtriple=riscv64 -mattr=+m | FileCheck %s --check-prefix=RV64I
; RUN: llc < %s -mtriple=riscv32 -mattr=+m,+experimental-zbb | FileCheck %s --check-prefix=RV32IZbb
; RUN: llc < %s -mtriple=riscv64 -mattr=+m,+experimental-zbb | FileCheck %s --check-prefix=RV64IZbb

declare i4 @llvm.sadd.sat.i4(i4, i4)
declare i8 @llvm.sadd.sat.i8(i8, i8)
declare i16 @llvm.sadd.sat.i16(i16, i16)
declare i32 @llvm.sadd.sat.i32(i32, i32)
declare i64 @llvm.sadd.sat.i64(i64, i64)

define signext i32 @func(i32 signext %x, i32 signext %y) nounwind {
; RV32I-LABEL: func:
; RV32I:       # %bb.0:
; RV32I-NEXT:    mv a2, a0
; RV32I-NEXT:    add a3, a0, a1
; RV32I-NEXT:    lui a0, 524288
; RV32I-NEXT:    bgez a3, .LBB0_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    addi a0, a0, -1
; RV32I-NEXT:  .LBB0_2:
; RV32I-NEXT:    slt a2, a3, a2
; RV32I-NEXT:    slti a1, a1, 0
; RV32I-NEXT:    xor a1, a1, a2
; RV32I-NEXT:    bnez a1, .LBB0_4
; RV32I-NEXT:  # %bb.3:
; RV32I-NEXT:    mv a0, a3
; RV32I-NEXT:  .LBB0_4:
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func:
; RV64I:       # %bb.0:
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    addiw a2, a1, -1
; RV64I-NEXT:    bge a0, a2, .LBB0_3
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    bge a1, a0, .LBB0_4
; RV64I-NEXT:  .LBB0_2:
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB0_3:
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    blt a1, a0, .LBB0_2
; RV64I-NEXT:  .LBB0_4:
; RV64I-NEXT:    lui a0, 524288
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    mv a2, a0
; RV32IZbb-NEXT:    add a3, a0, a1
; RV32IZbb-NEXT:    lui a0, 524288
; RV32IZbb-NEXT:    bgez a3, .LBB0_2
; RV32IZbb-NEXT:  # %bb.1:
; RV32IZbb-NEXT:    addi a0, a0, -1
; RV32IZbb-NEXT:  .LBB0_2:
; RV32IZbb-NEXT:    slt a2, a3, a2
; RV32IZbb-NEXT:    slti a1, a1, 0
; RV32IZbb-NEXT:    xor a1, a1, a2
; RV32IZbb-NEXT:    bnez a1, .LBB0_4
; RV32IZbb-NEXT:  # %bb.3:
; RV32IZbb-NEXT:    mv a0, a3
; RV32IZbb-NEXT:  .LBB0_4:
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    lui a1, 524288
; RV64IZbb-NEXT:    addiw a2, a1, -1
; RV64IZbb-NEXT:    min a0, a0, a2
; RV64IZbb-NEXT:    max a0, a0, a1
; RV64IZbb-NEXT:    ret
  %tmp = call i32 @llvm.sadd.sat.i32(i32 %x, i32 %y);
  ret i32 %tmp;
}

define i64 @func2(i64 %x, i64 %y) nounwind {
; RV32I-LABEL: func2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    mv a4, a1
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    add a5, a4, a3
; RV32I-NEXT:    add a0, a0, a2
; RV32I-NEXT:    sltu a1, a0, a1
; RV32I-NEXT:    add a2, a5, a1
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    bgez a2, .LBB1_2
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:  .LBB1_2:
; RV32I-NEXT:    xor a5, a4, a2
; RV32I-NEXT:    xor a3, a4, a3
; RV32I-NEXT:    not a3, a3
; RV32I-NEXT:    and a3, a3, a5
; RV32I-NEXT:    bltz a3, .LBB1_4
; RV32I-NEXT:  # %bb.3:
; RV32I-NEXT:    mv a1, a2
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB1_4:
; RV32I-NEXT:    srai a0, a2, 31
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    mv a2, a0
; RV64I-NEXT:    add a3, a0, a1
; RV64I-NEXT:    addi a0, zero, -1
; RV64I-NEXT:    slli a0, a0, 63
; RV64I-NEXT:    bgez a3, .LBB1_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    addi a0, a0, -1
; RV64I-NEXT:  .LBB1_2:
; RV64I-NEXT:    slt a2, a3, a2
; RV64I-NEXT:    slti a1, a1, 0
; RV64I-NEXT:    xor a1, a1, a2
; RV64I-NEXT:    bnez a1, .LBB1_4
; RV64I-NEXT:  # %bb.3:
; RV64I-NEXT:    mv a0, a3
; RV64I-NEXT:  .LBB1_4:
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func2:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    mv a4, a1
; RV32IZbb-NEXT:    mv a1, a0
; RV32IZbb-NEXT:    add a5, a4, a3
; RV32IZbb-NEXT:    add a0, a0, a2
; RV32IZbb-NEXT:    sltu a1, a0, a1
; RV32IZbb-NEXT:    add a2, a5, a1
; RV32IZbb-NEXT:    lui a1, 524288
; RV32IZbb-NEXT:    bgez a2, .LBB1_2
; RV32IZbb-NEXT:  # %bb.1:
; RV32IZbb-NEXT:    addi a1, a1, -1
; RV32IZbb-NEXT:  .LBB1_2:
; RV32IZbb-NEXT:    xor a5, a4, a2
; RV32IZbb-NEXT:    xor a3, a4, a3
; RV32IZbb-NEXT:    andn a3, a5, a3
; RV32IZbb-NEXT:    bltz a3, .LBB1_4
; RV32IZbb-NEXT:  # %bb.3:
; RV32IZbb-NEXT:    mv a1, a2
; RV32IZbb-NEXT:    ret
; RV32IZbb-NEXT:  .LBB1_4:
; RV32IZbb-NEXT:    srai a0, a2, 31
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func2:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    mv a2, a0
; RV64IZbb-NEXT:    add a3, a0, a1
; RV64IZbb-NEXT:    addi a0, zero, -1
; RV64IZbb-NEXT:    slli a0, a0, 63
; RV64IZbb-NEXT:    bgez a3, .LBB1_2
; RV64IZbb-NEXT:  # %bb.1:
; RV64IZbb-NEXT:    addi a0, a0, -1
; RV64IZbb-NEXT:  .LBB1_2:
; RV64IZbb-NEXT:    slt a2, a3, a2
; RV64IZbb-NEXT:    slti a1, a1, 0
; RV64IZbb-NEXT:    xor a1, a1, a2
; RV64IZbb-NEXT:    bnez a1, .LBB1_4
; RV64IZbb-NEXT:  # %bb.3:
; RV64IZbb-NEXT:    mv a0, a3
; RV64IZbb-NEXT:  .LBB1_4:
; RV64IZbb-NEXT:    ret
  %tmp = call i64 @llvm.sadd.sat.i64(i64 %x, i64 %y);
  ret i64 %tmp;
}

define signext i16 @func16(i16 signext %x, i16 signext %y) nounwind {
; RV32I-LABEL: func16:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    lui a1, 8
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    bge a0, a1, .LBB2_3
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    lui a1, 1048568
; RV32I-NEXT:    bge a1, a0, .LBB2_4
; RV32I-NEXT:  .LBB2_2:
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB2_3:
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    lui a1, 1048568
; RV32I-NEXT:    blt a1, a0, .LBB2_2
; RV32I-NEXT:  .LBB2_4:
; RV32I-NEXT:    lui a0, 1048568
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func16:
; RV64I:       # %bb.0:
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 8
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    bge a0, a1, .LBB2_3
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    lui a1, 1048568
; RV64I-NEXT:    bge a1, a0, .LBB2_4
; RV64I-NEXT:  .LBB2_2:
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB2_3:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    lui a1, 1048568
; RV64I-NEXT:    blt a1, a0, .LBB2_2
; RV64I-NEXT:  .LBB2_4:
; RV64I-NEXT:    lui a0, 1048568
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func16:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    lui a1, 8
; RV32IZbb-NEXT:    addi a1, a1, -1
; RV32IZbb-NEXT:    min a0, a0, a1
; RV32IZbb-NEXT:    lui a1, 1048568
; RV32IZbb-NEXT:    max a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func16:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    lui a1, 8
; RV64IZbb-NEXT:    addiw a1, a1, -1
; RV64IZbb-NEXT:    min a0, a0, a1
; RV64IZbb-NEXT:    lui a1, 1048568
; RV64IZbb-NEXT:    max a0, a0, a1
; RV64IZbb-NEXT:    ret
  %tmp = call i16 @llvm.sadd.sat.i16(i16 %x, i16 %y);
  ret i16 %tmp;
}

define signext i8 @func8(i8 signext %x, i8 signext %y) nounwind {
; RV32I-LABEL: func8:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    addi a1, zero, 127
; RV32I-NEXT:    bge a0, a1, .LBB3_3
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    addi a1, zero, -128
; RV32I-NEXT:    bge a1, a0, .LBB3_4
; RV32I-NEXT:  .LBB3_2:
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB3_3:
; RV32I-NEXT:    addi a0, zero, 127
; RV32I-NEXT:    addi a1, zero, -128
; RV32I-NEXT:    blt a1, a0, .LBB3_2
; RV32I-NEXT:  .LBB3_4:
; RV32I-NEXT:    addi a0, zero, -128
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func8:
; RV64I:       # %bb.0:
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    addi a1, zero, 127
; RV64I-NEXT:    bge a0, a1, .LBB3_3
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    addi a1, zero, -128
; RV64I-NEXT:    bge a1, a0, .LBB3_4
; RV64I-NEXT:  .LBB3_2:
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB3_3:
; RV64I-NEXT:    addi a0, zero, 127
; RV64I-NEXT:    addi a1, zero, -128
; RV64I-NEXT:    blt a1, a0, .LBB3_2
; RV64I-NEXT:  .LBB3_4:
; RV64I-NEXT:    addi a0, zero, -128
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func8:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    addi a1, zero, 127
; RV32IZbb-NEXT:    min a0, a0, a1
; RV32IZbb-NEXT:    addi a1, zero, -128
; RV32IZbb-NEXT:    max a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func8:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    addi a1, zero, 127
; RV64IZbb-NEXT:    min a0, a0, a1
; RV64IZbb-NEXT:    addi a1, zero, -128
; RV64IZbb-NEXT:    max a0, a0, a1
; RV64IZbb-NEXT:    ret
  %tmp = call i8 @llvm.sadd.sat.i8(i8 %x, i8 %y);
  ret i8 %tmp;
}

define signext i4 @func3(i4 signext %x, i4 signext %y) nounwind {
; RV32I-LABEL: func3:
; RV32I:       # %bb.0:
; RV32I-NEXT:    add a0, a0, a1
; RV32I-NEXT:    addi a1, zero, 7
; RV32I-NEXT:    bge a0, a1, .LBB4_3
; RV32I-NEXT:  # %bb.1:
; RV32I-NEXT:    addi a1, zero, -8
; RV32I-NEXT:    bge a1, a0, .LBB4_4
; RV32I-NEXT:  .LBB4_2:
; RV32I-NEXT:    ret
; RV32I-NEXT:  .LBB4_3:
; RV32I-NEXT:    addi a0, zero, 7
; RV32I-NEXT:    addi a1, zero, -8
; RV32I-NEXT:    blt a1, a0, .LBB4_2
; RV32I-NEXT:  .LBB4_4:
; RV32I-NEXT:    addi a0, zero, -8
; RV32I-NEXT:    ret
;
; RV64I-LABEL: func3:
; RV64I:       # %bb.0:
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    addi a1, zero, 7
; RV64I-NEXT:    bge a0, a1, .LBB4_3
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    addi a1, zero, -8
; RV64I-NEXT:    bge a1, a0, .LBB4_4
; RV64I-NEXT:  .LBB4_2:
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB4_3:
; RV64I-NEXT:    addi a0, zero, 7
; RV64I-NEXT:    addi a1, zero, -8
; RV64I-NEXT:    blt a1, a0, .LBB4_2
; RV64I-NEXT:  .LBB4_4:
; RV64I-NEXT:    addi a0, zero, -8
; RV64I-NEXT:    ret
;
; RV32IZbb-LABEL: func3:
; RV32IZbb:       # %bb.0:
; RV32IZbb-NEXT:    add a0, a0, a1
; RV32IZbb-NEXT:    addi a1, zero, 7
; RV32IZbb-NEXT:    min a0, a0, a1
; RV32IZbb-NEXT:    addi a1, zero, -8
; RV32IZbb-NEXT:    max a0, a0, a1
; RV32IZbb-NEXT:    ret
;
; RV64IZbb-LABEL: func3:
; RV64IZbb:       # %bb.0:
; RV64IZbb-NEXT:    add a0, a0, a1
; RV64IZbb-NEXT:    addi a1, zero, 7
; RV64IZbb-NEXT:    min a0, a0, a1
; RV64IZbb-NEXT:    addi a1, zero, -8
; RV64IZbb-NEXT:    max a0, a0, a1
; RV64IZbb-NEXT:    ret
  %tmp = call i4 @llvm.sadd.sat.i4(i4 %x, i4 %y);
  ret i4 %tmp;
}
