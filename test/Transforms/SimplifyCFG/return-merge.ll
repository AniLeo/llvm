; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck --check-prefixes=CHECK %s
; RUN: opt < %s -debugify -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck --check-prefixes=DBGINFO %s

define i32 @test1(i1 %C) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[C:%.*]], i32 1, i32 0
; CHECK-NEXT:    ret i32 [[SPEC_SELECT]]
;
; DBGINFO-LABEL: @test1(
; DBGINFO-NEXT:  entry:
; DBGINFO-NEXT:    call void @llvm.dbg.value(metadata i32 0, metadata [[META9:![0-9]+]], metadata !DIExpression()), !dbg [[DBG11:![0-9]+]]
; DBGINFO-NEXT:    [[SPEC_SELECT:%.*]] = select i1 [[C:%.*]], i32 1, i32 0, !dbg [[DBG11]]
; DBGINFO-NEXT:    ret i32 [[SPEC_SELECT]], !dbg [[DBG12:![0-9]+]]
;
entry:
  br i1 %C, label %T, label %F
T:              ; preds = %entry
  ret i32 1
F:              ; preds = %entry
  ret i32 0
}

define void @test2(i1 %C) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  T:
; CHECK-NEXT:    ret void
;
; DBGINFO-LABEL: @test2(
; DBGINFO-NEXT:  T:
; DBGINFO-NEXT:    call void @llvm.dbg.value(metadata i32 0, metadata [[META15:![0-9]+]], metadata !DIExpression()), !dbg [[DBG16:![0-9]+]]
; DBGINFO-NEXT:    ret void, !dbg [[DBG17:![0-9]+]]
;
  br i1 %C, label %T, label %F
T:              ; preds = %0
  ret void
F:              ; preds = %0
  ret void
}

