; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -mtriple=amdgcn-amd-amdhsa -amdgpu-attributor < %s | FileCheck %s

define internal void @indirect() {
; CHECK-LABEL: define {{[^@]+}}@indirect
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    ret void
;
  ret void
}

define internal void @direct() {
; CHECK-LABEL: define {{[^@]+}}@direct
; CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    [[FPTR:%.*]] = alloca void ()*, align 8
; CHECK-NEXT:    store void ()* @indirect, void ()** [[FPTR]], align 8
; CHECK-NEXT:    [[FP:%.*]] = load void ()*, void ()** [[FPTR]], align 8
; CHECK-NEXT:    call void [[FP]]()
; CHECK-NEXT:    ret void
;
  %fptr = alloca void()*
  store void()* @indirect, void()** %fptr
  %fp = load void()*, void()** %fptr
  call void %fp()
  ret void
}

define amdgpu_kernel void @test_direct_indirect_call() {
; CHECK-LABEL: define {{[^@]+}}@test_direct_indirect_call
; CHECK-SAME: () #[[ATTR1]] {
; CHECK-NEXT:    call void @direct()
; CHECK-NEXT:    ret void
;
  call void @direct()
  ret void
}
;.
; CHECK: attributes #[[ATTR0]] = { "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; CHECK: attributes #[[ATTR1]] = { "uniform-work-group-size"="false" }
;.
