; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=sse2 | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: opt < %s -vector-combine -S -mtriple=x86_64-- -mattr=avx2 | FileCheck %s --check-prefixes=CHECK,AVX

define i1 @fcmp_and_v2f64(<2 x double> %a) {
; CHECK-LABEL: @fcmp_and_v2f64(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <2 x double> [[A:%.*]], i32 0
; CHECK-NEXT:    [[E2:%.*]] = extractelement <2 x double> [[A]], i32 1
; CHECK-NEXT:    [[CMP1:%.*]] = fcmp olt double [[E1]], 4.200000e+01
; CHECK-NEXT:    [[CMP2:%.*]] = fcmp olt double [[E2]], -8.000000e+00
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <2 x double> %a, i32 0
  %e2 = extractelement <2 x double> %a, i32 1
  %cmp1 = fcmp olt double %e1, 42.0
  %cmp2 = fcmp olt double %e2, -8.0
  %r = and i1 %cmp1, %cmp2
  ret i1 %r
}

define i1 @fcmp_or_v4f64(<4 x double> %a) {
; CHECK-LABEL: @fcmp_or_v4f64(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <4 x double> [[A:%.*]], i32 0
; CHECK-NEXT:    [[E2:%.*]] = extractelement <4 x double> [[A]], i64 2
; CHECK-NEXT:    [[CMP1:%.*]] = fcmp olt double [[E1]], 4.200000e+01
; CHECK-NEXT:    [[CMP2:%.*]] = fcmp olt double [[E2]], -8.000000e+00
; CHECK-NEXT:    [[R:%.*]] = or i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x double> %a, i32 0
  %e2 = extractelement <4 x double> %a, i64 2
  %cmp1 = fcmp olt double %e1, 42.0
  %cmp2 = fcmp olt double %e2, -8.0
  %r = or i1 %cmp1, %cmp2
  ret i1 %r
}

define i1 @icmp_xor_v4i32(<4 x i32> %a) {
; CHECK-LABEL: @icmp_xor_v4i32(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <4 x i32> [[A:%.*]], i32 3
; CHECK-NEXT:    [[E2:%.*]] = extractelement <4 x i32> [[A]], i32 1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[E1]], 42
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[E2]], -8
; CHECK-NEXT:    [[R:%.*]] = xor i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x i32> %a, i32 3
  %e2 = extractelement <4 x i32> %a, i32 1
  %cmp1 = icmp sgt i32 %e1, 42
  %cmp2 = icmp sgt i32 %e2, -8
  %r = xor i1 %cmp1, %cmp2
  ret i1 %r
}

; add is not canonical (should be xor), but that is ok.

define i1 @icmp_add_v8i32(<8 x i32> %a) {
; CHECK-LABEL: @icmp_add_v8i32(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <8 x i32> [[A:%.*]], i32 7
; CHECK-NEXT:    [[E2:%.*]] = extractelement <8 x i32> [[A]], i32 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[E1]], 42
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[E2]], -8
; CHECK-NEXT:    [[R:%.*]] = add i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <8 x i32> %a, i32 7
  %e2 = extractelement <8 x i32> %a, i32 2
  %cmp1 = icmp eq i32 %e1, 42
  %cmp2 = icmp eq i32 %e2, -8
  %r = add i1 %cmp1, %cmp2
  ret i1 %r
}

define i1 @same_extract_index(<4 x i32> %a) {
; CHECK-LABEL: @same_extract_index(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <4 x i32> [[A:%.*]], i32 2
; CHECK-NEXT:    [[E2:%.*]] = extractelement <4 x i32> [[A]], i32 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 [[E1]], 42
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[E2]], -8
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x i32> %a, i32 2
  %e2 = extractelement <4 x i32> %a, i32 2
  %cmp1 = icmp ugt i32 %e1, 42
  %cmp2 = icmp ugt i32 %e2, -8
  %r = and i1 %cmp1, %cmp2
  ret i1 %r
}

define i1 @different_preds(<4 x i32> %a) {
; CHECK-LABEL: @different_preds(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <4 x i32> [[A:%.*]], i32 1
; CHECK-NEXT:    [[E2:%.*]] = extractelement <4 x i32> [[A]], i32 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[E1]], 42
; CHECK-NEXT:    [[CMP2:%.*]] = icmp ugt i32 [[E2]], -8
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x i32> %a, i32 1
  %e2 = extractelement <4 x i32> %a, i32 2
  %cmp1 = icmp sgt i32 %e1, 42
  %cmp2 = icmp ugt i32 %e2, -8
  %r = and i1 %cmp1, %cmp2
  ret i1 %r
}

define i1 @different_source_vec(<4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: @different_source_vec(
; CHECK-NEXT:    [[E1:%.*]] = extractelement <4 x i32> [[A:%.*]], i32 1
; CHECK-NEXT:    [[E2:%.*]] = extractelement <4 x i32> [[B:%.*]], i32 2
; CHECK-NEXT:    [[CMP1:%.*]] = icmp sgt i32 [[E1]], 42
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[E2]], -8
; CHECK-NEXT:    [[R:%.*]] = and i1 [[CMP1]], [[CMP2]]
; CHECK-NEXT:    ret i1 [[R]]
;
  %e1 = extractelement <4 x i32> %a, i32 1
  %e2 = extractelement <4 x i32> %b, i32 2
  %cmp1 = icmp sgt i32 %e1, 42
  %cmp2 = icmp sgt i32 %e2, -8
  %r = and i1 %cmp1, %cmp2
  ret i1 %r
}
