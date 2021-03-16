; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -mtriple=x86_64-unknown-linux-gnu < %s | FileCheck %s

define <2 x float> @foo() {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SOURCE:%.*]] = insertelement <2 x float> undef, float undef, i32 0
; CHECK-NEXT:    [[TMP0:%.*]] = fsub <2 x float> [[SOURCE]], [[SOURCE]]
; CHECK-NEXT:    ret <2 x float> [[TMP0]]
;
entry:
  %source = insertelement <2 x float> undef, float undef, i32 0
  %e0 = extractelement <2 x float> %source, i32 0
  %e0.dup = extractelement <2 x float> %source, i32 0
  %sub1 = fsub float %e0, %e0.dup
  %e1 = extractelement <2 x float> %source, i32 1
  %e1.dup = extractelement <2 x float> %source, i32 1
  %sub2 = fsub float %e1, %e1.dup
  %res1 = insertelement <2 x float> undef, float %sub1, i32 0
  %res2 = insertelement <2 x float> %res1, float %sub2, i32 1
  ret <2 x float> %res2
}

!llvm.ident = !{!0, !0}

!0 = !{!"clang version 4.0.0 "}
