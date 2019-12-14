; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -S -passes=attributor -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=2 < %s | FileCheck %s --check-prefixes=ATTRIBUTOR
; RUN: opt -S -passes='globalopt,attributor' -aa-pipeline='basic-aa' -attributor-disable=false -attributor-max-iterations-verify -attributor-max-iterations=2 < %s | FileCheck %s --check-prefixes=GLOBALOPT_ATTRIBUTOR

target datalayout = "E-p:64:64:64-a0:0:8-f32:32:32-f64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:32:64-v64:64:64-v128:128:128"

%struct.ss = type { i32, i32 }

; Argpromote + sroa should change this to passing the two integers by value.
define internal i32 @f(%struct.ss* inalloca  %s) {
; ATTRIBUTOR-LABEL: define {{[^@]+}}@f
; ATTRIBUTOR-SAME: (%struct.ss* inalloca noalias nocapture nofree nonnull align 4 dereferenceable(8) [[S:%.*]])
; ATTRIBUTOR-NEXT:  entry:
; ATTRIBUTOR-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS:%.*]], %struct.ss* [[S]], i32 0, i32 0
; ATTRIBUTOR-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; ATTRIBUTOR-NEXT:    [[A:%.*]] = load i32, i32* [[F0]], align 4
; ATTRIBUTOR-NEXT:    [[B:%.*]] = load i32, i32* [[F1]], align 4
; ATTRIBUTOR-NEXT:    [[R:%.*]] = add i32 [[A]], [[B]]
; ATTRIBUTOR-NEXT:    ret i32 [[R]]
;
; GLOBALOPT_ATTRIBUTOR-LABEL: define {{[^@]+}}@f
; GLOBALOPT_ATTRIBUTOR-SAME: (%struct.ss* noalias nocapture nofree nonnull readonly align 4 dereferenceable(8) [[S:%.*]]) unnamed_addr
; GLOBALOPT_ATTRIBUTOR-NEXT:  entry:
; GLOBALOPT_ATTRIBUTOR-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS:%.*]], %struct.ss* [[S]], i32 0, i32 0
; GLOBALOPT_ATTRIBUTOR-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; GLOBALOPT_ATTRIBUTOR-NEXT:    [[A:%.*]] = load i32, i32* [[F0]], align 4
; GLOBALOPT_ATTRIBUTOR-NEXT:    [[B:%.*]] = load i32, i32* [[F1]], align 4
; GLOBALOPT_ATTRIBUTOR-NEXT:    [[R:%.*]] = add i32 [[A]], [[B]]
; GLOBALOPT_ATTRIBUTOR-NEXT:    ret i32 [[R]]
;
entry:
  %f0 = getelementptr %struct.ss, %struct.ss* %s, i32 0, i32 0
  %f1 = getelementptr %struct.ss, %struct.ss* %s, i32 0, i32 1
  %a = load i32, i32* %f0, align 4
  %b = load i32, i32* %f1, align 4
  %r = add i32 %a, %b
  ret i32 %r
}

define i32 @main() {
; ATTRIBUTOR-LABEL: define {{[^@]+}}@main()
; ATTRIBUTOR-NEXT:  entry:
; ATTRIBUTOR-NEXT:    [[S:%.*]] = alloca inalloca [[STRUCT_SS:%.*]]
; ATTRIBUTOR-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; ATTRIBUTOR-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; ATTRIBUTOR-NEXT:    store i32 1, i32* [[F0]], align 4
; ATTRIBUTOR-NEXT:    store i32 2, i32* [[F1]], align 4
; ATTRIBUTOR-NEXT:    [[R:%.*]] = call i32 @f(%struct.ss* inalloca noalias nocapture nofree nonnull align 4 dereferenceable(8) [[S]])
; ATTRIBUTOR-NEXT:    ret i32 [[R]]
;
; GLOBALOPT_ATTRIBUTOR-LABEL: define {{[^@]+}}@main() local_unnamed_addr
; GLOBALOPT_ATTRIBUTOR-NEXT:  entry:
; GLOBALOPT_ATTRIBUTOR-NEXT:    [[S:%.*]] = alloca inalloca [[STRUCT_SS:%.*]]
; GLOBALOPT_ATTRIBUTOR-NEXT:    [[F0:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 0
; GLOBALOPT_ATTRIBUTOR-NEXT:    [[F1:%.*]] = getelementptr [[STRUCT_SS]], %struct.ss* [[S]], i32 0, i32 1
; GLOBALOPT_ATTRIBUTOR-NEXT:    store i32 1, i32* [[F0]], align 4
; GLOBALOPT_ATTRIBUTOR-NEXT:    store i32 2, i32* [[F1]], align 4
; GLOBALOPT_ATTRIBUTOR-NEXT:    [[R:%.*]] = call fastcc i32 @f(%struct.ss* noalias nocapture nofree nonnull align 4 dereferenceable(8) [[S]])
; GLOBALOPT_ATTRIBUTOR-NEXT:    ret i32 [[R]]
;
entry:
  %S = alloca inalloca %struct.ss
  %f0 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 0
  %f1 = getelementptr %struct.ss, %struct.ss* %S, i32 0, i32 1
  store i32 1, i32* %f0, align 4
  store i32 2, i32* %f1, align 4
  %r = call i32 @f(%struct.ss* inalloca %S)
  ret i32 %r
}

; Argpromote can't promote %a because of the icmp use.
define internal i1 @g(%struct.ss* %a, %struct.ss* inalloca %b) nounwind  {
entry:
  %c = icmp eq %struct.ss* %a, %b
  ret i1 %c
}

define i32 @test() {
; ATTRIBUTOR-LABEL: define {{[^@]+}}@test()
; ATTRIBUTOR-NEXT:  entry:
; ATTRIBUTOR-NEXT:    ret i32 0
;
; GLOBALOPT_ATTRIBUTOR-LABEL: define {{[^@]+}}@test() local_unnamed_addr
; GLOBALOPT_ATTRIBUTOR-NEXT:  entry:
; GLOBALOPT_ATTRIBUTOR-NEXT:    ret i32 0
;
entry:
  %S = alloca inalloca %struct.ss
  %c = call i1 @g(%struct.ss* %S, %struct.ss* inalloca %S)
  ret i32 0
}
