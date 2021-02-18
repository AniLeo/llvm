; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -target-abi=ilp32d -mattr=+experimental-v,+experimental-zfh,+f,+d -verify-machineinstrs -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=RV32
; RUN: llc -mtriple=riscv64 -target-abi=lp64d -mattr=+experimental-v,+experimental-zfh,+f,+d -verify-machineinstrs -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefixes=RV64

; FIXME: This codegen needs to be improved. These tests previously asserted in
; ReplaceNodeResults on RV32.

define i64 @extractelt_v4i64(<4 x i64>* %x) nounwind {
; RV32-LABEL: extractelt_v4i64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -64
; RV32-NEXT:    sw ra, 60(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s0, 56(sp) # 4-byte Folded Spill
; RV32-NEXT:    addi s0, sp, 64
; RV32-NEXT:    andi sp, sp, -32
; RV32-NEXT:    addi a1, zero, 8
; RV32-NEXT:    vsetvli a1, a1, e32,m2,ta,mu
; RV32-NEXT:    vle32.v v26, (a0)
; RV32-NEXT:    vse32.v v26, (sp)
; RV32-NEXT:    lw a0, 24(sp)
; RV32-NEXT:    lw a1, 28(sp)
; RV32-NEXT:    addi sp, s0, -64
; RV32-NEXT:    lw s0, 56(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw ra, 60(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 64
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_v4i64:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -64
; RV64-NEXT:    sd ra, 56(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s0, 48(sp) # 8-byte Folded Spill
; RV64-NEXT:    addi s0, sp, 64
; RV64-NEXT:    andi sp, sp, -32
; RV64-NEXT:    addi a1, zero, 4
; RV64-NEXT:    vsetvli a1, a1, e64,m2,ta,mu
; RV64-NEXT:    vle64.v v26, (a0)
; RV64-NEXT:    vse64.v v26, (sp)
; RV64-NEXT:    ld a0, 24(sp)
; RV64-NEXT:    addi sp, s0, -64
; RV64-NEXT:    ld s0, 48(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld ra, 56(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 64
; RV64-NEXT:    ret
  %a = load <4 x i64>, <4 x i64>* %x
  %b = extractelement <4 x i64> %a, i32 3
  ret i64 %b
}

; This uses a non-power of 2 type so that it isn't an MVT to catch an
; incorrect use of getSimpleValueType().
define i64 @extractelt_v3i64(<3 x i64>* %x) nounwind {
; RV32-LABEL: extractelt_v3i64:
; RV32:       # %bb.0:
; RV32-NEXT:    addi sp, sp, -64
; RV32-NEXT:    sw ra, 60(sp) # 4-byte Folded Spill
; RV32-NEXT:    sw s0, 56(sp) # 4-byte Folded Spill
; RV32-NEXT:    addi s0, sp, 64
; RV32-NEXT:    andi sp, sp, -32
; RV32-NEXT:    addi a1, zero, 8
; RV32-NEXT:    vsetvli a1, a1, e32,m2,ta,mu
; RV32-NEXT:    vle32.v v26, (a0)
; RV32-NEXT:    vse32.v v26, (sp)
; RV32-NEXT:    lw a0, 16(sp)
; RV32-NEXT:    lw a1, 20(sp)
; RV32-NEXT:    addi sp, s0, -64
; RV32-NEXT:    lw s0, 56(sp) # 4-byte Folded Reload
; RV32-NEXT:    lw ra, 60(sp) # 4-byte Folded Reload
; RV32-NEXT:    addi sp, sp, 64
; RV32-NEXT:    ret
;
; RV64-LABEL: extractelt_v3i64:
; RV64:       # %bb.0:
; RV64-NEXT:    addi sp, sp, -64
; RV64-NEXT:    sd ra, 56(sp) # 8-byte Folded Spill
; RV64-NEXT:    sd s0, 48(sp) # 8-byte Folded Spill
; RV64-NEXT:    addi s0, sp, 64
; RV64-NEXT:    andi sp, sp, -32
; RV64-NEXT:    addi a1, zero, 4
; RV64-NEXT:    vsetvli a1, a1, e64,m2,ta,mu
; RV64-NEXT:    vle64.v v26, (a0)
; RV64-NEXT:    vse64.v v26, (sp)
; RV64-NEXT:    ld a0, 16(sp)
; RV64-NEXT:    addi sp, s0, -64
; RV64-NEXT:    ld s0, 48(sp) # 8-byte Folded Reload
; RV64-NEXT:    ld ra, 56(sp) # 8-byte Folded Reload
; RV64-NEXT:    addi sp, sp, 64
; RV64-NEXT:    ret
  %a = load <3 x i64>, <3 x i64>* %x
  %b = extractelement <3 x i64> %a, i32 2
  ret i64 %b
}
