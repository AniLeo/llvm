; RUN: opt < %s -analyze -enable-new-pm=0 -scalar-evolution | FileCheck %s
; RUN: opt < %s -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s

; ScalarEvolution should be able to understand the loop and eliminate the casts.

; CHECK: {%d,+,4}

define void @foo(i32* nocapture %d, i32 %n) nounwind {
entry:
	%0 = icmp sgt i32 %n, 0		; <i1> [#uses=1]
	br i1 %0, label %bb.nph, label %return

bb.nph:		; preds = %entry
	br label %bb

bb:		; preds = %bb1, %bb.nph
	%i.02 = phi i32 [ %5, %bb1 ], [ 0, %bb.nph ]		; <i32> [#uses=2]
	%p.01 = phi i8 [ %4, %bb1 ], [ -1, %bb.nph ]		; <i8> [#uses=2]
	%1 = sext i8 %p.01 to i32		; <i32> [#uses=1]
	%2 = sext i32 %i.02 to i64		; <i64> [#uses=1]
	%3 = getelementptr i32, i32* %d, i64 %2		; <i32*> [#uses=1]
	store i32 %1, i32* %3, align 4
	%4 = add i8 %p.01, 1		; <i8> [#uses=1]
	%5 = add i32 %i.02, 1		; <i32> [#uses=2]
	br label %bb1

bb1:		; preds = %bb
	%6 = icmp slt i32 %5, %n		; <i1> [#uses=1]
	br i1 %6, label %bb, label %bb1.return_crit_edge

bb1.return_crit_edge:		; preds = %bb1
	br label %return

return:		; preds = %bb1.return_crit_edge, %entry
	ret void
}

; ScalarEvolution should be able to find the maximum tripcount
; of this multiple-exit loop, and if it doesn't know the exact
; count, it should say so.

; PR7845
; CHECK: Loop %for.cond: <multiple exits> Unpredictable backedge-taken count.
; CHECK: Loop %for.cond: max backedge-taken count is 5

@.str = private constant [4 x i8] c"%d\0A\00"     ; <[4 x i8]*> [#uses=2]

define i32 @main() nounwind {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %g_4.0 = phi i32 [ 0, %entry ], [ %add, %for.inc ] ; <i32> [#uses=5]
  %cmp = icmp slt i32 %g_4.0, 5                   ; <i1> [#uses=1]
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %conv = trunc i32 %g_4.0 to i16                 ; <i16> [#uses=1]
  %tobool.not = icmp eq i16 %conv, 0              ; <i1> [#uses=1]
  %tobool3 = icmp ne i32 %g_4.0, 0                ; <i1> [#uses=1]
  %or.cond = and i1 %tobool.not, %tobool3         ; <i1> [#uses=1]
  br i1 %or.cond, label %for.end, label %for.inc

for.inc:                                          ; preds = %for.body
  %add = add nsw i32 %g_4.0, 1                    ; <i32> [#uses=1]
  br label %for.cond

for.end:                                          ; preds = %for.body, %for.cond
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 %g_4.0) nounwind ; <i32> [#uses=0]
  ret i32 0
}

declare i32 @printf(i8*, ...)

define void @test(i8* %a, i32 %n) nounwind {
entry:
  %cmp1 = icmp sgt i32 %n, 0
  br i1 %cmp1, label %for.body.lr.ph, label %for.end

for.body.lr.ph:                                   ; preds = %entry
  %tmp = zext i32 %n to i64
  br label %for.body

for.body:                                         ; preds = %for.body, %for.body.lr.ph
  %indvar = phi i64 [ %indvar.next, %for.body ], [ 0, %for.body.lr.ph ]
  %arrayidx = getelementptr i8, i8* %a, i64 %indvar
  store i8 0, i8* %arrayidx, align 1
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp ne i64 %indvar.next, %tmp
  br i1 %exitcond, label %for.body, label %for.cond.for.end_crit_edge

for.cond.for.end_crit_edge:                       ; preds = %for.body
  br label %for.end

for.end:                                          ; preds = %for.cond.for.end_crit_edge, %entry
  ret void
}

; CHECK: Determining loop execution counts for: @test
; CHECK-NEXT: backedge-taken count is
; CHECK-NEXT: max backedge-taken count is 2147483646

; PR19799: Indvars miscompile due to an incorrect max backedge taken count from SCEV.
; CHECK-LABEL: @pr19799
; CHECK: Loop %for.body.i: <multiple exits> Unpredictable backedge-taken count.
; CHECK: Loop %for.body.i: max backedge-taken count is 1
@a = common global i32 0, align 4

define i32 @pr19799() {
entry:
  store i32 -1, i32* @a, align 4
  br label %for.body.i

for.body.i:                                       ; preds = %for.cond.i, %entry
  %storemerge1.i = phi i32 [ -1, %entry ], [ %add.i.i, %for.cond.i ]
  %tobool.i = icmp eq i32 %storemerge1.i, 0
  %add.i.i = add nsw i32 %storemerge1.i, 2
  br i1 %tobool.i, label %bar.exit, label %for.cond.i

for.cond.i:                                       ; preds = %for.body.i
  store i32 %add.i.i, i32* @a, align 4
  %cmp.i = icmp slt i32 %storemerge1.i, 0
  br i1 %cmp.i, label %for.body.i, label %bar.exit

bar.exit:                                         ; preds = %for.cond.i, %for.body.i
  ret i32 0
}

; PR18886: Indvars miscompile due to an incorrect max backedge taken count from SCEV.
; CHECK-LABEL: @pr18886
; CHECK: Loop %for.body: <multiple exits> Unpredictable backedge-taken count.
; CHECK: Loop %for.body: max backedge-taken count is 3
@aa = global i64 0, align 8

define i32 @pr18886() {
entry:
  store i64 -21, i64* @aa, align 8
  br label %for.body

for.body:
  %storemerge1 = phi i64 [ -21, %entry ], [ %add, %for.cond ]
  %tobool = icmp eq i64 %storemerge1, 0
  %add = add nsw i64 %storemerge1, 8
  br i1 %tobool, label %return, label %for.cond

for.cond:
  store i64 %add, i64* @aa, align 8
  %cmp = icmp slt i64 %add, 9
  br i1 %cmp, label %for.body, label %return

return:
  %retval.0 = phi i32 [ 1, %for.body ], [ 0, %for.cond ]
  ret i32 %retval.0
}

; Here we have a must-exit loop latch that is not computable and a
; may-exit early exit that can only have one non-exiting iteration
; before the check is forever skipped.
;
; CHECK-LABEL: @cannot_compute_mustexit
; CHECK: Loop %for.body.i: <multiple exits> Unpredictable backedge-taken count.
; CHECK: Loop %for.body.i: Unpredictable max backedge-taken count.
@b = common global i32 0, align 4

define i32 @cannot_compute_mustexit() {
entry:
  store i32 -1, i32* @a, align 4
  br label %for.body.i

for.body.i:                                       ; preds = %for.cond.i, %entry
  %storemerge1.i = phi i32 [ -1, %entry ], [ %add.i.i, %for.cond.i ]
  %tobool.i = icmp eq i32 %storemerge1.i, 0
  %add.i.i = add nsw i32 %storemerge1.i, 2
  br i1 %tobool.i, label %bar.exit, label %for.cond.i

for.cond.i:                                       ; preds = %for.body.i
  store i32 %add.i.i, i32* @a, align 4
  %ld = load volatile i32, i32* @b
  %cmp.i = icmp ne i32 %ld, 0
  br i1 %cmp.i, label %for.body.i, label %bar.exit

bar.exit:                                         ; preds = %for.cond.i, %for.body.i
  ret i32 0
}

; This loop has two must-exits, both of which dominate the latch. The
; MaxBECount should be the minimum of them.
;
; CHECK-LABEL: @two_mustexit
; CHECK: Loop %for.body.i: <multiple exits> backedge-taken count is 1
; CHECK: Loop %for.body.i: max backedge-taken count is 1
define i32 @two_mustexit() {
entry:
  store i32 -1, i32* @a, align 4
  br label %for.body.i

for.body.i:                                       ; preds = %for.cond.i, %entry
  %storemerge1.i = phi i32 [ -1, %entry ], [ %add.i.i, %for.cond.i ]
  %tobool.i = icmp sgt i32 %storemerge1.i, 0
  %add.i.i = add nsw i32 %storemerge1.i, 2
  br i1 %tobool.i, label %bar.exit, label %for.cond.i

for.cond.i:                                       ; preds = %for.body.i
  store i32 %add.i.i, i32* @a, align 4
  %cmp.i = icmp slt i32 %storemerge1.i, 3
  br i1 %cmp.i, label %for.body.i, label %bar.exit

bar.exit:                                         ; preds = %for.cond.i, %for.body.i
  ret i32 0
}

; CHECK-LABEL: @ne_max_trip_count_1
; CHECK: Loop %for.body: max backedge-taken count is 7
define i32 @ne_max_trip_count_1(i32 %n) {
entry:
  %masked = and i32 %n, 7
  br label %for.body

for.body:
  %i = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %add = add nsw i32 %i, 1
  %cmp = icmp ne i32 %i, %masked
  br i1 %cmp, label %for.body, label %bar.exit

bar.exit:
  ret i32 0
}

; CHECK-LABEL: @ne_max_trip_count_2
; CHECK: Loop %for.body: max backedge-taken count is -1
define i32 @ne_max_trip_count_2(i32 %n) {
entry:
  %masked = and i32 %n, 7
  br label %for.body

for.body:
  %i = phi i32 [ 0, %entry ], [ %add, %for.body ]
  %add = add nsw i32 %i, 1
  %cmp = icmp ne i32 %add, %masked
  br i1 %cmp, label %for.body, label %bar.exit

bar.exit:
  ret i32 0
}

; CHECK-LABEL: @ne_max_trip_count_3
; CHECK: Loop %for.body: max backedge-taken count is 6
define i32 @ne_max_trip_count_3(i32 %n) {
entry:
  %masked = and i32 %n, 7
  %guard = icmp eq i32 %masked, 0
  br i1 %guard, label %exit, label %for.preheader

for.preheader:
  br label %for.body

for.body:
  %i = phi i32 [ 0, %for.preheader ], [ %add, %for.body ]
  %add = add nsw i32 %i, 1
  %cmp = icmp ne i32 %add, %masked
  br i1 %cmp, label %for.body, label %loop.exit

loop.exit:
  br label %exit

exit:
  ret i32 0
}

; CHECK-LABEL: @ne_max_trip_count_4
; CHECK: Loop %for.body: max backedge-taken count is -2
define i32 @ne_max_trip_count_4(i32 %n) {
entry:
  %guard = icmp eq i32 %n, 0
  br i1 %guard, label %exit, label %for.preheader

for.preheader:
  br label %for.body

for.body:
  %i = phi i32 [ 0, %for.preheader ], [ %add, %for.body ]
  %add = add nsw i32 %i, 1
  %cmp = icmp ne i32 %add, %n
  br i1 %cmp, label %for.body, label %loop.exit

loop.exit:
  br label %exit

exit:
  ret i32 0
}

; The end bound of the loop can change between iterations, so the exact trip
; count is unknown, but SCEV can calculate the max trip count.
define void @changing_end_bound(i32* %n_addr, i32* %addr) {
; CHECK-LABEL: Determining loop execution counts for: @changing_end_bound
; CHECK: Loop %loop: Unpredictable backedge-taken count.
; CHECK: Loop %loop: max backedge-taken count is 2147483646
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %val = load atomic i32, i32* %addr unordered, align 4
  fence acquire
  %acc.next = add i32 %acc, %val
  %iv.next = add nsw i32 %iv, 1
  %n = load atomic i32, i32* %n_addr unordered, align 4
  %cmp = icmp slt i32 %iv.next, %n
  br i1 %cmp, label %loop, label %loop.exit

loop.exit:
  ret void
}

; Similar test as above, but unknown start value.
; Also, there's no nsw on the iv.next, but SCEV knows 
; the termination condition is LT, so the IV cannot wrap.
define void @changing_end_bound2(i32 %start, i32* %n_addr, i32* %addr) {
; CHECK-LABEL: Determining loop execution counts for: @changing_end_bound2
; CHECK: Loop %loop: Unpredictable backedge-taken count.
; CHECK: Loop %loop: max backedge-taken count is -1
entry:
  br label %loop

loop:
  %iv = phi i32 [ %start, %entry ], [ %iv.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %val = load atomic i32, i32* %addr unordered, align 4
  fence acquire
  %acc.next = add i32 %acc, %val
  %iv.next = add i32 %iv, 1
  %n = load atomic i32, i32* %n_addr unordered, align 4
  %cmp = icmp slt i32 %iv.next, %n
  br i1 %cmp, label %loop, label %loop.exit

loop.exit:
  ret void
}

; changing end bound and greater than one stride
define void @changing_end_bound3(i32 %start, i32* %n_addr, i32* %addr) {
; CHECK-LABEL: Determining loop execution counts for: @changing_end_bound3
; CHECK: Loop %loop: Unpredictable backedge-taken count.
; CHECK: Loop %loop: max backedge-taken count is 1073741823
entry:
  br label %loop

loop:
  %iv = phi i32 [ %start, %entry ], [ %iv.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %val = load atomic i32, i32* %addr unordered, align 4
  fence acquire
  %acc.next = add i32 %acc, %val
  %iv.next = add nsw i32 %iv, 4
  %n = load atomic i32, i32* %n_addr unordered, align 4
  %cmp = icmp slt i32 %iv.next, %n
  br i1 %cmp, label %loop, label %loop.exit

loop.exit:
  ret void
}

; same as above test, but the IV can wrap around.
; so the max backedge taken count is unpredictable.
define void @changing_end_bound4(i32 %start, i32* %n_addr, i32* %addr) {
; CHECK-LABEL: Determining loop execution counts for: @changing_end_bound4
; CHECK: Loop %loop: Unpredictable backedge-taken count.
; CHECK: Loop %loop: Unpredictable max backedge-taken count.
entry:
  br label %loop

loop:
  %iv = phi i32 [ %start, %entry ], [ %iv.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %val = load atomic i32, i32* %addr unordered, align 4
  fence acquire
  %acc.next = add i32 %acc, %val
  %iv.next = add i32 %iv, 4
  %n = load atomic i32, i32* %n_addr unordered, align 4
  %cmp = icmp slt i32 %iv.next, %n
  br i1 %cmp, label %loop, label %loop.exit

loop.exit:
  ret void
}

; unknown stride. Since it's not knownPositive, we do not estimate the max
; backedge taken count.
define void @changing_end_bound5(i32 %stride, i32 %start, i32* %n_addr, i32* %addr) {
; CHECK-LABEL: Determining loop execution counts for: @changing_end_bound5
; CHECK: Loop %loop: Unpredictable backedge-taken count.
; CHECK: Loop %loop: Unpredictable max backedge-taken count.
entry:
  br label %loop

loop:
  %iv = phi i32 [ %start, %entry ], [ %iv.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %val = load atomic i32, i32* %addr unordered, align 4
  fence acquire
  %acc.next = add i32 %acc, %val
  %iv.next = add nsw i32 %iv, %stride
  %n = load atomic i32, i32* %n_addr unordered, align 4
  %cmp = icmp slt i32 %iv.next, %n
  br i1 %cmp, label %loop, label %loop.exit

loop.exit:
  ret void
}

; negative stride value
define void @changing_end_bound6(i32 %start, i32* %n_addr, i32* %addr) {
; CHECK-LABEL: Determining loop execution counts for: @changing_end_bound6
; CHECK: Loop %loop: Unpredictable backedge-taken count.
; CHECK: Loop %loop: Unpredictable max backedge-taken count.
entry:
  br label %loop

loop:
  %iv = phi i32 [ %start, %entry ], [ %iv.next, %loop ]
  %acc = phi i32 [ 0, %entry ], [ %acc.next, %loop ]
  %val = load atomic i32, i32* %addr unordered, align 4
  fence acquire
  %acc.next = add i32 %acc, %val
  %iv.next = add nsw i32 %iv, -1
  %n = load atomic i32, i32* %n_addr unordered, align 4
  %cmp = icmp slt i32 %iv.next, %n
  br i1 %cmp, label %loop, label %loop.exit

loop.exit:
  ret void
}
