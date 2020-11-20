; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs < %s | FileCheck %s
; A collection of basic functionality tests for statepoint lowering - most
; interesting cornercases are exercised through the x86 tests.

target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "aarch64-unknown-linux-gnu"

%struct = type { i64, i64 }

declare zeroext i1 @return_i1()
declare zeroext i32 @return_i32()
declare i32* @return_i32ptr()
declare float @return_float()
declare %struct @return_struct()
declare void @varargf(i32, ...)

define i1 @test_i1_return() gc "statepoint-example" {
; CHECK-LABEL: test_i1_return:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    bl return_i1
; CHECK-NEXT:  .Ltmp2:
; CHECK-NEXT:    and w0, w0, #0x1
; CHECK-NEXT:    ret
; This is just checking that a i1 gets lowered normally when there's no extra
; state arguments to the statepoint
entry:
  %safepoint_token = tail call token (i64, i32, i1 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i1f(i64 0, i32 0, i1 ()* @return_i1, i32 0, i32 0, i32 0, i32 0)
  %call1 = call zeroext i1 @llvm.experimental.gc.result.i1(token %safepoint_token)
  ret i1 %call1
}

define i32 @test_i32_return() gc "statepoint-example" {
; CHECK-LABEL: test_i32_return:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    bl return_i32
; CHECK-NEXT:  .Ltmp3:
; CHECK-NEXT:    ret
entry:
  %safepoint_token = tail call token (i64, i32, i32 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i32f(i64 0, i32 0, i32 ()* @return_i32, i32 0, i32 0, i32 0, i32 0)
  %call1 = call zeroext i32 @llvm.experimental.gc.result.i32(token %safepoint_token)
  ret i32 %call1
}

define i32* @test_i32ptr_return() gc "statepoint-example" {
; CHECK-LABEL: test_i32ptr_return:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    bl return_i32ptr
; CHECK-NEXT:  .Ltmp4:
; CHECK-NEXT:    ret
entry:
  %safepoint_token = tail call token (i64, i32, i32* ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_p0i32f(i64 0, i32 0, i32* ()* @return_i32ptr, i32 0, i32 0, i32 0, i32 0)
  %call1 = call i32* @llvm.experimental.gc.result.p0i32(token %safepoint_token)
  ret i32* %call1
}

define float @test_float_return() gc "statepoint-example" {
; CHECK-LABEL: test_float_return:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    bl return_float
; CHECK-NEXT:  .Ltmp5:
; CHECK-NEXT:    ret
entry:
  %safepoint_token = tail call token (i64, i32, float ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_f32f(i64 0, i32 0, float ()* @return_float, i32 0, i32 0, i32 0, i32 0)
  %call1 = call float @llvm.experimental.gc.result.f32(token %safepoint_token)
  ret float %call1
}

define %struct @test_struct_return() gc "statepoint-example" {
; CHECK-LABEL: test_struct_return:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    bl return_struct
; CHECK-NEXT:  .Ltmp6:
; CHECK-NEXT:    ret
entry:
  %safepoint_token = tail call token (i64, i32, %struct ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_structf(i64 0, i32 0, %struct ()* @return_struct, i32 0, i32 0, i32 0, i32 0)
  %call1 = call %struct @llvm.experimental.gc.result.struct(token %safepoint_token)
  ret %struct %call1
}

define i1 @test_relocate(i32 addrspace(1)* %a) gc "statepoint-example" {
; CHECK-LABEL: test_relocate:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub sp, sp, #16 // =16
; CHECK-NEXT:    .cfi_def_cfa_offset 16
; CHECK-NEXT:    str x0, [sp, #8]
; CHECK-NEXT:    bl return_i1
; CHECK-NEXT:  .Ltmp7:
; CHECK-NEXT:    and w0, w0, #0x1
; CHECK-NEXT:    add sp, sp, #16 // =16
; CHECK-NEXT:    ret
; Check that an ununsed relocate has no code-generation impact
entry:
  %safepoint_token = tail call token (i64, i32, i1 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i1f(i64 0, i32 0, i1 ()* @return_i1, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32 addrspace(1)* %a)]
  %call1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %call2 = call zeroext i1 @llvm.experimental.gc.result.i1(token %safepoint_token)
  ret i1 %call2
}

define void @test_void_vararg() gc "statepoint-example" {
; CHECK-LABEL: test_void_vararg:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    mov w0, #42
; CHECK-NEXT:    mov w1, #43
; CHECK-NEXT:    bl varargf
; CHECK-NEXT:  .Ltmp8:
; CHECK-NEXT:    ret
; Check a statepoint wrapping a *void* returning vararg function works
entry:
  %safepoint_token = tail call token (i64, i32, void (i32, ...)*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidi32varargf(i64 0, i32 0, void (i32, ...)* @varargf, i32 2, i32 0, i32 42, i32 43, i32 0, i32 0)
  ;; if we try to use the result from a statepoint wrapping a
  ;; non-void-returning varargf, we will experience a crash.
  ret void
}

define i1 @test_i1_return_patchable() gc "statepoint-example" {
; CHECK-LABEL: test_i1_return_patchable:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    nop
; CHECK-NEXT:  .Ltmp9:
; CHECK-NEXT:    and w0, w0, #0x1
; CHECK-NEXT:    ret
; A patchable variant of test_i1_return
entry:
  %safepoint_token = tail call token (i64, i32, i1 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i1f(i64 0, i32 4, i1 ()*null, i32 0, i32 0, i32 0, i32 0)
  %call1 = call zeroext i1 @llvm.experimental.gc.result.i1(token %safepoint_token)
  ret i1 %call1
}

declare void @consume(i32 addrspace(1)* %obj)

define i1 @test_cross_bb(i32 addrspace(1)* %a, i1 %external_cond) gc "statepoint-example" {
; CHECK-LABEL: test_cross_bb:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    str x30, [sp, #-32]! // 8-byte Folded Spill
; CHECK-NEXT:    stp x20, x19, [sp, #16] // 16-byte Folded Spill
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    .cfi_offset w19, -8
; CHECK-NEXT:    .cfi_offset w20, -16
; CHECK-NEXT:    .cfi_offset w30, -32
; CHECK-NEXT:    mov w20, w1
; CHECK-NEXT:    str x0, [sp, #8]
; CHECK-NEXT:    bl return_i1
; CHECK-NEXT:  .Ltmp10:
; CHECK-NEXT:    tbz w20, #0, .LBB8_2
; CHECK-NEXT:  // %bb.1: // %left
; CHECK-NEXT:    mov w19, w0
; CHECK-NEXT:    ldr x0, [sp, #8]
; CHECK-NEXT:    bl consume
; CHECK-NEXT:    and w0, w19, #0x1
; CHECK-NEXT:    b .LBB8_3
; CHECK-NEXT:  .LBB8_2: // %right
; CHECK-NEXT:    mov w0, #1
; CHECK-NEXT:  .LBB8_3: // %right
; CHECK-NEXT:    ldp x20, x19, [sp, #16] // 16-byte Folded Reload
; CHECK-NEXT:    ldr x30, [sp], #32 // 8-byte Folded Reload
; CHECK-NEXT:    ret
entry:
  %safepoint_token = tail call token (i64, i32, i1 ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_i1f(i64 0, i32 0, i1 ()* @return_i1, i32 0, i32 0, i32 0, i32 0) ["gc-live" (i32 addrspace(1)* %a)]
  br i1 %external_cond, label %left, label %right

left:
  %call1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %call2 = call zeroext i1 @llvm.experimental.gc.result.i1(token %safepoint_token)
  call void @consume(i32 addrspace(1)* %call1)
  ret i1 %call2

right:
  ret i1 true
}

%struct2 = type { i64, i64, i64 }

declare void @consume_attributes(i32, i8* nest, i32, %struct2* byval(%struct2))

define void @test_attributes(%struct2* byval(%struct2) %s) gc "statepoint-example" {
; CHECK-LABEL: test_attributes:
; CHECK:       // %bb.0: // %entry
; CHECK-NEXT:    sub sp, sp, #32 // =32
; CHECK-NEXT:    .cfi_def_cfa_offset 32
; CHECK-NEXT:    ldr x8, [sp, #48]
; CHECK-NEXT:    ldr q0, [sp, #32]
; CHECK-NEXT:    mov w0, #42
; CHECK-NEXT:    mov w1, #17
; CHECK-NEXT:    mov x18, xzr
; CHECK-NEXT:    str x8, [sp, #16]
; CHECK-NEXT:    str q0, [sp]
; CHECK-NEXT:    bl consume_attributes
; CHECK-NEXT:  .Ltmp11:
; CHECK-NEXT:    add sp, sp, #32 // =32
; CHECK-NEXT:    ret
entry:
; Check that arguments with attributes are lowered correctly.
; We call a function that has a nest argument and a byval argument.
  %statepoint_token = call token (i64, i32, void (i32, i8*, i32, %struct2*)*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidi32p0i8i32p0s_struct2sf(i64 0, i32 0, void (i32, i8*, i32, %struct2*)* @consume_attributes, i32 4, i32 0, i32 42, i8* nest null, i32 17, %struct2* byval(%struct2) %s, i32 0, i32 0)
  ret void
}

declare token @llvm.experimental.gc.statepoint.p0f_i1f(i64, i32, i1 ()*, i32, i32, ...)
declare i1 @llvm.experimental.gc.result.i1(token)

declare token @llvm.experimental.gc.statepoint.p0f_i32f(i64, i32, i32 ()*, i32, i32, ...)
declare i32 @llvm.experimental.gc.result.i32(token)

declare token @llvm.experimental.gc.statepoint.p0f_p0i32f(i64, i32, i32* ()*, i32, i32, ...)
declare i32* @llvm.experimental.gc.result.p0i32(token)

declare token @llvm.experimental.gc.statepoint.p0f_f32f(i64, i32, float ()*, i32, i32, ...)
declare float @llvm.experimental.gc.result.f32(token)

declare token @llvm.experimental.gc.statepoint.p0f_structf(i64, i32, %struct ()*, i32, i32, ...)
declare %struct @llvm.experimental.gc.result.struct(token)

declare token @llvm.experimental.gc.statepoint.p0f_isVoidi32varargf(i64, i32, void (i32, ...)*, i32, i32, ...)

declare token @llvm.experimental.gc.statepoint.p0f_isVoidi32p0i8i32p0s_struct2sf(i64, i32, void (i32, i8*, i32, %struct2*)*, i32, i32, ...)

declare i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token, i32, i32)
