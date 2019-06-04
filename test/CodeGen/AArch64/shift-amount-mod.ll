; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-unknown | FileCheck %s

;==============================================================================;
; the shift amount is negated (shiftbitwidth - shiftamt)
;==============================================================================;

; shift left
;------------------------------------------------------------------------------;

define i32 @reg32_shl_by_negated(i32 %val, i32 %shamt) nounwind {
; CHECK-LABEL: reg32_shl_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    lsl w0, w0, w8
; CHECK-NEXT:    ret
  %negshamt = sub i32 32, %shamt
  %shifted = shl i32 %val, %negshamt
  ret i32 %shifted
}
define i32 @load32_shl_by_negated(i32* %valptr, i32 %shamt) nounwind {
; CHECK-LABEL: load32_shl_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    neg w9, w1
; CHECK-NEXT:    lsl w0, w8, w9
; CHECK-NEXT:    ret
  %val = load i32, i32* %valptr
  %negshamt = sub i32 32, %shamt
  %shifted = shl i32 %val, %negshamt
  ret i32 %shifted
}
define void @store32_shl_by_negated(i32 %val, i32* %dstptr, i32 %shamt) nounwind {
; CHECK-LABEL: store32_shl_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w2
; CHECK-NEXT:    lsl w8, w0, w8
; CHECK-NEXT:    str w8, [x1]
; CHECK-NEXT:    ret
  %negshamt = sub i32 32, %shamt
  %shifted = shl i32 %val, %negshamt
  store i32 %shifted, i32* %dstptr
  ret void
}
define void @modify32_shl_by_negated(i32* %valptr, i32 %shamt) nounwind {
; CHECK-LABEL: modify32_shl_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    neg w9, w1
; CHECK-NEXT:    lsl w8, w8, w9
; CHECK-NEXT:    str w8, [x0]
; CHECK-NEXT:    ret
  %val = load i32, i32* %valptr
  %negshamt = sub i32 32, %shamt
  %shifted = shl i32 %val, %negshamt
  store i32 %shifted, i32* %valptr
  ret void
}

define i64 @reg64_shl_by_negated(i64 %val, i64 %shamt) nounwind {
; CHECK-LABEL: reg64_shl_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x8, x1
; CHECK-NEXT:    lsl x0, x0, x8
; CHECK-NEXT:    ret
  %negshamt = sub i64 64, %shamt
  %shifted = shl i64 %val, %negshamt
  ret i64 %shifted
}
define i64 @load64_shl_by_negated(i64* %valptr, i64 %shamt) nounwind {
; CHECK-LABEL: load64_shl_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    neg x9, x1
; CHECK-NEXT:    lsl x0, x8, x9
; CHECK-NEXT:    ret
  %val = load i64, i64* %valptr
  %negshamt = sub i64 64, %shamt
  %shifted = shl i64 %val, %negshamt
  ret i64 %shifted
}
define void @store64_shl_by_negated(i64 %val, i64* %dstptr, i64 %shamt) nounwind {
; CHECK-LABEL: store64_shl_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x8, x2
; CHECK-NEXT:    lsl x8, x0, x8
; CHECK-NEXT:    str x8, [x1]
; CHECK-NEXT:    ret
  %negshamt = sub i64 64, %shamt
  %shifted = shl i64 %val, %negshamt
  store i64 %shifted, i64* %dstptr
  ret void
}
define void @modify64_shl_by_negated(i64* %valptr, i64 %shamt) nounwind {
; CHECK-LABEL: modify64_shl_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    neg x9, x1
; CHECK-NEXT:    lsl x8, x8, x9
; CHECK-NEXT:    str x8, [x0]
; CHECK-NEXT:    ret
  %val = load i64, i64* %valptr
  %negshamt = sub i64 64, %shamt
  %shifted = shl i64 %val, %negshamt
  store i64 %shifted, i64* %valptr
  ret void
}

; logical shift right
;------------------------------------------------------------------------------;

define i32 @reg32_lshr_by_negated(i32 %val, i32 %shamt) nounwind {
; CHECK-LABEL: reg32_lshr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %negshamt = sub i32 32, %shamt
  %shifted = lshr i32 %val, %negshamt
  ret i32 %shifted
}
define i32 @load32_lshr_by_negated(i32* %valptr, i32 %shamt) nounwind {
; CHECK-LABEL: load32_lshr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    neg w9, w1
; CHECK-NEXT:    lsr w0, w8, w9
; CHECK-NEXT:    ret
  %val = load i32, i32* %valptr
  %negshamt = sub i32 32, %shamt
  %shifted = lshr i32 %val, %negshamt
  ret i32 %shifted
}
define void @store32_lshr_by_negated(i32 %val, i32* %dstptr, i32 %shamt) nounwind {
; CHECK-LABEL: store32_lshr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w2
; CHECK-NEXT:    lsr w8, w0, w8
; CHECK-NEXT:    str w8, [x1]
; CHECK-NEXT:    ret
  %negshamt = sub i32 32, %shamt
  %shifted = lshr i32 %val, %negshamt
  store i32 %shifted, i32* %dstptr
  ret void
}
define void @modify32_lshr_by_negated(i32* %valptr, i32 %shamt) nounwind {
; CHECK-LABEL: modify32_lshr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    neg w9, w1
; CHECK-NEXT:    lsr w8, w8, w9
; CHECK-NEXT:    str w8, [x0]
; CHECK-NEXT:    ret
  %val = load i32, i32* %valptr
  %negshamt = sub i32 32, %shamt
  %shifted = lshr i32 %val, %negshamt
  store i32 %shifted, i32* %valptr
  ret void
}

define i64 @reg64_lshr_by_negated(i64 %val, i64 %shamt) nounwind {
; CHECK-LABEL: reg64_lshr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x8, x1
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %negshamt = sub i64 64, %shamt
  %shifted = lshr i64 %val, %negshamt
  ret i64 %shifted
}
define i64 @load64_lshr_by_negated(i64* %valptr, i64 %shamt) nounwind {
; CHECK-LABEL: load64_lshr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    neg x9, x1
; CHECK-NEXT:    lsr x0, x8, x9
; CHECK-NEXT:    ret
  %val = load i64, i64* %valptr
  %negshamt = sub i64 64, %shamt
  %shifted = lshr i64 %val, %negshamt
  ret i64 %shifted
}
define void @store64_lshr_by_negated(i64 %val, i64* %dstptr, i64 %shamt) nounwind {
; CHECK-LABEL: store64_lshr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x8, x2
; CHECK-NEXT:    lsr x8, x0, x8
; CHECK-NEXT:    str x8, [x1]
; CHECK-NEXT:    ret
  %negshamt = sub i64 64, %shamt
  %shifted = lshr i64 %val, %negshamt
  store i64 %shifted, i64* %dstptr
  ret void
}
define void @modify64_lshr_by_negated(i64* %valptr, i64 %shamt) nounwind {
; CHECK-LABEL: modify64_lshr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    neg x9, x1
; CHECK-NEXT:    lsr x8, x8, x9
; CHECK-NEXT:    str x8, [x0]
; CHECK-NEXT:    ret
  %val = load i64, i64* %valptr
  %negshamt = sub i64 64, %shamt
  %shifted = lshr i64 %val, %negshamt
  store i64 %shifted, i64* %valptr
  ret void
}

; arithmetic shift right
;------------------------------------------------------------------------------;

define i32 @reg32_ashr_by_negated(i32 %val, i32 %shamt) nounwind {
; CHECK-LABEL: reg32_ashr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    asr w0, w0, w8
; CHECK-NEXT:    ret
  %negshamt = sub i32 32, %shamt
  %shifted = ashr i32 %val, %negshamt
  ret i32 %shifted
}
define i32 @load32_ashr_by_negated(i32* %valptr, i32 %shamt) nounwind {
; CHECK-LABEL: load32_ashr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    neg w9, w1
; CHECK-NEXT:    asr w0, w8, w9
; CHECK-NEXT:    ret
  %val = load i32, i32* %valptr
  %negshamt = sub i32 32, %shamt
  %shifted = ashr i32 %val, %negshamt
  ret i32 %shifted
}
define void @store32_ashr_by_negated(i32 %val, i32* %dstptr, i32 %shamt) nounwind {
; CHECK-LABEL: store32_ashr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w2
; CHECK-NEXT:    asr w8, w0, w8
; CHECK-NEXT:    str w8, [x1]
; CHECK-NEXT:    ret
  %negshamt = sub i32 32, %shamt
  %shifted = ashr i32 %val, %negshamt
  store i32 %shifted, i32* %dstptr
  ret void
}
define void @modify32_ashr_by_negated(i32* %valptr, i32 %shamt) nounwind {
; CHECK-LABEL: modify32_ashr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    neg w9, w1
; CHECK-NEXT:    asr w8, w8, w9
; CHECK-NEXT:    str w8, [x0]
; CHECK-NEXT:    ret
  %val = load i32, i32* %valptr
  %negshamt = sub i32 32, %shamt
  %shifted = ashr i32 %val, %negshamt
  store i32 %shifted, i32* %valptr
  ret void
}

define i64 @reg64_ashr_by_negated(i64 %val, i64 %shamt) nounwind {
; CHECK-LABEL: reg64_ashr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x8, x1
; CHECK-NEXT:    asr x0, x0, x8
; CHECK-NEXT:    ret
  %negshamt = sub i64 64, %shamt
  %shifted = ashr i64 %val, %negshamt
  ret i64 %shifted
}
define i64 @load64_ashr_by_negated(i64* %valptr, i64 %shamt) nounwind {
; CHECK-LABEL: load64_ashr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    neg x9, x1
; CHECK-NEXT:    asr x0, x8, x9
; CHECK-NEXT:    ret
  %val = load i64, i64* %valptr
  %negshamt = sub i64 64, %shamt
  %shifted = ashr i64 %val, %negshamt
  ret i64 %shifted
}
define void @store64_ashr_by_negated(i64 %val, i64* %dstptr, i64 %shamt) nounwind {
; CHECK-LABEL: store64_ashr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x8, x2
; CHECK-NEXT:    asr x8, x0, x8
; CHECK-NEXT:    str x8, [x1]
; CHECK-NEXT:    ret
  %negshamt = sub i64 64, %shamt
  %shifted = ashr i64 %val, %negshamt
  store i64 %shifted, i64* %dstptr
  ret void
}
define void @modify64_ashr_by_negated(i64* %valptr, i64 %shamt) nounwind {
; CHECK-LABEL: modify64_ashr_by_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    neg x9, x1
; CHECK-NEXT:    asr x8, x8, x9
; CHECK-NEXT:    str x8, [x0]
; CHECK-NEXT:    ret
  %val = load i64, i64* %valptr
  %negshamt = sub i64 64, %shamt
  %shifted = ashr i64 %val, %negshamt
  store i64 %shifted, i64* %valptr
  ret void
}

;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;
; next let's only test simple reg pattern, and only lshr.
;||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||;

;==============================================================================;
; subtraction from negated shift amount

define i32 @reg32_lshr_by_sub_from_negated(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_sub_from_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #32
; CHECK-NEXT:    sub w8, w8, w1
; CHECK-NEXT:    sub w8, w8, w2
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 32, %a
  %negasubb = sub i32 %nega, %b
  %shifted = lshr i32 %val, %negasubb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_sub_from_negated(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_sub_from_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w8, #64
; CHECK-NEXT:    sub x8, x8, x1
; CHECK-NEXT:    sub x8, x8, x2
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 64, %a
  %negasubb = sub i64 %nega, %b
  %shifted = lshr i64 %val, %negasubb
  ret i64 %shifted
}

;==============================================================================;
; subtraction of negated shift amount

define i32 @reg32_lshr_by_sub_of_negated(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_sub_of_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w1, w2
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 32, %a
  %negasubb = sub i32 %b, %nega
  %shifted = lshr i32 %val, %negasubb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_sub_of_negated(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_sub_of_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add x8, x1, x2
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 64, %a
  %negasubb = sub i64 %b, %nega
  %shifted = lshr i64 %val, %negasubb
  ret i64 %shifted
}

;==============================================================================;
; add to negated shift amount
;

define i32 @reg32_lshr_by_add_to_negated(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_add_to_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w8, w2, w1
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 32, %a
  %negasubb = add i32 %nega, %b
  %shifted = lshr i32 %val, %negasubb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_add_to_negated(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_add_to_negated:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub x8, x2, x1
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 64, %a
  %negasubb = add i64 %nega, %b
  %shifted = lshr i64 %val, %negasubb
  ret i64 %shifted
}

;==============================================================================;
; subtraction of negated shift amounts

define i32 @reg32_lshr_by_sub_of_negated_amts(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_sub_of_negated_amts:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w8, w2, w1
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 32, %a
  %negb = sub i32 32, %b
  %negasubnegb = sub i32 %nega, %negb
  %shifted = lshr i32 %val, %negasubnegb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_sub_of_negated_amts(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_sub_of_negated_amts:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub x8, x2, x1
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 64, %a
  %negb = sub i64 64, %b
  %negasubnegb = sub i64 %nega, %negb
  %shifted = lshr i64 %val, %negasubnegb
  ret i64 %shifted
}

;==============================================================================;
; addition of negated shift amounts

define i32 @reg32_lshr_by_add_of_negated_amts(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_add_of_negated_amts:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w1, w2
; CHECK-NEXT:    neg w8, w8
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 32, %a
  %negb = sub i32 32, %b
  %negasubnegb = add i32 %nega, %negb
  %shifted = lshr i32 %val, %negasubnegb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_add_of_negated_amts(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_add_of_negated_amts:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add x8, x1, x2
; CHECK-NEXT:    neg x8, x8
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 64, %a
  %negb = sub i64 64, %b
  %negasubnegb = add i64 %nega, %negb
  %shifted = lshr i64 %val, %negasubnegb
  ret i64 %shifted
}

;==============================================================================;
; and patterns with an actual negation+addition

define i32 @reg32_lshr_by_negated_unfolded(i32 %val, i32 %shamt) nounwind {
; CHECK-LABEL: reg32_lshr_by_negated_unfolded:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %negshamt = sub i32 0, %shamt
  %negaaddbitwidth = add i32 %negshamt, 32
  %shifted = lshr i32 %val, %negaaddbitwidth
  ret i32 %shifted
}
define i64 @reg64_lshr_by_negated_unfolded(i64 %val, i64 %shamt) nounwind {
; CHECK-LABEL: reg64_lshr_by_negated_unfolded:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x8, x1
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %negshamt = sub i64 0, %shamt
  %negaaddbitwidth = add i64 %negshamt, 64
  %shifted = lshr i64 %val, %negaaddbitwidth
  ret i64 %shifted
}

define i32 @reg32_lshr_by_negated_unfolded_sub_b(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_negated_unfolded_sub_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    sub w8, w8, w2
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 0, %a
  %negaaddbitwidth = add i32 %nega, 32
  %negaaddbitwidthsubb = sub i32 %negaaddbitwidth, %b
  %shifted = lshr i32 %val, %negaaddbitwidthsubb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_negated_unfolded_sub_b(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_negated_unfolded_sub_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x8, x1
; CHECK-NEXT:    sub x8, x8, x2
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 0, %a
  %negaaddbitwidth = add i64 %nega, 64
  %negaaddbitwidthsubb = sub i64 %negaaddbitwidth, %b
  %shifted = lshr i64 %val, %negaaddbitwidthsubb
  ret i64 %shifted
}

define i32 @reg32_lshr_by_b_sub_negated_unfolded(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_b_sub_negated_unfolded:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add w8, w2, w1
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 0, %a
  %negaaddbitwidth = add i32 %nega, 32
  %negaaddbitwidthsubb = sub i32 %b, %negaaddbitwidth
  %shifted = lshr i32 %val, %negaaddbitwidthsubb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_b_sub_negated_unfolded(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_b_sub_negated_unfolded:
; CHECK:       // %bb.0:
; CHECK-NEXT:    add x8, x2, x1
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 0, %a
  %negaaddbitwidth = add i64 %nega, 64
  %negaaddbitwidthsubb = sub i64 %b, %negaaddbitwidth
  %shifted = lshr i64 %val, %negaaddbitwidthsubb
  ret i64 %shifted
}

define i32 @reg32_lshr_by_negated_unfolded_add_b(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_negated_unfolded_add_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub w8, w2, w1
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 0, %a
  %negaaddbitwidth = add i32 %nega, 32
  %negaaddbitwidthaddb = add i32 %negaaddbitwidth, %b
  %shifted = lshr i32 %val, %negaaddbitwidthaddb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_negated_unfolded_add_b(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_negated_unfolded_add_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    sub x8, x2, x1
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 0, %a
  %negaaddbitwidth = add i64 %nega, 64
  %negaaddbitwidthaddb = add i64 %negaaddbitwidth, %b
  %shifted = lshr i64 %val, %negaaddbitwidthaddb
  ret i64 %shifted
}

;==============================================================================;
; and patterns with an actual negation+mask

define i32 @reg32_lshr_by_masked_negated_unfolded(i32 %val, i32 %shamt) nounwind {
; CHECK-LABEL: reg32_lshr_by_masked_negated_unfolded:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %negshamt = sub i32 0, %shamt
  %negaaddbitwidth = and i32 %negshamt, 31
  %shifted = lshr i32 %val, %negaaddbitwidth
  ret i32 %shifted
}
define i64 @reg64_lshr_by_masked_negated_unfolded(i64 %val, i64 %shamt) nounwind {
; CHECK-LABEL: reg64_lshr_by_masked_negated_unfolded:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %negshamt = sub i64 0, %shamt
  %negaaddbitwidth = and i64 %negshamt, 63
  %shifted = lshr i64 %val, %negaaddbitwidth
  ret i64 %shifted
}

define i32 @reg32_lshr_by_masked_negated_unfolded_sub_b(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_masked_negated_unfolded_sub_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    and w8, w8, #0x1f
; CHECK-NEXT:    sub w8, w8, w2
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 0, %a
  %negaaddbitwidth = and i32 %nega, 31
  %negaaddbitwidthsubb = sub i32 %negaaddbitwidth, %b
  %shifted = lshr i32 %val, %negaaddbitwidthsubb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_masked_negated_unfolded_sub_b(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_masked_negated_unfolded_sub_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    and x8, x8, #0x3f
; CHECK-NEXT:    sub x8, x8, x2
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 0, %a
  %negaaddbitwidth = and i64 %nega, 63
  %negaaddbitwidthsubb = sub i64 %negaaddbitwidth, %b
  %shifted = lshr i64 %val, %negaaddbitwidthsubb
  ret i64 %shifted
}

define i32 @reg32_lshr_by_masked_b_sub_negated_unfolded(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_masked_b_sub_negated_unfolded:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    and w8, w8, #0x1f
; CHECK-NEXT:    sub w8, w2, w8
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 0, %a
  %negaaddbitwidth = and i32 %nega, 31
  %negaaddbitwidthsubb = sub i32 %b, %negaaddbitwidth
  %shifted = lshr i32 %val, %negaaddbitwidthsubb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_masked_b_sub_negated_unfolded(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_masked_b_sub_negated_unfolded:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    and x8, x8, #0x3f
; CHECK-NEXT:    sub x8, x2, x8
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 0, %a
  %negaaddbitwidth = and i64 %nega, 63
  %negaaddbitwidthsubb = sub i64 %b, %negaaddbitwidth
  %shifted = lshr i64 %val, %negaaddbitwidthsubb
  ret i64 %shifted
}

define i32 @reg32_lshr_by_masked_negated_unfolded_add_b(i32 %val, i32 %a, i32 %b) nounwind {
; CHECK-LABEL: reg32_lshr_by_masked_negated_unfolded_add_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    and w8, w8, #0x1f
; CHECK-NEXT:    add w8, w8, w2
; CHECK-NEXT:    lsr w0, w0, w8
; CHECK-NEXT:    ret
  %nega = sub i32 0, %a
  %negaaddbitwidth = and i32 %nega, 31
  %negaaddbitwidthaddb = add i32 %negaaddbitwidth, %b
  %shifted = lshr i32 %val, %negaaddbitwidthaddb
  ret i32 %shifted
}
define i64 @reg64_lshr_by_masked_negated_unfolded_add_b(i64 %val, i64 %a, i64 %b) nounwind {
; CHECK-LABEL: reg64_lshr_by_masked_negated_unfolded_add_b:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w8, w1
; CHECK-NEXT:    and x8, x8, #0x3f
; CHECK-NEXT:    add x8, x8, x2
; CHECK-NEXT:    lsr x0, x0, x8
; CHECK-NEXT:    ret
  %nega = sub i64 0, %a
  %negaaddbitwidth = and i64 %nega, 63
  %negaaddbitwidthaddb = add i64 %negaaddbitwidth, %b
  %shifted = lshr i64 %val, %negaaddbitwidthaddb
  ret i64 %shifted
}
