; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instsimplify -S | FileCheck %s

; Here we subtract two values, check that subtraction did not overflow AND
; that the result is non-zero. This can be simplified just to a comparison
; between the base and offset.

define i1 @t0(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t0(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i64 [[ADJUSTED]], [[BASE]]
; CHECK-NEXT:    ret i1 [[NO_UNDERFLOW]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  %no_underflow = icmp uge i64 %adjusted, %base
  %not_null = icmp ne i64 %adjusted, 0
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t1(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t1(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ult i64 [[ADJUSTED]], [[BASE]]
; CHECK-NEXT:    ret i1 [[NO_UNDERFLOW]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  %no_underflow = icmp ult i64 %adjusted, %base
  %not_null = icmp eq i64 %adjusted, 0
  %r = or i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t2_commutative(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t2_commutative(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ule i64 [[BASE]], [[ADJUSTED]]
; CHECK-NEXT:    ret i1 [[NO_UNDERFLOW]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  %no_underflow = icmp ule i64 %base, %adjusted
  %not_null = icmp ne i64 %adjusted, 0
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}

define i1 @t3_commutative(i64 %base, i64* nonnull %offsetptr) {
; CHECK-LABEL: @t3_commutative(
; CHECK-NEXT:    [[OFFSET:%.*]] = ptrtoint i64* [[OFFSETPTR:%.*]] to i64
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET]]
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp ugt i64 [[BASE]], [[ADJUSTED]]
; CHECK-NEXT:    ret i1 [[NO_UNDERFLOW]]
;
  %offset = ptrtoint i64* %offsetptr to i64

  %adjusted = sub i64 %base, %offset
  %no_underflow = icmp ugt i64 %base, %adjusted
  %not_null = icmp eq i64 %adjusted, 0
  %r = or i1 %not_null, %no_underflow
  ret i1 %r
}

; We don't know that offset is non-zero, so we can't fold.
define i1 @t4_bad(i64 %base, i64 %offset) {
; CHECK-LABEL: @t4_bad(
; CHECK-NEXT:    [[ADJUSTED:%.*]] = sub i64 [[BASE:%.*]], [[OFFSET:%.*]]
; CHECK-NEXT:    [[NO_UNDERFLOW:%.*]] = icmp uge i64 [[ADJUSTED]], [[BASE]]
; CHECK-NEXT:    [[NOT_NULL:%.*]] = icmp ne i64 [[ADJUSTED]], 0
; CHECK-NEXT:    [[R:%.*]] = and i1 [[NOT_NULL]], [[NO_UNDERFLOW]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %adjusted = sub i64 %base, %offset
  %no_underflow = icmp uge i64 %adjusted, %base
  %not_null = icmp ne i64 %adjusted, 0
  %r = and i1 %not_null, %no_underflow
  ret i1 %r
}
