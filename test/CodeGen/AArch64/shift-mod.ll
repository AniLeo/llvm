; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64 < %s | FileCheck %s

; Check that we optimize out AND instructions and ADD/SUB instructions
; modulo the shift size to take advantage of the implicit mod done on
; the shift amount value by the variable shift/rotate instructions.

define i32 @test1(i32 %x, i64 %y) {
; CHECK-LABEL: test1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w0, w0, w1
; CHECK-NEXT:    ret
  %sh_prom = trunc i64 %y to i32
  %shr = lshr i32 %x, %sh_prom
  ret i32 %shr
}

define i64 @test2(i32 %x, i64 %y) {
; CHECK-LABEL: test2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w[[REG:[0-9]+]], w0
; CHECK-NEXT:    asr x0, x1, x[[REG]]
; CHECK-NEXT:    ret
  %sub9 = sub nsw i32 64, %x
  %sh_prom12.i = zext i32 %sub9 to i64
  %shr.i = ashr i64 %y, %sh_prom12.i
  ret i64 %shr.i
}

define i64 @test3(i64 %x, i64 %y) {
; CHECK-LABEL: test3:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsl x0, x1, x0
; CHECK-NEXT:    ret
  %add = add nsw i64 64, %x
  %shl = shl i64 %y, %add
  ret i64 %shl
}

define i64 @test4(i64 %y, i32 %s) {
; CHECK-LABEL: test4:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    asr x0, x0, x1
; CHECK-NEXT:    ret
entry:
  %sh_prom = zext i32 %s to i64
  %shr = ashr i64 %y, %sh_prom
  ret i64 %shr
}

define i64 @test5(i64 %y, i32 %s) {
; CHECK-LABEL: test5:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    asr x0, x0, x1
; CHECK-NEXT:    ret
entry:
  %sh_prom = sext i32 %s to i64
  %shr = ashr i64 %y, %sh_prom
  ret i64 %shr
}

define i64 @test6(i64 %y, i32 %s) {
; CHECK-LABEL: test6:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsl x0, x0, x1
; CHECK-NEXT:    ret
entry:
  %sh_prom = sext i32 %s to i64
  %shr = shl i64 %y, %sh_prom
  ret i64 %shr
}

; PR42644 - https://bugs.llvm.org/show_bug.cgi?id=42644

define i64 @ashr_add_shl_i32(i64 %r) {
; CHECK-LABEL: ashr_add_shl_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #1
; CHECK-NEXT:    sxtw x0, w8
; CHECK-NEXT:    ret
  %conv = shl i64 %r, 32
  %sext = add i64 %conv, 4294967296
  %conv1 = ashr i64 %sext, 32
  ret i64 %conv1
}

define i64 @ashr_add_shl_i8(i64 %r) {
; CHECK-LABEL: ashr_add_shl_i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w0, #1
; CHECK-NEXT:    sxtb x0, w8
; CHECK-NEXT:    ret
  %conv = shl i64 %r, 56
  %sext = add i64 %conv, 72057594037927936
  %conv1 = ashr i64 %sext, 56
  ret i64 %conv1
}

define <4 x i32> @ashr_add_shl_v4i8(<4 x i32> %r) {
; CHECK-LABEL: ashr_add_shl_v4i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    shl v0.4s, v0.4s, #24
; CHECK-NEXT:    movi v1.4s, #1, lsl #24
; CHECK-NEXT:    add v0.4s, v0.4s, v1.4s
; CHECK-NEXT:    sshr v0.4s, v0.4s, #24
; CHECK-NEXT:    ret
  %conv = shl <4 x i32> %r, <i32 24, i32 24, i32 24, i32 24>
  %sext = add <4 x i32> %conv, <i32 16777216, i32 16777216, i32 16777216, i32 16777216>
  %conv1 = ashr <4 x i32> %sext, <i32 24, i32 24, i32 24, i32 24>
  ret <4 x i32> %conv1
}

define i64 @ashr_add_shl_i36(i64 %r) {
; CHECK-LABEL: ashr_add_shl_i36:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sbfx x0, x0, #0, #28
; CHECK-NEXT:    ret
  %conv = shl i64 %r, 36
  %sext = add i64 %conv, 4294967296
  %conv1 = ashr i64 %sext, 36
  ret i64 %conv1
}

define i64 @ashr_add_shl_mismatch_shifts1(i64 %r) {
; CHECK-LABEL: ashr_add_shl_mismatch_shifts1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #4294967296
; CHECK-NEXT:    add x8, x8, x0, lsl #8
; CHECK-NEXT:    asr x0, x8, #32
; CHECK-NEXT:    ret
  %conv = shl i64 %r, 8
  %sext = add i64 %conv, 4294967296
  %conv1 = ashr i64 %sext, 32
  ret i64 %conv1
}

define i64 @ashr_add_shl_mismatch_shifts2(i64 %r) {
; CHECK-LABEL: ashr_add_shl_mismatch_shifts2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x8, #4294967296
; CHECK-NEXT:    add x8, x8, x0, lsr #8
; CHECK-NEXT:    lsr x0, x8, #8
; CHECK-NEXT:    ret
  %conv = lshr i64 %r, 8
  %sext = add i64 %conv, 4294967296
  %conv1 = ashr i64 %sext, 8
  ret i64 %conv1
}
