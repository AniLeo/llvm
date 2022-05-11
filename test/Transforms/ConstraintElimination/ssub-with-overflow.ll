; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

declare { i8, i1 } @llvm.ssub.with.overflow.i8(i8, i8)

define i8 @ssub_no_overflow_due_to_or_conds(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_no_overflow_due_to_or_conds(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sle i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp slt i8 [[A]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = or i1 [[C_2]], [[C_1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[EXIT_FAIL:%.*]], label [[MATH:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B]], i8 [[A]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i8, i1 } [[OP]], 0
; CHECK-NEXT:    ret i8 [[RES]]
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp sle i8 %b, %a
  %c.2 = icmp slt i8 %a, 0
  %or.cond = or i1 %c.2, %c.1
  br i1 %or.cond, label %exit.fail, label %math

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  %res = extractvalue { i8, i1 } %op, 0
  ret i8 %res

exit.fail:
  ret i8 0
}

declare void @use_res({ i8, i1 })

define i8 @ssub_no_overflow_due_to_or_conds_result_used(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_no_overflow_due_to_or_conds_result_used(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sle i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp slt i8 [[A]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = or i1 [[C_2]], [[C_1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[EXIT_FAIL:%.*]], label [[MATH:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B]], i8 [[A]])
; CHECK-NEXT:    call void @use_res({ i8, i1 } [[OP]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i8, i1 } [[OP]], 0
; CHECK-NEXT:    ret i8 [[RES]]
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp sle i8 %b, %a
  %c.2 = icmp slt i8 %a, 0
  %or.cond = or i1 %c.2, %c.1
  br i1 %or.cond, label %exit.fail, label %math

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  call void @use_res({ i8, i1 } %op)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  %res = extractvalue { i8, i1 } %op, 0
  ret i8 %res

exit.fail:
  ret i8 0
}

define i8 @ssub_no_overflow_due_to_and_conds(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_no_overflow_due_to_and_conds(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[A]], 0
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[C_2]], [[C_1]]
; CHECK-NEXT:    br i1 [[AND]], label [[MATH:%.*]], label [[EXIT_FAIL:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B]], i8 [[A]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i8, i1 } [[OP]], 0
; CHECK-NEXT:    ret i8 [[RES]]
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp sge i8 %b, %a
  %c.2 = icmp sge i8 %a, 0
  %and = and i1 %c.2, %c.1
  br i1 %and, label %math, label %exit.fail

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  %res = extractvalue { i8, i1 } %op, 0
  ret i8 %res

exit.fail:
  ret i8 0
}

define i8 @ssub_no_overflow_due_to_and_conds_sub_result_not_used(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_no_overflow_due_to_and_conds_sub_result_not_used(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[A]], 0
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[C_2]], [[C_1]]
; CHECK-NEXT:    br i1 [[AND]], label [[MATH:%.*]], label [[EXIT_FAIL:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B]], i8 [[A]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    ret i8 20
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp sge i8 %b, %a
  %c.2 = icmp sge i8 %a, 0
  %and = and i1 %c.2, %c.1
  br i1 %and, label %math, label %exit.fail

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  ret i8 20

exit.fail:
  ret i8 0
}

define i8 @ssub_may_overflow1(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_may_overflow1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    br i1 [[C_1]], label [[MATH:%.*]], label [[EXIT_FAIL:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B]], i8 [[A]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i8, i1 } [[OP]], 0
; CHECK-NEXT:    ret i8 [[RES]]
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp sge i8 %b, %a
  br i1 %c.1, label %math, label %exit.fail

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  %res = extractvalue { i8, i1 } %op, 0
  ret i8 %res

exit.fail:
  ret i8 0
}

define i8 @ssub_may_overflow2(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_may_overflow2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[A:%.*]], 0
; CHECK-NEXT:    br i1 [[C_1]], label [[MATH:%.*]], label [[EXIT_FAIL:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B:%.*]], i8 [[A]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i8, i1 } [[OP]], 0
; CHECK-NEXT:    ret i8 [[RES]]
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp sge i8 %a, 0
  br i1 %c.1, label %math, label %exit.fail

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  %res = extractvalue { i8, i1 } %op, 0
  ret i8 %res

exit.fail:
  ret i8 0
}

define i8 @ssub_may_overflow3(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_may_overflow3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[A]], -1
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[C_2]], [[C_1]]
; CHECK-NEXT:    br i1 [[AND]], label [[MATH:%.*]], label [[EXIT_FAIL:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B]], i8 [[A]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i8, i1 } [[OP]], 0
; CHECK-NEXT:    ret i8 [[RES]]
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp sge i8 %b, %a
  %c.2 = icmp sge i8 %a, -1
  %and = and i1 %c.2, %c.1
  br i1 %and, label %math, label %exit.fail

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  %res = extractvalue { i8, i1 } %op, 0
  ret i8 %res

exit.fail:
  ret i8 0
}

define i8 @ssub_may_overflow4(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_may_overflow4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[A]], 0
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[C_2]], [[C_1]]
; CHECK-NEXT:    br i1 [[AND]], label [[MATH:%.*]], label [[EXIT_FAIL:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B]], i8 [[A]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i8, i1 } [[OP]], 0
; CHECK-NEXT:    ret i8 [[RES]]
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp uge i8 %b, %a
  %c.2 = icmp sge i8 %a, 0
  %and = and i1 %c.2, %c.1
  br i1 %and, label %math, label %exit.fail

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  %res = extractvalue { i8, i1 } %op, 0
  ret i8 %res

exit.fail:
  ret i8 0
}

define i8 @ssub_may_overflow5(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_may_overflow5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[B]], 0
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[C_2]], [[C_1]]
; CHECK-NEXT:    br i1 [[AND]], label [[MATH:%.*]], label [[EXIT_FAIL:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B]], i8 [[A]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i8, i1 } [[OP]], 0
; CHECK-NEXT:    ret i8 [[RES]]
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp sge i8 %b, %a
  %c.2 = icmp sge i8 %b, 0
  %and = and i1 %c.2, %c.1
  br i1 %and, label %math, label %exit.fail

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  %res = extractvalue { i8, i1 } %op, 0
  ret i8 %res

exit.fail:
  ret i8 0
}

define i8 @ssub_may_overflow6(i8 %a, i8 %b) {
; CHECK-LABEL: @ssub_may_overflow6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C_1:%.*]] = icmp sle i8 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp slt i8 [[B]], 0
; CHECK-NEXT:    [[OR_COND:%.*]] = or i1 [[C_2]], [[C_1]]
; CHECK-NEXT:    br i1 [[OR_COND]], label [[EXIT_FAIL:%.*]], label [[MATH:%.*]]
; CHECK:       math:
; CHECK-NEXT:    [[OP:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[B]], i8 [[A]])
; CHECK-NEXT:    [[STATUS:%.*]] = extractvalue { i8, i1 } [[OP]], 1
; CHECK-NEXT:    br i1 [[STATUS]], label [[EXIT_FAIL]], label [[EXIT_OK:%.*]]
; CHECK:       exit.ok:
; CHECK-NEXT:    [[RES:%.*]] = extractvalue { i8, i1 } [[OP]], 0
; CHECK-NEXT:    ret i8 [[RES]]
; CHECK:       exit.fail:
; CHECK-NEXT:    ret i8 0
;
entry:
  %c.1 = icmp sle i8 %b, %a
  %c.2 = icmp slt i8 %b, 0
  %or.cond = or i1 %c.2, %c.1
  br i1 %or.cond, label %exit.fail, label %math

math:
  %op = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %b, i8 %a)
  %status = extractvalue { i8, i1 } %op, 1
  br i1 %status, label %exit.fail, label %exit.ok

exit.ok:
  %res = extractvalue { i8, i1 } %op, 0
  ret i8 %res

exit.fail:
  ret i8 0
}
