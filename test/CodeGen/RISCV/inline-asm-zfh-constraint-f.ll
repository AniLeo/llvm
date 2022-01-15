; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=zfh -verify-machineinstrs < %s \
; RUN:   -target-abi=ilp32f | FileCheck -check-prefix=RV32ZFH %s
; RUN: llc -mtriple=riscv64 -mattr=zfh -verify-machineinstrs < %s \
; RUN:   -target-abi=lp64f | FileCheck -check-prefix=RV64ZFH %s
; RUN: llc -mtriple=riscv32 -mattr=zfh,+d -verify-machineinstrs < %s \
; RUN:   -target-abi=ilp32d | FileCheck -check-prefix=RV32DZFH %s
; RUN: llc -mtriple=riscv64 -mattr=zfh,+d -verify-machineinstrs < %s \
; RUN:   -target-abi=lp64d | FileCheck -check-prefix=RV64DZFH %s

@gh = external global half

define half @constraint_f_half(half %a) nounwind {
; RV32ZFH-LABEL: constraint_f_half:
; RV32ZFH:       # %bb.0:
; RV32ZFH-NEXT:    lui a0, %hi(gh)
; RV32ZFH-NEXT:    flh ft0, %lo(gh)(a0)
; RV32ZFH-NEXT:    #APP
; RV32ZFH-NEXT:    fadd.h fa0, fa0, ft0
; RV32ZFH-NEXT:    #NO_APP
; RV32ZFH-NEXT:    ret
;
; RV64ZFH-LABEL: constraint_f_half:
; RV64ZFH:       # %bb.0:
; RV64ZFH-NEXT:    lui a0, %hi(gh)
; RV64ZFH-NEXT:    flh ft0, %lo(gh)(a0)
; RV64ZFH-NEXT:    #APP
; RV64ZFH-NEXT:    fadd.h fa0, fa0, ft0
; RV64ZFH-NEXT:    #NO_APP
; RV64ZFH-NEXT:    ret
;
; RV32DZFH-LABEL: constraint_f_half:
; RV32DZFH:       # %bb.0:
; RV32DZFH-NEXT:    lui a0, %hi(gh)
; RV32DZFH-NEXT:    flh ft0, %lo(gh)(a0)
; RV32DZFH-NEXT:    #APP
; RV32DZFH-NEXT:    fadd.h fa0, fa0, ft0
; RV32DZFH-NEXT:    #NO_APP
; RV32DZFH-NEXT:    ret
;
; RV64DZFH-LABEL: constraint_f_half:
; RV64DZFH:       # %bb.0:
; RV64DZFH-NEXT:    lui a0, %hi(gh)
; RV64DZFH-NEXT:    flh ft0, %lo(gh)(a0)
; RV64DZFH-NEXT:    #APP
; RV64DZFH-NEXT:    fadd.h fa0, fa0, ft0
; RV64DZFH-NEXT:    #NO_APP
; RV64DZFH-NEXT:    ret
  %1 = load half, half* @gh
  %2 = tail call half asm "fadd.h $0, $1, $2", "=f,f,f"(half %a, half %1)
  ret half %2
}

define half @constraint_f_half_abi_name(half %a) nounwind {
; RV32ZFH-LABEL: constraint_f_half_abi_name:
; RV32ZFH:       # %bb.0:
; RV32ZFH-NEXT:    addi sp, sp, -16
; RV32ZFH-NEXT:    fsw fs0, 12(sp) # 4-byte Folded Spill
; RV32ZFH-NEXT:    lui a0, %hi(gh)
; RV32ZFH-NEXT:    flh fs0, %lo(gh)(a0)
; RV32ZFH-NEXT:    #APP
; RV32ZFH-NEXT:    fadd.s ft0, fa0, fs0
; RV32ZFH-NEXT:    #NO_APP
; RV32ZFH-NEXT:    fmv.h fa0, ft0
; RV32ZFH-NEXT:    flw fs0, 12(sp) # 4-byte Folded Reload
; RV32ZFH-NEXT:    addi sp, sp, 16
; RV32ZFH-NEXT:    ret
;
; RV64ZFH-LABEL: constraint_f_half_abi_name:
; RV64ZFH:       # %bb.0:
; RV64ZFH-NEXT:    addi sp, sp, -16
; RV64ZFH-NEXT:    fsw fs0, 12(sp) # 4-byte Folded Spill
; RV64ZFH-NEXT:    lui a0, %hi(gh)
; RV64ZFH-NEXT:    flh fs0, %lo(gh)(a0)
; RV64ZFH-NEXT:    #APP
; RV64ZFH-NEXT:    fadd.s ft0, fa0, fs0
; RV64ZFH-NEXT:    #NO_APP
; RV64ZFH-NEXT:    fmv.h fa0, ft0
; RV64ZFH-NEXT:    flw fs0, 12(sp) # 4-byte Folded Reload
; RV64ZFH-NEXT:    addi sp, sp, 16
; RV64ZFH-NEXT:    ret
;
; RV32DZFH-LABEL: constraint_f_half_abi_name:
; RV32DZFH:       # %bb.0:
; RV32DZFH-NEXT:    addi sp, sp, -16
; RV32DZFH-NEXT:    fsd fs0, 8(sp) # 8-byte Folded Spill
; RV32DZFH-NEXT:    lui a0, %hi(gh)
; RV32DZFH-NEXT:    flh fs0, %lo(gh)(a0)
; RV32DZFH-NEXT:    #APP
; RV32DZFH-NEXT:    fadd.s ft0, fa0, fs0
; RV32DZFH-NEXT:    #NO_APP
; RV32DZFH-NEXT:    fmv.h fa0, ft0
; RV32DZFH-NEXT:    fld fs0, 8(sp) # 8-byte Folded Reload
; RV32DZFH-NEXT:    addi sp, sp, 16
; RV32DZFH-NEXT:    ret
;
; RV64DZFH-LABEL: constraint_f_half_abi_name:
; RV64DZFH:       # %bb.0:
; RV64DZFH-NEXT:    addi sp, sp, -16
; RV64DZFH-NEXT:    fsd fs0, 8(sp) # 8-byte Folded Spill
; RV64DZFH-NEXT:    lui a0, %hi(gh)
; RV64DZFH-NEXT:    flh fs0, %lo(gh)(a0)
; RV64DZFH-NEXT:    #APP
; RV64DZFH-NEXT:    fadd.s ft0, fa0, fs0
; RV64DZFH-NEXT:    #NO_APP
; RV64DZFH-NEXT:    fmv.h fa0, ft0
; RV64DZFH-NEXT:    fld fs0, 8(sp) # 8-byte Folded Reload
; RV64DZFH-NEXT:    addi sp, sp, 16
; RV64DZFH-NEXT:    ret
  %1 = load half, half* @gh
  %2 = tail call half asm "fadd.s $0, $1, $2", "={ft0},{fa0},{fs0}"(half %a, half %1)
  ret half %2
}
