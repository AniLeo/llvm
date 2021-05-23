; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-unroll %s | FileCheck %s

; Full unrolling can be performed against the header exit here, but we have
; both multiple exits and a latch exit. After full unrolling, this function
; folds to ret i1 true.

define i1 @test() {
; CHECK-LABEL: @test(
; CHECK-NEXT:  start:
; CHECK-NEXT:    [[A1:%.*]] = alloca [2 x i64], align 8
; CHECK-NEXT:    [[A2:%.*]] = alloca [2 x i64], align 8
; CHECK-NEXT:    [[A1_0:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 0
; CHECK-NEXT:    store i64 -5015437470765251660, i64* [[A1_0]], align 8
; CHECK-NEXT:    [[A1_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 1
; CHECK-NEXT:    store i64 -8661621401413125213, i64* [[A1_1]], align 8
; CHECK-NEXT:    [[A2_0:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 0
; CHECK-NEXT:    store i64 -5015437470765251660, i64* [[A2_0]], align 8
; CHECK-NEXT:    [[A2_1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 1
; CHECK-NEXT:    store i64 -8661621401413125213, i64* [[A2_1]], align 8
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[START:%.*]] ], [ [[IV_NEXT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[IV]], 2
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[EXIT:%.*]], label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A1]], i64 0, i64 [[IV]]
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr inbounds [2 x i64], [2 x i64]* [[A2]], i64 0, i64 [[IV]]
; CHECK-NEXT:    [[LOAD1:%.*]] = load i64, i64* [[GEP1]], align 8
; CHECK-NEXT:    [[LOAD2:%.*]] = load i64, i64* [[GEP2]], align 8
; CHECK-NEXT:    [[EXITCOND2:%.*]] = icmp eq i64 [[LOAD1]], [[LOAD2]]
; CHECK-NEXT:    br i1 [[EXITCOND2]], label [[LOOP]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    [[EXIT_VAL:%.*]] = phi i1 [ false, [[LATCH]] ], [ true, [[LOOP]] ]
; CHECK-NEXT:    ret i1 [[EXIT_VAL]]
;
start:
  %a1 = alloca [2 x i64], align 8
  %a2 = alloca [2 x i64], align 8
  %a1.0 = getelementptr inbounds [2 x i64], [2 x i64]* %a1, i64 0, i64 0
  store i64 -5015437470765251660, i64* %a1.0, align 8
  %a1.1 = getelementptr inbounds [2 x i64], [2 x i64]* %a1, i64 0, i64 1
  store i64 -8661621401413125213, i64* %a1.1, align 8
  %a2.0 = getelementptr inbounds [2 x i64], [2 x i64]* %a2, i64 0, i64 0
  store i64 -5015437470765251660, i64* %a2.0, align 8
  %a2.1 = getelementptr inbounds [2 x i64], [2 x i64]* %a2, i64 0, i64 1
  store i64 -8661621401413125213, i64* %a2.1, align 8
  br label %loop

loop:
  %iv = phi i64 [ 0, %start ], [ %iv.next, %latch ]
  %exitcond = icmp eq i64 %iv, 2
  br i1 %exitcond, label %exit, label %latch

latch:
  %iv.next = add nuw nsw i64 %iv, 1
  %gep1 = getelementptr inbounds [2 x i64], [2 x i64]* %a1, i64 0, i64 %iv
  %gep2 = getelementptr inbounds [2 x i64], [2 x i64]* %a2, i64 0, i64 %iv
  %load1 = load i64, i64* %gep1, align 8
  %load2 = load i64, i64* %gep2, align 8
  %exitcond2 = icmp eq i64 %load1, %load2
  br i1 %exitcond2, label %loop, label %exit

exit:
  %exit.val = phi i1 [ false, %latch ], [ true, %loop ]
  ret i1 %exit.val
}
