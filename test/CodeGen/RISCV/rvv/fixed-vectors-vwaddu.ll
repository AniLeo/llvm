; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=CHECK,RV64

define <2 x i16> @vwaddu_v2i16(<2 x i8>* %x, <2 x i8>* %y) {
; CHECK-LABEL: vwaddu_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vle8.v v9, (a0)
; CHECK-NEXT:    vle8.v v10, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v9, v10
; CHECK-NEXT:    ret
  %a = load <2 x i8>, <2 x i8>* %x
  %b = load <2 x i8>, <2 x i8>* %y
  %c = zext <2 x i8> %a to <2 x i16>
  %d = zext <2 x i8> %b to <2 x i16>
  %e = add <2 x i16> %c, %d
  ret <2 x i16> %e
}

define <4 x i16> @vwaddu_v4i16(<4 x i8>* %x, <4 x i8>* %y) {
; CHECK-LABEL: vwaddu_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vle8.v v9, (a0)
; CHECK-NEXT:    vle8.v v10, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v9, v10
; CHECK-NEXT:    ret
  %a = load <4 x i8>, <4 x i8>* %x
  %b = load <4 x i8>, <4 x i8>* %y
  %c = zext <4 x i8> %a to <4 x i16>
  %d = zext <4 x i8> %b to <4 x i16>
  %e = add <4 x i16> %c, %d
  ret <4 x i16> %e
}

define <2 x i32> @vwaddu_v2i32(<2 x i16>* %x, <2 x i16>* %y) {
; CHECK-LABEL: vwaddu_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v9, (a0)
; CHECK-NEXT:    vle16.v v10, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v9, v10
; CHECK-NEXT:    ret
  %a = load <2 x i16>, <2 x i16>* %x
  %b = load <2 x i16>, <2 x i16>* %y
  %c = zext <2 x i16> %a to <2 x i32>
  %d = zext <2 x i16> %b to <2 x i32>
  %e = add <2 x i32> %c, %d
  ret <2 x i32> %e
}

define <8 x i16> @vwaddu_v8i16(<8 x i8>* %x, <8 x i8>* %y) {
; CHECK-LABEL: vwaddu_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v9, (a0)
; CHECK-NEXT:    vle8.v v10, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v9, v10
; CHECK-NEXT:    ret
  %a = load <8 x i8>, <8 x i8>* %x
  %b = load <8 x i8>, <8 x i8>* %y
  %c = zext <8 x i8> %a to <8 x i16>
  %d = zext <8 x i8> %b to <8 x i16>
  %e = add <8 x i16> %c, %d
  ret <8 x i16> %e
}

define <4 x i32> @vwaddu_v4i32(<4 x i16>* %x, <4 x i16>* %y) {
; CHECK-LABEL: vwaddu_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v9, (a0)
; CHECK-NEXT:    vle16.v v10, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v9, v10
; CHECK-NEXT:    ret
  %a = load <4 x i16>, <4 x i16>* %x
  %b = load <4 x i16>, <4 x i16>* %y
  %c = zext <4 x i16> %a to <4 x i32>
  %d = zext <4 x i16> %b to <4 x i32>
  %e = add <4 x i32> %c, %d
  ret <4 x i32> %e
}

define <2 x i64> @vwaddu_v2i64(<2 x i32>* %x, <2 x i32>* %y) {
; CHECK-LABEL: vwaddu_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v9, (a0)
; CHECK-NEXT:    vle32.v v10, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v9, v10
; CHECK-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %b = load <2 x i32>, <2 x i32>* %y
  %c = zext <2 x i32> %a to <2 x i64>
  %d = zext <2 x i32> %b to <2 x i64>
  %e = add <2 x i64> %c, %d
  ret <2 x i64> %e
}

define <16 x i16> @vwaddu_v16i16(<16 x i8>* %x, <16 x i8>* %y) {
; CHECK-LABEL: vwaddu_v16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; CHECK-NEXT:    vle8.v v10, (a0)
; CHECK-NEXT:    vle8.v v11, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v10, v11
; CHECK-NEXT:    ret
  %a = load <16 x i8>, <16 x i8>* %x
  %b = load <16 x i8>, <16 x i8>* %y
  %c = zext <16 x i8> %a to <16 x i16>
  %d = zext <16 x i8> %b to <16 x i16>
  %e = add <16 x i16> %c, %d
  ret <16 x i16> %e
}

define <8 x i32> @vwaddu_v8i32(<8 x i16>* %x, <8 x i16>* %y) {
; CHECK-LABEL: vwaddu_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; CHECK-NEXT:    vle16.v v10, (a0)
; CHECK-NEXT:    vle16.v v11, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v10, v11
; CHECK-NEXT:    ret
  %a = load <8 x i16>, <8 x i16>* %x
  %b = load <8 x i16>, <8 x i16>* %y
  %c = zext <8 x i16> %a to <8 x i32>
  %d = zext <8 x i16> %b to <8 x i32>
  %e = add <8 x i32> %c, %d
  ret <8 x i32> %e
}

define <4 x i64> @vwaddu_v4i64(<4 x i32>* %x, <4 x i32>* %y) {
; CHECK-LABEL: vwaddu_v4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v10, (a0)
; CHECK-NEXT:    vle32.v v11, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v10, v11
; CHECK-NEXT:    ret
  %a = load <4 x i32>, <4 x i32>* %x
  %b = load <4 x i32>, <4 x i32>* %y
  %c = zext <4 x i32> %a to <4 x i64>
  %d = zext <4 x i32> %b to <4 x i64>
  %e = add <4 x i64> %c, %d
  ret <4 x i64> %e
}

define <32 x i16> @vwaddu_v32i16(<32 x i8>* %x, <32 x i8>* %y) {
; CHECK-LABEL: vwaddu_v32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a2, 32
; CHECK-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; CHECK-NEXT:    vle8.v v12, (a0)
; CHECK-NEXT:    vle8.v v14, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v12, v14
; CHECK-NEXT:    ret
  %a = load <32 x i8>, <32 x i8>* %x
  %b = load <32 x i8>, <32 x i8>* %y
  %c = zext <32 x i8> %a to <32 x i16>
  %d = zext <32 x i8> %b to <32 x i16>
  %e = add <32 x i16> %c, %d
  ret <32 x i16> %e
}

define <16 x i32> @vwaddu_v16i32(<16 x i16>* %x, <16 x i16>* %y) {
; CHECK-LABEL: vwaddu_v16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, mu
; CHECK-NEXT:    vle16.v v12, (a0)
; CHECK-NEXT:    vle16.v v14, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v12, v14
; CHECK-NEXT:    ret
  %a = load <16 x i16>, <16 x i16>* %x
  %b = load <16 x i16>, <16 x i16>* %y
  %c = zext <16 x i16> %a to <16 x i32>
  %d = zext <16 x i16> %b to <16 x i32>
  %e = add <16 x i32> %c, %d
  ret <16 x i32> %e
}

define <8 x  i64> @vwaddu_v8i64(<8 x  i32>* %x, <8 x  i32>* %y) {
; CHECK-LABEL: vwaddu_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; CHECK-NEXT:    vle32.v v12, (a0)
; CHECK-NEXT:    vle32.v v14, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v12, v14
; CHECK-NEXT:    ret
  %a = load <8 x  i32>, <8 x  i32>* %x
  %b = load <8 x  i32>, <8 x  i32>* %y
  %c = zext <8 x  i32> %a to <8 x  i64>
  %d = zext <8 x  i32> %b to <8 x  i64>
  %e = add <8 x  i64> %c, %d
  ret <8 x  i64> %e
}

define <64 x i16> @vwaddu_v64i16(<64 x i8>* %x, <64 x i8>* %y) {
; CHECK-LABEL: vwaddu_v64i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a2, 64
; CHECK-NEXT:    vsetvli zero, a2, e8, m4, ta, mu
; CHECK-NEXT:    vle8.v v16, (a0)
; CHECK-NEXT:    vle8.v v20, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v16, v20
; CHECK-NEXT:    ret
  %a = load <64 x i8>, <64 x i8>* %x
  %b = load <64 x i8>, <64 x i8>* %y
  %c = zext <64 x i8> %a to <64 x i16>
  %d = zext <64 x i8> %b to <64 x i16>
  %e = add <64 x i16> %c, %d
  ret <64 x i16> %e
}

define <32 x i32> @vwaddu_v32i32(<32 x i16>* %x, <32 x i16>* %y) {
; CHECK-LABEL: vwaddu_v32i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a2, 32
; CHECK-NEXT:    vsetvli zero, a2, e16, m4, ta, mu
; CHECK-NEXT:    vle16.v v16, (a0)
; CHECK-NEXT:    vle16.v v20, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v16, v20
; CHECK-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %x
  %b = load <32 x i16>, <32 x i16>* %y
  %c = zext <32 x i16> %a to <32 x i32>
  %d = zext <32 x i16> %b to <32 x i32>
  %e = add <32 x i32> %c, %d
  ret <32 x i32> %e
}

define <16 x i64> @vwaddu_v16i64(<16 x i32>* %x, <16 x i32>* %y) {
; CHECK-LABEL: vwaddu_v16i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e32, m4, ta, mu
; CHECK-NEXT:    vle32.v v16, (a0)
; CHECK-NEXT:    vle32.v v20, (a1)
; CHECK-NEXT:    vwaddu.vv v8, v16, v20
; CHECK-NEXT:    ret
  %a = load <16 x i32>, <16 x i32>* %x
  %b = load <16 x i32>, <16 x i32>* %y
  %c = zext <16 x i32> %a to <16 x i64>
  %d = zext <16 x i32> %b to <16 x i64>
  %e = add <16 x i64> %c, %d
  ret <16 x i64> %e
}

define <128 x i16> @vwaddu_v128i16(<128 x i8>* %x, <128 x i8>* %y) nounwind {
; CHECK-LABEL: vwaddu_v128i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    csrr a2, vlenb
; CHECK-NEXT:    slli a2, a2, 3
; CHECK-NEXT:    sub sp, sp, a2
; CHECK-NEXT:    li a2, 128
; CHECK-NEXT:    vsetvli zero, a2, e8, m8, ta, mu
; CHECK-NEXT:    vle8.v v16, (a0)
; CHECK-NEXT:    vle8.v v24, (a1)
; CHECK-NEXT:    li a0, 64
; CHECK-NEXT:    vsetvli zero, a0, e8, m8, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v16, a0
; CHECK-NEXT:    addi a1, sp, 16
; CHECK-NEXT:    vs8r.v v8, (a1) # Unknown-size Folded Spill
; CHECK-NEXT:    vslidedown.vx v0, v24, a0
; CHECK-NEXT:    vsetvli zero, a0, e8, m4, ta, mu
; CHECK-NEXT:    vwaddu.vv v8, v16, v24
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vl8re8.v v24, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    vwaddu.vv v16, v24, v0
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 3
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
  %a = load <128 x i8>, <128 x i8>* %x
  %b = load <128 x i8>, <128 x i8>* %y
  %c = zext <128 x i8> %a to <128 x i16>
  %d = zext <128 x i8> %b to <128 x i16>
  %e = add <128 x i16> %c, %d
  ret <128 x i16> %e
}

define <64 x i32> @vwaddu_v64i32(<64 x i16>* %x, <64 x i16>* %y) nounwind {
; CHECK-LABEL: vwaddu_v64i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    csrr a2, vlenb
; CHECK-NEXT:    slli a2, a2, 3
; CHECK-NEXT:    sub sp, sp, a2
; CHECK-NEXT:    li a2, 64
; CHECK-NEXT:    vsetvli zero, a2, e16, m8, ta, mu
; CHECK-NEXT:    vle16.v v16, (a0)
; CHECK-NEXT:    vle16.v v24, (a1)
; CHECK-NEXT:    li a0, 32
; CHECK-NEXT:    vsetvli zero, a0, e16, m8, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v16, a0
; CHECK-NEXT:    addi a1, sp, 16
; CHECK-NEXT:    vs8r.v v8, (a1) # Unknown-size Folded Spill
; CHECK-NEXT:    vslidedown.vx v0, v24, a0
; CHECK-NEXT:    vsetvli zero, a0, e16, m4, ta, mu
; CHECK-NEXT:    vwaddu.vv v8, v16, v24
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vl8re8.v v24, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    vwaddu.vv v16, v24, v0
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 3
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
  %a = load <64 x i16>, <64 x i16>* %x
  %b = load <64 x i16>, <64 x i16>* %y
  %c = zext <64 x i16> %a to <64 x i32>
  %d = zext <64 x i16> %b to <64 x i32>
  %e = add <64 x i32> %c, %d
  ret <64 x i32> %e
}

define <32 x i64> @vwaddu_v32i64(<32 x i32>* %x, <32 x i32>* %y) nounwind {
; CHECK-LABEL: vwaddu_v32i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi sp, sp, -16
; CHECK-NEXT:    csrr a2, vlenb
; CHECK-NEXT:    slli a2, a2, 3
; CHECK-NEXT:    sub sp, sp, a2
; CHECK-NEXT:    li a2, 32
; CHECK-NEXT:    vsetvli zero, a2, e32, m8, ta, mu
; CHECK-NEXT:    vle32.v v16, (a0)
; CHECK-NEXT:    vle32.v v24, (a1)
; CHECK-NEXT:    vsetivli zero, 16, e32, m8, ta, mu
; CHECK-NEXT:    vslidedown.vi v8, v16, 16
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vs8r.v v8, (a0) # Unknown-size Folded Spill
; CHECK-NEXT:    vslidedown.vi v0, v24, 16
; CHECK-NEXT:    vsetivli zero, 16, e32, m4, ta, mu
; CHECK-NEXT:    vwaddu.vv v8, v16, v24
; CHECK-NEXT:    addi a0, sp, 16
; CHECK-NEXT:    vl8re8.v v24, (a0) # Unknown-size Folded Reload
; CHECK-NEXT:    vwaddu.vv v16, v24, v0
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    slli a0, a0, 3
; CHECK-NEXT:    add sp, sp, a0
; CHECK-NEXT:    addi sp, sp, 16
; CHECK-NEXT:    ret
  %a = load <32 x i32>, <32 x i32>* %x
  %b = load <32 x i32>, <32 x i32>* %y
  %c = zext <32 x i32> %a to <32 x i64>
  %d = zext <32 x i32> %b to <32 x i64>
  %e = add <32 x i64> %c, %d
  ret <32 x i64> %e
}

define <2 x i32> @vwaddu_v2i32_v2i8(<2 x i8>* %x, <2 x i8>* %y) {
; CHECK-LABEL: vwaddu_v2i32_v2i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vle8.v v8, (a1)
; CHECK-NEXT:    vle8.v v9, (a0)
; CHECK-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; CHECK-NEXT:    vzext.vf2 v10, v8
; CHECK-NEXT:    vzext.vf2 v11, v9
; CHECK-NEXT:    vwaddu.vv v8, v11, v10
; CHECK-NEXT:    ret
  %a = load <2 x i8>, <2 x i8>* %x
  %b = load <2 x i8>, <2 x i8>* %y
  %c = zext <2 x i8> %a to <2 x i32>
  %d = zext <2 x i8> %b to <2 x i32>
  %e = add <2 x i32> %c, %d
  ret <2 x i32> %e
}

define <4 x i32> @vwaddu_v4i32_v4i8_v4i16(<4 x i8>* %x, <4 x i16>* %y) {
; CHECK-LABEL: vwaddu_v4i32_v4i8_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vle8.v v8, (a0)
; CHECK-NEXT:    vle16.v v9, (a1)
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vzext.vf2 v10, v8
; CHECK-NEXT:    vwaddu.vv v8, v10, v9
; CHECK-NEXT:    ret
  %a = load <4 x i8>, <4 x i8>* %x
  %b = load <4 x i16>, <4 x i16>* %y
  %c = zext <4 x i8> %a to <4 x i32>
  %d = zext <4 x i16> %b to <4 x i32>
  %e = add <4 x i32> %c, %d
  ret <4 x i32> %e
}

define <4 x i64> @vwaddu_v4i64_v4i32_v4i8(<4 x i32>* %x, <4 x i8>* %y) {
; CHECK-LABEL: vwaddu_v4i64_v4i32_v4i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vle8.v v8, (a1)
; CHECK-NEXT:    vle32.v v10, (a0)
; CHECK-NEXT:    vzext.vf4 v11, v8
; CHECK-NEXT:    vwaddu.vv v8, v10, v11
; CHECK-NEXT:    ret
  %a = load <4 x i32>, <4 x i32>* %x
  %b = load <4 x i8>, <4 x i8>* %y
  %c = zext <4 x i32> %a to <4 x i64>
  %d = zext <4 x i8> %b to <4 x i64>
  %e = add <4 x i64> %c, %d
  ret <4 x i64> %e
}

define <2 x i16> @vwaddu_vx_v2i16(<2 x i8>* %x, i8 %y) {
; CHECK-LABEL: vwaddu_vx_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e8, mf8, ta, mu
; CHECK-NEXT:    vle8.v v9, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v9, a1
; CHECK-NEXT:    ret
  %a = load <2 x i8>, <2 x i8>* %x
  %b = insertelement <2 x i8> undef, i8 %y, i32 0
  %c = shufflevector <2 x i8> %b, <2 x i8> undef, <2 x i32> zeroinitializer
  %d = zext <2 x i8> %a to <2 x i16>
  %e = zext <2 x i8> %c to <2 x i16>
  %f = add <2 x i16> %d, %e
  ret <2 x i16> %f
}

define <4 x i16> @vwaddu_vx_v4i16(<4 x i8>* %x, i8 %y) {
; CHECK-LABEL: vwaddu_vx_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e8, mf4, ta, mu
; CHECK-NEXT:    vle8.v v9, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v9, a1
; CHECK-NEXT:    ret
  %a = load <4 x i8>, <4 x i8>* %x
  %b = insertelement <4 x i8> undef, i8 %y, i32 0
  %c = shufflevector <4 x i8> %b, <4 x i8> undef, <4 x i32> zeroinitializer
  %d = zext <4 x i8> %a to <4 x i16>
  %e = zext <4 x i8> %c to <4 x i16>
  %f = add <4 x i16> %d, %e
  ret <4 x i16> %f
}

define <2 x i32> @vwaddu_vx_v2i32(<2 x i16>* %x, i16 %y) {
; CHECK-LABEL: vwaddu_vx_v2i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vle16.v v9, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v9, a1
; CHECK-NEXT:    ret
  %a = load <2 x i16>, <2 x i16>* %x
  %b = insertelement <2 x i16> undef, i16 %y, i32 0
  %c = shufflevector <2 x i16> %b, <2 x i16> undef, <2 x i32> zeroinitializer
  %d = zext <2 x i16> %a to <2 x i32>
  %e = zext <2 x i16> %c to <2 x i32>
  %f = add <2 x i32> %d, %e
  ret <2 x i32> %f
}

define <8 x i16> @vwaddu_vx_v8i16(<8 x i8>* %x, i8 %y) {
; CHECK-LABEL: vwaddu_vx_v8i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v9, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v9, a1
; CHECK-NEXT:    ret
  %a = load <8 x i8>, <8 x i8>* %x
  %b = insertelement <8 x i8> undef, i8 %y, i32 0
  %c = shufflevector <8 x i8> %b, <8 x i8> undef, <8 x i32> zeroinitializer
  %d = zext <8 x i8> %a to <8 x i16>
  %e = zext <8 x i8> %c to <8 x i16>
  %f = add <8 x i16> %d, %e
  ret <8 x i16> %f
}

define <4 x i32> @vwaddu_vx_v4i32(<4 x i16>* %x, i16 %y) {
; CHECK-LABEL: vwaddu_vx_v4i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v9, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v9, a1
; CHECK-NEXT:    ret
  %a = load <4 x i16>, <4 x i16>* %x
  %b = insertelement <4 x i16> undef, i16 %y, i32 0
  %c = shufflevector <4 x i16> %b, <4 x i16> undef, <4 x i32> zeroinitializer
  %d = zext <4 x i16> %a to <4 x i32>
  %e = zext <4 x i16> %c to <4 x i32>
  %f = add <4 x i32> %d, %e
  ret <4 x i32> %f
}

define <2 x i64> @vwaddu_vx_v2i64(<2 x i32>* %x, i32 %y) {
; CHECK-LABEL: vwaddu_vx_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; CHECK-NEXT:    vle32.v v9, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v9, a1
; CHECK-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %b = insertelement <2 x i32> undef, i32 %y, i64 0
  %c = shufflevector <2 x i32> %b, <2 x i32> undef, <2 x i32> zeroinitializer
  %d = zext <2 x i32> %a to <2 x i64>
  %e = zext <2 x i32> %c to <2 x i64>
  %f = add <2 x i64> %d, %e
  ret <2 x i64> %f
}

define <16 x i16> @vwaddu_vx_v16i16(<16 x i8>* %x, i8 %y) {
; CHECK-LABEL: vwaddu_vx_v16i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e8, m1, ta, mu
; CHECK-NEXT:    vle8.v v10, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v10, a1
; CHECK-NEXT:    ret
  %a = load <16 x i8>, <16 x i8>* %x
  %b = insertelement <16 x i8> undef, i8 %y, i32 0
  %c = shufflevector <16 x i8> %b, <16 x i8> undef, <16 x i32> zeroinitializer
  %d = zext <16 x i8> %a to <16 x i16>
  %e = zext <16 x i8> %c to <16 x i16>
  %f = add <16 x i16> %d, %e
  ret <16 x i16> %f
}

define <8 x i32> @vwaddu_vx_v8i32(<8 x i16>* %x, i16 %y) {
; CHECK-LABEL: vwaddu_vx_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; CHECK-NEXT:    vle16.v v10, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v10, a1
; CHECK-NEXT:    ret
  %a = load <8 x i16>, <8 x i16>* %x
  %b = insertelement <8 x i16> undef, i16 %y, i32 0
  %c = shufflevector <8 x i16> %b, <8 x i16> undef, <8 x i32> zeroinitializer
  %d = zext <8 x i16> %a to <8 x i32>
  %e = zext <8 x i16> %c to <8 x i32>
  %f = add <8 x i32> %d, %e
  ret <8 x i32> %f
}

define <4 x i64> @vwaddu_vx_v4i64(<4 x i32>* %x, i32 %y) {
; CHECK-LABEL: vwaddu_vx_v4i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e32, m1, ta, mu
; CHECK-NEXT:    vle32.v v10, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v10, a1
; CHECK-NEXT:    ret
  %a = load <4 x i32>, <4 x i32>* %x
  %b = insertelement <4 x i32> undef, i32 %y, i64 0
  %c = shufflevector <4 x i32> %b, <4 x i32> undef, <4 x i32> zeroinitializer
  %d = zext <4 x i32> %a to <4 x i64>
  %e = zext <4 x i32> %c to <4 x i64>
  %f = add <4 x i64> %d, %e
  ret <4 x i64> %f
}

define <32 x i16> @vwaddu_vx_v32i16(<32 x i8>* %x, i8 %y) {
; CHECK-LABEL: vwaddu_vx_v32i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a2, 32
; CHECK-NEXT:    vsetvli zero, a2, e8, m2, ta, mu
; CHECK-NEXT:    vle8.v v12, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v12, a1
; CHECK-NEXT:    ret
  %a = load <32 x i8>, <32 x i8>* %x
  %b = insertelement <32 x i8> undef, i8 %y, i32 0
  %c = shufflevector <32 x i8> %b, <32 x i8> undef, <32 x i32> zeroinitializer
  %d = zext <32 x i8> %a to <32 x i16>
  %e = zext <32 x i8> %c to <32 x i16>
  %f = add <32 x i16> %d, %e
  ret <32 x i16> %f
}

define <16 x i32> @vwaddu_vx_v16i32(<16 x i16>* %x, i16 %y) {
; CHECK-LABEL: vwaddu_vx_v16i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e16, m2, ta, mu
; CHECK-NEXT:    vle16.v v12, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v12, a1
; CHECK-NEXT:    ret
  %a = load <16 x i16>, <16 x i16>* %x
  %b = insertelement <16 x i16> undef, i16 %y, i32 0
  %c = shufflevector <16 x i16> %b, <16 x i16> undef, <16 x i32> zeroinitializer
  %d = zext <16 x i16> %a to <16 x i32>
  %e = zext <16 x i16> %c to <16 x i32>
  %f = add <16 x i32> %d, %e
  ret <16 x i32> %f
}

define <8 x i64> @vwaddu_vx_v8i64(<8 x i32>* %x, i32 %y) {
; CHECK-LABEL: vwaddu_vx_v8i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e32, m2, ta, mu
; CHECK-NEXT:    vle32.v v12, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v12, a1
; CHECK-NEXT:    ret
  %a = load <8 x i32>, <8 x i32>* %x
  %b = insertelement <8 x i32> undef, i32 %y, i64 0
  %c = shufflevector <8 x i32> %b, <8 x i32> undef, <8 x i32> zeroinitializer
  %d = zext <8 x i32> %a to <8 x i64>
  %e = zext <8 x i32> %c to <8 x i64>
  %f = add <8 x i64> %d, %e
  ret <8 x i64> %f
}

define <64 x i16> @vwaddu_vx_v64i16(<64 x i8>* %x, i8 %y) {
; CHECK-LABEL: vwaddu_vx_v64i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a2, 64
; CHECK-NEXT:    vsetvli zero, a2, e8, m4, ta, mu
; CHECK-NEXT:    vle8.v v16, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v16, a1
; CHECK-NEXT:    ret
  %a = load <64 x i8>, <64 x i8>* %x
  %b = insertelement <64 x i8> undef, i8 %y, i32 0
  %c = shufflevector <64 x i8> %b, <64 x i8> undef, <64 x i32> zeroinitializer
  %d = zext <64 x i8> %a to <64 x i16>
  %e = zext <64 x i8> %c to <64 x i16>
  %f = add <64 x i16> %d, %e
  ret <64 x i16> %f
}

define <32 x i32> @vwaddu_vx_v32i32(<32 x i16>* %x, i16 %y) {
; CHECK-LABEL: vwaddu_vx_v32i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a2, 32
; CHECK-NEXT:    vsetvli zero, a2, e16, m4, ta, mu
; CHECK-NEXT:    vle16.v v16, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v16, a1
; CHECK-NEXT:    ret
  %a = load <32 x i16>, <32 x i16>* %x
  %b = insertelement <32 x i16> undef, i16 %y, i32 0
  %c = shufflevector <32 x i16> %b, <32 x i16> undef, <32 x i32> zeroinitializer
  %d = zext <32 x i16> %a to <32 x i32>
  %e = zext <32 x i16> %c to <32 x i32>
  %f = add <32 x i32> %d, %e
  ret <32 x i32> %f
}

define <16 x i64> @vwaddu_vx_v16i64(<16 x i32>* %x, i32 %y) {
; CHECK-LABEL: vwaddu_vx_v16i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 16, e32, m4, ta, mu
; CHECK-NEXT:    vle32.v v16, (a0)
; CHECK-NEXT:    vwaddu.vx v8, v16, a1
; CHECK-NEXT:    ret
  %a = load <16 x i32>, <16 x i32>* %x
  %b = insertelement <16 x i32> undef, i32 %y, i64 0
  %c = shufflevector <16 x i32> %b, <16 x i32> undef, <16 x i32> zeroinitializer
  %d = zext <16 x i32> %a to <16 x i64>
  %e = zext <16 x i32> %c to <16 x i64>
  %f = add <16 x i64> %d, %e
  ret <16 x i64> %f
}

define <8 x i16> @vwaddu_vx_v8i16_i8(<8 x i8>* %x, i8* %y) {
; CHECK-LABEL: vwaddu_vx_v8i16_i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v9, (a0)
; CHECK-NEXT:    lbu a0, 0(a1)
; CHECK-NEXT:    vwaddu.vx v8, v9, a0
; CHECK-NEXT:    ret
  %a = load <8 x i8>, <8 x i8>* %x
  %b = load i8, i8* %y
  %c = zext i8 %b to i16
  %d = insertelement <8 x i16> undef, i16 %c, i32 0
  %e = shufflevector <8 x i16> %d, <8 x i16> undef, <8 x i32> zeroinitializer
  %f = zext <8 x i8> %a to <8 x i16>
  %g = add <8 x i16> %e, %f
  ret <8 x i16> %g
}

define <8 x i16> @vwaddu_vx_v8i16_i16(<8 x i8>* %x, i16* %y) {
; CHECK-LABEL: vwaddu_vx_v8i16_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 8, e8, mf2, ta, mu
; CHECK-NEXT:    vle8.v v9, (a0)
; CHECK-NEXT:    vlse16.v v10, (a1), zero
; CHECK-NEXT:    vwaddu.wv v8, v10, v9
; CHECK-NEXT:    ret
  %a = load <8 x i8>, <8 x i8>* %x
  %b = load i16, i16* %y
  %d = insertelement <8 x i16> undef, i16 %b, i32 0
  %e = shufflevector <8 x i16> %d, <8 x i16> undef, <8 x i32> zeroinitializer
  %f = zext <8 x i8> %a to <8 x i16>
  %g = add <8 x i16> %e, %f
  ret <8 x i16> %g
}

define <4 x i32> @vwaddu_vx_v4i32_i8(<4 x i16>* %x, i8* %y) {
; CHECK-LABEL: vwaddu_vx_v4i32_i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v9, (a0)
; CHECK-NEXT:    lbu a0, 0(a1)
; CHECK-NEXT:    vwaddu.vx v8, v9, a0
; CHECK-NEXT:    ret
  %a = load <4 x i16>, <4 x i16>* %x
  %b = load i8, i8* %y
  %c = zext i8 %b to i32
  %d = insertelement <4 x i32> undef, i32 %c, i32 0
  %e = shufflevector <4 x i32> %d, <4 x i32> undef, <4 x i32> zeroinitializer
  %f = zext <4 x i16> %a to <4 x i32>
  %g = add <4 x i32> %e, %f
  ret <4 x i32> %g
}

define <4 x i32> @vwaddu_vx_v4i32_i16(<4 x i16>* %x, i16* %y) {
; CHECK-LABEL: vwaddu_vx_v4i32_i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v9, (a0)
; CHECK-NEXT:    lhu a0, 0(a1)
; CHECK-NEXT:    vwaddu.vx v8, v9, a0
; CHECK-NEXT:    ret
  %a = load <4 x i16>, <4 x i16>* %x
  %b = load i16, i16* %y
  %c = zext i16 %b to i32
  %d = insertelement <4 x i32> undef, i32 %c, i32 0
  %e = shufflevector <4 x i32> %d, <4 x i32> undef, <4 x i32> zeroinitializer
  %f = zext <4 x i16> %a to <4 x i32>
  %g = add <4 x i32> %e, %f
  ret <4 x i32> %g
}

define <4 x i32> @vwaddu_vx_v4i32_i32(<4 x i16>* %x, i32* %y) {
; CHECK-LABEL: vwaddu_vx_v4i32_i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 4, e16, mf2, ta, mu
; CHECK-NEXT:    vle16.v v9, (a0)
; CHECK-NEXT:    vlse32.v v10, (a1), zero
; CHECK-NEXT:    vwaddu.wv v8, v10, v9
; CHECK-NEXT:    ret
  %a = load <4 x i16>, <4 x i16>* %x
  %b = load i32, i32* %y
  %d = insertelement <4 x i32> undef, i32 %b, i32 0
  %e = shufflevector <4 x i32> %d, <4 x i32> undef, <4 x i32> zeroinitializer
  %f = zext <4 x i16> %a to <4 x i32>
  %g = add <4 x i32> %e, %f
  ret <4 x i32> %g
}

define <2 x i64> @vwaddu_vx_v2i64_i8(<2 x i32>* %x, i8* %y) nounwind {
; RV32-LABEL: vwaddu_vx_v2i64_i8:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV32-NEXT:    lbu a1, 0(a1)
; RV32-NEXT:    vle32.v v9, (a0)
; RV32-NEXT:    sw zero, 12(sp)
; RV32-NEXT:    sw a1, 8(sp)
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v10, (a0), zero
; RV32-NEXT:    vwaddu.wv v8, v10, v9
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: vwaddu_vx_v2i64_i8:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV64-NEXT:    vle32.v v9, (a0)
; RV64-NEXT:    lbu a0, 0(a1)
; RV64-NEXT:    vwaddu.vx v8, v9, a0
; RV64-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %b = load i8, i8* %y
  %c = zext i8 %b to i64
  %d = insertelement <2 x i64> undef, i64 %c, i64 0
  %e = shufflevector <2 x i64> %d, <2 x i64> undef, <2 x i32> zeroinitializer
  %f = zext <2 x i32> %a to <2 x i64>
  %g = add <2 x i64> %e, %f
  ret <2 x i64> %g
}

define <2 x i64> @vwaddu_vx_v2i64_i16(<2 x i32>* %x, i16* %y) nounwind {
; RV32-LABEL: vwaddu_vx_v2i64_i16:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV32-NEXT:    lhu a1, 0(a1)
; RV32-NEXT:    vle32.v v9, (a0)
; RV32-NEXT:    sw zero, 12(sp)
; RV32-NEXT:    sw a1, 8(sp)
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v10, (a0), zero
; RV32-NEXT:    vwaddu.wv v8, v10, v9
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: vwaddu_vx_v2i64_i16:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV64-NEXT:    vle32.v v9, (a0)
; RV64-NEXT:    lhu a0, 0(a1)
; RV64-NEXT:    vwaddu.vx v8, v9, a0
; RV64-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %b = load i16, i16* %y
  %c = zext i16 %b to i64
  %d = insertelement <2 x i64> undef, i64 %c, i64 0
  %e = shufflevector <2 x i64> %d, <2 x i64> undef, <2 x i32> zeroinitializer
  %f = zext <2 x i32> %a to <2 x i64>
  %g = add <2 x i64> %e, %f
  ret <2 x i64> %g
}

define <2 x i64> @vwaddu_vx_v2i64_i32(<2 x i32>* %x, i32* %y) nounwind {
; RV32-LABEL: vwaddu_vx_v2i64_i32:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV32-NEXT:    lw a1, 0(a1)
; RV32-NEXT:    vle32.v v9, (a0)
; RV32-NEXT:    sw zero, 12(sp)
; RV32-NEXT:    sw a1, 8(sp)
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v10, (a0), zero
; RV32-NEXT:    vwaddu.wv v8, v10, v9
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: vwaddu_vx_v2i64_i32:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV64-NEXT:    vle32.v v9, (a0)
; RV64-NEXT:    lwu a0, 0(a1)
; RV64-NEXT:    vwaddu.vx v8, v9, a0
; RV64-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %b = load i32, i32* %y
  %c = zext i32 %b to i64
  %d = insertelement <2 x i64> undef, i64 %c, i64 0
  %e = shufflevector <2 x i64> %d, <2 x i64> undef, <2 x i32> zeroinitializer
  %f = zext <2 x i32> %a to <2 x i64>
  %g = add <2 x i64> %e, %f
  ret <2 x i64> %g
}

define <2 x i64> @vwaddu_vx_v2i64_i64(<2 x i32>* %x, i64* %y) nounwind {
; RV32-LABEL: vwaddu_vx_v2i64_i64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -16
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV32-NEXT:    lw a2, 4(a1)
; RV32-NEXT:    lw a1, 0(a1)
; RV32-NEXT:    vle32.v v9, (a0)
; RV32-NEXT:    sw a2, 12(sp)
; RV32-NEXT:    sw a1, 8(sp)
; RV32-NEXT:    addi a0, sp, 8
; RV32-NEXT:    vlse64.v v10, (a0), zero
; RV32-NEXT:    vwaddu.wv v8, v10, v9
; RV32-NEXT:    addi sp, sp, 16
; RV32-NEXT:    ret
;
; RV64-LABEL: vwaddu_vx_v2i64_i64:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV64-NEXT:    vle32.v v9, (a0)
; RV64-NEXT:    vlse64.v v10, (a1), zero
; RV64-NEXT:    vwaddu.wv v8, v10, v9
; RV64-NEXT:    ret
  %a = load <2 x i32>, <2 x i32>* %x
  %b = load i64, i64* %y
  %d = insertelement <2 x i64> undef, i64 %b, i64 0
  %e = shufflevector <2 x i64> %d, <2 x i64> undef, <2 x i32> zeroinitializer
  %f = zext <2 x i32> %a to <2 x i64>
  %g = add <2 x i64> %e, %f
  ret <2 x i64> %g
}
