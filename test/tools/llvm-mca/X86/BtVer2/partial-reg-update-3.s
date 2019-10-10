# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1500 -timeline -timeline-max-iterations=3 < %s | FileCheck %s

# perf stat reports a throughput of 1.00 IPC for this code snippet.

# The ILP is limited by the false dependency on %dx. So, the mov cannot execute
# in parallel with the add.

add %cx, %dx
mov %ax, %dx
xor %bx, %dx

# CHECK:      Iterations:        1500
# CHECK-NEXT: Instructions:      4500
# CHECK-NEXT: Total Cycles:      4503
# CHECK-NEXT: Total uOps:        4500

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               1.00
# CHECK-NEXT: Block RThroughput: 1.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.50                        addw	%cx, %dx
# CHECK-NEXT:  1      1     0.50                        movw	%ax, %dx
# CHECK-NEXT:  1      1     0.50                        xorw	%bx, %dx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - JALU0
# CHECK-NEXT: [1]   - JALU1
# CHECK-NEXT: [2]   - JDiv
# CHECK-NEXT: [3]   - JFPA
# CHECK-NEXT: [4]   - JFPM
# CHECK-NEXT: [5]   - JFPU0
# CHECK-NEXT: [6]   - JFPU1
# CHECK-NEXT: [7]   - JLAGU
# CHECK-NEXT: [8]   - JMul
# CHECK-NEXT: [9]   - JSAGU
# CHECK-NEXT: [10]  - JSTC
# CHECK-NEXT: [11]  - JVALU0
# CHECK-NEXT: [12]  - JVALU1
# CHECK-NEXT: [13]  - JVIMUL

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     addw	%cx, %dx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     movw	%ax, %dx
# CHECK-NEXT: 0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -     xorw	%bx, %dx

# CHECK:      Timeline view:
# CHECK-NEXT:                     01
# CHECK-NEXT: Index     0123456789

# CHECK:      [0,0]     DeER .    ..   addw	%cx, %dx
# CHECK-NEXT: [0,1]     D=eER.    ..   movw	%ax, %dx
# CHECK-NEXT: [0,2]     .D=eER    ..   xorw	%bx, %dx
# CHECK-NEXT: [1,0]     .D==eER   ..   addw	%cx, %dx
# CHECK-NEXT: [1,1]     . D==eER  ..   movw	%ax, %dx
# CHECK-NEXT: [1,2]     . D===eER ..   xorw	%bx, %dx
# CHECK-NEXT: [2,0]     .  D===eER..   addw	%cx, %dx
# CHECK-NEXT: [2,1]     .  D====eER.   movw	%ax, %dx
# CHECK-NEXT: [2,2]     .   D====eER   xorw	%bx, %dx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     3     2.7    0.3    0.0       addw	%cx, %dx
# CHECK-NEXT: 1.     3     3.3    0.0    0.0       movw	%ax, %dx
# CHECK-NEXT: 2.     3     3.7    0.0    0.0       xorw	%bx, %dx
# CHECK-NEXT:        3     3.2    0.1    0.0       <total>
