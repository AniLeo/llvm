; RUN: llc -march=sparc   < %s | FileCheck %s --check-prefix=V8
; RUN: llc -march=sparcv9 < %s | FileCheck %s --check-prefix=SPARC64

; V8-LABEL: variable_alloca_with_adj_call_stack
; V8:       save %sp, -96, %sp
; (this should ideally be doing "add 4+7; and -8", instead of
;  "add 7; and -8; add 8"; see comments in LowerDYNAMIC_STACKALLOC)
; V8:       add %i0, 7, %i0
; V8-NEXT:  and %i0, -8, %i0
; V8-NEXT:  add %i0, 8, %i0
; V8-NEXT:  sub %sp, %i0, %i0
; V8-NEXT:  add %i0, 96, %o0
; V8:       add %sp, -16, %sp
; V8:       call foo
; V8:       add %sp, 16, %sp

; SPARC64-LABEL: variable_alloca_with_adj_call_stack
; SPARC64:       save %sp, -128, %sp
; SPARC64:       add {{.+}}, 2175, %o0
; SPARC64:       add %sp, -80, %sp
; SPARC64:       call foo
; SPARC64:       add %sp, 80, %sp

define void @variable_alloca_with_adj_call_stack(i32 %num) {
entry:
  %0 = alloca i8, i32 %num, align 8
  call void @foo(i8* %0, i8* %0, i8* %0, i8* %0, i8* %0, i8* %0, i8* %0, i8* %0, i8* %0, i8* %0)
  ret void
}

declare void @foo(i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*);
