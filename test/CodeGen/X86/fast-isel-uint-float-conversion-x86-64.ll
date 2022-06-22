; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=x86_64-unknown-unknown -mcpu=generic -mattr=+avx512f -fast-isel --fast-isel-abort=1 < %s | FileCheck %s --check-prefix=ALL


define double @long_to_double_rr(i64 %a) {
; ALL-LABEL: long_to_double_rr:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vcvtusi2sd %rdi, %xmm0, %xmm0
; ALL-NEXT:    retq
entry:
  %0 = uitofp i64 %a to double
  ret double %0
}

define double @long_to_double_rm(ptr %a) {
; ALL-LABEL: long_to_double_rm:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vcvtusi2sdq (%rdi), %xmm0, %xmm0
; ALL-NEXT:    retq
entry:
  %0 = load i64, ptr %a
  %1 = uitofp i64 %0 to double
  ret double %1
}

define double @long_to_double_rm_optsize(ptr %a) optsize {
; ALL-LABEL: long_to_double_rm_optsize:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vcvtusi2sdq (%rdi), %xmm0, %xmm0
; ALL-NEXT:    retq
entry:
  %0 = load i64, ptr %a
  %1 = uitofp i64 %0 to double
  ret double %1
}

define float @long_to_float_rr(i64 %a) {
; ALL-LABEL: long_to_float_rr:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vcvtusi2ss %rdi, %xmm0, %xmm0
; ALL-NEXT:    retq
entry:
  %0 = uitofp i64 %a to float
  ret float %0
}

define float @long_to_float_rm(ptr %a) {
; ALL-LABEL: long_to_float_rm:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vcvtusi2ssq (%rdi), %xmm0, %xmm0
; ALL-NEXT:    retq
entry:
  %0 = load i64, ptr %a
  %1 = uitofp i64 %0 to float
  ret float %1
}

define float @long_to_float_rm_optsize(ptr %a) optsize {
; ALL-LABEL: long_to_float_rm_optsize:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    vcvtusi2ssq (%rdi), %xmm0, %xmm0
; ALL-NEXT:    retq
entry:
  %0 = load i64, ptr %a
  %1 = uitofp i64 %0 to float
  ret float %1
}
