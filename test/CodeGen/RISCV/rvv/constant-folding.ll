; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+v -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s --check-prefixes=CHECK,RV64

; These tests check that the scalable-vector version of this series of
; instructions does not get into an infinite DAGCombine loop. This was
; originally exposing an infinite loop between an 'and' of two truncates being promoted
; to the larger value type, then that 'truncate' being split back up into an
; 'and' of two truncates.
; This didn't happen in the fixed-length test because a truncate of the
; constant BUILD_VECTOR is folded into the BUILD_VECTOR itself. The truncate of
; a constant SPLAT_VECTOR didn't follow suit.

define <2 x i16> @fixedlen(<2 x i32> %x) {
; RV32-LABEL: fixedlen:
; RV32:       # %bb.0:
; RV32-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV32-NEXT:    vsrl.vi v8, v8, 16
; RV32-NEXT:    lui a0, 1048568
; RV32-NEXT:    vand.vx v8, v8, a0
; RV32-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; RV32-NEXT:    vnsrl.wx v8, v8, zero
; RV32-NEXT:    ret
;
; RV64-LABEL: fixedlen:
; RV64:       # %bb.0:
; RV64-NEXT:    vsetivli zero, 2, e32, mf2, ta, mu
; RV64-NEXT:    vsrl.vi v8, v8, 16
; RV64-NEXT:    lui a0, 131071
; RV64-NEXT:    slli a0, a0, 3
; RV64-NEXT:    vand.vx v8, v8, a0
; RV64-NEXT:    vsetvli zero, zero, e16, mf4, ta, mu
; RV64-NEXT:    vnsrl.wx v8, v8, zero
; RV64-NEXT:    ret
  %v41 = insertelement <2 x i32> poison, i32 16, i32 0
  %v42 = shufflevector <2 x i32> %v41, <2 x i32> poison, <2 x i32> zeroinitializer
  %v43 = lshr <2 x i32> %x, %v42
  %v44 = trunc <2 x i32> %v43 to <2 x i16>
  %v45 =  insertelement <2 x i32> poison, i32 -32768, i32 0
  %v46 = shufflevector <2 x i32> %v45, <2 x i32> poison, <2 x i32> zeroinitializer
  %v47 = trunc <2 x i32> %v46 to <2 x i16>
  %v48 = and <2 x i16> %v44, %v47
  ret <2 x i16> %v48
}

define <vscale x 2 x i16> @scalable(<vscale x 2 x i32> %x) {
; CHECK-LABEL: scalable:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e32, m1, ta, mu
; CHECK-NEXT:    vsrl.vi v8, v8, 16
; CHECK-NEXT:    vsetvli zero, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vnsrl.wx v8, v8, zero
; CHECK-NEXT:    lui a0, 1048568
; CHECK-NEXT:    vand.vx v8, v8, a0
; CHECK-NEXT:    ret
  %v41 = insertelement <vscale x 2 x i32> poison, i32 16, i32 0
  %v42 = shufflevector <vscale x 2 x i32> %v41, <vscale x 2 x i32> poison, <vscale x 2 x i32> zeroinitializer
  %v43 = lshr <vscale x 2 x i32> %x, %v42
  %v44 = trunc <vscale x 2 x i32> %v43 to <vscale x 2 x i16>
  %v45 =  insertelement <vscale x 2 x i32> poison, i32 -32768, i32 0
  %v46 = shufflevector <vscale x 2 x i32> %v45, <vscale x 2 x i32> poison, <vscale x 2 x i32> zeroinitializer
  %v47 = trunc <vscale x 2 x i32> %v46 to <vscale x 2 x i16>
  %v48 = and <vscale x 2 x i16> %v44, %v47
  ret <vscale x 2 x i16> %v48
}
