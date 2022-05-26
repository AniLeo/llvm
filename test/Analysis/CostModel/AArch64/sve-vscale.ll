; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -mtriple=aarch64-linux-gnu -mattr=+sve -passes='print<cost-model>' 2>&1 -disable-output < %s | FileCheck %s

define i32 @vscale32() {
; CHECK-LABEL: 'vscale32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = call i32 @llvm.vscale.i32()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %c
;
  %c = call i32 @llvm.vscale.i32()
  ret i32 %c
}

define i64 @vscale64() {
; CHECK-LABEL: 'vscale64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = call i64 @llvm.vscale.i64()
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i64 %c
;
  %c = call i64 @llvm.vscale.i64()
  ret i64 %c
}

declare i32 @llvm.vscale.i32()
declare i64 @llvm.vscale.i64()
