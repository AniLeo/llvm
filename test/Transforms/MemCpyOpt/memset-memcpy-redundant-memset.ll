; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -basic-aa -memcpyopt -S %s -enable-memcpyopt-memoryssa=0 | FileCheck %s
; RUN: opt -basic-aa -memcpyopt -S %s -enable-memcpyopt-memoryssa=1 -verify-memoryssa | FileCheck %s

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

define void @test(i8* %src, i64 %src_size, i8* noalias %dst, i64 %dst_size, i8 %c) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i64 [[DST_SIZE:%.*]], [[SRC_SIZE:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 [[DST_SIZE]], [[SRC_SIZE]]
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i64 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* [[DST:%.*]], i64 [[SRC_SIZE]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP4]], i8 [[C:%.*]], i64 [[TMP3]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST]], i8* [[SRC:%.*]], i64 [[SRC_SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 %c, i64 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 %src_size, i1 false)
  ret void
}

define void @test_different_types_i32_i64(i8* noalias %dst, i8* %src, i32 %dst_size, i64 %src_size, i8 %c) {
; CHECK-LABEL: @test_different_types_i32_i64(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[DST_SIZE:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ule i64 [[TMP1]], [[SRC_SIZE:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = sub i64 [[TMP1]], [[SRC_SIZE]]
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP2]], i64 0, i64 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[DST:%.*]], i64 [[SRC_SIZE]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP5]], i8 [[C:%.*]], i64 [[TMP4]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST]], i8* [[SRC:%.*]], i64 [[SRC_SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i32(i8* %dst, i8 %c, i32 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 %src_size, i1 false)
  ret void
}

define void @test_different_types_i128_i32(i8* noalias %dst, i8* %src, i128 %dst_size, i32 %src_size, i8 %c) {
; CHECK-LABEL: @test_different_types_i128_i32(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[SRC_SIZE:%.*]] to i128
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ule i128 [[DST_SIZE:%.*]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = sub i128 [[DST_SIZE]], [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP2]], i128 0, i128 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[DST:%.*]], i128 [[TMP1]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i128(i8* align 1 [[TMP5]], i8 [[C:%.*]], i128 [[TMP4]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* [[DST]], i8* [[SRC:%.*]], i32 [[SRC_SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i128(i8* %dst, i8 %c, i128 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %dst, i8* %src, i32 %src_size, i1 false)
  ret void
}

define void @test_different_types_i32_i128(i8* noalias %dst, i8* %src, i32 %dst_size, i128 %src_size, i8 %c) {
; CHECK-LABEL: @test_different_types_i32_i128(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[DST_SIZE:%.*]] to i128
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ule i128 [[TMP1]], [[SRC_SIZE:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = sub i128 [[TMP1]], [[SRC_SIZE]]
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP2]], i128 0, i128 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[DST:%.*]], i128 [[SRC_SIZE]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i128(i8* align 1 [[TMP5]], i8 [[C:%.*]], i128 [[TMP4]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i128(i8* [[DST]], i8* [[SRC:%.*]], i128 [[SRC_SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i32(i8* %dst, i8 %c, i32 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i128(i8* %dst, i8* %src, i128 %src_size, i1 false)
  ret void
}

define void @test_different_types_i64_i32(i8* noalias %dst, i8* %src, i64 %dst_size, i32 %src_size, i8 %c) {
; CHECK-LABEL: @test_different_types_i64_i32(
; CHECK-NEXT:    [[TMP1:%.*]] = zext i32 [[SRC_SIZE:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ule i64 [[DST_SIZE:%.*]], [[TMP1]]
; CHECK-NEXT:    [[TMP3:%.*]] = sub i64 [[DST_SIZE]], [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP2]], i64 0, i64 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i8, i8* [[DST:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP5]], i8 [[C:%.*]], i64 [[TMP4]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* [[DST]], i8* [[SRC:%.*]], i32 [[SRC_SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 %c, i64 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* %dst, i8* %src, i32 %src_size, i1 false)
  ret void
}

define void @test_align_same(i8* %src, i8* noalias %dst, i64 %dst_size) {
; CHECK-LABEL: @test_align_same(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i64 [[DST_SIZE:%.*]], 80
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 [[DST_SIZE]], 80
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i64 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* [[DST:%.*]], i64 80
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[TMP4]], i8 0, i64 [[TMP3]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST]], i8* [[SRC:%.*]], i64 80, i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* align 8 %dst, i8 0, i64 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 80, i1 false)
  ret void
}

define void @test_align_min(i8* %src, i8* noalias %dst, i64 %dst_size) {
; CHECK-LABEL: @test_align_min(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i64 [[DST_SIZE:%.*]], 36
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 [[DST_SIZE]], 36
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i64 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* [[DST:%.*]], i64 36
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[TMP4]], i8 0, i64 [[TMP3]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST]], i8* [[SRC:%.*]], i64 36, i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* align 8 %dst, i8 0, i64 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 36, i1 false)
  ret void
}

define void @test_align_memcpy(i8* %src, i8* noalias %dst, i64 %dst_size) {
; CHECK-LABEL: @test_align_memcpy(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i64 [[DST_SIZE:%.*]], 80
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 [[DST_SIZE]], 80
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i64 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* [[DST:%.*]], i64 80
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[TMP4]], i8 0, i64 [[TMP3]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 [[DST]], i8* align 8 [[SRC:%.*]], i64 80, i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 0, i64 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 8 %dst, i8* align 8 %src, i64 80, i1 false)
  ret void
}

define void @test_non_i8_dst_type(i8* %src, i64 %src_size, i64* noalias %dst_pi64, i64 %dst_size, i8 %c) {
; CHECK-LABEL: @test_non_i8_dst_type(
; CHECK-NEXT:    [[DST:%.*]] = bitcast i64* [[DST_PI64:%.*]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i64 [[DST_SIZE:%.*]], [[SRC_SIZE:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 [[DST_SIZE]], [[SRC_SIZE]]
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i64 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* [[DST]], i64 [[SRC_SIZE]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP4]], i8 [[C:%.*]], i64 [[TMP3]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST]], i8* [[SRC:%.*]], i64 [[SRC_SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  %dst = bitcast i64* %dst_pi64 to i8*
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 %c, i64 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 %src_size, i1 false)
  ret void
}

define void @test_different_dst(i8* noalias %dst2, i8* %src, i64 %src_size, i8* noalias %dst, i64 %dst_size) {
; CHECK-LABEL: @test_different_dst(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[DST:%.*]], i8 0, i64 [[DST_SIZE:%.*]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST2:%.*]], i8* [[SRC:%.*]], i64 [[SRC_SIZE:%.*]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 0, i64 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst2, i8* %src, i64 %src_size, i1 false)
  ret void
}

; Make sure we also take into account dependencies on the destination.

define i8 @test_intermediate_read(i8* noalias %a, i8* %b) #0 {
; CHECK-LABEL: @test_intermediate_read(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[A:%.*]], i8 0, i64 64, i1 false)
; CHECK-NEXT:    [[R:%.*]] = load i8, i8* [[A]], align 1
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[A]], i8* [[B:%.*]], i64 24, i1 false)
; CHECK-NEXT:    ret i8 [[R]]
;
  call void @llvm.memset.p0i8.i64(i8* %a, i8 0, i64 64, i1 false)
  %r = load i8, i8* %a
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %a, i8* %b, i64 24, i1 false)
  ret i8 %r
}

%struct = type { [8 x i8], [8 x i8] }

define void @test_intermediate_write(i8* %b) #0 {
; CHECK-LABEL: @test_intermediate_write(
; CHECK-NEXT:    [[A:%.*]] = alloca [[STRUCT:%.*]], align 8
; CHECK-NEXT:    [[A0:%.*]] = getelementptr [[STRUCT]], %struct* [[A]], i32 0, i32 0, i32 0
; CHECK-NEXT:    [[A1:%.*]] = getelementptr [[STRUCT]], %struct* [[A]], i32 0, i32 1, i32 0
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[A0]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    store i8 1, i8* [[A1]], align 1
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[A0]], i8* [[B:%.*]], i64 8, i1 false)
; CHECK-NEXT:    ret void
;
  %a = alloca %struct
  %a0 = getelementptr %struct, %struct* %a, i32 0, i32 0, i32 0
  %a1 = getelementptr %struct, %struct* %a, i32 0, i32 1, i32 0
  call void @llvm.memset.p0i8.i64(i8* %a0, i8 0, i64 16, i1 false)
  store i8 1, i8* %a1
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %a0, i8* %b, i64 8, i1 false)
  ret void
}

define void @test_throwing_call(i8* %src, i64 %src_size, i8* noalias %dst, i64 %dst_size, i8 %c) {
; CHECK-LABEL: @test_throwing_call(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[DST:%.*]], i8 [[C:%.*]], i64 [[DST_SIZE:%.*]], i1 false)
; CHECK-NEXT:    call void @call() #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST]], i8* [[SRC:%.*]], i64 [[SRC_SIZE:%.*]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 %c, i64 %dst_size, i1 false)
  call void @call() readnone
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 %src_size, i1 false)
  ret void
}

define void @test_throwing_call_alloca(i8* %src, i64 %src_size, i64 %dst_size, i8 %c) {
; CHECK-LABEL: @test_throwing_call_alloca(
; CHECK-NEXT:    [[DST:%.*]] = alloca i8, align 1
; CHECK-NEXT:    call void @call() #[[ATTR2]]
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i64 [[DST_SIZE:%.*]], [[SRC_SIZE:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 [[DST_SIZE]], [[SRC_SIZE]]
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i64 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* [[DST]], i64 [[SRC_SIZE]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP4]], i8 [[C:%.*]], i64 [[TMP3]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST]], i8* [[SRC:%.*]], i64 [[SRC_SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  %dst = alloca i8
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 %c, i64 %dst_size, i1 false)
  call void @call() readnone
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 %src_size, i1 false)
  ret void
}

; %dst and %src in the memcpy may be equal, in which case shorting the memset
; is not legal.
define void @test_missing_noalias(i8* %src, i64 %src_size, i8* %dst, i64 %dst_size, i8 %c) {
; CHECK-LABEL: @test_missing_noalias(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[DST:%.*]], i8 [[C:%.*]], i64 [[DST_SIZE:%.*]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST]], i8* [[SRC:%.*]], i64 [[SRC_SIZE:%.*]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 %c, i64 %dst_size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 %src_size, i1 false)
  ret void
}

define void @test_same_const_size(i8* noalias %src, i8* noalias %dst, i8 %c) {
; CHECK-LABEL: @test_same_const_size(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST:%.*]], i8* [[SRC:%.*]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 %c, i64 16, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 16, i1 false)
  ret void
}

define void @test_same_dynamic_size(i8* noalias %src, i8* noalias %dst, i64 %size, i8 %c) {
; CHECK-LABEL: @test_same_dynamic_size(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST:%.*]], i8* [[SRC:%.*]], i64 [[SIZE:%.*]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0i8.i64(i8* %dst, i8 %c, i64 %size, i1 false)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 %size, i1 false)
  ret void
}

; Destinations must alias, but are not trivially equal.
define void @test_must_alias_same_size(i8* noalias %src, i8* noalias %dst, i8 %c) {
; CHECK-LABEL: @test_must_alias_same_size(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i8, i8* [[DST:%.*]], i64 16
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i8, i8* [[DST]], i64 16
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[GEP2]], i8* [[SRC:%.*]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %gep1 = getelementptr i8, i8* %dst, i64 16
  call void @llvm.memset.p0i8.i64(i8* %gep1, i8 %c, i64 16, i1 false)
  %gep2 = getelementptr i8, i8* %dst, i64 16
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %gep2, i8* %src, i64 16, i1 false)
  ret void
}

define void @test_must_alias_different_size(i8* noalias %src, i64 %src_size, i8* noalias %dst, i64 %dst_size, i8 %c) {
; CHECK-LABEL: @test_must_alias_different_size(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i8, i8* [[DST:%.*]], i64 16
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i8, i8* [[DST]], i64 16
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i64 [[DST_SIZE:%.*]], [[SRC_SIZE:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 [[DST_SIZE]], [[SRC_SIZE]]
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i64 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, i8* [[GEP2]], i64 [[SRC_SIZE]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[TMP4]], i8 [[C:%.*]], i64 [[TMP3]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[GEP2]], i8* [[SRC:%.*]], i64 [[SRC_SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  %gep1 = getelementptr i8, i8* %dst, i64 16
  call void @llvm.memset.p0i8.i64(i8* %gep1, i8 %c, i64 %dst_size, i1 false)
  %gep2 = getelementptr i8, i8* %dst, i64 16
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %gep2, i8* %src, i64 %src_size, i1 false)
  ret void
}

define void @test_opaque_ptrs(ptr %src, i64 %src_size, ptr noalias %dst, i64 %dst_size, i8 %c) {
; CHECK-LABEL: @test_opaque_ptrs(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ule i64 [[DST_SIZE:%.*]], [[SRC_SIZE:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = sub i64 [[DST_SIZE]], [[SRC_SIZE]]
; CHECK-NEXT:    [[TMP3:%.*]] = select i1 [[TMP1]], i64 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr i8, ptr [[DST:%.*]], i64 [[SRC_SIZE]]
; CHECK-NEXT:    call void @llvm.memset.p0.i64(ptr align 1 [[TMP4]], i8 [[C:%.*]], i64 [[TMP3]], i1 false)
; CHECK-NEXT:    call void @llvm.memcpy.p0.p0.i64(ptr [[DST]], ptr [[SRC:%.*]], i64 [[SRC_SIZE]], i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.memset.p0.i64(ptr %dst, i8 %c, i64 %dst_size, i1 false)
  call void @llvm.memcpy.p0.p0.i64(ptr %dst, ptr %src, i64 %src_size, i1 false)
  ret void
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i1)
declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i1)
declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture readonly, i32, i1)
declare void @llvm.memset.p0i8.i128(i8* nocapture, i8, i128, i1)
declare void @llvm.memcpy.p0i8.p0i8.i128(i8* nocapture, i8* nocapture readonly, i128, i1)
declare void @llvm.memset.p0.i64(ptr nocapture, i8, i64, i1)
declare void @llvm.memcpy.p0.p0.i64(ptr nocapture, ptr nocapture readonly, i64, i1)
declare void @call()
