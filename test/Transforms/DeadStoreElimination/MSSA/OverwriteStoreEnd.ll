; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -enable-dse-memoryssa -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"

%struct.vec2 = type { <4 x i32>, <4 x i32> }
%struct.vec2plusi = type { <4 x i32>, <4 x i32>, i32 }

@glob1 = global %struct.vec2 zeroinitializer, align 16
@glob2 = global %struct.vec2plusi zeroinitializer, align 16

define void @write24to28(i32* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write24to28(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 24, i1 false)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    store i32 1, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %p, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i1 false)
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 7
  store i32 1, i32* %arrayidx1, align 4
  ret void
}

define void @write24to28_atomic(i32* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write24to28_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 24, i32 4)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    store atomic i32 1, i32* [[ARRAYIDX1]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %p, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i32 4)
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 7
  store atomic i32 1, i32* %arrayidx1 unordered, align 4
  ret void
}

; Atomicity of the store is weaker from the memset
define void @write24to28_atomic_weaker(i32* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write24to28_atomic_weaker(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 24, i32 4)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    store i32 1, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %p, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i32 4)
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 7
  store i32 1, i32* %arrayidx1, align 4
  ret void
}

define void @write28to32(i32* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write28to32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 28, i1 false)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    store i32 1, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %p3, i8 0, i64 32, i1 false)
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 7
  store i32 1, i32* %arrayidx1, align 4
  ret void
}

define void @write28to32_atomic(i32* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write28to32_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 28, i32 4)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    store atomic i32 1, i32* [[ARRAYIDX1]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 32, i32 4)
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 7
  store atomic i32 1, i32* %arrayidx1 unordered, align 4
  ret void
}

define void @dontwrite28to32memset(i32* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @dontwrite28to32memset(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 16 [[P3]], i8 0, i64 32, i1 false)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    store i32 1, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %p3, i8 0, i64 32, i1 false)
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 7
  store i32 1, i32* %arrayidx1, align 4
  ret void
}

define void @dontwrite28to32memset_atomic(i32* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @dontwrite28to32memset_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 16 [[P3]], i8 0, i64 32, i32 4)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 7
; CHECK-NEXT:    store atomic i32 1, i32* [[ARRAYIDX1]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 16 %p3, i8 0, i64 32, i32 4)
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 7
  store atomic i32 1, i32* %arrayidx1 unordered, align 4
  ret void
}

define void @write32to36(%struct.vec2plusi* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write32to36(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast %struct.vec2plusi* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 [[TMP0]], i8* align 16 bitcast (%struct.vec2plusi* @glob2 to i8*), i64 32, i1 false)
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[STRUCT_VEC2PLUSI:%.*]], %struct.vec2plusi* [[P]], i64 0, i32 2
; CHECK-NEXT:    store i32 1, i32* [[C]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = bitcast %struct.vec2plusi* %p to i8*
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast (%struct.vec2plusi* @glob2 to i8*), i64 36, i1 false)
  %c = getelementptr inbounds %struct.vec2plusi, %struct.vec2plusi* %p, i64 0, i32 2
  store i32 1, i32* %c, align 4
  ret void
}

define void @write32to36_atomic(%struct.vec2plusi* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write32to36_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast %struct.vec2plusi* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 16 [[TMP0]], i8* align 16 bitcast (%struct.vec2plusi* @glob2 to i8*), i64 32, i32 4)
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[STRUCT_VEC2PLUSI:%.*]], %struct.vec2plusi* [[P]], i64 0, i32 2
; CHECK-NEXT:    store atomic i32 1, i32* [[C]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = bitcast %struct.vec2plusi* %p to i8*
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast (%struct.vec2plusi* @glob2 to i8*), i64 36, i32 4)
  %c = getelementptr inbounds %struct.vec2plusi, %struct.vec2plusi* %p, i64 0, i32 2
  store atomic i32 1, i32* %c unordered, align 4
  ret void
}

; Atomicity of the store is weaker than the memcpy
define void @write32to36_atomic_weaker(%struct.vec2plusi* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write32to36_atomic_weaker(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast %struct.vec2plusi* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 16 [[TMP0]], i8* align 16 bitcast (%struct.vec2plusi* @glob2 to i8*), i64 32, i32 4)
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[STRUCT_VEC2PLUSI:%.*]], %struct.vec2plusi* [[P]], i64 0, i32 2
; CHECK-NEXT:    store i32 1, i32* [[C]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = bitcast %struct.vec2plusi* %p to i8*
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast (%struct.vec2plusi* @glob2 to i8*), i64 36, i32 4)
  %c = getelementptr inbounds %struct.vec2plusi, %struct.vec2plusi* %p, i64 0, i32 2
  store i32 1, i32* %c, align 4
  ret void
}

define void @write16to32(%struct.vec2* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write16to32(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast %struct.vec2* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 [[TMP0]], i8* align 16 bitcast (%struct.vec2* @glob1 to i8*), i64 16, i1 false)
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[STRUCT_VEC2:%.*]], %struct.vec2* [[P]], i64 0, i32 1
; CHECK-NEXT:    store <4 x i32> <i32 1, i32 2, i32 3, i32 4>, <4 x i32>* [[C]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = bitcast %struct.vec2* %p to i8*
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast (%struct.vec2* @glob1 to i8*), i64 32, i1 false)
  %c = getelementptr inbounds %struct.vec2, %struct.vec2* %p, i64 0, i32 1
  store <4 x i32> <i32 1, i32 2, i32 3, i32 4>, <4 x i32>* %c, align 4
  ret void
}

define void @write16to32_atomic(%struct.vec2* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @write16to32_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast %struct.vec2* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 16 [[TMP0]], i8* align 16 bitcast (%struct.vec2* @glob1 to i8*), i64 16, i32 4)
; CHECK-NEXT:    [[C:%.*]] = getelementptr inbounds [[STRUCT_VEC2:%.*]], %struct.vec2* [[P]], i64 0, i32 1
; CHECK-NEXT:    store <4 x i32> <i32 1, i32 2, i32 3, i32 4>, <4 x i32>* [[C]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = bitcast %struct.vec2* %p to i8*
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast (%struct.vec2* @glob1 to i8*), i64 32, i32 4)
  %c = getelementptr inbounds %struct.vec2, %struct.vec2* %p, i64 0, i32 1
  store <4 x i32> <i32 1, i32 2, i32 3, i32 4>, <4 x i32>* %c, align 4
  ret void
}

define void @dontwrite28to32memcpy(%struct.vec2* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @dontwrite28to32memcpy(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast %struct.vec2* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 [[TMP0]], i8* align 16 bitcast (%struct.vec2* @glob1 to i8*), i64 32, i1 false)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [[STRUCT_VEC2:%.*]], %struct.vec2* [[P]], i64 0, i32 0, i64 7
; CHECK-NEXT:    store i32 1, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = bitcast %struct.vec2* %p to i8*
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast (%struct.vec2* @glob1 to i8*), i64 32, i1 false)
  %arrayidx1 = getelementptr inbounds %struct.vec2, %struct.vec2* %p, i64 0, i32 0, i64 7
  store i32 1, i32* %arrayidx1, align 4
  ret void
}

define void @dontwrite28to32memcpy_atomic(%struct.vec2* nocapture %p) nounwind uwtable ssp {
; CHECK-LABEL: @dontwrite28to32memcpy_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast %struct.vec2* [[P:%.*]] to i8*
; CHECK-NEXT:    tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 16 [[TMP0]], i8* align 16 bitcast (%struct.vec2* @glob1 to i8*), i64 32, i32 4)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [[STRUCT_VEC2:%.*]], %struct.vec2* [[P]], i64 0, i32 0, i64 7
; CHECK-NEXT:    store atomic i32 1, i32* [[ARRAYIDX1]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = bitcast %struct.vec2* %p to i8*
  tail call void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* align 16 %0, i8* align 16 bitcast (%struct.vec2* @glob1 to i8*), i64 32, i32 4)
  %arrayidx1 = getelementptr inbounds %struct.vec2, %struct.vec2* %p, i64 0, i32 0, i64 7
  store atomic i32 1, i32* %arrayidx1 unordered, align 4
  ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind
declare void @llvm.memcpy.element.unordered.atomic.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i32) nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind
declare void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* nocapture, i8, i64, i32) nounwind

%struct.trapframe = type { i64, i64, i64 }

; bugzilla 11455 - make sure negative GEP's don't break this optimisation
define void @cpu_lwp_fork(%struct.trapframe* %md_regs, i64 %pcb_rsp0) nounwind uwtable noinline ssp {
; CHECK-LABEL: @cpu_lwp_fork(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = inttoptr i64 [[PCB_RSP0:%.*]] to %struct.trapframe*
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds [[STRUCT_TRAPFRAME:%.*]], %struct.trapframe* [[TMP0]], i64 -1
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast %struct.trapframe* [[ADD_PTR]] to i8*
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast %struct.trapframe* [[MD_REGS:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[TMP1]], i8* [[TMP2]], i64 24, i1 false)
; CHECK-NEXT:    [[TF_TRAPNO:%.*]] = getelementptr inbounds [[STRUCT_TRAPFRAME]], %struct.trapframe* [[TMP0]], i64 -1, i32 1
; CHECK-NEXT:    store i64 3, i64* [[TF_TRAPNO]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %0 = inttoptr i64 %pcb_rsp0 to %struct.trapframe*
  %add.ptr = getelementptr inbounds %struct.trapframe, %struct.trapframe* %0, i64 -1
  %1 = bitcast %struct.trapframe* %add.ptr to i8*
  %2 = bitcast %struct.trapframe* %md_regs to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %1, i8* %2, i64 24, i1 false)
  %tf_trapno = getelementptr inbounds %struct.trapframe, %struct.trapframe* %0, i64 -1, i32 1
  store i64 3, i64* %tf_trapno, align 8
  ret void
}

define void @write16To23AndThen24To31(i64* nocapture %P, i64 %n64, i32 %n32, i16 %n16, i8 %n8) {
; CHECK-LABEL: @write16To23AndThen24To31(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE0:%.*]] = bitcast i64* [[P:%.*]] to i8*
; CHECK-NEXT:    [[MYBASE0:%.*]] = getelementptr inbounds i8, i8* [[BASE0]], i64 0
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* align 8 [[MYBASE0]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    [[BASE64_2:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 2
; CHECK-NEXT:    [[BASE64_3:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 3
; CHECK-NEXT:    store i64 3, i64* [[BASE64_2]]
; CHECK-NEXT:    store i64 3, i64* [[BASE64_3]]
; CHECK-NEXT:    ret void
;
entry:

  %base0 = bitcast i64* %P to i8*
  %mybase0 = getelementptr inbounds i8, i8* %base0, i64 0
  tail call void @llvm.memset.p0i8.i64(i8* align 8 %mybase0, i8 0, i64 32, i1 false)

  %base64_2 = getelementptr inbounds i64, i64* %P, i64 2
  %base64_3 = getelementptr inbounds i64, i64* %P, i64 3

  store i64 3, i64* %base64_2
  store i64 3, i64* %base64_3
  ret void
}

define void @write16To23AndThen24To31_atomic(i64* nocapture %P, i64 %n64, i32 %n32, i16 %n16, i8 %n8) {
; CHECK-LABEL: @write16To23AndThen24To31_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE0:%.*]] = bitcast i64* [[P:%.*]] to i8*
; CHECK-NEXT:    [[MYBASE0:%.*]] = getelementptr inbounds i8, i8* [[BASE0]], i64 0
; CHECK-NEXT:    tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 [[MYBASE0]], i8 0, i64 16, i32 8)
; CHECK-NEXT:    [[BASE64_2:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 2
; CHECK-NEXT:    [[BASE64_3:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 3
; CHECK-NEXT:    store atomic i64 3, i64* [[BASE64_2]] unordered, align 8
; CHECK-NEXT:    store atomic i64 3, i64* [[BASE64_3]] unordered, align 8
; CHECK-NEXT:    ret void
;
entry:

  %base0 = bitcast i64* %P to i8*
  %mybase0 = getelementptr inbounds i8, i8* %base0, i64 0
  tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 %mybase0, i8 0, i64 32, i32 8)

  %base64_2 = getelementptr inbounds i64, i64* %P, i64 2
  %base64_3 = getelementptr inbounds i64, i64* %P, i64 3

  store atomic i64 3, i64* %base64_2 unordered, align 8
  store atomic i64 3, i64* %base64_3 unordered, align 8
  ret void
}

define void @write16To23AndThen24To31_atomic_weaker1(i64* nocapture %P, i64 %n64, i32 %n32, i16 %n16, i8 %n8) {
; CHECK-LABEL: @write16To23AndThen24To31_atomic_weaker1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE0:%.*]] = bitcast i64* [[P:%.*]] to i8*
; CHECK-NEXT:    [[MYBASE0:%.*]] = getelementptr inbounds i8, i8* [[BASE0]], i64 0
; CHECK-NEXT:    tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 [[MYBASE0]], i8 0, i64 16, i32 8)
; CHECK-NEXT:    [[BASE64_2:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 2
; CHECK-NEXT:    [[BASE64_3:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 3
; CHECK-NEXT:    store i64 3, i64* [[BASE64_2]], align 8
; CHECK-NEXT:    store atomic i64 3, i64* [[BASE64_3]] unordered, align 8
; CHECK-NEXT:    ret void
;
entry:

  %base0 = bitcast i64* %P to i8*
  %mybase0 = getelementptr inbounds i8, i8* %base0, i64 0
  tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 %mybase0, i8 0, i64 32, i32 8)

  %base64_2 = getelementptr inbounds i64, i64* %P, i64 2
  %base64_3 = getelementptr inbounds i64, i64* %P, i64 3

  store i64 3, i64* %base64_2, align 8
  store atomic i64 3, i64* %base64_3 unordered, align 8
  ret void
}

define void @write16To23AndThen24To31_atomic_weaker2(i64* nocapture %P, i64 %n64, i32 %n32, i16 %n16, i8 %n8) {
; CHECK-LABEL: @write16To23AndThen24To31_atomic_weaker2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE0:%.*]] = bitcast i64* [[P:%.*]] to i8*
; CHECK-NEXT:    [[MYBASE0:%.*]] = getelementptr inbounds i8, i8* [[BASE0]], i64 0
; CHECK-NEXT:    tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 [[MYBASE0]], i8 0, i64 16, i32 8)
; CHECK-NEXT:    [[BASE64_2:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 2
; CHECK-NEXT:    [[BASE64_3:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 3
; CHECK-NEXT:    store atomic i64 3, i64* [[BASE64_2]] unordered, align 8
; CHECK-NEXT:    store i64 3, i64* [[BASE64_3]], align 8
; CHECK-NEXT:    ret void
;
entry:

  %base0 = bitcast i64* %P to i8*
  %mybase0 = getelementptr inbounds i8, i8* %base0, i64 0
  tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 %mybase0, i8 0, i64 32, i32 8)

  %base64_2 = getelementptr inbounds i64, i64* %P, i64 2
  %base64_3 = getelementptr inbounds i64, i64* %P, i64 3

  store atomic i64 3, i64* %base64_2 unordered, align 8
  store i64 3, i64* %base64_3, align 8
  ret void
}
