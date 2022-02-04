; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -instcombine-max-iterations=1 -S | FileCheck %s
; These tests check the optimizations specific to
; pointers being relocated at a statepoint.


declare void @func()

define i1 @test_null(i1 %cond) gc "statepoint-example" {
; CHECK-LABEL: @test_null(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       right:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       left:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = tail call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* nonnull elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"() ]
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN2:%.*]] = tail call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* nonnull elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"() ]
; CHECK-NEXT:    ret i1 true
;
entry:
  br i1 %cond, label %left, label %right

right:
  br label %merge

left:
  %safepoint_token = tail call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32* null)]
  %pnew = call i32* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  br label %merge

merge:
  %pnew_phi = phi i32* [null, %right], [%pnew, %left]
  %safepoint_token2 = tail call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32* %pnew_phi)]
  %pnew2 = call i32* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 0)
  %cmp = icmp eq i32* %pnew2, null
  ret i1 %cmp
}

define i32* @test_undef(i1 %cond) gc "statepoint-example" {
; CHECK-LABEL: @test_undef(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       right:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       left:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = tail call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* nonnull elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"() ]
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN2:%.*]] = tail call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* nonnull elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"() ]
; CHECK-NEXT:    ret i32* undef
;
entry:
  br i1 %cond, label %left, label %right

right:
  br label %merge

left:
  %safepoint_token = tail call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32* undef)]
  %pnew = call i32* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  br label %merge

merge:
  %pnew_phi = phi i32* [undef, %right], [%pnew, %left]
  %safepoint_token2 = tail call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* elementtype(void ()) @func, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32* %pnew_phi)]
  %pnew2 = call i32* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 0)
  ret i32* %pnew2
}

declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64, i32, void ()*, i32, i32, ...)
declare i32* @llvm.experimental.gc.relocate.p1i32(token, i32, i32)
