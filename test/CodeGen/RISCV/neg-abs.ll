; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -verify-machineinstrs -mtriple=riscv32-unknown-unknown | FileCheck %s --check-prefix=RV32
; RUN: llc < %s -verify-machineinstrs -mtriple=riscv64-unknown-unknown | FileCheck %s --check-prefix=RV64

declare i32 @llvm.abs.i32(i32, i1 immarg)
declare i64 @llvm.abs.i64(i64, i1 immarg)

define i32 @neg_abs32(i32 %x) {
; RV32-LABEL: neg_abs32:
; RV32:       # %bb.0:
; RV32-NEXT:    srai a1, a0, 31
; RV32-NEXT:    xor a0, a0, a1
; RV32-NEXT:    sub a0, a1, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: neg_abs32:
; RV64:       # %bb.0:
; RV64-NEXT:    sraiw a1, a0, 31
; RV64-NEXT:    xor a0, a0, a1
; RV64-NEXT:    subw a0, a1, a0
; RV64-NEXT:    ret
  %abs = tail call i32 @llvm.abs.i32(i32 %x, i1 true)
  %neg = sub nsw i32 0, %abs
  ret i32 %neg
}

define i64 @neg_abs64(i64 %x) {
; RV32-LABEL: neg_abs64:
; RV32:       # %bb.0:
; RV32-NEXT:    srai a2, a1, 31
; RV32-NEXT:    xor a0, a0, a2
; RV32-NEXT:    sltu a3, a2, a0
; RV32-NEXT:    xor a1, a1, a2
; RV32-NEXT:    sub a1, a2, a1
; RV32-NEXT:    sub a1, a1, a3
; RV32-NEXT:    sub a0, a2, a0
; RV32-NEXT:    ret
;
; RV64-LABEL: neg_abs64:
; RV64:       # %bb.0:
; RV64-NEXT:    srai a1, a0, 63
; RV64-NEXT:    xor a0, a0, a1
; RV64-NEXT:    sub a0, a1, a0
; RV64-NEXT:    ret
  %abs = tail call i64 @llvm.abs.i64(i64 %x, i1 true)
  %neg = sub nsw i64 0, %abs
  ret i64 %neg
}
