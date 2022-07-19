; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -mtriple=amdgcn-amd- -amdgpu-attributor %s | FileCheck %s

; If the kernel does not have the uniform-work-group-attribute, set both callee and caller as false
; We write to a global so that the attributor don't deletes the function.

@x = global i32 0

;.
; CHECK: @[[X:[a-zA-Z0-9_$"\\.-]+]] = global i32 0
;.
define void @foo() #0 {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    store i32 0, i32* @x, align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* @x
  ret void
}

define amdgpu_kernel void @kernel1() #1 {
; CHECK-LABEL: define {{[^@]+}}@kernel1
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    ret void
;
  call void @foo()
  ret void
}

attributes #0 = { "uniform-work-group-size"="true" }
;.
; CHECK: attributes #[[ATTR0]] = { "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
;.
