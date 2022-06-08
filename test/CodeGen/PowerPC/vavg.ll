; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr9 < %s | FileCheck -check-prefix=CHECK-P9 %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr8 < %s | FileCheck -check-prefix=CHECK-P8 %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -mcpu=pwr7 < %s | FileCheck -check-prefix=CHECK-P7 %s
define <8 x i16> @test_v8i16(<8 x i16> %m, <8 x i16> %n) {
; CHECK-P9-LABEL: test_v8i16:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vavguh 2, 3, 2
; CHECK-P9-NEXT:    blr
;
; CHECK-P8-LABEL: test_v8i16:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vavguh 2, 3, 2
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: test_v8i16:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    vavguh 2, 3, 2
; CHECK-P7-NEXT:    blr
entry:
  %add = add <8 x i16> %m, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %add1 = add <8 x i16> %add, %n
  %shr = lshr <8 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %shr
}

define <8 x i16> @test_v8i16_sign(<8 x i16> %m, <8 x i16> %n) {
; CHECK-P9-LABEL: test_v8i16_sign:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vavgsh 2, 3, 2
; CHECK-P9-NEXT:    blr
;
; CHECK-P8-LABEL: test_v8i16_sign:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vavgsh 2, 3, 2
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: test_v8i16_sign:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    vavgsh 2, 3, 2
; CHECK-P7-NEXT:    blr
entry:
  %add = add <8 x i16> %m, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %add1 = add <8 x i16> %add, %n
  %shr = ashr <8 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %shr
}

define <4 x i32> @test_v4i32(<4 x i32> %m, <4 x i32> %n) {
; CHECK-P9-LABEL: test_v4i32:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vavguw 2, 3, 2
; CHECK-P9-NEXT:    blr
;
; CHECK-P8-LABEL: test_v4i32:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vavguw 2, 3, 2
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: test_v4i32:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    vavguw 2, 3, 2
; CHECK-P7-NEXT:    blr
entry:
  %add = add <4 x i32> %m, <i32 1, i32 1, i32 1, i32 1>
  %add1 = add <4 x i32> %add, %n
  %shr = lshr <4 x i32> %add1, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %shr
}

define <4 x i32> @test_v4i32_sign(<4 x i32> %m, <4 x i32> %n) {
; CHECK-P9-LABEL: test_v4i32_sign:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vavgsw 2, 3, 2
; CHECK-P9-NEXT:    blr
;
; CHECK-P8-LABEL: test_v4i32_sign:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vavgsw 2, 3, 2
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: test_v4i32_sign:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    vavgsw 2, 3, 2
; CHECK-P7-NEXT:    blr
entry:
  %add = add <4 x i32> %m, <i32 1, i32 1, i32 1, i32 1>
  %add1 = add <4 x i32> %add, %n
  %shr = ashr <4 x i32> %add1, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %shr
}

define <16 x i8> @test_v16i8(<16 x i8> %m, <16 x i8> %n) {
; CHECK-P9-LABEL: test_v16i8:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vavgub 2, 3, 2
; CHECK-P9-NEXT:    blr
;
; CHECK-P8-LABEL: test_v16i8:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vavgub 2, 3, 2
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: test_v16i8:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    vavgub 2, 3, 2
; CHECK-P7-NEXT:    blr
entry:
  %add = add <16 x i8> %m, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %add1 = add <16 x i8> %add, %n
  %shr = lshr <16 x i8> %add1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %shr
}

define <16 x i8> @test_v16i8_sign(<16 x i8> %m, <16 x i8> %n) {
; CHECK-P9-LABEL: test_v16i8_sign:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vavgsb 2, 3, 2
; CHECK-P9-NEXT:    blr
;
; CHECK-P8-LABEL: test_v16i8_sign:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vavgsb 2, 3, 2
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: test_v16i8_sign:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    vavgsb 2, 3, 2
; CHECK-P7-NEXT:    blr
entry:
  %add = add <16 x i8> %m, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %add1 = add <16 x i8> %add, %n
  %shr = ashr <16 x i8> %add1, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %shr
}

define <8 x i16> @test_v8i16_sign_negative(<8 x i16> %m, <8 x i16> %n) {
; CHECK-P9-LABEL: test_v8i16_sign_negative:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    addis 3, 2, .LCPI6_0@toc@ha
; CHECK-P9-NEXT:    vadduhm 2, 2, 3
; CHECK-P9-NEXT:    addi 3, 3, .LCPI6_0@toc@l
; CHECK-P9-NEXT:    lxv 35, 0(3)
; CHECK-P9-NEXT:    vadduhm 2, 2, 3
; CHECK-P9-NEXT:    vspltish 3, 1
; CHECK-P9-NEXT:    vsrah 2, 2, 3
; CHECK-P9-NEXT:    blr
;
; CHECK-P8-LABEL: test_v8i16_sign_negative:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis 3, 2, .LCPI6_0@toc@ha
; CHECK-P8-NEXT:    vadduhm 2, 2, 3
; CHECK-P8-NEXT:    vspltish 3, 1
; CHECK-P8-NEXT:    addi 3, 3, .LCPI6_0@toc@l
; CHECK-P8-NEXT:    lxvd2x 0, 0, 3
; CHECK-P8-NEXT:    xxswapd 36, 0
; CHECK-P8-NEXT:    vadduhm 2, 2, 4
; CHECK-P8-NEXT:    vsrah 2, 2, 3
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: test_v8i16_sign_negative:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    addis 3, 2, .LCPI6_0@toc@ha
; CHECK-P7-NEXT:    vadduhm 2, 2, 3
; CHECK-P7-NEXT:    vspltish 3, 1
; CHECK-P7-NEXT:    addi 3, 3, .LCPI6_0@toc@l
; CHECK-P7-NEXT:    lxvd2x 0, 0, 3
; CHECK-P7-NEXT:    xxswapd 36, 0
; CHECK-P7-NEXT:    vadduhm 2, 2, 4
; CHECK-P7-NEXT:    vsrah 2, 2, 3
; CHECK-P7-NEXT:    blr
entry:
  %add = add <8 x i16> %m, <i16 1, i16 1, i16 1, i16 -1, i16 1, i16 1, i16 1, i16 1>
  %add1 = add <8 x i16> %add, %n
  %shr = ashr <8 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %shr
}

define <4 x i32> @test_v4i32_negative(<4 x i32> %m, <4 x i32> %n) {
; CHECK-P9-LABEL: test_v4i32_negative:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    xxlnor 34, 34, 34
; CHECK-P9-NEXT:    vsubuwm 2, 3, 2
; CHECK-P9-NEXT:    vspltisw 3, 2
; CHECK-P9-NEXT:    vsrw 2, 2, 3
; CHECK-P9-NEXT:    blr
;
; CHECK-P8-LABEL: test_v4i32_negative:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxlnor 34, 34, 34
; CHECK-P8-NEXT:    vspltisw 4, 2
; CHECK-P8-NEXT:    vsubuwm 2, 3, 2
; CHECK-P8-NEXT:    vsrw 2, 2, 4
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: test_v4i32_negative:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    xxlnor 34, 34, 34
; CHECK-P7-NEXT:    vspltisw 4, 2
; CHECK-P7-NEXT:    vsubuwm 2, 3, 2
; CHECK-P7-NEXT:    vsrw 2, 2, 4
; CHECK-P7-NEXT:    blr
entry:
  %add = add <4 x i32> %m, <i32 1, i32 1, i32 1, i32 1>
  %add1 = add <4 x i32> %add, %n
  %shr = lshr <4 x i32> %add1, <i32 2, i32 2, i32 2, i32 2>
  ret <4 x i32> %shr
}

define <4 x i32> @test_v4i32_sign_negative(<4 x i32> %m, <4 x i32> %n) {
; CHECK-P9-LABEL: test_v4i32_sign_negative:
; CHECK-P9:       # %bb.0: # %entry
; CHECK-P9-NEXT:    vadduwm 2, 2, 3
; CHECK-P9-NEXT:    xxleqv 35, 35, 35
; CHECK-P9-NEXT:    vadduwm 2, 2, 3
; CHECK-P9-NEXT:    vspltisw 3, 1
; CHECK-P9-NEXT:    vsraw 2, 2, 3
; CHECK-P9-NEXT:    blr
;
; CHECK-P8-LABEL: test_v4i32_sign_negative:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    xxleqv 36, 36, 36
; CHECK-P8-NEXT:    vadduwm 2, 2, 3
; CHECK-P8-NEXT:    vspltisw 3, 1
; CHECK-P8-NEXT:    vadduwm 2, 2, 4
; CHECK-P8-NEXT:    vsraw 2, 2, 3
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: test_v4i32_sign_negative:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    vspltisb 4, -1
; CHECK-P7-NEXT:    vadduwm 2, 2, 3
; CHECK-P7-NEXT:    vspltisw 3, 1
; CHECK-P7-NEXT:    vadduwm 2, 2, 4
; CHECK-P7-NEXT:    vsraw 2, 2, 3
; CHECK-P7-NEXT:    blr
entry:
  %add = add <4 x i32> %m, <i32 -1, i32 -1, i32 -1, i32 -1>
  %add1 = add <4 x i32> %add, %n
  %shr = ashr <4 x i32> %add1, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %shr
}
