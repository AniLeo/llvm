; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+avx512f,+avx512vbmi2 | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vbmi2 | FileCheck %s --check-prefixes=CHECK,X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/avx512vbmi2-builtins.c

define <8 x i64> @test_mm512_mask_compress_epi16(<8 x i64> %__S, i32 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_mask_compress_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpcompressw %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_compress_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpcompressw %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <32 x i16>
  %1 = bitcast <8 x i64> %__S to <32 x i16>
  %2 = tail call <32 x i16> @llvm.x86.avx512.mask.compress.w.512(<32 x i16> %0, <32 x i16> %1, i32 %__U)
  %3 = bitcast <32 x i16> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_maskz_compress_epi16(i32 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_maskz_compress_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpcompressw %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_compress_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpcompressw %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <32 x i16>
  %1 = tail call <32 x i16> @llvm.x86.avx512.mask.compress.w.512(<32 x i16> %0, <32 x i16> zeroinitializer, i32 %__U)
  %2 = bitcast <32 x i16> %1 to <8 x i64>
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_mask_compress_epi8(<8 x i64> %__S, i64 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_mask_compress_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpcompressb %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_compress_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpcompressb %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <64 x i8>
  %1 = bitcast <8 x i64> %__S to <64 x i8>
  %2 = tail call <64 x i8> @llvm.x86.avx512.mask.compress.b.512(<64 x i8> %0, <64 x i8> %1, i64 %__U)
  %3 = bitcast <64 x i8> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_maskz_compress_epi8(i64 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_maskz_compress_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpcompressb %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_compress_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpcompressb %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <64 x i8>
  %1 = tail call <64 x i8> @llvm.x86.avx512.mask.compress.b.512(<64 x i8> %0, <64 x i8> zeroinitializer, i64 %__U)
  %2 = bitcast <64 x i8> %1 to <8 x i64>
  ret <8 x i64> %2
}

define void @test_mm512_mask_compressstoreu_epi16(ptr %__P, i32 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_mask_compressstoreu_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpcompressw %zmm0, (%eax) {%k1}
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_compressstoreu_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %esi, %k1
; X64-NEXT:    vpcompressw %zmm0, (%rdi) {%k1}
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <32 x i16>
  %1 = bitcast i32 %__U to <32 x i1>
  tail call void @llvm.masked.compressstore.v32i16(<32 x i16> %0, ptr %__P, <32 x i1> %1)
  ret void
}

define void @test_mm512_mask_compressstoreu_epi8(ptr %__P, i64 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_mask_compressstoreu_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpcompressb %zmm0, (%eax) {%k1}
; X86-NEXT:    vzeroupper
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_compressstoreu_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rsi, %k1
; X64-NEXT:    vpcompressb %zmm0, (%rdi) {%k1}
; X64-NEXT:    vzeroupper
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <64 x i8>
  %1 = bitcast i64 %__U to <64 x i1>
  tail call void @llvm.masked.compressstore.v64i8(<64 x i8> %0, ptr %__P, <64 x i1> %1)
  ret void
}

define <8 x i64> @test_mm512_mask_expand_epi16(<8 x i64> %__S, i32 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_mask_expand_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpexpandw %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_expand_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpexpandw %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <32 x i16>
  %1 = bitcast <8 x i64> %__S to <32 x i16>
  %2 = tail call <32 x i16> @llvm.x86.avx512.mask.expand.w.512(<32 x i16> %0, <32 x i16> %1, i32 %__U)
  %3 = bitcast <32 x i16> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_maskz_expand_epi16(i32 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_maskz_expand_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpexpandw %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_expand_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpexpandw %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <32 x i16>
  %1 = tail call <32 x i16> @llvm.x86.avx512.mask.expand.w.512(<32 x i16> %0, <32 x i16> zeroinitializer, i32 %__U)
  %2 = bitcast <32 x i16> %1 to <8 x i64>
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_mask_expand_epi8(<8 x i64> %__S, i64 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_mask_expand_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpexpandb %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_expand_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpexpandb %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <64 x i8>
  %1 = bitcast <8 x i64> %__S to <64 x i8>
  %2 = tail call <64 x i8> @llvm.x86.avx512.mask.expand.b.512(<64 x i8> %0, <64 x i8> %1, i64 %__U)
  %3 = bitcast <64 x i8> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_maskz_expand_epi8(i64 %__U, <8 x i64> %__D) {
; X86-LABEL: test_mm512_maskz_expand_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpexpandb %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_expand_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpexpandb %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__D to <64 x i8>
  %1 = tail call <64 x i8> @llvm.x86.avx512.mask.expand.b.512(<64 x i8> %0, <64 x i8> zeroinitializer, i64 %__U)
  %2 = bitcast <64 x i8> %1 to <8 x i64>
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_mask_expandloadu_epi16(<8 x i64> %__S, i32 %__U, ptr readonly %__P) {
; X86-LABEL: test_mm512_mask_expandloadu_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpexpandw (%eax), %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_expandloadu_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpexpandw (%rsi), %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <32 x i16>
  %1 = bitcast i32 %__U to <32 x i1>
  %2 = tail call <32 x i16> @llvm.masked.expandload.v32i16(ptr %__P, <32 x i1> %1, <32 x i16> %0)
  %3 = bitcast <32 x i16> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_maskz_expandloadu_epi16(i32 %__U, ptr readonly %__P) {
; X86-LABEL: test_mm512_maskz_expandloadu_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpexpandw (%eax), %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_expandloadu_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpexpandw (%rsi), %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast i32 %__U to <32 x i1>
  %1 = tail call <32 x i16> @llvm.masked.expandload.v32i16(ptr %__P, <32 x i1> %0, <32 x i16> zeroinitializer)
  %2 = bitcast <32 x i16> %1 to <8 x i64>
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_mask_expandloadu_epi8(<8 x i64> %__S, i64 %__U, ptr readonly %__P) {
; X86-LABEL: test_mm512_mask_expandloadu_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpexpandb (%eax), %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_expandloadu_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpexpandb (%rsi), %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <64 x i8>
  %1 = bitcast i64 %__U to <64 x i1>
  %2 = tail call <64 x i8> @llvm.masked.expandload.v64i8(ptr %__P, <64 x i1> %1, <64 x i8> %0)
  %3 = bitcast <64 x i8> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_maskz_expandloadu_epi8(i64 %__U, ptr readonly %__P) {
; X86-LABEL: test_mm512_maskz_expandloadu_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpexpandb (%eax), %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_expandloadu_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpexpandb (%rsi), %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast i64 %__U to <64 x i1>
  %1 = tail call <64 x i8> @llvm.masked.expandload.v64i8(ptr %__P, <64 x i1> %0, <64 x i8> zeroinitializer)
  %2 = bitcast <64 x i8> %1 to <8 x i64>
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_mask_shldi_epi64(<8 x i64> %__S, i8 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shldi_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd %eax, %k1
; X86-NEXT:    vpshldq $47, %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shldi_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldq $47, %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = tail call <8 x i64> @llvm.fshl.v8i64(<8 x i64> %__A, <8 x i64> %__B, <8 x i64> <i64 47, i64 47, i64 47, i64 47, i64 47, i64 47, i64 47, i64 47>)
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = select <8 x i1> %1, <8 x i64> %0, <8 x i64> %__S
  ret <8 x i64> %2
}

declare <8 x i64> @llvm.fshl.v8i64(<8 x i64>, <8 x i64>, <8 x i64>)

define <8 x i64> @test_mm512_maskz_shldi_epi64(i8 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shldi_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd %eax, %k1
; X86-NEXT:    vpshldq $63, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shldi_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldq $63, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = tail call <8 x i64> @llvm.fshl.v8i64(<8 x i64> %__A, <8 x i64> %__B, <8 x i64> <i64 63, i64 63, i64 63, i64 63, i64 63, i64 63, i64 63, i64 63>)
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = select <8 x i1> %1, <8 x i64> %0, <8 x i64> zeroinitializer
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_shldi_epi64(<8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shldi_epi64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshldq $31, %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = tail call <8 x i64> @llvm.fshl.v8i64(<8 x i64> %__A, <8 x i64> %__B, <8 x i64> <i64 31, i64 31, i64 31, i64 31, i64 31, i64 31, i64 31, i64 31>)
  ret <8 x i64> %0
}

define <8 x i64> @test_mm512_mask_shldi_epi32(<8 x i64> %__S, i16 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shldi_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshldd $7, %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shldi_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldd $7, %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <16 x i32>
  %1 = bitcast <8 x i64> %__B to <16 x i32>
  %2 = tail call <16 x i32> @llvm.fshl.v16i32(<16 x i32> %0, <16 x i32> %1, <16 x i32> <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>)
  %3 = bitcast <8 x i64> %__S to <16 x i32>
  %4 = bitcast i16 %__U to <16 x i1>
  %5 = select <16 x i1> %4, <16 x i32> %2, <16 x i32> %3
  %6 = bitcast <16 x i32> %5 to <8 x i64>
  ret <8 x i64> %6
}

declare <16 x i32> @llvm.fshl.v16i32(<16 x i32>, <16 x i32>, <16 x i32>)

define <8 x i64> @test_mm512_maskz_shldi_epi32(i16 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shldi_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshldd $15, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shldi_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldd $15, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <16 x i32>
  %1 = bitcast <8 x i64> %__B to <16 x i32>
  %2 = tail call <16 x i32> @llvm.fshl.v16i32(<16 x i32> %0, <16 x i32> %1, <16 x i32> <i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>)
  %3 = bitcast i16 %__U to <16 x i1>
  %4 = select <16 x i1> %3, <16 x i32> %2, <16 x i32> zeroinitializer
  %5 = bitcast <16 x i32> %4 to <8 x i64>
  ret <8 x i64> %5
}

define <8 x i64> @test_mm512_shldi_epi32(<8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shldi_epi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshldd $31, %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = bitcast <8 x i64> %__A to <16 x i32>
  %1 = bitcast <8 x i64> %__B to <16 x i32>
  %2 = tail call <16 x i32> @llvm.fshl.v16i32(<16 x i32> %0, <16 x i32> %1, <16 x i32> <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>)
  %3 = bitcast <16 x i32> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_mask_shldi_epi16(<8 x i64> %__S, i32 %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shldi_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshldw $3, %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shldi_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldw $3, %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <32 x i16>
  %1 = bitcast <8 x i64> %__B to <32 x i16>
  %2 = tail call <32 x i16> @llvm.fshl.v32i16(<32 x i16> %0, <32 x i16> %1, <32 x i16> <i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3>)
  %3 = bitcast <8 x i64> %__S to <32 x i16>
  %4 = bitcast i32 %__U to <32 x i1>
  %5 = select <32 x i1> %4, <32 x i16> %2, <32 x i16> %3
  %6 = bitcast <32 x i16> %5 to <8 x i64>
  ret <8 x i64> %6
}

declare <32 x i16> @llvm.fshl.v32i16(<32 x i16>, <32 x i16>, <32 x i16>)

define <8 x i64> @test_mm512_maskz_shldi_epi16(i32 %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shldi_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshldw $7, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shldi_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldw $7, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <32 x i16>
  %1 = bitcast <8 x i64> %__B to <32 x i16>
  %2 = tail call <32 x i16> @llvm.fshl.v32i16(<32 x i16> %0, <32 x i16> %1, <32 x i16> <i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7, i16 7>)
  %3 = bitcast i32 %__U to <32 x i1>
  %4 = select <32 x i1> %3, <32 x i16> %2, <32 x i16> zeroinitializer
  %5 = bitcast <32 x i16> %4 to <8 x i64>
  ret <8 x i64> %5
}

define <8 x i64> @test_mm512_shldi_epi16(<8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shldi_epi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshldw $15, %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = bitcast <8 x i64> %__A to <32 x i16>
  %1 = bitcast <8 x i64> %__B to <32 x i16>
  %2 = tail call <32 x i16> @llvm.fshl.v32i16(<32 x i16> %0, <32 x i16> %1, <32 x i16> <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>)
  %3 = bitcast <32 x i16> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_mask_shrdi_epi64(<8 x i64> %__S, i8 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shrdi_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd %eax, %k1
; X86-NEXT:    vpshrdq $47, %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shrdi_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdq $47, %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = tail call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %__B, <8 x i64> %__A, <8 x i64> <i64 47, i64 47, i64 47, i64 47, i64 47, i64 47, i64 47, i64 47>)
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = select <8 x i1> %1, <8 x i64> %0, <8 x i64> %__S
  ret <8 x i64> %2
}

declare <8 x i64> @llvm.fshr.v8i64(<8 x i64>, <8 x i64>, <8 x i64>)

define <8 x i64> @test_mm512_maskz_shrdi_epi64(i8 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shrdi_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd %eax, %k1
; X86-NEXT:    vpshrdq $63, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shrdi_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdq $63, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = tail call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %__B, <8 x i64> %__A, <8 x i64> <i64 63, i64 63, i64 63, i64 63, i64 63, i64 63, i64 63, i64 63>)
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = select <8 x i1> %1, <8 x i64> %0, <8 x i64> zeroinitializer
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_shrdi_epi64(<8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shrdi_epi64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshrdq $31, %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = tail call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %__B, <8 x i64> %__A, <8 x i64> <i64 31, i64 31, i64 31, i64 31, i64 31, i64 31, i64 31, i64 31>)
  ret <8 x i64> %0
}

define <8 x i64> @test_mm512_mask_shrdi_epi32(<8 x i64> %__S, i16 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shrdi_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshrdd $7, %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shrdi_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdd $7, %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <16 x i32>
  %1 = bitcast <8 x i64> %__B to <16 x i32>
  %2 = tail call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %1, <16 x i32> %0, <16 x i32> <i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7, i32 7>)
  %3 = bitcast <8 x i64> %__S to <16 x i32>
  %4 = bitcast i16 %__U to <16 x i1>
  %5 = select <16 x i1> %4, <16 x i32> %2, <16 x i32> %3
  %6 = bitcast <16 x i32> %5 to <8 x i64>
  ret <8 x i64> %6
}

declare <16 x i32> @llvm.fshr.v16i32(<16 x i32>, <16 x i32>, <16 x i32>)

define <8 x i64> @test_mm512_maskz_shrdi_epi32(i16 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shrdi_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshrdd $15, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shrdi_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdd $15, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <16 x i32>
  %1 = bitcast <8 x i64> %__B to <16 x i32>
  %2 = tail call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %1, <16 x i32> %0, <16 x i32> <i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>)
  %3 = bitcast i16 %__U to <16 x i1>
  %4 = select <16 x i1> %3, <16 x i32> %2, <16 x i32> zeroinitializer
  %5 = bitcast <16 x i32> %4 to <8 x i64>
  ret <8 x i64> %5
}

define <8 x i64> @test_mm512_shrdi_epi32(<8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shrdi_epi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshrdd $31, %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = bitcast <8 x i64> %__A to <16 x i32>
  %1 = bitcast <8 x i64> %__B to <16 x i32>
  %2 = tail call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %1, <16 x i32> %0, <16 x i32> <i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31, i32 31>)
  %3 = bitcast <16 x i32> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_mask_shrdi_epi16(<8 x i64> %__S, i32 %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shrdi_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshrdw $3, %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shrdi_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdw $3, %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <32 x i16>
  %1 = bitcast <8 x i64> %__B to <32 x i16>
  %2 = tail call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %1, <32 x i16> %0, <32 x i16> <i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3, i16 3>)
  %3 = bitcast <8 x i64> %__S to <32 x i16>
  %4 = bitcast i32 %__U to <32 x i1>
  %5 = select <32 x i1> %4, <32 x i16> %2, <32 x i16> %3
  %6 = bitcast <32 x i16> %5 to <8 x i64>
  ret <8 x i64> %6
}

declare <32 x i16> @llvm.fshr.v32i16(<32 x i16>, <32 x i16>, <32 x i16>)

define <8 x i64> @test_mm512_maskz_shrdi_epi16(i32 %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shrdi_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshrdw $15, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shrdi_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdw $15, %zmm1, %zmm0, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <32 x i16>
  %1 = bitcast <8 x i64> %__B to <32 x i16>
  %2 = tail call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %1, <32 x i16> %0, <32 x i16> <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>)
  %3 = bitcast i32 %__U to <32 x i1>
  %4 = select <32 x i1> %3, <32 x i16> %2, <32 x i16> zeroinitializer
  %5 = bitcast <32 x i16> %4 to <8 x i64>
  ret <8 x i64> %5
}

define <8 x i64> @test_mm512_shrdi_epi16(<8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shrdi_epi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshrdw $15, %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = bitcast <8 x i64> %__A to <32 x i16>
  %1 = bitcast <8 x i64> %__B to <32 x i16>
  %2 = tail call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %1, <32 x i16> %0, <32 x i16> <i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31, i16 31>)
  %3 = bitcast <32 x i16> %2 to <8 x i64>
  ret <8 x i64> %3
}

define <8 x i64> @test_mm512_mask_shldv_epi64(<8 x i64> %__S, i8 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shldv_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd %eax, %k1
; X86-NEXT:    vpshldvq %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shldv_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldvq %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = tail call <8 x i64> @llvm.fshl.v8i64(<8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B)
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = select <8 x i1> %1, <8 x i64> %0, <8 x i64> %__S
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_maskz_shldv_epi64(i8 zeroext %__U, <8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shldv_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd %eax, %k1
; X86-NEXT:    vpshldvq %zmm2, %zmm1, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shldv_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldvq %zmm2, %zmm1, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = tail call <8 x i64> @llvm.fshl.v8i64(<8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B)
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = select <8 x i1> %1, <8 x i64> %0, <8 x i64> zeroinitializer
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_shldv_epi64(<8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shldv_epi64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshldvq %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = tail call <8 x i64> @llvm.fshl.v8i64(<8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B)
  ret <8 x i64> %0
}

define <8 x i64> @test_mm512_mask_shldv_epi32(<8 x i64> %__S, i16 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shldv_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshldvd %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shldv_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldvd %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <16 x i32>
  %1 = bitcast <8 x i64> %__A to <16 x i32>
  %2 = bitcast <8 x i64> %__B to <16 x i32>
  %3 = tail call <16 x i32> @llvm.fshl.v16i32(<16 x i32> %0, <16 x i32> %1, <16 x i32> %2)
  %4 = bitcast i16 %__U to <16 x i1>
  %5 = select <16 x i1> %4, <16 x i32> %3, <16 x i32> %0
  %6 = bitcast <16 x i32> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_maskz_shldv_epi32(i16 zeroext %__U, <8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shldv_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshldvd %zmm2, %zmm1, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shldv_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldvd %zmm2, %zmm1, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <16 x i32>
  %1 = bitcast <8 x i64> %__A to <16 x i32>
  %2 = bitcast <8 x i64> %__B to <16 x i32>
  %3 = tail call <16 x i32> @llvm.fshl.v16i32(<16 x i32> %0, <16 x i32> %1, <16 x i32> %2)
  %4 = bitcast i16 %__U to <16 x i1>
  %5 = select <16 x i1> %4, <16 x i32> %3, <16 x i32> zeroinitializer
  %6 = bitcast <16 x i32> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_shldv_epi32(<8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shldv_epi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshldvd %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = bitcast <8 x i64> %__S to <16 x i32>
  %1 = bitcast <8 x i64> %__A to <16 x i32>
  %2 = bitcast <8 x i64> %__B to <16 x i32>
  %3 = tail call <16 x i32> @llvm.fshl.v16i32(<16 x i32> %0, <16 x i32> %1, <16 x i32> %2)
  %4 = bitcast <16 x i32> %3 to <8 x i64>
  ret <8 x i64> %4
}

define <8 x i64> @test_mm512_mask_shldv_epi16(<8 x i64> %__S, i32 %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shldv_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshldvw %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shldv_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldvw %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <32 x i16>
  %1 = bitcast <8 x i64> %__A to <32 x i16>
  %2 = bitcast <8 x i64> %__B to <32 x i16>
  %3 = tail call <32 x i16> @llvm.fshl.v32i16(<32 x i16> %0, <32 x i16> %1, <32 x i16> %2)
  %4 = bitcast i32 %__U to <32 x i1>
  %5 = select <32 x i1> %4, <32 x i16> %3, <32 x i16> %0
  %6 = bitcast <32 x i16> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_maskz_shldv_epi16(i32 %__U, <8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shldv_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshldvw %zmm2, %zmm1, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shldv_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshldvw %zmm2, %zmm1, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <32 x i16>
  %1 = bitcast <8 x i64> %__A to <32 x i16>
  %2 = bitcast <8 x i64> %__B to <32 x i16>
  %3 = tail call <32 x i16> @llvm.fshl.v32i16(<32 x i16> %0, <32 x i16> %1, <32 x i16> %2)
  %4 = bitcast i32 %__U to <32 x i1>
  %5 = select <32 x i1> %4, <32 x i16> %3, <32 x i16> zeroinitializer
  %6 = bitcast <32 x i16> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_shldv_epi16(<8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shldv_epi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshldvw %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = bitcast <8 x i64> %__S to <32 x i16>
  %1 = bitcast <8 x i64> %__A to <32 x i16>
  %2 = bitcast <8 x i64> %__B to <32 x i16>
  %3 = tail call <32 x i16> @llvm.fshl.v32i16(<32 x i16> %0, <32 x i16> %1, <32 x i16> %2)
  %4 = bitcast <32 x i16> %3 to <8 x i64>
  ret <8 x i64> %4
}

define <8 x i64> @test_mm512_mask_shrdv_epi64(<8 x i64> %__S, i8 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shrdv_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd %eax, %k1
; X86-NEXT:    vpshrdvq %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shrdv_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdvq %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = tail call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %__A, <8 x i64> %__S, <8 x i64> %__B)
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = select <8 x i1> %1, <8 x i64> %0, <8 x i64> %__S
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_maskz_shrdv_epi64(i8 zeroext %__U, <8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shrdv_epi64:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movzbl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    kmovd %eax, %k1
; X86-NEXT:    vpshrdvq %zmm2, %zmm1, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shrdv_epi64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdvq %zmm2, %zmm1, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = tail call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %__A, <8 x i64> %__S, <8 x i64> %__B)
  %1 = bitcast i8 %__U to <8 x i1>
  %2 = select <8 x i1> %1, <8 x i64> %0, <8 x i64> zeroinitializer
  ret <8 x i64> %2
}

define <8 x i64> @test_mm512_shrdv_epi64(<8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shrdv_epi64:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshrdvq %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = tail call <8 x i64> @llvm.fshr.v8i64(<8 x i64> %__A, <8 x i64> %__S, <8 x i64> %__B)
  ret <8 x i64> %0
}

define <8 x i64> @test_mm512_mask_shrdv_epi32(<8 x i64> %__S, i16 zeroext %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shrdv_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshrdvd %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shrdv_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdvd %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <16 x i32>
  %1 = bitcast <8 x i64> %__A to <16 x i32>
  %2 = bitcast <8 x i64> %__B to <16 x i32>
  %3 = tail call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %1, <16 x i32> %0, <16 x i32> %2)
  %4 = bitcast i16 %__U to <16 x i1>
  %5 = select <16 x i1> %4, <16 x i32> %3, <16 x i32> %0
  %6 = bitcast <16 x i32> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_maskz_shrdv_epi32(i16 zeroext %__U, <8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shrdv_epi32:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovw {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshrdvd %zmm2, %zmm1, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shrdv_epi32:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdvd %zmm2, %zmm1, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <16 x i32>
  %1 = bitcast <8 x i64> %__A to <16 x i32>
  %2 = bitcast <8 x i64> %__B to <16 x i32>
  %3 = tail call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %1, <16 x i32> %0, <16 x i32> %2)
  %4 = bitcast i16 %__U to <16 x i1>
  %5 = select <16 x i1> %4, <16 x i32> %3, <16 x i32> zeroinitializer
  %6 = bitcast <16 x i32> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_shrdv_epi32(<8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shrdv_epi32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshrdvd %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = bitcast <8 x i64> %__S to <16 x i32>
  %1 = bitcast <8 x i64> %__A to <16 x i32>
  %2 = bitcast <8 x i64> %__B to <16 x i32>
  %3 = tail call <16 x i32> @llvm.fshr.v16i32(<16 x i32> %1, <16 x i32> %0, <16 x i32> %2)
  %4 = bitcast <16 x i32> %3 to <8 x i64>
  ret <8 x i64> %4
}

define <8 x i64> @test_mm512_mask_shrdv_epi16(<8 x i64> %__S, i32 %__U, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_shrdv_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshrdvw %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_shrdv_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdvw %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <32 x i16>
  %1 = bitcast <8 x i64> %__A to <32 x i16>
  %2 = bitcast <8 x i64> %__B to <32 x i16>
  %3 = tail call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %1, <32 x i16> %0, <32 x i16> %2)
  %4 = bitcast i32 %__U to <32 x i1>
  %5 = select <32 x i1> %4, <32 x i16> %3, <32 x i16> %0
  %6 = bitcast <32 x i16> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_maskz_shrdv_epi16(i32 %__U, <8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_shrdv_epi16:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    vpshrdvw %zmm2, %zmm1, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_shrdv_epi16:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovd %edi, %k1
; X64-NEXT:    vpshrdvw %zmm2, %zmm1, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__S to <32 x i16>
  %1 = bitcast <8 x i64> %__A to <32 x i16>
  %2 = bitcast <8 x i64> %__B to <32 x i16>
  %3 = tail call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %1, <32 x i16> %0, <32 x i16> %2)
  %4 = bitcast i32 %__U to <32 x i1>
  %5 = select <32 x i1> %4, <32 x i16> %3, <32 x i16> zeroinitializer
  %6 = bitcast <32 x i16> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_shrdv_epi16(<8 x i64> %__S, <8 x i64> %__A, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_shrdv_epi16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpshrdvw %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = bitcast <8 x i64> %__S to <32 x i16>
  %1 = bitcast <8 x i64> %__A to <32 x i16>
  %2 = bitcast <8 x i64> %__B to <32 x i16>
  %3 = tail call <32 x i16> @llvm.fshr.v32i16(<32 x i16> %1, <32 x i16> %0, <32 x i16> %2)
  %4 = bitcast <32 x i16> %3 to <8 x i64>
  ret <8 x i64> %4
}

declare <32 x i16> @llvm.x86.avx512.mask.compress.w.512(<32 x i16>, <32 x i16>, i32)
declare <64 x i8> @llvm.x86.avx512.mask.compress.b.512(<64 x i8>, <64 x i8>, i64)
declare void @llvm.masked.compressstore.v32i16(<32 x i16>, ptr, <32 x i1>)
declare void @llvm.masked.compressstore.v64i8(<64 x i8>, ptr, <64 x i1>)
declare <32 x i16> @llvm.x86.avx512.mask.expand.w.512(<32 x i16>, <32 x i16>, i32)
declare <64 x i8> @llvm.x86.avx512.mask.expand.b.512(<64 x i8>, <64 x i8>, i64)
declare <32 x i16> @llvm.masked.expandload.v32i16(ptr, <32 x i1>, <32 x i16>)
declare <64 x i8> @llvm.masked.expandload.v64i8(ptr, <64 x i1>, <64 x i8>)
