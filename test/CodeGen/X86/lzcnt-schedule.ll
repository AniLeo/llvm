; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=+lzcnt | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=haswell   | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=broadwell | FileCheck %s --check-prefix=CHECK --check-prefix=BROADWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skylake   | FileCheck %s --check-prefix=CHECK --check-prefix=SKYLAKE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=knl       | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=btver2    | FileCheck %s --check-prefix=CHECK --check-prefix=BTVER2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1    | FileCheck %s --check-prefix=CHECK --check-prefix=ZNVER1

define i16 @test_ctlz_i16(i16 zeroext %a0, i16 *%a1) {
; GENERIC-LABEL: test_ctlz_i16:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    lzcntw (%rsi), %cx # sched: [8:1.00]
; GENERIC-NEXT:    lzcntw %di, %ax # sched: [3:1.00]
; GENERIC-NEXT:    orl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    # kill: def $ax killed $ax killed $eax
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_ctlz_i16:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    lzcntw (%rsi), %cx # sched: [8:1.00]
; HASWELL-NEXT:    lzcntw %di, %ax # sched: [3:1.00]
; HASWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    # kill: def $ax killed $ax killed $eax
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; BROADWELL-LABEL: test_ctlz_i16:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    lzcntw (%rsi), %cx # sched: [8:1.00]
; BROADWELL-NEXT:    lzcntw %di, %ax # sched: [3:1.00]
; BROADWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; BROADWELL-NEXT:    # kill: def $ax killed $ax killed $eax
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_ctlz_i16:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    lzcntw (%rsi), %cx # sched: [8:1.00]
; SKYLAKE-NEXT:    lzcntw %di, %ax # sched: [3:1.00]
; SKYLAKE-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; SKYLAKE-NEXT:    # kill: def $ax killed $ax killed $eax
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; BTVER2-LABEL: test_ctlz_i16:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    lzcntw (%rsi), %cx # sched: [4:1.00]
; BTVER2-NEXT:    lzcntw %di, %ax # sched: [1:0.50]
; BTVER2-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    # kill: def $ax killed $ax killed $eax
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_ctlz_i16:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    lzcntw (%rsi), %cx # sched: [6:0.50]
; ZNVER1-NEXT:    lzcntw %di, %ax # sched: [2:0.25]
; ZNVER1-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    # kill: def $ax killed $ax killed $eax
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %1 = load i16, i16 *%a1
  %2 = tail call i16 @llvm.ctlz.i16( i16 %1, i1 false )
  %3 = tail call i16 @llvm.ctlz.i16( i16 %a0, i1 false )
  %4 = or i16 %2, %3
  ret i16 %4
}
declare i16 @llvm.ctlz.i16(i16, i1)

define i32 @test_ctlz_i32(i32 %a0, i32 *%a1) {
; GENERIC-LABEL: test_ctlz_i32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    lzcntl (%rsi), %ecx # sched: [8:1.00]
; GENERIC-NEXT:    lzcntl %edi, %eax # sched: [3:1.00]
; GENERIC-NEXT:    orl %ecx, %eax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_ctlz_i32:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    lzcntl (%rsi), %ecx # sched: [8:1.00]
; HASWELL-NEXT:    lzcntl %edi, %eax # sched: [3:1.00]
; HASWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; BROADWELL-LABEL: test_ctlz_i32:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    lzcntl (%rsi), %ecx # sched: [8:1.00]
; BROADWELL-NEXT:    lzcntl %edi, %eax # sched: [3:1.00]
; BROADWELL-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_ctlz_i32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    lzcntl (%rsi), %ecx # sched: [8:1.00]
; SKYLAKE-NEXT:    lzcntl %edi, %eax # sched: [3:1.00]
; SKYLAKE-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; BTVER2-LABEL: test_ctlz_i32:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    lzcntl (%rsi), %ecx # sched: [4:1.00]
; BTVER2-NEXT:    lzcntl %edi, %eax # sched: [1:0.50]
; BTVER2-NEXT:    orl %ecx, %eax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_ctlz_i32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    lzcntl (%rsi), %ecx # sched: [6:0.50]
; ZNVER1-NEXT:    lzcntl %edi, %eax # sched: [2:0.25]
; ZNVER1-NEXT:    orl %ecx, %eax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %1 = load i32, i32 *%a1
  %2 = tail call i32 @llvm.ctlz.i32( i32 %1, i1 false )
  %3 = tail call i32 @llvm.ctlz.i32( i32 %a0, i1 false )
  %4 = or i32 %2, %3
  ret i32 %4
}
declare i32 @llvm.ctlz.i32(i32, i1)

define i64 @test_ctlz_i64(i64 %a0, i64 *%a1) {
; GENERIC-LABEL: test_ctlz_i64:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    lzcntq (%rsi), %rcx # sched: [8:1.00]
; GENERIC-NEXT:    lzcntq %rdi, %rax # sched: [3:1.00]
; GENERIC-NEXT:    orq %rcx, %rax # sched: [1:0.33]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; HASWELL-LABEL: test_ctlz_i64:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    lzcntq (%rsi), %rcx # sched: [8:1.00]
; HASWELL-NEXT:    lzcntq %rdi, %rax # sched: [3:1.00]
; HASWELL-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; BROADWELL-LABEL: test_ctlz_i64:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    lzcntq (%rsi), %rcx # sched: [8:1.00]
; BROADWELL-NEXT:    lzcntq %rdi, %rax # sched: [3:1.00]
; BROADWELL-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_ctlz_i64:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    lzcntq (%rsi), %rcx # sched: [8:1.00]
; SKYLAKE-NEXT:    lzcntq %rdi, %rax # sched: [3:1.00]
; SKYLAKE-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; BTVER2-LABEL: test_ctlz_i64:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    lzcntq (%rsi), %rcx # sched: [4:1.00]
; BTVER2-NEXT:    lzcntq %rdi, %rax # sched: [1:0.50]
; BTVER2-NEXT:    orq %rcx, %rax # sched: [1:0.50]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_ctlz_i64:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    lzcntq (%rsi), %rcx # sched: [6:0.50]
; ZNVER1-NEXT:    lzcntq %rdi, %rax # sched: [2:0.25]
; ZNVER1-NEXT:    orq %rcx, %rax # sched: [1:0.25]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %1 = load i64, i64 *%a1
  %2 = tail call i64 @llvm.ctlz.i64( i64 %1, i1 false )
  %3 = tail call i64 @llvm.ctlz.i64( i64 %a0, i1 false )
  %4 = or i64 %2, %3
  ret i64 %4
}
declare i64 @llvm.ctlz.i64(i64, i1)
