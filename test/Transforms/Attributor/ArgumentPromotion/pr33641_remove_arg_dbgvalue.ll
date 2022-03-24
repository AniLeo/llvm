; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=2 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM

; Fix for PR33641. ArgumentPromotion removed the argument to bar but left the call to
; dbg.value which still used the removed argument.

; The %p argument should be removed, and the use of it in dbg.value should be
; changed to undef.

%p_t = type i16*
%fun_t = type void (%p_t)*

define void @foo() {
; CHECK: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; CHECK-LABEL: define {{[^@]+}}@foo
; CHECK-SAME: () #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[TMP:%.*]] = alloca void (i16*)*, align 8
; CHECK-NEXT:    ret void
;
  %tmp = alloca %fun_t
  store %fun_t @bar, %fun_t* %tmp
  ret void
}

define internal void @bar(%p_t %p)  {
; IS__CGSCC_OPM-LABEL: define {{[^@]+}}@bar
; IS__CGSCC_OPM-SAME: (i16* [[P:%.*]]) {
; IS__CGSCC_OPM-NEXT:    call void @llvm.dbg.value(metadata i16* [[P]], metadata [[META3:![0-9]+]], metadata !DIExpression()), !dbg [[DBG5:![0-9]+]]
; IS__CGSCC_OPM-NEXT:    ret void
;
; IS__CGSCC_NPM: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__CGSCC_NPM-LABEL: define {{[^@]+}}@bar
; IS__CGSCC_NPM-SAME: (i16* nocapture nofree readnone [[P:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__CGSCC_NPM-NEXT:    call void @llvm.dbg.value(metadata i16* [[P]], metadata [[META3:![0-9]+]], metadata !DIExpression()) #[[ATTR3:[0-9]+]], !dbg [[DBG5:![0-9]+]]
; IS__CGSCC_NPM-NEXT:    ret void
;
  call void @llvm.dbg.value(metadata %p_t %p, metadata !4, metadata !5), !dbg !6
  ret void
}

declare void @llvm.dbg.value(metadata, metadata, metadata)

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!2}

!0 = distinct !DICompileUnit(language: DW_LANG_C, file: !1)
!1 = !DIFile(filename: "test.c", directory: "")
!2 = !{i32 2, !"Debug Info Version", i32 3}
!3 = distinct !DISubprogram(name: "bar", unit: !0)
!4 = !DILocalVariable(name: "p", scope: !3)
!5 = !DIExpression()
!6 = !DILocation(line: 1, column: 1, scope: !3)
;.
; NOT_CGSCC_NPM: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; NOT_CGSCC_NPM: attributes #[[ATTR1:[0-9]+]] = { nofree nosync nounwind readnone speculatable willreturn }
;.
; IS__CGSCC_NPM: attributes #[[ATTR0]] = { nofree norecurse nosync nounwind readnone willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR1]] = { nofree nosync nounwind readnone willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR2:[0-9]+]] = { nofree nosync nounwind readnone speculatable willreturn }
; IS__CGSCC_NPM: attributes #[[ATTR3]] = { readnone willreturn }
;.
; IS__TUNIT____: [[META0:![0-9]+]] = distinct !DICompileUnit(language: DW_LANG_C, file: !1, isOptimized: false, runtimeVersion: 0, emissionKind: NoDebug)
; IS__TUNIT____: [[META1:![0-9]+]] = !DIFile(filename: "test.c", directory: "")
; IS__TUNIT____: [[META2:![0-9]+]] = !{i32 2, !"Debug Info Version", i32 3}
;.
; IS__CGSCC____: [[META0:![0-9]+]] = distinct !DICompileUnit(language: DW_LANG_C, file: !1, isOptimized: false, runtimeVersion: 0, emissionKind: NoDebug)
; IS__CGSCC____: [[META1:![0-9]+]] = !DIFile(filename: "test.c", directory: "")
; IS__CGSCC____: [[META2:![0-9]+]] = !{i32 2, !"Debug Info Version", i32 3}
; IS__CGSCC____: [[META3:![0-9]+]] = !DILocalVariable(name: "p", scope: !4)
; IS__CGSCC____: [[META4:![0-9]+]] = distinct !DISubprogram(name: "bar", scope: null, spFlags: DISPFlagDefinition, unit: !0)
; IS__CGSCC____: [[META5:![0-9]+]] = !DILocation(line: 1, column: 1, scope: !4)
;.
