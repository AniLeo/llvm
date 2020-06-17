; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s | FileCheck %s --check-prefixes=ALL,CHECK
; RUN: llc -O0 < %s | FileCheck %s --check-prefixes=ALL,CHECK-O0

; Source to regenerate:
; struct Foo {
;   int * __ptr32 p32;
;   int * __ptr64 p64;
;   __attribute__((address_space(9))) int *p_other;
; };
; void use_foo(Foo *f);
; void test_sign_ext(Foo *f, int * __ptr32 __sptr i) {
;   f->p64 = i;
;   use_foo(f);
; }
; void test_zero_ext(Foo *f, int * __ptr32 __uptr i) {
;   f->p64 = i;
;   use_foo(f);
; }
; void test_trunc(Foo *f, int * __ptr64 i) {
;   f->p32 = i;
;   use_foo(f);
; }
; void test_noop1(Foo *f, int * __ptr32 i) {
;   f->p32 = i;
;   use_foo(f);
; }
; void test_noop2(Foo *f, int * __ptr64 i) {
;   f->p64 = i;
;   use_foo(f);
; }
; void test_null_arg(Foo *f) {
;   test_noop2(f, 0);
; }
; void test_unrecognized(Foo *f, __attribute__((address_space(14))) int *i) {
;   f->p64 = (int * __ptr64)i;
;   use_foo(f);
; }
; void test_unrecognized2(Foo *f, int * __ptr64 i) {
;   f->p_other = i;
;   use_foo(f);
; }
;
; $ clang -cc1 -triple x86_64-windows-msvc -fms-extensions -O2 -S t.cpp

target datalayout = "e-m:x-p:32:32-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:32-n8:16:32-a:0:32-S32"
target triple = "i686-unknown-windows-msvc"

%struct.Foo = type { i32*, i32 addrspace(272)*, i32 addrspace(9)* }
declare dso_local void @use_foo(%struct.Foo*)

define dso_local void @test_sign_ext(%struct.Foo* %f, i32* %i) {
; CHECK-LABEL: test_sign_ext:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %ecx, 8(%eax)
; CHECK-NEXT:    sarl $31, %ecx
; CHECK-NEXT:    movl %ecx, 12(%eax)
; CHECK-NEXT:    jmp _use_foo # TAILCALL
;
; CHECK-O0-LABEL: test_sign_ext:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-O0-NEXT:    movl %eax, %edx
; CHECK-O0-NEXT:    sarl $31, %edx
; CHECK-O0-NEXT:    movl %eax, 8(%ecx)
; CHECK-O0-NEXT:    movl %edx, 12(%ecx)
; CHECK-O0-NEXT:    jmp _use_foo # TAILCALL
entry:
  %0 = addrspacecast i32* %i to i32 addrspace(272)*
  %p64 = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 1
  store i32 addrspace(272)* %0, i32 addrspace(272)** %p64, align 8
  tail call void @use_foo(%struct.Foo* %f)
  ret void
}

define dso_local void @test_zero_ext(%struct.Foo* %f, i32 addrspace(271)* %i) {
; ALL-LABEL: test_zero_ext:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movl {{[0-9]+}}(%esp), %eax
; ALL-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; ALL-NEXT:    movl %eax, 8(%ecx)
; ALL-NEXT:    movl $0, 12(%ecx)
; ALL-NEXT:    jmp _use_foo # TAILCALL
entry:
  %0 = addrspacecast i32 addrspace(271)* %i to i32 addrspace(272)*
  %p64 = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 1
  store i32 addrspace(272)* %0, i32 addrspace(272)** %p64, align 8
  tail call void @use_foo(%struct.Foo* %f)
  ret void
}

define dso_local void @test_trunc(%struct.Foo* %f, i32 addrspace(272)* %i) {
; CHECK-LABEL: test_trunc:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %eax, (%ecx)
; CHECK-NEXT:    jmp _use_foo # TAILCALL
;
; CHECK-O0-LABEL: test_trunc:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushl %eax
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-O0-NEXT:    movl %ecx, (%edx)
; CHECK-O0-NEXT:    movl %eax, (%esp) # 4-byte Spill
; CHECK-O0-NEXT:    popl %eax
; CHECK-O0-NEXT:    jmp _use_foo # TAILCALL
entry:
  %0 = addrspacecast i32 addrspace(272)* %i to i32*
  %p32 = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 0
  store i32* %0, i32** %p32, align 8
  tail call void @use_foo(%struct.Foo* %f)
  ret void
}

define dso_local void @test_noop1(%struct.Foo* %f, i32* %i) {
; ALL-LABEL: test_noop1:
; ALL:       # %bb.0: # %entry
; ALL-NEXT:    movl {{[0-9]+}}(%esp), %eax
; ALL-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; ALL-NEXT:    movl %eax, (%ecx)
; ALL-NEXT:    jmp _use_foo # TAILCALL
entry:
  %p32 = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 0
  store i32* %i, i32** %p32, align 8
  tail call void @use_foo(%struct.Foo* %f)
  ret void
}

define dso_local void @test_noop2(%struct.Foo* %f, i32 addrspace(272)* %i) {
; CHECK-LABEL: test_noop2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-NEXT:    movl %ecx, 12(%edx)
; CHECK-NEXT:    movl %eax, 8(%edx)
; CHECK-NEXT:    jmp _use_foo # TAILCALL
;
; CHECK-O0-LABEL: test_noop2:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-O0-NEXT:    movl %ecx, 8(%edx)
; CHECK-O0-NEXT:    movl %eax, 12(%edx)
; CHECK-O0-NEXT:    jmp _use_foo # TAILCALL
entry:
  %p64 = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 1
  store i32 addrspace(272)* %i, i32 addrspace(272)** %p64, align 8
  tail call void @use_foo(%struct.Foo* %f)
  ret void
}

; Test that null can be passed as a 64-bit pointer.
define dso_local void @test_null_arg(%struct.Foo* %f) {
; CHECK-LABEL: test_null_arg:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushl $0
; CHECK-NEXT:    pushl $0
; CHECK-NEXT:    pushl {{[0-9]+}}(%esp)
; CHECK-NEXT:    calll _test_noop2
; CHECK-NEXT:    addl $12, %esp
; CHECK-NEXT:    retl
;
; CHECK-O0-LABEL: test_null_arg:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    subl $12, %esp
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-O0-NEXT:    movl %esp, %ecx
; CHECK-O0-NEXT:    movl %eax, (%ecx)
; CHECK-O0-NEXT:    movl $0, 8(%ecx)
; CHECK-O0-NEXT:    movl $0, 4(%ecx)
; CHECK-O0-NEXT:    calll _test_noop2
; CHECK-O0-NEXT:    addl $12, %esp
; CHECK-O0-NEXT:    retl
entry:
  call void @test_noop2(%struct.Foo* %f, i32 addrspace(272)* null)
  ret void
}

define dso_local void @test_unrecognized(%struct.Foo* %f, i32 addrspace(14)* %i) {
; CHECK-LABEL: test_unrecognized:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %ecx, 8(%eax)
; CHECK-NEXT:    sarl $31, %ecx
; CHECK-NEXT:    movl %ecx, 12(%eax)
; CHECK-NEXT:    jmp _use_foo # TAILCALL
;
; CHECK-O0-LABEL: test_unrecognized:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-O0-NEXT:    movl %eax, %edx
; CHECK-O0-NEXT:    sarl $31, %edx
; CHECK-O0-NEXT:    movl %eax, 8(%ecx)
; CHECK-O0-NEXT:    movl %edx, 12(%ecx)
; CHECK-O0-NEXT:    jmp _use_foo # TAILCALL
entry:
  %0 = addrspacecast i32 addrspace(14)* %i to i32 addrspace(272)*
  %p64 = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 1
  store i32 addrspace(272)* %0, i32 addrspace(272)** %p64, align 8
  tail call void @use_foo(%struct.Foo* %f)
  ret void
}

define dso_local void @test_unrecognized2(%struct.Foo* %f, i32 addrspace(272)* %i) {
; CHECK-LABEL: test_unrecognized2:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-NEXT:    movl %eax, 16(%ecx)
; CHECK-NEXT:    jmp _use_foo # TAILCALL
;
; CHECK-O0-LABEL: test_unrecognized2:
; CHECK-O0:       # %bb.0: # %entry
; CHECK-O0-NEXT:    pushl %eax
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %eax
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; CHECK-O0-NEXT:    movl {{[0-9]+}}(%esp), %edx
; CHECK-O0-NEXT:    movl %ecx, 16(%edx)
; CHECK-O0-NEXT:    movl %eax, (%esp) # 4-byte Spill
; CHECK-O0-NEXT:    popl %eax
; CHECK-O0-NEXT:    jmp _use_foo # TAILCALL
entry:
  %0 = addrspacecast i32 addrspace(272)* %i to i32 addrspace(9)*
  %p_other = getelementptr inbounds %struct.Foo, %struct.Foo* %f, i32 0, i32 2
  store i32 addrspace(9)* %0, i32 addrspace(9)** %p_other, align 8
  tail call void @use_foo(%struct.Foo* %f)
  ret void
}
