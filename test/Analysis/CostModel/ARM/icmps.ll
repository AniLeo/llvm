; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -cost-model -analyze -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve.fp < %s | FileCheck %s --check-prefix=CHECK-MVE
; RUN: opt -cost-model -analyze -mtriple=thumbv8m.main-none-eabi < %s | FileCheck %s --check-prefix=CHECK-V8M-MAIN
; RUN: opt -cost-model -analyze -mtriple=thumbv8m.base-none-eabi < %s | FileCheck %s --check-prefix=CHECK-V8M-BASE
; RUN: opt -cost-model -analyze -mtriple=armv8r-none-eabi < %s | FileCheck %s --check-prefix=CHECK-V8R

define i32 @icmps() {
; CHECK-MVE-LABEL: 'icmps'
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a = icmp slt i8 undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %b = icmp ult i16 undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = icmp sge i32 undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = icmp ne i64 undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %e = icmp slt <16 x i8> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %f = icmp ult <8 x i16> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %g = icmp sge <4 x i32> undef, undef
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; CHECK-V8M-MAIN-LABEL: 'icmps'
; CHECK-V8M-MAIN-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a = icmp slt i8 undef, undef
; CHECK-V8M-MAIN-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %b = icmp ult i16 undef, undef
; CHECK-V8M-MAIN-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = icmp sge i32 undef, undef
; CHECK-V8M-MAIN-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = icmp ne i64 undef, undef
; CHECK-V8M-MAIN-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %e = icmp slt <16 x i8> undef, undef
; CHECK-V8M-MAIN-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %f = icmp ult <8 x i16> undef, undef
; CHECK-V8M-MAIN-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %g = icmp sge <4 x i32> undef, undef
; CHECK-V8M-MAIN-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; CHECK-V8M-BASE-LABEL: 'icmps'
; CHECK-V8M-BASE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a = icmp slt i8 undef, undef
; CHECK-V8M-BASE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %b = icmp ult i16 undef, undef
; CHECK-V8M-BASE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = icmp sge i32 undef, undef
; CHECK-V8M-BASE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = icmp ne i64 undef, undef
; CHECK-V8M-BASE-NEXT:  Cost Model: Found an estimated cost of 32 for instruction: %e = icmp slt <16 x i8> undef, undef
; CHECK-V8M-BASE-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %f = icmp ult <8 x i16> undef, undef
; CHECK-V8M-BASE-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %g = icmp sge <4 x i32> undef, undef
; CHECK-V8M-BASE-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
; CHECK-V8R-LABEL: 'icmps'
; CHECK-V8R-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a = icmp slt i8 undef, undef
; CHECK-V8R-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %b = icmp ult i16 undef, undef
; CHECK-V8R-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c = icmp sge i32 undef, undef
; CHECK-V8R-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %d = icmp ne i64 undef, undef
; CHECK-V8R-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = icmp slt <16 x i8> undef, undef
; CHECK-V8R-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %f = icmp ult <8 x i16> undef, undef
; CHECK-V8R-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %g = icmp sge <4 x i32> undef, undef
; CHECK-V8R-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: ret i32 undef
;
  %a = icmp slt i8 undef, undef
  %b = icmp ult i16 undef, undef
  %c = icmp sge i32 undef, undef
  %d = icmp ne i64 undef, undef
  %e = icmp slt <16 x i8> undef, undef
  %f = icmp ult <8 x i16> undef, undef
  %g = icmp sge <4 x i32> undef, undef
  ret i32 undef
}
