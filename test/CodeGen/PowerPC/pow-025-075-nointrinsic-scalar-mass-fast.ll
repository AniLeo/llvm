; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -O3 -mtriple=powerpc64le-unknown-linux-gnu < %s | FileCheck --check-prefix=CHECK-LNX %s
; RUN: llc -verify-machineinstrs -O3 -mtriple=powerpc-ibm-aix-xcoff < %s | FileCheck --check-prefix=CHECK-AIX %s

declare float @powf (float, float);
declare double @pow (double, double);
declare float @__powf_finite (float, float);
declare double @__pow_finite (double, double);

; fast-math powf with 0.25
define float @powf_f32_fast025(float %a) #1 {
;
; CHECK-LNX-LABEL: powf_f32_fast025:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI0_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI0_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_powf_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: powf_f32_fast025:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C0(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_powf_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz float @powf(float %a, float 2.500000e-01)
  ret float %call
}

; fast-math pow with 0.25
define double @pow_f64_fast025(double %a) #1 {
;
; CHECK-LNX-LABEL: pow_f64_fast025:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI1_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI1_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_pow_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: pow_f64_fast025:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C1(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_pow_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz double @pow(double %a, double 2.500000e-01)
  ret double %call
}

; fast-math powf with 0.75
define float @powf_f32_fast075(float %a) #1 {
;
; CHECK-LNX-LABEL: powf_f32_fast075:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI2_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI2_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_powf_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: powf_f32_fast075:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C2(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_powf_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz float @powf(float %a, float 7.500000e-01)
  ret float %call
}

; fast-math pow with 0.75
define double @pow_f64_fast075(double %a) #1 {
;
; CHECK-LNX-LABEL: pow_f64_fast075:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI3_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI3_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_pow_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: pow_f64_fast075:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C3(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_pow_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz double @pow(double %a, double 7.500000e-01)
  ret double %call
}

; fast-math powf with 0.50
define float @powf_f32_fast050(float %a) #1 {
;
; CHECK-LNX-LABEL: powf_f32_fast050:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI4_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI4_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_powf_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: powf_f32_fast050:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C4(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_powf_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz float @powf(float %a, float 5.000000e-01)
  ret float %call
}

; fast-math pow with 0.50
define double @pow_f64_fast050(double %a) #1 {
;
; CHECK-LNX-LABEL: pow_f64_fast050:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI5_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI5_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_pow_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: pow_f64_fast050:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C5(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_pow_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz double @pow(double %a, double 5.000000e-01)
  ret double %call
}

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; fast-math __powf_finite with 0.25
define float @__powf_finite_f32_fast025(float %a) #1 {
;
; CHECK-LNX-LABEL: __powf_finite_f32_fast025:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI6_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI6_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_powf_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: __powf_finite_f32_fast025:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C6(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_powf_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz float @__powf_finite(float %a, float 2.500000e-01)
  ret float %call
}

; fast-math __pow_finite with 0.25
define double @__pow_finite_f64_fast025(double %a) #1 {
;
; CHECK-LNX-LABEL: __pow_finite_f64_fast025:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI7_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI7_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_pow_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: __pow_finite_f64_fast025:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C7(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_pow_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz double @__pow_finite(double %a, double 2.500000e-01)
  ret double %call
}

; fast-math __powf_finite with 0.75
define float @__powf_finite_f32_fast075(float %a) #1 {
;
; CHECK-LNX-LABEL: __powf_finite_f32_fast075:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI8_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI8_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_powf_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: __powf_finite_f32_fast075:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C8(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_powf_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz float @__powf_finite(float %a, float 7.500000e-01)
  ret float %call
}

; fast-math __pow_finite with 0.75
define double @__pow_finite_f64_fast075(double %a) #1 {
;
; CHECK-LNX-LABEL: __pow_finite_f64_fast075:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI9_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI9_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_pow_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: __pow_finite_f64_fast075:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C9(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_pow_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz double @__pow_finite(double %a, double 7.500000e-01)
  ret double %call
}

; fast-math __powf_finite with 0.50
define float @__powf_finite_f32_fast050(float %a) #1 {
;
; CHECK-LNX-LABEL: __powf_finite_f32_fast050:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI10_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI10_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_powf_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: __powf_finite_f32_fast050:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C10(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_powf_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz float @__powf_finite(float %a, float 5.000000e-01)
  ret float %call
}

; fast-math __pow_finite with 0.50
define double @__pow_finite_f64_fast050(double %a) #1 {
;
; CHECK-LNX-LABEL: __pow_finite_f64_fast050:
; CHECK-LNX:       # %bb.0: # %entry
; CHECK-LNX-NEXT:    mflr 0
; CHECK-LNX-NEXT:    std 0, 16(1)
; CHECK-LNX-NEXT:    stdu 1, -32(1)
; CHECK-LNX-NEXT:    .cfi_def_cfa_offset 32
; CHECK-LNX-NEXT:    .cfi_offset lr, 16
; CHECK-LNX-NEXT:    addis 3, 2, .LCPI11_0@toc@ha
; CHECK-LNX-NEXT:    lfs 2, .LCPI11_0@toc@l(3)
; CHECK-LNX-NEXT:    bl __xl_pow_finite
; CHECK-LNX-NEXT:    nop
; CHECK-LNX-NEXT:    addi 1, 1, 32
; CHECK-LNX-NEXT:    ld 0, 16(1)
; CHECK-LNX-NEXT:    mtlr 0
; CHECK-LNX-NEXT:    blr
;
; CHECK-AIX-LABEL: __pow_finite_f64_fast050:
; CHECK-AIX:       # %bb.0: # %entry
; CHECK-AIX-NEXT:    mflr 0
; CHECK-AIX-NEXT:    stw 0, 8(1)
; CHECK-AIX-NEXT:    stwu 1, -64(1)
; CHECK-AIX-NEXT:    lwz 3, L..C11(2) # %const.0
; CHECK-AIX-NEXT:    lfs 2, 0(3)
; CHECK-AIX-NEXT:    bl .__xl_pow_finite[PR]
; CHECK-AIX-NEXT:    nop
; CHECK-AIX-NEXT:    addi 1, 1, 64
; CHECK-AIX-NEXT:    lwz 0, 8(1)
; CHECK-AIX-NEXT:    mtlr 0
; CHECK-AIX-NEXT:    blr
entry:
  %call = tail call nnan ninf afn nsz double @__pow_finite(double %a, double 5.000000e-01)
  ret double %call
}

attributes #1 = { "approx-func-fp-math"="true" "no-infs-fp-math"="true" "no-nans-fp-math"="true" "no-signed-zeros-fp-math"="true" }
