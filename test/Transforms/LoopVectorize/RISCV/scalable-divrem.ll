; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-vectorize -scalable-vectorization=on -mtriple riscv64-linux-gnu -mattr=+v,+f -S 2>%t | FileCheck %s

; Tests specific to div/rem handling - both predicated and not

target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n64-S128"
target triple = "riscv64"

define void @vector_udiv(ptr noalias nocapture %a, i64 %v, i64 %n) {
; CHECK-LABEL: @vector_udiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 1024, [[TMP0]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 1024, [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 1024, [[N_MOD_VF]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <vscale x 1 x i64> poison, i64 [[V:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <vscale x 1 x i64> [[BROADCAST_SPLATINSERT]], <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, ptr [[TMP3]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 1 x i64>, ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = udiv <vscale x 1 x i64> [[WIDE_LOAD]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    store <vscale x 1 x i64> [[TMP5]], ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP6:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 [[IV]]
; CHECK-NEXT:    [[ELEM:%.*]] = load i64, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[DIVREM:%.*]] = udiv i64 [[ELEM]], [[V]]
; CHECK-NEXT:    store i64 [[DIVREM]], ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i64, ptr %a, i64 %iv
  %elem = load i64, ptr %arrayidx
  %divrem = udiv i64 %elem, %v
  store i64 %divrem, ptr %arrayidx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  ret void
}

define void @vector_sdiv(ptr noalias nocapture %a, i64 %v, i64 %n) {
; CHECK-LABEL: @vector_sdiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 1024, [[TMP0]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 1024, [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 1024, [[N_MOD_VF]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <vscale x 1 x i64> poison, i64 [[V:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <vscale x 1 x i64> [[BROADCAST_SPLATINSERT]], <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, ptr [[TMP3]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 1 x i64>, ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = sdiv <vscale x 1 x i64> [[WIDE_LOAD]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    store <vscale x 1 x i64> [[TMP5]], ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP6:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 [[IV]]
; CHECK-NEXT:    [[ELEM:%.*]] = load i64, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[DIVREM:%.*]] = sdiv i64 [[ELEM]], [[V]]
; CHECK-NEXT:    store i64 [[DIVREM]], ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i64, ptr %a, i64 %iv
  %elem = load i64, ptr %arrayidx
  %divrem = sdiv i64 %elem, %v
  store i64 %divrem, ptr %arrayidx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  ret void
}

define void @vector_urem(ptr noalias nocapture %a, i64 %v, i64 %n) {
; CHECK-LABEL: @vector_urem(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 1024, [[TMP0]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 1024, [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 1024, [[N_MOD_VF]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <vscale x 1 x i64> poison, i64 [[V:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <vscale x 1 x i64> [[BROADCAST_SPLATINSERT]], <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, ptr [[TMP3]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 1 x i64>, ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = urem <vscale x 1 x i64> [[WIDE_LOAD]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    store <vscale x 1 x i64> [[TMP5]], ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP6:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP6:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 [[IV]]
; CHECK-NEXT:    [[ELEM:%.*]] = load i64, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[DIVREM:%.*]] = urem i64 [[ELEM]], [[V]]
; CHECK-NEXT:    store i64 [[DIVREM]], ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP7:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i64, ptr %a, i64 %iv
  %elem = load i64, ptr %arrayidx
  %divrem = urem i64 %elem, %v
  store i64 %divrem, ptr %arrayidx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  ret void
}

define void @vector_srem(ptr noalias nocapture %a, i64 %v, i64 %n) {
; CHECK-LABEL: @vector_srem(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 1024, [[TMP0]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 1024, [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 1024, [[N_MOD_VF]]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <vscale x 1 x i64> poison, i64 [[V:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <vscale x 1 x i64> [[BROADCAST_SPLATINSERT]], <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, ptr [[TMP3]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 1 x i64>, ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = srem <vscale x 1 x i64> [[WIDE_LOAD]], [[BROADCAST_SPLAT]]
; CHECK-NEXT:    store <vscale x 1 x i64> [[TMP5]], ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP6:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP6]]
; CHECK-NEXT:    [[TMP7:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP7]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP8:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 [[IV]]
; CHECK-NEXT:    [[ELEM:%.*]] = load i64, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[DIVREM:%.*]] = srem i64 [[ELEM]], [[V]]
; CHECK-NEXT:    store i64 [[DIVREM]], ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %for.body ]
  %arrayidx = getelementptr inbounds i64, ptr %a, i64 %iv
  %elem = load i64, ptr %arrayidx
  %divrem = srem i64 %elem, %v
  store i64 %divrem, ptr %arrayidx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  ret void
}

define void @predicated_udiv(ptr noalias nocapture %a, i64 %v, i64 %n) {
; CHECK-LABEL: @predicated_udiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[ELEM:%.*]] = load i64, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[C:%.*]] = icmp ne i64 [[V:%.*]], 0
; CHECK-NEXT:    br i1 [[C]], label [[DO_OP:%.*]], label [[LATCH]]
; CHECK:       do_op:
; CHECK-NEXT:    [[DIVREM:%.*]] = udiv i64 [[ELEM]], [[V]]
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[ELEM]], [[FOR_BODY]] ], [ [[DIVREM]], [[DO_OP]] ]
; CHECK-NEXT:    store i64 [[PHI]], ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %latch ]
  %arrayidx = getelementptr inbounds i64, ptr %a, i64 %iv
  %elem = load i64, ptr %arrayidx
  %c = icmp ne i64 %v, 0
  br i1 %c, label %do_op, label %latch
do_op:
  %divrem = udiv i64 %elem, %v
  br label %latch
latch:
  %phi = phi i64 [%elem, %for.body], [%divrem, %do_op]
  store i64 %phi, ptr %arrayidx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  ret void
}

define void @predicated_sdiv(ptr noalias nocapture %a, i64 %v, i64 %n) {
; CHECK-LABEL: @predicated_sdiv(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 [[IV]]
; CHECK-NEXT:    [[ELEM:%.*]] = load i64, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[C:%.*]] = icmp ne i64 [[V:%.*]], 0
; CHECK-NEXT:    br i1 [[C]], label [[DO_OP:%.*]], label [[LATCH]]
; CHECK:       do_op:
; CHECK-NEXT:    [[DIVREM:%.*]] = sdiv i64 [[ELEM]], [[V]]
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[ELEM]], [[FOR_BODY]] ], [ [[DIVREM]], [[DO_OP]] ]
; CHECK-NEXT:    store i64 [[PHI]], ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END:%.*]], label [[FOR_BODY]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %latch ]
  %arrayidx = getelementptr inbounds i64, ptr %a, i64 %iv
  %elem = load i64, ptr %arrayidx
  %c = icmp ne i64 %v, 0
  br i1 %c, label %do_op, label %latch
do_op:
  %divrem = sdiv i64 %elem, %v
  br label %latch
latch:
  %phi = phi i64 [%elem, %for.body], [%divrem, %do_op]
  store i64 %phi, ptr %arrayidx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  ret void
}

define void @predicated_udiv_by_constant(ptr noalias nocapture %a, i64 %n) {
; CHECK-LABEL: @predicated_udiv_by_constant(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 1024, [[TMP0]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 1024, [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 1024, [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, ptr [[TMP3]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 1 x i64>, ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne <vscale x 1 x i64> [[WIDE_LOAD]], shufflevector (<vscale x 1 x i64> insertelement (<vscale x 1 x i64> poison, i64 42, i32 0), <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP6:%.*]] = udiv <vscale x 1 x i64> [[WIDE_LOAD]], shufflevector (<vscale x 1 x i64> insertelement (<vscale x 1 x i64> poison, i64 27, i32 0), <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP7:%.*]] = xor <vscale x 1 x i1> [[TMP5]], shufflevector (<vscale x 1 x i1> insertelement (<vscale x 1 x i1> poison, i1 true, i32 0), <vscale x 1 x i1> poison, <vscale x 1 x i32> zeroinitializer)
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <vscale x 1 x i1> [[TMP5]], <vscale x 1 x i64> [[TMP6]], <vscale x 1 x i64> [[WIDE_LOAD]]
; CHECK-NEXT:    store <vscale x 1 x i64> [[PREDPHI]], ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP8:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP8]]
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 [[IV]]
; CHECK-NEXT:    [[ELEM:%.*]] = load i64, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[C:%.*]] = icmp ne i64 [[ELEM]], 42
; CHECK-NEXT:    br i1 [[C]], label [[DO_OP:%.*]], label [[LATCH]]
; CHECK:       do_op:
; CHECK-NEXT:    [[DIVREM:%.*]] = udiv i64 [[ELEM]], 27
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[ELEM]], [[FOR_BODY]] ], [ [[DIVREM]], [[DO_OP]] ]
; CHECK-NEXT:    store i64 [[PHI]], ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP11:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %latch ]
  %arrayidx = getelementptr inbounds i64, ptr %a, i64 %iv
  %elem = load i64, ptr %arrayidx
  %c = icmp ne i64 %elem, 42
  br i1 %c, label %do_op, label %latch
do_op:
  %divrem = udiv i64 %elem, 27
  br label %latch
latch:
  %phi = phi i64 [%elem, %for.body], [%divrem, %do_op]
  store i64 %phi, ptr %arrayidx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  ret void
}

define void @predicated_sdiv_by_constant(ptr noalias nocapture %a, i64 %n) {
; CHECK-LABEL: @predicated_sdiv_by_constant(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 1024, [[TMP0]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP1:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 1024, [[TMP1]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 1024, [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds i64, ptr [[A:%.*]], i64 [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds i64, ptr [[TMP3]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 1 x i64>, ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP5:%.*]] = icmp ne <vscale x 1 x i64> [[WIDE_LOAD]], shufflevector (<vscale x 1 x i64> insertelement (<vscale x 1 x i64> poison, i64 42, i32 0), <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP6:%.*]] = sdiv <vscale x 1 x i64> [[WIDE_LOAD]], shufflevector (<vscale x 1 x i64> insertelement (<vscale x 1 x i64> poison, i64 27, i32 0), <vscale x 1 x i64> poison, <vscale x 1 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP7:%.*]] = xor <vscale x 1 x i1> [[TMP5]], shufflevector (<vscale x 1 x i1> insertelement (<vscale x 1 x i1> poison, i1 true, i32 0), <vscale x 1 x i1> poison, <vscale x 1 x i32> zeroinitializer)
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <vscale x 1 x i1> [[TMP5]], <vscale x 1 x i64> [[TMP6]], <vscale x 1 x i64> [[WIDE_LOAD]]
; CHECK-NEXT:    store <vscale x 1 x i64> [[PREDPHI]], ptr [[TMP4]], align 8
; CHECK-NEXT:    [[TMP8:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP8]]
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP12:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 [[IV]]
; CHECK-NEXT:    [[ELEM:%.*]] = load i64, ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[C:%.*]] = icmp ne i64 [[ELEM]], 42
; CHECK-NEXT:    br i1 [[C]], label [[DO_OP:%.*]], label [[LATCH]]
; CHECK:       do_op:
; CHECK-NEXT:    [[DIVREM:%.*]] = sdiv i64 [[ELEM]], 27
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[PHI:%.*]] = phi i64 [ [[ELEM]], [[FOR_BODY]] ], [ [[DIVREM]], [[DO_OP]] ]
; CHECK-NEXT:    store i64 [[PHI]], ptr [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP13:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %latch ]
  %arrayidx = getelementptr inbounds i64, ptr %a, i64 %iv
  %elem = load i64, ptr %arrayidx
  %c = icmp ne i64 %elem, 42
  br i1 %c, label %do_op, label %latch
do_op:
  %divrem = sdiv i64 %elem, 27
  br label %latch
latch:
  %phi = phi i64 [%elem, %for.body], [%divrem, %do_op]
  store i64 %phi, ptr %arrayidx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  ret void
}

; FIXME: The current code here is wrong.  sdiv/srem INT_MIN, -1 is UB.
; We can not speculate such a case.
define void @predicated_sdiv_by_minus_one(ptr noalias nocapture %a, i64 %n) {
; CHECK-LABEL: @predicated_sdiv_by_minus_one(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 16
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 1024, [[TMP1]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP3:%.*]] = mul i64 [[TMP2]], 16
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 1024, [[TMP3]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 1024, [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP4:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP5:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 8
; CHECK-NEXT:    [[TMP7:%.*]] = add i64 [[TMP6]], 0
; CHECK-NEXT:    [[TMP8:%.*]] = mul i64 [[TMP7]], 1
; CHECK-NEXT:    [[TMP9:%.*]] = add i64 [[INDEX]], [[TMP8]]
; CHECK-NEXT:    [[TMP10:%.*]] = getelementptr inbounds i8, ptr [[A:%.*]], i64 [[TMP4]]
; CHECK-NEXT:    [[TMP11:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 [[TMP9]]
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds i8, ptr [[TMP10]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 8 x i8>, ptr [[TMP12]], align 1
; CHECK-NEXT:    [[TMP13:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP14:%.*]] = mul i32 [[TMP13]], 8
; CHECK-NEXT:    [[TMP15:%.*]] = getelementptr inbounds i8, ptr [[TMP10]], i32 [[TMP14]]
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <vscale x 8 x i8>, ptr [[TMP15]], align 1
; CHECK-NEXT:    [[TMP16:%.*]] = icmp ne <vscale x 8 x i8> [[WIDE_LOAD]], shufflevector (<vscale x 8 x i8> insertelement (<vscale x 8 x i8> poison, i8 -128, i32 0), <vscale x 8 x i8> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP17:%.*]] = icmp ne <vscale x 8 x i8> [[WIDE_LOAD1]], shufflevector (<vscale x 8 x i8> insertelement (<vscale x 8 x i8> poison, i8 -128, i32 0), <vscale x 8 x i8> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP18:%.*]] = sdiv <vscale x 8 x i8> [[WIDE_LOAD]], shufflevector (<vscale x 8 x i8> insertelement (<vscale x 8 x i8> poison, i8 -1, i32 0), <vscale x 8 x i8> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP19:%.*]] = sdiv <vscale x 8 x i8> [[WIDE_LOAD1]], shufflevector (<vscale x 8 x i8> insertelement (<vscale x 8 x i8> poison, i8 -1, i32 0), <vscale x 8 x i8> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP20:%.*]] = xor <vscale x 8 x i1> [[TMP16]], shufflevector (<vscale x 8 x i1> insertelement (<vscale x 8 x i1> poison, i1 true, i32 0), <vscale x 8 x i1> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[TMP21:%.*]] = xor <vscale x 8 x i1> [[TMP17]], shufflevector (<vscale x 8 x i1> insertelement (<vscale x 8 x i1> poison, i1 true, i32 0), <vscale x 8 x i1> poison, <vscale x 8 x i32> zeroinitializer)
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <vscale x 8 x i1> [[TMP16]], <vscale x 8 x i8> [[TMP18]], <vscale x 8 x i8> [[WIDE_LOAD]]
; CHECK-NEXT:    [[PREDPHI2:%.*]] = select <vscale x 8 x i1> [[TMP17]], <vscale x 8 x i8> [[TMP19]], <vscale x 8 x i8> [[WIDE_LOAD1]]
; CHECK-NEXT:    store <vscale x 8 x i8> [[PREDPHI]], ptr [[TMP12]], align 1
; CHECK-NEXT:    [[TMP22:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP23:%.*]] = mul i32 [[TMP22]], 8
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr inbounds i8, ptr [[TMP10]], i32 [[TMP23]]
; CHECK-NEXT:    store <vscale x 8 x i8> [[PREDPHI2]], ptr [[TMP24]], align 1
; CHECK-NEXT:    [[TMP25:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP26:%.*]] = mul i64 [[TMP25]], 16
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP26]]
; CHECK-NEXT:    [[TMP27:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP27]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP14:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 1024, [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LATCH:%.*]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i8, ptr [[A]], i64 [[IV]]
; CHECK-NEXT:    [[ELEM:%.*]] = load i8, ptr [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[ELEM]], -128
; CHECK-NEXT:    br i1 [[C]], label [[DO_OP:%.*]], label [[LATCH]]
; CHECK:       do_op:
; CHECK-NEXT:    [[DIVREM:%.*]] = sdiv i8 [[ELEM]], -1
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[PHI:%.*]] = phi i8 [ [[ELEM]], [[FOR_BODY]] ], [ [[DIVREM]], [[DO_OP]] ]
; CHECK-NEXT:    store i8 [[PHI]], ptr [[ARRAYIDX]], align 1
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 1024
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop [[LOOP15:![0-9]+]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %latch ]
  %arrayidx = getelementptr inbounds i8, ptr %a, i64 %iv
  %elem = load i8, ptr %arrayidx
  %c = icmp ne i8 %elem, 128
  br i1 %c, label %do_op, label %latch
do_op:
  %divrem = sdiv i8 %elem, -1 ;; UB if %elem = INT_MIN
  br label %latch
latch:
  %phi = phi i8 [%elem, %for.body], [%divrem, %do_op]
  store i8 %phi, ptr %arrayidx
  %iv.next = add nuw nsw i64 %iv, 1
  %exitcond.not = icmp eq i64 %iv.next, 1024
  br i1 %exitcond.not, label %for.end, label %for.body

for.end:
  ret void
}
