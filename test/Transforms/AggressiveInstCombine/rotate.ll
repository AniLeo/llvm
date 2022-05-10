; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=aggressive-instcombine -S | FileCheck %s

; https://bugs.llvm.org/show_bug.cgi?id=34924

define i32 @rotl(i32 %a, i32 %b) {
; CHECK-LABEL: @rotl(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.fshl.i32(i32 [[A:%.*]], i32 [[A]], i32 [[B]])
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shr = lshr i32 %a, %sub
  %shl = shl i32 %a, %b
  %or = or i32 %shr, %shl
  br label %end

end:
  %cond = phi i32 [ %or, %rotbb ], [ %a, %entry ]
  ret i32 %cond
}

define i32 @rotl_commute_phi(i32 %a, i32 %b) {
; CHECK-LABEL: @rotl_commute_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.fshl.i32(i32 [[A:%.*]], i32 [[A]], i32 [[B]])
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shr = lshr i32 %a, %sub
  %shl = shl i32 %a, %b
  %or = or i32 %shr, %shl
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

define i32 @rotl_commute_or(i32 %a, i32 %b) {
; CHECK-LABEL: @rotl_commute_or(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.fshl.i32(i32 [[A:%.*]], i32 [[A]], i32 [[B]])
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shr = lshr i32 %a, %sub
  %shl = shl i32 %a, %b
  %or = or i32 %shl, %shr
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

; Verify that the intrinsic is inserted into a valid position.

define i32 @rotl_insert_valid_location(i32 %a, i32 %b) {
; CHECK-LABEL: @rotl_insert_valid_location(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[OTHER:%.*]] = phi i32 [ 1, [[ROTBB]] ], [ 2, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.fshl.i32(i32 [[A:%.*]], i32 [[A]], i32 [[B]])
; CHECK-NEXT:    [[RES:%.*]] = or i32 [[TMP0]], [[OTHER]]
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shr = lshr i32 %a, %sub
  %shl = shl i32 %a, %b
  %or = or i32 %shr, %shl
  br label %end

end:
  %cond = phi i32 [ %or, %rotbb ], [ %a, %entry ]
  %other = phi i32 [ 1, %rotbb ], [ 2, %entry ]
  %res = or i32 %cond, %other
  ret i32 %res
}

define i32 @rotr(i32 %a, i32 %b) {
; CHECK-LABEL: @rotr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.fshr.i32(i32 [[A:%.*]], i32 [[A]], i32 [[B]])
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shl = shl i32 %a, %sub
  %shr = lshr i32 %a, %b
  %or = or i32 %shr, %shl
  br label %end

end:
  %cond = phi i32 [ %or, %rotbb ], [ %a, %entry ]
  ret i32 %cond
}

define i32 @rotr_commute_phi(i32 %a, i32 %b) {
; CHECK-LABEL: @rotr_commute_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.fshr.i32(i32 [[A:%.*]], i32 [[A]], i32 [[B]])
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shl = shl i32 %a, %sub
  %shr = lshr i32 %a, %b
  %or = or i32 %shr, %shl
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

define i32 @rotr_commute_or(i32 %a, i32 %b) {
; CHECK-LABEL: @rotr_commute_or(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.fshr.i32(i32 [[A:%.*]], i32 [[A]], i32 [[B]])
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shl = shl i32 %a, %sub
  %shr = lshr i32 %a, %b
  %or = or i32 %shl, %shr
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

; Negative test - non-power-of-2 might require urem expansion in the backend.

define i12 @could_be_rotr_weird_type(i12 %a, i12 %b) {
; CHECK-LABEL: @could_be_rotr_weird_type(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i12 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    [[SUB:%.*]] = sub i12 12, [[B]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i12 [[A:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i12 [[A]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i12 [[SHL]], [[SHR]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[COND:%.*]] = phi i12 [ [[A]], [[ENTRY:%.*]] ], [ [[OR]], [[ROTBB]] ]
; CHECK-NEXT:    ret i12 [[COND]]
;
entry:
  %cmp = icmp eq i12 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i12 12, %b
  %shl = shl i12 %a, %sub
  %shr = lshr i12 %a, %b
  %or = or i12 %shl, %shr
  br label %end

end:
  %cond = phi i12 [ %a, %entry ], [ %or, %rotbb ]
  ret i12 %cond
}

; Negative test - wrong phi ops.

define i32 @not_rotr_1(i32 %a, i32 %b) {
; CHECK-LABEL: @not_rotr_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 32, [[B]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[A:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[A]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHL]], [[SHR]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[B]], [[ENTRY:%.*]] ], [ [[OR]], [[ROTBB]] ]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shl = shl i32 %a, %sub
  %shr = lshr i32 %a, %b
  %or = or i32 %shl, %shr
  br label %end

end:
  %cond = phi i32 [ %b, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

; Negative test - too many phi ops.

define i32 @not_rotr_2(i32 %a, i32 %b, i32 %c) {
; CHECK-LABEL: @not_rotr_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 32, [[B]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[A:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[A]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHL]], [[SHR]]
; CHECK-NEXT:    [[CMP42:%.*]] = icmp ugt i32 [[OR]], 42
; CHECK-NEXT:    br i1 [[CMP42]], label [[END]], label [[BOGUS:%.*]]
; CHECK:       bogus:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[A]], [[ENTRY:%.*]] ], [ [[OR]], [[ROTBB]] ], [ [[C:%.*]], [[BOGUS]] ]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shl = shl i32 %a, %sub
  %shr = lshr i32 %a, %b
  %or = or i32 %shl, %shr
  %cmp42 = icmp ugt i32 %or, 42
  br i1 %cmp42, label %end, label %bogus

bogus:
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ], [ %c, %bogus ]
  ret i32 %cond
}

; Negative test - wrong cmp (but this should match?).

define i32 @not_rotr_3(i32 %a, i32 %b) {
; CHECK-LABEL: @not_rotr_3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 32, [[B]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[A:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[A]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHL]], [[SHR]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[A]], [[ENTRY:%.*]] ], [ [[OR]], [[ROTBB]] ]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %cmp = icmp sle i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shl = shl i32 %a, %sub
  %shr = lshr i32 %a, %b
  %or = or i32 %shl, %shr
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

; Negative test - wrong shift.

define i32 @not_rotr_4(i32 %a, i32 %b) {
; CHECK-LABEL: @not_rotr_4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 32, [[B]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[A:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHR:%.*]] = ashr i32 [[A]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHL]], [[SHR]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[A]], [[ENTRY:%.*]] ], [ [[OR]], [[ROTBB]] ]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shl = shl i32 %a, %sub
  %shr = ashr i32 %a, %b
  %or = or i32 %shl, %shr
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

; Negative test - wrong shift for rotate (but can be folded to a generic funnel shift).

define i32 @not_rotr_5(i32 %a, i32 %b) {
; CHECK-LABEL: @not_rotr_5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.fshr.i32(i32 [[B]], i32 [[A:%.*]], i32 [[B]])
; CHECK-NEXT:    ret i32 [[TMP0]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shl = shl i32 %b, %sub
  %shr = lshr i32 %a, %b
  %or = or i32 %shl, %shr
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

; Negative test - wrong sub.

define i32 @not_rotr_6(i32 %a, i32 %b) {
; CHECK-LABEL: @not_rotr_6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 8, [[B]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[A:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[A]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHL]], [[SHR]]
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[A]], [[ENTRY:%.*]] ], [ [[OR]], [[ROTBB]] ]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 8, %b
  %shl = shl i32 %a, %sub
  %shr = lshr i32 %a, %b
  %or = or i32 %shl, %shr
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

; Negative test - extra use. Technically, we could transform this
; because it doesn't increase the instruction count, but we're
; being cautious not to cause a potential perf pessimization for
; targets that do not have a rotate instruction.

define i32 @could_be_rotr(i32 %a, i32 %b, i32* %p) {
; CHECK-LABEL: @could_be_rotr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[END:%.*]], label [[ROTBB:%.*]]
; CHECK:       rotbb:
; CHECK-NEXT:    [[SUB:%.*]] = sub i32 32, [[B]]
; CHECK-NEXT:    [[SHL:%.*]] = shl i32 [[A:%.*]], [[SUB]]
; CHECK-NEXT:    [[SHR:%.*]] = lshr i32 [[A]], [[B]]
; CHECK-NEXT:    [[OR:%.*]] = or i32 [[SHL]], [[SHR]]
; CHECK-NEXT:    store i32 [[OR]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[COND:%.*]] = phi i32 [ [[A]], [[ENTRY:%.*]] ], [ [[OR]], [[ROTBB]] ]
; CHECK-NEXT:    ret i32 [[COND]]
;
entry:
  %cmp = icmp eq i32 %b, 0
  br i1 %cmp, label %end, label %rotbb

rotbb:
  %sub = sub i32 32, %b
  %shl = shl i32 %a, %sub
  %shr = lshr i32 %a, %b
  %or = or i32 %shl, %shr
  store i32 %or, i32* %p
  br label %end

end:
  %cond = phi i32 [ %a, %entry ], [ %or, %rotbb ]
  ret i32 %cond
}

