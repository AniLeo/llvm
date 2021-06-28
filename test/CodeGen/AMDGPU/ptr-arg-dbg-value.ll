; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=amdgcn-amd-amdhsa -mcpu=gfx908 < %s | FileCheck %s

%struct.A = type { [100 x i32] }

; The 64-bit pointer argument %arg1 will be split into two registers
; and for its llvm.dbg.declare, DAG should emit two DBG_VALUE instructions
; with the fragment expressions.
define hidden void @ptr_arg_split_subregs(%struct.A* %arg1) #0 !dbg !9 {
; CHECK-LABEL: ptr_arg_split_subregs:
; CHECK:       .Lfunc_begin0:
; CHECK:       .loc 1 5 0 ; example.cpp:5:0
; CHECK-NEXT:    .cfi_sections .debug_frame
; CHECK-NEXT:    .cfi_startproc
; CHECK-NEXT:  ; %bb.0:
; CHECK-NEXT:    ;DEBUG_VALUE: ptr_arg_split_subregs:a <- [DW_OP_LLVM_fragment 32 32] [$vgpr1+0]
; CHECK-NEXT:    ;DEBUG_VALUE: ptr_arg_split_subregs:a <- [DW_OP_LLVM_fragment 0 32] [$vgpr0+0]
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    v_mov_b32_e32 v2, 1
; CHECK-NEXT:  .Ltmp0:
; CHECK-NEXT:    .loc 1 7 13 prologue_end ; example.cpp:7:13
; CHECK-NEXT:    flat_store_dword v[0:1], v2 offset:396
; CHECK-NEXT:    .loc 1 8 5 ; example.cpp:8:5
; CHECK-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; CHECK-NEXT:    s_setpc_b64 s[30:31]
; CHECK-NEXT:  .Ltmp1:
; CHECK:         .cfi_endproc
  call void @llvm.dbg.declare(metadata %struct.A* %arg1, metadata !20, metadata !DIExpression()), !dbg !21
  %gep1 = getelementptr inbounds %struct.A, %struct.A* %arg1, i32 0, i32 0, i32 99, !dbg !22
  store i32 1, i32* %gep1, align 4, !dbg !23
  ret void, !dbg !24
}

; FIXME: The 64-bit pointer argument %arg2 will be split between a register and
; the stack memory. The SelectionDAG though failed to emit the DBG_VALUE for the
; split part in memory. The two DBG_VALUE instructions emitted in the output pattern
; are totally misleading. The former represent part of the incoming argument in register
; while the latter was emitted for the parameter copy to a virtual register inserted
; at the function entry by DAGBuilder.
define hidden void @ptr_arg_split_reg_mem(<31 x i32>, %struct.A* %arg2) #0 !dbg !25 {
; CHECK-LABEL: ptr_arg_split_reg_mem:
; CHECK:       .Lfunc_begin1:
; CHECK-NEXT:    .loc 1 10 0 ; example.cpp:10:0
; CHECK-NEXT:    .cfi_startproc
; CHECK-NEXT:  ; %bb.0:
;; NOTE: One dbg_value (DEBUG_VALUE: ptr_arg_split_reg_mem:b <- [$vgpr31+0]) will be considered as
;; redundant after the virtregrewrite, so it will be removed.
; CHECK-NEXT:    ;DEBUG_VALUE: ptr_arg_split_reg_mem:b <- [$vgpr31+0]
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    buffer_load_dword v32, off, s[0:3], s32
; CHECK-NEXT:    v_mov_b32_e32 v0, 1
; CHECK-NEXT:  .Ltmp2:
; CHECK-NEXT:    .loc 1 12 13 prologue_end ; example.cpp:12:13
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    flat_store_dword v[31:32], v0 offset:396
; CHECK-NEXT:    .loc 1 13 5 ; example.cpp:13:5
; CHECK-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; CHECK-NEXT:    s_setpc_b64 s[30:31]
; CHECK-NEXT:  .Ltmp3:
; CHECK:         .cfi_endproc
  call void @llvm.dbg.declare(metadata %struct.A* %arg2, metadata !26, metadata !DIExpression()), !dbg !27
  %gep2 = getelementptr inbounds %struct.A, %struct.A* %arg2, i32 0, i32 0, i32 99, !dbg !28
  store i32 1, i32* %gep2, align 4, !dbg !29
  ret void, !dbg !30
}

; FIXME: The 64-bit pointer argument %arg3 will be entirely in the stack memory.
; No DBG_VALUE emitted for the incoming argument in this case and it should be fixed.
define hidden void @ptr_arg_in_memory(<32 x i32>, %struct.A* %arg3) #0 !dbg !31 {
; CHECK-LABEL: ptr_arg_in_memory:
; CHECK:       .Lfunc_begin2:
; CHECK-NEXT:    .loc 1 15 0 ; example.cpp:15:0
; CHECK-NEXT:    .cfi_startproc
; CHECK-NEXT:  ; %bb.0:
; CHECK-NEXT:    s_waitcnt vmcnt(0) expcnt(0) lgkmcnt(0)
; CHECK-NEXT:    buffer_load_dword v1, off, s[0:3], s32 offset:4
; CHECK-NEXT:    buffer_load_dword v0, off, s[0:3], s32
; CHECK-NEXT:    v_mov_b32_e32 v2, 1
; CHECK-NEXT:  .Ltmp4:
; CHECK-NEXT:    .loc 1 17 13 prologue_end ; example.cpp:17:13
; CHECK-NEXT:    s_waitcnt vmcnt(0)
; CHECK-NEXT:    flat_store_dword v[0:1], v2 offset:396
; CHECK-NEXT:    .loc 1 18 5 ; example.cpp:18:5
; CHECK-NEXT:    s_waitcnt vmcnt(0) lgkmcnt(0)
; CHECK-NEXT:    s_setpc_b64 s[30:31]
; CHECK-NEXT:  .Ltmp5:
; CHECK:         .cfi_endproc
  call void @llvm.dbg.declare(metadata %struct.A* %arg3, metadata !32, metadata !DIExpression()), !dbg !33
  %gep3 = getelementptr inbounds %struct.A, %struct.A* %arg3, i32 0, i32 0, i32 99, !dbg !34
  store i32 1, i32* %gep3, align 4, !dbg !35
  ret void, !dbg !36
}

declare void @llvm.dbg.declare(metadata, metadata, metadata) #0

attributes #0 = { nounwind }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = distinct !DICompileUnit(language: DW_LANG_C_plus_plus, file: !1, producer: "clang version 13.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "example.cpp", directory: "temp")
!2 = !{}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{i32 1, !"wchar_size", i32 4}
!6 = !{i32 7, !"uwtable", i32 1}
!7 = !{i32 7, !"frame-pointer", i32 2}
!8 = !{!"clang version 13.0.0"}
!9 = distinct !DISubprogram(name: "ptr_arg_split_subregs", scope: !10, file: !10, line: 5, type: !11, scopeLine: 5, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!10 = !DIFile(filename: "example.cpp", directory: "temp")
!11 = !DISubroutineType(types: !12)
!12 = !{!13}
!13 = distinct !DICompositeType(tag: DW_TAG_structure_type, name: "A", file: !10, line: 1, size: 3200, flags: DIFlagTypePassByValue, elements: !14, identifier: "_ZTS1A")
!14 = !{!15}
!15 = !DIDerivedType(tag: DW_TAG_member, name: "x", scope: !13, file: !10, line: 2, baseType: !16, size: 3200)
!16 = !DICompositeType(tag: DW_TAG_array_type, baseType: !17, size: 3200, elements: !18)
!17 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!18 = !{!19}
!19 = !DISubrange(count: 100)
!20 = !DILocalVariable(name: "a", scope: !9, file: !10, line: 6, type: !13)
!21 = !DILocation(line: 6, column: 7, scope: !9)
!22 = !DILocation(line: 7, column: 7, scope: !9)
!23 = !DILocation(line: 7, column: 13, scope: !9)
!24 = !DILocation(line: 8, column: 5, scope: !9)
!25 = distinct !DISubprogram(name: "ptr_arg_split_reg_mem", scope: !10, file: !10, line: 10, type: !11, scopeLine: 10, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!26 = !DILocalVariable(name: "b", scope: !25, file: !10, line: 11, type: !13)
!27 = !DILocation(line: 11, column: 7, scope: !25)
!28 = !DILocation(line: 12, column: 7, scope: !25)
!29 = !DILocation(line: 12, column: 13, scope: !25)
!30 = !DILocation(line: 13, column: 5, scope: !25)
!31 = distinct !DISubprogram(name: "ptr_arg_in_memory", scope: !10, file: !10, line: 15, type: !11, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !2)
!32 = !DILocalVariable(name: "c", scope: !31, file: !10, line: 16, type: !13)
!33 = !DILocation(line: 16, column: 7, scope: !31)
!34 = !DILocation(line: 17, column: 7, scope: !31)
!35 = !DILocation(line: 17, column: 13, scope: !31)
!36 = !DILocation(line: 18, column: 5, scope: !31)
