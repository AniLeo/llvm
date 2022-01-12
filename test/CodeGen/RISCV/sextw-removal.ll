; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=riscv64 -mattr=+m,+f \
; RUN:   | FileCheck %s --check-prefixes=CHECK,RV64I
; RUN: llc < %s -mtriple=riscv64 -mattr=+m,+zbb,+f \
; RUN:   | FileCheck %s --check-prefixes=CHECK,RV64ZBB
; RUN: llc < %s -mtriple=riscv64 -mattr=+m,+zbb,+f \
; RUN:   -riscv-disable-sextw-removal | FileCheck %s --check-prefix=NOREMOVAL

define void @test1(i32 signext %arg, i32 signext %arg1) nounwind {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    addi sp, sp, -32
; CHECK-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; CHECK-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; CHECK-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; CHECK-NEXT:    mv s0, a1
; CHECK-NEXT:    sraw s1, a0, a1
; CHECK-NEXT:  .LBB0_1: # %bb2
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mv a0, s1
; CHECK-NEXT:    call bar@plt
; CHECK-NEXT:    sllw s1, s1, s0
; CHECK-NEXT:    bnez a0, .LBB0_1
; CHECK-NEXT:  # %bb.2: # %bb7
; CHECK-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; CHECK-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; CHECK-NEXT:    addi sp, sp, 32
; CHECK-NEXT:    ret
;
; NOREMOVAL-LABEL: test1:
; NOREMOVAL:       # %bb.0: # %bb
; NOREMOVAL-NEXT:    addi sp, sp, -32
; NOREMOVAL-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; NOREMOVAL-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; NOREMOVAL-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; NOREMOVAL-NEXT:    mv s0, a1
; NOREMOVAL-NEXT:    sraw s1, a0, a1
; NOREMOVAL-NEXT:  .LBB0_1: # %bb2
; NOREMOVAL-NEXT:    # =>This Inner Loop Header: Depth=1
; NOREMOVAL-NEXT:    sext.w a0, s1
; NOREMOVAL-NEXT:    call bar@plt
; NOREMOVAL-NEXT:    sllw s1, s1, s0
; NOREMOVAL-NEXT:    bnez a0, .LBB0_1
; NOREMOVAL-NEXT:  # %bb.2: # %bb7
; NOREMOVAL-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; NOREMOVAL-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; NOREMOVAL-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; NOREMOVAL-NEXT:    addi sp, sp, 32
; NOREMOVAL-NEXT:    ret
bb:
  %i = ashr i32 %arg, %arg1
  br label %bb2

bb2:                                              ; preds = %bb2, %bb
  %i3 = phi i32 [ %i, %bb ], [ %i5, %bb2 ]
  %i4 = tail call signext i32 @bar(i32 signext %i3)
  %i5 = shl i32 %i3, %arg1
  %i6 = icmp eq i32 %i4, 0
  br i1 %i6, label %bb7, label %bb2

bb7:                                              ; preds = %bb2
  ret void
}

declare signext i32 @bar(i32 signext)

; The load here will be an anyext load in isel and sext.w will be emitted for
; the ret. Make sure we can look through logic ops to prove the sext.w is
; unnecessary.
define signext i32 @test2(i32* %p, i32 signext %b) nounwind {
; RV64I-LABEL: test2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    li a2, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    and a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: test2:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    lw a0, 0(a0)
; RV64ZBB-NEXT:    li a2, 1
; RV64ZBB-NEXT:    sllw a1, a2, a1
; RV64ZBB-NEXT:    andn a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; NOREMOVAL-LABEL: test2:
; NOREMOVAL:       # %bb.0:
; NOREMOVAL-NEXT:    lw a0, 0(a0)
; NOREMOVAL-NEXT:    li a2, 1
; NOREMOVAL-NEXT:    sllw a1, a2, a1
; NOREMOVAL-NEXT:    andn a0, a0, a1
; NOREMOVAL-NEXT:    sext.w a0, a0
; NOREMOVAL-NEXT:    ret
  %a = load i32, i32* %p
  %shl = shl i32 1, %b
  %neg = xor i32 %shl, -1
  %and1 = and i32 %neg, %a
  ret i32 %and1
}

define signext i32 @test3(i32* %p, i32 signext %b) nounwind {
; RV64I-LABEL: test3:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    li a2, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    not a1, a1
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: test3:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    lw a0, 0(a0)
; RV64ZBB-NEXT:    li a2, 1
; RV64ZBB-NEXT:    sllw a1, a2, a1
; RV64ZBB-NEXT:    orn a0, a0, a1
; RV64ZBB-NEXT:    ret
;
; NOREMOVAL-LABEL: test3:
; NOREMOVAL:       # %bb.0:
; NOREMOVAL-NEXT:    lw a0, 0(a0)
; NOREMOVAL-NEXT:    li a2, 1
; NOREMOVAL-NEXT:    sllw a1, a2, a1
; NOREMOVAL-NEXT:    orn a0, a0, a1
; NOREMOVAL-NEXT:    sext.w a0, a0
; NOREMOVAL-NEXT:    ret
  %a = load i32, i32* %p
  %shl = shl i32 1, %b
  %neg = xor i32 %shl, -1
  %and1 = or i32 %neg, %a
  ret i32 %and1
}

define signext i32 @test4(i32* %p, i32 signext %b) nounwind {
; RV64I-LABEL: test4:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lw a0, 0(a0)
; RV64I-NEXT:    li a2, 1
; RV64I-NEXT:    sllw a1, a2, a1
; RV64I-NEXT:    xor a0, a1, a0
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: test4:
; RV64ZBB:       # %bb.0:
; RV64ZBB-NEXT:    lw a0, 0(a0)
; RV64ZBB-NEXT:    li a2, 1
; RV64ZBB-NEXT:    sllw a1, a2, a1
; RV64ZBB-NEXT:    xnor a0, a1, a0
; RV64ZBB-NEXT:    ret
;
; NOREMOVAL-LABEL: test4:
; NOREMOVAL:       # %bb.0:
; NOREMOVAL-NEXT:    lw a0, 0(a0)
; NOREMOVAL-NEXT:    li a2, 1
; NOREMOVAL-NEXT:    sllw a1, a2, a1
; NOREMOVAL-NEXT:    xnor a0, a1, a0
; NOREMOVAL-NEXT:    sext.w a0, a0
; NOREMOVAL-NEXT:    ret
  %a = load i32, i32* %p
  %shl = shl i32 1, %b
  %neg = xor i32 %shl, -1
  %and1 = xor i32 %neg, %a
  ret i32 %and1
}

; Make sure we don't put a sext.w before bar when using cpopw.
define void @test5(i32 signext %arg, i32 signext %arg1) nounwind {
; RV64I-LABEL: test5:
; RV64I:       # %bb.0: # %bb
; RV64I-NEXT:    addi sp, sp, -48
; RV64I-NEXT:    sd ra, 40(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 32(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s2, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s3, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sraw a0, a0, a1
; RV64I-NEXT:    lui a1, 349525
; RV64I-NEXT:    addiw s2, a1, 1365
; RV64I-NEXT:    lui a1, 209715
; RV64I-NEXT:    addiw s1, a1, 819
; RV64I-NEXT:    lui a1, 61681
; RV64I-NEXT:    addiw s3, a1, -241
; RV64I-NEXT:    lui a1, 4112
; RV64I-NEXT:    addiw s0, a1, 257
; RV64I-NEXT:  .LBB4_1: # %bb2
; RV64I-NEXT:    # =>This Inner Loop Header: Depth=1
; RV64I-NEXT:    call bar@plt
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    srli a0, a0, 1
; RV64I-NEXT:    and a0, a0, s2
; RV64I-NEXT:    subw a0, a1, a0
; RV64I-NEXT:    and a2, a0, s1
; RV64I-NEXT:    srli a0, a0, 2
; RV64I-NEXT:    and a0, a0, s1
; RV64I-NEXT:    add a0, a2, a0
; RV64I-NEXT:    srli a2, a0, 4
; RV64I-NEXT:    add a0, a0, a2
; RV64I-NEXT:    and a0, a0, s3
; RV64I-NEXT:    mulw a0, a0, s0
; RV64I-NEXT:    srliw a0, a0, 24
; RV64I-NEXT:    bnez a1, .LBB4_1
; RV64I-NEXT:  # %bb.2: # %bb7
; RV64I-NEXT:    ld ra, 40(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 32(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s2, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s3, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 48
; RV64I-NEXT:    ret
;
; RV64ZBB-LABEL: test5:
; RV64ZBB:       # %bb.0: # %bb
; RV64ZBB-NEXT:    addi sp, sp, -16
; RV64ZBB-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64ZBB-NEXT:    sraw a0, a0, a1
; RV64ZBB-NEXT:  .LBB4_1: # %bb2
; RV64ZBB-NEXT:    # =>This Inner Loop Header: Depth=1
; RV64ZBB-NEXT:    call bar@plt
; RV64ZBB-NEXT:    mv a1, a0
; RV64ZBB-NEXT:    cpopw a0, a0
; RV64ZBB-NEXT:    bnez a1, .LBB4_1
; RV64ZBB-NEXT:  # %bb.2: # %bb7
; RV64ZBB-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64ZBB-NEXT:    addi sp, sp, 16
; RV64ZBB-NEXT:    ret
;
; NOREMOVAL-LABEL: test5:
; NOREMOVAL:       # %bb.0: # %bb
; NOREMOVAL-NEXT:    addi sp, sp, -16
; NOREMOVAL-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; NOREMOVAL-NEXT:    sraw a1, a0, a1
; NOREMOVAL-NEXT:  .LBB4_1: # %bb2
; NOREMOVAL-NEXT:    # =>This Inner Loop Header: Depth=1
; NOREMOVAL-NEXT:    sext.w a0, a1
; NOREMOVAL-NEXT:    call bar@plt
; NOREMOVAL-NEXT:    cpopw a1, a0
; NOREMOVAL-NEXT:    bnez a0, .LBB4_1
; NOREMOVAL-NEXT:  # %bb.2: # %bb7
; NOREMOVAL-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; NOREMOVAL-NEXT:    addi sp, sp, 16
; NOREMOVAL-NEXT:    ret
bb:
  %i = ashr i32 %arg, %arg1
  br label %bb2

bb2:                                              ; preds = %bb2, %bb
  %i3 = phi i32 [ %i, %bb ], [ %i5, %bb2 ]
  %i4 = tail call signext i32 @bar(i32 signext %i3)
  %i5 = tail call i32 @llvm.ctpop.i32(i32 %i4)
  %i6 = icmp eq i32 %i4, 0
  br i1 %i6, label %bb7, label %bb2

bb7:                                              ; preds = %bb2
  ret void
}

declare i32 @llvm.ctpop.i32(i32)

define void @test6(i32 signext %arg, i32 signext %arg1) nounwind {
; CHECK-LABEL: test6:
; CHECK:       # %bb.0: # %bb
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; CHECK-NEXT:    sraw a0, a0, a1
; CHECK-NEXT:    fmv.w.x ft0, zero
; CHECK-NEXT:    fsw ft0, 4(sp) # 4-byte Folded Spill
; CHECK-NEXT:  .LBB5_1: # %bb2
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    call baz@plt
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    flw ft1, 4(sp) # 4-byte Folded Reload
; CHECK-NEXT:    feq.s a1, ft0, ft1
; CHECK-NEXT:    fcvt.w.s a0, ft0, rtz
; CHECK-NEXT:    beqz a1, .LBB5_1
; CHECK-NEXT:  # %bb.2: # %bb7
; CHECK-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
;
; NOREMOVAL-LABEL: test6:
; NOREMOVAL:       # %bb.0: # %bb
; NOREMOVAL-NEXT:    addi sp, sp, -16
; NOREMOVAL-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; NOREMOVAL-NEXT:    sraw a0, a0, a1
; NOREMOVAL-NEXT:    fmv.w.x ft0, zero
; NOREMOVAL-NEXT:    fsw ft0, 4(sp) # 4-byte Folded Spill
; NOREMOVAL-NEXT:  .LBB5_1: # %bb2
; NOREMOVAL-NEXT:    # =>This Inner Loop Header: Depth=1
; NOREMOVAL-NEXT:    sext.w a0, a0
; NOREMOVAL-NEXT:    call baz@plt
; NOREMOVAL-NEXT:    fmv.w.x ft0, a0
; NOREMOVAL-NEXT:    flw ft1, 4(sp) # 4-byte Folded Reload
; NOREMOVAL-NEXT:    feq.s a1, ft0, ft1
; NOREMOVAL-NEXT:    fcvt.w.s a0, ft0, rtz
; NOREMOVAL-NEXT:    beqz a1, .LBB5_1
; NOREMOVAL-NEXT:  # %bb.2: # %bb7
; NOREMOVAL-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; NOREMOVAL-NEXT:    addi sp, sp, 16
; NOREMOVAL-NEXT:    ret
bb:
  %i = ashr i32 %arg, %arg1
  br label %bb2

bb2:                                              ; preds = %bb2, %bb
  %i3 = phi i32 [ %i, %bb ], [ %i5, %bb2 ]
  %i4 = tail call float @baz(i32 signext %i3)
  %i5 = fptosi float %i4 to i32
  %i6 = fcmp oeq float %i4, zeroinitializer
  br i1 %i6, label %bb7, label %bb2

bb7:                                              ; preds = %bb2
  ret void
}
declare float @baz(i32 signext %i3)
