; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

; Test cases specifically designed for the "undefined behavior" abstract function attribute.
; We want to verify that whenever undefined behavior is assumed, the code becomes unreachable.
; We use FIXME's to indicate problems and missing attributes.

; -- Load tests --

define void @load_wholly_unreachable() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@load_wholly_unreachable
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    unreachable
;
  %a = load i32, i32* null
  ret void
}

define void @loads_wholly_unreachable() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@loads_wholly_unreachable
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  %a = load i32, i32* null
  %b = load i32, i32* null
  ret void
}


define void @load_single_bb_unreachable(i1 %cond) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@load_single_bb_unreachable
; CHECK-SAME: (i1 [[COND:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    ret void
;
  br i1 %cond, label %t, label %e
t:
  %b = load i32, i32* null
  br label %e
e:
  ret void
}

; Note that while the load is removed (because it's unused), the block
; is not changed to unreachable
define void @load_null_pointer_is_defined() null_pointer_is_valid {
; CHECK: Function Attrs: nofree norecurse nosync nounwind null_pointer_is_valid readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@load_null_pointer_is_defined
; CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    ret void
;
  %a = load i32, i32* null
  ret void
}

define internal i32* @ret_null() {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@ret_null
; IS__CGSCC____-SAME: () #[[ATTR0]] {
; IS__CGSCC____-NEXT:    ret i32* undef
;
  ret i32* null
}

define void @load_null_propagated() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@load_null_propagated
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  %ptr = call i32* @ret_null()
  %a = load i32, i32* %ptr
  ret void
}

; -- Store tests --

define void @store_wholly_unreachable() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@store_wholly_unreachable
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  store i32 5, i32* null
  ret void
}

define void @store_wholly_unreachable_volatile() {
; CHECK: Function Attrs: nofree norecurse nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@store_wholly_unreachable_volatile
; CHECK-SAME: () #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:    store volatile i32 5, i32* null, align 4294967296
; CHECK-NEXT:    ret void
;
  store volatile i32 5, i32* null
  ret void
}

define void @store_single_bb_unreachable(i1 %cond) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@store_single_bb_unreachable
; CHECK-SAME: (i1 [[COND:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    ret void
;
  br i1 %cond, label %t, label %e
t:
  store i32 5, i32* null
  br label %e
e:
  ret void
}

define void @store_null_pointer_is_defined() null_pointer_is_valid {
; CHECK: Function Attrs: nofree norecurse nosync nounwind null_pointer_is_valid willreturn writeonly
; CHECK-LABEL: define {{[^@]+}}@store_null_pointer_is_defined
; CHECK-SAME: () #[[ATTR3:[0-9]+]] {
; CHECK-NEXT:    store i32 5, i32* null, align 4294967296
; CHECK-NEXT:    ret void
;
  store i32 5, i32* null
  ret void
}

define void @store_null_propagated() {
; ATTRIBUTOR-LABEL: @store_null_propagated(
; ATTRIBUTOR-NEXT:    unreachable
;
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@store_null_propagated
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  %ptr = call i32* @ret_null()
  store i32 5, i32* %ptr
  ret void
}

; -- AtomicRMW tests --

define void @atomicrmw_wholly_unreachable() {
; CHECK: Function Attrs: nofree norecurse nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@atomicrmw_wholly_unreachable
; CHECK-SAME: () #[[ATTR2]] {
; CHECK-NEXT:    unreachable
;
  %a = atomicrmw add i32* null, i32 1 acquire
  ret void
}

define void @atomicrmw_single_bb_unreachable(i1 %cond) {
; CHECK: Function Attrs: nofree norecurse nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@atomicrmw_single_bb_unreachable
; CHECK-SAME: (i1 [[COND:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    ret void
;
  br i1 %cond, label %t, label %e
t:
  %a = atomicrmw add i32* null, i32 1 acquire
  br label %e
e:
  ret void
}

define void @atomicrmw_null_pointer_is_defined() null_pointer_is_valid {
; CHECK: Function Attrs: nofree norecurse nounwind null_pointer_is_valid willreturn
; CHECK-LABEL: define {{[^@]+}}@atomicrmw_null_pointer_is_defined
; CHECK-SAME: () #[[ATTR4:[0-9]+]] {
; CHECK-NEXT:    [[A:%.*]] = atomicrmw add i32* null, i32 1 acquire, align 4
; CHECK-NEXT:    ret void
;
  %a = atomicrmw add i32* null, i32 1 acquire
  ret void
}

define void @atomicrmw_null_propagated() {
; ATTRIBUTOR-LABEL: @atomicrmw_null_propagated(
; ATTRIBUTOR-NEXT:    unreachable
;
; CHECK: Function Attrs: nofree norecurse nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@atomicrmw_null_propagated
; CHECK-SAME: () #[[ATTR2]] {
; CHECK-NEXT:    unreachable
;
  %ptr = call i32* @ret_null()
  %a = atomicrmw add i32* %ptr, i32 1 acquire
  ret void
}

; -- AtomicCmpXchg tests --

define void @atomiccmpxchg_wholly_unreachable() {
; CHECK: Function Attrs: nofree norecurse nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@atomiccmpxchg_wholly_unreachable
; CHECK-SAME: () #[[ATTR2]] {
; CHECK-NEXT:    unreachable
;
  %a = cmpxchg i32* null, i32 2, i32 3 acq_rel monotonic
  ret void
}

define void @atomiccmpxchg_single_bb_unreachable(i1 %cond) {
; CHECK: Function Attrs: nofree norecurse nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@atomiccmpxchg_single_bb_unreachable
; CHECK-SAME: (i1 [[COND:%.*]]) #[[ATTR2]] {
; CHECK-NEXT:    br i1 [[COND]], label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    ret void
;
  br i1 %cond, label %t, label %e
t:
  %a = cmpxchg i32* null, i32 2, i32 3 acq_rel monotonic
  br label %e
e:
  ret void
}

define void @atomiccmpxchg_null_pointer_is_defined() null_pointer_is_valid {
; CHECK: Function Attrs: nofree norecurse nounwind null_pointer_is_valid willreturn
; CHECK-LABEL: define {{[^@]+}}@atomiccmpxchg_null_pointer_is_defined
; CHECK-SAME: () #[[ATTR4]] {
; CHECK-NEXT:    [[A:%.*]] = cmpxchg i32* null, i32 2, i32 3 acq_rel monotonic, align 4
; CHECK-NEXT:    ret void
;
  %a = cmpxchg i32* null, i32 2, i32 3 acq_rel monotonic
  ret void
}

define void @atomiccmpxchg_null_propagated() {
; ATTRIBUTOR-LABEL: @atomiccmpxchg_null_propagated(
; ATTRIBUTOR-NEXT:    unreachable
;
; CHECK: Function Attrs: nofree norecurse nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@atomiccmpxchg_null_propagated
; CHECK-SAME: () #[[ATTR2]] {
; CHECK-NEXT:    unreachable
;
  %ptr = call i32* @ret_null()
  %a = cmpxchg i32* %ptr, i32 2, i32 3 acq_rel monotonic
  ret void
}

; -- Conditional branching tests --

; Note: The unreachable on %t and %e is _not_ from AAUndefinedBehavior

define i32 @cond_br_on_undef() {
; CHECK: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@cond_br_on_undef
; CHECK-SAME: () #[[ATTR5:[0-9]+]] {
; CHECK-NEXT:    unreachable
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    unreachable
;
  br i1 undef, label %t, label %e
t:
  ret i32 1
e:
  ret i32 2
}

; More complicated branching
  ; Valid branch - verify that this is not converted
  ; to unreachable.
define void @cond_br_on_undef2(i1 %cond) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@cond_br_on_undef2
; CHECK-SAME: (i1 [[COND:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    br i1 [[COND]], label [[T1:%.*]], label [[E1:%.*]]
; CHECK:       t1:
; CHECK-NEXT:    unreachable
; CHECK:       t2:
; CHECK-NEXT:    unreachable
; CHECK:       e2:
; CHECK-NEXT:    unreachable
; CHECK:       e1:
; CHECK-NEXT:    ret void
;
  br i1 %cond, label %t1, label %e1
t1:
  br i1 undef, label %t2, label %e2
t2:
  ret void
e2:
  ret void
e1:
  ret void
}

define i1 @ret_undef() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@ret_undef
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret i1 undef
;
  ret i1 undef
}

define void @cond_br_on_undef_interproc() {
; CHECK: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@cond_br_on_undef_interproc
; CHECK-SAME: () #[[ATTR5]] {
; CHECK-NEXT:    unreachable
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    unreachable
;
  %cond = call i1 @ret_undef()
  br i1 %cond, label %t, label %e
t:
  ret void
e:
  ret void
}

define i1 @ret_undef2() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@ret_undef2
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    br i1 true, label [[T:%.*]], label [[E:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i1 undef
; CHECK:       e:
; CHECK-NEXT:    unreachable
;
  br i1 true, label %t, label %e
t:
  ret i1 undef
e:
  ret i1 undef
}

; More complicated interproc deduction of undef
define void @cond_br_on_undef_interproc2() {
; CHECK: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@cond_br_on_undef_interproc2
; CHECK-SAME: () #[[ATTR5]] {
; CHECK-NEXT:    unreachable
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    unreachable
;
  %cond = call i1 @ret_undef2()
  br i1 %cond, label %t, label %e
t:
  ret void
e:
  ret void
}

; Branch on undef that depends on propagation of
; undef of a previous instruction.
define i32 @cond_br_on_undef3() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@cond_br_on_undef3
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    br label [[T:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i32 1
; CHECK:       e:
; CHECK-NEXT:    unreachable
;
  %cond = icmp ne i32 1, undef
  br i1 %cond, label %t, label %e
t:
  ret i32 1
e:
  ret i32 2
}

; Branch on undef because of uninitialized value.
; FIXME: Currently it doesn't propagate the undef.
define i32 @cond_br_on_undef_uninit() {
; CHECK: Function Attrs: nofree norecurse noreturn nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@cond_br_on_undef_uninit
; CHECK-SAME: () #[[ATTR5]] {
; CHECK-NEXT:    unreachable
; CHECK:       t:
; CHECK-NEXT:    unreachable
; CHECK:       e:
; CHECK-NEXT:    unreachable
;
  %alloc = alloca i1
  %cond = load i1, i1* %alloc
  br i1 %cond, label %t, label %e
t:
  ret i32 1
e:
  ret i32 2
}

; Note that the `load` has UB (so it will be changed to unreachable)
; and the branch is a terminator that can be constant-folded.
; We want to test that doing both won't cause a segfault.
; MODULE-NOT: @callee(
define internal i32 @callee(i1 %C, i32* %A) {
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@callee
; IS__CGSCC____-SAME: () #[[ATTR0]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    unreachable
; IS__CGSCC____:       T:
; IS__CGSCC____-NEXT:    unreachable
; IS__CGSCC____:       F:
; IS__CGSCC____-NEXT:    ret i32 undef
;
entry:
  %A.0 = load i32, i32* null
  br i1 %C, label %T, label %F

T:
  ret i32 %A.0

F:
  ret i32 1
}

define i32 @foo() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret i32 1
;
  %X = call i32 @callee(i1 false, i32* null)
  ret i32 %X
}

; Tests for nonnull noundef attribute violation.
;
; Tests for argument position

define void @arg_nonnull_1(i32* nonnull %a) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_1
; CHECK-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR6:[0-9]+]] {
; CHECK-NEXT:    store i32 0, i32* [[A]], align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %a
  ret void
}

define void @arg_nonnull_1_noundef_1(i32* nonnull noundef %a) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_1_noundef_1
; CHECK-SAME: (i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[A:%.*]]) #[[ATTR6]] {
; CHECK-NEXT:    store i32 0, i32* [[A]], align 4
; CHECK-NEXT:    ret void
;
  store i32 0, i32* %a
  ret void
}

define void @arg_nonnull_12(i32* nonnull %a, i32* nonnull %b, i32* %c) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_12
; CHECK-SAME: (i32* nocapture nofree nonnull writeonly [[A:%.*]], i32* nocapture nofree nonnull writeonly [[B:%.*]], i32* nofree writeonly [[C:%.*]]) #[[ATTR6]] {
; CHECK-NEXT:    [[D:%.*]] = icmp eq i32* [[C]], null
; CHECK-NEXT:    br i1 [[D]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    store i32 0, i32* [[A]], align 4
; CHECK-NEXT:    br label [[RET:%.*]]
; CHECK:       f:
; CHECK-NEXT:    store i32 1, i32* [[B]], align 4
; CHECK-NEXT:    br label [[RET]]
; CHECK:       ret:
; CHECK-NEXT:    ret void
;
  %d = icmp eq i32* %c, null
  br i1 %d, label %t, label %f
t:
  store i32 0, i32* %a
  br label %ret
f:
  store i32 1, i32* %b
  br label %ret
ret:
  ret void
}

define void @arg_nonnull_12_noundef_2(i32* nonnull %a, i32* noundef nonnull %b, i32* %c) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn writeonly
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_12_noundef_2
; CHECK-SAME: (i32* nocapture nofree nonnull writeonly [[A:%.*]], i32* nocapture nofree noundef nonnull writeonly [[B:%.*]], i32* nofree writeonly [[C:%.*]]) #[[ATTR6]] {
; CHECK-NEXT:    [[D:%.*]] = icmp eq i32* [[C]], null
; CHECK-NEXT:    br i1 [[D]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    store i32 0, i32* [[A]], align 4
; CHECK-NEXT:    br label [[RET:%.*]]
; CHECK:       f:
; CHECK-NEXT:    store i32 1, i32* [[B]], align 4
; CHECK-NEXT:    br label [[RET]]
; CHECK:       ret:
; CHECK-NEXT:    ret void
;
  %d = icmp eq i32* %c, null
  br i1 %d, label %t, label %f
t:
  store i32 0, i32* %a
  br label %ret
f:
  store i32 1, i32* %b
  br label %ret
ret:
  ret void
}

; Pass null directly to argument with nonnull attribute
define void @arg_nonnull_violation1_1() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_violation1_1
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  call void @arg_nonnull_1(i32* null)
  ret void
}

define void @arg_nonnull_violation1_2() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_violation1_2
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  call void @arg_nonnull_1_noundef_1(i32* null)
  ret void
}

; A case that depends on value simplification
define void @arg_nonnull_violation2_1(i1 %c) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_violation2_1
; CHECK-SAME: (i1 [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  %null = getelementptr i32, i32* null, i32 0
  %mustnull = select i1 %c, i32* null, i32* %null
  call void @arg_nonnull_1(i32* %mustnull)
  ret void
}

define void @arg_nonnull_violation2_2(i1 %c) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_violation2_2
; CHECK-SAME: (i1 [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    unreachable
;
  %null = getelementptr i32, i32* null, i32 0
  %mustnull = select i1 %c, i32* null, i32* %null
  call void @arg_nonnull_1_noundef_1(i32* %mustnull)
  ret void
}

; Cases for single and multiple violation at a callsite
define void @arg_nonnull_violation3_1(i1 %c) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_violation3_1
; CHECK-SAME: (i1 [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    call void @arg_nonnull_12(i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], i32* nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]]) #[[ATTR7:[0-9]+]]
; CHECK-NEXT:    call void @arg_nonnull_12(i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], i32* noalias nocapture nofree noundef writeonly align 4294967296 null) #[[ATTR7]]
; CHECK-NEXT:    unreachable
; CHECK:       f:
; CHECK-NEXT:    unreachable
; CHECK:       ret:
; CHECK-NEXT:    ret void
;
  %ptr = alloca i32
  br i1 %c, label %t, label %f
t:
  call void @arg_nonnull_12(i32* %ptr, i32* %ptr, i32* %ptr)
  call void @arg_nonnull_12(i32* %ptr, i32* %ptr, i32* null)
  call void @arg_nonnull_12(i32* %ptr, i32* null, i32* %ptr)
  call void @arg_nonnull_12(i32* %ptr, i32* null, i32* null)
  br label %ret
f:
  call void @arg_nonnull_12(i32* null, i32* %ptr, i32* %ptr)
  call void @arg_nonnull_12(i32* null, i32* %ptr, i32* null)
  call void @arg_nonnull_12(i32* null, i32* null, i32* %ptr)
  call void @arg_nonnull_12(i32* null, i32* null, i32* null)
  br label %ret
ret:
  ret void
}

define void @arg_nonnull_violation3_2(i1 %c) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@arg_nonnull_violation3_2
; CHECK-SAME: (i1 [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    call void @arg_nonnull_12_noundef_2(i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], i32* nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]]) #[[ATTR7]]
; CHECK-NEXT:    call void @arg_nonnull_12_noundef_2(i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], i32* nocapture nofree noundef nonnull writeonly align 4 dereferenceable(4) [[PTR]], i32* noalias nocapture nofree noundef writeonly align 4294967296 null) #[[ATTR7]]
; CHECK-NEXT:    unreachable
; CHECK:       f:
; CHECK-NEXT:    unreachable
; CHECK:       ret:
; CHECK-NEXT:    ret void
;
  %ptr = alloca i32
  br i1 %c, label %t, label %f
t:
  call void @arg_nonnull_12_noundef_2(i32* %ptr, i32* %ptr, i32* %ptr)
  call void @arg_nonnull_12_noundef_2(i32* %ptr, i32* %ptr, i32* null)
  call void @arg_nonnull_12_noundef_2(i32* %ptr, i32* null, i32* %ptr)
  call void @arg_nonnull_12_noundef_2(i32* %ptr, i32* null, i32* null)
  br label %ret
f:
  call void @arg_nonnull_12_noundef_2(i32* null, i32* %ptr, i32* %ptr)
  call void @arg_nonnull_12_noundef_2(i32* null, i32* %ptr, i32* null)
  call void @arg_nonnull_12_noundef_2(i32* null, i32* null, i32* %ptr)
  call void @arg_nonnull_12_noundef_2(i32* null, i32* null, i32* null)
  br label %ret
ret:
  ret void
}

; Tests for returned position

define nonnull i32* @returned_nonnnull(i32 %c) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@returned_nonnnull
; CHECK-SAME: (i32 [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    switch i32 [[C]], label [[ONDEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[ONZERO:%.*]]
; CHECK-NEXT:    i32 1, label [[ONONE:%.*]]
; CHECK-NEXT:    ]
; CHECK:       onzero:
; CHECK-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    ret i32* [[PTR]]
; CHECK:       onone:
; CHECK-NEXT:    ret i32* null
; CHECK:       ondefault:
; CHECK-NEXT:    ret i32* undef
;
  switch i32 %c, label %ondefault [ i32 0, label %onzero
  i32 1, label %onone ]
onzero:
  %ptr = alloca i32
  ret i32* %ptr
onone:
  ret i32* null
ondefault:
  ret i32* undef
}

define noundef i32* @returned_noundef(i32 %c) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@returned_noundef
; CHECK-SAME: (i32 [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    switch i32 [[C]], label [[ONDEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[ONZERO:%.*]]
; CHECK-NEXT:    i32 1, label [[ONONE:%.*]]
; CHECK-NEXT:    ]
; CHECK:       onzero:
; CHECK-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    ret i32* [[PTR]]
; CHECK:       onone:
; CHECK-NEXT:    ret i32* null
; CHECK:       ondefault:
; CHECK-NEXT:    unreachable
;
  switch i32 %c, label %ondefault [ i32 0, label %onzero
  i32 1, label %onone ]
onzero:
  %ptr = alloca i32
  ret i32* %ptr
onone:
  ret i32* null
ondefault:
  ret i32* undef
}

define nonnull noundef i32* @returned_nonnnull_noundef(i32 %c) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@returned_nonnnull_noundef
; CHECK-SAME: (i32 [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    switch i32 [[C]], label [[ONDEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[ONZERO:%.*]]
; CHECK-NEXT:    i32 1, label [[ONONE:%.*]]
; CHECK-NEXT:    ]
; CHECK:       onzero:
; CHECK-NEXT:    [[PTR:%.*]] = alloca i32, align 4
; CHECK-NEXT:    ret i32* [[PTR]]
; CHECK:       onone:
; CHECK-NEXT:    unreachable
; CHECK:       ondefault:
; CHECK-NEXT:    unreachable
;
  switch i32 %c, label %ondefault [ i32 0, label %onzero
  i32 1, label %onone ]
onzero:
  %ptr = alloca i32
  ret i32* %ptr
onone:
  ret i32* null
ondefault:
  ret i32* undef
}

define noundef i32 @returned_nonnnull_noundef_int() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@returned_nonnnull_noundef_int
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret i32 0
;
  ret i32 0
}

declare void @callee_int_arg(i32)

define void @callsite_noundef_1() {
; CHECK-LABEL: define {{[^@]+}}@callsite_noundef_1() {
; CHECK-NEXT:    call void @callee_int_arg(i32 noundef 0)
; CHECK-NEXT:    ret void
;
  call void @callee_int_arg(i32 noundef 0)
  ret void
}

declare void @callee_ptr_arg(i32*)

define void @callsite_noundef_2() {
; CHECK-LABEL: define {{[^@]+}}@callsite_noundef_2() {
; CHECK-NEXT:    unreachable
;
  call void @callee_ptr_arg(i32* noundef undef)
  ret void
}

define i32 @argument_noundef1(i32 noundef %c) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@argument_noundef1
; CHECK-SAME: (i32 noundef returned [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    ret i32 [[C]]
;
  ret i32 %c
}

define i32 @violate_noundef_nonpointer() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@violate_noundef_nonpointer
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret i32 undef
;
  %ret = call i32 @argument_noundef1(i32 undef)
  ret i32 %ret
}

define i32* @argument_noundef2(i32* noundef %c) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@argument_noundef2
; CHECK-SAME: (i32* nofree noundef readnone returned "no-capture-maybe-returned" [[C:%.*]]) #[[ATTR0]] {
; CHECK-NEXT:    ret i32* [[C]]
;
  ret i32* %c
}

define i32* @violate_noundef_pointer() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@violate_noundef_pointer
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    ret i32* undef
;
  %ret = call i32* @argument_noundef2(i32* undef)
  ret i32* %ret
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind null_pointer_is_valid readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR2]] = { nofree norecurse nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR3]] = { nofree norecurse nosync nounwind null_pointer_is_valid willreturn writeonly }
; IS__TUNIT____: attributes #[[ATTR4]] = { nofree norecurse nounwind null_pointer_is_valid willreturn }
; IS__TUNIT____: attributes #[[ATTR5]] = { nofree norecurse noreturn nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR6]] = { argmemonly nofree norecurse nosync nounwind willreturn writeonly }
; IS__TUNIT____: attributes #[[ATTR7]] = { nofree nosync nounwind willreturn writeonly }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind null_pointer_is_valid readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR2]] = { nofree norecurse nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR3]] = { nofree norecurse nosync nounwind null_pointer_is_valid willreturn writeonly }
; IS__CGSCC____: attributes #[[ATTR4]] = { nofree norecurse nounwind null_pointer_is_valid willreturn }
; IS__CGSCC____: attributes #[[ATTR5]] = { nofree norecurse noreturn nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR6]] = { argmemonly nofree norecurse nosync nounwind willreturn writeonly }
; IS__CGSCC____: attributes #[[ATTR7]] = { nounwind willreturn writeonly }
;.
