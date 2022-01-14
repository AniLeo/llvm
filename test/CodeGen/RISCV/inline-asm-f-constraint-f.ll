; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32F %s
; RUN: llc -mtriple=riscv64 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64F %s
; RUN: llc -mtriple=riscv32 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32D %s
; RUN: llc -mtriple=riscv64 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64D %s

@gf = external global float

define float @constraint_f_float(float %a) nounwind {
; RV32-LABEL: constraint_f_float:
; RV32:       # %bb.0:
; RV32-NEXT:    lui a1, %hi(gf)
; RV32-NEXT:    flw ft0, %lo(gf)(a1)
; RV32-NEXT:    fmv.w.x ft1, a0
; RV32-NEXT:    #APP
; RV32-NEXT:    fadd.s ft0, ft1, ft0
; RV32-NEXT:    #NO_APP
; RV32-NEXT:    fmv.x.w a0, ft0
; RV32-NEXT:    ret
;
; RV64-LABEL: constraint_f_float:
; RV64:       # %bb.0:
; RV64-NEXT:    lui a1, %hi(gf)
; RV64-NEXT:    flw ft0, %lo(gf)(a1)
; RV64-NEXT:    fmv.w.x ft1, a0
; RV64-NEXT:    #APP
; RV64-NEXT:    fadd.s ft0, ft1, ft0
; RV64-NEXT:    #NO_APP
; RV64-NEXT:    fmv.x.w a0, ft0
; RV64-NEXT:    ret
; RV32F-LABEL: constraint_f_float:
; RV32F:       # %bb.0:
; RV32F-NEXT:    lui a1, %hi(gf)
; RV32F-NEXT:    flw ft0, %lo(gf)(a1)
; RV32F-NEXT:    fmv.w.x ft1, a0
; RV32F-NEXT:    #APP
; RV32F-NEXT:    fadd.s ft0, ft1, ft0
; RV32F-NEXT:    #NO_APP
; RV32F-NEXT:    fmv.x.w a0, ft0
; RV32F-NEXT:    ret
;
; RV64F-LABEL: constraint_f_float:
; RV64F:       # %bb.0:
; RV64F-NEXT:    lui a1, %hi(gf)
; RV64F-NEXT:    flw ft0, %lo(gf)(a1)
; RV64F-NEXT:    fmv.w.x ft1, a0
; RV64F-NEXT:    #APP
; RV64F-NEXT:    fadd.s ft0, ft1, ft0
; RV64F-NEXT:    #NO_APP
; RV64F-NEXT:    fmv.x.w a0, ft0
; RV64F-NEXT:    ret
;
; RV32D-LABEL: constraint_f_float:
; RV32D:       # %bb.0:
; RV32D-NEXT:    lui a1, %hi(gf)
; RV32D-NEXT:    flw ft0, %lo(gf)(a1)
; RV32D-NEXT:    fmv.w.x ft1, a0
; RV32D-NEXT:    #APP
; RV32D-NEXT:    fadd.s ft0, ft1, ft0
; RV32D-NEXT:    #NO_APP
; RV32D-NEXT:    fmv.x.w a0, ft0
; RV32D-NEXT:    ret
;
; RV64D-LABEL: constraint_f_float:
; RV64D:       # %bb.0:
; RV64D-NEXT:    lui a1, %hi(gf)
; RV64D-NEXT:    flw ft0, %lo(gf)(a1)
; RV64D-NEXT:    fmv.w.x ft1, a0
; RV64D-NEXT:    #APP
; RV64D-NEXT:    fadd.s ft0, ft1, ft0
; RV64D-NEXT:    #NO_APP
; RV64D-NEXT:    fmv.x.w a0, ft0
; RV64D-NEXT:    ret
  %1 = load float, float* @gf
  %2 = tail call float asm "fadd.s $0, $1, $2", "=f,f,f"(float %a, float %1)
  ret float %2
}

define float @constraint_f_float_abi_name(float %a) nounwind {
; RV32F-LABEL: constraint_f_float_abi_name:
; RV32F:       # %bb.0:
; RV32F-NEXT:    lui a1, %hi(gf)
; RV32F-NEXT:    flw fs0, %lo(gf)(a1)
; RV32F-NEXT:    fmv.w.x fa0, a0
; RV32F-NEXT:    #APP
; RV32F-NEXT:    fadd.s ft0, fa0, fs0
; RV32F-NEXT:    #NO_APP
; RV32F-NEXT:    fmv.x.w a0, ft0
; RV32F-NEXT:    ret
;
; RV64F-LABEL: constraint_f_float_abi_name:
; RV64F:       # %bb.0:
; RV64F-NEXT:    lui a1, %hi(gf)
; RV64F-NEXT:    flw fs0, %lo(gf)(a1)
; RV64F-NEXT:    fmv.w.x fa0, a0
; RV64F-NEXT:    #APP
; RV64F-NEXT:    fadd.s ft0, fa0, fs0
; RV64F-NEXT:    #NO_APP
; RV64F-NEXT:    fmv.x.w a0, ft0
; RV64F-NEXT:    ret
;
; RV32D-LABEL: constraint_f_float_abi_name:
; RV32D:       # %bb.0:
; RV32D-NEXT:    lui a1, %hi(gf)
; RV32D-NEXT:    flw ft0, %lo(gf)(a1)
; RV32D-NEXT:    fmv.w.x ft1, a0
; RV32D-NEXT:    fcvt.d.s fa0, ft1
; RV32D-NEXT:    fcvt.d.s fs0, ft0
; RV32D-NEXT:    #APP
; RV32D-NEXT:    fadd.s ft0, fa0, fs0
; RV32D-NEXT:    #NO_APP
; RV32D-NEXT:    fcvt.s.d ft0, ft0
; RV32D-NEXT:    fmv.x.w a0, ft0
; RV32D-NEXT:    ret
;
; RV64D-LABEL: constraint_f_float_abi_name:
; RV64D:       # %bb.0:
; RV64D-NEXT:    lui a1, %hi(gf)
; RV64D-NEXT:    flw ft0, %lo(gf)(a1)
; RV64D-NEXT:    fmv.w.x ft1, a0
; RV64D-NEXT:    fcvt.d.s fa0, ft1
; RV64D-NEXT:    fcvt.d.s fs0, ft0
; RV64D-NEXT:    #APP
; RV64D-NEXT:    fadd.s ft0, fa0, fs0
; RV64D-NEXT:    #NO_APP
; RV64D-NEXT:    fcvt.s.d ft0, ft0
; RV64D-NEXT:    fmv.x.w a0, ft0
; RV64D-NEXT:    ret
  %1 = load float, float* @gf
  %2 = tail call float asm "fadd.s $0, $1, $2", "={ft0},{fa0},{fs0}"(float %a, float %1)
  ret float %2
}
