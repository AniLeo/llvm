# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -mtriple=x86_64-unknown-unknown -mcpu=skylake-avx512 -instruction-tables < %s | FileCheck %s

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
# CHECK-NEXT:  1      1     0.50                        adcxl	%ebx, %ecx
# CHECK-NEXT:  2      6     0.50    *                   adcxl	(%rbx), %ecx
# CHECK-NEXT:  1      1     0.50                        adcxq	%rbx, %rcx
# CHECK-NEXT:  2      6     0.50    *                   adcxq	(%rbx), %rcx
# CHECK-NEXT:  1      1     0.50                        adoxl	%ebx, %ecx
# CHECK-NEXT:  2      6     0.50    *                   adoxl	(%rbx), %ecx
# CHECK-NEXT:  1      1     0.50                        adoxq	%rbx, %rcx
# CHECK-NEXT:  2      6     0.50    *                   adoxq	(%rbx), %rcx

# CHECK:      Resources:
# CHECK-NEXT: [0]   - SKXDivider
# CHECK-NEXT: [1]   - SKXFPDivider
# CHECK-NEXT: [2]   - SKXPort0
# CHECK-NEXT: [3]   - SKXPort1
# CHECK-NEXT: [4]   - SKXPort2
# CHECK-NEXT: [5]   - SKXPort3
# CHECK-NEXT: [6]   - SKXPort4
# CHECK-NEXT: [7]   - SKXPort5
# CHECK-NEXT: [8]   - SKXPort6
# CHECK-NEXT: [9]   - SKXPort7

# CHECK:      Resource pressure per iteration:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]
# CHECK-NEXT:  -      -     4.00    -     2.00   2.00    -      -     4.00    -

# CHECK:      Resource pressure by instruction:
# CHECK-NEXT: [0]    [1]    [2]    [3]    [4]    [5]    [6]    [7]    [8]    [9]    Instructions:
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     adcxl	%ebx, %ecx
# CHECK-NEXT:  -      -     0.50    -     0.50   0.50    -      -     0.50    -     adcxl	(%rbx), %ecx
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     adcxq	%rbx, %rcx
# CHECK-NEXT:  -      -     0.50    -     0.50   0.50    -      -     0.50    -     adcxq	(%rbx), %rcx
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     adoxl	%ebx, %ecx
# CHECK-NEXT:  -      -     0.50    -     0.50   0.50    -      -     0.50    -     adoxl	(%rbx), %ecx
# CHECK-NEXT:  -      -     0.50    -      -      -      -      -     0.50    -     adoxq	%rbx, %rcx
# CHECK-NEXT:  -      -     0.50    -     0.50   0.50    -      -     0.50    -     adoxq	(%rbx), %rcx
