; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -cost-model -analyze -mtriple=thumbv6m-none-eabi < %s | FileCheck %s --check-prefix=CHECK-NOVEC
; RUN: opt -cost-model -analyze -mtriple=thumbv7m-none-eabi -mcpu=cortex-m3 < %s | FileCheck %s --check-prefix=CHECK-NOVEC
; RUN: opt -cost-model -analyze -mtriple=thumbv7m-none-eabi -mcpu=cortex-m4 < %s | FileCheck %s --check-prefix=CHECK-FP
; RUN: opt -cost-model -analyze -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve < %s | FileCheck %s --check-prefix=CHECK-MVE
; RUN: opt -cost-model -analyze -mtriple=thumbv7-apple-ios6.0.0 -mcpu=swift < %s | FileCheck %s --check-prefix=CHECK-NEON
; RUN: opt -cost-model -analyze -mtriple=arm-none-eabi -mcpu=cortex-a53 < %s | FileCheck %s --check-prefix=CHECK-NEON
; RUN: opt -cost-model -analyze -cost-kind=code-size -mtriple=thumbv8a-linux-gnueabihf < %s | FileCheck %s --check-prefix=CHECK-V8-SIZE
; RUN: opt -cost-model -analyze -cost-kind=code-size -mtriple=thumbv8.1m.main-none-eabi -mattr=+mve < %s | FileCheck %s --check-prefix=CHECK-MVE-SIZE

define void @stores() {
; CHECK-NOVEC-LABEL: 'stores'
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i8 undef, i8* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i16 undef, i16* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i32 undef, i32* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store i64 undef, i64* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store i128 undef, i128* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store float undef, float* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store double undef, double* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i8> undef, <2 x i8>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i16> undef, <2 x i16>* undef, align 2
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i32> undef, <2 x i32>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 2
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: store <16 x i8> undef, <16 x i8>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x float> undef, <4 x float>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: store <4 x double> undef, <4 x double>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x float> undef, <2 x float>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <2 x double> undef, <2 x double>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x float> undef, <4 x float>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <2 x double> undef, <2 x double>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-FP-LABEL: 'stores'
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i8 undef, i8* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i16 undef, i16* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i32 undef, i32* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store i64 undef, i64* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store i128 undef, i128* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store float undef, float* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store double undef, double* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i8> undef, <2 x i8>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i16> undef, <2 x i16>* undef, align 2
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i32> undef, <2 x i32>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 2
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: store <16 x i8> undef, <16 x i8>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x float> undef, <4 x float>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x double> undef, <4 x double>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x float> undef, <2 x float>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x double> undef, <2 x double>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x float> undef, <4 x float>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x double> undef, <2 x double>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-MVE-LABEL: 'stores'
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i8 undef, i8* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i16 undef, i16* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i32 undef, i32* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store i64 undef, i64* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store i128 undef, i128* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store float undef, float* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store double undef, double* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i8> undef, <2 x i8>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i16> undef, <2 x i16>* undef, align 2
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i32> undef, <2 x i32>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 2
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <16 x i8> undef, <16 x i8>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x float> undef, <4 x float>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <4 x double> undef, <4 x double>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x float> undef, <2 x float>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x double> undef, <2 x double>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <4 x float> undef, <4 x float>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store <2 x double> undef, <2 x double>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-NEON-LABEL: 'stores'
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i8 undef, i8* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i16 undef, i16* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i32 undef, i32* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: store i64 undef, i64* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store i128 undef, i128* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store float undef, float* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store double undef, double* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i8> undef, <2 x i8>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i16> undef, <2 x i16>* undef, align 2
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i32> undef, <2 x i32>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 2
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <16 x i8> undef, <16 x i8>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x float> undef, <4 x float>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: store <4 x double> undef, <4 x double>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x float> undef, <2 x float>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <2 x double> undef, <2 x double>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x float> undef, <4 x float>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: store <2 x double> undef, <2 x double>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-V8-SIZE-LABEL: 'stores'
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i8 undef, i8* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i16 undef, i16* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i32 undef, i32* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i64 undef, i64* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i128 undef, i128* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store float undef, float* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store double undef, double* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i8> undef, <2 x i8>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i16> undef, <2 x i16>* undef, align 2
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i32> undef, <2 x i32>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 2
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <16 x i8> undef, <16 x i8>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x float> undef, <4 x float>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x double> undef, <4 x double>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x float> undef, <2 x float>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x double> undef, <2 x double>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x float> undef, <4 x float>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x double> undef, <2 x double>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-MVE-SIZE-LABEL: 'stores'
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i8 undef, i8* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i16 undef, i16* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i32 undef, i32* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i64 undef, i64* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store i128 undef, i128* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store float undef, float* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store double undef, double* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i8> undef, <2 x i8>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i16> undef, <2 x i16>* undef, align 2
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i32> undef, <2 x i32>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 2
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <16 x i8> undef, <16 x i8>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x float> undef, <4 x float>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x double> undef, <4 x double>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x float> undef, <2 x float>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x double> undef, <2 x double>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x i64> undef, <2 x i64>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x i32> undef, <4 x i32>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <8 x i16> undef, <8 x i16>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <4 x float> undef, <4 x float>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: store <2 x double> undef, <2 x double>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  store i8 undef, i8* undef, align 4
  store i16 undef, i16* undef, align 4
  store i32 undef, i32* undef, align 4
  store i64 undef, i64* undef, align 4
  store i128 undef, i128* undef, align 4
  store float undef, float* undef, align 4
  store double undef, double* undef, align 4

  store <2 x i8> undef, <2 x i8>* undef, align 1
  store <2 x i16> undef, <2 x i16>* undef, align 2
  store <2 x i32> undef, <2 x i32>* undef, align 4
  store <2 x i64> undef, <2 x i64>* undef, align 4
  store <4 x i32> undef, <4 x i32>* undef, align 4
  store <8 x i16> undef, <8 x i16>* undef, align 2
  store <16 x i8> undef, <16 x i8>* undef, align 1

  store <4 x float> undef, <4 x float>* undef, align 4
  store <4 x double> undef, <4 x double>* undef, align 4
  store <2 x float> undef, <2 x float>* undef, align 4
  store <2 x double> undef, <2 x double>* undef, align 4

  store <2 x i64> undef, <2 x i64>* undef, align 1
  store <4 x i32> undef, <4 x i32>* undef, align 1
  store <8 x i16> undef, <8 x i16>* undef, align 1
  store <4 x float> undef, <4 x float>* undef, align 1
  store <2 x double> undef, <2 x double>* undef, align 1

  ret void
}

define void @loads() {
; CHECK-NOVEC-LABEL: 'loads'
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load i8, i8* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = load i16, i16* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %3 = load i32, i32* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %4 = load i64, i64* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %5 = load i128, i128* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %6 = load float, float* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %7 = load double, double* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %8 = load <2 x i8>, <2 x i8>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %9 = load <2 x i16>, <2 x i16>* undef, align 2
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %10 = load <2 x i32>, <2 x i32>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %11 = load <2 x i64>, <2 x i64>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %12 = load <4 x i32>, <4 x i32>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %13 = load <8 x i16>, <8 x i16>* undef, align 2
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %14 = load <16 x i8>, <16 x i8>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %15 = load <4 x float>, <4 x float>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %16 = load <4 x double>, <4 x double>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %17 = load <2 x float>, <2 x float>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %18 = load <2 x double>, <2 x double>* undef, align 4
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %19 = load <2 x i64>, <2 x i64>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %20 = load <4 x i32>, <4 x i32>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %21 = load <8 x i16>, <8 x i16>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %22 = load <4 x float>, <4 x float>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %23 = load <2 x double>, <2 x double>* undef, align 1
; CHECK-NOVEC-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-FP-LABEL: 'loads'
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load i8, i8* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = load i16, i16* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %3 = load i32, i32* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %4 = load i64, i64* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %5 = load i128, i128* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %6 = load float, float* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %7 = load double, double* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %8 = load <2 x i8>, <2 x i8>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %9 = load <2 x i16>, <2 x i16>* undef, align 2
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %10 = load <2 x i32>, <2 x i32>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %11 = load <2 x i64>, <2 x i64>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %12 = load <4 x i32>, <4 x i32>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %13 = load <8 x i16>, <8 x i16>* undef, align 2
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 16 for instruction: %14 = load <16 x i8>, <16 x i8>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %15 = load <4 x float>, <4 x float>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %16 = load <4 x double>, <4 x double>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %17 = load <2 x float>, <2 x float>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %18 = load <2 x double>, <2 x double>* undef, align 4
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %19 = load <2 x i64>, <2 x i64>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %20 = load <4 x i32>, <4 x i32>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %21 = load <8 x i16>, <8 x i16>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %22 = load <4 x float>, <4 x float>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %23 = load <2 x double>, <2 x double>* undef, align 1
; CHECK-FP-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-MVE-LABEL: 'loads'
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load i8, i8* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = load i16, i16* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %3 = load i32, i32* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %4 = load i64, i64* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %5 = load i128, i128* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %6 = load float, float* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %7 = load double, double* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %8 = load <2 x i8>, <2 x i8>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %9 = load <2 x i16>, <2 x i16>* undef, align 2
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %10 = load <2 x i32>, <2 x i32>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %11 = load <2 x i64>, <2 x i64>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %12 = load <4 x i32>, <4 x i32>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %13 = load <8 x i16>, <8 x i16>* undef, align 2
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %14 = load <16 x i8>, <16 x i8>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %15 = load <4 x float>, <4 x float>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %16 = load <4 x double>, <4 x double>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %17 = load <2 x float>, <2 x float>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %18 = load <2 x double>, <2 x double>* undef, align 4
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %19 = load <2 x i64>, <2 x i64>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %20 = load <4 x i32>, <4 x i32>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %21 = load <8 x i16>, <8 x i16>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %22 = load <4 x float>, <4 x float>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %23 = load <2 x double>, <2 x double>* undef, align 1
; CHECK-MVE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-NEON-LABEL: 'loads'
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load i8, i8* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = load i16, i16* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %3 = load i32, i32* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 2 for instruction: %4 = load i64, i64* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %5 = load i128, i128* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %6 = load float, float* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %7 = load double, double* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %8 = load <2 x i8>, <2 x i8>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %9 = load <2 x i16>, <2 x i16>* undef, align 2
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %10 = load <2 x i32>, <2 x i32>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %11 = load <2 x i64>, <2 x i64>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %12 = load <4 x i32>, <4 x i32>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %13 = load <8 x i16>, <8 x i16>* undef, align 2
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %14 = load <16 x i8>, <16 x i8>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %15 = load <4 x float>, <4 x float>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 8 for instruction: %16 = load <4 x double>, <4 x double>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %17 = load <2 x float>, <2 x float>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %18 = load <2 x double>, <2 x double>* undef, align 4
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %19 = load <2 x i64>, <2 x i64>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %20 = load <4 x i32>, <4 x i32>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %21 = load <8 x i16>, <8 x i16>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %22 = load <4 x float>, <4 x float>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 4 for instruction: %23 = load <2 x double>, <2 x double>* undef, align 1
; CHECK-NEON-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-V8-SIZE-LABEL: 'loads'
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load i8, i8* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = load i16, i16* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %3 = load i32, i32* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %4 = load i64, i64* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %5 = load i128, i128* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %6 = load float, float* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %7 = load double, double* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %8 = load <2 x i8>, <2 x i8>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %9 = load <2 x i16>, <2 x i16>* undef, align 2
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %10 = load <2 x i32>, <2 x i32>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %11 = load <2 x i64>, <2 x i64>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %12 = load <4 x i32>, <4 x i32>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %13 = load <8 x i16>, <8 x i16>* undef, align 2
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %14 = load <16 x i8>, <16 x i8>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %15 = load <4 x float>, <4 x float>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %16 = load <4 x double>, <4 x double>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %17 = load <2 x float>, <2 x float>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %18 = load <2 x double>, <2 x double>* undef, align 4
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %19 = load <2 x i64>, <2 x i64>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %20 = load <4 x i32>, <4 x i32>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %21 = load <8 x i16>, <8 x i16>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %22 = load <4 x float>, <4 x float>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %23 = load <2 x double>, <2 x double>* undef, align 1
; CHECK-V8-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
; CHECK-MVE-SIZE-LABEL: 'loads'
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %1 = load i8, i8* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %2 = load i16, i16* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %3 = load i32, i32* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %4 = load i64, i64* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %5 = load i128, i128* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %6 = load float, float* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %7 = load double, double* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %8 = load <2 x i8>, <2 x i8>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %9 = load <2 x i16>, <2 x i16>* undef, align 2
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %10 = load <2 x i32>, <2 x i32>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %11 = load <2 x i64>, <2 x i64>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %12 = load <4 x i32>, <4 x i32>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %13 = load <8 x i16>, <8 x i16>* undef, align 2
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %14 = load <16 x i8>, <16 x i8>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %15 = load <4 x float>, <4 x float>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %16 = load <4 x double>, <4 x double>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %17 = load <2 x float>, <2 x float>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %18 = load <2 x double>, <2 x double>* undef, align 4
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %19 = load <2 x i64>, <2 x i64>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %20 = load <4 x i32>, <4 x i32>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %21 = load <8 x i16>, <8 x i16>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %22 = load <4 x float>, <4 x float>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %23 = load <2 x double>, <2 x double>* undef, align 1
; CHECK-MVE-SIZE-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  load i8, i8* undef, align 4
  load i16, i16* undef, align 4
  load i32, i32* undef, align 4
  load i64, i64* undef, align 4
  load i128, i128* undef, align 4
  load float, float* undef, align 4
  load double, double* undef, align 4

  load <2 x i8>, <2 x i8>* undef, align 1
  load <2 x i16>, <2 x i16>* undef, align 2
  load <2 x i32>, <2 x i32>* undef, align 4
  load <2 x i64>, <2 x i64>* undef, align 4
  load <4 x i32>, <4 x i32>* undef, align 4
  load <8 x i16>, <8 x i16>* undef, align 2
  load <16 x i8>, <16 x i8>* undef, align 1

  load <4 x float>, <4 x float>* undef, align 4
  load <4 x double>, <4 x double>* undef, align 4
  load <2 x float>, <2 x float>* undef, align 4
  load <2 x double>, <2 x double>* undef, align 4

  load <2 x i64>, <2 x i64>* undef, align 1
  load <4 x i32>, <4 x i32>* undef, align 1
  load <8 x i16>, <8 x i16>* undef, align 1
  load <4 x float>, <4 x float>* undef, align 1
  load <2 x double>, <2 x double>* undef, align 1

  ret void
}

