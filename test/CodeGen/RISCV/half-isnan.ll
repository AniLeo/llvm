; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+zfh -verify-machineinstrs \
; RUN:   -target-abi ilp32f < %s | FileCheck %s
; RUN: llc -mtriple=riscv64 -mattr=+zfh -verify-machineinstrs \
; RUN:   -target-abi lp64f < %s | FileCheck %s

define zeroext i1 @half_is_nan(half %a) nounwind {
; CHECK-LABEL: half_is_nan:
; CHECK:       # %bb.0:
; CHECK-NEXT:    feq.h a0, fa0, fa0
; CHECK-NEXT:    xori a0, a0, 1
; CHECK-NEXT:    ret
  %1 = fcmp uno half %a, 0.000000e+00
  ret i1 %1
}

define zeroext i1 @half_not_nan(half %a) nounwind {
; CHECK-LABEL: half_not_nan:
; CHECK:       # %bb.0:
; CHECK-NEXT:    feq.h a0, fa0, fa0
; CHECK-NEXT:    ret
  %1 = fcmp ord half %a, 0.000000e+00
  ret i1 %1
}
