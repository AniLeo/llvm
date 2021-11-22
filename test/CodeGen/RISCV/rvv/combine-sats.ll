; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+experimental-v -riscv-v-vector-bits-min=128 < %s \
; RUN:     | FileCheck %s --check-prefixes=CHECK,RV32
; RUN: llc -mtriple=riscv64 -mattr=+m,+experimental-v -riscv-v-vector-bits-min=128 < %s \
; RUN:     | FileCheck %s --check-prefixes=CHECK,RV64

; fold (add (umax X, C), -C) --> (usubsat X, C)

define <2 x i64> @add_umax_v2i64(<2 x i64> %a0) {
; CHECK-LABEL: add_umax_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 7
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vssubu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %v1 = call <2 x i64> @llvm.umax.v2i64(<2 x i64> %a0, <2 x i64> <i64 7, i64 7>)
  %v2 = add <2 x i64> %v1, <i64 -7, i64 -7>
  ret <2 x i64> %v2
}

define <vscale x 2 x i64> @add_umax_nxv2i64(<vscale x 2 x i64> %a0) {
; CHECK-LABEL: add_umax_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 7
; CHECK-NEXT:    vsetvli a1, zero, e64, m2, ta, mu
; CHECK-NEXT:    vssubu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %ins1 = insertelement <vscale x 2 x i64> poison, i64 7, i32 0
  %splat1 = shufflevector <vscale x 2 x i64> %ins1, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %ins2 = insertelement <vscale x 2 x i64> poison, i64 -7, i32 0
  %splat2 = shufflevector <vscale x 2 x i64> %ins2, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %v1 = call <vscale x 2 x i64> @llvm.umax.nxv2i64(<vscale x 2 x i64> %a0, <vscale x 2 x i64> %splat1)
  %v2 = add <vscale x 2 x i64> %v1, %splat2
  ret <vscale x 2 x i64> %v2
}

; Try to find umax(a,b) - b or a - umin(a,b) patterns
; they may be converted to usubsat(a,b).

define <2 x i64> @sub_umax_v2i64(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: sub_umax_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vssubu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %v1 = call <2 x i64> @llvm.umax.v2i64(<2 x i64> %a0, <2 x i64> %a1)
  %v2 = sub <2 x i64> %v1, %a1
  ret <2 x i64> %v2
}

define <vscale x 2 x i64> @sub_umax_nxv2i64(<vscale x 2 x i64> %a0, <vscale x 2 x i64> %a1) {
; CHECK-LABEL: sub_umax_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vssubu.vv v8, v8, v10
; CHECK-NEXT:    ret
  %v1 = call <vscale x 2 x i64> @llvm.umax.nxv2i64(<vscale x 2 x i64> %a0, <vscale x 2 x i64> %a1)
  %v2 = sub <vscale x 2 x i64> %v1, %a1
  ret <vscale x 2 x i64> %v2
}

define <2 x i64> @sub_umin_v2i64(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: sub_umin_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vssubu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %v1 = call <2 x i64> @llvm.umin.v2i64(<2 x i64> %a0, <2 x i64> %a1)
  %v2 = sub <2 x i64> %a0, %v1
  ret <2 x i64> %v2
}

define <vscale x 2 x i64> @sub_umin_nxv2i64(<vscale x 2 x i64> %a0, <vscale x 2 x i64> %a1) {
; CHECK-LABEL: sub_umin_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vssubu.vv v8, v8, v10
; CHECK-NEXT:    ret
  %v1 = call <vscale x 2 x i64> @llvm.umin.nxv2i64(<vscale x 2 x i64> %a0, <vscale x 2 x i64> %a1)
  %v2 = sub <vscale x 2 x i64> %a0, %v1
  ret <vscale x 2 x i64> %v2
}

; Match VSELECTs into sub with unsigned saturation.

; x >= y ? x-y : 0 --> usubsat x, y

define <2 x i64> @vselect_sub_v2i64(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: vselect_sub_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vssubu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %cmp = icmp uge <2 x i64> %a0, %a1
  %v1 = sub <2 x i64> %a0, %a1
  %v2 = select <2 x i1> %cmp, <2 x i64> %v1, <2 x i64> zeroinitializer
  ret <2 x i64> %v2
}

define <vscale x 2 x i64> @vselect_sub_nxv2i64(<vscale x 2 x i64> %a0, <vscale x 2 x i64> %a1) {
; CHECK-LABEL: vselect_sub_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vssubu.vv v8, v8, v10
; CHECK-NEXT:    ret
  %cmp = icmp uge <vscale x 2 x i64> %a0, %a1
  %v1 = sub <vscale x 2 x i64> %a0, %a1
  %v2 = select <vscale x 2 x i1> %cmp, <vscale x 2 x i64> %v1, <vscale x 2 x i64> zeroinitializer
  ret <vscale x 2 x i64> %v2
}

define <8 x i16> @vselect_sub_2_v8i16(<8 x i16> %x, i16 zeroext %w) nounwind {
; CHECK-LABEL: vselect_sub_2_v8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 8, e16, m1, ta, mu
; CHECK-NEXT:    vssubu.vx v8, v8, a0
; CHECK-NEXT:    ret
entry:
  %0 = insertelement <8 x i16> undef, i16 %w, i32 0
  %broadcast15 = shufflevector <8 x i16> %0, <8 x i16> undef, <8 x i32> zeroinitializer
  %1 = icmp ult <8 x i16> %x, %broadcast15
  %2 = sub <8 x i16> %x, %broadcast15
  %res = select <8 x i1> %1, <8 x i16> zeroinitializer, <8 x i16> %2
  ret <8 x i16> %res
}

define <vscale x 8 x i16> @vselect_sub_2_nxv8i16(<vscale x 8 x i16> %x, i16 zeroext %w) nounwind {
; CHECK-LABEL: vselect_sub_2_nxv8i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a1, zero, e16, m2, ta, mu
; CHECK-NEXT:    vssubu.vx v8, v8, a0
; CHECK-NEXT:    ret
entry:
  %0 = insertelement <vscale x 8 x i16> undef, i16 %w, i32 0
  %broadcast15 = shufflevector <vscale x 8 x i16> %0, <vscale x 8 x i16> undef, <vscale x 8 x i32> zeroinitializer
  %1 = icmp ult <vscale x 8 x i16> %x, %broadcast15
  %2 = sub <vscale x 8 x i16> %x, %broadcast15
  %res = select <vscale x 8 x i1> %1, <vscale x 8 x i16> zeroinitializer, <vscale x 8 x i16> %2
  ret <vscale x 8 x i16> %res
}

; x >  y ? x-y : 0 --> usubsat x, y
; x > C-1 ? x+-C : 0 --> usubsat x, C

define <2 x i64> @vselect_add_const_v2i64(<2 x i64> %a0) {
; CHECK-LABEL: vselect_add_const_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 6
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vssubu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %v1 = add <2 x i64> %a0, <i64 -6, i64 -6>
  %cmp = icmp ugt <2 x i64> %a0, <i64 5, i64 5>
  %v2 = select <2 x i1> %cmp, <2 x i64> %v1, <2 x i64> zeroinitializer
  ret <2 x i64> %v2
}

define <vscale x 2 x i64> @vselect_add_const_nxv2i64(<vscale x 2 x i64> %a0) {
; CHECK-LABEL: vselect_add_const_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    li a0, 6
; CHECK-NEXT:    vsetvli a1, zero, e64, m2, ta, mu
; CHECK-NEXT:    vssubu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %cm1 = insertelement <vscale x 2 x i64> poison, i64 -6, i32 0
  %splatcm1 = shufflevector <vscale x 2 x i64> %cm1, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %nc = insertelement <vscale x 2 x i64> poison, i64 5, i32 0
  %splatnc = shufflevector <vscale x 2 x i64> %nc, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %v1 = add <vscale x 2 x i64> %a0, %splatcm1
  %cmp = icmp ugt <vscale x 2 x i64> %a0, %splatnc
  %v2 = select <vscale x 2 x i1> %cmp, <vscale x 2 x i64> %v1, <vscale x 2 x i64> zeroinitializer
  ret <vscale x 2 x i64> %v2
}

define <2 x i16> @vselect_add_const_signbit_v2i16(<2 x i16> %a0) {
; RV32-LABEL: vselect_add_const_signbit_v2i16:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a0, 8
; RV32-NEXT:    addi a0, a0, -1
; RV32-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; RV32-NEXT:    vssubu.vx v8, v8, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: vselect_add_const_signbit_v2i16:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a0, 8
; RV64-NEXT:    addiw a0, a0, -1
; RV64-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; RV64-NEXT:    vssubu.vx v8, v8, a0
; RV64-NEXT:    ret
  %cmp = icmp ugt <2 x i16> %a0, <i16 32766, i16 32766>
  %v1 = add <2 x i16> %a0, <i16 -32767, i16 -32767>
  %v2 = select <2 x i1> %cmp, <2 x i16> %v1, <2 x i16> zeroinitializer
  ret <2 x i16> %v2
}

define <vscale x 2 x i16> @vselect_add_const_signbit_nxv2i16(<vscale x 2 x i16> %a0) {
; RV32-LABEL: vselect_add_const_signbit_nxv2i16:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a0, 8
; RV32-NEXT:    addi a0, a0, -1
; RV32-NEXT:    vsetvli a1, zero, e16, mf2, ta, mu
; RV32-NEXT:    vssubu.vx v8, v8, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: vselect_add_const_signbit_nxv2i16:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a0, 8
; RV64-NEXT:    addiw a0, a0, -1
; RV64-NEXT:    vsetvli a1, zero, e16, mf2, ta, mu
; RV64-NEXT:    vssubu.vx v8, v8, a0
; RV64-NEXT:    ret
  %cm1 = insertelement <vscale x 2 x i16> poison, i16 32766, i32 0
  %splatcm1 = shufflevector <vscale x 2 x i16> %cm1, <vscale x 2 x i16> poison, <vscale x 2 x i32> zeroinitializer
  %nc = insertelement <vscale x 2 x i16> poison, i16 -32767, i32 0
  %splatnc = shufflevector <vscale x 2 x i16> %nc, <vscale x 2 x i16> poison, <vscale x 2 x i32> zeroinitializer
  %cmp = icmp ugt <vscale x 2 x i16> %a0, %splatcm1
  %v1 = add <vscale x 2 x i16> %a0, %splatnc
  %v2 = select <vscale x 2 x i1> %cmp, <vscale x 2 x i16> %v1, <vscale x 2 x i16> zeroinitializer
  ret <vscale x 2 x i16> %v2
}

; x s< 0 ? x^C : 0 --> usubsat x, C

define <2 x i16> @vselect_xor_const_signbit_v2i16(<2 x i16> %a0) {
; CHECK-LABEL: vselect_xor_const_signbit_v2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 8
; CHECK-NEXT:    vsetivli zero, 2, e16, mf4, ta, mu
; CHECK-NEXT:    vssubu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %cmp = icmp slt <2 x i16> %a0, zeroinitializer
  %v1 = xor <2 x i16> %a0, <i16 -32768, i16 -32768>
  %v2 = select <2 x i1> %cmp, <2 x i16> %v1, <2 x i16> zeroinitializer
  ret <2 x i16> %v2
}

define <vscale x 2 x i16> @vselect_xor_const_signbit_nxv2i16(<vscale x 2 x i16> %a0) {
; CHECK-LABEL: vselect_xor_const_signbit_nxv2i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, 8
; CHECK-NEXT:    vsetvli a1, zero, e16, mf2, ta, mu
; CHECK-NEXT:    vssubu.vx v8, v8, a0
; CHECK-NEXT:    ret
  %cmp = icmp slt <vscale x 2 x i16> %a0, zeroinitializer
  %ins = insertelement <vscale x 2 x i16> poison, i16 -32768, i32 0
  %splat = shufflevector <vscale x 2 x i16> %ins, <vscale x 2 x i16> poison, <vscale x 2 x i32> zeroinitializer
  %v1 = xor <vscale x 2 x i16> %a0, %splat
  %v2 = select <vscale x 2 x i1> %cmp, <vscale x 2 x i16> %v1, <vscale x 2 x i16> zeroinitializer
  ret <vscale x 2 x i16> %v2
}

; Match VSELECTs into add with unsigned saturation.

; x <= x+y ? x+y : ~0 --> uaddsat x, y
; x+y >= x ? x+y : ~0 --> uaddsat x, y

define <2 x i64> @vselect_add_v2i64(<2 x i64> %a0, <2 x i64> %a1) {
; CHECK-LABEL: vselect_add_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vsaddu.vv v8, v8, v9
; CHECK-NEXT:    ret
  %v1 = add <2 x i64> %a0, %a1
  %cmp = icmp ule <2 x i64> %a0, %v1
  %v2 = select <2 x i1> %cmp, <2 x i64> %v1, <2 x i64> <i64 -1, i64 -1>
  ret <2 x i64> %v2
}

define <vscale x 2 x i64> @vselect_add_nxv2i64(<vscale x 2 x i64> %a0, <vscale x 2 x i64> %a1) {
; CHECK-LABEL: vselect_add_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsaddu.vv v8, v8, v10
; CHECK-NEXT:    ret
  %v1 = add <vscale x 2 x i64> %a0, %a1
  %cmp = icmp ule <vscale x 2 x i64> %a0, %v1
  %allones = insertelement <vscale x 2 x i64> poison, i64 -1, i32 0
  %splatallones = shufflevector <vscale x 2 x i64> %allones, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %v2 = select <vscale x 2 x i1> %cmp, <vscale x 2 x i64> %v1, <vscale x 2 x i64> %splatallones
  ret <vscale x 2 x i64> %v2
}

; if the rhs is a constant we have to reverse the const canonicalization.
; x >= ~C ? x+C : ~0 --> uaddsat x, C

define <2 x i64> @vselect_add_const_2_v2i64(<2 x i64> %a0) {
; CHECK-LABEL: vselect_add_const_2_v2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetivli zero, 2, e64, m1, ta, mu
; CHECK-NEXT:    vsaddu.vi v8, v8, 6
; CHECK-NEXT:    ret
  %v1 = add <2 x i64> %a0, <i64 6, i64 6>
  %cmp = icmp ule <2 x i64> %a0, <i64 -7, i64 -7>
  %v2 = select <2 x i1> %cmp, <2 x i64> %v1, <2 x i64> <i64 -1, i64 -1>
  ret <2 x i64> %v2
}

define <vscale x 2 x i64> @vselect_add_const_2_nxv2i64(<vscale x 2 x i64> %a0) {
; CHECK-LABEL: vselect_add_const_2_nxv2i64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli a0, zero, e64, m2, ta, mu
; CHECK-NEXT:    vsaddu.vi v8, v8, 6
; CHECK-NEXT:    ret
  %cm1 = insertelement <vscale x 2 x i64> poison, i64 6, i32 0
  %splatcm1 = shufflevector <vscale x 2 x i64> %cm1, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %nc = insertelement <vscale x 2 x i64> poison, i64 -7, i32 0
  %splatnc = shufflevector <vscale x 2 x i64> %nc, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %v1 = add <vscale x 2 x i64> %a0, %splatcm1
  %cmp = icmp ule <vscale x 2 x i64> %a0, %splatnc
  %allones = insertelement <vscale x 2 x i64> poison, i64 -1, i32 0
  %splatallones = shufflevector <vscale x 2 x i64> %allones, <vscale x 2 x i64> poison, <vscale x 2 x i32> zeroinitializer
  %v2 = select <vscale x 2 x i1> %cmp, <vscale x 2 x i64> %v1, <vscale x 2 x i64> %splatallones
  ret <vscale x 2 x i64> %v2
}

declare <2 x i64> @llvm.umin.v2i64(<2 x i64>, <2 x i64>)
declare <2 x i64> @llvm.umax.v2i64(<2 x i64>, <2 x i64>)
declare <vscale x 2 x i64> @llvm.umin.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i64>)
declare <vscale x 2 x i64> @llvm.umax.nxv2i64(<vscale x 2 x i64>, <vscale x 2 x i64>)
