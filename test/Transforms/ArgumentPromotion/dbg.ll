; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt < %s -passes=argpromotion -S | FileCheck %s

declare void @sink(i32)

define internal void @test(i32** %X) !dbg !2 {
; CHECK-LABEL: define {{[^@]+}}@test
; CHECK-SAME: (i32 [[X_0_VAL_0_VAL:%.*]]) !dbg [[DBG3:![0-9]+]] {
; CHECK-NEXT:    call void @sink(i32 [[X_0_VAL_0_VAL]])
; CHECK-NEXT:    ret void
;
  %1 = load i32*, i32** %X, align 8
  %2 = load i32, i32* %1, align 8
  call void @sink(i32 %2)
  ret void
}

%struct.pair = type { i32, i32 }

define internal void @test_byval(%struct.pair* byval(%struct.pair) align 4 %P) {
; CHECK-LABEL: define {{[^@]+}}@test_byval
; CHECK-SAME: (i32 [[P_0:%.*]], i32 [[P_1:%.*]]) {
; CHECK-NEXT:    [[P:%.*]] = alloca [[STRUCT_PAIR:%.*]], align 4
; CHECK-NEXT:    [[DOT0:%.*]] = getelementptr [[STRUCT_PAIR]], %struct.pair* [[P]], i32 0, i32 0
; CHECK-NEXT:    store i32 [[P_0]], i32* [[DOT0]], align 4
; CHECK-NEXT:    [[DOT1:%.*]] = getelementptr [[STRUCT_PAIR]], %struct.pair* [[P]], i32 0, i32 1
; CHECK-NEXT:    store i32 [[P_1]], i32* [[DOT1]], align 4
; CHECK-NEXT:    ret void
;
  ret void
}

define void @caller(i32** %Y, %struct.pair* %P) {
; CHECK-LABEL: define {{[^@]+}}@caller
; CHECK-SAME: (i32** [[Y:%.*]], %struct.pair* [[P:%.*]]) {
; CHECK-NEXT:    [[Y_VAL:%.*]] = load i32*, i32** [[Y]], align 8, !dbg [[DBG4:![0-9]+]]
; CHECK-NEXT:    [[Y_VAL_VAL:%.*]] = load i32, i32* [[Y_VAL]], align 8, !dbg [[DBG4]]
; CHECK-NEXT:    call void @test(i32 [[Y_VAL_VAL]]), !dbg [[DBG4]]
; CHECK-NEXT:    [[P_0:%.*]] = getelementptr [[STRUCT_PAIR:%.*]], %struct.pair* [[P]], i32 0, i32 0, !dbg [[DBG5:![0-9]+]]
; CHECK-NEXT:    [[P_0_VAL:%.*]] = load i32, i32* [[P_0]], align 4, !dbg [[DBG5]]
; CHECK-NEXT:    [[P_1:%.*]] = getelementptr [[STRUCT_PAIR]], %struct.pair* [[P]], i32 0, i32 1, !dbg [[DBG5]]
; CHECK-NEXT:    [[P_1_VAL:%.*]] = load i32, i32* [[P_1]], align 4, !dbg [[DBG5]]
; CHECK-NEXT:    call void @test_byval(i32 [[P_0_VAL]], i32 [[P_1_VAL]]), !dbg [[DBG5]]
; CHECK-NEXT:    ret void
;
  call void @test(i32** %Y), !dbg !1

  call void @test_byval(%struct.pair* byval(%struct.pair) align 4 %P), !dbg !6
  ret void
}


!llvm.module.flags = !{!0}
!llvm.dbg.cu = !{!3}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !DILocation(line: 8, scope: !2)
!2 = distinct !DISubprogram(name: "test", file: !5, line: 3, isLocal: true, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, unit: !3, scopeLine: 3, scope: null)
!3 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, producer: "clang version 3.5.0 ", isOptimized: false, emissionKind: LineTablesOnly, file: !5)
!5 = !DIFile(filename: "test.c", directory: "")
!6 = !DILocation(line: 9, scope: !2)
