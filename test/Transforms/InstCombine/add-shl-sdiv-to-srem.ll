; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

define i8 @add-shl-sdiv-scalar0(i8 %x) {
; CHECK-LABEL: @add-shl-sdiv-scalar0(
; CHECK-NEXT:    [[RZ:%.*]] = srem i8 [[X:%.*]], 4
; CHECK-NEXT:    ret i8 [[RZ]]
;
  %sd = sdiv i8 %x, -4
  %sl = shl i8 %sd, 2
  %rz = add i8 %sl, %x
  ret i8 %rz
}

define i8 @add-shl-sdiv-scalar1(i8 %x) {
; CHECK-LABEL: @add-shl-sdiv-scalar1(
; CHECK-NEXT:    [[RZ:%.*]] = srem i8 [[X:%.*]], 64
; CHECK-NEXT:    ret i8 [[RZ]]
;
  %sd = sdiv i8 %x, -64
  %sl = shl i8 %sd, 6
  %rz = add i8 %sl, %x
  ret i8 %rz
}

define i32 @add-shl-sdiv-scalar2(i32 %x) {
; CHECK-LABEL: @add-shl-sdiv-scalar2(
; CHECK-NEXT:    [[RZ:%.*]] = srem i32 [[X:%.*]], 1073741824
; CHECK-NEXT:    ret i32 [[RZ]]
;
  %sd = sdiv i32 %x, -1073741824
  %sl = shl i32 %sd, 30
  %rz = add i32 %sl, %x
  ret i32 %rz
}

; Splat vectors

define <3 x i8> @add-shl-sdiv-splat0(<3 x i8> %x) {
; CHECK-LABEL: @add-shl-sdiv-splat0(
; CHECK-NEXT:    [[RZ:%.*]] = srem <3 x i8> [[X:%.*]], <i8 4, i8 4, i8 4>
; CHECK-NEXT:    ret <3 x i8> [[RZ]]
;
  %sd = sdiv <3 x i8> %x, <i8 -4, i8 -4, i8 -4>
  %sl = shl <3 x i8> %sd, <i8 2, i8 2, i8 2>
  %rz = add <3 x i8> %sl, %x
  ret <3 x i8> %rz
}

define <4 x i32> @add-shl-sdiv-splat1(<4 x i32> %x) {
; CHECK-LABEL: @add-shl-sdiv-splat1(
; CHECK-NEXT:    [[RZ:%.*]] = srem <4 x i32> [[X:%.*]], <i32 1073741824, i32 1073741824, i32 1073741824, i32 1073741824>
; CHECK-NEXT:    ret <4 x i32> [[RZ]]
;
  %sd = sdiv <4 x i32> %x, <i32 -1073741824, i32 -1073741824, i32 -1073741824, i32 -1073741824>
  %sl = shl <4 x i32> %sd, <i32 30, i32 30, i32 30, i32 30>
  %rz = add <4 x i32> %sl, %x
  ret <4 x i32> %rz
}

define <2 x i64> @add-shl-sdiv-splat2(<2 x i64> %x) {
; CHECK-LABEL: @add-shl-sdiv-splat2(
; CHECK-NEXT:    [[RZ:%.*]] = srem <2 x i64> [[X:%.*]], <i64 32, i64 32>
; CHECK-NEXT:    ret <2 x i64> [[RZ]]
;
  %sd = sdiv <2 x i64> %x, <i64 -32, i64 -32>
  %sl = shl <2 x i64> %sd, <i64 5, i64 5>
  %rz = add <2 x i64> %sl, %x
  ret <2 x i64> %rz
}

; One-use tests

declare void @use32(i32)
define i32 @add-shl-sdiv-i32-4-use0(i32 %x) {
; CHECK-LABEL: @add-shl-sdiv-i32-4-use0(
; CHECK-NEXT:    call void @use32(i32 [[X:%.*]])
; CHECK-NEXT:    [[RZ:%.*]] = srem i32 [[X]], 16
; CHECK-NEXT:    ret i32 [[RZ]]
;
  call void @use32(i32 %x)
  %sd = sdiv i32 %x, -16
  %sl = shl i32 %sd, 4
  %rz = add i32 %sl, %x
  ret i32 %rz
}

define i32 @add-shl-sdiv-i32-use1(i32 %x) {
; CHECK-LABEL: @add-shl-sdiv-i32-use1(
; CHECK-NEXT:    [[SD:%.*]] = sdiv i32 [[X:%.*]], -16
; CHECK-NEXT:    call void @use32(i32 [[SD]])
; CHECK-NEXT:    [[RZ:%.*]] = srem i32 [[X]], 16
; CHECK-NEXT:    ret i32 [[RZ]]
;
  %sd = sdiv i32 %x, -16
  call void @use32(i32 %sd)
  %sl = shl i32 %sd, 4
  %rz = add i32 %sl, %x
  ret i32 %rz
}

define i32 @add-shl-sdiv-i32-use2(i32 %x) {
; CHECK-LABEL: @add-shl-sdiv-i32-use2(
; CHECK-NEXT:    [[SD:%.*]] = sdiv i32 [[X:%.*]], -16
; CHECK-NEXT:    [[SL:%.*]] = shl i32 [[SD]], 4
; CHECK-NEXT:    call void @use32(i32 [[SL]])
; CHECK-NEXT:    [[RZ:%.*]] = srem i32 [[X]], 16
; CHECK-NEXT:    ret i32 [[RZ]]
;
  %sd = sdiv i32 %x, -16
  %sl = shl i32 %sd, 4
  call void @use32(i32 %sl)
  %rz = add i32 %sl, %x
  ret i32 %rz
}

define i32 @add-shl-sdiv-i32-use3(i32 %x) {
; CHECK-LABEL: @add-shl-sdiv-i32-use3(
; CHECK-NEXT:    [[SD:%.*]] = sdiv i32 [[X:%.*]], -16
; CHECK-NEXT:    call void @use32(i32 [[SD]])
; CHECK-NEXT:    [[SL:%.*]] = shl i32 [[SD]], 4
; CHECK-NEXT:    call void @use32(i32 [[SL]])
; CHECK-NEXT:    [[RZ:%.*]] = srem i32 [[X]], 16
; CHECK-NEXT:    ret i32 [[RZ]]
;
  %sd = sdiv i32 %x, -16
  call void @use32(i32 %sd)
  %sl = shl i32 %sd, 4
  call void @use32(i32 %sl)
  %rz = add i32 %sl, %x
  ret i32 %rz
}

declare void @use3xi8(<3 x i8>)
define <3 x i8> @add-shl-sdiv-use4(<3 x i8> %x) {
; CHECK-LABEL: @add-shl-sdiv-use4(
; CHECK-NEXT:    [[SD:%.*]] = sdiv <3 x i8> [[X:%.*]], <i8 -4, i8 -4, i8 -4>
; CHECK-NEXT:    call void @use3xi8(<3 x i8> [[SD]])
; CHECK-NEXT:    [[RZ:%.*]] = srem <3 x i8> [[X]], <i8 4, i8 4, i8 4>
; CHECK-NEXT:    ret <3 x i8> [[RZ]]
;
  %sd = sdiv <3 x i8> %x, <i8 -4, i8 -4, i8 -4>
  call void @use3xi8(<3 x i8> %sd)
  %sl = shl <3 x i8> %sd, <i8 2, i8 2, i8 2>
  %rz = add <3 x i8> %sl, %x
  ret <3 x i8> %rz
}

; Negative

define i8 @add-shl-sdiv-negative0(i8 %x) {
; CHECK-LABEL: @add-shl-sdiv-negative0(
; CHECK-NEXT:    [[SD:%.*]] = sdiv i8 [[X:%.*]], 4
; CHECK-NEXT:    [[SL:%.*]] = shl nsw i8 [[SD]], 2
; CHECK-NEXT:    [[RZ:%.*]] = add i8 [[SL]], [[X]]
; CHECK-NEXT:    ret i8 [[RZ]]
;
  %sd = sdiv i8 %x, 4
  %sl = shl i8 %sd, 2
  %rz = add i8 %sl, %x
  ret i8 %rz
}

define i32 @add-shl-sdiv-negative1(i32 %x) {
; CHECK-LABEL: @add-shl-sdiv-negative1(
; CHECK-NEXT:    [[RZ:%.*]] = sub i32 0, [[X:%.*]]
; CHECK-NEXT:    ret i32 [[RZ]]
;
  %sd = sdiv i32 %x, -1
  %sl = shl i32 %sd, 1
  %rz = add i32 %sl, %x
  ret i32 %rz
}

define i32 @add-shl-sdiv-negative2(i32 %x) {
; CHECK-LABEL: @add-shl-sdiv-negative2(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i32 [[X:%.*]], -2147483648
; CHECK-NEXT:    [[SL:%.*]] = select i1 [[TMP1]], i32 -2147483648, i32 0
; CHECK-NEXT:    [[RZ:%.*]] = add i32 [[SL]], [[X]]
; CHECK-NEXT:    ret i32 [[RZ]]
;
  %sd = sdiv i32 %x, -2147483648
  %sl = shl i32 %sd, 31
  %rz = add i32 %sl, %x
  ret i32 %rz
}

define <3 x i8> @add-shl-sdiv-negative3(<3 x i8> %x) {
; CHECK-LABEL: @add-shl-sdiv-negative3(
; CHECK-NEXT:    [[SD:%.*]] = sdiv <3 x i8> [[X:%.*]], <i8 -5, i8 -5, i8 -5>
; CHECK-NEXT:    [[SL:%.*]] = shl <3 x i8> [[SD]], <i8 2, i8 2, i8 2>
; CHECK-NEXT:    [[RZ:%.*]] = add <3 x i8> [[SL]], [[X]]
; CHECK-NEXT:    ret <3 x i8> [[RZ]]
;
  %sd = sdiv <3 x i8> %x, <i8 -5, i8 -5, i8 -5>
  %sl = shl <3 x i8> %sd, <i8 2, i8 2, i8 2>
  %rz = add <3 x i8> %sl, %x
  ret <3 x i8> %rz
}

define <2 x i64> @add-shl-sdiv-negative4(<2 x i64> %x) {
; CHECK-LABEL: @add-shl-sdiv-negative4(
; CHECK-NEXT:    ret <2 x i64> poison
;
  %sd = sdiv <2 x i64> %x, <i64 32, i64 32>
  %sl = shl <2 x i64> %sd, <i64 -5, i64 -5>
  %rz = add <2 x i64> %sl, %x
  ret <2 x i64> %rz
}

; Vectors with undef values

define <3 x i8> @add-shl-sdiv-3xi8-undef0(<3 x i8> %x) {
; CHECK-LABEL: @add-shl-sdiv-3xi8-undef0(
; CHECK-NEXT:    ret <3 x i8> poison
;
  %sd = sdiv <3 x i8> %x, <i8 -4, i8 undef, i8 -4>
  %sl = shl <3 x i8> %sd, <i8 2, i8 2, i8 2>
  %rz = add <3 x i8> %sl, %x
  ret <3 x i8> %rz
}

define <3 x i8> @add-shl-sdiv-3xi8-undef1(<3 x i8> %x) {
; CHECK-LABEL: @add-shl-sdiv-3xi8-undef1(
; CHECK-NEXT:    [[SD:%.*]] = sdiv <3 x i8> [[X:%.*]], <i8 -4, i8 -4, i8 -4>
; CHECK-NEXT:    [[SL:%.*]] = shl <3 x i8> [[SD]], <i8 2, i8 undef, i8 2>
; CHECK-NEXT:    [[RZ:%.*]] = add <3 x i8> [[SL]], [[X]]
; CHECK-NEXT:    ret <3 x i8> [[RZ]]
;
  %sd = sdiv <3 x i8> %x, <i8 -4, i8 -4, i8 -4>
  %sl = shl <3 x i8> %sd, <i8 2, i8 undef, i8 2>
  %rz = add <3 x i8> %sl, %x
  ret <3 x i8> %rz
}

; Non-splat vectors

define <2 x i64> @add-shl-sdiv-nonsplat0(<2 x i64> %x) {
; CHECK-LABEL: @add-shl-sdiv-nonsplat0(
; CHECK-NEXT:    [[SD:%.*]] = sdiv <2 x i64> [[X:%.*]], <i64 -32, i64 -64>
; CHECK-NEXT:    [[SL:%.*]] = shl <2 x i64> [[SD]], <i64 5, i64 6>
; CHECK-NEXT:    [[RZ:%.*]] = add <2 x i64> [[SL]], [[X]]
; CHECK-NEXT:    ret <2 x i64> [[RZ]]
;
  %sd = sdiv <2 x i64> %x, <i64 -32, i64 -64>
  %sl = shl <2 x i64> %sd, <i64 5, i64 6>
  %rz = add <2 x i64> %sl, %x
  ret <2 x i64> %rz
}

define <3 x i8> @add-shl-sdiv-nonsplat1(<3 x i8> %x) {
; CHECK-LABEL: @add-shl-sdiv-nonsplat1(
; CHECK-NEXT:    [[SD:%.*]] = sdiv <3 x i8> [[X:%.*]], <i8 -4, i8 -4, i8 -4>
; CHECK-NEXT:    [[SL:%.*]] = shl <3 x i8> [[SD]], <i8 2, i8 2, i8 3>
; CHECK-NEXT:    [[RZ:%.*]] = add <3 x i8> [[SL]], [[X]]
; CHECK-NEXT:    ret <3 x i8> [[RZ]]
;
  %sd = sdiv <3 x i8> %x, <i8 -4, i8 -4, i8 -4>
  %sl = shl <3 x i8> %sd, <i8 2, i8 2, i8 3>
  %rz = add <3 x i8> %sl, %x
  ret <3 x i8> %rz
}
