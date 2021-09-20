; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: -p
; RUN: opt < %s -indvars -S | FileCheck %s
; RUN: opt < %s -passes=indvars -S | FileCheck %s
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64"

declare i1 @foo(i8*, i8*)
declare i1 @bar()
declare i1 @baz()

define i1 @kill_backedge_and_phis(i8* align 1 %lhs, i8* align 1 %rhs, i32 %len) {
; CHECK-LABEL: @kill_backedge_and_phis(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %length_not_zero = icmp ne i32 %len, 0
; CHECK-NEXT:    br i1 %length_not_zero, label %loop_preheader, label %exit
; CHECK:       loop_preheader:
; CHECK-NEXT:    br label %loop
; CHECK:       loop:
; CHECK-NEXT:    %iv.next = add nuw nsw i32 0, 1
; CHECK-NEXT:    %left_ptr = getelementptr inbounds i8, i8* %lhs, i32 0
; CHECK-NEXT:    %right_ptr = getelementptr inbounds i8, i8* %rhs, i32 0
; CHECK-NEXT:    %result = call i1 @foo(i8* %left_ptr, i8* %right_ptr)
; CHECK-NEXT:    br i1 %result, label %exiting_1, label %exit.loopexit
; CHECK:       exiting_1:
; CHECK-NEXT:    %iv.wide.is_not_zero = icmp ne i64 0, 0
; CHECK-NEXT:    br i1 false, label %exiting_2, label %exit.loopexit
; CHECK:       exiting_2:
; CHECK-NEXT:    %bar_ret = call i1 @bar()
; CHECK-NEXT:    br i1 %bar_ret, label %exit.loopexit, label %exiting_3
; CHECK:       exiting_3:
; CHECK-NEXT:    %baz_ret = call i1 @baz()
; CHECK-NEXT:    %continue = icmp ne i32 %iv.next, %len
; CHECK-NEXT:    %or.cond = select i1 %baz_ret, i1 %continue, i1 false
; CHECK-NEXT:    br i1 %or.cond, label %loop, label %exit.loopexit
; CHECK:       exit.loopexit:
; CHECK-NEXT:    %val.ph = phi i1 [ %baz_ret, %exiting_3 ], [ %bar_ret, %exiting_2 ], [ %iv.wide.is_not_zero, %exiting_1 ], [ %result, %loop ]
; CHECK-NEXT:    br label %exit
; CHECK:       exit:
; CHECK-NEXT:    %val = phi i1 [ false, %entry ], [ %val.ph, %exit.loopexit ]
; CHECK-NEXT:    ret i1 %val
;
entry:
  %length_not_zero = icmp ne i32 %len, 0
  br i1 %length_not_zero, label %loop_preheader, label %exit

loop_preheader:
  br label %loop

loop:
  %iv = phi i32 [ 0, %loop_preheader ], [ %iv.next, %latch ]
  %iv.wide = phi i64 [ 0, %loop_preheader ], [ %iv.wide.next, %latch ]
  %iv.next = add i32 %iv, 1
  %iv.wide.next = add i64 %iv.wide, 1
  %left_ptr = getelementptr inbounds i8, i8* %lhs, i32 %iv
  %right_ptr = getelementptr inbounds i8, i8* %rhs, i32 %iv
  %result = call i1 @foo(i8* %left_ptr, i8* %right_ptr)
  br i1 %result, label %exiting_1, label %exit

exiting_1:
  %iv.wide.is_not_zero = icmp ne i64 %iv.wide, 0
  br i1 %iv.wide.is_not_zero, label %exiting_2, label %exit

exiting_2:
  %bar_ret = call i1 @bar()
  br i1 %bar_ret, label %exit, label %exiting_3

exiting_3:
  %baz_ret = call i1 @baz()
  br i1 %baz_ret, label %latch, label %exit

latch:
  %continue = icmp ne i32 %iv.next, %len
  br i1 %continue, label %loop, label %exit

exit:
  %val = phi i1 [ %result, %loop ], [ %iv.wide.is_not_zero, %exiting_1 ],
  [ %bar_ret, %exiting_2 ], [ %baz_ret, %exiting_3 ],
  [ %baz_ret, %latch ], [ 0, %entry ]
  ret i1 %val
}

define i1 @siblings(i8* align 1 %lhs, i8* align 1 %rhs, i32 %len) {
; CHECK-LABEL: @siblings(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    %length_not_zero = icmp ne i32 %len, 0
; CHECK-NEXT:    br i1 %length_not_zero, label %weird_loop.preheader, label %exit
; CHECK:       weird_loop.preheader:
; CHECK-NEXT:    br label %weird_loop
; CHECK:       weird_loop:
; CHECK-NEXT:    %weird.iv = phi i32 [ %weird.iv.next, %weird_loop ], [ 0, %weird_loop.preheader ]
; CHECK-NEXT:    %weird.iv.next = add i32 %weird.iv, 1
; CHECK-NEXT:    %weird.iv.wide = zext i32 %weird.iv to i64
; CHECK-NEXT:    %weird.cond = call i1 @bar()
; CHECK-NEXT:    br i1 %weird.cond, label %weird_loop, label %loop.preheader
; CHECK:       loop.preheader:
; CHECK-NEXT:    %weird.iv.lcssa = phi i32 [ %weird.iv, %weird_loop ]
; CHECK-NEXT:    %weird.iv.wide.lcssa = phi i64 [ %weird.iv.wide, %weird_loop ]
; CHECK-NEXT:    br label %loop
; CHECK:       loop:
; CHECK-NEXT:    %iv.next = add i32 %weird.iv.lcssa, 1
; CHECK-NEXT:    %left_ptr = getelementptr inbounds i8, i8* %lhs, i32 %weird.iv.lcssa
; CHECK-NEXT:    %right_ptr = getelementptr inbounds i8, i8* %rhs, i32 %weird.iv.lcssa
; CHECK-NEXT:    %result = call i1 @foo(i8* %left_ptr, i8* %right_ptr)
; CHECK-NEXT:    br i1 %result, label %exiting_1, label %exit.loopexit
; CHECK:       exiting_1:
; CHECK-NEXT:    %iv.wide.is_not_zero = icmp ne i64 %weird.iv.wide.lcssa, %weird.iv.wide.lcssa
; CHECK-NEXT:    br i1 false, label %exiting_2, label %exit.loopexit
; CHECK:       exiting_2:
; CHECK-NEXT:    %bar_ret = call i1 @bar()
; CHECK-NEXT:    br i1 %bar_ret, label %exit.loopexit, label %exiting_3
; CHECK:       exiting_3:
; CHECK-NEXT:    %baz_ret = call i1 @baz()
; CHECK-NEXT:    %continue = icmp ne i32 %iv.next, %len
; CHECK-NEXT:    %or.cond = select i1 %baz_ret, i1 %continue, i1 false
; CHECK-NEXT:    br i1 %or.cond, label %loop, label %exit.loopexit
; CHECK:       exit.loopexit:
; CHECK-NEXT:    %val.ph = phi i1 [ %baz_ret, %exiting_3 ], [ %bar_ret, %exiting_2 ], [ %iv.wide.is_not_zero, %exiting_1 ], [ %result, %loop ]
; CHECK-NEXT:    br label %exit
; CHECK:       exit:
; CHECK-NEXT:    %val = phi i1 [ false, %entry ], [ %val.ph, %exit.loopexit ]
; CHECK-NEXT:    ret i1 %val
;
entry:
  %length_not_zero = icmp ne i32 %len, 0
  br i1 %length_not_zero, label %weird_loop, label %exit

weird_loop:
  %weird.iv = phi i32 [ 0, %entry ], [ %weird.iv.next, %weird_loop ]
  %weird.iv.next = add i32 %weird.iv, 1
  %weird.iv.wide = zext i32 %weird.iv to i64
  %weird.cond = call i1 @bar()
  br i1 %weird.cond, label %weird_loop, label %loop

loop:
  %iv = phi i32 [ %weird.iv, %weird_loop ], [ %iv.next, %latch ]
  %iv.wide = phi i64 [ %weird.iv.wide, %weird_loop ], [ %iv.wide.next, %latch ]
  %iv.next = add i32 %iv, 1
  %iv.wide.next = add i64 %iv.wide, 1
  %left_ptr = getelementptr inbounds i8, i8* %lhs, i32 %iv
  %right_ptr = getelementptr inbounds i8, i8* %rhs, i32 %iv
  %result = call i1 @foo(i8* %left_ptr, i8* %right_ptr)
  br i1 %result, label %exiting_1, label %exit

exiting_1:
  %iv.wide.is_not_zero = icmp ne i64 %iv.wide, %weird.iv.wide
  br i1 %iv.wide.is_not_zero, label %exiting_2, label %exit

exiting_2:
  %bar_ret = call i1 @bar()
  br i1 %bar_ret, label %exit, label %exiting_3

exiting_3:
  %baz_ret = call i1 @baz()
  br i1 %baz_ret, label %latch, label %exit

latch:
  %continue = icmp ne i32 %iv.next, %len
  br i1 %continue, label %loop, label %exit

exit:
  %val = phi i1 [ %result, %loop ], [ %iv.wide.is_not_zero, %exiting_1 ],
  [ %bar_ret, %exiting_2 ], [ %baz_ret, %exiting_3 ],
  [ %baz_ret, %latch ], [ 0, %entry ]
  ret i1 %val
}
