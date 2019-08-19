# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake -instruction-tables < %s | FileCheck %s

cmpxchg8b  (%rax)
cmpxchg16b (%rax)
lock cmpxchg8b  (%rax)
lock cmpxchg16b (%rax)

cmpxchgb  %bl, %cl
cmpxchgw  %bx, %cx
cmpxchgl  %ebx, %ecx
cmpxchgq  %rbx, %rcx

cmpxchgb  %bl, (%rsi)
cmpxchgw  %bx, (%rsi)
cmpxchgl  %ebx, (%rsi)
cmpxchgq  %rbx, (%rsi)

lock cmpxchgb  %bl, (%rsi)
lock cmpxchgw  %bx, (%rsi)
lock cmpxchgl  %ebx, (%rsi)
lock cmpxchgq  %rbx, (%rsi)

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects (U)

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  14     16    2.75    *      *            cmpxchg8b	(%rax)
# CHECK-NEXT:  19     23    4.00    *      *            cmpxchg16b	(%rax)
# CHECK-NEXT:  14     16    2.75    *      *            lock		cmpxchg8b	(%rax)
# CHECK-NEXT:  19     23    4.00    *      *            lock		cmpxchg16b	(%rax)
# CHECK-NEXT:  5      5     1.25                        cmpxchgb	%bl, %cl
# CHECK-NEXT:  5      5     1.25                        cmpxchgw	%bx, %cx
# CHECK-NEXT:  5      5     1.25                        cmpxchgl	%ebx, %ecx
# CHECK-NEXT:  5      5     1.25                        cmpxchgq	%rbx, %rcx
# CHECK-NEXT:  6      8     1.00    *      *            cmpxchgb	%bl, (%rsi)
# CHECK-NEXT:  6      8     1.00    *      *            cmpxchgw	%bx, (%rsi)
# CHECK-NEXT:  6      8     1.00    *      *            cmpxchgl	%ebx, (%rsi)
# CHECK-NEXT:  6      8     1.00    *      *            cmpxchgq	%rbx, (%rsi)
# CHECK-NEXT:  6      8     1.00    *      *            lock		cmpxchgb	%bl, (%rsi)
# CHECK-NEXT:  6      8     1.00    *      *            lock		cmpxchgw	%bx, (%rsi)
# CHECK-NEXT:  6      8     1.00    *      *            lock		cmpxchgl	%ebx, (%rsi)
# CHECK-NEXT:  6      8     1.00    *      *            lock		cmpxchgq	%rbx, (%rsi)

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SKLDivider
# CHECK-NEXT: [1]   - SKLFPDivider
# CHECK-NEXT: [2]   - SKLPort0
# CHECK-NEXT: [3]   - SKLPort1
# CHECK-NEXT: [4]   - SKLPort2
# CHECK-NEXT: [5]   - SKLPort3
# CHECK-NEXT: [6]   - SKLPort4
# CHECK-NEXT: [7]   - SKLPort5
# CHECK-NEXT: [8]   - SKLPort6
# CHECK-NEXT: [9]   - SKLPort7

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
# CHECK-NEXT:  -      -     34.50  12.50  10.00  10.00  12.00  20.50  30.50  4.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    Instructions:
# CHECK-NEXT:  -      -     3.25   2.25   0.83   0.83   1.00   2.25   3.25   0.33   cmpxchg8b	(%rax)
# CHECK-NEXT:  -      -     5.50   1.50   0.83   0.83   1.00   5.50   3.50   0.33   cmpxchg16b	(%rax)
# CHECK-NEXT:  -      -     3.25   2.25   0.83   0.83   1.00   2.25   3.25   0.33   lock		cmpxchg8b	(%rax)
# CHECK-NEXT:  -      -     5.50   1.50   0.83   0.83   1.00   5.50   3.50   0.33   lock		cmpxchg16b	(%rax)
# CHECK-NEXT:  -      -     1.75   0.75    -      -      -     0.75   1.75    -     cmpxchgb	%bl, %cl
# CHECK-NEXT:  -      -     1.75   0.75    -      -      -     0.75   1.75    -     cmpxchgw	%bx, %cx
# CHECK-NEXT:  -      -     1.75   0.75    -      -      -     0.75   1.75    -     cmpxchgl	%ebx, %ecx
# CHECK-NEXT:  -      -     1.75   0.75    -      -      -     0.75   1.75    -     cmpxchgq	%rbx, %rcx
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   cmpxchgb	%bl, (%rsi)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   cmpxchgw	%bx, (%rsi)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   cmpxchgl	%ebx, (%rsi)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   cmpxchgq	%rbx, (%rsi)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   lock		cmpxchgb	%bl, (%rsi)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   lock		cmpxchgw	%bx, (%rsi)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   lock		cmpxchgl	%ebx, (%rsi)
# CHECK-NEXT:  -      -     1.25   0.25   0.83   0.83   1.00   0.25   1.25   0.33   lock		cmpxchgq	%rbx, (%rsi)
