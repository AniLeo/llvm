# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=2 -timeline < %s | FileCheck %s

# LLVM-MCA-BEGIN
xadd %ecx, (%rsp)
add %ecx, %ecx
add %ecx, %ecx
imul %ecx, %ecx
imul %ecx, %ecx
# LLVM-MCA-END

# LLVM-MCA-BEGIN
lock xadd %ecx, (%rsp)
add %ecx, %ecx
add %ecx, %ecx
imul %ecx, %ecx
imul %ecx, %ecx
# LLVM-MCA-END

# CHECK:      [0] Code Region

# CHECK:      Iterations:        2
# CHECK-NEXT: Instructions:      10
# CHECK-NEXT: Total Cycles:      24
# CHECK-NEXT: Total uOps:        16

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.67
# CHECK-NEXT: IPC:               0.42
# CHECK-NEXT: Block RThroughput: 4.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  4      11    1.50    *      *            xaddl	%ecx, (%rsp)
# CHECK-NEXT:  1      1     0.50                        addl	%ecx, %ecx
# CHECK-NEXT:  1      1     0.50                        addl	%ecx, %ecx
# CHECK-NEXT:  1      3     1.00                        imull	%ecx, %ecx
# CHECK-NEXT:  1      3     1.00                        imull	%ecx, %ecx

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
# CHECK-NEXT: 2.50   4.50    -      -      -      -      -     1.00   2.00   1.00    -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -     1.00    -     1.00    -      -      -      -     xaddl	%ecx, (%rsp)
# CHECK-NEXT: 1.00    -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%ecx, %ecx
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -      -      -      -      -      -      -     addl	%ecx, %ecx
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     1.00    -      -      -      -      -     imull	%ecx, %ecx
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     1.00    -      -      -      -      -     imull	%ecx, %ecx

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          0123

# CHECK:      [0,0]     DeeeeeeeeeeeER .    .  .   xaddl	%ecx, (%rsp)
# CHECK-NEXT: [0,1]     . D=eE-------R .    .  .   addl	%ecx, %ecx
# CHECK-NEXT: [0,2]     . D==eE-------R.    .  .   addl	%ecx, %ecx
# CHECK-NEXT: [0,3]     .  D==eeeE----R.    .  .   imull	%ecx, %ecx
# CHECK-NEXT: [0,4]     .  D=====eeeE--R    .  .   imull	%ecx, %ecx
# CHECK-NEXT: [1,0]     .   D====eeeeeeeeeeeER .   xaddl	%ecx, (%rsp)
# CHECK-NEXT: [1,1]     .    .D=====eE-------R .   addl	%ecx, %ecx
# CHECK-NEXT: [1,2]     .    .D======eE-------R.   addl	%ecx, %ecx
# CHECK-NEXT: [1,3]     .    . D======eeeE----R.   imull	%ecx, %ecx
# CHECK-NEXT: [1,4]     .    . D=========eeeE--R   imull	%ecx, %ecx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     3.0    0.5    0.0       xaddl	%ecx, (%rsp)
# CHECK-NEXT: 1.     2     4.0    0.0    7.0       addl	%ecx, %ecx
# CHECK-NEXT: 2.     2     5.0    0.0    7.0       addl	%ecx, %ecx
# CHECK-NEXT: 3.     2     5.0    0.0    4.0       imull	%ecx, %ecx
# CHECK-NEXT: 4.     2     8.0    0.0    2.0       imull	%ecx, %ecx
# CHECK-NEXT:        2     5.0    0.1    4.0       <total>

# CHECK:      [1] Code Region

# CHECK:      Iterations:        2
# CHECK-NEXT: Instructions:      10
# CHECK-NEXT: Total Cycles:      38
# CHECK-NEXT: Total uOps:        16

# CHECK:      Dispatch Width:    2
# CHECK-NEXT: uOps Per Cycle:    0.42
# CHECK-NEXT: IPC:               0.26
# CHECK-NEXT: Block RThroughput: 16.0

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  4      16    16.00   *      *            lock		xaddl	%ecx, (%rsp)
# CHECK-NEXT:  1      1     0.50                        addl	%ecx, %ecx
# CHECK-NEXT:  1      1     0.50                        addl	%ecx, %ecx
# CHECK-NEXT:  1      3     1.00                        imull	%ecx, %ecx
# CHECK-NEXT:  1      3     1.00                        imull	%ecx, %ecx

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
# CHECK-NEXT: 2.50   4.50    -      -      -      -      -     16.00  2.00   16.00   -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12]   [13]   Instructions:
# CHECK-NEXT: 1.50   1.50    -      -      -      -      -     16.00   -     16.00   -      -      -      -     lock		xaddl	%ecx, (%rsp)
# CHECK-NEXT: 1.00    -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%ecx, %ecx
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -      -      -      -      -      -      -     addl	%ecx, %ecx
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     1.00    -      -      -      -      -     imull	%ecx, %ecx
# CHECK-NEXT:  -     1.00    -      -      -      -      -      -     1.00    -      -      -      -      -     imull	%ecx, %ecx

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789          01234567
# CHECK-NEXT: Index     0123456789          0123456789

# CHECK:      [0,0]     DeeeeeeeeeeeeeeeeER .    .    .    . .   lock		xaddl	%ecx, (%rsp)
# CHECK-NEXT: [0,1]     . D=========eE----R .    .    .    . .   addl	%ecx, %ecx
# CHECK-NEXT: [0,2]     . D==========eE----R.    .    .    . .   addl	%ecx, %ecx
# CHECK-NEXT: [0,3]     .  D==========eeeE-R.    .    .    . .   imull	%ecx, %ecx
# CHECK-NEXT: [0,4]     .  D=============eeeER   .    .    . .   imull	%ecx, %ecx
# CHECK-NEXT: [1,0]     .   D============eeeeeeeeeeeeeeeeER. .   lock		xaddl	%ecx, (%rsp)
# CHECK-NEXT: [1,1]     .    .D=====================eE----R. .   addl	%ecx, %ecx
# CHECK-NEXT: [1,2]     .    .D======================eE----R .   addl	%ecx, %ecx
# CHECK-NEXT: [1,3]     .    . D======================eeeE-R .   imull	%ecx, %ecx
# CHECK-NEXT: [1,4]     .    . D=========================eeeER   imull	%ecx, %ecx

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     2     7.0    0.5    0.0       lock		xaddl	%ecx, (%rsp)
# CHECK-NEXT: 1.     2     16.0   0.0    4.0       addl	%ecx, %ecx
# CHECK-NEXT: 2.     2     17.0   0.0    4.0       addl	%ecx, %ecx
# CHECK-NEXT: 3.     2     17.0   0.0    1.0       imull	%ecx, %ecx
# CHECK-NEXT: 4.     2     20.0   0.0    0.0       imull	%ecx, %ecx
# CHECK-NEXT:        2     15.4   0.1    1.8       <total>
