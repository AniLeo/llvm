; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; Currently there is no custom lowering for vector shuffles operating on types
; bigger than NEON. However, having no support opens us up to a code generator
; hang when expanding BUILD_VECTOR. Here we just validate the promblematic case
; successfully exits code generation.
define void @hang_when_merging_stores_after_legalisation(<8 x i32>* %a, <2 x i32> %b) #0 {
; CHECK-LABEL: hang_when_merging_stores_after_legalisation:
; CHECK:       // %bb.0:
; CHECK-NEXT:    stp x29, x30, [sp, #-16]! // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    mov x29, sp
; CHECK-NEXT:    .cfi_def_cfa w29, 16
; CHECK-NEXT:    .cfi_offset w30, -8
; CHECK-NEXT:    .cfi_offset w29, -16
; CHECK-NEXT:    sub x9, sp, #48
; CHECK-NEXT:    and sp, x9, #0xffffffffffffffe0
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    stp s0, s0, [sp, #24]
; CHECK-NEXT:    stp s0, s0, [sp, #16]
; CHECK-NEXT:    stp s0, s0, [sp, #8]
; CHECK-NEXT:    stp s0, s0, [sp]
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [sp]
; CHECK-NEXT:    mov z1.d, z0.d
; CHECK-NEXT:    ext z1.b, z1.b, z1.b, #16
; CHECK-NEXT:    st2 { v0.4s, v1.4s }, [x0]
; CHECK-NEXT:    mov sp, x29
; CHECK-NEXT:    ldp x29, x30, [sp], #16 // 16-byte Folded Reload
; CHECK-NEXT:    ret
  %splat = shufflevector <2 x i32> %b, <2 x i32> undef, <8 x i32> zeroinitializer
  %interleaved.vec = shufflevector <8 x i32> %splat, <8 x i32> undef, <8 x i32> <i32 0, i32 4, i32 1, i32 5, i32 2, i32 6, i32 3, i32 7>
  store <8 x i32> %interleaved.vec, <8 x i32>* %a, align 4
  ret void
}

; Ensure we don't crash when trying to lower a shuffle via and extract
define void @crash_when_lowering_extract_shuffle(<32 x i32>* %dst, i1 %cond) #0 {
; CHECK-LABEL: crash_when_lowering_extract_shuffle:
; CHECK:       // %bb.0:
; CHECK-NEXT:    tbnz w1, #0, .LBB1_2
; CHECK-NEXT:  // %bb.1: // %vector.body
; CHECK-NEXT:    mov z0.b, #0 // =0x0
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    umov w8, v0.b[8]
; CHECK-NEXT:    umov w9, v0.b[1]
; CHECK-NEXT:    umov w10, v0.b[9]
; CHECK-NEXT:    umov w11, v0.b[2]
; CHECK-NEXT:    mov v1.16b, v0.16b
; CHECK-NEXT:    fmov s2, w8
; CHECK-NEXT:    umov w8, v0.b[10]
; CHECK-NEXT:    mov v1.b[1], w9
; CHECK-NEXT:    umov w9, v0.b[3]
; CHECK-NEXT:    mov v2.b[1], w10
; CHECK-NEXT:    umov w10, v0.b[11]
; CHECK-NEXT:    mov v1.b[2], w11
; CHECK-NEXT:    umov w11, v0.b[7]
; CHECK-NEXT:    mov v2.b[2], w8
; CHECK-NEXT:    umov w8, v0.b[4]
; CHECK-NEXT:    mov v1.b[3], w9
; CHECK-NEXT:    umov w9, v0.b[12]
; CHECK-NEXT:    mov v2.b[3], w10
; CHECK-NEXT:    umov w10, v0.b[5]
; CHECK-NEXT:    mov v1.b[4], w8
; CHECK-NEXT:    umov w8, v0.b[13]
; CHECK-NEXT:    mov v2.b[4], w9
; CHECK-NEXT:    umov w9, v0.b[6]
; CHECK-NEXT:    mov v1.b[5], w10
; CHECK-NEXT:    umov w10, v0.b[14]
; CHECK-NEXT:    mov v2.b[5], w8
; CHECK-NEXT:    mov x8, #16
; CHECK-NEXT:    mov v1.b[6], w9
; CHECK-NEXT:    mov x9, #24
; CHECK-NEXT:    ld1w { z4.s }, p0/z, [x0, x8, lsl #2]
; CHECK-NEXT:    mov v2.b[6], w10
; CHECK-NEXT:    umov w10, v0.b[15]
; CHECK-NEXT:    ext z0.b, z0.b, z0.b, #16
; CHECK-NEXT:    ld1w { z5.s }, p0/z, [x0, x9, lsl #2]
; CHECK-NEXT:    dup v3.2d, v0.d[1]
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    mov v1.b[7], w11
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    mov v2.b[7], w10
; CHECK-NEXT:    uunpklo z3.h, z3.b
; CHECK-NEXT:    uunpklo z3.s, z3.h
; CHECK-NEXT:    mov x11, #8
; CHECK-NEXT:    lsl z0.s, z0.s, #31
; CHECK-NEXT:    lsl z3.s, z3.s, #31
; CHECK-NEXT:    asr z0.s, z0.s, #31
; CHECK-NEXT:    asr z3.s, z3.s, #31
; CHECK-NEXT:    uunpklo z1.h, z1.b
; CHECK-NEXT:    uunpklo z2.h, z2.b
; CHECK-NEXT:    and z0.s, z0.s, #0x1
; CHECK-NEXT:    and z3.s, z3.s, #0x1
; CHECK-NEXT:    uunpklo z1.s, z1.h
; CHECK-NEXT:    uunpklo z2.s, z2.h
; CHECK-NEXT:    cmpne p1.s, p0/z, z0.s, #0
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [x0, x11, lsl #2]
; CHECK-NEXT:    cmpne p2.s, p0/z, z3.s, #0
; CHECK-NEXT:    ld1w { z3.s }, p0/z, [x0]
; CHECK-NEXT:    lsl z1.s, z1.s, #31
; CHECK-NEXT:    lsl z2.s, z2.s, #31
; CHECK-NEXT:    asr z1.s, z1.s, #31
; CHECK-NEXT:    asr z2.s, z2.s, #31
; CHECK-NEXT:    and z1.s, z1.s, #0x1
; CHECK-NEXT:    and z2.s, z2.s, #0x1
; CHECK-NEXT:    mov z4.s, p1/m, #0 // =0x0
; CHECK-NEXT:    mov z5.s, p2/m, #0 // =0x0
; CHECK-NEXT:    cmpne p1.s, p0/z, z1.s, #0
; CHECK-NEXT:    cmpne p2.s, p0/z, z2.s, #0
; CHECK-NEXT:    mov z3.s, p1/m, #0 // =0x0
; CHECK-NEXT:    mov z0.s, p2/m, #0 // =0x0
; CHECK-NEXT:    st1w { z4.s }, p0, [x0, x8, lsl #2]
; CHECK-NEXT:    st1w { z5.s }, p0, [x0, x9, lsl #2]
; CHECK-NEXT:    st1w { z0.s }, p0, [x0, x11, lsl #2]
; CHECK-NEXT:    st1w { z3.s }, p0, [x0]
; CHECK-NEXT:  .LBB1_2: // %exit
; CHECK-NEXT:    ret
  %broadcast.splat = shufflevector <32 x i1> zeroinitializer, <32 x i1> zeroinitializer, <32 x i32> zeroinitializer
  br i1 %cond, label %exit, label %vector.body

vector.body:
  %1 = load <32 x i32>, <32 x i32>* %dst, align 16
  %predphi = select <32 x i1> %broadcast.splat, <32 x i32> zeroinitializer, <32 x i32> %1
  store <32 x i32> %predphi, <32 x i32>* %dst, align 16
  br label %exit

exit:
  ret void
}

attributes #0 = { vscale_range(2,2) "target-features"="+sve" }
