; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zfh -verify-machineinstrs \
; RUN:   -target-abi ilp32f -disable-strictnode-mutation < %s \
; RUN:   | FileCheck -check-prefix=RV32IZFH %s
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zfh -verify-machineinstrs \
; RUN:   -target-abi lp64f -disable-strictnode-mutation < %s \
; RUN:   | FileCheck -check-prefix=RV64IZFH %s
; RUN: llc -mtriple=riscv32 -mattr=+d,+experimental-zfh -verify-machineinstrs \
; RUN:   -target-abi ilp32d -disable-strictnode-mutation < %s \
; RUN:   | FileCheck -check-prefix=RV32IDZFH %s
; RUN: llc -mtriple=riscv64 -mattr=+d,+experimental-zfh -verify-machineinstrs \
; RUN:   -target-abi lp64d -disable-strictnode-mutation < %s \
; RUN:   | FileCheck -check-prefix=RV64IDZFH %s

; NOTE: The rounding mode metadata does not effect which instruction is
; selected. Dynamic rounding mode is always used for operations that
; support rounding mode.

define i16 @fcvt_si_h(half %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_si_h:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_si_h:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.l.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_si_h:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_si_h:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.l.h a0, fa0, rtz
; RV64IDZFH-NEXT:    ret
  %1 = call i16 @llvm.experimental.constrained.fptosi.i16.f16(half %a, metadata !"fpexcept.strict") strictfp
  ret i16 %1
}
declare i16 @llvm.experimental.constrained.fptosi.i16.f16(half, metadata)

define i16 @fcvt_ui_h(half %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_ui_h:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.wu.h a0, fa0, rtz
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_ui_h:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.lu.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_ui_h:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.wu.h a0, fa0, rtz
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_ui_h:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.lu.h a0, fa0, rtz
; RV64IDZFH-NEXT:    ret
  %1 = call i16 @llvm.experimental.constrained.fptoui.i16.f16(half %a, metadata !"fpexcept.strict") strictfp
  ret i16 %1
}
declare i16 @llvm.experimental.constrained.fptoui.i16.f16(half, metadata)

define i32 @fcvt_w_h(half %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_w_h:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_w_h:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_w_h:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_w_h:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.w.h a0, fa0, rtz
; RV64IDZFH-NEXT:    ret
  %1 = call i32 @llvm.experimental.constrained.fptosi.i32.f16(half %a, metadata !"fpexcept.strict") strictfp
  ret i32 %1
}
declare i32 @llvm.experimental.constrained.fptosi.i32.f16(half, metadata)

define i32 @fcvt_wu_h(half %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_wu_h:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.wu.h a0, fa0, rtz
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_wu_h:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.wu.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_wu_h:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.wu.h a0, fa0, rtz
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_wu_h:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.wu.h a0, fa0, rtz
; RV64IDZFH-NEXT:    ret
  %1 = call i32 @llvm.experimental.constrained.fptoui.i32.f16(half %a, metadata !"fpexcept.strict") strictfp
  ret i32 %1
}
declare i32 @llvm.experimental.constrained.fptoui.i32.f16(half, metadata)

; Test where the fptoui has multiple uses, one of which causes a sext to be
; inserted on RV64.
; FIXME: We should not have an fcvt.wu.h and an fcvt.lu.h.
define i32 @fcvt_wu_h_multiple_use(half %x, i32* %y) {
; RV32IZFH-LABEL: fcvt_wu_h_multiple_use:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.wu.h a1, fa0, rtz
; RV32IZFH-NEXT:    li a0, 1
; RV32IZFH-NEXT:    beqz a1, .LBB4_2
; RV32IZFH-NEXT:  # %bb.1:
; RV32IZFH-NEXT:    mv a0, a1
; RV32IZFH-NEXT:  .LBB4_2:
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_wu_h_multiple_use:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.wu.h a1, fa0, rtz
; RV64IZFH-NEXT:    li a0, 1
; RV64IZFH-NEXT:    beqz a1, .LBB4_2
; RV64IZFH-NEXT:  # %bb.1:
; RV64IZFH-NEXT:    mv a0, a1
; RV64IZFH-NEXT:  .LBB4_2:
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_wu_h_multiple_use:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.wu.h a1, fa0, rtz
; RV32IDZFH-NEXT:    li a0, 1
; RV32IDZFH-NEXT:    beqz a1, .LBB4_2
; RV32IDZFH-NEXT:  # %bb.1:
; RV32IDZFH-NEXT:    mv a0, a1
; RV32IDZFH-NEXT:  .LBB4_2:
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_wu_h_multiple_use:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.wu.h a1, fa0, rtz
; RV64IDZFH-NEXT:    li a0, 1
; RV64IDZFH-NEXT:    beqz a1, .LBB4_2
; RV64IDZFH-NEXT:  # %bb.1:
; RV64IDZFH-NEXT:    mv a0, a1
; RV64IDZFH-NEXT:  .LBB4_2:
; RV64IDZFH-NEXT:    ret
  %a = call i32 @llvm.experimental.constrained.fptoui.i32.f16(half %x, metadata !"fpexcept.strict") strictfp
  %b = icmp eq i32 %a, 0
  %c = select i1 %b, i32 1, i32 %a
  ret i32 %c
}

define i64 @fcvt_l_h(half %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_l_h:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call __fixhfdi@plt
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_l_h:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.l.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_l_h:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    addi sp, sp, -16
; RV32IDZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IDZFH-NEXT:    call __fixhfdi@plt
; RV32IDZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IDZFH-NEXT:    addi sp, sp, 16
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_l_h:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.l.h a0, fa0, rtz
; RV64IDZFH-NEXT:    ret
  %1 = call i64 @llvm.experimental.constrained.fptosi.i64.f16(half %a, metadata !"fpexcept.strict") strictfp
  ret i64 %1
}
declare i64 @llvm.experimental.constrained.fptosi.i64.f16(half, metadata)

define i64 @fcvt_lu_h(half %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_lu_h:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call __fixunshfdi@plt
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_lu_h:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.lu.h a0, fa0, rtz
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_lu_h:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    addi sp, sp, -16
; RV32IDZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IDZFH-NEXT:    call __fixunshfdi@plt
; RV32IDZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IDZFH-NEXT:    addi sp, sp, 16
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_lu_h:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.lu.h a0, fa0, rtz
; RV64IDZFH-NEXT:    ret
  %1 = call i64 @llvm.experimental.constrained.fptoui.i64.f16(half %a, metadata !"fpexcept.strict") strictfp
  ret i64 %1
}
declare i64 @llvm.experimental.constrained.fptoui.i64.f16(half, metadata)

define half @fcvt_h_si(i16 %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_si:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    slli a0, a0, 16
; RV32IZFH-NEXT:    srai a0, a0, 16
; RV32IZFH-NEXT:    fcvt.h.w fa0, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_si:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    slli a0, a0, 48
; RV64IZFH-NEXT:    srai a0, a0, 48
; RV64IZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_si:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    slli a0, a0, 16
; RV32IDZFH-NEXT:    srai a0, a0, 16
; RV32IDZFH-NEXT:    fcvt.h.w fa0, a0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_si:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    slli a0, a0, 48
; RV64IDZFH-NEXT:    srai a0, a0, 48
; RV64IDZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.sitofp.f16.i16(i16 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}
declare half @llvm.experimental.constrained.sitofp.f16.i16(i16, metadata, metadata)

define half @fcvt_h_si_signext(i16 signext %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_si_signext:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.h.w fa0, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_si_signext:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_si_signext:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.h.w fa0, a0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_si_signext:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.sitofp.f16.i16(i16 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}

define half @fcvt_h_ui(i16 %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_ui:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    slli a0, a0, 16
; RV32IZFH-NEXT:    srli a0, a0, 16
; RV32IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_ui:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    slli a0, a0, 48
; RV64IZFH-NEXT:    srli a0, a0, 48
; RV64IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_ui:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    slli a0, a0, 16
; RV32IDZFH-NEXT:    srli a0, a0, 16
; RV32IDZFH-NEXT:    fcvt.h.wu fa0, a0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_ui:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    slli a0, a0, 48
; RV64IDZFH-NEXT:    srli a0, a0, 48
; RV64IDZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.uitofp.f16.i16(i16 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}
declare half @llvm.experimental.constrained.uitofp.f16.i16(i16, metadata, metadata)

define half @fcvt_h_ui_zeroext(i16 zeroext %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_ui_zeroext:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_ui_zeroext:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_ui_zeroext:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.h.wu fa0, a0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_ui_zeroext:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.uitofp.f16.i16(i16 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}

define half @fcvt_h_w(i32 %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_w:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.h.w fa0, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_w:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_w:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.h.w fa0, a0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_w:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.sitofp.f16.i32(i32 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}
declare half @llvm.experimental.constrained.sitofp.f16.i32(i32, metadata, metadata)

define half @fcvt_h_w_load(i32* %p) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_w_load:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    lw a0, 0(a0)
; RV32IZFH-NEXT:    fcvt.h.w fa0, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_w_load:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    lw a0, 0(a0)
; RV64IZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_w_load:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    lw a0, 0(a0)
; RV32IDZFH-NEXT:    fcvt.h.w fa0, a0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_w_load:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    lw a0, 0(a0)
; RV64IDZFH-NEXT:    fcvt.h.w fa0, a0
; RV64IDZFH-NEXT:    ret
  %a = load i32, i32* %p
  %1 = call half @llvm.experimental.constrained.sitofp.f16.i32(i32 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}

define half @fcvt_h_wu(i32 %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_wu:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_wu:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_wu:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.h.wu fa0, a0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_wu:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.uitofp.f16.i32(i32 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}
declare half @llvm.experimental.constrained.uitofp.f16.i32(i32, metadata, metadata)

define half @fcvt_h_wu_load(i32* %p) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_wu_load:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    lw a0, 0(a0)
; RV32IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_wu_load:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    lwu a0, 0(a0)
; RV64IZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_wu_load:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    lw a0, 0(a0)
; RV32IDZFH-NEXT:    fcvt.h.wu fa0, a0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_wu_load:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    lwu a0, 0(a0)
; RV64IDZFH-NEXT:    fcvt.h.wu fa0, a0
; RV64IDZFH-NEXT:    ret
  %a = load i32, i32* %p
  %1 = call half @llvm.experimental.constrained.uitofp.f16.i32(i32 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}

define half @fcvt_h_l(i64 %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_l:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call __floatdihf@plt
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_l:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.l fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_l:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    addi sp, sp, -16
; RV32IDZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IDZFH-NEXT:    call __floatdihf@plt
; RV32IDZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IDZFH-NEXT:    addi sp, sp, 16
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_l:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.h.l fa0, a0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.sitofp.f16.i64(i64 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}
declare half @llvm.experimental.constrained.sitofp.f16.i64(i64, metadata, metadata)

define half @fcvt_h_lu(i64 %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_lu:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call __floatundihf@plt
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_lu:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.lu fa0, a0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_lu:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    addi sp, sp, -16
; RV32IDZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IDZFH-NEXT:    call __floatundihf@plt
; RV32IDZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IDZFH-NEXT:    addi sp, sp, 16
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_lu:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.h.lu fa0, a0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.uitofp.f16.i64(i64 %a, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  ret half %1
}
declare half @llvm.experimental.constrained.uitofp.f16.i64(i64, metadata, metadata)

define half @fcvt_h_s(float %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_s:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.h.s fa0, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_s:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.h.s fa0, fa0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_s:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.h.s fa0, fa0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_s:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.h.s fa0, fa0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.fptrunc.f16.f32(float %a, metadata !"round.dynamic", metadata !"fpexcept.strict")
  ret half %1
}
declare half @llvm.experimental.constrained.fptrunc.f16.f32(float, metadata, metadata)

define float @fcvt_s_h(half %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_s_h:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_s_h:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_s_h:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_s_h:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.s.h fa0, fa0
; RV64IDZFH-NEXT:    ret
  %1 = call float @llvm.experimental.constrained.fpext.f32.f16(half %a, metadata !"fpexcept.strict")
  ret float %1
}
declare float @llvm.experimental.constrained.fpext.f32.f16(half, metadata)

define half @fcvt_h_d(double %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_h_d:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call __truncdfhf2@plt
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_d:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call __truncdfhf2@plt
; RV64IZFH-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IZFH-NEXT:    addi sp, sp, 16
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_d:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.h.d fa0, fa0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_d:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.h.d fa0, fa0
; RV64IDZFH-NEXT:    ret
  %1 = call half @llvm.experimental.constrained.fptrunc.f16.f64(double %a, metadata !"round.dynamic", metadata !"fpexcept.strict")
  ret half %1
}
declare half @llvm.experimental.constrained.fptrunc.f16.f64(double, metadata, metadata)

define double @fcvt_d_h(half %a) nounwind strictfp {
; RV32IZFH-LABEL: fcvt_d_h:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV32IZFH-NEXT:    call __extendsfdf2@plt
; RV32IZFH-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32IZFH-NEXT:    addi sp, sp, 16
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_d_h:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    fcvt.s.h fa0, fa0
; RV64IZFH-NEXT:    call __extendsfdf2@plt
; RV64IZFH-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64IZFH-NEXT:    addi sp, sp, 16
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_d_h:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    fcvt.d.h fa0, fa0
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_d_h:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    fcvt.d.h fa0, fa0
; RV64IDZFH-NEXT:    ret
  %1 = call double @llvm.experimental.constrained.fpext.f64.f16(half %a, metadata !"fpexcept.strict")
  ret double %1
}
declare double @llvm.experimental.constrained.fpext.f64.f16(half, metadata)

; Make sure we select W version of addi on RV64.
define signext i32 @fcvt_h_w_demanded_bits(i32 signext %0, half* %1) {
; RV32IZFH-LABEL: fcvt_h_w_demanded_bits:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi a0, a0, 1
; RV32IZFH-NEXT:    fcvt.h.w ft0, a0
; RV32IZFH-NEXT:    fsh ft0, 0(a1)
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_w_demanded_bits:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    addiw a0, a0, 1
; RV64IZFH-NEXT:    fcvt.h.w ft0, a0
; RV64IZFH-NEXT:    fsh ft0, 0(a1)
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_w_demanded_bits:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    addi a0, a0, 1
; RV32IDZFH-NEXT:    fcvt.h.w ft0, a0
; RV32IDZFH-NEXT:    fsh ft0, 0(a1)
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_w_demanded_bits:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    addiw a0, a0, 1
; RV64IDZFH-NEXT:    fcvt.h.w ft0, a0
; RV64IDZFH-NEXT:    fsh ft0, 0(a1)
; RV64IDZFH-NEXT:    ret
  %3 = add i32 %0, 1
  %4 = call half @llvm.experimental.constrained.sitofp.f16.i32(i32 %3, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  store half %4, half* %1, align 2
  ret i32 %3
}

; Make sure we select W version of addi on RV64.
define signext i32 @fcvt_h_wu_demanded_bits(i32 signext %0, half* %1) {
; RV32IZFH-LABEL: fcvt_h_wu_demanded_bits:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi a0, a0, 1
; RV32IZFH-NEXT:    fcvt.h.wu ft0, a0
; RV32IZFH-NEXT:    fsh ft0, 0(a1)
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcvt_h_wu_demanded_bits:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    addiw a0, a0, 1
; RV64IZFH-NEXT:    fcvt.h.wu ft0, a0
; RV64IZFH-NEXT:    fsh ft0, 0(a1)
; RV64IZFH-NEXT:    ret
;
; RV32IDZFH-LABEL: fcvt_h_wu_demanded_bits:
; RV32IDZFH:       # %bb.0:
; RV32IDZFH-NEXT:    addi a0, a0, 1
; RV32IDZFH-NEXT:    fcvt.h.wu ft0, a0
; RV32IDZFH-NEXT:    fsh ft0, 0(a1)
; RV32IDZFH-NEXT:    ret
;
; RV64IDZFH-LABEL: fcvt_h_wu_demanded_bits:
; RV64IDZFH:       # %bb.0:
; RV64IDZFH-NEXT:    addiw a0, a0, 1
; RV64IDZFH-NEXT:    fcvt.h.wu ft0, a0
; RV64IDZFH-NEXT:    fsh ft0, 0(a1)
; RV64IDZFH-NEXT:    ret
  %3 = add i32 %0, 1
  %4 = call half @llvm.experimental.constrained.uitofp.f16.i32(i32 %3, metadata !"round.dynamic", metadata !"fpexcept.strict") strictfp
  store half %4, half* %1, align 2
  ret i32 %3
}
