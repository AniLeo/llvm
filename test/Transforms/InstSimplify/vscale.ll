; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instsimplify -S -verify | FileCheck %s

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Vector Operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; insertelement

define <vscale x 4 x i32> @insertelement_idx_undef(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @insertelement_idx_undef(
; CHECK-NEXT:    ret <vscale x 4 x i32> undef
;
  %r = insertelement <vscale x 4 x i32> %a, i32 5, i64 undef
  ret <vscale x 4 x i32> %r
}

define <vscale x 4 x i32> @insertelement_value_undef(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @insertelement_value_undef(
; CHECK-NEXT:    ret <vscale x 4 x i32> [[A:%.*]]
;
  %r = insertelement <vscale x 4 x i32> %a, i32 undef, i64 0
  ret <vscale x 4 x i32> %r
}

define <vscale x 4 x i32> @insertelement_idx_maybe_out_of_bound(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @insertelement_idx_maybe_out_of_bound(
; CHECK-NEXT:    [[R:%.*]] = insertelement <vscale x 4 x i32> [[A:%.*]], i32 5, i64 4
; CHECK-NEXT:    ret <vscale x 4 x i32> [[R]]
;
  %r = insertelement <vscale x 4 x i32> %a, i32 5, i64 4
  ret <vscale x 4 x i32> %r
}

define <vscale x 4 x i32> @insertelement_idx_large_bound(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @insertelement_idx_large_bound(
; CHECK-NEXT:    [[R:%.*]] = insertelement <vscale x 4 x i32> [[A:%.*]], i32 5, i64 12345
; CHECK-NEXT:    ret <vscale x 4 x i32> [[R]]
;
  %r = insertelement <vscale x 4 x i32> %a, i32 5, i64 12345
  ret <vscale x 4 x i32> %r
}

define <vscale x 4 x i32> @insert_extract_element_same_vec_idx_1(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @insert_extract_element_same_vec_idx_1(
; CHECK-NEXT:    ret <vscale x 4 x i32> [[A:%.*]]
;
  %v = extractelement <vscale x 4 x i32> %a, i64 1
  %r = insertelement <vscale x 4 x i32> %a, i32 %v, i64 1
  ret <vscale x 4 x i32> %r
}

; extractelement

define i32 @extractelement_idx_undef(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @extractelement_idx_undef(
; CHECK-NEXT:    ret i32 undef
;
  %r = extractelement <vscale x 4 x i32> %a, i64 undef
  ret i32 %r
}

define i32 @extractelement_vec_undef(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @extractelement_vec_undef(
; CHECK-NEXT:    ret i32 undef
;
  %r = extractelement <vscale x 4 x i32> undef, i64 1
  ret i32 %r
}

define i32 @extractelement_idx_maybe_out_of_bound(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @extractelement_idx_maybe_out_of_bound(
; CHECK-NEXT:    [[R:%.*]] = extractelement <vscale x 4 x i32> [[A:%.*]], i64 4
; CHECK-NEXT:    ret i32 [[R]]
;
  %r = extractelement <vscale x 4 x i32> %a, i64 4
  ret i32 %r
}
define i32 @extractelement_idx_large_bound(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @extractelement_idx_large_bound(
; CHECK-NEXT:    [[R:%.*]] = extractelement <vscale x 4 x i32> [[A:%.*]], i64 12345
; CHECK-NEXT:    ret i32 [[R]]
;
  %r = extractelement <vscale x 4 x i32> %a, i64 12345
  ret i32 %r
}

define i32 @insert_extract_element_same_vec_idx_2(<vscale x 4 x i32> %a) {
; CHECK-LABEL: @insert_extract_element_same_vec_idx_2(
; CHECK-NEXT:    ret i32 1
;
  %v = insertelement <vscale x 4 x i32> undef, i32 1, i64 4
  %r = extractelement <vscale x 4 x i32> %v, i64 4
  ret i32 %r
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Memory Access and Addressing Operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; getelementptr

define <vscale x 4 x i32*> @getelementptr_constant_foldable_1() {
; CHECK-LABEL: @getelementptr_constant_foldable_1(
; CHECK-NEXT:    ret <vscale x 4 x i32*> zeroinitializer
;
  %ptr = getelementptr i32, <vscale x 4 x i32*> zeroinitializer, <vscale x 4 x i64> undef
  ret <vscale x 4 x i32*> %ptr
}

define <vscale x 4 x <vscale x 4 x i32>*> @getelementptr_constant_foldable_2() {
; CHECK-LABEL: @getelementptr_constant_foldable_2(
; CHECK-NEXT:    ret <vscale x 4 x <vscale x 4 x i32>*> zeroinitializer
;
  %ptr = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* null, <vscale x 4 x i64> undef
  ret <vscale x 4 x <vscale x 4 x i32>*> %ptr
}

; fold getelementptr P, 0 -> P.
define <vscale x 4 x i32>* @getelementptr_constant_foldable_3() {
; CHECK-LABEL: @getelementptr_constant_foldable_3(
; CHECK-NEXT:    ret <vscale x 4 x i32>* null
;
  %ptr = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* null, i64 0
  ret <vscale x 4 x i32>* %ptr
}

define <vscale x 4 x i32>* @getelementptr_not_constant_foldable(i64 %x) {
; CHECK-LABEL: @getelementptr_not_constant_foldable(
; CHECK-NEXT:    [[PTR:%.*]] = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* null, i64 [[X:%.*]]
; CHECK-NEXT:    ret <vscale x 4 x i32>* [[PTR]]
;
  %ptr = getelementptr <vscale x 4 x i32>, <vscale x 4 x i32>* null, i64 %x
  ret <vscale x 4 x i32>* %ptr
}
