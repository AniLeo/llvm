; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s

; This used to crash, just ensure that it doesn't.

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128-ni:1"
target triple = "x86_64-unknown-linux-gnu"

define void @TestvMeth(i32 %0, i64 %1) gc "statepoint-example" !prof !1 {
; CHECK-LABEL: TestvMeth:
; CHECK:       # %bb.0: # %bci_0
; CHECK-NEXT:    subq $24, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    movq %rsi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movl $10, %esi
; CHECK-NEXT:    movl $10, %edx
; CHECK-NEXT:    movl $400, %ecx # imm = 0x190
; CHECK-NEXT:    callq newarray@PLT
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    addss (%rax), %xmm0
; CHECK-NEXT:    movdqu (%rax), %xmm1
; CHECK-NEXT:    pcmpeqd %xmm2, %xmm2
; CHECK-NEXT:    psubd %xmm2, %xmm1
; CHECK-NEXT:    movdqu %xmm1, (%rax)
; CHECK-NEXT:    movss %xmm0, (%rax)
bci_0:
   %token418 = call token (i64, i32, i8 * (i64, i32, i32, i32)*, i32,
i32, ...) @llvm.experimental.gc.statepoint.p0f_p1i8i64i32i32i32f(i64
2882400000, i32 0, i8* (i64, i32, i32, i32)* nonnull elementtype(i8* (i64, i32, i32, i32)) @newarray, i32 4,
i32 0, i64 undef, i32 10, i32 10, i32 400, i32 0, i32 0) ["deopt"
(i32 35, i32 0, i32 1, i32 0, i32 43, i32 1, i32 13, i32 0, i32 3,
i32 400, i32 3, i32 %0, i32 4, i64 %1, i32 7, i8* null, i32 3,
i32 -11464, i32 7, i8* null, i32 3, i32 -243, i32 3, i32 14, i32 3,
i32 117, i32 3, i32 -13, i32 3, i32 -15, i32 3, i32 -210, i32 3,
i32 541, i32 7, i8* null)]
   %v2 = load atomic float, float * undef unordered, align 4
   %v3 = load <4 x i32>, <4 x i32> * undef, align 4
   %v4 = add <4 x i32> %v3, <i32 1, i32 1, i32 1, i32 1>
   store <4 x i32> %v4, <4 x i32> * undef, align 4
   %v5 = fadd float %v2, 1.500000e+01
   store atomic float %v5, float * undef unordered, align 4
   unreachable
}

declare i32* @personality_function()
declare i8 * @newarray(i64, i32, i32, i32)
declare token @llvm.experimental.gc.statepoint.p0f_p1i8i64i32i32i32f(i64
immarg, i32 immarg, i8 * (i64, i32, i32, i32)*, i32 immarg, i32 immarg, ...)

!1 = !{!"function_entry_count", i64 32768}
