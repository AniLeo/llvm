; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -S < %s | FileCheck %s
; RUN: opt -passes=simplify-cfg -S < %s | FileCheck %s

target datalayout = "e-p:64:64-p5:32:32-A5"

declare void @llvm.assume(i1)

define void @test_01(i1 %c, i64* align 1 %ptr) local_unnamed_addr #0 {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[TRUE2_CRITEDGE:%.*]], label [[FALSE1:%.*]]
; CHECK:       false1:
; CHECK-NEXT:    store volatile i64 1, i64* [[PTR:%.*]], align 4
; CHECK-NEXT:    [[PTRINT:%.*]] = ptrtoint i64* [[PTR]] to i64
; CHECK-NEXT:    [[MASKEDPTR:%.*]] = and i64 [[PTRINT]], 7
; CHECK-NEXT:    [[MASKCOND:%.*]] = icmp eq i64 [[MASKEDPTR]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[MASKCOND]])
; CHECK-NEXT:    store volatile i64 0, i64* [[PTR]], align 8
; CHECK-NEXT:    store volatile i64 3, i64* [[PTR]], align 8
; CHECK-NEXT:    ret void
; CHECK:       true2.critedge:
; CHECK-NEXT:    [[PTRINT_C:%.*]] = ptrtoint i64* [[PTR]] to i64
; CHECK-NEXT:    [[MASKEDPTR_C:%.*]] = and i64 [[PTRINT_C]], 7
; CHECK-NEXT:    [[MASKCOND_C:%.*]] = icmp eq i64 [[MASKEDPTR_C]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[MASKCOND_C]])
; CHECK-NEXT:    store volatile i64 0, i64* [[PTR]], align 8
; CHECK-NEXT:    store volatile i64 2, i64* [[PTR]], align 8
; CHECK-NEXT:    ret void
;
  br i1 %c, label %true1, label %false1

true1:                                            ; preds = %false1, %0
  %ptrint = ptrtoint i64* %ptr to i64
  %maskedptr = and i64 %ptrint, 7
  %maskcond = icmp eq i64 %maskedptr, 0
  tail call void @llvm.assume(i1 %maskcond)
  store volatile i64 0, i64* %ptr, align 8
  br i1 %c, label %true2, label %false2

false1:                                           ; preds = %0
  store volatile i64 1, i64* %ptr, align 4
  br label %true1

true2:                                            ; preds = %true1
  store volatile i64 2, i64* %ptr, align 8
  ret void

false2:                                           ; preds = %true1
  store volatile i64 3, i64* %ptr, align 8
  ret void
}

; FIXME: SimplifyCFG is doing something weird here. It should have split the
; blocks like in the test above, but instead it creates .pr Phi node which
; only complicates things.
define void @test_02(i1 %c, i64* align 1 %ptr) local_unnamed_addr #0 {
; CHECK-LABEL: @test_02(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[TRUE1:%.*]], label [[FALSE1:%.*]]
; CHECK:       true1:
; CHECK-NEXT:    [[C_PR:%.*]] = phi i1 [ [[C]], [[FALSE1]] ], [ true, [[TMP0:%.*]] ]
; CHECK-NEXT:    [[PTRINT:%.*]] = ptrtoint i64* [[PTR:%.*]] to i64
; CHECK-NEXT:    [[MASKEDPTR:%.*]] = and i64 [[PTRINT]], 7
; CHECK-NEXT:    [[MASKCOND:%.*]] = icmp eq i64 [[MASKEDPTR]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[MASKCOND]])
; CHECK-NEXT:    store volatile i64 0, i64* [[PTR]], align 8
; CHECK-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; CHECK-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; CHECK-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; CHECK-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; CHECK-NEXT:    store volatile i64 -1, i64* [[PTR]], align 8
; CHECK-NEXT:    br i1 [[C_PR]], label [[TRUE2:%.*]], label [[FALSE2:%.*]]
; CHECK:       false1:
; CHECK-NEXT:    store volatile i64 1, i64* [[PTR]], align 4
; CHECK-NEXT:    br label [[TRUE1]]
; CHECK:       true2:
; CHECK-NEXT:    store volatile i64 2, i64* [[PTR]], align 8
; CHECK-NEXT:    ret void
; CHECK:       false2:
; CHECK-NEXT:    store volatile i64 3, i64* [[PTR]], align 8
; CHECK-NEXT:    ret void
;
  br i1 %c, label %true1, label %false1

true1:                                            ; preds = %false1, %0
  %ptrint = ptrtoint i64* %ptr to i64
  %maskedptr = and i64 %ptrint, 7
  %maskcond = icmp eq i64 %maskedptr, 0
  tail call void @llvm.assume(i1 %maskcond)
  store volatile i64 0, i64* %ptr, align 8
  store volatile i64 -1, i64* %ptr, align 8
  store volatile i64 -1, i64* %ptr, align 8
  store volatile i64 -1, i64* %ptr, align 8
  store volatile i64 -1, i64* %ptr, align 8
  store volatile i64 -1, i64* %ptr, align 8
  br i1 %c, label %true2, label %false2

false1:                                           ; preds = %0
  store volatile i64 1, i64* %ptr, align 4
  br label %true1

true2:                                            ; preds = %true1
  store volatile i64 2, i64* %ptr, align 8
  ret void

false2:                                           ; preds = %true1
  store volatile i64 3, i64* %ptr, align 8
  ret void
}
