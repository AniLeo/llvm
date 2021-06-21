; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S -hoist-common-insts=true | FileCheck %s

declare void @bar(i32)

define void @test(i1 %P, i32* %Q) {
; CHECK-LABEL: @test(
; CHECK-NEXT:    store i32 1, i32* [[Q:%.*]], align 4
; CHECK-NEXT:    [[A:%.*]] = load i32, i32* [[Q]], align 4
; CHECK-NEXT:    call void @bar(i32 [[A]])
; CHECK-NEXT:    ret void
;
  br i1 %P, label %T, label %F
T:              ; preds = %0
  store i32 1, i32* %Q
  %A = load i32, i32* %Q               ; <i32> [#uses=1]
  call void @bar( i32 %A )
  ret void
F:              ; preds = %0
  store i32 1, i32* %Q
  %B = load i32, i32* %Q               ; <i32> [#uses=1]
  call void @bar( i32 %B )
  ret void
}

