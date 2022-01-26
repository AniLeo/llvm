; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -verify -iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; This test ensures that we do not outline vararg instructions or intrinsics, as
; they may cause inconsistencies when outlining.

declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*)

define i32 @func1(i32 %a, double %b, i8* %v, ...) nounwind {
; CHECK-LABEL: @func1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AP1_LOC:%.*]] = alloca i8*, align 8
; CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B_ADDR:%.*]] = alloca double, align 8
; CHECK-NEXT:    [[AP:%.*]] = alloca i8*, align 4
; CHECK-NEXT:    [[C:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[LT_CAST:%.*]] = bitcast i8** [[AP1_LOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    call void @outlined_ir_func_0(i32 [[A:%.*]], i32* [[A_ADDR]], double [[B:%.*]], double* [[B_ADDR]], i8** [[AP]], i8** [[AP1_LOC]])
; CHECK-NEXT:    [[AP1_RELOAD:%.*]] = load i8*, i8** [[AP1_LOC]], align 8
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    call void @llvm.va_start(i8* [[AP1_RELOAD]])
; CHECK-NEXT:    [[TMP0:%.*]] = va_arg i8** [[AP]], i32
; CHECK-NEXT:    call void @llvm.va_copy(i8* [[V:%.*]], i8* [[AP1_RELOAD]])
; CHECK-NEXT:    call void @llvm.va_end(i8* [[AP1_RELOAD]])
; CHECK-NEXT:    store i32 [[TMP0]], i32* [[C]], align 4
; CHECK-NEXT:    [[TMP:%.*]] = load i32, i32* [[C]], align 4
; CHECK-NEXT:    ret i32 [[TMP]]
;
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca double, align 8
  %ap = alloca i8*, align 4
  %c = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store double %b, double* %b.addr, align 8
  %ap1 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap1)
  %0 = va_arg i8** %ap, i32
  call void @llvm.va_copy(i8* %v, i8* %ap1)
  call void @llvm.va_end(i8* %ap1)
  store i32 %0, i32* %c, align 4
  %tmp = load i32, i32* %c, align 4
  ret i32 %tmp
}

define i32 @func2(i32 %a, double %b, i8* %v, ...) nounwind {
; CHECK-LABEL: @func2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[AP1_LOC:%.*]] = alloca i8*, align 8
; CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B_ADDR:%.*]] = alloca double, align 8
; CHECK-NEXT:    [[AP:%.*]] = alloca i8*, align 4
; CHECK-NEXT:    [[C:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[LT_CAST:%.*]] = bitcast i8** [[AP1_LOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    call void @outlined_ir_func_0(i32 [[A:%.*]], i32* [[A_ADDR]], double [[B:%.*]], double* [[B_ADDR]], i8** [[AP]], i8** [[AP1_LOC]])
; CHECK-NEXT:    [[AP1_RELOAD:%.*]] = load i8*, i8** [[AP1_LOC]], align 8
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    call void @llvm.va_start(i8* [[AP1_RELOAD]])
; CHECK-NEXT:    [[TMP0:%.*]] = va_arg i8** [[AP]], i32
; CHECK-NEXT:    call void @llvm.va_copy(i8* [[V:%.*]], i8* [[AP1_RELOAD]])
; CHECK-NEXT:    call void @llvm.va_end(i8* [[AP1_RELOAD]])
; CHECK-NEXT:    store i32 [[TMP0]], i32* [[C]], align 4
; CHECK-NEXT:    [[AP2:%.*]] = bitcast i8** [[AP]] to i8*
; CHECK-NEXT:    [[TMP:%.*]] = load i32, i32* [[C]], align 4
; CHECK-NEXT:    ret i32 [[TMP]]
;
entry:
  %a.addr = alloca i32, align 4
  %b.addr = alloca double, align 8
  %ap = alloca i8*, align 4
  %c = alloca i32, align 4
  store i32 %a, i32* %a.addr, align 4
  store double %b, double* %b.addr, align 8
  %ap1 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap1)
  %0 = va_arg i8** %ap, i32
  call void @llvm.va_copy(i8* %v, i8* %ap1)
  call void @llvm.va_end(i8* %ap1)
  store i32 %0, i32* %c, align 4
  %ap2 = bitcast i8** %ap to i8*
  %tmp = load i32, i32* %c, align 4
  ret i32 %tmp
}
