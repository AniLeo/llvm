; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

define void @PR37526(i32* %pz, i32* %px, i32* %py) {
; CHECK-LABEL: @PR37526(
; CHECK-NEXT:    [[T1:%.*]] = bitcast i32* [[PZ:%.*]] to i64*
; CHECK-NEXT:    [[T2:%.*]] = load i32, i32* [[PY:%.*]], align 4
; CHECK-NEXT:    [[T3:%.*]] = load i32, i32* [[PX:%.*]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[T2]], [[T3]]
; CHECK-NEXT:    [[SELECT:%.*]] = select i1 [[CMP]], i32* [[PX]], i32* [[PY]]
; CHECK-NEXT:    [[BC:%.*]] = bitcast i32* [[SELECT]] to i64*
; CHECK-NEXT:    [[R:%.*]] = load i64, i64* [[BC]], align 4
; CHECK-NEXT:    store i64 [[R]], i64* [[T1]], align 4
; CHECK-NEXT:    ret void
;
  %t1 = bitcast i32* %pz to i64*
  %t2 = load i32, i32* %py
  %t3 = load i32, i32* %px
  %cmp = icmp slt i32 %t2, %t3
  %select = select i1 %cmp, i32* %px, i32* %py
  %bc = bitcast i32* %select to i64*
  %r = load i64, i64* %bc
  store i64 %r, i64* %t1
  ret void
}
