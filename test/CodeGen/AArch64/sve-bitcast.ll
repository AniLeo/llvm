; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s 2>%t | FileCheck %s
; RUN: not --crash llc -mtriple=aarch64_be -mattr=+sve < %s
; RUN: FileCheck --check-prefix=WARN --allow-empty %s <%t

; WARN-NOT: warning

define <vscale x 16 x i8> @bitcast_i16_to_i8(<vscale x 8 x i16> %v) {
; CHECK-LABEL: bitcast_i16_to_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x i16> %v to <vscale x 16 x i8>
  ret <vscale x 16 x i8> %bc
}

define <vscale x 16 x i8> @bitcast_i32_to_i8(<vscale x 4 x i32> %v) {
; CHECK-LABEL: bitcast_i32_to_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x i32> %v to <vscale x 16 x i8>
  ret <vscale x 16 x i8> %bc
}

define <vscale x 16 x i8> @bitcast_i64_to_i8(<vscale x 2 x i64> %v) {
; CHECK-LABEL: bitcast_i64_to_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x i64> %v to <vscale x 16 x i8>
  ret <vscale x 16 x i8> %bc
}

define <vscale x 16 x i8> @bitcast_half_to_i8(<vscale x 8 x half> %v) {
; CHECK-LABEL: bitcast_half_to_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x half> %v to <vscale x 16 x i8>
  ret <vscale x 16 x i8> %bc
}

define <vscale x 16 x i8> @bitcast_float_to_i8(<vscale x 4 x float> %v) {
; CHECK-LABEL: bitcast_float_to_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x float> %v to <vscale x 16 x i8>
  ret <vscale x 16 x i8> %bc
}

define <vscale x 16 x i8> @bitcast_double_to_i8(<vscale x 2 x double> %v) {
; CHECK-LABEL: bitcast_double_to_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x double> %v to <vscale x 16 x i8>
  ret <vscale x 16 x i8> %bc
}

define <vscale x 8 x i16> @bitcast_i8_to_i16(<vscale x 16 x i8> %v) {
; CHECK-LABEL: bitcast_i8_to_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 16 x i8> %v to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %bc
}

define <vscale x 8 x i16> @bitcast_i32_to_i16(<vscale x 4 x i32> %v) {
; CHECK-LABEL: bitcast_i32_to_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x i32> %v to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %bc
}

define <vscale x 8 x i16> @bitcast_i64_to_i16(<vscale x 2 x i64> %v) {
; CHECK-LABEL: bitcast_i64_to_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x i64> %v to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %bc
}

define <vscale x 8 x i16> @bitcast_half_to_i16(<vscale x 8 x half> %v) {
; CHECK-LABEL: bitcast_half_to_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x half> %v to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %bc
}

define <vscale x 8 x i16> @bitcast_float_to_i16(<vscale x 4 x float> %v) {
; CHECK-LABEL: bitcast_float_to_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x float> %v to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %bc
}

define <vscale x 8 x i16> @bitcast_double_to_i16(<vscale x 2 x double> %v) {
; CHECK-LABEL: bitcast_double_to_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x double> %v to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %bc
}

define <vscale x 4 x i32> @bitcast_i8_to_i32(<vscale x 16 x i8> %v) {
; CHECK-LABEL: bitcast_i8_to_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 16 x i8> %v to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %bc
}

define <vscale x 4 x i32> @bitcast_i16_to_i32(<vscale x 8 x i16> %v) {
; CHECK-LABEL: bitcast_i16_to_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x i16> %v to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %bc
}

define <vscale x 4 x i32> @bitcast_i64_to_i32(<vscale x 2 x i64> %v) {
; CHECK-LABEL: bitcast_i64_to_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x i64> %v to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %bc
}

define <vscale x 4 x i32> @bitcast_half_to_i32(<vscale x 8 x half> %v) {
; CHECK-LABEL: bitcast_half_to_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x half> %v to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %bc
}

define <vscale x 4 x i32> @bitcast_float_to_i32(<vscale x 4 x float> %v) {
; CHECK-LABEL: bitcast_float_to_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x float> %v to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %bc
}

define <vscale x 4 x i32> @bitcast_double_to_i32(<vscale x 2 x double> %v) {
; CHECK-LABEL: bitcast_double_to_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x double> %v to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %bc
}

define <vscale x 2 x i64> @bitcast_i8_to_i64(<vscale x 16 x i8> %v) {
; CHECK-LABEL: bitcast_i8_to_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 16 x i8> %v to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %bc
}

define <vscale x 2 x i64> @bitcast_i16_to_i64(<vscale x 8 x i16> %v) {
; CHECK-LABEL: bitcast_i16_to_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x i16> %v to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %bc
}

define <vscale x 2 x i64> @bitcast_i32_to_i64(<vscale x 4 x i32> %v) {
; CHECK-LABEL: bitcast_i32_to_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x i32> %v to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %bc
}

define <vscale x 2 x i64> @bitcast_half_to_i64(<vscale x 8 x half> %v) {
; CHECK-LABEL: bitcast_half_to_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x half> %v to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %bc
}

define <vscale x 2 x i64> @bitcast_float_to_i64(<vscale x 4 x float> %v) {
; CHECK-LABEL: bitcast_float_to_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x float> %v to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %bc
}

define <vscale x 2 x i64> @bitcast_double_to_i64(<vscale x 2 x double> %v) {
; CHECK-LABEL: bitcast_double_to_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x double> %v to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %bc
}

define <vscale x 8 x half> @bitcast_i8_to_half(<vscale x 16 x i8> %v) {
; CHECK-LABEL: bitcast_i8_to_half:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 16 x i8> %v to <vscale x 8 x half>
  ret <vscale x 8 x half> %bc
}

define <vscale x 8 x half> @bitcast_i16_to_half(<vscale x 8 x i16> %v) {
; CHECK-LABEL: bitcast_i16_to_half:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x i16> %v to <vscale x 8 x half>
  ret <vscale x 8 x half> %bc
}

define <vscale x 8 x half> @bitcast_i32_to_half(<vscale x 4 x i32> %v) {
; CHECK-LABEL: bitcast_i32_to_half:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x i32> %v to <vscale x 8 x half>
  ret <vscale x 8 x half> %bc
}

define <vscale x 8 x half> @bitcast_i64_to_half(<vscale x 2 x i64> %v) {
; CHECK-LABEL: bitcast_i64_to_half:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x i64> %v to <vscale x 8 x half>
  ret <vscale x 8 x half> %bc
}

define <vscale x 8 x half> @bitcast_float_to_half(<vscale x 4 x float> %v) {
; CHECK-LABEL: bitcast_float_to_half:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x float> %v to <vscale x 8 x half>
  ret <vscale x 8 x half> %bc
}

define <vscale x 8 x half> @bitcast_double_to_half(<vscale x 2 x double> %v) {
; CHECK-LABEL: bitcast_double_to_half:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x double> %v to <vscale x 8 x half>
  ret <vscale x 8 x half> %bc
}

define <vscale x 4 x float> @bitcast_i8_to_float(<vscale x 16 x i8> %v) {
; CHECK-LABEL: bitcast_i8_to_float:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 16 x i8> %v to <vscale x 4 x float>
  ret <vscale x 4 x float> %bc
}

define <vscale x 4 x float> @bitcast_i16_to_float(<vscale x 8 x i16> %v) {
; CHECK-LABEL: bitcast_i16_to_float:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x i16> %v to <vscale x 4 x float>
  ret <vscale x 4 x float> %bc
}

define <vscale x 4 x float> @bitcast_i32_to_float(<vscale x 4 x i32> %v) {
; CHECK-LABEL: bitcast_i32_to_float:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x i32> %v to <vscale x 4 x float>
  ret <vscale x 4 x float> %bc
}

define <vscale x 4 x float> @bitcast_i64_to_float(<vscale x 2 x i64> %v) {
; CHECK-LABEL: bitcast_i64_to_float:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x i64> %v to <vscale x 4 x float>
  ret <vscale x 4 x float> %bc
}

define <vscale x 4 x float> @bitcast_half_to_float(<vscale x 8 x half> %v) {
; CHECK-LABEL: bitcast_half_to_float:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x half> %v to <vscale x 4 x float>
  ret <vscale x 4 x float> %bc
}

define <vscale x 4 x float> @bitcast_double_to_float(<vscale x 2 x double> %v) {
; CHECK-LABEL: bitcast_double_to_float:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x double> %v to <vscale x 4 x float>
  ret <vscale x 4 x float> %bc
}

define <vscale x 2 x double> @bitcast_i8_to_double(<vscale x 16 x i8> %v) {
; CHECK-LABEL: bitcast_i8_to_double:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 16 x i8> %v to <vscale x 2 x double>
  ret <vscale x 2 x double> %bc
}

define <vscale x 2 x double> @bitcast_i16_to_double(<vscale x 8 x i16> %v) {
; CHECK-LABEL: bitcast_i16_to_double:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x i16> %v to <vscale x 2 x double>
  ret <vscale x 2 x double> %bc
}

define <vscale x 2 x double> @bitcast_i32_to_double(<vscale x 4 x i32> %v) {
; CHECK-LABEL: bitcast_i32_to_double:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x i32> %v to <vscale x 2 x double>
  ret <vscale x 2 x double> %bc
}

define <vscale x 2 x double> @bitcast_i64_to_double(<vscale x 2 x i64> %v) {
; CHECK-LABEL: bitcast_i64_to_double:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x i64> %v to <vscale x 2 x double>
  ret <vscale x 2 x double> %bc
}

define <vscale x 2 x double> @bitcast_half_to_double(<vscale x 8 x half> %v) {
; CHECK-LABEL: bitcast_half_to_double:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x half> %v to <vscale x 2 x double>
  ret <vscale x 2 x double> %bc
}

define <vscale x 2 x double> @bitcast_float_to_double(<vscale x 4 x float> %v) {
; CHECK-LABEL: bitcast_float_to_double:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x float> %v to <vscale x 2 x double>
  ret <vscale x 2 x double> %bc
}

define <vscale x 16 x i8> @bitcast_bfloat_to_i8(<vscale x 8 x bfloat> %v) #0 {
; CHECK-LABEL: bitcast_bfloat_to_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x bfloat> %v to <vscale x 16 x i8>
  ret <vscale x 16 x i8> %bc
}

define <vscale x 8 x i16> @bitcast_bfloat_to_i16(<vscale x 8 x bfloat> %v) #0 {
; CHECK-LABEL: bitcast_bfloat_to_i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x bfloat> %v to <vscale x 8 x i16>
  ret <vscale x 8 x i16> %bc
}

define <vscale x 4 x i32> @bitcast_bfloat_to_i32(<vscale x 8 x bfloat> %v) #0 {
; CHECK-LABEL: bitcast_bfloat_to_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x bfloat> %v to <vscale x 4 x i32>
  ret <vscale x 4 x i32> %bc
}

define <vscale x 2 x i64> @bitcast_bfloat_to_i64(<vscale x 8 x bfloat> %v) #0 {
; CHECK-LABEL: bitcast_bfloat_to_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x bfloat> %v to <vscale x 2 x i64>
  ret <vscale x 2 x i64> %bc
}

define <vscale x 8 x half> @bitcast_bfloat_to_half(<vscale x 8 x bfloat> %v) #0 {
; CHECK-LABEL: bitcast_bfloat_to_half:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x bfloat> %v to <vscale x 8 x half>
  ret <vscale x 8 x half> %bc
}

define <vscale x 4 x float> @bitcast_bfloat_to_float(<vscale x 8 x bfloat> %v) #0 {
; CHECK-LABEL: bitcast_bfloat_to_float:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x bfloat> %v to <vscale x 4 x float>
  ret <vscale x 4 x float> %bc
}

define <vscale x 2 x double> @bitcast_bfloat_to_double(<vscale x 8 x bfloat> %v) #0 {
; CHECK-LABEL: bitcast_bfloat_to_double:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x bfloat> %v to <vscale x 2 x double>
  ret <vscale x 2 x double> %bc
}

define <vscale x 8 x bfloat> @bitcast_i8_to_bfloat(<vscale x 16 x i8> %v) #0 {
; CHECK-LABEL: bitcast_i8_to_bfloat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 16 x i8> %v to <vscale x 8 x bfloat>
  ret <vscale x 8 x bfloat> %bc
}

define <vscale x 8 x bfloat> @bitcast_i16_to_bfloat(<vscale x 8 x i16> %v) #0 {
; CHECK-LABEL: bitcast_i16_to_bfloat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x i16> %v to <vscale x 8 x bfloat>
  ret <vscale x 8 x bfloat> %bc
}

define <vscale x 8 x bfloat> @bitcast_i32_to_bfloat(<vscale x 4 x i32> %v) #0 {
; CHECK-LABEL: bitcast_i32_to_bfloat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x i32> %v to <vscale x 8 x bfloat>
  ret <vscale x 8 x bfloat> %bc
}

define <vscale x 8 x bfloat> @bitcast_i64_to_bfloat(<vscale x 2 x i64> %v) #0 {
; CHECK-LABEL: bitcast_i64_to_bfloat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x i64> %v to <vscale x 8 x bfloat>
  ret <vscale x 8 x bfloat> %bc
}

define <vscale x 8 x bfloat> @bitcast_half_to_bfloat(<vscale x 8 x half> %v) #0 {
; CHECK-LABEL: bitcast_half_to_bfloat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 8 x half> %v to <vscale x 8 x bfloat>
  ret <vscale x 8 x bfloat> %bc
}

define <vscale x 8 x bfloat> @bitcast_float_to_bfloat(<vscale x 4 x float> %v) #0 {
; CHECK-LABEL: bitcast_float_to_bfloat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 4 x float> %v to <vscale x 8 x bfloat>
  ret <vscale x 8 x bfloat> %bc
}

define <vscale x 8 x bfloat> @bitcast_double_to_bfloat(<vscale x 2 x double> %v) #0 {
; CHECK-LABEL: bitcast_double_to_bfloat:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %bc = bitcast <vscale x 2 x double> %v to <vscale x 8 x bfloat>
  ret <vscale x 8 x bfloat> %bc
}

; +bf16 is required for the bfloat version.
attributes #0 = { "target-features"="+sve,+bf16" }
