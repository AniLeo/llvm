; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -disable-post-ra -mtriple=armv7-apple-darwin -mcpu=cortex-a8 | FileCheck %s -check-prefix=SOFT
; RUN: llc < %s -disable-post-ra -mtriple=armv7-gnueabi -float-abi=hard -mcpu=cortex-a8 | FileCheck %s -check-prefix=HARD

; rdar://8984306
define float @test1(float %x, float %y) nounwind {
; SOFT-LABEL: test1:
; SOFT:       @ %bb.0: @ %entry
; SOFT-NEXT:    lsr r1, r1, #31
; SOFT-NEXT:    bfi r0, r1, #31, #1
; SOFT-NEXT:    bx lr
;
; HARD-LABEL: test1:
; HARD:       @ %bb.0: @ %entry
; HARD-NEXT:    vmov.f32 s2, s1
; HARD-NEXT:    @ kill: def $s0 killed $s0 def $d0
; HARD-NEXT:    vmov.i32 d16, #0x80000000
; HARD-NEXT:    vbit d0, d1, d16
; HARD-NEXT:    @ kill: def $s0 killed $s0 killed $d0
; HARD-NEXT:    bx lr
entry:

  %0 = tail call float @copysignf(float %x, float %y) nounwind readnone
  ret float %0
}

define double @test2(double %x, double %y) nounwind {
; SOFT-LABEL: test2:
; SOFT:       @ %bb.0: @ %entry
; SOFT-NEXT:    lsr r2, r3, #31
; SOFT-NEXT:    bfi r1, r2, #31, #1
; SOFT-NEXT:    bx lr
;
; HARD-LABEL: test2:
; HARD:       @ %bb.0: @ %entry
; HARD-NEXT:    vmov.i32 d16, #0x80000000
; HARD-NEXT:    vshl.i64 d16, d16, #32
; HARD-NEXT:    vbit d0, d1, d16
; HARD-NEXT:    bx lr
entry:

  %0 = tail call double @copysign(double %x, double %y) nounwind readnone
  ret double %0
}

define double @test3(double %x, double %y, double %z) nounwind {
; SOFT-LABEL: test3:
; SOFT:       @ %bb.0: @ %entry
; SOFT-NEXT:    vmov d16, r2, r3
; SOFT-NEXT:    vmov d17, r0, r1
; SOFT-NEXT:    vmul.f64 d16, d17, d16
; SOFT-NEXT:    vmov.i32 d17, #0x80000000
; SOFT-NEXT:    vshl.i64 d17, d17, #32
; SOFT-NEXT:    vldr d18, [sp]
; SOFT-NEXT:    vbit d16, d18, d17
; SOFT-NEXT:    vmov r0, r1, d16
; SOFT-NEXT:    bx lr
;
; HARD-LABEL: test3:
; HARD:       @ %bb.0: @ %entry
; HARD-NEXT:    vmul.f64 d16, d0, d1
; HARD-NEXT:    vmov.i32 d17, #0x80000000
; HARD-NEXT:    vshl.i64 d17, d17, #32
; HARD-NEXT:    vorr d0, d17, d17
; HARD-NEXT:    vbsl d0, d2, d16
; HARD-NEXT:    bx lr
entry:
  %0 = fmul double %x, %y
  %1 = tail call double @copysign(double %0, double %z) nounwind readnone
  ret double %1
}

; rdar://9287902
define float @test4() nounwind {
; SOFT-LABEL: test4:
; SOFT:       @ %bb.0: @ %entry
; SOFT-NEXT:    push {lr}
; SOFT-NEXT:    bl _bar
; SOFT-NEXT:    vmov d16, r0, r1
; SOFT-NEXT:    vcvt.f32.f64 s0, d16
; SOFT-NEXT:    vmov.i32 d17, #0x80000000
; SOFT-NEXT:    vshr.u64 d16, d16, #32
; SOFT-NEXT:    vmov.f32 d18, #5.000000e-01
; SOFT-NEXT:    vbif d16, d18, d17
; SOFT-NEXT:    vadd.f32 d0, d0, d16
; SOFT-NEXT:    vmov r0, s0
; SOFT-NEXT:    pop {lr}
;
; HARD-LABEL: test4:
; HARD:       @ %bb.0: @ %entry
; HARD-NEXT:    .save {r11, lr}
; HARD-NEXT:    push {r11, lr}
; HARD-NEXT:    bl bar
; HARD-NEXT:    vmov d16, r0, r1
; HARD-NEXT:    vcvt.f32.f64 s0, d16
; HARD-NEXT:    vmov.i32 d17, #0x80000000
; HARD-NEXT:    vshr.u64 d16, d16, #32
; HARD-NEXT:    vmov.f32 s2, #5.000000e-01
; HARD-NEXT:    vbit d1, d16, d17
; HARD-NEXT:    vadd.f32 s0, s0, s2
; HARD-NEXT:    pop {r11, pc}
entry:
  %0 = tail call double (...) @bar() nounwind
  %1 = fptrunc double %0 to float
  %2 = tail call float @copysignf(float 5.000000e-01, float %1) nounwind readnone
  %3 = fadd float %1, %2
  ret float %3
}

declare double @bar(...)
declare double @copysign(double, double) nounwind
declare float @copysignf(float, float) nounwind
