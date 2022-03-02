; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-none-eabi -mcpu=cortex-a55 -o - %s | FileCheck %s

; Check that stp are not suppressed at minsize.

%T_IN_BLOCK = type [ 2 x { double, { double, double } } ]
declare %T_IN_BLOCK @return_in_block()
@in_block_store = dso_local global %T_IN_BLOCK zeroinitializer, align 8

define void @test_default() uwtable {
; CHECK-LABEL: test_default:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    bl return_in_block
; CHECK-NEXT:    adrp x8, in_block_store
; CHECK-NEXT:    add x8, x8, :lo12:in_block_store
; CHECK-NEXT:    str d0, [x8]
; CHECK-NEXT:    str d1, [x8, #8]
; CHECK-NEXT:    str d2, [x8, #16]
; CHECK-NEXT:    str d3, [x8, #24]
; CHECK-NEXT:    str d4, [x8, #32]
; CHECK-NEXT:    str d5, [x8, #40]
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    .cfi_def_cfa_offset 0
; CHECK-NEXT:    .cfi_restore w30
; CHECK-NEXT:    ret
  %1 = call %T_IN_BLOCK @return_in_block()
  store %T_IN_BLOCK %1, %T_IN_BLOCK* @in_block_store
  ret void
}

define void @test_minsize() minsize uwtable {
; CHECK-LABEL: test_minsize:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    bl return_in_block
; CHECK-NEXT:    adrp x8, in_block_store
; CHECK-NEXT:    add x8, x8, :lo12:in_block_store
; CHECK-NEXT:    stp d0, d1, [x8]
; CHECK-NEXT:    stp d2, d3, [x8, #16]
; CHECK-NEXT:    stp d4, d5, [x8, #32]
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
  %1 = call %T_IN_BLOCK @return_in_block()
  store %T_IN_BLOCK %1, %T_IN_BLOCK* @in_block_store
  ret void
}

define void @test_optsize() optsize uwtable {
; CHECK-LABEL: test_optsize:
; CHECK:       // %bb.0:
; CHECK-NEXT:    str x30, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    .cfi_offset w30, -16
; CHECK-NEXT:    bl return_in_block
; CHECK-NEXT:    adrp x8, in_block_store
; CHECK-NEXT:    add x8, x8, :lo12:in_block_store
; CHECK-NEXT:    stp d0, d1, [x8]
; CHECK-NEXT:    stp d2, d3, [x8, #16]
; CHECK-NEXT:    stp d4, d5, [x8, #32]
; CHECK-NEXT:    ldr x30, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    .cfi_def_cfa_offset 0
; CHECK-NEXT:    .cfi_restore w30
; CHECK-NEXT:    ret
  %1 = call %T_IN_BLOCK @return_in_block()
  store %T_IN_BLOCK %1, %T_IN_BLOCK* @in_block_store
  ret void
}
