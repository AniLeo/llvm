; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve --verify-machineinstrs %s -o - | FileCheck %s

define void @vctp8(i32 %arg, <16 x i8> *%in, <16 x i8>* %out) {
; CHECK-LABEL: vctp8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vctp.8 r0
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vmovt q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r2]
; CHECK-NEXT:    bx lr
  %pred = call <16 x i1> @llvm.arm.mve.vctp8(i32 %arg)
  %ld = load <16 x i8>, <16 x i8>* %in
  %res = select <16 x i1> %pred, <16 x i8> %ld, <16 x i8> zeroinitializer
  store <16 x i8> %res, <16 x i8>* %out
  ret void
}

define void @vctp16(i32 %arg, <8 x i16> *%in, <8 x i16>* %out) {
; CHECK-LABEL: vctp16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vctp.16 r0
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vmovt q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r2]
; CHECK-NEXT:    bx lr
  %pred = call <8 x i1> @llvm.arm.mve.vctp16(i32 %arg)
  %ld = load <8 x i16>, <8 x i16>* %in
  %res = select <8 x i1> %pred, <8 x i16> %ld, <8 x i16> zeroinitializer
  store <8 x i16> %res, <8 x i16>* %out
  ret void
}

define void @vctp32(i32 %arg, <4 x i32> *%in, <4 x i32>* %out) {
; CHECK-LABEL: vctp32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vldrw.u32 q1, [r1]
; CHECK-NEXT:    vctp.32 r0
; CHECK-NEXT:    vmov.i32 q0, #0x0
; CHECK-NEXT:    vpst
; CHECK-NEXT:    vmovt q0, q1
; CHECK-NEXT:    vstrw.32 q0, [r2]
; CHECK-NEXT:    bx lr
  %pred = call <4 x i1> @llvm.arm.mve.vctp32(i32 %arg)
  %ld = load <4 x i32>, <4 x i32>* %in
  %res = select <4 x i1> %pred, <4 x i32> %ld, <4 x i32> zeroinitializer
  store <4 x i32> %res, <4 x i32>* %out
  ret void
}


define arm_aapcs_vfpcc <4 x i32> @vcmp_ult_v4i32(i32 %n, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: vcmp_ult_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.32 q2, r0
; CHECK-NEXT:    adr r0, .LCPI3_0
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vcmp.u32 hi, q2, q3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI3_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 3 @ 0x3
entry:
  %i = insertelement <4 x i32> undef, i32 %n, i32 0
  %ns = shufflevector <4 x i32> %i, <4 x i32> undef, <4 x i32> zeroinitializer
  %c = icmp ult <4 x i32> <i32 0, i32 1, i32 2, i32 3>, %ns
  %s = select <4 x i1> %c, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <4 x i32> @vcmp_uge_v4i32(i32 %n, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: vcmp_uge_v4i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.32 q2, r0
; CHECK-NEXT:    adr r0, .LCPI4_0
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vcmp.u32 cs, q2, q3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI4_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .long 2 @ 0x2
; CHECK-NEXT:    .long 3 @ 0x3
entry:
  %i = insertelement <4 x i32> undef, i32 %n, i32 0
  %ns = shufflevector <4 x i32> %i, <4 x i32> undef, <4 x i32> zeroinitializer
  %c = icmp uge <4 x i32> %ns, <i32 0, i32 1, i32 2, i32 3>
  %s = select <4 x i1> %c, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <4 x i32> @vcmp_ult_v4i32_undef(i32 %n, <4 x i32> %a, <4 x i32> %b) {
; CHECK-LABEL: vcmp_ult_v4i32_undef:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.32 q2, r0
; CHECK-NEXT:    adr r0, .LCPI5_0
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vcmp.u32 hi, q2, q3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI5_0:
; CHECK-NEXT:    .long 0 @ 0x0
; CHECK-NEXT:    .long 1 @ 0x1
; CHECK-NEXT:    .zero 4
; CHECK-NEXT:    .zero 4
entry:
  %i = insertelement <4 x i32> undef, i32 %n, i32 0
  %ns = shufflevector <4 x i32> %i, <4 x i32> undef, <4 x i32> zeroinitializer
  %c = icmp ult <4 x i32> <i32 0, i32 1, i32 undef, i32 undef>, %ns
  %s = select <4 x i1> %c, <4 x i32> %a, <4 x i32> %b
  ret <4 x i32> %s
}


define arm_aapcs_vfpcc <8 x i16> @vcmp_ult_v8i16(i16 %n, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: vcmp_ult_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.16 q2, r0
; CHECK-NEXT:    adr r0, .LCPI6_0
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vcmp.u16 hi, q2, q3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI6_0:
; CHECK-NEXT:    .short 0 @ 0x0
; CHECK-NEXT:    .short 1 @ 0x1
; CHECK-NEXT:    .short 2 @ 0x2
; CHECK-NEXT:    .short 3 @ 0x3
; CHECK-NEXT:    .short 4 @ 0x4
; CHECK-NEXT:    .short 5 @ 0x5
; CHECK-NEXT:    .short 6 @ 0x6
; CHECK-NEXT:    .short 7 @ 0x7
entry:
  %i = insertelement <8 x i16> undef, i16 %n, i32 0
  %ns = shufflevector <8 x i16> %i, <8 x i16> undef, <8 x i32> zeroinitializer
  %c = icmp ult <8 x i16> <i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7>, %ns
  %s = select <8 x i1> %c, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %s
}

define arm_aapcs_vfpcc <8 x i16> @vcmp_uge_v8i16(i16 %n, <8 x i16> %a, <8 x i16> %b) {
; CHECK-LABEL: vcmp_uge_v8i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.16 q2, r0
; CHECK-NEXT:    adr r0, .LCPI7_0
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vcmp.u16 cs, q2, q3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI7_0:
; CHECK-NEXT:    .short 0 @ 0x0
; CHECK-NEXT:    .short 1 @ 0x1
; CHECK-NEXT:    .short 2 @ 0x2
; CHECK-NEXT:    .short 3 @ 0x3
; CHECK-NEXT:    .short 4 @ 0x4
; CHECK-NEXT:    .short 5 @ 0x5
; CHECK-NEXT:    .short 6 @ 0x6
; CHECK-NEXT:    .short 7 @ 0x7
entry:
  %i = insertelement <8 x i16> undef, i16 %n, i32 0
  %ns = shufflevector <8 x i16> %i, <8 x i16> undef, <8 x i32> zeroinitializer
  %c = icmp uge <8 x i16> %ns, <i16 0, i16 1, i16 2, i16 3, i16 4, i16 5, i16 6, i16 7>
  %s = select <8 x i1> %c, <8 x i16> %a, <8 x i16> %b
  ret <8 x i16> %s
}


define arm_aapcs_vfpcc <16 x i8> @vcmp_ult_v16i8(i8 %n, <16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: vcmp_ult_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.8 q2, r0
; CHECK-NEXT:    adr r0, .LCPI8_0
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vcmp.u8 hi, q2, q3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI8_0:
; CHECK-NEXT:    .byte 0 @ 0x0
; CHECK-NEXT:    .byte 1 @ 0x1
; CHECK-NEXT:    .byte 2 @ 0x2
; CHECK-NEXT:    .byte 3 @ 0x3
; CHECK-NEXT:    .byte 4 @ 0x4
; CHECK-NEXT:    .byte 5 @ 0x5
; CHECK-NEXT:    .byte 6 @ 0x6
; CHECK-NEXT:    .byte 7 @ 0x7
; CHECK-NEXT:    .byte 8 @ 0x8
; CHECK-NEXT:    .byte 9 @ 0x9
; CHECK-NEXT:    .byte 10 @ 0xa
; CHECK-NEXT:    .byte 11 @ 0xb
; CHECK-NEXT:    .byte 12 @ 0xc
; CHECK-NEXT:    .byte 13 @ 0xd
; CHECK-NEXT:    .byte 14 @ 0xe
; CHECK-NEXT:    .byte 15 @ 0xf
entry:
  %i = insertelement <16 x i8> undef, i8 %n, i32 0
  %ns = shufflevector <16 x i8> %i, <16 x i8> undef, <16 x i32> zeroinitializer
  %c = icmp ult <16 x i8> <i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15>, %ns
  %s = select <16 x i1> %c, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %s
}

define arm_aapcs_vfpcc <16 x i8> @vcmp_uge_v16i8(i8 %n, <16 x i8> %a, <16 x i8> %b) {
; CHECK-LABEL: vcmp_uge_v16i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    vdup.8 q2, r0
; CHECK-NEXT:    adr r0, .LCPI9_0
; CHECK-NEXT:    vldrw.u32 q3, [r0]
; CHECK-NEXT:    vcmp.u8 cs, q2, q3
; CHECK-NEXT:    vpsel q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 4
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI9_0:
; CHECK-NEXT:    .byte 0 @ 0x0
; CHECK-NEXT:    .byte 1 @ 0x1
; CHECK-NEXT:    .byte 2 @ 0x2
; CHECK-NEXT:    .byte 3 @ 0x3
; CHECK-NEXT:    .byte 4 @ 0x4
; CHECK-NEXT:    .byte 5 @ 0x5
; CHECK-NEXT:    .byte 6 @ 0x6
; CHECK-NEXT:    .byte 7 @ 0x7
; CHECK-NEXT:    .byte 8 @ 0x8
; CHECK-NEXT:    .byte 9 @ 0x9
; CHECK-NEXT:    .byte 10 @ 0xa
; CHECK-NEXT:    .byte 11 @ 0xb
; CHECK-NEXT:    .byte 12 @ 0xc
; CHECK-NEXT:    .byte 13 @ 0xd
; CHECK-NEXT:    .byte 14 @ 0xe
; CHECK-NEXT:    .byte 15 @ 0xf
entry:
  %i = insertelement <16 x i8> undef, i8 %n, i32 0
  %ns = shufflevector <16 x i8> %i, <16 x i8> undef, <16 x i32> zeroinitializer
  %c = icmp uge <16 x i8> %ns, <i8 0, i8 1, i8 2, i8 3, i8 4, i8 5, i8 6, i8 7, i8 8, i8 9, i8 10, i8 11, i8 12, i8 13, i8 14, i8 15>
  %s = select <16 x i1> %c, <16 x i8> %a, <16 x i8> %b
  ret <16 x i8> %s
}


define arm_aapcs_vfpcc <2 x i64> @vcmp_ult_v2i64(i64 %n, <2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: vcmp_ult_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    rsbs.w r3, r0, #1
; CHECK-NEXT:    mov.w r2, #0
; CHECK-NEXT:    sbcs.w r3, r2, r1
; CHECK-NEXT:    mov.w r3, #0
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r3, #1
; CHECK-NEXT:    cmp r3, #0
; CHECK-NEXT:    csetm r3, ne
; CHECK-NEXT:    rsbs r0, r0, #0
; CHECK-NEXT:    sbcs.w r0, r2, r1
; CHECK-NEXT:    it lo
; CHECK-NEXT:    movlo r2, #1
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    vmov q2[2], q2[0], r0, r3
; CHECK-NEXT:    vmov q2[3], q2[1], r0, r3
; CHECK-NEXT:    vbic q1, q1, q2
; CHECK-NEXT:    vand q0, q0, q2
; CHECK-NEXT:    vorr q0, q0, q1
; CHECK-NEXT:    bx lr
entry:
  %i = insertelement <2 x i64> undef, i64 %n, i32 0
  %ns = shufflevector <2 x i64> %i, <2 x i64> undef, <2 x i32> zeroinitializer
  %c = icmp ult <2 x i64> <i64 0, i64 1>, %ns
  %s = select <2 x i1> %c, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}

define arm_aapcs_vfpcc <2 x i64> @vcmp_uge_v2i64(i64 %n, <2 x i64> %a, <2 x i64> %b) {
; CHECK-LABEL: vcmp_uge_v2i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    subs r0, #1
; CHECK-NEXT:    mov.w r2, #0
; CHECK-NEXT:    sbcs r0, r1, #0
; CHECK-NEXT:    it hs
; CHECK-NEXT:    movhs r2, #1
; CHECK-NEXT:    cmp r2, #0
; CHECK-NEXT:    vldr s8, .LCPI11_0
; CHECK-NEXT:    csetm r0, ne
; CHECK-NEXT:    vmov s10, r0
; CHECK-NEXT:    vmov.f32 s9, s8
; CHECK-NEXT:    vmov.f32 s11, s10
; CHECK-NEXT:    vbic q1, q1, q2
; CHECK-NEXT:    vand q0, q0, q2
; CHECK-NEXT:    vorr q0, q0, q1
; CHECK-NEXT:    bx lr
; CHECK-NEXT:    .p2align 2
; CHECK-NEXT:  @ %bb.1:
; CHECK-NEXT:  .LCPI11_0:
; CHECK-NEXT:    .long 0xffffffff @ float NaN
entry:
  %i = insertelement <2 x i64> undef, i64 %n, i32 0
  %ns = shufflevector <2 x i64> %i, <2 x i64> undef, <2 x i32> zeroinitializer
  %c = icmp uge <2 x i64> %ns, <i64 0, i64 1>
  %s = select <2 x i1> %c, <2 x i64> %a, <2 x i64> %b
  ret <2 x i64> %s
}


declare <16 x i1> @llvm.arm.mve.vctp8(i32)
declare <8 x i1> @llvm.arm.mve.vctp16(i32)
declare <4 x i1> @llvm.arm.mve.vctp32(i32)
