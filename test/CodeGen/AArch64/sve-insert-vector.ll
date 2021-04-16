; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-linux-gnu -mattr=+sve < %s | FileCheck %s --check-prefixes=CHECK

define <vscale x 2 x i64> @insert_v2i64_nxv2i64(<vscale x 2 x i64> %vec, <2 x i64> %subvec) nounwind {
; CHECK-LABEL: insert_v2i64_nxv2i64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    st1d { z0.d }, p0, [sp]
; CHECK-NEXT:    str q1, [sp]
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [sp]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <vscale x 2 x i64> @llvm.experimental.vector.insert.nxv2i64.v2i64(<vscale x 2 x i64> %vec, <2 x i64> %subvec, i64 0)
  ret <vscale x 2 x i64> %retval
}

define <vscale x 2 x i64> @insert_v2i64_nxv2i64_idx1(<vscale x 2 x i64> %vec, <2 x i64> %subvec) nounwind {
; CHECK-LABEL: insert_v2i64_nxv2i64_idx1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.d
; CHECK-NEXT:    st1d { z0.d }, p0, [sp]
; CHECK-NEXT:    stur q1, [sp, #8]
; CHECK-NEXT:    ld1d { z0.d }, p0/z, [sp]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <vscale x 2 x i64> @llvm.experimental.vector.insert.nxv2i64.v2i64(<vscale x 2 x i64> %vec, <2 x i64> %subvec, i64 1)
  ret <vscale x 2 x i64> %retval
}

define <vscale x 4 x i32> @insert_v4i32_nxv4i32(<vscale x 4 x i32> %vec, <4 x i32> %subvec) nounwind {
; CHECK-LABEL: insert_v4i32_nxv4i32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [sp]
; CHECK-NEXT:    str q1, [sp]
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [sp]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <vscale x 4 x i32> @llvm.experimental.vector.insert.nxv4i32.v4i32(<vscale x 4 x i32> %vec, <4 x i32> %subvec, i64 0)
  ret <vscale x 4 x i32> %retval
}

define <vscale x 4 x i32> @insert_v4i32_nxv4i32_idx1(<vscale x 4 x i32> %vec, <4 x i32> %subvec) nounwind {
; CHECK-LABEL: insert_v4i32_nxv4i32_idx1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.s
; CHECK-NEXT:    st1w { z0.s }, p0, [sp]
; CHECK-NEXT:    stur q1, [sp, #4]
; CHECK-NEXT:    ld1w { z0.s }, p0/z, [sp]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <vscale x 4 x i32> @llvm.experimental.vector.insert.nxv4i32.v4i32(<vscale x 4 x i32> %vec, <4 x i32> %subvec, i64 1)
  ret <vscale x 4 x i32> %retval
}

define <vscale x 8 x i16> @insert_v8i16_nxv8i16(<vscale x 8 x i16> %vec, <8 x i16> %subvec) nounwind {
; CHECK-LABEL: insert_v8i16_nxv8i16:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [sp]
; CHECK-NEXT:    str q1, [sp]
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [sp]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <vscale x 8 x i16> @llvm.experimental.vector.insert.nxv8i16.v8i16(<vscale x 8 x i16> %vec, <8 x i16> %subvec, i64 0)
  ret <vscale x 8 x i16> %retval
}

define <vscale x 8 x i16> @insert_v8i16_nxv8i16_idx1(<vscale x 8 x i16> %vec, <8 x i16> %subvec) nounwind {
; CHECK-LABEL: insert_v8i16_nxv8i16_idx1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.h
; CHECK-NEXT:    st1h { z0.h }, p0, [sp]
; CHECK-NEXT:    stur q1, [sp, #2]
; CHECK-NEXT:    ld1h { z0.h }, p0/z, [sp]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <vscale x 8 x i16> @llvm.experimental.vector.insert.nxv8i16.v8i16(<vscale x 8 x i16> %vec, <8 x i16> %subvec, i64 1)
  ret <vscale x 8 x i16> %retval
}

define <vscale x 16 x i8> @insert_v16i8_nxv16i8(<vscale x 16 x i8> %vec, <16 x i8> %subvec) nounwind {
; CHECK-LABEL: insert_v16i8_nxv16i8:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [sp]
; CHECK-NEXT:    str q1, [sp]
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [sp]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <vscale x 16 x i8> @llvm.experimental.vector.insert.nxv16i8.v16i8(<vscale x 16 x i8> %vec, <16 x i8> %subvec, i64 0)
  ret <vscale x 16 x i8> %retval
}

define <vscale x 16 x i8> @insert_v16i8_nxv16i8_idx1(<vscale x 16 x i8> %vec, <16 x i8> %subvec) nounwind {
; CHECK-LABEL: insert_v16i8_nxv16i8_idx1:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x29, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    addvl sp, sp, #-1
; CHECK-NEXT:    ptrue p0.b
; CHECK-NEXT:    st1b { z0.b }, p0, [sp]
; CHECK-NEXT:    stur q1, [sp, #1]
; CHECK-NEXT:    ld1b { z0.b }, p0/z, [sp]
; CHECK-NEXT:    addvl sp, sp, #1
; CHECK-NEXT:    ldr x29, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %retval = call <vscale x 16 x i8> @llvm.experimental.vector.insert.nxv16i8.v16i8(<vscale x 16 x i8> %vec, <16 x i8> %subvec, i64 1)
  ret <vscale x 16 x i8> %retval
}

declare <vscale x 2 x i64> @llvm.experimental.vector.insert.nxv2i64.v2i64(<vscale x 2 x i64>, <2 x i64>, i64)
declare <vscale x 4 x i32> @llvm.experimental.vector.insert.nxv4i32.v4i32(<vscale x 4 x i32>, <4 x i32>, i64)
declare <vscale x 8 x i16> @llvm.experimental.vector.insert.nxv8i16.v8i16(<vscale x 8 x i16>, <8 x i16>, i64)
declare <vscale x 16 x i8> @llvm.experimental.vector.insert.nxv16i8.v16i8(<vscale x 16 x i8>, <16 x i8>, i64)
