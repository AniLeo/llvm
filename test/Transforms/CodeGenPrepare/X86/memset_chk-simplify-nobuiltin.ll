; RUN: opt -S -disable-simplify-libcalls -codegenprepare < %s | FileCheck %s
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"

; This is a workaround for PR23093: when building with -mkernel/-fno-builtin,
; we still generate fortified library calls.

; Check that we ignore two things:
; - attribute nobuiltin
; - TLI::has (always returns false thanks to -disable-simplify-libcalls)

; CHECK-NOT: _chk
; CHECK: call void @llvm.memset.p0i8.i64(i8* %dst, i8 0, i64 %len, i32 1, i1 false)
define void @test_nobuiltin(i8* %dst, i64 %len) {
  call i8* @__memset_chk(i8* %dst, i32 0, i64 %len, i64 -1) nobuiltin
  ret void
}

declare i8* @__memset_chk(i8*, i32, i64, i64)
