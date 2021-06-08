; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-linux-gnu -mattr=+neon | FileCheck %s --check-prefix=CHECK

declare i1 @llvm.vector.reduce.and.v1i1(<1 x i1> %a)
declare i1 @llvm.vector.reduce.and.v2i1(<2 x i1> %a)
declare i1 @llvm.vector.reduce.and.v4i1(<4 x i1> %a)
declare i1 @llvm.vector.reduce.and.v8i1(<8 x i1> %a)
declare i1 @llvm.vector.reduce.and.v16i1(<16 x i1> %a)
declare i1 @llvm.vector.reduce.and.v32i1(<32 x i1> %a)

declare i1 @llvm.vector.reduce.or.v1i1(<1 x i1> %a)
declare i1 @llvm.vector.reduce.or.v2i1(<2 x i1> %a)
declare i1 @llvm.vector.reduce.or.v4i1(<4 x i1> %a)
declare i1 @llvm.vector.reduce.or.v8i1(<8 x i1> %a)
declare i1 @llvm.vector.reduce.or.v16i1(<16 x i1> %a)
declare i1 @llvm.vector.reduce.or.v32i1(<32 x i1> %a)

define i32 @reduce_and_v1(<1 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_and_v1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    smov w8, v0.b[0]
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    csel w0, w0, w1, lt
; CHECK-NEXT:    ret
  %x = icmp slt <1 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.and.v1i1(<1 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_and_v2(<2 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_and_v2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.2s, v0.2s, #24
; CHECK-NEXT:    sshr v0.2s, v0.2s, #24
; CHECK-NEXT:    cmlt v0.2s, v0.2s, #0
; CHECK-NEXT:    uminp v0.2s, v0.2s, v0.2s
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <2 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.and.v2i1(<2 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_and_v4(<4 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_and_v4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.4h, v0.4h, #8
; CHECK-NEXT:    sshr v0.4h, v0.4h, #8
; CHECK-NEXT:    cmlt v0.4h, v0.4h, #0
; CHECK-NEXT:    uminv h0, v0.4h
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <4 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.and.v4i1(<4 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_and_v8(<8 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_and_v8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.8b, v0.8b, #0
; CHECK-NEXT:    uminv b0, v0.8b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <8 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.and.v8i1(<8 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_and_v16(<16 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_and_v16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    uminv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <16 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.and.v16i1(<16 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_and_v32(<32 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_and_v32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    uminv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <32 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.and.v32i1(<32 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_or_v1(<1 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_or_v1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $d0 killed $d0 def $q0
; CHECK-NEXT:    smov w8, v0.b[0]
; CHECK-NEXT:    cmp w8, #0 // =0
; CHECK-NEXT:    csel w0, w0, w1, lt
; CHECK-NEXT:    ret
  %x = icmp slt <1 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.or.v1i1(<1 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_or_v2(<2 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_or_v2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.2s, v0.2s, #24
; CHECK-NEXT:    sshr v0.2s, v0.2s, #24
; CHECK-NEXT:    cmlt v0.2s, v0.2s, #0
; CHECK-NEXT:    umaxp v0.2s, v0.2s, v0.2s
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <2 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.or.v2i1(<2 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_or_v4(<4 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_or_v4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.4h, v0.4h, #8
; CHECK-NEXT:    sshr v0.4h, v0.4h, #8
; CHECK-NEXT:    cmlt v0.4h, v0.4h, #0
; CHECK-NEXT:    umaxv h0, v0.4h
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <4 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.or.v4i1(<4 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_or_v8(<8 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_or_v8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.8b, v0.8b, #0
; CHECK-NEXT:    umaxv b0, v0.8b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <8 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.or.v8i1(<8 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_or_v16(<16 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_or_v16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    umaxv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <16 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.or.v16i1(<16 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}

define i32 @reduce_or_v32(<32 x i8> %a0, i32 %a1, i32 %a2) nounwind {
; CHECK-LABEL: reduce_or_v32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr v0.16b, v0.16b, v1.16b
; CHECK-NEXT:    cmlt v0.16b, v0.16b, #0
; CHECK-NEXT:    umaxv b0, v0.16b
; CHECK-NEXT:    fmov w8, s0
; CHECK-NEXT:    tst w8, #0x1
; CHECK-NEXT:    csel w0, w0, w1, ne
; CHECK-NEXT:    ret
  %x = icmp slt <32 x i8> %a0, zeroinitializer
  %y = call i1 @llvm.vector.reduce.or.v32i1(<32 x i1> %x)
  %z = select i1 %y, i32 %a1, i32 %a2
  ret i32 %z
}
