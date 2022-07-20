; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -force-vector-width=4 -force-vector-interleave=1 -passes=loop-vectorize -S | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

define i8 @PR34687(i1 %c, i32 %x, i32 %n) {
; CHECK-LABEL: @PR34687(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[N:%.*]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[N]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <4 x i1> poison, i1 [[C:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <4 x i1> [[BROADCAST_SPLATINSERT]], <4 x i1> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT7:%.*]] = insertelement <4 x i32> poison, i32 [[X:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT8:%.*]] = shufflevector <4 x i32> [[BROADCAST_SPLATINSERT7]], <4 x i32> poison, <4 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_SDIV_CONTINUE6:%.*]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP16:%.*]], [[PRED_SDIV_CONTINUE6]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <4 x i1> [[BROADCAST_SPLAT]], i32 0
; CHECK-NEXT:    br i1 [[TMP0]], label [[PRED_SDIV_IF:%.*]], label [[PRED_SDIV_CONTINUE:%.*]]
; CHECK:       pred.sdiv.if:
; CHECK-NEXT:    [[TMP1:%.*]] = sdiv i32 undef, undef
; CHECK-NEXT:    br label [[PRED_SDIV_CONTINUE]]
; CHECK:       pred.sdiv.continue:
; CHECK-NEXT:    [[TMP2:%.*]] = phi i32 [ poison, [[VECTOR_BODY]] ], [ [[TMP1]], [[PRED_SDIV_IF]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <4 x i1> [[BROADCAST_SPLAT]], i32 1
; CHECK-NEXT:    br i1 [[TMP3]], label [[PRED_SDIV_IF1:%.*]], label [[PRED_SDIV_CONTINUE2:%.*]]
; CHECK:       pred.sdiv.if1:
; CHECK-NEXT:    [[TMP4:%.*]] = sdiv i32 undef, undef
; CHECK-NEXT:    br label [[PRED_SDIV_CONTINUE2]]
; CHECK:       pred.sdiv.continue2:
; CHECK-NEXT:    [[TMP5:%.*]] = phi i32 [ poison, [[PRED_SDIV_CONTINUE]] ], [ [[TMP4]], [[PRED_SDIV_IF1]] ]
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <4 x i1> [[BROADCAST_SPLAT]], i32 2
; CHECK-NEXT:    br i1 [[TMP6]], label [[PRED_SDIV_IF3:%.*]], label [[PRED_SDIV_CONTINUE4:%.*]]
; CHECK:       pred.sdiv.if3:
; CHECK-NEXT:    [[TMP7:%.*]] = sdiv i32 undef, undef
; CHECK-NEXT:    br label [[PRED_SDIV_CONTINUE4]]
; CHECK:       pred.sdiv.continue4:
; CHECK-NEXT:    [[TMP8:%.*]] = phi i32 [ poison, [[PRED_SDIV_CONTINUE2]] ], [ [[TMP7]], [[PRED_SDIV_IF3]] ]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <4 x i1> [[BROADCAST_SPLAT]], i32 3
; CHECK-NEXT:    br i1 [[TMP9]], label [[PRED_SDIV_IF5:%.*]], label [[PRED_SDIV_CONTINUE6]]
; CHECK:       pred.sdiv.if5:
; CHECK-NEXT:    [[TMP10:%.*]] = sdiv i32 undef, undef
; CHECK-NEXT:    br label [[PRED_SDIV_CONTINUE6]]
; CHECK:       pred.sdiv.continue6:
; CHECK-NEXT:    [[TMP11:%.*]] = phi i32 [ poison, [[PRED_SDIV_CONTINUE4]] ], [ [[TMP10]], [[PRED_SDIV_IF5]] ]
; CHECK-NEXT:    [[TMP12:%.*]] = and <4 x i32> [[VEC_PHI]], <i32 255, i32 255, i32 255, i32 255>
; CHECK-NEXT:    [[TMP13:%.*]] = add <4 x i32> [[TMP12]], [[BROADCAST_SPLAT8]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP14:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    [[TMP15:%.*]] = trunc <4 x i32> [[TMP13]] to <4 x i8>
; CHECK-NEXT:    [[TMP16]] = zext <4 x i8> [[TMP15]] to <4 x i32>
; CHECK-NEXT:    br i1 [[TMP14]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP17:%.*]] = trunc <4 x i32> [[TMP16]] to <4 x i8>
; CHECK-NEXT:    [[TMP18:%.*]] = call i8 @llvm.vector.reduce.add.v4i8(<4 x i8> [[TMP17]])
; CHECK-NEXT:    [[TMP19:%.*]] = zext i8 [[TMP18]] to i32
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[TMP19]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[I_NEXT:%.*]], [[IF_END:%.*]] ]
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[R_NEXT:%.*]], [[IF_END]] ]
; CHECK-NEXT:    br i1 [[C]], label [[IF_THEN:%.*]], label [[IF_END]]
; CHECK:       if.then:
; CHECK-NEXT:    [[T0:%.*]] = sdiv i32 undef, undef
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[T1:%.*]] = and i32 [[R]], 255
; CHECK-NEXT:    [[I_NEXT]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    [[R_NEXT]] = add nuw nsw i32 [[T1]], [[X]]
; CHECK-NEXT:    [[COND:%.*]] = icmp eq i32 [[I_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    [[T2:%.*]] = phi i32 [ [[R_NEXT]], [[IF_END]] ], [ [[TMP19]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[T3:%.*]] = trunc i32 [[T2]] to i8
; CHECK-NEXT:    ret i8 [[T3]]
;
entry:
  br label %for.body

for.body:
  %i = phi i32 [ 0, %entry ], [ %i.next, %if.end ]
  %r = phi i32 [ 0, %entry ], [ %r.next, %if.end ]
  br i1 %c, label %if.then, label %if.end

if.then:
  %t0 = sdiv i32 undef, undef
  br label %if.end

if.end:
  %t1 = and i32 %r, 255
  %i.next = add nsw i32 %i, 1
  %r.next = add nuw nsw i32 %t1, %x
  %cond = icmp eq i32 %i.next, %n
  br i1 %cond, label %for.end, label %for.body

for.end:
  %t2 = phi i32 [ %r.next, %if.end ]
  %t3 = trunc i32 %t2 to i8
  ret i8 %t3
}

define i32 @PR35734(i32 %x, i32 %y) {
; CHECK-LABEL: @PR35734(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SMAX:%.*]] = call i32 @llvm.smax.i32(i32 [[X:%.*]], i32 78)
; CHECK-NEXT:    [[TMP0:%.*]] = add i32 [[SMAX]], 1
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 [[TMP0]], [[X]]
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i32 [[TMP1]], 4
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i32 [[TMP1]], 4
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i32 [[TMP1]], [[N_MOD_VF]]
; CHECK-NEXT:    [[IND_END:%.*]] = add i32 [[X]], [[N_VEC]]
; CHECK-NEXT:    [[TMP2:%.*]] = insertelement <4 x i32> zeroinitializer, i32 [[Y:%.*]], i32 0
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <4 x i32> [ [[TMP2]], [[VECTOR_PH]] ], [ [[TMP7:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP3:%.*]] = and <4 x i32> [[VEC_PHI]], <i32 1, i32 1, i32 1, i32 1>
; CHECK-NEXT:    [[TMP4:%.*]] = add <4 x i32> [[TMP3]], <i32 -1, i32 -1, i32 -1, i32 -1>
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 4
; CHECK-NEXT:    [[TMP5:%.*]] = icmp eq i32 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    [[TMP6:%.*]] = trunc <4 x i32> [[TMP4]] to <4 x i1>
; CHECK-NEXT:    [[TMP7]] = sext <4 x i1> [[TMP6]] to <4 x i32>
; CHECK-NEXT:    br i1 [[TMP5]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP8:%.*]] = trunc <4 x i32> [[TMP7]] to <4 x i1>
; CHECK-NEXT:    [[TMP9:%.*]] = call i1 @llvm.vector.reduce.add.v4i1(<4 x i1> [[TMP8]])
; CHECK-NEXT:    [[TMP10:%.*]] = sext i1 [[TMP9]] to i32
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 [[TMP1]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ [[IND_END]], [[MIDDLE_BLOCK]] ], [ [[X]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ [[Y]], [[ENTRY]] ], [ [[TMP10]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[I_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[R:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[R_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[T0:%.*]] = and i32 [[R]], 1
; CHECK-NEXT:    [[R_NEXT]] = add i32 [[T0]], -1
; CHECK-NEXT:    [[I_NEXT]] = add nsw i32 [[I]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp sgt i32 [[I]], 77
; CHECK-NEXT:    br i1 [[COND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    [[T1:%.*]] = phi i32 [ [[R_NEXT]], [[FOR_BODY]] ], [ [[TMP10]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i32 [[T1]]
;
entry:
  br label %for.body

for.body:
  %i = phi i32 [ %x, %entry ], [ %i.next, %for.body ]
  %r = phi i32 [ %y, %entry ], [ %r.next, %for.body ]
  %t0 = and i32 %r, 1
  %r.next = add i32 %t0, -1
  %i.next = add nsw i32 %i, 1
  %cond = icmp sgt i32 %i, 77
  br i1 %cond, label %for.end, label %for.body

for.end:
  %t1 = phi i32 [ %r.next, %for.body ]
  ret i32 %t1
}

define i32 @pr51794_signed_negative(i16 %iv.start, i32 %xor.start) {
; CHECK-LABEL: @pr51794_signed_negative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[XOR_RED:%.*]] = phi i32 [ [[XOR_START:%.*]], [[ENTRY:%.*]] ], [ [[XOR:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV:%.*]] = phi i16 [ [[IV_START:%.*]], [[ENTRY]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add i16 [[IV]], -1
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[XOR_RED]], 1
; CHECK-NEXT:    [[XOR]] = xor i32 [[AND]], -1
; CHECK-NEXT:    [[TOBOOL_NOT:%.*]] = icmp eq i16 [[IV_NEXT]], 0
; CHECK-NEXT:    br i1 [[TOBOOL_NOT]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[XOR_LCSSA:%.*]] = phi i32 [ [[XOR]], [[LOOP]] ]
; CHECK-NEXT:    ret i32 [[XOR_LCSSA]]
;
entry:
  br label %loop

loop:
  %xor.red = phi i32 [ %xor.start, %entry ], [ %xor, %loop ]
  %iv = phi i16 [ %iv.start, %entry ], [ %iv.next, %loop ]
  %iv.next = add i16 %iv, -1
  %and = and i32 %xor.red, 1
  %xor = xor i32 %and, -1
  %tobool.not = icmp eq i16 %iv.next, 0
  br i1 %tobool.not, label %exit, label %loop

exit:
  %xor.lcssa = phi i32 [ %xor, %loop ]
  ret i32 %xor.lcssa
}

define i32 @pr52485_signed_negative(i32 %xor.start) {
; CHECK-LABEL: @pr52485_signed_negative(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ -23, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[XOR_RED:%.*]] = phi i32 [ [[XOR_START:%.*]], [[ENTRY]] ], [ [[XOR:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[XOR_RED]], 255
; CHECK-NEXT:    [[XOR]] = xor i32 [[AND]], -9
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 2
; CHECK-NEXT:    [[CMP_NOT:%.*]] = icmp eq i32 [[IV_NEXT]], -15
; CHECK-NEXT:    br i1 [[CMP_NOT]], label [[EXIT:%.*]], label [[LOOP]]
; CHECK:       exit:
; CHECK-NEXT:    [[XOR_LCSSA:%.*]] = phi i32 [ [[XOR]], [[LOOP]] ]
; CHECK-NEXT:    ret i32 [[XOR_LCSSA]]
;
entry:
  br label %loop

loop:
  %iv = phi i32 [ -23, %entry ], [ %iv.next, %loop ]
  %xor.red = phi i32 [ %xor.start, %entry ], [ %xor, %loop ]
  %and = and i32 %xor.red, 255
  %xor = xor i32 %and, -9
  %iv.next = add nuw nsw i32 %iv, 2
  %cmp.not = icmp eq i32 %iv.next, -15
  br i1 %cmp.not, label %exit, label %loop

exit:
  %xor.lcssa = phi i32 [ %xor, %loop ]
  ret i32 %xor.lcssa
}
