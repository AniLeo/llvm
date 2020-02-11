; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -S | FileCheck %s
; RUN: opt < %s -aa-pipeline=basic-aa -passes=dse -enable-dse-memoryssa -S | FileCheck %s
target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind
declare void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* nocapture, i8, i64, i32) nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind
declare void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i32) nounwind
declare void @llvm.init.trampoline(i8*, i8*, i8*)

; PR8576 - Should delete store of 10 even though p/q are may aliases.
define void @test2(i32 *%p, i32 *%q) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    store i32 20, i32* [[Q:%.*]], align 4
; CHECK-NEXT:    store i32 30, i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret void
;
  store i32 10, i32* %p, align 4
  store i32 20, i32* %q, align 4
  store i32 30, i32* %p, align 4
  ret void
}

define void @test5(i32* %Q) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[A:%.*]] = load volatile i32, i32* [[Q:%.*]]
; CHECK-NEXT:    ret void
;
  %a = load volatile i32, i32* %Q
  store i32 %a, i32* %Q
  ret void
}

; Should delete store of 10 even though memset is a may-store to P (P and Q may
; alias).
define void @test6(i32 *%p, i8 *%q) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[Q:%.*]], i8 42, i64 900, i1 false)
; CHECK-NEXT:    store i32 30, i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret void
;
  store i32 10, i32* %p, align 4       ;; dead.
  call void @llvm.memset.p0i8.i64(i8* %q, i8 42, i64 900, i1 false)
  store i32 30, i32* %p, align 4
  ret void
}

; Should delete store of 10 even though memset is a may-store to P (P and Q may
; alias).
define void @test6_atomic(i32* align 4 %p, i8* align 4 %q) {
; CHECK-LABEL: @test6_atomic(
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[Q:%.*]], i8 42, i64 900, i32 4)
; CHECK-NEXT:    store atomic i32 30, i32* [[P:%.*]] unordered, align 4
; CHECK-NEXT:    ret void
;
  store atomic i32 10, i32* %p unordered, align 4       ;; dead.
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %q, i8 42, i64 900, i32 4)
  store atomic i32 30, i32* %p unordered, align 4
  ret void
}

; Should delete store of 10 even though memcpy is a may-store to P (P and Q may
; alias).
define void @test7(i32 *%p, i8 *%q, i8* noalias %r) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[Q:%.*]], i8* [[R:%.*]], i64 900, i1 false)
; CHECK-NEXT:    store i32 30, i32* [[P:%.*]], align 4
; CHECK-NEXT:    ret void
;
  store i32 10, i32* %p, align 4       ;; dead.
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %q, i8* %r, i64 900, i1 false)
  store i32 30, i32* %p, align 4
  ret void
}

; Should delete store of 10 even though memcpy is a may-store to P (P and Q may
; alias).
define void @test7_atomic(i32* align 4 %p, i8* align 4 %q, i8* noalias align 4 %r) {
; CHECK-LABEL: @test7_atomic(
; CHECK-NEXT:    call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 4 [[Q:%.*]], i8* align 4 [[R:%.*]], i64 900, i32 4)
; CHECK-NEXT:    store atomic i32 30, i32* [[P:%.*]] unordered, align 4
; CHECK-NEXT:    ret void
;
  store atomic i32 10, i32* %p unordered, align 4       ;; dead.
  call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 4 %q, i8* align 4 %r, i64 900, i32 4)
  store atomic i32 30, i32* %p unordered, align 4
  ret void
}

; Do not delete stores that are only partially killed.
define i32 @test8() {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    [[V:%.*]] = alloca i32
; CHECK-NEXT:    store i32 1234567, i32* [[V]]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[V]]
; CHECK-NEXT:    ret i32 [[X]]
;
  %V = alloca i32
  store i32 1234567, i32* %V
  %V2 = bitcast i32* %V to i8*
  store i8 0, i8* %V2
  %X = load i32, i32* %V
  ret i32 %X

}

; Test for byval handling.
%struct.x = type { i32, i32, i32, i32 }
define void @test9(%struct.x* byval  %a) nounwind  {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    ret void
;
  %tmp2 = getelementptr %struct.x, %struct.x* %a, i32 0, i32 0
  store i32 1, i32* %tmp2, align 4
  ret void
}

; Test for inalloca handling.
define void @test9_2(%struct.x* inalloca  %a) nounwind  {
; CHECK-LABEL: @test9_2(
; CHECK-NEXT:    ret void
;
  %tmp2 = getelementptr %struct.x, %struct.x* %a, i32 0, i32 0
  store i32 1, i32* %tmp2, align 4
  ret void
}

; DSE should delete the dead trampoline.
declare void @test11f()
define void @test11() {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    ret void
;
  %storage = alloca [10 x i8], align 16		; <[10 x i8]*> [#uses=1]
  %cast = getelementptr [10 x i8], [10 x i8]* %storage, i32 0, i32 0		; <i8*> [#uses=1]
  call void @llvm.init.trampoline( i8* %cast, i8* bitcast (void ()* @test11f to i8*), i8* null )		; <i8*> [#uses=1]
  ret void
}

; PR2599 - load -> store to same address.
define void @test12({ i32, i32 }* %x) nounwind  {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr { i32, i32 }, { i32, i32 }* [[X:%.*]], i32 0, i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = load i32, i32* [[TMP7]], align 4
; CHECK-NEXT:    [[TMP17:%.*]] = sub i32 0, [[TMP8]]
; CHECK-NEXT:    store i32 [[TMP17]], i32* [[TMP7]], align 4
; CHECK-NEXT:    ret void
;
  %tmp4 = getelementptr { i32, i32 }, { i32, i32 }* %x, i32 0, i32 0
  %tmp5 = load i32, i32* %tmp4, align 4
  %tmp7 = getelementptr { i32, i32 }, { i32, i32 }* %x, i32 0, i32 1
  %tmp8 = load i32, i32* %tmp7, align 4
  %tmp17 = sub i32 0, %tmp8
  store i32 %tmp5, i32* %tmp4, align 4
  store i32 %tmp17, i32* %tmp7, align 4
  ret void
}


; %P doesn't escape, the DEAD instructions should be removed.
declare void @test13f()
define i32* @test13() {
; CHECK-LABEL: @test13(
; CHECK-NEXT:    [[PTR:%.*]] = tail call i8* @malloc(i32 4)
; CHECK-NEXT:    [[P:%.*]] = bitcast i8* [[PTR]] to i32*
; CHECK-NEXT:    call void @test13f()
; CHECK-NEXT:    store i32 0, i32* [[P]]
; CHECK-NEXT:    ret i32* [[P]]
;
  %ptr = tail call i8* @malloc(i32 4)
  %P = bitcast i8* %ptr to i32*
  %DEAD = load i32, i32* %P
  %DEAD2 = add i32 %DEAD, 1
  store i32 %DEAD2, i32* %P
  call void @test13f( )
  store i32 0, i32* %P
  ret i32* %P
}

define i32 addrspace(1)* @test13_addrspacecast() {
; CHECK-LABEL: @test13_addrspacecast(
; CHECK-NEXT:    [[P:%.*]] = tail call i8* @malloc(i32 4)
; CHECK-NEXT:    [[P_BC:%.*]] = bitcast i8* [[P]] to i32*
; CHECK-NEXT:    [[P:%.*]] = addrspacecast i32* [[P_BC]] to i32 addrspace(1)*
; CHECK-NEXT:    call void @test13f()
; CHECK-NEXT:    store i32 0, i32 addrspace(1)* [[P]]
; CHECK-NEXT:    ret i32 addrspace(1)* [[P]]
;
  %p = tail call i8* @malloc(i32 4)
  %p.bc = bitcast i8* %p to i32*
  %P = addrspacecast i32* %p.bc to i32 addrspace(1)*
  %DEAD = load i32, i32 addrspace(1)* %P
  %DEAD2 = add i32 %DEAD, 1
  store i32 %DEAD2, i32 addrspace(1)* %P
  call void @test13f( )
  store i32 0, i32 addrspace(1)* %P
  ret i32 addrspace(1)* %P
}

declare noalias i8* @malloc(i32)
declare noalias i8* @calloc(i32, i32)

define void @test14(i32* %Q) {
; CHECK-LABEL: @test14(
; CHECK-NEXT:    ret void
;
  %P = alloca i32
  %DEAD = load i32, i32* %Q
  store i32 %DEAD, i32* %P
  ret void

}

define void @test20() {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    ret void
;
  %m = call i8* @malloc(i32 24)
  store i8 0, i8* %m
  ret void
}

define void @test21() {
; CHECK-LABEL: @test21(
; CHECK-NEXT:    ret void
;
  %m = call i8* @calloc(i32 9, i32 7)
  store i8 0, i8* %m
  ret void
}

define void @test22(i1 %i, i32 %k, i32 %m) nounwind {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    ret void
;
  %k.addr = alloca i32
  %m.addr = alloca i32
  %k.addr.m.addr = select i1 %i, i32* %k.addr, i32* %m.addr
  store i32 0, i32* %k.addr.m.addr, align 4
  ret void
}

; Make sure same sized store to later element is deleted
define void @test24([2 x i32]* %a, i32 %b, i32 %c) nounwind {
; CHECK-LABEL: @test24(
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A:%.*]], i64 0, i64 0
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 1
; CHECK-NEXT:    store i32 [[C:%.*]], i32* [[TMP2]], align 4
; CHECK-NEXT:    ret void
;
  %1 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 0
  store i32 0, i32* %1, align 4
  %2 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 1
  store i32 0, i32* %2, align 4
  %3 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 0
  store i32 %b, i32* %3, align 4
  %4 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 1
  store i32 %c, i32* %4, align 4
  ret void
}

; Remove redundant store if loaded value is in another block.
define i32 @test26(i1 %c, i32* %p) {
; CHECK-LABEL: @test26(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
entry:
  %v = load i32, i32* %p, align 4
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  store i32 %v, i32* %p, align 4
  br label %bb3
bb3:
  ret i32 0
}

; Remove redundant store if loaded value is in another block.
define i32 @test27(i1 %c, i32* %p) {
; CHECK-LABEL: @test27(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
entry:
  %v = load i32, i32* %p, align 4
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  br label %bb3
bb3:
  store i32 %v, i32* %p, align 4
  ret i32 0
}

declare void @unknown_func()

; Don't remove redundant store because of unknown call.
define i32 @test30(i1 %c, i32* %p, i32 %i) {
; CHECK-LABEL: @test30(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[P:%.*]], align 4
; CHECK-NEXT:    br i1 [[C:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @unknown_func()
; CHECK-NEXT:    br label [[BB3]]
; CHECK:       bb3:
; CHECK-NEXT:    store i32 [[V]], i32* [[P]], align 4
; CHECK-NEXT:    ret i32 0
;
entry:
  %v = load i32, i32* %p, align 4
  br i1 %c, label %bb1, label %bb2
bb1:
  br label %bb3
bb2:
  ; Might overwrite value at %p
  call void @unknown_func()
  br label %bb3
bb3:
  store i32 %v, i32* %p, align 4
  ret i32 0
}

; Remove redundant store if loaded value is in another block inside a loop.
define i32 @test31(i1 %c, i32* %p, i32 %i) {
; CHECK-LABEL: @test31(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br i1 undef, label [[BB1]], label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    ret i32 0
;
entry:
  %v = load i32, i32* %p, align 4
  br label %bb1
bb1:
  store i32 %v, i32* %p, align 4
  br i1 undef, label %bb1, label %bb2
bb2:
  ret i32 0
}

; Remove redundant store, which is in the lame loop as the load.
define i32 @test33(i1 %c, i32* %p, i32 %i) {
; CHECK-LABEL: @test33(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB1:%.*]]
; CHECK:       bb1:
; CHECK-NEXT:    br label [[BB2:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    call void @unknown_func()
; CHECK-NEXT:    br i1 undef, label [[BB1]], label [[BB3:%.*]]
; CHECK:       bb3:
; CHECK-NEXT:    ret i32 0
;
entry:
  br label %bb1
bb1:
  %v = load i32, i32* %p, align 4
  br label %bb2
bb2:
  store i32 %v, i32* %p, align 4
  ; Might read and overwrite value at %p, but doesn't matter.
  call void @unknown_func()
  br i1 undef, label %bb1, label %bb3
bb3:
  ret i32 0
}

define void @test43(i32* %P, i32* noalias %Q) {
; CHECK-LABEL: @test43(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 50331649, i32* [[P:%.*]]
; CHECK-NEXT:    store i32 2, i32* [[Q:%.*]]
; CHECK-NEXT:    ret void
;
entry:
  store i32 1, i32* %P
  %P2 = bitcast i32* %P to i8*
  store i32 2, i32* %Q
  store i8 3, i8* %P2
  ret void
}

define void @test43a(i32* %P, i32* noalias %Q) {
; CHECK-LABEL: @test43a(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store atomic i32 50331649, i32* [[P:%.*]] unordered, align 4
; CHECK-NEXT:    store atomic i32 2, i32* [[Q:%.*]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  store atomic i32 1, i32* %P unordered, align 4
  %P2 = bitcast i32* %P to i8*
  store atomic i32 2, i32* %Q unordered, align 4
  store atomic i8 3, i8* %P2 unordered, align 4
  ret void
}
