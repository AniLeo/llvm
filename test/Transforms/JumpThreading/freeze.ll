; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -jump-threading -S < %s | FileCheck %s

declare i32 @f1()
declare i32 @f2()
declare void @f3()

define i32 @test1(i1 %cond) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[T2:%.*]], label [[F2:%.*]]
; CHECK:       T2:
; CHECK-NEXT:    [[V1:%.*]] = call i32 @f1()
; CHECK-NEXT:    call void @f3()
; CHECK-NEXT:    ret i32 [[V1]]
; CHECK:       F2:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @f2()
; CHECK-NEXT:    ret i32 [[V2]]
;
  br i1 %cond, label %T1, label %F1

T1:
  %v1 = call i32 @f1()
  br label %Merge

F1:
  %v2 = call i32 @f2()
  br label %Merge

Merge:
  %A = phi i1 [true, %T1], [false, %F1]
  %B = phi i32 [%v1, %T1], [%v2, %F1]
  %A.fr = freeze i1 %A
  br i1 %A.fr, label %T2, label %F2

T2:
  call void @f3()
  ret i32 %B

F2:
  ret i32 %B
}

define i32 @test1_cast(i1 %cond) {
; CHECK-LABEL: @test1_cast(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[MERGE_THREAD:%.*]], label [[MERGE:%.*]]
; CHECK:       Merge.thread:
; CHECK-NEXT:    [[V1:%.*]] = call i32 @f1()
; CHECK-NEXT:    br label [[T2:%.*]]
; CHECK:       Merge:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @f2()
; CHECK-NEXT:    [[A:%.*]] = trunc i32 0 to i1
; CHECK-NEXT:    [[A_FR:%.*]] = freeze i1 [[A]]
; CHECK-NEXT:    br i1 [[A_FR]], label [[T2]], label [[F2:%.*]]
; CHECK:       T2:
; CHECK-NEXT:    [[B5:%.*]] = phi i32 [ [[V1]], [[MERGE_THREAD]] ], [ [[V2]], [[MERGE]] ]
; CHECK-NEXT:    call void @f3()
; CHECK-NEXT:    ret i32 [[B5]]
; CHECK:       F2:
; CHECK-NEXT:    ret i32 [[V2]]
;
  br i1 %cond, label %T1, label %F1

T1:
  %v1 = call i32 @f1()
  br label %Merge

F1:
  %v2 = call i32 @f2()
  br label %Merge

Merge:
  %A0 = phi i32 [1, %T1], [0, %F1]
  %B = phi i32 [%v1, %T1], [%v2, %F1]
  %A = trunc i32 %A0 to i1
  %A.fr = freeze i1 %A
  br i1 %A.fr, label %T2, label %F2

T2:
  call void @f3()
  ret i32 %B

F2:
  ret i32 %B
}

define i32 @test1_cast2(i1 %cond) {
; CHECK-LABEL: @test1_cast2(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[MERGE_THREAD:%.*]], label [[MERGE:%.*]]
; CHECK:       Merge.thread:
; CHECK-NEXT:    [[V1:%.*]] = call i32 @f1()
; CHECK-NEXT:    br label [[T2:%.*]]
; CHECK:       Merge:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @f2()
; CHECK-NEXT:    [[A0_FR:%.*]] = freeze i32 0
; CHECK-NEXT:    [[A_FR:%.*]] = trunc i32 [[A0_FR]] to i1
; CHECK-NEXT:    br i1 [[A_FR]], label [[T2]], label [[F2:%.*]]
; CHECK:       T2:
; CHECK-NEXT:    [[B5:%.*]] = phi i32 [ [[V1]], [[MERGE_THREAD]] ], [ [[V2]], [[MERGE]] ]
; CHECK-NEXT:    call void @f3()
; CHECK-NEXT:    ret i32 [[B5]]
; CHECK:       F2:
; CHECK-NEXT:    ret i32 [[V2]]
;
  br i1 %cond, label %T1, label %F1

T1:
  %v1 = call i32 @f1()
  br label %Merge

F1:
  %v2 = call i32 @f2()
  br label %Merge

Merge:
  %A0 = phi i32 [1, %T1], [0, %F1]
  %B = phi i32 [%v1, %T1], [%v2, %F1]
  %A0.fr = freeze i32 %A0
  %A.fr = trunc i32 %A0.fr to i1
  br i1 %A.fr, label %T2, label %F2

T2:
  call void @f3()
  ret i32 %B

F2:
  ret i32 %B
}

define i32 @test1_undef(i1 %cond) {
; CHECK-LABEL: @test1_undef(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[MERGE_THREAD:%.*]], label [[MERGE:%.*]]
; CHECK:       Merge.thread:
; CHECK-NEXT:    [[V1:%.*]] = call i32 @f1()
; CHECK-NEXT:    br label [[T2:%.*]]
; CHECK:       Merge:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @f2()
; CHECK-NEXT:    [[A_FR:%.*]] = freeze i1 undef
; CHECK-NEXT:    br i1 [[A_FR]], label [[T2]], label [[F2:%.*]]
; CHECK:       T2:
; CHECK-NEXT:    [[B4:%.*]] = phi i32 [ [[V1]], [[MERGE_THREAD]] ], [ [[V2]], [[MERGE]] ]
; CHECK-NEXT:    call void @f3()
; CHECK-NEXT:    ret i32 [[B4]]
; CHECK:       F2:
; CHECK-NEXT:    ret i32 [[V2]]
;
  br i1 %cond, label %T1, label %F1

T1:
  %v1 = call i32 @f1()
  br label %Merge

F1:
  %v2 = call i32 @f2()
  br label %Merge

Merge:
  %A = phi i1 [true, %T1], [undef, %F1]
  %B = phi i32 [%v1, %T1], [%v2, %F1]
  %A.fr = freeze i1 %A
  br i1 %A.fr, label %T2, label %F2

T2:
  call void @f3()
  ret i32 %B

F2:
  ret i32 %B
}

define i32 @test2(i1 %cond, i1 %cond2) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[MERGE_THREAD:%.*]], label [[MERGE:%.*]]
; CHECK:       Merge.thread:
; CHECK-NEXT:    [[V1:%.*]] = call i32 @f1()
; CHECK-NEXT:    br label [[T2:%.*]]
; CHECK:       Merge:
; CHECK-NEXT:    [[V2:%.*]] = call i32 @f2()
; CHECK-NEXT:    [[A_FR:%.*]] = freeze i1 [[COND2:%.*]]
; CHECK-NEXT:    br i1 [[A_FR]], label [[T2]], label [[F2:%.*]]
; CHECK:       T2:
; CHECK-NEXT:    [[B4:%.*]] = phi i32 [ [[V1]], [[MERGE_THREAD]] ], [ [[V2]], [[MERGE]] ]
; CHECK-NEXT:    call void @f3()
; CHECK-NEXT:    ret i32 [[B4]]
; CHECK:       F2:
; CHECK-NEXT:    ret i32 [[V2]]
;
  br i1 %cond, label %T1, label %F1

T1:
  %v1 = call i32 @f1()
  br label %Merge

F1:
  %v2 = call i32 @f2()
  br label %Merge

Merge:
  %A = phi i1 [true, %T1], [%cond2, %F1]
  %B = phi i32 [%v1, %T1], [%v2, %F1]
  %A.fr = freeze i1 %A
  br i1 %A.fr, label %T2, label %F2

T2:
  call void @f3()
  ret i32 %B

F2:
  ret i32 %B
}
