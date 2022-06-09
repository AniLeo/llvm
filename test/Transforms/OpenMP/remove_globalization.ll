; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-globals
; RUN: opt -S -passes=openmp-opt < %s | FileCheck %s
; RUN: opt -passes=openmp-opt -pass-remarks=openmp-opt -pass-remarks-missed=openmp-opt -disable-output < %s 2>&1 | FileCheck %s -check-prefix=CHECK-REMARKS
; RUN: opt -passes=openmp-opt -pass-remarks-missed=openmp-opt -openmp-opt-max-iterations=1 -disable-output < %s 2>&1 | FileCheck %s -check-prefix=CHECK-FIXPOINT
; RUN: opt -openmp-opt-disable-deglobalization -S -passes=openmp-opt < %s | FileCheck %s --check-prefix=CHECK-DISABLED
target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"
target triple = "nvptx64"

; UTC_ARGS: --disable
; CHECK-REMARKS: remark: remove_globalization.c:4:2: Could not move globalized variable to the stack. Variable is potentially captured in call. Mark parameter as `__attribute__((noescape))` to override.
; CHECK-REMARKS: remark: remove_globalization.c:2:2: Moving globalized variable to the stack.
; CHECK-REMARKS: remark: remove_globalization.c:6:2: Moving globalized variable to the stack.
; CHECK-REMARKS: remark: remove_globalization.c:4:2: Found thread data sharing on the GPU. Expect degraded performance due to data globalization.
; CHECK-FIXPOINT: Attributor did not reach a fixpoint after 1 iterations.
; UTC_ARGS: --enable

@S = external local_unnamed_addr global i8*

%struct.ident_t = type { i32, i32, i32, i32, i8* }

declare i32 @__kmpc_target_init(%struct.ident_t*, i8, i1, i1)
declare void @__kmpc_target_deinit(%struct.ident_t*, i8, i1)

;.
; CHECK: @[[S:[a-zA-Z0-9_$"\\.-]+]] = external local_unnamed_addr global i8*
;.
; CHECK-DISABLED: @[[S:[a-zA-Z0-9_$"\\.-]+]] = external local_unnamed_addr global i8*
;.
define void @kernel() {
; CHECK-LABEL: define {{[^@]+}}@kernel() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* nonnull null, i8 1, i1 false, i1 true)
; CHECK-NEXT:    call void @foo() #[[ATTR0:[0-9]+]]
; CHECK-NEXT:    call void @bar() #[[ATTR0]]
; CHECK-NEXT:    call void @unknown_no_openmp()
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* nonnull null, i8 1, i1 true)
; CHECK-NEXT:    ret void
;
; CHECK-DISABLED-LABEL: define {{[^@]+}}@kernel() {
; CHECK-DISABLED-NEXT:  entry:
; CHECK-DISABLED-NEXT:    [[TMP0:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* nonnull null, i8 1, i1 false, i1 true)
; CHECK-DISABLED-NEXT:    call void @foo() #[[ATTR0:[0-9]+]]
; CHECK-DISABLED-NEXT:    call void @bar() #[[ATTR0]]
; CHECK-DISABLED-NEXT:    call void @unknown_no_openmp()
; CHECK-DISABLED-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* nonnull null, i8 1, i1 true)
; CHECK-DISABLED-NEXT:    ret void
;
entry:
  %0 = call i32 @__kmpc_target_init(%struct.ident_t* nonnull null, i8 1, i1 true, i1 true)
  call void @foo()
  call void @bar()
  call void @unknown_no_openmp()
  call void @__kmpc_target_deinit(%struct.ident_t* nonnull null, i8 1, i1 true)
  ret void
}

define internal void @foo() {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca i8, i64 4, align 1
; CHECK-NEXT:    ret void
;
; CHECK-DISABLED-LABEL: define {{[^@]+}}@foo
; CHECK-DISABLED-SAME: () #[[ATTR0]] {
; CHECK-DISABLED-NEXT:  entry:
; CHECK-DISABLED-NEXT:    [[TMP0:%.*]] = alloca i8, i64 4, align 1
; CHECK-DISABLED-NEXT:    ret void
;
entry:
  %0 = call i8* @__kmpc_alloc_shared(i64 4), !dbg !12
  call void @use(i8* %0)
  call void @__kmpc_free_shared(i8* %0, i64 4)
  ret void
}

define internal void @bar() {
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: () #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i8* @__kmpc_alloc_shared(i64 4) #[[ATTR0]], !dbg [[DBG8:![0-9]+]]
; CHECK-NEXT:    call void @share(i8* nofree [[TMP0]]) #[[ATTR6:[0-9]+]], !dbg [[DBG8]]
; CHECK-NEXT:    call void @__kmpc_free_shared(i8* [[TMP0]], i64 4) #[[ATTR0]]
; CHECK-NEXT:    ret void
;
; CHECK-DISABLED-LABEL: define {{[^@]+}}@bar
; CHECK-DISABLED-SAME: () #[[ATTR1:[0-9]+]] {
; CHECK-DISABLED-NEXT:  entry:
; CHECK-DISABLED-NEXT:    [[TMP0:%.*]] = call i8* @__kmpc_alloc_shared(i64 4) #[[ATTR0]], !dbg [[DBG8:![0-9]+]]
; CHECK-DISABLED-NEXT:    call void @share(i8* nofree [[TMP0]]) #[[ATTR6:[0-9]+]], !dbg [[DBG8]]
; CHECK-DISABLED-NEXT:    call void @__kmpc_free_shared(i8* [[TMP0]], i64 4) #[[ATTR0]]
; CHECK-DISABLED-NEXT:    ret void
;
entry:
  %0 = call i8* @__kmpc_alloc_shared(i64 4), !dbg !13
  call void @share(i8* %0), !dbg !13
  call void @__kmpc_free_shared(i8* %0, i64 4)
  ret void
}

define internal void @use(i8* %x) {
; CHECK-LABEL: define {{[^@]+}}@use
; CHECK-SAME: (i8* [[X:%.*]]) #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    ret void
;
; CHECK-DISABLED-LABEL: define {{[^@]+}}@use
; CHECK-DISABLED-SAME: (i8* [[X:%.*]]) #[[ATTR2:[0-9]+]] {
; CHECK-DISABLED-NEXT:  entry:
; CHECK-DISABLED-NEXT:    ret void
;
entry:
  ret void
}

define internal void @share(i8* %x) {
; CHECK-LABEL: define {{[^@]+}}@share
; CHECK-SAME: (i8* nofree [[X:%.*]]) #[[ATTR3:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i8* [[X]], i8** @S, align 8
; CHECK-NEXT:    ret void
;
; CHECK-DISABLED-LABEL: define {{[^@]+}}@share
; CHECK-DISABLED-SAME: (i8* nofree [[X:%.*]]) #[[ATTR3:[0-9]+]] {
; CHECK-DISABLED-NEXT:  entry:
; CHECK-DISABLED-NEXT:    store i8* [[X]], i8** @S, align 8
; CHECK-DISABLED-NEXT:    ret void
;
entry:
  store i8* %x, i8** @S
  ret void
}

define void @unused() {
; CHECK-LABEL: define {{[^@]+}}@unused() {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = alloca i8, i64 4, align 1
; CHECK-NEXT:    call void @use(i8* undef)
; CHECK-NEXT:    ret void
;
; CHECK-DISABLED-LABEL: define {{[^@]+}}@unused() {
; CHECK-DISABLED-NEXT:  entry:
; CHECK-DISABLED-NEXT:    [[TMP0:%.*]] = call i8* @__kmpc_alloc_shared(i64 4), !dbg [[DBG11:![0-9]+]]
; CHECK-DISABLED-NEXT:    call void @use(i8* [[TMP0]])
; CHECK-DISABLED-NEXT:    call void @__kmpc_free_shared(i8* [[TMP0]], i64 4)
; CHECK-DISABLED-NEXT:    ret void
;
entry:
  %0 = call i8* @__kmpc_alloc_shared(i64 4), !dbg !14
  call void @use(i8* %0)
  call void @__kmpc_free_shared(i8* %0, i64 4)
  ret void
}

; CHECK: declare i8* @__kmpc_alloc_shared(i64)
declare i8* @__kmpc_alloc_shared(i64)

; CHECK: declare void @__kmpc_free_shared(i8* nocapture, i64)
declare void @__kmpc_free_shared(i8*, i64)

declare void @unknown_no_openmp() "llvm.assume"="omp_no_openmp"

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !6, !7}
!nvvm.annotations = !{!5}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 13.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "remove_globalization.c", directory: "/tmp/remove_globalization.c")
!2 = !{}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{void ()* @kernel, !"kernel", i32 1}
!6 = !{i32 7, !"openmp", i32 50}
!7 = !{i32 7, !"openmp-device", i32 50}
!8 = distinct !DISubprogram(name: "foo", scope: !1, file: !1, line: 1, type: !11, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!9 = distinct !DISubprogram(name: "bar", scope: !1, file: !1, line: 1, type: !11, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!10 = distinct !DISubprogram(name: "unused", scope: !1, file: !1, line: 1, type: !11, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!11 = !DISubroutineType(types: !2)
!12 = !DILocation(line: 2, column: 2, scope: !8)
!13 = !DILocation(line: 4, column: 2, scope: !9)
!14 = !DILocation(line: 6, column: 2, scope: !9)
;.
; CHECK: attributes #[[ATTR0]] = { nounwind }
; CHECK: attributes #[[ATTR1]] = { nosync nounwind }
; CHECK: attributes #[[ATTR2]] = { nounwind readnone }
; CHECK: attributes #[[ATTR3]] = { nofree nosync nounwind writeonly }
; CHECK: attributes #[[ATTR4:[0-9]+]] = { nosync nounwind allocsize(0) }
; CHECK: attributes #[[ATTR5:[0-9]+]] = { "llvm.assume"="omp_no_openmp" }
; CHECK: attributes #[[ATTR6]] = { nosync nounwind writeonly }
;.
; CHECK-DISABLED: attributes #[[ATTR0]] = { nounwind }
; CHECK-DISABLED: attributes #[[ATTR1]] = { nosync nounwind }
; CHECK-DISABLED: attributes #[[ATTR2]] = { nounwind readnone }
; CHECK-DISABLED: attributes #[[ATTR3]] = { nofree nosync nounwind writeonly }
; CHECK-DISABLED: attributes #[[ATTR4:[0-9]+]] = { nosync nounwind allocsize(0) }
; CHECK-DISABLED: attributes #[[ATTR5:[0-9]+]] = { "llvm.assume"="omp_no_openmp" }
; CHECK-DISABLED: attributes #[[ATTR6]] = { nosync nounwind writeonly }
;.
; CHECK: [[META0:![0-9]+]] = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 13.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
; CHECK: [[META1:![0-9]+]] = !DIFile(filename: "remove_globalization.c", directory: "/tmp/remove_globalization.c")
; CHECK: [[META2:![0-9]+]] = !{}
; CHECK: [[META3:![0-9]+]] = !{i32 2, !"Debug Info Version", i32 3}
; CHECK: [[META4:![0-9]+]] = !{i32 1, !"wchar_size", i32 4}
; CHECK: [[META5:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK: [[META6:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
; CHECK: [[META7:![0-9]+]] = !{void ()* @kernel, !"kernel", i32 1}
; CHECK: [[DBG8]] = !DILocation(line: 4, column: 2, scope: !9)
; CHECK: [[META9:![0-9]+]] = distinct !DISubprogram(name: "bar", scope: !1, file: !1, line: 1, type: !10, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
; CHECK: [[META10:![0-9]+]] = !DISubroutineType(types: !2)
;.
; CHECK-DISABLED: [[META0:![0-9]+]] = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 13.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
; CHECK-DISABLED: [[META1:![0-9]+]] = !DIFile(filename: "remove_globalization.c", directory: "/tmp/remove_globalization.c")
; CHECK-DISABLED: [[META2:![0-9]+]] = !{}
; CHECK-DISABLED: [[META3:![0-9]+]] = !{i32 2, !"Debug Info Version", i32 3}
; CHECK-DISABLED: [[META4:![0-9]+]] = !{i32 1, !"wchar_size", i32 4}
; CHECK-DISABLED: [[META5:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK-DISABLED: [[META6:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
; CHECK-DISABLED: [[META7:![0-9]+]] = !{void ()* @kernel, !"kernel", i32 1}
; CHECK-DISABLED: [[DBG8]] = !DILocation(line: 4, column: 2, scope: !9)
; CHECK-DISABLED: [[META9:![0-9]+]] = distinct !DISubprogram(name: "bar", scope: !1, file: !1, line: 1, type: !10, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
; CHECK-DISABLED: [[META10:![0-9]+]] = !DISubroutineType(types: !2)
; CHECK-DISABLED: [[DBG11]] = !DILocation(line: 6, column: 2, scope: !9)
;.
