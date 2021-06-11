; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+enqcmd | FileCheck %s --check-prefix=X64
; RUN: llc < %s -mtriple=i386-unknown-unknown -mattr=+enqcmd | FileCheck %s --check-prefix=X86
; RUN: llc < %s -mtriple=x86_64-linux-gnux32 -mattr=+enqcmd | FileCheck %s --check-prefix=X32

define i8 @test_enqcmd(i8* %dst, i8* %src) {
; X64-LABEL: test_enqcmd:
; X64:       # %bb.0: # %entry
; X64-NEXT:    enqcmd (%rsi), %rdi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
;
; X86-LABEL: test_enqcmd:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    enqcmd (%eax), %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X32-LABEL: test_enqcmd:
; X32:       # %bb.0: # %entry
; X32-NEXT:    enqcmd (%esi), %edi
; X32-NEXT:    sete %al
; X32-NEXT:    retq
entry:


  %0 = call i8 @llvm.x86.enqcmd(i8* %dst, i8* %src)
  ret i8 %0
}

define i8 @test_enqcmds(i8* %dst, i8* %src) {
; X64-LABEL: test_enqcmds:
; X64:       # %bb.0: # %entry
; X64-NEXT:    enqcmds (%rsi), %rdi
; X64-NEXT:    sete %al
; X64-NEXT:    retq
;
; X86-LABEL: test_enqcmds:
; X86:       # %bb.0: # %entry
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    enqcmds (%eax), %ecx
; X86-NEXT:    sete %al
; X86-NEXT:    retl
;
; X32-LABEL: test_enqcmds:
; X32:       # %bb.0: # %entry
; X32-NEXT:    enqcmds (%esi), %edi
; X32-NEXT:    sete %al
; X32-NEXT:    retq
entry:


  %0 = call i8 @llvm.x86.enqcmds(i8* %dst, i8* %src)
  ret i8 %0
}

declare i8 @llvm.x86.enqcmd(i8*, i8*)
declare i8 @llvm.x86.enqcmds(i8*, i8*)
