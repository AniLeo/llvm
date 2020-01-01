; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

define i64 @test_inbounds([0 x i32]* %base, i64 %idx) {
; CHECK-LABEL: @test_inbounds(
; CHECK-NEXT:    [[P2_IDX:%.*]] = shl nsw i64 [[IDX:%.*]], 2
; CHECK-NEXT:    ret i64 [[P2_IDX]]
;
  %p1 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 0
  %p2 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 %idx
  %i1 = ptrtoint i32* %p1 to i64
  %i2 = ptrtoint i32* %p2 to i64
  %d = sub i64 %i2, %i1
  ret i64 %d
}

define i64 @test_inbounds_nuw([0 x i32]* %base, i64 %idx) {
; CHECK-LABEL: @test_inbounds_nuw(
; CHECK-NEXT:    [[P2_IDX:%.*]] = shl nsw i64 [[IDX:%.*]], 2
; CHECK-NEXT:    ret i64 [[P2_IDX]]
;
  %p1 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 0
  %p2 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 %idx
  %i1 = ptrtoint i32* %p1 to i64
  %i2 = ptrtoint i32* %p2 to i64
  %d = sub nuw i64 %i2, %i1
  ret i64 %d
}

define i64 @test_nuw([0 x i32]* %base, i64 %idx) {
; CHECK-LABEL: @test_nuw(
; CHECK-NEXT:    [[P2_IDX:%.*]] = shl i64 [[IDX:%.*]], 2
; CHECK-NEXT:    ret i64 [[P2_IDX]]
;
  %p1 = getelementptr [0 x i32], [0 x i32]* %base, i64 0, i64 0
  %p2 = getelementptr [0 x i32], [0 x i32]* %base, i64 0, i64 %idx
  %i1 = ptrtoint i32* %p1 to i64
  %i2 = ptrtoint i32* %p2 to i64
  %d = sub nuw i64 %i2, %i1
  ret i64 %d
}

define i32 @test_inbounds_nuw_trunc([0 x i32]* %base, i64 %idx) {
; CHECK-LABEL: @test_inbounds_nuw_trunc(
; CHECK-NEXT:    [[IDX_TR:%.*]] = trunc i64 [[IDX:%.*]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = shl i32 [[IDX_TR]], 2
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %p1 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 0
  %p2 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 %idx
  %i1 = ptrtoint i32* %p1 to i64
  %i2 = ptrtoint i32* %p2 to i64
  %t1 = trunc i64 %i1 to i32
  %t2 = trunc i64 %i2 to i32
  %d = sub nuw i32 %t2, %t1
  ret i32 %d
}

define i64 @test_inbounds_nuw_swapped([0 x i32]* %base, i64 %idx) {
; CHECK-LABEL: @test_inbounds_nuw_swapped(
; CHECK-NEXT:    [[P2_IDX:%.*]] = shl nsw i64 [[IDX:%.*]], 2
; CHECK-NEXT:    [[DIFF_NEG:%.*]] = sub i64 0, [[P2_IDX]]
; CHECK-NEXT:    ret i64 [[DIFF_NEG]]
;
  %p1 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 0
  %p2 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 %idx
  %i1 = ptrtoint i32* %p2 to i64
  %i2 = ptrtoint i32* %p1 to i64
  %d = sub nuw i64 %i2, %i1
  ret i64 %d
}

; The sub and shl here could be nuw, but this is harder to handle.
define i64 @test_inbounds_nuw_two_gep([0 x i32]* %base, i64 %idx, i64 %idx2) {
; CHECK-LABEL: @test_inbounds_nuw_two_gep(
; CHECK-NEXT:    [[P2_IDX1:%.*]] = sub i64 [[IDX2:%.*]], [[IDX:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = shl i64 [[P2_IDX1]], 2
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %p1 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 %idx
  %p2 = getelementptr inbounds [0 x i32], [0 x i32]* %base, i64 0, i64 %idx2
  %i1 = ptrtoint i32* %p1 to i64
  %i2 = ptrtoint i32* %p2 to i64
  %d = sub nuw i64 %i2, %i1
  ret i64 %d
}

define i64 @test_inbounds_nuw_multi_index([0 x [2 x i32]]* %base, i64 %idx, i64 %idx2) {
; CHECK-LABEL: @test_inbounds_nuw_multi_index(
; CHECK-NEXT:    [[P2_IDX:%.*]] = shl nsw i64 [[IDX:%.*]], 3
; CHECK-NEXT:    [[P2_IDX1:%.*]] = shl nsw i64 [[IDX2:%.*]], 2
; CHECK-NEXT:    [[P2_OFFS2:%.*]] = add i64 [[P2_IDX]], [[P2_IDX1]]
; CHECK-NEXT:    ret i64 [[P2_OFFS2]]
;
  %p1 = getelementptr inbounds [0 x [2 x i32]], [0 x [2 x i32]]* %base, i64 0, i64 0, i64 0
  %p2 = getelementptr inbounds [0 x [2 x i32]], [0 x [2 x i32]]* %base, i64 0, i64 %idx, i64 %idx2
  %i1 = ptrtoint i32* %p1 to i64
  %i2 = ptrtoint i32* %p2 to i64
  %d = sub nuw i64 %i2, %i1
  ret i64 %d
}
