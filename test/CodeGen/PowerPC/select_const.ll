; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=powerpc64le-unknown-unknown -verify-machineinstrs -mattr=+isel | FileCheck %s --check-prefix=ALL --check-prefix=ISEL
; RUN: llc < %s -mtriple=powerpc64le-unknown-unknown -verify-machineinstrs -mattr=-isel | FileCheck %s --check-prefix=ALL --check-prefix=NO_ISEL

; Select of constants: control flow / conditional moves can always be replaced by logic+math (but may not be worth it?).
; Test the zeroext/signext variants of each pattern to see if that makes a difference.

; select Cond, 0, 1 --> zext (!Cond)

define i32 @select_0_or_1(i1 %cond) {
; ALL-LABEL: select_0_or_1:
; ALL:       # %bb.0:
; ALL-NEXT:    not 3, 3
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 0, i32 1
  ret i32 %sel
}

define i32 @select_0_or_1_zeroext(i1 zeroext %cond) {
; ALL-LABEL: select_0_or_1_zeroext:
; ALL:       # %bb.0:
; ALL-NEXT:    xori 3, 3, 1
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 0, i32 1
  ret i32 %sel
}

define i32 @select_0_or_1_signext(i1 signext %cond) {
; ALL-LABEL: select_0_or_1_signext:
; ALL:       # %bb.0:
; ALL-NEXT:    not 3, 3
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 0, i32 1
  ret i32 %sel
}

; select Cond, 1, 0 --> zext (Cond)

define i32 @select_1_or_0(i1 %cond) {
; ALL-LABEL: select_1_or_0:
; ALL:       # %bb.0:
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 1, i32 0
  ret i32 %sel
}

define i32 @select_1_or_0_zeroext(i1 zeroext %cond) {
; ALL-LABEL: select_1_or_0_zeroext:
; ALL:       # %bb.0:
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 1, i32 0
  ret i32 %sel
}

define i32 @select_1_or_0_signext(i1 signext %cond) {
; ALL-LABEL: select_1_or_0_signext:
; ALL:       # %bb.0:
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 1, i32 0
  ret i32 %sel
}

; select Cond, 0, -1 --> sext (!Cond)

define i32 @select_0_or_neg1(i1 %cond) {
; ALL-LABEL: select_0_or_neg1:
; ALL:       # %bb.0:
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    addi 3, 3, -1
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 0, i32 -1
  ret i32 %sel
}

define i32 @select_0_or_neg1_zeroext(i1 zeroext %cond) {
; ALL-LABEL: select_0_or_neg1_zeroext:
; ALL:       # %bb.0:
; ALL-NEXT:    addi 3, 3, -1
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 0, i32 -1
  ret i32 %sel
}

define i32 @select_0_or_neg1_signext(i1 signext %cond) {
; ALL-LABEL: select_0_or_neg1_signext:
; ALL:       # %bb.0:
; ALL-NEXT:    not 3, 3
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 0, i32 -1
  ret i32 %sel
}

; select Cond, -1, 0 --> sext (Cond)

define i32 @select_neg1_or_0(i1 %cond) {
; ALL-LABEL: select_neg1_or_0:
; ALL:       # %bb.0:
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    neg 3, 3
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 -1, i32 0
  ret i32 %sel
}

define i32 @select_neg1_or_0_zeroext(i1 zeroext %cond) {
; ALL-LABEL: select_neg1_or_0_zeroext:
; ALL:       # %bb.0:
; ALL-NEXT:    neg 3, 3
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 -1, i32 0
  ret i32 %sel
}

define i32 @select_neg1_or_0_signext(i1 signext %cond) {
; ALL-LABEL: select_neg1_or_0_signext:
; ALL:       # %bb.0:
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 -1, i32 0
  ret i32 %sel
}

; select Cond, C+1, C --> add (zext Cond), C

define i32 @select_Cplus1_C(i1 %cond) {
; ALL-LABEL: select_Cplus1_C:
; ALL:       # %bb.0:
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    addi 3, 3, 41
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 42, i32 41
  ret i32 %sel
}

define i32 @select_Cplus1_C_zeroext(i1 zeroext %cond) {
; ALL-LABEL: select_Cplus1_C_zeroext:
; ALL:       # %bb.0:
; ALL-NEXT:    addi 3, 3, 41
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 42, i32 41
  ret i32 %sel
}

define i32 @select_Cplus1_C_signext(i1 signext %cond) {
; ALL-LABEL: select_Cplus1_C_signext:
; ALL:       # %bb.0:
; ALL-NEXT:    subfic 3, 3, 41
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 42, i32 41
  ret i32 %sel
}

; select Cond, C, C+1 --> add (sext Cond), C

define i32 @select_C_Cplus1(i1 %cond) {
; ALL-LABEL: select_C_Cplus1:
; ALL:       # %bb.0:
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    subfic 3, 3, 42
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 41, i32 42
  ret i32 %sel
}

define i32 @select_C_Cplus1_zeroext(i1 zeroext %cond) {
; ALL-LABEL: select_C_Cplus1_zeroext:
; ALL:       # %bb.0:
; ALL-NEXT:    subfic 3, 3, 42
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 41, i32 42
  ret i32 %sel
}

define i32 @select_C_Cplus1_signext(i1 signext %cond) {
; ALL-LABEL: select_C_Cplus1_signext:
; ALL:       # %bb.0:
; ALL-NEXT:    addi 3, 3, 42
; ALL-NEXT:    blr
  %sel = select i1 %cond, i32 41, i32 42
  ret i32 %sel
}

; In general, select of 2 constants could be:
; select Cond, C1, C2 --> add (mul (zext Cond), C1-C2), C2 --> add (and (sext Cond), C1-C2), C2

define i32 @select_C1_C2(i1 %cond) {
; ISEL-LABEL: select_C1_C2:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, 421
; ISEL-NEXT:    li 3, 42
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: select_C1_C2:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, 421
; NO_ISEL-NEXT:    li 3, 42
; NO_ISEL-NEXT:    bc 12, 1, .LBB18_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB18_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i32 421, i32 42
  ret i32 %sel
}

define i32 @select_C1_C2_zeroext(i1 zeroext %cond) {
; ISEL-LABEL: select_C1_C2_zeroext:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, 421
; ISEL-NEXT:    li 3, 42
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: select_C1_C2_zeroext:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, 421
; NO_ISEL-NEXT:    li 3, 42
; NO_ISEL-NEXT:    bc 12, 1, .LBB19_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB19_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i32 421, i32 42
  ret i32 %sel
}

define i32 @select_C1_C2_signext(i1 signext %cond) {
; ISEL-LABEL: select_C1_C2_signext:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, 421
; ISEL-NEXT:    li 3, 42
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: select_C1_C2_signext:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, 421
; NO_ISEL-NEXT:    li 3, 42
; NO_ISEL-NEXT:    bc 12, 1, .LBB20_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB20_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i32 421, i32 42
  ret i32 %sel
}

; A binary operator with constant after the select should always get folded into the select.

define i8 @sel_constants_add_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_add_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, 1
; ISEL-NEXT:    li 3, 28
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_add_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, 1
; NO_ISEL-NEXT:    li 3, 28
; NO_ISEL-NEXT:    bc 12, 1, .LBB21_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB21_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = add i8 %sel, 5
  ret i8 %bo
}

define i8 @sel_constants_sub_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_sub_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, -9
; ISEL-NEXT:    li 3, 18
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_sub_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, -9
; NO_ISEL-NEXT:    li 3, 18
; NO_ISEL-NEXT:    bc 12, 1, .LBB22_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB22_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = sub i8 %sel, 5
  ret i8 %bo
}

define i8 @sel_constants_sub_constant_sel_constants(i1 %cond) {
; ISEL-LABEL: sel_constants_sub_constant_sel_constants:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, 9
; ISEL-NEXT:    li 3, 2
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_sub_constant_sel_constants:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, 9
; NO_ISEL-NEXT:    li 3, 2
; NO_ISEL-NEXT:    bc 12, 1, .LBB23_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB23_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 3
  %bo = sub i8 5, %sel
  ret i8 %bo
}

define i8 @sel_constants_mul_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_mul_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, -20
; ISEL-NEXT:    li 3, 115
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_mul_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, -20
; NO_ISEL-NEXT:    li 3, 115
; NO_ISEL-NEXT:    bc 12, 1, .LBB24_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB24_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = mul i8 %sel, 5
  ret i8 %bo
}

define i8 @sel_constants_sdiv_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_sdiv_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 3, 4
; ISEL-NEXT:    iselgt 3, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_sdiv_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 3, 4
; NO_ISEL-NEXT:    bc 12, 1, .LBB25_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB25_1:
; NO_ISEL-NEXT:    li 3, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = sdiv i8 %sel, 5
  ret i8 %bo
}

define i8 @sdiv_constant_sel_constants(i1 %cond) {
; ISEL-LABEL: sdiv_constant_sel_constants:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 3, 5
; ISEL-NEXT:    iselgt 3, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sdiv_constant_sel_constants:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 3, 5
; NO_ISEL-NEXT:    bc 12, 1, .LBB26_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB26_1:
; NO_ISEL-NEXT:    li 3, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 121, i8 23
  %bo = sdiv i8 120, %sel
  ret i8 %bo
}

define i8 @sel_constants_udiv_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_udiv_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, 50
; ISEL-NEXT:    li 3, 4
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_udiv_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, 50
; NO_ISEL-NEXT:    li 3, 4
; NO_ISEL-NEXT:    bc 12, 1, .LBB27_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB27_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = udiv i8 %sel, 5
  ret i8 %bo
}

define i8 @udiv_constant_sel_constants(i1 %cond) {
; ISEL-LABEL: udiv_constant_sel_constants:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 3, 5
; ISEL-NEXT:    iselgt 3, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: udiv_constant_sel_constants:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 3, 5
; NO_ISEL-NEXT:    bc 12, 1, .LBB28_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB28_1:
; NO_ISEL-NEXT:    li 3, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = udiv i8 120, %sel
  ret i8 %bo
}

define i8 @sel_constants_srem_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_srem_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, -4
; ISEL-NEXT:    li 3, 3
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_srem_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, -4
; NO_ISEL-NEXT:    li 3, 3
; NO_ISEL-NEXT:    bc 12, 1, .LBB29_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB29_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = srem i8 %sel, 5
  ret i8 %bo
}

define i8 @srem_constant_sel_constants(i1 %cond) {
; ISEL-LABEL: srem_constant_sel_constants:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, 120
; ISEL-NEXT:    li 3, 5
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: srem_constant_sel_constants:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, 120
; NO_ISEL-NEXT:    li 3, 5
; NO_ISEL-NEXT:    bc 12, 1, .LBB30_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB30_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 121, i8 23
  %bo = srem i8 120, %sel
  ret i8 %bo
}

define i8 @sel_constants_urem_constant(i1 %cond) {
; ALL-LABEL: sel_constants_urem_constant:
; ALL:       # %bb.0:
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    subfic 3, 3, 3
; ALL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = urem i8 %sel, 5
  ret i8 %bo
}

define i8 @urem_constant_sel_constants(i1 %cond) {
; ISEL-LABEL: urem_constant_sel_constants:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, 120
; ISEL-NEXT:    li 3, 5
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: urem_constant_sel_constants:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, 120
; NO_ISEL-NEXT:    li 3, 5
; NO_ISEL-NEXT:    bc 12, 1, .LBB32_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB32_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = urem i8 120, %sel
  ret i8 %bo
}

define i8 @sel_constants_and_constant(i1 %cond) {
; ALL-LABEL: sel_constants_and_constant:
; ALL:       # %bb.0:
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    subfic 3, 3, 5
; ALL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = and i8 %sel, 5
  ret i8 %bo
}

define i8 @sel_constants_or_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_or_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, -3
; ISEL-NEXT:    li 3, 23
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_or_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, -3
; NO_ISEL-NEXT:    li 3, 23
; NO_ISEL-NEXT:    bc 12, 1, .LBB34_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB34_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = or i8 %sel, 5
  ret i8 %bo
}

define i8 @sel_constants_xor_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_xor_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, -7
; ISEL-NEXT:    li 3, 18
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_xor_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, -7
; NO_ISEL-NEXT:    li 3, 18
; NO_ISEL-NEXT:    bc 12, 1, .LBB35_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB35_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = xor i8 %sel, 5
  ret i8 %bo
}

define i8 @sel_constants_shl_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_shl_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, -128
; ISEL-NEXT:    li 3, -32
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_shl_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, -128
; NO_ISEL-NEXT:    li 3, -32
; NO_ISEL-NEXT:    bc 12, 1, .LBB36_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB36_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = shl i8 %sel, 5
  ret i8 %bo
}

define i8 @shl_constant_sel_constants(i1 %cond) {
; ALL-LABEL: shl_constant_sel_constants:
; ALL:       # %bb.0:
; ALL-NEXT:    clrlwi 3, 3, 31
; ALL-NEXT:    li 4, 1
; ALL-NEXT:    subfic 3, 3, 3
; ALL-NEXT:    slw 3, 4, 3
; ALL-NEXT:    blr
  %sel = select i1 %cond, i8 2, i8 3
  %bo = shl i8 1, %sel
  ret i8 %bo
}

define i8 @sel_constants_lshr_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_lshr_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    li 4, 7
; ISEL-NEXT:    li 3, 0
; ISEL-NEXT:    iselgt 3, 4, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_lshr_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    li 4, 7
; NO_ISEL-NEXT:    li 3, 0
; NO_ISEL-NEXT:    bc 12, 1, .LBB38_1
; NO_ISEL-NEXT:    blr
; NO_ISEL-NEXT:  .LBB38_1:
; NO_ISEL-NEXT:    addi 3, 4, 0
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = lshr i8 %sel, 5
  ret i8 %bo
}

define i8 @lshr_constant_sel_constants(i1 %cond) {
; ALL-LABEL: lshr_constant_sel_constants:
; ALL:       # %bb.0:
; ALL-NEXT:    clrlwi 3, 3, 31
; ALL-NEXT:    li 4, 64
; ALL-NEXT:    subfic 3, 3, 3
; ALL-NEXT:    srw 3, 4, 3
; ALL-NEXT:    blr
  %sel = select i1 %cond, i8 2, i8 3
  %bo = lshr i8 64, %sel
  ret i8 %bo
}


define i8 @sel_constants_ashr_constant(i1 %cond) {
; ALL-LABEL: sel_constants_ashr_constant:
; ALL:       # %bb.0:
; ALL-NEXT:    clrldi 3, 3, 63
; ALL-NEXT:    neg 3, 3
; ALL-NEXT:    blr
  %sel = select i1 %cond, i8 -4, i8 23
  %bo = ashr i8 %sel, 5
  ret i8 %bo
}

define i8 @ashr_constant_sel_constants(i1 %cond) {
; ALL-LABEL: ashr_constant_sel_constants:
; ALL:       # %bb.0:
; ALL-NEXT:    clrlwi 3, 3, 31
; ALL-NEXT:    li 4, -128
; ALL-NEXT:    subfic 3, 3, 3
; ALL-NEXT:    sraw 3, 4, 3
; ALL-NEXT:    blr
  %sel = select i1 %cond, i8 2, i8 3
  %bo = ashr i8 128, %sel
  ret i8 %bo
}

define double @sel_constants_fadd_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_fadd_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    addis 4, 2, .LCPI42_0@toc@ha
; ISEL-NEXT:    addis 3, 2, .LCPI42_1@toc@ha
; ISEL-NEXT:    addi 4, 4, .LCPI42_0@toc@l
; ISEL-NEXT:    addi 3, 3, .LCPI42_1@toc@l
; ISEL-NEXT:    iselgt 3, 3, 4
; ISEL-NEXT:    lfdx 1, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_fadd_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    addis 4, 2, .LCPI42_0@toc@ha
; NO_ISEL-NEXT:    addis 3, 2, .LCPI42_1@toc@ha
; NO_ISEL-NEXT:    addi 4, 4, .LCPI42_0@toc@l
; NO_ISEL-NEXT:    addi 3, 3, .LCPI42_1@toc@l
; NO_ISEL-NEXT:    bc 12, 1, .LBB42_2
; NO_ISEL-NEXT:  # %bb.1:
; NO_ISEL-NEXT:    ori 3, 4, 0
; NO_ISEL-NEXT:    b .LBB42_2
; NO_ISEL-NEXT:  .LBB42_2:
; NO_ISEL-NEXT:    lfdx 1, 0, 3
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = fadd double %sel, 5.1
  ret double %bo
}

define double @sel_constants_fsub_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_fsub_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    addis 4, 2, .LCPI43_0@toc@ha
; ISEL-NEXT:    addis 3, 2, .LCPI43_1@toc@ha
; ISEL-NEXT:    addi 4, 4, .LCPI43_0@toc@l
; ISEL-NEXT:    addi 3, 3, .LCPI43_1@toc@l
; ISEL-NEXT:    iselgt 3, 3, 4
; ISEL-NEXT:    lfdx 1, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_fsub_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    addis 4, 2, .LCPI43_0@toc@ha
; NO_ISEL-NEXT:    addis 3, 2, .LCPI43_1@toc@ha
; NO_ISEL-NEXT:    addi 4, 4, .LCPI43_0@toc@l
; NO_ISEL-NEXT:    addi 3, 3, .LCPI43_1@toc@l
; NO_ISEL-NEXT:    bc 12, 1, .LBB43_2
; NO_ISEL-NEXT:  # %bb.1:
; NO_ISEL-NEXT:    ori 3, 4, 0
; NO_ISEL-NEXT:    b .LBB43_2
; NO_ISEL-NEXT:  .LBB43_2:
; NO_ISEL-NEXT:    lfdx 1, 0, 3
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = fsub double %sel, 5.1
  ret double %bo
}

define double @fsub_constant_sel_constants(i1 %cond) {
; ISEL-LABEL: fsub_constant_sel_constants:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    addis 4, 2, .LCPI44_0@toc@ha
; ISEL-NEXT:    addis 3, 2, .LCPI44_1@toc@ha
; ISEL-NEXT:    addi 4, 4, .LCPI44_0@toc@l
; ISEL-NEXT:    addi 3, 3, .LCPI44_1@toc@l
; ISEL-NEXT:    iselgt 3, 3, 4
; ISEL-NEXT:    lfdx 1, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: fsub_constant_sel_constants:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    addis 4, 2, .LCPI44_0@toc@ha
; NO_ISEL-NEXT:    addis 3, 2, .LCPI44_1@toc@ha
; NO_ISEL-NEXT:    addi 4, 4, .LCPI44_0@toc@l
; NO_ISEL-NEXT:    addi 3, 3, .LCPI44_1@toc@l
; NO_ISEL-NEXT:    bc 12, 1, .LBB44_2
; NO_ISEL-NEXT:  # %bb.1:
; NO_ISEL-NEXT:    ori 3, 4, 0
; NO_ISEL-NEXT:    b .LBB44_2
; NO_ISEL-NEXT:  .LBB44_2:
; NO_ISEL-NEXT:    lfdx 1, 0, 3
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = fsub double 5.1, %sel
  ret double %bo
}

define double @sel_constants_fmul_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_fmul_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    addis 4, 2, .LCPI45_0@toc@ha
; ISEL-NEXT:    addis 3, 2, .LCPI45_1@toc@ha
; ISEL-NEXT:    addi 4, 4, .LCPI45_0@toc@l
; ISEL-NEXT:    addi 3, 3, .LCPI45_1@toc@l
; ISEL-NEXT:    iselgt 3, 3, 4
; ISEL-NEXT:    lfdx 1, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_fmul_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    addis 4, 2, .LCPI45_0@toc@ha
; NO_ISEL-NEXT:    addis 3, 2, .LCPI45_1@toc@ha
; NO_ISEL-NEXT:    addi 4, 4, .LCPI45_0@toc@l
; NO_ISEL-NEXT:    addi 3, 3, .LCPI45_1@toc@l
; NO_ISEL-NEXT:    bc 12, 1, .LBB45_2
; NO_ISEL-NEXT:  # %bb.1:
; NO_ISEL-NEXT:    ori 3, 4, 0
; NO_ISEL-NEXT:    b .LBB45_2
; NO_ISEL-NEXT:  .LBB45_2:
; NO_ISEL-NEXT:    lfdx 1, 0, 3
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = fmul double %sel, 5.1
  ret double %bo
}

define double @sel_constants_fdiv_constant(i1 %cond) {
; ISEL-LABEL: sel_constants_fdiv_constant:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    addis 4, 2, .LCPI46_0@toc@ha
; ISEL-NEXT:    addis 3, 2, .LCPI46_1@toc@ha
; ISEL-NEXT:    addi 4, 4, .LCPI46_0@toc@l
; ISEL-NEXT:    addi 3, 3, .LCPI46_1@toc@l
; ISEL-NEXT:    iselgt 3, 3, 4
; ISEL-NEXT:    lfdx 1, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: sel_constants_fdiv_constant:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    addis 4, 2, .LCPI46_0@toc@ha
; NO_ISEL-NEXT:    addis 3, 2, .LCPI46_1@toc@ha
; NO_ISEL-NEXT:    addi 4, 4, .LCPI46_0@toc@l
; NO_ISEL-NEXT:    addi 3, 3, .LCPI46_1@toc@l
; NO_ISEL-NEXT:    bc 12, 1, .LBB46_2
; NO_ISEL-NEXT:  # %bb.1:
; NO_ISEL-NEXT:    ori 3, 4, 0
; NO_ISEL-NEXT:    b .LBB46_2
; NO_ISEL-NEXT:  .LBB46_2:
; NO_ISEL-NEXT:    lfdx 1, 0, 3
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = fdiv double %sel, 5.1
  ret double %bo
}

define double @fdiv_constant_sel_constants(i1 %cond) {
; ISEL-LABEL: fdiv_constant_sel_constants:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    addis 4, 2, .LCPI47_0@toc@ha
; ISEL-NEXT:    addis 3, 2, .LCPI47_1@toc@ha
; ISEL-NEXT:    addi 4, 4, .LCPI47_0@toc@l
; ISEL-NEXT:    addi 3, 3, .LCPI47_1@toc@l
; ISEL-NEXT:    iselgt 3, 3, 4
; ISEL-NEXT:    lfdx 1, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: fdiv_constant_sel_constants:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    addis 4, 2, .LCPI47_0@toc@ha
; NO_ISEL-NEXT:    addis 3, 2, .LCPI47_1@toc@ha
; NO_ISEL-NEXT:    addi 4, 4, .LCPI47_0@toc@l
; NO_ISEL-NEXT:    addi 3, 3, .LCPI47_1@toc@l
; NO_ISEL-NEXT:    bc 12, 1, .LBB47_2
; NO_ISEL-NEXT:  # %bb.1:
; NO_ISEL-NEXT:    ori 3, 4, 0
; NO_ISEL-NEXT:    b .LBB47_2
; NO_ISEL-NEXT:  .LBB47_2:
; NO_ISEL-NEXT:    lfdx 1, 0, 3
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = fdiv double 5.1, %sel
  ret double %bo
}

define double @sel_constants_frem_constant(i1 %cond) {
; ALL-LABEL: sel_constants_frem_constant:
; ALL:       # %bb.0:
; ALL-NEXT:    andi. 3, 3, 1
; ALL-NEXT:    bc 12, 1, .LBB48_2
; ALL-NEXT:  # %bb.1:
; ALL-NEXT:    addis 3, 2, .LCPI48_0@toc@ha
; ALL-NEXT:    lfd 1, .LCPI48_0@toc@l(3)
; ALL-NEXT:    blr
; ALL-NEXT:  .LBB48_2:
; ALL-NEXT:    addis 3, 2, .LCPI48_1@toc@ha
; ALL-NEXT:    lfs 1, .LCPI48_1@toc@l(3)
; ALL-NEXT:    blr
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = frem double %sel, 5.1
  ret double %bo
}

define double @frem_constant_sel_constants(i1 %cond) {
; ISEL-LABEL: frem_constant_sel_constants:
; ISEL:       # %bb.0:
; ISEL-NEXT:    andi. 3, 3, 1
; ISEL-NEXT:    addis 4, 2, .LCPI49_0@toc@ha
; ISEL-NEXT:    addis 3, 2, .LCPI49_1@toc@ha
; ISEL-NEXT:    addi 4, 4, .LCPI49_0@toc@l
; ISEL-NEXT:    addi 3, 3, .LCPI49_1@toc@l
; ISEL-NEXT:    iselgt 3, 3, 4
; ISEL-NEXT:    lfdx 1, 0, 3
; ISEL-NEXT:    blr
;
; NO_ISEL-LABEL: frem_constant_sel_constants:
; NO_ISEL:       # %bb.0:
; NO_ISEL-NEXT:    andi. 3, 3, 1
; NO_ISEL-NEXT:    addis 4, 2, .LCPI49_0@toc@ha
; NO_ISEL-NEXT:    addis 3, 2, .LCPI49_1@toc@ha
; NO_ISEL-NEXT:    addi 4, 4, .LCPI49_0@toc@l
; NO_ISEL-NEXT:    addi 3, 3, .LCPI49_1@toc@l
; NO_ISEL-NEXT:    bc 12, 1, .LBB49_2
; NO_ISEL-NEXT:  # %bb.1:
; NO_ISEL-NEXT:    ori 3, 4, 0
; NO_ISEL-NEXT:    b .LBB49_2
; NO_ISEL-NEXT:  .LBB49_2:
; NO_ISEL-NEXT:    lfdx 1, 0, 3
; NO_ISEL-NEXT:    blr
  %sel = select i1 %cond, double -4.0, double 23.3
  %bo = frem double 5.1, %sel
  ret double %bo
}
