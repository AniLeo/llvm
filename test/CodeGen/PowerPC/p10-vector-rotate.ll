; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s -check-prefixes=CHECK,CHECK-LE

; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr < %s | \
; RUN:   FileCheck %s -check-prefixes=CHECK,CHECK-BE

; This test case aims to test the builtins for vector rotate instructions
; on Power10.


define <1 x i128> @test_vrlq(<1 x i128> %x, <1 x i128> %y) {
; CHECK-LABEL: test_vrlq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vrlq v2, v3, v2
; CHECK-NEXT:    blr
  %shl.i = shl <1 x i128> %y, %x
  %sub.i = sub <1 x i128> <i128 128>, %x
  %lshr.i = lshr <1 x i128> %y, %sub.i
  %tmp = or <1 x i128> %shl.i, %lshr.i
  ret <1 x i128> %tmp
}

define <1 x i128> @test_vrlq_cost_mult8(<1 x i128> %x) {
; CHECK-LE-LABEL: test_vrlq_cost_mult8:
; CHECK-LE:       # %bb.0:
; CHECK-LE-NEXT:    plxv v3, .LCPI1_0@PCREL(0), 1
; CHECK-LE-NEXT:    vrlq v2, v3, v2
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: test_vrlq_cost_mult8:
; CHECK-BE:       # %bb.0:
; CHECK-BE-NEXT:    addis r3, r2, .LCPI1_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI1_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r3)
; CHECK-BE-NEXT:    vrlq v2, v3, v2
; CHECK-BE-NEXT:    blr
  %shl.i = shl <1 x i128> <i128 16>, %x
  %sub.i = sub <1 x i128> <i128 128>, %x
  %lshr.i = lshr <1 x i128> <i128 16>, %sub.i
  %tmp = or <1 x i128> %shl.i, %lshr.i
  ret <1 x i128> %tmp
}

define <1 x i128> @test_vrlq_cost_non_mult8(<1 x i128> %x) {
; CHECK-LE-LABEL: test_vrlq_cost_non_mult8:
; CHECK-LE:       # %bb.0:
; CHECK-LE-NEXT:    plxv v3, .LCPI2_0@PCREL(0), 1
; CHECK-LE-NEXT:    vrlq v2, v3, v2
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: test_vrlq_cost_non_mult8:
; CHECK-BE:       # %bb.0:
; CHECK-BE-NEXT:    addis r3, r2, .LCPI2_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI2_0@toc@l
; CHECK-BE-NEXT:    lxv v3, 0(r3)
; CHECK-BE-NEXT:    vrlq v2, v3, v2
; CHECK-BE-NEXT:    blr
  %shl.i = shl <1 x i128> <i128 4>, %x
  %sub.i = sub <1 x i128> <i128 128>, %x
  %lshr.i = lshr <1 x i128> <i128 4>, %sub.i
  %tmp = or <1 x i128> %shl.i, %lshr.i
  ret <1 x i128> %tmp
}

; Function Attrs: nounwind readnone
define <1 x i128> @test_vrlqmi(<1 x i128> %a, <1 x i128> %b, <1 x i128> %c) {
; CHECK-LABEL: test_vrlqmi:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vrlqmi v3, v2, v4
; CHECK-NEXT:    vmr v2, v3
; CHECK-NEXT:    blr
entry:
  %tmp = tail call <1 x i128> @llvm.ppc.altivec.vrlqmi(<1 x i128> %a, <1 x i128> %c, <1 x i128> %b)
  ret <1 x i128> %tmp
}

; Function Attrs: nounwind readnone
define <1 x i128> @test_vrlqnm(<1 x i128> %a, <1 x i128> %b, <1 x i128> %c) {
; CHECK-LE-LABEL: test_vrlqnm:
; CHECK-LE:       # %bb.0: # %entry
; CHECK-LE-NEXT:    plxv v5, .LCPI4_0@PCREL(0), 1
; CHECK-LE-NEXT:    vperm v3, v4, v3, v5
; CHECK-LE-NEXT:    vrlqnm v2, v2, v3
; CHECK-LE-NEXT:    blr
;
; CHECK-BE-LABEL: test_vrlqnm:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    addis r3, r2, .LCPI4_0@toc@ha
; CHECK-BE-NEXT:    addi r3, r3, .LCPI4_0@toc@l
; CHECK-BE-NEXT:    lxv v5, 0(r3)
; CHECK-BE-NEXT:    vperm v3, v3, v4, v5
; CHECK-BE-NEXT:    vrlqnm v2, v2, v3
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast <1 x i128> %b to <16 x i8>
  %1 = bitcast <1 x i128> %c to <16 x i8>
  %shuffle.i = shufflevector <16 x i8> %0, <16 x i8> %1, <16 x i32> <i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 16, i32 0, i32 1, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef>
  %d = bitcast <16 x i8> %shuffle.i to <1 x i128>
  %tmp = tail call <1 x i128> @llvm.ppc.altivec.vrlqnm(<1 x i128> %a, <1 x i128> %d)
  ret <1 x i128> %tmp
}

; Function Attrs: nounwind readnone
declare <1 x i128> @llvm.ppc.altivec.vrlqmi(<1 x i128>, <1 x i128>, <1 x i128>)

; Function Attrs: nounwind readnone
declare <1 x i128> @llvm.ppc.altivec.vrlqnm(<1 x i128>, <1 x i128>)
