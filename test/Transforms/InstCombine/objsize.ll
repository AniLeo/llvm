; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test a pile of objectsize bounds checking.
; RUN: opt < %s -passes=instcombine -S | FileCheck %s
; We need target data to get the sizes of the arrays and structures.
target datalayout = "e-p:32:32:32-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:32:64-v64:64:64-v128:128:128-a0:0:64-f80:128:128"

@a = private global [60 x i8] zeroinitializer, align 1 ; <[60 x i8]*>
@.str = private constant [8 x i8] c"abcdefg\00"   ; <[8 x i8]*>
define i32 @foo() nounwind {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    ret i32 60
;
  %1 = call i32 @llvm.objectsize.i32.p0i8(i8* getelementptr inbounds ([60 x i8], [60 x i8]* @a, i32 0, i32 0), i1 false, i1 false, i1 false)
  ret i32 %1
}

define i8* @bar() nounwind {
; CHECK-LABEL: @bar(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RETVAL:%.*]] = alloca i8*, align 4
; CHECK-NEXT:    br i1 true, label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    [[TMP0:%.*]] = load i8*, i8** [[RETVAL]], align 4
; CHECK-NEXT:    ret i8* [[TMP0]]
; CHECK:       cond.false:
; CHECK-NEXT:    ret i8* poison
;
entry:
  %retval = alloca i8*
  %0 = call i32 @llvm.objectsize.i32.p0i8(i8* getelementptr inbounds ([60 x i8], [60 x i8]* @a, i32 0, i32 0), i1 false, i1 false, i1 false)
  %cmp = icmp ne i32 %0, -1
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:
  %1 = load i8*, i8** %retval
  ret i8* %1

cond.false:
  %2 = load i8*, i8** %retval
  ret i8* %2
}

define i32 @f() nounwind {
; CHECK-LABEL: @f(
; CHECK-NEXT:    ret i32 0
;
  %1 = call i32 @llvm.objectsize.i32.p0i8(i8* getelementptr ([60 x i8], [60 x i8]* @a, i32 1, i32 0), i1 false, i1 false, i1 false)
  ret i32 %1
}

@window = external global [0 x i8]

define i1 @baz() nounwind {
; CHECK-LABEL: @baz(
; CHECK-NEXT:    [[TMP1:%.*]] = tail call i32 @llvm.objectsize.i32.p0i8(i8* getelementptr inbounds ([0 x i8], [0 x i8]* @window, i32 0, i32 0), i1 false, i1 false, i1 false)
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP1]], -1
; CHECK-NEXT:    ret i1 [[TMP2]]
;
  %1 = tail call i32 @llvm.objectsize.i32.p0i8(i8* getelementptr inbounds ([0 x i8], [0 x i8]* @window, i32 0, i32 0), i1 false, i1 false, i1 false)
  %2 = icmp eq i32 %1, -1
  ret i1 %2
}

define void @test1(i8* %q, i32 %x) nounwind noinline {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @llvm.objectsize.i32.p0i8(i8* getelementptr inbounds ([0 x i8], [0 x i8]* @window, i32 0, i32 10), i1 false, i1 false, i1 false)
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[TMP0]], -1
; CHECK-NEXT:    br i1 [[TMP1]], label %"47", label %"46"
; CHECK:       "46":
; CHECK-NEXT:    unreachable
; CHECK:       "47":
; CHECK-NEXT:    unreachable
;
entry:
  %0 = call i32 @llvm.objectsize.i32.p0i8(i8* getelementptr inbounds ([0 x i8], [0 x i8]* @window, i32 0, i32 10), i1 false, i1 false, i1 false) ; <i64> [#uses=1]
  %1 = icmp eq i32 %0, -1                         ; <i1> [#uses=1]
  br i1 %1, label %"47", label %"46"

"46":                                             ; preds = %entry
  unreachable

"47":                                             ; preds = %entry
  unreachable
}

@.str5 = private constant [9 x i32] [i32 97, i32 98, i32 99, i32 100, i32 0, i32
  101, i32 102, i32 103, i32 0], align 4
define i32 @test2() nounwind {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i32 34
;
  %1 = call i32 @llvm.objectsize.i32.p0i8(i8* getelementptr (i8, i8* bitcast ([9 x i32]* @.str5 to i8*), i32 2), i1 false, i1 false, i1 false)
  ret i32 %1
}

; rdar://7674946
@array = internal global [480 x float] zeroinitializer ; <[480 x float]*> [#uses=1]

declare i8* @__memcpy_chk(i8*, i8*, i32, i32) nounwind

declare i32 @llvm.objectsize.i32.p0i8(i8*, i1, i1, i1) nounwind readonly

declare i32 @llvm.objectsize.i32.p1i8(i8 addrspace(1)*, i1, i1, i1) nounwind readonly

declare i8* @__inline_memcpy_chk(i8*, i8*, i32) nounwind inlinehint

define void @test3(i1 %c1, i8* %ptr1, i8* %ptr2, i8* %ptr3) nounwind {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB11:%.*]], label [[BB12:%.*]]
; CHECK:       bb11:
; CHECK-NEXT:    unreachable
; CHECK:       bb12:
; CHECK-NEXT:    [[TMP0:%.*]] = call i8* @__inline_memcpy_chk(i8* bitcast (float* getelementptr inbounds ([480 x float], [480 x float]* @array, i32 0, i32 1) to i8*), i8* [[PTR3:%.*]], i32 512) #[[ATTR3:[0-9]+]]
; CHECK-NEXT:    unreachable
;
entry:
  br i1 %c1, label %bb11, label %bb12

bb11:
  %0 = getelementptr inbounds float, float* getelementptr inbounds ([480 x float], [480 x float]* @array, i32 0, i32 128), i32 -127 ; <float*> [#uses=1]
  %1 = bitcast float* %0 to i8*                   ; <i8*> [#uses=1]
  %2 = call i32 @llvm.objectsize.i32.p0i8(i8* %1, i1 false, i1 false, i1 false) ; <i32> [#uses=1]
  %3 = call i8* @__memcpy_chk(i8* %ptr1, i8* %ptr2, i32 512, i32 %2) nounwind ; <i8*> [#uses=0]
  unreachable

bb12:
  %4 = getelementptr inbounds float, float* getelementptr inbounds ([480 x float], [480 x float]* @array, i32 0, i32 128), i32 -127 ; <float*> [#uses=1]
  %5 = bitcast float* %4 to i8*                   ; <i8*> [#uses=1]
  %6 = call i8* @__inline_memcpy_chk(i8* %5, i8* %ptr3, i32 512) nounwind inlinehint ; <i8*> [#uses=0]
  unreachable
}

; rdar://7718857

%struct.data = type { [100 x i32], [100 x i32], [1024 x i8] }

define i32 @test4(i8** %esc) nounwind ssp {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca [[STRUCT_DATA:%.*]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast %struct.data* [[TMP0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* noundef nonnull align 8 dereferenceable(1824) [[TMP1]], i8 0, i32 1824, i1 false) #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8** [[ESC:%.*]] to %struct.data**
; CHECK-NEXT:    store %struct.data* [[TMP0]], %struct.data** [[TMP2]], align 4
; CHECK-NEXT:    ret i32 0
;
entry:
  %0 = alloca %struct.data, align 8
  %1 = bitcast %struct.data* %0 to i8*
  %2 = call i32 @llvm.objectsize.i32.p0i8(i8* %1, i1 false, i1 false, i1 false) nounwind
  %3 = call i8* @__memset_chk(i8* %1, i32 0, i32 1824, i32 %2) nounwind
  store i8* %1, i8** %esc
  ret i32 0
}

; rdar://7782496
@s = external global i8*

define i8* @test5(i32 %n) nounwind ssp {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = tail call noalias dereferenceable_or_null(20) i8* @malloc(i32 20) #[[ATTR0]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i8*, i8** @s, align 8
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i32(i8* noundef nonnull align 1 dereferenceable(10) [[TMP0]], i8* noundef nonnull align 1 dereferenceable(10) [[TMP1]], i32 10, i1 false) #[[ATTR0]]
; CHECK-NEXT:    ret i8* [[TMP0]]
;
entry:
  %0 = tail call noalias i8* @malloc(i32 20) nounwind
  %1 = tail call i32 @llvm.objectsize.i32.p0i8(i8* %0, i1 false, i1 false, i1 false)
  %2 = load i8*, i8** @s, align 8
  %3 = tail call i8* @__memcpy_chk(i8* %0, i8* %2, i32 10, i32 %1) nounwind
  ret i8* %0
}

define void @test6(i32 %n) nounwind ssp {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = tail call noalias dereferenceable_or_null(20) i8* @malloc(i32 20) #[[ATTR0]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i8*, i8** @s, align 8
; CHECK-NEXT:    [[TMP2:%.*]] = tail call i8* @__memcpy_chk(i8* [[TMP0]], i8* [[TMP1]], i32 30, i32 20) #[[ATTR0]]
; CHECK-NEXT:    ret void
;
entry:
  %0 = tail call noalias i8* @malloc(i32 20) nounwind
  %1 = tail call i32 @llvm.objectsize.i32.p0i8(i8* %0, i1 false, i1 false, i1 false)
  %2 = load i8*, i8** @s, align 8
  %3 = tail call i8* @__memcpy_chk(i8* %0, i8* %2, i32 30, i32 %1) nounwind
  ret void
}

declare i8* @__memset_chk(i8*, i32, i32, i32) nounwind

declare noalias i8* @malloc(i32) nounwind allockind("alloc,uninitialized") allocsize(0)

define i32 @test7(i8** %esc) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[ALLOC:%.*]] = call noalias dereferenceable_or_null(48) i8* @malloc(i32 48) #[[ATTR0]]
; CHECK-NEXT:    store i8* [[ALLOC]], i8** [[ESC:%.*]], align 4
; CHECK-NEXT:    ret i32 32
;
  %alloc = call noalias i8* @malloc(i32 48) nounwind
  store i8* %alloc, i8** %esc
  %gep = getelementptr inbounds i8, i8* %alloc, i32 16
  %objsize = call i32 @llvm.objectsize.i32.p0i8(i8* %gep, i1 false, i1 false, i1 false) nounwind readonly
  ret i32 %objsize
}

declare noalias i8* @calloc(i32, i32) nounwind allockind("alloc,zeroed") allocsize(0,1)

define i32 @test8(i8** %esc) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[ALLOC:%.*]] = call noalias dereferenceable_or_null(35) i8* @calloc(i32 5, i32 7) #[[ATTR0]]
; CHECK-NEXT:    store i8* [[ALLOC]], i8** [[ESC:%.*]], align 4
; CHECK-NEXT:    ret i32 30
;
  %alloc = call noalias i8* @calloc(i32 5, i32 7) nounwind
  store i8* %alloc, i8** %esc
  %gep = getelementptr inbounds i8, i8* %alloc, i32 5
  %objsize = call i32 @llvm.objectsize.i32.p0i8(i8* %gep, i1 false, i1 false, i1 false) nounwind readonly
  ret i32 %objsize
}

declare noalias i8* @strdup(i8* nocapture) nounwind
declare noalias i8* @strndup(i8* nocapture, i32) nounwind

define i32 @test9(i8** %esc) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[CALL:%.*]] = tail call dereferenceable_or_null(8) i8* @strdup(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0)) #[[ATTR0]]
; CHECK-NEXT:    store i8* [[CALL]], i8** [[ESC:%.*]], align 8
; CHECK-NEXT:    ret i32 8
;
  %call = tail call i8* @strdup(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0)) nounwind
  store i8* %call, i8** %esc, align 8
  %1 = tail call i32 @llvm.objectsize.i32.p0i8(i8* %call, i1 true, i1 false, i1 false)
  ret i32 %1
}

define i32 @test10(i8** %esc) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[CALL:%.*]] = tail call dereferenceable_or_null(4) i8* @strndup(i8* dereferenceable(8) getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0), i32 3) #[[ATTR0]]
; CHECK-NEXT:    store i8* [[CALL]], i8** [[ESC:%.*]], align 8
; CHECK-NEXT:    ret i32 4
;
  %call = tail call i8* @strndup(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i32 3) nounwind
  store i8* %call, i8** %esc, align 8
  %1 = tail call i32 @llvm.objectsize.i32.p0i8(i8* %call, i1 true, i1 false, i1 false)
  ret i32 %1
}

define i32 @test11(i8** %esc) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[STRDUP:%.*]] = tail call dereferenceable_or_null(8) i8* @strdup(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0))
; CHECK-NEXT:    store i8* [[STRDUP]], i8** [[ESC:%.*]], align 8
; CHECK-NEXT:    ret i32 8
;
  %call = tail call i8* @strndup(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i32 7) nounwind
  store i8* %call, i8** %esc, align 8
  %1 = tail call i32 @llvm.objectsize.i32.p0i8(i8* %call, i1 true, i1 false, i1 false)
  ret i32 %1
}

define i32 @test12(i8** %esc) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[STRDUP:%.*]] = tail call dereferenceable_or_null(8) i8* @strdup(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0))
; CHECK-NEXT:    store i8* [[STRDUP]], i8** [[ESC:%.*]], align 8
; CHECK-NEXT:    ret i32 8
;
  %call = tail call i8* @strndup(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i32 8) nounwind
  store i8* %call, i8** %esc, align 8
  %1 = tail call i32 @llvm.objectsize.i32.p0i8(i8* %call, i1 true, i1 false, i1 false)
  ret i32 %1
}

define i32 @test13(i8** %esc) {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[STRDUP:%.*]] = tail call dereferenceable_or_null(8) i8* @strdup(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i32 0, i32 0))
; CHECK-NEXT:    store i8* [[STRDUP]], i8** [[ESC:%.*]], align 8
; CHECK-NEXT:    ret i32 8
;
  %call = tail call i8* @strndup(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str, i64 0, i64 0), i32 57) nounwind
  store i8* %call, i8** %esc, align 8
  %1 = tail call i32 @llvm.objectsize.i32.p0i8(i8* %call, i1 true, i1 false, i1 false)
  ret i32 %1
}

@globalalias = internal alias [60 x i8], [60 x i8]* @a

define i32 @test18() {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    ret i32 60
;
  %bc = bitcast [60 x i8]* @globalalias to i8*
  %1 = call i32 @llvm.objectsize.i32.p0i8(i8* %bc, i1 false, i1 false, i1 false)
  ret i32 %1
}

@globalalias2 = weak alias [60 x i8], [60 x i8]* @a

define i32 @test19() {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.objectsize.i32.p0i8(i8* getelementptr inbounds ([60 x i8], [60 x i8]* @globalalias2, i32 0, i32 0), i1 false, i1 false, i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %bc = bitcast [60 x i8]* @globalalias2 to i8*
  %1 = call i32 @llvm.objectsize.i32.p0i8(i8* %bc, i1 false, i1 false, i1 false)
  ret i32 %1
}

define i32 @test20() {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    ret i32 0
;
  %1 = call i32 @llvm.objectsize.i32.p0i8(i8* null, i1 false, i1 false, i1 false)
  ret i32 %1
}

define i32 @test21() {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    ret i32 0
;
  %1 = call i32 @llvm.objectsize.i32.p0i8(i8* null, i1 true, i1 false, i1 false)
  ret i32 %1
}

define i32 @test22() {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.objectsize.i32.p0i8(i8* null, i1 false, i1 true, i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = call i32 @llvm.objectsize.i32.p0i8(i8* null, i1 false, i1 true, i1 false)
  ret i32 %1
}

define i32 @test23() {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.objectsize.i32.p0i8(i8* null, i1 true, i1 true, i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = call i32 @llvm.objectsize.i32.p0i8(i8* null, i1 true, i1 true, i1 false)
  ret i32 %1
}

; 1 is an arbitrary non-zero address space.
define i32 @test24() {
; CHECK-LABEL: @test24(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.objectsize.i32.p1i8(i8 addrspace(1)* null, i1 false, i1 false, i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = call i32 @llvm.objectsize.i32.p1i8(i8 addrspace(1)* null, i1 false,
  i1 false, i1 false)
  ret i32 %1
}

define i32 @test25() {
; CHECK-LABEL: @test25(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.objectsize.i32.p1i8(i8 addrspace(1)* null, i1 true, i1 false, i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = call i32 @llvm.objectsize.i32.p1i8(i8 addrspace(1)* null, i1 true,
  i1 false, i1 false)
  ret i32 %1
}

define i32 @test26() {
; CHECK-LABEL: @test26(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.objectsize.i32.p1i8(i8 addrspace(1)* null, i1 false, i1 true, i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = call i32 @llvm.objectsize.i32.p1i8(i8 addrspace(1)* null, i1 false,
  i1 true, i1 false)
  ret i32 %1
}

define i32 @test27() {
; CHECK-LABEL: @test27(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.objectsize.i32.p1i8(i8 addrspace(1)* null, i1 true, i1 true, i1 false)
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %1 = call i32 @llvm.objectsize.i32.p1i8(i8 addrspace(1)* null, i1 true,
  i1 true, i1 false)
  ret i32 %1
}
