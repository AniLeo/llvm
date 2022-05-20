; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mtriple=aarch64-unknown-unknown | FileCheck %s --check-prefixes=CHECK,DEFAULT
; RUN: llc < %s -verify-machineinstrs -mtriple=aarch64-unknown-unknown -mattr=+sve | FileCheck %s --check-prefixes=CHECK,SVE

@result = dso_local global i32 0, align 4

define dso_local i32 @skip(i32 noundef %a, i32 noundef %b, i32 noundef %c) local_unnamed_addr #0 "zero-call-used-regs"="skip" {
; CHECK-LABEL: skip:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mul w8, w1, w0
; CHECK-NEXT:    orr w0, w8, w2
; CHECK-NEXT:    ret

entry:
  %mul = mul nsw i32 %b, %a
  %or = or i32 %mul, %c
  ret i32 %or
}

define dso_local i32 @used_gpr_arg(i32 noundef %a, i32 noundef %b, i32 noundef %c) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="used-gpr-arg" {
; CHECK-LABEL: used_gpr_arg:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mul w8, w1, w0
; CHECK-NEXT:    orr w0, w8, w2
; CHECK-NEXT:    mov x1, #0
; CHECK-NEXT:    mov x2, #0
; CHECK-NEXT:    ret

entry:
  %mul = mul nsw i32 %b, %a
  %or = or i32 %mul, %c
  ret i32 %or
}

define dso_local i32 @used_gpr(i32 noundef %a, i32 noundef %b, i32 noundef %c) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="used-gpr" {
; CHECK-LABEL: used_gpr:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mul w8, w1, w0
; CHECK-NEXT:    orr w0, w8, w2
; CHECK-NEXT:    mov x1, #0
; CHECK-NEXT:    mov x2, #0
; CHECK-NEXT:    mov x8, #0
; CHECK-NEXT:    ret

entry:
  %mul = mul nsw i32 %b, %a
  %or = or i32 %mul, %c
  ret i32 %or
}

define dso_local i32 @used_arg(i32 noundef %a, i32 noundef %b, i32 noundef %c) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="used-arg" {
; CHECK-LABEL: used_arg:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mul w8, w1, w0
; CHECK-NEXT:    orr w0, w8, w2
; CHECK-NEXT:    mov x1, #0
; CHECK-NEXT:    mov x2, #0
; CHECK-NEXT:    ret

entry:
  %mul = mul nsw i32 %b, %a
  %or = or i32 %mul, %c
  ret i32 %or
}

define dso_local i32 @used(i32 noundef %a, i32 noundef %b, i32 noundef %c) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="used" {
; CHECK-LABEL: used:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mul w8, w1, w0
; CHECK-NEXT:    orr w0, w8, w2
; CHECK-NEXT:    mov x1, #0
; CHECK-NEXT:    mov x2, #0
; CHECK-NEXT:    mov x8, #0
; CHECK-NEXT:    ret

entry:
  %mul = mul nsw i32 %b, %a
  %or = or i32 %mul, %c
  ret i32 %or
}

define dso_local i32 @all_gpr_arg(i32 noundef %a, i32 noundef %b, i32 noundef %c) local_unnamed_addr #0 "zero-call-used-regs"="all-gpr-arg" {
; CHECK-LABEL: all_gpr_arg:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mul w8, w1, w0
; CHECK-NEXT:    mov x1, #0
; CHECK-NEXT:    mov x3, #0
; CHECK-NEXT:    mov x4, #0
; CHECK-NEXT:    orr w0, w8, w2
; CHECK-NEXT:    mov x2, #0
; CHECK-NEXT:    mov x5, #0
; CHECK-NEXT:    mov x6, #0
; CHECK-NEXT:    mov x7, #0
; CHECK-NEXT:    mov x8, #0
; CHECK-NEXT:    mov x18, #0
; CHECK-NEXT:    ret

entry:
  %mul = mul nsw i32 %b, %a
  %or = or i32 %mul, %c
  ret i32 %or
}

define dso_local i32 @all_gpr(i32 noundef %a, i32 noundef %b, i32 noundef %c) local_unnamed_addr #0 "zero-call-used-regs"="all-gpr" {
; CHECK-LABEL: all_gpr:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mul w8, w1, w0
; CHECK-NEXT:    mov x1, #0
; CHECK-NEXT:    mov x3, #0
; CHECK-NEXT:    mov x4, #0
; CHECK-NEXT:    orr w0, w8, w2
; CHECK-NEXT:    mov x2, #0
; CHECK-NEXT:    mov x5, #0
; CHECK-NEXT:    mov x6, #0
; CHECK-NEXT:    mov x7, #0
; CHECK-NEXT:    mov x8, #0
; CHECK-NEXT:    mov x9, #0
; CHECK-NEXT:    mov x10, #0
; CHECK-NEXT:    mov x11, #0
; CHECK-NEXT:    mov x12, #0
; CHECK-NEXT:    mov x13, #0
; CHECK-NEXT:    mov x14, #0
; CHECK-NEXT:    mov x15, #0
; CHECK-NEXT:    mov x16, #0
; CHECK-NEXT:    mov x17, #0
; CHECK-NEXT:    mov x18, #0
; CHECK-NEXT:    ret

entry:
  %mul = mul nsw i32 %b, %a
  %or = or i32 %mul, %c
  ret i32 %or
}

define dso_local i32 @all_arg(i32 noundef %a, i32 noundef %b, i32 noundef %c) local_unnamed_addr #0 "zero-call-used-regs"="all-arg" {
; DEFAULT-LABEL: all_arg:
; DEFAULT:       // %bb.0: // %entry
; DEFAULT-NEXT:    mul w8, w1, w0
; DEFAULT-NEXT:    mov x1, #0
; DEFAULT-NEXT:    mov x3, #0
; DEFAULT-NEXT:    mov x4, #0
; DEFAULT-NEXT:    orr w0, w8, w2
; DEFAULT-NEXT:    mov x2, #0
; DEFAULT-NEXT:    mov x5, #0
; DEFAULT-NEXT:    mov x6, #0
; DEFAULT-NEXT:    mov x7, #0
; DEFAULT-NEXT:    mov x8, #0
; DEFAULT-NEXT:    mov x18, #0
; DEFAULT-NEXT:    movi v0.2d, #0000000000000000
; DEFAULT-NEXT:    movi v1.2d, #0000000000000000
; DEFAULT-NEXT:    movi v2.2d, #0000000000000000
; DEFAULT-NEXT:    movi v3.2d, #0000000000000000
; DEFAULT-NEXT:    movi v4.2d, #0000000000000000
; DEFAULT-NEXT:    movi v5.2d, #0000000000000000
; DEFAULT-NEXT:    movi v6.2d, #0000000000000000
; DEFAULT-NEXT:    movi v7.2d, #0000000000000000
; DEFAULT-NEXT:    ret
;
; SVE-LABEL: all_arg:
; SVE:       // %bb.0: // %entry
; SVE-NEXT:    mul w8, w1, w0
; SVE-NEXT:    mov x1, #0
; SVE-NEXT:    mov x3, #0
; SVE-NEXT:    mov x4, #0
; SVE-NEXT:    orr w0, w8, w2
; SVE-NEXT:    mov x2, #0
; SVE-NEXT:    mov x5, #0
; SVE-NEXT:    mov x6, #0
; SVE-NEXT:    mov x7, #0
; SVE-NEXT:    mov x8, #0
; SVE-NEXT:    mov x18, #0
; SVE-NEXT:    mov z0.d, #0 // =0x0
; SVE-NEXT:    mov z1.d, #0 // =0x0
; SVE-NEXT:    mov z2.d, #0 // =0x0
; SVE-NEXT:    mov z3.d, #0 // =0x0
; SVE-NEXT:    mov z4.d, #0 // =0x0
; SVE-NEXT:    mov z5.d, #0 // =0x0
; SVE-NEXT:    mov z6.d, #0 // =0x0
; SVE-NEXT:    mov z7.d, #0 // =0x0
; SVE-NEXT:    pfalse p0.b
; SVE-NEXT:    pfalse p1.b
; SVE-NEXT:    pfalse p2.b
; SVE-NEXT:    pfalse p3.b
; SVE-NEXT:    ret

entry:
  %mul = mul nsw i32 %b, %a
  %or = or i32 %mul, %c
  ret i32 %or
}

define dso_local i32 @all(i32 noundef %a, i32 noundef %b, i32 noundef %c) local_unnamed_addr #0 "zero-call-used-regs"="all" {
; DEFAULT-LABEL: all:
; DEFAULT:       // %bb.0: // %entry
; DEFAULT-NEXT:    mul w8, w1, w0
; DEFAULT-NEXT:    mov x1, #0
; DEFAULT-NEXT:    mov x3, #0
; DEFAULT-NEXT:    mov x4, #0
; DEFAULT-NEXT:    orr w0, w8, w2
; DEFAULT-NEXT:    mov x2, #0
; DEFAULT-NEXT:    mov x5, #0
; DEFAULT-NEXT:    mov x6, #0
; DEFAULT-NEXT:    mov x7, #0
; DEFAULT-NEXT:    mov x8, #0
; DEFAULT-NEXT:    mov x9, #0
; DEFAULT-NEXT:    mov x10, #0
; DEFAULT-NEXT:    mov x11, #0
; DEFAULT-NEXT:    mov x12, #0
; DEFAULT-NEXT:    mov x13, #0
; DEFAULT-NEXT:    mov x14, #0
; DEFAULT-NEXT:    mov x15, #0
; DEFAULT-NEXT:    mov x16, #0
; DEFAULT-NEXT:    mov x17, #0
; DEFAULT-NEXT:    mov x18, #0
; DEFAULT-NEXT:    movi v0.2d, #0000000000000000
; DEFAULT-NEXT:    movi v1.2d, #0000000000000000
; DEFAULT-NEXT:    movi v2.2d, #0000000000000000
; DEFAULT-NEXT:    movi v3.2d, #0000000000000000
; DEFAULT-NEXT:    movi v4.2d, #0000000000000000
; DEFAULT-NEXT:    movi v5.2d, #0000000000000000
; DEFAULT-NEXT:    movi v6.2d, #0000000000000000
; DEFAULT-NEXT:    movi v7.2d, #0000000000000000
; DEFAULT-NEXT:    movi v8.2d, #0000000000000000
; DEFAULT-NEXT:    movi v9.2d, #0000000000000000
; DEFAULT-NEXT:    movi v10.2d, #0000000000000000
; DEFAULT-NEXT:    movi v11.2d, #0000000000000000
; DEFAULT-NEXT:    movi v12.2d, #0000000000000000
; DEFAULT-NEXT:    movi v13.2d, #0000000000000000
; DEFAULT-NEXT:    movi v14.2d, #0000000000000000
; DEFAULT-NEXT:    movi v15.2d, #0000000000000000
; DEFAULT-NEXT:    movi v16.2d, #0000000000000000
; DEFAULT-NEXT:    movi v17.2d, #0000000000000000
; DEFAULT-NEXT:    movi v18.2d, #0000000000000000
; DEFAULT-NEXT:    movi v19.2d, #0000000000000000
; DEFAULT-NEXT:    movi v20.2d, #0000000000000000
; DEFAULT-NEXT:    movi v21.2d, #0000000000000000
; DEFAULT-NEXT:    movi v22.2d, #0000000000000000
; DEFAULT-NEXT:    movi v23.2d, #0000000000000000
; DEFAULT-NEXT:    movi v24.2d, #0000000000000000
; DEFAULT-NEXT:    movi v25.2d, #0000000000000000
; DEFAULT-NEXT:    movi v26.2d, #0000000000000000
; DEFAULT-NEXT:    movi v27.2d, #0000000000000000
; DEFAULT-NEXT:    movi v28.2d, #0000000000000000
; DEFAULT-NEXT:    movi v29.2d, #0000000000000000
; DEFAULT-NEXT:    movi v30.2d, #0000000000000000
; DEFAULT-NEXT:    movi v31.2d, #0000000000000000
; DEFAULT-NEXT:    ret
;
; SVE-LABEL: all:
; SVE:       // %bb.0: // %entry
; SVE-NEXT:    mul w8, w1, w0
; SVE-NEXT:    mov x1, #0
; SVE-NEXT:    mov x3, #0
; SVE-NEXT:    mov x4, #0
; SVE-NEXT:    orr w0, w8, w2
; SVE-NEXT:    mov x2, #0
; SVE-NEXT:    mov x5, #0
; SVE-NEXT:    mov x6, #0
; SVE-NEXT:    mov x7, #0
; SVE-NEXT:    mov x8, #0
; SVE-NEXT:    mov x9, #0
; SVE-NEXT:    mov x10, #0
; SVE-NEXT:    mov x11, #0
; SVE-NEXT:    mov x12, #0
; SVE-NEXT:    mov x13, #0
; SVE-NEXT:    mov x14, #0
; SVE-NEXT:    mov x15, #0
; SVE-NEXT:    mov x16, #0
; SVE-NEXT:    mov x17, #0
; SVE-NEXT:    mov x18, #0
; SVE-NEXT:    mov z0.d, #0 // =0x0
; SVE-NEXT:    mov z1.d, #0 // =0x0
; SVE-NEXT:    mov z2.d, #0 // =0x0
; SVE-NEXT:    mov z3.d, #0 // =0x0
; SVE-NEXT:    mov z4.d, #0 // =0x0
; SVE-NEXT:    mov z5.d, #0 // =0x0
; SVE-NEXT:    mov z6.d, #0 // =0x0
; SVE-NEXT:    mov z7.d, #0 // =0x0
; SVE-NEXT:    mov z8.d, #0 // =0x0
; SVE-NEXT:    mov z9.d, #0 // =0x0
; SVE-NEXT:    mov z10.d, #0 // =0x0
; SVE-NEXT:    mov z11.d, #0 // =0x0
; SVE-NEXT:    mov z12.d, #0 // =0x0
; SVE-NEXT:    mov z13.d, #0 // =0x0
; SVE-NEXT:    mov z14.d, #0 // =0x0
; SVE-NEXT:    mov z15.d, #0 // =0x0
; SVE-NEXT:    mov z16.d, #0 // =0x0
; SVE-NEXT:    mov z17.d, #0 // =0x0
; SVE-NEXT:    mov z18.d, #0 // =0x0
; SVE-NEXT:    mov z19.d, #0 // =0x0
; SVE-NEXT:    mov z20.d, #0 // =0x0
; SVE-NEXT:    mov z21.d, #0 // =0x0
; SVE-NEXT:    mov z22.d, #0 // =0x0
; SVE-NEXT:    mov z23.d, #0 // =0x0
; SVE-NEXT:    mov z24.d, #0 // =0x0
; SVE-NEXT:    mov z25.d, #0 // =0x0
; SVE-NEXT:    mov z26.d, #0 // =0x0
; SVE-NEXT:    mov z27.d, #0 // =0x0
; SVE-NEXT:    mov z28.d, #0 // =0x0
; SVE-NEXT:    mov z29.d, #0 // =0x0
; SVE-NEXT:    mov z30.d, #0 // =0x0
; SVE-NEXT:    mov z31.d, #0 // =0x0
; SVE-NEXT:    pfalse p0.b
; SVE-NEXT:    pfalse p1.b
; SVE-NEXT:    pfalse p2.b
; SVE-NEXT:    pfalse p3.b
; SVE-NEXT:    pfalse p4.b
; SVE-NEXT:    pfalse p5.b
; SVE-NEXT:    pfalse p6.b
; SVE-NEXT:    pfalse p7.b
; SVE-NEXT:    pfalse p8.b
; SVE-NEXT:    pfalse p9.b
; SVE-NEXT:    pfalse p10.b
; SVE-NEXT:    pfalse p11.b
; SVE-NEXT:    pfalse p12.b
; SVE-NEXT:    pfalse p13.b
; SVE-NEXT:    pfalse p14.b
; SVE-NEXT:    pfalse p15.b
; SVE-NEXT:    ret

entry:
  %mul = mul nsw i32 %b, %a
  %or = or i32 %mul, %c
  ret i32 %or
}

define dso_local double @skip_float(double noundef %a, float noundef %b) local_unnamed_addr #0 "zero-call-used-regs"="skip" {
; CHECK-LABEL: skip_float:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvt d1, s1
; CHECK-NEXT:    fmul d0, d1, d0
; CHECK-NEXT:    ret

entry:
  %conv = fpext float %b to double
  %mul = fmul double %conv, %a
  ret double %mul
}

define dso_local double @used_gpr_arg_float(double noundef %a, float noundef %b) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="used-gpr-arg" {
; CHECK-LABEL: used_gpr_arg_float:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvt d1, s1
; CHECK-NEXT:    fmul d0, d1, d0
; CHECK-NEXT:    ret

entry:
  %conv = fpext float %b to double
  %mul = fmul double %conv, %a
  ret double %mul
}

define dso_local double @used_gpr_float(double noundef %a, float noundef %b) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="used-gpr" {
; CHECK-LABEL: used_gpr_float:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvt d1, s1
; CHECK-NEXT:    fmul d0, d1, d0
; CHECK-NEXT:    ret

entry:
  %conv = fpext float %b to double
  %mul = fmul double %conv, %a
  ret double %mul
}

define dso_local double @used_arg_float(double noundef %a, float noundef %b) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="used-arg" {
; DEFAULT-LABEL: used_arg_float:
; DEFAULT:       // %bb.0: // %entry
; DEFAULT-NEXT:    fcvt d1, s1
; DEFAULT-NEXT:    fmul d0, d1, d0
; DEFAULT-NEXT:    movi v1.2d, #0000000000000000
; DEFAULT-NEXT:    ret
;
; SVE-LABEL: used_arg_float:
; SVE:       // %bb.0: // %entry
; SVE-NEXT:    fcvt d1, s1
; SVE-NEXT:    fmul d0, d1, d0
; SVE-NEXT:    mov z1.d, #0 // =0x0
; SVE-NEXT:    ret

entry:
  %conv = fpext float %b to double
  %mul = fmul double %conv, %a
  ret double %mul
}

define dso_local double @used_float(double noundef %a, float noundef %b) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="used" {
; DEFAULT-LABEL: used_float:
; DEFAULT:       // %bb.0: // %entry
; DEFAULT-NEXT:    fcvt d1, s1
; DEFAULT-NEXT:    fmul d0, d1, d0
; DEFAULT-NEXT:    movi v1.2d, #0000000000000000
; DEFAULT-NEXT:    ret
;
; SVE-LABEL: used_float:
; SVE:       // %bb.0: // %entry
; SVE-NEXT:    fcvt d1, s1
; SVE-NEXT:    fmul d0, d1, d0
; SVE-NEXT:    mov z1.d, #0 // =0x0
; SVE-NEXT:    ret

entry:
  %conv = fpext float %b to double
  %mul = fmul double %conv, %a
  ret double %mul
}

define dso_local double @all_gpr_arg_float(double noundef %a, float noundef %b) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="all-gpr-arg" {
; CHECK-LABEL: all_gpr_arg_float:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvt d1, s1
; CHECK-NEXT:    fmul d0, d1, d0
; CHECK-NEXT:    mov x0, #0
; CHECK-NEXT:    mov x1, #0
; CHECK-NEXT:    mov x2, #0
; CHECK-NEXT:    mov x3, #0
; CHECK-NEXT:    mov x4, #0
; CHECK-NEXT:    mov x5, #0
; CHECK-NEXT:    mov x6, #0
; CHECK-NEXT:    mov x7, #0
; CHECK-NEXT:    mov x8, #0
; CHECK-NEXT:    mov x18, #0
; CHECK-NEXT:    ret

entry:
  %conv = fpext float %b to double
  %mul = fmul double %conv, %a
  ret double %mul
}

define dso_local double @all_gpr_float(double noundef %a, float noundef %b) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="all-gpr" {
; CHECK-LABEL: all_gpr_float:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    fcvt d1, s1
; CHECK-NEXT:    fmul d0, d1, d0
; CHECK-NEXT:    mov x0, #0
; CHECK-NEXT:    mov x1, #0
; CHECK-NEXT:    mov x2, #0
; CHECK-NEXT:    mov x3, #0
; CHECK-NEXT:    mov x4, #0
; CHECK-NEXT:    mov x5, #0
; CHECK-NEXT:    mov x6, #0
; CHECK-NEXT:    mov x7, #0
; CHECK-NEXT:    mov x8, #0
; CHECK-NEXT:    mov x9, #0
; CHECK-NEXT:    mov x10, #0
; CHECK-NEXT:    mov x11, #0
; CHECK-NEXT:    mov x12, #0
; CHECK-NEXT:    mov x13, #0
; CHECK-NEXT:    mov x14, #0
; CHECK-NEXT:    mov x15, #0
; CHECK-NEXT:    mov x16, #0
; CHECK-NEXT:    mov x17, #0
; CHECK-NEXT:    mov x18, #0
; CHECK-NEXT:    ret

entry:
  %conv = fpext float %b to double
  %mul = fmul double %conv, %a
  ret double %mul
}

define dso_local double @all_arg_float(double noundef %a, float noundef %b) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="all-arg" {
; DEFAULT-LABEL: all_arg_float:
; DEFAULT:       // %bb.0: // %entry
; DEFAULT-NEXT:    fcvt d1, s1
; DEFAULT-NEXT:    fmul d0, d1, d0
; DEFAULT-NEXT:    mov x0, #0
; DEFAULT-NEXT:    mov x1, #0
; DEFAULT-NEXT:    mov x2, #0
; DEFAULT-NEXT:    mov x3, #0
; DEFAULT-NEXT:    mov x4, #0
; DEFAULT-NEXT:    mov x5, #0
; DEFAULT-NEXT:    mov x6, #0
; DEFAULT-NEXT:    mov x7, #0
; DEFAULT-NEXT:    mov x8, #0
; DEFAULT-NEXT:    mov x18, #0
; DEFAULT-NEXT:    movi v1.2d, #0000000000000000
; DEFAULT-NEXT:    movi v2.2d, #0000000000000000
; DEFAULT-NEXT:    movi v3.2d, #0000000000000000
; DEFAULT-NEXT:    movi v4.2d, #0000000000000000
; DEFAULT-NEXT:    movi v5.2d, #0000000000000000
; DEFAULT-NEXT:    movi v6.2d, #0000000000000000
; DEFAULT-NEXT:    movi v7.2d, #0000000000000000
; DEFAULT-NEXT:    ret
;
; SVE-LABEL: all_arg_float:
; SVE:       // %bb.0: // %entry
; SVE-NEXT:    fcvt d1, s1
; SVE-NEXT:    fmul d0, d1, d0
; SVE-NEXT:    mov x0, #0
; SVE-NEXT:    mov x1, #0
; SVE-NEXT:    mov x2, #0
; SVE-NEXT:    mov x3, #0
; SVE-NEXT:    mov x4, #0
; SVE-NEXT:    mov x5, #0
; SVE-NEXT:    mov x6, #0
; SVE-NEXT:    mov x7, #0
; SVE-NEXT:    mov x8, #0
; SVE-NEXT:    mov x18, #0
; SVE-NEXT:    mov z1.d, #0 // =0x0
; SVE-NEXT:    mov z2.d, #0 // =0x0
; SVE-NEXT:    mov z3.d, #0 // =0x0
; SVE-NEXT:    mov z4.d, #0 // =0x0
; SVE-NEXT:    mov z5.d, #0 // =0x0
; SVE-NEXT:    mov z6.d, #0 // =0x0
; SVE-NEXT:    mov z7.d, #0 // =0x0
; SVE-NEXT:    pfalse p0.b
; SVE-NEXT:    pfalse p1.b
; SVE-NEXT:    pfalse p2.b
; SVE-NEXT:    pfalse p3.b
; SVE-NEXT:    ret

entry:
  %conv = fpext float %b to double
  %mul = fmul double %conv, %a
  ret double %mul
}

define dso_local double @all_float(double noundef %a, float noundef %b) local_unnamed_addr #0 noinline optnone "zero-call-used-regs"="all" {
; DEFAULT-LABEL: all_float:
; DEFAULT:       // %bb.0: // %entry
; DEFAULT-NEXT:    fcvt d1, s1
; DEFAULT-NEXT:    fmul d0, d1, d0
; DEFAULT-NEXT:    mov x0, #0
; DEFAULT-NEXT:    mov x1, #0
; DEFAULT-NEXT:    mov x2, #0
; DEFAULT-NEXT:    mov x3, #0
; DEFAULT-NEXT:    mov x4, #0
; DEFAULT-NEXT:    mov x5, #0
; DEFAULT-NEXT:    mov x6, #0
; DEFAULT-NEXT:    mov x7, #0
; DEFAULT-NEXT:    mov x8, #0
; DEFAULT-NEXT:    mov x9, #0
; DEFAULT-NEXT:    mov x10, #0
; DEFAULT-NEXT:    mov x11, #0
; DEFAULT-NEXT:    mov x12, #0
; DEFAULT-NEXT:    mov x13, #0
; DEFAULT-NEXT:    mov x14, #0
; DEFAULT-NEXT:    mov x15, #0
; DEFAULT-NEXT:    mov x16, #0
; DEFAULT-NEXT:    mov x17, #0
; DEFAULT-NEXT:    mov x18, #0
; DEFAULT-NEXT:    movi v1.2d, #0000000000000000
; DEFAULT-NEXT:    movi v2.2d, #0000000000000000
; DEFAULT-NEXT:    movi v3.2d, #0000000000000000
; DEFAULT-NEXT:    movi v4.2d, #0000000000000000
; DEFAULT-NEXT:    movi v5.2d, #0000000000000000
; DEFAULT-NEXT:    movi v6.2d, #0000000000000000
; DEFAULT-NEXT:    movi v7.2d, #0000000000000000
; DEFAULT-NEXT:    movi v8.2d, #0000000000000000
; DEFAULT-NEXT:    movi v9.2d, #0000000000000000
; DEFAULT-NEXT:    movi v10.2d, #0000000000000000
; DEFAULT-NEXT:    movi v11.2d, #0000000000000000
; DEFAULT-NEXT:    movi v12.2d, #0000000000000000
; DEFAULT-NEXT:    movi v13.2d, #0000000000000000
; DEFAULT-NEXT:    movi v14.2d, #0000000000000000
; DEFAULT-NEXT:    movi v15.2d, #0000000000000000
; DEFAULT-NEXT:    movi v16.2d, #0000000000000000
; DEFAULT-NEXT:    movi v17.2d, #0000000000000000
; DEFAULT-NEXT:    movi v18.2d, #0000000000000000
; DEFAULT-NEXT:    movi v19.2d, #0000000000000000
; DEFAULT-NEXT:    movi v20.2d, #0000000000000000
; DEFAULT-NEXT:    movi v21.2d, #0000000000000000
; DEFAULT-NEXT:    movi v22.2d, #0000000000000000
; DEFAULT-NEXT:    movi v23.2d, #0000000000000000
; DEFAULT-NEXT:    movi v24.2d, #0000000000000000
; DEFAULT-NEXT:    movi v25.2d, #0000000000000000
; DEFAULT-NEXT:    movi v26.2d, #0000000000000000
; DEFAULT-NEXT:    movi v27.2d, #0000000000000000
; DEFAULT-NEXT:    movi v28.2d, #0000000000000000
; DEFAULT-NEXT:    movi v29.2d, #0000000000000000
; DEFAULT-NEXT:    movi v30.2d, #0000000000000000
; DEFAULT-NEXT:    movi v31.2d, #0000000000000000
; DEFAULT-NEXT:    ret
;
; SVE-LABEL: all_float:
; SVE:       // %bb.0: // %entry
; SVE-NEXT:    fcvt d1, s1
; SVE-NEXT:    fmul d0, d1, d0
; SVE-NEXT:    mov x0, #0
; SVE-NEXT:    mov x1, #0
; SVE-NEXT:    mov x2, #0
; SVE-NEXT:    mov x3, #0
; SVE-NEXT:    mov x4, #0
; SVE-NEXT:    mov x5, #0
; SVE-NEXT:    mov x6, #0
; SVE-NEXT:    mov x7, #0
; SVE-NEXT:    mov x8, #0
; SVE-NEXT:    mov x9, #0
; SVE-NEXT:    mov x10, #0
; SVE-NEXT:    mov x11, #0
; SVE-NEXT:    mov x12, #0
; SVE-NEXT:    mov x13, #0
; SVE-NEXT:    mov x14, #0
; SVE-NEXT:    mov x15, #0
; SVE-NEXT:    mov x16, #0
; SVE-NEXT:    mov x17, #0
; SVE-NEXT:    mov x18, #0
; SVE-NEXT:    mov z1.d, #0 // =0x0
; SVE-NEXT:    mov z2.d, #0 // =0x0
; SVE-NEXT:    mov z3.d, #0 // =0x0
; SVE-NEXT:    mov z4.d, #0 // =0x0
; SVE-NEXT:    mov z5.d, #0 // =0x0
; SVE-NEXT:    mov z6.d, #0 // =0x0
; SVE-NEXT:    mov z7.d, #0 // =0x0
; SVE-NEXT:    mov z8.d, #0 // =0x0
; SVE-NEXT:    mov z9.d, #0 // =0x0
; SVE-NEXT:    mov z10.d, #0 // =0x0
; SVE-NEXT:    mov z11.d, #0 // =0x0
; SVE-NEXT:    mov z12.d, #0 // =0x0
; SVE-NEXT:    mov z13.d, #0 // =0x0
; SVE-NEXT:    mov z14.d, #0 // =0x0
; SVE-NEXT:    mov z15.d, #0 // =0x0
; SVE-NEXT:    mov z16.d, #0 // =0x0
; SVE-NEXT:    mov z17.d, #0 // =0x0
; SVE-NEXT:    mov z18.d, #0 // =0x0
; SVE-NEXT:    mov z19.d, #0 // =0x0
; SVE-NEXT:    mov z20.d, #0 // =0x0
; SVE-NEXT:    mov z21.d, #0 // =0x0
; SVE-NEXT:    mov z22.d, #0 // =0x0
; SVE-NEXT:    mov z23.d, #0 // =0x0
; SVE-NEXT:    mov z24.d, #0 // =0x0
; SVE-NEXT:    mov z25.d, #0 // =0x0
; SVE-NEXT:    mov z26.d, #0 // =0x0
; SVE-NEXT:    mov z27.d, #0 // =0x0
; SVE-NEXT:    mov z28.d, #0 // =0x0
; SVE-NEXT:    mov z29.d, #0 // =0x0
; SVE-NEXT:    mov z30.d, #0 // =0x0
; SVE-NEXT:    mov z31.d, #0 // =0x0
; SVE-NEXT:    pfalse p0.b
; SVE-NEXT:    pfalse p1.b
; SVE-NEXT:    pfalse p2.b
; SVE-NEXT:    pfalse p3.b
; SVE-NEXT:    pfalse p4.b
; SVE-NEXT:    pfalse p5.b
; SVE-NEXT:    pfalse p6.b
; SVE-NEXT:    pfalse p7.b
; SVE-NEXT:    pfalse p8.b
; SVE-NEXT:    pfalse p9.b
; SVE-NEXT:    pfalse p10.b
; SVE-NEXT:    pfalse p11.b
; SVE-NEXT:    pfalse p12.b
; SVE-NEXT:    pfalse p13.b
; SVE-NEXT:    pfalse p14.b
; SVE-NEXT:    pfalse p15.b
; SVE-NEXT:    ret

entry:
  %conv = fpext float %b to double
  %mul = fmul double %conv, %a
  ret double %mul
}

; Don't emit zeroing registers in "main" function.
define dso_local i32 @main() local_unnamed_addr #0 {
; CHECK-LABEL: main:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    ret

entry:
  ret i32 0
}

attributes #0 = { mustprogress nofree norecurse nosync nounwind readnone willreturn uwtable "frame-pointer"="non-leaf" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="generic" "target-features"="+neon,+v8a" }
