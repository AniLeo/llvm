; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512bw -mattr=+avx512vl -mattr=+avx512dq  | FileCheck %s  --check-prefix=CHECK --check-prefix=SKX
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f -mattr=+fma | FileCheck %s --check-prefix=CHECK --check-prefix=KNL

; This test checks combinations of FNEG and FMA intrinsics on AVX-512 target
; PR28892

declare <8 x float> @llvm.fma.v8f32(<8 x float>, <8 x float>, <8 x float>)
declare <16 x float> @llvm.fma.v16f32(<16 x float>, <16 x float>, <16 x float>)
declare <16 x float> @llvm.x86.avx512.vfmadd.ps.512(<16 x float>, <16 x float>, <16 x float>, i32)
declare <16 x float> @llvm.x86.avx512.mask.vfnmadd.ps.512(<16 x float>, <16 x float>, <16 x float>, i16, i32)
declare <16 x float> @llvm.x86.avx512.mask.vfnmsub.ps.512(<16 x float>, <16 x float>, <16 x float>, i16, i32)
declare <8 x float> @llvm.x86.fma.vfmsub.ps.256(<8 x float>, <8 x float>, <8 x float>)
declare <8 x double> @llvm.x86.avx512.vfmadd.pd.512(<8 x double> %a, <8 x double> %b, <8 x double> %c, i32)
declare <2 x double> @llvm.x86.avx512.mask.vfmadd.sd(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8, i32)
declare <4 x float> @llvm.x86.avx512.mask3.vfmadd.ss(<4 x float>, <4 x float>, <4 x float>, i8, i32)
declare <4 x float> @llvm.x86.avx512.mask.vfmadd.ss(<4 x float>, <4 x float>, <4 x float>, i8, i32)
declare <16 x float> @llvm.x86.avx512.vfmaddsub.ps.512(<16 x float>, <16 x float>, <16 x float>, i32)
declare <8 x double> @llvm.x86.avx512.vfmaddsub.pd.512(<8 x double>, <8 x double>, <8 x double>, i32)

define <16 x float> @test1(<16 x float> %a, <16 x float> %b, <16 x float> %c)  {
; CHECK-LABEL: test1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfmsub213ps {{.*#+}} zmm0 = (zmm1 * zmm0) - zmm2
; CHECK-NEXT:    retq
  %sub.i = fneg <16 x float> %c
  %t0 = tail call <16 x float> @llvm.x86.avx512.vfmadd.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %sub.i, i32 4)
  ret <16 x float> %t0
}

define <16 x float> @test2(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; SKX-LABEL: test2:
; SKX:       # %bb.0:
; SKX-NEXT:    vfmadd213ps {{.*#+}} zmm0 = (zmm1 * zmm0) + zmm2
; SKX-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test2:
; KNL:       # %bb.0:
; KNL-NEXT:    vfmadd213ps {{.*#+}} zmm0 = (zmm1 * zmm0) + zmm2
; KNL-NEXT:    vpxord {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; KNL-NEXT:    retq
  %fma = call <16 x float> @llvm.fma.v16f32(<16 x float> %a, <16 x float> %b, <16 x float> %c)
  %neg = fneg <16 x float> %fma
  ret <16 x float> %neg
}

define <16 x float> @test2_nsz(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; CHECK-LABEL: test2_nsz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfnmsub213ps {{.*#+}} zmm0 = -(zmm1 * zmm0) - zmm2
; CHECK-NEXT:    retq
  %fma = call nsz <16 x float> @llvm.fma.v16f32(<16 x float> %a, <16 x float> %b, <16 x float> %c)
  %neg = fneg <16 x float> %fma
  ret <16 x float> %neg
}

define <16 x float> @test3(<16 x float> %a, <16 x float> %b, <16 x float> %c)  {
; SKX-LABEL: test3:
; SKX:       # %bb.0:
; SKX-NEXT:    vfnmadd213ps {{.*#+}} zmm0 = -(zmm1 * zmm0) + zmm2
; SKX-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test3:
; KNL:       # %bb.0:
; KNL-NEXT:    vfnmadd213ps {{.*#+}} zmm0 = -(zmm1 * zmm0) + zmm2
; KNL-NEXT:    vpxord {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; KNL-NEXT:    retq
  %t0 = fneg <16 x float> %b
  %t1 = call <16 x float> @llvm.fma.v16f32(<16 x float> %a, <16 x float> %t0, <16 x float> %c)
  %sub.i = fneg <16 x float> %t1
  ret <16 x float> %sub.i
}

define <16 x float> @test3_nsz(<16 x float> %a, <16 x float> %b, <16 x float> %c)  {
; CHECK-LABEL: test3_nsz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfmsub213ps {{.*#+}} zmm0 = (zmm1 * zmm0) - zmm2
; CHECK-NEXT:    retq
  %t0 = fneg <16 x float> %b
  %t1 = call nsz <16 x float> @llvm.fma.v16f32(<16 x float> %a, <16 x float> %t0, <16 x float> %c)
  %sub.i = fneg <16 x float> %t1
  ret <16 x float> %sub.i
}

define <16 x float> @test4(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; SKX-LABEL: test4:
; SKX:       # %bb.0:
; SKX-NEXT:    vfnmsub213ps {{.*#+}} zmm0 = -(zmm1 * zmm0) - zmm2
; SKX-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test4:
; KNL:       # %bb.0:
; KNL-NEXT:    vfnmsub213ps {{.*#+}} zmm0 = -(zmm1 * zmm0) - zmm2
; KNL-NEXT:    vpxord {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; KNL-NEXT:    retq
  %t0 = fneg <16 x float> %b
  %t1 = fneg <16 x float> %c
  %t2 = call <16 x float> @llvm.fma.v16f32(<16 x float> %a, <16 x float> %t0, <16 x float> %t1)
  %sub.i = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %t2
  ret <16 x float> %sub.i
}

define <16 x float> @test4_nsz(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; CHECK-LABEL: test4_nsz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfmadd213ps {{.*#+}} zmm0 = (zmm1 * zmm0) + zmm2
; CHECK-NEXT:    retq
  %t0 = fneg <16 x float> %b
  %t1 = fneg <16 x float> %c
  %t2 = call nsz <16 x float> @llvm.fma.v16f32(<16 x float> %a, <16 x float> %t0, <16 x float> %t1)
  %sub.i = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %t2
  ret <16 x float> %sub.i
}

define <16 x float> @test5(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; CHECK-LABEL: test5:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmsub213ps {ru-sae}, %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %sub.i = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %0 = tail call <16 x float> @llvm.x86.avx512.vfmadd.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %sub.i, i32 10) #2
  ret <16 x float> %0
}

define <16 x float> @test6(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; SKX-LABEL: test6:
; SKX:       # %bb.0:
; SKX-NEXT:    vfnmsub213ps {ru-sae}, %zmm2, %zmm1, %zmm0
; SKX-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test6:
; KNL:       # %bb.0:
; KNL-NEXT:    vfnmsub213ps {ru-sae}, %zmm2, %zmm1, %zmm0
; KNL-NEXT:    vpxord {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; KNL-NEXT:    retq
  %t0 = fneg <16 x float> %b
  %t1 = fneg <16 x float> %c
  %t2 = call <16 x float> @llvm.x86.avx512.vfmadd.ps.512(<16 x float> %a, <16 x float> %t0, <16 x float> %t1, i32 10)
  %sub.i = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %t2
  ret <16 x float> %sub.i
}

define <16 x float> @test6_nsz(<16 x float> %a, <16 x float> %b, <16 x float> %c) {
; CHECK-LABEL: test6_nsz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfmadd213ps {ru-sae}, %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %t0 = fneg <16 x float> %b
  %t1 = fneg <16 x float> %c
  %t2 = call nsz <16 x float> @llvm.x86.avx512.vfmadd.ps.512(<16 x float> %a, <16 x float> %t0, <16 x float> %t1, i32 10)
  %sub.i = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %t2
  ret <16 x float> %sub.i
}

define <8 x float> @test7(<8 x float> %a, <8 x float> %b, <8 x float> %c) {
; SKX-LABEL: test7:
; SKX:       # %bb.0:
; SKX-NEXT:    vfmsub213ps {{.*#+}} ymm0 = (ymm1 * ymm0) - ymm2
; SKX-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %ymm0, %ymm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test7:
; KNL:       # %bb.0:
; KNL-NEXT:    vfmsub213ps {{.*#+}} ymm0 = (ymm1 * ymm0) - ymm2
; KNL-NEXT:    vbroadcastss {{.*#+}} ymm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; KNL-NEXT:    vxorps %ymm1, %ymm0, %ymm0
; KNL-NEXT:    retq
  %t0 = fneg <8 x float> %c
  %t1 = call <8 x float> @llvm.fma.v8f32(<8 x float> %a, <8 x float> %b, <8 x float> %t0)
  %sub.i = fsub <8 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %t1
  ret <8 x float> %sub.i
}

define <8 x float> @test7_nsz(<8 x float> %a, <8 x float> %b, <8 x float> %c) {
; CHECK-LABEL: test7_nsz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfnmadd213ps {{.*#+}} ymm0 = -(ymm1 * ymm0) + ymm2
; CHECK-NEXT:    retq
  %t0 = fneg <8 x float> %c
  %t1 = call nsz <8 x float> @llvm.fma.v8f32(<8 x float> %a, <8 x float> %b, <8 x float> %t0)
  %sub.i = fsub <8 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %t1
  ret <8 x float> %sub.i
}

define <8 x float> @test8(<8 x float> %a, <8 x float> %b, <8 x float> %c) {
; CHECK-LABEL: test8:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmadd213ps {{.*#+}} ymm0 = (ymm1 * ymm0) + ymm2
; CHECK-NEXT:    retq
entry:
  %sub.c = fsub <8 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %0 = tail call <8 x float> @llvm.x86.fma.vfmsub.ps.256(<8 x float> %a, <8 x float> %b, <8 x float> %sub.c) #2
  ret <8 x float> %0
}

define <8 x double> @test9(<8 x double> %a, <8 x double> %b, <8 x double> %c) {
; SKX-LABEL: test9:
; SKX:       # %bb.0:
; SKX-NEXT:    vfmadd213pd {{.*#+}} zmm0 = (zmm1 * zmm0) + zmm2
; SKX-NEXT:    vxorpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm0, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test9:
; KNL:       # %bb.0:
; KNL-NEXT:    vfmadd213pd {{.*#+}} zmm0 = (zmm1 * zmm0) + zmm2
; KNL-NEXT:    vpxorq {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm0, %zmm0
; KNL-NEXT:    retq
  %t0 = tail call <8 x double> @llvm.x86.avx512.vfmadd.pd.512(<8 x double> %a, <8 x double> %b, <8 x double> %c, i32 4)
  %sub.i = fneg <8 x double> %t0
  ret <8 x double> %sub.i
}

define <8 x double> @test9_nsz(<8 x double> %a, <8 x double> %b, <8 x double> %c) {
; CHECK-LABEL: test9_nsz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    vfnmsub213pd {{.*#+}} zmm0 = -(zmm1 * zmm0) - zmm2
; CHECK-NEXT:    retq
  %t0 = tail call nsz <8 x double> @llvm.x86.avx512.vfmadd.pd.512(<8 x double> %a, <8 x double> %b, <8 x double> %c, i32 4)
  %sub.i = fneg <8 x double> %t0
  ret <8 x double> %sub.i
}

define <2 x double> @test10(<2 x double> %a, <2 x double> %b, <2 x double> %c) {
; CHECK-LABEL: test10:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfmadd213sd {{.*#+}} xmm0 = (xmm1 * xmm0) + xmm2
; CHECK-NEXT:    vxorpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm0
; CHECK-NEXT:    retq
entry:
  %0 = tail call <2 x double> @llvm.x86.avx512.mask.vfmadd.sd(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 -1, i32 4) #2
  %sub.i = fsub <2 x double> <double -0.0, double -0.0>, %0
  ret <2 x double> %sub.i
}

define <4 x float> @test11(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test11:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %xmm2, %xmm3
; SKX-NEXT:    vfmsub213ss {{.*#+}} xmm0 = (xmm1 * xmm0) - xmm2
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vmovss %xmm0, %xmm3, %xmm3 {%k1}
; SKX-NEXT:    vmovaps %xmm3, %xmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test11:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    vbroadcastss {{.*#+}} xmm3 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; KNL-NEXT:    vxorps %xmm3, %xmm2, %xmm3
; KNL-NEXT:    vfmsub213ss {{.*#+}} xmm0 = (xmm1 * xmm0) - xmm2
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vmovss %xmm0, %xmm3, %xmm3 {%k1}
; KNL-NEXT:    vmovaps %xmm3, %xmm0
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %0 = tail call <4 x float> @llvm.x86.avx512.mask3.vfmadd.ss(<4 x float> %a, <4 x float> %b, <4 x float> %sub.i, i8 %mask, i32 4) #10
  ret <4 x float> %0
}

define <4 x float> @test11b(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test11b:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmsub213ss {{.*#+}} xmm0 {%k1} = (xmm1 * xmm0) - xmm2
; SKX-NEXT:    retq
;
; KNL-LABEL: test11b:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmsub213ss {{.*#+}} xmm0 {%k1} = (xmm1 * xmm0) - xmm2
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %0 = tail call <4 x float> @llvm.x86.avx512.mask.vfmadd.ss(<4 x float> %a, <4 x float> %b, <4 x float> %sub.i, i8 %mask, i32 4) #10
  ret <4 x float> %0
}

define <8 x double> @test12(<8 x double> %a, <8 x double> %b, <8 x double> %c, i8 %mask) {
; SKX-LABEL: test12:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmadd132pd {{.*#+}} zmm0 {%k1} = (zmm0 * zmm1) + zmm2
; SKX-NEXT:    vxorpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm0, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test12:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmadd132pd {{.*#+}} zmm0 {%k1} = (zmm0 * zmm1) + zmm2
; KNL-NEXT:    vpxorq {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm0, %zmm0
; KNL-NEXT:    retq
entry:
  %0 = tail call <8 x double> @llvm.x86.avx512.vfmadd.pd.512(<8 x double> %a, <8 x double> %b, <8 x double> %c, i32 4) #2
  %bc = bitcast i8 %mask to <8 x i1>
  %sel = select <8 x i1> %bc, <8 x double> %0, <8 x double> %a
  %sub.i = fsub <8 x double> <double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0>, %sel
  ret <8 x double> %sub.i
}

define <2 x double> @test13(<2 x double> %a, <2 x double> %b, <2 x double> %c, i8 %mask) {
; SKX-LABEL: test13:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    vxorpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm3
; SKX-NEXT:    vfnmadd213sd {{.*#+}} xmm1 = -(xmm0 * xmm1) + xmm2
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vmovsd %xmm1, %xmm3, %xmm3 {%k1}
; SKX-NEXT:    vmovapd %xmm3, %xmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test13:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    vxorpd {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0, %xmm3
; KNL-NEXT:    vfnmadd213sd {{.*#+}} xmm1 = -(xmm0 * xmm1) + xmm2
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vmovsd %xmm1, %xmm3, %xmm3 {%k1}
; KNL-NEXT:    vmovapd %xmm3, %xmm0
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <2 x double> <double -0.0, double -0.0>, %a
  %0 = tail call <2 x double> @llvm.x86.avx512.mask.vfmadd.sd(<2 x double> %sub.i, <2 x double> %b, <2 x double> %c, i8 %mask, i32 4)
  ret <2 x double> %0
}

define <16 x float> @test14(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 %mask) {
; SKX-LABEL: test14:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfnmsub132ps {ru-sae}, %zmm1, %zmm2, %zmm0 {%k1}
; SKX-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test14:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfnmsub132ps {ru-sae}, %zmm1, %zmm2, %zmm0 {%k1}
; KNL-NEXT:    vpxord {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm0
; KNL-NEXT:    retq
entry:
  %0 = tail call <16 x float> @llvm.x86.avx512.mask.vfnmsub.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 %mask, i32 10) #2
  %sub.i = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %0
  ret <16 x float> %sub.i
}

define <16 x float> @test15(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 %mask)  {
; SKX-LABEL: test15:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vxorps {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm3
; SKX-NEXT:    vfnmadd213ps {ru-sae}, %zmm2, %zmm0, %zmm1
; SKX-NEXT:    vmovaps %zmm1, %zmm3 {%k1}
; SKX-NEXT:    vfnmadd132ps {rd-sae}, %zmm0, %zmm2, %zmm3 {%k1}
; SKX-NEXT:    vmovaps %zmm3, %zmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test15:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vpxord {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %zmm0, %zmm3
; KNL-NEXT:    vfnmadd213ps {ru-sae}, %zmm2, %zmm0, %zmm1
; KNL-NEXT:    vmovaps %zmm1, %zmm3 {%k1}
; KNL-NEXT:    vfnmadd132ps {rd-sae}, %zmm0, %zmm2, %zmm3 {%k1}
; KNL-NEXT:    vmovaps %zmm3, %zmm0
; KNL-NEXT:    retq
entry:
  %bc = bitcast i16 %mask to <16 x i1>
  %sub.i = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %a
  %0 = tail call <16 x float> @llvm.x86.avx512.vfmadd.ps.512(<16 x float> %sub.i, <16 x float> %b, <16 x float> %c, i32 10)
  %sel = select <16 x i1> %bc, <16 x float> %0, <16 x float> %sub.i
  %1 = tail call <16 x float> @llvm.x86.avx512.vfmadd.ps.512(<16 x float> %sel, <16 x float> %sub.i, <16 x float> %c, i32 9)
  %sel2 = select <16 x i1> %bc, <16 x float> %1, <16 x float> %sel
  ret <16 x float> %sel2
}

define <16 x float> @test16(<16 x float> %a, <16 x float> %b, <16 x float> %c, i16 %mask) {
; SKX-LABEL: test16:
; SKX:       # %bb.0:
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmsubadd132ps {rd-sae}, %zmm1, %zmm2, %zmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test16:
; KNL:       # %bb.0:
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmsubadd132ps {rd-sae}, %zmm1, %zmm2, %zmm0 {%k1}
; KNL-NEXT:    retq
  %sub.i = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %res = call <16 x float> @llvm.x86.avx512.vfmaddsub.ps.512(<16 x float> %a, <16 x float> %b, <16 x float> %sub.i, i32 9)
  %bc = bitcast i16 %mask to <16 x i1>
  %sel = select <16 x i1> %bc, <16 x float> %res, <16 x float> %a
  ret <16 x float> %sel
}

define <8 x double> @test17(<8 x double> %a, <8 x double> %b, <8 x double> %c, i8 %mask) {
; SKX-LABEL: test17:
; SKX:       # %bb.0:
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmsubadd132pd {{.*#+}} zmm0 {%k1} = (zmm0 * zmm1) -/+ zmm2
; SKX-NEXT:    retq
;
; KNL-LABEL: test17:
; KNL:       # %bb.0:
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmsubadd132pd {{.*#+}} zmm0 {%k1} = (zmm0 * zmm1) -/+ zmm2
; KNL-NEXT:    retq
  %sub.i = fsub <8 x double> <double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0, double -0.0>, %c
  %res = call <8 x double> @llvm.x86.avx512.vfmaddsub.pd.512(<8 x double> %a, <8 x double> %b, <8 x double> %sub.i, i32 4)
  %bc = bitcast i8 %mask to <8 x i1>
  %sel = select <8 x i1> %bc, <8 x double> %res, <8 x double> %a
  ret <8 x double> %sel
}

define <4 x float> @test18(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test18:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfnmadd213ss {{.*#+}} xmm0 {%k1} = -(xmm1 * xmm0) + xmm2
; SKX-NEXT:    retq
;
; KNL-LABEL: test18:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfnmadd213ss {{.*#+}} xmm0 {%k1} = -(xmm1 * xmm0) + xmm2
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %b
  %0 = tail call <4 x float> @llvm.x86.avx512.mask.vfmadd.ss(<4 x float> %a, <4 x float> %sub.i, <4 x float> %c, i8 %mask, i32 4) #10
  ret <4 x float> %0
}

define <4 x float> @test19(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test19:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfnmsub213ss {{.*#+}} xmm0 {%k1} = -(xmm1 * xmm0) - xmm2
; SKX-NEXT:    retq
;
; KNL-LABEL: test19:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfnmsub213ss {{.*#+}} xmm0 {%k1} = -(xmm1 * xmm0) - xmm2
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %b
  %sub.i.2 = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %0 = tail call <4 x float> @llvm.x86.avx512.mask.vfmadd.ss(<4 x float> %a, <4 x float> %sub.i, <4 x float> %sub.i.2, i8 %mask, i32 4) #10
  ret <4 x float> %0
}

define <4 x float> @test20(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test20:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfnmadd231ss {{.*#+}} xmm2 {%k1} = -(xmm0 * xmm1) + xmm2
; SKX-NEXT:    vmovaps %xmm2, %xmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test20:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfnmadd231ss {{.*#+}} xmm2 {%k1} = -(xmm0 * xmm1) + xmm2
; KNL-NEXT:    vmovaps %xmm2, %xmm0
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %b
  %0 = tail call <4 x float> @llvm.x86.avx512.mask3.vfmadd.ss(<4 x float> %a, <4 x float> %sub.i, <4 x float> %c, i8 %mask, i32 4) #10
  ret <4 x float> %0
}

define <4 x float> @test21(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test21:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfnmadd213ss {rn-sae}, %xmm2, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test21:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfnmadd213ss {rn-sae}, %xmm2, %xmm1, %xmm0 {%k1}
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %b
  %0 = tail call <4 x float> @llvm.x86.avx512.mask.vfmadd.ss(<4 x float> %a, <4 x float> %sub.i, <4 x float> %c, i8 %mask, i32 8) #10
  ret <4 x float> %0
}

define <4 x float> @test22(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test22:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfnmsub213ss {rn-sae}, %xmm2, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test22:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfnmsub213ss {rn-sae}, %xmm2, %xmm1, %xmm0 {%k1}
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %b
  %sub.i.2 = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %0 = tail call <4 x float> @llvm.x86.avx512.mask.vfmadd.ss(<4 x float> %a, <4 x float> %sub.i, <4 x float> %sub.i.2, i8 %mask, i32 8) #10
  ret <4 x float> %0
}

define <4 x float> @test23(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test23:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfnmadd231ss {rn-sae}, %xmm1, %xmm0, %xmm2 {%k1}
; SKX-NEXT:    vmovaps %xmm2, %xmm0
; SKX-NEXT:    retq
;
; KNL-LABEL: test23:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfnmadd231ss {rn-sae}, %xmm1, %xmm0, %xmm2 {%k1}
; KNL-NEXT:    vmovaps %xmm2, %xmm0
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %b
  %0 = tail call <4 x float> @llvm.x86.avx512.mask3.vfmadd.ss(<4 x float> %a, <4 x float> %sub.i, <4 x float> %c, i8 %mask, i32 8) #10
  ret <4 x float> %0
}

define <4 x float> @test24(<4 x float> %a, <4 x float> %b, <4 x float> %c, i8 zeroext %mask) local_unnamed_addr #0 {
; SKX-LABEL: test24:
; SKX:       # %bb.0: # %entry
; SKX-NEXT:    kmovd %edi, %k1
; SKX-NEXT:    vfmsub213ss {rn-sae}, %xmm2, %xmm1, %xmm0 {%k1}
; SKX-NEXT:    retq
;
; KNL-LABEL: test24:
; KNL:       # %bb.0: # %entry
; KNL-NEXT:    kmovw %edi, %k1
; KNL-NEXT:    vfmsub213ss {rn-sae}, %xmm2, %xmm1, %xmm0 {%k1}
; KNL-NEXT:    retq
entry:
  %sub.i = fsub <4 x float> <float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %0 = tail call <4 x float> @llvm.x86.avx512.mask.vfmadd.ss(<4 x float> %a, <4 x float> %b, <4 x float> %sub.i, i8 %mask, i32 8) #10
  ret <4 x float> %0
}

define <16 x float> @test25(<16 x float> %a, <16 x float> %b, <16 x float> %c)  {
; CHECK-LABEL: test25:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vfnmsub213ps {rn-sae}, %zmm2, %zmm1, %zmm0
; CHECK-NEXT:    retq
entry:
  %sub.i = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %b
  %sub.i.2 = fsub <16 x float> <float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0, float -0.0>, %c
  %0 = tail call <16 x float> @llvm.x86.avx512.vfmadd.ps.512(<16 x float> %a, <16 x float> %sub.i, <16 x float> %sub.i.2, i32 8) #2
  ret <16 x float> %0
}
