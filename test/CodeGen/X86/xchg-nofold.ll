; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=x86_64-linux-gnu < %s | FileCheck %s

%"struct.std::atomic" = type { %"struct.std::atomic_bool" }
%"struct.std::atomic_bool" = type { %"struct.std::__atomic_base" }
%"struct.std::__atomic_base" = type { i8 }

; CHECK-LABEL: _Z3fooRSt6atomicIbEb
define zeroext i1 @_Z3fooRSt6atomicIbEb(%"struct.std::atomic"* nocapture dereferenceable(1) %a, i1 returned zeroext %b) nounwind {
; CHECK-LABEL: _Z3fooRSt6atomicIbEb:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    pushq %rax
; CHECK-NEXT:    movl %esi, %eax
; CHECK-NEXT:    movq %rdi, %rcx
; CHECK-NEXT:    shrq $3, %rcx
; CHECK-NEXT:    movb 2147450880(%rcx), %cl
; CHECK-NEXT:    testb %cl, %cl
; CHECK-NEXT:    je .LBB0_3
; CHECK-NEXT:  # %bb.1:
; CHECK-NEXT:    movl %edi, %edx
; CHECK-NEXT:    andb $7, %dl
; CHECK-NEXT:    cmpb %cl, %dl
; CHECK-NEXT:    jge .LBB0_2
; CHECK-NEXT:  .LBB0_3:
; CHECK-NEXT:    movl %eax, %ecx
; CHECK-NEXT:    xchgb %cl, (%rdi)
; CHECK-NEXT:    # kill: def $al killed $al killed $eax
; CHECK-NEXT:    popq %rcx
; CHECK-NEXT:    retq
; CHECK-NEXT:  .LBB0_2:
; CHECK-NEXT:    callq __asan_report_store1
; CHECK-NEXT:    #APP
; CHECK-NEXT:    #NO_APP
entry:
  %frombool.i.i = zext i1 %b to i8
  %_M_i.i.i = getelementptr inbounds %"struct.std::atomic", %"struct.std::atomic"* %a, i64 0, i32 0, i32 0, i32 0
  %0 = ptrtoint i8* %_M_i.i.i to i64
  %1 = lshr i64 %0, 3
  %2 = add i64 %1, 2147450880
  %3 = inttoptr i64 %2 to i8*
  %4 = load i8, i8* %3
  %5 = icmp ne i8 %4, 0
  br i1 %5, label %6, label %11

; <label>:6:                                      ; preds = %entry
  %7 = and i64 %0, 7
  %8 = trunc i64 %7 to i8
  %9 = icmp sge i8 %8, %4
  br i1 %9, label %10, label %11

; <label>:10:                                     ; preds = %6
  call void @__asan_report_store1(i64 %0)
  call void asm sideeffect "", ""()
  unreachable

; <label>:11:                                     ; preds = %6, %entry
  store atomic i8 %frombool.i.i, i8* %_M_i.i.i seq_cst, align 1
  ret i1 %b
}

declare void @__asan_report_store1(i64)
