; RUN: opt -S -instsimplify < %s | FileCheck %s

; Test cases for denormal handling mode when constant folding floating point
; operations. Input and output modes are checked seperately.

; ============================================================================ ;
; fadd tests
; Denormal operand added to normal operand produces denormal result.
; If denormal outputs should be flushed to zero, the result should be zero.
; If denormal inputs should be treated as zero, the result should be the
; normal operand (a number plus zero is the same number).
; ============================================================================ ;

define float @test_float_fadd_ieee() #0 {
; CHECK-LABEL: @test_float_fadd_ieee(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fadd float 0xB810000000000000, 0x3800000000000000
  ret float %result
}

define float @test_float_fadd_pzero_out() #1 {
; CHECK-LABEL: @test_float_fadd_pzero_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fadd float 0xB810000000000000, 0x3800000000000000
  ret float %result
}

define float @test_float_fadd_psign_out() #2 {
; CHECK-LABEL: @test_float_fadd_psign_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fadd float 0xB810000000000000, 0x3800000000000000
  ret float %result
}

define float @test_float_fadd_pzero_in() #3 {
; CHECK-LABEL: @test_float_fadd_pzero_in(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fadd float 0xB810000000000000, 0x3800000000000000
  ret float %result
}

define float @test_float_fadd_psign_in() #4 {
; CHECK-LABEL: @test_float_fadd_psign_in(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fadd float 0xB810000000000000, 0x3800000000000000
  ret float %result
}

define float @test_float_fadd_pzero_f32_out() #5 {
; CHECK-LABEL: @test_float_fadd_pzero_f32_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fadd float 0xB810000000000000, 0x3800000000000000
  ret float %result
}

define double @test_double_fadd_ieee() #0 {
; CHECK-LABEL: @test_double_fadd_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fadd double 0x8010000000000000, 0x8000000000000
  ret double %result
}

define double @test_double_fadd_pzero_out() #1 {
; CHECK-LABEL: @test_double_fadd_pzero_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fadd double 0x8010000000000000, 0x8000000000000
  ret double %result
}

define double @test_double_fadd_psign_out() #2 {
; CHECK-LABEL: @test_double_fadd_psign_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fadd double 0x8010000000000000, 0x8000000000000
  ret double %result
}

define double @test_double_fadd_pzero_in() #3 {
; CHECK-LABEL: @test_double_fadd_pzero_in(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fadd double 0x8010000000000000, 0x8000000000000
  ret double %result
}

define double @test_double_fadd_psign_in() #4 {
; CHECK-LABEL: @test_double_fadd_psign_in(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fadd double 0x8010000000000000, 0x8000000000000
  ret double %result
}

define double @test_double_fadd_f32_ieee() #5 {
; CHECK-LABEL: @test_double_fadd_f32_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fadd double 0x8010000000000000, 0x8000000000000
  ret double %result
}

; ============================================================================ ;
; fsub tests
; Normal operand subtracted from denormal operand produces denormal result
; If denormal outputs should be flushed to zero, the result should be zero.
; If denormal inputs should be treated as zero, the result should be the
; negated normal operand (zero minus the original operand).
; ============================================================================ ;

define float @test_float_fsub_ieee() #0 {
; CHECK-LABEL: @test_float_fsub_ieee(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fsub float 0x3800000000000000, 0x3810000000000000
  ret float %result
}

define float @test_float_fsub_pzero_out() #1 {
; CHECK-LABEL: @test_float_fsub_pzero_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fsub float 0x3800000000000000, 0x3810000000000000
  ret float %result
}

define float @test_float_fsub_psign_out() #2 {
; CHECK-LABEL: @test_float_fsub_psign_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fsub float 0x3800000000000000, 0x3810000000000000
  ret float %result
}

define float @test_float_fsub_pzero_in() #3 {
; CHECK-LABEL: @test_float_fsub_pzero_in(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fsub float 0x3800000000000000, 0x3810000000000000
  ret float %result
}

define float @test_float_fsub_psign_in() #4 {
; CHECK-LABEL: @test_float_fsub_psign_in(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fsub float 0x3800000000000000, 0x3810000000000000
  ret float %result
}

define float @test_float_fsub_pzero_f32_out() #5 {
; CHECK-LABEL: @test_float_fsub_pzero_f32_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fsub float 0x3800000000000000, 0x3810000000000000
  ret float %result
}

define double @test_double_fsub_ieee() #0 {
; CHECK-LABEL: @test_double_fsub_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fsub double 0x8000000000000, 0x10000000000000
  ret double %result
}

define double @test_double_fsub_pzero_out() #1 {
; CHECK-LABEL: @test_double_fsub_pzero_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fsub double 0x8000000000000, 0x10000000000000
  ret double %result
}

define double @test_double_fsub_psign_out() #2 {
; CHECK-LABEL: @test_double_fsub_psign_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fsub double 0x8000000000000, 0x10000000000000
  ret double %result
}

define double @test_double_fsub_pzero_in() #3 {
; CHECK-LABEL: @test_double_fsub_pzero_in(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fsub double 0x8000000000000, 0x10000000000000
  ret double %result
}

define double @test_double_fsub_psign_in() #4 {
; CHECK-LABEL: @test_double_fsub_psign_in(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fsub double 0x8000000000000, 0x10000000000000
  ret double %result
}

define double @test_double_fsub_f32_ieee() #5 {
; CHECK-LABEL: @test_double_fsub_f32_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fsub double 0x8000000000000, 0x10000000000000
  ret double %result
}

; ============================================================================ ;
; fmul tests
; Output modes are tested by multiplying the smallest normal number by 0.5,
; producing a denormal result. If denormal outputs should be flushed to zero,
; the result should be zero.
; Input modes are tested by the reverse operation: taking the denormal and
; multiplying by 2 to produce a normal number. If denormal inputs should be
; treated as zero, the result should also be zero.
; ============================================================================ ;

define float @test_float_fmul_ieee() #0 {
; CHECK-LABEL: @test_float_fmul_ieee(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fmul float 0x3810000000000000, -5.000000e-01
  ret float %result
}

define float @test_float_fmul_pzero_out() #1 {
; CHECK-LABEL: @test_float_fmul_pzero_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fmul float 0x3810000000000000, -5.000000e-01
  ret float %result
}

define float @test_float_fmul_psign_out() #2 {
; CHECK-LABEL: @test_float_fmul_psign_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fmul float 0x3810000000000000, -5.000000e-01
  ret float %result
}

define float @test_float_fmul_pzero_in() #3 {
; CHECK-LABEL: @test_float_fmul_pzero_in(
; CHECK-NEXT:    ret float 0xB810000000000000
; default ieee mode leaves result as a normal
  %result = fmul float 0xB800000000000000, 2.000000e-00
  ret float %result
}

define float @test_float_fmul_psign_in() #4 {
; CHECK-LABEL: @test_float_fmul_psign_in(
; CHECK-NEXT:    ret float 0xB810000000000000
; default ieee mode leaves result as a normal
  %result = fmul float 0xB800000000000000, 2.000000e-00
  ret float %result
}

define float @test_float_fmul_pzero_f32_out() #1 {
; CHECK-LABEL: @test_float_fmul_pzero_f32_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fmul float 0x3810000000000000, -5.000000e-01
  ret float %result
}

define double @test_double_fmul_ieee() #0 {
; CHECK-LABEL: @test_double_fmul_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fmul double 0x10000000000000, -5.000000e-01
  ret double %result
}

define double @test_double_fmul_pzero_out() #1 {
; CHECK-LABEL: @test_double_fmul_pzero_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fmul double 0x10000000000000, -5.000000e-01
  ret double %result
}

define double @test_double_fmul_psign_out() #2 {
; CHECK-LABEL: @test_double_fmul_psign_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fmul double 0x10000000000000, -5.000000e-01
  ret double %result
}

define double @test_double_fmul_pzero_in() #3 {
; CHECK-LABEL: @test_double_fmul_pzero_in(
; CHECK-NEXT:    ret double 0x8010000000000000
; default ieee mode leaves result as a normal
  %result = fmul double 0x8008000000000000, 2.000000e-00
  ret double %result
}

define double @test_double_fmul_psign_in() #4 {
; CHECK-LABEL: @test_double_fmul_psign_in(
; CHECK-NEXT:    ret double 0x8010000000000000
; default ieee mode leaves result as a normal
  %result = fmul double 0x8008000000000000, 2.000000e-00
  ret double %result
}

define double @test_double_fmul_f32_ieee() #5 {
; CHECK-LABEL: @test_double_fmul_f32_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fmul double 0x10000000000000, -5.000000e-01
  ret double %result
}

; ============================================================================ ;
; fdiv tests
; Output modes are tested by dividing the smallest normal number by 2,
; producing a denormal result. If denormal outputs should be flushed to zero,
; the result should be zero.
; Input modes are tested by the reverse operation: taking the denormal and
; dividing by 0.5 to produce a normal number. If denormal inputs should be
; treated as zero, the result should also be zero.
; ============================================================================ ;

define float @test_float_fdiv_ieee() #0 {
; CHECK-LABEL: @test_float_fdiv_ieee(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fdiv float 0x3810000000000000, -2.000000e-00
  ret float %result
}

define float @test_float_fdiv_pzero_out() #1 {
; CHECK-LABEL: @test_float_fdiv_pzero_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fdiv float 0x3810000000000000, -2.000000e-00
  ret float %result
}

define float @test_float_fdiv_psign_out() #2 {
; CHECK-LABEL: @test_float_fdiv_psign_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fdiv float 0x3810000000000000, -2.000000e-00
  ret float %result
}

define float @test_float_fdiv_pzero_in() #3 {
; CHECK-LABEL: @test_float_fdiv_pzero_in(
; CHECK-NEXT:    ret float 0xB810000000000000
; default ieee mode leaves result as a normal
  %result = fdiv float 0xB800000000000000, 5.000000e-01
  ret float %result
}

define float @test_float_fdiv_psign_in() #4 {
; CHECK-LABEL: @test_float_fdiv_psign_in(
; CHECK-NEXT:    ret float 0xB7F0000000000000
; default ieee mode leaves result as a normal
  %result = fmul float 0xB800000000000000, 5.000000e-01
  ret float %result
}

define float @test_float_fdiv_pzero_f32_out() #1 {
; CHECK-LABEL: @test_float_fdiv_pzero_f32_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = fdiv float 0x3810000000000000, -2.000000e-00
  ret float %result
}

define double @test_double_fdiv_ieee() #0 {
; CHECK-LABEL: @test_double_fdiv_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fdiv double 0x10000000000000, -2.000000e-00
  ret double %result
}

define double @test_double_fdiv_pzero_out() #1 {
; CHECK-LABEL: @test_double_fdiv_pzero_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fdiv double 0x10000000000000, -2.000000e-00
  ret double %result
}

define double @test_double_fdiv_psign_out() #2 {
; CHECK-LABEL: @test_double_fdiv_psign_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fdiv double 0x10000000000000, -2.000000e-00
  ret double %result
}

define double @test_double_fdiv_pzero_in() #3 {
; CHECK-LABEL: @test_double_fdiv_pzero_in(
; CHECK-NEXT:    ret double 0x8010000000000000
; default ieee mode leaves result as a normal
  %result = fdiv double 0x8008000000000000, 5.000000e-01
  ret double %result
}

define double @test_double_fdiv_psign_in() #4 {
; CHECK-LABEL: @test_double_fdiv_psign_in(
; CHECK-NEXT:    ret double 0x8010000000000000
; default ieee mode leaves result as a normal
  %result = fdiv double 0x8008000000000000, 5.000000e-01
  ret double %result
}

define double @test_double_fdiv_f32_ieee() #5 {
; CHECK-LABEL: @test_double_fdiv_f32_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = fdiv double 0x10000000000000, -2.000000e-00
  ret double %result
}

; ============================================================================ ;
; frem tests
; Output modes are tested by using two small normal numbers to produce a
; denormal result. If denormal outputs should be flushed to zero, the result
; should be zero.
; Input modes are tested by calculating the remainder of a denormal number
; and a larger normal number. If denormal inputs should be treated as zero
; the result also becomes zero.
; ============================================================================ ;

define float @test_float_frem_ieee_out() #0 {
; CHECK-LABEL: @test_float_frem_ieee_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = frem float 0xB818000000000000, 0x3810000000000000
  ret float %result
}

define float @test_float_frem_pzero_out() #1 {
; CHECK-LABEL: @test_float_frem_pzero_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = frem float 0xB818000000000000, 0x3810000000000000
  ret float %result
}

define float @test_float_frem_psign_out() #2 {
; CHECK-LABEL: @test_float_frem_psign_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = frem float 0xB818000000000000, 0x3810000000000000
  ret float %result
}

define float @test_float_frem_ieee_in() #0 {
; CHECK-LABEL: @test_float_frem_ieee_in(
; CHECK-NEXT:    ret float 0x3800000000000000
; default ieee mode leaves result same as input
  %result = frem float 0x3800000000000000, 2.000000e+00
  ret float %result
}

define float @test_float_frem_pzero_in() #3 {
; CHECK-LABEL: @test_float_frem_pzero_in(
; CHECK-NEXT:    ret float 0x3800000000000000
; default ieee mode leaves result same as input
  %result = frem float 0x3800000000000000, 2.000000e+00
  ret float %result
}

define float @test_float_frem_psign_in() #4 {
; CHECK-LABEL: @test_float_frem_psign_in(
; CHECK-NEXT:    ret float 0x3800000000000000
; default ieee mode leaves result same as input
  %result = frem float 0x3800000000000000, 2.000000e+00
  ret float %result
}

define float @test_float_frem_pzero_f32_out() #1 {
; CHECK-LABEL: @test_float_frem_pzero_f32_out(
; CHECK-NEXT:    ret float 0xB800000000000000
; default ieee mode leaves result as a denormal
  %result = frem float 0xB818000000000000, 0x3810000000000000
  ret float %result
}

define double @test_double_frem_ieee_out() #0 {
; CHECK-LABEL: @test_double_frem_ieee_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = frem double 0x8018000000000000, 0x10000000000000
  ret double %result
}

define double @test_double_frem_pzero_out() #1 {
; CHECK-LABEL: @test_double_frem_pzero_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = frem double 0x8018000000000000, 0x10000000000000
  ret double %result
}

define double @test_double_frem_psign_out() #2 {
; CHECK-LABEL: @test_double_frem_psign_out(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = frem double 0x8018000000000000, 0x10000000000000
  ret double %result
}

define double @test_double_frem_ieee_in() #0 {
; CHECK-LABEL: @test_double_frem_ieee_in(
; CHECK-NEXT:    ret double 0x8000000000000
; default ieee mode leaves result same as input
  %result = frem double 0x8000000000000, 2.000000e+00
  ret double %result
}

define double @test_double_frem_pzero_in() #3 {
; CHECK-LABEL: @test_double_frem_pzero_in( 
; CHECK-NEXT:    ret double 0x8000000000000
; default ieee mode leaves result same as input
  %result = frem double 0x8000000000000, 2.000000e+00
  ret double %result
}

define double @test_double_frem_psign_in() #4 {
; CHECK-LABEL: @test_double_frem_psign_in(
; CHECK-NEXT:    ret double 0x8000000000000
; default ieee mode leaves result same as input
  %result = frem double 0x8000000000000, 2.000000e+00
  ret double %result
}

define double @test_double_frem_f32_ieee() #5 {
; CHECK-LABEL: @test_double_frem_f32_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
; default ieee mode leaves result as a denormal
  %result = frem double 0x8018000000000000, 0x10000000000000
  ret double %result
}

; ============================================================================ ;
; fneg tests
; fneg should NOT be affected by denormal handling mode
; these tests confirm fneg results are unchanged
; ============================================================================ ;

define float @test_float_fneg_ieee() #0 {
; CHECK-LABEL: @test_float_fneg_ieee(
; CHECK-NEXT:    ret float 0xB800000000000000
  %result = fneg float 0x3800000000000000
  ret float %result
}

define float @test_float_fneg_pzero_out() #0 {
; CHECK-LABEL: @test_float_fneg_pzero_out(
; CHECK-NEXT:    ret float 0xB800000000000000
  %result = fneg float 0x3800000000000000
  ret float %result
}

define float @test_float_fneg_psign_out() #0 {
; CHECK-LABEL: @test_float_fneg_psign_out(
; CHECK-NEXT:    ret float 0xB800000000000000
  %result = fneg float 0x3800000000000000
  ret float %result
}

define float @test_float_fneg_pzero_in() #0 {
; CHECK-LABEL: @test_float_fneg_pzero_in(
; CHECK-NEXT:    ret float 0xB800000000000000
  %result = fneg float 0x3800000000000000
  ret float %result
}

define float @test_float_fneg_psign_in() #0 {
; CHECK-LABEL: @test_float_fneg_psign_in(
; CHECK-NEXT:    ret float 0xB800000000000000
  %result = fneg float 0x3800000000000000
  ret float %result
}

define float @test_float_fneg_pzero_f32_out() #5 {
; CHECK-LABEL: @test_float_fneg_pzero_f32_out(
; CHECK-NEXT:    ret float 0xB800000000000000
  %result = fneg float 0x3800000000000000
  ret float %result
}

define double @test_double_fneg_ieee() #0 {
; CHECK-LABEL: @test_double_fneg_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
  %result = fneg double 0x8000000000000
  ret double %result
}

define double @test_double_fneg_pzero_out() #1 {
; CHECK-LABEL: @test_double_fneg_pzero_out(
; CHECK-NEXT:    ret double 0x8008000000000000
  %result = fneg double 0x8000000000000
  ret double %result
}

define double @test_double_fneg_psign_out() #2 {
; CHECK-LABEL: @test_double_fneg_psign_out(
; CHECK-NEXT:    ret double 0x8008000000000000
  %result = fneg double 0x8000000000000
  ret double %result
}

define double @test_double_fneg_pzero_in() #3 {
; CHECK-LABEL: @test_double_fneg_pzero_in(
; CHECK-NEXT:    ret double 0x8008000000000000
  %result = fneg double 0x8000000000000
  ret double %result
}

define double @test_double_fneg_psign_in() #4 {
; CHECK-LABEL: @test_double_fneg_psign_in(
; CHECK-NEXT:    ret double 0x8008000000000000
  %result = fneg double 0x8000000000000
  ret double %result
}

define double @test_double_fneg_f32_ieee() #5 {
; CHECK-LABEL: @test_double_fneg_f32_ieee(
; CHECK-NEXT:    ret double 0x8008000000000000
  %result = fneg double 0x8000000000000
  ret double %result
}

attributes #0 = { nounwind "denormal-fp-math"="ieee,ieee" }
attributes #1 = { nounwind "denormal-fp-math"="positive-zero,ieee" }
attributes #2 = { nounwind "denormal-fp-math"="preserve-sign,ieee" }
attributes #3 = { nounwind "denormal-fp-math"="ieee,positive-zero" }
attributes #4 = { nounwind "denormal-fp-math"="ieee,preserve-sign" }
attributes #5 = { nounwind "denormal-fp-math"="ieee,ieee" "denormal-fp-math-f32"="positive-zero,ieee" }
