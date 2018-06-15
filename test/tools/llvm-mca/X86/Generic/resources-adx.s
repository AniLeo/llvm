# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=x86-64 -instruction-tables < %s | FileCheck %s

adcx        %ebx, %ecx
adcx        (%rbx), %ecx
adcx        %rbx, %rcx
adcx        (%rbx), %rcx

adox        %ebx, %ecx
adox        (%rbx), %ecx
adox        %rbx, %rcx
adox        (%rbx), %rcx

# CHECK:      Instruction Info:
# CHECK-NEXT: [1]: #uOps
# CHECK-NEXT: [2]: Latency
# CHECK-NEXT: [3]: RThroughput
# CHECK-NEXT: [4]: MayLoad
# CHECK-NEXT: [5]: MayStore
# CHECK-NEXT: [6]: HasSideEffects

# CHECK:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:
# CHECK-NEXT:  2      2     0.67                        adcxl	%ebx, %ecx
# CHECK-NEXT:  3      7     0.67    *                   adcxl	(%rbx), %ecx
# CHECK-NEXT:  2      2     0.67                        adcxq	%rbx, %rcx
# CHECK-NEXT:  3      7     0.67    *                   adcxq	(%rbx), %rcx
# CHECK-NEXT:  2      2     0.67                        adoxl	%ebx, %ecx
# CHECK-NEXT:  3      7     0.67    *                   adoxl	(%rbx), %ecx
# CHECK-NEXT:  2      2     0.67                        adoxq	%rbx, %rcx
# CHECK-NEXT:  3      7     0.67    *                   adoxq	(%rbx), %rcx

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
# CHECK-NEXT:  -      -     6.67   2.67    -     6.67   2.00   2.00

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6.0]  [6.1]  Instructions:
# CHECK-NEXT:  -      -     0.83   0.33    -     0.83    -      -     adcxl	%ebx, %ecx
# CHECK-NEXT:  -      -     0.83   0.33    -     0.83   0.50   0.50   adcxl	(%rbx), %ecx
# CHECK-NEXT:  -      -     0.83   0.33    -     0.83    -      -     adcxq	%rbx, %rcx
# CHECK-NEXT:  -      -     0.83   0.33    -     0.83   0.50   0.50   adcxq	(%rbx), %rcx
# CHECK-NEXT:  -      -     0.83   0.33    -     0.83    -      -     adoxl	%ebx, %ecx
# CHECK-NEXT:  -      -     0.83   0.33    -     0.83   0.50   0.50   adoxl	(%rbx), %ecx
# CHECK-NEXT:  -      -     0.83   0.33    -     0.83    -      -     adoxq	%rbx, %rcx
# CHECK-NEXT:  -      -     0.83   0.33    -     0.83   0.50   0.50   adoxq	(%rbx), %rcx
