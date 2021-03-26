; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s | FileCheck %s
; RUN: llvm-dis < %s.bc | FileCheck %s

; Verifying auto-upgrade for the change related to llvm.powi with the exponent
; now being an overloaded operand.
define void @foo(double %a, float %b, i32 %c) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    [[T1:%.*]] = call double @llvm.powi.f64.i32(double [[A:%.*]], i32 [[C:%.*]])
; CHECK-NEXT:    [[T2:%.*]] = call float @llvm.powi.f32.i32(float [[B:%.*]], i32 [[C]])
; CHECK-NEXT:    ret void
;
  %t1 = call double @llvm.powi.f64(double %a, i32 %c)
  %t2 = call float @llvm.powi.f32(float %b, i32 %c)
  ret void
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare double @llvm.powi.f64(double, i32) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.powi.f32(float, i32) #2

attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
