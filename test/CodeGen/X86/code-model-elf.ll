; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; Run with --no_x86_scrub_rip because we care a lot about how globals are
; accessed in the code model.

; RUN: llc -verify-machineinstrs < %s -relocation-model=static -code-model=small  | FileCheck %s --check-prefix=CHECK --check-prefix=SMALL-STATIC
; RUN: llc -verify-machineinstrs < %s -relocation-model=static -code-model=medium | FileCheck %s --check-prefix=CHECK --check-prefix=MEDIUM-STATIC
; RUN: llc -verify-machineinstrs < %s -relocation-model=static -code-model=large  | FileCheck %s --check-prefix=CHECK --check-prefix=LARGE-STATIC
; RUN: llc -verify-machineinstrs < %s -relocation-model=pic    -code-model=small  | FileCheck %s --check-prefix=CHECK --check-prefix=SMALL-PIC
; RUN: llc -verify-machineinstrs < %s -relocation-model=pic    -code-model=medium | FileCheck %s --check-prefix=CHECK --check-prefix=MEDIUM-PIC
; RUN: llc -verify-machineinstrs < %s -relocation-model=pic    -code-model=large  | FileCheck %s --check-prefix=CHECK --check-prefix=LARGE-PIC

; Generated from this C source:
;
; static int static_data[10];
; int global_data[10] = {1, 2};
; extern int extern_data[10];
;
; int *lea_static_data() { return &static_data[0]; }
; int *lea_global_data() { return &global_data[0]; }
; int *lea_extern_data() { return &extern_data[0]; }
;
; static void static_fn(void) {}
; void global_fn(void) {}
; void extern_fn(void);
;
; typedef void (*void_fn)(void);
; void_fn lea_static_fn() { return &static_fn; }
; void_fn lea_global_fn() { return &global_fn; }
; void_fn lea_extern_fn() { return &extern_fn; }


; ModuleID = 'model.c'
source_filename = "model.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64--linux"

@global_data = dso_local global [10 x i32] [i32 1, i32 2, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0], align 16
@static_data = internal global [10 x i32] zeroinitializer, align 16
@extern_data = external global [10 x i32], align 16
@thread_data = external thread_local global i32, align 4


define dso_local ptr @lea_static_data() #0 {
; SMALL-STATIC-LABEL: lea_static_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $static_data, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_static_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $static_data, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_static_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $static_data, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_static_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    leaq static_data(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_static_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    leaq _GLOBAL_OFFSET_TABLE_(%rip), %rcx
; MEDIUM-PIC-NEXT:    movabsq $static_data@GOTOFF, %rax
; MEDIUM-PIC-NEXT:    addq %rcx, %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_static_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .L0$pb:
; LARGE-PIC-NEXT:    leaq .L0$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L0$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $static_data@GOTOFF, %rax
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    retq
  ret ptr @static_data
}

define dso_local ptr @lea_global_data() #0 {
; SMALL-STATIC-LABEL: lea_global_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $global_data, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_global_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $global_data, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_global_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $global_data, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_global_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    leaq global_data(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_global_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    leaq _GLOBAL_OFFSET_TABLE_(%rip), %rcx
; MEDIUM-PIC-NEXT:    movabsq $global_data@GOTOFF, %rax
; MEDIUM-PIC-NEXT:    addq %rcx, %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_global_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .L1$pb:
; LARGE-PIC-NEXT:    leaq .L1$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L1$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $global_data@GOTOFF, %rax
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    retq
  ret ptr @global_data
}

define dso_local ptr @lea_extern_data() #0 {
; SMALL-STATIC-LABEL: lea_extern_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_extern_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_extern_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $extern_data, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_extern_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_extern_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_extern_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .L2$pb:
; LARGE-PIC-NEXT:    leaq .L2$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L2$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $extern_data@GOT, %rax
; LARGE-PIC-NEXT:    movq (%rcx,%rax), %rax
; LARGE-PIC-NEXT:    retq
  ret ptr @extern_data
}

define dso_local i32 @load_global_data() #0 {
; SMALL-STATIC-LABEL: load_global_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl global_data+8(%rip), %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: load_global_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $global_data, %rax
; MEDIUM-STATIC-NEXT:    movl 8(%rax), %eax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: load_global_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $global_data, %rax
; LARGE-STATIC-NEXT:    movl 8(%rax), %eax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: load_global_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    movl global_data+8(%rip), %eax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: load_global_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    leaq _GLOBAL_OFFSET_TABLE_(%rip), %rax
; MEDIUM-PIC-NEXT:    movabsq $global_data@GOTOFF, %rcx
; MEDIUM-PIC-NEXT:    movl 8(%rax,%rcx), %eax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: load_global_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .L3$pb:
; LARGE-PIC-NEXT:    leaq .L3$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L3$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $global_data@GOTOFF, %rax
; LARGE-PIC-NEXT:    movl 8(%rcx,%rax), %eax
; LARGE-PIC-NEXT:    retq
  %rv = load i32, ptr getelementptr inbounds ([10 x i32], ptr @global_data, i64 0, i64 2)
  ret i32 %rv
}

define dso_local i32 @load_extern_data() #0 {
; SMALL-STATIC-LABEL: load_extern_data:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; SMALL-STATIC-NEXT:    movl 8(%rax), %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: load_extern_data:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; MEDIUM-STATIC-NEXT:    movl 8(%rax), %eax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: load_extern_data:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $extern_data, %rax
; LARGE-STATIC-NEXT:    movl 8(%rax), %eax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: load_extern_data:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; SMALL-PIC-NEXT:    movl 8(%rax), %eax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: load_extern_data:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movq extern_data@GOTPCREL(%rip), %rax
; MEDIUM-PIC-NEXT:    movl 8(%rax), %eax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: load_extern_data:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .L4$pb:
; LARGE-PIC-NEXT:    leaq .L4$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L4$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $extern_data@GOT, %rax
; LARGE-PIC-NEXT:    movq (%rcx,%rax), %rax
; LARGE-PIC-NEXT:    movl 8(%rax), %eax
; LARGE-PIC-NEXT:    retq
  %rv = load i32, ptr getelementptr inbounds ([10 x i32], ptr @extern_data, i64 0, i64 2)
  ret i32 %rv
}

define dso_local void @global_fn() #0 {
; CHECK-LABEL: global_fn:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  ret void
}

define internal void @static_fn() #0 {
; CHECK-LABEL: static_fn:
; CHECK:       # %bb.0:
; CHECK-NEXT:    retq
  ret void
}

declare void @extern_fn()

define dso_local ptr @lea_static_fn() #0 {
; SMALL-STATIC-LABEL: lea_static_fn:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $static_fn, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_static_fn:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $static_fn, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_static_fn:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $static_fn, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_static_fn:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    leaq static_fn(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_static_fn:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movabsq $static_fn, %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_static_fn:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .L7$pb:
; LARGE-PIC-NEXT:    leaq .L7$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L7$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $static_fn@GOTOFF, %rax
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    retq
  ret ptr @static_fn
}

define dso_local ptr @lea_global_fn() #0 {
; SMALL-STATIC-LABEL: lea_global_fn:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movl $global_fn, %eax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_global_fn:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq $global_fn, %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_global_fn:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $global_fn, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_global_fn:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    leaq global_fn(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_global_fn:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movabsq $global_fn, %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_global_fn:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .L8$pb:
; LARGE-PIC-NEXT:    leaq .L8$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L8$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $global_fn@GOTOFF, %rax
; LARGE-PIC-NEXT:    addq %rcx, %rax
; LARGE-PIC-NEXT:    retq
  ret ptr @global_fn
}

define dso_local ptr @lea_extern_fn() #0 {
; SMALL-STATIC-LABEL: lea_extern_fn:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    movq extern_fn@GOTPCREL(%rip), %rax
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: lea_extern_fn:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movq extern_fn@GOTPCREL(%rip), %rax
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: lea_extern_fn:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq $extern_fn, %rax
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: lea_extern_fn:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    movq extern_fn@GOTPCREL(%rip), %rax
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: lea_extern_fn:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    movq extern_fn@GOTPCREL(%rip), %rax
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: lea_extern_fn:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .L9$pb:
; LARGE-PIC-NEXT:    leaq .L9$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L9$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq $extern_fn@GOT, %rax
; LARGE-PIC-NEXT:    movq (%rcx,%rax), %rax
; LARGE-PIC-NEXT:    retq
  ret ptr @extern_fn
}

; FIXME: The result is same for small, medium and large model, because we
; specify pie option in the test case. And the type of tls is initial exec tls.
; For pic code. The large model code for pic tls should be emitted as below.

; .L3:
; leaq	.L3(%rip), %rbx
; movabsq	$_GLOBAL_OFFSET_TABLE_-.L3, %r11
; addq	%r11, %rbx
; leaq	thread_data@TLSGD(%rip), %rdi
; movabsq	$__tls_get_addr@PLTOFF, %rax
; addq	%rbx, %rax
; call	*%rax
; movl	(%rax), %eax

; The medium and small model code for pic tls should be emitted as below.
; data16
; leaq	thread_data@TLSGD(%rip), %rdi
; data16
; data16
; rex64
; callq	__tls_get_addr@PLT
; movl	(%rax), %eax

define dso_local i32 @load_thread_data() #0 {
; CHECK-LABEL: load_thread_data:
; CHECK:       # %bb.0:
; CHECK-NEXT:    movq thread_data@GOTTPOFF(%rip), %rax
; CHECK-NEXT:    movl %fs:(%rax), %eax
; CHECK-NEXT:    retq
  %1 = load i32, ptr @thread_data, align 4
  ret i32 %1
}

define dso_local float @load_constant_pool(float %x) #0 {
; SMALL-STATIC-LABEL: load_constant_pool:
; SMALL-STATIC:       # %bb.0:
; SMALL-STATIC-NEXT:    addss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SMALL-STATIC-NEXT:    retq
;
; MEDIUM-STATIC-LABEL: load_constant_pool:
; MEDIUM-STATIC:       # %bb.0:
; MEDIUM-STATIC-NEXT:    movabsq ${{\.?LCPI[0-9]+_[0-9]+}}, %rax
; MEDIUM-STATIC-NEXT:    addss (%rax), %xmm0
; MEDIUM-STATIC-NEXT:    retq
;
; LARGE-STATIC-LABEL: load_constant_pool:
; LARGE-STATIC:       # %bb.0:
; LARGE-STATIC-NEXT:    movabsq ${{\.?LCPI[0-9]+_[0-9]+}}, %rax
; LARGE-STATIC-NEXT:    addss (%rax), %xmm0
; LARGE-STATIC-NEXT:    retq
;
; SMALL-PIC-LABEL: load_constant_pool:
; SMALL-PIC:       # %bb.0:
; SMALL-PIC-NEXT:    addss {{\.?LCPI[0-9]+_[0-9]+}}(%rip), %xmm0
; SMALL-PIC-NEXT:    retq
;
; MEDIUM-PIC-LABEL: load_constant_pool:
; MEDIUM-PIC:       # %bb.0:
; MEDIUM-PIC-NEXT:    leaq _GLOBAL_OFFSET_TABLE_(%rip), %rax
; MEDIUM-PIC-NEXT:    movabsq ${{\.?LCPI[0-9]+_[0-9]+}}@GOTOFF, %rcx
; MEDIUM-PIC-NEXT:    addss (%rax,%rcx), %xmm0
; MEDIUM-PIC-NEXT:    retq
;
; LARGE-PIC-LABEL: load_constant_pool:
; LARGE-PIC:       # %bb.0:
; LARGE-PIC-NEXT:  .L11$pb:
; LARGE-PIC-NEXT:    leaq .L11$pb(%rip), %rax
; LARGE-PIC-NEXT:    movabsq $_GLOBAL_OFFSET_TABLE_-.L11$pb, %rcx
; LARGE-PIC-NEXT:    addq %rax, %rcx
; LARGE-PIC-NEXT:    movabsq ${{\.?LCPI[0-9]+_[0-9]+}}@GOTOFF, %rax
; LARGE-PIC-NEXT:    addss (%rcx,%rax), %xmm0
; LARGE-PIC-NEXT:    retq
  %a = fadd float %x, 1.0
  ret float %a
}

attributes #0 = { noinline nounwind uwtable }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{!"clang version 7.0.0 "}
