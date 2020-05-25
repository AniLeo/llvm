; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx  | FileCheck %s --check-prefixes=CHECK,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=CHECK,AVX2

;
; testz(~X,Y) -> testc(X,Y)
;

define i32 @ptestz_128_invert0(<2 x i64> %c, <2 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_128_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %xmm1, %xmm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t1 = xor <2 x i64> %c, <i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %t1, <2 x i64> %d)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestz_256_invert0(<4 x i64> %c, <4 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_256_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %ymm1, %ymm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = xor <4 x i64> %c, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.avx.ptestz.256(<4 x i64> %t1, <4 x i64> %d)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

;
; testz(X,~Y) -> testc(Y,X)
;

define i32 @ptestz_128_invert1(<2 x i64> %c, <2 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_128_invert1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %xmm0, %xmm1
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t1 = xor <2 x i64> %d, <i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %c, <2 x i64> %t1)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestz_256_invert1(<4 x i64> %c, <4 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_256_invert1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %ymm0, %ymm1
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = xor <4 x i64> %d, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.avx.ptestz.256(<4 x i64> %c, <4 x i64> %t1)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

;
; testc(~X,Y) -> testz(X,Y)
;

define i32 @ptestc_128_invert0(<2 x i64> %c, <2 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestc_128_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %xmm1, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t1 = xor <2 x i64> %c, <i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.sse41.ptestc(<2 x i64> %t1, <2 x i64> %d)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestc_256_invert0(<4 x i64> %c, <4 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestc_256_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %ymm1, %ymm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = xor <4 x i64> %c, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.avx.ptestc.256(<4 x i64> %t1, <4 x i64> %d)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

;
; testnzc(~X,Y) -> testnzc(X,Y)
;

define i32 @ptestnzc_128_invert0(<2 x i64> %c, <2 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestnzc_128_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %xmm1, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t1 = xor <2 x i64> %c, <i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.sse41.ptestc(<2 x i64> %t1, <2 x i64> %d)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestnzc_256_invert0(<4 x i64> %c, <4 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestnzc_256_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %ymm1, %ymm0
; CHECK-NEXT:    cmovbel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = xor <4 x i64> %c, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.avx.ptestnzc.256(<4 x i64> %t1, <4 x i64> %d)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestnzc_256_invert0_commute(<4 x i64> %c, <4 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestnzc_256_invert0_commute:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %ymm1, %ymm0
; CHECK-NEXT:    cmoval %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = xor <4 x i64> %c, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = call i32 @llvm.x86.avx.ptestnzc.256(<4 x i64> %t1, <4 x i64> %d)
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

;
; testz(AND(X,Y),AND(X,Y)) -> testz(X,Y)
;

define i32 @ptestz_128_and(<2 x i64> %c, <2 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_128_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %xmm1, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t1 = and <2 x i64> %c, %d
  %t2 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %t1, <2 x i64> %t1)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestz_256_and(<4 x i64> %c, <4 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_256_and:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %ymm1, %ymm0
; CHECK-NEXT:    cmovel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = and <4 x i64> %c, %d
  %t2 = call i32 @llvm.x86.avx.ptestz.256(<4 x i64> %t1, <4 x i64> %t1)
  %t3 = icmp eq i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

;
; testz(AND(~X,Y),AND(~X,Y)) -> testc(X,Y)
;

define i32 @ptestz_128_andc(<2 x i64> %c, <2 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_128_andc:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %xmm1, %xmm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t1 = xor <2 x i64> %c, <i64 -1, i64 -1>
  %t2 = and <2 x i64> %t1, %d
  %t3 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %t2, <2 x i64> %t2)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @ptestz_256_andc(<4 x i64> %c, <4 x i64> %d, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_256_andc:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %ymm1, %ymm0
; CHECK-NEXT:    cmovbl %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = xor <4 x i64> %c, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = and <4 x i64> %t1, %d
  %t3 = call i32 @llvm.x86.avx.ptestz.256(<4 x i64> %t2, <4 x i64> %t2)
  %t4 = icmp eq i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

;
; testz(-1,X) -> testz(X,X)
;

define i32 @ptestz_128_allones0(<2 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_128_allones0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %xmm0, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t1 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> <i64 -1, i64 -1>, <2 x i64> %c)
  %t2 = icmp ne i32 %t1, 0
  %t3 = select i1 %t2, i32 %a, i32 %b
  ret i32 %t3
}

define i32 @ptestz_256_allones0(<4 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_256_allones0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %ymm0, %ymm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = call i32 @llvm.x86.avx.ptestz.256(<4 x i64> <i64 -1, i64 -1, i64 -1, i64 -1>, <4 x i64> %c)
  %t2 = icmp ne i32 %t1, 0
  %t3 = select i1 %t2, i32 %a, i32 %b
  ret i32 %t3
}

;
; testz(X,-1) -> testz(X,X)
;

define i32 @ptestz_128_allones1(<2 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_128_allones1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %xmm0, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t1 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %c, <2 x i64> <i64 -1, i64 -1>)
  %t2 = icmp ne i32 %t1, 0
  %t3 = select i1 %t2, i32 %a, i32 %b
  ret i32 %t3
}

define i32 @ptestz_256_allones1(<4 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_256_allones1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vptest %ymm0, %ymm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t1 = call i32 @llvm.x86.avx.ptestz.256(<4 x i64> %c, <4 x i64> <i64 -1, i64 -1, i64 -1, i64 -1>)
  %t2 = icmp ne i32 %t1, 0
  %t3 = select i1 %t2, i32 %a, i32 %b
  ret i32 %t3
}

define zeroext i1 @PR38522(<16 x i8>* %x, <16 x i8>* %y) {
; CHECK-LABEL: PR38522:
; CHECK:       # %bb.0: # %start
; CHECK-NEXT:    vmovdqa (%rdi), %xmm0
; CHECK-NEXT:    vpcmpgtb (%rsi), %xmm0, %xmm0
; CHECK-NEXT:    vptest %xmm0, %xmm0
; CHECK-NEXT:    sete %al
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

;
; TODO: testz(ashr(X,bw-1),-1) -> movmsk(X)
;

define i32 @ptestz_v2i64_signbits(<2 x i64> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_v2i64_signbits:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vpcmpgtq %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    vptest %xmm0, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t1 = ashr <2 x i64> %c, <i64 63, i64 63>
  %t2 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %t1, <2 x i64> <i64 -1, i64 -1>)
  %t3 = icmp ne i32 %t2, 0
  %t4 = select i1 %t3, i32 %a, i32 %b
  ret i32 %t4
}

define i32 @ptestz_v8i32_signbits(<8 x i32> %c, i32 %a, i32 %b) {
; AVX1-LABEL: ptestz_v8i32_signbits:
; AVX1:       # %bb.0:
; AVX1-NEXT:    movl %edi, %eax
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpsrad $31, %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    vptest %ymm0, %ymm0
; AVX1-NEXT:    cmovnel %esi, %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ptestz_v8i32_signbits:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movl %edi, %eax
; AVX2-NEXT:    vpsrad $31, %ymm0, %ymm0
; AVX2-NEXT:    vptest %ymm0, %ymm0
; AVX2-NEXT:    cmovnel %esi, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %t1 = ashr <8 x i32> %c, <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>
  %t2 = bitcast <8 x i32> %t1 to <4 x i64>
  %t3 = call i32 @llvm.x86.avx.ptestz.256(<4 x i64> %t2, <4 x i64> <i64 -1, i64 -1, i64 -1, i64 -1>)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @ptestz_v8i16_signbits(<8 x i16> %c, i32 %a, i32 %b) {
; CHECK-LABEL: ptestz_v8i16_signbits:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vpsraw $15, %xmm0, %xmm0
; CHECK-NEXT:    vptest %xmm0, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t1 = ashr <8 x i16> %c, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %t2 = bitcast <8 x i16> %t1 to <2 x i64>
  %t3 = call i32 @llvm.x86.sse41.ptestz(<2 x i64> %t2, <2 x i64> <i64 -1, i64 -1>)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @ptestz_v32i8_signbits(<32 x i8> %c, i32 %a, i32 %b) {
; AVX1-LABEL: ptestz_v32i8_signbits:
; AVX1:       # %bb.0:
; AVX1-NEXT:    movl %edi, %eax
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpxor %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vpcmpgtb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtb %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    vptest %ymm0, %ymm0
; AVX1-NEXT:    cmovnel %esi, %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: ptestz_v32i8_signbits:
; AVX2:       # %bb.0:
; AVX2-NEXT:    movl %edi, %eax
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtb %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vptest %ymm0, %ymm0
; AVX2-NEXT:    cmovnel %esi, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
  %t1 = ashr <32 x i8> %c, <i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7, i8 7>
  %t2 = bitcast <32 x i8> %t1 to <4 x i64>
  %t3 = call i32 @llvm.x86.avx.ptestz.256(<4 x i64> %t2, <4 x i64> <i64 -1, i64 -1, i64 -1, i64 -1>)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

declare i32 @llvm.x86.sse41.ptestz(<2 x i64>, <2 x i64>) nounwind readnone
declare i32 @llvm.x86.sse41.ptestc(<2 x i64>, <2 x i64>) nounwind readnone
declare i32 @llvm.x86.sse41.ptestnzc(<2 x i64>, <2 x i64>) nounwind readnone

declare i32 @llvm.x86.avx.ptestz.256(<4 x i64>, <4 x i64>)
declare i32 @llvm.x86.avx.ptestc.256(<4 x i64>, <4 x i64>)
declare i32 @llvm.x86.avx.ptestnzc.256(<4 x i64>, <4 x i64>)
