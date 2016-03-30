; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s --check-prefix=SSE --check-prefix=SSE2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2

;
; PR6455 'Clear Upper Bits' Patterns
;

define <2 x i64> @_clearupper2xi64a(<2 x i64>) nounwind {
; SSE-LABEL: _clearupper2xi64a:
; SSE:       # BB#0:
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: _clearupper2xi64a:
; AVX:       # BB#0:
; AVX-NEXT:    vpshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; AVX-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <2 x i64> %0, i32 0
  %x1 = extractelement <2 x i64> %0, i32 1
  %trunc0 = trunc i64 %x0 to i32
  %trunc1 = trunc i64 %x1 to i32
  %ext0 = zext i32 %trunc0 to i64
  %ext1 = zext i32 %trunc1 to i64
  %v0 = insertelement <2 x i64> undef, i64 %ext0, i32 0
  %v1 = insertelement <2 x i64> %v0,   i64 %ext1, i32 1
  ret <2 x i64> %v1
}

define <4 x i32> @_clearupper4xi32a(<4 x i32>) nounwind {
; SSE-LABEL: _clearupper4xi32a:
; SSE:       # BB#0:
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[1,1,2,3]
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm0[2,3,0,1]
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm0[3,1,2,3]
; SSE-NEXT:    punpckldq {{.*#+}} xmm1 = xmm1[0],xmm3[0],xmm1[1],xmm3[1]
; SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1]
; SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: _clearupper4xi32a:
; AVX1:       # BB#0:
; AVX1-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: _clearupper4xi32a:
; AVX2:       # BB#0:
; AVX2-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; AVX2-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    retq
  %x0 = extractelement <4 x i32> %0, i32 0
  %x1 = extractelement <4 x i32> %0, i32 1
  %x2 = extractelement <4 x i32> %0, i32 2
  %x3 = extractelement <4 x i32> %0, i32 3
  %trunc0 = trunc i32 %x0 to i16
  %trunc1 = trunc i32 %x1 to i16
  %trunc2 = trunc i32 %x2 to i16
  %trunc3 = trunc i32 %x3 to i16
  %ext0 = zext i16 %trunc0 to i32
  %ext1 = zext i16 %trunc1 to i32
  %ext2 = zext i16 %trunc2 to i32
  %ext3 = zext i16 %trunc3 to i32
  %v0 = insertelement <4 x i32> undef, i32 %ext0, i32 0
  %v1 = insertelement <4 x i32> %v0,   i32 %ext1, i32 1
  %v2 = insertelement <4 x i32> %v1,   i32 %ext2, i32 2
  %v3 = insertelement <4 x i32> %v2,   i32 %ext3, i32 3
  ret <4 x i32> %v3
}

define <8 x i16> @_clearupper8xi16a(<8 x i16>) nounwind {
; SSE-LABEL: _clearupper8xi16a:
; SSE:       # BB#0:
; SSE-NEXT:    pextrw $1, %xmm0, %eax
; SSE-NEXT:    pextrw $2, %xmm0, %r9d
; SSE-NEXT:    pextrw $3, %xmm0, %edx
; SSE-NEXT:    pextrw $4, %xmm0, %r8d
; SSE-NEXT:    pextrw $5, %xmm0, %edi
; SSE-NEXT:    pextrw $6, %xmm0, %esi
; SSE-NEXT:    pextrw $7, %xmm0, %ecx
; SSE-NEXT:    movd %ecx, %xmm1
; SSE-NEXT:    movd %edx, %xmm2
; SSE-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3]
; SSE-NEXT:    movd %edi, %xmm1
; SSE-NEXT:    movd %eax, %xmm3
; SSE-NEXT:    punpcklwd {{.*#+}} xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3]
; SSE-NEXT:    punpcklwd {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3]
; SSE-NEXT:    movd %esi, %xmm1
; SSE-NEXT:    movd %r9d, %xmm2
; SSE-NEXT:    punpcklwd {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3]
; SSE-NEXT:    movd %r8d, %xmm1
; SSE-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3]
; SSE-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3]
; SSE-NEXT:    punpcklwd {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1],xmm0[2],xmm3[2],xmm0[3],xmm3[3]
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: _clearupper8xi16a:
; AVX:       # BB#0:
; AVX-NEXT:    vpextrw $1, %xmm0, %eax
; AVX-NEXT:    vpextrw $2, %xmm0, %ecx
; AVX-NEXT:    vpextrw $3, %xmm0, %edx
; AVX-NEXT:    vpextrw $4, %xmm0, %esi
; AVX-NEXT:    vpextrw $5, %xmm0, %edi
; AVX-NEXT:    vpextrw $6, %xmm0, %r8d
; AVX-NEXT:    vpextrw $7, %xmm0, %r9d
; AVX-NEXT:    vpinsrw $1, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrw $2, %ecx, %xmm0, %xmm0
; AVX-NEXT:    vpinsrw $3, %edx, %xmm0, %xmm0
; AVX-NEXT:    vpinsrw $4, %esi, %xmm0, %xmm0
; AVX-NEXT:    vpinsrw $5, %edi, %xmm0, %xmm0
; AVX-NEXT:    vpinsrw $6, %r8d, %xmm0, %xmm0
; AVX-NEXT:    vpinsrw $7, %r9d, %xmm0, %xmm0
; AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x0 = extractelement <8 x i16> %0, i32 0
  %x1 = extractelement <8 x i16> %0, i32 1
  %x2 = extractelement <8 x i16> %0, i32 2
  %x3 = extractelement <8 x i16> %0, i32 3
  %x4 = extractelement <8 x i16> %0, i32 4
  %x5 = extractelement <8 x i16> %0, i32 5
  %x6 = extractelement <8 x i16> %0, i32 6
  %x7 = extractelement <8 x i16> %0, i32 7
  %trunc0 = trunc i16 %x0 to i8
  %trunc1 = trunc i16 %x1 to i8
  %trunc2 = trunc i16 %x2 to i8
  %trunc3 = trunc i16 %x3 to i8
  %trunc4 = trunc i16 %x4 to i8
  %trunc5 = trunc i16 %x5 to i8
  %trunc6 = trunc i16 %x6 to i8
  %trunc7 = trunc i16 %x7 to i8
  %ext0 = zext i8 %trunc0 to i16
  %ext1 = zext i8 %trunc1 to i16
  %ext2 = zext i8 %trunc2 to i16
  %ext3 = zext i8 %trunc3 to i16
  %ext4 = zext i8 %trunc4 to i16
  %ext5 = zext i8 %trunc5 to i16
  %ext6 = zext i8 %trunc6 to i16
  %ext7 = zext i8 %trunc7 to i16
  %v0 = insertelement <8 x i16> undef, i16 %ext0, i32 0
  %v1 = insertelement <8 x i16> %v0,   i16 %ext1, i32 1
  %v2 = insertelement <8 x i16> %v1,   i16 %ext2, i32 2
  %v3 = insertelement <8 x i16> %v2,   i16 %ext3, i32 3
  %v4 = insertelement <8 x i16> %v3,   i16 %ext4, i32 4
  %v5 = insertelement <8 x i16> %v4,   i16 %ext5, i32 5
  %v6 = insertelement <8 x i16> %v5,   i16 %ext6, i32 6
  %v7 = insertelement <8 x i16> %v6,   i16 %ext7, i32 7
  ret <8 x i16> %v7
}

define <16 x i8> @_clearupper16xi8a(<16 x i8>) nounwind {
; SSE-LABEL: _clearupper16xi8a:
; SSE:       # BB#0:
; SSE-NEXT:    movaps %xmm0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %eax
; SSE-NEXT:    movd %eax, %xmm0
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %r9d
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %esi
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %r8d
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edi
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %eax
; SSE-NEXT:    movd %eax, %xmm1
; SSE-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE-NEXT:    movd %esi, %xmm0
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %eax
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %esi
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE-NEXT:    movd %ecx, %xmm2
; SSE-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
; SSE-NEXT:    movd %edx, %xmm0
; SSE-NEXT:    movd %esi, %xmm1
; SSE-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE-NEXT:    movd %edi, %xmm0
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %ecx
; SSE-NEXT:    movzbl -{{[0-9]+}}(%rsp), %edx
; SSE-NEXT:    movd %edx, %xmm3
; SSE-NEXT:    punpcklbw {{.*#+}} xmm3 = xmm3[0],xmm0[0],xmm3[1],xmm0[1],xmm3[2],xmm0[2],xmm3[3],xmm0[3],xmm3[4],xmm0[4],xmm3[5],xmm0[5],xmm3[6],xmm0[6],xmm3[7],xmm0[7]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1],xmm3[2],xmm1[2],xmm3[3],xmm1[3],xmm3[4],xmm1[4],xmm3[5],xmm1[5],xmm3[6],xmm1[6],xmm3[7],xmm1[7]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm3 = xmm3[0],xmm2[0],xmm3[1],xmm2[1],xmm3[2],xmm2[2],xmm3[3],xmm2[3],xmm3[4],xmm2[4],xmm3[5],xmm2[5],xmm3[6],xmm2[6],xmm3[7],xmm2[7]
; SSE-NEXT:    movd %r9d, %xmm0
; SSE-NEXT:    movd %eax, %xmm1
; SSE-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE-NEXT:    movd %r8d, %xmm0
; SSE-NEXT:    movd %ecx, %xmm2
; SSE-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm0[0],xmm2[1],xmm0[1],xmm2[2],xmm0[2],xmm2[3],xmm0[3],xmm2[4],xmm0[4],xmm2[5],xmm0[5],xmm2[6],xmm0[6],xmm2[7],xmm0[7]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1],xmm2[2],xmm1[2],xmm2[3],xmm1[3],xmm2[4],xmm1[4],xmm2[5],xmm1[5],xmm2[6],xmm1[6],xmm2[7],xmm1[7]
; SSE-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    movd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; SSE-NEXT:    punpcklbw {{.*#+}} xmm1 = xmm1[0],xmm0[0],xmm1[1],xmm0[1],xmm1[2],xmm0[2],xmm1[3],xmm0[3],xmm1[4],xmm0[4],xmm1[5],xmm0[5],xmm1[6],xmm0[6],xmm1[7],xmm0[7]
; SSE-NEXT:    movd {{.*#+}} xmm4 = mem[0],zero,zero,zero
; SSE-NEXT:    movd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm4[0],xmm0[1],xmm4[1],xmm0[2],xmm4[2],xmm0[3],xmm4[3],xmm0[4],xmm4[4],xmm0[5],xmm4[5],xmm0[6],xmm4[6],xmm0[7],xmm4[7]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1],xmm0[2],xmm1[2],xmm0[3],xmm1[3],xmm0[4],xmm1[4],xmm0[5],xmm1[5],xmm0[6],xmm1[6],xmm0[7],xmm1[7]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm2[0],xmm0[1],xmm2[1],xmm0[2],xmm2[2],xmm0[3],xmm2[3],xmm0[4],xmm2[4],xmm0[5],xmm2[5],xmm0[6],xmm2[6],xmm0[7],xmm2[7]
; SSE-NEXT:    punpcklbw {{.*#+}} xmm0 = xmm0[0],xmm3[0],xmm0[1],xmm3[1],xmm0[2],xmm3[2],xmm0[3],xmm3[3],xmm0[4],xmm3[4],xmm0[5],xmm3[5],xmm0[6],xmm3[6],xmm0[7],xmm3[7]
; SSE-NEXT:    pand {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: _clearupper16xi8a:
; AVX:       # BB#0:
; AVX-NEXT:    vpextrb $0, %xmm0, %eax
; AVX-NEXT:    vmovd %eax, %xmm1
; AVX-NEXT:    vpextrb $1, %xmm0, %eax
; AVX-NEXT:    vpinsrb $1, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $2, %xmm0, %eax
; AVX-NEXT:    vpinsrb $2, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $3, %xmm0, %eax
; AVX-NEXT:    vpinsrb $3, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $4, %xmm0, %eax
; AVX-NEXT:    vpinsrb $4, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $5, %xmm0, %eax
; AVX-NEXT:    vpinsrb $5, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $6, %xmm0, %eax
; AVX-NEXT:    vpinsrb $6, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $7, %xmm0, %eax
; AVX-NEXT:    vpinsrb $7, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $8, %xmm0, %eax
; AVX-NEXT:    vpinsrb $8, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $9, %xmm0, %eax
; AVX-NEXT:    vpinsrb $9, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $10, %xmm0, %eax
; AVX-NEXT:    vpinsrb $10, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $11, %xmm0, %eax
; AVX-NEXT:    vpinsrb $11, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $12, %xmm0, %eax
; AVX-NEXT:    vpinsrb $12, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $13, %xmm0, %eax
; AVX-NEXT:    vpinsrb $13, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $14, %xmm0, %eax
; AVX-NEXT:    vpinsrb $14, %eax, %xmm1, %xmm1
; AVX-NEXT:    vpextrb $15, %xmm0, %eax
; AVX-NEXT:    vpinsrb $15, %eax, %xmm1, %xmm0
; AVX-NEXT:    vpand {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %x0  = extractelement <16 x i8> %0, i32 0
  %x1  = extractelement <16 x i8> %0, i32 1
  %x2  = extractelement <16 x i8> %0, i32 2
  %x3  = extractelement <16 x i8> %0, i32 3
  %x4  = extractelement <16 x i8> %0, i32 4
  %x5  = extractelement <16 x i8> %0, i32 5
  %x6  = extractelement <16 x i8> %0, i32 6
  %x7  = extractelement <16 x i8> %0, i32 7
  %x8  = extractelement <16 x i8> %0, i32 8
  %x9  = extractelement <16 x i8> %0, i32 9
  %x10 = extractelement <16 x i8> %0, i32 10
  %x11 = extractelement <16 x i8> %0, i32 11
  %x12 = extractelement <16 x i8> %0, i32 12
  %x13 = extractelement <16 x i8> %0, i32 13
  %x14 = extractelement <16 x i8> %0, i32 14
  %x15 = extractelement <16 x i8> %0, i32 15
  %trunc0  = trunc i8 %x0  to i4
  %trunc1  = trunc i8 %x1  to i4
  %trunc2  = trunc i8 %x2  to i4
  %trunc3  = trunc i8 %x3  to i4
  %trunc4  = trunc i8 %x4  to i4
  %trunc5  = trunc i8 %x5  to i4
  %trunc6  = trunc i8 %x6  to i4
  %trunc7  = trunc i8 %x7  to i4
  %trunc8  = trunc i8 %x8  to i4
  %trunc9  = trunc i8 %x9  to i4
  %trunc10 = trunc i8 %x10 to i4
  %trunc11 = trunc i8 %x11 to i4
  %trunc12 = trunc i8 %x12 to i4
  %trunc13 = trunc i8 %x13 to i4
  %trunc14 = trunc i8 %x14 to i4
  %trunc15 = trunc i8 %x15 to i4
  %ext0  = zext i4 %trunc0  to i8
  %ext1  = zext i4 %trunc1  to i8
  %ext2  = zext i4 %trunc2  to i8
  %ext3  = zext i4 %trunc3  to i8
  %ext4  = zext i4 %trunc4  to i8
  %ext5  = zext i4 %trunc5  to i8
  %ext6  = zext i4 %trunc6  to i8
  %ext7  = zext i4 %trunc7  to i8
  %ext8  = zext i4 %trunc8  to i8
  %ext9  = zext i4 %trunc9  to i8
  %ext10 = zext i4 %trunc10 to i8
  %ext11 = zext i4 %trunc11 to i8
  %ext12 = zext i4 %trunc12 to i8
  %ext13 = zext i4 %trunc13 to i8
  %ext14 = zext i4 %trunc14 to i8
  %ext15 = zext i4 %trunc15 to i8
  %v0  = insertelement <16 x i8> undef, i8 %ext0,  i32 0
  %v1  = insertelement <16 x i8> %v0,   i8 %ext1,  i32 1
  %v2  = insertelement <16 x i8> %v1,   i8 %ext2,  i32 2
  %v3  = insertelement <16 x i8> %v2,   i8 %ext3,  i32 3
  %v4  = insertelement <16 x i8> %v3,   i8 %ext4,  i32 4
  %v5  = insertelement <16 x i8> %v4,   i8 %ext5,  i32 5
  %v6  = insertelement <16 x i8> %v5,   i8 %ext6,  i32 6
  %v7  = insertelement <16 x i8> %v6,   i8 %ext7,  i32 7
  %v8  = insertelement <16 x i8> %v7,   i8 %ext8,  i32 8
  %v9  = insertelement <16 x i8> %v8,   i8 %ext9,  i32 9
  %v10 = insertelement <16 x i8> %v9,   i8 %ext10, i32 10
  %v11 = insertelement <16 x i8> %v10,  i8 %ext11, i32 11
  %v12 = insertelement <16 x i8> %v11,  i8 %ext12, i32 12
  %v13 = insertelement <16 x i8> %v12,  i8 %ext13, i32 13
  %v14 = insertelement <16 x i8> %v13,  i8 %ext14, i32 14
  %v15 = insertelement <16 x i8> %v14,  i8 %ext15, i32 15
  ret <16 x i8> %v15
}

define <2 x i64> @_clearupper2xi64b(<2 x i64>) nounwind {
; SSE-LABEL: _clearupper2xi64b:
; SSE:       # BB#0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    movd %eax, %xmm2
; SSE-NEXT:    movaps %xmm2, %xmm1
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,0],xmm0[0,0]
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[2,0],xmm0[2,3]
; SSE-NEXT:    shufps {{.*#+}} xmm2 = xmm2[0,0],xmm1[2,0]
; SSE-NEXT:    shufps {{.*#+}} xmm1 = xmm1[0,1],xmm2[2,0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: _clearupper2xi64b:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: _clearupper2xi64b:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; AVX2-NEXT:    retq
  %x32 = bitcast <2 x i64> %0 to <4 x i32>
  %r0 = insertelement <4 x i32> %x32, i32 zeroinitializer, i32 1
  %r1 = insertelement <4 x i32> %r0,  i32 zeroinitializer, i32 3
  %r = bitcast <4 x i32> %r1 to <2 x i64>
  ret <2 x i64> %r
}

define <4 x i32> @_clearupper4xi32b(<4 x i32>) nounwind {
; SSE-LABEL: _clearupper4xi32b:
; SSE:       # BB#0:
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    pinsrw $1, %eax, %xmm0
; SSE-NEXT:    pinsrw $3, %eax, %xmm0
; SSE-NEXT:    pinsrw $5, %eax, %xmm0
; SSE-NEXT:    pinsrw $7, %eax, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: _clearupper4xi32b:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: _clearupper4xi32b:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1],zero,zero,xmm0[4,5],zero,zero,xmm0[8,9],zero,zero,xmm0[12,13],zero,zero
; AVX2-NEXT:    retq
  %x16 = bitcast <4 x i32> %0 to <8 x i16>
  %r0 = insertelement <8 x i16> %x16, i16 zeroinitializer, i32 1
  %r1 = insertelement <8 x i16> %r0,  i16 zeroinitializer, i32 3
  %r2 = insertelement <8 x i16> %r1,  i16 zeroinitializer, i32 5
  %r3 = insertelement <8 x i16> %r2,  i16 zeroinitializer, i32 7
  %r = bitcast <8 x i16> %r3 to <4 x i32>
  ret <4 x i32> %r
}

define <8 x i16> @_clearupper8xi16b(<8 x i16>) nounwind {
; SSE-LABEL: _clearupper8xi16b:
; SSE:       # BB#0:
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    xorl %eax, %eax
; SSE-NEXT:    movd %eax, %xmm1
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    psllw $8, %xmm3
; SSE-NEXT:    pandn %xmm3, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,0,255,255,255,255,255,255,255,255,255,255,255,255]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    pslld $24, %xmm3
; SSE-NEXT:    pandn %xmm3, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,0,255,255,255,255,255,255,255,255,255,255]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    psllq $40, %xmm3
; SSE-NEXT:    pandn %xmm3, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,0,255,255,255,255,255,255,255,255]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    psllq $56, %xmm3
; SSE-NEXT:    pandn %xmm3, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255,255,0,255,255,255,255,255,255]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1,2,3,4,5,6]
; SSE-NEXT:    pandn %xmm3, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255,255,255,255,0,255,255,255,255]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1,2,3,4]
; SSE-NEXT:    pandn %xmm3, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255,255,255,255,255,255,0,255,255]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    movdqa %xmm1, %xmm3
; SSE-NEXT:    pslldq {{.*#+}} xmm3 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm3[0,1,2]
; SSE-NEXT:    pandn %xmm3, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    movdqa {{.*#+}} xmm2 = [255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0]
; SSE-NEXT:    pand %xmm2, %xmm0
; SSE-NEXT:    pslldq {{.*#+}} xmm1 = zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,zero,xmm1[0]
; SSE-NEXT:    pandn %xmm1, %xmm2
; SSE-NEXT:    por %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: _clearupper8xi16b:
; AVX:       # BB#0:
; AVX-NEXT:    xorl %eax, %eax
; AVX-NEXT:    vpinsrb $1, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrb $3, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrb $5, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrb $7, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrb $9, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrb $11, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrb $13, %eax, %xmm0, %xmm0
; AVX-NEXT:    vpinsrb $15, %eax, %xmm0, %xmm0
; AVX-NEXT:    retq
  %x8 = bitcast <8 x i16> %0 to <16 x i8>
  %r0 = insertelement <16 x i8> %x8, i8 zeroinitializer, i32 1
  %r1 = insertelement <16 x i8> %r0, i8 zeroinitializer, i32 3
  %r2 = insertelement <16 x i8> %r1, i8 zeroinitializer, i32 5
  %r3 = insertelement <16 x i8> %r2, i8 zeroinitializer, i32 7
  %r4 = insertelement <16 x i8> %r3, i8 zeroinitializer, i32 9
  %r5 = insertelement <16 x i8> %r4, i8 zeroinitializer, i32 11
  %r6 = insertelement <16 x i8> %r5, i8 zeroinitializer, i32 13
  %r7 = insertelement <16 x i8> %r6, i8 zeroinitializer, i32 15
  %r = bitcast <16 x i8> %r7 to <8 x i16>
  ret <8 x i16> %r
}

define <16 x i8> @_clearupper16xi8b(<16 x i8>) nounwind {
; SSE-LABEL: _clearupper16xi8b:
; SSE:       # BB#0:
; SSE-NEXT:    pushq %r14
; SSE-NEXT:    pushq %rbx
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm0[2,3,0,1]
; SSE-NEXT:    movd %xmm0, %rcx
; SSE-NEXT:    movq %rcx, %r8
; SSE-NEXT:    movq %rcx, %r9
; SSE-NEXT:    movq %rcx, %r10
; SSE-NEXT:    movq %rcx, %rax
; SSE-NEXT:    movq %rcx, %rdx
; SSE-NEXT:    movq %rcx, %rsi
; SSE-NEXT:    movq %rcx, %rdi
; SSE-NEXT:    andb $15, %cl
; SSE-NEXT:    movb %cl, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movd %xmm1, %rcx
; SSE-NEXT:    shrq $56, %rdi
; SSE-NEXT:    andb $15, %dil
; SSE-NEXT:    movb %dil, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq %rcx, %r11
; SSE-NEXT:    shrq $48, %rsi
; SSE-NEXT:    andb $15, %sil
; SSE-NEXT:    movb %sil, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq %rcx, %r14
; SSE-NEXT:    shrq $40, %rdx
; SSE-NEXT:    andb $15, %dl
; SSE-NEXT:    movb %dl, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq %rcx, %rdx
; SSE-NEXT:    shrq $32, %rax
; SSE-NEXT:    andb $15, %al
; SSE-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq %rcx, %rax
; SSE-NEXT:    shrq $24, %r10
; SSE-NEXT:    andb $15, %r10b
; SSE-NEXT:    movb %r10b, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq %rcx, %rdi
; SSE-NEXT:    shrq $16, %r9
; SSE-NEXT:    andb $15, %r9b
; SSE-NEXT:    movb %r9b, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq %rcx, %rsi
; SSE-NEXT:    shrq $8, %r8
; SSE-NEXT:    andb $15, %r8b
; SSE-NEXT:    movb %r8b, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq %rcx, %rbx
; SSE-NEXT:    movb $0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    andb $15, %cl
; SSE-NEXT:    movb %cl, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    shrq $56, %rbx
; SSE-NEXT:    andb $15, %bl
; SSE-NEXT:    movb %bl, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    shrq $48, %rsi
; SSE-NEXT:    andb $15, %sil
; SSE-NEXT:    movb %sil, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    shrq $40, %rdi
; SSE-NEXT:    andb $15, %dil
; SSE-NEXT:    movb %dil, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    shrq $32, %rax
; SSE-NEXT:    andb $15, %al
; SSE-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    shrq $24, %rdx
; SSE-NEXT:    andb $15, %dl
; SSE-NEXT:    movb %dl, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    shrq $16, %r14
; SSE-NEXT:    andb $15, %r14b
; SSE-NEXT:    movb %r14b, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    shrq $8, %r11
; SSE-NEXT:    andb $15, %r11b
; SSE-NEXT:    movb %r11b, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movb $0, -{{[0-9]+}}(%rsp)
; SSE-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE-NEXT:    movq {{.*#+}} xmm1 = mem[0],zero
; SSE-NEXT:    punpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; SSE-NEXT:    popq %rbx
; SSE-NEXT:    popq %r14
; SSE-NEXT:    retq
;
; AVX-LABEL: _clearupper16xi8b:
; AVX:       # BB#0:
; AVX-NEXT:    pushq %rbp
; AVX-NEXT:    pushq %r15
; AVX-NEXT:    pushq %r14
; AVX-NEXT:    pushq %r13
; AVX-NEXT:    pushq %r12
; AVX-NEXT:    pushq %rbx
; AVX-NEXT:    vmovaps %xmm0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movq -{{[0-9]+}}(%rsp), %rcx
; AVX-NEXT:    movq -{{[0-9]+}}(%rsp), %rdx
; AVX-NEXT:    movq %rcx, %r8
; AVX-NEXT:    movq %rcx, %r9
; AVX-NEXT:    movq %rcx, %r10
; AVX-NEXT:    movq %rcx, %r11
; AVX-NEXT:    movq %rcx, %r14
; AVX-NEXT:    movq %rcx, %r15
; AVX-NEXT:    movq %rdx, %r12
; AVX-NEXT:    movq %rdx, %r13
; AVX-NEXT:    movq %rdx, %rdi
; AVX-NEXT:    movq %rdx, %rax
; AVX-NEXT:    movq %rdx, %rsi
; AVX-NEXT:    movq %rdx, %rbx
; AVX-NEXT:    movq %rdx, %rbp
; AVX-NEXT:    andb $15, %dl
; AVX-NEXT:    movb %dl, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movq %rcx, %rdx
; AVX-NEXT:    andb $15, %cl
; AVX-NEXT:    movb %cl, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $56, %rbp
; AVX-NEXT:    andb $15, %bpl
; AVX-NEXT:    movb %bpl, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $48, %rbx
; AVX-NEXT:    andb $15, %bl
; AVX-NEXT:    movb %bl, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $40, %rsi
; AVX-NEXT:    andb $15, %sil
; AVX-NEXT:    movb %sil, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $32, %rax
; AVX-NEXT:    andb $15, %al
; AVX-NEXT:    movb %al, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $24, %rdi
; AVX-NEXT:    andb $15, %dil
; AVX-NEXT:    movb %dil, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $16, %r13
; AVX-NEXT:    andb $15, %r13b
; AVX-NEXT:    movb %r13b, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $8, %r12
; AVX-NEXT:    andb $15, %r12b
; AVX-NEXT:    movb %r12b, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $56, %rdx
; AVX-NEXT:    andb $15, %dl
; AVX-NEXT:    movb %dl, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $48, %r15
; AVX-NEXT:    andb $15, %r15b
; AVX-NEXT:    movb %r15b, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $40, %r14
; AVX-NEXT:    andb $15, %r14b
; AVX-NEXT:    movb %r14b, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $32, %r11
; AVX-NEXT:    andb $15, %r11b
; AVX-NEXT:    movb %r11b, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $24, %r10
; AVX-NEXT:    andb $15, %r10b
; AVX-NEXT:    movb %r10b, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $16, %r9
; AVX-NEXT:    andb $15, %r9b
; AVX-NEXT:    movb %r9b, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    shrq $8, %r8
; AVX-NEXT:    andb $15, %r8b
; AVX-NEXT:    movb %r8b, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    movb $0, -{{[0-9]+}}(%rsp)
; AVX-NEXT:    vmovaps -{{[0-9]+}}(%rsp), %xmm0
; AVX-NEXT:    popq %rbx
; AVX-NEXT:    popq %r12
; AVX-NEXT:    popq %r13
; AVX-NEXT:    popq %r14
; AVX-NEXT:    popq %r15
; AVX-NEXT:    popq %rbp
; AVX-NEXT:    retq
  %x4  = bitcast <16 x i8> %0 to <32 x i4>
  %r0  = insertelement <32 x i4> %x4,  i4 zeroinitializer, i32 1
  %r1  = insertelement <32 x i4> %r0,  i4 zeroinitializer, i32 3
  %r2  = insertelement <32 x i4> %r1,  i4 zeroinitializer, i32 5
  %r3  = insertelement <32 x i4> %r2,  i4 zeroinitializer, i32 7
  %r4  = insertelement <32 x i4> %r3,  i4 zeroinitializer, i32 9
  %r5  = insertelement <32 x i4> %r4,  i4 zeroinitializer, i32 11
  %r6  = insertelement <32 x i4> %r5,  i4 zeroinitializer, i32 13
  %r7  = insertelement <32 x i4> %r6,  i4 zeroinitializer, i32 15
  %r8  = insertelement <32 x i4> %r7,  i4 zeroinitializer, i32 17
  %r9  = insertelement <32 x i4> %r8,  i4 zeroinitializer, i32 19
  %r10 = insertelement <32 x i4> %r9,  i4 zeroinitializer, i32 21
  %r11 = insertelement <32 x i4> %r10, i4 zeroinitializer, i32 23
  %r12 = insertelement <32 x i4> %r11, i4 zeroinitializer, i32 25
  %r13 = insertelement <32 x i4> %r12, i4 zeroinitializer, i32 27
  %r14 = insertelement <32 x i4> %r13, i4 zeroinitializer, i32 29
  %r15 = insertelement <32 x i4> %r14, i4 zeroinitializer, i32 31
  %r = bitcast <32 x i4> %r15 to <16 x i8>
  ret <16 x i8> %r
}

define <2 x i64> @_clearupper2xi64c(<2 x i64>) nounwind {
; SSE-LABEL: _clearupper2xi64c:
; SSE:       # BB#0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: _clearupper2xi64c:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0,1],xmm1[2,3],xmm0[4,5],xmm1[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: _clearupper2xi64c:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vpblendd {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3]
; AVX2-NEXT:    retq
  %r = and <2 x i64> <i64 4294967295, i64 4294967295>, %0
  ret <2 x i64> %r
}

define <4 x i32> @_clearupper4xi32c(<4 x i32>) nounwind {
; SSE-LABEL: _clearupper4xi32c:
; SSE:       # BB#0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: _clearupper4xi32c:
; AVX:       # BB#0:
; AVX-NEXT:    vpxor %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vpblendw {{.*#+}} xmm0 = xmm0[0],xmm1[1],xmm0[2],xmm1[3],xmm0[4],xmm1[5],xmm0[6],xmm1[7]
; AVX-NEXT:    retq
  %r = and <4 x i32> <i32 65535, i32 65535, i32 65535, i32 65535>, %0
  ret <4 x i32> %r
}

define <8 x i16> @_clearupper8xi16c(<8 x i16>) nounwind {
; SSE-LABEL: _clearupper8xi16c:
; SSE:       # BB#0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: _clearupper8xi16c:
; AVX:       # BB#0:
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %r = and <8 x i16> <i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255, i16 255>, %0
  ret <8 x i16> %r
}

define <16 x i8> @_clearupper16xi8c(<16 x i8>) nounwind {
; SSE-LABEL: _clearupper16xi8c:
; SSE:       # BB#0:
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: _clearupper16xi8c:
; AVX:       # BB#0:
; AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX-NEXT:    retq
  %r = and <16 x i8> <i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15, i8 15>, %0
  ret <16 x i8> %r
}
