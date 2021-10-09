; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-apple-darwin                             -verify-machineinstrs < %s | FileCheck %s --check-prefix=CHECK --check-prefix=SDAG
; RUN: llc -mtriple=aarch64-apple-darwin -fast-isel -fast-isel-abort=1 -verify-machineinstrs < %s | FileCheck %s --check-prefix=CHECK --check-prefix=FAST

; Load / Store Base Register only
define zeroext i1 @load_breg_i1(i1* %a) {
; SDAG-LABEL: load_breg_i1:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    ldrb w0, [x0]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_breg_i1:
; FAST:       ; %bb.0:
; FAST-NEXT:    ldrb w8, [x0]
; FAST-NEXT:    and w8, w8, #0x1
; FAST-NEXT:    and w0, w8, #0x1
; FAST-NEXT:    ret
  %1 = load i1, i1* %a
  ret i1 %1
}

define zeroext i8 @load_breg_i8(i8* %a) {
; SDAG-LABEL: load_breg_i8:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    ldrb w0, [x0]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_breg_i8:
; FAST:       ; %bb.0:
; FAST-NEXT:    ldrb w8, [x0]
; FAST-NEXT:    uxtb w0, w8
; FAST-NEXT:    ret
  %1 = load i8, i8* %a
  ret i8 %1
}

define zeroext i16 @load_breg_i16(i16* %a) {
; SDAG-LABEL: load_breg_i16:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    ldrh w0, [x0]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_breg_i16:
; FAST:       ; %bb.0:
; FAST-NEXT:    ldrh w8, [x0]
; FAST-NEXT:    uxth w0, w8
; FAST-NEXT:    ret
  %1 = load i16, i16* %a
  ret i16 %1
}

define i32 @load_breg_i32(i32* %a) {
; CHECK-LABEL: load_breg_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x0]
; CHECK-NEXT:    ret
  %1 = load i32, i32* %a
  ret i32 %1
}

define i64 @load_breg_i64(i64* %a) {
; CHECK-LABEL: load_breg_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr x0, [x0]
; CHECK-NEXT:    ret
  %1 = load i64, i64* %a
  ret i64 %1
}

define float @load_breg_f32(float* %a) {
; CHECK-LABEL: load_breg_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr s0, [x0]
; CHECK-NEXT:    ret
  %1 = load float, float* %a
  ret float %1
}

define double @load_breg_f64(double* %a) {
; CHECK-LABEL: load_breg_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr d0, [x0]
; CHECK-NEXT:    ret
  %1 = load double, double* %a
  ret double %1
}

define void @store_breg_i1(i1* %a) {
; CHECK-LABEL: store_breg_i1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    strb wzr, [x0]
; CHECK-NEXT:    ret
  store i1 0, i1* %a
  ret void
}

define void @store_breg_i1_2(i1* %a) {
; SDAG-LABEL: store_breg_i1_2:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    mov w8, #1
; SDAG-NEXT:    strb w8, [x0]
; SDAG-NEXT:    ret
;
; FAST-LABEL: store_breg_i1_2:
; FAST:       ; %bb.0:
; FAST-NEXT:    mov w8, #1
; FAST-NEXT:    and w8, w8, #0x1
; FAST-NEXT:    strb w8, [x0]
; FAST-NEXT:    ret
  store i1 true, i1* %a
  ret void
}

define void @store_breg_i8(i8* %a) {
; CHECK-LABEL: store_breg_i8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    strb wzr, [x0]
; CHECK-NEXT:    ret
  store i8 0, i8* %a
  ret void
}

define void @store_breg_i16(i16* %a) {
; CHECK-LABEL: store_breg_i16:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    strh wzr, [x0]
; CHECK-NEXT:    ret
  store i16 0, i16* %a
  ret void
}

define void @store_breg_i32(i32* %a) {
; CHECK-LABEL: store_breg_i32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    str wzr, [x0]
; CHECK-NEXT:    ret
  store i32 0, i32* %a
  ret void
}

define void @store_breg_i64(i64* %a) {
; CHECK-LABEL: store_breg_i64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    str xzr, [x0]
; CHECK-NEXT:    ret
  store i64 0, i64* %a
  ret void
}

define void @store_breg_f32(float* %a) {
; CHECK-LABEL: store_breg_f32:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    str wzr, [x0]
; CHECK-NEXT:    ret
  store float 0.0, float* %a
  ret void
}

define void @store_breg_f64(double* %a) {
; CHECK-LABEL: store_breg_f64:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    str xzr, [x0]
; CHECK-NEXT:    ret
  store double 0.0, double* %a
  ret void
}

; Load Immediate
define i32 @load_immoff_1() {
; SDAG-LABEL: load_immoff_1:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    mov w8, #128
; SDAG-NEXT:    ldr w0, [x8]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_immoff_1:
; FAST:       ; %bb.0:
; FAST-NEXT:    mov x8, #128
; FAST-NEXT:    ldr w0, [x8]
; FAST-NEXT:    ret
  %1 = inttoptr i64 128 to i32*
  %2 = load i32, i32* %1
  ret i32 %2
}

; Load / Store Base Register + Immediate Offset
; Max supported negative offset
define i32 @load_breg_immoff_1(i64 %a) {
; CHECK-LABEL: load_breg_immoff_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldur w0, [x0, #-256]
; CHECK-NEXT:    ret
  %1 = add i64 %a, -256
  %2 = inttoptr i64 %1 to i32*
  %3 = load i32, i32* %2
  ret i32 %3
}

; Min not-supported negative offset
define i32 @load_breg_immoff_2(i64 %a) {
; CHECK-LABEL: load_breg_immoff_2:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub x8, x0, #257
; CHECK-NEXT:    ldr w0, [x8]
; CHECK-NEXT:    ret
  %1 = add i64 %a, -257
  %2 = inttoptr i64 %1 to i32*
  %3 = load i32, i32* %2
  ret i32 %3
}

; Max supported unscaled offset
define i32 @load_breg_immoff_3(i64 %a) {
; CHECK-LABEL: load_breg_immoff_3:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldur w0, [x0, #255]
; CHECK-NEXT:    ret
  %1 = add i64 %a, 255
  %2 = inttoptr i64 %1 to i32*
  %3 = load i32, i32* %2
  ret i32 %3
}

; Min un-supported unscaled offset
define i32 @load_breg_immoff_4(i64 %a) {
; CHECK-LABEL: load_breg_immoff_4:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    add x8, x0, #257
; CHECK-NEXT:    ldr w0, [x8]
; CHECK-NEXT:    ret
  %1 = add i64 %a, 257
  %2 = inttoptr i64 %1 to i32*
  %3 = load i32, i32* %2
  ret i32 %3
}

; Max supported scaled offset
define i32 @load_breg_immoff_5(i64 %a) {
; CHECK-LABEL: load_breg_immoff_5:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x0, #16380]
; CHECK-NEXT:    ret
  %1 = add i64 %a, 16380
  %2 = inttoptr i64 %1 to i32*
  %3 = load i32, i32* %2
  ret i32 %3
}

; Min un-supported scaled offset
define i32 @load_breg_immoff_6(i64 %a) {
; SDAG-LABEL: load_breg_immoff_6:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    mov w8, #16384
; SDAG-NEXT:    ldr w0, [x0, x8]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_breg_immoff_6:
; FAST:       ; %bb.0:
; FAST-NEXT:    add x8, x0, #4, lsl #12 ; =16384
; FAST-NEXT:    ldr w0, [x8]
; FAST-NEXT:    ret
  %1 = add i64 %a, 16384
  %2 = inttoptr i64 %1 to i32*
  %3 = load i32, i32* %2
  ret i32 %3
}

; Max supported negative offset
define void @store_breg_immoff_1(i64 %a) {
; CHECK-LABEL: store_breg_immoff_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    stur wzr, [x0, #-256]
; CHECK-NEXT:    ret
  %1 = add i64 %a, -256
  %2 = inttoptr i64 %1 to i32*
  store i32 0, i32* %2
  ret void
}

; Min not-supported negative offset
define void @store_breg_immoff_2(i64 %a) {
; CHECK-LABEL: store_breg_immoff_2:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub x8, x0, #257
; CHECK-NEXT:    str wzr, [x8]
; CHECK-NEXT:    ret
  %1 = add i64 %a, -257
  %2 = inttoptr i64 %1 to i32*
  store i32 0, i32* %2
  ret void
}

; Max supported unscaled offset
define void @store_breg_immoff_3(i64 %a) {
; CHECK-LABEL: store_breg_immoff_3:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    stur wzr, [x0, #255]
; CHECK-NEXT:    ret
  %1 = add i64 %a, 255
  %2 = inttoptr i64 %1 to i32*
  store i32 0, i32* %2
  ret void
}

; Min un-supported unscaled offset
define void @store_breg_immoff_4(i64 %a) {
; CHECK-LABEL: store_breg_immoff_4:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    add x8, x0, #257
; CHECK-NEXT:    str wzr, [x8]
; CHECK-NEXT:    ret
  %1 = add i64 %a, 257
  %2 = inttoptr i64 %1 to i32*
  store i32 0, i32* %2
  ret void
}

; Max supported scaled offset
define void @store_breg_immoff_5(i64 %a) {
; CHECK-LABEL: store_breg_immoff_5:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    str wzr, [x0, #16380]
; CHECK-NEXT:    ret
  %1 = add i64 %a, 16380
  %2 = inttoptr i64 %1 to i32*
  store i32 0, i32* %2
  ret void
}

; Min un-supported scaled offset
define void @store_breg_immoff_6(i64 %a) {
; SDAG-LABEL: store_breg_immoff_6:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    mov w8, #16384
; SDAG-NEXT:    str wzr, [x0, x8]
; SDAG-NEXT:    ret
;
; FAST-LABEL: store_breg_immoff_6:
; FAST:       ; %bb.0:
; FAST-NEXT:    add x8, x0, #4, lsl #12 ; =16384
; FAST-NEXT:    str wzr, [x8]
; FAST-NEXT:    ret
  %1 = add i64 %a, 16384
  %2 = inttoptr i64 %1 to i32*
  store i32 0, i32* %2
  ret void
}

define i64 @load_breg_immoff_7(i64 %a) {
; CHECK-LABEL: load_breg_immoff_7:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr x0, [x0, #48]
; CHECK-NEXT:    ret
  %1 = add i64 %a, 48
  %2 = inttoptr i64 %1 to i64*
  %3 = load i64, i64* %2
  ret i64 %3
}

; Flip add operands
define i64 @load_breg_immoff_8(i64 %a) {
; CHECK-LABEL: load_breg_immoff_8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr x0, [x0, #48]
; CHECK-NEXT:    ret
  %1 = add i64 48, %a
  %2 = inttoptr i64 %1 to i64*
  %3 = load i64, i64* %2
  ret i64 %3
}

; Load Base Register + Register Offset
define i64 @load_breg_offreg_1(i64 %a, i64 %b) {
; CHECK-LABEL: load_breg_offreg_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr x0, [x0, x1]
; CHECK-NEXT:    ret
  %1 = add i64 %a, %b
  %2 = inttoptr i64 %1 to i64*
  %3 = load i64, i64* %2
  ret i64 %3
}

; Flip add operands
define i64 @load_breg_offreg_2(i64 %a, i64 %b) {
; CHECK-LABEL: load_breg_offreg_2:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr x0, [x1, x0]
; CHECK-NEXT:    ret
  %1 = add i64 %b, %a
  %2 = inttoptr i64 %1 to i64*
  %3 = load i64, i64* %2
  ret i64 %3
}

; Load Base Register + Register Offset + Immediate Offset
define i64 @load_breg_offreg_immoff_1(i64 %a, i64 %b) {
; CHECK-LABEL: load_breg_offreg_immoff_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    add x8, x0, x1
; CHECK-NEXT:    ldr x0, [x8, #48]
; CHECK-NEXT:    ret
  %1 = add i64 %a, %b
  %2 = add i64 %1, 48
  %3 = inttoptr i64 %2 to i64*
  %4 = load i64, i64* %3
  ret i64 %4
}

define i64 @load_breg_offreg_immoff_2(i64 %a, i64 %b) {
; SDAG-LABEL: load_breg_offreg_immoff_2:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    mov w8, #61440
; SDAG-NEXT:    add x9, x0, x1
; SDAG-NEXT:    ldr x0, [x9, x8]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_breg_offreg_immoff_2:
; FAST:       ; %bb.0:
; FAST-NEXT:    add x8, x0, #15, lsl #12 ; =61440
; FAST-NEXT:    ldr x0, [x8, x1]
; FAST-NEXT:    ret
  %1 = add i64 %a, %b
  %2 = add i64 %1, 61440
  %3 = inttoptr i64 %2 to i64*
  %4 = load i64, i64* %3
  ret i64 %4
}

; Load Scaled Register Offset
define i32 @load_shift_offreg_1(i64 %a) {
; CHECK-LABEL: load_shift_offreg_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsl x8, x0, #2
; CHECK-NEXT:    ldr w0, [x8]
; CHECK-NEXT:    ret
  %1 = shl i64 %a, 2
  %2 = inttoptr i64 %1 to i32*
  %3 = load i32, i32* %2
  ret i32 %3
}

define i32 @load_mul_offreg_1(i64 %a) {
; CHECK-LABEL: load_mul_offreg_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsl x8, x0, #2
; CHECK-NEXT:    ldr w0, [x8]
; CHECK-NEXT:    ret
  %1 = mul i64 %a, 4
  %2 = inttoptr i64 %1 to i32*
  %3 = load i32, i32* %2
  ret i32 %3
}

; Load Base Register + Scaled Register Offset
define i32 @load_breg_shift_offreg_1(i64 %a, i64 %b) {
; CHECK-LABEL: load_breg_shift_offreg_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, x0, lsl #2]
; CHECK-NEXT:    ret
  %1 = shl i64 %a, 2
  %2 = add i64 %1, %b
  %3 = inttoptr i64 %2 to i32*
  %4 = load i32, i32* %3
  ret i32 %4
}

define i32 @load_breg_shift_offreg_2(i64 %a, i64 %b) {
; CHECK-LABEL: load_breg_shift_offreg_2:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, x0, lsl #2]
; CHECK-NEXT:    ret
  %1 = shl i64 %a, 2
  %2 = add i64 %b, %1
  %3 = inttoptr i64 %2 to i32*
  %4 = load i32, i32* %3
  ret i32 %4
}

define i32 @load_breg_shift_offreg_3(i64 %a, i64 %b) {
; SDAG-LABEL: load_breg_shift_offreg_3:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    lsl x8, x0, #2
; SDAG-NEXT:    ldr w0, [x8, x1, lsl #2]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_breg_shift_offreg_3:
; FAST:       ; %bb.0:
; FAST-NEXT:    lsl x8, x1, #2
; FAST-NEXT:    ldr w0, [x8, x0, lsl #2]
; FAST-NEXT:    ret
  %1 = shl i64 %a, 2
  %2 = shl i64 %b, 2
  %3 = add i64 %1, %2
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

define i32 @load_breg_shift_offreg_4(i64 %a, i64 %b) {
; SDAG-LABEL: load_breg_shift_offreg_4:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    lsl x8, x1, #2
; SDAG-NEXT:    ldr w0, [x8, x0, lsl #2]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_breg_shift_offreg_4:
; FAST:       ; %bb.0:
; FAST-NEXT:    lsl x8, x0, #2
; FAST-NEXT:    ldr w0, [x8, x1, lsl #2]
; FAST-NEXT:    ret
  %1 = shl i64 %a, 2
  %2 = shl i64 %b, 2
  %3 = add i64 %2, %1
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

define i32 @load_breg_shift_offreg_5(i64 %a, i64 %b) {
; CHECK-LABEL: load_breg_shift_offreg_5:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    lsl x8, x1, #3
; CHECK-NEXT:    ldr w0, [x8, x0, lsl #2]
; CHECK-NEXT:    ret
  %1 = shl i64 %a, 2
  %2 = shl i64 %b, 3
  %3 = add i64 %1, %2
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

define i32 @load_breg_mul_offreg_1(i64 %a, i64 %b) {
; CHECK-LABEL: load_breg_mul_offreg_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, x0, lsl #2]
; CHECK-NEXT:    ret
  %1 = mul i64 %a, 4
  %2 = add i64 %1, %b
  %3 = inttoptr i64 %2 to i32*
  %4 = load i32, i32* %3
  ret i32 %4
}

define zeroext i8 @load_breg_and_offreg_1(i64 %a, i64 %b) {
; SDAG-LABEL: load_breg_and_offreg_1:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    ldrb w0, [x1, w0, uxtw]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_breg_and_offreg_1:
; FAST:       ; %bb.0:
; FAST-NEXT:    ldrb w8, [x1, w0, uxtw]
; FAST-NEXT:    uxtb w0, w8
; FAST-NEXT:    ret
  %1 = and i64 %a, 4294967295
  %2 = add i64 %1, %b
  %3 = inttoptr i64 %2 to i8*
  %4 = load i8, i8* %3
  ret i8 %4
}

define zeroext i16 @load_breg_and_offreg_2(i64 %a, i64 %b) {
; SDAG-LABEL: load_breg_and_offreg_2:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    ldrh w0, [x1, w0, uxtw #1]
; SDAG-NEXT:    ret
;
; FAST-LABEL: load_breg_and_offreg_2:
; FAST:       ; %bb.0:
; FAST-NEXT:    ldrh w8, [x1, w0, uxtw #1]
; FAST-NEXT:    uxth w0, w8
; FAST-NEXT:    ret
  %1 = and i64 %a, 4294967295
  %2 = shl i64 %1, 1
  %3 = add i64 %2, %b
  %4 = inttoptr i64 %3 to i16*
  %5 = load i16, i16* %4
  ret i16 %5
}

define i32 @load_breg_and_offreg_3(i64 %a, i64 %b) {
; CHECK-LABEL: load_breg_and_offreg_3:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, w0, uxtw #2]
; CHECK-NEXT:    ret
  %1 = and i64 %a, 4294967295
  %2 = shl i64 %1, 2
  %3 = add i64 %2, %b
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

define i64 @load_breg_and_offreg_4(i64 %a, i64 %b) {
; CHECK-LABEL: load_breg_and_offreg_4:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr x0, [x1, w0, uxtw #3]
; CHECK-NEXT:    ret
  %1 = and i64 %a, 4294967295
  %2 = shl i64 %1, 3
  %3 = add i64 %2, %b
  %4 = inttoptr i64 %3 to i64*
  %5 = load i64, i64* %4
  ret i64 %5
}

; Not all 'and' instructions have immediates.
define i64 @load_breg_and_offreg_5(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: load_breg_and_offreg_5:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    and x8, x0, x2
; CHECK-NEXT:    ldr x0, [x8, x1]
; CHECK-NEXT:    ret
  %1 = and i64 %a, %c
  %2 = add i64 %1, %b
  %3 = inttoptr i64 %2 to i64*
  %4 = load i64, i64* %3
  ret i64 %4
}

define i64 @load_breg_and_offreg_6(i64 %a, i64 %b, i64 %c) {
; CHECK-LABEL: load_breg_and_offreg_6:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    and x8, x0, x2
; CHECK-NEXT:    ldr x0, [x1, x8, lsl #3]
; CHECK-NEXT:    ret
  %1 = and i64 %a, %c
  %2 = shl i64 %1, 3
  %3 = add i64 %2, %b
  %4 = inttoptr i64 %3 to i64*
  %5 = load i64, i64* %4
  ret i64 %5
}

; Load Base Register + Scaled Register Offset + Sign/Zero extension
define i32 @load_breg_zext_shift_offreg_1(i32 %a, i64 %b) {
; CHECK-LABEL: load_breg_zext_shift_offreg_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, w0, uxtw #2]
; CHECK-NEXT:    ret
  %1 = zext i32 %a to i64
  %2 = shl i64 %1, 2
  %3 = add i64 %2, %b
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

define i32 @load_breg_zext_shift_offreg_2(i32 %a, i64 %b) {
; CHECK-LABEL: load_breg_zext_shift_offreg_2:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, w0, uxtw #2]
; CHECK-NEXT:    ret
  %1 = zext i32 %a to i64
  %2 = shl i64 %1, 2
  %3 = add i64 %b, %2
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

define i32 @load_breg_zext_mul_offreg_1(i32 %a, i64 %b) {
; CHECK-LABEL: load_breg_zext_mul_offreg_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, w0, uxtw #2]
; CHECK-NEXT:    ret
  %1 = zext i32 %a to i64
  %2 = mul i64 %1, 4
  %3 = add i64 %2, %b
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

define i32 @load_breg_sext_shift_offreg_1(i32 %a, i64 %b) {
; CHECK-LABEL: load_breg_sext_shift_offreg_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, w0, sxtw #2]
; CHECK-NEXT:    ret
  %1 = sext i32 %a to i64
  %2 = shl i64 %1, 2
  %3 = add i64 %2, %b
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

define i32 @load_breg_sext_shift_offreg_2(i32 %a, i64 %b) {
; CHECK-LABEL: load_breg_sext_shift_offreg_2:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, w0, sxtw #2]
; CHECK-NEXT:    ret
  %1 = sext i32 %a to i64
  %2 = shl i64 %1, 2
  %3 = add i64 %b, %2
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

; Make sure that we don't drop the first 'add' instruction.
define i32 @load_breg_sext_shift_offreg_3(i32 %a, i64 %b) {
; CHECK-LABEL: load_breg_sext_shift_offreg_3:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    add w8, w0, #4
; CHECK-NEXT:    ldr w0, [x1, w8, sxtw #2]
; CHECK-NEXT:    ret
  %1 = add i32 %a, 4
  %2 = sext i32 %1 to i64
  %3 = shl i64 %2, 2
  %4 = add i64 %b, %3
  %5 = inttoptr i64 %4 to i32*
  %6 = load i32, i32* %5
  ret i32 %6
}


define i32 @load_breg_sext_mul_offreg_1(i32 %a, i64 %b) {
; CHECK-LABEL: load_breg_sext_mul_offreg_1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ldr w0, [x1, w0, sxtw #2]
; CHECK-NEXT:    ret
  %1 = sext i32 %a to i64
  %2 = mul i64 %1, 4
  %3 = add i64 %2, %b
  %4 = inttoptr i64 %3 to i32*
  %5 = load i32, i32* %4
  ret i32 %5
}

; Load Scaled Register Offset + Immediate Offset + Sign/Zero extension
define i64 @load_sext_shift_offreg_imm1(i32 %a) {
; CHECK-LABEL: load_sext_shift_offreg_imm1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    ; kill: def $w0 killed $w0 def $x0
; CHECK-NEXT:    sbfiz x8, x0, #3, #32
; CHECK-NEXT:    ldr x0, [x8, #8]
; CHECK-NEXT:    ret
  %1 = sext i32 %a to i64
  %2 = shl i64 %1, 3
  %3 = add i64 %2, 8
  %4 = inttoptr i64 %3 to i64*
  %5 = load i64, i64* %4
  ret i64 %5
}

; Load Base Register + Scaled Register Offset + Immediate Offset + Sign/Zero extension
define i64 @load_breg_sext_shift_offreg_imm1(i32 %a, i64 %b) {
; CHECK-LABEL: load_breg_sext_shift_offreg_imm1:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    add x8, x1, w0, sxtw #3
; CHECK-NEXT:    ldr x0, [x8, #8]
; CHECK-NEXT:    ret
  %1 = sext i32 %a to i64
  %2 = shl i64 %1, 3
  %3 = add i64 %b, %2
  %4 = add i64 %3, 8
  %5 = inttoptr i64 %4 to i64*
  %6 = load i64, i64* %5
  ret i64 %6
}

; Test that the kill flag is not set - the machine instruction verifier does that for us.
define i64 @kill_reg(i64 %a) {
; SDAG-LABEL: kill_reg:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    ldr x8, [x0, #88]!
; SDAG-NEXT:    add x0, x0, x8
; SDAG-NEXT:    ret
;
; FAST-LABEL: kill_reg:
; FAST:       ; %bb.0:
; FAST-NEXT:    ldr x8, [x0, #88]
; FAST-NEXT:    sub x9, x0, #8
; FAST-NEXT:    add x9, x9, #96
; FAST-NEXT:    add x0, x9, x8
; FAST-NEXT:    ret
  %1 = sub i64 %a, 8
  %2 = add i64 %1, 96
  %3 = inttoptr i64 %2 to i64*
  %4 = load i64, i64* %3
  %5 = add i64 %2, %4
  ret i64 %5
}

define void @store_fi(i64 %i) {
; SDAG-LABEL: store_fi:
; SDAG:       ; %bb.0:
; SDAG-NEXT:    sub sp, sp, #32
; SDAG-NEXT:    .cfi_def_cfa_offset 32
; SDAG-NEXT:    mov x8, sp
; SDAG-NEXT:    mov w9, #47
; SDAG-NEXT:    str w9, [x8, x0, lsl #2]
; SDAG-NEXT:    add sp, sp, #32
; SDAG-NEXT:    ret
;
; FAST-LABEL: store_fi:
; FAST:       ; %bb.0:
; FAST-NEXT:    sub sp, sp, #32
; FAST-NEXT:    .cfi_def_cfa_offset 32
; FAST-NEXT:    mov w8, #47
; FAST-NEXT:    mov x9, sp
; FAST-NEXT:    str w8, [x9, x0, lsl #2]
; FAST-NEXT:    add sp, sp, #32
; FAST-NEXT:    ret
  %1 = alloca [8 x i32]
  %2 = ptrtoint [8 x i32]* %1 to i64
  %3 = mul i64 %i, 4
  %4 = add i64 %2, %3
  %5 = inttoptr i64 %4 to i32*
  store i32 47, i32* %5, align 4
  ret void
}

define i32 @load_fi(i64 %i) {
; CHECK-LABEL: load_fi:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub sp, sp, #32
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    mov x8, sp
; CHECK-NEXT:    ldr w0, [x8, x0, lsl #2]
; CHECK-NEXT:    add sp, sp, #32
; CHECK-NEXT:    ret
  %1 = alloca [8 x i32]
  %2 = ptrtoint [8 x i32]* %1 to i64
  %3 = mul i64 %i, 4
  %4 = add i64 %2, %3
  %5 = inttoptr i64 %4 to i32*
  %6 = load i32, i32* %5, align 4
  ret i32 %6
}

