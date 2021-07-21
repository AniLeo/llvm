; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -licm -S | FileCheck %s
; RUN: opt -aa-pipeline=basic-aa -passes='require<aa>,require<targetir>,require<scalar-evolution>,require<opt-remark-emit>,loop(licm)' < %s -S | FileCheck %s

target datalayout = "e-m:x-p:32:32-i64:64-f80:32-n8:16:32-a:0:32-S32"
target triple = "i386-pc-windows-msvc18.0.0"

define void @test1(i32* %s, i1 %b) personality i32 (...)* @__CxxFrameHandler3 {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @pure_computation()
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[TRY_CONT_LOOPEXIT:%.*]], label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    invoke void @may_throw()
; CHECK-NEXT:    to label [[WHILE_COND]] unwind label [[CATCH_DISPATCH:%.*]]
; CHECK:       catch.dispatch:
; CHECK-NEXT:    [[DOTLCSSA1:%.*]] = phi i32 [ [[TMP0]], [[WHILE_BODY]] ]
; CHECK-NEXT:    [[CS:%.*]] = catchswitch within none [label %catch] unwind to caller
; CHECK:       catch:
; CHECK-NEXT:    [[CP:%.*]] = catchpad within [[CS]] [i8* null, i32 64, i8* null]
; CHECK-NEXT:    store i32 [[DOTLCSSA1]], i32* [[S:%.*]], align 4
; CHECK-NEXT:    catchret from [[CP]] to label [[TRY_CONT:%.*]]
; CHECK:       try.cont.loopexit:
; CHECK-NEXT:    br label [[TRY_CONT]]
; CHECK:       try.cont:
; CHECK-NEXT:    ret void
;
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %0 = call i32 @pure_computation()
  br i1 %b, label %try.cont, label %while.body

while.body:                                       ; preds = %while.cond
  invoke void @may_throw()
  to label %while.cond unwind label %catch.dispatch

catch.dispatch:                                   ; preds = %while.body
  %.lcssa1 = phi i32 [ %0, %while.body ]
  %cs = catchswitch within none [label %catch] unwind to caller

catch:                                            ; preds = %catch.dispatch
  %cp = catchpad within %cs [i8* null, i32 64, i8* null]
  store i32 %.lcssa1, i32* %s
  catchret from %cp to label %try.cont

try.cont:                                         ; preds = %catch, %while.cond
  ret void
}

define void @test2(i32* %s, i1 %b) personality i32 (...)* @__CxxFrameHandler3 {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[TRY_CONT:%.*]], label [[WHILE_BODY:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    invoke void @may_throw()
; CHECK-NEXT:    to label [[WHILE_COND]] unwind label [[CATCH_DISPATCH:%.*]]
; CHECK:       catch.dispatch:
; CHECK-NEXT:    [[CP:%.*]] = cleanuppad within none []
; CHECK-NEXT:    [[TMP0:%.*]] = call i32 @pure_computation() [ "funclet"(token [[CP]]) ]
; CHECK-NEXT:    store i32 [[TMP0]], i32* [[S:%.*]], align 4
; CHECK-NEXT:    cleanupret from [[CP]] unwind to caller
; CHECK:       try.cont:
; CHECK-NEXT:    ret void
;
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.body, %entry
  %0 = call i32 @pure_computation()
  br i1 %b, label %try.cont, label %while.body

while.body:                                       ; preds = %while.cond
  invoke void @may_throw()
  to label %while.cond unwind label %catch.dispatch

catch.dispatch:                                   ; preds = %while.body
  %.lcssa1 = phi i32 [ %0, %while.body ]
  %cp = cleanuppad within none []
  store i32 %.lcssa1, i32* %s
  cleanupret from %cp unwind to caller

try.cont:                                         ; preds = %catch, %while.cond
  ret void
}

define void @test3(i1 %a, i1 %b, i1 %c) personality i32 (...)* @__CxxFrameHandler3 {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[DOTFRAME:%.*]] = alloca i8, align 4
; CHECK-NEXT:    [[DOTFRAME2:%.*]] = alloca i8, align 4
; CHECK-NEXT:    [[BC:%.*]] = bitcast i8* [[DOTFRAME]] to i32*
; CHECK-NEXT:    [[BC2:%.*]] = bitcast i8* [[DOTFRAME2]] to i32*
; CHECK-NEXT:    br i1 [[A:%.*]], label [[TRY_SUCCESS_OR_CAUGHT:%.*]], label [[FORBODY_PREHEADER:%.*]]
; CHECK:       forbody.preheader:
; CHECK-NEXT:    store i32 1, i32* [[BC]], align 4
; CHECK-NEXT:    store i32 2, i32* [[BC2]], align 4
; CHECK-NEXT:    br label [[FORBODY:%.*]]
; CHECK:       catch.object.Throwable:
; CHECK-NEXT:    [[CP:%.*]] = catchpad within [[CS:%.*]] [i8* null, i32 64, i8* null]
; CHECK-NEXT:    unreachable
; CHECK:       try.success.or.caught.loopexit:
; CHECK-NEXT:    br label [[TRY_SUCCESS_OR_CAUGHT]]
; CHECK:       try.success.or.caught:
; CHECK-NEXT:    ret void
; CHECK:       postinvoke:
; CHECK-NEXT:    br i1 [[B:%.*]], label [[ELSE:%.*]], label [[FORCOND_BACKEDGE:%.*]]
; CHECK:       forcond.backedge:
; CHECK-NEXT:    br i1 [[C:%.*]], label [[TRY_SUCCESS_OR_CAUGHT_LOOPEXIT:%.*]], label [[FORBODY]]
; CHECK:       catch.dispatch:
; CHECK-NEXT:    [[CS]] = catchswitch within none [label %catch.object.Throwable] unwind to caller
; CHECK:       forbody:
; CHECK-NEXT:    invoke void @may_throw()
; CHECK-NEXT:    to label [[POSTINVOKE:%.*]] unwind label [[CATCH_DISPATCH:%.*]]
; CHECK:       else:
; CHECK-NEXT:    invoke void @may_throw()
; CHECK-NEXT:    to label [[FORCOND_BACKEDGE]] unwind label [[CATCH_DISPATCH]]
;
entry:
  %.frame = alloca i8, align 4
  %.frame2 = alloca i8, align 4
  %bc = bitcast i8* %.frame to i32*
  %bc2 = bitcast i8* %.frame2 to i32*
  br i1 %a, label %try.success.or.caught, label %forbody

catch.object.Throwable:                           ; preds = %catch.dispatch
  %cp = catchpad within %cs [i8* null, i32 64, i8* null]
  unreachable

try.success.or.caught:                            ; preds = %forcond.backedge, %0
  ret void

postinvoke:                                       ; preds = %forbody
  br i1 %b, label %else, label %forcond.backedge

forcond.backedge:                                 ; preds = %else, %postinvoke
  br i1 %c, label %try.success.or.caught, label %forbody

catch.dispatch:                                   ; preds = %else, %forbody
  %cs = catchswitch within none [label %catch.object.Throwable] unwind to caller

forbody:                                          ; preds = %forcond.backedge, %0
  store i32 1, i32* %bc, align 4
  store i32 2, i32* %bc2, align 4
  invoke void @may_throw()
  to label %postinvoke unwind label %catch.dispatch

else:                                             ; preds = %postinvoke
  invoke void @may_throw()
  to label %forcond.backedge unwind label %catch.dispatch
}

declare void @may_throw()

declare i32 @pure_computation() nounwind argmemonly readonly willreturn

declare i32 @__CxxFrameHandler3(...)
