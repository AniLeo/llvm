; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mcpu=skx | FileCheck %s

define void @PR48727() {
; CHECK-LABEL: PR48727:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vcvttpd2dqy 0, %xmm0
; CHECK-NEXT:    vcvttpd2dqy 128, %xmm1
; CHECK-NEXT:    movq (%rax), %rax
; CHECK-NEXT:    vcvttpd2dqy 160, %xmm2
; CHECK-NEXT:    vinserti128 $1, %xmm2, %ymm1, %ymm1
; CHECK-NEXT:    vcvttpd2dqy (%rax), %xmm2
; CHECK-NEXT:    vinserti128 $1, %xmm2, %ymm0, %ymm0
; CHECK-NEXT:    vinserti64x4 $1, %ymm1, %zmm0, %zmm0
; CHECK-NEXT:    vpmovdw %zmm0, %ymm0
; CHECK-NEXT:    vmovdqu %ymm0, 16(%rax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %0 = load [100 x [100 x i16]]*, [100 x [100 x i16]]** undef, align 8
  %wide.load.2 = load <4 x double>, <4 x double>* null, align 16
  %1 = fptosi <4 x double> %wide.load.2 to <4 x i16>
  %2 = getelementptr inbounds [100 x [100 x i16]], [100 x [100 x i16]]* %0, i64 0, i64 0, i64 8
  %3 = bitcast i16* %2 to <4 x i16>*
  store <4 x i16> %1, <4 x i16>* %3, align 8
  %wide.load.3 = load <4 x double>, <4 x double>* undef, align 16, !invariant.load !0, !noalias !1
  %4 = fptosi <4 x double> %wide.load.3 to <4 x i16>
  %5 = getelementptr inbounds [100 x [100 x i16]], [100 x [100 x i16]]* %0, i64 0, i64 0, i64 12
  %6 = bitcast i16* %5 to <4 x i16>*
  store <4 x i16> %4, <4 x i16>* %6, align 8
  %7 = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* null, i64 0, i64 0, i64 16
  %8 = bitcast double* %7 to <4 x double>*
  %wide.load.4 = load <4 x double>, <4 x double>* %8, align 16, !invariant.load !0, !noalias !1
  %9 = fptosi <4 x double> %wide.load.4 to <4 x i16>
  %10 = getelementptr inbounds [100 x [100 x i16]], [100 x [100 x i16]]* %0, i64 0, i64 0, i64 16
  %11 = bitcast i16* %10 to <4 x i16>*
  store <4 x i16> %9, <4 x i16>* %11, align 8
  %12 = getelementptr inbounds [100 x [100 x double]], [100 x [100 x double]]* null, i64 0, i64 0, i64 20
  %13 = bitcast double* %12 to <4 x double>*
  %wide.load.5 = load <4 x double>, <4 x double>* %13, align 16, !invariant.load !0, !noalias !1
  %14 = fptosi <4 x double> %wide.load.5 to <4 x i16>
  %15 = getelementptr inbounds [100 x [100 x i16]], [100 x [100 x i16]]* %0, i64 0, i64 0, i64 20
  %16 = bitcast i16* %15 to <4 x i16>*
  store <4 x i16> %14, <4 x i16>* %16, align 8
  ret void
}

!0 = !{}
!1 = !{!2}
!2 = !{!"buffer: {index:1, offset:0, size:20000}", !3}
!3 = !{!"XLA global AA domain"}
