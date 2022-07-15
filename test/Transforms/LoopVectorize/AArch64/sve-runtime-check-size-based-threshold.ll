; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=loop-vectorize -mattr=+sve -S %s | FileCheck %s

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
; CHECK-NEXT:    [[MIN_ITERS_CHECK:%.*]] = icmp ult i64 [[UMAX]], 28
; CHECK-NEXT:    br i1 [[MIN_ITERS_CHECK]], label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[TMP0:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP1:%.*]] = mul i64 [[TMP0]], 2
; CHECK-NEXT:    [[TMP2:%.*]] = mul i64 [[TMP1]], 16
; CHECK-NEXT:    [[TMP3:%.*]] = sub i64 [[DST_21]], [[DST_12]]
; CHECK-NEXT:    [[DIFF_CHECK:%.*]] = icmp ult i64 [[TMP3]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP5:%.*]] = mul i64 [[TMP4]], 2
; CHECK-NEXT:    [[TMP6:%.*]] = mul i64 [[TMP5]], 16
; CHECK-NEXT:    [[TMP7:%.*]] = sub i64 [[DST_12]], [[SRC_13]]
; CHECK-NEXT:    [[DIFF_CHECK4:%.*]] = icmp ult i64 [[TMP7]], [[TMP6]]
; CHECK-NEXT:    [[CONFLICT_RDX:%.*]] = or i1 [[DIFF_CHECK]], [[DIFF_CHECK4]]
; CHECK-NEXT:    [[TMP8:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP9:%.*]] = mul i64 [[TMP8]], 2
; CHECK-NEXT:    [[TMP10:%.*]] = mul i64 [[TMP9]], 16
; CHECK-NEXT:    [[TMP11:%.*]] = sub i64 [[DST_12]], [[SRC_25]]
; CHECK-NEXT:    [[DIFF_CHECK6:%.*]] = icmp ult i64 [[TMP11]], [[TMP10]]
; CHECK-NEXT:    [[CONFLICT_RDX7:%.*]] = or i1 [[CONFLICT_RDX]], [[DIFF_CHECK6]]
; CHECK-NEXT:    [[TMP12:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP13:%.*]] = mul i64 [[TMP12]], 2
; CHECK-NEXT:    [[TMP14:%.*]] = mul i64 [[TMP13]], 16
; CHECK-NEXT:    [[TMP15:%.*]] = sub i64 [[DST_21]], [[SRC_13]]
; CHECK-NEXT:    [[DIFF_CHECK8:%.*]] = icmp ult i64 [[TMP15]], [[TMP14]]
; CHECK-NEXT:    [[CONFLICT_RDX9:%.*]] = or i1 [[CONFLICT_RDX7]], [[DIFF_CHECK8]]
; CHECK-NEXT:    [[TMP16:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP17:%.*]] = mul i64 [[TMP16]], 2
; CHECK-NEXT:    [[TMP18:%.*]] = mul i64 [[TMP17]], 16
; CHECK-NEXT:    [[TMP19:%.*]] = sub i64 [[DST_21]], [[SRC_25]]
; CHECK-NEXT:    [[DIFF_CHECK10:%.*]] = icmp ult i64 [[TMP19]], [[TMP18]]
; CHECK-NEXT:    [[CONFLICT_RDX11:%.*]] = or i1 [[CONFLICT_RDX9]], [[DIFF_CHECK10]]
; CHECK-NEXT:    br i1 [[CONFLICT_RDX11]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[TMP20:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP21:%.*]] = mul i64 [[TMP20]], 4
; CHECK-NEXT:    [[N_MOD_VF:%.*]] = urem i64 [[UMAX]], [[TMP21]]
; CHECK-NEXT:    [[N_VEC:%.*]] = sub i64 [[UMAX]], [[N_MOD_VF]]
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP22:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP23:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP24:%.*]] = mul i64 [[TMP23]], 2
; CHECK-NEXT:    [[TMP25:%.*]] = add i64 [[TMP24]], 0
; CHECK-NEXT:    [[TMP26:%.*]] = mul i64 [[TMP25]], 1
; CHECK-NEXT:    [[TMP27:%.*]] = add i64 [[INDEX]], [[TMP26]]
; CHECK-NEXT:    [[TMP28:%.*]] = getelementptr i64, ptr [[SRC_1]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP29:%.*]] = getelementptr i64, ptr [[SRC_1]], i64 [[TMP27]]
; CHECK-NEXT:    [[TMP30:%.*]] = getelementptr i64, ptr [[SRC_2]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP31:%.*]] = getelementptr i64, ptr [[SRC_2]], i64 [[TMP27]]
; CHECK-NEXT:    [[TMP32:%.*]] = getelementptr i64, ptr [[TMP28]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <vscale x 2 x i64>, ptr [[TMP32]], align 4
; CHECK-NEXT:    [[TMP33:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP34:%.*]] = mul i32 [[TMP33]], 2
; CHECK-NEXT:    [[TMP35:%.*]] = getelementptr i64, ptr [[TMP28]], i32 [[TMP34]]
; CHECK-NEXT:    [[WIDE_LOAD12:%.*]] = load <vscale x 2 x i64>, ptr [[TMP35]], align 4
; CHECK-NEXT:    [[TMP36:%.*]] = getelementptr i64, ptr [[TMP30]], i32 0
; CHECK-NEXT:    [[WIDE_LOAD13:%.*]] = load <vscale x 2 x i64>, ptr [[TMP36]], align 4
; CHECK-NEXT:    [[TMP37:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP38:%.*]] = mul i32 [[TMP37]], 2
; CHECK-NEXT:    [[TMP39:%.*]] = getelementptr i64, ptr [[TMP30]], i32 [[TMP38]]
; CHECK-NEXT:    [[WIDE_LOAD14:%.*]] = load <vscale x 2 x i64>, ptr [[TMP39]], align 4
; CHECK-NEXT:    [[TMP40:%.*]] = add <vscale x 2 x i64> [[WIDE_LOAD]], [[WIDE_LOAD13]]
; CHECK-NEXT:    [[TMP41:%.*]] = add <vscale x 2 x i64> [[WIDE_LOAD12]], [[WIDE_LOAD14]]
; CHECK-NEXT:    [[TMP42:%.*]] = getelementptr i64, ptr [[DST_1]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP43:%.*]] = getelementptr i64, ptr [[DST_1]], i64 [[TMP27]]
; CHECK-NEXT:    [[TMP44:%.*]] = getelementptr i64, ptr [[DST_2]], i64 [[TMP22]]
; CHECK-NEXT:    [[TMP45:%.*]] = getelementptr i64, ptr [[DST_2]], i64 [[TMP27]]
; CHECK-NEXT:    [[TMP46:%.*]] = getelementptr i64, ptr [[TMP42]], i32 0
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP40]], ptr [[TMP46]], align 4
; CHECK-NEXT:    [[TMP47:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP48:%.*]] = mul i32 [[TMP47]], 2
; CHECK-NEXT:    [[TMP49:%.*]] = getelementptr i64, ptr [[TMP42]], i32 [[TMP48]]
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP41]], ptr [[TMP49]], align 4
; CHECK-NEXT:    [[TMP50:%.*]] = getelementptr i64, ptr [[TMP44]], i32 0
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP40]], ptr [[TMP50]], align 4
; CHECK-NEXT:    [[TMP51:%.*]] = call i32 @llvm.vscale.i32()
; CHECK-NEXT:    [[TMP52:%.*]] = mul i32 [[TMP51]], 2
; CHECK-NEXT:    [[TMP53:%.*]] = getelementptr i64, ptr [[TMP44]], i32 [[TMP52]]
; CHECK-NEXT:    store <vscale x 2 x i64> [[TMP41]], ptr [[TMP53]], align 4
; CHECK-NEXT:    [[TMP54:%.*]] = call i64 @llvm.vscale.i64()
; CHECK-NEXT:    [[TMP55:%.*]] = mul i64 [[TMP54]], 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], [[TMP55]]
; CHECK-NEXT:    [[TMP56:%.*]] = icmp eq i64 [[INDEX_NEXT]], [[N_VEC]]
; CHECK-NEXT:    br i1 [[TMP56]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
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
