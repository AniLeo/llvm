# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=znver3 -timeline -register-file-stats -iterations=500 < %s | FileCheck %s

# LLVM-MCA-BEGIN
xorl %eax, %eax
addl %eax, %eax
# LLVM-MCA-END

# LLVM-MCA-BEGIN
xorq %rax, %rax
addq %rax, %rax
# LLVM-MCA-END

# LLVM-MCA-BEGIN
subl %eax, %eax
addl %eax, %eax
# LLVM-MCA-END

# LLVM-MCA-BEGIN
subq %rax, %rax
addq %rax, %rax
# LLVM-MCA-END

# CHECK:      [0] Code Region

# CHECK:      Iterations:        500
# CHECK-NEXT: Instructions:      1000
# CHECK-NEXT: Total Cycles:      1003
# CHECK-NEXT: Total uOps:        1000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               1.00
# CHECK-NEXT: Block RThroughput: 0.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.25                        xorl	%eax, %eax
# CHECK-NEXT:  1      1     0.25                        addl	%eax, %eax

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    2000
# CHECK-NEXT: Max number of mappings used:         192

# CHECK:      *  Register File #1 -- Zn3FpPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      *  Register File #2 -- Zn3IntegerPRF:
# CHECK-NEXT:    Number of physical registers:     192
# CHECK-NEXT:    Total number of mappings created: 2000
# CHECK-NEXT:    Max number of mappings used:      192

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -     0.50    -     0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     xorl	%eax, %eax
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%eax, %eax

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          012

# CHECK:      [0,0]     DeER .    .    .    . .   xorl	%eax, %eax
# CHECK-NEXT: [0,1]     D=eER.    .    .    . .   addl	%eax, %eax
# CHECK-NEXT: [1,0]     D==eER    .    .    . .   xorl	%eax, %eax
# CHECK-NEXT: [1,1]     D===eER   .    .    . .   addl	%eax, %eax
# CHECK-NEXT: [2,0]     D====eER  .    .    . .   xorl	%eax, %eax
# CHECK-NEXT: [2,1]     D=====eER .    .    . .   addl	%eax, %eax
# CHECK-NEXT: [3,0]     .D=====eER.    .    . .   xorl	%eax, %eax
# CHECK-NEXT: [3,1]     .D======eER    .    . .   addl	%eax, %eax
# CHECK-NEXT: [4,0]     .D=======eER   .    . .   xorl	%eax, %eax
# CHECK-NEXT: [4,1]     .D========eER  .    . .   addl	%eax, %eax
# CHECK-NEXT: [5,0]     .D=========eER .    . .   xorl	%eax, %eax
# CHECK-NEXT: [5,1]     .D==========eER.    . .   addl	%eax, %eax
# CHECK-NEXT: [6,0]     . D==========eER    . .   xorl	%eax, %eax
# CHECK-NEXT: [6,1]     . D===========eER   . .   addl	%eax, %eax
# CHECK-NEXT: [7,0]     . D============eER  . .   xorl	%eax, %eax
# CHECK-NEXT: [7,1]     . D=============eER . .   addl	%eax, %eax
# CHECK-NEXT: [8,0]     . D==============eER. .   xorl	%eax, %eax
# CHECK-NEXT: [8,1]     . D===============eER .   addl	%eax, %eax
# CHECK-NEXT: [9,0]     .  D===============eER.   xorl	%eax, %eax
# CHECK-NEXT: [9,1]     .  D================eER   addl	%eax, %eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     10    8.8    0.1    0.0       xorl	%eax, %eax
# CHECK-NEXT: 1.     10    9.8    0.0    0.0       addl	%eax, %eax
# CHECK-NEXT:        10    9.3    0.1    0.0       <total>

# CHECK:      [1] Code Region

# CHECK:      Iterations:        500
# CHECK-NEXT: Instructions:      1000
# CHECK-NEXT: Total Cycles:      1003
# CHECK-NEXT: Total uOps:        1000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               1.00
# CHECK-NEXT: Block RThroughput: 0.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.25                        xorq	%rax, %rax
# CHECK-NEXT:  1      1     0.25                        addq	%rax, %rax

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    2000
# CHECK-NEXT: Max number of mappings used:         192

# CHECK:      *  Register File #1 -- Zn3FpPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      *  Register File #2 -- Zn3IntegerPRF:
# CHECK-NEXT:    Number of physical registers:     192
# CHECK-NEXT:    Total number of mappings created: 2000
# CHECK-NEXT:    Max number of mappings used:      192

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -     0.50    -     0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     xorq	%rax, %rax
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     addq	%rax, %rax

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          012

# CHECK:      [0,0]     DeER .    .    .    . .   xorq	%rax, %rax
# CHECK-NEXT: [0,1]     D=eER.    .    .    . .   addq	%rax, %rax
# CHECK-NEXT: [1,0]     D==eER    .    .    . .   xorq	%rax, %rax
# CHECK-NEXT: [1,1]     D===eER   .    .    . .   addq	%rax, %rax
# CHECK-NEXT: [2,0]     D====eER  .    .    . .   xorq	%rax, %rax
# CHECK-NEXT: [2,1]     D=====eER .    .    . .   addq	%rax, %rax
# CHECK-NEXT: [3,0]     .D=====eER.    .    . .   xorq	%rax, %rax
# CHECK-NEXT: [3,1]     .D======eER    .    . .   addq	%rax, %rax
# CHECK-NEXT: [4,0]     .D=======eER   .    . .   xorq	%rax, %rax
# CHECK-NEXT: [4,1]     .D========eER  .    . .   addq	%rax, %rax
# CHECK-NEXT: [5,0]     .D=========eER .    . .   xorq	%rax, %rax
# CHECK-NEXT: [5,1]     .D==========eER.    . .   addq	%rax, %rax
# CHECK-NEXT: [6,0]     . D==========eER    . .   xorq	%rax, %rax
# CHECK-NEXT: [6,1]     . D===========eER   . .   addq	%rax, %rax
# CHECK-NEXT: [7,0]     . D============eER  . .   xorq	%rax, %rax
# CHECK-NEXT: [7,1]     . D=============eER . .   addq	%rax, %rax
# CHECK-NEXT: [8,0]     . D==============eER. .   xorq	%rax, %rax
# CHECK-NEXT: [8,1]     . D===============eER .   addq	%rax, %rax
# CHECK-NEXT: [9,0]     .  D===============eER.   xorq	%rax, %rax
# CHECK-NEXT: [9,1]     .  D================eER   addq	%rax, %rax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     10    8.8    0.1    0.0       xorq	%rax, %rax
# CHECK-NEXT: 1.     10    9.8    0.0    0.0       addq	%rax, %rax
# CHECK-NEXT:        10    9.3    0.1    0.0       <total>

# CHECK:      [2] Code Region

# CHECK:      Iterations:        500
# CHECK-NEXT: Instructions:      1000
# CHECK-NEXT: Total Cycles:      1003
# CHECK-NEXT: Total uOps:        1000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               1.00
# CHECK-NEXT: Block RThroughput: 0.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.25                        subl	%eax, %eax
# CHECK-NEXT:  1      1     0.25                        addl	%eax, %eax

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    2000
# CHECK-NEXT: Max number of mappings used:         192

# CHECK:      *  Register File #1 -- Zn3FpPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      *  Register File #2 -- Zn3IntegerPRF:
# CHECK-NEXT:    Number of physical registers:     192
# CHECK-NEXT:    Total number of mappings created: 2000
# CHECK-NEXT:    Max number of mappings used:      192

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -     0.50    -     0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     subl	%eax, %eax
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     addl	%eax, %eax

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          012

# CHECK:      [0,0]     DeER .    .    .    . .   subl	%eax, %eax
# CHECK-NEXT: [0,1]     D=eER.    .    .    . .   addl	%eax, %eax
# CHECK-NEXT: [1,0]     D==eER    .    .    . .   subl	%eax, %eax
# CHECK-NEXT: [1,1]     D===eER   .    .    . .   addl	%eax, %eax
# CHECK-NEXT: [2,0]     D====eER  .    .    . .   subl	%eax, %eax
# CHECK-NEXT: [2,1]     D=====eER .    .    . .   addl	%eax, %eax
# CHECK-NEXT: [3,0]     .D=====eER.    .    . .   subl	%eax, %eax
# CHECK-NEXT: [3,1]     .D======eER    .    . .   addl	%eax, %eax
# CHECK-NEXT: [4,0]     .D=======eER   .    . .   subl	%eax, %eax
# CHECK-NEXT: [4,1]     .D========eER  .    . .   addl	%eax, %eax
# CHECK-NEXT: [5,0]     .D=========eER .    . .   subl	%eax, %eax
# CHECK-NEXT: [5,1]     .D==========eER.    . .   addl	%eax, %eax
# CHECK-NEXT: [6,0]     . D==========eER    . .   subl	%eax, %eax
# CHECK-NEXT: [6,1]     . D===========eER   . .   addl	%eax, %eax
# CHECK-NEXT: [7,0]     . D============eER  . .   subl	%eax, %eax
# CHECK-NEXT: [7,1]     . D=============eER . .   addl	%eax, %eax
# CHECK-NEXT: [8,0]     . D==============eER. .   subl	%eax, %eax
# CHECK-NEXT: [8,1]     . D===============eER .   addl	%eax, %eax
# CHECK-NEXT: [9,0]     .  D===============eER.   subl	%eax, %eax
# CHECK-NEXT: [9,1]     .  D================eER   addl	%eax, %eax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     10    8.8    0.1    0.0       subl	%eax, %eax
# CHECK-NEXT: 1.     10    9.8    0.0    0.0       addl	%eax, %eax
# CHECK-NEXT:        10    9.3    0.1    0.0       <total>

# CHECK:      [3] Code Region

# CHECK:      Iterations:        500
# CHECK-NEXT: Instructions:      1000
# CHECK-NEXT: Total Cycles:      1003
# CHECK-NEXT: Total uOps:        1000

# CHECK:      Dispatch Width:    6
# CHECK-NEXT: uOps Per Cycle:    1.00
# CHECK-NEXT: IPC:               1.00
# CHECK-NEXT: Block RThroughput: 0.5

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  1      1     0.25                        subq	%rax, %rax
# CHECK-NEXT:  1      1     0.25                        addq	%rax, %rax

# CHECK:      Register File statistics:
# CHECK-NEXT: Total number of mappings created:    2000
# CHECK-NEXT: Max number of mappings used:         192

# CHECK:      *  Register File #1 -- Zn3FpPRF:
# CHECK-NEXT:    Number of physical registers:     160
# CHECK-NEXT:    Total number of mappings created: 0
# CHECK-NEXT:    Max number of mappings used:      0

# CHECK:      *  Register File #2 -- Zn3IntegerPRF:
# CHECK-NEXT:    Number of physical registers:     192
# CHECK-NEXT:    Total number of mappings created: 2000
# CHECK-NEXT:    Max number of mappings used:      192

# CHECK:      Resources:
# CHECK-NEXT: [0]   - Zn3AGU0
# CHECK-NEXT: [1]   - Zn3AGU1
# CHECK-NEXT: [2]   - Zn3AGU2
# CHECK-NEXT: [3]   - Zn3ALU0
# CHECK-NEXT: [4]   - Zn3ALU1
# CHECK-NEXT: [5]   - Zn3ALU2
# CHECK-NEXT: [6]   - Zn3ALU3
# CHECK-NEXT: [7]   - Zn3BRU1
# CHECK-NEXT: [8]   - Zn3FPP0
# CHECK-NEXT: [9]   - Zn3FPP1
# CHECK-NEXT: [10]  - Zn3FPP2
# CHECK-NEXT: [11]  - Zn3FPP3
# CHECK-NEXT: [12.0] - Zn3FPP45
# CHECK-NEXT: [12.1] - Zn3FPP45
# CHECK-NEXT: [13]  - Zn3FPSt
# CHECK-NEXT: [14.0] - Zn3LSU
# CHECK-NEXT: [14.1] - Zn3LSU
# CHECK-NEXT: [14.2] - Zn3LSU
# CHECK-NEXT: [15.0] - Zn3Load
# CHECK-NEXT: [15.1] - Zn3Load
# CHECK-NEXT: [15.2] - Zn3Load
# CHECK-NEXT: [16.0] - Zn3Store
# CHECK-NEXT: [16.1] - Zn3Store

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1]
# CHECK-NEXT:  -      -      -     0.50   0.50   0.50   0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    [10]   [11]   [12.0] [12.1] [13]   [14.0] [14.1] [14.2] [15.0] [15.1] [15.2] [16.0] [16.1] Instructions:
# CHECK-NEXT:  -      -      -      -     0.50    -     0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     subq	%rax, %rax
# CHECK-NEXT:  -      -      -     0.50    -     0.50    -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -      -     addq	%rax, %rax

# CHECK:      Timeline view:
# CHECK-NEXT:                     0123456789
# CHECK-NEXT: Index     0123456789          012

# CHECK:      [0,0]     DeER .    .    .    . .   subq	%rax, %rax
# CHECK-NEXT: [0,1]     D=eER.    .    .    . .   addq	%rax, %rax
# CHECK-NEXT: [1,0]     D==eER    .    .    . .   subq	%rax, %rax
# CHECK-NEXT: [1,1]     D===eER   .    .    . .   addq	%rax, %rax
# CHECK-NEXT: [2,0]     D====eER  .    .    . .   subq	%rax, %rax
# CHECK-NEXT: [2,1]     D=====eER .    .    . .   addq	%rax, %rax
# CHECK-NEXT: [3,0]     .D=====eER.    .    . .   subq	%rax, %rax
# CHECK-NEXT: [3,1]     .D======eER    .    . .   addq	%rax, %rax
# CHECK-NEXT: [4,0]     .D=======eER   .    . .   subq	%rax, %rax
# CHECK-NEXT: [4,1]     .D========eER  .    . .   addq	%rax, %rax
# CHECK-NEXT: [5,0]     .D=========eER .    . .   subq	%rax, %rax
# CHECK-NEXT: [5,1]     .D==========eER.    . .   addq	%rax, %rax
# CHECK-NEXT: [6,0]     . D==========eER    . .   subq	%rax, %rax
# CHECK-NEXT: [6,1]     . D===========eER   . .   addq	%rax, %rax
# CHECK-NEXT: [7,0]     . D============eER  . .   subq	%rax, %rax
# CHECK-NEXT: [7,1]     . D=============eER . .   addq	%rax, %rax
# CHECK-NEXT: [8,0]     . D==============eER. .   subq	%rax, %rax
# CHECK-NEXT: [8,1]     . D===============eER .   addq	%rax, %rax
# CHECK-NEXT: [9,0]     .  D===============eER.   subq	%rax, %rax
# CHECK-NEXT: [9,1]     .  D================eER   addq	%rax, %rax

# CHECK:      Average Wait times (based on the timeline view):
# CHECK-NEXT: [0]: Executions
# CHECK-NEXT: [1]: Average time spent waiting in a scheduler's queue
# CHECK-NEXT: [2]: Average time spent waiting in a scheduler's queue while ready
# CHECK-NEXT: [3]: Average time elapsed from WB until retire stage

# CHECK:            [0]    [1]    [2]    [3]
# CHECK-NEXT: 0.     10    8.8    0.1    0.0       subq	%rax, %rax
# CHECK-NEXT: 1.     10    9.8    0.0    0.0       addq	%rax, %rax
# CHECK-NEXT:        10    9.3    0.1    0.0       <total>
