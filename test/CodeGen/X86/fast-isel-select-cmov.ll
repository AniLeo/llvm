; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -fast-isel-abort=1 -mtriple=x86_64-apple-darwin10                  | FileCheck %s --check-prefix=CHECK --check-prefix=NOAVX512
; RUN: llc < %s -fast-isel -fast-isel-abort=1 -mtriple=x86_64-apple-darwin10 -mattr=+avx512f  | FileCheck %s --check-prefix=CHECK --check-prefix=AVX512

; Test conditional move for the supported types (i16, i32, and i32) and
; conditon input (argument or cmp). Currently i8 is not supported.

define zeroext i16 @select_cmov_i16(i1 zeroext %cond, i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: select_cmov_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    cmovew %dx, %si
; CHECK-NEXT:    movzwl %si, %eax
; CHECK-NEXT:    retq
  %1 = select i1 %cond, i16 %a, i16 %b
  ret i16 %1
}

define zeroext i16 @select_cmp_cmov_i16(i16 zeroext %a, i16 zeroext %b) {
; CHECK-LABEL: select_cmp_cmov_i16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    cmpw %si, %di
; CHECK-NEXT:    cmovbw %di, %si
; CHECK-NEXT:    movzwl %si, %eax
; CHECK-NEXT:    retq
  %1 = icmp ult i16 %a, %b
  %2 = select i1 %1, i16 %a, i16 %b
  ret i16 %2
}

define i32 @select_cmov_i32(i1 zeroext %cond, i32 %a, i32 %b) {
; CHECK-LABEL: select_cmov_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    cmovel %edx, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %1 = select i1 %cond, i32 %a, i32 %b
  ret i32 %1
}

define i32 @select_cmp_cmov_i32(i32 %a, i32 %b) {
; CHECK-LABEL: select_cmp_cmov_i32:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    cmpl %esi, %edi
; CHECK-NEXT:    cmovbl %edi, %esi
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    retq
  %1 = icmp ult i32 %a, %b
  %2 = select i1 %1, i32 %a, i32 %b
  ret i32 %2
}

define i64 @select_cmov_i64(i1 zeroext %cond, i64 %a, i64 %b) {
; CHECK-LABEL: select_cmov_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    testb $1, %dil
; CHECK-NEXT:    cmoveq %rdx, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %1 = select i1 %cond, i64 %a, i64 %b
  ret i64 %1
}

define i64 @select_cmp_cmov_i64(i64 %a, i64 %b) {
; CHECK-LABEL: select_cmp_cmov_i64:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    cmpq %rsi, %rdi
; CHECK-NEXT:    cmovbq %rdi, %rsi
; CHECK-NEXT:    movq %rsi, %rax
; CHECK-NEXT:    retq
  %1 = icmp ult i64 %a, %b
  %2 = select i1 %1, i64 %a, i64 %b
  ret i64 %2
}

