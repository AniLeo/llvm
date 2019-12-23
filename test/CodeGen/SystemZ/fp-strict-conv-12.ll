; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Test strict conversion of floating-point values to unsigned i64s (z10 only).
;
; RUN: llc < %s -mtriple=s390x-linux-gnu -mcpu=z10 | FileCheck %s

; z10 doesn't have native support for unsigned fp-to-i64 conversions;
; they were added in z196 as the Convert to Logical family of instructions.
; Convert via signed i64s instead.
; Note that the strict expansion sequence must be used.

declare i64 @llvm.experimental.constrained.fptoui.i64.f32(float, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.f64(double, metadata)
declare i64 @llvm.experimental.constrained.fptoui.i64.f128(fp128, metadata)

; Test f32->i64.
define i64 @f1(float %f) #0 {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    larl %r1, .LCPI0_0
; CHECK-NEXT:    le %f1, 0(%r1)
; CHECK-NEXT:    kebr %f0, %f1
; CHECK-NEXT:    jnl .LBB0_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    lghi %r0, 0
; CHECK-NEXT:    lzer %f1
; CHECK-NEXT:    j .LBB0_3
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    llihh %r0, 32768
; CHECK-NEXT:  .LBB0_3:
; CHECK-NEXT:    sebr %f0, %f1
; CHECK-NEXT:    cgebr %r2, 5, %f0
; CHECK-NEXT:    xgr %r2, %r0
; CHECK-NEXT:    br %r14
  %conv = call i64 @llvm.experimental.constrained.fptoui.i64.f32(float %f,
                                               metadata !"fpexcept.strict") #0
  ret i64 %conv
}

; Test f64->i64.
define i64 @f2(double %f) #0 {
; CHECK-LABEL: f2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    larl %r1, .LCPI1_0
; CHECK-NEXT:    ldeb %f1, 0(%r1)
; CHECK-NEXT:    kdbr %f0, %f1
; CHECK-NEXT:    jnl .LBB1_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    lghi %r0, 0
; CHECK-NEXT:    lzdr %f1
; CHECK-NEXT:    j .LBB1_3
; CHECK-NEXT:  .LBB1_2:
; CHECK-NEXT:    llihh %r0, 32768
; CHECK-NEXT:  .LBB1_3:
; CHECK-NEXT:    sdbr %f0, %f1
; CHECK-NEXT:    cgdbr %r2, 5, %f0
; CHECK-NEXT:    xgr %r2, %r0
; CHECK-NEXT:    br %r14
  %conv = call i64 @llvm.experimental.constrained.fptoui.i64.f64(double %f,
                                               metadata !"fpexcept.strict") #0
  ret i64 %conv
}

; Test f128->i64.
define i64 @f3(fp128 *%src) #0 {
; CHECK-LABEL: f3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ld %f0, 0(%r2)
; CHECK-NEXT:    ld %f2, 8(%r2)
; CHECK-NEXT:    larl %r1, .LCPI2_0
; CHECK-NEXT:    lxeb %f1, 0(%r1)
; CHECK-NEXT:    kxbr %f0, %f1
; CHECK-NEXT:    jnl .LBB2_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    lghi %r0, 0
; CHECK-NEXT:    lzxr %f1
; CHECK-NEXT:    j .LBB2_3
; CHECK-NEXT:  .LBB2_2:
; CHECK-NEXT:    llihh %r0, 32768
; CHECK-NEXT:  .LBB2_3:
; CHECK-NEXT:    sxbr %f0, %f1
; CHECK-NEXT:    cgxbr %r2, 5, %f0
; CHECK-NEXT:    xgr %r2, %r0
; CHECK-NEXT:    br %r14
  %f = load fp128, fp128 *%src
  %conv = call i64 @llvm.experimental.constrained.fptoui.i64.f128(fp128 %f,
                                               metadata !"fpexcept.strict") #0
  ret i64 %conv
}

attributes #0 = { strictfp }
