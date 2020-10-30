; RUN: opt < %s -passes='default<O2>' | llc -march=bpfel -filetype=asm -o /dev/null -
; RUN: opt < %s -passes='default<O0>' | llc -march=bpfel -filetype=asm -o /dev/null -

; IR generated by
; $ cat /tmp/a.c
; struct ss { int a; };
; int foo() { return __builtin_btf_type_id(0, 0) + __builtin_preserve_type_info(*(struct ss *)0, 0); }
; $ clang -target bpf -g -S -emit-llvm t.c -Xclang -disable-llvm-passes /tmp/a.c

target triple = "bpf"

; Function Attrs: noinline nounwind optnone
define dso_local i32 @foo() #0 !dbg !9 {
entry:
  %0 = call i32 @llvm.bpf.btf.type.id(i32 0, i64 0), !dbg !12, !llvm.preserve.access.index !4
  %1 = call i32 @llvm.bpf.preserve.type.info(i32 1, i64 0), !dbg !13, !llvm.preserve.access.index !14
  %add = add i32 %0, %1, !dbg !17
  ret i32 %add, !dbg !18
}

; Function Attrs: nounwind readnone
declare i32 @llvm.bpf.btf.type.id(i32, i64) #1

; Function Attrs: nounwind readnone
declare i32 @llvm.bpf.preserve.type.info(i32, i64) #1

attributes #0 = { noinline nounwind optnone }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 12.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, retainedTypes: !3, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "C:/src/tmp\\a.c", directory: "C:\\src\\llvm-project")
!2 = !{}
!3 = !{!4}
!4 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!5 = !{i32 7, !"Dwarf Version", i32 4}
!6 = !{i32 2, !"Debug Info Version", i32 3}
!7 = !{i32 1, !"wchar_size", i32 4}
!8 = !{!"clang version 12.0.0"}
!9 = distinct !DISubprogram(name: "foo", scope: !10, file: !10, line: 2, type: !11, scopeLine: 2, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DIFile(filename: "C:/src/tmp/a.c", directory: "")
!11 = !DISubroutineType(types: !3)
!12 = !DILocation(line: 2, column: 21, scope: !9)
!13 = !DILocation(line: 2, column: 51, scope: !9)
!14 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "ss", file: !10, line: 1, size: 32, elements: !15)
!15 = !{!16}
!16 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !14, file: !10, line: 1, baseType: !4, size: 32)
!17 = !DILocation(line: 2, column: 49, scope: !9)
!18 = !DILocation(line: 2, column: 14, scope: !9)
