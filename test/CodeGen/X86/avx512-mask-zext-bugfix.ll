; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O0 -mtriple=x86_64-apple-darwin -mcpu=skx -fast-isel-abort=1 | FileCheck %s

; ModuleID = 'mask_set.c'
source_filename = "mask_set.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare void @llvm.dbg.declare(metadata, metadata, metadata)

; Function Attrs: nounwind uwtable
declare i64 @calc_expected_mask_val(i8* %valp, i32 %el_size, i32 %length)
; Function Attrs: nounwind uwtable
declare i32 @check_mask16(i16 zeroext %res_mask, i16 zeroext %exp_mask, i8* %fname, i8* %input)

; Function Attrs: nounwind uwtable
define void @test_xmm(i32 %shift, i32 %mulp, <2 x i64> %a,i8* %arraydecay,i8* %fname){
; CHECK-LABEL: test_xmm:
; CHECK:       ## BB#0:
; CHECK-NEXT:    subq $56, %rsp
; CHECK-NEXT:    .cfi_def_cfa_offset 64
; CHECK-NEXT:    movl $2, %esi
; CHECK-NEXT:    movl $8, %eax
; CHECK-NEXT:    vpmovw2m %xmm0, %k0
; CHECK-NEXT:    kmovd %k0, %edi
; CHECK-NEXT:    movb %dil, %r8b
; CHECK-NEXT:    movzbl %r8b, %edi
; CHECK-NEXT:    movw %di, %r9w
; CHECK-NEXT:    movq %rdx, %rdi
; CHECK-NEXT:    movq %rdx, {{[0-9]+}}(%rsp) ## 8-byte Spill
; CHECK-NEXT:    movl %eax, %edx
; CHECK-NEXT:    movw %r9w, {{[0-9]+}}(%rsp) ## 2-byte Spill
; CHECK-NEXT:    movq %rcx, {{[0-9]+}}(%rsp) ## 8-byte Spill
; CHECK-NEXT:    vmovaps %xmm0, {{[0-9]+}}(%rsp) ## 16-byte Spill
; CHECK-NEXT:    callq _calc_expected_mask_val
; CHECK-NEXT:    movw %ax, %r9w
; CHECK-NEXT:    movw {{[0-9]+}}(%rsp), %r10w ## 2-byte Reload
; CHECK-NEXT:    movzwl %r10w, %edi
; CHECK-NEXT:    movzwl %r9w, %esi
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rdx ## 8-byte Reload
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rcx ## 8-byte Reload
; CHECK-NEXT:    callq _check_mask16
; CHECK-NEXT:    movl $4, %esi
; CHECK-NEXT:    vmovaps {{[0-9]+}}(%rsp), %xmm0 ## 16-byte Reload
; CHECK-NEXT:    vpmovd2m %xmm0, %k0
; CHECK-NEXT:    kmovd %k0, %edi
; CHECK-NEXT:    movb %dil, %r8b
; CHECK-NEXT:    movzbl %r8b, %edi
; CHECK-NEXT:    movw %di, %r9w
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rdi ## 8-byte Reload
; CHECK-NEXT:    movl %esi, {{[0-9]+}}(%rsp) ## 4-byte Spill
; CHECK-NEXT:    movl {{[0-9]+}}(%rsp), %edx ## 4-byte Reload
; CHECK-NEXT:    movl %eax, {{[0-9]+}}(%rsp) ## 4-byte Spill
; CHECK-NEXT:    movw %r9w, {{[0-9]+}}(%rsp) ## 2-byte Spill
; CHECK-NEXT:    callq _calc_expected_mask_val
; CHECK-NEXT:    movw %ax, %r9w
; CHECK-NEXT:    movw {{[0-9]+}}(%rsp), %r10w ## 2-byte Reload
; CHECK-NEXT:    movzwl %r10w, %edi
; CHECK-NEXT:    movzwl %r9w, %esi
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rdx ## 8-byte Reload
; CHECK-NEXT:    movq {{[0-9]+}}(%rsp), %rcx ## 8-byte Reload
; CHECK-NEXT:    callq _check_mask16
; CHECK-NEXT:    movl %eax, (%rsp) ## 4-byte Spill
; CHECK-NEXT:    addq $56, %rsp
; CHECK-NEXT:    retq
  %d2 = bitcast <2 x i64> %a to <8 x i16>
  %m2 = call i8 @llvm.x86.avx512.cvtw2mask.128(<8 x i16> %d2)
  %conv7 = zext i8 %m2 to i16
  %call9 = call i64 @calc_expected_mask_val(i8* %arraydecay, i32 2, i32 8)
  %conv10 = trunc i64 %call9 to i16
  %call12 = call i32 @check_mask16(i16 zeroext %conv7, i16 zeroext %conv10, i8* %fname, i8* %arraydecay)
  %d3 = bitcast <2 x i64> %a to <4 x i32>
  %m3 = call i8 @llvm.x86.avx512.cvtd2mask.128(<4 x i32> %d3)
  %conv14 = zext i8 %m3 to i16
  %call16 = call i64 @calc_expected_mask_val(i8* %arraydecay, i32 4, i32 4)
  %conv17 = trunc i64 %call16 to i16
  %call19 = call i32 @check_mask16(i16 zeroext %conv14, i16 zeroext %conv17, i8* %fname, i8* %arraydecay)
  ret void
}

; Function Attrs: nounwind readnone
declare i8 @llvm.x86.avx512.cvtw2mask.128(<8 x i16>)

; Function Attrs: nounwind readnone
declare i8 @llvm.x86.avx512.cvtd2mask.128(<4 x i32>)

