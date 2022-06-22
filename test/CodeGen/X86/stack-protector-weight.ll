; RUN: llc -mtriple=x86_64-apple-darwin -print-after=finalize-isel -enable-selectiondag-sp=true %s -o /dev/null 2>&1 | FileCheck %s --check-prefix=DARWIN-SELDAG
; RUN: llc -mtriple=x86_64-apple-darwin -print-after=finalize-isel -enable-selectiondag-sp=false %s -o /dev/null 2>&1 | FileCheck %s --check-prefix=DARWIN-IR
; RUN: llc -mtriple=i386-pc-windows-msvc -print-after=finalize-isel -enable-selectiondag-sp=true %s -o /dev/null 2>&1 | FileCheck %s -check-prefix=MSVC-SELDAG
; RUN: llc -mtriple=i386-pc-windows-msvc -print-after=finalize-isel -enable-selectiondag-sp=false %s -o /dev/null 2>&1 | FileCheck %s -check-prefix=MSVC-IR

; DARWIN-SELDAG: # Machine code for function test_branch_weights:
; DARWIN-SELDAG: successors: %bb.[[SUCCESS:[0-9]+]](0x7ffff800), %bb.[[FAILURE:[0-9]+]]
; DARWIN-SELDAG: bb.[[FAILURE]]{{[0-9a-zA-Z_.]+}}:
; DARWIN-SELDAG: CALL64pcrel32 &__stack_chk_fail
; DARWIN-SELDAG: bb.[[SUCCESS]]{{[0-9a-zA-Z_.]+}}:

; DARWIN-IR: # Machine code for function test_branch_weights:
; DARWIN-IR: successors: %bb.[[SUCCESS:[0-9]+]](0x7fffffff), %bb.[[FAILURE:[0-9]+]]
; DARWIN-IR: bb.[[SUCCESS]]{{[0-9a-zA-Z_.]+}}:
; DARWIN-IR: bb.[[FAILURE]]{{[0-9a-zA-Z_.]+}}:
; DARWIN-IR: CALL64pcrel32 @__stack_chk_fail

; MSVC-SELDAG: # Machine code for function test_branch_weights:
; MSVC-SELDAG: :: (volatile load (s32) from @__security_cookie)
; MSVC-SELDAG: (store (s32) into stack)
; MSVC-SELDAG: (volatile load (s32) from %stack.0.StackGuardSlot)
; MSVC-SELDAG: CALLpcrel32 @__security_check_cookie

; MSVC always uses selection DAG now.
; MSVC-IR: # Machine code for function test_branch_weights:
; MSVC-IR: :: (volatile load (s32) from @__security_cookie)
; MSVC-IR: (store (s32) into stack)
; MSVC-IR: (volatile load (s32) from %stack.0.StackGuardSlot)
; MSVC-IR: CALLpcrel32 @__security_check_cookie

define i32 @test_branch_weights(i32 %n) #0 {
entry:
  %a = alloca [128 x i32], align 16
  call void @llvm.lifetime.start.p0(i64 512, ptr %a)
  call void @foo2(ptr %a)
  %idxprom = sext i32 %n to i64
  %arrayidx = getelementptr inbounds [128 x i32], ptr %a, i64 0, i64 %idxprom
  %0 = load i32, ptr %arrayidx, align 4
  call void @llvm.lifetime.end.p0(i64 512, ptr %a)
  ret i32 %0
}

declare void @llvm.lifetime.start.p0(i64, ptr nocapture)

declare void @foo2(ptr)

declare void @llvm.lifetime.end.p0(i64, ptr nocapture)

attributes #0 = { sspstrong "stack-protector-buffer-size"="8" }
