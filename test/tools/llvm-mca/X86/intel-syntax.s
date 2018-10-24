# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -resource-pressure=false                       < %s | FileCheck %s -check-prefixes=ALL,INTEL
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -resource-pressure=false -output-asm-variant=0 < %s | FileCheck %s -check-prefixes=ALL,ATT
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=btver2 -resource-pressure=false -output-asm-variant=1 < %s | FileCheck %s -check-prefixes=ALL,INTEL

  .intel_syntax noprefix
  mov	eax, 1
  mov	ebx, 0xff
  imul	esi, edi
  lea	eax, [rsi + rdi]

# ALL:        Iterations:        100
# ALL-NEXT:   Instructions:      400
# ALL-NEXT:   Total Cycles:      305
# ALL-NEXT:   Total uOps:        500

# ALL:        Dispatch Width:    2
# ALL-NEXT:   uOps Per Cycle:    1.64
# ALL-NEXT:   IPC:               1.31
# ALL-NEXT:   Block RThroughput: 2.5

# ALL:        Instruction Info:
# ALL-NEXT:   [1]: #uOps
# ALL-NEXT:   [2]: Latency
# ALL-NEXT:   [3]: RThroughput
# ALL-NEXT:   [4]: MayLoad
# ALL-NEXT:   [5]: MayStore
# ALL-NEXT:   [6]: HasSideEffects (U)

# ALL:        [1]    [2]    [3]    [4]    [5]    [6]    Instructions:

# ATT-NEXT:    1      1     0.50                        movl	$1, %eax
# ATT-NEXT:    1      1     0.50                        movl	$255, %ebx
# ATT-NEXT:    2      3     1.00                        imull	%edi, %esi
# ATT-NEXT:    1      1     0.50                        leal	(%rsi,%rdi), %eax

# INTEL-NEXT:  1      1     0.50                        mov	eax, 1
# INTEL-NEXT:  1      1     0.50                        mov	ebx, 255
# INTEL-NEXT:  2      3     1.00                        imul	esi, edi
# INTEL-NEXT:  1      1     0.50                        lea	eax, [rsi + rdi]
