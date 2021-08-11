; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -mtriple=amdgcn-amd- -amdgpu-annotate-kernel-features %s | FileCheck -check-prefixes=CHECK,AKF_CHECK %s
; RUN: opt -S -mtriple=amdgcn-amd- -amdgpu-attributor %s | FileCheck -check-prefixes=CHECK,ATTRIBUTOR_CHECK %s

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
; AKF_CHECK-LABEL: define {{[^@]+}}@kernel1
; AKF_CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; AKF_CHECK-NEXT:    call void @foo()
; AKF_CHECK-NEXT:    ret void
;
; ATTRIBUTOR_CHECK-LABEL: define {{[^@]+}}@kernel1
; ATTRIBUTOR_CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; ATTRIBUTOR_CHECK-NEXT:    call void @foo() #[[ATTR2:[0-9]+]]
; ATTRIBUTOR_CHECK-NEXT:    ret void
;
  call void @foo()
  ret void
}

attributes #0 = { "uniform-work-group-size"="true" }
;.
; AKF_CHECK: attributes #[[ATTR0]] = { "uniform-work-group-size"="false" }
; AKF_CHECK: attributes #[[ATTR1]] = { "amdgpu-calls" "uniform-work-group-size"="false" }
;.
; ATTRIBUTOR_CHECK: attributes #[[ATTR0]] = { nounwind writeonly "uniform-work-group-size"="false" }
; ATTRIBUTOR_CHECK: attributes #[[ATTR1]] = { "uniform-work-group-size"="false" }
; ATTRIBUTOR_CHECK: attributes #[[ATTR2]] = { nounwind writeonly }
;.
