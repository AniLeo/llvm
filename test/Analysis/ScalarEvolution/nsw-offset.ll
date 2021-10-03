; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -S -disable-output "-passes=print<scalar-evolution>" 2>&1 | FileCheck %s

; ScalarEvolution should be able to fold away the sign-extensions
; on this loop with a primary induction variable incremented with
; a nsw add of 2.

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128"

define void @foo(i32 %no, double* nocapture %d, double* nocapture %q) nounwind {
; CHECK-LABEL: 'foo'
; CHECK-NEXT:  Classifying expressions for: @foo
; CHECK-NEXT:    %n = and i32 %no, -2
; CHECK-NEXT:    --> (2 * (%no /u 2))<nuw> U: [0,-1) S: [-2147483648,2147483647)
; CHECK-NEXT:    %i.01 = phi i32 [ %16, %bb1 ], [ 0, %bb.nph ]
; CHECK-NEXT:    --> {0,+,2}<nuw><nsw><%bb> U: [0,2147483645) S: [0,2147483645) Exits: (2 * ((-1 + (2 * (%no /u 2))<nuw>) /u 2))<nuw> LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %1 = sext i32 %i.01 to i64
; CHECK-NEXT:    --> {0,+,2}<nuw><nsw><%bb> U: [0,2147483645) S: [0,2147483645) Exits: (2 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw> LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %2 = getelementptr inbounds double, double* %d, i64 %1
; CHECK-NEXT:    --> {%d,+,16}<nuw><%bb> U: full-set S: full-set Exits: ((16 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw> + %d) LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %4 = sext i32 %i.01 to i64
; CHECK-NEXT:    --> {0,+,2}<nuw><nsw><%bb> U: [0,2147483645) S: [0,2147483645) Exits: (2 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw> LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %5 = getelementptr inbounds double, double* %q, i64 %4
; CHECK-NEXT:    --> {%q,+,16}<nuw><%bb> U: full-set S: full-set Exits: ((16 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw> + %q) LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %7 = or i32 %i.01, 1
; CHECK-NEXT:    --> {1,+,2}<nuw><nsw><%bb> U: [1,2147483646) S: [1,2147483646) Exits: (1 + (2 * ((-1 + (2 * (%no /u 2))<nuw>) /u 2))<nuw>)<nuw><nsw> LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %8 = sext i32 %7 to i64
; CHECK-NEXT:    --> {1,+,2}<nuw><nsw><%bb> U: [1,2147483646) S: [1,2147483646) Exits: (1 + (2 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw>)<nuw><nsw> LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %9 = getelementptr inbounds double, double* %q, i64 %8
; CHECK-NEXT:    --> {(8 + %q),+,16}<nuw><%bb> U: full-set S: full-set Exits: (8 + (16 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw> + %q) LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %t7 = add nsw i32 %i.01, 1
; CHECK-NEXT:    --> {1,+,2}<nuw><nsw><%bb> U: [1,2147483646) S: [1,2147483646) Exits: (1 + (2 * ((-1 + (2 * (%no /u 2))<nuw>) /u 2))<nuw>)<nuw><nsw> LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %t8 = sext i32 %t7 to i64
; CHECK-NEXT:    --> {1,+,2}<nuw><nsw><%bb> U: [1,2147483646) S: [1,2147483646) Exits: (1 + (2 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw>)<nuw><nsw> LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %t9 = getelementptr inbounds double, double* %q, i64 %t8
; CHECK-NEXT:    --> {(8 + %q),+,16}<nuw><%bb> U: full-set S: full-set Exits: (8 + (16 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw> + %q) LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %14 = sext i32 %i.01 to i64
; CHECK-NEXT:    --> {0,+,2}<nuw><nsw><%bb> U: [0,2147483645) S: [0,2147483645) Exits: (2 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw> LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %15 = getelementptr inbounds double, double* %d, i64 %14
; CHECK-NEXT:    --> {%d,+,16}<nuw><%bb> U: full-set S: full-set Exits: ((16 * ((1 + (zext i32 (-2 + (2 * (%no /u 2))<nuw>) to i64))<nuw><nsw> /u 2))<nuw><nsw> + %d) LoopDispositions: { %bb: Computable }
; CHECK-NEXT:    %16 = add nsw i32 %i.01, 2
; CHECK-NEXT:    --> {2,+,2}<nuw><nsw><%bb> U: [2,2147483647) S: [2,2147483647) Exits: (2 + (2 * ((-1 + (2 * (%no /u 2))<nuw>) /u 2))<nuw>) LoopDispositions: { %bb: Computable }
; CHECK-NEXT:  Determining loop execution counts for: @foo
; CHECK-NEXT:  Loop %bb: backedge-taken count is ((-1 + (2 * (%no /u 2))<nuw>) /u 2)
; CHECK-NEXT:  Loop %bb: max backedge-taken count is 1073741822
; CHECK-NEXT:  Loop %bb: Predicated backedge-taken count is ((-1 + (2 * (%no /u 2))<nuw>) /u 2)
; CHECK-NEXT:   Predicates:
; CHECK:       Loop %bb: Trip multiple is 1
;
entry:
  %n = and i32 %no, 4294967294
  %0 = icmp sgt i32 %n, 0                         ; <i1> [#uses=1]
  br i1 %0, label %bb.nph, label %return

bb.nph:                                           ; preds = %entry
  br label %bb

bb:                                               ; preds = %bb.nph, %bb1
  %i.01 = phi i32 [ %16, %bb1 ], [ 0, %bb.nph ]   ; <i32> [#uses=5]

  %1 = sext i32 %i.01 to i64                      ; <i64> [#uses=1]

  %2 = getelementptr inbounds double, double* %d, i64 %1  ; <double*> [#uses=1]

  %3 = load double, double* %2, align 8                   ; <double> [#uses=1]
  %4 = sext i32 %i.01 to i64                      ; <i64> [#uses=1]
  %5 = getelementptr inbounds double, double* %q, i64 %4  ; <double*> [#uses=1]
  %6 = load double, double* %5, align 8                   ; <double> [#uses=1]
  %7 = or i32 %i.01, 1                            ; <i32> [#uses=1]

  %8 = sext i32 %7 to i64                         ; <i64> [#uses=1]

  %9 = getelementptr inbounds double, double* %q, i64 %8  ; <double*> [#uses=1]

; Artificially repeat the above three instructions, this time using
; add nsw instead of or.
  %t7 = add nsw i32 %i.01, 1                            ; <i32> [#uses=1]

  %t8 = sext i32 %t7 to i64                         ; <i64> [#uses=1]

  %t9 = getelementptr inbounds double, double* %q, i64 %t8  ; <double*> [#uses=1]

  %10 = load double, double* %9, align 8                  ; <double> [#uses=1]
  %11 = fadd double %6, %10                       ; <double> [#uses=1]
  %12 = fadd double %11, 3.200000e+00             ; <double> [#uses=1]
  %13 = fmul double %3, %12                       ; <double> [#uses=1]
  %14 = sext i32 %i.01 to i64                     ; <i64> [#uses=1]
  %15 = getelementptr inbounds double, double* %d, i64 %14 ; <double*> [#uses=1]
  store double %13, double* %15, align 8
  %16 = add nsw i32 %i.01, 2                      ; <i32> [#uses=2]
  br label %bb1

bb1:                                              ; preds = %bb
  %17 = icmp slt i32 %16, %n                      ; <i1> [#uses=1]
  br i1 %17, label %bb, label %bb1.return_crit_edge

bb1.return_crit_edge:                             ; preds = %bb1
  br label %return

return:                                           ; preds = %bb1.return_crit_edge, %entry
  ret void
}
