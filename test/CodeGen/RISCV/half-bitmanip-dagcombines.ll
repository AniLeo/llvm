; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s
; RUN: llc -mtriple=riscv32 -mattr=+experimental-zfh -verify-machineinstrs \
; RUN:   -target-abi ilp32f < %s \
; RUN:   | FileCheck -check-prefix=RV32IZFH %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64I %s
; RUN: llc -mtriple=riscv64 -mattr=+experimental-zfh -verify-machineinstrs \
; RUN:   -target-abi lp64f < %s \
; RUN:   | FileCheck -check-prefix=RV64IZFH %s

; This file tests cases where simple floating point operations can be
; profitably handled though bit manipulation if a soft-float ABI is being used
; (e.g. fneg implemented by XORing the sign bit). This is typically handled in
; DAGCombiner::visitBITCAST, but this target-independent code may not trigger
; in cases where we perform custom legalisation (e.g. RV64F).

define half @fneg(half %a) nounwind {
; RV32I-LABEL: fneg:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 1048568
; RV32I-NEXT:    xor a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IZFH-LABEL: fneg:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fneg.h fa0, fa0
; RV32IZFH-NEXT:    ret
;
; RV64I-LABEL: fneg:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 1048568
; RV64I-NEXT:    xor a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IZFH-LABEL: fneg:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fneg.h fa0, fa0
; RV64IZFH-NEXT:    ret
  %1 = fneg half %a
  ret half %1
}

declare half @llvm.fabs.f16(half)

define half @fabs(half %a) nounwind {
; RV32I-LABEL: fabs:
; RV32I:       # %bb.0:
; RV32I-NEXT:    lui a1, 8
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    ret
;
; RV32IZFH-LABEL: fabs:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fabs.h fa0, fa0
; RV32IZFH-NEXT:    ret
;
; RV64I-LABEL: fabs:
; RV64I:       # %bb.0:
; RV64I-NEXT:    lui a1, 8
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    ret
;
; RV64IZFH-LABEL: fabs:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fabs.h fa0, fa0
; RV64IZFH-NEXT:    ret
  %1 = call half @llvm.fabs.f16(half %a)
  ret half %1
}

declare half @llvm.copysign.f16(half, half)

; DAGTypeLegalizer::SoftenFloatRes_FCOPYSIGN will convert to bitwise
; operations if half precision floating point isn't supported. A combine could
; be written to do the same even when f16 is legal.

define half @fcopysign_fneg(half %a, half %b) nounwind {
; RV32I-LABEL: fcopysign_fneg:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -16
; RV32I-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-NEXT:    mv s0, a1
; RV32I-NEXT:    lui a1, 16
; RV32I-NEXT:    addi a1, a1, -1
; RV32I-NEXT:    and a0, a0, a1
; RV32I-NEXT:    call __gnu_h2f_ieee@plt
; RV32I-NEXT:    not a1, s0
; RV32I-NEXT:    lui a2, 524288
; RV32I-NEXT:    addi a2, a2, -1
; RV32I-NEXT:    and a0, a0, a2
; RV32I-NEXT:    lui a2, 8
; RV32I-NEXT:    and a1, a1, a2
; RV32I-NEXT:    slli a1, a1, 16
; RV32I-NEXT:    or a0, a0, a1
; RV32I-NEXT:    call __gnu_f2h_ieee@plt
; RV32I-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 16
; RV32I-NEXT:    ret
;
; RV32IZFH-LABEL: fcopysign_fneg:
; RV32IZFH:       # %bb.0:
; RV32IZFH-NEXT:    fsgnjn.h fa0, fa0, fa1
; RV32IZFH-NEXT:    ret
;
; RV64I-LABEL: fcopysign_fneg:
; RV64I:       # %bb.0:
; RV64I-NEXT:    addi sp, sp, -16
; RV64I-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-NEXT:    mv s0, a1
; RV64I-NEXT:    lui a1, 16
; RV64I-NEXT:    addiw a1, a1, -1
; RV64I-NEXT:    and a0, a0, a1
; RV64I-NEXT:    call __gnu_h2f_ieee@plt
; RV64I-NEXT:    not a1, s0
; RV64I-NEXT:    lui a2, 524288
; RV64I-NEXT:    addiw a2, a2, -1
; RV64I-NEXT:    and a0, a0, a2
; RV64I-NEXT:    addi a2, zero, 1
; RV64I-NEXT:    slli a2, a2, 33
; RV64I-NEXT:    addi a2, a2, -1
; RV64I-NEXT:    slli a2, a2, 15
; RV64I-NEXT:    and a1, a1, a2
; RV64I-NEXT:    slli a1, a1, 16
; RV64I-NEXT:    or a0, a0, a1
; RV64I-NEXT:    call __gnu_f2h_ieee@plt
; RV64I-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-NEXT:    addi sp, sp, 16
; RV64I-NEXT:    ret
;
; RV64IZFH-LABEL: fcopysign_fneg:
; RV64IZFH:       # %bb.0:
; RV64IZFH-NEXT:    fsgnjn.h fa0, fa0, fa1
; RV64IZFH-NEXT:    ret
  %1 = fneg half %b
  %2 = call half @llvm.copysign.f16(half %a, half %1)
  ret half %2
}
