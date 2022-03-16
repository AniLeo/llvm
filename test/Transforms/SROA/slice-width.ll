; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=sroa -S | FileCheck %s
target datalayout = "e-p:64:64:64-p1:16:16:16-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-f32:32:32-f64:64:64-f80:128-v64:64:64-v128:128:128-a0:0:64-n8:16:32:64"

declare void @llvm.memcpy.p0i8.p0i8.i32(i8* nocapture, i8* nocapture, i32, i1) nounwind
declare void @llvm.memset.p0i8.i32(i8* nocapture, i8, i32, i1) nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind

; This tests that allocas are not split into slices that are not byte width multiple
define void @no_split_on_non_byte_width(i32) {
; CHECK-LABEL: @no_split_on_non_byte_width(
; CHECK-NEXT:    [[ARG_SROA_0:%.*]] = alloca i8, align 8
; CHECK-NEXT:    [[ARG_SROA_0_0_EXTRACT_TRUNC:%.*]] = trunc i32 [[TMP0:%.*]] to i8
; CHECK-NEXT:    store i8 [[ARG_SROA_0_0_EXTRACT_TRUNC]], i8* [[ARG_SROA_0]], align 8
; CHECK-NEXT:    [[ARG_SROA_3_0_EXTRACT_SHIFT:%.*]] = lshr i32 [[TMP0]], 8
; CHECK-NEXT:    [[ARG_SROA_3_0_EXTRACT_TRUNC:%.*]] = trunc i32 [[ARG_SROA_3_0_EXTRACT_SHIFT]] to i24
; CHECK-NEXT:    br label [[LOAD_I32:%.*]]
; CHECK:       load_i32:
; CHECK-NEXT:    [[ARG_SROA_0_0_ARG_SROA_0_0_R01:%.*]] = load i8, i8* [[ARG_SROA_0]], align 8
; CHECK-NEXT:    br label [[LOAD_I1:%.*]]
; CHECK:       load_i1:
; CHECK-NEXT:    [[ARG_SROA_0_0_P1_SROA_CAST4:%.*]] = bitcast i8* [[ARG_SROA_0]] to i1*
; CHECK-NEXT:    [[ARG_SROA_0_0_ARG_SROA_0_0_T1:%.*]] = load i1, i1* [[ARG_SROA_0_0_P1_SROA_CAST4]], align 8
; CHECK-NEXT:    ret void
;
  %arg = alloca i32 , align 8
  store i32 %0, i32* %arg
  br label %load_i32

load_i32:
  %r0 = load i32, i32* %arg
  br label %load_i1

load_i1:
  %p1 = bitcast i32* %arg to i1*
  %t1 = load i1, i1* %p1
  ret void
}

; PR18726: Check that we use memcpy and memset to fill out padding when we have
; a slice with a simple single type whose store size is smaller than the slice
; size.

%union.Foo = type { x86_fp80, i64, i64 }

@foo_copy_source = external constant %union.Foo
@i64_sink = global i64 0

define void @memcpy_fp80_padding() {
; CHECK-LABEL: @memcpy_fp80_padding(
; CHECK-NEXT:    [[X_SROA_0:%.*]] = alloca x86_fp80, align 16
; CHECK-NEXT:    [[X_SROA_0_0_X_I8_SROA_CAST:%.*]] = bitcast x86_fp80* [[X_SROA_0]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 [[X_SROA_0_0_X_I8_SROA_CAST]], i8* align 16 bitcast (%union.Foo* @foo_copy_source to i8*), i32 16, i1 false)
; CHECK-NEXT:    [[X_SROA_1_0_COPYLOAD:%.*]] = load i64, i64* getelementptr inbounds ([[UNION_FOO:%.*]], %union.Foo* @foo_copy_source, i64 0, i32 1), align 16
; CHECK-NEXT:    [[X_SROA_2_0_COPYLOAD:%.*]] = load i64, i64* getelementptr inbounds ([[UNION_FOO]], %union.Foo* @foo_copy_source, i64 0, i32 2), align 8
; CHECK-NEXT:    store i64 [[X_SROA_1_0_COPYLOAD]], i64* @i64_sink, align 4
; CHECK-NEXT:    ret void
;
  %x = alloca %union.Foo

  ; Copy from a global.
  %x_i8 = bitcast %union.Foo* %x to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 16 %x_i8, i8* align 16 bitcast (%union.Foo* @foo_copy_source to i8*), i32 32, i1 false)

  ; Access a slice of the alloca to trigger SROA.
  %mid_p = getelementptr %union.Foo, %union.Foo* %x, i32 0, i32 1
  %elt = load i64, i64* %mid_p
  store i64 %elt, i64* @i64_sink
  ret void
}

define void @memset_fp80_padding() {
; CHECK-LABEL: @memset_fp80_padding(
; CHECK-NEXT:    [[X_SROA_0:%.*]] = alloca x86_fp80, align 16
; CHECK-NEXT:    [[X_SROA_0_0_X_I8_SROA_CAST1:%.*]] = bitcast x86_fp80* [[X_SROA_0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i32(i8* align 16 [[X_SROA_0_0_X_I8_SROA_CAST1]], i8 -1, i32 16, i1 false)
; CHECK-NEXT:    store i64 -1, i64* @i64_sink, align 4
; CHECK-NEXT:    ret void
;
  %x = alloca %union.Foo

  ; Set to all ones.
  %x_i8 = bitcast %union.Foo* %x to i8*
  call void @llvm.memset.p0i8.i32(i8* align 16 %x_i8, i8 -1, i32 32, i1 false)

  ; Access a slice of the alloca to trigger SROA.
  %mid_p = getelementptr %union.Foo, %union.Foo* %x, i32 0, i32 1
  %elt = load i64, i64* %mid_p
  store i64 %elt, i64* @i64_sink
  ret void
}

%S.vec3float = type { float, float, float }
%U.vec3float = type { <4 x float> }

declare i32 @memcpy_vec3float_helper(%S.vec3float*)

; PR18726: Check that SROA does not rewrite a 12-byte memcpy into a 16-byte
; vector store, hence accidentally putting gibberish onto the stack.
define i32 @memcpy_vec3float_widening(%S.vec3float* %x) {
; CHECK-LABEL: @memcpy_vec3float_widening(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP1_SROA_0_0_TMP1_SROA_0_0__SROA_CAST_SROA_CAST:%.*]] = bitcast %S.vec3float* [[X:%.*]] to <3 x float>*
; CHECK-NEXT:    [[TMP1_SROA_0_0_COPYLOAD:%.*]] = load <3 x float>, <3 x float>* [[TMP1_SROA_0_0_TMP1_SROA_0_0__SROA_CAST_SROA_CAST]], align 4
; CHECK-NEXT:    [[TMP1_SROA_0_0_VEC_EXPAND:%.*]] = shufflevector <3 x float> [[TMP1_SROA_0_0_COPYLOAD]], <3 x float> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
; CHECK-NEXT:    [[TMP1_SROA_0_0_VECBLEND:%.*]] = select <4 x i1> <i1 true, i1 true, i1 true, i1 false>, <4 x float> [[TMP1_SROA_0_0_VEC_EXPAND]], <4 x float> undef
; CHECK-NEXT:    [[TMP2:%.*]] = alloca [[S_VEC3FLOAT:%.*]], align 4
; CHECK-NEXT:    [[TMP1_SROA_0_0_TMP1_SROA_0_0__SROA_CAST2_SROA_CAST:%.*]] = bitcast %S.vec3float* [[TMP2]] to <3 x float>*
; CHECK-NEXT:    [[TMP1_SROA_0_0_VEC_EXTRACT:%.*]] = shufflevector <4 x float> [[TMP1_SROA_0_0_VECBLEND]], <4 x float> poison, <3 x i32> <i32 0, i32 1, i32 2>
; CHECK-NEXT:    store <3 x float> [[TMP1_SROA_0_0_VEC_EXTRACT]], <3 x float>* [[TMP1_SROA_0_0_TMP1_SROA_0_0__SROA_CAST2_SROA_CAST]], align 4
; CHECK-NEXT:    [[RESULT:%.*]] = call i32 @memcpy_vec3float_helper(%S.vec3float* [[TMP2]])
; CHECK-NEXT:    ret i32 [[RESULT]]
;
entry:
  ; Create a temporary variable %tmp1 and copy %x[0] into it
  %tmp1 = alloca %S.vec3float, align 4
  %0 = bitcast %S.vec3float* %tmp1 to i8*
  %1 = bitcast %S.vec3float* %x to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %0, i8* align 4 %1, i32 12, i1 false)

  ; The following block does nothing; but appears to confuse SROA
  %unused1 = bitcast %S.vec3float* %tmp1 to %U.vec3float*
  %unused2 = getelementptr inbounds %U.vec3float, %U.vec3float* %unused1, i32 0, i32 0
  %unused3 = load <4 x float>, <4 x float>* %unused2, align 1

  ; Create a second temporary and copy %tmp1 into it
  %tmp2 = alloca %S.vec3float, align 4
  %2 = bitcast %S.vec3float* %tmp2 to i8*
  %3 = bitcast %S.vec3float* %tmp1 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i32(i8* align 4 %2, i8* align 4 %3, i32 12, i1 false)

  %result = call i32 @memcpy_vec3float_helper(%S.vec3float* %tmp2)
  ret i32 %result
}

; Don't crash on length that is constant expression.

define void @PR50888() {
; CHECK-LABEL: @PR50888(
; CHECK-NEXT:    [[ARRAY:%.*]] = alloca i8, align 1
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 1 [[ARRAY]], i8 0, i64 ptrtoint (void ()* @PR50888 to i64), i1 false)
; CHECK-NEXT:    ret void
;
  %array = alloca i8
  call void @llvm.memset.p0i8.i64(i8* align 16 %array, i8 0, i64 ptrtoint (void ()* @PR50888 to i64), i1 false)
  ret void
}

; Don't crash on out-of-bounds length.

define void @PR50910() {
; CHECK-LABEL: @PR50910(
; CHECK-NEXT:    [[T1:%.*]] = alloca i8, i64 1, align 8
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[T1]], i8 0, i64 1, i1 false)
; CHECK-NEXT:    ret void
;
  %t1 = alloca i8, i64 1, align 8
  call void @llvm.memset.p0i8.i64(i8* align 8 %t1, i8 0, i64 4294967296, i1 false)
  ret void
}

define i1 @presplit_overlarge_load() {
; CHECK-LABEL: @presplit_overlarge_load(
; CHECK-NEXT:    [[A_SROA_0:%.*]] = alloca i8, align 2
; CHECK-NEXT:    [[A_SROA_0_0_A_SROA_0_0_L11:%.*]] = load i8, i8* [[A_SROA_0]], align 2
; CHECK-NEXT:    [[A_SROA_0_0_A_1_SROA_CAST3:%.*]] = bitcast i8* [[A_SROA_0]] to i1*
; CHECK-NEXT:    [[A_SROA_0_0_A_SROA_0_0_L2:%.*]] = load i1, i1* [[A_SROA_0_0_A_1_SROA_CAST3]], align 2
; CHECK-NEXT:    ret i1 [[A_SROA_0_0_A_SROA_0_0_L2]]
;
  %A = alloca i16
  %A.32 = bitcast i16* %A to i32*
  %A.1 = bitcast i16* %A to i1*
  %L1 = load i32, i32* %A.32
  %L2 = load i1, i1* %A.1
  ret i1 %L2
}
