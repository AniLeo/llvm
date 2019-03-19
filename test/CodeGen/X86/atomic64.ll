; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -O0 -mtriple=x86_64-- -mcpu=corei7 -verify-machineinstrs | FileCheck %s --check-prefix X64
; RUN: llc < %s -O0 -mtriple=i386-- -mcpu=i486 -verify-machineinstrs | FileCheck %s --check-prefix I486

@sc64 = external global i64
@fsc64 = external global double

define void @atomic_fetch_add64() nounwind {
; X64-LABEL: atomic_fetch_add64:
; X64:       # %bb.0: # %entry
; X64-NEXT:    lock incq {{.*}}(%rip)
; X64-NEXT:    lock addq $3, {{.*}}(%rip)
; X64-NEXT:    movl $5, %eax
; X64-NEXT:    lock xaddq %rax, {{.*}}(%rip)
; X64-NEXT:    lock addq %rax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_add64:
; I486:       # %bb.0: # %entry
; I486-NEXT:    pushl %esi
; I486-NEXT:    subl $48, %esp
; I486-NEXT:    leal sc64, %eax
; I486-NEXT:    movl %esp, %ecx
; I486-NEXT:    movl $2, 12(%ecx)
; I486-NEXT:    movl $0, 8(%ecx)
; I486-NEXT:    movl $1, 4(%ecx)
; I486-NEXT:    movl $sc64, (%ecx)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_add_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $0, 8(%esi)
; I486-NEXT:    movl $3, 4(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_add_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $0, 8(%esi)
; I486-NEXT:    movl $5, 4(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_add_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl %edx, 8(%esi)
; I486-NEXT:    movl %eax, 4(%esi)
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_add_8
; I486-NEXT:    addl $48, %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    retl
entry:
  %t1 = atomicrmw add  i64* @sc64, i64 1 acquire
  %t2 = atomicrmw add  i64* @sc64, i64 3 acquire
  %t3 = atomicrmw add  i64* @sc64, i64 5 acquire
  %t4 = atomicrmw add  i64* @sc64, i64 %t3 acquire
  ret void
}

define void @atomic_fetch_sub64() nounwind {
; X64-LABEL: atomic_fetch_sub64:
; X64:       # %bb.0:
; X64-NEXT:    lock decq {{.*}}(%rip)
; X64-NEXT:    lock subq $3, {{.*}}(%rip)
; X64-NEXT:    movq $-5, %rax
; X64-NEXT:    lock xaddq %rax, {{.*}}(%rip)
; X64-NEXT:    lock subq %rax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_sub64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %esi
; I486-NEXT:    subl $48, %esp
; I486-NEXT:    leal sc64, %eax
; I486-NEXT:    movl %esp, %ecx
; I486-NEXT:    movl $2, 12(%ecx)
; I486-NEXT:    movl $0, 8(%ecx)
; I486-NEXT:    movl $1, 4(%ecx)
; I486-NEXT:    movl $sc64, (%ecx)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_sub_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $0, 8(%esi)
; I486-NEXT:    movl $3, 4(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_sub_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $0, 8(%esi)
; I486-NEXT:    movl $5, 4(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_sub_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl %edx, 8(%esi)
; I486-NEXT:    movl %eax, 4(%esi)
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_sub_8
; I486-NEXT:    addl $48, %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    retl
  %t1 = atomicrmw sub  i64* @sc64, i64 1 acquire
  %t2 = atomicrmw sub  i64* @sc64, i64 3 acquire
  %t3 = atomicrmw sub  i64* @sc64, i64 5 acquire
  %t4 = atomicrmw sub  i64* @sc64, i64 %t3 acquire
  ret void
}

define void @atomic_fetch_and64() nounwind {
; X64-LABEL: atomic_fetch_and64:
; X64:       # %bb.0:
; X64-NEXT:    lock andq $3, {{.*}}(%rip)
; X64-NEXT:    movq sc64, %rax
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:  .LBB2_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    movl %eax, %ecx
; X64-NEXT:    andl $5, %ecx
; X64-NEXT:    # kill: def $rcx killed $ecx
; X64-NEXT:    lock cmpxchgq %rcx, {{.*}}(%rip)
; X64-NEXT:    sete %cl
; X64-NEXT:    testb $1, %cl
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    movq %rcx, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    jne .LBB2_2
; X64-NEXT:    jmp .LBB2_1
; X64-NEXT:  .LBB2_2: # %atomicrmw.end
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    lock andq %rax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_and64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %esi
; I486-NEXT:    subl $36, %esp
; I486-NEXT:    leal sc64, %eax
; I486-NEXT:    movl %esp, %ecx
; I486-NEXT:    movl $2, 12(%ecx)
; I486-NEXT:    movl $0, 8(%ecx)
; I486-NEXT:    movl $3, 4(%ecx)
; I486-NEXT:    movl $sc64, (%ecx)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_and_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $0, 8(%esi)
; I486-NEXT:    movl $5, 4(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_and_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl %edx, 8(%esi)
; I486-NEXT:    movl %eax, 4(%esi)
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_and_8
; I486-NEXT:    addl $36, %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    retl
  %t1 = atomicrmw and  i64* @sc64, i64 3 acquire
  %t2 = atomicrmw and  i64* @sc64, i64 5 acquire
  %t3 = atomicrmw and  i64* @sc64, i64 %t2 acquire
  ret void
}

define void @atomic_fetch_or64() nounwind {
; X64-LABEL: atomic_fetch_or64:
; X64:       # %bb.0:
; X64-NEXT:    lock orq $3, {{.*}}(%rip)
; X64-NEXT:    movq sc64, %rax
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:  .LBB3_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    orq $5, %rcx
; X64-NEXT:    lock cmpxchgq %rcx, {{.*}}(%rip)
; X64-NEXT:    sete %cl
; X64-NEXT:    testb $1, %cl
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    movq %rcx, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    jne .LBB3_2
; X64-NEXT:    jmp .LBB3_1
; X64-NEXT:  .LBB3_2: # %atomicrmw.end
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    lock orq %rax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_or64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %esi
; I486-NEXT:    subl $36, %esp
; I486-NEXT:    leal sc64, %eax
; I486-NEXT:    movl %esp, %ecx
; I486-NEXT:    movl $2, 12(%ecx)
; I486-NEXT:    movl $0, 8(%ecx)
; I486-NEXT:    movl $3, 4(%ecx)
; I486-NEXT:    movl $sc64, (%ecx)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_or_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $0, 8(%esi)
; I486-NEXT:    movl $5, 4(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_or_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl %edx, 8(%esi)
; I486-NEXT:    movl %eax, 4(%esi)
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_or_8
; I486-NEXT:    addl $36, %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    retl
  %t1 = atomicrmw or   i64* @sc64, i64 3 acquire
  %t2 = atomicrmw or   i64* @sc64, i64 5 acquire
  %t3 = atomicrmw or   i64* @sc64, i64 %t2 acquire
  ret void
}

define void @atomic_fetch_xor64() nounwind {
; X64-LABEL: atomic_fetch_xor64:
; X64:       # %bb.0:
; X64-NEXT:    lock xorq $3, {{.*}}(%rip)
; X64-NEXT:    movq sc64, %rax
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:  .LBB4_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    xorq $5, %rcx
; X64-NEXT:    lock cmpxchgq %rcx, {{.*}}(%rip)
; X64-NEXT:    sete %cl
; X64-NEXT:    testb $1, %cl
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    movq %rcx, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    jne .LBB4_2
; X64-NEXT:    jmp .LBB4_1
; X64-NEXT:  .LBB4_2: # %atomicrmw.end
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    lock xorq %rax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_xor64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %esi
; I486-NEXT:    subl $36, %esp
; I486-NEXT:    leal sc64, %eax
; I486-NEXT:    movl %esp, %ecx
; I486-NEXT:    movl $2, 12(%ecx)
; I486-NEXT:    movl $0, 8(%ecx)
; I486-NEXT:    movl $3, 4(%ecx)
; I486-NEXT:    movl $sc64, (%ecx)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_xor_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $0, 8(%esi)
; I486-NEXT:    movl $5, 4(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_xor_8
; I486-NEXT:    leal sc64, %ecx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl %edx, 8(%esi)
; I486-NEXT:    movl %eax, 4(%esi)
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_xor_8
; I486-NEXT:    addl $36, %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    retl
  %t1 = atomicrmw xor  i64* @sc64, i64 3 acquire
  %t2 = atomicrmw xor  i64* @sc64, i64 5 acquire
  %t3 = atomicrmw xor  i64* @sc64, i64 %t2 acquire
  ret void
}

define void @atomic_fetch_nand64(i64 %x) nounwind {
; X64-LABEL: atomic_fetch_nand64:
; X64:       # %bb.0:
; X64-NEXT:    movq sc64, %rax
; X64-NEXT:    movq %rdi, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:  .LBB5_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rdx # 8-byte Reload
; X64-NEXT:    andq %rdx, %rcx
; X64-NEXT:    notq %rcx
; X64-NEXT:    lock cmpxchgq %rcx, {{.*}}(%rip)
; X64-NEXT:    sete %cl
; X64-NEXT:    testb $1, %cl
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    jne .LBB5_2
; X64-NEXT:    jmp .LBB5_1
; X64-NEXT:  .LBB5_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_nand64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %esi
; I486-NEXT:    subl $20, %esp
; I486-NEXT:    movl {{[0-9]+}}(%esp), %eax
; I486-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; I486-NEXT:    leal sc64, %edx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl %eax, 8(%esi)
; I486-NEXT:    movl %ecx, 4(%esi)
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_fetch_nand_8
; I486-NEXT:    addl $20, %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    retl
  %t1 = atomicrmw nand i64* @sc64, i64 %x acquire
  ret void
}

define void @atomic_fetch_max64(i64 %x) nounwind {
; X64-LABEL: atomic_fetch_max64:
; X64:       # %bb.0:
; X64-NEXT:    movq sc64, %rax
; X64-NEXT:    movq %rdi, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:  .LBB6_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rdx # 8-byte Reload
; X64-NEXT:    subq %rdx, %rcx
; X64-NEXT:    cmovgeq %rax, %rdx
; X64-NEXT:    lock cmpxchgq %rdx, {{.*}}(%rip)
; X64-NEXT:    sete %dl
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rcx, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    jne .LBB6_2
; X64-NEXT:    jmp .LBB6_1
; X64-NEXT:  .LBB6_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_max64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %ebp
; I486-NEXT:    movl %esp, %ebp
; I486-NEXT:    pushl %ebx
; I486-NEXT:    pushl %edi
; I486-NEXT:    pushl %esi
; I486-NEXT:    andl $-8, %esp
; I486-NEXT:    subl $72, %esp
; I486-NEXT:    movl 12(%ebp), %eax
; I486-NEXT:    movl 8(%ebp), %ecx
; I486-NEXT:    movl sc64+4, %edx
; I486-NEXT:    movl sc64, %esi
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    jmp .LBB6_1
; I486-NEXT:  .LBB6_1: # %atomicrmw.start
; I486-NEXT:    # =>This Inner Loop Header: Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl %ecx, %edx
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; I486-NEXT:    subl %esi, %edx
; I486-NEXT:    movl %eax, %edi
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ebx # 4-byte Reload
; I486-NEXT:    sbbl %ebx, %edi
; I486-NEXT:    movl %ecx, %esi
; I486-NEXT:    movl %eax, %ebx
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ebx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    jge .LBB6_4
; I486-NEXT:  # %bb.3: # %atomicrmw.start
; I486-NEXT:    # in Loop: Header=BB6_1 Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:  .LBB6_4: # %atomicrmw.start
; I486-NEXT:    # in Loop: Header=BB6_1 Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; I486-NEXT:    movl %edx, {{[0-9]+}}(%esp)
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; I486-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; I486-NEXT:    movl %esp, %edi
; I486-NEXT:    movl %eax, 12(%edi)
; I486-NEXT:    movl %ecx, 8(%edi)
; I486-NEXT:    leal {{[0-9]+}}(%esp), %eax
; I486-NEXT:    movl %eax, 4(%edi)
; I486-NEXT:    movl $2, 20(%edi)
; I486-NEXT:    movl $2, 16(%edi)
; I486-NEXT:    movl $sc64, (%edi)
; I486-NEXT:    calll __atomic_compare_exchange_8
; I486-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; I486-NEXT:    movl {{[0-9]+}}(%esp), %edx
; I486-NEXT:    testb %al, %al
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    je .LBB6_1
; I486-NEXT:    jmp .LBB6_2
; I486-NEXT:  .LBB6_2: # %atomicrmw.end
; I486-NEXT:    leal -12(%ebp), %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    popl %edi
; I486-NEXT:    popl %ebx
; I486-NEXT:    popl %ebp
; I486-NEXT:    retl
  %t1 = atomicrmw max  i64* @sc64, i64 %x acquire

  ret void
}

define void @atomic_fetch_min64(i64 %x) nounwind {
; X64-LABEL: atomic_fetch_min64:
; X64:       # %bb.0:
; X64-NEXT:    movq sc64, %rax
; X64-NEXT:    movq %rdi, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:  .LBB7_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rdx # 8-byte Reload
; X64-NEXT:    subq %rdx, %rcx
; X64-NEXT:    cmovleq %rax, %rdx
; X64-NEXT:    lock cmpxchgq %rdx, {{.*}}(%rip)
; X64-NEXT:    sete %dl
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rcx, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    jne .LBB7_2
; X64-NEXT:    jmp .LBB7_1
; X64-NEXT:  .LBB7_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_min64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %ebp
; I486-NEXT:    movl %esp, %ebp
; I486-NEXT:    pushl %ebx
; I486-NEXT:    pushl %edi
; I486-NEXT:    pushl %esi
; I486-NEXT:    andl $-8, %esp
; I486-NEXT:    subl $72, %esp
; I486-NEXT:    movl 12(%ebp), %eax
; I486-NEXT:    movl 8(%ebp), %ecx
; I486-NEXT:    movl sc64+4, %edx
; I486-NEXT:    movl sc64, %esi
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    jmp .LBB7_1
; I486-NEXT:  .LBB7_1: # %atomicrmw.start
; I486-NEXT:    # =>This Inner Loop Header: Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; I486-NEXT:    subl %ecx, %edx
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; I486-NEXT:    sbbl %eax, %esi
; I486-NEXT:    movl %ecx, %edi
; I486-NEXT:    movl %eax, %ebx
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ebx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    jge .LBB7_4
; I486-NEXT:  # %bb.3: # %atomicrmw.start
; I486-NEXT:    # in Loop: Header=BB7_1 Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:  .LBB7_4: # %atomicrmw.start
; I486-NEXT:    # in Loop: Header=BB7_1 Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; I486-NEXT:    movl %edx, {{[0-9]+}}(%esp)
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; I486-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; I486-NEXT:    movl %esp, %edi
; I486-NEXT:    movl %eax, 12(%edi)
; I486-NEXT:    movl %ecx, 8(%edi)
; I486-NEXT:    leal {{[0-9]+}}(%esp), %eax
; I486-NEXT:    movl %eax, 4(%edi)
; I486-NEXT:    movl $2, 20(%edi)
; I486-NEXT:    movl $2, 16(%edi)
; I486-NEXT:    movl $sc64, (%edi)
; I486-NEXT:    calll __atomic_compare_exchange_8
; I486-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; I486-NEXT:    movl {{[0-9]+}}(%esp), %edx
; I486-NEXT:    testb %al, %al
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    je .LBB7_1
; I486-NEXT:    jmp .LBB7_2
; I486-NEXT:  .LBB7_2: # %atomicrmw.end
; I486-NEXT:    leal -12(%ebp), %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    popl %edi
; I486-NEXT:    popl %ebx
; I486-NEXT:    popl %ebp
; I486-NEXT:    retl
  %t1 = atomicrmw min  i64* @sc64, i64 %x acquire

  ret void
}

define void @atomic_fetch_umax64(i64 %x) nounwind {
; X64-LABEL: atomic_fetch_umax64:
; X64:       # %bb.0:
; X64-NEXT:    movq sc64, %rax
; X64-NEXT:    movq %rdi, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:  .LBB8_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rdx # 8-byte Reload
; X64-NEXT:    subq %rdx, %rcx
; X64-NEXT:    cmovaq %rax, %rdx
; X64-NEXT:    lock cmpxchgq %rdx, {{.*}}(%rip)
; X64-NEXT:    sete %dl
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rcx, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    jne .LBB8_2
; X64-NEXT:    jmp .LBB8_1
; X64-NEXT:  .LBB8_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_umax64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %ebp
; I486-NEXT:    movl %esp, %ebp
; I486-NEXT:    pushl %ebx
; I486-NEXT:    pushl %edi
; I486-NEXT:    pushl %esi
; I486-NEXT:    andl $-8, %esp
; I486-NEXT:    subl $72, %esp
; I486-NEXT:    movl 12(%ebp), %eax
; I486-NEXT:    movl 8(%ebp), %ecx
; I486-NEXT:    movl sc64+4, %edx
; I486-NEXT:    movl sc64, %esi
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    jmp .LBB8_1
; I486-NEXT:  .LBB8_1: # %atomicrmw.start
; I486-NEXT:    # =>This Inner Loop Header: Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; I486-NEXT:    subl %ecx, %edx
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; I486-NEXT:    sbbl %eax, %esi
; I486-NEXT:    movl %ecx, %edi
; I486-NEXT:    movl %eax, %ebx
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ebx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    jb .LBB8_4
; I486-NEXT:  # %bb.3: # %atomicrmw.start
; I486-NEXT:    # in Loop: Header=BB8_1 Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:  .LBB8_4: # %atomicrmw.start
; I486-NEXT:    # in Loop: Header=BB8_1 Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; I486-NEXT:    movl %edx, {{[0-9]+}}(%esp)
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; I486-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; I486-NEXT:    movl %esp, %edi
; I486-NEXT:    movl %eax, 12(%edi)
; I486-NEXT:    movl %ecx, 8(%edi)
; I486-NEXT:    leal {{[0-9]+}}(%esp), %eax
; I486-NEXT:    movl %eax, 4(%edi)
; I486-NEXT:    movl $2, 20(%edi)
; I486-NEXT:    movl $2, 16(%edi)
; I486-NEXT:    movl $sc64, (%edi)
; I486-NEXT:    calll __atomic_compare_exchange_8
; I486-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; I486-NEXT:    movl {{[0-9]+}}(%esp), %edx
; I486-NEXT:    testb %al, %al
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    je .LBB8_1
; I486-NEXT:    jmp .LBB8_2
; I486-NEXT:  .LBB8_2: # %atomicrmw.end
; I486-NEXT:    leal -12(%ebp), %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    popl %edi
; I486-NEXT:    popl %ebx
; I486-NEXT:    popl %ebp
; I486-NEXT:    retl
  %t1 = atomicrmw umax i64* @sc64, i64 %x acquire

  ret void
}

define void @atomic_fetch_umin64(i64 %x) nounwind {
; X64-LABEL: atomic_fetch_umin64:
; X64:       # %bb.0:
; X64-NEXT:    movq sc64, %rax
; X64-NEXT:    movq %rdi, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:  .LBB9_1: # %atomicrmw.start
; X64-NEXT:    # =>This Inner Loop Header: Depth=1
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; X64-NEXT:    movq %rax, %rcx
; X64-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rdx # 8-byte Reload
; X64-NEXT:    subq %rdx, %rcx
; X64-NEXT:    cmovbeq %rax, %rdx
; X64-NEXT:    lock cmpxchgq %rdx, {{.*}}(%rip)
; X64-NEXT:    sete %dl
; X64-NEXT:    testb $1, %dl
; X64-NEXT:    movq %rax, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    movq %rcx, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; X64-NEXT:    jne .LBB9_2
; X64-NEXT:    jmp .LBB9_1
; X64-NEXT:  .LBB9_2: # %atomicrmw.end
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_umin64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %ebp
; I486-NEXT:    movl %esp, %ebp
; I486-NEXT:    pushl %ebx
; I486-NEXT:    pushl %edi
; I486-NEXT:    pushl %esi
; I486-NEXT:    andl $-8, %esp
; I486-NEXT:    subl $72, %esp
; I486-NEXT:    movl 12(%ebp), %eax
; I486-NEXT:    movl 8(%ebp), %ecx
; I486-NEXT:    movl sc64+4, %edx
; I486-NEXT:    movl sc64, %esi
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %esi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    jmp .LBB9_1
; I486-NEXT:  .LBB9_1: # %atomicrmw.start
; I486-NEXT:    # =>This Inner Loop Header: Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; I486-NEXT:    subl %ecx, %edx
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; I486-NEXT:    sbbl %eax, %esi
; I486-NEXT:    movl %ecx, %edi
; I486-NEXT:    movl %eax, %ebx
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edi, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ebx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    jae .LBB9_4
; I486-NEXT:  # %bb.3: # %atomicrmw.start
; I486-NEXT:    # in Loop: Header=BB9_1 Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:  .LBB9_4: # %atomicrmw.start
; I486-NEXT:    # in Loop: Header=BB9_1 Depth=1
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %ecx # 4-byte Reload
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %edx # 4-byte Reload
; I486-NEXT:    movl %edx, {{[0-9]+}}(%esp)
; I486-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %esi # 4-byte Reload
; I486-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; I486-NEXT:    movl %esp, %edi
; I486-NEXT:    movl %eax, 12(%edi)
; I486-NEXT:    movl %ecx, 8(%edi)
; I486-NEXT:    leal {{[0-9]+}}(%esp), %eax
; I486-NEXT:    movl %eax, 4(%edi)
; I486-NEXT:    movl $2, 20(%edi)
; I486-NEXT:    movl $2, 16(%edi)
; I486-NEXT:    movl $sc64, (%edi)
; I486-NEXT:    calll __atomic_compare_exchange_8
; I486-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; I486-NEXT:    movl {{[0-9]+}}(%esp), %edx
; I486-NEXT:    testb %al, %al
; I486-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    je .LBB9_1
; I486-NEXT:    jmp .LBB9_2
; I486-NEXT:  .LBB9_2: # %atomicrmw.end
; I486-NEXT:    leal -12(%ebp), %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    popl %edi
; I486-NEXT:    popl %ebx
; I486-NEXT:    popl %ebp
; I486-NEXT:    retl
  %t1 = atomicrmw umin i64* @sc64, i64 %x acquire

  ret void
}

define void @atomic_fetch_cmpxchg64() nounwind {
; X64-LABEL: atomic_fetch_cmpxchg64:
; X64:       # %bb.0:
; X64-NEXT:    xorl %eax, %eax
; X64-NEXT:    # kill: def $rax killed $eax
; X64-NEXT:    movl $1, %ecx
; X64-NEXT:    lock cmpxchgq %rcx, {{.*}}(%rip)
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_cmpxchg64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %ebp
; I486-NEXT:    movl %esp, %ebp
; I486-NEXT:    andl $-8, %esp
; I486-NEXT:    subl $40, %esp
; I486-NEXT:    leal sc64, %eax
; I486-NEXT:    leal {{[0-9]+}}(%esp), %ecx
; I486-NEXT:    movl $0, {{[0-9]+}}(%esp)
; I486-NEXT:    movl $0, {{[0-9]+}}(%esp)
; I486-NEXT:    movl %esp, %edx
; I486-NEXT:    movl %ecx, 4(%edx)
; I486-NEXT:    movl $2, 20(%edx)
; I486-NEXT:    movl $2, 16(%edx)
; I486-NEXT:    movl $0, 12(%edx)
; I486-NEXT:    movl $1, 8(%edx)
; I486-NEXT:    movl $sc64, (%edx)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_compare_exchange_8
; I486-NEXT:    movl %ebp, %esp
; I486-NEXT:    popl %ebp
; I486-NEXT:    retl
  %t1 = cmpxchg i64* @sc64, i64 0, i64 1 acquire acquire
  ret void
}

define void @atomic_fetch_store64(i64 %x) nounwind {
; X64-LABEL: atomic_fetch_store64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, {{.*}}(%rip)
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_store64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %esi
; I486-NEXT:    subl $20, %esp
; I486-NEXT:    movl {{[0-9]+}}(%esp), %eax
; I486-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; I486-NEXT:    leal sc64, %edx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl %eax, 8(%esi)
; I486-NEXT:    movl %ecx, 4(%esi)
; I486-NEXT:    movl $3, 12(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_store_8
; I486-NEXT:    addl $20, %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    retl
  store atomic i64 %x, i64* @sc64 release, align 8
  ret void
}

define void @atomic_fetch_swap64(i64 %x) nounwind {
; X64-LABEL: atomic_fetch_swap64:
; X64:       # %bb.0:
; X64-NEXT:    xchgq %rdi, {{.*}}(%rip)
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_swap64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %esi
; I486-NEXT:    subl $20, %esp
; I486-NEXT:    movl {{[0-9]+}}(%esp), %eax
; I486-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; I486-NEXT:    leal sc64, %edx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl %eax, 8(%esi)
; I486-NEXT:    movl %ecx, 4(%esi)
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $sc64, (%esi)
; I486-NEXT:    movl %edx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_exchange_8
; I486-NEXT:    addl $20, %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    retl
  %t1 = atomicrmw xchg i64* @sc64, i64 %x acquire
  ret void
}

define void @atomic_fetch_swapf64(double %x) nounwind {
; X64-LABEL: atomic_fetch_swapf64:
; X64:       # %bb.0:
; X64-NEXT:    movq %xmm0, %rax
; X64-NEXT:    xchgq %rax, {{.*}}(%rip)
; X64-NEXT:    retq
;
; I486-LABEL: atomic_fetch_swapf64:
; I486:       # %bb.0:
; I486-NEXT:    pushl %ebp
; I486-NEXT:    movl %esp, %ebp
; I486-NEXT:    pushl %esi
; I486-NEXT:    andl $-8, %esp
; I486-NEXT:    subl $40, %esp
; I486-NEXT:    fldl 8(%ebp)
; I486-NEXT:    leal fsc64, %eax
; I486-NEXT:    fstpl {{[0-9]+}}(%esp)
; I486-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; I486-NEXT:    movl {{[0-9]+}}(%esp), %edx
; I486-NEXT:    movl %esp, %esi
; I486-NEXT:    movl %edx, 8(%esi)
; I486-NEXT:    movl %ecx, 4(%esi)
; I486-NEXT:    movl $2, 12(%esi)
; I486-NEXT:    movl $fsc64, (%esi)
; I486-NEXT:    movl %eax, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; I486-NEXT:    calll __atomic_exchange_8
; I486-NEXT:    leal -4(%ebp), %esp
; I486-NEXT:    popl %esi
; I486-NEXT:    popl %ebp
; I486-NEXT:    retl
  %t1 = atomicrmw xchg double* @fsc64, double %x acquire
  ret void
}
