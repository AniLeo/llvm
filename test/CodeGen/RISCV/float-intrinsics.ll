; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IF %s
; RUN: llc -mtriple=riscv32 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IF %s

declare float @llvm.sqrt.f32(float)

define float @sqrt_f32(float %a) nounwind {
; RV32IF-LABEL: sqrt_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fsqrt.s ft0, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.sqrt.f32(float %a)
  ret float %1
}

declare float @llvm.powi.f32(float, i32)

define float @powi_f32(float %a, i32 %b) nounwind {
; RV32IF-LABEL: powi_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call __powisf2
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.powi.f32(float %a, i32 %b)
  ret float %1
}

declare float @llvm.sin.f32(float)

define float @sin_f32(float %a) nounwind {
; RV32IF-LABEL: sin_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call sinf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.sin.f32(float %a)
  ret float %1
}

declare float @llvm.cos.f32(float)

define float @cos_f32(float %a) nounwind {
; RV32IF-LABEL: cos_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call cosf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.cos.f32(float %a)
  ret float %1
}

; The sin+cos combination results in an FSINCOS SelectionDAG node.
define float @sincos_f32(float %a) nounwind {
; RV32IF-LABEL: sincos_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    sw s1, 8(sp)
; RV32IF-NEXT:    sw s2, 4(sp)
; RV32IF-NEXT:    mv s1, a0
; RV32IF-NEXT:    call sinf
; RV32IF-NEXT:    mv s2, a0
; RV32IF-NEXT:    mv a0, s1
; RV32IF-NEXT:    call cosf
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fmv.w.x ft1, s2
; RV32IF-NEXT:    fadd.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    lw s2, 4(sp)
; RV32IF-NEXT:    lw s1, 8(sp)
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.sin.f32(float %a)
  %2 = call float @llvm.cos.f32(float %a)
  %3 = fadd float %1, %2
  ret float %3
}

declare float @llvm.pow.f32(float, float)

define float @pow_f32(float %a, float %b) nounwind {
; RV32IF-LABEL: pow_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call powf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.pow.f32(float %a, float %b)
  ret float %1
}

declare float @llvm.exp.f32(float)

define float @exp_f32(float %a) nounwind {
; RV32IF-LABEL: exp_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call expf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.exp.f32(float %a)
  ret float %1
}

declare float @llvm.exp2.f32(float)

define float @exp2_f32(float %a) nounwind {
; RV32IF-LABEL: exp2_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call exp2f
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.exp2.f32(float %a)
  ret float %1
}

declare float @llvm.log.f32(float)

define float @log_f32(float %a) nounwind {
; RV32IF-LABEL: log_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call logf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.log.f32(float %a)
  ret float %1
}

declare float @llvm.log10.f32(float)

define float @log10_f32(float %a) nounwind {
; RV32IF-LABEL: log10_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call log10f
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.log10.f32(float %a)
  ret float %1
}

declare float @llvm.log2.f32(float)

define float @log2_f32(float %a) nounwind {
; RV32IF-LABEL: log2_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call log2f
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.log2.f32(float %a)
  ret float %1
}

declare float @llvm.fma.f32(float, float, float)

define float @fma_f32(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fma_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a2
; RV32IF-NEXT:    fmv.w.x ft1, a1
; RV32IF-NEXT:    fmv.w.x ft2, a0
; RV32IF-NEXT:    fmadd.s ft0, ft2, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.fma.f32(float %a, float %b, float %c)
  ret float %1
}

declare float @llvm.fmuladd.f32(float, float, float)

define float @fmuladd_f32(float %a, float %b, float %c) nounwind {
; Use of fmadd depends on TargetLowering::isFMAFasterthanFMulAndFAdd
; RV32IF-LABEL: fmuladd_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fmul.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.w.x ft1, a2
; RV32IF-NEXT:    fadd.s ft0, ft0, ft1
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.fmuladd.f32(float %a, float %b, float %c)
  ret float %1
}

declare float @llvm.fabs.f32(float)

define float @fabs_f32(float %a) nounwind {
; RV32IF-LABEL: fabs_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    lui a1, 524288
; RV32IF-NEXT:    addi a1, a1, -1
; RV32IF-NEXT:    and a0, a0, a1
; RV32IF-NEXT:    ret
  %1 = call float @llvm.fabs.f32(float %a)
  ret float %1
}

declare float @llvm.minnum.f32(float, float)

define float @minnum_f32(float %a, float %b) nounwind {
; RV32IF-LABEL: minnum_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fmin.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.minnum.f32(float %a, float %b)
  ret float %1
}

declare float @llvm.maxnum.f32(float, float)

define float @maxnum_f32(float %a, float %b) nounwind {
; RV32IF-LABEL: maxnum_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fmax.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.maxnum.f32(float %a, float %b)
  ret float %1
}

; TODO: FMINNAN and FMAXNAN aren't handled in
; SelectionDAGLegalize::ExpandNode.

; declare float @llvm.minimum.f32(float, float)

; define float @fminimum_f32(float %a, float %b) nounwind {
;   %1 = call float @llvm.minimum.f32(float %a, float %b)
;   ret float %1
; }

; declare float @llvm.maximum.f32(float, float)

; define float @fmaximum_f32(float %a, float %b) nounwind {
;   %1 = call float @llvm.maximum.f32(float %a, float %b)
;   ret float %1
; }

declare float @llvm.copysign.f32(float, float)

define float @copysign_f32(float %a, float %b) nounwind {
; RV32IF-LABEL: copysign_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fsgnj.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
  %1 = call float @llvm.copysign.f32(float %a, float %b)
  ret float %1
}

declare float @llvm.floor.f32(float)

define float @floor_f32(float %a) nounwind {
; RV32IF-LABEL: floor_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call floorf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.floor.f32(float %a)
  ret float %1
}

declare float @llvm.ceil.f32(float)

define float @ceil_f32(float %a) nounwind {
; RV32IF-LABEL: ceil_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call ceilf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.ceil.f32(float %a)
  ret float %1
}

declare float @llvm.trunc.f32(float)

define float @trunc_f32(float %a) nounwind {
; RV32IF-LABEL: trunc_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call truncf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.trunc.f32(float %a)
  ret float %1
}

declare float @llvm.rint.f32(float)

define float @rint_f32(float %a) nounwind {
; RV32IF-LABEL: rint_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call rintf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.rint.f32(float %a)
  ret float %1
}

declare float @llvm.nearbyint.f32(float)

define float @nearbyint_f32(float %a) nounwind {
; RV32IF-LABEL: nearbyint_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call nearbyintf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.nearbyint.f32(float %a)
  ret float %1
}

declare float @llvm.round.f32(float)

define float @round_f32(float %a) nounwind {
; RV32IF-LABEL: round_f32:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp)
; RV32IF-NEXT:    call roundf
; RV32IF-NEXT:    lw ra, 12(sp)
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
  %1 = call float @llvm.round.f32(float %a)
  ret float %1
}
