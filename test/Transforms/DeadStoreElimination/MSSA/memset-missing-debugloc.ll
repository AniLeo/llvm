; Test that the getelementptr generated when the dse pass determines that
; a memset can be shortened has the debugloc carried over from the memset.

; RUN: opt -S -march=native -dse -enable-dse-memoryssa < %s| FileCheck %s
; CHECK: bitcast [5 x i64]* %{{[a-zA-Z_][a-zA-Z0-9_]*}} to i8*, !dbg
; CHECK-NEXT: %{{[0-9]+}} = getelementptr inbounds i8, i8* %0, i64 32, !dbg ![[DBG:[0-9]+]]
; CHECK-NEXT: call void @llvm.memset.p0i8.i64(i8* align 16 %1, i8 0, i64 8, i1 false), !dbg ![[DBG:[0-9]+]]
; CHECK: ![[DBG]] = !DILocation(line: 2,

; The test IR is generated by running:
;
; clang Debugify_Dead_Store_Elimination.cpp -Wno-c++11-narrowing -S \
;   -emit-llvm -O0 -w -Xclang -disable-O0-optnone -march=native -fdeclspec \
;   --target=x86_64-gnu-linux-unknown -Werror=unreachable-code -o -
;
; Where Debugify_Dead_Store_Elimination.cpp contains:
;
; int a() {
;   long b[]{2, 2, 2, 2, 0};
;   if (a())
;     ;
; }


declare void @use([5 x i64]*)

define dso_local i32 @_Z1av() !dbg !7 {
entry:
  %retval = alloca i32, align 4
  %b = alloca [5 x i64], align 16
  call void @llvm.dbg.declare(metadata [5 x i64]* %b, metadata !11, metadata !DIExpression()), !dbg !16
  %0 = bitcast [5 x i64]* %b to i8*, !dbg !16
  call void @llvm.memset.p0i8.i64(i8* align 16 %0, i8 0, i64 40, i1 false), !dbg !16
  %1 = bitcast i8* %0 to [5 x i64]*, !dbg !16
  %2 = getelementptr inbounds [5 x i64], [5 x i64]* %1, i32 0, i32 0, !dbg !16
  store i64 2, i64* %2, align 16, !dbg !16
  %3 = getelementptr inbounds [5 x i64], [5 x i64]* %1, i32 0, i32 1, !dbg !16
  store i64 2, i64* %3, align 8, !dbg !16
  %4 = getelementptr inbounds [5 x i64], [5 x i64]* %1, i32 0, i32 2, !dbg !16
  store i64 2, i64* %4, align 16, !dbg !16
  %5 = getelementptr inbounds [5 x i64], [5 x i64]* %1, i32 0, i32 3, !dbg !16
  store i64 2, i64* %5, align 8, !dbg !16
  call void @use([5 x i64]* %b)
  %call = call i32 @_Z1av(), !dbg !17
  %tobool = icmp ne i32 %call, 0, !dbg !17
  br i1 %tobool, label %if.then, label %if.end, !dbg !19

if.then:                                          ; preds = %entry
  br label %if.end, !dbg !19

if.end:                                           ; preds = %if.then, %entry
  call void @llvm.trap(), !dbg !20
  unreachable, !dbg !20

return:                                           ; No predecessors!
  %6 = load i32, i32* %retval, align 4, !dbg !21
  ret i32 %6, !dbg !21
}

; Function Attrs: nounwind readnone speculatable
declare void @llvm.dbg.declare(metadata, metadata, metadata)

; Function Attrs: argmemonly nounwind
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

; Function Attrs: cold noreturn nounwind
declare void @llvm.trap()

!llvm.module.flags = !{!3, !4, !5}
!llvm.ident = !{!6}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 9.0.0 (https://github.com/llvm/llvm-project.git eb1a156d7f7ba56ea8f9a26da36e6a93d1e98bda)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, nameTableKind: None)
!1 = !DIFile(filename: "Debugify_Dead_Store_Elimination.cpp", directory: "")
!2 = !{}
!3 = !{i32 2, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{!"clang version 9.0.0 (https://github.com/llvm/llvm-project.git eb1a156d7f7ba56ea8f9a26da36e6a93d1e98bda)"}
!7 = distinct !DISubprogram(name: "a", linkageName: "_Z1av", scope: !1, file: !1, line: 1, type: !8, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!8 = !DISubroutineType(types: !9)
!9 = !{!10}
!10 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!11 = !DILocalVariable(name: "b", scope: !7, file: !1, line: 2, type: !12)
!12 = !DICompositeType(tag: DW_TAG_array_type, baseType: !13, size: 320, elements: !14)
!13 = !DIBasicType(name: "long int", size: 64, encoding: DW_ATE_signed)
!14 = !{!15}
!15 = !DISubrange(count: 5)
!16 = !DILocation(line: 2, column: 8, scope: !7)
!17 = !DILocation(line: 3, column: 7, scope: !18)
!18 = distinct !DILexicalBlock(scope: !7, file: !1, line: 3, column: 7)
!19 = !DILocation(line: 3, column: 7, scope: !7)
!20 = !DILocation(line: 3, column: 9, scope: !18)
!21 = !DILocation(line: 5, column: 1, scope: !7)
