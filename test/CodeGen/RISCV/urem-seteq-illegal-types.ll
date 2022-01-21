; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 < %s | FileCheck %s --check-prefixes=RV32
; RUN: llc -mtriple=riscv64 < %s | FileCheck %s --check-prefixes=RV64
; RUN: llc -mtriple=riscv32 -mattr=+m < %s | FileCheck %s --check-prefixes=RV32M
; RUN: llc -mtriple=riscv64 -mattr=+m < %s | FileCheck %s --check-prefixes=RV64M
; RUN: llc -mtriple=riscv32 -mattr=+m,+v -riscv-v-vector-bits-min=128 < %s | FileCheck %s --check-prefixes=RV32MV
; RUN: llc -mtriple=riscv64 -mattr=+m,+v -riscv-v-vector-bits-min=128 < %s | FileCheck %s --check-prefixes=RV64MV

define i1 @test_urem_odd(i13 %X) nounwind {
; RV32-LABEL: test_urem_odd:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    lui a1, 1
; RV32-NEXT:    addi a1, a1, -819
; RV32-NEXT:    call __mulsi3@plt
; RV32-NEXT:    slli a0, a0, 19
; RV32-NEXT:    srli a0, a0, 19
; RV32-NEXT:    sltiu a0, a0, 1639
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: test_urem_odd:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    lui a1, 1
; RV64-NEXT:    addiw a1, a1, -819
; RV64-NEXT:    call __muldi3@plt
; RV64-NEXT:    slli a0, a0, 51
; RV64-NEXT:    srli a0, a0, 51
; RV64-NEXT:    sltiu a0, a0, 1639
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
;
; RV32M-LABEL: test_urem_odd:
; RV32M:       # %bb.0:
; RV32M-NEXT:    lui a1, 1
; RV32M-NEXT:    addi a1, a1, -819
; RV32M-NEXT:    mul a0, a0, a1
; RV32M-NEXT:    slli a0, a0, 19
; RV32M-NEXT:    srli a0, a0, 19
; RV32M-NEXT:    sltiu a0, a0, 1639
; RV32M-NEXT:    ret
;
; RV64M-LABEL: test_urem_odd:
; RV64M:       # %bb.0:
; RV64M-NEXT:    lui a1, 1
; RV64M-NEXT:    addiw a1, a1, -819
; RV64M-NEXT:    mulw a0, a0, a1
; RV64M-NEXT:    slli a0, a0, 51
; RV64M-NEXT:    srli a0, a0, 51
; RV64M-NEXT:    sltiu a0, a0, 1639
; RV64M-NEXT:    ret
;
; RV32MV-LABEL: test_urem_odd:
; RV32MV:       # %bb.0:
; RV32MV-NEXT:    lui a1, 1
; RV32MV-NEXT:    addi a1, a1, -819
; RV32MV-NEXT:    mul a0, a0, a1
; RV32MV-NEXT:    slli a0, a0, 19
; RV32MV-NEXT:    srli a0, a0, 19
; RV32MV-NEXT:    sltiu a0, a0, 1639
; RV32MV-NEXT:    ret
;
; RV64MV-LABEL: test_urem_odd:
; RV64MV:       # %bb.0:
; RV64MV-NEXT:    lui a1, 1
; RV64MV-NEXT:    addiw a1, a1, -819
; RV64MV-NEXT:    mulw a0, a0, a1
; RV64MV-NEXT:    slli a0, a0, 51
; RV64MV-NEXT:    srli a0, a0, 51
; RV64MV-NEXT:    sltiu a0, a0, 1639
; RV64MV-NEXT:    ret
  %urem = urem i13 %X, 5
  %cmp = icmp eq i13 %urem, 0
  ret i1 %cmp
}

define i1 @test_urem_even(i27 %X) nounwind {
; RV32-LABEL: test_urem_even:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    lui a1, 28087
; RV32-NEXT:    addi a1, a1, -585
; RV32-NEXT:    call __mulsi3@plt
; RV32-NEXT:    slli a1, a0, 26
; RV32-NEXT:    slli a0, a0, 5
; RV32-NEXT:    srli a0, a0, 6
; RV32-NEXT:    or a0, a0, a1
; RV32-NEXT:    slli a0, a0, 5
; RV32-NEXT:    srli a0, a0, 5
; RV32-NEXT:    lui a1, 2341
; RV32-NEXT:    addi a1, a1, -1755
; RV32-NEXT:    sltu a0, a0, a1
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: test_urem_even:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    lui a1, 28087
; RV64-NEXT:    addiw a1, a1, -585
; RV64-NEXT:    call __muldi3@plt
; RV64-NEXT:    slli a1, a0, 26
; RV64-NEXT:    slli a0, a0, 37
; RV64-NEXT:    srli a0, a0, 38
; RV64-NEXT:    or a0, a0, a1
; RV64-NEXT:    slli a0, a0, 37
; RV64-NEXT:    srli a0, a0, 37
; RV64-NEXT:    lui a1, 2341
; RV64-NEXT:    addiw a1, a1, -1755
; RV64-NEXT:    sltu a0, a0, a1
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
;
; RV32M-LABEL: test_urem_even:
; RV32M:       # %bb.0:
; RV32M-NEXT:    lui a1, 28087
; RV32M-NEXT:    addi a1, a1, -585
; RV32M-NEXT:    mul a0, a0, a1
; RV32M-NEXT:    slli a1, a0, 26
; RV32M-NEXT:    slli a0, a0, 5
; RV32M-NEXT:    srli a0, a0, 6
; RV32M-NEXT:    or a0, a0, a1
; RV32M-NEXT:    slli a0, a0, 5
; RV32M-NEXT:    srli a0, a0, 5
; RV32M-NEXT:    lui a1, 2341
; RV32M-NEXT:    addi a1, a1, -1755
; RV32M-NEXT:    sltu a0, a0, a1
; RV32M-NEXT:    ret
;
; RV64M-LABEL: test_urem_even:
; RV64M:       # %bb.0:
; RV64M-NEXT:    lui a1, 28087
; RV64M-NEXT:    addiw a1, a1, -585
; RV64M-NEXT:    mul a0, a0, a1
; RV64M-NEXT:    slli a1, a0, 26
; RV64M-NEXT:    slli a0, a0, 37
; RV64M-NEXT:    srli a0, a0, 38
; RV64M-NEXT:    or a0, a0, a1
; RV64M-NEXT:    slli a0, a0, 37
; RV64M-NEXT:    srli a0, a0, 37
; RV64M-NEXT:    lui a1, 2341
; RV64M-NEXT:    addiw a1, a1, -1755
; RV64M-NEXT:    sltu a0, a0, a1
; RV64M-NEXT:    ret
;
; RV32MV-LABEL: test_urem_even:
; RV32MV:       # %bb.0:
; RV32MV-NEXT:    lui a1, 28087
; RV32MV-NEXT:    addi a1, a1, -585
; RV32MV-NEXT:    mul a0, a0, a1
; RV32MV-NEXT:    slli a1, a0, 26
; RV32MV-NEXT:    slli a0, a0, 5
; RV32MV-NEXT:    srli a0, a0, 6
; RV32MV-NEXT:    or a0, a0, a1
; RV32MV-NEXT:    slli a0, a0, 5
; RV32MV-NEXT:    srli a0, a0, 5
; RV32MV-NEXT:    lui a1, 2341
; RV32MV-NEXT:    addi a1, a1, -1755
; RV32MV-NEXT:    sltu a0, a0, a1
; RV32MV-NEXT:    ret
;
; RV64MV-LABEL: test_urem_even:
; RV64MV:       # %bb.0:
; RV64MV-NEXT:    lui a1, 28087
; RV64MV-NEXT:    addiw a1, a1, -585
; RV64MV-NEXT:    mul a0, a0, a1
; RV64MV-NEXT:    slli a1, a0, 26
; RV64MV-NEXT:    slli a0, a0, 37
; RV64MV-NEXT:    srli a0, a0, 38
; RV64MV-NEXT:    or a0, a0, a1
; RV64MV-NEXT:    slli a0, a0, 37
; RV64MV-NEXT:    srli a0, a0, 37
; RV64MV-NEXT:    lui a1, 2341
; RV64MV-NEXT:    addiw a1, a1, -1755
; RV64MV-NEXT:    sltu a0, a0, a1
; RV64MV-NEXT:    ret
  %urem = urem i27 %X, 14
  %cmp = icmp eq i27 %urem, 0
  ret i1 %cmp
}

define i1 @test_urem_odd_setne(i4 %X) nounwind {
; RV32-LABEL: test_urem_odd_setne:
; RV32:       # %bb.0:
; RV32-NEXT:    slli a1, a0, 1
; RV32-NEXT:    add a0, a1, a0
; RV32-NEXT:    neg a0, a0
; RV32-NEXT:    andi a0, a0, 15
; RV32-NEXT:    li a1, 3
; RV32-NEXT:    sltu a0, a1, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: test_urem_odd_setne:
; RV64:       # %bb.0:
; RV64-NEXT:    slliw a1, a0, 1
; RV64-NEXT:    addw a0, a1, a0
; RV64-NEXT:    negw a0, a0
; RV64-NEXT:    andi a0, a0, 15
; RV64-NEXT:    li a1, 3
; RV64-NEXT:    sltu a0, a1, a0
; RV64-NEXT:    ret
;
; RV32M-LABEL: test_urem_odd_setne:
; RV32M:       # %bb.0:
; RV32M-NEXT:    slli a1, a0, 1
; RV32M-NEXT:    add a0, a1, a0
; RV32M-NEXT:    neg a0, a0
; RV32M-NEXT:    andi a0, a0, 15
; RV32M-NEXT:    li a1, 3
; RV32M-NEXT:    sltu a0, a1, a0
; RV32M-NEXT:    ret
;
; RV64M-LABEL: test_urem_odd_setne:
; RV64M:       # %bb.0:
; RV64M-NEXT:    slliw a1, a0, 1
; RV64M-NEXT:    addw a0, a1, a0
; RV64M-NEXT:    negw a0, a0
; RV64M-NEXT:    andi a0, a0, 15
; RV64M-NEXT:    li a1, 3
; RV64M-NEXT:    sltu a0, a1, a0
; RV64M-NEXT:    ret
;
; RV32MV-LABEL: test_urem_odd_setne:
; RV32MV:       # %bb.0:
; RV32MV-NEXT:    slli a1, a0, 1
; RV32MV-NEXT:    add a0, a1, a0
; RV32MV-NEXT:    neg a0, a0
; RV32MV-NEXT:    andi a0, a0, 15
; RV32MV-NEXT:    li a1, 3
; RV32MV-NEXT:    sltu a0, a1, a0
; RV32MV-NEXT:    ret
;
; RV64MV-LABEL: test_urem_odd_setne:
; RV64MV:       # %bb.0:
; RV64MV-NEXT:    slliw a1, a0, 1
; RV64MV-NEXT:    addw a0, a1, a0
; RV64MV-NEXT:    negw a0, a0
; RV64MV-NEXT:    andi a0, a0, 15
; RV64MV-NEXT:    li a1, 3
; RV64MV-NEXT:    sltu a0, a1, a0
; RV64MV-NEXT:    ret
  %urem = urem i4 %X, 5
  %cmp = icmp ne i4 %urem, 0
  ret i1 %cmp
}

define i1 @test_urem_negative_odd(i9 %X) nounwind {
; RV32-LABEL: test_urem_negative_odd:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    li a1, 307
; RV32-NEXT:    call __mulsi3@plt
; RV32-NEXT:    andi a0, a0, 511
; RV32-NEXT:    li a1, 1
; RV32-NEXT:    sltu a0, a1, a0
; RV32-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: test_urem_negative_odd:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -16
; RV64-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    li a1, 307
; RV64-NEXT:    call __muldi3@plt
; RV64-NEXT:    andi a0, a0, 511
; RV64-NEXT:    li a1, 1
; RV64-NEXT:    sltu a0, a1, a0
; RV64-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 16
; RV64-NEXT:    ret
;
; RV32M-LABEL: test_urem_negative_odd:
; RV32M:       # %bb.0:
; RV32M-NEXT:    li a1, 307
; RV32M-NEXT:    mul a0, a0, a1
; RV32M-NEXT:    andi a0, a0, 511
; RV32M-NEXT:    li a1, 1
; RV32M-NEXT:    sltu a0, a1, a0
; RV32M-NEXT:    ret
;
; RV64M-LABEL: test_urem_negative_odd:
; RV64M:       # %bb.0:
; RV64M-NEXT:    li a1, 307
; RV64M-NEXT:    mulw a0, a0, a1
; RV64M-NEXT:    andi a0, a0, 511
; RV64M-NEXT:    li a1, 1
; RV64M-NEXT:    sltu a0, a1, a0
; RV64M-NEXT:    ret
;
; RV32MV-LABEL: test_urem_negative_odd:
; RV32MV:       # %bb.0:
; RV32MV-NEXT:    li a1, 307
; RV32MV-NEXT:    mul a0, a0, a1
; RV32MV-NEXT:    andi a0, a0, 511
; RV32MV-NEXT:    li a1, 1
; RV32MV-NEXT:    sltu a0, a1, a0
; RV32MV-NEXT:    ret
;
; RV64MV-LABEL: test_urem_negative_odd:
; RV64MV:       # %bb.0:
; RV64MV-NEXT:    li a1, 307
; RV64MV-NEXT:    mulw a0, a0, a1
; RV64MV-NEXT:    andi a0, a0, 511
; RV64MV-NEXT:    li a1, 1
; RV64MV-NEXT:    sltu a0, a1, a0
; RV64MV-NEXT:    ret
  %urem = urem i9 %X, -5
  %cmp = icmp ne i9 %urem, 0
  ret i1 %cmp
}

define void @test_urem_vec(<3 x i11>* %X) nounwind {
; RV32-LABEL: test_urem_vec:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -32
; RV32-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s0, 24(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s1, 20(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s2, 16(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s3, 12(sp) # 4-byte Folded Spill
; RV32-NEXT:    mv s0, a0
; RV32-NEXT:    lb a0, 4(a0)
; RV32-NEXT:    lw a1, 0(s0)
; RV32-NEXT:    slli a0, a0, 10
; RV32-NEXT:    srli a2, a1, 22
; RV32-NEXT:    or s1, a2, a0
; RV32-NEXT:    srli s2, a1, 11
; RV32-NEXT:    andi a0, a1, 2047
; RV32-NEXT:    li a1, 683
; RV32-NEXT:    call __mulsi3@plt
; RV32-NEXT:    slli a1, a0, 10
; RV32-NEXT:    slli a0, a0, 21
; RV32-NEXT:    srli a0, a0, 22
; RV32-NEXT:    or a0, a0, a1
; RV32-NEXT:    andi a0, a0, 2047
; RV32-NEXT:    li a1, 341
; RV32-NEXT:    sltu s3, a1, a0
; RV32-NEXT:    li a1, 819
; RV32-NEXT:    mv a0, s1
; RV32-NEXT:    call __mulsi3@plt
; RV32-NEXT:    addi a0, a0, -1638
; RV32-NEXT:    andi a0, a0, 2047
; RV32-NEXT:    li a1, 1
; RV32-NEXT:    sltu s1, a1, a0
; RV32-NEXT:    li a1, 1463
; RV32-NEXT:    mv a0, s2
; RV32-NEXT:    call __mulsi3@plt
; RV32-NEXT:    addi a0, a0, -1463
; RV32-NEXT:    andi a0, a0, 2047
; RV32-NEXT:    li a1, 292
; RV32-NEXT:    sltu a0, a1, a0
; RV32-NEXT:    neg a1, s3
; RV32-NEXT:    neg a0, a0
; RV32-NEXT:    neg a2, s1
; RV32-NEXT:    srli a2, a2, 10
; RV32-NEXT:    andi a2, a2, 1
; RV32-NEXT:    sb a2, 4(s0)
; RV32-NEXT:    andi a1, a1, 2047
; RV32-NEXT:    andi a0, a0, 2047
; RV32-NEXT:    slli a0, a0, 11
; RV32-NEXT:    or a0, a1, a0
; RV32-NEXT:    slli a1, s1, 22
; RV32-NEXT:    sub a0, a0, a1
; RV32-NEXT:    sw a0, 0(s0)
; RV32-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw s0, 24(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw s1, 20(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw s2, 16(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw s3, 12(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 32
; RV32-NEXT:    ret
;
; RV64-LABEL: test_urem_vec:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -48
; RV64-NEXT:    sd ra, 40(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s0, 32(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s1, 24(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s2, 16(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s3, 8(sp) # 8-byte Folded Spill
; RV64-NEXT:    mv s0, a0
; RV64-NEXT:    lbu a0, 4(a0)
; RV64-NEXT:    lwu a1, 0(s0)
; RV64-NEXT:    slli a0, a0, 32
; RV64-NEXT:    or a0, a1, a0
; RV64-NEXT:    srli s1, a0, 11
; RV64-NEXT:    srli s2, a0, 22
; RV64-NEXT:    andi a0, a0, 2047
; RV64-NEXT:    li a1, 683
; RV64-NEXT:    call __muldi3@plt
; RV64-NEXT:    slli a1, a0, 10
; RV64-NEXT:    slli a0, a0, 53
; RV64-NEXT:    srli a0, a0, 54
; RV64-NEXT:    or a0, a0, a1
; RV64-NEXT:    andi a0, a0, 2047
; RV64-NEXT:    li a1, 341
; RV64-NEXT:    sltu s3, a1, a0
; RV64-NEXT:    li a1, 819
; RV64-NEXT:    mv a0, s2
; RV64-NEXT:    call __muldi3@plt
; RV64-NEXT:    addiw a0, a0, -1638
; RV64-NEXT:    andi a0, a0, 2047
; RV64-NEXT:    li a1, 1
; RV64-NEXT:    sltu s2, a1, a0
; RV64-NEXT:    li a1, 1463
; RV64-NEXT:    mv a0, s1
; RV64-NEXT:    call __muldi3@plt
; RV64-NEXT:    addiw a0, a0, -1463
; RV64-NEXT:    andi a0, a0, 2047
; RV64-NEXT:    li a1, 292
; RV64-NEXT:    sltu a0, a1, a0
; RV64-NEXT:    negw a1, s3
; RV64-NEXT:    negw a0, a0
; RV64-NEXT:    andi a1, a1, 2047
; RV64-NEXT:    andi a0, a0, 2047
; RV64-NEXT:    slli a0, a0, 11
; RV64-NEXT:    or a0, a1, a0
; RV64-NEXT:    slli a1, s2, 22
; RV64-NEXT:    sub a0, a0, a1
; RV64-NEXT:    sw a0, 0(s0)
; RV64-NEXT:    slli a0, a0, 31
; RV64-NEXT:    srli a0, a0, 63
; RV64-NEXT:    sb a0, 4(s0)
; RV64-NEXT:    ld ra, 40(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld s0, 32(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld s1, 24(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld s2, 16(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld s3, 8(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 48
; RV64-NEXT:    ret
;
; RV32M-LABEL: test_urem_vec:
; RV32M:       # %bb.0:
; RV32M-NEXT:    lb a1, 4(a0)
; RV32M-NEXT:    lw a2, 0(a0)
; RV32M-NEXT:    slli a1, a1, 10
; RV32M-NEXT:    srli a3, a2, 22
; RV32M-NEXT:    or a1, a3, a1
; RV32M-NEXT:    srli a3, a2, 11
; RV32M-NEXT:    andi a2, a2, 2047
; RV32M-NEXT:    li a4, 683
; RV32M-NEXT:    mul a2, a2, a4
; RV32M-NEXT:    slli a4, a2, 10
; RV32M-NEXT:    slli a2, a2, 21
; RV32M-NEXT:    srli a2, a2, 22
; RV32M-NEXT:    or a2, a2, a4
; RV32M-NEXT:    andi a2, a2, 2047
; RV32M-NEXT:    li a4, 341
; RV32M-NEXT:    sltu a2, a4, a2
; RV32M-NEXT:    li a4, 819
; RV32M-NEXT:    mul a1, a1, a4
; RV32M-NEXT:    addi a1, a1, -1638
; RV32M-NEXT:    andi a1, a1, 2047
; RV32M-NEXT:    li a4, 1
; RV32M-NEXT:    sltu a1, a4, a1
; RV32M-NEXT:    li a4, 1463
; RV32M-NEXT:    mul a3, a3, a4
; RV32M-NEXT:    addi a3, a3, -1463
; RV32M-NEXT:    andi a3, a3, 2047
; RV32M-NEXT:    li a4, 292
; RV32M-NEXT:    sltu a3, a4, a3
; RV32M-NEXT:    neg a2, a2
; RV32M-NEXT:    neg a3, a3
; RV32M-NEXT:    neg a4, a1
; RV32M-NEXT:    srli a4, a4, 10
; RV32M-NEXT:    andi a4, a4, 1
; RV32M-NEXT:    sb a4, 4(a0)
; RV32M-NEXT:    andi a2, a2, 2047
; RV32M-NEXT:    andi a3, a3, 2047
; RV32M-NEXT:    slli a3, a3, 11
; RV32M-NEXT:    or a2, a2, a3
; RV32M-NEXT:    slli a1, a1, 22
; RV32M-NEXT:    sub a1, a2, a1
; RV32M-NEXT:    sw a1, 0(a0)
; RV32M-NEXT:    ret
;
; RV64M-LABEL: test_urem_vec:
; RV64M:       # %bb.0:
; RV64M-NEXT:    lbu a1, 4(a0)
; RV64M-NEXT:    lwu a2, 0(a0)
; RV64M-NEXT:    slli a1, a1, 32
; RV64M-NEXT:    or a1, a2, a1
; RV64M-NEXT:    srli a2, a1, 11
; RV64M-NEXT:    srli a3, a1, 22
; RV64M-NEXT:    andi a1, a1, 2047
; RV64M-NEXT:    li a4, 683
; RV64M-NEXT:    mul a1, a1, a4
; RV64M-NEXT:    slli a4, a1, 10
; RV64M-NEXT:    slli a1, a1, 53
; RV64M-NEXT:    srli a1, a1, 54
; RV64M-NEXT:    or a1, a1, a4
; RV64M-NEXT:    andi a1, a1, 2047
; RV64M-NEXT:    li a4, 341
; RV64M-NEXT:    sltu a1, a4, a1
; RV64M-NEXT:    li a4, 819
; RV64M-NEXT:    mulw a3, a3, a4
; RV64M-NEXT:    addiw a3, a3, -1638
; RV64M-NEXT:    andi a3, a3, 2047
; RV64M-NEXT:    li a4, 1
; RV64M-NEXT:    sltu a3, a4, a3
; RV64M-NEXT:    li a4, 1463
; RV64M-NEXT:    mulw a2, a2, a4
; RV64M-NEXT:    addiw a2, a2, -1463
; RV64M-NEXT:    andi a2, a2, 2047
; RV64M-NEXT:    li a4, 292
; RV64M-NEXT:    sltu a2, a4, a2
; RV64M-NEXT:    negw a1, a1
; RV64M-NEXT:    negw a2, a2
; RV64M-NEXT:    andi a1, a1, 2047
; RV64M-NEXT:    andi a2, a2, 2047
; RV64M-NEXT:    slli a2, a2, 11
; RV64M-NEXT:    or a1, a1, a2
; RV64M-NEXT:    slli a2, a3, 22
; RV64M-NEXT:    sub a1, a1, a2
; RV64M-NEXT:    sw a1, 0(a0)
; RV64M-NEXT:    slli a1, a1, 31
; RV64M-NEXT:    srli a1, a1, 63
; RV64M-NEXT:    sb a1, 4(a0)
; RV64M-NEXT:    ret
;
; RV32MV-LABEL: test_urem_vec:
; RV32MV:       # %bb.0:
; RV32MV-NEXT:    addi sp, sp, -16
; RV32MV-NEXT:    lw a1, 0(a0)
; RV32MV-NEXT:    andi a2, a1, 2047
; RV32MV-NEXT:    sh a2, 8(sp)
; RV32MV-NEXT:    srli a2, a1, 11
; RV32MV-NEXT:    andi a2, a2, 2047
; RV32MV-NEXT:    sh a2, 10(sp)
; RV32MV-NEXT:    lb a2, 4(a0)
; RV32MV-NEXT:    slli a2, a2, 10
; RV32MV-NEXT:    srli a1, a1, 22
; RV32MV-NEXT:    or a1, a1, a2
; RV32MV-NEXT:    andi a1, a1, 2047
; RV32MV-NEXT:    sh a1, 12(sp)
; RV32MV-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; RV32MV-NEXT:    addi a1, sp, 8
; RV32MV-NEXT:    vle16.v v8, (a1)
; RV32MV-NEXT:    vmv.v.i v9, 10
; RV32MV-NEXT:    li a1, 9
; RV32MV-NEXT:    vsetvli zero, zero, e16, mf2, tu, mu
; RV32MV-NEXT:    vmv.s.x v9, a1
; RV32MV-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; RV32MV-NEXT:    lui a1, %hi(.LCPI4_0)
; RV32MV-NEXT:    addi a1, a1, %lo(.LCPI4_0)
; RV32MV-NEXT:    vle16.v v10, (a1)
; RV32MV-NEXT:    vid.v v11
; RV32MV-NEXT:    vsub.vv v8, v8, v11
; RV32MV-NEXT:    vmul.vv v8, v8, v10
; RV32MV-NEXT:    vadd.vv v10, v8, v8
; RV32MV-NEXT:    vsll.vv v9, v10, v9
; RV32MV-NEXT:    vmv.v.i v10, 0
; RV32MV-NEXT:    li a1, 1
; RV32MV-NEXT:    vsetvli zero, zero, e16, mf2, tu, mu
; RV32MV-NEXT:    vmv1r.v v11, v10
; RV32MV-NEXT:    vmv.s.x v11, a1
; RV32MV-NEXT:    li a1, 2047
; RV32MV-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; RV32MV-NEXT:    vand.vx v8, v8, a1
; RV32MV-NEXT:    lui a2, %hi(.LCPI4_1)
; RV32MV-NEXT:    addi a2, a2, %lo(.LCPI4_1)
; RV32MV-NEXT:    vle16.v v12, (a2)
; RV32MV-NEXT:    vsrl.vv v8, v8, v11
; RV32MV-NEXT:    vor.vv v8, v8, v9
; RV32MV-NEXT:    vand.vx v8, v8, a1
; RV32MV-NEXT:    vmsltu.vv v0, v12, v8
; RV32MV-NEXT:    vmerge.vim v8, v10, -1, v0
; RV32MV-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; RV32MV-NEXT:    vslidedown.vi v9, v8, 2
; RV32MV-NEXT:    vmv.x.s a1, v9
; RV32MV-NEXT:    srli a2, a1, 10
; RV32MV-NEXT:    andi a2, a2, 1
; RV32MV-NEXT:    sb a2, 4(a0)
; RV32MV-NEXT:    vmv.x.s a2, v8
; RV32MV-NEXT:    andi a2, a2, 2047
; RV32MV-NEXT:    vslidedown.vi v8, v8, 1
; RV32MV-NEXT:    vmv.x.s a3, v8
; RV32MV-NEXT:    andi a3, a3, 2047
; RV32MV-NEXT:    slli a3, a3, 11
; RV32MV-NEXT:    or a2, a2, a3
; RV32MV-NEXT:    slli a1, a1, 22
; RV32MV-NEXT:    or a1, a2, a1
; RV32MV-NEXT:    sw a1, 0(a0)
; RV32MV-NEXT:    addi sp, sp, 16
; RV32MV-NEXT:    ret
;
; RV64MV-LABEL: test_urem_vec:
; RV64MV:       # %bb.0:
; RV64MV-NEXT:    addi sp, sp, -16
; RV64MV-NEXT:    lbu a1, 4(a0)
; RV64MV-NEXT:    lwu a2, 0(a0)
; RV64MV-NEXT:    slli a1, a1, 32
; RV64MV-NEXT:    or a1, a2, a1
; RV64MV-NEXT:    srli a2, a1, 22
; RV64MV-NEXT:    sh a2, 12(sp)
; RV64MV-NEXT:    andi a2, a1, 2047
; RV64MV-NEXT:    sh a2, 8(sp)
; RV64MV-NEXT:    srli a1, a1, 11
; RV64MV-NEXT:    andi a1, a1, 2047
; RV64MV-NEXT:    sh a1, 10(sp)
; RV64MV-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; RV64MV-NEXT:    addi a1, sp, 8
; RV64MV-NEXT:    vle16.v v8, (a1)
; RV64MV-NEXT:    vmv.v.i v9, 10
; RV64MV-NEXT:    li a1, 9
; RV64MV-NEXT:    vsetvli zero, zero, e16, mf2, tu, mu
; RV64MV-NEXT:    vmv.s.x v9, a1
; RV64MV-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; RV64MV-NEXT:    lui a1, %hi(.LCPI4_0)
; RV64MV-NEXT:    addi a1, a1, %lo(.LCPI4_0)
; RV64MV-NEXT:    vle16.v v10, (a1)
; RV64MV-NEXT:    vid.v v11
; RV64MV-NEXT:    vsub.vv v8, v8, v11
; RV64MV-NEXT:    vmul.vv v8, v8, v10
; RV64MV-NEXT:    vadd.vv v10, v8, v8
; RV64MV-NEXT:    vsll.vv v9, v10, v9
; RV64MV-NEXT:    vmv.v.i v10, 0
; RV64MV-NEXT:    li a1, 1
; RV64MV-NEXT:    vsetvli zero, zero, e16, mf2, tu, mu
; RV64MV-NEXT:    vmv1r.v v11, v10
; RV64MV-NEXT:    vmv.s.x v11, a1
; RV64MV-NEXT:    li a1, 2047
; RV64MV-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; RV64MV-NEXT:    vand.vx v8, v8, a1
; RV64MV-NEXT:    lui a2, %hi(.LCPI4_1)
; RV64MV-NEXT:    addi a2, a2, %lo(.LCPI4_1)
; RV64MV-NEXT:    vle16.v v12, (a2)
; RV64MV-NEXT:    vsrl.vv v8, v8, v11
; RV64MV-NEXT:    vor.vv v8, v8, v9
; RV64MV-NEXT:    vand.vx v8, v8, a1
; RV64MV-NEXT:    vmsltu.vv v0, v12, v8
; RV64MV-NEXT:    vmerge.vim v8, v10, -1, v0
; RV64MV-NEXT:    vmv.x.s a1, v8
; RV64MV-NEXT:    andi a1, a1, 2047
; RV64MV-NEXT:    vsetivli zero, 1, e16, mf2, ta, mu
; RV64MV-NEXT:    vslidedown.vi v9, v8, 1
; RV64MV-NEXT:    vmv.x.s a2, v9
; RV64MV-NEXT:    andi a2, a2, 2047
; RV64MV-NEXT:    slli a2, a2, 11
; RV64MV-NEXT:    or a1, a1, a2
; RV64MV-NEXT:    vslidedown.vi v8, v8, 2
; RV64MV-NEXT:    vmv.x.s a2, v8
; RV64MV-NEXT:    slli a2, a2, 22
; RV64MV-NEXT:    or a1, a1, a2
; RV64MV-NEXT:    sw a1, 0(a0)
; RV64MV-NEXT:    slli a1, a1, 31
; RV64MV-NEXT:    srli a1, a1, 63
; RV64MV-NEXT:    sb a1, 4(a0)
; RV64MV-NEXT:    addi sp, sp, 16
; RV64MV-NEXT:    ret
  %ld = load <3 x i11>, <3 x i11>* %X
  %urem = urem <3 x i11> %ld, <i11 6, i11 7, i11 -5>
  %cmp = icmp ne <3 x i11> %urem, <i11 0, i11 1, i11 2>
  %ext = sext <3 x i1> %cmp to <3 x i11>
  store <3 x i11> %ext, <3 x i11>* %X
  ret void
}
