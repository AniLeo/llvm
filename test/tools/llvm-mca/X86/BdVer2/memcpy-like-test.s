# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -iterations=100 -timeline -timeline-max-iterations=1 < %s | FileCheck %s

vmovaps (%rsi), %xmm0
vmovaps %xmm0, (%rdi)
vmovaps 16(%rsi), %xmm0
vmovaps %xmm0, 16(%rdi)
vmovaps 32(%rsi), %xmm0
vmovaps %xmm0, 32(%rdi)
vmovaps 48(%rsi), %xmm0
vmovaps %xmm0, 48(%rdi)

# CHECK:      Iterations:        100
# CHECK-NEXT: Instructions:      800
# CHECK-NEXT: Total Cycles:      409
# CHECK-NEXT: Total uOps:        800

# CHECK:      Dispatch Width:    4
# CHECK-NEXT: uOps Per Cycle:    1.96
# CHECK-NEXT: IPC:               1.96
# CHECK-NEXT: Block RThroughput: 4.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      6     0.50    *                   vmovaps	(%rsi), %xmm0
# CHECK-NEXT:  1      1     1.00           *            vmovaps	%xmm0, (%rdi)
# CHECK-NEXT:  1      6     0.50    *                   vmovaps	16(%rsi), %xmm0
# CHECK-NEXT:  1      1     1.00           *            vmovaps	%xmm0, 16(%rdi)
# CHECK-NEXT:  1      6     0.50    *                   vmovaps	32(%rsi), %xmm0
# CHECK-NEXT:  1      1     1.00           *            vmovaps	%xmm0, 32(%rdi)
# CHECK-NEXT:  1      6     0.50    *                   vmovaps	48(%rsi), %xmm0
# CHECK-NEXT:  1      1     1.00           *            vmovaps	%xmm0, 48(%rdi)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SBDivider
# CHECK-NEXT: [1]   - SBFPDivider
# CHECK-NEXT: [2]   - SBPort0
# CHECK-NEXT: [3]   - SBPort1
# CHECK-NEXT: [4]   - SBPort4
# CHECK-NEXT: [5]   - SBPort5
# CHECK-NEXT: [6.0] - SBPort23
# CHECK-NEXT: [6.1] - SBPort23

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]
# CHECK-NEXT:  -      -      -      -     4.00    -     3.94   4.06

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -      -      -      -      -     0.97   0.03   vmovaps	(%rsi), %xmm0
# CHECK-NEXT:  -      -      -      -     1.00    -      -     1.00   vmovaps	%xmm0, (%rdi)
# CHECK-NEXT:  -      -      -      -      -      -     0.03   0.97   vmovaps	16(%rsi), %xmm0
# CHECK-NEXT:  -      -      -      -     1.00    -     0.97   0.03   vmovaps	%xmm0, 16(%rdi)
# CHECK-NEXT:  -      -      -      -      -      -     1.00    -     vmovaps	32(%rsi), %xmm0
# CHECK-NEXT:  -      -      -      -     1.00    -      -     1.00   vmovaps	%xmm0, 32(%rdi)
# CHECK-NEXT:  -      -      -      -      -      -      -     1.00   vmovaps	48(%rsi), %xmm0
# CHECK-NEXT:  -      -      -      -     1.00    -     0.97   0.03   vmovaps	%xmm0, 48(%rdi)

# CHECK:      Timeline view:
# CHECK-NEXT:                     012
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeeeeeeER . .   vmovaps	(%rsi), %xmm0
# CHECK-NEXT: [0,1]     D======eER. .   vmovaps	%xmm0, (%rdi)
# CHECK-NEXT: [0,2]     DeeeeeeE-R. .   vmovaps	16(%rsi), %xmm0
# CHECK-NEXT: [0,3]     D=======eER .   vmovaps	%xmm0, 16(%rdi)
# CHECK-NEXT: [0,4]     .DeeeeeeE-R .   vmovaps	32(%rsi), %xmm0
# CHECK-NEXT: [0,5]     .D=======eER.   vmovaps	%xmm0, 32(%rdi)
# CHECK-NEXT: [0,6]     .DeeeeeeE--R.   vmovaps	48(%rsi), %xmm0
# CHECK-NEXT: [0,7]     .D========eER   vmovaps	%xmm0, 48(%rdi)

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     1     1.0    1.0    0.0       vmovaps	(%rsi), %xmm0
# CHECK-NEXT: 1.     1     7.0    0.0    0.0       vmovaps	%xmm0, (%rdi)
# CHECK-NEXT: 2.     1     1.0    1.0    1.0       vmovaps	16(%rsi), %xmm0
# CHECK-NEXT: 3.     1     8.0    0.0    0.0       vmovaps	%xmm0, 16(%rdi)
# CHECK-NEXT: 4.     1     1.0    1.0    1.0       vmovaps	32(%rsi), %xmm0
# CHECK-NEXT: 5.     1     8.0    0.0    0.0       vmovaps	%xmm0, 32(%rdi)
# CHECK-NEXT: 6.     1     1.0    1.0    2.0       vmovaps	48(%rsi), %xmm0
# CHECK-NEXT: 7.     1     9.0    0.0    0.0       vmovaps	%xmm0, 48(%rdi)
