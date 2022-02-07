; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=csky -mattr=+fpuv2_sf,+fpuv2_df,+hard-float -float-abi=hard  -verify-machineinstrs -csky-no-aliases < %s \
; RUN:   | FileCheck -check-prefix=CSKYIFD %s

; These test that we can use both the architectural names (r*) and the ABI names
; (a*, l* etc) to refer to registers in inline asm constraint lists. In each
; case, the named register should be used for the source register of the `addi`.
;
; The inline assembly will, by default, contain the ABI names for the registers.
;
; Parenthesised registers in comments are the other aliases for this register.

define double @explicit_register_fr0_d(double %a, double %b) nounwind {
; CSKYIFD-LABEL: explicit_register_fr0_d:
; CSKYIFD:       # %bb.0:
; CSKYIFD-NEXT:    subi16 sp, sp, 4
; CSKYIFD-NEXT:    fmovd vr0, vr1
; CSKYIFD-NEXT:    #APP
; CSKYIFD-NEXT:    faddd vr0, vr0, vr0
; CSKYIFD-NEXT:    #NO_APP
; CSKYIFD-NEXT:    addi16 sp, sp, 4
; CSKYIFD-NEXT:    rts16
  %1 = tail call double asm "faddd $0, $1, $2", "=v,{fr0},{fr0}"(double %a, double %b)
  ret double %1
}

define double @explicit_register_vr0_d(double %a, double %b) nounwind {
; CSKYIFD-LABEL: explicit_register_vr0_d:
; CSKYIFD:       # %bb.0:
; CSKYIFD-NEXT:    subi16 sp, sp, 4
; CSKYIFD-NEXT:    fmovd vr0, vr1
; CSKYIFD-NEXT:    #APP
; CSKYIFD-NEXT:    faddd vr0, vr0, vr0
; CSKYIFD-NEXT:    #NO_APP
; CSKYIFD-NEXT:    addi16 sp, sp, 4
; CSKYIFD-NEXT:    rts16
  %1 = tail call double asm "faddd $0, $1, $2", "=v,{vr0},{vr0}"(double %a, double %b)
  ret double %1
}

define float @explicit_register_fr0_s(float %a, float %b) nounwind {
; CSKYIFD-LABEL: explicit_register_fr0_s:
; CSKYIFD:       # %bb.0:
; CSKYIFD-NEXT:    subi16 sp, sp, 4
; CSKYIFD-NEXT:    fstod vr0, vr1
; CSKYIFD-NEXT:    #APP
; CSKYIFD-NEXT:    fadds vr0, vr0, vr0
; CSKYIFD-NEXT:    #NO_APP
; CSKYIFD-NEXT:    addi16 sp, sp, 4
; CSKYIFD-NEXT:    rts16
  %1 = tail call float asm "fadds $0, $1, $2", "=v,{fr0},{fr0}"(float %a, float %b)
  ret float %1
}

define float @explicit_register_vr0_s(float %a, float %b) nounwind {
; CSKYIFD-LABEL: explicit_register_vr0_s:
; CSKYIFD:       # %bb.0:
; CSKYIFD-NEXT:    subi16 sp, sp, 4
; CSKYIFD-NEXT:    fstod vr0, vr1
; CSKYIFD-NEXT:    #APP
; CSKYIFD-NEXT:    fadds vr0, vr0, vr0
; CSKYIFD-NEXT:    #NO_APP
; CSKYIFD-NEXT:    addi16 sp, sp, 4
; CSKYIFD-NEXT:    rts16
  %1 = tail call float asm "fadds $0, $1, $2", "=v,{vr0},{vr0}"(float %a, float %b)
  ret float %1
}
