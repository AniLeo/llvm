; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -disable-peephole -mtriple=i686-unknown-unknown -mattr=+avx,+xop | FileCheck %s --check-prefixes=CHECK,X86
; RUN: llc < %s -disable-peephole -mtriple=x86_64-unknown-unknown -mattr=+avx,+xop | FileCheck %s --check-prefixes=CHECK,X64

define <16 x i8> @commute_fold_vpcomb(ptr %a0, <16 x i8> %a1) {
; X86-LABEL: commute_fold_vpcomb:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpcomgtb (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpcomb:
; X64:       # %bb.0:
; X64-NEXT:    vpcomgtb (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <16 x i8>, ptr %a0
  %2 = call <16 x i8> @llvm.x86.xop.vpcomb(<16 x i8> %1, <16 x i8> %a1, i8 0) ; vpcomltb
  ret <16 x i8> %2
}
declare <16 x i8> @llvm.x86.xop.vpcomb(<16 x i8>, <16 x i8>, i8) nounwind readnone

define <4 x i32> @commute_fold_vpcomd(ptr %a0, <4 x i32> %a1) {
; X86-LABEL: commute_fold_vpcomd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpcomged (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpcomd:
; X64:       # %bb.0:
; X64-NEXT:    vpcomged (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <4 x i32>, ptr %a0
  %2 = call <4 x i32> @llvm.x86.xop.vpcomd(<4 x i32> %1, <4 x i32> %a1, i8 1) ; vpcomled
  ret <4 x i32> %2
}
declare <4 x i32> @llvm.x86.xop.vpcomd(<4 x i32>, <4 x i32>, i8) nounwind readnone

define <2 x i64> @commute_fold_vpcomq(ptr %a0, <2 x i64> %a1) {
; X86-LABEL: commute_fold_vpcomq:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpcomltq (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpcomq:
; X64:       # %bb.0:
; X64-NEXT:    vpcomltq (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <2 x i64>, ptr %a0
  %2 = call <2 x i64> @llvm.x86.xop.vpcomq(<2 x i64> %1, <2 x i64> %a1, i8 2) ; vpcomgtq
  ret <2 x i64> %2
}
declare <2 x i64> @llvm.x86.xop.vpcomq(<2 x i64>, <2 x i64>, i8) nounwind readnone

define <16 x i8> @commute_fold_vpcomub(ptr %a0, <16 x i8> %a1) {
; X86-LABEL: commute_fold_vpcomub:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpcomleub (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpcomub:
; X64:       # %bb.0:
; X64-NEXT:    vpcomleub (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <16 x i8>, ptr %a0
  %2 = call <16 x i8> @llvm.x86.xop.vpcomub(<16 x i8> %1, <16 x i8> %a1, i8 3) ; vpcomgeub
  ret <16 x i8> %2
}
declare <16 x i8> @llvm.x86.xop.vpcomub(<16 x i8>, <16 x i8>, i8) nounwind readnone

define <4 x i32> @commute_fold_vpcomud(ptr %a0, <4 x i32> %a1) {
; X86-LABEL: commute_fold_vpcomud:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpcomeqd (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpcomud:
; X64:       # %bb.0:
; X64-NEXT:    vpcomeqd (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <4 x i32>, ptr %a0
  %2 = call <4 x i32> @llvm.x86.xop.vpcomud(<4 x i32> %1, <4 x i32> %a1, i8 4) ; vpcomequd
  ret <4 x i32> %2
}
declare <4 x i32> @llvm.x86.xop.vpcomud(<4 x i32>, <4 x i32>, i8) nounwind readnone

define <2 x i64> @commute_fold_vpcomuq(ptr %a0, <2 x i64> %a1) {
; X86-LABEL: commute_fold_vpcomuq:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpcomneqq (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpcomuq:
; X64:       # %bb.0:
; X64-NEXT:    vpcomneqq (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <2 x i64>, ptr %a0
  %2 = call <2 x i64> @llvm.x86.xop.vpcomuq(<2 x i64> %1, <2 x i64> %a1, i8 5) ; vpcomnequq
  ret <2 x i64> %2
}
declare <2 x i64> @llvm.x86.xop.vpcomuq(<2 x i64>, <2 x i64>, i8) nounwind readnone

define <8 x i16> @commute_fold_vpcomuw(ptr %a0, <8 x i16> %a1) {
; CHECK-LABEL: commute_fold_vpcomuw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = load <8 x i16>, ptr %a0
  %2 = call <8 x i16> @llvm.x86.xop.vpcomuw(<8 x i16> %1, <8 x i16> %a1, i8 6) ; vpcomfalseuw
  ret <8 x i16> %2
}
declare <8 x i16> @llvm.x86.xop.vpcomuw(<8 x i16>, <8 x i16>, i8) nounwind readnone

define <8 x i16> @commute_fold_vpcomw(ptr %a0, <8 x i16> %a1) {
; CHECK-LABEL: commute_fold_vpcomw:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpcmpeqd %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    ret{{[l|q]}}
  %1 = load <8 x i16>, ptr %a0
  %2 = call <8 x i16> @llvm.x86.xop.vpcomw(<8 x i16> %1, <8 x i16> %a1, i8 7) ; vpcomtruew
  ret <8 x i16> %2
}
declare <8 x i16> @llvm.x86.xop.vpcomw(<8 x i16>, <8 x i16>, i8) nounwind readnone

define <4 x i32> @commute_fold_vpmacsdd(ptr %a0, <4 x i32> %a1, <4 x i32> %a2) {
; X86-LABEL: commute_fold_vpmacsdd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacsdd %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacsdd:
; X64:       # %bb.0:
; X64-NEXT:    vpmacsdd %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <4 x i32>, ptr %a0
  %2 = call <4 x i32> @llvm.x86.xop.vpmacsdd(<4 x i32> %1, <4 x i32> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}
declare <4 x i32> @llvm.x86.xop.vpmacsdd(<4 x i32>, <4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @commute_fold_vpmacsdqh(ptr %a0, <4 x i32> %a1, <2 x i64> %a2) {
; X86-LABEL: commute_fold_vpmacsdqh:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacsdqh %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacsdqh:
; X64:       # %bb.0:
; X64-NEXT:    vpmacsdqh %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <4 x i32>, ptr %a0
  %2 = call <2 x i64> @llvm.x86.xop.vpmacsdqh(<4 x i32> %1, <4 x i32> %a1, <2 x i64> %a2)
  ret <2 x i64> %2
}
declare <2 x i64> @llvm.x86.xop.vpmacsdqh(<4 x i32>, <4 x i32>, <2 x i64>) nounwind readnone

define <2 x i64> @commute_fold_vpmacsdql(ptr %a0, <4 x i32> %a1, <2 x i64> %a2) {
; X86-LABEL: commute_fold_vpmacsdql:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacsdql %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacsdql:
; X64:       # %bb.0:
; X64-NEXT:    vpmacsdql %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <4 x i32>, ptr %a0
  %2 = call <2 x i64> @llvm.x86.xop.vpmacsdql(<4 x i32> %1, <4 x i32> %a1, <2 x i64> %a2)
  ret <2 x i64> %2
}
declare <2 x i64> @llvm.x86.xop.vpmacsdql(<4 x i32>, <4 x i32>, <2 x i64>) nounwind readnone

define <4 x i32> @commute_fold_vpmacssdd(ptr %a0, <4 x i32> %a1, <4 x i32> %a2) {
; X86-LABEL: commute_fold_vpmacssdd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacssdd %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacssdd:
; X64:       # %bb.0:
; X64-NEXT:    vpmacssdd %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <4 x i32>, ptr %a0
  %2 = call <4 x i32> @llvm.x86.xop.vpmacssdd(<4 x i32> %1, <4 x i32> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}
declare <4 x i32> @llvm.x86.xop.vpmacssdd(<4 x i32>, <4 x i32>, <4 x i32>) nounwind readnone

define <2 x i64> @commute_fold_vpmacssdqh(ptr %a0, <4 x i32> %a1, <2 x i64> %a2) {
; X86-LABEL: commute_fold_vpmacssdqh:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacssdqh %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacssdqh:
; X64:       # %bb.0:
; X64-NEXT:    vpmacssdqh %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <4 x i32>, ptr %a0
  %2 = call <2 x i64> @llvm.x86.xop.vpmacssdqh(<4 x i32> %1, <4 x i32> %a1, <2 x i64> %a2)
  ret <2 x i64> %2
}
declare <2 x i64> @llvm.x86.xop.vpmacssdqh(<4 x i32>, <4 x i32>, <2 x i64>) nounwind readnone

define <2 x i64> @commute_fold_vpmacssdql(ptr %a0, <4 x i32> %a1, <2 x i64> %a2) {
; X86-LABEL: commute_fold_vpmacssdql:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacssdql %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacssdql:
; X64:       # %bb.0:
; X64-NEXT:    vpmacssdql %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <4 x i32>, ptr %a0
  %2 = call <2 x i64> @llvm.x86.xop.vpmacssdql(<4 x i32> %1, <4 x i32> %a1, <2 x i64> %a2)
  ret <2 x i64> %2
}
declare <2 x i64> @llvm.x86.xop.vpmacssdql(<4 x i32>, <4 x i32>, <2 x i64>) nounwind readnone

define <4 x i32> @commute_fold_vpmacsswd(ptr %a0, <8 x i16> %a1, <4 x i32> %a2) {
; X86-LABEL: commute_fold_vpmacsswd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacsswd %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacsswd:
; X64:       # %bb.0:
; X64-NEXT:    vpmacsswd %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <8 x i16>, ptr %a0
  %2 = call <4 x i32> @llvm.x86.xop.vpmacsswd(<8 x i16> %1, <8 x i16> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}
declare <4 x i32> @llvm.x86.xop.vpmacsswd(<8 x i16>, <8 x i16>, <4 x i32>) nounwind readnone

define <8 x i16> @commute_fold_vpmacssww(ptr %a0, <8 x i16> %a1, <8 x i16> %a2) {
; X86-LABEL: commute_fold_vpmacssww:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacssww %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacssww:
; X64:       # %bb.0:
; X64-NEXT:    vpmacssww %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <8 x i16>, ptr %a0
  %2 = call <8 x i16> @llvm.x86.xop.vpmacssww(<8 x i16> %1, <8 x i16> %a1, <8 x i16> %a2)
  ret <8 x i16> %2
}
declare <8 x i16> @llvm.x86.xop.vpmacssww(<8 x i16>, <8 x i16>, <8 x i16>) nounwind readnone

define <4 x i32> @commute_fold_vpmacswd(ptr %a0, <8 x i16> %a1, <4 x i32> %a2) {
; X86-LABEL: commute_fold_vpmacswd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacswd %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacswd:
; X64:       # %bb.0:
; X64-NEXT:    vpmacswd %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <8 x i16>, ptr %a0
  %2 = call <4 x i32> @llvm.x86.xop.vpmacswd(<8 x i16> %1, <8 x i16> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}
declare <4 x i32> @llvm.x86.xop.vpmacswd(<8 x i16>, <8 x i16>, <4 x i32>) nounwind readnone

define <8 x i16> @commute_fold_vpmacsww(ptr %a0, <8 x i16> %a1, <8 x i16> %a2) {
; X86-LABEL: commute_fold_vpmacsww:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmacsww %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmacsww:
; X64:       # %bb.0:
; X64-NEXT:    vpmacsww %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <8 x i16>, ptr %a0
  %2 = call <8 x i16> @llvm.x86.xop.vpmacsww(<8 x i16> %1, <8 x i16> %a1, <8 x i16> %a2)
  ret <8 x i16> %2
}
declare <8 x i16> @llvm.x86.xop.vpmacsww(<8 x i16>, <8 x i16>, <8 x i16>) nounwind readnone

define <4 x i32> @commute_fold_vpmadcsswd(ptr %a0, <8 x i16> %a1, <4 x i32> %a2) {
; X86-LABEL: commute_fold_vpmadcsswd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmadcsswd %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmadcsswd:
; X64:       # %bb.0:
; X64-NEXT:    vpmadcsswd %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <8 x i16>, ptr %a0
  %2 = call <4 x i32> @llvm.x86.xop.vpmadcsswd(<8 x i16> %1, <8 x i16> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}
declare <4 x i32> @llvm.x86.xop.vpmadcsswd(<8 x i16>, <8 x i16>, <4 x i32>) nounwind readnone

define <4 x i32> @commute_fold_vpmadcswd(ptr %a0, <8 x i16> %a1, <4 x i32> %a2) {
; X86-LABEL: commute_fold_vpmadcswd:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    vpmadcswd %xmm1, (%eax), %xmm0, %xmm0
; X86-NEXT:    retl
;
; X64-LABEL: commute_fold_vpmadcswd:
; X64:       # %bb.0:
; X64-NEXT:    vpmadcswd %xmm1, (%rdi), %xmm0, %xmm0
; X64-NEXT:    retq
  %1 = load <8 x i16>, ptr %a0
  %2 = call <4 x i32> @llvm.x86.xop.vpmadcswd(<8 x i16> %1, <8 x i16> %a1, <4 x i32> %a2)
  ret <4 x i32> %2
}
declare <4 x i32> @llvm.x86.xop.vpmadcswd(<8 x i16>, <8 x i16>, <4 x i32>) nounwind readnone
