; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=mips-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=MIPSEL
; RUN: llc -mtriple=mips64el-unknown-linux-gnu < %s | FileCheck %s --check-prefixes=MIPS64EL

define i1 @test_urem_odd(i13 %X) nounwind {
; MIPSEL-LABEL: test_urem_odd:
; MIPSEL:       # %bb.0:
; MIPSEL-NEXT:    addiu $1, $zero, 3277
; MIPSEL-NEXT:    mul $1, $4, $1
; MIPSEL-NEXT:    andi $1, $1, 8191
; MIPSEL-NEXT:    jr $ra
; MIPSEL-NEXT:    sltiu $2, $1, 1639
;
; MIPS64EL-LABEL: test_urem_odd:
; MIPS64EL:       # %bb.0:
; MIPS64EL-NEXT:    sll $1, $4, 0
; MIPS64EL-NEXT:    sll $2, $1, 1
; MIPS64EL-NEXT:    addu $2, $2, $1
; MIPS64EL-NEXT:    sll $3, $1, 4
; MIPS64EL-NEXT:    subu $2, $3, $2
; MIPS64EL-NEXT:    sll $3, $1, 6
; MIPS64EL-NEXT:    subu $2, $2, $3
; MIPS64EL-NEXT:    sll $3, $1, 8
; MIPS64EL-NEXT:    addu $2, $3, $2
; MIPS64EL-NEXT:    sll $3, $1, 10
; MIPS64EL-NEXT:    subu $2, $2, $3
; MIPS64EL-NEXT:    sll $1, $1, 12
; MIPS64EL-NEXT:    addu $1, $1, $2
; MIPS64EL-NEXT:    andi $1, $1, 8191
; MIPS64EL-NEXT:    jr $ra
; MIPS64EL-NEXT:    sltiu $2, $1, 1639
  %urem = urem i13 %X, 5
  %cmp = icmp eq i13 %urem, 0
  ret i1 %cmp
}

define i1 @test_urem_even(i27 %X) nounwind {
; MIPSEL-LABEL: test_urem_even:
; MIPSEL:       # %bb.0:
; MIPSEL-NEXT:    lui $1, 1755
; MIPSEL-NEXT:    ori $1, $1, 28087
; MIPSEL-NEXT:    mul $1, $4, $1
; MIPSEL-NEXT:    sll $2, $1, 26
; MIPSEL-NEXT:    lui $3, 2047
; MIPSEL-NEXT:    ori $4, $3, 65534
; MIPSEL-NEXT:    and $1, $1, $4
; MIPSEL-NEXT:    srl $1, $1, 1
; MIPSEL-NEXT:    or $1, $1, $2
; MIPSEL-NEXT:    ori $2, $3, 65535
; MIPSEL-NEXT:    and $1, $1, $2
; MIPSEL-NEXT:    lui $2, 146
; MIPSEL-NEXT:    ori $2, $2, 18725
; MIPSEL-NEXT:    jr $ra
; MIPSEL-NEXT:    sltu $2, $1, $2
;
; MIPS64EL-LABEL: test_urem_even:
; MIPS64EL:       # %bb.0:
; MIPS64EL-NEXT:    lui $1, 1755
; MIPS64EL-NEXT:    ori $1, $1, 28087
; MIPS64EL-NEXT:    sll $2, $4, 0
; MIPS64EL-NEXT:    mul $1, $2, $1
; MIPS64EL-NEXT:    sll $2, $1, 26
; MIPS64EL-NEXT:    lui $3, 2047
; MIPS64EL-NEXT:    ori $4, $3, 65534
; MIPS64EL-NEXT:    and $1, $1, $4
; MIPS64EL-NEXT:    srl $1, $1, 1
; MIPS64EL-NEXT:    or $1, $1, $2
; MIPS64EL-NEXT:    ori $2, $3, 65535
; MIPS64EL-NEXT:    lui $3, 146
; MIPS64EL-NEXT:    and $1, $1, $2
; MIPS64EL-NEXT:    ori $2, $3, 18725
; MIPS64EL-NEXT:    jr $ra
; MIPS64EL-NEXT:    sltu $2, $1, $2
  %urem = urem i27 %X, 14
  %cmp = icmp eq i27 %urem, 0
  ret i1 %cmp
}

define i1 @test_urem_odd_setne(i4 %X) nounwind {
; MIPSEL-LABEL: test_urem_odd_setne:
; MIPSEL:       # %bb.0:
; MIPSEL-NEXT:    sll $1, $4, 1
; MIPSEL-NEXT:    addu $1, $1, $4
; MIPSEL-NEXT:    negu $1, $1
; MIPSEL-NEXT:    andi $1, $1, 15
; MIPSEL-NEXT:    addiu $2, $zero, 3
; MIPSEL-NEXT:    jr $ra
; MIPSEL-NEXT:    sltu $2, $2, $1
;
; MIPS64EL-LABEL: test_urem_odd_setne:
; MIPS64EL:       # %bb.0:
; MIPS64EL-NEXT:    sll $1, $4, 0
; MIPS64EL-NEXT:    sll $2, $1, 1
; MIPS64EL-NEXT:    addu $1, $2, $1
; MIPS64EL-NEXT:    negu $1, $1
; MIPS64EL-NEXT:    andi $1, $1, 15
; MIPS64EL-NEXT:    addiu $2, $zero, 3
; MIPS64EL-NEXT:    jr $ra
; MIPS64EL-NEXT:    sltu $2, $2, $1
  %urem = urem i4 %X, 5
  %cmp = icmp ne i4 %urem, 0
  ret i1 %cmp
}

define i1 @test_urem_negative_odd(i9 %X) nounwind {
; MIPSEL-LABEL: test_urem_negative_odd:
; MIPSEL:       # %bb.0:
; MIPSEL-NEXT:    sll $1, $4, 1
; MIPSEL-NEXT:    addu $1, $1, $4
; MIPSEL-NEXT:    sll $2, $4, 4
; MIPSEL-NEXT:    subu $1, $1, $2
; MIPSEL-NEXT:    sll $2, $4, 6
; MIPSEL-NEXT:    addu $1, $2, $1
; MIPSEL-NEXT:    sll $2, $4, 8
; MIPSEL-NEXT:    addu $1, $2, $1
; MIPSEL-NEXT:    andi $1, $1, 511
; MIPSEL-NEXT:    addiu $2, $zero, 1
; MIPSEL-NEXT:    jr $ra
; MIPSEL-NEXT:    sltu $2, $2, $1
;
; MIPS64EL-LABEL: test_urem_negative_odd:
; MIPS64EL:       # %bb.0:
; MIPS64EL-NEXT:    sll $1, $4, 0
; MIPS64EL-NEXT:    sll $2, $1, 1
; MIPS64EL-NEXT:    addu $2, $2, $1
; MIPS64EL-NEXT:    sll $3, $1, 4
; MIPS64EL-NEXT:    subu $2, $2, $3
; MIPS64EL-NEXT:    sll $3, $1, 6
; MIPS64EL-NEXT:    addu $2, $3, $2
; MIPS64EL-NEXT:    sll $1, $1, 8
; MIPS64EL-NEXT:    addiu $3, $zero, 1
; MIPS64EL-NEXT:    addu $1, $1, $2
; MIPS64EL-NEXT:    andi $1, $1, 511
; MIPS64EL-NEXT:    jr $ra
; MIPS64EL-NEXT:    sltu $2, $3, $1
  %urem = urem i9 %X, -5
  %cmp = icmp ne i9 %urem, 0
  ret i1 %cmp
}

; Asserts today
; define <3 x i1> @test_urem_vec(<3 x i11> %X) nounwind {
;   %urem = urem <3 x i11> %X, <i11 6, i11 7, i11 -5>
;   %cmp = icmp ne <3 x i11> %urem, <i11 0, i11 1, i11 2>
;   ret <3 x i1> %cmp
; }

define i1 @test_urem_oversized(i66 %X) nounwind {
; MIPSEL-LABEL: test_urem_oversized:
; MIPSEL:       # %bb.0:
; MIPSEL-NEXT:    lui $1, 52741
; MIPSEL-NEXT:    ori $1, $1, 40665
; MIPSEL-NEXT:    multu $6, $1
; MIPSEL-NEXT:    mfhi $2
; MIPSEL-NEXT:    mflo $3
; MIPSEL-NEXT:    multu $5, $1
; MIPSEL-NEXT:    mfhi $7
; MIPSEL-NEXT:    mflo $8
; MIPSEL-NEXT:    lui $9, 12057
; MIPSEL-NEXT:    ori $9, $9, 37186
; MIPSEL-NEXT:    multu $6, $9
; MIPSEL-NEXT:    mflo $10
; MIPSEL-NEXT:    mfhi $11
; MIPSEL-NEXT:    addu $2, $8, $2
; MIPSEL-NEXT:    addu $12, $10, $2
; MIPSEL-NEXT:    sltu $2, $2, $8
; MIPSEL-NEXT:    addu $2, $7, $2
; MIPSEL-NEXT:    sltu $7, $12, $10
; MIPSEL-NEXT:    sll $8, $12, 31
; MIPSEL-NEXT:    srl $10, $12, 1
; MIPSEL-NEXT:    sll $12, $3, 1
; MIPSEL-NEXT:    srl $3, $3, 1
; MIPSEL-NEXT:    mul $1, $4, $1
; MIPSEL-NEXT:    mul $4, $5, $9
; MIPSEL-NEXT:    sll $5, $6, 1
; MIPSEL-NEXT:    lui $6, 60010
; MIPSEL-NEXT:    addu $7, $11, $7
; MIPSEL-NEXT:    addu $2, $2, $7
; MIPSEL-NEXT:    addu $2, $4, $2
; MIPSEL-NEXT:    addu $1, $5, $1
; MIPSEL-NEXT:    addu $1, $2, $1
; MIPSEL-NEXT:    sll $2, $1, 31
; MIPSEL-NEXT:    or $4, $10, $2
; MIPSEL-NEXT:    sltiu $2, $4, 13
; MIPSEL-NEXT:    xori $4, $4, 13
; MIPSEL-NEXT:    or $3, $3, $8
; MIPSEL-NEXT:    ori $5, $6, 61135
; MIPSEL-NEXT:    sltu $3, $3, $5
; MIPSEL-NEXT:    movz $2, $3, $4
; MIPSEL-NEXT:    andi $1, $1, 2
; MIPSEL-NEXT:    srl $1, $1, 1
; MIPSEL-NEXT:    or $1, $1, $12
; MIPSEL-NEXT:    andi $1, $1, 3
; MIPSEL-NEXT:    jr $ra
; MIPSEL-NEXT:    movn $2, $zero, $1
;
; MIPS64EL-LABEL: test_urem_oversized:
; MIPS64EL:       # %bb.0:
; MIPS64EL-NEXT:    lui $1, 6029
; MIPS64EL-NEXT:    daddiu $1, $1, -14175
; MIPS64EL-NEXT:    dsll $1, $1, 16
; MIPS64EL-NEXT:    daddiu $1, $1, 26371
; MIPS64EL-NEXT:    dsll $1, $1, 17
; MIPS64EL-NEXT:    daddiu $1, $1, -24871
; MIPS64EL-NEXT:    dmult $5, $1
; MIPS64EL-NEXT:    mflo $2
; MIPS64EL-NEXT:    dmultu $4, $1
; MIPS64EL-NEXT:    mflo $1
; MIPS64EL-NEXT:    mfhi $3
; MIPS64EL-NEXT:    lui $5, 14
; MIPS64EL-NEXT:    daddiu $5, $5, -5525
; MIPS64EL-NEXT:    dsll $5, $5, 16
; MIPS64EL-NEXT:    daddiu $5, $5, -4401
; MIPS64EL-NEXT:    dsll $4, $4, 1
; MIPS64EL-NEXT:    daddu $3, $3, $4
; MIPS64EL-NEXT:    daddu $3, $3, $2
; MIPS64EL-NEXT:    dsll $2, $3, 63
; MIPS64EL-NEXT:    dsrl $4, $1, 1
; MIPS64EL-NEXT:    or $2, $4, $2
; MIPS64EL-NEXT:    sltu $2, $2, $5
; MIPS64EL-NEXT:    andi $3, $3, 2
; MIPS64EL-NEXT:    dsrl $3, $3, 1
; MIPS64EL-NEXT:    dsll $1, $1, 1
; MIPS64EL-NEXT:    or $1, $3, $1
; MIPS64EL-NEXT:    andi $1, $1, 3
; MIPS64EL-NEXT:    jr $ra
; MIPS64EL-NEXT:    movn $2, $zero, $1
  %urem = urem i66 %X, 1234567890
  %cmp = icmp eq i66 %urem, 0
  ret i1 %cmp
}
