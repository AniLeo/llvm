; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-unroll -S %s | FileCheck %s

declare void @foo()

define void @unroll_unreachable_exit_and_latch_exit(i32* %ptr, i32 %N, i32 %x) {
; CHECK-LABEL: @unroll_unreachable_exit_and_latch_exit(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[IV]], 2
; CHECK-NEXT:    br i1 [[C]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       else:
; CHECK-NEXT:    [[C_2:%.*]] = icmp eq i32 [[IV]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[C_2]], label [[UNREACHABLE_EXIT:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[M:%.*]] = phi i32 [ 0, [[THEN]] ], [ [[X]], [[ELSE]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i32 [[IV]]
; CHECK-NEXT:    store i32 [[M]], i32* [[GEP]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[C_3:%.*]] = icmp ult i32 [[IV]], 1000
; CHECK-NEXT:    br i1 [[C_3]], label [[LOOP_HEADER]], label [[EXIT:%.*]]
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

define void @unroll_unreachable_exit_and_header_exit(i32* %ptr, i32 %N, i32 %x) {
; CHECK-LABEL: @unroll_unreachable_exit_and_header_exit(
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

define void @unroll_unreachable_and_multiple_reachable_exits(i32* %ptr, i32 %N, i32 %x) {
; CHECK-LABEL: @unroll_unreachable_and_multiple_reachable_exits(
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
