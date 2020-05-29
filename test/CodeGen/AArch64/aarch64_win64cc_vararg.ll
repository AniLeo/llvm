; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-linux-gnu | FileCheck %s

define win64cc void @pass_va(i32 %count, ...) nounwind {
; CHECK-LABEL: pass_va:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub sp, sp, #96 // =96
; CHECK-NEXT:    add x8, sp, #40 // =40
; CHECK-NEXT:    add x0, sp, #40 // =40
; CHECK-NEXT:    stp x30, x18, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    stp x1, x2, [sp, #40]
; CHECK-NEXT:    stp x3, x4, [sp, #56]
; CHECK-NEXT:    stp x5, x6, [sp, #72]
; CHECK-NEXT:    str x7, [sp, #88]
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    bl other_func
; CHECK-NEXT:    ldp x30, x18, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    add sp, sp, #96 // =96
; CHECK-NEXT:    ret
entry:
  %ap = alloca i8*, align 8
  %ap1 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap1)
  %ap2 = load i8*, i8** %ap, align 8
  call void @other_func(i8* %ap2)
  ret void
}

declare void @other_func(i8*) local_unnamed_addr

declare void @llvm.va_start(i8*) nounwind
declare void @llvm.va_copy(i8*, i8*) nounwind

define win64cc i8* @f9(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, i64 %a8, ...) nounwind {
; CHECK-LABEL: f9:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    str x18, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    add x8, sp, #24 // =24
; CHECK-NEXT:    add x0, sp, #24 // =24
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    ldr x18, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  %ap = alloca i8*, align 8
  %ap1 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap1)
  %ap2 = load i8*, i8** %ap, align 8
  ret i8* %ap2
}

define win64cc i8* @f8(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, i64 %a7, ...) nounwind {
; CHECK-LABEL: f8:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    str x18, [sp, #-16]! // 8-byte Folded Spill
; CHECK-NEXT:    add x8, sp, #16 // =16
; CHECK-NEXT:    add x0, sp, #16 // =16
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    ldr x18, [sp], #16 // 8-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  %ap = alloca i8*, align 8
  %ap1 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap1)
  %ap2 = load i8*, i8** %ap, align 8
  ret i8* %ap2
}

define win64cc i8* @f7(i64 %a0, i64 %a1, i64 %a2, i64 %a3, i64 %a4, i64 %a5, i64 %a6, ...) nounwind {
; CHECK-LABEL: f7:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    str x18, [sp, #-32]! // 8-byte Folded Spill
; CHECK-NEXT:    add x8, sp, #24 // =24
; CHECK-NEXT:    str x7, [sp, #24]
; CHECK-NEXT:    add x0, sp, #24 // =24
; CHECK-NEXT:    str x8, [sp, #8]
; CHECK-NEXT:    ldr x18, [sp], #32 // 8-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  %ap = alloca i8*, align 8
  %ap1 = bitcast i8** %ap to i8*
  call void @llvm.va_start(i8* %ap1)
  %ap2 = load i8*, i8** %ap, align 8
  ret i8* %ap2
}
