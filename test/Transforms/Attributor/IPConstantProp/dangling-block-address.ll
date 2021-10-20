; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -attributor -enable-new-pm=0 -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=1 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -enable-new-pm=0 -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
; PR5569

; IPSCCP should prove that the blocks are dead and delete them, and
; properly handle the dangling blockaddress constants.

@code = global [5 x i32] [i32 0, i32 0, i32 0, i32 0, i32 1], align 4 ; <[5 x i32]*> [#uses=0]
@bar.l = internal constant [2 x i8*] [i8* blockaddress(@bar, %lab0), i8* blockaddress(@bar, %end)] ; <[2 x i8*]*> [#uses=1]

;.
; IS__TUNIT____: @[[CODE:[a-zA-Z0-9_$"\\.-]+]] = global [5 x i32] [i32 0, i32 0, i32 0, i32 0, i32 1], align 4
; IS__TUNIT____: @[[BAR_L:[a-zA-Z0-9_$"\\.-]+]] = internal constant [2 x i8*] [i8* inttoptr (i32 1 to i8*), i8* inttoptr (i32 1 to i8*)]
;.
; IS__CGSCC____: @[[CODE:[a-zA-Z0-9_$"\\.-]+]] = global [5 x i32] [i32 0, i32 0, i32 0, i32 0, i32 1], align 4
; IS__CGSCC____: @[[BAR_L:[a-zA-Z0-9_$"\\.-]+]] = internal constant [2 x i8*] [i8* blockaddress(@bar, [[LAB0:%.*]]), i8* blockaddress(@bar, [[END:%.*]])]
;.
define internal void @foo(i32 %x) nounwind readnone {
; IS__CGSCC____: Function Attrs: nounwind readnone
; IS__CGSCC____-LABEL: define {{[^@]+}}@foo
; IS__CGSCC____-SAME: (i32 [[X:%.*]]) #[[ATTR0:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    [[B:%.*]] = alloca i32, align 4
; IS__CGSCC____-NEXT:    store volatile i32 -1, i32* [[B]], align 4
; IS__CGSCC____-NEXT:    ret void
;
entry:
  %b = alloca i32, align 4                        ; <i32*> [#uses=1]
  store volatile i32 -1, i32* %b
  ret void
}

define internal void @bar(i32* nocapture %pc) nounwind readonly {
; IS__CGSCC____: Function Attrs: nounwind readonly
; IS__CGSCC____-LABEL: define {{[^@]+}}@bar
; IS__CGSCC____-SAME: (i32* nocapture [[PC:%.*]]) #[[ATTR1:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    br label [[INDIRECTGOTO:%.*]]
; IS__CGSCC____:       lab0:
; IS__CGSCC____-NEXT:    [[INDVAR_NEXT:%.*]] = add i32 [[INDVAR:%.*]], 1
; IS__CGSCC____-NEXT:    br label [[INDIRECTGOTO]]
; IS__CGSCC____:       end:
; IS__CGSCC____-NEXT:    ret void
; IS__CGSCC____:       indirectgoto:
; IS__CGSCC____-NEXT:    [[INDVAR]] = phi i32 [ [[INDVAR_NEXT]], [[LAB0:%.*]] ], [ 0, [[ENTRY:%.*]] ]
; IS__CGSCC____-NEXT:    [[PC_ADDR_0:%.*]] = getelementptr i32, i32* [[PC]], i32 [[INDVAR]]
; IS__CGSCC____-NEXT:    [[TMP1_PN:%.*]] = load i32, i32* [[PC_ADDR_0]], align 4
; IS__CGSCC____-NEXT:    [[INDIRECT_GOTO_DEST_IN:%.*]] = getelementptr inbounds [2 x i8*], [2 x i8*]* @bar.l, i32 0, i32 [[TMP1_PN]]
; IS__CGSCC____-NEXT:    [[INDIRECT_GOTO_DEST:%.*]] = load i8*, i8** [[INDIRECT_GOTO_DEST_IN]], align 8
; IS__CGSCC____-NEXT:    indirectbr i8* [[INDIRECT_GOTO_DEST]], [label [[LAB0]], label %end]
;
entry:
  br label %indirectgoto

lab0:                                             ; preds = %indirectgoto
  %indvar.next = add i32 %indvar, 1               ; <i32> [#uses=1]
  br label %indirectgoto

end:                                              ; preds = %indirectgoto
  ret void

indirectgoto:                                     ; preds = %lab0, %entry
  %indvar = phi i32 [ %indvar.next, %lab0 ], [ 0, %entry ] ; <i32> [#uses=2]
  %pc.addr.0 = getelementptr i32, i32* %pc, i32 %indvar ; <i32*> [#uses=1]
  %tmp1.pn = load i32, i32* %pc.addr.0                 ; <i32> [#uses=1]
  %indirect.goto.dest.in = getelementptr inbounds [2 x i8*], [2 x i8*]* @bar.l, i32 0, i32 %tmp1.pn ; <i8**> [#uses=1]
  %indirect.goto.dest = load i8*, i8** %indirect.goto.dest.in ; <i8*> [#uses=1]
  indirectbr i8* %indirect.goto.dest, [label %lab0, label %end]
}

define i32 @main() nounwind readnone {
; IS__TUNIT____: Function Attrs: nofree nosync nounwind readnone willreturn
; IS__TUNIT____-LABEL: define {{[^@]+}}@main
; IS__TUNIT____-SAME: () #[[ATTR0:[0-9]+]] {
; IS__TUNIT____-NEXT:  entry:
; IS__TUNIT____-NEXT:    ret i32 0
;
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@main
; IS__CGSCC____-SAME: () #[[ATTR2:[0-9]+]] {
; IS__CGSCC____-NEXT:  entry:
; IS__CGSCC____-NEXT:    ret i32 0
;
entry:
  ret i32 0
}
;.
; IS__TUNIT____: attributes #[[ATTR0]] = { nofree nosync nounwind readnone willreturn }
;.
; IS__CGSCC____: attributes #[[ATTR0]] = { nounwind readnone }
; IS__CGSCC____: attributes #[[ATTR1]] = { nounwind readonly }
; IS__CGSCC____: attributes #[[ATTR2]] = { nofree norecurse nosync nounwind readnone willreturn }
;.
