; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+zfh -verify-machineinstrs \
; RUN:   -target-abi ilp32f -disable-strictnode-mutation < %s \
; RUN:   | FileCheck -check-prefix=RV32IZFH %s
; RUN: llc -mtriple=riscv64 -mattr=+zfh -verify-machineinstrs \
; RUN:   -target-abi lp64f -disable-strictnode-mutation < %s \
; RUN:   | FileCheck -check-prefix=RV64IZFH %s

define i32 @fcmp_oeq(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_oeq:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    feq.h a0, fa0, fa1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_oeq:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"oeq", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}
declare i1 @llvm.experimental.constrained.fcmp.f16(half, half, metadata, metadata)

define i32 @fcmp_ogt(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_ogt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a1
; RV32IZFH-NEXT:    flt.h a0, fa1, fa0
; RV32IZFH-NEXT:    fsflags a1
; RV32IZFH-NEXT:    feq.h zero, fa1, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_ogt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a1
; RV64IZFH-NEXT:    flt.h a0, fa1, fa0
; RV64IZFH-NEXT:    fsflags a1
; RV64IZFH-NEXT:    feq.h zero, fa1, fa0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"ogt", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_oge(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_oge:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a1
; RV32IZFH-NEXT:    fle.h a0, fa1, fa0
; RV32IZFH-NEXT:    fsflags a1
; RV32IZFH-NEXT:    feq.h zero, fa1, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_oge:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a1
; RV64IZFH-NEXT:    fle.h a0, fa1, fa0
; RV64IZFH-NEXT:    fsflags a1
; RV64IZFH-NEXT:    feq.h zero, fa1, fa0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"oge", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_olt(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_olt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a1
; RV32IZFH-NEXT:    flt.h a0, fa0, fa1
; RV32IZFH-NEXT:    fsflags a1
; RV32IZFH-NEXT:    feq.h zero, fa0, fa1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_olt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a1
; RV64IZFH-NEXT:    flt.h a0, fa0, fa1
; RV64IZFH-NEXT:    fsflags a1
; RV64IZFH-NEXT:    feq.h zero, fa0, fa1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"olt", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ole(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_ole:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a1
; RV32IZFH-NEXT:    fle.h a0, fa0, fa1
; RV32IZFH-NEXT:    fsflags a1
; RV32IZFH-NEXT:    feq.h zero, fa0, fa1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_ole:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a1
; RV64IZFH-NEXT:    fle.h a0, fa0, fa1
; RV64IZFH-NEXT:    fsflags a1
; RV64IZFH-NEXT:    feq.h zero, fa0, fa1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"ole", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

; FIXME: We only need one frflags before the two flts and one fsflags after the
; two flts.
define i32 @fcmp_one(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_one:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a0
; RV32IZFH-NEXT:    flt.h a1, fa0, fa1
; RV32IZFH-NEXT:    fsflags a0
; RV32IZFH-NEXT:    feq.h zero, fa0, fa1
; RV32IZFH-NEXT:    frflags a0
; RV32IZFH-NEXT:    flt.h a2, fa1, fa0
; RV32IZFH-NEXT:    fsflags a0
; RV32IZFH-NEXT:    or a0, a2, a1
; RV32IZFH-NEXT:    feq.h zero, fa1, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_one:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a0
; RV64IZFH-NEXT:    flt.h a1, fa0, fa1
; RV64IZFH-NEXT:    fsflags a0
; RV64IZFH-NEXT:    feq.h zero, fa0, fa1
; RV64IZFH-NEXT:    frflags a0
; RV64IZFH-NEXT:    flt.h a2, fa1, fa0
; RV64IZFH-NEXT:    fsflags a0
; RV64IZFH-NEXT:    or a0, a2, a1
; RV64IZFH-NEXT:    feq.h zero, fa1, fa0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"one", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ord(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_ord:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    feq.h a0, fa1, fa1
; RV32IZFH-NEXT:    feq.h a1, fa0, fa0
; RV32IZFH-NEXT:    and a0, a1, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_ord:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa1, fa1
; RV64IZFH-NEXT:    feq.h a1, fa0, fa0
; RV64IZFH-NEXT:    and a0, a1, a0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"ord", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

; FIXME: We only need one frflags before the two flts and one fsflags after the
; two flts.
define i32 @fcmp_ueq(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_ueq:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a0
; RV32IZFH-NEXT:    flt.h a1, fa0, fa1
; RV32IZFH-NEXT:    fsflags a0
; RV32IZFH-NEXT:    feq.h zero, fa0, fa1
; RV32IZFH-NEXT:    frflags a0
; RV32IZFH-NEXT:    flt.h a2, fa1, fa0
; RV32IZFH-NEXT:    fsflags a0
; RV32IZFH-NEXT:    or a0, a2, a1
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    feq.h zero, fa1, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_ueq:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a0
; RV64IZFH-NEXT:    flt.h a1, fa0, fa1
; RV64IZFH-NEXT:    fsflags a0
; RV64IZFH-NEXT:    feq.h zero, fa0, fa1
; RV64IZFH-NEXT:    frflags a0
; RV64IZFH-NEXT:    flt.h a2, fa1, fa0
; RV64IZFH-NEXT:    fsflags a0
; RV64IZFH-NEXT:    or a0, a2, a1
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    feq.h zero, fa1, fa0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"ueq", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ugt(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_ugt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a0
; RV32IZFH-NEXT:    fle.h a1, fa0, fa1
; RV32IZFH-NEXT:    fsflags a0
; RV32IZFH-NEXT:    xori a0, a1, 1
; RV32IZFH-NEXT:    feq.h zero, fa0, fa1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_ugt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a0
; RV64IZFH-NEXT:    fle.h a1, fa0, fa1
; RV64IZFH-NEXT:    fsflags a0
; RV64IZFH-NEXT:    xori a0, a1, 1
; RV64IZFH-NEXT:    feq.h zero, fa0, fa1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"ugt", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_uge(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_uge:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a0
; RV32IZFH-NEXT:    flt.h a1, fa0, fa1
; RV32IZFH-NEXT:    fsflags a0
; RV32IZFH-NEXT:    xori a0, a1, 1
; RV32IZFH-NEXT:    feq.h zero, fa0, fa1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_uge:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a0
; RV64IZFH-NEXT:    flt.h a1, fa0, fa1
; RV64IZFH-NEXT:    fsflags a0
; RV64IZFH-NEXT:    xori a0, a1, 1
; RV64IZFH-NEXT:    feq.h zero, fa0, fa1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"uge", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ult(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_ult:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a0
; RV32IZFH-NEXT:    fle.h a1, fa1, fa0
; RV32IZFH-NEXT:    fsflags a0
; RV32IZFH-NEXT:    xori a0, a1, 1
; RV32IZFH-NEXT:    feq.h zero, fa1, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_ult:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a0
; RV64IZFH-NEXT:    fle.h a1, fa1, fa0
; RV64IZFH-NEXT:    fsflags a0
; RV64IZFH-NEXT:    xori a0, a1, 1
; RV64IZFH-NEXT:    feq.h zero, fa1, fa0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"ult", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_ule(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_ule:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    frflags a0
; RV32IZFH-NEXT:    flt.h a1, fa1, fa0
; RV32IZFH-NEXT:    fsflags a0
; RV32IZFH-NEXT:    xori a0, a1, 1
; RV32IZFH-NEXT:    feq.h zero, fa1, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_ule:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    frflags a0
; RV64IZFH-NEXT:    flt.h a1, fa1, fa0
; RV64IZFH-NEXT:    fsflags a0
; RV64IZFH-NEXT:    xori a0, a1, 1
; RV64IZFH-NEXT:    feq.h zero, fa1, fa0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"ule", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_une(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_une:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    feq.h a0, fa0, fa1
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_une:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa1
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"une", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmp_uno(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmp_uno:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    feq.h a0, fa1, fa1
; RV32IZFH-NEXT:    feq.h a1, fa0, fa0
; RV32IZFH-NEXT:    and a0, a1, a0
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmp_uno:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa1, fa1
; RV64IZFH-NEXT:    feq.h a1, fa0, fa0
; RV64IZFH-NEXT:    and a0, a1, a0
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmp.f16(half %a, half %b, metadata !"uno", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_oeq(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_oeq:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa1, fa0
; RV32IZFH-NEXT:    fle.h a1, fa0, fa1
; RV32IZFH-NEXT:    and a0, a1, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_oeq:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa1, fa0
; RV64IZFH-NEXT:    fle.h a1, fa0, fa1
; RV64IZFH-NEXT:    and a0, a1, a0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"oeq", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}
declare i1 @llvm.experimental.constrained.fcmps.f16(half, half, metadata, metadata)

define i32 @fcmps_ogt(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_ogt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa1, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_ogt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa1, fa0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"ogt", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_oge(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_oge:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa1, fa0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_oge:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa1, fa0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"oge", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_olt(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_olt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa0, fa1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_olt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa0, fa1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"olt", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_ole(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_ole:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa0, fa1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_ole:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa0, fa1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"ole", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_one(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_one:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa0, fa1
; RV32IZFH-NEXT:    flt.h a1, fa1, fa0
; RV32IZFH-NEXT:    or a0, a1, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_one:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa0, fa1
; RV64IZFH-NEXT:    flt.h a1, fa1, fa0
; RV64IZFH-NEXT:    or a0, a1, a0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"one", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_ord(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_ord:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa1, fa1
; RV32IZFH-NEXT:    fle.h a1, fa0, fa0
; RV32IZFH-NEXT:    and a0, a1, a0
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_ord:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa1, fa1
; RV64IZFH-NEXT:    fle.h a1, fa0, fa0
; RV64IZFH-NEXT:    and a0, a1, a0
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"ord", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_ueq(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_ueq:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa0, fa1
; RV32IZFH-NEXT:    flt.h a1, fa1, fa0
; RV32IZFH-NEXT:    or a0, a1, a0
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_ueq:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa0, fa1
; RV64IZFH-NEXT:    flt.h a1, fa1, fa0
; RV64IZFH-NEXT:    or a0, a1, a0
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"ueq", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_ugt(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_ugt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa0, fa1
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_ugt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa0, fa1
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"ugt", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_uge(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_uge:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa0, fa1
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_uge:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa0, fa1
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"uge", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_ult(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_ult:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa1, fa0
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_ult:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa1, fa0
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"ult", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_ule(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_ule:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa1, fa0
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_ule:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa1, fa0
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"ule", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_une(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_une:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa1, fa0
; RV32IZFH-NEXT:    fle.h a1, fa0, fa1
; RV32IZFH-NEXT:    and a0, a1, a0
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_une:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa1, fa0
; RV64IZFH-NEXT:    fle.h a1, fa0, fa1
; RV64IZFH-NEXT:    and a0, a1, a0
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"une", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}

define i32 @fcmps_uno(half %a, half %b) nounwind strictfp {
; RV32IZFH-LABEL: fcmps_uno:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa1, fa1
; RV32IZFH-NEXT:    fle.h a1, fa0, fa0
; RV32IZFH-NEXT:    and a0, a1, a0
; RV32IZFH-NEXT:    xori a0, a0, 1
; RV32IZFH-NEXT:    ret
;
; RV64IZFH-LABEL: fcmps_uno:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa1, fa1
; RV64IZFH-NEXT:    fle.h a1, fa0, fa0
; RV64IZFH-NEXT:    and a0, a1, a0
; RV64IZFH-NEXT:    xori a0, a0, 1
; RV64IZFH-NEXT:    ret
  %1 = call i1 @llvm.experimental.constrained.fcmps.f16(half %a, half %b, metadata !"uno", metadata !"fpexcept.strict") strictfp
  %2 = zext i1 %1 to i32
  ret i32 %2
}
