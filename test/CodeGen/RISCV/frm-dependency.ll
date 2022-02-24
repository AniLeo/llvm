; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+f,+d -stop-after=finalize-isel < %s \
; RUN:   -target-abi=ilp32d | FileCheck -check-prefixes=RV32IF %s
; RUN: llc -mtriple=riscv64 -mattr=+f,+d -stop-after=finalize-isel < %s \
; RUN:   -target-abi=lp64d | FileCheck -check-prefixes=RV64IF %s

; Make sure an implicit FRM dependency is added to instructions with dynamic
; rounding.

define float @fadd_s(float %a, float %b) nounwind {
  ; RV32IF-LABEL: name: fadd_s
  ; RV32IF: bb.0 (%ir-block.0):
  ; RV32IF-NEXT:   liveins: $f10_f, $f11_f
  ; RV32IF-NEXT: {{  $}}
  ; RV32IF-NEXT:   [[COPY:%[0-9]+]]:fpr32 = COPY $f11_f
  ; RV32IF-NEXT:   [[COPY1:%[0-9]+]]:fpr32 = COPY $f10_f
  ; RV32IF-NEXT:   %2:fpr32 = nofpexcept FADD_S [[COPY1]], [[COPY]], 7, implicit $frm
  ; RV32IF-NEXT:   $f10_f = COPY %2
  ; RV32IF-NEXT:   PseudoRET implicit $f10_f
  ; RV64IF-LABEL: name: fadd_s
  ; RV64IF: bb.0 (%ir-block.0):
  ; RV64IF-NEXT:   liveins: $f10_f, $f11_f
  ; RV64IF-NEXT: {{  $}}
  ; RV64IF-NEXT:   [[COPY:%[0-9]+]]:fpr32 = COPY $f11_f
  ; RV64IF-NEXT:   [[COPY1:%[0-9]+]]:fpr32 = COPY $f10_f
  ; RV64IF-NEXT:   %2:fpr32 = nofpexcept FADD_S [[COPY1]], [[COPY]], 7, implicit $frm
  ; RV64IF-NEXT:   $f10_f = COPY %2
  ; RV64IF-NEXT:   PseudoRET implicit $f10_f
  %1 = fadd float %a, %b
  ret float %1
}

declare float @llvm.fma.f32(float, float, float)

define float @fmadd_s(float %a, float %b, float %c) nounwind {
  ; RV32IF-LABEL: name: fmadd_s
  ; RV32IF: bb.0 (%ir-block.0):
  ; RV32IF-NEXT:   liveins: $f10_f, $f11_f, $f12_f
  ; RV32IF-NEXT: {{  $}}
  ; RV32IF-NEXT:   [[COPY:%[0-9]+]]:fpr32 = COPY $f12_f
  ; RV32IF-NEXT:   [[COPY1:%[0-9]+]]:fpr32 = COPY $f11_f
  ; RV32IF-NEXT:   [[COPY2:%[0-9]+]]:fpr32 = COPY $f10_f
  ; RV32IF-NEXT:   %3:fpr32 = nofpexcept FMADD_S [[COPY2]], [[COPY1]], [[COPY]], 7, implicit $frm
  ; RV32IF-NEXT:   $f10_f = COPY %3
  ; RV32IF-NEXT:   PseudoRET implicit $f10_f
  ; RV64IF-LABEL: name: fmadd_s
  ; RV64IF: bb.0 (%ir-block.0):
  ; RV64IF-NEXT:   liveins: $f10_f, $f11_f, $f12_f
  ; RV64IF-NEXT: {{  $}}
  ; RV64IF-NEXT:   [[COPY:%[0-9]+]]:fpr32 = COPY $f12_f
  ; RV64IF-NEXT:   [[COPY1:%[0-9]+]]:fpr32 = COPY $f11_f
  ; RV64IF-NEXT:   [[COPY2:%[0-9]+]]:fpr32 = COPY $f10_f
  ; RV64IF-NEXT:   %3:fpr32 = nofpexcept FMADD_S [[COPY2]], [[COPY1]], [[COPY]], 7, implicit $frm
  ; RV64IF-NEXT:   $f10_f = COPY %3
  ; RV64IF-NEXT:   PseudoRET implicit $f10_f
  %1 = call float @llvm.fma.f32(float %a, float %b, float %c)
  ret float %1
}

; This uses rtz instead of dyn rounding mode so shouldn't have an FRM dependncy.
define i32 @fcvt_w_s(float %a) nounwind {
  ; RV32IF-LABEL: name: fcvt_w_s
  ; RV32IF: bb.0 (%ir-block.0):
  ; RV32IF-NEXT:   liveins: $f10_f
  ; RV32IF-NEXT: {{  $}}
  ; RV32IF-NEXT:   [[COPY:%[0-9]+]]:fpr32 = COPY $f10_f
  ; RV32IF-NEXT:   %1:gpr = nofpexcept FCVT_W_S [[COPY]], 1
  ; RV32IF-NEXT:   $x10 = COPY %1
  ; RV32IF-NEXT:   PseudoRET implicit $x10
  ; RV64IF-LABEL: name: fcvt_w_s
  ; RV64IF: bb.0 (%ir-block.0):
  ; RV64IF-NEXT:   liveins: $f10_f
  ; RV64IF-NEXT: {{  $}}
  ; RV64IF-NEXT:   [[COPY:%[0-9]+]]:fpr32 = COPY $f10_f
  ; RV64IF-NEXT:   %1:gpr = nofpexcept FCVT_W_S [[COPY]], 1
  ; RV64IF-NEXT:   $x10 = COPY %1
  ; RV64IF-NEXT:   PseudoRET implicit $x10
  %1 = fptosi float %a to i32
  ret i32 %1
}

; This doesn't use a rounding mode since i32 can be represented exactly as a
; double.
define double @fcvt_d_w(i32 %a) nounwind {
  ; RV32IF-LABEL: name: fcvt_d_w
  ; RV32IF: bb.0 (%ir-block.0):
  ; RV32IF-NEXT:   liveins: $x10
  ; RV32IF-NEXT: {{  $}}
  ; RV32IF-NEXT:   [[COPY:%[0-9]+]]:gpr = COPY $x10
  ; RV32IF-NEXT:   %1:fpr64 = nofpexcept FCVT_D_W [[COPY]]
  ; RV32IF-NEXT:   $f10_d = COPY %1
  ; RV32IF-NEXT:   PseudoRET implicit $f10_d
  ; RV64IF-LABEL: name: fcvt_d_w
  ; RV64IF: bb.0 (%ir-block.0):
  ; RV64IF-NEXT:   liveins: $x10
  ; RV64IF-NEXT: {{  $}}
  ; RV64IF-NEXT:   [[COPY:%[0-9]+]]:gpr = COPY $x10
  ; RV64IF-NEXT:   %1:fpr64 = nofpexcept FCVT_D_W [[COPY]]
  ; RV64IF-NEXT:   $f10_d = COPY %1
  ; RV64IF-NEXT:   PseudoRET implicit $f10_d
  %1 = sitofp i32 %a to double
  ret double %1
}
