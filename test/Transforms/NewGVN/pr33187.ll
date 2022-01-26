; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
;; Ensure we don't change after value numbering by accidentally deleting the wrong expression.
; RUN: opt -passes=newgvn -S %s | FileCheck %s
define void @fn1() local_unnamed_addr #0 {
; CHECK-LABEL: @fn1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND_PREHEADER:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    br label [[FOR_COND_PREHEADER]]
; CHECK:       for.cond.preheader:
; CHECK-NEXT:    [[H_031:%.*]] = phi i32 [ 5, [[ENTRY:%.*]] ], [ [[H_127:%.*]], [[WHILE_COND:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[H_128:%.*]] = phi i32 [ [[H_031]], [[FOR_COND_PREHEADER]] ], [ [[H_2:%.*]], [[FOR_INC:%.*]] ]
; CHECK-NEXT:    br label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br i1 false, label [[L_LOOPEXIT:%.*]], label [[IF_END:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    br i1 undef, label [[FOR_INC]], label [[IF_END9:%.*]]
; CHECK:       if.end9:
; CHECK-NEXT:    br label [[FOR_INC]]
; CHECK:       for.inc:
; CHECK-NEXT:    [[H_2]] = phi i32 [ [[H_128]], [[IF_END]] ], [ 0, [[IF_END9]] ]
; CHECK-NEXT:    br i1 undef, label [[WHILE_COND10_LOOPEXIT:%.*]], label [[FOR_BODY]]
; CHECK:       while.cond10.loopexit:
; CHECK-NEXT:    br label [[WHILE_COND10:%.*]]
; CHECK:       while.cond10:
; CHECK-NEXT:    [[H_127]] = phi i32 [ [[H_126:%.*]], [[IF_END18:%.*]] ], [ [[H_125:%.*]], [[L:%.*]] ], [ [[H_2]], [[WHILE_COND10_LOOPEXIT]] ]
; CHECK-NEXT:    br i1 undef, label [[WHILE_COND]], label [[WHILE_BODY12:%.*]]
; CHECK:       while.body12:
; CHECK-NEXT:    br i1 undef, label [[IF_END18]], label [[L]]
; CHECK:       L.loopexit:
; CHECK-NEXT:    store i8 poison, i8* null
; CHECK-NEXT:    br label [[L]]
; CHECK:       L:
; CHECK-NEXT:    [[H_125]] = phi i32 [ [[H_127]], [[WHILE_BODY12]] ], [ poison, [[L_LOOPEXIT]] ]
; CHECK-NEXT:    br i1 undef, label [[WHILE_COND10]], label [[IF_END18]]
; CHECK:       if.end18:
; CHECK-NEXT:    [[H_126]] = phi i32 [ [[H_125]], [[L]] ], [ [[H_127]], [[WHILE_BODY12]] ]
; CHECK-NEXT:    br label [[WHILE_COND10]]
;
entry:
  br label %for.cond.preheader

while.cond:                                       ; preds = %while.cond10
  br label %for.cond.preheader

for.cond.preheader:                               ; preds = %while.cond, %entry
  %h.031 = phi i32 [ 5, %entry ], [ %h.127, %while.cond ]
  br label %for.body

for.body:                                         ; preds = %for.inc, %for.cond.preheader
  %h.128 = phi i32 [ %h.031, %for.cond.preheader ], [ %h.2, %for.inc ]
  br label %if.then

if.then:                                          ; preds = %for.body
  br i1 false, label %L.loopexit, label %if.end

if.end:                                           ; preds = %if.then
  br i1 undef, label %for.inc, label %if.end9

if.end9:                                          ; preds = %if.end
  br label %for.inc

for.inc:                                          ; preds = %if.end9, %if.end
  %h.2 = phi i32 [ %h.128, %if.end ], [ 0, %if.end9 ]
  br i1 undef, label %while.cond10.loopexit, label %for.body

while.cond10.loopexit:                            ; preds = %for.inc
  %h.2.lcssa = phi i32 [ %h.2, %for.inc ]
  br label %while.cond10

while.cond10:                                     ; preds = %if.end18, %L, %while.cond10.loopexit
  %h.127 = phi i32 [ %h.126, %if.end18 ], [ %h.125, %L ], [ %h.2.lcssa, %while.cond10.loopexit ]
  br i1 undef, label %while.cond, label %while.body12

while.body12:                                     ; preds = %while.cond10
  br i1 undef, label %if.end18, label %L

L.loopexit:                                       ; preds = %if.then
  br label %L

L:                                                ; preds = %L.loopexit, %while.body12
  %h.125 = phi i32 [ %h.127, %while.body12 ], [ undef, %L.loopexit ]
  br i1 undef, label %while.cond10, label %if.end18

if.end18:                                         ; preds = %L, %while.body12
  %h.126 = phi i32 [ %h.125, %L ], [ %h.127, %while.body12 ]
  br label %while.cond10
}


define void @hoge() local_unnamed_addr #0 {
; CHECK-LABEL: @hoge(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[TMP:%.*]] = phi i64 [ 0, [[BB:%.*]] ], [ [[TMP2:%.*]], [[BB1]] ]
; CHECK-NEXT:    [[TMP2]] = add nuw nsw i64 [[TMP]], 1
; CHECK-NEXT:    br label [[BB1]]
;
bb:
  br label %bb1

bb1:                                              ; preds = %bb1, %bb
  %tmp = phi i64 [ 0, %bb ], [ %tmp2, %bb1 ]
  %tmp2 = add nuw nsw i64 %tmp, 1
  br label %bb1
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "frame-pointer"="none" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }


define void @a() {
; CHECK-LABEL: @a(
; CHECK-NEXT:  b:
; CHECK-NEXT:    store i8* null, i8** null
; CHECK-NEXT:    br label [[D:%.*]]
; CHECK:       d:
; CHECK-NEXT:    [[I:%.*]] = phi i8* [ null, [[B:%.*]] ], [ [[E:%.*]], [[F:%.*]] ]
; CHECK-NEXT:    br i1 undef, label [[F]], label [[G:%.*]]
; CHECK:       g:
; CHECK-NEXT:    store i8* [[I]], i8** null
; CHECK-NEXT:    unreachable
; CHECK:       f:
; CHECK-NEXT:    [[E]] = getelementptr i8, i8* [[I]], i64 1
; CHECK-NEXT:    br label [[D]]
;
b:
  store i8* null, i8** null
  br label %d

d:                                                ; preds = %f, %b
  %i = phi i8* [ null, %b ], [ %e, %f ]
  br i1 undef, label %f, label %g

g:                                                ; preds = %d
  %h = phi i8* [ %i, %d ]
  store i8* %h, i8** null
  unreachable

f:                                                ; preds = %d
  %e = getelementptr i8, i8* %i, i64 1
  br label %d
}

