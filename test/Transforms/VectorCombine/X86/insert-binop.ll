; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -passes=vector-combine -S -mtriple=x86_64-- -mattr=SSE2 | FileCheck %s --check-prefixes=CHECK,SSE
; RUN: opt < %s -passes=vector-combine -S -mtriple=x86_64-- -mattr=AVX2 | FileCheck %s --check-prefixes=CHECK,AVX

declare void @use(<4 x i32>)
declare void @usef(<4 x float>)

; Eliminating an insert is profitable.

define <16 x i8> @ins0_ins0_add(i8 %x, i8 %y) {
; CHECK-LABEL: @ins0_ins0_add(
; CHECK-NEXT:    [[R_SCALAR:%.*]] = add i8 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <16 x i8> undef, i8 [[R_SCALAR]], i64 0
; CHECK-NEXT:    ret <16 x i8> [[R]]
;
  %i0 = insertelement <16 x i8> undef, i8 %x, i32 0
  %i1 = insertelement <16 x i8> undef, i8 %y, i32 0
  %r = add <16 x i8> %i0, %i1
  ret <16 x i8> %r
}

; Eliminating an insert is still profitable. Flags propagate. Mismatch types on index is ok.

define <8 x i16> @ins0_ins0_sub_flags(i16 %x, i16 %y) {
; CHECK-LABEL: @ins0_ins0_sub_flags(
; CHECK-NEXT:    [[R_SCALAR:%.*]] = sub nuw nsw i16 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <8 x i16> undef, i16 [[R_SCALAR]], i64 5
; CHECK-NEXT:    ret <8 x i16> [[R]]
;
  %i0 = insertelement <8 x i16> undef, i16 %x, i8 5
  %i1 = insertelement <8 x i16> undef, i16 %y, i32 5
  %r = sub nsw nuw <8 x i16> %i0, %i1
  ret <8 x i16> %r
}

; The new vector constant is calculated by constant folding.
; This is conservatively created as zero rather than undef for 'undef ^ undef'.

define <2 x i64> @ins1_ins1_xor(i64 %x, i64 %y) {
; CHECK-LABEL: @ins1_ins1_xor(
; CHECK-NEXT:    [[R_SCALAR:%.*]] = xor i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <2 x i64> zeroinitializer, i64 [[R_SCALAR]], i64 1
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %i0 = insertelement <2 x i64> undef, i64 %x, i64 1
  %i1 = insertelement <2 x i64> undef, i64 %y, i32 1
  %r = xor <2 x i64> %i0, %i1
  ret <2 x i64> %r
}

define <2 x i64> @ins1_ins1_iterate(i64 %w, i64 %x, i64 %y, i64 %z) {
; CHECK-LABEL: @ins1_ins1_iterate(
; CHECK-NEXT:    [[S0_SCALAR:%.*]] = sub i64 [[W:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[S1_SCALAR:%.*]] = or i64 [[S0_SCALAR]], [[Y:%.*]]
; CHECK-NEXT:    [[S2_SCALAR:%.*]] = shl i64 [[Z:%.*]], [[S1_SCALAR]]
; CHECK-NEXT:    [[S2:%.*]] = insertelement <2 x i64> poison, i64 [[S2_SCALAR]], i64 1
; CHECK-NEXT:    ret <2 x i64> [[S2]]
;
  %i0 = insertelement <2 x i64> undef, i64 %w, i64 1
  %i1 = insertelement <2 x i64> undef, i64 %x, i32 1
  %s0 = sub <2 x i64> %i0, %i1
  %i2 = insertelement <2 x i64> undef, i64 %y, i32 1
  %s1 = or <2 x i64> %s0, %i2
  %i3 = insertelement <2 x i64> undef, i64 %z, i32 1
  %s2 = shl <2 x i64> %i3, %s1
  ret <2 x i64> %s2
}

; The inserts are free, but it's still better to scalarize.

define <2 x double> @ins0_ins0_fadd(double %x, double %y) {
; CHECK-LABEL: @ins0_ins0_fadd(
; CHECK-NEXT:    [[R_SCALAR:%.*]] = fadd reassoc nsz double [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <2 x double> undef, double [[R_SCALAR]], i64 0
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %i0 = insertelement <2 x double> undef, double %x, i32 0
  %i1 = insertelement <2 x double> undef, double %y, i32 0
  %r = fadd reassoc nsz <2 x double> %i0, %i1
  ret <2 x double> %r
}

; Negative test - mismatched indexes (but could fold this).

define <16 x i8> @ins1_ins0_add(i8 %x, i8 %y) {
; CHECK-LABEL: @ins1_ins0_add(
; CHECK-NEXT:    [[I0:%.*]] = insertelement <16 x i8> undef, i8 [[X:%.*]], i32 1
; CHECK-NEXT:    [[I1:%.*]] = insertelement <16 x i8> undef, i8 [[Y:%.*]], i32 0
; CHECK-NEXT:    [[R:%.*]] = add <16 x i8> [[I0]], [[I1]]
; CHECK-NEXT:    ret <16 x i8> [[R]]
;
  %i0 = insertelement <16 x i8> undef, i8 %x, i32 1
  %i1 = insertelement <16 x i8> undef, i8 %y, i32 0
  %r = add <16 x i8> %i0, %i1
  ret <16 x i8> %r
}

; Base vector does not have to be undef.

define <4 x i32> @ins0_ins0_mul(i32 %x, i32 %y) {
; CHECK-LABEL: @ins0_ins0_mul(
; CHECK-NEXT:    [[R_SCALAR:%.*]] = mul i32 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x i32> zeroinitializer, i32 [[R_SCALAR]], i64 0
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %i0 = insertelement <4 x i32> zeroinitializer, i32 %x, i32 0
  %i1 = insertelement <4 x i32> undef, i32 %y, i32 0
  %r = mul <4 x i32> %i0, %i1
  ret <4 x i32> %r
}

; It is safe to scalarize any binop (no extra UB/poison danger).

define <2 x i64> @ins1_ins1_sdiv(i64 %x, i64 %y) {
; CHECK-LABEL: @ins1_ins1_sdiv(
; CHECK-NEXT:    [[R_SCALAR:%.*]] = sdiv i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <2 x i64> <i64 -6, i64 0>, i64 [[R_SCALAR]], i64 1
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %i0 = insertelement <2 x i64> <i64 42, i64 -42>, i64 %x, i64 1
  %i1 = insertelement <2 x i64> <i64 -7, i64 128>, i64 %y, i32 1
  %r = sdiv <2 x i64> %i0, %i1
  ret <2 x i64> %r
}

; Constant folding deals with undef per element - the entire value does not become undef.

define <2 x i64> @ins1_ins1_udiv(i64 %x, i64 %y) {
; CHECK-LABEL: @ins1_ins1_udiv(
; CHECK-NEXT:    [[R_SCALAR:%.*]] = udiv i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <2 x i64> <i64 6, i64 poison>, i64 [[R_SCALAR]], i64 1
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %i0 = insertelement <2 x i64> <i64 42, i64 undef>, i64 %x, i32 1
  %i1 = insertelement <2 x i64> <i64 7, i64 undef>, i64 %y, i32 1
  %r = udiv <2 x i64> %i0, %i1
  ret <2 x i64> %r
}

; This could be simplified -- creates immediate UB without the transform because
; divisor has an undef element -- but that is hidden after the transform.

define <2 x i64> @ins1_ins1_urem(i64 %x, i64 %y) {
; CHECK-LABEL: @ins1_ins1_urem(
; CHECK-NEXT:    [[R_SCALAR:%.*]] = urem i64 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <2 x i64> <i64 poison, i64 0>, i64 [[R_SCALAR]], i64 1
; CHECK-NEXT:    ret <2 x i64> [[R]]
;
  %i0 = insertelement <2 x i64> <i64 42, i64 undef>, i64 %x, i64 1
  %i1 = insertelement <2 x i64> <i64 undef, i64 128>, i64 %y, i32 1
  %r = urem <2 x i64> %i0, %i1
  ret <2 x i64> %r
}

; Extra use is accounted for in cost calculation.

define <4 x i32> @ins0_ins0_xor(i32 %x, i32 %y) {
; CHECK-LABEL: @ins0_ins0_xor(
; CHECK-NEXT:    [[I0:%.*]] = insertelement <4 x i32> undef, i32 [[X:%.*]], i32 0
; CHECK-NEXT:    call void @use(<4 x i32> [[I0]])
; CHECK-NEXT:    [[R_SCALAR:%.*]] = xor i32 [[X]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x i32> zeroinitializer, i32 [[R_SCALAR]], i64 0
; CHECK-NEXT:    ret <4 x i32> [[R]]
;
  %i0 = insertelement <4 x i32> undef, i32 %x, i32 0
  call void @use(<4 x i32> %i0)
  %i1 = insertelement <4 x i32> undef, i32 %y, i32 0
  %r = xor <4 x i32> %i0, %i1
  ret <4 x i32> %r
}

; Extra use is accounted for in cost calculation.

define <4 x float> @ins1_ins1_fmul(float %x, float %y) {
; CHECK-LABEL: @ins1_ins1_fmul(
; CHECK-NEXT:    [[I1:%.*]] = insertelement <4 x float> undef, float [[Y:%.*]], i32 1
; CHECK-NEXT:    call void @usef(<4 x float> [[I1]])
; CHECK-NEXT:    [[R_SCALAR:%.*]] = fmul float [[X:%.*]], [[Y]]
; CHECK-NEXT:    [[R:%.*]] = insertelement <4 x float> undef, float [[R_SCALAR]], i64 1
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %i0 = insertelement <4 x float> undef, float %x, i32 1
  %i1 = insertelement <4 x float> undef, float %y, i32 1
  call void @usef(<4 x float> %i1)
  %r = fmul <4 x float> %i0, %i1
  ret <4 x float> %r
}

; If the scalar binop is not cheaper than the vector binop, extra uses can prevent the transform.

define <4 x float> @ins2_ins2_fsub(float %x, float %y) {
; CHECK-LABEL: @ins2_ins2_fsub(
; CHECK-NEXT:    [[I0:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 2
; CHECK-NEXT:    call void @usef(<4 x float> [[I0]])
; CHECK-NEXT:    [[I1:%.*]] = insertelement <4 x float> undef, float [[Y:%.*]], i32 2
; CHECK-NEXT:    call void @usef(<4 x float> [[I1]])
; CHECK-NEXT:    [[R:%.*]] = fsub <4 x float> [[I0]], [[I1]]
; CHECK-NEXT:    ret <4 x float> [[R]]
;
  %i0 = insertelement <4 x float> undef, float %x, i32 2
  call void @usef(<4 x float> %i0)
  %i1 = insertelement <4 x float> undef, float %y, i32 2
  call void @usef(<4 x float> %i1)
  %r = fsub <4 x float> %i0, %i1
  ret <4 x float> %r
}

; It may be worth scalarizing an expensive binop even if both inserts have extra uses.

define <4 x float> @ins3_ins3_fdiv(float %x, float %y) {
; SSE-LABEL: @ins3_ins3_fdiv(
; SSE-NEXT:    [[I0:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 3
; SSE-NEXT:    call void @usef(<4 x float> [[I0]])
; SSE-NEXT:    [[I1:%.*]] = insertelement <4 x float> undef, float [[Y:%.*]], i32 3
; SSE-NEXT:    call void @usef(<4 x float> [[I1]])
; SSE-NEXT:    [[R_SCALAR:%.*]] = fdiv float [[X]], [[Y]]
; SSE-NEXT:    [[R:%.*]] = insertelement <4 x float> undef, float [[R_SCALAR]], i64 3
; SSE-NEXT:    ret <4 x float> [[R]]
;
; AVX-LABEL: @ins3_ins3_fdiv(
; AVX-NEXT:    [[I0:%.*]] = insertelement <4 x float> undef, float [[X:%.*]], i32 3
; AVX-NEXT:    call void @usef(<4 x float> [[I0]])
; AVX-NEXT:    [[I1:%.*]] = insertelement <4 x float> undef, float [[Y:%.*]], i32 3
; AVX-NEXT:    call void @usef(<4 x float> [[I1]])
; AVX-NEXT:    [[R:%.*]] = fdiv <4 x float> [[I0]], [[I1]]
; AVX-NEXT:    ret <4 x float> [[R]]
;
  %i0 = insertelement <4 x float> undef, float %x, i32 3
  call void @usef(<4 x float> %i0)
  %i1 = insertelement <4 x float> undef, float %y, i32 3
  call void @usef(<4 x float> %i1)
  %r = fdiv <4 x float> %i0, %i1
  ret <4 x float> %r
}
