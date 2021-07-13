; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -mtriple=amdgcn-amd- -amdgpu-annotate-kernel-features %s | FileCheck %s

; Test to ensure recursive functions exhibit proper behaviour
; Test to generate fibonacci numbers

define i32 @fib(i32 %n) #0 {
; CHECK-LABEL: define {{[^@]+}}@fib
; CHECK-SAME: (i32 [[N:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[N]], 0
; CHECK-NEXT:    br i1 [[CMP1]], label [[EXIT:%.*]], label [[CONT1:%.*]]
; CHECK:       cont1:
; CHECK-NEXT:    [[CMP2:%.*]] = icmp eq i32 [[N]], 1
; CHECK-NEXT:    br i1 [[CMP2]], label [[EXIT]], label [[CONT2:%.*]]
; CHECK:       cont2:
; CHECK-NEXT:    [[NM1:%.*]] = sub i32 [[N]], 1
; CHECK-NEXT:    [[FIBM1:%.*]] = call i32 @fib(i32 [[NM1]])
; CHECK-NEXT:    [[NM2:%.*]] = sub i32 [[N]], 2
; CHECK-NEXT:    [[FIBM2:%.*]] = call i32 @fib(i32 [[NM2]])
; CHECK-NEXT:    [[RETVAL:%.*]] = add i32 [[FIBM1]], [[FIBM2]]
; CHECK-NEXT:    ret i32 [[RETVAL]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 1
;
  %cmp1 = icmp eq i32 %n, 0
  br i1 %cmp1, label %exit, label %cont1

cont1:
  %cmp2 = icmp eq i32 %n, 1
  br i1 %cmp2, label %exit, label %cont2

cont2:
  %nm1 = sub i32 %n, 1
  %fibm1 = call i32 @fib(i32 %nm1)
  %nm2 = sub i32 %n, 2
  %fibm2 = call i32 @fib(i32 %nm2)
  %retval = add i32 %fibm1, %fibm2

  ret i32 %retval

exit:
  ret i32 1
}

define amdgpu_kernel void @kernel(i32 addrspace(1)* %m) #1 {
; CHECK-LABEL: define {{[^@]+}}@kernel
; CHECK-SAME: (i32 addrspace(1)* [[M:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    [[R:%.*]] = call i32 @fib(i32 5)
; CHECK-NEXT:    store i32 [[R]], i32 addrspace(1)* [[M]], align 4
; CHECK-NEXT:    ret void
;
  %r = call i32 @fib(i32 5)
  store i32 %r, i32 addrspace(1)* %m
  ret void
}

attributes #1 = { "uniform-work-group-size"="true" }

;.
; CHECK: attributes #[[ATTR0]] = { "uniform-work-group-size"="true" }
; CHECK: attributes #[[ATTR1]] = { "amdgpu-calls" "uniform-work-group-size"="true" }
;.
