; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown | FileCheck %s -check-prefix=X64
; RUN: llc < %s -mtriple=i686-unknown-unknown   | FileCheck %s -check-prefix=X32

; tailcc will turn all of these musttail calls into tail calls.

declare dso_local tailcc i32 @tailcallee(i32 %a1, i32 %a2)

define tailcc i32 @tailcaller(i32 %in1, i32 %in2) nounwind {
; X64-LABEL: tailcaller:
; X64:       # %bb.0: # %entry
; X64-NEXT:    jmp tailcallee # TAILCALL
;
; X32-LABEL: tailcaller:
; X32:       # %bb.0: # %entry
; X32-NEXT:    jmp tailcallee # TAILCALL
entry:
  %tmp11 = musttail call tailcc i32 @tailcallee(i32 %in1, i32 %in2)
  ret i32 %tmp11
}

declare dso_local tailcc i8* @alias_callee()

define tailcc noalias i8* @noalias_caller() nounwind {
; X64-LABEL: noalias_caller:
; X64:       # %bb.0:
; X64-NEXT:    jmp alias_callee # TAILCALL
;
; X32-LABEL: noalias_caller:
; X32:       # %bb.0:
; X32-NEXT:    jmp alias_callee # TAILCALL
  %p = musttail call tailcc i8* @alias_callee()
  ret i8* %p
}

declare dso_local tailcc noalias i8* @noalias_callee()

define tailcc i8* @alias_caller() nounwind {
; X64-LABEL: alias_caller:
; X64:       # %bb.0:
; X64-NEXT:    jmp noalias_callee # TAILCALL
;
; X32-LABEL: alias_caller:
; X32:       # %bb.0:
; X32-NEXT:    jmp noalias_callee # TAILCALL
  %p = musttail call tailcc noalias i8* @noalias_callee()
  ret i8* %p
}

define tailcc void @void_test(i32, i32, i32, i32) {
; X64-LABEL: void_test:
; X64:       # %bb.0: # %entry
; X64-NEXT:    jmp void_test # TAILCALL
;
; X32-LABEL: void_test:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esi
; X32-NEXT:    .cfi_def_cfa_offset 8
; X32-NEXT:    .cfi_offset %esi, -8
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; X32-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; X32-NEXT:    popl %esi
; X32-NEXT:    .cfi_def_cfa_offset 4
; X32-NEXT:    jmp void_test # TAILCALL
  entry:
   musttail call tailcc void @void_test( i32 %0, i32 %1, i32 %2, i32 %3)
   ret void
}

define tailcc i1 @i1test(i32, i32, i32, i32) {
; X64-LABEL: i1test:
; X64:       # %bb.0: # %entry
; X64-NEXT:    jmp i1test # TAILCALL
;
; X32-LABEL: i1test:
; X32:       # %bb.0: # %entry
; X32-NEXT:    pushl %esi
; X32-NEXT:    .cfi_def_cfa_offset 8
; X32-NEXT:    .cfi_offset %esi, -8
; X32-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X32-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X32-NEXT:    movl %esi, {{[0-9]+}}(%esp)
; X32-NEXT:    movl %eax, {{[0-9]+}}(%esp)
; X32-NEXT:    popl %esi
; X32-NEXT:    .cfi_def_cfa_offset 4
; X32-NEXT:    jmp i1test # TAILCALL
  entry:
  %4 = musttail call tailcc i1 @i1test( i32 %0, i32 %1, i32 %2, i32 %3)
  ret i1 %4
}
