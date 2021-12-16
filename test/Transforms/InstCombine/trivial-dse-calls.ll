; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture)
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture)

declare void @unknown()
declare void @f(i8*)
declare void @f2(i8*, i8*)

; Basic case for DSEing a trivially dead writing call
define void @test_dead() {
; CHECK-LABEL: @test_dead(
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  call void @f(i8* writeonly nocapture %bitcast) argmemonly nounwind willreturn
  ret void
}

; Add in canonical lifetime intrinsics
define void @test_lifetime() {
; CHECK-LABEL: @test_lifetime(
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %bitcast)
  call void @f(i8* writeonly nocapture %bitcast) argmemonly nounwind willreturn
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %bitcast)
  ret void
}

; Add some unknown calls just to point out that this is use based, not
; instruction order sensitive
define void @test_lifetime2() {
; CHECK-LABEL: @test_lifetime2(
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    call void @unknown()
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %bitcast)
  call void @unknown()
  call void @f(i8* writeonly nocapture %bitcast) argmemonly nounwind willreturn
  call void @unknown()
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %bitcast)
  ret void
}

; As long as the result is unused, we can even remove reads of the alloca
; itself since the write will be dropped.
define void @test_dead_readwrite() {
; CHECK-LABEL: @test_dead_readwrite(
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  call void @f(i8* nocapture %bitcast) argmemonly nounwind willreturn
  ret void
}

define i32 @test_neg_read_after() {
; CHECK-LABEL: @test_neg_read_after(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void @f(i8* nocapture nonnull writeonly [[BITCAST]]) #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    [[RES:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    ret i32 [[RES]]
;
  %a = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  call void @f(i8* writeonly nocapture %bitcast) argmemonly nounwind willreturn
  %res = load i32, i32* %a
  ret i32 %res
}


define void @test_neg_infinite_loop() {
; CHECK-LABEL: @test_neg_infinite_loop(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void @f(i8* nocapture nonnull writeonly [[BITCAST]]) #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  call void @f(i8* writeonly nocapture %bitcast) argmemonly nounwind
  ret void
}

define void @test_neg_throw() {
; CHECK-LABEL: @test_neg_throw(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void @f(i8* nocapture nonnull writeonly [[BITCAST]]) #[[ATTR3:[0-9]+]]
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  call void @f(i8* writeonly nocapture %bitcast) argmemonly willreturn
  ret void
}

define void @test_neg_extra_write() {
; CHECK-LABEL: @test_neg_extra_write(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void @f(i8* nocapture nonnull writeonly [[BITCAST]]) #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  call void @f(i8* writeonly nocapture %bitcast) nounwind willreturn
  ret void
}

; In this case, we can't remove a1 because we need to preserve the write to
; a2, and if we leave the call around, we need memory to pass to the first arg.
define void @test_neg_unmodeled_write() {
; CHECK-LABEL: @test_neg_unmodeled_write(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    [[BITCAST2:%.*]] = bitcast i32* [[A2]] to i8*
; CHECK-NEXT:    call void @f2(i8* nocapture nonnull writeonly [[BITCAST]], i8* nonnull [[BITCAST2]]) #[[ATTR1]]
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %a2 = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  %bitcast2 = bitcast i32* %a2 to i8*
  call void @f2(i8* nocapture writeonly %bitcast, i8* %bitcast2) argmemonly nounwind willreturn
  ret void
}

define i32 @test_neg_captured_by_call() {
; CHECK-LABEL: @test_neg_captured_by_call(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A2:%.*]] = alloca i8*, align 8
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    [[BITCAST2:%.*]] = bitcast i8** [[A2]] to i8*
; CHECK-NEXT:    call void @f2(i8* nonnull writeonly [[BITCAST]], i8* nonnull [[BITCAST2]]) #[[ATTR1]]
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8** [[A2]] to i32**
; CHECK-NEXT:    [[A_COPY_CAST1:%.*]] = load i32*, i32** [[TMP1]], align 8
; CHECK-NEXT:    [[RES:%.*]] = load i32, i32* [[A_COPY_CAST1]], align 4
; CHECK-NEXT:    ret i32 [[RES]]
;
  %a = alloca i32, align 4
  %a2 = alloca i8*, align 4
  %bitcast = bitcast i32* %a to i8*
  %bitcast2 = bitcast i8** %a2 to i8*
  call void @f2(i8* writeonly %bitcast, i8* %bitcast2) argmemonly nounwind willreturn
  %a_copy_cast = load i8*, i8** %a2
  %a_copy = bitcast i8* %a_copy_cast to i32*
  %res = load i32, i32* %a_copy
  ret i32 %res
}

define i32 @test_neg_captured_before() {
; CHECK-LABEL: @test_neg_captured_before(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    call void @f(i8* nocapture nonnull writeonly [[BITCAST]]) #[[ATTR1]]
; CHECK-NEXT:    [[RES:%.*]] = load i32, i32* [[A]], align 4
; CHECK-NEXT:    ret i32 [[RES]]
;
  %a = alloca i32, align 4
  %a2 = alloca i8*, align 4
  %bitcast = bitcast i32* %a to i8*
  %bitcast2 = bitcast i8** %a2 to i8*
  store i8* %bitcast, i8** %a2
  call void @f(i8* writeonly nocapture %bitcast) argmemonly nounwind willreturn
  %a_copy_cast = load i8*, i8** %a2
  %a_copy = bitcast i8* %a_copy_cast to i32*
  %res = load i32, i32* %a_copy
  ret i32 %res
}

; Show that reading from unrelated memory is okay
define void @test_unreleated_read() {
; CHECK-LABEL: @test_unreleated_read(
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %a2 = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  %bitcast2 = bitcast i32* %a2 to i8*
  call void @f2(i8* nocapture writeonly %bitcast, i8* nocapture readonly %bitcast2) argmemonly nounwind willreturn
  ret void
}

; But that removing a capture of an unrelated pointer isn't okay.
define void @test_neg_unreleated_capture() {
; CHECK-LABEL: @test_neg_unreleated_capture(
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[A2:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[BITCAST:%.*]] = bitcast i32* [[A]] to i8*
; CHECK-NEXT:    [[BITCAST2:%.*]] = bitcast i32* [[A2]] to i8*
; CHECK-NEXT:    call void @f2(i8* nocapture nonnull writeonly [[BITCAST]], i8* nonnull readonly [[BITCAST2]]) #[[ATTR1]]
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %a2 = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  %bitcast2 = bitcast i32* %a2 to i8*
  call void @f2(i8* nocapture writeonly %bitcast, i8* readonly %bitcast2) argmemonly nounwind willreturn
  ret void
}

; As long as the result is unused, we can even remove reads of the alloca
; itself since the write will be dropped.
define void @test_self_read() {
; CHECK-LABEL: @test_self_read(
; CHECK-NEXT:    ret void
;
  %a = alloca i32, align 4
  %bitcast = bitcast i32* %a to i8*
  call void @f2(i8* nocapture writeonly %bitcast, i8* nocapture readonly %bitcast) argmemonly nounwind willreturn
  ret void
}

