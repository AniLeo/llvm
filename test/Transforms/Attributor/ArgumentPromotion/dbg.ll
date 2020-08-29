; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=4 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

declare void @sink(i32)

define internal void @test(i32** %X) !dbg !2 {
; CHECK-LABEL: define {{[^@]+}}@test
; CHECK-SAME: (i32** nocapture nonnull readonly align 8 dereferenceable(8) [[X:%.*]]) [[DBG3:!dbg !.*]] {
; CHECK-NEXT:    [[TMP1:%.*]] = load i32*, i32** [[X]], align 8
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP1]], align 8
; CHECK-NEXT:    call void @sink(i32 [[TMP2]])
; CHECK-NEXT:    ret void
;
  %1 = load i32*, i32** %X, align 8
  %2 = load i32, i32* %1, align 8
  call void @sink(i32 %2)
  ret void
}

%struct.pair = type { i32, i32 }

define internal void @test_byval(%struct.pair* byval %P) {
; CHECK-LABEL: define {{[^@]+}}@test_byval() {
; CHECK-NEXT:    call void @sink(i32 0)
; CHECK-NEXT:    ret void
;
  call void @sink(i32 0)
  ret void
}

define void @caller(i32** %Y, %struct.pair* %P) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller
; IS__TUNIT____-SAME: (i32** nocapture readonly [[Y:%.*]], %struct.pair* nocapture nofree readnone [[P:%.*]]) {
; IS__TUNIT____-NEXT:    call void @test(i32** nocapture readonly align 8 [[Y]]), [[DBG4:!dbg !.*]]
; IS__TUNIT____-NEXT:    call void @test_byval(), [[DBG5:!dbg !.*]]
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller
; IS__CGSCC____-SAME: (i32** nocapture nonnull readonly align 8 dereferenceable(8) [[Y:%.*]], %struct.pair* nocapture nofree readnone [[P:%.*]]) {
; IS__CGSCC____-NEXT:    call void @test(i32** nocapture nonnull readonly align 8 dereferenceable(8) [[Y]]), [[DBG4:!dbg !.*]]
; IS__CGSCC____-NEXT:    call void @test_byval(), [[DBG5:!dbg !.*]]
; IS__CGSCC____-NEXT:    ret void
;
  call void @test(i32** %Y), !dbg !1

  call void @test_byval(%struct.pair* %P), !dbg !6
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
