; RUN: llc -mtriple=s390x-linux-gnu -disable-fp-elim < %s | FileCheck %s
; RUN: llc -mtriple=s390x-linux-gnu -disable-fp-elim -filetype=obj < %s \
; RUN:     | llvm-dwarfdump -debug-dump=info - | FileCheck --check-prefix=DEBUG %s
;
; This is a regression test making sure the location of variables is correct in
; debugging information, even if they're addressed via the frame pointer.
; Originally a copy of the AArch64 test, commandeered for SystemZ.
;
; First make sure main_arr is where we expect it: %r11 + 164
;
; CHECK: main:
; CHECK: aghi    %r15, -568
; CHECK: la      %r2, 164(%r11)
; CHECK: brasl   %r14, populate_array@PLT

; DEBUG: DW_TAG_variable
; Rather hard-coded, but 0x91 => DW_OP_fbreg and 0xa401 is SLEB128 encoded 164.
; DEBUG-NOT: DW_TAG
; DEBUG: DW_AT_location {{.*}}(<0x3> 91 a4 01 )
; DEBUG-NOT: DW_TAG
; DEBUG: DW_AT_name {{.*}} "main_arr"


@.str = private unnamed_addr constant [13 x i8] c"Total is %d\0A\00", align 2

declare void @populate_array(i32*, i32) nounwind

declare void @llvm.dbg.declare(metadata, metadata, metadata) nounwind readnone

declare i32 @sum_array(i32*, i32) nounwind

define i32 @main() nounwind {
entry:
  %retval = alloca i32, align 4
  %main_arr = alloca [100 x i32], align 4
  %val = alloca i32, align 4
  store volatile i32 0, i32* %retval
  call void @llvm.dbg.declare(metadata [100 x i32]* %main_arr, metadata !17, metadata !MDExpression()), !dbg !22
  call void @llvm.dbg.declare(metadata i32* %val, metadata !23, metadata !MDExpression()), !dbg !24
  %arraydecay = getelementptr inbounds [100 x i32], [100 x i32]* %main_arr, i32 0, i32 0, !dbg !25
  call void @populate_array(i32* %arraydecay, i32 100), !dbg !25
  %arraydecay1 = getelementptr inbounds [100 x i32], [100 x i32]* %main_arr, i32 0, i32 0, !dbg !26
  %call = call i32 @sum_array(i32* %arraydecay1, i32 100), !dbg !26
  store i32 %call, i32* %val, align 4, !dbg !26
  %0 = load i32, i32* %val, align 4, !dbg !27
  %call2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @.str, i32 0, i32 0), i32 %0), !dbg !27
  ret i32 0, !dbg !28
}

declare i32 @printf(i8*, ...)

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!30}

!0 = !MDCompileUnit(language: DW_LANG_C99, producer: "clang version 3.2 ", isOptimized: false, emissionKind: 0, file: !29, enums: !1, retainedTypes: !1, subprograms: !3, globals: !1, imports:  !1)
!1 = !{}
!3 = !{!5, !11, !14}
!5 = !MDSubprogram(name: "populate_array", line: 4, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 4, file: !29, scope: !6, type: !7, function: void (i32*, i32)* @populate_array, variables: !1)
!6 = !MDFile(filename: "simple.c", directory: "/home/timnor01/a64-trunk/build")
!7 = !MDSubroutineType(types: !8)
!8 = !{null, !9, !10}
!9 = !MDDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, baseType: !10)
!10 = !MDBasicType(tag: DW_TAG_base_type, name: "int", size: 32, align: 32, encoding: DW_ATE_signed)
!11 = !MDSubprogram(name: "sum_array", line: 9, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 9, file: !29, scope: !6, type: !12, function: i32 (i32*, i32)* @sum_array, variables: !1)
!12 = !MDSubroutineType(types: !13)
!13 = !{!10, !9, !10}
!14 = !MDSubprogram(name: "main", line: 18, isLocal: false, isDefinition: true, virtualIndex: 6, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 18, file: !29, scope: !6, type: !15, function: i32 ()* @main, variables: !1)
!15 = !MDSubroutineType(types: !16)
!16 = !{!10}
!17 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "main_arr", line: 19, scope: !18, file: !6, type: !19)
!18 = distinct !MDLexicalBlock(line: 18, column: 16, file: !29, scope: !14)
!19 = !MDCompositeType(tag: DW_TAG_array_type, size: 3200, align: 32, baseType: !10, elements: !{!20})
!20 = !MDSubrange(count: 99)
!22 = !MDLocation(line: 19, column: 7, scope: !18)
!23 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "val", line: 20, scope: !18, file: !6, type: !10)
!24 = !MDLocation(line: 20, column: 7, scope: !18)
!25 = !MDLocation(line: 22, column: 3, scope: !18)
!26 = !MDLocation(line: 23, column: 9, scope: !18)
!27 = !MDLocation(line: 24, column: 3, scope: !18)
!28 = !MDLocation(line: 26, column: 3, scope: !18)
!29 = !MDFile(filename: "simple.c", directory: "/home/timnor01/a64-trunk/build")
!30 = !{i32 1, !"Debug Info Version", i32 3}
