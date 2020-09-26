; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -basic-aa -dse < %s | FileCheck %s

target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) nounwind
declare void @llvm.lifetime.end.p0i8(i64, i8* nocapture) nounwind
declare void @llvm.memset.p0i8.i8(i8* nocapture, i8, i8, i1) nounwind

define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[A:%.*]] = alloca i8, align 1
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 1, i8* [[A]])
; CHECK-NEXT:    ret void
;
  %A = alloca i8

  store i8 0, i8* %A  ;; Written to by memset
  call void @llvm.lifetime.end.p0i8(i64 1, i8* %A)

  call void @llvm.memset.p0i8.i8(i8* %A, i8 0, i8 -1, i1 false)

  ret void
}

define void @test2(i32* %P) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[Q:%.*]] = getelementptr i32, i32* [[P:%.*]], i32 1
; CHECK-NEXT:    [[R:%.*]] = bitcast i32* [[Q]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* [[R]])
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 4, i8* [[R]])
; CHECK-NEXT:    ret void
;
  %Q = getelementptr i32, i32* %P, i32 1
  %R = bitcast i32* %Q to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %R)
  store i32 0, i32* %Q  ;; This store is dead.
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %R)
  ret void
}

; lifetime.end only marks the first two bytes of %A as dead. Make sure
; `store i8 20, i8* %A.2 is not removed.
define void @test3_lifetime_end_partial() {
; CHECK-LABEL: @test3_lifetime_end_partial(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A_0:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 2, i8* [[A_0]])
; CHECK-NEXT:    [[A_1:%.*]] = getelementptr i8, i8* [[A_0]], i64 1
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 2, i8* [[A_0]])
; CHECK-NEXT:    call void @use(i8* [[A_1]])
; CHECK-NEXT:    ret void
;
  %A = alloca i32

  %A.0 = bitcast i32 * %A to i8*
  call void @llvm.lifetime.start.p0i8(i64 2, i8* %A.0)
  %A.1 = getelementptr i8, i8* %A.0, i64 1
  %A.2 = getelementptr i8, i8* %A.0, i64 2

  store i8 0, i8* %A.0
  store i8 10, i8* %A.1
  store i8 20, i8* %A.2

  call void @llvm.lifetime.end.p0i8(i64 2, i8* %A.0)
  call void @use(i8* %A.1)
  ret void
}

; lifetime.end only marks the first two bytes of %A as dead. Make sure
; `store i8 20, i8* %A.2 is not removed.
define void @test4_lifetime_end_partial_loop() {
; CHECK-LABEL: @test4_lifetime_end_partial_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A_0:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i8 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 2, i8* [[A_0]])
; CHECK-NEXT:    [[A_1:%.*]] = getelementptr i8, i8* [[A_0]], i64 1
; CHECK-NEXT:    [[A_2:%.*]] = getelementptr i8, i8* [[A_0]], i64 2
; CHECK-NEXT:    call void @use(i8* [[A_1]])
; CHECK-NEXT:    store i8 20, i8* [[A_2]], align 1
; CHECK-NEXT:    store i8 10, i8* [[A_1]], align 1
; CHECK-NEXT:    store i8 0, i8* [[A_0]], align 1
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 2, i8* [[A_0]])
; CHECK-NEXT:    [[IV_NEXT]] = add i8 [[IV]], 10
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i8 [[IV_NEXT]], 10
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %A = alloca i32

  %A.0 = bitcast i32 * %A to i8*
  br label %loop

loop:
  %iv = phi i8 [ 0, %entry ], [ %iv.next, %loop ]
  call void @llvm.lifetime.start.p0i8(i64 2, i8* %A.0)
  %A.1 = getelementptr i8, i8* %A.0, i64 1
  %A.2 = getelementptr i8, i8* %A.0, i64 2

  call void @use(i8* %A.1)

  store i8 20, i8* %A.2
  store i8 10, i8* %A.1
  store i8 0, i8* %A.0
  call void @llvm.lifetime.end.p0i8(i64 2, i8* %A.0)

  %iv.next = add i8 %iv, 10
  %exitcond = icmp eq i8 %iv.next, 10
  br i1 %exitcond, label %exit, label %loop

exit:
  ret void
}

; lifetime.end only marks the first two bytes of %A as dead. Make sure
; `store i8 20, i8* %A.2 is not removed.
define void @test5_lifetime_end_partial(i32* %A) {
; CHECK-LABEL: @test5_lifetime_end_partial(
; CHECK-NEXT:    [[A_0:%.*]] = bitcast i32* [[A:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 2, i8* [[A_0]])
; CHECK-NEXT:    [[A_1:%.*]] = getelementptr i8, i8* [[A_0]], i64 1
; CHECK-NEXT:    [[A_2:%.*]] = getelementptr i8, i8* [[A_0]], i64 2
; CHECK-NEXT:    call void @llvm.lifetime.end.p0i8(i64 2, i8* [[A_0]])
; CHECK-NEXT:    call void @use(i8* [[A_1]])
; CHECK-NEXT:    store i8 30, i8* [[A_1]], align 1
; CHECK-NEXT:    store i8 40, i8* [[A_2]], align 1
; CHECK-NEXT:    ret void
;

  %A.0 = bitcast i32 * %A to i8*
  call void @llvm.lifetime.start.p0i8(i64 2, i8* %A.0)
  %A.1 = getelementptr i8, i8* %A.0, i64 1
  %A.2 = getelementptr i8, i8* %A.0, i64 2

  store i8 0, i8* %A.0
  store i8 10, i8* %A.1
  store i8 20, i8* %A.2

  call void @llvm.lifetime.end.p0i8(i64 2, i8* %A.0)

  call void @use(i8* %A.1)
  store i8 30, i8* %A.1
  store i8 40, i8* %A.2
  ret void
}

declare void @use(i8*) readonly
