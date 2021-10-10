; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-linux-gnu -mattr=+neon | FileCheck %s
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon -global-isel -global-isel-abort=1 | FileCheck %s --check-prefix=GISEL

define i1 @test_redxor_v1i1(<1 x i1> %a) {
; CHECK-LABEL: test_redxor_v1i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w0, w0, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v1i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    and w0, w0, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.xor.v1i1(<1 x i1> %a)
  ret i1 %or_result
}

define i1 @test_redxor_v2i1(<2 x i1> %a) {
; CHECK-LABEL: test_redxor_v2i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v2i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    mov s1, v0.s[1]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    and w0, w8, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.xor.v2i1(<2 x i1> %a)
  ret i1 %or_result
}

define i1 @test_redxor_v4i1(<4 x i1> %a) {
; CHECK-LABEL: test_redxor_v4i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w8, v0.h[1]
; CHECK-NEXT:    umov w9, v0.h[0]
; CHECK-NEXT:    umov w10, v0.h[2]
; CHECK-NEXT:    umov w11, v0.h[3]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    eor w8, w8, w11
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v4i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    mov h1, v0.h[1]
; GISEL-NEXT:    mov h2, v0.h[2]
; GISEL-NEXT:    mov h3, v0.h[3]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    eor w9, w10, w11
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    and w0, w8, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.xor.v4i1(<4 x i1> %a)
  ret i1 %or_result
}

define i1 @test_redxor_v8i1(<8 x i1> %a) {
; CHECK-LABEL: test_redxor_v8i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w8, v0.b[1]
; CHECK-NEXT:    umov w9, v0.b[0]
; CHECK-NEXT:    umov w10, v0.b[2]
; CHECK-NEXT:    umov w11, v0.b[3]
; CHECK-NEXT:    umov w12, v0.b[4]
; CHECK-NEXT:    umov w13, v0.b[5]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    umov w9, v0.b[6]
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    umov w10, v0.b[7]
; CHECK-NEXT:    eor w8, w8, w11
; CHECK-NEXT:    eor w8, w8, w12
; CHECK-NEXT:    eor w8, w8, w13
; CHECK-NEXT:    eor w8, w8, w9
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v8i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    mov b1, v0.b[1]
; GISEL-NEXT:    mov b2, v0.b[2]
; GISEL-NEXT:    mov b3, v0.b[3]
; GISEL-NEXT:    mov b4, v0.b[4]
; GISEL-NEXT:    mov b5, v0.b[5]
; GISEL-NEXT:    mov b6, v0.b[6]
; GISEL-NEXT:    mov b7, v0.b[7]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    fmov w12, s4
; GISEL-NEXT:    fmov w13, s5
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    fmov w9, s6
; GISEL-NEXT:    eor w10, w10, w11
; GISEL-NEXT:    fmov w11, s7
; GISEL-NEXT:    eor w12, w12, w13
; GISEL-NEXT:    eor w8, w8, w10
; GISEL-NEXT:    eor w9, w9, w11
; GISEL-NEXT:    eor w9, w12, w9
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    and w0, w8, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.xor.v8i1(<8 x i1> %a)
  ret i1 %or_result
}

define i1 @test_redxor_v16i1(<16 x i1> %a) {
; CHECK-LABEL: test_redxor_v16i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    eor v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    umov w8, v0.b[1]
; CHECK-NEXT:    umov w9, v0.b[0]
; CHECK-NEXT:    umov w10, v0.b[2]
; CHECK-NEXT:    umov w11, v0.b[3]
; CHECK-NEXT:    umov w12, v0.b[4]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    umov w9, v0.b[5]
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    umov w10, v0.b[6]
; CHECK-NEXT:    eor w8, w8, w11
; CHECK-NEXT:    umov w11, v0.b[7]
; CHECK-NEXT:    eor w8, w8, w12
; CHECK-NEXT:    eor w8, w8, w9
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    eor w8, w8, w11
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v16i1:
; GISEL:       // %bb.0:
; GISEL-NEXT:    mov b1, v0.b[1]
; GISEL-NEXT:    mov b2, v0.b[2]
; GISEL-NEXT:    mov b3, v0.b[3]
; GISEL-NEXT:    mov b4, v0.b[4]
; GISEL-NEXT:    mov b5, v0.b[5]
; GISEL-NEXT:    mov b6, v0.b[6]
; GISEL-NEXT:    mov b7, v0.b[7]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    mov b16, v0.b[8]
; GISEL-NEXT:    mov b17, v0.b[9]
; GISEL-NEXT:    mov b18, v0.b[10]
; GISEL-NEXT:    mov b19, v0.b[11]
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    eor w9, w10, w11
; GISEL-NEXT:    fmov w10, s4
; GISEL-NEXT:    fmov w11, s5
; GISEL-NEXT:    fmov w12, s6
; GISEL-NEXT:    fmov w13, s7
; GISEL-NEXT:    mov b20, v0.b[12]
; GISEL-NEXT:    mov b21, v0.b[13]
; GISEL-NEXT:    mov b22, v0.b[14]
; GISEL-NEXT:    mov b23, v0.b[15]
; GISEL-NEXT:    eor w10, w10, w11
; GISEL-NEXT:    eor w11, w12, w13
; GISEL-NEXT:    fmov w12, s16
; GISEL-NEXT:    fmov w13, s17
; GISEL-NEXT:    fmov w14, s18
; GISEL-NEXT:    fmov w15, s19
; GISEL-NEXT:    fmov w16, s22
; GISEL-NEXT:    fmov w17, s23
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    eor w12, w12, w13
; GISEL-NEXT:    eor w9, w10, w11
; GISEL-NEXT:    eor w13, w14, w15
; GISEL-NEXT:    fmov w14, s20
; GISEL-NEXT:    fmov w15, s21
; GISEL-NEXT:    eor w10, w12, w13
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    eor w14, w14, w15
; GISEL-NEXT:    eor w15, w16, w17
; GISEL-NEXT:    eor w11, w14, w15
; GISEL-NEXT:    eor w9, w10, w11
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    and w0, w8, #0x1
; GISEL-NEXT:    ret
  %or_result = call i1 @llvm.vector.reduce.xor.v16i1(<16 x i1> %a)
  ret i1 %or_result
}

define i8 @test_redxor_v1i8(<1 x i8> %a) {
; CHECK-LABEL: test_redxor_v1i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w0, v0.b[0]
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v1i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    fmov x0, d0
; GISEL-NEXT:    // kill: def $w0 killed $w0 killed $x0
; GISEL-NEXT:    ret
  %xor_result = call i8 @llvm.vector.reduce.xor.v1i8(<1 x i8> %a)
  ret i8 %xor_result
}

define i8 @test_redxor_v3i8(<3 x i8> %a) {
; CHECK-LABEL: test_redxor_v3i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor w8, w0, w1
; CHECK-NEXT:    eor w0, w8, w2
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v3i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    eor w8, w0, w1
; GISEL-NEXT:    eor w0, w8, w2
; GISEL-NEXT:    ret
  %xor_result = call i8 @llvm.vector.reduce.xor.v3i8(<3 x i8> %a)
  ret i8 %xor_result
}

define i8 @test_redxor_v4i8(<4 x i8> %a) {
; CHECK-LABEL: test_redxor_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w8, v0.h[1]
; CHECK-NEXT:    umov w9, v0.h[0]
; CHECK-NEXT:    umov w10, v0.h[2]
; CHECK-NEXT:    umov w11, v0.h[3]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    eor w0, w8, w11
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v4i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    mov h1, v0.h[1]
; GISEL-NEXT:    mov h2, v0.h[2]
; GISEL-NEXT:    mov h3, v0.h[3]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    eor w9, w10, w11
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i8 @llvm.vector.reduce.xor.v4i8(<4 x i8> %a)
  ret i8 %xor_result
}

define i8 @test_redxor_v8i8(<8 x i8> %a) {
; CHECK-LABEL: test_redxor_v8i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w8, v0.b[1]
; CHECK-NEXT:    umov w9, v0.b[0]
; CHECK-NEXT:    umov w10, v0.b[2]
; CHECK-NEXT:    umov w11, v0.b[3]
; CHECK-NEXT:    umov w12, v0.b[4]
; CHECK-NEXT:    umov w13, v0.b[5]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    umov w9, v0.b[6]
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    umov w10, v0.b[7]
; CHECK-NEXT:    eor w8, w8, w11
; CHECK-NEXT:    eor w8, w8, w12
; CHECK-NEXT:    eor w8, w8, w13
; CHECK-NEXT:    eor w8, w8, w9
; CHECK-NEXT:    eor w0, w8, w10
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v8i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    mov b1, v0.b[1]
; GISEL-NEXT:    mov b2, v0.b[2]
; GISEL-NEXT:    mov b3, v0.b[3]
; GISEL-NEXT:    mov b4, v0.b[4]
; GISEL-NEXT:    mov b5, v0.b[5]
; GISEL-NEXT:    mov b6, v0.b[6]
; GISEL-NEXT:    mov b7, v0.b[7]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    fmov w12, s4
; GISEL-NEXT:    fmov w13, s5
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    fmov w9, s6
; GISEL-NEXT:    eor w10, w10, w11
; GISEL-NEXT:    fmov w11, s7
; GISEL-NEXT:    eor w12, w12, w13
; GISEL-NEXT:    eor w8, w8, w10
; GISEL-NEXT:    eor w9, w9, w11
; GISEL-NEXT:    eor w9, w12, w9
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i8 @llvm.vector.reduce.xor.v8i8(<8 x i8> %a)
  ret i8 %xor_result
}

define i8 @test_redxor_v16i8(<16 x i8> %a) {
; CHECK-LABEL: test_redxor_v16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    eor v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    umov w8, v0.b[1]
; CHECK-NEXT:    umov w9, v0.b[0]
; CHECK-NEXT:    umov w10, v0.b[2]
; CHECK-NEXT:    umov w11, v0.b[3]
; CHECK-NEXT:    umov w12, v0.b[4]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    umov w9, v0.b[5]
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    umov w10, v0.b[6]
; CHECK-NEXT:    eor w8, w8, w11
; CHECK-NEXT:    umov w11, v0.b[7]
; CHECK-NEXT:    eor w8, w8, w12
; CHECK-NEXT:    eor w8, w8, w9
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    eor w0, w8, w11
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v16i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    eor v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    mov b1, v0.b[1]
; GISEL-NEXT:    mov b2, v0.b[2]
; GISEL-NEXT:    mov b3, v0.b[3]
; GISEL-NEXT:    mov b4, v0.b[4]
; GISEL-NEXT:    mov b5, v0.b[5]
; GISEL-NEXT:    mov b6, v0.b[6]
; GISEL-NEXT:    mov b7, v0.b[7]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    fmov w12, s4
; GISEL-NEXT:    fmov w13, s5
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    fmov w9, s6
; GISEL-NEXT:    eor w10, w10, w11
; GISEL-NEXT:    fmov w11, s7
; GISEL-NEXT:    eor w12, w12, w13
; GISEL-NEXT:    eor w8, w8, w10
; GISEL-NEXT:    eor w9, w9, w11
; GISEL-NEXT:    eor w9, w12, w9
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i8 @llvm.vector.reduce.xor.v16i8(<16 x i8> %a)
  ret i8 %xor_result
}

define i8 @test_redxor_v32i8(<32 x i8> %a) {
; CHECK-LABEL: test_redxor_v32i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    eor v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    umov w8, v0.b[1]
; CHECK-NEXT:    umov w9, v0.b[0]
; CHECK-NEXT:    umov w10, v0.b[2]
; CHECK-NEXT:    umov w11, v0.b[3]
; CHECK-NEXT:    umov w12, v0.b[4]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    umov w9, v0.b[5]
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    umov w10, v0.b[6]
; CHECK-NEXT:    eor w8, w8, w11
; CHECK-NEXT:    umov w11, v0.b[7]
; CHECK-NEXT:    eor w8, w8, w12
; CHECK-NEXT:    eor w8, w8, w9
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    eor w0, w8, w11
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v32i8:
; GISEL:       // %bb.0:
; GISEL-NEXT:    eor v0.16b, v0.16b, v1.16b
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    eor v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    mov b1, v0.b[1]
; GISEL-NEXT:    mov b2, v0.b[2]
; GISEL-NEXT:    mov b3, v0.b[3]
; GISEL-NEXT:    mov b4, v0.b[4]
; GISEL-NEXT:    mov b5, v0.b[5]
; GISEL-NEXT:    mov b6, v0.b[6]
; GISEL-NEXT:    mov b7, v0.b[7]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    fmov w12, s4
; GISEL-NEXT:    fmov w13, s5
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    fmov w9, s6
; GISEL-NEXT:    eor w10, w10, w11
; GISEL-NEXT:    fmov w11, s7
; GISEL-NEXT:    eor w12, w12, w13
; GISEL-NEXT:    eor w8, w8, w10
; GISEL-NEXT:    eor w9, w9, w11
; GISEL-NEXT:    eor w9, w12, w9
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i8 @llvm.vector.reduce.xor.v32i8(<32 x i8> %a)
  ret i8 %xor_result
}

define i16 @test_redxor_v4i16(<4 x i16> %a) {
; CHECK-LABEL: test_redxor_v4i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w8, v0.h[1]
; CHECK-NEXT:    umov w9, v0.h[0]
; CHECK-NEXT:    umov w10, v0.h[2]
; CHECK-NEXT:    umov w11, v0.h[3]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    eor w0, w8, w11
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v4i16:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    mov h1, v0.h[1]
; GISEL-NEXT:    mov h2, v0.h[2]
; GISEL-NEXT:    mov h3, v0.h[3]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    eor w9, w10, w11
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i16 @llvm.vector.reduce.xor.v4i16(<4 x i16> %a)
  ret i16 %xor_result
}

define i16 @test_redxor_v8i16(<8 x i16> %a) {
; CHECK-LABEL: test_redxor_v8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    eor v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    umov w8, v0.h[1]
; CHECK-NEXT:    umov w9, v0.h[0]
; CHECK-NEXT:    umov w10, v0.h[2]
; CHECK-NEXT:    umov w11, v0.h[3]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    eor w0, w8, w11
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v8i16:
; GISEL:       // %bb.0:
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    eor v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    mov h1, v0.h[1]
; GISEL-NEXT:    mov h2, v0.h[2]
; GISEL-NEXT:    mov h3, v0.h[3]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    eor w9, w10, w11
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i16 @llvm.vector.reduce.xor.v8i16(<8 x i16> %a)
  ret i16 %xor_result
}

define i16 @test_redxor_v16i16(<16 x i16> %a) {
; CHECK-LABEL: test_redxor_v16i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    eor v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    umov w8, v0.h[1]
; CHECK-NEXT:    umov w9, v0.h[0]
; CHECK-NEXT:    umov w10, v0.h[2]
; CHECK-NEXT:    umov w11, v0.h[3]
; CHECK-NEXT:    eor w8, w9, w8
; CHECK-NEXT:    eor w8, w8, w10
; CHECK-NEXT:    eor w0, w8, w11
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v16i16:
; GISEL:       // %bb.0:
; GISEL-NEXT:    eor v0.16b, v0.16b, v1.16b
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    eor v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    mov h1, v0.h[1]
; GISEL-NEXT:    mov h2, v0.h[2]
; GISEL-NEXT:    mov h3, v0.h[3]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    fmov w10, s2
; GISEL-NEXT:    fmov w11, s3
; GISEL-NEXT:    eor w8, w8, w9
; GISEL-NEXT:    eor w9, w10, w11
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i16 @llvm.vector.reduce.xor.v16i16(<16 x i16> %a)
  ret i16 %xor_result
}

define i32 @test_redxor_v2i32(<2 x i32> %a) {
; CHECK-LABEL: test_redxor_v2i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    eor w0, w9, w8
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v2i32:
; GISEL:       // %bb.0:
; GISEL-NEXT:    // kill: def $d0 killed $d0 def $q0
; GISEL-NEXT:    mov s1, v0.s[1]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i32 @llvm.vector.reduce.xor.v2i32(<2 x i32> %a)
  ret i32 %xor_result
}

define i32 @test_redxor_v4i32(<4 x i32> %a) {
; CHECK-LABEL: test_redxor_v4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    eor v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    eor w0, w9, w8
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v4i32:
; GISEL:       // %bb.0:
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    eor v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    mov s1, v0.s[1]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i32 @llvm.vector.reduce.xor.v4i32(<4 x i32> %a)
  ret i32 %xor_result
}

define i32 @test_redxor_v8i32(<8 x i32> %a) {
; CHECK-LABEL: test_redxor_v8i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    eor v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    eor w0, w9, w8
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v8i32:
; GISEL:       // %bb.0:
; GISEL-NEXT:    eor v0.16b, v0.16b, v1.16b
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    eor v0.8b, v0.8b, v1.8b
; GISEL-NEXT:    mov s1, v0.s[1]
; GISEL-NEXT:    fmov w8, s0
; GISEL-NEXT:    fmov w9, s1
; GISEL-NEXT:    eor w0, w8, w9
; GISEL-NEXT:    ret
  %xor_result = call i32 @llvm.vector.reduce.xor.v8i32(<8 x i32> %a)
  ret i32 %xor_result
}

define i64 @test_redxor_v2i64(<2 x i64> %a) {
; CHECK-LABEL: test_redxor_v2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    eor v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v2i64:
; GISEL:       // %bb.0:
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    fmov x8, d0
; GISEL-NEXT:    fmov x9, d1
; GISEL-NEXT:    eor x0, x8, x9
; GISEL-NEXT:    ret
  %xor_result = call i64 @llvm.vector.reduce.xor.v2i64(<2 x i64> %a)
  ret i64 %xor_result
}

define i64 @test_redxor_v4i64(<4 x i64> %a) {
; CHECK-LABEL: test_redxor_v4i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    eor v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    eor v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
;
; GISEL-LABEL: test_redxor_v4i64:
; GISEL:       // %bb.0:
; GISEL-NEXT:    eor v0.16b, v0.16b, v1.16b
; GISEL-NEXT:    mov d1, v0.d[1]
; GISEL-NEXT:    fmov x8, d0
; GISEL-NEXT:    fmov x9, d1
; GISEL-NEXT:    eor x0, x8, x9
; GISEL-NEXT:    ret
  %xor_result = call i64 @llvm.vector.reduce.xor.v4i64(<4 x i64> %a)
  ret i64 %xor_result
}

declare i1 @llvm.vector.reduce.xor.v1i1(<1 x i1>)
declare i1 @llvm.vector.reduce.xor.v2i1(<2 x i1>)
declare i1 @llvm.vector.reduce.xor.v4i1(<4 x i1>)
declare i1 @llvm.vector.reduce.xor.v8i1(<8 x i1>)
declare i1 @llvm.vector.reduce.xor.v16i1(<16 x i1>)
declare i64 @llvm.vector.reduce.xor.v2i64(<2 x i64>)
declare i64 @llvm.vector.reduce.xor.v4i64(<4 x i64>)
declare i32 @llvm.vector.reduce.xor.v2i32(<2 x i32>)
declare i32 @llvm.vector.reduce.xor.v4i32(<4 x i32>)
declare i32 @llvm.vector.reduce.xor.v8i32(<8 x i32>)
declare i16 @llvm.vector.reduce.xor.v4i16(<4 x i16>)
declare i16 @llvm.vector.reduce.xor.v8i16(<8 x i16>)
declare i16 @llvm.vector.reduce.xor.v16i16(<16 x i16>)
declare i8 @llvm.vector.reduce.xor.v1i8(<1 x i8>)
declare i8 @llvm.vector.reduce.xor.v3i8(<3 x i8>)
declare i8 @llvm.vector.reduce.xor.v4i8(<4 x i8>)
declare i8 @llvm.vector.reduce.xor.v8i8(<8 x i8>)
declare i8 @llvm.vector.reduce.xor.v16i8(<16 x i8>)
declare i8 @llvm.vector.reduce.xor.v32i8(<32 x i8>)
