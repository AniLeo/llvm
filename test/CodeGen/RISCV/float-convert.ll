; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IF %s
; RUN: llc -mtriple=riscv64 -mattr=+f -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64IF %s

; For RV64F, fcvt.l.s is semantically equivalent to fcvt.w.s in this case
; because fptosi will produce poison if the result doesn't fit into an i32.
define i32 @fcvt_w_s(float %a) nounwind {
; RV32IF-LABEL: fcvt_w_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fcvt.w.s a0, ft0, rtz
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_w_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.l.s a0, ft0, rtz
; RV64IF-NEXT:    ret
  %1 = fptosi float %a to i32
  ret i32 %1
}

; For RV64F, fcvt.lu.s is semantically equivalent to fcvt.wu.s in this case
; because fptoui will produce poison if the result doesn't fit into an i32.
define i32 @fcvt_wu_s(float %a) nounwind {
; RV32IF-LABEL: fcvt_wu_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fcvt.wu.s a0, ft0, rtz
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_wu_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.lu.s a0, ft0, rtz
; RV64IF-NEXT:    ret
  %1 = fptoui float %a to i32
  ret i32 %1
}

define i32 @fmv_x_w(float %a, float %b) nounwind {
; RV32IF-LABEL: fmv_x_w:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a1
; RV32IF-NEXT:    fmv.w.x ft1, a0
; RV32IF-NEXT:    fadd.s ft0, ft1, ft0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmv_x_w:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a1
; RV64IF-NEXT:    fmv.w.x ft1, a0
; RV64IF-NEXT:    fadd.s ft0, ft1, ft0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
; Ensure fmv.x.w is generated even for a soft float calling convention
  %1 = fadd float %a, %b
  %2 = bitcast float %1 to i32
  ret i32 %2
}

define float @fcvt_s_w(i32 %a) nounwind {
; RV32IF-LABEL: fcvt_s_w:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fcvt.s.w ft0, a0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_s_w:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.w ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = sitofp i32 %a to float
  ret float %1
}

define float @fcvt_s_wu(i32 %a) nounwind {
; RV32IF-LABEL: fcvt_s_wu:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fcvt.s.wu ft0, a0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_s_wu:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.wu ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = uitofp i32 %a to float
  ret float %1
}

define float @fmv_w_x(i32 %a, i32 %b) nounwind {
; RV32IF-LABEL: fmv_w_x:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fmv.w.x ft0, a0
; RV32IF-NEXT:    fmv.w.x ft1, a1
; RV32IF-NEXT:    fadd.s ft0, ft0, ft1
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fmv_w_x:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fmv.w.x ft1, a1
; RV64IF-NEXT:    fadd.s ft0, ft0, ft1
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
; Ensure fmv.w.x is generated even for a soft float calling convention
  %1 = bitcast i32 %a to float
  %2 = bitcast i32 %b to float
  %3 = fadd float %1, %2
  ret float %3
}

define i64 @fcvt_l_s(float %a) nounwind {
; RV32IF-LABEL: fcvt_l_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IF-NEXT:    call __fixsfdi@plt
; RV32IF-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_l_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.l.s a0, ft0, rtz
; RV64IF-NEXT:    ret
  %1 = fptosi float %a to i64
  ret i64 %1
}

define i64 @fcvt_lu_s(float %a) nounwind {
; RV32IF-LABEL: fcvt_lu_s:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IF-NEXT:    call __fixunssfdi@plt
; RV32IF-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_lu_s:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fmv.w.x ft0, a0
; RV64IF-NEXT:    fcvt.lu.s a0, ft0, rtz
; RV64IF-NEXT:    ret
  %1 = fptoui float %a to i64
  ret i64 %1
}

define float @fcvt_s_l(i64 %a) nounwind {
; RV32IF-LABEL: fcvt_s_l:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IF-NEXT:    call __floatdisf@plt
; RV32IF-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_s_l:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.l ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = sitofp i64 %a to float
  ret float %1
}

define float @fcvt_s_lu(i64 %a) nounwind {
; RV32IF-LABEL: fcvt_s_lu:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    addi sp, sp, -16
; RV32IF-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IF-NEXT:    call __floatundisf@plt
; RV32IF-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IF-NEXT:    addi sp, sp, 16
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_s_lu:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.lu ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = uitofp i64 %a to float
  ret float %1
}

define float @fcvt_s_w_i8(i8 signext %a) nounwind {
; RV32IF-LABEL: fcvt_s_w_i8:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fcvt.s.w ft0, a0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_s_w_i8:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.w ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = sitofp i8 %a to float
  ret float %1
}

define float @fcvt_s_wu_i8(i8 zeroext %a) nounwind {
; RV32IF-LABEL: fcvt_s_wu_i8:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fcvt.s.wu ft0, a0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_s_wu_i8:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.wu ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = uitofp i8 %a to float
  ret float %1
}

define float @fcvt_s_w_i16(i16 signext %a) nounwind {
; RV32IF-LABEL: fcvt_s_w_i16:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fcvt.s.w ft0, a0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_s_w_i16:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.w ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = sitofp i16 %a to float
  ret float %1
}

define float @fcvt_s_wu_i16(i16 zeroext %a) nounwind {
; RV32IF-LABEL: fcvt_s_wu_i16:
; RV32IF:       # %bb.0:
; RV32IF-NEXT:    fcvt.s.wu ft0, a0
; RV32IF-NEXT:    fmv.x.w a0, ft0
; RV32IF-NEXT:    ret
;
; RV64IF-LABEL: fcvt_s_wu_i16:
; RV64IF:       # %bb.0:
; RV64IF-NEXT:    fcvt.s.wu ft0, a0
; RV64IF-NEXT:    fmv.x.w a0, ft0
; RV64IF-NEXT:    ret
  %1 = uitofp i16 %a to float
  ret float %1
}
