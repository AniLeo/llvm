; RUN: llc --mtriple=loongarch32 < %s | FileCheck %s --check-prefix=LA32
; RUN: llc --mtriple=loongarch64 < %s | FileCheck %s --check-prefix=LA64

;; This test checks that unnecessary masking of shift amount operands is
;; eliminated during instruction selection. The test needs to ensure that the
;; masking is not removed if it may affect the shift amount.

define i32 @sll_redundant_mask(i32 %a, i32 %b) {
; LA32-LABEL: sll_redundant_mask:
; LA32:       # %bb.0:
; LA32-NEXT:    sll.w $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: sll_redundant_mask:
; LA64:       # %bb.0:
; LA64-NEXT:    sll.w $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = and i32 %b, 31
  %2 = shl i32 %a, %1
  ret i32 %2
}

define i32 @sll_non_redundant_mask(i32 %a, i32 %b) {
; LA32-LABEL: sll_non_redundant_mask:
; LA32:       # %bb.0:
; LA32-NEXT:    andi $a1, $a1, 15
; LA32-NEXT:    sll.w $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: sll_non_redundant_mask:
; LA64:       # %bb.0:
; LA64-NEXT:    andi $a1, $a1, 15
; LA64-NEXT:    sll.w $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = and i32 %b, 15
  %2 = shl i32 %a, %1
  ret i32 %2
}

define i32 @srl_redundant_mask(i32 %a, i32 %b) {
; LA32-LABEL: srl_redundant_mask:
; LA32:       # %bb.0:
; LA32-NEXT:    srl.w $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: srl_redundant_mask:
; LA64:       # %bb.0:
; LA64-NEXT:    srl.w $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = and i32 %b, 4095
  %2 = lshr i32 %a, %1
  ret i32 %2
}

define i32 @srl_non_redundant_mask(i32 %a, i32 %b) {
; LA32-LABEL: srl_non_redundant_mask:
; LA32:       # %bb.0:
; LA32-NEXT:    andi $a1, $a1, 7
; LA32-NEXT:    srl.w $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: srl_non_redundant_mask:
; LA64:       # %bb.0:
; LA64-NEXT:    andi $a1, $a1, 7
; LA64-NEXT:    srl.w $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = and i32 %b, 7
  %2 = lshr i32 %a, %1
  ret i32 %2
}

define i32 @sra_redundant_mask(i32 %a, i32 %b) {
; LA32-LABEL: sra_redundant_mask:
; LA32:       # %bb.0:
; LA32-NEXT:    sra.w $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: sra_redundant_mask:
; LA64:       # %bb.0:
; LA64-NEXT:    sra.w $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = and i32 %b, 65535
  %2 = ashr i32 %a, %1
  ret i32 %2
}

define i32 @sra_non_redundant_mask(i32 %a, i32 %b) {
; LA32-LABEL: sra_non_redundant_mask:
; LA32:       # %bb.0:
; LA32-NEXT:    andi $a1, $a1, 32
; LA32-NEXT:    sra.w $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: sra_non_redundant_mask:
; LA64:       # %bb.0:
; LA64-NEXT:    andi $a1, $a1, 32
; LA64-NEXT:    sra.w $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = and i32 %b, 32
  %2 = ashr i32 %a, %1
  ret i32 %2
}

define i32 @sll_redundant_mask_zeros(i32 %a, i32 %b) {
; LA32-LABEL: sll_redundant_mask_zeros:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a1, $a1, 1
; LA32-NEXT:    sll.w $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: sll_redundant_mask_zeros:
; LA64:       # %bb.0:
; LA64-NEXT:    slli.d $a1, $a1, 1
; LA64-NEXT:    sll.w $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = shl i32 %b, 1
  %2 = and i32 %1, 30
  %3 = shl i32 %a, %2
  ret i32 %3
}

define i32 @srl_redundant_mask_zeros(i32 %a, i32 %b) {
; LA32-LABEL: srl_redundant_mask_zeros:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a1, $a1, 2
; LA32-NEXT:    srl.w $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: srl_redundant_mask_zeros:
; LA64:       # %bb.0:
; LA64-NEXT:    slli.d $a1, $a1, 2
; LA64-NEXT:    srl.w $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = shl i32 %b, 2
  %2 = and i32 %1, 28
  %3 = lshr i32 %a, %2
  ret i32 %3
}

define i32 @sra_redundant_mask_zeros(i32 %a, i32 %b) {
; LA32-LABEL: sra_redundant_mask_zeros:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a1, $a1, 3
; LA32-NEXT:    sra.w $a0, $a0, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: sra_redundant_mask_zeros:
; LA64:       # %bb.0:
; LA64-NEXT:    slli.d $a1, $a1, 3
; LA64-NEXT:    sra.w $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = shl i32 %b, 3
  %2 = and i32 %1, 24
  %3 = ashr i32 %a, %2
  ret i32 %3
}

define i64 @sll_redundant_mask_zeros_i64(i64 %a, i64 %b) {
; LA32-LABEL: sll_redundant_mask_zeros_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a2, 2
; LA32-NEXT:    srli.w $a3, $a0, 1
; LA32-NEXT:    andi $a4, $a2, 60
; LA32-NEXT:    xori $a5, $a4, 31
; LA32-NEXT:    srl.w $a3, $a3, $a5
; LA32-NEXT:    sll.w $a1, $a1, $a2
; LA32-NEXT:    or $a1, $a1, $a3
; LA32-NEXT:    addi.w $a3, $a4, -32
; LA32-NEXT:    slti $a4, $a3, 0
; LA32-NEXT:    maskeqz $a1, $a1, $a4
; LA32-NEXT:    sll.w $a5, $a0, $a3
; LA32-NEXT:    masknez $a4, $a5, $a4
; LA32-NEXT:    or $a1, $a1, $a4
; LA32-NEXT:    sll.w $a0, $a0, $a2
; LA32-NEXT:    srai.w $a2, $a3, 31
; LA32-NEXT:    and $a0, $a2, $a0
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: sll_redundant_mask_zeros_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    slli.d $a1, $a1, 2
; LA64-NEXT:    sll.d $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = shl i64 %b, 2
  %2 = and i64 %1, 60
  %3 = shl i64 %a, %2
  ret i64 %3
}

define i64 @srl_redundant_mask_zeros_i64(i64 %a, i64 %b) {
; LA32-LABEL: srl_redundant_mask_zeros_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a2, $a2, 3
; LA32-NEXT:    slli.w $a3, $a1, 1
; LA32-NEXT:    andi $a4, $a2, 56
; LA32-NEXT:    xori $a5, $a4, 31
; LA32-NEXT:    sll.w $a3, $a3, $a5
; LA32-NEXT:    srl.w $a0, $a0, $a2
; LA32-NEXT:    or $a0, $a0, $a3
; LA32-NEXT:    addi.w $a3, $a4, -32
; LA32-NEXT:    slti $a4, $a3, 0
; LA32-NEXT:    maskeqz $a0, $a0, $a4
; LA32-NEXT:    srl.w $a5, $a1, $a3
; LA32-NEXT:    masknez $a4, $a5, $a4
; LA32-NEXT:    or $a0, $a0, $a4
; LA32-NEXT:    srl.w $a1, $a1, $a2
; LA32-NEXT:    srai.w $a2, $a3, 31
; LA32-NEXT:    and $a1, $a2, $a1
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: srl_redundant_mask_zeros_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    slli.d $a1, $a1, 3
; LA64-NEXT:    srl.d $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = shl i64 %b, 3
  %2 = and i64 %1, 56
  %3 = lshr i64 %a, %2
  ret i64 %3
}

define i64 @sra_redundant_mask_zeros_i64(i64 %a, i64 %b) {
; LA32-LABEL: sra_redundant_mask_zeros_i64:
; LA32:       # %bb.0:
; LA32-NEXT:    slli.w $a3, $a2, 4
; LA32-NEXT:    srai.w $a2, $a1, 31
; LA32-NEXT:    andi $a4, $a3, 48
; LA32-NEXT:    addi.w $a5, $a4, -32
; LA32-NEXT:    slti $a6, $a5, 0
; LA32-NEXT:    masknez $a2, $a2, $a6
; LA32-NEXT:    sra.w $a7, $a1, $a3
; LA32-NEXT:    maskeqz $a7, $a7, $a6
; LA32-NEXT:    or $a2, $a7, $a2
; LA32-NEXT:    srl.w $a0, $a0, $a3
; LA32-NEXT:    xori $a3, $a4, 31
; LA32-NEXT:    slli.w $a4, $a1, 1
; LA32-NEXT:    sll.w $a3, $a4, $a3
; LA32-NEXT:    or $a0, $a0, $a3
; LA32-NEXT:    sra.w $a1, $a1, $a5
; LA32-NEXT:    maskeqz $a0, $a0, $a6
; LA32-NEXT:    masknez $a1, $a1, $a6
; LA32-NEXT:    or $a0, $a0, $a1
; LA32-NEXT:    move $a1, $a2
; LA32-NEXT:    jirl $zero, $ra, 0
;
; LA64-LABEL: sra_redundant_mask_zeros_i64:
; LA64:       # %bb.0:
; LA64-NEXT:    slli.d $a1, $a1, 4
; LA64-NEXT:    sra.d $a0, $a0, $a1
; LA64-NEXT:    jirl $zero, $ra, 0
  %1 = shl i64 %b, 4
  %2 = and i64 %1, 48
  %3 = ashr i64 %a, %2
  ret i64 %3
}
