; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-bound-split -S < %s | FileCheck %s

; Previously, it caused compiler crash from verifier.
; The phi node in exit block should be updated properly.

define i16 @test_int() {
; CHECK-LABEL: @test_int(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[ENTRY_SPLIT:%.*]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i16 [ 0, [[ENTRY_SPLIT]] ], [ [[ADD:%.*]], [[COND_END:%.*]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i16 [[I]], 3
; CHECK-NEXT:    br i1 true, label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.false:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[CALL:%.*]] = call i16 @foo()
; CHECK-NEXT:    [[ADD]] = add nuw nsw i16 [[I]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i16 [[I]], 3
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_BODY]], label [[ENTRY_SPLIT_SPLIT:%.*]]
; CHECK:       entry.split.split:
; CHECK-NEXT:    [[CALL_LCSSA1:%.*]] = phi i16 [ [[CALL]], [[COND_END]] ]
; CHECK-NEXT:    [[I_LCSSA:%.*]] = phi i16 [ [[I]], [[COND_END]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ne i16 [[I_LCSSA]], 11
; CHECK-NEXT:    br i1 [[TMP0]], label [[FOR_BODY_SPLIT_PREHEADER:%.*]], label [[END:%.*]]
; CHECK:       for.body.split.preheader:
; CHECK-NEXT:    br label [[FOR_BODY_SPLIT:%.*]]
; CHECK:       for.body.split:
; CHECK-NEXT:    [[I_SPLIT:%.*]] = phi i16 [ [[ADD_SPLIT:%.*]], [[COND_END_SPLIT:%.*]] ], [ 0, [[FOR_BODY_SPLIT_PREHEADER]] ]
; CHECK-NEXT:    [[CMP1_SPLIT:%.*]] = icmp ult i16 [[I_SPLIT]], 3
; CHECK-NEXT:    br i1 false, label [[COND_TRUE_SPLIT:%.*]], label [[COND_FALSE_SPLIT:%.*]]
; CHECK:       cond.false.split:
; CHECK-NEXT:    br label [[COND_END_SPLIT]]
; CHECK:       cond.true.split:
; CHECK-NEXT:    br label [[COND_END_SPLIT]]
; CHECK:       cond.end.split:
; CHECK-NEXT:    [[CALL_SPLIT:%.*]] = call i16 @foo()
; CHECK-NEXT:    [[ADD_SPLIT]] = add nuw nsw i16 [[I_SPLIT]], 1
; CHECK-NEXT:    [[CMP2_SPLIT:%.*]] = icmp ult i16 [[I_SPLIT]], 11
; CHECK-NEXT:    br i1 [[CMP2_SPLIT]], label [[FOR_BODY_SPLIT]], label [[END_LOOPEXIT:%.*]]
; CHECK:       end.loopexit:
; CHECK-NEXT:    [[CALL_LCSSA_PH:%.*]] = phi i16 [ [[CALL_SPLIT]], [[COND_END_SPLIT]] ]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[CALL_LCSSA:%.*]] = phi i16 [ [[CALL_LCSSA1]], [[ENTRY_SPLIT_SPLIT]] ], [ [[CALL_LCSSA_PH]], [[END_LOOPEXIT]] ]
; CHECK-NEXT:    ret i16 [[CALL_LCSSA]]
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %cond.end
  %i = phi i16 [ 0, %entry ], [ %add, %cond.end ]
  %cmp1 = icmp ult i16 %i, 3
  br i1 %cmp1, label %cond.true, label %cond.false

cond.true:                                        ; preds = %for.body
  br label %cond.end

cond.false:                                       ; preds = %for.body
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %call = call i16 @foo()
  %add = add nuw nsw i16 %i, 1
  %cmp2 = icmp ult i16 %i, 11
  br i1 %cmp2, label %for.body, label %end

end:                                              ; preds = %cond.end
  ret i16 %call
}

declare i16 @foo()
