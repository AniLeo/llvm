; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -analyze -scalar-evolution 2>&1 | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @unsimplified_and1(i32 %n) {
; CHECK-LABEL: 'unsimplified_and1'
; CHECK-NEXT:  Classifying expressions for: @unsimplified_and1
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: %n LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (1 + %n) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %and = and i1 %becond, true
; CHECK-NEXT:    --> %becond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @unsimplified_and1
; CHECK-NEXT:  Loop %loop: backedge-taken count is %n
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is %n
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ule i32 %iv.inc, %n
  %and = and i1 %becond, true
  br i1 %and, label %loop, label %leave

leave:
  ret void
}

define void @unsimplified_and2(i32 %n) {
; CHECK-LABEL: 'unsimplified_and2'
; CHECK-NEXT:  Classifying expressions for: @unsimplified_and2
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: %n LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (1 + %n) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %and = and i1 true, %becond
; CHECK-NEXT:    --> %and U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @unsimplified_and2
; CHECK-NEXT:  Loop %loop: backedge-taken count is %n
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is %n
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ule i32 %iv.inc, %n
  %and = and i1 true, %becond
  br i1 %and, label %loop, label %leave

leave:
  ret void
}

define void @unsimplified_and3(i32 %n) {
; CHECK-LABEL: 'unsimplified_and3'
; CHECK-NEXT:  Classifying expressions for: @unsimplified_and3
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,1) S: [0,1) Exits: 0 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%loop> U: [1,2) S: [1,2) Exits: 1 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %and = and i1 false, %becond
; CHECK-NEXT:    --> %and U: [0,-1) S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @unsimplified_and3
; CHECK-NEXT:  Loop %loop: backedge-taken count is false
; CHECK-NEXT:  Loop %loop: max backedge-taken count is false
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is false
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ule i32 %iv.inc, %n
  %and = and i1 false, %becond
  br i1 %and, label %loop, label %leave

leave:
  ret void
}

define void @unsimplified_and4(i32 %n) {
; CHECK-LABEL: 'unsimplified_and4'
; CHECK-NEXT:  Classifying expressions for: @unsimplified_and4
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,1) S: [0,1) Exits: 0 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%loop> U: [1,2) S: [1,2) Exits: 1 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %and = and i1 %becond, false
; CHECK-NEXT:    --> false U: [0,-1) S: [0,-1) Exits: false LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:  Determining loop execution counts for: @unsimplified_and4
; CHECK-NEXT:  Loop %loop: backedge-taken count is false
; CHECK-NEXT:  Loop %loop: max backedge-taken count is false
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is false
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ule i32 %iv.inc, %n
  %and = and i1 %becond, false
  br i1 %and, label %loop, label %leave

leave:
  ret void
}

define void @unsimplified_or1(i32 %n) {
; CHECK-LABEL: 'unsimplified_or1'
; CHECK-NEXT:  Classifying expressions for: @unsimplified_or1
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or = or i1 %becond, true
; CHECK-NEXT:    --> %or U: [-1,0) S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @unsimplified_or1
; CHECK-NEXT:  Loop %loop: Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable max backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable predicated backedge-taken count.
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ule i32 %iv.inc, %n
  %or = or i1 %becond, true
  br i1 %or, label %loop, label %leave

leave:
  ret void
}

define void @unsimplified_or2(i32 %n) {
; CHECK-LABEL: 'unsimplified_or2'
; CHECK-NEXT:  Classifying expressions for: @unsimplified_or2
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or = or i1 true, %becond
; CHECK-NEXT:    --> %or U: [-1,0) S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @unsimplified_or2
; CHECK-NEXT:  Loop %loop: Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable max backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable predicated backedge-taken count.
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ule i32 %iv.inc, %n
  %or = or i1 true, %becond
  br i1 %or, label %loop, label %leave

leave:
  ret void
}

define void @unsimplified_or3(i32 %n) {
; CHECK-LABEL: 'unsimplified_or3'
; CHECK-NEXT:  Classifying expressions for: @unsimplified_or3
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: %n LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (1 + %n) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or = or i1 false, %becond
; CHECK-NEXT:    --> %or U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @unsimplified_or3
; CHECK-NEXT:  Loop %loop: backedge-taken count is %n
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is %n
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ule i32 %iv.inc, %n
  %or = or i1 false, %becond
  br i1 %or, label %loop, label %leave

leave:
  ret void
}

define void @unsimplified_or4(i32 %n) {
; CHECK-LABEL: 'unsimplified_or4'
; CHECK-NEXT:  Classifying expressions for: @unsimplified_or4
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: %n LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (1 + %n) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or = or i1 %becond, false
; CHECK-NEXT:    --> %becond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @unsimplified_or4
; CHECK-NEXT:  Loop %loop: backedge-taken count is %n
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is %n
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ule i32 %iv.inc, %n
  %or = or i1 %becond, false
  br i1 %or, label %loop, label %leave

leave:
  ret void
}

define void @reversed_and1(i32 %n) {
; CHECK-LABEL: 'reversed_and1'
; CHECK-NEXT:  Classifying expressions for: @reversed_and1
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: %n LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (1 + %n) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %and = and i1 %becond, true
; CHECK-NEXT:    --> %becond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @reversed_and1
; CHECK-NEXT:  Loop %loop: backedge-taken count is %n
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is %n
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ugt i32 %iv.inc, %n
  %and = and i1 %becond, true
  br i1 %and, label %leave, label %loop

leave:
  ret void
}

define void @reversed_and2(i32 %n) {
; CHECK-LABEL: 'reversed_and2'
; CHECK-NEXT:  Classifying expressions for: @reversed_and2
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: %n LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (1 + %n) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %and = and i1 true, %becond
; CHECK-NEXT:    --> %and U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @reversed_and2
; CHECK-NEXT:  Loop %loop: backedge-taken count is %n
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is %n
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ugt i32 %iv.inc, %n
  %and = and i1 true, %becond
  br i1 %and, label %leave, label %loop

leave:
  ret void
}

define void @reversed_and3(i32 %n) {
; CHECK-LABEL: 'reversed_and3'
; CHECK-NEXT:  Classifying expressions for: @reversed_and3
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %and = and i1 false, %becond
; CHECK-NEXT:    --> %and U: [0,-1) S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @reversed_and3
; CHECK-NEXT:  Loop %loop: Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable max backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable predicated backedge-taken count.
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ugt i32 %iv.inc, %n
  %and = and i1 false, %becond
  br i1 %and, label %leave, label %loop

leave:
  ret void
}

define void @reversed_and4(i32 %n) {
; CHECK-LABEL: 'reversed_and4'
; CHECK-NEXT:  Classifying expressions for: @reversed_and4
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: <<Unknown>> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %and = and i1 %becond, false
; CHECK-NEXT:    --> false U: [0,-1) S: [0,-1) Exits: false LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:  Determining loop execution counts for: @reversed_and4
; CHECK-NEXT:  Loop %loop: Unpredictable backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable max backedge-taken count.
; CHECK-NEXT:  Loop %loop: Unpredictable predicated backedge-taken count.
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ugt i32 %iv.inc, %n
  %and = and i1 %becond, false
  br i1 %and, label %leave, label %loop

leave:
  ret void
}

define void @reversed_or1(i32 %n) {
; CHECK-LABEL: 'reversed_or1'
; CHECK-NEXT:  Classifying expressions for: @reversed_or1
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,1) S: [0,1) Exits: 0 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%loop> U: [1,2) S: [1,2) Exits: 1 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or = or i1 %becond, true
; CHECK-NEXT:    --> %or U: [-1,0) S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @reversed_or1
; CHECK-NEXT:  Loop %loop: backedge-taken count is false
; CHECK-NEXT:  Loop %loop: max backedge-taken count is false
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is false
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ugt i32 %iv.inc, %n
  %or = or i1 %becond, true
  br i1 %or, label %leave, label %loop

leave:
  ret void
}

define void @reversed_or2(i32 %n) {
; CHECK-LABEL: 'reversed_or2'
; CHECK-NEXT:  Classifying expressions for: @reversed_or2
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,1) S: [0,1) Exits: 0 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><nsw><%loop> U: [1,2) S: [1,2) Exits: 1 LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or = or i1 true, %becond
; CHECK-NEXT:    --> %or U: [-1,0) S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @reversed_or2
; CHECK-NEXT:  Loop %loop: backedge-taken count is false
; CHECK-NEXT:  Loop %loop: max backedge-taken count is false
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is false
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ugt i32 %iv.inc, %n
  %or = or i1 true, %becond
  br i1 %or, label %leave, label %loop

leave:
  ret void
}

define void @reversed_or3(i32 %n) {
; CHECK-LABEL: 'reversed_or3'
; CHECK-NEXT:  Classifying expressions for: @reversed_or3
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: %n LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (1 + %n) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or = or i1 false, %becond
; CHECK-NEXT:    --> %or U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @reversed_or3
; CHECK-NEXT:  Loop %loop: backedge-taken count is %n
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is %n
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ugt i32 %iv.inc, %n
  %or = or i1 false, %becond
  br i1 %or, label %leave, label %loop

leave:
  ret void
}

define void @reversed_or4(i32 %n) {
; CHECK-LABEL: 'reversed_or4'
; CHECK-NEXT:  Classifying expressions for: @reversed_or4
; CHECK-NEXT:    %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
; CHECK-NEXT:    --> {0,+,1}<nuw><nsw><%loop> U: [0,-2147483648) S: [0,-2147483648) Exits: %n LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %iv.inc = add nsw i32 %iv, 1
; CHECK-NEXT:    --> {1,+,1}<nuw><%loop> U: [1,0) S: [1,0) Exits: (1 + %n) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %or = or i1 %becond, false
; CHECK-NEXT:    --> %becond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @reversed_or4
; CHECK-NEXT:  Loop %loop: backedge-taken count is %n
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is %n
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.inc, %loop ]
  %iv.inc = add nsw i32 %iv, 1
  %becond = icmp ugt i32 %iv.inc, %n
  %or = or i1 %becond, false
  br i1 %or, label %leave, label %loop

leave:
  ret void
}
