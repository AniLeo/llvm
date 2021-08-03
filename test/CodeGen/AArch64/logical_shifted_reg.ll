; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=aarch64-none-linux-gnu | FileCheck %s

@var1_32 = global i32 0
@var2_32 = global i32 0

@var1_64 = global i64 0
@var2_64 = global i64 0

define void @logical_32bit() minsize {
; CHECK-LABEL: logical_32bit:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x19, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w19, -16
; CHECK-NEXT:    adrp x8, :got:var1_32
; CHECK-NEXT:    adrp x9, :got:var2_32
; CHECK-NEXT:    ldr x8, [x8, :got_lo12:var1_32]
; CHECK-NEXT:    ldr x9, [x9, :got_lo12:var2_32]
; CHECK-NEXT:    ldr w10, [x8]
; CHECK-NEXT:    ldr w9, [x9]
; CHECK-NEXT:    and w11, w10, w9
; CHECK-NEXT:    bic w12, w10, w9
; CHECK-NEXT:    orr w13, w10, w9
; CHECK-NEXT:    orn w14, w10, w9
; CHECK-NEXT:    eor w15, w10, w9
; CHECK-NEXT:    eon w16, w9, w10
; CHECK-NEXT:    and w17, w10, w9, lsl #31
; CHECK-NEXT:    bic w18, w10, w9, lsl #31
; CHECK-NEXT:    orr w0, w10, w9, lsl #31
; CHECK-NEXT:    orn w1, w10, w9, lsl #31
; CHECK-NEXT:    eor w2, w10, w9, lsl #31
; CHECK-NEXT:    eon w3, w10, w9, lsl #31
; CHECK-NEXT:    bic w4, w10, w9, asr #10
; CHECK-NEXT:    eor w5, w10, w9, asr #10
; CHECK-NEXT:    orn w6, w10, w9, lsr #1
; CHECK-NEXT:    eor w7, w10, w9, lsr #1
; CHECK-NEXT:    eon w19, w10, w9, ror #20
; CHECK-NEXT:    and w9, w10, w9, ror #20
; CHECK-NEXT:    str w11, [x8]
; CHECK-NEXT:    str w12, [x8]
; CHECK-NEXT:    str w13, [x8]
; CHECK-NEXT:    str w14, [x8]
; CHECK-NEXT:    str w15, [x8]
; CHECK-NEXT:    str w16, [x8]
; CHECK-NEXT:    str w17, [x8]
; CHECK-NEXT:    str w18, [x8]
; CHECK-NEXT:    str w0, [x8]
; CHECK-NEXT:    str w1, [x8]
; CHECK-NEXT:    str w2, [x8]
; CHECK-NEXT:    str w3, [x8]
; CHECK-NEXT:    str w4, [x8]
; CHECK-NEXT:    str w5, [x8]
; CHECK-NEXT:    str w6, [x8]
; CHECK-NEXT:    str w7, [x8]
; CHECK-NEXT:    str w19, [x8]
; CHECK-NEXT:    str w9, [x8]
; CHECK-NEXT:    ldr x19, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %val1 = load i32, i32* @var1_32
  %val2 = load i32, i32* @var2_32

  ; First check basic and/bic/or/orn/eor/eon patterns with no shift
  %neg_val2 = xor i32 -1, %val2

  %and_noshift = and i32 %val1, %val2
  store volatile i32 %and_noshift, i32* @var1_32
  %bic_noshift = and i32 %neg_val2, %val1
  store volatile i32 %bic_noshift, i32* @var1_32

  %or_noshift = or i32 %val1, %val2
  store volatile i32 %or_noshift, i32* @var1_32
  %orn_noshift = or i32 %neg_val2, %val1
  store volatile i32 %orn_noshift, i32* @var1_32

  %xor_noshift = xor i32 %val1, %val2
  store volatile i32 %xor_noshift, i32* @var1_32
  %xorn_noshift = xor i32 %neg_val2, %val1
  store volatile i32 %xorn_noshift, i32* @var1_32

  ; Check the maximum shift on each
  %operand_lsl31 = shl i32 %val2, 31
  %neg_operand_lsl31 = xor i32 -1, %operand_lsl31

  %and_lsl31 = and i32 %val1, %operand_lsl31
  store volatile i32 %and_lsl31, i32* @var1_32
  %bic_lsl31 = and i32 %val1, %neg_operand_lsl31
  store volatile i32 %bic_lsl31, i32* @var1_32

  %or_lsl31 = or i32 %val1, %operand_lsl31
  store volatile i32 %or_lsl31, i32* @var1_32
  %orn_lsl31 = or i32 %val1, %neg_operand_lsl31
  store volatile i32 %orn_lsl31, i32* @var1_32

  %xor_lsl31 = xor i32 %val1, %operand_lsl31
  store volatile i32 %xor_lsl31, i32* @var1_32
  %xorn_lsl31 = xor i32 %val1, %neg_operand_lsl31
  store volatile i32 %xorn_lsl31, i32* @var1_32

  ; Check other shifts on a subset
  %operand_asr10 = ashr i32 %val2, 10
  %neg_operand_asr10 = xor i32 -1, %operand_asr10

  %bic_asr10 = and i32 %val1, %neg_operand_asr10
  store volatile i32 %bic_asr10, i32* @var1_32
  %xor_asr10 = xor i32 %val1, %operand_asr10
  store volatile i32 %xor_asr10, i32* @var1_32

  %operand_lsr1 = lshr i32 %val2, 1
  %neg_operand_lsr1 = xor i32 -1, %operand_lsr1

  %orn_lsr1 = or i32 %val1, %neg_operand_lsr1
  store volatile i32 %orn_lsr1, i32* @var1_32
  %xor_lsr1 = xor i32 %val1, %operand_lsr1
  store volatile i32 %xor_lsr1, i32* @var1_32

  %operand_ror20_big = shl i32 %val2, 12
  %operand_ror20_small = lshr i32 %val2, 20
  %operand_ror20 = or i32 %operand_ror20_big, %operand_ror20_small
  %neg_operand_ror20 = xor i32 -1, %operand_ror20

  %xorn_ror20 = xor i32 %val1, %neg_operand_ror20
  store volatile i32 %xorn_ror20, i32* @var1_32
  %and_ror20 = and i32 %val1, %operand_ror20
  store volatile i32 %and_ror20, i32* @var1_32

  ret void
}

define void @logical_64bit() minsize {
; CHECK-LABEL: logical_64bit:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x19, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w19, -16
; CHECK-NEXT:    adrp x8, :got:var1_64
; CHECK-NEXT:    adrp x9, :got:var2_64
; CHECK-NEXT:    ldr x8, [x8, :got_lo12:var1_64]
; CHECK-NEXT:    ldr x9, [x9, :got_lo12:var2_64]
; CHECK-NEXT:    ldr x10, [x8]
; CHECK-NEXT:    ldr x9, [x9]
; CHECK-NEXT:    and x11, x10, x9
; CHECK-NEXT:    bic x12, x10, x9
; CHECK-NEXT:    orr x13, x10, x9
; CHECK-NEXT:    orn x14, x10, x9
; CHECK-NEXT:    eor x15, x10, x9
; CHECK-NEXT:    eon x16, x9, x10
; CHECK-NEXT:    and x17, x10, x9, lsl #63
; CHECK-NEXT:    bic x18, x10, x9, lsl #63
; CHECK-NEXT:    orr x0, x10, x9, lsl #63
; CHECK-NEXT:    orn x1, x10, x9, lsl #63
; CHECK-NEXT:    eor x2, x10, x9, lsl #63
; CHECK-NEXT:    eon x3, x10, x9, lsl #63
; CHECK-NEXT:    bic x4, x10, x9, asr #10
; CHECK-NEXT:    eor x5, x10, x9, asr #10
; CHECK-NEXT:    orn x6, x10, x9, lsr #1
; CHECK-NEXT:    eor x7, x10, x9, lsr #1
; CHECK-NEXT:    eon x19, x10, x9, ror #20
; CHECK-NEXT:    and x9, x10, x9, ror #20
; CHECK-NEXT:    str x11, [x8]
; CHECK-NEXT:    str x12, [x8]
; CHECK-NEXT:    str x13, [x8]
; CHECK-NEXT:    str x14, [x8]
; CHECK-NEXT:    str x15, [x8]
; CHECK-NEXT:    str x16, [x8]
; CHECK-NEXT:    str x17, [x8]
; CHECK-NEXT:    str x18, [x8]
; CHECK-NEXT:    str x0, [x8]
; CHECK-NEXT:    str x1, [x8]
; CHECK-NEXT:    str x2, [x8]
; CHECK-NEXT:    str x3, [x8]
; CHECK-NEXT:    str x4, [x8]
; CHECK-NEXT:    str x5, [x8]
; CHECK-NEXT:    str x6, [x8]
; CHECK-NEXT:    str x7, [x8]
; CHECK-NEXT:    str x19, [x8]
; CHECK-NEXT:    str x9, [x8]
; CHECK-NEXT:    ldr x19, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %val1 = load i64, i64* @var1_64
  %val2 = load i64, i64* @var2_64

  ; First check basic and/bic/or/orn/eor/eon patterns with no shift
  %neg_val2 = xor i64 -1, %val2

  %and_noshift = and i64 %val1, %val2
  store volatile i64 %and_noshift, i64* @var1_64
  %bic_noshift = and i64 %neg_val2, %val1
  store volatile i64 %bic_noshift, i64* @var1_64

  %or_noshift = or i64 %val1, %val2
  store volatile i64 %or_noshift, i64* @var1_64
  %orn_noshift = or i64 %neg_val2, %val1
  store volatile i64 %orn_noshift, i64* @var1_64

  %xor_noshift = xor i64 %val1, %val2
  store volatile i64 %xor_noshift, i64* @var1_64
  %xorn_noshift = xor i64 %neg_val2, %val1
  store volatile i64 %xorn_noshift, i64* @var1_64

  ; Check the maximum shift on each
  %operand_lsl63 = shl i64 %val2, 63
  %neg_operand_lsl63 = xor i64 -1, %operand_lsl63

  %and_lsl63 = and i64 %val1, %operand_lsl63
  store volatile i64 %and_lsl63, i64* @var1_64
  %bic_lsl63 = and i64 %val1, %neg_operand_lsl63
  store volatile i64 %bic_lsl63, i64* @var1_64

  %or_lsl63 = or i64 %val1, %operand_lsl63
  store volatile i64 %or_lsl63, i64* @var1_64
  %orn_lsl63 = or i64 %val1, %neg_operand_lsl63
  store volatile i64 %orn_lsl63, i64* @var1_64

  %xor_lsl63 = xor i64 %val1, %operand_lsl63
  store volatile i64 %xor_lsl63, i64* @var1_64
  %xorn_lsl63 = xor i64 %val1, %neg_operand_lsl63
  store volatile i64 %xorn_lsl63, i64* @var1_64

  ; Check other shifts on a subset
  %operand_asr10 = ashr i64 %val2, 10
  %neg_operand_asr10 = xor i64 -1, %operand_asr10

  %bic_asr10 = and i64 %val1, %neg_operand_asr10
  store volatile i64 %bic_asr10, i64* @var1_64
  %xor_asr10 = xor i64 %val1, %operand_asr10
  store volatile i64 %xor_asr10, i64* @var1_64

  %operand_lsr1 = lshr i64 %val2, 1
  %neg_operand_lsr1 = xor i64 -1, %operand_lsr1

  %orn_lsr1 = or i64 %val1, %neg_operand_lsr1
  store volatile i64 %orn_lsr1, i64* @var1_64
  %xor_lsr1 = xor i64 %val1, %operand_lsr1
  store volatile i64 %xor_lsr1, i64* @var1_64

  ; Construct a rotate-right from a bunch of other logical
  ; operations. DAGCombiner should ensure we the ROTR during
  ; selection
  %operand_ror20_big = shl i64 %val2, 44
  %operand_ror20_small = lshr i64 %val2, 20
  %operand_ror20 = or i64 %operand_ror20_big, %operand_ror20_small
  %neg_operand_ror20 = xor i64 -1, %operand_ror20

  %xorn_ror20 = xor i64 %val1, %neg_operand_ror20
  store volatile i64 %xorn_ror20, i64* @var1_64
  %and_ror20 = and i64 %val1, %operand_ror20
  store volatile i64 %and_ror20, i64* @var1_64

  ret void
}

define void @flag_setting() {
; CHECK-LABEL: flag_setting:
; CHECK:       // %bb.0:
; CHECK-NEXT:    adrp x8, :got:var1_64
; CHECK-NEXT:    adrp x10, :got:var2_64
; CHECK-NEXT:    ldr x8, [x8, :got_lo12:var1_64]
; CHECK-NEXT:    ldr x10, [x10, :got_lo12:var2_64]
; CHECK-NEXT:    ldr x9, [x8]
; CHECK-NEXT:    ldr x10, [x10]
; CHECK-NEXT:    tst x9, x10
; CHECK-NEXT:    b.gt .LBB2_4
; CHECK-NEXT:  // %bb.1: // %test2
; CHECK-NEXT:    tst x9, x10, lsl #63
; CHECK-NEXT:    b.lt .LBB2_4
; CHECK-NEXT:  // %bb.2: // %test3
; CHECK-NEXT:    and x10, x9, x10, asr #12
; CHECK-NEXT:    cmp x10, #1
; CHECK-NEXT:    b.ge .LBB2_4
; CHECK-NEXT:  // %bb.3: // %other_exit
; CHECK-NEXT:    str x9, [x8]
; CHECK-NEXT:  .LBB2_4: // %common.ret
; CHECK-NEXT:    ret
  %val1 = load i64, i64* @var1_64
  %val2 = load i64, i64* @var2_64

  %simple_and = and i64 %val1, %val2
  %tst1 = icmp sgt i64 %simple_and, 0
  br i1 %tst1, label %ret, label %test2, !prof !1

test2:
  %shifted_op = shl i64 %val2, 63
  %shifted_and = and i64 %val1, %shifted_op
  %tst2 = icmp slt i64 %shifted_and, 0
  br i1 %tst2, label %ret, label %test3, !prof !1

test3:
  %asr_op = ashr i64 %val2, 12
  %asr_and = and i64 %asr_op, %val1
  %tst3 = icmp sgt i64 %asr_and, 0
  br i1 %tst3, label %ret, label %other_exit, !prof !1

other_exit:
  store volatile i64 %val1, i64* @var1_64
  ret void
ret:
  ret void
}

!1 = !{!"branch_weights", i32 1, i32 1}
