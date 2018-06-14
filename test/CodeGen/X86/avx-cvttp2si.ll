; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx              | FileCheck %s --check-prefixes=AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-- -mattr=avx512f,avx512vl | FileCheck %s --check-prefixes=AVX,AVX512

; PR37751 - https://bugs.llvm.org/show_bug.cgi?id=37751
; We can't combine into 'round' instructions because the behavior is different for out-of-range values.

declare <8 x i32> @llvm.x86.avx.cvtt.ps2dq.256(<8 x float>)
declare <4 x i32> @llvm.x86.avx.cvtt.pd2dq.256(<4 x double>)

define <8 x float> @float_to_int_to_float_mem_v8f32(<8 x float>* %p) {
; AVX-LABEL: float_to_int_to_float_mem_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvttps2dq (%rdi), %ymm0
; AVX-NEXT:    vcvtdq2ps %ymm0, %ymm0
; AVX-NEXT:    retq
  %x = load <8 x float>, <8 x float>* %p, align 16
  %fptosi = tail call <8 x i32> @llvm.x86.avx.cvtt.ps2dq.256(<8 x float> %x)
  %sitofp = sitofp <8 x i32> %fptosi to <8 x float>
  ret <8 x float> %sitofp
}

define <8 x float> @float_to_int_to_float_reg_v8f32(<8 x float> %x) {
; AVX-LABEL: float_to_int_to_float_reg_v8f32:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvttps2dq %ymm0, %ymm0
; AVX-NEXT:    vcvtdq2ps %ymm0, %ymm0
; AVX-NEXT:    retq
  %fptosi = tail call <8 x i32> @llvm.x86.avx.cvtt.ps2dq.256(<8 x float> %x)
  %sitofp = sitofp <8 x i32> %fptosi to <8 x float>
  ret <8 x float> %sitofp
}

define <4 x double> @float_to_int_to_float_mem_v4f64(<4 x double>* %p) {
; AVX-LABEL: float_to_int_to_float_mem_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvttpd2dqy (%rdi), %xmm0
; AVX-NEXT:    vcvtdq2pd %xmm0, %ymm0
; AVX-NEXT:    retq
  %x = load <4 x double>, <4 x double>* %p, align 16
  %fptosi = tail call <4 x i32> @llvm.x86.avx.cvtt.pd2dq.256(<4 x double> %x)
  %sitofp = sitofp <4 x i32> %fptosi to <4 x double>
  ret <4 x double> %sitofp
}

define <4 x double> @float_to_int_to_float_reg_v4f64(<4 x double> %x) {
; AVX-LABEL: float_to_int_to_float_reg_v4f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vcvttpd2dq %ymm0, %xmm0
; AVX-NEXT:    vcvtdq2pd %xmm0, %ymm0
; AVX-NEXT:    retq
  %fptosi = tail call <4 x i32> @llvm.x86.avx.cvtt.pd2dq.256(<4 x double> %x)
  %sitofp = sitofp <4 x i32> %fptosi to <4 x double>
  ret <4 x double> %sitofp
}

