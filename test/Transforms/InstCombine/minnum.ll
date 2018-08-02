; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine < %s | FileCheck %s

declare float @llvm.minnum.f32(float, float)
declare float @llvm.minnum.v2f32(<2 x float>, <2 x float>)
declare <4 x float> @llvm.minnum.v4f32(<4 x float>, <4 x float>)

declare double @llvm.minnum.f64(double, double)
declare <2 x double> @llvm.minnum.v2f64(<2 x double>, <2 x double>)

declare float @llvm.maxnum.f32(float, float)

define float @constant_fold_minnum_f32() {
; CHECK-LABEL: @constant_fold_minnum_f32(
; CHECK-NEXT:    ret float 1.000000e+00
;
  %x = call float @llvm.minnum.f32(float 1.0, float 2.0)
  ret float %x
}

define float @constant_fold_minnum_f32_inv() {
; CHECK-LABEL: @constant_fold_minnum_f32_inv(
; CHECK-NEXT:    ret float 1.000000e+00
;
  %x = call float @llvm.minnum.f32(float 2.0, float 1.0)
  ret float %x
}

define float @constant_fold_minnum_f32_nan0() {
; CHECK-LABEL: @constant_fold_minnum_f32_nan0(
; CHECK-NEXT:    ret float 2.000000e+00
;
  %x = call float @llvm.minnum.f32(float 0x7FF8000000000000, float 2.0)
  ret float %x
}

define float @constant_fold_minnum_f32_nan1() {
; CHECK-LABEL: @constant_fold_minnum_f32_nan1(
; CHECK-NEXT:    ret float 2.000000e+00
;
  %x = call float @llvm.minnum.f32(float 2.0, float 0x7FF8000000000000)
  ret float %x
}

define float @constant_fold_minnum_f32_nan_nan() {
; CHECK-LABEL: @constant_fold_minnum_f32_nan_nan(
; CHECK-NEXT:    ret float 0x7FF8000000000000
;
  %x = call float @llvm.minnum.f32(float 0x7FF8000000000000, float 0x7FF8000000000000)
  ret float %x
}

define float @constant_fold_minnum_f32_p0_p0() {
; CHECK-LABEL: @constant_fold_minnum_f32_p0_p0(
; CHECK-NEXT:    ret float 0.000000e+00
;
  %x = call float @llvm.minnum.f32(float 0.0, float 0.0)
  ret float %x
}

define float @constant_fold_minnum_f32_p0_n0() {
; CHECK-LABEL: @constant_fold_minnum_f32_p0_n0(
; CHECK-NEXT:    ret float 0.000000e+00
;
  %x = call float @llvm.minnum.f32(float 0.0, float -0.0)
  ret float %x
}

define float @constant_fold_minnum_f32_n0_p0() {
; CHECK-LABEL: @constant_fold_minnum_f32_n0_p0(
; CHECK-NEXT:    ret float -0.000000e+00
;
  %x = call float @llvm.minnum.f32(float -0.0, float 0.0)
  ret float %x
}

define float @constant_fold_minnum_f32_n0_n0() {
; CHECK-LABEL: @constant_fold_minnum_f32_n0_n0(
; CHECK-NEXT:    ret float -0.000000e+00
;
  %x = call float @llvm.minnum.f32(float -0.0, float -0.0)
  ret float %x
}

define <4 x float> @constant_fold_minnum_v4f32() {
; CHECK-LABEL: @constant_fold_minnum_v4f32(
; CHECK-NEXT:    ret <4 x float> <float 1.000000e+00, float 2.000000e+00, float 3.000000e+00, float 5.000000e+00>
;
  %x = call <4 x float> @llvm.minnum.v4f32(<4 x float> <float 1.0, float 8.0, float 3.0, float 9.0>, <4 x float> <float 2.0, float 2.0, float 10.0, float 5.0>)
  ret <4 x float> %x
}

define double @constant_fold_minnum_f64() {
; CHECK-LABEL: @constant_fold_minnum_f64(
; CHECK-NEXT:    ret double 1.000000e+00
;
  %x = call double @llvm.minnum.f64(double 1.0, double 2.0)
  ret double %x
}

define double @constant_fold_minnum_f64_nan0() {
; CHECK-LABEL: @constant_fold_minnum_f64_nan0(
; CHECK-NEXT:    ret double 2.000000e+00
;
  %x = call double @llvm.minnum.f64(double 0x7FF8000000000000, double 2.0)
  ret double %x
}

define double @constant_fold_minnum_f64_nan1() {
; CHECK-LABEL: @constant_fold_minnum_f64_nan1(
; CHECK-NEXT:    ret double 2.000000e+00
;
  %x = call double @llvm.minnum.f64(double 2.0, double 0x7FF8000000000000)
  ret double %x
}

define double @constant_fold_minnum_f64_nan_nan() {
; CHECK-LABEL: @constant_fold_minnum_f64_nan_nan(
; CHECK-NEXT:    ret double 0x7FF8000000000000
;
  %x = call double @llvm.minnum.f64(double 0x7FF8000000000000, double 0x7FF8000000000000)
  ret double %x
}

define float @canonicalize_constant_minnum_f32(float %x) {
; CHECK-LABEL: @canonicalize_constant_minnum_f32(
; CHECK-NEXT:    [[Y:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float 1.000000e+00)
; CHECK-NEXT:    ret float [[Y]]
;
  %y = call float @llvm.minnum.f32(float 1.0, float %x)
  ret float %y
}

define float @minnum_f32_nan_val(float %x) {
; CHECK-LABEL: @minnum_f32_nan_val(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %y = call float @llvm.minnum.f32(float 0x7FF8000000000000, float %x)
  ret float %y
}

define float @minnum_f32_val_nan(float %x) {
; CHECK-LABEL: @minnum_f32_val_nan(
; CHECK-NEXT:    ret float [[X:%.*]]
;
  %y = call float @llvm.minnum.f32(float %x, float 0x7FF8000000000000)
  ret float %y
}

define float @fold_minnum_f32_undef_undef(float %x) {
; CHECK-LABEL: @fold_minnum_f32_undef_undef(
; CHECK-NEXT:    ret float undef
;
  %val = call float @llvm.minnum.f32(float undef, float undef)
  ret float %val
}

define float @minnum_x_minnum_x_y(float %x, float %y) {
; CHECK-LABEL: @minnum_x_minnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %x, float %a)
  ret float %b
}

define float @minnum_y_minnum_x_y(float %x, float %y) {
; CHECK-LABEL: @minnum_y_minnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    ret float [[A]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %y, float %a)
  ret float %b
}

define float @minnum_z_minnum_x_y(float %x, float %y, float %z) {
; CHECK-LABEL: @minnum_z_minnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.minnum.f32(float [[Z:%.*]], float [[A]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %z, float %a)
  ret float %b
}

define float @minnum_minnum_x_y_z(float %x, float %y, float %z) {
; CHECK-LABEL: @minnum_minnum_x_y_z(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.minnum.f32(float [[A]], float [[Z:%.*]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %a, float %z)
  ret float %b
}

define float @minnum4(float %x, float %y, float %z, float %w) {
; CHECK-LABEL: @minnum4(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.minnum.f32(float [[Z:%.*]], float [[W:%.*]])
; CHECK-NEXT:    [[C:%.*]] = call float @llvm.minnum.f32(float [[A]], float [[B]])
; CHECK-NEXT:    ret float [[C]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %z, float %w)
  %c = call float @llvm.minnum.f32(float %a, float %b)
  ret float %c
}

define float @minnum_x_maxnum_x_y(float %x, float %y) {
; CHECK-LABEL: @minnum_x_maxnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.maxnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.minnum.f32(float [[X]], float [[A]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.maxnum.f32(float %x, float %y)
  %b = call float @llvm.minnum.f32(float %x, float %a)
  ret float %b
}

define float @maxnum_x_minnum_x_y(float %x, float %y) {
; CHECK-LABEL: @maxnum_x_minnum_x_y(
; CHECK-NEXT:    [[A:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float [[Y:%.*]])
; CHECK-NEXT:    [[B:%.*]] = call float @llvm.maxnum.f32(float [[X]], float [[A]])
; CHECK-NEXT:    ret float [[B]]
;
  %a = call float @llvm.minnum.f32(float %x, float %y)
  %b = call float @llvm.maxnum.f32(float %x, float %a)
  ret float %b
}

define float @fold_minnum_f32_inf_val(float %x) {
; CHECK-LABEL: @fold_minnum_f32_inf_val(
; CHECK-NEXT:    [[VAL:%.*]] = call float @llvm.minnum.f32(float [[X:%.*]], float 0x7FF0000000000000)
; CHECK-NEXT:    ret float [[VAL]]
;
  %val = call float @llvm.minnum.f32(float 0x7FF0000000000000, float %x)
  ret float %val
}

define float @fold_minnum_f32_minf_val(float %x) {
; CHECK-LABEL: @fold_minnum_f32_minf_val(
; CHECK-NEXT:    ret float 0xFFF0000000000000
;
  %val = call float @llvm.minnum.f32(float 0xFFF0000000000000, float %x)
  ret float %val
}

; PR37405 - https://bugs.llvm.org/show_bug.cgi?id=37405

define double @neg_neg(double %x, double %y) {
; CHECK-LABEL: @neg_neg(
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.maxnum.f64(double [[X:%.*]], double [[Y:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fsub double -0.000000e+00, [[TMP1]]
; CHECK-NEXT:    ret double [[R]]
;
  %negx = fsub double -0.0, %x
  %negy = fsub double -0.0, %y
  %r = call double @llvm.minnum.f64(double %negx, double %negy)
  ret double %r
}

; FMF is not required, but it should be propagated from the intrinsic (not the fnegs).
; Also, make sure this works with vectors.

define <2 x double> @neg_neg_vec_fmf(<2 x double> %x, <2 x double> %y) {
; CHECK-LABEL: @neg_neg_vec_fmf(
; CHECK-NEXT:    [[TMP1:%.*]] = call nnan ninf <2 x double> @llvm.maxnum.v2f64(<2 x double> [[X:%.*]], <2 x double> [[Y:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fsub nnan ninf <2 x double> <double -0.000000e+00, double -0.000000e+00>, [[TMP1]]
; CHECK-NEXT:    ret <2 x double> [[R]]
;
  %negx = fsub reassoc <2 x double> <double -0.0, double -0.0>, %x
  %negy = fsub fast <2 x double> <double -0.0, double -0.0>, %y
  %r = call nnan ninf <2 x double> @llvm.minnum.v2f64(<2 x double> %negx, <2 x double> %negy)
  ret <2 x double> %r
}

; 1 extra use of an intermediate value should still allow the fold,
; but 2 would require more instructions than we started with.

declare void @use(double)
define double @neg_neg_extra_use_x(double %x, double %y) {
; CHECK-LABEL: @neg_neg_extra_use_x(
; CHECK-NEXT:    [[NEGX:%.*]] = fsub double -0.000000e+00, [[X:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.maxnum.f64(double [[X]], double [[Y:%.*]])
; CHECK-NEXT:    [[R:%.*]] = fsub double -0.000000e+00, [[TMP1]]
; CHECK-NEXT:    call void @use(double [[NEGX]])
; CHECK-NEXT:    ret double [[R]]
;
  %negx = fsub double -0.0, %x
  %negy = fsub double -0.0, %y
  %r = call double @llvm.minnum.f64(double %negx, double %negy)
  call void @use(double %negx)
  ret double %r
}

define double @neg_neg_extra_use_y(double %x, double %y) {
; CHECK-LABEL: @neg_neg_extra_use_y(
; CHECK-NEXT:    [[NEGY:%.*]] = fsub double -0.000000e+00, [[Y:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = call double @llvm.maxnum.f64(double [[X:%.*]], double [[Y]])
; CHECK-NEXT:    [[R:%.*]] = fsub double -0.000000e+00, [[TMP1]]
; CHECK-NEXT:    call void @use(double [[NEGY]])
; CHECK-NEXT:    ret double [[R]]
;
  %negx = fsub double -0.0, %x
  %negy = fsub double -0.0, %y
  %r = call double @llvm.minnum.f64(double %negx, double %negy)
  call void @use(double %negy)
  ret double %r
}

define double @neg_neg_extra_use_x_and_y(double %x, double %y) {
; CHECK-LABEL: @neg_neg_extra_use_x_and_y(
; CHECK-NEXT:    [[NEGX:%.*]] = fsub double -0.000000e+00, [[X:%.*]]
; CHECK-NEXT:    [[NEGY:%.*]] = fsub double -0.000000e+00, [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = call double @llvm.minnum.f64(double [[NEGX]], double [[NEGY]])
; CHECK-NEXT:    call void @use(double [[NEGX]])
; CHECK-NEXT:    call void @use(double [[NEGY]])
; CHECK-NEXT:    ret double [[R]]
;
  %negx = fsub double -0.0, %x
  %negy = fsub double -0.0, %y
  %r = call double @llvm.minnum.f64(double %negx, double %negy)
  call void @use(double %negx)
  call void @use(double %negy)
  ret double %r
}

