; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=ILP32
; RUN: llc -mtriple=riscv64 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=LP64
; RUN: llc -mtriple=riscv32 -mattr=+d -target-abi ilp32d -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=ILP32D
; RUN: llc -mtriple=riscv64 -mattr=+d -target-abi lp64d -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=LP64D

@var = global [32 x double] zeroinitializer

; All floating point registers are temporaries for the ilp32 and lp64 ABIs.
; fs0-fs11 are callee-saved for the ilp32f, ilp32d, lp64f, and lp64d ABIs.

; This function tests that RISCVRegisterInfo::getCalleeSavedRegs returns
; something appropriate.

define void @callee() nounwind {
; ILP32-LABEL: callee:
; ILP32:       # %bb.0:
; ILP32-NEXT:    lui a0, %hi(var)
; ILP32-NEXT:    fld ft0, %lo(var)(a0)
; ILP32-NEXT:    fld ft1, %lo(var+8)(a0)
; ILP32-NEXT:    addi a1, a0, %lo(var)
; ILP32-NEXT:    fld ft2, 16(a1)
; ILP32-NEXT:    fld ft3, 24(a1)
; ILP32-NEXT:    fld ft4, 32(a1)
; ILP32-NEXT:    fld ft5, 40(a1)
; ILP32-NEXT:    fld ft6, 48(a1)
; ILP32-NEXT:    fld ft7, 56(a1)
; ILP32-NEXT:    fld fa0, 64(a1)
; ILP32-NEXT:    fld fa1, 72(a1)
; ILP32-NEXT:    fld fa2, 80(a1)
; ILP32-NEXT:    fld fa3, 88(a1)
; ILP32-NEXT:    fld fa4, 96(a1)
; ILP32-NEXT:    fld fa5, 104(a1)
; ILP32-NEXT:    fld fa6, 112(a1)
; ILP32-NEXT:    fld fa7, 120(a1)
; ILP32-NEXT:    fld ft8, 128(a1)
; ILP32-NEXT:    fld ft9, 136(a1)
; ILP32-NEXT:    fld ft10, 144(a1)
; ILP32-NEXT:    fld ft11, 152(a1)
; ILP32-NEXT:    fld fs0, 160(a1)
; ILP32-NEXT:    fld fs1, 168(a1)
; ILP32-NEXT:    fld fs2, 176(a1)
; ILP32-NEXT:    fld fs3, 184(a1)
; ILP32-NEXT:    fld fs4, 192(a1)
; ILP32-NEXT:    fld fs5, 200(a1)
; ILP32-NEXT:    fld fs6, 208(a1)
; ILP32-NEXT:    fld fs7, 216(a1)
; ILP32-NEXT:    fld fs8, 248(a1)
; ILP32-NEXT:    fld fs9, 240(a1)
; ILP32-NEXT:    fld fs10, 232(a1)
; ILP32-NEXT:    fld fs11, 224(a1)
; ILP32-NEXT:    fsd fs8, 248(a1)
; ILP32-NEXT:    fsd fs9, 240(a1)
; ILP32-NEXT:    fsd fs10, 232(a1)
; ILP32-NEXT:    fsd fs11, 224(a1)
; ILP32-NEXT:    fsd fs7, 216(a1)
; ILP32-NEXT:    fsd fs6, 208(a1)
; ILP32-NEXT:    fsd fs5, 200(a1)
; ILP32-NEXT:    fsd fs4, 192(a1)
; ILP32-NEXT:    fsd fs3, 184(a1)
; ILP32-NEXT:    fsd fs2, 176(a1)
; ILP32-NEXT:    fsd fs1, 168(a1)
; ILP32-NEXT:    fsd fs0, 160(a1)
; ILP32-NEXT:    fsd ft11, 152(a1)
; ILP32-NEXT:    fsd ft10, 144(a1)
; ILP32-NEXT:    fsd ft9, 136(a1)
; ILP32-NEXT:    fsd ft8, 128(a1)
; ILP32-NEXT:    fsd fa7, 120(a1)
; ILP32-NEXT:    fsd fa6, 112(a1)
; ILP32-NEXT:    fsd fa5, 104(a1)
; ILP32-NEXT:    fsd fa4, 96(a1)
; ILP32-NEXT:    fsd fa3, 88(a1)
; ILP32-NEXT:    fsd fa2, 80(a1)
; ILP32-NEXT:    fsd fa1, 72(a1)
; ILP32-NEXT:    fsd fa0, 64(a1)
; ILP32-NEXT:    fsd ft7, 56(a1)
; ILP32-NEXT:    fsd ft6, 48(a1)
; ILP32-NEXT:    fsd ft5, 40(a1)
; ILP32-NEXT:    fsd ft4, 32(a1)
; ILP32-NEXT:    fsd ft3, 24(a1)
; ILP32-NEXT:    fsd ft2, 16(a1)
; ILP32-NEXT:    fsd ft1, %lo(var+8)(a0)
; ILP32-NEXT:    fsd ft0, %lo(var)(a0)
; ILP32-NEXT:    ret
;
; LP64-LABEL: callee:
; LP64:       # %bb.0:
; LP64-NEXT:    lui a0, %hi(var)
; LP64-NEXT:    fld ft0, %lo(var)(a0)
; LP64-NEXT:    fld ft1, %lo(var+8)(a0)
; LP64-NEXT:    addi a1, a0, %lo(var)
; LP64-NEXT:    fld ft2, 16(a1)
; LP64-NEXT:    fld ft3, 24(a1)
; LP64-NEXT:    fld ft4, 32(a1)
; LP64-NEXT:    fld ft5, 40(a1)
; LP64-NEXT:    fld ft6, 48(a1)
; LP64-NEXT:    fld ft7, 56(a1)
; LP64-NEXT:    fld fa0, 64(a1)
; LP64-NEXT:    fld fa1, 72(a1)
; LP64-NEXT:    fld fa2, 80(a1)
; LP64-NEXT:    fld fa3, 88(a1)
; LP64-NEXT:    fld fa4, 96(a1)
; LP64-NEXT:    fld fa5, 104(a1)
; LP64-NEXT:    fld fa6, 112(a1)
; LP64-NEXT:    fld fa7, 120(a1)
; LP64-NEXT:    fld ft8, 128(a1)
; LP64-NEXT:    fld ft9, 136(a1)
; LP64-NEXT:    fld ft10, 144(a1)
; LP64-NEXT:    fld ft11, 152(a1)
; LP64-NEXT:    fld fs0, 160(a1)
; LP64-NEXT:    fld fs1, 168(a1)
; LP64-NEXT:    fld fs2, 176(a1)
; LP64-NEXT:    fld fs3, 184(a1)
; LP64-NEXT:    fld fs4, 192(a1)
; LP64-NEXT:    fld fs5, 200(a1)
; LP64-NEXT:    fld fs6, 208(a1)
; LP64-NEXT:    fld fs7, 216(a1)
; LP64-NEXT:    fld fs8, 248(a1)
; LP64-NEXT:    fld fs9, 240(a1)
; LP64-NEXT:    fld fs10, 232(a1)
; LP64-NEXT:    fld fs11, 224(a1)
; LP64-NEXT:    fsd fs8, 248(a1)
; LP64-NEXT:    fsd fs9, 240(a1)
; LP64-NEXT:    fsd fs10, 232(a1)
; LP64-NEXT:    fsd fs11, 224(a1)
; LP64-NEXT:    fsd fs7, 216(a1)
; LP64-NEXT:    fsd fs6, 208(a1)
; LP64-NEXT:    fsd fs5, 200(a1)
; LP64-NEXT:    fsd fs4, 192(a1)
; LP64-NEXT:    fsd fs3, 184(a1)
; LP64-NEXT:    fsd fs2, 176(a1)
; LP64-NEXT:    fsd fs1, 168(a1)
; LP64-NEXT:    fsd fs0, 160(a1)
; LP64-NEXT:    fsd ft11, 152(a1)
; LP64-NEXT:    fsd ft10, 144(a1)
; LP64-NEXT:    fsd ft9, 136(a1)
; LP64-NEXT:    fsd ft8, 128(a1)
; LP64-NEXT:    fsd fa7, 120(a1)
; LP64-NEXT:    fsd fa6, 112(a1)
; LP64-NEXT:    fsd fa5, 104(a1)
; LP64-NEXT:    fsd fa4, 96(a1)
; LP64-NEXT:    fsd fa3, 88(a1)
; LP64-NEXT:    fsd fa2, 80(a1)
; LP64-NEXT:    fsd fa1, 72(a1)
; LP64-NEXT:    fsd fa0, 64(a1)
; LP64-NEXT:    fsd ft7, 56(a1)
; LP64-NEXT:    fsd ft6, 48(a1)
; LP64-NEXT:    fsd ft5, 40(a1)
; LP64-NEXT:    fsd ft4, 32(a1)
; LP64-NEXT:    fsd ft3, 24(a1)
; LP64-NEXT:    fsd ft2, 16(a1)
; LP64-NEXT:    fsd ft1, %lo(var+8)(a0)
; LP64-NEXT:    fsd ft0, %lo(var)(a0)
; LP64-NEXT:    ret
;
; ILP32D-LABEL: callee:
; ILP32D:       # %bb.0:
; ILP32D-NEXT:    addi sp, sp, -96
; ILP32D-NEXT:    fsd fs0, 88(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs1, 80(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs2, 72(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs3, 64(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs4, 56(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs5, 48(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs6, 40(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs7, 32(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs8, 24(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs9, 16(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs10, 8(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs11, 0(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    lui a0, %hi(var)
; ILP32D-NEXT:    fld ft0, %lo(var)(a0)
; ILP32D-NEXT:    fld ft1, %lo(var+8)(a0)
; ILP32D-NEXT:    addi a1, a0, %lo(var)
; ILP32D-NEXT:    fld ft2, 16(a1)
; ILP32D-NEXT:    fld ft3, 24(a1)
; ILP32D-NEXT:    fld ft4, 32(a1)
; ILP32D-NEXT:    fld ft5, 40(a1)
; ILP32D-NEXT:    fld ft6, 48(a1)
; ILP32D-NEXT:    fld ft7, 56(a1)
; ILP32D-NEXT:    fld fa0, 64(a1)
; ILP32D-NEXT:    fld fa1, 72(a1)
; ILP32D-NEXT:    fld fa2, 80(a1)
; ILP32D-NEXT:    fld fa3, 88(a1)
; ILP32D-NEXT:    fld fa4, 96(a1)
; ILP32D-NEXT:    fld fa5, 104(a1)
; ILP32D-NEXT:    fld fa6, 112(a1)
; ILP32D-NEXT:    fld fa7, 120(a1)
; ILP32D-NEXT:    fld ft8, 128(a1)
; ILP32D-NEXT:    fld ft9, 136(a1)
; ILP32D-NEXT:    fld ft10, 144(a1)
; ILP32D-NEXT:    fld ft11, 152(a1)
; ILP32D-NEXT:    fld fs0, 160(a1)
; ILP32D-NEXT:    fld fs1, 168(a1)
; ILP32D-NEXT:    fld fs2, 176(a1)
; ILP32D-NEXT:    fld fs3, 184(a1)
; ILP32D-NEXT:    fld fs4, 192(a1)
; ILP32D-NEXT:    fld fs5, 200(a1)
; ILP32D-NEXT:    fld fs6, 208(a1)
; ILP32D-NEXT:    fld fs7, 216(a1)
; ILP32D-NEXT:    fld fs8, 248(a1)
; ILP32D-NEXT:    fld fs9, 240(a1)
; ILP32D-NEXT:    fld fs10, 232(a1)
; ILP32D-NEXT:    fld fs11, 224(a1)
; ILP32D-NEXT:    fsd fs8, 248(a1)
; ILP32D-NEXT:    fsd fs9, 240(a1)
; ILP32D-NEXT:    fsd fs10, 232(a1)
; ILP32D-NEXT:    fsd fs11, 224(a1)
; ILP32D-NEXT:    fsd fs7, 216(a1)
; ILP32D-NEXT:    fsd fs6, 208(a1)
; ILP32D-NEXT:    fsd fs5, 200(a1)
; ILP32D-NEXT:    fsd fs4, 192(a1)
; ILP32D-NEXT:    fsd fs3, 184(a1)
; ILP32D-NEXT:    fsd fs2, 176(a1)
; ILP32D-NEXT:    fsd fs1, 168(a1)
; ILP32D-NEXT:    fsd fs0, 160(a1)
; ILP32D-NEXT:    fsd ft11, 152(a1)
; ILP32D-NEXT:    fsd ft10, 144(a1)
; ILP32D-NEXT:    fsd ft9, 136(a1)
; ILP32D-NEXT:    fsd ft8, 128(a1)
; ILP32D-NEXT:    fsd fa7, 120(a1)
; ILP32D-NEXT:    fsd fa6, 112(a1)
; ILP32D-NEXT:    fsd fa5, 104(a1)
; ILP32D-NEXT:    fsd fa4, 96(a1)
; ILP32D-NEXT:    fsd fa3, 88(a1)
; ILP32D-NEXT:    fsd fa2, 80(a1)
; ILP32D-NEXT:    fsd fa1, 72(a1)
; ILP32D-NEXT:    fsd fa0, 64(a1)
; ILP32D-NEXT:    fsd ft7, 56(a1)
; ILP32D-NEXT:    fsd ft6, 48(a1)
; ILP32D-NEXT:    fsd ft5, 40(a1)
; ILP32D-NEXT:    fsd ft4, 32(a1)
; ILP32D-NEXT:    fsd ft3, 24(a1)
; ILP32D-NEXT:    fsd ft2, 16(a1)
; ILP32D-NEXT:    fsd ft1, %lo(var+8)(a0)
; ILP32D-NEXT:    fsd ft0, %lo(var)(a0)
; ILP32D-NEXT:    fld fs0, 88(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs1, 80(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs2, 72(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs3, 64(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs4, 56(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs5, 48(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs6, 40(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs7, 32(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs8, 24(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs9, 16(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs10, 8(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs11, 0(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    addi sp, sp, 96
; ILP32D-NEXT:    ret
;
; LP64D-LABEL: callee:
; LP64D:       # %bb.0:
; LP64D-NEXT:    addi sp, sp, -96
; LP64D-NEXT:    fsd fs0, 88(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs1, 80(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs2, 72(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs3, 64(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs4, 56(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs5, 48(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs6, 40(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs7, 32(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs8, 24(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs9, 16(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs10, 8(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs11, 0(sp) # 8-byte Folded Spill
; LP64D-NEXT:    lui a0, %hi(var)
; LP64D-NEXT:    fld ft0, %lo(var)(a0)
; LP64D-NEXT:    fld ft1, %lo(var+8)(a0)
; LP64D-NEXT:    addi a1, a0, %lo(var)
; LP64D-NEXT:    fld ft2, 16(a1)
; LP64D-NEXT:    fld ft3, 24(a1)
; LP64D-NEXT:    fld ft4, 32(a1)
; LP64D-NEXT:    fld ft5, 40(a1)
; LP64D-NEXT:    fld ft6, 48(a1)
; LP64D-NEXT:    fld ft7, 56(a1)
; LP64D-NEXT:    fld fa0, 64(a1)
; LP64D-NEXT:    fld fa1, 72(a1)
; LP64D-NEXT:    fld fa2, 80(a1)
; LP64D-NEXT:    fld fa3, 88(a1)
; LP64D-NEXT:    fld fa4, 96(a1)
; LP64D-NEXT:    fld fa5, 104(a1)
; LP64D-NEXT:    fld fa6, 112(a1)
; LP64D-NEXT:    fld fa7, 120(a1)
; LP64D-NEXT:    fld ft8, 128(a1)
; LP64D-NEXT:    fld ft9, 136(a1)
; LP64D-NEXT:    fld ft10, 144(a1)
; LP64D-NEXT:    fld ft11, 152(a1)
; LP64D-NEXT:    fld fs0, 160(a1)
; LP64D-NEXT:    fld fs1, 168(a1)
; LP64D-NEXT:    fld fs2, 176(a1)
; LP64D-NEXT:    fld fs3, 184(a1)
; LP64D-NEXT:    fld fs4, 192(a1)
; LP64D-NEXT:    fld fs5, 200(a1)
; LP64D-NEXT:    fld fs6, 208(a1)
; LP64D-NEXT:    fld fs7, 216(a1)
; LP64D-NEXT:    fld fs8, 248(a1)
; LP64D-NEXT:    fld fs9, 240(a1)
; LP64D-NEXT:    fld fs10, 232(a1)
; LP64D-NEXT:    fld fs11, 224(a1)
; LP64D-NEXT:    fsd fs8, 248(a1)
; LP64D-NEXT:    fsd fs9, 240(a1)
; LP64D-NEXT:    fsd fs10, 232(a1)
; LP64D-NEXT:    fsd fs11, 224(a1)
; LP64D-NEXT:    fsd fs7, 216(a1)
; LP64D-NEXT:    fsd fs6, 208(a1)
; LP64D-NEXT:    fsd fs5, 200(a1)
; LP64D-NEXT:    fsd fs4, 192(a1)
; LP64D-NEXT:    fsd fs3, 184(a1)
; LP64D-NEXT:    fsd fs2, 176(a1)
; LP64D-NEXT:    fsd fs1, 168(a1)
; LP64D-NEXT:    fsd fs0, 160(a1)
; LP64D-NEXT:    fsd ft11, 152(a1)
; LP64D-NEXT:    fsd ft10, 144(a1)
; LP64D-NEXT:    fsd ft9, 136(a1)
; LP64D-NEXT:    fsd ft8, 128(a1)
; LP64D-NEXT:    fsd fa7, 120(a1)
; LP64D-NEXT:    fsd fa6, 112(a1)
; LP64D-NEXT:    fsd fa5, 104(a1)
; LP64D-NEXT:    fsd fa4, 96(a1)
; LP64D-NEXT:    fsd fa3, 88(a1)
; LP64D-NEXT:    fsd fa2, 80(a1)
; LP64D-NEXT:    fsd fa1, 72(a1)
; LP64D-NEXT:    fsd fa0, 64(a1)
; LP64D-NEXT:    fsd ft7, 56(a1)
; LP64D-NEXT:    fsd ft6, 48(a1)
; LP64D-NEXT:    fsd ft5, 40(a1)
; LP64D-NEXT:    fsd ft4, 32(a1)
; LP64D-NEXT:    fsd ft3, 24(a1)
; LP64D-NEXT:    fsd ft2, 16(a1)
; LP64D-NEXT:    fsd ft1, %lo(var+8)(a0)
; LP64D-NEXT:    fsd ft0, %lo(var)(a0)
; LP64D-NEXT:    fld fs0, 88(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs1, 80(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs2, 72(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs3, 64(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs4, 56(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs5, 48(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs6, 40(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs7, 32(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs8, 24(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs9, 16(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs10, 8(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs11, 0(sp) # 8-byte Folded Reload
; LP64D-NEXT:    addi sp, sp, 96
; LP64D-NEXT:    ret
  %val = load [32 x double], [32 x double]* @var
  store volatile [32 x double] %val, [32 x double]* @var
  ret void
}

; This function tests that RISCVRegisterInfo::getCallPreservedMask returns
; something appropriate.
;
; For the soft float ABIs, no floating point registers are preserved, and
; codegen will use only ft0 in the body of caller. For the 'f' and 'd ABIs,
; fs0-fs11 are preserved across calls.

define void @caller() nounwind {
; ILP32-LABEL: caller:
; ILP32:       # %bb.0:
; ILP32-NEXT:    addi sp, sp, -272
; ILP32-NEXT:    sw ra, 268(sp) # 4-byte Folded Spill
; ILP32-NEXT:    sw s0, 264(sp) # 4-byte Folded Spill
; ILP32-NEXT:    sw s1, 260(sp) # 4-byte Folded Spill
; ILP32-NEXT:    lui s0, %hi(var)
; ILP32-NEXT:    fld ft0, %lo(var)(s0)
; ILP32-NEXT:    fsd ft0, 248(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, %lo(var+8)(s0)
; ILP32-NEXT:    fsd ft0, 240(sp) # 8-byte Folded Spill
; ILP32-NEXT:    addi s1, s0, %lo(var)
; ILP32-NEXT:    fld ft0, 16(s1)
; ILP32-NEXT:    fsd ft0, 232(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 24(s1)
; ILP32-NEXT:    fsd ft0, 224(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 32(s1)
; ILP32-NEXT:    fsd ft0, 216(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 40(s1)
; ILP32-NEXT:    fsd ft0, 208(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 48(s1)
; ILP32-NEXT:    fsd ft0, 200(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 56(s1)
; ILP32-NEXT:    fsd ft0, 192(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 64(s1)
; ILP32-NEXT:    fsd ft0, 184(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 72(s1)
; ILP32-NEXT:    fsd ft0, 176(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 80(s1)
; ILP32-NEXT:    fsd ft0, 168(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 88(s1)
; ILP32-NEXT:    fsd ft0, 160(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 96(s1)
; ILP32-NEXT:    fsd ft0, 152(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 104(s1)
; ILP32-NEXT:    fsd ft0, 144(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 112(s1)
; ILP32-NEXT:    fsd ft0, 136(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 120(s1)
; ILP32-NEXT:    fsd ft0, 128(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 128(s1)
; ILP32-NEXT:    fsd ft0, 120(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 136(s1)
; ILP32-NEXT:    fsd ft0, 112(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 144(s1)
; ILP32-NEXT:    fsd ft0, 104(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 152(s1)
; ILP32-NEXT:    fsd ft0, 96(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 160(s1)
; ILP32-NEXT:    fsd ft0, 88(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 168(s1)
; ILP32-NEXT:    fsd ft0, 80(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 176(s1)
; ILP32-NEXT:    fsd ft0, 72(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 184(s1)
; ILP32-NEXT:    fsd ft0, 64(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 192(s1)
; ILP32-NEXT:    fsd ft0, 56(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 200(s1)
; ILP32-NEXT:    fsd ft0, 48(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 208(s1)
; ILP32-NEXT:    fsd ft0, 40(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 216(s1)
; ILP32-NEXT:    fsd ft0, 32(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 224(s1)
; ILP32-NEXT:    fsd ft0, 24(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 232(s1)
; ILP32-NEXT:    fsd ft0, 16(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 240(s1)
; ILP32-NEXT:    fsd ft0, 8(sp) # 8-byte Folded Spill
; ILP32-NEXT:    fld ft0, 248(s1)
; ILP32-NEXT:    fsd ft0, 0(sp) # 8-byte Folded Spill
; ILP32-NEXT:    call callee@plt
; ILP32-NEXT:    fld ft0, 0(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 248(s1)
; ILP32-NEXT:    fld ft0, 8(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 240(s1)
; ILP32-NEXT:    fld ft0, 16(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 232(s1)
; ILP32-NEXT:    fld ft0, 24(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 224(s1)
; ILP32-NEXT:    fld ft0, 32(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 216(s1)
; ILP32-NEXT:    fld ft0, 40(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 208(s1)
; ILP32-NEXT:    fld ft0, 48(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 200(s1)
; ILP32-NEXT:    fld ft0, 56(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 192(s1)
; ILP32-NEXT:    fld ft0, 64(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 184(s1)
; ILP32-NEXT:    fld ft0, 72(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 176(s1)
; ILP32-NEXT:    fld ft0, 80(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 168(s1)
; ILP32-NEXT:    fld ft0, 88(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 160(s1)
; ILP32-NEXT:    fld ft0, 96(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 152(s1)
; ILP32-NEXT:    fld ft0, 104(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 144(s1)
; ILP32-NEXT:    fld ft0, 112(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 136(s1)
; ILP32-NEXT:    fld ft0, 120(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 128(s1)
; ILP32-NEXT:    fld ft0, 128(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 120(s1)
; ILP32-NEXT:    fld ft0, 136(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 112(s1)
; ILP32-NEXT:    fld ft0, 144(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 104(s1)
; ILP32-NEXT:    fld ft0, 152(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 96(s1)
; ILP32-NEXT:    fld ft0, 160(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 88(s1)
; ILP32-NEXT:    fld ft0, 168(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 80(s1)
; ILP32-NEXT:    fld ft0, 176(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 72(s1)
; ILP32-NEXT:    fld ft0, 184(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 64(s1)
; ILP32-NEXT:    fld ft0, 192(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 56(s1)
; ILP32-NEXT:    fld ft0, 200(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 48(s1)
; ILP32-NEXT:    fld ft0, 208(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 40(s1)
; ILP32-NEXT:    fld ft0, 216(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 32(s1)
; ILP32-NEXT:    fld ft0, 224(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 24(s1)
; ILP32-NEXT:    fld ft0, 232(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, 16(s1)
; ILP32-NEXT:    fld ft0, 240(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, %lo(var+8)(s0)
; ILP32-NEXT:    fld ft0, 248(sp) # 8-byte Folded Reload
; ILP32-NEXT:    fsd ft0, %lo(var)(s0)
; ILP32-NEXT:    lw ra, 268(sp) # 4-byte Folded Reload
; ILP32-NEXT:    lw s0, 264(sp) # 4-byte Folded Reload
; ILP32-NEXT:    lw s1, 260(sp) # 4-byte Folded Reload
; ILP32-NEXT:    addi sp, sp, 272
; ILP32-NEXT:    ret
;
; LP64-LABEL: caller:
; LP64:       # %bb.0:
; LP64-NEXT:    addi sp, sp, -288
; LP64-NEXT:    sd ra, 280(sp) # 8-byte Folded Spill
; LP64-NEXT:    sd s0, 272(sp) # 8-byte Folded Spill
; LP64-NEXT:    sd s1, 264(sp) # 8-byte Folded Spill
; LP64-NEXT:    lui s0, %hi(var)
; LP64-NEXT:    fld ft0, %lo(var)(s0)
; LP64-NEXT:    fsd ft0, 256(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, %lo(var+8)(s0)
; LP64-NEXT:    fsd ft0, 248(sp) # 8-byte Folded Spill
; LP64-NEXT:    addi s1, s0, %lo(var)
; LP64-NEXT:    fld ft0, 16(s1)
; LP64-NEXT:    fsd ft0, 240(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 24(s1)
; LP64-NEXT:    fsd ft0, 232(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 32(s1)
; LP64-NEXT:    fsd ft0, 224(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 40(s1)
; LP64-NEXT:    fsd ft0, 216(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 48(s1)
; LP64-NEXT:    fsd ft0, 208(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 56(s1)
; LP64-NEXT:    fsd ft0, 200(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 64(s1)
; LP64-NEXT:    fsd ft0, 192(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 72(s1)
; LP64-NEXT:    fsd ft0, 184(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 80(s1)
; LP64-NEXT:    fsd ft0, 176(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 88(s1)
; LP64-NEXT:    fsd ft0, 168(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 96(s1)
; LP64-NEXT:    fsd ft0, 160(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 104(s1)
; LP64-NEXT:    fsd ft0, 152(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 112(s1)
; LP64-NEXT:    fsd ft0, 144(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 120(s1)
; LP64-NEXT:    fsd ft0, 136(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 128(s1)
; LP64-NEXT:    fsd ft0, 128(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 136(s1)
; LP64-NEXT:    fsd ft0, 120(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 144(s1)
; LP64-NEXT:    fsd ft0, 112(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 152(s1)
; LP64-NEXT:    fsd ft0, 104(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 160(s1)
; LP64-NEXT:    fsd ft0, 96(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 168(s1)
; LP64-NEXT:    fsd ft0, 88(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 176(s1)
; LP64-NEXT:    fsd ft0, 80(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 184(s1)
; LP64-NEXT:    fsd ft0, 72(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 192(s1)
; LP64-NEXT:    fsd ft0, 64(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 200(s1)
; LP64-NEXT:    fsd ft0, 56(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 208(s1)
; LP64-NEXT:    fsd ft0, 48(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 216(s1)
; LP64-NEXT:    fsd ft0, 40(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 224(s1)
; LP64-NEXT:    fsd ft0, 32(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 232(s1)
; LP64-NEXT:    fsd ft0, 24(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 240(s1)
; LP64-NEXT:    fsd ft0, 16(sp) # 8-byte Folded Spill
; LP64-NEXT:    fld ft0, 248(s1)
; LP64-NEXT:    fsd ft0, 8(sp) # 8-byte Folded Spill
; LP64-NEXT:    call callee@plt
; LP64-NEXT:    fld ft0, 8(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 248(s1)
; LP64-NEXT:    fld ft0, 16(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 240(s1)
; LP64-NEXT:    fld ft0, 24(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 232(s1)
; LP64-NEXT:    fld ft0, 32(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 224(s1)
; LP64-NEXT:    fld ft0, 40(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 216(s1)
; LP64-NEXT:    fld ft0, 48(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 208(s1)
; LP64-NEXT:    fld ft0, 56(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 200(s1)
; LP64-NEXT:    fld ft0, 64(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 192(s1)
; LP64-NEXT:    fld ft0, 72(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 184(s1)
; LP64-NEXT:    fld ft0, 80(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 176(s1)
; LP64-NEXT:    fld ft0, 88(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 168(s1)
; LP64-NEXT:    fld ft0, 96(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 160(s1)
; LP64-NEXT:    fld ft0, 104(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 152(s1)
; LP64-NEXT:    fld ft0, 112(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 144(s1)
; LP64-NEXT:    fld ft0, 120(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 136(s1)
; LP64-NEXT:    fld ft0, 128(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 128(s1)
; LP64-NEXT:    fld ft0, 136(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 120(s1)
; LP64-NEXT:    fld ft0, 144(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 112(s1)
; LP64-NEXT:    fld ft0, 152(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 104(s1)
; LP64-NEXT:    fld ft0, 160(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 96(s1)
; LP64-NEXT:    fld ft0, 168(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 88(s1)
; LP64-NEXT:    fld ft0, 176(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 80(s1)
; LP64-NEXT:    fld ft0, 184(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 72(s1)
; LP64-NEXT:    fld ft0, 192(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 64(s1)
; LP64-NEXT:    fld ft0, 200(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 56(s1)
; LP64-NEXT:    fld ft0, 208(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 48(s1)
; LP64-NEXT:    fld ft0, 216(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 40(s1)
; LP64-NEXT:    fld ft0, 224(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 32(s1)
; LP64-NEXT:    fld ft0, 232(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 24(s1)
; LP64-NEXT:    fld ft0, 240(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, 16(s1)
; LP64-NEXT:    fld ft0, 248(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, %lo(var+8)(s0)
; LP64-NEXT:    fld ft0, 256(sp) # 8-byte Folded Reload
; LP64-NEXT:    fsd ft0, %lo(var)(s0)
; LP64-NEXT:    ld ra, 280(sp) # 8-byte Folded Reload
; LP64-NEXT:    ld s0, 272(sp) # 8-byte Folded Reload
; LP64-NEXT:    ld s1, 264(sp) # 8-byte Folded Reload
; LP64-NEXT:    addi sp, sp, 288
; LP64-NEXT:    ret
;
; ILP32D-LABEL: caller:
; ILP32D:       # %bb.0:
; ILP32D-NEXT:    addi sp, sp, -272
; ILP32D-NEXT:    sw ra, 268(sp) # 4-byte Folded Spill
; ILP32D-NEXT:    sw s0, 264(sp) # 4-byte Folded Spill
; ILP32D-NEXT:    sw s1, 260(sp) # 4-byte Folded Spill
; ILP32D-NEXT:    fsd fs0, 248(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs1, 240(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs2, 232(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs3, 224(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs4, 216(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs5, 208(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs6, 200(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs7, 192(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs8, 184(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs9, 176(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs10, 168(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fsd fs11, 160(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    lui s0, %hi(var)
; ILP32D-NEXT:    fld ft0, %lo(var)(s0)
; ILP32D-NEXT:    fsd ft0, 152(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, %lo(var+8)(s0)
; ILP32D-NEXT:    fsd ft0, 144(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    addi s1, s0, %lo(var)
; ILP32D-NEXT:    fld ft0, 16(s1)
; ILP32D-NEXT:    fsd ft0, 136(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 24(s1)
; ILP32D-NEXT:    fsd ft0, 128(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 32(s1)
; ILP32D-NEXT:    fsd ft0, 120(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 40(s1)
; ILP32D-NEXT:    fsd ft0, 112(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 48(s1)
; ILP32D-NEXT:    fsd ft0, 104(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 56(s1)
; ILP32D-NEXT:    fsd ft0, 96(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 64(s1)
; ILP32D-NEXT:    fsd ft0, 88(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 72(s1)
; ILP32D-NEXT:    fsd ft0, 80(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 80(s1)
; ILP32D-NEXT:    fsd ft0, 72(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 88(s1)
; ILP32D-NEXT:    fsd ft0, 64(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 96(s1)
; ILP32D-NEXT:    fsd ft0, 56(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 104(s1)
; ILP32D-NEXT:    fsd ft0, 48(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 112(s1)
; ILP32D-NEXT:    fsd ft0, 40(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 120(s1)
; ILP32D-NEXT:    fsd ft0, 32(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 128(s1)
; ILP32D-NEXT:    fsd ft0, 24(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 136(s1)
; ILP32D-NEXT:    fsd ft0, 16(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 144(s1)
; ILP32D-NEXT:    fsd ft0, 8(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld ft0, 152(s1)
; ILP32D-NEXT:    fsd ft0, 0(sp) # 8-byte Folded Spill
; ILP32D-NEXT:    fld fs8, 160(s1)
; ILP32D-NEXT:    fld fs9, 168(s1)
; ILP32D-NEXT:    fld fs10, 176(s1)
; ILP32D-NEXT:    fld fs11, 184(s1)
; ILP32D-NEXT:    fld fs0, 192(s1)
; ILP32D-NEXT:    fld fs1, 200(s1)
; ILP32D-NEXT:    fld fs2, 208(s1)
; ILP32D-NEXT:    fld fs3, 216(s1)
; ILP32D-NEXT:    fld fs4, 224(s1)
; ILP32D-NEXT:    fld fs5, 232(s1)
; ILP32D-NEXT:    fld fs6, 240(s1)
; ILP32D-NEXT:    fld fs7, 248(s1)
; ILP32D-NEXT:    call callee@plt
; ILP32D-NEXT:    fsd fs7, 248(s1)
; ILP32D-NEXT:    fsd fs6, 240(s1)
; ILP32D-NEXT:    fsd fs5, 232(s1)
; ILP32D-NEXT:    fsd fs4, 224(s1)
; ILP32D-NEXT:    fsd fs3, 216(s1)
; ILP32D-NEXT:    fsd fs2, 208(s1)
; ILP32D-NEXT:    fsd fs1, 200(s1)
; ILP32D-NEXT:    fsd fs0, 192(s1)
; ILP32D-NEXT:    fsd fs11, 184(s1)
; ILP32D-NEXT:    fsd fs10, 176(s1)
; ILP32D-NEXT:    fsd fs9, 168(s1)
; ILP32D-NEXT:    fsd fs8, 160(s1)
; ILP32D-NEXT:    fld ft0, 0(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 152(s1)
; ILP32D-NEXT:    fld ft0, 8(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 144(s1)
; ILP32D-NEXT:    fld ft0, 16(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 136(s1)
; ILP32D-NEXT:    fld ft0, 24(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 128(s1)
; ILP32D-NEXT:    fld ft0, 32(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 120(s1)
; ILP32D-NEXT:    fld ft0, 40(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 112(s1)
; ILP32D-NEXT:    fld ft0, 48(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 104(s1)
; ILP32D-NEXT:    fld ft0, 56(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 96(s1)
; ILP32D-NEXT:    fld ft0, 64(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 88(s1)
; ILP32D-NEXT:    fld ft0, 72(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 80(s1)
; ILP32D-NEXT:    fld ft0, 80(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 72(s1)
; ILP32D-NEXT:    fld ft0, 88(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 64(s1)
; ILP32D-NEXT:    fld ft0, 96(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 56(s1)
; ILP32D-NEXT:    fld ft0, 104(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 48(s1)
; ILP32D-NEXT:    fld ft0, 112(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 40(s1)
; ILP32D-NEXT:    fld ft0, 120(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 32(s1)
; ILP32D-NEXT:    fld ft0, 128(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 24(s1)
; ILP32D-NEXT:    fld ft0, 136(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, 16(s1)
; ILP32D-NEXT:    fld ft0, 144(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, %lo(var+8)(s0)
; ILP32D-NEXT:    fld ft0, 152(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fsd ft0, %lo(var)(s0)
; ILP32D-NEXT:    lw ra, 268(sp) # 4-byte Folded Reload
; ILP32D-NEXT:    lw s0, 264(sp) # 4-byte Folded Reload
; ILP32D-NEXT:    lw s1, 260(sp) # 4-byte Folded Reload
; ILP32D-NEXT:    fld fs0, 248(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs1, 240(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs2, 232(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs3, 224(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs4, 216(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs5, 208(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs6, 200(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs7, 192(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs8, 184(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs9, 176(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs10, 168(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    fld fs11, 160(sp) # 8-byte Folded Reload
; ILP32D-NEXT:    addi sp, sp, 272
; ILP32D-NEXT:    ret
;
; LP64D-LABEL: caller:
; LP64D:       # %bb.0:
; LP64D-NEXT:    addi sp, sp, -288
; LP64D-NEXT:    sd ra, 280(sp) # 8-byte Folded Spill
; LP64D-NEXT:    sd s0, 272(sp) # 8-byte Folded Spill
; LP64D-NEXT:    sd s1, 264(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs0, 256(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs1, 248(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs2, 240(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs3, 232(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs4, 224(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs5, 216(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs6, 208(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs7, 200(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs8, 192(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs9, 184(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs10, 176(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fsd fs11, 168(sp) # 8-byte Folded Spill
; LP64D-NEXT:    lui s0, %hi(var)
; LP64D-NEXT:    fld ft0, %lo(var)(s0)
; LP64D-NEXT:    fsd ft0, 160(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, %lo(var+8)(s0)
; LP64D-NEXT:    fsd ft0, 152(sp) # 8-byte Folded Spill
; LP64D-NEXT:    addi s1, s0, %lo(var)
; LP64D-NEXT:    fld ft0, 16(s1)
; LP64D-NEXT:    fsd ft0, 144(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 24(s1)
; LP64D-NEXT:    fsd ft0, 136(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 32(s1)
; LP64D-NEXT:    fsd ft0, 128(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 40(s1)
; LP64D-NEXT:    fsd ft0, 120(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 48(s1)
; LP64D-NEXT:    fsd ft0, 112(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 56(s1)
; LP64D-NEXT:    fsd ft0, 104(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 64(s1)
; LP64D-NEXT:    fsd ft0, 96(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 72(s1)
; LP64D-NEXT:    fsd ft0, 88(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 80(s1)
; LP64D-NEXT:    fsd ft0, 80(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 88(s1)
; LP64D-NEXT:    fsd ft0, 72(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 96(s1)
; LP64D-NEXT:    fsd ft0, 64(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 104(s1)
; LP64D-NEXT:    fsd ft0, 56(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 112(s1)
; LP64D-NEXT:    fsd ft0, 48(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 120(s1)
; LP64D-NEXT:    fsd ft0, 40(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 128(s1)
; LP64D-NEXT:    fsd ft0, 32(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 136(s1)
; LP64D-NEXT:    fsd ft0, 24(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 144(s1)
; LP64D-NEXT:    fsd ft0, 16(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld ft0, 152(s1)
; LP64D-NEXT:    fsd ft0, 8(sp) # 8-byte Folded Spill
; LP64D-NEXT:    fld fs8, 160(s1)
; LP64D-NEXT:    fld fs9, 168(s1)
; LP64D-NEXT:    fld fs10, 176(s1)
; LP64D-NEXT:    fld fs11, 184(s1)
; LP64D-NEXT:    fld fs0, 192(s1)
; LP64D-NEXT:    fld fs1, 200(s1)
; LP64D-NEXT:    fld fs2, 208(s1)
; LP64D-NEXT:    fld fs3, 216(s1)
; LP64D-NEXT:    fld fs4, 224(s1)
; LP64D-NEXT:    fld fs5, 232(s1)
; LP64D-NEXT:    fld fs6, 240(s1)
; LP64D-NEXT:    fld fs7, 248(s1)
; LP64D-NEXT:    call callee@plt
; LP64D-NEXT:    fsd fs7, 248(s1)
; LP64D-NEXT:    fsd fs6, 240(s1)
; LP64D-NEXT:    fsd fs5, 232(s1)
; LP64D-NEXT:    fsd fs4, 224(s1)
; LP64D-NEXT:    fsd fs3, 216(s1)
; LP64D-NEXT:    fsd fs2, 208(s1)
; LP64D-NEXT:    fsd fs1, 200(s1)
; LP64D-NEXT:    fsd fs0, 192(s1)
; LP64D-NEXT:    fsd fs11, 184(s1)
; LP64D-NEXT:    fsd fs10, 176(s1)
; LP64D-NEXT:    fsd fs9, 168(s1)
; LP64D-NEXT:    fsd fs8, 160(s1)
; LP64D-NEXT:    fld ft0, 8(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 152(s1)
; LP64D-NEXT:    fld ft0, 16(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 144(s1)
; LP64D-NEXT:    fld ft0, 24(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 136(s1)
; LP64D-NEXT:    fld ft0, 32(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 128(s1)
; LP64D-NEXT:    fld ft0, 40(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 120(s1)
; LP64D-NEXT:    fld ft0, 48(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 112(s1)
; LP64D-NEXT:    fld ft0, 56(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 104(s1)
; LP64D-NEXT:    fld ft0, 64(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 96(s1)
; LP64D-NEXT:    fld ft0, 72(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 88(s1)
; LP64D-NEXT:    fld ft0, 80(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 80(s1)
; LP64D-NEXT:    fld ft0, 88(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 72(s1)
; LP64D-NEXT:    fld ft0, 96(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 64(s1)
; LP64D-NEXT:    fld ft0, 104(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 56(s1)
; LP64D-NEXT:    fld ft0, 112(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 48(s1)
; LP64D-NEXT:    fld ft0, 120(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 40(s1)
; LP64D-NEXT:    fld ft0, 128(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 32(s1)
; LP64D-NEXT:    fld ft0, 136(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 24(s1)
; LP64D-NEXT:    fld ft0, 144(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, 16(s1)
; LP64D-NEXT:    fld ft0, 152(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, %lo(var+8)(s0)
; LP64D-NEXT:    fld ft0, 160(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fsd ft0, %lo(var)(s0)
; LP64D-NEXT:    ld ra, 280(sp) # 8-byte Folded Reload
; LP64D-NEXT:    ld s0, 272(sp) # 8-byte Folded Reload
; LP64D-NEXT:    ld s1, 264(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs0, 256(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs1, 248(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs2, 240(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs3, 232(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs4, 224(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs5, 216(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs6, 208(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs7, 200(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs8, 192(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs9, 184(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs10, 176(sp) # 8-byte Folded Reload
; LP64D-NEXT:    fld fs11, 168(sp) # 8-byte Folded Reload
; LP64D-NEXT:    addi sp, sp, 288
; LP64D-NEXT:    ret
  %val = load [32 x double], [32 x double]* @var
  call void @callee()
  store volatile [32 x double] %val, [32 x double]* @var
  ret void
}
