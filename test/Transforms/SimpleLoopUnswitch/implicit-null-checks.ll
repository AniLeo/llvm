; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -enable-nontrivial-unswitch=true -simple-loop-unswitch -S < %s | FileCheck %s
; RUN: opt -enable-nontrivial-unswitch=true -passes='loop(simple-loop-unswitch),verify<loops>' -S < %s | FileCheck %s

declare void @may_exit()
declare void @throw_npe()

; It is illegal to preserve make_implicit notion of the condition being
; unswitched because we may exit loop before we reach the condition, so
; there is no guarantee that following implicit branch always means getting
; to throw_npe block.
define i32 @test_should_drop_make_implicit(i32* %p1, i32* %p2) {
; CHECK-LABEL: @test_should_drop_make_implicit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NULL_CHECK:%.*]] = icmp eq i32* [[P2:%.*]], null
; CHECK-NEXT:    [[NULL_CHECK_FR:%.*]] = freeze i1 [[NULL_CHECK]]
; CHECK-NEXT:    br i1 [[NULL_CHECK_FR]], label [[ENTRY_SPLIT_US:%.*]], label [[ENTRY_SPLIT:%.*]]
; CHECK:       entry.split.us:
; CHECK-NEXT:    br label [[LOOP_US:%.*]]
; CHECK:       loop.us:
; CHECK-NEXT:    [[IV_US:%.*]] = phi i32 [ 0, [[ENTRY_SPLIT_US]] ]
; CHECK-NEXT:    [[X_US:%.*]] = load i32, i32* [[P1:%.*]], align 4
; CHECK-NEXT:    [[SIDE_EXIT_COND_US:%.*]] = icmp eq i32 [[X_US]], 0
; CHECK-NEXT:    br i1 [[SIDE_EXIT_COND_US]], label [[SIDE_EXIT_SPLIT_US:%.*]], label [[NULL_CHECK_BLOCK_US:%.*]]
; CHECK:       null_check_block.us:
; CHECK-NEXT:    br label [[THROW_NPE_SPLIT_US:%.*]]
; CHECK:       side_exit.split.us:
; CHECK-NEXT:    br label [[SIDE_EXIT:%.*]]
; CHECK:       throw_npe.split.us:
; CHECK-NEXT:    br label [[THROW_NPE:%.*]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY_SPLIT]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P1]], align 4
; CHECK-NEXT:    [[SIDE_EXIT_COND:%.*]] = icmp eq i32 [[X]], 0
; CHECK-NEXT:    br i1 [[SIDE_EXIT_COND]], label [[SIDE_EXIT_SPLIT:%.*]], label [[NULL_CHECK_BLOCK:%.*]]
; CHECK:       null_check_block:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[IV_NEXT]], 10000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       side_exit.split:
; CHECK-NEXT:    br label [[SIDE_EXIT]]
; CHECK:       side_exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       throw_npe:
; CHECK-NEXT:    call void @throw_npe()
; CHECK-NEXT:    unreachable
; CHECK:       exit:
; CHECK-NEXT:    [[X_LCSSA2:%.*]] = phi i32 [ [[X]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[X_LCSSA2]]
;
entry:
  %null_check = icmp eq i32* %p2, null
  br label %loop
loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p1
  %side_exit_cond = icmp eq i32 %x, 0
  br i1 %side_exit_cond, label %side_exit, label %null_check_block

null_check_block:
  br i1 %null_check, label %throw_npe, label %backedge, !make.implicit !0

backedge:
  %iv.next = add i32 %iv,1
  %loop_cond = icmp slt i32 %iv.next, 10000
  br i1 %loop_cond, label %loop, label %exit

side_exit:
  ret i32 0

throw_npe:
  call void @throw_npe()
  unreachable

exit:
  ret i32 %x
}

; Here make.implicit notion may be preserved because we always get to throw_npe
; after following true branch. This is a trivial unswitch.
define i32 @test_may_keep_make_implicit_trivial(i32* %p1, i32* %p2) {
; CHECK-LABEL: @test_may_keep_make_implicit_trivial(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NULL_CHECK:%.*]] = icmp eq i32* [[P2:%.*]], null
; CHECK-NEXT:    br i1 [[NULL_CHECK]], label [[THROW_NPE:%.*]], label [[ENTRY_SPLIT:%.*]], !make.implicit !0
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY_SPLIT]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P1:%.*]], align 4
; CHECK-NEXT:    [[SIDE_EXIT_COND:%.*]] = icmp eq i32 [[X]], 0
; CHECK-NEXT:    br label [[SIDE_EXIT_BLOCK:%.*]]
; CHECK:       side_exit_block:
; CHECK-NEXT:    br i1 [[SIDE_EXIT_COND]], label [[SIDE_EXIT:%.*]], label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[IV_NEXT]], 10000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       side_exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       throw_npe:
; CHECK-NEXT:    call void @throw_npe()
; CHECK-NEXT:    unreachable
; CHECK:       exit:
; CHECK-NEXT:    [[X_LCSSA2:%.*]] = phi i32 [ [[X]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[X_LCSSA2]]
;
entry:
  %null_check = icmp eq i32* %p2, null
  br label %loop
loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p1
  %side_exit_cond = icmp eq i32 %x, 0
  br i1 %null_check, label %throw_npe, label %side_exit_block, !make.implicit !0

side_exit_block:
  br i1 %side_exit_cond, label %side_exit, label %backedge

backedge:
  %iv.next = add i32 %iv,1
  %loop_cond = icmp slt i32 %iv.next, 10000
  br i1 %loop_cond, label %loop, label %exit

side_exit:
  ret i32 0

throw_npe:
  call void @throw_npe()
  unreachable

exit:
  ret i32 %x
}

define i32 @test_may_keep_make_implicit_non_trivial(i32* %p1, i32* %p2) {
; CHECK-LABEL: @test_may_keep_make_implicit_non_trivial(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NULL_CHECK:%.*]] = icmp eq i32* [[P2:%.*]], null
; CHECK-NEXT:    br i1 [[NULL_CHECK]], label [[ENTRY_SPLIT_US:%.*]], label [[ENTRY_SPLIT:%.*]], !make.implicit !0
; CHECK:       entry.split.us:
; CHECK-NEXT:    br label [[LOOP_US:%.*]]
; CHECK:       loop.us:
; CHECK-NEXT:    [[IV_US:%.*]] = phi i32 [ 0, [[ENTRY_SPLIT_US]] ]
; CHECK-NEXT:    [[X_US:%.*]] = load i32, i32* [[P1:%.*]], align 4
; CHECK-NEXT:    [[INNER_BLOCK_COND_US:%.*]] = icmp eq i32 [[X_US]], 0
; CHECK-NEXT:    br i1 [[INNER_BLOCK_COND_US]], label [[INNER_BLOCK_US:%.*]], label [[NULL_CHECK_BLOCK_US:%.*]]
; CHECK:       inner_block.us:
; CHECK-NEXT:    br label [[NULL_CHECK_BLOCK_US]]
; CHECK:       null_check_block.us:
; CHECK-NEXT:    br label [[THROW_NPE_SPLIT_US:%.*]]
; CHECK:       throw_npe.split.us:
; CHECK-NEXT:    br label [[THROW_NPE:%.*]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY_SPLIT]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P1]], align 4
; CHECK-NEXT:    [[INNER_BLOCK_COND:%.*]] = icmp eq i32 [[X]], 0
; CHECK-NEXT:    br i1 [[INNER_BLOCK_COND]], label [[INNER_BLOCK:%.*]], label [[NULL_CHECK_BLOCK:%.*]]
; CHECK:       inner_block:
; CHECK-NEXT:    br label [[NULL_CHECK_BLOCK]]
; CHECK:       null_check_block:
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[IV_NEXT]], 10000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       throw_npe:
; CHECK-NEXT:    call void @throw_npe()
; CHECK-NEXT:    unreachable
; CHECK:       exit:
; CHECK-NEXT:    [[X_LCSSA1:%.*]] = phi i32 [ [[X]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[X_LCSSA1]]
;
entry:
  %null_check = icmp eq i32* %p2, null
  br label %loop
loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p1
  %inner_block_cond = icmp eq i32 %x, 0
  br i1 %inner_block_cond, label %inner_block, label %null_check_block

inner_block:
  br label %null_check_block

null_check_block:
  br i1 %null_check, label %throw_npe, label %backedge, !make.implicit !0

backedge:
  %iv.next = add i32 %iv,1
  %loop_cond = icmp slt i32 %iv.next, 10000
  br i1 %loop_cond, label %loop, label %exit

throw_npe:
  call void @throw_npe()
  unreachable

exit:
  ret i32 %x
}

; Here make.implicit notion should be dropped because of exiting call.
define i32 @test_should_drop_make_implicit_exiting_call(i32* %p1, i32* %p2) {
; CHECK-LABEL: @test_should_drop_make_implicit_exiting_call(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NULL_CHECK:%.*]] = icmp eq i32* [[P2:%.*]], null
; CHECK-NEXT:    [[NULL_CHECK_FR:%.*]] = freeze i1 [[NULL_CHECK]]
; CHECK-NEXT:    br i1 [[NULL_CHECK_FR]], label [[ENTRY_SPLIT_US:%.*]], label [[ENTRY_SPLIT:%.*]]
; CHECK:       entry.split.us:
; CHECK-NEXT:    br label [[LOOP_US:%.*]]
; CHECK:       loop.us:
; CHECK-NEXT:    [[IV_US:%.*]] = phi i32 [ 0, [[ENTRY_SPLIT_US]] ]
; CHECK-NEXT:    call void @may_exit()
; CHECK-NEXT:    [[X_US:%.*]] = load i32, i32* [[P1:%.*]], align 4
; CHECK-NEXT:    [[SIDE_EXIT_COND_US:%.*]] = icmp eq i32 [[X_US]], 0
; CHECK-NEXT:    br label [[THROW_NPE_SPLIT_US:%.*]]
; CHECK:       throw_npe.split.us:
; CHECK-NEXT:    br label [[THROW_NPE:%.*]]
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY_SPLIT]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    call void @may_exit()
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P1]], align 4
; CHECK-NEXT:    [[SIDE_EXIT_COND:%.*]] = icmp eq i32 [[X]], 0
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[IV_NEXT]], 10000
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       throw_npe:
; CHECK-NEXT:    call void @throw_npe()
; CHECK-NEXT:    unreachable
; CHECK:       exit:
; CHECK-NEXT:    [[X_LCSSA1:%.*]] = phi i32 [ [[X]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[X_LCSSA1]]
;
entry:
  %null_check = icmp eq i32* %p2, null
  br label %loop
loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  call void @may_exit()
  %x = load i32, i32* %p1
  %side_exit_cond = icmp eq i32 %x, 0
  br i1 %null_check, label %throw_npe, label %backedge, !make.implicit !0

backedge:
  %iv.next = add i32 %iv,1
  %loop_cond = icmp slt i32 %iv.next, 10000
  br i1 %loop_cond, label %loop, label %exit

throw_npe:
  call void @throw_npe()
  unreachable

exit:
  ret i32 %x
}

; Here exiting call goes after the null check, so make.implicit may be preserved.
define i32 @test_may_keep_make_implicit_exiting_call(i32* %p1, i32* %p2) {
; CHECK-LABEL: @test_may_keep_make_implicit_exiting_call(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[NULL_CHECK:%.*]] = icmp eq i32* [[P2:%.*]], null
; CHECK-NEXT:    br i1 [[NULL_CHECK]], label [[THROW_NPE:%.*]], label [[ENTRY_SPLIT:%.*]], !make.implicit !0
; CHECK:       entry.split:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY_SPLIT]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P1:%.*]], align 4
; CHECK-NEXT:    [[SIDE_EXIT_COND:%.*]] = icmp eq i32 [[X]], 0
; CHECK-NEXT:    br label [[BACKEDGE]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[IV_NEXT]], 10000
; CHECK-NEXT:    call void @may_exit()
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       throw_npe:
; CHECK-NEXT:    call void @throw_npe()
; CHECK-NEXT:    unreachable
; CHECK:       exit:
; CHECK-NEXT:    [[X_LCSSA1:%.*]] = phi i32 [ [[X]], [[BACKEDGE]] ]
; CHECK-NEXT:    ret i32 [[X_LCSSA1]]
;
entry:
  %null_check = icmp eq i32* %p2, null
  br label %loop
loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  %x = load i32, i32* %p1
  %side_exit_cond = icmp eq i32 %x, 0
  br i1 %null_check, label %throw_npe, label %backedge, !make.implicit !0

backedge:
  %iv.next = add i32 %iv,1
  %loop_cond = icmp slt i32 %iv.next, 10000
  call void @may_exit()
  br i1 %loop_cond, label %loop, label %exit

throw_npe:
  call void @throw_npe()
  unreachable

exit:
  ret i32 %x
}

!0 = !{}
