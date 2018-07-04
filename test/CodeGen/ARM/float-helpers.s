; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -asm-verbose=false -mattr=-vfp2 -mtriple=arm-eabi < %s | FileCheck %s -check-prefix=CHECK-ALL -check-prefix=CHECK-SOFT
; RUN: llc -asm-verbose=false -mattr=-vfp2 -mtriple=arm-eabi -meabi=gnu < %s | FileCheck %s -check-prefix=CHECK-ALL -check-prefix=CHECK-SOFT
; RUN: llc -asm-verbose=false -mattr=+vfp3 -mtriple=arm-eabi < %s | FileCheck %s -check-prefix=CHECK-ALL -check-prefix=CHECK-SOFTFP
; RUN: llc -asm-verbose=false -mattr=+vfp3 -meabi=gnu -mtriple=arm-eabi < %s | FileCheck %s -check-prefix=CHECK-ALL -check-prefix=CHECK-SOFTFP
; RUN: llc -asm-verbose=false -mattr=+vfp3 -float-abi=hard -mtriple=arm-eabi < %s | FileCheck %s -check-prefix=CHECK-ALL -check-prefix=CHECK-HARDFP-SP -check-prefix=CHECK-HARDFP-DP
; RUN: llc -asm-verbose=false -mattr=+vfp3 -float-abi=hard -meabi=gnu -mtriple=arm-eabi < %s | FileCheck %s -check-prefix=CHECK-ALL -check-prefix=CHECK-HARDFP-SP -check-prefix=CHECK-HARDFP-DP
; RUN: llc -asm-verbose=false -mattr=+vfp3,+fp-only-sp -float-abi=hard -mtriple=arm-eabi < %s | FileCheck %s -check-prefix=CHECK-ALL -check-prefix=CHECK-HARDFP-SP -check-prefix=CHECK-HARDFP-SPONLY
; RUN: llc -asm-verbose=false -mattr=+vfp3,+fp-only-sp -float-abi=hard -mtriple=arm-eabi -meabi=gnu < %s | FileCheck %s -check-prefix=CHECK-ALL -check-prefix=CHECK-HARDFP-SP -check-prefix=CHECK-HARDFP-SPONLY

; The Runtime ABI for the ARM Architecture IHI0043 section 4.1.2 The
; floating-point helper functions to always use the base AAPCS (soft-float)
; calling convention.

; In this test we cover the following configurations:
; CHECK-SOFT -mfloat-abi=soft
;     * expect no use of floating point instructions
;     * expect to use __aeabi_ helper function in each function
; CHECK-SOFTFP -mfloat-abi=softfp
;     * all functions use base AAPCS
;     * floating point instructions permitted, so __aeabi_ helpers only
;       expected when there is no available instruction.
; CHECK-HARDFP-SP -mfloat-abi=hardfp (single precision instructions)
;     * all non Runtime ABI helper functions use AAPCS VFP
;     * floating point instructions permitted, so __aeabi_ helpers only
;       expected when there is no available instruction.
; CHECK-HARDFP-DP -mfloat-abi=hardfp (double precision instructions)
; CHECK-HARDFP-SPONLY -mfloat-abi=hardfp (double precision but single
;                      precision only FPU)
;     * as CHECK-HARDFP-SP, but we split up the double precision helper
;       functions so we can test a single precision only FPU, which has to use
;       helper function for all double precision operations.

; In all cases we must use base AAPCS when calling a helper function from
; section 4.1.2.

target datalayout = "e-m:e-p:32:32-i64:64-v128:64:128-a:0:32-n32-S64"
target triple = "arm-eabi"

define float @fadd(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fadd:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fadd
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fadd:
; CHECK-SOFTFP:         vmov s0, r1
; CHECK-SOFTFP-NEXT:    vmov s2, r0
; CHECK-SOFTFP-NEXT:    vadd.f32 s0, s2, s0
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fadd:
; CHECK-HARDFP-SP:         vadd.f32 s0, s0, s1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %add = fadd float %a, %b
  ret float %add
}

define float @fdiv(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fdiv:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fdiv
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fdiv:
; CHECK-SOFTFP:         vmov s0, r1
; CHECK-SOFTFP-NEXT:    vmov s2, r0
; CHECK-SOFTFP-NEXT:    vdiv.f32 s0, s2, s0
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fdiv:
; CHECK-HARDFP-SP:         vdiv.f32 s0, s0, s1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %div = fdiv float %a, %b
  ret float %div
}

define float @fmul(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fmul:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fmul
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fmul:
; CHECK-SOFTFP:         vmov s0, r1
; CHECK-SOFTFP-NEXT:    vmov s2, r0
; CHECK-SOFTFP-NEXT:    vmul.f32 s0, s2, s0
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fmul:
; CHECK-HARDFP-SP:         vmul.f32 s0, s0, s1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %mul = fmul float %a, %b
  ret float %mul
}

define float @fsub(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fsub:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fsub
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fsub:
; CHECK-SOFTFP:         vmov s0, r1
; CHECK-SOFTFP-NEXT:    vmov s2, r0
; CHECK-SOFTFP-NEXT:    vsub.f32 s0, s2, s0
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fsub:
; CHECK-HARDFP-SP:         vsub.f32 s0, s0, s1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %sub = fsub float %a, %b
  ret float %sub
}

define i32 @fcmpeq(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fcmpeq:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fcmpeq
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fcmpeq:
; CHECK-SOFTFP:         vmov s2, r0
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vmov s0, r1
; CHECK-SOFTFP-NEXT:    vcmp.f32 s2, s0
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    moveq r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fcmpeq:
; CHECK-HARDFP-SP:         vcmp.f32 s0, s1
; CHECK-HARDFP-SP-NEXT:    mov r0, #0
; CHECK-HARDFP-SP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-SP-NEXT:    moveq r0, #1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %cmp = fcmp oeq float %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @fcmplt(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fcmplt:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fcmplt
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fcmplt:
; CHECK-SOFTFP:         vmov s2, r0
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vmov s0, r1
; CHECK-SOFTFP-NEXT:    vcmpe.f32 s2, s0
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movmi r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fcmplt:
; CHECK-HARDFP-SP:         vcmpe.f32 s0, s1
; CHECK-HARDFP-SP-NEXT:    mov r0, #0
; CHECK-HARDFP-SP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-SP-NEXT:    movmi r0, #1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %cmp = fcmp olt float %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @fcmple(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fcmple:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fcmple
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fcmple:
; CHECK-SOFTFP:         vmov s2, r0
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vmov s0, r1
; CHECK-SOFTFP-NEXT:    vcmpe.f32 s2, s0
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movls r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fcmple:
; CHECK-HARDFP-SP:         vcmpe.f32 s0, s1
; CHECK-HARDFP-SP-NEXT:    mov r0, #0
; CHECK-HARDFP-SP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-SP-NEXT:    movls r0, #1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %cmp = fcmp ole float %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @fcmpge(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fcmpge:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fcmpge
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fcmpge:
; CHECK-SOFTFP:         vmov s2, r0
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vmov s0, r1
; CHECK-SOFTFP-NEXT:    vcmpe.f32 s2, s0
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movge r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fcmpge:
; CHECK-HARDFP-SP:         vcmpe.f32 s0, s1
; CHECK-HARDFP-SP-NEXT:    mov r0, #0
; CHECK-HARDFP-SP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-SP-NEXT:    movge r0, #1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %cmp = fcmp oge float %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @fcmpgt(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fcmpgt:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fcmpgt
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fcmpgt:
; CHECK-SOFTFP:         vmov s2, r0
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vmov s0, r1
; CHECK-SOFTFP-NEXT:    vcmpe.f32 s2, s0
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movgt r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fcmpgt:
; CHECK-HARDFP-SP:         vcmpe.f32 s0, s1
; CHECK-HARDFP-SP-NEXT:    mov r0, #0
; CHECK-HARDFP-SP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-SP-NEXT:    movgt r0, #1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %cmp = fcmp ogt float %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @fcmpun(float %a, float %b) #0 {
; CHECK-SOFT-LABEL: fcmpun:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_fcmpun
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: fcmpun:
; CHECK-SOFTFP:         vmov s2, r0
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vmov s0, r1
; CHECK-SOFTFP-NEXT:    vcmpe.f32 s2, s0
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movvs r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: fcmpun:
; CHECK-HARDFP-SP:         vcmpe.f32 s0, s1
; CHECK-HARDFP-SP-NEXT:    mov r0, #0
; CHECK-HARDFP-SP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-SP-NEXT:    movvs r0, #1
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %cmp = fcmp uno float %a, %b
  %0 = zext i1 %cmp to i32
  ret i32 %0
}

define double @dadd(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: dadd:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_dadd
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: dadd:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    vadd.f64 d16, d17, d16
; CHECK-SOFTFP-NEXT:    vmov r0, r1, d16
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: dadd:
; CHECK-HARDFP-DP:         vadd.f64 d0, d0, d1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: dadd:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_dadd
; CHECK-HARDFP-SPONLY-NEXT:    vmov d0, r0, r1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %add = fadd double %a, %b
  ret double %add
}

define double @ddiv(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: ddiv:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_ddiv
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: ddiv:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    vdiv.f64 d16, d17, d16
; CHECK-SOFTFP-NEXT:    vmov r0, r1, d16
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: ddiv:
; CHECK-HARDFP-DP:         vdiv.f64 d0, d0, d1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: ddiv:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_ddiv
; CHECK-HARDFP-SPONLY-NEXT:    vmov d0, r0, r1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %div = fdiv double %a, %b
  ret double %div
}

define double @dmul(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: dmul:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_dmul
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: dmul:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    vmul.f64 d16, d17, d16
; CHECK-SOFTFP-NEXT:    vmov r0, r1, d16
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: dmul:
; CHECK-HARDFP-DP:         vmul.f64 d0, d0, d1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: dmul:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_dmul
; CHECK-HARDFP-SPONLY-NEXT:    vmov d0, r0, r1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %mul = fmul double %a, %b
  ret double %mul
}

define double @dsub(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: dsub:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_dsub
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: dsub:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    vsub.f64 d16, d17, d16
; CHECK-SOFTFP-NEXT:    vmov r0, r1, d16
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: dsub:
; CHECK-HARDFP-DP:         vsub.f64 d0, d0, d1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: dsub:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_dsub
; CHECK-HARDFP-SPONLY-NEXT:    vmov d0, r0, r1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %sub = fsub double %a, %b
  ret double %sub
}

define i32 @dcmpeq(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: dcmpeq:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_dcmpeq
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: dcmpeq:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vcmp.f64 d17, d16
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    moveq r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: dcmpeq:
; CHECK-HARDFP-DP:         vcmp.f64 d0, d1
; CHECK-HARDFP-DP-NEXT:    mov r0, #0
; CHECK-HARDFP-DP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-DP-NEXT:    moveq r0, #1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: dcmpeq:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_dcmpeq
; CHECK-HARDFP-SPONLY-NEXT:    cmp r0, #0
; CHECK-HARDFP-SPONLY-NEXT:    movne r0, #1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %cmp = fcmp oeq double %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @dcmplt(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: dcmplt:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_dcmplt
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: dcmplt:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vcmpe.f64 d17, d16
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movmi r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: dcmplt:
; CHECK-HARDFP-DP:         vcmpe.f64 d0, d1
; CHECK-HARDFP-DP-NEXT:    mov r0, #0
; CHECK-HARDFP-DP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-DP-NEXT:    movmi r0, #1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: dcmplt:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_dcmplt
; CHECK-HARDFP-SPONLY-NEXT:    cmp r0, #0
; CHECK-HARDFP-SPONLY-NEXT:    movne r0, #1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %cmp = fcmp olt double %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @dcmple(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: dcmple:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_dcmple
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: dcmple:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vcmpe.f64 d17, d16
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movls r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: dcmple:
; CHECK-HARDFP-DP:         vcmpe.f64 d0, d1
; CHECK-HARDFP-DP-NEXT:    mov r0, #0
; CHECK-HARDFP-DP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-DP-NEXT:    movls r0, #1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: dcmple:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_dcmple
; CHECK-HARDFP-SPONLY-NEXT:    cmp r0, #0
; CHECK-HARDFP-SPONLY-NEXT:    movne r0, #1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %cmp = fcmp ole double %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @dcmpge(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: dcmpge:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_dcmpge
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: dcmpge:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vcmpe.f64 d17, d16
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movge r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: dcmpge:
; CHECK-HARDFP-DP:         vcmpe.f64 d0, d1
; CHECK-HARDFP-DP-NEXT:    mov r0, #0
; CHECK-HARDFP-DP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-DP-NEXT:    movge r0, #1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: dcmpge:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_dcmpge
; CHECK-HARDFP-SPONLY-NEXT:    cmp r0, #0
; CHECK-HARDFP-SPONLY-NEXT:    movne r0, #1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %cmp = fcmp oge double %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @dcmpgt(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: dcmpgt:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_dcmpgt
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: dcmpgt:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vcmpe.f64 d17, d16
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movgt r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: dcmpgt:
; CHECK-HARDFP-DP:         vcmpe.f64 d0, d1
; CHECK-HARDFP-DP-NEXT:    mov r0, #0
; CHECK-HARDFP-DP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-DP-NEXT:    movgt r0, #1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: dcmpgt:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_dcmpgt
; CHECK-HARDFP-SPONLY-NEXT:    cmp r0, #0
; CHECK-HARDFP-SPONLY-NEXT:    movne r0, #1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %cmp = fcmp ogt double %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @dcmpun(double %a, double %b) #0 {
; CHECK-SOFT-LABEL: dcmpun:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_dcmpun
; CHECK-SOFT-NEXT:    cmp r0, #0
; CHECK-SOFT-NEXT:    movne r0, #1
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: dcmpun:
; CHECK-SOFTFP:         vmov d16, r2, r3
; CHECK-SOFTFP-NEXT:    vmov d17, r0, r1
; CHECK-SOFTFP-NEXT:    mov r0, #0
; CHECK-SOFTFP-NEXT:    vcmpe.f64 d17, d16
; CHECK-SOFTFP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-SOFTFP-NEXT:    movvs r0, #1
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: dcmpun:
; CHECK-HARDFP-DP:         vcmpe.f64 d0, d1
; CHECK-HARDFP-DP-NEXT:    mov r0, #0
; CHECK-HARDFP-DP-NEXT:    vmrs APSR_nzcv, fpscr
; CHECK-HARDFP-DP-NEXT:    movvs r0, #1
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: dcmpun:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    vmov r2, r3, d1
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_dcmpun
; CHECK-HARDFP-SPONLY-NEXT:    cmp r0, #0
; CHECK-HARDFP-SPONLY-NEXT:    movne r0, #1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %cmp = fcmp uno double %a, %b
  %0 = zext i1 %cmp to i32
  ret i32 %0
}

define i32 @d2iz(double %a) #0 {
; CHECK-SOFT-LABEL: d2iz:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_d2iz
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: d2iz:
; CHECK-SOFTFP:         vmov d16, r0, r1
; CHECK-SOFTFP-NEXT:    vcvt.s32.f64 s0, d16
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: d2iz:
; CHECK-HARDFP-DP:         vcvt.s32.f64 s0, d0
; CHECK-HARDFP-DP-NEXT:    vmov r0, s0
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: d2iz:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_d2iz
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %conv = fptosi double %a to i32
  ret i32 %conv
}

define i32 @d2uiz(double %a) #0 {
; CHECK-SOFT-LABEL: d2uiz:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_d2uiz
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: d2uiz:
; CHECK-SOFTFP:         vmov d16, r0, r1
; CHECK-SOFTFP-NEXT:    vcvt.u32.f64 s0, d16
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: d2uiz:
; CHECK-HARDFP-DP:         vcvt.u32.f64 s0, d0
; CHECK-HARDFP-DP-NEXT:    vmov r0, s0
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: d2uiz:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_d2uiz
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %conv = fptoui double %a to i32
  ret i32 %conv
}

define i64 @d2lz(double %a) #0 {
; CHECK-SOFT-LABEL: d2lz:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_d2lz
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: d2lz:
; CHECK-SOFTFP:         .save {r11, lr}
; CHECK-SOFTFP-NEXT:    push {r11, lr}
; CHECK-SOFTFP-NEXT:    bl __aeabi_d2lz
; CHECK-SOFTFP-NEXT:    pop {r11, lr}
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: d2lz:
; CHECK-HARDFP-SP:         .save {r11, lr}
; CHECK-HARDFP-SP-NEXT:    push {r11, lr}
; CHECK-HARDFP-SP-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SP-NEXT:    bl __aeabi_d2lz
; CHECK-HARDFP-SP-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = fptosi double %a to i64
  ret i64 %conv
}

define i64 @d2ulz(double %a) #0 {
; CHECK-SOFT-LABEL: d2ulz:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_d2ulz
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: d2ulz:
; CHECK-SOFTFP:         .save {r11, lr}
; CHECK-SOFTFP-NEXT:    push {r11, lr}
; CHECK-SOFTFP-NEXT:    bl __aeabi_d2ulz
; CHECK-SOFTFP-NEXT:    pop {r11, lr}
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: d2ulz:
; CHECK-HARDFP-SP:         .save {r11, lr}
; CHECK-HARDFP-SP-NEXT:    push {r11, lr}
; CHECK-HARDFP-SP-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SP-NEXT:    bl __aeabi_d2ulz
; CHECK-HARDFP-SP-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = fptoui double %a to i64
  ret i64 %conv
}

define i32 @f2iz(float %a) #0 {
; CHECK-SOFT-LABEL: f2iz:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_f2iz
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: f2iz:
; CHECK-SOFTFP:         vmov s0, r0
; CHECK-SOFTFP-NEXT:    vcvt.s32.f32 s0, s0
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: f2iz:
; CHECK-HARDFP-SP:         vcvt.s32.f32 s0, s0
; CHECK-HARDFP-SP-NEXT:    vmov r0, s0
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = fptosi float %a to i32
  ret i32 %conv
}

define i32 @f2uiz(float %a) #0 {
; CHECK-SOFT-LABEL: f2uiz:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_f2uiz
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: f2uiz:
; CHECK-SOFTFP:         vmov s0, r0
; CHECK-SOFTFP-NEXT:    vcvt.u32.f32 s0, s0
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: f2uiz:
; CHECK-HARDFP-SP:         vcvt.u32.f32 s0, s0
; CHECK-HARDFP-SP-NEXT:    vmov r0, s0
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = fptoui float %a to i32
  ret i32 %conv
}

define i64 @f2lz(float %a) #0 {
; CHECK-SOFT-LABEL: f2lz:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_f2lz
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: f2lz:
; CHECK-SOFTFP:         .save {r11, lr}
; CHECK-SOFTFP-NEXT:    push {r11, lr}
; CHECK-SOFTFP-NEXT:    bl __aeabi_f2lz
; CHECK-SOFTFP-NEXT:    pop {r11, lr}
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: f2lz:
; CHECK-HARDFP-SP:         .save {r11, lr}
; CHECK-HARDFP-SP-NEXT:    push {r11, lr}
; CHECK-HARDFP-SP-NEXT:    vmov r0, s0
; CHECK-HARDFP-SP-NEXT:    bl __aeabi_f2lz
; CHECK-HARDFP-SP-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = fptosi float %a to i64
  ret i64 %conv
}

define i64 @f2ulz(float %a) #0 {
; CHECK-SOFT-LABEL: f2ulz:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_f2ulz
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: f2ulz:
; CHECK-SOFTFP:         .save {r11, lr}
; CHECK-SOFTFP-NEXT:    push {r11, lr}
; CHECK-SOFTFP-NEXT:    bl __aeabi_f2ulz
; CHECK-SOFTFP-NEXT:    pop {r11, lr}
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: f2ulz:
; CHECK-HARDFP-SP:         .save {r11, lr}
; CHECK-HARDFP-SP-NEXT:    push {r11, lr}
; CHECK-HARDFP-SP-NEXT:    vmov r0, s0
; CHECK-HARDFP-SP-NEXT:    bl __aeabi_f2ulz
; CHECK-HARDFP-SP-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = fptoui float %a to i64
  ret i64 %conv
}

define float @d2f(double %a) #0 {
; CHECK-SOFT-LABEL: d2f:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_d2f
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: d2f:
; CHECK-SOFTFP:         vmov d16, r0, r1
; CHECK-SOFTFP-NEXT:    vcvt.f32.f64 s0, d16
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: d2f:
; CHECK-HARDFP-DP:         vcvt.f32.f64 s0, d0
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: d2f:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, r1, d0
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_d2f
; CHECK-HARDFP-SPONLY-NEXT:    vmov s0, r0
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %conv = fptrunc double %a to float
  ret float %conv
}

define double @f2d(float %a) #0 {
; CHECK-SOFT-LABEL: f2d:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_f2d
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: f2d:
; CHECK-SOFTFP:         vmov s0, r0
; CHECK-SOFTFP-NEXT:    vcvt.f64.f32 d16, s0
; CHECK-SOFTFP-NEXT:    vmov r0, r1, d16
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: f2d:
; CHECK-HARDFP-DP:         vcvt.f64.f32 d0, s0
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: f2d:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    vmov r0, s0
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_f2d
; CHECK-HARDFP-SPONLY-NEXT:    vmov d0, r0, r1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %conv = fpext float %a to double
  ret double %conv
}

define double @i2d(i32 %a) #0 {
; CHECK-SOFT-LABEL: i2d:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_i2d
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: i2d:
; CHECK-SOFTFP:         vmov s0, r0
; CHECK-SOFTFP-NEXT:    vcvt.f64.s32 d16, s0
; CHECK-SOFTFP-NEXT:    vmov r0, r1, d16
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: i2d:
; CHECK-HARDFP-DP:         vmov s0, r0
; CHECK-HARDFP-DP-NEXT:    vcvt.f64.s32 d0, s0
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: i2d:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_i2d
; CHECK-HARDFP-SPONLY-NEXT:    vmov d0, r0, r1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %conv = sitofp i32 %a to double
  ret double %conv
}

define double @ui2d(i32 %a) #0 {
; CHECK-SOFT-LABEL: ui2d:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_ui2d
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: ui2d:
; CHECK-SOFTFP:         vmov s0, r0
; CHECK-SOFTFP-NEXT:    vcvt.f64.u32 d16, s0
; CHECK-SOFTFP-NEXT:    vmov r0, r1, d16
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-DP-LABEL: ui2d:
; CHECK-HARDFP-DP:         vmov s0, r0
; CHECK-HARDFP-DP-NEXT:    vcvt.f64.u32 d0, s0
; CHECK-HARDFP-DP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SPONLY-LABEL: ui2d:
; CHECK-HARDFP-SPONLY:         .save {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    push {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    bl __aeabi_ui2d
; CHECK-HARDFP-SPONLY-NEXT:    vmov d0, r0, r1
; CHECK-HARDFP-SPONLY-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SPONLY-NEXT:    mov pc, lr
entry:
  %conv = uitofp i32 %a to double
  ret double %conv
}

define double @l2d(i64 %a) #0 {
; CHECK-SOFT-LABEL: l2d:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_l2d
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: l2d:
; CHECK-SOFTFP:         .save {r11, lr}
; CHECK-SOFTFP-NEXT:    push {r11, lr}
; CHECK-SOFTFP-NEXT:    bl __aeabi_l2d
; CHECK-SOFTFP-NEXT:    pop {r11, lr}
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: l2d:
; CHECK-HARDFP-SP:         .save {r11, lr}
; CHECK-HARDFP-SP-NEXT:    push {r11, lr}
; CHECK-HARDFP-SP-NEXT:    bl __aeabi_l2d
; CHECK-HARDFP-SP-NEXT:    vmov d0, r0, r1
; CHECK-HARDFP-SP-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = sitofp i64 %a to double
  ret double %conv
}

define double @ul2d(i64 %a) #0 {
; CHECK-SOFT-LABEL: ul2d:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_ul2d
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: ul2d:
; CHECK-SOFTFP:         .save {r11, lr}
; CHECK-SOFTFP-NEXT:    push {r11, lr}
; CHECK-SOFTFP-NEXT:    bl __aeabi_ul2d
; CHECK-SOFTFP-NEXT:    pop {r11, lr}
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: ul2d:
; CHECK-HARDFP-SP:         .save {r11, lr}
; CHECK-HARDFP-SP-NEXT:    push {r11, lr}
; CHECK-HARDFP-SP-NEXT:    bl __aeabi_ul2d
; CHECK-HARDFP-SP-NEXT:    vmov d0, r0, r1
; CHECK-HARDFP-SP-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = uitofp i64 %a to double
  ret double %conv
}

define float @i2f(i32 %a) #0 {
; CHECK-SOFT-LABEL: i2f:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_i2f
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: i2f:
; CHECK-SOFTFP:         vmov s0, r0
; CHECK-SOFTFP-NEXT:    vcvt.f32.s32 s0, s0
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: i2f:
; CHECK-HARDFP-SP:         vmov s0, r0
; CHECK-HARDFP-SP-NEXT:    vcvt.f32.s32 s0, s0
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = sitofp i32 %a to float
  ret float %conv
}

define float @ui2f(i32 %a) #0 {
; CHECK-SOFT-LABEL: ui2f:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_ui2f
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: ui2f:
; CHECK-SOFTFP:         vmov s0, r0
; CHECK-SOFTFP-NEXT:    vcvt.f32.u32 s0, s0
; CHECK-SOFTFP-NEXT:    vmov r0, s0
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: ui2f:
; CHECK-HARDFP-SP:         vmov s0, r0
; CHECK-HARDFP-SP-NEXT:    vcvt.f32.u32 s0, s0
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = uitofp i32 %a to float
  ret float %conv
}

define float @l2f(i64 %a) #0 {
; CHECK-SOFT-LABEL: l2f:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_l2f
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: l2f:
; CHECK-SOFTFP:         .save {r11, lr}
; CHECK-SOFTFP-NEXT:    push {r11, lr}
; CHECK-SOFTFP-NEXT:    bl __aeabi_l2f
; CHECK-SOFTFP-NEXT:    pop {r11, lr}
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: l2f:
; CHECK-HARDFP-SP:         .save {r11, lr}
; CHECK-HARDFP-SP-NEXT:    push {r11, lr}
; CHECK-HARDFP-SP-NEXT:    bl __aeabi_l2f
; CHECK-HARDFP-SP-NEXT:    vmov s0, r0
; CHECK-HARDFP-SP-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = sitofp i64 %a to float
  ret float %conv
}

define float @ul2f(i64 %a) #0 {
; CHECK-SOFT-LABEL: ul2f:
; CHECK-SOFT:         .save {r11, lr}
; CHECK-SOFT-NEXT:    push {r11, lr}
; CHECK-SOFT-NEXT:    bl __aeabi_ul2f
; CHECK-SOFT-NEXT:    pop {r11, lr}
; CHECK-SOFT-NEXT:    mov pc, lr
;
; CHECK-SOFTFP-LABEL: ul2f:
; CHECK-SOFTFP:         .save {r11, lr}
; CHECK-SOFTFP-NEXT:    push {r11, lr}
; CHECK-SOFTFP-NEXT:    bl __aeabi_ul2f
; CHECK-SOFTFP-NEXT:    pop {r11, lr}
; CHECK-SOFTFP-NEXT:    mov pc, lr
;
; CHECK-HARDFP-SP-LABEL: ul2f:
; CHECK-HARDFP-SP:         .save {r11, lr}
; CHECK-HARDFP-SP-NEXT:    push {r11, lr}
; CHECK-HARDFP-SP-NEXT:    bl __aeabi_ul2f
; CHECK-HARDFP-SP-NEXT:    vmov s0, r0
; CHECK-HARDFP-SP-NEXT:    pop {r11, lr}
; CHECK-HARDFP-SP-NEXT:    mov pc, lr
entry:
  %conv = uitofp i64 %a to float
  ret float %conv
}
attributes #0 = { nounwind }
