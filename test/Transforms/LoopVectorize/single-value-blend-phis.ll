; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -force-vector-width=2 -S %s | FileCheck %s

@src = external global [32 x i16], align 1
@dst = external global [32 x i16], align 1

; The load in the loop does not need predication, because the accessed memory
; is de-referenceable for all loop iterations.
define void @single_incoming_phi_no_blend_mask(i64 %a, i64 %b) {
; CHECK-LABEL: @single_incoming_phi_no_blend_mask(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i64> poison, i64 [[A:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT]], <2 x i64> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i64> [ <i64 0, i64 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[INDEX]] to i16
; CHECK-NEXT:    [[TMP1:%.*]] = add i16 [[TMP0]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 [[TMP1]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i16, i16* [[TMP3]], i32 0
; CHECK-NEXT:    [[TMP5:%.*]] = bitcast i16* [[TMP4]] to <2 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x i16>, <2 x i16>* [[TMP5]], align 1
; CHECK-NEXT:    [[TMP6:%.*]] = icmp sgt <2 x i64> [[VEC_IND]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP7:%.*]] = xor <2 x i1> [[TMP6]], <i1 true, i1 true>
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP6]], <2 x i16> <i16 1, i16 1>, <2 x i16> [[WIDE_LOAD]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @dst, i16 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP9:%.*]] = getelementptr inbounds i16, i16* [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = bitcast i16* [[TMP9]] to <2 x i16>*
; CHECK-NEXT:    store <2 x i16> [[PREDPHI]], <2 x i16>* [[TMP10]], align 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i64> [[VEC_IND]], <i64 2, i64 2>
; CHECK-NEXT:    [[TMP11:%.*]] = icmp eq i64 [[INDEX_NEXT]], 32
; CHECK-NEXT:    br i1 [[TMP11]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 32, 32
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 32, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[IV_TRUNC:%.*]] = trunc i64 [[IV]] to i16
; CHECK-NEXT:    br label [[LOOP_COND:%.*]]
; CHECK:       loop.cond:
; CHECK-NEXT:    [[BLEND:%.*]] = phi i16 [ [[IV_TRUNC]], [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[SRC_PTR:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 [[BLEND]]
; CHECK-NEXT:    [[LV:%.*]] = load i16, i16* [[SRC_PTR]], align 1
; CHECK-NEXT:    [[CMP_B:%.*]] = icmp sgt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 [[CMP_B]], label [[LOOP_NEXT:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.next:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[RES:%.*]] = phi i16 [ [[LV]], [[LOOP_COND]] ], [ 1, [[LOOP_NEXT]] ]
; CHECK-NEXT:    [[DST_PTR:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @dst, i16 0, i64 [[IV]]
; CHECK-NEXT:    store i16 [[RES]], i16* [[DST_PTR]], align 2
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[CMP439:%.*]] = icmp ult i64 [[IV]], 31
; CHECK-NEXT:    br i1 [[CMP439]], label [[LOOP_HEADER]], label [[EXIT]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %iv.trunc = trunc i64 %iv to i16
  br label %loop.cond

loop.cond:
  %blend = phi i16 [ %iv.trunc, %loop.header ]
  %src.ptr = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 %blend
  %lv = load i16, i16* %src.ptr, align 1
  %cmp.b = icmp sgt i64 %iv, %a
  br i1 %cmp.b, label %loop.next, label %loop.latch

loop.next:
  br label %loop.latch

loop.latch:
  %res = phi i16 [ %lv, %loop.cond ], [ 1, %loop.next ]
  %dst.ptr = getelementptr inbounds [32 x i16], [32 x i16]* @dst, i16 0, i64 %iv
  store i16 %res, i16* %dst.ptr
  %iv.next = add nuw nsw i64 %iv, 1
  %cmp439 = icmp ult i64 %iv, 31
  br i1 %cmp439, label %loop.header, label %exit

exit:
  ret void
}

; The load in the loop does not need predication, because the accessed memory
; is de-referenceable for all loop iterations.
define void @single_incoming_phi_with_blend_mask(i64 %a, i64 %b) {
; CHECK-LABEL: @single_incoming_phi_with_blend_mask(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i64> poison, i64 [[A:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT]], <2 x i64> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i64> [ <i64 0, i64 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[INDEX]] to i16
; CHECK-NEXT:    [[TMP1:%.*]] = add i16 [[TMP0]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = icmp ugt <2 x i64> [[VEC_IND]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr [32 x i16], [32 x i16]* @src, i16 0, i16 [[TMP1]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr i16, i16* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast i16* [[TMP5]] to <2 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x i16>, <2 x i16>* [[TMP6]], align 1
; CHECK-NEXT:    [[TMP7:%.*]] = icmp sgt <2 x i64> [[VEC_IND]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP8:%.*]] = xor <2 x i1> [[TMP3]], <i1 true, i1 true>
; CHECK-NEXT:    [[TMP9:%.*]] = xor <2 x i1> [[TMP7]], <i1 true, i1 true>
; CHECK-NEXT:    [[TMP10:%.*]] = select <2 x i1> [[TMP3]], <2 x i1> [[TMP9]], <2 x i1> zeroinitializer
; CHECK-NEXT:    [[TMP11:%.*]] = select <2 x i1> [[TMP3]], <2 x i1> [[TMP7]], <2 x i1> zeroinitializer
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP10]], <2 x i16> [[WIDE_LOAD]], <2 x i16> zeroinitializer
; CHECK-NEXT:    [[PREDPHI1:%.*]] = select <2 x i1> [[TMP11]], <2 x i16> <i16 1, i16 1>, <2 x i16> [[PREDPHI]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @dst, i16 0, i64 [[TMP2]]
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds i16, i16* [[TMP12]], i32 0
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast i16* [[TMP13]] to <2 x i16>*
; CHECK-NEXT:    store <2 x i16> [[PREDPHI1]], <2 x i16>* [[TMP14]], align 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i64> [[VEC_IND]], <i64 2, i64 2>
; CHECK-NEXT:    [[TMP15:%.*]] = icmp eq i64 [[INDEX_NEXT]], 32
; CHECK-NEXT:    br i1 [[TMP15]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 32, 32
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 32, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[IV_TRUNC:%.*]] = trunc i64 [[IV]] to i16
; CHECK-NEXT:    [[CMP_A:%.*]] = icmp ugt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 [[CMP_A]], label [[LOOP_COND:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.cond:
; CHECK-NEXT:    [[BLEND:%.*]] = phi i16 [ [[IV_TRUNC]], [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[SRC_PTR:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 [[BLEND]]
; CHECK-NEXT:    [[LV:%.*]] = load i16, i16* [[SRC_PTR]], align 1
; CHECK-NEXT:    [[CMP_B:%.*]] = icmp sgt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 [[CMP_B]], label [[LOOP_NEXT:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.next:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[RES:%.*]] = phi i16 [ 0, [[LOOP_HEADER]] ], [ [[LV]], [[LOOP_COND]] ], [ 1, [[LOOP_NEXT]] ]
; CHECK-NEXT:    [[DST_PTR:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @dst, i16 0, i64 [[IV]]
; CHECK-NEXT:    store i16 [[RES]], i16* [[DST_PTR]], align 2
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[CMP439:%.*]] = icmp ult i64 [[IV]], 31
; CHECK-NEXT:    br i1 [[CMP439]], label [[LOOP_HEADER]], label [[EXIT]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %iv.trunc = trunc i64 %iv to i16
  %cmp.a = icmp ugt i64 %iv, %a
  br i1 %cmp.a, label %loop.cond, label %loop.latch

loop.cond:
  %blend = phi i16 [ %iv.trunc, %loop.header ]
  %src.ptr = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 %blend
  %lv = load i16, i16* %src.ptr, align 1
  %cmp.b = icmp sgt i64 %iv, %a
  br i1 %cmp.b, label %loop.next, label %loop.latch

loop.next:
  br label %loop.latch

loop.latch:
  %res = phi i16 [ 0, %loop.header ], [ %lv, %loop.cond ], [ 1, %loop.next ]
  %dst.ptr = getelementptr inbounds [32 x i16], [32 x i16]* @dst, i16 0, i64 %iv
  store i16 %res, i16* %dst.ptr
  %iv.next = add nuw nsw i64 %iv, 1
  %cmp439 = icmp ult i64 %iv, 31
  br i1 %cmp439, label %loop.header, label %exit

exit:
  ret void
}

define void @multiple_incoming_phi_with_blend_mask(i64 %a, i16* noalias %dst) {
; CHECK-LABEL: @multiple_incoming_phi_with_blend_mask(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i64> poison, i64 [[A:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT]], <2 x i64> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i64> [ <i64 0, i64 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND1:%.*]] = phi <2 x i16> [ <i16 0, i16 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT2:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND3:%.*]] = phi <2 x i16> [ <i16 0, i16 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT4:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt <2 x i64> [[VEC_IND]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor <2 x i1> [[TMP1]], <i1 true, i1 true>
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP1]], <2 x i16> [[VEC_IND3]], <2 x i16> [[VEC_IND1]]
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x i16> [[PREDPHI]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = extractelement <2 x i16> [[PREDPHI]], i32 1
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = load i16, i16* [[TMP4]], align 1
; CHECK-NEXT:    [[TMP8:%.*]] = load i16, i16* [[TMP6]], align 1
; CHECK-NEXT:    [[TMP9:%.*]] = insertelement <2 x i16> poison, i16 [[TMP7]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = insertelement <2 x i16> [[TMP9]], i16 [[TMP8]], i32 1
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i16, i16* [[DST:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i16, i16* [[TMP11]], i32 0
; CHECK-NEXT:    [[TMP13:%.*]] = bitcast i16* [[TMP12]] to <2 x i16>*
; CHECK-NEXT:    store <2 x i16> [[TMP10]], <2 x i16>* [[TMP13]], align 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i64> [[VEC_IND]], <i64 2, i64 2>
; CHECK-NEXT:    [[VEC_IND_NEXT2]] = add <2 x i16> [[VEC_IND1]], <i16 2, i16 2>
; CHECK-NEXT:    [[VEC_IND_NEXT4]] = add <2 x i16> [[VEC_IND3]], <i16 2, i16 2>
; CHECK-NEXT:    [[TMP14:%.*]] = icmp eq i64 [[INDEX_NEXT]], 32
; CHECK-NEXT:    br i1 [[TMP14]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 32, 32
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 32, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[IV_TRUNC:%.*]] = trunc i64 [[IV]] to i16
; CHECK-NEXT:    [[IV_TRUNC_2:%.*]] = trunc i64 [[IV]] to i16
; CHECK-NEXT:    [[CMP_A:%.*]] = icmp ugt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 [[CMP_A]], label [[LOOP_NEXT:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.next:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[BLEND:%.*]] = phi i16 [ [[IV_TRUNC]], [[LOOP_HEADER]] ], [ [[IV_TRUNC_2]], [[LOOP_NEXT]] ]
; CHECK-NEXT:    [[SRC_PTR:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 [[BLEND]]
; CHECK-NEXT:    [[LV:%.*]] = load i16, i16* [[SRC_PTR]], align 1
; CHECK-NEXT:    [[DST_PTR:%.*]] = getelementptr inbounds i16, i16* [[DST]], i64 [[IV]]
; CHECK-NEXT:    store i16 [[LV]], i16* [[DST_PTR]], align 2
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[CMP439:%.*]] = icmp ult i64 [[IV]], 31
; CHECK-NEXT:    br i1 [[CMP439]], label [[LOOP_HEADER]], label [[EXIT]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %iv.trunc = trunc i64 %iv to i16
  %iv.trunc.2 = trunc i64 %iv to i16
  %cmp.a = icmp ugt i64 %iv, %a
  br i1 %cmp.a, label %loop.next, label %loop.latch

loop.next:
  br label %loop.latch

loop.latch:
  %blend = phi i16 [ %iv.trunc, %loop.header ], [ %iv.trunc.2, %loop.next ]
  %src.ptr = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 %blend
  %lv = load i16, i16* %src.ptr, align 1
  %dst.ptr = getelementptr inbounds i16, i16* %dst, i64 %iv
  store i16 %lv, i16* %dst.ptr
  %iv.next = add nuw nsw i64 %iv, 1
  %cmp439 = icmp ult i64 %iv, 31
  br i1 %cmp439, label %loop.header, label %exit

exit:
  ret void
}

; The load in the loop needs predication, because the accessed memory is not
; de-referencable for all iterations of the loop.
define void @single_incoming_needs_predication(i64 %a, i64 %b) {
; CHECK-LABEL: @single_incoming_needs_predication(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i64> poison, i64 [[A:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i64> [[BROADCAST_SPLATINSERT]], <2 x i64> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[PRED_LOAD_CONTINUE4:%.*]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i64> [ <i64 0, i64 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[PRED_LOAD_CONTINUE4]] ]
; CHECK-NEXT:    [[VEC_IND1:%.*]] = phi <2 x i16> [ <i16 0, i16 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT2:%.*]], [[PRED_LOAD_CONTINUE4]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt <2 x i64> [[VEC_IND]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP2:%.*]] = extractelement <2 x i1> [[TMP1]], i32 0
; CHECK-NEXT:    br i1 [[TMP2]], label [[PRED_LOAD_IF:%.*]], label [[PRED_LOAD_CONTINUE:%.*]]
; CHECK:       pred.load.if:
; CHECK-NEXT:    [[TMP3:%.*]] = extractelement <2 x i16> [[VEC_IND1]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 [[TMP3]]
; CHECK-NEXT:    [[TMP5:%.*]] = load i16, i16* [[TMP4]], align 1
; CHECK-NEXT:    [[TMP6:%.*]] = insertelement <2 x i16> poison, i16 [[TMP5]], i32 0
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE]]
; CHECK:       pred.load.continue:
; CHECK-NEXT:    [[TMP7:%.*]] = phi <2 x i16> [ poison, [[VECTOR_BODY]] ], [ [[TMP6]], [[PRED_LOAD_IF]] ]
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x i1> [[TMP1]], i32 1
; CHECK-NEXT:    br i1 [[TMP8]], label [[PRED_LOAD_IF3:%.*]], label [[PRED_LOAD_CONTINUE4]]
; CHECK:       pred.load.if3:
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i16> [[VEC_IND1]], i32 1
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 [[TMP9]]
; CHECK-NEXT:    [[TMP11:%.*]] = load i16, i16* [[TMP10]], align 1
; CHECK-NEXT:    [[TMP12:%.*]] = insertelement <2 x i16> [[TMP7]], i16 [[TMP11]], i32 1
; CHECK-NEXT:    br label [[PRED_LOAD_CONTINUE4]]
; CHECK:       pred.load.continue4:
; CHECK-NEXT:    [[TMP13:%.*]] = phi <2 x i16> [ [[TMP7]], [[PRED_LOAD_CONTINUE]] ], [ [[TMP12]], [[PRED_LOAD_IF3]] ]
; CHECK-NEXT:    [[TMP14:%.*]] = icmp sgt <2 x i64> [[VEC_IND]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    [[TMP15:%.*]] = xor <2 x i1> [[TMP1]], <i1 true, i1 true>
; CHECK-NEXT:    [[TMP16:%.*]] = xor <2 x i1> [[TMP14]], <i1 true, i1 true>
; CHECK-NEXT:    [[TMP17:%.*]] = select <2 x i1> [[TMP1]], <2 x i1> [[TMP16]], <2 x i1> zeroinitializer
; CHECK-NEXT:    [[TMP18:%.*]] = select <2 x i1> [[TMP1]], <2 x i1> [[TMP14]], <2 x i1> zeroinitializer
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP17]], <2 x i16> [[TMP13]], <2 x i16> zeroinitializer
; CHECK-NEXT:    [[PREDPHI5:%.*]] = select <2 x i1> [[TMP18]], <2 x i16> <i16 1, i16 1>, <2 x i16> [[PREDPHI]]
; CHECK-NEXT:    [[TMP19:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @dst, i16 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP20:%.*]] = getelementptr inbounds i16, i16* [[TMP19]], i32 0
; CHECK-NEXT:    [[TMP21:%.*]] = bitcast i16* [[TMP20]] to <2 x i16>*
; CHECK-NEXT:    store <2 x i16> [[PREDPHI5]], <2 x i16>* [[TMP21]], align 2
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i64> [[VEC_IND]], <i64 2, i64 2>
; CHECK-NEXT:    [[VEC_IND_NEXT2]] = add <2 x i16> [[VEC_IND1]], <i16 2, i16 2>
; CHECK-NEXT:    [[TMP22:%.*]] = icmp eq i64 [[INDEX_NEXT]], 64
; CHECK-NEXT:    br i1 [[TMP22]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 64, 64
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 64, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[IV_TRUNC:%.*]] = trunc i64 [[IV]] to i16
; CHECK-NEXT:    [[CMP_A:%.*]] = icmp ugt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 [[CMP_A]], label [[LOOP_COND:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.cond:
; CHECK-NEXT:    [[BLEND:%.*]] = phi i16 [ [[IV_TRUNC]], [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[SRC_PTR:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 [[BLEND]]
; CHECK-NEXT:    [[LV:%.*]] = load i16, i16* [[SRC_PTR]], align 1
; CHECK-NEXT:    [[CMP_B:%.*]] = icmp sgt i64 [[IV]], [[A]]
; CHECK-NEXT:    br i1 [[CMP_B]], label [[LOOP_NEXT:%.*]], label [[LOOP_LATCH]]
; CHECK:       loop.next:
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[RES:%.*]] = phi i16 [ 0, [[LOOP_HEADER]] ], [ [[LV]], [[LOOP_COND]] ], [ 1, [[LOOP_NEXT]] ]
; CHECK-NEXT:    [[DST_PTR:%.*]] = getelementptr inbounds [32 x i16], [32 x i16]* @dst, i16 0, i64 [[IV]]
; CHECK-NEXT:    store i16 [[RES]], i16* [[DST_PTR]], align 2
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[CMP439:%.*]] = icmp ult i64 [[IV]], 63
; CHECK-NEXT:    br i1 [[CMP439]], label [[LOOP_HEADER]], label [[EXIT]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %iv.trunc = trunc i64 %iv to i16
  %cmp.a = icmp ugt i64 %iv, %a
  br i1 %cmp.a, label %loop.cond, label %loop.latch

loop.cond:
  %blend = phi i16 [ %iv.trunc, %loop.header ]
  %src.ptr = getelementptr inbounds [32 x i16], [32 x i16]* @src, i16 0, i16 %blend
  %lv = load i16, i16* %src.ptr, align 1
  %cmp.b = icmp sgt i64 %iv, %a
  br i1 %cmp.b, label %loop.next, label %loop.latch

loop.next:
  br label %loop.latch

loop.latch:
  %res = phi i16 [ 0, %loop.header ], [ %lv, %loop.cond ], [ 1, %loop.next ]
  %dst.ptr = getelementptr inbounds [32 x i16], [32 x i16]* @dst, i16 0, i64 %iv
  store i16 %res, i16* %dst.ptr
  %iv.next = add nuw nsw i64 %iv, 1
  %cmp439 = icmp ult i64 %iv, 63
  br i1 %cmp439, label %loop.header, label %exit

exit:
  ret void
}

; Test case for PR44800.
define void @duplicated_incoming_blocks_blend(i32 %x, i32* %ptr) {
; CHECK-LABEL: @duplicated_incoming_blocks_blend(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i32> [ <i32 0, i32 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = extractelement <2 x i32> [[VEC_IND]], i32 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr i32, i32* [[PTR:%.*]], i32 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr i32, i32* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast i32* [[TMP2]] to <2 x i32>*
; CHECK-NEXT:    store <2 x i32> [[VEC_IND]], <2 x i32>* [[TMP3]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i32> [[VEC_IND]], <i32 2, i32 2>
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i32 [[INDEX_NEXT]], 1000
; CHECK-NEXT:    br i1 [[TMP4]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 1000, 1000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ 1000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[ADD_I:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[C_0:%.*]] = icmp ugt i32 [[IV]], [[X:%.*]]
; CHECK-NEXT:    br i1 [[C_0]], label [[LOOP_LATCH]], label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[P:%.*]] = phi i32 [ [[IV]], [[LOOP_HEADER]] ], [ [[IV]], [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[GEP_PTR:%.*]] = getelementptr i32, i32* [[PTR]], i32 [[P]]
; CHECK-NEXT:    store i32 [[P]], i32* [[GEP_PTR]], align 4
; CHECK-NEXT:    [[ADD_I]] = add nsw i32 [[P]], 1
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[ADD_I]], 1000
; CHECK-NEXT:    br i1 [[CMP]], label [[LOOP_HEADER]], label [[EXIT]], !llvm.loop [[LOOP11:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop.header

loop.header:
  %iv = phi i32 [ 0 , %entry ], [ %add.i, %loop.latch ]
  %c.0 = icmp ugt i32 %iv, %x
  br i1 %c.0, label %loop.latch, label %loop.latch

loop.latch:
  %p = phi i32 [ %iv, %loop.header ], [ %iv, %loop.header ]
  %gep.ptr = getelementptr i32, i32* %ptr, i32 %p
  store i32 %p, i32* %gep.ptr
  %add.i = add nsw i32 %p, 1
  %cmp = icmp slt i32 %add.i, 1000
  br i1 %cmp, label %loop.header, label %exit

exit:
  ret void
}
