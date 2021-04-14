; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=x86_64-apple-darwin -passes="print<cost-model>" 2>&1 -disable-output -mattr=+sse2 | FileCheck %s

define void @test() {
; CHECK-LABEL: 'test'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 6 for instruction: %matins.2.2 = shufflevector <9 x double> undef, <9 x double> undef, <9 x i32> <i32 0, i32 3, i32 6, i32 1, i32 4, i32 7, i32 2, i32 5, i32 8>
; CHECK-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
entry:
  %matins.2.2 = shufflevector <9 x double> undef, <9 x double> undef, <9 x i32> <i32 0, i32 3, i32 6, i32 1, i32 4, i32 7, i32 2, i32 5, i32 8>
  ret void
}

