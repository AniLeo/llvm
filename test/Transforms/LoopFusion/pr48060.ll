; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-fusion < %s | FileCheck %s
; RUN: opt -S -loop-fusion -pass-remarks-output=%t < %s
; RUN: FileCheck --input-file=%t %s --check-prefix REMARKS

define dso_local void @pr48060(i1 %cond) {
; CHECK-LABEL: @pr48060(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_1_PH:%.*]]
; CHECK:       for.1.ph:
; CHECK-NEXT:    br label [[FOR_1:%.*]]
; CHECK:       for.1:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[FOR_1_PH]] ], [ [[I_NEXT:%.*]], [[FOR_1]] ]
; CHECK-NEXT:    [[I_NEXT]] = add i32 [[I]], 1
; CHECK-NEXT:    [[COND_1:%.*]] = icmp eq i32 [[I_NEXT]], 10
; CHECK-NEXT:    br i1 [[COND_1]], label [[FOR_1_EXIT:%.*]], label [[FOR_1]]
; CHECK:       for.1.exit:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[END:%.*]], label [[FOR_2_PH:%.*]]
; CHECK:       for.2.ph:
; CHECK-NEXT:    br label [[FOR_2:%.*]]
; CHECK:       for.2:
; CHECK-NEXT:    [[J:%.*]] = phi i32 [ 0, [[FOR_2_PH]] ], [ [[J_NEXT:%.*]], [[FOR_2]] ]
; CHECK-NEXT:    [[J_NEXT]] = add i32 [[J]], 1
; CHECK-NEXT:    [[COND_2:%.*]] = icmp eq i32 [[J_NEXT]], 10
; CHECK-NEXT:    br i1 [[COND_2]], label [[FOR_2_EXIT:%.*]], label [[FOR_2]]
; CHECK:       for.2.exit:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;

; REMARKS:      --- !Missed
; REMARKS-NEXT: Pass:            loop-fusion
; REMARKS-NEXT: Name:            OnlySecondCandidateIsGuarded
; REMARKS-NEXT: Function:        pr48060
; REMARKS-NEXT: Args:
; REMARKS:        - Cand1:           for.1.ph
; REMARKS:        - Cand2:           for.2.ph
; REMARKS:        - String:          The second candidate is guarded while the first one is not
entry:
  br label %for.1.ph

for.1.ph:                                         ; preds = %entry
  br label %for.1

for.1:                                            ; preds = %for.1, %for.1.ph
  %i = phi i32 [ 0, %for.1.ph ], [ %i.next, %for.1 ]
  %i.next = add i32 %i, 1
  %cond.1 = icmp eq i32 %i.next, 10
  br i1 %cond.1, label %for.1.exit, label %for.1

for.1.exit:                                       ; preds = %for.1
  br i1 %cond, label %end, label %for.2.ph

for.2.ph:                                         ; preds = %for.1.exit
  br label %for.2

for.2:                                            ; preds = %for.2, %for.2.ph
  %j = phi i32 [ 0, %for.2.ph ], [ %j.next, %for.2 ]
  %j.next = add i32 %j, 1
  %cond.2 = icmp eq i32 %j.next, 10
  br i1 %cond.2, label %for.2.exit, label %for.2

for.2.exit:                                       ; preds = %for.2
  br label %end

end:                                              ; preds = %for.1.exit, %for.2.exit
  ret void
}
