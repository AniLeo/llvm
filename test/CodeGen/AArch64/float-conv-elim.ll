; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-- < %s | FileCheck %s

define i32 @s32_f32_s24_s32(i32 %a) {
; CHECK-LABEL: s32_f32_s24_s32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w0, w0, #0, #24
; CHECK-NEXT:    ret
  %f = sitofp i32 %a to float
  %i = fptosi float %f to i24
  %r = sext i24 %i to i32
  ret i32 %r
}

define i32 @s32_f32_u24_u32(i32 %a) {
; CHECK-LABEL: s32_f32_u24_u32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w0, w0, #0xffffff
; CHECK-NEXT:    ret
  %f = sitofp i32 %a to float
  %i = fptoui float %f to i24
  %r = zext i24 %i to i32
  ret i32 %r
}

define i32 @u32_f32_s24_s32(i32 %a) {
; CHECK-LABEL: u32_f32_s24_s32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w0, w0, #0, #24
; CHECK-NEXT:    ret
  %f = uitofp i32 %a to float
  %i = fptosi float %f to i24
  %r = sext i24 %i to i32
  ret i32 %r
}

define i32 @u32_f32_u24_u32(i32 %a) {
; CHECK-LABEL: u32_f32_u24_u32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    and w0, w0, #0xffffff
; CHECK-NEXT:    ret
  %f = uitofp i32 %a to float
  %i = fptoui float %f to i24
  %r = zext i24 %i to i32
  ret i32 %r
}

define i32 @s32_f32_s25_s32(i32 %a) {
; CHECK-LABEL: s32_f32_s25_s32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w0, w0, #0, #25
; CHECK-NEXT:    ret
  %f = sitofp i32 %a to float
  %i = fptosi float %f to i25
  %r = sext i25 %i to i32
  ret i32 %r
}

define i32 @s32_f32_u25_u32(i32 %a) {
; CHECK-LABEL: s32_f32_u25_u32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    scvtf s0, w0
; CHECK-NEXT:    fcvtzs w0, s0
; CHECK-NEXT:    ret
  %f = sitofp i32 %a to float
  %i = fptoui float %f to i25
  %r = zext i25 %i to i32
  ret i32 %r
}

define i32 @u32_f32_s25_s32(i32 %a) {
; CHECK-LABEL: u32_f32_s25_s32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx w0, w0, #0, #25
; CHECK-NEXT:    ret
  %f = uitofp i32 %a to float
  %i = fptosi float %f to i25
  %r = sext i25 %i to i32
  ret i32 %r
}

define i32 @u32_f32_u25_u32(i32 %a) {
; CHECK-LABEL: u32_f32_u25_u32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ucvtf s0, w0
; CHECK-NEXT:    fcvtzs w0, s0
; CHECK-NEXT:    ret
  %f = uitofp i32 %a to float
  %i = fptoui float %f to i25
  %r = zext i25 %i to i32
  ret i32 %r
}
