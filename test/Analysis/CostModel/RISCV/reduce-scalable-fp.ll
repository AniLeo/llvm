; NOTE: Assertions have been autogenerated by utils/update_analyze_test_checks.py
; RUN: opt < %s -mtriple=riscv32 -mattr=+d,+zfh,+experimental-zvfh,+v -passes='print<cost-model>' -cost-kind=throughput 2>&1 -disable-output | FileCheck %s
; RUN: opt < %s -mtriple=riscv64 -mattr=+d,+zfh,+experimental-zvfh,+v -passes='print<cost-model>' -cost-kind=throughput 2>&1 -disable-output | FileCheck %s

declare half @llvm.vector.reduce.fadd.nxv1f16(half, <vscale x 1 x half>)

define half @vreduce_fadd_nxv1f16(<vscale x 1 x half> %v, half %s) {
; CHECK-LABEL: 'vreduce_fadd_nxv1f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc half @llvm.vector.reduce.fadd.nxv1f16(half %s, <vscale x 1 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call reassoc half @llvm.vector.reduce.fadd.nxv1f16(half %s, <vscale x 1 x half> %v)
  ret half %red
}

define half @vreduce_ord_fadd_nxv1f16(<vscale x 1 x half> %v, half %s) {
; CHECK-LABEL: 'vreduce_ord_fadd_nxv1f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fadd.nxv1f16(half %s, <vscale x 1 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fadd.nxv1f16(half %s, <vscale x 1 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fadd.nxv2f16(half, <vscale x 2 x half>)

define half @vreduce_fadd_nxv2f16(<vscale x 2 x half> %v, half %s) {
; CHECK-LABEL: 'vreduce_fadd_nxv2f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc half @llvm.vector.reduce.fadd.nxv2f16(half %s, <vscale x 2 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call reassoc half @llvm.vector.reduce.fadd.nxv2f16(half %s, <vscale x 2 x half> %v)
  ret half %red
}

define half @vreduce_ord_fadd_nxv2f16(<vscale x 2 x half> %v, half %s) {
; CHECK-LABEL: 'vreduce_ord_fadd_nxv2f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fadd.nxv2f16(half %s, <vscale x 2 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fadd.nxv2f16(half %s, <vscale x 2 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fadd.nxv4f16(half, <vscale x 4 x half>)

define half @vreduce_fadd_nxv4f16(<vscale x 4 x half> %v, half %s) {
; CHECK-LABEL: 'vreduce_fadd_nxv4f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc half @llvm.vector.reduce.fadd.nxv4f16(half %s, <vscale x 4 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call reassoc half @llvm.vector.reduce.fadd.nxv4f16(half %s, <vscale x 4 x half> %v)
  ret half %red
}

define half @vreduce_ord_fadd_nxv4f16(<vscale x 4 x half> %v, half %s) {
; CHECK-LABEL: 'vreduce_ord_fadd_nxv4f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fadd.nxv4f16(half %s, <vscale x 4 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fadd.nxv4f16(half %s, <vscale x 4 x half> %v)
  ret half %red
}

declare float @llvm.vector.reduce.fadd.nxv1f32(float, <vscale x 1 x float>)

define float @vreduce_fadd_nxv1f32(<vscale x 1 x float> %v, float %s) {
; CHECK-LABEL: 'vreduce_fadd_nxv1f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call reassoc float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %v)
  ret float %red
}

define float @vreduce_ord_fadd_nxv1f32(<vscale x 1 x float> %v, float %s) {
; CHECK-LABEL: 'vreduce_ord_fadd_nxv1f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %v)
  ret float %red
}

define float @vreduce_fwadd_nxv1f32(<vscale x 1 x half> %v, float %s) {
; CHECK-LABEL: 'vreduce_fwadd_nxv1f32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 1 x half> %v to <vscale x 1 x float>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %e = fpext <vscale x 1 x half> %v to <vscale x 1 x float>
  %red = call reassoc float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %e)
  ret float %red
}

define float @vreduce_ord_fwadd_nxv1f32(<vscale x 1 x half> %v, float %s) {
; CHECK-LABEL: 'vreduce_ord_fwadd_nxv1f32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 1 x half> %v to <vscale x 1 x float>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %e = fpext <vscale x 1 x half> %v to <vscale x 1 x float>
  %red = call float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %e)
  ret float %red
}

declare float @llvm.vector.reduce.fadd.nxv2f32(float, <vscale x 2 x float>)

define float @vreduce_fadd_nxv2f32(<vscale x 2 x float> %v, float %s) {
; CHECK-LABEL: 'vreduce_fadd_nxv2f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call reassoc float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %v)
  ret float %red
}

define float @vreduce_ord_fadd_nxv2f32(<vscale x 2 x float> %v, float %s) {
; CHECK-LABEL: 'vreduce_ord_fadd_nxv2f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %v)
  ret float %red
}

define float @vreduce_fwadd_nxv2f32(<vscale x 2 x half> %v, float %s) {
; CHECK-LABEL: 'vreduce_fwadd_nxv2f32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 2 x half> %v to <vscale x 2 x float>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %e = fpext <vscale x 2 x half> %v to <vscale x 2 x float>
  %red = call reassoc float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %e)
  ret float %red
}

define float @vreduce_ord_fwadd_nxv2f32(<vscale x 2 x half> %v, float %s) {
; CHECK-LABEL: 'vreduce_ord_fwadd_nxv2f32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 2 x half> %v to <vscale x 2 x float>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %e = fpext <vscale x 2 x half> %v to <vscale x 2 x float>
  %red = call float @llvm.vector.reduce.fadd.nxv2f32(float %s, <vscale x 2 x float> %e)
  ret float %red
}

declare float @llvm.vector.reduce.fadd.nxv4f32(float, <vscale x 4 x float>)

define float @vreduce_fadd_nxv4f32(<vscale x 4 x float> %v, float %s) {
; CHECK-LABEL: 'vreduce_fadd_nxv4f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call reassoc float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %v)
  ret float %red
}

define float @vreduce_ord_fadd_nxv4f32(<vscale x 4 x float> %v, float %s) {
; CHECK-LABEL: 'vreduce_ord_fadd_nxv4f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %v)
  ret float %red
}

define float @vreduce_fwadd_nxv4f32(<vscale x 4 x half> %v, float %s) {
; CHECK-LABEL: 'vreduce_fwadd_nxv4f32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 4 x half> %v to <vscale x 4 x float>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %e = fpext <vscale x 4 x half> %v to <vscale x 4 x float>
  %red = call reassoc float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %e)
  ret float %red
}

define float @vreduce_ord_fwadd_nxv4f32(<vscale x 4 x half> %v, float %s) {
; CHECK-LABEL: 'vreduce_ord_fwadd_nxv4f32'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 4 x half> %v to <vscale x 4 x float>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %e = fpext <vscale x 4 x half> %v to <vscale x 4 x float>
  %red = call float @llvm.vector.reduce.fadd.nxv4f32(float %s, <vscale x 4 x float> %e)
  ret float %red
}

declare double @llvm.vector.reduce.fadd.nxv1f64(double, <vscale x 1 x double>)

define double @vreduce_fadd_nxv1f64(<vscale x 1 x double> %v, double %s) {
; CHECK-LABEL: 'vreduce_fadd_nxv1f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call reassoc double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %v)
  ret double %red
}

define double @vreduce_ord_fadd_nxv1f64(<vscale x 1 x double> %v, double %s) {
; CHECK-LABEL: 'vreduce_ord_fadd_nxv1f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %v)
  ret double %red
}

define double @vreduce_fwadd_nxv1f64(<vscale x 1 x float> %v, double %s) {
; CHECK-LABEL: 'vreduce_fwadd_nxv1f64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 1 x float> %v to <vscale x 1 x double>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %e = fpext <vscale x 1 x float> %v to <vscale x 1 x double>
  %red = call reassoc double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %e)
  ret double %red
}

define double @vreduce_ord_fwadd_nxv1f64(<vscale x 1 x float> %v, double %s) {
; CHECK-LABEL: 'vreduce_ord_fwadd_nxv1f64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 1 x float> %v to <vscale x 1 x double>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %e = fpext <vscale x 1 x float> %v to <vscale x 1 x double>
  %red = call double @llvm.vector.reduce.fadd.nxv1f64(double %s, <vscale x 1 x double> %e)
  ret double %red
}

declare double @llvm.vector.reduce.fadd.nxv2f64(double, <vscale x 2 x double>)

define double @vreduce_fadd_nxv2f64(<vscale x 2 x double> %v, double %s) {
; CHECK-LABEL: 'vreduce_fadd_nxv2f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call reassoc double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %v)
  ret double %red
}

define double @vreduce_ord_fadd_nxv2f64(<vscale x 2 x double> %v, double %s) {
; CHECK-LABEL: 'vreduce_ord_fadd_nxv2f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %v)
  ret double %red
}

define double @vreduce_fwadd_nxv2f64(<vscale x 2 x float> %v, double %s) {
; CHECK-LABEL: 'vreduce_fwadd_nxv2f64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 2 x float> %v to <vscale x 2 x double>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %e = fpext <vscale x 2 x float> %v to <vscale x 2 x double>
  %red = call reassoc double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %e)
  ret double %red
}

define double @vreduce_ord_fwadd_nxv2f64(<vscale x 2 x float> %v, double %s) {
; CHECK-LABEL: 'vreduce_ord_fwadd_nxv2f64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 2 x float> %v to <vscale x 2 x double>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %e = fpext <vscale x 2 x float> %v to <vscale x 2 x double>
  %red = call double @llvm.vector.reduce.fadd.nxv2f64(double %s, <vscale x 2 x double> %e)
  ret double %red
}

declare double @llvm.vector.reduce.fadd.nxv4f64(double, <vscale x 4 x double>)

define double @vreduce_fadd_nxv4f64(<vscale x 4 x double> %v, double %s) {
; CHECK-LABEL: 'vreduce_fadd_nxv4f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call reassoc double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %v)
  ret double %red
}

define double @vreduce_ord_fadd_nxv4f64(<vscale x 4 x double> %v, double %s) {
; CHECK-LABEL: 'vreduce_ord_fadd_nxv4f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %v)
  ret double %red
}

define double @vreduce_fwadd_nxv4f64(<vscale x 4 x float> %v, double %s) {
; CHECK-LABEL: 'vreduce_fwadd_nxv4f64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 4 x float> %v to <vscale x 4 x double>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %e = fpext <vscale x 4 x float> %v to <vscale x 4 x double>
  %red = call reassoc double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %e)
  ret double %red
}

define double @vreduce_ord_fwadd_nxv4f64(<vscale x 4 x float> %v, double %s) {
; CHECK-LABEL: 'vreduce_ord_fwadd_nxv4f64'
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: %e = fpext <vscale x 4 x float> %v to <vscale x 4 x double>
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %e)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %e = fpext <vscale x 4 x float> %v to <vscale x 4 x double>
  %red = call double @llvm.vector.reduce.fadd.nxv4f64(double %s, <vscale x 4 x double> %e)
  ret double %red
}

declare half @llvm.vector.reduce.fmin.nxv1f16(<vscale x 1 x half>)

define half @vreduce_fmin_nxv1f16(<vscale x 1 x half> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv1f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fmin.nxv1f16(<vscale x 1 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fmin.nxv1f16(<vscale x 1 x half> %v)
  ret half %red
}

define half @vreduce_fmin_nxv1f16_nonans(<vscale x 1 x half> %v) #0 {
; CHECK-LABEL: 'vreduce_fmin_nxv1f16_nonans'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan half @llvm.vector.reduce.fmin.nxv1f16(<vscale x 1 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call nnan half @llvm.vector.reduce.fmin.nxv1f16(<vscale x 1 x half> %v)
  ret half %red
}

define half @vreduce_fmin_nxv1f16_nonans_noinfs(<vscale x 1 x half> %v) #1 {
; CHECK-LABEL: 'vreduce_fmin_nxv1f16_nonans_noinfs'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan ninf half @llvm.vector.reduce.fmin.nxv1f16(<vscale x 1 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call nnan ninf half @llvm.vector.reduce.fmin.nxv1f16(<vscale x 1 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fmin.nxv2f16(<vscale x 2 x half>)

define half @vreduce_fmin_nxv2f16(<vscale x 2 x half> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv2f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fmin.nxv2f16(<vscale x 2 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fmin.nxv2f16(<vscale x 2 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fmin.nxv4f16(<vscale x 4 x half>)

define half @vreduce_fmin_nxv4f16(<vscale x 4 x half> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv4f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fmin.nxv4f16(<vscale x 4 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fmin.nxv4f16(<vscale x 4 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fmin.nxv64f16(<vscale x 64 x half>)

define half @vreduce_fmin_nxv64f16(<vscale x 64 x half> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv64f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fmin.nxv64f16(<vscale x 64 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fmin.nxv64f16(<vscale x 64 x half> %v)
  ret half %red
}

declare float @llvm.vector.reduce.fmin.nxv1f32(<vscale x 1 x float>)

define float @vreduce_fmin_nxv1f32(<vscale x 1 x float> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv1f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fmin.nxv1f32(<vscale x 1 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fmin.nxv1f32(<vscale x 1 x float> %v)
  ret float %red
}

define float @vreduce_fmin_nxv1f32_nonans(<vscale x 1 x float> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv1f32_nonans'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan float @llvm.vector.reduce.fmin.nxv1f32(<vscale x 1 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call nnan float @llvm.vector.reduce.fmin.nxv1f32(<vscale x 1 x float> %v)
  ret float %red
}

define float @vreduce_fmin_nxv1f32_nonans_noinfs(<vscale x 1 x float> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv1f32_nonans_noinfs'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan ninf float @llvm.vector.reduce.fmin.nxv1f32(<vscale x 1 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call nnan ninf float @llvm.vector.reduce.fmin.nxv1f32(<vscale x 1 x float> %v)
  ret float %red
}

declare float @llvm.vector.reduce.fmin.nxv2f32(<vscale x 2 x float>)

define float @vreduce_fmin_nxv2f32(<vscale x 2 x float> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv2f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fmin.nxv2f32(<vscale x 2 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fmin.nxv2f32(<vscale x 2 x float> %v)
  ret float %red
}

declare float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float>)

define float @vreduce_fmin_nxv4f32(<vscale x 4 x float> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv4f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fmin.nxv4f32(<vscale x 4 x float> %v)
  ret float %red
}

declare float @llvm.vector.reduce.fmin.nxv32f32(<vscale x 32 x float>)

define float @vreduce_fmin_nxv32f32(<vscale x 32 x float> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv32f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fmin.nxv32f32(<vscale x 32 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fmin.nxv32f32(<vscale x 32 x float> %v)
  ret float %red
}

declare double @llvm.vector.reduce.fmin.nxv1f64(<vscale x 1 x double>)

define double @vreduce_fmin_nxv1f64(<vscale x 1 x double> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv1f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fmin.nxv1f64(<vscale x 1 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fmin.nxv1f64(<vscale x 1 x double> %v)
  ret double %red
}

define double @vreduce_fmin_nxv1f64_nonans(<vscale x 1 x double> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv1f64_nonans'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan double @llvm.vector.reduce.fmin.nxv1f64(<vscale x 1 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call nnan double @llvm.vector.reduce.fmin.nxv1f64(<vscale x 1 x double> %v)
  ret double %red
}

define double @vreduce_fmin_nxv1f64_nonans_noinfs(<vscale x 1 x double> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv1f64_nonans_noinfs'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan ninf double @llvm.vector.reduce.fmin.nxv1f64(<vscale x 1 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call nnan ninf double @llvm.vector.reduce.fmin.nxv1f64(<vscale x 1 x double> %v)
  ret double %red
}

declare double @llvm.vector.reduce.fmin.nxv2f64(<vscale x 2 x double>)

define double @vreduce_fmin_nxv2f64(<vscale x 2 x double> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv2f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fmin.nxv2f64(<vscale x 2 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fmin.nxv2f64(<vscale x 2 x double> %v)
  ret double %red
}

declare double @llvm.vector.reduce.fmin.nxv4f64(<vscale x 4 x double>)

define double @vreduce_fmin_nxv4f64(<vscale x 4 x double> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv4f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fmin.nxv4f64(<vscale x 4 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fmin.nxv4f64(<vscale x 4 x double> %v)
  ret double %red
}

declare double @llvm.vector.reduce.fmin.nxv16f64(<vscale x 16 x double>)

define double @vreduce_fmin_nxv16f64(<vscale x 16 x double> %v) {
; CHECK-LABEL: 'vreduce_fmin_nxv16f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fmin.nxv16f64(<vscale x 16 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fmin.nxv16f64(<vscale x 16 x double> %v)
  ret double %red
}

declare half @llvm.vector.reduce.fmax.nxv1f16(<vscale x 1 x half>)

define half @vreduce_fmax_nxv1f16(<vscale x 1 x half> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv1f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fmax.nxv1f16(<vscale x 1 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fmax.nxv1f16(<vscale x 1 x half> %v)
  ret half %red
}

define half @vreduce_fmax_nxv1f16_nonans(<vscale x 1 x half> %v) #0 {
; CHECK-LABEL: 'vreduce_fmax_nxv1f16_nonans'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan half @llvm.vector.reduce.fmax.nxv1f16(<vscale x 1 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call nnan half @llvm.vector.reduce.fmax.nxv1f16(<vscale x 1 x half> %v)
  ret half %red
}

define half @vreduce_fmax_nxv1f16_nonans_noinfs(<vscale x 1 x half> %v) #1 {
; CHECK-LABEL: 'vreduce_fmax_nxv1f16_nonans_noinfs'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan ninf half @llvm.vector.reduce.fmax.nxv1f16(<vscale x 1 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call nnan ninf half @llvm.vector.reduce.fmax.nxv1f16(<vscale x 1 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fmax.nxv2f16(<vscale x 2 x half>)

define half @vreduce_fmax_nxv2f16(<vscale x 2 x half> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv2f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fmax.nxv2f16(<vscale x 2 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fmax.nxv2f16(<vscale x 2 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fmax.nxv4f16(<vscale x 4 x half>)

define half @vreduce_fmax_nxv4f16(<vscale x 4 x half> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv4f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fmax.nxv4f16(<vscale x 4 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fmax.nxv4f16(<vscale x 4 x half> %v)
  ret half %red
}

declare half @llvm.vector.reduce.fmax.nxv64f16(<vscale x 64 x half>)

define half @vreduce_fmax_nxv64f16(<vscale x 64 x half> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv64f16'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call half @llvm.vector.reduce.fmax.nxv64f16(<vscale x 64 x half> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret half %red
;
  %red = call half @llvm.vector.reduce.fmax.nxv64f16(<vscale x 64 x half> %v)
  ret half %red
}

declare float @llvm.vector.reduce.fmax.nxv1f32(<vscale x 1 x float>)

define float @vreduce_fmax_nxv1f32(<vscale x 1 x float> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv1f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fmax.nxv1f32(<vscale x 1 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fmax.nxv1f32(<vscale x 1 x float> %v)
  ret float %red
}

define float @vreduce_fmax_nxv1f32_nonans(<vscale x 1 x float> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv1f32_nonans'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan float @llvm.vector.reduce.fmax.nxv1f32(<vscale x 1 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call nnan float @llvm.vector.reduce.fmax.nxv1f32(<vscale x 1 x float> %v)
  ret float %red
}

define float @vreduce_fmax_nxv1f32_nonans_noinfs(<vscale x 1 x float> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv1f32_nonans_noinfs'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan ninf float @llvm.vector.reduce.fmax.nxv1f32(<vscale x 1 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call nnan ninf float @llvm.vector.reduce.fmax.nxv1f32(<vscale x 1 x float> %v)
  ret float %red
}

declare float @llvm.vector.reduce.fmax.nxv2f32(<vscale x 2 x float>)

define float @vreduce_fmax_nxv2f32(<vscale x 2 x float> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv2f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fmax.nxv2f32(<vscale x 2 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fmax.nxv2f32(<vscale x 2 x float> %v)
  ret float %red
}

declare float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float>)

define float @vreduce_fmax_nxv4f32(<vscale x 4 x float> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv4f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fmax.nxv4f32(<vscale x 4 x float> %v)
  ret float %red
}

declare float @llvm.vector.reduce.fmax.nxv32f32(<vscale x 32 x float>)

define float @vreduce_fmax_nxv32f32(<vscale x 32 x float> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv32f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call float @llvm.vector.reduce.fmax.nxv32f32(<vscale x 32 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call float @llvm.vector.reduce.fmax.nxv32f32(<vscale x 32 x float> %v)
  ret float %red
}

declare double @llvm.vector.reduce.fmax.nxv1f64(<vscale x 1 x double>)

define double @vreduce_fmax_nxv1f64(<vscale x 1 x double> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv1f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fmax.nxv1f64(<vscale x 1 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fmax.nxv1f64(<vscale x 1 x double> %v)
  ret double %red
}

define double @vreduce_fmax_nxv1f64_nonans(<vscale x 1 x double> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv1f64_nonans'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan double @llvm.vector.reduce.fmax.nxv1f64(<vscale x 1 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call nnan double @llvm.vector.reduce.fmax.nxv1f64(<vscale x 1 x double> %v)
  ret double %red
}

define double @vreduce_fmax_nxv1f64_nonans_noinfs(<vscale x 1 x double> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv1f64_nonans_noinfs'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call nnan ninf double @llvm.vector.reduce.fmax.nxv1f64(<vscale x 1 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call nnan ninf double @llvm.vector.reduce.fmax.nxv1f64(<vscale x 1 x double> %v)
  ret double %red
}

declare double @llvm.vector.reduce.fmax.nxv2f64(<vscale x 2 x double>)

define double @vreduce_fmax_nxv2f64(<vscale x 2 x double> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv2f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fmax.nxv2f64(<vscale x 2 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fmax.nxv2f64(<vscale x 2 x double> %v)
  ret double %red
}

declare double @llvm.vector.reduce.fmax.nxv4f64(<vscale x 4 x double>)

define double @vreduce_fmax_nxv4f64(<vscale x 4 x double> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv4f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fmax.nxv4f64(<vscale x 4 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fmax.nxv4f64(<vscale x 4 x double> %v)
  ret double %red
}

declare double @llvm.vector.reduce.fmax.nxv16f64(<vscale x 16 x double>)

define double @vreduce_fmax_nxv16f64(<vscale x 16 x double> %v) {
; CHECK-LABEL: 'vreduce_fmax_nxv16f64'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call double @llvm.vector.reduce.fmax.nxv16f64(<vscale x 16 x double> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret double %red
;
  %red = call double @llvm.vector.reduce.fmax.nxv16f64(<vscale x 16 x double> %v)
  ret double %red
}

define float @vreduce_nsz_fadd_nxv1f32(<vscale x 1 x float> %v, float %s) {
; CHECK-LABEL: 'vreduce_nsz_fadd_nxv1f32'
; CHECK-NEXT:  Cost Model: Invalid cost for instruction: %red = call reassoc nsz float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %v)
; CHECK-NEXT:  Cost Model: Found an estimated cost of 1 for instruction: ret float %red
;
  %red = call reassoc nsz float @llvm.vector.reduce.fadd.nxv1f32(float %s, <vscale x 1 x float> %v)
  ret float %red
}
