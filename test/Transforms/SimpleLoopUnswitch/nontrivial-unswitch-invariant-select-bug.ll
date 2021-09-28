; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes='simple-loop-unswitch<nontrivial>' -S < %s | FileCheck %s

; FIXME: We should not replace `true` with `false` here!
define i1 @bar() {
; CHECK-LABEL: @bar(
; CHECK-NEXT:    ret i1 false
;
  ret i1 true
}

; FIXME: We shouldn't unswitch this loop!
define void @foo() {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 true, label [[ENTRY_SPLIT_US:%.*]], label [[ENTRY_SPLIT:%.*]]
; CHECK:       entry.split.us:
; CHECK-NEXT:    br label [[HEADER_US:%.*]]
; CHECK:       header.us:
; CHECK-NEXT:    [[VAL_US:%.*]] = select i1 true, i1 true, i1 false
; CHECK-NEXT:    br label [[EXIT_SPLIT_US:%.*]]
; CHECK:       exit.split.us:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[VAL:%.*]] = select i1 false, i1 false, i1 false
; CHECK-NEXT:    br label [[HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %header

header:
  %val = select i1 true, i1 true, i1 false
  br i1 %val, label %exit, label %header

exit:
  ret void
}
