; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --include-generated-funcs
; RUN: opt -S -verify -iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; This test checks that we sucessfully outline identical memcpy var arg
; intrinsics, but not the var arg instruction itself.

declare void @llvm.va_start(i8*)
declare void @llvm.va_copy(i8*, i8*)
declare void @llvm.va_end(i8*)

define i32 @func1(i32 %a, double %b, i8* %v, ...) nounwind {
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
; CHECK-LABEL: @func1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B_ADDR:%.*]] = alloca double, align 8
; CHECK-NEXT:    [[AP:%.*]] = alloca i8*, align 4
; CHECK-NEXT:    [[C:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 [[A:%.*]], i32* [[A_ADDR]], align 4
; CHECK-NEXT:    store double [[B:%.*]], double* [[B_ADDR]], align 8
; CHECK-NEXT:    [[AP1:%.*]] = bitcast i8** [[AP]] to i8*
; CHECK-NEXT:    call void @llvm.va_start(i8* [[AP1]])
; CHECK-NEXT:    [[TMP0:%.*]] = va_arg i8** [[AP]], i32
; CHECK-NEXT:    call void @outlined_ir_func_0(i8* [[V:%.*]], i8* [[AP1]], i32 [[TMP0]], i32* [[C]])
; CHECK-NEXT:    [[TMP:%.*]] = load i32, i32* [[C]], align 4
; CHECK-NEXT:    ret i32 [[TMP]]
;
;
; CHECK-LABEL: @func2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A_ADDR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B_ADDR:%.*]] = alloca double, align 8
; CHECK-NEXT:    [[AP:%.*]] = alloca i8*, align 4
; CHECK-NEXT:    [[C:%.*]] = alloca i32, align 4
; CHECK-NEXT:    store i32 [[A:%.*]], i32* [[A_ADDR]], align 4
; CHECK-NEXT:    store double [[B:%.*]], double* [[B_ADDR]], align 8
; CHECK-NEXT:    [[AP1:%.*]] = bitcast i8** [[AP]] to i8*
; CHECK-NEXT:    call void @llvm.va_start(i8* [[AP1]])
; CHECK-NEXT:    [[TMP0:%.*]] = va_arg i8** [[AP]], i32
; CHECK-NEXT:    call void @outlined_ir_func_0(i8* [[V:%.*]], i8* [[AP1]], i32 [[TMP0]], i32* [[C]])
; CHECK-NEXT:    [[AP2:%.*]] = bitcast i8** [[AP]] to i8*
; CHECK-NEXT:    [[TMP:%.*]] = load i32, i32* [[C]], align 4
; CHECK-NEXT:    ret i32 [[TMP]]
;
;
; CHECK: define internal void @outlined_ir_func_0(
; CHECK-NEXT:  newFuncRoot:
; CHECK-NEXT:    br label [[ENTRY_TO_OUTLINE:%.*]]
; CHECK:       entry_to_outline:
; CHECK-NEXT:    call void @llvm.va_copy(i8* [[TMP0:%.*]], i8* [[TMP1:%.*]])
; CHECK-NEXT:    call void @llvm.va_end(i8* [[TMP1]])
; CHECK-NEXT:    store i32 [[TMP2:%.*]], i32* [[TMP3:%.*]], align 4
; CHECK-NEXT:    br label [[ENTRY_AFTER_OUTLINE_EXITSTUB:%.*]]
; CHECK:       entry_after_outline.exitStub:
; CHECK-NEXT:    ret void
;
