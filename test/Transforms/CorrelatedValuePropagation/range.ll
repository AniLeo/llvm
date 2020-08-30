; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -correlated-propagation -S < %s | FileCheck %s

declare i32 @foo()

define i32 @test1(i32 %a) nounwind {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br i1 false, label [[END:%.*]], label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    ret i32 1
; CHECK:       end:
; CHECK-NEXT:    ret i32 2
;
  %a.off = add i32 %a, -8
  %cmp = icmp ult i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, 7
  br i1 %dead, label %end, label %else

else:
  ret i32 1

end:
  ret i32 2
}

define i32 @test2(i32 %a) nounwind {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br i1 false, label [[END:%.*]], label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    ret i32 1
; CHECK:       end:
; CHECK-NEXT:    ret i32 2
;
  %a.off = add i32 %a, -8
  %cmp = icmp ult i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp ugt i32 %a, 15
  br i1 %dead, label %end, label %else

else:
  ret i32 1

end:
  ret i32 2
}

define i32 @test3(i32 %c) nounwind {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[C:%.*]], 2
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    ret i32 1
; CHECK:       if.end:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp slt i32 [[C]], 3
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN2:%.*]], label [[IF_END8:%.*]]
; CHECK:       if.then2:
; CHECK-NEXT:    br i1 true, label [[IF_THEN4:%.*]], label [[IF_END6:%.*]]
; CHECK:       if.end6:
; CHECK-NEXT:    ret i32 2
; CHECK:       if.then4:
; CHECK-NEXT:    ret i32 3
; CHECK:       if.end8:
; CHECK-NEXT:    ret i32 4
;
  %cmp = icmp slt i32 %c, 2
  br i1 %cmp, label %if.then, label %if.end

if.then:
  ret i32 1

if.end:
  %cmp1 = icmp slt i32 %c, 3
  br i1 %cmp1, label %if.then2, label %if.end8

if.then2:
  %cmp2 = icmp eq i32 %c, 2
  br i1 %cmp2, label %if.then4, label %if.end6

if.end6:
  ret i32 2

if.then4:
  ret i32 3

if.end8:
  ret i32 4
}

define i32 @test4(i32 %c) nounwind {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    switch i32 [[C:%.*]], label [[SW_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 1, label [[SW_BB:%.*]]
; CHECK-NEXT:    i32 2, label [[SW_BB]]
; CHECK-NEXT:    i32 4, label [[SW_BB]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    br i1 true, label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       sw.default:
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i32 [ 42, [[SW_DEFAULT]] ], [ 4, [[IF_THEN]] ], [ 9, [[IF_END]] ]
; CHECK-NEXT:    ret i32 [[RETVAL_0]]
;
  switch i32 %c, label %sw.default [
  i32 1, label %sw.bb
  i32 2, label %sw.bb
  i32 4, label %sw.bb
  ]

sw.bb:
  %cmp = icmp sge i32 %c, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:
  br label %return

if.end:
  br label %return

sw.default:
  br label %return

return:
  %retval.0 = phi i32 [ 42, %sw.default ], [ 4, %if.then ], [ 9, %if.end ]
  ret i32 %retval.0
}

define i1 @test5(i32 %c) nounwind {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[C:%.*]], 5
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[C]], 4
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_END]], label [[IF_END8:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    ret i1 true
; CHECK:       if.end8:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[C]], 3
; CHECK-NEXT:    [[OR:%.*]] = or i1 false, false
; CHECK-NEXT:    ret i1 [[CMP2]]
;
  %cmp = icmp slt i32 %c, 5
  br i1 %cmp, label %if.then, label %if.end

if.then:
  %cmp1 = icmp eq i32 %c, 4
  br i1 %cmp1, label %if.end, label %if.end8

if.end:
  ret i1 true

if.end8:
  %cmp2 = icmp eq i32 %c, 3
  %cmp3 = icmp eq i32 %c, 4
  %cmp4 = icmp eq i32 %c, 6
  %or = or i1 %cmp3, %cmp4
  ret i1 %cmp2
}

define i1 @test6(i32 %c) nounwind {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i32 [[C:%.*]], 7
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[C]], 6
; CHECK-NEXT:    br i1 [[COND]], label [[SW_BB:%.*]], label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    ret i1 true
; CHECK:       sw.bb:
; CHECK-NEXT:    ret i1 true
;
  %cmp = icmp ule i32 %c, 7
  br i1 %cmp, label %if.then, label %if.end

if.then:
  switch i32 %c, label %if.end [
  i32 6, label %sw.bb
  i32 8, label %sw.bb
  ]

if.end:
  ret i1 true

sw.bb:
  %cmp2 = icmp eq i32 %c, 6
  ret i1 %cmp2
}

define i1 @test7(i32 %c) nounwind {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    switch i32 [[C:%.*]], label [[SW_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 6, label [[SW_BB:%.*]]
; CHECK-NEXT:    i32 7, label [[SW_BB]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    ret i1 true
; CHECK:       sw.default:
; CHECK-NEXT:    [[CMP5:%.*]] = icmp eq i32 [[C]], 5
; CHECK-NEXT:    [[CMP8:%.*]] = icmp eq i32 [[C]], 8
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP5]], false
; CHECK-NEXT:    [[OR2:%.*]] = or i1 false, [[CMP8]]
; CHECK-NEXT:    ret i1 false
;
entry:
  switch i32 %c, label %sw.default [
  i32 6, label %sw.bb
  i32 7, label %sw.bb
  ]

sw.bb:
  ret i1 true

sw.default:
  %cmp5 = icmp eq i32 %c, 5
  %cmp6 = icmp eq i32 %c, 6
  %cmp7 = icmp eq i32 %c, 7
  %cmp8 = icmp eq i32 %c, 8
  %or = or i1 %cmp5, %cmp6
  %or2 = or i1 %cmp7, %cmp8
  ret i1 false
}

define i1 @test8(i64* %p) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[A:%.*]] = load i64, i64* [[P:%.*]], align 4, [[RNG0:!range !.*]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i64 [[A]], 0
; CHECK-NEXT:    ret i1 false
;
  %a = load i64, i64* %p, !range !{i64 4, i64 255}
  %res = icmp eq i64 %a, 0
  ret i1 %res
}

define i1 @test9(i64* %p) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[A:%.*]] = load i64, i64* [[P:%.*]], align 4, [[RNG1:!range !.*]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i64 [[A]], 0
; CHECK-NEXT:    ret i1 true
;
  %a = load i64, i64* %p, !range !{i64 0, i64 1}
  %res = icmp eq i64 %a, 0
  ret i1 %res
}

define i1 @test10(i64* %p) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[A:%.*]] = load i64, i64* [[P:%.*]], align 4, [[RNG2:!range !.*]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i64 [[A]], 0
; CHECK-NEXT:    ret i1 false
;
  %a = load i64, i64* %p, !range !{i64 4, i64 8, i64 15, i64 20}
  %res = icmp eq i64 %a, 0
  ret i1 %res
}

@g = external global i32

define i1 @test11() {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[POSITIVE:%.*]] = load i32, i32* @g, align 4, [[RNG3:!range !.*]]
; CHECK-NEXT:    [[ADD:%.*]] = add nuw nsw i32 [[POSITIVE]], 1
; CHECK-NEXT:    [[TEST:%.*]] = icmp sgt i32 [[ADD]], 0
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    ret i1 true
;
  %positive = load i32, i32* @g, !range !{i32 1, i32 2048}
  %add = add i32 %positive, 1
  %test = icmp sgt i32 %add, 0
  br label %next

next:
  ret i1 %test
}

define i32 @test12(i32 %a, i32 %b) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br i1 false, label [[END:%.*]], label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    ret i32 1
; CHECK:       end:
; CHECK-NEXT:    ret i32 2
;
  %cmp = icmp ult i32 %a, %b
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, -1
  br i1 %dead, label %end, label %else

else:
  ret i32 1

end:
  ret i32 2
}

define i32 @test12_swap(i32 %a, i32 %b) {
; CHECK-LABEL: @test12_swap(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i32 [[B:%.*]], [[A:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br i1 false, label [[END:%.*]], label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    ret i32 1
; CHECK:       end:
; CHECK-NEXT:    ret i32 2
;
  %cmp = icmp ugt i32 %b, %a
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, -1
  br i1 %dead, label %end, label %else

else:
  ret i32 1

end:
  ret i32 2
}

; The same as @test12 but the second check is on the false path

define i32 @test12_neg(i32 %a, i32 %b) {
; CHECK-LABEL: @test12_neg(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[ALIVE:%.*]] = icmp eq i32 [[A]], -1
; CHECK-NEXT:    br i1 [[ALIVE]], label [[END:%.*]], label [[THEN]]
; CHECK:       then:
; CHECK-NEXT:    ret i32 1
; CHECK:       end:
; CHECK-NEXT:    ret i32 2
;
  %cmp = icmp ult i32 %a, %b
  br i1 %cmp, label %then, label %else

else:
  %alive = icmp eq i32 %a, -1
  br i1 %alive, label %end, label %then

then:
  ret i32 1

end:
  ret i32 2
}

; The same as @test12 but with signed comparison

define i32 @test12_signed(i32 %a, i32 %b) {
; CHECK-LABEL: @test12_signed(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br i1 false, label [[END:%.*]], label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    ret i32 1
; CHECK:       end:
; CHECK-NEXT:    ret i32 2
;
  %cmp = icmp slt i32 %a, %b
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, 2147483647
  br i1 %dead, label %end, label %else

else:
  ret i32 1

end:
  ret i32 2
}

define i32 @test13(i32 %a, i32 %b) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[A_OFF]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br i1 false, label [[END:%.*]], label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    ret i32 1
; CHECK:       end:
; CHECK-NEXT:    ret i32 2
;
  %a.off = add i32 %a, -8
  %cmp = icmp ult i32 %a.off, %b
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, 7
  br i1 %dead, label %end, label %else

else:
  ret i32 1

end:
  ret i32 2
}

define i32 @test13_swap(i32 %a, i32 %b) {
; CHECK-LABEL: @test13_swap(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i32 [[B:%.*]], [[A_OFF]]
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br i1 false, label [[END:%.*]], label [[ELSE]]
; CHECK:       else:
; CHECK-NEXT:    ret i32 1
; CHECK:       end:
; CHECK-NEXT:    ret i32 2
;
  %a.off = add i32 %a, -8
  %cmp = icmp ugt i32 %b, %a.off
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, 7
  br i1 %dead, label %end, label %else

else:
  ret i32 1

end:
  ret i32 2
}

define i1 @test14_slt(i32 %a) {
; CHECK-LABEL: @test14_slt(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[RESULT:%.*]] = or i1 false, false
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %a.off = add i32 %a, -8
  %cmp = icmp slt i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead.1 = icmp eq i32 %a, -2147483641
  %dead.2 = icmp eq i32 %a, 16
  %result = or i1 %dead.1, %dead.2
  ret i1 %result

else:
  ret i1 false
}

define i1 @test14_sle(i32 %a) {
; CHECK-LABEL: @test14_sle(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp sle i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[ALIVE:%.*]] = icmp eq i32 [[A]], 16
; CHECK-NEXT:    [[RESULT:%.*]] = or i1 false, [[ALIVE]]
; CHECK-NEXT:    ret i1 [[RESULT]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %a.off = add i32 %a, -8
  %cmp = icmp sle i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, -2147483641
  %alive = icmp eq i32 %a, 16
  %result = or i1 %dead, %alive
  ret i1 %result

else:
  ret i1 false
}

define i1 @test14_sgt(i32 %a) {
; CHECK-LABEL: @test14_sgt(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[RESULT:%.*]] = or i1 false, false
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %a.off = add i32 %a, -8
  %cmp = icmp sgt i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead.1 = icmp eq i32 %a, -2147483640
  %dead.2 = icmp eq i32 %a, 16
  %result = or i1 %dead.1, %dead.2
  ret i1 %result

else:
  ret i1 false
}

define i1 @test14_sge(i32 %a) {
; CHECK-LABEL: @test14_sge(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[ALIVE:%.*]] = icmp eq i32 [[A]], 16
; CHECK-NEXT:    [[RESULT:%.*]] = or i1 false, [[ALIVE]]
; CHECK-NEXT:    ret i1 [[RESULT]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %a.off = add i32 %a, -8
  %cmp = icmp sge i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, -2147483640
  %alive = icmp eq i32 %a, 16
  %result = or i1 %dead, %alive
  ret i1 %result

else:
  ret i1 false
}

define i1 @test14_ule(i32 %a) {
; CHECK-LABEL: @test14_ule(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp ule i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[ALIVE:%.*]] = icmp eq i32 [[A]], 16
; CHECK-NEXT:    [[RESULT:%.*]] = or i1 false, [[ALIVE]]
; CHECK-NEXT:    ret i1 [[RESULT]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %a.off = add i32 %a, -8
  %cmp = icmp ule i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, 7
  %alive = icmp eq i32 %a, 16
  %result = or i1 %dead, %alive
  ret i1 %result

else:
  ret i1 false
}

define i1 @test14_ugt(i32 %a) {
; CHECK-LABEL: @test14_ugt(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[RESULT:%.*]] = or i1 false, false
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %a.off = add i32 %a, -8
  %cmp = icmp ugt i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead.1 = icmp eq i32 %a, 8
  %dead.2 = icmp eq i32 %a, 16
  %result = or i1 %dead.1, %dead.2
  ret i1 %result

else:
  ret i1 false
}

define i1 @test14_uge(i32 %a) {
; CHECK-LABEL: @test14_uge(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[ALIVE:%.*]] = icmp eq i32 [[A]], 16
; CHECK-NEXT:    [[RESULT:%.*]] = or i1 false, [[ALIVE]]
; CHECK-NEXT:    ret i1 [[RESULT]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %a.off = add i32 %a, -8
  %cmp = icmp uge i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead = icmp eq i32 %a, 8
  %alive = icmp eq i32 %a, 16
  %result = or i1 %dead, %alive
  ret i1 %result

else:
  ret i1 false
}

define i1 @test14_ugt_and(i32 %a) {
; CHECK-LABEL: @test14_ugt_and(
; CHECK-NEXT:    [[A_OFF:%.*]] = add i32 [[A:%.*]], -8
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i32 [[A_OFF]], 8
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[RESULT:%.*]] = and i1 false, false
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %a.off = add i32 %a, -8
  %cmp = icmp ugt i32 %a.off, 8
  br i1 %cmp, label %then, label %else

then:
  %dead.1 = icmp eq i32 %a, 8
  %dead.2 = icmp eq i32 %a, 16
  %result = and i1 %dead.1, %dead.2
  ret i1 %result

else:
  ret i1 false
}

@limit = external global i32
define i1 @test15(i32 %a) {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    [[LIMIT:%.*]] = load i32, i32* @limit, align 4, [[RNG4:!range !.*]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[A:%.*]], [[LIMIT]]
; CHECK-NEXT:    br i1 [[CMP]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
  %limit = load i32, i32* @limit, !range !{i32 0, i32 256}
  %cmp = icmp ult i32 %a, %limit
  br i1 %cmp, label %then, label %else

then:
  %result = icmp eq i32 %a, 255
  ret i1 %result

else:
  ret i1 false
}

define i32 @test16(i8 %a) {
; CHECK-LABEL: @test16(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    br label [[DISPATCH:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 93
; CHECK-NEXT:    br i1 [[CMP]], label [[TARGET93:%.*]], label [[DISPATCH]]
; CHECK:       target93:
; CHECK-NEXT:    ret i32 93
;
entry:
  %b = zext i8 %a to i32
  br label %dispatch

dispatch:
  %cmp = icmp eq i8 %a, 93
  br i1 %cmp, label %target93, label %dispatch

target93:
  ret i32 %b
}

define i32 @test16_i1(i1 %a) {
; CHECK-LABEL: @test16_i1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = zext i1 [[A:%.*]] to i32
; CHECK-NEXT:    br label [[DISPATCH:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    br i1 [[A]], label [[TRUE:%.*]], label [[DISPATCH]]
; CHECK:       true:
; CHECK-NEXT:    ret i32 1
;
entry:
  %b = zext i1 %a to i32
  br label %dispatch

dispatch:
  br i1 %a, label %true, label %dispatch

true:
  ret i32 %b
}

define i8 @test17(i8 %a) {
; CHECK-LABEL: @test17(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = add i8 [[A:%.*]], 3
; CHECK-NEXT:    br label [[DISPATCH:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 93
; CHECK-NEXT:    br i1 [[CMP]], label [[TARGET93:%.*]], label [[DISPATCH]]
; CHECK:       target93:
; CHECK-NEXT:    ret i8 96
;
entry:
  %c = add i8 %a, 3
  br label %dispatch

dispatch:
  %cmp = icmp eq i8 %a, 93
  br i1 %cmp, label %target93, label %dispatch

target93:
  ret i8 %c
}

define i8 @test17_2(i8 %a) {
; CHECK-LABEL: @test17_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = add i8 [[A:%.*]], [[A]]
; CHECK-NEXT:    br label [[DISPATCH:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[A]], 93
; CHECK-NEXT:    br i1 [[CMP]], label [[TARGET93:%.*]], label [[DISPATCH]]
; CHECK:       target93:
; CHECK-NEXT:    ret i8 -70
;
entry:
  %c = add i8 %a, %a
  br label %dispatch

dispatch:
  %cmp = icmp eq i8 %a, 93
  br i1 %cmp, label %target93, label %dispatch

target93:
  ret i8 %c
}

define i1 @test17_i1(i1 %a) {
; CHECK-LABEL: @test17_i1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[DISPATCH:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    br i1 [[A:%.*]], label [[TRUE:%.*]], label [[DISPATCH]]
; CHECK:       true:
; CHECK-NEXT:    ret i1 true
;
entry:
  %c = and i1 %a, true
  br label %dispatch

dispatch:
  br i1 %a, label %true, label %dispatch

true:
  ret i1 %c
}

define i32 @test18(i8 %a) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = zext i8 [[A:%.*]] to i32
; CHECK-NEXT:    br label [[DISPATCH:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    switch i8 [[A]], label [[DISPATCH]] [
; CHECK-NEXT:    i8 93, label [[TARGET93:%.*]]
; CHECK-NEXT:    i8 -111, label [[DISPATCH]]
; CHECK-NEXT:    ]
; CHECK:       target93:
; CHECK-NEXT:    ret i32 93
;
entry:
  %b = zext i8 %a to i32
  br label %dispatch

dispatch:
  switch i8 %a, label %dispatch [
  i8 93, label %target93
  i8 -111, label %dispatch
  ]

target93:
  ret i32 %b
}

define i8 @test19(i8 %a) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = add i8 [[A:%.*]], 3
; CHECK-NEXT:    br label [[DISPATCH:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    switch i8 [[A]], label [[DISPATCH]] [
; CHECK-NEXT:    i8 93, label [[TARGET93:%.*]]
; CHECK-NEXT:    i8 -111, label [[DISPATCH]]
; CHECK-NEXT:    ]
; CHECK:       target93:
; CHECK-NEXT:    ret i8 96
;
entry:
  %c = add i8 %a, 3
  br label %dispatch

dispatch:
  switch i8 %a, label %dispatch [
  i8 93, label %target93
  i8 -111, label %dispatch
  ]

target93:
  ret i8 %c
}

; Negative test. Shouldn't be incorrectly optimized to "ret i1 false".

define i1 @test20(i64 %a) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B:%.*]] = and i64 [[A:%.*]], 7
; CHECK-NEXT:    br label [[DISPATCH:%.*]]
; CHECK:       dispatch:
; CHECK-NEXT:    switch i64 [[A]], label [[DEFAULT:%.*]] [
; CHECK-NEXT:    i64 0, label [[EXIT2:%.*]]
; CHECK-NEXT:    i64 -2147483647, label [[EXIT2]]
; CHECK-NEXT:    ]
; CHECK:       default:
; CHECK-NEXT:    [[C:%.*]] = icmp eq i64 [[B]], 0
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret i1 [[C]]
; CHECK:       exit2:
; CHECK-NEXT:    ret i1 false
;
entry:
  %b = and i64 %a, 7
  br label %dispatch

dispatch:
  switch i64 %a, label %default [
  i64 0, label %exit2
  i64 -2147483647, label %exit2
  ]

default:
  %c = icmp eq i64 %b, 0
  br label %exit

exit:
  ret i1 %c

exit2:
  ret i1 false
}

define i1 @slt(i8 %a, i8 %b) {
; CHECK-LABEL: @slt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp slt i8 %a, %b
  call void @llvm.assume(i1 %cmp)
  %res = icmp slt i8 %a, 127
  ret i1 %res
}

define i1 @sgt(i8 %a, i8 %b) {
; CHECK-LABEL: @sgt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sgt i8 %a, %b
  call void @llvm.assume(i1 %cmp)
  %res = icmp sgt i8 %a, -128
  ret i1 %res
}

define i1 @ult(i8 %a, i8 %b) {
; CHECK-LABEL: @ult(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp ult i8 %a, %b
  call void @llvm.assume(i1 %cmp)
  %res = icmp ult i8 %a, 255
  ret i1 %res
}

define i1 @ugt(i8 %a, i8 %b) {
; CHECK-LABEL: @ugt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i8 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp ugt i8 %a, %b
  call void @llvm.assume(i1 %cmp)
  %res = icmp ugt i8 %a, 0
  ret i1 %res
}

declare void @llvm.assume(i1)
