; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=armv6-eabi %s -o - | FileCheck %s 
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+dsp %s -o - | FileCheck %s

define arm_aapcs_vfpcc i32 @ssat_lsl(i32 %num){
; CHECK-LABEL:  ssat_lsl
; CHECK:        @ %bb.0: @ %entry
; CHECK-NEXT: 	ssat	r0, #8, r0, lsl #7
; CHECK-NEXT:   bx	lr
entry:
  %shl = shl i32 %num, 7
  %0 = tail call i32 @llvm.arm.ssat(i32 %shl, i32 8)
  ret i32 %0
}

define arm_aapcs_vfpcc i32 @ssat_asr(i32 %num){
; CHECK-LABEL:  ssat_asr
; CHECK:        @ %bb.0: @ %entry
; CHECK-NEXT:   ssat	r0, #8, r0, asr #7
; CHECK-NEXT:   bx	lr
entry:
  %shr = ashr i32 %num, 7
  %0 = tail call i32 @llvm.arm.ssat(i32 %shr, i32 8)
  ret i32 %0
}

declare i32 @llvm.arm.ssat(i32, i32)
