; RUN: opt < %s -S -simplifycfg -simplifycfg-require-and-preserve-domtree=1 | FileCheck %s

; In 'simplifycfg', during the flattening of a 'br', the instructions for the
; 'true' and 'false' parts, are moved out from their respective basic blocks.
; Their original debug locations (DILocations) and debug intrinsic instructions
; (dbg.values) are removed.
; As those basic blocks are now empty, their associated labels are removed.
;
; For the given test case, the labels 'W' and 'cleanup4' are removed.
; We're expecting the dbg.label associated with 'W' to disappear, because
; the 'W' label was removed.

; CHECK-LABEL: _Z7test_itv()
; CHECK:       entry:
; CHECK-NEXT:    %retval.0 = select i1 undef, i16 1, i16 0
; CHECK-NEXT:    ret i16 0

define i16 @_Z7test_itv() {
entry:
  br label %sw.bb

sw.bb:                                            ; preds = %entry
  br i1 undef, label %W, label %cleanup4

W:                                                ; preds = %sw.bb
  call void @llvm.dbg.label(metadata !1), !dbg !8
  br label %cleanup4

cleanup4:                                         ; preds = %W, %sw.bb
  %retval.0 = phi i16 [ 1, %W ], [ 0, %sw.bb ]
  ret i16 0
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.label(metadata) #0

attributes #0 = { nounwind readnone speculatable }

!llvm.dbg.cu = !{}
!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
!1 = !DILabel(scope: !2, name: "W", file: !3, line: 47)
!2 = distinct !DILexicalBlock(scope: !4, file: !3, line: 40, column: 3)
!3 = !DIFile(filename: "foo.c", directory: "./")
!4 = distinct !DISubprogram(name: "test_it", scope: !3, file: !3, line: 35, type: !5, scopeLine: 36, unit: !7)
!5 = !DISubroutineType(types: !6)
!6 = !{}
!7 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !3, producer: "clang", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug)
!8 = !DILocation(line: 47, column: 2, scope: !2)
