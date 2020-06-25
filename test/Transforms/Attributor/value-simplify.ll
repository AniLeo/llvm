; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=17 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=17 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
declare void @f(i32)
declare token @llvm.call.preallocated.setup(i32)
declare i8* @llvm.call.preallocated.arg(token, i32)

; Test1: Replace argument with constant
define internal void @test1(i32 %a) {
; CHECK-LABEL: define {{[^@]+}}@test1() {
; CHECK-NEXT:    tail call void @f(i32 noundef 1)
; CHECK-NEXT:    ret void
;
  tail call void @f(i32 %a)
  ret void
}

define void @test1_helper() {
; CHECK-LABEL: define {{[^@]+}}@test1_helper() {
; CHECK-NEXT:    tail call void @test1()
; CHECK-NEXT:    ret void
;
  tail call void @test1(i32 1)
  ret void
}

; TEST 2 : Simplify return value
define i32 @return0() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@return0
; IS__TUNIT____-SAME: () [[ATTR1:#.*]] {
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@return0
; IS__CGSCC____-SAME: () [[ATTR1:#.*]] {
; IS__CGSCC____-NEXT:    ret i32 0
;
  ret i32 0
}

define i32 @return1() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@return1
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i32 1
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@return1
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i32 1
;
  ret i32 1
}

define i32 @test2_1(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@test2_1
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) [[ATTR1]] {
; IS__TUNIT____-NEXT:    br i1 [[C]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; IS__TUNIT____:       if.true:
; IS__TUNIT____-NEXT:    [[RET0:%.*]] = add i32 0, 1
; IS__TUNIT____-NEXT:    br label [[END:%.*]]
; IS__TUNIT____:       if.false:
; IS__TUNIT____-NEXT:    br label [[END]]
; IS__TUNIT____:       end:
; IS__TUNIT____-NEXT:    [[RET:%.*]] = phi i32 [ [[RET0]], [[IF_TRUE]] ], [ 1, [[IF_FALSE]] ]
; IS__TUNIT____-NEXT:    ret i32 1
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test2_1
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) [[ATTR1]] {
; IS__CGSCC____-NEXT:    br i1 [[C]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; IS__CGSCC____:       if.true:
; IS__CGSCC____-NEXT:    [[RET0:%.*]] = add i32 0, 1
; IS__CGSCC____-NEXT:    br label [[END:%.*]]
; IS__CGSCC____:       if.false:
; IS__CGSCC____-NEXT:    br label [[END]]
; IS__CGSCC____:       end:
; IS__CGSCC____-NEXT:    [[RET:%.*]] = phi i32 [ [[RET0]], [[IF_TRUE]] ], [ 1, [[IF_FALSE]] ]
; IS__CGSCC____-NEXT:    ret i32 1
;
  br i1 %c, label %if.true, label %if.false
if.true:
  %call = tail call i32 @return0()
  %ret0 = add i32 %call, 1
  br label %end
if.false:
  %ret1 = tail call i32 @return1()
  br label %end
end:

  %ret = phi i32 [ %ret0, %if.true ], [ %ret1, %if.false ]

  ret i32 1
}



define i32 @test2_2(i1 %c) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@test2_2
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i32 1
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test2_2
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i32 1
;
  %ret = tail call i32 @test2_1(i1 %c)
  ret i32 %ret
}

declare void @use(i32)
define void @test3(i1 %c) {
; CHECK-LABEL: define {{[^@]+}}@test3
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    br i1 [[C]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ 1, [[IF_TRUE]] ], [ 1, [[IF_FALSE]] ]
; CHECK-NEXT:    tail call void @use(i32 noundef 1)
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if.true, label %if.false
if.true:
  br label %end
if.false:
  %ret1 = tail call i32 @return1()
  br label %end
end:

  %r = phi i32 [ 1, %if.true ], [ %ret1, %if.false ]

  tail call void @use(i32 %r)
  ret void
}

define void @test-select-phi(i1 %c) {
; CHECK-LABEL: define {{[^@]+}}@test-select-phi
; CHECK-SAME: (i1 [[C:%.*]]) {
; CHECK-NEXT:    tail call void @use(i32 noundef 1)
; CHECK-NEXT:    [[SELECT_NOT_SAME:%.*]] = select i1 [[C]], i32 1, i32 0
; CHECK-NEXT:    tail call void @use(i32 noundef [[SELECT_NOT_SAME]])
; CHECK-NEXT:    br i1 [[C]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if-true:
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       if-false:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI_SAME:%.*]] = phi i32 [ 1, [[IF_TRUE]] ], [ 1, [[IF_FALSE]] ]
; CHECK-NEXT:    [[PHI_NOT_SAME:%.*]] = phi i32 [ 0, [[IF_TRUE]] ], [ 1, [[IF_FALSE]] ]
; CHECK-NEXT:    [[PHI_SAME_PROP:%.*]] = phi i32 [ 1, [[IF_TRUE]] ], [ 1, [[IF_FALSE]] ]
; CHECK-NEXT:    [[PHI_SAME_UNDEF:%.*]] = phi i32 [ 1, [[IF_TRUE]] ], [ undef, [[IF_FALSE]] ]
; CHECK-NEXT:    [[SELECT_NOT_SAME_UNDEF:%.*]] = select i1 [[C]], i32 [[PHI_NOT_SAME]], i32 undef
; CHECK-NEXT:    tail call void @use(i32 noundef 1)
; CHECK-NEXT:    tail call void @use(i32 noundef [[PHI_NOT_SAME]])
; CHECK-NEXT:    tail call void @use(i32 noundef 1)
; CHECK-NEXT:    tail call void @use(i32 1)
; CHECK-NEXT:    tail call void @use(i32 [[SELECT_NOT_SAME_UNDEF]])
; CHECK-NEXT:    ret void
;
  %select-same = select i1 %c, i32 1, i32 1
  tail call void @use(i32 %select-same)

  %select-not-same = select i1 %c, i32 1, i32 0
  tail call void @use(i32 %select-not-same)
  br i1 %c, label %if-true, label %if-false
if-true:
  br label %end
if-false:
  br label %end
end:
  %phi-same = phi i32 [ 1, %if-true ], [ 1, %if-false ]
  %phi-not-same = phi i32 [ 0, %if-true ], [ 1, %if-false ]
  %phi-same-prop = phi i32 [ 1, %if-true ], [ %select-same, %if-false ]
  %phi-same-undef = phi i32 [ 1, %if-true ], [ undef, %if-false ]
  %select-not-same-undef = select i1 %c, i32 %phi-not-same, i32 undef


  tail call void @use(i32 %phi-same)

  tail call void @use(i32 %phi-not-same)

  tail call void @use(i32 %phi-same-prop)

  tail call void @use(i32 %phi-same-undef)

  tail call void @use(i32 %select-not-same-undef)

  ret void

}

define i32 @ipccp1(i32 %a) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@ipccp1
; IS__TUNIT____-SAME: (i32 returned [[A:%.*]]) [[ATTR1]] {
; IS__TUNIT____-NEXT:    br i1 true, label [[T:%.*]], label [[F:%.*]]
; IS__TUNIT____:       t:
; IS__TUNIT____-NEXT:    ret i32 [[A]]
; IS__TUNIT____:       f:
; IS__TUNIT____-NEXT:    unreachable
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp1
; IS__CGSCC____-SAME: (i32 returned [[A:%.*]]) [[ATTR1]] {
; IS__CGSCC____-NEXT:    br i1 true, label [[T:%.*]], label [[F:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i32 [[A]]
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    unreachable
;
  br i1 true, label %t, label %f
t:
  ret i32 %a
f:
  %r = call i32 @ipccp1(i32 5)
  ret i32 %r
}

define internal i1 @ipccp2i(i1 %a) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp2i
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    br label [[T:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i1 undef
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    unreachable
;
  br i1 %a, label %t, label %f
t:
  ret i1 %a
f:
  %r = call i1 @ipccp2i(i1 false)
  ret i1 %r
}

define i1 @ipccp2() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@ipccp2
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i1 true
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp2
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i1 true
;
  %r = call i1 @ipccp2i(i1 true)
  ret i1 %r
}

define internal i1 @ipccp2ib(i1 %a) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp2ib
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    br label [[T:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i1 undef
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    unreachable
;
  br i1 %a, label %t, label %f
t:
  ret i1 true
f:
  %r = call i1 @ipccp2ib(i1 false)
  ret i1 %r
}

define i1 @ipccp2b() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@ipccp2b
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i1 true
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp2b
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i1 true
;
  %r = call i1 @ipccp2ib(i1 true)
  ret i1 %r
}

define internal i32 @ipccp3i(i32 %a) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp3i
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    br label [[T:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i32 undef
; IS__CGSCC____:       f:
; IS__CGSCC____-NEXT:    unreachable
;
  %c = icmp eq i32 %a, 7
  br i1 %c, label %t, label %f
t:
  ret i32 %a
f:
  %r = call i32 @ipccp3i(i32 5)
  ret i32 %r
}

define i32 @ipccp3() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@ipccp3
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i32 7
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp3
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i32 7
;
  %r = call i32 @ipccp3i(i32 7)
  ret i32 %r
}

; Do not touch complicated arguments (for now)
%struct.X = type { i8* }
define internal i32* @test_inalloca(i32* inalloca %a) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@test_inalloca
; IS__TUNIT____-SAME: (i32* inalloca noalias nofree nonnull returned writeonly dereferenceable(4) "no-capture-maybe-returned" [[A:%.*]]) [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i32* [[A]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_inalloca
; IS__CGSCC____-SAME: (i32* inalloca noalias nofree nonnull returned writeonly dereferenceable(4) "no-capture-maybe-returned" [[A:%.*]]) [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i32* [[A]]
;
  ret i32* %a
}
define i32* @complicated_args_inalloca(i32* %arg) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@complicated_args_inalloca
; IS__TUNIT____-SAME: (i32* nofree readnone returned "no-capture-maybe-returned" [[ARG:%.*]]) [[ATTR1]] {
; IS__TUNIT____-NEXT:    [[CALL:%.*]] = call i32* @test_inalloca(i32* noalias nofree writeonly "no-capture-maybe-returned" [[ARG]]) [[ATTR1]]
; IS__TUNIT____-NEXT:    ret i32* [[CALL]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@complicated_args_inalloca
; IS__CGSCC_OPM-SAME: (i32* nofree nonnull readnone returned dereferenceable(4) "no-capture-maybe-returned" [[ARG:%.*]]) [[ATTR1:#.*]] {
; IS__CGSCC_OPM-NEXT:    [[CALL:%.*]] = call i32* @test_inalloca(i32* noalias nofree nonnull writeonly dereferenceable(4) "no-capture-maybe-returned" [[ARG]]) [[ATTR5:#.*]]
; IS__CGSCC_OPM-NEXT:    ret i32* [[CALL]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@complicated_args_inalloca
; IS__CGSCC_NPM-SAME: (i32* nofree nonnull readnone returned dereferenceable(4) "no-capture-maybe-returned" [[ARG:%.*]]) [[ATTR1:#.*]] {
; IS__CGSCC_NPM-NEXT:    [[CALL:%.*]] = call i32* @test_inalloca(i32* noalias nofree nonnull writeonly dereferenceable(4) "no-capture-maybe-returned" [[ARG]]) [[ATTR4:#.*]]
; IS__CGSCC_NPM-NEXT:    ret i32* [[CALL]]
;
  %call = call i32* @test_inalloca(i32* %arg)
  ret i32* %call
}

define internal i32* @test_preallocated(i32* preallocated(i32) %a) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@test_preallocated
; IS__TUNIT____-SAME: (i32* noalias nofree noundef nonnull returned writeonly preallocated(i32) align 536870912 dereferenceable(4) "no-capture-maybe-returned" [[A:%.*]]) [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i32* [[A]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_preallocated
; IS__CGSCC____-SAME: (i32* noalias nofree noundef nonnull returned writeonly preallocated(i32) align 536870912 dereferenceable(4) "no-capture-maybe-returned" [[A:%.*]]) [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i32* [[A]]
;
  ret i32* %a
}
define i32* @complicated_args_preallocated() {
; IS__TUNIT_OPM: Function Attrs: nounwind
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@complicated_args_preallocated
; IS__TUNIT_OPM-SAME: () [[ATTR0:#.*]] {
; IS__TUNIT_OPM-NEXT:    [[C:%.*]] = call token @llvm.call.preallocated.setup(i32 noundef 1)
; IS__TUNIT_OPM-NEXT:    [[CALL:%.*]] = call i32* @test_preallocated(i32* noalias nocapture nofree noundef writeonly preallocated(i32) align 536870912 null) [[ATTR5:#.*]] [ "preallocated"(token [[C]]) ]
; IS__TUNIT_OPM-NEXT:    ret i32* [[CALL]]
;
; IS__TUNIT_NPM: Function Attrs: nounwind
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@complicated_args_preallocated
; IS__TUNIT_NPM-SAME: () [[ATTR0:#.*]] {
; IS__TUNIT_NPM-NEXT:    [[C:%.*]] = call token @llvm.call.preallocated.setup(i32 noundef 1)
; IS__TUNIT_NPM-NEXT:    [[CALL:%.*]] = call i32* @test_preallocated(i32* noalias nocapture nofree noundef writeonly preallocated(i32) align 536870912 null) [[ATTR4:#.*]] [ "preallocated"(token [[C]]) ]
; IS__TUNIT_NPM-NEXT:    ret i32* [[CALL]]
;
; IS__CGSCC_OPM: Function Attrs: nounwind
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@complicated_args_preallocated
; IS__CGSCC_OPM-SAME: () [[ATTR0:#.*]] {
; IS__CGSCC_OPM-NEXT:    [[C:%.*]] = call token @llvm.call.preallocated.setup(i32 noundef 1)
; IS__CGSCC_OPM-NEXT:    [[CALL:%.*]] = call i32* @test_preallocated(i32* noalias nocapture nofree noundef writeonly preallocated(i32) align 536870912 null) [[ATTR6:#.*]] [ "preallocated"(token [[C]]) ]
; IS__CGSCC_OPM-NEXT:    ret i32* [[CALL]]
;
; IS__CGSCC_NPM: Function Attrs: nounwind
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@complicated_args_preallocated
; IS__CGSCC_NPM-SAME: () [[ATTR0:#.*]] {
; IS__CGSCC_NPM-NEXT:    [[C:%.*]] = call token @llvm.call.preallocated.setup(i32 noundef 1)
; IS__CGSCC_NPM-NEXT:    [[CALL:%.*]] = call i32* @test_preallocated(i32* noalias nocapture nofree noundef writeonly preallocated(i32) align 536870912 null) [[ATTR5:#.*]] [ "preallocated"(token [[C]]) ]
; IS__CGSCC_NPM-NEXT:    ret i32* [[CALL]]
;
  %c = call token @llvm.call.preallocated.setup(i32 1)
  %call = call i32* @test_preallocated(i32* preallocated(i32) null) ["preallocated"(token %c)]
  ret i32* %call
}

define internal void @test_sret(%struct.X* sret %a, %struct.X** %b) {
;
; IS__TUNIT____: Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
; IS__TUNIT____-LABEL: define {{[^@]+}}@test_sret
; IS__TUNIT____-SAME: (%struct.X* noalias nofree noundef nonnull sret writeonly align 536870912 dereferenceable(8) [[A:%.*]], %struct.X** nocapture nofree nonnull writeonly align 8 dereferenceable(8) [[B:%.*]]) [[ATTR2:#.*]] {
; IS__TUNIT____-NEXT:    store %struct.X* [[A]], %struct.X** [[B]], align 8
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_sret
; IS__CGSCC____-SAME: (%struct.X* noalias nofree noundef nonnull sret writeonly align 536870912 dereferenceable(8) [[A:%.*]], %struct.X** nocapture nofree nonnull writeonly align 8 dereferenceable(8) [[B:%.*]]) [[ATTR2:#.*]] {
; IS__CGSCC____-NEXT:    store %struct.X* [[A]], %struct.X** [[B]], align 8
; IS__CGSCC____-NEXT:    ret void
;
  store %struct.X* %a, %struct.X** %b
  ret void
}
; FIXME: Alignment and dereferenceability are not propagated to the argument
define void @complicated_args_sret(%struct.X** %b) {
;
; IS__TUNIT_OPM: Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@complicated_args_sret
; IS__TUNIT_OPM-SAME: (%struct.X** nocapture nofree writeonly [[B:%.*]]) [[ATTR2:#.*]] {
; IS__TUNIT_OPM-NEXT:    call void @test_sret(%struct.X* noalias nocapture nofree noundef writeonly align 536870912 null, %struct.X** nocapture nofree writeonly align 8 [[B]]) [[ATTR6:#.*]]
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM: Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@complicated_args_sret
; IS__TUNIT_NPM-SAME: (%struct.X** nocapture nofree writeonly [[B:%.*]]) [[ATTR2:#.*]] {
; IS__TUNIT_NPM-NEXT:    call void @test_sret(%struct.X* noalias nocapture nofree noundef writeonly align 536870912 null, %struct.X** nocapture nofree writeonly align 8 [[B]]) [[ATTR5:#.*]]
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@complicated_args_sret
; IS__CGSCC____-SAME: (%struct.X** nocapture nofree nonnull writeonly align 8 dereferenceable(8) [[B:%.*]]) [[ATTR2]] {
; IS__CGSCC____-NEXT:    unreachable
;
  call void @test_sret(%struct.X* null, %struct.X** %b)
  ret void
}

define internal %struct.X* @test_nest(%struct.X* nest %a) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@test_nest
; IS__TUNIT____-SAME: (%struct.X* nest noalias nofree noundef readnone returned align 536870912 "no-capture-maybe-returned" [[A:%.*]]) [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret %struct.X* [[A]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_nest
; IS__CGSCC____-SAME: (%struct.X* nest noalias nofree noundef readnone returned align 536870912 "no-capture-maybe-returned" [[A:%.*]]) [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret %struct.X* [[A]]
;
  ret %struct.X* %a
}
define %struct.X* @complicated_args_nest() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@complicated_args_nest
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    [[CALL:%.*]] = call %struct.X* @test_nest(%struct.X* noalias nocapture nofree noundef readnone align 536870912 null) [[ATTR1]]
; IS__TUNIT____-NEXT:    ret %struct.X* [[CALL]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@complicated_args_nest
; IS__CGSCC_OPM-SAME: () [[ATTR1]] {
; IS__CGSCC_OPM-NEXT:    [[CALL:%.*]] = call %struct.X* @test_nest(%struct.X* noalias nocapture nofree noundef readnone align 536870912 null) [[ATTR5]]
; IS__CGSCC_OPM-NEXT:    ret %struct.X* [[CALL]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@complicated_args_nest
; IS__CGSCC_NPM-SAME: () [[ATTR1]] {
; IS__CGSCC_NPM-NEXT:    [[CALL:%.*]] = call %struct.X* @test_nest(%struct.X* noalias nocapture nofree noundef readnone align 536870912 null) [[ATTR4]]
; IS__CGSCC_NPM-NEXT:    ret %struct.X* [[CALL]]
;
  %call = call %struct.X* @test_nest(%struct.X* null)
  ret %struct.X* %call
}

@S = external global %struct.X
define internal void @test_byval(%struct.X* byval %a) {
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@test_byval
; IS__CGSCC_OPM-SAME: (%struct.X* noalias nocapture nofree noundef nonnull writeonly byval align 8 dereferenceable(8) [[A:%.*]]) [[ATTR1]] {
; IS__CGSCC_OPM-NEXT:    [[G0:%.*]] = getelementptr [[STRUCT_X:%.*]], %struct.X* [[A]], i32 0, i32 0
; IS__CGSCC_OPM-NEXT:    store i8* null, i8** [[G0]], align 8
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@test_byval
; IS__CGSCC_NPM-SAME: (i8* noalias nocapture nofree readnone [[TMP0:%.*]]) [[ATTR1]] {
; IS__CGSCC_NPM-NEXT:    [[A_PRIV:%.*]] = alloca [[STRUCT_X:%.*]], align 8
; IS__CGSCC_NPM-NEXT:    [[A_PRIV_CAST:%.*]] = bitcast %struct.X* [[A_PRIV]] to i8**
; IS__CGSCC_NPM-NEXT:    store i8* [[TMP0]], i8** [[A_PRIV_CAST]], align 8
; IS__CGSCC_NPM-NEXT:    [[G0:%.*]] = getelementptr [[STRUCT_X]], %struct.X* [[A_PRIV]], i32 0, i32 0
; IS__CGSCC_NPM-NEXT:    store i8* null, i8** [[G0]], align 8
; IS__CGSCC_NPM-NEXT:    ret void
;
  %g0 = getelementptr %struct.X, %struct.X* %a, i32 0, i32 0
  store i8* null, i8** %g0
  ret void
}
define void @complicated_args_byval() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@complicated_args_byval
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@complicated_args_byval
; IS__CGSCC_OPM-SAME: () [[ATTR1]] {
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@complicated_args_byval
; IS__CGSCC_NPM-SAME: () [[ATTR3:#.*]] {
; IS__CGSCC_NPM-NEXT:    ret void
;
  call void @test_byval(%struct.X* @S)
  ret void
}

define internal i8*@test_byval2(%struct.X* byval %a) {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readonly willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@test_byval2
; IS__TUNIT____-SAME: () [[ATTR3:#.*]] {
; IS__TUNIT____-NEXT:    [[G0:%.*]] = getelementptr [[STRUCT_X:%.*]], %struct.X* @S, i32 0, i32 0
; IS__TUNIT____-NEXT:    [[L:%.*]] = load i8*, i8** [[G0]], align 8
; IS__TUNIT____-NEXT:    ret i8* [[L]]
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_byval2
; IS__CGSCC____-SAME: () [[ATTR3:#.*]] {
; IS__CGSCC____-NEXT:    [[G0:%.*]] = getelementptr [[STRUCT_X:%.*]], %struct.X* @S, i32 0, i32 0
; IS__CGSCC____-NEXT:    [[L:%.*]] = load i8*, i8** [[G0]], align 8
; IS__CGSCC____-NEXT:    ret i8* [[L]]
;
  %g0 = getelementptr %struct.X, %struct.X* %a, i32 0, i32 0
  %l = load i8*, i8** %g0
  ret i8* %l
}
define i8* @complicated_args_byval2() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readonly willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@complicated_args_byval2
; IS__TUNIT____-SAME: () [[ATTR3]] {
; IS__TUNIT____-NEXT:    [[C:%.*]] = call i8* @test_byval2() [[ATTR3]]
; IS__TUNIT____-NEXT:    ret i8* [[C]]
;
; IS__CGSCC_OPM: Function Attrs: nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@complicated_args_byval2
; IS__CGSCC_OPM-SAME: () [[ATTR3:#.*]] {
; IS__CGSCC_OPM-NEXT:    [[C:%.*]] = call i8* @test_byval2() [[ATTR7:#.*]]
; IS__CGSCC_OPM-NEXT:    ret i8* [[C]]
;
; IS__CGSCC_NPM: Function Attrs: nofree norecurse nosync nounwind readonly willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@complicated_args_byval2
; IS__CGSCC_NPM-SAME: () [[ATTR3]] {
; IS__CGSCC_NPM-NEXT:    [[C:%.*]] = call i8* @test_byval2() [[ATTR6:#.*]]
; IS__CGSCC_NPM-NEXT:    ret i8* [[C]]
;
  %c = call i8* @test_byval2(%struct.X* @S)
  ret i8* %c
}

define void @fixpoint_changed(i32* %p) {
; IS__TUNIT_OPM: Function Attrs: argmemonly nofree nosync nounwind writeonly
; IS__TUNIT_OPM-LABEL: define {{[^@]+}}@fixpoint_changed
; IS__TUNIT_OPM-SAME: (i32* nocapture nofree writeonly [[P:%.*]]) [[ATTR4:#.*]] {
; IS__TUNIT_OPM-NEXT:  entry:
; IS__TUNIT_OPM-NEXT:    br label [[FOR_COND:%.*]]
; IS__TUNIT_OPM:       for.cond:
; IS__TUNIT_OPM-NEXT:    [[J_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[SW_EPILOG:%.*]] ]
; IS__TUNIT_OPM-NEXT:    [[CMP:%.*]] = icmp slt i32 [[J_0]], 30
; IS__TUNIT_OPM-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; IS__TUNIT_OPM:       for.body:
; IS__TUNIT_OPM-NEXT:    switch i32 [[J_0]], label [[SW_EPILOG]] [
; IS__TUNIT_OPM-NEXT:    i32 1, label [[SW_BB:%.*]]
; IS__TUNIT_OPM-NEXT:    ]
; IS__TUNIT_OPM:       sw.bb:
; IS__TUNIT_OPM-NEXT:    br label [[SW_EPILOG]]
; IS__TUNIT_OPM:       sw.epilog:
; IS__TUNIT_OPM-NEXT:    [[X_0:%.*]] = phi i32 [ 255, [[FOR_BODY]] ], [ 253, [[SW_BB]] ]
; IS__TUNIT_OPM-NEXT:    store i32 [[X_0]], i32* [[P]], align 4
; IS__TUNIT_OPM-NEXT:    [[INC]] = add nsw i32 [[J_0]], 1
; IS__TUNIT_OPM-NEXT:    br label [[FOR_COND]]
; IS__TUNIT_OPM:       for.end:
; IS__TUNIT_OPM-NEXT:    ret void
;
; IS__TUNIT_NPM: Function Attrs: argmemonly nofree nosync nounwind willreturn writeonly
; IS__TUNIT_NPM-LABEL: define {{[^@]+}}@fixpoint_changed
; IS__TUNIT_NPM-SAME: (i32* nocapture nofree writeonly [[P:%.*]]) [[ATTR2]] {
; IS__TUNIT_NPM-NEXT:  entry:
; IS__TUNIT_NPM-NEXT:    br label [[FOR_COND:%.*]]
; IS__TUNIT_NPM:       for.cond:
; IS__TUNIT_NPM-NEXT:    [[J_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[SW_EPILOG:%.*]] ]
; IS__TUNIT_NPM-NEXT:    [[CMP:%.*]] = icmp slt i32 [[J_0]], 30
; IS__TUNIT_NPM-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; IS__TUNIT_NPM:       for.body:
; IS__TUNIT_NPM-NEXT:    switch i32 [[J_0]], label [[SW_EPILOG]] [
; IS__TUNIT_NPM-NEXT:    i32 1, label [[SW_BB:%.*]]
; IS__TUNIT_NPM-NEXT:    ]
; IS__TUNIT_NPM:       sw.bb:
; IS__TUNIT_NPM-NEXT:    br label [[SW_EPILOG]]
; IS__TUNIT_NPM:       sw.epilog:
; IS__TUNIT_NPM-NEXT:    [[X_0:%.*]] = phi i32 [ 255, [[FOR_BODY]] ], [ 253, [[SW_BB]] ]
; IS__TUNIT_NPM-NEXT:    store i32 [[X_0]], i32* [[P]], align 4
; IS__TUNIT_NPM-NEXT:    [[INC]] = add nsw i32 [[J_0]], 1
; IS__TUNIT_NPM-NEXT:    br label [[FOR_COND]]
; IS__TUNIT_NPM:       for.end:
; IS__TUNIT_NPM-NEXT:    ret void
;
; IS__CGSCC_OPM: Function Attrs: argmemonly nofree norecurse nosync nounwind writeonly
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@fixpoint_changed
; IS__CGSCC_OPM-SAME: (i32* nocapture nofree writeonly [[P:%.*]]) [[ATTR4:#.*]] {
; IS__CGSCC_OPM-NEXT:  entry:
; IS__CGSCC_OPM-NEXT:    br label [[FOR_COND:%.*]]
; IS__CGSCC_OPM:       for.cond:
; IS__CGSCC_OPM-NEXT:    [[J_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[SW_EPILOG:%.*]] ]
; IS__CGSCC_OPM-NEXT:    [[CMP:%.*]] = icmp slt i32 [[J_0]], 30
; IS__CGSCC_OPM-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; IS__CGSCC_OPM:       for.body:
; IS__CGSCC_OPM-NEXT:    switch i32 [[J_0]], label [[SW_EPILOG]] [
; IS__CGSCC_OPM-NEXT:    i32 1, label [[SW_BB:%.*]]
; IS__CGSCC_OPM-NEXT:    ]
; IS__CGSCC_OPM:       sw.bb:
; IS__CGSCC_OPM-NEXT:    br label [[SW_EPILOG]]
; IS__CGSCC_OPM:       sw.epilog:
; IS__CGSCC_OPM-NEXT:    [[X_0:%.*]] = phi i32 [ 255, [[FOR_BODY]] ], [ 253, [[SW_BB]] ]
; IS__CGSCC_OPM-NEXT:    store i32 [[X_0]], i32* [[P]], align 4
; IS__CGSCC_OPM-NEXT:    [[INC]] = add nsw i32 [[J_0]], 1
; IS__CGSCC_OPM-NEXT:    br label [[FOR_COND]]
; IS__CGSCC_OPM:       for.end:
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@fixpoint_changed
; IS__CGSCC_NPM-SAME: (i32* nocapture nofree writeonly [[P:%.*]]) [[ATTR2:#.*]] {
; IS__CGSCC_NPM-NEXT:  entry:
; IS__CGSCC_NPM-NEXT:    br label [[FOR_COND:%.*]]
; IS__CGSCC_NPM:       for.cond:
; IS__CGSCC_NPM-NEXT:    [[J_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[SW_EPILOG:%.*]] ]
; IS__CGSCC_NPM-NEXT:    [[CMP:%.*]] = icmp slt i32 [[J_0]], 30
; IS__CGSCC_NPM-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; IS__CGSCC_NPM:       for.body:
; IS__CGSCC_NPM-NEXT:    switch i32 [[J_0]], label [[SW_EPILOG]] [
; IS__CGSCC_NPM-NEXT:    i32 1, label [[SW_BB:%.*]]
; IS__CGSCC_NPM-NEXT:    ]
; IS__CGSCC_NPM:       sw.bb:
; IS__CGSCC_NPM-NEXT:    br label [[SW_EPILOG]]
; IS__CGSCC_NPM:       sw.epilog:
; IS__CGSCC_NPM-NEXT:    [[X_0:%.*]] = phi i32 [ 255, [[FOR_BODY]] ], [ 253, [[SW_BB]] ]
; IS__CGSCC_NPM-NEXT:    store i32 [[X_0]], i32* [[P]], align 4
; IS__CGSCC_NPM-NEXT:    [[INC]] = add nsw i32 [[J_0]], 1
; IS__CGSCC_NPM-NEXT:    br label [[FOR_COND]]
; IS__CGSCC_NPM:       for.end:
; IS__CGSCC_NPM-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:
  %j.0 = phi i32 [ 0, %entry ], [ %inc, %sw.epilog ]
  %cmp = icmp slt i32 %j.0, 30
  br i1 %cmp, label %for.body, label %for.end

for.body:
  switch i32 %j.0, label %sw.epilog [
  i32 1, label %sw.bb
  ]

sw.bb:
  br label %sw.epilog

sw.epilog:
  %x.0 = phi i32 [ 255, %for.body ], [ 253, %sw.bb ]
  store i32 %x.0, i32* %p
  %inc = add nsw i32 %j.0, 1
  br label %for.cond

for.end:
  ret void
}

; Check we merge undef and a constant properly.
define i8 @caller0() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller0
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i8 49
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller0
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i8 49
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define i8 @caller1() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller1
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i8 49
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller1
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i8 49
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define i8 @caller2() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller2
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i8 49
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller2
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i8 49
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define i8 @caller_middle() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller_middle
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i8 49
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller_middle
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i8 49
;
  %c = call i8 @callee(i8 42)
  ret i8 %c
}
define i8 @caller3() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller3
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i8 49
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller3
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i8 49
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define i8 @caller4() {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller4
; IS__TUNIT____-SAME: () [[ATTR1]] {
; IS__TUNIT____-NEXT:    ret i8 49
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller4
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i8 49
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define internal i8 @callee(i8 %a) {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@callee
; IS__CGSCC____-SAME: () [[ATTR1]] {
; IS__CGSCC____-NEXT:    ret i8 undef
;
  %c = add i8 %a, 7
  ret i8 %c
}

