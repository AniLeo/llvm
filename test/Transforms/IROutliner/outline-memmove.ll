; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --include-generated-funcs
; RUN: opt -S -verify -iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; This test checks that we sucecssfully outline identical memmove instructions.

declare void @llvm.memmove.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1)

define i8 @function1(i8* noalias %s, i8* noalias %d, i64 %len) {
entry:
  %a = load i8, i8* %s
  %b = load i8, i8* %d
  call void @llvm.memmove.p0i8.p0i8.i64(i8* %d, i8* %s, i64 %len, i1 false)
  %c = add i8 %a, %b
  %ret = load i8, i8* %s
  ret i8 %ret
}

define i8 @function2(i8* noalias %s, i8* noalias %d, i64 %len) {
entry:
  %a = load i8, i8* %s
  %b = load i8, i8* %d
  call void @llvm.memmove.p0i8.p0i8.i64(i8* %d, i8* %s, i64 %len, i1 false)
  %c = add i8 %a, %b
  %ret = load i8, i8* %s
  ret i8 %ret
}
; CHECK-LABEL: @function1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RET_LOC:%.*]] = alloca i8, align 1
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[RET_LOC]])
; CHECK-NEXT:    call void @outlined_ir_func_0(i8* [[S:%.*]], i8* [[D:%.*]], i64 [[LEN:%.*]], i8* [[RET_LOC]])
; CHECK-NEXT:    [[RET_RELOAD:%.*]] = load i8, i8* [[RET_LOC]], align 1
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[RET_LOC]])
; CHECK-NEXT:    ret i8 [[RET_RELOAD]]
;
;
; CHECK-LABEL: @function2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[RET_LOC:%.*]] = alloca i8, align 1
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[RET_LOC]])
; CHECK-NEXT:    call void @outlined_ir_func_0(i8* [[S:%.*]], i8* [[D:%.*]], i64 [[LEN:%.*]], i8* [[RET_LOC]])
; CHECK-NEXT:    [[RET_RELOAD:%.*]] = load i8, i8* [[RET_LOC]], align 1
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[RET_LOC]])
; CHECK-NEXT:    ret i8 [[RET_RELOAD]]
;
;
; CHECK: define internal void @outlined_ir_func_0(
; CHECK-NEXT:  newFuncRoot:
; CHECK-NEXT:    br label [[ENTRY_TO_OUTLINE:%.*]]
; CHECK:       entry_to_outline:
; CHECK-NEXT:    [[A:%.*]] = load i8, i8* [[TMP0:%.*]], align 1
; CHECK-NEXT:    [[B:%.*]] = load i8, i8* [[TMP1:%.*]], align 1
; CHECK-NEXT:    call void @llvm.memmove.p0i8.p0i8.i64(i8* [[TMP1]], i8* [[TMP0]], i64 [[TMP2:%.*]], i1 false)
; CHECK-NEXT:    [[C:%.*]] = add i8 [[A]], [[B]]
; CHECK-NEXT:    [[RET:%.*]] = load i8, i8* [[TMP0]], align 1
; CHECK-NEXT:    br label [[ENTRY_AFTER_OUTLINE_EXITSTUB:%.*]]
; CHECK:       entry_after_outline.exitStub:
; CHECK-NEXT:    store i8 [[RET]], i8* [[TMP3:%.*]], align 1
; CHECK-NEXT:    ret void
;
