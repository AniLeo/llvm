; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X32 --check-prefix=X32_AVX
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=X32 --check-prefix=X32_AVX512VL
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+avx512dq,+avx512vl | FileCheck %s --check-prefix=X32 --check-prefix=X32_AVX512VLDQ
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=X64 --check-prefix=X64_AVX
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=X64 --check-prefix=X64_AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512dq,+avx512vl | FileCheck %s --check-prefix=X64 --check-prefix=X64_AVX512VLDQ

; FIXME: Drop the regex pattern matching of 'nan' once we drop support for MSVC
; 2013.

define <2 x double> @fabs_v2f64(<2 x double> %p) {
; X32-LABEL: fabs_v2f64:
; X32:       # BB#0:
; X32-NEXT:    vandps {{\.LCPI.*}}, %xmm0, %xmm0
; X32-NEXT:    retl
;
; X64-LABEL: fabs_v2f64:
; X64:       # BB#0:
; X64-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; X64-NEXT:    retq
  %t = call <2 x double> @llvm.fabs.v2f64(<2 x double> %p)
  ret <2 x double> %t
}
declare <2 x double> @llvm.fabs.v2f64(<2 x double> %p)

define <4 x float> @fabs_v4f32(<4 x float> %p) {
; X32_AVX-LABEL: fabs_v4f32:
; X32_AVX:       # BB#0:
; X32_AVX-NEXT:    vandps {{\.LCPI.*}}, %xmm0, %xmm0
; X32_AVX-NEXT:    retl
;
; X32_AVX512VL-LABEL: fabs_v4f32:
; X32_AVX512VL:       # BB#0:
; X32_AVX512VL-NEXT:    vbroadcastss {{\.LCPI.*}}, %xmm1
; X32_AVX512VL-NEXT:    vandps %xmm1, %xmm0, %xmm0
; X32_AVX512VL-NEXT:    retl
;
; X32_AVX512VLDQ-LABEL: fabs_v4f32:
; X32_AVX512VLDQ:       # BB#0:
; X32_AVX512VLDQ-NEXT:    vandps {{\.LCPI.*}}{1to4}, %xmm0, %xmm0
; X32_AVX512VLDQ-NEXT:    retl
;
; X64_AVX-LABEL: fabs_v4f32:
; X64_AVX:       # BB#0:
; X64_AVX-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; X64_AVX-NEXT:    retq
;
; X64_AVX512VL-LABEL: fabs_v4f32:
; X64_AVX512VL:       # BB#0:
; X64_AVX512VL-NEXT:    vbroadcastss {{.*}}(%rip), %xmm1
; X64_AVX512VL-NEXT:    vandps %xmm1, %xmm0, %xmm0
; X64_AVX512VL-NEXT:    retq
;
; X64_AVX512VLDQ-LABEL: fabs_v4f32:
; X64_AVX512VLDQ:       # BB#0:
; X64_AVX512VLDQ-NEXT:    vandps {{.*}}(%rip){1to4}, %xmm0, %xmm0
; X64_AVX512VLDQ-NEXT:    retq
  %t = call <4 x float> @llvm.fabs.v4f32(<4 x float> %p)
  ret <4 x float> %t
}
declare <4 x float> @llvm.fabs.v4f32(<4 x float> %p)

define <4 x double> @fabs_v4f64(<4 x double> %p) {
; X32_AVX-LABEL: fabs_v4f64:
; X32_AVX:       # BB#0:
; X32_AVX-NEXT:    vandps {{\.LCPI.*}}, %ymm0, %ymm0
; X32_AVX-NEXT:    retl
;
; X32_AVX512VL-LABEL: fabs_v4f64:
; X32_AVX512VL:       # BB#0:
; X32_AVX512VL-NEXT:    vbroadcastsd {{\.LCPI.*}}, %ymm1
; X32_AVX512VL-NEXT:    vandps %ymm1, %ymm0, %ymm0
; X32_AVX512VL-NEXT:    retl
;
; X32_AVX512VLDQ-LABEL: fabs_v4f64:
; X32_AVX512VLDQ:       # BB#0:
; X32_AVX512VLDQ-NEXT:    vandpd {{\.LCPI.*}}{1to4}, %ymm0, %ymm0
; X32_AVX512VLDQ-NEXT:    retl
;
; X64_AVX-LABEL: fabs_v4f64:
; X64_AVX:       # BB#0:
; X64_AVX-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; X64_AVX-NEXT:    retq
;
; X64_AVX512VL-LABEL: fabs_v4f64:
; X64_AVX512VL:       # BB#0:
; X64_AVX512VL-NEXT:    vbroadcastsd {{.*}}(%rip), %ymm1
; X64_AVX512VL-NEXT:    vandps %ymm1, %ymm0, %ymm0
; X64_AVX512VL-NEXT:    retq
;
; X64_AVX512VLDQ-LABEL: fabs_v4f64:
; X64_AVX512VLDQ:       # BB#0:
; X64_AVX512VLDQ-NEXT:    vandpd {{.*}}(%rip){1to4}, %ymm0, %ymm0
; X64_AVX512VLDQ-NEXT:    retq
  %t = call <4 x double> @llvm.fabs.v4f64(<4 x double> %p)
  ret <4 x double> %t
}
declare <4 x double> @llvm.fabs.v4f64(<4 x double> %p)

define <8 x float> @fabs_v8f32(<8 x float> %p) {
; X32_AVX-LABEL: fabs_v8f32:
; X32_AVX:       # BB#0:
; X32_AVX-NEXT:    vandps {{\.LCPI.*}}, %ymm0, %ymm0
; X32_AVX-NEXT:    retl
;
; X32_AVX512VL-LABEL: fabs_v8f32:
; X32_AVX512VL:       # BB#0:
; X32_AVX512VL-NEXT:    vbroadcastss {{\.LCPI.*}}, %ymm1
; X32_AVX512VL-NEXT:    vandps %ymm1, %ymm0, %ymm0
; X32_AVX512VL-NEXT:    retl
;
; X32_AVX512VLDQ-LABEL: fabs_v8f32:
; X32_AVX512VLDQ:       # BB#0:
; X32_AVX512VLDQ-NEXT:    vandps {{\.LCPI.*}}{1to8}, %ymm0, %ymm0
; X32_AVX512VLDQ-NEXT:    retl
;
; X64_AVX-LABEL: fabs_v8f32:
; X64_AVX:       # BB#0:
; X64_AVX-NEXT:    vandps {{.*}}(%rip), %ymm0, %ymm0
; X64_AVX-NEXT:    retq
;
; X64_AVX512VL-LABEL: fabs_v8f32:
; X64_AVX512VL:       # BB#0:
; X64_AVX512VL-NEXT:    vbroadcastss {{.*}}(%rip), %ymm1
; X64_AVX512VL-NEXT:    vandps %ymm1, %ymm0, %ymm0
; X64_AVX512VL-NEXT:    retq
;
; X64_AVX512VLDQ-LABEL: fabs_v8f32:
; X64_AVX512VLDQ:       # BB#0:
; X64_AVX512VLDQ-NEXT:    vandps {{.*}}(%rip){1to8}, %ymm0, %ymm0
; X64_AVX512VLDQ-NEXT:    retq
  %t = call <8 x float> @llvm.fabs.v8f32(<8 x float> %p)
  ret <8 x float> %t
}
declare <8 x float> @llvm.fabs.v8f32(<8 x float> %p)

define <8 x double> @fabs_v8f64(<8 x double> %p) {
; X32_AVX-LABEL: fabs_v8f64:
; X32_AVX:       # BB#0:
; X32_AVX-NEXT:    vmovaps {{.*#+}} ymm2 = [{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}}]
; X32_AVX-NEXT:    vandps %ymm2, %ymm0, %ymm0
; X32_AVX-NEXT:    vandps %ymm2, %ymm1, %ymm1
; X32_AVX-NEXT:    retl
;
; X32_AVX512VL-LABEL: fabs_v8f64:
; X32_AVX512VL:       # BB#0:
; X32_AVX512VL-NEXT:    vpandq {{\.LCPI.*}}{1to8}, %zmm0, %zmm0
; X32_AVX512VL-NEXT:    retl
;
; X32_AVX512VLDQ-LABEL: fabs_v8f64:
; X32_AVX512VLDQ:       # BB#0:
; X32_AVX512VLDQ-NEXT:    vandpd {{\.LCPI.*}}{1to8}, %zmm0, %zmm0
; X32_AVX512VLDQ-NEXT:    retl
;
; X64_AVX-LABEL: fabs_v8f64:
; X64_AVX:       # BB#0:
; X64_AVX-NEXT:    vmovaps {{.*#+}} ymm2 = [{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}}]
; X64_AVX-NEXT:    vandps %ymm2, %ymm0, %ymm0
; X64_AVX-NEXT:    vandps %ymm2, %ymm1, %ymm1
; X64_AVX-NEXT:    retq
;
; X64_AVX512VL-LABEL: fabs_v8f64:
; X64_AVX512VL:       # BB#0:
; X64_AVX512VL-NEXT:    vpandq {{.*}}(%rip){1to8}, %zmm0, %zmm0
; X64_AVX512VL-NEXT:    retq
;
; X64_AVX512VLDQ-LABEL: fabs_v8f64:
; X64_AVX512VLDQ:       # BB#0:
; X64_AVX512VLDQ-NEXT:    vandpd {{.*}}(%rip){1to8}, %zmm0, %zmm0
; X64_AVX512VLDQ-NEXT:    retq
  %t = call <8 x double> @llvm.fabs.v8f64(<8 x double> %p)
  ret <8 x double> %t
}
declare <8 x double> @llvm.fabs.v8f64(<8 x double> %p)

define <16 x float> @fabs_v16f32(<16 x float> %p) {
; X32_AVX-LABEL: fabs_v16f32:
; X32_AVX:       # BB#0:
; X32_AVX-NEXT:    vmovaps {{.*#+}} ymm2 = [{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}}]
; X32_AVX-NEXT:    vandps %ymm2, %ymm0, %ymm0
; X32_AVX-NEXT:    vandps %ymm2, %ymm1, %ymm1
; X32_AVX-NEXT:    retl
;
; X32_AVX512VL-LABEL: fabs_v16f32:
; X32_AVX512VL:       # BB#0:
; X32_AVX512VL-NEXT:    vpandd {{\.LCPI.*}}{1to16}, %zmm0, %zmm0
; X32_AVX512VL-NEXT:    retl
;
; X32_AVX512VLDQ-LABEL: fabs_v16f32:
; X32_AVX512VLDQ:       # BB#0:
; X32_AVX512VLDQ-NEXT:    vandps {{\.LCPI.*}}{1to16}, %zmm0, %zmm0
; X32_AVX512VLDQ-NEXT:    retl
;
; X64_AVX-LABEL: fabs_v16f32:
; X64_AVX:       # BB#0:
; X64_AVX-NEXT:    vmovaps {{.*#+}} ymm2 = [{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}},{{(nan|1\.#QNAN0e\+00)}}]
; X64_AVX-NEXT:    vandps %ymm2, %ymm0, %ymm0
; X64_AVX-NEXT:    vandps %ymm2, %ymm1, %ymm1
; X64_AVX-NEXT:    retq
;
; X64_AVX512VL-LABEL: fabs_v16f32:
; X64_AVX512VL:       # BB#0:
; X64_AVX512VL-NEXT:    vpandd {{.*}}(%rip){1to16}, %zmm0, %zmm0
; X64_AVX512VL-NEXT:    retq
;
; X64_AVX512VLDQ-LABEL: fabs_v16f32:
; X64_AVX512VLDQ:       # BB#0:
; X64_AVX512VLDQ-NEXT:    vandps {{.*}}(%rip){1to16}, %zmm0, %zmm0
; X64_AVX512VLDQ-NEXT:    retq
  %t = call <16 x float> @llvm.fabs.v16f32(<16 x float> %p)
  ret <16 x float> %t
}
declare <16 x float> @llvm.fabs.v16f32(<16 x float> %p)

; PR20354: when generating code for a vector fabs op,
; make sure that we're only turning off the sign bit of each float value.
; No constant pool loads or vector ops are needed for the fabs of a
; bitcasted integer constant; we should just return an integer constant
; that has the sign bits turned off.
;
; So instead of something like this:
;    movabsq (constant pool load of mask for sign bits)
;    vmovq   (move from integer register to vector/fp register)
;    vandps  (mask off sign bits)
;    vmovq   (move vector/fp register back to integer return register)
;
; We should generate:
;    mov     (put constant value in return register)

define i64 @fabs_v2f32_1() {
; X32-LABEL: fabs_v2f32_1:
; X32:       # BB#0:
; X32-NEXT:    xorl %eax, %eax
; X32-NEXT:    movl $2147483647, %edx # imm = 0x7FFFFFFF
; X32-NEXT:    retl
;
; X64-LABEL: fabs_v2f32_1:
; X64:       # BB#0:
; X64-NEXT:    movabsq $9223372032559808512, %rax # imm = 0x7FFFFFFF00000000
; X64-NEXT:    retq
 %bitcast = bitcast i64 18446744069414584320 to <2 x float> ; 0xFFFF_FFFF_0000_0000
 %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %bitcast)
 %ret = bitcast <2 x float> %fabs to i64
 ret i64 %ret
}

define i64 @fabs_v2f32_2() {
; X32-LABEL: fabs_v2f32_2:
; X32:       # BB#0:
; X32-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; X32-NEXT:    xorl %edx, %edx
; X32-NEXT:    retl
;
; X64-LABEL: fabs_v2f32_2:
; X64:       # BB#0:
; X64-NEXT:    movl $2147483647, %eax # imm = 0x7FFFFFFF
; X64-NEXT:    retq
 %bitcast = bitcast i64 4294967295 to <2 x float> ; 0x0000_0000_FFFF_FFFF
 %fabs = call <2 x float> @llvm.fabs.v2f32(<2 x float> %bitcast)
 %ret = bitcast <2 x float> %fabs to i64
 ret i64 %ret
}

declare <2 x float> @llvm.fabs.v2f32(<2 x float> %p)
