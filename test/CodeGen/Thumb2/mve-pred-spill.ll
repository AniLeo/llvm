; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK-LE
; RUN: llc -mtriple=thumbebv8.1m.main-none-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s --check-prefix=CHECK-BE

declare arm_aapcs_vfpcc <2 x i64> @ext_i64(<2 x i64> %c)
declare arm_aapcs_vfpcc <4 x i32> @ext_i32(<4 x i32> %c)
declare arm_aapcs_vfpcc <8 x i16> @ext_i16(<8 x i16> %c)
declare arm_aapcs_vfpcc <16 x i8> @ext_i8(<16 x i8> %c)

define arm_aapcs_vfpcc <2 x i64> @shuffle1_v2i64(<2 x i64> %src, <2 x i64> %a) {
; CHECK-LE-LABEL: shuffle1_v2i64:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r7, lr}
; CHECK-LE-NEXT:    push {r7, lr}
; CHECK-LE-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-LE-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-LE-NEXT:    vmov r0, r1, d1
; CHECK-LE-NEXT:    orrs r0, r1
; CHECK-LE-NEXT:    vmov r1, r2, d0
; CHECK-LE-NEXT:    cset r0, eq
; CHECK-LE-NEXT:    cmp r0, #0
; CHECK-LE-NEXT:    csetm r0, ne
; CHECK-LE-NEXT:    orrs r1, r2
; CHECK-LE-NEXT:    cset r1, eq
; CHECK-LE-NEXT:    cmp r1, #0
; CHECK-LE-NEXT:    csetm r1, ne
; CHECK-LE-NEXT:    vmov q5[2], q5[0], r1, r0
; CHECK-LE-NEXT:    vmov q5[3], q5[1], r1, r0
; CHECK-LE-NEXT:    vand q4, q1, q5
; CHECK-LE-NEXT:    vmov q0, q4
; CHECK-LE-NEXT:    bl ext_i64
; CHECK-LE-NEXT:    vbic q0, q0, q5
; CHECK-LE-NEXT:    vorr q0, q4, q0
; CHECK-LE-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-LE-NEXT:    pop {r7, pc}
;
; CHECK-BE-LABEL: shuffle1_v2i64:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r7, lr}
; CHECK-BE-NEXT:    push {r7, lr}
; CHECK-BE-NEXT:    .vsave {d8, d9, d10, d11}
; CHECK-BE-NEXT:    vpush {d8, d9, d10, d11}
; CHECK-BE-NEXT:    vrev64.32 q2, q0
; CHECK-BE-NEXT:    vmov r0, r1, d5
; CHECK-BE-NEXT:    orrs r0, r1
; CHECK-BE-NEXT:    vmov r1, r2, d4
; CHECK-BE-NEXT:    cset r0, eq
; CHECK-BE-NEXT:    cmp r0, #0
; CHECK-BE-NEXT:    csetm r0, ne
; CHECK-BE-NEXT:    orrs r1, r2
; CHECK-BE-NEXT:    cset r1, eq
; CHECK-BE-NEXT:    cmp r1, #0
; CHECK-BE-NEXT:    csetm r1, ne
; CHECK-BE-NEXT:    vmov q0[2], q0[0], r1, r0
; CHECK-BE-NEXT:    vmov q0[3], q0[1], r1, r0
; CHECK-BE-NEXT:    vrev64.32 q2, q0
; CHECK-BE-NEXT:    vmov.i8 q0, #0xff
; CHECK-BE-NEXT:    vand q4, q1, q2
; CHECK-BE-NEXT:    veor q5, q2, q0
; CHECK-BE-NEXT:    vmov q0, q4
; CHECK-BE-NEXT:    bl ext_i64
; CHECK-BE-NEXT:    vand q0, q0, q5
; CHECK-BE-NEXT:    vorr q0, q4, q0
; CHECK-BE-NEXT:    vpop {d8, d9, d10, d11}
; CHECK-BE-NEXT:    pop {r7, pc}
entry:
  %c = icmp eq <2 x i64> %src, zeroinitializer
  %s1 = select <2 x i1> %c, <2 x i64> %a, <2 x i64> zeroinitializer
  %ext = call arm_aapcs_vfpcc <2 x i64> @ext_i64(<2 x i64> %s1)
  %s = select <2 x i1> %c, <2 x i64> %a, <2 x i64> %ext
  ret <2 x i64> %s
}

define arm_aapcs_vfpcc <4 x i32> @shuffle1_v4i32(<4 x i32> %src, <4 x i32> %a) {
; CHECK-LE-LABEL: shuffle1_v4i32:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r7, lr}
; CHECK-LE-NEXT:    push {r7, lr}
; CHECK-LE-NEXT:    .vsave {d8, d9}
; CHECK-LE-NEXT:    vpush {d8, d9}
; CHECK-LE-NEXT:    .pad #8
; CHECK-LE-NEXT:    sub sp, #8
; CHECK-LE-NEXT:    vcmp.i32 eq, q0, zr
; CHECK-LE-NEXT:    vmov.i32 q0, #0x0
; CHECK-LE-NEXT:    vpsel q0, q1, q0
; CHECK-LE-NEXT:    vmov q4, q1
; CHECK-LE-NEXT:    vstr p0, [sp, #4] @ 4-byte Spill
; CHECK-LE-NEXT:    bl ext_i32
; CHECK-LE-NEXT:    vldr p0, [sp, #4] @ 4-byte Reload
; CHECK-LE-NEXT:    vpsel q0, q4, q0
; CHECK-LE-NEXT:    add sp, #8
; CHECK-LE-NEXT:    vpop {d8, d9}
; CHECK-LE-NEXT:    pop {r7, pc}
;
; CHECK-BE-LABEL: shuffle1_v4i32:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r7, lr}
; CHECK-BE-NEXT:    push {r7, lr}
; CHECK-BE-NEXT:    .vsave {d8, d9}
; CHECK-BE-NEXT:    vpush {d8, d9}
; CHECK-BE-NEXT:    .pad #8
; CHECK-BE-NEXT:    sub sp, #8
; CHECK-BE-NEXT:    vrev64.32 q4, q1
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vcmp.i32 eq, q1, zr
; CHECK-BE-NEXT:    vmov.i32 q0, #0x0
; CHECK-BE-NEXT:    vpsel q1, q4, q0
; CHECK-BE-NEXT:    vstr p0, [sp, #4] @ 4-byte Spill
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    bl ext_i32
; CHECK-BE-NEXT:    vldr p0, [sp, #4] @ 4-byte Reload
; CHECK-BE-NEXT:    vrev64.32 q1, q0
; CHECK-BE-NEXT:    vpsel q1, q4, q1
; CHECK-BE-NEXT:    vrev64.32 q0, q1
; CHECK-BE-NEXT:    add sp, #8
; CHECK-BE-NEXT:    vpop {d8, d9}
; CHECK-BE-NEXT:    pop {r7, pc}
entry:
  %c = icmp eq <4 x i32> %src, zeroinitializer
  %s1 = select <4 x i1> %c, <4 x i32> %a, <4 x i32> zeroinitializer
  %ext = call arm_aapcs_vfpcc <4 x i32> @ext_i32(<4 x i32> %s1)
  %s = select <4 x i1> %c, <4 x i32> %a, <4 x i32> %ext
  ret <4 x i32> %s
}

define arm_aapcs_vfpcc <8 x i16> @shuffle1_v8i16(<8 x i16> %src, <8 x i16> %a) {
; CHECK-LE-LABEL: shuffle1_v8i16:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r7, lr}
; CHECK-LE-NEXT:    push {r7, lr}
; CHECK-LE-NEXT:    .vsave {d8, d9}
; CHECK-LE-NEXT:    vpush {d8, d9}
; CHECK-LE-NEXT:    .pad #8
; CHECK-LE-NEXT:    sub sp, #8
; CHECK-LE-NEXT:    vcmp.i16 eq, q0, zr
; CHECK-LE-NEXT:    vmov.i32 q0, #0x0
; CHECK-LE-NEXT:    vpsel q0, q1, q0
; CHECK-LE-NEXT:    vmov q4, q1
; CHECK-LE-NEXT:    vstr p0, [sp, #4] @ 4-byte Spill
; CHECK-LE-NEXT:    bl ext_i16
; CHECK-LE-NEXT:    vldr p0, [sp, #4] @ 4-byte Reload
; CHECK-LE-NEXT:    vpsel q0, q4, q0
; CHECK-LE-NEXT:    add sp, #8
; CHECK-LE-NEXT:    vpop {d8, d9}
; CHECK-LE-NEXT:    pop {r7, pc}
;
; CHECK-BE-LABEL: shuffle1_v8i16:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r7, lr}
; CHECK-BE-NEXT:    push {r7, lr}
; CHECK-BE-NEXT:    .vsave {d8, d9}
; CHECK-BE-NEXT:    vpush {d8, d9}
; CHECK-BE-NEXT:    .pad #8
; CHECK-BE-NEXT:    sub sp, #8
; CHECK-BE-NEXT:    vrev64.16 q4, q1
; CHECK-BE-NEXT:    vmov.i32 q1, #0x0
; CHECK-BE-NEXT:    vrev64.16 q2, q0
; CHECK-BE-NEXT:    vrev32.16 q1, q1
; CHECK-BE-NEXT:    vcmp.i16 eq, q2, zr
; CHECK-BE-NEXT:    vpsel q1, q4, q1
; CHECK-BE-NEXT:    vstr p0, [sp, #4] @ 4-byte Spill
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    bl ext_i16
; CHECK-BE-NEXT:    vldr p0, [sp, #4] @ 4-byte Reload
; CHECK-BE-NEXT:    vrev64.16 q1, q0
; CHECK-BE-NEXT:    vpsel q1, q4, q1
; CHECK-BE-NEXT:    vrev64.16 q0, q1
; CHECK-BE-NEXT:    add sp, #8
; CHECK-BE-NEXT:    vpop {d8, d9}
; CHECK-BE-NEXT:    pop {r7, pc}
entry:
  %c = icmp eq <8 x i16> %src, zeroinitializer
  %s1 = select <8 x i1> %c, <8 x i16> %a, <8 x i16> zeroinitializer
  %ext = call arm_aapcs_vfpcc <8 x i16> @ext_i16(<8 x i16> %s1)
  %s = select <8 x i1> %c, <8 x i16> %a, <8 x i16> %ext
  ret <8 x i16> %s
}

define arm_aapcs_vfpcc <16 x i8> @shuffle1_v16i8(<16 x i8> %src, <16 x i8> %a) {
; CHECK-LE-LABEL: shuffle1_v16i8:
; CHECK-LE:       @ %bb.0: @ %entry
; CHECK-LE-NEXT:    .save {r7, lr}
; CHECK-LE-NEXT:    push {r7, lr}
; CHECK-LE-NEXT:    .vsave {d8, d9}
; CHECK-LE-NEXT:    vpush {d8, d9}
; CHECK-LE-NEXT:    .pad #8
; CHECK-LE-NEXT:    sub sp, #8
; CHECK-LE-NEXT:    vcmp.i8 eq, q0, zr
; CHECK-LE-NEXT:    vmov.i32 q0, #0x0
; CHECK-LE-NEXT:    vpsel q0, q1, q0
; CHECK-LE-NEXT:    vmov q4, q1
; CHECK-LE-NEXT:    vstr p0, [sp, #4] @ 4-byte Spill
; CHECK-LE-NEXT:    bl ext_i8
; CHECK-LE-NEXT:    vldr p0, [sp, #4] @ 4-byte Reload
; CHECK-LE-NEXT:    vpsel q0, q4, q0
; CHECK-LE-NEXT:    add sp, #8
; CHECK-LE-NEXT:    vpop {d8, d9}
; CHECK-LE-NEXT:    pop {r7, pc}
;
; CHECK-BE-LABEL: shuffle1_v16i8:
; CHECK-BE:       @ %bb.0: @ %entry
; CHECK-BE-NEXT:    .save {r7, lr}
; CHECK-BE-NEXT:    push {r7, lr}
; CHECK-BE-NEXT:    .vsave {d8, d9}
; CHECK-BE-NEXT:    vpush {d8, d9}
; CHECK-BE-NEXT:    .pad #8
; CHECK-BE-NEXT:    sub sp, #8
; CHECK-BE-NEXT:    vrev64.8 q4, q1
; CHECK-BE-NEXT:    vmov.i32 q1, #0x0
; CHECK-BE-NEXT:    vrev64.8 q2, q0
; CHECK-BE-NEXT:    vrev32.8 q1, q1
; CHECK-BE-NEXT:    vcmp.i8 eq, q2, zr
; CHECK-BE-NEXT:    vpsel q1, q4, q1
; CHECK-BE-NEXT:    vstr p0, [sp, #4] @ 4-byte Spill
; CHECK-BE-NEXT:    vrev64.8 q0, q1
; CHECK-BE-NEXT:    bl ext_i8
; CHECK-BE-NEXT:    vldr p0, [sp, #4] @ 4-byte Reload
; CHECK-BE-NEXT:    vrev64.8 q1, q0
; CHECK-BE-NEXT:    vpsel q1, q4, q1
; CHECK-BE-NEXT:    vrev64.8 q0, q1
; CHECK-BE-NEXT:    add sp, #8
; CHECK-BE-NEXT:    vpop {d8, d9}
; CHECK-BE-NEXT:    pop {r7, pc}
entry:
  %c = icmp eq <16 x i8> %src, zeroinitializer
  %s1 = select <16 x i1> %c, <16 x i8> %a, <16 x i8> zeroinitializer
  %ext = call arm_aapcs_vfpcc <16 x i8> @ext_i8(<16 x i8> %s1)
  %s = select <16 x i1> %c, <16 x i8> %a, <16 x i8> %ext
  ret <16 x i8> %s
}
