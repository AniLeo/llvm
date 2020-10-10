; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -aa-pipeline=basic-aa -passes='require<memoryssa>,memcpyopt' -verify-memoryssa -S %s | FileCheck %s

; REQUIRES: asserts

target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.15.0"

%t = type <{ i8*, [4 x i8], i8*, i8*, i32, [8192 x i8] }>


define i32 @test1(%t* %ptr) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  invoke.cont6:
; CHECK-NEXT:    [[P_1:%.*]] = getelementptr inbounds [[T:%.*]], %t* [[PTR:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[P_1_C:%.*]] = bitcast i8** [[P_1]] to i8*
; CHECK-NEXT:    [[P_2:%.*]] = getelementptr inbounds [[T]], %t* [[PTR]], i64 0, i32 4
; CHECK-NEXT:    [[P_3:%.*]] = getelementptr inbounds [[T]], %t* [[PTR]], i64 0, i32 5, i64 0
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i8** [[P_1]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[TMP0]], i8 0, i64 20, i1 false)
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i32* [[P_2]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[TMP1]], i8 0, i64 8195, i1 false)
; CHECK-NEXT:    ret i32 0
;
invoke.cont6:
  %p.1 = getelementptr inbounds %t, %t* %ptr, i64 0, i32 0
  %p.1.c = bitcast i8** %p.1 to i8*
  call void @llvm.memset.p0i8.i64(i8* %p.1.c, i8 0, i64 20, i1 false)
  store i8* null, i8** %p.1, align 8
  %p.2 = getelementptr inbounds %t, %t* %ptr, i64 0, i32 4
  store i32 0, i32* %p.2, align 8
  %p.3 = getelementptr inbounds %t, %t* %ptr, i64 0, i32 5, i64 0
  call void @llvm.memset.p0i8.i64(i8* %p.3, i8 0, i64 8191, i1 false)
  ret i32 0
}

declare i8* @get_ptr()

define void @test2(i8* noalias %in) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL_I1_I:%.*]] = tail call i8* @get_ptr()
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr i8, i8* [[CALL_I1_I]], i64 10
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP0]], i8 0, i64 0, i1 false)
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[CALL_I1_I]], i8* [[IN:%.*]], i64 10, i1 false)
; CHECK-NEXT:    ret void
;
entry:
  %call.i1.i = tail call i8* @get_ptr()
  tail call void @llvm.memset.p0i8.i64(i8* %call.i1.i, i8 0, i64 10, i1 false)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %call.i1.i, i8* %in, i64 10, i1 false)
  ret void
}

declare i8* @malloc(i64)

define i32 @test3(i8* noalias %in) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[CALL_I_I_I:%.*]] = tail call i8* @malloc(i64 20)
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[CALL_I_I_I]], i8* [[IN:%.*]], i64 20, i1 false)
; CHECK-NEXT:    ret i32 10
;
  %call.i.i.i = tail call i8* @malloc(i64 20)
  tail call void @llvm.memmove.p0i8.p0i8.i64(i8* %call.i.i.i, i8* %in, i64 20, i1 false)
  ret i32 10
}

define void @test4(i32 %n, i8* noalias %ptr.0, i8* noalias %ptr.1, i32* %ptr.2) unnamed_addr {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[ELEM_I:%.*]] = getelementptr i8, i8* [[PTR_0:%.*]], i64 8
; CHECK-NEXT:    store i32 [[N:%.*]], i32* [[PTR_2:%.*]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr i8, i8* [[ELEM_I]], i64 10
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP1]], i8 0, i64 0, i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[ELEM_I]], i8* [[PTR_1:%.*]], i64 10, i1 false)
; CHECK-NEXT:    ret void
;
  %elem.i = getelementptr i8, i8* %ptr.0, i64 8
  call void @llvm.memset.p0i8.i64(i8* %elem.i, i8 0, i64 10, i1 false)
  store i32 %n, i32* %ptr.2, align 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %elem.i, i8* %ptr.1, i64 10, i1 false)
  ret void
}

declare void @decompose(%t* nocapture)

define void @test5(i32* %ptr) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[EARLY_DATA:%.*]] = alloca [128 x i8], align 8
; CHECK-NEXT:    [[TMP:%.*]] = alloca [[T:%.*]], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast [128 x i8]* [[EARLY_DATA]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast %t* [[TMP]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 32, i8* [[TMP0]])
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[PTR:%.*]], align 8
; CHECK-NEXT:    call fastcc void @decompose(%t* [[TMP]])
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[TMP0]], i8* [[TMP1]], i64 32, i1 false)
; CHECK-NEXT:    ret void
;
entry:
  %early_data = alloca [128 x i8], align 8
  %tmp = alloca %t, align 8
  %0 = bitcast [128 x i8]* %early_data to i8*
  %1 = bitcast %t* %tmp to i8*
  call void @llvm.lifetime.start.p0i8(i64 32, i8* %0)
  %2 = load i32, i32* %ptr, align 8
  call fastcc void @decompose(%t* %tmp)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %0, i8* %1, i64 32, i1 false)
  ret void
}

define i8 @test6(i8* %ptr, i8* noalias %ptr.1) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 24, i8* [[PTR:%.*]])
; CHECK-NEXT:    [[TMP0:%.*]] = load i8, i8* [[PTR]], align 8
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[PTR]], i8* [[PTR_1:%.*]], i64 24, i1 false)
; CHECK-NEXT:    ret i8 [[TMP0]]
;
entry:
  call void @llvm.lifetime.start.p0i8(i64 24, i8* %ptr)
  %0 = load i8, i8* %ptr, align 8
  call void @llvm.memmove.p0i8.p0i8.i64(i8* %ptr, i8* %ptr.1, i64 24, i1 false)
  ret i8 %0
}

define void @test7([4 x i32]* %ptr) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds [4 x i32], [4 x i32]* [[PTR:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [4 x i32], [4 x i32]* [[PTR]], i64 0, i32 1
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [4 x i32], [4 x i32]* [[PTR]], i64 0, i32 2
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [4 x i32], [4 x i32]* [[PTR]], i64 0, i32 3
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast i32* [[TMP0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP4]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    call void @clobber()
; CHECK-NEXT:    ret void
;
entry:
  %0 = getelementptr inbounds [4 x i32], [4 x i32]* %ptr, i64 0, i32 0
  store i32 0, i32* %0, align 1
  %1 = getelementptr inbounds [4 x i32], [4 x i32]* %ptr, i64 0, i32 1
  store i32 0, i32* %1, align 1
  %2 = getelementptr inbounds [4 x i32], [4 x i32]* %ptr, i64 0, i32 2
  store i32 0, i32* %2, align 1
  %3 = getelementptr inbounds [4 x i32], [4 x i32]* %ptr, i64 0, i32 3
  store i32 0, i32* %3, align 1
  call void @clobber()
  ret void
}

declare void @clobber()

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #0

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #0

; Function Attrs: argmemonly nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

; Function Attrs: argmemonly nounwind willreturn
declare void @llvm.memmove.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i1 immarg) #0

attributes #0 = { argmemonly nounwind willreturn }
attributes #1 = { argmemonly nounwind willreturn writeonly }
