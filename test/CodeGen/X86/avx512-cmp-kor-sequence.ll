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
; CHECK-NEXT:    kmovw %k0, %ecx
; CHECK-NEXT:    vcmpgeps %zmm4, %zmm1, %k0
; CHECK-NEXT:    kmovw %k0, %edx
; CHECK-NEXT:    vcmpgeps %zmm4, %zmm2, %k0
; CHECK-NEXT:    kmovw %k0, %esi
; CHECK-NEXT:    vcmpgeps %zmm4, %zmm3, %k0
; CHECK-NEXT:    kmovw %k0, %eax
; CHECK-NEXT:    orl %ecx, %edx
; CHECK-NEXT:    orl %esi, %eax
; CHECK-NEXT:    orl %edx, %eax
; CHECK-NEXT:    # kill: def $ax killed $ax killed $eax
; CHECK-NEXT:    retq
entry:
  %0 = tail call i16 @llvm.x86.avx512.mask.cmp.ps.512(<16 x float> %a, <16 x float> %x, i32 13, i16 -1, i32 4)
  %1 = tail call i16 @llvm.x86.avx512.mask.cmp.ps.512(<16 x float> %b, <16 x float> %x, i32 13, i16 -1, i32 4)
  %2 = tail call i16 @llvm.x86.avx512.mask.cmp.ps.512(<16 x float> %c, <16 x float> %x, i32 13, i16 -1, i32 4)
  %3 = tail call i16 @llvm.x86.avx512.mask.cmp.ps.512(<16 x float> %d, <16 x float> %x, i32 13, i16 -1, i32 4)
  %4 = tail call i16 @llvm.x86.avx512.kor.w(i16 %0, i16 %1) #2
  %5 = tail call i16 @llvm.x86.avx512.kor.w(i16 %2, i16 %3) #2
  %6 = tail call i16 @llvm.x86.avx512.kor.w(i16 %4, i16 %5) #2
  ret i16 %6
}

; Function Attrs: nounwind readnone
declare i16 @llvm.x86.avx512.mask.cmp.ps.512(<16 x float>, <16 x float>, i32, i16, i32) #1

; Function Attrs: nounwind readnone
declare i16 @llvm.x86.avx512.kor.w(i16, i16) #1

attributes #0 = { nounwind readnone uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="knl" "target-features"="+adx,+aes,+avx,+avx2,+avx512cd,+avx512er,+avx512f,+avx512pf,+bmi,+bmi2,+cx16,+f16c,+fma,+fsgsbase,+fxsr,+lzcnt,+mmx,+movbe,+pclmul,+popcnt,+prefetchwt1,+rdrnd,+rdseed,+rtm,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave,+xsaveopt" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { nounwind }
