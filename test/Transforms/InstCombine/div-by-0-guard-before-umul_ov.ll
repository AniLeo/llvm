; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -instcombine -S -instcombine-unsafe-select-transform=0 | FileCheck %s

declare { i4, i1 } @llvm.umul.with.overflow.i4(i4, i4) #1

define i1 @t0_umul(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @t0_umul(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i4 [[SIZE:%.*]], 0
; CHECK-NEXT:    [[UMUL:%.*]] = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 [[SIZE]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[UMUL_OV:%.*]] = extractvalue { i4, i1 } [[UMUL]], 1
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[UMUL_OV]], i1 [[CMP]], i1 false
; CHECK-NEXT:    ret i1 [[AND]]
;
  %cmp = icmp ne i4 %size, 0
  %umul = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 %size, i4 %nmemb)
  %umul.ov = extractvalue { i4, i1 } %umul, 1
  %and = select i1 %umul.ov, i1 %cmp, i1 false
  ret i1 %and
}

define i1 @t1_commutative(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @t1_commutative(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i4 [[SIZE:%.*]], 0
; CHECK-NEXT:    [[UMUL:%.*]] = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 [[SIZE]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[UMUL_OV:%.*]] = extractvalue { i4, i1 } [[UMUL]], 1
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[CMP]], i1 [[UMUL_OV]], i1 false
; CHECK-NEXT:    ret i1 [[AND]]
;
  %cmp = icmp ne i4 %size, 0
  %umul = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 %size, i4 %nmemb)
  %umul.ov = extractvalue { i4, i1 } %umul, 1
  %and = select i1 %cmp, i1 %umul.ov, i1 false ; swapped
  ret i1 %and
}

define i1 @n2_wrong_size(i4 %size0, i4 %size1, i4 %nmemb) {
; CHECK-LABEL: @n2_wrong_size(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i4 [[SIZE1:%.*]], 0
; CHECK-NEXT:    [[UMUL:%.*]] = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 [[SIZE0:%.*]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[UMUL_OV:%.*]] = extractvalue { i4, i1 } [[UMUL]], 1
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[UMUL_OV]], i1 [[CMP]], i1 false
; CHECK-NEXT:    ret i1 [[AND]]
;
  %cmp = icmp ne i4 %size1, 0 ; not %size0
  %umul = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 %size0, i4 %nmemb)
  %umul.ov = extractvalue { i4, i1 } %umul, 1
  %and = select i1 %umul.ov, i1 %cmp, i1 false
  ret i1 %and
}

define i1 @n3_wrong_pred(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @n3_wrong_pred(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i4 [[SIZE:%.*]], 0
; CHECK-NEXT:    [[UMUL:%.*]] = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 [[SIZE]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[UMUL_OV:%.*]] = extractvalue { i4, i1 } [[UMUL]], 1
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[UMUL_OV]], i1 [[CMP]], i1 false
; CHECK-NEXT:    ret i1 [[AND]]
;
  %cmp = icmp eq i4 %size, 0 ; not 'ne'
  %umul = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 %size, i4 %nmemb)
  %umul.ov = extractvalue { i4, i1 } %umul, 1
  %and = select i1 %umul.ov, i1 %cmp, i1 false
  ret i1 %and
}

define i1 @n4_not_and(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @n4_not_and(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i4 [[SIZE:%.*]], 0
; CHECK-NEXT:    [[UMUL:%.*]] = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 [[SIZE]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[UMUL_OV:%.*]] = extractvalue { i4, i1 } [[UMUL]], 1
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[UMUL_OV]], i1 true, i1 [[CMP]]
; CHECK-NEXT:    ret i1 [[AND]]
;
  %cmp = icmp ne i4 %size, 0
  %umul = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 %size, i4 %nmemb)
  %umul.ov = extractvalue { i4, i1 } %umul, 1
  %and = select i1 %umul.ov, i1 true, i1 %cmp ; not 'and'
  ret i1 %and
}

define i1 @n5_not_zero(i4 %size, i4 %nmemb) {
; CHECK-LABEL: @n5_not_zero(
; CHECK-NEXT:    [[CMP:%.*]] = icmp ne i4 [[SIZE:%.*]], 1
; CHECK-NEXT:    [[UMUL:%.*]] = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 [[SIZE]], i4 [[NMEMB:%.*]])
; CHECK-NEXT:    [[UMUL_OV:%.*]] = extractvalue { i4, i1 } [[UMUL]], 1
; CHECK-NEXT:    [[AND:%.*]] = select i1 [[UMUL_OV]], i1 [[CMP]], i1 false
; CHECK-NEXT:    ret i1 [[AND]]
;
  %cmp = icmp ne i4 %size, 1 ; should be '0'
  %umul = tail call { i4, i1 } @llvm.umul.with.overflow.i4(i4 %size, i4 %nmemb)
  %umul.ov = extractvalue { i4, i1 } %umul, 1
  %and = select i1 %umul.ov, i1 %cmp, i1 false
  ret i1 %and
}
