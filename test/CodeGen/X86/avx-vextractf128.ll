; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx | FileCheck %s

define <8 x float> @A(<8 x float> %a) nounwind uwtable readnone ssp {
; CHECK-LABEL: A:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm0
; CHECK-NEXT:    retq
entry:
  %shuffle = shufflevector <8 x float> %a, <8 x float> undef, <8 x i32> <i32 4, i32 5, i32 6, i32 7, i32 8, i32 8, i32 8, i32 8>
  ret <8 x float> %shuffle
}

define <4 x double> @B(<4 x double> %a) nounwind uwtable readnone ssp {
; CHECK-LABEL: B:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vextractf128 $1, %ymm0, %xmm0
; CHECK-NEXT:    retq
entry:
  %shuffle = shufflevector <4 x double> %a, <4 x double> undef, <4 x i32> <i32 2, i32 3, i32 4, i32 4>
  ret <4 x double> %shuffle
}

define void @t0(ptr nocapture %addr, <8 x float> %a) nounwind uwtable ssp {
; CHECK-LABEL: t0:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vextractf128 $1, %ymm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %0 = tail call <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float> %a, i8 1)
  store <4 x float> %0, ptr %addr, align 16
  ret void
}

define void @t2(ptr nocapture %addr, <4 x double> %a) nounwind uwtable ssp {
; CHECK-LABEL: t2:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vextractf128 $1, %ymm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %0 = tail call <2 x double> @llvm.x86.avx.vextractf128.pd.256(<4 x double> %a, i8 1)
  store <2 x double> %0, ptr %addr, align 16
  ret void
}

define void @t4(ptr nocapture %addr, <4 x i64> %a) nounwind uwtable ssp {
; CHECK-LABEL: t4:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vextractf128 $1, %ymm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <4 x i64> %a to <8 x i32>
  %1 = tail call <4 x i32> @llvm.x86.avx.vextractf128.si.256(<8 x i32> %0, i8 1)
  %2 = bitcast <4 x i32> %1 to <2 x i64>
  store <2 x i64> %2, ptr %addr, align 16
  ret void
}

define void @t5(ptr nocapture %addr, <8 x float> %a) nounwind uwtable ssp {
; CHECK-LABEL: t5:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vmovaps %xmm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %0 = tail call <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float> %a, i8 0)
  store <4 x float> %0, ptr %addr, align 16
  ret void
}

define void @t6(ptr nocapture %addr, <4 x double> %a) nounwind uwtable ssp {
; CHECK-LABEL: t6:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vmovaps %xmm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %0 = tail call <2 x double> @llvm.x86.avx.vextractf128.pd.256(<4 x double> %a, i8 0)
  store <2 x double> %0, ptr %addr, align 16
  ret void
}

define void @t7(ptr nocapture %addr, <4 x i64> %a) nounwind uwtable ssp {
; CHECK-LABEL: t7:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vmovaps %xmm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <4 x i64> %a to <8 x i32>
  %1 = tail call <4 x i32> @llvm.x86.avx.vextractf128.si.256(<8 x i32> %0, i8 0)
  %2 = bitcast <4 x i32> %1 to <2 x i64>
  store <2 x i64> %2, ptr %addr, align 16
  ret void
}

define void @t8(ptr nocapture %addr, <4 x i64> %a) nounwind uwtable ssp {
; CHECK-LABEL: t8:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vmovups %xmm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <4 x i64> %a to <8 x i32>
  %1 = tail call <4 x i32> @llvm.x86.avx.vextractf128.si.256(<8 x i32> %0, i8 0)
  %2 = bitcast <4 x i32> %1 to <2 x i64>
  store <2 x i64> %2, ptr %addr, align 1
  ret void
}

; PR15462
define void @t9(ptr %p) {
; CHECK-LABEL: t9:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; CHECK-NEXT:    vmovups %ymm0, (%rdi)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
 store i64 0, ptr %p
 %q = getelementptr i64, ptr %p, i64 1
 store i64 0, ptr %q
 %r = getelementptr i64, ptr %p, i64 2
 store i64 0, ptr %r
 %s = getelementptr i64, ptr %p, i64 3
 store i64 0, ptr %s
 ret void
}

declare <2 x double> @llvm.x86.avx.vextractf128.pd.256(<4 x double>, i8) nounwind readnone
declare <4 x float> @llvm.x86.avx.vextractf128.ps.256(<8 x float>, i8) nounwind readnone
declare <4 x i32> @llvm.x86.avx.vextractf128.si.256(<8 x i32>, i8) nounwind readnone
