; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+amx-tile,+amx-int8,+amx-bf16,+avx512f -verify-machineinstrs | FileCheck %s

define void @test_amx(i8* %pointer, i8* %base, i64 %stride) {
; CHECK-LABEL: test_amx:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpxord %zmm0, %zmm0, %zmm0
; CHECK-NEXT:    vmovdqu64 %zmm0, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb $1, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb $8, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw $8, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb $8, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw $8, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movb $8, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw $8, -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    ldtilecfg -{{[0-9]+}}(%rsp)
; CHECK-NEXT:    movw $8, %ax
; CHECK-NEXT:    tilezero %tmm0
; CHECK-NEXT:    tileloadd (%rsi,%rdx), %tmm1
; CHECK-NEXT:    tileloadd (%rsi,%rdx), %tmm2
; CHECK-NEXT:    tdpbssd %tmm2, %tmm1, %tmm0
; CHECK-NEXT:    tdpbsud %tmm2, %tmm1, %tmm0
; CHECK-NEXT:    tdpbusd %tmm2, %tmm1, %tmm0
; CHECK-NEXT:    tdpbuud %tmm2, %tmm1, %tmm0
; CHECK-NEXT:    tdpbf16ps %tmm2, %tmm1, %tmm0
; CHECK-NEXT:    tileloaddt1 (%rsi,%rdx), %tmm1
; CHECK-NEXT:    tilestored %tmm0, (%rdi,%rdx)
; CHECK-NEXT:    tilerelease
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
  %c = call x86_amx @llvm.x86.tilezero.internal(i16 8, i16 8)
  %a = call x86_amx @llvm.x86.tileloadd64.internal(i16 8, i16 8, i8* %base, i64 %stride)
  %b = call x86_amx @llvm.x86.tileloadd64.internal(i16 8, i16 8, i8* %base, i64 %stride)
  %d0 = call x86_amx @llvm.x86.tdpbssd.internal(i16 8, i16 8, i16 8, x86_amx %c, x86_amx %a, x86_amx %b)
  %d1 = call x86_amx @llvm.x86.tdpbsud.internal(i16 8, i16 8, i16 8, x86_amx %d0, x86_amx %a, x86_amx %b)
  %d2 = call x86_amx @llvm.x86.tdpbusd.internal(i16 8, i16 8, i16 8, x86_amx %d1, x86_amx %a, x86_amx %b)
  %d3 = call x86_amx @llvm.x86.tdpbuud.internal(i16 8, i16 8, i16 8, x86_amx %d2, x86_amx %a, x86_amx %b)
  %d4 = call x86_amx @llvm.x86.tdpbf16ps.internal(i16 8, i16 8, i16 8, x86_amx %d3, x86_amx %a, x86_amx %b)
  %e = call x86_amx @llvm.x86.tileloaddt164.internal(i16 8, i16 8, i8* %base, i64 %stride)
  call void @llvm.x86.tilestored64.internal(i16 8, i16 8, i8* %pointer, i64 %stride, x86_amx %d4)

  ret void
}

declare x86_amx @llvm.x86.tilezero.internal(i16, i16)
declare x86_amx @llvm.x86.tileloadd64.internal(i16, i16, i8*, i64)
declare x86_amx @llvm.x86.tileloaddt164.internal(i16, i16, i8*, i64)
declare x86_amx @llvm.x86.tdpbssd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbsud.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbusd.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbuud.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare x86_amx @llvm.x86.tdpbf16ps.internal(i16, i16, i16, x86_amx, x86_amx, x86_amx)
declare void @llvm.x86.tilestored64.internal(i16, i16, i8*, i64, x86_amx)
