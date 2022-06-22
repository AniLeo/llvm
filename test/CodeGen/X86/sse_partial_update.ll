; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-macosx -mattr=+sse2 -mcpu=nehalem | FileCheck %s

; rdar: 12558838
; PR14221
; There is a mismatch between the intrinsic and the actual instruction.
; The actual instruction has a partial update of dest, while the intrinsic
; passes through the upper FP values. Here, we make sure the source and
; destination of each scalar unary op are the same.

define void @rsqrtss(<4 x float> %a) nounwind uwtable ssp {
; CHECK-LABEL: rsqrtss:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    rsqrtss %xmm0, %xmm0
; CHECK-NEXT:    cvtss2sd %xmm0, %xmm2
; CHECK-NEXT:    movshdup {{.*#+}} xmm0 = xmm0[1,1,3,3]
; CHECK-NEXT:    cvtss2sd %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm2, %xmm0
; CHECK-NEXT:    jmp _callee ## TAILCALL
  %t0 = tail call <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float> %a) nounwind
  %a.addr.0.extract = extractelement <4 x float> %t0, i32 0
  %conv = fpext float %a.addr.0.extract to double
  %a.addr.4.extract = extractelement <4 x float> %t0, i32 1
  %conv3 = fpext float %a.addr.4.extract to double
  tail call void @callee(double %conv, double %conv3) nounwind
  ret void
}
declare void @callee(double, double)
declare <4 x float> @llvm.x86.sse.rsqrt.ss(<4 x float>) nounwind readnone

define void @rcpss(<4 x float> %a) nounwind uwtable ssp {
; CHECK-LABEL: rcpss:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    rcpss %xmm0, %xmm0
; CHECK-NEXT:    cvtss2sd %xmm0, %xmm2
; CHECK-NEXT:    movshdup {{.*#+}} xmm0 = xmm0[1,1,3,3]
; CHECK-NEXT:    cvtss2sd %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm2, %xmm0
; CHECK-NEXT:    jmp _callee ## TAILCALL
  %t0 = tail call <4 x float> @llvm.x86.sse.rcp.ss(<4 x float> %a) nounwind
  %a.addr.0.extract = extractelement <4 x float> %t0, i32 0
  %conv = fpext float %a.addr.0.extract to double
  %a.addr.4.extract = extractelement <4 x float> %t0, i32 1
  %conv3 = fpext float %a.addr.4.extract to double
  tail call void @callee(double %conv, double %conv3) nounwind
  ret void
}
declare <4 x float> @llvm.x86.sse.rcp.ss(<4 x float>) nounwind readnone

define void @sqrtss(<4 x float> %a) nounwind uwtable ssp {
; CHECK-LABEL: sqrtss:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sqrtss %xmm0, %xmm1
; CHECK-NEXT:    cvtss2sd %xmm1, %xmm2
; CHECK-NEXT:    movshdup {{.*#+}} xmm0 = xmm0[1,1,3,3]
; CHECK-NEXT:    xorps %xmm1, %xmm1
; CHECK-NEXT:    cvtss2sd %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm2, %xmm0
; CHECK-NEXT:    jmp _callee ## TAILCALL
  %t0 = tail call <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float> %a) nounwind
  %a.addr.0.extract = extractelement <4 x float> %t0, i32 0
  %conv = fpext float %a.addr.0.extract to double
  %a.addr.4.extract = extractelement <4 x float> %t0, i32 1
  %conv3 = fpext float %a.addr.4.extract to double
  tail call void @callee(double %conv, double %conv3) nounwind
  ret void
}
declare <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float>) nounwind readnone

define void @sqrtsd(<2 x double> %a) nounwind uwtable ssp {
; CHECK-LABEL: sqrtsd:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sqrtsd %xmm0, %xmm1
; CHECK-NEXT:    cvtsd2ss %xmm1, %xmm2
; CHECK-NEXT:    unpckhpd {{.*#+}} xmm0 = xmm0[1,1]
; CHECK-NEXT:    xorps %xmm1, %xmm1
; CHECK-NEXT:    cvtsd2ss %xmm0, %xmm1
; CHECK-NEXT:    movaps %xmm2, %xmm0
; CHECK-NEXT:    jmp _callee2 ## TAILCALL
  %t0 = tail call <2 x double> @llvm.x86.sse2.sqrt.sd(<2 x double> %a) nounwind
  %a0 = extractelement <2 x double> %t0, i32 0
  %conv = fptrunc double %a0 to float
  %a1 = extractelement <2 x double> %t0, i32 1
  %conv3 = fptrunc double %a1 to float
  tail call void @callee2(float %conv, float %conv3) nounwind
  ret void
}

declare void @callee2(float, float)
declare <2 x double> @llvm.x86.sse2.sqrt.sd(<2 x double>) nounwind readnone

define <2 x double> @load_fold_cvtss2sd_int(ptr%a) {
; CHECK-LABEL: load_fold_cvtss2sd_int:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; CHECK-NEXT:    cvtss2sd %xmm0, %xmm0
; CHECK-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; CHECK-NEXT:    retq
  %ld = load <4 x float>, ptr%a
  %x = call <2 x double> @llvm.x86.sse2.cvtss2sd(<2 x double> <double 0x0, double 0x0>, <4 x float> %ld)
  ret <2 x double> %x
}

define <2 x double> @load_fold_cvtss2sd_int_optsize(ptr%a) optsize {
; CHECK-LABEL: load_fold_cvtss2sd_int_optsize:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    cvtss2sd (%rdi), %xmm0
; CHECK-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; CHECK-NEXT:    retq
  %ld = load <4 x float>, ptr%a
  %x = call <2 x double> @llvm.x86.sse2.cvtss2sd(<2 x double> <double 0x0, double 0x0>, <4 x float> %ld)
  ret <2 x double> %x
}

define <2 x double> @load_fold_cvtss2sd_int_minsize(ptr%a) minsize {
; CHECK-LABEL: load_fold_cvtss2sd_int_minsize:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    cvtss2sd (%rdi), %xmm0
; CHECK-NEXT:    movq {{.*#+}} xmm0 = xmm0[0],zero
; CHECK-NEXT:    retq
  %ld = load <4 x float>, ptr%a
  %x = call <2 x double> @llvm.x86.sse2.cvtss2sd(<2 x double> <double 0x0, double 0x0>, <4 x float> %ld)
  ret <2 x double> %x
}

declare <2 x double> @llvm.x86.sse2.cvtss2sd(<2 x double>, <4 x float>) nounwind readnone

define float @PR22206(<4 x float> %a) {
; CHECK-LABEL: PR22206:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    sqrtss %xmm0, %xmm1
; CHECK-NEXT:    addss %xmm1, %xmm0
; CHECK-NEXT:    retq
  %res = tail call <4 x float> @llvm.x86.sse.sqrt.ss(<4 x float> %a) nounwind
  %new = extractelement <4 x float> %res, i32 0
  %orig = extractelement <4 x float> %a, i32 0
  %add = fadd float %new, %orig
  ret float %add
}

