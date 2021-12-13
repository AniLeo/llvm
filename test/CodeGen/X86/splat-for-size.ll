; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=CHECK --check-prefix=AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=CHECK --check-prefix=AVX2

; Check constant loads of every 128-bit and 256-bit vector type
; for size optimization using splat ops available with AVX and AVX2.

; There is no AVX broadcast from double to 128-bit vector because movddup has been around since SSE3 (grrr).
define <2 x double> @splat_v2f64(<2 x double> %x) #0 {
; CHECK-LABEL: splat_v2f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovddup {{.*#+}} xmm1 = [1.0E+0,1.0E+0]
; CHECK-NEXT:    # xmm1 = mem[0,0]
; CHECK-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %add = fadd <2 x double> %x, <double 1.0, double 1.0>
  ret <2 x double> %add
}

define <2 x double> @splat_v2f64_pgso(<2 x double> %x) !prof !14 {
; CHECK-LABEL: splat_v2f64_pgso:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmovddup {{.*#+}} xmm1 = [1.0E+0,1.0E+0]
; CHECK-NEXT:    # xmm1 = mem[0,0]
; CHECK-NEXT:    vaddpd %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %add = fadd <2 x double> %x, <double 1.0, double 1.0>
  ret <2 x double> %add
}

define <4 x double> @splat_v4f64(<4 x double> %x) #1 {
; CHECK-LABEL: splat_v4f64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcastsd {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; CHECK-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %add = fadd <4 x double> %x, <double 1.0, double 1.0, double 1.0, double 1.0>
  ret <4 x double> %add
}

define <4 x double> @splat_v4f64_pgso(<4 x double> %x) !prof !14 {
; CHECK-LABEL: splat_v4f64_pgso:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcastsd {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; CHECK-NEXT:    vaddpd %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %add = fadd <4 x double> %x, <double 1.0, double 1.0, double 1.0, double 1.0>
  ret <4 x double> %add
}

define <4 x float> @splat_v4f32(<4 x float> %x) #0 {
; CHECK-LABEL: splat_v4f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcastss {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; CHECK-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %add = fadd <4 x float> %x, <float 1.0, float 1.0, float 1.0, float 1.0>
  ret <4 x float> %add
}

define <4 x float> @splat_v4f32_pgso(<4 x float> %x) !prof !14 {
; CHECK-LABEL: splat_v4f32_pgso:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcastss {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; CHECK-NEXT:    vaddps %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %add = fadd <4 x float> %x, <float 1.0, float 1.0, float 1.0, float 1.0>
  ret <4 x float> %add
}

define <8 x float> @splat_v8f32(<8 x float> %x) #1 {
; CHECK-LABEL: splat_v8f32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcastss {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; CHECK-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %add = fadd <8 x float> %x, <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>
  ret <8 x float> %add
}

define <8 x float> @splat_v8f32_pgso(<8 x float> %x) !prof !14 {
; CHECK-LABEL: splat_v8f32_pgso:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vbroadcastss {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; CHECK-NEXT:    vaddps %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %add = fadd <8 x float> %x, <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>
  ret <8 x float> %add
}

; AVX can't do integer splats, so fake it: use vmovddup to splat 64-bit value.
; We also generate vmovddup for AVX2 because it's one byte smaller than vpbroadcastq.
define <2 x i64> @splat_v2i64(<2 x i64> %x) #1 {
; AVX-LABEL: splat_v2i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} xmm1 = [2,2]
; AVX-NEXT:    # xmm1 = mem[0,0]
; AVX-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v2i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastq {{.*#+}} xmm1 = [2,2]
; AVX2-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %add = add <2 x i64> %x, <i64 2, i64 2>
  ret <2 x i64> %add
}

define <2 x i64> @splat_v2i64_pgso(<2 x i64> %x) !prof !14 {
; AVX-LABEL: splat_v2i64_pgso:
; AVX:       # %bb.0:
; AVX-NEXT:    vmovddup {{.*#+}} xmm1 = [2,2]
; AVX-NEXT:    # xmm1 = mem[0,0]
; AVX-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v2i64_pgso:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastq {{.*#+}} xmm1 = [2,2]
; AVX2-NEXT:    vpaddq %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %add = add <2 x i64> %x, <i64 2, i64 2>
  ret <2 x i64> %add
}

; AVX can't do 256-bit integer ops, so we split this into two 128-bit vectors,
; and then we fake it: use vmovddup to splat 64-bit value.
define <4 x i64> @splat_v4i64(<4 x i64> %x) #0 {
; AVX-LABEL: splat_v4i64:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vmovddup {{.*#+}} xmm2 = [2,2]
; AVX-NEXT:    # xmm2 = mem[0,0]
; AVX-NEXT:    vpaddq %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpaddq %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v4i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastq {{.*#+}} ymm1 = [2,2,2,2]
; AVX2-NEXT:    vpaddq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %add = add <4 x i64> %x, <i64 2, i64 2, i64 2, i64 2>
  ret <4 x i64> %add
}

define <4 x i64> @splat_v4i64_pgso(<4 x i64> %x) !prof !14 {
; AVX-LABEL: splat_v4i64_pgso:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vmovddup {{.*#+}} xmm2 = [2,2]
; AVX-NEXT:    # xmm2 = mem[0,0]
; AVX-NEXT:    vpaddq %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpaddq %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v4i64_pgso:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastq {{.*#+}} ymm1 = [2,2,2,2]
; AVX2-NEXT:    vpaddq %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %add = add <4 x i64> %x, <i64 2, i64 2, i64 2, i64 2>
  ret <4 x i64> %add
}

; AVX can't do integer splats, so fake it: use vbroadcastss to splat 32-bit value.
define <4 x i32> @splat_v4i32(<4 x i32> %x) #1 {
; AVX-LABEL: splat_v4i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm1 = [2,2,2,2]
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v4i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [2,2,2,2]
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %add = add <4 x i32> %x, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %add
}

define <4 x i32> @splat_v4i32_pgso(<4 x i32> %x) !prof !14 {
; AVX-LABEL: splat_v4i32_pgso:
; AVX:       # %bb.0:
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm1 = [2,2,2,2]
; AVX-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v4i32_pgso:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} xmm1 = [2,2,2,2]
; AVX2-NEXT:    vpaddd %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %add = add <4 x i32> %x, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %add
}

; AVX can't do integer splats, so fake it: use vbroadcastss to splat 32-bit value.
define <8 x i32> @splat_v8i32(<8 x i32> %x) #0 {
; AVX-LABEL: splat_v8i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [2,2,2,2]
; AVX-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpaddd %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} ymm1 = [2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %add = add <8 x i32> %x, <i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2>
  ret <8 x i32> %add
}

define <8 x i32> @splat_v8i32_pgso(<8 x i32> %x) !prof !14 {
; AVX-LABEL: splat_v8i32_pgso:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vbroadcastss {{.*#+}} xmm2 = [2,2,2,2]
; AVX-NEXT:    vpaddd %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpaddd %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v8i32_pgso:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastd {{.*#+}} ymm1 = [2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddd %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %add = add <8 x i32> %x, <i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2, i32 2>
  ret <8 x i32> %add
}

; AVX can't do integer splats, and there's no broadcast fakery for 16-bit. Could use pshuflw, etc?
define <8 x i16> @splat_v8i16(<8 x i16> %x) #1 {
; AVX-LABEL: splat_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v8i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastw {{.*#+}} xmm1 = [2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %add = add <8 x i16> %x, <i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2>
  ret <8 x i16> %add
}

define <8 x i16> @splat_v8i16_pgso(<8 x i16> %x) !prof !14 {
; AVX-LABEL: splat_v8i16_pgso:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddw {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v8i16_pgso:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastw {{.*#+}} xmm1 = [2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %add = add <8 x i16> %x, <i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2>
  ret <8 x i16> %add
}

; AVX can't do integer splats, and there's no broadcast fakery for 16-bit. Could use pshuflw, etc?
define <16 x i16> @splat_v16i16(<16 x i16> %x) #0 {
; AVX-LABEL: splat_v16i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [2,2,2,2,2,2,2,2]
; AVX-NEXT:    vpaddw %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpaddw %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v16i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastw {{.*#+}} ymm1 = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %add = add <16 x i16> %x, <i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2>
  ret <16 x i16> %add
}

define <16 x i16> @splat_v16i16_pgso(<16 x i16> %x) !prof !14 {
; AVX-LABEL: splat_v16i16_pgso:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [2,2,2,2,2,2,2,2]
; AVX-NEXT:    vpaddw %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpaddw %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v16i16_pgso:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastw {{.*#+}} ymm1 = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddw %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %add = add <16 x i16> %x, <i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2, i16 2>
  ret <16 x i16> %add
}

; AVX can't do integer splats, and there's no broadcast fakery for 8-bit. Could use pshufb, etc?
define <16 x i8> @splat_v16i8(<16 x i8> %x) #1 {
; AVX-LABEL: splat_v16i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v16i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastb {{.*#+}} xmm1 = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %add = add <16 x i8> %x, <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>
  ret <16 x i8> %add
}

define <16 x i8> @splat_v16i8_pgso(<16 x i8> %x) !prof !14 {
; AVX-LABEL: splat_v16i8_pgso:
; AVX:       # %bb.0:
; AVX-NEXT:    vpaddb {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v16i8_pgso:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastb {{.*#+}} xmm1 = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %add = add <16 x i8> %x, <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>
  ret <16 x i8> %add
}

; AVX can't do integer splats, and there's no broadcast fakery for 8-bit. Could use pshufb, etc?
define <32 x i8> @splat_v32i8(<32 x i8> %x) #0 {
; AVX-LABEL: splat_v32i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
; AVX-NEXT:    vpaddb %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpaddb %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v32i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastb {{.*#+}} ymm1 = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %add = add <32 x i8> %x, <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>
  ret <32 x i8> %add
}

define <32 x i8> @splat_v32i8_pgso(<32 x i8> %x) !prof !14 {
; AVX-LABEL: splat_v32i8_pgso:
; AVX:       # %bb.0:
; AVX-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX-NEXT:    vmovdqa {{.*#+}} xmm2 = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
; AVX-NEXT:    vpaddb %xmm2, %xmm1, %xmm1
; AVX-NEXT:    vpaddb %xmm2, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; AVX2-LABEL: splat_v32i8_pgso:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpbroadcastb {{.*#+}} ymm1 = [2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2]
; AVX2-NEXT:    vpaddb %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
  %add = add <32 x i8> %x, <i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2, i8 2>
  ret <32 x i8> %add
}

; PR23259: Verify that ISel doesn't crash with a 'fatal error in backend'
; due to a missing AVX pattern to select a v2i64 X86ISD::BROADCAST of a
; loadi64 with multiple uses.

@A = common dso_local global <3 x i64> zeroinitializer, align 32

define <8 x i64> @pr23259() #1 {
; CHECK-LABEL: pr23259:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovaps A+16(%rip), %xmm0
; CHECK-NEXT:    vblendps {{.*#+}} xmm0 = xmm0[0,1],mem[2,3]
; CHECK-NEXT:    vblendps {{.*#+}} ymm0 = ymm0[0,1,2,3],mem[4,5,6,7]
; CHECK-NEXT:    vbroadcastsd {{.*#+}} ymm1 = [1,1,1,1]
; CHECK-NEXT:    retq
entry:
  %0 = load <4 x i64>, <4 x i64>* bitcast (<3 x i64>* @A to <4 x i64>*), align 32
  %1 = shufflevector <4 x i64> %0, <4 x i64> undef, <3 x i32> <i32 undef, i32 undef, i32 2>
  %shuffle = shufflevector <3 x i64> <i64 1, i64 undef, i64 undef>, <3 x i64> %1, <8 x i32> <i32 5, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0>
  ret <8 x i64> %shuffle
}

attributes #0 = { nounwind optsize }
attributes #1 = { nounwind minsize }

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"ProfileSummary", !1}
!1 = !{!2, !3, !4, !5, !6, !7, !8, !9}
!2 = !{!"ProfileFormat", !"InstrProf"}
!3 = !{!"TotalCount", i64 10000}
!4 = !{!"MaxCount", i64 10}
!5 = !{!"MaxInternalCount", i64 1}
!6 = !{!"MaxFunctionCount", i64 1000}
!7 = !{!"NumCounts", i64 3}
!8 = !{!"NumFunctions", i64 3}
!9 = !{!"DetailedSummary", !10}
!10 = !{!11, !12, !13}
!11 = !{i32 10000, i64 100, i32 1}
!12 = !{i32 999000, i64 100, i32 1}
!13 = !{i32 999999, i64 1, i32 2}
!14 = !{!"function_entry_count", i64 0}
