; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+sse4a | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -fast-isel -mtriple=i386-unknown-unknown -mattr=+sse4a,+avx | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+sse4a | FileCheck %s --check-prefixes=CHECK,X64
; RUN: llc < %s -fast-isel -mtriple=x86_64-unknown-unknown -mattr=+sse4a,+avx | FileCheck %s --check-prefixes=CHECK,X64

; NOTE: This should use IR equivalent to what is generated by clang/test/CodeGen/sse4a-builtins.c

define <2 x i64> @test_mm_extracti_si64(<2 x i64> %x) {
; CHECK-LABEL: test_mm_extracti_si64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    extrq $2, $3, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse4a.extrqi(<2 x i64> %x, i8 3, i8 2)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse4a.extrqi(<2 x i64>, i8, i8) nounwind readnone

define <2 x i64> @test_mm_extract_si64(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: test_mm_extract_si64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    extrq %xmm1, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %bc = bitcast <2 x i64> %y to <16 x i8>
  %res = call <2 x i64> @llvm.x86.sse4a.extrq(<2 x i64> %x, <16 x i8> %bc)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse4a.extrq(<2 x i64>, <16 x i8>) nounwind readnone

define <2 x i64> @test_mm_inserti_si64(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: test_mm_inserti_si64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    insertq $6, $5, %xmm1, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse4a.insertqi(<2 x i64> %x, <2 x i64> %y, i8 5, i8 6)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse4a.insertqi(<2 x i64>, <2 x i64>, i8, i8) nounwind readnone

define <2 x i64> @test_mm_insert_si64(<2 x i64> %x, <2 x i64> %y) {
; CHECK-LABEL: test_mm_insert_si64:
; CHECK:       # %bb.0:
; CHECK-NEXT:    insertq %xmm1, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %res = call <2 x i64> @llvm.x86.sse4a.insertq(<2 x i64> %x, <2 x i64> %y)
  ret <2 x i64> %res
}
declare <2 x i64> @llvm.x86.sse4a.insertq(<2 x i64>, <2 x i64>) nounwind readnone

define void @test_stream_sd(double* %p, <2 x double> %a) {
; X86-LABEL: test_stream_sd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movntsd %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_stream_sd:
; X64:       # %bb.0:
; X64-NEXT:    movntsd %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = extractelement <2 x double> %a, i64 0
  store double %1, double* %p, align 1, !nontemporal !1
  ret void
}

define void @test_mm_stream_ss(float* %p, <4 x float> %a) {
; X86-LABEL: test_mm_stream_ss:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movntss %xmm0, (%eax)
; X86-NEXT:    retl
;
; X64-LABEL: test_mm_stream_ss:
; X64:       # %bb.0:
; X64-NEXT:    movntss %xmm0, (%rdi)
; X64-NEXT:    retq
  %1 = extractelement <4 x float> %a, i64 0
  store float %1, float* %p, align 1, !nontemporal !1
  ret void
}

!1 = !{i32 1}
