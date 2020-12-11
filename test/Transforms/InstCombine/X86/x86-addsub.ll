; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -mtriple=x86_64-unknown-unknown -S | FileCheck %s

declare <2 x double> @llvm.x86.sse3.addsub.pd(<2 x double>, <2 x double>)
declare <4 x float> @llvm.x86.sse3.addsub.ps(<4 x float>, <4 x float>)
declare <4 x double> @llvm.x86.avx.addsub.pd.256(<4 x double>, <4 x double>)
declare <8 x float> @llvm.x86.avx.addsub.ps.256(<8 x float>, <8 x float>)
declare <2 x double> @llvm.x86.sse2.cmp.sd(<2 x double>, <2 x double>, i8 immarg) #0

;
; Demanded Elts
;

define double @elts_addsub_v2f64(<2 x double> %0, <2 x double> %1) {
; CHECK-LABEL: @elts_addsub_v2f64(
; CHECK-NEXT:    [[TMP3:%.*]] = shufflevector <2 x double> [[TMP1:%.*]], <2 x double> undef, <2 x i32> <i32 1, i32 undef>
; CHECK-NEXT:    [[TMP4:%.*]] = fsub <2 x double> [[TMP0:%.*]], [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x double> [[TMP4]], i32 0
; CHECK-NEXT:    ret double [[TMP5]]
;
  %3 = shufflevector <2 x double> %0, <2 x double> undef, <2 x i32> <i32 0, i32 0>
  %4 = shufflevector <2 x double> %1, <2 x double> undef, <2 x i32> <i32 1, i32 1>
  %5 = tail call <2 x double> @llvm.x86.sse3.addsub.pd(<2 x double> %3, <2 x double> %4)
  %6 = extractelement <2 x double> %5, i32 0
  ret double %6
}

define double @elts_addsub_v2f64_sub(<2 x double> %0, <2 x double> %1) {
; CHECK-LABEL: @elts_addsub_v2f64_sub(
; CHECK-NEXT:    [[TMP3:%.*]] = fsub <2 x double> [[TMP0:%.*]], [[TMP1:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <2 x double> [[TMP3]], i32 0
; CHECK-NEXT:    ret double [[TMP4]]
;
  %3 = shufflevector <2 x double> %0, <2 x double> undef, <2 x i32> <i32 0, i32 0>
  %4 = shufflevector <2 x double> %1, <2 x double> undef, <2 x i32> <i32 0, i32 0>
  %5 = tail call <2 x double> @llvm.x86.sse3.addsub.pd(<2 x double> %3, <2 x double> %4)
  %6 = extractelement <2 x double> %5, i32 0
  ret double %6
}

define float @elts_addsub_v4f32(<4 x float> %0, <4 x float> %1) {
; CHECK-LABEL: @elts_addsub_v4f32(
; CHECK-NEXT:    [[TMP3:%.*]] = tail call <4 x float> @llvm.x86.sse3.addsub.ps(<4 x float> [[TMP0:%.*]], <4 x float> [[TMP1:%.*]])
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = fadd float [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret float [[TMP6]]
;
  %3 = shufflevector <4 x float> %0, <4 x float> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
  %4 = shufflevector <4 x float> %1, <4 x float> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
  %5 = tail call <4 x float> @llvm.x86.sse3.addsub.ps(<4 x float> %3, <4 x float> %4)
  %6 = extractelement <4 x float> %5, i32 0
  %7 = extractelement <4 x float> %5, i32 1
  %8 = fadd float %6, %7
  ret float %8
}

define float @elts_addsub_v4f32_add(<4 x float> %0, <4 x float> %1) {
; CHECK-LABEL: @elts_addsub_v4f32_add(
; CHECK-NEXT:    [[TMP3:%.*]] = fadd <4 x float> [[TMP0:%.*]], [[TMP1:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x float> [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x float> [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = fadd float [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret float [[TMP6]]
;
  %3 = shufflevector <4 x float> %0, <4 x float> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
  %4 = shufflevector <4 x float> %1, <4 x float> undef, <4 x i32> <i32 0, i32 1, i32 0, i32 1>
  %5 = tail call <4 x float> @llvm.x86.sse3.addsub.ps(<4 x float> %3, <4 x float> %4)
  %6 = extractelement <4 x float> %5, i32 1
  %7 = extractelement <4 x float> %5, i32 3
  %8 = fadd float %6, %7
  ret float %8
}

define double @elts_addsub_v4f64(<4 x double> %0, <4 x double> %1) {
; CHECK-LABEL: @elts_addsub_v4f64(
; CHECK-NEXT:    [[TMP3:%.*]] = tail call <4 x double> @llvm.x86.avx.addsub.pd.256(<4 x double> [[TMP0:%.*]], <4 x double> [[TMP1:%.*]])
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x double> [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x double> [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = fadd double [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret double [[TMP6]]
;
  %3 = shufflevector <4 x double> %0, <4 x double> undef, <4 x i32> <i32 0, i32 1, i32 3, i32 3>
  %4 = shufflevector <4 x double> %1, <4 x double> undef, <4 x i32> <i32 0, i32 1, i32 3, i32 3>
  %5 = tail call <4 x double> @llvm.x86.avx.addsub.pd.256(<4 x double> %3, <4 x double> %4)
  %6 = extractelement <4 x double> %5, i32 0
  %7 = extractelement <4 x double> %5, i32 1
  %8 = fadd double %6, %7
  ret double %8
}

define double @elts_addsub_v4f64_add(<4 x double> %0, <4 x double> %1) {
; CHECK-LABEL: @elts_addsub_v4f64_add(
; CHECK-NEXT:    [[TMP3:%.*]] = fadd <4 x double> [[TMP0:%.*]], [[TMP1:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <4 x double> [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <4 x double> [[TMP3]], i32 3
; CHECK-NEXT:    [[TMP6:%.*]] = fadd double [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret double [[TMP6]]
;
  %3 = shufflevector <4 x double> %0, <4 x double> undef, <4 x i32> <i32 0, i32 1, i32 3, i32 3>
  %4 = shufflevector <4 x double> %1, <4 x double> undef, <4 x i32> <i32 0, i32 1, i32 3, i32 3>
  %5 = tail call <4 x double> @llvm.x86.avx.addsub.pd.256(<4 x double> %3, <4 x double> %4)
  %6 = extractelement <4 x double> %5, i32 1
  %7 = extractelement <4 x double> %5, i32 3
  %8 = fadd double %6, %7
  ret double %8
}

define float @elts_addsub_v8f32(<8 x float> %0, <8 x float> %1) {
; CHECK-LABEL: @elts_addsub_v8f32(
; CHECK-NEXT:    [[TMP3:%.*]] = tail call <8 x float> @llvm.x86.avx.addsub.ps.256(<8 x float> [[TMP0:%.*]], <8 x float> [[TMP1:%.*]])
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <8 x float> [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <8 x float> [[TMP3]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = fadd float [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret float [[TMP6]]
;
  %3 = shufflevector <8 x float> %0, <8 x float> undef, <8 x i32> <i32 0, i32 1, i32 0, i32 1, i32 4, i32 4, i32 4, i32 4>
  %4 = shufflevector <8 x float> %1, <8 x float> undef, <8 x i32> <i32 0, i32 1, i32 0, i32 1, i32 4, i32 4, i32 4, i32 4>
  %5 = tail call <8 x float> @llvm.x86.avx.addsub.ps.256(<8 x float> %3, <8 x float> %4)
  %6 = extractelement <8 x float> %5, i32 0
  %7 = extractelement <8 x float> %5, i32 1
  %8 = fadd float %6, %7
  ret float %8
}

define float @elts_addsub_v8f32_sub(<8 x float> %0, <8 x float> %1) {
; CHECK-LABEL: @elts_addsub_v8f32_sub(
; CHECK-NEXT:    [[TMP3:%.*]] = fsub <8 x float> [[TMP0:%.*]], [[TMP1:%.*]]
; CHECK-NEXT:    [[TMP4:%.*]] = extractelement <8 x float> [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <8 x float> [[TMP3]], i32 4
; CHECK-NEXT:    [[TMP6:%.*]] = fadd float [[TMP4]], [[TMP5]]
; CHECK-NEXT:    ret float [[TMP6]]
;
  %3 = shufflevector <8 x float> %0, <8 x float> undef, <8 x i32> <i32 0, i32 1, i32 0, i32 1, i32 4, i32 4, i32 4, i32 4>
  %4 = shufflevector <8 x float> %1, <8 x float> undef, <8 x i32> <i32 0, i32 1, i32 0, i32 1, i32 4, i32 4, i32 4, i32 4>
  %5 = tail call <8 x float> @llvm.x86.avx.addsub.ps.256(<8 x float> %3, <8 x float> %4)
  %6 = extractelement <8 x float> %5, i32 0
  %7 = extractelement <8 x float> %5, i32 4
  %8 = fadd float %6, %7
  ret float %8
}

define void @PR46277(float %0, float %1, float %2, float %3, <4 x float> %4, float* %5) {
; CHECK-LABEL: @PR46277(
; CHECK-NEXT:    [[TMP7:%.*]] = insertelement <4 x float> undef, float [[TMP0:%.*]], i32 0
; CHECK-NEXT:    [[TMP8:%.*]] = insertelement <4 x float> [[TMP7]], float [[TMP1:%.*]], i32 1
; CHECK-NEXT:    [[TMP9:%.*]] = tail call <4 x float> @llvm.x86.sse3.addsub.ps(<4 x float> [[TMP8]], <4 x float> [[TMP4:%.*]])
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <4 x float> [[TMP9]], i32 0
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds float, float* [[TMP5:%.*]], i64 1
; CHECK-NEXT:    store float [[TMP10]], float* [[TMP5]], align 4
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <4 x float> [[TMP9]], i32 1
; CHECK-NEXT:    store float [[TMP12]], float* [[TMP11]], align 4
; CHECK-NEXT:    ret void
;
  %7 = insertelement <4 x float> undef, float %0, i32 0
  %8 = insertelement <4 x float> %7, float %1, i32 1
  %9 = insertelement <4 x float> %8, float %2, i32 2
  %10 = insertelement <4 x float> %9, float %3, i32 3
  %11 = tail call <4 x float> @llvm.x86.sse3.addsub.ps(<4 x float> %10, <4 x float> %4)
  %12 = extractelement <4 x float> %11, i32 0
  %13 = getelementptr inbounds float, float* %5, i64 1
  store float %12, float* %5, align 4
  %14 = extractelement <4 x float> %11, i32 1
  store float %14, float* %13, align 4
  ret void
}

define double @PR48476_fsub(<2 x double> %x) {
; CHECK-LABEL: @PR48476_fsub(
; CHECK-NEXT:    [[TMP1:%.*]] = fsub <2 x double> <double 0.000000e+00, double undef>, [[X:%.*]]
; CHECK-NEXT:    [[T2:%.*]] = call <2 x double> @llvm.x86.sse2.cmp.sd(<2 x double> [[TMP1]], <2 x double> [[X]], i8 6)
; CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <2 x double> [[T2]], i32 0
; CHECK-NEXT:    ret double [[VECEXT]]
;
  %t1 = call <2 x double> @llvm.x86.sse3.addsub.pd(<2 x double> zeroinitializer, <2 x double> %x)
  %t2 = call <2 x double> @llvm.x86.sse2.cmp.sd(<2 x double> %t1, <2 x double> %x, i8 6)
  %vecext = extractelement <2 x double> %t2, i32 0
  ret double %vecext
}

define double @PR48476_fadd_fsub(<2 x double> %x) {
; CHECK-LABEL: @PR48476_fadd_fsub(
; CHECK-NEXT:    [[TMP1:%.*]] = fadd <2 x double> [[X:%.*]], <double undef, double 0.000000e+00>
; CHECK-NEXT:    [[S:%.*]] = shufflevector <2 x double> [[TMP1]], <2 x double> undef, <2 x i32> <i32 1, i32 undef>
; CHECK-NEXT:    [[TMP2:%.*]] = fsub <2 x double> [[S]], [[X]]
; CHECK-NEXT:    [[VECEXT:%.*]] = extractelement <2 x double> [[TMP2]], i32 0
; CHECK-NEXT:    ret double [[VECEXT]]
;
  %t1 = call <2 x double> @llvm.x86.sse3.addsub.pd(<2 x double> zeroinitializer, <2 x double> %x)
  %s = shufflevector <2 x double> %t1, <2 x double> undef, <2 x i32> <i32 1, i32 0>
  %t2 = call <2 x double> @llvm.x86.sse3.addsub.pd(<2 x double> %s, <2 x double> %x)
  %vecext = extractelement <2 x double> %t2, i32 0
  ret double %vecext
}
