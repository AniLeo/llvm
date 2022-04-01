; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes=instcombine %s | FileCheck %s

; Function Attrs: nonlazybind uwtable
define void @alloc_elides_test(i32 %data){
; CHECK-LABEL: @alloc_elides_test(
; CHECK-NEXT:  start:
; CHECK-NEXT:    ret void
;
start:
  %0 = tail call i8* @__rust_alloc(i64 4, i64 32)
  tail call void @__rust_dealloc(i8* nonnull %0, i64 4, i64 32)
  ret void
}

declare noalias i8* @__rust_alloc(i64, i64 allocalign) unnamed_addr nounwind nonlazybind allocsize(0) uwtable allockind("alloc,uninitialized,aligned") "alloc-family"="__rust_alloc"

declare void @__rust_dealloc(i8* allocptr, i64, i64) unnamed_addr nounwind nonlazybind uwtable allockind("free") "alloc-family"="__rust_alloc"
