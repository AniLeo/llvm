; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX --check-prefix=AVX512F
;
; Just one 32-bit run to make sure we do reasonable things.
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X32-AVX

define <4 x double> @merge_4f64_2f64_23(<2 x double>* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4f64_2f64_23:
; AVX:       # BB#0:
; AVX-NEXT:    vmovups 32(%rdi), %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4f64_2f64_23:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovups 32(%eax), %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds <2 x double>, <2 x double>* %ptr, i64 2
  %ptr1 = getelementptr inbounds <2 x double>, <2 x double>* %ptr, i64 3
  %val0 = load <2 x double>, <2 x double>* %ptr0
  %val1 = load <2 x double>, <2 x double>* %ptr1
  %res = shufflevector <2 x double> %val0, <2 x double> %val1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x double> %res
}

define <4 x double> @merge_4f64_2f64_2z(<2 x double>* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4f64_2f64_2z:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps 32(%rdi), %xmm0
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4f64_2f64_2z:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovaps 32(%eax), %xmm0
; X32-AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X32-AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds <2 x double>, <2 x double>* %ptr, i64 2
  %val0 = load <2 x double>, <2 x double>* %ptr0
  %res = shufflevector <2 x double> %val0, <2 x double> zeroinitializer, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x double> %res
}

define <4 x double> @merge_4f64_f64_2345(double* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4f64_f64_2345:
; AVX:       # BB#0:
; AVX-NEXT:    vmovups 16(%rdi), %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4f64_f64_2345:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovups 16(%eax), %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds double, double* %ptr, i64 2
  %ptr1 = getelementptr inbounds double, double* %ptr, i64 3
  %ptr2 = getelementptr inbounds double, double* %ptr, i64 4
  %ptr3 = getelementptr inbounds double, double* %ptr, i64 5
  %val0 = load double, double* %ptr0
  %val1 = load double, double* %ptr1
  %val2 = load double, double* %ptr2
  %val3 = load double, double* %ptr3
  %res0 = insertelement <4 x double> undef, double %val0, i32 0
  %res1 = insertelement <4 x double> %res0, double %val1, i32 1
  %res2 = insertelement <4 x double> %res1, double %val2, i32 2
  %res3 = insertelement <4 x double> %res2, double %val3, i32 3
  ret <4 x double> %res3
}

define <4 x double> @merge_4f64_f64_3zuu(double* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4f64_f64_3zuu:
; AVX:       # BB#0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4f64_f64_3zuu:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds double, double* %ptr, i64 3
  %val0 = load double, double* %ptr0
  %res0 = insertelement <4 x double> undef, double %val0, i32 0
  %res1 = insertelement <4 x double> %res0, double 0.0, i32 1
  ret <4 x double> %res1
}

define <4 x double> @merge_4f64_f64_34uu(double* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4f64_f64_34uu:
; AVX:       # BB#0:
; AVX-NEXT:    vmovups 24(%rdi), %xmm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4f64_f64_34uu:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovups 24(%eax), %xmm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds double, double* %ptr, i64 3
  %ptr1 = getelementptr inbounds double, double* %ptr, i64 4
  %val0 = load double, double* %ptr0
  %val1 = load double, double* %ptr1
  %res0 = insertelement <4 x double> undef, double %val0, i32 0
  %res1 = insertelement <4 x double> %res0, double %val1, i32 1
  ret <4 x double> %res1
}

define <4 x double> @merge_4f64_f64_45zz(double* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4f64_f64_45zz:
; AVX:       # BB#0:
; AVX-NEXT:    vmovups 32(%rdi), %xmm0
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4f64_f64_45zz:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovups 32(%eax), %xmm0
; X32-AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X32-AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds double, double* %ptr, i64 4
  %ptr1 = getelementptr inbounds double, double* %ptr, i64 5
  %val0 = load double, double* %ptr0
  %val1 = load double, double* %ptr1
  %res0 = insertelement <4 x double> zeroinitializer, double %val0, i32 0
  %res1 = insertelement <4 x double> %res0, double %val1, i32 1
  ret <4 x double> %res1
}

define <4 x double> @merge_4f64_f64_34z6(double* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4f64_f64_34z6:
; AVX:       # BB#0:
; AVX-NEXT:    vxorpd %ymm0, %ymm0, %ymm0
; AVX-NEXT:    vblendpd {{.*#+}} ymm0 = mem[0,1],ymm0[2],mem[3]
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4f64_f64_34z6:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vxorpd %ymm0, %ymm0, %ymm0
; X32-AVX-NEXT:    vblendpd {{.*#+}} ymm0 = mem[0,1],ymm0[2],mem[3]
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds double, double* %ptr, i64 3
  %ptr1 = getelementptr inbounds double, double* %ptr, i64 4
  %ptr3 = getelementptr inbounds double, double* %ptr, i64 6
  %val0 = load double, double* %ptr0
  %val1 = load double, double* %ptr1
  %val3 = load double, double* %ptr3
  %res0 = insertelement <4 x double> undef, double %val0, i32 0
  %res1 = insertelement <4 x double> %res0, double %val1, i32 1
  %res2 = insertelement <4 x double> %res1, double   0.0, i32 2
  %res3 = insertelement <4 x double> %res2, double %val3, i32 3
  ret <4 x double> %res3
}

define <4 x i64> @merge_4i64_2i64_3z(<2 x i64>* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4i64_2i64_3z:
; AVX:       # BB#0:
; AVX-NEXT:    vmovaps 48(%rdi), %xmm0
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4i64_2i64_3z:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovaps 48(%eax), %xmm0
; X32-AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X32-AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds <2 x i64>, <2 x i64>* %ptr, i64 3
  %val0 = load <2 x i64>, <2 x i64>* %ptr0
  %res = shufflevector <2 x i64> %val0, <2 x i64> zeroinitializer, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  ret <4 x i64> %res
}

define <4 x i64> @merge_4i64_i64_1234(i64* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4i64_i64_1234:
; AVX:       # BB#0:
; AVX-NEXT:    vmovups 8(%rdi), %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4i64_i64_1234:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovups 8(%eax), %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i64, i64* %ptr, i64 1
  %ptr1 = getelementptr inbounds i64, i64* %ptr, i64 2
  %ptr2 = getelementptr inbounds i64, i64* %ptr, i64 3
  %ptr3 = getelementptr inbounds i64, i64* %ptr, i64 4
  %val0 = load i64, i64* %ptr0
  %val1 = load i64, i64* %ptr1
  %val2 = load i64, i64* %ptr2
  %val3 = load i64, i64* %ptr3
  %res0 = insertelement <4 x i64> undef, i64 %val0, i32 0
  %res1 = insertelement <4 x i64> %res0, i64 %val1, i32 1
  %res2 = insertelement <4 x i64> %res1, i64 %val2, i32 2
  %res3 = insertelement <4 x i64> %res2, i64 %val3, i32 3
  ret <4 x i64> %res3
}

define <4 x i64> @merge_4i64_i64_1zzu(i64* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4i64_i64_1zzu:
; AVX:       # BB#0:
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4i64_i64_1zzu:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i64, i64* %ptr, i64 1
  %val0 = load i64, i64* %ptr0
  %res0 = insertelement <4 x i64> undef, i64 %val0, i32 0
  %res1 = insertelement <4 x i64> %res0, i64 0, i32 1
  %res2 = insertelement <4 x i64> %res1, i64 0, i32 1
  ret <4 x i64> %res2
}

define <4 x i64> @merge_4i64_i64_23zz(i64* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_4i64_i64_23zz:
; AVX:       # BB#0:
; AVX-NEXT:    vmovups 16(%rdi), %xmm0
; AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_4i64_i64_23zz:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovups 16(%eax), %xmm0
; X32-AVX-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; X32-AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i64, i64* %ptr, i64 2
  %ptr1 = getelementptr inbounds i64, i64* %ptr, i64 3
  %val0 = load i64, i64* %ptr0
  %val1 = load i64, i64* %ptr1
  %res0 = insertelement <4 x i64> zeroinitializer, i64 %val0, i32 0
  %res1 = insertelement <4 x i64> %res0, i64 %val1, i32 1
  ret <4 x i64> %res1
}

define <8 x float> @merge_8f32_2f32_23z5(<2 x float>* %ptr) nounwind uwtable noinline ssp {
; AVX1-LABEL: merge_8f32_2f32_23z5:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovupd 16(%rdi), %xmm0
; AVX1-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: merge_8f32_2f32_23z5:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovupd 16(%rdi), %xmm0
; AVX2-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; AVX2-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: merge_8f32_2f32_23z5:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovups 16(%rdi), %xmm0
; AVX512F-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX512F-NEXT:    vmovhpd {{.*#+}} xmm1 = xmm1[0],mem[0]
; AVX512F-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; X32-AVX-LABEL: merge_8f32_2f32_23z5:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vxorpd %ymm0, %ymm0, %ymm0
; X32-AVX-NEXT:    vblendpd {{.*#+}} ymm0 = mem[0,1],ymm0[2],mem[3]
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds <2 x float>, <2 x float>* %ptr, i64 2
  %ptr1 = getelementptr inbounds <2 x float>, <2 x float>* %ptr, i64 3
  %ptr3 = getelementptr inbounds <2 x float>, <2 x float>* %ptr, i64 5
  %val0 = load <2 x float>, <2 x float>* %ptr0
  %val1 = load <2 x float>, <2 x float>* %ptr1
  %val3 = load <2 x float>, <2 x float>* %ptr3
  %res01 = shufflevector <2 x float> %val0, <2 x float> %val1, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %res23 = shufflevector <2 x float> zeroinitializer, <2 x float> %val3, <4 x i32> <i32 0, i32 1, i32 2, i32 3>
  %res = shufflevector <4 x float> %res01, <4 x float> %res23, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x float> %res
}

define <8 x float> @merge_8f32_4f32_z2(<4 x float>* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_8f32_4f32_z2:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, 32(%rdi), %ymm0, %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_8f32_4f32_z2:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-AVX-NEXT:    vinsertf128 $1, 32(%eax), %ymm0, %ymm0
; X32-AVX-NEXT:    retl
  %ptr1 = getelementptr inbounds <4 x float>, <4 x float>* %ptr, i64 2
  %val1 = load <4 x float>, <4 x float>* %ptr1
  %res = shufflevector <4 x float> zeroinitializer, <4 x float> %val1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x float> %res
}

define <8 x float> @merge_8f32_f32_12zzuuzz(float* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_8f32_f32_12zzuuzz:
; AVX:       # BB#0:
; AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_8f32_f32_12zzuuzz:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds float, float* %ptr, i64 1
  %ptr1 = getelementptr inbounds float, float* %ptr, i64 2
  %val0 = load float, float* %ptr0
  %val1 = load float, float* %ptr1
  %res0 = insertelement <8 x float> undef, float %val0, i32 0
  %res1 = insertelement <8 x float> %res0, float %val1, i32 1
  %res2 = insertelement <8 x float> %res1, float   0.0, i32 2
  %res3 = insertelement <8 x float> %res2, float   0.0, i32 3
  %res6 = insertelement <8 x float> %res3, float   0.0, i32 6
  %res7 = insertelement <8 x float> %res6, float   0.0, i32 7
  ret <8 x float> %res7
}

define <8 x float> @merge_8f32_f32_1u3u5zu8(float* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_8f32_f32_1u3u5zu8:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %ymm0, %ymm0, %ymm0
; AVX-NEXT:    vblendps {{.*#+}} ymm0 = mem[0,1,2,3,4],ymm0[5],mem[6,7]
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_8f32_f32_1u3u5zu8:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vxorps %ymm0, %ymm0, %ymm0
; X32-AVX-NEXT:    vblendps {{.*#+}} ymm0 = mem[0,1,2,3,4],ymm0[5],mem[6,7]
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds float, float* %ptr, i64 1
  %ptr2 = getelementptr inbounds float, float* %ptr, i64 3
  %ptr4 = getelementptr inbounds float, float* %ptr, i64 5
  %ptr7 = getelementptr inbounds float, float* %ptr, i64 8
  %val0 = load float, float* %ptr0
  %val2 = load float, float* %ptr2
  %val4 = load float, float* %ptr4
  %val7 = load float, float* %ptr7
  %res0 = insertelement <8 x float> undef, float %val0, i32 0
  %res2 = insertelement <8 x float> %res0, float %val2, i32 2
  %res4 = insertelement <8 x float> %res2, float %val4, i32 4
  %res5 = insertelement <8 x float> %res4, float   0.0, i32 5
  %res7 = insertelement <8 x float> %res5, float %val7, i32 7
  ret <8 x float> %res7
}

define <8 x i32> @merge_8i32_4i32_z3(<4 x i32>* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_8i32_4i32_z3:
; AVX:       # BB#0:
; AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vinsertf128 $1, 48(%rdi), %ymm0, %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_8i32_4i32_z3:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; X32-AVX-NEXT:    vinsertf128 $1, 48(%eax), %ymm0, %ymm0
; X32-AVX-NEXT:    retl
  %ptr1 = getelementptr inbounds <4 x i32>, <4 x i32>* %ptr, i64 3
  %val1 = load <4 x i32>, <4 x i32>* %ptr1
  %res = shufflevector <4 x i32> zeroinitializer, <4 x i32> %val1, <8 x i32> <i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7>
  ret <8 x i32> %res
}

define <8 x i32> @merge_8i32_i32_56zz9uzz(i32* %ptr) nounwind uwtable noinline ssp {
; AVX1-LABEL: merge_8i32_i32_56zz9uzz:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX1-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: merge_8i32_i32_56zz9uzz:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: merge_8i32_i32_56zz9uzz:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX512F-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX512F-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; X32-AVX-LABEL: merge_8i32_i32_56zz9uzz:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; X32-AVX-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X32-AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i32, i32* %ptr, i64 5
  %ptr1 = getelementptr inbounds i32, i32* %ptr, i64 6
  %ptr4 = getelementptr inbounds i32, i32* %ptr, i64 9
  %val0 = load i32, i32* %ptr0
  %val1 = load i32, i32* %ptr1
  %val4 = load i32, i32* %ptr4
  %res0 = insertelement <8 x i32> undef, i32 %val0, i32 0
  %res1 = insertelement <8 x i32> %res0, i32 %val1, i32 1
  %res2 = insertelement <8 x i32> %res1, i32     0, i32 2
  %res3 = insertelement <8 x i32> %res2, i32     0, i32 3
  %res4 = insertelement <8 x i32> %res3, i32 %val4, i32 4
  %res6 = insertelement <8 x i32> %res4, i32     0, i32 6
  %res7 = insertelement <8 x i32> %res6, i32     0, i32 7
  ret <8 x i32> %res7
}

define <8 x i32> @merge_8i32_i32_1u3u5zu8(i32* %ptr) nounwind uwtable noinline ssp {
; AVX1-LABEL: merge_8i32_i32_1u3u5zu8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vxorps %ymm0, %ymm0, %ymm0
; AVX1-NEXT:    vblendps {{.*#+}} ymm0 = mem[0,1,2,3,4],ymm0[5],mem[6,7]
; AVX1-NEXT:    retq
;
; AVX2-LABEL: merge_8i32_i32_1u3u5zu8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpxor %ymm0, %ymm0, %ymm0
; AVX2-NEXT:    vpblendd {{.*#+}} ymm0 = mem[0,1,2,3,4],ymm0[5],mem[6,7]
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: merge_8i32_i32_1u3u5zu8:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpxor %ymm0, %ymm0, %ymm0
; AVX512F-NEXT:    vpblendd {{.*#+}} ymm0 = mem[0,1,2,3,4],ymm0[5],mem[6,7]
; AVX512F-NEXT:    retq
;
; X32-AVX-LABEL: merge_8i32_i32_1u3u5zu8:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vxorps %ymm0, %ymm0, %ymm0
; X32-AVX-NEXT:    vblendps {{.*#+}} ymm0 = mem[0,1,2,3,4],ymm0[5],mem[6,7]
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i32, i32* %ptr, i64 1
  %ptr2 = getelementptr inbounds i32, i32* %ptr, i64 3
  %ptr4 = getelementptr inbounds i32, i32* %ptr, i64 5
  %ptr7 = getelementptr inbounds i32, i32* %ptr, i64 8
  %val0 = load i32, i32* %ptr0
  %val2 = load i32, i32* %ptr2
  %val4 = load i32, i32* %ptr4
  %val7 = load i32, i32* %ptr7
  %res0 = insertelement <8 x i32> undef, i32 %val0, i32 0
  %res2 = insertelement <8 x i32> %res0, i32 %val2, i32 2
  %res4 = insertelement <8 x i32> %res2, i32 %val4, i32 4
  %res5 = insertelement <8 x i32> %res4, i32     0, i32 5
  %res7 = insertelement <8 x i32> %res5, i32 %val7, i32 7
  ret <8 x i32> %res7
}

define <16 x i16> @merge_16i16_i16_89zzzuuuuuuuuuuuz(i16* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_16i16_i16_89zzzuuuuuuuuuuuz:
; AVX:       # BB#0:
; AVX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_16i16_i16_89zzzuuuuuuuuuuuz:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i16, i16* %ptr, i64 8
  %ptr1 = getelementptr inbounds i16, i16* %ptr, i64 9
  %val0 = load i16, i16* %ptr0
  %val1 = load i16, i16* %ptr1
  %res0 = insertelement <16 x i16> undef, i16 %val0, i16 0
  %res1 = insertelement <16 x i16> %res0, i16 %val1, i16 1
  %res2 = insertelement <16 x i16> %res1, i16     0, i16 2
  %res3 = insertelement <16 x i16> %res2, i16     0, i16 3
  %res4 = insertelement <16 x i16> %res3, i16     0, i16 4
  %resF = insertelement <16 x i16> %res4, i16     0, i16 15
  ret <16 x i16> %resF
}

define <16 x i16> @merge_16i16_i16_45u7uuuuuuuuuuuu(i16* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_16i16_i16_45u7uuuuuuuuuuuu:
; AVX:       # BB#0:
; AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_16i16_i16_45u7uuuuuuuuuuuu:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovq {{.*#+}} xmm0 = mem[0],zero
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i16, i16* %ptr, i64 4
  %ptr1 = getelementptr inbounds i16, i16* %ptr, i64 5
  %ptr3 = getelementptr inbounds i16, i16* %ptr, i64 7
  %val0 = load i16, i16* %ptr0
  %val1 = load i16, i16* %ptr1
  %val3 = load i16, i16* %ptr3
  %res0 = insertelement <16 x i16> undef, i16 %val0, i16 0
  %res1 = insertelement <16 x i16> %res0, i16 %val1, i16 1
  %res3 = insertelement <16 x i16> %res1, i16 %val3, i16 3
  ret <16 x i16> %res3
}

define <16 x i16> @merge_16i16_i16_0uu3uuuuuuuuCuEF(i16* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_16i16_i16_0uu3uuuuuuuuCuEF:
; AVX:       # BB#0:
; AVX-NEXT:    vmovups (%rdi), %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_16i16_i16_0uu3uuuuuuuuCuEF:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovups (%eax), %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i16, i16* %ptr, i64 0
  %ptr3 = getelementptr inbounds i16, i16* %ptr, i64 3
  %ptrC = getelementptr inbounds i16, i16* %ptr, i64 12
  %ptrE = getelementptr inbounds i16, i16* %ptr, i64 14
  %ptrF = getelementptr inbounds i16, i16* %ptr, i64 15
  %val0 = load i16, i16* %ptr0
  %val3 = load i16, i16* %ptr3
  %valC = load i16, i16* %ptrC
  %valE = load i16, i16* %ptrE
  %valF = load i16, i16* %ptrF
  %res0 = insertelement <16 x i16> undef, i16 %val0, i16 0
  %res3 = insertelement <16 x i16> %res0, i16 %val3, i16 3
  %resC = insertelement <16 x i16> %res3, i16 %valC, i16 12
  %resE = insertelement <16 x i16> %resC, i16 %valE, i16 14
  %resF = insertelement <16 x i16> %resE, i16 %valF, i16 15
  ret <16 x i16> %resF
}

define <16 x i16> @merge_16i16_i16_0uu3zzuuuuuzCuEF(i16* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_16i16_i16_0uu3zzuuuuuzCuEF:
; AVX:       # BB#0:
; AVX-NEXT:    vmovups (%rdi), %ymm0
; AVX-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_16i16_i16_0uu3zzuuuuuzCuEF:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovups (%eax), %ymm0
; X32-AVX-NEXT:    vandps {{\.LCPI.*}}, %ymm0, %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i16, i16* %ptr, i64 0
  %ptr3 = getelementptr inbounds i16, i16* %ptr, i64 3
  %ptrC = getelementptr inbounds i16, i16* %ptr, i64 12
  %ptrE = getelementptr inbounds i16, i16* %ptr, i64 14
  %ptrF = getelementptr inbounds i16, i16* %ptr, i64 15
  %val0 = load i16, i16* %ptr0
  %val3 = load i16, i16* %ptr3
  %valC = load i16, i16* %ptrC
  %valE = load i16, i16* %ptrE
  %valF = load i16, i16* %ptrF
  %res0 = insertelement <16 x i16> undef, i16 %val0, i16 0
  %res3 = insertelement <16 x i16> %res0, i16 %val3, i16 3
  %res4 = insertelement <16 x i16> %res3, i16     0, i16 4
  %res5 = insertelement <16 x i16> %res4, i16     0, i16 5
  %resC = insertelement <16 x i16> %res5, i16 %valC, i16 12
  %resD = insertelement <16 x i16> %resC, i16     0, i16 13
  %resE = insertelement <16 x i16> %resD, i16 %valE, i16 14
  %resF = insertelement <16 x i16> %resE, i16 %valF, i16 15
  ret <16 x i16> %resF
}

define <32 x i8> @merge_32i8_i8_45u7uuuuuuuuuuuuuuuuuuuuuuuuuuuu(i8* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_32i8_i8_45u7uuuuuuuuuuuuuuuuuuuuuuuuuuuu:
; AVX:       # BB#0:
; AVX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_32i8_i8_45u7uuuuuuuuuuuuuuuuuuuuuuuuuuuu:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i8, i8* %ptr, i64 4
  %ptr1 = getelementptr inbounds i8, i8* %ptr, i64 5
  %ptr3 = getelementptr inbounds i8, i8* %ptr, i64 7
  %val0 = load i8, i8* %ptr0
  %val1 = load i8, i8* %ptr1
  %val3 = load i8, i8* %ptr3
  %res0 = insertelement <32 x i8> undef, i8 %val0, i8 0
  %res1 = insertelement <32 x i8> %res0, i8 %val1, i8 1
  %res3 = insertelement <32 x i8> %res1, i8 %val3, i8 3
  ret <32 x i8> %res3
}

define <32 x i8> @merge_32i8_i8_23u5uuuuuuuuuuzzzzuuuuuuuuuuuuuu(i8* %ptr) nounwind uwtable noinline ssp {
; AVX-LABEL: merge_32i8_i8_23u5uuuuuuuuuuzzzzuuuuuuuuuuuuuu:
; AVX:       # BB#0:
; AVX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; AVX-NEXT:    retq
;
; X32-AVX-LABEL: merge_32i8_i8_23u5uuuuuuuuuuzzzzuuuuuuuuuuuuuu:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovd {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i8, i8* %ptr, i64 2
  %ptr1 = getelementptr inbounds i8, i8* %ptr, i64 3
  %ptr3 = getelementptr inbounds i8, i8* %ptr, i64 5
  %val0 = load i8, i8* %ptr0
  %val1 = load i8, i8* %ptr1
  %val3 = load i8, i8* %ptr3
  %res0 = insertelement <32 x i8> undef, i8 %val0, i8 0
  %res1 = insertelement <32 x i8> %res0, i8 %val1, i8 1
  %res3 = insertelement <32 x i8> %res1, i8 %val3, i8 3
  %resE = insertelement <32 x i8> %res3, i8     0, i8 14
  %resF = insertelement <32 x i8> %resE, i8     0, i8 15
  %resG = insertelement <32 x i8> %resF, i8     0, i8 16
  %resH = insertelement <32 x i8> %resG, i8     0, i8 17
  ret <32 x i8> %resH
}

;
; consecutive loads including any/all volatiles may not be combined
;

define <4 x double> @merge_4f64_f64_34uz_volatile(double* %ptr) nounwind uwtable noinline ssp {
; AVX1-LABEL: merge_4f64_f64_34uz_volatile:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX1-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; AVX1-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: merge_4f64_f64_34uz_volatile:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX2-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; AVX2-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; AVX2-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: merge_4f64_f64_34uz_volatile:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; AVX512F-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; AVX512F-NEXT:    vxorps %xmm1, %xmm1, %xmm1
; AVX512F-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; AVX512F-NEXT:    retq
;
; X32-AVX-LABEL: merge_4f64_f64_34uz_volatile:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vmovsd {{.*#+}} xmm0 = mem[0],zero
; X32-AVX-NEXT:    vmovhpd {{.*#+}} xmm0 = xmm0[0],mem[0]
; X32-AVX-NEXT:    vxorpd %xmm1, %xmm1, %xmm1
; X32-AVX-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds double, double* %ptr, i64 3
  %ptr1 = getelementptr inbounds double, double* %ptr, i64 4
  %val0 = load volatile double, double* %ptr0
  %val1 = load volatile double, double* %ptr1
  %res0 = insertelement <4 x double> undef, double %val0, i32 0
  %res1 = insertelement <4 x double> %res0, double %val1, i32 1
  %res3 = insertelement <4 x double> %res1, double   0.0, i32 3
  ret <4 x double> %res3
}

define <16 x i16> @merge_16i16_i16_0uu3zzuuuuuzCuEF_volatile(i16* %ptr) nounwind uwtable noinline ssp {
; AVX1-LABEL: merge_16i16_i16_0uu3zzuuuuuzCuEF_volatile:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX1-NEXT:    vpinsrw $0, (%rdi), %xmm0, %xmm1
; AVX1-NEXT:    vpinsrw $3, 6(%rdi), %xmm1, %xmm1
; AVX1-NEXT:    vpinsrw $4, 24(%rdi), %xmm0, %xmm0
; AVX1-NEXT:    vpinsrw $6, 28(%rdi), %xmm0, %xmm0
; AVX1-NEXT:    vpinsrw $7, 30(%rdi), %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: merge_16i16_i16_0uu3zzuuuuuzCuEF_volatile:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    vpinsrw $0, (%rdi), %xmm0, %xmm1
; AVX2-NEXT:    vpinsrw $3, 6(%rdi), %xmm1, %xmm1
; AVX2-NEXT:    vpinsrw $4, 24(%rdi), %xmm0, %xmm0
; AVX2-NEXT:    vpinsrw $6, 28(%rdi), %xmm0, %xmm0
; AVX2-NEXT:    vpinsrw $7, 30(%rdi), %xmm0, %xmm0
; AVX2-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: merge_16i16_i16_0uu3zzuuuuuzCuEF_volatile:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; AVX512F-NEXT:    vpinsrw $0, (%rdi), %xmm0, %xmm1
; AVX512F-NEXT:    vpinsrw $3, 6(%rdi), %xmm1, %xmm1
; AVX512F-NEXT:    vpinsrw $4, 24(%rdi), %xmm0, %xmm0
; AVX512F-NEXT:    vpinsrw $6, 28(%rdi), %xmm0, %xmm0
; AVX512F-NEXT:    vpinsrw $7, 30(%rdi), %xmm0, %xmm0
; AVX512F-NEXT:    vinserti128 $1, %xmm0, %ymm1, %ymm0
; AVX512F-NEXT:    retq
;
; X32-AVX-LABEL: merge_16i16_i16_0uu3zzuuuuuzCuEF_volatile:
; X32-AVX:       # BB#0:
; X32-AVX-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-AVX-NEXT:    vpxor %xmm0, %xmm0, %xmm0
; X32-AVX-NEXT:    vpinsrw $0, (%eax), %xmm0, %xmm1
; X32-AVX-NEXT:    vpinsrw $3, 6(%eax), %xmm1, %xmm1
; X32-AVX-NEXT:    vpinsrw $4, 24(%eax), %xmm0, %xmm0
; X32-AVX-NEXT:    vpinsrw $6, 28(%eax), %xmm0, %xmm0
; X32-AVX-NEXT:    vpinsrw $7, 30(%eax), %xmm0, %xmm0
; X32-AVX-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; X32-AVX-NEXT:    retl
  %ptr0 = getelementptr inbounds i16, i16* %ptr, i64 0
  %ptr3 = getelementptr inbounds i16, i16* %ptr, i64 3
  %ptrC = getelementptr inbounds i16, i16* %ptr, i64 12
  %ptrE = getelementptr inbounds i16, i16* %ptr, i64 14
  %ptrF = getelementptr inbounds i16, i16* %ptr, i64 15
  %val0 = load volatile i16, i16* %ptr0
  %val3 = load i16, i16* %ptr3
  %valC = load i16, i16* %ptrC
  %valE = load i16, i16* %ptrE
  %valF = load volatile i16, i16* %ptrF
  %res0 = insertelement <16 x i16> undef, i16 %val0, i16 0
  %res3 = insertelement <16 x i16> %res0, i16 %val3, i16 3
  %res4 = insertelement <16 x i16> %res3, i16     0, i16 4
  %res5 = insertelement <16 x i16> %res4, i16     0, i16 5
  %resC = insertelement <16 x i16> %res5, i16 %valC, i16 12
  %resD = insertelement <16 x i16> %resC, i16     0, i16 13
  %resE = insertelement <16 x i16> %resD, i16 %valE, i16 14
  %resF = insertelement <16 x i16> %resE, i16 %valF, i16 15
  ret <16 x i16> %resF
}
