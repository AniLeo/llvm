; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S < %s | FileCheck %s

define i32 @foo(i32 %i) nounwind ssp !dbg !0 {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 [[I:%.*]], metadata [[META7:![0-9]+]], metadata !DIExpression()), !dbg [[DBG8:![0-9]+]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 0, metadata [[META9:![0-9]+]], metadata !DIExpression()), !dbg [[DBG11:![0-9]+]]
; CHECK-NEXT:    [[COND:%.*]] = icmp ne i32 [[I]], 0, !dbg [[DBG12:![0-9]+]]
; CHECK-NEXT:    br i1 [[COND]], label [[THEN:%.*]], label [[ELSE:%.*]], !dbg [[DBG12]]
; CHECK:       then:
; CHECK-NEXT:    [[CALL_1:%.*]] = call i32 (...) @bar(), !dbg [[DBG13:![0-9]+]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 [[CALL_1]], metadata [[META9]], metadata !DIExpression()), !dbg [[DBG13]]
; CHECK-NEXT:    br label [[EXIT:%.*]], !dbg [[DBG15:![0-9]+]]
; CHECK:       else:
; CHECK-NEXT:    [[CALL_2:%.*]] = call i32 (...) @bar(), !dbg [[DBG16:![0-9]+]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 [[CALL_2]], metadata [[META9]], metadata !DIExpression()), !dbg [[DBG16]]
; CHECK-NEXT:    br label [[EXIT]], !dbg [[DBG18:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    [[K_0:%.*]] = phi i32 [ [[CALL_1]], [[THEN]] ], [ [[CALL_2]], [[ELSE]] ]
; CHECK-NEXT:    ret i32 [[K_0]], !dbg [[DBG19:![0-9]+]]
;
entry:
  call void @llvm.dbg.value(metadata i32 %i, metadata !6, metadata !DIExpression()), !dbg !7
  call void @llvm.dbg.value(metadata i32 0, metadata !9, metadata !DIExpression()), !dbg !11
  %cond = icmp ne i32 %i, 0, !dbg !12
  br i1 %cond, label %then, label %else, !dbg !12

then:
  %call.1 = call i32 (...) @bar(), !dbg !13
  call void @llvm.dbg.value(metadata i32 %call.1, metadata !9, metadata !DIExpression()), !dbg !13
  br label %exit, !dbg !15

else:
  %call.2 = call i32 (...) @bar(), !dbg !16
  call void @llvm.dbg.value(metadata i32 %call.2, metadata !9, metadata !DIExpression()), !dbg !16
  br label %exit, !dbg !18

exit:
  %k.0 = phi i32 [ %call.1, %then ], [ %call.2, %else ]
  ret i32 %k.0, !dbg !19
}

define i1 @hoist_with_debug2(i32 %x) !dbg !22 {
; CHECK-LABEL: @hoist_with_debug2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TOBOOL_NOT:%.*]] = icmp ugt i32 [[X:%.*]], 2
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 [[X]], metadata [[META21:![0-9]+]], metadata !DIExpression()), !dbg [[DBG23:![0-9]+]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 [[X]], metadata [[META21]], metadata !DIExpression()), !dbg [[DBG23]]
; CHECK-NEXT:    [[DOT:%.*]] = select i1 [[TOBOOL_NOT]], i1 false, i1 true
; CHECK-NEXT:    ret i1 [[DOT]]
;
entry:
  %tobool.not = icmp ugt i32 %x, 2
  br i1 %tobool.not, label %cond.end.thread, label %cond.end.thread19

cond.end.thread19:                                ; preds = %land.lhs.true
  call void @llvm.dbg.value(metadata i32 %x, metadata !24, metadata !DIExpression()), !dbg !25
  br label %exit

cond.end.thread:                                  ; preds = %land.lhs.true
  call void @llvm.dbg.value(metadata i32 %x, metadata !24, metadata !DIExpression()), !dbg !25
  br label %exit

exit:
  %p = phi i1 [ true, %cond.end.thread19 ], [ false, %cond.end.thread ]
  ret i1 %p
}

; Test case for PR49982.
define i16 @hoist_with_debug3_pr49982(i32 %x, i1 %c.2) !dbg !26 {
; CHECK-LABEL: @hoist_with_debug3_pr49982(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[C_0:%.*]] = icmp sgt i32 [[X:%.*]], 0
; CHECK-NEXT:    [[BRMERGE:%.*]] = or i1 [[C_0]], [[C_2:%.*]]
; CHECK-NEXT:    [[DOTMUX:%.*]] = select i1 [[C_0]], i16 0, i16 20
; CHECK-NEXT:    br i1 [[BRMERGE]], label [[EXIT_1:%.*]], label [[FOR_COND]]
; CHECK:       exit.1:
; CHECK-NEXT:    ret i16 [[DOTMUX]]
;
entry:
  br label %for.cond

for.cond:
  %c.0 = icmp sgt i32 %x, 0
  br i1 %c.0, label %check, label %latch

check:
  %c.1 = icmp ugt i32 %x, 2
  br i1 %c.1, label %then, label %else

then:
  call void @llvm.dbg.value(metadata i32 %x, metadata !28, metadata !DIExpression()), !dbg !29
  br label %exit.2

else:
  call void @llvm.dbg.value(metadata i32 %x, metadata !28, metadata !DIExpression()), !dbg !29
  br label %exit.2

latch:
  br i1 %c.2, label %exit.1, label %for.cond

exit.1:
  ret i16 20

exit.2:
  ret i16 0
}

declare void @llvm.dbg.declare(metadata, metadata, metadata) nounwind readnone

declare i32 @bar(...)

declare void @llvm.dbg.value(metadata, metadata, metadata) nounwind readnone

!llvm.module.flags = !{!21}
!llvm.dbg.cu = !{!2}

!0 = distinct !DISubprogram(name: "foo", line: 2, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !2, file: !20, scope: !1, type: !3)
!1 = !DIFile(filename: "b.c", directory: "/private/tmp")
!2 = distinct !DICompileUnit(language: DW_LANG_C99, producer: "clang", isOptimized: true, emissionKind: FullDebug, file: !20)
!3 = !DISubroutineType(types: !4)
!4 = !{!5}
!5 = !DIBasicType(tag: DW_TAG_base_type, name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!6 = !DILocalVariable(name: "i", line: 2, arg: 1, scope: !0, file: !1, type: !5)
!7 = !DILocation(line: 2, column: 13, scope: !0)
!9 = !DILocalVariable(name: "k", line: 3, scope: !10, file: !1, type: !5)
!10 = distinct !DILexicalBlock(line: 2, column: 16, file: !20, scope: !0)
!11 = !DILocation(line: 3, column: 12, scope: !10)
!12 = !DILocation(line: 4, column: 3, scope: !10)
!13 = !DILocation(line: 5, column: 5, scope: !14)
!14 = distinct !DILexicalBlock(line: 4, column: 10, file: !20, scope: !10)
!15 = !DILocation(line: 6, column: 3, scope: !14)
!16 = !DILocation(line: 7, column: 5, scope: !17)
!17 = distinct !DILexicalBlock(line: 6, column: 10, file: !20, scope: !10)
!18 = !DILocation(line: 8, column: 3, scope: !17)
!19 = !DILocation(line: 9, column: 3, scope: !10)
!20 = !DIFile(filename: "b.c", directory: "/private/tmp")
!21 = !{i32 1, !"Debug Info Version", i32 3}

!22 = distinct !DISubprogram(name: "bar", line: 20, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !2, file: !20, scope: !1, type: !3)
!23 = distinct !DILexicalBlock(line: 21, column: 33, file: !20, scope: !22)
!24 = !DILocalVariable(name: "y", line: 21, scope: !23, file: !1, type: !5)
!25 = !DILocation(line: 23, column: 3, scope: !23)

!26 = distinct !DISubprogram(name: "zar", line: 20, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !2, file: !20, scope: !1, type: !3)
!27 = distinct !DILexicalBlock(line: 31, column: 33, file: !20, scope: !26)
!28 = !DILocalVariable(name: "y", line: 21, scope: !27, file: !1, type: !5)
!29 = !DILocation(line: 33, column: 3, scope: !27)
