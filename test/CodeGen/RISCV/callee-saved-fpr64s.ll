; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=ILP32-LP64
; RUN: llc -mtriple=riscv64 -mattr=+d -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=ILP32-LP64

@var = global [32 x double] zeroinitializer

; All floating point registers are temporaries for the ilp32 and lp64 ABIs.

define void @foo() {
; ILP32-LP64-LABEL: foo:
; ILP32-LP64:       # %bb.0:
; ILP32-LP64-NEXT:    lui a0, %hi(var)
; ILP32-LP64-NEXT:    addi a1, a0, %lo(var)
; ILP32-LP64-NEXT:    fld ft0, %lo(var)(a0)
; ILP32-LP64-NEXT:    fld ft1, 8(a1)
; ILP32-LP64-NEXT:    fld ft2, 16(a1)
; ILP32-LP64-NEXT:    fld ft3, 24(a1)
; ILP32-LP64-NEXT:    fld ft4, 32(a1)
; ILP32-LP64-NEXT:    fld ft5, 40(a1)
; ILP32-LP64-NEXT:    fld ft6, 48(a1)
; ILP32-LP64-NEXT:    fld ft7, 56(a1)
; ILP32-LP64-NEXT:    fld fa0, 64(a1)
; ILP32-LP64-NEXT:    fld fa1, 72(a1)
; ILP32-LP64-NEXT:    fld fa2, 80(a1)
; ILP32-LP64-NEXT:    fld fa3, 88(a1)
; ILP32-LP64-NEXT:    fld fa4, 96(a1)
; ILP32-LP64-NEXT:    fld fa5, 104(a1)
; ILP32-LP64-NEXT:    fld fa6, 112(a1)
; ILP32-LP64-NEXT:    fld fa7, 120(a1)
; ILP32-LP64-NEXT:    fld ft8, 128(a1)
; ILP32-LP64-NEXT:    fld ft9, 136(a1)
; ILP32-LP64-NEXT:    fld ft10, 144(a1)
; ILP32-LP64-NEXT:    fld ft11, 152(a1)
; ILP32-LP64-NEXT:    fld fs0, 160(a1)
; ILP32-LP64-NEXT:    fld fs1, 168(a1)
; ILP32-LP64-NEXT:    fld fs2, 176(a1)
; ILP32-LP64-NEXT:    fld fs3, 184(a1)
; ILP32-LP64-NEXT:    fld fs4, 192(a1)
; ILP32-LP64-NEXT:    fld fs5, 200(a1)
; ILP32-LP64-NEXT:    fld fs6, 208(a1)
; ILP32-LP64-NEXT:    fld fs7, 216(a1)
; ILP32-LP64-NEXT:    fld fs8, 224(a1)
; ILP32-LP64-NEXT:    fld fs9, 232(a1)
; ILP32-LP64-NEXT:    fld fs10, 240(a1)
; ILP32-LP64-NEXT:    fld fs11, 248(a1)
; ILP32-LP64-NEXT:    fsd fs11, 248(a1)
; ILP32-LP64-NEXT:    fsd fs10, 240(a1)
; ILP32-LP64-NEXT:    fsd fs9, 232(a1)
; ILP32-LP64-NEXT:    fsd fs8, 224(a1)
; ILP32-LP64-NEXT:    fsd fs7, 216(a1)
; ILP32-LP64-NEXT:    fsd fs6, 208(a1)
; ILP32-LP64-NEXT:    fsd fs5, 200(a1)
; ILP32-LP64-NEXT:    fsd fs4, 192(a1)
; ILP32-LP64-NEXT:    fsd fs3, 184(a1)
; ILP32-LP64-NEXT:    fsd fs2, 176(a1)
; ILP32-LP64-NEXT:    fsd fs1, 168(a1)
; ILP32-LP64-NEXT:    fsd fs0, 160(a1)
; ILP32-LP64-NEXT:    fsd ft11, 152(a1)
; ILP32-LP64-NEXT:    fsd ft10, 144(a1)
; ILP32-LP64-NEXT:    fsd ft9, 136(a1)
; ILP32-LP64-NEXT:    fsd ft8, 128(a1)
; ILP32-LP64-NEXT:    fsd fa7, 120(a1)
; ILP32-LP64-NEXT:    fsd fa6, 112(a1)
; ILP32-LP64-NEXT:    fsd fa5, 104(a1)
; ILP32-LP64-NEXT:    fsd fa4, 96(a1)
; ILP32-LP64-NEXT:    fsd fa3, 88(a1)
; ILP32-LP64-NEXT:    fsd fa2, 80(a1)
; ILP32-LP64-NEXT:    fsd fa1, 72(a1)
; ILP32-LP64-NEXT:    fsd fa0, 64(a1)
; ILP32-LP64-NEXT:    fsd ft7, 56(a1)
; ILP32-LP64-NEXT:    fsd ft6, 48(a1)
; ILP32-LP64-NEXT:    fsd ft5, 40(a1)
; ILP32-LP64-NEXT:    fsd ft4, 32(a1)
; ILP32-LP64-NEXT:    fsd ft3, 24(a1)
; ILP32-LP64-NEXT:    fsd ft2, 16(a1)
; ILP32-LP64-NEXT:    fsd ft1, 8(a1)
; ILP32-LP64-NEXT:    fsd ft0, %lo(var)(a0)
; ILP32-LP64-NEXT:    ret
  %val = load [32 x double], [32 x double]* @var
  store volatile [32 x double] %val, [32 x double]* @var
  ret void
}
