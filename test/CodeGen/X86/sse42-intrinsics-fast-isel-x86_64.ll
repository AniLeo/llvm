; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefix=X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/sse42-builtins.c

define i64 @test_mm_crc64_u8(i64 %a0, i8 %a1) nounwind{
; X64-LABEL: test_mm_crc64_u8:
; X64:       # %bb.0:
; X64-NEXT:    crc32b %sil, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    retq
  %res = call i64 @llvm.x86.sse42.crc32.64.8(i64 %a0, i8 %a1)
  ret i64 %res
}
declare i64 @llvm.x86.sse42.crc32.64.8(i64, i8) nounwind readnone

define i64 @test_mm_crc64_u64(i64 %a0, i64 %a1) nounwind{
; X64-LABEL: test_mm_crc64_u64:
; X64:       # %bb.0:
; X64-NEXT:    crc32q %rsi, %rdi
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    retq
  %res = call i64 @llvm.x86.sse42.crc32.64.64(i64 %a0, i64 %a1)
  ret i64 %res
}
declare i64 @llvm.x86.sse42.crc32.64.64(i64, i64) nounwind readnone
