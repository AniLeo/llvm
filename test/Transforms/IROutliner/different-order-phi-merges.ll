; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --include-generated-funcs
; RUN: opt -S -verify -iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; Check that differently ordered phi nodes are not matched when merged, instead
; generating two output paths.

define void @f1() {
bb1:
  %0 = add i32 1, 2
  %1 = add i32 3, 4
  %2 = add i32 5, 6
  %3 = add i32 7, 8
  br i1 true, label %bb2, label %bb5
bb2:
  %4 = mul i32 5, 4
  br label %bb5

placeholder:
  %a = sub i32 5, 4
  ret void

bb5:
  %phinode = phi i32 [%3, %bb1], [%2, %bb2]
  ret void
}

define void @f2() {
bb1:
  %0 = add i32 1, 2
  %1 = add i32 3, 4
  %2 = add i32 5, 6
  %3 = add i32 7, 8
  br i1 true, label %bb2, label %bb5
bb2:
  %4 = mul i32 5, 4
  br label %bb5

placeholder:
  %a = sub i32 5, 4
  ret void

bb5:
  %phinode = phi i32 [%2, %bb1], [%3, %bb2]
  ret void
}
; CHECK-LABEL: @f1(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    [[PHINODE_CE_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[LT_CAST:%.*]] = bitcast i32* [[PHINODE_CE_LOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    [[TMP0:%.*]] = call i1 @outlined_ir_func_0(i32* [[PHINODE_CE_LOC]], i32 0)
; CHECK-NEXT:    [[PHINODE_CE_RELOAD:%.*]] = load i32, i32* [[PHINODE_CE_LOC]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    br i1 [[TMP0]], label [[BB5:%.*]], label [[BB1_AFTER_OUTLINE:%.*]]
; CHECK:       bb1_after_outline:
; CHECK-NEXT:    ret void
; CHECK:       bb5:
; CHECK-NEXT:    [[PHINODE:%.*]] = phi i32 [ [[PHINODE_CE_RELOAD]], [[BB1:%.*]] ]
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: @f2(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    [[PHINODE_CE_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[LT_CAST:%.*]] = bitcast i32* [[PHINODE_CE_LOC]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    [[TMP0:%.*]] = call i1 @outlined_ir_func_0(i32* [[PHINODE_CE_LOC]], i32 1)
; CHECK-NEXT:    [[PHINODE_CE_RELOAD:%.*]] = load i32, i32* [[PHINODE_CE_LOC]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 -1, i8* [[LT_CAST]])
; CHECK-NEXT:    br i1 [[TMP0]], label [[BB5:%.*]], label [[BB1_AFTER_OUTLINE:%.*]]
; CHECK:       bb1_after_outline:
; CHECK-NEXT:    ret void
; CHECK:       bb5:
; CHECK-NEXT:    [[PHINODE:%.*]] = phi i32 [ [[PHINODE_CE_RELOAD]], [[BB1:%.*]] ]
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define internal i1 @outlined_ir_func_0(
; CHECK-NEXT:  newFuncRoot:
; CHECK-NEXT:    br label [[BB1_TO_OUTLINE:%.*]]
; CHECK:       bb1_to_outline:
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 1, 2
; CHECK-NEXT:    [[TMP3:%.*]] = add i32 3, 4
; CHECK-NEXT:    [[TMP4:%.*]] = add i32 5, 6
; CHECK-NEXT:    [[TMP5:%.*]] = add i32 7, 8
; CHECK-NEXT:    br i1 true, label [[BB2:%.*]], label [[BB5_SPLIT:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP6:%.*]] = mul i32 5, 4
; CHECK-NEXT:    br label [[BB5_SPLIT]]
; CHECK:       placeholder:
; CHECK-NEXT:    [[A:%.*]] = sub i32 5, 4
; CHECK-NEXT:    br label [[BB1_AFTER_OUTLINE_EXITSTUB:%.*]]
; CHECK:       bb5.split:
; CHECK-NEXT:    [[TMP7:%.*]] = phi i32 [ [[TMP4]], [[BB1_TO_OUTLINE]] ], [ [[TMP5]], [[BB2]] ]
; CHECK-NEXT:    [[PHINODE_CE:%.*]] = phi i32 [ [[TMP5]], [[BB1_TO_OUTLINE]] ], [ [[TMP4]], [[BB2]] ]
; CHECK-NEXT:    br label [[BB5_EXITSTUB:%.*]]
; CHECK:       bb5.exitStub:
; CHECK-NEXT:    switch i32 [[TMP1:%.*]], label [[FINAL_BLOCK_1:%.*]] [
; CHECK-NEXT:    i32 0, label [[OUTPUT_BLOCK_0_1:%.*]]
; CHECK-NEXT:    i32 1, label [[OUTPUT_BLOCK_1_1:%.*]]
; CHECK-NEXT:    ]
; CHECK:       bb1_after_outline.exitStub:
; CHECK-NEXT:    switch i32 [[TMP1]], label [[FINAL_BLOCK_0:%.*]] [
; CHECK-NEXT:    ]
; CHECK:       output_block_0_1:
; CHECK-NEXT:    store i32 [[PHINODE_CE]], i32* [[TMP0:%.*]], align 4
; CHECK-NEXT:    br label [[FINAL_BLOCK_1]]
; CHECK:       output_block_1_1:
; CHECK-NEXT:    store i32 [[TMP7]], i32* [[TMP0]], align 4
; CHECK-NEXT:    br label [[FINAL_BLOCK_1]]
; CHECK:       final_block_0:
; CHECK-NEXT:    ret i1 false
; CHECK:       final_block_1:
; CHECK-NEXT:    ret i1 true
;
