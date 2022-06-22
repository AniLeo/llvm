; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-- < %s | FileCheck %s
@sc8 = external dso_local global i8

define void @atomic_maxmin_i8() {
; CHECK-LABEL: atomic_maxmin_i8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movb sc8(%rip), %al
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %atomicrmw.start
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpb $6, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    movl $5, %ecx
; CHECK-NEXT:    cmovgel %eax, %ecx
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    lock cmpxchgb %cl, sc8(%rip)
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %atomicrmw.end
; CHECK-NEXT:    movb sc8(%rip), %al
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_3: # %atomicrmw.start2
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpb $7, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    movl $6, %ecx
; CHECK-NEXT:    cmovll %eax, %ecx
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    lock cmpxchgb %cl, sc8(%rip)
; CHECK-NEXT:    jne .LBB0_3
; CHECK-NEXT:  # %bb.4: # %atomicrmw.end1
; CHECK-NEXT:    movb sc8(%rip), %al
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_5: # %atomicrmw.start8
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpb $8, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    movl $7, %ecx
; CHECK-NEXT:    cmovael %eax, %ecx
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    lock cmpxchgb %cl, sc8(%rip)
; CHECK-NEXT:    jne .LBB0_5
; CHECK-NEXT:  # %bb.6: # %atomicrmw.end7
; CHECK-NEXT:    movb sc8(%rip), %al
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_7: # %atomicrmw.start14
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    cmpb $9, %al
; CHECK-NEXT:    movzbl %al, %eax
; CHECK-NEXT:    movl $8, %ecx
; CHECK-NEXT:    cmovbl %eax, %ecx
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    lock cmpxchgb %cl, sc8(%rip)
; CHECK-NEXT:    jne .LBB0_7
; CHECK-NEXT:  # %bb.8: # %atomicrmw.end13
; CHECK-NEXT:    retq
  %1 = atomicrmw max  ptr @sc8, i8 5 acquire
  %2 = atomicrmw min  ptr @sc8, i8 6 acquire
  %3 = atomicrmw umax ptr @sc8, i8 7 acquire
  %4 = atomicrmw umin ptr @sc8, i8 8 acquire
  ret void
}
