; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I
; RUN: llc -mtriple=riscv32 -verify-machineinstrs -mattr=+f -mattr=+d \
; RUN:   -target-abi ilp32d < %s | FileCheck %s -check-prefix=RV32IFD
; RUN: llc -mtriple=riscv64 -verify-machineinstrs -mattr=+f -mattr=+d \
; RUN:   -target-abi lp64d < %s | FileCheck %s -check-prefix=RV64IFD

; Test fcopysign scenarios where the sign argument is casted to the type of the
; magnitude argument. Those casts can be folded away by the DAGCombiner.

declare double @llvm.copysign.f64(double, double)
declare float @llvm.copysign.f32(float, float)

define double @fold_promote(double %a, float %b) nounwind {
; RV32I-LABEL: fold_promote:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a3, 524288
; RV32I-NEXT:    and a2, a2, a3
; RV32I-NEXT:    addi a3, a3, -1
; RV32I-NEXT:    and a1, a1, a3
; RV32I-NEXT:    or a1, a1, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fold_promote:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi a2, zero, -1
; RV64I-NEXT:    slli a2, a2, 63
; RV64I-NEXT:    addi a2, a2, -1
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    slli a2, a2, 31
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    slli a1, a1, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV32IFD-LABEL: fold_promote:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.d.s ft0, fa1
; RV32IFD-NEXT:    fsgnj.d fa0, fa0, ft0
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fold_promote:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.d.s ft0, fa1
; RV64IFD-NEXT:    fsgnj.d fa0, fa0, ft0
; RV64IFD-NEXT:    ret
  %c = fpext float %b to double
  %t = call double @llvm.copysign.f64(double %a, double %c)
  ret double %t
}

define float @fold_demote(float %a, double %b) nounwind {
; RV32I-LABEL: fold_demote:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    and a2, a2, a1
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    or a0, a0, a2
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fold_demote:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    addiw a2, a2, -1
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    addi a2, zero, -1
; RV64I-NEXT:    slli a2, a2, 63
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    srli a1, a1, 32
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
;
; RV32IFD-LABEL: fold_demote:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    fcvt.s.d ft0, fa1
; RV32IFD-NEXT:    fsgnj.s fa0, fa0, ft0
; RV32IFD-NEXT:    ret
;
; RV64IFD-LABEL: fold_demote:
; RV64IFD:       # %bb.0:
; RV64IFD-NEXT:    fcvt.s.d ft0, fa1
; RV64IFD-NEXT:    fsgnj.s fa0, fa0, ft0
; RV64IFD-NEXT:    ret
  %c = fptrunc double %b to float
  %t = call float @llvm.copysign.f32(float %a, float %c)
  ret float %t
}
