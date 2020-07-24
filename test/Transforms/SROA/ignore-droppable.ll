; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -sroa -S -o - < %s | FileCheck %s
; RUN: opt -passes=sroa -S -o - < %s | FileCheck %s

declare void @llvm.assume(i1)
declare void @llvm.lifetime.start.p0i8(i64 %size, i8* nocapture %ptr)
declare void @llvm.lifetime.end.p0i8(i64 %size, i8* nocapture %ptr)

define void @positive_assume_uses(i32* %arg) {
; CHECK-LABEL: @positive_assume_uses(
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i32* [[ARG:%.*]]), "ignore"(i32* undef, i64 2) ]
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "ignore"(i32* undef, i64 8), "nonnull"(i32* [[ARG]]) ]
; CHECK-NEXT:    ret void
;
  %A = alloca i32
  call void @llvm.assume(i1 true) ["nonnull"(i32* %arg), "align"(i32* %A, i64 2)]
  store i32 1, i32* %A
  call void @llvm.assume(i1 true) ["align"(i32* %A, i64 8), "nonnull"(i32* %arg)]
  ret void
}

define void @negative_assume_condition_use() {
; CHECK-LABEL: @negative_assume_condition_use(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[B:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    [[CND:%.*]] = icmp eq i8* [[B]], null
; CHECK-NEXT:    call void @llvm.assume(i1 [[CND]])
; CHECK-NEXT:    store i32 1, i32* [[A]], align 4
; CHECK-NEXT:    ret void
;
  %A = alloca i32
  %B = bitcast i32* %A to i8*
  %cnd = icmp eq i8* %B, null
  call void @llvm.assume(i1 %cnd)
  store i32 1, i32* %A
  ret void
}

define void @positive_multiple_assume_uses() {
; CHECK-LABEL: @positive_multiple_assume_uses(
; CHECK-NEXT:    [[A:%.*]] = alloca { i8, i16 }, align 8
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"({ i8, i16 }* [[A]], i64 8), "align"({ i8, i16 }* [[A]], i64 16) ]
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"({ i8, i16 }* [[A]]), "align"({ i8, i16 }* [[A]], i64 2) ]
; CHECK-NEXT:    ret void
;
  %A = alloca {i8, i16}
  call void @llvm.assume(i1 true) ["align"({i8, i16}* %A, i64 8), "align"({i8, i16}* %A, i64 16)]
  store {i8, i16} zeroinitializer, {i8, i16}* %A
  call void @llvm.assume(i1 true) ["nonnull"({i8, i16}* %A), "align"({i8, i16}* %A, i64 2)]
  ret void
}

define void @positive_gep_assume_uses() {
; CHECK-LABEL: @positive_gep_assume_uses(
; CHECK-NEXT:    [[A:%.*]] = alloca { i8, i16 }, align 8
; CHECK-NEXT:    [[B:%.*]] = getelementptr { i8, i16 }, { i8, i16 }* [[A]], i32 0, i32 0
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "align"(i8* [[B]], i64 8), "align"(i8* [[B]], i64 16) ]
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "nonnull"(i8* [[B]]), "align"(i8* [[B]], i64 2) ]
; CHECK-NEXT:    ret void
;
  %A = alloca {i8, i16}
  %B = getelementptr {i8, i16}, {i8, i16}* %A, i32 0, i32 0
  call void @llvm.lifetime.start.p0i8(i64 2, i8* %B)
  call void @llvm.assume(i1 true) ["align"(i8* %B, i64 8), "align"(i8* %B, i64 16)]
  store {i8, i16} zeroinitializer, {i8, i16}* %A
  call void @llvm.lifetime.end.p0i8(i64 2, i8* %B)
  call void @llvm.assume(i1 true) ["nonnull"(i8* %B), "align"(i8* %B, i64 2)]
  ret void
}

define void @positive_mixed_assume_uses() {
; CHECK-LABEL: @positive_mixed_assume_uses(
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "ignore"(i8* undef), "ignore"(i8* undef, i64 8), "ignore"(i8* undef, i64 16) ]
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "ignore"(i8* undef), "ignore"(i8* undef, i64 2), "ignore"(i8* undef) ]
; CHECK-NEXT:    call void @llvm.assume(i1 true) [ "ignore"(i32* undef), "ignore"(i32* undef, i64 2), "ignore"(i8* undef) ]
; CHECK-NEXT:    ret void
;
  %A = alloca i8
  %B = getelementptr i8, i8* %A, i32 0
  %C = bitcast i8* %A to i32*
  call void @llvm.lifetime.start.p0i8(i64 2, i8* %B)
  call void @llvm.assume(i1 true) ["nonnull"(i8* %B), "align"(i8* %A, i64 8), "align"(i8* %B, i64 16)]
  store i8 1, i8* %A
  call void @llvm.lifetime.end.p0i8(i64 2, i8* %B)
  call void @llvm.assume(i1 true) ["nonnull"(i8* %B), "align"(i8* %A, i64 2), "nonnull"(i8* %A)]
  call void @llvm.assume(i1 true) ["nonnull"(i32* %C), "align"(i32* %C, i64 2), "nonnull"(i8* %A)]
  ret void
}
