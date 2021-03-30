; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -basic-aa -debugify -loop-idiom -pass-remarks=loop-idiom -pass-remarks-analysis=loop-idiom -verify -verify-each -verify-dom-info -verify-loop-info  < %s -S 2>&1 | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Check that everything still works when debuginfo is present, and that it is reasonably propagated.

; CHECK: remark: <stdin>:6:1: Formed a call to llvm.memcpy.p0i8.p0i8.i64() function

define void @test6_dest_align(i32* noalias align 1 %Base, i32* noalias align 4 %Dest, i64 %Size) nounwind ssp {
; CHECK-LABEL: @test6_dest_align(
; CHECK-NEXT:  bb.nph:
; CHECK-NEXT:    [[DEST1:%.*]] = bitcast i32* [[DEST:%.*]] to i8*
; CHECK-NEXT:    [[BASE2:%.*]] = bitcast i32* [[BASE:%.*]] to i8*
; CHECK-NEXT:    [[TMP0:%.*]] = shl nuw i64 [[SIZE:%.*]], 2, !dbg !18
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 [[DEST1]], i8* align 1 [[BASE2]], i64 [[TMP0]], i1 false), !dbg !19
; CHECK-NEXT:    br label [[FOR_BODY:%.*]], !dbg !18
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVAR:%.*]] = phi i64 [ 0, [[BB_NPH:%.*]] ], [ [[INDVAR_NEXT:%.*]], [[FOR_BODY]] ], !dbg !20
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i64 [[INDVAR]], metadata !9, metadata !DIExpression()), !dbg !20
; CHECK-NEXT:    [[I_0_014:%.*]] = getelementptr i32, i32* [[BASE]], i64 [[INDVAR]], !dbg !21
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32* [[I_0_014]], metadata !11, metadata !DIExpression()), !dbg !21
; CHECK-NEXT:    [[DESTI:%.*]] = getelementptr i32, i32* [[DEST]], i64 [[INDVAR]], !dbg !22
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32* [[DESTI]], metadata !12, metadata !DIExpression()), !dbg !22
; CHECK-NEXT:    [[V:%.*]] = load i32, i32* [[I_0_014]], align 1, !dbg !23
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i32 [[V]], metadata !13, metadata !DIExpression()), !dbg !23
; CHECK-NEXT:    [[INDVAR_NEXT]] = add i64 [[INDVAR]], 1, !dbg !24
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i64 [[INDVAR_NEXT]], metadata !15, metadata !DIExpression()), !dbg !24
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVAR_NEXT]], [[SIZE]], !dbg !25
; CHECK-NEXT:    call void @llvm.dbg.value(metadata i1 [[EXITCOND]], metadata !16, metadata !DIExpression()), !dbg !25
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END:%.*]], label [[FOR_BODY]], !dbg !26
; CHECK:       for.end:
; CHECK-NEXT:    ret void, !dbg !27
;
bb.nph:
  br label %for.body

for.body:                                         ; preds = %bb.nph, %for.body
  %indvar = phi i64 [ 0, %bb.nph ], [ %indvar.next, %for.body ]
  %I.0.014 = getelementptr i32, i32* %Base, i64 %indvar
  %DestI = getelementptr i32, i32* %Dest, i64 %indvar
  %V = load i32, i32* %I.0.014, align 1
  store i32 %V, i32* %DestI, align 4
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp eq i64 %indvar.next, %Size
  br i1 %exitcond, label %for.end, label %for.body

for.end:                                          ; preds = %for.body, %entry
  ret void
}
