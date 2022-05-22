; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s
; These should be InstSimplify checks, but most of the code
; is currently only in InstCombine.  TODO: move supporting code

declare void @use(i8)
declare void @use_vec(<2 x i8>)

; Definitely out of range
define i1 @test_nonzero(i32* nocapture readonly %arg) {
; CHECK-LABEL: @test_nonzero(
; CHECK-NEXT:    ret i1 true
;
  %val = load i32, i32* %arg, !range !0
  %rval = icmp ne i32 %val, 0
  ret i1 %rval
}
define i1 @test_nonzero2(i32* nocapture readonly %arg) {
; CHECK-LABEL: @test_nonzero2(
; CHECK-NEXT:    ret i1 false
;
  %val = load i32, i32* %arg, !range !0
  %rval = icmp eq i32 %val, 0
  ret i1 %rval
}

; Potentially in range
define i1 @test_nonzero3(i32* nocapture readonly %arg) {
; CHECK-LABEL: @test_nonzero3(
; CHECK-NEXT:    [[VAL:%.*]] = load i32, i32* [[ARG:%.*]], align 4, !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[RVAL:%.*]] = icmp ne i32 [[VAL]], 0
; CHECK-NEXT:    ret i1 [[RVAL]]
;
; Check that this does not trigger - it wouldn't be legal
  %val = load i32, i32* %arg, !range !1
  %rval = icmp ne i32 %val, 0
  ret i1 %rval
}

; Definitely in range
define i1 @test_nonzero4(i8* nocapture readonly %arg) {
; CHECK-LABEL: @test_nonzero4(
; CHECK-NEXT:    ret i1 false
;
  %val = load i8, i8* %arg, !range !2
  %rval = icmp ne i8 %val, 0
  ret i1 %rval
}

define i1 @test_nonzero5(i8* nocapture readonly %arg) {
; CHECK-LABEL: @test_nonzero5(
; CHECK-NEXT:    ret i1 false
;
  %val = load i8, i8* %arg, !range !2
  %rval = icmp ugt i8 %val, 0
  ret i1 %rval
}

; Cheaper checks (most values in range meet requirements)
define i1 @test_nonzero6(i8* %argw) {
; CHECK-LABEL: @test_nonzero6(
; CHECK-NEXT:    [[VAL:%.*]] = load i8, i8* [[ARGW:%.*]], align 1, !range [[RNG1:![0-9]+]]
; CHECK-NEXT:    [[RVAL:%.*]] = icmp ne i8 [[VAL]], 0
; CHECK-NEXT:    ret i1 [[RVAL]]
;
  %val = load i8, i8* %argw, !range !3
  %rval = icmp sgt i8 %val, 0
  ret i1 %rval
}

; Constant not in range, should return true.
define i1 @test_not_in_range(i32* nocapture readonly %arg) {
; CHECK-LABEL: @test_not_in_range(
; CHECK-NEXT:    ret i1 true
;
  %val = load i32, i32* %arg, !range !0
  %rval = icmp ne i32 %val, 6
  ret i1 %rval
}

; Constant in range, can not fold.
define i1 @test_in_range(i32* nocapture readonly %arg) {
; CHECK-LABEL: @test_in_range(
; CHECK-NEXT:    [[VAL:%.*]] = load i32, i32* [[ARG:%.*]], align 4, !range [[RNG2:![0-9]+]]
; CHECK-NEXT:    [[RVAL:%.*]] = icmp ne i32 [[VAL]], 3
; CHECK-NEXT:    ret i1 [[RVAL]]
;
  %val = load i32, i32* %arg, !range !0
  %rval = icmp ne i32 %val, 3
  ret i1 %rval
}

; Values in range greater than constant.
define i1 @test_range_sgt_constant(i32* nocapture readonly %arg) {
; CHECK-LABEL: @test_range_sgt_constant(
; CHECK-NEXT:    ret i1 true
;
  %val = load i32, i32* %arg, !range !0
  %rval = icmp sgt i32 %val, 0
  ret i1 %rval
}

; Values in range less than constant.
define i1 @test_range_slt_constant(i32* nocapture readonly %arg) {
; CHECK-LABEL: @test_range_slt_constant(
; CHECK-NEXT:    ret i1 false
;
  %val = load i32, i32* %arg, !range !0
  %rval = icmp sgt i32 %val, 6
  ret i1 %rval
}

; Values in union of multiple sub ranges not equal to constant.
define i1 @test_multi_range1(i32* nocapture readonly %arg) {
; CHECK-LABEL: @test_multi_range1(
; CHECK-NEXT:    ret i1 true
;
  %val = load i32, i32* %arg, !range !4
  %rval = icmp ne i32 %val, 0
  ret i1 %rval
}

; Values in multiple sub ranges not equal to constant, but in
; union of sub ranges could possibly equal to constant. This
; in theory could also be folded and might be implemented in
; the future if shown profitable in practice.
define i1 @test_multi_range2(i32* nocapture readonly %arg) {
; CHECK-LABEL: @test_multi_range2(
; CHECK-NEXT:    [[VAL:%.*]] = load i32, i32* [[ARG:%.*]], align 4, !range [[RNG3:![0-9]+]]
; CHECK-NEXT:    [[RVAL:%.*]] = icmp ne i32 [[VAL]], 7
; CHECK-NEXT:    ret i1 [[RVAL]]
;
  %val = load i32, i32* %arg, !range !4
  %rval = icmp ne i32 %val, 7
  ret i1 %rval
}

; Values' ranges overlap each other, so it can not be simplified.
define i1 @test_two_ranges(i32* nocapture readonly %arg1, i32* nocapture readonly %arg2) {
; CHECK-LABEL: @test_two_ranges(
; CHECK-NEXT:    [[VAL1:%.*]] = load i32, i32* [[ARG1:%.*]], align 4, !range [[RNG4:![0-9]+]]
; CHECK-NEXT:    [[VAL2:%.*]] = load i32, i32* [[ARG2:%.*]], align 4, !range [[RNG5:![0-9]+]]
; CHECK-NEXT:    [[RVAL:%.*]] = icmp ult i32 [[VAL2]], [[VAL1]]
; CHECK-NEXT:    ret i1 [[RVAL]]
;
  %val1 = load i32, i32* %arg1, !range !5
  %val2 = load i32, i32* %arg2, !range !6
  %rval = icmp ult i32 %val2, %val1
  ret i1 %rval
}

; Values' ranges do not overlap each other, so it can simplified to false.
define i1 @test_two_ranges2(i32* nocapture readonly %arg1, i32* nocapture readonly %arg2) {
; CHECK-LABEL: @test_two_ranges2(
; CHECK-NEXT:    ret i1 false
;
  %val1 = load i32, i32* %arg1, !range !0
  %val2 = load i32, i32* %arg2, !range !6
  %rval = icmp ult i32 %val2, %val1
  ret i1 %rval
}

; Values' ranges do not overlap each other, so it can simplified to true.
define i1 @test_two_ranges3(i32* nocapture readonly %arg1, i32* nocapture readonly %arg2) {
; CHECK-LABEL: @test_two_ranges3(
; CHECK-NEXT:    ret i1 true
;
  %val1 = load i32, i32* %arg1, !range !0
  %val2 = load i32, i32* %arg2, !range !6
  %rval = icmp ugt i32 %val2, %val1
  ret i1 %rval
}

define i1 @sub_ult_zext(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @sub_ult_zext(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = and i1 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %z = zext i1 %b to i8
  %s = sub i8 %x, %y
  %r = icmp ult i8 %s, %z
  ret i1 %r
}

define i1 @sub_ult_zext_use1(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @sub_ult_zext_use1(
; CHECK-NEXT:    [[Z:%.*]] = zext i1 [[B:%.*]] to i8
; CHECK-NEXT:    call void @use(i8 [[Z]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = and i1 [[TMP1]], [[B]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %z = zext i1 %b to i8
  call void @use(i8 %z)
  %s = sub i8 %x, %y
  %r = icmp ult i8 %s, %z
  ret i1 %r
}

define <2 x i1> @zext_ugt_sub_use2(<2 x i1> %b, <2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @zext_ugt_sub_use2(
; CHECK-NEXT:    [[S:%.*]] = sub <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use_vec(<2 x i8> [[S]])
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <2 x i8> [[X]], [[Y]]
; CHECK-NEXT:    [[R:%.*]] = and <2 x i1> [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %z = zext <2 x i1> %b to <2 x i8>
  %s = sub <2 x i8> %x, %y
  call void @use_vec(<2 x i8> %s)
  %r = icmp ugt <2 x i8> %z, %s
  ret <2 x i1> %r
}

; negative test - too many extra uses

define i1 @sub_ult_zext_use3(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @sub_ult_zext_use3(
; CHECK-NEXT:    [[Z:%.*]] = zext i1 [[B:%.*]] to i8
; CHECK-NEXT:    call void @use(i8 [[Z]])
; CHECK-NEXT:    [[S:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    call void @use(i8 [[S]])
; CHECK-NEXT:    [[R:%.*]] = icmp ult i8 [[S]], [[Z]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %z = zext i1 %b to i8
  call void @use(i8 %z)
  %s = sub i8 %x, %y
  call void @use(i8 %s)
  %r = icmp ult i8 %s, %z
  ret i1 %r
}

; negative test - wrong predicate

define i1 @sub_ule_zext(i1 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @sub_ule_zext(
; CHECK-NEXT:    [[Z:%.*]] = zext i1 [[B:%.*]] to i8
; CHECK-NEXT:    [[S:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ule i8 [[S]], [[Z]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %z = zext i1 %b to i8
  %s = sub i8 %x, %y
  %r = icmp ule i8 %s, %z
  ret i1 %r
}

define <2 x i1> @sub_ult_and(<2 x i8> %b, <2 x i8> %x, <2 x i8> %y) {
; CHECK-LABEL: @sub_ult_and(
; CHECK-NEXT:    [[A:%.*]] = and <2 x i8> [[B:%.*]], <i8 1, i8 1>
; CHECK-NEXT:    [[S:%.*]] = sub <2 x i8> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ult <2 x i8> [[S]], [[A]]
; CHECK-NEXT:    ret <2 x i1> [[R]]
;
  %a = and <2 x i8> %b, <i8 1, i8 1>
  %s = sub <2 x i8> %x, %y
  %r = icmp ult <2 x i8> %s, %a
  ret <2 x i1> %r
}

define i1 @and_ugt_sub(i8 %b, i8 %x, i8 %y) {
; CHECK-LABEL: @and_ugt_sub(
; CHECK-NEXT:    [[A:%.*]] = and i8 [[B:%.*]], 1
; CHECK-NEXT:    [[S:%.*]] = sub i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i8 [[A]], [[S]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %a = and i8 %b, 1
  %s = sub i8 %x, %y
  %r = icmp ugt i8 %a, %s
  ret i1 %r
}

!0 = !{i32 1, i32 6}
!1 = !{i32 0, i32 6}
!2 = !{i8 0, i8 1}
!3 = !{i8 0, i8 6}
!4 = !{i32 1, i32 6, i32 8, i32 10}
!5 = !{i32 5, i32 10}
!6 = !{i32 8, i32 16}
