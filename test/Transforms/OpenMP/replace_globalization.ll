; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals --include-generated-funcs
; RUN: opt -S -passes='openmp-opt' < %s | FileCheck %s
; RUN: opt -passes=openmp-opt -pass-remarks=openmp-opt -disable-output < %s 2>&1 | FileCheck %s -check-prefix=CHECK-REMARKS
; RUN: opt -passes=openmp-opt -pass-remarks=openmp-opt -pass-remarks-missed=openmp-opt -disable-output -openmp-opt-shared-limit=4 < %s 2>&1 | FileCheck %s -check-prefix=CHECK-LIMIT
target datalayout = "e-i64:64-i128:128-v16:16-v32:32-n16:32:64"
target triple = "nvptx64"

; UTC_ARGS: --disable
; CHECK-REMARKS: remark: replace_globalization.c:5:7: Replaced globalized variable with 16 bytes of shared memory
; CHECK-REMARKS: remark: replace_globalization.c:5:14: Replaced globalized variable with 4 bytes of shared memory
; CHECK-REMARKS-NOT: 6 bytes
; CHECK-LIMIT: remark: replace_globalization.c:5:14: Replaced globalized variable with 4 bytes of shared memory
; CHECK-LIMIT: remark: replace_globalization.c:5:7: Found thread data sharing on the GPU. Expect degraded performance due to data globalization
; UTC_ARGS: --enable

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@S = external local_unnamed_addr global i8*
@0 = private unnamed_addr constant [113 x i8] c";llvm/test/Transforms/OpenMP/custom_state_machines_remarks.c;__omp_offloading_2a_d80d3d_test_fallback_l11;11;1;;\00", align 1
@1 = private unnamed_addr constant %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([113 x i8], [113 x i8]* @0, i32 0, i32 0) }, align 8
@foo_exec_mode = weak constant i8 1
@bar_exec_mode = weak constant i8 1
@baz_spmd_exec_mode = weak constant i8 2


define dso_local void @foo() "kernel" {
entry:
  %c = call i32 @__kmpc_target_init(%struct.ident_t* @1, i8 1, i1 true, i1 true)
  %x = call align 4 i8* @__kmpc_alloc_shared(i64 4)
  call void @unknown_no_openmp()
  %x_on_stack = bitcast i8* %x to i32*
  %0 = bitcast i32* %x_on_stack to i8*
  call void @use(i8* %0)
  call void @__kmpc_free_shared(i8* %x, i64 4)
  call void @__kmpc_target_deinit(%struct.ident_t* @1, i8 1, i1 true)
  ret void
}

define void @bar() "kernel" {
  %c = call i32 @__kmpc_target_init(%struct.ident_t* @1, i8 1, i1 true, i1 true)
  call void @unknown_no_openmp()
  %cmp = icmp eq i32 %c, -1
  br i1 %cmp, label %master1, label %exit
master1:
  %x = call align 4 i8* @__kmpc_alloc_shared(i64 16), !dbg !11
  %x_on_stack = bitcast i8* %x to [4 x i32]*
  %a0 = bitcast [4 x i32]* %x_on_stack to i8*
  call void @use(i8* %a0)
  call void @__kmpc_free_shared(i8* %x, i64 16)
  br label %next
next:
  call void @unknown_no_openmp()
  %b0 = icmp eq i32 %c, -1
  br i1 %b0, label %master2, label %exit
master2:
  %y = call align 4 i8* @__kmpc_alloc_shared(i64 4), !dbg !12
  %y_on_stack = bitcast i8* %y to [4 x i32]*
  %b1 = bitcast [4 x i32]* %y_on_stack to i8*
  call void @use(i8* %b1)
  call void @__kmpc_free_shared(i8* %y, i64 4)
  br label %exit
exit:
  call void @__kmpc_target_deinit(%struct.ident_t* @1, i8 1, i1 true)
  ret void
}

define void @baz_spmd() "kernel" {
  %c = call i32 @__kmpc_target_init(%struct.ident_t* @1, i8 2, i1 true, i1 true)
  call void @unknown_no_openmp()
  %c0 = icmp eq i32 %c, -1
  br i1 %c0, label %master3, label %exit
master3:
  %z = call align 4 i8* @__kmpc_alloc_shared(i64 24), !dbg !12
  %z_on_stack = bitcast i8* %z to [6 x i32]*
  %c1 = bitcast [6 x i32]* %z_on_stack to i8*
  call void @use(i8* %c1)
  call void @__kmpc_free_shared(i8* %z, i64 24)
  br label %exit
exit:
  call void @__kmpc_target_deinit(%struct.ident_t* @1, i8 2, i1 true)
  ret void
}

define void @use(i8* %x) {
entry:
  store i8* %x, i8** @S
  ret void
}

@offset =global i32 undef
@stack = internal addrspace(3) global [1024 x i8] undef
define private i8* @__kmpc_alloc_shared(i64) {
  %bc = bitcast [1024 x i8] addrspace(3) * @stack to i8 addrspace(3) *
  %ac = addrspacecast i8 addrspace(3) * %bc to i8*
  %l = load i32, i32* @offset
  %gep = getelementptr i8, i8* %ac, i32 %l
  ret i8* %gep
}

declare void @__kmpc_free_shared(i8*, i64)

declare i32 @llvm.nvvm.read.ptx.sreg.tid.x()

declare i32 @llvm.nvvm.read.ptx.sreg.ntid.x()

declare i32 @llvm.nvvm.read.ptx.sreg.warpsize()

declare i32 @__kmpc_target_init(%struct.ident_t*, i8, i1, i1)

declare void @__kmpc_target_deinit(%struct.ident_t*, i8, i1)

declare void @unknown_no_openmp() "llvm.assume"="omp_no_openmp"

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!3, !4, !5, !6}
!nvvm.annotations = !{!7, !8, !13}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 12.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "replace_globalization.c", directory: "/tmp/replace_globalization.c")
!2 = !{}
!3 = !{i32 2, !"Debug Info Version", i32 3}
!4 = !{i32 1, !"wchar_size", i32 4}
!5 = !{i32 7, !"openmp", i32 50}
!6 = !{i32 7, !"openmp-device", i32 50}
!7 = !{void ()* @foo, !"kernel", i32 1}
!8 = !{void ()* @bar, !"kernel", i32 1}
!13 = !{void ()* @baz_spmd, !"kernel", i32 1}
!9 = distinct !DISubprogram(name: "bar", scope: !1, file: !1, line: 1, type: !10, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
!10 = !DISubroutineType(types: !2)
!11 = !DILocation(line: 5, column: 7, scope: !9)
!12 = !DILocation(line: 5, column: 14, scope: !9)
;.
; CHECK: @[[S:[a-zA-Z0-9_$"\\.-]+]] = external local_unnamed_addr global i8*
; CHECK: @[[GLOB0:[0-9]+]] = private unnamed_addr constant [113 x i8] c"
; CHECK: @[[GLOB1:[0-9]+]] = private unnamed_addr constant [[STRUCT_IDENT_T:%.*]] { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([113 x i8], [113 x i8]* @[[GLOB0]], i32 0, i32 0) }, align 8
; CHECK: @[[FOO_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 1
; CHECK: @[[BAR_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 1
; CHECK: @[[BAZ_SPMD_EXEC_MODE:[a-zA-Z0-9_$"\\.-]+]] = weak constant i8 2
; CHECK: @[[OFFSET:[a-zA-Z0-9_$"\\.-]+]] = global i32 undef
; CHECK: @[[STACK:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(3) global [1024 x i8] undef
; CHECK: @[[X_SHARED:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(3) global [16 x i8] undef, align 4
; CHECK: @[[Y_SHARED:[a-zA-Z0-9_$"\\.-]+]] = internal addrspace(3) global [4 x i8] undef, align 4
;.
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[C:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* @[[GLOB1]], i8 1, i1 false, i1 true)
; CHECK-NEXT:    [[X:%.*]] = call align 4 i8* @__kmpc_alloc_shared(i64 4) #[[ATTR7:[0-9]+]]
; CHECK-NEXT:    call void @unknown_no_openmp() #[[ATTR6:[0-9]+]]
; CHECK-NEXT:    [[X_ON_STACK:%.*]] = bitcast i8* [[X]] to i32*
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast i32* [[X_ON_STACK]] to i8*
; CHECK-NEXT:    call void @use.internalized(i8* nofree [[TMP0]]) #[[ATTR8:[0-9]+]]
; CHECK-NEXT:    call void @__kmpc_free_shared(i8* [[X]], i64 4) #[[ATTR9:[0-9]+]]
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* @[[GLOB1]], i8 1, i1 true)
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    [[C:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* @[[GLOB1]], i8 1, i1 false, i1 true)
; CHECK-NEXT:    call void @unknown_no_openmp() #[[ATTR6]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[C]], -1
; CHECK-NEXT:    br i1 [[CMP]], label [[MASTER1:%.*]], label [[EXIT:%.*]]
; CHECK:       master1:
; CHECK-NEXT:    [[X_ON_STACK:%.*]] = bitcast i8* addrspacecast (i8 addrspace(3)* getelementptr inbounds ([16 x i8], [16 x i8] addrspace(3)* @x_shared, i32 0, i32 0) to i8*) to [4 x i32]*
; CHECK-NEXT:    [[A0:%.*]] = bitcast [4 x i32]* [[X_ON_STACK]] to i8*
; CHECK-NEXT:    call void @use.internalized(i8* nofree [[A0]]) #[[ATTR8]]
; CHECK-NEXT:    br label [[NEXT:%.*]]
; CHECK:       next:
; CHECK-NEXT:    call void @unknown_no_openmp() #[[ATTR6]]
; CHECK-NEXT:    br label [[MASTER2:%.*]]
; CHECK:       master2:
; CHECK-NEXT:    [[Y_ON_STACK:%.*]] = bitcast i8* addrspacecast (i8 addrspace(3)* getelementptr inbounds ([4 x i8], [4 x i8] addrspace(3)* @y_shared, i32 0, i32 0) to i8*) to [4 x i32]*
; CHECK-NEXT:    [[B1:%.*]] = bitcast [4 x i32]* [[Y_ON_STACK]] to i8*
; CHECK-NEXT:    call void @use.internalized(i8* nofree [[B1]]) #[[ATTR8]]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* @[[GLOB1]], i8 1, i1 true)
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@baz_spmd
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:    [[C:%.*]] = call i32 @__kmpc_target_init(%struct.ident_t* @[[GLOB1]], i8 2, i1 true, i1 true)
; CHECK-NEXT:    call void @unknown_no_openmp() #[[ATTR6]]
; CHECK-NEXT:    [[C0:%.*]] = icmp eq i32 [[C]], -1
; CHECK-NEXT:    br i1 [[C0]], label [[MASTER3:%.*]], label [[EXIT:%.*]]
; CHECK:       master3:
; CHECK-NEXT:    [[Z:%.*]] = call align 4 i8* @__kmpc_alloc_shared(i64 24) #[[ATTR7]], !dbg [[DBG10:![0-9]+]]
; CHECK-NEXT:    [[Z_ON_STACK:%.*]] = bitcast i8* [[Z]] to [6 x i32]*
; CHECK-NEXT:    [[C1:%.*]] = bitcast [6 x i32]* [[Z_ON_STACK]] to i8*
; CHECK-NEXT:    call void @use.internalized(i8* nofree [[C1]]) #[[ATTR8]]
; CHECK-NEXT:    call void @__kmpc_free_shared(i8* [[Z]], i64 24) #[[ATTR9]]
; CHECK-NEXT:    br label [[EXIT]]
; CHECK:       exit:
; CHECK-NEXT:    call void @__kmpc_target_deinit(%struct.ident_t* @[[GLOB1]], i8 2, i1 true)
; CHECK-NEXT:    ret void
;
;
; CHECK: Function Attrs: nofree nounwind writeonly
; CHECK-LABEL: define {{[^@]+}}@use.internalized
; CHECK-SAME: (i8* nofree [[X:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i8* [[X]], i8** @S, align 8
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@use
; CHECK-SAME: (i8* [[X:%.*]]) {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    store i8* [[X]], i8** @S, align 8
; CHECK-NEXT:    ret void
;
;
; CHECK-LABEL: define {{[^@]+}}@__kmpc_alloc_shared
; CHECK-SAME: (i64 [[TMP0:%.*]]) #[[ATTR2:[0-9]+]] {
; CHECK-NEXT:    [[L:%.*]] = load i32, i32* @offset, align 4
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* addrspacecast (i8 addrspace(3)* getelementptr inbounds ([1024 x i8], [1024 x i8] addrspace(3)* @stack, i32 0, i32 0) to i8*), i32 [[L]]
; CHECK-NEXT:    ret i8* [[GEP]]
;
;.
; CHECK: attributes #[[ATTR0]] = { "kernel" }
; CHECK: attributes #[[ATTR1]] = { nofree nounwind writeonly }
; CHECK: attributes #[[ATTR2]] = { nosync nounwind readonly allocsize(0) }
; CHECK: attributes #[[ATTR3:[0-9]+]] = { nosync nounwind }
; CHECK: attributes #[[ATTR4:[0-9]+]] = { nounwind readnone speculatable }
; CHECK: attributes #[[ATTR5:[0-9]+]] = { nofree nosync nounwind readnone speculatable willreturn }
; CHECK: attributes #[[ATTR6]] = { "llvm.assume"="omp_no_openmp" }
; CHECK: attributes #[[ATTR7]] = { nounwind readonly }
; CHECK: attributes #[[ATTR8]] = { nounwind writeonly }
; CHECK: attributes #[[ATTR9]] = { nounwind }
;.
; CHECK: [[META0:![0-9]+]] = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 12.0.0", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, enums: !2, splitDebugInlining: false, nameTableKind: None)
; CHECK: [[META1:![0-9]+]] = !DIFile(filename: "replace_globalization.c", directory: "/tmp/replace_globalization.c")
; CHECK: [[META2:![0-9]+]] = !{}
; CHECK: [[META3:![0-9]+]] = !{i32 2, !"Debug Info Version", i32 3}
; CHECK: [[META4:![0-9]+]] = !{i32 1, !"wchar_size", i32 4}
; CHECK: [[META5:![0-9]+]] = !{i32 7, !"openmp", i32 50}
; CHECK: [[META6:![0-9]+]] = !{i32 7, !"openmp-device", i32 50}
; CHECK: [[META7:![0-9]+]] = !{void ()* @foo, !"kernel", i32 1}
; CHECK: [[META8:![0-9]+]] = !{void ()* @bar, !"kernel", i32 1}
; CHECK: [[META9:![0-9]+]] = !{void ()* @baz_spmd, !"kernel", i32 1}
; CHECK: [[DBG10]] = !DILocation(line: 5, column: 14, scope: !11)
; CHECK: [[META11:![0-9]+]] = distinct !DISubprogram(name: "bar", scope: !1, file: !1, line: 1, type: !12, scopeLine: 1, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !0, retainedNodes: !2)
; CHECK: [[META12:![0-9]+]] = !DISubroutineType(types: !2)
;.
