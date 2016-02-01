; RUN: opt -instcombine -S < %s | FileCheck %s

declare <2 x double> @llvm.masked.load.v2f64(<2 x double>* %ptrs, i32, <2 x i1> %mask, <2 x double> %src0)


define <2 x double> @load_zeromask(<2 x double>* %ptr, <2 x double> %passthru)  {
  %res = call <2 x double> @llvm.masked.load.v2f64(<2 x double>* %ptr, i32 1, <2 x i1> zeroinitializer, <2 x double> %passthru)
  ret <2 x double> %res

; CHECK-LABEL: @load_zeromask(
; CHECK-NEXT   ret <2 x double> %passthru
}

define <2 x double> @load_onemask(<2 x double>* %ptr, <2 x double> %passthru)  {
  %res = call <2 x double> @llvm.masked.load.v2f64(<2 x double>* %ptr, i32 2, <2 x i1> <i1 1, i1 1>, <2 x double> %passthru)
  ret <2 x double> %res

; CHECK-LABEL: @load_onemask(
; CHECK-NEXT:  %unmaskedload = load <2 x double>, <2 x double>* %ptr, align 2
; CHECK-NEXT   ret <2 x double> %res
}

