; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=indvars -S < %s -opaque-pointers | FileCheck %s

declare void @c(ptr)

define void @test(ptr %arg) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[O:%.*]] = getelementptr ptr, ptr [[ARG:%.*]], i64 16
; CHECK-NEXT:    call void @c(ptr [[O]])
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IDX:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[INC]] = add nuw nsw i32 [[IDX]], 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i32 [[INC]], 16
; CHECK-NEXT:    call void @c(ptr [[O]])
; CHECK-NEXT:    br i1 [[C]], label [[LOOP]], label [[END:%.*]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  %o = getelementptr ptr, ptr %arg, i64 16
  call void @c(ptr %o)
  br label %loop
loop:
  %idx = phi i32 [ 1, %entry ], [ %inc, %loop ]
  %inc = add i32 %idx, 1
  %c = icmp ne i32 %inc, 16
  %p = getelementptr ptr, ptr %arg, i32 2
  %p1 = getelementptr ptr, ptr %p, i32 %idx
  %neg = sub i32 0, %idx
  %p2 = getelementptr ptr, ptr %p1, i32 %neg
  call void @c(ptr %p2)
  br i1 %c, label %loop, label %end
end:
  ret void
}
