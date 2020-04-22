; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
declare void @f(i32)

; Test1: Replace argument with constant
define internal void @test1(i32 %a) {
; CHECK-LABEL: define {{[^@]+}}@test1()
; CHECK-NEXT:    tail call void @f(i32 1)
; CHECK-NEXT:    ret void
;
  tail call void @f(i32 %a)
  ret void
}

define void @test1_helper() {
; CHECK-LABEL: define {{[^@]+}}@test1_helper()
; CHECK-NEXT:    tail call void @test1()
; CHECK-NEXT:    ret void
;
  tail call void @test1(i32 1)
  ret void
}

; TEST 2 : Simplify return value
define i32 @return0() {
; CHECK-LABEL: define {{[^@]+}}@return0()
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

define i32 @return1() {
; CHECK-LABEL: define {{[^@]+}}@return1()
; CHECK-NEXT:    ret i32 1
;
  ret i32 1
}

define i32 @test2_1(i1 %c) {
; CHECK-LABEL: define {{[^@]+}}@test2_1
; CHECK-SAME: (i1 [[C:%.*]])
; CHECK-NEXT:    br i1 [[C]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    [[RET0:%.*]] = add i32 0, 1
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[RET:%.*]] = phi i32 [ [[RET0]], [[IF_TRUE]] ], [ 1, [[IF_FALSE]] ]
; CHECK-NEXT:    ret i32 1
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
; CHECK-LABEL: define {{[^@]+}}@test2_2
; CHECK-SAME: (i1 [[C:%.*]])
; CHECK-NEXT:    ret i32 1
;
  %ret = tail call i32 @test2_1(i1 %c)
  ret i32 %ret
}

declare void @use(i32)
define void @test3(i1 %c) {
; CHECK-LABEL: define {{[^@]+}}@test3
; CHECK-SAME: (i1 [[C:%.*]])
; CHECK-NEXT:    br i1 [[C]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ 1, [[IF_TRUE]] ], [ 1, [[IF_FALSE]] ]
; CHECK-NEXT:    tail call void @use(i32 1)
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
; CHECK-SAME: (i1 [[C:%.*]])
; CHECK-NEXT:    tail call void @use(i32 1)
; CHECK-NEXT:    [[SELECT_NOT_SAME:%.*]] = select i1 [[C]], i32 1, i32 0
; CHECK-NEXT:    tail call void @use(i32 [[SELECT_NOT_SAME]])
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
; CHECK-NEXT:    tail call void @use(i32 1)
; CHECK-NEXT:    tail call void @use(i32 [[PHI_NOT_SAME]])
; CHECK-NEXT:    tail call void @use(i32 1)
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
; CHECK-LABEL: define {{[^@]+}}@ipccp1
; CHECK-SAME: (i32 returned [[A:%.*]])
; CHECK-NEXT:    br i1 true, label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i32 [[A]]
; CHECK:       f:
; CHECK-NEXT:    unreachable
;
  br i1 true, label %t, label %f
t:
  ret i32 %a
f:
  %r = call i32 @ipccp1(i32 5)
  ret i32 %r
}

define internal i1 @ipccp2i(i1 %a) {
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp2i()
; IS__CGSCC____-NEXT:    br label [[T:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i1 true
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
; IS__TUNIT____-LABEL: define {{[^@]+}}@ipccp2()
; IS__TUNIT____-NEXT:    ret i1 true
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp2()
; IS__CGSCC____-NEXT:    [[R:%.*]] = call i1 @ipccp2i()
; IS__CGSCC____-NEXT:    ret i1 [[R]]
;
  %r = call i1 @ipccp2i(i1 true)
  ret i1 %r
}

define internal i1 @ipccp2ib(i1 %a) {
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp2ib()
; IS__CGSCC____-NEXT:    br label [[T:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i1 true
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
; CHECK-LABEL: define {{[^@]+}}@ipccp2b()
; CHECK-NEXT:    ret i1 true
;
  %r = call i1 @ipccp2ib(i1 true)
  ret i1 %r
}

define internal i32 @ipccp3i(i32 %a) {
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp3i()
; IS__CGSCC____-NEXT:    br label [[T:%.*]]
; IS__CGSCC____:       t:
; IS__CGSCC____-NEXT:    ret i32 7
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
; IS__TUNIT____-LABEL: define {{[^@]+}}@ipccp3()
; IS__TUNIT____-NEXT:    ret i32 7
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@ipccp3()
; IS__CGSCC____-NEXT:    [[R:%.*]] = call i32 @ipccp3i()
; IS__CGSCC____-NEXT:    ret i32 [[R]]
;
  %r = call i32 @ipccp3i(i32 7)
  ret i32 %r
}

; Do not touch complicated arguments (for now)
%struct.X = type { i8* }
define internal i32* @test_inalloca(i32* inalloca %a) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@test_inalloca
; IS__TUNIT____-SAME: (i32* inalloca noalias nofree returned writeonly align 536870912 "no-capture-maybe-returned" [[A:%.*]])
; IS__TUNIT____-NEXT:    ret i32* [[A]]
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_inalloca
; IS__CGSCC____-SAME: (i32* inalloca noalias nofree returned writeonly "no-capture-maybe-returned" [[A:%.*]])
; IS__CGSCC____-NEXT:    ret i32* [[A]]
;
  ret i32* %a
}
define i32* @complicated_args_inalloca() {
; CHECK-LABEL: define {{[^@]+}}@complicated_args_inalloca()
; CHECK-NEXT:    [[CALL:%.*]] = call i32* @test_inalloca(i32* noalias nocapture nofree writeonly align 536870912 null)
; CHECK-NEXT:    ret i32* [[CALL]]
;
  %call = call i32* @test_inalloca(i32* null)
  ret i32* %call
}

define internal void @test_sret(%struct.X* sret %a, %struct.X** %b) {
;
; IS__TUNIT____-LABEL: define {{[^@]+}}@test_sret
; IS__TUNIT____-SAME: (%struct.X* noalias nofree sret writeonly align 536870912 [[A:%.*]], %struct.X** nocapture nofree nonnull writeonly align 8 dereferenceable(8) [[B:%.*]])
; IS__TUNIT____-NEXT:    store %struct.X* [[A]], %struct.X** [[B]], align 8
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_sret
; IS__CGSCC____-SAME: (%struct.X* noalias nofree sret writeonly [[A:%.*]], %struct.X** nocapture nofree nonnull writeonly align 8 dereferenceable(8) [[B:%.*]])
; IS__CGSCC____-NEXT:    store %struct.X* [[A]], %struct.X** [[B]], align 8
; IS__CGSCC____-NEXT:    ret void
;
  store %struct.X* %a, %struct.X** %b
  ret void
}
; FIXME: Alignment and dereferenceability are not propagated to the argument
define void @complicated_args_sret(%struct.X** %b) {
;
; IS__TUNIT____-LABEL: define {{[^@]+}}@complicated_args_sret
; IS__TUNIT____-SAME: (%struct.X** nocapture nofree writeonly [[B:%.*]])
; IS__TUNIT____-NEXT:    call void @test_sret(%struct.X* noalias nocapture nofree writeonly align 536870912 null, %struct.X** nocapture nofree writeonly align 8 [[B]])
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@complicated_args_sret
; IS__CGSCC____-SAME: (%struct.X** nocapture nofree nonnull writeonly align 8 dereferenceable(8) [[B:%.*]])
; IS__CGSCC____-NEXT:    call void @test_sret(%struct.X* noalias nocapture nofree writeonly align 536870912 null, %struct.X** nocapture nofree nonnull writeonly align 8 dereferenceable(8) [[B]])
; IS__CGSCC____-NEXT:    ret void
;
  call void @test_sret(%struct.X* null, %struct.X** %b)
  ret void
}

define internal %struct.X* @test_nest(%struct.X* nest %a) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@test_nest
; IS__TUNIT____-SAME: (%struct.X* nest noalias nofree readnone returned align 536870912 "no-capture-maybe-returned" [[A:%.*]])
; IS__TUNIT____-NEXT:    ret %struct.X* [[A]]
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@test_nest
; IS__CGSCC____-SAME: (%struct.X* nest noalias nofree readnone returned "no-capture-maybe-returned" [[A:%.*]])
; IS__CGSCC____-NEXT:    ret %struct.X* [[A]]
;
  ret %struct.X* %a
}
define %struct.X* @complicated_args_nest() {
; CHECK-LABEL: define {{[^@]+}}@complicated_args_nest()
; CHECK-NEXT:    [[CALL:%.*]] = call %struct.X* @test_nest(%struct.X* noalias nocapture nofree readnone align 536870912 null)
; CHECK-NEXT:    ret %struct.X* [[CALL]]
;
  %call = call %struct.X* @test_nest(%struct.X* null)
  ret %struct.X* %call
}

@S = external global %struct.X
define internal void @test_byval(%struct.X* byval %a) {
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@test_byval
; IS__CGSCC_OPM-SAME: (%struct.X* noalias nocapture nofree nonnull writeonly byval align 8 dereferenceable(8) [[A:%.*]])
; IS__CGSCC_OPM-NEXT:    [[G0:%.*]] = getelementptr [[STRUCT_X:%.*]], %struct.X* [[A]], i32 0, i32 0
; IS__CGSCC_OPM-NEXT:    store i8* null, i8** [[G0]], align 8
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@test_byval
; IS__CGSCC_NPM-SAME: (i8* nocapture nofree readnone [[TMP0:%.*]])
; IS__CGSCC_NPM-NEXT:    [[A_PRIV:%.*]] = alloca [[STRUCT_X:%.*]]
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
; CHECK-LABEL: define {{[^@]+}}@complicated_args_byval()
; CHECK-NEXT:    ret void
;
  call void @test_byval(%struct.X* @S)
  ret void
}

define internal i8*@test_byval2(%struct.X* byval %a) {
; CHECK-LABEL: define {{[^@]+}}@test_byval2()
; CHECK-NEXT:    [[G0:%.*]] = getelementptr [[STRUCT_X:%.*]], %struct.X* @S, i32 0, i32 0
; CHECK-NEXT:    [[L:%.*]] = load i8*, i8** [[G0]], align 8
; CHECK-NEXT:    ret i8* [[L]]
;
  %g0 = getelementptr %struct.X, %struct.X* %a, i32 0, i32 0
  %l = load i8*, i8** %g0
  ret i8* %l
}
define i8* @complicated_args_byval2() {
; CHECK-LABEL: define {{[^@]+}}@complicated_args_byval2()
; CHECK-NEXT:    [[C:%.*]] = call i8* @test_byval2()
; CHECK-NEXT:    ret i8* [[C]]
;
  %c = call i8* @test_byval2(%struct.X* @S)
  ret i8* %c
}

define void @fixpoint_changed(i32* %p) {
; CHECK-LABEL: define {{[^@]+}}@fixpoint_changed
; CHECK-SAME: (i32* nocapture nofree writeonly [[P:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[J_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[SW_EPILOG:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[J_0]], 30
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    switch i32 [[J_0]], label [[SW_EPILOG]] [
; CHECK-NEXT:    i32 1, label [[SW_BB:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    br label [[SW_EPILOG]]
; CHECK:       sw.epilog:
; CHECK-NEXT:    [[X_0:%.*]] = phi i32 [ 255, [[FOR_BODY]] ], [ 253, [[SW_BB]] ]
; CHECK-NEXT:    store i32 [[X_0]], i32* [[P]]
; CHECK-NEXT:    [[INC]] = add nsw i32 [[J_0]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
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
; FIXME fold the addition and return the constant.
define i8 @caller0() {
; CHECK-LABEL: define {{[^@]+}}@caller0()
; CHECK-NEXT:    [[C:%.*]] = call i8 @callee()
; CHECK-NEXT:    ret i8 [[C]]
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define i8 @caller1() {
; CHECK-LABEL: define {{[^@]+}}@caller1()
; CHECK-NEXT:    [[C:%.*]] = call i8 @callee()
; CHECK-NEXT:    ret i8 [[C]]
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define i8 @caller2() {
; CHECK-LABEL: define {{[^@]+}}@caller2()
; CHECK-NEXT:    [[C:%.*]] = call i8 @callee()
; CHECK-NEXT:    ret i8 [[C]]
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define i8 @caller_middle() {
; CHECK-LABEL: define {{[^@]+}}@caller_middle()
; CHECK-NEXT:    [[C:%.*]] = call i8 @callee()
; CHECK-NEXT:    ret i8 [[C]]
;
  %c = call i8 @callee(i8 42)
  ret i8 %c
}
define i8 @caller3() {
; CHECK-LABEL: define {{[^@]+}}@caller3()
; CHECK-NEXT:    [[C:%.*]] = call i8 @callee()
; CHECK-NEXT:    ret i8 [[C]]
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define i8 @caller4() {
; CHECK-LABEL: define {{[^@]+}}@caller4()
; CHECK-NEXT:    [[C:%.*]] = call i8 @callee()
; CHECK-NEXT:    ret i8 [[C]]
;
  %c = call i8 @callee(i8 undef)
  ret i8 %c
}
define internal i8 @callee(i8 %a) {
; CHECK-LABEL: define {{[^@]+}}@callee()
; CHECK-NEXT:    [[C:%.*]] = add i8 42, 7
; CHECK-NEXT:    ret i8 [[C]]
;
  %c = add i8 %a, 7
  ret i8 %c
}

