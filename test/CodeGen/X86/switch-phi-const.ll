; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc %s -o - -mtriple=x86_64-- | FileCheck %s
@g = global i32 0
@effect = global i32 0

define void @switch_phi_const(i32 %x) {
; CHECK-LABEL: switch_phi_const:
; CHECK:       # %bb.0: # %bb0
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    leal -1(%rdi), %ecx
; CHECK-NEXT:    cmpl $54, %ecx
; CHECK-NEXT:    ja .LBB0_8
; CHECK-NEXT:  # %bb.1: # %bb0
; CHECK-NEXT:    movl $42, %eax
; CHECK-NEXT:    jmpq *.LJTI0_0(,%rcx,8)
; CHECK-NEXT:  .LBB0_2: # %case_7
; CHECK-NEXT:    movq g@GOTPCREL(%rip), %rax
; CHECK-NEXT:    movl (%rax), %edi
; CHECK-NEXT:    movq effect@GOTPCREL(%rip), %rax
; CHECK-NEXT:    movl $7, (%rax)
; CHECK-NEXT:  .LBB0_3: # %case_1_loop
; CHECK-NEXT:    movq effect@GOTPCREL(%rip), %rax
; CHECK-NEXT:    movl $1, (%rax)
; CHECK-NEXT:  .LBB0_4: # %case_5
; CHECK-NEXT:    movq effect@GOTPCREL(%rip), %rax
; CHECK-NEXT:    movl $5, (%rax)
; CHECK-NEXT:  .LBB0_5: # %case_13
; CHECK-NEXT:    movq effect@GOTPCREL(%rip), %rax
; CHECK-NEXT:    movl $13, (%rax)
; CHECK-NEXT:  .LBB0_6: # %case_42
; CHECK-NEXT:    movq effect@GOTPCREL(%rip), %rax
; CHECK-NEXT:    movl %edi, (%rax)
; CHECK-NEXT:    movl $55, %eax
; CHECK-NEXT:  .LBB0_7: # %case_55
; CHECK-NEXT:    movq effect@GOTPCREL(%rip), %rcx
; CHECK-NEXT:    movl %eax, (%rcx)
; CHECK-NEXT:  .LBB0_8: # %default
; CHECK-NEXT:    retq
bb0:
  switch i32 %x, label %default [
  i32 1, label %case_1_loop
  i32 5, label %case_5
  i32 7, label %case_7
  i32 13, label %case_13
  i32 42, label %case_42
  i32 55, label %case_55
  ]

case_1_loop:
  ; We should replace 1 with %x
  %x0 = phi i32 [ 1, %bb0 ], [ %x5, %case_7 ]
  store i32 1, ptr @effect, align 4
  br label %case_5

case_5:
  ; We should replace 5 with %x
  %x1 = phi i32 [ 5, %bb0 ], [ %x0, %case_1_loop ]
  store i32 5, ptr @effect, align 4
  br label %case_13

case_13:
  ; We should replace 13 with %x
  %x2 = phi i32 [ 13, %bb0 ], [ %x1, %case_5 ]
  store i32 13, ptr @effect, align 4
  br label %case_42

case_42:
  ; We should replace 42 with %x
  %x3 = phi i32 [ 42, %bb0 ], [ %x2, %case_13 ]
  store i32 %x3, ptr @effect, align 4
  br label %case_55

case_55:
  ; We must not replace any of the PHI arguments!
  %x4 = phi i32 [ 42, %bb0 ], [ 55, %case_42 ]
  store i32 %x4, ptr @effect, align 4
  br label %default

case_7:
  %x5 = load i32, ptr @g, align 4
  store i32 7, ptr @effect, align 4
  br label %case_1_loop

default:
  ret void
}

@g64 = global i64 0
@effect64 = global i64 0

define void @switch_trunc_phi_const(i32 %x) {
; CHECK-LABEL: switch_trunc_phi_const:
; CHECK:       # %bb.0: # %bb0
; CHECK-NEXT:    # kill: def $edi killed $edi def $rdi
; CHECK-NEXT:    movzbl %dil, %ecx
; CHECK-NEXT:    decl %ecx
; CHECK-NEXT:    cmpl $54, %ecx
; CHECK-NEXT:    ja .LBB1_8
; CHECK-NEXT:  # %bb.1: # %bb0
; CHECK-NEXT:    movzbl %dil, %eax
; CHECK-NEXT:    movl $3895, %edx # imm = 0xF37
; CHECK-NEXT:    jmpq *.LJTI1_0(,%rcx,8)
; CHECK-NEXT:  .LBB1_8: # %default
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB1_2: # %case_1_loop
; CHECK-NEXT:    movq effect64@GOTPCREL(%rip), %rcx
; CHECK-NEXT:    movq $1, (%rcx)
; CHECK-NEXT:  .LBB1_3: # %case_5
; CHECK-NEXT:    movq effect64@GOTPCREL(%rip), %rcx
; CHECK-NEXT:    movq $5, (%rcx)
; CHECK-NEXT:  .LBB1_4: # %case_13
; CHECK-NEXT:    movq effect64@GOTPCREL(%rip), %rcx
; CHECK-NEXT:    movq $13, (%rcx)
; CHECK-NEXT:  .LBB1_5: # %case_42
; CHECK-NEXT:    movq effect64@GOTPCREL(%rip), %rcx
; CHECK-NEXT:    movq %rax, (%rcx)
; CHECK-NEXT:    movl $55, %edx
; CHECK-NEXT:  .LBB1_6: # %case_55
; CHECK-NEXT:    movq effect64@GOTPCREL(%rip), %rax
; CHECK-NEXT:    movq %rdx, (%rax)
; CHECK-NEXT:  .LBB1_7: # %case_7
; CHECK-NEXT:    movq g64@GOTPCREL(%rip), %rax
; CHECK-NEXT:    movq (%rax), %rax
; CHECK-NEXT:    movq effect64@GOTPCREL(%rip), %rcx
; CHECK-NEXT:    movq $7, (%rcx)
; CHECK-NEXT:    jmp .LBB1_2
bb0:
  %x_trunc = trunc i32 %x to i8
  switch i8 %x_trunc, label %default [
  i8 1, label %case_1_loop
  i8 5, label %case_5
  i8 7, label %case_7
  i8 13, label %case_13
  i8 42, label %case_42
  i8 55, label %case_55
  ]

case_1_loop:
  ; We should replace 1 with %x
  %x0 = phi i64 [ 1, %bb0 ], [ %x5, %case_7 ]
  store i64 1, ptr @effect64, align 4
  br label %case_5

case_5:
  ; We should replace 5 with %x
  %x1 = phi i64 [ 5, %bb0 ], [ %x0, %case_1_loop ]
  store i64 5, ptr @effect64, align 4
  br label %case_13

case_13:
  ; We should replace 13 with %x
  %x2 = phi i64 [ 13, %bb0 ], [ %x1, %case_5 ]
  store i64 13, ptr @effect64, align 4
  br label %case_42

case_42:
  ; We should replace 42 with %x
  %x3 = phi i64 [ 42, %bb0 ], [ %x2, %case_13 ]
  store i64 %x3, ptr @effect64, align 4
  br label %case_55

case_55:
  ; We must not replace any of the PHI arguments! (3898 == 0xf00 + 55)
  %x4 = phi i64 [ 3895, %bb0 ], [ 55, %case_42 ]
  store i64 %x4, ptr @effect64, align 4
  br label %case_7

case_7:
  %x5 = load i64, ptr @g64, align 4
  store i64 7, ptr @effect64, align 4
  br label %case_1_loop

default:
  ret void
}
