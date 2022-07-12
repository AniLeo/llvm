; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-vectorize -mattr=+sve -prefer-predicate-over-epilogue=scalar-epilogue -S %s | FileCheck %s

target triple = "aarch64-unknown-linux-gnu"

; Test case where the minimum profitable trip count due to runtime checks
; exceeds VF.getKnownMinValue() * UF.
; FIXME: The code currently incorrectly is missing a umax(VF * UF, 28).
define void @min_trip_count_due_to_runtime_checks_1(ptr %dst.1, ptr %dst.2, ptr %src.1, ptr %src.2, i64 %n) {
; CHECK-LABEL: @min_trip_count_due_to_runtime_checks_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[SRC_25:%.*]] = ptrtoint ptr [[SRC_2:%.*]] to i64
; CHECK-NEXT:    [[SRC_13:%.*]] = ptrtoint ptr [[SRC_1:%.*]] to i64
; CHECK-NEXT:    [[DST_12:%.*]] = ptrtoint ptr [[DST_1:%.*]] to i64
; CHECK-NEXT:    [[DST_21:%.*]] = ptrtoint ptr [[DST_2:%.*]] to i64
; CHECK-NEXT:    [[UMAX:%.*]] = call i64 @llvm.umax.i64(i64 [[N:%.*]], i64 1)
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 4
; CHECK-NEXT:    [[TMP2:%.*]] = call i64 @llvm.umax.i64(i64 20, i64 [[TMP1]])
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[UMAX]], [[TMP2]]
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[TMP3:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP4:%.*]] = mul i64 [[TMP3]], 2
; CHECK-NEXT:    [[TMP5:%.*]] = mul i64 [[TMP4]], 16
; CHECK-NEXT:    [[TMP6:%.*]] = sub i64 [[DST_21]], [[DST_12]]
; CHECK-NEXT:    [[DIFF_CHECK:%.*]] = icmp ult i64 [[TMP6]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = mul i64 [[TMP4]], 16
; CHECK-NEXT:    [[TMP8:%.*]] = sub i64 [[DST_12]], [[SRC_13]]
; CHECK-NEXT:    [[DIFF_CHECK4:%.*]] = icmp ult i64 [[TMP8]], [[TMP7]]
; CHECK-NEXT:    [[CONFLICT_RDX:%.*]] = or i1 [[DIFF_CHECK]], [[DIFF_CHECK4]]
; CHECK-NEXT:    [[TMP9:%.*]] = mul i64 [[TMP4]], 16
; CHECK-NEXT:    [[TMP10:%.*]] = sub i64 [[DST_12]], [[SRC_25]]
; CHECK-NEXT:    [[DIFF_CHECK6:%.*]] = icmp ult i64 [[TMP10]], [[TMP9]]
; CHECK-NEXT:    [[CONFLICT_RDX7:%.*]] = or i1 [[CONFLICT_RDX]], [[DIFF_CHECK6]]
; CHECK-NEXT:    [[TMP11:%.*]] = mul i64 [[TMP4]], 16
; CHECK-NEXT:    [[TMP12:%.*]] = sub i64 [[DST_21]], [[SRC_13]]
; CHECK-NEXT:    [[DIFF_CHECK8:%.*]] = icmp ult i64 [[TMP12]], [[TMP11]]
; CHECK-NEXT:    [[CONFLICT_RDX9:%.*]] = or i1 [[CONFLICT_RDX7]], [[DIFF_CHECK8]]
; CHECK-NEXT:    [[TMP13:%.*]] = mul i64 [[TMP4]], 16
; CHECK-NEXT:    [[TMP14:%.*]] = sub i64 [[DST_21]], [[SRC_25]]
; CHECK-NEXT:    [[DIFF_CHECK10:%.*]] = icmp ult i64 [[TMP14]], [[TMP13]]
; CHECK-NEXT:    [[CONFLICT_RDX11:%.*]] = or i1 [[CONFLICT_RDX9]], [[DIFF_CHECK10]]
; CHECK-NEXT:    br i1 [[CONFLICT_RDX11]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP15:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP16:%.*]] = mul i64 [[TMP15]], 4
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[UMAX]], [[TMP16]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[UMAX]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP17:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP18:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP19:%.*]] = mul i64 [[TMP18]], 2
; CHECK-NEXT:    [[TMP20:%.*]] = add i64 [[TMP19]], 0
; CHECK-NEXT:    [[TMP21:%.*]] = mul i64 [[TMP20]], 1
; CHECK-NEXT:    [[TMP22:%.*]] = add i64 [[INDEX]], [[TMP21]]
; CHECK-NEXT:    [[TMP23:%.*]] = getelementptr i64, ptr [[SRC_1]], i64 [[TMP17]]
; CHECK-NEXT:    [[TMP24:%.*]] = getelementptr i64, ptr [[SRC_1]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP25:%.*]] = getelementptr i64, ptr [[SRC_2]], i64 [[TMP17]]
; CHECK-NEXT:    [[TMP26:%.*]] = getelementptr i64, ptr [[SRC_2]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP27:%.*]] = getelementptr i64, ptr [[TMP23]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 2 x i64>, ptr [[TMP27]], align 4
; CHECK-NEXT:    [[TMP28:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP29:%.*]] = mul i32 [[TMP28]], 2
; CHECK-NEXT:    [[TMP30:%.*]] = getelementptr i64, ptr [[TMP23]], i32 [[TMP29]]
; CHECK-NEXT:    [[WIDE_LOAD12:%.*]] = load <vscale x 2 x i64>, ptr [[TMP30]], align 4
; CHECK-NEXT:    [[TMP31:%.*]] = getelementptr i64, ptr [[TMP25]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD13:%.*]] = load <vscale x 2 x i64>, ptr [[TMP31]], align 4
; CHECK-NEXT:    [[TMP32:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP33:%.*]] = mul i32 [[TMP32]], 2
; CHECK-NEXT:    [[TMP34:%.*]] = getelementptr i64, ptr [[TMP25]], i32 [[TMP33]]
; CHECK-NEXT:    [[WIDE_LOAD14:%.*]] = load <vscale x 2 x i64>, ptr [[TMP34]], align 4
; CHECK-NEXT:    [[TMP35:%.*]] = add <vscale x 2 x i64> [[WIDE_LOAD]], [[WIDE_LOAD13]]
; CHECK-NEXT:    [[TMP36:%.*]] = add <vscale x 2 x i64> [[WIDE_LOAD12]], [[WIDE_LOAD14]]
; CHECK-NEXT:    [[TMP37:%.*]] = getelementptr i64, ptr [[DST_1]], i64 [[TMP17]]
; CHECK-NEXT:    [[TMP38:%.*]] = getelementptr i64, ptr [[DST_1]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP39:%.*]] = getelementptr i64, ptr [[DST_2]], i64 [[TMP17]]
; CHECK-NEXT:    [[TMP40:%.*]] = getelementptr i64, ptr [[DST_2]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP41:%.*]] = getelementptr i64, ptr [[TMP37]], i32 0
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP35]], ptr [[TMP41]], align 4
; CHECK-NEXT:    [[TMP42:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP43:%.*]] = mul i32 [[TMP42]], 2
; CHECK-NEXT:    [[TMP44:%.*]] = getelementptr i64, ptr [[TMP37]], i32 [[TMP43]]
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP36]], ptr [[TMP44]], align 4
; CHECK-NEXT:    [[TMP45:%.*]] = getelementptr i64, ptr [[TMP39]], i32 0
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP35]], ptr [[TMP45]], align 4
; CHECK-NEXT:    [[TMP46:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP47:%.*]] = mul i32 [[TMP46]], 2
; CHECK-NEXT:    [[TMP48:%.*]] = getelementptr i64, ptr [[TMP39]], i32 [[TMP47]]
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP36]], ptr [[TMP48]], align 4
; CHECK-NEXT:    [[TMP49:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP50:%.*]] = mul i64 [[TMP49]], 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP50]]
; CHECK-NEXT:    [[TMP51:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP51]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 [[UMAX]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ [[N_VEC]], [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP]] ]
; CHECK-NEXT:    [[GEP_SRC_1:%.*]] = getelementptr i64, ptr [[SRC_1]], i64 [[IV]]
; CHECK-NEXT:    [[GEP_SRC_2:%.*]] = getelementptr i64, ptr [[SRC_2]], i64 [[IV]]
; CHECK-NEXT:    [[L_1:%.*]] = load i64, ptr [[GEP_SRC_1]], align 4
; CHECK-NEXT:    [[L_2:%.*]] = load i64, ptr [[GEP_SRC_2]], align 4
; CHECK-NEXT:    [[ADD:%.*]] = add i64 [[L_1]], [[L_2]]
; CHECK-NEXT:    [[GEP_DST_1:%.*]] = getelementptr i64, ptr [[DST_1]], i64 [[IV]]
; CHECK-NEXT:    [[GEP_DST_2:%.*]] = getelementptr i64, ptr [[DST_2]], i64 [[IV]]
; CHECK-NEXT:    store i64 [[ADD]], ptr [[GEP_DST_1]], align 4
; CHECK-NEXT:    store i64 [[ADD]], ptr [[GEP_DST_2]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add nsw i64 [[IV]], 1
; CHECK-NEXT:    [[CMP10:%.*]] = icmp ult i64 [[IV_NEXT]], [[N]]
; CHECK-NEXT:    br i1 [[CMP10]], label [[LOOP]], label [[EXIT]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop ]
  %gep.src.1 = getelementptr i64, ptr %src.1, i64 %iv
  %gep.src.2 = getelementptr i64, ptr %src.2, i64 %iv
  %l.1 = load i64, ptr %gep.src.1
  %l.2 = load i64, ptr %gep.src.2
  %add = add i64 %l.1, %l.2
  %gep.dst.1 = getelementptr i64, ptr %dst.1, i64 %iv
  %gep.dst.2 = getelementptr i64, ptr %dst.2, i64 %iv
  store i64 %add, ptr %gep.dst.1
  store i64 %add, ptr %gep.dst.2
  %iv.next = add nsw i64 %iv, 1
  %cmp10 = icmp ult i64 %iv.next, %n
  br i1 %cmp10, label %loop, label %exit

exit:
  ret void
}
