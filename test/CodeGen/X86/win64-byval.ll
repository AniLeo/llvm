; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple x86_64-w64-mingw32 %s -o - | FileCheck %s

declare void @foo(ptr byval({ float, double }))
@G = external constant { float, double }

define void @bar() {
; Make sure we're creating a temporary stack slot, rather than just passing
; the pointer through unmodified.
; CHECK-LABEL: bar:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $56, %rsp
; CHECK-NEXT:    .seh_stackalloc 56
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    movq .refptr.G(%rip), %rax
; CHECK-NEXT:    movq (%rax), %rcx
; CHECK-NEXT:    movq 8(%rax), %rax
; CHECK-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rcx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    nop
; CHECK-NEXT:    addq $56, %rsp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
    call void @foo(ptr byval({ float, double }) @G)
    ret void
}

define void @baz(ptr byval({ float, double }) %arg) {
; On Win64 the byval is effectively ignored on declarations, since we do
; pass a real pointer in registers. However, by our semantics if we pass
; the pointer on to another byval function, we do need to make a copy.
; CHECK-LABEL: baz:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $56, %rsp
; CHECK-NEXT:    .seh_stackalloc 56
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    movq (%rcx), %rax
; CHECK-NEXT:    movq 8(%rcx), %rcx
; CHECK-NEXT:    movq %rcx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    callq foo
; CHECK-NEXT:    nop
; CHECK-NEXT:    addq $56, %rsp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
    call void @foo(ptr byval({ float, double }) %arg)
    ret void
}

declare void @foo2(ptr byval({ float, double }), ptr byval({ float, double }), ptr byval({ float, double }), ptr byval({ float, double }), ptr byval({ float, double }), i64 %f)
@data = external constant { float, double }

define void @test() {
; CHECK-LABEL: test:
; CHECK:       # %bb.0:
; CHECK-NEXT:    subq $136, %rsp
; CHECK-NEXT:    .seh_stackalloc 136
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    movq .refptr.G(%rip), %rax
; CHECK-NEXT:    movq (%rax), %rcx
; CHECK-NEXT:    movq 8(%rax), %rax
; CHECK-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rcx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rcx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rcx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rcx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq %rcx, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rax
; CHECK-NEXT:    movq %rax, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    movq $10, {{[0-9]+}}(%rsp)
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rcx
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rdx
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %r8
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %r9
; CHECK-NEXT:    callq foo2
; CHECK-NEXT:    nop
; CHECK-NEXT:    addq $136, %rsp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  call void @foo2(ptr byval({ float, double }) @G, ptr byval({ float, double }) @G, ptr byval({ float, double }) @G, ptr byval({ float, double }) @G, ptr byval({ float, double }) @G, i64 10)
  ret void
}
