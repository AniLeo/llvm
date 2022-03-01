; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+zbc -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ZBC

declare i64 @llvm.riscv.clmulr.i64(i64 %a, i64 %b)

define i64 @clmul64r(i64 %a, i64 %b) nounwind {
; RV64ZBC-LABEL: clmul64r:
; RV64ZBC:       # %bb.0:
; RV64ZBC-NEXT:    clmulr a0, a0, a1
; RV64ZBC-NEXT:    ret
  %tmp = call i64 @llvm.riscv.clmulr.i64(i64 %a, i64 %b)
  ret i64 %tmp
}
