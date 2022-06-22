; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Run with --no_x86_scrub_rip because we care a lot about how globals are
; accessed in the code model.

; Memset is interesting because it is an ExternalSymbol reference instead of a
; GlobalValue. Make sure we do the right GOT load for 64-bit large.

; RUN: llc < %s -relocation-model=pic    -code-model=small  | FileCheck %s --check-prefix=SMALL-PIC
; RUN: llc < %s -relocation-model=pic    -code-model=medium | FileCheck %s --check-prefix=MEDIUM-PIC
; RUN: llc < %s -relocation-model=pic    -code-model=large  | FileCheck %s --check-prefix=LARGE-PIC

; Generated from this C source:
;
; int main() {
;   unsigned int a[100] = {0};
;   return 0;
; }

; ModuleID = 'model.c'
source_filename = "model.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64--linux"

declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1) #1

define i32 @main() #0 {
; SMALL-PIC-LABEL: main:
; SMALL-PIC:       # %bb.0: # %entry
; SMALL-PIC-NEXT:    subq $424, %rsp # imm = 0x1A8
; SMALL-PIC-NEXT:    .cfi_def_cfa_offset 432
; SMALL-PIC-NEXT:    movl $0, {{[0-9]+}}(%rsp)
; SMALL-PIC-NEXT:    leaq {{[0-9]+}}(%rsp), %rdi
; SMALL-PIC-NEXT:    movl $400, %edx # imm = 0x190
; SMALL-PIC-NEXT:    xorl %esi, %esi
; SMALL-PIC-NEXT:    callq memset@PLT
; SMALL-PIC-NEXT:    xorl %eax, %eax
; SMALL-PIC-NEXT:    addq $424, %rsp # imm = 0x1A8
; SMALL-PIC-NEXT:    .cfi_def_cfa_offset 8
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: main:
; MEDIUM-PIC:       # %bb.0: # %entry
; MEDIUM-PIC-NEXT:    subq $424, %rsp # imm = 0x1A8
; MEDIUM-PIC-NEXT:    .cfi_def_cfa_offset 432
; MEDIUM-PIC-NEXT:    movl $0, {{[0-9]+}}(%rsp)
; MEDIUM-PIC-NEXT:    leaq {{[0-9]+}}(%rsp), %rdi
; MEDIUM-PIC-NEXT:    movl $400, %edx # imm = 0x190
; MEDIUM-PIC-NEXT:    xorl %esi, %esi
; MEDIUM-PIC-NEXT:    callq memset@PLT
; MEDIUM-PIC-NEXT:    xorl %eax, %eax
; MEDIUM-PIC-NEXT:    addq $424, %rsp # imm = 0x1A8
; MEDIUM-PIC-NEXT:    .cfi_def_cfa_offset 8
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: main:
; LARGE-PIC:       # %bb.0: # %entry
; LARGE-PIC-NEXT:    subq $424, %rsp # imm = 0x1A8
; LARGE-PIC-NEXT:    .cfi_def_cfa_offset 432
; LARGE-PIC-NEXT:  .L0$pb:
; LARGE-PIC-NEXT:    leaq .L0$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L0$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movl $0, {{[0-9]+}}(%rsp)
; LARGE-PIC-NEXT:    leaq {{[0-9]+}}(%rsp), %rdi
; LARGE-PIC-NEXT:    movabsq $memset@GOT, %rax
; LARGE-PIC-NEXT:    movl $400, %edx # imm = 0x190
; LARGE-PIC-NEXT:    xorl %esi, %esi
; LARGE-PIC-NEXT:    callq *(%rcx,%rax)
; LARGE-PIC-NEXT:    xorl %eax, %eax
; LARGE-PIC-NEXT:    addq $424, %rsp # imm = 0x1A8
; LARGE-PIC-NEXT:    .cfi_def_cfa_offset 8
; LARGE-PIC-NEXT:    retq
entry:
  %retval = alloca i32, align 4
  %a = alloca [100 x i32], align 16
  store i32 0, ptr %retval, align 4
  call void @llvm.memset.p0.i64(ptr align 16 %a, i8 0, i64 400, i1 false)
  ret i32 0
}

attributes #0 = { noinline nounwind uwtable }
attributes #0 = { argmemonly nounwind uwtable }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{!"clang version 7.0.0 "}
