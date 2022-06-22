; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-macosx -mattr=+sse4.1 | FileCheck -check-prefix=CHECK-SSE %s
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-macosx -mattr=+avx | FileCheck -check-prefix=CHECK-AVX %s
; RUN: llc < %s -disable-peephole -mtriple=x86_64-apple-macosx -mattr=+avx512f | FileCheck -check-prefix=CHECK-AVX512 %s

define float @test1(float %x) nounwind  {
; CHECK-SSE-LABEL: test1:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundss $9, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test1:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundss $9, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test1:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundss $9, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call float @floorf(float %x) nounwind readnone
  ret float %call
}

declare float @floorf(float) nounwind readnone

define double @test2(double %x) nounwind  {
; CHECK-SSE-LABEL: test2:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundsd $9, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test2:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundsd $9, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test2:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundsd $9, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call double @floor(double %x) nounwind readnone
  ret double %call
}

declare double @floor(double) nounwind readnone

define float @test3(float %x) nounwind  {
; CHECK-SSE-LABEL: test3:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundss $12, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test3:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundss $12, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test3:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundss $12, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call float @nearbyintf(float %x) nounwind readnone
  ret float %call
}

declare float @nearbyintf(float) nounwind readnone

define double @test4(double %x) nounwind  {
; CHECK-SSE-LABEL: test4:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundsd $12, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test4:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundsd $12, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test4:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundsd $12, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call double @nearbyint(double %x) nounwind readnone
  ret double %call
}

declare double @nearbyint(double) nounwind readnone

define float @test5(float %x) nounwind  {
; CHECK-SSE-LABEL: test5:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundss $10, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test5:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundss $10, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test5:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundss $10, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call float @ceilf(float %x) nounwind readnone
  ret float %call
}

declare float @ceilf(float) nounwind readnone

define double @test6(double %x) nounwind  {
; CHECK-SSE-LABEL: test6:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundsd $10, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test6:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundsd $10, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test6:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundsd $10, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call double @ceil(double %x) nounwind readnone
  ret double %call
}

declare double @ceil(double) nounwind readnone

define float @test7(float %x) nounwind  {
; CHECK-SSE-LABEL: test7:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundss $4, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test7:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundss $4, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test7:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundss $4, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call float @rintf(float %x) nounwind readnone
  ret float %call
}

declare float @rintf(float) nounwind readnone

define double @test8(double %x) nounwind  {
; CHECK-SSE-LABEL: test8:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundsd $4, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test8:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundsd $4, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test8:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundsd $4, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call double @rint(double %x) nounwind readnone
  ret double %call
}

declare double @rint(double) nounwind readnone

define float @test9(float %x) nounwind  {
; CHECK-SSE-LABEL: test9:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundss $11, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test9:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundss $11, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test9:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundss $11, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call float @truncf(float %x) nounwind readnone
  ret float %call
}

declare float @truncf(float) nounwind readnone

define double @test10(double %x) nounwind  {
; CHECK-SSE-LABEL: test10:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundsd $11, %xmm0, %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test10:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundsd $11, %xmm0, %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test10:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundsd $11, %xmm0, %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %call = tail call double @trunc(double %x) nounwind readnone
  ret double %call
}

declare double @trunc(double) nounwind readnone

define float @test11(ptr %xptr) nounwind optsize {
; CHECK-SSE-LABEL: test11:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundss $11, (%rdi), %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test11:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundss $11, (%rdi), %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test11:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundss $11, (%rdi), %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %x = load float, ptr %xptr
  %call = tail call float @truncf(float %x) nounwind readnone
  ret float %call
}

define double @test12(ptr %xptr) nounwind optsize {
; CHECK-SSE-LABEL: test12:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundsd $11, (%rdi), %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test12:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundsd $11, (%rdi), %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test12:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundsd $11, (%rdi), %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %x = load double, ptr %xptr
  %call = tail call double @trunc(double %x) nounwind readnone
  ret double %call
}

define float @test11_pgso(ptr %xptr) nounwind !prof !14 {
; CHECK-SSE-LABEL: test11_pgso:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundss $11, (%rdi), %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test11_pgso:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundss $11, (%rdi), %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test11_pgso:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundss $11, (%rdi), %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %x = load float, ptr %xptr
  %call = tail call float @truncf(float %x) nounwind readnone
  ret float %call
}

define double @test12_pgso(ptr %xptr) nounwind !prof !14 {
; CHECK-SSE-LABEL: test12_pgso:
; CHECK-SSE:       ## %bb.0:
; CHECK-SSE-NEXT:    roundsd $11, (%rdi), %xmm0
; CHECK-SSE-NEXT:    retq
;
; CHECK-AVX-LABEL: test12_pgso:
; CHECK-AVX:       ## %bb.0:
; CHECK-AVX-NEXT:    vroundsd $11, (%rdi), %xmm0, %xmm0
; CHECK-AVX-NEXT:    retq
;
; CHECK-AVX512-LABEL: test12_pgso:
; CHECK-AVX512:       ## %bb.0:
; CHECK-AVX512-NEXT:    vroundsd $11, (%rdi), %xmm0, %xmm0
; CHECK-AVX512-NEXT:    retq
  %x = load double, ptr %xptr
  %call = tail call double @trunc(double %x) nounwind readnone
  ret double %call
}

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"ProfileSummary", !1}
!1 = !{!2, !3, !4, !5, !6, !7, !8, !9}
!2 = !{!"ProfileFormat", !"InstrProf"}
!3 = !{!"TotalCount", i64 10000}
!4 = !{!"MaxCount", i64 10}
!5 = !{!"MaxInternalCount", i64 1}
!6 = !{!"MaxFunctionCount", i64 1000}
!7 = !{!"NumCounts", i64 3}
!8 = !{!"NumFunctions", i64 3}
!9 = !{!"DetailedSummary", !10}
!10 = !{!11, !12, !13}
!11 = !{i32 10000, i64 100, i32 1}
!12 = !{i32 999000, i64 100, i32 1}
!13 = !{i32 999999, i64 1, i32 2}
!14 = !{!"function_entry_count", i64 0}
