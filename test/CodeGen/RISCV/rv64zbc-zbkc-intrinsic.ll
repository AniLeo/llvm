; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+zbc -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ZBC-ZBKC
; RUN: llc -mtriple=riscv64 -mattr=+zbkc -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ZBC-ZBKC

declare i64 @llvm.riscv.clmul.i64(i64 %a, i64 %b)

define i64 @clmul64(i64 %a, i64 %b) nounwind {
; RV64ZBC-ZBKC-LABEL: clmul64:
; RV64ZBC-ZBKC:       # %bb.0:
; RV64ZBC-ZBKC-NEXT:    clmul a0, a0, a1
; RV64ZBC-ZBKC-NEXT:    ret
  %tmp = call i64 @llvm.riscv.clmul.i64(i64 %a, i64 %b)
 ret i64 %tmp
}

declare i64 @llvm.riscv.clmulh.i64(i64 %a, i64 %b)

define i64 @clmul64h(i64 %a, i64 %b) nounwind {
; RV64ZBC-ZBKC-LABEL: clmul64h:
; RV64ZBC-ZBKC:       # %bb.0:
; RV64ZBC-ZBKC-NEXT:    clmulh a0, a0, a1
; RV64ZBC-ZBKC-NEXT:    ret
  %tmp = call i64 @llvm.riscv.clmulh.i64(i64 %a, i64 %b)
 ret i64 %tmp
}

