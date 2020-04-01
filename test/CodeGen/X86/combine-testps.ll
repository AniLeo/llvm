; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s

;
; testz(~X,Y) -> testc(X,Y)
;

define i32 @testpsz_128_invert0(<4 x float> %c, <4 x float> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpsz_128_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestps %xmm1, %xmm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t0 = bitcast <4 x float> %c to <2 x i64>
  %t1 = xor <2 x i64> %t0, <i64 -1, i64 -1>
  %t2 = bitcast <2 x i64> %t1 to <4 x float>
  %t3 = call i32 @llvm.x86.avx.vtestz.ps(<4 x float> %t2, <4 x float> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @testpsz_256_invert0(<8 x float> %c, <8 x float> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpsz_256_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestps %ymm1, %ymm0
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t0 = bitcast <8 x float> %c to <4 x i64>
  %t1 = xor <4 x i64> %t0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = bitcast <4 x i64> %t1 to <8 x float>
  %t3 = call i32 @llvm.x86.avx.vtestz.ps.256(<8 x float> %t2, <8 x float> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

;
; testz(X,~Y) -> testc(Y,X)
;

define i32 @testpsz_128_invert1(<4 x float> %c, <4 x float> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpsz_128_invert1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestps %xmm0, %xmm1
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    retq
  %t0 = bitcast <4 x float> %d to <2 x i64>
  %t1 = xor <2 x i64> %t0, <i64 -1, i64 -1>
  %t2 = bitcast <2 x i64> %t1 to <4 x float>
  %t3 = call i32 @llvm.x86.avx.vtestz.ps(<4 x float> %c, <4 x float> %t2)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @testpsz_256_invert1(<8 x float> %c, <8 x float> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpsz_256_invert1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestps %ymm0, %ymm1
; CHECK-NEXT:    cmovael %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t0 = bitcast <8 x float> %d to <4 x i64>
  %t1 = xor <4 x i64> %t0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = bitcast <4 x i64> %t1 to <8 x float>
  %t3 = call i32 @llvm.x86.avx.vtestz.ps.256(<8 x float> %c, <8 x float> %t2)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

;
; testc(~X,Y) -> testz(X,Y)
;

define i32 @testpsc_128_invert0(<4 x float> %c, <4 x float> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpsc_128_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestps %xmm1, %xmm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = bitcast <4 x float> %c to <2 x i64>
  %t1 = xor <2 x i64> %t0, <i64 -1, i64 -1>
  %t2 = bitcast <2 x i64> %t1 to <4 x float>
  %t3 = call i32 @llvm.x86.avx.vtestc.ps(<4 x float> %t2, <4 x float> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @testpsc_256_invert0(<8 x float> %c, <8 x float> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpsc_256_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestps %ymm1, %ymm0
; CHECK-NEXT:    cmovnel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t0 = bitcast <8 x float> %c to <4 x i64>
  %t1 = xor <4 x i64> %t0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = bitcast <4 x i64> %t1 to <8 x float>
  %t3 = call i32 @llvm.x86.avx.vtestc.ps.256(<8 x float> %t2, <8 x float> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

;
; testnzc(~X,Y) -> testnzc(X,Y)
;

define i32 @testpsnzc_128_invert0(<4 x float> %c, <4 x float> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpsnzc_128_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestps %xmm1, %xmm0
; CHECK-NEXT:    cmovbel %esi, %eax
; CHECK-NEXT:    retq
  %t0 = bitcast <4 x float> %c to <2 x i64>
  %t1 = xor <2 x i64> %t0, <i64 -1, i64 -1>
  %t2 = bitcast <2 x i64> %t1 to <4 x float>
  %t3 = call i32 @llvm.x86.avx.vtestnzc.ps(<4 x float> %t2, <4 x float> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

define i32 @testpsnzc_256_invert0(<8 x float> %c, <8 x float> %d, i32 %a, i32 %b) {
; CHECK-LABEL: testpsnzc_256_invert0:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movl %edi, %eax
; CHECK-NEXT:    vtestps %ymm1, %ymm0
; CHECK-NEXT:    cmovbel %esi, %eax
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %t0 = bitcast <8 x float> %c to <4 x i64>
  %t1 = xor <4 x i64> %t0, <i64 -1, i64 -1, i64 -1, i64 -1>
  %t2 = bitcast <4 x i64> %t1 to <8 x float>
  %t3 = call i32 @llvm.x86.avx.vtestnzc.ps.256(<8 x float> %t2, <8 x float> %d)
  %t4 = icmp ne i32 %t3, 0
  %t5 = select i1 %t4, i32 %a, i32 %b
  ret i32 %t5
}

declare i32 @llvm.x86.avx.vtestz.ps(<4 x float>, <4 x float>) nounwind readnone
declare i32 @llvm.x86.avx.vtestc.ps(<4 x float>, <4 x float>) nounwind readnone
declare i32 @llvm.x86.avx.vtestnzc.ps(<4 x float>, <4 x float>) nounwind readnone

declare i32 @llvm.x86.avx.vtestz.ps.256(<8 x float>, <8 x float>) nounwind readnone
declare i32 @llvm.x86.avx.vtestc.ps.256(<8 x float>, <8 x float>) nounwind readnone
declare i32 @llvm.x86.avx.vtestnzc.ps.256(<8 x float>, <8 x float>) nounwind readnone
