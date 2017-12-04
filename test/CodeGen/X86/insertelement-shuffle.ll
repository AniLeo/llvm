; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=avx2    | FileCheck %s --check-prefix=X32_AVX256
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx2    | FileCheck %s --check-prefix=X64_AVX256
; RUN: llc < %s -mtriple=i686-unknown-unknown   -mattr=avx512f | FileCheck %s --check-prefix=X32_AVX512
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=avx512f | FileCheck %s --check-prefix=X64_AVX512

define <8 x float> @insert_subvector_256(i16 %x0, i16 %x1, <8 x float> %v) nounwind {
; X32_AVX256-LABEL: insert_subvector_256:
; X32_AVX256:       # %bb.0:
; X32_AVX256-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32_AVX256-NEXT:    vpinsrw $1, {{[0-9]+}}(%esp), %xmm1, %xmm1
; X32_AVX256-NEXT:    vpbroadcastd %xmm1, %xmm1
; X32_AVX256-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm1[1],ymm0[2,3,4,5,6,7]
; X32_AVX256-NEXT:    retl
;
; X64_AVX256-LABEL: insert_subvector_256:
; X64_AVX256:       # %bb.0:
; X64_AVX256-NEXT:    vmovd %edi, %xmm1
; X64_AVX256-NEXT:    vpinsrw $1, %esi, %xmm1, %xmm1
; X64_AVX256-NEXT:    vpbroadcastd %xmm1, %xmm1
; X64_AVX256-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm1[1],ymm0[2,3,4,5,6,7]
; X64_AVX256-NEXT:    retq
;
; X32_AVX512-LABEL: insert_subvector_256:
; X32_AVX512:       # %bb.0:
; X32_AVX512-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32_AVX512-NEXT:    vpinsrw $1, {{[0-9]+}}(%esp), %xmm1, %xmm1
; X32_AVX512-NEXT:    vpbroadcastd %xmm1, %xmm1
; X32_AVX512-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm1[1],ymm0[2,3,4,5,6,7]
; X32_AVX512-NEXT:    retl
;
; X64_AVX512-LABEL: insert_subvector_256:
; X64_AVX512:       # %bb.0:
; X64_AVX512-NEXT:    vmovd %edi, %xmm1
; X64_AVX512-NEXT:    vpinsrw $1, %esi, %xmm1, %xmm1
; X64_AVX512-NEXT:    vpbroadcastd %xmm1, %xmm1
; X64_AVX512-NEXT:    vpblendd {{.*#+}} ymm0 = ymm0[0],ymm1[1],ymm0[2,3,4,5,6,7]
; X64_AVX512-NEXT:    retq
  %ins1 = insertelement <2 x i16> undef, i16 %x0, i32 0
  %ins2 = insertelement <2 x i16> %ins1, i16 %x1, i32 1
  %bc = bitcast <2 x i16> %ins2 to float
  %ins3 = insertelement <8 x float> %v, float %bc, i32 1
  ret <8 x float> %ins3
}

define <8 x i64> @insert_subvector_512(i32 %x0, i32 %x1, <8 x i64> %v) nounwind {
; X32_AVX256-LABEL: insert_subvector_512:
; X32_AVX256:       # %bb.0:
; X32_AVX256-NEXT:    pushl %ebp
; X32_AVX256-NEXT:    movl %esp, %ebp
; X32_AVX256-NEXT:    andl $-8, %esp
; X32_AVX256-NEXT:    subl $8, %esp
; X32_AVX256-NEXT:    vmovsd {{.*#+}} xmm2 = mem[0],zero
; X32_AVX256-NEXT:    vmovlps %xmm2, (%esp)
; X32_AVX256-NEXT:    vextracti128 $1, %ymm0, %xmm2
; X32_AVX256-NEXT:    vpinsrd $0, (%esp), %xmm2, %xmm2
; X32_AVX256-NEXT:    vpinsrd $1, {{[0-9]+}}(%esp), %xmm2, %xmm2
; X32_AVX256-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; X32_AVX256-NEXT:    movl %ebp, %esp
; X32_AVX256-NEXT:    popl %ebp
; X32_AVX256-NEXT:    retl
;
; X64_AVX256-LABEL: insert_subvector_512:
; X64_AVX256:       # %bb.0:
; X64_AVX256-NEXT:    vmovd %edi, %xmm2
; X64_AVX256-NEXT:    vpinsrd $1, %esi, %xmm2, %xmm2
; X64_AVX256-NEXT:    vmovq %xmm2, %rax
; X64_AVX256-NEXT:    vextracti128 $1, %ymm0, %xmm2
; X64_AVX256-NEXT:    vpinsrq $0, %rax, %xmm2, %xmm2
; X64_AVX256-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; X64_AVX256-NEXT:    retq
;
; X32_AVX512-LABEL: insert_subvector_512:
; X32_AVX512:       # %bb.0:
; X32_AVX512-NEXT:    vmovq {{.*#+}} xmm1 = mem[0],zero
; X32_AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [0,0,1,0,8,0,3,0,4,0,5,0,6,0,7,0]
; X32_AVX512-NEXT:    vpermt2q %zmm1, %zmm2, %zmm0
; X32_AVX512-NEXT:    retl
;
; X64_AVX512-LABEL: insert_subvector_512:
; X64_AVX512:       # %bb.0:
; X64_AVX512-NEXT:    vmovd %edi, %xmm1
; X64_AVX512-NEXT:    vpinsrd $1, %esi, %xmm1, %xmm1
; X64_AVX512-NEXT:    vmovdqa64 {{.*#+}} zmm2 = [0,1,8,3,4,5,6,7]
; X64_AVX512-NEXT:    vpermt2q %zmm1, %zmm2, %zmm0
; X64_AVX512-NEXT:    retq
  %ins1 = insertelement <2 x i32> undef, i32 %x0, i32 0
  %ins2 = insertelement <2 x i32> %ins1, i32 %x1, i32 1
  %bc = bitcast <2 x i32> %ins2 to i64
  %ins3 = insertelement <8 x i64> %v, i64 %bc, i32 2
  ret <8 x i64> %ins3
}

; PR34716 - https://bugs.llvm.org/show_bug.cgi?id=34716
; Special case: if we're inserting into an undef vector, we can optimize more.

define <8 x i64> @insert_subvector_into_undef(i32 %x0, i32 %x1) nounwind {
; X32_AVX256-LABEL: insert_subvector_into_undef:
; X32_AVX256:       # %bb.0:
; X32_AVX256-NEXT:    pushl %ebp
; X32_AVX256-NEXT:    movl %esp, %ebp
; X32_AVX256-NEXT:    andl $-8, %esp
; X32_AVX256-NEXT:    subl $8, %esp
; X32_AVX256-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X32_AVX256-NEXT:    vmovlps %xmm0, (%esp)
; X32_AVX256-NEXT:    movl (%esp), %eax
; X32_AVX256-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X32_AVX256-NEXT:    vmovd %eax, %xmm0
; X32_AVX256-NEXT:    vpinsrd $1, %ecx, %xmm0, %xmm0
; X32_AVX256-NEXT:    vpinsrd $2, %eax, %xmm0, %xmm0
; X32_AVX256-NEXT:    vpinsrd $3, %ecx, %xmm0, %xmm0
; X32_AVX256-NEXT:    vinserti128 $1, %xmm0, %ymm0, %ymm0
; X32_AVX256-NEXT:    vmovdqa %ymm0, %ymm1
; X32_AVX256-NEXT:    movl %ebp, %esp
; X32_AVX256-NEXT:    popl %ebp
; X32_AVX256-NEXT:    retl
;
; X64_AVX256-LABEL: insert_subvector_into_undef:
; X64_AVX256:       # %bb.0:
; X64_AVX256-NEXT:    vmovd %edi, %xmm0
; X64_AVX256-NEXT:    vpinsrd $1, %esi, %xmm0, %xmm0
; X64_AVX256-NEXT:    vpbroadcastq %xmm0, %ymm0
; X64_AVX256-NEXT:    vmovdqa %ymm0, %ymm1
; X64_AVX256-NEXT:    retq
;
; X32_AVX512-LABEL: insert_subvector_into_undef:
; X32_AVX512:       # %bb.0:
; X32_AVX512-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X32_AVX512-NEXT:    vbroadcastsd %xmm0, %zmm0
; X32_AVX512-NEXT:    retl
;
; X64_AVX512-LABEL: insert_subvector_into_undef:
; X64_AVX512:       # %bb.0:
; X64_AVX512-NEXT:    vmovd %edi, %xmm0
; X64_AVX512-NEXT:    vpinsrd $1, %esi, %xmm0, %xmm0
; X64_AVX512-NEXT:    vpbroadcastq %xmm0, %zmm0
; X64_AVX512-NEXT:    retq
  %ins1 = insertelement <2 x i32> undef, i32 %x0, i32 0
  %ins2 = insertelement <2 x i32> %ins1, i32 %x1, i32 1
  %bc = bitcast <2 x i32> %ins2 to i64
  %ins3 = insertelement <8 x i64> undef, i64 %bc, i32 0
  %splat = shufflevector <8 x i64> %ins3, <8 x i64> undef, <8 x i32> zeroinitializer
  ret <8 x i64> %splat
}

