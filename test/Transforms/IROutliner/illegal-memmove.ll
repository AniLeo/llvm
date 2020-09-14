; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -verify -iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; This test checks that we do not outline memcpy intrinsics since it may require
; extra address space checks.

declare void @llvm.memmove.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1)

define i8 @function1(i8* noalias %s, i8* noalias %d, i64 %len) {
; CHECK-LABEL: @function1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B_LOC:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[A_LOC:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[RET_LOC:%.*]] = alloca i8, align 1
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[A_LOC]])
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[B_LOC]])
; CHECK-NEXT:    call void @outlined_ir_func_1(i8* [[S:%.*]], i8* [[D:%.*]], i8* [[A_LOC]], i8* [[B_LOC]])
; CHECK-NEXT:    [[A_RELOAD:%.*]] = load i8, i8* [[A_LOC]], align 1
; CHECK-NEXT:    [[B_RELOAD:%.*]] = load i8, i8* [[B_LOC]], align 1
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[A_LOC]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[B_LOC]])
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i64(i8* [[D]], i8* [[S]], i64 [[LEN:%.*]], i1 false)
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[RET_LOC]])
; CHECK-NEXT:    call void @outlined_ir_func_0(i8 [[A_RELOAD]], i8 [[B_RELOAD]], i8* [[S]], i8* [[RET_LOC]])
; CHECK-NEXT:    [[RET_RELOAD:%.*]] = load i8, i8* [[RET_LOC]], align 1
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[RET_LOC]])
; CHECK-NEXT:    ret i8 [[RET_RELOAD]]
;
entry:
  %a = load i8, i8* %s
  %b = load i8, i8* %d
  call void @llvm.memmove.p0i8.p0i8.i64(i8* %d, i8* %s, i64 %len, i1 false)
  %c = add i8 %a, %b
  %ret = load i8, i8* %s
  ret i8 %ret
}

define i8 @function2(i8* noalias %s, i8* noalias %d, i64 %len) {
; CHECK-LABEL: @function2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B_LOC:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[A_LOC:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[RET_LOC:%.*]] = alloca i8, align 1
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[A_LOC]])
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[B_LOC]])
; CHECK-NEXT:    call void @outlined_ir_func_1(i8* [[S:%.*]], i8* [[D:%.*]], i8* [[A_LOC]], i8* [[B_LOC]])
; CHECK-NEXT:    [[A_RELOAD:%.*]] = load i8, i8* [[A_LOC]], align 1
; CHECK-NEXT:    [[B_RELOAD:%.*]] = load i8, i8* [[B_LOC]], align 1
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[A_LOC]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[B_LOC]])
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i64(i8* [[D]], i8* [[S]], i64 [[LEN:%.*]], i1 false)
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[RET_LOC]])
; CHECK-NEXT:    call void @outlined_ir_func_0(i8 [[A_RELOAD]], i8 [[B_RELOAD]], i8* [[S]], i8* [[RET_LOC]])
; CHECK-NEXT:    [[RET_RELOAD:%.*]] = load i8, i8* [[RET_LOC]], align 1
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[RET_LOC]])
; CHECK-NEXT:    ret i8 [[RET_RELOAD]]
;
entry:
  %a = load i8, i8* %s
  %b = load i8, i8* %d
  call void @llvm.memmove.p0i8.p0i8.i64(i8* %d, i8* %s, i64 %len, i1 false)
  %c = add i8 %a, %b
  %ret = load i8, i8* %s
  ret i8 %ret
}
