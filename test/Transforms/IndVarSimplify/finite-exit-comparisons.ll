; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -indvars -S < %s -indvars-predicate-loops=0 | FileCheck %s

; A collection of tests which domonstrate cases where we can use properties
; of the loop (i.e. single exit, finite, mustprogress) to optimize conditions
; and extends we couldn't otherwise handle.

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

define void @slt_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @slt_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

;; Range logic doesn't depend on must execute
define void @slt_constant_rhs_maythrow(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @slt_constant_rhs_maythrow(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  call void @unknown()
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

;; Range logic doesn't depend on must execute
define void @slt_constant_rhs_multiexit(i16 %n.raw, i8 %start, i1 %c) mustprogress {
; CHECK-LABEL: @slt_constant_rhs_multiexit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[LATCH:%.*]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    br i1 [[C:%.*]], label [[LATCH]], label [[FOR_END:%.*]]
; CHECK:       latch:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %latch ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  br i1 %c, label %latch, label %for.end

latch:
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @slt_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @slt_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Case where we could prove this using range facts, but not must exit reasoning
define void @slt_non_constant_rhs_no_mustprogress(i16 %n.raw) {
; CHECK-LABEL: @slt_non_constant_rhs_no_mustprogress(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[N:%.*]] = and i16 [[N_RAW:%.*]], 255
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 [[N]] to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %n = and i16 %n.raw, 255
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Fact holds for exiting branch, but not for earlier use
; We could recognize the unreachable loop here, but don't currently.  Its
; also not terribly interesting, because EarlyCSE will fold condition.
define void @slt_neg_multiple_use(i8 %start) mustprogress {
; CHECK-LABEL: @slt_neg_multiple_use(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[START:%.*]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[ZEXT]], 254
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %zext = zext i8 %start to i16
  %cmp = icmp slt i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @slt_neg_multiple_use2(i8 %start, i16 %n) mustprogress {
; CHECK-LABEL: @slt_neg_multiple_use2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[START:%.*]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY_PREHEADER:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body.preheader:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END_LOOPEXIT:%.*]]
; CHECK:       for.end.loopexit:
; CHECK-NEXT:    br label [[FOR_END]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  %zext = zext i8 %start to i16
  %cmp = icmp slt i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %entry, %for.body
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

@G = external global i8

; Negative case where the loop could be infinite and make progress
define void @slt_neg_well_defined_infinite(i16 %n) mustprogress {
; CHECK-LABEL: @slt_neg_well_defined_infinite(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    store volatile i8 [[IV]], i8* @G, align 1
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  store volatile i8 %iv, i8* @G
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Negative case with no mustprogress rsltuirement
define void @slt_neg_no_mustprogress(i16 %n) {
; CHECK-LABEL: @slt_neg_no_mustprogress(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

declare void @unknown()

define void @slt_neg_abnormal_exit(i16 %n) mustprogress {
; CHECK-LABEL: @slt_neg_abnormal_exit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  call void @unknown()
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; For the other comparison flavors, we only bother to repeat the positive
; tests since the negative variants are mostly the same.

define void @ne_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @ne_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i16 [[ZEXT]], 254
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ne i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ne_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @ne_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ne i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @eq_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @eq_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[ZEXT]], 254
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp eq i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @eq_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @eq_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp eq i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @sgt_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @sgt_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp sgt i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @sgt_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @sgt_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp sgt i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @sle_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @sle_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp sle i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @sle_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @sle_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp sle i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @sge_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @sge_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp sge i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @sge_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @sge_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp sge i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ult_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @ult_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ult i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ult_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @ult_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ult i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ugt_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @ugt_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ugt i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ugt_neg_non_loop(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @ugt_neg_non_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i16 [[ZEXT]], -2
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ugt i16 %zext, -2
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ugt_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @ugt_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ugt i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ule_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @ule_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ule i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ule_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @ule_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ule i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @uge_constant_rhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @uge_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i8 [[IV_NEXT]], [[TMP0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp uge i16 %zext, 254
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @uge_non_constant_rhs(i16 %n) mustprogress {
; CHECK-LABEL: @uge_non_constant_rhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i16 [[ZEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp uge i16 %zext, %n
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

; Show that these transformatios also work with inverted operands
; We only both to do this with slt/ult, but it applies to all predicates.

define void @slt_constant_lhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @slt_constant_lhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[TMP0]], [[IV_NEXT]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 254, %zext
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @slt_non_constant_lhs(i16 %n) mustprogress {
; CHECK-LABEL: @slt_non_constant_lhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i16 [[N:%.*]], [[ZEXT]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp slt i16 %n, %zext
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ult_constant_lhs(i16 %n.raw, i8 %start) mustprogress {
; CHECK-LABEL: @ult_constant_lhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i16 254 to i8
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ [[START:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[TMP0]], [[IV_NEXT]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ %start, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ult i16 254, %zext
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}

define void @ult_non_constant_lhs(i16 %n) mustprogress {
; CHECK-LABEL: @ult_non_constant_lhs(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ [[IV_NEXT:%.*]], [[FOR_BODY]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 1
; CHECK-NEXT:    [[ZEXT:%.*]] = zext i8 [[IV_NEXT]] to i16
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i16 [[N:%.*]], [[ZEXT]]
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %for.body
  %iv = phi i8 [ %iv.next, %for.body ], [ 0, %entry ]
  %iv.next = add i8 %iv, 1
  %zext = zext i8 %iv.next to i16
  %cmp = icmp ult i16 %n, %zext
  br i1 %cmp, label %for.body, label %for.end

for.end:                                          ; preds = %for.body, %entry
  ret void
}
