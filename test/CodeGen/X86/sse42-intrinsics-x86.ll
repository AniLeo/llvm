; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -disable-peephole -mtriple=i386-apple-darwin -mattr=+sse4.2 -show-mc-encoding | FileCheck %s --check-prefixes=SSE,X86-SSE
; RUN: llc < %s -disable-peephole -mtriple=i386-apple-darwin -mattr=+sse4.2,-crc32 -show-mc-encoding | FileCheck %s --check-prefixes=SSE,X86-SSE
; RUN: llc < %s -disable-peephole -mtriple=i386-apple-darwin -mattr=+avx -show-mc-encoding | FileCheck %s --check-prefixes=AVX,X86-AVX,X86-AVX1
; RUN: llc < %s -disable-peephole -mtriple=i386-apple-darwin -mattr=+avx512f,+avx512bw,+avx512dq,+avx512vl -show-mc-encoding | FileCheck %s --check-prefixes=AVX,X86-AVX,X86-AVX512
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-darwin -mattr=+sse4.2 -show-mc-encoding | FileCheck %s --check-prefixes=SSE,X64-SSE
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-darwin -mattr=+sse4.2,-crc32 -show-mc-encoding | FileCheck %s --check-prefixes=SSE,X64-SSE
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-darwin -mattr=+avx -show-mc-encoding | FileCheck %s --check-prefixes=AVX,X64-AVX,X64-AVX1
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-darwin -mattr=+avx512f,+avx512bw,+avx512dq,+avx512vl -show-mc-encoding | FileCheck %s --check-prefixes=AVX,X64-AVX,X64-AVX512

define i32 @test_x86_sse42_pcmpestri128(<16 x i8> %a0, <16 x i8> %a2) {
; SSE-LABEL: test_x86_sse42_pcmpestri128:
; SSE:       ## %bb.0:
; SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; SSE-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse42_pcmpestri128:
; AVX:       ## %bb.0:
; AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; AVX-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpestri128(<16 x i8> %a0, i32 7, <16 x i8> %a2, i32 7, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestri128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpestri128_load(<16 x i8>* %a0, <16 x i8>* %a2) {
; X86-SSE-LABEL: test_x86_sse42_pcmpestri128_load:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x08]
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-SSE-NEXT:    movdqa (%eax), %xmm0 ## encoding: [0x66,0x0f,0x6f,0x00]
; X86-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    pcmpestri $7, (%ecx), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0x01,0x07]
; X86-SSE-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX1-LABEL: test_x86_sse42_pcmpestri128_load:
; X86-AVX1:       ## %bb.0:
; X86-AVX1-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x08]
; X86-AVX1-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX1-NEXT:    vmovdqa (%eax), %xmm0 ## encoding: [0xc5,0xf9,0x6f,0x00]
; X86-AVX1-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-AVX1-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-AVX1-NEXT:    vpcmpestri $7, (%ecx), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0x01,0x07]
; X86-AVX1-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X86-AVX1-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX512-LABEL: test_x86_sse42_pcmpestri128_load:
; X86-AVX512:       ## %bb.0:
; X86-AVX512-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x08]
; X86-AVX512-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX512-NEXT:    vmovdqa (%eax), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf9,0x6f,0x00]
; X86-AVX512-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-AVX512-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-AVX512-NEXT:    vpcmpestri $7, (%ecx), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0x01,0x07]
; X86-AVX512-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X86-AVX512-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse42_pcmpestri128_load:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    movdqa (%rdi), %xmm0 ## encoding: [0x66,0x0f,0x6f,0x07]
; X64-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    pcmpestri $7, (%rsi), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0x06,0x07]
; X64-SSE-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX1-LABEL: test_x86_sse42_pcmpestri128_load:
; X64-AVX1:       ## %bb.0:
; X64-AVX1-NEXT:    vmovdqa (%rdi), %xmm0 ## encoding: [0xc5,0xf9,0x6f,0x07]
; X64-AVX1-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-AVX1-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-AVX1-NEXT:    vpcmpestri $7, (%rsi), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0x06,0x07]
; X64-AVX1-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X64-AVX1-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX512-LABEL: test_x86_sse42_pcmpestri128_load:
; X64-AVX512:       ## %bb.0:
; X64-AVX512-NEXT:    vmovdqa (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf9,0x6f,0x07]
; X64-AVX512-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-AVX512-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-AVX512-NEXT:    vpcmpestri $7, (%rsi), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0x06,0x07]
; X64-AVX512-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X64-AVX512-NEXT:    retq ## encoding: [0xc3]
  %1 = load <16 x i8>, <16 x i8>* %a0
  %2 = load <16 x i8>, <16 x i8>* %a2
  %res = call i32 @llvm.x86.sse42.pcmpestri128(<16 x i8> %1, i32 7, <16 x i8> %2, i32 7, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}


define i32 @test_x86_sse42_pcmpestria128(<16 x i8> %a0, <16 x i8> %a2) nounwind {
; X86-SSE-LABEL: test_x86_sse42_pcmpestria128:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-SSE-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X86-SSE-NEXT:    seta %bl ## encoding: [0x0f,0x97,0xc3]
; X86-SSE-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-SSE-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_sse42_pcmpestria128:
; X86-AVX:       ## %bb.0:
; X86-AVX-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-AVX-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X86-AVX-NEXT:    seta %bl ## encoding: [0x0f,0x97,0xc3]
; X86-AVX-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-AVX-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-AVX-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse42_pcmpestria128:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X64-SSE-NEXT:    seta %sil ## encoding: [0x40,0x0f,0x97,0xc6]
; X64-SSE-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_sse42_pcmpestria128:
; X64-AVX:       ## %bb.0:
; X64-AVX-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X64-AVX-NEXT:    seta %sil ## encoding: [0x40,0x0f,0x97,0xc6]
; X64-AVX-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-AVX-NEXT:    retq ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpestria128(<16 x i8> %a0, i32 7, <16 x i8> %a2, i32 7, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestria128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpestric128(<16 x i8> %a0, <16 x i8> %a2) nounwind {
; X86-SSE-LABEL: test_x86_sse42_pcmpestric128:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-SSE-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X86-SSE-NEXT:    setb %bl ## encoding: [0x0f,0x92,0xc3]
; X86-SSE-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-SSE-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_sse42_pcmpestric128:
; X86-AVX:       ## %bb.0:
; X86-AVX-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-AVX-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X86-AVX-NEXT:    setb %bl ## encoding: [0x0f,0x92,0xc3]
; X86-AVX-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-AVX-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-AVX-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse42_pcmpestric128:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X64-SSE-NEXT:    setb %sil ## encoding: [0x40,0x0f,0x92,0xc6]
; X64-SSE-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_sse42_pcmpestric128:
; X64-AVX:       ## %bb.0:
; X64-AVX-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X64-AVX-NEXT:    setb %sil ## encoding: [0x40,0x0f,0x92,0xc6]
; X64-AVX-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-AVX-NEXT:    retq ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpestric128(<16 x i8> %a0, i32 7, <16 x i8> %a2, i32 7, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestric128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpestrio128(<16 x i8> %a0, <16 x i8> %a2) nounwind {
; X86-SSE-LABEL: test_x86_sse42_pcmpestrio128:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-SSE-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X86-SSE-NEXT:    seto %bl ## encoding: [0x0f,0x90,0xc3]
; X86-SSE-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-SSE-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_sse42_pcmpestrio128:
; X86-AVX:       ## %bb.0:
; X86-AVX-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-AVX-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X86-AVX-NEXT:    seto %bl ## encoding: [0x0f,0x90,0xc3]
; X86-AVX-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-AVX-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-AVX-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse42_pcmpestrio128:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X64-SSE-NEXT:    seto %sil ## encoding: [0x40,0x0f,0x90,0xc6]
; X64-SSE-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_sse42_pcmpestrio128:
; X64-AVX:       ## %bb.0:
; X64-AVX-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X64-AVX-NEXT:    seto %sil ## encoding: [0x40,0x0f,0x90,0xc6]
; X64-AVX-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-AVX-NEXT:    retq ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpestrio128(<16 x i8> %a0, i32 7, <16 x i8> %a2, i32 7, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestrio128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpestris128(<16 x i8> %a0, <16 x i8> %a2) nounwind {
; X86-SSE-LABEL: test_x86_sse42_pcmpestris128:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-SSE-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X86-SSE-NEXT:    sets %bl ## encoding: [0x0f,0x98,0xc3]
; X86-SSE-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-SSE-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_sse42_pcmpestris128:
; X86-AVX:       ## %bb.0:
; X86-AVX-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-AVX-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X86-AVX-NEXT:    sets %bl ## encoding: [0x0f,0x98,0xc3]
; X86-AVX-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-AVX-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-AVX-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse42_pcmpestris128:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X64-SSE-NEXT:    sets %sil ## encoding: [0x40,0x0f,0x98,0xc6]
; X64-SSE-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_sse42_pcmpestris128:
; X64-AVX:       ## %bb.0:
; X64-AVX-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X64-AVX-NEXT:    sets %sil ## encoding: [0x40,0x0f,0x98,0xc6]
; X64-AVX-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-AVX-NEXT:    retq ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpestris128(<16 x i8> %a0, i32 7, <16 x i8> %a2, i32 7, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestris128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpestriz128(<16 x i8> %a0, <16 x i8> %a2) nounwind {
; X86-SSE-LABEL: test_x86_sse42_pcmpestriz128:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-SSE-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X86-SSE-NEXT:    sete %bl ## encoding: [0x0f,0x94,0xc3]
; X86-SSE-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-SSE-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_sse42_pcmpestriz128:
; X86-AVX:       ## %bb.0:
; X86-AVX-NEXT:    pushl %ebx ## encoding: [0x53]
; X86-AVX-NEXT:    xorl %ebx, %ebx ## encoding: [0x31,0xdb]
; X86-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X86-AVX-NEXT:    sete %bl ## encoding: [0x0f,0x94,0xc3]
; X86-AVX-NEXT:    movl %ebx, %eax ## encoding: [0x89,0xd8]
; X86-AVX-NEXT:    popl %ebx ## encoding: [0x5b]
; X86-AVX-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse42_pcmpestriz128:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    pcmpestri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x61,0xc1,0x07]
; X64-SSE-NEXT:    sete %sil ## encoding: [0x40,0x0f,0x94,0xc6]
; X64-SSE-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_sse42_pcmpestriz128:
; X64-AVX:       ## %bb.0:
; X64-AVX-NEXT:    xorl %esi, %esi ## encoding: [0x31,0xf6]
; X64-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    vpcmpestri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x61,0xc1,0x07]
; X64-AVX-NEXT:    sete %sil ## encoding: [0x40,0x0f,0x94,0xc6]
; X64-AVX-NEXT:    movl %esi, %eax ## encoding: [0x89,0xf0]
; X64-AVX-NEXT:    retq ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpestriz128(<16 x i8> %a0, i32 7, <16 x i8> %a2, i32 7, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpestriz128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone


define <16 x i8> @test_x86_sse42_pcmpestrm128(<16 x i8> %a0, <16 x i8> %a2) {
; SSE-LABEL: test_x86_sse42_pcmpestrm128:
; SSE:       ## %bb.0:
; SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; SSE-NEXT:    pcmpestrm $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x60,0xc1,0x07]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse42_pcmpestrm128:
; AVX:       ## %bb.0:
; AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; AVX-NEXT:    vpcmpestrm $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x60,0xc1,0x07]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <16 x i8> @llvm.x86.sse42.pcmpestrm128(<16 x i8> %a0, i32 7, <16 x i8> %a2, i32 7, i8 7) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.sse42.pcmpestrm128(<16 x i8>, i32, <16 x i8>, i32, i8) nounwind readnone


define <16 x i8> @test_x86_sse42_pcmpestrm128_load(<16 x i8> %a0, <16 x i8>* %a2) {
; X86-SSE-LABEL: test_x86_sse42_pcmpestrm128_load:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x04]
; X86-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-SSE-NEXT:    pcmpestrm $7, (%ecx), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x60,0x01,0x07]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_sse42_pcmpestrm128_load:
; X86-AVX:       ## %bb.0:
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x04]
; X86-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X86-AVX-NEXT:    vpcmpestrm $7, (%ecx), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x60,0x01,0x07]
; X86-AVX-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse42_pcmpestrm128_load:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-SSE-NEXT:    pcmpestrm $7, (%rdi), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x60,0x07,0x07]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_sse42_pcmpestrm128_load:
; X64-AVX:       ## %bb.0:
; X64-AVX-NEXT:    movl $7, %eax ## encoding: [0xb8,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    movl $7, %edx ## encoding: [0xba,0x07,0x00,0x00,0x00]
; X64-AVX-NEXT:    vpcmpestrm $7, (%rdi), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x60,0x07,0x07]
; X64-AVX-NEXT:    retq ## encoding: [0xc3]
  %1 = load <16 x i8>, <16 x i8>* %a2
  %res = call <16 x i8> @llvm.x86.sse42.pcmpestrm128(<16 x i8> %a0, i32 7, <16 x i8> %1, i32 7, i8 7) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}


define i32 @test_x86_sse42_pcmpistri128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse42_pcmpistri128:
; SSE:       ## %bb.0:
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x63,0xc1,0x07]
; SSE-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse42_pcmpistri128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0xc1,0x07]
; AVX-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpistri128(<16 x i8> %a0, <16 x i8> %a1, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistri128(<16 x i8>, <16 x i8>, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpistri128_load(<16 x i8>* %a0, <16 x i8>* %a1) {
; X86-SSE-LABEL: test_x86_sse42_pcmpistri128_load:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x08]
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x04]
; X86-SSE-NEXT:    movdqa (%ecx), %xmm0 ## encoding: [0x66,0x0f,0x6f,0x01]
; X86-SSE-NEXT:    pcmpistri $7, (%eax), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x63,0x00,0x07]
; X86-SSE-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX1-LABEL: test_x86_sse42_pcmpistri128_load:
; X86-AVX1:       ## %bb.0:
; X86-AVX1-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x08]
; X86-AVX1-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x04]
; X86-AVX1-NEXT:    vmovdqa (%ecx), %xmm0 ## encoding: [0xc5,0xf9,0x6f,0x01]
; X86-AVX1-NEXT:    vpcmpistri $7, (%eax), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0x00,0x07]
; X86-AVX1-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X86-AVX1-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX512-LABEL: test_x86_sse42_pcmpistri128_load:
; X86-AVX512:       ## %bb.0:
; X86-AVX512-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x08]
; X86-AVX512-NEXT:    movl {{[0-9]+}}(%esp), %ecx ## encoding: [0x8b,0x4c,0x24,0x04]
; X86-AVX512-NEXT:    vmovdqa (%ecx), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf9,0x6f,0x01]
; X86-AVX512-NEXT:    vpcmpistri $7, (%eax), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0x00,0x07]
; X86-AVX512-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X86-AVX512-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse42_pcmpistri128_load:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    movdqa (%rdi), %xmm0 ## encoding: [0x66,0x0f,0x6f,0x07]
; X64-SSE-NEXT:    pcmpistri $7, (%rsi), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x63,0x06,0x07]
; X64-SSE-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX1-LABEL: test_x86_sse42_pcmpistri128_load:
; X64-AVX1:       ## %bb.0:
; X64-AVX1-NEXT:    vmovdqa (%rdi), %xmm0 ## encoding: [0xc5,0xf9,0x6f,0x07]
; X64-AVX1-NEXT:    vpcmpistri $7, (%rsi), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0x06,0x07]
; X64-AVX1-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X64-AVX1-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX512-LABEL: test_x86_sse42_pcmpistri128_load:
; X64-AVX512:       ## %bb.0:
; X64-AVX512-NEXT:    vmovdqa (%rdi), %xmm0 ## EVEX TO VEX Compression encoding: [0xc5,0xf9,0x6f,0x07]
; X64-AVX512-NEXT:    vpcmpistri $7, (%rsi), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0x06,0x07]
; X64-AVX512-NEXT:    movl %ecx, %eax ## encoding: [0x89,0xc8]
; X64-AVX512-NEXT:    retq ## encoding: [0xc3]
  %1 = load <16 x i8>, <16 x i8>* %a0
  %2 = load <16 x i8>, <16 x i8>* %a1
  %res = call i32 @llvm.x86.sse42.pcmpistri128(<16 x i8> %1, <16 x i8> %2, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}


define i32 @test_x86_sse42_pcmpistria128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse42_pcmpistria128:
; SSE:       ## %bb.0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x63,0xc1,0x07]
; SSE-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse42_pcmpistria128:
; AVX:       ## %bb.0:
; AVX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0xc1,0x07]
; AVX-NEXT:    seta %al ## encoding: [0x0f,0x97,0xc0]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpistria128(<16 x i8> %a0, <16 x i8> %a1, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistria128(<16 x i8>, <16 x i8>, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpistric128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse42_pcmpistric128:
; SSE:       ## %bb.0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x63,0xc1,0x07]
; SSE-NEXT:    setb %al ## encoding: [0x0f,0x92,0xc0]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse42_pcmpistric128:
; AVX:       ## %bb.0:
; AVX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0xc1,0x07]
; AVX-NEXT:    setb %al ## encoding: [0x0f,0x92,0xc0]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpistric128(<16 x i8> %a0, <16 x i8> %a1, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistric128(<16 x i8>, <16 x i8>, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpistrio128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse42_pcmpistrio128:
; SSE:       ## %bb.0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x63,0xc1,0x07]
; SSE-NEXT:    seto %al ## encoding: [0x0f,0x90,0xc0]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse42_pcmpistrio128:
; AVX:       ## %bb.0:
; AVX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0xc1,0x07]
; AVX-NEXT:    seto %al ## encoding: [0x0f,0x90,0xc0]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpistrio128(<16 x i8> %a0, <16 x i8> %a1, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistrio128(<16 x i8>, <16 x i8>, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpistris128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse42_pcmpistris128:
; SSE:       ## %bb.0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x63,0xc1,0x07]
; SSE-NEXT:    sets %al ## encoding: [0x0f,0x98,0xc0]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse42_pcmpistris128:
; AVX:       ## %bb.0:
; AVX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0xc1,0x07]
; AVX-NEXT:    sets %al ## encoding: [0x0f,0x98,0xc0]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpistris128(<16 x i8> %a0, <16 x i8> %a1, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistris128(<16 x i8>, <16 x i8>, i8) nounwind readnone


define i32 @test_x86_sse42_pcmpistriz128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse42_pcmpistriz128:
; SSE:       ## %bb.0:
; SSE-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; SSE-NEXT:    pcmpistri $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x63,0xc1,0x07]
; SSE-NEXT:    sete %al ## encoding: [0x0f,0x94,0xc0]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse42_pcmpistriz128:
; AVX:       ## %bb.0:
; AVX-NEXT:    xorl %eax, %eax ## encoding: [0x31,0xc0]
; AVX-NEXT:    vpcmpistri $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x63,0xc1,0x07]
; AVX-NEXT:    sete %al ## encoding: [0x0f,0x94,0xc0]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call i32 @llvm.x86.sse42.pcmpistriz128(<16 x i8> %a0, <16 x i8> %a1, i8 7) ; <i32> [#uses=1]
  ret i32 %res
}
declare i32 @llvm.x86.sse42.pcmpistriz128(<16 x i8>, <16 x i8>, i8) nounwind readnone


define <16 x i8> @test_x86_sse42_pcmpistrm128(<16 x i8> %a0, <16 x i8> %a1) {
; SSE-LABEL: test_x86_sse42_pcmpistrm128:
; SSE:       ## %bb.0:
; SSE-NEXT:    pcmpistrm $7, %xmm1, %xmm0 ## encoding: [0x66,0x0f,0x3a,0x62,0xc1,0x07]
; SSE-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
;
; AVX-LABEL: test_x86_sse42_pcmpistrm128:
; AVX:       ## %bb.0:
; AVX-NEXT:    vpcmpistrm $7, %xmm1, %xmm0 ## encoding: [0xc4,0xe3,0x79,0x62,0xc1,0x07]
; AVX-NEXT:    ret{{[l|q]}} ## encoding: [0xc3]
  %res = call <16 x i8> @llvm.x86.sse42.pcmpistrm128(<16 x i8> %a0, <16 x i8> %a1, i8 7) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}
declare <16 x i8> @llvm.x86.sse42.pcmpistrm128(<16 x i8>, <16 x i8>, i8) nounwind readnone


define <16 x i8> @test_x86_sse42_pcmpistrm128_load(<16 x i8> %a0, <16 x i8>* %a1) {
; X86-SSE-LABEL: test_x86_sse42_pcmpistrm128_load:
; X86-SSE:       ## %bb.0:
; X86-SSE-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-SSE-NEXT:    pcmpistrm $7, (%eax), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x62,0x00,0x07]
; X86-SSE-NEXT:    retl ## encoding: [0xc3]
;
; X86-AVX-LABEL: test_x86_sse42_pcmpistrm128_load:
; X86-AVX:       ## %bb.0:
; X86-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax ## encoding: [0x8b,0x44,0x24,0x04]
; X86-AVX-NEXT:    vpcmpistrm $7, (%eax), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x62,0x00,0x07]
; X86-AVX-NEXT:    retl ## encoding: [0xc3]
;
; X64-SSE-LABEL: test_x86_sse42_pcmpistrm128_load:
; X64-SSE:       ## %bb.0:
; X64-SSE-NEXT:    pcmpistrm $7, (%rdi), %xmm0 ## encoding: [0x66,0x0f,0x3a,0x62,0x07,0x07]
; X64-SSE-NEXT:    retq ## encoding: [0xc3]
;
; X64-AVX-LABEL: test_x86_sse42_pcmpistrm128_load:
; X64-AVX:       ## %bb.0:
; X64-AVX-NEXT:    vpcmpistrm $7, (%rdi), %xmm0 ## encoding: [0xc4,0xe3,0x79,0x62,0x07,0x07]
; X64-AVX-NEXT:    retq ## encoding: [0xc3]
  %1 = load <16 x i8>, <16 x i8>* %a1, align 1
  %res = call <16 x i8> @llvm.x86.sse42.pcmpistrm128(<16 x i8> %a0, <16 x i8> %1, i8 7) ; <<16 x i8>> [#uses=1]
  ret <16 x i8> %res
}
