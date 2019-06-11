; Confirm that the line numbers for the middle.block operations are all the
; same as the start of the loop.

; RUN: opt -S -loop-vectorize -force-vector-width=4 -force-vector-interleave=4 <%s | FileCheck %s
;
; CHECK: middle.block:
; CHECK-NEXT: %{{.*}}= add <4 x i32>{{.*}}, !dbg ![[DL:[0-9]+]]
; CHECK-NEXT: %{{.*}}= add <4 x i32>{{.*}}, !dbg ![[DL]]
; CHECK-NEXT: %{{.*}}= add <4 x i32>{{.*}}, !dbg ![[DL]]
; CHECK-NEXT: %{{.*}}= shufflevector <4 x i32>{{.*}}, !dbg ![[DL]]
; CHECK-NEXT: %{{.*}}= add <4 x i32>{{.*}}, !dbg ![[DL]]
; CHECK-NEXT: %{{.*}}= shufflevector <4 x i32>{{.*}}, !dbg ![[DL]]
; CHECK-NEXT: %{{.*}}= add <4 x i32>{{.*}}, !dbg ![[DL]]
; CHECK-NEXT: %{{.*}}= extractelement <4 x i32>{{.*}}, !dbg ![[DL]]
; CHECK-NEXT: %{{.*}}= icmp eq i64{{.*}}, !dbg ![[DL]]
; CHECK-NEXT: br i1 %{{.*}}, !dbg ![[DL]]
; CHECK: ![[DL]] = !DILocation(line: 5,

; This IR can be generated by running:
; clang -gmlt -S src.cpp -emit-llvm -mllvm -opt-bisect-limit=56 -O2 -o -
;
; Where  src.cpp contains:
; int foo(int count, int *bar)
; {
;   int ret = count;
;   int tmp;
;   for (int j = 0; j < count; j++) {
;     tmp = bar[j];
;     ret += tmp;
;   }
;
;   return ret;
; }

define dso_local i32 @"foo"(i32 %count, i32* nocapture readonly %bar) local_unnamed_addr !dbg !8 {
entry:
  %cmp8 = icmp sgt i32 %count, 0, !dbg !10
  br i1 %cmp8, label %for.body.preheader, label %for.cond.cleanup, !dbg !10

for.body.preheader:                               ; preds = %entry
  %wide.trip.count = zext i32 %count to i64
  br label %for.body, !dbg !11

for.cond.cleanup.loopexit:                        ; preds = %for.body
  %add.lcssa = phi i32 [ %add, %for.body ], !dbg !12
  br label %for.cond.cleanup, !dbg !13

for.cond.cleanup:                                 ; preds = %for.cond.cleanup.loopexit, %entry
  %ret.0.lcssa = phi i32 [ %count, %entry ], [ %add.lcssa, %for.cond.cleanup.loopexit ], !dbg !14
  ret i32 %ret.0.lcssa, !dbg !13

for.body:                                         ; preds = %for.body, %for.body.preheader
  %indvars.iv = phi i64 [ 0, %for.body.preheader ], [ %indvars.iv.next, %for.body ]
  %ret.09 = phi i32 [ %count, %for.body.preheader ], [ %add, %for.body ]
  %arrayidx = getelementptr inbounds i32, i32* %bar, i64 %indvars.iv, !dbg !11
  %0 = load i32, i32* %arrayidx, align 4, !dbg !11, !tbaa !15
  %add = add nsw i32 %0, %ret.09, !dbg !12
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1, !dbg !10
  %exitcond = icmp eq i64 %indvars.iv.next, %wide.trip.count, !dbg !10
  br i1 %exitcond, label %for.cond.cleanup.loopexit, label %for.body, !dbg !10, !llvm.loop !19
}

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5, !6}
!llvm.ident = !{!7}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "", isOptimized: true, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "src.cpp", directory: "")
!2 = !{}
!3 = !{i32 2, !"CodeView", i32 1}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 2}
!6 = !{i32 7, !"PIC Level", i32 2}
!7 = !{!""}
!8 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 1, type: !9, scopeLine: 2, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!9 = !DISubroutineType(types: !2)
!10 = !DILocation(line: 5, scope: !8)
!11 = !DILocation(line: 6, scope: !8)
!12 = !DILocation(line: 7, scope: !8)
!13 = !DILocation(line: 10, scope: !8)
!14 = !DILocation(line: 0, scope: !8)
!15 = !{!16, !16, i64 0}
!16 = !{!"int", !17, i64 0}
!17 = !{!"omnipotent char", !18, i64 0}
!18 = !{!"Simple C++ TBAA"}
!19 = distinct !{!19, !10, !20}
!20 = !DILocation(line: 8, scope: !8)
