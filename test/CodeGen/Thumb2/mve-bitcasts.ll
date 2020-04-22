; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve,+fullfp16 -verify-machineinstrs %s -o - | FileCheck %s
; RUN: llc -mtriple=thumbv8.1m.main-none-none-eabi -mattr=+mve.fp -verify-machineinstrs %s -o - | FileCheck %s

define arm_aapcs_vfpcc <2 x i64> @bitcast_i64_i64(<2 x i64> %src) {
; CHECK-LABEL: bitcast_i64_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x i64> %src to <2 x i64>
  ret <2 x i64> %r
}

define arm_aapcs_vfpcc <2 x i64> @bitcast_i64_i32(<4 x i32> %src) {
; CHECK-LABEL: bitcast_i64_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x i32> %src to <2 x i64>
  ret <2 x i64> %r
}

define arm_aapcs_vfpcc <2 x i64> @bitcast_i64_i16(<8 x i16> %src) {
; CHECK-LABEL: bitcast_i64_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x i16> %src to <2 x i64>
  ret <2 x i64> %r
}

define arm_aapcs_vfpcc <2 x i64> @bitcast_i64_i8(<16 x i8> %src) {
; CHECK-LABEL: bitcast_i64_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <16 x i8> %src to <2 x i64>
  ret <2 x i64> %r
}

define arm_aapcs_vfpcc <2 x i64> @bitcast_i64_f64(<2 x double> %src) {
; CHECK-LABEL: bitcast_i64_f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x double> %src to <2 x i64>
  ret <2 x i64> %r
}

define arm_aapcs_vfpcc <2 x i64> @bitcast_i64_f32(<4 x float> %src) {
; CHECK-LABEL: bitcast_i64_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x float> %src to <2 x i64>
  ret <2 x i64> %r
}

define arm_aapcs_vfpcc <2 x i64> @bitcast_i64_f16(<8 x half> %src) {
; CHECK-LABEL: bitcast_i64_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x half> %src to <2 x i64>
  ret <2 x i64> %r
}


define arm_aapcs_vfpcc <4 x i32> @bitcast_i32_i64(<2 x i64> %src) {
; CHECK-LABEL: bitcast_i32_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x i64> %src to <4 x i32>
  ret <4 x i32> %r
}

define arm_aapcs_vfpcc <4 x i32> @bitcast_i32_i32(<4 x i32> %src) {
; CHECK-LABEL: bitcast_i32_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x i32> %src to <4 x i32>
  ret <4 x i32> %r
}

define arm_aapcs_vfpcc <4 x i32> @bitcast_i32_i16(<8 x i16> %src) {
; CHECK-LABEL: bitcast_i32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x i16> %src to <4 x i32>
  ret <4 x i32> %r
}

define arm_aapcs_vfpcc <4 x i32> @bitcast_i32_i8(<16 x i8> %src) {
; CHECK-LABEL: bitcast_i32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <16 x i8> %src to <4 x i32>
  ret <4 x i32> %r
}

define arm_aapcs_vfpcc <4 x i32> @bitcast_i32_f64(<2 x double> %src) {
; CHECK-LABEL: bitcast_i32_f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x double> %src to <4 x i32>
  ret <4 x i32> %r
}

define arm_aapcs_vfpcc <4 x i32> @bitcast_i32_f32(<4 x float> %src) {
; CHECK-LABEL: bitcast_i32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x float> %src to <4 x i32>
  ret <4 x i32> %r
}

define arm_aapcs_vfpcc <4 x i32> @bitcast_i32_f16(<8 x half> %src) {
; CHECK-LABEL: bitcast_i32_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x half> %src to <4 x i32>
  ret <4 x i32> %r
}


define arm_aapcs_vfpcc <8 x i16> @bitcast_i16_i64(<2 x i64> %src) {
; CHECK-LABEL: bitcast_i16_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x i64> %src to <8 x i16>
  ret <8 x i16> %r
}

define arm_aapcs_vfpcc <8 x i16> @bitcast_i16_i32(<4 x i32> %src) {
; CHECK-LABEL: bitcast_i16_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x i32> %src to <8 x i16>
  ret <8 x i16> %r
}

define arm_aapcs_vfpcc <8 x i16> @bitcast_i16_i16(<8 x i16> %src) {
; CHECK-LABEL: bitcast_i16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x i16> %src to <8 x i16>
  ret <8 x i16> %r
}

define arm_aapcs_vfpcc <8 x i16> @bitcast_i16_i8(<16 x i8> %src) {
; CHECK-LABEL: bitcast_i16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <16 x i8> %src to <8 x i16>
  ret <8 x i16> %r
}

define arm_aapcs_vfpcc <8 x i16> @bitcast_i16_f64(<2 x double> %src) {
; CHECK-LABEL: bitcast_i16_f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x double> %src to <8 x i16>
  ret <8 x i16> %r
}

define arm_aapcs_vfpcc <8 x i16> @bitcast_i16_f32(<4 x float> %src) {
; CHECK-LABEL: bitcast_i16_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x float> %src to <8 x i16>
  ret <8 x i16> %r
}

define arm_aapcs_vfpcc <8 x i16> @bitcast_i16_f16(<8 x half> %src) {
; CHECK-LABEL: bitcast_i16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x half> %src to <8 x i16>
  ret <8 x i16> %r
}


define arm_aapcs_vfpcc <16 x i8> @bitcast_i8_i64(<2 x i64> %src) {
; CHECK-LABEL: bitcast_i8_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x i64> %src to <16 x i8>
  ret <16 x i8> %r
}

define arm_aapcs_vfpcc <16 x i8> @bitcast_i8_i32(<4 x i32> %src) {
; CHECK-LABEL: bitcast_i8_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x i32> %src to <16 x i8>
  ret <16 x i8> %r
}

define arm_aapcs_vfpcc <16 x i8> @bitcast_i8_i16(<8 x i16> %src) {
; CHECK-LABEL: bitcast_i8_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x i16> %src to <16 x i8>
  ret <16 x i8> %r
}

define arm_aapcs_vfpcc <16 x i8> @bitcast_i8_i8(<16 x i8> %src) {
; CHECK-LABEL: bitcast_i8_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <16 x i8> %src to <16 x i8>
  ret <16 x i8> %r
}

define arm_aapcs_vfpcc <16 x i8> @bitcast_i8_f64(<2 x double> %src) {
; CHECK-LABEL: bitcast_i8_f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x double> %src to <16 x i8>
  ret <16 x i8> %r
}

define arm_aapcs_vfpcc <16 x i8> @bitcast_i8_f32(<4 x float> %src) {
; CHECK-LABEL: bitcast_i8_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x float> %src to <16 x i8>
  ret <16 x i8> %r
}

define arm_aapcs_vfpcc <16 x i8> @bitcast_i8_f16(<8 x half> %src) {
; CHECK-LABEL: bitcast_i8_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x half> %src to <16 x i8>
  ret <16 x i8> %r
}


define arm_aapcs_vfpcc <2 x double> @bitcast_f64_i64(<2 x i64> %src) {
; CHECK-LABEL: bitcast_f64_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x i64> %src to <2 x double>
  ret <2 x double> %r
}

define arm_aapcs_vfpcc <2 x double> @bitcast_f64_i32(<4 x i32> %src) {
; CHECK-LABEL: bitcast_f64_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x i32> %src to <2 x double>
  ret <2 x double> %r
}

define arm_aapcs_vfpcc <2 x double> @bitcast_f64_i16(<8 x i16> %src) {
; CHECK-LABEL: bitcast_f64_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x i16> %src to <2 x double>
  ret <2 x double> %r
}

define arm_aapcs_vfpcc <2 x double> @bitcast_f64_i8(<16 x i8> %src) {
; CHECK-LABEL: bitcast_f64_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <16 x i8> %src to <2 x double>
  ret <2 x double> %r
}

define arm_aapcs_vfpcc <2 x double> @bitcast_f64_f64(<2 x double> %src) {
; CHECK-LABEL: bitcast_f64_f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x double> %src to <2 x double>
  ret <2 x double> %r
}

define arm_aapcs_vfpcc <2 x double> @bitcast_f64_f32(<4 x float> %src) {
; CHECK-LABEL: bitcast_f64_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x float> %src to <2 x double>
  ret <2 x double> %r
}

define arm_aapcs_vfpcc <2 x double> @bitcast_f64_f16(<8 x half> %src) {
; CHECK-LABEL: bitcast_f64_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x half> %src to <2 x double>
  ret <2 x double> %r
}


define arm_aapcs_vfpcc <4 x float> @bitcast_f32_i64(<2 x i64> %src) {
; CHECK-LABEL: bitcast_f32_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x i64> %src to <4 x float>
  ret <4 x float> %r
}

define arm_aapcs_vfpcc <4 x float> @bitcast_f32_i32(<4 x i32> %src) {
; CHECK-LABEL: bitcast_f32_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x i32> %src to <4 x float>
  ret <4 x float> %r
}

define arm_aapcs_vfpcc <4 x float> @bitcast_f32_i16(<8 x i16> %src) {
; CHECK-LABEL: bitcast_f32_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x i16> %src to <4 x float>
  ret <4 x float> %r
}

define arm_aapcs_vfpcc <4 x float> @bitcast_f32_i8(<16 x i8> %src) {
; CHECK-LABEL: bitcast_f32_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <16 x i8> %src to <4 x float>
  ret <4 x float> %r
}

define arm_aapcs_vfpcc <4 x float> @bitcast_f32_f64(<2 x double> %src) {
; CHECK-LABEL: bitcast_f32_f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x double> %src to <4 x float>
  ret <4 x float> %r
}

define arm_aapcs_vfpcc <4 x float> @bitcast_f32_f32(<4 x float> %src) {
; CHECK-LABEL: bitcast_f32_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x float> %src to <4 x float>
  ret <4 x float> %r
}

define arm_aapcs_vfpcc <4 x float> @bitcast_f32_f16(<8 x half> %src) {
; CHECK-LABEL: bitcast_f32_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x half> %src to <4 x float>
  ret <4 x float> %r
}


define arm_aapcs_vfpcc <8 x half> @bitcast_f16_i64(<2 x i64> %src) {
; CHECK-LABEL: bitcast_f16_i64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x i64> %src to <8 x half>
  ret <8 x half> %r
}

define arm_aapcs_vfpcc <8 x half> @bitcast_f16_i32(<4 x i32> %src) {
; CHECK-LABEL: bitcast_f16_i32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x i32> %src to <8 x half>
  ret <8 x half> %r
}

define arm_aapcs_vfpcc <8 x half> @bitcast_f16_i16(<8 x i16> %src) {
; CHECK-LABEL: bitcast_f16_i16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x i16> %src to <8 x half>
  ret <8 x half> %r
}

define arm_aapcs_vfpcc <8 x half> @bitcast_f16_i8(<16 x i8> %src) {
; CHECK-LABEL: bitcast_f16_i8:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <16 x i8> %src to <8 x half>
  ret <8 x half> %r
}

define arm_aapcs_vfpcc <8 x half> @bitcast_f16_f64(<2 x double> %src) {
; CHECK-LABEL: bitcast_f16_f64:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <2 x double> %src to <8 x half>
  ret <8 x half> %r
}

define arm_aapcs_vfpcc <8 x half> @bitcast_f16_f32(<4 x float> %src) {
; CHECK-LABEL: bitcast_f16_f32:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <4 x float> %src to <8 x half>
  ret <8 x half> %r
}

define arm_aapcs_vfpcc <8 x half> @bitcast_f16_f16(<8 x half> %src) {
; CHECK-LABEL: bitcast_f16_f16:
; CHECK:       @ %bb.0: @ %entry
; CHECK-NEXT:    bx lr
entry:
  %r = bitcast <8 x half> %src to <8 x half>
  ret <8 x half> %r
}
