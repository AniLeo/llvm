; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -slp-vectorizer -S -mtriple=aarch64-apple-ios -mcpu=cyclone -o - %s | FileCheck %s

define void @f1(<2 x i16> %x, i16* %a) {
; CHECK-LABEL: @f1(
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i16> [[X:%.*]], <2 x i16> poison, <4 x i32> <i32 0, i32 1, i32 1, i32 0>
; CHECK-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 0
; CHECK-NEXT:    [[PTR1:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 1
; CHECK-NEXT:    [[PTR2:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 2
; CHECK-NEXT:    [[PTR3:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 3
; CHECK-NEXT:    [[TMP1:%.*]] = extractelement <4 x i16> [[SHUFFLE]], i32 0
; CHECK-NEXT:    store i16 [[TMP1]], i16* [[A:%.*]], align 2
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i16* [[PTR0]] to <4 x i16>*
; CHECK-NEXT:    store <4 x i16> [[SHUFFLE]], <4 x i16>* [[TMP2]], align 2
; CHECK-NEXT:    ret void
;
  %t2 = extractelement <2 x i16> %x, i32 0
  %t3 = extractelement <2 x i16> %x, i32 1
  %ptr0 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 0
  %ptr1 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 1
  %ptr2 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 2
  %ptr3 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 3
  store i16 %t2, i16* %a
  store i16 %t2, i16* %ptr0
  store i16 %t3, i16* %ptr1
  store i16 %t3, i16* %ptr2
  store i16 %t2, i16* %ptr3
  ret void
}

define void @f2(<2 x i16> %x, i16* %a) {
; CHECK-LABEL: @f2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[CONT:%.*]]
; CHECK:       cont:
; CHECK-NEXT:    [[XX:%.*]] = phi <2 x i16> [ [[X:%.*]], [[ENTRY:%.*]] ], [ undef, [[CONT]] ]
; CHECK-NEXT:    [[AA:%.*]] = phi i16* [ [[A:%.*]], [[ENTRY]] ], [ undef, [[CONT]] ]
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i16> [[XX]], <2 x i16> poison, <4 x i32> <i32 0, i32 1, i32 1, i32 0>
; CHECK-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 0
; CHECK-NEXT:    [[PTR1:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 1
; CHECK-NEXT:    [[PTR2:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 2
; CHECK-NEXT:    [[PTR3:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 3
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <4 x i16> [[SHUFFLE]], i32 0
; CHECK-NEXT:    store i16 [[TMP0]], i16* [[A]], align 2
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[PTR0]] to <4 x i16>*
; CHECK-NEXT:    store <4 x i16> [[SHUFFLE]], <4 x i16>* [[TMP1]], align 2
; CHECK-NEXT:    [[A_VAL:%.*]] = load i16, i16* [[A]], align 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[A_VAL]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[CONT]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %cont

cont:                                           ; preds = %entry, %cont
  %xx = phi <2 x i16> [ %x, %entry ], [ undef, %cont ]
  %aa = phi i16* [ %a, %entry ], [ undef, %cont ]
  %t2 = extractelement <2 x i16> %xx, i32 0
  %t3 = extractelement <2 x i16> %xx, i32 1
  %ptr0 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 0
  %ptr1 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 1
  %ptr2 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 2
  %ptr3 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 3
  store i16 %t2, i16* %a
  store i16 %t2, i16* %ptr0
  store i16 %t3, i16* %ptr1
  store i16 %t3, i16* %ptr2
  store i16 %t2, i16* %ptr3
  %a_val = load i16, i16* %a, align 2
  %cmp = icmp eq i16 %a_val, 0
  br i1 %cmp, label %cont, label %exit

exit:                                           ; preds = %cont
  ret void
}

define void @f3(<2 x i16> %x, i16* %a) {
; CHECK-LABEL: @f3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[CONT:%.*]]
; CHECK:       cont:
; CHECK-NEXT:    [[XX:%.*]] = phi <2 x i16> [ [[X:%.*]], [[ENTRY:%.*]] ], [ undef, [[CONT]] ]
; CHECK-NEXT:    [[AA:%.*]] = phi i16* [ [[A:%.*]], [[ENTRY]] ], [ undef, [[CONT]] ]
; CHECK-NEXT:    [[SHUFFLE:%.*]] = shufflevector <2 x i16> [[XX]], <2 x i16> poison, <4 x i32> <i32 1, i32 0, i32 0, i32 1>
; CHECK-NEXT:    [[PTR0:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 0
; CHECK-NEXT:    [[PTR1:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 1
; CHECK-NEXT:    [[PTR2:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 2
; CHECK-NEXT:    [[PTR3:%.*]] = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 3
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <4 x i16> [[SHUFFLE]], i32 0
; CHECK-NEXT:    store i16 [[TMP0]], i16* [[A]], align 2
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i16* [[PTR0]] to <4 x i16>*
; CHECK-NEXT:    store <4 x i16> [[SHUFFLE]], <4 x i16>* [[TMP1]], align 2
; CHECK-NEXT:    [[A_VAL:%.*]] = load i16, i16* [[A]], align 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[A_VAL]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[CONT]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %cont

cont:                                           ; preds = %entry, %cont
  %xx = phi <2 x i16> [ %x, %entry ], [ undef, %cont ]
  %aa = phi i16* [ %a, %entry ], [ undef, %cont ]
  %t2 = extractelement <2 x i16> %xx, i32 0
  %t3 = extractelement <2 x i16> %xx, i32 1
  %ptr0 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 0
  %ptr1 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 1
  %ptr2 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 2
  %ptr3 = getelementptr inbounds [4 x i16], [4 x i16]* undef, i16 0, i16 3
  store i16 %t3, i16* %a
  store i16 %t3, i16* %ptr0
  store i16 %t2, i16* %ptr1
  store i16 %t2, i16* %ptr2
  store i16 %t3, i16* %ptr3
  %a_val = load i16, i16* %a, align 2
  %cmp = icmp eq i16 %a_val, 0
  br i1 %cmp, label %cont, label %exit

exit:                                           ; preds = %cont
  ret void
}
