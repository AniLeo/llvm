; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zve64d,+f,+d,+zfh \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

declare {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.nxv16i16(i16* , i64)
declare {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.mask.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i1>, i64, i64)

define void @test_vlseg2ff_dead_value(i16* %base, i64 %vl, i64* %outvl) {
; CHECK-LABEL: test_vlseg2ff_dead_value:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e16, m4, ta, mu
; CHECK-NEXT:    vlseg2e16ff.v v8, (a0)
; CHECK-NEXT:    csrr a0, vl
; CHECK-NEXT:    sd a0, 0(a2)
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.nxv16i16(i16* %base, i64 %vl)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} %0, 2
  store i64 %1, i64* %outvl
  ret void
}

define void @test_vlseg2ff_mask_dead_value(<vscale x 16 x i16> %val, i16* %base, i64 %vl, <vscale x 16 x i1> %mask, i64* %outvl) {
; CHECK-LABEL: test_vlseg2ff_mask_dead_value:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    # kill: def $v8m4 killed $v8m4 def $v8m4_v12m4
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetvli zero, a1, e16, m4, ta, mu
; CHECK-NEXT:    vlseg2e16ff.v v8, (a0), v0.t
; CHECK-NEXT:    csrr a0, vl
; CHECK-NEXT:    sd a0, 0(a2)
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.mask.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i1> %mask, i64 %vl, i64 1)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} %0, 2
  store i64 %1, i64* %outvl
  ret void
}

define <vscale x 16 x i16> @test_vlseg2ff_dead_vl(i16* %base, i64 %vl) {
; CHECK-LABEL: test_vlseg2ff_dead_vl:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e16, m4, ta, mu
; CHECK-NEXT:    vlseg2e16ff.v v4, (a0)
; CHECK-NEXT:    # kill: def $v8m4 killed $v8m4 killed $v4m4_v8m4
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.nxv16i16(i16* %base, i64 %vl)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} %0, 1
  ret <vscale x 16 x i16> %1
}

define <vscale x 16 x i16> @test_vlseg2ff_mask_dead_vl(<vscale x 16 x i16> %val, i16* %base, i64 %vl, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vlseg2ff_mask_dead_vl:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v4, v8
; CHECK-NEXT:    vsetvli zero, a1, e16, m4, ta, mu
; CHECK-NEXT:    vlseg2e16ff.v v4, (a0), v0.t
; CHECK-NEXT:    # kill: def $v8m4 killed $v8m4 killed $v4m4_v8m4
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.mask.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i1> %mask, i64 %vl, i64 1)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} %0, 1
  ret <vscale x 16 x i16> %1
}

define void @test_vlseg2ff_dead_all(i16* %base, i64 %vl) {
; CHECK-LABEL: test_vlseg2ff_dead_all:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli zero, a1, e16, m4, ta, mu
; CHECK-NEXT:    vlseg2e16ff.v v8, (a0)
; CHECK-NEXT:    ret
entry:
  tail call {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.nxv16i16(i16* %base, i64 %vl)
  ret void
}

define void @test_vlseg2ff_mask_dead_all(<vscale x 16 x i16> %val, i16* %base, i64 %vl, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vlseg2ff_mask_dead_all:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    # kill: def $v8m4 killed $v8m4 def $v8m4_v12m4
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetvli zero, a1, e16, m4, ta, mu
; CHECK-NEXT:    vlseg2e16ff.v v8, (a0), v0.t
; CHECK-NEXT:    ret
entry:
  tail call {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.mask.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i1> %mask, i64 %vl, i64 1)
  ret void
}
