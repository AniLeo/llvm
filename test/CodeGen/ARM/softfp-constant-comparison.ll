; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv7em-arm-none-eabi < %s | FileCheck %s

target datalayout = "e-m:e-p:32:32-Fi8-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "thumbv7em-arm-none-eabi"

@a = hidden global i32 0, align 4

define hidden void @fn1() nounwind #0 {
; CHECK-LABEL: fn1:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    movs r0, #1
; CHECK-NEXT:    cbnz r0, .LBB0_2
; CHECK-NEXT:    b .LBB0_1
; CHECK-NEXT:  .LBB0_1: @ %land.rhs
; CHECK-NEXT:    b .LBB0_2
; CHECK-NEXT:  .LBB0_2: @ %land.end
; CHECK-NEXT:    bx lr
entry:
  %0 = load i32, i32* @a, align 4
  %conv = sitofp i32 %0 to double
  %mul = fmul nnan ninf nsz double 0.000000e+00, %conv
  %tobool = fcmp nnan ninf nsz une double %mul, 0.000000e+00
  br i1 %tobool, label %land.rhs, label %land.end

land.rhs:                                         ; preds = %entry
  br label %land.end

land.end:                                         ; preds = %land.rhs, %entry
  %1 = phi i1 [ false, %entry ], [ false, %land.rhs ]
  %land.ext = zext i1 %1 to i32
  ret void
}

attributes #0 = { noinline nounwind optnone "correctly-rounded-divide-sqrt-fp-math"="false" "denormal-fp-math"="preserve-sign,preserve-sign" "disable-tail-calls"="false" "frame-pointer"="none" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="true" "no-jump-tables"="false" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="cortex-m4" "target-features"="+armv7e-m,+dsp,+fp16,+hwdiv,+thumb-mode,+vfp2sp,+vfp3d16sp,+vfp4d16sp,-aes,-crc,-crypto,-dotprod,-fp16fml,-fullfp16,-hwdiv-arm,-lob,-mve,-mve.fp,-ras,-sb,-sha2" "unsafe-fp-math"="false" "use-soft-float"="false" }
