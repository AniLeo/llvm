; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=argpromotion -S %s | FileCheck %s

@glob = external global i32*

; No arguments in @callee can be promoted, but it contains a dead GEP. Make
; sure it is not removed, as we do not perform any promotion.
define i32 @caller(i32* %ptr) {
; CHECK-LABEL: @caller(
; CHECK-NEXT:    call void @callee(i32* [[PTR:%.*]], i32* [[PTR]], i32* [[PTR]])
; CHECK-NEXT:    ret i32 0
;
  call void @callee(i32* %ptr, i32* %ptr, i32* %ptr)
  ret i32 0
}

define internal void @callee(i32* %arg, i32* %arg1, i32* %arg2) {
; CHECK-LABEL: define internal void @callee(
; CHECK-NEXT:    call void @external_fn(i32* [[ARG:%.*]], i32* [[ARG1:%.*]])
; CHECK-NEXT:    [[DEAD_GEP:%.*]] = getelementptr inbounds i32, i32* [[ARG1]], i32 17
; CHECK-NEXT:    store i32* [[ARG2:%.*]], i32** @glob, align 8
; CHECK-NEXT:    ret void
;
  call void @external_fn(i32* %arg, i32* %arg1)
  %dead.gep = getelementptr inbounds i32, i32* %arg1, i32 17
  store i32* %arg2, i32** @glob, align 8
  ret  void
}

declare void @external_fn(i32*, i32*)
