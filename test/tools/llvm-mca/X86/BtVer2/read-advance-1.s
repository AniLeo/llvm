# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s

# The vmul can start executing 3cy in advance. That is beause the first use
# operand (i.e. %xmm1) is a ReadAfterLd. That means, the memory operand is
# evaluated before %xmm1.


vaddps  %xmm0, %xmm0, %xmm1
vmulps  (%rdi), %xmm1, %xmm2


# CHECK:      Iterations:     1
# CHECK-NEXT: Instructions:   2
# CHECK-NEXT: Total Cycles:   10
# CHECK-NEXT: Dispatch Width: 2


# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]	Instructions:
# CHECK-NEXT:  1      3     1.00                    	vaddps	%xmm0, %xmm0, %xmm1
# CHECK-NEXT:  1      7     1.00    *               	vmulps	(%rdi), %xmm1, %xmm2


# CHECK:      Timeline view:

# CHECK:      Index	0123456789
# CHECK:      [0,0]	DeeeER   .	vaddps	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: [0,1]	DeeeeeeeER	vmulps	(%rdi), %xmm1, %xmm2


# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0  	vaddps	%xmm0, %xmm0, %xmm1
# CHECK-NEXT: 1.     1     1.0    0.0    0.0  	vmulps	(%rdi), %xmm1, %xmm2
