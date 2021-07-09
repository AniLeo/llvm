; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-apple-darwin10 -mattr=+avx | FileCheck %s

define <2 x float> @cvt_v2i8_v2f32(<2 x i8> %src) {
; CHECK-LABEL: cvt_v2i8_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpmovsxbd %xmm0, %xmm0
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = sitofp <2 x i8> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2i16_v2f32(<2 x i16> %src) {
; CHECK-LABEL: cvt_v2i16_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpmovsxwd %xmm0, %xmm0
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = sitofp <2 x i16> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2i32_v2f32(<2 x i32> %src) {
; CHECK-LABEL: cvt_v2i32_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = sitofp <2 x i32> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2u8_v2f32(<2 x i8> %src) {
; CHECK-LABEL: cvt_v2u8_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpmovzxbd {{.*#+}} xmm0 = xmm0[0],zero,zero,zero,xmm0[1],zero,zero,zero,xmm0[2],zero,zero,zero,xmm0[3],zero,zero,zero
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = uitofp <2 x i8> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2u16_v2f32(<2 x i16> %src) {
; CHECK-LABEL: cvt_v2u16_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpmovzxwd {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero
; CHECK-NEXT:    vcvtdq2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = uitofp <2 x i16> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x float> @cvt_v2u32_v2f32(<2 x i32> %src) {
; CHECK-LABEL: cvt_v2u32_v2f32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpmovzxdq {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero
; CHECK-NEXT:    vmovdqa {{.*#+}} xmm1 = [4.503599627370496E+15,4.503599627370496E+15]
; CHECK-NEXT:    vpor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vsubpd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vcvtpd2ps %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = uitofp <2 x i32> %src to <2 x float>
  ret <2 x float> %res
}

define <2 x i8> @cvt_v2f32_v2i8(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2i8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    vpackssdw %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vpacksswb %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = fptosi <2 x float> %src to <2 x i8>
  ret <2 x i8> %res
}

define <2 x i16> @cvt_v2f32_v2i16(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    vpackssdw %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = fptosi <2 x float> %src to <2 x i16>
  ret <2 x i16> %res
}

define <2 x i32> @cvt_v2f32_v2i32(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = fptosi <2 x float> %src to <2 x i32>
  ret <2 x i32> %res
}

define <2 x i8> @cvt_v2f32_v2u8(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2u8:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    vpackusdw %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vpackuswb %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = fptoui <2 x float> %src to <2 x i8>
  ret <2 x i8> %res
}

define <2 x i16> @cvt_v2f32_v2u16(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2u16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    vpackusdw %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    retl
  %res = fptoui <2 x float> %src to <2 x i16>
  ret <2 x i16> %res
}

define <2 x i32> @cvt_v2f32_v2u32(<2 x float> %src) {
; CHECK-LABEL: cvt_v2f32_v2u32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovaps {{.*#+}} xmm1 = [2.14748365E+9,2.14748365E+9,2.14748365E+9,2.14748365E+9]
; CHECK-NEXT:    vcmpltps %xmm1, %xmm0, %xmm2
; CHECK-NEXT:    vsubps %xmm1, %xmm0, %xmm1
; CHECK-NEXT:    vcvttps2dq %xmm1, %xmm1
; CHECK-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}, %xmm1, %xmm1
; CHECK-NEXT:    vcvttps2dq %xmm0, %xmm0
; CHECK-NEXT:    vblendvps %xmm2, %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retl
  %res = fptoui <2 x float> %src to <2 x i32>
  ret <2 x i32> %res
}

define <32 x i8> @PR40146(<4 x i64> %x) {
; CHECK-LABEL: PR40146:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpunpckhbw {{.*#+}} xmm1 = xmm0[8],xmm1[8],xmm0[9],xmm1[9],xmm0[10],xmm1[10],xmm0[11],xmm1[11],xmm0[12],xmm1[12],xmm0[13],xmm1[13],xmm0[14],xmm1[14],xmm0[15],xmm1[15]
; CHECK-NEXT:    vpmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    retl
  %perm = shufflevector <4 x i64> %x, <4 x i64> undef, <4 x i32> <i32 0, i32 undef, i32 1, i32 undef>
  %t1 = bitcast <4 x i64> %perm to <32 x i8>
  %t2 = shufflevector <32 x i8> %t1, <32 x i8> <i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>, <32 x i32> <i32 0, i32 32, i32 1, i32 32, i32 2, i32 32, i32 3, i32 32, i32 4, i32 32, i32 5, i32 32, i32 6, i32 32, i32 7, i32 32, i32 16, i32 48, i32 17, i32 48, i32 18, i32 48, i32 19, i32 48, i32 20, i32 48, i32 21, i32 48, i32 22, i32 48, i32 23, i32 48>
  ret <32 x i8> %t2
}

