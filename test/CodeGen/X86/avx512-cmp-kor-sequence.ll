; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s

; This test checks optimal passing values between "cmp" and "kor" intrinsics
; PR28839

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind readnone uwtable
define zeroext i16 @cmp_kor_seq_16(<16 x float> %a, <16 x float> %b, <16 x float> %c, <16 x float> %d, <16 x float> %x) local_unnamed_addr #0 {
; CHECK-LABEL: cmp_kor_seq_16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vcmpgeps %zmm4, %zmm0, %k0
; CHECK-NEXT:    vcmpgeps %zmm4, %zmm1, %k1
; CHECK-NEXT:    korw %k1, %k0, %k0
; CHECK-NEXT:    vcmpgeps %zmm4, %zmm2, %k1
; CHECK-NEXT:    vcmpgeps %zmm4, %zmm3, %k2
; CHECK-NEXT:    korw %k2, %k1, %k1
; CHECK-NEXT:    korw %k1, %k0, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    retq
entry:
  %0 = call <16 x i1> @llvm.x86.avx512.mask.cmp.ps.512(<16 x float> %a, <16 x float> %x, i32 13, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, i32 4)
  %1 = bitcast <16 x i1> %0 to i16
  %2 = call <16 x i1> @llvm.x86.avx512.mask.cmp.ps.512(<16 x float> %b, <16 x float> %x, i32 13, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, i32 4)
  %3 = bitcast <16 x i1> %2 to i16
  %4 = call <16 x i1> @llvm.x86.avx512.mask.cmp.ps.512(<16 x float> %c, <16 x float> %x, i32 13, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, i32 4)
  %5 = bitcast <16 x i1> %4 to i16
  %6 = call <16 x i1> @llvm.x86.avx512.mask.cmp.ps.512(<16 x float> %d, <16 x float> %x, i32 13, <16 x i1> <i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true, i1 true>, i32 4)
  %7 = bitcast <16 x i1> %6 to i16
  %8 = bitcast i16 %1 to <16 x i1>
  %9 = bitcast i16 %3 to <16 x i1>
  %10 = or <16 x i1> %8, %9
  %11 = bitcast <16 x i1> %10 to i16
  %12 = bitcast i16 %5 to <16 x i1>
  %13 = bitcast i16 %7 to <16 x i1>
  %14 = or <16 x i1> %12, %13
  %15 = bitcast <16 x i1> %14 to i16
  %16 = bitcast i16 %11 to <16 x i1>
  %17 = bitcast i16 %15 to <16 x i1>
  %18 = or <16 x i1> %16, %17
  %19 = bitcast <16 x i1> %18 to i16
  ret i16 %19
}

; Function Attrs: nounwind readnone
declare <16 x i1> @llvm.x86.avx512.mask.cmp.ps.512(<16 x float>, <16 x float>, i32, <16 x i1>, i32) #1

attributes #0 = { nounwind readnone uwtable "disable-tail-calls"="false" "frame-pointer"="none" "stack-protector-buffer-size"="8" "target-cpu"="knl" "target-features"="+adx,+aes,+avx,+avx2,+avx512cd,+avx512er,+avx512f,+avx512pf,+bmi,+bmi2,+cx16,+f16c,+fma,+fsgsbase,+fxsr,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prefetchwt1,+rdrnd,+rdseed,+rtm,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
