; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+avx512f,+avx512vbmi | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512vbmi | FileCheck %s --check-prefixes=CHECK,X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/avx512vbmi-builtins.c

define <8 x i64> @test_mm512_mask2_permutex2var_epi8(<8 x i64> %__A, <8 x i64> %__I, i64 %__U, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask2_permutex2var_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpermi2b %zmm2, %zmm0, %zmm1 {%k1}
; X86-NEXT:    vmovdqa64 %zmm1, %zmm0
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask2_permutex2var_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpermi2b %zmm2, %zmm0, %zmm1 {%k1}
; X64-NEXT:    vmovdqa64 %zmm1, %zmm0
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <64 x i8>
  %1 = bitcast <8 x i64> %__I to <64 x i8>
  %2 = bitcast <8 x i64> %__B to <64 x i8>
  %3 = tail call <64 x i8> @llvm.x86.avx512.vpermi2var.qi.512(<64 x i8> %0, <64 x i8> %1, <64 x i8> %2)
  %4 = bitcast i64 %__U to <64 x i1>
  %5 = select <64 x i1> %4, <64 x i8> %3, <64 x i8> %1
  %6 = bitcast <64 x i8> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_permutex2var_epi8(<8 x i64> %__A, <8 x i64> %__I, <8 x i64> %__B) {
; CHECK-LABEL: test_mm512_permutex2var_epi8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vpermt2b %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    ret{{[l|q]}}
entry:
  %0 = bitcast <8 x i64> %__A to <64 x i8>
  %1 = bitcast <8 x i64> %__I to <64 x i8>
  %2 = bitcast <8 x i64> %__B to <64 x i8>
  %3 = tail call <64 x i8> @llvm.x86.avx512.vpermi2var.qi.512(<64 x i8> %0, <64 x i8> %1, <64 x i8> %2)
  %4 = bitcast <64 x i8> %3 to <8 x i64>
  ret <8 x i64> %4
}

define <8 x i64> @test_mm512_mask_permutex2var_epi8(<8 x i64> %__A, i64 %__U, <8 x i64> %__I, <8 x i64> %__B) {
; X86-LABEL: test_mm512_mask_permutex2var_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpermt2b %zmm2, %zmm1, %zmm0 {%k1}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_mask_permutex2var_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpermt2b %zmm2, %zmm1, %zmm0 {%k1}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <64 x i8>
  %1 = bitcast <8 x i64> %__I to <64 x i8>
  %2 = bitcast <8 x i64> %__B to <64 x i8>
  %3 = tail call <64 x i8> @llvm.x86.avx512.vpermi2var.qi.512(<64 x i8> %0, <64 x i8> %1, <64 x i8> %2)
  %4 = bitcast i64 %__U to <64 x i1>
  %5 = select <64 x i1> %4, <64 x i8> %3, <64 x i8> %0
  %6 = bitcast <64 x i8> %5 to <8 x i64>
  ret <8 x i64> %6
}

define <8 x i64> @test_mm512_maskz_permutex2var_epi8(i64 %__U, <8 x i64> %__A, <8 x i64> %__I, <8 x i64> %__B) {
; X86-LABEL: test_mm512_maskz_permutex2var_epi8:
; X86:       # %bb.0: # %entry
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k0
; X86-NEXT:    kmovd {{[0-9]+}}(%esp), %k1
; X86-NEXT:    kunpckdq %k1, %k0, %k1
; X86-NEXT:    vpermt2b %zmm2, %zmm1, %zmm0 {%k1} {z}
; X86-NEXT:    retl
;
; X64-LABEL: test_mm512_maskz_permutex2var_epi8:
; X64:       # %bb.0: # %entry
; X64-NEXT:    kmovq %rdi, %k1
; X64-NEXT:    vpermt2b %zmm2, %zmm1, %zmm0 {%k1} {z}
; X64-NEXT:    retq
entry:
  %0 = bitcast <8 x i64> %__A to <64 x i8>
  %1 = bitcast <8 x i64> %__I to <64 x i8>
  %2 = bitcast <8 x i64> %__B to <64 x i8>
  %3 = tail call <64 x i8> @llvm.x86.avx512.vpermi2var.qi.512(<64 x i8> %0, <64 x i8> %1, <64 x i8> %2)
  %4 = bitcast i64 %__U to <64 x i1>
  %5 = select <64 x i1> %4, <64 x i8> %3, <64 x i8> zeroinitializer
  %6 = bitcast <64 x i8> %5 to <8 x i64>
  ret <8 x i64> %6
}

declare <64 x i8> @llvm.x86.avx512.vpermi2var.qi.512(<64 x i8>, <64 x i8>, <64 x i8>)
