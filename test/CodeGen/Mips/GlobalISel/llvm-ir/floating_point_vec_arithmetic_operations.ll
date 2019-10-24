; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -mtriple=mipsel-linux-gnu -global-isel -mcpu=mips32r5 -mattr=+msa,+fp64,+nan2008 -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=P5600

define void @fadd_v4f32(<4 x float>* %a, <4 x float>* %b, <4 x float>* %c) {
; P5600-LABEL: fadd_v4f32:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.w $w0, 0($4)
; P5600-NEXT:    ld.w $w1, 0($5)
; P5600-NEXT:    fadd.w $w0, $w0, $w1
; P5600-NEXT:    st.w $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %1 = load <4 x float>, <4 x float>* %b, align 16
  %add = fadd <4 x float> %0, %1
  store <4 x float> %add, <4 x float>* %c, align 16
  ret void
}


define void @fadd_v2f64(<2 x double>* %a, <2 x double>* %b, <2 x double>* %c) {
; P5600-LABEL: fadd_v2f64:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.d $w0, 0($4)
; P5600-NEXT:    ld.d $w1, 0($5)
; P5600-NEXT:    fadd.d $w0, $w0, $w1
; P5600-NEXT:    st.d $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <2 x double>, <2 x double>* %a, align 16
  %1 = load <2 x double>, <2 x double>* %b, align 16
  %add = fadd <2 x double> %0, %1
  store <2 x double> %add, <2 x double>* %c, align 16
  ret void
}


define void @fsub_v4f32(<4 x float>* %a, <4 x float>* %b, <4 x float>* %c) {
; P5600-LABEL: fsub_v4f32:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.w $w0, 0($4)
; P5600-NEXT:    ld.w $w1, 0($5)
; P5600-NEXT:    fsub.w $w0, $w0, $w1
; P5600-NEXT:    st.w $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %1 = load <4 x float>, <4 x float>* %b, align 16
  %sub = fsub <4 x float> %0, %1
  store <4 x float> %sub, <4 x float>* %c, align 16
  ret void
}


define void @fsub_v2f64(<2 x double>* %a, <2 x double>* %b, <2 x double>* %c) {
; P5600-LABEL: fsub_v2f64:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.d $w0, 0($4)
; P5600-NEXT:    ld.d $w1, 0($5)
; P5600-NEXT:    fsub.d $w0, $w0, $w1
; P5600-NEXT:    st.d $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <2 x double>, <2 x double>* %a, align 16
  %1 = load <2 x double>, <2 x double>* %b, align 16
  %sub = fsub <2 x double> %0, %1
  store <2 x double> %sub, <2 x double>* %c, align 16
  ret void
}


define void @fmul_v4f32(<4 x float>* %a, <4 x float>* %b, <4 x float>* %c) {
; P5600-LABEL: fmul_v4f32:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.w $w0, 0($4)
; P5600-NEXT:    ld.w $w1, 0($5)
; P5600-NEXT:    fmul.w $w0, $w0, $w1
; P5600-NEXT:    st.w $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %1 = load <4 x float>, <4 x float>* %b, align 16
  %mul = fmul <4 x float> %0, %1
  store <4 x float> %mul, <4 x float>* %c, align 16
  ret void
}


define void @fmul_v2f64(<2 x double>* %a, <2 x double>* %b, <2 x double>* %c) {
; P5600-LABEL: fmul_v2f64:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.d $w0, 0($4)
; P5600-NEXT:    ld.d $w1, 0($5)
; P5600-NEXT:    fmul.d $w0, $w0, $w1
; P5600-NEXT:    st.d $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <2 x double>, <2 x double>* %a, align 16
  %1 = load <2 x double>, <2 x double>* %b, align 16
  %mul = fmul <2 x double> %0, %1
  store <2 x double> %mul, <2 x double>* %c, align 16
  ret void
}


define void @fdiv_v4f32(<4 x float>* %a, <4 x float>* %b, <4 x float>* %c) {
; P5600-LABEL: fdiv_v4f32:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.w $w0, 0($4)
; P5600-NEXT:    ld.w $w1, 0($5)
; P5600-NEXT:    fdiv.w $w0, $w0, $w1
; P5600-NEXT:    st.w $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <4 x float>, <4 x float>* %a, align 16
  %1 = load <4 x float>, <4 x float>* %b, align 16
  %div = fdiv <4 x float> %0, %1
  store <4 x float> %div, <4 x float>* %c, align 16
  ret void
}


define void @fdiv_v2f64(<2 x double>* %a, <2 x double>* %b, <2 x double>* %c) {
; P5600-LABEL: fdiv_v2f64:
; P5600:       # %bb.0: # %entry
; P5600-NEXT:    ld.d $w0, 0($4)
; P5600-NEXT:    ld.d $w1, 0($5)
; P5600-NEXT:    fdiv.d $w0, $w0, $w1
; P5600-NEXT:    st.d $w0, 0($6)
; P5600-NEXT:    jr $ra
; P5600-NEXT:    nop
entry:
  %0 = load <2 x double>, <2 x double>* %a, align 16
  %1 = load <2 x double>, <2 x double>* %b, align 16
  %div = fdiv <2 x double> %0, %1
  store <2 x double> %div, <2 x double>* %c, align 16
  ret void
}
