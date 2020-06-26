; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -dse -enable-dse-memoryssa -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

declare void @f()
declare i32 @__CxxFrameHandler3(...)


; Make sure we do not eliminate `store i32 20, i32* %sv`. Even though it is a store
; to a stack object, we can read it in the landing/catchpad.
define void @test12(i32* %p) personality i32 (...)* @__CxxFrameHandler3 {
; CHECK-LABEL: @test12(
; CHECK-NEXT:  block1:
; CHECK-NEXT:    [[SV:%.*]] = alloca i32
; CHECK-NEXT:    br label [[BLOCK2:%.*]]
; CHECK:       block2:
; CHECK-NEXT:    store i32 20, i32* [[SV]]
; CHECK-NEXT:    invoke void @f()
; CHECK-NEXT:    to label [[BLOCK3:%.*]] unwind label [[CATCH_DISPATCH:%.*]]
; CHECK:       block3:
; CHECK-NEXT:    br label [[EXIT:%.*]]
; CHECK:       catch.dispatch:
; CHECK-NEXT:    [[CS1:%.*]] = catchswitch within none [label %catch] unwind label [[CLEANUP:%.*]]
; CHECK:       catch:
; CHECK-NEXT:    [[C:%.*]] = catchpad within [[CS1]] []
; CHECK-NEXT:    [[LV:%.*]] = load i32, i32* [[SV]]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       cleanup:
; CHECK-NEXT:    [[C1:%.*]] = cleanuppad within none []
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
block1:
  %sv = alloca i32
  br label %block2

block2:
  store i32 20, i32* %sv
  invoke void @f()
  to label %block3 unwind label %catch.dispatch

block3:
  store i32 30, i32* %sv
  br label %exit

catch.dispatch:
  %cs1 = catchswitch within none [label %catch] unwind label %cleanup

catch:
  %c = catchpad within %cs1 []
  %lv = load i32, i32* %sv
  br label %exit

cleanup:
  %c1 = cleanuppad within none []
  br label %exit

exit:
  store i32 40, i32* %sv
  ret void
}
