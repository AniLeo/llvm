; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-unroll -simplifycfg -instcombine -simplifycfg -S -mtriple arm-none-eabi -mcpu=cortex-m7 %s | FileCheck %s

; This test is meant to check that this loop is unrolled into three iterations.
define void @test(i32* %x, i32 %n) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = add nsw i32 [[N:%.*]], -1
; CHECK-NEXT:    [[REM:%.*]] = srem i32 [[SUB]], 4
; CHECK-NEXT:    [[CMP7:%.*]] = icmp sgt i32 [[REM]], 0
; CHECK-NEXT:    br i1 [[CMP7]], label [[WHILE_BODY:%.*]], label [[WHILE_END:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[X:%.*]], align 4
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[TMP0]], 10
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 0, i32* [[X]], align 4
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[INCDEC_PTR:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[REM]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[WHILE_BODY_1:%.*]], label [[WHILE_END]]
; CHECK:       while.end:
; CHECK-NEXT:    ret void
; CHECK:       while.body.1:
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[INCDEC_PTR]], align 4
; CHECK-NEXT:    [[CMP1_1:%.*]] = icmp slt i32 [[TMP1]], 10
; CHECK-NEXT:    br i1 [[CMP1_1]], label [[IF_THEN_1:%.*]], label [[IF_END_1:%.*]]
; CHECK:       if.then.1:
; CHECK-NEXT:    store i32 0, i32* [[INCDEC_PTR]], align 4
; CHECK-NEXT:    br label [[IF_END_1]]
; CHECK:       if.end.1:
; CHECK-NEXT:    [[INCDEC_PTR_1:%.*]] = getelementptr inbounds i32, i32* [[X]], i64 2
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp sgt i32 [[REM]], 2
; CHECK-NEXT:    br i1 [[CMP_1]], label [[WHILE_BODY_2:%.*]], label [[WHILE_END]]
; CHECK:       while.body.2:
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[INCDEC_PTR_1]], align 4
; CHECK-NEXT:    [[CMP1_2:%.*]] = icmp slt i32 [[TMP2]], 10
; CHECK-NEXT:    br i1 [[CMP1_2]], label [[IF_THEN_2:%.*]], label [[WHILE_END]]
; CHECK:       if.then.2:
; CHECK-NEXT:    store i32 0, i32* [[INCDEC_PTR_1]], align 4
; CHECK-NEXT:    br label [[WHILE_END]]
;
entry:
  %sub = add nsw i32 %n, -1
  %rem = srem i32 %sub, 4
  %cmp7 = icmp sgt i32 %rem, 0
  br i1 %cmp7, label %while.body, label %while.end

while.body:                                       ; preds = %entry, %if.end
  %x.addr.09 = phi i32* [ %incdec.ptr, %if.end ], [ %x, %entry ]
  %n.addr.08 = phi i32 [ %dec, %if.end ], [ %rem, %entry ]
  %0 = load i32, i32* %x.addr.09, align 4
  %cmp1 = icmp slt i32 %0, 10
  br i1 %cmp1, label %if.then, label %if.end

if.then:                                          ; preds = %while.body
  store i32 0, i32* %x.addr.09, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %while.body
  %incdec.ptr = getelementptr inbounds i32, i32* %x.addr.09, i32 1
  %dec = add nsw i32 %n.addr.08, -1
  %cmp = icmp sgt i32 %dec, 0
  br i1 %cmp, label %while.body, label %while.end

while.end:                                        ; preds = %if.end, %entry
  ret void
}

; Larger test that is still fully unrolled, thanks in part to the constant data and the max upper bound.
@data = internal constant [50 x i32] [i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15, i32 16, i32 17, i32 18, i32 19, i32 20, i32 21, i32 22, i32 23, i32 24, i32 25, i32 26, i32 27, i32 28, i32 29, i32 30, i32 31, i32 32, i32 33, i32 34, i32 35, i32 36, i32 37, i32 38, i32 39, i32 40, i32 41, i32 42, i32 43, i32 44, i32 45, i32 46, i32 47, i32 48, i32 49, i32 50], align 4
define i32 @test2(i32 %l86) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[L86_OFF:%.*]] = add i32 [[L86:%.*]], -1
; CHECK-NEXT:    [[SWITCH:%.*]] = icmp ult i32 [[L86_OFF]], 24
; CHECK-NEXT:    [[DOTNOT30:%.*]] = icmp ne i32 [[L86]], 25
; CHECK-NEXT:    [[SPEC_SELECT24:%.*]] = zext i1 [[DOTNOT30]] to i32
; CHECK-NEXT:    [[COMMON_RET31_OP:%.*]] = select i1 [[SWITCH]], i32 0, i32 [[SPEC_SELECT24]]
; CHECK-NEXT:    ret i32 [[COMMON_RET31_OP]]
;
entry:
  br label %for.body.i.i

for.body.i.i:                                     ; preds = %for.body.i.i.preheader, %for.inc.i.3.i
  %i.0137.i.i = phi i32 [ %add.i.3.i, %for.inc.i.3.i ], [ 0, %entry ]
  %add.i.i = or i32 %i.0137.i.i, 1
  %arrayidx.i.i = getelementptr inbounds i32, i32* getelementptr inbounds ([50 x i32], [50 x i32]* @data, i32 0, i32 0), i32 %add.i.i
  %l93 = load i32, i32* %arrayidx.i.i, align 4
  %cmp1.i.i = icmp sgt i32 %l93, %l86
  br i1 %cmp1.i.i, label %land.lhs.true.i.i, label %for.inc.i.i

land.lhs.true.i.i:                                ; preds = %for.body.i.i
  %arrayidx2.i.i = getelementptr inbounds i32, i32* getelementptr inbounds ([50 x i32], [50 x i32]* @data, i32 0, i32 0), i32 %i.0137.i.i
  %l94 = load i32, i32* %arrayidx2.i.i, align 4
  %cmp3.not.i.i = icmp sgt i32 %l94, %l86
  br i1 %cmp3.not.i.i, label %for.inc.i.i, label %for.end.i.if.end8.i_crit_edge.i.loopexit

for.inc.i.i:                                      ; preds = %land.lhs.true.i.i, %for.body.i.i
  %exitcond.not.i.i = icmp eq i32 %add.i.i, 25
  br i1 %exitcond.not.i.i, label %if.then6.i.i.loopexitsplit, label %for.body.i.1.i

for.body.i.1.i:                                   ; preds = %for.inc.i.i
  %add.i.1.i = or i32 %i.0137.i.i, 2
  %arrayidx.i.1.i = getelementptr inbounds i32, i32* getelementptr inbounds ([50 x i32], [50 x i32]* @data, i32 0, i32 0), i32 %add.i.1.i
  %l345 = load i32, i32* %arrayidx.i.1.i, align 4
  %cmp1.i.1.i = icmp sgt i32 %l345, %l86
  br i1 %cmp1.i.1.i, label %land.lhs.true.i.1.i, label %for.inc.i.1.i

land.lhs.true.i.1.i:                              ; preds = %for.body.i.1.i
  br i1 %cmp1.i.i, label %for.inc.i.1.i, label %for.end.i.i

for.inc.i.1.i:                                    ; preds = %land.lhs.true.i.1.i, %for.body.i.1.i
  %add.i.2.i = or i32 %i.0137.i.i, 3
  %arrayidx.i.2.i = getelementptr inbounds i32, i32* getelementptr inbounds ([50 x i32], [50 x i32]* @data, i32 0, i32 0), i32 %add.i.2.i
  %l346 = load i32, i32* %arrayidx.i.2.i, align 4
  %cmp1.i.2.i = icmp sgt i32 %l346, %l86
  br i1 %cmp1.i.2.i, label %land.lhs.true.i.2.i, label %for.inc.i.2.i

land.lhs.true.i.2.i:                              ; preds = %for.inc.i.1.i
  br i1 %cmp1.i.1.i, label %for.inc.i.2.i, label %for.end.i.if.end8.i_crit_edge.i.loopexit

for.inc.i.2.i:                                    ; preds = %land.lhs.true.i.2.i, %for.inc.i.1.i
  br label %for.body.i.3.i

for.body.i.3.i:                                   ; preds = %for.inc.i.2.i
  %add.i.3.i = add nuw nsw i32 %i.0137.i.i, 4
  %arrayidx.i.3.i = getelementptr inbounds i32, i32* getelementptr inbounds ([50 x i32], [50 x i32]* @data, i32 0, i32 0), i32 %add.i.3.i
  %l347 = load i32, i32* %arrayidx.i.3.i, align 4
  %cmp1.i.3.i = icmp sgt i32 %l347, %l86
  br i1 %cmp1.i.3.i, label %land.lhs.true.i.3.i, label %for.inc.i.3.i

land.lhs.true.i.3.i:                              ; preds = %for.body.i.3.i
  br i1 %cmp1.i.2.i, label %for.inc.i.3.i, label %for.end.i.i

for.inc.i.3.i:                                    ; preds = %land.lhs.true.i.3.i, %for.body.i.3.i
  br label %for.body.i.i

for.end.i.if.end8.i_crit_edge.i.loopexit:         ; preds = %land.lhs.true.i.i, %land.lhs.true.i.2.i
  %i.0.lcssa.i.i3.ph = phi i32 [ %i.0137.i.i, %land.lhs.true.i.i ], [ %add.i.1.i, %land.lhs.true.i.2.i ]
  br label %for.end.i.if.end8.i_crit_edge.i

if.then6.i.i.loopexitsplit:                       ; preds = %for.inc.i.i
  br label %if.then6.i.i.loopexit

for.end.i.i:                                      ; preds = %land.lhs.true.i.3.i, %land.lhs.true.i.1.i
  %i.0.lcssa.i.i = phi i32 [ %add.i.i, %land.lhs.true.i.1.i ], [ %add.i.2.i, %land.lhs.true.i.3.i ]
  %cmp5.i.i = icmp eq i32 %i.0.lcssa.i.i, 25
  br i1 %cmp5.i.i, label %if.then6.i.i, label %for.end.i.if.end8.i_crit_edge.i

for.end.i.if.end8.i_crit_edge.i:
  ret i32 0

if.then6.i.i.loopexit:
  ret i32 1

if.then6.i.i:
  ret i32 2
}
