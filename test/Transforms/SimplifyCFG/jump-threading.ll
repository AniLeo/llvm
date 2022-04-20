; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -simplifycfg < %s | FileCheck %s

declare void @foo()
declare void @bar()
declare void @use.i1(i1)

define void @test_phi_simple(i1 %c) {
; CHECK-LABEL: @test_phi_simple(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  %c2 = phi i1 [ true, %if ], [ false, %else ]
  br i1 %c2, label %if2, label %else2

if2:
  call void @foo()
  br label %join2

else2:
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_phi_extra_use(i1 %c) {
; CHECK-LABEL: @test_phi_extra_use(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    call void @use.i1(i1 true)
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    call void @use.i1(i1 false)
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  %c2 = phi i1 [ true, %if ], [ false, %else ]
  call void @use.i1(i1 %c2)
  br i1 %c2, label %if2, label %else2

if2:
  call void @foo()
  br label %join2

else2:
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_phi_extra_use_different_block(i1 %c) {
; CHECK-LABEL: @test_phi_extra_use_different_block(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    [[C2:%.*]] = phi i1 [ true, [[IF]] ], [ false, [[ELSE]] ]
; CHECK-NEXT:    br i1 [[C2]], label [[IF2:%.*]], label [[ELSE2:%.*]]
; CHECK:       if2:
; CHECK-NEXT:    call void @use.i1(i1 [[C2]])
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else2:
; CHECK-NEXT:    call void @use.i1(i1 [[C2]])
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  %c2 = phi i1 [ true, %if ], [ false, %else ]
  br i1 %c2, label %if2, label %else2

if2:
  call void @use.i1(i1 %c2)
  call void @foo()
  br label %join2

else2:
  call void @use.i1(i1 %c2)
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_same_cond_simple(i1 %c) {
; CHECK-LABEL: @test_same_cond_simple(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  br i1 %c, label %if2, label %else2

if2:
  call void @foo()
  br label %join2

else2:
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_same_cond_extra_use(i1 %c) {
; CHECK-LABEL: @test_same_cond_extra_use(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    call void @use.i1(i1 [[C]])
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    call void @use.i1(i1 [[C]])
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  call void @use.i1(i1 %c)
  br i1 %c, label %if2, label %else2

if2:
  call void @foo()
  br label %join2

else2:
  call void @bar()
  br label %join2

join2:
  ret void
}

define void @test_same_cond_extra_use_different_block(i1 %c) {
; CHECK-LABEL: @test_same_cond_extra_use_different_block(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    call void @use.i1(i1 [[C]])
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    br label [[JOIN2:%.*]]
; CHECK:       else:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    call void @use.i1(i1 [[C]])
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    br label [[JOIN2]]
; CHECK:       join2:
; CHECK-NEXT:    ret void
;
  br i1 %c, label %if, label %else

if:
  call void @foo()
  br label %join

else:
  call void @bar()
  br label %join

join:
  br i1 %c, label %if2, label %else2

if2:
  call void @use.i1(i1 %c)
  call void @foo()
  br label %join2

else2:
  call void @use.i1(i1 %c)
  call void @bar()
  br label %join2

join2:
  ret void
}
