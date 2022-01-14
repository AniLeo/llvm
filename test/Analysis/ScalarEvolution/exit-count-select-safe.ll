; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -disable-output "-passes=print<scalar-evolution>" %s 2>&1 | FileCheck %s

define i32 @logical_and_2ops(i32 %n, i32 %m) {
; CHECK-LABEL: 'logical_and_2ops'
; CHECK-NEXT:  Classifying expressions for: @logical_and_2ops
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin_seq %m) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin_seq %m)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond = select i1 %cond_p0, i1 %cond_p1, i1 false
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_and_2ops
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin_seq %m)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin_seq %m)
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
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin_seq %m) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin_seq %m)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_2ops
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin_seq %m)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin_seq %m)
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
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin_seq %m umin_seq %k) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin_seq %m umin_seq %k)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond_p3 = select i1 %cond_p0, i1 %cond_p1, i1 false
; CHECK-NEXT:    --> %cond_p3 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p3, i1 %cond_p2, i1 false
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_and_3ops
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin_seq %m umin_seq %k)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin_seq %m umin_seq %k)
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
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin_seq %m umin_seq %k) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin_seq %m umin_seq %k)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond_p3 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_3ops
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin_seq %m umin_seq %k)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin_seq %m umin_seq %k)
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

define i32 @logical_or_3ops_duplicate(i32 %n, i32 %m, i32 %k) {
; CHECK-LABEL: 'logical_or_3ops_duplicate'
; CHECK-NEXT:  Classifying expressions for: @logical_or_3ops_duplicate
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin_seq %m umin_seq %k) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin_seq %m umin_seq %k)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond_p4 = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond_p4 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond_p5 = select i1 %cond_p4, i1 true, i1 %cond_p2
; CHECK-NEXT:    --> %cond_p5 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p5, i1 true, i1 %cond_p3
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_3ops_duplicate
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin_seq %m umin_seq %k)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin_seq %m umin_seq %k)
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
  %cond_p2 = icmp uge i32 %i, %n
  %cond_p3 = icmp uge i32 %i, %k
  %cond_p4 = select i1 %cond_p0, i1 true, i1 %cond_p1
  %cond_p5 = select i1 %cond_p4, i1 true, i1 %cond_p2
  %cond = select i1 %cond_p5, i1 true, i1 %cond_p3
  br i1 %cond, label %exit, label %loop
exit:
  ret i32 %i
}

define i32 @logical_or_3ops_redundant_uminseq_operand(i32 %n, i32 %m, i32 %k) {
; CHECK-LABEL: 'logical_or_3ops_redundant_uminseq_operand'
; CHECK-NEXT:  Classifying expressions for: @logical_or_3ops_redundant_uminseq_operand
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: ((%n umin %m) umin_seq %k) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + ((%n umin %m) umin_seq %k)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
; CHECK-NEXT:    --> (%n umin %m) U: full-set S: full-set Exits: (%n umin %m) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond_p3 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_3ops_redundant_uminseq_operand
; CHECK-NEXT:  Loop %loop: backedge-taken count is ((%n umin %m) umin_seq %k)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is ((%n umin %m) umin_seq %k)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
  %cond_p0 = icmp uge i32 %i, %umin
  %cond_p1 = icmp uge i32 %i, %n
  %cond_p2 = icmp uge i32 %i, %k
  %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
  %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
  br i1 %cond, label %exit, label %loop
exit:
  ret i32 %i
}

define i32 @logical_or_3ops_redundant_umin_operand(i32 %n, i32 %m, i32 %k) {
; CHECK-LABEL: 'logical_or_3ops_redundant_umin_operand'
; CHECK-NEXT:  Classifying expressions for: @logical_or_3ops_redundant_umin_operand
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin_seq %k umin_seq %m) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin_seq %k umin_seq %m)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
; CHECK-NEXT:    --> (%n umin %m) U: full-set S: full-set Exits: (%n umin %m) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond_p3 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_3ops_redundant_umin_operand
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin_seq %k umin_seq %m)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin_seq %k umin_seq %m)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
  %cond_p0 = icmp uge i32 %i, %n
  %cond_p1 = icmp uge i32 %i, %k
  %cond_p2 = icmp uge i32 %i, %umin
  %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
  %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
  br i1 %cond, label %exit, label %loop
exit:
  ret i32 %i
}

define i32 @logical_or_4ops_redundant_operand_across_umins(i32 %n, i32 %m, i32 %k, i32 %q) {
; CHECK-LABEL: 'logical_or_4ops_redundant_operand_across_umins'
; CHECK-NEXT:  Classifying expressions for: @logical_or_4ops_redundant_operand_across_umins
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: ((%n umin %m) umin_seq %k umin_seq %q) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + ((%n umin %m) umin_seq %k umin_seq %q)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
; CHECK-NEXT:    --> (%n umin %m) U: full-set S: full-set Exits: (%n umin %m) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %umin2 = call i32 @llvm.umin.i32(i32 %n, i32 %q)
; CHECK-NEXT:    --> (%n umin %q) U: full-set S: full-set Exits: (%n umin %q) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond_p3 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_4ops_redundant_operand_across_umins
; CHECK-NEXT:  Loop %loop: backedge-taken count is ((%n umin %m) umin_seq %k umin_seq %q)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is ((%n umin %m) umin_seq %k umin_seq %q)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
  %umin2 = call i32 @llvm.umin.i32(i32 %n, i32 %q)
  %cond_p0 = icmp uge i32 %i, %umin
  %cond_p1 = icmp uge i32 %i, %k
  %cond_p2 = icmp uge i32 %i, %umin2
  %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
  %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
  br i1 %cond, label %exit, label %loop
exit:
  ret i32 %i
}

define i32 @logical_or_3ops_operand_wise_redundant_umin(i32 %n, i32 %m, i32 %k) {
; CHECK-LABEL: 'logical_or_3ops_operand_wise_redundant_umin'
; CHECK-NEXT:  Classifying expressions for: @logical_or_3ops_operand_wise_redundant_umin
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: ((%n umin %m) umin_seq %k) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + ((%n umin %m) umin_seq %k)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
; CHECK-NEXT:    --> (%n umin %m) U: full-set S: full-set Exits: (%n umin %m) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %umin2 = call i32 @llvm.umin.i32(i32 %n, i32 %k)
; CHECK-NEXT:    --> (%n umin %k) U: full-set S: full-set Exits: (%n umin %k) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond_p3 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_3ops_operand_wise_redundant_umin
; CHECK-NEXT:  Loop %loop: backedge-taken count is ((%n umin %m) umin_seq %k)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is ((%n umin %m) umin_seq %k)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
  %umin2 = call i32 @llvm.umin.i32(i32 %n, i32 %k)
  %cond_p0 = icmp uge i32 %i, %umin
  %cond_p1 = icmp uge i32 %i, %k
  %cond_p2 = icmp uge i32 %i, %umin2
  %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
  %cond = select i1 %cond_p3, i1 true, i1 %cond_p2
  br i1 %cond, label %exit, label %loop
exit:
  ret i32 %i
}

define i32 @logical_or_3ops_partially_redundant_umin(i32 %n, i32 %m, i32 %k) {
; CHECK-LABEL: 'logical_or_3ops_partially_redundant_umin'
; CHECK-NEXT:  Classifying expressions for: @logical_or_3ops_partially_redundant_umin
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin_seq (%m umin %k)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin_seq (%m umin %k))) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
; CHECK-NEXT:    --> (%n umin %m) U: full-set S: full-set Exits: (%n umin %m) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %umin2 = call i32 @llvm.umin.i32(i32 %umin, i32 %k)
; CHECK-NEXT:    --> (%n umin %m umin %k) U: full-set S: full-set Exits: (%n umin %m umin %k) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %cond = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_3ops_partially_redundant_umin
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin_seq (%m umin %k))
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin_seq (%m umin %k))
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %umin = call i32 @llvm.umin.i32(i32 %n, i32 %m)
  %umin2 = call i32 @llvm.umin.i32(i32 %umin, i32 %k)
  %cond_p0 = icmp uge i32 %i, %n
  %cond_p1 = icmp uge i32 %i, %umin2
  %cond = select i1 %cond_p0, i1 true, i1 %cond_p1
  br i1 %cond, label %exit, label %loop
exit:
  ret i32 %i
}

define i32 @logical_or_5ops_redundant_opearand_of_inner_uminseq(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e) {
; CHECK-LABEL: 'logical_or_5ops_redundant_opearand_of_inner_uminseq'
; CHECK-NEXT:  Classifying expressions for: @logical_or_5ops_redundant_opearand_of_inner_uminseq
; CHECK-NEXT:    %first.i = phi i32 [ 0, %entry ], [ %first.i.next, %first.loop ]
; CHECK-NEXT:    --> {0,+,1}<%first.loop> U: full-set S: full-set Exits: (%e umin_seq %d umin_seq %a) LoopDispositions: { %first.loop: Computable }
; CHECK-NEXT:    %first.i.next = add i32 %first.i, 1
; CHECK-NEXT:    --> {1,+,1}<%first.loop> U: full-set S: full-set Exits: (1 + (%e umin_seq %d umin_seq %a)) LoopDispositions: { %first.loop: Computable }
; CHECK-NEXT:    %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
; CHECK-NEXT:    --> %cond_p3 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %first.loop: Variant }
; CHECK-NEXT:    %cond_p4 = select i1 %cond_p3, i1 true, i1 %cond_p2
; CHECK-NEXT:    --> %cond_p4 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %first.loop: Variant }
; CHECK-NEXT:    %i = phi i32 [ 0, %first.loop.exit ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%a umin_seq %b umin_seq ((%e umin_seq %d) umin %c)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%a umin_seq %b umin_seq ((%e umin_seq %d) umin %c))) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %c, i32 %d)
; CHECK-NEXT:    --> (%c umin %d) U: full-set S: full-set Exits: (%c umin %d) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %umin2 = call i32 @llvm.umin.i32(i32 %umin, i32 %first.i)
; CHECK-NEXT:    --> ({0,+,1}<%first.loop> umin %c umin %d) U: full-set S: full-set --> ((%e umin_seq %d umin_seq %a) umin %c umin %d) U: full-set S: full-set Exits: ((%e umin_seq %d umin_seq %a) umin %c umin %d) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %cond_p8 = select i1 %cond_p5, i1 true, i1 %cond_p6
; CHECK-NEXT:    --> %cond_p8 U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %cond = select i1 %cond_p8, i1 true, i1 %cond_p7
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_or_5ops_redundant_opearand_of_inner_uminseq
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%a umin_seq %b umin_seq ((%e umin_seq %d) umin %c))
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%a umin_seq %b umin_seq ((%e umin_seq %d) umin %c))
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
; CHECK-NEXT:  Loop %first.loop: backedge-taken count is (%e umin_seq %d umin_seq %a)
; CHECK-NEXT:  Loop %first.loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %first.loop: Predicated backedge-taken count is (%e umin_seq %d umin_seq %a)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %first.loop: Trip multiple is 1
;
entry:
  br label %first.loop
first.loop:
  %first.i = phi i32 [0, %entry], [%first.i.next, %first.loop]
  %first.i.next = add i32 %first.i, 1
  %cond_p0 = icmp uge i32 %first.i, %e
  %cond_p1 = icmp uge i32 %first.i, %d
  %cond_p2 = icmp uge i32 %first.i, %a
  %cond_p3 = select i1 %cond_p0, i1 true, i1 %cond_p1
  %cond_p4 = select i1 %cond_p3, i1 true, i1 %cond_p2
  br i1 %cond_p4, label %first.loop.exit, label %first.loop
first.loop.exit:
  br label %loop
loop:
  %i = phi i32 [0, %first.loop.exit], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %umin = call i32 @llvm.umin.i32(i32 %c, i32 %d)
  %umin2 = call i32 @llvm.umin.i32(i32 %umin, i32 %first.i)
  %cond_p5 = icmp uge i32 %i, %a
  %cond_p6 = icmp uge i32 %i, %b
  %cond_p7 = icmp uge i32 %i, %umin2
  %cond_p8 = select i1 %cond_p5, i1 true, i1 %cond_p6
  %cond = select i1 %cond_p8, i1 true, i1 %cond_p7
  br i1 %cond, label %exit, label %loop
exit:
  ret i32 %i
}

define i32 @logical_and_2ops_and_constant(i32 %n, i32 %m, i32 %k) {
; CHECK-LABEL: 'logical_and_2ops_and_constant'
; CHECK-NEXT:  Classifying expressions for: @logical_and_2ops_and_constant
; CHECK-NEXT:    %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: [0,43) S: [0,43) Exits: (%n umin_seq 42) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i32 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: [1,44) S: [1,44) Exits: (1 + (%n umin_seq 42))<nuw><nsw> LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %umin = call i32 @llvm.umin.i32(i32 %n, i32 42)
; CHECK-NEXT:    --> (42 umin %n) U: [0,43) S: [0,43) Exits: (42 umin %n) LoopDispositions: { %loop: Invariant }
; CHECK-NEXT:    %cond = select i1 %cond_p1, i1 true, i1 %cond_p0
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:  Determining loop execution counts for: @logical_and_2ops_and_constant
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin_seq 42)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is 42
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin_seq 42)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i32 [0, %entry], [%i.next, %loop]
  %i.next = add i32 %i, 1
  %umin = call i32 @llvm.umin.i32(i32 %n, i32 42)
  %cond_p0 = icmp uge i32 %i, %umin
  %cond_p1 = icmp uge i32 %i, %n
  %cond = select i1 %cond_p1, i1 true, i1 %cond_p0
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

define i64 @uminseq_vs_ptrtoint_complexity(i64 %n, i64 %m, i64* %ptr) {
; CHECK-LABEL: 'uminseq_vs_ptrtoint_complexity'
; CHECK-NEXT:  Classifying expressions for: @uminseq_vs_ptrtoint_complexity
; CHECK-NEXT:    %i = phi i64 [ 0, %entry ], [ %i.next, %loop ]
; CHECK-NEXT:    --> {0,+,1}<%loop> U: full-set S: full-set Exits: (%n umin_seq %m) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %i.next = add i64 %i, 1
; CHECK-NEXT:    --> {1,+,1}<%loop> U: full-set S: full-set Exits: (1 + (%n umin_seq %m)) LoopDispositions: { %loop: Computable }
; CHECK-NEXT:    %cond = select i1 %cond_p0, i1 %cond_p1, i1 false
; CHECK-NEXT:    --> %cond U: full-set S: full-set Exits: <<Unknown>> LoopDispositions: { %loop: Variant }
; CHECK-NEXT:    %ptr.int = ptrtoint i64* %ptr to i64
; CHECK-NEXT:    --> (ptrtoint i64* %ptr to i64) U: full-set S: full-set
; CHECK-NEXT:    %r = add i64 %i, %ptr.int
; CHECK-NEXT:    --> {(ptrtoint i64* %ptr to i64),+,1}<%loop> U: full-set S: full-set --> ((%n umin_seq %m) + (ptrtoint i64* %ptr to i64)) U: full-set S: full-set
; CHECK-NEXT:  Determining loop execution counts for: @uminseq_vs_ptrtoint_complexity
; CHECK-NEXT:  Loop %loop: backedge-taken count is (%n umin_seq %m)
; CHECK-NEXT:  Loop %loop: max backedge-taken count is -1
; CHECK-NEXT:  Loop %loop: Predicated backedge-taken count is (%n umin_seq %m)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %loop: Trip multiple is 1
;
entry:
  br label %loop
loop:
  %i = phi i64 [0, %entry], [%i.next, %loop]
  %i.next = add i64 %i, 1
  %cond_p0 = icmp ult i64 %i, %n
  %cond_p1 = icmp ult i64 %i, %m
  %cond = select i1 %cond_p0, i1 %cond_p1, i1 false
  br i1 %cond, label %loop, label %exit
exit:
  %ptr.int = ptrtoint i64* %ptr to i64
  %r = add i64 %i, %ptr.int
  ret i64 %r
}

declare i32 @llvm.umin.i32(i32, i32)
