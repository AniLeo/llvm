; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-unroll -S %s | FileCheck %s

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"
target triple = "arm64-apple-ios5.0.0"

; The loop in the function only contains a few instructions, but they will get
; lowered to a very large amount of target instructions.
define void @loop_with_large_vector_ops(i32 %i, <225 x double>* %A, <225 x double>* %B) {
; CHECK-LABEL: @loop_with_large_vector_ops(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[A_GEP:%.*]] = getelementptr <225 x double>, <225 x double>* [[A:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[LV_1:%.*]] = load <225 x double>, <225 x double>* [[A_GEP]], align 8
; CHECK-NEXT:    [[B_GEP:%.*]] = getelementptr <225 x double>, <225 x double>* [[A]], i32 [[IV]]
; CHECK-NEXT:    [[LV_2:%.*]] = load <225 x double>, <225 x double>* [[B_GEP]], align 8
; CHECK-NEXT:    [[MUL:%.*]] = fmul <225 x double> [[LV_1]], [[LV_2]]
; CHECK-NEXT:    store <225 x double> [[MUL]], <225 x double>* [[B_GEP]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i32 [[IV]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[IV_NEXT]], 10
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %loop ]
  %A.gep = getelementptr <225 x  double>, <225 x  double>* %A, i32 %iv
  %lv.1 = load <225 x double>, <225 x double>* %A.gep, align 8
  %B.gep = getelementptr <225 x  double>, <225 x  double>* %A, i32 %iv
  %lv.2 = load <225 x double>, <225 x double>* %B.gep, align 8
  %mul = fmul <225 x double> %lv.1, %lv.2
  store <225 x double> %mul, <225 x double>* %B.gep, align 8
  %iv.next = add nuw i32 %iv, 1
  %cmp = icmp ult i32 %iv.next, 10
  br i1 %cmp, label %loop, label %exit

exit:
  ret void
}
