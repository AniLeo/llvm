; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -mcpu=pwr8 < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr8 < %s | FileCheck %s
declare i32 @llvm.bitreverse.i32(i32)
define i32 @testBitReverseIntrinsicI32(i32 %arg) {
; CHECK-LABEL: testBitReverseIntrinsicI32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lis 4, -21846
; CHECK-NEXT:    lis 5, 21845
; CHECK-NEXT:    slwi 6, 3, 1
; CHECK-NEXT:    srwi 3, 3, 1
; CHECK-NEXT:    ori 4, 4, 43690
; CHECK-NEXT:    ori 5, 5, 21845
; CHECK-NEXT:    and 4, 6, 4
; CHECK-NEXT:    and 3, 3, 5
; CHECK-NEXT:    lis 5, 13107
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    lis 4, -13108
; CHECK-NEXT:    ori 5, 5, 13107
; CHECK-NEXT:    slwi 6, 3, 2
; CHECK-NEXT:    ori 4, 4, 52428
; CHECK-NEXT:    srwi 3, 3, 2
; CHECK-NEXT:    and 4, 6, 4
; CHECK-NEXT:    and 3, 3, 5
; CHECK-NEXT:    lis 5, 3855
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    lis 4, -3856
; CHECK-NEXT:    ori 5, 5, 3855
; CHECK-NEXT:    slwi 6, 3, 4
; CHECK-NEXT:    ori 4, 4, 61680
; CHECK-NEXT:    srwi 3, 3, 4
; CHECK-NEXT:    and 4, 6, 4
; CHECK-NEXT:    and 3, 3, 5
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    rotlwi 4, 3, 24
; CHECK-NEXT:    rlwimi 4, 3, 8, 8, 15
; CHECK-NEXT:    rlwimi 4, 3, 8, 24, 31
; CHECK-NEXT:    rldicl 3, 4, 0, 32
; CHECK-NEXT:    blr
  %res = call i32 @llvm.bitreverse.i32(i32 %arg)
  ret i32 %res
}

declare i64 @llvm.bitreverse.i64(i64)
define i64 @testBitReverseIntrinsicI64(i64 %arg) {
; CHECK-LABEL: testBitReverseIntrinsicI64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lis 4, -21846
; CHECK-NEXT:    lis 5, 21845
; CHECK-NEXT:    lis 6, -13108
; CHECK-NEXT:    lis 7, 13107
; CHECK-NEXT:    sldi 8, 3, 1
; CHECK-NEXT:    rldicl 3, 3, 63, 1
; CHECK-NEXT:    ori 4, 4, 43690
; CHECK-NEXT:    ori 5, 5, 21845
; CHECK-NEXT:    ori 6, 6, 52428
; CHECK-NEXT:    ori 7, 7, 13107
; CHECK-NEXT:    sldi 4, 4, 32
; CHECK-NEXT:    sldi 5, 5, 32
; CHECK-NEXT:    oris 4, 4, 43690
; CHECK-NEXT:    oris 5, 5, 21845
; CHECK-NEXT:    ori 4, 4, 43690
; CHECK-NEXT:    ori 5, 5, 21845
; CHECK-NEXT:    and 4, 8, 4
; CHECK-NEXT:    and 3, 3, 5
; CHECK-NEXT:    sldi 5, 6, 32
; CHECK-NEXT:    sldi 6, 7, 32
; CHECK-NEXT:    lis 7, 3855
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    oris 4, 5, 52428
; CHECK-NEXT:    oris 5, 6, 13107
; CHECK-NEXT:    lis 6, -3856
; CHECK-NEXT:    ori 7, 7, 3855
; CHECK-NEXT:    sldi 8, 3, 2
; CHECK-NEXT:    ori 4, 4, 52428
; CHECK-NEXT:    rldicl 3, 3, 62, 2
; CHECK-NEXT:    ori 5, 5, 13107
; CHECK-NEXT:    ori 6, 6, 61680
; CHECK-NEXT:    and 4, 8, 4
; CHECK-NEXT:    and 3, 3, 5
; CHECK-NEXT:    sldi 5, 6, 32
; CHECK-NEXT:    sldi 6, 7, 32
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    oris 4, 5, 61680
; CHECK-NEXT:    oris 5, 6, 3855
; CHECK-NEXT:    sldi 6, 3, 4
; CHECK-NEXT:    ori 4, 4, 61680
; CHECK-NEXT:    rldicl 3, 3, 60, 4
; CHECK-NEXT:    ori 5, 5, 3855
; CHECK-NEXT:    and 4, 6, 4
; CHECK-NEXT:    and 3, 3, 5
; CHECK-NEXT:    or 3, 3, 4
; CHECK-NEXT:    rldicl 4, 3, 32, 32
; CHECK-NEXT:    rlwinm 5, 3, 24, 0, 31
; CHECK-NEXT:    rlwinm 6, 4, 24, 0, 31
; CHECK-NEXT:    rlwimi 5, 3, 8, 8, 15
; CHECK-NEXT:    rlwimi 5, 3, 8, 24, 31
; CHECK-NEXT:    rlwimi 6, 4, 8, 8, 15
; CHECK-NEXT:    rlwimi 6, 4, 8, 24, 31
; CHECK-NEXT:    sldi 3, 5, 32
; CHECK-NEXT:    or 3, 3, 6
; CHECK-NEXT:    blr
  %res = call i64 @llvm.bitreverse.i64(i64 %arg)
  ret i64 %res
}
