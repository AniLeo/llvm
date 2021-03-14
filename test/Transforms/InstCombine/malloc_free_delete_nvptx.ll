; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

target triple = "nvptx64"

declare void @user(i8*)
declare i8* @malloc(i64)
declare void @free(i8*)

; Ensure the nvptx backend states malloc & free are a thing so we can recognize
; so we will optimize them properly. In the test below the malloc-free chain is
; useless and we can remove it *if* we know about malloc & free.
define void @malloc_then_free_not_needed() {
; CHECK-LABEL: @malloc_then_free_not_needed(
; CHECK-NEXT:    ret void
;
  %a = call i8* @malloc(i64 4)
  store i8 0, i8* %a
  call void @free(i8* %a)
  ret void
}

define void @malloc_then_free_needed() {
; CHECK-LABEL: @malloc_then_free_needed(
; CHECK-NEXT:    [[A:%.*]] = call dereferenceable_or_null(4) i8* @malloc(i64 4)
; CHECK-NEXT:    call void @user(i8* [[A]])
; CHECK-NEXT:    call void @free(i8* [[A]])
; CHECK-NEXT:    ret void
;
  %a = call i8* @malloc(i64 4)
  call void @user(i8* %a)
  call void @free(i8* %a)
  ret void
}
