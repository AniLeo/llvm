; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=newgvn -S | FileCheck %s

@g_20 = external global i32, align 4

define void @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[STOREMERGE:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[ADD1:%.*]], [[CRITEDGE:%.*]] ]
; CHECK-NEXT:    store i32 [[STOREMERGE]], i32* @g_20, align 4
; CHECK-NEXT:    [[CMP0:%.*]] = icmp eq i32 [[STOREMERGE]], 0
; CHECK-NEXT:    br i1 [[CMP0]], label [[LR_PH:%.*]], label [[CRITEDGE]]
; CHECK:       lr.ph:
; CHECK-NEXT:    [[LV:%.*]] = load i64, i64* inttoptr (i64 16 to i64*), align 16
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i64 [[LV]], 0
; CHECK-NEXT:    br i1 [[CMP1]], label [[PREHEADER_SPLIT:%.*]], label [[CRITEDGE]]
; CHECK:       preheader.split:
; CHECK-NEXT:    br label [[PREHEADER_SPLIT]]
; CHECK:       critedge:
; CHECK-NEXT:    [[PHIOFOPS1:%.*]] = phi i1 [ false, [[BB1]] ], [ true, [[LR_PH]] ]
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi i1 [ [[CMP0]], [[BB1]] ], [ true, [[LR_PH]] ]
; CHECK-NEXT:    [[DOT05_LCSSA:%.*]] = phi i32 [ 0, [[BB1]] ], [ -1, [[LR_PH]] ]
; CHECK-NEXT:    [[ADD1]] = add nsw i32 [[STOREMERGE]], -1
; CHECK-NEXT:    br i1 [[PHIOFOPS]], label [[BB1]], label [[END:%.*]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  br label %bb1

bb1:                                      ; preds = %critedge, %entry
  %storemerge = phi i32 [ 0, %entry ], [ %add1, %critedge ]
  store i32 %storemerge, i32* @g_20, align 4
  %cmp0 = icmp eq i32 %storemerge, 0
  br i1 %cmp0, label %lr.ph, label %critedge

lr.ph:                                           ; preds = %bb1
  %lv = load i64, i64* inttoptr (i64 16 to i64*), align 16
  %cmp1 = icmp eq i64 %lv, 0
  br i1 %cmp1, label %preheader.split, label %critedge

preheader.split:                                 ; preds = %lr.ph, %preheader.split
  br label %preheader.split

critedge:                                        ; preds = %lr.ph, %bb1
  %.05.lcssa = phi i32 [ 0, %bb1 ], [ -1, %lr.ph ]
  %cmp2 = icmp ne i32 %.05.lcssa, 0
  %brmerge = or i1 %cmp0, %cmp2
  %add1 = add nsw i32 %storemerge, -1
  br i1 %brmerge, label %bb1, label %end

end:
  ret void
}

; In this test case a temporary PhiOfOps node gets moved to BB with more
; predecessors, so a new one needs to be created.
define void @test2() {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[STOREMERGE:%.*]] = phi i32 [ 0, [[TMP0:%.*]] ], [ [[ADD:%.*]], [[CRITEDGE:%.*]] ]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[STOREMERGE]], 0
; CHECK-NEXT:    br i1 [[CMP1]], label [[LR_PH:%.*]], label [[CRITEDGE]]
; CHECK:       lr.ph:
; CHECK-NEXT:    br i1 undef, label [[SPLIT1:%.*]], label [[SPLIT2:%.*]]
; CHECK:       split1:
; CHECK-NEXT:    br label [[CRITEDGE]]
; CHECK:       split2:
; CHECK-NEXT:    br label [[CRITEDGE]]
; CHECK:       critedge:
; CHECK-NEXT:    [[PHIOFOPS1:%.*]] = phi i1 [ false, [[BB1]] ], [ true, [[SPLIT2]] ], [ true, [[SPLIT1]] ]
; CHECK-NEXT:    [[PHIOFOPS:%.*]] = phi i1 [ [[CMP1]], [[BB1]] ], [ true, [[SPLIT2]] ], [ true, [[SPLIT1]] ]
; CHECK-NEXT:    [[LCSSA:%.*]] = phi i32 [ 0, [[BB1]] ], [ -1, [[SPLIT1]] ], [ -1, [[SPLIT2]] ]
; CHECK-NEXT:    [[ADD]] = add nsw i32 [[STOREMERGE]], -1
; CHECK-NEXT:    br i1 [[PHIOFOPS]], label [[BB1]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  br label %bb1

bb1:                                      ; preds = %critedge, %0
  %storemerge = phi i32 [ 0, %0 ], [ %add, %critedge ]
  %cmp1 = icmp eq i32 %storemerge, 0
  br i1 %cmp1, label %lr.ph, label %critedge

lr.ph:                                           ; preds = %bb1
  br i1 undef, label %split1, label %split2

split1:                                     ; preds = %lr.ph
  br label %critedge

split2:                                     ; preds = %lr.ph
  br label %critedge

critedge:                                        ; preds = %split1, %split2, %bb1
  %lcssa = phi i32 [ 0, %bb1 ], [ -1, %split1 ], [ -1, %split2 ]
  %cmp2 = icmp ne i32 %lcssa, 0
  %brmerge = or i1 %cmp1, %cmp2
  %add = add nsw i32 %storemerge, -1
  br i1 %brmerge, label %bb1, label %exit

exit:                                      ; preds = %critedge
  ret void
}
