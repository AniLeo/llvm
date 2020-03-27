; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s

define i32 @ptestz_128_invert(<2 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_128_invert:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vptest %xmm1, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t1 = xor <2 x i64> %c, <i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %t1, <2 x i64> <i64 -1, i64 -1>)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestz_256_invert(<4 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_256_invert:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; CHECK-NEXT:    vxorps %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vptest %ymm1, %ymm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = xor <4 x i64> %c, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.avx.ptestz.256(<4 x i64> %t1, <4 x i64> <i64 -1, i64 -1, i64 -1, i64 -1>)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestc_128_invert(<2 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestc_128_invert:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vptest %xmm1, %xmm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t1 = xor <2 x i64> %c, <i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.sse41.ptestc(<2 x i64> %t1, <2 x i64> <i64 -1, i64 -1>)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestc_256_invert(<4 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestc_256_invert:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; CHECK-NEXT:    vxorps %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vptest %ymm1, %ymm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = xor <4 x i64> %c, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.avx.ptestc.256(<4 x i64> %t1, <4 x i64> <i64 -1, i64 -1, i64 -1, i64 -1>)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestnzc_128_invert(<2 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestnzc_128_invert:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vptest %xmm1, %xmm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t1 = xor <2 x i64> %c, <i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.sse41.ptestc(<2 x i64> %t1, <2 x i64> <i64 -1, i64 -1>)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestnzc_256_invert(<4 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestnzc_256_invert:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vcmptrueps %ymm1, %ymm1, %ymm1
; CHECK-NEXT:    vxorps %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    vptest %ymm1, %ymm0
; CHECK-NEXT:    cmovbel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = xor <4 x i64> %c, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.avx.ptestnzc.256(<4 x i64> %t1, <4 x i64> <i64 -1, i64 -1, i64 -1, i64 -1>)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define zeroext i1 @PR38522(<16 x i8>* %x, <16 x i8>* %y) {
; CHECK-LABEL: PR38522:
; CHECK:       # %bb.0: # %start
; CHECK-NEXT:    vmovdqa (%rdi), %xmm0
; CHECK-NEXT:    vpcmpgtb (%rsi), %xmm0, %xmm0
; CHECK-NEXT:    vpcmpeqd %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vptest %xmm1, %xmm0
; CHECK-NEXT:    setb %al
; CHECK-NEXT:    retq
start:
  %0 = load <16 x i8>, <16 x i8>* %x, align 16
  %1 = load <16 x i8>, <16 x i8>* %y, align 16
  %2 = icmp sle <16 x i8> %0, %1
  %3 = sext <16 x i1> %2 to <16 x i8>
  %4 = bitcast <16 x i8> %3 to <2 x i64>
  %5 = tail call i32 @llvm.x86.sse41.ptestc(<2 x i64> %4, <2 x i64> <i64 -1, i64 -1>)
  %6 = icmp eq i32 %5, 1
  ret i1 %6
}

declare i32 @llvm.x86.sse41.ptestz(<2 x i64>, <2 x i64>) nounwind readnone
declare i32 @llvm.x86.sse41.ptestc(<2 x i64>, <2 x i64>) nounwind readnone
declare i32 @llvm.x86.sse41.ptestnzc(<2 x i64>, <2 x i64>) nounwind readnone

declare i32 @llvm.x86.avx.ptestz.256(<4 x i64>, <4 x i64>)
declare i32 @llvm.x86.avx.ptestc.256(<4 x i64>, <4 x i64>)
declare i32 @llvm.x86.avx.ptestnzc.256(<4 x i64>, <4 x i64>)
