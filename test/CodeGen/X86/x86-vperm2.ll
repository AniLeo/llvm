; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-apple-darwin -mattr=avx2 -show-mc-encoding | FileCheck %s --check-prefix=CHECK --check-prefix=AVX2

; Test cases derived from the possible immediate values of the vperm2f128 intrinsics.

define <4 x double> @perm2pd_0x00(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x00:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $0, %ymm0, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc0,0x00]
; CHECK-NEXT:    ## ymm0 = ymm0[0,1,0,1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a0, <4 x double> %a0, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x01(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x01:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $1, %ymm0, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc0,0x01]
; CHECK-NEXT:    ## ymm0 = ymm0[2,3,0,1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a0, <4 x double> %a0, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x02(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x02:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0 ## encoding: [0xc4,0xe3,0x75,0x18,0xc0,0x01]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a1, <4 x double> %a0, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x03(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x03:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $33, %ymm0, %ymm1, %ymm0 ## encoding: [0xc4,0xe3,0x75,0x06,0xc0,0x21]
; CHECK-NEXT:    ## ymm0 = ymm1[2,3],ymm0[0,1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a1, <4 x double> %a0, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x10(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x10:
; CHECK:       ## BB#0:
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a0, <4 x double> %a0, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x11(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x11:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $17, %ymm0, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc0,0x11]
; CHECK-NEXT:    ## ymm0 = ymm0[2,3,2,3]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a0, <4 x double> %a0, <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x12(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x12:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vblendpd $12, %ymm0, %ymm1, %ymm0 ## encoding: [0xc4,0xe3,0x75,0x0d,0xc0,0x0c]
; CHECK-NEXT:    ## ymm0 = ymm1[0,1],ymm0[2,3]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a1, <4 x double> %a0, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x13(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x13:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $49, %ymm0, %ymm1, %ymm0 ## encoding: [0xc4,0xe3,0x75,0x06,0xc0,0x31]
; CHECK-NEXT:    ## ymm0 = ymm1[2,3],ymm0[2,3]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a1, <4 x double> %a0, <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x20(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x20:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x18,0xc1,0x01]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a0, <4 x double> %a1, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x21(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x21:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $33, %ymm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc1,0x21]
; CHECK-NEXT:    ## ymm0 = ymm0[2,3],ymm1[0,1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a0, <4 x double> %a1, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x22(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x22:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $0, %ymm0, %ymm1, %ymm0 ## encoding: [0xc4,0xe3,0x75,0x06,0xc0,0x00]
; CHECK-NEXT:    ## ymm0 = ymm1[0,1,0,1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a1, <4 x double> %a1, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x23(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x23:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $1, %ymm0, %ymm1, %ymm0 ## encoding: [0xc4,0xe3,0x75,0x06,0xc0,0x01]
; CHECK-NEXT:    ## ymm0 = ymm1[2,3,0,1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a1, <4 x double> %a1, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x30(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x30:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vblendpd $12, %ymm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x0d,0xc1,0x0c]
; CHECK-NEXT:    ## ymm0 = ymm0[0,1],ymm1[2,3]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a0, <4 x double> %a1, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x31(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x31:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $49, %ymm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc1,0x31]
; CHECK-NEXT:    ## ymm0 = ymm0[2,3],ymm1[2,3]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a0, <4 x double> %a1, <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x32(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x32:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vmovaps %ymm1, %ymm0 ## encoding: [0xc5,0xfc,0x28,0xc1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a1, <4 x double> %a1, <4 x i32> <i32 0, i32 1, i32 6, i32 7>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x33(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x33:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $17, %ymm0, %ymm1, %ymm0 ## encoding: [0xc4,0xe3,0x75,0x06,0xc0,0x11]
; CHECK-NEXT:    ## ymm0 = ymm1[2,3,2,3]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a1, <4 x double> %a1, <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  ret <4 x double> %1
}

define <8 x float> @perm2ps_0x31(<8 x float> %a0, <8 x float> %a1) {
; CHECK-LABEL: perm2ps_0x31:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $49, %ymm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc1,0x31]
; CHECK-NEXT:    ## ymm0 = ymm0[2,3],ymm1[2,3]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <8 x float> %a0, <8 x float> %a1, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 12, i32 13, i32 14, i32 15>
  ret <8 x float> %1
}

define <4 x i64> @perm2i_0x33(<4 x i64> %a0, <4 x i64> %a1) {
; CHECK-LABEL: perm2i_0x33:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $17, %ymm0, %ymm1, %ymm0 ## encoding: [0xc4,0xe3,0x75,0x06,0xc0,0x11]
; CHECK-NEXT:    ## ymm0 = ymm1[2,3,2,3]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x i64> %a1, <4 x i64> %a1, <4 x i32> <i32 2, i32 3, i32 6, i32 7>
  ret <4 x i64> %1
}

define <4 x double> @perm2pd_0x81(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x81:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $129, %ymm0, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc0,0x81]
; CHECK-NEXT:    ## ymm0 = ymm0[2,3],zero,zero
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a0, <4 x double> zeroinitializer, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x83(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x83:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $129, %ymm0, %ymm1, %ymm0 ## encoding: [0xc4,0xe3,0x75,0x06,0xc0,0x81]
; CHECK-NEXT:    ## ymm0 = ymm1[2,3],zero,zero
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> %a1, <4 x double> zeroinitializer, <4 x i32> <i32 2, i32 3, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x28(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x28:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $40, %ymm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc1,0x28]
; CHECK-NEXT:    ## ymm0 = zero,zero,ymm1[0,1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> zeroinitializer, <4 x double> %a1, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x double> @perm2pd_0x08(<4 x double> %a0, <4 x double> %a1) {
; CHECK-LABEL: perm2pd_0x08:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $40, %ymm0, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc0,0x28]
; CHECK-NEXT:    ## ymm0 = zero,zero,ymm0[0,1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x double> zeroinitializer, <4 x double> %a0, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x double> %1
}

define <4 x i64> @perm2i_0x28(<4 x i64> %a0, <4 x i64> %a1) {
; CHECK-LABEL: perm2i_0x28:
; CHECK:       ## BB#0:
; CHECK-NEXT:    vperm2f128 $40, %ymm1, %ymm0, %ymm0 ## encoding: [0xc4,0xe3,0x7d,0x06,0xc1,0x28]
; CHECK-NEXT:    ## ymm0 = zero,zero,ymm1[0,1]
; CHECK-NEXT:    retl ## encoding: [0xc3]
  %1 = shufflevector <4 x i64> zeroinitializer, <4 x i64> %a1, <4 x i32> <i32 0, i32 1, i32 4, i32 5>
  ret <4 x i64> %1
}
