; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-simplifycfg -verify-scev < %s | FileCheck %s
; RUN: opt -S -loop-simplifycfg -verify-scev -enable-mssa-loop-dependency=true -verify-memoryssa < %s | FileCheck %s

; Verify that the scev information is still valid. Verification should not fail

define void @t_run_test() {
; CHECK-LABEL: @t_run_test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label %[[LOOP_PH:.*]]
; CHECK:       [[LOOP_PH]]:
; CHECK-NEXT:    br label %[[LOOP_BODY:.*]]
; CHECK:       [[LOOP_BODY]]:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, %[[LOOP_PH]] ], [ [[INC:%.*]], %[[LOOP_BODY]] ]
; CHECK-NEXT:    [[INC]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[INC]], 10
; CHECK-NEXT:    br i1 [[CMP]], label %[[LOOP_BODY]], label %[[EXIT:.*]]
; CHECK:       [[EXIT]]:
; CHECK-NEXT:    br label %[[LOOP_BODY2:.*]]
; CHECK:       [[LOOP_BODY2]]:
; CHECK-NEXT:    [[IV2:%.*]] = phi i32 [ 0, %[[EXIT]] ], [ [[INC2:%.*]], %[[LOOP_BODY2]] ]
; CHECK-NEXT:    [[INC2]] = add i32 [[IV2]], 1
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i32 [[INC2]], 10
; CHECK-NEXT:    br i1 [[CMP2]], label %[[LOOP_BODY2]], label %[[EXIT2:.*]]
; CHECK:       [[EXIT2]]:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.ph

loop.ph:
  br label %loop.header

loop.header:
  %iv = phi i32 [0, %loop.ph], [%inc, %loop.body]
  br label %loop.body1

loop.body1:
  br label %loop.body

loop.body:
  %inc = add i32 %iv, 1
  %cmp = icmp ult i32 %inc, 10
  br i1 %cmp, label %loop.header, label %exit

exit:
  br label %loop.body2

loop.body2:
  %iv2 = phi i32 [0, %exit], [%inc2, %loop.body2]
  %inc2 = add i32 %iv2, 1
  %cmp2 = icmp ult i32 %inc2, 10
  br i1 %cmp2, label %loop.body2, label %exit2

exit2:
  ret void
}

