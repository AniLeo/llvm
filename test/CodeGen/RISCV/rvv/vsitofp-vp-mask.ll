; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+m,+v,+zfh,+experimental-zvfh < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+m,+v,+zfh,+experimental-zvfh < %s | FileCheck %s

declare <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i1(<vscale x 2 x i1>, <vscale x 2 x i1>, i32)

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i1(<vscale x 2 x i1> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vmerge.vim v9, v9, -1, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vfcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i1(<vscale x 2 x i1> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x half> %v
}

define <vscale x 2 x half> @vsitofp_nxv2f16_nxv2i1_unmasked(<vscale x 2 x i1> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f16_nxv2i1_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e16, mf2, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, -1, v0
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x half> @llvm.vp.sitofp.nxv2f16.nxv2i1(<vscale x 2 x i1> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x half> %v
}

declare <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i1(<vscale x 2 x i1>, <vscale x 2 x i1>, i32)

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i1(<vscale x 2 x i1> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.i v9, 0
; CHECK-NEXT:    vmerge.vim v9, v9, -1, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vfcvt.f.x.v v8, v9, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i1(<vscale x 2 x i1> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x float> %v
}

define <vscale x 2 x float> @vsitofp_nxv2f32_nxv2i1_unmasked(<vscale x 2 x i1> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f32_nxv2i1_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e32, m1, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, -1, v0
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x float> @llvm.vp.sitofp.nxv2f32.nxv2i1(<vscale x 2 x i1> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x float> %v
}

declare <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i1(<vscale x 2 x i1>, <vscale x 2 x i1>, i32)

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i1(<vscale x 2 x i1> %va, <vscale x 2 x i1> %m, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vmv.v.i v10, 0
; CHECK-NEXT:    vmerge.vim v10, v10, -1, v0
; CHECK-NEXT:    vmv1r.v v0, v8
; CHECK-NEXT:    vfcvt.f.x.v v8, v10, v0.t
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i1(<vscale x 2 x i1> %va, <vscale x 2 x i1> %m, i32 %evl)
  ret <vscale x 2 x double> %v
}

define <vscale x 2 x double> @vsitofp_nxv2f64_nxv2i1_unmasked(<vscale x 2 x i1> %va, i32 zeroext %evl) {
; CHECK-LABEL: vsitofp_nxv2f64_nxv2i1_unmasked:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vsetvli zero, a0, e64, m2, ta, mu
; CHECK-NEXT:    vmv.v.i v8, 0
; CHECK-NEXT:    vmerge.vim v8, v8, -1, v0
; CHECK-NEXT:    vfcvt.f.x.v v8, v8
; CHECK-NEXT:    ret
  %v = call <vscale x 2 x double> @llvm.vp.sitofp.nxv2f64.nxv2i1(<vscale x 2 x i1> %va, <vscale x 2 x i1> shufflevector (<vscale x 2 x i1> insertelement (<vscale x 2 x i1> undef, i1 true, i32 0), <vscale x 2 x i1> undef, <vscale x 2 x i32> zeroinitializer), i32 %evl)
  ret <vscale x 2 x double> %v
}
