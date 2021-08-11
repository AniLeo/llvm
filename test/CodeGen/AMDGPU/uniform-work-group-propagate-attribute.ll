; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -mtriple=amdgcn-amd- -amdgpu-annotate-kernel-features %s | FileCheck -check-prefixes=CHECK,AKF_CHECK %s
; RUN: opt -S -mtriple=amdgcn-amd- -amdgpu-attributor %s | FileCheck -check-prefixes=CHECK,ATTRIBUTOR_CHECK %s

@x = global i32 0

; Propagate the uniform-work-group-attribute from the kernel to callee if it doesn't have it
;.
; CHECK: @[[X:[a-zA-Z0-9_$"\\.-]+]] = global i32 0
;.
define void @func() #0 {
; CHECK-LABEL: define {{[^@]+}}@func
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    store i32 0, i32* @x, align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* @x
  ret void
}

define amdgpu_kernel void @kernel1() #1 {
; CHECK-LABEL: define {{[^@]+}}@kernel1
; CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    call void @func()
; CHECK-NEXT:    ret void
;
  call void @func()
  ret void
}

; External declaration of a function
define weak_odr void @weak_func() #0 {
; CHECK-LABEL: define {{[^@]+}}@weak_func
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    store i32 0, i32* @x, align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* @x
  ret void
}

define amdgpu_kernel void @kernel2() #2 {
; CHECK-LABEL: define {{[^@]+}}@kernel2
; CHECK-SAME: () #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:    call void @weak_func()
; CHECK-NEXT:    ret void
;
  call void @weak_func()
  ret void
}

attributes #0 = { nounwind }
attributes #1 = { "uniform-work-group-size"="false" }
attributes #2 = { "uniform-work-group-size"="true" }
;.
; AKF_CHECK: attributes #[[ATTR0]] = { nounwind "uniform-work-group-size"="false" }
; AKF_CHECK: attributes #[[ATTR1]] = { "amdgpu-calls" "uniform-work-group-size"="false" }
; AKF_CHECK: attributes #[[ATTR2]] = { "amdgpu-calls" "uniform-work-group-size"="true" }
;.
; ATTRIBUTOR_CHECK: attributes #[[ATTR0]] = { nounwind "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_CHECK: attributes #[[ATTR1]] = { "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; ATTRIBUTOR_CHECK: attributes #[[ATTR2]] = { "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="true" }
;.
