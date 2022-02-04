; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine -S < %s | FileCheck %s

target datalayout = "e-i64:64-f80:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%A__vtbl = type { i8*, i32 (%A*)* }
%A = type { %A__vtbl* }
%B = type { i8*, i64 }

@A__vtblZ = constant %A__vtbl { i8* null, i32 (%A*)* @A.foo }

declare i32 @A.foo(%A* nocapture %this)

define void @storeA(%A* %a.ptr) {
; CHECK-LABEL: @storeA(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [[A:%.*]], %A* [[A_PTR:%.*]], i64 0, i32 0
; CHECK-NEXT:    store %A__vtbl* @A__vtblZ, %A__vtbl** [[TMP1]], align 8
; CHECK-NEXT:    ret void
;
  store %A { %A__vtbl* @A__vtblZ }, %A* %a.ptr, align 8
  ret void
}

define void @storeB(%B* %b.ptr) {
; CHECK-LABEL: @storeB(
; CHECK-NEXT:    [[B_PTR_REPACK:%.*]] = getelementptr inbounds [[B:%.*]], %B* [[B_PTR:%.*]], i64 0, i32 0
; CHECK-NEXT:    store i8* null, i8** [[B_PTR_REPACK]], align 8
; CHECK-NEXT:    [[B_PTR_REPACK1:%.*]] = getelementptr inbounds [[B]], %B* [[B_PTR]], i64 0, i32 1
; CHECK-NEXT:    store i64 42, i64* [[B_PTR_REPACK1]], align 8
; CHECK-NEXT:    ret void
;
  store %B { i8* null, i64 42 }, %B* %b.ptr, align 8
  ret void
}

define void @storeStructOfA({ %A }* %sa.ptr) {
; CHECK-LABEL: @storeStructOfA(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr { [[A:%.*]] }, { [[A]] }* [[SA_PTR:%.*]], i64 0, i32 0, i32 0
; CHECK-NEXT:    store %A__vtbl* @A__vtblZ, %A__vtbl** [[TMP1]], align 8
; CHECK-NEXT:    ret void
;
  store { %A } { %A { %A__vtbl* @A__vtblZ } }, { %A }* %sa.ptr, align 8
  ret void
}

define void @storeArrayOfA([1 x %A]* %aa.ptr) {
; CHECK-LABEL: @storeArrayOfA(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [1 x %A], [1 x %A]* [[AA_PTR:%.*]], i64 0, i64 0, i32 0
; CHECK-NEXT:    store %A__vtbl* @A__vtblZ, %A__vtbl** [[TMP1]], align 8
; CHECK-NEXT:    ret void
;
  store [1 x %A] [%A { %A__vtbl* @A__vtblZ }], [1 x %A]* %aa.ptr, align 8
  ret void
}

; UTC_ARGS: --disable
define void @storeLargeArrayOfA([2000 x %A]* %aa.ptr) {
; CHECK-LABEL: @storeLargeArrayOfA(
; CHECK-NEXT:    store [2000 x %A]
; CHECK-NEXT:    ret void
;
  %i1 = insertvalue [2000 x %A] undef, %A { %A__vtbl* @A__vtblZ }, 1
  store [2000 x %A] %i1, [2000 x %A]* %aa.ptr, align 8
  ret void
}
; UTC_ARGS: --enable

define void @storeStructOfArrayOfA({ [1 x %A] }* %saa.ptr) {
; CHECK-LABEL: @storeStructOfArrayOfA(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr { [1 x %A] }, { [1 x %A] }* [[SAA_PTR:%.*]], i64 0, i32 0, i64 0, i32 0
; CHECK-NEXT:    store %A__vtbl* @A__vtblZ, %A__vtbl** [[TMP1]], align 8
; CHECK-NEXT:    ret void
;
  store { [1 x %A] } { [1 x %A] [%A { %A__vtbl* @A__vtblZ }] }, { [1 x %A] }* %saa.ptr, align 8
  ret void
}

define void @storeArrayOfB([2 x %B]* %ab.ptr, [2 x %B] %ab) {
; CHECK-LABEL: @storeArrayOfB(
; CHECK-NEXT:    [[AB_ELT:%.*]] = extractvalue [2 x %B] [[AB:%.*]], 0
; CHECK-NEXT:    [[AB_PTR_REPACK_REPACK:%.*]] = getelementptr inbounds [2 x %B], [2 x %B]* [[AB_PTR:%.*]], i64 0, i64 0, i32 0
; CHECK-NEXT:    [[AB_ELT_ELT:%.*]] = extractvalue [[B:%.*]] [[AB_ELT]], 0
; CHECK-NEXT:    store i8* [[AB_ELT_ELT]], i8** [[AB_PTR_REPACK_REPACK]], align 8
; CHECK-NEXT:    [[AB_PTR_REPACK_REPACK3:%.*]] = getelementptr inbounds [2 x %B], [2 x %B]* [[AB_PTR]], i64 0, i64 0, i32 1
; CHECK-NEXT:    [[AB_ELT_ELT4:%.*]] = extractvalue [[B]] [[AB_ELT]], 1
; CHECK-NEXT:    store i64 [[AB_ELT_ELT4]], i64* [[AB_PTR_REPACK_REPACK3]], align 8
; CHECK-NEXT:    [[AB_ELT2:%.*]] = extractvalue [2 x %B] [[AB]], 1
; CHECK-NEXT:    [[AB_PTR_REPACK1_REPACK:%.*]] = getelementptr inbounds [2 x %B], [2 x %B]* [[AB_PTR]], i64 0, i64 1, i32 0
; CHECK-NEXT:    [[AB_ELT2_ELT:%.*]] = extractvalue [[B]] [[AB_ELT2]], 0
; CHECK-NEXT:    store i8* [[AB_ELT2_ELT]], i8** [[AB_PTR_REPACK1_REPACK]], align 8
; CHECK-NEXT:    [[AB_PTR_REPACK1_REPACK5:%.*]] = getelementptr inbounds [2 x %B], [2 x %B]* [[AB_PTR]], i64 0, i64 1, i32 1
; CHECK-NEXT:    [[AB_ELT2_ELT6:%.*]] = extractvalue [[B]] [[AB_ELT2]], 1
; CHECK-NEXT:    store i64 [[AB_ELT2_ELT6]], i64* [[AB_PTR_REPACK1_REPACK5]], align 8
; CHECK-NEXT:    ret void
;
  store [2 x %B] %ab, [2 x %B]* %ab.ptr, align 8
  ret void
}

define %A @loadA(%A* %a.ptr) {
; CHECK-LABEL: @loadA(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [[A:%.*]], %A* [[A_PTR:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[DOTUNPACK:%.*]] = load %A__vtbl*, %A__vtbl** [[TMP1]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue [[A]] undef, %A__vtbl* [[DOTUNPACK]], 0
; CHECK-NEXT:    ret [[A]] [[TMP2]]
;
  %1 = load %A, %A* %a.ptr, align 8
  ret %A %1
}

define %B @loadB(%B* %b.ptr) {
; CHECK-LABEL: @loadB(
; CHECK-NEXT:    [[DOTELT:%.*]] = getelementptr inbounds [[B:%.*]], %B* [[B_PTR:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[DOTUNPACK:%.*]] = load i8*, i8** [[DOTELT]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue [[B]] undef, i8* [[DOTUNPACK]], 0
; CHECK-NEXT:    [[DOTELT1:%.*]] = getelementptr inbounds [[B]], %B* [[B_PTR]], i64 0, i32 1
; CHECK-NEXT:    [[DOTUNPACK2:%.*]] = load i64, i64* [[DOTELT1]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue [[B]] [[TMP1]], i64 [[DOTUNPACK2]], 1
; CHECK-NEXT:    ret [[B]] [[TMP2]]
;
  %1 = load %B, %B* %b.ptr, align 8
  ret %B %1
}

define { %A } @loadStructOfA({ %A }* %sa.ptr) {
; CHECK-LABEL: @loadStructOfA(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr { [[A:%.*]] }, { [[A]] }* [[SA_PTR:%.*]], i64 0, i32 0, i32 0
; CHECK-NEXT:    [[DOTUNPACK_UNPACK:%.*]] = load %A__vtbl*, %A__vtbl** [[TMP1]], align 8
; CHECK-NEXT:    [[DOTUNPACK1:%.*]] = insertvalue [[A]] undef, %A__vtbl* [[DOTUNPACK_UNPACK]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue { [[A]] } undef, [[A]] [[DOTUNPACK1]], 0
; CHECK-NEXT:    ret { [[A]] } [[TMP2]]
;
  %1 = load { %A }, { %A }* %sa.ptr, align 8
  ret { %A } %1
}

define [1 x %A] @loadArrayOfA([1 x %A]* %aa.ptr) {
; CHECK-LABEL: @loadArrayOfA(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr [1 x %A], [1 x %A]* [[AA_PTR:%.*]], i64 0, i64 0, i32 0
; CHECK-NEXT:    [[DOTUNPACK_UNPACK:%.*]] = load %A__vtbl*, %A__vtbl** [[TMP1]], align 8
; CHECK-NEXT:    [[DOTUNPACK1:%.*]] = insertvalue [[A:%.*]] undef, %A__vtbl* [[DOTUNPACK_UNPACK]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue [1 x %A] undef, [[A]] [[DOTUNPACK1]], 0
; CHECK-NEXT:    ret [1 x %A] [[TMP2]]
;
  %1 = load [1 x %A], [1 x %A]* %aa.ptr, align 8
  ret [1 x %A] %1
}

define { [1 x %A] } @loadStructOfArrayOfA({ [1 x %A] }* %saa.ptr) {
; CHECK-LABEL: @loadStructOfArrayOfA(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr { [1 x %A] }, { [1 x %A] }* [[SAA_PTR:%.*]], i64 0, i32 0, i64 0, i32 0
; CHECK-NEXT:    [[DOTUNPACK_UNPACK_UNPACK:%.*]] = load %A__vtbl*, %A__vtbl** [[TMP1]], align 8
; CHECK-NEXT:    [[DOTUNPACK_UNPACK2:%.*]] = insertvalue [[A:%.*]] undef, %A__vtbl* [[DOTUNPACK_UNPACK_UNPACK]], 0
; CHECK-NEXT:    [[DOTUNPACK1:%.*]] = insertvalue [1 x %A] undef, [[A]] [[DOTUNPACK_UNPACK2]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue { [1 x %A] } undef, [1 x %A] [[DOTUNPACK1]], 0
; CHECK-NEXT:    ret { [1 x %A] } [[TMP2]]
;
  %1 = load { [1 x %A] }, { [1 x %A] }* %saa.ptr, align 8
  ret { [1 x %A] } %1
}

define { %A } @structOfA({ %A }* %sa.ptr) {
; CHECK-LABEL: @structOfA(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr { [[A:%.*]] }, { [[A]] }* [[SA_PTR:%.*]], i64 0, i32 0, i32 0
; CHECK-NEXT:    store %A__vtbl* @A__vtblZ, %A__vtbl** [[TMP1]], align 8
; CHECK-NEXT:    ret { [[A]] } { [[A]] { %A__vtbl* @A__vtblZ } }
;
  store { %A } { %A { %A__vtbl* @A__vtblZ } }, { %A }* %sa.ptr, align 8
  %1 = load { %A }, { %A }* %sa.ptr, align 8
  ret { %A } %1
}

define %B @structB(%B* %b.ptr) {
; CHECK-LABEL: @structB(
; CHECK-NEXT:    [[B_PTR_REPACK:%.*]] = getelementptr inbounds [[B:%.*]], %B* [[B_PTR:%.*]], i64 0, i32 0
; CHECK-NEXT:    store i8* null, i8** [[B_PTR_REPACK]], align 8
; CHECK-NEXT:    [[B_PTR_REPACK1:%.*]] = getelementptr inbounds [[B]], %B* [[B_PTR]], i64 0, i32 1
; CHECK-NEXT:    store i64 42, i64* [[B_PTR_REPACK1]], align 8
; CHECK-NEXT:    ret [[B]] { i8* null, i64 42 }
;
  store %B { i8* null, i64 42 }, %B* %b.ptr, align 8
  %1 = load %B, %B* %b.ptr, align 8
  ret %B %1
}

define [2 x %B] @loadArrayOfB([2 x %B]* %ab.ptr) {
; CHECK-LABEL: @loadArrayOfB(
; CHECK-NEXT:    [[DOTUNPACK_ELT:%.*]] = getelementptr inbounds [2 x %B], [2 x %B]* [[AB_PTR:%.*]], i64 0, i64 0, i32 0
; CHECK-NEXT:    [[DOTUNPACK_UNPACK:%.*]] = load i8*, i8** [[DOTUNPACK_ELT]], align 8
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue [[B:%.*]] undef, i8* [[DOTUNPACK_UNPACK]], 0
; CHECK-NEXT:    [[DOTUNPACK_ELT3:%.*]] = getelementptr inbounds [2 x %B], [2 x %B]* [[AB_PTR]], i64 0, i64 0, i32 1
; CHECK-NEXT:    [[DOTUNPACK_UNPACK4:%.*]] = load i64, i64* [[DOTUNPACK_ELT3]], align 8
; CHECK-NEXT:    [[DOTUNPACK5:%.*]] = insertvalue [[B]] [[TMP1]], i64 [[DOTUNPACK_UNPACK4]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = insertvalue [2 x %B] undef, [[B]] [[DOTUNPACK5]], 0
; CHECK-NEXT:    [[DOTUNPACK2_ELT:%.*]] = getelementptr inbounds [2 x %B], [2 x %B]* [[AB_PTR]], i64 0, i64 1, i32 0
; CHECK-NEXT:    [[DOTUNPACK2_UNPACK:%.*]] = load i8*, i8** [[DOTUNPACK2_ELT]], align 8
; CHECK-NEXT:    [[TMP3:%.*]] = insertvalue [[B]] undef, i8* [[DOTUNPACK2_UNPACK]], 0
; CHECK-NEXT:    [[DOTUNPACK2_ELT6:%.*]] = getelementptr inbounds [2 x %B], [2 x %B]* [[AB_PTR]], i64 0, i64 1, i32 1
; CHECK-NEXT:    [[DOTUNPACK2_UNPACK7:%.*]] = load i64, i64* [[DOTUNPACK2_ELT6]], align 8
; CHECK-NEXT:    [[DOTUNPACK28:%.*]] = insertvalue [[B]] [[TMP3]], i64 [[DOTUNPACK2_UNPACK7]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = insertvalue [2 x %B] [[TMP2]], [[B]] [[DOTUNPACK28]], 1
; CHECK-NEXT:    ret [2 x %B] [[TMP4]]
;
  %1 = load [2 x %B], [2 x %B]* %ab.ptr, align 8
  ret [2 x %B] %1
}

define [2000 x %B] @loadLargeArrayOfB([2000 x %B]* %ab.ptr) {
; CHECK-LABEL: @loadLargeArrayOfB(
; CHECK-NEXT:    [[TMP1:%.*]] = load [2000 x %B], [2000 x %B]* [[AB_PTR:%.*]], align 8
; CHECK-NEXT:    ret [2000 x %B] [[TMP1]]
;
  %1 = load [2000 x %B], [2000 x %B]* %ab.ptr, align 8
  ret [2000 x %B] %1
}

%struct.S = type <{ i8, %struct.T }>
%struct.T = type { i32, i32 }

; Make sure that we do not increase alignment of packed struct element
define i32 @packed_alignment(%struct.S* dereferenceable(9) %s) {
; CHECK-LABEL: @packed_alignment(
; CHECK-NEXT:    [[TV_ELT1:%.*]] = getelementptr inbounds [[STRUCT_S:%.*]], %struct.S* [[S:%.*]], i64 0, i32 1, i32 1
; CHECK-NEXT:    [[TV_UNPACK2:%.*]] = load i32, i32* [[TV_ELT1]], align 1
; CHECK-NEXT:    ret i32 [[TV_UNPACK2]]
;
  %t = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 1
  %tv = load %struct.T, %struct.T* %t, align 1
  %v = extractvalue %struct.T %tv, 1
  ret i32 %v
}

%struct.U = type {i8, i8, i8, i8, i8, i8, i8, i8, i64}

define void @check_alignment(%struct.U* %u, %struct.U* %v) {
; CHECK-LABEL: @check_alignment(
; CHECK-NEXT:    [[DOTELT:%.*]] = getelementptr inbounds [[STRUCT_U:%.*]], %struct.U* [[U:%.*]], i64 0, i32 0
; CHECK-NEXT:    [[DOTUNPACK:%.*]] = load i8, i8* [[DOTELT]], align 8
; CHECK-NEXT:    [[DOTELT1:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[U]], i64 0, i32 1
; CHECK-NEXT:    [[DOTUNPACK2:%.*]] = load i8, i8* [[DOTELT1]], align 1
; CHECK-NEXT:    [[DOTELT3:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[U]], i64 0, i32 2
; CHECK-NEXT:    [[DOTUNPACK4:%.*]] = load i8, i8* [[DOTELT3]], align 2
; CHECK-NEXT:    [[DOTELT5:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[U]], i64 0, i32 3
; CHECK-NEXT:    [[DOTUNPACK6:%.*]] = load i8, i8* [[DOTELT5]], align 1
; CHECK-NEXT:    [[DOTELT7:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[U]], i64 0, i32 4
; CHECK-NEXT:    [[DOTUNPACK8:%.*]] = load i8, i8* [[DOTELT7]], align 4
; CHECK-NEXT:    [[DOTELT9:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[U]], i64 0, i32 5
; CHECK-NEXT:    [[DOTUNPACK10:%.*]] = load i8, i8* [[DOTELT9]], align 1
; CHECK-NEXT:    [[DOTELT11:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[U]], i64 0, i32 6
; CHECK-NEXT:    [[DOTUNPACK12:%.*]] = load i8, i8* [[DOTELT11]], align 2
; CHECK-NEXT:    [[DOTELT13:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[U]], i64 0, i32 7
; CHECK-NEXT:    [[DOTUNPACK14:%.*]] = load i8, i8* [[DOTELT13]], align 1
; CHECK-NEXT:    [[DOTELT15:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[U]], i64 0, i32 8
; CHECK-NEXT:    [[DOTUNPACK16:%.*]] = load i64, i64* [[DOTELT15]], align 8
; CHECK-NEXT:    [[V_REPACK:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[V:%.*]], i64 0, i32 0
; CHECK-NEXT:    store i8 [[DOTUNPACK]], i8* [[V_REPACK]], align 8
; CHECK-NEXT:    [[V_REPACK18:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[V]], i64 0, i32 1
; CHECK-NEXT:    store i8 [[DOTUNPACK2]], i8* [[V_REPACK18]], align 1
; CHECK-NEXT:    [[V_REPACK20:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[V]], i64 0, i32 2
; CHECK-NEXT:    store i8 [[DOTUNPACK4]], i8* [[V_REPACK20]], align 2
; CHECK-NEXT:    [[V_REPACK22:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[V]], i64 0, i32 3
; CHECK-NEXT:    store i8 [[DOTUNPACK6]], i8* [[V_REPACK22]], align 1
; CHECK-NEXT:    [[V_REPACK24:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[V]], i64 0, i32 4
; CHECK-NEXT:    store i8 [[DOTUNPACK8]], i8* [[V_REPACK24]], align 4
; CHECK-NEXT:    [[V_REPACK26:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[V]], i64 0, i32 5
; CHECK-NEXT:    store i8 [[DOTUNPACK10]], i8* [[V_REPACK26]], align 1
; CHECK-NEXT:    [[V_REPACK28:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[V]], i64 0, i32 6
; CHECK-NEXT:    store i8 [[DOTUNPACK12]], i8* [[V_REPACK28]], align 2
; CHECK-NEXT:    [[V_REPACK30:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[V]], i64 0, i32 7
; CHECK-NEXT:    store i8 [[DOTUNPACK14]], i8* [[V_REPACK30]], align 1
; CHECK-NEXT:    [[V_REPACK32:%.*]] = getelementptr inbounds [[STRUCT_U]], %struct.U* [[V]], i64 0, i32 8
; CHECK-NEXT:    store i64 [[DOTUNPACK16]], i64* [[V_REPACK32]], align 8
; CHECK-NEXT:    ret void
;
  %1 = load %struct.U, %struct.U* %u
  store %struct.U %1, %struct.U* %v
  ret void
}
