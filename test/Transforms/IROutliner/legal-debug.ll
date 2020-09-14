; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -verify -iroutliner -ir-outlining-no-cost < %s | FileCheck %s

; This test looks ahecks that debug info is extracted along with the other
; instructions.

define void @function1() !dbg !6 {
; CHECK-LABEL: @function1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4, [[DBG17:!dbg !.*]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32* [[A]], [[META9:metadata !.*]], metadata !DIExpression()), [[DBG17]]
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4, [[DBG18:!dbg !.*]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32* [[B]], [[META11:metadata !.*]], metadata !DIExpression()), [[DBG18]]
; CHECK-NEXT:    [[C:%.*]] = alloca i32, align 4, [[DBG19:!dbg !.*]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32* [[C]], [[META12:metadata !.*]], metadata !DIExpression()), [[DBG19]]
; CHECK-NEXT:    call void @outlined_ir_func_0(i32* [[A]], i32* [[B]], i32* [[C]]), [[DBG20:!dbg !.*]]
; CHECK-NEXT:    ret void, [[DBG21:!dbg !.*]]
;
entry:
  %a = alloca i32, align 4, !dbg !17
  call void @llvm.dbg.value(metadata i32* %a, metadata !9, metadata !DIExpression()), !dbg !17
  %b = alloca i32, align 4, !dbg !18
  call void @llvm.dbg.value(metadata i32* %b, metadata !11, metadata !DIExpression()), !dbg !18
  %c = alloca i32, align 4, !dbg !19
  call void @llvm.dbg.value(metadata i32* %c, metadata !12, metadata !DIExpression()), !dbg !19
  store i32 2, i32* %a, align 4, !dbg !20
  store i32 3, i32* %b, align 4, !dbg !21
  store i32 4, i32* %c, align 4, !dbg !22
  %al = load i32, i32* %a, align 4, !dbg !23
  call void @llvm.dbg.value(metadata i32 %al, metadata !13, metadata !DIExpression()), !dbg !23
  %bl = load i32, i32* %b, align 4, !dbg !24
  call void @llvm.dbg.value(metadata i32 %bl, metadata !15, metadata !DIExpression()), !dbg !24
  %cl = load i32, i32* %c, align 4, !dbg !25
  call void @llvm.dbg.value(metadata i32 %cl, metadata !16, metadata !DIExpression()), !dbg !25
  ret void, !dbg !26
}

define void @function2() !dbg !27 {
; CHECK-LABEL: @function2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[A:%.*]] = alloca i32, align 4, [[DBG30:!dbg !.*]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32* [[A]], [[META24:metadata !.*]], metadata !DIExpression()), [[DBG30]]
; CHECK-NEXT:    [[B:%.*]] = alloca i32, align 4, [[DBG31:!dbg !.*]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32* [[B]], [[META25:metadata !.*]], metadata !DIExpression()), [[DBG31]]
; CHECK-NEXT:    [[C:%.*]] = alloca i32, align 4, [[DBG32:!dbg !.*]]
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32* [[C]], [[META26:metadata !.*]], metadata !DIExpression()), [[DBG32]]
; CHECK-NEXT:    call void @outlined_ir_func_0(i32* [[A]], i32* [[B]], i32* [[C]]), [[DBG33:!dbg !.*]]
; CHECK-NEXT:    ret void, [[DBG34:!dbg !.*]]
;
entry:
  %a = alloca i32, align 4, !dbg !35
  call void @llvm.dbg.value(metadata i32* %a, metadata !29, metadata !DIExpression()), !dbg !35
  %b = alloca i32, align 4, !dbg !36
  call void @llvm.dbg.value(metadata i32* %b, metadata !30, metadata !DIExpression()), !dbg !36
  %c = alloca i32, align 4, !dbg !37
  call void @llvm.dbg.value(metadata i32* %c, metadata !31, metadata !DIExpression()), !dbg !37
  store i32 2, i32* %a, align 4, !dbg !38
  store i32 3, i32* %b, align 4, !dbg !39
  store i32 4, i32* %c, align 4, !dbg !40
  %al = load i32, i32* %a, align 4, !dbg !41
  call void @llvm.dbg.value(metadata i32 %al, metadata !32, metadata !DIExpression()), !dbg !41
  %bl = load i32, i32* %b, align 4, !dbg !42
  call void @llvm.dbg.value(metadata i32 %bl, metadata !33, metadata !DIExpression()), !dbg !42
  %cl = load i32, i32* %c, align 4, !dbg !43
  call void @llvm.dbg.value(metadata i32 %cl, metadata !34, metadata !DIExpression()), !dbg !43
  ret void, !dbg !44
}

; Function Attrs: nounwind readnone speculatable willreturn
declare void @llvm.dbg.value(metadata, metadata, metadata) #0

attributes #0 = { nounwind readnone speculatable willreturn }

!llvm.dbg.cu = !{!0}
!llvm.debugify = !{!3, !4}
!llvm.module.flags = !{!5}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1, producer: "debugify", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "legal-debug.ll", directory: "/")
!2 = !{}
!3 = !{i32 20}
!4 = !{i32 12}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = distinct !DISubprogram(name: "function1", linkageName: "function1", scope: null, file: !1, line: 1, type: !7, scopeLine: 1, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !8)
!7 = !DISubroutineType(types: !2)
!8 = !{!9, !11, !12, !13, !15, !16}
!9 = !DILocalVariable(name: "1", scope: !6, file: !1, line: 1, type: !10)
!10 = !DIBasicType(name: "ty64", size: 64, encoding: DW_ATE_unsigned)
!11 = !DILocalVariable(name: "2", scope: !6, file: !1, line: 2, type: !10)
!12 = !DILocalVariable(name: "3", scope: !6, file: !1, line: 3, type: !10)
!13 = !DILocalVariable(name: "4", scope: !6, file: !1, line: 7, type: !14)
!14 = !DIBasicType(name: "ty32", size: 32, encoding: DW_ATE_unsigned)
!15 = !DILocalVariable(name: "5", scope: !6, file: !1, line: 8, type: !14)
!16 = !DILocalVariable(name: "6", scope: !6, file: !1, line: 9, type: !14)
!17 = !DILocation(line: 1, column: 1, scope: !6)
!18 = !DILocation(line: 2, column: 1, scope: !6)
!19 = !DILocation(line: 3, column: 1, scope: !6)
!20 = !DILocation(line: 4, column: 1, scope: !6)
!21 = !DILocation(line: 5, column: 1, scope: !6)
!22 = !DILocation(line: 6, column: 1, scope: !6)
!23 = !DILocation(line: 7, column: 1, scope: !6)
!24 = !DILocation(line: 8, column: 1, scope: !6)
!25 = !DILocation(line: 9, column: 1, scope: !6)
!26 = !DILocation(line: 10, column: 1, scope: !6)
!27 = distinct !DISubprogram(name: "function2", linkageName: "function2", scope: null, file: !1, line: 11, type: !7, scopeLine: 11, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !28)
!28 = !{!29, !30, !31, !32, !33, !34}
!29 = !DILocalVariable(name: "7", scope: !27, file: !1, line: 11, type: !10)
!30 = !DILocalVariable(name: "8", scope: !27, file: !1, line: 12, type: !10)
!31 = !DILocalVariable(name: "9", scope: !27, file: !1, line: 13, type: !10)
!32 = !DILocalVariable(name: "10", scope: !27, file: !1, line: 17, type: !14)
!33 = !DILocalVariable(name: "11", scope: !27, file: !1, line: 18, type: !14)
!34 = !DILocalVariable(name: "12", scope: !27, file: !1, line: 19, type: !14)
!35 = !DILocation(line: 11, column: 1, scope: !27)
!36 = !DILocation(line: 12, column: 1, scope: !27)
!37 = !DILocation(line: 13, column: 1, scope: !27)
!38 = !DILocation(line: 14, column: 1, scope: !27)
!39 = !DILocation(line: 15, column: 1, scope: !27)
!40 = !DILocation(line: 16, column: 1, scope: !27)
!41 = !DILocation(line: 17, column: 1, scope: !27)
!42 = !DILocation(line: 18, column: 1, scope: !27)
!43 = !DILocation(line: 19, column: 1, scope: !27)
!44 = !DILocation(line: 20, column: 1, scope: !27)
