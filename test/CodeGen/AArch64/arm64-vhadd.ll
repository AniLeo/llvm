; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=arm64-eabi -aarch64-neon-syntax=apple | FileCheck %s

define <8 x i8> @shadd8b(<8 x i8>* %A, <8 x i8>* %B) nounwind {
; CHECK-LABEL: shadd8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    shadd.8b v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <8 x i8>, <8 x i8>* %A
	%tmp2 = load <8 x i8>, <8 x i8>* %B
	%tmp3 = call <8 x i8> @llvm.aarch64.neon.shadd.v8i8(<8 x i8> %tmp1, <8 x i8> %tmp2)
	ret <8 x i8> %tmp3
}

define <16 x i8> @shadd16b(<16 x i8>* %A, <16 x i8>* %B) nounwind {
; CHECK-LABEL: shadd16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    shadd.16b v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <16 x i8>, <16 x i8>* %A
	%tmp2 = load <16 x i8>, <16 x i8>* %B
	%tmp3 = call <16 x i8> @llvm.aarch64.neon.shadd.v16i8(<16 x i8> %tmp1, <16 x i8> %tmp2)
	ret <16 x i8> %tmp3
}

define <4 x i16> @shadd4h(<4 x i16>* %A, <4 x i16>* %B) nounwind {
; CHECK-LABEL: shadd4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    shadd.4h v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <4 x i16>, <4 x i16>* %A
	%tmp2 = load <4 x i16>, <4 x i16>* %B
	%tmp3 = call <4 x i16> @llvm.aarch64.neon.shadd.v4i16(<4 x i16> %tmp1, <4 x i16> %tmp2)
	ret <4 x i16> %tmp3
}

define <8 x i16> @shadd8h(<8 x i16>* %A, <8 x i16>* %B) nounwind {
; CHECK-LABEL: shadd8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    shadd.8h v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <8 x i16>, <8 x i16>* %A
	%tmp2 = load <8 x i16>, <8 x i16>* %B
	%tmp3 = call <8 x i16> @llvm.aarch64.neon.shadd.v8i16(<8 x i16> %tmp1, <8 x i16> %tmp2)
	ret <8 x i16> %tmp3
}

define <2 x i32> @shadd2s(<2 x i32>* %A, <2 x i32>* %B) nounwind {
; CHECK-LABEL: shadd2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    shadd.2s v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <2 x i32>, <2 x i32>* %A
	%tmp2 = load <2 x i32>, <2 x i32>* %B
	%tmp3 = call <2 x i32> @llvm.aarch64.neon.shadd.v2i32(<2 x i32> %tmp1, <2 x i32> %tmp2)
	ret <2 x i32> %tmp3
}

define <4 x i32> @shadd4s(<4 x i32>* %A, <4 x i32>* %B) nounwind {
; CHECK-LABEL: shadd4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    shadd.4s v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <4 x i32>, <4 x i32>* %A
	%tmp2 = load <4 x i32>, <4 x i32>* %B
	%tmp3 = call <4 x i32> @llvm.aarch64.neon.shadd.v4i32(<4 x i32> %tmp1, <4 x i32> %tmp2)
	ret <4 x i32> %tmp3
}

define <8 x i8> @uhadd8b(<8 x i8>* %A, <8 x i8>* %B) nounwind {
; CHECK-LABEL: uhadd8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    uhadd.8b v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <8 x i8>, <8 x i8>* %A
	%tmp2 = load <8 x i8>, <8 x i8>* %B
	%tmp3 = call <8 x i8> @llvm.aarch64.neon.uhadd.v8i8(<8 x i8> %tmp1, <8 x i8> %tmp2)
	ret <8 x i8> %tmp3
}

define <16 x i8> @uhadd16b(<16 x i8>* %A, <16 x i8>* %B) nounwind {
; CHECK-LABEL: uhadd16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    uhadd.16b v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <16 x i8>, <16 x i8>* %A
	%tmp2 = load <16 x i8>, <16 x i8>* %B
	%tmp3 = call <16 x i8> @llvm.aarch64.neon.uhadd.v16i8(<16 x i8> %tmp1, <16 x i8> %tmp2)
	ret <16 x i8> %tmp3
}

define <4 x i16> @uhadd4h(<4 x i16>* %A, <4 x i16>* %B) nounwind {
; CHECK-LABEL: uhadd4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    uhadd.4h v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <4 x i16>, <4 x i16>* %A
	%tmp2 = load <4 x i16>, <4 x i16>* %B
	%tmp3 = call <4 x i16> @llvm.aarch64.neon.uhadd.v4i16(<4 x i16> %tmp1, <4 x i16> %tmp2)
	ret <4 x i16> %tmp3
}

define <8 x i16> @uhadd8h(<8 x i16>* %A, <8 x i16>* %B) nounwind {
; CHECK-LABEL: uhadd8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    uhadd.8h v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <8 x i16>, <8 x i16>* %A
	%tmp2 = load <8 x i16>, <8 x i16>* %B
	%tmp3 = call <8 x i16> @llvm.aarch64.neon.uhadd.v8i16(<8 x i16> %tmp1, <8 x i16> %tmp2)
	ret <8 x i16> %tmp3
}

define <2 x i32> @uhadd2s(<2 x i32>* %A, <2 x i32>* %B) nounwind {
; CHECK-LABEL: uhadd2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    uhadd.2s v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <2 x i32>, <2 x i32>* %A
	%tmp2 = load <2 x i32>, <2 x i32>* %B
	%tmp3 = call <2 x i32> @llvm.aarch64.neon.uhadd.v2i32(<2 x i32> %tmp1, <2 x i32> %tmp2)
	ret <2 x i32> %tmp3
}

define <4 x i32> @uhadd4s(<4 x i32>* %A, <4 x i32>* %B) nounwind {
; CHECK-LABEL: uhadd4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    uhadd.4s v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <4 x i32>, <4 x i32>* %A
	%tmp2 = load <4 x i32>, <4 x i32>* %B
	%tmp3 = call <4 x i32> @llvm.aarch64.neon.uhadd.v4i32(<4 x i32> %tmp1, <4 x i32> %tmp2)
	ret <4 x i32> %tmp3
}

declare <8 x i8>  @llvm.aarch64.neon.shadd.v8i8(<8 x i8>, <8 x i8>) nounwind readnone
declare <4 x i16> @llvm.aarch64.neon.shadd.v4i16(<4 x i16>, <4 x i16>) nounwind readnone
declare <2 x i32> @llvm.aarch64.neon.shadd.v2i32(<2 x i32>, <2 x i32>) nounwind readnone

declare <8 x i8>  @llvm.aarch64.neon.uhadd.v8i8(<8 x i8>, <8 x i8>) nounwind readnone
declare <4 x i16> @llvm.aarch64.neon.uhadd.v4i16(<4 x i16>, <4 x i16>) nounwind readnone
declare <2 x i32> @llvm.aarch64.neon.uhadd.v2i32(<2 x i32>, <2 x i32>) nounwind readnone

declare <16 x i8> @llvm.aarch64.neon.shadd.v16i8(<16 x i8>, <16 x i8>) nounwind readnone
declare <8 x i16> @llvm.aarch64.neon.shadd.v8i16(<8 x i16>, <8 x i16>) nounwind readnone
declare <4 x i32> @llvm.aarch64.neon.shadd.v4i32(<4 x i32>, <4 x i32>) nounwind readnone

declare <16 x i8> @llvm.aarch64.neon.uhadd.v16i8(<16 x i8>, <16 x i8>) nounwind readnone
declare <8 x i16> @llvm.aarch64.neon.uhadd.v8i16(<8 x i16>, <8 x i16>) nounwind readnone
declare <4 x i32> @llvm.aarch64.neon.uhadd.v4i32(<4 x i32>, <4 x i32>) nounwind readnone

define <8 x i8> @srhadd8b(<8 x i8>* %A, <8 x i8>* %B) nounwind {
; CHECK-LABEL: srhadd8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    srhadd.8b v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <8 x i8>, <8 x i8>* %A
	%tmp2 = load <8 x i8>, <8 x i8>* %B
	%tmp3 = call <8 x i8> @llvm.aarch64.neon.srhadd.v8i8(<8 x i8> %tmp1, <8 x i8> %tmp2)
	ret <8 x i8> %tmp3
}

define <16 x i8> @srhadd16b(<16 x i8>* %A, <16 x i8>* %B) nounwind {
; CHECK-LABEL: srhadd16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    srhadd.16b v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <16 x i8>, <16 x i8>* %A
	%tmp2 = load <16 x i8>, <16 x i8>* %B
	%tmp3 = call <16 x i8> @llvm.aarch64.neon.srhadd.v16i8(<16 x i8> %tmp1, <16 x i8> %tmp2)
	ret <16 x i8> %tmp3
}

define <4 x i16> @srhadd4h(<4 x i16>* %A, <4 x i16>* %B) nounwind {
; CHECK-LABEL: srhadd4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    srhadd.4h v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <4 x i16>, <4 x i16>* %A
	%tmp2 = load <4 x i16>, <4 x i16>* %B
	%tmp3 = call <4 x i16> @llvm.aarch64.neon.srhadd.v4i16(<4 x i16> %tmp1, <4 x i16> %tmp2)
	ret <4 x i16> %tmp3
}

define <8 x i16> @srhadd8h(<8 x i16>* %A, <8 x i16>* %B) nounwind {
; CHECK-LABEL: srhadd8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    srhadd.8h v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <8 x i16>, <8 x i16>* %A
	%tmp2 = load <8 x i16>, <8 x i16>* %B
	%tmp3 = call <8 x i16> @llvm.aarch64.neon.srhadd.v8i16(<8 x i16> %tmp1, <8 x i16> %tmp2)
	ret <8 x i16> %tmp3
}

define <2 x i32> @srhadd2s(<2 x i32>* %A, <2 x i32>* %B) nounwind {
; CHECK-LABEL: srhadd2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    srhadd.2s v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <2 x i32>, <2 x i32>* %A
	%tmp2 = load <2 x i32>, <2 x i32>* %B
	%tmp3 = call <2 x i32> @llvm.aarch64.neon.srhadd.v2i32(<2 x i32> %tmp1, <2 x i32> %tmp2)
	ret <2 x i32> %tmp3
}

define <4 x i32> @srhadd4s(<4 x i32>* %A, <4 x i32>* %B) nounwind {
; CHECK-LABEL: srhadd4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    srhadd.4s v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <4 x i32>, <4 x i32>* %A
	%tmp2 = load <4 x i32>, <4 x i32>* %B
	%tmp3 = call <4 x i32> @llvm.aarch64.neon.srhadd.v4i32(<4 x i32> %tmp1, <4 x i32> %tmp2)
	ret <4 x i32> %tmp3
}

define <8 x i8> @urhadd8b(<8 x i8>* %A, <8 x i8>* %B) nounwind {
; CHECK-LABEL: urhadd8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    urhadd.8b v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <8 x i8>, <8 x i8>* %A
	%tmp2 = load <8 x i8>, <8 x i8>* %B
	%tmp3 = call <8 x i8> @llvm.aarch64.neon.urhadd.v8i8(<8 x i8> %tmp1, <8 x i8> %tmp2)
	ret <8 x i8> %tmp3
}

define <16 x i8> @urhadd16b(<16 x i8>* %A, <16 x i8>* %B) nounwind {
; CHECK-LABEL: urhadd16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    urhadd.16b v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <16 x i8>, <16 x i8>* %A
	%tmp2 = load <16 x i8>, <16 x i8>* %B
	%tmp3 = call <16 x i8> @llvm.aarch64.neon.urhadd.v16i8(<16 x i8> %tmp1, <16 x i8> %tmp2)
	ret <16 x i8> %tmp3
}

define <4 x i16> @urhadd4h(<4 x i16>* %A, <4 x i16>* %B) nounwind {
; CHECK-LABEL: urhadd4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    urhadd.4h v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <4 x i16>, <4 x i16>* %A
	%tmp2 = load <4 x i16>, <4 x i16>* %B
	%tmp3 = call <4 x i16> @llvm.aarch64.neon.urhadd.v4i16(<4 x i16> %tmp1, <4 x i16> %tmp2)
	ret <4 x i16> %tmp3
}

define <8 x i16> @urhadd8h(<8 x i16>* %A, <8 x i16>* %B) nounwind {
; CHECK-LABEL: urhadd8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    urhadd.8h v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <8 x i16>, <8 x i16>* %A
	%tmp2 = load <8 x i16>, <8 x i16>* %B
	%tmp3 = call <8 x i16> @llvm.aarch64.neon.urhadd.v8i16(<8 x i16> %tmp1, <8 x i16> %tmp2)
	ret <8 x i16> %tmp3
}

define <2 x i32> @urhadd2s(<2 x i32>* %A, <2 x i32>* %B) nounwind {
; CHECK-LABEL: urhadd2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ldr d1, [x1]
; CHECK-NEXT:    urhadd.2s v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <2 x i32>, <2 x i32>* %A
	%tmp2 = load <2 x i32>, <2 x i32>* %B
	%tmp3 = call <2 x i32> @llvm.aarch64.neon.urhadd.v2i32(<2 x i32> %tmp1, <2 x i32> %tmp2)
	ret <2 x i32> %tmp3
}

define <4 x i32> @urhadd4s(<4 x i32>* %A, <4 x i32>* %B) nounwind {
; CHECK-LABEL: urhadd4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr q0, [x0]
; CHECK-NEXT:    ldr q1, [x1]
; CHECK-NEXT:    urhadd.4s v0, v0, v1
; CHECK-NEXT:    ret
	%tmp1 = load <4 x i32>, <4 x i32>* %A
	%tmp2 = load <4 x i32>, <4 x i32>* %B
	%tmp3 = call <4 x i32> @llvm.aarch64.neon.urhadd.v4i32(<4 x i32> %tmp1, <4 x i32> %tmp2)
	ret <4 x i32> %tmp3
}

define void @testLowerToSRHADD8b(<8 x i8> %src1, <8 x i8> %src2, <8 x i8>* %dest) nounwind {
; CHECK-LABEL: testLowerToSRHADD8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    srhadd.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <8 x i8> %src1 to <8 x i16>
  %sextsrc2 = sext <8 x i8> %src2 to <8 x i16>
  %add1 = add <8 x i16> %sextsrc1, %sextsrc2
  %add2 = add <8 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %resulti16 = lshr <8 x i16> %add2, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %result = trunc <8 x i16> %resulti16 to <8 x i8>
  store <8 x i8> %result, <8 x i8>* %dest, align 8
  ret void
}

define void @testLowerToSRHADD4h(<4 x i16> %src1, <4 x i16> %src2, <4 x i16>* %dest) nounwind {
; CHECK-LABEL: testLowerToSRHADD4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    srhadd.4h v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <4 x i16> %src1 to <4 x i32>
  %sextsrc2 = sext <4 x i16> %src2 to <4 x i32>
  %add1 = add <4 x i32> %sextsrc1, %sextsrc2
  %add2 = add <4 x i32> %add1, <i32 1, i32 1, i32 1, i32 1>
  %resulti16 = lshr <4 x i32> %add2, <i32 1, i32 1, i32 1, i32 1>
  %result = trunc <4 x i32> %resulti16 to <4 x i16>
  store <4 x i16> %result, <4 x i16>* %dest, align 8
  ret void
}

define void @testLowerToSRHADD2s(<2 x i32> %src1, <2 x i32> %src2, <2 x i32>* %dest) nounwind {
; CHECK-LABEL: testLowerToSRHADD2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    srhadd.2s v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <2 x i32> %src1 to <2 x i64>
  %sextsrc2 = sext <2 x i32> %src2 to <2 x i64>
  %add1 = add <2 x i64> %sextsrc1, %sextsrc2
  %add2 = add <2 x i64> %add1, <i64 1, i64 1>
  %resulti16 = lshr <2 x i64> %add2, <i64 1, i64 1>
  %result = trunc <2 x i64> %resulti16 to <2 x i32>
  store <2 x i32> %result, <2 x i32>* %dest, align 8
  ret void
}

define void @testLowerToSRHADD16b(<16 x i8> %src1, <16 x i8> %src2, <16 x i8>* %dest) nounwind {
; CHECK-LABEL: testLowerToSRHADD16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    srhadd.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <16 x i8> %src1 to <16 x i16>
  %sextsrc2 = sext <16 x i8> %src2 to <16 x i16>
  %add1 = add <16 x i16> %sextsrc1, %sextsrc2
  %add2 = add <16 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %resulti16 = lshr <16 x i16> %add2, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %result = trunc <16 x i16> %resulti16 to <16 x i8>
  store <16 x i8> %result, <16 x i8>* %dest, align 16
  ret void
}

define void @testLowerToSRHADD8h(<8 x i16> %src1, <8 x i16> %src2, <8 x i16>* %dest) nounwind {
; CHECK-LABEL: testLowerToSRHADD8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    srhadd.8h v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <8 x i16> %src1 to <8 x i32>
  %sextsrc2 = sext <8 x i16> %src2 to <8 x i32>
  %add1 = add <8 x i32> %sextsrc1, %sextsrc2
  %add2 = add <8 x i32> %add1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %resulti16 = lshr <8 x i32> %add2, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %result = trunc <8 x i32> %resulti16 to <8 x i16>
  store <8 x i16> %result, <8 x i16>* %dest, align 16
  ret void
}

define void @testLowerToSRHADD4s(<4 x i32> %src1, <4 x i32> %src2, <4 x i32>* %dest) nounwind {
; CHECK-LABEL: testLowerToSRHADD4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    srhadd.4s v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <4 x i32> %src1 to <4 x i64>
  %sextsrc2 = sext <4 x i32> %src2 to <4 x i64>
  %add1 = add <4 x i64> %sextsrc1, %sextsrc2
  %add2 = add <4 x i64> %add1, <i64 1, i64 1, i64 1, i64 1>
  %resulti16 = lshr <4 x i64> %add2, <i64 1, i64 1, i64 1, i64 1>
  %result = trunc <4 x i64> %resulti16 to <4 x i32>
  store <4 x i32> %result, <4 x i32>* %dest, align 16
  ret void
}

define void @testLowerToSHADD8b(<8 x i8> %src1, <8 x i8> %src2, <8 x i8>* %dest) nounwind {
; CHECK-LABEL: testLowerToSHADD8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shadd.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <8 x i8> %src1 to <8 x i16>
  %sextsrc2 = sext <8 x i8> %src2 to <8 x i16>
  %add = add <8 x i16> %sextsrc1, %sextsrc2
  %resulti16 = lshr <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %result = trunc <8 x i16> %resulti16 to <8 x i8>
  store <8 x i8> %result, <8 x i8>* %dest, align 8
  ret void
}

define void @testLowerToSHADD4h(<4 x i16> %src1, <4 x i16> %src2, <4 x i16>* %dest) nounwind {
; CHECK-LABEL: testLowerToSHADD4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shadd.4h v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <4 x i16> %src1 to <4 x i32>
  %sextsrc2 = sext <4 x i16> %src2 to <4 x i32>
  %add = add <4 x i32> %sextsrc1, %sextsrc2
  %resulti16 = lshr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %result = trunc <4 x i32> %resulti16 to <4 x i16>
  store <4 x i16> %result, <4 x i16>* %dest, align 8
  ret void
}

define void @testLowerToSHADD2s(<2 x i32> %src1, <2 x i32> %src2, <2 x i32>* %dest) nounwind {
; CHECK-LABEL: testLowerToSHADD2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shadd.2s v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <2 x i32> %src1 to <2 x i64>
  %sextsrc2 = sext <2 x i32> %src2 to <2 x i64>
  %add = add <2 x i64> %sextsrc1, %sextsrc2
  %resulti16 = lshr <2 x i64> %add, <i64 1, i64 1>
  %result = trunc <2 x i64> %resulti16 to <2 x i32>
  store <2 x i32> %result, <2 x i32>* %dest, align 8
  ret void
}

define void @testLowerToSHADD16b(<16 x i8> %src1, <16 x i8> %src2, <16 x i8>* %dest) nounwind {
; CHECK-LABEL: testLowerToSHADD16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shadd.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <16 x i8> %src1 to <16 x i16>
  %sextsrc2 = sext <16 x i8> %src2 to <16 x i16>
  %add = add <16 x i16> %sextsrc1, %sextsrc2
  %resulti16 = lshr <16 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %result = trunc <16 x i16> %resulti16 to <16 x i8>
  store <16 x i8> %result, <16 x i8>* %dest, align 16
  ret void
}

define void @testLowerToSHADD8h(<8 x i16> %src1, <8 x i16> %src2, <8 x i16>* %dest) nounwind {
; CHECK-LABEL: testLowerToSHADD8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shadd.8h v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <8 x i16> %src1 to <8 x i32>
  %sextsrc2 = sext <8 x i16> %src2 to <8 x i32>
  %add = add <8 x i32> %sextsrc1, %sextsrc2
  %resulti16 = lshr <8 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %result = trunc <8 x i32> %resulti16 to <8 x i16>
  store <8 x i16> %result, <8 x i16>* %dest, align 16
  ret void
}

define void @testLowerToSHADD4s(<4 x i32> %src1, <4 x i32> %src2, <4 x i32>* %dest) nounwind {
; CHECK-LABEL: testLowerToSHADD4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shadd.4s v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %sextsrc1 = sext <4 x i32> %src1 to <4 x i64>
  %sextsrc2 = sext <4 x i32> %src2 to <4 x i64>
  %add = add <4 x i64> %sextsrc1, %sextsrc2
  %resulti16 = lshr <4 x i64> %add, <i64 1, i64 1, i64 1, i64 1>
  %result = trunc <4 x i64> %resulti16 to <4 x i32>
  store <4 x i32> %result, <4 x i32>* %dest, align 16
  ret void
}

define void @testLowerToURHADD8b(<8 x i8> %src1, <8 x i8> %src2, <8 x i8>* %dest) nounwind {
; CHECK-LABEL: testLowerToURHADD8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    urhadd.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <8 x i8> %src1 to <8 x i16>
  %zextsrc2 = zext <8 x i8> %src2 to <8 x i16>
  %add1 = add <8 x i16> %zextsrc1, %zextsrc2
  %add2 = add <8 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %resulti16 = lshr <8 x i16> %add2, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %result = trunc <8 x i16> %resulti16 to <8 x i8>
  store <8 x i8> %result, <8 x i8>* %dest, align 8
  ret void
}

define void @testLowerToURHADD4h(<4 x i16> %src1, <4 x i16> %src2, <4 x i16>* %dest) nounwind {
; CHECK-LABEL: testLowerToURHADD4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    urhadd.4h v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <4 x i16> %src1 to <4 x i32>
  %zextsrc2 = zext <4 x i16> %src2 to <4 x i32>
  %add1 = add <4 x i32> %zextsrc1, %zextsrc2
  %add2 = add <4 x i32> %add1, <i32 1, i32 1, i32 1, i32 1>
  %resulti16 = lshr <4 x i32> %add2, <i32 1, i32 1, i32 1, i32 1>
  %result = trunc <4 x i32> %resulti16 to <4 x i16>
  store <4 x i16> %result, <4 x i16>* %dest, align 8
  ret void
}

define void @testLowerToURHADD2s(<2 x i32> %src1, <2 x i32> %src2, <2 x i32>* %dest) nounwind {
; CHECK-LABEL: testLowerToURHADD2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    urhadd.2s v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <2 x i32> %src1 to <2 x i64>
  %zextsrc2 = zext <2 x i32> %src2 to <2 x i64>
  %add1 = add <2 x i64> %zextsrc1, %zextsrc2
  %add2 = add <2 x i64> %add1, <i64 1, i64 1>
  %resulti16 = lshr <2 x i64> %add2, <i64 1, i64 1>
  %result = trunc <2 x i64> %resulti16 to <2 x i32>
  store <2 x i32> %result, <2 x i32>* %dest, align 8
  ret void
}

define void @testLowerToURHADD16b(<16 x i8> %src1, <16 x i8> %src2, <16 x i8>* %dest) nounwind {
; CHECK-LABEL: testLowerToURHADD16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    urhadd.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <16 x i8> %src1 to <16 x i16>
  %zextsrc2 = zext <16 x i8> %src2 to <16 x i16>
  %add1 = add <16 x i16> %zextsrc1, %zextsrc2
  %add2 = add <16 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %resulti16 = lshr <16 x i16> %add2, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %result = trunc <16 x i16> %resulti16 to <16 x i8>
  store <16 x i8> %result, <16 x i8>* %dest, align 16
  ret void
}

define void @testLowerToURHADD8h(<8 x i16> %src1, <8 x i16> %src2, <8 x i16>* %dest) nounwind {
; CHECK-LABEL: testLowerToURHADD8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    urhadd.8h v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <8 x i16> %src1 to <8 x i32>
  %zextsrc2 = zext <8 x i16> %src2 to <8 x i32>
  %add1 = add <8 x i32> %zextsrc1, %zextsrc2
  %add2 = add <8 x i32> %add1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %resulti16 = lshr <8 x i32> %add2, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %result = trunc <8 x i32> %resulti16 to <8 x i16>
  store <8 x i16> %result, <8 x i16>* %dest, align 16
  ret void
}

define void @testLowerToURHADD4s(<4 x i32> %src1, <4 x i32> %src2, <4 x i32>* %dest) nounwind {
; CHECK-LABEL: testLowerToURHADD4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    urhadd.4s v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <4 x i32> %src1 to <4 x i64>
  %zextsrc2 = zext <4 x i32> %src2 to <4 x i64>
  %add1 = add <4 x i64> %zextsrc1, %zextsrc2
  %add2 = add <4 x i64> %add1, <i64 1, i64 1, i64 1, i64 1>
  %resulti16 = lshr <4 x i64> %add2, <i64 1, i64 1, i64 1, i64 1>
  %result = trunc <4 x i64> %resulti16 to <4 x i32>
  store <4 x i32> %result, <4 x i32>* %dest, align 16
  ret void
}

define void @testLowerToUHADD8b(<8 x i8> %src1, <8 x i8> %src2, <8 x i8>* %dest) nounwind {
; CHECK-LABEL: testLowerToUHADD8b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uhadd.8b v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <8 x i8> %src1 to <8 x i16>
  %zextsrc2 = zext <8 x i8> %src2 to <8 x i16>
  %add = add <8 x i16> %zextsrc1, %zextsrc2
  %resulti16 = lshr <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %result = trunc <8 x i16> %resulti16 to <8 x i8>
  store <8 x i8> %result, <8 x i8>* %dest, align 8
  ret void
}

define void @testLowerToUHADD4h(<4 x i16> %src1, <4 x i16> %src2, <4 x i16>* %dest) nounwind {
; CHECK-LABEL: testLowerToUHADD4h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uhadd.4h v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <4 x i16> %src1 to <4 x i32>
  %zextsrc2 = zext <4 x i16> %src2 to <4 x i32>
  %add = add <4 x i32> %zextsrc1, %zextsrc2
  %resulti16 = lshr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %result = trunc <4 x i32> %resulti16 to <4 x i16>
  store <4 x i16> %result, <4 x i16>* %dest, align 8
  ret void
}

define void @testLowerToUHADD2s(<2 x i32> %src1, <2 x i32> %src2, <2 x i32>* %dest) nounwind {
; CHECK-LABEL: testLowerToUHADD2s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uhadd.2s v0, v0, v1
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <2 x i32> %src1 to <2 x i64>
  %zextsrc2 = zext <2 x i32> %src2 to <2 x i64>
  %add = add <2 x i64> %zextsrc1, %zextsrc2
  %resulti16 = lshr <2 x i64> %add, <i64 1, i64 1>
  %result = trunc <2 x i64> %resulti16 to <2 x i32>
  store <2 x i32> %result, <2 x i32>* %dest, align 8
  ret void
}

define void @testLowerToUHADD16b(<16 x i8> %src1, <16 x i8> %src2, <16 x i8>* %dest) nounwind {
; CHECK-LABEL: testLowerToUHADD16b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uhadd.16b v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <16 x i8> %src1 to <16 x i16>
  %zextsrc2 = zext <16 x i8> %src2 to <16 x i16>
  %add = add <16 x i16> %zextsrc1, %zextsrc2
  %resulti16 = lshr <16 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %result = trunc <16 x i16> %resulti16 to <16 x i8>
  store <16 x i8> %result, <16 x i8>* %dest, align 16
  ret void
}

define void @testLowerToUHADD8h(<8 x i16> %src1, <8 x i16> %src2, <8 x i16>* %dest) nounwind {
; CHECK-LABEL: testLowerToUHADD8h:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uhadd.8h v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <8 x i16> %src1 to <8 x i32>
  %zextsrc2 = zext <8 x i16> %src2 to <8 x i32>
  %add = add <8 x i32> %zextsrc1, %zextsrc2
  %resulti16 = lshr <8 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %result = trunc <8 x i32> %resulti16 to <8 x i16>
  store <8 x i16> %result, <8 x i16>* %dest, align 16
  ret void
}

define void @testLowerToUHADD4s(<4 x i32> %src1, <4 x i32> %src2, <4 x i32>* %dest) nounwind {
; CHECK-LABEL: testLowerToUHADD4s:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uhadd.4s v0, v0, v1
; CHECK-NEXT:    str q0, [x0]
; CHECK-NEXT:    ret
  %zextsrc1 = zext <4 x i32> %src1 to <4 x i64>
  %zextsrc2 = zext <4 x i32> %src2 to <4 x i64>
  %add = add <4 x i64> %zextsrc1, %zextsrc2
  %resulti16 = lshr <4 x i64> %add, <i64 1, i64 1, i64 1, i64 1>
  %result = trunc <4 x i64> %resulti16 to <4 x i32>
  store <4 x i32> %result, <4 x i32>* %dest, align 16
  ret void
}


define <4 x i32> @hadd16_sext_asr(<4 x i16> %src1, <4 x i16> %src2) nounwind {
; CHECK-LABEL: hadd16_sext_asr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    saddl.4s v0, v0, v1
; CHECK-NEXT:    sshr.4s v0, v0, #1
; CHECK-NEXT:    ret
  %zextsrc1 = sext <4 x i16> %src1 to <4 x i32>
  %zextsrc2 = sext <4 x i16> %src2 to <4 x i32>
  %add = add <4 x i32> %zextsrc1, %zextsrc2
  %resulti16 = ashr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %resulti16
}

define <4 x i32> @hadd16_zext_asr(<4 x i16> %src1, <4 x i16> %src2) nounwind {
; CHECK-LABEL: hadd16_zext_asr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uaddl.4s v0, v0, v1
; CHECK-NEXT:    ushr.4s v0, v0, #1
; CHECK-NEXT:    ret
  %zextsrc1 = zext <4 x i16> %src1 to <4 x i32>
  %zextsrc2 = zext <4 x i16> %src2 to <4 x i32>
  %add = add <4 x i32> %zextsrc1, %zextsrc2
  %resulti16 = ashr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %resulti16
}

define <4 x i32> @hadd16_sext_lsr(<4 x i16> %src1, <4 x i16> %src2) nounwind {
; CHECK-LABEL: hadd16_sext_lsr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    saddl.4s v0, v0, v1
; CHECK-NEXT:    ushr.4s v0, v0, #1
; CHECK-NEXT:    ret
  %zextsrc1 = sext <4 x i16> %src1 to <4 x i32>
  %zextsrc2 = sext <4 x i16> %src2 to <4 x i32>
  %add = add <4 x i32> %zextsrc1, %zextsrc2
  %resulti16 = lshr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %resulti16
}

define <4 x i32> @hadd16_zext_lsr(<4 x i16> %src1, <4 x i16> %src2) nounwind {
; CHECK-LABEL: hadd16_zext_lsr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uaddl.4s v0, v0, v1
; CHECK-NEXT:    ushr.4s v0, v0, #1
; CHECK-NEXT:    ret
  %zextsrc1 = zext <4 x i16> %src1 to <4 x i32>
  %zextsrc2 = zext <4 x i16> %src2 to <4 x i32>
  %add = add <4 x i32> %zextsrc1, %zextsrc2
  %resulti16 = lshr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %resulti16
}



define <4 x i64> @hadd32_sext_asr(<4 x i32> %src1, <4 x i32> %src2) nounwind {
; CHECK-LABEL: hadd32_sext_asr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    saddl.2d v2, v0, v1
; CHECK-NEXT:    saddl2.2d v0, v0, v1
; CHECK-NEXT:    sshr.2d v1, v0, #1
; CHECK-NEXT:    sshr.2d v0, v2, #1
; CHECK-NEXT:    ret
  %zextsrc1 = sext <4 x i32> %src1 to <4 x i64>
  %zextsrc2 = sext <4 x i32> %src2 to <4 x i64>
  %add = add <4 x i64> %zextsrc1, %zextsrc2
  %resulti32 = ashr <4 x i64> %add, <i64 1, i64 1, i64 1, i64 1>
  ret <4 x i64> %resulti32
}

define <4 x i64> @hadd32_zext_asr(<4 x i32> %src1, <4 x i32> %src2) nounwind {
; CHECK-LABEL: hadd32_zext_asr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uaddl.2d v2, v0, v1
; CHECK-NEXT:    uaddl2.2d v0, v0, v1
; CHECK-NEXT:    ushr.2d v1, v0, #1
; CHECK-NEXT:    ushr.2d v0, v2, #1
; CHECK-NEXT:    ret
  %zextsrc1 = zext <4 x i32> %src1 to <4 x i64>
  %zextsrc2 = zext <4 x i32> %src2 to <4 x i64>
  %add = add <4 x i64> %zextsrc1, %zextsrc2
  %resulti32 = ashr <4 x i64> %add, <i64 1, i64 1, i64 1, i64 1>
  ret <4 x i64> %resulti32
}

define <4 x i64> @hadd32_sext_lsr(<4 x i32> %src1, <4 x i32> %src2) nounwind {
; CHECK-LABEL: hadd32_sext_lsr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    saddl.2d v2, v0, v1
; CHECK-NEXT:    saddl2.2d v0, v0, v1
; CHECK-NEXT:    ushr.2d v1, v0, #1
; CHECK-NEXT:    ushr.2d v0, v2, #1
; CHECK-NEXT:    ret
  %zextsrc1 = sext <4 x i32> %src1 to <4 x i64>
  %zextsrc2 = sext <4 x i32> %src2 to <4 x i64>
  %add = add <4 x i64> %zextsrc1, %zextsrc2
  %resulti32 = lshr <4 x i64> %add, <i64 1, i64 1, i64 1, i64 1>
  ret <4 x i64> %resulti32
}

define <4 x i64> @hadd32_zext_lsr(<4 x i32> %src1, <4 x i32> %src2) nounwind {
; CHECK-LABEL: hadd32_zext_lsr:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uaddl.2d v2, v0, v1
; CHECK-NEXT:    uaddl2.2d v0, v0, v1
; CHECK-NEXT:    ushr.2d v1, v0, #1
; CHECK-NEXT:    ushr.2d v0, v2, #1
; CHECK-NEXT:    ret
  %zextsrc1 = zext <4 x i32> %src1 to <4 x i64>
  %zextsrc2 = zext <4 x i32> %src2 to <4 x i64>
  %add = add <4 x i64> %zextsrc1, %zextsrc2
  %resulti32 = lshr <4 x i64> %add, <i64 1, i64 1, i64 1, i64 1>
  ret <4 x i64> %resulti32
}


declare <8 x i8>  @llvm.aarch64.neon.srhadd.v8i8(<8 x i8>, <8 x i8>) nounwind readnone
declare <4 x i16> @llvm.aarch64.neon.srhadd.v4i16(<4 x i16>, <4 x i16>) nounwind readnone
declare <2 x i32> @llvm.aarch64.neon.srhadd.v2i32(<2 x i32>, <2 x i32>) nounwind readnone

declare <8 x i8>  @llvm.aarch64.neon.urhadd.v8i8(<8 x i8>, <8 x i8>) nounwind readnone
declare <4 x i16> @llvm.aarch64.neon.urhadd.v4i16(<4 x i16>, <4 x i16>) nounwind readnone
declare <2 x i32> @llvm.aarch64.neon.urhadd.v2i32(<2 x i32>, <2 x i32>) nounwind readnone

declare <16 x i8> @llvm.aarch64.neon.srhadd.v16i8(<16 x i8>, <16 x i8>) nounwind readnone
declare <8 x i16> @llvm.aarch64.neon.srhadd.v8i16(<8 x i16>, <8 x i16>) nounwind readnone
declare <4 x i32> @llvm.aarch64.neon.srhadd.v4i32(<4 x i32>, <4 x i32>) nounwind readnone

declare <16 x i8> @llvm.aarch64.neon.urhadd.v16i8(<16 x i8>, <16 x i8>) nounwind readnone
declare <8 x i16> @llvm.aarch64.neon.urhadd.v8i16(<8 x i16>, <8 x i16>) nounwind readnone
declare <4 x i32> @llvm.aarch64.neon.urhadd.v4i32(<4 x i32>, <4 x i32>) nounwind readnone
