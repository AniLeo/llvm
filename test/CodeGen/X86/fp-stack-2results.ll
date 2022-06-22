; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-- | FileCheck %s --check-prefixes=ALL,i686
; RUN: llc < %s -mtriple=x86_64-- | FileCheck %s -check-prefixes=ALL,x86_64


%0 = type { x86_fp80, x86_fp80 }

; This is basically this code on x86-64:
; _Complex long double test() { return 1.0; }
define %0 @test() {
; ALL-LABEL: test:
; ALL:       # %bb.0:
; ALL-NEXT:    fldz
; ALL-NEXT:    fld1
; ALL-NEXT:    ret{{[l|q]}}
  %A = fpext double 1.0 to x86_fp80
  %B = fpext double 0.0 to x86_fp80
  %mrv = insertvalue %0 undef, x86_fp80 %A, 0
  %mrv1 = insertvalue %0 %mrv, x86_fp80 %B, 1
  ret %0 %mrv1
}


;_test2:
;	fld1
;	fld	%st(0)
;	ret
define %0 @test2() {
; ALL-LABEL: test2:
; ALL:       # %bb.0:
; ALL-NEXT:    fld1
; ALL-NEXT:    fld %st(0)
; ALL-NEXT:    ret{{[l|q]}}
  %A = fpext double 1.0 to x86_fp80
  %mrv = insertvalue %0 undef, x86_fp80 %A, 0
  %mrv1 = insertvalue %0 %mrv, x86_fp80 %A, 1
  ret %0 %mrv1
}

; Uses both values.
define void @call1(ptr%P1, ptr%P2) {
; i686-LABEL: call1:
; i686:       # %bb.0:
; i686-NEXT:    pushl %edi
; i686-NEXT:    .cfi_def_cfa_offset 8
; i686-NEXT:    pushl %esi
; i686-NEXT:    .cfi_def_cfa_offset 12
; i686-NEXT:    .cfi_offset %esi, -12
; i686-NEXT:    .cfi_offset %edi, -8
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edi
; i686-NEXT:    calll test@PLT
; i686-NEXT:    fstpt (%edi)
; i686-NEXT:    fstpt (%esi)
; i686-NEXT:    popl %esi
; i686-NEXT:    .cfi_def_cfa_offset 8
; i686-NEXT:    popl %edi
; i686-NEXT:    .cfi_def_cfa_offset 4
; i686-NEXT:    retl
;
; x86_64-LABEL: call1:
; x86_64:       # %bb.0:
; x86_64-NEXT:    pushq %r14
; x86_64-NEXT:    .cfi_def_cfa_offset 16
; x86_64-NEXT:    pushq %rbx
; x86_64-NEXT:    .cfi_def_cfa_offset 24
; x86_64-NEXT:    pushq %rax
; x86_64-NEXT:    .cfi_def_cfa_offset 32
; x86_64-NEXT:    .cfi_offset %rbx, -24
; x86_64-NEXT:    .cfi_offset %r14, -16
; x86_64-NEXT:    movq %rsi, %r14
; x86_64-NEXT:    movq %rdi, %rbx
; x86_64-NEXT:    callq test@PLT
; x86_64-NEXT:    fstpt (%rbx)
; x86_64-NEXT:    fstpt (%r14)
; x86_64-NEXT:    addq $8, %rsp
; x86_64-NEXT:    .cfi_def_cfa_offset 24
; x86_64-NEXT:    popq %rbx
; x86_64-NEXT:    .cfi_def_cfa_offset 16
; x86_64-NEXT:    popq %r14
; x86_64-NEXT:    .cfi_def_cfa_offset 8
; x86_64-NEXT:    retq
  %a = call %0 @test()
  %b = extractvalue %0 %a, 0
  store x86_fp80 %b, ptr %P1

  %c = extractvalue %0 %a, 1
  store x86_fp80 %c, ptr %P2
  ret void
}

; Uses both values, requires fxch
define void @call2(ptr%P1, ptr%P2) {
; i686-LABEL: call2:
; i686:       # %bb.0:
; i686-NEXT:    pushl %edi
; i686-NEXT:    .cfi_def_cfa_offset 8
; i686-NEXT:    pushl %esi
; i686-NEXT:    .cfi_def_cfa_offset 12
; i686-NEXT:    .cfi_offset %esi, -12
; i686-NEXT:    .cfi_offset %edi, -8
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    movl {{[0-9]+}}(%esp), %edi
; i686-NEXT:    calll test@PLT
; i686-NEXT:    fxch %st(1)
; i686-NEXT:    fstpt (%edi)
; i686-NEXT:    fstpt (%esi)
; i686-NEXT:    popl %esi
; i686-NEXT:    .cfi_def_cfa_offset 8
; i686-NEXT:    popl %edi
; i686-NEXT:    .cfi_def_cfa_offset 4
; i686-NEXT:    retl
;
; x86_64-LABEL: call2:
; x86_64:       # %bb.0:
; x86_64-NEXT:    pushq %r14
; x86_64-NEXT:    .cfi_def_cfa_offset 16
; x86_64-NEXT:    pushq %rbx
; x86_64-NEXT:    .cfi_def_cfa_offset 24
; x86_64-NEXT:    pushq %rax
; x86_64-NEXT:    .cfi_def_cfa_offset 32
; x86_64-NEXT:    .cfi_offset %rbx, -24
; x86_64-NEXT:    .cfi_offset %r14, -16
; x86_64-NEXT:    movq %rsi, %r14
; x86_64-NEXT:    movq %rdi, %rbx
; x86_64-NEXT:    callq test@PLT
; x86_64-NEXT:    fxch %st(1)
; x86_64-NEXT:    fstpt (%rbx)
; x86_64-NEXT:    fstpt (%r14)
; x86_64-NEXT:    addq $8, %rsp
; x86_64-NEXT:    .cfi_def_cfa_offset 24
; x86_64-NEXT:    popq %rbx
; x86_64-NEXT:    .cfi_def_cfa_offset 16
; x86_64-NEXT:    popq %r14
; x86_64-NEXT:    .cfi_def_cfa_offset 8
; x86_64-NEXT:    retq
  %a = call %0 @test()
  %b = extractvalue %0 %a, 1
  store x86_fp80 %b, ptr %P1

  %c = extractvalue %0 %a, 0
  store x86_fp80 %c, ptr %P2
  ret void
}

; Uses ST(0), ST(1) is dead but must be popped.
define void @call3(ptr%P1, ptr%P2) {
; i686-LABEL: call3:
; i686:       # %bb.0:
; i686-NEXT:    pushl %esi
; i686-NEXT:    .cfi_def_cfa_offset 8
; i686-NEXT:    .cfi_offset %esi, -8
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    calll test@PLT
; i686-NEXT:    fstp %st(1)
; i686-NEXT:    fstpt (%esi)
; i686-NEXT:    popl %esi
; i686-NEXT:    .cfi_def_cfa_offset 4
; i686-NEXT:    retl
;
; x86_64-LABEL: call3:
; x86_64:       # %bb.0:
; x86_64-NEXT:    pushq %rbx
; x86_64-NEXT:    .cfi_def_cfa_offset 16
; x86_64-NEXT:    .cfi_offset %rbx, -16
; x86_64-NEXT:    movq %rdi, %rbx
; x86_64-NEXT:    callq test@PLT
; x86_64-NEXT:    fstp %st(1)
; x86_64-NEXT:    fstpt (%rbx)
; x86_64-NEXT:    popq %rbx
; x86_64-NEXT:    .cfi_def_cfa_offset 8
; x86_64-NEXT:    retq
  %a = call %0 @test()
  %b = extractvalue %0 %a, 0
  store x86_fp80 %b, ptr %P1
  ret void
}

; Uses ST(1), ST(0) is dead and must be popped.
define void @call4(ptr%P1, ptr%P2) {
; i686-LABEL: call4:
; i686:       # %bb.0:
; i686-NEXT:    pushl %esi
; i686-NEXT:    .cfi_def_cfa_offset 8
; i686-NEXT:    .cfi_offset %esi, -8
; i686-NEXT:    movl {{[0-9]+}}(%esp), %esi
; i686-NEXT:    calll test@PLT
; i686-NEXT:    fstp %st(0)
; i686-NEXT:    fstpt (%esi)
; i686-NEXT:    popl %esi
; i686-NEXT:    .cfi_def_cfa_offset 4
; i686-NEXT:    retl
;
; x86_64-LABEL: call4:
; x86_64:       # %bb.0:
; x86_64-NEXT:    pushq %rbx
; x86_64-NEXT:    .cfi_def_cfa_offset 16
; x86_64-NEXT:    .cfi_offset %rbx, -16
; x86_64-NEXT:    movq %rsi, %rbx
; x86_64-NEXT:    callq test@PLT
; x86_64-NEXT:    fstp %st(0)
; x86_64-NEXT:    fstpt (%rbx)
; x86_64-NEXT:    popq %rbx
; x86_64-NEXT:    .cfi_def_cfa_offset 8
; x86_64-NEXT:    retq
  %a = call %0 @test()

  %c = extractvalue %0 %a, 1
  store x86_fp80 %c, ptr %P2
  ret void
}

