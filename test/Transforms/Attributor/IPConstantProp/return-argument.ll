; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

;; This function returns its second argument on all return statements
define internal i32* @incdec(i1 %C, i32* %V) {
; CHECK: Function Attrs: argmemonly nofree norecurse nosync nounwind willreturn
; CHECK-LABEL: define {{[^@]+}}@incdec
; CHECK-SAME: (i1 [[C:%.*]], i32* noalias nofree noundef nonnull returned align 4 dereferenceable(4) "no-capture-maybe-returned" [[V:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[X:%.*]] = load i32, i32* [[V]], align 4
; CHECK-NEXT:    br i1 [[C]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       T:
; CHECK-NEXT:    [[X1:%.*]] = add i32 [[X]], 1
; CHECK-NEXT:    store i32 [[X1]], i32* [[V]], align 4
; CHECK-NEXT:    ret i32* [[V]]
; CHECK:       F:
; CHECK-NEXT:    [[X2:%.*]] = sub i32 [[X]], 1
; CHECK-NEXT:    store i32 [[X2]], i32* [[V]], align 4
; CHECK-NEXT:    ret i32* [[V]]
;
  %X = load i32, i32* %V
  br i1 %C, label %T, label %F

T:              ; preds = %0
  %X1 = add i32 %X, 1
  store i32 %X1, i32* %V
  ret i32* %V

F:              ; preds = %0
  %X2 = sub i32 %X, 1
  store i32 %X2, i32* %V
  ret i32* %V
}

;; This function returns its first argument as a part of a multiple return
;; value
define internal { i32, i32 } @foo(i32 %A, i32 %B) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: (i32 noundef [[A:%.*]], i32 noundef [[B:%.*]]) #[[ATTR1:[0-9]+]] {
; CHECK-NEXT:    [[X:%.*]] = add i32 [[A]], [[B]]
; CHECK-NEXT:    [[Y:%.*]] = insertvalue { i32, i32 } undef, i32 [[A]], 0
; CHECK-NEXT:    [[Z:%.*]] = insertvalue { i32, i32 } [[Y]], i32 [[X]], 1
; CHECK-NEXT:    ret { i32, i32 } [[Z]]
;
  %X = add i32 %A, %B
  %Y = insertvalue { i32, i32 } undef, i32 %A, 0
  %Z = insertvalue { i32, i32 } %Y, i32 %X, 1
  ret { i32, i32 } %Z
}

define void @caller(i1 %C) personality i32 (...)* @__gxx_personality_v0 {
; IS__TUNIT____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@caller
; IS__TUNIT____-SAME: (i1 [[C:%.*]]) #[[ATTR1]] personality i32 (...)* @__gxx_personality_v0 {
; IS__TUNIT____-NEXT:    [[Q:%.*]] = alloca i32, align 4
; IS__TUNIT____-NEXT:    [[W:%.*]] = call align 4 i32* @incdec(i1 [[C]], i32* noalias nofree noundef nonnull align 4 dereferenceable(4) "no-capture-maybe-returned" [[Q]]) #[[ATTR2:[0-9]+]]
; IS__TUNIT____-NEXT:    [[S1:%.*]] = call { i32, i32 } @foo(i32 noundef 1, i32 noundef 2) #[[ATTR3:[0-9]+]]
; IS__TUNIT____-NEXT:    [[X1:%.*]] = extractvalue { i32, i32 } [[S1]], 0
; IS__TUNIT____-NEXT:    [[S2:%.*]] = call { i32, i32 } @foo(i32 noundef 3, i32 noundef 4) #[[ATTR3]]
; IS__TUNIT____-NEXT:    br label [[OK:%.*]]
; IS__TUNIT____:       OK:
; IS__TUNIT____-NEXT:    [[X2:%.*]] = extractvalue { i32, i32 } [[S2]], 0
; IS__TUNIT____-NEXT:    [[Z:%.*]] = add i32 [[X1]], [[X2]]
; IS__TUNIT____-NEXT:    store i32 [[Z]], i32* [[Q]], align 4
; IS__TUNIT____-NEXT:    br label [[RET:%.*]]
; IS__TUNIT____:       LPAD:
; IS__TUNIT____-NEXT:    unreachable
; IS__TUNIT____:       RET:
; IS__TUNIT____-NEXT:    ret void
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@caller
; IS__CGSCC____-SAME: (i1 [[C:%.*]]) #[[ATTR1]] personality i32 (...)* @__gxx_personality_v0 {
; IS__CGSCC____-NEXT:    [[Q:%.*]] = alloca i32, align 4
; IS__CGSCC____-NEXT:    [[W:%.*]] = call align 4 i32* @incdec(i1 [[C]], i32* noalias nofree noundef nonnull align 4 dereferenceable(4) "no-capture-maybe-returned" [[Q]]) #[[ATTR2:[0-9]+]]
; IS__CGSCC____-NEXT:    [[S1:%.*]] = call { i32, i32 } @foo(i32 noundef 1, i32 noundef 2) #[[ATTR3:[0-9]+]]
; IS__CGSCC____-NEXT:    [[X1:%.*]] = extractvalue { i32, i32 } [[S1]], 0
; IS__CGSCC____-NEXT:    [[S2:%.*]] = call { i32, i32 } @foo(i32 noundef 3, i32 noundef 4) #[[ATTR4:[0-9]+]]
; IS__CGSCC____-NEXT:    br label [[OK:%.*]]
; IS__CGSCC____:       OK:
; IS__CGSCC____-NEXT:    [[X2:%.*]] = extractvalue { i32, i32 } [[S2]], 0
; IS__CGSCC____-NEXT:    [[Z:%.*]] = add i32 [[X1]], [[X2]]
; IS__CGSCC____-NEXT:    store i32 [[Z]], i32* [[Q]], align 4
; IS__CGSCC____-NEXT:    br label [[RET:%.*]]
; IS__CGSCC____:       LPAD:
; IS__CGSCC____-NEXT:    unreachable
; IS__CGSCC____:       RET:
; IS__CGSCC____-NEXT:    ret void
;
  %Q = alloca i32
  ;; Call incdec to see if %W is properly replaced by %Q
  %W = call i32* @incdec(i1 %C, i32* %Q )             ; <i32> [#uses=1]
  ;; Call @foo twice, to prevent the arguments from propagating into the
  ;; function (so we can check the returned argument is properly
  ;; propagated per-caller).
  %S1 = call { i32, i32 } @foo(i32 1, i32 2)
  %X1 = extractvalue { i32, i32 } %S1, 0
  %S2 = invoke { i32, i32 } @foo(i32 3, i32 4) to label %OK unwind label %LPAD

OK:
  %X2 = extractvalue { i32, i32 } %S2, 0
  ;; Do some stuff with the returned values which we can grep for
  %Z  = add i32 %X1, %X2
  store i32 %Z, i32* %W
  br label %RET

LPAD:
  %exn = landingpad {i8*, i32}
  cleanup
  br label %RET

RET:
  ret void
}

declare i32 @__gxx_personality_v0(...)
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind willreturn }
; IS__TUNIT____: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__TUNIT____: attributes #[[ATTR2]] = { nofree nosync nounwind willreturn }
; IS__TUNIT____: attributes #[[ATTR3]] = { nofree nosync nounwind readnone willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { argmemonly nofree norecurse nosync nounwind willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR2]] = { nounwind willreturn }
; IS__CGSCC____: attributes #[[ATTR3]] = { readnone willreturn }
; IS__CGSCC____: attributes #[[ATTR4]] = { nounwind readnone willreturn }
;.
