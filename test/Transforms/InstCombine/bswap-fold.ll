; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=instcombine -S | FileCheck %s

; rdar://5992453
; A & 255
define i32 @test4(i32 %a) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[T2:%.*]] = and i32 [[A:%.*]], 255
; CHECK-NEXT:    ret i32 [[T2]]
;
  %t2 = call i32 @llvm.bswap.i32( i32 %a )
  %t4 = lshr i32 %t2, 24
  ret i32 %t4
}

; a >> 24
define i32 @test6(i32 %a) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    [[T2:%.*]] = lshr i32 [[A:%.*]], 24
; CHECK-NEXT:    ret i32 [[T2]]
;
  %t2 = call i32 @llvm.bswap.i32( i32 %a )
  %t4 = and i32 %t2, 255
  ret i32 %t4
}

define i32 @lshr8_i32(i32 %x) {
; CHECK-LABEL: @lshr8_i32(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @llvm.bswap.i32(i32 [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = shl i32 [[TMP1]], 8
; CHECK-NEXT:    ret i32 [[R]]
;
  %s = lshr i32 %x, 8
  %r = call i32 @llvm.bswap.i32(i32 %s)
  ret i32 %r
}

define <2 x i32> @lshr16_v2i32(<2 x i32> %x) {
; CHECK-LABEL: @lshr16_v2i32(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = shl <2 x i32> [[TMP1]], <i32 16, i32 16>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %s = lshr <2 x i32> %x, <i32 16, i32 16>
  %r = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %s)
  ret <2 x i32> %r
}

define i32 @lshr24_i32(i32 %x) {
; CHECK-LABEL: @lshr24_i32(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[X:%.*]], -16777216
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %s = lshr i32 %x, 24
  %r = call i32 @llvm.bswap.i32(i32 %s)
  ret i32 %r
}

; negative test - need shift-by-8-bit-multiple

define i32 @lshr12_i32(i32 %x) {
; CHECK-LABEL: @lshr12_i32(
; CHECK-NEXT:    [[S:%.*]] = lshr i32 [[X:%.*]], 12
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.bswap.i32(i32 [[S]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %s = lshr i32 %x, 12
  %r = call i32 @llvm.bswap.i32(i32 %s)
  ret i32 %r
}

; negative test - uses

define i32 @lshr8_i32_use(i32 %x, i32* %p) {
; CHECK-LABEL: @lshr8_i32_use(
; CHECK-NEXT:    [[S:%.*]] = lshr i32 [[X:%.*]], 12
; CHECK-NEXT:    store i32 [[S]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.bswap.i32(i32 [[S]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %s = lshr i32 %x, 12
  store i32 %s, i32* %p
  %r = call i32 @llvm.bswap.i32(i32 %s)
  ret i32 %r
}

define i64 @shl16_i64(i64 %x) {
; CHECK-LABEL: @shl16_i64(
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.bswap.i64(i64 [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = lshr i64 [[TMP1]], 16
; CHECK-NEXT:    ret i64 [[R]]
;
  %s = shl i64 %x, 16
  %r = call i64 @llvm.bswap.i64(i64 %s)
  ret i64 %r
}

; poison vector element propagates

define <2 x i64> @shl16_v2i64(<2 x i64> %x) {
; CHECK-LABEL: @shl16_v2i64(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = lshr <2 x i64> [[TMP1]], <i64 poison, i64 24>
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %s = shl <2 x i64> %x, <i64 poison, i64 24>
  %r = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %s)
  ret <2 x i64> %r
}

define i64 @shl56_i64(i64 %x) {
; CHECK-LABEL: @shl56_i64(
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[X:%.*]], 255
; CHECK-NEXT:    ret i64 [[TMP1]]
;
  %s = shl i64 %x, 56
  %r = call i64 @llvm.bswap.i64(i64 %s)
  ret i64 %r
}

; negative test - need shift-by-8-bit-multiple

define i64 @shl42_i64(i64 %x) {
; CHECK-LABEL: @shl42_i64(
; CHECK-NEXT:    [[S:%.*]] = shl i64 [[X:%.*]], 42
; CHECK-NEXT:    [[R:%.*]] = call i64 @llvm.bswap.i64(i64 [[S]])
; CHECK-NEXT:    ret i64 [[R]]
;
  %s = shl i64 %x, 42
  %r = call i64 @llvm.bswap.i64(i64 %s)
  ret i64 %r
}

; negative test - uses

define i32 @shl8_i32_use(i32 %x, i32* %p) {
; CHECK-LABEL: @shl8_i32_use(
; CHECK-NEXT:    [[S:%.*]] = shl i32 [[X:%.*]], 8
; CHECK-NEXT:    store i32 [[S]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = call i32 @llvm.bswap.i32(i32 [[S]])
; CHECK-NEXT:    ret i32 [[R]]
;
  %s = shl i32 %x, 8
  store i32 %s, i32* %p
  %r = call i32 @llvm.bswap.i32(i32 %s)
  ret i32 %r
}

; swaps cancel

define i64 @swap_shl16_i64(i64 %x) {
; CHECK-LABEL: @swap_shl16_i64(
; CHECK-NEXT:    [[R:%.*]] = lshr i64 [[X:%.*]], 16
; CHECK-NEXT:    ret i64 [[R]]
;
  %b = call i64 @llvm.bswap.i64(i64 %x)
  %s = shl i64 %b, 16
  %r = call i64 @llvm.bswap.i64(i64 %s)
  ret i64 %r
}

; canonicalize shift after bswap if shift amount is multiple of 8-bits
; (including non-uniform vector elements)

define <2 x i32> @variable_lshr_v2i32(<2 x i32> %x, <2 x i32> %n) {
; CHECK-LABEL: @variable_lshr_v2i32(
; CHECK-NEXT:    [[SHAMT:%.*]] = and <2 x i32> [[N:%.*]], <i32 -8, i32 -16>
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[X:%.*]])
; CHECK-NEXT:    [[R:%.*]] = lshr <2 x i32> [[TMP1]], [[SHAMT]]
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %shamt = and <2 x i32> %n, <i32 -8, i32 -16>
  %s = shl <2 x i32> %x, %shamt
  %r = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %s)
  ret <2 x i32> %r
}

; PR55327 - swaps cancel

define i64 @variable_shl_i64(i64 %x, i64 %n) {
; CHECK-LABEL: @variable_shl_i64(
; CHECK-NEXT:    [[N8:%.*]] = shl i64 [[N:%.*]], 3
; CHECK-NEXT:    [[SHAMT:%.*]] = and i64 [[N8]], 56
; CHECK-NEXT:    [[R:%.*]] = lshr i64 [[X:%.*]], [[SHAMT]]
; CHECK-NEXT:    ret i64 [[R]]
;
  %b = tail call i64 @llvm.bswap.i64(i64 %x)
  %n8 = shl i64 %n, 3
  %shamt = and i64 %n8, 56
  %s = shl i64 %b, %shamt
  %r = tail call i64 @llvm.bswap.i64(i64 %s)
  ret i64 %r
}

; negative test - must have multiple of 8-bit shift amount

define i64 @variable_shl_not_masked_enough_i64(i64 %x, i64 %n) {
; CHECK-LABEL: @variable_shl_not_masked_enough_i64(
; CHECK-NEXT:    [[SHAMT:%.*]] = and i64 [[N:%.*]], -4
; CHECK-NEXT:    [[S:%.*]] = shl i64 [[X:%.*]], [[SHAMT]]
; CHECK-NEXT:    [[R:%.*]] = call i64 @llvm.bswap.i64(i64 [[S]])
; CHECK-NEXT:    ret i64 [[R]]
;
  %shamt = and i64 %n, -4
  %s = shl i64 %x, %shamt
  %r = call i64 @llvm.bswap.i64(i64 %s)
  ret i64 %r
}

; PR5284
define i16 @test7(i32 %A) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i32 [[A:%.*]], 16
; CHECK-NEXT:    [[D:%.*]] = trunc i32 [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[D]]
;
  %B = tail call i32 @llvm.bswap.i32(i32 %A) nounwind
  %C = trunc i32 %B to i16
  %D = tail call i16 @llvm.bswap.i16(i16 %C) nounwind
  ret i16 %D
}

define <2 x i16> @test7_vector(<2 x i32> %A) {
; CHECK-LABEL: @test7_vector(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i32> [[A:%.*]], <i32 16, i32 16>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i32> [[TMP1]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[D]]
;
  %B = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %A) nounwind
  %C = trunc <2 x i32> %B to <2 x i16>
  %D = tail call <2 x i16> @llvm.bswap.v2i16(<2 x i16> %C) nounwind
  ret <2 x i16> %D
}

define i16 @test8(i64 %A) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr i64 [[A:%.*]], 48
; CHECK-NEXT:    [[D:%.*]] = trunc i64 [[TMP1]] to i16
; CHECK-NEXT:    ret i16 [[D]]
;
  %B = tail call i64 @llvm.bswap.i64(i64 %A) nounwind
  %C = trunc i64 %B to i16
  %D = tail call i16 @llvm.bswap.i16(i16 %C) nounwind
  ret i16 %D
}

define <2 x i16> @test8_vector(<2 x i64> %A) {
; CHECK-LABEL: @test8_vector(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <2 x i64> [[A:%.*]], <i64 48, i64 48>
; CHECK-NEXT:    [[D:%.*]] = trunc <2 x i64> [[TMP1]] to <2 x i16>
; CHECK-NEXT:    ret <2 x i16> [[D]]
;
  %B = tail call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %A) nounwind
  %C = trunc <2 x i64> %B to <2 x i16>
  %D = tail call <2 x i16> @llvm.bswap.v2i16(<2 x i16> %C) nounwind
  ret <2 x i16> %D
}

; Misc: Fold bswap(undef) to undef.
define i64 @foo() {
; CHECK-LABEL: @foo(
; CHECK-NEXT:    ret i64 undef
;
  %a = call i64 @llvm.bswap.i64(i64 undef)
  ret i64 %a
}

; PR15782
; Fold: OP( BSWAP(x), BSWAP(y) ) -> BSWAP( OP(x, y) )
; Fold: OP( BSWAP(x), CONSTANT ) -> BSWAP( OP(x, BSWAP(CONSTANT) ) )
define i16 @bs_and16i(i16 %a, i16 %b) #0 {
; CHECK-LABEL: @bs_and16i(
; CHECK-NEXT:    [[TMP1:%.*]] = and i16 [[A:%.*]], 4391
; CHECK-NEXT:    [[TMP2:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %1 = tail call i16 @llvm.bswap.i16(i16 %a)
  %2 = and i16 %1, 10001
  ret i16 %2
}

define i16 @bs_and16(i16 %a, i16 %b) #0 {
; CHECK-LABEL: @bs_and16(
; CHECK-NEXT:    [[TMP1:%.*]] = and i16 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %t1 = tail call i16 @llvm.bswap.i16(i16 %a)
  %t2 = tail call i16 @llvm.bswap.i16(i16 %b)
  %t3 = and i16 %t1, %t2
  ret i16 %t3
}

define i16 @bs_or16(i16 %a, i16 %b) #0 {
; CHECK-LABEL: @bs_or16(
; CHECK-NEXT:    [[TMP1:%.*]] = or i16 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %t1 = tail call i16 @llvm.bswap.i16(i16 %a)
  %t2 = tail call i16 @llvm.bswap.i16(i16 %b)
  %t3 = or i16 %t1, %t2
  ret i16 %t3
}

define i16 @bs_xor16(i16 %a, i16 %b) #0 {
; CHECK-LABEL: @bs_xor16(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i16 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i16 @llvm.bswap.i16(i16 [[TMP1]])
; CHECK-NEXT:    ret i16 [[TMP2]]
;
  %t1 = tail call i16 @llvm.bswap.i16(i16 %a)
  %t2 = tail call i16 @llvm.bswap.i16(i16 %b)
  %t3 = xor i16 %t1, %t2
  ret i16 %t3
}

define i32 @bs_and32i(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @bs_and32i(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], -1585053440
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %t1 = tail call i32 @llvm.bswap.i32(i32 %a)
  %t2 = and i32 %t1, 100001
  ret i32 %t2
}

define i32 @bs_and32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @bs_and32(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %t1 = tail call i32 @llvm.bswap.i32(i32 %a)
  %t2 = tail call i32 @llvm.bswap.i32(i32 %b)
  %t3 = and i32 %t1, %t2
  ret i32 %t3
}

define i32 @bs_or32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @bs_or32(
; CHECK-NEXT:    [[TMP1:%.*]] = or i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %t1 = tail call i32 @llvm.bswap.i32(i32 %a)
  %t2 = tail call i32 @llvm.bswap.i32(i32 %b)
  %t3 = or i32 %t1, %t2
  ret i32 %t3
}

define i32 @bs_xor32(i32 %a, i32 %b) #0 {
; CHECK-LABEL: @bs_xor32(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @llvm.bswap.i32(i32 [[TMP1]])
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %t1 = tail call i32 @llvm.bswap.i32(i32 %a)
  %t2 = tail call i32 @llvm.bswap.i32(i32 %b)
  %t3 = xor i32 %t1, %t2
  ret i32 %t3
}

define i64 @bs_and64i(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64i(
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[A:%.*]], 129085117527228416
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %t1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %t2 = and i64 %t1, 1000000001
  ret i64 %t2
}

define i64 @bs_and64(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64(
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %t1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %t2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %t3 = and i64 %t1, %t2
  ret i64 %t3
}

define i64 @bs_or64(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_or64(
; CHECK-NEXT:    [[TMP1:%.*]] = or i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %t1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %t2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %t3 = or i64 %t1, %t2
  ret i64 %t3
}

define i64 @bs_xor64(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_xor64(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i64 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %t1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %t2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %t3 = xor i64 %t1, %t2
  ret i64 %t3
}

define <2 x i32> @bs_and32vec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_and32vec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %t1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %t2 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %b)
  %t3 = and <2 x i32> %t1, %t2
  ret <2 x i32> %t3
}

define <2 x i32> @bs_or32vec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_or32vec(
; CHECK-NEXT:    [[TMP1:%.*]] = or <2 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %t1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %t2 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %b)
  %t3 = or <2 x i32> %t1, %t2
  ret <2 x i32> %t3
}

define <2 x i32> @bs_xor32vec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_xor32vec(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i32> [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %t1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %t2 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %b)
  %t3 = xor <2 x i32> %t1, %t2
  ret <2 x i32> %t3
}

define <2 x i32> @bs_and32ivec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_and32ivec(
; CHECK-NEXT:    [[TMP1:%.*]] = and <2 x i32> [[A:%.*]], <i32 -1585053440, i32 -1585053440>
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %t1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %t2 = and <2 x i32> %t1, <i32 100001, i32 100001>
  ret <2 x i32> %t2
}

define <2 x i32> @bs_or32ivec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_or32ivec(
; CHECK-NEXT:    [[TMP1:%.*]] = or <2 x i32> [[A:%.*]], <i32 -1585053440, i32 -1585053440>
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %t1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %t2 = or <2 x i32> %t1, <i32 100001, i32 100001>
  ret <2 x i32> %t2
}

define <2 x i32> @bs_xor32ivec(<2 x i32> %a, <2 x i32> %b) #0 {
; CHECK-LABEL: @bs_xor32ivec(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i32> [[A:%.*]], <i32 -1585053440, i32 -1585053440>
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP1]])
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %t1 = tail call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %a)
  %t2 = xor <2 x i32> %t1, <i32 100001, i32 100001>
  ret <2 x i32> %t2
}

define i64 @bs_and64_multiuse1(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64_multiuse1(
; CHECK-NEXT:    [[T1:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[A:%.*]])
; CHECK-NEXT:    [[T2:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[B:%.*]])
; CHECK-NEXT:    [[T3:%.*]] = and i64 [[T1]], [[T2]]
; CHECK-NEXT:    [[T4:%.*]] = mul i64 [[T3]], [[T1]]
; CHECK-NEXT:    [[T5:%.*]] = mul i64 [[T4]], [[T2]]
; CHECK-NEXT:    ret i64 [[T5]]
;
  %t1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %t2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %t3 = and i64 %t1, %t2
  %t4 = mul i64 %t3, %t1 ; to increase use count of the bswaps
  %t5 = mul i64 %t4, %t2 ; to increase use count of the bswaps
  ret i64 %t5
}

define i64 @bs_and64_multiuse2(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64_multiuse2(
; CHECK-NEXT:    [[T1:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[A:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[A]], [[B:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    [[T4:%.*]] = mul i64 [[TMP2]], [[T1]]
; CHECK-NEXT:    ret i64 [[T4]]
;
  %t1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %t2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %t3 = and i64 %t1, %t2
  %t4 = mul i64 %t3, %t1 ; to increase use count of the bswaps
  ret i64 %t4
}

define i64 @bs_and64_multiuse3(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64_multiuse3(
; CHECK-NEXT:    [[T2:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[B:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = and i64 [[A:%.*]], [[B]]
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP1]])
; CHECK-NEXT:    [[T4:%.*]] = mul i64 [[TMP2]], [[T2]]
; CHECK-NEXT:    ret i64 [[T4]]
;
  %t1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %t2 = tail call i64 @llvm.bswap.i64(i64 %b)
  %t3 = and i64 %t1, %t2
  %t4 = mul i64 %t3, %t2 ; to increase use count of the bswaps
  ret i64 %t4
}

define i64 @bs_and64i_multiuse(i64 %a, i64 %b) #0 {
; CHECK-LABEL: @bs_and64i_multiuse(
; CHECK-NEXT:    [[T1:%.*]] = tail call i64 @llvm.bswap.i64(i64 [[A:%.*]])
; CHECK-NEXT:    [[T2:%.*]] = and i64 [[T1]], 1000000001
; CHECK-NEXT:    [[T3:%.*]] = mul i64 [[T2]], [[T1]]
; CHECK-NEXT:    ret i64 [[T3]]
;
  %t1 = tail call i64 @llvm.bswap.i64(i64 %a)
  %t2 = and i64 %t1, 1000000001
  %t3 = mul i64 %t2, %t1 ; to increase use count of the bswap
  ret i64 %t3
}


define i64 @bs_active_high8(i64 %0) {
; CHECK-LABEL: @bs_active_high8(
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP0:%.*]], 255
; CHECK-NEXT:    ret i64 [[TMP2]]
;
  %2 = shl i64 %0, 56
  %3 = call i64 @llvm.bswap.i64(i64 %2)
  ret i64 %3
}

define i32 @bs_active_high7(i32 %0) {
; CHECK-LABEL: @bs_active_high7(
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[TMP0:%.*]], 24
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 254
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %2 = and i32 %0, -33554432  ; 0xfe000000
  %3 = call i32 @llvm.bswap.i32(i32 %2)
  ret i32 %3
}

define <2 x i64> @bs_active_high4(<2 x i64> %0) {
; CHECK-LABEL: @bs_active_high4(
; CHECK-NEXT:    [[TMP2:%.*]] = shl <2 x i64> [[TMP0:%.*]], <i64 4, i64 4>
; CHECK-NEXT:    [[TMP3:%.*]] = and <2 x i64> [[TMP2]], <i64 240, i64 240>
; CHECK-NEXT:    ret <2 x i64> [[TMP3]]
;
  %2 = shl <2 x i64> %0, <i64 60, i64 60>
  %3 = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %2)
  ret <2 x i64> %3
}

define <2 x i64> @bs_active_high_different(<2 x i64> %0) {
; CHECK-LABEL: @bs_active_high_different(
; CHECK-NEXT:    [[TMP2:%.*]] = shl <2 x i64> [[TMP0:%.*]], <i64 56, i64 57>
; CHECK-NEXT:    [[TMP3:%.*]] = lshr exact <2 x i64> [[TMP2]], <i64 56, i64 56>
; CHECK-NEXT:    ret <2 x i64> [[TMP3]]
;
  %2 = shl <2 x i64> %0, <i64 56, i64 57>
  %3 = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %2)
  ret <2 x i64> %3
}

; negative test
define <2 x i64> @bs_active_high_different_negative(<2 x i64> %0) {
; CHECK-LABEL: @bs_active_high_different_negative(
; CHECK-NEXT:    [[TMP2:%.*]] = shl <2 x i64> [[TMP0:%.*]], <i64 56, i64 55>
; CHECK-NEXT:    [[TMP3:%.*]] = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> [[TMP2]])
; CHECK-NEXT:    ret <2 x i64> [[TMP3]]
;
  %2 = shl <2 x i64> %0, <i64 56, i64 55>  ; second elem has 9 active high bits
  %3 = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %2)
  ret <2 x i64> %3
}

; TODO: This should fold to 'and'.
define <2 x i64> @bs_active_high_undef(<2 x i64> %0) {
; CHECK-LABEL: @bs_active_high_undef(
; CHECK-NEXT:    [[TMP2:%.*]] = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> [[TMP0:%.*]])
; CHECK-NEXT:    [[TMP3:%.*]] = lshr <2 x i64> [[TMP2]], <i64 56, i64 undef>
; CHECK-NEXT:    ret <2 x i64> [[TMP3]]
;
  %2 = shl <2 x i64> %0, <i64 56, i64 undef>
  %3 = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %2)
  ret <2 x i64> %3
}

define i64 @bs_active_high8_multiuse(i64 %0) {
; CHECK-LABEL: @bs_active_high8_multiuse(
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP0:%.*]], 56
; CHECK-NEXT:    [[TMP3:%.*]] = and i64 [[TMP0]], 255
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP3]]
; CHECK-NEXT:    ret i64 [[TMP4]]
;
  %2 = shl i64 %0, 56
  %3 = call i64 @llvm.bswap.i64(i64 %2)
  %4 = mul i64 %2, %3  ; increase use of shl and bswap
  ret i64 %4
}

define i64 @bs_active_high7_multiuse(i64 %0) {
; CHECK-LABEL: @bs_active_high7_multiuse(
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP0:%.*]], 57
; CHECK-NEXT:    [[TMP3:%.*]] = lshr exact i64 [[TMP2]], 56
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP3]]
; CHECK-NEXT:    ret i64 [[TMP4]]
;
  %2 = shl i64 %0, 57
  %3 = call i64 @llvm.bswap.i64(i64 %2)
  %4 = mul i64 %2, %3  ; increase use of shl and bswap
  ret i64 %4
}

define i64 @bs_active_byte_6h(i64 %0) {
; CHECK-LABEL: @bs_active_byte_6h(
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i64 [[TMP0:%.*]], 24
; CHECK-NEXT:    [[TMP3:%.*]] = and i64 [[TMP2]], 16711680
; CHECK-NEXT:    ret i64 [[TMP3]]
;
  %2 = and i64 %0, 280375465082880  ; 0xff00'00000000
  %3 = call i64 @llvm.bswap.i64(i64 %2)
  ret i64 %3
}

define i32 @bs_active_byte_3h(i32 %0) {
; CHECK-LABEL: @bs_active_byte_3h(
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i32 [[TMP0:%.*]], 8
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 1536
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %2 = and i32 %0, 393216  ; 0x0006'0000
  %3 = call i32 @llvm.bswap.i32(i32 %2)
  ret i32 %3
}

define <2 x i32> @bs_active_byte_3h_v2(<2 x i32> %0) {
; CHECK-LABEL: @bs_active_byte_3h_v2(
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP0:%.*]], <i32 8388608, i32 65536>
; CHECK-NEXT:    [[TMP3:%.*]] = lshr exact <2 x i32> [[TMP2]], <i32 8, i32 8>
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %2 = and <2 x i32> %0, <i32 8388608, i32 65536>  ; 0x0080'0000, 0x0001'0000
  %3 = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %2)
  ret <2 x i32> %3
}

; negative test
define i64 @bs_active_byte_78h(i64 %0) {
; CHECK-LABEL: @bs_active_byte_78h(
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP0:%.*]], 108086391056891904
; CHECK-NEXT:    [[TMP3:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP2]])
; CHECK-NEXT:    ret i64 [[TMP3]]
;
  %2 = and i64 %0, 108086391056891904  ; 0x01800000'00000000
  %3 = call i64 @llvm.bswap.i64(i64 %2)
  ret i64 %3
}


define i16 @bs_active_low1(i16 %0) {
; CHECK-LABEL: @bs_active_low1(
; CHECK-NEXT:    [[TMP2:%.*]] = lshr i16 [[TMP0:%.*]], 7
; CHECK-NEXT:    [[TMP3:%.*]] = and i16 [[TMP2]], 256
; CHECK-NEXT:    ret i16 [[TMP3]]
;
  %2 = lshr i16 %0, 15
  %3 = call i16 @llvm.bswap.i16(i16 %2)
  ret i16 %3
}

define <2 x i32> @bs_active_low8(<2 x i32> %0) {
; CHECK-LABEL: @bs_active_low8(
; CHECK-NEXT:    [[TMP2:%.*]] = shl <2 x i32> [[TMP0:%.*]], <i32 24, i32 24>
; CHECK-NEXT:    ret <2 x i32> [[TMP2]]
;
  %2 = and <2 x i32> %0, <i32 255, i32 255>
  %3 = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %2)
  ret <2 x i32> %3
}

define <2 x i32> @bs_active_low_different(<2 x i32> %0) {
; CHECK-LABEL: @bs_active_low_different(
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP0:%.*]], <i32 2, i32 128>
; CHECK-NEXT:    [[TMP3:%.*]] = shl nuw <2 x i32> [[TMP2]], <i32 24, i32 24>
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %2 = and <2 x i32> %0, <i32 2, i32 128>
  %3 = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %2)
  ret <2 x i32> %3
}

; negative test
define <2 x i32> @bs_active_low_different_negative(<2 x i32> %0) {
; CHECK-LABEL: @bs_active_low_different_negative(
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP0:%.*]], <i32 256, i32 255>
; CHECK-NEXT:    [[TMP3:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP2]])
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %2 = and <2 x i32> %0, <i32 256, i32 255>
  %3 = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %2)
  ret <2 x i32> %3
}

; negative test
define <2 x i32> @bs_active_low_undef(<2 x i32> %0) {
; CHECK-LABEL: @bs_active_low_undef(
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i32> [[TMP0:%.*]], <i32 255, i32 undef>
; CHECK-NEXT:    [[TMP3:%.*]] = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> [[TMP2]])
; CHECK-NEXT:    ret <2 x i32> [[TMP3]]
;
  %2 = and <2 x i32> %0, <i32 255, i32 undef>
  %3 = call <2 x i32> @llvm.bswap.v2i32(<2 x i32> %2)
  ret <2 x i32> %3
}

define i64 @bs_active_low8_multiuse(i64 %0) {
; CHECK-LABEL: @bs_active_low8_multiuse(
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP0:%.*]], 255
; CHECK-NEXT:    [[TMP3:%.*]] = shl nuw i64 [[TMP2]], 56
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP3]]
; CHECK-NEXT:    ret i64 [[TMP4]]
;
  %2 = and i64 %0, 255
  %3 = call i64 @llvm.bswap.i64(i64 %2)
  %4 = mul i64 %2, %3  ; increase use of and and bswap
  ret i64 %4
}

define i64 @bs_active_low7_multiuse(i64 %0) {
; CHECK-LABEL: @bs_active_low7_multiuse(
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP0:%.*]], 127
; CHECK-NEXT:    [[TMP3:%.*]] = shl nuw nsw i64 [[TMP2]], 56
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP2]], [[TMP3]]
; CHECK-NEXT:    ret i64 [[TMP4]]
;
  %2 = and i64 %0, 127
  %3 = call i64 @llvm.bswap.i64(i64 %2)
  %4 = mul i64 %2, %3  ; increase use of and and bswap
  ret i64 %4
}

define i64 @bs_active_byte_4l(i64 %0) {
; CHECK-LABEL: @bs_active_byte_4l(
; CHECK-NEXT:    [[TMP2:%.*]] = shl i64 [[TMP0:%.*]], 8
; CHECK-NEXT:    [[TMP3:%.*]] = and i64 [[TMP2]], 292057776128
; CHECK-NEXT:    ret i64 [[TMP3]]
;
  %2 = and i64 %0, 1140850688  ; 0x44000000
  %3 = call i64 @llvm.bswap.i64(i64 %2)
  ret i64 %3
}

define i32 @bs_active_byte_2l(i32 %0) {
; CHECK-LABEL: @bs_active_byte_2l(
; CHECK-NEXT:    [[TMP2:%.*]] = shl i32 [[TMP0:%.*]], 8
; CHECK-NEXT:    [[TMP3:%.*]] = and i32 [[TMP2]], 16711680
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %2 = and i32 %0, 65280  ; 0xff00
  %3 = call i32 @llvm.bswap.i32(i32 %2)
  ret i32 %3
}

define <2 x i64> @bs_active_byte_2l_v2(<2 x i64> %0) {
; CHECK-LABEL: @bs_active_byte_2l_v2(
; CHECK-NEXT:    [[TMP2:%.*]] = and <2 x i64> [[TMP0:%.*]], <i64 256, i64 65280>
; CHECK-NEXT:    [[TMP3:%.*]] = shl nuw nsw <2 x i64> [[TMP2]], <i64 40, i64 40>
; CHECK-NEXT:    ret <2 x i64> [[TMP3]]
;
  %2 = and <2 x i64> %0, <i64 256, i64 65280>  ; 0x0100, 0xff00
  %3 = call <2 x i64> @llvm.bswap.v2i64(<2 x i64> %2)
  ret <2 x i64> %3
}

; negative test
define i64 @bs_active_byte_12l(i64 %0) {
; CHECK-LABEL: @bs_active_byte_12l(
; CHECK-NEXT:    [[TMP2:%.*]] = and i64 [[TMP0:%.*]], 384
; CHECK-NEXT:    [[TMP3:%.*]] = call i64 @llvm.bswap.i64(i64 [[TMP2]])
; CHECK-NEXT:    ret i64 [[TMP3]]
;
  %2 = and i64 %0, 384  ; 0x0180
  %3 = call i64 @llvm.bswap.i64(i64 %2)
  ret i64 %3
}


declare i16 @llvm.bswap.i16(i16)
declare i32 @llvm.bswap.i32(i32)
declare i64 @llvm.bswap.i64(i64)
declare <2 x i16> @llvm.bswap.v2i16(<2 x i16>)
declare <2 x i32> @llvm.bswap.v2i32(<2 x i32>)
declare <2 x i64> @llvm.bswap.v2i64(<2 x i64>)
