; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -fast-isel -fast-isel-abort=1 -mtriple=aarch64-apple-darwin -verify-machineinstrs < %s | FileCheck %s

define zeroext i16 @asr_zext_i1_i16(i1 %b) {
; CHECK-LABEL: asr_zext_i1_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    uxth w0, wzr
; CHECK-NEXT:    ret
  %1 = zext i1 %b to i16
  %2 = ashr i16 %1, 1
  ret i16 %2
}

define signext i16 @asr_sext_i1_i16(i1 %b) {
; CHECK-LABEL: asr_sext_i1_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #0, #1
; CHECK-NEXT:    sxth w0, w8
; CHECK-NEXT:    ret
  %1 = sext i1 %b to i16
  %2 = ashr i16 %1, 1
  ret i16 %2
}

define i32 @asr_zext_i1_i32(i1 %b) {
; CHECK-LABEL: asr_zext_i1_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    ret
  %1 = zext i1 %b to i32
  %2 = ashr i32 %1, 1
  ret i32 %2
}

define i32 @asr_sext_i1_i32(i1 %b) {
; CHECK-LABEL: asr_sext_i1_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfx w0, w0, #0, #1
; CHECK-NEXT:    ret
  %1 = sext i1 %b to i32
  %2 = ashr i32 %1, 1
  ret i32 %2
}

define i64 @asr_zext_i1_i64(i1 %b) {
; CHECK-LABEL: asr_zext_i1_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov x0, xzr
; CHECK-NEXT:    ret
  %1 = zext i1 %b to i64
  %2 = ashr i64 %1, 1
  ret i64 %2
}

define i64 @asr_sext_i1_i64(i1 %b) {
; CHECK-LABEL: asr_sext_i1_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sbfx x0, x0, #0, #1
; CHECK-NEXT:    ret
  %1 = sext i1 %b to i64
  %2 = ashr i64 %1, 1
  ret i64 %2
}

define zeroext i16 @lsr_zext_i1_i16(i1 %b) {
; CHECK-LABEL: lsr_zext_i1_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    uxth w0, wzr
; CHECK-NEXT:    ret
  %1 = zext i1 %b to i16
  %2 = lshr i16 %1, 1
  ret i16 %2
}

define signext i16 @lsr_sext_i1_i16(i1 %b) {
; CHECK-LABEL: lsr_sext_i1_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #0, #1
; CHECK-NEXT:    ubfx w8, w8, #1, #15
; CHECK-NEXT:    sxth w0, w8
; CHECK-NEXT:    ret
  %1 = sext i1 %b to i16
  %2 = lshr i16 %1, 1
  ret i16 %2
}

define i32 @lsr_zext_i1_i32(i1 %b) {
; CHECK-LABEL: lsr_zext_i1_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov w0, wzr
; CHECK-NEXT:    ret
  %1 = zext i1 %b to i32
  %2 = lshr i32 %1, 1
  ret i32 %2
}

define i32 @lsr_sext_i1_i32(i1 %b) {
; CHECK-LABEL: lsr_sext_i1_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #0, #1
; CHECK-NEXT:    lsr w0, w8, #1
; CHECK-NEXT:    ret
  %1 = sext i1 %b to i32
  %2 = lshr i32 %1, 1
  ret i32 %2
}

define i64 @lsr_zext_i1_i64(i1 %b) {
; CHECK-LABEL: lsr_zext_i1_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    mov x0, xzr
; CHECK-NEXT:    ret
  %1 = zext i1 %b to i64
  %2 = lshr i64 %1, 1
  ret i64 %2
}

define zeroext i16 @lsl_zext_i1_i16(i1 %b) {
; CHECK-LABEL: lsl_zext_i1_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfiz w8, w0, #4, #1
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = zext i1 %b to i16
  %2 = shl i16 %1, 4
  ret i16 %2
}

define signext i16 @lsl_sext_i1_i16(i1 %b) {
; CHECK-LABEL: lsl_sext_i1_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfiz w8, w0, #4, #1
; CHECK-NEXT:    sxth w0, w8
; CHECK-NEXT:    ret
  %1 = sext i1 %b to i16
  %2 = shl i16 %1, 4
  ret i16 %2
}

define i32 @lsl_zext_i1_i32(i1 %b) {
; CHECK-LABEL: lsl_zext_i1_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfiz w0, w0, #4, #1
; CHECK-NEXT:    ret
  %1 = zext i1 %b to i32
  %2 = shl i32 %1, 4
  ret i32 %2
}

define i32 @lsl_sext_i1_i32(i1 %b) {
; CHECK-LABEL: lsl_sext_i1_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfiz w0, w0, #4, #1
; CHECK-NEXT:    ret
  %1 = sext i1 %b to i32
  %2 = shl i32 %1, 4
  ret i32 %2
}

define i64 @lsl_zext_i1_i64(i1 %b) {
; CHECK-LABEL: lsl_zext_i1_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    ubfiz x0, x0, #4, #1
; CHECK-NEXT:    ret
  %1 = zext i1 %b to i64
  %2 = shl i64 %1, 4
  ret i64 %2
}

define i64 @lsl_sext_i1_i64(i1 %b) {
; CHECK-LABEL: lsl_sext_i1_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sbfiz x0, x0, #4, #1
; CHECK-NEXT:    ret
  %1 = sext i1 %b to i64
  %2 = shl i64 %1, 4
  ret i64 %2
}

define zeroext i8 @lslv_i8(i8 %a, i8 %b) {
; CHECK-LABEL: lslv_i8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    and w8, w1, #0xff
; CHECK-NEXT:    lsl w8, w0, w8
; CHECK-NEXT:    and w8, w8, #0xff
; CHECK-NEXT:    uxtb w0, w8
; CHECK-NEXT:    ret
  %1 = shl i8 %a, %b
  ret i8 %1
}

define zeroext i8 @lsl_i8(i8 %a) {
; CHECK-LABEL: lsl_i8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfiz w8, w0, #4, #4
; CHECK-NEXT:    uxtb w0, w8
; CHECK-NEXT:    ret
  %1 = shl i8 %a, 4
  ret i8 %1
}

define zeroext i16 @lsl_zext_i8_i16(i8 %b) {
; CHECK-LABEL: lsl_zext_i8_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfiz w8, w0, #4, #8
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = zext i8 %b to i16
  %2 = shl i16 %1, 4
  ret i16 %2
}

define signext i16 @lsl_sext_i8_i16(i8 %b) {
; CHECK-LABEL: lsl_sext_i8_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfiz w8, w0, #4, #8
; CHECK-NEXT:    sxth w0, w8
; CHECK-NEXT:    ret
  %1 = sext i8 %b to i16
  %2 = shl i16 %1, 4
  ret i16 %2
}

define i32 @lsl_zext_i8_i32(i8 %b) {
; CHECK-LABEL: lsl_zext_i8_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfiz w0, w0, #4, #8
; CHECK-NEXT:    ret
  %1 = zext i8 %b to i32
  %2 = shl i32 %1, 4
  ret i32 %2
}

define i32 @lsl_sext_i8_i32(i8 %b) {
; CHECK-LABEL: lsl_sext_i8_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfiz w0, w0, #4, #8
; CHECK-NEXT:    ret
  %1 = sext i8 %b to i32
  %2 = shl i32 %1, 4
  ret i32 %2
}

define i64 @lsl_zext_i8_i64(i8 %b) {
; CHECK-LABEL: lsl_zext_i8_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    ubfiz x0, x0, #4, #8
; CHECK-NEXT:    ret
  %1 = zext i8 %b to i64
  %2 = shl i64 %1, 4
  ret i64 %2
}

define i64 @lsl_sext_i8_i64(i8 %b) {
; CHECK-LABEL: lsl_sext_i8_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sbfiz x0, x0, #4, #8
; CHECK-NEXT:    ret
  %1 = sext i8 %b to i64
  %2 = shl i64 %1, 4
  ret i64 %2
}

define zeroext i16 @lslv_i16(i16 %a, i16 %b) {
; CHECK-LABEL: lslv_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    and w8, w1, #0xffff
; CHECK-NEXT:    lsl w8, w0, w8
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = shl i16 %a, %b
  ret i16 %1
}

define zeroext i16 @lsl_i16(i16 %a) {
; CHECK-LABEL: lsl_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfiz w8, w0, #8, #8
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = shl i16 %a, 8
  ret i16 %1
}

define i32 @lsl_zext_i16_i32(i16 %b) {
; CHECK-LABEL: lsl_zext_i16_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfiz w0, w0, #8, #16
; CHECK-NEXT:    ret
  %1 = zext i16 %b to i32
  %2 = shl i32 %1, 8
  ret i32 %2
}

define i32 @lsl_sext_i16_i32(i16 %b) {
; CHECK-LABEL: lsl_sext_i16_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfiz w0, w0, #8, #16
; CHECK-NEXT:    ret
  %1 = sext i16 %b to i32
  %2 = shl i32 %1, 8
  ret i32 %2
}

define i64 @lsl_zext_i16_i64(i16 %b) {
; CHECK-LABEL: lsl_zext_i16_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    ubfiz x0, x0, #8, #16
; CHECK-NEXT:    ret
  %1 = zext i16 %b to i64
  %2 = shl i64 %1, 8
  ret i64 %2
}

define i64 @lsl_sext_i16_i64(i16 %b) {
; CHECK-LABEL: lsl_sext_i16_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sbfiz x0, x0, #8, #16
; CHECK-NEXT:    ret
  %1 = sext i16 %b to i64
  %2 = shl i64 %1, 8
  ret i64 %2
}

define zeroext i32 @lslv_i32(i32 %a, i32 %b) {
; CHECK-LABEL: lslv_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsl w0, w0, w1
; CHECK-NEXT:    ret
  %1 = shl i32 %a, %b
  ret i32 %1
}

define zeroext i32 @lsl_i32(i32 %a) {
; CHECK-LABEL: lsl_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsl w0, w0, #16
; CHECK-NEXT:    ret
  %1 = shl i32 %a, 16
  ret i32 %1
}

define i64 @lsl_zext_i32_i64(i32 %b) {
; CHECK-LABEL: lsl_zext_i32_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    ubfiz x0, x0, #16, #32
; CHECK-NEXT:    ret
  %1 = zext i32 %b to i64
  %2 = shl i64 %1, 16
  ret i64 %2
}

define i64 @lsl_sext_i32_i64(i32 %b) {
; CHECK-LABEL: lsl_sext_i32_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sbfiz x0, x0, #16, #32
; CHECK-NEXT:    ret
  %1 = sext i32 %b to i64
  %2 = shl i64 %1, 16
  ret i64 %2
}

define i64 @lslv_i64(i64 %a, i64 %b) {
; CHECK-LABEL: lslv_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsl x0, x0, x1
; CHECK-NEXT:    ret
  %1 = shl i64 %a, %b
  ret i64 %1
}

define i64 @lsl_i64(i64 %a) {
; CHECK-LABEL: lsl_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsl x0, x0, #32
; CHECK-NEXT:    ret
  %1 = shl i64 %a, 32
  ret i64 %1
}

define zeroext i8 @lsrv_i8(i8 %a, i8 %b) {
; CHECK-LABEL: lsrv_i8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    and w8, w1, #0xff
; CHECK-NEXT:    and w9, w0, #0xff
; CHECK-NEXT:    lsr w8, w9, w8
; CHECK-NEXT:    and w8, w8, #0xff
; CHECK-NEXT:    uxtb w0, w8
; CHECK-NEXT:    ret
  %1 = lshr i8 %a, %b
  ret i8 %1
}

define zeroext i8 @lsr_i8(i8 %a) {
; CHECK-LABEL: lsr_i8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfx w8, w0, #4, #4
; CHECK-NEXT:    uxtb w0, w8
; CHECK-NEXT:    ret
  %1 = lshr i8 %a, 4
  ret i8 %1
}

define zeroext i16 @lsr_zext_i8_i16(i8 %b) {
; CHECK-LABEL: lsr_zext_i8_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfx w8, w0, #4, #4
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = zext i8 %b to i16
  %2 = lshr i16 %1, 4
  ret i16 %2
}

define signext i16 @lsr_sext_i8_i16(i8 %b) {
; CHECK-LABEL: lsr_sext_i8_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sxtb w8, w0
; CHECK-NEXT:    ubfx w8, w8, #4, #12
; CHECK-NEXT:    sxth w0, w8
; CHECK-NEXT:    ret
  %1 = sext i8 %b to i16
  %2 = lshr i16 %1, 4
  ret i16 %2
}

define i32 @lsr_zext_i8_i32(i8 %b) {
; CHECK-LABEL: lsr_zext_i8_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfx w0, w0, #4, #4
; CHECK-NEXT:    ret
  %1 = zext i8 %b to i32
  %2 = lshr i32 %1, 4
  ret i32 %2
}

define i32 @lsr_sext_i8_i32(i8 %b) {
; CHECK-LABEL: lsr_sext_i8_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sxtb w8, w0
; CHECK-NEXT:    lsr w0, w8, #4
; CHECK-NEXT:    ret
  %1 = sext i8 %b to i32
  %2 = lshr i32 %1, 4
  ret i32 %2
}

define zeroext i16 @lsrv_i16(i16 %a, i16 %b) {
; CHECK-LABEL: lsrv_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    and w8, w1, #0xffff
; CHECK-NEXT:    and w9, w0, #0xffff
; CHECK-NEXT:    lsr w8, w9, w8
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = lshr i16 %a, %b
  ret i16 %1
}

define zeroext i16 @lsr_i16(i16 %a) {
; CHECK-LABEL: lsr_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfx w8, w0, #8, #8
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = lshr i16 %a, 8
  ret i16 %1
}

define zeroext i32 @lsrv_i32(i32 %a, i32 %b) {
; CHECK-LABEL: lsrv_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsr w0, w0, w1
; CHECK-NEXT:    ret
  %1 = lshr i32 %a, %b
  ret i32 %1
}

define zeroext i32 @lsr_i32(i32 %a) {
; CHECK-LABEL: lsr_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsr w0, w0, #16
; CHECK-NEXT:    ret
  %1 = lshr i32 %a, 16
  ret i32 %1
}

define i64 @lsrv_i64(i64 %a, i64 %b) {
; CHECK-LABEL: lsrv_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsr x0, x0, x1
; CHECK-NEXT:    ret
  %1 = lshr i64 %a, %b
  ret i64 %1
}

define i64 @lsr_i64(i64 %a) {
; CHECK-LABEL: lsr_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsr x0, x0, #32
; CHECK-NEXT:    ret
  %1 = lshr i64 %a, 32
  ret i64 %1
}

define zeroext i8 @asrv_i8(i8 %a, i8 %b) {
; CHECK-LABEL: asrv_i8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    and w8, w1, #0xff
; CHECK-NEXT:    sxtb w9, w0
; CHECK-NEXT:    asr w8, w9, w8
; CHECK-NEXT:    and w8, w8, #0xff
; CHECK-NEXT:    uxtb w0, w8
; CHECK-NEXT:    ret
  %1 = ashr i8 %a, %b
  ret i8 %1
}

define zeroext i8 @asr_i8(i8 %a) {
; CHECK-LABEL: asr_i8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #4, #4
; CHECK-NEXT:    uxtb w0, w8
; CHECK-NEXT:    ret
  %1 = ashr i8 %a, 4
  ret i8 %1
}

define zeroext i16 @asr_zext_i8_i16(i8 %b) {
; CHECK-LABEL: asr_zext_i8_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfx w8, w0, #4, #4
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = zext i8 %b to i16
  %2 = ashr i16 %1, 4
  ret i16 %2
}

define signext i16 @asr_sext_i8_i16(i8 %b) {
; CHECK-LABEL: asr_sext_i8_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #4, #4
; CHECK-NEXT:    sxth w0, w8
; CHECK-NEXT:    ret
  %1 = sext i8 %b to i16
  %2 = ashr i16 %1, 4
  ret i16 %2
}

define i32 @asr_zext_i8_i32(i8 %b) {
; CHECK-LABEL: asr_zext_i8_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfx w0, w0, #4, #4
; CHECK-NEXT:    ret
  %1 = zext i8 %b to i32
  %2 = ashr i32 %1, 4
  ret i32 %2
}

define i32 @asr_sext_i8_i32(i8 %b) {
; CHECK-LABEL: asr_sext_i8_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfx w0, w0, #4, #4
; CHECK-NEXT:    ret
  %1 = sext i8 %b to i32
  %2 = ashr i32 %1, 4
  ret i32 %2
}

define zeroext i16 @asrv_i16(i16 %a, i16 %b) {
; CHECK-LABEL: asrv_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    and w8, w1, #0xffff
; CHECK-NEXT:    sxth w9, w0
; CHECK-NEXT:    asr w8, w9, w8
; CHECK-NEXT:    and w8, w8, #0xffff
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = ashr i16 %a, %b
  ret i16 %1
}

define zeroext i16 @asr_i16(i16 %a) {
; CHECK-LABEL: asr_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sbfx w8, w0, #8, #8
; CHECK-NEXT:    uxth w0, w8
; CHECK-NEXT:    ret
  %1 = ashr i16 %a, 8
  ret i16 %1
}

define zeroext i32 @asrv_i32(i32 %a, i32 %b) {
; CHECK-LABEL: asrv_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    asr w0, w0, w1
; CHECK-NEXT:    ret
  %1 = ashr i32 %a, %b
  ret i32 %1
}

define zeroext i32 @asr_i32(i32 %a) {
; CHECK-LABEL: asr_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    asr w0, w0, #16
; CHECK-NEXT:    ret
  %1 = ashr i32 %a, 16
  ret i32 %1
}

define i64 @asrv_i64(i64 %a, i64 %b) {
; CHECK-LABEL: asrv_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    asr x0, x0, x1
; CHECK-NEXT:    ret
  %1 = ashr i64 %a, %b
  ret i64 %1
}

define i64 @asr_i64(i64 %a) {
; CHECK-LABEL: asr_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    asr x0, x0, #32
; CHECK-NEXT:    ret
  %1 = ashr i64 %a, 32
  ret i64 %1
}

define i32 @shift_test1(i8 %a) {
; CHECK-LABEL: shift_test1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ubfiz w8, w0, #4, #4
; CHECK-NEXT:    sbfx w8, w8, #4, #4
; CHECK-NEXT:    sxtb w0, w8
; CHECK-NEXT:    ret
  %1 = shl i8 %a, 4
  %2 = ashr i8 %1, 4
  %3 = sext i8 %2 to i32
  ret i32 %3
}

; Test zero shifts

define i32 @shl_zero(i32 %a) {
; CHECK-LABEL: shl_zero:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ret
  %1 = shl i32 %a, 0
  ret i32 %1
}

define i32 @lshr_zero(i32 %a) {
; CHECK-LABEL: lshr_zero:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ret
  %1 = lshr i32 %a, 0
  ret i32 %1
}

define i32 @ashr_zero(i32 %a) {
; CHECK-LABEL: ashr_zero:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ret
  %1 = ashr i32 %a, 0
  ret i32 %1
}

define i64 @shl_zext_zero(i32 %a) {
; CHECK-LABEL: shl_zext_zero:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    ubfx x0, x0, #0, #32
; CHECK-NEXT:    ret
  %1 = zext i32 %a to i64
  %2 = shl i64 %1, 0
  ret i64 %2
}

define i64 @lshr_zext_zero(i32 %a) {
; CHECK-LABEL: lshr_zext_zero:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    ubfx x0, x0, #0, #32
; CHECK-NEXT:    ret
  %1 = zext i32 %a to i64
  %2 = lshr i64 %1, 0
  ret i64 %2
}

define i64 @ashr_zext_zero(i32 %a) {
; CHECK-LABEL: ashr_zext_zero:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    ubfx x0, x0, #0, #32
; CHECK-NEXT:    ret
  %1 = zext i32 %a to i64
  %2 = ashr i64 %1, 0
  ret i64 %2
}

