; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -mtriple=amdgcn-unknown-unknown -amdgpu-attributor < %s | FileCheck %s

;.
; CHECK: @[[G1:[a-zA-Z0-9_$"\\.-]+]] = global i32* null
; CHECK: @[[G2:[a-zA-Z0-9_$"\\.-]+]] = global i32 0
;.
define weak void @weak() {
; CHECK-LABEL: define {{[^@]+}}@weak
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    call void @internal1()
; CHECK-NEXT:    ret void
;
  call void @internal1()
  ret void
}

@G1 = global i32* null

define internal void @internal1() {
; CHECK-LABEL: define {{[^@]+}}@internal1
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    [[TMP1:%.*]] = load i32*, i32** @G1, align 8
; CHECK-NEXT:    store i32 0, i32* [[TMP1]], align 4
; CHECK-NEXT:    ret void
;
  %1 = load i32*, i32** @G1
  store i32 0, i32* %1
  ret void
}

define amdgpu_kernel void @kernel1() #0 {
; CHECK-LABEL: define {{[^@]+}}@kernel1
; CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    call void @weak()
; CHECK-NEXT:    ret void
;
  call void @weak()
  ret void
}

@G2 = global i32 0

define internal void @internal3() {
; CHECK-LABEL: define {{[^@]+}}@internal3
; CHECK-SAME: () #[[ATTR1]] {
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* @G2, align 4
; CHECK-NEXT:    [[TMP2:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[TMP3:%.*]], label [[TMP4:%.*]]
; CHECK:       3:
; CHECK-NEXT:    call void @internal4()
; CHECK-NEXT:    call void @internal3()
; CHECK-NEXT:    br label [[TMP4]]
; CHECK:       4:
; CHECK-NEXT:    ret void
;
  %1 = load i32, i32* @G2, align 4
  %2 = icmp eq i32 %1, 0
  br i1 %2, label %3, label %4
3:
  call void @internal4()
  call void @internal3()
  br label %4
4:
  ret void
}

define internal void @internal4() {
; CHECK-LABEL: define {{[^@]+}}@internal4
; CHECK-SAME: () #[[ATTR1]] {
; CHECK-NEXT:    store i32 1, i32* @G2, align 4
; CHECK-NEXT:    ret void
;
  store i32 1, i32* @G2, align 4
  ret void
}

define internal void @internal2() {
; CHECK-LABEL: define {{[^@]+}}@internal2
; CHECK-SAME: () #[[ATTR1]] {
; CHECK-NEXT:    call void @internal3()
; CHECK-NEXT:    ret void
;
  call void @internal3()
  ret void
}

define amdgpu_kernel void @kernel2() #0 {
; CHECK-LABEL: define {{[^@]+}}@kernel2
; CHECK-SAME: () #[[ATTR1]] {
; CHECK-NEXT:    call void @internal2()
; CHECK-NEXT:    ret void
;
  call void @internal2()
  ret void
}

attributes #0 = { "uniform-work-group-size"="true" }
;.
; CHECK: attributes #[[ATTR0]] = { "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="false" }
; CHECK: attributes #[[ATTR1]] = { "amdgpu-no-dispatch-id" "amdgpu-no-dispatch-ptr" "amdgpu-no-heap-ptr" "amdgpu-no-hostcall-ptr" "amdgpu-no-implicitarg-ptr" "amdgpu-no-lds-kernel-id" "amdgpu-no-multigrid-sync-arg" "amdgpu-no-queue-ptr" "amdgpu-no-workgroup-id-x" "amdgpu-no-workgroup-id-y" "amdgpu-no-workgroup-id-z" "amdgpu-no-workitem-id-x" "amdgpu-no-workitem-id-y" "amdgpu-no-workitem-id-z" "uniform-work-group-size"="true" }
;.
