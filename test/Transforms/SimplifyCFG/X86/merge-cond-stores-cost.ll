; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -mtriple=x86_64-unknown-unknown < %s -simplifycfg-merge-cond-stores=true -simplifycfg-merge-cond-stores-aggressively=false -phi-node-folding-threshold=2 -S | FileCheck %s

define void @test_costly(i32* %p, i32 %a, i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @test_costly(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[X1:%.*]] = icmp eq i32 [[A:%.*]], 0
; CHECK-NEXT:    br i1 [[X1]], label [[FALLTHROUGH:%.*]], label [[YES1:%.*]]
; CHECK:       yes1:
; CHECK-NEXT:    [[VAL0:%.*]] = sdiv i32 [[D:%.*]], [[C:%.*]]
; CHECK-NEXT:    store i32 [[VAL0]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    br label [[FALLTHROUGH]]
; CHECK:       fallthrough:
; CHECK-NEXT:    [[X2:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    br i1 [[X2]], label [[END:%.*]], label [[YES2:%.*]]
; CHECK:       yes2:
; CHECK-NEXT:    [[VAL1:%.*]] = sdiv i32 [[C]], [[D]]
; CHECK-NEXT:    store i32 [[VAL1]], i32* [[P]], align 4
; CHECK-NEXT:    br label [[END]]
; CHECK:       end:
; CHECK-NEXT:    ret void
;
entry:
  %x1 = icmp eq i32 %a, 0
  br i1 %x1, label %fallthrough, label %yes1

yes1:
  %val0 = sdiv i32 %d, %c
  store i32 %val0, i32* %p
  br label %fallthrough

fallthrough:
  %x2 = icmp eq i32 %b, 0
  br i1 %x2, label %end, label %yes2

yes2:
  %val1 = sdiv i32 %c, %d
  store i32 %val1, i32* %p
  br label %end

end:
  ret void
}
