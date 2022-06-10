; RUN: opt -passes='module(debugify),function(dce)' -S < %s | FileCheck %s

; CHECK-LABEL: @test
define void @test() {
  %add = add i32 1, 2
; CHECK-NEXT: call void @llvm.dbg.value(metadata i32 1, metadata [[add:![0-9]+]], metadata !DIExpression(DW_OP_plus_uconst, 2, DW_OP_stack_value))
  %sub = sub i32 %add, 1
; CHECK-NEXT: call void @llvm.dbg.value(metadata i32 1, metadata [[sub:![0-9]+]], metadata !DIExpression(DW_OP_plus_uconst, 2, DW_OP_constu, 1, DW_OP_minus, DW_OP_stack_value))
; CHECK-NEXT: ret void
  ret void
}

declare void @llvm.lifetime.start.p0(i64, ptr nocapture) nounwind
declare void @llvm.lifetime.end.p0(i64, ptr nocapture) nounwind

; CHECK-LABEL: @test_lifetime_alloca
define i32 @test_lifetime_alloca() {
; Check that lifetime intrinsics are removed along with the pointer.
; CHECK-NEXT: @llvm.dbg.value
; CHECK-NEXT: ret i32 0
; CHECK-NOT: llvm.lifetime.start
; CHECK-NOT: llvm.lifetime.end
  %i = alloca i8, align 4
  call void @llvm.lifetime.start.p0(i64 -1, ptr %i)
  call void @llvm.lifetime.end.p0(i64 -1, ptr %i)
  ret i32 0
}

; CHECK-LABEL: @test_lifetime_arg
define i32 @test_lifetime_arg(ptr) {
; Check that lifetime intrinsics are removed along with the pointer.
; CHECK-NEXT: llvm.dbg.value
; CHECK-NEXT: ret i32 0
; CHECK-NOT: llvm.lifetime.start
; CHECK-NOT: llvm.lifetime.end
  call void @llvm.lifetime.start.p0(i64 -1, ptr %0)
  call void @llvm.lifetime.end.p0(i64 -1, ptr %0)
  ret i32 0
}

@glob = global i8 1

; CHECK-LABEL: @test_lifetime_global
define i32 @test_lifetime_global() {
; Check that lifetime intrinsics are removed along with the pointer.
; CHECK-NEXT: llvm.dbg.value
; CHECK-NEXT: ret i32 0
; CHECK-NOT: llvm.lifetime.start
; CHECK-NOT: llvm.lifetime.end
  call void @llvm.lifetime.start.p0(i64 -1, ptr @glob)
  call void @llvm.lifetime.end.p0(i64 -1, ptr @glob)
  ret i32 0
}

; CHECK-LABEL: @test_lifetime_bitcast
define i32 @test_lifetime_bitcast(ptr) {
; Check that lifetime intrinsics are NOT removed when the pointer is a bitcast.
; It's not uncommon for two bitcasts to be made: one for lifetime, one for use.
; TODO: Support the above case.
; CHECK-NEXT: bitcast
; CHECK-NEXT: llvm.dbg.value
; CHECK-NEXT: llvm.lifetime.start
; CHECK-NEXT: llvm.lifetime.end
; CHECK-NEXT: ret i32 0
  %2 = bitcast ptr %0 to ptr
  call void @llvm.lifetime.start.p0(i64 -1, ptr %2)
  call void @llvm.lifetime.end.p0(i64 -1, ptr %2)
  ret i32 0
}

; CHECK: [[add]] = !DILocalVariable
; CHECK: [[sub]] = !DILocalVariable
