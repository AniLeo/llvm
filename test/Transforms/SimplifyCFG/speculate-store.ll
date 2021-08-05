; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S < %s | FileCheck %s

define void @ifconvertstore(i32* %A, i32 %B, i32 %C, i32 %D) {
; CHECK-LABEL: @ifconvertstore(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[A:%.*]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[D:%.*]], 42
; CHECK-NEXT:    [[SPEC_STORE_SELECT:%.*]] = select i1 [[CMP]], i32 [[C:%.*]], i32 [[B]], !prof [[PROF0:![0-9]+]]
; CHECK-NEXT:    store i32 [[SPEC_STORE_SELECT]], i32* [[A]], align 4
; CHECK-NEXT:    ret void
;
entry:
; First store to the location.
  store i32 %B, i32* %A
  %cmp = icmp sgt i32 %D, 42
  br i1 %cmp, label %if.then, label %ret.end, !prof !0

; Make sure we speculate stores like the following one. It is cheap compared to
; a mispredicated branch.
if.then:
  store i32 %C, i32* %A
  br label %ret.end

ret.end:
  ret void
}

; Store to a different location.

define void @noifconvertstore1(i32* %A1, i32* %A2, i32 %B, i32 %C, i32 %D) {
; CHECK-LABEL: @noifconvertstore1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[A1:%.*]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[D:%.*]], 42
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[RET_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 [[C:%.*]], i32* [[A2:%.*]], align 4
; CHECK-NEXT:    br label [[RET_END]]
; CHECK:       ret.end:
; CHECK-NEXT:    ret void
;
entry:
  store i32 %B, i32* %A1
  %cmp = icmp sgt i32 %D, 42
  br i1 %cmp, label %if.then, label %ret.end

if.then:
  store i32 %C, i32* %A2
  br label %ret.end

ret.end:
  ret void
}

; This function could store to our address, so we can't repeat the first store a second time.
declare void @unknown_fun()

define void @noifconvertstore2(i32* %A, i32 %B, i32 %C, i32 %D) {
; CHECK-LABEL: @noifconvertstore2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[A:%.*]], align 4
; CHECK-NEXT:    call void @unknown_fun()
; CHECK-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[D:%.*]], 42
; CHECK-NEXT:    br i1 [[CMP6]], label [[IF_THEN:%.*]], label [[RET_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 [[C:%.*]], i32* [[A]], align 4
; CHECK-NEXT:    br label [[RET_END]]
; CHECK:       ret.end:
; CHECK-NEXT:    ret void
;
entry:
; First store to the location.
  store i32 %B, i32* %A
  call void @unknown_fun()
  %cmp6 = icmp sgt i32 %D, 42
  br i1 %cmp6, label %if.then, label %ret.end

if.then:
  store i32 %C, i32* %A
  br label %ret.end

ret.end:
  ret void
}

; Make sure we don't speculate volatile stores.

define void @noifconvertstore_volatile(i32* %A, i32 %B, i32 %C, i32 %D) {
; CHECK-LABEL: @noifconvertstore_volatile(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 [[B:%.*]], i32* [[A:%.*]], align 4
; CHECK-NEXT:    [[CMP6:%.*]] = icmp sgt i32 [[D:%.*]], 42
; CHECK-NEXT:    br i1 [[CMP6]], label [[IF_THEN:%.*]], label [[RET_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store volatile i32 [[C:%.*]], i32* [[A]], align 4
; CHECK-NEXT:    br label [[RET_END]]
; CHECK:       ret.end:
; CHECK-NEXT:    ret void
;
entry:
; First store to the location.
  store i32 %B, i32* %A
  %cmp6 = icmp sgt i32 %D, 42
  br i1 %cmp6, label %if.then, label %ret.end

if.then:
  store volatile i32 %C, i32* %A
  br label %ret.end

ret.end:
  ret void
}

define void @different_type(ptr %ptr, i1 %cmp) {
; CHECK-LABEL: @different_type(
; CHECK-NEXT:    store i32 0, ptr [[PTR:%.*]], align 4
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_THEN:%.*]], label [[RET_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i64 1, ptr [[PTR]], align 4
; CHECK-NEXT:    br label [[RET_END]]
; CHECK:       ret.end:
; CHECK-NEXT:    ret void
;
  store i32 0, ptr %ptr
  br i1 %cmp, label %if.then, label %ret.end

if.then:
  store i64 1, ptr %ptr
  br label %ret.end

ret.end:
  ret void
}

define void @readonly_call(ptr %ptr, i1 %cmp) {
; CHECK-LABEL: @readonly_call(
; CHECK-NEXT:  ret.end:
; CHECK-NEXT:    store i32 0, ptr [[PTR:%.*]], align 4
; CHECK-NEXT:    call void @unknown_fun() #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    [[SPEC_STORE_SELECT:%.*]] = select i1 [[CMP:%.*]], i32 1, i32 0
; CHECK-NEXT:    store i32 [[SPEC_STORE_SELECT]], ptr [[PTR]], align 4
; CHECK-NEXT:    ret void
;
  store i32 0, ptr %ptr
  call void @unknown_fun() readonly
  br i1 %cmp, label %if.then, label %ret.end

if.then:
  store i32 1, ptr %ptr
  br label %ret.end

ret.end:
  ret void
}

define void @atomic_and_simple(ptr %ptr, i1 %cmp) {
; CHECK-LABEL: @atomic_and_simple(
; CHECK-NEXT:    store atomic i32 0, ptr [[PTR:%.*]] seq_cst, align 4
; CHECK-NEXT:    br i1 [[CMP:%.*]], label [[IF_THEN:%.*]], label [[RET_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 1, ptr [[PTR]], align 4
; CHECK-NEXT:    br label [[RET_END]]
; CHECK:       ret.end:
; CHECK-NEXT:    ret void
;
  store atomic i32 0, ptr %ptr seq_cst, align 4
  br i1 %cmp, label %if.then, label %ret.end

if.then:
  store i32 1, ptr %ptr
  br label %ret.end

ret.end:
  ret void
}

;; Speculate a store, preceded by a local, non-escaping load
define i32 @load_before_store_noescape(i64 %i, i32 %b)  {
; CHECK-LABEL: @load_before_store_noescape(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [2 x i32], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast [2 x i32]* [[A]] to i64*
; CHECK-NEXT:    store i64 4294967296, i64* [[TMP0]], align 8
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    [[SPEC_STORE_SELECT:%.*]] = select i1 [[CMP]], i32 [[B]], i32 [[TMP1]]
; CHECK-NEXT:    store i32 [[SPEC_STORE_SELECT]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP2]], [[TMP3]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %a = alloca [2 x i32], align 8
  %0 = bitcast [2 x i32]* %a to i64*
  store i64 4294967296, i64* %0, align 8
  %arrayidx = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 %i
  %1 = load i32, i32* %arrayidx, align 4
  %cmp = icmp slt i32 %1, %b
  br i1 %cmp, label %if.then, label %if.end

if.then:
  store i32 %b, i32* %arrayidx, align 4
  br label %if.end

if.end:
  %arrayidx1 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 0
  %2 = load i32, i32* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 1
  %3 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %2, %3
  ret i32 %add
}

;; Don't speculate a store, preceded by a local, escaping load
define i32 @load_before_store_escape(i64 %i, i32 %b)  {
; CHECK-LABEL: @load_before_store_escape(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [2 x i32], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast [2 x i32]* [[A]] to i64*
; CHECK-NEXT:    store i64 4294967296, i64* [[TMP0]], align 8
; CHECK-NEXT:    call void @fork_some_threads([2 x i32]* [[A]])
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 [[B]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 0
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP2]], [[TMP3]]
; CHECK-NEXT:    call void @join_some_threads()
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %a = alloca [2 x i32], align 8
  %0 = bitcast [2 x i32]* %a to i64*
  store i64 4294967296, i64* %0, align 8
  call void @fork_some_threads([2 x i32]* %a)
  %arrayidx = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 %i
  %1 = load i32, i32* %arrayidx, align 4
  %cmp = icmp slt i32 %1, %b
  br i1 %cmp, label %if.then, label %if.end

if.then:
  store i32 %b, i32* %arrayidx, align 4
  br label %if.end

if.end:
  %arrayidx1 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 0
  %2 = load i32, i32* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 1
  %3 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %2, %3
  call void @join_some_threads()
  ret i32 %add
}

declare void @fork_some_threads([2 x i32] *);
declare void @join_some_threads();

; Don't speculate if it's not the only instruction in the block (not counting
; the terminator)
define i32 @not_alone_in_block(i64 %i, i32 %b)  {
; CHECK-LABEL: @not_alone_in_block(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca [2 x i32], align 8
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast [2 x i32]* [[A]] to i64*
; CHECK-NEXT:    store i64 4294967296, i64* [[TMP0]], align 8
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 [[I:%.*]]
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 0
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[TMP1]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    store i32 [[B]], i32* [[ARRAYIDX]], align 4
; CHECK-NEXT:    store i32 [[B]], i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds [2 x i32], [2 x i32]* [[A]], i64 0, i64 1
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[ARRAYIDX2]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add nsw i32 [[TMP2]], [[TMP3]]
; CHECK-NEXT:    ret i32 [[ADD]]
;
entry:
  %a = alloca [2 x i32], align 8
  %0 = bitcast [2 x i32]* %a to i64*
  store i64 4294967296, i64* %0, align 8
  %arrayidx = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 %i
  %arrayidx1 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 0
  %1 = load i32, i32* %arrayidx, align 4
  %cmp = icmp slt i32 %1, %b
  br i1 %cmp, label %if.then, label %if.end

if.then:
  store i32 %b, i32* %arrayidx, align 4
  store i32 %b, i32* %arrayidx1, align 4
  br label %if.end

if.end:
  %2 = load i32, i32* %arrayidx1, align 4
  %arrayidx2 = getelementptr inbounds [2 x i32], [2 x i32]* %a, i64 0, i64 1
  %3 = load i32, i32* %arrayidx2, align 4
  %add = add nsw i32 %2, %3
  ret i32 %add
}

; CHECK: !0 = !{!"branch_weights", i32 3, i32 5}
!0 = !{!"branch_weights", i32 3, i32 5}

