; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64 < %s | FileCheck %s

define void @bool_eq(i1 zeroext %a, i1 zeroext %b, ptr nocapture %c) nounwind {
; CHECK-LABEL: bool_eq:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    xorl %esi, %edi
; CHECK-NEXT:    je .LBB0_2
; CHECK-NEXT:  # %bb.1: # %if.end
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_2: # %if.then
; CHECK-NEXT:    jmpq *%rdx # TAILCALL
entry:
  %0 = xor i1 %a, %b
  br i1 %0, label %if.end, label %if.then

if.then:
  tail call void %c() #1
  br label %if.end

if.end:
  ret void
}

define void @bool_ne(i1 zeroext %a, i1 zeroext %b, ptr nocapture %c) nounwind {
; CHECK-LABEL: bool_ne:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    cmpb %sil, %dil
; CHECK-NEXT:    je .LBB1_1
; CHECK-NEXT:  # %bb.2: # %if.then
; CHECK-NEXT:    jmpq *%rdx # TAILCALL
; CHECK-NEXT:  .LBB1_1: # %if.end
; CHECK-NEXT:    retq
entry:
  %cmp = xor i1 %a, %b
  br i1 %cmp, label %if.then, label %if.end

if.then:
  tail call void %c() #1
  br label %if.end

if.end:
  ret void
}
