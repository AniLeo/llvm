# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2               -resource-pressure=false < %s | FileCheck --check-prefix=ALL --check-prefix=DEFAULT %s
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=0 -resource-pressure=false < %s | FileCheck --check-prefix=ALL --check-prefix=DEFAULT %s
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -iterations=1 -resource-pressure=false < %s | FileCheck --check-prefix=ALL --check-prefix=CUSTOM %s

add %eax, %eax

# CUSTOM:      Iterations:     1
# CUSTOM-NEXT: Instructions:   1
# CUSTOM-NEXT: Total Cycles:   4
# CUSTOM-NEXT: Dispatch Width: 2
# CUSTOM-NEXT: IPC:            0.25

# DEFAULT:      Iterations:     100
# DEFAULT-NEXT: Instructions:   100
# DEFAULT-NEXT: Total Cycles:   103
# DEFAULT-NEXT: Dispatch Width: 2
# DEFAULT-NEXT: IPC:            0.97

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects

# ALL:      [1]    [2]    [3]    [4]    [5]    [6]	Instructions:
# ALL-NEXT:  1      1     0.50                    	addl	%eax, %eax

