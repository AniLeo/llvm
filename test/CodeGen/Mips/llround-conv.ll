; RUN: llc < %s -mtriple=mips64el -mattr=+soft-float | FileCheck %s

define signext i32 @testmsws(float %x) {
; CHECK-LABEL: testmsws:
; CHECK:       jal     llroundf
entry:
  %0 = tail call i64 @llvm.llround.f32(float %x)
  %conv = trunc i64 %0 to i32
  ret i32 %conv
}

define i64 @testmsxs(float %x) {
; CHECK-LABEL: testmsxs:
; CHECK:       jal     llroundf
entry:
  %0 = tail call i64 @llvm.llround.f32(float %x)
  ret i64 %0
}

define signext i32 @testmswd(double %x) {
; CHECK-LABEL: testmswd:
; CHECK:       jal     llround
entry:
  %0 = tail call i64 @llvm.llround.f64(double %x)
  %conv = trunc i64 %0 to i32
  ret i32 %conv
}

define i64 @testmsxd(double %x) {
; CHECK-LABEL: testmsxd:
; CHECK:       jal     llround
entry:
  %0 = tail call i64 @llvm.llround.f64(double %x)
  ret i64 %0
}

define signext i32 @testmswl(fp128 %x) {
; CHECK-LABEL: testmswl:
; CHECK:       jal     llroundl
entry:
  %0 = tail call i64 @llvm.llround.f128(fp128 %x)
  %conv = trunc i64 %0 to i32
  ret i32 %conv
}

define i64 @testmsll(fp128 %x) {
; CHECK-LABEL: testmsll:
; CHECK:       jal     llroundl
entry:
  %0 = tail call i64 @llvm.llround.f128(fp128 %x)
  ret i64 %0
}

declare i64 @llvm.llround.f32(float) nounwind readnone
declare i64 @llvm.llround.f64(double) nounwind readnone
declare i64 @llvm.llround.f128(fp128) nounwind readnone
