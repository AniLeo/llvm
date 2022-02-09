; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -passes='print<cost-model>' 2>&1 -disable-output -mtriple=powerpc64-unknown-linux-gnu -mcpu=pwr7 -mattr=+vsx | FileCheck --check-prefix=CHECK-P7 %s
; RUN: opt < %s -passes='print<cost-model>' 2>&1 -disable-output -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr8 -mattr=+vsx | FileCheck --check-prefix=CHECK-P8LE %s
; RUN: opt < %s -passes='print<cost-model>' 2>&1 -disable-output -mtriple=powerpc64-unknown-linux-gnu -mcpu=pwr9 -mattr=+vsx | FileCheck --check-prefix=CHECK-P9BE %s
; RUN: opt < %s -passes='print<cost-model>' 2>&1 -disable-output -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr9 -mattr=+vsx | FileCheck --check-prefix=CHECK-P9LE %s

target datalayout = "E-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-f128:128:128-v128:128:128-n32:64"
target triple = "powerpc64-unknown-linux-gnu"

define i32 @insert(i32 %arg) {
  ; CHECK: cost of 10 {{.*}} insertelement
; CHECK-P7-LABEL: 'insert'
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %x = insertelement <4 x i32> undef, i32 %arg, i32 0
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; CHECK-P8LE-LABEL: 'insert'
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %x = insertelement <4 x i32> undef, i32 %arg, i32 0
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; CHECK-P9BE-LABEL: 'insert'
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %x = insertelement <4 x i32> undef, i32 %arg, i32 0
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; CHECK-P9LE-LABEL: 'insert'
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %x = insertelement <4 x i32> undef, i32 %arg, i32 0
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %x = insertelement <4 x i32> undef, i32 %arg, i32 0
  ret i32 undef
}

define i32 @extract(<4 x i32> %arg) {
  ; CHECK: cost of 3 {{.*}} extractelement
; CHECK-P7-LABEL: 'extract'
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %x = extractelement <4 x i32> %arg, i32 0
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %x
;
; CHECK-P8LE-LABEL: 'extract'
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %x = extractelement <4 x i32> %arg, i32 0
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %x
;
; CHECK-P9BE-LABEL: 'extract'
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %x = extractelement <4 x i32> %arg, i32 0
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %x
;
; CHECK-P9LE-LABEL: 'extract'
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %x = extractelement <4 x i32> %arg, i32 0
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 %x
;
  %x = extractelement <4 x i32> %arg, i32 0
  ret i32 %x
}

define void @test2xdouble(<2 x double> %arg1) {
; CHECK-P7-LABEL: 'test2xdouble'
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v1 = extractelement <2 x double> %arg1, i32 0
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v2 = extractelement <2 x double> %arg1, i32 1
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P8LE-LABEL: 'test2xdouble'
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %v1 = extractelement <2 x double> %arg1, i32 0
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2 = extractelement <2 x double> %arg1, i32 1
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9BE-LABEL: 'test2xdouble'
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v1 = extractelement <2 x double> %arg1, i32 0
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v2 = extractelement <2 x double> %arg1, i32 1
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9LE-LABEL: 'test2xdouble'
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %v1 = extractelement <2 x double> %arg1, i32 0
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %v2 = extractelement <2 x double> %arg1, i32 1
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v1 = extractelement <2 x double> %arg1, i32 0
  %v2 = extractelement <2 x double> %arg1, i32 1
  ret void
}

define void @test4xi32(<4 x i32> %v1, i32 %x1) {
; CHECK-P7-LABEL: 'test4xi32'
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 10 for instruction: %v2 = insertelement <4 x i32> %v1, i32 %x1, i32 2
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P8LE-LABEL: 'test4xi32'
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %v2 = insertelement <4 x i32> %v1, i32 %x1, i32 2
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9BE-LABEL: 'test4xi32'
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2 = insertelement <4 x i32> %v1, i32 %x1, i32 2
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9LE-LABEL: 'test4xi32'
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %v2 = insertelement <4 x i32> %v1, i32 %x1, i32 2
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %v2 = insertelement <4 x i32> %v1, i32 %x1, i32 2
  ret void
}

define void @vexti32(<4 x i32> %p1) {
; CHECK-P7-LABEL: 'vexti32'
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i1 = extractelement <4 x i32> %p1, i32 0
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i2 = extractelement <4 x i32> %p1, i32 1
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i3 = extractelement <4 x i32> %p1, i32 2
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i4 = extractelement <4 x i32> %p1, i32 3
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P8LE-LABEL: 'vexti32'
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i1 = extractelement <4 x i32> %p1, i32 0
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i2 = extractelement <4 x i32> %p1, i32 1
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i3 = extractelement <4 x i32> %p1, i32 2
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i4 = extractelement <4 x i32> %p1, i32 3
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9BE-LABEL: 'vexti32'
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i1 = extractelement <4 x i32> %p1, i32 0
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %i2 = extractelement <4 x i32> %p1, i32 1
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i3 = extractelement <4 x i32> %p1, i32 2
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i4 = extractelement <4 x i32> %p1, i32 3
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9LE-LABEL: 'vexti32'
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i1 = extractelement <4 x i32> %p1, i32 0
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i2 = extractelement <4 x i32> %p1, i32 1
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %i3 = extractelement <4 x i32> %p1, i32 2
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i4 = extractelement <4 x i32> %p1, i32 3
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %i1 = extractelement <4 x i32> %p1, i32 0
  %i2 = extractelement <4 x i32> %p1, i32 1
  %i3 = extractelement <4 x i32> %p1, i32 2
  %i4 = extractelement <4 x i32> %p1, i32 3
  ret void
}

define void @vexti64(<2 x i64> %p1) {
; CHECK-P7-LABEL: 'vexti64'
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i1 = extractelement <2 x i64> %p1, i32 0
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i2 = extractelement <2 x i64> %p1, i32 1
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P8LE-LABEL: 'vexti64'
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i1 = extractelement <2 x i64> %p1, i32 0
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i2 = extractelement <2 x i64> %p1, i32 1
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9BE-LABEL: 'vexti64'
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %i1 = extractelement <2 x i64> %p1, i32 0
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i2 = extractelement <2 x i64> %p1, i32 1
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9LE-LABEL: 'vexti64'
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i1 = extractelement <2 x i64> %p1, i32 0
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %i2 = extractelement <2 x i64> %p1, i32 1
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %i1 = extractelement <2 x i64> %p1, i32 0
  %i2 = extractelement <2 x i64> %p1, i32 1
  ret void
}

define void @vext(<8 x i16> %p1, <16 x i8> %p2) {
; CHECK-P7-LABEL: 'vext'
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i1 = extractelement <8 x i16> %p1, i32 0
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i2 = extractelement <16 x i8> %p2, i32 0
; CHECK-P7-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P8LE-LABEL: 'vext'
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i1 = extractelement <8 x i16> %p1, i32 0
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 3 for instruction: %i2 = extractelement <16 x i8> %p2, i32 0
; CHECK-P8LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9BE-LABEL: 'vext'
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i1 = extractelement <8 x i16> %p1, i32 0
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i2 = extractelement <16 x i8> %p2, i32 0
; CHECK-P9BE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
; CHECK-P9LE-LABEL: 'vext'
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i1 = extractelement <8 x i16> %p1, i32 0
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %i2 = extractelement <16 x i8> %p2, i32 0
; CHECK-P9LE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret void
;
  %i1 = extractelement <8 x i16> %p1, i32 0
  %i2 = extractelement <16 x i8> %p2, i32 0
  ret void
}
