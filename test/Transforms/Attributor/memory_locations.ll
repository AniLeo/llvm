; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=13 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=13 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@G = external dso_local global i32, align 4

declare noalias i8* @malloc(i64) inaccessiblememonly

;.
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = external dso_local global i32, align 4
;.
define dso_local i8* @internal_only(i32 %arg) {
; CHECK: Function Attrs: inaccessiblememonly
; CHECK-LABEL: define {{[^@]+}}@internal_only
; CHECK-SAME: (i32 [[ARG:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[ARG]] to i64
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @malloc(i64 [[CONV]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
entry:
  %conv = sext i32 %arg to i64
  %call = call i8* @malloc(i64 %conv)
  ret i8* %call
}

define dso_local i8* @internal_only_rec(i32 %arg) {
; CHECK: Function Attrs: inaccessiblememonly
; CHECK-LABEL: define {{[^@]+}}@internal_only_rec
; CHECK-SAME: (i32 [[ARG:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[REM:%.*]] = srem i32 [[ARG]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[REM]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[ARG]], 2
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_only_rec(i32 [[DIV]])
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[ARG]] to i64
; CHECK-NEXT:    [[CALL1:%.*]] = call noalias i8* @malloc(i64 [[CONV]])
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i8* [ [[CALL]], [[IF_THEN]] ], [ [[CALL1]], [[IF_END]] ]
; CHECK-NEXT:    ret i8* [[RETVAL_0]]
;
entry:
  %rem = srem i32 %arg, 2
  %cmp = icmp eq i32 %rem, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %div = sdiv i32 %arg, 2
  %call = call i8* @internal_only_rec(i32 %div)
  br label %return

if.end:                                           ; preds = %entry
  %conv = sext i32 %arg to i64
  %call1 = call i8* @malloc(i64 %conv)
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i8* [ %call, %if.then ], [ %call1, %if.end ]
  ret i8* %retval.0
}

define dso_local i8* @internal_only_rec_static_helper(i32 %arg) {
; CHECK: Function Attrs: inaccessiblememonly
; CHECK-LABEL: define {{[^@]+}}@internal_only_rec_static_helper
; CHECK-SAME: (i32 [[ARG:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_only_rec_static(i32 [[ARG]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
entry:
  %call = call i8* @internal_only_rec_static(i32 %arg)
  ret i8* %call
}

define internal i8* @internal_only_rec_static(i32 %arg) {
; CHECK: Function Attrs: inaccessiblememonly
; CHECK-LABEL: define {{[^@]+}}@internal_only_rec_static
; CHECK-SAME: (i32 [[ARG:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[REM:%.*]] = srem i32 [[ARG]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[REM]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[ARG]], 2
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_only_rec(i32 [[DIV]])
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[ARG]] to i64
; CHECK-NEXT:    [[CALL1:%.*]] = call noalias i8* @malloc(i64 [[CONV]])
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i8* [ [[CALL]], [[IF_THEN]] ], [ [[CALL1]], [[IF_END]] ]
; CHECK-NEXT:    ret i8* [[RETVAL_0]]
;
entry:
  %rem = srem i32 %arg, 2
  %cmp = icmp eq i32 %rem, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %div = sdiv i32 %arg, 2
  %call = call i8* @internal_only_rec(i32 %div)
  br label %return

if.end:                                           ; preds = %entry
  %conv = sext i32 %arg to i64
  %call1 = call i8* @malloc(i64 %conv)
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i8* [ %call, %if.then ], [ %call1, %if.end ]
  ret i8* %retval.0
}

define dso_local i8* @internal_only_rec_static_helper_malloc_noescape(i32 %arg) {
; FIXME: This is actually inaccessiblememonly because the malloced memory does not escape
; CHECK-LABEL: define {{[^@]+}}@internal_only_rec_static_helper_malloc_noescape
; CHECK-SAME: (i32 [[ARG:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_only_rec_static_malloc_noescape(i32 [[ARG]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
entry:
  %call = call i8* @internal_only_rec_static_malloc_noescape(i32 %arg)
  ret i8* %call
}

define internal i8* @internal_only_rec_static_malloc_noescape(i32 %arg) {
; FIXME: This is actually inaccessiblememonly because the malloced memory does not escape
; CHECK-LABEL: define {{[^@]+}}@internal_only_rec_static_malloc_noescape
; CHECK-SAME: (i32 [[ARG:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[REM:%.*]] = srem i32 [[ARG]], 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[REM]], 1
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[DIV:%.*]] = sdiv i32 [[ARG]], 2
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_only_rec(i32 [[DIV]])
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[ARG]] to i64
; CHECK-NEXT:    [[CALL1:%.*]] = call noalias i8* @malloc(i64 [[CONV]])
; CHECK-NEXT:    store i8 0, i8* [[CALL1]], align 1
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i8* [ [[CALL]], [[IF_THEN]] ], [ null, [[IF_END]] ]
; CHECK-NEXT:    ret i8* [[RETVAL_0]]
;
entry:
  %rem = srem i32 %arg, 2
  %cmp = icmp eq i32 %rem, 1
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %div = sdiv i32 %arg, 2
  %call = call i8* @internal_only_rec(i32 %div)
  br label %return

if.end:                                           ; preds = %entry
  %conv = sext i32 %arg to i64
  %call1 = call i8* @malloc(i64 %conv)
  store i8 0, i8* %call1
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i8* [ %call, %if.then ], [ null, %if.end ]
  ret i8* %retval.0
}

define dso_local i8* @internal_argmem_only_read(i32* %arg) {
; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
; CHECK-LABEL: define {{[^@]+}}@internal_argmem_only_read
; CHECK-SAME: (i32* nocapture nofree noundef nonnull readonly align 4 dereferenceable(4) [[ARG:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[TMP]] to i64
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @malloc(i64 [[CONV]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
entry:
  %tmp = load i32, i32* %arg, align 4
  %conv = sext i32 %tmp to i64
  %call = call i8* @malloc(i64 %conv)
  ret i8* %call
}

define dso_local i8* @internal_argmem_only_write(i32* %arg) {
; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
; CHECK-LABEL: define {{[^@]+}}@internal_argmem_only_write
; CHECK-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[ARG:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 10, i32* [[ARG]], align 4
; CHECK-NEXT:    [[CALL:%.*]] = call noalias dereferenceable_or_null(10) i8* @malloc(i64 noundef 10)
; CHECK-NEXT:    ret i8* [[CALL]]
;
entry:
  store i32 10, i32* %arg, align 4
  %call = call dereferenceable_or_null(10) i8* @malloc(i64 10)
  ret i8* %call
}

define dso_local i8* @internal_argmem_only_rec(i32* %arg) {
; IS__TUNIT____: Function Attrs: inaccessiblemem_or_argmemonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@internal_argmem_only_rec
; IS__TUNIT____-SAME: (i32* nocapture nofree [[ARG:%.*]]) #[[ATTR1]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_argmem_only_rec_1(i32* nocapture nofree align 4 [[ARG]])
; IS__TUNIT____-NEXT:    ret i8* [[CALL]]
;
; IS__CGSCC____: Function Attrs: inaccessiblemem_or_argmemonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@internal_argmem_only_rec
; IS__CGSCC____-SAME: (i32* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[ARG:%.*]]) #[[ATTR1]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_argmem_only_rec_1(i32* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[ARG]])
; IS__CGSCC____-NEXT:    ret i8* [[CALL]]
;
entry:
  %call = call i8* @internal_argmem_only_rec_1(i32* %arg)
  ret i8* %call
}

define internal i8* @internal_argmem_only_rec_1(i32* %arg) {
; IS__TUNIT____: Function Attrs: inaccessiblemem_or_argmemonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@internal_argmem_only_rec_1
; IS__TUNIT____-SAME: (i32* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[ARG:%.*]]) #[[ATTR1]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[TMP:%.*]] = load i32, i32* [[ARG]], align 4
; IS__TUNIT____-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TMP]], 0
; IS__TUNIT____-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; IS__TUNIT____:       if.then:
; IS__TUNIT____-NEXT:    br label [[RETURN:%.*]]
; IS__TUNIT____:       if.end:
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARG]], align 4
; IS__TUNIT____-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[TMP1]], 1
; IS__TUNIT____-NEXT:    br i1 [[CMP1]], label [[IF_THEN2:%.*]], label [[IF_END3:%.*]]
; IS__TUNIT____:       if.then2:
; IS__TUNIT____-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, i32* [[ARG]], i64 -1
; IS__TUNIT____-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_argmem_only_rec_2(i32* nocapture nofree nonnull align 4 dereferenceable(4) [[ADD_PTR]])
; IS__TUNIT____-NEXT:    br label [[RETURN]]
; IS__TUNIT____:       if.end3:
; IS__TUNIT____-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARG]], align 4
; IS__TUNIT____-NEXT:    [[CONV:%.*]] = sext i32 [[TMP2]] to i64
; IS__TUNIT____-NEXT:    [[CALL4:%.*]] = call noalias i8* @malloc(i64 [[CONV]])
; IS__TUNIT____-NEXT:    br label [[RETURN]]
; IS__TUNIT____:       return:
; IS__TUNIT____-NEXT:    [[RETVAL_0:%.*]] = phi i8* [ null, [[IF_THEN]] ], [ [[CALL]], [[IF_THEN2]] ], [ [[CALL4]], [[IF_END3]] ]
; IS__TUNIT____-NEXT:    ret i8* [[RETVAL_0]]
;
; IS__CGSCC____: Function Attrs: inaccessiblemem_or_argmemonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@internal_argmem_only_rec_1
; IS__CGSCC____-SAME: (i32* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[ARG:%.*]]) #[[ATTR1]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[TMP:%.*]] = load i32, i32* [[ARG]], align 4
; IS__CGSCC____-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TMP]], 0
; IS__CGSCC____-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; IS__CGSCC____:       if.then:
; IS__CGSCC____-NEXT:    br label [[RETURN:%.*]]
; IS__CGSCC____:       if.end:
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARG]], align 4
; IS__CGSCC____-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[TMP1]], 1
; IS__CGSCC____-NEXT:    br i1 [[CMP1]], label [[IF_THEN2:%.*]], label [[IF_END3:%.*]]
; IS__CGSCC____:       if.then2:
; IS__CGSCC____-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, i32* [[ARG]], i64 -1
; IS__CGSCC____-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_argmem_only_rec_2(i32* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[ADD_PTR]])
; IS__CGSCC____-NEXT:    br label [[RETURN]]
; IS__CGSCC____:       if.end3:
; IS__CGSCC____-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARG]], align 4
; IS__CGSCC____-NEXT:    [[CONV:%.*]] = sext i32 [[TMP2]] to i64
; IS__CGSCC____-NEXT:    [[CALL4:%.*]] = call noalias i8* @malloc(i64 [[CONV]])
; IS__CGSCC____-NEXT:    br label [[RETURN]]
; IS__CGSCC____:       return:
; IS__CGSCC____-NEXT:    [[RETVAL_0:%.*]] = phi i8* [ null, [[IF_THEN]] ], [ [[CALL]], [[IF_THEN2]] ], [ [[CALL4]], [[IF_END3]] ]
; IS__CGSCC____-NEXT:    ret i8* [[RETVAL_0]]
;
entry:
  %tmp = load i32, i32* %arg, align 4
  %cmp = icmp eq i32 %tmp, 0
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  br label %return

if.end:                                           ; preds = %entry
  %tmp1 = load i32, i32* %arg, align 4
  %cmp1 = icmp eq i32 %tmp1, 1
  br i1 %cmp1, label %if.then2, label %if.end3

if.then2:                                         ; preds = %if.end
  %add.ptr = getelementptr inbounds i32, i32* %arg, i64 -1
  %call = call i8* @internal_argmem_only_rec_2(i32* nonnull %add.ptr)
  br label %return

if.end3:                                          ; preds = %if.end
  %tmp2 = load i32, i32* %arg, align 4
  %conv = sext i32 %tmp2 to i64
  %call4 = call i8* @malloc(i64 %conv)
  br label %return

return:                                           ; preds = %if.end3, %if.then2, %if.then
  %retval.0 = phi i8* [ null, %if.then ], [ %call, %if.then2 ], [ %call4, %if.end3 ]
  ret i8* %retval.0
}

define internal i8* @internal_argmem_only_rec_2(i32* %arg) {
; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
; CHECK-LABEL: define {{[^@]+}}@internal_argmem_only_rec_2
; CHECK-SAME: (i32* nocapture nofree noundef nonnull align 4 dereferenceable(4) [[ARG:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[ARG]], align 4
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, i32* [[ARG]], i64 -1
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_argmem_only_rec_1(i32* nocapture nofree nonnull align 4 dereferenceable(4) [[ADD_PTR]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
entry:
  store i32 0, i32* %arg, align 4
  %add.ptr = getelementptr inbounds i32, i32* %arg, i64 -1
  %call = call i8* @internal_argmem_only_rec_1(i32* nonnull %add.ptr)
  ret i8* %call
}

declare i8* @unknown_ptr() readnone
declare i8* @argmem_only(i8* %arg) argmemonly
declare i8* @inaccesible_argmem_only_decl(i8* %arg) inaccessiblemem_or_argmemonly
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) nounwind argmemonly willreturn

define void @callerA1(i8* %arg) {
; CHECK: Function Attrs: argmemonly
; CHECK-LABEL: define {{[^@]+}}@callerA1
; CHECK-SAME: (i8* [[ARG:%.*]]) #[[ATTR3:[0-9]+]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @argmem_only(i8* [[ARG]])
; CHECK-NEXT:    ret void
;
  call i8* @argmem_only(i8* %arg)
  ret void
}
define void @callerA2(i8* %arg) {
; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
; CHECK-LABEL: define {{[^@]+}}@callerA2
; CHECK-SAME: (i8* [[ARG:%.*]]) #[[ATTR1]] {
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @inaccesible_argmem_only_decl(i8* [[ARG]])
; CHECK-NEXT:    ret void
;
  call i8* @inaccesible_argmem_only_decl(i8* %arg)
  ret void
}
define void @callerB1() {
; CHECK: Function Attrs: readnone
; CHECK-LABEL: define {{[^@]+}}@callerB1
; CHECK-SAME: () #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:    [[STACK:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @argmem_only(i8* noundef nonnull dereferenceable(1) [[STACK]])
; CHECK-NEXT:    ret void
;
  %stack = alloca i8
  call i8* @argmem_only(i8* %stack)
  ret void
}
define void @callerB2() {
; CHECK: Function Attrs: inaccessiblememonly
; CHECK-LABEL: define {{[^@]+}}@callerB2
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    [[STACK:%.*]] = alloca i8, align 1
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @inaccesible_argmem_only_decl(i8* noundef nonnull dereferenceable(1) [[STACK]])
; CHECK-NEXT:    ret void
;
  %stack = alloca i8
  call i8* @inaccesible_argmem_only_decl(i8* %stack)
  ret void
}
define void @callerC1() {
; CHECK-LABEL: define {{[^@]+}}@callerC1() {
; CHECK-NEXT:    [[UNKNOWN:%.*]] = call i8* @unknown_ptr()
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @argmem_only(i8* [[UNKNOWN]])
; CHECK-NEXT:    ret void
;
  %unknown = call i8* @unknown_ptr()
  call i8* @argmem_only(i8* %unknown)
  ret void
}
define void @callerC2() {
; CHECK-LABEL: define {{[^@]+}}@callerC2() {
; CHECK-NEXT:    [[UNKNOWN:%.*]] = call i8* @unknown_ptr()
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @inaccesible_argmem_only_decl(i8* [[UNKNOWN]])
; CHECK-NEXT:    ret void
;
  %unknown = call i8* @unknown_ptr()
  call i8* @inaccesible_argmem_only_decl(i8* %unknown)
  ret void
}
define void @callerD1() {
; CHECK-LABEL: define {{[^@]+}}@callerD1() {
; CHECK-NEXT:    [[UNKNOWN:%.*]] = call i8* @argmem_only(i8* noalias nocapture noundef align 536870912 null)
; CHECK-NEXT:    store i8 0, i8* [[UNKNOWN]], align 1
; CHECK-NEXT:    ret void
;
  %unknown = call i8* @argmem_only(i8* null)
  store i8 0, i8* %unknown
  ret void
}
define void @callerD2() {
; CHECK-LABEL: define {{[^@]+}}@callerD2() {
; CHECK-NEXT:    [[UNKNOWN:%.*]] = call i8* @inaccesible_argmem_only_decl(i8* noalias nocapture noundef align 536870912 null)
; CHECK-NEXT:    store i8 0, i8* [[UNKNOWN]], align 1
; CHECK-NEXT:    ret void
;
  %unknown = call i8* @inaccesible_argmem_only_decl(i8* null)
  store i8 0, i8* %unknown
  ret void
}

define void @callerE(i8* %arg) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@callerE
; IS__TUNIT____-SAME: (i8* nocapture nofree readnone [[ARG:%.*]]) #[[ATTR5:[0-9]+]] {
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@callerE
; IS__CGSCC____-SAME: (i8* nocapture nofree readnone [[ARG:%.*]]) #[[ATTR5:[0-9]+]] {
; IS__CGSCC____-NEXT:    ret void
;
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %arg)
  ret void
}


define void @write_global() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@write_global
; IS__TUNIT____-SAME: () #[[ATTR6:[0-9]+]] {
; IS__TUNIT____-NEXT:    store i32 0, i32* @G, align 4
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@write_global
; IS__CGSCC____-SAME: () #[[ATTR6:[0-9]+]] {
; IS__CGSCC____-NEXT:    store i32 0, i32* @G, align 4
; IS__CGSCC____-NEXT:    ret void
;
  store i32 0, i32* @G, align 4
  ret void
}
define void @write_global_via_arg(i32* %GPtr) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@write_global_via_arg
; IS__TUNIT____-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[GPTR:%.*]]) #[[ATTR7:[0-9]+]] {
; IS__TUNIT____-NEXT:    store i32 0, i32* [[GPTR]], align 4
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@write_global_via_arg
; IS__CGSCC____-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[GPTR:%.*]]) #[[ATTR7:[0-9]+]] {
; IS__CGSCC____-NEXT:    store i32 0, i32* [[GPTR]], align 4
; IS__CGSCC____-NEXT:    ret void
;
  store i32 0, i32* %GPtr, align 4
  ret void
}
define internal void @write_global_via_arg_internal(i32* %GPtr) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@write_global_via_arg_internal
; IS__TUNIT____-SAME: () #[[ATTR6]] {
; IS__TUNIT____-NEXT:    store i32 0, i32* @G, align 4
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@write_global_via_arg_internal
; IS__CGSCC____-SAME: () #[[ATTR6]] {
; IS__CGSCC____-NEXT:    store i32 0, i32* @G, align 4
; IS__CGSCC____-NEXT:    ret void
;
  store i32 0, i32* %GPtr, align 4
  ret void
}

define void @writeonly_global() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@writeonly_global
; IS__TUNIT____-SAME: () #[[ATTR6]] {
; IS__TUNIT____-NEXT:    call void @write_global() #[[ATTR6]]
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@writeonly_global
; IS__CGSCC____-SAME: () #[[ATTR6]] {
; IS__CGSCC____-NEXT:    call void @write_global() #[[ATTR10:[0-9]+]]
; IS__CGSCC____-NEXT:    ret void
;
  call void @write_global()
  ret void
}
define void @writeonly_global_via_arg() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@writeonly_global_via_arg
; IS__TUNIT____-SAME: () #[[ATTR6]] {
; IS__TUNIT____-NEXT:    call void @write_global_via_arg(i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) @G) #[[ATTR6]]
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@writeonly_global_via_arg
; IS__CGSCC____-SAME: () #[[ATTR6]] {
; IS__CGSCC____-NEXT:    call void @write_global_via_arg(i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) @G) #[[ATTR10]]
; IS__CGSCC____-NEXT:    ret void
;
  call void @write_global_via_arg(i32* @G)
  ret void
}

define void @writeonly_global_via_arg_internal() {
;
; IS__TUNIT____: Function Attrs: nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@writeonly_global_via_arg_internal
; IS__TUNIT____-SAME: () #[[ATTR6]] {
; IS__TUNIT____-NEXT:    call void @write_global_via_arg_internal() #[[ATTR6]]
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@writeonly_global_via_arg_internal
; IS__CGSCC____-SAME: () #[[ATTR6]] {
; IS__CGSCC____-NEXT:    call void @write_global_via_arg_internal() #[[ATTR10]]
; IS__CGSCC____-NEXT:    ret void
;
  call void @write_global_via_arg_internal(i32* @G)
  ret void
}

define i8 @recursive_not_readnone(i8* %ptr, i1 %c) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@recursive_not_readnone
; IS__TUNIT____-SAME: (i8* nocapture nofree writeonly [[PTR:%.*]], i1 [[C:%.*]]) #[[ATTR8:[0-9]+]] {
; IS__TUNIT____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT____:       t:
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = call i8 @recursive_not_readnone(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 noundef false) #[[ATTR10:[0-9]+]], !range [[RNG0:![0-9]+]]
; IS__TUNIT____-NEXT:    ret i8 1
; IS__TUNIT____:       f:
; IS__TUNIT____-NEXT:    store i8 1, i8* [[PTR]], align 1
; IS__TUNIT____-NEXT:    ret i8 0
;
; IS__CGSCC____: Function Attrs: argmemonly nofree nosync nounwind writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@recursive_not_readnone
; IS__CGSCC____-SAME: (i8* nocapture nofree writeonly [[PTR:%.*]], i1 [[C:%.*]]) #[[ATTR8:[0-9]+]] {
; IS__CGSCC____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = call i8 @recursive_not_readnone(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 noundef false) #[[ATTR11:[0-9]+]], !range [[RNG0:![0-9]+]]
; IS__CGSCC____-NEXT:    ret i8 1
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    store i8 1, i8* [[PTR]], align 1
; IS__CGSCC____-NEXT:    ret i8 0
;
  %alloc = alloca i8
  br i1 %c, label %t, label %f
t:
  call i8 @recursive_not_readnone(i8* %alloc, i1 false)
  %r = load i8, i8* %alloc
  ret i8 %r
f:
  store i8 1, i8* %ptr
  ret i8 0
}

define internal i8 @recursive_not_readnone_internal(i8* %ptr, i1 %c) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@recursive_not_readnone_internal
; IS__TUNIT____-SAME: (i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[PTR:%.*]], i1 [[C:%.*]]) #[[ATTR8]] {
; IS__TUNIT____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT____:       t:
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = call i8 @recursive_not_readnone_internal(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 noundef false) #[[ATTR10]], !range [[RNG0]]
; IS__TUNIT____-NEXT:    ret i8 1
; IS__TUNIT____:       f:
; IS__TUNIT____-NEXT:    store i8 1, i8* [[PTR]], align 1
; IS__TUNIT____-NEXT:    ret i8 0
;
; IS__CGSCC____: Function Attrs: argmemonly nofree nosync nounwind writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@recursive_not_readnone_internal
; IS__CGSCC____-SAME: (i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[PTR:%.*]], i1 [[C:%.*]]) #[[ATTR8]] {
; IS__CGSCC____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = call i8 @recursive_not_readnone_internal(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 noundef false) #[[ATTR11]], !range [[RNG0]]
; IS__CGSCC____-NEXT:    ret i8 1
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    store i8 1, i8* [[PTR]], align 1
; IS__CGSCC____-NEXT:    ret i8 0
;
  %alloc = alloca i8
  br i1 %c, label %t, label %f
t:
  call i8 @recursive_not_readnone_internal(i8* %alloc, i1 false)
  %r = load i8, i8* %alloc
  ret i8 %r
f:
  store i8 1, i8* %ptr
  ret i8 0
}

define i8 @readnone_caller(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone
; IS__TUNIT____-LABEL: define {{[^@]+}}@readnone_caller
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) #[[ATTR9:[0-9]+]] {
; IS__TUNIT____-NEXT:    [[A:%.*]] = alloca i8, align 1
; IS__TUNIT____-NEXT:    [[R:%.*]] = call noundef i8 @recursive_not_readnone_internal(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[A]], i1 [[C]]) #[[ATTR10]], !range [[RNG0]]
; IS__TUNIT____-NEXT:    ret i8 [[R]]
;
; IS__CGSCC____: Function Attrs: nofree nosync nounwind readnone
; IS__CGSCC____-LABEL: define {{[^@]+}}@readnone_caller
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) #[[ATTR9:[0-9]+]] {
; IS__CGSCC____-NEXT:    [[A:%.*]] = alloca i8, align 1
; IS__CGSCC____-NEXT:    [[R:%.*]] = call noundef i8 @recursive_not_readnone_internal(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[A]], i1 [[C]]) #[[ATTR12:[0-9]+]], !range [[RNG0]]
; IS__CGSCC____-NEXT:    ret i8 [[R]]
;
  %a = alloca i8
  %r = call i8 @recursive_not_readnone_internal(i8* %a, i1 %c)
  ret i8 %r
}

define internal i8 @recursive_readnone_internal2(i8* %ptr, i1 %c) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@recursive_readnone_internal2
; IS__TUNIT____-SAME: (i8* nocapture nofree nonnull writeonly [[PTR:%.*]], i1 [[C:%.*]]) #[[ATTR8]] {
; IS__TUNIT____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT____:       t:
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = call i8 @recursive_readnone_internal2(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 noundef false) #[[ATTR10]], !range [[RNG0]]
; IS__TUNIT____-NEXT:    ret i8 1
; IS__TUNIT____:       f:
; IS__TUNIT____-NEXT:    store i8 1, i8* [[PTR]], align 1
; IS__TUNIT____-NEXT:    ret i8 0
;
; IS__CGSCC____: Function Attrs: argmemonly nofree nosync nounwind writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@recursive_readnone_internal2
; IS__CGSCC____-SAME: (i8* nocapture nofree nonnull writeonly [[PTR:%.*]], i1 [[C:%.*]]) #[[ATTR8]] {
; IS__CGSCC____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = call i8 @recursive_readnone_internal2(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 noundef false) #[[ATTR11]], !range [[RNG0]]
; IS__CGSCC____-NEXT:    ret i8 1
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    store i8 1, i8* [[PTR]], align 1
; IS__CGSCC____-NEXT:    ret i8 0
;
  %alloc = alloca i8
  br i1 %c, label %t, label %f
t:
  call i8 @recursive_readnone_internal2(i8* %alloc, i1 false)
  %r = load i8, i8* %alloc
  ret i8 %r
f:
  store i8 1, i8* %ptr
  ret i8 0
}

define i8 @readnone_caller2(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone
; IS__TUNIT____-LABEL: define {{[^@]+}}@readnone_caller2
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) #[[ATTR9]] {
; IS__TUNIT____-NEXT:    [[R:%.*]] = call noundef i8 @recursive_readnone_internal2(i8* undef, i1 [[C]]) #[[ATTR10]], !range [[RNG0]]
; IS__TUNIT____-NEXT:    ret i8 [[R]]
;
; IS__CGSCC____: Function Attrs: nofree nosync nounwind readnone
; IS__CGSCC____-LABEL: define {{[^@]+}}@readnone_caller2
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) #[[ATTR9]] {
; IS__CGSCC____-NEXT:    [[R:%.*]] = call noundef i8 @recursive_readnone_internal2(i8* undef, i1 [[C]]) #[[ATTR12]], !range [[RNG0]]
; IS__CGSCC____-NEXT:    ret i8 [[R]]
;
  %r = call i8 @recursive_readnone_internal2(i8* undef, i1 %c)
  ret i8 %r
}

define internal i8 @recursive_not_readnone_internal3(i8* %ptr, i1 %c) {
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@recursive_not_readnone_internal3
; IS__TUNIT____-SAME: (i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[PTR:%.*]], i1 [[C:%.*]]) #[[ATTR8]] {
; IS__TUNIT____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT____:       t:
; IS__TUNIT____-NEXT:    [[TMP1:%.*]] = call i8 @recursive_not_readnone_internal3(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 noundef false) #[[ATTR10]], !range [[RNG0]]
; IS__TUNIT____-NEXT:    ret i8 1
; IS__TUNIT____:       f:
; IS__TUNIT____-NEXT:    store i8 1, i8* [[PTR]], align 1
; IS__TUNIT____-NEXT:    ret i8 0
;
; IS__CGSCC____: Function Attrs: argmemonly nofree nosync nounwind writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@recursive_not_readnone_internal3
; IS__CGSCC____-SAME: (i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[PTR:%.*]], i1 [[C:%.*]]) #[[ATTR8]] {
; IS__CGSCC____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    [[TMP1:%.*]] = call i8 @recursive_not_readnone_internal3(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 noundef false) #[[ATTR11]], !range [[RNG0]]
; IS__CGSCC____-NEXT:    ret i8 1
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    store i8 1, i8* [[PTR]], align 1
; IS__CGSCC____-NEXT:    ret i8 0
;
  %alloc = alloca i8
  br i1 %c, label %t, label %f
t:
  call i8 @recursive_not_readnone_internal3(i8* %alloc, i1 false)
  %r = load i8, i8* %alloc
  ret i8 %r
f:
  store i8 1, i8* %ptr
  ret i8 0
}

define i8 @readnone_caller3(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone
; IS__TUNIT____-LABEL: define {{[^@]+}}@readnone_caller3
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) #[[ATTR9]] {
; IS__TUNIT____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__TUNIT____-NEXT:    [[R:%.*]] = call noundef i8 @recursive_not_readnone_internal3(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 [[C]]) #[[ATTR10]], !range [[RNG0]]
; IS__TUNIT____-NEXT:    ret i8 [[R]]
;
; IS__CGSCC____: Function Attrs: nofree nosync nounwind readnone
; IS__CGSCC____-LABEL: define {{[^@]+}}@readnone_caller3
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) #[[ATTR9]] {
; IS__CGSCC____-NEXT:    [[ALLOC:%.*]] = alloca i8, align 1
; IS__CGSCC____-NEXT:    [[R:%.*]] = call noundef i8 @recursive_not_readnone_internal3(i8* noalias nocapture nofree noundef nonnull writeonly dereferenceable(1) [[ALLOC]], i1 [[C]]) #[[ATTR12]], !range [[RNG0]]
; IS__CGSCC____-NEXT:    ret i8 [[R]]
;
  %alloc = alloca i8
  %r = call i8 @recursive_not_readnone_internal3(i8* %alloc, i1 %c)
  ret i8 %r
}

define internal void @argmemonly_before_ipconstprop(i32* %p) argmemonly {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@argmemonly_before_ipconstprop
; IS__TUNIT____-SAME: () #[[ATTR6]] {
; IS__TUNIT____-NEXT:    store i32 0, i32* @G, align 4
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@argmemonly_before_ipconstprop
; IS__CGSCC____-SAME: () #[[ATTR6]] {
; IS__CGSCC____-NEXT:    store i32 0, i32* @G, align 4
; IS__CGSCC____-NEXT:    ret void
;
  store i32 0, i32* %p
  ret void
}

define void @argmemonky_caller() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@argmemonky_caller
; IS__TUNIT____-SAME: () #[[ATTR6]] {
; IS__TUNIT____-NEXT:    call void @argmemonly_before_ipconstprop() #[[ATTR6]]
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@argmemonky_caller
; IS__CGSCC____-SAME: () #[[ATTR6]] {
; IS__CGSCC____-NEXT:    call void @argmemonly_before_ipconstprop() #[[ATTR10]]
; IS__CGSCC____-NEXT:    ret void
;
  call void @argmemonly_before_ipconstprop(i32* @G)
  ret void
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { inaccessiblememonly }
; IS__TUNIT____: attributes #[[ATTR1]] = { inaccessiblemem_or_argmemonly }
; IS__TUNIT____: attributes #[[ATTR2]] = { readnone }
; IS__TUNIT____: attributes #[[ATTR3]] = { argmemonly }
; IS__TUNIT____: attributes #[[ATTR4:[0-9]+]] = { argmemonly nofree nosync nounwind willreturn }
; IS__TUNIT____: attributes #[[ATTR5]] = { nofree nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR6]] = { nofree nosync nounwind willreturn writeonly }
; IS__TUNIT____: attributes #[[ATTR7]] = { argmemonly nofree nosync nounwind willreturn writeonly }
; IS__TUNIT____: attributes #[[ATTR8]] = { argmemonly nofree nosync nounwind writeonly }
; IS__TUNIT____: attributes #[[ATTR9]] = { nofree nosync nounwind readnone }
; IS__TUNIT____: attributes #[[ATTR10]] = { nofree nosync nounwind writeonly }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { inaccessiblememonly }
; IS__CGSCC____: attributes #[[ATTR1]] = { inaccessiblemem_or_argmemonly }
; IS__CGSCC____: attributes #[[ATTR2]] = { readnone }
; IS__CGSCC____: attributes #[[ATTR3]] = { argmemonly }
; IS__CGSCC____: attributes #[[ATTR4:[0-9]+]] = { argmemonly nofree nosync nounwind willreturn }
; IS__CGSCC____: attributes #[[ATTR5]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR6]] = { nofree norecurse nosync nounwind willreturn writeonly }
; IS__CGSCC____: attributes #[[ATTR7]] = { argmemonly nofree norecurse nosync nounwind willreturn writeonly }
; IS__CGSCC____: attributes #[[ATTR8]] = { argmemonly nofree nosync nounwind writeonly }
; IS__CGSCC____: attributes #[[ATTR9]] = { nofree nosync nounwind readnone }
; IS__CGSCC____: attributes #[[ATTR10]] = { nounwind willreturn writeonly }
; IS__CGSCC____: attributes #[[ATTR11]] = { nofree nosync nounwind writeonly }
; IS__CGSCC____: attributes #[[ATTR12]] = { nounwind writeonly }
;.
; CHECK: [[META0:![0-9]+]] = !{i8 0, i8 2}
;.
