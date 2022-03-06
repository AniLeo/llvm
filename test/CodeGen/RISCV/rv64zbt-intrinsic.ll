; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zbt -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64ZBT

declare i32 @llvm.riscv.fsl.i32(i32, i32, i32)

define i32 @fsl_i32(i32 %a, i32 %b, i32 %c) nounwind {
; RV64ZBT-LABEL: fsl_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fslw a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %1 = call i32 @llvm.riscv.fsl.i32(i32 %a, i32 %b, i32 %c)
  ret i32 %1
}

define i32 @fsl_i32_demandedbits(i32 %a, i32 %b, i32 %c) nounwind {
; RV64ZBT-LABEL: fsl_i32_demandedbits:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a1, a1, 31
; RV64ZBT-NEXT:    fslw a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %bmask = and i32 %b, 95
  %1 = call i32 @llvm.riscv.fsl.i32(i32 %a, i32 %bmask, i32 %c)
  ret i32 %1
}

declare i32 @llvm.riscv.fsr.i32(i32, i32, i32)

define i32 @fsr_i32(i32 %a, i32 %b, i32 %c) nounwind {
; RV64ZBT-LABEL: fsr_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsrw a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %1 = call i32 @llvm.riscv.fsr.i32(i32 %a, i32 %b, i32 %c)
  ret i32 %1
}

define i32 @fsr_i32_demandedbits(i32 %a, i32 %b, i32 %c) nounwind {
; RV64ZBT-LABEL: fsr_i32_demandedbits:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a1, a1, 31
; RV64ZBT-NEXT:    fsrw a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %bmask = and i32 %b, 95
  %1 = call i32 @llvm.riscv.fsr.i32(i32 %a, i32 %bmask, i32 %c)
  ret i32 %1
}

define i32 @fsli_i32(i32 %a, i32 %b) nounwind {
; RV64ZBT-LABEL: fsli_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsriw a0, a1, a0, 27
; RV64ZBT-NEXT:    ret
  %1 = call i32 @llvm.riscv.fsl.i32(i32 %a, i32 %b, i32 5)
  ret i32 %1
}

define i32 @fsri_i32(i32 %a, i32 %b) nounwind {
; RV64ZBT-LABEL: fsri_i32:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsriw a0, a0, a1, 15
; RV64ZBT-NEXT:    ret
  %1 = call i32 @llvm.riscv.fsr.i32(i32 %a, i32 %b, i32 15)
  ret i32 %1
}

declare i64 @llvm.riscv.fsl.i64(i64, i64, i64)

define i64 @fsl_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV64ZBT-LABEL: fsl_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsl a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %1 = call i64 @llvm.riscv.fsl.i64(i64 %a, i64 %b, i64 %c)
  ret i64 %1
}

define i64 @fsl_i64_demandedbits(i64 %a, i64 %b, i64 %c) nounwind {
; RV64ZBT-LABEL: fsl_i64_demandedbits:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a1, a1, 63
; RV64ZBT-NEXT:    fsl a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %bmask = and i64 %b, 191
  %1 = call i64 @llvm.riscv.fsl.i64(i64 %a, i64 %bmask, i64 %c)
  ret i64 %1
}

declare i64 @llvm.riscv.fsr.i64(i64, i64, i64)

define i64 @fsr_i64(i64 %a, i64 %b, i64 %c) nounwind {
; RV64ZBT-LABEL: fsr_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsr a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %1 = call i64 @llvm.riscv.fsr.i64(i64 %a, i64 %b, i64 %c)
  ret i64 %1
}

define i64 @fsr_i64_demandedbits(i64 %a, i64 %b, i64 %c) nounwind {
; RV64ZBT-LABEL: fsr_i64_demandedbits:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    andi a1, a1, 63
; RV64ZBT-NEXT:    fsr a0, a0, a1, a2
; RV64ZBT-NEXT:    ret
  %bmask = and i64 %b, 191
  %1 = call i64 @llvm.riscv.fsr.i64(i64 %a, i64 %bmask, i64 %c)
  ret i64 %1
}

define i64 @fsli_i64(i64 %a, i64 %b) nounwind {
; RV64ZBT-LABEL: fsli_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsri a0, a1, a0, 49
; RV64ZBT-NEXT:    ret
  %1 = call i64 @llvm.riscv.fsl.i64(i64 %a, i64 %b, i64 15)
  ret i64 %1
}

define i64 @fsri_i64(i64 %a, i64 %b) nounwind {
; RV64ZBT-LABEL: fsri_i64:
; RV64ZBT:       # %bb.0:
; RV64ZBT-NEXT:    fsri a0, a0, a1, 5
; RV64ZBT-NEXT:    ret
  %1 = call i64 @llvm.riscv.fsr.i64(i64 %a, i64 %b, i64 5)
  ret i64 %1
}
