; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

; Check if a value can be deduced as a power of 2, allowing urem optimization.
; i.e. A urem B = A & (B - 1) if B is a power of 2.

define i64 @known_power_of_two_urem_phi(i64 %size, i1 %cmp, i1 %cmp1) {
; CHECK-LABEL: @known_power_of_two_urem_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[COND_TRUE:%.*]], label [[COND_END:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    br i1 [[CMP1:%.*]], label [[COND_TRUE_TRUE:%.*]], label [[COND_TRUE_FALSE:%.*]]
; CHECK:       cond.true.true:
; CHECK-NEXT:    br label [[COND_TRUE_END:%.*]]
; CHECK:       cond.true.false:
; CHECK-NEXT:    br label [[COND_TRUE_END]]
; CHECK:       cond.true.end:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ 2, [[COND_TRUE_TRUE]] ], [ 4, [[COND_TRUE_FALSE]] ]
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[PHI1:%.*]] = phi i64 [ 4096, [[ENTRY:%.*]] ], [ [[PHI]], [[COND_TRUE_END]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[PHI1]], -1
; CHECK-NEXT:    [[UREM:%.*]] = and i64 [[TMP0]], [[SIZE:%.*]]
; CHECK-NEXT:    ret i64 [[UREM]]
;
entry:
  br i1 %cmp, label %cond.true, label %cond.end

cond.true:
  br i1 %cmp1, label %cond.true.true, label %cond.true.false

cond.true.true:
  br label %cond.true.end

cond.true.false:
  br label %cond.true.end

cond.true.end:
  %phi = phi i64 [ 2, %cond.true.true ], [ 4, %cond.true.false ]
  br label %cond.end

cond.end:
  %phi1 = phi i64 [ 4096, %entry ], [ %phi, %cond.true.end ]
  %urem = urem i64 %size, %phi1
  ret i64 %urem
}

define i64 @known_power_of_two_urem_nested_expr(i64 %size, i1 %cmp, i1 %cmp1, i64 %0) {
; CHECK-LABEL: @known_power_of_two_urem_nested_expr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    [[TMP1:%.*]] = shl nuw i64 1, [[TMP0:%.*]]
; CHECK-NEXT:    br label [[COND_END:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP1:%.*]], i64 2, i64 8
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[SELECT]], [[COND_FALSE]] ], [ [[TMP1]], [[COND_TRUE]] ], [ [[PHI]], [[COND_END]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[PHI]], -1
; CHECK-NEXT:    [[UREM:%.*]] = and i64 [[TMP2]], [[SIZE:%.*]]
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ult i64 [[UREM]], 10
; CHECK-NEXT:    br i1 [[CMP2]], label [[COND_END]], label [[END:%.*]]
; CHECK:       end:
; CHECK-NEXT:    ret i64 [[UREM]]
;
entry:
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:
  %1 = shl nuw i64 1, %0
  br label %cond.end

cond.false:
  %select = select i1 %cmp1, i64 2, i64 8
  br label %cond.end

cond.end:
  %phi = phi i64 [ %select, %cond.false ], [ %1, %cond.true ], [ %phi, %cond.end ]
  %2 = phi i64 [ %size, %cond.false ], [ %size, %cond.true ], [ %0, %cond.end ]
  %urem = urem i64 %size, %phi
  %cmp2 = icmp ult i64 %urem, 10
  br i1 %cmp2, label %cond.end, label %end

end:
  ret i64 %urem
}

define i64 @known_power_of_two_urem_negative(i64 %size, i1 %cmp, i64 %0) {
; urem is not replaced if not all operands are power of 2.
;
; CHECK-LABEL: @known_power_of_two_urem_negative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[COND_TRUE:%.*]], label [[COND_END:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    br label [[COND_END]]
; CHECK:       cond.end:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ 4, [[ENTRY:%.*]] ], [ [[TMP0:%.*]], [[COND_TRUE]] ]
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[SIZE:%.*]], [[PHI]]
; CHECK-NEXT:    ret i64 [[UREM]]
;
entry:
  br i1 %cmp, label %cond.true, label %cond.end

cond.true:
  br label %cond.end

cond.end:
  %phi = phi i64 [ 4, %entry ], [ %0, %cond.true ]
  %urem = urem i64 %size, %phi
  ret i64 %urem
}

define i64 @known_power_of_two_urem_loop_mul(i64 %size, i64 %a) {
; CHECK-LABEL: @known_power_of_two_urem_loop_mul(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[START:%.*]] = shl nuw i64 1, [[A:%.*]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[START]], [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[PHI]], -1
; CHECK-NEXT:    [[UREM:%.*]] = and i64 [[TMP0]], [[SIZE:%.*]]
; CHECK-NEXT:    [[ADD]] = add nuw i64 [[SUM]], [[UREM]]
; CHECK-NEXT:    [[I]] = shl nuw i64 [[PHI]], 2
; CHECK-NEXT:    [[ICMP:%.*]] = icmp ult i64 [[PHI]], 25000000
; CHECK-NEXT:    br i1 [[ICMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i64 [[SUM]]
;
entry:
  %start = shl nuw i64 1, %a
  br label %for.body

for.body:
  %phi = phi i64 [ %start, %entry ], [ %i, %for.body ]
  %sum = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %urem = urem i64 %size, %phi
  %add = add nuw i64 %sum, %urem
  %i = mul nuw i64 %phi, 4
  %icmp = icmp ult i64 %i, 100000000
  br i1 %icmp, label %for.body, label %for.end

for.end:
  %r = phi i64 [ %sum, %for.body ]
  ret i64 %r
}

define i64 @known_power_of_two_urem_loop_mul_negative(i64 %size, i64 %a) {
; Cannot deduce induction variable is a power of 2 if it is multiplied by 3.
;
; CHECK-LABEL: @known_power_of_two_urem_loop_mul_negative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[START:%.*]] = shl nuw i64 1, [[A:%.*]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[START]], [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[SIZE:%.*]], [[PHI]]
; CHECK-NEXT:    [[ADD]] = add nuw i64 [[SUM]], [[UREM]]
; CHECK-NEXT:    [[I]] = mul nuw i64 [[PHI]], 3
; CHECK-NEXT:    [[ICMP:%.*]] = icmp ult i64 [[PHI]], 33333334
; CHECK-NEXT:    br i1 [[ICMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i64 [[SUM]]
;
entry:
  %start = shl nuw i64 1, %a
  br label %for.body

for.body:
  %phi = phi i64 [ %start, %entry ], [ %i, %for.body ]
  %sum = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %urem = urem i64 %size, %phi
  %add = add nuw i64 %sum, %urem
  %i = mul nuw i64 %phi, 3
  %icmp = icmp ult i64 %i, 100000000
  br i1 %icmp, label %for.body, label %for.end

for.end:
  %r = phi i64 [ %sum, %for.body ]
  ret i64 %r
}

define i64 @known_power_of_two_urem_loop_shl(i64 %size, i64 %a) {
; CHECK-LABEL: @known_power_of_two_urem_loop_shl(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[START:%.*]] = shl nuw i64 1, [[A:%.*]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[START]], [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[PHI]], -1
; CHECK-NEXT:    [[UREM:%.*]] = and i64 [[TMP0]], [[SIZE:%.*]]
; CHECK-NEXT:    [[ADD]] = add nuw i64 [[SUM]], [[UREM]]
; CHECK-NEXT:    [[I]] = shl nuw i64 [[PHI]], 1
; CHECK-NEXT:    [[ICMP:%.*]] = icmp ult i64 [[PHI]], 50000000
; CHECK-NEXT:    br i1 [[ICMP]], label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i64 [[SUM]]
;
entry:
  %start = shl nuw i64 1, %a
  br label %for.body

for.body:
  %phi = phi i64 [ %start, %entry ], [ %i, %for.body ]
  %sum = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %urem = urem i64 %size, %phi
  %add = add nuw i64 %sum, %urem
  %i = shl nuw i64 %phi, 1
  %icmp = icmp ult i64 %i, 100000000
  br i1 %icmp, label %for.body, label %for.end

for.end:
  %r = phi i64 [ %sum, %for.body ]
  ret i64 %r
}

define i64 @known_power_of_two_urem_loop_lshr(i64 %size, i64 %a) {
; CHECK-LABEL: @known_power_of_two_urem_loop_lshr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[START:%.*]] = shl nuw i64 1, [[A:%.*]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[START]], [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[PHI]], -1
; CHECK-NEXT:    [[UREM:%.*]] = and i64 [[TMP0]], [[SIZE:%.*]]
; CHECK-NEXT:    [[ADD]] = add nuw i64 [[SUM]], [[UREM]]
; CHECK-NEXT:    [[I]] = lshr i64 [[PHI]], 1
; CHECK-NEXT:    [[ICMP_NOT:%.*]] = icmp ult i64 [[PHI]], 2
; CHECK-NEXT:    br i1 [[ICMP_NOT]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i64 [[SUM]]
;
entry:
  %start = shl nuw i64 1, %a
  br label %for.body

for.body:
  %phi = phi i64 [ %start, %entry ], [ %i, %for.body ]
  %sum = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %urem = urem i64 %size, %phi
  %add = add nuw i64 %sum, %urem
  %i = lshr i64 %phi, 1
  %icmp = icmp ugt i64 %i, 0
  br i1 %icmp, label %for.body, label %for.end

for.end:
  %r = phi i64 [ %sum, %for.body ]
  ret i64 %r
}


define i64 @known_power_of_two_urem_loop_ashr(i64 %size, i64 %a) {
; CHECK-LABEL: @known_power_of_two_urem_loop_ashr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ 4096, [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add nsw i64 [[PHI]], -1
; CHECK-NEXT:    [[UREM:%.*]] = and i64 [[TMP0]], [[SIZE:%.*]]
; CHECK-NEXT:    [[ADD]] = add nsw i64 [[SUM]], [[UREM]]
; CHECK-NEXT:    [[I]] = lshr i64 [[PHI]], [[A:%.*]]
; CHECK-NEXT:    [[ICMP_NOT:%.*]] = icmp eq i64 [[I]], 0
; CHECK-NEXT:    br i1 [[ICMP_NOT]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i64 [[SUM]]
;
entry:
  br label %for.body

for.body:
  %phi = phi i64 [ 4096, %entry ], [ %i, %for.body ]
  %sum = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %urem = urem i64 %size, %phi
  %add = add nsw i64 %sum, %urem
  %i = ashr i64 %phi, %a
  %icmp = icmp ugt i64 %i, 0
  br i1 %icmp, label %for.body, label %for.end

for.end:
  %r = phi i64 [ %sum, %for.body ]
  ret i64 %r
}

define i64 @known_power_of_two_urem_loop_ashr_negative(i64 %size, i64 %a) {
; Cannot deduce induction variable is a power of 2 for ashr if its starting
; value is equal to sign bit
;
; CHECK-LABEL: @known_power_of_two_urem_loop_ashr_negative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ -9223372036854775808, [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[SIZE:%.*]], [[PHI]]
; CHECK-NEXT:    [[ADD]] = add nsw i64 [[SUM]], [[UREM]]
; CHECK-NEXT:    [[I]] = ashr i64 [[PHI]], [[A:%.*]]
; CHECK-NEXT:    br i1 true, label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i64 [[SUM]]
;
entry:
  br label %for.body

for.body:
  %phi = phi i64 [ u0x8000000000000000, %entry ], [ %i, %for.body ]
  %sum = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %urem = urem i64 %size, %phi
  %add = add nsw i64 %sum, %urem
  %i = ashr i64 %phi, %a
  %icmp = icmp ugt i64 %i, 0
  br i1 %icmp, label %for.body, label %for.end

for.end:
  %r = phi i64 [ %sum, %for.body ]
  ret i64 %r
}

define i64 @known_power_of_two_urem_loop_ashr_negative_2(i64 %size, i64 %a) {
; Cannot deduce induction variable is a power of 2 for ashr if its starting
; value may equal to sign bit.
;
; CHECK-LABEL: @known_power_of_two_urem_loop_ashr_negative_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[START:%.*]] = shl nuw i64 1, [[A:%.*]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[START]], [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[SIZE:%.*]], [[PHI]]
; CHECK-NEXT:    [[ADD]] = add nsw i64 [[SUM]], [[UREM]]
; CHECK-NEXT:    [[I]] = ashr i64 [[PHI]], 2
; CHECK-NEXT:    [[ICMP_NOT:%.*]] = icmp ult i64 [[PHI]], 4
; CHECK-NEXT:    br i1 [[ICMP_NOT]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i64 [[SUM]]
;
entry:
  %start = shl nuw i64 1, %a
  br label %for.body

for.body:
  %phi = phi i64 [ %start, %entry ], [ %i, %for.body ]
  %sum = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %urem = urem i64 %size, %phi
  %add = add nsw i64 %sum, %urem
  %i = ashr i64 %phi, 2
  %icmp = icmp ugt i64 %i, 0
  br i1 %icmp, label %for.body, label %for.end

for.end:
  %r = phi i64 [ %sum, %for.body ]
  ret i64 %r
}

define i64 @known_power_of_two_urem_loop_negative(i64 %size, i64 %a) {
; Cannot deduce induction variable is a power of 2 if the recurrence is not one
; of the valid arithmetic operations.
;
; CHECK-LABEL: @known_power_of_two_urem_loop_negative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[START:%.*]] = shl nuw i64 1, [[A:%.*]]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[START]], [[ENTRY:%.*]] ], [ [[I:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[SUM:%.*]] = phi i64 [ 0, [[ENTRY]] ], [ [[ADD:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[UREM:%.*]] = urem i64 [[SIZE:%.*]], [[PHI]]
; CHECK-NEXT:    [[ADD]] = add nuw i64 [[SUM]], [[UREM]]
; CHECK-NEXT:    [[I]] = add nuw i64 [[PHI]], 1
; CHECK-NEXT:    br i1 true, label [[FOR_BODY]], label [[FOR_END:%.*]]
; CHECK:       for.end:
; CHECK-NEXT:    ret i64 [[SUM]]
;
entry:
  %start = shl nuw i64 1, %a
  br label %for.body

for.body:
  %phi = phi i64 [ %start, %entry ], [ %i, %for.body ]
  %sum = phi i64 [ 0, %entry ], [ %add, %for.body ]
  %urem = urem i64 %size, %phi
  %add = add nuw i64 %sum, %urem
  %i = add nuw i64 %phi, 1
  %icmp = icmp ugt i64 %i, 0
  br i1 %icmp, label %for.body, label %for.end

for.end:
  %r = phi i64 [ %sum, %for.body ]
  ret i64 %r
}
