; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -O2                   -S -data-layout="e" < %s | FileCheck %s
; RUN: opt -passes='default<O2>' -S -data-layout="e" < %s | FileCheck %s

define <4 x i16> @truncate(<4 x i32> %x) {
; CHECK-LABEL: @truncate(
; CHECK-NEXT:    [[V3:%.*]] = trunc <4 x i32> [[X:%.*]] to <4 x i16>
; CHECK-NEXT:    ret <4 x i16> [[V3]]
;
  %x0 = extractelement <4 x i32> %x, i32 0
  %t0 = trunc i32 %x0 to i16
  %v0 = insertelement <4 x i16> poison, i16 %t0, i32 0
  %x1 = extractelement <4 x i32> %x, i32 1
  %t1 = trunc i32 %x1 to i16
  %v1 = insertelement <4 x i16> %v0, i16 %t1, i32 1
  %x2 = extractelement <4 x i32> %x, i32 2
  %t2 = trunc i32 %x2 to i16
  %v2 = insertelement <4 x i16> %v1, i16 %t2, i32 2
  %x3 = extractelement <4 x i32> %x, i32 3
  %t3 = trunc i32 %x3 to i16
  %v3 = insertelement <4 x i16> %v2, i16 %t3, i32 3
  ret <4 x i16> %v3
}
