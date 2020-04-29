; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"

declare void @readnone_may_throw() readnone

declare void @use(i32 *)

; Tests where the pointer/object is accessible after the function returns.

; Cannot remove the store from the entry block, because the call in bb2 may throw.
define void @accessible_after_return_1(i32* noalias %P, i1 %c1) {
; CHECK-LABEL: @accessible_after_return_1(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]]
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P]]
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @readnone_may_throw()
; CHECK-NEXT:    store i32 3, i32* [[P]]
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  br label %bb5

bb2:
  call void @readnone_may_throw()
  store i32 3, i32* %P
  br label %bb5

bb5:
  call void @use(i32* %P)
  ret void
}

; Cannot remove the store from the entry block, because the call in bb3 may throw.
define void @accessible_after_return6(i32* %P, i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @accessible_after_return6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[P:%.*]]
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    store i32 1, i32* [[P]]
; CHECK-NEXT:    ret void
; CHECK:       bb3:
; CHECK-NEXT:    call void @readnone_may_throw()
; CHECK-NEXT:    store i32 2, i32* [[P]]
; CHECK-NEXT:    ret void
; CHECK:       bb4:
; CHECK-NEXT:    store i32 3, i32* [[P]]
; CHECK-NEXT:    ret void
;
entry:
  store i32 0, i32* %P
  br i1 %c.1, label %bb1, label %bb2

bb1:
  br i1 %c.2, label %bb3, label %bb4

bb2:
  store i32 1, i32* %P
  ret void

bb3:
  call void @readnone_may_throw()
  store i32 2, i32* %P
  ret void

bb4:
  store i32 3, i32* %P
  ret void
}

; Tests where the pointer/object is *NOT* accessible after the function returns.

; The store in the entry block can be eliminated, because it is overwritten
; on all paths to the exit. As the location is not visible to the caller, the
; call in bb2 (which may throw) can be ignored.
define void @alloca_1(i1 %c1) {
; CHECK-LABEL: @alloca_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P:%.*]] = alloca i32
; CHECK-NEXT:    br i1 [[C1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P]]
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @readnone_may_throw()
; CHECK-NEXT:    store i32 3, i32* [[P]]
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    ret void
;
entry:
  %P = alloca i32
  store i32 1, i32* %P
  br i1 %c1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  br label %bb5

bb2:
  call void @readnone_may_throw()
  store i32 3, i32* %P
  br label %bb5

bb5:
  call void @use(i32* %P)
  ret void
}

; The store in the entry block can be eliminated, because it is overwritten
; on all paths to the exit. As the location is not visible to the caller, the
; call in bb3 (which may throw) can be ignored.
define void @alloca_2(i1 %c.1, i1 %c.2) {
; CHECK-LABEL: @alloca_2(
; CHECK-NEXT:    [[P:%.*]] = alloca i32
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    store i32 0, i32* [[P]]
; CHECK-NEXT:    br label [[BB5:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br i1 [[C_2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    call void @readnone_may_throw()
; CHECK-NEXT:    store i32 3, i32* [[P]]
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb4:
; CHECK-NEXT:    store i32 5, i32* [[P]]
; CHECK-NEXT:    br label [[BB5]]
; CHECK:       bb5:
; CHECK-NEXT:    call void @use(i32* [[P]])
; CHECK-NEXT:    ret void
;
  %P = alloca i32
  store i32 1, i32* %P
  br i1 %c.1, label %bb1, label %bb2

bb1:
  store i32 0, i32* %P
  br label %bb5

bb2:
  br i1 %c.2, label %bb3, label %bb4

bb3:
  call void @readnone_may_throw()
  store i32 3, i32* %P
  br label %bb5

bb4:
  store i32 5, i32* %P
  br label %bb5

bb5:
  call void @use(i32* %P)
  ret void
}
