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
; AKF_CHECK-LABEL: define {{[^@]+}}@kernel1
; AKF_CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; AKF_CHECK-NEXT:    call void @func()
; AKF_CHECK-NEXT:    ret void
;
; ATTRIBUTOR_CHECK-LABEL: define {{[^@]+}}@kernel1
; ATTRIBUTOR_CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; ATTRIBUTOR_CHECK-NEXT:    call void @func() #[[ATTR4:[0-9]+]]
; ATTRIBUTOR_CHECK-NEXT:    ret void
;
  call void @func()
  ret void
}

; External declaration of a function
define weak_odr void @weak_func() #0 {
; AKF_CHECK-LABEL: define {{[^@]+}}@weak_func
; AKF_CHECK-SAME: () #[[ATTR0]] {
; AKF_CHECK-NEXT:    store i32 0, i32* @x, align 4
; AKF_CHECK-NEXT:    ret void
;
; ATTRIBUTOR_CHECK-LABEL: define {{[^@]+}}@weak_func
; ATTRIBUTOR_CHECK-SAME: () #[[ATTR2:[0-9]+]] {
; ATTRIBUTOR_CHECK-NEXT:    store i32 0, i32* @x, align 4
; ATTRIBUTOR_CHECK-NEXT:    ret void
;
  store i32 0, i32* @x
  ret void
}

define amdgpu_kernel void @kernel2() #2 {
; AKF_CHECK-LABEL: define {{[^@]+}}@kernel2
; AKF_CHECK-SAME: () #[[ATTR2:[0-9]+]] {
; AKF_CHECK-NEXT:    call void @weak_func()
; AKF_CHECK-NEXT:    ret void
;
; ATTRIBUTOR_CHECK-LABEL: define {{[^@]+}}@kernel2
; ATTRIBUTOR_CHECK-SAME: () #[[ATTR3:[0-9]+]] {
; ATTRIBUTOR_CHECK-NEXT:    call void @weak_func() #[[ATTR5:[0-9]+]]
; ATTRIBUTOR_CHECK-NEXT:    ret void
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
; ATTRIBUTOR_CHECK: attributes #[[ATTR0]] = { nounwind writeonly "uniform-work-group-size"="false" }
; ATTRIBUTOR_CHECK: attributes #[[ATTR1]] = { "amdgpu-calls" "uniform-work-group-size"="false" }
; ATTRIBUTOR_CHECK: attributes #[[ATTR2]] = { nounwind "uniform-work-group-size"="false" }
; ATTRIBUTOR_CHECK: attributes #[[ATTR3]] = { "amdgpu-calls" "uniform-work-group-size"="true" }
; ATTRIBUTOR_CHECK: attributes #[[ATTR4]] = { nounwind writeonly }
; ATTRIBUTOR_CHECK: attributes #[[ATTR5]] = { nounwind }
;.
