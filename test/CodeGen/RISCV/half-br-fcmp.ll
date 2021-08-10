; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zfh -verify-machineinstrs \
; RUN:   -target-abi ilp32f < %s | FileCheck -check-prefix=RV32IZFH %s
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zfh -verify-machineinstrs \
; RUN:   -target-abi lp64f < %s | FileCheck -check-prefix=RV64IZFH %s

declare void @abort()
declare void @exit(i32)
declare half @dummy(half)

define void @br_fcmp_false(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_false:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi a0, zero, 1
; RV32IZFH-NEXT:    bnez a0, .LBB0_2
; RV32IZFH-NEXT:  # %bb.1: # %if.then
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB0_2: # %if.else
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_false:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    addi a0, zero, 1
; RV64IZFH-NEXT:    bnez a0, .LBB0_2
; RV64IZFH-NEXT:  # %bb.1: # %if.then
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB0_2: # %if.else
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp false half %a, %b
  br i1 %1, label %if.then, label %if.else
if.then:
  ret void
if.else:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_oeq(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_oeq:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    feq.h a0, fa0, fa1
; RV32IZFH-NEXT:    bnez a0, .LBB1_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB1_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_oeq:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa1
; RV64IZFH-NEXT:    bnez a0, .LBB1_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB1_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp oeq half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

; TODO: generated code quality for this is very poor due to
; DAGCombiner::visitXOR converting the legal setoeq to setune, which requires
; expansion.
define void @br_fcmp_oeq_alt(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_oeq_alt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    feq.h a0, fa0, fa1
; RV32IZFH-NEXT:    bnez a0, .LBB2_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB2_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_oeq_alt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa1
; RV64IZFH-NEXT:    bnez a0, .LBB2_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB2_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp oeq half %a, %b
  br i1 %1, label %if.then, label %if.else
if.then:
  tail call void @abort()
  unreachable
if.else:
  ret void
}

define void @br_fcmp_ogt(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_ogt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa1, fa0
; RV32IZFH-NEXT:    bnez a0, .LBB3_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB3_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_ogt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa1, fa0
; RV64IZFH-NEXT:    bnez a0, .LBB3_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB3_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp ogt half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_oge(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_oge:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa1, fa0
; RV32IZFH-NEXT:    bnez a0, .LBB4_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB4_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_oge:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa1, fa0
; RV64IZFH-NEXT:    bnez a0, .LBB4_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB4_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp oge half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_olt(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_olt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa0, fa1
; RV32IZFH-NEXT:    bnez a0, .LBB5_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB5_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_olt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa0, fa1
; RV64IZFH-NEXT:    bnez a0, .LBB5_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB5_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp olt half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_ole(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_ole:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa0, fa1
; RV32IZFH-NEXT:    bnez a0, .LBB6_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB6_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_ole:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa0, fa1
; RV64IZFH-NEXT:    bnez a0, .LBB6_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB6_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp ole half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_one(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_one:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa0, fa1
; RV32IZFH-NEXT:    flt.h a1, fa1, fa0
; RV32IZFH-NEXT:    or a0, a1, a0
; RV32IZFH-NEXT:    bnez a0, .LBB7_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB7_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_one:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa0, fa1
; RV64IZFH-NEXT:    flt.h a1, fa1, fa0
; RV64IZFH-NEXT:    or a0, a1, a0
; RV64IZFH-NEXT:    bnez a0, .LBB7_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB7_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp one half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_ord(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_ord:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    feq.h a0, fa1, fa1
; RV32IZFH-NEXT:    feq.h a1, fa0, fa0
; RV32IZFH-NEXT:    and a0, a1, a0
; RV32IZFH-NEXT:    bnez a0, .LBB8_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB8_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_ord:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa1, fa1
; RV64IZFH-NEXT:    feq.h a1, fa0, fa0
; RV64IZFH-NEXT:    and a0, a1, a0
; RV64IZFH-NEXT:    bnez a0, .LBB8_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB8_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp ord half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_ueq(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_ueq:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa0, fa1
; RV32IZFH-NEXT:    flt.h a1, fa1, fa0
; RV32IZFH-NEXT:    or a0, a1, a0
; RV32IZFH-NEXT:    beqz a0, .LBB9_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB9_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_ueq:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa0, fa1
; RV64IZFH-NEXT:    flt.h a1, fa1, fa0
; RV64IZFH-NEXT:    or a0, a1, a0
; RV64IZFH-NEXT:    beqz a0, .LBB9_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB9_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp ueq half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_ugt(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_ugt:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa0, fa1
; RV32IZFH-NEXT:    beqz a0, .LBB10_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB10_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_ugt:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa0, fa1
; RV64IZFH-NEXT:    beqz a0, .LBB10_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB10_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp ugt half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_uge(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_uge:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa0, fa1
; RV32IZFH-NEXT:    beqz a0, .LBB11_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB11_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_uge:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa0, fa1
; RV64IZFH-NEXT:    beqz a0, .LBB11_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB11_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp uge half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_ult(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_ult:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fle.h a0, fa1, fa0
; RV32IZFH-NEXT:    beqz a0, .LBB12_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB12_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_ult:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fle.h a0, fa1, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB12_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB12_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp ult half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_ule(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_ule:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    flt.h a0, fa1, fa0
; RV32IZFH-NEXT:    beqz a0, .LBB13_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB13_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_ule:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    flt.h a0, fa1, fa0
; RV64IZFH-NEXT:    beqz a0, .LBB13_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB13_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp ule half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_une(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_une:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    feq.h a0, fa0, fa1
; RV32IZFH-NEXT:    beqz a0, .LBB14_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB14_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_une:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa0, fa1
; RV64IZFH-NEXT:    beqz a0, .LBB14_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB14_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp une half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_uno(half %a, half %b) nounwind {
; TODO: sltiu+bne -> beq
; RV32IZFH-LABEL: br_fcmp_uno:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    feq.h a0, fa1, fa1
; RV32IZFH-NEXT:    feq.h a1, fa0, fa0
; RV32IZFH-NEXT:    and a0, a1, a0
; RV32IZFH-NEXT:    beqz a0, .LBB15_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB15_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_uno:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    feq.h a0, fa1, fa1
; RV64IZFH-NEXT:    feq.h a1, fa0, fa0
; RV64IZFH-NEXT:    and a0, a1, a0
; RV64IZFH-NEXT:    beqz a0, .LBB15_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB15_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp uno half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}

define void @br_fcmp_true(half %a, half %b) nounwind {
; RV32IZFH-LABEL: br_fcmp_true:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    addi a0, zero, 1
; RV32IZFH-NEXT:    bnez a0, .LBB16_2
; RV32IZFH-NEXT:  # %bb.1: # %if.else
; RV32IZFH-NEXT:    ret
; RV32IZFH-NEXT:  .LBB16_2: # %if.then
; RV32IZFH-NEXT:    addi sp, sp, -16
; RV32IZFH-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IZFH-NEXT:    call abort@plt
;
; RV64IZFH-LABEL: br_fcmp_true:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    addi a0, zero, 1
; RV64IZFH-NEXT:    bnez a0, .LBB16_2
; RV64IZFH-NEXT:  # %bb.1: # %if.else
; RV64IZFH-NEXT:    ret
; RV64IZFH-NEXT:  .LBB16_2: # %if.then
; RV64IZFH-NEXT:    addi sp, sp, -16
; RV64IZFH-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64IZFH-NEXT:    call abort@plt
  %1 = fcmp true half %a, %b
  br i1 %1, label %if.then, label %if.else
if.else:
  ret void
if.then:
  tail call void @abort()
  unreachable
}
