; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -dce -instcombine -force-vector-interleave=1 -force-vector-width=8 -S < %s | FileCheck %s

define i8 @reduction_and_trunc(i8* noalias nocapture %ptr) {
; CHECK-LABEL: @reduction_and_trunc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <8 x i8> [ <i8 0, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1, i8 -1>, [[VECTOR_PH]] ], [ [[TMP3:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[INDEX]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i8, i8* [[PTR:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i8* [[TMP1]] to <8 x i8>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x i8>, <8 x i8>* [[TMP2]], align 1
; CHECK-NEXT:    [[TMP3]] = and <8 x i8> [[VEC_PHI]], [[WIDE_LOAD]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 8
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i32 [[INDEX_NEXT]], 256
; CHECK-NEXT:    br i1 [[TMP4]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP5:%.*]] = call i8 @llvm.vector.reduce.and.v8i8(<8 x i8> [[TMP3]])
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 poison, label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    [[AND_LCSSA_OFF0:%.*]] = phi i8 [ poison, [[FOR_BODY]] ], [ [[TMP5]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i8 [[AND_LCSSA_OFF0]]
;
entry:
  br label %for.body

for.body:
  %iv = phi i32 [ %iv.next, %for.body ], [ 0, %entry ]
  %sum.02p = phi i32 [ %and, %for.body ], [ 0, %entry ]
  %sum.02 = and i32 %sum.02p, 255
  %gep = getelementptr inbounds i8, i8* %ptr, i32 %iv
  %load = load i8, i8* %gep
  %ext = zext i8 %load to i32
  %and = and i32 %sum.02, %ext
  %iv.next = add i32 %iv, 1
  %exitcond = icmp eq i32 %iv.next, 256
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  %ret = trunc i32 %and to i8
  ret i8 %ret
}

define i16 @reduction_or_trunc(i16* noalias nocapture %ptr) {
; CHECK-LABEL: @reduction_or_trunc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <8 x i16> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP3:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[INDEX]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i16, i16* [[PTR:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i16* [[TMP1]] to <8 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x i16>, <8 x i16>* [[TMP2]], align 2
; CHECK-NEXT:    [[TMP3]] = or <8 x i16> [[VEC_PHI]], [[WIDE_LOAD]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 8
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i32 [[INDEX_NEXT]], 256
; CHECK-NEXT:    br i1 [[TMP4]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP5:%.*]] = call i16 @llvm.vector.reduce.or.v8i16(<8 x i16> [[TMP3]])
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 poison, label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    [[XOR_LCSSA_OFF0:%.*]] = phi i16 [ poison, [[FOR_BODY]] ], [ [[TMP5]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i16 [[XOR_LCSSA_OFF0]]
;
entry:
  br label %for.body

for.body:
  %iv = phi i32 [ %iv.next, %for.body ], [ 0, %entry ]
  %sum.02p = phi i32 [ %xor, %for.body ], [ 0, %entry ]
  %sum.02 = and i32 %sum.02p, 65535
  %gep = getelementptr inbounds i16, i16* %ptr, i32 %iv
  %load = load i16, i16* %gep
  %ext = zext i16 %load to i32
  %xor = or i32 %sum.02, %ext
  %iv.next = add i32 %iv, 1
  %exitcond = icmp eq i32 %iv.next, 256
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  %ret = trunc i32 %xor to i16
  ret i16 %ret
}

define i16 @reduction_xor_trunc(i16* noalias nocapture %ptr) {
; CHECK-LABEL: @reduction_xor_trunc(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <8 x i16> [ zeroinitializer, [[VECTOR_PH]] ], [ [[TMP3:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = sext i32 [[INDEX]] to i64
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds i16, i16* [[PTR:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = bitcast i16* [[TMP1]] to <8 x i16>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x i16>, <8 x i16>* [[TMP2]], align 2
; CHECK-NEXT:    [[TMP3]] = xor <8 x i16> [[VEC_PHI]], [[WIDE_LOAD]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 8
; CHECK-NEXT:    [[TMP4:%.*]] = icmp eq i32 [[INDEX_NEXT]], 256
; CHECK-NEXT:    br i1 [[TMP4]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP5:%.*]] = call i16 @llvm.vector.reduce.xor.v8i16(<8 x i16> [[TMP3]])
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    br i1 poison, label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    [[XOR_LCSSA_OFF0:%.*]] = phi i16 [ poison, [[FOR_BODY]] ], [ [[TMP5]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    ret i16 [[XOR_LCSSA_OFF0]]
;
entry:
  br label %for.body

for.body:
  %iv = phi i32 [ %iv.next, %for.body ], [ 0, %entry ]
  %sum.02p = phi i32 [ %xor, %for.body ], [ 0, %entry ]
  %sum.02 = and i32 %sum.02p, 65535
  %gep = getelementptr inbounds i16, i16* %ptr, i32 %iv
  %load = load i16, i16* %gep
  %ext = zext i16 %load to i32
  %xor = xor i32 %sum.02, %ext
  %iv.next = add i32 %iv, 1
  %exitcond = icmp eq i32 %iv.next, 256
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  %ret = trunc i32 %xor to i16
  ret i16 %ret
}

define i8 @reduction_smin_trunc(i8* noalias nocapture %ptr) {
; CHECK-LABEL: @reduction_smin_trunc(
; CHECK-NOT: vector.body
; CHECK-NOT: <8 x
; CHECK: ret
entry:
  br label %for.body

for.body:
  %iv = phi i32 [ %iv.next, %for.body ], [ 0, %entry ]
  %sum.02p = phi i32 [ %min, %for.body ], [ 256, %entry ]
  %sum.02 = and i32 %sum.02p, 255
  %gep = getelementptr inbounds i8, i8* %ptr, i32 %iv
  %load = load i8, i8* %gep
  %ext = sext i8 %load to i32
  %icmp = icmp slt i32 %sum.02, %ext
  %min = select i1 %icmp, i32 %sum.02, i32 %ext
  %iv.next = add i32 %iv, 1
  %exitcond = icmp eq i32 %iv.next, 256
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  %ret = trunc i32 %min to i8
  ret i8 %ret
}

define i8 @reduction_umin_trunc(i8* noalias nocapture %ptr) {
; CHECK-LABEL: @reduction_umin_trunc(
; CHECK-NOT: vector.body
; CHECK-NOT: <8 x
; CHECK: ret
entry:
  br label %for.body

for.body:
  %iv = phi i32 [ %iv.next, %for.body ], [ 0, %entry ]
  %sum.02p = phi i32 [ %min, %for.body ], [ 0, %entry ]
  %sum.02 = and i32 %sum.02p, 255
  %gep = getelementptr inbounds i8, i8* %ptr, i32 %iv
  %load = load i8, i8* %gep
  %ext = zext i8 %load to i32
  %icmp = icmp ult i32 %sum.02, %ext
  %min = select i1 %icmp, i32 %sum.02, i32 %ext
  %iv.next = add i32 %iv, 1
  %exitcond = icmp eq i32 %iv.next, 256
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  %ret = trunc i32 %min to i8
  ret i8 %ret
}

define i16 @reduction_smax_trunc(i16* noalias nocapture %ptr) {
; CHECK-LABEL: @reduction_smax_trunc(
; CHECK-NOT: vector.body
; CHECK-NOT: <8 x
; CHECK: ret
entry:
  br label %for.body

for.body:
  %iv = phi i32 [ %iv.next, %for.body ], [ 0, %entry ]
  %sum.02p = phi i32 [ %min, %for.body ], [ 0, %entry ]
  %sum.02 = and i32 %sum.02p, 65535
  %gep = getelementptr inbounds i16, i16* %ptr, i32 %iv
  %load = load i16, i16* %gep
  %ext = sext i16 %load to i32
  %icmp = icmp sgt i32 %sum.02, %ext
  %min = select i1 %icmp, i32 %sum.02, i32 %ext
  %iv.next = add i32 %iv, 1
  %exitcond = icmp eq i32 %iv.next, 256
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  %ret = trunc i32 %min to i16
  ret i16 %ret
}

define i16 @reduction_umax_trunc(i16* noalias nocapture %ptr) {
; CHECK-LABEL: @reduction_umax_trunc(
; CHECK-NOT: vector.body
; CHECK-NOT: <8 x
; CHECK: ret
entry:
  br label %for.body

for.body:
  %iv = phi i32 [ %iv.next, %for.body ], [ 0, %entry ]
  %sum.02p = phi i32 [ %min, %for.body ], [ 0, %entry ]
  %sum.02 = and i32 %sum.02p, 65535
  %gep = getelementptr inbounds i16, i16* %ptr, i32 %iv
  %load = load i16, i16* %gep
  %ext = zext i16 %load to i32
  %icmp = icmp ugt i32 %sum.02, %ext
  %min = select i1 %icmp, i32 %sum.02, i32 %ext
  %iv.next = add i32 %iv, 1
  %exitcond = icmp eq i32 %iv.next, 256
  br i1 %exitcond, label %for.end, label %for.body

for.end:
  %ret = trunc i32 %min to i16
  ret i16 %ret
}
