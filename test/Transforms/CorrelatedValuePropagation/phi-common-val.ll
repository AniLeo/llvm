; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -correlated-propagation -S | FileCheck %s
; RUN: opt < %s -passes="correlated-propagation" -S | FileCheck %s

define i8* @simplify_phi_common_value_op0(i8* %ptr, i32* %b) {
; CHECK-LABEL: @simplify_phi_common_value_op0(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ISNULL:%.*]] = icmp eq i8* [[PTR:%.*]], null
; CHECK-NEXT:    br i1 [[ISNULL]], label [[RETURN:%.*]], label [[ELSE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[LB:%.*]] = load i32, i32* [[B:%.*]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[LB]], 1
; CHECK-NEXT:    store i32 [[ADD]], i32* [[B]], align 4
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret i8* [[PTR]]
;
entry:
  %isnull = icmp eq i8* %ptr, null
  br i1 %isnull, label %return, label %else

else:
  %lb = load i32, i32* %b
  %add = add nsw i32 %lb, 1
  store i32 %add, i32* %b
  br label %return

return:
  %r = phi i8* [ %ptr, %else ], [ null, %entry ]
  ret i8* %r
}

define i8* @simplify_phi_common_value_op1(i8* %ptr, i32* %b) {
; CHECK-LABEL: @simplify_phi_common_value_op1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ISNULL:%.*]] = icmp eq i8* [[PTR:%.*]], null
; CHECK-NEXT:    br i1 [[ISNULL]], label [[RETURN:%.*]], label [[ELSE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[LB:%.*]] = load i32, i32* [[B:%.*]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[LB]], 1
; CHECK-NEXT:    store i32 [[ADD]], i32* [[B]], align 4
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret i8* [[PTR]]
;
entry:
  %isnull = icmp eq i8* %ptr, null
  br i1 %isnull, label %return, label %else

else:
  %lb = load i32, i32* %b
  %add = add i32 %lb, 1
  store i32 %add, i32* %b
  br label %return

return:
  %r = phi i8* [ null, %entry], [ %ptr, %else ]
  ret i8* %r
}

define i8 @simplify_phi_multiple_constants(i8 %x, i32* %b) {
; CHECK-LABEL: @simplify_phi_multiple_constants(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IS0:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    br i1 [[IS0]], label [[RETURN:%.*]], label [[ELSE1:%.*]]
; CHECK:       else1:
; CHECK-NEXT:    [[IS42:%.*]] = icmp eq i8 [[X]], 42
; CHECK-NEXT:    br i1 [[IS42]], label [[RETURN]], label [[ELSE2:%.*]]
; CHECK:       else2:
; CHECK-NEXT:    [[LB:%.*]] = load i32, i32* [[B:%.*]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[LB]], 1
; CHECK-NEXT:    store i32 [[ADD]], i32* [[B]], align 4
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret i8 [[X]]
;
entry:
  %is0 = icmp eq i8 %x, 0
  br i1 %is0, label %return, label %else1

else1:
  %is42 = icmp eq i8 %x, 42
  br i1 %is42, label %return, label %else2

else2:
  %lb = load i32, i32* %b
  %add = add i32 %lb, 1
  store i32 %add, i32* %b
  br label %return

return:
  %r = phi i8 [ 0, %entry], [ %x, %else2 ], [ 42, %else1 ]
  ret i8 %r
}

define i8* @simplify_phi_common_value_from_instruction(i8* %ptr_op, i32* %b, i32 %i) {
; CHECK-LABEL: @simplify_phi_common_value_from_instruction(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr i8, i8* [[PTR_OP:%.*]], i32 [[I:%.*]]
; CHECK-NEXT:    [[ISNULL:%.*]] = icmp eq i8* [[PTR]], null
; CHECK-NEXT:    br i1 [[ISNULL]], label [[RETURN:%.*]], label [[ELSE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[LB:%.*]] = load i32, i32* [[B:%.*]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[LB]], 1
; CHECK-NEXT:    store i32 [[ADD]], i32* [[B]], align 4
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    ret i8* [[PTR]]
;
entry:
  %ptr = getelementptr i8, i8* %ptr_op, i32 %i
  %isnull = icmp eq i8* %ptr, null
  br i1 %isnull, label %return, label %else

else:
  %lb = load i32, i32* %b
  %add = add nsw i32 %lb, 1
  store i32 %add, i32* %b
  br label %return

return:
  %r = phi i8* [ %ptr, %else ], [ null, %entry ]
  ret i8* %r
}

; The sub has 'nsw', so it is not safe to propagate that value along
; the bb2 edge because that would propagate poison to the return.
; FIXME: In this particular case, it would be possible to perform the
; transform if we drop nowrap flags from the sub.

define i32 @PR43802(i32 %arg) {
; CHECK-LABEL: @PR43802(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub nsw i32 0, [[ARG:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[ARG]], -2147483648
; CHECK-NEXT:    br i1 [[CMP]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ -2147483648, [[BB2]] ], [ [[SUB]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret i32 [[R]]
;
entry:
  %sub = sub nsw i32 0, %arg
  %cmp = icmp eq i32 %arg, -2147483648
  br i1 %cmp, label %bb2, label %bb3

bb2:
  br label %bb3

bb3:
  %r = phi i32 [ -2147483648, %bb2 ], [ %sub, %entry ]
  ret i32 %r
}

; Same as previous test case, but without nowrap flags.
define i32 @PR43802_without_nowrap(i32 %arg) {
; CHECK-LABEL: @PR43802_without_nowrap(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 0, [[ARG:%.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[ARG]], -2147483648
; CHECK-NEXT:    br i1 [[CMP]], label [[BB2:%.*]], label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 [[SUB]]
;
entry:
  %sub = sub i32 0, %arg
  %cmp = icmp eq i32 %arg, -2147483648
  br i1 %cmp, label %bb2, label %bb3

bb2:
  br label %bb3

bb3:
  %r = phi i32 [ -2147483648, %bb2 ], [ %sub, %entry ]
  ret i32 %r
}

; Similar to the previous case, we know that %y is always poison on the
; entry -> join1 edge, and thus always zero or poison on the join1 -> join2
; edge. We need to make sure that we don't replace zero with "zero or poison".

define i8 @pr50399(i8 %x) {
; CHECK-LABEL: @pr50399(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[X:%.*]], -100
; CHECK-NEXT:    [[Y:%.*]] = add nsw i8 [[X]], -100
; CHECK-NEXT:    br i1 [[CMP]], label [[JOIN1:%.*]], label [[ELSE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i8 [[Y]], 0
; CHECK-NEXT:    br i1 [[CMP2]], label [[JOIN1]], label [[ELSE2:%.*]]
; CHECK:       join1:
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else2:
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    [[PHI:%.*]] = phi i8 [ 0, [[JOIN1]] ], [ [[Y]], [[ELSE2]] ]
; CHECK-NEXT:    ret i8 [[PHI]]
;
  %cmp = icmp slt i8 %x, -100
  %y = add nsw i8 %x, -100
  br i1 %cmp, label %join1, label %else

else:                                               ; preds = %cond.end9
  %cmp2 = icmp eq i8 %y, 0
  br i1 %cmp2, label %join1, label %else2

join1:
  br label %join2

else2:                                         ; preds = %bb
  br label %join2

join2:
  %phi = phi i8 [ 0, %join1 ], [ %y, %else2 ]
  ret i8 %phi
}
