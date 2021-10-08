; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-unroll -S %s | FileCheck %s

declare void @foo()

define void @peel_unreachable_exit_and_latch_exit(i32* %ptr, i32 %N, i32 %x) {
; CHECK-LABEL: @peel_unreachable_exit_and_latch_exit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER_PEEL_BEGIN:%.*]]
; CHECK:       loop.header.peel.begin:
; CHECK-NEXT:    br label [[LOOP_HEADER_PEEL:%.*]]
; CHECK:       loop.header.peel:
; CHECK-NEXT:    [[C_PEEL:%.*]] = icmp ult i32 1, 2
; CHECK-NEXT:    br i1 [[C_PEEL]], label [[THEN_PEEL:%.*]], label [[ELSE_PEEL:%.*]]
; CHECK:       else.peel:
; CHECK-NEXT:    [[C_2_PEEL:%.*]] = icmp eq i32 1, [[X:%.*]]
; CHECK-NEXT:    br i1 [[C_2_PEEL]], label [[UNREACHABLE_EXIT:%.*]], label [[LOOP_LATCH_PEEL:%.*]]
; CHECK:       then.peel:
; CHECK-NEXT:    br label [[LOOP_LATCH_PEEL]]
; CHECK:       loop.latch.peel:
; CHECK-NEXT:    [[M_PEEL:%.*]] = phi i32 [ 0, [[THEN_PEEL]] ], [ [[X]], [[ELSE_PEEL]] ]
; CHECK-NEXT:    [[GEP_PEEL:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i32 1
; CHECK-NEXT:    store i32 [[M_PEEL]], i32* [[GEP_PEEL]], align 4
; CHECK-NEXT:    [[IV_NEXT_PEEL:%.*]] = add nuw nsw i32 1, 1
; CHECK-NEXT:    [[C_3_PEEL:%.*]] = icmp ult i32 1, 1000
; CHECK-NEXT:    br i1 [[C_3_PEEL]], label [[LOOP_HEADER_PEEL_NEXT:%.*]], label [[EXIT:%.*]]
; CHECK:       loop.header.peel.next:
; CHECK-NEXT:    br label [[LOOP_HEADER_PEEL_NEXT1:%.*]]
; CHECK:       loop.header.peel.next1:
; CHECK-NEXT:    br label [[ENTRY_PEEL_NEWPH:%.*]]
; CHECK:       entry.peel.newph:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ [[IV_NEXT_PEEL]], [[ENTRY_PEEL_NEWPH]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    br i1 false, label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       else:
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i32 [[IV]], [[X]]
; CHECK-NEXT:    br i1 [[C_2]], label [[UNREACHABLE_EXIT_LOOPEXIT:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[M:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[X]], [[ELSE]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[PTR]], i32 [[IV]]
; CHECK-NEXT:    store i32 [[M]], i32* [[GEP]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i32 [[IV]], 1000
; CHECK-NEXT:    br i1 [[C_3]], label [[LOOP_HEADER]], label [[EXIT_LOOPEXIT:%.*]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       exit.loopexit:
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       unreachable.exit.loopexit:
; CHECK-NEXT:    br label [[UNREACHABLE_EXIT]]
; CHECK:       unreachable.exit:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    unreachable
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i32 [ 1, %entry ], [ %iv.next, %loop.latch ]
  %c = icmp ult i32 %iv, 2
  br i1 %c, label %then, label %else

then:
  br label %loop.latch

else:
  %c.2 = icmp eq i32 %iv, %x
  br i1 %c.2, label %unreachable.exit, label %loop.latch

loop.latch:
  %m = phi i32 [ 0, %then ], [ %x, %else ]
  %gep = getelementptr i32, i32* %ptr, i32 %iv
  store i32 %m, i32* %gep
  %iv.next = add nuw nsw i32  %iv, 1
  %c.3 = icmp ult i32 %iv, 1000
  br i1 %c.3, label %loop.header, label %exit

exit:
  ret void

unreachable.exit:
  call void @foo()
  unreachable
}

define void @peel_unreachable_exit_and_header_exit(i32* %ptr, i32 %N, i32 %x) {
; CHECK-LABEL: @peel_unreachable_exit_and_header_exit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    br i1 true, label [[EXIT:%.*]], label [[ELSE:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i32 1, [[X:%.*]]
; CHECK-NEXT:    br i1 [[C_2]], label [[UNREACHABLE_EXIT:%.*]], label [[LOOP_LATCH:%.*]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i32 1
; CHECK-NEXT:    store i32 [[X]], i32* [[GEP]], align 4
; CHECK-NEXT:    unreachable
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       unreachable.exit:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    unreachable
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i32 [ 1, %entry ], [ %iv.next, %loop.latch ]
  %c = icmp ult i32 %iv, 1000
  br i1 %c, label %exit, label %else

else:
  %c.2 = icmp eq i32 %iv, %x
  br i1 %c.2, label %unreachable.exit, label %loop.latch

loop.latch:
  %gep = getelementptr i32, i32* %ptr, i32 %iv
  store i32 %x, i32* %gep
  %iv.next = add nuw nsw i32  %iv, 1
  br label %loop.header

exit:
  ret void

unreachable.exit:
  call void @foo()
  unreachable
}

define void @peel_unreachable_and_multiple_reachable_exits(i32* %ptr, i32 %N, i32 %x) {
; CHECK-LABEL: @peel_unreachable_and_multiple_reachable_exits(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[IV]], 2
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    [[C_2:%.*]] = icmp sgt i32 [[IV]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[C_2]], label [[EXIT:%.*]], label [[LOOP_LATCH]]
; CHECK:       else:
; CHECK-NEXT:    [[C_3:%.*]] = icmp eq i32 [[IV]], [[X]]
; CHECK-NEXT:    br i1 [[C_3]], label [[UNREACHABLE_EXIT:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[M:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[X]], [[ELSE]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i32 [[IV]]
; CHECK-NEXT:    store i32 [[M]], i32* [[GEP]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[C_4:%.*]] = icmp ult i32 [[IV]], 1000
; CHECK-NEXT:    br i1 [[C_4]], label [[LOOP_HEADER]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       unreachable.exit:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    unreachable
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i32 [ 1, %entry ], [ %iv.next, %loop.latch ]
  %c = icmp ult i32 %iv, 2
  br i1 %c, label %then, label %else

then:
  %c.2 = icmp sgt i32 %iv, %x
  br i1 %c.2, label %exit, label %loop.latch

else:
  %c.3 = icmp eq i32 %iv, %x
  br i1 %c.3, label %unreachable.exit, label %loop.latch

loop.latch:
  %m = phi i32 [ 0, %then ], [ %x, %else ]
  %gep = getelementptr i32, i32* %ptr, i32 %iv
  store i32 %m, i32* %gep
  %iv.next = add nuw nsw i32  %iv, 1
  %c.4 = icmp ult i32 %iv, 1000
  br i1 %c.4, label %loop.header, label %exit

exit:
  ret void

unreachable.exit:
  call void @foo()
  unreachable
}

define void @peel_exits_to_blocks_branch_to_unreachable_block(i32* %ptr, i32 %N, i32 %x, i1 %c.1) {
; CHECK-LABEL: @peel_exits_to_blocks_branch_to_unreachable_block(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[IV]], 2
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[EXIT_1:%.*]], label [[LOOP_LATCH]]
; CHECK:       else:
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i32 [[IV]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[C_2]], label [[EXIT_2:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[M:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[X]], [[ELSE]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i32 [[IV]]
; CHECK-NEXT:    store i32 [[M]], i32* [[GEP]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i32 [[IV]], 1000
; CHECK-NEXT:    br i1 [[C_3]], label [[LOOP_HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       exit.1:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[UNREACHABLE_TERM:%.*]]
; CHECK:       exit.2:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[UNREACHABLE_TERM]]
; CHECK:       unreachable.term:
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    unreachable
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i32 [ 1, %entry ], [ %iv.next, %loop.latch ]
  %c = icmp ult i32 %iv, 2
  br i1 %c, label %then, label %else

then:
  br i1 %c.1, label %exit.1, label %loop.latch

else:
  %c.2 = icmp eq i32 %iv, %x
  br i1 %c.2, label %exit.2, label %loop.latch

loop.latch:
  %m = phi i32 [ 0, %then ], [ %x, %else ]
  %gep = getelementptr i32, i32* %ptr, i32 %iv
  store i32 %m, i32* %gep
  %iv.next = add nuw nsw i32  %iv, 1
  %c.3 = icmp ult i32 %iv, 1000
  br i1 %c.3, label %loop.header, label %exit

exit:
  ret void

exit.1:
  call void @foo()
  br label %unreachable.term

exit.2:
  call void @bar()
  br label %unreachable.term

unreachable.term:
  call void @baz()
  unreachable
}

define void @peel_exits_to_blocks_branch_to_unreachable_block_with_invariant_load(i32* %ptr, i32 %N, i32 %x, i1 %c.1, i32 %y, i32* %size_ptr) {
; CHECK-LABEL: @peel_exits_to_blocks_branch_to_unreachable_block_with_invariant_load(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[IV]], [[Y:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[EXIT_1:%.*]], label [[LOOP_LATCH]]
; CHECK:       else:
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i32 [[IV]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[C_2]], label [[EXIT_2:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[M:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[X]], [[ELSE]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i32 [[IV]]
; CHECK-NEXT:    store i32 [[M]], i32* [[GEP]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[SIZE:%.*]] = load i32, i32* [[SIZE_PTR:%.*]], align 4
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i32 [[IV_NEXT]], [[SIZE]]
; CHECK-NEXT:    br i1 [[C_3]], label [[LOOP_HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       exit.1:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[UNREACHABLE_TERM:%.*]]
; CHECK:       exit.2:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[UNREACHABLE_TERM]]
; CHECK:       unreachable.term:
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    unreachable
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i32 [ 1, %entry ], [ %iv.next, %loop.latch ]
  %c = icmp ult i32 %iv, %y
  br i1 %c, label %then, label %else

then:
  br i1 %c.1, label %exit.1, label %loop.latch

else:
  %c.2 = icmp eq i32 %iv, %x
  br i1 %c.2, label %exit.2, label %loop.latch

loop.latch:
  %m = phi i32 [ 0, %then ], [ %x, %else ]
  %gep = getelementptr i32, i32* %ptr, i32 %iv
  store i32 %m, i32* %gep
  %iv.next = add nuw nsw i32 %iv, 1
  %size = load i32, i32* %size_ptr, align 4
  %c.3 = icmp ult i32 %iv.next, %size
  br i1 %c.3, label %loop.header, label %exit

exit:
  ret void

exit.1:
  call void @foo()
  br label %unreachable.term

exit.2:
  call void @bar()
  br label %unreachable.term

unreachable.term:
  call void @baz()
  unreachable
}

define void @peel_exits_to_blocks_branch_to_unreachable_block_with_profile(i32* %ptr, i32 %N, i32 %x, i1 %c.1) !prof !0 {
; CHECK-LABEL: @peel_exits_to_blocks_branch_to_unreachable_block_with_profile(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[IV]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]], !prof [[PROF3:![0-9]+]]
; CHECK:       then:
; CHECK-NEXT:    br i1 [[C_1:%.*]], label [[EXIT_1:%.*]], label [[LOOP_LATCH]]
; CHECK:       else:
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i32 [[IV]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[C_2]], label [[EXIT_2:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[M:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[X]], [[ELSE]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i32 [[IV]]
; CHECK-NEXT:    store i32 [[M]], i32* [[GEP]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i32 [[IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[C_3]], label [[LOOP_HEADER]], label [[EXIT:%.*]], !prof [[PROF3]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
; CHECK:       exit.1:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[UNREACHABLE_TERM:%.*]]
; CHECK:       exit.2:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[UNREACHABLE_TERM]]
; CHECK:       unreachable.term:
; CHECK-NEXT:    call void @baz()
; CHECK-NEXT:    unreachable
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i32 [ 1, %entry ], [ %iv.next, %loop.latch ]
  %c = icmp ult i32 %iv, %N
  br i1 %c, label %then, label %else, !prof !1

then:
  br i1 %c.1, label %exit.1, label %loop.latch

else:
  %c.2 = icmp eq i32 %iv, %x
  br i1 %c.2, label %exit.2, label %loop.latch

loop.latch:
  %m = phi i32 [ 0, %then ], [ %x, %else ]
  %gep = getelementptr i32, i32* %ptr, i32 %iv
  store i32 %m, i32* %gep
  %iv.next = add nuw nsw i32  %iv, 1
  %c.3 = icmp ult i32 %iv.next, %N
  br i1 %c.3, label %loop.header, label %exit, !prof !2

exit:
  ret void

exit.1:
  call void @foo()
  br label %unreachable.term

exit.2:
  call void @bar()
  br label %unreachable.term

unreachable.term:
  call void @baz()
  unreachable
}

declare void @bar()
declare void @baz()

!0 = !{!"function_entry_count", i64 32768}
!1 = !{!"branch_weights", i32 0, i32 1}
!2 = !{!"branch_weights", i32 0, i32 1}
