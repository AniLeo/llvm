; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck %s

%0 = type { %1*, %2* }
%1 = type { %0* }
%2 = type { %0*, %2* }

define void @eggs(i1 %arg, i1 %arg16, %0* %arg17, %0* %arg18, %0* %arg19) {
; CHECK-LABEL: @eggs(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 [[ARG:%.*]], label [[BB20:%.*]], label [[BB21:%.*]]
; CHECK:       bb20:
; CHECK-NEXT:    call void @wombat()
; CHECK-NEXT:    unreachable
; CHECK:       bb21:
; CHECK-NEXT:    [[I:%.*]] = icmp eq %0* [[ARG17:%.*]], null
; CHECK-NEXT:    call void @hoge()
; CHECK-NEXT:    [[I26:%.*]] = select i1 [[ARG16:%.*]], %0* null, %0* [[ARG19:%.*]]
; CHECK-NEXT:    [[I27:%.*]] = getelementptr inbounds [[TMP0:%.*]], %0* [[I26]], i64 0, i32 0
; CHECK-NEXT:    [[I28:%.*]] = load %1*, %1** [[I27]], align 8
; CHECK-NEXT:    call void @pluto.1(%1* [[I28]])
; CHECK-NEXT:    call void @pluto()
; CHECK-NEXT:    ret void
;
bb:
  br i1 %arg, label %bb20, label %bb21

bb20:                                             ; preds = %bb
  call void @wombat()
  br label %bb24

bb21:                                             ; preds = %bb
  %i = icmp eq %0* %arg17, null
  br i1 %i, label %bb24, label %bb22

bb22:                                             ; preds = %bb21
  call void @hoge()
  br i1 %arg16, label %bb24, label %bb23

bb23:                                             ; preds = %bb22
  br label %bb24

bb24:                                             ; preds = %bb23, %bb22, %bb21, %bb20
  %i25 = phi i1 [ false, %bb21 ], [ false, %bb20 ], [ false, %bb23 ], [ false, %bb22 ]
  %i26 = phi %0* [ null, %bb21 ], [ null, %bb20 ], [ %arg19, %bb23 ], [ null, %bb22 ]
  %i27 = getelementptr inbounds %0, %0* %i26, i64 0, i32 0
  %i28 = load %1*, %1** %i27, align 8
  call void @pluto.1(%1* %i28)
  br i1 %i25, label %bb30, label %bb29

bb29:                                             ; preds = %bb24
  call void @pluto()
  ret void

bb30:                                             ; preds = %bb24
  call void @spam()
  ret void
}

declare void @wombat()
declare void @pluto()
declare void @spam()
declare void @hoge()
declare void @pluto.1(%1*)
