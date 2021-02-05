; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-reduce -S | FileCheck %s

target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128-ni:1-p2:32:8:8:32-ni:2"
target triple = "x86_64-unknown-linux-gnu"

; FIXME: iv.next is supposed to be inserted in the backedge.
define i32 @test_01(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[P:%.*]], i64 -1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ], [ [[LEN:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nsw i64 [[IV]], -1
; CHECK-NEXT:    [[COND_1:%.*]] = icmp eq i64 [[IV]], 0
; CHECK-NEXT:    br i1 [[COND_1]], label [[EXIT:%.*]], label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[SCEVGEP1:%.*]] = getelementptr i32, i32* [[SCEVGEP]], i64 [[IV]]
; CHECK-NEXT:    [[LOADED:%.*]] = load atomic i32, i32* [[SCEVGEP1]] unordered, align 4
; CHECK-NEXT:    [[COND_2:%.*]] = icmp eq i32 [[LOADED]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[COND_2]], label [[FAILURE:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 -1
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ %len, %entry ]
  %iv.next = add nsw i64 %iv, -1
  %cond_1 = icmp eq i64 %iv, 0
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %addr = getelementptr inbounds i32, i32* %p, i64 %iv.next
  %loaded = load atomic i32, i32* %addr unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}

define i32 @test_02(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: @test_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[P:%.*]], i64 -1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[BACKEDGE:%.*]] ], [ [[LEN:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[COND_1:%.*]] = icmp eq i64 [[LSR_IV]], 0
; CHECK-NEXT:    br i1 [[COND_1]], label [[EXIT:%.*]], label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[SCEVGEP1:%.*]] = getelementptr i32, i32* [[SCEVGEP]], i64 [[LSR_IV]]
; CHECK-NEXT:    [[LOADED:%.*]] = load atomic i32, i32* [[SCEVGEP1]] unordered, align 4
; CHECK-NEXT:    [[COND_2:%.*]] = icmp eq i32 [[LOADED]], [[X:%.*]]
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -1
; CHECK-NEXT:    br i1 [[COND_2]], label [[FAILURE:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 -1
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  %start = add i64 %len, -1
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ %start, %entry ]
  %iv.next = add nsw i64 %iv, -1
  %iv.offset = add i64 %iv, 1
  %iv.next.offset = add i64 %iv.next, 1
  %cond_1 = icmp eq i64 %iv.offset, 0
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %addr = getelementptr inbounds i32, i32* %p, i64 %iv.next.offset
  %loaded = load atomic i32, i32* %addr unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}

define i32 @test_03(i32* %p, i64 %len, i32 %x) {
; CHECK-LABEL: @test_03(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr i32, i32* [[P:%.*]], i64 -1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi i64 [ [[LSR_IV_NEXT:%.*]], [[BACKEDGE:%.*]] ], [ [[LEN:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[COND_1:%.*]] = icmp eq i64 [[LSR_IV]], 0
; CHECK-NEXT:    br i1 [[COND_1]], label [[EXIT:%.*]], label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[SCEVGEP1:%.*]] = getelementptr i32, i32* [[SCEVGEP]], i64 [[LSR_IV]]
; CHECK-NEXT:    [[LOADED:%.*]] = load atomic i32, i32* [[SCEVGEP1]] unordered, align 4
; CHECK-NEXT:    [[COND_2:%.*]] = icmp eq i32 [[LOADED]], [[X:%.*]]
; CHECK-NEXT:    [[LSR_IV_NEXT]] = add i64 [[LSR_IV]], -1
; CHECK-NEXT:    br i1 [[COND_2]], label [[FAILURE:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 -1
; CHECK:       failure:
; CHECK-NEXT:    unreachable
;
entry:
  %start = add i64 %len, -100
  br label %loop

loop:                                             ; preds = %backedge, %entry
  %iv = phi i64 [ %iv.next, %backedge ], [ %start, %entry ]
  %iv.next = add nsw i64 %iv, -1
  %iv.offset = add i64 %iv, 100
  %iv.next.offset = add i64 %iv.next, 100
  %cond_1 = icmp eq i64 %iv.offset, 0
  br i1 %cond_1, label %exit, label %backedge

backedge:                                         ; preds = %loop
  %addr = getelementptr inbounds i32, i32* %p, i64 %iv.next.offset
  %loaded = load atomic i32, i32* %addr unordered, align 4
  %cond_2 = icmp eq i32 %loaded, %x
  br i1 %cond_2, label %failure, label %loop

exit:                                             ; preds = %loop
  ret i32 -1

failure:                                          ; preds = %backedge
  unreachable
}
