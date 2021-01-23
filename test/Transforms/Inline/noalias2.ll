; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
; RUN: opt -inline -enable-noalias-to-md-conversion -S < %s | FileCheck %s
; RUN: opt -inline -enable-noalias-to-md-conversion --enable-knowledge-retention -S < %s | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define void @hello(float* noalias nocapture %a, float* noalias nocapture readonly %c) #0 {
; CHECK-LABEL: define {{[^@]+}}@hello
; CHECK-SAME: (float* noalias nocapture [[A:%.*]], float* noalias nocapture readonly [[C:%.*]]) [[ATTR0:#.*]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[C]], align 4
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[A]], i64 5
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load float, float* %c, align 4
  %arrayidx = getelementptr inbounds float, float* %a, i64 5
  store float %0, float* %arrayidx, align 4
  ret void
}

define void @foo(float* noalias nocapture %a, float* noalias nocapture readonly %c) #0 {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (float* noalias nocapture [[A:%.*]], float* noalias nocapture readonly [[C:%.*]]) [[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !0)
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !3)
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[C]], align 4, !alias.scope !3, !noalias !0
; CHECK-NEXT:    [[ARRAYIDX_I:%.*]] = getelementptr inbounds float, float* [[A]], i64 5
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX_I]], align 4, !alias.scope !0, !noalias !3
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[C]], align 4
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[A]], i64 7
; CHECK-NEXT:    store float [[TMP1]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    ret void
;
entry:
  tail call void @hello(float* %a, float* %c)
  %0 = load float, float* %c, align 4
  %arrayidx = getelementptr inbounds float, float* %a, i64 7
  store float %0, float* %arrayidx, align 4
  ret void
}

define void @hello2(float* noalias nocapture %a, float* noalias nocapture %b, float* nocapture readonly %c) #0 {
; CHECK-LABEL: define {{[^@]+}}@hello2
; CHECK-SAME: (float* noalias nocapture [[A:%.*]], float* noalias nocapture [[B:%.*]], float* nocapture readonly [[C:%.*]]) [[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[C]], align 4
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[A]], i64 6
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    [[ARRAYIDX1:%.*]] = getelementptr inbounds float, float* [[B]], i64 8
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX1]], align 4
; CHECK-NEXT:    ret void
;
entry:
  %0 = load float, float* %c, align 4
  %arrayidx = getelementptr inbounds float, float* %a, i64 6
  store float %0, float* %arrayidx, align 4
  %arrayidx1 = getelementptr inbounds float, float* %b, i64 8
  store float %0, float* %arrayidx1, align 4
  ret void
}

; Check that when hello() is inlined into foo(), and then foo() is inlined into
; foo2(), the noalias scopes are properly concatenated.
define void @foo2(float* nocapture %a, float* nocapture %b, float* nocapture readonly %c) #0 {
; CHECK-LABEL: define {{[^@]+}}@foo2
; CHECK-SAME: (float* nocapture [[A:%.*]], float* nocapture [[B:%.*]], float* nocapture readonly [[C:%.*]]) [[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !5)
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !8)
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !10) [[ATTR2:#.*]], !noalias !13
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !14) [[ATTR2]], !noalias !13
; CHECK-NEXT:    [[TMP0:%.*]] = load float, float* [[C]], align 4, !alias.scope !16, !noalias !17
; CHECK-NEXT:    [[ARRAYIDX_I_I:%.*]] = getelementptr inbounds float, float* [[A]], i64 5
; CHECK-NEXT:    store float [[TMP0]], float* [[ARRAYIDX_I_I]], align 4, !alias.scope !17, !noalias !16
; CHECK-NEXT:    [[TMP1:%.*]] = load float, float* [[C]], align 4, !alias.scope !8, !noalias !5
; CHECK-NEXT:    [[ARRAYIDX_I:%.*]] = getelementptr inbounds float, float* [[A]], i64 7
; CHECK-NEXT:    store float [[TMP1]], float* [[ARRAYIDX_I]], align 4, !alias.scope !5, !noalias !8
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !18)
; CHECK-NEXT:    call void @llvm.experimental.noalias.scope.decl(metadata !21)
; CHECK-NEXT:    [[TMP2:%.*]] = load float, float* [[C]], align 4, !noalias !23
; CHECK-NEXT:    [[ARRAYIDX_I1:%.*]] = getelementptr inbounds float, float* [[A]], i64 6
; CHECK-NEXT:    store float [[TMP2]], float* [[ARRAYIDX_I1]], align 4, !alias.scope !18, !noalias !21
; CHECK-NEXT:    [[ARRAYIDX1_I:%.*]] = getelementptr inbounds float, float* [[B]], i64 8
; CHECK-NEXT:    store float [[TMP2]], float* [[ARRAYIDX1_I]], align 4, !alias.scope !21, !noalias !18
; CHECK-NEXT:    [[TMP3:%.*]] = load float, float* [[C]], align 4
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[A]], i64 7
; CHECK-NEXT:    store float [[TMP3]], float* [[ARRAYIDX]], align 4
; CHECK-NEXT:    ret void
;
entry:
  tail call void @foo(float* %a, float* %c)
  tail call void @hello2(float* %a, float* %b, float* %c)
  %0 = load float, float* %c, align 4
  %arrayidx = getelementptr inbounds float, float* %a, i64 7
  store float %0, float* %arrayidx, align 4
  ret void
}

; CHECK: !0 = !{!1}
; CHECK: !1 = distinct !{!1, !2, !"hello: %a"}
; CHECK: !2 = distinct !{!2, !"hello"}
; CHECK: !3 = !{!4}
; CHECK: !4 = distinct !{!4, !2, !"hello: %c"}
; CHECK: !5 = !{!6}
; CHECK: !6 = distinct !{!6, !7, !"foo: %a"}
; CHECK: !7 = distinct !{!7, !"foo"}
; CHECK: !8 = !{!9}
; CHECK: !9 = distinct !{!9, !7, !"foo: %c"}
; CHECK: !10 = !{!11}
; CHECK: !11 = distinct !{!11, !12, !"hello: %a"}
; CHECK: !12 = distinct !{!12, !"hello"}
; CHECK: !13 = !{!6, !9}
; CHECK: !14 = !{!15}
; CHECK: !15 = distinct !{!15, !12, !"hello: %c"}
; CHECK: !16 = !{!15, !9}
; CHECK: !17 = !{!11, !6}
; CHECK: !18 = !{!19}
; CHECK: !19 = distinct !{!19, !20, !"hello2: %a"}
; CHECK: !20 = distinct !{!20, !"hello2"}
; CHECK: !21 = !{!22}
; CHECK: !22 = distinct !{!22, !20, !"hello2: %b"}
; CHECK: !23 = !{!19, !22}

attributes #0 = { nounwind uwtable }

