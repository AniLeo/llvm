; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+d -target-abi=ilp32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32IFD %s

define double @test(double %a) nounwind {
; RV32IFD-LABEL: test:
; RV32IFD:       # %bb.0:
; RV32IFD-NEXT:    ret
  ret double %a
}

; This previously failed complaining of multiple vreg defs due to an ABI
; lowering issue.

define i32 @main() nounwind {
; RV32IFD-LABEL: main:
; RV32IFD:       # %bb.0: # %entry
; RV32IFD-NEXT:    addi sp, sp, -16
; RV32IFD-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32IFD-NEXT:    lui a1, 262144
; RV32IFD-NEXT:    li a0, 0
; RV32IFD-NEXT:    call test@plt
; RV32IFD-NEXT:    sw a0, 0(sp)
; RV32IFD-NEXT:    sw a1, 4(sp)
; RV32IFD-NEXT:    fld ft0, 0(sp)
; RV32IFD-NEXT:    lui a0, %hi(.LCPI1_0)
; RV32IFD-NEXT:    fld ft1, %lo(.LCPI1_0)(a0)
; RV32IFD-NEXT:    lui a0, %hi(.LCPI1_1)
; RV32IFD-NEXT:    fld ft2, %lo(.LCPI1_1)(a0)
; RV32IFD-NEXT:    flt.d a0, ft0, ft1
; RV32IFD-NEXT:    not a0, a0
; RV32IFD-NEXT:    flt.d a1, ft2, ft0
; RV32IFD-NEXT:    xori a1, a1, 1
; RV32IFD-NEXT:    and a0, a0, a1
; RV32IFD-NEXT:    bnez a0, .LBB1_2
; RV32IFD-NEXT:  # %bb.1: # %if.then
; RV32IFD-NEXT:    call abort@plt
; RV32IFD-NEXT:  .LBB1_2: # %if.end
; RV32IFD-NEXT:    li a0, 0
; RV32IFD-NEXT:    call exit@plt
entry:
  %call = call double @test(double 2.000000e+00)
  %cmp = fcmp olt double %call, 2.400000e-01
  %cmp2 = fcmp ogt double %call, 2.600000e-01
  %or.cond = or i1 %cmp, %cmp2
  br i1 %or.cond, label %if.then, label %if.end

if.then:
  call void @abort()
  unreachable

if.end:
  call void @exit(i32 0)
  unreachable
}

declare void @abort()

declare void @exit(i32)
