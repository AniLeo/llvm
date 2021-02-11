; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i64 @test_lshr() {
; CHECK-LABEL: @test_lshr(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV_LSHR:%.*]] = phi i64 [ 1023, [[ENTRY:%.*]] ], [ [[IV_LSHR_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_LSHR_NEXT]] = lshr i64 [[IV_LSHR]], 1
; CHECK-NEXT:    br i1 undef, label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = or i64 [[IV_LSHR]], 1023
; CHECK-NEXT:    ret i64 [[RES]]
;
entry:
  br label %loop
loop:
  %iv.lshr = phi i64 [1023, %entry], [%iv.lshr.next, %loop]
  %iv.lshr.next = lshr i64 %iv.lshr, 1
  br i1 undef, label %exit, label %loop
exit:
  %res = or i64 %iv.lshr, 1023
  ret i64 %res
}

define i64 @test_ashr_zeros() {
; CHECK-LABEL: @test_ashr_zeros(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV_ASHR:%.*]] = phi i64 [ 1023, [[ENTRY:%.*]] ], [ [[IV_ASHR_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_ASHR_NEXT]] = ashr i64 [[IV_ASHR]], 1
; CHECK-NEXT:    br i1 undef, label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = or i64 [[IV_ASHR]], 1023
; CHECK-NEXT:    ret i64 [[RES]]
;
entry:
  br label %loop
loop:
  %iv.ashr = phi i64 [1023, %entry], [%iv.ashr.next, %loop]
  %iv.ashr.next = ashr i64 %iv.ashr, 1
  br i1 undef, label %exit, label %loop
exit:
  %res = or i64 %iv.ashr, 1023
  ret i64 %res
}

define i64 @test_ashr_ones() {
; CHECK-LABEL: @test_ashr_ones(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV_ASHR:%.*]] = phi i64 [ -1023, [[ENTRY:%.*]] ], [ [[IV_ASHR_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_ASHR_NEXT]] = ashr i64 [[IV_ASHR]], 1
; CHECK-NEXT:    br i1 undef, label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = or i64 [[IV_ASHR]], 1023
; CHECK-NEXT:    ret i64 [[RES]]
;
entry:
  br label %loop
loop:
  %iv.ashr = phi i64 [-1023, %entry], [%iv.ashr.next, %loop]
  %iv.ashr.next = ashr i64 %iv.ashr, 1
  br i1 undef, label %exit, label %loop
exit:
  %res = or i64 %iv.ashr, 1023
  ret i64 %res
}

; negative case for when start is unknown
define i64 @test_ashr_unknown(i64 %start) {
; CHECK-LABEL: @test_ashr_unknown(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV_ASHR:%.*]] = phi i64 [ [[START:%.*]], [[ENTRY:%.*]] ], [ [[IV_ASHR_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_ASHR_NEXT]] = ashr i64 [[IV_ASHR]], 1
; CHECK-NEXT:    br i1 undef, label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = or i64 [[IV_ASHR]], 1023
; CHECK-NEXT:    ret i64 [[RES]]
;
entry:
  br label %loop
loop:
  %iv.ashr = phi i64 [%start, %entry], [%iv.ashr.next, %loop]
  %iv.ashr.next = ashr i64 %iv.ashr, 1
  br i1 undef, label %exit, label %loop
exit:
  %res = or i64 %iv.ashr, 1023
  ret i64 %res
}

define i64 @test_shl() {
; CHECK-LABEL: @test_shl(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV_SHL:%.*]] = phi i64 [ 8, [[ENTRY:%.*]] ], [ [[IV_SHL_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_SHL_NEXT]] = shl i64 [[IV_SHL]], 1
; CHECK-NEXT:    br i1 undef, label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[RES:%.*]] = and i64 [[IV_SHL]], 6
; CHECK-NEXT:    ret i64 [[RES]]
;
entry:
  br label %loop
loop:
  %iv.shl = phi i64 [8, %entry], [%iv.shl.next, %loop]
  %iv.shl.next = shl i64 %iv.shl, 1
  br i1 undef, label %exit, label %loop
exit:
  %res = and i64 %iv.shl, 7
  ret i64 %res
}
