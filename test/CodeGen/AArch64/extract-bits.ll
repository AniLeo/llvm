; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s

; *Please* keep in sync with test/CodeGen/X86/extract-bits.ll

; https://bugs.llvm.org/show_bug.cgi?id=36419
; https://bugs.llvm.org/show_bug.cgi?id=37603
; https://bugs.llvm.org/show_bug.cgi?id=37610

; Patterns:
;   a) (x >> start) &  (1 << nbits) - 1
;   b) (x >> start) & ~(-1 << nbits)
;   c) (x >> start) &  (-1 >> (32 - y))
;   d) (x >> start) << (32 - y) >> (32 - y)
; are equivalent.

; ---------------------------------------------------------------------------- ;
; Pattern a. 32-bit
; ---------------------------------------------------------------------------- ;

define i32 @bextr32_a0(i32 %val, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_a0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    sub w9, w9, #1 // =1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %shifted = lshr i32 %val, %numskipbits
  %onebit = shl i32 1, %numlowbits
  %mask = add nsw i32 %onebit, -1
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_a0_arithmetic(i32 %val, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_a0_arithmetic:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    asr w8, w0, w1
; CHECK-NEXT:    sub w9, w9, #1 // =1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %shifted = ashr i32 %val, %numskipbits
  %onebit = shl i32 1, %numlowbits
  %mask = add nsw i32 %onebit, -1
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_a1_indexzext(i32 %val, i8 zeroext %numskipbits, i8 zeroext %numlowbits) nounwind {
; CHECK-LABEL: bextr32_a1_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    sub w9, w9, #1 // =1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %skip = zext i8 %numskipbits to i32
  %shifted = lshr i32 %val, %skip
  %conv = zext i8 %numlowbits to i32
  %onebit = shl i32 1, %conv
  %mask = add nsw i32 %onebit, -1
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_a2_load(i32* %w, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_a2_load:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    sub w9, w9, #1 // =1
; CHECK-NEXT:    lsr w8, w8, w1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %val = load i32, i32* %w
  %shifted = lshr i32 %val, %numskipbits
  %onebit = shl i32 1, %numlowbits
  %mask = add nsw i32 %onebit, -1
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_a3_load_indexzext(i32* %w, i8 zeroext %numskipbits, i8 zeroext %numlowbits) nounwind {
; CHECK-LABEL: bextr32_a3_load_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    sub w9, w9, #1 // =1
; CHECK-NEXT:    lsr w8, w8, w1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %val = load i32, i32* %w
  %skip = zext i8 %numskipbits to i32
  %shifted = lshr i32 %val, %skip
  %conv = zext i8 %numlowbits to i32
  %onebit = shl i32 1, %conv
  %mask = add nsw i32 %onebit, -1
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_a4_commutative(i32 %val, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_a4_commutative:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    sub w9, w9, #1 // =1
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
  %shifted = lshr i32 %val, %numskipbits
  %onebit = shl i32 1, %numlowbits
  %mask = add nsw i32 %onebit, -1
  %masked = and i32 %shifted, %mask ; swapped order
  ret i32 %masked
}

; 64-bit

define i64 @bextr64_a0(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_a0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    sub x9, x9, #1 // =1
; CHECK-NEXT:    and x0, x9, x8
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %onebit = shl i64 1, %numlowbits
  %mask = add nsw i64 %onebit, -1
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_a0_arithmetic(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_a0_arithmetic:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    asr x8, x0, x1
; CHECK-NEXT:    sub x9, x9, #1 // =1
; CHECK-NEXT:    and x0, x9, x8
; CHECK-NEXT:    ret
  %shifted = ashr i64 %val, %numskipbits
  %onebit = shl i64 1, %numlowbits
  %mask = add nsw i64 %onebit, -1
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_a1_indexzext(i64 %val, i8 zeroext %numskipbits, i8 zeroext %numlowbits) nounwind {
; CHECK-LABEL: bextr64_a1_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    sub x9, x9, #1 // =1
; CHECK-NEXT:    and x0, x9, x8
; CHECK-NEXT:    ret
  %skip = zext i8 %numskipbits to i64
  %shifted = lshr i64 %val, %skip
  %conv = zext i8 %numlowbits to i64
  %onebit = shl i64 1, %conv
  %mask = add nsw i64 %onebit, -1
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_a2_load(i64* %w, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_a2_load:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    sub x9, x9, #1 // =1
; CHECK-NEXT:    lsr x8, x8, x1
; CHECK-NEXT:    and x0, x9, x8
; CHECK-NEXT:    ret
  %val = load i64, i64* %w
  %shifted = lshr i64 %val, %numskipbits
  %onebit = shl i64 1, %numlowbits
  %mask = add nsw i64 %onebit, -1
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_a3_load_indexzext(i64* %w, i8 zeroext %numskipbits, i8 zeroext %numlowbits) nounwind {
; CHECK-LABEL: bextr64_a3_load_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    sub x9, x9, #1 // =1
; CHECK-NEXT:    lsr x8, x8, x1
; CHECK-NEXT:    and x0, x9, x8
; CHECK-NEXT:    ret
  %val = load i64, i64* %w
  %skip = zext i8 %numskipbits to i64
  %shifted = lshr i64 %val, %skip
  %conv = zext i8 %numlowbits to i64
  %onebit = shl i64 1, %conv
  %mask = add nsw i64 %onebit, -1
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_a4_commutative(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_a4_commutative:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    sub x9, x9, #1 // =1
; CHECK-NEXT:    and x0, x8, x9
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %onebit = shl i64 1, %numlowbits
  %mask = add nsw i64 %onebit, -1
  %masked = and i64 %shifted, %mask ; swapped order
  ret i64 %masked
}

; 64-bit, but with 32-bit output

; Everything done in 64-bit, truncation happens last.
define i32 @bextr64_32_a0(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_a0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    sub w9, w9, #1 // =1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %onebit = shl i64 1, %numlowbits
  %mask = add nsw i64 %onebit, -1
  %masked = and i64 %mask, %shifted
  %res = trunc i64 %masked to i32
  ret i32 %res
}

; Shifting happens in 64-bit, then truncation. Masking is 32-bit.
define i32 @bextr64_32_a1(i64 %val, i64 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_a1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    sub w9, w9, #1 // =1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %truncshifted = trunc i64 %shifted to i32
  %onebit = shl i32 1, %numlowbits
  %mask = add nsw i32 %onebit, -1
  %masked = and i32 %mask, %truncshifted
  ret i32 %masked
}

; Shifting happens in 64-bit. Mask is 32-bit, but extended to 64-bit.
; Masking is 64-bit. Then truncation.
define i32 @bextr64_32_a2(i64 %val, i64 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_a2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    sub w9, w9, #1 // =1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %onebit = shl i32 1, %numlowbits
  %mask = add nsw i32 %onebit, -1
  %zextmask = zext i32 %mask to i64
  %masked = and i64 %zextmask, %shifted
  %truncmasked = trunc i64 %masked to i32
  ret i32 %truncmasked
}

; ---------------------------------------------------------------------------- ;
; Pattern b. 32-bit
; ---------------------------------------------------------------------------- ;

define i32 @bextr32_b0(i32 %val, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_b0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #-1
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    bic w0, w8, w9
; CHECK-NEXT:    ret
  %shifted = lshr i32 %val, %numskipbits
  %notmask = shl i32 -1, %numlowbits
  %mask = xor i32 %notmask, -1
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_b1_indexzext(i32 %val, i8 zeroext %numskipbits, i8 zeroext %numlowbits) nounwind {
; CHECK-LABEL: bextr32_b1_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #-1
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    bic w0, w8, w9
; CHECK-NEXT:    ret
  %skip = zext i8 %numskipbits to i32
  %shifted = lshr i32 %val, %skip
  %conv = zext i8 %numlowbits to i32
  %notmask = shl i32 -1, %conv
  %mask = xor i32 %notmask, -1
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_b2_load(i32* %w, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_b2_load:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    mov w9, #-1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    lsr w8, w8, w1
; CHECK-NEXT:    bic w0, w8, w9
; CHECK-NEXT:    ret
  %val = load i32, i32* %w
  %shifted = lshr i32 %val, %numskipbits
  %notmask = shl i32 -1, %numlowbits
  %mask = xor i32 %notmask, -1
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_b3_load_indexzext(i32* %w, i8 zeroext %numskipbits, i8 zeroext %numlowbits) nounwind {
; CHECK-LABEL: bextr32_b3_load_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    mov w9, #-1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    lsr w8, w8, w1
; CHECK-NEXT:    bic w0, w8, w9
; CHECK-NEXT:    ret
  %val = load i32, i32* %w
  %skip = zext i8 %numskipbits to i32
  %shifted = lshr i32 %val, %skip
  %conv = zext i8 %numlowbits to i32
  %notmask = shl i32 -1, %conv
  %mask = xor i32 %notmask, -1
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_b4_commutative(i32 %val, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_b4_commutative:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #-1
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    bic w0, w8, w9
; CHECK-NEXT:    ret
  %shifted = lshr i32 %val, %numskipbits
  %notmask = shl i32 -1, %numlowbits
  %mask = xor i32 %notmask, -1
  %masked = and i32 %shifted, %mask ; swapped order
  ret i32 %masked
}

; 64-bit

define i64 @bextr64_b0(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_b0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x9, #-1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    bic x0, x8, x9
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %notmask = shl i64 -1, %numlowbits
  %mask = xor i64 %notmask, -1
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_b1_indexzext(i64 %val, i8 zeroext %numskipbits, i8 zeroext %numlowbits) nounwind {
; CHECK-LABEL: bextr64_b1_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x9, #-1
; CHECK-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    bic x0, x8, x9
; CHECK-NEXT:    ret
  %skip = zext i8 %numskipbits to i64
  %shifted = lshr i64 %val, %skip
  %conv = zext i8 %numlowbits to i64
  %notmask = shl i64 -1, %conv
  %mask = xor i64 %notmask, -1
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_b2_load(i64* %w, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_b2_load:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    mov x9, #-1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    lsr x8, x8, x1
; CHECK-NEXT:    bic x0, x8, x9
; CHECK-NEXT:    ret
  %val = load i64, i64* %w
  %shifted = lshr i64 %val, %numskipbits
  %notmask = shl i64 -1, %numlowbits
  %mask = xor i64 %notmask, -1
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_b3_load_indexzext(i64* %w, i8 zeroext %numskipbits, i8 zeroext %numlowbits) nounwind {
; CHECK-LABEL: bextr64_b3_load_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    mov x9, #-1
; CHECK-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    lsr x8, x8, x1
; CHECK-NEXT:    bic x0, x8, x9
; CHECK-NEXT:    ret
  %val = load i64, i64* %w
  %skip = zext i8 %numskipbits to i64
  %shifted = lshr i64 %val, %skip
  %conv = zext i8 %numlowbits to i64
  %notmask = shl i64 -1, %conv
  %mask = xor i64 %notmask, -1
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_b4_commutative(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_b4_commutative:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x9, #-1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    bic x0, x8, x9
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %notmask = shl i64 -1, %numlowbits
  %mask = xor i64 %notmask, -1
  %masked = and i64 %shifted, %mask ; swapped order
  ret i64 %masked
}

; 64-bit, but with 32-bit output

; Everything done in 64-bit, truncation happens last.
define i32 @bextr64_32_b0(i64 %val, i64 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_b0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov x9, #-1
; CHECK-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsl x9, x9, x2
; CHECK-NEXT:    bic w0, w8, w9
; CHECK-NEXT:    ret
  %shiftedval = lshr i64 %val, %numskipbits
  %widenumlowbits = zext i8 %numlowbits to i64
  %notmask = shl nsw i64 -1, %widenumlowbits
  %mask = xor i64 %notmask, -1
  %wideres = and i64 %shiftedval, %mask
  %res = trunc i64 %wideres to i32
  ret i32 %res
}

; Shifting happens in 64-bit, then truncation. Masking is 32-bit.
define i32 @bextr64_32_b1(i64 %val, i64 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_b1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #-1
; CHECK-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    bic w0, w8, w9
; CHECK-NEXT:    ret
  %shiftedval = lshr i64 %val, %numskipbits
  %truncshiftedval = trunc i64 %shiftedval to i32
  %widenumlowbits = zext i8 %numlowbits to i32
  %notmask = shl nsw i32 -1, %widenumlowbits
  %mask = xor i32 %notmask, -1
  %res = and i32 %truncshiftedval, %mask
  ret i32 %res
}

; Shifting happens in 64-bit. Mask is 32-bit, but extended to 64-bit.
; Masking is 64-bit. Then truncation.
define i32 @bextr64_32_b2(i64 %val, i64 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_b2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    mov w9, #-1
; CHECK-NEXT:    // kill: def $w2 killed $w2 def $x2
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsl w9, w9, w2
; CHECK-NEXT:    bic w0, w8, w9
; CHECK-NEXT:    ret
  %shiftedval = lshr i64 %val, %numskipbits
  %widenumlowbits = zext i8 %numlowbits to i32
  %notmask = shl nsw i32 -1, %widenumlowbits
  %mask = xor i32 %notmask, -1
  %zextmask = zext i32 %mask to i64
  %wideres = and i64 %shiftedval, %zextmask
  %res = trunc i64 %wideres to i32
  ret i32 %res
}

; ---------------------------------------------------------------------------- ;
; Pattern c. 32-bit
; ---------------------------------------------------------------------------- ;

define i32 @bextr32_c0(i32 %val, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_c0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w9, w2
; CHECK-NEXT:    mov w10, #-1
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    lsr w9, w10, w9
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %shifted = lshr i32 %val, %numskipbits
  %numhighbits = sub i32 32, %numlowbits
  %mask = lshr i32 -1, %numhighbits
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_c1_indexzext(i32 %val, i8 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_c1_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x20
; CHECK-NEXT:    sub w9, w9, w2
; CHECK-NEXT:    mov w10, #-1
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    lsr w9, w10, w9
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %skip = zext i8 %numskipbits to i32
  %shifted = lshr i32 %val, %skip
  %numhighbits = sub i8 32, %numlowbits
  %sh_prom = zext i8 %numhighbits to i32
  %mask = lshr i32 -1, %sh_prom
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_c2_load(i32* %w, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_c2_load:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    neg w9, w2
; CHECK-NEXT:    mov w10, #-1
; CHECK-NEXT:    lsr w9, w10, w9
; CHECK-NEXT:    lsr w8, w8, w1
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %val = load i32, i32* %w
  %shifted = lshr i32 %val, %numskipbits
  %numhighbits = sub i32 32, %numlowbits
  %mask = lshr i32 -1, %numhighbits
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_c3_load_indexzext(i32* %w, i8 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_c3_load_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    orr w9, wzr, #0x20
; CHECK-NEXT:    mov w10, #-1
; CHECK-NEXT:    sub w9, w9, w2
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsr w8, w8, w1
; CHECK-NEXT:    lsr w9, w10, w9
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %val = load i32, i32* %w
  %skip = zext i8 %numskipbits to i32
  %shifted = lshr i32 %val, %skip
  %numhighbits = sub i8 32, %numlowbits
  %sh_prom = zext i8 %numhighbits to i32
  %mask = lshr i32 -1, %sh_prom
  %masked = and i32 %mask, %shifted
  ret i32 %masked
}

define i32 @bextr32_c4_commutative(i32 %val, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_c4_commutative:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w9, w2
; CHECK-NEXT:    mov w10, #-1
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    lsr w9, w10, w9
; CHECK-NEXT:    and w0, w8, w9
; CHECK-NEXT:    ret
  %shifted = lshr i32 %val, %numskipbits
  %numhighbits = sub i32 32, %numlowbits
  %mask = lshr i32 -1, %numhighbits
  %masked = and i32 %shifted, %mask ; swapped order
  ret i32 %masked
}

; 64-bit

define i64 @bextr64_c0(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_c0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x9, x2
; CHECK-NEXT:    mov x10, #-1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsr x9, x10, x9
; CHECK-NEXT:    and x0, x9, x8
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %numhighbits = sub i64 64, %numlowbits
  %mask = lshr i64 -1, %numhighbits
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_c1_indexzext(i64 %val, i8 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_c1_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x40
; CHECK-NEXT:    sub w9, w9, w2
; CHECK-NEXT:    mov x10, #-1
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsr x9, x10, x9
; CHECK-NEXT:    and x0, x9, x8
; CHECK-NEXT:    ret
  %skip = zext i8 %numskipbits to i64
  %shifted = lshr i64 %val, %skip
  %numhighbits = sub i8 64, %numlowbits
  %sh_prom = zext i8 %numhighbits to i64
  %mask = lshr i64 -1, %sh_prom
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_c2_load(i64* %w, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_c2_load:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    neg x9, x2
; CHECK-NEXT:    mov x10, #-1
; CHECK-NEXT:    lsr x9, x10, x9
; CHECK-NEXT:    lsr x8, x8, x1
; CHECK-NEXT:    and x0, x9, x8
; CHECK-NEXT:    ret
  %val = load i64, i64* %w
  %shifted = lshr i64 %val, %numskipbits
  %numhighbits = sub i64 64, %numlowbits
  %mask = lshr i64 -1, %numhighbits
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_c3_load_indexzext(i64* %w, i8 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_c3_load_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    orr w9, wzr, #0x40
; CHECK-NEXT:    mov x10, #-1
; CHECK-NEXT:    sub w9, w9, w2
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsr x8, x8, x1
; CHECK-NEXT:    lsr x9, x10, x9
; CHECK-NEXT:    and x0, x9, x8
; CHECK-NEXT:    ret
  %val = load i64, i64* %w
  %skip = zext i8 %numskipbits to i64
  %shifted = lshr i64 %val, %skip
  %numhighbits = sub i8 64, %numlowbits
  %sh_prom = zext i8 %numhighbits to i64
  %mask = lshr i64 -1, %sh_prom
  %masked = and i64 %mask, %shifted
  ret i64 %masked
}

define i64 @bextr64_c4_commutative(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_c4_commutative:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x9, x2
; CHECK-NEXT:    mov x10, #-1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsr x9, x10, x9
; CHECK-NEXT:    and x0, x8, x9
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %numhighbits = sub i64 64, %numlowbits
  %mask = lshr i64 -1, %numhighbits
  %masked = and i64 %shifted, %mask ; swapped order
  ret i64 %masked
}

; 64-bit, but with 32-bit output

; Everything done in 64-bit, truncation happens last.
define i32 @bextr64_32_c0(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_c0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg x9, x2
; CHECK-NEXT:    mov x10, #-1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsr x9, x10, x9
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %numhighbits = sub i64 64, %numlowbits
  %mask = lshr i64 -1, %numhighbits
  %masked = and i64 %mask, %shifted
  %res = trunc i64 %masked to i32
  ret i32 %res
}

; Shifting happens in 64-bit, then truncation. Masking is 32-bit.
define i32 @bextr64_32_c1(i64 %val, i64 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_c1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w9, w2
; CHECK-NEXT:    mov w10, #-1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsr w9, w10, w9
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %truncshifted = trunc i64 %shifted to i32
  %numhighbits = sub i32 32, %numlowbits
  %mask = lshr i32 -1, %numhighbits
  %masked = and i32 %mask, %truncshifted
  ret i32 %masked
}

; Shifting happens in 64-bit. Mask is 32-bit, but extended to 64-bit.
; Masking is 64-bit. Then truncation.
define i32 @bextr64_32_c2(i64 %val, i64 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_c2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    neg w9, w2
; CHECK-NEXT:    mov w10, #-1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    lsr w9, w10, w9
; CHECK-NEXT:    and w0, w9, w8
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %numhighbits = sub i32 32, %numlowbits
  %mask = lshr i32 -1, %numhighbits
  %zextmask = zext i32 %mask to i64
  %masked = and i64 %zextmask, %shifted
  %truncmasked = trunc i64 %masked to i32
  ret i32 %truncmasked
}

; ---------------------------------------------------------------------------- ;
; Pattern d. 32-bit.
; ---------------------------------------------------------------------------- ;

define i32 @bextr32_d0(i32 %val, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_d0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    neg w9, w2
; CHECK-NEXT:    lsl w8, w8, w9
; CHECK-NEXT:    lsr w0, w8, w9
; CHECK-NEXT:    ret
  %shifted = lshr i32 %val, %numskipbits
  %numhighbits = sub i32 32, %numlowbits
  %highbitscleared = shl i32 %shifted, %numhighbits
  %masked = lshr i32 %highbitscleared, %numhighbits
  ret i32 %masked
}

define i32 @bextr32_d1_indexzext(i32 %val, i8 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_d1_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x20
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsr w8, w0, w1
; CHECK-NEXT:    sub w9, w9, w2
; CHECK-NEXT:    lsl w8, w8, w9
; CHECK-NEXT:    lsr w0, w8, w9
; CHECK-NEXT:    ret
  %skip = zext i8 %numskipbits to i32
  %shifted = lshr i32 %val, %skip
  %numhighbits = sub i8 32, %numlowbits
  %sh_prom = zext i8 %numhighbits to i32
  %highbitscleared = shl i32 %shifted, %sh_prom
  %masked = lshr i32 %highbitscleared, %sh_prom
  ret i32 %masked
}

define i32 @bextr32_d2_load(i32* %w, i32 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_d2_load:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    neg w9, w2
; CHECK-NEXT:    lsr w8, w8, w1
; CHECK-NEXT:    lsl w8, w8, w9
; CHECK-NEXT:    lsr w0, w8, w9
; CHECK-NEXT:    ret
  %val = load i32, i32* %w
  %shifted = lshr i32 %val, %numskipbits
  %numhighbits = sub i32 32, %numlowbits
  %highbitscleared = shl i32 %shifted, %numhighbits
  %masked = lshr i32 %highbitscleared, %numhighbits
  ret i32 %masked
}

define i32 @bextr32_d3_load_indexzext(i32* %w, i8 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr32_d3_load_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr w8, [x0]
; CHECK-NEXT:    orr w9, wzr, #0x20
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    sub w9, w9, w2
; CHECK-NEXT:    lsr w8, w8, w1
; CHECK-NEXT:    lsl w8, w8, w9
; CHECK-NEXT:    lsr w0, w8, w9
; CHECK-NEXT:    ret
  %val = load i32, i32* %w
  %skip = zext i8 %numskipbits to i32
  %shifted = lshr i32 %val, %skip
  %numhighbits = sub i8 32, %numlowbits
  %sh_prom = zext i8 %numhighbits to i32
  %highbitscleared = shl i32 %shifted, %sh_prom
  %masked = lshr i32 %highbitscleared, %sh_prom
  ret i32 %masked
}

; 64-bit.

define i64 @bextr64_d0(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_d0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    neg x9, x2
; CHECK-NEXT:    lsl x8, x8, x9
; CHECK-NEXT:    lsr x0, x8, x9
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %numhighbits = sub i64 64, %numlowbits
  %highbitscleared = shl i64 %shifted, %numhighbits
  %masked = lshr i64 %highbitscleared, %numhighbits
  ret i64 %masked
}

define i64 @bextr64_d1_indexzext(i64 %val, i8 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_d1_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    orr w9, wzr, #0x40
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    sub w9, w9, w2
; CHECK-NEXT:    lsl x8, x8, x9
; CHECK-NEXT:    lsr x0, x8, x9
; CHECK-NEXT:    ret
  %skip = zext i8 %numskipbits to i64
  %shifted = lshr i64 %val, %skip
  %numhighbits = sub i8 64, %numlowbits
  %sh_prom = zext i8 %numhighbits to i64
  %highbitscleared = shl i64 %shifted, %sh_prom
  %masked = lshr i64 %highbitscleared, %sh_prom
  ret i64 %masked
}

define i64 @bextr64_d2_load(i64* %w, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_d2_load:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    neg x9, x2
; CHECK-NEXT:    lsr x8, x8, x1
; CHECK-NEXT:    lsl x8, x8, x9
; CHECK-NEXT:    lsr x0, x8, x9
; CHECK-NEXT:    ret
  %val = load i64, i64* %w
  %shifted = lshr i64 %val, %numskipbits
  %numhighbits = sub i64 64, %numlowbits
  %highbitscleared = shl i64 %shifted, %numhighbits
  %masked = lshr i64 %highbitscleared, %numhighbits
  ret i64 %masked
}

define i64 @bextr64_d3_load_indexzext(i64* %w, i8 %numskipbits, i8 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_d3_load_indexzext:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x0]
; CHECK-NEXT:    orr w9, wzr, #0x40
; CHECK-NEXT:    // kill: def $w1 killed $w1 def $x1
; CHECK-NEXT:    sub w9, w9, w2
; CHECK-NEXT:    lsr x8, x8, x1
; CHECK-NEXT:    lsl x8, x8, x9
; CHECK-NEXT:    lsr x0, x8, x9
; CHECK-NEXT:    ret
  %val = load i64, i64* %w
  %skip = zext i8 %numskipbits to i64
  %shifted = lshr i64 %val, %skip
  %numhighbits = sub i8 64, %numlowbits
  %sh_prom = zext i8 %numhighbits to i64
  %highbitscleared = shl i64 %shifted, %sh_prom
  %masked = lshr i64 %highbitscleared, %sh_prom
  ret i64 %masked
}

; 64-bit, but with 32-bit output

; Everything done in 64-bit, truncation happens last.
define i32 @bextr64_32_d0(i64 %val, i64 %numskipbits, i64 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_d0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    neg x9, x2
; CHECK-NEXT:    lsl x8, x8, x9
; CHECK-NEXT:    lsr x0, x8, x9
; CHECK-NEXT:    // kill: def $w0 killed $w0 killed $x0
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %numhighbits = sub i64 64, %numlowbits
  %highbitscleared = shl i64 %shifted, %numhighbits
  %masked = lshr i64 %highbitscleared, %numhighbits
  %res = trunc i64 %masked to i32
  ret i32 %res
}

; Shifting happens in 64-bit, then truncation. Masking is 32-bit.
define i32 @bextr64_32_d1(i64 %val, i64 %numskipbits, i32 %numlowbits) nounwind {
; CHECK-LABEL: bextr64_32_d1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr x8, x0, x1
; CHECK-NEXT:    neg w9, w2
; CHECK-NEXT:    lsl w8, w8, w9
; CHECK-NEXT:    lsr w0, w8, w9
; CHECK-NEXT:    ret
  %shifted = lshr i64 %val, %numskipbits
  %truncshifted = trunc i64 %shifted to i32
  %numhighbits = sub i32 32, %numlowbits
  %highbitscleared = shl i32 %truncshifted, %numhighbits
  %masked = lshr i32 %highbitscleared, %numhighbits
  ret i32 %masked
}

; ---------------------------------------------------------------------------- ;
; Constant
; ---------------------------------------------------------------------------- ;

; https://bugs.llvm.org/show_bug.cgi?id=38938
define void @pr38938(i32* %a0, i64* %a1) nounwind {
; CHECK-LABEL: pr38938:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ldr x8, [x1]
; CHECK-NEXT:    ubfx x8, x8, #21, #10
; CHECK-NEXT:    lsl x8, x8, #2
; CHECK-NEXT:    ldr w9, [x0, x8]
; CHECK-NEXT:    add w9, w9, #1 // =1
; CHECK-NEXT:    str w9, [x0, x8]
; CHECK-NEXT:    ret
  %tmp = load i64, i64* %a1, align 8
  %tmp1 = lshr i64 %tmp, 21
  %tmp2 = and i64 %tmp1, 1023
  %tmp3 = getelementptr inbounds i32, i32* %a0, i64 %tmp2
  %tmp4 = load i32, i32* %tmp3, align 4
  %tmp5 = add nsw i32 %tmp4, 1
  store i32 %tmp5, i32* %tmp3, align 4
  ret void
}

; The most canonical variant
define i32 @c0_i32(i32 %arg) nounwind {
; CHECK-LABEL: c0_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx w0, w0, #19, #10
; CHECK-NEXT:    ret
  %tmp0 = lshr i32 %arg, 19
  %tmp1 = and i32 %tmp0, 1023
  ret i32 %tmp1
}

; Should be still fine, but the mask is shifted
define i32 @c1_i32(i32 %arg) nounwind {
; CHECK-LABEL: c1_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w8, w0, #19
; CHECK-NEXT:    and w0, w8, #0xffc
; CHECK-NEXT:    ret
  %tmp0 = lshr i32 %arg, 19
  %tmp1 = and i32 %tmp0, 4092
  ret i32 %tmp1
}

; Should be still fine, but the result is shifted left afterwards
define i32 @c2_i32(i32 %arg) nounwind {
; CHECK-LABEL: c2_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx w8, w0, #19, #10
; CHECK-NEXT:    lsl w0, w8, #2
; CHECK-NEXT:    ret
  %tmp0 = lshr i32 %arg, 19
  %tmp1 = and i32 %tmp0, 1023
  %tmp2 = shl i32 %tmp1, 2
  ret i32 %tmp2
}

; The mask covers newly shifted-in bit
define i32 @c4_i32_bad(i32 %arg) nounwind {
; CHECK-LABEL: c4_i32_bad:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr w8, w0, #19
; CHECK-NEXT:    and w0, w8, #0x1ffe
; CHECK-NEXT:    ret
  %tmp0 = lshr i32 %arg, 19
  %tmp1 = and i32 %tmp0, 16382
  ret i32 %tmp1
}

; i64

; The most canonical variant
define i64 @c0_i64(i64 %arg) nounwind {
; CHECK-LABEL: c0_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx x0, x0, #51, #10
; CHECK-NEXT:    ret
  %tmp0 = lshr i64 %arg, 51
  %tmp1 = and i64 %tmp0, 1023
  ret i64 %tmp1
}

; Should be still fine, but the mask is shifted
define i64 @c1_i64(i64 %arg) nounwind {
; CHECK-LABEL: c1_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr x8, x0, #51
; CHECK-NEXT:    and x0, x8, #0xffc
; CHECK-NEXT:    ret
  %tmp0 = lshr i64 %arg, 51
  %tmp1 = and i64 %tmp0, 4092
  ret i64 %tmp1
}

; Should be still fine, but the result is shifted left afterwards
define i64 @c2_i64(i64 %arg) nounwind {
; CHECK-LABEL: c2_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx x8, x0, #51, #10
; CHECK-NEXT:    lsl x0, x8, #2
; CHECK-NEXT:    ret
  %tmp0 = lshr i64 %arg, 51
  %tmp1 = and i64 %tmp0, 1023
  %tmp2 = shl i64 %tmp1, 2
  ret i64 %tmp2
}

; The mask covers newly shifted-in bit
define i64 @c4_i64_bad(i64 %arg) nounwind {
; CHECK-LABEL: c4_i64_bad:
; CHECK:       // %bb.0:
; CHECK-NEXT:    lsr x8, x0, #51
; CHECK-NEXT:    and x0, x8, #0x1ffe
; CHECK-NEXT:    ret
  %tmp0 = lshr i64 %arg, 51
  %tmp1 = and i64 %tmp0, 16382
  ret i64 %tmp1
}

; ---------------------------------------------------------------------------- ;
; Constant, storing the result afterwards.
; ---------------------------------------------------------------------------- ;

; i32

; The most canonical variant
define void @c5_i32(i32 %arg, i32* %ptr) nounwind {
; CHECK-LABEL: c5_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx w8, w0, #19, #10
; CHECK-NEXT:    str w8, [x1]
; CHECK-NEXT:    ret
  %tmp0 = lshr i32 %arg, 19
  %tmp1 = and i32 %tmp0, 1023
  store i32 %tmp1, i32* %ptr
  ret void
}

; Should be still fine, but the mask is shifted
define void @c6_i32(i32 %arg, i32* %ptr) nounwind {
; CHECK-LABEL: c6_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx w8, w0, #19, #12
; CHECK-NEXT:    str w8, [x1]
; CHECK-NEXT:    ret
  %tmp0 = lshr i32 %arg, 19
  %tmp1 = and i32 %tmp0, 4095
  store i32 %tmp1, i32* %ptr
  ret void
}

; Should be still fine, but the result is shifted left afterwards
define void @c7_i32(i32 %arg, i32* %ptr) nounwind {
; CHECK-LABEL: c7_i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx w8, w0, #19, #10
; CHECK-NEXT:    lsl w8, w8, #2
; CHECK-NEXT:    str w8, [x1]
; CHECK-NEXT:    ret
  %tmp0 = lshr i32 %arg, 19
  %tmp1 = and i32 %tmp0, 1023
  %tmp2 = shl i32 %tmp1, 2
  store i32 %tmp2, i32* %ptr
  ret void
}

; i64

; The most canonical variant
define void @c5_i64(i64 %arg, i64* %ptr) nounwind {
; CHECK-LABEL: c5_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx x8, x0, #51, #10
; CHECK-NEXT:    str x8, [x1]
; CHECK-NEXT:    ret
  %tmp0 = lshr i64 %arg, 51
  %tmp1 = and i64 %tmp0, 1023
  store i64 %tmp1, i64* %ptr
  ret void
}

; Should be still fine, but the mask is shifted
define void @c6_i64(i64 %arg, i64* %ptr) nounwind {
; CHECK-LABEL: c6_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx x8, x0, #51, #12
; CHECK-NEXT:    str x8, [x1]
; CHECK-NEXT:    ret
  %tmp0 = lshr i64 %arg, 51
  %tmp1 = and i64 %tmp0, 4095
  store i64 %tmp1, i64* %ptr
  ret void
}

; Should be still fine, but the result is shifted left afterwards
define void @c7_i64(i64 %arg, i64* %ptr) nounwind {
; CHECK-LABEL: c7_i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ubfx x8, x0, #51, #10
; CHECK-NEXT:    lsl x8, x8, #2
; CHECK-NEXT:    str x8, [x1]
; CHECK-NEXT:    ret
  %tmp0 = lshr i64 %arg, 51
  %tmp1 = and i64 %tmp0, 1023
  %tmp2 = shl i64 %tmp1, 2
  store i64 %tmp2, i64* %ptr
  ret void
}
