; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target datalayout = "e-p:32:32"
target triple = "i686-pc-linux-gnu"
@r = external global [17 x i32]         ; <[17 x i32]*> [#uses=1]

define i1 @print_pgm_cond_true(i32 %tmp12.reload, i32* %tmp16.out) {
; CHECK-LABEL: @print_pgm_cond_true(
; CHECK-NEXT:  newFuncRoot:
; CHECK-NEXT:    br label [[COND_TRUE:%.*]]
; CHECK:       bb27.exitStub:
; CHECK-NEXT:    store i32 [[TMP16:%.*]], i32* [[TMP16_OUT:%.*]], align 4
; CHECK-NEXT:    ret i1 true
; CHECK:       cond_next23.exitStub:
; CHECK-NEXT:    store i32 [[TMP16]], i32* [[TMP16_OUT]], align 4
; CHECK-NEXT:    ret i1 false
; CHECK:       cond_true:
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr [17 x i32], [17 x i32]* @r, i32 0, i32 [[TMP12_RELOAD:%.*]]
; CHECK-NEXT:    [[TMP16]] = load i32, i32* [[TMP15]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[TMP16]], -32
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[TMP0]], -63
; CHECK-NEXT:    br i1 [[TMP1]], label [[BB27_EXITSTUB:%.*]], label [[COND_NEXT23_EXITSTUB:%.*]]
;
newFuncRoot:
  br label %cond_true

bb27.exitStub:          ; preds = %cond_true
  store i32 %tmp16, i32* %tmp16.out
  ret i1 true

cond_next23.exitStub:           ; preds = %cond_true
  store i32 %tmp16, i32* %tmp16.out
  ret i1 false

cond_true:              ; preds = %newFuncRoot
  %tmp15 = getelementptr [17 x i32], [17 x i32]* @r, i32 0, i32 %tmp12.reload         ; <i32*> [#uses=1]
  %tmp16 = load i32, i32* %tmp15               ; <i32> [#uses=4]
  %tmp18 = icmp slt i32 %tmp16, -31               ; <i1> [#uses=1]
  %tmp21 = icmp sgt i32 %tmp16, 31                ; <i1> [#uses=1]
  %bothcond = or i1 %tmp18, %tmp21                ; <i1> [#uses=1]
  br i1 %bothcond, label %bb27.exitStub, label %cond_next23.exitStub
}

define i1 @print_pgm_cond_true_logical(i32 %tmp12.reload, i32* %tmp16.out) {
; CHECK-LABEL: @print_pgm_cond_true_logical(
; CHECK-NEXT:  newFuncRoot:
; CHECK-NEXT:    br label [[COND_TRUE:%.*]]
; CHECK:       bb27.exitStub:
; CHECK-NEXT:    store i32 [[TMP16:%.*]], i32* [[TMP16_OUT:%.*]], align 4
; CHECK-NEXT:    ret i1 true
; CHECK:       cond_next23.exitStub:
; CHECK-NEXT:    store i32 [[TMP16]], i32* [[TMP16_OUT]], align 4
; CHECK-NEXT:    ret i1 false
; CHECK:       cond_true:
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr [17 x i32], [17 x i32]* @r, i32 0, i32 [[TMP12_RELOAD:%.*]]
; CHECK-NEXT:    [[TMP16]] = load i32, i32* [[TMP15]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[TMP16]], -32
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult i32 [[TMP0]], -63
; CHECK-NEXT:    br i1 [[TMP1]], label [[BB27_EXITSTUB:%.*]], label [[COND_NEXT23_EXITSTUB:%.*]]
;
newFuncRoot:
  br label %cond_true

bb27.exitStub:          ; preds = %cond_true
  store i32 %tmp16, i32* %tmp16.out
  ret i1 true

cond_next23.exitStub:           ; preds = %cond_true
  store i32 %tmp16, i32* %tmp16.out
  ret i1 false

cond_true:              ; preds = %newFuncRoot
  %tmp15 = getelementptr [17 x i32], [17 x i32]* @r, i32 0, i32 %tmp12.reload         ; <i32*> [#uses=1]
  %tmp16 = load i32, i32* %tmp15               ; <i32> [#uses=4]
  %tmp18 = icmp slt i32 %tmp16, -31               ; <i1> [#uses=1]
  %tmp21 = icmp sgt i32 %tmp16, 31                ; <i1> [#uses=1]
  %bothcond = select i1 %tmp18, i1 true, i1 %tmp21                ; <i1> [#uses=1]
  br i1 %bothcond, label %bb27.exitStub, label %cond_next23.exitStub
}

