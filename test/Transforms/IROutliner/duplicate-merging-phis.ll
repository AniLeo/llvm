; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --include-generated-funcs
; RUN: opt -S -verify -iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; Make sure that when we merge phi nodes, we do not merge two different PHINodes
; as the same phi node.

define void @f1() {
bb1:
  %0 = add i32 1, 2
  %1 = add i32 3, 4
  %2 = add i32 5, 6
  %3 = add i32 7, 8
  br label %bb5
bb2:
  %4 = mul i32 5, 4
  br label %bb5

placeholder:
  %a = sub i32 5, 4
  ret void

bb5:
  %phinode = phi i32 [5, %bb1], [5, %bb2]
  %phinode1 = phi i32 [5, %bb1], [5, %bb2]
  ret void
}

define void @f2() {
bb1:
  %0 = add i32 1, 2
  %1 = add i32 3, 4
  %2 = add i32 5, 6
  %3 = add i32 7, 8
  br label %bb5
bb2:
  %4 = mul i32 5, 4
  br label %bb5

placeholder:
  %a = sub i32 5, 4
  ret void

bb5:
  %phinode = phi i32 [5, %bb1], [5, %bb2]
  %phinode1 = phi i32 [5, %bb1], [5, %bb2]
  ret void
}
; CHECK-LABEL: @f1(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    [[PHINODE1_CE_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[PHINODE_CE_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 -1, ptr [[PHINODE_CE_LOC]])
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 -1, ptr [[PHINODE1_CE_LOC]])
; CHECK-NEXT:    [[TARGETBLOCK:%.*]] = call i1 @outlined_ir_func_0(ptr [[PHINODE_CE_LOC]], ptr [[PHINODE1_CE_LOC]])
; CHECK-NEXT:    [[PHINODE_CE_RELOAD:%.*]] = load i32, ptr [[PHINODE_CE_LOC]], align 4
; CHECK-NEXT:    [[PHINODE1_CE_RELOAD:%.*]] = load i32, ptr [[PHINODE1_CE_LOC]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 -1, ptr [[PHINODE_CE_LOC]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 -1, ptr [[PHINODE1_CE_LOC]])
; CHECK-NEXT:    br i1 [[TARGETBLOCK]], label [[BB5:%.*]], label [[BB1_AFTER_OUTLINE:%.*]]
; CHECK:       bb1_after_outline:
; CHECK-NEXT:    ret void
; CHECK:       bb5:
; CHECK-NEXT:    [[PHINODE:%.*]] = phi i32 [ [[PHINODE_CE_RELOAD]], [[BB1:%.*]] ]
; CHECK-NEXT:    [[PHINODE1:%.*]] = phi i32 [ [[PHINODE1_CE_RELOAD]], [[BB1]] ]
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: @f2(
; CHECK-NEXT:  bb1:
; CHECK-NEXT:    [[PHINODE1_CE_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[PHINODE_CE_LOC:%.*]] = alloca i32, align 4
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 -1, ptr [[PHINODE_CE_LOC]])
; CHECK-NEXT:    call void @llvm.lifetime.start.p0(i64 -1, ptr [[PHINODE1_CE_LOC]])
; CHECK-NEXT:    [[TARGETBLOCK:%.*]] = call i1 @outlined_ir_func_0(ptr [[PHINODE_CE_LOC]], ptr [[PHINODE1_CE_LOC]])
; CHECK-NEXT:    [[PHINODE_CE_RELOAD:%.*]] = load i32, ptr [[PHINODE_CE_LOC]], align 4
; CHECK-NEXT:    [[PHINODE1_CE_RELOAD:%.*]] = load i32, ptr [[PHINODE1_CE_LOC]], align 4
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 -1, ptr [[PHINODE_CE_LOC]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0(i64 -1, ptr [[PHINODE1_CE_LOC]])
; CHECK-NEXT:    br i1 [[TARGETBLOCK]], label [[BB5:%.*]], label [[BB1_AFTER_OUTLINE:%.*]]
; CHECK:       bb1_after_outline:
; CHECK-NEXT:    ret void
; CHECK:       bb5:
; CHECK-NEXT:    [[PHINODE:%.*]] = phi i32 [ [[PHINODE_CE_RELOAD]], [[BB1:%.*]] ]
; CHECK-NEXT:    [[PHINODE1:%.*]] = phi i32 [ [[PHINODE1_CE_RELOAD]], [[BB1]] ]
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
; CHECK-NEXT:    br label [[BB5_SPLIT:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    [[TMP6:%.*]] = mul i32 5, 4
; CHECK-NEXT:    br label [[BB5_SPLIT]]
; CHECK:       placeholder:
; CHECK-NEXT:    [[A:%.*]] = sub i32 5, 4
; CHECK-NEXT:    br label [[BB1_AFTER_OUTLINE_EXITSTUB:%.*]]
; CHECK:       bb5.split:
; CHECK-NEXT:    [[PHINODE_CE:%.*]] = phi i32 [ 5, [[BB1_TO_OUTLINE]] ], [ 5, [[BB2:%.*]] ]
; CHECK-NEXT:    [[PHINODE1_CE:%.*]] = phi i32 [ 5, [[BB1_TO_OUTLINE]] ], [ 5, [[BB2]] ]
; CHECK-NEXT:    br label [[BB5_EXITSTUB:%.*]]
; CHECK:       bb5.exitStub:
; CHECK-NEXT:    store i32 [[PHINODE_CE]], ptr [[TMP0:%.*]], align 4
; CHECK-NEXT:    store i32 [[PHINODE1_CE]], ptr [[TMP1:%.*]], align 4
; CHECK-NEXT:    ret i1 true
; CHECK:       bb1_after_outline.exitStub:
; CHECK-NEXT:    ret i1 false
;
