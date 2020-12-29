; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -mtriple=x86_64-unknown-unknown -S | FileCheck %s

;
; UNDEF Elts
;

define <8 x i16> @undef_packssdw_128() {
; CHECK-LABEL: @undef_packssdw_128(
; CHECK-NEXT:    ret <8 x i16> undef
;
  %1 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> undef, <4 x i32> undef)
  ret <8 x i16> %1
}

define <8 x i16> @undef_packusdw_128() {
; CHECK-LABEL: @undef_packusdw_128(
; CHECK-NEXT:    ret <8 x i16> undef
;
  %1 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> undef, <4 x i32> undef)
  ret <8 x i16> %1
}

define <16 x i8> @undef_packsswb_128() {
; CHECK-LABEL: @undef_packsswb_128(
; CHECK-NEXT:    ret <16 x i8> undef
;
  %1 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> undef, <8 x i16> undef)
  ret <16 x i8> %1
}

define <16 x i8> @undef_packuswb_128() {
; CHECK-LABEL: @undef_packuswb_128(
; CHECK-NEXT:    ret <16 x i8> undef
;
  %1 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> undef, <8 x i16> undef)
  ret <16 x i8> %1
}

define <16 x i16> @undef_packssdw_256() {
; CHECK-LABEL: @undef_packssdw_256(
; CHECK-NEXT:    ret <16 x i16> undef
;
  %1 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> undef, <8 x i32> undef)
  ret <16 x i16> %1
}

define <16 x i16> @undef_packusdw_256() {
; CHECK-LABEL: @undef_packusdw_256(
; CHECK-NEXT:    ret <16 x i16> undef
;
  %1 = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> undef, <8 x i32> undef)
  ret <16 x i16> %1
}

define <32 x i8> @undef_packsswb_256() {
; CHECK-LABEL: @undef_packsswb_256(
; CHECK-NEXT:    ret <32 x i8> undef
;
  %1 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> undef, <16 x i16> undef)
  ret <32 x i8> %1
}

define <32 x i8> @undef_packuswb_256() {
; CHECK-LABEL: @undef_packuswb_256(
; CHECK-NEXT:    ret <32 x i8> undef
;
  %1 = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> undef, <16 x i16> undef)
  ret <32 x i8> %1
}

define <32 x i16> @undef_packssdw_512() {
; CHECK-LABEL: @undef_packssdw_512(
; CHECK-NEXT:    ret <32 x i16> undef
;
  %1 = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> undef, <16 x i32> undef)
  ret <32 x i16> %1
}

define <32 x i16> @undef_packusdw_512() {
; CHECK-LABEL: @undef_packusdw_512(
; CHECK-NEXT:    ret <32 x i16> undef
;
  %1 = call <32 x i16> @llvm.x86.avx512.packusdw.512(<16 x i32> undef, <16 x i32> undef)
  ret <32 x i16> %1
}

define <64 x i8> @undef_packsswb_512() {
; CHECK-LABEL: @undef_packsswb_512(
; CHECK-NEXT:    ret <64 x i8> undef
;
  %1 = call <64 x i8> @llvm.x86.avx512.packsswb.512(<32 x i16> undef, <32 x i16> undef)
  ret <64 x i8> %1
}

define <64 x i8> @undef_packuswb_512() {
; CHECK-LABEL: @undef_packuswb_512(
; CHECK-NEXT:    ret <64 x i8> undef
;
  %1 = call <64 x i8> @llvm.x86.avx512.packuswb.512(<32 x i16> undef, <32 x i16> undef)
  ret <64 x i8> %1
}

;
; Constant Folding
;

define <8 x i16> @fold_packssdw_128() {
; CHECK-LABEL: @fold_packssdw_128(
; CHECK-NEXT:    ret <8 x i16> <i16 0, i16 -1, i16 32767, i16 -32768, i16 0, i16 0, i16 0, i16 0>
;
  %1 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> <i32 0, i32 -1, i32 65536, i32 -131072>, <4 x i32> zeroinitializer)
  ret <8 x i16> %1
}

define <8 x i16> @fold_packusdw_128() {
; CHECK-LABEL: @fold_packusdw_128(
; CHECK-NEXT:    ret <8 x i16> <i16 undef, i16 undef, i16 undef, i16 undef, i16 0, i16 0, i16 -32768, i16 -1>
;
  %1 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> undef, <4 x i32> <i32 0, i32 -1, i32 32768, i32 65537>)
  ret <8 x i16> %1
}

define <16 x i8> @fold_packsswb_128() {
; CHECK-LABEL: @fold_packsswb_128(
; CHECK-NEXT:    ret <16 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef>
;
  %1 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> zeroinitializer, <8 x i16> undef)
  ret <16 x i8> %1
}

define <16 x i8> @fold_packuswb_128() {
; CHECK-LABEL: @fold_packuswb_128(
; CHECK-NEXT:    ret <16 x i8> <i8 0, i8 1, i8 0, i8 -1, i8 0, i8 0, i8 0, i8 15, i8 0, i8 127, i8 0, i8 1, i8 0, i8 1, i8 0, i8 0>
;
  %1 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> <i16 0, i16 1, i16 -1, i16 255, i16 65535, i16 -32768, i16 -127, i16 15>, <8 x i16> <i16 -15, i16 127, i16 32768, i16 -65535, i16 -255, i16 1, i16 -1, i16 0>)
  ret <16 x i8> %1
}

define <16 x i16> @fold_packssdw_256() {
; CHECK-LABEL: @fold_packssdw_256(
; CHECK-NEXT:    ret <16 x i16> <i16 0, i16 256, i16 32767, i16 -32768, i16 undef, i16 undef, i16 undef, i16 undef, i16 -127, i16 -32768, i16 -32767, i16 32767, i16 undef, i16 undef, i16 undef, i16 undef>
;
  %1 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> <i32 0, i32 256, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767>, <8 x i32> undef)
  ret <16 x i16> %1
}

define <16 x i16> @fold_packusdw_256() {
; CHECK-LABEL: @fold_packusdw_256(
; CHECK-NEXT:    ret <16 x i16> <i16 0, i16 0, i16 0, i16 -1, i16 0, i16 256, i16 -1, i16 0, i16 127, i16 -32768, i16 32767, i16 0, i16 0, i16 0, i16 0, i16 32767>
;
  %1 = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> <i32 0, i32 -256, i32 -65535, i32 65536, i32 127, i32 32768, i32 32767, i32 -32767>, <8 x i32> <i32 0, i32 256, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767>)
  ret <16 x i16> %1
}

define <32 x i8> @fold_packsswb_256() {
; CHECK-LABEL: @fold_packsswb_256(
; CHECK-NEXT:    ret <32 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
;
  %1 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> undef, <16 x i16> zeroinitializer)
  ret <32 x i8> %1
}

define <32 x i8> @fold_packuswb_256() {
; CHECK-LABEL: @fold_packuswb_256(
; CHECK-NEXT:    ret <32 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 -1, i8 -1, i8 -1, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 1, i8 2, i8 4, i8 8, i8 16, i8 32, i8 64>
;
  %1 = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> zeroinitializer, <16 x i16> <i16 0, i16 -127, i16 -128, i16 -32768, i16 65536, i16 255, i16 256, i16 512, i16 -1, i16 1, i16 2, i16 4, i16 8, i16 16, i16 32, i16 64>)
  ret <32 x i8> %1
}

define <32 x i16> @fold_packssdw_512() {
; CHECK-LABEL: @fold_packssdw_512(
; CHECK-NEXT:    ret <32 x i16> <i16 0, i16 512, i16 32767, i16 -32768, i16 undef, i16 undef, i16 undef, i16 undef, i16 -127, i16 -32768, i16 -32767, i16 32767, i16 undef, i16 undef, i16 undef, i16 undef, i16 0, i16 512, i16 32767, i16 -32768, i16 undef, i16 undef, i16 undef, i16 undef, i16 -127, i16 -32768, i16 -32767, i16 32767, i16 undef, i16 undef, i16 undef, i16 undef>
;
  %1 = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> <i32 0, i32 512, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767, i32 0, i32 512, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767>, <16 x i32> undef)
  ret <32 x i16> %1
}

define <32 x i16> @fold_packusdw_512() {
; CHECK-LABEL: @fold_packusdw_512(
; CHECK-NEXT:    ret <32 x i16> <i16 0, i16 0, i16 0, i16 -1, i16 0, i16 512, i16 -1, i16 0, i16 127, i16 -32768, i16 32767, i16 0, i16 0, i16 0, i16 0, i16 32767, i16 0, i16 0, i16 0, i16 -1, i16 0, i16 512, i16 -1, i16 0, i16 127, i16 -32768, i16 32767, i16 0, i16 0, i16 0, i16 0, i16 32767>
;
  %1 = call <32 x i16> @llvm.x86.avx512.packusdw.512(<16 x i32> <i32 0, i32 -512, i32 -65535, i32 65536, i32 127, i32 32768, i32 32767, i32 -32767, i32 0, i32 -512, i32 -65535, i32 65536, i32 127, i32 32768, i32 32767, i32 -32767>, <16 x i32> <i32 0, i32 512, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767, i32 0, i32 512, i32 65535, i32 -65536, i32 -127, i32 -32768, i32 -32767, i32 32767>)
  ret <32 x i16> %1
}

define <64 x i8> @fold_packsswb_512() {
; CHECK-LABEL: @fold_packsswb_512(
; CHECK-NEXT:    ret <64 x i8> <i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 undef, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0>
;
  %1 = call <64 x i8> @llvm.x86.avx512.packsswb.512(<32 x i16> undef, <32 x i16> zeroinitializer)
  ret <64 x i8> %1
}

define <64 x i8> @fold_packuswb_512() {
; CHECK-LABEL: @fold_packuswb_512(
; CHECK-NEXT:    ret <64 x i8> <i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 -1, i8 -1, i8 -1, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 1, i8 2, i8 4, i8 8, i8 16, i8 32, i8 64, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 -1, i8 -1, i8 -1, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 0, i8 1, i8 2, i8 4, i8 8, i8 16, i8 32, i8 64>
;
  %1 = call <64 x i8> @llvm.x86.avx512.packuswb.512(<32 x i16> zeroinitializer, <32 x i16> <i16 0, i16 -127, i16 -128, i16 -32768, i16 65536, i16 255, i16 512, i16 512, i16 -1, i16 1, i16 2, i16 4, i16 8, i16 16, i16 32, i16 64, i16 0, i16 -127, i16 -128, i16 -32768, i16 65536, i16 255, i16 512, i16 512, i16 -1, i16 1, i16 2, i16 4, i16 8, i16 16, i16 32, i16 64>)
  ret <64 x i8> %1
}

;
; Demanded Elts
;

define <8 x i16> @elts_packssdw_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @elts_packssdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> [[A0:%.*]], <4 x i32> undef)
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i16> [[TMP1]], <8 x i16> poison, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <8 x i16> [[TMP2]]
;
  %1 = shufflevector <4 x i32> %a0, <4 x i32> poison, <4 x i32> <i32 3, i32 1, i32 undef, i32 undef>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> poison, <4 x i32> <i32 undef, i32 2, i32 1, i32 undef>
  %3 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %1, <4 x i32> %2)
  %4 = shufflevector <8 x i16> %3, <8 x i16> poison, <8 x i32> <i32 1, i32 1, i32 1, i32 1, i32 7, i32 7, i32 7, i32 7>
  ret <8 x i16> %4
}

define <8 x i16> @elts_packusdw_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @elts_packusdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> [[A0:%.*]], <4 x i32> [[A1:%.*]])
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i16> [[TMP1]], <8 x i16> poison, <8 x i32> <i32 undef, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 undef>
; CHECK-NEXT:    ret <8 x i16> [[TMP2]]
;
  %1 = insertelement <4 x i32> %a0, i32 0, i32 0
  %2 = insertelement <4 x i32> %a1, i32 0, i32 3
  %3 = call <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32> %1, <4 x i32> %2)
  %4 = shufflevector <8 x i16> %3, <8 x i16> poison, <8 x i32> <i32 undef, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 undef>
  ret <8 x i16> %4
}

define <16 x i8> @elts_packsswb_128(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: @elts_packsswb_128(
; CHECK-NEXT:    ret <16 x i8> zeroinitializer
;
  %1 = insertelement <8 x i16> %a0, i16 0, i32 0
  %2 = insertelement <8 x i16> %a1, i16 0, i32 0
  %3 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> %1, <8 x i16> %2)
  %4 = shufflevector <16 x i8> %3, <16 x i8> poison, <16 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8, i32 8>
  ret <16 x i8> %4
}

define <16 x i8> @elts_packuswb_128(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: @elts_packuswb_128(
; CHECK-NEXT:    ret <16 x i8> undef
;
  %1 = insertelement <8 x i16> poison, i16 0, i32 0
  %2 = insertelement <8 x i16> poison, i16 0, i32 0
  %3 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> %1, <8 x i16> %2)
  %4 = shufflevector <16 x i8> %3, <16 x i8> poison, <16 x i32> <i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 1, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>
  ret <16 x i8> %4
}

define <16 x i16> @elts_packssdw_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @elts_packssdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> [[A0:%.*]], <8 x i32> undef)
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i16> [[TMP1]], <16 x i16> poison, <16 x i32> <i32 undef, i32 undef, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 8, i32 undef, i32 undef, i32 11, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <16 x i16> [[TMP2]]
;
  %1 = shufflevector <8 x i32> %a0, <8 x i32> poison, <8 x i32> <i32 1, i32 0, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %2 = shufflevector <8 x i32> %a1, <8 x i32> poison, <8 x i32> <i32 undef, i32 2, i32 1, i32 undef, i32 undef, i32 6, i32 5, i32 undef>
  %3 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> %1, <8 x i32> %2)
  %4 = shufflevector <16 x i16> %3, <16 x i16> poison, <16 x i32> <i32 undef, i32 undef, i32 2, i32 3, i32 4, i32 undef, i32 undef, i32 7, i32 8, i32 undef, i32 undef, i32 11, i32 12, i32 undef, i32 undef, i32 15>
  ret <16 x i16> %4
}

define <16 x i16> @elts_packusdw_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @elts_packusdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A1:%.*]], <8 x i32> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
; CHECK-NEXT:    [[TMP2:%.*]] = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> poison, <8 x i32> [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <16 x i16> [[TMP2]], <16 x i16> poison, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <16 x i16> [[TMP3]]
;
  %1 = shufflevector <8 x i32> %a0, <8 x i32> poison, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  %2 = shufflevector <8 x i32> %a1, <8 x i32> poison, <8 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0>
  %3 = call <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32> %1, <8 x i32> %2)
  %4 = shufflevector <16 x i16> %3, <16 x i16> poison, <16 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef>
  ret <16 x i16> %4
}

define <32 x i8> @elts_packsswb_256(<16 x i16> %a0, <16 x i16> %a1) {
; CHECK-LABEL: @elts_packsswb_256(
; CHECK-NEXT:    ret <32 x i8> zeroinitializer
;
  %1 = insertelement <16 x i16> %a0, i16 0, i32 0
  %2 = insertelement <16 x i16> %a1, i16 0, i32 8
  %3 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> %1, <16 x i16> %2)
  %4 = shufflevector <32 x i8> %3, <32 x i8> poison, <32 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24>
  ret <32 x i8> %4
}

define <32 x i8> @elts_packuswb_256(<16 x i16> %a0, <16 x i16> %a1) {
; CHECK-LABEL: @elts_packuswb_256(
; CHECK-NEXT:    ret <32 x i8> undef
;
  %1 = insertelement <16 x i16> poison, i16 0, i32 1
  %2 = insertelement <16 x i16> poison, i16 0, i32 0
  %3 = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> %1, <16 x i16> %2)
  %4 = shufflevector <32 x i8> %3, <32 x i8> poison, <32 x i32> zeroinitializer
  ret <32 x i8> %4
}

define <32 x i16> @elts_packssdw_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @elts_packssdw_512(
; CHECK-NEXT:    [[TMP1:%.*]] = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> [[A0:%.*]], <16 x i32> undef)
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <32 x i16> [[TMP1]], <32 x i16> poison, <32 x i32> <i32 undef, i32 undef, i32 2, i32 3, i32 undef, i32 undef, i32 undef, i32 undef, i32 8, i32 undef, i32 undef, i32 11, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 undef, i32 18, i32 19, i32 undef, i32 undef, i32 undef, i32 undef, i32 24, i32 undef, i32 undef, i32 27, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <32 x i16> [[TMP2]]
;
  %1 = shufflevector <16 x i32> %a0, <16 x i32> poison, <16 x i32> <i32 1, i32 0, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 9, i32 8, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %2 = shufflevector <16 x i32> %a1, <16 x i32> poison, <16 x i32> <i32 undef, i32 2, i32 1, i32 undef, i32 undef, i32 6, i32 5, i32 undef, i32 undef, i32 10, i32 9, i32 undef, i32 undef, i32 14, i32 13, i32 undef>
  %3 = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> %1, <16 x i32> %2)
  %4 = shufflevector <32 x i16> %3, <32 x i16> poison, <32 x i32> <i32 undef, i32 undef, i32 2, i32 3, i32 4, i32 undef, i32 undef, i32 7, i32 8, i32 undef, i32 undef, i32 11, i32 12, i32 undef, i32 undef, i32 15, i32 undef, i32 undef, i32 18, i32 19, i32 20, i32 undef, i32 undef, i32 23, i32 24, i32 undef, i32 undef, i32 27, i32 28, i32 undef, i32 undef, i32 31>
  ret <32 x i16> %4
}

define <32 x i16> @elts_packusdw_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @elts_packusdw_512(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <16 x i32> [[A1:%.*]], <16 x i32> poison, <16 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8>
; CHECK-NEXT:    [[TMP2:%.*]] = call <32 x i16> @llvm.x86.avx512.packusdw.512(<16 x i32> poison, <16 x i32> [[TMP1]])
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <32 x i16> [[TMP2]], <32 x i16> poison, <32 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 20, i32 21, i32 22, i32 23, i32 undef, i32 undef, i32 undef, i32 undef, i32 28, i32 29, i32 30, i32 31, i32 undef, i32 undef, i32 undef, i32 undef>
; CHECK-NEXT:    ret <32 x i16> [[TMP3]]
;
  %1 = shufflevector <16 x i32> %a0, <16 x i32> poison, <16 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9, i32 10, i32 11, i32 12, i32 13, i32 14, i32 15>
  %2 = shufflevector <16 x i32> %a1, <16 x i32> poison, <16 x i32> <i32 7, i32 6, i32 5, i32 4, i32 3, i32 2, i32 1, i32 0, i32 15, i32 14, i32 13, i32 12, i32 11, i32 10, i32 9, i32 8>
  %3 = call <32 x i16> @llvm.x86.avx512.packusdw.512(<16 x i32> %1, <16 x i32> %2)
  %4 = shufflevector <32 x i16> %3, <32 x i16> poison, <32 x i32> <i32 4, i32 5, i32 6, i32 7, i32 undef, i32 undef, i32 undef, i32 undef, i32 12, i32 13, i32 14, i32 15, i32 undef, i32 undef, i32 undef, i32 undef, i32 20, i32 21, i32 22, i32 23, i32 undef, i32 undef, i32 undef, i32 undef, i32 28, i32 29, i32 30, i32 31, i32 undef, i32 undef, i32 undef, i32 undef>
  ret <32 x i16> %4
}

define <64 x i8> @elts_packsswb_512(<32 x i16> %a0, <32 x i16> %a1) {
; CHECK-LABEL: @elts_packsswb_512(
; CHECK-NEXT:    ret <64 x i8> zeroinitializer
;
  %1 = insertelement <32 x i16> %a0, i16 0, i32 0
  %2 = insertelement <32 x i16> %a1, i16 0, i32 8
  %3 = insertelement <32 x i16> %1, i16 0, i32 16
  %4 = insertelement <32 x i16> %2, i16 0, i32 24
  %5 = call <64 x i8> @llvm.x86.avx512.packsswb.512(<32 x i16> %3, <32 x i16> %4)
  %6 = shufflevector <64 x i8> %5, <64 x i8> poison, <64 x i32> <i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 24, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 32, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56, i32 56>
  ret <64 x i8> %6
}

define <64 x i8> @elts_packuswb_512(<32 x i16> %a0, <32 x i16> %a1) {
; CHECK-LABEL: @elts_packuswb_512(
; CHECK-NEXT:    ret <64 x i8> undef
;
  %1 = insertelement <32 x i16> poison, i16 0, i32 1
  %2 = insertelement <32 x i16> poison, i16 0, i32 0
  %3 = call <64 x i8> @llvm.x86.avx512.packuswb.512(<32 x i16> %1, <32 x i16> %2)
  %4 = shufflevector <64 x i8> %3, <64 x i8> poison, <64 x i32> zeroinitializer
  ret <64 x i8> %4
}

;
; Truncation (without Saturation)
;

define <8 x i16> @trunc_packssdw_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @trunc_packssdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <4 x i32> [[A0:%.*]], <i32 17, i32 17, i32 17, i32 17>
; CHECK-NEXT:    [[TMP2:%.*]] = and <4 x i32> [[A1:%.*]], <i32 15, i32 15, i32 15, i32 15>
; CHECK-NEXT:    [[TMP3:%.*]] = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> [[TMP1]], <4 x i32> [[TMP2]])
; CHECK-NEXT:    ret <8 x i16> [[TMP3]]
;
  %1 = ashr <4 x i32> %a0, <i32 17, i32 17, i32 17, i32 17>
  %2 = and  <4 x i32> %a1, <i32 15, i32 15, i32 15, i32 15>
  %3 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %1, <4 x i32> %2)
  ret <8 x i16> %3
}

define <8 x i16> @trunc_packusdw_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @trunc_packusdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <4 x i32> [[A0:%.*]], <i32 17, i32 17, i32 17, i32 17>
; CHECK-NEXT:    [[TMP2:%.*]] = and <4 x i32> [[A1:%.*]], <i32 15, i32 15, i32 15, i32 15>
; CHECK-NEXT:    [[TMP3:%.*]] = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> [[TMP1]], <4 x i32> [[TMP2]])
; CHECK-NEXT:    ret <8 x i16> [[TMP3]]
;
  %1 = lshr <4 x i32> %a0, <i32 17, i32 17, i32 17, i32 17>
  %2 = and  <4 x i32> %a1, <i32 15, i32 15, i32 15, i32 15>
  %3 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %1, <4 x i32> %2)
  ret <8 x i16> %3
}

define <16 x i8> @trunc_packsswb_128(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: @trunc_packsswb_128(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <8 x i16> [[A0:%.*]], <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
; CHECK-NEXT:    [[TMP2:%.*]] = and <8 x i16> [[A1:%.*]], <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
; CHECK-NEXT:    [[TMP3:%.*]] = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> [[TMP1]], <8 x i16> [[TMP2]])
; CHECK-NEXT:    ret <16 x i8> [[TMP3]]
;
  %1 = ashr <8 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <8 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> %1, <8 x i16> %2)
  ret <16 x i8> %3
}

define <16 x i8> @trunc_packuswb_128(<8 x i16> %a0, <8 x i16> %a1) {
; CHECK-LABEL: @trunc_packuswb_128(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <8 x i16> [[A0:%.*]], <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
; CHECK-NEXT:    [[TMP2:%.*]] = and <8 x i16> [[A1:%.*]], <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
; CHECK-NEXT:    [[TMP3:%.*]] = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> [[TMP1]], <8 x i16> [[TMP2]])
; CHECK-NEXT:    ret <16 x i8> [[TMP3]]
;
  %1 = lshr <8 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <8 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = call <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16> %1, <8 x i16> %2)
  ret <16 x i8> %3
}

define <16 x i16> @trunc_packssdw_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @trunc_packssdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <8 x i32> [[A0:%.*]], <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
; CHECK-NEXT:    [[TMP2:%.*]] = ashr <8 x i32> [[A1:%.*]], <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
; CHECK-NEXT:    [[TMP3:%.*]] = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> [[TMP1]], <8 x i32> [[TMP2]])
; CHECK-NEXT:    ret <16 x i16> [[TMP3]]
;
  %1 = ashr <8 x i32> %a0, <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
  %2 = ashr <8 x i32> %a1, <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
  %3 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> %1, <8 x i32> %2)
  ret <16 x i16> %3
}

define <16 x i16> @trunc_packusdw_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @trunc_packusdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <8 x i32> [[A0:%.*]], <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
; CHECK-NEXT:    [[TMP2:%.*]] = and <8 x i32> [[A1:%.*]], <i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>
; CHECK-NEXT:    [[TMP3:%.*]] = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> [[TMP1]], <8 x i32> [[TMP2]])
; CHECK-NEXT:    ret <16 x i16> [[TMP3]]
;
  %1 = lshr <8 x i32> %a0, <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
  %2 = and  <8 x i32> %a1, <i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>
  %3 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> %1, <8 x i32> %2)
  ret <16 x i16> %3
}

define <32 x i8> @trunc_packsswb_256(<16 x i16> %a0, <16 x i16> %a1) {
; CHECK-LABEL: @trunc_packsswb_256(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <16 x i16> [[A0:%.*]], <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
; CHECK-NEXT:    [[TMP2:%.*]] = and <16 x i16> [[A1:%.*]], <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
; CHECK-NEXT:    [[TMP3:%.*]] = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> [[TMP1]], <16 x i16> [[TMP2]])
; CHECK-NEXT:    ret <32 x i8> [[TMP3]]
;
  %1 = ashr <16 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <16 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> %1, <16 x i16> %2)
  ret <32 x i8> %3
}

define <32 x i8> @trunc_packuswb_256(<16 x i16> %a0, <16 x i16> %a1) {
; CHECK-LABEL: @trunc_packuswb_256(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <16 x i16> [[A0:%.*]], <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
; CHECK-NEXT:    [[TMP2:%.*]] = and <16 x i16> [[A1:%.*]], <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
; CHECK-NEXT:    [[TMP3:%.*]] = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> [[TMP1]], <16 x i16> [[TMP2]])
; CHECK-NEXT:    ret <32 x i8> [[TMP3]]
;
  %1 = lshr <16 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <16 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = call <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16> %1, <16 x i16> %2)
  ret <32 x i8> %3
}

define <32 x i16> @trunc_packssdw_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @trunc_packssdw_512(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <16 x i32> [[A0:%.*]], <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
; CHECK-NEXT:    [[TMP2:%.*]] = ashr <16 x i32> [[A1:%.*]], <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
; CHECK-NEXT:    [[TMP3:%.*]] = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> [[TMP1]], <16 x i32> [[TMP2]])
; CHECK-NEXT:    ret <32 x i16> [[TMP3]]
;
  %1 = ashr <16 x i32> %a0, <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
  %2 = ashr <16 x i32> %a1, <i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23, i32 23>
  %3 = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> %1, <16 x i32> %2)
  ret <32 x i16> %3
}

define <32 x i16> @trunc_packusdw_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @trunc_packusdw_512(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <16 x i32> [[A0:%.*]], <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
; CHECK-NEXT:    [[TMP2:%.*]] = and <16 x i32> [[A1:%.*]], <i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>
; CHECK-NEXT:    [[TMP3:%.*]] = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> [[TMP1]], <16 x i32> [[TMP2]])
; CHECK-NEXT:    ret <32 x i16> [[TMP3]]
;
  %1 = lshr <16 x i32> %a0, <i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17, i32 17>
  %2 = and  <16 x i32> %a1, <i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15, i32 15>
  %3 = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> %1, <16 x i32> %2)
  ret <32 x i16> %3
}

define <64 x i8> @trunc_packsswb_512(<32 x i16> %a0, <32 x i16> %a1) {
; CHECK-LABEL: @trunc_packsswb_512(
; CHECK-NEXT:    [[TMP1:%.*]] = ashr <32 x i16> [[A0:%.*]], <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
; CHECK-NEXT:    [[TMP2:%.*]] = and <32 x i16> [[A1:%.*]], <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
; CHECK-NEXT:    [[TMP3:%.*]] = call <64 x i8> @llvm.x86.avx512.packsswb.512(<32 x i16> [[TMP1]], <32 x i16> [[TMP2]])
; CHECK-NEXT:    ret <64 x i8> [[TMP3]]
;
  %1 = ashr <32 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <32 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = call <64 x i8> @llvm.x86.avx512.packsswb.512(<32 x i16> %1, <32 x i16> %2)
  ret <64 x i8> %3
}

define <64 x i8> @trunc_packuswb_512(<32 x i16> %a0, <32 x i16> %a1) {
; CHECK-LABEL: @trunc_packuswb_512(
; CHECK-NEXT:    [[TMP1:%.*]] = lshr <32 x i16> [[A0:%.*]], <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
; CHECK-NEXT:    [[TMP2:%.*]] = and <32 x i16> [[A1:%.*]], <i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1, i16 1>
; CHECK-NEXT:    [[TMP3:%.*]] = call <64 x i8> @llvm.x86.avx512.packuswb.512(<32 x i16> [[TMP1]], <32 x i16> [[TMP2]])
; CHECK-NEXT:    ret <64 x i8> [[TMP3]]
;
  %1 = lshr <32 x i16> %a0, <i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15, i16 15>
  %2 = and  <32 x i16> %a1, <i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1, i16  1>
  %3 = call <64 x i8> @llvm.x86.avx512.packuswb.512(<32 x i16> %1, <32 x i16> %2)
  ret <64 x i8> %3
}

;
; Signed Pack Comparison Results
;

define <8 x i16> @cmp_packssdw_128(<4 x i32> %a0, <4 x i32> %a1, <4 x i32> %a2, <4 x i32> %a3) {
; CHECK-LABEL: @cmp_packssdw_128(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <4 x i32> [[A0:%.*]], [[A1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <4 x i32> [[A2:%.*]], [[A3:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = sext <4 x i1> [[TMP1]] to <4 x i32>
; CHECK-NEXT:    [[TMP4:%.*]] = sext <4 x i1> [[TMP2]] to <4 x i32>
; CHECK-NEXT:    [[TMP5:%.*]] = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> [[TMP3]], <4 x i32> [[TMP4]])
; CHECK-NEXT:    ret <8 x i16> [[TMP5]]
;
  %1 = icmp eq <4 x i32> %a0, %a1
  %2 = icmp eq <4 x i32> %a2, %a3
  %3 = sext <4 x i1> %1 to <4 x i32>
  %4 = sext <4 x i1> %2 to <4 x i32>
  %5 = call <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32> %3, <4 x i32> %4)
  ret <8 x i16> %5
}

define <16 x i8> @cmp_packsswb_128(<8 x i16> %a0, <8 x i16> %a1, <8 x i16> %a2, <8 x i16> %a3) {
; CHECK-LABEL: @cmp_packsswb_128(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <8 x i16> [[A0:%.*]], [[A1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <8 x i16> [[A2:%.*]], [[A3:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = sext <8 x i1> [[TMP1]] to <8 x i16>
; CHECK-NEXT:    [[TMP4:%.*]] = sext <8 x i1> [[TMP2]] to <8 x i16>
; CHECK-NEXT:    [[TMP5:%.*]] = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> [[TMP3]], <8 x i16> [[TMP4]])
; CHECK-NEXT:    ret <16 x i8> [[TMP5]]
;
  %1 = icmp eq <8 x i16> %a0, %a1
  %2 = icmp eq <8 x i16> %a2, %a3
  %3 = sext <8 x i1> %1 to <8 x i16>
  %4 = sext <8 x i1> %2 to <8 x i16>
  %5 = call <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16> %3, <8 x i16> %4)
  ret <16 x i8> %5
}

define <16 x i16> @cmp_packssdw_256(<8 x i32> %a0, <8 x i32> %a1, <8 x i32> %a2, <8 x i32> %a3) {
; CHECK-LABEL: @cmp_packssdw_256(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <8 x i32> [[A0:%.*]], [[A1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <8 x i32> [[A2:%.*]], [[A3:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = sext <8 x i1> [[TMP1]] to <8 x i32>
; CHECK-NEXT:    [[TMP4:%.*]] = sext <8 x i1> [[TMP2]] to <8 x i32>
; CHECK-NEXT:    [[TMP5:%.*]] = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> [[TMP3]], <8 x i32> [[TMP4]])
; CHECK-NEXT:    ret <16 x i16> [[TMP5]]
;
  %1 = icmp eq <8 x i32> %a0, %a1
  %2 = icmp eq <8 x i32> %a2, %a3
  %3 = sext <8 x i1> %1 to <8 x i32>
  %4 = sext <8 x i1> %2 to <8 x i32>
  %5 = call <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32> %3, <8 x i32> %4)
  ret <16 x i16> %5
}

define <32 x i8> @cmp_packsswb_256(<16 x i16> %a0, <16 x i16> %a1, <16 x i16> %a2, <16 x i16> %a3) {
; CHECK-LABEL: @cmp_packsswb_256(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <16 x i16> [[A0:%.*]], [[A1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <16 x i16> [[A2:%.*]], [[A3:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = sext <16 x i1> [[TMP1]] to <16 x i16>
; CHECK-NEXT:    [[TMP4:%.*]] = sext <16 x i1> [[TMP2]] to <16 x i16>
; CHECK-NEXT:    [[TMP5:%.*]] = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> [[TMP3]], <16 x i16> [[TMP4]])
; CHECK-NEXT:    ret <32 x i8> [[TMP5]]
;
  %1 = icmp eq <16 x i16> %a0, %a1
  %2 = icmp eq <16 x i16> %a2, %a3
  %3 = sext <16 x i1> %1 to <16 x i16>
  %4 = sext <16 x i1> %2 to <16 x i16>
  %5 = call <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16> %3, <16 x i16> %4)
  ret <32 x i8> %5
}

define <32 x i16> @cmp_packssdw_512(<16 x i32> %a0, <16 x i32> %a1, <16 x i32> %a2, <16 x i32> %a3) {
; CHECK-LABEL: @cmp_packssdw_512(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <16 x i32> [[A0:%.*]], [[A1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <16 x i32> [[A2:%.*]], [[A3:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = sext <16 x i1> [[TMP1]] to <16 x i32>
; CHECK-NEXT:    [[TMP4:%.*]] = sext <16 x i1> [[TMP2]] to <16 x i32>
; CHECK-NEXT:    [[TMP5:%.*]] = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> [[TMP3]], <16 x i32> [[TMP4]])
; CHECK-NEXT:    ret <32 x i16> [[TMP5]]
;
  %1 = icmp eq <16 x i32> %a0, %a1
  %2 = icmp eq <16 x i32> %a2, %a3
  %3 = sext <16 x i1> %1 to <16 x i32>
  %4 = sext <16 x i1> %2 to <16 x i32>
  %5 = call <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32> %3, <16 x i32> %4)
  ret <32 x i16> %5
}

define <64 x i8> @cmp_packsswb_512(<32 x i16> %a0, <32 x i16> %a1, <32 x i16> %a2, <32 x i16> %a3) {
; CHECK-LABEL: @cmp_packsswb_512(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp eq <32 x i16> [[A0:%.*]], [[A1:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq <32 x i16> [[A2:%.*]], [[A3:%.*]]
; CHECK-NEXT:    [[TMP3:%.*]] = sext <32 x i1> [[TMP1]] to <32 x i16>
; CHECK-NEXT:    [[TMP4:%.*]] = sext <32 x i1> [[TMP2]] to <32 x i16>
; CHECK-NEXT:    [[TMP5:%.*]] = call <64 x i8> @llvm.x86.avx512.packsswb.512(<32 x i16> [[TMP3]], <32 x i16> [[TMP4]])
; CHECK-NEXT:    ret <64 x i8> [[TMP5]]
;
  %1 = icmp eq <32 x i16> %a0, %a1
  %2 = icmp eq <32 x i16> %a2, %a3
  %3 = sext <32 x i1> %1 to <32 x i16>
  %4 = sext <32 x i1> %2 to <32 x i16>
  %5 = call <64 x i8> @llvm.x86.avx512.packsswb.512(<32 x i16> %3, <32 x i16> %4)
  ret <64 x i8> %5
}

declare <8 x i16> @llvm.x86.sse2.packssdw.128(<4 x i32>, <4 x i32>) nounwind readnone
declare <16 x i8> @llvm.x86.sse2.packsswb.128(<8 x i16>, <8 x i16>) nounwind readnone
declare <16 x i8> @llvm.x86.sse2.packuswb.128(<8 x i16>, <8 x i16>) nounwind readnone
declare <8 x i16> @llvm.x86.sse41.packusdw(<4 x i32>, <4 x i32>) nounwind readnone

declare <16 x i16> @llvm.x86.avx2.packssdw(<8 x i32>, <8 x i32>) nounwind readnone
declare <16 x i16> @llvm.x86.avx2.packusdw(<8 x i32>, <8 x i32>) nounwind readnone
declare <32 x i8> @llvm.x86.avx2.packsswb(<16 x i16>, <16 x i16>) nounwind readnone
declare <32 x i8> @llvm.x86.avx2.packuswb(<16 x i16>, <16 x i16>) nounwind readnone

declare <32 x i16> @llvm.x86.avx512.packssdw.512(<16 x i32>, <16 x i32>) nounwind readnone
declare <32 x i16> @llvm.x86.avx512.packusdw.512(<16 x i32>, <16 x i32>) nounwind readnone
declare <64 x i8> @llvm.x86.avx512.packsswb.512(<32 x i16>, <32 x i16>) nounwind readnone
declare <64 x i8> @llvm.x86.avx512.packuswb.512(<32 x i16>, <32 x i16>) nounwind readnone
