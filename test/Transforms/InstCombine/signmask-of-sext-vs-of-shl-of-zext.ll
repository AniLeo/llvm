; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; If we zero-extend some value, and then immediately left-shift-out all the new
; sign bits, and apply a mask to keep only the sign bit (which is the original
; sign bit from before zero-extension), we might as well just sign-extend
; and apply the same signmask.

declare void @use32(i32)

; Basic pattern

define i32 @t0(i16 %x) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[X_SIGNEXT:%.*]] = sext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[R:%.*]] = and i32 [[X_SIGNEXT]], -2147483648
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = zext i16 %x to i32
  %i1 = shl i32 %i0, 16
  %r = and i32 %i1, -2147483648
  ret i32 %r
}
define i32 @t1(i8 %x) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[X_SIGNEXT:%.*]] = sext i8 [[X:%.*]] to i32
; CHECK-NEXT:    [[R:%.*]] = and i32 [[X_SIGNEXT]], -2147483648
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = zext i8 %x to i32
  %i1 = shl i32 %i0, 24
  %r = and i32 %i1, -2147483648
  ret i32 %r
}

; Some negative tests

define i32 @n2(i16 %x) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    ret i32 0
;
  %i0 = zext i16 %x to i32
  %i1 = shl i32 %i0, 15 ; undershifting
  %r = and i32 %i1, -2147483648
  ret i32 %r
}
define i32 @n3(i16 %x) {
; CHECK-LABEL: @n3(
; CHECK-NEXT:    [[I0:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[I1:%.*]] = shl i32 [[I0]], 17
; CHECK-NEXT:    [[R:%.*]] = and i32 [[I1]], -2147483648
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = zext i16 %x to i32
  %i1 = shl i32 %i0, 17 ; overshifting
  %r = and i32 %i1, -2147483648
  ret i32 %r
}
define i32 @n4(i16 %x) {
; CHECK-LABEL: @n4(
; CHECK-NEXT:    [[I0:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[I1:%.*]] = shl nuw i32 [[I0]], 16
; CHECK-NEXT:    [[R:%.*]] = and i32 [[I1]], -1073741824
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = zext i16 %x to i32
  %i1 = shl i32 %i0, 16
  %r = and i32 %i1, 3221225472 ; not a sign bit
  ret i32 %r
}

; Extra-use tests

define i32 @t5(i16 %x) {
; CHECK-LABEL: @t5(
; CHECK-NEXT:    [[I0:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    call void @use32(i32 [[I0]])
; CHECK-NEXT:    [[X_SIGNEXT:%.*]] = sext i16 [[X]] to i32
; CHECK-NEXT:    [[R:%.*]] = and i32 [[X_SIGNEXT]], -2147483648
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = zext i16 %x to i32
  call void @use32(i32 %i0)
  %i1 = shl i32 %i0, 16
  %r = and i32 %i1, -2147483648
  ret i32 %r
}
define i32 @n6(i16 %x) {
; CHECK-LABEL: @n6(
; CHECK-NEXT:    [[I0:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    [[I1:%.*]] = shl nuw i32 [[I0]], 16
; CHECK-NEXT:    call void @use32(i32 [[I1]])
; CHECK-NEXT:    [[R:%.*]] = and i32 [[I1]], -2147483648
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = zext i16 %x to i32
  %i1 = shl i32 %i0, 16 ; not one-use
  call void @use32(i32 %i1)
  %r = and i32 %i1, -2147483648
  ret i32 %r
}
define i32 @n7(i16 %x) {
; CHECK-LABEL: @n7(
; CHECK-NEXT:    [[I0:%.*]] = zext i16 [[X:%.*]] to i32
; CHECK-NEXT:    call void @use32(i32 [[I0]])
; CHECK-NEXT:    [[I1:%.*]] = shl nuw i32 [[I0]], 16
; CHECK-NEXT:    call void @use32(i32 [[I1]])
; CHECK-NEXT:    [[R:%.*]] = and i32 [[I1]], -2147483648
; CHECK-NEXT:    ret i32 [[R]]
;
  %i0 = zext i16 %x to i32 ; not one-use
  call void @use32(i32 %i0)
  %i1 = shl i32 %i0, 16 ; not one-use
  call void @use32(i32 %i1)
  %r = and i32 %i1, -2147483648
  ret i32 %r
}

; Some vector tests

define <2 x i32> @t8(<2 x i16> %x) {
; CHECK-LABEL: @t8(
; CHECK-NEXT:    [[X_SIGNEXT:%.*]] = sext <2 x i16> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[R:%.*]] = and <2 x i32> [[X_SIGNEXT]], <i32 -2147483648, i32 -2147483648>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %i0 = zext <2 x i16> %x to <2 x i32>
  %i1 = shl <2 x i32> %i0, <i32 16, i32 16>
  %r = and <2 x i32> %i1, <i32 -2147483648, i32 -2147483648>
  ret <2 x i32> %r
}
define <2 x i32> @t9(<2 x i16> %x) {
; CHECK-LABEL: @t9(
; CHECK-NEXT:    [[X_SIGNEXT:%.*]] = sext <2 x i16> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[R:%.*]] = and <2 x i32> [[X_SIGNEXT]], <i32 -2147483648, i32 undef>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %i0 = zext <2 x i16> %x to <2 x i32>
  %i1 = shl <2 x i32> %i0, <i32 16, i32 undef>
  %r = and <2 x i32> %i1, <i32 -2147483648, i32 -2147483648>
  ; Here undef can be propagated into the mask.
  ret <2 x i32> %r
}
define <2 x i32> @t10(<2 x i16> %x) {
; CHECK-LABEL: @t10(
; CHECK-NEXT:    [[X_SIGNEXT:%.*]] = sext <2 x i16> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[R:%.*]] = and <2 x i32> [[X_SIGNEXT]], <i32 -2147483648, i32 0>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %i0 = zext <2 x i16> %x to <2 x i32>
  %i1 = shl <2 x i32> %i0, <i32 16, i32 16>
  %r = and <2 x i32> %i1, <i32 -2147483648, i32 undef>
  ; CAREFUL! We can't keep undef mask here, since high bits are no longer zero,
  ; we must sanitize it to 0.
  ret <2 x i32> %r
}
define <2 x i32> @t11(<2 x i16> %x) {
; CHECK-LABEL: @t11(
; CHECK-NEXT:    [[X_SIGNEXT:%.*]] = sext <2 x i16> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[R:%.*]] = and <2 x i32> [[X_SIGNEXT]], <i32 -2147483648, i32 undef>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %i0 = zext <2 x i16> %x to <2 x i32>
  %i1 = shl <2 x i32> %i0, <i32 16, i32 undef>
  %r = and <2 x i32> %i1, <i32 -2147483648, i32 undef>
  ; Here undef mask is fine.
  ret <2 x i32> %r
}
