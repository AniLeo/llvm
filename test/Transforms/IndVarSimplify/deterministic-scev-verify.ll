; RUN: opt -indvars -stats -disable-output < %s 2>&1 | FileCheck %s --check-prefix=STATS
; RUN: opt -indvars -S < %s | FileCheck %s --check-prefix=IR
; REQUIRES: asserts

; Check that IndVarSimplify's result is not influenced by stray calls to
; ScalarEvolution in debug builds. However, -verify-indvars may still do
; such calls.
; llvm.org/PR44815

; STATS: 1 scalar-evolution - Number of loops with trip counts computed by force
; STATS: 2 scalar-evolution - Number of loops with predictable loop counts

; In this test, adding -verify-indvars causes %tmp13 to not be optimized away.
; IR-LABEL: @foo
; IR-NOT:   phi i32

target triple = "x86_64-unknown-linux-gnu"

@b = external dso_local local_unnamed_addr global i32

define dso_local void @foo() {
tmp0:
  br label %tmp12

tmp7:
  %tmp8 = add nuw nsw i32 %tmp13, 1
  store i32 undef, i32* @b
  br label %tmp12

tmp12:
  %tmp13 = phi i32 [ 2, %tmp0 ], [ %tmp8, %tmp7 ]
  %tmp14 = phi i32 [ 1, %tmp0 ], [ %tmp13, %tmp7 ]
  %tmp15 = icmp ult i32 %tmp14, undef
  br i1 %tmp15, label %tmp7, label %tmp16

tmp16:
  ret void
}
