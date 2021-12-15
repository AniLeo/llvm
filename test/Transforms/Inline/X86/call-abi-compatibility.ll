; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
; RUN: opt < %s -mtriple=x86_64-unknown-linux-gnu -S -inline | FileCheck %s

; Test for PR52660.

; This call should not get inlined, because it would make the callee_not_avx
; call ABI incompatible.
define void @caller_avx() "target-features"="+avx" {
; CHECK-LABEL: define {{[^@]+}}@caller_avx
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    call void @caller_not_avx()
; CHECK-NEXT:    ret void
;
  call void @caller_not_avx()
  ret void
}

define internal void @caller_not_avx() {
; CHECK-LABEL: define {{[^@]+}}@caller_not_avx() {
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @callee_not_avx(<4 x i64> <i64 0, i64 1, i64 2, i64 3>)
; CHECK-NEXT:    ret void
;
  call i64 @callee_not_avx(<4 x i64> <i64 0, i64 1, i64 2, i64 3>)
  ret void
}

define i64 @callee_not_avx(<4 x i64> %arg) noinline {
; CHECK-LABEL: define {{[^@]+}}@callee_not_avx
; CHECK-SAME: (<4 x i64> [[ARG:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    [[V:%.*]] = extractelement <4 x i64> [[ARG]], i64 2
; CHECK-NEXT:    ret i64 [[V]]
;
  %v = extractelement <4 x i64> %arg, i64 2
  ret i64 %v
}

; This call also shouldn't be inlined, as we don't know whether callee_unknown
; is ABI compatible or not.
define void @caller_avx2() "target-features"="+avx" {
; CHECK-LABEL: define {{[^@]+}}@caller_avx2
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    call void @caller_not_avx2()
; CHECK-NEXT:    ret void
;
  call void @caller_not_avx2()
  ret void
}

define internal void @caller_not_avx2() {
; CHECK-LABEL: define {{[^@]+}}@caller_not_avx2() {
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @callee_unknown(<4 x i64> <i64 0, i64 1, i64 2, i64 3>)
; CHECK-NEXT:    ret void
;
  call i64 @callee_unknown(<4 x i64> <i64 0, i64 1, i64 2, i64 3>)
  ret void
}

declare i64 @callee_unknown(<4 x i64>)

; This call should get inlined, because we assume that intrinsics are always
; ABI compatible.
define void @caller_avx3() "target-features"="+avx" {
; CHECK-LABEL: define {{[^@]+}}@caller_avx3
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.some_intrinsic(<4 x i64> <i64 0, i64 1, i64 2, i64 3>)
; CHECK-NEXT:    ret void
;
  call void @caller_not_avx3()
  ret void
}

define internal void @caller_not_avx3() {
  call i64 @llvm.some_intrinsic(<4 x i64> <i64 0, i64 1, i64 2, i64 3>)
  ret void
}

declare i64 @llvm.some_intrinsic(<4 x i64>)

; This call should get inlined, because only simple types are involved.
define void @caller_avx4() "target-features"="+avx" {
; CHECK-LABEL: define {{[^@]+}}@caller_avx4
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @caller_unknown_simple(i64 0)
; CHECK-NEXT:    ret void
;
  call void @caller_not_avx4()
  ret void
}

define internal void @caller_not_avx4() {
  call i64 @caller_unknown_simple(i64 0)
  ret void
}

declare i64 @caller_unknown_simple(i64)
