; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -ipsccp < %s | FileCheck %s

; Make sure we always consider the default edge executable for a switch
; with no cases.
declare void @foo()
define void @test1() {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    switch i32 undef, label [[D:%.*]] [
; CHECK-NEXT:    ]
; CHECK:       d:
; CHECK-NEXT:    call void @foo()
; CHECK-NEXT:    ret void
;
  switch i32 undef, label %d []
d:
  call void @foo()
  ret void
}

define i32 @test_duplicate_successors_phi(i1 %c, i32 %x) {
; CHECK-LABEL: @test_duplicate_successors_phi(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[SWITCH:%.*]], label [[END:%.*]]
; CHECK:       switch:
; CHECK-NEXT:    br label [[SWITCH_DEFAULT:%.*]]
; CHECK:       switch.default:
; CHECK-NEXT:    ret i32 -1
; CHECK:       end:
; CHECK-NEXT:    ret i32 [[X:%.*]]
;
entry:
  br i1 %c, label %switch, label %end

switch:
  switch i32 -1, label %switch.default [
  i32 0, label %end
  i32 1, label %end
  ]

switch.default:
  ret i32 -1

end:
  %phi = phi i32 [ %x, %entry ], [ 1, %switch ], [ 1, %switch ]
  ret i32 %phi
}

define i32 @test_duplicate_successors_phi_2(i1 %c, i32 %x) {
; CHECK-LABEL: @test_duplicate_successors_phi_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[SWITCH:%.*]], label [[END:%.*]]
; CHECK:       switch:
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    [[PHI:%.*]] = phi i32 [ [[X:%.*]], [[ENTRY:%.*]] ], [ 1, [[SWITCH]] ]
; CHECK-NEXT:    ret i32 [[PHI]]
;
entry:
  br i1 %c, label %switch, label %end

switch:
  switch i32 0, label %switch.default [
  i32 0, label %end
  i32 1, label %end
  ]

switch.default:
  ret i32 -1

end:
  %phi = phi i32 [ %x, %entry ], [ 1, %switch ], [ 1, %switch ]
  ret i32 %phi
}

define i32 @test_local_range(i32 %x) {
; CHECK-LABEL: @test_local_range(
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[X:%.*]], 3
; CHECK-NEXT:    call void @llvm.assume(i1 [[C]])
; CHECK-NEXT:    switch i32 [[X]], label [[SWITCH_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[SWITCH_0:%.*]]
; CHECK-NEXT:    i32 1, label [[SWITCH_1:%.*]]
; CHECK-NEXT:    i32 2, label [[SWITCH_2:%.*]]
; CHECK-NEXT:    i32 3, label [[SWITCH_3:%.*]]
; CHECK-NEXT:    ]
; CHECK:       switch.default:
; CHECK-NEXT:    ret i32 -1
; CHECK:       switch.0:
; CHECK-NEXT:    ret i32 0
; CHECK:       switch.1:
; CHECK-NEXT:    ret i32 1
; CHECK:       switch.2:
; CHECK-NEXT:    ret i32 2
; CHECK:       switch.3:
; CHECK-NEXT:    ret i32 3
;
  %c = icmp ult i32 %x, 3
  call void @llvm.assume(i1 %c)
  switch i32 %x, label %switch.default [
  i32 0, label %switch.0
  i32 1, label %switch.1
  i32 2, label %switch.2
  i32 3, label %switch.3
  ]

switch.default:
  ret i32 -1

switch.0:
  ret i32 0

switch.1:
  ret i32 1

switch.2:
  ret i32 2

switch.3:
  ret i32 3
}

define i32 @test_duplicate_successors(i32 %x) {
; CHECK-LABEL: @test_duplicate_successors(
; CHECK-NEXT:    [[C:%.*]] = icmp ult i32 [[X:%.*]], 3
; CHECK-NEXT:    call void @llvm.assume(i1 [[C]])
; CHECK-NEXT:    switch i32 [[X]], label [[SWITCH_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[SWITCH_0:%.*]]
; CHECK-NEXT:    i32 1, label [[SWITCH_0]]
; CHECK-NEXT:    i32 2, label [[SWITCH_1:%.*]]
; CHECK-NEXT:    i32 3, label [[SWITCH_1]]
; CHECK-NEXT:    i32 4, label [[SWITCH_2:%.*]]
; CHECK-NEXT:    i32 5, label [[SWITCH_2]]
; CHECK-NEXT:    ]
; CHECK:       switch.default:
; CHECK-NEXT:    ret i32 -1
; CHECK:       switch.0:
; CHECK-NEXT:    ret i32 0
; CHECK:       switch.1:
; CHECK-NEXT:    ret i32 1
; CHECK:       switch.2:
; CHECK-NEXT:    ret i32 2
;
  %c = icmp ult i32 %x, 3
  call void @llvm.assume(i1 %c)
  switch i32 %x, label %switch.default [
  i32 0, label %switch.0
  i32 1, label %switch.0
  i32 2, label %switch.1
  i32 3, label %switch.1
  i32 4, label %switch.2
  i32 5, label %switch.2
  ]

switch.default:
  ret i32 -1

switch.0:
  ret i32 0

switch.1:
  ret i32 1

switch.2:
  ret i32 2
}

define internal i32 @test_ip_range(i32 %x) {
; CHECK-LABEL: @test_ip_range(
; CHECK-NEXT:    switch i32 [[X:%.*]], label [[SWITCH_DEFAULT:%.*]] [
; CHECK-NEXT:    i32 0, label [[SWITCH_0:%.*]]
; CHECK-NEXT:    i32 1, label [[SWITCH_1:%.*]]
; CHECK-NEXT:    i32 2, label [[SWITCH_2:%.*]]
; CHECK-NEXT:    i32 3, label [[SWITCH_3:%.*]]
; CHECK-NEXT:    ]
; CHECK:       switch.default:
; CHECK-NEXT:    ret i32 -1
; CHECK:       switch.0:
; CHECK-NEXT:    ret i32 0
; CHECK:       switch.1:
; CHECK-NEXT:    ret i32 1
; CHECK:       switch.2:
; CHECK-NEXT:    ret i32 2
; CHECK:       switch.3:
; CHECK-NEXT:    ret i32 3
;
  switch i32 %x, label %switch.default [
  i32 0, label %switch.0
  i32 1, label %switch.1
  i32 2, label %switch.2
  i32 3, label %switch.3
  ]

switch.default:
  ret i32 -1

switch.0:
  ret i32 0

switch.1:
  ret i32 1

switch.2:
  ret i32 2

switch.3:
  ret i32 3
}

define void @call_test_ip_range() {
; CHECK-LABEL: @call_test_ip_range(
; CHECK-NEXT:    [[TMP1:%.*]] = call i32 @test_ip_range(i32 1)
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @test_ip_range(i32 3)
; CHECK-NEXT:    ret void
;
  call i32 @test_ip_range(i32 1)
  call i32 @test_ip_range(i32 3)
  ret void
}

declare void @llvm.assume(i1)
