; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
; RUN: opt -S -openmpopt < %s | FileCheck %s
; RUN: opt -S -passes=openmpopt < %s | FileCheck %s

%struct.ident_t = type { i32, i32, i32, i32, i8* }

@.str = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr global %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8

define dso_local i32 @foo(i32 %0, i32 %1) {
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (i32 [[TMP0:%.*]], i32 [[TMP1:%.*]])
; CHECK-NEXT:    tail call void @omp_set_num_threads(i32 [[TMP0]])
; CHECK-NEXT:    tail call void @omp_set_num_threads(i32 [[TMP1]])
; CHECK-NEXT:    tail call void @use(i32 [[TMP1]])
; CHECK-NEXT:    tail call void @use(i32 [[TMP1]])
; CHECK-NEXT:    tail call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @0, i32 0, void (i32*, i32*, ...)* bitcast (void (i32*, i32*)* @.omp_outlined. to void (i32*, i32*, ...)*))
; CHECK-NEXT:    [[TMP3:%.*]] = tail call i32 @omp_get_max_threads()
; CHECK-NEXT:    tail call void @use(i32 [[TMP3]])
; CHECK-NEXT:    ret i32 0
;
  tail call void @omp_set_num_threads(i32 %0)
  %3 = tail call i32 @omp_get_max_threads()
; FIXME: this value should be tracked and the rest of the getters deduplicated and replaced with it.
  tail call void @omp_set_num_threads(i32 %1)
  %4 = tail call i32 @omp_get_max_threads()
  %5 = tail call i32 @omp_get_max_threads()
  %6 = tail call i32 @omp_get_max_threads()
  tail call void @use(i32 %4)
  tail call void @use(i32 %5)
  tail call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @0, i32 0, void (i32*, i32*, ...)* bitcast (void (i32*, i32*)* @.omp_outlined. to void (i32*, i32*, ...)*))
  %7 = tail call i32 @omp_get_max_threads()
  tail call void @use(i32 %7)
  ret i32 0
}

declare dso_local void @omp_set_num_threads(i32)

declare dso_local i32 @omp_get_max_threads()

declare dso_local void @use(i32)

define internal void @.omp_outlined.(i32* %0, i32* %1) {
; CHECK-LABEL: define {{[^@]+}}@.omp_outlined.
; CHECK-SAME: (i32* [[TMP0:%.*]], i32* [[TMP1:%.*]])
; CHECK-NEXT:    [[TMP3:%.*]] = tail call i32 @omp_get_max_threads()
; CHECK-NEXT:    [[TMP4:%.*]] = tail call i32 @omp_get_max_threads()
; CHECK-NEXT:    tail call void @use(i32 [[TMP4]])
; CHECK-NEXT:    tail call void @omp_set_num_threads(i32 10)
; CHECK-NEXT:    tail call void @use(i32 10)
; CHECK-NEXT:    ret void
;
; FIXME: this value should be tracked and the rest of the getters deduplicated and replaced with it.
  %3 = tail call i32 @omp_get_max_threads()
  %4 = tail call i32 @omp_get_max_threads()
  tail call void @use(i32 %4)
  tail call void @omp_set_num_threads(i32 10)
  %5 = tail call i32 @omp_get_max_threads()
  tail call void @use(i32 %5)
  ret void
}

declare !callback !0 void @__kmpc_fork_call(%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...)

define dso_local i32 @bar(i32 %0, i32 %1) {
; CHECK-LABEL: define {{[^@]+}}@bar
; CHECK-SAME: (i32 [[TMP0:%.*]], i32 [[TMP1:%.*]])
; CHECK-NEXT:    [[TMP3:%.*]] = icmp sgt i32 [[TMP0]], [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = select i1 [[TMP3]], i32 [[TMP0]], i32 [[TMP1]]
; CHECK-NEXT:    tail call void @omp_set_num_threads(i32 [[TMP4]])
; CHECK-NEXT:    tail call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @0, i32 0, void (i32*, i32*, ...)* bitcast (void (i32*, i32*)* @.omp_outlined..1 to void (i32*, i32*, ...)*))
; CHECK-NEXT:    [[TMP5:%.*]] = tail call i32 @omp_get_max_threads()
; CHECK-NEXT:    tail call void @use(i32 [[TMP5]])
; CHECK-NEXT:    ret i32 0
;
  %3 = icmp sgt i32 %0, %1
  %4 = select i1 %3, i32 %0, i32 %1
; FIXME: getters can be replaced with %4
  tail call void @omp_set_num_threads(i32 %4)
  %5 = tail call i32 @omp_get_max_threads()
  tail call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* nonnull @0, i32 0, void (i32*, i32*, ...)* bitcast (void (i32*, i32*)* @.omp_outlined..1 to void (i32*, i32*, ...)*))
  %6 = tail call i32 @omp_get_max_threads()
  tail call void @use(i32 %6)
  ret i32 0
}

define internal void @.omp_outlined..1(i32* %0, i32*  %1) {
; CHECK-LABEL: define {{[^@]+}}@.omp_outlined..1
; CHECK-SAME: (i32* [[TMP0:%.*]], i32* [[TMP1:%.*]])
; CHECK-NEXT:    [[TMP3:%.*]] = tail call i32 @omp_get_max_threads()
; CHECK-NEXT:    tail call void @use(i32 [[TMP3]])
; CHECK-NEXT:    tail call void @omp_set_num_threads(i32 10)
; CHECK-NEXT:    tail call void @use(i32 10)
; CHECK-NEXT:    [[TMP4:%.*]] = tail call i32 @omp_get_max_threads()
; CHECK-NEXT:    tail call void @use(i32 [[TMP4]])
; CHECK-NEXT:    ret void
;
  %3 = tail call i32 @omp_get_max_threads()
  tail call void @use(i32 %3)
  tail call void @omp_set_num_threads(i32 10)
  %4 = tail call i32 @omp_get_max_threads()
  tail call void @use(i32 %4)
  %5 = tail call i32 @omp_get_max_threads()
  tail call void @use(i32 %5)
  ret void
}

!0 = !{!1}
!1 = !{i64 2, i64 -1, i64 -1, i1 true}
