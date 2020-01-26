; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor --attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=6 -S < %s | FileCheck %s --check-prefixes=CHECK,MODULE,ALL_BUT_OLD_CGSCCC
; RUN: opt -attributor-cgscc --attributor-disable=false -attributor-annotate-decl-cs -attributor-max-iterations=6 -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC
; RUN: opt -passes=attributor --attributor-disable=false -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=6 -S < %s | FileCheck %s --check-prefixes=CHECK,MODULE,ALL_BUT_OLD_CGSCCC
; RUN: opt -passes='attributor-cgscc' --attributor-disable=false -attributor-annotate-decl-cs -attributor-max-iterations=6 -S < %s | FileCheck %s --check-prefixes=CHECK,CGSCC,ALL_BUT_OLD_CGSCCC
; UTC_ARGS: --disable

; ALL_BUT_OLD_CGSCCC: @dead_with_blockaddress_users.l = constant [2 x i8*] [i8* inttoptr (i32 1 to i8*), i8* inttoptr (i32 1 to i8*)]
@dead_with_blockaddress_users.l = constant [2 x i8*] [i8* blockaddress(@dead_with_blockaddress_users, %lab0), i8* blockaddress(@dead_with_blockaddress_users, %end)]

declare void @no_return_call() nofree noreturn nounwind nosync

declare void @normal_call() readnone

declare i32 @foo()

declare i32 @foo_nounwind() nounwind

declare i32 @foo_noreturn_nounwind() noreturn nounwind

declare i32 @foo_noreturn() noreturn

declare i32 @bar() nosync readnone

; This internal function has no live call sites, so all its BBs are considered dead,
; and nothing should be deduced for it.

; MODULE-NOT: define internal i32 @dead_internal_func(i32 %0)
define internal i32 @dead_internal_func(i32 %0) {
  %2 = icmp slt i32 %0, 1
  br i1 %2, label %3, label %5

; <label>:3:                                      ; preds = %5, %1
  %4 = phi i32 [ 1, %1 ], [ %8, %5 ]
  ret i32 %4

; <label>:5:                                      ; preds = %1, %5
  %6 = phi i32 [ %9, %5 ], [ 1, %1 ]
  %7 = phi i32 [ %8, %5 ], [ 1, %1 ]
  %8 = mul nsw i32 %6, %7
  %9 = add nuw nsw i32 %6, 1
  %10 = icmp eq i32 %6, %0
  br i1 %10, label %3, label %5
}

; CHECK: Function Attrs: argmemonly nofree norecurse nounwind uwtable willreturn
define i32 @volatile_load(i32*) norecurse nounwind uwtable {
  %2 = load volatile i32, i32* %0, align 4
  ret i32 %2
}

; MODULE-NOT: internal_load
define internal i32 @internal_load(i32*) norecurse nounwind uwtable {
  %2 = load i32, i32* %0, align 4
  ret i32 %2
}
; TEST 1: Only first block is live.

; CHECK: Function Attrs: nofree noreturn nosync nounwind
; MODULE-NEXT: define i32 @first_block_no_return(i32 %a, i32* nocapture nofree nonnull readnone %ptr1, i32* nocapture nofree readnone %ptr2)
; CGSCC-NEXT:  define i32 @first_block_no_return(i32 %a, i32* nocapture nofree nonnull readnone align 4 dereferenceable(4) %ptr1, i32* nocapture nofree readnone %ptr2)
define i32 @first_block_no_return(i32 %a, i32* nonnull %ptr1, i32* %ptr2) #0 {
entry:
  call i32 @internal_load(i32* %ptr1)
  call void @no_return_call()
  ; CHECK: call void @no_return_call()
  ; CHECK-NEXT: unreachable
  call i32 @dead_internal_func(i32 10)
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  call i32 @internal_load(i32* %ptr2)
  %load = call i32 @volatile_load(i32* %ptr1)
  call void @normal_call()
  %call = call i32 @foo()
  br label %cond.end

cond.false:                                       ; preds = %entry
  call void @normal_call()
  %call1 = call i32 @bar()
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %call, %cond.true ], [ %call1, %cond.false ]
  ret i32 %cond
}

; TEST 2: cond.true is dead, but cond.end is not, since cond.false is live

; This is just an example. For example we can put a sync call in a
; dead block and check if it is deduced.

; CHECK: Function Attrs: nosync
; CHECK-NEXT: define i32 @dead_block_present(i32 %a, i32* nocapture nofree readnone %ptr1)
define i32 @dead_block_present(i32 %a, i32* %ptr1) #0 {
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  call void @no_return_call()
  ; CHECK: call void @no_return_call()
  ; CHECK-NEXT: unreachable
  %call = call i32 @volatile_load(i32* %ptr1)
  br label %cond.end

cond.false:                                       ; preds = %entry
  call void @normal_call()
  %call1 = call i32 @bar()
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
; CHECK:      cond.end:
; CHECK-NEXT:   ret i32 %call1
  %cond = phi i32 [ %call, %cond.true ], [ %call1, %cond.false ]
  ret i32 %cond
}

; TEST 3: both cond.true and cond.false are dead, therfore cond.end is dead as well.

define i32 @all_dead(i32 %a) #0 {
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  call void @no_return_call()
  ; CHECK: call void @no_return_call()
  ; CHECK-NEXT: unreachable
  call i32 @dead_internal_func(i32 10)
  ; CHECK-NOT: call
  %call = call i32 @foo()
  br label %cond.end

cond.false:                                       ; preds = %entry
  call void @no_return_call()
  ; CHECK: call void @no_return_call()
  ; CHECK-NEXT: unreachable
  call i32 @dead_internal_func(i32 10)
  %call1 = call i32 @bar()
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %call, %cond.true ], [ %call1, %cond.false ]
  ret i32 %cond
}

declare i32 @__gxx_personality_v0(...)

; TEST 4: All blocks are live.

; CHECK: define i32 @all_live(i32 %a)
define i32 @all_live(i32 %a) #0 {
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  call void @normal_call()
  %call = call i32 @foo_noreturn()
  br label %cond.end

cond.false:                                       ; preds = %entry
  call void @normal_call()
  %call1 = call i32 @bar()
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %cond.true
  %cond = phi i32 [ %call, %cond.true ], [ %call1, %cond.false ]
  ret i32 %cond
}

; TEST 5.1 noreturn invoke instruction with a unreachable normal successor block.

; CHECK: define i32 @invoke_noreturn(i32 %a)
define i32 @invoke_noreturn(i32 %a) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  call void @normal_call()
  %call = invoke i32 @foo_noreturn() to label %continue
            unwind label %cleanup
  ; CHECK:      %call = invoke i32 @foo_noreturn()
  ; CHECK-NEXT:         to label %continue unwind label %cleanup

cond.false:                                       ; preds = %entry
  call void @normal_call()
  %call1 = call i32 @bar()
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %continue
  %cond = phi i32 [ %call, %continue ], [ %call1, %cond.false ]
  ret i32 %cond

continue:
  ; CHECK:      continue:
  ; CHECK-NEXT: unreachable
  br label %cond.end

cleanup:
  %res = landingpad { i8*, i32 }
  catch i8* null
  ret i32 0
}

; TEST 5.2 noreturn invoke instruction replaced by a call and an unreachable instruction
; put after it.

; CHECK: define i32 @invoke_noreturn_nounwind(i32 %a)
define i32 @invoke_noreturn_nounwind(i32 %a) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  call void @normal_call()
  %call = invoke i32 @foo_noreturn_nounwind() to label %continue
            unwind label %cleanup
  ; CHECK:      call void @normal_call()
  ; CHECK-NEXT: call i32 @foo_noreturn_nounwind()
  ; CHECK-NEXT: unreachable

  ; CHECK-NOT:      @foo_noreturn_nounwind()

cond.false:                                       ; preds = %entry
  call void @normal_call()
  %call1 = call i32 @bar()
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %continue
  %cond = phi i32 [ %call, %continue ], [ %call1, %cond.false ]
  ret i32 %cond

continue:
  br label %cond.end

cleanup:
  %res = landingpad { i8*, i32 }
  catch i8* null
  ret i32 0
}

; TEST 5.3 unounwind invoke instruction replaced by a call and a branch instruction put after it.
define i32 @invoke_nounwind(i32 %a) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; CHECK-LABEL: define {{[^@]+}}@invoke_nounwind
; CHECK:       cond.true:
; CHECK-NEXT:    call void @normal_call()
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @foo_nounwind()
; CHECK-NEXT:    br label [[CONTINUE:%.*]]
; CHECK:       continue:
; CHECK-NEXT:    br label [[COND_END:%.*]]
;
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  call void @normal_call()
  %call = invoke i32 @foo_nounwind() to label %continue
  unwind label %cleanup

cond.false:                                       ; preds = %entry
  call void @normal_call()
  %call1 = call i32 @bar()
  br label %cond.end

cond.end:                                         ; preds = %cond.false, %continue
  %cond = phi i32 [ %call, %continue ], [ %call1, %cond.false ]
  ret i32 %cond

continue:
  br label %cond.end

cleanup:
  %res = landingpad { i8*, i32 }
  catch i8* null
  ret i32 0
}

; UTC_ARGS: --enable

; TEST 5.4 unounwind invoke instruction replaced by a call and a branch instruction put after it.
define i32 @invoke_nounwind_phi(i32 %a) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; CHECK-LABEL: define {{[^@]+}}@invoke_nounwind_phi
; CHECK-SAME: (i32 [[A:%.*]]) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*)
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    call void @normal_call()
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @foo_nounwind()
; CHECK-NEXT:    br label [[CONTINUE:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    call void @normal_call()
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @bar()
; CHECK-NEXT:    br label [[CONTINUE]]
; CHECK:       continue:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ 0, [[COND_TRUE]] ], [ 1, [[COND_FALSE]] ]
; CHECK-NEXT:    ret i32 [[P]]
; CHECK:       cleanup:
; CHECK-NEXT:    unreachable
;
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  call void @normal_call()
  %call = invoke i32 @foo_nounwind() to label %continue
  unwind label %cleanup

cond.false:                                       ; preds = %entry
  call void @normal_call()
  %call1 = call i32 @bar()
  br label %continue

continue:
  %p = phi i32 [ 0, %cond.true ], [ 1, %cond.false ]
  ret i32 %p

cleanup:
  %res = landingpad { i8*, i32 } catch i8* null
  ret i32 0
}

; TEST 5.5 unounwind invoke instruction replaced by a call and a branch instruction put after it.
define i32 @invoke_nounwind_phi_dom(i32 %a) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; CHECK-LABEL: define {{[^@]+}}@invoke_nounwind_phi_dom
; CHECK-SAME: (i32 [[A:%.*]]) personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*)
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[A]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_TRUE:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.true:
; CHECK-NEXT:    call void @normal_call()
; CHECK-NEXT:    [[CALL:%.*]] = call i32 @foo_nounwind()
; CHECK-NEXT:    br label [[CONTINUE:%.*]]
; CHECK:       cond.false:
; CHECK-NEXT:    call void @normal_call()
; CHECK-NEXT:    [[CALL1:%.*]] = call i32 @bar()
; CHECK-NEXT:    br label [[CONTINUE]]
; CHECK:       continue:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ [[CALL]], [[COND_TRUE]] ], [ [[CALL1]], [[COND_FALSE]] ]
; CHECK-NEXT:    ret i32 [[P]]
; CHECK:       cleanup:
; CHECK-NEXT:    unreachable
;
entry:
  %cmp = icmp eq i32 %a, 0
  br i1 %cmp, label %cond.true, label %cond.false

cond.true:                                        ; preds = %entry
  call void @normal_call()
  %call = invoke i32 @foo_nounwind() to label %continue
  unwind label %cleanup

cond.false:                                       ; preds = %entry
  call void @normal_call()
  %call1 = call i32 @bar()
  br label %continue

continue:
  %p = phi i32 [ %call, %cond.true ], [ %call1, %cond.false ]
  ret i32 %p

cleanup:
  %res = landingpad { i8*, i32 } catch i8* null
  ret i32 0
}

; UTC_ARGS: --disable

; TEST 6: Undefined behvior, taken from LangRef.
; FIXME: Should be able to detect undefined behavior.

; CHECK: define void @ub(i32* nocapture nofree writeonly %0)
define void @ub(i32* %0) {
  %poison = sub nuw i32 0, 1           ; Results in a poison value.
  %still_poison = and i32 %poison, 0   ; 0, but also poison.
  %poison_yet_again = getelementptr i32, i32* %0, i32 %still_poison
  store i32 0, i32* %poison_yet_again  ; Undefined behavior due to store to poison.
  ret void
}

define void @inf_loop() #0 {
entry:
  br label %while.body

while.body:                                       ; preds = %entry, %while.body
  br label %while.body
}

; TEST 7: Infinite loop.
; FIXME: Detect infloops, and mark affected blocks dead.

define i32 @test5(i32, i32) #0 {
  %3 = icmp sgt i32 %0, %1
  br i1 %3, label %cond.if, label %cond.elseif

cond.if:                                                ; preds = %2
  %4 = tail call i32 @bar()
  br label %cond.end

cond.elseif:                                                ; preds = %2
  call void @inf_loop()
  %5 = icmp slt i32 %0, %1
  br i1 %5, label %cond.end, label %cond.else

cond.else:                                                ; preds = %cond.elseif
  %6 = tail call i32 @foo()
  br label %cond.end

cond.end:                                               ; preds = %cond.if, %cond.else, %cond.elseif
  %7 = phi i32 [ %1, %cond.elseif ], [ 0, %cond.else ], [ 0, %cond.if ]
  ret i32 %7
}

define void @rec() #0 {
entry:
  call void @rec()
  ret void
}

; TEST 8: Recursion
; FIXME: everything after first block should be marked dead
; and unreachable should be put after call to @rec().

define i32 @test6(i32, i32) #0 {
  call void @rec()
  %3 = icmp sgt i32 %0, %1
  br i1 %3, label %cond.if, label %cond.elseif

cond.if:                                                ; preds = %2
  %4 = tail call i32 @bar()
  br label %cond.end

cond.elseif:                                                ; preds = %2
  call void @rec()
  %5 = icmp slt i32 %0, %1
  br i1 %5, label %cond.end, label %cond.else

cond.else:                                                ; preds = %cond.elseif
  %6 = tail call i32 @foo()
  br label %cond.end

cond.end:                                               ; preds = %cond.if, %cond.else, %cond.elseif
  %7 = phi i32 [ %1, %cond.elseif ], [ 0, %cond.else ], [ 0, %cond.if ]
  ret i32 %7
}
; TEST 9: Recursion
; FIXME: contains recursive call to itself in cond.elseif block

define i32 @test7(i32, i32) #0 {
  %3 = icmp sgt i32 %0, %1
  br i1 %3, label %cond.if, label %cond.elseif

cond.if:                                                ; preds = %2
  %4 = tail call i32 @bar()
  br label %cond.end

cond.elseif:                                                ; preds = %2
  %5 = tail call i32 @test7(i32 %0, i32 %1)
  %6 = icmp slt i32 %0, %1
  br i1 %6, label %cond.end, label %cond.else

cond.else:                                                ; preds = %cond.elseif
  %7 = tail call i32 @foo()
  br label %cond.end

cond.end:                                               ; preds = %cond.if, %cond.else, %cond.elseif
  %8 = phi i32 [ %1, %cond.elseif ], [ 0, %cond.else ], [ 0, %cond.if ]
  ret i32 %8
}

; SCC test
;
; char a1 __attribute__((aligned(8)));
; char a2 __attribute__((aligned(16)));
;
; char* f1(char* a ){
;     return a?a:f2(&a1);
; }
; char* f2(char* a){
;     return a?f1(a):f3(&a2);
; }
;
; char* f3(char* a){
;     return a?&a1: f1(&a2);
; }

@a1 = common global i8 0, align 8
@a2 = common global i8 0, align 16

define internal i8* @f1(i8* readnone %0) local_unnamed_addr #0 {
; ATTRIBUTOR: define internal i8* @f1(i8* readnone %0)
  %2 = icmp eq i8* %0, null
  br i1 %2, label %3, label %5

; <label>:3:                                      ; preds = %1
; ATTRIBUTOR: %4 = tail call i8* undef(i8* nonnull align 8 @a1)
  %4 = tail call i8* @f2(i8* nonnull @a1)
  br label %5

; <label>:5:                                      ; preds = %1, %3
  %6 = phi i8* [ %4, %3 ], [ %0, %1 ]
  ret i8* %6
}

define internal i8* @f2(i8* readnone %0) local_unnamed_addr #0 {
; ATTRIBUTOR: define internal i8* @f2(i8* readnone %0)
  %2 = icmp eq i8* %0, null
  br i1 %2, label %5, label %3

; <label>:3:                                      ; preds = %1

; ATTRIBUTOR: %4 = tail call i8* undef(i8* nonnull align 8 %0)
  %4 = tail call i8* @f1(i8* nonnull %0)
  br label %7

; <label>:5:                                      ; preds = %1
; ATTRIBUTOR: %6 = tail call i8* undef(i8* nonnull align 16 @a2)
  %6 = tail call i8* @f3(i8* nonnull @a2)
  br label %7

; <label>:7:                                      ; preds = %5, %3
  %8 = phi i8* [ %4, %3 ], [ %6, %5 ]
  ret i8* %8
}

define internal i8* @f3(i8* readnone %0) local_unnamed_addr #0 {
; ATTRIBUTOR: define internal i8* @f3(i8* readnone %0)
  %2 = icmp eq i8* %0, null
  br i1 %2, label %3, label %5

; <label>:3:                                      ; preds = %1
; ATTRIBUTOR: %4 = tail call i8* undef(i8* nonnull align 16 @a2)
  %4 = tail call i8* @f1(i8* nonnull @a2)
  br label %5

; <label>:5:                                      ; preds = %1, %3
  %6 = phi i8* [ %4, %3 ], [ @a1, %1 ]
  ret i8* %6
}

declare void @sink() nofree nosync nounwind willreturn
define void @test_unreachable() {
; CHECK:       define void @test_unreachable()
; CHECK-NEXT:    call void @sink()
; CHECK-NEXT:    call void @test_unreachable()
; CHECK-NEXT:    unreachable
; CHECK-NEXT:  }
  call void @sink()
  call void @test_unreachable()
  unreachable
}

define linkonce_odr void @non_exact1() {
  call void @non_dead_a0()
  call void @non_dead_a1()
  call void @non_dead_a2()
  call void @non_dead_a3()
  call void @non_dead_a4()
  call void @non_dead_a5()
  call void @non_dead_a6()
  call void @non_dead_a7()
  call void @non_dead_a8()
  call void @non_dead_a9()
  call void @non_dead_a10()
  call void @non_dead_a11()
  call void @non_dead_a12()
  call void @non_dead_a13()
  call void @non_dead_a14()
  call void @non_dead_a15()
  call void @middle()
  ret void
}
define internal void @middle() {
bb0:
  call void @non_dead_b0()
  call void @non_dead_b1()
  call void @non_dead_b2()
  call void @non_dead_b3()
br label %bb1
bb1:
  call void @non_dead_b4()
  call void @non_dead_b5()
  call void @non_dead_b6()
  call void @non_dead_b7()
br label %bb2
bb2:
  call void @non_dead_b8()
  call void @non_dead_b9()
  call void @non_dead_b10()
  call void @non_dead_b11()
br label %bb3
bb3:
  call void @non_dead_b12()
  call void @non_dead_b13()
  call void @non_dead_b14()
  call void @non_dead_b15()
br label %bb4
bb4:
  call void @non_exact2()
  ret void
}
define linkonce_odr void @non_exact2() {
  call void @non_dead_c0()
  call void @non_dead_c1()
  call void @non_dead_c2()
  call void @non_dead_c3()
  call void @non_dead_c4()
  call void @non_dead_c5()
  call void @non_dead_c6()
  call void @non_dead_c7()
  call void @non_dead_c8()
  call void @non_dead_c9()
  call void @non_dead_c10()
  call void @non_dead_c11()
  call void @non_dead_c12()
  call void @non_dead_c13()
  call void @non_dead_c14()
  call void @non_dead_c15()
  call void @non_exact3()
  ret void
}
define linkonce_odr void @non_exact3() {
  call void @non_dead_d0()
  call void @non_dead_d1()
  call void @non_dead_d2()
  call void @non_dead_d3()
  call void @non_dead_d4()
  call void @non_dead_d5()
  call void @non_dead_d6()
  call void @non_dead_d7()
  call void @non_dead_d8()
  call void @non_dead_d9()
  call void @non_dead_d10()
  call void @non_dead_d11()
  call void @non_dead_d12()
  call void @non_dead_d13()
  call void @non_dead_d14()
  call void @non_dead_d15()
  %nr = call i32 @foo_noreturn()
  call void @dead_e1()
  ret void
}
; CHECK:       define linkonce_odr void @non_exact3() {
; CHECK-NEXT:   call void @non_dead_d0()
; CHECK-NEXT:   call void @non_dead_d1()
; CHECK-NEXT:   call void @non_dead_d2()
; CHECK-NEXT:   call void @non_dead_d3()
; CHECK-NEXT:   call void @non_dead_d4()
; CHECK-NEXT:   call void @non_dead_d5()
; CHECK-NEXT:   call void @non_dead_d6()
; CHECK-NEXT:   call void @non_dead_d7()
; CHECK-NEXT:   call void @non_dead_d8()
; CHECK-NEXT:   call void @non_dead_d9()
; CHECK-NEXT:   call void @non_dead_d10()
; CHECK-NEXT:   call void @non_dead_d11()
; CHECK-NEXT:   call void @non_dead_d12()
; CHECK-NEXT:   call void @non_dead_d13()
; CHECK-NEXT:   call void @non_dead_d14()
; CHECK-NEXT:   call void @non_dead_d15()
; CHECK-NEXT:   %nr = call i32 @foo_noreturn()
; CHECK-NEXT:   unreachable

define internal void @non_dead_a0() {
  call void @sink()
  ret void
}
define internal void @non_dead_a1() {
  call void @sink()
  ret void
}
define internal void @non_dead_a2() {
  call void @sink()
  ret void
}
define internal void @non_dead_a3() {
  call void @sink()
  ret void
}
define internal void @non_dead_a4() {
  call void @sink()
  ret void
}
define internal void @non_dead_a5() {
  call void @sink()
  ret void
}
define internal void @non_dead_a6() {
  call void @sink()
  ret void
}
define internal void @non_dead_a7() {
  call void @sink()
  ret void
}
define internal void @non_dead_a8() {
  call void @sink()
  ret void
}
define internal void @non_dead_a9() {
  call void @sink()
  ret void
}
define internal void @non_dead_a10() {
  call void @sink()
  ret void
}
define internal void @non_dead_a11() {
  call void @sink()
  ret void
}
define internal void @non_dead_a12() {
  call void @sink()
  ret void
}
define internal void @non_dead_a13() {
  call void @sink()
  ret void
}
define internal void @non_dead_a14() {
  call void @sink()
  ret void
}
define internal void @non_dead_a15() {
  call void @sink()
  ret void
}
define internal void @non_dead_b0() {
  call void @sink()
  ret void
}
define internal void @non_dead_b1() {
  call void @sink()
  ret void
}
define internal void @non_dead_b2() {
  call void @sink()
  ret void
}
define internal void @non_dead_b3() {
  call void @sink()
  ret void
}
define internal void @non_dead_b4() {
  call void @sink()
  ret void
}
define internal void @non_dead_b5() {
  call void @sink()
  ret void
}
define internal void @non_dead_b6() {
  call void @sink()
  ret void
}
define internal void @non_dead_b7() {
  call void @sink()
  ret void
}
define internal void @non_dead_b8() {
  call void @sink()
  ret void
}
define internal void @non_dead_b9() {
  call void @sink()
  ret void
}
define internal void @non_dead_b10() {
  call void @sink()
  ret void
}
define internal void @non_dead_b11() {
  call void @sink()
  ret void
}
define internal void @non_dead_b12() {
  call void @sink()
  ret void
}
define internal void @non_dead_b13() {
  call void @sink()
  ret void
}
define internal void @non_dead_b14() {
  call void @sink()
  ret void
}
define internal void @non_dead_b15() {
  call void @sink()
  ret void
}
define internal void @non_dead_c0() {
  call void @sink()
  ret void
}
define internal void @non_dead_c1() {
  call void @sink()
  ret void
}
define internal void @non_dead_c2() {
  call void @sink()
  ret void
}
define internal void @non_dead_c3() {
  call void @sink()
  ret void
}
define internal void @non_dead_c4() {
  call void @sink()
  ret void
}
define internal void @non_dead_c5() {
  call void @sink()
  ret void
}
define internal void @non_dead_c6() {
  call void @sink()
  ret void
}
define internal void @non_dead_c7() {
  call void @sink()
  ret void
}
define internal void @non_dead_c8() {
  call void @sink()
  ret void
}
define internal void @non_dead_c9() {
  call void @sink()
  ret void
}
define internal void @non_dead_c10() {
  call void @sink()
  ret void
}
define internal void @non_dead_c11() {
  call void @sink()
  ret void
}
define internal void @non_dead_c12() {
  call void @sink()
  ret void
}
define internal void @non_dead_c13() {
  call void @sink()
  ret void
}
define internal void @non_dead_c14() {
  call void @sink()
  ret void
}
define internal void @non_dead_c15() {
  call void @sink()
  ret void
}
define internal void @non_dead_d0() {
  call void @sink()
  ret void
}
define internal void @non_dead_d1() {
  call void @sink()
  ret void
}
define internal void @non_dead_d2() {
  call void @sink()
  ret void
}
define internal void @non_dead_d3() {
  call void @sink()
  ret void
}
define internal void @non_dead_d4() {
  call void @sink()
  ret void
}
define internal void @non_dead_d5() {
  call void @sink()
  ret void
}
define internal void @non_dead_d6() {
  call void @sink()
  ret void
}
define internal void @non_dead_d7() {
  call void @sink()
  ret void
}
define internal void @non_dead_d8() {
  call void @sink()
  ret void
}
define internal void @non_dead_d9() {
  call void @sink()
  ret void
}
define internal void @non_dead_d10() {
  call void @sink()
  ret void
}
define internal void @non_dead_d11() {
  call void @sink()
  ret void
}
define internal void @non_dead_d12() {
  call void @sink()
  ret void
}
define internal void @non_dead_d13() {
  call void @sink()
  ret void
}
define internal void @non_dead_d14() {
  call void @sink()
  ret void
}
define internal void @non_dead_d15() {
  call void @sink()
  ret void
}
define internal void @dead_e0() { call void @dead_e1() ret void }
define internal void @dead_e1() { call void @dead_e2() ret void }
define internal void @dead_e2() { ret void }

; CHECK: define internal void @non_dead_a0()
; CHECK: define internal void @non_dead_a1()
; CHECK: define internal void @non_dead_a2()
; CHECK: define internal void @non_dead_a3()
; CHECK: define internal void @non_dead_a4()
; CHECK: define internal void @non_dead_a5()
; CHECK: define internal void @non_dead_a6()
; CHECK: define internal void @non_dead_a7()
; CHECK: define internal void @non_dead_a8()
; CHECK: define internal void @non_dead_a9()
; CHECK: define internal void @non_dead_a10()
; CHECK: define internal void @non_dead_a11()
; CHECK: define internal void @non_dead_a12()
; CHECK: define internal void @non_dead_a13()
; CHECK: define internal void @non_dead_a14()
; CHECK: define internal void @non_dead_a15()
; CHECK: define internal void @non_dead_b0()
; CHECK: define internal void @non_dead_b1()
; CHECK: define internal void @non_dead_b2()
; CHECK: define internal void @non_dead_b3()
; CHECK: define internal void @non_dead_b4()
; CHECK: define internal void @non_dead_b5()
; CHECK: define internal void @non_dead_b6()
; CHECK: define internal void @non_dead_b7()
; CHECK: define internal void @non_dead_b8()
; CHECK: define internal void @non_dead_b9()
; CHECK: define internal void @non_dead_b10()
; CHECK: define internal void @non_dead_b11()
; CHECK: define internal void @non_dead_b12()
; CHECK: define internal void @non_dead_b13()
; CHECK: define internal void @non_dead_b14()
; CHECK: define internal void @non_dead_b15()
; CHECK: define internal void @non_dead_c0()
; CHECK: define internal void @non_dead_c1()
; CHECK: define internal void @non_dead_c2()
; CHECK: define internal void @non_dead_c3()
; CHECK: define internal void @non_dead_c4()
; CHECK: define internal void @non_dead_c5()
; CHECK: define internal void @non_dead_c6()
; CHECK: define internal void @non_dead_c7()
; CHECK: define internal void @non_dead_c8()
; CHECK: define internal void @non_dead_c9()
; CHECK: define internal void @non_dead_c10()
; CHECK: define internal void @non_dead_c11()
; CHECK: define internal void @non_dead_c12()
; CHECK: define internal void @non_dead_c13()
; CHECK: define internal void @non_dead_c14()
; CHECK: define internal void @non_dead_c15()
; CHECK: define internal void @non_dead_d0()
; CHECK: define internal void @non_dead_d1()
; CHECK: define internal void @non_dead_d2()
; CHECK: define internal void @non_dead_d3()
; CHECK: define internal void @non_dead_d4()
; CHECK: define internal void @non_dead_d5()
; CHECK: define internal void @non_dead_d6()
; CHECK: define internal void @non_dead_d7()
; CHECK: define internal void @non_dead_d8()
; CHECK: define internal void @non_dead_d9()
; CHECK: define internal void @non_dead_d10()
; CHECK: define internal void @non_dead_d11()
; CHECK: define internal void @non_dead_d12()
; CHECK: define internal void @non_dead_d13()
; CHECK: define internal void @non_dead_d14()
; Verify we actually deduce information for these functions.
; MODULE: Function Attrs: nofree nosync nounwind willreturn
; MODULE-NEXT: define internal void @non_dead_d15()
; MODULE-NOT: define internal void @dead_e
; CGSCC: Function Attrs: nofree nosync nounwind willreturn
; CGSCC-NEXT: define internal void @non_dead_d15()

declare void @blowup() noreturn
define void @live_with_dead_entry() personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; CHECK:      define void @live_with_dead_entry(
; CHECK-NEXT: entry:
; CHECK-NEXT:   invoke void @blowup()
; CHECK-NEXT:           to label %live_with_dead_entry.dead unwind label %lpad
; CHECK:      lpad:                                             ; preds = %entry
; CHECK-NEXT:   %0 = landingpad { i8*, i32 }
; CHECK-NEXT:           catch i8* null
; CHECK-NEXT:   br label %live_with_dead_entry
; CHECK:      live_with_dead_entry.dead:                        ; preds = %entry
; CHECK-NEXT:   unreachable
; CHECK:      live_with_dead_entry:                             ; preds = %lpad
; CHECK-NEXT:   ret void
entry:
  invoke void @blowup() to label %live_with_dead_entry unwind label %lpad
lpad:
  %0 = landingpad { i8*, i32 } catch i8* null
  br label %live_with_dead_entry
live_with_dead_entry:
  ret void
}

define void @live_with_dead_entry_lp() personality i8* bitcast (i32 (...)* @__gxx_personality_v0 to i8*) {
; CHECK:      define void @live_with_dead_entry_lp(
; CHECK-NEXT: entry:
; CHECK-NEXT:   invoke void @blowup()
; CHECK-NEXT:    to label %[[LIVE_WITH_DEAD_ENTRY_DEAD1:.*]] unwind label %[[LP1:.*]]
; CHECK:      [[LP1]]:                                              ; preds = %entry
; CHECK-NEXT:   %lp = landingpad { i8*, i32 }
; CHECK-NEXT:           catch i8* null
; CHECK-NEXT:   invoke void @blowup()
; CHECK-NEXT:    to label %[[LIVE_WITH_DEAD_ENTRY_DEAD2:.*]] unwind label %[[LP2:.*]]
; CHECK:      [[LP2]]:                                              ; preds = %lp1
; CHECK-NEXT:   %0 = landingpad { i8*, i32 }
; CHECK-NEXT:           catch i8* null
; CHECK-NEXT:   br label %live_with_dead_entry
; CHECK:      [[LIVE_WITH_DEAD_ENTRY_DEAD1]]:
; CHECK-NEXT:   unreachable
; CHECK:      [[LIVE_WITH_DEAD_ENTRY_DEAD2]]:
; CHECK-NEXT:   unreachable
; CHECK:      live_with_dead_entry:                             ; preds = %lp2
; CHECK-NEXT:   ret void
entry:
  invoke void @blowup() to label %live_with_dead_entry unwind label %lp1
lp1:
  %lp = landingpad { i8*, i32 } catch i8* null
  invoke void @blowup() to label %live_with_dead_entry unwind label %lp2
lp2:
  %0 = landingpad { i8*, i32 } catch i8* null
  br label %live_with_dead_entry
live_with_dead_entry:
  ret void
}

; MODULE: define internal void @useless_arg_sink()
; CGSCC: define internal void @useless_arg_sink(i32*{{.*}} %a)
define internal void @useless_arg_sink(i32* %a) {
  call void @sink()
  ret void
}

; MODULE: define internal void @useless_arg_almost_sink()
; CGSCC: define internal void @useless_arg_almost_sink(i32*{{.*}} %a)
define internal void @useless_arg_almost_sink(i32* %a) {
; MODULE: call void @useless_arg_sink()
; CGSCC: call void @useless_arg_sink(i32* noalias nocapture nofree readnone %a)
  call void @useless_arg_sink(i32* %a)
  ret void
}

; Check we do not annotate the function interface of this weak function.
; CHECK: define weak_odr void @useless_arg_ext(i32* %a)
define weak_odr void @useless_arg_ext(i32* %a) {
; MODULE: call void @useless_arg_almost_sink()
; CGSCC: call void @useless_arg_almost_sink(i32* noalias nofree readnone %a)
  call void @useless_arg_almost_sink(i32* %a)
  ret void
}

; CHECK: define internal void @useless_arg_ext_int(i32* %a)
define internal void @useless_arg_ext_int(i32* %a) {
; CHECK: call void @useless_arg_ext(i32* %a)
  call void @useless_arg_ext(i32* %a)
  ret void
}

define void @useless_arg_ext_int_ext(i32* %a) {
; CHECK: call void @useless_arg_ext_int(i32* %a)
  call void @useless_arg_ext_int(i32* %a)
  ret void
}

; UTC_ARGS: --enable

; FIXME: We should fold terminators.

define internal i32 @switch_default(i64 %i) nounwind {
; MODULE-LABEL: define {{[^@]+}}@switch_default()
; MODULE-NEXT:  entry:
; MODULE-NEXT:    switch i64 0, label [[SW_DEFAULT:%.*]] [
; MODULE-NEXT:    i64 3, label [[RETURN:%.*]]
; MODULE-NEXT:    i64 10, label [[RETURN]]
; MODULE-NEXT:    ]
; MODULE:       sw.default:
; MODULE-NEXT:    call void @sink()
; MODULE-NEXT:    ret i32 undef
; MODULE:       return:
; MODULE-NEXT:    unreachable
;
; CGSCC-LABEL: define {{[^@]+}}@switch_default
; CGSCC-SAME: (i64 [[I:%.*]])
; CGSCC-NEXT:  entry:
; CGSCC-NEXT:    switch i64 0, label [[SW_DEFAULT:%.*]] [
; CGSCC-NEXT:    i64 3, label [[RETURN:%.*]]
; CGSCC-NEXT:    i64 10, label [[RETURN]]
; CGSCC-NEXT:    ]
; CGSCC:       sw.default:
; CGSCC-NEXT:    call void @sink()
; CGSCC-NEXT:    ret i32 123
; CGSCC:       return:
; CGSCC-NEXT:    unreachable
;
entry:
  switch i64 %i, label %sw.default [
  i64 3, label %return
  i64 10, label %return
  ]

sw.default:
  call void @sink()
  ret i32 123

return:
  ret i32 0
}

define i32 @switch_default_caller() {
; MODULE-LABEL: define {{[^@]+}}@switch_default_caller()
; MODULE-NEXT:    [[CALL2:%.*]] = tail call i32 @switch_default()
; MODULE-NEXT:    ret i32 123
;
; CGSCC-LABEL: define {{[^@]+}}@switch_default_caller()
; CGSCC-NEXT:    [[CALL2:%.*]] = tail call i32 @switch_default(i64 0)
; CGSCC-NEXT:    ret i32 123
;
  %call2 = tail call i32 @switch_default(i64 0)
  ret i32 %call2
}

define internal i32 @switch_default_dead(i64 %i) nounwind {
entry:
  switch i64 %i, label %sw.default [
  i64 3, label %return
  i64 10, label %return
  ]

sw.default:
  ret i32 123

return:
  ret i32 0
}

define i32 @switch_default_dead_caller() {
; CHECK-LABEL: define {{[^@]+}}@switch_default_dead_caller()
; CHECK-NEXT:    ret i32 123
;
  %call2 = tail call i32 @switch_default_dead(i64 0)
  ret i32 %call2
}

; UTC_ARGS: --disable

; Allow blockaddress users
; ALL_BUT_OLD_CGSCCC-NOT @dead_with_blockaddress_users
define internal void @dead_with_blockaddress_users(i32* nocapture %pc) nounwind readonly {
entry:
  br label %indirectgoto

lab0:                                             ; preds = %indirectgoto
  %indvar.next = add i32 %indvar, 1               ; <i32> [#uses=1]
  br label %indirectgoto

end:                                              ; preds = %indirectgoto
  ret void

indirectgoto:                                     ; preds = %lab0, %entry
  %indvar = phi i32 [ %indvar.next, %lab0 ], [ 0, %entry ] ; <i32> [#uses=2]
  %pc.addr.0 = getelementptr i32, i32* %pc, i32 %indvar ; <i32*> [#uses=1]
  %tmp1.pn = load i32, i32* %pc.addr.0                 ; <i32> [#uses=1]
  %indirect.goto.dest.in = getelementptr inbounds [2 x i8*], [2 x i8*]* @dead_with_blockaddress_users.l, i32 0, i32 %tmp1.pn ; <i8**> [#uses=1]
  %indirect.goto.dest = load i8*, i8** %indirect.goto.dest.in ; <i8*> [#uses=1]
  indirectbr i8* %indirect.goto.dest, [label %lab0, label %end]
}
