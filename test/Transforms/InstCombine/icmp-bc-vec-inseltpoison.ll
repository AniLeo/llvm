; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; Tests to verify proper functioning of the icmp folding implemented in
;  InstCombiner::foldICmpBitCastConstant
; Specifically, folding:
;   icmp <pred> iN X, C
;  where X = bitcast <M x iK> (shufflevector <M x iK> %vec, undef, SC)) to iN
;    and C is a splat of a K-bit pattern
;    and SC is a constant vector = <C', C', C', ..., C'>
; Into:
;  %E = extractelement <M x iK> %vec, i32 C'
;  icmp <pred> iK %E, trunc(C)

define i1 @test_i1_0(i1 %val) {
; CHECK-LABEL: @test_i1_0(
; CHECK-NEXT:    [[COND:%.*]] = xor i1 [[VAL:%.*]], true
; CHECK-NEXT:    ret i1 [[COND]]
;
  %insvec = insertelement <4 x i1> poison, i1 %val, i32 0
  %vec = shufflevector <4 x i1> %insvec, <4 x i1> poison, <4 x i32> zeroinitializer
  %cast = bitcast <4 x i1> %vec to i4
  %cond = icmp eq i4 %cast, 0
  ret i1 %cond
}

define i1 @test_i1_0_2(i1 %val) {
; CHECK-LABEL: @test_i1_0_2(
; CHECK-NEXT:    [[COND:%.*]] = xor i1 [[VAL:%.*]], true
; CHECK-NEXT:    ret i1 [[COND]]
;
  %insvec = insertelement <4 x i1> poison, i1 %val, i32 2
  %vec = shufflevector <4 x i1> %insvec, <4 x i1> poison, <4 x i32> <i32 2, i32 2, i32 2, i32 2>
  %cast = bitcast <4 x i1> %vec to i4
  %cond = icmp eq i4 %cast, 0
  ret i1 %cond
}

define i1 @test_i1_m1(i1 %val) {
; CHECK-LABEL: @test_i1_m1(
; CHECK-NEXT:    ret i1 [[VAL:%.*]]
;
  %insvec = insertelement <4 x i1> poison, i1 %val, i32 0
  %vec = shufflevector <4 x i1> %insvec, <4 x i1> poison, <4 x i32> zeroinitializer
  %cast = bitcast <4 x i1> %vec to i4
  %cond = icmp eq i4 %cast, -1
  ret i1 %cond
}

define i1 @test_i8_pattern(i8 %val) {
; CHECK-LABEL: @test_i8_pattern(
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i8 [[VAL:%.*]], 72
; CHECK-NEXT:    ret i1 [[COND]]
;
  %insvec = insertelement <4 x i8> poison, i8 %val, i32 0
  %vec = shufflevector <4 x i8> %insvec, <4 x i8> poison, <4 x i32> zeroinitializer
  %cast = bitcast <4 x i8> %vec to i32
  %cond = icmp eq i32 %cast, 1212696648
  ret i1 %cond
}

define i1 @test_i8_pattern_2(i8 %val) {
; CHECK-LABEL: @test_i8_pattern_2(
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i8 [[VAL:%.*]], 72
; CHECK-NEXT:    ret i1 [[COND]]
;
  %insvec = insertelement <4 x i8> poison, i8 %val, i32 2
  %vec = shufflevector <4 x i8> %insvec, <4 x i8> poison, <4 x i32> <i32 2, i32 2, i32 2, i32 2>
  %cast = bitcast <4 x i8> %vec to i32
  %cond = icmp eq i32 %cast, 1212696648
  ret i1 %cond
}

; Make sure we don't try to fold if the shufflemask has differing element values
define i1 @test_i8_pattern_3(<4 x i8> %invec) {
; CHECK-LABEL: @test_i8_pattern_3(
; CHECK-NEXT:    [[VEC:%.*]] = shufflevector <4 x i8> [[INVEC:%.*]], <4 x i8> poison, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
; CHECK-NEXT:    [[CAST:%.*]] = bitcast <4 x i8> [[VEC]] to i32
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[CAST]], 1212696648
; CHECK-NEXT:    ret i1 [[COND]]
;
  %vec = shufflevector <4 x i8> %invec, <4 x i8> poison, <4 x i32> <i32 1, i32 0, i32 3, i32 2>
  %cast = bitcast <4 x i8> %vec to i32
  %cond = icmp eq i32 %cast, 1212696648
  ret i1 %cond
}

; Make sure we don't try to fold if the compared-to constant isn't a splatted value
define i1 @test_i8_nopattern(i8 %val) {
; CHECK-LABEL: @test_i8_nopattern(
; CHECK-NEXT:    [[INSVEC:%.*]] = insertelement <4 x i8> poison, i8 [[VAL:%.*]], i64 0
; CHECK-NEXT:    [[VEC:%.*]] = shufflevector <4 x i8> [[INSVEC]], <4 x i8> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[CAST:%.*]] = bitcast <4 x i8> [[VEC]] to i32
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[CAST]], 1212696647
; CHECK-NEXT:    ret i1 [[COND]]
;
  %insvec = insertelement <4 x i8> poison, i8 %val, i32 0
  %vec = shufflevector <4 x i8> %insvec, <4 x i8> poison, <4 x i32> zeroinitializer
  %cast = bitcast <4 x i8> %vec to i32
  %cond = icmp eq i32 %cast, 1212696647
  ret i1 %cond
}

; Verify that we fold more than just the eq predicate
define i1 @test_i8_ult_pattern(i8 %val) {
; CHECK-LABEL: @test_i8_ult_pattern(
; CHECK-NEXT:    [[COND:%.*]] = icmp ult i8 [[VAL:%.*]], 72
; CHECK-NEXT:    ret i1 [[COND]]
;
  %insvec = insertelement <4 x i8> poison, i8 %val, i32 0
  %vec = shufflevector <4 x i8> %insvec, <4 x i8> poison, <4 x i32> zeroinitializer
  %cast = bitcast <4 x i8> %vec to i32
  %cond = icmp ult i32 %cast, 1212696648
  ret i1 %cond
}

define i1 @extending_shuffle_with_weird_types(<2 x i9> %v) {
; CHECK-LABEL: @extending_shuffle_with_weird_types(
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <2 x i9> [[V:%.*]], i64 0
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i9 [[TMP1]], 1
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %splat = shufflevector <2 x i9> %v, <2 x i9> poison, <3 x i32> zeroinitializer
  %cast = bitcast <3 x i9> %splat to i27
  %cmp = icmp slt i27 %cast, 262657 ; 0x040201
  ret i1 %cmp
}
