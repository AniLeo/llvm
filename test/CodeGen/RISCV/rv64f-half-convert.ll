; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zfh -verify-machineinstrs \
; RUN:   -target-abi lp64f < %s | FileCheck %s -check-prefix=RV64IZFH

; This file exhaustively checks half<->i32 conversions. In general,
; fcvt.l[u].h can be selected instead of fcvt.w[u].h because poison is
; generated for an fpto[s|u]i conversion if the result doesn't fit in the
; target type.

define i32 @aext_fptosi(half %a) nounwind {
; RV64IZFH-LABEL: aext_fptosi:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
  %1 = fptosi half %a to i32
  ret i32 %1
}

define signext i32 @sext_fptosi(half %a) nounwind {
; RV64IZFH-LABEL: sext_fptosi:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
  %1 = fptosi half %a to i32
  ret i32 %1
}

define zeroext i32 @zext_fptosi(half %a) nounwind {
; RV64IZFH-LABEL: zext_fptosi:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; RV64IZFH-NEXT:    slli a0, a0, 32
; RV64IZFH-NEXT:    srli a0, a0, 32
; RV64IZFH-NEXT:    ret
  %1 = fptosi half %a to i32
  ret i32 %1
}

define i32 @aext_fptoui(half %a) nounwind {
; RV64IZFH-LABEL: aext_fptoui:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.wu.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
  %1 = fptoui half %a to i32
  ret i32 %1
}

define signext i32 @sext_fptoui(half %a) nounwind {
; RV64IZFH-LABEL: sext_fptoui:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.wu.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
  %1 = fptoui half %a to i32
  ret i32 %1
}

define zeroext i32 @zext_fptoui(half %a) nounwind {
; RV64IZFH-LABEL: zext_fptoui:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.lu.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
  %1 = fptoui half %a to i32
  ret i32 %1
}

define i16 @bcvt_f16_to_aext_i16(half %a, half %b) nounwind {
; RV64IZFH-LABEL: bcvt_f16_to_aext_i16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fadd.h ft0, fa0, fa1
; RV64IZFH-NEXT:    fmv.x.h a0, ft0
; RV64IZFH-NEXT:    ret
  %1 = fadd half %a, %b
  %2 = bitcast half %1 to i16
  ret i16 %2
}

define signext i16 @bcvt_f16_to_sext_i16(half %a, half %b) nounwind {
; RV64IZFH-LABEL: bcvt_f16_to_sext_i16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fadd.h ft0, fa0, fa1
; RV64IZFH-NEXT:    fmv.x.h a0, ft0
; RV64IZFH-NEXT:    slli a0, a0, 48
; RV64IZFH-NEXT:    srai a0, a0, 48
; RV64IZFH-NEXT:    ret
  %1 = fadd half %a, %b
  %2 = bitcast half %1 to i16
  ret i16 %2
}

define zeroext i16 @bcvt_f16_to_zext_i16(half %a, half %b) nounwind {
; RV64IZFH-LABEL: bcvt_f16_to_zext_i16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fadd.h ft0, fa0, fa1
; RV64IZFH-NEXT:    fmv.x.h a0, ft0
; RV64IZFH-NEXT:    lui a1, 16
; RV64IZFH-NEXT:    addiw a1, a1, -1
; RV64IZFH-NEXT:    and a0, a0, a1
; RV64IZFH-NEXT:    ret
  %1 = fadd half %a, %b
  %2 = bitcast half %1 to i16
  ret i16 %2
}

define half @bcvt_i64_to_f16_via_i16(i64 %a, i64 %b) nounwind {
; RV64IZFH-LABEL: bcvt_i64_to_f16_via_i16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fmv.h.x ft0, a0
; RV64IZFH-NEXT:    fmv.h.x ft1, a1
; RV64IZFH-NEXT:    fadd.h fa0, ft0, ft1
; RV64IZFH-NEXT:    ret
  %1 = trunc i64 %a to i16
  %2 = trunc i64 %b to i16
  %3 = bitcast i16 %1 to half
  %4 = bitcast i16 %2 to half
  %5 = fadd half %3, %4
  ret half %5
}

define half @uitofp_aext_i32_to_f16(i32 %a) nounwind {
; RV64IZFH-LABEL: uitofp_aext_i32_to_f16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IZFH-NEXT:    ret
  %1 = uitofp i32 %a to half
  ret half %1
}

define half @uitofp_sext_i32_to_f16(i32 signext %a) nounwind {
; RV64IZFH-LABEL: uitofp_sext_i32_to_f16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IZFH-NEXT:    ret
  %1 = uitofp i32 %a to half
  ret half %1
}

define half @uitofp_zext_i32_to_f16(i32 zeroext %a) nounwind {
; RV64IZFH-LABEL: uitofp_zext_i32_to_f16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IZFH-NEXT:    ret
  %1 = uitofp i32 %a to half
  ret half %1
}

define half @sitofp_aext_i32_to_f16(i32 %a) nounwind {
; RV64IZFH-LABEL: sitofp_aext_i32_to_f16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IZFH-NEXT:    ret
  %1 = sitofp i32 %a to half
  ret half %1
}

define half @sitofp_sext_i32_to_f16(i32 signext %a) nounwind {
; RV64IZFH-LABEL: sitofp_sext_i32_to_f16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IZFH-NEXT:    ret
  %1 = sitofp i32 %a to half
  ret half %1
}

define half @sitofp_zext_i32_to_f16(i32 zeroext %a) nounwind {
; RV64IZFH-LABEL: sitofp_zext_i32_to_f16:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IZFH-NEXT:    ret
  %1 = sitofp i32 %a to half
  ret half %1
}
