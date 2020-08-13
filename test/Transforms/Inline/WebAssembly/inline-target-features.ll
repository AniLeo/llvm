; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -mtriple=wasm32-unknown-unknown -S -inline | FileCheck %s

; Check that having functions can be inlined into callers only when
; they have a subset of the caller's features.

target datalayout = "e-m:e-p:32:32-i64:64-n32:64-S128"
target triple = "wasm32-unknown-unknown"

declare void @foo()

define internal void @uses_simd() #0 {
; CHECK-LABEL: @uses_simd(
; CHECK-NEXT:    tail call void @foo()
; CHECK-NEXT:    ret void
;
  tail call void @foo()
  ret void
}

define void @many_features() #1 {
; CHECK-LABEL: @many_features(
; CHECK-NEXT:    tail call void @foo()
; CHECK-NEXT:    ret void
;
  tail call fastcc void @uses_simd()
  ret void
}

define void @few_features() #2 {
; CHECK-LABEL: @few_features(
; CHECK-NEXT:    tail call fastcc void @uses_simd()
; CHECK-NEXT:    ret void
;
  tail call fastcc void @uses_simd()
  ret void
}

attributes #0 = { "target-cpu"="mvp" "target-features"="+simd128"}
attributes #1 = { "target-cpu"="bleeding-edge" "target-features"="+simd128" }
attributes #2 = { "target-cpu"="mvp" "target-features"="+multivalue" }
