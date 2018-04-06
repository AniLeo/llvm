; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=x86-64 -mattr=+movbe | FileCheck %s --check-prefix=CHECK --check-prefix=GENERIC
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=atom | FileCheck %s --check-prefix=CHECK --check-prefix=ATOM
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=slm | FileCheck %s --check-prefix=CHECK --check-prefix=SLM
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=haswell | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=broadwell | FileCheck %s --check-prefix=CHECK --check-prefix=BROADWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=skylake | FileCheck %s --check-prefix=CHECK --check-prefix=SKYLAKE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=knl | FileCheck %s --check-prefix=CHECK --check-prefix=HASWELL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=btver2 | FileCheck %s --check-prefix=CHECK --check-prefix=BTVER2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -print-schedule -mcpu=znver1 | FileCheck %s --check-prefix=CHECK --check-prefix=ZNVER1

define i16 @test_movbe_i16(i16 *%a0, i16 %a1, i16 *%a2) {
; GENERIC-LABEL: test_movbe_i16:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movbew (%rdi), %ax # sched: [6:0.50]
; GENERIC-NEXT:    movbew %si, (%rdx) # sched: [1:1.00]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_movbe_i16:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movbew (%rdi), %ax # sched: [1:1.00]
; ATOM-NEXT:    movbew %si, (%rdx) # sched: [1:1.00]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_movbe_i16:
; SLM:       # %bb.0:
; SLM-NEXT:    movbew (%rdi), %ax # sched: [4:1.00]
; SLM-NEXT:    movbew %si, (%rdx) # sched: [1:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; HASWELL-LABEL: test_movbe_i16:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movbew (%rdi), %ax # sched: [6:0.50]
; HASWELL-NEXT:    movbew %si, (%rdx) # sched: [2:1.00]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; BROADWELL-LABEL: test_movbe_i16:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movbew (%rdi), %ax # sched: [6:0.50]
; BROADWELL-NEXT:    movbew %si, (%rdx) # sched: [2:1.00]
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_movbe_i16:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movbew (%rdi), %ax # sched: [6:0.50]
; SKYLAKE-NEXT:    movbew %si, (%rdx) # sched: [2:1.00]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; BTVER2-LABEL: test_movbe_i16:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movbew (%rdi), %ax # sched: [4:1.00]
; BTVER2-NEXT:    movbew %si, (%rdx) # sched: [1:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_movbe_i16:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movbew (%rdi), %ax # sched: [5:0.50]
; ZNVER1-NEXT:    movbew %si, (%rdx) # sched: [5:0.50]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %1 = load i16, i16 *%a0
  %2 = tail call i16 @llvm.bswap.i16( i16 %1 )
  %3 = tail call i16 @llvm.bswap.i16( i16 %a1 )
  store i16 %3, i16* %a2, align 2
  ret i16 %2
}
declare i16 @llvm.bswap.i16(i16)

define i32 @test_movbe_i32(i32 *%a0, i32 %a1, i32 *%a2) {
; GENERIC-LABEL: test_movbe_i32:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movbel (%rdi), %eax # sched: [6:0.50]
; GENERIC-NEXT:    movbel %esi, (%rdx) # sched: [1:1.00]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_movbe_i32:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movbel (%rdi), %eax # sched: [1:1.00]
; ATOM-NEXT:    movbel %esi, (%rdx) # sched: [1:1.00]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_movbe_i32:
; SLM:       # %bb.0:
; SLM-NEXT:    movbel (%rdi), %eax # sched: [4:1.00]
; SLM-NEXT:    movbel %esi, (%rdx) # sched: [1:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; HASWELL-LABEL: test_movbe_i32:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movbel (%rdi), %eax # sched: [6:0.50]
; HASWELL-NEXT:    movbel %esi, (%rdx) # sched: [2:1.00]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; BROADWELL-LABEL: test_movbe_i32:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movbel (%rdi), %eax # sched: [6:0.50]
; BROADWELL-NEXT:    movbel %esi, (%rdx) # sched: [2:1.00]
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_movbe_i32:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movbel (%rdi), %eax # sched: [6:0.50]
; SKYLAKE-NEXT:    movbel %esi, (%rdx) # sched: [2:1.00]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; BTVER2-LABEL: test_movbe_i32:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movbel (%rdi), %eax # sched: [4:1.00]
; BTVER2-NEXT:    movbel %esi, (%rdx) # sched: [1:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_movbe_i32:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movbel (%rdi), %eax # sched: [5:0.50]
; ZNVER1-NEXT:    movbel %esi, (%rdx) # sched: [5:0.50]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %1 = load i32, i32 *%a0
  %2 = tail call i32 @llvm.bswap.i32( i32 %1 )
  %3 = tail call i32 @llvm.bswap.i32( i32 %a1 )
  store i32 %3, i32* %a2, align 2
  ret i32 %2
}
declare i32 @llvm.bswap.i32(i32)

define i64 @test_movbe_i64(i64 *%a0, i64 %a1, i64 *%a2) {
; GENERIC-LABEL: test_movbe_i64:
; GENERIC:       # %bb.0:
; GENERIC-NEXT:    movbeq (%rdi), %rax # sched: [6:0.50]
; GENERIC-NEXT:    movbeq %rsi, (%rdx) # sched: [1:1.00]
; GENERIC-NEXT:    retq # sched: [1:1.00]
;
; ATOM-LABEL: test_movbe_i64:
; ATOM:       # %bb.0:
; ATOM-NEXT:    movbeq (%rdi), %rax # sched: [1:1.00]
; ATOM-NEXT:    movbeq %rsi, (%rdx) # sched: [1:1.00]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    nop # sched: [1:0.50]
; ATOM-NEXT:    retq # sched: [79:39.50]
;
; SLM-LABEL: test_movbe_i64:
; SLM:       # %bb.0:
; SLM-NEXT:    movbeq (%rdi), %rax # sched: [4:1.00]
; SLM-NEXT:    movbeq %rsi, (%rdx) # sched: [1:1.00]
; SLM-NEXT:    retq # sched: [4:1.00]
;
; HASWELL-LABEL: test_movbe_i64:
; HASWELL:       # %bb.0:
; HASWELL-NEXT:    movbeq (%rdi), %rax # sched: [6:0.50]
; HASWELL-NEXT:    movbeq %rsi, (%rdx) # sched: [2:1.00]
; HASWELL-NEXT:    retq # sched: [7:1.00]
;
; BROADWELL-LABEL: test_movbe_i64:
; BROADWELL:       # %bb.0:
; BROADWELL-NEXT:    movbeq (%rdi), %rax # sched: [6:0.50]
; BROADWELL-NEXT:    movbeq %rsi, (%rdx) # sched: [2:1.00]
; BROADWELL-NEXT:    retq # sched: [7:1.00]
;
; SKYLAKE-LABEL: test_movbe_i64:
; SKYLAKE:       # %bb.0:
; SKYLAKE-NEXT:    movbeq (%rdi), %rax # sched: [6:0.50]
; SKYLAKE-NEXT:    movbeq %rsi, (%rdx) # sched: [2:1.00]
; SKYLAKE-NEXT:    retq # sched: [7:1.00]
;
; BTVER2-LABEL: test_movbe_i64:
; BTVER2:       # %bb.0:
; BTVER2-NEXT:    movbeq (%rdi), %rax # sched: [4:1.00]
; BTVER2-NEXT:    movbeq %rsi, (%rdx) # sched: [1:1.00]
; BTVER2-NEXT:    retq # sched: [4:1.00]
;
; ZNVER1-LABEL: test_movbe_i64:
; ZNVER1:       # %bb.0:
; ZNVER1-NEXT:    movbeq (%rdi), %rax # sched: [5:0.50]
; ZNVER1-NEXT:    movbeq %rsi, (%rdx) # sched: [5:0.50]
; ZNVER1-NEXT:    retq # sched: [1:0.50]
  %1 = load i64, i64 *%a0
  %2 = tail call i64 @llvm.bswap.i64( i64 %1 )
  %3 = tail call i64 @llvm.bswap.i64( i64 %a1 )
  store i64 %3, i64* %a2, align 2
  ret i64 %2
}
declare i64 @llvm.bswap.i64(i64)
