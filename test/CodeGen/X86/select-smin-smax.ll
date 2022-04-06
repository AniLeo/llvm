; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-unknown-linux-gnu -mattr=+bmi < %s | FileCheck %s

declare i32 @llvm.smax.i32(i32, i32)
declare i32 @llvm.smin.i32(i32, i32)
declare i64 @llvm.smax.i64(i64, i64)
declare i64 @llvm.smin.i64(i64, i64)

define i32 @test_i32_smax(i32 %a) nounwind {
; CHECK-LABEL: test_i32_smax:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    cmovgl %edi, %eax
; CHECK-NEXT:    retq
  %r = call i32 @llvm.smax.i32(i32 %a, i32 0)
  ret i32 %r
}

define i32 @test_i32_smin(i32 %a) nounwind {
; CHECK-LABEL: test_i32_smin:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testl %edi, %edi
; CHECK-NEXT:    cmovsl %edi, %eax
; CHECK-NEXT:    retq
  %r = call i32 @llvm.smin.i32(i32 %a, i32 0)
  ret i32 %r
}

define i64 @test_i64_smax(i64 %a) nounwind {
; CHECK-LABEL: test_i64_smax:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testq %rdi, %rdi
; CHECK-NEXT:    cmovgq %rdi, %rax
; CHECK-NEXT:    retq
  %r = call i64 @llvm.smax.i64(i64 %a, i64 0)
  ret i64 %r
}

define i64 @test_i64_smin(i64 %a) nounwind {
; CHECK-LABEL: test_i64_smin:
; CHECK:       # %bb.0:
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    testq %rdi, %rdi
; CHECK-NEXT:    cmovsq %rdi, %rax
; CHECK-NEXT:    retq
  %r = call i64 @llvm.smin.i64(i64 %a, i64 0)
  ret i64 %r
}
