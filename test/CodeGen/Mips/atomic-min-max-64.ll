; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=mips64 -O0 -mcpu=mips64r2 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=MIPS
; RUN: llc -march=mips64el -O0 -mcpu=mips64r2 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=MIPS
; RUN: llc -march=mips64 -O0 -mcpu=mips64r6 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=MIPSR6
; RUN: llc -march=mips64el -O0 -mcpu=mips64r6 -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=MIPSR6

define i64 @test_max(i64* nocapture %ptr, i64 signext %val) {
; MIPS-LABEL: test_max:
; MIPS:       # %bb.0: # %entry
; MIPS-NEXT:    sync
; MIPS-NEXT:  .LBB0_1: # %entry
; MIPS-NEXT:    # =>This Inner Loop Header: Depth=1
; MIPS-NEXT:    lld $2, 0($4)
; MIPS-NEXT:    slt $3, $2, $5
; MIPS-NEXT:    move $1, $2
; MIPS-NEXT:    movn $1, $5, $3
; MIPS-NEXT:    scd $1, 0($4)
; MIPS-NEXT:    beqz $1, .LBB0_1
; MIPS-NEXT:    nop
; MIPS-NEXT:  # %bb.2: # %entry
; MIPS-NEXT:    sync
; MIPS-NEXT:    jr $ra
; MIPS-NEXT:    nop
;
; MIPSR6-LABEL: test_max:
; MIPSR6:       # %bb.0: # %entry
; MIPSR6-NEXT:    sync
; MIPSR6-NEXT:  .LBB0_1: # %entry
; MIPSR6-NEXT:    # =>This Inner Loop Header: Depth=1
; MIPSR6-NEXT:    lld $2, 0($4)
; MIPSR6-NEXT:    slt $3, $2, $5
; MIPSR6-NEXT:    seleqz $1, $2, $3
; MIPSR6-NEXT:    selnez $3, $5, $3
; MIPSR6-NEXT:    or $1, $1, $3
; MIPSR6-NEXT:    scd $1, 0($4)
; MIPSR6-NEXT:    beqzc $1, .LBB0_1
; MIPSR6-NEXT:  # %bb.2: # %entry
; MIPSR6-NEXT:    sync
; MIPSR6-NEXT:    jrc $ra
entry:
  %0 = atomicrmw max i64* %ptr, i64 %val seq_cst
  ret i64 %0
}

define i64 @test_min(i64* nocapture %ptr, i64 signext %val) {
; MIPS-LABEL: test_min:
; MIPS:       # %bb.0: # %entry
; MIPS-NEXT:    sync
; MIPS-NEXT:  .LBB1_1: # %entry
; MIPS-NEXT:    # =>This Inner Loop Header: Depth=1
; MIPS-NEXT:    lld $2, 0($4)
; MIPS-NEXT:    slt $3, $2, $5
; MIPS-NEXT:    move $1, $2
; MIPS-NEXT:    movz $1, $5, $3
; MIPS-NEXT:    scd $1, 0($4)
; MIPS-NEXT:    beqz $1, .LBB1_1
; MIPS-NEXT:    nop
; MIPS-NEXT:  # %bb.2: # %entry
; MIPS-NEXT:    sync
; MIPS-NEXT:    jr $ra
; MIPS-NEXT:    nop
;
; MIPSR6-LABEL: test_min:
; MIPSR6:       # %bb.0: # %entry
; MIPSR6-NEXT:    sync
; MIPSR6-NEXT:  .LBB1_1: # %entry
; MIPSR6-NEXT:    # =>This Inner Loop Header: Depth=1
; MIPSR6-NEXT:    lld $2, 0($4)
; MIPSR6-NEXT:    slt $3, $2, $5
; MIPSR6-NEXT:    selnez $1, $2, $3
; MIPSR6-NEXT:    seleqz $3, $5, $3
; MIPSR6-NEXT:    or $1, $1, $3
; MIPSR6-NEXT:    scd $1, 0($4)
; MIPSR6-NEXT:    beqzc $1, .LBB1_1
; MIPSR6-NEXT:  # %bb.2: # %entry
; MIPSR6-NEXT:    sync
; MIPSR6-NEXT:    jrc $ra
entry:
  %0 = atomicrmw min i64* %ptr, i64 %val seq_cst
  ret i64 %0
}

define i64 @test_umax(i64* nocapture %ptr, i64 zeroext %val) {
; MIPS-LABEL: test_umax:
; MIPS:       # %bb.0: # %entry
; MIPS-NEXT:    sync
; MIPS-NEXT:  .LBB2_1: # %entry
; MIPS-NEXT:    # =>This Inner Loop Header: Depth=1
; MIPS-NEXT:    lld $2, 0($4)
; MIPS-NEXT:    sltu $3, $2, $5
; MIPS-NEXT:    move $1, $2
; MIPS-NEXT:    movn $1, $5, $3
; MIPS-NEXT:    scd $1, 0($4)
; MIPS-NEXT:    beqz $1, .LBB2_1
; MIPS-NEXT:    nop
; MIPS-NEXT:  # %bb.2: # %entry
; MIPS-NEXT:    sync
; MIPS-NEXT:    jr $ra
; MIPS-NEXT:    nop
;
; MIPSR6-LABEL: test_umax:
; MIPSR6:       # %bb.0: # %entry
; MIPSR6-NEXT:    sync
; MIPSR6-NEXT:  .LBB2_1: # %entry
; MIPSR6-NEXT:    # =>This Inner Loop Header: Depth=1
; MIPSR6-NEXT:    lld $2, 0($4)
; MIPSR6-NEXT:    sltu $3, $2, $5
; MIPSR6-NEXT:    seleqz $1, $2, $3
; MIPSR6-NEXT:    selnez $3, $5, $3
; MIPSR6-NEXT:    or $1, $1, $3
; MIPSR6-NEXT:    scd $1, 0($4)
; MIPSR6-NEXT:    beqzc $1, .LBB2_1
; MIPSR6-NEXT:  # %bb.2: # %entry
; MIPSR6-NEXT:    sync
; MIPSR6-NEXT:    jrc $ra
entry:
  %0 = atomicrmw umax i64* %ptr, i64 %val seq_cst
  ret i64 %0
}

define i64 @test_umin(i64* nocapture %ptr, i64 zeroext %val) {
; MIPS-LABEL: test_umin:
; MIPS:       # %bb.0: # %entry
; MIPS-NEXT:    sync
; MIPS-NEXT:  .LBB3_1: # %entry
; MIPS-NEXT:    # =>This Inner Loop Header: Depth=1
; MIPS-NEXT:    lld $2, 0($4)
; MIPS-NEXT:    sltu $3, $2, $5
; MIPS-NEXT:    move $1, $2
; MIPS-NEXT:    movz $1, $5, $3
; MIPS-NEXT:    scd $1, 0($4)
; MIPS-NEXT:    beqz $1, .LBB3_1
; MIPS-NEXT:    nop
; MIPS-NEXT:  # %bb.2: # %entry
; MIPS-NEXT:    sync
; MIPS-NEXT:    jr $ra
; MIPS-NEXT:    nop
;
; MIPSR6-LABEL: test_umin:
; MIPSR6:       # %bb.0: # %entry
; MIPSR6-NEXT:    sync
; MIPSR6-NEXT:  .LBB3_1: # %entry
; MIPSR6-NEXT:    # =>This Inner Loop Header: Depth=1
; MIPSR6-NEXT:    lld $2, 0($4)
; MIPSR6-NEXT:    sltu $3, $2, $5
; MIPSR6-NEXT:    selnez $1, $2, $3
; MIPSR6-NEXT:    seleqz $3, $5, $3
; MIPSR6-NEXT:    or $1, $1, $3
; MIPSR6-NEXT:    scd $1, 0($4)
; MIPSR6-NEXT:    beqzc $1, .LBB3_1
; MIPSR6-NEXT:  # %bb.2: # %entry
; MIPSR6-NEXT:    sync
; MIPSR6-NEXT:    jrc $ra
entry:
  %0 = atomicrmw umin i64* %ptr, i64 %val seq_cst
  ret i64 %0
}

