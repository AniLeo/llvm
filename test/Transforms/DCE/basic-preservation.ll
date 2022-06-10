; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=dce -S --enable-knowledge-retention < %s | FileCheck %s

define void @test(ptr %P) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(ptr [[P:%.*]], i64 4), "nonnull"(ptr [[P]]), "align"(ptr [[P]], i64 4) ]
; CHECK-NEXT:    ret void
;
  %a = load i32, ptr %P
  ret void
}
