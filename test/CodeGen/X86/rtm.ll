; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s -mtriple=i686-unknown-unknown -mattr=+rtm | FileCheck %s --check-prefix=X86
; RUN: llc -verify-machineinstrs < %s -mtriple=x86_64-unknown-unknown -mattr=+rtm | FileCheck %s --check-prefix=X64

declare i32 @llvm.x86.xbegin() nounwind
declare void @llvm.x86.xend() nounwind
declare void @llvm.x86.xabort(i8) nounwind
declare void @f1()

define i32 @test_xbegin() nounwind uwtable {
; X86-LABEL: test_xbegin:
; X86:       # BB#0: # %entry
; X86-NEXT:    xbegin .LBB0_2
; X86-NEXT:  # BB#1: # %entry
; X86-NEXT:    movl $-1, %eax
; X86:       .LBB0_2: # %entry
; X86-NEXT:  # XABORT DEF
; X86-NEXT:    retl
;
; X64-LABEL: test_xbegin:
; X64:       # BB#0: # %entry
; X64-NEXT:    xbegin .LBB0_2
; X64-NEXT:  # BB#1: # %entry
; X64-NEXT:    movl $-1, %eax
; X64:       .LBB0_2: # %entry
; X64-NEXT:  # XABORT DEF
; X64-NEXT:    retq
entry:
  %0 = tail call i32 @llvm.x86.xbegin() nounwind
  ret i32 %0
}

define void @test_xend() nounwind uwtable {
; X86-LABEL: test_xend:
; X86:       # BB#0: # %entry
; X86-NEXT:    xend
; X86-NEXT:    retl
;
; X64-LABEL: test_xend:
; X64:       # BB#0: # %entry
; X64-NEXT:    xend
; X64-NEXT:    retq
entry:
  tail call void @llvm.x86.xend() nounwind
  ret void
}

define void @test_xabort() nounwind uwtable {
; X86-LABEL: test_xabort:
; X86:       # BB#0: # %entry
; X86-NEXT:    xabort $2
; X86-NEXT:    retl
;
; X64-LABEL: test_xabort:
; X64:       # BB#0: # %entry
; X64-NEXT:    xabort $2
; X64-NEXT:    retq
entry:
  tail call void @llvm.x86.xabort(i8 2)
  ret void
}

define void @f2(i32 %x) nounwind uwtable {
; X86-LABEL: f2:
; X86:       # BB#0: # %entry
; X86-NEXT:    xabort $1
; X86-NEXT:    calll f1
; X86-NEXT:    retl
;
; X64-LABEL: f2:
; X64:       # BB#0: # %entry
; X64-NEXT:    pushq %rax
; X64-NEXT:  .Lcfi0:
; X64-NEXT:    .cfi_def_cfa_offset 16
; X64-NEXT:    movl %edi, {{[0-9]+}}(%rsp)
; X64-NEXT:    xabort $1
; X64-NEXT:    callq f1
; X64-NEXT:    popq %rax
; X64-NEXT:  .Lcfi1:
; X64-NEXT:    .cfi_def_cfa_offset 8
; X64-NEXT:    retq
entry:
  %x.addr = alloca i32, align 4
  store i32 %x, i32* %x.addr, align 4
  call void @llvm.x86.xabort(i8 1)
  call void @f1()
  ret void
}

