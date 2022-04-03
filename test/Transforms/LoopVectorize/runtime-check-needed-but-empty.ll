; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -force-vector-width=4 -S %s | FileCheck %s

define void @test(float* %A, i32 %x) {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_SCEVCHECK:%.*]]
; CHECK:       vector.scevcheck:
; CHECK-NEXT:    [[IDENT_CHECK:%.*]] = icmp ne i32 [[X:%.*]], 1
; CHECK-NEXT:    br i1 [[IDENT_CHECK]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = trunc i64 [[INDEX]] to i32
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[TMP0]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP3:%.*]] = add nuw nsw i64 [[TMP2]], 1
; CHECK-NEXT:    [[TMP4:%.*]] = trunc i64 [[TMP3]] to i32
; CHECK-NEXT:    [[TMP5:%.*]] = mul i32 [[TMP4]], [[X]]
; CHECK-NEXT:    [[TMP6:%.*]] = zext i32 [[TMP5]] to i64
; CHECK-NEXT:    [[TMP7:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[TMP6]]
; CHECK-NEXT:    [[TMP8:%.*]] = getelementptr inbounds float, float* [[TMP7]], i32 0
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast float* [[TMP8]] to <4 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <4 x float>, <4 x float>* [[TMP9]], align 4
; CHECK-NEXT:    [[TMP10:%.*]] = mul i32 [[TMP1]], [[X]]
; CHECK-NEXT:    [[TMP11:%.*]] = zext i32 [[TMP10]] to i64
; CHECK-NEXT:    [[TMP12:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds float, float* [[TMP12]], i32 0
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast float* [[TMP13]] to <4 x float>*
; CHECK-NEXT:    store <4 x float> [[WIDE_LOAD]], <4 x float>* [[TMP14]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 4
; CHECK-NEXT:    [[TMP15:%.*]] = icmp eq i64 [[INDEX_NEXT]], undef
; CHECK-NEXT:    br i1 [[TMP15]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 undef, undef
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ undef, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_SCEVCHECK]] ]
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[IV_NEXT:%.*]], [[LOOP]] ], [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[T_IV_NEXT:%.*]] = trunc i64 [[IV_NEXT]] to i32
; CHECK-NEXT:    [[MUL_IV_NEXT:%.*]] = mul i32 [[T_IV_NEXT]], [[X]]
; CHECK-NEXT:    [[IDX_1:%.*]] = zext i32 [[MUL_IV_NEXT]] to i64
; CHECK-NEXT:    [[ARRAYIDX1215:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[IDX_1]]
; CHECK-NEXT:    [[LV:%.*]] = load float, float* [[ARRAYIDX1215]], align 4
; CHECK-NEXT:    [[T_IV:%.*]] = trunc i64 [[IV]] to i32
; CHECK-NEXT:    [[MUL_IV:%.*]] = mul i32 [[T_IV]], [[X]]
; CHECK-NEXT:    [[IDX_2:%.*]] = zext i32 [[MUL_IV]] to i64
; CHECK-NEXT:    [[ARRAYIDX1209:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[IDX_2]]
; CHECK-NEXT:    store float [[LV]], float* [[ARRAYIDX1209]], align 4
; CHECK-NEXT:    [[EC:%.*]] = icmp eq i64 [[IV_NEXT]], undef
; CHECK-NEXT:    br i1 [[EC]], label [[EXIT]], label [[LOOP]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret void
;
entry:
  br label %loop

loop:                                     ; preds = %loop, %entry
  %iv = phi i64 [ %iv.next, %loop ], [ 0, %entry ]
  %iv.next = add nuw nsw i64 %iv, 1
  %t.iv.next = trunc i64 %iv.next to i32
  %mul.iv.next = mul i32 %t.iv.next, %x
  %idx.1 = zext i32 %mul.iv.next to i64
  %arrayidx1215 = getelementptr inbounds float, float* %A, i64 %idx.1
  %lv = load float, float* %arrayidx1215, align 4

  %t.iv = trunc i64 %iv to i32
  %mul.iv = mul i32 %t.iv, %x
  %idx.2 = zext i32 %mul.iv to i64
  %arrayidx1209 = getelementptr inbounds float, float* %A, i64 %idx.2
  store float %lv, float* %arrayidx1209, align 4
  %ec = icmp eq i64 %iv.next, undef
  br i1 %ec, label %exit, label %loop

exit:                             ; preds = %loop
  ret void
}
