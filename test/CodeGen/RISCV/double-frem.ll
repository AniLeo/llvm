; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IFD %s
; RUN: llc -mtriple=riscv64 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64IFD %s

define double @frem_f64(double %a, double %b) nounwind {
; RV32IFD-LABEL: frem_f64:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    call fmod@plt
; RV32IFD-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IFD-NEXT:    addi sp, sp, 16
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: frem_f64:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    addi sp, sp, -16
; RV64IFD-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IFD-NEXT:    call fmod@plt
; RV64IFD-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IFD-NEXT:    addi sp, sp, 16
; RV64IFD-NEXT:    ret
  %1 = frem double %a, %b
  ret double %1
}
