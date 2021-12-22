; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --include-generated-funcs
; RUN: opt -S -verify -iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; Show that we do differentiate between outputs of the region stored in PHINodes
; versus those stored outside of PHINodes.

define void @function1(i32* %a, i32* %b) {
entry:
  %0 = alloca i32, align 4
  %c = load i32, i32* %0, align 4
  br label %test1
test1:
  %e = load i32, i32* %0, align 4
  br i1 true, label %first, label %test
test:
  %d = load i32, i32* %0, align 4
  br i1 true, label %first, label %next
first:
  %1 = phi i32 [ %c, %test ], [ %e, %test1 ]
  ret void
next:
  ret void
}

define void @function2(i32* %a, i32* %b) {
entry:
  %0 = alloca i32, align 4
  %c = load i32, i32* %0, align 4
  br label %test1
test1:
  %e = load i32, i32* %0, align 4
  br i1 true, label %first, label %test
test:
  %d = load i32, i32* %0, align 4
  br i1 true, label %first, label %next
first:
  ret void
next:
  %1 = add i32 %c, 1
  %2 = add i32 %e, 1
  ret void
}
; CHECK-LABEL: @function1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTCE_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP0:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[LT_CAST:%.*]] = bitcast i32* [[DOTCE_LOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i1 @outlined_ir_func_0(i32* [[TMP0]], i32* [[DOTCE_LOC]], i32* null, i32 0)
; CHECK-NEXT:    [[DOTCE_RELOAD:%.*]] = load i32, i32* [[DOTCE_LOC]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    br i1 [[TMP1]], label [[FIRST:%.*]], label [[NEXT:%.*]]
; CHECK:       first:
; CHECK-NEXT:    [[TMP2:%.*]] = phi i32 [ [[DOTCE_RELOAD]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    ret void
; CHECK:       next:
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: @function2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[E_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[C_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP0:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[LT_CAST:%.*]] = bitcast i32* [[C_LOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    [[LT_CAST1:%.*]] = bitcast i32* [[E_LOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST1]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i1 @outlined_ir_func_0(i32* [[TMP0]], i32* [[C_LOC]], i32* [[E_LOC]], i32 1)
; CHECK-NEXT:    [[C_RELOAD:%.*]] = load i32, i32* [[C_LOC]], align 4
; CHECK-NEXT:    [[E_RELOAD:%.*]] = load i32, i32* [[E_LOC]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST1]])
; CHECK-NEXT:    br i1 [[TMP1]], label [[FIRST:%.*]], label [[NEXT:%.*]]
; CHECK:       first:
; CHECK-NEXT:    ret void
; CHECK:       next:
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[C_RELOAD]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 [[E_RELOAD]], 1
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define internal i1 @outlined_ir_func_0(
; CHECK-NEXT:  newFuncRoot:
; CHECK-NEXT:    br label [[ENTRY_TO_OUTLINE:%.*]]
; CHECK:       entry_to_outline:
; CHECK-NEXT:    [[C:%.*]] = load i32, i32* [[TMP0:%.*]], align 4
; CHECK-NEXT:    br label [[TEST1:%.*]]
; CHECK:       test1:
; CHECK-NEXT:    [[E:%.*]] = load i32, i32* [[TMP0]], align 4
; CHECK-NEXT:    br i1 true, label [[FIRST_SPLIT:%.*]], label [[TEST:%.*]]
; CHECK:       test:
; CHECK-NEXT:    [[D:%.*]] = load i32, i32* [[TMP0]], align 4
; CHECK-NEXT:    br i1 true, label [[FIRST_SPLIT]], label [[NEXT_EXITSTUB:%.*]]
; CHECK:       first.split:
; CHECK-NEXT:    [[DOTCE:%.*]] = phi i32 [ [[C]], [[TEST]] ], [ [[E]], [[TEST1]] ]
; CHECK-NEXT:    br label [[FIRST_EXITSTUB:%.*]]
; CHECK:       first.exitStub:
; CHECK-NEXT:    switch i32 [[TMP3:%.*]], label [[FINAL_BLOCK_1:%.*]] [
; CHECK-NEXT:    i32 0, label [[OUTPUT_BLOCK_0_1:%.*]]
; CHECK-NEXT:    i32 1, label [[OUTPUT_BLOCK_1_1:%.*]]
; CHECK-NEXT:    ]
; CHECK:       next.exitStub:
; CHECK-NEXT:    switch i32 [[TMP3]], label [[FINAL_BLOCK_0:%.*]] [
; CHECK-NEXT:    i32 0, label [[OUTPUT_BLOCK_1_0:%.*]]
; CHECK-NEXT:    ]
; CHECK:       output_block_0_1:
; CHECK-NEXT:    store i32 [[DOTCE]], i32* [[TMP1:%.*]], align 4
; CHECK-NEXT:    br label [[FINAL_BLOCK_1]]
; CHECK:       output_block_1_0:
; CHECK-NEXT:    store i32 [[C]], i32* [[TMP1]], align 4
; CHECK-NEXT:    store i32 [[E]], i32* [[TMP2:%.*]], align 4
; CHECK-NEXT:    br label [[FINAL_BLOCK_0]]
; CHECK:       output_block_1_1:
; CHECK-NEXT:    store i32 [[C]], i32* [[TMP1]], align 4
; CHECK-NEXT:    store i32 [[E]], i32* [[TMP2]], align 4
; CHECK-NEXT:    br label [[FINAL_BLOCK_1]]
; CHECK:       final_block_0:
; CHECK-NEXT:    ret i1 false
; CHECK:       final_block_1:
; CHECK-NEXT:    ret i1 true
;
