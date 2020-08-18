; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal -attributor-annotate-decl-cs -attributor-max-initialization-chain-length=1 -S < %s | FileCheck %s --check-prefixes=CHECK,CHECK_1
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal -attributor-annotate-decl-cs -attributor-max-initialization-chain-length=1 -S < %s | FileCheck %s --check-prefixes=CHECK,CHECK_1
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal -attributor-annotate-decl-cs -attributor-max-initialization-chain-length=1024 -S < %s | FileCheck %s --check-prefixes=CHECK,CHECK_5
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal -attributor-annotate-decl-cs -attributor-max-initialization-chain-length=1024 -S < %s | FileCheck %s --check-prefixes=CHECK,CHECK_5

declare void @foo(i8* dereferenceable(8) %arg)

define dso_local i32 @bar(i32* %arg) {
; CHECK_1-LABEL: define {{[^@]+}}@bar
; CHECK_1-SAME: (i32* dereferenceable_or_null(8) [[ARG:%.*]]) {
; CHECK_1-NEXT:  entry:
; CHECK_1-NEXT:    [[BC1:%.*]] = bitcast i32* [[ARG]] to i8*
; CHECK_1-NEXT:    call void @foo(i8* dereferenceable_or_null(8) [[BC1]])
; CHECK_1-NEXT:    [[LD:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK_1-NEXT:    ret i32 [[LD]]
;
; CHECK_5-LABEL: define {{[^@]+}}@bar
; CHECK_5-SAME: (i32* nonnull dereferenceable(8) [[ARG:%.*]]) {
; CHECK_5-NEXT:  entry:
; CHECK_5-NEXT:    [[BC1:%.*]] = bitcast i32* [[ARG]] to i8*
; CHECK_5-NEXT:    call void @foo(i8* nonnull dereferenceable(8) [[BC1]])
; CHECK_5-NEXT:    [[LD:%.*]] = load i32, i32* [[ARG]], align 4
; CHECK_5-NEXT:    ret i32 [[LD]]
;
entry:
  %bc1 = bitcast i32* %arg to i8*
  call void @foo(i8* %bc1)
  %ld = load i32, i32* %arg
  ret i32 %ld
}
