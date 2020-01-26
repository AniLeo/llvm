# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=haswell -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=HASWELL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=broadwell -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=BDWELL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=SKYLAKE
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver1 -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=ZNVER1
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver2 -iterations=1 -timeline -resource-pressure=false < %s | FileCheck %s -check-prefix=ALL -check-prefix=ZNVER2

add     %edi, %esi
bzhil	%esi, (%rdi), %eax

# ALL:          Iterations:        1
# ALL-NEXT:     Instructions:      2

# BDWELL-NEXT:  Total Cycles:      9
# HASWELL-NEXT: Total Cycles:      9
# SKYLAKE-NEXT: Total Cycles:      9
# ZNVER1-NEXT:  Total Cycles:      8
# ZNVER2-NEXT:  Total Cycles:      8

# ALL-NEXT:     Total uOps:        3

# BDWELL:       Dispatch Width:    4
# BDWELL-NEXT:  uOps Per Cycle:    0.33
# BDWELL-NEXT:  IPC:               0.22
# BDWELL-NEXT:  Block RThroughput: 0.8

# HASWELL:      Dispatch Width:    4
# HASWELL-NEXT: uOps Per Cycle:    0.33
# HASWELL-NEXT: IPC:               0.22
# HASWELL-NEXT: Block RThroughput: 0.8

# SKYLAKE:      Dispatch Width:    6
# SKYLAKE-NEXT: uOps Per Cycle:    0.33
# SKYLAKE-NEXT: IPC:               0.22
# SKYLAKE-NEXT: Block RThroughput: 0.5

# ZNVER1:       Dispatch Width:    4
# ZNVER1-NEXT:  uOps Per Cycle:    0.38
# ZNVER1-NEXT:  IPC:               0.25
# ZNVER1-NEXT:  Block RThroughput: 0.8

# ZNVER2:       Dispatch Width:    4
# ZNVER2-NEXT:  uOps Per Cycle:    0.38
# ZNVER2-NEXT:  IPC:               0.25
# ZNVER2-NEXT:  Block RThroughput: 0.8

# ALL:          Instruction Info:
# ALL-NEXT:     [1]: #uOps
# ALL-NEXT:     [2]: Latency
# ALL-NEXT:     [3]: RThroughput
# ALL-NEXT:     [4]: MayLoad
# ALL-NEXT:     [5]: MayStore
# ALL-NEXT:     [6]: HasSideEffects (U)

# ALL:          [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# ALL-NEXT:      1      1     0.25                        addl	%edi, %esi

# BDWELL-NEXT:   2      6     0.50    *                   bzhil	%esi, (%rdi), %eax
# HASWELL-NEXT:  2      6     0.50    *                   bzhil	%esi, (%rdi), %eax
# SKYLAKE-NEXT:  2      6     0.50    *                   bzhil	%esi, (%rdi), %eax
# ZNVER1-NEXT:   2      5     0.50    *                   bzhil	%esi, (%rdi), %eax
# ZNVER2-NEXT:   2      5     0.33    *                   bzhil	%esi, (%rdi), %eax

# ALL:          Timeline view:

# BDWELL-NEXT:  Index     012345678
# HASWELL-NEXT: Index     012345678
# SKYLAKE-NEXT: Index     012345678
# ZNVER1-NEXT:  Index     01234567
# ZNVER2-NEXT:  Index     01234567

# BDWELL:       [0,0]     DeER .  .   addl	%edi, %esi
# BDWELL-NEXT:  [0,1]     DeeeeeeER   bzhil	%esi, (%rdi), %eax

# HASWELL:      [0,0]     DeER .  .   addl	%edi, %esi
# HASWELL-NEXT: [0,1]     DeeeeeeER   bzhil	%esi, (%rdi), %eax

# SKYLAKE:      [0,0]     DeER .  .   addl	%edi, %esi
# SKYLAKE-NEXT: [0,1]     DeeeeeeER   bzhil	%esi, (%rdi), %eax

# ZNVER1:       [0,0]     DeER . .   addl	%edi, %esi
# ZNVER1-NEXT:  [0,1]     DeeeeeER   bzhil	%esi, (%rdi), %eax

# ZNVER2:       [0,0]     DeER . .   addl	%edi, %esi
# ZNVER2-NEXT:  [0,1]     DeeeeeER   bzhil	%esi, (%rdi), %eax

# ALL:          Average Wait times (based on the timeline view):
# ALL-NEXT:     [0]: Executions
# ALL-NEXT:     [1]: Average time spent waiting in a scheduler's queue
# ALL-NEXT:     [2]: Average time spent waiting in a scheduler's queue while ready
# ALL-NEXT:     [3]: Average time elapsed from WB until retire stage

# ALL:                [0]    [1]    [2]    [3]
# ALL-NEXT:     0.     1     1.0    1.0    0.0       addl	%edi, %esi
# ALL-NEXT:     1.     1     1.0    0.0    0.0       bzhil	%esi, (%rdi), %eax
# ALL-NEXT:            1     1.0    0.5    0.0       <total>
