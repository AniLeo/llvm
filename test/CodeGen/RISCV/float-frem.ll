; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IF %s
; RUN: llc -mtriple=riscv64 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64IF %s

define float @frem_f32(float %a, float %b) nounwind {
; RV32IF-LABEL: frem_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IF-NEXT:    call fmodf@plt
; RV32IF-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: frem_f32:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    addi sp, sp, -16
; RV64IF-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IF-NEXT:    call fmodf@plt
; RV64IF-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IF-NEXT:    addi sp, sp, 16
; RV64IF-NEXT:    ret
  %1 = frem float %a, %b
  ret float %1
}
