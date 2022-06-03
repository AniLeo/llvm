; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d -verify-machineinstrs < %s \
; RUN:   -target-abi=ilp32d | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+d -verify-machineinstrs < %s \
; RUN:   -target-abi=lp64d | FileCheck %s

define double @select_fcmp_false(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_false:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:    ret
  %1 = fcmp false double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_oeq(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_oeq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    feq.d a0, fa0, fa1
; CHECK-NEXT:    bnez a0, .LBB1_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB1_2:
; CHECK-NEXT:    ret
  %1 = fcmp oeq double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_ogt(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_ogt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    flt.d a0, fa1, fa0
; CHECK-NEXT:    bnez a0, .LBB2_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB2_2:
; CHECK-NEXT:    ret
  %1 = fcmp ogt double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_oge(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_oge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fle.d a0, fa1, fa0
; CHECK-NEXT:    bnez a0, .LBB3_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB3_2:
; CHECK-NEXT:    ret
  %1 = fcmp oge double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_olt(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_olt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    flt.d a0, fa0, fa1
; CHECK-NEXT:    bnez a0, .LBB4_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB4_2:
; CHECK-NEXT:    ret
  %1 = fcmp olt double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_ole(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_ole:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fle.d a0, fa0, fa1
; CHECK-NEXT:    bnez a0, .LBB5_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB5_2:
; CHECK-NEXT:    ret
  %1 = fcmp ole double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_one(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_one:
; CHECK:       # %bb.0:
; CHECK-NEXT:    flt.d a0, fa0, fa1
; CHECK-NEXT:    flt.d a1, fa1, fa0
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    bnez a0, .LBB6_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB6_2:
; CHECK-NEXT:    ret
  %1 = fcmp one double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_ord(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_ord:
; CHECK:       # %bb.0:
; CHECK-NEXT:    feq.d a0, fa1, fa1
; CHECK-NEXT:    feq.d a1, fa0, fa0
; CHECK-NEXT:    and a0, a1, a0
; CHECK-NEXT:    bnez a0, .LBB7_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB7_2:
; CHECK-NEXT:    ret
  %1 = fcmp ord double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_ueq(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_ueq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    flt.d a0, fa0, fa1
; CHECK-NEXT:    flt.d a1, fa1, fa0
; CHECK-NEXT:    or a0, a1, a0
; CHECK-NEXT:    beqz a0, .LBB8_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB8_2:
; CHECK-NEXT:    ret
  %1 = fcmp ueq double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_ugt(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_ugt:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fle.d a0, fa0, fa1
; CHECK-NEXT:    beqz a0, .LBB9_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB9_2:
; CHECK-NEXT:    ret
  %1 = fcmp ugt double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_uge(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_uge:
; CHECK:       # %bb.0:
; CHECK-NEXT:    flt.d a0, fa0, fa1
; CHECK-NEXT:    beqz a0, .LBB10_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB10_2:
; CHECK-NEXT:    ret
  %1 = fcmp uge double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_ult(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_ult:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fle.d a0, fa1, fa0
; CHECK-NEXT:    beqz a0, .LBB11_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB11_2:
; CHECK-NEXT:    ret
  %1 = fcmp ult double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_ule(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_ule:
; CHECK:       # %bb.0:
; CHECK-NEXT:    flt.d a0, fa1, fa0
; CHECK-NEXT:    beqz a0, .LBB12_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB12_2:
; CHECK-NEXT:    ret
  %1 = fcmp ule double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_une(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_une:
; CHECK:       # %bb.0:
; CHECK-NEXT:    feq.d a0, fa0, fa1
; CHECK-NEXT:    beqz a0, .LBB13_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB13_2:
; CHECK-NEXT:    ret
  %1 = fcmp une double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_uno(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_uno:
; CHECK:       # %bb.0:
; CHECK-NEXT:    feq.d a0, fa1, fa1
; CHECK-NEXT:    feq.d a1, fa0, fa0
; CHECK-NEXT:    and a0, a1, a0
; CHECK-NEXT:    beqz a0, .LBB14_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    fmv.d fa0, fa1
; CHECK-NEXT:  .LBB14_2:
; CHECK-NEXT:    ret
  %1 = fcmp uno double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

define double @select_fcmp_true(double %a, double %b) nounwind {
; CHECK-LABEL: select_fcmp_true:
; CHECK:       # %bb.0:
; CHECK-NEXT:    ret
  %1 = fcmp true double %a, %b
  %2 = select i1 %1, double %a, double %b
  ret double %2
}

; Ensure that ISel succeeds for a select+fcmp that has an i32 result type.
define i32 @i32_select_fcmp_oeq(double %a, double %b, i32 %c, i32 %d) nounwind {
; CHECK-LABEL: i32_select_fcmp_oeq:
; CHECK:       # %bb.0:
; CHECK-NEXT:    feq.d a2, fa0, fa1
; CHECK-NEXT:    bnez a2, .LBB16_2
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    mv a0, a1
; CHECK-NEXT:  .LBB16_2:
; CHECK-NEXT:    ret
  %1 = fcmp oeq double %a, %b
  %2 = select i1 %1, i32 %c, i32 %d
  ret i32 %2
}
