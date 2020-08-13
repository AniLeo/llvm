; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+m -verify-machineinstrs < %s | FileCheck %s

define signext i32 @mulw(i32 signext %s, i32 signext %n, i32 signext %k) nounwind {
; CHECK-LABEL: mulw:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    addi a2, zero, 1
; CHECK-NEXT:    bge a0, a1, .LBB0_2
; CHECK-NEXT:  .LBB0_1: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    mulw a2, a0, a2
; CHECK-NEXT:    addiw a0, a0, 1
; CHECK-NEXT:    blt a0, a1, .LBB0_1
; CHECK-NEXT:  .LBB0_2: # %for.cond.cleanup
; CHECK-NEXT:    mv a0, a2
; CHECK-NEXT:    ret
entry:
  %cmp6 = icmp slt i32 %s, %n
  br i1 %cmp6, label %for.body, label %for.cond.cleanup

for.cond.cleanup:                                 ; preds = %for.body, %entry
  %sum.0.lcssa = phi i32 [ 1, %entry ], [ %mul, %for.body ]
  ret i32 %sum.0.lcssa

for.body:                                         ; preds = %entry, %for.body
  %i.08 = phi i32 [ %inc, %for.body ], [ %s, %entry ]
  %sum.07 = phi i32 [ %mul, %for.body ], [ 1, %entry ]
  %mul = mul nsw i32 %i.08, %sum.07
  %inc = add nsw i32 %i.08, 1
  %cmp = icmp slt i32 %inc, %n
  br i1 %cmp, label %for.body, label %for.cond.cleanup
}
