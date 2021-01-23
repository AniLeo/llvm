; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -inline -S < %s | FileCheck %s
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; This callee uses scoped alias metadata internally itself.
define void @callee_with_metadata(float* nocapture %a, float* nocapture %b, float* nocapture readonly %c) #0 {
; CHECK-LABEL: @callee_with_metadata(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !0)
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !3)
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[C:%.*]], align 4, !noalias !5
; CHECK-NEXT:    [[ARRAYIDX_I:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 5
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX_I]], align 4, !alias.scope !0, !noalias !3
; CHECK-NEXT:    [[ARRAYIDX1_I:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 8
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX1_I]], align 4, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[C]], align 4
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[A]], i64 7
; CHECK-NEXT:    store float [[TMP1]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    ret void
;
entry:
  call void @llvm.experimental.noalias.scope.decl(metadata !7)
  call void @llvm.experimental.noalias.scope.decl(metadata !8)
  %0 = load float, float* %c, align 4, !noalias !3
  %arrayidx.i = getelementptr inbounds float, float* %a, i64 5
  store float %0, float* %arrayidx.i, align 4, !alias.scope !7, !noalias !8
  %arrayidx1.i = getelementptr inbounds float, float* %b, i64 8
  store float %0, float* %arrayidx1.i, align 4, !alias.scope !8, !noalias !7
  %1 = load float, float* %c, align 4
  %arrayidx = getelementptr inbounds float, float* %a, i64 7
  store float %1, float* %arrayidx, align 4
  ret void
}

declare void @llvm.experimental.noalias.scope.decl(metadata);

; This callee does not make use of scoped alias metadata itself.
define void @callee_without_metadata(float* nocapture %a, float* nocapture %b, float* nocapture readonly %c) #0 {
; CHECK-LABEL: @callee_without_metadata(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[C:%.*]], align 4
; CHECK-NEXT:    [[ARRAYIDX_I:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 5
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX_I]], align 4
; CHECK-NEXT:    [[ARRAYIDX1_I:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 8
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX1_I]], align 4
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[C]], align 4
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[A]], i64 7
; CHECK-NEXT:    store float [[TMP1]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load float, float* %c, align 4
  %arrayidx.i = getelementptr inbounds float, float* %a, i64 5
  store float %0, float* %arrayidx.i, align 4
  %arrayidx1.i = getelementptr inbounds float, float* %b, i64 8
  store float %0, float* %arrayidx1.i, align 4
  %1 = load float, float* %c, align 4
  %arrayidx = getelementptr inbounds float, float* %a, i64 7
  store float %1, float* %arrayidx, align 4
  ret void
}

define void @caller(float* nocapture %a, float* nocapture %b, float** nocapture readonly %c_ptr) #0 {
; CHECK-LABEL: @caller(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = load float*, float** [[C_PTR:%.*]], align 8, !alias.scope !6
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !9) [[ATTR2:#.*]], !noalias !6
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !12) [[ATTR2]], !noalias !6
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[C]], align 4, !noalias !14
; CHECK-NEXT:    [[ARRAYIDX_I_I:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 5
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX_I_I]], align 4, !alias.scope !9, !noalias !15
; CHECK-NEXT:    [[ARRAYIDX1_I_I:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 8
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX1_I_I]], align 4, !alias.scope !12, !noalias !16
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[C]], align 4, !noalias !6
; CHECK-NEXT:    [[ARRAYIDX_I:%.*]] = getelementptr inbounds float, float* [[A]], i64 7
; CHECK-NEXT:    store float [[TMP1]], float* [[ARRAYIDX_I]], align 4, !noalias !6
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !17) [[ATTR2]], !alias.scope !6
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !20) [[ATTR2]], !alias.scope !6
; CHECK-NEXT:    [[TMP2:%.*]] = load float, float* [[A]], align 4, !alias.scope !6, !noalias !22
; CHECK-NEXT:    [[ARRAYIDX_I_I7:%.*]] = getelementptr inbounds float, float* [[B]], i64 5
; CHECK-NEXT:    store float [[TMP2]], float* [[ARRAYIDX_I_I7]], align 4, !alias.scope !23, !noalias !20
; CHECK-NEXT:    [[ARRAYIDX1_I_I8:%.*]] = getelementptr inbounds float, float* [[B]], i64 8
; CHECK-NEXT:    store float [[TMP2]], float* [[ARRAYIDX1_I_I8]], align 4, !alias.scope !24, !noalias !17
; CHECK-NEXT:    [[TMP3:%.*]] = load float, float* [[A]], align 4, !alias.scope !6
; CHECK-NEXT:    [[ARRAYIDX_I9:%.*]] = getelementptr inbounds float, float* [[B]], i64 7
; CHECK-NEXT:    store float [[TMP3]], float* [[ARRAYIDX_I9]], align 4, !alias.scope !6
; CHECK-NEXT:    [[TMP4:%.*]] = load float, float* [[C]], align 4, !noalias !6
; CHECK-NEXT:    [[ARRAYIDX_I_I4:%.*]] = getelementptr inbounds float, float* [[A]], i64 5
; CHECK-NEXT:    store float [[TMP4]], float* [[ARRAYIDX_I_I4]], align 4, !noalias !6
; CHECK-NEXT:    [[ARRAYIDX1_I_I5:%.*]] = getelementptr inbounds float, float* [[B]], i64 8
; CHECK-NEXT:    store float [[TMP4]], float* [[ARRAYIDX1_I_I5]], align 4, !noalias !6
; CHECK-NEXT:    [[TMP5:%.*]] = load float, float* [[C]], align 4, !noalias !6
; CHECK-NEXT:    [[ARRAYIDX_I6:%.*]] = getelementptr inbounds float, float* [[A]], i64 7
; CHECK-NEXT:    store float [[TMP5]], float* [[ARRAYIDX_I6]], align 4, !noalias !6
; CHECK-NEXT:    [[TMP6:%.*]] = load float, float* [[A]], align 4, !alias.scope !6
; CHECK-NEXT:    [[ARRAYIDX_I_I1:%.*]] = getelementptr inbounds float, float* [[B]], i64 5
; CHECK-NEXT:    store float [[TMP6]], float* [[ARRAYIDX_I_I1]], align 4, !alias.scope !6
; CHECK-NEXT:    [[ARRAYIDX1_I_I2:%.*]] = getelementptr inbounds float, float* [[B]], i64 8
; CHECK-NEXT:    store float [[TMP6]], float* [[ARRAYIDX1_I_I2]], align 4, !alias.scope !6
; CHECK-NEXT:    [[TMP7:%.*]] = load float, float* [[A]], align 4, !alias.scope !6
; CHECK-NEXT:    [[ARRAYIDX_I3:%.*]] = getelementptr inbounds float, float* [[B]], i64 7
; CHECK-NEXT:    store float [[TMP7]], float* [[ARRAYIDX_I3]], align 4, !alias.scope !6
; CHECK-NEXT:    ret void
;
entry:
  %c = load float*, float** %c_ptr, !alias.scope !0
  call void @callee_with_metadata(float* %a, float* %b, float* %c), !noalias !0
  call void @callee_with_metadata(float* %b, float* %b, float* %a), !alias.scope !0
  call void @callee_without_metadata(float* %a, float* %b, float* %c), !noalias !0
  call void @callee_without_metadata(float* %b, float* %b, float* %a), !alias.scope !0
  ret void
}

attributes #0 = { nounwind uwtable }

!0 = !{!1}
!1 = distinct !{!1, !2, !"hello: %a"}
!2 = distinct !{!2, !"hello"}
!3 = !{!4, !6}
!4 = distinct !{!4, !5, !"hello2: %a"}
!5 = distinct !{!5, !"hello2"}
!6 = distinct !{!6, !5, !"hello2: %b"}
!7 = !{!4}
!8 = !{!6}

; CHECK: !0 = !{!1}
; CHECK: !1 = distinct !{!1, !2, !"hello2: %a"}
; CHECK: !2 = distinct !{!2, !"hello2"}
; CHECK: !3 = !{!4}
; CHECK: !4 = distinct !{!4, !2, !"hello2: %b"}
; CHECK: !5 = !{!1, !4}
; CHECK: !6 = !{!7}
; CHECK: !7 = distinct !{!7, !8, !"hello: %a"}
; CHECK: !8 = distinct !{!8, !"hello"}
; CHECK: !9 = !{!10}
; CHECK: !10 = distinct !{!10, !11, !"hello2: %a"}
; CHECK: !11 = distinct !{!11, !"hello2"}
; CHECK: !12 = !{!13}
; CHECK: !13 = distinct !{!13, !11, !"hello2: %b"}
; CHECK: !14 = !{!10, !13, !7}
; CHECK: !15 = !{!13, !7}
; CHECK: !16 = !{!10, !7}
; CHECK: !17 = !{!18}
; CHECK: !18 = distinct !{!18, !19, !"hello2: %a"}
; CHECK: !19 = distinct !{!19, !"hello2"}
; CHECK: !20 = !{!21}
; CHECK: !21 = distinct !{!21, !19, !"hello2: %b"}
; CHECK: !22 = !{!18, !21}
; CHECK: !23 = !{!18, !7}
; CHECK: !24 = !{!21, !7}
