; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=AVX512VL --check-prefix=AVX512VL-X64
; RUN: llc < %s -mtriple=i386-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=AVX512VL --check-prefix=AVX512VL-X86
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512F --check-prefix=AVX512F-X64
; RUN: llc < %s -mtriple=i386-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512F --check-prefix=AVX512F-X86

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm_test_epi64_mask(<2 x i64> %__A, <2 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-LABEL: TEST_mm_test_epi64_mask:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vptestmq %xmm0, %xmm1, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-NEXT:    ret{{[l|q]}}
;
; AVX512F-LABEL: TEST_mm_test_epi64_mask:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kshiftlw $14, %k0, %k0
; AVX512F-NEXT:    kshiftrw $14, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = icmp ne <2 x i64> %and.i.i, zeroinitializer
  %1 = shufflevector <2 x i1> %0, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %2 = bitcast <8 x i1> %1 to i8
  ret i8 %2
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm_test_epi32_mask(<2 x i64> %__A, <2 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-LABEL: TEST_mm_test_epi32_mask:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vptestmd %xmm0, %xmm1, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-NEXT:    ret{{[l|q]}}
;
; AVX512F-LABEL: TEST_mm_test_epi32_mask:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <4 x i32>
  %1 = icmp ne <4 x i32> %0, zeroinitializer
  %2 = shufflevector <4 x i1> %1, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %3 = bitcast <8 x i1> %2 to i8
  ret i8 %3
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm256_test_epi64_mask(<4 x i64> %__A, <4 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-LABEL: TEST_mm256_test_epi64_mask:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vptestmq %ymm0, %ymm1, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    ret{{[l|q]}}
;
; AVX512F-LABEL: TEST_mm256_test_epi64_mask:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vptestmq %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = icmp ne <4 x i64> %and.i.i, zeroinitializer
  %1 = shufflevector <4 x i1> %0, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %2 = bitcast <8 x i1> %1 to i8
  ret i8 %2
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm256_test_epi32_mask(<4 x i64> %__A, <4 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-LABEL: TEST_mm256_test_epi32_mask:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vptestmd %ymm0, %ymm1, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    ret{{[l|q]}}
;
; AVX512F-LABEL: TEST_mm256_test_epi32_mask:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <8 x i32>
  %1 = icmp ne <8 x i32> %0, zeroinitializer
  %2 = bitcast <8 x i1> %1 to i8
  ret i8 %2
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm_mask_test_epi64_mask(i8 %__U, <2 x i64> %__A, <2 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-X64-LABEL: TEST_mm_mask_test_epi64_mask:
; AVX512VL-X64:       # %bb.0: # %entry
; AVX512VL-X64-NEXT:    kmovw %edi, %k1
; AVX512VL-X64-NEXT:    vptestmq %xmm0, %xmm1, %k0 {%k1}
; AVX512VL-X64-NEXT:    kmovw %k0, %eax
; AVX512VL-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X64-NEXT:    retq
;
; AVX512VL-X86-LABEL: TEST_mm_mask_test_epi64_mask:
; AVX512VL-X86:       # %bb.0: # %entry
; AVX512VL-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512VL-X86-NEXT:    kmovw %eax, %k1
; AVX512VL-X86-NEXT:    vptestmq %xmm0, %xmm1, %k0 {%k1}
; AVX512VL-X86-NEXT:    kmovw %k0, %eax
; AVX512VL-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X86-NEXT:    retl
;
; AVX512F-X64-LABEL: TEST_mm_mask_test_epi64_mask:
; AVX512F-X64:       # %bb.0: # %entry
; AVX512F-X64-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-X64-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-X64-NEXT:    kmovw %edi, %k1
; AVX512F-X64-NEXT:    vptestmq %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X64-NEXT:    kshiftlw $14, %k0, %k0
; AVX512F-X64-NEXT:    kshiftrw $14, %k0, %k0
; AVX512F-X64-NEXT:    kmovw %k0, %eax
; AVX512F-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X64-NEXT:    vzeroupper
; AVX512F-X64-NEXT:    retq
;
; AVX512F-X86-LABEL: TEST_mm_mask_test_epi64_mask:
; AVX512F-X86:       # %bb.0: # %entry
; AVX512F-X86-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-X86-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512F-X86-NEXT:    kmovw %eax, %k1
; AVX512F-X86-NEXT:    vptestmq %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X86-NEXT:    kshiftlw $14, %k0, %k0
; AVX512F-X86-NEXT:    kshiftrw $14, %k0, %k0
; AVX512F-X86-NEXT:    kmovw %k0, %eax
; AVX512F-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X86-NEXT:    vzeroupper
; AVX512F-X86-NEXT:    retl
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = icmp ne <2 x i64> %and.i.i, zeroinitializer
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = shufflevector <8 x i1> %1, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %3 = and <2 x i1> %0, %2
  %4 = shufflevector <2 x i1> %3, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %5 = bitcast <8 x i1> %4 to i8
  ret i8 %5
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm_mask_test_epi32_mask(i8 %__U, <2 x i64> %__A, <2 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-X64-LABEL: TEST_mm_mask_test_epi32_mask:
; AVX512VL-X64:       # %bb.0: # %entry
; AVX512VL-X64-NEXT:    kmovw %edi, %k1
; AVX512VL-X64-NEXT:    vptestmd %xmm0, %xmm1, %k0 {%k1}
; AVX512VL-X64-NEXT:    kmovw %k0, %eax
; AVX512VL-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X64-NEXT:    retq
;
; AVX512VL-X86-LABEL: TEST_mm_mask_test_epi32_mask:
; AVX512VL-X86:       # %bb.0: # %entry
; AVX512VL-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512VL-X86-NEXT:    kmovw %eax, %k1
; AVX512VL-X86-NEXT:    vptestmd %xmm0, %xmm1, %k0 {%k1}
; AVX512VL-X86-NEXT:    kmovw %k0, %eax
; AVX512VL-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X86-NEXT:    retl
;
; AVX512F-X64-LABEL: TEST_mm_mask_test_epi32_mask:
; AVX512F-X64:       # %bb.0: # %entry
; AVX512F-X64-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-X64-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-X64-NEXT:    kmovw %edi, %k1
; AVX512F-X64-NEXT:    vptestmd %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X64-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-X64-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-X64-NEXT:    kmovw %k0, %eax
; AVX512F-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X64-NEXT:    vzeroupper
; AVX512F-X64-NEXT:    retq
;
; AVX512F-X86-LABEL: TEST_mm_mask_test_epi32_mask:
; AVX512F-X86:       # %bb.0: # %entry
; AVX512F-X86-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-X86-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512F-X86-NEXT:    kmovw %eax, %k1
; AVX512F-X86-NEXT:    vptestmd %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X86-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-X86-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-X86-NEXT:    kmovw %k0, %eax
; AVX512F-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X86-NEXT:    vzeroupper
; AVX512F-X86-NEXT:    retl
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <4 x i32>
  %1 = icmp ne <4 x i32> %0, zeroinitializer
  %2 = bitcast i8 %__U to <8 x i1>
  %3 = shufflevector <8 x i1> %2, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = and <4 x i1> %1, %3
  %5 = shufflevector <4 x i1> %4, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %6 = bitcast <8 x i1> %5 to i8
  ret i8 %6
}


; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm256_mask_test_epi64_mask(i8 %__U, <4 x i64> %__A, <4 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-X64-LABEL: TEST_mm256_mask_test_epi64_mask:
; AVX512VL-X64:       # %bb.0: # %entry
; AVX512VL-X64-NEXT:    kmovw %edi, %k1
; AVX512VL-X64-NEXT:    vptestmq %ymm0, %ymm1, %k0 {%k1}
; AVX512VL-X64-NEXT:    kmovw %k0, %eax
; AVX512VL-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X64-NEXT:    vzeroupper
; AVX512VL-X64-NEXT:    retq
;
; AVX512VL-X86-LABEL: TEST_mm256_mask_test_epi64_mask:
; AVX512VL-X86:       # %bb.0: # %entry
; AVX512VL-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512VL-X86-NEXT:    kmovw %eax, %k1
; AVX512VL-X86-NEXT:    vptestmq %ymm0, %ymm1, %k0 {%k1}
; AVX512VL-X86-NEXT:    kmovw %k0, %eax
; AVX512VL-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X86-NEXT:    vzeroupper
; AVX512VL-X86-NEXT:    retl
;
; AVX512F-X64-LABEL: TEST_mm256_mask_test_epi64_mask:
; AVX512F-X64:       # %bb.0: # %entry
; AVX512F-X64-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-X64-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-X64-NEXT:    kmovw %edi, %k1
; AVX512F-X64-NEXT:    vptestmq %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X64-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-X64-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-X64-NEXT:    kmovw %k0, %eax
; AVX512F-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X64-NEXT:    vzeroupper
; AVX512F-X64-NEXT:    retq
;
; AVX512F-X86-LABEL: TEST_mm256_mask_test_epi64_mask:
; AVX512F-X86:       # %bb.0: # %entry
; AVX512F-X86-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-X86-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512F-X86-NEXT:    kmovw %eax, %k1
; AVX512F-X86-NEXT:    vptestmq %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X86-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-X86-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-X86-NEXT:    kmovw %k0, %eax
; AVX512F-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X86-NEXT:    vzeroupper
; AVX512F-X86-NEXT:    retl
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = icmp ne <4 x i64> %and.i.i, zeroinitializer
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = shufflevector <8 x i1> %1, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %3 = and <4 x i1> %0, %2
  %4 = shufflevector <4 x i1> %3, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %5 = bitcast <8 x i1> %4 to i8
  ret i8 %5
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm256_mask_test_epi32_mask(i8 %__U, <4 x i64> %__A, <4 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-X64-LABEL: TEST_mm256_mask_test_epi32_mask:
; AVX512VL-X64:       # %bb.0: # %entry
; AVX512VL-X64-NEXT:    vptestmd %ymm0, %ymm1, %k0
; AVX512VL-X64-NEXT:    kmovw %k0, %eax
; AVX512VL-X64-NEXT:    andb %dil, %al
; AVX512VL-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X64-NEXT:    vzeroupper
; AVX512VL-X64-NEXT:    retq
;
; AVX512VL-X86-LABEL: TEST_mm256_mask_test_epi32_mask:
; AVX512VL-X86:       # %bb.0: # %entry
; AVX512VL-X86-NEXT:    vptestmd %ymm0, %ymm1, %k0
; AVX512VL-X86-NEXT:    kmovw %k0, %eax
; AVX512VL-X86-NEXT:    andb {{[0-9]+}}(%esp), %al
; AVX512VL-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X86-NEXT:    vzeroupper
; AVX512VL-X86-NEXT:    retl
;
; AVX512F-X64-LABEL: TEST_mm256_mask_test_epi32_mask:
; AVX512F-X64:       # %bb.0: # %entry
; AVX512F-X64-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-X64-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-X64-NEXT:    vptestmd %zmm0, %zmm1, %k0
; AVX512F-X64-NEXT:    kmovw %k0, %eax
; AVX512F-X64-NEXT:    andb %dil, %al
; AVX512F-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X64-NEXT:    vzeroupper
; AVX512F-X64-NEXT:    retq
;
; AVX512F-X86-LABEL: TEST_mm256_mask_test_epi32_mask:
; AVX512F-X86:       # %bb.0: # %entry
; AVX512F-X86-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-X86-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-X86-NEXT:    vptestmd %zmm0, %zmm1, %k0
; AVX512F-X86-NEXT:    kmovw %k0, %eax
; AVX512F-X86-NEXT:    andb {{[0-9]+}}(%esp), %al
; AVX512F-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X86-NEXT:    vzeroupper
; AVX512F-X86-NEXT:    retl
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <8 x i32>
  %1 = icmp ne <8 x i32> %0, zeroinitializer
  %2 = bitcast i8 %__U to <8 x i1>
  %3 = and <8 x i1> %1, %2
  %4 = bitcast <8 x i1> %3 to i8
  ret i8 %4
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm_testn_epi64_mask(<2 x i64> %__A, <2 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-LABEL: TEST_mm_testn_epi64_mask:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vptestnmq %xmm0, %xmm1, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-NEXT:    ret{{[l|q]}}
;
; AVX512F-LABEL: TEST_mm_testn_epi64_mask:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vptestnmq %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kshiftlw $14, %k0, %k0
; AVX512F-NEXT:    kshiftrw $14, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = icmp eq <2 x i64> %and.i.i, zeroinitializer
  %1 = shufflevector <2 x i1> %0, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %2 = bitcast <8 x i1> %1 to i8
  ret i8 %2
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm_testn_epi32_mask(<2 x i64> %__A, <2 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-LABEL: TEST_mm_testn_epi32_mask:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vptestnmd %xmm0, %xmm1, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-NEXT:    ret{{[l|q]}}
;
; AVX512F-LABEL: TEST_mm_testn_epi32_mask:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-NEXT:    vptestnmd %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <4 x i32>
  %1 = icmp eq <4 x i32> %0, zeroinitializer
  %2 = shufflevector <4 x i1> %1, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %3 = bitcast <8 x i1> %2 to i8
  ret i8 %3
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm256_testn_epi64_mask(<4 x i64> %__A, <4 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-LABEL: TEST_mm256_testn_epi64_mask:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vptestnmq %ymm0, %ymm1, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    ret{{[l|q]}}
;
; AVX512F-LABEL: TEST_mm256_testn_epi64_mask:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vptestnmq %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = icmp eq <4 x i64> %and.i.i, zeroinitializer
  %1 = shufflevector <4 x i1> %0, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %2 = bitcast <8 x i1> %1 to i8
  ret i8 %2
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm256_testn_epi32_mask(<4 x i64> %__A, <4 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-LABEL: TEST_mm256_testn_epi32_mask:
; AVX512VL:       # %bb.0: # %entry
; AVX512VL-NEXT:    vptestnmd %ymm0, %ymm1, %k0
; AVX512VL-NEXT:    kmovw %k0, %eax
; AVX512VL-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    ret{{[l|q]}}
;
; AVX512F-LABEL: TEST_mm256_testn_epi32_mask:
; AVX512F:       # %bb.0: # %entry
; AVX512F-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-NEXT:    vptestnmd %zmm0, %zmm1, %k0
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    ret{{[l|q]}}
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <8 x i32>
  %1 = icmp eq <8 x i32> %0, zeroinitializer
  %2 = bitcast <8 x i1> %1 to i8
  ret i8 %2
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm_mask_testn_epi64_mask(i8 %__U, <2 x i64> %__A, <2 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-X64-LABEL: TEST_mm_mask_testn_epi64_mask:
; AVX512VL-X64:       # %bb.0: # %entry
; AVX512VL-X64-NEXT:    kmovw %edi, %k1
; AVX512VL-X64-NEXT:    vptestnmq %xmm0, %xmm1, %k0 {%k1}
; AVX512VL-X64-NEXT:    kmovw %k0, %eax
; AVX512VL-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X64-NEXT:    retq
;
; AVX512VL-X86-LABEL: TEST_mm_mask_testn_epi64_mask:
; AVX512VL-X86:       # %bb.0: # %entry
; AVX512VL-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512VL-X86-NEXT:    kmovw %eax, %k1
; AVX512VL-X86-NEXT:    vptestnmq %xmm0, %xmm1, %k0 {%k1}
; AVX512VL-X86-NEXT:    kmovw %k0, %eax
; AVX512VL-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X86-NEXT:    retl
;
; AVX512F-X64-LABEL: TEST_mm_mask_testn_epi64_mask:
; AVX512F-X64:       # %bb.0: # %entry
; AVX512F-X64-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-X64-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-X64-NEXT:    kmovw %edi, %k1
; AVX512F-X64-NEXT:    vptestnmq %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X64-NEXT:    kshiftlw $14, %k0, %k0
; AVX512F-X64-NEXT:    kshiftrw $14, %k0, %k0
; AVX512F-X64-NEXT:    kmovw %k0, %eax
; AVX512F-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X64-NEXT:    vzeroupper
; AVX512F-X64-NEXT:    retq
;
; AVX512F-X86-LABEL: TEST_mm_mask_testn_epi64_mask:
; AVX512F-X86:       # %bb.0: # %entry
; AVX512F-X86-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-X86-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512F-X86-NEXT:    kmovw %eax, %k1
; AVX512F-X86-NEXT:    vptestnmq %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X86-NEXT:    kshiftlw $14, %k0, %k0
; AVX512F-X86-NEXT:    kshiftrw $14, %k0, %k0
; AVX512F-X86-NEXT:    kmovw %k0, %eax
; AVX512F-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X86-NEXT:    vzeroupper
; AVX512F-X86-NEXT:    retl
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = icmp eq <2 x i64> %and.i.i, zeroinitializer
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = shufflevector <8 x i1> %1, <8 x i1> undef, <2 x i32> <i32 0, i32 1>
  %3 = and <2 x i1> %0, %2
  %4 = shufflevector <2 x i1> %3, <2 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 2, i32 3, i32 2, i32 3>
  %5 = bitcast <8 x i1> %4 to i8
  ret i8 %5
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm_mask_testn_epi32_mask(i8 %__U, <2 x i64> %__A, <2 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-X64-LABEL: TEST_mm_mask_testn_epi32_mask:
; AVX512VL-X64:       # %bb.0: # %entry
; AVX512VL-X64-NEXT:    kmovw %edi, %k1
; AVX512VL-X64-NEXT:    vptestnmd %xmm0, %xmm1, %k0 {%k1}
; AVX512VL-X64-NEXT:    kmovw %k0, %eax
; AVX512VL-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X64-NEXT:    retq
;
; AVX512VL-X86-LABEL: TEST_mm_mask_testn_epi32_mask:
; AVX512VL-X86:       # %bb.0: # %entry
; AVX512VL-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512VL-X86-NEXT:    kmovw %eax, %k1
; AVX512VL-X86-NEXT:    vptestnmd %xmm0, %xmm1, %k0 {%k1}
; AVX512VL-X86-NEXT:    kmovw %k0, %eax
; AVX512VL-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X86-NEXT:    retl
;
; AVX512F-X64-LABEL: TEST_mm_mask_testn_epi32_mask:
; AVX512F-X64:       # %bb.0: # %entry
; AVX512F-X64-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-X64-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-X64-NEXT:    kmovw %edi, %k1
; AVX512F-X64-NEXT:    vptestnmd %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X64-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-X64-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-X64-NEXT:    kmovw %k0, %eax
; AVX512F-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X64-NEXT:    vzeroupper
; AVX512F-X64-NEXT:    retq
;
; AVX512F-X86-LABEL: TEST_mm_mask_testn_epi32_mask:
; AVX512F-X86:       # %bb.0: # %entry
; AVX512F-X86-NEXT:    # kill: def $xmm1 killed $xmm1 def $zmm1
; AVX512F-X86-NEXT:    # kill: def $xmm0 killed $xmm0 def $zmm0
; AVX512F-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512F-X86-NEXT:    kmovw %eax, %k1
; AVX512F-X86-NEXT:    vptestnmd %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X86-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-X86-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-X86-NEXT:    kmovw %k0, %eax
; AVX512F-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X86-NEXT:    vzeroupper
; AVX512F-X86-NEXT:    retl
entry:
  %and.i.i = and <2 x i64> %__B, %__A
  %0 = bitcast <2 x i64> %and.i.i to <4 x i32>
  %1 = icmp eq <4 x i32> %0, zeroinitializer
  %2 = bitcast i8 %__U to <8 x i1>
  %3 = shufflevector <8 x i1> %2, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %4 = and <4 x i1> %1, %3
  %5 = shufflevector <4 x i1> %4, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %6 = bitcast <8 x i1> %5 to i8
  ret i8 %6
}


; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm256_mask_testn_epi64_mask(i8 %__U, <4 x i64> %__A, <4 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-X64-LABEL: TEST_mm256_mask_testn_epi64_mask:
; AVX512VL-X64:       # %bb.0: # %entry
; AVX512VL-X64-NEXT:    kmovw %edi, %k1
; AVX512VL-X64-NEXT:    vptestnmq %ymm0, %ymm1, %k0 {%k1}
; AVX512VL-X64-NEXT:    kmovw %k0, %eax
; AVX512VL-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X64-NEXT:    vzeroupper
; AVX512VL-X64-NEXT:    retq
;
; AVX512VL-X86-LABEL: TEST_mm256_mask_testn_epi64_mask:
; AVX512VL-X86:       # %bb.0: # %entry
; AVX512VL-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512VL-X86-NEXT:    kmovw %eax, %k1
; AVX512VL-X86-NEXT:    vptestnmq %ymm0, %ymm1, %k0 {%k1}
; AVX512VL-X86-NEXT:    kmovw %k0, %eax
; AVX512VL-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X86-NEXT:    vzeroupper
; AVX512VL-X86-NEXT:    retl
;
; AVX512F-X64-LABEL: TEST_mm256_mask_testn_epi64_mask:
; AVX512F-X64:       # %bb.0: # %entry
; AVX512F-X64-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-X64-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-X64-NEXT:    kmovw %edi, %k1
; AVX512F-X64-NEXT:    vptestnmq %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X64-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-X64-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-X64-NEXT:    kmovw %k0, %eax
; AVX512F-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X64-NEXT:    vzeroupper
; AVX512F-X64-NEXT:    retq
;
; AVX512F-X86-LABEL: TEST_mm256_mask_testn_epi64_mask:
; AVX512F-X86:       # %bb.0: # %entry
; AVX512F-X86-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-X86-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; AVX512F-X86-NEXT:    kmovw %eax, %k1
; AVX512F-X86-NEXT:    vptestnmq %zmm0, %zmm1, %k0 {%k1}
; AVX512F-X86-NEXT:    kshiftlw $12, %k0, %k0
; AVX512F-X86-NEXT:    kshiftrw $12, %k0, %k0
; AVX512F-X86-NEXT:    kmovw %k0, %eax
; AVX512F-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X86-NEXT:    vzeroupper
; AVX512F-X86-NEXT:    retl
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = icmp eq <4 x i64> %and.i.i, zeroinitializer
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = shufflevector <8 x i1> %1, <8 x i1> undef, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %3 = and <4 x i1> %0, %2
  %4 = shufflevector <4 x i1> %3, <4 x i1> zeroinitializer, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %5 = bitcast <8 x i1> %4 to i8
  ret i8 %5
}

; Function Attrs: norecurse nounwind readnone
define zeroext i8 @TEST_mm256_mask_testn_epi32_mask(i8 %__U, <4 x i64> %__A, <4 x i64> %__B) local_unnamed_addr #0 {
; AVX512VL-X64-LABEL: TEST_mm256_mask_testn_epi32_mask:
; AVX512VL-X64:       # %bb.0: # %entry
; AVX512VL-X64-NEXT:    vptestnmd %ymm0, %ymm1, %k0
; AVX512VL-X64-NEXT:    kmovw %k0, %eax
; AVX512VL-X64-NEXT:    andb %dil, %al
; AVX512VL-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X64-NEXT:    vzeroupper
; AVX512VL-X64-NEXT:    retq
;
; AVX512VL-X86-LABEL: TEST_mm256_mask_testn_epi32_mask:
; AVX512VL-X86:       # %bb.0: # %entry
; AVX512VL-X86-NEXT:    vptestnmd %ymm0, %ymm1, %k0
; AVX512VL-X86-NEXT:    kmovw %k0, %eax
; AVX512VL-X86-NEXT:    andb {{[0-9]+}}(%esp), %al
; AVX512VL-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512VL-X86-NEXT:    vzeroupper
; AVX512VL-X86-NEXT:    retl
;
; AVX512F-X64-LABEL: TEST_mm256_mask_testn_epi32_mask:
; AVX512F-X64:       # %bb.0: # %entry
; AVX512F-X64-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-X64-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-X64-NEXT:    vptestnmd %zmm0, %zmm1, %k0
; AVX512F-X64-NEXT:    kmovw %k0, %eax
; AVX512F-X64-NEXT:    andb %dil, %al
; AVX512F-X64-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X64-NEXT:    vzeroupper
; AVX512F-X64-NEXT:    retq
;
; AVX512F-X86-LABEL: TEST_mm256_mask_testn_epi32_mask:
; AVX512F-X86:       # %bb.0: # %entry
; AVX512F-X86-NEXT:    # kill: def $ymm1 killed $ymm1 def $zmm1
; AVX512F-X86-NEXT:    # kill: def $ymm0 killed $ymm0 def $zmm0
; AVX512F-X86-NEXT:    vptestnmd %zmm0, %zmm1, %k0
; AVX512F-X86-NEXT:    kmovw %k0, %eax
; AVX512F-X86-NEXT:    andb {{[0-9]+}}(%esp), %al
; AVX512F-X86-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-X86-NEXT:    vzeroupper
; AVX512F-X86-NEXT:    retl
entry:
  %and.i.i = and <4 x i64> %__B, %__A
  %0 = bitcast <4 x i64> %and.i.i to <8 x i32>
  %1 = icmp eq <8 x i32> %0, zeroinitializer
  %2 = bitcast i8 %__U to <8 x i1>
  %3 = and <8 x i1> %1, %2
  %4 = bitcast <8 x i1> %3 to i8
  ret i8 %4
}

