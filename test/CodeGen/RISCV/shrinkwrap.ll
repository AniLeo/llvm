; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple riscv32 -enable-shrink-wrap=false < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I-SW-NO
; RUN: llc -mtriple riscv32 < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I-SW
; RUN: llc -mtriple riscv32 -mattr=+save-restore < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I-SW-SR
; RUN: llc -mtriple riscv64 < %s \
; RUN:   | FileCheck %s -check-prefix=RV64I-SW

declare void @abort()

define void @eliminate_restore(i32 %n) nounwind {
; RV32I-SW-NO-LABEL: eliminate_restore:
; RV32I-SW-NO:       # %bb.0:
; RV32I-SW-NO-NEXT:    addi sp, sp, -16
; RV32I-SW-NO-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-SW-NO-NEXT:    li a1, 32
; RV32I-SW-NO-NEXT:    bgeu a1, a0, .LBB0_2
; RV32I-SW-NO-NEXT:  # %bb.1: # %if.end
; RV32I-SW-NO-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-SW-NO-NEXT:    addi sp, sp, 16
; RV32I-SW-NO-NEXT:    ret
; RV32I-SW-NO-NEXT:  .LBB0_2: # %if.then
; RV32I-SW-NO-NEXT:    call abort@plt
;
; RV32I-SW-LABEL: eliminate_restore:
; RV32I-SW:       # %bb.0:
; RV32I-SW-NEXT:    addi sp, sp, -16
; RV32I-SW-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-SW-NEXT:    li a1, 32
; RV32I-SW-NEXT:    bgeu a1, a0, .LBB0_2
; RV32I-SW-NEXT:  # %bb.1: # %if.end
; RV32I-SW-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-SW-NEXT:    addi sp, sp, 16
; RV32I-SW-NEXT:    ret
; RV32I-SW-NEXT:  .LBB0_2: # %if.then
; RV32I-SW-NEXT:    call abort@plt
;
; RV32I-SW-SR-LABEL: eliminate_restore:
; RV32I-SW-SR:       # %bb.0:
; RV32I-SW-SR-NEXT:    call t0, __riscv_save_0
; RV32I-SW-SR-NEXT:    li a1, 32
; RV32I-SW-SR-NEXT:    bgeu a1, a0, .LBB0_2
; RV32I-SW-SR-NEXT:  # %bb.1: # %if.end
; RV32I-SW-SR-NEXT:    tail __riscv_restore_0
; RV32I-SW-SR-NEXT:  .LBB0_2: # %if.then
; RV32I-SW-SR-NEXT:    call abort@plt
;
; RV64I-SW-LABEL: eliminate_restore:
; RV64I-SW:       # %bb.0:
; RV64I-SW-NEXT:    addi sp, sp, -16
; RV64I-SW-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-SW-NEXT:    sext.w a0, a0
; RV64I-SW-NEXT:    li a1, 32
; RV64I-SW-NEXT:    bgeu a1, a0, .LBB0_2
; RV64I-SW-NEXT:  # %bb.1: # %if.end
; RV64I-SW-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-SW-NEXT:    addi sp, sp, 16
; RV64I-SW-NEXT:    ret
; RV64I-SW-NEXT:  .LBB0_2: # %if.then
; RV64I-SW-NEXT:    call abort@plt
  %cmp = icmp ule i32 %n, 32
  br i1 %cmp, label %if.then, label %if.end

if.then:
  call void @abort()
  unreachable

if.end:
  ret void
}

declare void @notdead(i8*)

define void @conditional_alloca(i32 %n) nounwind {
; RV32I-SW-NO-LABEL: conditional_alloca:
; RV32I-SW-NO:       # %bb.0:
; RV32I-SW-NO-NEXT:    addi sp, sp, -16
; RV32I-SW-NO-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-SW-NO-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-SW-NO-NEXT:    addi s0, sp, 16
; RV32I-SW-NO-NEXT:    li a1, 32
; RV32I-SW-NO-NEXT:    bltu a1, a0, .LBB1_2
; RV32I-SW-NO-NEXT:  # %bb.1: # %if.then
; RV32I-SW-NO-NEXT:    addi a0, a0, 15
; RV32I-SW-NO-NEXT:    andi a0, a0, -16
; RV32I-SW-NO-NEXT:    sub a0, sp, a0
; RV32I-SW-NO-NEXT:    mv sp, a0
; RV32I-SW-NO-NEXT:    call notdead@plt
; RV32I-SW-NO-NEXT:  .LBB1_2: # %if.end
; RV32I-SW-NO-NEXT:    addi sp, s0, -16
; RV32I-SW-NO-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-SW-NO-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-SW-NO-NEXT:    addi sp, sp, 16
; RV32I-SW-NO-NEXT:    ret
;
; RV32I-SW-LABEL: conditional_alloca:
; RV32I-SW:       # %bb.0:
; RV32I-SW-NEXT:    addi sp, sp, -16
; RV32I-SW-NEXT:    sw ra, 12(sp) # 4-byte Folded Spill
; RV32I-SW-NEXT:    sw s0, 8(sp) # 4-byte Folded Spill
; RV32I-SW-NEXT:    addi s0, sp, 16
; RV32I-SW-NEXT:    li a1, 32
; RV32I-SW-NEXT:    bltu a1, a0, .LBB1_2
; RV32I-SW-NEXT:  # %bb.1: # %if.then
; RV32I-SW-NEXT:    addi a0, a0, 15
; RV32I-SW-NEXT:    andi a0, a0, -16
; RV32I-SW-NEXT:    sub a0, sp, a0
; RV32I-SW-NEXT:    mv sp, a0
; RV32I-SW-NEXT:    call notdead@plt
; RV32I-SW-NEXT:  .LBB1_2: # %if.end
; RV32I-SW-NEXT:    addi sp, s0, -16
; RV32I-SW-NEXT:    lw ra, 12(sp) # 4-byte Folded Reload
; RV32I-SW-NEXT:    lw s0, 8(sp) # 4-byte Folded Reload
; RV32I-SW-NEXT:    addi sp, sp, 16
; RV32I-SW-NEXT:    ret
;
; RV32I-SW-SR-LABEL: conditional_alloca:
; RV32I-SW-SR:       # %bb.0:
; RV32I-SW-SR-NEXT:    call t0, __riscv_save_1
; RV32I-SW-SR-NEXT:    addi s0, sp, 16
; RV32I-SW-SR-NEXT:    li a1, 32
; RV32I-SW-SR-NEXT:    bltu a1, a0, .LBB1_2
; RV32I-SW-SR-NEXT:  # %bb.1: # %if.then
; RV32I-SW-SR-NEXT:    addi a0, a0, 15
; RV32I-SW-SR-NEXT:    andi a0, a0, -16
; RV32I-SW-SR-NEXT:    sub a0, sp, a0
; RV32I-SW-SR-NEXT:    mv sp, a0
; RV32I-SW-SR-NEXT:    call notdead@plt
; RV32I-SW-SR-NEXT:  .LBB1_2: # %if.end
; RV32I-SW-SR-NEXT:    addi sp, s0, -16
; RV32I-SW-SR-NEXT:    tail __riscv_restore_1
;
; RV64I-SW-LABEL: conditional_alloca:
; RV64I-SW:       # %bb.0:
; RV64I-SW-NEXT:    addi sp, sp, -16
; RV64I-SW-NEXT:    sd ra, 8(sp) # 8-byte Folded Spill
; RV64I-SW-NEXT:    sd s0, 0(sp) # 8-byte Folded Spill
; RV64I-SW-NEXT:    addi s0, sp, 16
; RV64I-SW-NEXT:    sext.w a1, a0
; RV64I-SW-NEXT:    li a2, 32
; RV64I-SW-NEXT:    bltu a2, a1, .LBB1_2
; RV64I-SW-NEXT:  # %bb.1: # %if.then
; RV64I-SW-NEXT:    slli a0, a0, 32
; RV64I-SW-NEXT:    srli a0, a0, 32
; RV64I-SW-NEXT:    addi a0, a0, 15
; RV64I-SW-NEXT:    andi a0, a0, -16
; RV64I-SW-NEXT:    sub a0, sp, a0
; RV64I-SW-NEXT:    mv sp, a0
; RV64I-SW-NEXT:    call notdead@plt
; RV64I-SW-NEXT:  .LBB1_2: # %if.end
; RV64I-SW-NEXT:    addi sp, s0, -16
; RV64I-SW-NEXT:    ld ra, 8(sp) # 8-byte Folded Reload
; RV64I-SW-NEXT:    ld s0, 0(sp) # 8-byte Folded Reload
; RV64I-SW-NEXT:    addi sp, sp, 16
; RV64I-SW-NEXT:    ret
  %cmp = icmp ule i32 %n, 32
  br i1 %cmp, label %if.then, label %if.end

if.then:
  %addr = alloca i8, i32 %n
  call void @notdead(i8* %addr)
  br label %if.end

if.end:
  ret void
}
