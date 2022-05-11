; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+zve32x \
; RUN:     -verify-machineinstrs < %s | FileCheck %s

; Make sure we don't select a 0 vl to X0 in the custom isel handlers we use
; for these intrinsics.

declare {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vlseg2.nxv16i16(i16* , i64)
declare {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vlseg2.mask.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i1>, i64, i64)

define <vscale x 16 x i16> @test_vlseg2_mask_nxv16i16(i16* %base, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vlseg2_mask_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vlseg2e16.v v4, (a0)
; CHECK-NEXT:    vmv4r.v v8, v4
; CHECK-NEXT:    vlseg2e16.v v4, (a0), v0.t
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vlseg2.nxv16i16(i16* %base, i64 0)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>} %0, 0
  %2 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vlseg2.mask.nxv16i16(<vscale x 16 x i16> %1,<vscale x 16 x i16> %1, i16* %base, <vscale x 16 x i1> %mask, i64 0, i64 1)
  %3 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>} %2, 1
  ret <vscale x 16 x i16> %3
}

declare {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vlsseg2.nxv16i16(i16*, i64, i64)
declare {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vlsseg2.mask.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, i64, <vscale x 16 x i1>, i64, i64)

define <vscale x 16 x i16> @test_vlsseg2_mask_nxv16i16(i16* %base, i64 %offset, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vlsseg2_mask_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vlsseg2e16.v v4, (a0), a1
; CHECK-NEXT:    vmv4r.v v8, v4
; CHECK-NEXT:    vlsseg2e16.v v4, (a0), a1, v0.t
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vlsseg2.nxv16i16(i16* %base, i64 %offset, i64 0)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>} %0, 0
  %2 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vlsseg2.mask.nxv16i16(<vscale x 16 x i16> %1,<vscale x 16 x i16> %1, i16* %base, i64 %offset, <vscale x 16 x i1> %mask, i64 0, i64 1)
  %3 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>} %2, 1
  ret <vscale x 16 x i16> %3
}
declare {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vloxseg2.nxv16i16.nxv16i16(i16*, <vscale x 16 x i16>, i64)
declare {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vloxseg2.mask.nxv16i16.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i16>, <vscale x 16 x i1>, i64, i64)

define <vscale x 16 x i16> @test_vloxseg2_mask_nxv16i16_nxv16i16(i16* %base, <vscale x 16 x i16> %index, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vloxseg2_mask_nxv16i16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vloxseg2ei16.v v12, (a0), v8
; CHECK-NEXT:    vmv4r.v v16, v12
; CHECK-NEXT:    vloxseg2ei16.v v12, (a0), v8, v0.t
; CHECK-NEXT:    vmv4r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vloxseg2.nxv16i16.nxv16i16(i16* %base, <vscale x 16 x i16> %index, i64 0)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>} %0, 0
  %2 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vloxseg2.mask.nxv16i16.nxv16i16(<vscale x 16 x i16> %1,<vscale x 16 x i16> %1, i16* %base, <vscale x 16 x i16> %index, <vscale x 16 x i1> %mask, i64 0, i64 1)
  %3 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>} %2, 1
  ret <vscale x 16 x i16> %3
}

declare {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vluxseg2.nxv16i16.nxv16i16(i16*, <vscale x 16 x i16>, i64)
declare {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vluxseg2.mask.nxv16i16.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i16>, <vscale x 16 x i1>, i64, i64)

define <vscale x 16 x i16> @test_vluxseg2_mask_nxv16i16_nxv16i16(i16* %base, <vscale x 16 x i16> %index, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vluxseg2_mask_nxv16i16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vluxseg2ei16.v v12, (a0), v8
; CHECK-NEXT:    vmv4r.v v16, v12
; CHECK-NEXT:    vluxseg2ei16.v v12, (a0), v8, v0.t
; CHECK-NEXT:    vmv4r.v v8, v16
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vluxseg2.nxv16i16.nxv16i16(i16* %base, <vscale x 16 x i16> %index, i64 0)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>} %0, 0
  %2 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>} @llvm.riscv.vluxseg2.mask.nxv16i16.nxv16i16(<vscale x 16 x i16> %1,<vscale x 16 x i16> %1, i16* %base, <vscale x 16 x i16> %index, <vscale x 16 x i1> %mask, i64 0, i64 1)
  %3 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>} %2, 1
  ret <vscale x 16 x i16> %3
}

declare {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.nxv16i16(i16* , i64)
declare {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.mask.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i1>, i64, i64)

define <vscale x 16 x i16> @test_vlseg2ff_nxv16i16(i16* %base, i64* %outvl) {
; CHECK-LABEL: test_vlseg2ff_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vlseg2e16ff.v v4, (a0)
; CHECK-NEXT:    csrr a0, vl
; CHECK-NEXT:    sd a0, 0(a1)
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.nxv16i16(i16* %base, i64 0)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} %0, 1
  %2 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} %0, 2
  store i64 %2, i64* %outvl
  ret <vscale x 16 x i16> %1
}

define <vscale x 16 x i16> @test_vlseg2ff_mask_nxv16i16(<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i1> %mask, i64* %outvl) {
; CHECK-LABEL: test_vlseg2ff_mask_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v4, v8
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vlseg2e16ff.v v4, (a0), v0.t
; CHECK-NEXT:    csrr a0, vl
; CHECK-NEXT:    sd a0, 0(a1)
; CHECK-NEXT:    ret
entry:
  %0 = tail call {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} @llvm.riscv.vlseg2ff.mask.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i1> %mask, i64 0, i64 1)
  %1 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} %0, 1
  %2 = extractvalue {<vscale x 16 x i16>,<vscale x 16 x i16>, i64} %0, 2
  store i64 %2, i64* %outvl
  ret <vscale x 16 x i16> %1
}

declare void @llvm.riscv.vsseg2.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16* , i64)
declare void @llvm.riscv.vsseg2.mask.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i1>, i64)

define void @test_vsseg2_nxv16i16(<vscale x 16 x i16> %val, i16* %base) {
; CHECK-LABEL: test_vsseg2_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vsseg2e16.v v8, (a0)
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.riscv.vsseg2.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, i64 0)
  ret void
}

define void @test_vsseg2_mask_nxv16i16(<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vsseg2_mask_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vsseg2e16.v v8, (a0), v0.t
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.riscv.vsseg2.mask.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i1> %mask, i64 0)
  ret void
}

declare void @llvm.riscv.vssseg2.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, i64, i64)
declare void @llvm.riscv.vssseg2.mask.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, i64, <vscale x 16 x i1>, i64)

define void @test_vssseg2_nxv16i16(<vscale x 16 x i16> %val, i16* %base, i64 %offset) {
; CHECK-LABEL: test_vssseg2_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vssseg2e16.v v8, (a0), a1
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.riscv.vssseg2.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, i64 %offset, i64 0)
  ret void
}

define void @test_vssseg2_mask_nxv16i16(<vscale x 16 x i16> %val, i16* %base, i64 %offset, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vssseg2_mask_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vssseg2e16.v v8, (a0), a1, v0.t
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.riscv.vssseg2.mask.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, i64 %offset, <vscale x 16 x i1> %mask, i64 0)
  ret void
}

declare void @llvm.riscv.vsoxseg2.nxv16i16.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i16>, i64)
declare void @llvm.riscv.vsoxseg2.mask.nxv16i16.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i16>, <vscale x 16 x i1>, i64)

define void @test_vsoxseg2_nxv16i16_nxv16i16(<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i16> %index) {
; CHECK-LABEL: test_vsoxseg2_nxv16i16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v16, v12
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vsoxseg2ei16.v v8, (a0), v16
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.riscv.vsoxseg2.nxv16i16.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i16> %index, i64 0)
  ret void
}

define void @test_vsoxseg2_mask_nxv16i16_nxv16i16(<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i16> %index, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vsoxseg2_mask_nxv16i16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v16, v12
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vsoxseg2ei16.v v8, (a0), v16, v0.t
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.riscv.vsoxseg2.mask.nxv16i16.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i16> %index, <vscale x 16 x i1> %mask, i64 0)
  ret void
}

declare void @llvm.riscv.vsuxseg2.nxv16i16.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i16>, i64)
declare void @llvm.riscv.vsuxseg2.mask.nxv16i16.nxv16i16(<vscale x 16 x i16>,<vscale x 16 x i16>, i16*, <vscale x 16 x i16>, <vscale x 16 x i1>, i64)

define void @test_vsuxseg2_nxv16i16_nxv16i16(<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i16> %index) {
; CHECK-LABEL: test_vsuxseg2_nxv16i16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v16, v12
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vsuxseg2ei16.v v8, (a0), v16
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.riscv.vsuxseg2.nxv16i16.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i16> %index, i64 0)
  ret void
}

define void @test_vsuxseg2_mask_nxv16i16_nxv16i16(<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i16> %index, <vscale x 16 x i1> %mask) {
; CHECK-LABEL: test_vsuxseg2_mask_nxv16i16_nxv16i16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmv4r.v v16, v12
; CHECK-NEXT:    vmv4r.v v12, v8
; CHECK-NEXT:    vsetivli zero, 0, e16, m4, ta, mu
; CHECK-NEXT:    vsuxseg2ei16.v v8, (a0), v16, v0.t
; CHECK-NEXT:    ret
entry:
  tail call void @llvm.riscv.vsuxseg2.mask.nxv16i16.nxv16i16(<vscale x 16 x i16> %val,<vscale x 16 x i16> %val, i16* %base, <vscale x 16 x i16> %index, <vscale x 16 x i1> %mask, i64 0)
  ret void
}
