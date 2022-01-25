; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S < %s -indvars | FileCheck %s
; RUN: opt -S < %s -passes=indvars | FileCheck %s

declare i1 @cond()
declare void @exit(i32 %code)

define void @test_01(i32* %p, i32 %shift) {
; CHECK-LABEL: @test_01(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4, !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[X_SHIFTED:%.*]] = lshr i32 [[X]], [[SHIFT:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[LESS_THAN_SHIFTED:%.*]] = icmp slt i32 [[IV]], [[X_SHIFTED]]
; CHECK-NEXT:    br i1 [[LESS_THAN_SHIFTED]], label [[GUARDED:%.*]], label [[FAILURE:%.*]]
; CHECK:       guarded:
; CHECK-NEXT:    br i1 true, label [[BACKEDGE]], label [[NEVER_HAPPENS:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    ret void
; CHECK:       failure:
; CHECK-NEXT:    call void @exit(i32 1)
; CHECK-NEXT:    unreachable
; CHECK:       never_happens:
; CHECK-NEXT:    call void @exit(i32 0)
; CHECK-NEXT:    unreachable
;
entry:
  %x = load i32, i32* %p, !range !0
  %x.shifted = lshr i32 %x, %shift
  br label %loop

loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  %less.than.shifted = icmp slt i32 %iv, %x.shifted
  br i1 %less.than.shifted, label %guarded, label %failure

guarded:
  %less.than.x = icmp slt i32 %iv, %x
  br i1 %less.than.x, label %backedge, label %never_happens

backedge:
  %iv.next = add nuw nsw i32 %iv, 1
  %loop.cond = call i1 @cond()
  br i1 %loop.cond, label %loop, label %done

done:
  ret void

failure:
  call void @exit(i32 1)
  unreachable

never_happens:
  call void @exit(i32 0)
  unreachable
}

define void @test_02(i32* %p, i32 %shift) {
; CHECK-LABEL: @test_02(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4, !range [[RNG0]]
; CHECK-NEXT:    [[X_SHIFTED:%.*]] = lshr i32 [[X]], [[SHIFT:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[LESS_THAN_SHIFTED:%.*]] = icmp sgt i32 [[X_SHIFTED]], [[IV]]
; CHECK-NEXT:    br i1 [[LESS_THAN_SHIFTED]], label [[GUARDED:%.*]], label [[FAILURE:%.*]]
; CHECK:       guarded:
; CHECK-NEXT:    br i1 true, label [[BACKEDGE]], label [[NEVER_HAPPENS:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    ret void
; CHECK:       failure:
; CHECK-NEXT:    call void @exit(i32 1)
; CHECK-NEXT:    unreachable
; CHECK:       never_happens:
; CHECK-NEXT:    call void @exit(i32 0)
; CHECK-NEXT:    unreachable
;
entry:
  %x = load i32, i32* %p, !range !0
  %x.shifted = lshr i32 %x, %shift
  br label %loop

loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  %less.than.shifted = icmp sgt i32 %x.shifted, %iv
  br i1 %less.than.shifted, label %guarded, label %failure

guarded:
  %less.than.x = icmp sgt i32 %x, %iv
  br i1 %less.than.x, label %backedge, label %never_happens

backedge:
  %iv.next = add nuw nsw i32 %iv, 1
  %loop.cond = call i1 @cond()
  br i1 %loop.cond, label %loop, label %done

done:
  ret void

failure:
  call void @exit(i32 1)
  unreachable

never_happens:
  call void @exit(i32 0)
  unreachable
}

define void @test_03(i32* %p, i32 %shift) {
; CHECK-LABEL: @test_03(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4, !range [[RNG0]]
; CHECK-NEXT:    [[X_SHIFTED:%.*]] = lshr i32 [[X]], [[SHIFT:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[LESS_THAN_SHIFTED:%.*]] = icmp ult i32 [[IV]], [[X_SHIFTED]]
; CHECK-NEXT:    br i1 [[LESS_THAN_SHIFTED]], label [[GUARDED:%.*]], label [[FAILURE:%.*]]
; CHECK:       guarded:
; CHECK-NEXT:    br i1 true, label [[BACKEDGE]], label [[NEVER_HAPPENS:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    ret void
; CHECK:       failure:
; CHECK-NEXT:    call void @exit(i32 1)
; CHECK-NEXT:    unreachable
; CHECK:       never_happens:
; CHECK-NEXT:    call void @exit(i32 0)
; CHECK-NEXT:    unreachable
;
entry:
  %x = load i32, i32* %p, !range !0
  %x.shifted = lshr i32 %x, %shift
  br label %loop

loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  %less.than.shifted = icmp ult i32 %iv, %x.shifted
  br i1 %less.than.shifted, label %guarded, label %failure

guarded:
  %less.than.x = icmp ult i32 %iv, %x
  br i1 %less.than.x, label %backedge, label %never_happens

backedge:
  %iv.next = add nuw nsw i32 %iv, 1
  %loop.cond = call i1 @cond()
  br i1 %loop.cond, label %loop, label %done

done:
  ret void

failure:
  call void @exit(i32 1)
  unreachable

never_happens:
  call void @exit(i32 0)
  unreachable
}

define void @test_04(i32* %p, i32 %shift) {
; CHECK-LABEL: @test_04(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[P:%.*]], align 4, !range [[RNG0]]
; CHECK-NEXT:    [[X_SHIFTED:%.*]] = lshr i32 [[X]], [[SHIFT:%.*]]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[LESS_THAN_SHIFTED:%.*]] = icmp ugt i32 [[X_SHIFTED]], [[IV]]
; CHECK-NEXT:    br i1 [[LESS_THAN_SHIFTED]], label [[GUARDED:%.*]], label [[FAILURE:%.*]]
; CHECK:       guarded:
; CHECK-NEXT:    br i1 true, label [[BACKEDGE]], label [[NEVER_HAPPENS:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = call i1 @cond()
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[DONE:%.*]]
; CHECK:       done:
; CHECK-NEXT:    ret void
; CHECK:       failure:
; CHECK-NEXT:    call void @exit(i32 1)
; CHECK-NEXT:    unreachable
; CHECK:       never_happens:
; CHECK-NEXT:    call void @exit(i32 0)
; CHECK-NEXT:    unreachable
;
entry:
  %x = load i32, i32* %p, !range !0
  %x.shifted = lshr i32 %x, %shift
  br label %loop

loop:
  %iv = phi i32 [0, %entry], [%iv.next, %backedge]
  %less.than.shifted = icmp ugt i32 %x.shifted, %iv
  br i1 %less.than.shifted, label %guarded, label %failure

guarded:
  %less.than.x = icmp ugt i32 %x, %iv
  br i1 %less.than.x, label %backedge, label %never_happens

backedge:
  %iv.next = add nuw nsw i32 %iv, 1
  %loop.cond = call i1 @cond()
  br i1 %loop.cond, label %loop, label %done

done:
  ret void

failure:
  call void @exit(i32 1)
  unreachable

never_happens:
  call void @exit(i32 0)
  unreachable
}

!0 = !{i32 0, i32 2147483647}
