; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -O0 -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s --check-prefix=GISEL
; RUN: llc -O0 -global-isel=0 -mtriple=aarch64-unknown-linux-gnu < %s | FileCheck %s --check-prefix=SDAG

; Verify that GISel and SDAG do the same thing for this phi (modulo regalloc)
define void @test() nounwind {
; GISEL-LABEL: test:
; GISEL:       // %bb.0: // %entry
; GISEL-NEXT:    sub sp, sp, #16
; GISEL-NEXT:    mov x8, xzr
; GISEL-NEXT:    mov x9, x8
; GISEL-NEXT:    str x9, [sp] // 8-byte Folded Spill
; GISEL-NEXT:    str x8, [sp, #8] // 8-byte Folded Spill
; GISEL-NEXT:    b .LBB0_1
; GISEL-NEXT:  .LBB0_1: // %loop
; GISEL-NEXT:    // =>This Inner Loop Header: Depth=1
; GISEL-NEXT:    ldr x8, [sp, #8] // 8-byte Folded Reload
; GISEL-NEXT:    ldr x9, [sp] // 8-byte Folded Reload
; GISEL-NEXT:    str x9, [sp] // 8-byte Folded Spill
; GISEL-NEXT:    str x8, [sp, #8] // 8-byte Folded Spill
; GISEL-NEXT:    b .LBB0_1
;
; SDAG-LABEL: test:
; SDAG:       // %bb.0: // %entry
; SDAG-NEXT:    sub sp, sp, #16
; SDAG-NEXT:    mov x1, xzr
; SDAG-NEXT:    mov x0, x1
; SDAG-NEXT:    str x1, [sp] // 8-byte Folded Spill
; SDAG-NEXT:    str x0, [sp, #8] // 8-byte Folded Spill
; SDAG-NEXT:    b .LBB0_1
; SDAG-NEXT:  .LBB0_1: // %loop
; SDAG-NEXT:    // =>This Inner Loop Header: Depth=1
; SDAG-NEXT:    ldr x0, [sp, #8] // 8-byte Folded Reload
; SDAG-NEXT:    ldr x1, [sp] // 8-byte Folded Reload
; SDAG-NEXT:    str x1, [sp] // 8-byte Folded Spill
; SDAG-NEXT:    str x0, [sp, #8] // 8-byte Folded Spill
; SDAG-NEXT:    b .LBB0_1
entry:
  br label %loop

loop:
  %p = phi i72 [ 0, %entry ], [ %p, %loop ]
  br label %loop
}
