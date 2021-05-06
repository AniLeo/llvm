; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt  -passes=loop-bound-split -S < %s | FileCheck %s

define void @split_loop_bound_inc_with_sgt(i64 %a, i64* noalias %src, i64* noalias %dst, i64 %n) {
; CHECK-LABEL: @split_loop_bound_inc_with_sgt(
; CHECK-NEXT:  loop.ph:
; CHECK-NEXT:    br label [[LOOP_PH_SPLIT:%.*]]
; CHECK:       loop.ph.split:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 0)
; CHECK-NEXT:    [[NEW_BOUND:%.*]] = call i64 @llvm.smin.i64(i64 [[A:%.*]], i64 [[SMAX]])
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_INC:%.*]] ], [ 0, [[LOOP_PH_SPLIT]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 true, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[SRC_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[SRC:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[VAL:%.*]] = load i64, i64* [[SRC_ARRAYIDX]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[DST:%.*]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[VAL]], i64* [[DST_ARRAYIDX]], align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp sgt i64 [[INC]], [[NEW_BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP_PH_SPLIT_SPLIT:%.*]], label [[LOOP]]
; CHECK:       loop.ph.split.split:
; CHECK-NEXT:    [[INC_LCSSA:%.*]] = phi i64 [ [[INC]], [[FOR_INC]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = icmp ne i64 [[INC_LCSSA]], [[N]]
; CHECK-NEXT:    br i1 [[TMP0]], label [[LOOP_SPLIT_PREHEADER:%.*]], label [[EXIT:%.*]]
; CHECK:       loop.split.preheader:
; CHECK-NEXT:    br label [[LOOP_SPLIT:%.*]]
; CHECK:       loop.split:
; CHECK-NEXT:    [[IV_SPLIT:%.*]] = phi i64 [ [[INC_SPLIT:%.*]], [[FOR_INC_SPLIT:%.*]] ], [ [[NEW_BOUND]], [[LOOP_SPLIT_PREHEADER]] ]
; CHECK-NEXT:    [[CMP_SPLIT:%.*]] = icmp slt i64 [[IV_SPLIT]], [[A]]
; CHECK-NEXT:    br i1 false, label [[IF_THEN_SPLIT:%.*]], label [[IF_ELSE_SPLIT:%.*]]
; CHECK:       if.else.split:
; CHECK-NEXT:    br label [[FOR_INC_SPLIT]]
; CHECK:       if.then.split:
; CHECK-NEXT:    [[SRC_ARRAYIDX_SPLIT:%.*]] = getelementptr inbounds i64, i64* [[SRC]], i64 [[IV_SPLIT]]
; CHECK-NEXT:    [[VAL_SPLIT:%.*]] = load i64, i64* [[SRC_ARRAYIDX_SPLIT]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX_SPLIT:%.*]] = getelementptr inbounds i64, i64* [[DST]], i64 [[IV_SPLIT]]
; CHECK-NEXT:    store i64 [[VAL_SPLIT]], i64* [[DST_ARRAYIDX_SPLIT]], align 4
; CHECK-NEXT:    br label [[FOR_INC_SPLIT]]
; CHECK:       for.inc.split:
; CHECK-NEXT:    [[INC_SPLIT]] = add nuw nsw i64 [[IV_SPLIT]], 1
; CHECK-NEXT:    [[COND_SPLIT:%.*]] = icmp sgt i64 [[INC_SPLIT]], [[N]]
; CHECK-NEXT:    br i1 [[COND_SPLIT]], label [[EXIT_LOOPEXIT:%.*]], label [[LOOP_SPLIT]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
loop.ph:
  br label %loop

loop:
  %iv = phi i64 [ %inc, %for.inc ], [ 0, %loop.ph ]
  %cmp = icmp slt i64 %iv, %a
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %src.arrayidx = getelementptr inbounds i64, i64* %src, i64 %iv
  %val = load i64, i64* %src.arrayidx
  %dst.arrayidx = getelementptr inbounds i64, i64* %dst, i64 %iv
  store i64 %val, i64* %dst.arrayidx
  br label %for.inc

if.else:
  br label %for.inc

for.inc:
  %inc = add nuw nsw i64 %iv, 1
  %cond = icmp sgt i64 %inc, %n
  br i1 %cond, label %exit, label %loop

exit:
  ret void
}

define void @split_loop_bound_inc_with_eq(i64 %a, i64* noalias %src, i64* noalias %dst, i64 %n) {
; CHECK-LABEL: @split_loop_bound_inc_with_eq(
; CHECK-NEXT:  loop.ph:
; CHECK-NEXT:    br label [[LOOP_PH_SPLIT:%.*]]
; CHECK:       loop.ph.split:
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[N:%.*]], -1
; CHECK-NEXT:    [[NEW_BOUND:%.*]] = call i64 @llvm.umin.i64(i64 [[A:%.*]], i64 [[TMP0]])
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_INC:%.*]] ], [ 0, [[LOOP_PH_SPLIT]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 true, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[SRC_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[SRC:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[VAL:%.*]] = load i64, i64* [[SRC_ARRAYIDX]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[DST:%.*]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[VAL]], i64* [[DST_ARRAYIDX]], align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i64 [[INC]], [[NEW_BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP_PH_SPLIT_SPLIT:%.*]], label [[LOOP]]
; CHECK:       loop.ph.split.split:
; CHECK-NEXT:    [[INC_LCSSA:%.*]] = phi i64 [ [[INC]], [[FOR_INC]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i64 [[INC_LCSSA]], [[N]]
; CHECK-NEXT:    br i1 [[TMP1]], label [[LOOP_SPLIT_PREHEADER:%.*]], label [[EXIT:%.*]]
; CHECK:       loop.split.preheader:
; CHECK-NEXT:    br label [[LOOP_SPLIT:%.*]]
; CHECK:       loop.split:
; CHECK-NEXT:    [[IV_SPLIT:%.*]] = phi i64 [ [[INC_SPLIT:%.*]], [[FOR_INC_SPLIT:%.*]] ], [ [[NEW_BOUND]], [[LOOP_SPLIT_PREHEADER]] ]
; CHECK-NEXT:    [[CMP_SPLIT:%.*]] = icmp slt i64 [[IV_SPLIT]], [[A]]
; CHECK-NEXT:    br i1 false, label [[IF_THEN_SPLIT:%.*]], label [[IF_ELSE_SPLIT:%.*]]
; CHECK:       if.else.split:
; CHECK-NEXT:    br label [[FOR_INC_SPLIT]]
; CHECK:       if.then.split:
; CHECK-NEXT:    [[SRC_ARRAYIDX_SPLIT:%.*]] = getelementptr inbounds i64, i64* [[SRC]], i64 [[IV_SPLIT]]
; CHECK-NEXT:    [[VAL_SPLIT:%.*]] = load i64, i64* [[SRC_ARRAYIDX_SPLIT]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX_SPLIT:%.*]] = getelementptr inbounds i64, i64* [[DST]], i64 [[IV_SPLIT]]
; CHECK-NEXT:    store i64 [[VAL_SPLIT]], i64* [[DST_ARRAYIDX_SPLIT]], align 4
; CHECK-NEXT:    br label [[FOR_INC_SPLIT]]
; CHECK:       for.inc.split:
; CHECK-NEXT:    [[INC_SPLIT]] = add nuw nsw i64 [[IV_SPLIT]], 1
; CHECK-NEXT:    [[COND_SPLIT:%.*]] = icmp eq i64 [[INC_SPLIT]], [[N]]
; CHECK-NEXT:    br i1 [[COND_SPLIT]], label [[EXIT_LOOPEXIT:%.*]], label [[LOOP_SPLIT]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
loop.ph:
  br label %loop

loop:
  %iv = phi i64 [ %inc, %for.inc ], [ 0, %loop.ph ]
  %cmp = icmp slt i64 %iv, %a
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %src.arrayidx = getelementptr inbounds i64, i64* %src, i64 %iv
  %val = load i64, i64* %src.arrayidx
  %dst.arrayidx = getelementptr inbounds i64, i64* %dst, i64 %iv
  store i64 %val, i64* %dst.arrayidx
  br label %for.inc

if.else:
  br label %for.inc

for.inc:
  %inc = add nuw nsw i64 %iv, 1
  %cond = icmp eq i64 %inc, %n
  br i1 %cond, label %exit, label %loop

exit:
  ret void
}

define void @split_loop_bound_inc_with_sge(i64 %a, i64* noalias %src, i64* noalias %dst, i64 %n) {
; CHECK-LABEL: @split_loop_bound_inc_with_sge(
; CHECK-NEXT:  loop.ph:
; CHECK-NEXT:    br label [[LOOP_PH_SPLIT:%.*]]
; CHECK:       loop.ph.split:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[SMAX]], -1
; CHECK-NEXT:    [[NEW_BOUND:%.*]] = call i64 @llvm.smin.i64(i64 [[A:%.*]], i64 [[TMP0]])
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_INC:%.*]] ], [ 0, [[LOOP_PH_SPLIT]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 true, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[SRC_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[SRC:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[VAL:%.*]] = load i64, i64* [[SRC_ARRAYIDX]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[DST:%.*]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[VAL]], i64* [[DST_ARRAYIDX]], align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp sge i64 [[INC]], [[NEW_BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP_PH_SPLIT_SPLIT:%.*]], label [[LOOP]]
; CHECK:       loop.ph.split.split:
; CHECK-NEXT:    [[INC_LCSSA:%.*]] = phi i64 [ [[INC]], [[FOR_INC]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i64 [[INC_LCSSA]], [[N]]
; CHECK-NEXT:    br i1 [[TMP1]], label [[LOOP_SPLIT_PREHEADER:%.*]], label [[EXIT:%.*]]
; CHECK:       loop.split.preheader:
; CHECK-NEXT:    br label [[LOOP_SPLIT:%.*]]
; CHECK:       loop.split:
; CHECK-NEXT:    [[IV_SPLIT:%.*]] = phi i64 [ [[INC_SPLIT:%.*]], [[FOR_INC_SPLIT:%.*]] ], [ [[NEW_BOUND]], [[LOOP_SPLIT_PREHEADER]] ]
; CHECK-NEXT:    [[CMP_SPLIT:%.*]] = icmp slt i64 [[IV_SPLIT]], [[A]]
; CHECK-NEXT:    br i1 false, label [[IF_THEN_SPLIT:%.*]], label [[IF_ELSE_SPLIT:%.*]]
; CHECK:       if.else.split:
; CHECK-NEXT:    br label [[FOR_INC_SPLIT]]
; CHECK:       if.then.split:
; CHECK-NEXT:    [[SRC_ARRAYIDX_SPLIT:%.*]] = getelementptr inbounds i64, i64* [[SRC]], i64 [[IV_SPLIT]]
; CHECK-NEXT:    [[VAL_SPLIT:%.*]] = load i64, i64* [[SRC_ARRAYIDX_SPLIT]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX_SPLIT:%.*]] = getelementptr inbounds i64, i64* [[DST]], i64 [[IV_SPLIT]]
; CHECK-NEXT:    store i64 [[VAL_SPLIT]], i64* [[DST_ARRAYIDX_SPLIT]], align 4
; CHECK-NEXT:    br label [[FOR_INC_SPLIT]]
; CHECK:       for.inc.split:
; CHECK-NEXT:    [[INC_SPLIT]] = add nuw nsw i64 [[IV_SPLIT]], 1
; CHECK-NEXT:    [[COND_SPLIT:%.*]] = icmp sge i64 [[INC_SPLIT]], [[N]]
; CHECK-NEXT:    br i1 [[COND_SPLIT]], label [[EXIT_LOOPEXIT:%.*]], label [[LOOP_SPLIT]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
loop.ph:
  br label %loop

loop:
  %iv = phi i64 [ %inc, %for.inc ], [ 0, %loop.ph ]
  %cmp = icmp slt i64 %iv, %a
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %src.arrayidx = getelementptr inbounds i64, i64* %src, i64 %iv
  %val = load i64, i64* %src.arrayidx
  %dst.arrayidx = getelementptr inbounds i64, i64* %dst, i64 %iv
  store i64 %val, i64* %dst.arrayidx
  br label %for.inc

if.else:
  br label %for.inc

for.inc:
  %inc = add nuw nsw i64 %iv, 1
  %cond = icmp sge i64 %inc, %n
  br i1 %cond, label %exit, label %loop

exit:
  ret void
}

define void @split_loop_bound_inc_with_step_is_not_one(i64 %a, i64* noalias %src, i64* noalias %dst, i64 %n) {
; CHECK-LABEL: @split_loop_bound_inc_with_step_is_not_one(
; CHECK-NEXT:  loop.ph:
; CHECK-NEXT:    br label [[LOOP_PH_SPLIT:%.*]]
; CHECK:       loop.ph.split:
; CHECK-NEXT:    [[SMAX:%.*]] = call i64 @llvm.smax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    [[TMP0:%.*]] = lshr i64 [[SMAX]], 1
; CHECK-NEXT:    [[NEW_BOUND:%.*]] = call i64 @llvm.smin.i64(i64 [[A:%.*]], i64 [[TMP0]])
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_INC:%.*]] ], [ 0, [[LOOP_PH_SPLIT]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 true, label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[SRC_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[SRC:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[VAL:%.*]] = load i64, i64* [[SRC_ARRAYIDX]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[DST:%.*]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[VAL]], i64* [[DST_ARRAYIDX]], align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       if.else:
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[IV]], 2
; CHECK-NEXT:    [[COND:%.*]] = icmp sgt i64 [[INC]], [[NEW_BOUND]]
; CHECK-NEXT:    br i1 [[COND]], label [[LOOP_PH_SPLIT_SPLIT:%.*]], label [[LOOP]]
; CHECK:       loop.ph.split.split:
; CHECK-NEXT:    [[INC_LCSSA:%.*]] = phi i64 [ [[INC]], [[FOR_INC]] ]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ne i64 [[INC_LCSSA]], [[N]]
; CHECK-NEXT:    br i1 [[TMP1]], label [[LOOP_SPLIT_PREHEADER:%.*]], label [[EXIT:%.*]]
; CHECK:       loop.split.preheader:
; CHECK-NEXT:    br label [[LOOP_SPLIT:%.*]]
; CHECK:       loop.split:
; CHECK-NEXT:    [[IV_SPLIT:%.*]] = phi i64 [ [[INC_SPLIT:%.*]], [[FOR_INC_SPLIT:%.*]] ], [ [[NEW_BOUND]], [[LOOP_SPLIT_PREHEADER]] ]
; CHECK-NEXT:    [[CMP_SPLIT:%.*]] = icmp slt i64 [[IV_SPLIT]], [[A]]
; CHECK-NEXT:    br i1 false, label [[IF_THEN_SPLIT:%.*]], label [[IF_ELSE_SPLIT:%.*]]
; CHECK:       if.else.split:
; CHECK-NEXT:    br label [[FOR_INC_SPLIT]]
; CHECK:       if.then.split:
; CHECK-NEXT:    [[SRC_ARRAYIDX_SPLIT:%.*]] = getelementptr inbounds i64, i64* [[SRC]], i64 [[IV_SPLIT]]
; CHECK-NEXT:    [[VAL_SPLIT:%.*]] = load i64, i64* [[SRC_ARRAYIDX_SPLIT]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX_SPLIT:%.*]] = getelementptr inbounds i64, i64* [[DST]], i64 [[IV_SPLIT]]
; CHECK-NEXT:    store i64 [[VAL_SPLIT]], i64* [[DST_ARRAYIDX_SPLIT]], align 4
; CHECK-NEXT:    br label [[FOR_INC_SPLIT]]
; CHECK:       for.inc.split:
; CHECK-NEXT:    [[INC_SPLIT]] = add nuw nsw i64 [[IV_SPLIT]], 2
; CHECK-NEXT:    [[COND_SPLIT:%.*]] = icmp sgt i64 [[INC_SPLIT]], [[N]]
; CHECK-NEXT:    br i1 [[COND_SPLIT]], label [[EXIT_LOOPEXIT:%.*]], label [[LOOP_SPLIT]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
loop.ph:
  br label %loop

loop:
  %iv = phi i64 [ %inc, %for.inc ], [ 0, %loop.ph ]
  %cmp = icmp slt i64 %iv, %a
  br i1 %cmp, label %if.then, label %if.else

if.then:
  %src.arrayidx = getelementptr inbounds i64, i64* %src, i64 %iv
  %val = load i64, i64* %src.arrayidx
  %dst.arrayidx = getelementptr inbounds i64, i64* %dst, i64 %iv
  store i64 %val, i64* %dst.arrayidx
  br label %for.inc

if.else:
  br label %for.inc

for.inc:
  %inc = add nuw nsw i64 %iv, 2
  %cond = icmp sgt i64 %inc, %n
  br i1 %cond, label %exit, label %loop

exit:
  ret void
}

define void @split_loop_bound_inc_with_ne(i64 %a, i64* noalias %src, i64* noalias %dst, i64 %n) {
; CHECK-LABEL: @split_loop_bound_inc_with_ne(
; CHECK-NEXT:  loop.ph:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[INC:%.*]], [[FOR_INC:%.*]] ], [ 0, [[LOOP_PH:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[IV]], [[A:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[FOR_INC]]
; CHECK:       if.then:
; CHECK-NEXT:    [[SRC_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[SRC:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[VAL:%.*]] = load i64, i64* [[SRC_ARRAYIDX]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[DST:%.*]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[VAL]], i64* [[DST_ARRAYIDX]], align 4
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i64 [[INC]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
loop.ph:
  br label %loop

loop:
  %iv = phi i64 [ %inc, %for.inc ], [ 0, %loop.ph ]
  %cmp = icmp slt i64 %iv, %a
  br i1 %cmp, label %if.then, label %for.inc

if.then:
  %src.arrayidx = getelementptr inbounds i64, i64* %src, i64 %iv
  %val = load i64, i64* %src.arrayidx
  %dst.arrayidx = getelementptr inbounds i64, i64* %dst, i64 %iv
  store i64 %val, i64* %dst.arrayidx
  br label %for.inc

for.inc:
  %inc = add nuw nsw i64 %iv, 1
  %cond = icmp ne i64 %inc, %n
  br i1 %cond, label %exit, label %loop

exit:
  ret void
}

define void @split_loop_bound_dec_with_slt(i64 %a, i64* noalias %src, i64* noalias %dst, i64 %n) {
; CHECK-LABEL: @split_loop_bound_dec_with_slt(
; CHECK-NEXT:  loop.ph:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[DEC:%.*]], [[FOR_DEC:%.*]] ], [ 0, [[LOOP_PH:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[IV]], [[A:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[FOR_DEC]]
; CHECK:       if.then:
; CHECK-NEXT:    [[SRC_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[SRC:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[VAL:%.*]] = load i64, i64* [[SRC_ARRAYIDX]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[DST:%.*]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[VAL]], i64* [[DST_ARRAYIDX]], align 4
; CHECK-NEXT:    br label [[FOR_DEC]]
; CHECK:       for.dec:
; CHECK-NEXT:    [[DEC]] = sub nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp slt i64 [[DEC]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
loop.ph:
  br label %loop

loop:
  %iv = phi i64 [ %dec, %for.dec ], [ 0, %loop.ph ]
  %cmp = icmp slt i64 %iv, %a
  br i1 %cmp, label %if.then, label %for.dec

if.then:
  %src.arrayidx = getelementptr inbounds i64, i64* %src, i64 %iv
  %val = load i64, i64* %src.arrayidx
  %dst.arrayidx = getelementptr inbounds i64, i64* %dst, i64 %iv
  store i64 %val, i64* %dst.arrayidx
  br label %for.dec

for.dec:
  %dec = sub nuw nsw i64 %iv, 1
  %cond = icmp slt i64 %dec, %n
  br i1 %cond, label %exit, label %loop

exit:
  ret void
}

define void @split_loop_bound_dec_with_sle(i64 %a, i64* noalias %src, i64* noalias %dst, i64 %n) {
; CHECK-LABEL: @split_loop_bound_dec_with_sle(
; CHECK-NEXT:  loop.ph:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[DEC:%.*]], [[FOR_DEC:%.*]] ], [ 0, [[LOOP_PH:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[IV]], [[A:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[FOR_DEC]]
; CHECK:       if.then:
; CHECK-NEXT:    [[SRC_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[SRC:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[VAL:%.*]] = load i64, i64* [[SRC_ARRAYIDX]], align 4
; CHECK-NEXT:    [[DST_ARRAYIDX:%.*]] = getelementptr inbounds i64, i64* [[DST:%.*]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[VAL]], i64* [[DST_ARRAYIDX]], align 4
; CHECK-NEXT:    br label [[FOR_DEC]]
; CHECK:       for.dec:
; CHECK-NEXT:    [[DEC]] = sub nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp sle i64 [[DEC]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[COND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
loop.ph:
  br label %loop

loop:
  %iv = phi i64 [ %dec, %for.dec ], [ 0, %loop.ph ]
  %cmp = icmp slt i64 %iv, %a
  br i1 %cmp, label %if.then, label %for.dec

if.then:
  %src.arrayidx = getelementptr inbounds i64, i64* %src, i64 %iv
  %val = load i64, i64* %src.arrayidx
  %dst.arrayidx = getelementptr inbounds i64, i64* %dst, i64 %iv
  store i64 %val, i64* %dst.arrayidx
  br label %for.dec

for.dec:
  %dec = sub nuw nsw i64 %iv, 1
  %cond = icmp sle i64 %dec, %n
  br i1 %cond, label %exit, label %loop

exit:
  ret void
}


