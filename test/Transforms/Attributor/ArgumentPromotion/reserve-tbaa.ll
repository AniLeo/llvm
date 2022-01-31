; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; PR17906
; When we promote two arguments in a single function with different types,
; before the fix, we used the same tag for the newly-created two loads.
; This testing case makes sure that we correctly transfer the tbaa tags from the
; original loads to the newly-created loads when promoting pointer arguments.

@a = global i32* null, align 8
@e = global i32** @a, align 8
@g = global i32 0, align 4
@c = global i64 0, align 8
@d = global i8 0, align 1

;.
; CHECK: @[[A:[a-zA-Z0-9_$"\\.-]+]] = global i32* null, align 8
; CHECK: @[[E:[a-zA-Z0-9_$"\\.-]+]] = global i32** @a, align 8
; CHECK: @[[G:[a-zA-Z0-9_$"\\.-]+]] = global i32 0, align 4
; CHECK: @[[C:[a-zA-Z0-9_$"\\.-]+]] = global i64 0, align 8
; CHECK: @[[D:[a-zA-Z0-9_$"\\.-]+]] = global i8 0, align 1
;.
define internal fastcc void @fn(i32* nocapture readonly %p1, i64* nocapture readonly %p2) {
; CHECK: Function Attrs: nofree norecurse nosync nounwind willreturn
; CHECK-LABEL: define {{[^@]+}}@fn
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* @g, align 4, !tbaa [[TBAA0:![0-9]+]]
; CHECK-NEXT:    [[CONV1:%.*]] = trunc i32 [[TMP0]] to i8
; CHECK-NEXT:    store i8 [[CONV1]], i8* @d, align 1, !tbaa [[TBAA4:![0-9]+]]
; CHECK-NEXT:    ret void
;
entry:
  %0 = load i64, i64* %p2, align 8, !tbaa !1
  %conv = trunc i64 %0 to i32
  %1 = load i32, i32* %p1, align 4, !tbaa !5
  %conv1 = trunc i32 %1 to i8
  store i8 %conv1, i8* @d, align 1, !tbaa !7
  ret void
}

define i32 @main() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind willreturn
; CHECK-LABEL: define {{[^@]+}}@main
; CHECK-SAME: () #[[ATTR0]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = load i32**, i32*** @e, align 8, !tbaa [[TBAA5:![0-9]+]]
; CHECK-NEXT:    store i32* @g, i32** [[TMP0]], align 8, !tbaa [[TBAA5]]
; CHECK-NEXT:    [[TMP1:%.*]] = load i32*, i32** @a, align 8, !tbaa [[TBAA5]]
; CHECK-NEXT:    store i32 1, i32* [[TMP1]], align 4, !tbaa [[TBAA0]]
; CHECK-NEXT:    call fastcc void @fn() #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    ret i32 0
;
entry:
  %0 = load i32**, i32*** @e, align 8, !tbaa !8
  store i32* @g, i32** %0, align 8, !tbaa !8
  %1 = load i32*, i32** @a, align 8, !tbaa !8
  store i32 1, i32* %1, align 4, !tbaa !5
  call fastcc void @fn(i32* @g, i64* @c)

  ret i32 0
}

!1 = !{!2, !2, i64 0}
!2 = !{!"long", !3, i64 0}
!3 = !{!"omnipotent char", !4, i64 0}
!4 = !{!"Simple C/C++ TBAA"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !3, i64 0}
!7 = !{!3, !3, i64 0}
!8 = !{!9, !9, i64 0}
!9 = !{!"any pointer", !3, i64 0}

;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind willreturn }
; IS__TUNIT____: attributes #[[ATTR1]] = { nofree nosync nounwind willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind willreturn }
; IS__CGSCC____: attributes #[[ATTR1]] = { nounwind willreturn }
;.
; CHECK: [[TBAA0]] = !{!1, !1, i64 0}
; CHECK: [[META1:![0-9]+]] = !{!"int", !2, i64 0}
; CHECK: [[META2:![0-9]+]] = !{!"omnipotent char", !3, i64 0}
; CHECK: [[META3:![0-9]+]] = !{!"Simple C/C++ TBAA"}
; CHECK: [[TBAA4]] = !{!2, !2, i64 0}
; CHECK: [[TBAA5]] = !{!6, !6, i64 0}
; CHECK: [[META6:![0-9]+]] = !{!"any pointer", !2, i64 0}
;.
