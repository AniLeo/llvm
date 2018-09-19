; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=CHECK,AVX,AVX1
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw,+avx512dq,+avx512vl | FileCheck %s --check-prefixes=CHECK,AVX,AVX512

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/sse42-builtins.c

define i64 @test_mm_crc64_u8(i64 %a0, i8 %a1) nounwind{
; CHECK-LABEL: test_mm_crc64_u8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    crc32b %sil, %edi
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    retq
  %res = call i64 @llvm.x86.sse42.crc32.64.8(i64 %a0, i8 %a1)
  ret i64 %res
}
declare i64 @llvm.x86.sse42.crc32.64.8(i64, i8) nounwind readnone

define i64 @test_mm_crc64_u64(i64 %a0, i64 %a1) nounwind{
; CHECK-LABEL: test_mm_crc64_u64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rdi, %rax
; CHECK-NEXT:    crc32q %rsi, %rax
; CHECK-NEXT:    retq
  %res = call i64 @llvm.x86.sse42.crc32.64.64(i64 %a0, i64 %a1)
  ret i64 %res
}
declare i64 @llvm.x86.sse42.crc32.64.64(i64, i64) nounwind readnone
