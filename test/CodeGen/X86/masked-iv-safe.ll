; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s --implicit-check-not '{{and|movz|sar|shl}}'

; Optimize away zext-inreg and sext-inreg on the loop induction
; variable using trip-count information.

define void @count_up(double* %d, i64 %n) nounwind {
; CHECK-LABEL: count_up:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq $-80, %rax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB0_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, 80(%rdi,%rax)
; CHECK-NEXT:    addq $8, %rax
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 0, %entry ], [ %indvar.next, %loop ]
	%indvar.i8 = and i64 %indvar, 255
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%indvar.i24 = and i64 %indvar, 16777215
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = add i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 10
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @count_down(double* %d, i64 %n) nounwind {
; CHECK-LABEL: count_down:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $80, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB1_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax)
; CHECK-NEXT:    addq $-8, %rax
; CHECK-NEXT:    jne .LBB1_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 10, %entry ], [ %indvar.next, %loop ]
	%indvar.i8 = and i64 %indvar, 255
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%indvar.i24 = and i64 %indvar, 16777215
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = sub i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 0
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @count_up_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: count_up_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq $-80, %rax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB2_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, 80(%rdi,%rax)
; CHECK-NEXT:    addq $8, %rax
; CHECK-NEXT:    jne .LBB2_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 0, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
	%indvar.i8 = ashr i64 %s0, 8
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%s1 = shl i64 %indvar, 24
	%indvar.i24 = ashr i64 %s1, 24
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = add i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 10
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @count_down_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: count_down_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $80, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB3_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax)
; CHECK-NEXT:    addq $-8, %rax
; CHECK-NEXT:    jne .LBB3_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 10, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
	%indvar.i8 = ashr i64 %s0, 8
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%s1 = shl i64 %indvar, 24
	%indvar.i24 = ashr i64 %s1, 24
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = sub i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 0
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @another_count_up(double* %d, i64 %n) nounwind {
; CHECK-LABEL: another_count_up:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq $-8, %rax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB4_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, 2048(%rdi,%rax)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, 134217728(%rdi,%rax)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax)
; CHECK-NEXT:    addq $8, %rax
; CHECK-NEXT:    jne .LBB4_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 18446744073709551615, %entry ], [ %indvar.next, %loop ]
	%indvar.i8 = and i64 %indvar, 255
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%indvar.i24 = and i64 %indvar, 16777215
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fmul double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = add i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 0
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @another_count_down(double* %d, i64 %n) nounwind {
; CHECK-LABEL: another_count_down:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq $-2040, %rax # imm = 0xF808
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    movq %rdi, %rcx
; CHECK-NEXT:    movq %rdi, %rdx
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB5_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    movsd %xmm3, 2040(%rdi,%rax)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    divsd %xmm1, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rcx)
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdx)
; CHECK-NEXT:    addq $-8, %rdx
; CHECK-NEXT:    addq $134217720, %rcx # imm = 0x7FFFFF8
; CHECK-NEXT:    addq $2040, %rax # imm = 0x7F8
; CHECK-NEXT:    jne .LBB5_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 0, %entry ], [ %indvar.next, %loop ]
	%indvar.i8 = and i64 %indvar, 255
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%indvar.i24 = and i64 %indvar, 16777215
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fdiv double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = sub i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 18446744073709551615
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @another_count_up_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: another_count_up_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movq $-8, %rax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB6_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    divsd %xmm1, %xmm3
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, (%rdi,%rax)
; CHECK-NEXT:    addq $8, %rax
; CHECK-NEXT:    jne .LBB6_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 18446744073709551615, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
	%indvar.i8 = ashr i64 %s0, 8
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%s1 = shl i64 %indvar, 24
	%indvar.i24 = ashr i64 %s1, 24
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fdiv double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = add i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 0
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}

define void @another_count_down_signed(double* %d, i64 %n) nounwind {
; CHECK-LABEL: another_count_down_signed:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl $8, %eax
; CHECK-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; CHECK-NEXT:    movsd {{.*#+}} xmm2 = mem[0],zero
; CHECK-NEXT:    .p2align 4, 0x90
; CHECK-NEXT:  .LBB7_1: # %loop
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movsd {{.*#+}} xmm3 = mem[0],zero
; CHECK-NEXT:    mulsd %xmm0, %xmm3
; CHECK-NEXT:    divsd %xmm1, %xmm3
; CHECK-NEXT:    mulsd %xmm2, %xmm3
; CHECK-NEXT:    movsd %xmm3, -8(%rdi,%rax)
; CHECK-NEXT:    addq $-8, %rax
; CHECK-NEXT:    jne .LBB7_1
; CHECK-NEXT:  # %bb.2: # %return
; CHECK-NEXT:    retq
entry:
	br label %loop

loop:
	%indvar = phi i64 [ 0, %entry ], [ %indvar.next, %loop ]
        %s0 = shl i64 %indvar, 8
	%indvar.i8 = ashr i64 %s0, 8
	%t0 = getelementptr double, double* %d, i64 %indvar.i8
	%t1 = load double, double* %t0
	%t2 = fmul double %t1, 0.1
	store double %t2, double* %t0
	%s1 = shl i64 %indvar, 24
	%indvar.i24 = ashr i64 %s1, 24
	%t3 = getelementptr double, double* %d, i64 %indvar.i24
	%t4 = load double, double* %t3
	%t5 = fdiv double %t4, 2.3
	store double %t5, double* %t3
	%t6 = getelementptr double, double* %d, i64 %indvar
	%t7 = load double, double* %t6
	%t8 = fmul double %t7, 4.5
	store double %t8, double* %t6
	%indvar.next = sub i64 %indvar, 1
	%exitcond = icmp eq i64 %indvar.next, 18446744073709551615
	br i1 %exitcond, label %return, label %loop

return:
	ret void
}
