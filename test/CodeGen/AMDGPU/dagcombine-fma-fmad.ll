; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -march=amdgcn -mcpu=gfx1010 -verify-machineinstrs < %s | FileCheck -enable-var-scope -check-prefix=GCN %s

define amdgpu_ps float @_amdgpu_ps_main() #0 {
; GCN-LABEL: _amdgpu_ps_main:
; GCN:       ; %bb.0: ; %.entry
; GCN-NEXT:    s_mov_b32 s0, 0
; GCN-NEXT:    v_mov_b32_e32 v4, 0
; GCN-NEXT:    s_mov_b32 s1, s0
; GCN-NEXT:    s_mov_b32 s2, s0
; GCN-NEXT:    s_mov_b32 s3, s0
; GCN-NEXT:    s_mov_b32 s4, s0
; GCN-NEXT:    s_mov_b32 s5, s0
; GCN-NEXT:    s_mov_b32 s6, s0
; GCN-NEXT:    s_mov_b32 s7, s0
; GCN-NEXT:    image_sample v[0:1], v[0:1], s[0:7], s[0:3] dmask:0x3 dim:SQ_RSRC_IMG_2D
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    s_clause 0x1
; GCN-NEXT:    image_sample v2, v[0:1], s[0:7], s[0:3] dmask:0x4 dim:SQ_RSRC_IMG_2D
; GCN-NEXT:    image_sample v3, v[0:1], s[0:7], s[0:3] dmask:0x1 dim:SQ_RSRC_IMG_2D
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    image_load_mip v4, v[2:4], s[0:7] dmask:0x4 dim:SQ_RSRC_IMG_2D unorm
; GCN-NEXT:    s_clause 0x3
; GCN-NEXT:    s_buffer_load_dword s24, s[0:3], 0x5c
; GCN-NEXT:    s_buffer_load_dword s28, s[0:3], 0x7c
; GCN-NEXT:    s_buffer_load_dword s29, s[0:3], 0xc0
; GCN-NEXT:    s_waitcnt_depctr 0xffe3
; GCN-NEXT:    s_nop 0
; GCN-NEXT:    s_buffer_load_dwordx4 s[0:3], s[0:3], 0x40
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_clause 0x1
; GCN-NEXT:    s_buffer_load_dwordx4 s[4:7], s[0:3], 0x50
; GCN-NEXT:    s_nop 0
; GCN-NEXT:    s_buffer_load_dword s0, s[0:3], 0x2c
; GCN-NEXT:    v_sub_f32_e64 v5, s24, s28
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    s_clause 0x4
; GCN-NEXT:    s_buffer_load_dwordx4 s[8:11], s[0:3], 0x60
; GCN-NEXT:    s_buffer_load_dwordx4 s[12:15], s[0:3], 0x20
; GCN-NEXT:    s_buffer_load_dwordx4 s[16:19], s[0:3], 0x0
; GCN-NEXT:    s_buffer_load_dwordx4 s[20:23], s[0:3], 0x70
; GCN-NEXT:    s_buffer_load_dwordx4 s[24:27], s[0:3], 0x10
; GCN-NEXT:    v_fma_f32 v1, v1, v5, s28
; GCN-NEXT:    v_max_f32_e64 v6, s0, s0 clamp
; GCN-NEXT:    v_add_f32_e64 v5, s29, -1.0
; GCN-NEXT:    v_sub_f32_e32 v8, s0, v1
; GCN-NEXT:    v_fma_f32 v7, -s2, v6, s6
; GCN-NEXT:    v_fma_f32 v5, v6, v5, 1.0
; GCN-NEXT:    v_mad_f32 v10, s2, v6, v2
; GCN-NEXT:    s_mov_b32 s0, 0x3c23d70a
; GCN-NEXT:    v_fmac_f32_e32 v1, v6, v8
; GCN-NEXT:    v_mac_f32_e32 v10, v7, v6
; GCN-NEXT:    s_waitcnt lgkmcnt(0)
; GCN-NEXT:    v_mul_f32_e32 v9, s10, v0
; GCN-NEXT:    v_fma_f32 v0, -v0, s10, s14
; GCN-NEXT:    v_mul_f32_e32 v8, s18, v2
; GCN-NEXT:    v_mul_f32_e32 v3, s22, v3
; GCN-NEXT:    v_fmac_f32_e32 v9, v0, v6
; GCN-NEXT:    v_sub_f32_e32 v0, v1, v5
; GCN-NEXT:    v_mul_f32_e32 v1, v8, v6
; GCN-NEXT:    v_mul_f32_e32 v7, v6, v3
; GCN-NEXT:    v_fma_f32 v3, -v6, v3, v9
; GCN-NEXT:    v_fmac_f32_e32 v5, v0, v6
; GCN-NEXT:    v_fma_f32 v0, v2, s26, -v1
; GCN-NEXT:    v_fmac_f32_e32 v7, v3, v6
; GCN-NEXT:    v_fmac_f32_e32 v1, v0, v6
; GCN-NEXT:    v_mul_f32_e32 v0, v2, v6
; GCN-NEXT:    s_waitcnt vmcnt(0)
; GCN-NEXT:    v_add_f32_e32 v4, v4, v10
; GCN-NEXT:    v_mul_f32_e32 v3, v4, v6
; GCN-NEXT:    v_fmaak_f32 v4, s0, v5, 0x3ca3d70a
; GCN-NEXT:    v_mul_f32_e32 v1, v3, v1
; GCN-NEXT:    v_mul_f32_e32 v2, v7, v4
; GCN-NEXT:    v_fmac_f32_e32 v1, v2, v0
; GCN-NEXT:    v_max_f32_e32 v0, 0, v1
; GCN-NEXT:    ; return to shader part epilog
.entry:
  %0 = call <3 x float> @llvm.amdgcn.image.sample.2d.v3f32.f32(i32 7, float undef, float undef, <8 x i32> undef, <4 x i32> undef, i1 false, i32 0, i32 0)
  %.i2243 = extractelement <3 x float> %0, i32 2
  %1 = call <3 x i32> @llvm.amdgcn.s.buffer.load.v3i32(<4 x i32> undef, i32 0, i32 0)
  %2 = shufflevector <3 x i32> %1, <3 x i32> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
  %3 = bitcast <4 x i32> %2 to <4 x float>
  %.i2248 = extractelement <4 x float> %3, i32 2
  %.i2249 = fmul reassoc nnan nsz arcp contract afn float %.i2243, %.i2248
  %4 = call reassoc nnan nsz arcp contract afn float @llvm.amdgcn.fmed3.f32(float undef, float 0.000000e+00, float 1.000000e+00)
  %5 = call <3 x float> @llvm.amdgcn.image.sample.2d.v3f32.f32(i32 7, float undef, float undef, <8 x i32> undef, <4 x i32> undef, i1 false, i32 0, i32 0)
  %.i2333 = extractelement <3 x float> %5, i32 2
  %6 = call reassoc nnan nsz arcp contract afn float @llvm.amdgcn.fmed3.f32(float undef, float 0.000000e+00, float 1.000000e+00)
  %7 = call <2 x float> @llvm.amdgcn.image.sample.2d.v2f32.f32(i32 3, float undef, float undef, <8 x i32> undef, <4 x i32> undef, i1 false, i32 0, i32 0)
  %.i1408 = extractelement <2 x float> %7, i32 1
  %.i0364 = extractelement <2 x float> %7, i32 0
  %8 = call float @llvm.amdgcn.image.sample.2d.f32.f32(i32 1, float undef, float undef, <8 x i32> undef, <4 x i32> undef, i1 false, i32 0, i32 0)
  %9 = call <3 x i32> @llvm.amdgcn.s.buffer.load.v3i32(<4 x i32> undef, i32 112, i32 0)
  %10 = shufflevector <3 x i32> %9, <3 x i32> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
  %11 = bitcast <4 x i32> %10 to <4 x float>
  %.i2360 = extractelement <4 x float> %11, i32 2
  %.i2363 = fmul reassoc nnan nsz arcp contract afn float %.i2360, %8
  %12 = call <3 x i32> @llvm.amdgcn.s.buffer.load.v3i32(<4 x i32> undef, i32 96, i32 0)
  %13 = shufflevector <3 x i32> %12, <3 x i32> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
  %14 = bitcast <4 x i32> %13 to <4 x float>
  %.i2367 = extractelement <4 x float> %14, i32 2
  %.i2370 = fmul reassoc nnan nsz arcp contract afn float %.i0364, %.i2367
  %15 = call <3 x i32> @llvm.amdgcn.s.buffer.load.v3i32(<4 x i32> undef, i32 32, i32 0)
  %16 = shufflevector <3 x i32> %15, <3 x i32> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
  %17 = bitcast <4 x i32> %16 to <4 x float>
  %.i2373 = extractelement <4 x float> %17, i32 2
  %.i2376 = fsub reassoc nnan nsz arcp contract afn float %.i2373, %.i2370
  %.i2383 = fmul reassoc nnan nsz arcp contract afn float %.i2376, %6
  %.i2386 = fadd reassoc nnan nsz arcp contract afn float %.i2370, %.i2383
  %18 = call reassoc nnan nsz arcp contract afn float @llvm.amdgcn.fmed3.f32(float undef, float 0.000000e+00, float 1.000000e+00)
  %19 = fmul reassoc nnan nsz arcp contract afn float %18, %.i2363
  %.i2394 = fsub reassoc nnan nsz arcp contract afn float %.i2386, %19
  %.i2397 = fmul reassoc nnan nsz arcp contract afn float %.i2363, %18
  %.i2404 = fmul reassoc nnan nsz arcp contract afn float %.i2394, %4
  %.i2407 = fadd reassoc nnan nsz arcp contract afn float %.i2397, %.i2404
  %20 = call i32 @llvm.amdgcn.s.buffer.load.i32(<4 x i32> undef, i32 92, i32 0)
  %21 = bitcast i32 %20 to float
  %22 = call i32 @llvm.amdgcn.s.buffer.load.i32(<4 x i32> undef, i32 124, i32 0)
  %23 = bitcast i32 %22 to float
  %24 = fsub reassoc nnan nsz arcp contract afn float %21, %23
  %25 = fmul reassoc nnan nsz arcp contract afn float %.i1408, %24
  %26 = fadd reassoc nnan nsz arcp contract afn float %25, %23
  %27 = call i32 @llvm.amdgcn.s.buffer.load.i32(<4 x i32> undef, i32 44, i32 0)
  %28 = bitcast i32 %27 to float
  %29 = fsub reassoc nnan nsz arcp contract afn float %28, %26
  %30 = fmul reassoc nnan nsz arcp contract afn float %6, %29
  %31 = fadd reassoc nnan nsz arcp contract afn float %26, %30
  %32 = call i32 @llvm.amdgcn.s.buffer.load.i32(<4 x i32> undef, i32 192, i32 0)
  %33 = bitcast i32 %32 to float
  %34 = fadd reassoc nnan nsz arcp contract afn float %33, -1.000000e+00
  %35 = fmul reassoc nnan nsz arcp contract afn float %18, %34
  %36 = fadd reassoc nnan nsz arcp contract afn float %35, 1.000000e+00
  %37 = fsub reassoc nnan nsz arcp contract afn float %31, %36
  %38 = fmul reassoc nnan nsz arcp contract afn float %37, %4
  %39 = fadd reassoc nnan nsz arcp contract afn float %36, %38
  %40 = fmul reassoc nnan nsz arcp contract afn float %39, 0x3F847AE140000000
  %41 = fadd reassoc nnan nsz arcp contract afn float %40, 0x3F947AE140000000
  %.i2415 = fmul reassoc nnan nsz arcp contract afn float %.i2407, %41
  %42 = call <3 x float> @llvm.amdgcn.image.load.mip.2d.v3f32.i32(i32 7, i32 undef, i32 undef, i32 0, <8 x i32> undef, i32 0, i32 0)
  %.i2521 = extractelement <3 x float> %42, i32 2
  %43 = call reassoc nnan nsz arcp contract afn float @llvm.amdgcn.fmed3.f32(float undef, float 0.000000e+00, float 1.000000e+00)
  %44 = call <3 x float> @llvm.amdgcn.image.sample.2d.v3f32.f32(i32 7, float undef, float undef, <8 x i32> undef, <4 x i32> undef, i1 false, i32 0, i32 0)
  %.i2465 = extractelement <3 x float> %44, i32 2
  %.i2466 = fmul reassoc nnan nsz arcp contract afn float %.i2465, %43
  %.i2469 = fmul reassoc nnan nsz arcp contract afn float %.i2415, %.i2466
  %45 = call <3 x i32> @llvm.amdgcn.s.buffer.load.v3i32(<4 x i32> undef, i32 64, i32 0)
  %46 = shufflevector <3 x i32> %45, <3 x i32> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
  %47 = bitcast <4 x i32> %46 to <4 x float>
  %.i2476 = extractelement <4 x float> %47, i32 2
  %.i2479 = fmul reassoc nnan nsz arcp contract afn float %.i2476, %18
  %48 = call <3 x i32> @llvm.amdgcn.s.buffer.load.v3i32(<4 x i32> undef, i32 80, i32 0)
  %49 = shufflevector <3 x i32> %48, <3 x i32> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
  %50 = bitcast <4 x i32> %49 to <4 x float>
  %.i2482 = extractelement <4 x float> %50, i32 2
  %.i2485 = fsub reassoc nnan nsz arcp contract afn float %.i2482, %.i2479
  %.i2488 = fmul reassoc nnan nsz arcp contract afn float %.i2249, %18
  %.i2491 = fmul reassoc nnan nsz arcp contract afn float %.i2485, %4
  %.i2494 = fadd reassoc nnan nsz arcp contract afn float %.i2479, %.i2491
  %51 = call <3 x float> @llvm.amdgcn.image.sample.2d.v3f32.f32(i32 7, float undef, float undef, <8 x i32> undef, <4 x i32> undef, i1 false, i32 0, i32 0)
  %.i2515 = extractelement <3 x float> %51, i32 2
  %.i2516 = fadd reassoc nnan nsz arcp contract afn float %.i2515, %.i2494
  %.i2522 = fadd reassoc nnan nsz arcp contract afn float %.i2521, %.i2516
  %.i2525 = fmul reassoc nnan nsz arcp contract afn float %.i2522, %43
  %52 = call <3 x i32> @llvm.amdgcn.s.buffer.load.v3i32(<4 x i32> undef, i32 16, i32 0)
  %53 = shufflevector <3 x i32> %52, <3 x i32> poison, <4 x i32> <i32 0, i32 1, i32 2, i32 undef>
  %54 = bitcast <4 x i32> %53 to <4 x float>
  %.i2530 = extractelement <4 x float> %54, i32 2
  %.i2531 = fmul reassoc nnan nsz arcp contract afn float %.i2333, %.i2530
  %.i2536 = fsub reassoc nnan nsz arcp contract afn float %.i2531, %.i2488
  %.i2539 = fmul reassoc nnan nsz arcp contract afn float %.i2536, %4
  %.i2542 = fadd reassoc nnan nsz arcp contract afn float %.i2488, %.i2539
  %.i2545 = fmul reassoc nnan nsz arcp contract afn float %.i2525, %.i2542
  %.i2548 = fadd reassoc nnan nsz arcp contract afn float %.i2469, %.i2545
  %.i2551 = call reassoc nnan nsz arcp contract afn float @llvm.maxnum.f32(float %.i2548, float 0.000000e+00)
  ret float %.i2551
}

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare float @llvm.maxnum.f32(float, float) #1

; Function Attrs: nounwind readnone speculatable willreturn
declare float @llvm.amdgcn.fmed3.f32(float, float, float) #2

; Function Attrs: nounwind readonly willreturn
declare <2 x float> @llvm.amdgcn.image.sample.2d.v2f32.f32(i32 immarg, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #3

; Function Attrs: nounwind readonly willreturn
declare float @llvm.amdgcn.image.sample.2d.f32.f32(i32 immarg, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #3

; Function Attrs: nounwind readonly willreturn
declare <3 x float> @llvm.amdgcn.image.sample.2d.v3f32.f32(i32 immarg, float, float, <8 x i32>, <4 x i32>, i1 immarg, i32 immarg, i32 immarg) #3

; Function Attrs: nounwind readonly willreturn
declare <3 x float> @llvm.amdgcn.image.load.mip.2d.v3f32.i32(i32 immarg, i32, i32, i32, <8 x i32>, i32 immarg, i32 immarg) #3

; Function Attrs: nounwind readnone willreturn
declare i32 @llvm.amdgcn.s.buffer.load.i32(<4 x i32>, i32, i32 immarg) #3

; Function Attrs: nounwind readnone willreturn
declare <3 x i32> @llvm.amdgcn.s.buffer.load.v3i32(<4 x i32>, i32, i32 immarg) #3

attributes #0 = { "denormal-fp-math-f32"="preserve-sign" }
attributes #1 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #2 = { nounwind readnone speculatable willreturn }
attributes #3 = { nounwind readonly willreturn }
