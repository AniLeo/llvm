; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -S | FileCheck %s

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"

define void @second_store_smaller_1(i32* noalias %P, i1 %c) {
; CHECK-LABEL: @second_store_smaller_1(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[P_I16:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    store i16 0, i16* [[P_I16]], align 2
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  %P.i16 = bitcast i32* %P to i16*
  store i16 0, i16* %P.i16
  ret void
}

define void @second_store_smaller_2(i32* noalias %P, i1 %c) {
; CHECK-LABEL: @second_store_smaller_2(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[P_I16:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    store i16 12345, i16* [[P_I16]], align 2
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  %P.i16 = bitcast i32* %P to i16*
  store i16 12345, i16* %P.i16
  ret void
}

declare void @use(i16) readnone
declare void @use.i8(i8) readnone

define void @second_store_smaller_3(i32* noalias %P, i1 %c) {
; CHECK-LABEL: @second_store_smaller_3(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[P_I16:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[L1:%.*]] = load i16, i16* [[P_I16]], align 2
; CHECK-NEXT:    call void @use(i16 [[L1]])
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i16 -31073, i16* [[P_I16]], align 2
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  %P.i16 = bitcast i32* %P to i16*
  br i1 %c, label %bb1, label %bb2

bb1:
  %l1 = load i16, i16* %P.i16
  call void @use(i16 %l1)
  br label %bb3
bb2:
  br label %bb3
bb3:
  store i16 -31073, i16* %P.i16
  ret void
}

define void @second_store_smaller_4(i32* noalias %P, i1 %c) {
; CHECK-LABEL: @second_store_smaller_4(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    [[P_I8:%.*]] = bitcast i32* [[P]] to i8*
; CHECK-NEXT:    [[L1:%.*]] = load i8, i8* [[P_I8]], align 1
; CHECK-NEXT:    call void @use.i8(i8 [[L1]])
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[P_I16:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    store i16 -31073, i16* [[P_I16]], align 2
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c, label %bb1, label %bb2

bb1:
  %P.i8 = bitcast i32* %P to i8*
  %l1 = load i8, i8* %P.i8
  call void @use.i8(i8 %l1)
  br label %bb3
bb2:
  br label %bb3
bb3:
  %P.i16 = bitcast i32* %P to i16*
  store i16 -31073, i16* %P.i16
  ret void
}

define void @second_store_smaller_5(i32* noalias %P, i16 %x, i1 %c) {
; CHECK-LABEL: @second_store_smaller_5(
; CHECK-NEXT:    store i32 1, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[P_I16:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    store i16 [[X:%.*]], i16* [[P_I16]], align 2
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  %P.i16 = bitcast i32* %P to i16*
  store i16 %x, i16* %P.i16
  ret void
}

define void @second_store_bigger(i32* noalias %P, i1 %c) {
; CHECK-LABEL: @second_store_bigger(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    [[P_I64:%.*]] = bitcast i32* [[P:%.*]] to i64*
; CHECK-NEXT:    store i64 0, i64* [[P_I64]], align 8
; CHECK-NEXT:    ret void
;
  store i32 1, i32* %P
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  %P.i64 = bitcast i32* %P to i64*
  store i64 0, i64* %P.i64
  ret void
}
