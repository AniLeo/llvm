; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -enable-loop-simplifycfg-term-folding=true -passes='require<domtree>,loop(loop-simplifycfg)' -verify-loop-info -verify-dom-info -verify-loop-lcssa < %s | FileCheck %s
; RUN: opt -S -enable-loop-simplifycfg-term-folding=true -loop-simplifycfg -verify-memoryssa -verify-loop-info -verify-dom-info -verify-loop-lcssa < %s | FileCheck %s

target datalayout = "e-m:e-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128"

define void @c() {
; CHECK-LABEL: @c(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[D:%.*]]
; CHECK:       d.loopexit:
; CHECK-NEXT:    [[DOTLCSSA:%.*]] = phi i32 [ [[TMP1:%.*]], [[FOR_COND:%.*]] ]
; CHECK-NEXT:    br label [[D]]
; CHECK:       d:
; CHECK-NEXT:    [[TMP0:%.*]] = phi i32 [ undef, [[ENTRY:%.*]] ], [ [[DOTLCSSA]], [[D_LOOPEXIT:%.*]] ]
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[TMP1]] = phi i32 [ [[TMP0]], [[D]] ], [ 0, [[IF_END:%.*]] ]
; CHECK-NEXT:    [[TOBOOL2:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[TOBOOL2]], label [[IF_END]], label [[D_LOOPEXIT]]
; CHECK:       if.end:
; CHECK-NEXT:    br label [[FOR_COND]]
;
entry:
  br label %d

d.loopexit:                                       ; preds = %if.end.7, %for.body
  %.lcssa = phi i32 [ %1, %for.body ], [ 0, %if.end.7 ]
  br label %d

d:                                                ; preds = %d.loopexit, %entry
  %0 = phi i32 [ undef, %entry ], [ %.lcssa, %d.loopexit ]
  br label %for.cond

for.cond:                                         ; preds = %if.end.8, %d
  %1 = phi i32 [ %0, %d ], [ 0, %if.end.8 ]
  br label %for.body

for.body:                                         ; preds = %for.cond
  %tobool2 = icmp eq i32 %1, 0
  br i1 %tobool2, label %if.end, label %d.loopexit

if.end:                                           ; preds = %for.body
  br label %if.end.7

if.end.7:                                         ; preds = %if.end
  br i1 true, label %if.end.8, label %d.loopexit

if.end.8:                                         ; preds = %if.end.7
  br label %for.cond
}

define void @test_01() {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond.loopexit:
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[INC41_LCSSA3:%.*]] = phi i16 [ undef, [[FOR_COND_LOOPEXIT:%.*]] ], [ undef, [[ENTRY:%.*]] ]
; CHECK-NEXT:    switch i32 0, label [[FOR_COND_SPLIT:%.*]] [
; CHECK-NEXT:    i32 1, label [[FOR_COND_LOOPEXIT]]
; CHECK-NEXT:    ]
; CHECK:       for.cond.split:
; CHECK-NEXT:    [[INC41_LCSSA3_LCSSA:%.*]] = phi i16 [ [[INC41_LCSSA3]], [[FOR_COND]] ]
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    [[INC41:%.*]] = phi i16 [ [[INC4:%.*]], [[WHILE_COND]] ], [ [[INC41_LCSSA3_LCSSA]], [[FOR_COND_SPLIT]] ]
; CHECK-NEXT:    [[INC4]] = add nsw i16 [[INC41]], 1
; CHECK-NEXT:    br label [[WHILE_COND]]
;
entry:
  br label %for.cond

for.cond.loopexit:                                ; preds = %while.cond
  %inc41.lcssa = phi i16 [ %inc41, %while.cond ]
  br label %for.cond

for.cond:                                         ; preds = %for.cond.loopexit, %entry
  %inc41.lcssa3 = phi i16 [ %inc41.lcssa, %for.cond.loopexit ], [ undef, %entry ]
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.cond
  %inc41 = phi i16 [ %inc4, %while.body ], [ %inc41.lcssa3, %for.cond ]
  br i1 true, label %while.body, label %for.cond.loopexit

while.body:                                       ; preds = %while.cond
  %inc4 = add nsw i16 %inc41, 1
  br label %while.cond
}

define void @bar() {
; CHECK-LABEL: @bar(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    switch i32 0, label [[BB_SPLIT:%.*]] [
; CHECK-NEXT:    i32 1, label [[BB10:%.*]]
; CHECK-NEXT:    ]
; CHECK:       bb.split:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP:%.*]] = phi i32 [ [[TMP7:%.*]], [[BB6:%.*]] ], [ undef, [[BB_SPLIT]] ]
; CHECK-NEXT:    switch i32 undef, label [[BB5:%.*]] [
; CHECK-NEXT:    i32 0, label [[BB6]]
; CHECK-NEXT:    i32 1, label [[BB8:%.*]]
; CHECK-NEXT:    ]
; CHECK:       bb5:
; CHECK-NEXT:    ret void
; CHECK:       bb6:
; CHECK-NEXT:    [[TMP7]] = add i32 undef, 123
; CHECK-NEXT:    br label [[BB1]]
; CHECK:       bb8:
; CHECK-NEXT:    [[TMP9:%.*]] = phi i32 [ [[TMP]], [[BB1]] ]
; CHECK-NEXT:    [[USE:%.*]] = add i32 [[TMP9]], 1
; CHECK-NEXT:    ret void
; CHECK:       bb10:
; CHECK-NEXT:    ret void
;

bb:
  br label %bb1

bb1:                                              ; preds = %bb6, %bb
  %tmp = phi i32 [ %tmp7, %bb6 ], [ undef, %bb ]
  br i1 false, label %bb2, label %bb4

bb2:                                              ; preds = %bb1
  switch i32 undef, label %bb10 [
  i32 0, label %bb3
  i32 1, label %bb8
  ]

bb3:                                              ; preds = %bb2
  br label %bb6

bb4:                                              ; preds = %bb1
  switch i32 undef, label %bb5 [
  i32 0, label %bb6
  i32 1, label %bb8
  ]

bb5:                                              ; preds = %bb4
  ret void

bb6:                                              ; preds = %bb4, %bb3
  %tmp7 = add i32 undef, 123
  br label %bb1

bb8:                                              ; preds = %bb4, %bb2
  %tmp9 = phi i32 [ %tmp, %bb2 ], [ %tmp, %bb4 ]
  %use = add i32 %tmp9, 1
  ret void

bb10:                                             ; preds = %bb2
  ret void
}

define void @memlcssa() {
; CHECK-LABEL: @memlcssa(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 0, label [[ENTRY_SPLIT:%.*]] [
; CHECK-NEXT:    i32 1, label [[DEFAULT_BB:%.*]]
; CHECK-NEXT:    ]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[FOR_BODY]]
; CHECK:       default.bb:
; CHECK-NEXT:    unreachable
;
entry:
  br label %for.body

for.body:                                         ; preds = %exit, %entry
  br label %switch.bb

switch.bb:                                        ; preds = %for.body
  switch i2 1, label %default.bb [
  i2 1, label %case.bb
  ]

case.bb:                                          ; preds = %switch
  br label %exit

default.bb:                                       ; preds = %switch
  unreachable

exit:                                             ; preds = %case.bb
  call void @foo()
  br label %for.body
}

declare void @foo()
