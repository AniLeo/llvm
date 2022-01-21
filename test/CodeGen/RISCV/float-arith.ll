; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   -target-abi=ilp32f | FileCheck -check-prefix=RV32IF %s
; RUN: llc -mtriple=riscv64 -mattr=+f -verify-machineinstrs < %s \
; RUN:   -target-abi=lp64f | FileCheck -check-prefix=RV64IF %s
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s

; These tests are each targeted at a particular RISC-V FPU instruction.
; Compares and conversions can be found in float-fcmp.ll and float-convert.ll
; respectively. Some other float-*.ll files in this folder exercise LLVM IR
; instructions that don't directly match a RISC-V instruction.

define float @fadd_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fadd_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fadd.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fadd_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fadd.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fadd_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fadd_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = fadd float %a, %b
  ret float %1
}

define float @fsub_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fsub_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fsub.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fsub_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fsub.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fsub_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __subsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fsub_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __subsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = fsub float %a, %b
  ret float %1
}

define float @fmul_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fmul_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmul.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmul_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmul.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmul_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __mulsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmul_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __mulsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = fmul float %a, %b
  ret float %1
}

define float @fdiv_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fdiv_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fdiv.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fdiv_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fdiv.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fdiv_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __divsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fdiv_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __divsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = fdiv float %a, %b
  ret float %1
}

declare float @llvm.sqrt.f32(float)

define float @fsqrt_s(float %a) nounwind {
; RV32IF-LABEL: fsqrt_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fsqrt.s fa0, fa0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fsqrt_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fsqrt.s fa0, fa0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fsqrt_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call sqrtf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fsqrt_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call sqrtf@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.sqrt.f32(float %a)
  ret float %1
}

declare float @llvm.copysign.f32(float, float)

define float @fsgnj_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fsgnj_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fsgnj.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fsgnj_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fsgnj.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fsgnj_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    srli a0, a0, 1
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fsgnj_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    slli a0, a0, 33
; RV64I-NEXT:    srli a0, a0, 33
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    ret
  %1 = call float @llvm.copysign.f32(float %a, float %b)
  ret float %1
}

; This function performs extra work to ensure that
; DAGCombiner::visitBITCAST doesn't replace the fneg with an xor.
define i32 @fneg_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fneg_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fadd.s ft0, fa0, fa0
; RV32IF-NEXT:    fneg.s ft1, ft0
; RV32IF-NEXT:    feq.s a0, ft0, ft1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fneg_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fadd.s ft0, fa0, fa0
; RV64IF-NEXT:    fneg.s ft1, ft0
; RV64IF-NEXT:    feq.s a0, ft0, ft1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fneg_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    xor a1, a0, a1
; RV32I-NEXT:    call __eqsf2@plt
; RV32I-NEXT:    seqz a0, a0
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fneg_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a1, a0, a1
; RV64I-NEXT:    call __eqsf2@plt
; RV64I-NEXT:    seqz a0, a0
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = fadd float %a, %a
  %2 = fneg float %1
  %3 = fcmp oeq float %1, %2
  %4 = zext i1 %3 to i32
  ret i32 %4
}

; This function performs extra work to ensure that
; DAGCombiner::visitBITCAST doesn't replace the fneg with an xor.
define float @fsgnjn_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fsgnjn_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fadd.s ft0, fa0, fa1
; RV32IF-NEXT:    fsgnjn.s fa0, fa0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fsgnjn_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fadd.s ft0, fa0, fa1
; RV64IF-NEXT:    fsgnjn.s fa0, fa0, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fsgnjn_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    not a0, a0
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    slli a1, s0, 1
; RV32I-NEXT:    srli a1, a1, 1
; RV32I-NEXT:    or a0, a1, a0
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fsgnjn_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    not a0, a0
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    slli a1, s0, 33
; RV64I-NEXT:    srli a1, a1, 33
; RV64I-NEXT:    or a0, a1, a0
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = fadd float %a, %b
  %2 = fneg float %1
  %3 = call float @llvm.copysign.f32(float %a, float %2)
  ret float %3
}

declare float @llvm.fabs.f32(float)

; This function performs extra work to ensure that
; DAGCombiner::visitBITCAST doesn't replace the fabs with an and.
define float @fabs_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fabs_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fadd.s ft0, fa0, fa1
; RV32IF-NEXT:    fabs.s ft1, ft0
; RV32IF-NEXT:    fadd.s fa0, ft1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fabs_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fadd.s ft0, fa0, fa1
; RV64IF-NEXT:    fabs.s ft1, ft0
; RV64IF-NEXT:    fadd.s fa0, ft1, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fabs_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    slli a0, a0, 1
; RV32I-NEXT:    srli a0, a0, 1
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fabs_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    slli a0, a0, 33
; RV64I-NEXT:    srli a0, a0, 33
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = fadd float %a, %b
  %2 = call float @llvm.fabs.f32(float %1)
  %3 = fadd float %2, %1
  ret float %3
}

declare float @llvm.minnum.f32(float, float)

define float @fmin_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fmin_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmin.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmin_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmin.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmin_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call fminf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmin_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call fminf@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.minnum.f32(float %a, float %b)
  ret float %1
}

declare float @llvm.maxnum.f32(float, float)

define float @fmax_s(float %a, float %b) nounwind {
; RV32IF-LABEL: fmax_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmax.s fa0, fa0, fa1
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmax_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmax.s fa0, fa0, fa1
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmax_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call fmaxf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmax_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call fmaxf@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.maxnum.f32(float %a, float %b)
  ret float %1
}

declare float @llvm.fma.f32(float, float, float)

define float @fmadd_s(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fmadd_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmadd.s fa0, fa0, fa1, fa2
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmadd_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmadd.s fa0, fa0, fa1, fa2
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmadd_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmadd_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = call float @llvm.fma.f32(float %a, float %b, float %c)
  ret float %1
}

define float @fmsub_s(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fmsub_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft0, fa2, ft0
; RV32IF-NEXT:    fmsub.s fa0, fa0, fa1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmsub_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft0, fa2, ft0
; RV64IF-NEXT:    fmsub.s fa0, fa0, fa1, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmsub_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a1
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    xor a2, a0, a1
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    mv a1, s0
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmsub_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a1
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a2, a0, a1
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    mv a1, s0
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %c_ = fadd float 0.0, %c ; avoid negation using xor
  %negc = fsub float -0.0, %c_
  %1 = call float @llvm.fma.f32(float %a, float %b, float %negc)
  ret float %1
}

define float @fnmadd_s(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fnmadd_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft1, fa0, ft0
; RV32IF-NEXT:    fadd.s ft0, fa2, ft0
; RV32IF-NEXT:    fnmadd.s fa0, ft1, fa1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmadd_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft1, fa0, ft0
; RV64IF-NEXT:    fadd.s ft0, fa2, ft0
; RV64IF-NEXT:    fnmadd.s fa0, ft1, fa1, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmadd_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s1, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    xor a1, s2, a2
; RV32I-NEXT:    xor a2, a0, a2
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmadd_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s2, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s1, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv s2, a0
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    xor a1, s2, a2
; RV64I-NEXT:    xor a2, a0, a2
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    mv a1, s1
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s2, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %a_ = fadd float 0.0, %a
  %c_ = fadd float 0.0, %c
  %nega = fsub float -0.0, %a_
  %negc = fsub float -0.0, %c_
  %1 = call float @llvm.fma.f32(float %nega, float %b, float %negc)
  ret float %1
}

define float @fnmadd_s_2(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fnmadd_s_2:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft1, fa1, ft0
; RV32IF-NEXT:    fadd.s ft0, fa2, ft0
; RV32IF-NEXT:    fnmadd.s fa0, ft1, fa0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmadd_s_2:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft1, fa1, ft0
; RV64IF-NEXT:    fadd.s ft0, fa2, ft0
; RV64IF-NEXT:    fnmadd.s fa0, ft1, fa0, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmadd_s_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    xor a1, s2, a2
; RV32I-NEXT:    xor a2, a0, a2
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmadd_s_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s2, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv s2, a0
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    xor a1, s2, a2
; RV64I-NEXT:    xor a2, a0, a2
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s2, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %b_ = fadd float 0.0, %b
  %c_ = fadd float 0.0, %c
  %negb = fsub float -0.0, %b_
  %negc = fsub float -0.0, %c_
  %1 = call float @llvm.fma.f32(float %a, float %negb, float %negc)
  ret float %1
}

define float @fnmsub_s(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fnmsub_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft0, fa0, ft0
; RV32IF-NEXT:    fnmsub.s fa0, ft0, fa1, fa2
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmsub_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft0, fa0, ft0
; RV64IF-NEXT:    fnmsub.s fa0, ft0, fa1, fa2
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmsub_s:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s1, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    mv a2, s0
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmsub_s:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s1, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    mv a1, s1
; RV64I-NEXT:    mv a2, s0
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %a_ = fadd float 0.0, %a
  %nega = fsub float -0.0, %a_
  %1 = call float @llvm.fma.f32(float %nega, float %b, float %c)
  ret float %1
}

define float @fnmsub_s_2(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fnmsub_s_2:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft0, fa1, ft0
; RV32IF-NEXT:    fnmsub.s fa0, ft0, fa0, fa2
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmsub_s_2:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft0, fa1, ft0
; RV64IF-NEXT:    fnmsub.s fa0, ft0, fa0, fa2
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmsub_s_2:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    xor a1, a0, a1
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    mv a2, s0
; RV32I-NEXT:    call fmaf@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmsub_s_2:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a1, a0, a1
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    mv a2, s0
; RV64I-NEXT:    call fmaf@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %b_ = fadd float 0.0, %b
  %negb = fsub float -0.0, %b_
  %1 = call float @llvm.fma.f32(float %a, float %negb, float %c)
  ret float %1
}

define float @fmadd_s_contract(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fmadd_s_contract:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmadd.s fa0, fa0, fa1, fa2
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmadd_s_contract:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmadd.s fa0, fa0, fa1, fa2
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmadd_s_contract:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    call __mulsf3@plt
; RV32I-NEXT:    mv a1, s0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmadd_s_contract:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    call __mulsf3@plt
; RV64I-NEXT:    mv a1, s0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
  %1 = fmul contract float %a, %b
  %2 = fadd contract float %1, %c
  ret float %2
}

define float @fmsub_s_contract(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fmsub_s_contract:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft0, fa2, ft0
; RV32IF-NEXT:    fmsub.s fa0, fa0, fa1, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmsub_s_contract:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft0, fa2, ft0
; RV64IF-NEXT:    fmsub.s fa0, fa0, fa1, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fmsub_s_contract:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a1
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, a2
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    mv a1, s0
; RV32I-NEXT:    call __mulsf3@plt
; RV32I-NEXT:    mv a1, s2
; RV32I-NEXT:    call __subsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fmsub_s_contract:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s2, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a1
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, a2
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv s2, a0
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    mv a1, s0
; RV64I-NEXT:    call __mulsf3@plt
; RV64I-NEXT:    mv a1, s2
; RV64I-NEXT:    call __subsf3@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s2, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %c_ = fadd float 0.0, %c ; avoid negation using xor
  %1 = fmul contract float %a, %b
  %2 = fsub contract float %1, %c_
  ret float %2
}

define float @fnmadd_s_contract(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fnmadd_s_contract:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft1, fa0, ft0
; RV32IF-NEXT:    fadd.s ft2, fa1, ft0
; RV32IF-NEXT:    fadd.s ft0, fa2, ft0
; RV32IF-NEXT:    fnmadd.s fa0, ft1, ft2, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmadd_s_contract:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft1, fa0, ft0
; RV64IF-NEXT:    fadd.s ft2, fa1, ft0
; RV64IF-NEXT:    fadd.s ft0, fa2, ft0
; RV64IF-NEXT:    fnmadd.s fa0, ft1, ft2, ft0
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmadd_s_contract:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s1, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv s1, a0
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv s0, a0
; RV32I-NEXT:    mv a0, s2
; RV32I-NEXT:    mv a1, s1
; RV32I-NEXT:    call __mulsf3@plt
; RV32I-NEXT:    lui a1, 524288
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    mv a1, s0
; RV32I-NEXT:    call __subsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmadd_s_contract:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s2, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s1, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv s2, a0
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv s1, a0
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv s0, a0
; RV64I-NEXT:    mv a0, s2
; RV64I-NEXT:    mv a1, s1
; RV64I-NEXT:    call __mulsf3@plt
; RV64I-NEXT:    lui a1, 524288
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    mv a1, s0
; RV64I-NEXT:    call __subsf3@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s2, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %a_ = fadd float 0.0, %a ; avoid negation using xor
  %b_ = fadd float 0.0, %b ; avoid negation using xor
  %c_ = fadd float 0.0, %c ; avoid negation using xor
  %1 = fmul contract float %a_, %b_
  %2 = fneg float %1
  %3 = fsub contract float %2, %c_
  ret float %3
}

define float @fnmsub_s_contract(float %a, float %b, float %c) nounwind {
; RV32IF-LABEL: fnmsub_s_contract:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, zero
; RV32IF-NEXT:    fadd.s ft1, fa0, ft0
; RV32IF-NEXT:    fadd.s ft0, fa1, ft0
; RV32IF-NEXT:    fnmsub.s fa0, ft1, ft0, fa2
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fnmsub_s_contract:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, zero
; RV64IF-NEXT:    fadd.s ft1, fa0, ft0
; RV64IF-NEXT:    fadd.s ft0, fa1, ft0
; RV64IF-NEXT:    fnmsub.s fa0, ft1, ft0, fa2
; RV64IF-NEXT:    ret
;
; RV32I-LABEL: fnmsub_s_contract:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s1, 4(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s2, 0(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a2
; RV32I-NEXT:    mv s1, a1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv s2, a0
; RV32I-NEXT:    mv a0, s1
; RV32I-NEXT:    li a1, 0
; RV32I-NEXT:    call __addsf3@plt
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    mv a0, s2
; RV32I-NEXT:    call __mulsf3@plt
; RV32I-NEXT:    mv a1, a0
; RV32I-NEXT:    mv a0, s0
; RV32I-NEXT:    call __subsf3@plt
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s1, 4(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw s2, 0(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV64I-LABEL: fnmsub_s_contract:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -32
; RV64I-NEXT:    sd ra, 24(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 16(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s1, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s2, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a2
; RV64I-NEXT:    mv s1, a1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv s2, a0
; RV64I-NEXT:    mv a0, s1
; RV64I-NEXT:    li a1, 0
; RV64I-NEXT:    call __addsf3@plt
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    mv a0, s2
; RV64I-NEXT:    call __mulsf3@plt
; RV64I-NEXT:    mv a1, a0
; RV64I-NEXT:    mv a0, s0
; RV64I-NEXT:    call __subsf3@plt
; RV64I-NEXT:    ld ra, 24(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s0, 16(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s1, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld s2, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 32
; RV64I-NEXT:    ret
  %a_ = fadd float 0.0, %a ; avoid negation using xor
  %b_ = fadd float 0.0, %b ; avoid negation using xor
  %1 = fmul contract float %a_, %b_
  %2 = fsub contract float %c, %1
  ret float %2
}
