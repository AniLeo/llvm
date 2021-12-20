; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare void @use(i8)

; Tests for slt/ult

define i1 @slt_positive_multip_rem_zero(i8 %x) {
; CHECK-LABEL: @slt_positive_multip_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp slt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, 7
  %b = icmp slt i8 %a, 21
  ret i1 %b
}

define i1 @slt_negative_multip_rem_zero(i8 %x) {
; CHECK-LABEL: @slt_negative_multip_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], -7
; CHECK-NEXT:    [[B:%.*]] = icmp slt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, -7
  %b = icmp slt i8 %a, 21
  ret i1 %b
}

define i1 @slt_positive_multip_rem_nz(i8 %x) {
; CHECK-LABEL: @slt_positive_multip_rem_nz(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp slt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, 5
  %b = icmp slt i8 %a, 21
  ret i1 %b
}

define i1 @ult_rem_zero(i8 %x) {
; CHECK-LABEL: @ult_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp ult i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 7
  %b = icmp ult i8 %a, 21
  ret i1 %b
}

define i1 @ult_rem_nz(i8 %x) {
; CHECK-LABEL: @ult_rem_nz(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp ult i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 5
  %b = icmp ult i8 %a, 21
  ret i1 %b
}

; Tests for sgt/ugt

define i1 @sgt_positive_multip_rem_zero(i8 %x) {
; CHECK-LABEL: @sgt_positive_multip_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp sgt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, 7
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @sgt_negative_multip_rem_zero(i8 %x) {
; CHECK-LABEL: @sgt_negative_multip_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], -7
; CHECK-NEXT:    [[B:%.*]] = icmp sgt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, -7
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @sgt_positive_multip_rem_nz(i8 %x) {
; CHECK-LABEL: @sgt_positive_multip_rem_nz(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp sgt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, 5
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @ugt_rem_zero(i8 %x) {
; CHECK-LABEL: @ugt_rem_zero(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp ugt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 7
  %b = icmp ugt i8 %a, 21
  ret i1 %b
}

define i1 @ugt_rem_nz(i8 %x) {
; CHECK-LABEL: @ugt_rem_nz(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp ugt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 5
  %b = icmp ugt i8 %a, 21
  ret i1 %b
}

; Tests for eq/ne

define i1 @eq_nsw_rem_zero(i8 %x) {
; CHECK-LABEL: @eq_nsw_rem_zero(
; CHECK-NEXT:    [[B:%.*]] = icmp eq i8 [[X:%.*]], -4
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, -5
  %b = icmp eq i8 %a, 20
  ret i1 %b
}

define <2 x i1> @ne_nsw_rem_zero(<2 x i8> %x) {
; CHECK-LABEL: @ne_nsw_rem_zero(
; CHECK-NEXT:    [[B:%.*]] = icmp ne <2 x i8> [[X:%.*]], <i8 -6, i8 -6>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nsw <2 x i8> %x, <i8 5, i8 5>
  %b = icmp ne <2 x i8> %a, <i8 -30, i8 -30>
  ret <2 x i1> %b
}

; TODO: Missed fold with undef.

define <2 x i1> @ne_nsw_rem_zero_undef1(<2 x i8> %x) {
; CHECK-LABEL: @ne_nsw_rem_zero_undef1(
; CHECK-NEXT:    [[A:%.*]] = mul nsw <2 x i8> [[X:%.*]], <i8 5, i8 undef>
; CHECK-NEXT:    [[B:%.*]] = icmp ne <2 x i8> [[A]], <i8 -30, i8 -30>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nsw <2 x i8> %x, <i8 5, i8 undef>
  %b = icmp ne <2 x i8> %a, <i8 -30, i8 -30>
  ret <2 x i1> %b
}

; TODO: Missed fold with undef.

define <2 x i1> @ne_nsw_rem_zero_undef2(<2 x i8> %x) {
; CHECK-LABEL: @ne_nsw_rem_zero_undef2(
; CHECK-NEXT:    [[A:%.*]] = mul nsw <2 x i8> [[X:%.*]], <i8 5, i8 5>
; CHECK-NEXT:    [[B:%.*]] = icmp ne <2 x i8> [[A]], <i8 -30, i8 undef>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nsw <2 x i8> %x, <i8 5, i8 5>
  %b = icmp ne <2 x i8> %a, <i8 -30, i8 undef>
  ret <2 x i1> %b
}

define i1 @eq_nsw_rem_zero_uses(i8 %x) {
; CHECK-LABEL: @eq_nsw_rem_zero_uses(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], -5
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[B:%.*]] = icmp eq i8 [[X]], -4
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nsw i8 %x, -5
  call void @use(i8 %a)
  %b = icmp eq i8 %a, 20
  ret i1 %b
}

; Impossible multiple should be handled by instsimplify.

define i1 @eq_nsw_rem_nz(i8 %x) {
; CHECK-LABEL: @eq_nsw_rem_nz(
; CHECK-NEXT:    ret i1 false
;
  %a = mul nsw i8 %x, 5
  %b = icmp eq i8 %a, 245
  ret i1 %b
}

; Impossible multiple should be handled by instsimplify.

define i1 @ne_nsw_rem_nz(i8 %x) {
; CHECK-LABEL: @ne_nsw_rem_nz(
; CHECK-NEXT:    ret i1 true
;
  %a = mul nsw i8 %x, 5
  %b = icmp ne i8 %a, 130
  ret i1 %b
}

define <2 x i1> @eq_nuw_rem_zero(<2 x i8> %x) {
; CHECK-LABEL: @eq_nuw_rem_zero(
; CHECK-NEXT:    [[B:%.*]] = icmp eq <2 x i8> [[X:%.*]], <i8 4, i8 4>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nuw <2 x i8> %x, <i8 5, i8 5>
  %b = icmp eq <2 x i8> %a, <i8 20, i8 20>
  ret <2 x i1> %b
}

; TODO: Missed fold with undef.

define <2 x i1> @eq_nuw_rem_zero_undef1(<2 x i8> %x) {
; CHECK-LABEL: @eq_nuw_rem_zero_undef1(
; CHECK-NEXT:    [[A:%.*]] = mul nuw <2 x i8> [[X:%.*]], <i8 undef, i8 5>
; CHECK-NEXT:    [[B:%.*]] = icmp eq <2 x i8> [[A]], <i8 20, i8 20>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nuw <2 x i8> %x, <i8 undef, i8 5>
  %b = icmp eq <2 x i8> %a, <i8 20, i8 20>
  ret <2 x i1> %b
}

; TODO: Missed fold with undef.

define <2 x i1> @eq_nuw_rem_zero_undef2(<2 x i8> %x) {
; CHECK-LABEL: @eq_nuw_rem_zero_undef2(
; CHECK-NEXT:    [[A:%.*]] = mul nuw <2 x i8> [[X:%.*]], <i8 5, i8 5>
; CHECK-NEXT:    [[B:%.*]] = icmp eq <2 x i8> [[A]], <i8 undef, i8 20>
; CHECK-NEXT:    ret <2 x i1> [[B]]
;
  %a = mul nuw <2 x i8> %x, <i8 5, i8 5>
  %b = icmp eq <2 x i8> %a, <i8 undef, i8 20>
  ret <2 x i1> %b
}

define i1 @ne_nuw_rem_zero(i8 %x) {
; CHECK-LABEL: @ne_nuw_rem_zero(
; CHECK-NEXT:    [[B:%.*]] = icmp ne i8 [[X:%.*]], 26
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 5
  %b = icmp ne i8 %a, 130
  ret i1 %b
}

define i1 @ne_nuw_rem_zero_uses(i8 %x) {
; CHECK-LABEL: @ne_nuw_rem_zero_uses(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 5
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[B:%.*]] = icmp ne i8 [[X]], 26
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul nuw i8 %x, 5
  call void @use(i8 %a)
  %b = icmp ne i8 %a, 130
  ret i1 %b
}

; Impossible multiple should be handled by instsimplify.

define i1 @eq_nuw_rem_nz(i8 %x) {
; CHECK-LABEL: @eq_nuw_rem_nz(
; CHECK-NEXT:    ret i1 false
;
  %a = mul nuw i8 %x, -5
  %b = icmp eq i8 %a, 20
  ret i1 %b
}

; Impossible multiple should be handled by instsimplify.

define i1 @ne_nuw_rem_nz(i8 %x) {
; CHECK-LABEL: @ne_nuw_rem_nz(
; CHECK-NEXT:    ret i1 true
;
  %a = mul nuw i8 %x, 5
  %b = icmp ne i8 %a, -30
  ret i1 %b
}

; Negative tests for the icmp mul folds

define i1 @sgt_positive_multip_rem_zero_nonsw(i8 %x) {
; CHECK-LABEL: @sgt_positive_multip_rem_zero_nonsw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp sgt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 7
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @ult_multip_rem_zero_nonsw(i8 %x) {
; CHECK-LABEL: @ult_multip_rem_zero_nonsw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp ult i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 7
  %b = icmp ult i8 %a, 21
  ret i1 %b
}

define i1 @ugt_rem_zero_nonuw(i8 %x) {
; CHECK-LABEL: @ugt_rem_zero_nonuw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 7
; CHECK-NEXT:    [[B:%.*]] = icmp ugt i8 [[A]], 21
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 7
  %b = icmp ugt i8 %a, 21
  ret i1 %b
}

define i1 @sgt_minnum(i8 %x) {
; CHECK-LABEL: @sgt_minnum(
; CHECK-NEXT:    ret i1 true
;
  %a = mul nsw i8 %x, 7
  %b = icmp sgt i8 %a, -128
  ret i1 %b
}

define i1 @ule_bignum(i8 %x) {
; CHECK-LABEL: @ule_bignum(
; CHECK-NEXT:    [[B:%.*]] = icmp eq i8 [[X:%.*]], 0
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 2147483647
  %b = icmp ule i8 %a, 0
  ret i1 %b
}

define i1 @sgt_mulzero(i8 %x) {
; CHECK-LABEL: @sgt_mulzero(
; CHECK-NEXT:    ret i1 false
;
  %a = mul nsw i8 %x, 0
  %b = icmp sgt i8 %a, 21
  ret i1 %b
}

define i1 @eq_rem_zero_nonuw(i8 %x) {
; CHECK-LABEL: @eq_rem_zero_nonuw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp eq i8 [[A]], 20
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 5
  %b = icmp eq i8 %a, 20
  ret i1 %b
}

define i1 @ne_rem_zero_nonuw(i8 %x) {
; CHECK-LABEL: @ne_rem_zero_nonuw(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 5
; CHECK-NEXT:    [[B:%.*]] = icmp ne i8 [[A]], 30
; CHECK-NEXT:    ret i1 [[B]]
;
  %a = mul i8 %x, 5
  %b = icmp ne i8 %a, 30
  ret i1 %b
}

define i1 @mul_constant_eq(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_constant_eq(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul i32 %x, 5
  %B = mul i32 %y, 5
  %C = icmp eq i32 %A, %B
  ret i1 %C
}

define <2 x i1> @mul_constant_ne_splat(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @mul_constant_ne_splat(
; CHECK-NEXT:    [[C:%.*]] = icmp ne <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %A = mul <2 x i32> %x, <i32 5, i32 5>
  %B = mul <2 x i32> %y, <i32 5, i32 5>
  %C = icmp ne <2 x i32> %A, %B
  ret <2 x i1> %C
}

define i1 @mul_constant_ne_extra_use1(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_constant_ne_extra_use1(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 5
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul i8 %x, 5
  call void @use(i8 %A)
  %B = mul i8 %y, 5
  %C = icmp ne i8 %A, %B
  ret i1 %C
}

define i1 @mul_constant_eq_extra_use2(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_constant_eq_extra_use2(
; CHECK-NEXT:    [[B:%.*]] = mul i8 [[Y:%.*]], 5
; CHECK-NEXT:    call void @use(i8 [[B]])
; CHECK-NEXT:    [[C:%.*]] = icmp eq i8 [[X:%.*]], [[Y]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul i8 %x, 5
  %B = mul i8 %y, 5
  call void @use(i8 %B)
  %C = icmp eq i8 %A, %B
  ret i1 %C
}

define i1 @mul_constant_ne_extra_use3(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_constant_ne_extra_use3(
; CHECK-NEXT:    [[A:%.*]] = mul i8 [[X:%.*]], 5
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[B:%.*]] = mul i8 [[Y:%.*]], 5
; CHECK-NEXT:    call void @use(i8 [[B]])
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul i8 %x, 5
  call void @use(i8 %A)
  %B = mul i8 %y, 5
  call void @use(i8 %B)
  %C = icmp ne i8 %A, %B
  ret i1 %C
}

define i1 @mul_constant_eq_nsw(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_constant_eq_nsw(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nsw i32 %x, 6
  %B = mul nsw i32 %y, 6
  %C = icmp eq i32 %A, %B
  ret i1 %C
}

define <2 x i1> @mul_constant_ne_nsw_splat(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @mul_constant_ne_nsw_splat(
; CHECK-NEXT:    [[C:%.*]] = icmp ne <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %A = mul nsw <2 x i32> %x, <i32 12, i32 12>
  %B = mul nsw <2 x i32> %y, <i32 12, i32 12>
  %C = icmp ne <2 x i32> %A, %B
  ret <2 x i1> %C
}

define i1 @mul_constant_ne_nsw_extra_use1(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_constant_ne_nsw_extra_use1(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 74
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nsw i8 %x, 74
  call void @use(i8 %A)
  %B = mul nsw i8 %y, 74
  %C = icmp ne i8 %A, %B
  ret i1 %C
}

define i1 @mul_constant_eq_nsw_extra_use2(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_constant_eq_nsw_extra_use2(
; CHECK-NEXT:    [[B:%.*]] = mul nsw i8 [[Y:%.*]], 20
; CHECK-NEXT:    call void @use(i8 [[B]])
; CHECK-NEXT:    [[C:%.*]] = icmp eq i8 [[X:%.*]], [[Y]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nsw i8 %x, 20
  %B = mul nsw i8 %y, 20
  call void @use(i8 %B)
  %C = icmp eq i8 %A, %B
  ret i1 %C
}

define i1 @mul_constant_ne_nsw_extra_use3(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_constant_ne_nsw_extra_use3(
; CHECK-NEXT:    [[A:%.*]] = mul nsw i8 [[X:%.*]], 24
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[B:%.*]] = mul nsw i8 [[Y:%.*]], 24
; CHECK-NEXT:    call void @use(i8 [[B]])
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nsw i8 %x, 24
  call void @use(i8 %A)
  %B = mul nsw i8 %y, 24
  call void @use(i8 %B)
  %C = icmp ne i8 %A, %B
  ret i1 %C
}

define i1 @mul_constant_nuw_eq(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_constant_nuw_eq(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nuw i32 %x, 22
  %B = mul nuw i32 %y, 22
  %C = icmp eq i32 %A, %B
  ret i1 %C
}

define <2 x i1> @mul_constant_ne_nuw_splat(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @mul_constant_ne_nuw_splat(
; CHECK-NEXT:    [[C:%.*]] = icmp ne <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %A = mul nuw <2 x i32> %x, <i32 10, i32 10>
  %B = mul nuw <2 x i32> %y, <i32 10, i32 10>
  %C = icmp ne <2 x i32> %A, %B
  ret <2 x i1> %C
}

define i1 @mul_constant_ne_nuw_extra_use1(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_constant_ne_nuw_extra_use1(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 6
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[X]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nuw i8 %x, 6
  call void @use(i8 %A)
  %B = mul nuw i8 %y, 6
  %C = icmp ne i8 %A, %B
  ret i1 %C
}

define i1 @mul_constant_eq_nuw_extra_use2(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_constant_eq_nuw_extra_use2(
; CHECK-NEXT:    [[B:%.*]] = mul nuw i8 [[Y:%.*]], 36
; CHECK-NEXT:    call void @use(i8 [[B]])
; CHECK-NEXT:    [[C:%.*]] = icmp eq i8 [[X:%.*]], [[Y]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nuw i8 %x, 36
  %B = mul nuw i8 %y, 36
  call void @use(i8 %B)
  %C = icmp eq i8 %A, %B
  ret i1 %C
}

define i1 @mul_constant_ne_nuw_extra_use3(i8 %x, i8 %y) {
; CHECK-LABEL: @mul_constant_ne_nuw_extra_use3(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i8 [[X:%.*]], 38
; CHECK-NEXT:    call void @use(i8 [[A]])
; CHECK-NEXT:    [[B:%.*]] = mul nuw i8 [[Y:%.*]], 38
; CHECK-NEXT:    call void @use(i8 [[B]])
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[X]], [[Y]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nuw i8 %x, 38
  call void @use(i8 %A)
  %B = mul nuw i8 %y, 38
  call void @use(i8 %B)
  %C = icmp ne i8 %A, %B
  ret i1 %C
}

; Negative test - wrong pred

define i1 @mul_constant_ult(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_constant_ult(
; CHECK-NEXT:    [[A:%.*]] = mul i32 [[X:%.*]], 47
; CHECK-NEXT:    [[B:%.*]] = mul i32 [[Y:%.*]], 47
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[A]], [[B]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul i32 %x, 47
  %B = mul i32 %y, 47
  %C = icmp ult i32 %A, %B
  ret i1 %C
}

; Negative test - wrong pred

define i1 @mul_constant_nuw_sgt(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_constant_nuw_sgt(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i32 [[X:%.*]], 46
; CHECK-NEXT:    [[B:%.*]] = mul nuw i32 [[Y:%.*]], 46
; CHECK-NEXT:    [[C:%.*]] = icmp sgt i32 [[A]], [[B]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nuw i32 %x, 46
  %B = mul nuw i32 %y, 46
  %C = icmp sgt i32 %A, %B
  ret i1 %C
}

; Negative test - wrong constants

define i1 @mul_mismatch_constant_nuw_eq(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_mismatch_constant_nuw_eq(
; CHECK-NEXT:    [[A:%.*]] = mul nuw i32 [[X:%.*]], 46
; CHECK-NEXT:    [[B:%.*]] = mul nuw i32 [[Y:%.*]], 44
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[A]], [[B]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nuw i32 %x, 46
  %B = mul nuw i32 %y, 44
  %C = icmp eq i32 %A, %B
  ret i1 %C
}

; If the multiply constant has any trailing zero bits but could overflow,
; we get something completely different.
; We mask off the high bits of each input and then convert:
; (X&Z) == (Y&Z) -> (X^Y) & Z == 0

define i1 @mul_constant_partial_nuw_eq(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_constant_partial_nuw_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 1073741823
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul i32 %x, 44
  %B = mul nuw i32 %y, 44
  %C = icmp eq i32 %A, %B
  ret i1 %C
}

define i1 @mul_constant_mismatch_wrap_eq(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_constant_mismatch_wrap_eq(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 2147483647
; CHECK-NEXT:    [[C:%.*]] = icmp eq i32 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul nsw i32 %x, 54
  %B = mul nuw i32 %y, 54
  %C = icmp eq i32 %A, %B
  ret i1 %C
}

define i1 @eq_mul_constants_with_tz(i32 %x, i32 %y) {
; CHECK-LABEL: @eq_mul_constants_with_tz(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and i32 [[TMP1]], 1073741823
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[TMP2]], 0
; CHECK-NEXT:    ret i1 [[C]]
;
  %A = mul i32 %x, 12
  %B = mul i32 %y, 12
  %C = icmp ne i32 %A, %B
  ret i1 %C
}

define <2 x i1> @eq_mul_constants_with_tz_splat(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @eq_mul_constants_with_tz_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP1]], <i32 1073741823, i32 1073741823>
; CHECK-NEXT:    [[C:%.*]] = icmp eq <2 x i32> [[TMP2]], zeroinitializer
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %A = mul <2 x i32> %x, <i32 12, i32 12>
  %B = mul <2 x i32> %y, <i32 12, i32 12>
  %C = icmp eq <2 x i32> %A, %B
  ret <2 x i1> %C
}

@g = extern_weak global i32

define i1 @oss_fuzz_39934(i32 %arg) {
; CHECK-LABEL: @oss_fuzz_39934(
; CHECK-NEXT:    [[B13:%.*]] = mul nsw i32 [[ARG:%.*]], -65536
; CHECK-NEXT:    [[C10:%.*]] = icmp ne i32 [[B13]], mul (i32 or (i32 zext (i1 icmp eq (i32* @g, i32* null) to i32), i32 65537), i32 -65536)
; CHECK-NEXT:    ret i1 [[C10]]
;
  %B13 = mul nsw i32 %arg, -65536
  %C10 = icmp ne i32 mul (i32 or (i32 zext (i1 icmp eq (i32* @g, i32* null) to i32), i32 65537), i32 -65536), %B13
  ret i1 %C10
}

define i1 @mul_of_bool(i32 %x, i8 %y) {
; CHECK-LABEL: @mul_of_bool(
; CHECK-NEXT:    ret i1 false
;
  %b = and i32 %x, 1
  %z = zext i8 %y to i32
  %m = mul i32 %b, %z
  %r = icmp ugt i32 %m, 255
  ret i1 %r
}

define i1 @mul_of_bool_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_of_bool_commute(
; CHECK-NEXT:    ret i1 false
;
  %x1 = and i32 %x, 1
  %y8 = and i32 %y, 255
  %m = mul i32 %y8, %x1
  %r = icmp ugt i32 %m, 255
  ret i1 %r
}

define i1 @mul_of_bools(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_of_bools(
; CHECK-NEXT:    ret i1 true
;
  %x1 = and i32 %x, 1
  %y1 = and i32 %y, 1
  %m = mul i32 %x1, %y1
  %r = icmp ult i32 %m, 2
  ret i1 %r
}

; negative test - not a mask of low bit

define i1 @not_mul_of_bool(i32 %x, i8 %y) {
; CHECK-LABEL: @not_mul_of_bool(
; CHECK-NEXT:    [[Q:%.*]] = and i32 [[X:%.*]], 3
; CHECK-NEXT:    [[Z:%.*]] = zext i8 [[Y:%.*]] to i32
; CHECK-NEXT:    [[M:%.*]] = mul nuw nsw i32 [[Q]], [[Z]]
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i32 [[M]], 255
; CHECK-NEXT:    ret i1 [[R]]
;
  %q = and i32 %x, 3
  %z = zext i8 %y to i32
  %m = mul i32 %q, %z
  %r = icmp ugt i32 %m, 255
  ret i1 %r
}

; negative test - not a single low bit

define i1 @not_mul_of_bool_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @not_mul_of_bool_commute(
; CHECK-NEXT:    [[X30:%.*]] = lshr i32 [[X:%.*]], 30
; CHECK-NEXT:    [[Y8:%.*]] = and i32 [[Y:%.*]], 255
; CHECK-NEXT:    [[M:%.*]] = mul nuw nsw i32 [[Y8]], [[X30]]
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i32 [[M]], 255
; CHECK-NEXT:    ret i1 [[R]]
;
  %x30 = lshr i32 %x, 30
  %y8 = and i32 %y, 255
  %m = mul i32 %y8, %x30
  %r = icmp ugt i32 %m, 255
  ret i1 %r
}

; negative test - no leading zeros for 's'
; TODO: If analysis was generalized for sign bits, we could reduce this to false.

define i1 @mul_of_bool_no_lz_other_op(i32 %x, i8 %y) {
; CHECK-LABEL: @mul_of_bool_no_lz_other_op(
; CHECK-NEXT:    [[B:%.*]] = and i32 [[X:%.*]], 1
; CHECK-NEXT:    [[S:%.*]] = sext i8 [[Y:%.*]] to i32
; CHECK-NEXT:    [[M:%.*]] = mul nuw nsw i32 [[B]], [[S]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i32 [[M]], 127
; CHECK-NEXT:    ret i1 [[R]]
;
  %b = and i32 %x, 1
  %s = sext i8 %y to i32
  %m = mul nuw nsw i32 %b, %s
  %r = icmp sgt i32 %m, 127
  ret i1 %r
}

; high and low bits are known 0

define i1 @mul_of_pow2(i32 %x, i8 %y) {
; CHECK-LABEL: @mul_of_pow2(
; CHECK-NEXT:    ret i1 false
;
  %b = and i32 %x, 2
  %z = zext i8 %y to i32
  %m = mul i32 %b, %z
  %r = icmp ugt i32 %m, 510
  ret i1 %r
}

; high and low bits are known 0

define i1 @mul_of_pow2_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_of_pow2_commute(
; CHECK-NEXT:    ret i1 false
;
  %x4 = and i32 %x, 4
  %y8 = and i32 %y, 255
  %m = mul i32 %y8, %x4
  %r = icmp ugt i32 %m, 1020
  ret i1 %r
}

; only bit 7 can be set by the multiply

define i32 @mul_of_pow2s(i32 %x, i32 %y) {
; CHECK-LABEL: @mul_of_pow2s(
; CHECK-NEXT:    ret i32 128
;
  %x8 = and i32 %x, 8
  %y16 = and i32 %y, 16
  %m = mul i32 %x8, %y16
  %bit7 = or i32 %m, 128
  ret i32 %bit7
}

; negative test - 6 * 255 = 1530 (but constant range analysis can get this)

define i1 @not_mul_of_pow2(i32 %x, i8 %y) {
; CHECK-LABEL: @not_mul_of_pow2(
; CHECK-NEXT:    [[Q:%.*]] = and i32 [[X:%.*]], 6
; CHECK-NEXT:    [[Z:%.*]] = zext i8 [[Y:%.*]] to i32
; CHECK-NEXT:    [[M:%.*]] = mul nuw nsw i32 [[Q]], [[Z]]
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i32 [[M]], 1530
; CHECK-NEXT:    ret i1 [[R]]
;
  %q = and i32 %x, 6
  %z = zext i8 %y to i32
  %m = mul i32 %q, %z
  %r = icmp ugt i32 %m, 1530
  ret i1 %r
}

; negative test - 12 * 255 = 3060 (but constant range analysis can get this)

define i1 @not_mul_of_pow2_commute(i32 %x, i32 %y) {
; CHECK-LABEL: @not_mul_of_pow2_commute(
; CHECK-NEXT:    [[X30:%.*]] = and i32 [[X:%.*]], 12
; CHECK-NEXT:    [[Y8:%.*]] = and i32 [[Y:%.*]], 255
; CHECK-NEXT:    [[M:%.*]] = mul nuw nsw i32 [[Y8]], [[X30]]
; CHECK-NEXT:    [[R:%.*]] = icmp ugt i32 [[M]], 3060
; CHECK-NEXT:    ret i1 [[R]]
;
  %x30 = and i32 %x, 12
  %y8 = and i32 %y, 255
  %m = mul i32 %y8, %x30
  %r = icmp ugt i32 %m, 3060
  ret i1 %r
}

; negative test - no leading zeros for 's'
; TODO: If analysis was generalized for sign bits, we could reduce this to false.

define i1 @mul_of_pow2_no_lz_other_op(i32 %x, i8 %y) {
; CHECK-LABEL: @mul_of_pow2_no_lz_other_op(
; CHECK-NEXT:    [[B:%.*]] = and i32 [[X:%.*]], 2
; CHECK-NEXT:    [[S:%.*]] = sext i8 [[Y:%.*]] to i32
; CHECK-NEXT:    [[M:%.*]] = mul nuw nsw i32 [[B]], [[S]]
; CHECK-NEXT:    [[R:%.*]] = icmp sgt i32 [[M]], 254
; CHECK-NEXT:    ret i1 [[R]]
;
  %b = and i32 %x, 2
  %s = sext i8 %y to i32
  %m = mul nuw nsw i32 %b, %s
  %r = icmp sgt i32 %m, 254
  ret i1 %r
}

; The top 32-bits must be zero.

define i1 @splat_mul_known_lz(i32 %x) {
; CHECK-LABEL: @splat_mul_known_lz(
; CHECK-NEXT:    ret i1 true
;
  %z = zext i32 %x to i128
  %m = mul i128 %z, 18446744078004518913 ; 0x00000000_00000001_00000001_00000001
  %s = lshr i128 %m, 96
  %r = icmp eq i128 %s, 0
  ret i1 %r
}

; Negative test - the 33rd bit could be set.

define i1 @splat_mul_unknown_lz(i32 %x) {
; CHECK-LABEL: @splat_mul_unknown_lz(
; CHECK-NEXT:    [[Z:%.*]] = zext i32 [[X:%.*]] to i128
; CHECK-NEXT:    [[M:%.*]] = mul nuw nsw i128 [[Z]], 18446744078004518913
; CHECK-NEXT:    [[R:%.*]] = icmp ult i128 [[M]], 39614081257132168796771975168
; CHECK-NEXT:    ret i1 [[R]]
;
  %z = zext i32 %x to i128
  %m = mul i128 %z, 18446744078004518913 ; 0x00000000_00000001_00000001_00000001
  %s = lshr i128 %m, 95
  %r = icmp eq i128 %s, 0
  ret i1 %r
}
