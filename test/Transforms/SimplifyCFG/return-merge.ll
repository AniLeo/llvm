; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck --check-prefixes=CHECK %s
; RUN: opt < %s -debugify -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck --check-prefixes=DBGINFO %s

define i32 @test1(i1 %C) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOT:%.*]] = select i1 [[C:%.*]], i32 1, i32 0
; CHECK-NEXT:    ret i32 [[DOT]]
;
; DBGINFO-LABEL: @test1(
; DBGINFO-NEXT:  entry:
; DBGINFO-NEXT:    call void @llvm.dbg.value(metadata i32 0, metadata [[META9:![0-9]+]], metadata !DIExpression()), !dbg [[DBG11:![0-9]+]]
; DBGINFO-NEXT:    [[DOT:%.*]] = select i1 [[C:%.*]], i32 1, i32 0
; DBGINFO-NEXT:    ret i32 [[DOT]], !dbg [[DBG12:![0-9]+]]
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
; CHECK-NEXT:  common.ret:
; CHECK-NEXT:    ret void
;
; DBGINFO-LABEL: @test2(
; DBGINFO-NEXT:  common.ret:
; DBGINFO-NEXT:    call void @llvm.dbg.value(metadata i32 0, metadata [[META15:![0-9]+]], metadata !DIExpression()), !dbg [[DBG16:![0-9]+]]
; DBGINFO-NEXT:    ret void, !dbg [[DBG17:![0-9]+]]
;
  br i1 %C, label %T, label %F
T:              ; preds = %0
  ret void
F:              ; preds = %0
  ret void
}

declare void @sideeffect0()
declare void @sideeffect1()
declare void @sideeffect2()

define i32 @test3(i1 %C0, i1 %C1, i32 %v0, i32 %v1, i32 %v2) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    call void @sideeffect0()
; CHECK-NEXT:    br i1 [[C0:%.*]], label [[T:%.*]], label [[F:%.*]]
; CHECK:       end:
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ [[V2:%.*]], [[F]] ], [ [[SPEC_SELECT:%.*]], [[T]] ]
; CHECK-NEXT:    ret i32 [[R]]
; CHECK:       T:
; CHECK-NEXT:    call void @sideeffect1()
; CHECK-NEXT:    [[SPEC_SELECT]] = select i1 [[C1:%.*]], i32 [[V0:%.*]], i32 [[V1:%.*]]
; CHECK-NEXT:    br label [[END:%.*]]
; CHECK:       F:
; CHECK-NEXT:    call void @sideeffect2()
; CHECK-NEXT:    br label [[END]]
;
; DBGINFO-LABEL: @test3(
; DBGINFO-NEXT:  entry:
; DBGINFO-NEXT:    call void @sideeffect0(), !dbg [[DBG21:![0-9]+]]
; DBGINFO-NEXT:    br i1 [[C0:%.*]], label [[T:%.*]], label [[F:%.*]], !dbg [[DBG22:![0-9]+]]
; DBGINFO:       end:
; DBGINFO-NEXT:    [[R:%.*]] = phi i32 [ [[V2:%.*]], [[F]] ], [ [[SPEC_SELECT:%.*]], [[T]] ], !dbg [[DBG23:![0-9]+]]
; DBGINFO-NEXT:    call void @llvm.dbg.value(metadata i32 [[R]], metadata [[META20:![0-9]+]], metadata !DIExpression()), !dbg [[DBG23]]
; DBGINFO-NEXT:    ret i32 [[R]], !dbg [[DBG24:![0-9]+]]
; DBGINFO:       T:
; DBGINFO-NEXT:    call void @sideeffect1(), !dbg [[DBG25:![0-9]+]]
; DBGINFO-NEXT:    [[SPEC_SELECT]] = select i1 [[C1:%.*]], i32 [[V0:%.*]], i32 [[V1:%.*]], !dbg [[DBG26:![0-9]+]]
; DBGINFO-NEXT:    br label [[END:%.*]], !dbg [[DBG26]]
; DBGINFO:       F:
; DBGINFO-NEXT:    call void @sideeffect2(), !dbg [[DBG27:![0-9]+]]
; DBGINFO-NEXT:    br label [[END]], !dbg [[DBG28:![0-9]+]]
;
entry:
  call void @sideeffect0()
  br i1 %C0, label %T, label %F

T.cont:
  ; empty block with single predecessor
  br label %end

end:
  %r = phi i32 [ %v0, %T.cont ], [ %v1, %T ], [ %v2, %F ]
  ; empty block
  ret i32 %r

T:
  call void @sideeffect1()
  br i1 %C1, label %T.cont, label %end

F:
  call void @sideeffect2()
  br label %end
}
