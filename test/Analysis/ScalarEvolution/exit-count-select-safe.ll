; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -disable-output "-passes=print<scalar-evolution>" %s 2>&1 | FileCheck %s

define i32 @logical_and_2ops(i32 %n, i32 %m) {
; CHECK-LABEL: 'logical_and_2ops'
; CHECK-NEXT:  Classifying expressions for: @logical_and_2ops
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin %m) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin %m)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond = select i1 %cond_p0, i1 %cond_p1, i1 false
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_and_2ops
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin %m)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin %m)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %cond_p0 = icmp ult i32 %i, %n
  %cond_p1 = icmp ult i32 %i, %m
  %cond = select i1 %cond_p0, i1 %cond_p1, i1 false
  br i1 %cond, label %loop, label %exit
exit:
  ret i32 %i
}

define i32 @logical_or_2ops(i32 %n, i32 %m) {
; CHECK-LABEL: 'logical_or_2ops'
; CHECK-NEXT:  Classifying expressions for: @logical_or_2ops
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin %m) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin %m)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_2ops
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin %m)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin %m)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %cond_p0 = icmp uge i32 %i, %n
  %cond_p1 = icmp uge i32 %i, %m
  %cond = select i1 %cond_p0, i1 true, i1 %cond_p1
  br i1 %cond, label %exit, label %loop
exit:
  ret i32 %i
}

define i32 @logical_and_3ops(i32 %n, i32 %m, i32 %k) {
; CHECK-LABEL: 'logical_and_3ops'
; CHECK-NEXT:  Classifying expressions for: @logical_and_3ops
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin %m umin %k) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin %m umin %k)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond_p3 = select i1 %cond_p0, i1 %cond_p1, i1 false
; CHECK-NEXT:    --> %cond_p3 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p3, i1 %cond_p2, i1 false
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_and_3ops
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin %m umin %k)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin %m umin %k)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %cond_p0 = icmp ult i32 %i, %n
  %cond_p1 = icmp ult i32 %i, %m
  %cond_p2 = icmp ult i32 %i, %k
  %cond_p3 = select i1 %cond_p0, i1 %cond_p1, i1 false
  %cond = select i1 %cond_p3, i1 %cond_p2, i1 false
  br i1 %cond, label %loop, label %exit
exit:
  ret i32 %i
}

define i32 @logical_or_3ops(i32 %n, i32 %m, i32 %k) {
; CHECK-LABEL: 'logical_or_3ops'
; CHECK-NEXT:  Classifying expressions for: @logical_or_3ops
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin %m umin %k) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin %m umin %k)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond_p3 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_3ops
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin %m umin %k)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin %m umin %k)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %cond_p0 = icmp uge i32 %i, %n
  %cond_p1 = icmp uge i32 %i, %m
  %cond_p2 = icmp uge i32 %i, %k
  %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
  %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
  br i1 %cond, label %exit, label %loop
exit:
  ret i32 %i
}

define i32 @computeSCEVAtScope(i32 %d.0) {
; CHECK-LABEL: 'computeSCEVAtScope'
; CHECK-NEXT:  Classifying expressions for: @computeSCEVAtScope
; CHECK-NEXT:    %d.1 = phi i32 [ %inc, %for.body ], [ %d.0, %for.cond.preheader ]
; CHECK-NEXT:    --> {%d.0,+,1}<nsw><%for.cond> U: full-set S: full-set Exits: 0 LoopDispositions: { %for.cond: Computable, %while.cond: Variant }
; CHECK-NEXT:    %e.1 = phi i32 [ %inc3, %for.body ], [ %d.0, %for.cond.preheader ]
; CHECK-NEXT:    --> {%d.0,+,1}<nsw><%for.cond> U: full-set S: full-set Exits: 0 LoopDispositions: { %for.cond: Computable, %while.cond: Variant }
; CHECK-NEXT:    %0 = select i1 %tobool1, i1 %tobool2, i1 false
; CHECK-NEXT:    --> %0 U: full-set S: full-set Exits: false LoopDispositions: { %for.cond: Variant, %while.cond: Variant }
; CHECK-NEXT:    %inc = add nsw i32 %d.1, 1
; CHECK-NEXT:    --> {(1 + %d.0),+,1}<nw><%for.cond> U: full-set S: full-set Exits: 1 LoopDispositions: { %for.cond: Computable, %while.cond: Variant }
; CHECK-NEXT:    %inc3 = add nsw i32 %e.1, 1
; CHECK-NEXT:    --> {(1 + %d.0),+,1}<nw><%for.cond> U: full-set S: full-set Exits: 1 LoopDispositions: { %for.cond: Computable, %while.cond: Variant }
; CHECK-NEXT:    %f.1 = phi i32 [ %inc8, %for.body5 ], [ 0, %for.cond4.preheader ]
; CHECK-NEXT:    --> {0,+,1}<%for.cond4> U: [0,1) S: [0,1) Exits: 0 LoopDispositions: { %for.cond4: Computable, %while.cond: Variant }
; CHECK-NEXT:    %inc8 = add i32 %f.1, 1
; CHECK-NEXT:    --> {1,+,1}<%for.cond4> U: [1,2) S: [1,2) Exits: 1 LoopDispositions: { %for.cond4: Computable, %while.cond: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @computeSCEVAtScope
; CHECK-NEXT:  Loop %for.cond: backedge-taken count is (-1 * %d.0)
; CHECK-NEXT:  Loop %for.cond: max backedge-taken count is -1
; CHECK-NEXT:  Loop %for.cond: Predicated backedge-taken count is (-1 * %d.0)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %for.cond: Trip multiple is 1
; CHECK-NEXT:  Loop %for.cond4: backedge-taken count is 0
; CHECK-NEXT:  Loop %for.cond4: max backedge-taken count is 0
; CHECK-NEXT:  Loop %for.cond4: Predicated backedge-taken count is 0
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %for.cond4: Trip multiple is 1
; CHECK-NEXT:  Loop %while.cond: <multiple exits> Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %while.cond: Unpredictable max backedge-taken count.
; CHECK-NEXT:  Loop %while.cond: Unpredictable predicated backedge-taken count.
;
entry:
  br label %while.cond

while.cond.loopexit:                              ; preds = %for.cond4
  br label %while.cond

while.cond:                                       ; preds = %while.cond.loopexit, %entry
  br label %for.cond.preheader

for.cond.preheader:                               ; preds = %while.cond
  br label %for.cond

for.cond:                                         ; preds = %for.body, %for.cond.preheader
  %d.1 = phi i32 [ %inc, %for.body ], [ %d.0, %for.cond.preheader ]
  %e.1 = phi i32 [ %inc3, %for.body ], [ %d.0, %for.cond.preheader ]
  %tobool1 = icmp ne i32 %e.1, 0
  %tobool2 = icmp ne i32 %d.1, 0
  %0 = select i1 %tobool1, i1 %tobool2, i1 false
  br i1 %0, label %for.body, label %for.cond4.preheader

for.cond4.preheader:                              ; preds = %for.cond
  br label %for.cond4

for.body:                                         ; preds = %for.cond
  %inc = add nsw i32 %d.1, 1
  %inc3 = add nsw i32 %e.1, 1
  br label %for.cond

for.cond4:                                        ; preds = %for.body5, %for.cond4.preheader
  %f.1 = phi i32 [ %inc8, %for.body5 ], [ 0, %for.cond4.preheader ]
  %exitcond.not = icmp eq i32 %f.1, %e.1
  br i1 %exitcond.not, label %while.cond.loopexit, label %for.body5

for.body5:                                        ; preds = %for.cond4
  %inc8 = add i32 %f.1, 1
  br label %for.cond4
}
