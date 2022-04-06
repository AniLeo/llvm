; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unkown-unkown -mattr=+avx512bw -mattr=+avx512vl -mattr=+avx512fp16 | FileCheck %s

define <16 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_256(<16 x i16> %arg0, <16 x half> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtw2ph %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %msk = bitcast i16 %mask to <16 x i1>
  %res0 = sitofp <16 x i16> %arg0 to <16 x half>
  %res = select <16 x i1> %msk, <16 x half> %res0, <16 x half> %arg1
  ret <16 x half> %res
}

define <16 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_256_b(i16* %arg0, <16 x half> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_256_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtw2ph (%rdi){1to16}, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %msk = bitcast i16 %mask to <16 x i1>
  %scalar = load i16, i16* %arg0
  %scalar_in_vector = insertelement <16 x i16> undef, i16 %scalar, i32 0
  %val = shufflevector <16 x i16> %scalar_in_vector, <16 x i16> undef, <16 x i32> zeroinitializer
  %res0 = sitofp <16 x i16> %val to <16 x half>
  %res = select <16 x i1> %msk, <16 x half> %res0, <16 x half> %arg1
  ret <16 x half> %res
}

define <16 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_256_nomask(<16 x i16> %arg0, <16 x half> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_256_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtw2ph %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res = sitofp <16 x i16> %arg0 to <16 x half>
  ret <16 x half> %res
}

define <16 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_256_z(<16 x i16> %arg0, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_256_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtw2ph %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %msk = bitcast i16 %mask to <16 x i1>
  %res0 = sitofp <16 x i16> %arg0 to <16 x half>
  %res = select <16 x i1> %msk, <16 x half> %res0, <16 x half> zeroinitializer
  ret <16 x half> %res
}

define <16 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_256_load(<16 x i16>* %arg0, <16 x half> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_256_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtw2ph (%rdi), %ymm0 {%k1}
; CHECK-NEXT:    retq
  %msk = bitcast i16 %mask to <16 x i1>
  %val = load <16 x i16>, <16 x i16>* %arg0
  %res0 = sitofp <16 x i16> %val to <16 x half>
  %res = select <16 x i1> %msk, <16 x half> %res0, <16 x half> %arg1
  ret <16 x half> %res
}

declare <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.256(<16 x half>, <16 x i16>, i16)

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_256(<16 x half> %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtph2w %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.256(<16 x half> %arg0, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_256_b(half* %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_256_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtph2w (%rdi){1to16}, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %scalar = load half, half* %arg0
  %scalar_in_vector = insertelement <16 x half> undef, half %scalar, i32 0
  %val = shufflevector <16 x half> %scalar_in_vector, <16 x half> undef, <16 x i32> zeroinitializer
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.256(<16 x half> %val, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_256_nomask(<16 x half> %arg0, <16 x i16> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_256_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2w %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.256(<16 x half> %arg0, <16 x i16> %arg1, i16 -1)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_256_z(<16 x half> %arg0, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_256_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtph2w %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.256(<16 x half> %arg0, <16 x i16> zeroinitializer, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_256_load(<16 x half>* %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_256_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtph2w (%rdi), %ymm0 {%k1}
; CHECK-NEXT:    retq
  %val = load <16 x half>, <16 x half>* %arg0
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.256(<16 x half> %val, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <16 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_256(<16 x i16> %arg0, <16 x half> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtuw2ph %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %msk = bitcast i16 %mask to <16 x i1>
  %res0 = uitofp <16 x i16> %arg0 to <16 x half>
  %res = select <16 x i1> %msk, <16 x half> %res0, <16 x half> %arg1
  ret <16 x half> %res
}

define <16 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_256_b(i16* %arg0, <16 x half> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_256_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtuw2ph (%rdi){1to16}, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %msk = bitcast i16 %mask to <16 x i1>
  %scalar = load i16, i16* %arg0
  %scalar_in_vector = insertelement <16 x i16> undef, i16 %scalar, i32 0
  %val = shufflevector <16 x i16> %scalar_in_vector, <16 x i16> undef, <16 x i32> zeroinitializer
  %res0 = uitofp <16 x i16> %val to <16 x half>
  %res = select <16 x i1> %msk, <16 x half> %res0, <16 x half> %arg1
  ret <16 x half> %res
}

define <16 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_256_nomask(<16 x i16> %arg0, <16 x half> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_256_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtuw2ph %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res = uitofp <16 x i16> %arg0 to <16 x half>
  ret <16 x half> %res
}

define <16 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_256_z(<16 x i16> %arg0, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_256_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtuw2ph %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %msk = bitcast i16 %mask to <16 x i1>
  %res0 = uitofp <16 x i16> %arg0 to <16 x half>
  %res = select <16 x i1> %msk, <16 x half> %res0, <16 x half> zeroinitializer
  ret <16 x half> %res
}

define <16 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_256_load(<16 x i16>* %arg0, <16 x half> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_256_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtuw2ph (%rdi), %ymm0 {%k1}
; CHECK-NEXT:    retq
  %msk = bitcast i16 %mask to <16 x i1>
  %val = load <16 x i16>, <16 x i16>* %arg0
  %res0 = uitofp <16 x i16> %val to <16 x half>
  %res = select <16 x i1> %msk, <16 x half> %res0, <16 x half> %arg1
  ret <16 x half> %res
}

declare <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.256(<16 x half>, <16 x i16>, i16)

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_256(<16 x half> %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtph2uw %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.256(<16 x half> %arg0, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_256_b(half* %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_256_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtph2uw (%rdi){1to16}, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %scalar = load half, half* %arg0
  %scalar_in_vector = insertelement <16 x half> undef, half %scalar, i32 0
  %val = shufflevector <16 x half> %scalar_in_vector, <16 x half> undef, <16 x i32> zeroinitializer
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.256(<16 x half> %val, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_256_nomask(<16 x half> %arg0, <16 x i16> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_256_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2uw %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.256(<16 x half> %arg0, <16 x i16> %arg1, i16 -1)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_256_z(<16 x half> %arg0, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_256_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtph2uw %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.256(<16 x half> %arg0, <16 x i16> zeroinitializer, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_256_load(<16 x half>* %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_256_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtph2uw (%rdi), %ymm0 {%k1}
; CHECK-NEXT:    retq
  %val = load <16 x half>, <16 x half>* %arg0
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.256(<16 x half> %val, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

declare <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.256(<16 x half>, <16 x i16>, i16)

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_256(<16 x half> %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvttph2w %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.256(<16 x half> %arg0, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_256_b(half* %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_256_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvttph2w (%rdi){1to16}, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %scalar = load half, half* %arg0
  %scalar_in_vector = insertelement <16 x half> undef, half %scalar, i32 0
  %val = shufflevector <16 x half> %scalar_in_vector, <16 x half> undef, <16 x i32> zeroinitializer
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.256(<16 x half> %val, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_256_nomask(<16 x half> %arg0, <16 x i16> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_256_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttph2w %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.256(<16 x half> %arg0, <16 x i16> %arg1, i16 -1)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_256_z(<16 x half> %arg0, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_256_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvttph2w %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.256(<16 x half> %arg0, <16 x i16> zeroinitializer, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_256_load(<16 x half>* %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_256_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvttph2w (%rdi), %ymm0 {%k1}
; CHECK-NEXT:    retq
  %val = load <16 x half>, <16 x half>* %arg0
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.256(<16 x half> %val, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

declare <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.256(<16 x half>, <16 x i16>, i16)

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_256(<16 x half> %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_256:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvttph2uw %ymm0, %ymm1 {%k1}
; CHECK-NEXT:    vmovaps %ymm1, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.256(<16 x half> %arg0, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_256_b(half* %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_256_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvttph2uw (%rdi){1to16}, %ymm0 {%k1}
; CHECK-NEXT:    retq
  %scalar = load half, half* %arg0
  %scalar_in_vector = insertelement <16 x half> undef, half %scalar, i32 0
  %val = shufflevector <16 x half> %scalar_in_vector, <16 x half> undef, <16 x i32> zeroinitializer
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.256(<16 x half> %val, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_256_nomask(<16 x half> %arg0, <16 x i16> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_256_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttph2uw %ymm0, %ymm0
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.256(<16 x half> %arg0, <16 x i16> %arg1, i16 -1)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_256_z(<16 x half> %arg0, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_256_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvttph2uw %ymm0, %ymm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.256(<16 x half> %arg0, <16 x i16> zeroinitializer, i16 %mask)
  ret <16 x i16> %res
}

define <16 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_256_load(<16 x half>* %arg0, <16 x i16> %arg1, i16 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_256_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvttph2uw (%rdi), %ymm0 {%k1}
; CHECK-NEXT:    retq
  %val = load <16 x half>, <16 x half>* %arg0
  %res = call <16 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.256(<16 x half> %val, <16 x i16> %arg1, i16 %mask)
  ret <16 x i16> %res
}

define <8 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_128(<8 x i16> %arg0, <8 x half> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtw2ph %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vmovaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %msk = bitcast i8 %mask to <8 x i1>
  %res0 = sitofp <8 x i16> %arg0 to <8 x half>
  %res = select <8 x i1> %msk, <8 x half> %res0, <8 x half> %arg1
  ret <8 x half> %res
}

define <8 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_128_b(i16* %arg0, <8 x half> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_128_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtw2ph (%rdi){1to8}, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %msk = bitcast i8 %mask to <8 x i1>
  %scalar = load i16, i16* %arg0
  %scalar_in_vector = insertelement <8 x i16> undef, i16 %scalar, i32 0
  %val = shufflevector <8 x i16> %scalar_in_vector, <8 x i16> undef, <8 x i32> zeroinitializer
  %res0 = sitofp <8 x i16> %val to <8 x half>
  %res = select <8 x i1> %msk, <8 x half> %res0, <8 x half> %arg1
  ret <8 x half> %res
}

define <8 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_128_nomask(<8 x i16> %arg0, <8 x half> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_128_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtw2ph %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = sitofp <8 x i16> %arg0 to <8 x half>
  ret <8 x half> %res
}

define <8 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_128_z(<8 x i16> %arg0, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_128_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtw2ph %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %msk = bitcast i8 %mask to <8 x i1>
  %res0 = sitofp <8 x i16> %arg0 to <8 x half>
  %res = select <8 x i1> %msk, <8 x half> %res0, <8 x half> zeroinitializer
  ret <8 x half> %res
}

define <8 x half> @test_int_x86_avx512fp16_mask_cvtw2ph_128_load(<8 x i16>* %arg0, <8 x half> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtw2ph_128_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtw2ph (%rdi), %xmm0 {%k1}
; CHECK-NEXT:    retq
  %msk = bitcast i8 %mask to <8 x i1>
  %val = load <8 x i16>, <8 x i16>* %arg0
  %res0 = sitofp <8 x i16> %val to <8 x half>
  %res = select <8 x i1> %msk, <8 x half> %res0, <8 x half> %arg1
  ret <8 x half> %res
}

declare <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.128(<8 x half>, <8 x i16>, i8)

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_128(<8 x half> %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtph2w %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vmovaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.128(<8 x half> %arg0, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_128_b(half* %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_128_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtph2w (%rdi){1to8}, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %scalar = load half, half* %arg0
  %scalar_in_vector = insertelement <8 x half> undef, half %scalar, i32 0
  %val = shufflevector <8 x half> %scalar_in_vector, <8 x half> undef, <8 x i32> zeroinitializer
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.128(<8 x half> %val, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_128_nomask(<8 x half> %arg0, <8 x i16> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_128_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2w %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.128(<8 x half> %arg0, <8 x i16> %arg1, i8 -1)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_128_z(<8 x half> %arg0, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_128_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtph2w %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.128(<8 x half> %arg0, <8 x i16> zeroinitializer, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2w_128_load(<8 x half>* %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2w_128_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtph2w (%rdi), %xmm0 {%k1}
; CHECK-NEXT:    retq
  %val = load <8 x half>, <8 x half>* %arg0
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2w.128(<8 x half> %val, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}


define <8 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_128(<8 x i16> %arg0, <8 x half> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtuw2ph %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vmovaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %msk = bitcast i8 %mask to <8 x i1>
  %res0 = uitofp <8 x i16> %arg0 to <8 x half>
  %res = select <8 x i1> %msk, <8 x half> %res0, <8 x half> %arg1
  ret <8 x half> %res
}

define <8 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_128_b(i16* %arg0, <8 x half> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_128_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtuw2ph (%rdi){1to8}, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %msk = bitcast i8 %mask to <8 x i1>
  %scalar = load i16, i16* %arg0
  %scalar_in_vector = insertelement <8 x i16> undef, i16 %scalar, i32 0
  %val = shufflevector <8 x i16> %scalar_in_vector, <8 x i16> undef, <8 x i32> zeroinitializer
  %res0 = uitofp <8 x i16> %val to <8 x half>
  %res = select <8 x i1> %msk, <8 x half> %res0, <8 x half> %arg1
  ret <8 x half> %res
}

define <8 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_128_nomask(<8 x i16> %arg0, <8 x half> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_128_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtuw2ph %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = uitofp <8 x i16> %arg0 to <8 x half>
  ret <8 x half> %res
}

define <8 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_128_z(<8 x i16> %arg0, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_128_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtuw2ph %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %msk = bitcast i8 %mask to <8 x i1>
  %res0 = uitofp <8 x i16> %arg0 to <8 x half>
  %res = select <8 x i1> %msk, <8 x half> %res0, <8 x half> zeroinitializer
  ret <8 x half> %res
}

define <8 x half> @test_int_x86_avx512fp16_mask_cvtuw2ph_128_load(<8 x i16>* %arg0, <8 x half> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtuw2ph_128_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtuw2ph (%rdi), %xmm0 {%k1}
; CHECK-NEXT:    retq
  %msk = bitcast i8 %mask to <8 x i1>
  %val = load <8 x i16>, <8 x i16>* %arg0
  %res0 = uitofp <8 x i16> %val to <8 x half>
  %res = select <8 x i1> %msk, <8 x half> %res0, <8 x half> %arg1
  ret <8 x half> %res
}

declare <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.128(<8 x half>, <8 x i16>, i8)

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_128(<8 x half> %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtph2uw %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vmovaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.128(<8 x half> %arg0, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_128_b(half* %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_128_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtph2uw (%rdi){1to8}, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %scalar = load half, half* %arg0
  %scalar_in_vector = insertelement <8 x half> undef, half %scalar, i32 0
  %val = shufflevector <8 x half> %scalar_in_vector, <8 x half> undef, <8 x i32> zeroinitializer
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.128(<8 x half> %val, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_128_nomask(<8 x half> %arg0, <8 x i16> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_128_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtph2uw %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.128(<8 x half> %arg0, <8 x i16> %arg1, i8 -1)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_128_z(<8 x half> %arg0, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_128_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvtph2uw %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.128(<8 x half> %arg0, <8 x i16> zeroinitializer, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvtph2uw_128_load(<8 x half>* %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvtph2uw_128_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvtph2uw (%rdi), %xmm0 {%k1}
; CHECK-NEXT:    retq
  %val = load <8 x half>, <8 x half>* %arg0
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvtph2uw.128(<8 x half> %val, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

declare <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.128(<8 x half>, <8 x i16>, i8)

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_128(<8 x half> %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvttph2w %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vmovaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.128(<8 x half> %arg0, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_128_b(half* %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_128_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvttph2w (%rdi){1to8}, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %scalar = load half, half* %arg0
  %scalar_in_vector = insertelement <8 x half> undef, half %scalar, i32 0
  %val = shufflevector <8 x half> %scalar_in_vector, <8 x half> undef, <8 x i32> zeroinitializer
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.128(<8 x half> %val, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_128_nomask(<8 x half> %arg0, <8 x i16> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_128_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttph2w %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.128(<8 x half> %arg0, <8 x i16> %arg1, i8 -1)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_128_z(<8 x half> %arg0, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_128_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvttph2w %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.128(<8 x half> %arg0, <8 x i16> zeroinitializer, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2w_128_load(<8 x half>* %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2w_128_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvttph2w (%rdi), %xmm0 {%k1}
; CHECK-NEXT:    retq
  %val = load <8 x half>, <8 x half>* %arg0
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2w.128(<8 x half> %val, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

declare <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.128(<8 x half>, <8 x i16>, i8)

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_128(<8 x half> %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_128:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvttph2uw %xmm0, %xmm1 {%k1}
; CHECK-NEXT:    vmovaps %xmm1, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.128(<8 x half> %arg0, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_128_b(half* %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_128_b:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvttph2uw (%rdi){1to8}, %xmm0 {%k1}
; CHECK-NEXT:    retq
  %scalar = load half, half* %arg0
  %scalar_in_vector = insertelement <8 x half> undef, half %scalar, i32 0
  %val = shufflevector <8 x half> %scalar_in_vector, <8 x half> undef, <8 x i32> zeroinitializer
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.128(<8 x half> %val, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_128_nomask(<8 x half> %arg0, <8 x i16> %arg1) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_128_nomask:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvttph2uw %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.128(<8 x half> %arg0, <8 x i16> %arg1, i8 -1)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_128_z(<8 x half> %arg0, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_128_z:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %edi, %k1
; CHECK-NEXT:    vcvttph2uw %xmm0, %xmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.128(<8 x half> %arg0, <8 x i16> zeroinitializer, i8 %mask)
  ret <8 x i16> %res
}

define <8 x i16> @test_int_x86_avx512fp16_mask_cvttph2uw_128_load(<8 x half>* %arg0, <8 x i16> %arg1, i8 %mask) {
; CHECK-LABEL: test_int_x86_avx512fp16_mask_cvttph2uw_128_load:
; CHECK:       # %bb.0:
; CHECK-NEXT:    kmovd %esi, %k1
; CHECK-NEXT:    vcvttph2uw (%rdi), %xmm0 {%k1}
; CHECK-NEXT:    retq
  %val = load <8 x half>, <8 x half>* %arg0
  %res = call <8 x i16> @llvm.x86.avx512fp16.mask.vcvttph2uw.128(<8 x half> %val, <8 x i16> %arg1, i8 %mask)
  ret <8 x i16> %res
}

define <4 x half> @test_u16tofp4(<4 x i16> %arg0) {
; CHECK-LABEL: test_u16tofp4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtuw2ph %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = uitofp <4 x i16> %arg0 to <4 x half>
  ret <4 x half> %res
}

define <2 x half> @test_s16tofp2(<2 x i16> %arg0) {
; CHECK-LABEL: test_s16tofp2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vcvtw2ph %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = sitofp <2 x i16> %arg0 to <2 x half>
  ret <2 x half> %res
}

define <4 x half> @test_u8tofp4(<4 x i8> %arg0) {
; CHECK-LABEL: test_u8tofp4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovzxbw {{.*#+}} xmm0 = xmm0[0],zero,xmm0[1],zero,xmm0[2],zero,xmm0[3],zero,xmm0[4],zero,xmm0[5],zero,xmm0[6],zero,xmm0[7],zero
; CHECK-NEXT:    vcvtuw2ph %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = uitofp <4 x i8> %arg0 to <4 x half>
  ret <4 x half> %res
}

define <2 x half> @test_s8tofp2(<2 x i8> %arg0) {
; CHECK-LABEL: test_s8tofp2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovsxbw %xmm0, %xmm0
; CHECK-NEXT:    vcvtw2ph %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = sitofp <2 x i8> %arg0 to <2 x half>
  ret <2 x half> %res
}

define <2 x half> @test_u1tofp2(<2 x i1> %arg0) {
; CHECK-LABEL: test_u1tofp2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpmovqw %xmm0, %xmm0
; CHECK-NEXT:    vpand {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    vcvtuw2ph %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = uitofp <2 x i1> %arg0 to <2 x half>
  ret <2 x half> %res
}

define <4 x half> @test_s17tofp4(<4 x i17> %arg0) {
; CHECK-LABEL: test_s17tofp4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vpslld $15, %xmm0, %xmm0
; CHECK-NEXT:    vpsrad $15, %xmm0, %xmm0
; CHECK-NEXT:    vcvtdq2ph %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = sitofp <4 x i17> %arg0 to <4 x half>
  ret <4 x half> %res
}

define <2 x half> @test_u33tofp2(<2 x i33> %arg0) {
; CHECK-LABEL: test_u33tofp2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vandpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to2}, %xmm0, %xmm0
; CHECK-NEXT:    vcvtuqq2ph %xmm0, %xmm0
; CHECK-NEXT:    retq
  %res = uitofp <2 x i33> %arg0 to <2 x half>
  ret <2 x half> %res
}
