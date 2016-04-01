; RUN: opt < %s -S -inline | FileCheck %s
;
; The purpose of this test is to check that inline pass preserves debug info
; for variable using the dbg.declare intrinsic.
;
;; This test was generated by running this command:
;; clang.exe -S -O0 -emit-llvm -g foo.c
;;
;; foo.c
;; ==========================
;; float foo(float x)
;; {
;;    return x;
;; }
;;
;; void bar(float *dst)
;; {
;;    dst[0] = foo(dst[0]);
;; }
;; ==========================

target datalayout = "e-m:w-p:32:32-i64:64-f80:32-n8:16:32-S32"
target triple = "i686-pc-windows-msvc"

; Function Attrs: nounwind
define float @foo(float %x) #0 !dbg !4 {
entry:
  %x.addr = alloca float, align 4
  store float %x, float* %x.addr, align 4
  call void @llvm.dbg.declare(metadata float* %x.addr, metadata !16, metadata !17), !dbg !18
  %0 = load float, float* %x.addr, align 4, !dbg !19
  ret float %0, !dbg !19
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; CHECK: define void @bar

; Function Attrs: nounwind
define void @bar(float* %dst) #0 !dbg !9 {
entry:

; CHECK: [[x_addr_i:%[a-zA-Z0-9.]+]] = alloca float, align 4
; CHECK-NEXT: void @llvm.dbg.declare(metadata float* [[x_addr_i]], metadata [[m23:![0-9]+]], metadata !{{[0-9]+}}), !dbg [[m24:![0-9]+]]

  %dst.addr = alloca float*, align 4
  store float* %dst, float** %dst.addr, align 4
  call void @llvm.dbg.declare(metadata float** %dst.addr, metadata !20, metadata !17), !dbg !21
  %0 = load float*, float** %dst.addr, align 4, !dbg !22
  %arrayidx = getelementptr inbounds float, float* %0, i32 0, !dbg !22
  %1 = load float, float* %arrayidx, align 4, !dbg !22
  %call = call float @foo(float %1), !dbg !22

; CHECK-NOT: call float @foo

  %2 = load float*, float** %dst.addr, align 4, !dbg !22
  %arrayidx1 = getelementptr inbounds float, float* %2, i32 0, !dbg !22
  store float %call, float* %arrayidx1, align 4, !dbg !22
  ret void, !dbg !23
}

attributes #0 = { nounwind }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!13, !14}
!llvm.ident = !{!15}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, producer: "clang version 3.6.0 (trunk)", isOptimized: false, emissionKind: FullDebug, file: !1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !DIFile(filename: "foo.c", directory: "")
!2 = !{}
!3 = !{!4, !9}
!4 = distinct !DISubprogram(name: "foo", line: 1, isLocal: false, isDefinition: true, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 2, file: !1, scope: !5, type: !6, variables: !2)
!5 = !DIFile(filename: "foo.c", directory: "")
!6 = !DISubroutineType(types: !7)
!7 = !{!8, !8}
!8 = !DIBasicType(tag: DW_TAG_base_type, name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!9 = distinct !DISubprogram(name: "bar", line: 6, isLocal: false, isDefinition: true, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 7, file: !1, scope: !5, type: !10, variables: !2)
!10 = !DISubroutineType(types: !11)
!11 = !{null, !12}
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, size: 32, align: 32, baseType: !8)
!13 = !{i32 2, !"Dwarf Version", i32 4}
!14 = !{i32 2, !"Debug Info Version", i32 3}
!15 = !{!"clang version 3.6.0 (trunk)"}
!16 = !DILocalVariable(name: "x", line: 1, arg: 1, scope: !4, file: !5, type: !8)
!17 = !DIExpression()
!18 = !DILocation(line: 1, column: 17, scope: !4)
!19 = !DILocation(line: 3, column: 5, scope: !4)
!20 = !DILocalVariable(name: "dst", line: 6, arg: 1, scope: !9, file: !5, type: !12)
!21 = !DILocation(line: 6, column: 17, scope: !9)
!22 = !DILocation(line: 8, column: 14, scope: !9)
!23 = !DILocation(line: 9, column: 1, scope: !9)

; CHECK: [[FOO:![0-9]+]] = distinct !DISubprogram(name: "foo",
; CHECK: [[BAR:![0-9]+]] = distinct !DISubprogram(name: "bar",
; CHECK: [[m23]] = !DILocalVariable(name: "x", arg: 1, scope: [[FOO]]
; CHECK: [[m24]] = !DILocation(line: 1, column: 17, scope: [[FOO]], inlinedAt: [[CALL_SITE:![0-9]+]])
; CHECK: [[CALL_SITE]] = distinct !DILocation(line: 8, column: 14, scope: [[BAR]])
