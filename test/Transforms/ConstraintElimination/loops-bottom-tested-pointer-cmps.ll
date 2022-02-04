; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

declare void @use(i1)
define void @checks_in_loops_removable(i8* %ptr, i8* %lower, i8* %upper, i8 %n) {
; CHECK-LABEL: @checks_in_loops_removable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_PTR_LOWER:%.*]] = icmp ult i8* [[PTR:%.*]], [[LOWER:%.*]]
; CHECK-NEXT:    br i1 [[CMP_PTR_LOWER]], label [[TRAP:%.*]], label [[PRE_1:%.*]]
; CHECK:       pre.1:
; CHECK-NEXT:    [[IDX_EXT:%.*]] = zext i8 [[N:%.*]] to i16
; CHECK-NEXT:    [[PTR_N:%.*]] = getelementptr inbounds i8, i8* [[PTR]], i16 [[IDX_EXT]]
; CHECK-NEXT:    [[CMP_PTR_N_UPPER:%.*]] = icmp ult i8* [[PTR_N]], [[UPPER:%.*]]
; CHECK-NEXT:    br i1 [[CMP_PTR_N_UPPER]], label [[PRE_2:%.*]], label [[TRAP]]
; CHECK:       pre.2:
; CHECK-NEXT:    [[CMP_N_NOT_ZERO:%.*]] = icmp eq i8 [[N]], 0
; CHECK-NEXT:    br i1 [[CMP_N_NOT_ZERO]], label [[EXIT:%.*]], label [[LOOP_HEADER:%.*]]
; CHECK:       trap:
; CHECK-NEXT:    ret void
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i16 [ 0, [[PRE_2]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[PTR_IV:%.*]] = getelementptr inbounds i8, i8* [[PTR]], i16 [[IV]]
; CHECK-NEXT:    [[CMP_PTR_IV_LOWER:%.*]] = icmp ugt i8* [[LOWER]], [[PTR_IV]]
; CHECK-NEXT:    [[CMP_PTR_IV_UPPER:%.*]] = icmp ule i8* [[UPPER]], [[PTR_IV]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP_PTR_IV_LOWER]], [[CMP_PTR_IV_UPPER]]
; CHECK-NEXT:    br i1 [[OR]], label [[TRAP]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    store i8 0, i8* [[PTR_IV]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i16 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i16 [[IV_NEXT]], [[IDX_EXT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_HEADER]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp.ptr.lower = icmp ult i8* %ptr, %lower
  br i1 %cmp.ptr.lower, label %trap, label %pre.1

pre.1:
  %idx.ext = zext i8 %n to i16
  %ptr.n = getelementptr inbounds i8, i8* %ptr, i16 %idx.ext
  %cmp.ptr.n.upper = icmp ult i8* %ptr.n, %upper
  br i1 %cmp.ptr.n.upper, label %pre.2, label %trap

pre.2:
  %cmp.n.not.zero = icmp eq i8 %n, 0
  br i1 %cmp.n.not.zero, label %exit, label %loop.header

trap:
  ret void

loop.header:
  %iv = phi i16 [ 0, %pre.2 ], [ %iv.next, %loop.latch ]
  %ptr.iv = getelementptr inbounds i8, i8* %ptr, i16 %iv
  %cmp.ptr.iv.lower = icmp ugt i8* %lower, %ptr.iv
  %cmp.ptr.iv.upper = icmp ule i8* %upper, %ptr.iv
  %or = or i1 %cmp.ptr.iv.lower, %cmp.ptr.iv.upper
  br i1 %or, label %trap, label %loop.latch

loop.latch:
  store i8 0, i8* %ptr.iv, align 4
  %iv.next = add nuw nsw i16 %iv, 1
  %exitcond = icmp ne i16 %iv.next, %idx.ext
  br i1 %exitcond, label %loop.header, label %exit

exit:
  ret void
}

define void @some_checks_in_loops_removable(i8* %ptr, i8* %lower, i8* %upper, i8 %n) {
; CHECK-LABEL: @some_checks_in_loops_removable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_PTR_LOWER:%.*]] = icmp ult i8* [[PTR:%.*]], [[LOWER:%.*]]
; CHECK-NEXT:    br i1 [[CMP_PTR_LOWER]], label [[TRAP:%.*]], label [[PRE_1:%.*]]
; CHECK:       pre.1:
; CHECK-NEXT:    [[IDX_EXT:%.*]] = zext i8 [[N:%.*]] to i16
; CHECK-NEXT:    [[PTR_N:%.*]] = getelementptr inbounds i8, i8* [[PTR]], i16 [[IDX_EXT]]
; CHECK-NEXT:    [[CMP_PTR_N_UPPER:%.*]] = icmp ult i8* [[PTR_N]], [[UPPER:%.*]]
; CHECK-NEXT:    br i1 [[CMP_PTR_N_UPPER]], label [[PRE_2:%.*]], label [[TRAP]]
; CHECK:       pre.2:
; CHECK-NEXT:    [[CMP_N_NOT_ZERO:%.*]] = icmp eq i8 [[N]], 0
; CHECK-NEXT:    br i1 [[CMP_N_NOT_ZERO]], label [[EXIT:%.*]], label [[LOOP_HEADER:%.*]]
; CHECK:       trap:
; CHECK-NEXT:    ret void
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i16 [ 0, [[PRE_2]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[PTR_IV:%.*]] = getelementptr inbounds i8, i8* [[PTR]], i16 [[IV]]
; CHECK-NEXT:    [[CMP_PTR_IV_LOWER:%.*]] = icmp ugt i8* [[LOWER]], [[PTR_IV]]
; CHECK-NEXT:    [[CMP_PTR_IV_UPPER:%.*]] = icmp ule i8* [[UPPER]], [[PTR_IV]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP_PTR_IV_LOWER]], [[CMP_PTR_IV_UPPER]]
; CHECK-NEXT:    br i1 [[OR]], label [[TRAP]], label [[LOOP_BODY:%.*]]
; CHECK:       loop.body:
; CHECK-NEXT:    [[IV_1:%.*]] = add nuw nsw i16 [[IV]], 1
; CHECK-NEXT:    [[PTR_IV_1:%.*]] = getelementptr inbounds i8, i8* [[PTR]], i16 [[IV_1]]
; CHECK-NEXT:    [[CMP_PTR_IV_1_LOWER:%.*]] = icmp ugt i8* [[LOWER]], [[PTR_IV_1]]
; CHECK-NEXT:    [[CMP_PTR_IV_1_UPPER:%.*]] = icmp ule i8* [[UPPER]], [[PTR_IV_1]]
; CHECK-NEXT:    [[OR_1:%.*]] = or i1 [[CMP_PTR_IV_1_LOWER]], [[CMP_PTR_IV_1_UPPER]]
; CHECK-NEXT:    br i1 [[OR]], label [[TRAP]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    store i8 0, i8* [[PTR_IV]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i16 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i16 [[IV_NEXT]], [[IDX_EXT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_HEADER]], label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp.ptr.lower = icmp ult i8* %ptr, %lower
  br i1 %cmp.ptr.lower, label %trap, label %pre.1

pre.1:
  %idx.ext = zext i8 %n to i16
  %ptr.n = getelementptr inbounds i8, i8* %ptr, i16 %idx.ext
  %cmp.ptr.n.upper = icmp ult i8* %ptr.n, %upper
  br i1 %cmp.ptr.n.upper, label %pre.2, label %trap

pre.2:
  %cmp.n.not.zero = icmp eq i8 %n, 0
  br i1 %cmp.n.not.zero, label %exit, label %loop.header

trap:
  ret void

loop.header:
  %iv = phi i16 [ 0, %pre.2 ], [ %iv.next, %loop.latch ]
  %ptr.iv = getelementptr inbounds i8, i8* %ptr, i16 %iv
  %cmp.ptr.iv.lower = icmp ugt i8* %lower, %ptr.iv
  %cmp.ptr.iv.upper = icmp ule i8* %upper, %ptr.iv
  %or = or i1 %cmp.ptr.iv.lower, %cmp.ptr.iv.upper
  br i1 %or, label %trap, label %loop.body

loop.body:
  %iv.1 = add nuw nsw i16 %iv, 1
  %ptr.iv.1 = getelementptr inbounds i8, i8* %ptr, i16 %iv.1
  %cmp.ptr.iv.1.lower = icmp ugt i8* %lower, %ptr.iv.1
  %cmp.ptr.iv.1.upper = icmp ule i8* %upper, %ptr.iv.1
  %or.1 = or i1 %cmp.ptr.iv.1.lower, %cmp.ptr.iv.1.upper
  br i1 %or, label %trap, label %loop.latch

loop.latch:
  store i8 0, i8* %ptr.iv, align 4
  %iv.next = add nuw nsw i16 %iv, 1
  %exitcond = icmp ne i16 %iv.next, %idx.ext
  br i1 %exitcond, label %loop.header, label %exit

exit:
  ret void
}


; N might be zero, cannot remove upper checks.
define void @no_checks_in_loops_removable(i8* %ptr, i8* %lower, i8* %upper, i8 %n) {
; CHECK-LABEL: @no_checks_in_loops_removable(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP_PTR_LOWER:%.*]] = icmp ult i8* [[PTR:%.*]], [[LOWER:%.*]]
; CHECK-NEXT:    br i1 [[CMP_PTR_LOWER]], label [[TRAP:%.*]], label [[PRE_1:%.*]]
; CHECK:       pre.1:
; CHECK-NEXT:    [[IDX_EXT:%.*]] = zext i8 [[N:%.*]] to i16
; CHECK-NEXT:    [[PTR_N:%.*]] = getelementptr inbounds i8, i8* [[PTR]], i16 [[IDX_EXT]]
; CHECK-NEXT:    [[CMP_PTR_N_UPPER:%.*]] = icmp ult i8* [[PTR_N]], [[UPPER:%.*]]
; CHECK-NEXT:    br i1 [[CMP_PTR_N_UPPER]], label [[LOOP_HEADER:%.*]], label [[TRAP]]
; CHECK:       trap:
; CHECK-NEXT:    ret void
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i16 [ 0, [[PRE_1]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[PTR_IV:%.*]] = getelementptr inbounds i8, i8* [[PTR]], i16 [[IV]]
; CHECK-NEXT:    [[CMP_PTR_IV_LOWER:%.*]] = icmp ugt i8* [[LOWER]], [[PTR_IV]]
; CHECK-NEXT:    [[CMP_PTR_IV_UPPER:%.*]] = icmp ule i8* [[UPPER]], [[PTR_IV]]
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[CMP_PTR_IV_LOWER]], [[CMP_PTR_IV_UPPER]]
; CHECK-NEXT:    br i1 [[OR]], label [[TRAP]], label [[LOOP_BODY:%.*]]
; CHECK:       loop.body:
; CHECK-NEXT:    [[IV_1:%.*]] = add nuw nsw i16 [[IV]], 1
; CHECK-NEXT:    [[PTR_IV_1:%.*]] = getelementptr inbounds i8, i8* [[PTR]], i16 [[IV_1]]
; CHECK-NEXT:    [[CMP_PTR_IV_1_LOWER:%.*]] = icmp ugt i8* [[LOWER]], [[PTR_IV_1]]
; CHECK-NEXT:    [[CMP_PTR_IV_1_UPPER:%.*]] = icmp ule i8* [[UPPER]], [[PTR_IV_1]]
; CHECK-NEXT:    [[OR_1:%.*]] = or i1 [[CMP_PTR_IV_1_LOWER]], [[CMP_PTR_IV_1_UPPER]]
; CHECK-NEXT:    br i1 [[OR]], label [[TRAP]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    store i8 0, i8* [[PTR_IV]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i16 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp ne i16 [[IV_NEXT]], [[IDX_EXT]]
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[LOOP_HEADER]], label [[EXIT:%.*]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  %cmp.ptr.lower = icmp ult i8* %ptr, %lower
  br i1 %cmp.ptr.lower, label %trap, label %pre.1

pre.1:
  %idx.ext = zext i8 %n to i16
  %ptr.n = getelementptr inbounds i8, i8* %ptr, i16 %idx.ext
  %cmp.ptr.n.upper = icmp ult i8* %ptr.n, %upper
  br i1 %cmp.ptr.n.upper, label %loop.header, label %trap

trap:
  ret void

loop.header:
  %iv = phi i16 [ 0, %pre.1 ], [ %iv.next, %loop.latch ]
  %ptr.iv = getelementptr inbounds i8, i8* %ptr, i16 %iv
  %cmp.ptr.iv.lower = icmp ugt i8* %lower, %ptr.iv
  %cmp.ptr.iv.upper = icmp ule i8* %upper, %ptr.iv
  %or = or i1 %cmp.ptr.iv.lower, %cmp.ptr.iv.upper
  br i1 %or, label %trap, label %loop.body

loop.body:
  %iv.1 = add nuw nsw i16 %iv, 1
  %ptr.iv.1 = getelementptr inbounds i8, i8* %ptr, i16 %iv.1
  %cmp.ptr.iv.1.lower = icmp ugt i8* %lower, %ptr.iv.1
  %cmp.ptr.iv.1.upper = icmp ule i8* %upper, %ptr.iv.1
  %or.1 = or i1 %cmp.ptr.iv.1.lower, %cmp.ptr.iv.1.upper
  br i1 %or, label %trap, label %loop.latch

loop.latch:
  store i8 0, i8* %ptr.iv, align 4
  %iv.next = add nuw nsw i16 %iv, 1
  %exitcond = icmp ne i16 %iv.next, %idx.ext
  br i1 %exitcond, label %loop.header, label %exit

exit:
  ret void
}
