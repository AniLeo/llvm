; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -inferattrs -basic-aa -dse | FileCheck %s
; RUN: opt < %s -S -aa-pipeline=basic-aa -passes=inferattrs,dse | FileCheck %s

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

define void @strcpy_reads_after(i8* noalias %dest, i8* %src) {
; CHECK-LABEL: @strcpy_reads_after(
; CHECK-NEXT:    [[SRC_2:%.*]] = getelementptr inbounds i8, i8* [[SRC:%.*]], i64 1
; CHECK-NEXT:    store i8 99, i8* [[SRC_2]], align 1
; CHECK-NEXT:    [[SRC_1:%.*]] = getelementptr inbounds i8, i8* [[SRC]], i64 1
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @strcpy(i8* [[DEST:%.*]], i8* [[SRC_1]])
; CHECK-NEXT:    store i8 2, i8* [[SRC]], align 1
; CHECK-NEXT:    store i8 2, i8* [[SRC_2]], align 1
; CHECK-NEXT:    ret void
;
  %src.2 = getelementptr inbounds i8, i8* %src, i64 1
  store i8 1, i8* %src
  store i8 99, i8* %src.2
  %src.1 = getelementptr inbounds i8, i8* %src, i64 1
  %call = call i8* @strcpy(i8* %dest, i8* %src.1)
  store i8 2, i8* %src
  store i8 2, i8* %src.2
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

define void @test_strcat_with_lifetime(i8* %src) {
; CHECK-LABEL: @test_strcat_with_lifetime(
; CHECK-NEXT:    [[B:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[B_CAST:%.*]] = bitcast [16 x i8]* [[B]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull [[B_CAST]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull [[B_CAST]])
; CHECK-NEXT:    ret void
;
  %B = alloca [16 x i8]
  %B.cast = bitcast [16 x i8]* %B to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %B.cast)
  %dest = getelementptr inbounds [16 x i8], [16 x i8]* %B, i64 0, i64 0
  %call = call i8* @strcat(i8* %dest, i8* %src)
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %B.cast)
  ret void
}

define void @test_strcat_with_lifetime_nonlocal(i8* %dest, i8* %src) {
; CHECK-LABEL: @test_strcat_with_lifetime_nonlocal(
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull [[DEST:%.*]])
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @strcat(i8* [[DEST]], i8* [[SRC:%.*]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull [[DEST]])
; CHECK-NEXT:    ret void
;
  call void @llvm.lifetime.start.p0i8(i64 16, i8* nonnull %dest)
  %call = call i8* @strcat(i8* %dest, i8* %src)
  call void @llvm.lifetime.end.p0i8(i64 16, i8* nonnull %dest)
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

declare i32 @bcmp(i8*, i8*, i64)

define i1 @test_bcmp_const_size(i8* noalias %foo) {
; CHECK-LABEL: @test_bcmp_const_size(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STACK:%.*]] = alloca [10 x i8], align 1
; CHECK-NEXT:    [[STACK_PTR:%.*]] = bitcast [10 x i8]* [[STACK]] to i8*
; CHECK-NEXT:    store i8 49, i8* [[STACK_PTR]], align 1
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 1
; CHECK-NEXT:    store i8 50, i8* [[GEP_1]], align 1
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @bcmp(i8* nonnull dereferenceable(2) [[FOO:%.*]], i8* nonnull dereferenceable(2) [[STACK_PTR]], i64 2)
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[CALL]], 0
; CHECK-NEXT:    ret i1 [[RES]]
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
  %call = call i32 @bcmp(i8* nonnull dereferenceable(2) %foo, i8* nonnull dereferenceable(2) %stack.ptr, i64 2)
  %res = icmp eq i32 %call, 0
  ret i1 %res
}

define i1 @test_bcmp_variable_size(i8* noalias %foo, i64 %n) {
; CHECK-LABEL: @test_bcmp_variable_size(
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
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @bcmp(i8* nonnull [[FOO:%.*]], i8* nonnull [[STACK_PTR]], i64 [[N:%.*]])
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i32 [[CALL]], 0
; CHECK-NEXT:    ret i1 [[RES]]
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
  %call = call i32 @bcmp(i8* nonnull %foo, i8* nonnull %stack.ptr, i64 %n)
  %res = icmp eq i32 %call, 0
  ret i1 %res
}

declare i8* @memchr(i8*, i32, i64)

define i8* @test_memchr_const_size() {
; CHECK-LABEL: @test_memchr_const_size(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STACK:%.*]] = alloca [10 x i8], align 1
; CHECK-NEXT:    [[STACK_PTR:%.*]] = bitcast [10 x i8]* [[STACK]] to i8*
; CHECK-NEXT:    store i8 49, i8* [[STACK_PTR]], align 1
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 1
; CHECK-NEXT:    store i8 50, i8* [[GEP_1]], align 1
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memchr(i8* [[STACK_PTR]], i32 42, i64 2)
; CHECK-NEXT:    ret i8* [[CALL]]
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
  %call = call i8* @memchr(i8* %stack.ptr, i32 42, i64 2)
  ret i8* %call
}

define i8* @test_memchr_variable_size(i64 %n) {
; CHECK-LABEL: @test_memchr_variable_size(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STACK:%.*]] = alloca [10 x i8], align 1
; CHECK-NEXT:    [[STACK_PTR:%.*]] = bitcast [10 x i8]* [[STACK]] to i8*
; CHECK-NEXT:    store i8 49, i8* [[STACK_PTR]], align 1
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 1
; CHECK-NEXT:    store i8 50, i8* [[GEP_1]], align 1
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 2
; CHECK-NEXT:    store i8 51, i8* [[GEP_2]], align 1
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 4
; CHECK-NEXT:    store i8 52, i8* [[GEP]], align 1
; CHECK-NEXT:    [[CALL:%.*]] = call i8* @memchr(i8* [[STACK_PTR]], i32 42, i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
entry:
  %stack = alloca [10 x i8]
  %stack.ptr = bitcast [10 x i8]* %stack to i8*
  store i8 49, i8* %stack.ptr, align 1
  %gep.1 = getelementptr i8, i8* %stack.ptr, i64 1
  store i8 50, i8* %gep.1, align 1
  %gep.2 = getelementptr i8, i8* %stack.ptr, i64 2
  store i8 51, i8* %gep.2, align 1
  %gep = getelementptr i8, i8* %stack.ptr, i64 4
  store i8 52, i8* %gep, align 1
  %call = call i8* @memchr(i8* %stack.ptr, i32 42, i64 %n)
  ret i8* %call
}

declare i8* @memccpy(i8*, i8*, i32, i64)

define i8* @test_memccpy_const_size(i8* %foo) {
; CHECK-LABEL: @test_memccpy_const_size(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STACK:%.*]] = alloca [10 x i8], align 1
; CHECK-NEXT:    [[STACK_PTR:%.*]] = bitcast [10 x i8]* [[STACK]] to i8*
; CHECK-NEXT:    store i8 49, i8* [[STACK_PTR]], align 1
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr i8, i8* [[STACK_PTR]], i64 1
; CHECK-NEXT:    store i8 50, i8* [[GEP_1]], align 1
; CHECK-NEXT:    [[RES:%.*]] = call i8* @memccpy(i8* [[FOO:%.*]], i8* [[STACK_PTR]], i32 42, i64 2)
; CHECK-NEXT:    ret i8* [[RES]]
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
  %res = call i8* @memccpy(i8* %foo, i8* %stack.ptr, i32 42, i64 2)
  ret i8* %res
}

define i8* @test_memccpy_variable_size(i8* %foo, i64 %n) {
; CHECK-LABEL: @test_memccpy_variable_size(
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
; CHECK-NEXT:    [[RES:%.*]] = call i8* @memccpy(i8* [[FOO:%.*]], i8* [[STACK_PTR]], i32 42, i64 [[N:%.*]])
; CHECK-NEXT:    ret i8* [[RES]]
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
  %res = call i8* @memccpy(i8* %foo, i8* %stack.ptr, i32 42, i64 %n)
  ret i8* %res
}

; Make sure memccpy does not kill any stores, because it is not known how many
; bytes are written.
define i8* @test_memccpy_const_size_does_not_kill_stores(i8* noalias %dest, i8* noalias %foo) {
; CHECK-LABEL: @test_memccpy_const_size_does_not_kill_stores(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i8 49, i8* [[DEST:%.*]], align 1
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr i8, i8* [[DEST]], i64 1
; CHECK-NEXT:    store i8 50, i8* [[GEP_1]], align 1
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr i8, i8* [[DEST]], i64 2
; CHECK-NEXT:    store i8 51, i8* [[GEP_2]], align 1
; CHECK-NEXT:    [[GEP_3:%.*]] = getelementptr i8, i8* [[DEST]], i64 3
; CHECK-NEXT:    store i8 52, i8* [[GEP_3]], align 1
; CHECK-NEXT:    [[RES:%.*]] = call i8* @memccpy(i8* [[DEST]], i8* [[FOO:%.*]], i32 42, i64 2)
; CHECK-NEXT:    ret i8* [[RES]]
;
entry:
  store i8 49, i8* %dest, align 1
  %gep.1 = getelementptr i8, i8* %dest, i64 1
  store i8 50, i8* %gep.1, align 1
  %gep.2 = getelementptr i8, i8* %dest, i64 2
  store i8 51, i8* %gep.2, align 1
  %gep.3 = getelementptr i8, i8* %dest, i64 3
  store i8 52, i8* %gep.3, align 1
  %res = call i8* @memccpy(i8* %dest, i8* %foo, i32 42, i64 2)
  ret i8* %res
}

define void @dse_strcpy(i8* nocapture readonly %src) {
; CHECK-LABEL: @dse_strcpy(
; CHECK-NEXT:    [[A:%.*]] = alloca [256 x i8], align 16
; CHECK-NEXT:    [[BUF:%.*]] = getelementptr inbounds [256 x i8], [256 x i8]* [[A]], i64 0, i64 0
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull [[BUF]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull [[BUF]])
; CHECK-NEXT:    ret void
;
  %a = alloca [256 x i8], align 16
  %buf = getelementptr inbounds [256 x i8], [256 x i8]* %a, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull %buf)
  call i8* @strcpy(i8* nonnull %buf, i8* nonnull dereferenceable(1) %src)
  call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull %buf)
  ret void
}

define void @dse_strncpy(i8* nocapture readonly %src) {
; CHECK-LABEL: @dse_strncpy(
; CHECK-NEXT:    [[A:%.*]] = alloca [256 x i8], align 16
; CHECK-NEXT:    [[BUF:%.*]] = getelementptr inbounds [256 x i8], [256 x i8]* [[A]], i64 0, i64 0
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull [[BUF]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull [[BUF]])
; CHECK-NEXT:    ret void
;
  %a = alloca [256 x i8], align 16
  %buf = getelementptr inbounds [256 x i8], [256 x i8]* %a, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull %buf)
  call i8* @strncpy(i8* nonnull %buf, i8* nonnull dereferenceable(1) %src, i64 6)
  call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull %buf)
  ret void
}

define void @dse_strcat(i8* nocapture readonly %src) {
; CHECK-LABEL: @dse_strcat(
; CHECK-NEXT:    [[A:%.*]] = alloca [256 x i8], align 16
; CHECK-NEXT:    [[BUF:%.*]] = getelementptr inbounds [256 x i8], [256 x i8]* [[A]], i64 0, i64 0
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull [[BUF]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull [[BUF]])
; CHECK-NEXT:    ret void
;
  %a = alloca [256 x i8], align 16
  %buf = getelementptr inbounds [256 x i8], [256 x i8]* %a, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull %buf)
  call i8* @strcat(i8* nonnull %buf, i8* nonnull dereferenceable(1) %src)
  call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull %buf)
  ret void
}

define void @dse_strncat(i8* nocapture readonly %src) {
; CHECK-LABEL: @dse_strncat(
; CHECK-NEXT:    [[A:%.*]] = alloca [256 x i8], align 16
; CHECK-NEXT:    [[BUF:%.*]] = getelementptr inbounds [256 x i8], [256 x i8]* [[A]], i64 0, i64 0
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull [[BUF]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull [[BUF]])
; CHECK-NEXT:    ret void
;
  %a = alloca [256 x i8], align 16
  %buf = getelementptr inbounds [256 x i8], [256 x i8]* %a, i64 0, i64 0
  call void @llvm.lifetime.start.p0i8(i64 256, i8* nonnull %buf)
  call i8* @strncat(i8* nonnull %buf, i8* nonnull dereferenceable(1) %src, i64 6)
  call void @llvm.lifetime.end.p0i8(i64 256, i8* nonnull %buf)
  ret void
}

declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind

; Test that strncpy/memset overwriting each other is optimized out

; strncpy -> memset, full overwrite
define void @dse_strncpy_test1(i8* noalias %out, i8* noalias %in) {
; CHECK-LABEL: @dse_strncpy_test1(
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* [[OUT:%.*]], i8 42, i64 100, i1 false)
; CHECK-NEXT:    ret void
;
  %call = tail call i8* @strncpy(i8* %out, i8* %in, i64 100)
  tail call void @llvm.memset.p0i8.i64(i8* %out, i8 42, i64 100, i1 false)
  ret void
}

declare i8* @__memset_chk(i8* writeonly, i32, i64, i64) argmemonly

; strncpy -> __memset_chk, full overwrite
define void @dse_strncpy_memset_chk_test1(i8* noalias %out, i8* noalias %in, i64 %n) {
; CHECK-LABEL: @dse_strncpy_memset_chk_test1(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @strncpy(i8* [[OUT:%.*]], i8* [[IN:%.*]], i64 100)
; CHECK-NEXT:    [[CALL_2:%.*]] = tail call i8* @__memset_chk(i8* [[OUT]], i32 42, i64 100, i64 [[N:%.*]])
; CHECK-NEXT:    ret void
;
  %call = tail call i8* @strncpy(i8* %out, i8* %in, i64 100)
  %call.2 = tail call i8* @__memset_chk(i8* %out, i32 42, i64 100, i64 %n)
  ret void
}

; strncpy -> memset, partial overwrite
define void @dse_strncpy_test2(i8* noalias %out, i8* noalias %in) {
; CHECK-LABEL: @dse_strncpy_test2(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @strncpy(i8* [[OUT:%.*]], i8* [[IN:%.*]], i64 100)
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* [[OUT]], i8 42, i64 99, i1 false)
; CHECK-NEXT:    ret void
;
  %call = tail call i8* @strncpy(i8* %out, i8* %in, i64 100)
  tail call void @llvm.memset.p0i8.i64(i8* %out, i8 42, i64 99, i1 false)
  ret void
}

; strncpy -> memset_chk, partial overwrite
define void @dse_strncpy_memset_chk_test2(i8* noalias %out, i8* noalias %in, i64 %n) {
; CHECK-LABEL: @dse_strncpy_memset_chk_test2(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @strncpy(i8* [[OUT:%.*]], i8* [[IN:%.*]], i64 100)
; CHECK-NEXT:    [[CALL_2:%.*]] = tail call i8* @__memset_chk(i8* [[OUT]], i32 42, i64 99, i64 [[N:%.*]])
; CHECK-NEXT:    ret void
;
  %call = tail call i8* @strncpy(i8* %out, i8* %in, i64 100)
  %call.2 = tail call i8* @__memset_chk(i8* %out, i32 42, i64 99, i64 %n)
  ret void
}

; strncpy -> memset, different destination
define void @dse_strncpy_test3(i8* noalias %out1, i8* noalias %out2, i8* noalias %in) {
; CHECK-LABEL: @dse_strncpy_test3(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @strncpy(i8* [[OUT1:%.*]], i8* [[IN:%.*]], i64 100)
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* [[OUT2:%.*]], i8 42, i64 100, i1 false)
; CHECK-NEXT:    ret void
;
  %call = tail call i8* @strncpy(i8* %out1, i8* %in, i64 100)
  tail call void @llvm.memset.p0i8.i64(i8* %out2, i8 42, i64 100, i1 false)
  ret void
}

; strncpy -> memset_chk, different destination
define void @dse_strncpy_chk_test3(i8* noalias %out1, i8* noalias %out2, i8* noalias %in, i64 %n) {
; CHECK-LABEL: @dse_strncpy_chk_test3(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @strncpy(i8* [[OUT1:%.*]], i8* [[IN:%.*]], i64 100)
; CHECK-NEXT:    [[CALL_2:%.*]] = tail call i8* @__memset_chk(i8* [[OUT2:%.*]], i32 42, i64 100, i64 [[N:%.*]])
; CHECK-NEXT:    ret void
;
  %call = tail call i8* @strncpy(i8* %out1, i8* %in, i64 100)
  %call.2 = tail call i8* @__memset_chk(i8* %out2, i32 42, i64 100, i64 %n)
  ret void
}

; memset -> strncpy, full overwrite
define void @dse_strncpy_test4(i8* noalias %out, i8* noalias %in) {
; CHECK-LABEL: @dse_strncpy_test4(
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @strncpy(i8* [[OUT:%.*]], i8* [[IN:%.*]], i64 100)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memset.p0i8.i64(i8* %out, i8 42, i64 100, i1 false)
  %call = tail call i8* @strncpy(i8* %out, i8* %in, i64 100)
  ret void
}

; memset -> strncpy, partial overwrite
define void @dse_strncpy_test5(i8* noalias %out, i8* noalias %in) {
; CHECK-LABEL: @dse_strncpy_test5(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, i8* [[OUT:%.*]], i64 99
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP1]], i8 42, i64 1, i1 false)
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @strncpy(i8* [[OUT]], i8* [[IN:%.*]], i64 99)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memset.p0i8.i64(i8* %out, i8 42, i64 100, i1 false)
  %call = tail call i8* @strncpy(i8* %out, i8* %in, i64 99)
  ret void
}

; memset -> strncpy, different destination
define void @dse_strncpy_test6(i8* noalias %out1, i8* noalias %out2, i8* noalias %in) {
; CHECK-LABEL: @dse_strncpy_test6(
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* [[OUT1:%.*]], i8 42, i64 100, i1 false)
; CHECK-NEXT:    [[CALL:%.*]] = tail call i8* @strncpy(i8* [[OUT2:%.*]], i8* [[IN:%.*]], i64 100)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memset.p0i8.i64(i8* %out1, i8 42, i64 100, i1 false)
  %call = tail call i8* @strncpy(i8* %out2, i8* %in, i64 100)
  ret void
}
