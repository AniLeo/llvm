; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Without list-burr scheduling we may not see the difference in codegen here.
; Use a subtarget that has post-RA scheduling enabled because the anti-dependency
; breaker requires liveness information to be kept.
; RUN: llc < %s -mtriple=x86_64-- -mcpu=atom -enable-misched=false -post-RA-scheduler -pre-RA-sched=list-burr -break-anti-dependencies=none | FileCheck %s --check-prefix=none
; RUN: llc < %s -mtriple=x86_64-- -mcpu=atom -post-RA-scheduler -break-anti-dependencies=critical | FileCheck %s --check-prefix=critical

define void @goo(double* %r, double* %p, double* %q) nounwind {
; none-LABEL: goo:
; none:       # %bb.0: # %entry
; none-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; none-NEXT:    addsd {{.*}}(%rip), %xmm0
; none-NEXT:    mulsd {{.*}}(%rip), %xmm0
; none-NEXT:    addsd {{.*}}(%rip), %xmm0
; none-NEXT:    mulsd {{.*}}(%rip), %xmm0
; none-NEXT:    addsd {{.*}}(%rip), %xmm0
; none-NEXT:    cvttsd2si %xmm0, %eax
; none-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; none-NEXT:    addsd {{.*}}(%rip), %xmm0
; none-NEXT:    mulsd {{.*}}(%rip), %xmm0
; none-NEXT:    addsd {{.*}}(%rip), %xmm0
; none-NEXT:    mulsd {{.*}}(%rip), %xmm0
; none-NEXT:    addsd {{.*}}(%rip), %xmm0
; none-NEXT:    cvttsd2si %xmm0, %ecx
; none-NEXT:    cmpl %eax, %ecx
; none-NEXT:    jge .LBB0_2
; none-NEXT:  # %bb.1: # %bb
; none-NEXT:    movabsq $4621425052621576602, %rax # imm = 0x402299999999999A
; none-NEXT:    movq %rax, (%rdx)
; none-NEXT:  .LBB0_2: # %return
; none-NEXT:    retq
;
; critical-LABEL: goo:
; critical:       # %bb.0: # %entry
; critical-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; critical-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; critical-NEXT:    addsd {{.*}}(%rip), %xmm0
; critical-NEXT:    addsd {{.*}}(%rip), %xmm1
; critical-NEXT:    mulsd {{.*}}(%rip), %xmm0
; critical-NEXT:    mulsd {{.*}}(%rip), %xmm1
; critical-NEXT:    addsd {{.*}}(%rip), %xmm0
; critical-NEXT:    addsd {{.*}}(%rip), %xmm1
; critical-NEXT:    mulsd {{.*}}(%rip), %xmm0
; critical-NEXT:    mulsd {{.*}}(%rip), %xmm1
; critical-NEXT:    addsd {{.*}}(%rip), %xmm0
; critical-NEXT:    addsd {{.*}}(%rip), %xmm1
; critical-NEXT:    cvttsd2si %xmm0, %eax
; critical-NEXT:    cvttsd2si %xmm1, %ecx
; critical-NEXT:    cmpl %ecx, %eax
; critical-NEXT:    jge .LBB0_2
; critical-NEXT:  # %bb.1: # %bb
; critical-NEXT:    movabsq $4621425052621576602, %rax # imm = 0x402299999999999A
; critical-NEXT:    movq %rax, (%rdx)
; critical-NEXT:  .LBB0_2: # %return
; critical-NEXT:    retq
entry:
	%0 = load double, double* %p, align 8
	%1 = fadd double %0, 1.100000e+00
	%2 = fmul double %1, 1.200000e+00
	%3 = fadd double %2, 1.300000e+00
	%4 = fmul double %3, 1.400000e+00
	%5 = fadd double %4, 1.500000e+00
	%6 = fptosi double %5 to i32
	%7 = load double, double* %r, align 8
	%8 = fadd double %7, 7.100000e+00
	%9 = fmul double %8, 7.200000e+00
	%10 = fadd double %9, 7.300000e+00
	%11 = fmul double %10, 7.400000e+00
	%12 = fadd double %11, 7.500000e+00
	%13 = fptosi double %12 to i32
	%14 = icmp slt i32 %6, %13
	br i1 %14, label %bb, label %return

bb:
	store double 9.300000e+00, double* %q, align 8
	ret void

return:
	ret void
}
