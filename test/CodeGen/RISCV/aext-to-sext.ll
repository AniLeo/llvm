; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I

; Make sure we don't generate an addi in the loop in
; addition to the addiw. Previously we type legalize the
; setcc use using signext and the phi use using anyext.
; We now detect when it would be beneficial to replace
; anyext with signext.

define void @quux(i32 signext %arg, i32 signext %arg1) nounwind {
; RV64I-LABEL: quux:
; RV64I:       # %bb.0: # %bb
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    beq a0, a1, .LBB0_3
; RV64I-NEXT:  # %bb.1: # %bb2.preheader
; RV64I-NEXT:    mv s0, a1
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:  .LBB0_2: # %bb2
; RV64I-NEXT:    # =>This Inner Loop Header: Depth=1
; RV64I-NEXT:    call hoge@plt
; RV64I-NEXT:    addiw s1, s1, 1
; RV64I-NEXT:    bne s1, s0, .LBB0_2
; RV64I-NEXT:  .LBB0_3: # %bb6
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
bb:
  %tmp = icmp eq i32 %arg, %arg1
  br i1 %tmp, label %bb6, label %bb2

bb2:                                              ; preds = %bb2, %bb
  %tmp3 = phi i32 [ %tmp4, %bb2 ], [ %arg, %bb ]
  tail call void @hoge()
  %tmp4 = add nsw i32 %tmp3, 1
  %tmp5 = icmp eq i32 %tmp4, %arg1
  br i1 %tmp5, label %bb6, label %bb2

bb6:                                              ; preds = %bb2, %bb
  ret void
}

declare void @hoge()

; This ends up creating a shl with a i64 result type, but an i32 shift amount.
; Because custom type legalization for i32 is enabled, this resulted in
; LowerOperation being called for the amount. This was not expected and
; triggered an assert.
define i32 @crash(i32 %x, i32 %y, i32 %z) {
; RV64I-LABEL: crash:
; RV64I:       # %bb.0:
; RV64I-NEXT:    sext.w a0, a0
; RV64I-NEXT:    seqz a3, a0
; RV64I-NEXT:    addw a0, a1, a2
; RV64I-NEXT:    slli a1, a3, 3
; RV64I-NEXT:  .LBB1_1: # %bb
; RV64I-NEXT:    # =>This Inner Loop Header: Depth=1
; RV64I-NEXT:    beq a0, a1, .LBB1_1
; RV64I-NEXT:  # %bb.2: # %bar
; RV64I-NEXT:    ret
  br label %bb

bb:
  %a = icmp eq i32 %x, 0
  %b = add i32 %y, %z
  %c = select i1 %a, i32 8, i32 0
  %d = icmp eq i32 %b, %c
  br i1 %d, label %bb, label %bar

bar:
  ret i32 %b
}

; We prefer to sign extend i32 constants for phis. The default behavior in
; SelectionDAGBuilder is zero extend. We have a target hook to override it.
define i64 @sext_phi_constants(i32 signext %c) {
; RV64I-LABEL: sext_phi_constants:
; RV64I:       # %bb.0:
; RV64I-NEXT:    li a1, -1
; RV64I-NEXT:    bnez a0, .LBB2_2
; RV64I-NEXT:  # %bb.1: # %iffalse
; RV64I-NEXT:    li a1, -2
; RV64I-NEXT:  .LBB2_2: # %merge
; RV64I-NEXT:    slli a0, a1, 32
; RV64I-NEXT:    srli a0, a0, 32
; RV64I-NEXT:    ret
  %a = icmp ne i32 %c, 0
  br i1 %a, label %iftrue, label %iffalse

iftrue:
  br label %merge

iffalse:
  br label %merge

merge:
  %b = phi i32 [-1, %iftrue], [-2, %iffalse]
  %d = zext i32 %b to i64
  ret i64 %d
}
