; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32I %s

%struct.Foo = type { i32, i32, i32, i16, i8 }
@foo = global %struct.Foo { i32 1, i32 2, i32 3, i16 4, i8 5 }, align 4

define i32 @callee(%struct.Foo* byval(%struct.Foo) %f) nounwind {
; RV32I-LABEL: callee:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    lw a0, 0(a0)
; RV32I-NEXT:    ret
entry:
  %0 = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 0
  %1 = load i32, i32* %0, align 4
  ret i32 %1
}


define void @caller() nounwind {
; RV32I-LABEL: caller:
; RV32I:       # %bb.0: # %entry
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; RV32I-NEXT:    lui a0, %hi(foo)
; RV32I-NEXT:    lw a1, %lo(foo)(a0)
; RV32I-NEXT:    sw a1, 12(sp)
; RV32I-NEXT:    addi a0, a0, %lo(foo)
; RV32I-NEXT:    lw a1, 12(a0)
; RV32I-NEXT:    sw a1, 24(sp)
; RV32I-NEXT:    lw a1, 8(a0)
; RV32I-NEXT:    sw a1, 20(sp)
; RV32I-NEXT:    lw a0, 4(a0)
; RV32I-NEXT:    sw a0, 16(sp)
; RV32I-NEXT:    addi a0, sp, 12
; RV32I-NEXT:    call callee
; RV32I-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; RV32I-NEXT:    addi sp, sp, 32
; RV32I-NEXT:    ret
entry:
  %call = call i32 @callee(%struct.Foo* byval(%struct.Foo) @foo)
  ret void
}
