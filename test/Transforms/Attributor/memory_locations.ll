; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=7 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=7 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

; CHECK: Function Attrs: inaccessiblememonly
declare noalias i8* @malloc(i64) inaccessiblememonly

; CHECK: Function Attrs: inaccessiblememonly
define dso_local i8* @internal_only(i32 %arg) {
; CHECK-LABEL: define {{[^@]+}}@internal_only
; CHECK-SAME: (i32 [[ARG:%.*]])
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

; CHECK: Function Attrs: inaccessiblememonly
define dso_local i8* @internal_only_rec(i32 %arg) {
; CHECK-LABEL: define {{[^@]+}}@internal_only_rec
; CHECK-SAME: (i32 [[ARG:%.*]])
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

; CHECK: Function Attrs: inaccessiblememonly
define dso_local i8* @internal_only_rec_static_helper(i32 %arg) {
; CHECK-LABEL: define {{[^@]+}}@internal_only_rec_static_helper
; CHECK-SAME: (i32 [[ARG:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_only_rec_static(i32 [[ARG]])
; CHECK-NEXT:    ret i8* [[CALL]]
;
entry:
  %call = call i8* @internal_only_rec_static(i32 %arg)
  ret i8* %call
}

; CHECK: Function Attrs: inaccessiblememonly
define internal i8* @internal_only_rec_static(i32 %arg) {
; CHECK-LABEL: define {{[^@]+}}@internal_only_rec_static
; CHECK-SAME: (i32 [[ARG:%.*]])
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
; CHECK-SAME: (i32 [[ARG:%.*]])
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
; CHECK-SAME: (i32 [[ARG:%.*]])
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
; CHECK-NEXT:    store i8 0, i8* [[CALL1]]
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

; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
define dso_local i8* @internal_argmem_only_read(i32* %arg) {
; CHECK-LABEL: define {{[^@]+}}@internal_argmem_only_read
; CHECK-SAME: (i32* nocapture nonnull readonly align 4 dereferenceable(4) [[ARG:%.*]])
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

; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
define dso_local i8* @internal_argmem_only_write(i32* %arg) {
; CHECK-LABEL: define {{[^@]+}}@internal_argmem_only_write
; CHECK-SAME: (i32* nocapture nonnull writeonly align 4 dereferenceable(4) [[ARG:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 10, i32* [[ARG]], align 4
; CHECK-NEXT:    [[CALL:%.*]] = call noalias dereferenceable_or_null(10) i8* @malloc(i64 10)
; CHECK-NEXT:    ret i8* [[CALL]]
;
entry:
  store i32 10, i32* %arg, align 4
  %call = call dereferenceable_or_null(10) i8* @malloc(i64 10)
  ret i8* %call
}

; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
define dso_local i8* @internal_argmem_only_rec(i32* %arg) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@internal_argmem_only_rec
; IS__TUNIT____-SAME: (i32* nocapture align 4 [[ARG:%.*]])
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_argmem_only_rec_1(i32* nocapture align 4 [[ARG]])
; IS__TUNIT____-NEXT:    ret i8* [[CALL]]
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@internal_argmem_only_rec
; IS__CGSCC____-SAME: (i32* nocapture nonnull align 4 dereferenceable(4) [[ARG:%.*]])
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_argmem_only_rec_1(i32* nocapture nonnull align 4 dereferenceable(4) [[ARG]])
; IS__CGSCC____-NEXT:    ret i8* [[CALL]]
;
entry:
  %call = call i8* @internal_argmem_only_rec_1(i32* %arg)
  ret i8* %call
}

; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
define internal i8* @internal_argmem_only_rec_1(i32* %arg) {
; CHECK-LABEL: define {{[^@]+}}@internal_argmem_only_rec_1
; CHECK-SAME: (i32* nocapture nonnull align 4 dereferenceable(4) [[ARG:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TMP]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_THEN:%.*]], label [[IF_END:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[RETURN:%.*]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[TMP1]], 1
; CHECK-NEXT:    br i1 [[CMP1]], label [[IF_THEN2:%.*]], label [[IF_END3:%.*]]
; CHECK:       if.then2:
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, i32* [[ARG]], i64 -1
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_argmem_only_rec_2(i32* nocapture nonnull align 4 dereferenceable(4) [[ADD_PTR]])
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       if.end3:
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK-NEXT:    [[CONV:%.*]] = sext i32 [[TMP2]] to i64
; CHECK-NEXT:    [[CALL4:%.*]] = call noalias i8* @malloc(i64 [[CONV]])
; CHECK-NEXT:    br label [[RETURN]]
; CHECK:       return:
; CHECK-NEXT:    [[RETVAL_0:%.*]] = phi i8* [ null, [[IF_THEN]] ], [ [[CALL]], [[IF_THEN2]] ], [ [[CALL4]], [[IF_END3]] ]
; CHECK-NEXT:    ret i8* [[RETVAL_0]]
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

; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
define internal i8* @internal_argmem_only_rec_2(i32* %arg) {
; CHECK-LABEL: define {{[^@]+}}@internal_argmem_only_rec_2
; CHECK-SAME: (i32* nocapture nonnull align 4 dereferenceable(4) [[ARG:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i32 0, i32* [[ARG]], align 4
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, i32* [[ARG]], i64 -1
; CHECK-NEXT:    [[CALL:%.*]] = call noalias i8* @internal_argmem_only_rec_1(i32* nocapture nonnull align 4 dereferenceable(4) [[ADD_PTR]])
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

; CHECK: Function Attrs: argmemonly
define void @callerA1(i8* %arg) {
; CHECK-LABEL: define {{[^@]+}}@callerA1
; CHECK-SAME: (i8* [[ARG:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @argmem_only(i8* [[ARG]])
; CHECK-NEXT:    ret void
;
  call i8* @argmem_only(i8* %arg)
  ret void
}
; CHECK: Function Attrs: inaccessiblemem_or_argmemonly
define void @callerA2(i8* %arg) {
; CHECK-LABEL: define {{[^@]+}}@callerA2
; CHECK-SAME: (i8* [[ARG:%.*]])
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @inaccesible_argmem_only_decl(i8* [[ARG]])
; CHECK-NEXT:    ret void
;
  call i8* @inaccesible_argmem_only_decl(i8* %arg)
  ret void
}
; CHECK: Function Attrs: readnone
define void @callerB1() {
; CHECK-LABEL: define {{[^@]+}}@callerB1()
; CHECK-NEXT:    [[STACK:%.*]] = alloca i8
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @argmem_only(i8* nonnull dereferenceable(1) [[STACK]])
; CHECK-NEXT:    ret void
;
  %stack = alloca i8
  call i8* @argmem_only(i8* %stack)
  ret void
}
; CHECK: Function Attrs: inaccessiblememonly
define void @callerB2() {
; CHECK-LABEL: define {{[^@]+}}@callerB2()
; CHECK-NEXT:    [[STACK:%.*]] = alloca i8
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @inaccesible_argmem_only_decl(i8* nonnull dereferenceable(1) [[STACK]])
; CHECK-NEXT:    ret void
;
  %stack = alloca i8
  call i8* @inaccesible_argmem_only_decl(i8* %stack)
  ret void
}
; CHECK-NOT: Function Attrs
define void @callerC1() {
; CHECK-LABEL: define {{[^@]+}}@callerC1()
; CHECK-NEXT:    [[UNKNOWN:%.*]] = call i8* @unknown_ptr()
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @argmem_only(i8* [[UNKNOWN]])
; CHECK-NEXT:    ret void
;
  %unknown = call i8* @unknown_ptr()
  call i8* @argmem_only(i8* %unknown)
  ret void
}
; CHECK-NOT: Function Attrs
define void @callerC2() {
; CHECK-LABEL: define {{[^@]+}}@callerC2()
; CHECK-NEXT:    [[UNKNOWN:%.*]] = call i8* @unknown_ptr()
; CHECK-NEXT:    [[TMP1:%.*]] = call i8* @inaccesible_argmem_only_decl(i8* [[UNKNOWN]])
; CHECK-NEXT:    ret void
;
  %unknown = call i8* @unknown_ptr()
  call i8* @inaccesible_argmem_only_decl(i8* %unknown)
  ret void
}
; CHECK-NOT: Function Attrs
define void @callerD1() {
; CHECK-LABEL: define {{[^@]+}}@callerD1()
; CHECK-NEXT:    [[UNKNOWN:%.*]] = call i8* @argmem_only(i8* noalias nocapture align 536870912 null)
; CHECK-NEXT:    store i8 0, i8* [[UNKNOWN]]
; CHECK-NEXT:    ret void
;
  %unknown = call i8* @argmem_only(i8* null)
  store i8 0, i8* %unknown
  ret void
}
; CHECK-NOT: Function Attrs
define void @callerD2() {
; CHECK-LABEL: define {{[^@]+}}@callerD2()
; CHECK-NEXT:    [[UNKNOWN:%.*]] = call i8* @inaccesible_argmem_only_decl(i8* noalias nocapture align 536870912 null)
; CHECK-NEXT:    store i8 0, i8* [[UNKNOWN]]
; CHECK-NEXT:    ret void
;
  %unknown = call i8* @inaccesible_argmem_only_decl(i8* null)
  store i8 0, i8* %unknown
  ret void
}
; CHECK: Function Attrs: argmemonly nounwind willreturn
define void @callerE(i8* %arg) {
; CHECK-LABEL: define {{[^@]+}}@callerE
; CHECK-SAME: (i8* nocapture [[ARG:%.*]])
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* nocapture [[ARG]])
; CHECK-NEXT:    ret void
;
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %arg)
  ret void
}

@G = external dso_local global i32, align 4

; CHECK: Function Attrs:
; CHECK-SAME: writeonly
define void @write_global() {
; CHECK-LABEL: define {{[^@]+}}@write_global()
; CHECK-NEXT:    store i32 0, i32* @G, align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* @G, align 4
  ret void
}
; CHECK: Function Attrs: argmemonly
; CHECK-SAME: writeonly
define void @write_global_via_arg(i32* %GPtr) {
; CHECK-LABEL: define {{[^@]+}}@write_global_via_arg
; CHECK-SAME: (i32* nocapture nofree nonnull writeonly align 4 dereferenceable(4) [[GPTR:%.*]])
; CHECK-NEXT:    store i32 0, i32* [[GPTR]], align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %GPtr, align 4
  ret void
}

; CHECK: Function Attrs:
; CHECK-SAME: writeonly
define void @writeonly_global() {
; CHECK-LABEL: define {{[^@]+}}@writeonly_global()
; CHECK-NEXT:    call void @write_global()
; CHECK-NEXT:    ret void
;
  call void @write_global()
  ret void
}
; CHECK: Function Attrs:
; CHECK-SAME: writeonly
define void @writeonly_global_via_arg() {
; CHECK-LABEL: define {{[^@]+}}@writeonly_global_via_arg()
; CHECK-NEXT:    call void @write_global_via_arg(i32* nocapture nofree nonnull writeonly align 4 dereferenceable(4) @G)
; CHECK-NEXT:    ret void
;
  call void @write_global_via_arg(i32* @G)
  ret void
}
