; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -unify-loop-exits -S | FileCheck %s

define void @nested(i1 %PredB3, i1 %PredB4, i1 %PredA4, i1 %PredA3, i32 %X, i32 %Y, i32 %Z) {
; CHECK-LABEL: @nested(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[A1:%.*]]
; CHECK:       A1:
; CHECK-NEXT:    br label [[B1:%.*]]
; CHECK:       B1:
; CHECK-NEXT:    br label [[B2:%.*]]
; CHECK:       B2:
; CHECK-NEXT:    [[X_INC:%.*]] = add i32 [[X:%.*]], 1
; CHECK-NEXT:    br label [[B3:%.*]]
; CHECK:       B3:
; CHECK-NEXT:    br i1 [[PREDB3:%.*]], label [[B4:%.*]], label [[LOOP_EXIT_GUARD1:%.*]]
; CHECK:       B4:
; CHECK-NEXT:    br i1 [[PREDB4:%.*]], label [[B1]], label [[LOOP_EXIT_GUARD1]]
; CHECK:       A2:
; CHECK-NEXT:    br label [[A4:%.*]]
; CHECK:       A3:
; CHECK-NEXT:    br label [[A4]]
; CHECK:       A4:
; CHECK-NEXT:    [[A4_PHI:%.*]] = phi i32 [ [[Y:%.*]], [[A3:%.*]] ], [ [[X_INC_MOVED:%.*]], [[A2:%.*]] ]
; CHECK-NEXT:    br i1 [[PREDA4:%.*]], label [[LOOP_EXIT_GUARD:%.*]], label [[A5:%.*]]
; CHECK:       A5:
; CHECK-NEXT:    br i1 [[PREDA3:%.*]], label [[LOOP_EXIT_GUARD]], label [[A1]]
; CHECK:       C:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[EXIT_PHI:%.*]] = phi i32 [ [[Z:%.*]], [[C:%.*]] ], [ [[EXIT_PHI_MOVED:%.*]], [[LOOP_EXIT_GUARD]] ]
; CHECK-NEXT:    ret void
; CHECK:       loop.exit.guard:
; CHECK-NEXT:    [[GUARD_C:%.*]] = phi i1 [ true, [[A4]] ], [ false, [[A5]] ]
; CHECK-NEXT:    [[EXIT_PHI_MOVED]] = phi i32 [ undef, [[A4]] ], [ [[A4_PHI]], [[A5]] ]
; CHECK-NEXT:    br i1 [[GUARD_C]], label [[C]], label [[EXIT]]
; CHECK:       loop.exit.guard1:
; CHECK-NEXT:    [[GUARD_A3:%.*]] = phi i1 [ true, [[B3]] ], [ false, [[B4]] ]
; CHECK-NEXT:    [[X_INC_MOVED]] = phi i32 [ [[X_INC]], [[B3]] ], [ [[X_INC]], [[B4]] ]
; CHECK-NEXT:    br i1 [[GUARD_A3]], label [[A3]], label [[A2]]
;
entry:
  br label %A1

A1:
  br label %B1

B1:
  br label %B2

B2:
  %X.inc = add i32 %X, 1
  br label %B3

B3:
  br i1 %PredB3, label %B4, label %A3

B4:
  br i1 %PredB4, label %B1, label %A2

A2:
  br label %A4

A3:
  br label %A4

A4:
  %A4.phi = phi i32 [%Y, %A3], [%X.inc, %A2]
  br i1 %PredA4, label %C, label %A5

A5:
  br i1 %PredA3, label %exit, label %A1

C:
  br label %exit

exit:
  %exit.phi = phi i32 [%A4.phi, %A5], [%Z, %C]
  ret void
}
