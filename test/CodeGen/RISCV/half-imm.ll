; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+zfh -verify-machineinstrs \
; RUN:   -target-abi ilp32f < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+zfh -verify-machineinstrs \
; RUN:   -target-abi lp64f < %s | FileCheck %s

; TODO: constant pool shouldn't be necessary for RV32IZfh and RV64IZfh
define half @half_imm() nounwind {
; CHECK-LABEL: half_imm:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(.LCPI0_0)
; CHECK-NEXT:    flh fa0, %lo(.LCPI0_0)(a0)
; CHECK-NEXT:    ret
  ret half 3.0
}

define half @half_imm_op(half %a) nounwind {
; CHECK-LABEL: half_imm_op:
; CHECK:       # %bb.0:
; CHECK-NEXT:    lui a0, %hi(.LCPI1_0)
; CHECK-NEXT:    flh ft0, %lo(.LCPI1_0)(a0)
; CHECK-NEXT:    fadd.h fa0, fa0, ft0
; CHECK-NEXT:    ret
  %1 = fadd half %a, 1.0
  ret half %1
}
