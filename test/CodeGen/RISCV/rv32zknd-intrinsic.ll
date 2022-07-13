; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+zknd -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32ZKND

declare i32 @llvm.riscv.aes32dsi(i32, i32, i8);

define i32 @aes32dsi(i32 %a, i32 %b) nounwind {
; RV32ZKND-LABEL: aes32dsi:
; RV32ZKND:       # %bb.0:
; RV32ZKND-NEXT:    aes32dsi a0, a0, a1, 0
; RV32ZKND-NEXT:    ret
    %val = call i32 @llvm.riscv.aes32dsi(i32 %a, i32 %b, i8 0)
    ret i32 %val
}

declare i32 @llvm.riscv.aes32dsmi(i32, i32, i8);

define i32 @aes32dsmi(i32 %a, i32 %b) nounwind {
; RV32ZKND-LABEL: aes32dsmi:
; RV32ZKND:       # %bb.0:
; RV32ZKND-NEXT:    aes32dsmi a0, a0, a1, 1
; RV32ZKND-NEXT:    ret
    %val = call i32 @llvm.riscv.aes32dsmi(i32 %a, i32 %b, i8 1)
    ret i32 %val
}
