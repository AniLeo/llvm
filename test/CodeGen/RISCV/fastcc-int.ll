; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV32 %s
; RUN: llc -mtriple=riscv64 -verify-machineinstrs < %s \
; RUN:   | FileCheck -check-prefix=RV64 %s

define fastcc i32 @callee(<16 x i32> %A) nounwind {
; RV32-LABEL: callee:
; RV32:       # %bb.0:
; RV32-NEXT:    ret
;
; RV64-LABEL: callee:
; RV64:       # %bb.0:
; RV64-NEXT:    ret
	%B = extractelement <16 x i32> %A, i32 0
	ret i32 %B
}

; With the fastcc, arguments will be passed by a0-a7 and t2-t6.
; The rest will be pushed on the stack.
define i32 @caller(<16 x i32> %A) nounwind {
; RV32-LABEL: caller:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -32
; RV32-NEXT:    sw ra, 28(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s0, 24(sp) # 4-byte Folded Spill
; RV32-NEXT:    lw t0, 0(a0)
; RV32-NEXT:    lw a1, 4(a0)
; RV32-NEXT:    lw a2, 8(a0)
; RV32-NEXT:    lw a3, 12(a0)
; RV32-NEXT:    lw a4, 16(a0)
; RV32-NEXT:    lw a5, 20(a0)
; RV32-NEXT:    lw a6, 24(a0)
; RV32-NEXT:    lw a7, 28(a0)
; RV32-NEXT:    lw t2, 32(a0)
; RV32-NEXT:    lw t3, 36(a0)
; RV32-NEXT:    lw t4, 40(a0)
; RV32-NEXT:    lw t5, 44(a0)
; RV32-NEXT:    lw t6, 48(a0)
; RV32-NEXT:    lw t1, 52(a0)
; RV32-NEXT:    lw s0, 56(a0)
; RV32-NEXT:    lw a0, 60(a0)
; RV32-NEXT:    sw a0, 8(sp)
; RV32-NEXT:    sw s0, 4(sp)
; RV32-NEXT:    sw t1, 0(sp)
; RV32-NEXT:    mv a0, t0
; RV32-NEXT:    call callee
; RV32-NEXT:    lw s0, 24(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw ra, 28(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 32
; RV32-NEXT:    ret
;
; RV64-LABEL: caller:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -48
; RV64-NEXT:    sd ra, 40(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s0, 32(sp) # 8-byte Folded Spill
; RV64-NEXT:    ld t0, 0(a0)
; RV64-NEXT:    ld a1, 8(a0)
; RV64-NEXT:    ld a2, 16(a0)
; RV64-NEXT:    ld a3, 24(a0)
; RV64-NEXT:    ld a4, 32(a0)
; RV64-NEXT:    ld a5, 40(a0)
; RV64-NEXT:    ld a6, 48(a0)
; RV64-NEXT:    ld a7, 56(a0)
; RV64-NEXT:    ld t2, 64(a0)
; RV64-NEXT:    ld t3, 72(a0)
; RV64-NEXT:    ld t4, 80(a0)
; RV64-NEXT:    ld t5, 88(a0)
; RV64-NEXT:    ld t6, 96(a0)
; RV64-NEXT:    ld t1, 104(a0)
; RV64-NEXT:    ld s0, 112(a0)
; RV64-NEXT:    ld a0, 120(a0)
; RV64-NEXT:    sd a0, 16(sp)
; RV64-NEXT:    sd s0, 8(sp)
; RV64-NEXT:    sd t1, 0(sp)
; RV64-NEXT:    mv a0, t0
; RV64-NEXT:    call callee
; RV64-NEXT:    ld s0, 32(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld ra, 40(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 48
; RV64-NEXT:    ret
	%C = call fastcc i32 @callee(<16 x i32> %A)
	ret i32 %C
}
