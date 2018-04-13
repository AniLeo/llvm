; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

;
; UNDEF Elts
;

define <2 x i64> @undef_pmuludq_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @undef_pmuludq_128(
; CHECK-NEXT:    ret <2 x i64> zeroinitializer
;
  %1 = call <2 x i64> @llvm.x86.sse2.pmulu.dq(<4 x i32> undef, <4 x i32> undef)
  ret <2 x i64> %1
}

define <4 x i64> @undef_pmuludq_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @undef_pmuludq_256(
; CHECK-NEXT:    ret <4 x i64> zeroinitializer
;
  %1 = call <4 x i64> @llvm.x86.avx2.pmulu.dq(<8 x i32> undef, <8 x i32> undef)
  ret <4 x i64> %1
}

define <8 x i64> @undef_pmuludq_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @undef_pmuludq_512(
; CHECK-NEXT:    ret <8 x i64> zeroinitializer
;
  %1 = call <8 x i64> @llvm.x86.avx512.pmulu.dq.512(<16 x i32> undef, <16 x i32> undef)
  ret <8 x i64> %1
}

define <2 x i64> @undef_pmuldq_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @undef_pmuldq_128(
; CHECK-NEXT:    ret <2 x i64> zeroinitializer
;
  %1 = call <2 x i64> @llvm.x86.sse41.pmuldq(<4 x i32> undef, <4 x i32> undef)
  ret <2 x i64> %1
}

define <4 x i64> @undef_pmuldq_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @undef_pmuldq_256(
; CHECK-NEXT:    ret <4 x i64> zeroinitializer
;
  %1 = call <4 x i64> @llvm.x86.avx2.pmul.dq(<8 x i32> undef, <8 x i32> undef)
  ret <4 x i64> %1
}

define <8 x i64> @undef_pmuldq_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @undef_pmuldq_512(
; CHECK-NEXT:    ret <8 x i64> zeroinitializer
;
  %1 = call <8 x i64> @llvm.x86.avx512.pmul.dq.512(<16 x i32> undef, <16 x i32> undef)
  ret <8 x i64> %1
}

define <2 x i64> @undef_zero_pmuludq_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @undef_zero_pmuludq_128(
; CHECK-NEXT:    ret <2 x i64> zeroinitializer
;
  %1 = call <2 x i64> @llvm.x86.sse2.pmulu.dq(<4 x i32> undef, <4 x i32> zeroinitializer)
  ret <2 x i64> %1
}

define <4 x i64> @undef_zero_pmuludq_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @undef_zero_pmuludq_256(
; CHECK-NEXT:    ret <4 x i64> zeroinitializer
;
  %1 = call <4 x i64> @llvm.x86.avx2.pmulu.dq(<8 x i32> zeroinitializer, <8 x i32> undef)
  ret <4 x i64> %1
}

define <8 x i64> @undef_zero_pmuludq_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @undef_zero_pmuludq_512(
; CHECK-NEXT:    ret <8 x i64> zeroinitializer
;
  %1 = call <8 x i64> @llvm.x86.avx512.pmulu.dq.512(<16 x i32> undef, <16 x i32> zeroinitializer)
  ret <8 x i64> %1
}

define <2 x i64> @undef_zero_pmuldq_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @undef_zero_pmuldq_128(
; CHECK-NEXT:    ret <2 x i64> zeroinitializer
;
  %1 = call <2 x i64> @llvm.x86.sse41.pmuldq(<4 x i32> zeroinitializer, <4 x i32> undef)
  ret <2 x i64> %1
}

define <4 x i64> @undef_zero_pmuldq_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @undef_zero_pmuldq_256(
; CHECK-NEXT:    ret <4 x i64> zeroinitializer
;
  %1 = call <4 x i64> @llvm.x86.avx2.pmul.dq(<8 x i32> undef, <8 x i32> zeroinitializer)
  ret <4 x i64> %1
}

define <8 x i64> @undef_zero_pmuldq_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @undef_zero_pmuldq_512(
; CHECK-NEXT:    ret <8 x i64> zeroinitializer
;
  %1 = call <8 x i64> @llvm.x86.avx512.pmul.dq.512(<16 x i32> zeroinitializer, <16 x i32> undef)
  ret <8 x i64> %1
}

;
; Constant Folding
;

define <2 x i64> @fold_pmuludq_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @fold_pmuludq_128(
; CHECK-NEXT:    ret <2 x i64> <i64 9223372030412324865, i64 4294967295>
;
  %1 = call <2 x i64> @llvm.x86.sse2.pmulu.dq(<4 x i32> <i32 -1, i32 -1, i32 -1, i32 -1>, <4 x i32> <i32 2147483647, i32 1, i32 1, i32 3>)
  ret <2 x i64> %1
}

define <4 x i64> @fold_pmuludq_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @fold_pmuludq_256(
; CHECK-NEXT:    ret <4 x i64> zeroinitializer
;
  %1 = call <4 x i64> @llvm.x86.avx2.pmulu.dq(<8 x i32> zeroinitializer, <8 x i32> zeroinitializer)
  ret <4 x i64> %1
}

define <8 x i64> @fold_pmuludq_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @fold_pmuludq_512(
; CHECK-NEXT:    ret <8 x i64> <i64 0, i64 0, i64 255, i64 131070, i64 0, i64 -281474976645121, i64 140737488289792, i64 281470681743360>
;
  %1 = call <8 x i64> @llvm.x86.avx512.pmulu.dq.512(<16 x i32> <i32 0, i32 0, i32 undef, i32 0, i32 1, i32 1, i32 2, i32 2, i32 undef, i32 undef, i32 -1, i32 -1, i32 65536, i32 -1, i32 -65536, i32 undef>, <16 x i32> <i32 undef, i32 undef, i32 undef, i32 1, i32 255, i32 -256, i32 65535, i32 -65536, i32 0, i32 -1, i32 -65535, i32 -65535, i32 2147483647, i32 2147483648, i32 65536, i32 -65535>)
  ret <8 x i64> %1
}

define <2 x i64> @fold_pmuldq_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @fold_pmuldq_128(
; CHECK-NEXT:    ret <2 x i64> <i64 0, i64 2>
;
  %1 = call <2 x i64> @llvm.x86.sse41.pmuldq(<4 x i32> <i32 undef, i32 -1, i32 -1, i32 -1>, <4 x i32> <i32 undef, i32 1, i32 -2, i32 3>)
  ret <2 x i64> %1
}

define <4 x i64> @fold_pmuldq_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @fold_pmuldq_256(
; CHECK-NEXT:    ret <4 x i64> <i64 0, i64 4294836225, i64 140737488289792, i64 -140737488355328>
;
  %1 = call <4 x i64> @llvm.x86.avx2.pmul.dq(<8 x i32> <i32 undef, i32 1, i32 -65535, i32 128, i32 65536, i32 2147483647, i32 -2147483648, i32 65536>, <8 x i32> <i32 0, i32 -1, i32 -65535, i32 -65535, i32 2147483647, i32 2147483648, i32 65536, i32 -65535>)
  ret <4 x i64> %1
}

define <8 x i64> @fold_pmuldq_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @fold_pmuldq_512(
; CHECK-NEXT:    ret <8 x i64> zeroinitializer
;
  %1 = call <8 x i64> @llvm.x86.avx512.pmul.dq.512(<16 x i32> zeroinitializer, <16 x i32> <i32 undef, i32 -1, i32 -3, i32 -1, i32 8, i32 10, i32 -256, i32 65536, i32 undef, i32 1, i32 -65535, i32 128, i32 65536, i32 2147483647, i32 -2147483648, i32 65536>)
  ret <8 x i64> %1
}

;
; PMULUDQ/PMULDQ - only the even elements (0, 2, 4, 6) of the vXi32 inputs are required.
;

define <2 x i64> @test_demanded_elts_pmuludq_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @test_demanded_elts_pmuludq_128(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[A0:%.*]], <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i32> [[A1:%.*]], <4 x i32> undef, <4 x i32> <i32 1, i32 1, i32 undef, i32 undef>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <4 x i32> [[TMP1]] to <2 x i64>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP2]] to <2 x i64>
; CHECK-NEXT:    [[TMP5:%.*]] = and <2 x i64> [[TMP3]], <i64 4294967295, i64 undef>
; CHECK-NEXT:    [[TMP6:%.*]] = and <2 x i64> [[TMP4]], <i64 4294967295, i64 undef>
; CHECK-NEXT:    [[TMP7:%.*]] = mul nuw <2 x i64> [[TMP5]], [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = shufflevector <2 x i64> [[TMP7]], <2 x i64> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    ret <2 x i64> [[TMP8]]
;
  %1 = shufflevector <4 x i32> %a0, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 2, i32 2>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> undef, <4 x i32> <i32 1, i32 1, i32 3, i32 3>
  %3 = call <2 x i64> @llvm.x86.sse2.pmulu.dq(<4 x i32> %1, <4 x i32> %2)
  %4 = shufflevector <2 x i64> %3, <2 x i64> undef, <2 x i32> zeroinitializer
  ret <2 x i64> %4
}

define <4 x i64> @test_demanded_elts_pmuludq_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @test_demanded_elts_pmuludq_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A0:%.*]], <8 x i32> undef, <8 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[A1:%.*]], <8 x i32> undef, <8 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <8 x i32> [[TMP1]] to <4 x i64>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <8 x i32> [[TMP2]] to <4 x i64>
; CHECK-NEXT:    [[TMP5:%.*]] = and <4 x i64> [[TMP3]], <i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295>
; CHECK-NEXT:    [[TMP6:%.*]] = and <4 x i64> [[TMP4]], <i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295>
; CHECK-NEXT:    [[TMP7:%.*]] = mul nuw <4 x i64> [[TMP5]], [[TMP6]]
; CHECK-NEXT:    ret <4 x i64> [[TMP7]]
;
  %1 = shufflevector <8 x i32> %a0, <8 x i32> undef, <8 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6>
  %2 = shufflevector <8 x i32> %a1, <8 x i32> undef, <8 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7>
  %3 = call <4 x i64> @llvm.x86.avx2.pmulu.dq(<8 x i32> %1, <8 x i32> %2)
  ret <4 x i64> %3
}

define <8 x i64> @test_demanded_elts_pmuludq_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @test_demanded_elts_pmuludq_512(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <16 x i32> [[A0:%.*]], <16 x i32> undef, <16 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6, i32 8, i32 8, i32 10, i32 10, i32 12, i32 12, i32 14, i32 14>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i32> [[A1:%.*]], <16 x i32> undef, <16 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7, i32 9, i32 9, i32 11, i32 11, i32 13, i32 13, i32 15, i32 15>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <16 x i32> [[TMP1]] to <8 x i64>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <16 x i32> [[TMP2]] to <8 x i64>
; CHECK-NEXT:    [[TMP5:%.*]] = and <8 x i64> [[TMP3]], <i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295>
; CHECK-NEXT:    [[TMP6:%.*]] = and <8 x i64> [[TMP4]], <i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295, i64 4294967295>
; CHECK-NEXT:    [[TMP7:%.*]] = mul nuw <8 x i64> [[TMP5]], [[TMP6]]
; CHECK-NEXT:    ret <8 x i64> [[TMP7]]
;
  %1 = shufflevector <16 x i32> %a0, <16 x i32> undef, <16 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6, i32 8, i32 8, i32 10, i32 10, i32 12, i32 12, i32 14, i32 14>
  %2 = shufflevector <16 x i32> %a1, <16 x i32> undef, <16 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7, i32 9, i32 9, i32 11, i32 11, i32 13, i32 13, i32 15, i32 15>
  %3 = call <8 x i64> @llvm.x86.avx512.pmulu.dq.512(<16 x i32> %1, <16 x i32> %2)
  ret <8 x i64> %3
}

define <2 x i64> @test_demanded_elts_pmuldq_128(<4 x i32> %a0, <4 x i32> %a1) {
; CHECK-LABEL: @test_demanded_elts_pmuldq_128(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <4 x i32> [[A0:%.*]], <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 2, i32 2>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <4 x i32> [[A1:%.*]], <4 x i32> undef, <4 x i32> <i32 1, i32 1, i32 3, i32 3>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <4 x i32> [[TMP1]] to <2 x i64>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <4 x i32> [[TMP2]] to <2 x i64>
; CHECK-NEXT:    [[TMP5:%.*]] = shl <2 x i64> [[TMP3]], <i64 32, i64 32>
; CHECK-NEXT:    [[TMP6:%.*]] = ashr exact <2 x i64> [[TMP5]], <i64 32, i64 32>
; CHECK-NEXT:    [[TMP7:%.*]] = shl <2 x i64> [[TMP4]], <i64 32, i64 32>
; CHECK-NEXT:    [[TMP8:%.*]] = ashr exact <2 x i64> [[TMP7]], <i64 32, i64 32>
; CHECK-NEXT:    [[TMP9:%.*]] = mul nsw <2 x i64> [[TMP6]], [[TMP8]]
; CHECK-NEXT:    ret <2 x i64> [[TMP9]]
;
  %1 = shufflevector <4 x i32> %a0, <4 x i32> undef, <4 x i32> <i32 0, i32 0, i32 2, i32 2>
  %2 = shufflevector <4 x i32> %a1, <4 x i32> undef, <4 x i32> <i32 1, i32 1, i32 3, i32 3>
  %3 = call <2 x i64> @llvm.x86.sse41.pmuldq(<4 x i32> %1, <4 x i32> %2)
  ret <2 x i64> %3
}

define <4 x i64> @test_demanded_elts_pmuldq_256(<8 x i32> %a0, <8 x i32> %a1) {
; CHECK-LABEL: @test_demanded_elts_pmuldq_256(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <8 x i32> [[A0:%.*]], <8 x i32> undef, <8 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <8 x i32> [[A1:%.*]], <8 x i32> undef, <8 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <8 x i32> [[TMP1]] to <4 x i64>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <8 x i32> [[TMP2]] to <4 x i64>
; CHECK-NEXT:    [[TMP5:%.*]] = shl <4 x i64> [[TMP3]], <i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[TMP6:%.*]] = ashr exact <4 x i64> [[TMP5]], <i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[TMP7:%.*]] = shl <4 x i64> [[TMP4]], <i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[TMP8:%.*]] = ashr exact <4 x i64> [[TMP7]], <i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[TMP9:%.*]] = mul nsw <4 x i64> [[TMP6]], [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <4 x i64> [[TMP9]], <4 x i64> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
; CHECK-NEXT:    ret <4 x i64> [[TMP10]]
;
  %1 = shufflevector <8 x i32> %a0, <8 x i32> undef, <8 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6>
  %2 = shufflevector <8 x i32> %a1, <8 x i32> undef, <8 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7>
  %3 = call <4 x i64> @llvm.x86.avx2.pmul.dq(<8 x i32> %1, <8 x i32> %2)
  %4 = shufflevector <4 x i64> %3, <4 x i64> undef, <4 x i32> <i32 0, i32 0, i32 3, i32 3>
  ret <4 x i64> %4
}

define <8 x i64> @test_demanded_elts_pmuldq_512(<16 x i32> %a0, <16 x i32> %a1) {
; CHECK-LABEL: @test_demanded_elts_pmuldq_512(
; CHECK-NEXT:    [[TMP1:%.*]] = shufflevector <16 x i32> [[A0:%.*]], <16 x i32> undef, <16 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6, i32 8, i32 8, i32 10, i32 10, i32 12, i32 12, i32 14, i32 14>
; CHECK-NEXT:    [[TMP2:%.*]] = shufflevector <16 x i32> [[A1:%.*]], <16 x i32> undef, <16 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7, i32 9, i32 9, i32 11, i32 11, i32 13, i32 13, i32 15, i32 15>
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast <16 x i32> [[TMP1]] to <8 x i64>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast <16 x i32> [[TMP2]] to <8 x i64>
; CHECK-NEXT:    [[TMP5:%.*]] = shl <8 x i64> [[TMP3]], <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[TMP6:%.*]] = ashr exact <8 x i64> [[TMP5]], <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[TMP7:%.*]] = shl <8 x i64> [[TMP4]], <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[TMP8:%.*]] = ashr exact <8 x i64> [[TMP7]], <i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32, i64 32>
; CHECK-NEXT:    [[TMP9:%.*]] = mul nsw <8 x i64> [[TMP6]], [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = shufflevector <8 x i64> [[TMP9]], <8 x i64> undef, <8 x i32> <i32 0, i32 0, i32 3, i32 3, i32 4, i32 4, i32 7, i32 7>
; CHECK-NEXT:    ret <8 x i64> [[TMP10]]
;
  %1 = shufflevector <16 x i32> %a0, <16 x i32> undef, <16 x i32> <i32 0, i32 0, i32 2, i32 2, i32 4, i32 4, i32 6, i32 6, i32 8, i32 8, i32 10, i32 10, i32 12, i32 12, i32 14, i32 14>
  %2 = shufflevector <16 x i32> %a1, <16 x i32> undef, <16 x i32> <i32 1, i32 1, i32 3, i32 3, i32 5, i32 5, i32 7, i32 7, i32 9, i32 9, i32 11, i32 11, i32 13, i32 13, i32 15, i32 15>
  %3 = call <8 x i64> @llvm.x86.avx512.pmul.dq.512(<16 x i32> %1, <16 x i32> %2)
  %4 = shufflevector <8 x i64> %3, <8 x i64> undef, <8 x i32> <i32 0, i32 0, i32 3, i32 3, i32 4, i32 4, i32 7, i32 7>
  ret <8 x i64> %4
}

declare <2 x i64> @llvm.x86.sse2.pmulu.dq(<4 x i32>, <4 x i32>) nounwind readnone
declare <2 x i64> @llvm.x86.sse41.pmuldq(<4 x i32>, <4 x i32>) nounwind readnone

declare <4 x i64> @llvm.x86.avx2.pmulu.dq(<8 x i32>, <8 x i32>) nounwind readnone
declare <4 x i64> @llvm.x86.avx2.pmul.dq(<8 x i32>, <8 x i32>) nounwind readnone

declare <8 x i64> @llvm.x86.avx512.pmulu.dq.512(<16 x i32>, <16 x i32>) nounwind readnone
declare <8 x i64> @llvm.x86.avx512.pmul.dq.512(<16 x i32>, <16 x i32>) nounwind readnone
