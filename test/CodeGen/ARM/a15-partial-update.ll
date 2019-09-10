; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O1 -mcpu=cortex-a15 -mtriple=armv7-linux-gnueabi -verify-machineinstrs < %s  | FileCheck %s

; The generated code for this test uses a vld1.32 instruction
; to write the lane 1 of a D register containing the value of
; <2 x float> %B. Since the D register is defined, it would
; be incorrect to fully write it (with a vmov.f64) before the
; vld1.32 instruction. The test checks that a vmov.f64 was not
; generated.

define <2 x float> @t1(float* %A, <2 x float> %B) {
; CHECK-LABEL: t1:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vmov d16, r2, r3
; CHECK-NEXT:    vld1.32 {d16[1]}, [r0:32]
; CHECK-NEXT:    vmov r0, r1, d16
; CHECK-NEXT:    bx lr
  %tmp2 = load float, float* %A, align 4
  %tmp3 = insertelement <2 x float> %B, float %tmp2, i32 1
  ret <2 x float> %tmp3
}

; The code generated by this test uses a vld1.32 instruction.
; We check that a dependency breaking vmov* instruction was
; generated.

define void @t2(<4 x i8> *%in, <4 x i8> *%out, i32 %n) {
; CHECK-LABEL: t2:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    add r0, r0, #4
; CHECK-NEXT:    add r1, r1, #4
; CHECK-NEXT:  .LBB1_1: @ %loop
; CHECK-NEXT:    @ =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    vmov.f64 d16, #5.000000e-01
; CHECK-NEXT:    vld1.32 {d16[0]}, [r0:32]
; CHECK-NEXT:    vmovl.u8 q8, d16
; CHECK-NEXT:    vuzp.8 d16, d18
; CHECK-NEXT:    vst1.32 {d16[0]}, [r1:32]!
; CHECK-NEXT:    add r0, r0, #4
; CHECK-NEXT:    subs r2, r2, #1
; CHECK-NEXT:    beq .LBB1_1
; CHECK-NEXT:  @ %bb.2: @ %ret
; CHECK-NEXT:    bx lr
entry:
  br label %loop
loop:
  %oldcount = phi i32 [0, %entry], [%newcount, %loop]
  %newcount = add i32 %oldcount, 1
  %p1 = getelementptr <4 x i8>, <4 x i8> *%in, i32 %newcount
  %p2 = getelementptr <4 x i8>, <4 x i8> *%out, i32 %newcount
  %tmp1 = load <4 x i8> , <4 x i8> *%p1, align 4
  store <4 x i8> %tmp1, <4 x i8> *%p2
  %cmp = icmp eq i32 %newcount, %n
  br i1 %cmp, label %loop, label %ret
ret:
  ret void
}
