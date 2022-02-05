; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv64 -mattr=+zbb -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ZBB

declare i32 @llvm.ctlz.i32(i32, i1)

define signext i32 @ctlz_i32(i32 signext %a) nounwind {
; RV64I-LABEL: ctlz_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a0, .LBB0_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    srliw a1, a0, 1
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 4
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 8
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 16
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srliw a0, a0, 24
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB0_2:
; RV64I-NEXT:    li a0, 32
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ctlz_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    clzw a0, a0
; RV64ZBB-NEXT:    ret
  %1 = call i32 @llvm.ctlz.i32(i32 %a, i1 false)
  ret i32 %1
}

define signext i32 @log2_i32(i32 signext %a) nounwind {
; RV64I-LABEL: log2_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a0, .LBB1_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    srliw a1, a0, 1
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 4
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 8
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 16
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srliw a0, a0, 24
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    j .LBB1_3
; RV64I-NEXT:  .LBB1_2:
; RV64I-NEXT:    li a0, 32
; RV64I-NEXT:  .LBB1_3: # %cond.end
; RV64I-NEXT:    li a1, 31
; RV64I-NEXT:    sub a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: log2_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    clzw a0, a0
; RV64ZBB-NEXT:    li a1, 31
; RV64ZBB-NEXT:    sub a0, a1, a0
; RV64ZBB-NEXT:    ret
  %1 = call i32 @llvm.ctlz.i32(i32 %a, i1 false)
  %2 = sub i32 31, %1
  ret i32 %2
}

define signext i32 @log2_ceil_i32(i32 signext %a) nounwind {
; RV64I-LABEL: log2_ceil_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addiw a0, a0, -1
; RV64I-NEXT:    li s0, 32
; RV64I-NEXT:    li a1, 32
; RV64I-NEXT:    beqz a0, .LBB2_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    srliw a1, a0, 1
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 4
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 8
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 16
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srliw a1, a0, 24
; RV64I-NEXT:  .LBB2_2: # %cond.end
; RV64I-NEXT:    sub a0, s0, a1
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: log2_ceil_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    addiw a0, a0, -1
; RV64ZBB-NEXT:    clzw a0, a0
; RV64ZBB-NEXT:    li a1, 32
; RV64ZBB-NEXT:    sub a0, a1, a0
; RV64ZBB-NEXT:    ret
  %1 = sub i32 %a, 1
  %2 = call i32 @llvm.ctlz.i32(i32 %1, i1 false)
  %3 = sub i32 32, %2
  ret i32 %3
}

define signext i32 @findLastSet_i32(i32 signext %a) nounwind {
; RV64I-LABEL: findLastSet_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    srliw a0, a0, 1
; RV64I-NEXT:    or a0, s0, a0
; RV64I-NEXT:    srliw a1, a0, 2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 4
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 8
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srliw a1, a0, 16
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    li a0, -1
; RV64I-NEXT:    beqz s0, .LBB3_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    srliw a0, a1, 24
; RV64I-NEXT:    xori a0, a0, 31
; RV64I-NEXT:  .LBB3_2:
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: findLastSet_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    mv a1, a0
; RV64ZBB-NEXT:    li a0, -1
; RV64ZBB-NEXT:    beqz a1, .LBB3_2
; RV64ZBB-NEXT:  # %bb.1:
; RV64ZBB-NEXT:    clzw a0, a1
; RV64ZBB-NEXT:    xori a0, a0, 31
; RV64ZBB-NEXT:  .LBB3_2:
; RV64ZBB-NEXT:    ret
  %1 = call i32 @llvm.ctlz.i32(i32 %a, i1 true)
  %2 = xor i32 31, %1
  %3 = icmp eq i32 %a, 0
  %4 = select i1 %3, i32 -1, i32 %2
  ret i32 %4
}

define i32 @ctlz_lshr_i32(i32 signext %a) {
; RV64I-LABEL: ctlz_lshr_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a0, a0, 1
; RV64I-NEXT:    beqz a0, .LBB4_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    .cfi_def_cfa_offset 16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    .cfi_offset ra, -8
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 8
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    slli a1, a0, 33
; RV64I-NEXT:    srli a1, a1, 49
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srliw a0, a0, 24
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB4_2:
; RV64I-NEXT:    li a0, 32
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ctlz_lshr_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    srliw a0, a0, 1
; RV64ZBB-NEXT:    clzw a0, a0
; RV64ZBB-NEXT:    ret
  %1 = lshr i32 %a, 1
  %2 = call i32 @llvm.ctlz.i32(i32 %1, i1 false)
  ret i32 %2
}

declare i64 @llvm.ctlz.i64(i64, i1)

define i64 @ctlz_i64(i64 %a) nounwind {
; RV64I-LABEL: ctlz_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a0, .LBB5_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 8
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 16
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    lui a1, %hi(.LCPI5_0)
; RV64I-NEXT:    ld a1, %lo(.LCPI5_0)(a1)
; RV64I-NEXT:    lui a2, %hi(.LCPI5_1)
; RV64I-NEXT:    ld a2, %lo(.LCPI5_1)(a2)
; RV64I-NEXT:    srli a3, a0, 1
; RV64I-NEXT:    and a1, a3, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    and a1, a0, a2
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    lui a2, %hi(.LCPI5_2)
; RV64I-NEXT:    ld a2, %lo(.LCPI5_2)(a2)
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    lui a1, %hi(.LCPI5_3)
; RV64I-NEXT:    ld a1, %lo(.LCPI5_3)(a1)
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB5_2:
; RV64I-NEXT:    li a0, 64
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ctlz_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    clz a0, a0
; RV64ZBB-NEXT:    ret
  %1 = call i64 @llvm.ctlz.i64(i64 %a, i1 false)
  ret i64 %1
}

declare i32 @llvm.cttz.i32(i32, i1)

define signext i32 @cttz_i32(i32 signext %a) nounwind {
; RV64I-LABEL: cttz_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a0, .LBB6_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addiw a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srliw a0, a0, 24
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB6_2:
; RV64I-NEXT:    li a0, 32
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: cttz_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    ctzw a0, a0
; RV64ZBB-NEXT:    ret
  %1 = call i32 @llvm.cttz.i32(i32 %a, i1 false)
  ret i32 %1
}

define signext i32 @cttz_zero_undef_i32(i32 signext %a) nounwind {
; RV64I-LABEL: cttz_zero_undef_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addiw a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srliw a0, a0, 24
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: cttz_zero_undef_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    ctzw a0, a0
; RV64ZBB-NEXT:    ret
  %1 = call i32 @llvm.cttz.i32(i32 %a, i1 true)
  ret i32 %1
}

define signext i32 @findFirstSet_i32(i32 signext %a) nounwind {
; RV64I-LABEL: findFirstSet_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    addiw a0, a0, -1
; RV64I-NEXT:    not a1, s0
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    li a0, -1
; RV64I-NEXT:    beqz s0, .LBB8_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    srliw a0, a1, 24
; RV64I-NEXT:  .LBB8_2:
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: findFirstSet_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    mv a1, a0
; RV64ZBB-NEXT:    li a0, -1
; RV64ZBB-NEXT:    beqz a1, .LBB8_2
; RV64ZBB-NEXT:  # %bb.1:
; RV64ZBB-NEXT:    ctzw a0, a1
; RV64ZBB-NEXT:  .LBB8_2:
; RV64ZBB-NEXT:    ret
  %1 = call i32 @llvm.cttz.i32(i32 %a, i1 true)
  %2 = icmp eq i32 %a, 0
  %3 = select i1 %2, i32 -1, i32 %1
  ret i32 %3
}

define signext i32 @ffs_i32(i32 signext %a) nounwind {
; RV64I-LABEL: ffs_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    addiw a0, a0, -1
; RV64I-NEXT:    not a1, s0
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    li a0, 0
; RV64I-NEXT:    beqz s0, .LBB9_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    srliw a0, a1, 24
; RV64I-NEXT:    addi a0, a0, 1
; RV64I-NEXT:  .LBB9_2:
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ffs_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    mv a1, a0
; RV64ZBB-NEXT:    li a0, 0
; RV64ZBB-NEXT:    beqz a1, .LBB9_2
; RV64ZBB-NEXT:  # %bb.1:
; RV64ZBB-NEXT:    ctzw a0, a1
; RV64ZBB-NEXT:    addi a0, a0, 1
; RV64ZBB-NEXT:  .LBB9_2:
; RV64ZBB-NEXT:    ret
  %1 = call i32 @llvm.cttz.i32(i32 %a, i1 true)
  %2 = add i32 %1, 1
  %3 = icmp eq i32 %a, 0
  %4 = select i1 %3, i32 0, i32 %2
  ret i32 %4
}

declare i64 @llvm.cttz.i64(i64, i1)

define i64 @cttz_i64(i64 %a) nounwind {
; RV64I-LABEL: cttz_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    beqz a0, .LBB10_2
; RV64I-NEXT:  # %bb.1: # %cond.false
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    addi a1, a0, -1
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, %hi(.LCPI10_0)
; RV64I-NEXT:    ld a1, %lo(.LCPI10_0)(a1)
; RV64I-NEXT:    lui a2, %hi(.LCPI10_1)
; RV64I-NEXT:    ld a2, %lo(.LCPI10_1)(a2)
; RV64I-NEXT:    srli a3, a0, 1
; RV64I-NEXT:    and a1, a3, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    and a1, a0, a2
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    lui a2, %hi(.LCPI10_2)
; RV64I-NEXT:    ld a2, %lo(.LCPI10_2)(a2)
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    lui a1, %hi(.LCPI10_3)
; RV64I-NEXT:    ld a1, %lo(.LCPI10_3)(a1)
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
; RV64I-NEXT:  .LBB10_2:
; RV64I-NEXT:    li a0, 64
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: cttz_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    ctz a0, a0
; RV64ZBB-NEXT:    ret
  %1 = call i64 @llvm.cttz.i64(i64 %a, i1 false)
  ret i64 %1
}

declare i32 @llvm.ctpop.i32(i32)

define signext i32 @ctpop_i32(i32 signext %a) nounwind {
; RV64I-LABEL: ctpop_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srliw a0, a0, 24
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ctpop_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    cpopw a0, a0
; RV64ZBB-NEXT:    ret
  %1 = call i32 @llvm.ctpop.i32(i32 %a)
  ret i32 %1
}

define signext i32 @ctpop_i32_load(i32* %p) nounwind {
; RV64I-LABEL: ctpop_i32_load:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    srli a1, a0, 1
; RV64I-NEXT:    lui a2, 349525
; RV64I-NEXT:    addiw a2, a2, 1365
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    subw a0, a0, a1
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw a1, a1, 819
; RV64I-NEXT:    and a2, a0, a1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw a1, a1, -241
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw a1, a1, 257
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srliw a0, a0, 24
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ctpop_i32_load:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    lwu a0, 0(a0)
; RV64ZBB-NEXT:    cpopw a0, a0
; RV64ZBB-NEXT:    ret
  %a = load i32, i32* %p
  %1 = call i32 @llvm.ctpop.i32(i32 %a)
  ret i32 %1
}

declare i64 @llvm.ctpop.i64(i64)

define i64 @ctpop_i64(i64 %a) nounwind {
; RV64I-LABEL: ctpop_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    lui a1, %hi(.LCPI13_0)
; RV64I-NEXT:    ld a1, %lo(.LCPI13_0)(a1)
; RV64I-NEXT:    lui a2, %hi(.LCPI13_1)
; RV64I-NEXT:    ld a2, %lo(.LCPI13_1)(a2)
; RV64I-NEXT:    srli a3, a0, 1
; RV64I-NEXT:    and a1, a3, a1
; RV64I-NEXT:    sub a0, a0, a1
; RV64I-NEXT:    and a1, a0, a2
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    lui a2, %hi(.LCPI13_2)
; RV64I-NEXT:    ld a2, %lo(.LCPI13_2)(a2)
; RV64I-NEXT:    add a0, a1, a0
; RV64I-NEXT:    srli a1, a0, 4
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    lui a1, %hi(.LCPI13_3)
; RV64I-NEXT:    ld a1, %lo(.LCPI13_3)(a1)
; RV64I-NEXT:    call __muldi3@plt
; RV64I-NEXT:    srli a0, a0, 56
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: ctpop_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    cpop a0, a0
; RV64ZBB-NEXT:    ret
  %1 = call i64 @llvm.ctpop.i64(i64 %a)
  ret i64 %1
}

define signext i32 @sextb_i32(i32 signext %a) nounwind {
; RV64I-LABEL: sextb_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srai a0, a0, 56
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: sextb_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.b a0, a0
; RV64ZBB-NEXT:    ret
  %shl = shl i32 %a, 24
  %shr = ashr exact i32 %shl, 24
  ret i32 %shr
}

define i64 @sextb_i64(i64 %a) nounwind {
; RV64I-LABEL: sextb_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    srai a0, a0, 56
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: sextb_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.b a0, a0
; RV64ZBB-NEXT:    ret
  %shl = shl i64 %a, 56
  %shr = ashr exact i64 %shl, 56
  ret i64 %shr
}

define signext i32 @sexth_i32(i32 signext %a) nounwind {
; RV64I-LABEL: sexth_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 48
; RV64I-NEXT:    srai a0, a0, 48
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: sexth_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.h a0, a0
; RV64ZBB-NEXT:    ret
  %shl = shl i32 %a, 16
  %shr = ashr exact i32 %shl, 16
  ret i32 %shr
}

define i64 @sexth_i64(i64 %a) nounwind {
; RV64I-LABEL: sexth_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 48
; RV64I-NEXT:    srai a0, a0, 48
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: sexth_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.h a0, a0
; RV64ZBB-NEXT:    ret
  %shl = shl i64 %a, 48
  %shr = ashr exact i64 %shl, 48
  ret i64 %shr
}

define signext i32 @min_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: min_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    blt a0, a1, .LBB18_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB18_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: min_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    min a0, a0, a1
; RV64ZBB-NEXT:    ret
  %cmp = icmp slt i32 %a, %b
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

define i64 @min_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: min_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    blt a0, a1, .LBB19_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB19_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: min_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    min a0, a0, a1
; RV64ZBB-NEXT:    ret
  %cmp = icmp slt i64 %a, %b
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

define signext i32 @max_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: max_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    blt a1, a0, .LBB20_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB20_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: max_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %cmp = icmp sgt i32 %a, %b
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

define i64 @max_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: max_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    blt a1, a0, .LBB21_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB21_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: max_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %cmp = icmp sgt i64 %a, %b
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

define signext i32 @minu_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: minu_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bltu a0, a1, .LBB22_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB22_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: minu_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    minu a0, a0, a1
; RV64ZBB-NEXT:    ret
  %cmp = icmp ult i32 %a, %b
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

define i64 @minu_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: minu_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bltu a0, a1, .LBB23_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB23_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: minu_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    minu a0, a0, a1
; RV64ZBB-NEXT:    ret
  %cmp = icmp ult i64 %a, %b
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

define signext i32 @maxu_i32(i32 signext %a, i32 signext %b) nounwind {
; RV64I-LABEL: maxu_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bltu a1, a0, .LBB24_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB24_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: maxu_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    maxu a0, a0, a1
; RV64ZBB-NEXT:    ret
  %cmp = icmp ugt i32 %a, %b
  %cond = select i1 %cmp, i32 %a, i32 %b
  ret i32 %cond
}

define i64 @maxu_i64(i64 %a, i64 %b) nounwind {
; RV64I-LABEL: maxu_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    bltu a1, a0, .LBB25_2
; RV64I-NEXT:  # %bb.1:
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:  .LBB25_2:
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: maxu_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    maxu a0, a0, a1
; RV64ZBB-NEXT:    ret
  %cmp = icmp ugt i64 %a, %b
  %cond = select i1 %cmp, i64 %a, i64 %b
  ret i64 %cond
}

declare i32 @llvm.abs.i32(i32, i1 immarg)

define i32 @abs_i32(i32 %x) {
; RV64I-LABEL: abs_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    srai a1, a0, 63
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: abs_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    sext.w a0, a0
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 true)
  ret i32 %abs
}

; FIXME: We can remove the sext.w by using addw for RV64I and negw for RV64ZBB.
define signext i32 @abs_i32_sext(i32 signext %x) {
; RV64I-LABEL: abs_i32_sext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srai a1, a0, 63
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: abs_i32_sext:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    sext.w a0, a0
; RV64ZBB-NEXT:    ret
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 true)
  ret i32 %abs
}

declare i64 @llvm.abs.i64(i64, i1 immarg)

define i64 @abs_i64(i64 %x) {
; RV64I-LABEL: abs_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srai a1, a0, 63
; RV64I-NEXT:    add a0, a0, a1
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: abs_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    neg a1, a0
; RV64ZBB-NEXT:    max a0, a0, a1
; RV64ZBB-NEXT:    ret
  %abs = tail call i64 @llvm.abs.i64(i64 %x, i1 true)
  ret i64 %abs
}

define i32 @zexth_i32(i32 %a) nounwind {
; RV64I-LABEL: zexth_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 48
; RV64I-NEXT:    srli a0, a0, 48
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: zexth_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    zext.h a0, a0
; RV64ZBB-NEXT:    ret
  %and = and i32 %a, 65535
  ret i32 %and
}

define i64 @zexth_i64(i64 %a) nounwind {
; RV64I-LABEL: zexth_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    slli a0, a0, 48
; RV64I-NEXT:    srli a0, a0, 48
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: zexth_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    zext.h a0, a0
; RV64ZBB-NEXT:    ret
  %and = and i64 %a, 65535
  ret i64 %and
}

declare i32 @llvm.bswap.i32(i32)

define signext i32 @bswap_i32(i32 signext %a) nounwind {
; RV64I-LABEL: bswap_i32:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a1, a0, 8
; RV64I-NEXT:    lui a2, 16
; RV64I-NEXT:    addiw a2, a2, -256
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    srliw a2, a0, 24
; RV64I-NEXT:    or a1, a1, a2
; RV64I-NEXT:    slli a2, a0, 8
; RV64I-NEXT:    lui a3, 4080
; RV64I-NEXT:    and a2, a2, a3
; RV64I-NEXT:    slliw a0, a0, 24
; RV64I-NEXT:    or a0, a0, a2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: bswap_i32:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rev8 a0, a0
; RV64ZBB-NEXT:    srai a0, a0, 32
; RV64ZBB-NEXT:    ret
  %1 = tail call i32 @llvm.bswap.i32(i32 %a)
  ret i32 %1
}

; Similar to bswap_i32 but the result is not sign extended.
define void @bswap_i32_nosext(i32 signext %a, i32* %x) nounwind {
; RV64I-LABEL: bswap_i32_nosext:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srliw a2, a0, 8
; RV64I-NEXT:    lui a3, 16
; RV64I-NEXT:    addiw a3, a3, -256
; RV64I-NEXT:    and a2, a2, a3
; RV64I-NEXT:    srliw a3, a0, 24
; RV64I-NEXT:    or a2, a2, a3
; RV64I-NEXT:    slli a3, a0, 8
; RV64I-NEXT:    lui a4, 4080
; RV64I-NEXT:    and a3, a3, a4
; RV64I-NEXT:    slli a0, a0, 24
; RV64I-NEXT:    or a0, a0, a3
; RV64I-NEXT:    or a0, a0, a2
; RV64I-NEXT:    sw a0, 0(a1)
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: bswap_i32_nosext:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rev8 a0, a0
; RV64ZBB-NEXT:    srli a0, a0, 32
; RV64ZBB-NEXT:    sw a0, 0(a1)
; RV64ZBB-NEXT:    ret
  %1 = tail call i32 @llvm.bswap.i32(i32 %a)
  store i32 %1, i32* %x
  ret void
}

declare i64 @llvm.bswap.i64(i64)

define i64 @bswap_i64(i64 %a) {
; RV64I-LABEL: bswap_i64:
; RV64I:       # %bb.0:
; RV64I-NEXT:    srli a1, a0, 24
; RV64I-NEXT:    lui a2, 4080
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    srli a2, a0, 8
; RV64I-NEXT:    li a3, 255
; RV64I-NEXT:    slli a4, a3, 24
; RV64I-NEXT:    and a2, a2, a4
; RV64I-NEXT:    or a1, a2, a1
; RV64I-NEXT:    srli a2, a0, 40
; RV64I-NEXT:    lui a4, 16
; RV64I-NEXT:    addiw a4, a4, -256
; RV64I-NEXT:    and a2, a2, a4
; RV64I-NEXT:    srli a4, a0, 56
; RV64I-NEXT:    or a2, a2, a4
; RV64I-NEXT:    or a1, a1, a2
; RV64I-NEXT:    slli a2, a0, 24
; RV64I-NEXT:    slli a4, a3, 40
; RV64I-NEXT:    and a2, a2, a4
; RV64I-NEXT:    srliw a4, a0, 24
; RV64I-NEXT:    slli a4, a4, 32
; RV64I-NEXT:    or a2, a2, a4
; RV64I-NEXT:    slli a4, a0, 40
; RV64I-NEXT:    slli a3, a3, 48
; RV64I-NEXT:    and a3, a4, a3
; RV64I-NEXT:    slli a0, a0, 56
; RV64I-NEXT:    or a0, a0, a3
; RV64I-NEXT:    or a0, a0, a2
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: bswap_i64:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    rev8 a0, a0
; RV64ZBB-NEXT:    ret
  %1 = call i64 @llvm.bswap.i64(i64 %a)
  ret i64 %1
}
