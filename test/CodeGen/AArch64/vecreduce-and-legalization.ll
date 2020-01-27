; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon | FileCheck %s --check-prefix=CHECK

declare i1 @llvm.experimental.vector.reduce.and.v1i1(<1 x i1> %a)
declare i8 @llvm.experimental.vector.reduce.and.v1i8(<1 x i8> %a)
declare i16 @llvm.experimental.vector.reduce.and.v1i16(<1 x i16> %a)
declare i24 @llvm.experimental.vector.reduce.and.v1i24(<1 x i24> %a)
declare i32 @llvm.experimental.vector.reduce.and.v1i32(<1 x i32> %a)
declare i64 @llvm.experimental.vector.reduce.and.v1i64(<1 x i64> %a)
declare i128 @llvm.experimental.vector.reduce.and.v1i128(<1 x i128> %a)

declare i8 @llvm.experimental.vector.reduce.and.v3i8(<3 x i8> %a)
declare i8 @llvm.experimental.vector.reduce.and.v9i8(<9 x i8> %a)
declare i32 @llvm.experimental.vector.reduce.and.v3i32(<3 x i32> %a)
declare i1 @llvm.experimental.vector.reduce.and.v4i1(<4 x i1> %a)
declare i24 @llvm.experimental.vector.reduce.and.v4i24(<4 x i24> %a)
declare i128 @llvm.experimental.vector.reduce.and.v2i128(<2 x i128> %a)
declare i32 @llvm.experimental.vector.reduce.and.v16i32(<16 x i32> %a)

define i1 @test_v1i1(<1 x i1> %a) nounwind {
; CHECK-LABEL: test_v1i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w0, w0, #0x1
; CHECK-NEXT:    ret
  %b = call i1 @llvm.experimental.vector.reduce.and.v1i1(<1 x i1> %a)
  ret i1 %b
}

define i8 @test_v1i8(<1 x i8> %a) nounwind {
; CHECK-LABEL: test_v1i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w0, v0.b[0]
; CHECK-NEXT:    ret
  %b = call i8 @llvm.experimental.vector.reduce.and.v1i8(<1 x i8> %a)
  ret i8 %b
}

define i16 @test_v1i16(<1 x i16> %a) nounwind {
; CHECK-LABEL: test_v1i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w0, v0.h[0]
; CHECK-NEXT:    ret
  %b = call i16 @llvm.experimental.vector.reduce.and.v1i16(<1 x i16> %a)
  ret i16 %b
}

define i24 @test_v1i24(<1 x i24> %a) nounwind {
; CHECK-LABEL: test_v1i24:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %b = call i24 @llvm.experimental.vector.reduce.and.v1i24(<1 x i24> %a)
  ret i24 %b
}

define i32 @test_v1i32(<1 x i32> %a) nounwind {
; CHECK-LABEL: test_v1i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    fmov w0, s0
; CHECK-NEXT:    ret
  %b = call i32 @llvm.experimental.vector.reduce.and.v1i32(<1 x i32> %a)
  ret i32 %b
}

define i64 @test_v1i64(<1 x i64> %a) nounwind {
; CHECK-LABEL: test_v1i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    fmov x0, d0
; CHECK-NEXT:    ret
  %b = call i64 @llvm.experimental.vector.reduce.and.v1i64(<1 x i64> %a)
  ret i64 %b
}

define i128 @test_v1i128(<1 x i128> %a) nounwind {
; CHECK-LABEL: test_v1i128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %b = call i128 @llvm.experimental.vector.reduce.and.v1i128(<1 x i128> %a)
  ret i128 %b
}

define i8 @test_v3i8(<3 x i8> %a) nounwind {
; CHECK-LABEL: test_v3i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w8, w0, w1
; CHECK-NEXT:    and w8, w8, w2
; CHECK-NEXT:    and w0, w8, #0xff
; CHECK-NEXT:    ret
  %b = call i8 @llvm.experimental.vector.reduce.and.v3i8(<3 x i8> %a)
  ret i8 %b
}

define i8 @test_v9i8(<9 x i8> %a) nounwind {
; CHECK-LABEL: test_v9i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #-1
; CHECK-NEXT:    mov v0.b[9], w8
; CHECK-NEXT:    mov v0.b[10], w8
; CHECK-NEXT:    mov v0.b[11], w8
; CHECK-NEXT:    mov v0.b[12], w8
; CHECK-NEXT:    mov v0.b[13], w8
; CHECK-NEXT:    mov v0.b[14], w8
; CHECK-NEXT:    mov v0.b[15], w8
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v1.8b, v0.8b, v1.8b
; CHECK-NEXT:    umov w8, v1.b[1]
; CHECK-NEXT:    umov w9, v1.b[0]
; CHECK-NEXT:    and w8, w9, w8
; CHECK-NEXT:    umov w9, v1.b[2]
; CHECK-NEXT:    and w8, w8, w9
; CHECK-NEXT:    umov w9, v1.b[3]
; CHECK-NEXT:    and w8, w8, w9
; CHECK-NEXT:    umov w9, v1.b[4]
; CHECK-NEXT:    and w8, w8, w9
; CHECK-NEXT:    umov w9, v1.b[5]
; CHECK-NEXT:    and w8, w8, w9
; CHECK-NEXT:    umov w9, v0.b[6]
; CHECK-NEXT:    and w8, w8, w9
; CHECK-NEXT:    umov w9, v0.b[7]
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
  %b = call i8 @llvm.experimental.vector.reduce.and.v9i8(<9 x i8> %a)
  ret i8 %b
}

define i32 @test_v3i32(<3 x i32> %a) nounwind {
; CHECK-LABEL: test_v3i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v1.8b, v0.8b, v1.8b
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %b = call i32 @llvm.experimental.vector.reduce.and.v3i32(<3 x i32> %a)
  ret i32 %b
}

define i1 @test_v4i1(<4 x i1> %a) nounwind {
; CHECK-LABEL: test_v4i1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    umov w10, v0.h[1]
; CHECK-NEXT:    umov w11, v0.h[0]
; CHECK-NEXT:    umov w9, v0.h[2]
; CHECK-NEXT:    and w10, w11, w10
; CHECK-NEXT:    umov w8, v0.h[3]
; CHECK-NEXT:    and w9, w10, w9
; CHECK-NEXT:    and w8, w9, w8
; CHECK-NEXT:    and w0, w8, #0x1
; CHECK-NEXT:    ret
  %b = call i1 @llvm.experimental.vector.reduce.and.v4i1(<4 x i1> %a)
  ret i1 %b
}

define i24 @test_v4i24(<4 x i24> %a) nounwind {
; CHECK-LABEL: test_v4i24:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %b = call i24 @llvm.experimental.vector.reduce.and.v4i24(<4 x i24> %a)
  ret i24 %b
}

define i128 @test_v2i128(<2 x i128> %a) nounwind {
; CHECK-LABEL: test_v2i128:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and x0, x0, x2
; CHECK-NEXT:    and x1, x1, x3
; CHECK-NEXT:    ret
  %b = call i128 @llvm.experimental.vector.reduce.and.v2i128(<2 x i128> %a)
  ret i128 %b
}

define i32 @test_v16i32(<16 x i32> %a) nounwind {
; CHECK-LABEL: test_v16i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and v1.16b, v1.16b, v3.16b
; CHECK-NEXT:    and v0.16b, v0.16b, v2.16b
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    ext v1.16b, v0.16b, v0.16b, #8
; CHECK-NEXT:    and v0.8b, v0.8b, v1.8b
; CHECK-NEXT:    mov w8, v0.s[1]
; CHECK-NEXT:    fmov w9, s0
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %b = call i32 @llvm.experimental.vector.reduce.and.v16i32(<16 x i32> %a)
  ret i32 %b
}
