; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature
; RUN: opt -S -openmp-opt-cgscc < %s | FileCheck %s
; RUN: opt -S -passes=openmp-opt-cgscc < %s | FileCheck %s
%struct.ident_t = type { i32, i32, i32, i32, i8* }

@.str = private unnamed_addr constant [23 x i8] c";unknown;unknown;0;0;;\00", align 1
@0 = private unnamed_addr global %struct.ident_t { i32 0, i32 2, i32 0, i32 0, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str, i32 0, i32 0) }, align 8

; Function Attrs: nounwind uwtable
define dso_local i32 @b() #0 {
; CHECK-LABEL: define {{[^@]+}}@b() #0
; CHECK-NEXT:    [[TMP1:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @a()
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]], align 4
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = alloca i32, align 4
  %2 = call i32 @a()
  %3 = load i32, i32* %1, align 4
  ret i32 %3
}

; Function Attrs: nounwind uwtable
define internal i32 @a() #0 {
; CHECK-LABEL: define {{[^@]+}}@a() #0
; CHECK-NEXT:    [[TMP1:%.*]] = alloca i32, align 4
; CHECK-NEXT:    [[TMP2:%.*]] = call i32 @b()
; CHECK-NEXT:    call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* @0, i32 0, void (i32*, i32*, ...)* bitcast (void (i32*, i32*)* @.omp_outlined. to void (i32*, i32*, ...)*))
; CHECK-NEXT:    [[TMP3:%.*]] = load i32, i32* [[TMP1]], align 4
; CHECK-NEXT:    ret i32 [[TMP3]]
;
  %1 = alloca i32, align 4
  %2 = call i32 @b()
  call void (%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) @__kmpc_fork_call(%struct.ident_t* @0, i32 0, void (i32*, i32*, ...)* bitcast (void (i32*, i32*)* @.omp_outlined. to void (i32*, i32*, ...)*))
  %3 = load i32, i32* %1, align 4
  ret i32 %3
}

; Function Attrs: norecurse nounwind uwtable
define internal void @.omp_outlined.(i32* noalias %0, i32* noalias %1) #1 {
; CHECK-LABEL: define {{[^@]+}}@.omp_outlined.
; CHECK-SAME: (i32* noalias [[TMP0:%.*]], i32* noalias [[TMP1:%.*]]) #1
; CHECK-NEXT:    [[TMP3:%.*]] = alloca i32*, align 8
; CHECK-NEXT:    [[TMP4:%.*]] = alloca i32*, align 8
; CHECK-NEXT:    store i32* [[TMP0]], i32** [[TMP3]], align 8, !tbaa !2
; CHECK-NEXT:    store i32* [[TMP1]], i32** [[TMP4]], align 8, !tbaa !2
; CHECK-NEXT:    ret void
;
  %3 = alloca i32*, align 8
  %4 = alloca i32*, align 8
  store i32* %0, i32** %3, align 8, !tbaa !2
  store i32* %1, i32** %4, align 8, !tbaa !2
  ret void
}

; Function Attrs: nounwind
declare !callback !6 void @__kmpc_fork_call(%struct.ident_t*, i32, void (i32*, i32*, ...)*, ...) #2

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "use-soft-float"="false" }
attributes #1 = { norecurse nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "min-legal-vector-width"="0" "no-trapping-math" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "use-soft-float"="false" }
attributes #2 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"Debian clang version 11.0.0-++20200709100646+c92a8c0a0f6-1~exp1~20200709201313.3348"}
!2 = !{!3, !3, i64 0}
!3 = !{!"any pointer", !4, i64 0}
!4 = !{!"omnipotent char", !5, i64 0}
!5 = !{!"Simple C/C++ TBAA"}
!6 = !{!7}
!7 = !{i64 2, i64 -1, i64 -1, i1 true}
