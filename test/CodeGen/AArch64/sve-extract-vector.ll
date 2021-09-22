; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve,+bf16 < %s | FileCheck %s --check-prefixes=CHECK

; Should codegen to a nop, since idx is zero.
define <2 x i64> @extract_v2i64_nxv2i64(<vscale x 2 x i64> %vec) nounwind {
; CHECK-LABEL: extract_v2i64_nxv2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %retval = call <2 x i64> @llvm.experimental.vector.extract.v2i64.nxv2i64(<vscale x 2 x i64> %vec, i64 0)
  ret <2 x i64> %retval
}

; Goes through memory currently; idx != 0.
define <2 x i64> @extract_v2i64_nxv2i64_idx2(<vscale x 2 x i64> %vec) nounwind {
; CHECK-LABEL: extract_v2i64_nxv2i64_idx2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    cntd x9
; CHECK-NEXT:    sub x9, x9, #2
; CHECK-NEXT:    mov w8, #2
; CHECK-NEXT:    cmp x9, #2
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    csel x8, x9, x8, lo
; CHECK-NEXT:    st1d { z0.d }, p0, [sp]
; CHECK-NEXT:    lsl x8, x8, #3
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    ldr q0, [x9, x8]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <2 x i64> @llvm.experimental.vector.extract.v2i64.nxv2i64(<vscale x 2 x i64> %vec, i64 2)
  ret <2 x i64> %retval
}

; Should codegen to a nop, since idx is zero.
define <4 x i32> @extract_v4i32_nxv4i32(<vscale x 4 x i32> %vec) nounwind {
; CHECK-LABEL: extract_v4i32_nxv4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %retval = call <4 x i32> @llvm.experimental.vector.extract.v4i32.nxv4i32(<vscale x 4 x i32> %vec, i64 0)
  ret <4 x i32> %retval
}

; Goes through memory currently; idx != 0.
define <4 x i32> @extract_v4i32_nxv4i32_idx4(<vscale x 4 x i32> %vec) nounwind {
; CHECK-LABEL: extract_v4i32_nxv4i32_idx4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    cntw x9
; CHECK-NEXT:    sub x9, x9, #4
; CHECK-NEXT:    mov w8, #4
; CHECK-NEXT:    cmp x9, #4
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    csel x8, x9, x8, lo
; CHECK-NEXT:    st1w { z0.s }, p0, [sp]
; CHECK-NEXT:    lsl x8, x8, #2
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    ldr q0, [x9, x8]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <4 x i32> @llvm.experimental.vector.extract.v4i32.nxv4i32(<vscale x 4 x i32> %vec, i64 4)
  ret <4 x i32> %retval
}

; Should codegen to a nop, since idx is zero.
define <8 x i16> @extract_v8i16_nxv8i16(<vscale x 8 x i16> %vec) nounwind {
; CHECK-LABEL: extract_v8i16_nxv8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %retval = call <8 x i16> @llvm.experimental.vector.extract.v8i16.nxv8i16(<vscale x 8 x i16> %vec, i64 0)
  ret <8 x i16> %retval
}

; Goes through memory currently; idx != 0.
define <8 x i16> @extract_v8i16_nxv8i16_idx8(<vscale x 8 x i16> %vec) nounwind {
; CHECK-LABEL: extract_v8i16_nxv8i16_idx8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    cnth x9
; CHECK-NEXT:    sub x9, x9, #8
; CHECK-NEXT:    mov w8, #8
; CHECK-NEXT:    cmp x9, #8
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    csel x8, x9, x8, lo
; CHECK-NEXT:    st1h { z0.h }, p0, [sp]
; CHECK-NEXT:    lsl x8, x8, #1
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    ldr q0, [x9, x8]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <8 x i16> @llvm.experimental.vector.extract.v8i16.nxv8i16(<vscale x 8 x i16> %vec, i64 8)
  ret <8 x i16> %retval
}

; Should codegen to a nop, since idx is zero.
define <16 x i8> @extract_v16i8_nxv16i8(<vscale x 16 x i8> %vec) nounwind {
; CHECK-LABEL: extract_v16i8_nxv16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    // kill: def $q0 killed $q0 killed $z0
; CHECK-NEXT:    ret
  %retval = call <16 x i8> @llvm.experimental.vector.extract.v16i8.nxv16i8(<vscale x 16 x i8> %vec, i64 0)
  ret <16 x i8> %retval
}

; Goes through memory currently; idx != 0.
define <16 x i8> @extract_v16i8_nxv16i8_idx16(<vscale x 16 x i8> %vec) nounwind {
; CHECK-LABEL: extract_v16i8_nxv16i8_idx16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    rdvl x9, #1
; CHECK-NEXT:    sub x9, x9, #16
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    mov w8, #16
; CHECK-NEXT:    cmp x9, #16
; CHECK-NEXT:    st1b { z0.b }, p0, [sp]
; CHECK-NEXT:    csel x8, x9, x8, lo
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    ldr q0, [x9, x8]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <16 x i8> @llvm.experimental.vector.extract.v16i8.nxv16i8(<vscale x 16 x i8> %vec, i64 16)
  ret <16 x i8> %retval
}


; Extracting illegal subvectors

define <vscale x 1 x i32> @extract_nxv1i32_nxv4i32(<vscale x 4 x i32> %vec) nounwind {
; CHECK-LABEL: extract_nxv1i32_nxv4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %retval = call <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv4i32(<vscale x 4 x i32> %vec, i64 0)
  ret <vscale x 1 x i32> %retval
}

define <vscale x 1 x i16> @extract_nxv1i16_nxv6i16(<vscale x 6 x i16> %vec) nounwind {
; CHECK-LABEL: extract_nxv1i16_nxv6i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    ret
  %retval = call <vscale x 1 x i16> @llvm.experimental.vector.extract.nxv1i16.nxv6i16(<vscale x 6 x i16> %vec, i64 0)
  ret <vscale x 1 x i16> %retval
}

; Fixed length clamping

define <2 x i64> @extract_fixed_v2i64_nxv2i64(<vscale x 2 x i64> %vec) nounwind #0 {
; CHECK-LABEL: extract_fixed_v2i64_nxv2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    cntd x9
; CHECK-NEXT:    sub x9, x9, #2
; CHECK-NEXT:    mov w8, #2
; CHECK-NEXT:    cmp x9, #2
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    csel x8, x9, x8, lo
; CHECK-NEXT:    st1d { z0.d }, p0, [sp]
; CHECK-NEXT:    lsl x8, x8, #3
; CHECK-NEXT:    mov x9, sp
; CHECK-NEXT:    ldr q0, [x9, x8]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <2 x i64> @llvm.experimental.vector.extract.v2i64.nxv2i64(<vscale x 2 x i64> %vec, i64 2)
  ret <2 x i64> %retval
}

define <4 x i64> @extract_fixed_v4i64_nxv2i64(<vscale x 2 x i64> %vec) nounwind #0 {
; CHECK-LABEL: extract_fixed_v4i64_nxv2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    cntd x9
; CHECK-NEXT:    subs x9, x9, #4
; CHECK-NEXT:    csel x9, xzr, x9, lo
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    mov w10, #4
; CHECK-NEXT:    cmp x9, #4
; CHECK-NEXT:    st1d { z0.d }, p0, [sp]
; CHECK-NEXT:    csel x9, x9, x10, lo
; CHECK-NEXT:    mov x10, sp
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [x10, x9, lsl #3]
; CHECK-NEXT:    st1d { z0.d }, p0, [x8]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <4 x i64> @llvm.experimental.vector.extract.v4i64.nxv2i64(<vscale x 2 x i64> %vec, i64 4)
  ret <4 x i64> %retval
}

;
; Extracting a predicate from a wider predicate, that is more than twice the size.
;

define <vscale x 2 x i1> @extract_nxv2i1_nxv16i1_0(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv16i1_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %vec, i64 0)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv16i1_2(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv16i1_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %vec, i64 2)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv16i1_4(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv16i1_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %vec, i64 4)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv16i1_6(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv16i1_6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %vec, i64 6)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv16i1_8(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv16i1_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %vec, i64 8)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv16i1_10(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv16i1_10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %vec, i64 10)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv16i1_12(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv16i1_12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %vec, i64 12)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv16i1_14(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv16i1_14:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1> %vec, i64 14)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv8i1_0(<vscale x 8 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv8i1_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv8i1(<vscale x 8 x i1> %vec, i64 0)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv8i1_2(<vscale x 8 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv8i1_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv8i1(<vscale x 8 x i1> %vec, i64 2)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv8i1_4(<vscale x 8 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv8i1_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv8i1(<vscale x 8 x i1> %vec, i64 4)
  ret <vscale x 2 x i1> %res
}

define <vscale x 2 x i1> @extract_nxv2i1_nxv8i1_6(<vscale x 8 x i1> %vec) {
; CHECK-LABEL: extract_nxv2i1_nxv8i1_6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv8i1(<vscale x 8 x i1> %vec, i64 6)
  ret <vscale x 2 x i1> %res
}

define <vscale x 4 x i1> @extract_nxv4i1_nxv16i1_0(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv4i1_nxv16i1_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1> %vec, i64 0)
  ret <vscale x 4 x i1> %res
}

define <vscale x 4 x i1> @extract_nxv4i1_nxv16i1_4(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv4i1_nxv16i1_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1> %vec, i64 4)
  ret <vscale x 4 x i1> %res
}

define <vscale x 4 x i1> @extract_nxv4i1_nxv16i1_8(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv4i1_nxv16i1_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpklo p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1> %vec, i64 8)
  ret <vscale x 4 x i1> %res
}

define <vscale x 4 x i1> @extract_nxv4i1_nxv16i1_12(<vscale x 16 x i1> %vec) {
; CHECK-LABEL: extract_nxv4i1_nxv16i1_12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    punpkhi p0.h, p0.b
; CHECK-NEXT:    ret
  %res = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1> %vec, i64 12)
  ret <vscale x 4 x i1> %res
}

;
; Extracting illegal vector that needs promotion from a vector that needs splitting.
;

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_0(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 0)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_2(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 2)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_4(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 4)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_6(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 6)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_8(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z0.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 8)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_10(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z0.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 10)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_12(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z0.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 12)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_14(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_14:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z0.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 14)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_16(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z1.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 16)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_18(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_18:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z1.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 18)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_20(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_20:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z1.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 20)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_22(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_22:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z1.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 22)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_24(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_24:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z1.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 24)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_26(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_26:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z1.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 26)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_28(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_28:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z1.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 28)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv32i8_30(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv32i8_30:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z1.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 30)
  ret <vscale x 2 x i8> %res
}

;
; Extracting illegal vector that needs promotion from a vector that needs widening.
;

define <vscale x 2 x i8> @extract_nxv2i8_nxv14i8_0(<vscale x 14 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv14i8_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv14i8(<vscale x 14 x i8> %vec, i64 0)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv14i8_2(<vscale x 14 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv14i8_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv14i8(<vscale x 14 x i8> %vec, i64 2)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv14i8_4(<vscale x 14 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv14i8_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv14i8(<vscale x 14 x i8> %vec, i64 4)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv14i8_6(<vscale x 14 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv14i8_6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.h, z0.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv14i8(<vscale x 14 x i8> %vec, i64 6)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv14i8_8(<vscale x 14 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv14i8_8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z0.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv14i8(<vscale x 14 x i8> %vec, i64 8)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv14i8_10(<vscale x 14 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv14i8_10:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z0.b
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv14i8(<vscale x 14 x i8> %vec, i64 10)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x i8> @extract_nxv2i8_nxv14i8_12(<vscale x 14 x i8> %vec) {
; CHECK-LABEL: extract_nxv2i8_nxv14i8_12:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.h, z0.b
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv14i8(<vscale x 14 x i8> %vec, i64 12)
  ret <vscale x 2 x i8> %res
}

define <vscale x 2 x half> @extract_nxv2f16_nxv8f16_0(<vscale x 8 x half> %in) {
; CHECK-LABEL: extract_nxv2f16_nxv8f16_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x half> @llvm.experimental.vector.extract.nxv2f16.nxv8f16(<vscale x 8 x half> %in, i64 0)
  ret <vscale x 2 x half> %res
}

define <vscale x 2 x half> @extract_nxv2f16_nxv8f16_2(<vscale x 8 x half> %in) {
; CHECK-LABEL: extract_nxv2f16_nxv8f16_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x half> @llvm.experimental.vector.extract.nxv2f16.nxv8f16(<vscale x 8 x half> %in, i64 2)
  ret <vscale x 2 x half> %res
}

define <vscale x 2 x half> @extract_nxv2f16_nxv8f16_4(<vscale x 8 x half> %in) {
; CHECK-LABEL: extract_nxv2f16_nxv8f16_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x half> @llvm.experimental.vector.extract.nxv2f16.nxv8f16(<vscale x 8 x half> %in, i64 4)
  ret <vscale x 2 x half> %res
}

define <vscale x 2 x half> @extract_nxv2f16_nxv8f16_6(<vscale x 8 x half> %in) {
; CHECK-LABEL: extract_nxv2f16_nxv8f16_6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x half> @llvm.experimental.vector.extract.nxv2f16.nxv8f16(<vscale x 8 x half> %in, i64 6)
  ret <vscale x 2 x half> %res
}

define <vscale x 2 x bfloat> @extract_nxv2bf16_nxv8bf16_0(<vscale x 8 x bfloat> %in) {
; CHECK-LABEL: extract_nxv2bf16_nxv8bf16_0:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x bfloat> @llvm.experimental.vector.extract.nxv2bf16.nxv8bf16(<vscale x 8 x bfloat> %in, i64 0)
  ret <vscale x 2 x bfloat> %res
}

define <vscale x 2 x bfloat> @extract_nxv2bf16_nxv8bf16_2(<vscale x 8 x bfloat> %in) {
; CHECK-LABEL: extract_nxv2bf16_nxv8bf16_2:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpklo z0.d, z0.s
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x bfloat> @llvm.experimental.vector.extract.nxv2bf16.nxv8bf16(<vscale x 8 x bfloat> %in, i64 2)
  ret <vscale x 2 x bfloat> %res
}

define <vscale x 2 x bfloat> @extract_nxv2bf16_nxv8bf16_4(<vscale x 8 x bfloat> %in) {
; CHECK-LABEL: extract_nxv2bf16_nxv8bf16_4:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    uunpklo z0.s, z0.h
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x bfloat> @llvm.experimental.vector.extract.nxv2bf16.nxv8bf16(<vscale x 8 x bfloat> %in, i64 4)
  ret <vscale x 2 x bfloat> %res
}

define <vscale x 2 x bfloat> @extract_nxv2bf16_nxv8bf16_6(<vscale x 8 x bfloat> %in) {
; CHECK-LABEL: extract_nxv2bf16_nxv8bf16_6:
; CHECK:       // %bb.0:
; CHECK-NEXT:    uunpkhi z0.d, z0.s
; CHECK-NEXT:    uunpkhi z0.s, z0.h
; CHECK-NEXT:    ret
  %res = call <vscale x 2 x bfloat> @llvm.experimental.vector.extract.nxv2bf16.nxv8bf16(<vscale x 8 x bfloat> %in, i64 6)
  ret <vscale x 2 x bfloat> %res
}

attributes #0 = { vscale_range(2,2) }

declare <2 x i64> @llvm.experimental.vector.extract.v2i64.nxv2i64(<vscale x 2 x i64>, i64)
declare <4 x i32> @llvm.experimental.vector.extract.v4i32.nxv4i32(<vscale x 4 x i32>, i64)
declare <8 x i16> @llvm.experimental.vector.extract.v8i16.nxv8i16(<vscale x 8 x i16>, i64)
declare <16 x i8> @llvm.experimental.vector.extract.v16i8.nxv16i8(<vscale x 16 x i8>, i64)

declare <4 x i64> @llvm.experimental.vector.extract.v4i64.nxv2i64(<vscale x 2 x i64>, i64)

declare <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv4i32(<vscale x 4 x i32>, i64)
declare <vscale x 1 x i16> @llvm.experimental.vector.extract.nxv1i16.nxv6i16(<vscale x 6 x i16>, i64)

declare <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv16i1(<vscale x 16 x i1>, i64)
declare <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1.nxv8i1(<vscale x 8 x i1>, i64)
declare <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1.nxv16i1(<vscale x 16 x i1>, i64)

declare <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> , i64)
declare <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv14i8(<vscale x 14 x i8> , i64)

declare <vscale x 2 x half> @llvm.experimental.vector.extract.nxv2f16.nxv8f16(<vscale x 8 x half>, i64)
declare <vscale x 2 x bfloat> @llvm.experimental.vector.extract.nxv2bf16.nxv8bf16(<vscale x 8 x bfloat>, i64)
