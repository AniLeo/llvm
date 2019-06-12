; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -indvars < %s | FileCheck %s

define i16 @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP1:%.*]]
; CHECK:       loop1:
; CHECK-NEXT:    [[L1:%.*]] = phi i16 [ 0, [[ENTRY:%.*]] ], [ [[L1_ADD:%.*]], [[LOOP1]] ]
; CHECK-NEXT:    [[L1_ADD]] = add nuw nsw i16 [[L1]], 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i16 [[L1_ADD]], 2
; CHECK-NEXT:    br i1 [[CMP1]], label [[LOOP1]], label [[LOOP2_PREHEADER:%.*]]
; CHECK:       loop2.preheader:
; CHECK-NEXT:    br label [[LOOP2:%.*]]
; CHECK:       loop2:
; CHECK-NEXT:    [[K2:%.*]] = phi i16 [ [[K2_ADD:%.*]], [[LOOP2]] ], [ 182, [[LOOP2_PREHEADER]] ]
; CHECK-NEXT:    [[L2:%.*]] = phi i16 [ [[L2_ADD:%.*]], [[LOOP2]] ], [ 0, [[LOOP2_PREHEADER]] ]
; CHECK-NEXT:    [[L2_ADD]] = add nuw nsw i16 [[L2]], 1
; CHECK-NEXT:    tail call void @foo(i16 [[K2]])
; CHECK-NEXT:    [[K2_ADD]] = add nuw nsw i16 [[K2]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i16 [[L2_ADD]], 2
; CHECK-NEXT:    br i1 [[CMP2]], label [[LOOP2]], label [[LOOP2_END:%.*]]
; CHECK:       loop2.end:
; CHECK-NEXT:    ret i16 184
;
entry:
  br label %loop1

loop1:                                           ; preds = %entry, %loop1
  %k1 = phi i16 [ 180, %entry ], [ %k1.add, %loop1 ]
  %l1 = phi i16 [ 0, %entry ], [ %l1.add, %loop1 ]
  %k1.add = add nuw nsw i16 %k1, 1
  %l1.add = add nuw nsw i16 %l1, 1
  %cmp1 = icmp ult i16 %l1.add, 2
  br i1 %cmp1, label %loop1, label %loop2.preheader

loop2.preheader:                                 ; preds = %loop1
  %k1.add.lcssa = phi i16 [ %k1.add, %loop1 ]
  br label %loop2

loop2:                                           ; preds = %loop2.preheader, %loop2
  %k2 = phi i16 [ %k2.add, %loop2 ], [ %k1.add.lcssa, %loop2.preheader ]
  %l2 = phi i16 [ %l2.add, %loop2 ], [ 0, %loop2.preheader ]
  %l2.add = add nuw i16 %l2, 1
  tail call void @foo(i16 %k2)
  %k2.add = add nuw nsw i16 %k2, 1
  %cmp2 = icmp ult i16 %l2.add, 2
  br i1 %cmp2, label %loop2, label %loop2.end

loop2.end:                                       ; preds = %loop2
  %k2.add.lcssa = phi i16 [ %k2.add, %loop2 ]
  ret i16 %k2.add.lcssa
}

declare void @foo(i16)
