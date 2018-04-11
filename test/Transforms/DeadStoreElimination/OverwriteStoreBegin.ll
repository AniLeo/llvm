; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basicaa -dse -S | FileCheck %s

define void @write4to7(i32* nocapture %p) {
; CHECK-LABEL: @write4to7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[P3]], i64 4
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[TMP0]], i8 0, i64 24, i1 false)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    store i32 1, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %p, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i1 false)
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 1
  store i32 1, i32* %arrayidx1, align 4
  ret void
}

define void @write4to7_atomic(i32* nocapture %p) {
; CHECK-LABEL: @write4to7_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 28, i32 4)
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds i32, i32* [[P]], i64 1
; CHECK-NEXT:    store atomic i32 1, i32* [[ARRAYIDX1]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %p, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i32 4)
  %arrayidx1 = getelementptr inbounds i32, i32* %p, i64 1
  store atomic i32 1, i32* %arrayidx1 unordered, align 4
  ret void
}

define void @write0to3(i32* nocapture %p) {
; CHECK-LABEL: @write0to3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[P3]], i64 4
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[TMP0]], i8 0, i64 24, i1 false)
; CHECK-NEXT:    store i32 1, i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i1 false)
  store i32 1, i32* %p, align 4
  ret void
}

define void @write0to3_atomic(i32* nocapture %p) {
; CHECK-LABEL: @write0to3_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 28, i32 4)
; CHECK-NEXT:    store atomic i32 1, i32* [[P]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i32 4)
  store atomic i32 1, i32* %p unordered, align 4
  ret void
}

; Atomicity of the store is weaker from the memset
define void @write0to3_atomic_weaker(i32* nocapture %p) {
; CHECK-LABEL: @write0to3_atomic_weaker(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 28, i32 4)
; CHECK-NEXT:    store i32 1, i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i32 4)
  store i32 1, i32* %p, align 4
  ret void
}

define void @write0to7(i32* nocapture %p) {
; CHECK-LABEL: @write0to7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[P3]], i64 8
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[TMP0]], i8 0, i64 24, i1 false)
; CHECK-NEXT:    [[P4:%.*]] = bitcast i32* [[P]] to i64*
; CHECK-NEXT:    store i64 1, i64* [[P4]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %p3, i8 0, i64 32, i1 false)
  %p4 = bitcast i32* %p to i64*
  store i64 1, i64* %p4, align 8
  ret void
}

; Changing the memset start and length is okay here because the
; store is a multiple of the memset element size
define void @write0to7_atomic(i32* nocapture %p) {
; CHECK-LABEL: @write0to7_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 32, i32 4)
; CHECK-NEXT:    [[P4:%.*]] = bitcast i32* [[P]] to i64*
; CHECK-NEXT:    store atomic i64 1, i64* [[P4]] unordered, align 8
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 32, i32 4)
  %p4 = bitcast i32* %p to i64*
  store atomic i64 1, i64* %p4 unordered, align 8
  ret void
}

define void @write0to7_2(i32* nocapture %p) {
; CHECK-LABEL: @write0to7_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[P3]], i64 4
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[TMP0]], i8 0, i64 24, i1 false)
; CHECK-NEXT:    [[P4:%.*]] = bitcast i32* [[P]] to i64*
; CHECK-NEXT:    store i64 1, i64* [[P4]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %p, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i1 false)
  %p4 = bitcast i32* %p to i64*
  store i64 1, i64* %p4, align 8
  ret void
}

define void @write0to7_2_atomic(i32* nocapture %p) {
; CHECK-LABEL: @write0to7_2_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 28, i32 4)
; CHECK-NEXT:    [[P4:%.*]] = bitcast i32* [[P]] to i64*
; CHECK-NEXT:    store atomic i64 1, i64* [[P4]] unordered, align 8
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %p, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 28, i32 4)
  %p4 = bitcast i32* %p to i64*
  store atomic i64 1, i64* %p4 unordered, align 8
  ret void
}

; We do not trim the beginning of the eariler write if the alignment of the
; start pointer is changed.
define void @dontwrite0to3_align8(i32* nocapture %p) {
; CHECK-LABEL: @dontwrite0to3_align8(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 8 [[P3]], i8 0, i64 32, i1 false)
; CHECK-NEXT:    store i32 1, i32* [[P]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.p0i8.i64(i8* align 8 %p3, i8 0, i64 32, i1 false)
  store i32 1, i32* %p, align 4
  ret void
}

define void @dontwrite0to3_align8_atomic(i32* nocapture %p) {
; CHECK-LABEL: @dontwrite0to3_align8_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 [[P3]], i8 0, i64 32, i32 4)
; CHECK-NEXT:    store atomic i32 1, i32* [[P]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 %p3, i8 0, i64 32, i32 4)
  store atomic i32 1, i32* %p unordered, align 4
  ret void
}

define void @dontwrite0to1(i32* nocapture %p) {
; CHECK-LABEL: @dontwrite0to1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 32, i1 false)
; CHECK-NEXT:    [[P4:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    store i16 1, i16* [[P4]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %p3, i8 0, i64 32, i1 false)
  %p4 = bitcast i32* %p to i16*
  store i16 1, i16* %p4, align 4
  ret void
}

define void @dontwrite0to1_atomic(i32* nocapture %p) {
; CHECK-LABEL: @dontwrite0to1_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[P:%.*]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 32, i32 4)
; CHECK-NEXT:    [[P4:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    store atomic i16 1, i16* [[P4]] unordered, align 4
; CHECK-NEXT:    ret void
;
entry:
  %p3 = bitcast i32* %p to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 32, i32 4)
  %p4 = bitcast i32* %p to i16*
  store atomic i16 1, i16* %p4 unordered, align 4
  ret void
}

define void @dontwrite2to9(i32* nocapture %p) {
; CHECK-LABEL: @dontwrite2to9(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 32, i1 false)
; CHECK-NEXT:    [[P4:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i16, i16* [[P4]], i64 1
; CHECK-NEXT:    [[P5:%.*]] = bitcast i16* [[ARRAYIDX2]] to i64*
; CHECK-NEXT:    store i64 1, i64* [[P5]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %p, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 4 %p3, i8 0, i64 32, i1 false)
  %p4 = bitcast i32* %p to i16*
  %arrayidx2 = getelementptr inbounds i16, i16* %p4, i64 1
  %p5 = bitcast i16* %arrayidx2 to i64*
  store i64 1, i64* %p5, align 8
  ret void
}

define void @dontwrite2to9_atomic(i32* nocapture %p) {
; CHECK-LABEL: @dontwrite2to9_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[ARRAYIDX0:%.*]] = getelementptr inbounds i32, i32* [[P:%.*]], i64 1
; CHECK-NEXT:    [[P3:%.*]] = bitcast i32* [[ARRAYIDX0]] to i8*
; CHECK-NEXT:    call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 [[P3]], i8 0, i64 32, i32 4)
; CHECK-NEXT:    [[P4:%.*]] = bitcast i32* [[P]] to i16*
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds i16, i16* [[P4]], i64 1
; CHECK-NEXT:    [[P5:%.*]] = bitcast i16* [[ARRAYIDX2]] to i64*
; CHECK-NEXT:    store atomic i64 1, i64* [[P5]] unordered, align 8
; CHECK-NEXT:    ret void
;
entry:
  %arrayidx0 = getelementptr inbounds i32, i32* %p, i64 1
  %p3 = bitcast i32* %arrayidx0 to i8*
  call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 4 %p3, i8 0, i64 32, i32 4)
  %p4 = bitcast i32* %p to i16*
  %arrayidx2 = getelementptr inbounds i16, i16* %p4, i64 1
  %p5 = bitcast i16* %arrayidx2 to i64*
  store atomic i64 1, i64* %p5 unordered, align 8
  ret void
}

define void @write8To15AndThen0To7(i64* nocapture %P) {
; CHECK-LABEL: @write8To15AndThen0To7(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE0:%.*]] = bitcast i64* [[P:%.*]] to i8*
; CHECK-NEXT:    [[MYBASE0:%.*]] = getelementptr inbounds i8, i8* [[BASE0]], i64 0
; CHECK-NEXT:    [[TMP0:%.*]] = getelementptr inbounds i8, i8* [[MYBASE0]], i64 16
; CHECK-NEXT:    tail call void @llvm.memset.p0i8.i64(i8* align 8 [[TMP0]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    [[BASE64_0:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 0
; CHECK-NEXT:    [[BASE64_1:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 1
; CHECK-NEXT:    store i64 1, i64* [[BASE64_1]]
; CHECK-NEXT:    store i64 2, i64* [[BASE64_0]]
; CHECK-NEXT:    ret void
;
entry:

  %base0 = bitcast i64* %P to i8*
  %mybase0 = getelementptr inbounds i8, i8* %base0, i64 0
  tail call void @llvm.memset.p0i8.i64(i8* align 8 %mybase0, i8 0, i64 32, i1 false)

  %base64_0 = getelementptr inbounds i64, i64* %P, i64 0
  %base64_1 = getelementptr inbounds i64, i64* %P, i64 1

  store i64 1, i64* %base64_1
  store i64 2, i64* %base64_0
  ret void
}

define void @write8To15AndThen0To7_atomic(i64* nocapture %P) {
; CHECK-LABEL: @write8To15AndThen0To7_atomic(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE0:%.*]] = bitcast i64* [[P:%.*]] to i8*
; CHECK-NEXT:    [[MYBASE0:%.*]] = getelementptr inbounds i8, i8* [[BASE0]], i64 0
; CHECK-NEXT:    tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 [[MYBASE0]], i8 0, i64 32, i32 8)
; CHECK-NEXT:    [[BASE64_0:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 0
; CHECK-NEXT:    [[BASE64_1:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 1
; CHECK-NEXT:    store atomic i64 1, i64* [[BASE64_1]] unordered, align 8
; CHECK-NEXT:    store atomic i64 2, i64* [[BASE64_0]] unordered, align 8
; CHECK-NEXT:    ret void
;
entry:

  %base0 = bitcast i64* %P to i8*
  %mybase0 = getelementptr inbounds i8, i8* %base0, i64 0
  tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 %mybase0, i8 0, i64 32, i32 8)

  %base64_0 = getelementptr inbounds i64, i64* %P, i64 0
  %base64_1 = getelementptr inbounds i64, i64* %P, i64 1

  store atomic i64 1, i64* %base64_1 unordered, align 8
  store atomic i64 2, i64* %base64_0 unordered, align 8
  ret void
}

define void @write8To15AndThen0To7_atomic_weaker(i64* nocapture %P) {
; CHECK-LABEL: @write8To15AndThen0To7_atomic_weaker(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE0:%.*]] = bitcast i64* [[P:%.*]] to i8*
; CHECK-NEXT:    [[MYBASE0:%.*]] = getelementptr inbounds i8, i8* [[BASE0]], i64 0
; CHECK-NEXT:    tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 [[MYBASE0]], i8 0, i64 32, i32 8)
; CHECK-NEXT:    [[BASE64_0:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 0
; CHECK-NEXT:    [[BASE64_1:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 1
; CHECK-NEXT:    store atomic i64 1, i64* [[BASE64_1]] unordered, align 8
; CHECK-NEXT:    store i64 2, i64* [[BASE64_0]], align 8
; CHECK-NEXT:    ret void
;
entry:

  %base0 = bitcast i64* %P to i8*
  %mybase0 = getelementptr inbounds i8, i8* %base0, i64 0
  tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 %mybase0, i8 0, i64 32, i32 8)

  %base64_0 = getelementptr inbounds i64, i64* %P, i64 0
  %base64_1 = getelementptr inbounds i64, i64* %P, i64 1

  store atomic i64 1, i64* %base64_1 unordered, align 8
  store i64 2, i64* %base64_0, align 8
  ret void
}

define void @write8To15AndThen0To7_atomic_weaker_2(i64* nocapture %P) {
; CHECK-LABEL: @write8To15AndThen0To7_atomic_weaker_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE0:%.*]] = bitcast i64* [[P:%.*]] to i8*
; CHECK-NEXT:    [[MYBASE0:%.*]] = getelementptr inbounds i8, i8* [[BASE0]], i64 0
; CHECK-NEXT:    tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 [[MYBASE0]], i8 0, i64 32, i32 8)
; CHECK-NEXT:    [[BASE64_0:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 0
; CHECK-NEXT:    [[BASE64_1:%.*]] = getelementptr inbounds i64, i64* [[P]], i64 1
; CHECK-NEXT:    store i64 1, i64* [[BASE64_1]], align 8
; CHECK-NEXT:    store atomic i64 2, i64* [[BASE64_0]] unordered, align 8
; CHECK-NEXT:    ret void
;
entry:

  %base0 = bitcast i64* %P to i8*
  %mybase0 = getelementptr inbounds i8, i8* %base0, i64 0
  tail call void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* align 8 %mybase0, i8 0, i64 32, i32 8)

  %base64_0 = getelementptr inbounds i64, i64* %P, i64 0
  %base64_1 = getelementptr inbounds i64, i64* %P, i64 1

  store i64 1, i64* %base64_1, align 8
  store atomic i64 2, i64* %base64_0 unordered, align 8
  ret void
}

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i1) nounwind
declare void @llvm.memset.element.unordered.atomic.p0i8.i64(i8* nocapture, i8, i64, i32) nounwind

