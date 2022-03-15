; RUN: opt < %s -aa-pipeline=basic-aa -passes=aa-eval -print-all-alias-modref-info -disable-output 2>&1 | FileCheck %s
target datalayout = "e-p:32:32:32-i1:8:32-i8:8:32-i16:16:32-i32:32:32-i64:32:32-f32:32:32-f64:32:32-v64:32:64-v128:32:128-a0:0:32-n32"

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) #0
declare void @llvm.assume(i1) #0

define void @test1(i8* %P, i8* %Q) nounwind ssp {
  tail call void @llvm.assume(i1 true)
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
  load i8, i8* %P
  load i8, i8* %Q
  ret void

; CHECK-LABEL: Function: test1:

; CHECK: MayAlias:	i8* %P, i8* %Q
; CHECK: NoModRef:  Ptr: i8* %P	<->  tail call void @llvm.assume(i1 true)
; CHECK: NoModRef:  Ptr: i8* %Q	<->  tail call void @llvm.assume(i1 true)
; CHECK: Both ModRef:  Ptr: i8* %P	<->  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
; CHECK: Both ModRef:  Ptr: i8* %Q	<->  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
; CHECK: NoModRef:   tail call void @llvm.assume(i1 true) <->   tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
; CHECK: NoModRef:   tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false) <->   tail call void @llvm.assume(i1 true)
}

; Same but with operand bundles
define void @test2(i8* %P, i8* %Q) nounwind ssp {
  tail call void @llvm.assume(i1 true) [ "nonnull"(i8* %P) ]
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
  load i8, i8* %P
  load i8, i8* %Q
  ret void

; CHECK-LABEL: Function: test2:

; CHECK: MayAlias:	i8* %P, i8* %Q
; CHECK: NoModRef:  Ptr: i8* %P	<->  tail call void @llvm.assume(i1 true) [ "nonnull"(i8* %P) ]
; CHECK: NoModRef:  Ptr: i8* %Q	<->  tail call void @llvm.assume(i1 true) [ "nonnull"(i8* %P) ]
; CHECK: Both ModRef:  Ptr: i8* %P	<->  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
; CHECK: Both ModRef:  Ptr: i8* %Q	<->  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
; CHECK: NoModRef:   tail call void @llvm.assume(i1 true) [ "nonnull"(i8* %P) ] <->   tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false)
; CHECK: NoModRef:   tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %P, i8* %Q, i64 12, i1 false) <->   tail call void @llvm.assume(i1 true) [ "nonnull"(i8* %P) ]
}

attributes #0 = { nounwind }
