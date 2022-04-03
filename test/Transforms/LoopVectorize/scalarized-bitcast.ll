; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; REQUIRES: asserts
; RUN: opt -loop-vectorize -force-vector-width=2 -debug-only=loop-vectorize -S -o - < %s 2>&1 | FileCheck %s

%struct.foo = type { i32, i64 }

; CHECK: LV: Found an estimated cost of 0 for VF 2 For instruction:   %0 = bitcast i64* %b to i32*

; The bitcast below will be scalarized due to the predication in the loop. Bitcasts
; between pointer types should be treated as free, despite the scalarization.
define void @foo(%struct.foo* noalias nocapture %in, i32* noalias nocapture readnone %out, i64 %n) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[N:%.*]], 2
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[N]], -1
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr [[STRUCT_FOO:%.*]], %struct.foo* [[IN:%.*]], i64 0, i32 1
; CHECK-NEXT:    [[SCEVGEP1:%.*]] = bitcast i64* [[SCEVGEP]] to %struct.foo*
; CHECK-NEXT:    [[MUL:%.*]] = call { i64, i1 } @llvm.umul.with.overflow.i64(i64 12, i64 [[TMP0]])
; CHECK-NEXT:    [[MUL_RESULT:%.*]] = extractvalue { i64, i1 } [[MUL]], 0
; CHECK-NEXT:    [[MUL_OVERFLOW:%.*]] = extractvalue { i64, i1 } [[MUL]], 1
; CHECK-NEXT:    [[SCEVGEP12:%.*]] = bitcast %struct.foo* [[SCEVGEP1]] to i8*
; CHECK-NEXT:    [[TMP1:%.*]] = sub i64 0, [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr i8, i8* [[SCEVGEP12]], i64 [[MUL_RESULT]]
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ult i8* [[TMP2]], [[SCEVGEP12]]
; CHECK-NEXT:    [[TMP4:%.*]] = or i1 [[TMP3]], [[MUL_OVERFLOW]]
; CHECK-NEXT:    br i1 [[TMP4]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[N]], 2
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[N]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_STORE_CONTINUE6:%.*]] ]
; CHECK-NEXT:    [[TMP5:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP6:%.*]] = add i64 [[INDEX]], 1
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds [[STRUCT_FOO]], %struct.foo* [[IN]], i64 [[TMP5]], i32 1
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds [[STRUCT_FOO]], %struct.foo* [[IN]], i64 [[TMP6]], i32 1
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast i64* [[TMP7]] to i32*
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i64* [[TMP8]] to i32*
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds [[STRUCT_FOO]], %struct.foo* [[IN]], i64 [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds [[STRUCT_FOO]], %struct.foo* [[IN]], i64 [[TMP6]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = load i32, i32* [[TMP11]], align 8
; CHECK-NEXT:    [[TMP14:%.*]] = load i32, i32* [[TMP12]], align 8
; CHECK-NEXT:    [[TMP15:%.*]] = insertelement <2 x i32> poison, i32 [[TMP13]], i32 0
; CHECK-NEXT:    [[TMP16:%.*]] = insertelement <2 x i32> [[TMP15]], i32 [[TMP14]], i32 1
; CHECK-NEXT:    [[TMP17:%.*]] = icmp eq <2 x i32> [[TMP16]], zeroinitializer
; CHECK-NEXT:    [[TMP18:%.*]] = xor <2 x i1> [[TMP17]], <i1 true, i1 true>
; CHECK-NEXT:    [[TMP19:%.*]] = extractelement <2 x i1> [[TMP18]], i32 0
; CHECK-NEXT:    br i1 [[TMP19]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[TMP20:%.*]] = load i32, i32* [[TMP9]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP21:%.*]] = phi i32 [ poison, [[VECTOR_BODY]] ], [ [[TMP20]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP22:%.*]] = extractelement <2 x i1> [[TMP18]], i32 1
; CHECK-NEXT:    br i1 [[TMP22]], label [[PRED_LOAD_IF3:%.*]], label [[PRED_LOAD_CONTINUE4:%.*]]
; CHECK:       pred.load.if3:
; CHECK-NEXT:    [[TMP23:%.*]] = load i32, i32* [[TMP10]], align 4
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE4]]
; CHECK:       pred.load.continue4:
; CHECK-NEXT:    [[TMP24:%.*]] = phi i32 [ poison, [[PRED_LOAD_CONTINUE]] ], [ [[TMP23]], [[PRED_LOAD_IF3]] ]
; CHECK-NEXT:    [[TMP25:%.*]] = insertelement <2 x i32> poison, i32 [[TMP21]], i32 0
; CHECK-NEXT:    [[TMP26:%.*]] = insertelement <2 x i32> [[TMP25]], i32 [[TMP24]], i32 1
; CHECK-NEXT:    [[TMP27:%.*]] = icmp sgt <2 x i32> [[TMP26]], zeroinitializer
; CHECK-NEXT:    [[TMP28:%.*]] = select <2 x i1> [[TMP18]], <2 x i1> [[TMP27]], <2 x i1> zeroinitializer
; CHECK-NEXT:    [[TMP29:%.*]] = extractelement <2 x i1> [[TMP28]], i32 0
; CHECK-NEXT:    br i1 [[TMP29]], label [[PRED_STORE_IF:%.*]], label [[PRED_STORE_CONTINUE:%.*]]
; CHECK:       pred.store.if:
; CHECK-NEXT:    [[TMP30:%.*]] = add nsw i32 [[TMP21]], -1
; CHECK-NEXT:    store i32 [[TMP30]], i32* [[TMP9]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE]]
; CHECK:       pred.store.continue:
; CHECK-NEXT:    [[TMP31:%.*]] = extractelement <2 x i1> [[TMP28]], i32 1
; CHECK-NEXT:    br i1 [[TMP31]], label [[PRED_STORE_IF5:%.*]], label [[PRED_STORE_CONTINUE6]]
; CHECK:       pred.store.if5:
; CHECK-NEXT:    [[TMP32:%.*]] = add nsw i32 [[TMP24]], -1
; CHECK-NEXT:    store i32 [[TMP32]], i32* [[TMP10]], align 4
; CHECK-NEXT:    br label [[PRED_STORE_CONTINUE6]]
; CHECK:       pred.store.continue6:
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[TMP33:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP33]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[N]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[I_012:%.*]] = phi i64 [ [[INC:%.*]], [[IF_END:%.*]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[B:%.*]] = getelementptr inbounds [[STRUCT_FOO]], %struct.foo* [[IN]], i64 [[I_012]], i32 1
; CHECK-NEXT:    [[TMP34:%.*]] = bitcast i64* [[B]] to i32*
; CHECK-NEXT:    [[A:%.*]] = getelementptr inbounds [[STRUCT_FOO]], %struct.foo* [[IN]], i64 [[I_012]], i32 0
; CHECK-NEXT:    [[TMP35:%.*]] = load i32, i32* [[A]], align 8
; CHECK-NEXT:    [[TOBOOL_NOT:%.*]] = icmp eq i32 [[TMP35]], 0
; CHECK-NEXT:    br i1 [[TOBOOL_NOT]], label [[IF_END]], label [[LAND_LHS_TRUE:%.*]]
; CHECK:       land.lhs.true:
; CHECK-NEXT:    [[TMP36:%.*]] = load i32, i32* [[TMP34]], align 4
; CHECK-NEXT:    [[CMP2:%.*]] = icmp sgt i32 [[TMP36]], 0
; CHECK-NEXT:    br i1 [[CMP2]], label [[IF_THEN:%.*]], label [[IF_END]]
; CHECK:       if.then:
; CHECK-NEXT:    [[SUB:%.*]] = add nsw i32 [[TMP36]], -1
; CHECK-NEXT:    store i32 [[SUB]], i32* [[TMP34]], align 4
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[INC]] = add nuw nsw i64 [[I_012]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[INC]], [[N]]
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:                                         ; preds = %entry, %if.end
  %i.012 = phi i64 [ %inc, %if.end ], [ 0, %entry ]
  %b = getelementptr inbounds %struct.foo, %struct.foo* %in, i64 %i.012, i32 1
  %0 = bitcast i64* %b to i32*
  %a = getelementptr inbounds %struct.foo, %struct.foo* %in, i64 %i.012, i32 0
  %1 = load i32, i32* %a, align 8
  %tobool.not = icmp eq i32 %1, 0
  br i1 %tobool.not, label %if.end, label %land.lhs.true

land.lhs.true:                                    ; preds = %for.body
  %2 = load i32, i32* %0, align 4
  %cmp2 = icmp sgt i32 %2, 0
  br i1 %cmp2, label %if.then, label %if.end

if.then:                                          ; preds = %land.lhs.true
  %sub = add nsw i32 %2, -1
  store i32 %sub, i32* %0, align 4
  br label %if.end

if.end:                                           ; preds = %if.then, %land.lhs.true, %for.body
  %inc = add nuw nsw i64 %i.012, 1
  %exitcond.not = icmp eq i64 %inc, %n
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:                                          ; preds = %if.end
  ret void
}
