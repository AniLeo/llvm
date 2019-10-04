; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -mtriple=x86_64-gnu-linux < %s | FileCheck %s

define x86_fp80 @constrained_fpext_f32_as_fp80(float %mem) #0 {
; CHECK-LABEL: constrained_fpext_f32_as_fp80:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movss %xmm0, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    flds -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    retq
entry:
  %ext = call x86_fp80 @llvm.experimental.constrained.fpext.f80.f32(
            float %mem,
            metadata !"fpexcept.strict") #0
  ret x86_fp80 %ext
}

define float @constrained_fptrunc_f80_to_f32(x86_fp80 %reg) #0 {
; CHECK-LABEL: constrained_fptrunc_f80_to_f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fstps -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    retq
  %trunc = call float @llvm.experimental.constrained.fptrunc.f32.f80(
             x86_fp80 %reg,
             metadata !"round.dynamic",
             metadata !"fpexcept.strict") #0
  ret float %trunc
}

define x86_fp80 @constrained_fpext_f64_to_f80(double %mem) #0 {
; CHECK-LABEL: constrained_fpext_f64_to_f80:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movsd %xmm0, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    fldl -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    retq
entry:
  %ext = call x86_fp80 @llvm.experimental.constrained.fpext.f80.f64(
            double %mem,
            metadata !"fpexcept.strict") #0
  ret x86_fp80 %ext
}

define double @constrained_fptrunc_f80_to_f64(x86_fp80 %reg) #0 {
; CHECK-LABEL: constrained_fptrunc_f80_to_f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fstpl -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    retq
  %trunc = call double @llvm.experimental.constrained.fptrunc.f64.f80(
             x86_fp80 %reg,
             metadata !"round.dynamic",
             metadata !"fpexcept.strict") #0
  ret double %trunc
}

attributes #0 = { strictfp }

declare x86_fp80 @llvm.experimental.constrained.fpext.f80.f32(float, metadata)
declare x86_fp80 @llvm.experimental.constrained.fpext.f80.f64(double, metadata)
declare float @llvm.experimental.constrained.fptrunc.f32.f80(x86_fp80, metadata, metadata)
declare double @llvm.experimental.constrained.fptrunc.f64.f80(x86_fp80, metadata, metadata)
