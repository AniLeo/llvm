; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mcpu=corei7 -mtriple=i686-- -verify-machineinstrs | FileCheck %s --check-prefix=CHECK --check-prefix=SSE42
; RUN: llc < %s -mtriple=i686-- -verify-machineinstrs | FileCheck %s --check-prefix=CHECK --check-prefix=NOSSE

; 64-bit load/store on x86-32
; FIXME: The generated code can be substantially improved.

define void @test1(ptr %ptr, i64 %val1) {
; SSE42-LABEL: test1:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE42-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; SSE42-NEXT:    movlps %xmm0, (%eax)
; SSE42-NEXT:    lock orl $0, (%esp)
; SSE42-NEXT:    retl
;
; NOSSE-LABEL: test1:
; NOSSE:       # %bb.0:
; NOSSE-NEXT:    pushl %ebp
; NOSSE-NEXT:    .cfi_def_cfa_offset 8
; NOSSE-NEXT:    .cfi_offset %ebp, -8
; NOSSE-NEXT:    movl %esp, %ebp
; NOSSE-NEXT:    .cfi_def_cfa_register %ebp
; NOSSE-NEXT:    andl $-8, %esp
; NOSSE-NEXT:    subl $8, %esp
; NOSSE-NEXT:    movl 8(%ebp), %eax
; NOSSE-NEXT:    movl 12(%ebp), %ecx
; NOSSE-NEXT:    movl 16(%ebp), %edx
; NOSSE-NEXT:    movl %edx, {{[0-9]+}}(%esp)
; NOSSE-NEXT:    movl %ecx, (%esp)
; NOSSE-NEXT:    fildll (%esp)
; NOSSE-NEXT:    fistpll (%eax)
; NOSSE-NEXT:    lock orl $0, (%esp)
; NOSSE-NEXT:    movl %ebp, %esp
; NOSSE-NEXT:    popl %ebp
; NOSSE-NEXT:    .cfi_def_cfa %esp, 4
; NOSSE-NEXT:    retl
  store atomic i64 %val1, ptr %ptr seq_cst, align 8
  ret void
}

define i64 @test2(ptr %ptr) {
; SSE42-LABEL: test2:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE42-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE42-NEXT:    movd %xmm0, %eax
; SSE42-NEXT:    pextrd $1, %xmm0, %edx
; SSE42-NEXT:    retl
;
; NOSSE-LABEL: test2:
; NOSSE:       # %bb.0:
; NOSSE-NEXT:    pushl %ebp
; NOSSE-NEXT:    .cfi_def_cfa_offset 8
; NOSSE-NEXT:    .cfi_offset %ebp, -8
; NOSSE-NEXT:    movl %esp, %ebp
; NOSSE-NEXT:    .cfi_def_cfa_register %ebp
; NOSSE-NEXT:    andl $-8, %esp
; NOSSE-NEXT:    subl $8, %esp
; NOSSE-NEXT:    movl 8(%ebp), %eax
; NOSSE-NEXT:    fildll (%eax)
; NOSSE-NEXT:    fistpll (%esp)
; NOSSE-NEXT:    movl (%esp), %eax
; NOSSE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; NOSSE-NEXT:    movl %ebp, %esp
; NOSSE-NEXT:    popl %ebp
; NOSSE-NEXT:    .cfi_def_cfa %esp, 4
; NOSSE-NEXT:    retl
  %val = load atomic i64, ptr %ptr seq_cst, align 8
  ret i64 %val
}

; Same as test2, but with noimplicitfloat.
define i64 @test3(ptr %ptr) noimplicitfloat {
; CHECK-LABEL: test3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushl %ebx
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    pushl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 12
; CHECK-NEXT:    .cfi_offset %esi, -12
; CHECK-NEXT:    .cfi_offset %ebx, -8
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %esi
; CHECK-NEXT:    xorl %eax, %eax
; CHECK-NEXT:    xorl %edx, %edx
; CHECK-NEXT:    xorl %ecx, %ecx
; CHECK-NEXT:    xorl %ebx, %ebx
; CHECK-NEXT:    lock cmpxchg8b (%esi)
; CHECK-NEXT:    popl %esi
; CHECK-NEXT:    .cfi_def_cfa_offset 8
; CHECK-NEXT:    popl %ebx
; CHECK-NEXT:    .cfi_def_cfa_offset 4
; CHECK-NEXT:    retl
  %val = load atomic i64, ptr %ptr seq_cst, align 8
  ret i64 %val
}

define i64 @test4(ptr %ptr) {
; SSE42-LABEL: test4:
; SSE42:       # %bb.0:
; SSE42-NEXT:    movl {{[0-9]+}}(%esp), %eax
; SSE42-NEXT:    movq {{.*#+}} xmm0 = mem[0],zero
; SSE42-NEXT:    movd %xmm0, %eax
; SSE42-NEXT:    pextrd $1, %xmm0, %edx
; SSE42-NEXT:    retl
;
; NOSSE-LABEL: test4:
; NOSSE:       # %bb.0:
; NOSSE-NEXT:    pushl %ebp
; NOSSE-NEXT:    .cfi_def_cfa_offset 8
; NOSSE-NEXT:    .cfi_offset %ebp, -8
; NOSSE-NEXT:    movl %esp, %ebp
; NOSSE-NEXT:    .cfi_def_cfa_register %ebp
; NOSSE-NEXT:    andl $-8, %esp
; NOSSE-NEXT:    subl $8, %esp
; NOSSE-NEXT:    movl 8(%ebp), %eax
; NOSSE-NEXT:    fildll (%eax)
; NOSSE-NEXT:    fistpll (%esp)
; NOSSE-NEXT:    movl (%esp), %eax
; NOSSE-NEXT:    movl {{[0-9]+}}(%esp), %edx
; NOSSE-NEXT:    movl %ebp, %esp
; NOSSE-NEXT:    popl %ebp
; NOSSE-NEXT:    .cfi_def_cfa %esp, 4
; NOSSE-NEXT:    retl
  %val = load atomic volatile i64, ptr %ptr seq_cst, align 8
  ret i64 %val
}
