; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -indvars -indvars-post-increment-ranges -S | FileCheck %s

target datalayout = "p:64:64:64-n32:64"

; When the IV in this loop is widened we want to widen this use as well:
; icmp slt i32 %i.inc, %limit
; In order to do this indvars need to prove that the narrow IV def (%i.inc)
; is not-negative from the range check inside of the loop.
define void @test(i32* %base, i32 %limit, i32 %start) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    [[UMAX:%.*]] = call i32 @llvm.umax.i32(i32 [[START:%.*]], i32 64)
; CHECK-NEXT:    [[TMP0:%.*]] = sub i32 [[UMAX]], [[START]]
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[START]], 1
; CHECK-NEXT:    [[SMAX:%.*]] = call i32 @llvm.smax.i32(i32 [[LIMIT:%.*]], i32 [[TMP1]])
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[SMAX]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = sub i32 [[TMP2]], [[START]]
; CHECK-NEXT:    [[UMIN:%.*]] = call i32 @llvm.umin.i32(i32 [[TMP3]], i32 [[TMP0]])
; CHECK-NEXT:    [[TMP4:%.*]] = icmp ne i32 [[TMP0]], [[UMIN]]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP3]], [[UMIN]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 [[TMP4]], label [[CONTINUE:%.*]], label [[FOR_END:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    br label [[FOR_INC:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    br i1 [[TMP5]], label [[FOR_BODY]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

for.body.lr.ph:
  br label %for.body

for.body:
  %i = phi i32 [ %start, %for.body.lr.ph ], [ %i.inc, %for.inc ]
  %within_limits = icmp ult i32 %i, 64
  br i1 %within_limits, label %continue, label %for.end

continue:
  %i.i64 = zext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %arrayidx, align 4
  br label %for.inc

for.inc:
  %i.inc = add nsw nuw i32 %i, 1
  %cmp = icmp slt i32 %i.inc, %limit
  br i1 %cmp, label %for.body, label %for.end

for.end:
  br label %exit

exit:
  ret void
}

define void @test_false_edge(i32* %base, i32 %limit, i32 %start) {
; CHECK-LABEL: @test_false_edge(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    [[UMAX:%.*]] = call i32 @llvm.umax.i32(i32 [[START:%.*]], i32 65)
; CHECK-NEXT:    [[TMP0:%.*]] = sub i32 [[UMAX]], [[START]]
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[START]], 1
; CHECK-NEXT:    [[SMAX:%.*]] = call i32 @llvm.smax.i32(i32 [[LIMIT:%.*]], i32 [[TMP1]])
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[SMAX]], -1
; CHECK-NEXT:    [[TMP3:%.*]] = sub i32 [[TMP2]], [[START]]
; CHECK-NEXT:    [[UMIN:%.*]] = call i32 @llvm.umin.i32(i32 [[TMP3]], i32 [[TMP0]])
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i32 [[TMP0]], [[UMIN]]
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne i32 [[TMP3]], [[UMIN]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 [[TMP4]], label [[FOR_END:%.*]], label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    br label [[FOR_INC:%.*]]
; CHECK:       for.inc:
; CHECK-NEXT:    br i1 [[TMP5]], label [[FOR_BODY]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

for.body.lr.ph:
  br label %for.body

for.body:
  %i = phi i32 [ %start, %for.body.lr.ph ], [ %i.inc, %for.inc ]
  %out_of_bounds = icmp ugt i32 %i, 64
  br i1 %out_of_bounds, label %for.end, label %continue

continue:
  %i.i64 = zext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %arrayidx, align 4
  br label %for.inc

for.inc:
  %i.inc = add nsw nuw i32 %i, 1
  %cmp = icmp slt i32 %i.inc, %limit
  br i1 %cmp, label %for.body, label %for.end

for.end:
  br label %exit

exit:
  ret void
}

define void @test_range_metadata(i32* %array_length_ptr, i32* %base,
; CHECK-LABEL: @test_range_metadata(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[START:%.*]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[LIMIT:%.*]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ], [ [[TMP0]], [[FOR_BODY_LR_PH:%.*]] ]
; CHECK-NEXT:    [[ARRAY_LENGTH:%.*]] = load i32, i32* [[ARRAY_LENGTH_PTR:%.*]], align 4, !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[TMP2:%.*]] = zext i32 [[ARRAY_LENGTH]] to i64
; CHECK-NEXT:    [[WITHIN_LIMITS:%.*]] = icmp ult i64 [[INDVARS_IV]], [[TMP2]]
; CHECK-NEXT:    br i1 [[WITHIN_LIMITS]], label [[CONTINUE:%.*]], label [[FOR_END:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT]], [[TMP1]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  i32 %limit, i32 %start) {

for.body.lr.ph:
  br label %for.body

for.body:
  %i = phi i32 [ %start, %for.body.lr.ph ], [ %i.inc, %for.inc ]
  %array_length = load i32, i32* %array_length_ptr, !range !{i32 0, i32 64 }
  %within_limits = icmp ult i32 %i, %array_length
  br i1 %within_limits, label %continue, label %for.end

continue:
  %i.i64 = zext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %arrayidx, align 4
  br label %for.inc

for.inc:
  %i.inc = add nsw nuw i32 %i, 1
  %cmp = icmp slt i32 %i.inc, %limit
  br i1 %cmp, label %for.body, label %for.end

for.end:
  br label %exit

exit:
  ret void
}

; Negative version of the test above, we don't know anything about
; array_length_ptr range.
define void @test_neg(i32* %array_length_ptr, i32* %base,
; CHECK-LABEL: @test_neg(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[START:%.*]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ], [ [[TMP0]], [[FOR_BODY_LR_PH:%.*]] ]
; CHECK-NEXT:    [[ARRAY_LENGTH:%.*]] = load i32, i32* [[ARRAY_LENGTH_PTR:%.*]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[ARRAY_LENGTH]] to i64
; CHECK-NEXT:    [[WITHIN_LIMITS:%.*]] = icmp ult i64 [[INDVARS_IV]], [[TMP1]]
; CHECK-NEXT:    br i1 [[WITHIN_LIMITS]], label [[CONTINUE:%.*]], label [[FOR_END:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = trunc i64 [[INDVARS_IV_NEXT]] to i32
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP2]], [[LIMIT:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
  i32 %limit, i32 %start) {

for.body.lr.ph:
  br label %for.body

for.body:
  %i = phi i32 [ %start, %for.body.lr.ph ], [ %i.inc, %for.inc ]
  %array_length = load i32, i32* %array_length_ptr
  %within_limits = icmp ult i32 %i, %array_length
  br i1 %within_limits, label %continue, label %for.end

continue:
  %i.i64 = zext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %arrayidx, align 4
  br label %for.inc

for.inc:
  %i.inc = add nsw nuw i32 %i, 1
  %cmp = icmp slt i32 %i.inc, %limit
  br i1 %cmp, label %for.body, label %for.end

for.end:
  br label %exit

exit:
  ret void
}

define void @test_transitive_use(i32* %base, i32 %limit, i32 %start) {
; CHECK-LABEL: @test_transitive_use(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[START:%.*]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[LIMIT:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = sext i32 [[LIMIT]] to i64
; CHECK-NEXT:    [[UMAX:%.*]] = call i32 @llvm.umax.i32(i32 [[START]], i32 64)
; CHECK-NEXT:    [[WIDE_TRIP_COUNT:%.*]] = zext i32 [[UMAX]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ], [ [[TMP0]], [[FOR_BODY_LR_PH:%.*]] ]
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[INDVARS_IV]], [[WIDE_TRIP_COUNT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[CONTINUE:%.*]], label [[FOR_END:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    [[TMP3:%.*]] = mul nuw nsw i64 [[INDVARS_IV]], 3
; CHECK-NEXT:    [[MUL_WITHIN:%.*]] = icmp ult i64 [[TMP3]], 64
; CHECK-NEXT:    br i1 [[MUL_WITHIN]], label [[GUARDED:%.*]], label [[CONTINUE_2:%.*]]
; CHECK:       guarded:
; CHECK-NEXT:    [[TMP4:%.*]] = add nuw nsw i64 [[TMP3]], 1
; CHECK-NEXT:    [[RESULT:%.*]] = icmp slt i64 [[TMP4]], [[TMP1]]
; CHECK-NEXT:    br i1 [[RESULT]], label [[CONTINUE_2]], label [[FOR_END]]
; CHECK:       continue.2:
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT]], [[TMP2]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

for.body.lr.ph:
  br label %for.body

for.body:
  %i = phi i32 [ %start, %for.body.lr.ph ], [ %i.inc, %for.inc ]
  %within_limits = icmp ult i32 %i, 64
  br i1 %within_limits, label %continue, label %for.end

continue:
  %i.mul.3 = mul nsw nuw i32 %i, 3
  %mul_within = icmp ult i32 %i.mul.3, 64
  br i1 %mul_within, label %guarded, label %continue.2

guarded:
  %i.mul.3.inc = add nsw nuw i32 %i.mul.3, 1
  %result = icmp slt i32 %i.mul.3.inc, %limit
  br i1 %result, label %continue.2, label %for.end

continue.2:
  %i.i64 = zext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %arrayidx, align 4
  br label %for.inc

for.inc:
  %i.inc = add nsw nuw i32 %i, 1
  %cmp = icmp slt i32 %i.inc, %limit
  br i1 %cmp, label %for.body, label %for.end


for.end:
  br label %exit

exit:
  ret void
}

declare void @llvm.experimental.guard(i1, ...)

define void @test_guard_one_bb(i32* %base, i32 %limit, i32 %start) {
; CHECK-LABEL: @test_guard_one_bb(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[START:%.*]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[LIMIT:%.*]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[TMP0]], [[FOR_BODY_LR_PH:%.*]] ]
; CHECK-NEXT:    [[WITHIN_LIMITS:%.*]] = icmp ult i64 [[INDVARS_IV]], 64
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[WITHIN_LIMITS]]) [ "deopt"() ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT]], [[TMP1]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

for.body.lr.ph:
  br label %for.body

for.body:
  %i = phi i32 [ %start, %for.body.lr.ph ], [ %i.inc, %for.body ]
  %within_limits = icmp ult i32 %i, 64
  %i.i64 = zext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %arrayidx, align 4
  call void(i1, ...) @llvm.experimental.guard(i1 %within_limits) [ "deopt"() ]
  %i.inc = add nsw nuw i32 %i, 1
  %cmp = icmp slt i32 %i.inc, %limit
  br i1 %cmp, label %for.body, label %for.end

for.end:
  br label %exit

exit:
  ret void
}

define void @test_guard_in_the_same_bb(i32* %base, i32 %limit, i32 %start) {
; CHECK-LABEL: @test_guard_in_the_same_bb(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[START:%.*]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[LIMIT:%.*]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ], [ [[TMP0]], [[FOR_BODY_LR_PH:%.*]] ]
; CHECK-NEXT:    [[WITHIN_LIMITS:%.*]] = icmp ult i64 [[INDVARS_IV]], 64
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[WITHIN_LIMITS]]) [ "deopt"() ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT]], [[TMP1]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

for.body.lr.ph:
  br label %for.body

for.body:
  %i = phi i32 [ %start, %for.body.lr.ph ], [ %i.inc, %for.inc ]
  %within_limits = icmp ult i32 %i, 64
  %i.i64 = zext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %arrayidx, align 4
  br label %for.inc

for.inc:
  call void(i1, ...) @llvm.experimental.guard(i1 %within_limits) [ "deopt"() ]
  %i.inc = add nsw nuw i32 %i, 1
  %cmp = icmp slt i32 %i.inc, %limit
  br i1 %cmp, label %for.body, label %for.end

for.end:
  br label %exit

exit:
  ret void
}

define void @test_guard_in_idom(i32* %base, i32 %limit, i32 %start) {
; CHECK-LABEL: @test_guard_in_idom(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[START:%.*]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[LIMIT:%.*]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_INC:%.*]] ], [ [[TMP0]], [[FOR_BODY_LR_PH:%.*]] ]
; CHECK-NEXT:    [[WITHIN_LIMITS:%.*]] = icmp ult i64 [[INDVARS_IV]], 64
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[WITHIN_LIMITS]]) [ "deopt"() ]
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT]], [[TMP1]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

for.body.lr.ph:
  br label %for.body

for.body:
  %i = phi i32 [ %start, %for.body.lr.ph ], [ %i.inc, %for.inc ]
  %within_limits = icmp ult i32 %i, 64
  call void(i1, ...) @llvm.experimental.guard(i1 %within_limits) [ "deopt"() ]
  %i.i64 = zext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %arrayidx, align 4
  br label %for.inc

for.inc:
  %i.inc = add nsw nuw i32 %i, 1
  %cmp = icmp slt i32 %i.inc, %limit
  br i1 %cmp, label %for.body, label %for.end

for.end:
  br label %exit

exit:
  ret void
}

define void @test_guard_merge_ranges(i32* %base, i32 %limit, i32 %start) {
; CHECK-LABEL: @test_guard_merge_ranges(
; CHECK-NEXT:  for.body.lr.ph:
; CHECK-NEXT:    [[TMP0:%.*]] = zext i32 [[START:%.*]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[LIMIT:%.*]] to i64
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[TMP0]], [[FOR_BODY_LR_PH:%.*]] ]
; CHECK-NEXT:    [[WITHIN_LIMITS_1:%.*]] = icmp ult i64 [[INDVARS_IV]], 64
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[WITHIN_LIMITS_1]]) [ "deopt"() ]
; CHECK-NEXT:    [[WITHIN_LIMITS_2:%.*]] = icmp ult i64 [[INDVARS_IV]], 2147483647
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[WITHIN_LIMITS_2]]) [ "deopt"() ]
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[INDVARS_IV_NEXT]], [[TMP1]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;

for.body.lr.ph:
  br label %for.body

for.body:
  %i = phi i32 [ %start, %for.body.lr.ph ], [ %i.inc, %for.body ]
  %within_limits.1 = icmp ult i32 %i, 64
  call void(i1, ...) @llvm.experimental.guard(i1 %within_limits.1) [ "deopt"() ]
  %within_limits.2 = icmp ult i32 %i, 2147483647
  call void(i1, ...) @llvm.experimental.guard(i1 %within_limits.2) [ "deopt"() ]
  %i.i64 = zext i32 %i to i64
  %arrayidx = getelementptr inbounds i32, i32* %base, i64 %i.i64
  %val = load i32, i32* %arrayidx, align 4
  %i.inc = add nsw nuw i32 %i, 1
  %cmp = icmp slt i32 %i.inc, %limit
  br i1 %cmp, label %for.body, label %for.end

for.end:
  br label %exit

exit:
  ret void
}
