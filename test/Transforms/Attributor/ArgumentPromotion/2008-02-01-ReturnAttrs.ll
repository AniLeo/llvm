; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=6 -S < %s | FileCheck %s

define internal i32 @deref(i32* %x) nounwind {
; CHECK-LABEL: define {{[^@]+}}@deref
; CHECK-SAME: (i32 [[TMP0:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X_PRIV:%.*]] = alloca i32
; CHECK-NEXT:    store i32 [[TMP0]], i32* [[X_PRIV]]
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[X_PRIV]], align 4
; CHECK-NEXT:    ret i32 [[TMP2]]
;
entry:
  %tmp2 = load i32, i32* %x, align 4
  ret i32 %tmp2
}

define i32 @f(i32 %x) {
; CHECK-LABEL: define {{[^@]+}}@f
; CHECK-SAME: (i32 [[X:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X_ADDR:%.*]] = alloca i32
; CHECK-NEXT:    store i32 [[X]], i32* [[X_ADDR]], align 4
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[X_ADDR]], align 1
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @deref(i32 [[TMP0]])
; CHECK-NEXT:    ret i32 [[TMP1]]
;
entry:
  %x_addr = alloca i32
  store i32 %x, i32* %x_addr, align 4
  %tmp1 = call i32 @deref( i32* %x_addr ) nounwind
  ret i32 %tmp1
}
