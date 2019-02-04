; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S -mtriple "i386-pc-linux"     | FileCheck %s
; RUN: opt < %s -instcombine -S -mtriple "i386-pc-win32"     | FileCheck %s
; RUN: opt < %s -instcombine -S -mtriple "x86_64-pc-win32"   | FileCheck %s
; RUN: opt < %s -instcombine -S -mtriple "i386-pc-mingw32"   | FileCheck %s
; RUN: opt < %s -instcombine -S -mtriple "x86_64-pc-mingw32" | FileCheck %s
; RUN: opt < %s -instcombine -S -mtriple "sparc-sun-solaris" | FileCheck %s
; RUN: opt < %s -instcombine -S -mtriple "x86_64-pc-win32" -enable-debugify 2>&1 | FileCheck --check-prefix=DBG-VALID %s

declare double @floor(double)
declare double @ceil(double)
declare double @round(double)
declare double @nearbyint(double)
declare double @trunc(double)
declare double @fabs(double)

declare double @llvm.ceil.f64(double)
declare <2 x double> @llvm.ceil.v2f64(<2 x double>)

declare double @llvm.fabs.f64(double)
declare <2 x double> @llvm.fabs.v2f64(<2 x double>)

declare double @llvm.floor.f64(double)
declare <2 x double> @llvm.floor.v2f64(<2 x double>)

declare double @llvm.nearbyint.f64(double)
declare <2 x double> @llvm.nearbyint.v2f64(<2 x double>)

declare float @llvm.rint.f32(float)
declare <2 x float> @llvm.rint.v2f32(<2 x float>)

declare double @llvm.round.f64(double)
declare <2 x double> @llvm.round.v2f64(<2 x double>)

declare double @llvm.trunc.f64(double)
declare <2 x double> @llvm.trunc.v2f64(<2 x double>)

define float @test_shrink_libcall_floor(float %C) {
; CHECK-LABEL: @test_shrink_libcall_floor(
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.floor.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext float %C to double
  ; --> floorf
  %E = call double @floor(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_libcall_ceil(float %C) {
; CHECK-LABEL: @test_shrink_libcall_ceil(
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.ceil.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext float %C to double
  ; --> ceilf
  %E = call double @ceil(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_libcall_round(float %C) {
; CHECK-LABEL: @test_shrink_libcall_round(
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.round.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext float %C to double
  ; --> roundf
  %E = call double @round(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_libcall_nearbyint(float %C) {
; CHECK-LABEL: @test_shrink_libcall_nearbyint(
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.nearbyint.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext float %C to double
  ; --> nearbyintf
  %E = call double @nearbyint(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_libcall_trunc(float %C) {
; CHECK-LABEL: @test_shrink_libcall_trunc(
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.trunc.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext float %C to double
  ; --> truncf
  %E = call double @trunc(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

; This is replaced with the intrinsic, which does the right thing on
; CHECK platforms.
define float @test_shrink_libcall_fabs(float %C) {
; CHECK-LABEL: @test_shrink_libcall_fabs(
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.fabs.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext float %C to double
  %E = call double @fabs(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

; Make sure fast math flags are preserved
define float @test_shrink_libcall_fabs_fast(float %C) {
; CHECK-LABEL: @test_shrink_libcall_fabs_fast(
; CHECK-NEXT:    [[F:%.*]] = call fast float @llvm.fabs.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext float %C to double
  %E = call fast double @fabs(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_intrin_ceil(float %C) {
; CHECK-LABEL: @test_shrink_intrin_ceil(
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.ceil.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %D = fpext float %C to double
  %E = call double @llvm.ceil.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_intrin_fabs(float %C) {
; CHECK-LABEL: @test_shrink_intrin_fabs(
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.fabs.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %D = fpext float %C to double
  %E = call double @llvm.fabs.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_intrin_floor(float %C) {
; CHECK-LABEL: @test_shrink_intrin_floor(
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.floor.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %D = fpext float %C to double
  %E = call double @llvm.floor.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_intrin_nearbyint(float %C) {
; CHECK-LABEL: @test_shrink_intrin_nearbyint(
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.nearbyint.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %D = fpext float %C to double
  %E = call double @llvm.nearbyint.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define half @test_shrink_intrin_rint(half %C) {
; CHECK-LABEL: @test_shrink_intrin_rint(
; CHECK-NEXT:    [[TMP1:%.*]] = call half @llvm.rint.f16(half [[C:%.*]])
; CHECK-NEXT:    ret half [[TMP1]]
;
  %D = fpext half %C to float
  %E = call float @llvm.rint.f32(float %D)
  %F = fptrunc float %E to half
  ret half %F
}

define float @test_shrink_intrin_round(float %C) {
; CHECK-LABEL: @test_shrink_intrin_round(
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.round.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %D = fpext float %C to double
  %E = call double @llvm.round.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_intrin_trunc(float %C) {
; CHECK-LABEL: @test_shrink_intrin_trunc(
; CHECK-NEXT:    [[TMP1:%.*]] = call float @llvm.trunc.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %D = fpext float %C to double
  %E = call double @llvm.trunc.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

declare void @use_v2f64(<2 x double>)
declare void @use_v2f32(<2 x float>)

define <2 x float> @test_shrink_intrin_ceil_multi_use(<2 x float> %C) {
; CHECK-LABEL: @test_shrink_intrin_ceil_multi_use(
; CHECK-NEXT:    [[D:%.*]] = fpext <2 x float> [[C:%.*]] to <2 x double>
; CHECK-NEXT:    [[E:%.*]] = call <2 x double> @llvm.ceil.v2f64(<2 x double> [[D]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc <2 x double> [[E]] to <2 x float>
; CHECK-NEXT:    call void @use_v2f64(<2 x double> [[D]])
; CHECK-NEXT:    ret <2 x float> [[F]]
;
  %D = fpext <2 x float> %C to <2 x double>
  %E = call <2 x double> @llvm.ceil.v2f64(<2 x double> %D)
  %F = fptrunc <2 x double> %E to <2 x float>
  call void @use_v2f64(<2 x double> %D)
  ret <2 x float> %F
}

define <2 x float> @test_shrink_intrin_fabs_multi_use(<2 x float> %C) {
; CHECK-LABEL: @test_shrink_intrin_fabs_multi_use(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x float> @llvm.fabs.v2f32(<2 x float> [[C:%.*]])
; CHECK-NEXT:    [[E:%.*]] = fpext <2 x float> [[TMP1]] to <2 x double>
; CHECK-NEXT:    call void @use_v2f64(<2 x double> [[E]])
; CHECK-NEXT:    ret <2 x float> [[TMP1]]
;
  %D = fpext <2 x float> %C to <2 x double>
  %E = call <2 x double> @llvm.fabs.v2f64(<2 x double> %D)
  %F = fptrunc <2 x double> %E to <2 x float>
  call void @use_v2f64(<2 x double> %E)
  ret <2 x float> %F
}

define <2 x float> @test_shrink_intrin_floor_multi_use(<2 x float> %C) {
; CHECK-LABEL: @test_shrink_intrin_floor_multi_use(
; CHECK-NEXT:    [[D:%.*]] = fpext <2 x float> [[C:%.*]] to <2 x double>
; CHECK-NEXT:    [[E:%.*]] = call <2 x double> @llvm.floor.v2f64(<2 x double> [[D]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc <2 x double> [[E]] to <2 x float>
; CHECK-NEXT:    call void @use_v2f64(<2 x double> [[D]])
; CHECK-NEXT:    call void @use_v2f64(<2 x double> [[E]])
; CHECK-NEXT:    ret <2 x float> [[F]]
;
  %D = fpext <2 x float> %C to <2 x double>
  %E = call <2 x double> @llvm.floor.v2f64(<2 x double> %D)
  %F = fptrunc <2 x double> %E to <2 x float>
  call void @use_v2f64(<2 x double> %D)
  call void @use_v2f64(<2 x double> %E)
  ret <2 x float> %F
}

define <2 x float> @test_shrink_intrin_nearbyint_multi_use(<2 x float> %C) {
; CHECK-LABEL: @test_shrink_intrin_nearbyint_multi_use(
; CHECK-NEXT:    [[D:%.*]] = fpext <2 x float> [[C:%.*]] to <2 x double>
; CHECK-NEXT:    [[E:%.*]] = call <2 x double> @llvm.nearbyint.v2f64(<2 x double> [[D]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc <2 x double> [[E]] to <2 x float>
; CHECK-NEXT:    call void @use_v2f64(<2 x double> [[D]])
; CHECK-NEXT:    ret <2 x float> [[F]]
;
  %D = fpext <2 x float> %C to <2 x double>
  %E = call <2 x double> @llvm.nearbyint.v2f64(<2 x double> %D)
  %F = fptrunc <2 x double> %E to <2 x float>
  call void @use_v2f64(<2 x double> %D)
  ret <2 x float> %F
}

define <2 x half> @test_shrink_intrin_rint_multi_use(<2 x half> %C) {
; CHECK-LABEL: @test_shrink_intrin_rint_multi_use(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x half> @llvm.rint.v2f16(<2 x half> [[C:%.*]])
; CHECK-NEXT:    [[E:%.*]] = fpext <2 x half> [[TMP1]] to <2 x float>
; CHECK-NEXT:    call void @use_v2f32(<2 x float> [[E]])
; CHECK-NEXT:    ret <2 x half> [[TMP1]]
;
  %D = fpext <2 x half> %C to <2 x float>
  %E = call <2 x float> @llvm.rint.v2f32(<2 x float> %D)
  %F = fptrunc <2 x float> %E to <2 x half>
  call void @use_v2f32(<2 x float> %E)
  ret <2 x half> %F
}

define <2 x float> @test_shrink_intrin_round_multi_use(<2 x float> %C) {
; CHECK-LABEL: @test_shrink_intrin_round_multi_use(
; CHECK-NEXT:    [[D:%.*]] = fpext <2 x float> [[C:%.*]] to <2 x double>
; CHECK-NEXT:    [[E:%.*]] = call <2 x double> @llvm.round.v2f64(<2 x double> [[D]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc <2 x double> [[E]] to <2 x float>
; CHECK-NEXT:    call void @use_v2f64(<2 x double> [[D]])
; CHECK-NEXT:    call void @use_v2f64(<2 x double> [[E]])
; CHECK-NEXT:    ret <2 x float> [[F]]
;
  %D = fpext <2 x float> %C to <2 x double>
  %E = call <2 x double> @llvm.round.v2f64(<2 x double> %D)
  %F = fptrunc <2 x double> %E to <2 x float>
  call void @use_v2f64(<2 x double> %D)
  call void @use_v2f64(<2 x double> %E)
  ret <2 x float> %F
}

define <2 x float> @test_shrink_intrin_trunc_multi_use(<2 x float> %C) {
; CHECK-LABEL: @test_shrink_intrin_trunc_multi_use(
; CHECK-NEXT:    [[D:%.*]] = fpext <2 x float> [[C:%.*]] to <2 x double>
; CHECK-NEXT:    [[E:%.*]] = call <2 x double> @llvm.trunc.v2f64(<2 x double> [[D]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc <2 x double> [[E]] to <2 x float>
; CHECK-NEXT:    call void @use_v2f64(<2 x double> [[D]])
; CHECK-NEXT:    ret <2 x float> [[F]]
;
  %D = fpext <2 x float> %C to <2 x double>
  %E = call <2 x double> @llvm.trunc.v2f64(<2 x double> %D)
  %F = fptrunc <2 x double> %E to <2 x float>
  call void @use_v2f64(<2 x double> %D)
  ret <2 x float> %F
}

; Make sure fast math flags are preserved
define float @test_shrink_intrin_fabs_fast(float %C) {
; CHECK-LABEL: @test_shrink_intrin_fabs_fast(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast float @llvm.fabs.f32(float [[C:%.*]])
; CHECK-NEXT:    ret float [[TMP1]]
;
  %D = fpext float %C to double
  %E = call fast double @llvm.fabs.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_no_shrink_intrin_floor(double %D) {
; CHECK-LABEL: @test_no_shrink_intrin_floor(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.floor.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %E = call double @llvm.floor.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_no_shrink_intrin_ceil(double %D) {
; CHECK-LABEL: @test_no_shrink_intrin_ceil(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.ceil.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %E = call double @llvm.ceil.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_no_shrink_intrin_round(double %D) {
; CHECK-LABEL: @test_no_shrink_intrin_round(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.round.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %E = call double @llvm.round.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_no_shrink_intrin_nearbyint(double %D) {
; CHECK-LABEL: @test_no_shrink_intrin_nearbyint(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.nearbyint.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %E = call double @llvm.nearbyint.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_no_shrink_intrin_trunc(double %D) {
; CHECK-LABEL: @test_no_shrink_intrin_trunc(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.trunc.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %E = call double @llvm.trunc.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_intrin_fabs_double_src(double %D) {
; CHECK-LABEL: @test_shrink_intrin_fabs_double_src(
; CHECK-NEXT:    [[TMP1:%.*]] = fptrunc double [[D:%.*]] to float
; CHECK-NEXT:    [[F:%.*]] = call float @llvm.fabs.f32(float [[TMP1]])
; CHECK-NEXT:    ret float [[F]]
;
  %E = call double @llvm.fabs.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

; Make sure fast math flags are preserved
define float @test_shrink_intrin_fabs_fast_double_src(double %D) {
; CHECK-LABEL: @test_shrink_intrin_fabs_fast_double_src(
; CHECK-NEXT:    [[TMP1:%.*]] = fptrunc double [[D:%.*]] to float
; CHECK-NEXT:    [[F:%.*]] = call fast float @llvm.fabs.f32(float [[TMP1]])
; CHECK-NEXT:    ret float [[F]]
;
  %E = call fast double @llvm.fabs.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_float_convertible_constant_intrin_floor() {
; CHECK-LABEL: @test_shrink_float_convertible_constant_intrin_floor(
; CHECK-NEXT:    ret float 2.000000e+00
;
  %E = call double @llvm.floor.f64(double 2.1)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_float_convertible_constant_intrin_ceil() {
; CHECK-LABEL: @test_shrink_float_convertible_constant_intrin_ceil(
; CHECK-NEXT:    ret float 3.000000e+00
;
  %E = call double @llvm.ceil.f64(double 2.1)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_float_convertible_constant_intrin_round() {
; CHECK-LABEL: @test_shrink_float_convertible_constant_intrin_round(
; CHECK-NEXT:    ret float 2.000000e+00
;
  %E = call double @llvm.round.f64(double 2.1)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_float_convertible_constant_intrin_nearbyint() {
; CHECK-LABEL: @test_shrink_float_convertible_constant_intrin_nearbyint(
; CHECK-NEXT:    ret float 2.000000e+00
;
  %E = call double @llvm.nearbyint.f64(double 2.1)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_float_convertible_constant_intrin_trunc() {
; CHECK-LABEL: @test_shrink_float_convertible_constant_intrin_trunc(
; CHECK-NEXT:    ret float 2.000000e+00
;
  %E = call double @llvm.trunc.f64(double 2.1)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_shrink_float_convertible_constant_intrin_fabs() {
; CHECK-LABEL: @test_shrink_float_convertible_constant_intrin_fabs(
; CHECK-NEXT:    ret float 0x4000CCCCC0000000
;
  %E = call double @llvm.fabs.f64(double 2.1)
  %F = fptrunc double %E to float
  ret float %F
}

; Make sure fast math flags are preserved
define float @test_shrink_float_convertible_constant_intrin_fabs_fast() {
; CHECK-LABEL: @test_shrink_float_convertible_constant_intrin_fabs_fast(
; CHECK-NEXT:    ret float 0x4000CCCCC0000000
;
  %E = call fast double @llvm.fabs.f64(double 2.1)
  %F = fptrunc double %E to float
  ret float %F
}

define half @test_no_shrink_mismatched_type_intrin_floor(double %D) {
; CHECK-LABEL: @test_no_shrink_mismatched_type_intrin_floor(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.floor.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to half
; CHECK-NEXT:    ret half [[F]]
;
  %E = call double @llvm.floor.f64(double %D)
  %F = fptrunc double %E to half
  ret half %F
}

define half @test_no_shrink_mismatched_type_intrin_ceil(double %D) {
; CHECK-LABEL: @test_no_shrink_mismatched_type_intrin_ceil(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.ceil.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to half
; CHECK-NEXT:    ret half [[F]]
;
  %E = call double @llvm.ceil.f64(double %D)
  %F = fptrunc double %E to half
  ret half %F
}

define half @test_no_shrink_mismatched_type_intrin_round(double %D) {
; CHECK-LABEL: @test_no_shrink_mismatched_type_intrin_round(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.round.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to half
; CHECK-NEXT:    ret half [[F]]
;
  %E = call double @llvm.round.f64(double %D)
  %F = fptrunc double %E to half
  ret half %F
}

define half @test_no_shrink_mismatched_type_intrin_nearbyint(double %D) {
; CHECK-LABEL: @test_no_shrink_mismatched_type_intrin_nearbyint(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.nearbyint.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to half
; CHECK-NEXT:    ret half [[F]]
;
  %E = call double @llvm.nearbyint.f64(double %D)
  %F = fptrunc double %E to half
  ret half %F
}

define half @test_no_shrink_mismatched_type_intrin_trunc(double %D) {
; CHECK-LABEL: @test_no_shrink_mismatched_type_intrin_trunc(
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.trunc.f64(double [[D:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to half
; CHECK-NEXT:    ret half [[F]]
;
  %E = call double @llvm.trunc.f64(double %D)
  %F = fptrunc double %E to half
  ret half %F
}

define half @test_shrink_mismatched_type_intrin_fabs_double_src(double %D) {
; CHECK-LABEL: @test_shrink_mismatched_type_intrin_fabs_double_src(
; CHECK-NEXT:    [[TMP1:%.*]] = fptrunc double [[D:%.*]] to half
; CHECK-NEXT:    [[F:%.*]] = call half @llvm.fabs.f16(half [[TMP1]])
; CHECK-NEXT:    ret half [[F]]
;
  %E = call double @llvm.fabs.f64(double %D)
  %F = fptrunc double %E to half
  ret half %F
}

; Make sure fast math flags are preserved
define half @test_mismatched_type_intrin_fabs_fast_double_src(double %D) {
; CHECK-LABEL: @test_mismatched_type_intrin_fabs_fast_double_src(
; CHECK-NEXT:    [[TMP1:%.*]] = fptrunc double [[D:%.*]] to half
; CHECK-NEXT:    [[F:%.*]] = call fast half @llvm.fabs.f16(half [[TMP1]])
; CHECK-NEXT:    ret half [[F]]
;
  %E = call fast double @llvm.fabs.f64(double %D)
  %F = fptrunc double %E to half
  ret half %F
}

define <2 x double> @test_shrink_intrin_floor_fp16_vec(<2 x half> %C) {
; CHECK-LABEL: @test_shrink_intrin_floor_fp16_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call arcp <2 x half> @llvm.floor.v2f16(<2 x half> [[C:%.*]])
; CHECK-NEXT:    [[E:%.*]] = fpext <2 x half> [[TMP1]] to <2 x double>
; CHECK-NEXT:    ret <2 x double> [[E]]
;
  %D = fpext <2 x half> %C to <2 x double>
  %E = call arcp <2 x double> @llvm.floor.v2f64(<2 x double> %D)
  ret <2 x double> %E
}

define float @test_shrink_intrin_ceil_fp16_src(half %C) {
; CHECK-LABEL: @test_shrink_intrin_ceil_fp16_src(
; CHECK-NEXT:    [[TMP1:%.*]] = call half @llvm.ceil.f16(half [[C:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fpext half [[TMP1]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext half %C to double
  %E = call double @llvm.ceil.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define <2 x double> @test_shrink_intrin_round_fp16_vec(<2 x half> %C) {
; CHECK-LABEL: @test_shrink_intrin_round_fp16_vec(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x half> @llvm.round.v2f16(<2 x half> [[C:%.*]])
; CHECK-NEXT:    [[E:%.*]] = fpext <2 x half> [[TMP1]] to <2 x double>
; CHECK-NEXT:    ret <2 x double> [[E]]
;
  %D = fpext <2 x  half> %C to <2 x double>
  %E = call <2 x double> @llvm.round.v2f64(<2 x double> %D)
  ret <2 x double> %E
}

define float @test_shrink_intrin_nearbyint_fp16_src(half %C) {
; CHECK-LABEL: @test_shrink_intrin_nearbyint_fp16_src(
; CHECK-NEXT:    [[TMP1:%.*]] = call half @llvm.nearbyint.f16(half [[C:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fpext half [[TMP1]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext half %C to double
  %E = call double @llvm.nearbyint.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define <2 x double> @test_shrink_intrin_trunc_fp16_src(<2 x half> %C) {
; CHECK-LABEL: @test_shrink_intrin_trunc_fp16_src(
; CHECK-NEXT:    [[TMP1:%.*]] = call <2 x half> @llvm.trunc.v2f16(<2 x half> [[C:%.*]])
; CHECK-NEXT:    [[E:%.*]] = fpext <2 x half> [[TMP1]] to <2 x double>
; CHECK-NEXT:    ret <2 x double> [[E]]
;
  %D = fpext <2 x half> %C to <2 x double>
  %E = call <2 x double> @llvm.trunc.v2f64(<2 x double> %D)
  ret <2 x double> %E
}

define float @test_shrink_intrin_fabs_fp16_src(half %C) {
; CHECK-LABEL: @test_shrink_intrin_fabs_fp16_src(
; CHECK-NEXT:    [[TMP1:%.*]] = call half @llvm.fabs.f16(half [[C:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fpext half [[TMP1]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext half %C to double
  %E = call double @llvm.fabs.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

; Make sure fast math flags are preserved
define float @test_shrink_intrin_fabs_fast_fp16_src(half %C) {
; CHECK-LABEL: @test_shrink_intrin_fabs_fast_fp16_src(
; CHECK-NEXT:    [[TMP1:%.*]] = call fast half @llvm.fabs.f16(half [[C:%.*]])
; CHECK-NEXT:    [[F:%.*]] = fpext half [[TMP1]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext half %C to double
  %E = call fast double @llvm.fabs.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_no_shrink_intrin_floor_multi_use_fpext(half %C) {
; CHECK-LABEL: @test_no_shrink_intrin_floor_multi_use_fpext(
; CHECK-NEXT:    [[D:%.*]] = fpext half [[C:%.*]] to double
; CHECK-NEXT:    store volatile double [[D]], double* undef, align 8
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.floor.f64(double [[D]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext half %C to double
  store volatile double %D, double* undef
  %E = call double @llvm.floor.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

define float @test_no_shrink_intrin_fabs_multi_use_fpext(half %C) {
; CHECK-LABEL: @test_no_shrink_intrin_fabs_multi_use_fpext(
; CHECK-NEXT:    [[D:%.*]] = fpext half [[C:%.*]] to double
; CHECK-NEXT:    store volatile double [[D]], double* undef, align 8
; CHECK-NEXT:    [[E:%.*]] = call double @llvm.fabs.f64(double [[D]])
; CHECK-NEXT:    [[F:%.*]] = fptrunc double [[E]] to float
; CHECK-NEXT:    ret float [[F]]
;
  %D = fpext half %C to double
  store volatile double %D, double* undef
  %E = call double @llvm.fabs.f64(double %D)
  %F = fptrunc double %E to float
  ret float %F
}

; DBG-VALID: CheckModuleDebugify: PASS
