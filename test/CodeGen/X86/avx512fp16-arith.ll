; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mcpu=skx -mattr=+avx512fp16 | FileCheck %s

define <32 x half> @vaddph_512_test(<32 x half> %i, <32 x half> %j) nounwind readnone {
; CHECK-LABEL: vaddph_512_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vaddph %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = fadd  <32 x half> %i, %j
  ret <32 x half> %x
}

define <32 x half> @vaddph_512_fold_test(<32 x half> %i, ptr %j) nounwind {
; CHECK-LABEL: vaddph_512_fold_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vaddph (%rdi), %zmm0, %zmm0
; CHECK-NEXT:    retq
  %tmp = load <32 x half>, ptr %j, align 4
  %x = fadd  <32 x half> %i, %tmp
  ret <32 x half> %x
}

define <32 x half> @vaddph_512_broadc_test(<32 x half> %a) nounwind {
; CHECK-LABEL: vaddph_512_broadc_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vaddph {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to32}, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %b = fadd <32 x half> %a, <half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0>
  ret <32 x half> %b
}

define <16 x half> @vaddph_256_broadc_test(<16 x half> %a) nounwind {
; CHECK-LABEL: vaddph_256_broadc_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vaddph {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to16}, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %b = fadd <16 x half> %a, <half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0>
  ret <16 x half> %b
}

define <8 x half> @vaddph_128_broadc_test(<8 x half> %a) nounwind {
; CHECK-LABEL: vaddph_128_broadc_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vaddph {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %b = fadd <8 x half> %a, <half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0, half 1.0>
  ret <8 x half> %b
}

define <32 x half> @vaddph_512_mask_test1(<32 x half> %i, <32 x half> %j, <32 x i1> %mask) nounwind readnone {
; CHECK-LABEL: vaddph_512_mask_test1:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpsllw $7, %ymm2, %ymm2
; CHECK-NEXT:    vpmovb2m %ymm2, %k1
; CHECK-NEXT:    vaddph %zmm1, %zmm0, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %x = fadd  <32 x half> %i, %j
  %r = select <32 x i1> %mask, <32 x half> %x, <32 x half> %i
  ret <32 x half> %r
}

define <32 x half> @vaddph_512_mask_test(<32 x half> %i, <32 x half> %j, <32 x half> %mask1) nounwind readnone {
; CHECK-LABEL: vaddph_512_mask_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vxorps %xmm3, %xmm3, %xmm3
; CHECK-NEXT:    vcmpneq_oqph %zmm3, %zmm2, %k1
; CHECK-NEXT:    vaddph %zmm1, %zmm0, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = fcmp one <32 x half> %mask1, zeroinitializer
  %x = fadd  <32 x half> %i, %j
  %r = select <32 x i1> %mask, <32 x half> %x, <32 x half> %i
  ret <32 x half> %r
}

define <32 x half> @vaddph_512_maskz_test(<32 x half> %i, <32 x half> %j, <32 x half> %mask1) nounwind readnone {
; CHECK-LABEL: vaddph_512_maskz_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vxorps %xmm3, %xmm3, %xmm3
; CHECK-NEXT:    vcmpneq_oqph %zmm3, %zmm2, %k1
; CHECK-NEXT:    vaddph %zmm1, %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %mask = fcmp one <32 x half> %mask1, zeroinitializer
  %x = fadd  <32 x half> %i, %j
  %r = select <32 x i1> %mask, <32 x half> %x, <32 x half> zeroinitializer
  ret <32 x half> %r
}

define <32 x half> @vaddph_512_mask_fold_test(<32 x half> %i, ptr %j.ptr, <32 x half> %mask1) nounwind readnone {
; CHECK-LABEL: vaddph_512_mask_fold_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vcmpneq_oqph %zmm2, %zmm1, %k1
; CHECK-NEXT:    vaddph (%rdi), %zmm0, %zmm0 {%k1}
; CHECK-NEXT:    retq
  %mask = fcmp one <32 x half> %mask1, zeroinitializer
  %j = load <32 x half>, ptr %j.ptr
  %x = fadd  <32 x half> %i, %j
  %r = select <32 x i1> %mask, <32 x half> %x, <32 x half> %i
  ret <32 x half> %r
}

define <32 x half> @vaddph_512_maskz_fold_test(<32 x half> %i, ptr %j.ptr, <32 x half> %mask1) nounwind readnone {
; CHECK-LABEL: vaddph_512_maskz_fold_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vcmpneq_oqph %zmm2, %zmm1, %k1
; CHECK-NEXT:    vaddph (%rdi), %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %mask = fcmp one <32 x half> %mask1, zeroinitializer
  %j = load <32 x half>, ptr %j.ptr
  %x = fadd  <32 x half> %i, %j
  %r = select <32 x i1> %mask, <32 x half> %x, <32 x half> zeroinitializer
  ret <32 x half> %r
}

define <32 x half> @vaddph_512_maskz_fold_test_2(<32 x half> %i, ptr %j.ptr, <32 x half> %mask1) nounwind readnone {
; CHECK-LABEL: vaddph_512_maskz_fold_test_2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; CHECK-NEXT:    vcmpneq_oqph %zmm2, %zmm1, %k1
; CHECK-NEXT:    vaddph (%rdi), %zmm0, %zmm0 {%k1} {z}
; CHECK-NEXT:    retq
  %mask = fcmp one <32 x half> %mask1, zeroinitializer
  %j = load <32 x half>, ptr %j.ptr
  %x = fadd  <32 x half> %j, %i
  %r = select <32 x i1> %mask, <32 x half> %x, <32 x half> zeroinitializer
  ret <32 x half> %r
}

define <32 x half> @vsubph_512_test(<32 x half> %i, <32 x half> %j) nounwind readnone {
; CHECK-LABEL: vsubph_512_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vsubph %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = fsub  <32 x half> %i, %j
  ret <32 x half> %x
}

define <32 x half> @vmulph_512_test(<32 x half> %i, <32 x half> %j) nounwind readnone {
; CHECK-LABEL: vmulph_512_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmulph %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = fmul  <32 x half> %i, %j
  ret <32 x half> %x
}

define <32 x half> @vdivph_512_test(<32 x half> %i, <32 x half> %j) nounwind readnone {
; CHECK-LABEL: vdivph_512_test:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vdivph %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %x = fdiv  <32 x half> %i, %j
  ret <32 x half> %x
}

define <32 x half> @vdivph_512_test_fast(<32 x half> %i, <32 x half> %j) nounwind readnone {
; CHECK-LABEL: vdivph_512_test_fast:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrcpph %zmm1, %zmm1
; CHECK-NEXT:    vmulph %zmm0, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %x = fdiv fast <32 x half> %i, %j
  ret <32 x half> %x
}

define half @add_sh(half %i, half %j, ptr %x.ptr) nounwind readnone {
; CHECK-LABEL: add_sh:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vaddsh %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vaddsh (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %x = load half, ptr %x.ptr
  %y = fadd  half %i, %j
  %r = fadd  half %x, %y
  ret half %r
}

define half @sub_sh(half %i, half %j, ptr %x.ptr) nounwind readnone {
; CHECK-LABEL: sub_sh:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovsh (%rdi), %xmm2
; CHECK-NEXT:    vsubsh %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vsubsh %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %x = load half, ptr %x.ptr
  %y = fsub  half %i, %j
  %r = fsub  half %x, %y
  ret half %r
}

define half @sub_sh_2(half %i, half %j, ptr %x.ptr) nounwind readnone {
; CHECK-LABEL: sub_sh_2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vsubsh %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vsubsh (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %x = load half, ptr %x.ptr
  %y = fsub  half %i, %j
  %r = fsub  half %y, %x
  ret half %r
}

define half @mul_sh(half %i, half %j, ptr %x.ptr) nounwind readnone {
; CHECK-LABEL: mul_sh:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmulsh %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vmulsh (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %x = load half, ptr %x.ptr
  %y = fmul  half %i, %j
  %r = fmul  half %x, %y
  ret half %r
}

define half @div_sh(half %i, half %j, ptr %x.ptr) nounwind readnone {
; CHECK-LABEL: div_sh:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vmovsh (%rdi), %xmm2
; CHECK-NEXT:    vdivsh %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vdivsh %xmm0, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %x = load half, ptr %x.ptr
  %y = fdiv  half %i, %j
  %r = fdiv  half %x, %y
  ret half %r
}

define half @div_sh_2(half %i, half %j, ptr %x.ptr) nounwind readnone {
; CHECK-LABEL: div_sh_2:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vdivsh %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vdivsh (%rdi), %xmm0, %xmm0
; CHECK-NEXT:    retq
  %x = load half, ptr %x.ptr
  %y = fdiv  half %i, %j
  %r = fdiv  half %y, %x
  ret half %r
}

define half @div_sh_3(half %i, half %j) nounwind readnone {
; CHECK-LABEL: div_sh_3:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vrcpsh %xmm1, %xmm1, %xmm1
; CHECK-NEXT:    vmulsh %xmm0, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %r = fdiv fast half %i, %j
  ret half %r
}

define i1 @cmp_une_sh(half %x, half %y) {
; CHECK-LABEL: cmp_une_sh:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcmpneqsh %xmm1, %xmm0, %k0
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    ## kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
entry:
  %0 = fcmp une half %x, %y
  ret i1 %0
}

define i1 @cmp_oeq_sh(half %x, half %y) {
; CHECK-LABEL: cmp_oeq_sh:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcmpeqsh %xmm1, %xmm0, %k0
; CHECK-NEXT:    kmovd %k0, %eax
; CHECK-NEXT:    ## kill: def $al killed $al killed $eax
; CHECK-NEXT:    retq
entry:
  %0 = fcmp oeq half %x, %y
  ret i1 %0
}

define i1 @cmp_olt_sh(half %x, half %y) {
; CHECK-LABEL: cmp_olt_sh:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vucomish %xmm0, %xmm1
; CHECK-NEXT:    seta %al
; CHECK-NEXT:    retq
  entry:
  %0 = fcmp olt half %x, %y
  ret i1 %0
}

define <32 x i1> @cmp_ph(<32 x half> %x, <32 x half> %y) {
; CHECK-LABEL: cmp_ph:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcmpneqph %zmm1, %zmm0, %k0
; CHECK-NEXT:    vpmovm2b %k0, %ymm0
; CHECK-NEXT:    retq
entry:
  %0 = fcmp une <32 x half> %x, %y
  ret <32 x i1> %0
}

define half @fneg(half %x) {
; CHECK-LABEL: fneg:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = fneg half %x
  ret half %a
}

define half @fneg_idiom(half %x) {
; CHECK-LABEL: fneg_idiom:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = fsub half -0.0, %x
  ret half %a
}

define half @fabs(half %x) {
; CHECK-LABEL: fabs:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} xmm1 = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN]
; CHECK-NEXT:    vpand %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = call half @llvm.fabs.f16(half %x)
  ret half %a
}
declare half @llvm.fabs.f16(half)

define half @fcopysign(half %x, half %y) {
; CHECK-LABEL: fcopysign:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN]
; CHECK-NEXT:    vpternlogq $226, %xmm1, %xmm2, %xmm0
; CHECK-NEXT:    retq
  %a = call half @llvm.copysign.f16(half %x, half %y)
  ret half %a
}
declare half @llvm.copysign.f16(half, half)

define <8 x half> @fnegv8f16(<8 x half> %x) {
; CHECK-LABEL: fnegv8f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = fneg <8 x half> %x
  ret <8 x half> %a
}

define <8 x half> @fneg_idiomv8f16(<8 x half> %x) {
; CHECK-LABEL: fneg_idiomv8f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} xmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    vpxor %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = fsub <8 x half> <half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0>, %x
  ret <8 x half> %a
}

define <8 x half> @fabsv8f16(<8 x half> %x) {
; CHECK-LABEL: fabsv8f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} xmm1 = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN]
; CHECK-NEXT:    vpand %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    retq
  %a = call <8 x half> @llvm.fabs.v8f16(<8 x half> %x)
  ret <8 x half> %a
}
declare <8 x half> @llvm.fabs.v8f16(<8 x half>)

define <8 x half> @fcopysignv8f16(<8 x half> %x, <8 x half> %y) {
; CHECK-LABEL: fcopysignv8f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpternlogq $228, {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to2}, %xmm1, %xmm0
; CHECK-NEXT:    retq
  %a = call <8 x half> @llvm.copysign.v8f16(<8 x half> %x, <8 x half> %y)
  ret <8 x half> %a
}
declare <8 x half> @llvm.copysign.v8f16(<8 x half>, <8 x half>)

define <16 x half> @fnegv16f16(<16 x half> %x) {
; CHECK-LABEL: fnegv16f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} ymm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    vpxor %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %a = fneg <16 x half> %x
  ret <16 x half> %a
}

define <16 x half> @fneg_idiomv16f16(<16 x half> %x) {
; CHECK-LABEL: fneg_idiomv16f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} ymm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    vpxor %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %a = fsub <16 x half> <half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0>, %x
  ret <16 x half> %a
}

define <16 x half> @fabsv16f16(<16 x half> %x) {
; CHECK-LABEL: fabsv16f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} ymm1 = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN]
; CHECK-NEXT:    vpand %ymm1, %ymm0, %ymm0
; CHECK-NEXT:    retq
  %a = call <16 x half> @llvm.fabs.v16f16(<16 x half> %x)
  ret <16 x half> %a
}
declare <16 x half> @llvm.fabs.v16f16(<16 x half>)

define <16 x half> @fcopysignv16f16(<16 x half> %x, <16 x half> %y) {
; CHECK-LABEL: fcopysignv16f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpternlogq $228, {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to4}, %ymm1, %ymm0
; CHECK-NEXT:    retq
  %a = call <16 x half> @llvm.copysign.v16f16(<16 x half> %x, <16 x half> %y)
  ret <16 x half> %a
}
declare <16 x half> @llvm.copysign.v16f16(<16 x half>, <16 x half>)

define <32 x half> @fnegv32f16(<32 x half> %x) {
; CHECK-LABEL: fnegv32f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} zmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    vpxorq %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %a = fneg <32 x half> %x
  ret <32 x half> %a
}

define <32 x half> @fneg_idiomv32f16(<32 x half> %x) {
; CHECK-LABEL: fneg_idiomv32f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} zmm1 = [-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0,-0.0E+0]
; CHECK-NEXT:    vpxorq %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %a = fsub <32 x half> <half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0, half -0.0>, %x
  ret <32 x half> %a
}

define <32 x half> @fabsv32f16(<32 x half> %x) {
; CHECK-LABEL: fabsv32f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpbroadcastw {{.*#+}} zmm1 = [NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN,NaN]
; CHECK-NEXT:    vpandq %zmm1, %zmm0, %zmm0
; CHECK-NEXT:    retq
  %a = call <32 x half> @llvm.fabs.v32f16(<32 x half> %x)
  ret <32 x half> %a
}
declare <32 x half> @llvm.fabs.v32f16(<32 x half>)

define <32 x half> @fcopysignv32f16(<32 x half> %x, <32 x half> %y) {
; CHECK-LABEL: fcopysignv32f16:
; CHECK:       ## %bb.0:
; CHECK-NEXT:    vpternlogq $228, {{\.?LCPI[0-9]+_[0-9]+}}(%rip){1to8}, %zmm1, %zmm0
; CHECK-NEXT:    retq
  %a = call <32 x half> @llvm.copysign.v32f16(<32 x half> %x, <32 x half> %y)
  ret <32 x half> %a
}
declare <32 x half> @llvm.copysign.v32f16(<32 x half>, <32 x half>)

define <8 x half>  @regression_test1(<8 x half> %x, <8 x half> %y) #0 {
; CHECK-LABEL: regression_test1:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vsubph %xmm1, %xmm0, %xmm2
; CHECK-NEXT:    vaddph %xmm1, %xmm0, %xmm0
; CHECK-NEXT:    vpblendw {{.*#+}} xmm0 = xmm2[0],xmm0[1],xmm2[2],xmm0[3],xmm2[4],xmm0[5],xmm2[6],xmm0[7]
; CHECK-NEXT:    retq
entry:
  %a = fsub <8 x half> %x, %y
  %b = fadd <8 x half> %x, %y
  %c = shufflevector <8 x half> %a, <8 x half> %b, <8 x i32> <i32 0, i32 9, i32 2, i32 11, i32 4, i32 13, i32 6, i32 15>
  ret <8 x half> %c
}

define <8 x i16>  @regression_test2(<8 x float> %x) #0 {
; CHECK-LABEL: regression_test2:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcvttps2udq %ymm0, %ymm0
; CHECK-NEXT:    vpmovdw %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %a = fptoui <8 x float> %x to  <8 x i16>
  ret <8 x i16> %a
}

define <8 x i16>  @regression_test3(<8 x float> %x) #0 {
; CHECK-LABEL: regression_test3:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcvttps2dq %ymm0, %ymm0
; CHECK-NEXT:    vpmovdw %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %a = fptosi <8 x float> %x to  <8 x i16>
  ret <8 x i16> %a
}

define <8 x i16>  @regression_test4(<8 x double> %x) #0 {
; CHECK-LABEL: regression_test4:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcvttpd2udq %zmm0, %ymm0
; CHECK-NEXT:    vpmovdw %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %a = fptoui <8 x double> %x to  <8 x i16>
  ret <8 x i16> %a
}

define <8 x i16>  @regression_test5(<8 x double> %x) #0 {
; CHECK-LABEL: regression_test5:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcvttpd2dq %zmm0, %ymm0
; CHECK-NEXT:    vpmovdw %ymm0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
entry:
  %a = fptosi <8 x double> %x to  <8 x i16>
  ret <8 x i16> %a
}

define <8 x i1> @fcmp_v8f16(<8 x half> %a, <8 x half> %b)
; CHECK-LABEL: fcmp_v8f16:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcmpeqph %xmm1, %xmm0, %k0
; CHECK-NEXT:    vpmovm2w %k0, %xmm0
; CHECK-NEXT:    retq
{
entry:
  %0 = fcmp oeq <8 x half> %a, %b
  ret <8 x i1> %0
}

define <16 x i1> @fcmp_v16f16(<16 x half> %a, <16 x half> %b)
; CHECK-LABEL: fcmp_v16f16:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcmpeqph %ymm1, %ymm0, %k0
; CHECK-NEXT:    vpmovm2b %k0, %xmm0
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retq
{
entry:
  %0 = fcmp oeq <16 x half> %a, %b
  ret <16 x i1> %0
}

define <32 x i1> @fcmp_v32f16(<32 x half> %a, <32 x half> %b)
; CHECK-LABEL: fcmp_v32f16:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcmpeqph %zmm1, %zmm0, %k0
; CHECK-NEXT:    vpmovm2b %k0, %ymm0
; CHECK-NEXT:    retq
{
entry:
  %0 = fcmp oeq <32 x half> %a, %b
  ret <32 x i1> %0
}

define <8 x i16> @zext_fcmp_v8f16(<8 x half> %a, <8 x half> %b)
; CHECK-LABEL: zext_fcmp_v8f16:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcmpeqph %xmm1, %xmm0, %k0
; CHECK-NEXT:    vpmovm2w %k0, %xmm0
; CHECK-NEXT:    vpsrlw $15, %xmm0, %xmm0
; CHECK-NEXT:    retq
{
entry:
  %0 = fcmp oeq <8 x half> %a, %b
  %1 = zext <8 x i1> %0 to <8 x i16>
  ret <8 x i16> %1
}

define <16 x i16> @zext_fcmp_v16f16(<16 x half> %a, <16 x half> %b)
; CHECK-LABEL: zext_fcmp_v16f16:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcmpeqph %ymm1, %ymm0, %k0
; CHECK-NEXT:    vpmovm2w %k0, %ymm0
; CHECK-NEXT:    vpsrlw $15, %ymm0, %ymm0
; CHECK-NEXT:    retq
{
entry:
  %0 = fcmp oeq <16 x half> %a, %b
  %1 = zext <16 x i1> %0 to <16 x i16>
  ret <16 x i16> %1
}

define <32 x i16> @zext_fcmp_v32f16(<32 x half> %a, <32 x half> %b)
; CHECK-LABEL: zext_fcmp_v32f16:
; CHECK:       ## %bb.0: ## %entry
; CHECK-NEXT:    vcmpeqph %zmm1, %zmm0, %k0
; CHECK-NEXT:    vpmovm2w %k0, %zmm0
; CHECK-NEXT:    vpsrlw $15, %zmm0, %zmm0
; CHECK-NEXT:    retq
{
entry:
  %0 = fcmp oeq <32 x half> %a, %b
  %1 = zext <32 x i1> %0 to <32 x i16>
  ret <32 x i16> %1
}

