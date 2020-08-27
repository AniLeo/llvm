; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -inferattrs -basic-aa -dse -enable-dse-memoryssa < %s | FileCheck %s

target triple = "x86_64-unknown-linux-gnu"

declare i8* @strcpy(i8* %dest, i8* %src) nounwind
define void @test1(i8* %src) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret void
;
  %B = alloca [16 x i8]
  %dest = getelementptr inbounds [16 x i8], [16 x i8]* %B, i64 0, i64 0
  %call = call i8* @strcpy(i8* %dest, i8* %src)
  ret void
}

declare i8* @strncpy(i8* %dest, i8* %src, i64 %n) nounwind
define void @test2(i8* %src) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret void
;
  %B = alloca [16 x i8]
  %dest = getelementptr inbounds [16 x i8], [16 x i8]* %B, i64 0, i64 0
  %call = call i8* @strncpy(i8* %dest, i8* %src, i64 12)
  ret void
}

declare i8* @strcat(i8* %dest, i8* %src) nounwind
define void @test3(i8* %src) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret void
;
  %B = alloca [16 x i8]
  %dest = getelementptr inbounds [16 x i8], [16 x i8]* %B, i64 0, i64 0
  %call = call i8* @strcat(i8* %dest, i8* %src)
  ret void
}

declare i8* @strncat(i8* %dest, i8* %src, i64 %n) nounwind
define void @test4(i8* %src) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret void
;
  %B = alloca [16 x i8]
  %dest = getelementptr inbounds [16 x i8], [16 x i8]* %B, i64 0, i64 0
  %call = call i8* @strncat(i8* %dest, i8* %src, i64 12)
  ret void
}

define void @test5(i8* nocapture %src) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret void
;
  %dest = alloca [100 x i8], align 16
  %arraydecay = getelementptr inbounds [100 x i8], [100 x i8]* %dest, i64 0, i64 0
  %call = call i8* @strcpy(i8* %arraydecay, i8* %src)
  %arrayidx = getelementptr inbounds i8, i8* %call, i64 10
  store i8 97, i8* %arrayidx, align 1
  ret void
}

declare void @user(i8* %p)
define void @test6(i8* %src) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[B:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[DEST:%.*]] = getelementptr inbounds [16 x i8], [16 x i8]* [[B]], i64 0, i64 0
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @strcpy(i8* [[DEST]], i8* [[SRC:%.*]])
; CHECK-NEXT:    call void @user(i8* [[DEST]])
; CHECK-NEXT:    ret void
;
  %B = alloca [16 x i8]
  %dest = getelementptr inbounds [16 x i8], [16 x i8]* %B, i64 0, i64 0
  %call = call i8* @strcpy(i8* %dest, i8* %src)
  call void @user(i8* %dest)
  ret void
}

declare i32 @memcmp(i8*, i8*, i64)

define i32 @test_memcmp_const_size(i8* noalias %foo) {
; CHECK-LABEL: @test_memcmp_const_size(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STACK:%.*]] = alloca [10 x i8], align 1
; CHECK-NEXT:    [[STACK_PTR:%.*]] = bitcast [10 x i8]* [[STACK]] to i8*
; CHECK-NEXT:    store i8 49, i8* [[STACK_PTR]], align 1
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 1
; CHECK-NEXT:    store i8 50, i8* [[GEP_1]], align 1
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 2
; CHECK-NEXT:    store i8 51, i8* [[GEP_2]], align 1
; CHECK-NEXT:    [[GEP_3:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 3
; CHECK-NEXT:    store i8 52, i8* [[GEP_3]], align 1
; CHECK-NEXT:    [[RES:%.*]] = call i32 @memcmp(i8* nonnull dereferenceable(2) [[FOO:%.*]], i8* nonnull dereferenceable(2) [[STACK_PTR]], i64 2)
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  %stack = alloca [10 x i8]
  %stack.ptr = bitcast [10 x i8]* %stack to i8*
  store i8 49, i8* %stack.ptr, align 1
  %gep.1 = getelementptr i8, i8* %stack.ptr, i64 1
  store i8 50, i8* %gep.1, align 1
  %gep.2 = getelementptr i8, i8* %stack.ptr, i64 2
  store i8 51, i8* %gep.2, align 1
  %gep.3 = getelementptr i8, i8* %stack.ptr, i64 3
  store i8 52, i8* %gep.3, align 1
  %res = call i32 @memcmp(i8* nonnull dereferenceable(2) %foo, i8* nonnull dereferenceable(2) %stack.ptr, i64 2)
  ret i32 %res
}

define i32 @test_memcmp_variable_size(i8* noalias %foo, i64 %n) {
; CHECK-LABEL: @test_memcmp_variable_size(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STACK:%.*]] = alloca [10 x i8], align 1
; CHECK-NEXT:    [[STACK_PTR:%.*]] = bitcast [10 x i8]* [[STACK]] to i8*
; CHECK-NEXT:    store i8 49, i8* [[STACK_PTR]], align 1
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 1
; CHECK-NEXT:    store i8 50, i8* [[GEP_1]], align 1
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 2
; CHECK-NEXT:    store i8 51, i8* [[GEP_2]], align 1
; CHECK-NEXT:    [[GEP_3:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 3
; CHECK-NEXT:    store i8 52, i8* [[GEP_3]], align 1
; CHECK-NEXT:    [[RES:%.*]] = call i32 @memcmp(i8* nonnull [[FOO:%.*]], i8* nonnull [[STACK_PTR]], i64 [[N:%.*]])
; CHECK-NEXT:    ret i32 [[RES]]
;
entry:
  %stack = alloca [10 x i8]
  %stack.ptr = bitcast [10 x i8]* %stack to i8*
  store i8 49, i8* %stack.ptr, align 1
  %gep.1 = getelementptr i8, i8* %stack.ptr, i64 1
  store i8 50, i8* %gep.1, align 1
  %gep.2 = getelementptr i8, i8* %stack.ptr, i64 2
  store i8 51, i8* %gep.2, align 1
  %gep.3 = getelementptr i8, i8* %stack.ptr, i64 3
  store i8 52, i8* %gep.3, align 1
  %res = call i32 @memcmp(i8* nonnull %foo, i8* nonnull %stack.ptr, i64 %n)
  ret i32 %res
}
