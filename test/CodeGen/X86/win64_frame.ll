; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-pc-win32              | FileCheck %s
; RUN: llc < %s -mtriple=x86_64-pc-win32 -mattr=+sahf | FileCheck %s

define i32 @f1(i32 %p1, i32 %p2, i32 %p3, i32 %p4, i32 %p5) "frame-pointer"="all" {
; CHECK-LABEL: f1:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 0
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    movl 48(%rbp), %eax
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  ret i32 %p5
}

define void @f2(i32 %p, ...) "frame-pointer"="all" {
; CHECK-LABEL: f2:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    .seh_stackalloc 8
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 0
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    movq %rdx, 32(%rbp)
; CHECK-NEXT:    movq %r8, 40(%rbp)
; CHECK-NEXT:    movq %r9, 48(%rbp)
; CHECK-NEXT:    leaq 32(%rbp), %rax
; CHECK-NEXT:    movq %rax, (%rbp)
; CHECK-NEXT:    addq $8, %rsp
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  %ap = alloca i8, align 8
  call void @llvm.va_start(ptr %ap)
  ret void
}

define ptr @f3() "frame-pointer"="all" {
; CHECK-LABEL: f3:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 0
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    movq 8(%rbp), %rax
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  %ra = call ptr @llvm.returnaddress(i32 0)
  ret ptr %ra
}

define ptr @f4() "frame-pointer"="all" {
; CHECK-LABEL: f4:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    subq $304, %rsp # imm = 0x130
; CHECK-NEXT:    .seh_stackalloc 304
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 128
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    movq 184(%rbp), %rax
; CHECK-NEXT:    addq $304, %rsp # imm = 0x130
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  alloca [300 x i8]
  %ra = call ptr @llvm.returnaddress(i32 0)
  ret ptr %ra
}

declare void @external(ptr)

define void @f5() "frame-pointer"="all" {
; CHECK-LABEL: f5:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    subq $336, %rsp # imm = 0x150
; CHECK-NEXT:    .seh_stackalloc 336
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 128
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    leaq -92(%rbp), %rcx
; CHECK-NEXT:    callq external
; CHECK-NEXT:    nop
; CHECK-NEXT:    addq $336, %rsp # imm = 0x150
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  %a = alloca [300 x i8]
  call void @external(ptr %a)
  ret void
}

define void @f6(i32 %p, ...) "frame-pointer"="all" {
; CHECK-LABEL: f6:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    subq $336, %rsp # imm = 0x150
; CHECK-NEXT:    .seh_stackalloc 336
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 128
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    leaq -92(%rbp), %rcx
; CHECK-NEXT:    callq external
; CHECK-NEXT:    nop
; CHECK-NEXT:    addq $336, %rsp # imm = 0x150
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  %a = alloca [300 x i8]
  call void @external(ptr %a)
  ret void
}

define i32 @f7(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e) "frame-pointer"="all" {
; CHECK-LABEL: f7:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    subq $304, %rsp # imm = 0x130
; CHECK-NEXT:    .seh_stackalloc 304
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 128
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    andq $-64, %rsp
; CHECK-NEXT:    movl 224(%rbp), %eax
; CHECK-NEXT:    leaq 176(%rbp), %rsp
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  alloca [300 x i8], align 64
  ret i32 %e
}

define i32 @f8(i32 %a, i32 %b, i32 %c, i32 %d, i32 %e) "frame-pointer"="all" {
; CHECK-LABEL: f8:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    pushq %rsi
; CHECK-NEXT:    .seh_pushreg %rsi
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .seh_pushreg %rbx
; CHECK-NEXT:    subq $352, %rsp # imm = 0x160
; CHECK-NEXT:    .seh_stackalloc 352
; CHECK-NEXT:    leaq {{[0-9]+}}(%rsp), %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 128
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    andq $-64, %rsp
; CHECK-NEXT:    movq %rsp, %rbx
; CHECK-NEXT:    movl 288(%rbp), %esi
; CHECK-NEXT:    movl %ecx, %eax
; CHECK-NEXT:    leaq 15(,%rax,4), %rax
; CHECK-NEXT:    andq $-16, %rax
; CHECK-NEXT:    callq __chkstk
; CHECK-NEXT:    subq %rax, %rsp
; CHECK-NEXT:    subq $32, %rsp
; CHECK-NEXT:    movq %rbx, %rcx
; CHECK-NEXT:    callq external
; CHECK-NEXT:    addq $32, %rsp
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    leaq 224(%rbp), %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %rsi
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  %alloca = alloca [300 x i8], align 64
  alloca i32, i32 %a
  call void @external(ptr %alloca)
  ret i32 %e
}

define i64 @f9() {
; CHECK-LABEL: f9:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 0
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    pushfq
; CHECK-NEXT:    popq %rax
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
entry:
  %call = call i64 @llvm.x86.flags.read.u64()
  ret i64 %call
}

declare i64 @dummy()

define i64 @f10(ptr %foo, i64 %bar, i64 %baz) {
; CHECK-LABEL: f10:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rsi
; CHECK-NEXT:    .seh_pushreg %rsi
; CHECK-NEXT:    pushq %rbx
; CHECK-NEXT:    .seh_pushreg %rbx
; CHECK-NEXT:    subq $40, %rsp
; CHECK-NEXT:    .seh_stackalloc 40
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    movq %rdx, %rsi
; CHECK-NEXT:    movq %rdx, %rax
; CHECK-NEXT:    lock cmpxchgq %r8, (%rcx)
; CHECK-NEXT:    sete %bl
; CHECK-NEXT:    callq dummy
; CHECK-NEXT:    testb %bl, %bl
; CHECK-NEXT:    cmoveq %rsi, %rax
; CHECK-NEXT:    addq $40, %rsp
; CHECK-NEXT:    popq %rbx
; CHECK-NEXT:    popq %rsi
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  %cx = cmpxchg ptr %foo, i64 %bar, i64 %baz seq_cst seq_cst
  %v = extractvalue { i64, i1 } %cx, 0
  %p = extractvalue { i64, i1 } %cx, 1
  %call = call i64 @dummy()
  %sel = select i1 %p, i64 %call, i64 %bar
  ret i64 %sel
}

define ptr @f11() "frame-pointer"="all" {
; CHECK-LABEL: f11:
; CHECK:       # %bb.0:
; CHECK-NEXT:    pushq %rbp
; CHECK-NEXT:    .seh_pushreg %rbp
; CHECK-NEXT:    movq %rsp, %rbp
; CHECK-NEXT:    .seh_setframe %rbp, 0
; CHECK-NEXT:    .seh_endprologue
; CHECK-NEXT:    leaq 8(%rbp), %rax
; CHECK-NEXT:    popq %rbp
; CHECK-NEXT:    retq
; CHECK-NEXT:    .seh_endproc
  %aora = call ptr @llvm.addressofreturnaddress()
  ret ptr %aora
}

define ptr @f12() {
; CHECK-LABEL: f12:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq %rsp, %rax
; CHECK-NEXT:    retq
  %aora = call ptr @llvm.addressofreturnaddress()
  ret ptr %aora
}

declare ptr @llvm.returnaddress(i32) nounwind readnone
declare ptr @llvm.addressofreturnaddress() nounwind readnone
declare i64 @llvm.x86.flags.read.u64()
declare void @llvm.va_start(ptr) nounwind
