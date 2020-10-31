; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -inline -S < %s | FileCheck %s
target datalayout = "e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; This callee uses scoped alias metadata internally itself.
define void @callee_with_metadata(float* nocapture %a, float* nocapture %b, float* nocapture readonly %c) #0 {
entry:
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

; This callee does not make use of scoped alias metadata itself.
define void @callee_without_metadata(float* nocapture %a, float* nocapture %b, float* nocapture readonly %c) #0 {
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

define void @caller(float* nocapture %a, float* nocapture %b, float* nocapture readonly %c) #0 {
; CHECK-LABEL: @caller(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[C:%.*]], align 4, !noalias !6
; CHECK-NEXT:    [[ARRAYIDX_I_I:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 5
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX_I_I]], align 4, !alias.scope !12, !noalias !13
; CHECK-NEXT:    [[ARRAYIDX1_I_I:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 8
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX1_I_I]], align 4, !alias.scope !14, !noalias !15
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[C]], align 4, !noalias !16
; CHECK-NEXT:    [[ARRAYIDX_I:%.*]] = getelementptr inbounds float, float* [[A]], i64 7
; CHECK-NEXT:    store float [[TMP1]], float* [[ARRAYIDX_I]], align 4, !noalias !16
; CHECK-NEXT:    [[TMP2:%.*]] = load float, float* [[A]], align 4, !alias.scope !16, !noalias !17
; CHECK-NEXT:    [[ARRAYIDX_I_I7:%.*]] = getelementptr inbounds float, float* [[B]], i64 5
; CHECK-NEXT:    store float [[TMP2]], float* [[ARRAYIDX_I_I7]], align 4, !alias.scope !21, !noalias !22
; CHECK-NEXT:    [[ARRAYIDX1_I_I8:%.*]] = getelementptr inbounds float, float* [[B]], i64 8
; CHECK-NEXT:    store float [[TMP2]], float* [[ARRAYIDX1_I_I8]], align 4, !alias.scope !23, !noalias !24
; CHECK-NEXT:    [[TMP3:%.*]] = load float, float* [[A]], align 4, !alias.scope !16
; CHECK-NEXT:    [[ARRAYIDX_I9:%.*]] = getelementptr inbounds float, float* [[B]], i64 7
; CHECK-NEXT:    store float [[TMP3]], float* [[ARRAYIDX_I9]], align 4, !alias.scope !16
; CHECK-NEXT:    [[TMP4:%.*]] = load float, float* [[C]], align 4
; CHECK-NEXT:    [[ARRAYIDX_I_I4:%.*]] = getelementptr inbounds float, float* [[A]], i64 5
; CHECK-NEXT:    store float [[TMP4]], float* [[ARRAYIDX_I_I4]], align 4
; CHECK-NEXT:    [[ARRAYIDX1_I_I5:%.*]] = getelementptr inbounds float, float* [[B]], i64 8
; CHECK-NEXT:    store float [[TMP4]], float* [[ARRAYIDX1_I_I5]], align 4
; CHECK-NEXT:    [[TMP5:%.*]] = load float, float* [[C]], align 4
; CHECK-NEXT:    [[ARRAYIDX_I6:%.*]] = getelementptr inbounds float, float* [[A]], i64 7
; CHECK-NEXT:    store float [[TMP5]], float* [[ARRAYIDX_I6]], align 4
; CHECK-NEXT:    [[TMP6:%.*]] = load float, float* [[A]], align 4
; CHECK-NEXT:    [[ARRAYIDX_I_I1:%.*]] = getelementptr inbounds float, float* [[B]], i64 5
; CHECK-NEXT:    store float [[TMP6]], float* [[ARRAYIDX_I_I1]], align 4
; CHECK-NEXT:    [[ARRAYIDX1_I_I2:%.*]] = getelementptr inbounds float, float* [[B]], i64 8
; CHECK-NEXT:    store float [[TMP6]], float* [[ARRAYIDX1_I_I2]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = load float, float* [[A]], align 4
; CHECK-NEXT:    [[ARRAYIDX_I3:%.*]] = getelementptr inbounds float, float* [[B]], i64 7
; CHECK-NEXT:    store float [[TMP7]], float* [[ARRAYIDX_I3]], align 4
; CHECK-NEXT:    ret void
;
entry:
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

; CHECK: !0 = !{!1, !3}
; CHECK: !1 = distinct !{!1, !2, !"hello2: %a"}
; CHECK: !2 = distinct !{!2, !"hello2"}
; CHECK: !3 = distinct !{!3, !2, !"hello2: %b"}
; CHECK: !4 = !{!1}
; CHECK: !5 = !{!3}
; CHECK: !6 = !{!7, !9, !10}
; CHECK: !7 = distinct !{!7, !8, !"hello2: %a"}
; CHECK: !8 = distinct !{!8, !"hello2"}
; CHECK: !9 = distinct !{!9, !8, !"hello2: %b"}
; CHECK: !10 = distinct !{!10, !11, !"hello: %a"}
; CHECK: !11 = distinct !{!11, !"hello"}
; CHECK: !12 = !{!7}
; CHECK: !13 = !{!9, !10}
; CHECK: !14 = !{!9}
; CHECK: !15 = !{!7, !10}
; CHECK: !16 = !{!10}
; CHECK: !17 = !{!18, !20}
; CHECK: !18 = distinct !{!18, !19, !"hello2: %a"}
; CHECK: !19 = distinct !{!19, !"hello2"}
; CHECK: !20 = distinct !{!20, !19, !"hello2: %b"}
; CHECK: !21 = !{!18, !10}
; CHECK: !22 = !{!20}
; CHECK: !23 = !{!20, !10}
; CHECK: !24 = !{!18}

