; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-vectorize -force-vector-width=2 < %s | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

define void @bottom_tested(i16* %p, i32 %n) {
; CHECK-LABEL: @bottom_tested(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = icmp sgt i32 [[N:%.*]], 0
; CHECK-NEXT:    [[SMAX:%.*]] = select i1 [[TMP0]], i32 [[N]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = add nuw i32 [[SMAX]], 1
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[TMP1]], 2
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[TMP1]], 2
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[TMP1]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = sext i32 [[TMP2]] to i64
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i16, i16* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i16* [[TMP5]] to <2 x i16>*
; CHECK-NEXT:    store <2 x i16> zeroinitializer, <2 x i16>* [[TMP6]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i32 [[INDEX]], 2
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], [[LOOP0:!llvm.loop !.*]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[TMP1]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[IF_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INC:%.*]], [[FOR_COND]] ]
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P]], i64 [[IPROM]]
; CHECK-NEXT:    store i16 0, i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I]], [[N]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_COND]], label [[IF_END]], [[LOOP2:!llvm.loop !.*]]
; CHECK:       if.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.cond ]
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  store i16 0, i16* %b, align 4
  %inc = add nsw i32 %i, 1
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %for.cond, label %if.end

if.end:
  ret void
}

define void @early_exit(i16* %p, i32 %n) {
; CHECK-LABEL: @early_exit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[IF_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[IPROM]]
; CHECK-NEXT:    store i16 0, i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       if.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %for.body, label %if.end

for.body:
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  store i16 0, i16* %b, align 4
  %inc = add nsw i32 %i, 1
  br label %for.cond

if.end:
  ret void
}


; multiple exit - no values inside the loop used outside
define void @multiple_unique_exit(i16* %p, i32 %n) {
; CHECK-LABEL: @multiple_unique_exit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[IF_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[IPROM]]
; CHECK-NEXT:    store i16 0, i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[I]], 2096
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_COND]], label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %for.body, label %if.end

for.body:
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  store i16 0, i16* %b, align 4
  %inc = add nsw i32 %i, 1
  %cmp2 = icmp slt i32 %i, 2096
  br i1 %cmp2, label %for.cond, label %if.end

if.end:
  ret void
}

; multiple exit - with an lcssa phi
define i32 @multiple_unique_exit2(i16* %p, i32 %n) {
; CHECK-LABEL: @multiple_unique_exit2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[IF_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[IPROM]]
; CHECK-NEXT:    store i16 0, i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[I]], 2096
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_COND]], label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[I_LCSSA:%.*]] = phi i32 [ [[I]], [[FOR_BODY]] ], [ [[I]], [[FOR_COND]] ]
; CHECK-NEXT:    ret i32 [[I_LCSSA]]
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %for.body, label %if.end

for.body:
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  store i16 0, i16* %b, align 4
  %inc = add nsw i32 %i, 1
  %cmp2 = icmp slt i32 %i, 2096
  br i1 %cmp2, label %for.cond, label %if.end

if.end:
  ret i32 %i
}

; multiple exit w/a non lcssa phi
define i32 @multiple_unique_exit3(i16* %p, i32 %n) {
; CHECK-LABEL: @multiple_unique_exit3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[IF_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[IPROM]]
; CHECK-NEXT:    store i16 0, i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[I]], 2096
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_COND]], label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[EXIT:%.*]] = phi i32 [ 0, [[FOR_COND]] ], [ 1, [[FOR_BODY]] ]
; CHECK-NEXT:    ret i32 [[EXIT]]
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %for.body, label %if.end

for.body:
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  store i16 0, i16* %b, align 4
  %inc = add nsw i32 %i, 1
  %cmp2 = icmp slt i32 %i, 2096
  br i1 %cmp2, label %for.cond, label %if.end

if.end:
  %exit = phi i32 [0, %for.cond], [1, %for.body]
  ret i32 %exit
}

; multiple exits w/distinct target blocks
define i32 @multiple_exit_blocks(i16* %p, i32 %n) {
; CHECK-LABEL: @multiple_exit_blocks(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_BODY:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[I]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[IF_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[IPROM]]
; CHECK-NEXT:    store i16 0, i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp slt i32 [[I]], 2096
; CHECK-NEXT:    br i1 [[CMP2]], label [[FOR_COND]], label [[IF_END2:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    ret i32 0
; CHECK:       if.end2:
; CHECK-NEXT:    ret i32 1
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %for.body, label %if.end

for.body:
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  store i16 0, i16* %b, align 4
  %inc = add nsw i32 %i, 1
  %cmp2 = icmp slt i32 %i, 2096
  br i1 %cmp2, label %for.cond, label %if.end2

if.end:
  ret i32 0

if.end2:
  ret i32 1
}

; unique exit case but with a switch as two edges between the same pair of
; blocks is an often missed edge case
define i32 @multiple_exit_switch(i16* %p, i32 %n) {
; CHECK-LABEL: @multiple_exit_switch(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_COND]] ]
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[IPROM]]
; CHECK-NEXT:    store i16 0, i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    switch i32 [[I]], label [[FOR_COND]] [
; CHECK-NEXT:    i32 2096, label [[IF_END:%.*]]
; CHECK-NEXT:    i32 2097, label [[IF_END]]
; CHECK-NEXT:    ]
; CHECK:       if.end:
; CHECK-NEXT:    [[I_LCSSA:%.*]] = phi i32 [ [[I]], [[FOR_COND]] ], [ [[I]], [[FOR_COND]] ]
; CHECK-NEXT:    ret i32 [[I_LCSSA]]
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.cond ]
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  store i16 0, i16* %b, align 4
  %inc = add nsw i32 %i, 1
  switch i32 %i, label %for.cond [
  i32 2096, label %if.end
  i32 2097, label %if.end
  ]

if.end:
  ret i32 %i
}

; multiple exit case but with a switch as multiple exiting edges from
; a single block is a commonly missed edge case
define i32 @multiple_exit_switch2(i16* %p, i32 %n) {
; CHECK-LABEL: @multiple_exit_switch2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[FOR_COND]] ]
; CHECK-NEXT:    [[IPROM:%.*]] = sext i32 [[I]] to i64
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds i16, i16* [[P:%.*]], i64 [[IPROM]]
; CHECK-NEXT:    store i16 0, i16* [[B]], align 4
; CHECK-NEXT:    [[INC]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    switch i32 [[I]], label [[FOR_COND]] [
; CHECK-NEXT:    i32 2096, label [[IF_END:%.*]]
; CHECK-NEXT:    i32 2097, label [[IF_END2:%.*]]
; CHECK-NEXT:    ]
; CHECK:       if.end:
; CHECK-NEXT:    ret i32 0
; CHECK:       if.end2:
; CHECK-NEXT:    ret i32 1
;
entry:
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.cond ]
  %iprom = sext i32 %i to i64
  %b = getelementptr inbounds i16, i16* %p, i64 %iprom
  store i16 0, i16* %b, align 4
  %inc = add nsw i32 %i, 1
  switch i32 %i, label %for.cond [
  i32 2096, label %if.end
  i32 2097, label %if.end2
  ]

if.end:
  ret i32 0

if.end2:
  ret i32 1
}
