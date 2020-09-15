; NOTE: Assertions have been autogenerated by utils/update_test_checks.py

; XFAIL: *
; RUN: opt < %s -basic-aa -dse -enable-dse-memoryssa -S | FileCheck %s
; RUN: opt < %s -aa-pipeline=basic-aa -passes=dse -enable-dse-memoryssa -S | FileCheck %s
target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind
declare void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* nocapture, i8, i64, i32) nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind
declare void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i32) nounwind

; PR8701

;; Fully dead overwrite of memcpy.
define void @test15(i8* %P, i8* %Q) nounwind ssp {
; CHECK-LABEL: @test15(
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[P:%.*]], i8* [[Q:%.*]], i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
  ret void
}

;; Fully dead overwrite of memcpy.
define void @test15_atomic(i8* %P, i8* %Q) nounwind ssp {
; CHECK-LABEL: @test15_atomic(
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i32 1)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i32 1)
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i32 1)
  ret void
}

;; Fully dead overwrite of memcpy.
define void @test15_atomic_weaker(i8* %P, i8* %Q) nounwind ssp {
; CHECK-LABEL: @test15_atomic_weaker(
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i32 1)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i1 false)
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i32 1)
  ret void
}

;; Fully dead overwrite of memcpy.
define void @test15_atomic_weaker_2(i8* %P, i8* %Q) nounwind ssp {
; CHECK-LABEL: @test15_atomic_weaker_2(
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i32 1)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i1 false)
  ret void
}

;; Full overwrite of smaller memcpy.
define void @test16(i8* %P, i8* %Q) nounwind ssp {
; CHECK-LABEL: @test16(
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[P:%.*]], i8* [[Q:%.*]], i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 8, i1 false)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
  ret void
}

;; Full overwrite of smaller memcpy.
define void @test16_atomic(i8* %P, i8* %Q) nounwind ssp {
; CHECK-LABEL: @test16_atomic(
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i32 1)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 8, i32 1)
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i32 1)
  ret void
}

;; Full overwrite of smaller memory where overwrite has stronger atomicity
define void @test16_atomic_weaker(i8* %P, i8* %Q) nounwind ssp {
; CHECK-LABEL: @test16_atomic_weaker(
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i32 1)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 8, i1 false)
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i32 1)
  ret void
}

;; Full overwrite of smaller memory where overwrite has weaker atomicity.
define void @test16_atomic_weaker_2(i8* %P, i8* %Q) nounwind ssp {
; CHECK-LABEL: @test16_atomic_weaker_2(
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 8, i32 1)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i1 false)
  ret void
}

;; Overwrite of memset by memcpy.
define void @test17(i8* %P, i8* noalias %Q) nounwind ssp {
; CHECK-LABEL: @test17(
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[P:%.*]], i8* [[Q:%.*]], i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memset.p0i8.i64(i8* %P, i8 42, i64 8, i1 false)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
  ret void
}

;; Overwrite of memset by memcpy.
define void @test17_atomic(i8* %P, i8* noalias %Q) nounwind ssp {
; CHECK-LABEL: @test17_atomic(
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i32 1)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 1 %P, i8 42, i64 8, i32 1)
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i32 1)
  ret void
}

;; Overwrite of memset by memcpy. Overwrite is stronger atomicity. We can
;; remove the memset.
define void @test17_atomic_weaker(i8* %P, i8* noalias %Q) nounwind ssp {
; CHECK-LABEL: @test17_atomic_weaker(
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i32 1)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memset.p0i8.i64(i8* align 1 %P, i8 42, i64 8, i1 false)
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i32 1)
  ret void
}

;; Overwrite of memset by memcpy. Overwrite is weaker atomicity. We can remove
;; the memset.
define void @test17_atomic_weaker_2(i8* %P, i8* noalias %Q) nounwind ssp {
; CHECK-LABEL: @test17_atomic_weaker_2(
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 1 %P, i8 42, i64 8, i32 1)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i1 false)
  ret void
}

; Should not delete the volatile memset.
define void @test17v(i8* %P, i8* %Q) nounwind ssp {
; CHECK-LABEL: @test17v(
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* [[P:%.*]], i8 42, i64 8, i1 true)
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[P]], i8* [[Q:%.*]], i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memset.p0i8.i64(i8* %P, i8 42, i64 8, i1 true)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
  ret void
}

; PR8728
; Do not delete instruction where possible situation is:
; A = B
; A = A
;
; NB! See PR11763 - currently LLVM allows memcpy's source and destination to be
; equal (but not inequal and overlapping).
define void @test18(i8* %P, i8* %Q, i8* %R) nounwind ssp {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[P:%.*]], i8* [[Q:%.*]], i64 12, i1 false)
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[P]], i8* [[R:%.*]], i64 12, i1 false)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %R, i64 12, i1 false)
  ret void
}

define void @test18_atomic(i8* %P, i8* %Q, i8* %R) nounwind ssp {
; CHECK-LABEL: @test18_atomic(
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 [[P:%.*]], i8* align 1 [[Q:%.*]], i64 12, i32 1)
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 [[P]], i8* align 1 [[R:%.*]], i64 12, i32 1)
; CHECK-NEXT:    ret void
;
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %Q, i64 12, i32 1)
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 1 %P, i8* align 1 %R, i64 12, i32 1)
  ret void
}

