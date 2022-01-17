; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple riscv32 -mattr=+m,+d,+zfh,+experimental-v -verify-machineinstrs < %s | FileCheck %s
; RUN: llc -mtriple riscv64 -mattr=+m,+d,+zfh,+experimental-v -verify-machineinstrs < %s | FileCheck %s

define <vscale x 4 x i32> @extract_nxv8i32_nxv4i32_0(<vscale x 8 x i32> %vec) {
; CHECK-LABEL: extract_nxv8i32_nxv4i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $v8m2 killed $v8m2 killed $v8m4
; CHECK-NEXT:    ret
  %c = call <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv8i32(<vscale x 8 x i32> %vec, i64 0)
  ret <vscale x 4 x i32> %c
}

define <vscale x 4 x i32> @extract_nxv8i32_nxv4i32_4(<vscale x 8 x i32> %vec) {
; CHECK-LABEL: extract_nxv8i32_nxv4i32_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %c = call <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv8i32(<vscale x 8 x i32> %vec, i64 4)
  ret <vscale x 4 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv8i32_nxv2i32_0(<vscale x 8 x i32> %vec) {
; CHECK-LABEL: extract_nxv8i32_nxv2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $v8 killed $v8 killed $v8m4
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv8i32(<vscale x 8 x i32> %vec, i64 0)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv8i32_nxv2i32_2(<vscale x 8 x i32> %vec) {
; CHECK-LABEL: extract_nxv8i32_nxv2i32_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv8i32(<vscale x 8 x i32> %vec, i64 2)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv8i32_nxv2i32_4(<vscale x 8 x i32> %vec) {
; CHECK-LABEL: extract_nxv8i32_nxv2i32_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv8i32(<vscale x 8 x i32> %vec, i64 4)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv8i32_nxv2i32_6(<vscale x 8 x i32> %vec) {
; CHECK-LABEL: extract_nxv8i32_nxv2i32_6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v11
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv8i32(<vscale x 8 x i32> %vec, i64 6)
  ret <vscale x 2 x i32> %c
}

define <vscale x 8 x i32> @extract_nxv16i32_nxv8i32_0(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv8i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $v8m4 killed $v8m4 killed $v8m8
; CHECK-NEXT:    ret
  %c = call <vscale x 8 x i32> @llvm.experimental.vector.extract.nxv8i32.nxv16i32(<vscale x 16 x i32> %vec, i64 0)
  ret <vscale x 8 x i32> %c
}

define <vscale x 8 x i32> @extract_nxv16i32_nxv8i32_8(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv8i32_8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv4r.v v8, v12
; CHECK-NEXT:    ret
  %c = call <vscale x 8 x i32> @llvm.experimental.vector.extract.nxv8i32.nxv16i32(<vscale x 16 x i32> %vec, i64 8)
  ret <vscale x 8 x i32> %c
}

define <vscale x 4 x i32> @extract_nxv16i32_nxv4i32_0(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv4i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $v8m2 killed $v8m2 killed $v8m8
; CHECK-NEXT:    ret
  %c = call <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv16i32(<vscale x 16 x i32> %vec, i64 0)
  ret <vscale x 4 x i32> %c
}

define <vscale x 4 x i32> @extract_nxv16i32_nxv4i32_4(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv4i32_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv2r.v v8, v10
; CHECK-NEXT:    ret
  %c = call <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv16i32(<vscale x 16 x i32> %vec, i64 4)
  ret <vscale x 4 x i32> %c
}

define <vscale x 4 x i32> @extract_nxv16i32_nxv4i32_8(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv4i32_8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv2r.v v8, v12
; CHECK-NEXT:    ret
  %c = call <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv16i32(<vscale x 16 x i32> %vec, i64 8)
  ret <vscale x 4 x i32> %c
}

define <vscale x 4 x i32> @extract_nxv16i32_nxv4i32_12(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv4i32_12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv2r.v v8, v14
; CHECK-NEXT:    ret
  %c = call <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv16i32(<vscale x 16 x i32> %vec, i64 12)
  ret <vscale x 4 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv16i32_nxv2i32_0(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv2i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $v8 killed $v8 killed $v8m8
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 0)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv16i32_nxv2i32_2(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv2i32_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 2)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv16i32_nxv2i32_4(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv2i32_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v10
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 4)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv16i32_nxv2i32_6(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv2i32_6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v11
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 6)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv16i32_nxv2i32_8(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv2i32_8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v12
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 8)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv16i32_nxv2i32_10(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv2i32_10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v13
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 10)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv16i32_nxv2i32_12(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv2i32_12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v14
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 12)
  ret <vscale x 2 x i32> %c
}

define <vscale x 2 x i32> @extract_nxv16i32_nxv2i32_14(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv2i32_14:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v15
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 14)
  ret <vscale x 2 x i32> %c
}

define <vscale x 1 x i32> @extract_nxv16i32_nxv1i32_0(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv1i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $v8 killed $v8 killed $v8m8
; CHECK-NEXT:    ret
  %c = call <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv16i32(<vscale x 16 x i32> %vec, i64 0)
  ret <vscale x 1 x i32> %c
}

define <vscale x 1 x i32> @extract_nxv16i32_nxv1i32_1(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv1i32_1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 3
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv16i32(<vscale x 16 x i32> %vec, i64 1)
  ret <vscale x 1 x i32> %c
}

define <vscale x 1 x i32> @extract_nxv16i32_nxv1i32_3(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv1i32_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 3
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v9, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv16i32(<vscale x 16 x i32> %vec, i64 3)
  ret <vscale x 1 x i32> %c
}

define <vscale x 1 x i32> @extract_nxv16i32_nxv1i32_15(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv1i32_15:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 3
; CHECK-NEXT:    vsetvli a1, zero, e32, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v15, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv16i32(<vscale x 16 x i32> %vec, i64 15)
  ret <vscale x 1 x i32> %c
}

define <vscale x 1 x i32> @extract_nxv16i32_nxv1i32_2(<vscale x 16 x i32> %vec) {
; CHECK-LABEL: extract_nxv16i32_nxv1i32_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %c = call <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv16i32(<vscale x 16 x i32> %vec, i64 2)
  ret <vscale x 1 x i32> %c
}

define <vscale x 1 x i32> @extract_nxv2i32_nxv1i32_0(<vscale x 2 x i32> %vec) {
; CHECK-LABEL: extract_nxv2i32_nxv1i32_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %c = call <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv2i32(<vscale x 2 x i32> %vec, i64 0)
  ret <vscale x 1 x i32> %c
}

define <vscale x 2 x i8> @extract_nxv32i8_nxv2i8_0(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv32i8_nxv2i8_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $v8 killed $v8 killed $v8m4
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 0)
  ret <vscale x 2 x i8> %c
}

define <vscale x 2 x i8> @extract_nxv32i8_nxv2i8_2(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv32i8_nxv2i8_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 2
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 2)
  ret <vscale x 2 x i8> %c
}

define <vscale x 2 x i8> @extract_nxv32i8_nxv2i8_4(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv32i8_nxv2i8_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 4)
  ret <vscale x 2 x i8> %c
}

define <vscale x 2 x i8> @extract_nxv32i8_nxv2i8_6(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv32i8_nxv2i8_6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 3
; CHECK-NEXT:    li a1, 6
; CHECK-NEXT:    mul a0, a0, a1
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 6)
  ret <vscale x 2 x i8> %c
}

define <vscale x 2 x i8> @extract_nxv32i8_nxv2i8_8(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv32i8_nxv2i8_8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 8)
  ret <vscale x 2 x i8> %c
}

define <vscale x 2 x i8> @extract_nxv32i8_nxv2i8_22(<vscale x 32 x i8> %vec) {
; CHECK-LABEL: extract_nxv32i8_nxv2i8_22:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 3
; CHECK-NEXT:    li a1, 6
; CHECK-NEXT:    mul a0, a0, a1
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v10, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 22)
  ret <vscale x 2 x i8> %c
}

define <vscale x 1 x i8> @extract_nxv8i8_nxv1i8_7(<vscale x 8 x i8> %vec) {
; CHECK-LABEL: extract_nxv8i8_nxv1i8_7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 3
; CHECK-NEXT:    slli a1, a0, 3
; CHECK-NEXT:    sub a0, a1, a0
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 1 x i8> @llvm.experimental.vector.extract.nxv1i8.nxv8i8(<vscale x 8 x i8> %vec, i64 7)
  ret <vscale x 1 x i8> %c
}

define <vscale x 1 x i8> @extract_nxv4i8_nxv1i8_3(<vscale x 4 x i8> %vec) {
; CHECK-LABEL: extract_nxv4i8_nxv1i8_3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 3
; CHECK-NEXT:    slli a1, a0, 1
; CHECK-NEXT:    add a0, a1, a0
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 1 x i8> @llvm.experimental.vector.extract.nxv1i8.nxv4i8(<vscale x 4 x i8> %vec, i64 3)
  ret <vscale x 1 x i8> %c
}

define <vscale x 2 x half> @extract_nxv2f16_nxv16f16_0(<vscale x 16 x half> %vec) {
; CHECK-LABEL: extract_nxv2f16_nxv16f16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $v8 killed $v8 killed $v8m4
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x half> @llvm.experimental.vector.extract.nxv2f16.nxv16f16(<vscale x 16 x half> %vec, i64 0)
  ret <vscale x 2 x half> %c
}

define <vscale x 2 x half> @extract_nxv2f16_nxv16f16_2(<vscale x 16 x half> %vec) {
; CHECK-LABEL: extract_nxv2f16_nxv16f16_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 2
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x half> @llvm.experimental.vector.extract.nxv2f16.nxv16f16(<vscale x 16 x half> %vec, i64 2)
  ret <vscale x 2 x half> %c
}

define <vscale x 2 x half> @extract_nxv2f16_nxv16f16_4(<vscale x 16 x half> %vec) {
; CHECK-LABEL: extract_nxv2f16_nxv16f16_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vmv1r.v v8, v9
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x half> @llvm.experimental.vector.extract.nxv2f16.nxv16f16(<vscale x 16 x half> %vec, i64 4)
  ret <vscale x 2 x half> %c
}

define <vscale x 8 x i1> @extract_nxv64i1_nxv8i1_0(<vscale x 64 x i1> %mask) {
; CHECK-LABEL: extract_nxv64i1_nxv8i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %c = call <vscale x 8 x i1> @llvm.experimental.vector.extract.nxv8i1(<vscale x 64 x i1> %mask, i64 0)
  ret <vscale x 8 x i1> %c
}

define <vscale x 8 x i1> @extract_nxv64i1_nxv8i1_8(<vscale x 64 x i1> %mask) {
; CHECK-LABEL: extract_nxv64i1_nxv8i1_8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 3
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v0, v0, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 8 x i1> @llvm.experimental.vector.extract.nxv8i1(<vscale x 64 x i1> %mask, i64 8)
  ret <vscale x 8 x i1> %c
}

define <vscale x 2 x i1> @extract_nxv64i1_nxv2i1_0(<vscale x 64 x i1> %mask) {
; CHECK-LABEL: extract_nxv64i1_nxv2i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1(<vscale x 64 x i1> %mask, i64 0)
  ret <vscale x 2 x i1> %c
}

define <vscale x 2 x i1> @extract_nxv64i1_nxv2i1_2(<vscale x 64 x i1> %mask) {
; CHECK-LABEL: extract_nxv64i1_nxv2i1_2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m8, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 2
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vsetvli a0, zero, e8, mf4, ta, mu
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    ret
  %c = call <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1(<vscale x 64 x i1> %mask, i64 2)
  ret <vscale x 2 x i1> %c
}

define <vscale x 4 x i1> @extract_nxv4i1_nxv32i1_0(<vscale x 32 x i1> %x) {
; CHECK-LABEL: extract_nxv4i1_nxv32i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %c = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1(<vscale x 32 x i1> %x, i64 0)
  ret <vscale x 4 x i1> %c
}

define <vscale x 4 x i1> @extract_nxv4i1_nxv32i1_4(<vscale x 32 x i1> %x) {
; CHECK-LABEL: extract_nxv4i1_nxv32i1_4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e8, m4, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, 1, v0
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 1
; CHECK-NEXT:    vsetvli a1, zero, e8, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v8, v8, a0
; CHECK-NEXT:    vsetvli a0, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vmsne.vi v0, v8, 0
; CHECK-NEXT:    ret
  %c = call <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1(<vscale x 32 x i1> %x, i64 4)
  ret <vscale x 4 x i1> %c
}

define <vscale x 16 x i1> @extract_nxv16i1_nxv32i1_0(<vscale x 32 x i1> %x) {
; CHECK-LABEL: extract_nxv16i1_nxv32i1_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %c = call <vscale x 16 x i1> @llvm.experimental.vector.extract.nxv16i1(<vscale x 32 x i1> %x, i64 0)
  ret <vscale x 16 x i1> %c
}

define <vscale x 16 x i1> @extract_nxv16i1_nxv32i1_16(<vscale x 32 x i1> %x) {
; CHECK-LABEL: extract_nxv16i1_nxv32i1_16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 2
; CHECK-NEXT:    vsetvli a1, zero, e8, mf2, ta, mu
; CHECK-NEXT:    vslidedown.vx v0, v0, a0
; CHECK-NEXT:    ret
  %c = call <vscale x 16 x i1> @llvm.experimental.vector.extract.nxv16i1(<vscale x 32 x i1> %x, i64 16)
  ret <vscale x 16 x i1> %c
}

;
; Extract f16 vector that needs widening from one that needs widening.
;
define <vscale x 6 x half> @extract_nxv6f16_nxv12f16_0(<vscale x 12 x half> %in) {
; CHECK-LABEL: extract_nxv6f16_nxv12f16_0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    # kill: def $v8m2 killed $v8m2 killed $v8m4
; CHECK-NEXT:    ret
  %res = call <vscale x 6 x half> @llvm.experimental.vector.extract.nxv6f16.nxv12f16(<vscale x 12 x half> %in, i64 0)
  ret <vscale x 6 x half> %res
}

define <vscale x 6 x half> @extract_nxv6f16_nxv12f16_6(<vscale x 12 x half> %in) {
; CHECK-LABEL: extract_nxv6f16_nxv12f16_6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    csrr a0, vlenb
; CHECK-NEXT:    srli a0, a0, 2
; CHECK-NEXT:    vsetvli a1, zero, e16, m1, ta, mu
; CHECK-NEXT:    vslidedown.vx v14, v10, a0
; CHECK-NEXT:    vslidedown.vx v12, v9, a0
; CHECK-NEXT:    vsetvli zero, a0, e16, m1, tu, mu
; CHECK-NEXT:    vslideup.vi v13, v14, 0
; CHECK-NEXT:    add a1, a0, a0
; CHECK-NEXT:    vsetvli zero, a1, e16, m1, tu, mu
; CHECK-NEXT:    vslideup.vx v12, v10, a0
; CHECK-NEXT:    vmv2r.v v8, v12
; CHECK-NEXT:    ret
  %res = call <vscale x 6 x half> @llvm.experimental.vector.extract.nxv6f16.nxv12f16(<vscale x 12 x half> %in, i64 6)
  ret <vscale x 6 x half> %res
}

declare <vscale x 6 x half> @llvm.experimental.vector.extract.nxv6f16.nxv12f16(<vscale x 12 x half>, i64)

declare <vscale x 1 x i8> @llvm.experimental.vector.extract.nxv1i8.nxv4i8(<vscale x 4 x i8> %vec, i64 %idx)
declare <vscale x 1 x i8> @llvm.experimental.vector.extract.nxv1i8.nxv8i8(<vscale x 8 x i8> %vec, i64 %idx)

declare <vscale x 2 x i8> @llvm.experimental.vector.extract.nxv2i8.nxv32i8(<vscale x 32 x i8> %vec, i64 %idx)

declare <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv2i32(<vscale x 2 x i32> %vec, i64 %idx)

declare <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv8i32(<vscale x 8 x i32> %vec, i64 %idx)
declare <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv8i32(<vscale x 8 x i32> %vec, i64 %idx)

declare <vscale x 1 x i32> @llvm.experimental.vector.extract.nxv1i32.nxv16i32(<vscale x 16 x i32> %vec, i64 %idx)
declare <vscale x 2 x i32> @llvm.experimental.vector.extract.nxv2i32.nxv16i32(<vscale x 16 x i32> %vec, i64 %idx)
declare <vscale x 4 x i32> @llvm.experimental.vector.extract.nxv4i32.nxv16i32(<vscale x 16 x i32> %vec, i64 %idx)
declare <vscale x 8 x i32> @llvm.experimental.vector.extract.nxv8i32.nxv16i32(<vscale x 16 x i32> %vec, i64 %idx)

declare <vscale x 2 x half> @llvm.experimental.vector.extract.nxv2f16.nxv16f16(<vscale x 16 x half> %vec, i64 %idx)

declare <vscale x 4 x i1> @llvm.experimental.vector.extract.nxv4i1(<vscale x 32 x i1> %vec, i64 %idx)
declare <vscale x 16 x i1> @llvm.experimental.vector.extract.nxv16i1(<vscale x 32 x i1> %vec, i64 %idx)

declare <vscale x 2 x i1> @llvm.experimental.vector.extract.nxv2i1(<vscale x 64 x i1> %vec, i64 %idx)
declare <vscale x 8 x i1> @llvm.experimental.vector.extract.nxv8i1(<vscale x 64 x i1> %vec, i64 %idx)
