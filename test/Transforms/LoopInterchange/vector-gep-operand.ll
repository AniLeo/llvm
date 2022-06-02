; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-interchange -loop-interchange-threshold=-10 -S %s | FileCheck %s

target triple = "powerpc64le-unknown-linux-gnu"

; The test contains a GEP with an operand that is not SCEV-able. Make sure
; loop-interchange does not crash.
define void @test([256 x float]* noalias %src, float* %dst) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[INNER_PREHEADER:%.*]]
; CHECK:       outer.header.preheader:
; CHECK-NEXT:    br label [[OUTER_HEADER:%.*]]
; CHECK:       outer.header:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[I_NEXT:%.*]], [[OUTER_LATCH:%.*]] ], [ 0, [[OUTER_HEADER_PREHEADER:%.*]] ]
; CHECK-NEXT:    br label [[INNER_SPLIT1:%.*]]
; CHECK:       inner.preheader:
; CHECK-NEXT:    br label [[INNER:%.*]]
; CHECK:       inner:
; CHECK-NEXT:    [[J:%.*]] = phi i64 [ [[TMP0:%.*]], [[INNER_SPLIT:%.*]] ], [ 0, [[INNER_PREHEADER]] ]
; CHECK-NEXT:    br label [[OUTER_HEADER_PREHEADER]]
; CHECK:       inner.split1:
; CHECK-NEXT:    [[SRC_GEP:%.*]] = getelementptr inbounds [256 x float], [256 x float]* [[SRC:%.*]], <2 x i64> <i64 0, i64 1>, i64 [[J]]
; CHECK-NEXT:    [[SRC_0:%.*]] = extractelement <2 x float*> [[SRC_GEP]], i32 0
; CHECK-NEXT:    [[LV_0:%.*]] = load float, float* [[SRC_0]], align 4
; CHECK-NEXT:    [[ADD_0:%.*]] = fadd float [[LV_0]], 1.000000e+00
; CHECK-NEXT:    [[DST_GEP:%.*]] = getelementptr inbounds float, float* [[DST:%.*]], i64 [[J]]
; CHECK-NEXT:    store float [[ADD_0]], float* [[DST_GEP]], align 4
; CHECK-NEXT:    [[J_NEXT:%.*]] = add nuw nsw i64 [[J]], 1
; CHECK-NEXT:    [[INNER_EXITCOND:%.*]] = icmp eq i64 [[J_NEXT]], 100
; CHECK-NEXT:    br label [[OUTER_LATCH]]
; CHECK:       inner.split:
; CHECK-NEXT:    [[TMP0]] = add nuw nsw i64 [[J]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq i64 [[TMP0]], 100
; CHECK-NEXT:    br i1 [[TMP1]], label [[EXIT:%.*]], label [[INNER]]
; CHECK:       outer.latch:
; CHECK-NEXT:    [[I_NEXT]] = add nuw nsw i32 [[I]], 1
; CHECK-NEXT:    [[OUTER_EXITCOND:%.*]] = icmp eq i32 [[I_NEXT]], 100
; CHECK-NEXT:    br i1 [[OUTER_EXITCOND]], label [[INNER_SPLIT]], label [[OUTER_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %outer.header

outer.header:
  %i = phi i32 [ %i.next, %outer.latch ], [ 0, %entry ]
  br label %inner

inner:
  %j = phi i64 [ 0, %outer.header ], [ %j.next, %inner ]
  %src.gep = getelementptr inbounds [256 x float], [256 x float]* %src, <2 x i64> <i64 0, i64 1>, i64 %j
  %src.0 = extractelement <2 x float*> %src.gep, i32 0
  %lv.0 = load float, float* %src.0
  %add.0 = fadd float %lv.0, 1.0
  %dst.gep = getelementptr inbounds float, float* %dst, i64 %j
  store float %add.0, float* %dst.gep
  %j.next = add nuw nsw i64 %j, 1
  %inner.exitcond = icmp eq i64 %j.next, 100
  br i1 %inner.exitcond, label %outer.latch, label %inner

outer.latch:
  %i.next = add nuw nsw i32 %i, 1
  %outer.exitcond = icmp eq i32 %i.next, 100
  br i1 %outer.exitcond, label %exit, label %outer.header

exit:
  ret void
}
