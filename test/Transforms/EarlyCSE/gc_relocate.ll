; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -early-cse -earlycse-debug-hash -S < %s | FileCheck %s

declare void @func()
declare i32 @"personality_function"()

define i1 @test_call(i32 addrspace(1)* %in) gc "statepoint-example" {
; CHECK-LABEL: @test_call(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN:%.*]], i32 addrspace(1)* [[IN]]) ]
; CHECK-NEXT:    [[BASE:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[SAFEPOINT_TOKEN2:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[BASE]], i32 addrspace(1)* [[BASE]]) ]
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    [[BASE_RELOC:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN2]], i32 0, i32 0)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 addrspace(1)* [[BASE_RELOC]], null
; CHECK-NEXT:    ret i1 [[CMP1]]
;
entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in, i32 addrspace(1)* %in)]
  %base = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %derived = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 1)
  %safepoint_token2 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %base, i32 addrspace(1)* %derived)]
  br label %next

next:
  %base_reloc = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 0)
  %derived_reloc = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 1)
  %cmp1 = icmp eq i32 addrspace(1)* %base_reloc, null
  %cmp2 = icmp eq i32 addrspace(1)* %derived_reloc, null
  %cmp = and i1 %cmp1, %cmp2
  ret i1 %cmp
}

; Negative test: Check that relocates from different statepoints are not CSE'd
define i1 @test_two_calls(i32 addrspace(1)* %in1, i32 addrspace(1)* %in2) gc "statepoint-example" {
; CHECK-LABEL: @test_two_calls(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN1:%.*]], i32 addrspace(1)* [[IN2:%.*]]) ]
; CHECK-NEXT:    [[IN1_RELOC1:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[IN2_RELOC1:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    [[SAFEPOINT_TOKEN2:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN1_RELOC1]], i32 addrspace(1)* [[IN2_RELOC1]]) ]
; CHECK-NEXT:    [[IN1_RELOC2:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN2]], i32 0, i32 1)
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 addrspace(1)* [[IN1_RELOC2]], null
; CHECK-NEXT:    ret i1 [[CMP1]]
;
entry:
  %safepoint_token = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in1, i32 addrspace(1)* %in2)]
  %in1.reloc1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  %in2.reloc1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 1, i32 1)
  %safepoint_token2 = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in1.reloc1, i32 addrspace(1)* %in2.reloc1)]
  %in1.reloc2 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 1)
  %in2.reloc2 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token2,  i32 0, i32 1)
  %cmp1 = icmp eq i32 addrspace(1)* %in1.reloc2, null
  %cmp2 = icmp eq i32 addrspace(1)* %in2.reloc2, null
  %cmp = and i1 %cmp1, %cmp2
  ret i1 %cmp
}

; Negative test: Check that relocates from normal and exceptional pathes are not be CSE'd
define i32 addrspace(1)* @test_invoke(i32 addrspace(1)* %in) gc "statepoint-example" personality i32 ()* @"personality_function" {
; CHECK-LABEL: @test_invoke(
; CHECK-NEXT:    [[SAFEPOINT_TOKEN:%.*]] = invoke token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) [ "gc-live"(i32 addrspace(1)* [[IN:%.*]]) ]
; CHECK-NEXT:    to label [[INVOKE_NORMAL_DEST:%.*]] unwind label [[EXCEPTIONAL_RETURN:%.*]]
; CHECK:       invoke_normal_dest:
; CHECK-NEXT:    [[OUT:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[SAFEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    ret i32 addrspace(1)* [[OUT]]
; CHECK:       exceptional_return:
; CHECK-NEXT:    [[LANDING_PAD:%.*]] = landingpad token
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    [[OUT1:%.*]] = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token [[LANDING_PAD]], i32 0, i32 0)
; CHECK-NEXT:    ret i32 addrspace(1)* [[OUT1]]
;
  %safepoint_token = invoke token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 0, i32 0, void ()* @func, i32 0, i32 0, i32 0, i32 0) ["gc-live"(i32 addrspace(1)* %in)]
  to label %invoke_normal_dest unwind label %exceptional_return

invoke_normal_dest:
  %out = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %safepoint_token,  i32 0, i32 0)
  ret i32 addrspace(1)* %out

exceptional_return:
  %landing_pad = landingpad token
  cleanup
  %out1 = call i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token %landing_pad, i32 0, i32 0)
  ret i32 addrspace(1)* %out1
}

declare token @llvm.experimental.gc.statepoint.p0f_isVoidf(i64, i32, void ()*, i32, i32, ...)
declare i32 addrspace(1)* @llvm.experimental.gc.relocate.p1i32(token, i32, i32)
