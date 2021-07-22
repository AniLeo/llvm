; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -S | FileCheck --check-prefixes=CHECK,NODUPRET %s
; RUN: opt < %s -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -simplifycfg-dup-ret -S | FileCheck --check-prefixes=CHECK,DUPRET %s
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
; NODUPRET-LABEL: @test2(
; NODUPRET-NEXT:  common.ret:
; NODUPRET-NEXT:    ret void
;
; DUPRET-LABEL: @test2(
; DUPRET-NEXT:    ret void
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
; NODUPRET-LABEL: @test3(
; NODUPRET-NEXT:  entry:
; NODUPRET-NEXT:    call void @sideeffect0()
; NODUPRET-NEXT:    br i1 [[C0:%.*]], label [[T:%.*]], label [[F:%.*]]
; NODUPRET:       end:
; NODUPRET-NEXT:    [[R:%.*]] = phi i32 [ [[V2:%.*]], [[F]] ], [ [[SPEC_SELECT:%.*]], [[T]] ]
; NODUPRET-NEXT:    ret i32 [[R]]
; NODUPRET:       T:
; NODUPRET-NEXT:    call void @sideeffect1()
; NODUPRET-NEXT:    [[SPEC_SELECT]] = select i1 [[C1:%.*]], i32 [[V0:%.*]], i32 [[V1:%.*]]
; NODUPRET-NEXT:    br label [[END:%.*]]
; NODUPRET:       F:
; NODUPRET-NEXT:    call void @sideeffect2()
; NODUPRET-NEXT:    br label [[END]]
;
; DUPRET-LABEL: @test3(
; DUPRET-NEXT:  entry:
; DUPRET-NEXT:    call void @sideeffect0()
; DUPRET-NEXT:    br i1 [[C0:%.*]], label [[T:%.*]], label [[F:%.*]]
; DUPRET:       T:
; DUPRET-NEXT:    call void @sideeffect1()
; DUPRET-NEXT:    [[RETVAL:%.*]] = select i1 [[C1:%.*]], i32 [[V0:%.*]], i32 [[V1:%.*]]
; DUPRET-NEXT:    ret i32 [[RETVAL]]
; DUPRET:       F:
; DUPRET-NEXT:    call void @sideeffect2()
; DUPRET-NEXT:    ret i32 [[V2:%.*]]
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
