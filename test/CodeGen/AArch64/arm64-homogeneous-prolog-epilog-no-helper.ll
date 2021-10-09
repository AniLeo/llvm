; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-apple-ios7.0  -homogeneous-prolog-epilog -frame-helper-size-threshold=6 | FileCheck %s
; RUN: llc < %s -mtriple=aarch64-unknown-linux-gnu  -homogeneous-prolog-epilog -frame-helper-size-threshold=6 | FileCheck %s --check-prefixes=CHECK-LINUX

define float @_Z3foofffi(float %b, float %x, float %y, i32 %z) uwtable ssp minsize "frame-pointer"="non-leaf" {
; CHECK-LABEL: _Z3foofffi:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    stp d11, d10, [sp, #-64]!
; CHECK-NEXT:    stp d9, d8, [sp, #16]
; CHECK-NEXT:    stp x20, x19, [sp, #32]
; CHECK-NEXT:    stp x29, x30, [sp, #48]
; CHECK-NEXT:    add x29, sp, #48
; CHECK-NEXT:    .cfi_def_cfa w29, 16
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    .cfi_offset w19, -24
; CHECK-NEXT:    .cfi_offset w20, -32
; CHECK-NEXT:    .cfi_offset b8, -40
; CHECK-NEXT:    .cfi_offset b9, -48
; CHECK-NEXT:    .cfi_offset b10, -56
; CHECK-NEXT:    .cfi_offset b11, -64
; CHECK-NEXT:    fmov s3, #1.00000000
; CHECK-NEXT:    scvtf s4, w0
; CHECK-NEXT:    sub w19, w0, #1
; CHECK-NEXT:    fadd s8, s0, s3
; CHECK-NEXT:    fadd s0, s8, s1
; CHECK-NEXT:    fadd s0, s0, s2
; CHECK-NEXT:    fsub s9, s0, s4
; CHECK-NEXT:    fmov s0, s8
; CHECK-NEXT:    bl __Z3goof
; CHECK-NEXT:    fmov s10, s0
; CHECK-NEXT:    fmov s0, s9
; CHECK-NEXT:    bl __Z3goof
; CHECK-NEXT:    fadd s0, s10, s0
; CHECK-NEXT:    scvtf s1, w19
; CHECK-NEXT:    ldp x29, x30, [sp, #48]
; CHECK-NEXT:    ldp x20, x19, [sp, #32]
; CHECK-NEXT:    fmul s0, s8, s0
; CHECK-NEXT:    fadd s0, s9, s0
; CHECK-NEXT:    ldp d9, d8, [sp, #16]
; CHECK-NEXT:    fsub s0, s0, s1
; CHECK-NEXT:    ldp d11, d10, [sp], #64
; CHECK-NEXT:    ret
;
; CHECK-LINUX-LABEL: _Z3foofffi:
; CHECK-LINUX:       // %bb.0: // %entry
; CHECK-LINUX-NEXT:    stp d11, d10, [sp, #-64]!
; CHECK-LINUX-NEXT:    stp d9, d8, [sp, #16]
; CHECK-LINUX-NEXT:    stp x29, x30, [sp, #32]
; CHECK-LINUX-NEXT:    add x29, sp, #32
; CHECK-LINUX-NEXT:    stp x20, x19, [sp, #48]
; CHECK-LINUX-NEXT:    .cfi_def_cfa w29, 32
; CHECK-LINUX-NEXT:    .cfi_offset w19, -8
; CHECK-LINUX-NEXT:    .cfi_offset w20, -16
; CHECK-LINUX-NEXT:    .cfi_offset w30, -24
; CHECK-LINUX-NEXT:    .cfi_offset w29, -32
; CHECK-LINUX-NEXT:    .cfi_offset b8, -40
; CHECK-LINUX-NEXT:    .cfi_offset b9, -48
; CHECK-LINUX-NEXT:    .cfi_offset b10, -56
; CHECK-LINUX-NEXT:    .cfi_offset b11, -64
; CHECK-LINUX-NEXT:    fmov s3, #1.00000000
; CHECK-LINUX-NEXT:    scvtf s4, w0
; CHECK-LINUX-NEXT:    sub w19, w0, #1
; CHECK-LINUX-NEXT:    fadd s8, s0, s3
; CHECK-LINUX-NEXT:    fadd s0, s8, s1
; CHECK-LINUX-NEXT:    fadd s0, s0, s2
; CHECK-LINUX-NEXT:    fsub s9, s0, s4
; CHECK-LINUX-NEXT:    fmov s0, s8
; CHECK-LINUX-NEXT:    bl _Z3goof
; CHECK-LINUX-NEXT:    fmov s10, s0
; CHECK-LINUX-NEXT:    fmov s0, s9
; CHECK-LINUX-NEXT:    bl _Z3goof
; CHECK-LINUX-NEXT:    fadd s0, s10, s0
; CHECK-LINUX-NEXT:    scvtf s1, w19
; CHECK-LINUX-NEXT:    ldp x20, x19, [sp, #48]
; CHECK-LINUX-NEXT:    ldp x29, x30, [sp, #32]
; CHECK-LINUX-NEXT:    fmul s0, s8, s0
; CHECK-LINUX-NEXT:    fadd s0, s9, s0
; CHECK-LINUX-NEXT:    ldp d9, d8, [sp, #16]
; CHECK-LINUX-NEXT:    fsub s0, s0, s1
; CHECK-LINUX-NEXT:    ldp d11, d10, [sp], #64
; CHECK-LINUX-NEXT:    ret
entry:
  %inc = fadd float %b, 1.000000e+00
  %add = fadd float %inc, %x
  %add1 = fadd float %add, %y
  %conv = sitofp i32 %z to float
  %sub = fsub float %add1, %conv
  %dec = add nsw i32 %z, -1
  %call = tail call float @_Z3goof(float %inc) #2
  %call2 = tail call float @_Z3goof(float %sub) #2
  %add3 = fadd float %call, %call2
  %mul = fmul float %inc, %add3
  %add4 = fadd float %sub, %mul
  %conv5 = sitofp i32 %dec to float
  %sub6 = fsub float %add4, %conv5
  ret float %sub6
}

define i32 @_Z3zoov() nounwind ssp minsize {
; CHECK-LABEL: _Z3zoov:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]!
; CHECK-NEXT:    bl __Z3hoov
; CHECK-NEXT:    add w0, w0, #1
; CHECK-NEXT:    ldp x29, x30, [sp], #16
; CHECK-NEXT:    ret
;
; CHECK-LINUX-LABEL: _Z3zoov:
; CHECK-LINUX:       // %bb.0:
; CHECK-LINUX-NEXT:    stp x29, x30, [sp, #-16]!
; CHECK-LINUX-NEXT:    bl _Z3hoov
; CHECK-LINUX-NEXT:    add w0, w0, #1
; CHECK-LINUX-NEXT:    ldp x29, x30, [sp], #16
; CHECK-LINUX-NEXT:    ret
  %1 = tail call i32 @_Z3hoov() #2
  %2 = add nsw i32 %1, 1
  ret i32 %2
}


declare float @_Z3goof(float) nounwind ssp minsize
declare i32 @_Z3hoov() nounwind ssp minsize
