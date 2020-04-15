; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-arm-none-eabi -mattr=+mve -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc <16 x i8> @vhadds_v16i8(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vhadds_v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vshr.s8 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <16 x i8> %x, %y
  %half = ashr <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <16 x i8> @vhaddu_v16i8(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vhaddu_v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vshr.u8 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <16 x i8> %x, %y
  %half = lshr <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <8 x i16> @vhadds_v8i16(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vhadds_v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vshr.s16 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <8 x i16> %x, %y
  %half = ashr <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <8 x i16> @vhaddu_v8i16(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vhaddu_v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vshr.u16 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <8 x i16> %x, %y
  %half = lshr <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <4 x i32> @vhadds_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vhadds_v4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vshr.s32 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <4 x i32> %x, %y
  %half = ashr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <4 x i32> @vhaddu_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vhaddu_v4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vshr.u32 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <4 x i32> %x, %y
  %half = lshr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <16 x i8> @vhsubs_v16i8(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vhsubs_v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i8 q0, q0, q1
; CHECK-NEXT:    vshr.s8 q0, q0, #1
; CHECK-NEXT:    bx lr
  %sub = sub <16 x i8> %x, %y
  %half = ashr <16 x i8> %sub, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <16 x i8> @vhsubu_v16i8(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vhsubu_v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i8 q0, q0, q1
; CHECK-NEXT:    vshr.u8 q0, q0, #1
; CHECK-NEXT:    bx lr
  %sub = sub <16 x i8> %x, %y
  %half = lshr <16 x i8> %sub, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <8 x i16> @vhsubs_v8i16(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vhsubs_v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i16 q0, q0, q1
; CHECK-NEXT:    vshr.s16 q0, q0, #1
; CHECK-NEXT:    bx lr
  %sub = sub <8 x i16> %x, %y
  %half = ashr <8 x i16> %sub, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <8 x i16> @vhsubu_v8i16(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vhsubu_v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i16 q0, q0, q1
; CHECK-NEXT:    vshr.u16 q0, q0, #1
; CHECK-NEXT:    bx lr
  %sub = sub <8 x i16> %x, %y
  %half = lshr <8 x i16> %sub, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <4 x i32> @vhsubs_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vhsubs_v4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i32 q0, q0, q1
; CHECK-NEXT:    vshr.s32 q0, q0, #1
; CHECK-NEXT:    bx lr
  %sub = sub <4 x i32> %x, %y
  %half = ashr <4 x i32> %sub, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <4 x i32> @vhsubu_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vhsubu_v4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vsub.i32 q0, q0, q1
; CHECK-NEXT:    vshr.u32 q0, q0, #1
; CHECK-NEXT:    bx lr
  %sub = sub <4 x i32> %x, %y
  %half = lshr <4 x i32> %sub, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}

define arm_aapcs_vfpcc <16 x i8> @vhadds_v16i8_nw(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vhadds_v16i8_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhadd.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nsw <16 x i8> %x, %y
  %half = ashr <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <16 x i8> @vhaddu_v16i8_nw(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vhaddu_v16i8_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhadd.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nuw <16 x i8> %x, %y
  %half = lshr <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <8 x i16> @vhadds_v8i16_nw(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vhadds_v8i16_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhadd.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nsw <8 x i16> %x, %y
  %half = ashr <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <8 x i16> @vhaddu_v8i16_nw(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vhaddu_v8i16_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhadd.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nuw <8 x i16> %x, %y
  %half = lshr <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <4 x i32> @vhadds_v4i32_nw(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vhadds_v4i32_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhadd.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nsw <4 x i32> %x, %y
  %half = ashr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <4 x i32> @vhaddu_v4i32_nw(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vhaddu_v4i32_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhadd.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nuw <4 x i32> %x, %y
  %half = lshr <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <16 x i8> @vhsubs_v16i8_nw(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vhsubs_v16i8_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhsub.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sub = sub nsw <16 x i8> %x, %y
  %half = ashr <16 x i8> %sub, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <16 x i8> @vhsubu_v16i8_nw(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vhsubu_v16i8_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhsub.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sub = sub nuw <16 x i8> %x, %y
  %half = lshr <16 x i8> %sub, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <8 x i16> @vhsubs_v8i16_nw(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vhsubs_v8i16_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhsub.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sub = sub nsw <8 x i16> %x, %y
  %half = ashr <8 x i16> %sub, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <8 x i16> @vhsubu_v8i16_nw(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vhsubu_v8i16_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhsub.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sub = sub nuw <8 x i16> %x, %y
  %half = lshr <8 x i16> %sub, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <4 x i32> @vhsubs_v4i32_nw(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vhsubs_v4i32_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhsub.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sub = sub nsw <4 x i32> %x, %y
  %half = ashr <4 x i32> %sub, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <4 x i32> @vhsubu_v4i32_nw(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vhsubu_v4i32_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vhsub.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %sub = sub nuw <4 x i32> %x, %y
  %half = lshr <4 x i32> %sub, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <16 x i8> @vrhadds_v16i8(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vrhadds_v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vmov.i8 q1, #0x1
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vshr.s8 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <16 x i8> %x, %y
  %round = add <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %half = ashr <16 x i8> %round, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <16 x i8> @vrhaddu_v16i8(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vrhaddu_v16i8:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vmov.i8 q1, #0x1
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vshr.u8 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <16 x i8> %x, %y
  %round = add <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %half = lshr <16 x i8> %round, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <8 x i16> @vrhadds_v8i16(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vrhadds_v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vmov.i16 q1, #0x1
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vshr.s16 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <8 x i16> %x, %y
  %round = add <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %half = ashr <8 x i16> %round, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <8 x i16> @vrhaddu_v8i16(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vrhaddu_v8i16:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vmov.i16 q1, #0x1
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vshr.u16 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <8 x i16> %x, %y
  %round = add <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
 %half = lshr <8 x i16> %round, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <4 x i32> @vrhadds_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vrhadds_v4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vmov.i32 q1, #0x1
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vshr.s32 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <4 x i32> %x, %y
  %round = add <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %half = ashr <4 x i32> %round, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <4 x i32> @vrhaddu_v4i32(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vrhaddu_v4i32:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vmov.i32 q1, #0x1
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vshr.u32 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add <4 x i32> %x, %y
  %round = add <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %half = lshr <4 x i32> %round, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <16 x i8> @vrhadds_v16i8_nwop(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vrhadds_v16i8_nwop:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vmov.i8 q1, #0x1
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vshr.s8 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add nsw <16 x i8> %x, %y
  %round = add <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %half = ashr <16 x i8> %round, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <16 x i8> @vrhaddu_v16i8_nwop(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vrhaddu_v16i8_nwop:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vmov.i8 q1, #0x1
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vshr.u8 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add nuw <16 x i8> %x, %y
  %round = add <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %half = lshr <16 x i8> %round, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <8 x i16> @vrhadds_v8i16_nwop(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vrhadds_v8i16_nwop:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vmov.i16 q1, #0x1
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vshr.s16 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add nsw <8 x i16> %x, %y
  %round = add <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %half = ashr <8 x i16> %round, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <8 x i16> @vrhaddu_v8i16_nwop(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vrhaddu_v8i16_nwop:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vmov.i16 q1, #0x1
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vshr.u16 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add nuw <8 x i16> %x, %y
  %round = add <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %half = lshr <8 x i16> %round, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <4 x i32> @vrhadds_v4i32_nwop(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vrhadds_v4i32_nwop:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vmov.i32 q1, #0x1
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vshr.s32 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add nsw <4 x i32> %x, %y
  %round = add <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %half = ashr <4 x i32> %round, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <4 x i32> @vrhaddu_v4i32_nwop(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vrhaddu_v4i32_nwop:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vmov.i32 q1, #0x1
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vshr.u32 q0, q0, #1
; CHECK-NEXT:    bx lr
  %add = add nuw <4 x i32> %x, %y
  %round = add <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %half = lshr <4 x i32> %round, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <16 x i8> @vrhadds_v16i8_nwrnd(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vrhadds_v16i8_nwrnd:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vmov.i8 q1, #0x1
; CHECK-NEXT:    vhadd.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add <16 x i8> %x, %y
  %round = add nsw <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %half = ashr <16 x i8> %round, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <16 x i8> @vrhaddu_v16i8_nwrnd(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vrhaddu_v16i8_nwrnd:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i8 q0, q0, q1
; CHECK-NEXT:    vmov.i8 q1, #0x1
; CHECK-NEXT:    vhadd.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add <16 x i8> %x, %y
  %round = add nuw <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %half = lshr <16 x i8> %round, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <8 x i16> @vrhadds_v8i16_nwrnd(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vrhadds_v8i16_nwrnd:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vmov.i16 q1, #0x1
; CHECK-NEXT:    vhadd.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add <8 x i16> %x, %y
  %round = add nsw <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %half = ashr <8 x i16> %round, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <8 x i16> @vrhaddu_v8i16_nwrnd(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vrhaddu_v8i16_nwrnd:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i16 q0, q0, q1
; CHECK-NEXT:    vmov.i16 q1, #0x1
; CHECK-NEXT:    vhadd.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add <8 x i16> %x, %y
  %round = add nuw <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %half = lshr <8 x i16> %round, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <4 x i32> @vrhadds_v4i32_nwrnd(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vrhadds_v4i32_nwrnd:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vmov.i32 q1, #0x1
; CHECK-NEXT:    vhadd.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add <4 x i32> %x, %y
  %round = add nsw <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %half = ashr <4 x i32> %round, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <4 x i32> @vrhaddu_v4i32_nwrnd(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vrhaddu_v4i32_nwrnd:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vadd.i32 q0, q0, q1
; CHECK-NEXT:    vmov.i32 q1, #0x1
; CHECK-NEXT:    vhadd.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add <4 x i32> %x, %y
  %round = add nuw <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %half = lshr <4 x i32> %round, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <16 x i8> @vrhadds_v16i8_both_nw(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vrhadds_v16i8_both_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vrhadd.s8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nsw <16 x i8> %x, %y
  %round = add nsw <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %half = ashr <16 x i8> %round, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <16 x i8> @vrhaddu_v16i8_both_nw(<16 x i8> %x, <16 x i8> %y) {
; CHECK-LABEL: vrhaddu_v16i8_both_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vrhadd.u8 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nuw <16 x i8> %x, %y
  %round = add nuw <16 x i8> %add, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  %half = lshr <16 x i8> %round, <i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1, i8 1>
  ret <16 x i8> %half
}
define arm_aapcs_vfpcc <8 x i16> @vrhadds_v8i16_both_nw(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vrhadds_v8i16_both_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vrhadd.s16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nsw <8 x i16> %x, %y
  %round = add nsw <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %half = ashr <8 x i16> %round, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <8 x i16> @vrhaddu_v8i16_both_nw(<8 x i16> %x, <8 x i16> %y) {
; CHECK-LABEL: vrhaddu_v8i16_both_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vrhadd.u16 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nuw <8 x i16> %x, %y
  %round = add nuw <8 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
 %half = lshr <8 x i16> %round, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  ret <8 x i16> %half
}
define arm_aapcs_vfpcc <4 x i32> @vrhadds_v4i32_both_nw(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vrhadds_v4i32_both_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vrhadd.s32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nsw <4 x i32> %x, %y
  %round = add nsw <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %half = ashr <4 x i32> %round, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
define arm_aapcs_vfpcc <4 x i32> @vrhaddu_v4i32_both_nw(<4 x i32> %x, <4 x i32> %y) {
; CHECK-LABEL: vrhaddu_v4i32_both_nw:
; CHECK:       @ %bb.0:
; CHECK-NEXT:    vrhadd.u32 q0, q0, q1
; CHECK-NEXT:    bx lr
  %add = add nuw <4 x i32> %x, %y
  %round = add nuw <4 x i32> %add, <i32 1, i32 1, i32 1, i32 1>
  %half = lshr <4 x i32> %round, <i32 1, i32 1, i32 1, i32 1>
  ret <4 x i32> %half
}
