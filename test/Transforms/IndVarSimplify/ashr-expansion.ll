; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -indvars -S %s | FileCheck %s

target datalayout = "e-m:o-i64:64-i128:128-n32:64-S128"

define float @ashr_expansion_valid(i64 %x, float* %ptr) {
; CHECK-LABEL: @ashr_expansion_valid(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BOUND:%.*]] = ashr i64 [[X:%.*]], 4
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[BOUND]], i64 1)
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[RED:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[RED_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr float, float* [[PTR:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[LV:%.*]] = load float, float* [[GEP]], align 4
; CHECK-NEXT:    [[RED_NEXT]] = fadd float [[LV]], [[RED]]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[IV_NEXT]], [[UMAX]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[LCSSA_RED_NEXT:%.*]] = phi float [ [[RED_NEXT]], [[LOOP]] ]
; CHECK-NEXT:    ret float [[LCSSA_RED_NEXT]]
;
entry:
  %bound = ashr exact i64 %x, 4
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %red = phi float [ 0.0, %entry ], [ %red.next, %loop ]
  %gep = getelementptr float, float* %ptr, i64 %iv
  %lv = load float, float* %gep
  %red.next = fadd float %lv, %red
  %iv.next = add nuw i64 %iv, 1
  %cond = icmp ult i64 %iv.next, %bound
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %bb135
  %lcssa.red.next = phi float [ %red.next, %loop ]
  ret float %lcssa.red.next
}

; No explicit ashr, but a chain of operations that can be replaced by ashr.
define float @ashr_equivalent_expansion(i64 %x, float* %ptr) {
; CHECK-LABEL: @ashr_equivalent_expansion(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ABS_X:%.*]] = call i64 @llvm.abs.i64(i64 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[DIV:%.*]] = udiv exact i64 [[ABS_X]], 16
; CHECK-NEXT:    [[T0:%.*]] = call i64 @llvm.smax.i64(i64 [[X]], i64 -1)
; CHECK-NEXT:    [[T1:%.*]] = call i64 @llvm.smin.i64(i64 [[T0]], i64 1)
; CHECK-NEXT:    [[BOUND:%.*]] = mul i64 [[DIV]], [[T1]]
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[BOUND]], i64 1)
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[RED:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[RED_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr float, float* [[PTR:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[LV:%.*]] = load float, float* [[GEP]], align 4
; CHECK-NEXT:    [[RED_NEXT]] = fadd float [[LV]], [[RED]]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[IV_NEXT]], [[UMAX]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[LCSSA_RED_NEXT:%.*]] = phi float [ [[RED_NEXT]], [[LOOP]] ]
; CHECK-NEXT:    ret float [[LCSSA_RED_NEXT]]
;
entry:
  %abs_x = call i64 @llvm.abs.i64(i64 %x, i1 false)
  %div = udiv exact i64 %abs_x, 16
  %t0 = call i64 @llvm.smax.i64(i64 %x, i64 -1)
  %t1 = call i64 @llvm.smin.i64(i64 %t0, i64 1)
  %bound = mul nsw i64 %div, %t1
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %red = phi float [ 0.0, %entry ], [ %red.next, %loop ]
  %gep = getelementptr float, float* %ptr, i64 %iv
  %lv = load float, float* %gep
  %red.next = fadd float %lv, %red
  %iv.next = add nuw i64 %iv, 1
  %cond = icmp ult i64 %iv.next, %bound
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %bb135
  %lcssa.red.next = phi float [ %red.next, %loop ]
  ret float %lcssa.red.next
}

; Chain of operations that *cannot* be replaced by ashr, because the udiv is
; missing exact.
define float @no_ashr_due_to_missing_exact_udiv(i64 %x, float* %ptr) {
; CHECK-LABEL: @no_ashr_due_to_missing_exact_udiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ABS_X:%.*]] = call i64 @llvm.abs.i64(i64 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 [[ABS_X]], 16
; CHECK-NEXT:    [[T0:%.*]] = call i64 @llvm.smax.i64(i64 [[X]], i64 -1)
; CHECK-NEXT:    [[T1:%.*]] = call i64 @llvm.smin.i64(i64 [[T0]], i64 1)
; CHECK-NEXT:    [[BOUND:%.*]] = mul i64 [[DIV]], [[T1]]
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[BOUND]], i64 1)
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[RED:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[RED_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr float, float* [[PTR:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[LV:%.*]] = load float, float* [[GEP]], align 4
; CHECK-NEXT:    [[RED_NEXT]] = fadd float [[LV]], [[RED]]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[IV_NEXT]], [[UMAX]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[LCSSA_RED_NEXT:%.*]] = phi float [ [[RED_NEXT]], [[LOOP]] ]
; CHECK-NEXT:    ret float [[LCSSA_RED_NEXT]]
;
entry:
  %abs_x = call i64 @llvm.abs.i64(i64 %x, i1 false)
  %div = udiv i64 %abs_x, 16
  %t0 = call i64 @llvm.smax.i64(i64 %x, i64 -1)
  %t1 = call i64 @llvm.smin.i64(i64 %t0, i64 1)
  %bound = mul nsw i64 %div, %t1
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %red = phi float [ 0.0, %entry ], [ %red.next, %loop ]
  %gep = getelementptr float, float* %ptr, i64 %iv
  %lv = load float, float* %gep
  %red.next = fadd float %lv, %red
  %iv.next = add nuw i64 %iv, 1
  %cond = icmp ult i64 %iv.next, %bound
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %bb135
  %lcssa.red.next = phi float [ %red.next, %loop ]
  ret float %lcssa.red.next
}

; Chain of operations that *cannot* be replaced by ashr, because abs and
; signum have different operands.
define float @no_ashr_due_to_different_ops(i64 %x, i64 %y, float* %ptr) {
; CHECK-LABEL: @no_ashr_due_to_different_ops(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ABS_X:%.*]] = call i64 @llvm.abs.i64(i64 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[DIV:%.*]] = udiv i64 [[ABS_X]], 16
; CHECK-NEXT:    [[T0:%.*]] = call i64 @llvm.smax.i64(i64 [[Y:%.*]], i64 -1)
; CHECK-NEXT:    [[T1:%.*]] = call i64 @llvm.smin.i64(i64 [[T0]], i64 1)
; CHECK-NEXT:    [[BOUND:%.*]] = mul i64 [[DIV]], [[T1]]
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[BOUND]], i64 1)
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[RED:%.*]] = phi float [ 0.000000e+00, [[ENTRY]] ], [ [[RED_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr float, float* [[PTR:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[LV:%.*]] = load float, float* [[GEP]], align 4
; CHECK-NEXT:    [[RED_NEXT]] = fadd float [[LV]], [[RED]]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i64 [[IV_NEXT]], [[UMAX]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    [[LCSSA_RED_NEXT:%.*]] = phi float [ [[RED_NEXT]], [[LOOP]] ]
; CHECK-NEXT:    ret float [[LCSSA_RED_NEXT]]
;
entry:
  %abs_x = call i64 @llvm.abs.i64(i64 %x, i1 false)
  %div = udiv i64 %abs_x, 16
  %t0 = call i64 @llvm.smax.i64(i64 %y, i64 -1)
  %t1 = call i64 @llvm.smin.i64(i64 %t0, i64 1)
  %bound = mul nsw i64 %div, %t1
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %red = phi float [ 0.0, %entry ], [ %red.next, %loop ]
  %gep = getelementptr float, float* %ptr, i64 %iv
  %lv = load float, float* %gep
  %red.next = fadd float %lv, %red
  %iv.next = add nuw i64 %iv, 1
  %cond = icmp ult i64 %iv.next, %bound
  br i1 %cond, label %loop, label %exit

exit:                                             ; preds = %bb135
  %lcssa.red.next = phi float [ %red.next, %loop ]
  ret float %lcssa.red.next
}

declare i64 @llvm.abs.i64(i64, i1)

declare i64 @llvm.smax.i64(i64, i64)

declare i64 @llvm.smin.i64(i64, i64)
