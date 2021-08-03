; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-none-linux -O2 < %s | FileCheck %s --check-prefix=CHECK-O2
; RUN: llc -mtriple=aarch64-none-linux -O3 < %s | FileCheck %s --check-prefix=CHECK-O3

; RUN: llc -mtriple=aarch64-none-linux -tail-dup-size=4 < %s | FileCheck %s --check-prefix=CHECK-O2
; RUN: llc -mtriple=aarch64-none-linux -tail-dup-placement-threshold=4 < %s | FileCheck %s --check-prefix=CHECK-O2
; RUN: llc -mtriple=aarch64-none-linux -tail-dup-placement-threshold=6 < %s | FileCheck %s --check-prefix=CHECK-O3

%a = type { %a*, i32, %b }
%b = type { %c }
%c = type { i32, i32, [31 x i8] }

@global_ptr = dso_local local_unnamed_addr global %a* null, align 8
@global_int = dso_local local_unnamed_addr global i32 0, align 4

define dso_local void @testcase(%a** nocapture %arg){
; CHECK-O2-LABEL: testcase:
; CHECK-O2:       // %bb.0: // %entry
; CHECK-O2-NEXT:    adrp x8, global_ptr
; CHECK-O2-NEXT:    ldr x9, [x8, :lo12:global_ptr]
; CHECK-O2-NEXT:    cbz x9, .LBB0_2
; CHECK-O2-NEXT:  // %bb.1: // %if.then
; CHECK-O2-NEXT:    ldr x9, [x9]
; CHECK-O2-NEXT:    str x9, [x0]
; CHECK-O2-NEXT:    ldr x8, [x8, :lo12:global_ptr]
; CHECK-O2-NEXT:    b .LBB0_3
; CHECK-O2-NEXT:  .LBB0_2:
; CHECK-O2-NEXT:    mov x8, xzr
; CHECK-O2-NEXT:  .LBB0_3: // %if.end
; CHECK-O2-NEXT:    adrp x9, global_int
; CHECK-O2-NEXT:    ldr w1, [x9, :lo12:global_int]
; CHECK-O2-NEXT:    add x2, x8, #16
; CHECK-O2-NEXT:    mov w0, #10
; CHECK-O2-NEXT:    b externalfunc
;
; CHECK-O3-LABEL: testcase:
; CHECK-O3:       // %bb.0: // %entry
; CHECK-O3-NEXT:    adrp x8, global_ptr
; CHECK-O3-NEXT:    ldr x9, [x8, :lo12:global_ptr]
; CHECK-O3-NEXT:    cbz x9, .LBB0_2
; CHECK-O3-NEXT:  // %bb.1: // %if.then
; CHECK-O3-NEXT:    ldr x9, [x9]
; CHECK-O3-NEXT:    str x9, [x0]
; CHECK-O3-NEXT:    ldr x8, [x8, :lo12:global_ptr]
; CHECK-O3-NEXT:    adrp x9, global_int
; CHECK-O3-NEXT:    ldr w1, [x9, :lo12:global_int]
; CHECK-O3-NEXT:    add x2, x8, #16
; CHECK-O3-NEXT:    mov w0, #10
; CHECK-O3-NEXT:    b externalfunc
; CHECK-O3-NEXT:  .LBB0_2:
; CHECK-O3-NEXT:    mov x8, xzr
; CHECK-O3-NEXT:    adrp x9, global_int
; CHECK-O3-NEXT:    ldr w1, [x9, :lo12:global_int]
; CHECK-O3-NEXT:    add x2, x8, #16
; CHECK-O3-NEXT:    mov w0, #10
; CHECK-O3-NEXT:    b externalfunc
entry:
  %0 = load %a*, %a** @global_ptr, align 8
  %cmp.not = icmp eq %a* %0, null
  br i1 %cmp.not, label %if.end, label %if.then

if.then:                                          ; preds = %entry
  %1 = getelementptr inbounds %a, %a* %0, i64 0, i32 0
  %2 = load %a*, %a** %1, align 8
  store %a* %2, %a** %arg, align 8
  %.pre = load %a*, %a** @global_ptr, align 8
  br label %if.end

if.end:                                           ; preds = %if.then, %entry
  %3 = phi %a* [ %.pre, %if.then ], [ null, %entry ]
  %4 = load i32, i32* @global_int, align 4
  %5 = getelementptr inbounds %a, %a* %3, i64 0, i32 2, i32 0, i32 1
  tail call void @externalfunc(i32 10, i32 %4, i32* nonnull %5)
  ret void
}

declare dso_local void @externalfunc(i32, i32, i32*)
