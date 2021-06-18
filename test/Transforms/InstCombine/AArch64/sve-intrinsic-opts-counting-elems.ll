; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

;
; CNTB
;

define i64 @cntb_vl1() {
; CHECK-LABEL: @cntb_vl1(
; CHECK-NEXT:    ret i64 1
;
  %out = call i64 @llvm.aarch64.sve.cntb(i32 1)
  ret i64 %out
}

define i64 @cntb_vl2() {
; CHECK-LABEL: @cntb_vl2(
; CHECK-NEXT:    ret i64 2
;
  %out = call i64 @llvm.aarch64.sve.cntb(i32 2)
  ret i64 %out
}

define i64 @cntb_vl4() {
; CHECK-LABEL: @cntb_vl4(
; CHECK-NEXT:    ret i64 4
;
  %out = call i64 @llvm.aarch64.sve.cntb(i32 4)
  ret i64 %out
}

define i64 @cntb_mul3() {
; CHECK-LABEL: @cntb_mul3(
; CHECK-NEXT:    ret i64 24
;
  %cnt = call i64 @llvm.aarch64.sve.cntb(i32 8)
  %out = mul i64 %cnt, 3
  ret i64 %out
}

define i64 @cntb_mul4() {
; CHECK-LABEL: @cntb_mul4(
; CHECK-NEXT:    ret i64 64
;
  %cnt = call i64 @llvm.aarch64.sve.cntb(i32 9)
  %out = mul i64 %cnt, 4
  ret i64 %out
}

define i64 @cntb_all() {
; CHECK-LABEL: @cntb_all(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[OUT:%.*]] = shl i64 [[TMP1]], 4
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %out = call i64 @llvm.aarch64.sve.cntb(i32 31)
  ret i64 %out
}

;
; CNTH
;

define i64 @cnth_vl1() {
; CHECK-LABEL: @cnth_vl1(
; CHECK-NEXT:    ret i64 1
;
  %out = call i64 @llvm.aarch64.sve.cnth(i32 1)
  ret i64 %out
}

define i64 @cnth_vl2() {
; CHECK-LABEL: @cnth_vl2(
; CHECK-NEXT:    ret i64 2
;
  %out = call i64 @llvm.aarch64.sve.cnth(i32 2)
  ret i64 %out
}

define i64 @cnth_vl4() {
; CHECK-LABEL: @cnth_vl4(
; CHECK-NEXT:    ret i64 4
;
  %out = call i64 @llvm.aarch64.sve.cnth(i32 4)
  ret i64 %out
}

define i64 @cnth_mul3() {
; CHECK-LABEL: @cnth_mul3(
; CHECK-NEXT:    ret i64 24
;
  %cnt = call i64 @llvm.aarch64.sve.cnth(i32 8)
  %out = mul i64 %cnt, 3
  ret i64 %out
}

define i64 @cnth_mul4() {
; CHECK-LABEL: @cnth_mul4(
; CHECK-NEXT:    [[CNT:%.*]] = call i64 @llvm.aarch64.sve.cnth(i32 9)
; CHECK-NEXT:    [[OUT:%.*]] = shl i64 [[CNT]], 2
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %cnt = call i64 @llvm.aarch64.sve.cnth(i32 9)
  %out = mul i64 %cnt, 4
  ret i64 %out
}

define i64 @cnth_all() {
; CHECK-LABEL: @cnth_all(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[OUT:%.*]] = shl i64 [[TMP1]], 3
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %out = call i64 @llvm.aarch64.sve.cnth(i32 31)
  ret i64 %out
}

;
; CNTW
;

define i64 @cntw_vl1() {
; CHECK-LABEL: @cntw_vl1(
; CHECK-NEXT:    ret i64 1
;
  %out = call i64 @llvm.aarch64.sve.cntw(i32 1)
  ret i64 %out
}

define i64 @cntw_vl2() {
; CHECK-LABEL: @cntw_vl2(
; CHECK-NEXT:    ret i64 2
;
  %out = call i64 @llvm.aarch64.sve.cntw(i32 2)
  ret i64 %out
}

define i64 @cntw_vl4() {
; CHECK-LABEL: @cntw_vl4(
; CHECK-NEXT:    ret i64 4
;
  %out = call i64 @llvm.aarch64.sve.cntw(i32 4)
  ret i64 %out
}

define i64 @cntw_mul3() {
; CHECK-LABEL: @cntw_mul3(
; CHECK-NEXT:    [[CNT:%.*]] = call i64 @llvm.aarch64.sve.cntw(i32 8)
; CHECK-NEXT:    [[OUT:%.*]] = mul i64 [[CNT]], 3
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %cnt = call i64 @llvm.aarch64.sve.cntw(i32 8)
  %out = mul i64 %cnt, 3
  ret i64 %out
}

define i64 @cntw_mul4() {
; CHECK-LABEL: @cntw_mul4(
; CHECK-NEXT:    [[CNT:%.*]] = call i64 @llvm.aarch64.sve.cntw(i32 9)
; CHECK-NEXT:    [[OUT:%.*]] = shl i64 [[CNT]], 2
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %cnt = call i64 @llvm.aarch64.sve.cntw(i32 9)
  %out = mul i64 %cnt, 4
  ret i64 %out
}

define i64 @cntw_all() {
; CHECK-LABEL: @cntw_all(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[OUT:%.*]] = shl i64 [[TMP1]], 2
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %out = call i64 @llvm.aarch64.sve.cntw(i32 31)
  ret i64 %out
}


;
; CNTD
;

define i64 @cntd_vl1() {
; CHECK-LABEL: @cntd_vl1(
; CHECK-NEXT:    ret i64 1
;
  %out = call i64 @llvm.aarch64.sve.cntd(i32 1)
  ret i64 %out
}

define i64 @cntd_vl2() {
; CHECK-LABEL: @cntd_vl2(
; CHECK-NEXT:    ret i64 2
;
  %out = call i64 @llvm.aarch64.sve.cntd(i32 2)
  ret i64 %out
}

define i64 @cntd_vl4() {
; CHECK-LABEL: @cntd_vl4(
; CHECK-NEXT:    [[OUT:%.*]] = call i64 @llvm.aarch64.sve.cntd(i32 4)
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %out = call i64 @llvm.aarch64.sve.cntd(i32 4)
  ret i64 %out
}

define i64 @cntd_mul3() {
; CHECK-LABEL: @cntd_mul3(
; CHECK-NEXT:    [[CNT:%.*]] = call i64 @llvm.aarch64.sve.cntd(i32 8)
; CHECK-NEXT:    [[OUT:%.*]] = mul i64 [[CNT]], 3
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %cnt = call i64 @llvm.aarch64.sve.cntd(i32 8)
  %out = mul i64 %cnt, 3
  ret i64 %out
}

define i64 @cntd_mul4() {
; CHECK-LABEL: @cntd_mul4(
; CHECK-NEXT:    [[CNT:%.*]] = call i64 @llvm.aarch64.sve.cntd(i32 9)
; CHECK-NEXT:    [[OUT:%.*]] = shl i64 [[CNT]], 2
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %cnt = call i64 @llvm.aarch64.sve.cntd(i32 9)
  %out = mul i64 %cnt, 4
  ret i64 %out
}

define i64 @cntd_all() {
; CHECK-LABEL: @cntd_all(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[OUT:%.*]] = shl i64 [[TMP1]], 1
; CHECK-NEXT:    ret i64 [[OUT]]
;
  %out = call i64 @llvm.aarch64.sve.cntd(i32 31)
  ret i64 %out
}


declare i64 @llvm.aarch64.sve.cntb(i32 %pattern)
declare i64 @llvm.aarch64.sve.cnth(i32 %pattern)
declare i64 @llvm.aarch64.sve.cntw(i32 %pattern)
declare i64 @llvm.aarch64.sve.cntd(i32 %pattern)

