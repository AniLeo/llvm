; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw -mattr=+avx512vl | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512BWVL

define <16 x i8> @avg_v16i8_mask(<16 x i8> %a, <16 x i8> %b, <16 x i8> %src, i16 %mask) nounwind {
; AVX512F-LABEL: avg_v16i8_mask:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpavgb %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vpmovdb %zmm1, %xmm1
; AVX512F-NEXT:    vpblendvb %xmm1, %xmm0, %xmm2, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v16i8_mask:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgb %xmm1, %xmm0, %xmm2 {%k1}
; AVX512BWVL-NEXT:    vmovdqa %xmm2, %xmm0
; AVX512BWVL-NEXT:    retq
  %za = zext <16 x i8> %a to <16 x i16>
  %zb = zext <16 x i8> %b to <16 x i16>
  %add = add nuw nsw <16 x i16> %za, %zb
  %add1 = add nuw nsw <16 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %lshr = lshr <16 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %trunc = trunc <16 x i16> %lshr to <16 x i8>
  %mask1 = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask1, <16 x i8> %trunc, <16 x i8> %src
  ret <16 x i8> %res
}

define <16 x i8> @avg_v16i8_maskz(<16 x i8> %a, <16 x i8> %b, i16 %mask) nounwind {
; AVX512F-LABEL: avg_v16i8_maskz:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpavgb %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vpmovdb %zmm1, %xmm1
; AVX512F-NEXT:    vpand %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v16i8_maskz:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgb %xmm1, %xmm0, %xmm0 {%k1} {z}
; AVX512BWVL-NEXT:    retq
  %za = zext <16 x i8> %a to <16 x i16>
  %zb = zext <16 x i8> %b to <16 x i16>
  %add = add nuw nsw <16 x i16> %za, %zb
  %add1 = add nuw nsw <16 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %lshr = lshr <16 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %trunc = trunc <16 x i16> %lshr to <16 x i8>
  %mask1 = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask1, <16 x i8> %trunc, <16 x i8> zeroinitializer
  ret <16 x i8> %res
}

define <32 x i8> @avg_v32i8_mask(<32 x i8> %a, <32 x i8> %b, <32 x i8> %src, i32 %mask) nounwind {
; AVX512F-LABEL: avg_v32i8_mask:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    shrl $16, %edi
; AVX512F-NEXT:    vpavgb %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    kmovw %edi, %k2
; AVX512F-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vpmovdb %zmm1, %xmm1
; AVX512F-NEXT:    vpternlogd $255, %zmm3, %zmm3, %zmm3 {%k2} {z}
; AVX512F-NEXT:    vpmovdb %zmm3, %xmm3
; AVX512F-NEXT:    vinserti128 $1, %xmm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpblendvb %ymm1, %ymm0, %ymm2, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v32i8_mask:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgb %ymm1, %ymm0, %ymm2 {%k1}
; AVX512BWVL-NEXT:    vmovdqa %ymm2, %ymm0
; AVX512BWVL-NEXT:    retq
  %za = zext <32 x i8> %a to <32 x i16>
  %zb = zext <32 x i8> %b to <32 x i16>
  %add = add nuw nsw <32 x i16> %za, %zb
  %add1 = add nuw nsw <32 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %lshr = lshr <32 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %trunc = trunc <32 x i16> %lshr to <32 x i8>
  %mask1 = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %mask1, <32 x i8> %trunc, <32 x i8> %src
  ret <32 x i8> %res
}

define <32 x i8> @avg_v32i8_maskz(<32 x i8> %a, <32 x i8> %b, i32 %mask) nounwind {
; AVX512F-LABEL: avg_v32i8_maskz:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    shrl $16, %edi
; AVX512F-NEXT:    vpavgb %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    kmovw %edi, %k2
; AVX512F-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vpmovdb %zmm1, %xmm1
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k2} {z}
; AVX512F-NEXT:    vpmovdb %zmm2, %xmm2
; AVX512F-NEXT:    vinserti128 $1, %xmm2, %ymm1, %ymm1
; AVX512F-NEXT:    vpand %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v32i8_maskz:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgb %ymm1, %ymm0, %ymm0 {%k1} {z}
; AVX512BWVL-NEXT:    retq
  %za = zext <32 x i8> %a to <32 x i16>
  %zb = zext <32 x i8> %b to <32 x i16>
  %add = add nuw nsw <32 x i16> %za, %zb
  %add1 = add nuw nsw <32 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %lshr = lshr <32 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %trunc = trunc <32 x i16> %lshr to <32 x i8>
  %mask1 = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %mask1, <32 x i8> %trunc, <32 x i8> zeroinitializer
  ret <32 x i8> %res
}

define <64 x i8> @avg_v64i8_mask(<64 x i8> %a, <64 x i8> %b, <64 x i8> %src, i64 %mask) nounwind {
; AVX512F-LABEL: avg_v64i8_mask:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    movq %rdi, %rax
; AVX512F-NEXT:    movq %rdi, %rcx
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    movl %edi, %edx
; AVX512F-NEXT:    shrl $16, %edx
; AVX512F-NEXT:    shrq $32, %rax
; AVX512F-NEXT:    shrq $48, %rcx
; AVX512F-NEXT:    vpavgb %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpavgb %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    kmovw %ecx, %k2
; AVX512F-NEXT:    kmovw %eax, %k3
; AVX512F-NEXT:    kmovw %edx, %k4
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k1} {z}
; AVX512F-NEXT:    vpmovdb %zmm2, %xmm2
; AVX512F-NEXT:    vpternlogd $255, %zmm3, %zmm3, %zmm3 {%k4} {z}
; AVX512F-NEXT:    vpmovdb %zmm3, %xmm3
; AVX512F-NEXT:    vinserti128 $1, %xmm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpblendvb %ymm2, %ymm0, %ymm4, %ymm0
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k3} {z}
; AVX512F-NEXT:    vpmovdb %zmm2, %xmm2
; AVX512F-NEXT:    vpternlogd $255, %zmm3, %zmm3, %zmm3 {%k2} {z}
; AVX512F-NEXT:    vpmovdb %zmm3, %xmm3
; AVX512F-NEXT:    vinserti128 $1, %xmm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpblendvb %ymm2, %ymm1, %ymm5, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v64i8_mask:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovq %rdi, %k1
; AVX512BWVL-NEXT:    vpavgb %zmm1, %zmm0, %zmm2 {%k1}
; AVX512BWVL-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BWVL-NEXT:    retq
  %za = zext <64 x i8> %a to <64 x i16>
  %zb = zext <64 x i8> %b to <64 x i16>
  %add = add nuw nsw <64 x i16> %za, %zb
  %add1 = add nuw nsw <64 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %lshr = lshr <64 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %trunc = trunc <64 x i16> %lshr to <64 x i8>
  %mask1 = bitcast i64 %mask to <64 x i1>
  %res = select <64 x i1> %mask1, <64 x i8> %trunc, <64 x i8> %src
  ret <64 x i8> %res
}

define <64 x i8> @avg_v64i8_maskz(<64 x i8> %a, <64 x i8> %b, i64 %mask) nounwind {
; AVX512F-LABEL: avg_v64i8_maskz:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    movq %rdi, %rax
; AVX512F-NEXT:    movq %rdi, %rcx
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    movl %edi, %edx
; AVX512F-NEXT:    shrl $16, %edx
; AVX512F-NEXT:    shrq $32, %rax
; AVX512F-NEXT:    shrq $48, %rcx
; AVX512F-NEXT:    vpavgb %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpavgb %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    kmovw %ecx, %k2
; AVX512F-NEXT:    kmovw %eax, %k3
; AVX512F-NEXT:    kmovw %edx, %k4
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k1} {z}
; AVX512F-NEXT:    vpmovdb %zmm2, %xmm2
; AVX512F-NEXT:    vpternlogd $255, %zmm3, %zmm3, %zmm3 {%k4} {z}
; AVX512F-NEXT:    vpmovdb %zmm3, %xmm3
; AVX512F-NEXT:    vinserti128 $1, %xmm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpand %ymm0, %ymm2, %ymm0
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k3} {z}
; AVX512F-NEXT:    vpmovdb %zmm2, %xmm2
; AVX512F-NEXT:    vpternlogd $255, %zmm3, %zmm3, %zmm3 {%k2} {z}
; AVX512F-NEXT:    vpmovdb %zmm3, %xmm3
; AVX512F-NEXT:    vinserti128 $1, %xmm3, %ymm2, %ymm2
; AVX512F-NEXT:    vpand %ymm1, %ymm2, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v64i8_maskz:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovq %rdi, %k1
; AVX512BWVL-NEXT:    vpavgb %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512BWVL-NEXT:    retq
  %za = zext <64 x i8> %a to <64 x i16>
  %zb = zext <64 x i8> %b to <64 x i16>
  %add = add nuw nsw <64 x i16> %za, %zb
  %add1 = add nuw nsw <64 x i16> %add, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %lshr = lshr <64 x i16> %add1, <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
  %trunc = trunc <64 x i16> %lshr to <64 x i8>
  %mask1 = bitcast i64 %mask to <64 x i1>
  %res = select <64 x i1> %mask1, <64 x i8> %trunc, <64 x i8> zeroinitializer
  ret <64 x i8> %res
}

define <8 x i16> @avg_v8i16_mask(<8 x i16> %a, <8 x i16> %b, <8 x i16> %src, i8 %mask) nounwind {
; AVX512F-LABEL: avg_v8i16_mask:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpavgw %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vpmovdw %zmm1, %ymm1
; AVX512F-NEXT:    vpblendvb %xmm1, %xmm0, %xmm2, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v8i16_mask:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgw %xmm1, %xmm0, %xmm2 {%k1}
; AVX512BWVL-NEXT:    vmovdqa %xmm2, %xmm0
; AVX512BWVL-NEXT:    retq
  %za = zext <8 x i16> %a to <8 x i32>
  %zb = zext <8 x i16> %b to <8 x i32>
  %add = add nuw nsw <8 x i32> %za, %zb
  %add1 = add nuw nsw <8 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %lshr = lshr <8 x i32> %add1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %trunc = trunc <8 x i32> %lshr to <8 x i16>
  %mask1 = bitcast i8 %mask to <8 x i1>
  %res = select <8 x i1> %mask1, <8 x i16> %trunc, <8 x i16> %src
  ret <8 x i16> %res
}

define <8 x i16> @avg_v8i16_maskz(<8 x i16> %a, <8 x i16> %b, i8 %mask) nounwind {
; AVX512F-LABEL: avg_v8i16_maskz:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpavgw %xmm1, %xmm0, %xmm0
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vpmovdw %zmm1, %ymm1
; AVX512F-NEXT:    vpand %xmm0, %xmm1, %xmm0
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v8i16_maskz:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgw %xmm1, %xmm0, %xmm0 {%k1} {z}
; AVX512BWVL-NEXT:    retq
  %za = zext <8 x i16> %a to <8 x i32>
  %zb = zext <8 x i16> %b to <8 x i32>
  %add = add nuw nsw <8 x i32> %za, %zb
  %add1 = add nuw nsw <8 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %lshr = lshr <8 x i32> %add1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %trunc = trunc <8 x i32> %lshr to <8 x i16>
  %mask1 = bitcast i8 %mask to <8 x i1>
  %res = select <8 x i1> %mask1, <8 x i16> %trunc, <8 x i16> zeroinitializer
  ret <8 x i16> %res
}

define <16 x i16> @avg_v16i16_mask(<16 x i16> %a, <16 x i16> %b, <16 x i16> %src, i16 %mask) nounwind {
; AVX512F-LABEL: avg_v16i16_mask:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpavgw %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vpmovdw %zmm1, %ymm1
; AVX512F-NEXT:    vpblendvb %ymm1, %ymm0, %ymm2, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v16i16_mask:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgw %ymm1, %ymm0, %ymm2 {%k1}
; AVX512BWVL-NEXT:    vmovdqa %ymm2, %ymm0
; AVX512BWVL-NEXT:    retq
  %za = zext <16 x i16> %a to <16 x i32>
  %zb = zext <16 x i16> %b to <16 x i32>
  %add = add nuw nsw <16 x i32> %za, %zb
  %add1 = add nuw nsw <16 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %lshr = lshr <16 x i32> %add1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %trunc = trunc <16 x i32> %lshr to <16 x i16>
  %mask1 = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask1, <16 x i16> %trunc, <16 x i16> %src
  ret <16 x i16> %res
}

define <16 x i16> @avg_v16i16_maskz(<16 x i16> %a, <16 x i16> %b, i16 %mask) nounwind {
; AVX512F-LABEL: avg_v16i16_maskz:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpavgw %ymm1, %ymm0, %ymm0
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    vpternlogd $255, %zmm1, %zmm1, %zmm1 {%k1} {z}
; AVX512F-NEXT:    vpmovdw %zmm1, %ymm1
; AVX512F-NEXT:    vpand %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v16i16_maskz:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgw %ymm1, %ymm0, %ymm0 {%k1} {z}
; AVX512BWVL-NEXT:    retq
  %za = zext <16 x i16> %a to <16 x i32>
  %zb = zext <16 x i16> %b to <16 x i32>
  %add = add nuw nsw <16 x i32> %za, %zb
  %add1 = add nuw nsw <16 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %lshr = lshr <16 x i32> %add1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %trunc = trunc <16 x i32> %lshr to <16 x i16>
  %mask1 = bitcast i16 %mask to <16 x i1>
  %res = select <16 x i1> %mask1, <16 x i16> %trunc, <16 x i16> zeroinitializer
  ret <16 x i16> %res
}

define <32 x i16> @avg_v32i16_mask(<32 x i16> %a, <32 x i16> %b, <32 x i16> %src, i32 %mask) nounwind {
; AVX512F-LABEL: avg_v32i16_mask:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    shrl $16, %edi
; AVX512F-NEXT:    vpavgw %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpavgw %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    kmovw %edi, %k2
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k1} {z}
; AVX512F-NEXT:    vpmovdw %zmm2, %ymm2
; AVX512F-NEXT:    vpblendvb %ymm2, %ymm0, %ymm4, %ymm0
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k2} {z}
; AVX512F-NEXT:    vpmovdw %zmm2, %ymm2
; AVX512F-NEXT:    vpblendvb %ymm2, %ymm1, %ymm5, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v32i16_mask:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgw %zmm1, %zmm0, %zmm2 {%k1}
; AVX512BWVL-NEXT:    vmovdqa64 %zmm2, %zmm0
; AVX512BWVL-NEXT:    retq
  %za = zext <32 x i16> %a to <32 x i32>
  %zb = zext <32 x i16> %b to <32 x i32>
  %add = add nuw nsw <32 x i32> %za, %zb
  %add1 = add nuw nsw <32 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %lshr = lshr <32 x i32> %add1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %trunc = trunc <32 x i32> %lshr to <32 x i16>
  %mask1 = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %mask1, <32 x i16> %trunc, <32 x i16> %src
  ret <32 x i16> %res
}

define <32 x i16> @avg_v32i16_maskz(<32 x i16> %a, <32 x i16> %b, i32 %mask) nounwind {
; AVX512F-LABEL: avg_v32i16_maskz:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    kmovw %edi, %k1
; AVX512F-NEXT:    shrl $16, %edi
; AVX512F-NEXT:    vpavgw %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpavgw %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    kmovw %edi, %k2
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k1} {z}
; AVX512F-NEXT:    vpmovdw %zmm2, %ymm2
; AVX512F-NEXT:    vpand %ymm0, %ymm2, %ymm0
; AVX512F-NEXT:    vpternlogd $255, %zmm2, %zmm2, %zmm2 {%k2} {z}
; AVX512F-NEXT:    vpmovdw %zmm2, %ymm2
; AVX512F-NEXT:    vpand %ymm1, %ymm2, %ymm1
; AVX512F-NEXT:    retq
;
; AVX512BWVL-LABEL: avg_v32i16_maskz:
; AVX512BWVL:       # %bb.0:
; AVX512BWVL-NEXT:    kmovd %edi, %k1
; AVX512BWVL-NEXT:    vpavgw %zmm1, %zmm0, %zmm0 {%k1} {z}
; AVX512BWVL-NEXT:    retq
  %za = zext <32 x i16> %a to <32 x i32>
  %zb = zext <32 x i16> %b to <32 x i32>
  %add = add nuw nsw <32 x i32> %za, %zb
  %add1 = add nuw nsw <32 x i32> %add, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %lshr = lshr <32 x i32> %add1, <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1>
  %trunc = trunc <32 x i32> %lshr to <32 x i16>
  %mask1 = bitcast i32 %mask to <32 x i1>
  %res = select <32 x i1> %mask1, <32 x i16> %trunc, <32 x i16> zeroinitializer
  ret <32 x i16> %res
}
