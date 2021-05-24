; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; ModuleID = 'bugpoint-reduced-simplified.bc'
; RUN: opt < %s -newgvn -S | FileCheck %s
source_filename = "bugpoint-output-e4c7d0f.bc"

;  Make sure we still properly resolve phi cycles when they involve predicateinfo copies of phis.
define void @hoge() local_unnamed_addr #0 {
; CHECK-LABEL: @hoge(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 undef, label [[BB6:%.*]], label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB6]]
; CHECK:       bb2:
; CHECK-NEXT:    br i1 true, label [[BB3:%.*]], label [[BB6]]
; CHECK:       bb3:
; CHECK-NEXT:    br label [[BB4:%.*]]
; CHECK:       bb4:
; CHECK-NEXT:    br i1 undef, label [[BB2:%.*]], label [[BB6]]
; CHECK:       bb6:
; CHECK-NEXT:    br label [[BB4]]
;
bb:
  br i1 undef, label %bb6, label %bb1

bb1:                                              ; preds = %bb
  br label %bb6

bb2:                                              ; preds = %bb4
  %tmp = icmp slt i8 %tmp5, 7
  br i1 %tmp, label %bb3, label %bb6

bb3:                                              ; preds = %bb2
  br label %bb4

bb4:                                              ; preds = %bb6, %bb3
  %tmp5 = phi i8 [ %tmp5, %bb3 ], [ %tmp7, %bb6 ]
  br i1 undef, label %bb2, label %bb6

bb6:                                              ; preds = %bb4, %bb2, %bb1, %bb
  %tmp7 = phi i8 [ %tmp5, %bb4 ], [ %tmp5, %bb2 ], [ 5, %bb1 ], [ undef, %bb ]
  br label %bb4
}

attributes #0 = { norecurse noreturn nounwind ssp uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="all" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+fxsr,+mmx,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 6.0.0"}
