; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O3 -mtriple=powerpc64le-unknown-unknown -ppc-asm-full-reg-names \
; RUN:   -verify-machineinstrs -mcpu=pwr8 < %s | \
; RUN:   FileCheck --check-prefix=CHECK-P8 %s
; RUN: llc -O3 -mtriple=powerpc64-unknown-unknown -ppc-asm-full-reg-names \
; RUN:   -verify-machineinstrs -mcpu=pwr7 < %s | \
; RUN:   FileCheck --check-prefix=CHECK-P7 %s

define <16 x i8> @rotl_v16i8(<16 x i8> %a) {
; CHECK-P8-LABEL: rotl_v16i8:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-P8-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    xxswapd vs35, vs0
; CHECK-P8-NEXT:    vrlb v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: rotl_v16i8:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    addis r3, r2, .LCPI0_0@toc@ha
; CHECK-P7-NEXT:    addi r3, r3, .LCPI0_0@toc@l
; CHECK-P7-NEXT:    lxvw4x vs35, 0, r3
; CHECK-P7-NEXT:    vrlb v2, v2, v3
; CHECK-P7-NEXT:    blr
entry:
  %b = shl <16 x i8> %a, <i8 1, i8 1, i8 2, i8 2, i8 3, i8 3, i8 4, i8 4, i8 5, i8 5, i8 6, i8 6, i8 7, i8 7, i8 8, i8 8>
  %c = lshr <16 x i8> %a, <i8 7, i8 7, i8 6, i8 6, i8 5, i8 5, i8 4, i8 4, i8 3, i8 3, i8 2, i8 2, i8 1, i8 1, i8 0, i8 0>
  %d = or <16 x i8> %b, %c
  ret <16 x i8> %d
}

define <8 x i16> @rotl_v8i16(<8 x i16> %a) {
; CHECK-P8-LABEL: rotl_v8i16:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-P8-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    xxswapd vs35, vs0
; CHECK-P8-NEXT:    vrlh v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: rotl_v8i16:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-P7-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-P7-NEXT:    lxvw4x vs35, 0, r3
; CHECK-P7-NEXT:    vrlh v2, v2, v3
; CHECK-P7-NEXT:    blr
entry:
  %b = shl <8 x i16> %a, <i16 1, i16 2, i16 3, i16 5, i16 7, i16 11, i16 13, i16 16>
  %c = lshr <8 x i16> %a, <i16 15, i16 14, i16 13, i16 11, i16 9, i16 5, i16 3, i16 0>
  %d = or <8 x i16> %b, %c
  ret <8 x i16> %d
}

define <4 x i32> @rotl_v4i32_0(<4 x i32> %a) {
; CHECK-P8-LABEL: rotl_v4i32_0:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; CHECK-P8-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    xxswapd vs35, vs0
; CHECK-P8-NEXT:    vrlw v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: rotl_v4i32_0:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; CHECK-P7-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; CHECK-P7-NEXT:    lxvw4x vs35, 0, r3
; CHECK-P7-NEXT:    vrlw v2, v2, v3
; CHECK-P7-NEXT:    blr
entry:
  %b = shl <4 x i32> %a, <i32 29, i32 19, i32 17, i32 11>
  %c = lshr <4 x i32> %a, <i32 3, i32 13, i32 15, i32 21>
  %d = or <4 x i32> %b, %c
  ret <4 x i32> %d
}

define <4 x i32> @rotl_v4i32_1(<4 x i32> %a) {
; CHECK-P8-LABEL: rotl_v4i32_1:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    vspltisw v3, -16
; CHECK-P8-NEXT:    vspltisw v4, 7
; CHECK-P8-NEXT:    vsubuwm v3, v4, v3
; CHECK-P8-NEXT:    vrlw v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: rotl_v4i32_1:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    vspltisw v3, -16
; CHECK-P7-NEXT:    vspltisw v4, 7
; CHECK-P7-NEXT:    vsubuwm v3, v4, v3
; CHECK-P7-NEXT:    vrlw v2, v2, v3
; CHECK-P7-NEXT:    blr
entry:
  %b = shl <4 x i32> %a, <i32 23, i32 23, i32 23, i32 23>
  %c = lshr <4 x i32> %a, <i32 9, i32 9, i32 9, i32 9>
  %d = or <4 x i32> %b, %c
  ret <4 x i32> %d
}

define <2 x i64> @rotl_v2i64(<2 x i64> %a) {
; CHECK-P8-LABEL: rotl_v2i64:
; CHECK-P8:       # %bb.0: # %entry
; CHECK-P8-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-P8-NEXT:    addi r3, r3, .LCPI4_0@toc@l
; CHECK-P8-NEXT:    lxvd2x vs0, 0, r3
; CHECK-P8-NEXT:    xxswapd vs35, vs0
; CHECK-P8-NEXT:    vrld v2, v2, v3
; CHECK-P8-NEXT:    blr
;
; CHECK-P7-LABEL: rotl_v2i64:
; CHECK-P7:       # %bb.0: # %entry
; CHECK-P7-NEXT:    addi r3, r1, -32
; CHECK-P7-NEXT:    stxvd2x vs34, 0, r3
; CHECK-P7-NEXT:    ld r3, -24(r1)
; CHECK-P7-NEXT:    rotldi r3, r3, 53
; CHECK-P7-NEXT:    std r3, -8(r1)
; CHECK-P7-NEXT:    ld r3, -32(r1)
; CHECK-P7-NEXT:    rotldi r3, r3, 41
; CHECK-P7-NEXT:    std r3, -16(r1)
; CHECK-P7-NEXT:    addi r3, r1, -16
; CHECK-P7-NEXT:    lxvd2x vs34, 0, r3
; CHECK-P7-NEXT:    blr
entry:
  %b = shl <2 x i64> %a, <i64 41, i64 53>
  %c = lshr <2 x i64> %a, <i64 23, i64 11>
  %d = or <2 x i64> %b, %c
  ret <2 x i64> %d
}
