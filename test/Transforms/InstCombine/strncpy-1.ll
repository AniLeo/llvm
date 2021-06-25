; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that the strncpy library call simplifier works correctly.
;
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

@hello = constant [6 x i8] c"hello\00"
@null = constant [1 x i8] zeroinitializer
@null_hello = constant [7 x i8] c"\00hello\00"
@a = common global [32 x i8] zeroinitializer, align 1
@b = common global [32 x i8] zeroinitializer, align 1

declare i8* @strncpy(i8*, i8*, i32)
declare i32 @puts(i8*)

; Check a bunch of strncpy invocations together.

define i32 @test_simplify1() {
; CHECK-LABEL: @test_simplify1(
; CHECK-NEXT:    [[TARGET:%.*]] = alloca [1024 x i8], align 1
; CHECK-NEXT:    [[ARG1:%.*]] = getelementptr inbounds [1024 x i8], [1024 x i8]* [[TARGET]], i32 0, i32 0
; CHECK-NEXT:    store i8 0, i8* [[ARG1]], align 1
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(6) [[ARG1]], i8* noundef nonnull align 1 dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @hello, i32 0, i32 0), i32 6, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(42) [[ARG1]], i8 0, i32 42, i1 false)
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(42) [[ARG1]], i8 0, i32 42, i1 false)
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @puts(i8* noundef nonnull [[ARG1]])
; CHECK-NEXT:    ret i32 0
;
  %target = alloca [1024 x i8]
  %arg1 = getelementptr [1024 x i8], [1024 x i8]* %target, i32 0, i32 0
  store i8 0, i8* %arg1

  %arg2 = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  %rslt1 = call i8* @strncpy(i8* %arg1, i8* %arg2, i32 6)

  %arg3 = getelementptr [1 x i8], [1 x i8]* @null, i32 0, i32 0
  %rslt2 = call i8* @strncpy(i8* %rslt1, i8* %arg3, i32 42)

  %arg4 = getelementptr [7 x i8], [7 x i8]* @null_hello, i32 0, i32 0
  %rslt3 = call i8* @strncpy(i8* %rslt2, i8* %arg4, i32 42)

  call i32 @puts( i8* %rslt3 )
  ret i32 0
}

; Check strncpy(x, "", y) -> memset(x, '\0', y, 1).

define void @test_simplify2() {
; CHECK-LABEL: @test_simplify2(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(32) getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0), i8 0, i32 32, i1 false)
; CHECK-NEXT:    ret void
;
  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [1 x i8], [1 x i8]* @null, i32 0, i32 0

  call i8* @strncpy(i8* %dst, i8* %src, i32 32)
  ret void
}

; Check strncpy(x, y, 0) -> x.

define i8* @test_simplify3() {
; CHECK-LABEL: @test_simplify3(
; CHECK-NEXT:    ret i8* getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0)
;
  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0

  %ret = call i8* @strncpy(i8* %dst, i8* %src, i32 0)
  ret i8* %ret
}

; Check  strncpy(x, s, c) -> memcpy(x, s, c, 1) [s and c are constant].

define void @test_simplify4() {
; CHECK-LABEL: @test_simplify4(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(6) getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0), i8* noundef nonnull align 1 dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @hello, i32 0, i32 0), i32 6, i1 false)
; CHECK-NEXT:    ret void
;
  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0

  call i8* @strncpy(i8* %dst, i8* %src, i32 6)
  ret void
}

define void @test_simplify5(i8* %dst) {
; CHECK-LABEL: @test_simplify5(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(32) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(32) getelementptr inbounds ([33 x i8], [33 x i8]* @str, i32 0, i32 0), i32 32, i1 false)
; CHECK-NEXT:    ret void
;
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  call i8* @strncpy(i8* dereferenceable(8) %dst, i8* %src, i32 32)
  ret void
}

define void @test_simplify6(i8* %dst) {
; CHECK-LABEL: @test_simplify6(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(80) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(32) getelementptr inbounds ([33 x i8], [33 x i8]* @str.1, i32 0, i32 0), i32 32, i1 false)
; CHECK-NEXT:    ret void
;
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  call i8* @strncpy(i8* dereferenceable(80) %dst, i8* %src, i32 32)
  ret void
}

define void @test_simplify7(i8* %dst, i32 %n) {
; CHECK-LABEL: @test_simplify7(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @strncpy(i8* noundef nonnull dereferenceable(80) [[DST:%.*]], i8* getelementptr inbounds ([1 x i8], [1 x i8]* @null, i32 0, i32 0), i32 [[N:%.*]])
; CHECK-NEXT:    ret void
;
  %src = getelementptr [1 x i8], [1 x i8]* @null, i32 0, i32 0
  call i8* @strncpy(i8* dereferenceable(80) %dst, i8* %src, i32 %n)
  ret void
}

define i8* @test1(i8* %dst, i8* %src, i32 %n) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[RET:%.*]] = call i8* @strncpy(i8* noundef nonnull [[DST:%.*]], i8* nonnull [[SRC:%.*]], i32 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[RET]]
;
  %ret = call i8* @strncpy(i8* nonnull %dst, i8* nonnull %src, i32 %n)
  ret i8* %ret
}

define i8* @test2(i8* %dst) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(5) [[DST:%.*]], i8* noundef nonnull align 1 dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @hello, i32 0, i32 0), i32 5, i1 false)
; CHECK-NEXT:    ret i8* [[DST]]
;
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0
  %ret = call i8* @strncpy(i8* nonnull %dst, i8* nonnull %src, i32 5)
  ret i8* %ret
}

define i8* @test3(i8* %dst, i32 %n) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* noalias noundef nonnull align 1 dereferenceable(5) [[DST:%.*]], i8 0, i32 5, i1 false)
; CHECK-NEXT:    ret i8* [[DST]]
;
  %src = getelementptr [1 x i8], [1 x i8]* @null, i32 0, i32 0
  %ret = call i8* @strncpy(i8* noalias nonnull %dst, i8* nonnull %src, i32 5);
  ret i8* %ret
}

define i8* @test4(i8* %dst, i32 %n) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* noalias noundef nonnull align 16 dereferenceable(5) [[DST:%.*]], i8 0, i32 5, i1 false)
; CHECK-NEXT:    ret i8* [[DST]]
;
  %src = getelementptr [1 x i8], [1 x i8]* @null, i32 0, i32 0
  %ret = call i8* @strncpy(i8* align(16) noalias nonnull %dst, i8* nonnull %src, i32 5);
  ret i8* %ret
}

; Check cases that shouldn't be simplified.

define void @test_no_simplify1() {
; CHECK-LABEL: @test_no_simplify1(
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @strncpy(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0), i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([32 x i8], [32 x i8]* @b, i32 0, i32 0), i32 32)
; CHECK-NEXT:    ret void
;
  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [32 x i8], [32 x i8]* @b, i32 0, i32 0

  call i8* @strncpy(i8* %dst, i8* %src, i32 32)
  ret void
}

define void @test_no_simplify2() {
; CHECK-LABEL: @test_no_simplify2(
; CHECK-NEXT:    store i64 478560413032, i64* bitcast ([32 x i8]* @a to i64*), align 1
; CHECK-NEXT:    ret void
;
  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0

  call i8* @strncpy(i8* %dst, i8* %src, i32 8)
  ret void
}

define void @test_no_incompatible_attr() {
; CHECK-LABEL: @test_no_incompatible_attr(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(6) getelementptr inbounds ([32 x i8], [32 x i8]* @a, i32 0, i32 0), i8* noundef nonnull align 1 dereferenceable(6) getelementptr inbounds ([6 x i8], [6 x i8]* @hello, i32 0, i32 0), i32 6, i1 false)
; CHECK-NEXT:    ret void
;
  %dst = getelementptr [32 x i8], [32 x i8]* @a, i32 0, i32 0
  %src = getelementptr [6 x i8], [6 x i8]* @hello, i32 0, i32 0

  call i8* @strncpy(i8* %dst, i8* %src, i32 6)
  ret void
}
