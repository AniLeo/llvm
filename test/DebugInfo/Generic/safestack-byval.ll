; Test dwarf codegen for DILocalVariable of a byval function argument that
; points to neither an argument nor an alloca. This kind of IR is generated by
; SafeStack for unsafe byval arguments.
; RUN: llc -stop-after expand-isel-pseudos %s -o /dev/null | FileCheck %s
; XFAIL: hexagon

; This was built by compiling the following source with SafeStack and
; simplifying the result a little.
; struct S {
;   int a[100];
; };
;
; int f(S zzz, unsigned long len) {
;   return zzz.a[len];
; }

; REQUIRES: tls

; CHECK: ![[ZZZ:.*]] = !DILocalVariable(name: "zzz",
; CHECK: ![[ZZZ_EXPR:.*]] = !DIExpression(DW_OP_deref, DW_OP_minus, 400)
; CHECK: DBG_VALUE {{.*}} ![[ZZZ]], ![[ZZZ_EXPR]]

%struct.S = type { [100 x i32] }

@__safestack_unsafe_stack_ptr = external thread_local(initialexec) global i8*

; Function Attrs: norecurse nounwind readonly safestack uwtable
define i32 @_Z1f1Sm(%struct.S* byval nocapture readonly align 8 %zzz, i64 %len) #0 !dbg !12 {
entry:
  %unsafe_stack_ptr = load i8*, i8** @__safestack_unsafe_stack_ptr, !dbg !22
  %unsafe_stack_static_top = getelementptr i8, i8* %unsafe_stack_ptr, i32 -400, !dbg !22
  store i8* %unsafe_stack_static_top, i8** @__safestack_unsafe_stack_ptr, !dbg !22
; !17 describes "zzz"
  call void @llvm.dbg.declare(metadata i8* %unsafe_stack_ptr, metadata !17, metadata !23), !dbg !22
  %0 = getelementptr i8, i8* %unsafe_stack_ptr, i32 -400, !dbg !22
  %zzz.unsafe-byval = bitcast i8* %0 to %struct.S*, !dbg !22
  %1 = bitcast %struct.S* %zzz to i8*, !dbg !24
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %0, i8* %1, i64 400, i32 8, i1 false), !dbg !24
  tail call void @llvm.dbg.value(metadata i64 %len, i64 0, metadata !18, metadata !25), !dbg !24
  %arrayidx = getelementptr inbounds %struct.S, %struct.S* %zzz.unsafe-byval, i64 0, i32 0, i64 %len, !dbg !26
  %2 = load i32, i32* %arrayidx, align 4, !dbg !26, !tbaa !27
  store i8* %unsafe_stack_ptr, i8** @__safestack_unsafe_stack_ptr, !dbg !31
  ret i32 %2, !dbg !31
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #1

; Function Attrs: argmemonly nounwind
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture readonly, i64, i32, i1) #2

attributes #0 = { norecurse nounwind readonly safestack uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }
attributes #2 = { argmemonly nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!19, !20}
!llvm.ident = !{!21}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 3.8.0 (trunk 254107) (llvm/trunk 254109)", isOptimized: true, runtimeVersion: 0, emissionKind: 1, enums: !2, retainedTypes: !3, subprograms: !11)
!1 = !DIFile(filename: "../llvm/1.cc", directory: "/tmp/build")
!2 = !{}
!3 = !{!4}
!4 = !DICompositeType(tag: DW_TAG_structure_type, name: "S", file: !1, line: 4, size: 3200, align: 32, elements: !5, identifier: "_ZTS1S")
!5 = !{!6}
!6 = !DIDerivedType(tag: DW_TAG_member, name: "a", scope: !"_ZTS1S", file: !1, line: 5, baseType: !7, size: 3200, align: 32)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 3200, align: 32, elements: !9)
!8 = !DIBasicType(name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!9 = !{!10}
!10 = !DISubrange(count: 100)
!11 = !{!12}
!12 = distinct !DISubprogram(name: "f", linkageName: "_Z1f1Sm", scope: !1, file: !1, line: 8, type: !13, isLocal: false, isDefinition: true, scopeLine: 8, flags: DIFlagPrototyped, isOptimized: true, variables: !16)
!13 = !DISubroutineType(types: !14)
!14 = !{!8, !"_ZTS1S", !15}
!15 = !DIBasicType(name: "long unsigned int", size: 64, align: 64, encoding: DW_ATE_unsigned)
!16 = !{!17, !18}
!17 = !DILocalVariable(name: "zzz", arg: 1, scope: !12, file: !1, line: 8, type: !"_ZTS1S")
!18 = !DILocalVariable(name: "len", arg: 2, scope: !12, file: !1, line: 8, type: !15)
!19 = !{i32 2, !"Dwarf Version", i32 4}
!20 = !{i32 2, !"Debug Info Version", i32 3}
!21 = !{!"clang version 3.8.0 (trunk 254107) (llvm/trunk 254109)"}
!22 = !DILocation(line: 8, column: 9, scope: !12)
!23 = !DIExpression(DW_OP_deref, DW_OP_minus, 400)
!24 = !DILocation(line: 8, column: 28, scope: !12)
!25 = !DIExpression()
!26 = !DILocation(line: 9, column: 10, scope: !12)
!27 = !{!28, !28, i64 0}
!28 = !{!"int", !29, i64 0}
!29 = !{!"omnipotent char", !30, i64 0}
!30 = !{!"Simple C/C++ TBAA"}
!31 = !DILocation(line: 9, column: 3, scope: !12)
