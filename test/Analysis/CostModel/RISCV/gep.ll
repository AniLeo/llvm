; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt -mtriple=riscv32 -cost-model -analyze < %s \
; RUN:   | FileCheck %s -check-prefix=RVI
; RUN: opt -mtriple=riscv64 -cost-model -analyze < %s \
; RUN:   | FileCheck %s -check-prefix=RVI

define void @testi8(i8* %a, i32 %i) {
; RVI-LABEL: 'testi8'
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a0 = getelementptr inbounds i8, i8* %a, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a1 = getelementptr inbounds i8, i8* %a, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a2 = getelementptr inbounds i8, i8* %a, i32 -1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a3 = getelementptr inbounds i8, i8* %a, i32 2047
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a4 = getelementptr inbounds i8, i8* %a, i32 2048
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a5 = getelementptr inbounds i8, i8* %a, i32 -2048
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a6 = getelementptr inbounds i8, i8* %a, i32 -2049
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %ai = getelementptr inbounds i8, i8* %a, i32 %i
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %a0 = getelementptr inbounds i8, i8* %a, i32 0
  %a1 = getelementptr inbounds i8, i8* %a, i32 1
  %a2 = getelementptr inbounds i8, i8* %a, i32 -1
  %a3 = getelementptr inbounds i8, i8* %a, i32 2047
  %a4 = getelementptr inbounds i8, i8* %a, i32 2048
  %a5 = getelementptr inbounds i8, i8* %a, i32 -2048
  %a6 = getelementptr inbounds i8, i8* %a, i32 -2049
  %ai = getelementptr inbounds i8, i8* %a, i32 %i
  ret void
}

define void @testi16(i16* %a, i32 %i) {
; RVI-LABEL: 'testi16'
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a0 = getelementptr inbounds i16, i16* %a, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a1 = getelementptr inbounds i16, i16* %a, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a2 = getelementptr inbounds i16, i16* %a, i32 -1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a3 = getelementptr inbounds i16, i16* %a, i32 1023
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a4 = getelementptr inbounds i16, i16* %a, i32 1024
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a5 = getelementptr inbounds i16, i16* %a, i32 -1024
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a6 = getelementptr inbounds i16, i16* %a, i32 -1025
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %ai = getelementptr inbounds i16, i16* %a, i32 %i
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %a0 = getelementptr inbounds i16, i16* %a, i32 0
  %a1 = getelementptr inbounds i16, i16* %a, i32 1
  %a2 = getelementptr inbounds i16, i16* %a, i32 -1
  %a3 = getelementptr inbounds i16, i16* %a, i32 1023
  %a4 = getelementptr inbounds i16, i16* %a, i32 1024
  %a5 = getelementptr inbounds i16, i16* %a, i32 -1024
  %a6 = getelementptr inbounds i16, i16* %a, i32 -1025
  %ai = getelementptr inbounds i16, i16* %a, i32 %i
  ret void
}

define void @testi32(i32* %a, i32 %i) {
; RVI-LABEL: 'testi32'
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a0 = getelementptr inbounds i32, i32* %a, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a1 = getelementptr inbounds i32, i32* %a, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a2 = getelementptr inbounds i32, i32* %a, i32 -1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a3 = getelementptr inbounds i32, i32* %a, i32 511
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a4 = getelementptr inbounds i32, i32* %a, i32 512
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a5 = getelementptr inbounds i32, i32* %a, i32 -512
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a6 = getelementptr inbounds i32, i32* %a, i32 -513
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %ai = getelementptr inbounds i32, i32* %a, i32 %i
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %a0 = getelementptr inbounds i32, i32* %a, i32 0
  %a1 = getelementptr inbounds i32, i32* %a, i32 1
  %a2 = getelementptr inbounds i32, i32* %a, i32 -1
  %a3 = getelementptr inbounds i32, i32* %a, i32 511
  %a4 = getelementptr inbounds i32, i32* %a, i32 512
  %a5 = getelementptr inbounds i32, i32* %a, i32 -512
  %a6 = getelementptr inbounds i32, i32* %a, i32 -513
  %ai = getelementptr inbounds i32, i32* %a, i32 %i
  ret void
}

define void @testi64(i64* %a, i32 %i) {
; RVI-LABEL: 'testi64'
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a0 = getelementptr inbounds i64, i64* %a, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a1 = getelementptr inbounds i64, i64* %a, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a2 = getelementptr inbounds i64, i64* %a, i32 -1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a3 = getelementptr inbounds i64, i64* %a, i32 255
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a4 = getelementptr inbounds i64, i64* %a, i32 256
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a5 = getelementptr inbounds i64, i64* %a, i32 -256
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a6 = getelementptr inbounds i64, i64* %a, i32 -257
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %ai = getelementptr inbounds i64, i64* %a, i32 %i
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %a0 = getelementptr inbounds i64, i64* %a, i32 0
  %a1 = getelementptr inbounds i64, i64* %a, i32 1
  %a2 = getelementptr inbounds i64, i64* %a, i32 -1
  %a3 = getelementptr inbounds i64, i64* %a, i32 255
  %a4 = getelementptr inbounds i64, i64* %a, i32 256
  %a5 = getelementptr inbounds i64, i64* %a, i32 -256
  %a6 = getelementptr inbounds i64, i64* %a, i32 -257
  %ai = getelementptr inbounds i64, i64* %a, i32 %i
  ret void
}

define void @testfloat(float* %a, i32 %i) {
; RVI-LABEL: 'testfloat'
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a0 = getelementptr inbounds float, float* %a, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a1 = getelementptr inbounds float, float* %a, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a2 = getelementptr inbounds float, float* %a, i32 -1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a3 = getelementptr inbounds float, float* %a, i32 511
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a4 = getelementptr inbounds float, float* %a, i32 512
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a5 = getelementptr inbounds float, float* %a, i32 -512
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a6 = getelementptr inbounds float, float* %a, i32 -513
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %ai = getelementptr inbounds float, float* %a, i32 %i
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %a0 = getelementptr inbounds float, float* %a, i32 0
  %a1 = getelementptr inbounds float, float* %a, i32 1
  %a2 = getelementptr inbounds float, float* %a, i32 -1
  %a3 = getelementptr inbounds float, float* %a, i32 511
  %a4 = getelementptr inbounds float, float* %a, i32 512
  %a5 = getelementptr inbounds float, float* %a, i32 -512
  %a6 = getelementptr inbounds float, float* %a, i32 -513
  %ai = getelementptr inbounds float, float* %a, i32 %i
  ret void
}

define void @testdouble(double* %a, i32 %i) {
; RVI-LABEL: 'testdouble'
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a0 = getelementptr inbounds double, double* %a, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a1 = getelementptr inbounds double, double* %a, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a2 = getelementptr inbounds double, double* %a, i32 -1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a3 = getelementptr inbounds double, double* %a, i32 255
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a4 = getelementptr inbounds double, double* %a, i32 256
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a5 = getelementptr inbounds double, double* %a, i32 -256
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %a6 = getelementptr inbounds double, double* %a, i32 -257
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %ai = getelementptr inbounds double, double* %a, i32 %i
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %a0 = getelementptr inbounds double, double* %a, i32 0
  %a1 = getelementptr inbounds double, double* %a, i32 1
  %a2 = getelementptr inbounds double, double* %a, i32 -1
  %a3 = getelementptr inbounds double, double* %a, i32 255
  %a4 = getelementptr inbounds double, double* %a, i32 256
  %a5 = getelementptr inbounds double, double* %a, i32 -256
  %a6 = getelementptr inbounds double, double* %a, i32 -257
  %ai = getelementptr inbounds double, double* %a, i32 %i
  ret void
}

define void @testvecs(i32 %i) {
; RVI-LABEL: 'testvecs'
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a0 = getelementptr inbounds <4 x i8>, <4 x i8>* undef, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a1 = getelementptr inbounds <4 x i16>, <4 x i16>* undef, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a2 = getelementptr inbounds <4 x i32>, <4 x i32>* undef, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a3 = getelementptr inbounds <4 x i64>, <4 x i64>* undef, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a4 = getelementptr inbounds <4 x float>, <4 x float>* undef, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %a5 = getelementptr inbounds <4 x double>, <4 x double>* undef, i32 0
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %b0 = getelementptr inbounds <4 x i8>, <4 x i8>* undef, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %b1 = getelementptr inbounds <4 x i16>, <4 x i16>* undef, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %b2 = getelementptr inbounds <4 x i32>, <4 x i32>* undef, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %b3 = getelementptr inbounds <4 x i64>, <4 x i64>* undef, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %b4 = getelementptr inbounds <4 x float>, <4 x float>* undef, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %b5 = getelementptr inbounds <4 x double>, <4 x double>* undef, i32 1
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %c1 = getelementptr inbounds <4 x i8>, <4 x i8>* undef, i32 128
; RVI-NEXT:  Cost Model: Found an estimated cost of 0 for instruction: %c2 = getelementptr inbounds <4 x i16>, <4 x i16>* undef, i32 128
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c3 = getelementptr inbounds <4 x i32>, <4 x i32>* undef, i32 128
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c4 = getelementptr inbounds <4 x i64>, <4 x i64>* undef, i32 128
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c5 = getelementptr inbounds <4 x float>, <4 x float>* undef, i32 128
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %c6 = getelementptr inbounds <4 x double>, <4 x double>* undef, i32 128
; RVI-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret void
;
  %a0 = getelementptr inbounds <4 x i8>, <4 x i8>* undef, i32 0
  %a1 = getelementptr inbounds <4 x i16>, <4 x i16>* undef, i32 0
  %a2 = getelementptr inbounds <4 x i32>, <4 x i32>* undef, i32 0
  %a3 = getelementptr inbounds <4 x i64>, <4 x i64>* undef, i32 0
  %a4 = getelementptr inbounds <4 x float>, <4 x float>* undef, i32 0
  %a5 = getelementptr inbounds <4 x double>, <4 x double>* undef, i32 0

  %b0 = getelementptr inbounds <4 x i8>, <4 x i8>* undef, i32 1
  %b1 = getelementptr inbounds <4 x i16>, <4 x i16>* undef, i32 1
  %b2 = getelementptr inbounds <4 x i32>, <4 x i32>* undef, i32 1
  %b3 = getelementptr inbounds <4 x i64>, <4 x i64>* undef, i32 1
  %b4 = getelementptr inbounds <4 x float>, <4 x float>* undef, i32 1
  %b5 = getelementptr inbounds <4 x double>, <4 x double>* undef, i32 1

  %c1 = getelementptr inbounds <4 x i8>, <4 x i8>* undef, i32 128
  %c2 = getelementptr inbounds <4 x i16>, <4 x i16>* undef, i32 128
  %c3 = getelementptr inbounds <4 x i32>, <4 x i32>* undef, i32 128
  %c4 = getelementptr inbounds <4 x i64>, <4 x i64>* undef, i32 128
  %c5 = getelementptr inbounds <4 x float>, <4 x float>* undef, i32 128
  %c6 = getelementptr inbounds <4 x double>, <4 x double>* undef, i32 128

  ret void
}
