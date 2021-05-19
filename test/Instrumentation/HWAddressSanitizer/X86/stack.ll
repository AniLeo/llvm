; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -hwasan -hwasan-instrument-with-calls -hwasan-instrument-stack -hwasan-use-page-alias=false -S | FileCheck %s

source_filename = "stack.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: noinline nounwind optnone uwtable
define dso_local i32 @main() sanitize_hwaddress {
; CHECK-LABEL: @main(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTHWASAN_SHADOW:%.*]] = call i8* asm "", "=r,0"(i8* null)
; CHECK-NEXT:    [[TMP0:%.*]] = call i8* @llvm.frameaddress.p0i8(i32 0)
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint i8* [[TMP0]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i64 [[TMP1]], 20
; CHECK-NEXT:    [[HWASAN_STACK_BASE_TAG:%.*]] = xor i64 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP3:%.*]] = and i64 [[HWASAN_STACK_BASE_TAG]], 63
; CHECK-NEXT:    [[RETVAL:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[LV0:%.*]] = alloca { i32, [12 x i8] }, align 16
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast { i32, [12 x i8] }* [[LV0]] to i32*
; CHECK-NEXT:    [[TMP5:%.*]] = xor i64 [[TMP3]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = and i64 [[TMP5]], 63
; CHECK-NEXT:    [[TMP7:%.*]] = ptrtoint i32* [[TMP4]] to i64
; CHECK-NEXT:    [[TMP8:%.*]] = shl i64 [[TMP6]], 57
; CHECK-NEXT:    [[TMP9:%.*]] = or i64 [[TMP7]], [[TMP8]]
; CHECK-NEXT:    [[LV0_HWASAN:%.*]] = inttoptr i64 [[TMP9]] to i32*
; CHECK-NEXT:    [[TMP10:%.*]] = trunc i64 [[TMP6]] to i8
; CHECK-NEXT:    [[TMP11:%.*]] = bitcast i32* [[TMP4]] to i8*
; CHECK-NEXT:    call void @__hwasan_tag_memory(i8* [[TMP11]], i8 [[TMP10]], i64 16)
; CHECK-NEXT:    [[TMP12:%.*]] = ptrtoint i32* [[RETVAL]] to i64
; CHECK-NEXT:    call void @__hwasan_store4(i64 [[TMP12]])
; CHECK-NEXT:    store i32 0, i32* [[RETVAL]], align 4
; CHECK-NEXT:    [[TMP13:%.*]] = ptrtoint i32* [[LV0_HWASAN]] to i64
; CHECK-NEXT:    call void @__hwasan_store4(i64 [[TMP13]])
; CHECK-NEXT:    store i32 12345, i32* [[LV0_HWASAN]], align 4
; CHECK-NEXT:    call void @foo(i32* [[LV0_HWASAN]])
; CHECK-NEXT:    [[TMP14:%.*]] = ptrtoint i32* [[LV0_HWASAN]] to i64
; CHECK-NEXT:    call void @__hwasan_load4(i64 [[TMP14]])
; CHECK-NEXT:    [[TMP15:%.*]] = load i32, i32* [[LV0_HWASAN]], align 4
; CHECK-NEXT:    [[TMP16:%.*]] = bitcast i32* [[TMP4]] to i8*
; CHECK-NEXT:    call void @__hwasan_tag_memory(i8* [[TMP16]], i8 0, i64 16)
; CHECK-NEXT:    ret i32 [[TMP15]]
;
entry:
  %retval = alloca i32, align 4
  %lv0 = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  store i32 12345, i32* %lv0, align 4
  call void @foo(i32* %lv0)
  %0 = load i32, i32* %lv0, align 4
  ret i32 %0
}

declare dso_local void @foo(i32*)
