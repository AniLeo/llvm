; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-apple-darwin -mattr=avx512f < %s | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc -mtriple=x86_64-apple-darwin -mattr=avx512f,avx512bw,avx512vl < %s | FileCheck %s --check-prefix=AVX512 --check-prefix=SKX

define <16 x i32> @test1(<16 x i32> %trigger, <16 x i32>* %addr) {
; AVX512-LABEL: test1:
; AVX512:       ## BB#0:
; AVX512-NEXT:    vpxord %zmm1, %zmm1, %zmm1
; AVX512-NEXT:    vpcmpeqd %zmm1, %zmm0, %k1
; AVX512-NEXT:    vmovdqu32 (%rdi), %zmm0 {%k1} {z}
; AVX512-NEXT:    retq
  %mask = icmp eq <16 x i32> %trigger, zeroinitializer
  %res = call <16 x i32> @llvm.masked.load.v16i32.p0v16i32(<16 x i32>* %addr, i32 4, <16 x i1>%mask, <16 x i32>undef)
  ret <16 x i32> %res
}

define <16 x i32> @test2(<16 x i32> %trigger, <16 x i32>* %addr) {
; AVX512-LABEL: test2:
; AVX512:       ## BB#0:
; AVX512-NEXT:    vpxord %zmm1, %zmm1, %zmm1
; AVX512-NEXT:    vpcmpeqd %zmm1, %zmm0, %k1
; AVX512-NEXT:    vmovdqu32 (%rdi), %zmm0 {%k1} {z}
; AVX512-NEXT:    retq
  %mask = icmp eq <16 x i32> %trigger, zeroinitializer
  %res = call <16 x i32> @llvm.masked.load.v16i32.p0v16i32(<16 x i32>* %addr, i32 4, <16 x i1>%mask, <16 x i32>zeroinitializer)
  ret <16 x i32> %res
}

define void @test3(<16 x i32> %trigger, <16 x i32>* %addr, <16 x i32> %val) {
; AVX512-LABEL: test3:
; AVX512:       ## BB#0:
; AVX512-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; AVX512-NEXT:    vpcmpeqd %zmm2, %zmm0, %k1
; AVX512-NEXT:    vmovdqu32 %zmm1, (%rdi) {%k1}
; AVX512-NEXT:    retq
  %mask = icmp eq <16 x i32> %trigger, zeroinitializer
  call void @llvm.masked.store.v16i32.p0v16i32(<16 x i32>%val, <16 x i32>* %addr, i32 4, <16 x i1>%mask)
  ret void
}

define <16 x float> @test4(<16 x i32> %trigger, <16 x float>* %addr, <16 x float> %dst) {
; AVX512-LABEL: test4:
; AVX512:       ## BB#0:
; AVX512-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; AVX512-NEXT:    vpcmpeqd %zmm2, %zmm0, %k1
; AVX512-NEXT:    vblendmps (%rdi), %zmm1, %zmm0 {%k1}
; AVX512-NEXT:    retq
  %mask = icmp eq <16 x i32> %trigger, zeroinitializer
  %res = call <16 x float> @llvm.masked.load.v16f32.p0v16f32(<16 x float>* %addr, i32 4, <16 x i1>%mask, <16 x float> %dst)
  ret <16 x float> %res
}

define void @test13(<16 x i32> %trigger, <16 x float>* %addr, <16 x float> %val) {
; AVX512-LABEL: test13:
; AVX512:       ## BB#0:
; AVX512-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; AVX512-NEXT:    vpcmpeqd %zmm2, %zmm0, %k1
; AVX512-NEXT:    vmovups %zmm1, (%rdi) {%k1}
; AVX512-NEXT:    retq
  %mask = icmp eq <16 x i32> %trigger, zeroinitializer
  call void @llvm.masked.store.v16f32.p0v16f32(<16 x float>%val, <16 x float>* %addr, i32 4, <16 x i1>%mask)
  ret void
}

define void @one_mask_bit_set5(<8 x double>* %addr, <8 x double> %val) {
; AVX512-LABEL: one_mask_bit_set5:
; AVX512:       ## BB#0:
; AVX512-NEXT:    vextractf32x4 $3, %zmm0, %xmm0
; AVX512-NEXT:    vmovlps %xmm0, 48(%rdi)
; AVX512-NEXT:    retq
  call void @llvm.masked.store.v8f64.p0v8f64(<8 x double> %val, <8 x double>* %addr, i32 4, <8 x i1><i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 true, i1 false>)
  ret void
}

define <8 x double> @load_one_mask_bit_set5(<8 x double>* %addr, <8 x double> %val) {
;
; AVX512-LABEL: load_one_mask_bit_set5:
; AVX512:       ## BB#0:
; AVX512-NEXT:    vextractf32x4 $3, %zmm0, %xmm1
; AVX512-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; AVX512-NEXT:    vinsertf32x4 $3, %xmm1, %zmm0, %zmm0
; AVX512-NEXT:    retq
  %res = call <8 x double> @llvm.masked.load.v8f64.p0v8f64(<8 x double>* %addr, i32 4, <8 x i1><i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 false, i1 true>, <8 x double> %val)
  ret <8 x double> %res
}

declare <16 x i32> @llvm.masked.load.v16i32.p0v16i32(<16 x i32>*, i32, <16 x i1>, <16 x i32>)
declare void @llvm.masked.store.v16i32.p0v16i32(<16 x i32>, <16 x i32>*, i32, <16 x i1>)
declare void @llvm.masked.store.v16f32.p0v16f32(<16 x float>, <16 x float>*, i32, <16 x i1>)
declare <16 x float> @llvm.masked.load.v16f32.p0v16f32(<16 x float>*, i32, <16 x i1>, <16 x float>)
declare <8 x double> @llvm.masked.load.v8f64.p0v8f64(<8 x double>*, i32, <8 x i1>, <8 x double>)
declare void @llvm.masked.store.v8f64.p0v8f64(<8 x double>, <8 x double>*, i32, <8 x i1>)

declare <16 x i32*> @llvm.masked.load.v16p0i32.p0v16p0i32(<16 x i32*>*, i32, <16 x i1>, <16 x i32*>)

define <16 x i32*> @test23(<16 x i32*> %trigger, <16 x i32*>* %addr) {
; AVX512-LABEL: test23:
; AVX512:       ## BB#0:
; AVX512-NEXT:    vpxord %zmm2, %zmm2, %zmm2
; AVX512-NEXT:    vpcmpeqq %zmm2, %zmm0, %k1
; AVX512-NEXT:    vpcmpeqq %zmm2, %zmm1, %k2
; AVX512-NEXT:    vmovdqu64 64(%rdi), %zmm1 {%k2} {z}
; AVX512-NEXT:    vmovdqu64 (%rdi), %zmm0 {%k1} {z}
; AVX512-NEXT:    retq
  %mask = icmp eq <16 x i32*> %trigger, zeroinitializer
  %res = call <16 x i32*> @llvm.masked.load.v16p0i32.p0v16p0i32(<16 x i32*>* %addr, i32 4, <16 x i1>%mask, <16 x i32*>zeroinitializer)
  ret <16 x i32*> %res
}

%mystruct = type { i16, i16, [1 x i8*] }

declare <16 x %mystruct*> @llvm.masked.load.v16p0mystruct.p0v16p0mystruct(<16 x %mystruct*>*, i32, <16 x i1>, <16 x %mystruct*>)

define <16 x %mystruct*> @test24(<16 x i1> %mask, <16 x %mystruct*>* %addr) {
; AVX512F-LABEL: test24:
; AVX512F:       ## BB#0:
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vmovdqu64 (%rdi), %zmm0 {%k1} {z}
; AVX512F-NEXT:    kshiftrw $8, %k1, %k1
; AVX512F-NEXT:    vmovdqu64 64(%rdi), %zmm1 {%k1} {z}
; AVX512F-NEXT:    retq
;
; SKX-LABEL: test24:
; SKX:       ## BB#0:
; SKX-NEXT:    vpsllw $7, %xmm0, %xmm0
; SKX-NEXT:    vpmovb2m %xmm0, %k1
; SKX-NEXT:    vmovdqu64 (%rdi), %zmm0 {%k1} {z}
; SKX-NEXT:    kshiftrw $8, %k1, %k1
; SKX-NEXT:    vmovdqu64 64(%rdi), %zmm1 {%k1} {z}
; SKX-NEXT:    retq
  %res = call <16 x %mystruct*> @llvm.masked.load.v16p0mystruct.p0v16p0mystruct(<16 x %mystruct*>* %addr, i32 4, <16 x i1>%mask, <16 x %mystruct*>zeroinitializer)
  ret <16 x %mystruct*> %res
}

define void @test_store_16i64(<16 x i64>* %ptrs, <16 x i1> %mask, <16 x i64> %src0)  {
; AVX512F-LABEL: test_store_16i64:
; AVX512F:       ## BB#0:
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vmovdqu64 %zmm1, (%rdi) {%k1}
; AVX512F-NEXT:    kshiftrw $8, %k1, %k1
; AVX512F-NEXT:    vmovdqu64 %zmm2, 64(%rdi) {%k1}
; AVX512F-NEXT:    retq
;
; SKX-LABEL: test_store_16i64:
; SKX:       ## BB#0:
; SKX-NEXT:    vpsllw $7, %xmm0, %xmm0
; SKX-NEXT:    vpmovb2m %xmm0, %k1
; SKX-NEXT:    vmovdqu64 %zmm1, (%rdi) {%k1}
; SKX-NEXT:    kshiftrw $8, %k1, %k1
; SKX-NEXT:    vmovdqu64 %zmm2, 64(%rdi) {%k1}
; SKX-NEXT:    retq
  call void @llvm.masked.store.v16i64.p0v16i64(<16 x i64> %src0, <16 x i64>* %ptrs, i32 4, <16 x i1> %mask)
  ret void
}
declare void @llvm.masked.store.v16i64.p0v16i64(<16 x i64> %src0, <16 x i64>* %ptrs, i32, <16 x i1> %mask)

define void @test_store_16f64(<16 x double>* %ptrs, <16 x i1> %mask, <16 x double> %src0)  {
; AVX512F-LABEL: test_store_16f64:
; AVX512F:       ## BB#0:
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vmovupd %zmm1, (%rdi) {%k1}
; AVX512F-NEXT:    kshiftrw $8, %k1, %k1
; AVX512F-NEXT:    vmovupd %zmm2, 64(%rdi) {%k1}
; AVX512F-NEXT:    retq
;
; SKX-LABEL: test_store_16f64:
; SKX:       ## BB#0:
; SKX-NEXT:    vpsllw $7, %xmm0, %xmm0
; SKX-NEXT:    vpmovb2m %xmm0, %k1
; SKX-NEXT:    vmovupd %zmm1, (%rdi) {%k1}
; SKX-NEXT:    kshiftrw $8, %k1, %k1
; SKX-NEXT:    vmovupd %zmm2, 64(%rdi) {%k1}
; SKX-NEXT:    retq
  call void @llvm.masked.store.v16f64.p0v16f64(<16 x double> %src0, <16 x double>* %ptrs, i32 4, <16 x i1> %mask)
  ret void
}
declare void @llvm.masked.store.v16f64.p0v16f64(<16 x double> %src0, <16 x double>* %ptrs, i32, <16 x i1> %mask)

define <16 x i64> @test_load_16i64(<16 x i64>* %ptrs, <16 x i1> %mask, <16 x i64> %src0)  {
; AVX512F-LABEL: test_load_16i64:
; AVX512F:       ## BB#0:
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vpblendmq (%rdi), %zmm1, %zmm0 {%k1}
; AVX512F-NEXT:    kshiftrw $8, %k1, %k1
; AVX512F-NEXT:    vpblendmq 64(%rdi), %zmm2, %zmm1 {%k1}
; AVX512F-NEXT:    retq
;
; SKX-LABEL: test_load_16i64:
; SKX:       ## BB#0:
; SKX-NEXT:    vpsllw $7, %xmm0, %xmm0
; SKX-NEXT:    vpmovb2m %xmm0, %k1
; SKX-NEXT:    vpblendmq (%rdi), %zmm1, %zmm0 {%k1}
; SKX-NEXT:    kshiftrw $8, %k1, %k1
; SKX-NEXT:    vpblendmq 64(%rdi), %zmm2, %zmm1 {%k1}
; SKX-NEXT:    retq
  %res = call <16 x i64> @llvm.masked.load.v16i64.p0v16i64(<16 x i64>* %ptrs, i32 4, <16 x i1> %mask, <16 x i64> %src0)
  ret <16 x i64> %res
}
declare <16 x i64> @llvm.masked.load.v16i64.p0v16i64(<16 x i64>* %ptrs, i32, <16 x i1> %mask, <16 x i64> %src0)

define <16 x double> @test_load_16f64(<16 x double>* %ptrs, <16 x i1> %mask, <16 x double> %src0)  {
; AVX512F-LABEL: test_load_16f64:
; AVX512F:       ## BB#0:
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k1
; AVX512F-NEXT:    vblendmpd (%rdi), %zmm1, %zmm0 {%k1}
; AVX512F-NEXT:    kshiftrw $8, %k1, %k1
; AVX512F-NEXT:    vblendmpd 64(%rdi), %zmm2, %zmm1 {%k1}
; AVX512F-NEXT:    retq
;
; SKX-LABEL: test_load_16f64:
; SKX:       ## BB#0:
; SKX-NEXT:    vpsllw $7, %xmm0, %xmm0
; SKX-NEXT:    vpmovb2m %xmm0, %k1
; SKX-NEXT:    vblendmpd (%rdi), %zmm1, %zmm0 {%k1}
; SKX-NEXT:    kshiftrw $8, %k1, %k1
; SKX-NEXT:    vblendmpd 64(%rdi), %zmm2, %zmm1 {%k1}
; SKX-NEXT:    retq
  %res = call <16 x double> @llvm.masked.load.v16f64.p0v16f64(<16 x double>* %ptrs, i32 4, <16 x i1> %mask, <16 x double> %src0)
  ret <16 x double> %res
}
declare <16 x double> @llvm.masked.load.v16f64.p0v16f64(<16 x double>* %ptrs, i32, <16 x i1> %mask, <16 x double> %src0)

define <32 x double> @test_load_32f64(<32 x double>* %ptrs, <32 x i1> %mask, <32 x double> %src0)  {
; AVX512F-LABEL: test_load_32f64:
; AVX512F:       ## BB#0:
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm5
; AVX512F-NEXT:    vpmovsxbd %xmm5, %zmm5
; AVX512F-NEXT:    vpslld $31, %zmm5, %zmm5
; AVX512F-NEXT:    vptestmd %zmm5, %zmm5, %k1
; AVX512F-NEXT:    vblendmpd 128(%rdi), %zmm3, %zmm5 {%k1}
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpslld $31, %zmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k2
; AVX512F-NEXT:    vblendmpd (%rdi), %zmm1, %zmm0 {%k2}
; AVX512F-NEXT:    kshiftrw $8, %k1, %k1
; AVX512F-NEXT:    vblendmpd 192(%rdi), %zmm4, %zmm3 {%k1}
; AVX512F-NEXT:    kshiftrw $8, %k2, %k1
; AVX512F-NEXT:    vblendmpd 64(%rdi), %zmm2, %zmm1 {%k1}
; AVX512F-NEXT:    vmovapd %zmm5, %zmm2
; AVX512F-NEXT:    retq
;
; SKX-LABEL: test_load_32f64:
; SKX:       ## BB#0:
; SKX-NEXT:    vpsllw $7, %ymm0, %ymm0
; SKX-NEXT:    vpmovb2m %ymm0, %k1
; SKX-NEXT:    vblendmpd (%rdi), %zmm1, %zmm0 {%k1}
; SKX-NEXT:    kshiftrd $16, %k1, %k2
; SKX-NEXT:    vblendmpd 128(%rdi), %zmm3, %zmm5 {%k2}
; SKX-NEXT:    kshiftrw $8, %k1, %k1
; SKX-NEXT:    vblendmpd 64(%rdi), %zmm2, %zmm1 {%k1}
; SKX-NEXT:    kshiftrw $8, %k2, %k1
; SKX-NEXT:    vblendmpd 192(%rdi), %zmm4, %zmm3 {%k1}
; SKX-NEXT:    vmovapd %zmm5, %zmm2
; SKX-NEXT:    retq
  %res = call <32 x double> @llvm.masked.load.v32f64.p0v32f64(<32 x double>* %ptrs, i32 4, <32 x i1> %mask, <32 x double> %src0)
  ret <32 x double> %res
}

declare <32 x double> @llvm.masked.load.v32f64.p0v32f64(<32 x double>* %ptrs, i32, <32 x i1> %mask, <32 x double> %src0)
