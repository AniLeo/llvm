; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -print-predicateinfo -disable-output < %s 2>&1 | FileCheck %s

declare void @foo(i1)
declare void @bar(i32)
declare void @llvm.assume(i1)

define void @test_or(i32 %x, i32 %y) {
; CHECK-LABEL: @test_or(
; CHECK-NEXT:    [[XZ:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[YZ:%.*]] = icmp eq i32 [[Y:%.*]], 0
; CHECK-NEXT:    [[Z:%.*]] = or i1 [[XZ]], [[YZ]]
; CHECK:         [[Z_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[Z]])
; CHECK:         [[XZ_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[XZ]])
; CHECK:         [[X_0:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[X]])
; CHECK:         [[YZ_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[YZ]])
; CHECK:         [[Y_0:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[Y]])
; CHECK-NEXT:    br i1 [[Z]], label [[ONEOF:%.*]], label [[NEITHER:%.*]]
; CHECK:       oneof:
; CHECK-NEXT:    call void @foo(i1 [[XZ]])
; CHECK-NEXT:    call void @foo(i1 [[YZ]])
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    call void @bar(i32 [[Y]])
; CHECK-NEXT:    ret void
; CHECK:       neither:
; CHECK-NEXT:    call void @foo(i1 [[XZ_0]])
; CHECK-NEXT:    call void @foo(i1 [[YZ_0]])
; CHECK-NEXT:    call void @bar(i32 [[X_0]])
; CHECK-NEXT:    call void @bar(i32 [[Y_0]])
; CHECK-NEXT:    call void @foo(i1 [[Z_0]])
; CHECK-NEXT:    ret void
;
  %xz = icmp eq i32 %x, 0
  %yz = icmp eq i32 %y, 0
  %z = or i1 %xz, %yz
  br i1 %z, label %oneof, label %neither
oneof:
;; Should not insert on the true edge for or
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  ret void
neither:
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  call void @foo(i1 %z)
  ret void
}

define void @test_or_logical(i32 %x, i32 %y) {
; CHECK-LABEL: @test_or_logical(
; CHECK-NEXT:    [[XZ:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[YZ:%.*]] = icmp eq i32 [[Y:%.*]], 0
; CHECK-NEXT:    [[Z:%.*]] = select i1 [[XZ]], i1 true, i1 [[YZ]]
; CHECK:         [[Z_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[Z]])
; CHECK-NEXT:    br i1 [[Z]], label [[ONEOF:%.*]], label [[NEITHER:%.*]]
; CHECK:       oneof:
; CHECK-NEXT:    call void @foo(i1 [[XZ]])
; CHECK-NEXT:    call void @foo(i1 [[YZ]])
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    call void @bar(i32 [[Y]])
; CHECK-NEXT:    ret void
; CHECK:       neither:
; CHECK-NEXT:    call void @foo(i1 [[XZ]])
; CHECK-NEXT:    call void @foo(i1 [[YZ]])
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    call void @bar(i32 [[Y]])
; CHECK-NEXT:    call void @foo(i1 [[Z_0]])
; CHECK-NEXT:    ret void
;
  %xz = icmp eq i32 %x, 0
  %yz = icmp eq i32 %y, 0
  %z = select i1 %xz, i1 true, i1 %yz
  br i1 %z, label %oneof, label %neither
oneof:
;; Should not insert on the true edge for or
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  ret void
neither:
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  call void @foo(i1 %z)
  ret void
}

define void @test_and(i32 %x, i32 %y) {
; CHECK-LABEL: @test_and(
; CHECK-NEXT:    [[XZ:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[YZ:%.*]] = icmp eq i32 [[Y:%.*]], 0
; CHECK-NEXT:    [[Z:%.*]] = and i1 [[XZ]], [[YZ]]
; CHECK:         [[Z_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[Z]])
; CHECK:         [[XZ_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[XZ]])
; CHECK:         [[X_0:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[X]])
; CHECK:         [[YZ_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[YZ]])
; CHECK:         [[Y_0:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[Y]])
; CHECK-NEXT:    br i1 [[Z]], label [[BOTH:%.*]], label [[NOPE:%.*]]
; CHECK:       both:
; CHECK-NEXT:    call void @foo(i1 [[XZ_0]])
; CHECK-NEXT:    call void @foo(i1 [[YZ_0]])
; CHECK-NEXT:    call void @bar(i32 [[X_0]])
; CHECK-NEXT:    call void @bar(i32 [[Y_0]])
; CHECK-NEXT:    ret void
; CHECK:       nope:
; CHECK-NEXT:    call void @foo(i1 [[XZ]])
; CHECK-NEXT:    call void @foo(i1 [[YZ]])
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    call void @bar(i32 [[Y]])
; CHECK-NEXT:    call void @foo(i1 [[Z_0]])
; CHECK-NEXT:    ret void
;
  %xz = icmp eq i32 %x, 0
  %yz = icmp eq i32 %y, 0
  %z = and i1 %xz, %yz
  br i1 %z, label %both, label %nope
both:
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  ret void
nope:
;; Should not insert on the false edge for and
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  call void @foo(i1 %z)
  ret void
}

define void @test_and_logical(i32 %x, i32 %y) {
; CHECK-LABEL: @test_and_logical(
; CHECK-NEXT:    [[XZ:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[YZ:%.*]] = icmp eq i32 [[Y:%.*]], 0
; CHECK-NEXT:    [[Z:%.*]] = select i1 [[XZ]], i1 [[YZ]], i1 false
; CHECK:         [[Z_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[Z]])
; CHECK-NEXT:    br i1 [[Z]], label [[BOTH:%.*]], label [[NOPE:%.*]]
; CHECK:       both:
; CHECK-NEXT:    call void @foo(i1 [[XZ]])
; CHECK-NEXT:    call void @foo(i1 [[YZ]])
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    call void @bar(i32 [[Y]])
; CHECK-NEXT:    ret void
; CHECK:       nope:
; CHECK-NEXT:    call void @foo(i1 [[XZ]])
; CHECK-NEXT:    call void @foo(i1 [[YZ]])
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    call void @bar(i32 [[Y]])
; CHECK-NEXT:    call void @foo(i1 [[Z_0]])
; CHECK-NEXT:    ret void
;
  %xz = icmp eq i32 %x, 0
  %yz = icmp eq i32 %y, 0
  %z = select i1 %xz, i1 %yz, i1 false
  br i1 %z, label %both, label %nope
both:
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  ret void
nope:
;; Should not insert on the false edge for and
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  call void @foo(i1 %z)
  ret void
}

define void @testandsame(i32 %x, i32 %y) {
; CHECK-LABEL: @testandsame(
; CHECK-NEXT:    [[XGT:%.*]] = icmp sgt i32 [[X:%.*]], 0
; CHECK-NEXT:    [[XLT:%.*]] = icmp slt i32 [[X]], 100
; CHECK-NEXT:    [[Z:%.*]] = and i1 [[XGT]], [[XLT]]
; CHECK:         [[Z_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[Z]])
; CHECK:         [[XGT_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[XGT]])
; CHECK:         [[X_0:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[X]])
; CHECK:         [[X_0_1:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[X_0]])
; CHECK:         [[XLT_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[XLT]])
; CHECK-NEXT:    br i1 [[Z]], label [[BOTH:%.*]], label [[NOPE:%.*]]
; CHECK:       both:
; CHECK-NEXT:    call void @foo(i1 [[XGT_0]])
; CHECK-NEXT:    call void @foo(i1 [[XLT_0]])
; CHECK-NEXT:    call void @bar(i32 [[X_0_1]])
; CHECK-NEXT:    ret void
; CHECK:       nope:
; CHECK-NEXT:    call void @foo(i1 [[XGT]])
; CHECK-NEXT:    call void @foo(i1 [[XLT]])
; CHECK-NEXT:    call void @foo(i1 [[Z_0]])
; CHECK-NEXT:    ret void
;
  %xgt = icmp sgt i32 %x, 0
  %xlt = icmp slt i32 %x, 100
  %z = and i1 %xgt, %xlt
  br i1 %z, label %both, label %nope
both:
  call void @foo(i1 %xgt)
  call void @foo(i1 %xlt)
  call void @bar(i32 %x)
  ret void
nope:
  call void @foo(i1 %xgt)
  call void @foo(i1 %xlt)
  call void @foo(i1 %z)
  ret void
}

define void @testandassume(i32 %x, i32 %y) {
; CHECK-LABEL: @testandassume(
; CHECK-NEXT:    [[XZ:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[YZ:%.*]] = icmp eq i32 [[Y:%.*]], 0
; CHECK-NEXT:    [[Z:%.*]] = and i1 [[XZ]], [[YZ]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[Z]])
; CHECK:         [[TMP1:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[Y]])
; CHECK:         [[TMP2:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[YZ]])
; CHECK:         [[TMP3:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[X]])
; CHECK:         [[TMP4:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[XZ]])
; CHECK:         [[TMP5:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[Z]])
; CHECK:         [[DOT0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[TMP5]])
; CHECK:         [[DOT01:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[TMP4]])
; CHECK:         [[DOT02:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[TMP3]])
; CHECK:         [[DOT03:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[TMP2]])
; CHECK:         [[DOT04:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[TMP1]])
; CHECK-NEXT:    br i1 [[TMP5]], label [[BOTH:%.*]], label [[NOPE:%.*]]
; CHECK:       both:
; CHECK-NEXT:    call void @foo(i1 [[DOT01]])
; CHECK-NEXT:    call void @foo(i1 [[DOT03]])
; CHECK-NEXT:    call void @bar(i32 [[DOT02]])
; CHECK-NEXT:    call void @bar(i32 [[DOT04]])
; CHECK-NEXT:    ret void
; CHECK:       nope:
; CHECK-NEXT:    call void @foo(i1 [[DOT0]])
; CHECK-NEXT:    ret void
;
  %xz = icmp eq i32 %x, 0
  %yz = icmp eq i32 %y, 0
  %z = and i1 %xz, %yz
  call void @llvm.assume(i1 %z)
  br i1 %z, label %both, label %nope
both:
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  ret void
nope:
  call void @foo(i1 %z)
  ret void
}

;; Unlike and/or for branches, assume is *always* true, so we only match and for it
define void @testorassume(i32 %x, i32 %y) {
;
; CHECK-LABEL: @testorassume(
; CHECK-NEXT:    [[XZ:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[YZ:%.*]] = icmp eq i32 [[Y:%.*]], 0
; CHECK-NEXT:    [[Z:%.*]] = or i1 [[XZ]], [[YZ]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[Z]])
; CHECK:         [[TMP1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[Z]])
; CHECK:         [[DOT0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[TMP1]])
; CHECK-NEXT:    br i1 [[TMP1]], label [[BOTH:%.*]], label [[NOPE:%.*]]
; CHECK:       both:
; CHECK-NEXT:    call void @foo(i1 [[XZ]])
; CHECK-NEXT:    call void @foo(i1 [[YZ]])
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    call void @bar(i32 [[Y]])
; CHECK-NEXT:    ret void
; CHECK:       nope:
; CHECK-NEXT:    call void @foo(i1 [[DOT0]])
; CHECK-NEXT:    ret void
;
  %xz = icmp eq i32 %x, 0
  %yz = icmp eq i32 %y, 0
  %z = or i1 %xz, %yz
  call void @llvm.assume(i1 %z)
  br i1 %z, label %both, label %nope
both:
  call void @foo(i1 %xz)
  call void @foo(i1 %yz)
  call void @bar(i32 %x)
  call void @bar(i32 %y)
  ret void
nope:
  call void @foo(i1 %z)
  ret void
}

define void @test_and_one_unknown_cond(i32 %x, i1 %c1) {
; CHECK-LABEL: @test_and_one_unknown_cond(
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[A:%.*]] = and i1 [[C1:%.*]], [[C2]]
; CHECK:         [[A_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A]])
; CHECK:         [[A_1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A]])
; CHECK:         [[C1_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[C1]])
; CHECK:         [[C2_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[C2]])
; CHECK:         [[X_0:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[X]])
; CHECK-NEXT:    br i1 [[A]], label [[BOTH:%.*]], label [[NOPE:%.*]]
; CHECK:       both:
; CHECK-NEXT:    call void @bar(i32 [[X_0]])
; CHECK-NEXT:    call void @foo(i1 [[C1_0]])
; CHECK-NEXT:    call void @foo(i1 [[C2_0]])
; CHECK-NEXT:    call void @foo(i1 [[A_0]])
; CHECK-NEXT:    ret void
; CHECK:       nope:
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    call void @foo(i1 [[C1]])
; CHECK-NEXT:    call void @foo(i1 [[C2]])
; CHECK-NEXT:    call void @foo(i1 [[A_1]])
; CHECK-NEXT:    ret void
;
  %c2 = icmp eq i32 %x, 0
  %a = and i1 %c1, %c2
  br i1 %a, label %both, label %nope

both:
  call void @bar(i32 %x)
  call void @foo(i1 %c1)
  call void @foo(i1 %c2)
  call void @foo(i1 %a)
  ret void

nope:
  call void @bar(i32 %x)
  call void @foo(i1 %c1)
  call void @foo(i1 %c2)
  call void @foo(i1 %a)
  ret void
}

define void @test_or_one_unknown_cond(i32 %x, i1 %c1) {
; CHECK-LABEL: @test_or_one_unknown_cond(
; CHECK-NEXT:    [[C2:%.*]] = icmp eq i32 [[X:%.*]], 0
; CHECK-NEXT:    [[A:%.*]] = or i1 [[C1:%.*]], [[C2]]
; CHECK:         [[A_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A]])
; CHECK:         [[A_1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A]])
; CHECK:         [[C1_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[C1]])
; CHECK:         [[C2_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[C2]])
; CHECK:         [[X_0:%.*]] = call i32 @llvm.ssa.copy.{{.+}}(i32 [[X]])
; CHECK-NEXT:    br i1 [[A]], label [[NOPE:%.*]], label [[BOTH_INVERTED:%.*]]
; CHECK:       both_inverted:
; CHECK-NEXT:    call void @bar(i32 [[X_0]])
; CHECK-NEXT:    call void @foo(i1 [[C1_0]])
; CHECK-NEXT:    call void @foo(i1 [[C2_0]])
; CHECK-NEXT:    call void @foo(i1 [[A_1]])
; CHECK-NEXT:    ret void
; CHECK:       nope:
; CHECK-NEXT:    call void @bar(i32 [[X]])
; CHECK-NEXT:    call void @foo(i1 [[C1]])
; CHECK-NEXT:    call void @foo(i1 [[C2]])
; CHECK-NEXT:    call void @foo(i1 [[A_0]])
; CHECK-NEXT:    ret void
;
  %c2 = icmp eq i32 %x, 0
  %a = or i1 %c1, %c2
  br i1 %a, label %nope, label %both_inverted

both_inverted:
  call void @bar(i32 %x)
  call void @foo(i1 %c1)
  call void @foo(i1 %c2)
  call void @foo(i1 %a)
  ret void

nope:
  call void @bar(i32 %x)
  call void @foo(i1 %c1)
  call void @foo(i1 %c2)
  call void @foo(i1 %a)
  ret void
}

define void @test_and_chain(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @test_and_chain(
; CHECK-NEXT:    [[AND1:%.*]] = and i1 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND2:%.*]] = and i1 [[AND1]], [[C:%.*]]
; CHECK:         [[AND2_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[AND2]])
; CHECK:         [[AND2_1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[AND2]])
; CHECK:         [[AND1_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[AND1]])
; CHECK:         [[A_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A]])
; CHECK:         [[B_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[B]])
; CHECK:         [[C_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[C]])
; CHECK-NEXT:    br i1 [[AND2]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo(i1 [[A_0]])
; CHECK-NEXT:    call void @foo(i1 [[B_0]])
; CHECK-NEXT:    call void @foo(i1 [[C_0]])
; CHECK-NEXT:    call void @foo(i1 [[AND1_0]])
; CHECK-NEXT:    call void @foo(i1 [[AND2_0]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    call void @foo(i1 [[A]])
; CHECK-NEXT:    call void @foo(i1 [[B]])
; CHECK-NEXT:    call void @foo(i1 [[C]])
; CHECK-NEXT:    call void @foo(i1 [[AND1]])
; CHECK-NEXT:    call void @foo(i1 [[AND2_1]])
; CHECK-NEXT:    ret void
;
  %and1 = and i1 %a, %b
  %and2 = and i1 %and1, %c
  br i1 %and2, label %if, label %else

if:
  call void @foo(i1 %a)
  call void @foo(i1 %b)
  call void @foo(i1 %c)
  call void @foo(i1 %and1)
  call void @foo(i1 %and2)
  ret void

else:
  call void @foo(i1 %a)
  call void @foo(i1 %b)
  call void @foo(i1 %c)
  call void @foo(i1 %and1)
  call void @foo(i1 %and2)
  ret void
}

define void @test_or_chain(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @test_or_chain(
; CHECK-NEXT:    [[OR1:%.*]] = or i1 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i1 [[OR1]], [[C:%.*]]
; CHECK:         [[OR2_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[OR2]])
; CHECK:         [[OR2_1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[OR2]])
; CHECK:         [[OR1_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[OR1]])
; CHECK:         [[A_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A]])
; CHECK:         [[B_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[B]])
; CHECK:         [[C_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[C]])
; CHECK-NEXT:    br i1 [[OR2]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo(i1 [[A]])
; CHECK-NEXT:    call void @foo(i1 [[B]])
; CHECK-NEXT:    call void @foo(i1 [[C]])
; CHECK-NEXT:    call void @foo(i1 [[OR1]])
; CHECK-NEXT:    call void @foo(i1 [[OR2_0]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    call void @foo(i1 [[A_0]])
; CHECK-NEXT:    call void @foo(i1 [[B_0]])
; CHECK-NEXT:    call void @foo(i1 [[C_0]])
; CHECK-NEXT:    call void @foo(i1 [[OR1_0]])
; CHECK-NEXT:    call void @foo(i1 [[OR2_1]])
; CHECK-NEXT:    ret void
;
  %or1 = or i1 %a, %b
  %or2 = or i1 %or1, %c
  br i1 %or2, label %if, label %else

if:
  call void @foo(i1 %a)
  call void @foo(i1 %b)
  call void @foo(i1 %c)
  call void @foo(i1 %or1)
  call void @foo(i1 %or2)
  ret void

else:
  call void @foo(i1 %a)
  call void @foo(i1 %b)
  call void @foo(i1 %c)
  call void @foo(i1 %or1)
  call void @foo(i1 %or2)
  ret void
}

define void @test_and_or_mixed(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @test_and_or_mixed(
; CHECK-NEXT:    [[OR:%.*]] = or i1 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND:%.*]] = and i1 [[OR]], [[C:%.*]]
; CHECK:         [[AND_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[AND]])
; CHECK:         [[AND_1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[AND]])
; CHECK:         [[OR_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[OR]])
; CHECK:         [[C_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[C]])
; CHECK-NEXT:    br i1 [[AND]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo(i1 [[A]])
; CHECK-NEXT:    call void @foo(i1 [[B]])
; CHECK-NEXT:    call void @foo(i1 [[C_0]])
; CHECK-NEXT:    call void @foo(i1 [[OR_0]])
; CHECK-NEXT:    call void @foo(i1 [[AND_0]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    call void @foo(i1 [[A]])
; CHECK-NEXT:    call void @foo(i1 [[B]])
; CHECK-NEXT:    call void @foo(i1 [[C]])
; CHECK-NEXT:    call void @foo(i1 [[OR]])
; CHECK-NEXT:    call void @foo(i1 [[AND_1]])
; CHECK-NEXT:    ret void
;
  %or = or i1 %a, %b
  %and = and i1 %or, %c
  br i1 %and, label %if, label %else

if:
  call void @foo(i1 %a)
  call void @foo(i1 %b)
  call void @foo(i1 %c)
  call void @foo(i1 %or)
  call void @foo(i1 %and)
  ret void

else:
  call void @foo(i1 %a)
  call void @foo(i1 %b)
  call void @foo(i1 %c)
  call void @foo(i1 %or)
  call void @foo(i1 %and)
  ret void
}

define void @test_deep_and_chain(i1 %a1) {
; CHECK-LABEL: @test_deep_and_chain(
; CHECK-NEXT:    [[A2:%.*]] = and i1 [[A1:%.*]], true
; CHECK-NEXT:    [[A3:%.*]] = and i1 [[A2]], true
; CHECK-NEXT:    [[A4:%.*]] = and i1 [[A3]], true
; CHECK-NEXT:    [[A5:%.*]] = and i1 [[A4]], true
; CHECK-NEXT:    [[A6:%.*]] = and i1 [[A5]], true
; CHECK-NEXT:    [[A7:%.*]] = and i1 [[A6]], true
; CHECK-NEXT:    [[A8:%.*]] = and i1 [[A7]], true
; CHECK-NEXT:    [[A9:%.*]] = and i1 [[A8]], true
; CHECK-NEXT:    [[A10:%.*]] = and i1 [[A9]], true
; CHECK-NEXT:    [[A11:%.*]] = and i1 [[A10]], true
; CHECK-NEXT:    [[A12:%.*]] = and i1 [[A11]], true
; CHECK-NEXT:    [[A13:%.*]] = and i1 [[A12]], true
; CHECK-NEXT:    [[A14:%.*]] = and i1 [[A13]], true
; CHECK-NEXT:    [[A15:%.*]] = and i1 [[A14]], true
; CHECK:         [[A15_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A15]])
; CHECK:         [[A15_1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A15]])
; CHECK:         [[A14_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A14]])
; CHECK:         [[A13_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A13]])
; CHECK:         [[A12_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A12]])
; CHECK:         [[A11_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A11]])
; CHECK:         [[A10_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A10]])
; CHECK:         [[A9_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A9]])
; CHECK:         [[A8_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A8]])
; CHECK-NEXT:    br i1 [[A15]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo(i1 [[A1]])
; CHECK-NEXT:    call void @foo(i1 [[A2]])
; CHECK-NEXT:    call void @foo(i1 [[A3]])
; CHECK-NEXT:    call void @foo(i1 [[A4]])
; CHECK-NEXT:    call void @foo(i1 [[A5]])
; CHECK-NEXT:    call void @foo(i1 [[A6]])
; CHECK-NEXT:    call void @foo(i1 [[A7]])
; CHECK-NEXT:    call void @foo(i1 [[A8_0]])
; CHECK-NEXT:    call void @foo(i1 [[A9_0]])
; CHECK-NEXT:    call void @foo(i1 [[A10_0]])
; CHECK-NEXT:    call void @foo(i1 [[A11_0]])
; CHECK-NEXT:    call void @foo(i1 [[A12_0]])
; CHECK-NEXT:    call void @foo(i1 [[A13_0]])
; CHECK-NEXT:    call void @foo(i1 [[A14_0]])
; CHECK-NEXT:    call void @foo(i1 [[A15_0]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    call void @foo(i1 [[A1]])
; CHECK-NEXT:    call void @foo(i1 [[A2]])
; CHECK-NEXT:    call void @foo(i1 [[A3]])
; CHECK-NEXT:    call void @foo(i1 [[A4]])
; CHECK-NEXT:    call void @foo(i1 [[A5]])
; CHECK-NEXT:    call void @foo(i1 [[A6]])
; CHECK-NEXT:    call void @foo(i1 [[A7]])
; CHECK-NEXT:    call void @foo(i1 [[A8]])
; CHECK-NEXT:    call void @foo(i1 [[A9]])
; CHECK-NEXT:    call void @foo(i1 [[A10]])
; CHECK-NEXT:    call void @foo(i1 [[A11]])
; CHECK-NEXT:    call void @foo(i1 [[A12]])
; CHECK-NEXT:    call void @foo(i1 [[A13]])
; CHECK-NEXT:    call void @foo(i1 [[A14]])
; CHECK-NEXT:    call void @foo(i1 [[A15_1]])
; CHECK-NEXT:    ret void
;
  %a2 = and i1 %a1, true
  %a3 = and i1 %a2, true
  %a4 = and i1 %a3, true
  %a5 = and i1 %a4, true
  %a6 = and i1 %a5, true
  %a7 = and i1 %a6, true
  %a8 = and i1 %a7, true
  %a9 = and i1 %a8, true
  %a10 = and i1 %a9, true
  %a11 = and i1 %a10, true
  %a12 = and i1 %a11, true
  %a13 = and i1 %a12, true
  %a14 = and i1 %a13, true
  %a15 = and i1 %a14, true
  br i1 %a15, label %if, label %else

if:
  call void @foo(i1 %a1)
  call void @foo(i1 %a2)
  call void @foo(i1 %a3)
  call void @foo(i1 %a4)
  call void @foo(i1 %a5)
  call void @foo(i1 %a6)
  call void @foo(i1 %a7)
  call void @foo(i1 %a8)
  call void @foo(i1 %a9)
  call void @foo(i1 %a10)
  call void @foo(i1 %a11)
  call void @foo(i1 %a12)
  call void @foo(i1 %a13)
  call void @foo(i1 %a14)
  call void @foo(i1 %a15)
  ret void

else:
  call void @foo(i1 %a1)
  call void @foo(i1 %a2)
  call void @foo(i1 %a3)
  call void @foo(i1 %a4)
  call void @foo(i1 %a5)
  call void @foo(i1 %a6)
  call void @foo(i1 %a7)
  call void @foo(i1 %a8)
  call void @foo(i1 %a9)
  call void @foo(i1 %a10)
  call void @foo(i1 %a11)
  call void @foo(i1 %a12)
  call void @foo(i1 %a13)
  call void @foo(i1 %a14)
  call void @foo(i1 %a15)
  ret void
}

define void @test_deep_and_tree(i1 %a1) {
; CHECK-LABEL: @test_deep_and_tree(
; CHECK-NEXT:    [[A2:%.*]] = and i1 [[A1:%.*]], [[A1]]
; CHECK-NEXT:    [[A3:%.*]] = and i1 [[A2]], [[A2]]
; CHECK-NEXT:    [[A4:%.*]] = and i1 [[A3]], [[A3]]
; CHECK-NEXT:    [[A5:%.*]] = and i1 [[A4]], [[A4]]
; CHECK-NEXT:    [[A6:%.*]] = and i1 [[A5]], [[A5]]
; CHECK-NEXT:    [[A7:%.*]] = and i1 [[A6]], [[A6]]
; CHECK-NEXT:    [[A8:%.*]] = and i1 [[A7]], [[A7]]
; CHECK-NEXT:    [[A9:%.*]] = and i1 [[A8]], [[A8]]
; CHECK-NEXT:    [[A10:%.*]] = and i1 [[A9]], [[A9]]
; CHECK-NEXT:    [[A11:%.*]] = and i1 [[A10]], [[A10]]
; CHECK-NEXT:    [[A12:%.*]] = and i1 [[A11]], [[A11]]
; CHECK-NEXT:    [[A13:%.*]] = and i1 [[A12]], [[A12]]
; CHECK-NEXT:    [[A14:%.*]] = and i1 [[A13]], [[A13]]
; CHECK-NEXT:    [[A15:%.*]] = and i1 [[A14]], [[A14]]
; CHECK:         [[A15_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A15]])
; CHECK:         [[A15_1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A15]])
; CHECK:         [[A14_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A14]])
; CHECK:         [[A13_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A13]])
; CHECK:         [[A12_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A12]])
; CHECK:         [[A11_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A11]])
; CHECK:         [[A10_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A10]])
; CHECK:         [[A9_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A9]])
; CHECK:         [[A8_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A8]])
; CHECK-NEXT:    br i1 [[A15]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo(i1 [[A1]])
; CHECK-NEXT:    call void @foo(i1 [[A2]])
; CHECK-NEXT:    call void @foo(i1 [[A3]])
; CHECK-NEXT:    call void @foo(i1 [[A4]])
; CHECK-NEXT:    call void @foo(i1 [[A5]])
; CHECK-NEXT:    call void @foo(i1 [[A6]])
; CHECK-NEXT:    call void @foo(i1 [[A7]])
; CHECK-NEXT:    call void @foo(i1 [[A8_0]])
; CHECK-NEXT:    call void @foo(i1 [[A9_0]])
; CHECK-NEXT:    call void @foo(i1 [[A10_0]])
; CHECK-NEXT:    call void @foo(i1 [[A11_0]])
; CHECK-NEXT:    call void @foo(i1 [[A12_0]])
; CHECK-NEXT:    call void @foo(i1 [[A13_0]])
; CHECK-NEXT:    call void @foo(i1 [[A14_0]])
; CHECK-NEXT:    call void @foo(i1 [[A15_0]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    call void @foo(i1 [[A1]])
; CHECK-NEXT:    call void @foo(i1 [[A2]])
; CHECK-NEXT:    call void @foo(i1 [[A3]])
; CHECK-NEXT:    call void @foo(i1 [[A4]])
; CHECK-NEXT:    call void @foo(i1 [[A5]])
; CHECK-NEXT:    call void @foo(i1 [[A6]])
; CHECK-NEXT:    call void @foo(i1 [[A7]])
; CHECK-NEXT:    call void @foo(i1 [[A8]])
; CHECK-NEXT:    call void @foo(i1 [[A9]])
; CHECK-NEXT:    call void @foo(i1 [[A10]])
; CHECK-NEXT:    call void @foo(i1 [[A11]])
; CHECK-NEXT:    call void @foo(i1 [[A12]])
; CHECK-NEXT:    call void @foo(i1 [[A13]])
; CHECK-NEXT:    call void @foo(i1 [[A14]])
; CHECK-NEXT:    call void @foo(i1 [[A15_1]])
; CHECK-NEXT:    ret void
;
  %a2 = and i1 %a1, %a1
  %a3 = and i1 %a2, %a2
  %a4 = and i1 %a3, %a3
  %a5 = and i1 %a4, %a4
  %a6 = and i1 %a5, %a5
  %a7 = and i1 %a6, %a6
  %a8 = and i1 %a7, %a7
  %a9 = and i1 %a8, %a8
  %a10 = and i1 %a9, %a9
  %a11 = and i1 %a10, %a10
  %a12 = and i1 %a11, %a11
  %a13 = and i1 %a12, %a12
  %a14 = and i1 %a13, %a13
  %a15 = and i1 %a14, %a14
  br i1 %a15, label %if, label %else

if:
  call void @foo(i1 %a1)
  call void @foo(i1 %a2)
  call void @foo(i1 %a3)
  call void @foo(i1 %a4)
  call void @foo(i1 %a5)
  call void @foo(i1 %a6)
  call void @foo(i1 %a7)
  call void @foo(i1 %a8)
  call void @foo(i1 %a9)
  call void @foo(i1 %a10)
  call void @foo(i1 %a11)
  call void @foo(i1 %a12)
  call void @foo(i1 %a13)
  call void @foo(i1 %a14)
  call void @foo(i1 %a15)
  ret void

else:
  call void @foo(i1 %a1)
  call void @foo(i1 %a2)
  call void @foo(i1 %a3)
  call void @foo(i1 %a4)
  call void @foo(i1 %a5)
  call void @foo(i1 %a6)
  call void @foo(i1 %a7)
  call void @foo(i1 %a8)
  call void @foo(i1 %a9)
  call void @foo(i1 %a10)
  call void @foo(i1 %a11)
  call void @foo(i1 %a12)
  call void @foo(i1 %a13)
  call void @foo(i1 %a14)
  call void @foo(i1 %a15)
  ret void
}

define void @test_deep_or_tree(i1 %a1) {
; CHECK-LABEL: @test_deep_or_tree(
; CHECK-NEXT:    [[A2:%.*]] = or i1 [[A1:%.*]], [[A1]]
; CHECK-NEXT:    [[A3:%.*]] = or i1 [[A2]], [[A2]]
; CHECK-NEXT:    [[A4:%.*]] = or i1 [[A3]], [[A3]]
; CHECK-NEXT:    [[A5:%.*]] = or i1 [[A4]], [[A4]]
; CHECK-NEXT:    [[A6:%.*]] = or i1 [[A5]], [[A5]]
; CHECK-NEXT:    [[A7:%.*]] = or i1 [[A6]], [[A6]]
; CHECK-NEXT:    [[A8:%.*]] = or i1 [[A7]], [[A7]]
; CHECK-NEXT:    [[A9:%.*]] = or i1 [[A8]], [[A8]]
; CHECK-NEXT:    [[A10:%.*]] = or i1 [[A9]], [[A9]]
; CHECK-NEXT:    [[A11:%.*]] = or i1 [[A10]], [[A10]]
; CHECK-NEXT:    [[A12:%.*]] = or i1 [[A11]], [[A11]]
; CHECK-NEXT:    [[A13:%.*]] = or i1 [[A12]], [[A12]]
; CHECK-NEXT:    [[A14:%.*]] = or i1 [[A13]], [[A13]]
; CHECK-NEXT:    [[A15:%.*]] = or i1 [[A14]], [[A14]]
; CHECK:         [[A15_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A15]])
; CHECK:         [[A15_1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A15]])
; CHECK:         [[A14_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A14]])
; CHECK:         [[A13_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A13]])
; CHECK:         [[A12_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A12]])
; CHECK:         [[A11_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A11]])
; CHECK:         [[A10_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A10]])
; CHECK:         [[A9_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A9]])
; CHECK:         [[A8_0:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A8]])
; CHECK-NEXT:    br i1 [[A15]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo(i1 [[A1]])
; CHECK-NEXT:    call void @foo(i1 [[A2]])
; CHECK-NEXT:    call void @foo(i1 [[A3]])
; CHECK-NEXT:    call void @foo(i1 [[A4]])
; CHECK-NEXT:    call void @foo(i1 [[A5]])
; CHECK-NEXT:    call void @foo(i1 [[A6]])
; CHECK-NEXT:    call void @foo(i1 [[A7]])
; CHECK-NEXT:    call void @foo(i1 [[A8]])
; CHECK-NEXT:    call void @foo(i1 [[A9]])
; CHECK-NEXT:    call void @foo(i1 [[A10]])
; CHECK-NEXT:    call void @foo(i1 [[A11]])
; CHECK-NEXT:    call void @foo(i1 [[A12]])
; CHECK-NEXT:    call void @foo(i1 [[A13]])
; CHECK-NEXT:    call void @foo(i1 [[A14]])
; CHECK-NEXT:    call void @foo(i1 [[A15_0]])
; CHECK-NEXT:    ret void
; CHECK:       else:
; CHECK-NEXT:    call void @foo(i1 [[A1]])
; CHECK-NEXT:    call void @foo(i1 [[A2]])
; CHECK-NEXT:    call void @foo(i1 [[A3]])
; CHECK-NEXT:    call void @foo(i1 [[A4]])
; CHECK-NEXT:    call void @foo(i1 [[A5]])
; CHECK-NEXT:    call void @foo(i1 [[A6]])
; CHECK-NEXT:    call void @foo(i1 [[A7]])
; CHECK-NEXT:    call void @foo(i1 [[A8_0]])
; CHECK-NEXT:    call void @foo(i1 [[A9_0]])
; CHECK-NEXT:    call void @foo(i1 [[A10_0]])
; CHECK-NEXT:    call void @foo(i1 [[A11_0]])
; CHECK-NEXT:    call void @foo(i1 [[A12_0]])
; CHECK-NEXT:    call void @foo(i1 [[A13_0]])
; CHECK-NEXT:    call void @foo(i1 [[A14_0]])
; CHECK-NEXT:    call void @foo(i1 [[A15_1]])
; CHECK-NEXT:    ret void
;
  %a2 = or i1 %a1, %a1
  %a3 = or i1 %a2, %a2
  %a4 = or i1 %a3, %a3
  %a5 = or i1 %a4, %a4
  %a6 = or i1 %a5, %a5
  %a7 = or i1 %a6, %a6
  %a8 = or i1 %a7, %a7
  %a9 = or i1 %a8, %a8
  %a10 = or i1 %a9, %a9
  %a11 = or i1 %a10, %a10
  %a12 = or i1 %a11, %a11
  %a13 = or i1 %a12, %a12
  %a14 = or i1 %a13, %a13
  %a15 = or i1 %a14, %a14
  br i1 %a15, label %if, label %else

if:
  call void @foo(i1 %a1)
  call void @foo(i1 %a2)
  call void @foo(i1 %a3)
  call void @foo(i1 %a4)
  call void @foo(i1 %a5)
  call void @foo(i1 %a6)
  call void @foo(i1 %a7)
  call void @foo(i1 %a8)
  call void @foo(i1 %a9)
  call void @foo(i1 %a10)
  call void @foo(i1 %a11)
  call void @foo(i1 %a12)
  call void @foo(i1 %a13)
  call void @foo(i1 %a14)
  call void @foo(i1 %a15)
  ret void

else:
  call void @foo(i1 %a1)
  call void @foo(i1 %a2)
  call void @foo(i1 %a3)
  call void @foo(i1 %a4)
  call void @foo(i1 %a5)
  call void @foo(i1 %a6)
  call void @foo(i1 %a7)
  call void @foo(i1 %a8)
  call void @foo(i1 %a9)
  call void @foo(i1 %a10)
  call void @foo(i1 %a11)
  call void @foo(i1 %a12)
  call void @foo(i1 %a13)
  call void @foo(i1 %a14)
  call void @foo(i1 %a15)
  ret void
}

define void @test_assume_and_chain(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @test_assume_and_chain(
; CHECK-NEXT:    [[AND1:%.*]] = and i1 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[AND2:%.*]] = and i1 [[AND1]], [[C:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[AND2]])
; CHECK:         [[TMP1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[C]])
; CHECK:         [[TMP2:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[B]])
; CHECK:         [[TMP3:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A]])
; CHECK:         [[TMP4:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[AND1]])
; CHECK:         [[TMP5:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[AND2]])
; CHECK-NEXT:    call void @foo(i1 [[TMP3]])
; CHECK-NEXT:    call void @foo(i1 [[TMP2]])
; CHECK-NEXT:    call void @foo(i1 [[TMP1]])
; CHECK-NEXT:    call void @foo(i1 [[TMP4]])
; CHECK-NEXT:    call void @foo(i1 [[TMP5]])
; CHECK-NEXT:    ret void
;
  %and1 = and i1 %a, %b
  %and2 = and i1 %and1, %c
  call void @llvm.assume(i1 %and2)
  call void @foo(i1 %a)
  call void @foo(i1 %b)
  call void @foo(i1 %c)
  call void @foo(i1 %and1)
  call void @foo(i1 %and2)
  ret void
}

define void @test_assume_or_chain(i1 %a, i1 %b, i1 %c) {
; CHECK-LABEL: @test_assume_or_chain(
; CHECK-NEXT:    [[OR1:%.*]] = or i1 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    [[OR2:%.*]] = or i1 [[OR1]], [[C:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[OR2]])
; CHECK:         [[TMP1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[OR2]])
; CHECK-NEXT:    call void @foo(i1 [[A]])
; CHECK-NEXT:    call void @foo(i1 [[B]])
; CHECK-NEXT:    call void @foo(i1 [[C]])
; CHECK-NEXT:    call void @foo(i1 [[OR1]])
; CHECK-NEXT:    call void @foo(i1 [[TMP1]])
; CHECK-NEXT:    ret void
;
  %or1 = or i1 %a, %b
  %or2 = or i1 %or1, %c
  call void @llvm.assume(i1 %or2)
  call void @foo(i1 %a)
  call void @foo(i1 %b)
  call void @foo(i1 %c)
  call void @foo(i1 %or1)
  call void @foo(i1 %or2)
  ret void
}

define void @test_assume_deep_and_tree(i1 %a1) {
; CHECK-LABEL: @test_assume_deep_and_tree(
; CHECK-NEXT:    [[A2:%.*]] = and i1 [[A1:%.*]], [[A1]]
; CHECK-NEXT:    [[A3:%.*]] = and i1 [[A2]], [[A2]]
; CHECK-NEXT:    [[A4:%.*]] = and i1 [[A3]], [[A3]]
; CHECK-NEXT:    [[A5:%.*]] = and i1 [[A4]], [[A4]]
; CHECK-NEXT:    [[A6:%.*]] = and i1 [[A5]], [[A5]]
; CHECK-NEXT:    [[A7:%.*]] = and i1 [[A6]], [[A6]]
; CHECK-NEXT:    [[A8:%.*]] = and i1 [[A7]], [[A7]]
; CHECK-NEXT:    [[A9:%.*]] = and i1 [[A8]], [[A8]]
; CHECK-NEXT:    [[A10:%.*]] = and i1 [[A9]], [[A9]]
; CHECK-NEXT:    [[A11:%.*]] = and i1 [[A10]], [[A10]]
; CHECK-NEXT:    [[A12:%.*]] = and i1 [[A11]], [[A11]]
; CHECK-NEXT:    [[A13:%.*]] = and i1 [[A12]], [[A12]]
; CHECK-NEXT:    [[A14:%.*]] = and i1 [[A13]], [[A13]]
; CHECK-NEXT:    [[A15:%.*]] = and i1 [[A14]], [[A14]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[A15]])
; CHECK:         [[TMP1:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A8]])
; CHECK:         [[TMP2:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A9]])
; CHECK:         [[TMP3:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A10]])
; CHECK:         [[TMP4:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A11]])
; CHECK:         [[TMP5:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A12]])
; CHECK:         [[TMP6:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A13]])
; CHECK:         [[TMP7:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A14]])
; CHECK:         [[TMP8:%.*]] = call i1 @llvm.ssa.copy.{{.+}}(i1 [[A15]])
; CHECK-NEXT:    call void @foo(i1 [[A1]])
; CHECK-NEXT:    call void @foo(i1 [[A2]])
; CHECK-NEXT:    call void @foo(i1 [[A3]])
; CHECK-NEXT:    call void @foo(i1 [[A4]])
; CHECK-NEXT:    call void @foo(i1 [[A5]])
; CHECK-NEXT:    call void @foo(i1 [[A6]])
; CHECK-NEXT:    call void @foo(i1 [[A7]])
; CHECK-NEXT:    call void @foo(i1 [[TMP1]])
; CHECK-NEXT:    call void @foo(i1 [[TMP2]])
; CHECK-NEXT:    call void @foo(i1 [[TMP3]])
; CHECK-NEXT:    call void @foo(i1 [[TMP4]])
; CHECK-NEXT:    call void @foo(i1 [[TMP5]])
; CHECK-NEXT:    call void @foo(i1 [[TMP6]])
; CHECK-NEXT:    call void @foo(i1 [[TMP7]])
; CHECK-NEXT:    call void @foo(i1 [[TMP8]])
; CHECK-NEXT:    ret void
;
  %a2 = and i1 %a1, %a1
  %a3 = and i1 %a2, %a2
  %a4 = and i1 %a3, %a3
  %a5 = and i1 %a4, %a4
  %a6 = and i1 %a5, %a5
  %a7 = and i1 %a6, %a6
  %a8 = and i1 %a7, %a7
  %a9 = and i1 %a8, %a8
  %a10 = and i1 %a9, %a9
  %a11 = and i1 %a10, %a10
  %a12 = and i1 %a11, %a11
  %a13 = and i1 %a12, %a12
  %a14 = and i1 %a13, %a13
  %a15 = and i1 %a14, %a14
  call void @llvm.assume(i1 %a15)
  call void @foo(i1 %a1)
  call void @foo(i1 %a2)
  call void @foo(i1 %a3)
  call void @foo(i1 %a4)
  call void @foo(i1 %a5)
  call void @foo(i1 %a6)
  call void @foo(i1 %a7)
  call void @foo(i1 %a8)
  call void @foo(i1 %a9)
  call void @foo(i1 %a10)
  call void @foo(i1 %a11)
  call void @foo(i1 %a12)
  call void @foo(i1 %a13)
  call void @foo(i1 %a14)
  call void @foo(i1 %a15)
  ret void
}
