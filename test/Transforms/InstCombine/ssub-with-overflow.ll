; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

declare { <2 x i32>, <2 x i1> } @llvm.ssub.with.overflow.v2i32(<2 x i32>, <2 x i32>)

declare { <2 x i8>, <2 x i1> } @llvm.ssub.with.overflow.v2i8(<2 x i8>, <2 x i8>)

declare { i32, i1 } @llvm.ssub.with.overflow.i32(i32, i32)

declare { i8, i1 } @llvm.ssub.with.overflow.i8(i8, i8)

define { i32, i1 } @simple_fold(i32 %x) {
; CHECK-LABEL: @simple_fold(
; CHECK-NEXT:    [[TMP1:%.*]] = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[X:%.*]], i32 -20)
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %a = sub nsw i32 %x, 7
  %b = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %a, i32 13)
  ret { i32, i1 } %b
}

define { i32, i1 } @fold_mixed_signs(i32 %x) {
; CHECK-LABEL: @fold_mixed_signs(
; CHECK-NEXT:    [[B:%.*]] = add nsw i32 [[X:%.*]], -6
; CHECK-NEXT:    [[TMP1:%.*]] = insertvalue { i32, i1 } { i32 undef, i1 false }, i32 [[B]], 0
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %a = sub nsw i32 %x, 13
  %b = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %a, i32 -7)
  ret { i32, i1 } %b
}

define { i8, i1 } @fold_on_constant_sub_no_overflow(i8 %x) {
; CHECK-LABEL: @fold_on_constant_sub_no_overflow(
; CHECK-NEXT:    [[TMP1:%.*]] = call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[X:%.*]], i8 -128)
; CHECK-NEXT:    ret { i8, i1 } [[TMP1]]
;
  %a = sub nsw i8 %x, 100
  %b = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %a, i8 28)
  ret { i8, i1 } %b
}

define { i8, i1 } @no_fold_on_constant_sub_overflow(i8 %x) {
; CHECK-LABEL: @no_fold_on_constant_sub_overflow(
; CHECK-NEXT:    [[A:%.*]] = add nsw i8 [[X:%.*]], -100
; CHECK-NEXT:    [[TMP1:%.*]] = call { i8, i1 } @llvm.sadd.with.overflow.i8(i8 [[A]], i8 -29)
; CHECK-NEXT:    ret { i8, i1 } [[TMP1]]
;
  %a = sub nsw i8 %x, 100
  %b = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %a, i8 29)
  ret { i8, i1 } %b
}

define { <2 x i32>, <2 x i1> } @fold_simple_splat_constant(<2 x i32> %x) {
; CHECK-LABEL: @fold_simple_splat_constant(
; CHECK-NEXT:    [[TMP1:%.*]] = call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> [[X:%.*]], <2 x i32> <i32 -42, i32 -42>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[TMP1]]
;
  %a = sub nsw <2 x i32> %x, <i32 12, i32 12>
  %b = tail call { <2 x i32>, <2 x i1> } @llvm.ssub.with.overflow.v2i32(<2 x i32> %a, <2 x i32> <i32 30, i32 30>)
  ret { <2 x i32>, <2 x i1> } %b
}

define { <2 x i32>, <2 x i1> } @no_fold_splat_undef_constant(<2 x i32> %x) {
; CHECK-LABEL: @no_fold_splat_undef_constant(
; CHECK-NEXT:    [[A:%.*]] = add <2 x i32> [[X:%.*]], <i32 -12, i32 undef>
; CHECK-NEXT:    [[TMP1:%.*]] = call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> [[A]], <2 x i32> <i32 -30, i32 -30>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[TMP1]]
;
  %a = sub nsw <2 x i32> %x, <i32 12, i32 undef>
  %b = tail call { <2 x i32>, <2 x i1> } @llvm.ssub.with.overflow.v2i32(<2 x i32> %a, <2 x i32> <i32 30, i32 30>)
  ret { <2 x i32>, <2 x i1> } %b
}

define { <2 x i32>, <2 x i1> } @no_fold_splat_not_constant(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @no_fold_splat_not_constant(
; CHECK-NEXT:    [[A:%.*]] = sub nsw <2 x i32> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> [[A]], <2 x i32> <i32 -30, i32 -30>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[TMP1]]
;
  %a = sub nsw <2 x i32> %x, %y
  %b = tail call { <2 x i32>, <2 x i1> } @llvm.ssub.with.overflow.v2i32(<2 x i32> %a, <2 x i32> <i32 30, i32 30>)
  ret { <2 x i32>, <2 x i1> } %b
}

define { i32, i1 } @fold_nuwnsw(i32 %x) {
; CHECK-LABEL: @fold_nuwnsw(
; CHECK-NEXT:    [[TMP1:%.*]] = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[X:%.*]], i32 -42)
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %a = sub nuw nsw i32 %x, 12
  %b = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %a, i32 30)
  ret { i32, i1 } %b
}

define { i32, i1 } @no_fold_nuw(i32 %x) {
; CHECK-LABEL: @no_fold_nuw(
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], -12
; CHECK-NEXT:    [[TMP1:%.*]] = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[A]], i32 -30)
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %a = sub nuw i32 %x, 12
  %b = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %a, i32 30)
  ret { i32, i1 } %b
}

define { i32, i1 } @no_fold_wrapped_sub(i32 %x) {
; CHECK-LABEL: @no_fold_wrapped_sub(
; CHECK-NEXT:    [[A:%.*]] = add i32 [[X:%.*]], -12
; CHECK-NEXT:    [[B:%.*]] = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 30, i32 [[A]])
; CHECK-NEXT:    ret { i32, i1 } [[B]]
;
  %a = sub i32 %x, 12
  %b = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 30, i32 %a)
  ret { i32, i1 } %b
}

define { i32, i1 } @fold_add_simple(i32 %x) {
; CHECK-LABEL: @fold_add_simple(
; CHECK-NEXT:    [[TMP1:%.*]] = call { i32, i1 } @llvm.sadd.with.overflow.i32(i32 [[X:%.*]], i32 -42)
; CHECK-NEXT:    ret { i32, i1 } [[TMP1]]
;
  %a = add nsw i32 %x, -12
  %b = tail call { i32, i1 } @llvm.ssub.with.overflow.i32(i32 %a, i32 30)
  ret { i32, i1 } %b
}

define { <2 x i32>, <2 x i1> } @keep_ssubo_undef(<2 x i32> %x) {
; CHECK-LABEL: @keep_ssubo_undef(
; CHECK-NEXT:    [[A:%.*]] = tail call { <2 x i32>, <2 x i1> } @llvm.ssub.with.overflow.v2i32(<2 x i32> [[X:%.*]], <2 x i32> <i32 30, i32 undef>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[A]]
;
  %a = tail call { <2 x i32>, <2 x i1> } @llvm.ssub.with.overflow.v2i32(<2 x i32> %x, <2 x i32> <i32 30, i32 undef>)
  ret { <2 x i32>, <2 x i1> } %a
}

define { <2 x i32>, <2 x i1> } @keep_ssubo_non_splat(<2 x i32> %x) {
; CHECK-LABEL: @keep_ssubo_non_splat(
; CHECK-NEXT:    [[TMP1:%.*]] = call { <2 x i32>, <2 x i1> } @llvm.sadd.with.overflow.v2i32(<2 x i32> [[X:%.*]], <2 x i32> <i32 -30, i32 -31>)
; CHECK-NEXT:    ret { <2 x i32>, <2 x i1> } [[TMP1]]
;
  %a = tail call { <2 x i32>, <2 x i1> } @llvm.ssub.with.overflow.v2i32(<2 x i32> %x, <2 x i32> <i32 30, i32 31>)
  ret { <2 x i32>, <2 x i1> } %a
}

define { <2 x i8>, <2 x i1> } @keep_ssubo_one_element_is_128(<2 x i8> %x) {
; CHECK-LABEL: @keep_ssubo_one_element_is_128(
; CHECK-NEXT:    [[A:%.*]] = tail call { <2 x i8>, <2 x i1> } @llvm.ssub.with.overflow.v2i8(<2 x i8> [[X:%.*]], <2 x i8> <i8 0, i8 -128>)
; CHECK-NEXT:    ret { <2 x i8>, <2 x i1> } [[A]]
;
  %a = tail call { <2 x i8>, <2 x i1> } @llvm.ssub.with.overflow.v2i8(<2 x i8> %x, <2 x i8> <i8 0, i8 -128>)
  ret { <2 x i8>, <2 x i1> } %a
}

define { i8, i1 } @keep_ssubo_128(i8 %x) {
; CHECK-LABEL: @keep_ssubo_128(
; CHECK-NEXT:    [[A:%.*]] = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 [[X:%.*]], i8 -128)
; CHECK-NEXT:    ret { i8, i1 } [[A]]
;
  %a = tail call { i8, i1 } @llvm.ssub.with.overflow.i8(i8 %x, i8 -128)
  ret { i8, i1 } %a
}
