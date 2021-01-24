; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -loop-unroll -unroll-count=4 < %s | FileCheck %s

define void @test_inside(i32* %addr1, i32* %addr2) {
; CHECK-LABEL: @test_inside(
; CHECK-NEXT:  start:
; CHECK-NEXT:    br label [[BODY:%.*]]
; CHECK:       body:
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !0)
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[ADDR1:%.*]], align 4, !alias.scope !0
; CHECK-NEXT:    store i32 [[X]], i32* [[ADDR2:%.*]], align 4, !noalias !0
; CHECK-NEXT:    [[ADDR1I_1:%.*]] = getelementptr inbounds i32, i32* [[ADDR1]], i32 1
; CHECK-NEXT:    [[ADDR2I_1:%.*]] = getelementptr inbounds i32, i32* [[ADDR2]], i32 1
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !3)
; CHECK-NEXT:    [[X_1:%.*]] = load i32, i32* [[ADDR1I_1]], align 4, !alias.scope !3
; CHECK-NEXT:    store i32 [[X_1]], i32* [[ADDR2I_1]], align 4, !noalias !3
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !5)
; CHECK-NEXT:    [[X_2:%.*]] = load i32, i32* [[ADDR1]], align 4, !alias.scope !5
; CHECK-NEXT:    store i32 [[X_2]], i32* [[ADDR2]], align 4, !noalias !5
; CHECK-NEXT:    [[ADDR1I_3:%.*]] = getelementptr inbounds i32, i32* [[ADDR1]], i32 1
; CHECK-NEXT:    [[ADDR2I_3:%.*]] = getelementptr inbounds i32, i32* [[ADDR2]], i32 1
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !7)
; CHECK-NEXT:    [[X_3:%.*]] = load i32, i32* [[ADDR1I_3]], align 4, !alias.scope !7
; CHECK-NEXT:    store i32 [[X_3]], i32* [[ADDR2I_3]], align 4, !noalias !7
; CHECK-NEXT:    ret void
;
start:
  br label %body

body:
  %i = phi i32 [ 0, %start ], [ %i2, %body ]
  %j = and i32 %i, 1
  %addr1i = getelementptr inbounds i32, i32* %addr1, i32 %j
  %addr2i = getelementptr inbounds i32, i32* %addr2, i32 %j

  call void @llvm.experimental.noalias.scope.decl(metadata !2)
  %x = load i32, i32* %addr1i, !alias.scope !2
  store i32 %x, i32* %addr2i, !noalias !2

  %i2 = add i32 %i, 1
  %cmp = icmp slt i32 %i2, 4
  br i1 %cmp, label %body, label %end

end:
  ret void
}

define void @test_outside(i32* %addr1, i32* %addr2) {
; CHECK-LABEL: @test_outside(
; CHECK-NEXT:  start:
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !0)
; CHECK-NEXT:    br label [[BODY:%.*]]
; CHECK:       body:
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[ADDR1:%.*]], align 4, !alias.scope !0
; CHECK-NEXT:    store i32 [[X]], i32* [[ADDR2:%.*]], align 4, !noalias !0
; CHECK-NEXT:    [[ADDR1I_1:%.*]] = getelementptr inbounds i32, i32* [[ADDR1]], i32 1
; CHECK-NEXT:    [[ADDR2I_1:%.*]] = getelementptr inbounds i32, i32* [[ADDR2]], i32 1
; CHECK-NEXT:    [[X_1:%.*]] = load i32, i32* [[ADDR1I_1]], align 4, !alias.scope !0
; CHECK-NEXT:    store i32 [[X_1]], i32* [[ADDR2I_1]], align 4, !noalias !0
; CHECK-NEXT:    [[X_2:%.*]] = load i32, i32* [[ADDR1]], align 4, !alias.scope !0
; CHECK-NEXT:    store i32 [[X_2]], i32* [[ADDR2]], align 4, !noalias !0
; CHECK-NEXT:    [[ADDR1I_3:%.*]] = getelementptr inbounds i32, i32* [[ADDR1]], i32 1
; CHECK-NEXT:    [[ADDR2I_3:%.*]] = getelementptr inbounds i32, i32* [[ADDR2]], i32 1
; CHECK-NEXT:    [[X_3:%.*]] = load i32, i32* [[ADDR1I_3]], align 4, !alias.scope !0
; CHECK-NEXT:    store i32 [[X_3]], i32* [[ADDR2I_3]], align 4, !noalias !0
; CHECK-NEXT:    ret void
;
start:
  call void @llvm.experimental.noalias.scope.decl(metadata !2)
  br label %body

body:
  %i = phi i32 [ 0, %start ], [ %i2, %body ]
  %j = and i32 %i, 1
  %addr1i = getelementptr inbounds i32, i32* %addr1, i32 %j
  %addr2i = getelementptr inbounds i32, i32* %addr2, i32 %j

  %x = load i32, i32* %addr1i, !alias.scope !2
  store i32 %x, i32* %addr2i, !noalias !2

  %i2 = add i32 %i, 1
  %cmp = icmp slt i32 %i2, 4
  br i1 %cmp, label %body, label %end

end:
  ret void
}

declare void @llvm.experimental.noalias.scope.decl(metadata)

!0 = distinct !{!0}
!1 = distinct !{!1, !0}
!2 = !{!1}

; CHECK: !0 = !{!1}
; CHECK: !1 = distinct !{!1, !2}
; CHECK: !2 = distinct !{!2}
; CHECK: !3 = !{!4}
; CHECK: !4 = distinct !{!4, !2, !"It1"}
; CHECK: !5 = !{!6}
; CHECK: !6 = distinct !{!6, !2, !"It2"}
; CHECK: !7 = !{!8}
; CHECK: !8 = distinct !{!8, !2, !"It3"}
