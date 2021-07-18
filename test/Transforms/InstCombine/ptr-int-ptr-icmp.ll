; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S -disable-i2p-p2i-opt < %s | FileCheck %s

target datalayout = "e-p:64:64-p1:16:16-p2:32:32:32-p3:64:64:64"
target triple = "x86_64-unknown-linux-gnu"

; icmp (inttoptr (ptrtoint p1)), p2 --> icmp p1, p2.

define i1 @func(i8* %X, i8* %Y) {
; CHECK-LABEL: @func(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %i = ptrtoint i8* %X to i64
  %p = inttoptr i64 %i to i8*
  %cmp = icmp eq i8* %p, %Y
  ret i1 %cmp
}

define i1 @func_pointer_different_types(i16* %X, i8* %Y) {
; CHECK-LABEL: @func_pointer_different_types(
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[X:%.*]] to i8*
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[TMP1]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %i = ptrtoint i16* %X to i64
  %p = inttoptr i64 %i to i8*
  %cmp = icmp eq i8* %p, %Y
  ret i1 %cmp
}

declare i8* @gen8ptr()

define i1 @func_commutative(i16* %X) {
; CHECK-LABEL: @func_commutative(
; CHECK-NEXT:    [[Y:%.*]] = call i8* @gen8ptr()
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[X:%.*]] to i8*
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[Y]], [[TMP1]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %Y = call i8* @gen8ptr() ; thwart complexity-based canonicalization
  %i = ptrtoint i16* %X to i64
  %p = inttoptr i64 %i to i8*
  %cmp = icmp eq i8* %Y, %p
  ret i1 %cmp
}

; Negative test - Wrong Integer type.

define i1 @func_integer_type_too_small(i16* %X, i8* %Y) {
; CHECK-LABEL: @func_integer_type_too_small(
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint i16* [[X:%.*]] to i64
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP1]], 4294967295
; CHECK-NEXT:    [[P:%.*]] = inttoptr i64 [[TMP2]] to i8*
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i8* [[P]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %i = ptrtoint i16* %X to i32
  %p = inttoptr i32 %i to i8*
  %cmp = icmp eq i8* %Y, %p
  ret i1 %cmp
}

; Negative test - Pointers in different address space

define i1 @func_ptr_different_addrspace(i8* %X, i16 addrspace(3)* %Y){
; CHECK-LABEL: @func_ptr_different_addrspace(
; CHECK-NEXT:    [[I:%.*]] = ptrtoint i8* [[X:%.*]] to i64
; CHECK-NEXT:    [[P:%.*]] = inttoptr i64 [[I]] to i16 addrspace(3)*
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 addrspace(3)* [[P]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %i = ptrtoint i8* %X to i64
  %p = inttoptr i64 %i to i16 addrspace(3)*
  %cmp = icmp eq i16 addrspace(3)* %Y, %p
  ret i1 %cmp
}

; Negative test - Pointers in different address space

define i1 @func_ptr_different_addrspace1(i8 addrspace(2)* %X, i16* %Y){
; CHECK-LABEL: @func_ptr_different_addrspace1(
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint i8 addrspace(2)* [[X:%.*]] to i32
; CHECK-NEXT:    [[I:%.*]] = zext i32 [[TMP1]] to i64
; CHECK-NEXT:    [[P:%.*]] = inttoptr i64 [[I]] to i16*
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16* [[P]], [[Y:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %i = ptrtoint i8 addrspace(2)* %X to i64
  %p = inttoptr i64 %i to i16*
  %cmp = icmp eq i16* %Y, %p
  ret i1 %cmp
}
