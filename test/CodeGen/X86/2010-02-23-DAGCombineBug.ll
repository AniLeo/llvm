; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s

define i32* @t(i32 %a0) nounwind optsize ssp {
; CHECK-LABEL: t:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpl $0, {{[0-9]+}}(%esp)
; CHECK-NEXT:    js .LBB0_2
; CHECK-NEXT:  # %bb.1: # %if.then27
; CHECK-NEXT:    retl
; CHECK-NEXT:  .LBB0_2: # %if.else29
entry:
  %cmp = icmp slt i32 %a0, 0                    ; <i1> [#uses=1]
  %outsearch.0 = select i1 %cmp, i1 false, i1 true ; <i1> [#uses=1]
  br i1 %outsearch.0, label %if.then27, label %if.else29

if.then27:                                        ; preds = %entry
  ret i32* undef

if.else29:                                        ; preds = %entry
  unreachable
}

