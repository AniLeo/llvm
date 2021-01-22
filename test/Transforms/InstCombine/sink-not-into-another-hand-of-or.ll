; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

; Transform
;   z = (~x) | y
; into:
;   z = ~(x & (~y))
; iff y is free to invert and all uses of z can be freely updated.

declare void @use1(i1)

; Most basic positive test
define i32 @t0(i1 %i0, i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = and i1 [[I1]], [[I0:%.*]]
; CHECK-NEXT:    [[I4:%.*]] = select i1 [[TMP1]], i32 [[V3:%.*]], i32 [[V2:%.*]]
; CHECK-NEXT:    ret i32 [[I4]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i2 = xor i1 %i0, -1
  %i3 = or i1 %i2, %i1
  %i4 = select i1 %i3, i32 %v2, i32 %v3
  ret i32 %i4
}
define i32 @t1(i32 %v0, i32 %v1, i32 %v2, i32 %v3, i32 %v4, i32 %v5) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[I0:%.*]] = icmp eq i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I1:%.*]] = icmp ne i32 [[V2:%.*]], [[V3:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I0]])
; CHECK-NEXT:    [[TMP1:%.*]] = and i1 [[I0]], [[I1]]
; CHECK-NEXT:    [[I4:%.*]] = select i1 [[TMP1]], i32 [[V5:%.*]], i32 [[V4:%.*]]
; CHECK-NEXT:    ret i32 [[I4]]
;
  %i0 = icmp eq i32 %v0, %v1
  %i1 = icmp eq i32 %v2, %v3
  call void @use1(i1 %i0)
  %i2 = xor i1 %i0, -1
  %i3 = or i1 %i2, %i1
  %i4 = select i1 %i3, i32 %v4, i32 %v5
  ret i32 %i4
}

; All users of %i3 must be invertible
define i1 @n2(i1 %i0, i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @n2(
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = xor i1 [[I0:%.*]], true
; CHECK-NEXT:    [[I3:%.*]] = or i1 [[I1]], [[I2]]
; CHECK-NEXT:    ret i1 [[I3]]
;
  %i1 = icmp eq i32 %v0, %v1
  %i2 = xor i1 %i0, -1
  %i3 = or i1 %i2, %i1
  ret i1 %i3 ; can not be inverted
}

; %i1 must be invertible
define i32 @n3(i1 %i0, i32 %v0, i32 %v1, i32 %v2, i32 %v3) {
; CHECK-LABEL: @n3(
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    call void @use1(i1 [[I1]])
; CHECK-NEXT:    [[I2:%.*]] = xor i1 [[I0:%.*]], true
; CHECK-NEXT:    [[I3:%.*]] = or i1 [[I1]], [[I2]]
; CHECK-NEXT:    [[I4:%.*]] = select i1 [[I3]], i32 [[V2:%.*]], i32 [[V3:%.*]]
; CHECK-NEXT:    ret i32 [[I4]]
;
  %i1 = icmp eq i32 %v0, %v1 ; has extra uninvertible use
  call void @use1(i1 %i1) ; bad extra use
  %i2 = xor i1 %i0, -1
  %i3 = or i1 %i2, %i1
  %i4 = select i1 %i3, i32 %v2, i32 %v3
  ret i32 %i4
}

; FIXME: we could invert all uses of %i1 here
define i32 @n4(i1 %i0, i32 %v0, i32 %v1, i32 %v2, i32 %v3, i32 %v4, i32 %v5, i32* %dst) {
; CHECK-LABEL: @n4(
; CHECK-NEXT:    [[I1:%.*]] = icmp eq i32 [[V0:%.*]], [[V1:%.*]]
; CHECK-NEXT:    [[I2:%.*]] = select i1 [[I1]], i32 [[V2:%.*]], i32 [[V3:%.*]]
; CHECK-NEXT:    store i32 [[I2]], i32* [[DST:%.*]], align 4
; CHECK-NEXT:    [[I3:%.*]] = xor i1 [[I0:%.*]], true
; CHECK-NEXT:    [[I4:%.*]] = or i1 [[I1]], [[I3]]
; CHECK-NEXT:    [[I5:%.*]] = select i1 [[I4]], i32 [[V4:%.*]], i32 [[V5:%.*]]
; CHECK-NEXT:    ret i32 [[I5]]
;
  %i1 = icmp eq i32 %v0, %v1 ; has extra invertible use
  %i2 = select i1 %i1, i32 %v2, i32 %v3 ; invertible use
  store i32 %i2, i32* %dst
  %i3 = xor i1 %i0, -1
  %i4 = or i1 %i3, %i1
  %i5 = select i1 %i4, i32 %v4, i32 %v5
  ret i32 %i5
}
