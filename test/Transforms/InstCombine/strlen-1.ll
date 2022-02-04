; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the strlen library call simplifier works correctly.
;
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

@hello = constant [6 x i8] c"hello\00"
@longer = constant [7 x i8] c"longer\00"
@null = constant [1 x i8] zeroinitializer
@null_hello = constant [7 x i8] c"\00hello\00"
@nullstring = constant i8 0
@a = common global [32 x i8] zeroinitializer, align 1
@null_hello_mid = constant [13 x i8] c"hello wor\00ld\00"

declare i32 @strlen(i8*)

; Check strlen(string constant) -> integer constant.

define i32 @test_simplify1() {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    ret i32 5
;
  %hello_p = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  %hello_l = call i32 @strlen(i8* %hello_p)
  ret i32 %hello_l
}

define i32 @test_simplify2() {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    ret i32 0
;
  %null_p = getelementptr [1 x i8], [1 x i8]* @null, i32 0, i32 0
  %null_l = call i32 @strlen(i8* %null_p)
  ret i32 %null_l
}

define i32 @test_simplify3() {
; CHECK-LABEL: @test_simplify3(
; CHECK-NEXT:    ret i32 0
;
  %null_hello_p = getelementptr [7 x i8], [7 x i8]* @null_hello, i32 0, i32 0
  %null_hello_l = call i32 @strlen(i8* %null_hello_p)
  ret i32 %null_hello_l
}

define i32 @test_simplify4() {
; CHECK-LABEL: @test_simplify4(
; CHECK-NEXT:    ret i32 0
;
  %len = tail call i32 @strlen(i8* @nullstring) nounwind
  ret i32 %len
}

; Check strlen(x) == 0 --> *x == 0.

define i1 @test_simplify5() {
; CHECK-LABEL: @test_simplify5(
; CHECK-NEXT:    ret i1 false
;
  %hello_p = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  %hello_l = call i32 @strlen(i8* %hello_p)
  %eq_hello = icmp eq i32 %hello_l, 0
  ret i1 %eq_hello
}

define i1 @test_simplify6(i8* %str_p) {
; CHECK-LABEL: @test_simplify6(
; CHECK-NEXT:    [[STRLENFIRST:%.*]] = load i8, i8* [[STR_P:%.*]], align 1
; CHECK-NEXT:    [[EQ_NULL:%.*]] = icmp eq i8 [[STRLENFIRST]], 0
; CHECK-NEXT:    ret i1 [[EQ_NULL]]
;
  %str_l = call i32 @strlen(i8* %str_p)
  %eq_null = icmp eq i32 %str_l, 0
  ret i1 %eq_null
}

; Check strlen(x) != 0 --> *x != 0.

define i1 @test_simplify7() {
; CHECK-LABEL: @test_simplify7(
; CHECK-NEXT:    ret i1 true
;
  %hello_p = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  %hello_l = call i32 @strlen(i8* %hello_p)
  %ne_hello = icmp ne i32 %hello_l, 0
  ret i1 %ne_hello
}

define i1 @test_simplify8(i8* %str_p) {
; CHECK-LABEL: @test_simplify8(
; CHECK-NEXT:    [[STRLENFIRST:%.*]] = load i8, i8* [[STR_P:%.*]], align 1
; CHECK-NEXT:    [[NE_NULL:%.*]] = icmp ne i8 [[STRLENFIRST]], 0
; CHECK-NEXT:    ret i1 [[NE_NULL]]
;
  %str_l = call i32 @strlen(i8* %str_p)
  %ne_null = icmp ne i32 %str_l, 0
  ret i1 %ne_null
}

define i32 @test_simplify9(i1 %x) {
; CHECK-LABEL: @test_simplify9(
; CHECK-NEXT:    [[TMP1:%.*]] = select i1 [[X:%.*]], i32 5, i32 6
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %hello = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  %longer = getelementptr [7 x i8], [7 x i8]* @longer, i32 0, i32 0
  %s = select i1 %x, i8* %hello, i8* %longer
  %l = call i32 @strlen(i8* %s)
  ret i32 %l
}

; Check the case that should be simplified to a sub instruction.
; strlen(@hello + x) --> 5 - x

define i32 @test_simplify10(i32 %x) {
; CHECK-LABEL: @test_simplify10(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 5, [[X:%.*]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %hello_p = getelementptr inbounds [6 x i8], [6 x i8]* @hello, i32 0, i32 %x
  %hello_l = call i32 @strlen(i8* %hello_p)
  ret i32 %hello_l
}

; strlen(@null_hello_mid + (x & 7)) --> 9 - (x & 7)

define i32 @test_simplify11(i32 %x) {
; CHECK-LABEL: @test_simplify11(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 7
; CHECK-NEXT:    [[TMP1:%.*]] = sub nuw nsw i32 9, [[AND]]
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %and = and i32 %x, 7
  %hello_p = getelementptr inbounds [13 x i8], [13 x i8]* @null_hello_mid, i32 0, i32 %and
  %hello_l = call i32 @strlen(i8* %hello_p)
  ret i32 %hello_l
}

; Check cases that shouldn't be simplified.

define i32 @test_no_simplify1() {
; CHECK-LABEL: @test_no_simplify1(
; CHECK-NEXT:    [[A_L:%.*]] = call i32 @strlen(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0))
; CHECK-NEXT:    ret i32 [[A_L]]
;
  %a_p = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %a_l = call i32 @strlen(i8* %a_p)
  ret i32 %a_l
}

; strlen(@null_hello + x) should not be simplified to a sub instruction.

define i32 @test_no_simplify2(i32 %x) {
; CHECK-LABEL: @test_no_simplify2(
; CHECK-NEXT:    [[HELLO_P:%.*]] = getelementptr inbounds [7 x i8], [7 x i8]* @null_hello, i32 0, i32 [[X:%.*]]
; CHECK-NEXT:    [[HELLO_L:%.*]] = call i32 @strlen(i8* noundef nonnull [[HELLO_P]])
; CHECK-NEXT:    ret i32 [[HELLO_L]]
;
  %hello_p = getelementptr inbounds [7 x i8], [7 x i8]* @null_hello, i32 0, i32 %x
  %hello_l = call i32 @strlen(i8* %hello_p)
  ret i32 %hello_l
}

define i32 @test_no_simplify2_no_null_opt(i32 %x) #0 {
; CHECK-LABEL: @test_no_simplify2_no_null_opt(
; CHECK-NEXT:    [[HELLO_P:%.*]] = getelementptr inbounds [7 x i8], [7 x i8]* @null_hello, i32 0, i32 [[X:%.*]]
; CHECK-NEXT:    [[HELLO_L:%.*]] = call i32 @strlen(i8* noundef [[HELLO_P]])
; CHECK-NEXT:    ret i32 [[HELLO_L]]
;
  %hello_p = getelementptr inbounds [7 x i8], [7 x i8]* @null_hello, i32 0, i32 %x
  %hello_l = call i32 @strlen(i8* %hello_p)
  ret i32 %hello_l
}

; strlen(@null_hello_mid + (x & 15)) should not be simplified to a sub instruction.

define i32 @test_no_simplify3(i32 %x) {
; CHECK-LABEL: @test_no_simplify3(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 15
; CHECK-NEXT:    [[HELLO_P:%.*]] = getelementptr inbounds [13 x i8], [13 x i8]* @null_hello_mid, i32 0, i32 [[AND]]
; CHECK-NEXT:    [[HELLO_L:%.*]] = call i32 @strlen(i8* noundef nonnull [[HELLO_P]])
; CHECK-NEXT:    ret i32 [[HELLO_L]]
;
  %and = and i32 %x, 15
  %hello_p = getelementptr inbounds [13 x i8], [13 x i8]* @null_hello_mid, i32 0, i32 %and
  %hello_l = call i32 @strlen(i8* %hello_p)
  ret i32 %hello_l
}

define i32 @test_no_simplify3_on_null_opt(i32 %x) #0 {
; CHECK-LABEL: @test_no_simplify3_on_null_opt(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], 15
; CHECK-NEXT:    [[HELLO_P:%.*]] = getelementptr inbounds [13 x i8], [13 x i8]* @null_hello_mid, i32 0, i32 [[AND]]
; CHECK-NEXT:    [[HELLO_L:%.*]] = call i32 @strlen(i8* noundef [[HELLO_P]])
; CHECK-NEXT:    ret i32 [[HELLO_L]]
;
  %and = and i32 %x, 15
  %hello_p = getelementptr inbounds [13 x i8], [13 x i8]* @null_hello_mid, i32 0, i32 %and
  %hello_l = call i32 @strlen(i8* %hello_p)
  ret i32 %hello_l
}

define i32 @test1(i8* %str) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[LEN:%.*]] = tail call i32 @strlen(i8* noundef nonnull dereferenceable(1) [[STR:%.*]]) [[ATTR1:#.*]]
; CHECK-NEXT:    ret i32 [[LEN]]
;
  %len = tail call i32 @strlen(i8* %str) nounwind
  ret i32 %len
}

define i32 @test2(i8* %str) #0 {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[LEN:%.*]] = tail call i32 @strlen(i8* noundef [[STR:%.*]]) [[ATTR1]]
; CHECK-NEXT:    ret i32 [[LEN]]
;
  %len = tail call i32 @strlen(i8* %str) nounwind
  ret i32 %len
}

; Test cases for PR47149.
define i1 @strlen0_after_write_to_first_byte_global() {
; CHECK-LABEL: @strlen0_after_write_to_first_byte_global(
; CHECK-NEXT:    store i8 49, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0), align 16
; CHECK-NEXT:    ret i1 false
;
  store i8 49, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @a, i64 0, i64 0), align 16
  %len = tail call i32 @strlen(i8* nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @a, i64 0, i64 0))
  %cmp = icmp eq i32 %len, 0
  ret i1 %cmp
}

define i1 @strlen0_after_write_to_second_byte_global() {
; CHECK-LABEL: @strlen0_after_write_to_second_byte_global(
; CHECK-NEXT:    store i8 49, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 1), align 16
; CHECK-NEXT:    [[STRLENFIRST:%.*]] = load i8, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0), align 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[STRLENFIRST]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  store i8 49, i8* getelementptr inbounds ([32 x i8], [32 x i8]* @a, i64 0, i64 1), align 16
  %len = tail call i32 @strlen(i8* nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @a, i64 0, i64 0))
  %cmp = icmp eq i32 %len, 0
  ret i1 %cmp
}

define i1 @strlen0_after_write_to_first_byte(i8 *%ptr) {
; CHECK-LABEL: @strlen0_after_write_to_first_byte(
; CHECK-NEXT:    store i8 49, i8* [[PTR:%.*]], align 1
; CHECK-NEXT:    ret i1 false
;
  store i8 49, i8* %ptr
  %len = tail call i32 @strlen(i8* nonnull dereferenceable(1) %ptr)
  %cmp = icmp eq i32 %len, 0
  ret i1 %cmp
}

define i1 @strlen0_after_write_to_second_byte(i8 *%ptr) {
; CHECK-LABEL: @strlen0_after_write_to_second_byte(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[PTR:%.*]], i32 1
; CHECK-NEXT:    store i8 49, i8* [[GEP]], align 1
; CHECK-NEXT:    [[STRLENFIRST:%.*]] = load i8, i8* [[PTR]], align 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8 [[STRLENFIRST]], 0
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep = getelementptr i8, i8* %ptr, i64 1
  store i8 49, i8* %gep
  %len = tail call i32 @strlen(i8* nonnull dereferenceable(1) %ptr)
  %cmp = icmp eq i32 %len, 0
  ret i1 %cmp
}

attributes #0 = { null_pointer_is_valid }
