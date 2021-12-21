; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -march=ve -mattr=+vpu | FileCheck %s

declare <256 x i32> @llvm.vp.udiv.v256i32(<256 x i32>, <256 x i32>, <256 x i1>, i32)

define fastcc <256 x i32> @test_vp_udiv_v256i32_vv(<256 x i32> %i0, <256 x i32> %i1, <256 x i1> %m, i32 %n) {
; CHECK-LABEL: test_vp_udiv_v256i32_vv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vdivu.w %v0, %v0, %v1, %vm1
; CHECK-NEXT:    b.l.t (, %s10)
  %r0 = call <256 x i32> @llvm.vp.udiv.v256i32(<256 x i32> %i0, <256 x i32> %i1, <256 x i1> %m, i32 %n)
  ret <256 x i32> %r0
}

define fastcc <256 x i32> @test_vp_udiv_v256i32_rv(i32 %s0, <256 x i32> %i1, <256 x i1> %m, i32 %n) {
; CHECK-LABEL: test_vp_udiv_v256i32_rv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vdivu.w %v0, %s0, %v0, %vm1
; CHECK-NEXT:    b.l.t (, %s10)
  %xins = insertelement <256 x i32> undef, i32 %s0, i32 0
  %i0 = shufflevector <256 x i32> %xins, <256 x i32> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x i32> @llvm.vp.udiv.v256i32(<256 x i32> %i0, <256 x i32> %i1, <256 x i1> %m, i32 %n)
  ret <256 x i32> %r0
}

define fastcc <256 x i32> @test_vp_udiv_v256i32_vr(<256 x i32> %i0, i32 %s1, <256 x i1> %m, i32 %n) {
; CHECK-LABEL: test_vp_udiv_v256i32_vr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vdivu.w %v0, %v0, %s0, %vm1
; CHECK-NEXT:    b.l.t (, %s10)
  %yins = insertelement <256 x i32> undef, i32 %s1, i32 0
  %i1 = shufflevector <256 x i32> %yins, <256 x i32> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x i32> @llvm.vp.udiv.v256i32(<256 x i32> %i0, <256 x i32> %i1, <256 x i1> %m, i32 %n)
  ret <256 x i32> %r0
}


declare <256 x i64> @llvm.vp.udiv.v256i64(<256 x i64>, <256 x i64>, <256 x i1>, i32)

define fastcc <256 x i64> @test_vp_int_v256i64_vv(<256 x i64> %i0, <256 x i64> %i1, <256 x i1> %m, i32 %n) {
; CHECK-LABEL: test_vp_int_v256i64_vv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s0, %s0, (32)0
; CHECK-NEXT:    lvl %s0
; CHECK-NEXT:    vdivu.l %v0, %v0, %v1, %vm1
; CHECK-NEXT:    b.l.t (, %s10)
  %r0 = call <256 x i64> @llvm.vp.udiv.v256i64(<256 x i64> %i0, <256 x i64> %i1, <256 x i1> %m, i32 %n)
  ret <256 x i64> %r0
}

define fastcc <256 x i64> @test_vp_udiv_v256i64_rv(i64 %s0, <256 x i64> %i1, <256 x i1> %m, i32 %n) {
; CHECK-LABEL: test_vp_udiv_v256i64_rv:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vdivu.l %v0, %s0, %v0, %vm1
; CHECK-NEXT:    b.l.t (, %s10)
  %xins = insertelement <256 x i64> undef, i64 %s0, i32 0
  %i0 = shufflevector <256 x i64> %xins, <256 x i64> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x i64> @llvm.vp.udiv.v256i64(<256 x i64> %i0, <256 x i64> %i1, <256 x i1> %m, i32 %n)
  ret <256 x i64> %r0
}

define fastcc <256 x i64> @test_vp_udiv_v256i64_vr(<256 x i64> %i0, i64 %s1, <256 x i1> %m, i32 %n) {
; CHECK-LABEL: test_vp_udiv_v256i64_vr:
; CHECK:       # %bb.0:
; CHECK-NEXT:    and %s1, %s1, (32)0
; CHECK-NEXT:    lvl %s1
; CHECK-NEXT:    vdivu.l %v0, %v0, %s0, %vm1
; CHECK-NEXT:    b.l.t (, %s10)
  %yins = insertelement <256 x i64> undef, i64 %s1, i32 0
  %i1 = shufflevector <256 x i64> %yins, <256 x i64> undef, <256 x i32> zeroinitializer
  %r0 = call <256 x i64> @llvm.vp.udiv.v256i64(<256 x i64> %i0, <256 x i64> %i1, <256 x i1> %m, i32 %n)
  ret <256 x i64> %r0
}
