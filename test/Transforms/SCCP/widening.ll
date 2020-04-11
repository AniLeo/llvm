; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -sccp -S | FileCheck --check-prefix=SCCP %s
; RUN: opt %s -ipsccp -S | FileCheck --check-prefix=IPSCCP %s

; Test different widening scenarios.

declare void @use(i1)
declare i1 @cond()

define void @test_2_incoming_constants(i32 %x) {
; SCCP-LABEL: @test_2_incoming_constants(
; SCCP-NEXT:  entry:
; SCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[EXIT:%.*]]
; SCCP:       bb1:
; SCCP-NEXT:    br label [[EXIT]]
; SCCP:       exit:
; SCCP-NEXT:    [[P:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ 1, [[BB1]] ]
; SCCP-NEXT:    [[A:%.*]] = add i32 [[P]], 1
; SCCP-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 20
; SCCP-NEXT:    call void @use(i1 [[T_1]])
; SCCP-NEXT:    [[F_1:%.*]] = icmp ugt i32 [[A]], 10
; SCCP-NEXT:    call void @use(i1 [[F_1]])
; SCCP-NEXT:    ret void
;
; IPSCCP-LABEL: @test_2_incoming_constants(
; IPSCCP-NEXT:  entry:
; IPSCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[EXIT:%.*]]
; IPSCCP:       bb1:
; IPSCCP-NEXT:    br label [[EXIT]]
; IPSCCP:       exit:
; IPSCCP-NEXT:    [[P:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ 1, [[BB1]] ]
; IPSCCP-NEXT:    [[A:%.*]] = add i32 [[P]], 1
; IPSCCP-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 20
; IPSCCP-NEXT:    call void @use(i1 [[T_1]])
; IPSCCP-NEXT:    [[F_1:%.*]] = icmp ugt i32 [[A]], 10
; IPSCCP-NEXT:    call void @use(i1 [[F_1]])
; IPSCCP-NEXT:    ret void
;
entry:
  %c.1 = call i1 @cond()
  br i1 %c.1, label %bb1, label %exit

bb1:
  br label %exit

exit:
  %p = phi i32 [0, %entry], [1, %bb1]
  %a = add i32 %p, 1
  %t.1 = icmp ult i32 %a, 20
  call void @use(i1 %t.1)
  %f.1 = icmp ugt i32 %a, 10
  call void @use(i1 %f.1)
  ret void
}

define void @test_3_incoming_constants(i32 %x) {
; SCCP-LABEL: @test_3_incoming_constants(
; SCCP-NEXT:  entry:
; SCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[EXIT:%.*]]
; SCCP:       bb1:
; SCCP-NEXT:    [[C_2:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_2]], label [[BB2:%.*]], label [[EXIT]]
; SCCP:       bb2:
; SCCP-NEXT:    br label [[EXIT]]
; SCCP:       exit:
; SCCP-NEXT:    [[P:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ 1, [[BB1]] ], [ 2, [[BB2]] ]
; SCCP-NEXT:    [[A:%.*]] = add i32 [[P]], 1
; SCCP-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 20
; SCCP-NEXT:    call void @use(i1 [[T_1]])
; SCCP-NEXT:    [[F_1:%.*]] = icmp ugt i32 [[A]], 10
; SCCP-NEXT:    call void @use(i1 [[F_1]])
; SCCP-NEXT:    ret void
;
; IPSCCP-LABEL: @test_3_incoming_constants(
; IPSCCP-NEXT:  entry:
; IPSCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[EXIT:%.*]]
; IPSCCP:       bb1:
; IPSCCP-NEXT:    [[C_2:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_2]], label [[BB2:%.*]], label [[EXIT]]
; IPSCCP:       bb2:
; IPSCCP-NEXT:    br label [[EXIT]]
; IPSCCP:       exit:
; IPSCCP-NEXT:    [[P:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ 1, [[BB1]] ], [ 2, [[BB2]] ]
; IPSCCP-NEXT:    [[A:%.*]] = add i32 [[P]], 1
; IPSCCP-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 20
; IPSCCP-NEXT:    call void @use(i1 [[T_1]])
; IPSCCP-NEXT:    [[F_1:%.*]] = icmp ugt i32 [[A]], 10
; IPSCCP-NEXT:    call void @use(i1 [[F_1]])
; IPSCCP-NEXT:    ret void
;
entry:
  %c.1 = call i1 @cond()
  br i1 %c.1, label %bb1, label %exit

bb1:
  %c.2 = call i1 @cond()
  br i1 %c.2, label %bb2, label %exit

bb2:
  br label %exit

exit:
  %p = phi i32 [0, %entry], [1, %bb1], [2, %bb2]
  %a = add i32 %p, 1
  %t.1 = icmp ult i32 %a, 20
  call void @use(i1 %t.1)
  %f.1 = icmp ugt i32 %a, 10
  call void @use(i1 %f.1)
  ret void
}

define void @test_5_incoming_constants(i32 %x) {
; SCCP-LABEL: @test_5_incoming_constants(
; SCCP-NEXT:  entry:
; SCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[EXIT:%.*]]
; SCCP:       bb1:
; SCCP-NEXT:    [[C_2:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_2]], label [[BB2:%.*]], label [[EXIT]]
; SCCP:       bb2:
; SCCP-NEXT:    [[C_3:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_3]], label [[BB3:%.*]], label [[EXIT]]
; SCCP:       bb3:
; SCCP-NEXT:    [[C_4:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_4]], label [[BB4:%.*]], label [[EXIT]]
; SCCP:       bb4:
; SCCP-NEXT:    br label [[EXIT]]
; SCCP:       exit:
; SCCP-NEXT:    [[P:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ 1, [[BB1]] ], [ 2, [[BB2]] ], [ 3, [[BB3]] ], [ 4, [[BB4]] ]
; SCCP-NEXT:    [[A:%.*]] = add i32 [[P]], 1
; SCCP-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 20
; SCCP-NEXT:    call void @use(i1 [[T_1]])
; SCCP-NEXT:    [[F_1:%.*]] = icmp ugt i32 [[A]], 10
; SCCP-NEXT:    call void @use(i1 [[F_1]])
; SCCP-NEXT:    ret void
;
; IPSCCP-LABEL: @test_5_incoming_constants(
; IPSCCP-NEXT:  entry:
; IPSCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_1]], label [[BB1:%.*]], label [[EXIT:%.*]]
; IPSCCP:       bb1:
; IPSCCP-NEXT:    [[C_2:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_2]], label [[BB2:%.*]], label [[EXIT]]
; IPSCCP:       bb2:
; IPSCCP-NEXT:    [[C_3:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_3]], label [[BB3:%.*]], label [[EXIT]]
; IPSCCP:       bb3:
; IPSCCP-NEXT:    [[C_4:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_4]], label [[BB4:%.*]], label [[EXIT]]
; IPSCCP:       bb4:
; IPSCCP-NEXT:    br label [[EXIT]]
; IPSCCP:       exit:
; IPSCCP-NEXT:    [[P:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ 1, [[BB1]] ], [ 2, [[BB2]] ], [ 3, [[BB3]] ], [ 4, [[BB4]] ]
; IPSCCP-NEXT:    [[A:%.*]] = add i32 [[P]], 1
; IPSCCP-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 20
; IPSCCP-NEXT:    call void @use(i1 [[T_1]])
; IPSCCP-NEXT:    [[F_1:%.*]] = icmp ugt i32 [[A]], 10
; IPSCCP-NEXT:    call void @use(i1 [[F_1]])
; IPSCCP-NEXT:    ret void
;
entry:
  %c.1 = call i1 @cond()
  br i1 %c.1, label %bb1, label %exit

bb1:
  %c.2 = call i1 @cond()
  br i1 %c.2, label %bb2, label %exit

bb2:
  %c.3 = call i1 @cond()
  br i1 %c.3, label %bb3, label %exit

bb3:
  %c.4 = call i1 @cond()
  br i1 %c.4, label %bb4, label %exit

bb4:
  br label %exit

exit:
  %p = phi i32 [0, %entry], [1, %bb1], [2, %bb2], [3, %bb3], [4, %bb4]
  %a = add i32 %p, 1
  %t.1 = icmp ult i32 %a, 20
  call void @use(i1 %t.1)
  %f.1 = icmp ugt i32 %a, 10
  call void @use(i1 %f.1)
  ret void
}

; For the rotated_loop_* test cases %p and %a are extended on each iteration.

define void @rotated_loop_2(i32 %x) {
; SCCP-LABEL: @rotated_loop_2(
; SCCP-NEXT:  entry:
; SCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_1]], label [[EXIT:%.*]], label [[BB1:%.*]]
; SCCP:       bb1:
; SCCP-NEXT:    [[C_2:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_2]], label [[EXIT]], label [[BB2:%.*]]
; SCCP:       bb2:
; SCCP-NEXT:    [[C_3:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_3]], label [[BB3:%.*]], label [[EXIT]]
; SCCP:       bb3:
; SCCP-NEXT:    br label [[EXIT]]
; SCCP:       exit:
; SCCP-NEXT:    [[P:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ 3, [[BB1]] ], [ 2, [[BB2]] ], [ 5, [[BB3]] ], [ [[A:%.*]], [[EXIT]] ]
; SCCP-NEXT:    [[A]] = add i32 [[P]], 1
; SCCP-NEXT:    call void @use(i1 true)
; SCCP-NEXT:    call void @use(i1 false)
; SCCP-NEXT:    br i1 false, label [[EXIT]], label [[EXIT_1:%.*]]
; SCCP:       exit.1:
; SCCP-NEXT:    ret void
;
; IPSCCP-LABEL: @rotated_loop_2(
; IPSCCP-NEXT:  entry:
; IPSCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_1]], label [[EXIT:%.*]], label [[BB1:%.*]]
; IPSCCP:       bb1:
; IPSCCP-NEXT:    [[C_2:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_2]], label [[EXIT]], label [[BB2:%.*]]
; IPSCCP:       bb2:
; IPSCCP-NEXT:    [[C_3:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_3]], label [[BB3:%.*]], label [[EXIT]]
; IPSCCP:       bb3:
; IPSCCP-NEXT:    br label [[EXIT]]
; IPSCCP:       exit:
; IPSCCP-NEXT:    [[P:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ 3, [[BB1]] ], [ 2, [[BB2]] ], [ 5, [[BB3]] ], [ [[A:%.*]], [[EXIT]] ]
; IPSCCP-NEXT:    [[A]] = add i32 [[P]], 1
; IPSCCP-NEXT:    call void @use(i1 true)
; IPSCCP-NEXT:    call void @use(i1 false)
; IPSCCP-NEXT:    br i1 false, label [[EXIT]], label [[EXIT_1:%.*]]
; IPSCCP:       exit.1:
; IPSCCP-NEXT:    ret void
;
entry:
  %c.1 = call i1 @cond()
  br i1 %c.1, label %exit, label %bb1

bb1:
  %c.2 = call i1 @cond()
  br i1 %c.2, label %exit, label %bb2

bb2:
  %c.3 = call i1 @cond()
  br i1 %c.3, label %bb3, label %exit

bb3:
  br label %exit

exit:
  %p = phi i32 [1, %entry], [3, %bb1], [2, %bb2], [5, %bb3], [%a, %exit]
  %a = add i32 %p, 1
  %t.1 = icmp ult i32 %a, 20
  call void @use(i1 %t.1)
  %f.1 = icmp ugt i32 %a, 10
  call void @use(i1 %f.1)
  %c.4 = icmp ult i32 %a, 2
  br i1 %c.4, label %exit, label %exit.1

exit.1:
  ret void
}

define void @rotated_loop_3(i32 %x) {
; SCCP-LABEL: @rotated_loop_3(
; SCCP-NEXT:  entry:
; SCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_1]], label [[EXIT:%.*]], label [[BB1:%.*]]
; SCCP:       bb1:
; SCCP-NEXT:    [[C_2:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_2]], label [[EXIT]], label [[BB2:%.*]]
; SCCP:       bb2:
; SCCP-NEXT:    [[C_3:%.*]] = call i1 @cond()
; SCCP-NEXT:    br i1 [[C_3]], label [[BB3:%.*]], label [[EXIT]]
; SCCP:       bb3:
; SCCP-NEXT:    br label [[EXIT]]
; SCCP:       exit:
; SCCP-NEXT:    [[P:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ 3, [[BB1]] ], [ 2, [[BB2]] ], [ 5, [[BB3]] ], [ [[A:%.*]], [[EXIT]] ]
; SCCP-NEXT:    [[A]] = add i32 [[P]], 1
; SCCP-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 20
; SCCP-NEXT:    call void @use(i1 [[T_1]])
; SCCP-NEXT:    [[F_1:%.*]] = icmp ugt i32 [[A]], 10
; SCCP-NEXT:    call void @use(i1 [[F_1]])
; SCCP-NEXT:    [[C_4:%.*]] = icmp ult i32 [[A]], 3
; SCCP-NEXT:    br i1 [[C_4]], label [[EXIT]], label [[EXIT_1:%.*]]
; SCCP:       exit.1:
; SCCP-NEXT:    ret void
;
; IPSCCP-LABEL: @rotated_loop_3(
; IPSCCP-NEXT:  entry:
; IPSCCP-NEXT:    [[C_1:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_1]], label [[EXIT:%.*]], label [[BB1:%.*]]
; IPSCCP:       bb1:
; IPSCCP-NEXT:    [[C_2:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_2]], label [[EXIT]], label [[BB2:%.*]]
; IPSCCP:       bb2:
; IPSCCP-NEXT:    [[C_3:%.*]] = call i1 @cond()
; IPSCCP-NEXT:    br i1 [[C_3]], label [[BB3:%.*]], label [[EXIT]]
; IPSCCP:       bb3:
; IPSCCP-NEXT:    br label [[EXIT]]
; IPSCCP:       exit:
; IPSCCP-NEXT:    [[P:%.*]] = phi i32 [ 1, [[ENTRY:%.*]] ], [ 3, [[BB1]] ], [ 2, [[BB2]] ], [ 5, [[BB3]] ], [ [[A:%.*]], [[EXIT]] ]
; IPSCCP-NEXT:    [[A]] = add i32 [[P]], 1
; IPSCCP-NEXT:    [[T_1:%.*]] = icmp ult i32 [[A]], 20
; IPSCCP-NEXT:    call void @use(i1 [[T_1]])
; IPSCCP-NEXT:    [[F_1:%.*]] = icmp ugt i32 [[A]], 10
; IPSCCP-NEXT:    call void @use(i1 [[F_1]])
; IPSCCP-NEXT:    [[C_4:%.*]] = icmp ult i32 [[A]], 3
; IPSCCP-NEXT:    br i1 [[C_4]], label [[EXIT]], label [[EXIT_1:%.*]]
; IPSCCP:       exit.1:
; IPSCCP-NEXT:    ret void
;
entry:
  %c.1 = call i1 @cond()
  br i1 %c.1, label %exit, label %bb1

bb1:
  %c.2 = call i1 @cond()
  br i1 %c.2, label %exit, label %bb2

bb2:
  %c.3 = call i1 @cond()
  br i1 %c.3, label %bb3, label %exit

bb3:
  br label %exit

exit:
  %p = phi i32 [1, %entry], [3, %bb1], [2, %bb2], [5, %bb3], [%a, %exit]
  %a = add i32 %p, 1
  %t.1 = icmp ult i32 %a, 20
  call void @use(i1 %t.1)
  %f.1 = icmp ugt i32 %a, 10
  call void @use(i1 %f.1)
  %c.4 = icmp ult i32 %a, 3
  br i1 %c.4, label %exit, label %exit.1

exit.1:
  ret void
}

; For the loop_with_header_* tests, %iv and %a change on each iteration, but we
; can use the range imposed by the condition %c.1 when widening.
define void @loop_with_header_1(i32 %x) {
; SCCP-LABEL: @loop_with_header_1(
; SCCP-NEXT:  entry:
; SCCP-NEXT:    br label [[LOOP_HEADER:%.*]]
; SCCP:       loop.header:
; SCCP-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_BODY:%.*]] ]
; SCCP-NEXT:    [[C_1:%.*]] = icmp slt i32 [[IV]], 2
; SCCP-NEXT:    br i1 [[C_1]], label [[LOOP_BODY]], label [[EXIT:%.*]]
; SCCP:       loop.body:
; SCCP-NEXT:    [[T_1:%.*]] = icmp slt i32 [[IV]], 2
; SCCP-NEXT:    call void @use(i1 [[T_1]])
; SCCP-NEXT:    [[IV_NEXT]] = add nsw i32 [[IV]], 1
; SCCP-NEXT:    br label [[LOOP_HEADER]]
; SCCP:       exit:
; SCCP-NEXT:    ret void
;
; IPSCCP-LABEL: @loop_with_header_1(
; IPSCCP-NEXT:  entry:
; IPSCCP-NEXT:    br label [[LOOP_HEADER:%.*]]
; IPSCCP:       loop.header:
; IPSCCP-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_BODY:%.*]] ]
; IPSCCP-NEXT:    [[C_1:%.*]] = icmp slt i32 [[IV]], 2
; IPSCCP-NEXT:    br i1 [[C_1]], label [[LOOP_BODY]], label [[EXIT:%.*]]
; IPSCCP:       loop.body:
; IPSCCP-NEXT:    [[T_1:%.*]] = icmp slt i32 [[IV]], 2
; IPSCCP-NEXT:    call void @use(i1 [[T_1]])
; IPSCCP-NEXT:    [[IV_NEXT]] = add nsw i32 [[IV]], 1
; IPSCCP-NEXT:    br label [[LOOP_HEADER]]
; IPSCCP:       exit:
; IPSCCP-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i32 [0, %entry], [%iv.next, %loop.body]
  %c.1 = icmp slt i32 %iv, 2
  br i1 %c.1, label %loop.body, label %exit

loop.body:
  %t.1 = icmp slt i32 %iv, 2
  call void @use(i1 %t.1)
  %iv.next = add nsw i32 %iv, 1
  br label %loop.header

exit:
  ret void
}

define void @loop_with_header_2(i32 %x) {
; SCCP-LABEL: @loop_with_header_2(
; SCCP-NEXT:  entry:
; SCCP-NEXT:    br label [[LOOP_HEADER:%.*]]
; SCCP:       loop.header:
; SCCP-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_BODY:%.*]] ]
; SCCP-NEXT:    [[C_1:%.*]] = icmp slt i32 [[IV]], 200
; SCCP-NEXT:    br i1 [[C_1]], label [[LOOP_BODY]], label [[EXIT:%.*]]
; SCCP:       loop.body:
; SCCP-NEXT:    [[T_1:%.*]] = icmp slt i32 [[IV]], 200
; SCCP-NEXT:    call void @use(i1 [[T_1]])
; SCCP-NEXT:    [[IV_NEXT]] = add nsw i32 [[IV]], 1
; SCCP-NEXT:    br label [[LOOP_HEADER]]
; SCCP:       exit:
; SCCP-NEXT:    ret void
;
; IPSCCP-LABEL: @loop_with_header_2(
; IPSCCP-NEXT:  entry:
; IPSCCP-NEXT:    br label [[LOOP_HEADER:%.*]]
; IPSCCP:       loop.header:
; IPSCCP-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP_BODY:%.*]] ]
; IPSCCP-NEXT:    [[C_1:%.*]] = icmp slt i32 [[IV]], 200
; IPSCCP-NEXT:    br i1 [[C_1]], label [[LOOP_BODY]], label [[EXIT:%.*]]
; IPSCCP:       loop.body:
; IPSCCP-NEXT:    [[T_1:%.*]] = icmp slt i32 [[IV]], 200
; IPSCCP-NEXT:    call void @use(i1 [[T_1]])
; IPSCCP-NEXT:    [[IV_NEXT]] = add nsw i32 [[IV]], 1
; IPSCCP-NEXT:    br label [[LOOP_HEADER]]
; IPSCCP:       exit:
; IPSCCP-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i32 [0, %entry], [%iv.next, %loop.body]
  %c.1 = icmp slt i32 %iv, 200
  br i1 %c.1, label %loop.body, label %exit

loop.body:
  %t.1 = icmp slt i32 %iv, 200
  call void @use(i1 %t.1)
  %iv.next = add nsw i32 %iv, 1
  br label %loop.header

exit:
  ret void
}
