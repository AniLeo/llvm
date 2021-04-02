; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-b -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32IB
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zbb -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32IBB

declare i32 @llvm.riscv.orc.b.i32(i32)

define i32 @orcb(i32 %a) nounwind {
; RV32IB-LABEL: orcb:
; RV32IB:       # %bb.0:
; RV32IB-NEXT:    orc.b a0, a0
; RV32IB-NEXT:    ret
;
; RV32IBB-LABEL: orcb:
; RV32IBB:       # %bb.0:
; RV32IBB-NEXT:    orc.b a0, a0
; RV32IBB-NEXT:    ret
  %tmp = call i32 @llvm.riscv.orc.b.i32(i32 %a)
 ret i32 %tmp
}
