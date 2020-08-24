; RUN: opt < %s -always-inline -barrier -coro-early -barrier -coro-split -S | FileCheck %s
; RUN: opt < %s -enable-new-pm  -always-inline -coro-early -coro-split  -S | FileCheck %s
; RUN: opt < %s -sample-profile-file=%S/Inputs/sample.text.prof -pgo-kind=pgo-sample-use-pipeline -coro-early -barrier -sample-profile -barrier -coro-split  -disable-inlining=true -S | FileCheck %s
; RUN: opt < %s -enable-new-pm -sample-profile-file=%S/Inputs/sample.text.prof -pgo-kind=pgo-sample-use-pipeline -coro-early -sample-profile -coro-split  -disable-inlining=true -S | FileCheck %s

; Function Attrs: alwaysinline ssp uwtable
define void @ff() #0 !dbg !12 {
entry:
  %id = call token @llvm.coro.id(i32 16, i8* null, i8* null, i8* null)
  %begin = call i8* @llvm.coro.begin(token %id, i8* null)
  ret void
}

; CHECK:  call void @ff()
; Function Attrs: alwaysinline ssp uwtable
define void @foo() #0 !dbg !8 {
entry:
  %id1 = call token @llvm.coro.id(i32 16, i8* null, i8* null, i8* null)
  %begin = call i8* @llvm.coro.begin(token %id1, i8* null)
  call void @ff(), !dbg !11
  ret void
}

declare token @llvm.coro.id(i32, i8* readnone, i8* nocapture readonly, i8*)
declare i8* @llvm.coro.begin(token, i8* writeonly)

attributes #0 = { alwaysinline ssp uwtable "coroutine.presplit"="1" "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="all" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="penryn" "target-features"="+cx16,+cx8,+fxsr,+mmx,+sahf,+sse,+sse2,+sse3,+sse4.1,+ssse3,+x87" "unsafe-fp-math"="false" "use-sample-profile" "use-soft-float"="false" }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5, !6}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus_14, file: !1, producer: "", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2)
!1 = !DIFile(filename: "inline_O2.cpp", directory: "")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"PIC Level", i32 2}
!8 = distinct !DISubprogram(name: "foo", linkageName: "foo", scope: !1, file: !1, line: 46, type: !9, scopeLine: 46, flags: DIFlagPrototyped, unit: !0, retainedNodes: !2)
!9 = !DISubroutineType(types: !10)
!10 = !{null}
!11 = !DILocation(line: 2, column: 0, scope: !8)
!12 = distinct !DISubprogram(name: "ff", linkageName: "ff", scope: !1, file: !1, line: 46, type: !9, scopeLine: 46, flags: DIFlagPrototyped, unit: !0, retainedNodes: !2)
