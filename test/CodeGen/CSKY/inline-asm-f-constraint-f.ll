; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=csky -mattr=+fpuv2_sf,+hard-float -float-abi=hard -verify-machineinstrs -csky-no-aliases < %s \
; RUN:   | FileCheck -check-prefix=CSKYF %s

@gf = external global float

define float @constraint_f_float(float %a) nounwind {
; CSKYF-LABEL: constraint_f_float:
; CSKYF:       # %bb.0:
; CSKYF-NEXT:    subi16 sp, sp, 4
; CSKYF-NEXT:    lrw32 a0, [.LCPI0_0]
; CSKYF-NEXT:    flds vr1, (a0, 0)
; CSKYF-NEXT:    #APP
; CSKYF-NEXT:    fadds vr0, vr0, vr1
; CSKYF-NEXT:    #NO_APP
; CSKYF-NEXT:    addi16 sp, sp, 4
; CSKYF-NEXT:    rts16
; CSKYF-NEXT:    .p2align 1
; CSKYF-NEXT:  # %bb.1:
; CSKYF-NEXT:    .p2align 2
; CSKYF-NEXT:  .LCPI0_0:
; CSKYF-NEXT:    .long gf
  %1 = load float, float* @gf
  %2 = tail call float asm "fadds $0, $1, $2", "=v,v,v"(float %a, float %1)
  ret float %2
}

define float @constraint_f_float_abi_name(float %a) nounwind {
; CSKYF-LABEL: constraint_f_float_abi_name:
; CSKYF:       # %bb.0:
; CSKYF-NEXT:    subi16 sp, sp, 4
; CSKYF-NEXT:    lrw32 a0, [.LCPI1_0]
; CSKYF-NEXT:    flds vr2, (a0, 0)
; CSKYF-NEXT:    fmovs vr1, vr0
; CSKYF-NEXT:    #APP
; CSKYF-NEXT:    fadds vr0, vr1, vr2
; CSKYF-NEXT:    #NO_APP
; CSKYF-NEXT:    addi16 sp, sp, 4
; CSKYF-NEXT:    rts16
; CSKYF-NEXT:    .p2align 1
; CSKYF-NEXT:  # %bb.1:
; CSKYF-NEXT:    .p2align 2
; CSKYF-NEXT:  .LCPI1_0:
; CSKYF-NEXT:    .long gf

  %1 = load float, float* @gf
  %2 = tail call float asm "fadds $0, $1, $2", "={fr0},{fr1},{fr2}"(float %a, float %1)
  ret float %2
}
