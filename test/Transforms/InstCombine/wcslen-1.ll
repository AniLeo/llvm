; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the wcslen library call simplifier works correctly.
;
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

declare i64 @wcslen(i32*)

@hello = constant [6 x i32] [i32 104, i32 101, i32 108, i32 108, i32 111, i32 0]
@longer = constant [7 x i32] [i32 108, i32 111, i32 110, i32 103, i32 101, i32 114, i32 0]
@null = constant [1 x i32] zeroinitializer
@null_hello = constant [7 x i32] [i32 0, i32 104, i32 101, i32 108, i32 108, i32 111, i32 0]
@nullstring = constant i32 0
@a = common global [32 x i32] zeroinitializer, align 1
@null_hello_mid = constant [13 x i32] [i32 104, i32 101, i32 108, i32 108, i32 111, i32 32, i32 119, i32 111, i32 114, i32 0, i32 108, i32 100, i32 0]

define i64 @test_simplify1() {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    ret i64 5
;
  %hello_p = getelementptr [6 x i32], [6 x i32]* @hello, i64 0, i64 0
  %hello_l = call i64 @wcslen(i32* %hello_p)
  ret i64 %hello_l
}

define i64 @test_simplify2() {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    ret i64 0
;
  %null_p = getelementptr [1 x i32], [1 x i32]* @null, i64 0, i64 0
  %null_l = call i64 @wcslen(i32* %null_p)
  ret i64 %null_l
}

define i64 @test_simplify3() {
; CHECK-LABEL: @test_simplify3(
; CHECK-NEXT:    ret i64 0
;
  %null_hello_p = getelementptr [7 x i32], [7 x i32]* @null_hello, i64 0, i64 0
  %null_hello_l = call i64 @wcslen(i32* %null_hello_p)
  ret i64 %null_hello_l
}

define i64 @test_simplify4() {
; CHECK-LABEL: @test_simplify4(
; CHECK-NEXT:    ret i64 0
;
  %len = tail call i64 @wcslen(i32* @nullstring) nounwind
  ret i64 %len
}

; Check wcslen(x) == 0 --> *x == 0.

define i1 @test_simplify5() {
; CHECK-LABEL: @test_simplify5(
; CHECK-NEXT:    ret i1 false
;
  %hello_p = getelementptr [6 x i32], [6 x i32]* @hello, i64 0, i64 0
  %hello_l = call i64 @wcslen(i32* %hello_p)
  %eq_hello = icmp eq i64 %hello_l, 0
  ret i1 %eq_hello
}

define i1 @test_simplify6(i32* %str_p) {
; CHECK-LABEL: @test_simplify6(
; CHECK-NEXT:    [[STRLENFIRST:%.*]] = load i32, i32* [[STR_P:%.*]], align 4
; CHECK-NEXT:    [[EQ_NULL:%.*]] = icmp eq i32 [[STRLENFIRST]], 0
; CHECK-NEXT:    ret i1 [[EQ_NULL]]
;
  %str_l = call i64 @wcslen(i32* %str_p)
  %eq_null = icmp eq i64 %str_l, 0
  ret i1 %eq_null
}

; Check wcslen(x) != 0 --> *x != 0.

define i1 @test_simplify7() {
; CHECK-LABEL: @test_simplify7(
; CHECK-NEXT:    ret i1 true
;
  %hello_p = getelementptr [6 x i32], [6 x i32]* @hello, i64 0, i64 0
  %hello_l = call i64 @wcslen(i32* %hello_p)
  %ne_hello = icmp ne i64 %hello_l, 0
  ret i1 %ne_hello
}

define i1 @test_simplify8(i32* %str_p) {
; CHECK-LABEL: @test_simplify8(
; CHECK-NEXT:    [[STRLENFIRST:%.*]] = load i32, i32* [[STR_P:%.*]], align 4
; CHECK-NEXT:    [[NE_NULL:%.*]] = icmp ne i32 [[STRLENFIRST]], 0
; CHECK-NEXT:    ret i1 [[NE_NULL]]
;
  %str_l = call i64 @wcslen(i32* %str_p)
  %ne_null = icmp ne i64 %str_l, 0
  ret i1 %ne_null
}

define i64 @test_simplify9(i1 %x) {
; CHECK-LABEL: @test_simplify9(
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[X:%.*]], i64 5, i64 6
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %hello = getelementptr [6 x i32], [6 x i32]* @hello, i64 0, i64 0
  %longer = getelementptr [7 x i32], [7 x i32]* @longer, i64 0, i64 0
  %s = select i1 %x, i32* %hello, i32* %longer
  %l = call i64 @wcslen(i32* %s)
  ret i64 %l
}

; Check the case that should be simplified to a sub instruction.
; wcslen(@hello + x) --> 5 - x

define i64 @test_simplify10(i32 %x) {
; CHECK-LABEL: @test_simplify10(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[X:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = sub nsw i64 5, [[TMP1]]
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %hello_p = getelementptr inbounds [6 x i32], [6 x i32]* @hello, i32 0, i32 %x
  %hello_l = call i64 @wcslen(i32* %hello_p)
  ret i64 %hello_l
}

; wcslen(@null_hello_mid + (x & 7)) --> 9 - (x & 7)

define i64 @test_simplify11(i32 %x) {
; CHECK-LABEL: @test_simplify11(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 7
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[AND]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = sub nsw i64 9, [[TMP1]]
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %and = and i32 %x, 7
  %hello_p = getelementptr inbounds [13 x i32], [13 x i32]* @null_hello_mid, i32 0, i32 %and
  %hello_l = call i64 @wcslen(i32* %hello_p)
  ret i64 %hello_l
}

; Check cases that shouldn't be simplified.

define i64 @test_no_simplify1() {
; CHECK-LABEL: @test_no_simplify1(
; CHECK-NEXT:    [[A_L:%.*]] = call i64 @wcslen(i32* getelementptr inbounds ([32 x i32], [32 x i32]* @a, i64 0, i64 0))
; CHECK-NEXT:    ret i64 [[A_L]]
;
  %a_p = getelementptr [32 x i32], [32 x i32]* @a, i64 0, i64 0
  %a_l = call i64 @wcslen(i32* %a_p)
  ret i64 %a_l
}

; wcslen(@null_hello + x) should not be simplified to a sub instruction.

define i64 @test_no_simplify2(i32 %x) {
; CHECK-LABEL: @test_no_simplify2(
; CHECK-NEXT:    [[TMP1:%.*]] = sext i32 [[X:%.*]] to i64
; CHECK-NEXT:    [[HELLO_P:%.*]] = getelementptr inbounds [7 x i32], [7 x i32]* @null_hello, i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[HELLO_L:%.*]] = call i64 @wcslen(i32* [[HELLO_P]])
; CHECK-NEXT:    ret i64 [[HELLO_L]]
;
  %hello_p = getelementptr inbounds [7 x i32], [7 x i32]* @null_hello, i32 0, i32 %x
  %hello_l = call i64 @wcslen(i32* %hello_p)
  ret i64 %hello_l
}

; wcslen(@null_hello_mid + (x & 15)) should not be simplified to a sub instruction.

define i64 @test_no_simplify3(i32 %x) {
; CHECK-LABEL: @test_no_simplify3(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 15
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[AND]] to i64
; CHECK-NEXT:    [[HELLO_P:%.*]] = getelementptr inbounds [13 x i32], [13 x i32]* @null_hello_mid, i64 0, i64 [[TMP1]]
; CHECK-NEXT:    [[HELLO_L:%.*]] = call i64 @wcslen(i32* [[HELLO_P]])
; CHECK-NEXT:    ret i64 [[HELLO_L]]
;
  %and = and i32 %x, 15
  %hello_p = getelementptr inbounds [13 x i32], [13 x i32]* @null_hello_mid, i32 0, i32 %and
  %hello_l = call i64 @wcslen(i32* %hello_p)
  ret i64 %hello_l
}

@str16 = constant [1 x i16] [i16 0]

define i64 @test_no_simplify4() {
; CHECK-LABEL: @test_no_simplify4(
; CHECK-NEXT:    [[L:%.*]] = call i64 @wcslen(i32* bitcast ([1 x i16]* @str16 to i32*))
; CHECK-NEXT:    ret i64 [[L]]
;
  %l = call i64 @wcslen(i32* bitcast ([1 x i16]* @str16 to i32*))
  ret i64 %l
}
