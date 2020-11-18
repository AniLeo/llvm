; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -inline -S < %s | FileCheck %s

declare void @external_function(i8*)

define internal void @inlined_function(i8* %arg) {
  call void @external_function(i8* %arg)
  ret void
}

; TODO: This is a miscompile.
define void @test(i8** %p) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    [[ARG:%.*]] = load i8*, i8** [[P:%.*]], align 8, !alias.scope !0, !noalias !0
; CHECK-NEXT:    call void @external_function(i8* [[ARG]]), !noalias !0
; CHECK-NEXT:    ret void
;
  %arg = load i8*, i8** %p, !alias.scope !0
  tail call void @inlined_function(i8* %arg), !noalias !0
  ret void
}

!0 = !{!1}
!1 = distinct !{!1, !2}
!2 = distinct !{!2}
