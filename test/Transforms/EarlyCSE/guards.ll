; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -early-cse -earlycse-debug-hash < %s | FileCheck %s --check-prefixes=CHECK,NO_ASSUME
; RUN: opt < %s -S -basic-aa -early-cse-memssa | FileCheck %s --check-prefixes=CHECK,NO_ASSUME
; RUN: opt < %s -S -basic-aa -early-cse-memssa --enable-knowledge-retention | FileCheck %s --check-prefixes=CHECK,USE_ASSUME

declare void @llvm.experimental.guard(i1,...)

declare void @llvm.assume(i1)

define i32 @test0(ptr %ptr, i1 %cond) {
; We can do store to load forwarding over a guard, since it does not
; clobber memory
; NO_ASSUME-LABEL: @test0(
; NO_ASSUME-NEXT:    store i32 40, ptr [[PTR:%.*]], align 4
; NO_ASSUME-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND:%.*]]) [ "deopt"() ]
; NO_ASSUME-NEXT:    ret i32 40
;
; USE_ASSUME-LABEL: @test0(
; USE_ASSUME-NEXT:    store i32 40, ptr [[PTR:%.*]], align 4
; USE_ASSUME-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND:%.*]]) [ "deopt"() ]
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(ptr [[PTR]], i64 4), "nonnull"(ptr [[PTR]]), "align"(ptr [[PTR]], i64 4) ]
; USE_ASSUME-NEXT:    ret i32 40
;

  store i32 40, ptr %ptr
  call void(i1,...) @llvm.experimental.guard(i1 %cond) [ "deopt"() ]
  %rval = load i32, ptr %ptr
  ret i32 %rval
}

define i32 @test1(ptr %val, i1 %cond) {
; We can CSE loads over a guard, since it does not clobber memory
; NO_ASSUME-LABEL: @test1(
; NO_ASSUME-NEXT:    [[VAL0:%.*]] = load i32, ptr [[VAL:%.*]], align 4
; NO_ASSUME-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND:%.*]]) [ "deopt"() ]
; NO_ASSUME-NEXT:    ret i32 0
;
; USE_ASSUME-LABEL: @test1(
; USE_ASSUME-NEXT:    [[VAL0:%.*]] = load i32, ptr [[VAL:%.*]], align 4
; USE_ASSUME-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND:%.*]]) [ "deopt"() ]
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(ptr [[VAL]], i64 4), "nonnull"(ptr [[VAL]]), "align"(ptr [[VAL]], i64 4) ]
; USE_ASSUME-NEXT:    ret i32 0
;

  %val0 = load i32, ptr %val
  call void(i1,...) @llvm.experimental.guard(i1 %cond) [ "deopt"() ]
  %val1 = load i32, ptr %val
  %rval = sub i32 %val0, %val1
  ret i32 %rval
}

define i32 @test2() {
; Guards on "true" get removed
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i32 0
;
  call void(i1, ...) @llvm.experimental.guard(i1 true) [ "deopt"() ]
  ret i32 0
}

define i32 @test3(i32 %val) {
; After a guard has executed the condition it was guarding is known to
; be true.
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[COND0:%.*]] = icmp slt i32 [[VAL:%.*]], 40
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND0]]) [ "deopt"() ]
; CHECK-NEXT:    ret i32 -1
;

  %cond0 = icmp slt i32 %val, 40
  call void(i1,...) @llvm.experimental.guard(i1 %cond0) [ "deopt"() ]
  %cond1 = icmp slt i32 %val, 40
  call void(i1,...) @llvm.experimental.guard(i1 %cond1) [ "deopt"() ]

  %cond2 = icmp slt i32 %val, 40
  %rval = sext i1 %cond2 to i32
  ret i32 %rval
}

define i32 @test3.unhandled(i32 %val) {
; After a guard has executed the condition it was guarding is known to
; be true.
; CHECK-LABEL: @test3.unhandled(
; CHECK-NEXT:    [[COND0:%.*]] = icmp slt i32 [[VAL:%.*]], 40
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND0]]) [ "deopt"() ]
; CHECK-NEXT:    [[COND1:%.*]] = icmp sge i32 [[VAL]], 40
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND1]]) [ "deopt"() ]
; CHECK-NEXT:    ret i32 0
;

; Demonstrates a case we do not yet handle (it is legal to fold %cond2
; to false)
  %cond0 = icmp slt i32 %val, 40
  call void(i1,...) @llvm.experimental.guard(i1 %cond0) [ "deopt"() ]
  %cond1 = icmp sge i32 %val, 40
  call void(i1,...) @llvm.experimental.guard(i1 %cond1) [ "deopt"() ]
  ret i32 0
}

define i32 @test4(i32 %val, i1 %c) {
; Same as test3, but with some control flow involved.
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND0:%.*]] = icmp slt i32 [[VAL:%.*]], 40
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND0]]) [ "deopt"() ]
; CHECK-NEXT:    br label [[BB0:%.*]]
; CHECK:       bb0:
; CHECK-NEXT:    [[COND2:%.*]] = icmp ult i32 [[VAL]], 200
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND2]]) [ "deopt"() ]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       left:
; CHECK-NEXT:    ret i32 0
; CHECK:       right:
; CHECK-NEXT:    ret i32 20
;




entry:
  %cond0 = icmp slt i32 %val, 40
  call void(i1,...) @llvm.experimental.guard(i1 %cond0) [ "deopt"() ]
  %cond1 = icmp slt i32 %val, 40
  call void(i1,...) @llvm.experimental.guard(i1 %cond1) [ "deopt"() ]
  br label %bb0

bb0:
  %cond2 = icmp ult i32 %val, 200
  call void(i1,...) @llvm.experimental.guard(i1 %cond2) [ "deopt"() ]
  br i1 %c, label %left, label %right

left:
  %cond3 = icmp ult i32 %val, 200
  call void(i1,...) @llvm.experimental.guard(i1 %cond3) [ "deopt"() ]
  ret i32 0

right:
  ret i32 20
}

define i32 @test5(i32 %val, i1 %c) {
; Same as test4, but the %left block has mutliple predecessors.
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[COND0:%.*]] = icmp slt i32 [[VAL:%.*]], 40
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND0]]) [ "deopt"() ]
; CHECK-NEXT:    br label [[BB0:%.*]]
; CHECK:       bb0:
; CHECK-NEXT:    [[COND2:%.*]] = icmp ult i32 [[VAL]], 200
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[COND2]]) [ "deopt"() ]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[LEFT:%.*]], label [[RIGHT:%.*]]
; CHECK:       left:
; CHECK-NEXT:    br label [[RIGHT]]
; CHECK:       right:
; CHECK-NEXT:    br label [[LEFT]]
;





entry:
  %cond0 = icmp slt i32 %val, 40
  call void(i1,...) @llvm.experimental.guard(i1 %cond0) [ "deopt"() ]
  %cond1 = icmp slt i32 %val, 40
  call void(i1,...) @llvm.experimental.guard(i1 %cond1) [ "deopt"() ]
  br label %bb0

bb0:
  %cond2 = icmp ult i32 %val, 200
  call void(i1,...) @llvm.experimental.guard(i1 %cond2) [ "deopt"() ]
  br i1 %c, label %left, label %right

left:
  %cond3 = icmp ult i32 %val, 200
  call void(i1,...) @llvm.experimental.guard(i1 %cond3) [ "deopt"() ]
  br label %right

right:
  br label %left
}

define void @test6(i1 %c, ptr %ptr) {
; Check that we do not DSE over calls to @llvm.experimental.guard.
; Guard intrinsics do _read_ memory, so th call to guard below needs
; to see the store of 500 to %ptr
; CHECK-LABEL: @test6(
; CHECK-NEXT:    store i32 500, ptr [[PTR:%.*]], align 4
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[C:%.*]]) [ "deopt"() ]
; CHECK-NEXT:    store i32 600, ptr [[PTR]], align 4
; CHECK-NEXT:    ret void
;


  store i32 500, ptr %ptr
  call void(i1,...) @llvm.experimental.guard(i1 %c) [ "deopt"() ]
  store i32 600, ptr %ptr
  ret void
}

define void @test07(i32 %a, i32 %b) {
; Check that we are able to remove the guards on the same condition even if the
; condition is not being recalculated.
; CHECK-LABEL: @test07(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) [ "deopt"() ]
; CHECK-NEXT:    ret void
;

  %cmp = icmp eq i32 %a, %b
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  ret void
}

define void @test08(i32 %a, i32 %b, ptr %ptr) {
; Check that we deal correctly with stores when removing guards in the same
; block in case when the condition is not recalculated.
; NO_ASSUME-LABEL: @test08(
; NO_ASSUME-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; NO_ASSUME-NEXT:    store i32 100, ptr [[PTR:%.*]], align 4
; NO_ASSUME-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) [ "deopt"() ]
; NO_ASSUME-NEXT:    store i32 400, ptr [[PTR]], align 4
; NO_ASSUME-NEXT:    ret void
;
; USE_ASSUME-LABEL: @test08(
; USE_ASSUME-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; USE_ASSUME-NEXT:    store i32 100, ptr [[PTR:%.*]], align 4
; USE_ASSUME-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) [ "deopt"() ]
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(ptr [[PTR]], i64 4), "nonnull"(ptr [[PTR]]), "align"(ptr [[PTR]], i64 4) ]
; USE_ASSUME-NEXT:    store i32 400, ptr [[PTR]], align 4
; USE_ASSUME-NEXT:    ret void
;

  %cmp = icmp eq i32 %a, %b
  store i32 100, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 200, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 300, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 400, ptr %ptr
  ret void
}

define void @test09(i32 %a, i32 %b, i1 %c, ptr %ptr) {
; Similar to test08, but with more control flow.
; TODO: Can we get rid of the store in the end of entry given that it is
; post-dominated by other stores?
; NO_ASSUME-LABEL: @test09(
; NO_ASSUME-NEXT:  entry:
; NO_ASSUME-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; NO_ASSUME-NEXT:    store i32 100, ptr [[PTR:%.*]], align 4
; NO_ASSUME-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) [ "deopt"() ]
; NO_ASSUME-NEXT:    store i32 400, ptr [[PTR]], align 4
; NO_ASSUME-NEXT:    br i1 [[C:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; NO_ASSUME:       if.true:
; NO_ASSUME-NEXT:    store i32 500, ptr [[PTR]], align 4
; NO_ASSUME-NEXT:    br label [[MERGE:%.*]]
; NO_ASSUME:       if.false:
; NO_ASSUME-NEXT:    store i32 600, ptr [[PTR]], align 4
; NO_ASSUME-NEXT:    br label [[MERGE]]
; NO_ASSUME:       merge:
; NO_ASSUME-NEXT:    ret void
;
; USE_ASSUME-LABEL: @test09(
; USE_ASSUME-NEXT:  entry:
; USE_ASSUME-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; USE_ASSUME-NEXT:    store i32 100, ptr [[PTR:%.*]], align 4
; USE_ASSUME-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) [ "deopt"() ]
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(ptr [[PTR]], i64 4), "nonnull"(ptr [[PTR]]), "align"(ptr [[PTR]], i64 4) ]
; USE_ASSUME-NEXT:    store i32 400, ptr [[PTR]], align 4
; USE_ASSUME-NEXT:    br i1 [[C:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; USE_ASSUME:       if.true:
; USE_ASSUME-NEXT:    store i32 500, ptr [[PTR]], align 4
; USE_ASSUME-NEXT:    br label [[MERGE:%.*]]
; USE_ASSUME:       if.false:
; USE_ASSUME-NEXT:    store i32 600, ptr [[PTR]], align 4
; USE_ASSUME-NEXT:    br label [[MERGE]]
; USE_ASSUME:       merge:
; USE_ASSUME-NEXT:    ret void
;

entry:
  %cmp = icmp eq i32 %a, %b
  store i32 100, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 200, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 300, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 400, ptr %ptr
  br i1 %c, label %if.true, label %if.false

if.true:
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 500, ptr %ptr
  br label %merge

if.false:
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 600, ptr %ptr
  br label %merge

merge:
  ret void
}

define void @test10(i32 %a, i32 %b, i1 %c, ptr %ptr) {
; Make sure that non-dominating guards do not cause other guards removal.
; CHECK-LABEL: @test10(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) [ "deopt"() ]
; CHECK-NEXT:    store i32 100, ptr [[PTR:%.*]], align 4
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    store i32 200, ptr [[PTR]], align 4
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    store i32 300, ptr [[PTR]], align 4
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) [ "deopt"() ]
; CHECK-NEXT:    store i32 400, ptr [[PTR]], align 4
; CHECK-NEXT:    ret void
;

entry:
  %cmp = icmp eq i32 %a, %b
  br i1 %c, label %if.true, label %if.false

if.true:
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 100, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  br label %merge

if.false:
  store i32 200, ptr %ptr
  br label %merge

merge:
  store i32 300, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 400, ptr %ptr
  ret void
}

define void @test11(i32 %a, i32 %b, ptr %ptr) {
; Make sure that branching condition is applied to guards.
; CHECK-LABEL: @test11(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[CMP]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 false) [ "deopt"() ]
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    ret void
;

entry:
  %cmp = icmp eq i32 %a, %b
  br i1 %cmp, label %if.true, label %if.false

if.true:
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  br label %merge

if.false:
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  br label %merge

merge:
  ret void
}

define void @test12(i32 %a, i32 %b) {
; Check that the assume marks its condition as being true (and thus allows to
; eliminate the dominated guards).
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    ret void
;

  %cmp = icmp eq i32 %a, %b
  call void @llvm.assume(i1 %cmp)
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  ret void
}

define void @test13(i32 %a, i32 %b, ptr %ptr) {
; Check that we deal correctly with stores when removing guards due to assume.
; NO_ASSUME-LABEL: @test13(
; NO_ASSUME-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; NO_ASSUME-NEXT:    call void @llvm.assume(i1 [[CMP]])
; NO_ASSUME-NEXT:    store i32 400, ptr [[PTR:%.*]], align 4
; NO_ASSUME-NEXT:    ret void
;
; USE_ASSUME-LABEL: @test13(
; USE_ASSUME-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 [[CMP]])
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(ptr [[PTR:%.*]], i64 4), "nonnull"(ptr [[PTR]]), "align"(ptr [[PTR]], i64 4) ]
; USE_ASSUME-NEXT:    store i32 400, ptr [[PTR]], align 4
; USE_ASSUME-NEXT:    ret void
;

  %cmp = icmp eq i32 %a, %b
  call void @llvm.assume(i1 %cmp)
  store i32 100, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 200, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 300, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 400, ptr %ptr
  ret void
}

define void @test14(i32 %a, i32 %b, i1 %c, ptr %ptr) {
; Similar to test13, but with more control flow.
; TODO: Can we get rid of the store in the end of entry given that it is
; post-dominated by other stores?
; NO_ASSUME-LABEL: @test14(
; NO_ASSUME-NEXT:  entry:
; NO_ASSUME-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; NO_ASSUME-NEXT:    call void @llvm.assume(i1 [[CMP]])
; NO_ASSUME-NEXT:    store i32 400, ptr [[PTR:%.*]], align 4
; NO_ASSUME-NEXT:    br i1 [[C:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; NO_ASSUME:       if.true:
; NO_ASSUME-NEXT:    store i32 500, ptr [[PTR]], align 4
; NO_ASSUME-NEXT:    br label [[MERGE:%.*]]
; NO_ASSUME:       if.false:
; NO_ASSUME-NEXT:    store i32 600, ptr [[PTR]], align 4
; NO_ASSUME-NEXT:    br label [[MERGE]]
; NO_ASSUME:       merge:
; NO_ASSUME-NEXT:    ret void
;
; USE_ASSUME-LABEL: @test14(
; USE_ASSUME-NEXT:  entry:
; USE_ASSUME-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 [[CMP]])
; USE_ASSUME-NEXT:    call void @llvm.assume(i1 true) [ "dereferenceable"(ptr [[PTR:%.*]], i64 4), "nonnull"(ptr [[PTR]]), "align"(ptr [[PTR]], i64 4) ]
; USE_ASSUME-NEXT:    store i32 400, ptr [[PTR]], align 4
; USE_ASSUME-NEXT:    br i1 [[C:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; USE_ASSUME:       if.true:
; USE_ASSUME-NEXT:    store i32 500, ptr [[PTR]], align 4
; USE_ASSUME-NEXT:    br label [[MERGE:%.*]]
; USE_ASSUME:       if.false:
; USE_ASSUME-NEXT:    store i32 600, ptr [[PTR]], align 4
; USE_ASSUME-NEXT:    br label [[MERGE]]
; USE_ASSUME:       merge:
; USE_ASSUME-NEXT:    ret void
;

entry:
  %cmp = icmp eq i32 %a, %b
  call void @llvm.assume(i1 %cmp)
  store i32 100, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 200, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 300, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 400, ptr %ptr
  br i1 %c, label %if.true, label %if.false

if.true:
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 500, ptr %ptr
  br label %merge

if.false:
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 600, ptr %ptr
  br label %merge

merge:
  ret void
}

define void @test15(i32 %a, i32 %b, i1 %c, ptr %ptr) {
; Make sure that non-dominating assumes do not cause guards removal.
; CHECK-LABEL: @test15(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    store i32 100, ptr [[PTR:%.*]], align 4
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    store i32 200, ptr [[PTR]], align 4
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    store i32 300, ptr [[PTR]], align 4
; CHECK-NEXT:    call void (i1, ...) @llvm.experimental.guard(i1 [[CMP]]) [ "deopt"() ]
; CHECK-NEXT:    store i32 400, ptr [[PTR]], align 4
; CHECK-NEXT:    ret void
;

entry:
  %cmp = icmp eq i32 %a, %b
  br i1 %c, label %if.true, label %if.false

if.true:
  call void @llvm.assume(i1 %cmp)
  store i32 100, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  br label %merge

if.false:
  store i32 200, ptr %ptr
  br label %merge

merge:
  store i32 300, ptr %ptr
  call void (i1, ...) @llvm.experimental.guard(i1 %cmp) [ "deopt"() ]
  store i32 400, ptr %ptr
  ret void
}

define void @test16(i32 %a, i32 %b) {
; Check that we don't bother to do anything with assumes even if we know the
; condition being true.
; CHECK-LABEL: @test16(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    ret void
;

  %cmp = icmp eq i32 %a, %b
  call void @llvm.assume(i1 %cmp)
  call void @llvm.assume(i1 %cmp)
  ret void
}

define void @test17(i32 %a, i32 %b, i1 %c, ptr %ptr) {
; Check that we don't bother to do anything with assumes even if we know the
; condition being true or false (includes come control flow).
; CHECK-LABEL: @test17(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF_TRUE:%.*]], label [[IF_FALSE:%.*]]
; CHECK:       if.true:
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       if.false:
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    ret void
;

entry:
  %cmp = icmp eq i32 %a, %b
  br i1 %c, label %if.true, label %if.false

if.true:
  call void @llvm.assume(i1 %cmp)
  br label %merge

if.false:
  call void @llvm.assume(i1 %cmp)
  br label %merge

merge:
  ret void
}

define void @test18(i1 %c) {
; Check that we don't bother to do anything with assumes even if we know the
; condition being true and not being an instruction.
; CHECK-LABEL: @test18(
; CHECK-NEXT:    call void @llvm.assume(i1 [[C:%.*]])
; CHECK-NEXT:    call void @llvm.assume(i1 [[C]])
; CHECK-NEXT:    ret void
;

  call void @llvm.assume(i1 %c)
  call void @llvm.assume(i1 %c)
  ret void
}
