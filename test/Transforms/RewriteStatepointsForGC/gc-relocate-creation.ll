; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -rewrite-statepoints-for-gc -S | FileCheck %s
; RUN: opt < %s -passes=rewrite-statepoints-for-gc -S | FileCheck %s

; This test is to verify gc.relocate can handle pointer to vector of
; pointers (<2 x i32 addrspace(1)*> addrspace(1)* in this case).
; The old scheme to create a gc.relocate of <2 x i32 addrspace(1)*> addrspace(1)*
; type will fail because llvm does not support mangling vector of pointers.
; The new scheme will create all gc.relocate to i8 addrspace(1)* type and
; then bitcast to the correct type.

declare void @foo()

declare void @use(...) "gc-leaf-function"

define void @test1(<2 x i32 addrspace(1)*> addrspace(1)* %obj) gc "statepoint-example" {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @foo, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(<2 x i32 addrspace(1)*> addrspace(1)* [[OBJ:%.*]]) ]
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[OBJ_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[OBJ_RELOCATED]] to <2 x i32 addrspace(1)*> addrspace(1)*
; CHECK-NEXT:    call void (...) @use(<2 x i32 addrspace(1)*> addrspace(1)* [[OBJ_RELOCATED_CASTED]])
; CHECK-NEXT:    ret void
;
entry:

  call void @foo() [ "deopt"() ]
  call void (...) @use(<2 x i32 addrspace(1)*> addrspace(1)* %obj)
  ret void
}
