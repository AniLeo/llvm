; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S -data-layout="E-n64" | FileCheck %s --check-prefixes=ALL
; RUN: opt < %s -instcombine -S -data-layout="e-n64" | FileCheck %s --check-prefixes=ALL

declare void @use(<2 x i8>)

define i16 @insert0_v2i8(i16 %x, i8 %y) {
; ALL-LABEL: @insert0_v2i8(
; ALL-NEXT:    [[V:%.*]] = bitcast i16 [[X:%.*]] to <2 x i8>
; ALL-NEXT:    [[I:%.*]] = insertelement <2 x i8> [[V]], i8 [[Y:%.*]], i8 0
; ALL-NEXT:    [[R:%.*]] = bitcast <2 x i8> [[I]] to i16
; ALL-NEXT:    ret i16 [[R]]
;
  %v = bitcast i16 %x to <2 x i8>
  %i = insertelement <2 x i8> %v, i8 %y, i8 0
  %r = bitcast <2 x i8> %i to i16
  ret i16 %r
}

define i16 @insert1_v2i8(i16 %x, i8 %y) {
; ALL-LABEL: @insert1_v2i8(
; ALL-NEXT:    [[V:%.*]] = bitcast i16 [[X:%.*]] to <2 x i8>
; ALL-NEXT:    [[I:%.*]] = insertelement <2 x i8> [[V]], i8 [[Y:%.*]], i8 1
; ALL-NEXT:    [[R:%.*]] = bitcast <2 x i8> [[I]] to i16
; ALL-NEXT:    ret i16 [[R]]
;
  %v = bitcast i16 %x to <2 x i8>
  %i = insertelement <2 x i8> %v, i8 %y, i8 1
  %r = bitcast <2 x i8> %i to i16
  ret i16 %r
}

define i32 @insert0_v4i8(i32 %x, i8 %y) {
; ALL-LABEL: @insert0_v4i8(
; ALL-NEXT:    [[V:%.*]] = bitcast i32 [[X:%.*]] to <4 x i8>
; ALL-NEXT:    [[I:%.*]] = insertelement <4 x i8> [[V]], i8 [[Y:%.*]], i8 0
; ALL-NEXT:    [[R:%.*]] = bitcast <4 x i8> [[I]] to i32
; ALL-NEXT:    ret i32 [[R]]
;
  %v = bitcast i32 %x to <4 x i8>
  %i = insertelement <4 x i8> %v, i8 %y, i8 0
  %r = bitcast <4 x i8> %i to i32
  ret i32 %r
}

define i64 @insert0_v4i16(i64 %x, i16 %y) {
; ALL-LABEL: @insert0_v4i16(
; ALL-NEXT:    [[V:%.*]] = bitcast i64 [[X:%.*]] to <4 x i16>
; ALL-NEXT:    [[I:%.*]] = insertelement <4 x i16> [[V]], i16 [[Y:%.*]], i8 0
; ALL-NEXT:    [[R:%.*]] = bitcast <4 x i16> [[I]] to i64
; ALL-NEXT:    ret i64 [[R]]
;
  %v = bitcast i64 %x to <4 x i16>
  %i = insertelement <4 x i16> %v, i16 %y, i8 0
  %r = bitcast <4 x i16> %i to i64
  ret i64 %r
}

define i64 @insert1_v4i16(i64 %x, i16 %y) {
; ALL-LABEL: @insert1_v4i16(
; ALL-NEXT:    [[V:%.*]] = bitcast i64 [[X:%.*]] to <4 x i16>
; ALL-NEXT:    [[I:%.*]] = insertelement <4 x i16> [[V]], i16 [[Y:%.*]], i8 1
; ALL-NEXT:    [[R:%.*]] = bitcast <4 x i16> [[I]] to i64
; ALL-NEXT:    ret i64 [[R]]
;
  %v = bitcast i64 %x to <4 x i16>
  %i = insertelement <4 x i16> %v, i16 %y, i8 1
  %r = bitcast <4 x i16> %i to i64
  ret i64 %r
}

define i64 @insert3_v4i16(i64 %x, i16 %y) {
; ALL-LABEL: @insert3_v4i16(
; ALL-NEXT:    [[V:%.*]] = bitcast i64 [[X:%.*]] to <4 x i16>
; ALL-NEXT:    [[I:%.*]] = insertelement <4 x i16> [[V]], i16 [[Y:%.*]], i8 3
; ALL-NEXT:    [[R:%.*]] = bitcast <4 x i16> [[I]] to i64
; ALL-NEXT:    ret i64 [[R]]
;
  %v = bitcast i64 %x to <4 x i16>
  %i = insertelement <4 x i16> %v, i16 %y, i8 3
  %r = bitcast <4 x i16> %i to i64
  ret i64 %r
}

define i128 @insert0_v4i32(i128 %x, i32 %y) {
; ALL-LABEL: @insert0_v4i32(
; ALL-NEXT:    [[V:%.*]] = bitcast i128 [[X:%.*]] to <4 x i32>
; ALL-NEXT:    [[I:%.*]] = insertelement <4 x i32> [[V]], i32 [[Y:%.*]], i8 0
; ALL-NEXT:    [[R:%.*]] = bitcast <4 x i32> [[I]] to i128
; ALL-NEXT:    ret i128 [[R]]
;
  %v = bitcast i128 %x to <4 x i32>
  %i = insertelement <4 x i32> %v, i32 %y, i8 0
  %r = bitcast <4 x i32> %i to i128
  ret i128 %r
}

define i16 @insert0_v2i8_use1(i16 %x, i8 %y) {
; ALL-LABEL: @insert0_v2i8_use1(
; ALL-NEXT:    [[V:%.*]] = bitcast i16 [[X:%.*]] to <2 x i8>
; ALL-NEXT:    call void @use(<2 x i8> [[V]])
; ALL-NEXT:    [[I:%.*]] = insertelement <2 x i8> [[V]], i8 [[Y:%.*]], i8 0
; ALL-NEXT:    [[R:%.*]] = bitcast <2 x i8> [[I]] to i16
; ALL-NEXT:    ret i16 [[R]]
;
  %v = bitcast i16 %x to <2 x i8>
  call void @use(<2 x i8> %v)
  %i = insertelement <2 x i8> %v, i8 %y, i8 0
  %r = bitcast <2 x i8> %i to i16
  ret i16 %r
}

define i16 @insert0_v2i8_use2(i16 %x, i8 %y) {
; ALL-LABEL: @insert0_v2i8_use2(
; ALL-NEXT:    [[V:%.*]] = bitcast i16 [[X:%.*]] to <2 x i8>
; ALL-NEXT:    [[I:%.*]] = insertelement <2 x i8> [[V]], i8 [[Y:%.*]], i8 0
; ALL-NEXT:    call void @use(<2 x i8> [[I]])
; ALL-NEXT:    [[R:%.*]] = bitcast <2 x i8> [[I]] to i16
; ALL-NEXT:    ret i16 [[R]]
;
  %v = bitcast i16 %x to <2 x i8>
  %i = insertelement <2 x i8> %v, i8 %y, i8 0
  call void @use(<2 x i8> %i)
  %r = bitcast <2 x i8> %i to i16
  ret i16 %r
}
