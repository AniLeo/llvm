; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -force-vector-width=2 -S %s | FileCheck %s

%s1 = type { [32000 x double], [32000 x double], [32000 x double] }

define i32 @load_with_pointer_phi_no_runtime_checks(%s1* %data) {
; CHECK-LABEL: @load_with_pointer_phi_no_runtime_checks(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i64> [ <i64 0, i64 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult <2 x i64> [[VEC_IND]], <i64 15999, i64 15999>
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [[S1:%.*]], %s1* [[DATA:%.*]], i64 0, i32 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 2, <2 x i64> [[VEC_IND]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 1, <2 x i64> [[VEC_IND]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor <2 x i1> [[TMP1]], <i1 true, i1 true>
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP1]], <2 x double*> [[TMP4]], <2 x double*> [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = extractelement <2 x double*> [[PREDPHI]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = load double, double* [[TMP6]], align 8
; CHECK-NEXT:    [[TMP8:%.*]] = extractelement <2 x double*> [[PREDPHI]], i32 1
; CHECK-NEXT:    [[TMP9:%.*]] = load double, double* [[TMP8]], align 8
; CHECK-NEXT:    [[TMP10:%.*]] = insertelement <2 x double> poison, double [[TMP7]], i32 0
; CHECK-NEXT:    [[TMP11:%.*]] = insertelement <2 x double> [[TMP10]], double [[TMP9]], i32 1
; CHECK-NEXT:    [[TMP12:%.*]] = fmul <2 x double> <double 3.000000e+00, double 3.000000e+00>, [[TMP11]]
; CHECK-NEXT:    [[TMP13:%.*]] = getelementptr inbounds double, double* [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP14:%.*]] = bitcast double* [[TMP13]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP12]], <2 x double>* [[TMP14]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i64> [[VEC_IND]], <i64 2, i64 2>
; CHECK-NEXT:    [[TMP15:%.*]] = icmp eq i64 [[INDEX_NEXT]], 32000
; CHECK-NEXT:    br i1 [[TMP15]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 32000, 32000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 32000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[CMP5:%.*]] = icmp ult i64 [[IV]], 15999
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 0, i64 [[IV]]
; CHECK-NEXT:    br i1 [[CMP5]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 1, i64 [[IV]]
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       if.else:
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 2, i64 [[IV]]
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[GEP_2_SINK:%.*]] = phi double* [ [[GEP_2]], [[IF_ELSE]] ], [ [[GEP_1]], [[IF_THEN]] ]
; CHECK-NEXT:    [[V8:%.*]] = load double, double* [[GEP_2_SINK]], align 8
; CHECK-NEXT:    [[MUL16:%.*]] = fmul double 3.000000e+00, [[V8]]
; CHECK-NEXT:    store double [[MUL16]], double* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 32000
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 10
;
entry:
  br label %loop.header

loop.header:                                        ; preds = %loop.latch, %entry
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %iv.next = add nuw nsw i64 %iv, 1
  %cmp5 = icmp ult i64 %iv, 15999
  %arrayidx = getelementptr inbounds %s1, %s1 * %data, i64 0, i32 0, i64 %iv
  br i1 %cmp5, label %if.then, label %if.else

if.then:                                          ; preds = %loop.header
  %gep.1 = getelementptr inbounds %s1, %s1* %data, i64 0, i32 1, i64 %iv
  br label %loop.latch

if.else:                                          ; preds = %loop.header
  %gep.2 = getelementptr inbounds %s1, %s1* %data, i64 0, i32 2, i64 %iv
  br label %loop.latch

loop.latch:                                          ; preds = %if.else, %if.then
  %gep.2.sink = phi double* [ %gep.2, %if.else ], [ %gep.1, %if.then ]
  %v8 = load double, double* %gep.2.sink, align 8
  %mul16 = fmul double 3.0, %v8
  store double %mul16, double* %arrayidx, align 8
  %exitcond.not = icmp eq i64 %iv.next, 32000
  br i1 %exitcond.not, label %exit, label %loop.header

exit:                                             ; preds = %loop.latch
  ret i32 10
}

define i32 @store_with_pointer_phi_no_runtime_checks(%s1* %data) {
; CHECK-LABEL: @store_with_pointer_phi_no_runtime_checks(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i64> [ <i64 0, i64 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult <2 x i64> [[VEC_IND]], <i64 15999, i64 15999>
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [[S1:%.*]], %s1* [[DATA:%.*]], i64 0, i32 0, i64 [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 2, <2 x i64> [[VEC_IND]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 1, <2 x i64> [[VEC_IND]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor <2 x i1> [[TMP1]], <i1 true, i1 true>
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP1]], <2 x double*> [[TMP4]], <2 x double*> [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds double, double* [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast double* [[TMP6]] to <2 x double>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x double>, <2 x double>* [[TMP7]], align 8
; CHECK-NEXT:    [[TMP8:%.*]] = fmul <2 x double> <double 3.000000e+00, double 3.000000e+00>, [[WIDE_LOAD]]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x double> [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <2 x double*> [[PREDPHI]], i32 0
; CHECK-NEXT:    store double [[TMP9]], double* [[TMP10]], align 8
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <2 x double> [[TMP8]], i32 1
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x double*> [[PREDPHI]], i32 1
; CHECK-NEXT:    store double [[TMP11]], double* [[TMP12]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i64> [[VEC_IND]], <i64 2, i64 2>
; CHECK-NEXT:    [[TMP13:%.*]] = icmp eq i64 [[INDEX_NEXT]], 32000
; CHECK-NEXT:    br i1 [[TMP13]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP4:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 32000, 32000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 32000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[CMP5:%.*]] = icmp ult i64 [[IV]], 15999
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 0, i64 [[IV]]
; CHECK-NEXT:    br i1 [[CMP5]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 1, i64 [[IV]]
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       if.else:
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds [[S1]], %s1* [[DATA]], i64 0, i32 2, i64 [[IV]]
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[GEP_2_SINK:%.*]] = phi double* [ [[GEP_2]], [[IF_ELSE]] ], [ [[GEP_1]], [[IF_THEN]] ]
; CHECK-NEXT:    [[V8:%.*]] = load double, double* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[MUL16:%.*]] = fmul double 3.000000e+00, [[V8]]
; CHECK-NEXT:    store double [[MUL16]], double* [[GEP_2_SINK]], align 8
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 32000
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP5:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 10
;
entry:
  br label %loop.header

loop.header:                                        ; preds = %loop.latch, %entry
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %iv.next = add nuw nsw i64 %iv, 1
  %cmp5 = icmp ult i64 %iv, 15999
  %arrayidx = getelementptr inbounds %s1, %s1 * %data, i64 0, i32 0, i64 %iv
  br i1 %cmp5, label %if.then, label %if.else

if.then:                                          ; preds = %loop.header
  %gep.1 = getelementptr inbounds %s1, %s1* %data, i64 0, i32 1, i64 %iv
  br label %loop.latch

if.else:                                          ; preds = %loop.header
  %gep.2 = getelementptr inbounds %s1, %s1* %data, i64 0, i32 2, i64 %iv
  br label %loop.latch

loop.latch:                                          ; preds = %if.else, %if.then
  %gep.2.sink = phi double* [ %gep.2, %if.else ], [ %gep.1, %if.then ]
  %v8 = load double, double* %arrayidx, align 8
  %mul16 = fmul double 3.0, %v8
  store double %mul16, double* %gep.2.sink, align 8
  %exitcond.not = icmp eq i64 %iv.next, 32000
  br i1 %exitcond.not, label %exit, label %loop.header

exit:                                             ; preds = %loop.latch
  ret i32 10
}

define i32 @store_with_pointer_phi_runtime_checks(double* %A, double* %B, double* %C) {
; CHECK-LABEL: @store_with_pointer_phi_runtime_checks(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[B1:%.*]] = bitcast double* [[B:%.*]] to i8*
; CHECK-NEXT:    [[C3:%.*]] = bitcast double* [[C:%.*]] to i8*
; CHECK-NEXT:    [[A6:%.*]] = bitcast double* [[A:%.*]] to i8*
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_MEMCHECK:%.*]]
; CHECK:       vector.memcheck:
; CHECK-NEXT:    [[SCEVGEP:%.*]] = getelementptr double, double* [[B]], i64 32000
; CHECK-NEXT:    [[SCEVGEP2:%.*]] = bitcast double* [[SCEVGEP]] to i8*
; CHECK-NEXT:    [[SCEVGEP4:%.*]] = getelementptr double, double* [[C]], i64 32000
; CHECK-NEXT:    [[SCEVGEP45:%.*]] = bitcast double* [[SCEVGEP4]] to i8*
; CHECK-NEXT:    [[SCEVGEP7:%.*]] = getelementptr double, double* [[A]], i64 32000
; CHECK-NEXT:    [[SCEVGEP78:%.*]] = bitcast double* [[SCEVGEP7]] to i8*
; CHECK-NEXT:    [[BOUND0:%.*]] = icmp ult i8* [[B1]], [[SCEVGEP45]]
; CHECK-NEXT:    [[BOUND1:%.*]] = icmp ult i8* [[C3]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT:%.*]] = and i1 [[BOUND0]], [[BOUND1]]
; CHECK-NEXT:    [[BOUND09:%.*]] = icmp ult i8* [[B1]], [[SCEVGEP78]]
; CHECK-NEXT:    [[BOUND110:%.*]] = icmp ult i8* [[A6]], [[SCEVGEP2]]
; CHECK-NEXT:    [[FOUND_CONFLICT11:%.*]] = and i1 [[BOUND09]], [[BOUND110]]
; CHECK-NEXT:    [[CONFLICT_RDX:%.*]] = or i1 [[FOUND_CONFLICT]], [[FOUND_CONFLICT11]]
; CHECK-NEXT:    [[BOUND012:%.*]] = icmp ult i8* [[C3]], [[SCEVGEP78]]
; CHECK-NEXT:    [[BOUND113:%.*]] = icmp ult i8* [[A6]], [[SCEVGEP45]]
; CHECK-NEXT:    [[FOUND_CONFLICT14:%.*]] = and i1 [[BOUND012]], [[BOUND113]]
; CHECK-NEXT:    [[CONFLICT_RDX15:%.*]] = or i1 [[CONFLICT_RDX]], [[FOUND_CONFLICT14]]
; CHECK-NEXT:    br i1 [[CONFLICT_RDX15]], label [[SCALAR_PH]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i64> [ <i64 0, i64 1>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ult <2 x i64> [[VEC_IND]], <i64 15999, i64 15999>
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds double, double* [[A]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds double, double* [[C]], <2 x i64> [[VEC_IND]]
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds double, double* [[B]], <2 x i64> [[VEC_IND]]
; CHECK-NEXT:    [[TMP5:%.*]] = xor <2 x i1> [[TMP1]], <i1 true, i1 true>
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP1]], <2 x double*> [[TMP4]], <2 x double*> [[TMP3]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds double, double* [[TMP2]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast double* [[TMP6]] to <2 x double>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <2 x double>, <2 x double>* [[TMP7]], align 8, !alias.scope !6
; CHECK-NEXT:    [[TMP8:%.*]] = fmul <2 x double> <double 3.000000e+00, double 3.000000e+00>, [[WIDE_LOAD]]
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x double> [[TMP8]], i32 0
; CHECK-NEXT:    [[TMP10:%.*]] = extractelement <2 x double*> [[PREDPHI]], i32 0
; CHECK-NEXT:    store double [[TMP9]], double* [[TMP10]], align 8
; CHECK-NEXT:    [[TMP11:%.*]] = extractelement <2 x double> [[TMP8]], i32 1
; CHECK-NEXT:    [[TMP12:%.*]] = extractelement <2 x double*> [[PREDPHI]], i32 1
; CHECK-NEXT:    store double [[TMP11]], double* [[TMP12]], align 8
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i64 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i64> [[VEC_IND]], <i64 2, i64 2>
; CHECK-NEXT:    [[TMP13:%.*]] = icmp eq i64 [[INDEX_NEXT]], 32000
; CHECK-NEXT:    br i1 [[TMP13]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP9:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 32000, 32000
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 32000, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ], [ 0, [[VECTOR_MEMCHECK]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[CMP5:%.*]] = icmp ult i64 [[IV]], 15999
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[A]], i64 [[IV]]
; CHECK-NEXT:    br i1 [[CMP5]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[GEP_1:%.*]] = getelementptr inbounds double, double* [[B]], i64 [[IV]]
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       if.else:
; CHECK-NEXT:    [[GEP_2:%.*]] = getelementptr inbounds double, double* [[C]], i64 [[IV]]
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[GEP_2_SINK:%.*]] = phi double* [ [[GEP_2]], [[IF_ELSE]] ], [ [[GEP_1]], [[IF_THEN]] ]
; CHECK-NEXT:    [[V8:%.*]] = load double, double* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[MUL16:%.*]] = fmul double 3.000000e+00, [[V8]]
; CHECK-NEXT:    store double [[MUL16]], double* [[GEP_2_SINK]], align 8
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 32000
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT]], label [[LOOP_HEADER]], !llvm.loop [[LOOP10:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 10
;
entry:
  br label %loop.header

loop.header:                                        ; preds = %loop.latch, %entry
  %iv = phi i64 [ 0, %entry ], [ %iv.next, %loop.latch ]
  %iv.next = add nuw nsw i64 %iv, 1
  %cmp5 = icmp ult i64 %iv, 15999
  %arrayidx = getelementptr inbounds double, double* %A, i64 %iv
  br i1 %cmp5, label %if.then, label %if.else

if.then:                                          ; preds = %loop.header
  %gep.1 = getelementptr inbounds double, double* %B, i64 %iv
  br label %loop.latch

if.else:                                          ; preds = %loop.header
  %gep.2 = getelementptr inbounds double, double* %C, i64 %iv
  br label %loop.latch

loop.latch:                                          ; preds = %if.else, %if.then
  %gep.2.sink = phi double* [ %gep.2, %if.else ], [ %gep.1, %if.then ]
  %v8 = load double, double* %arrayidx, align 8
  %mul16 = fmul double 3.0, %v8
  store double %mul16, double* %gep.2.sink, align 8
  %exitcond.not = icmp eq i64 %iv.next, 32000
  br i1 %exitcond.not, label %exit, label %loop.header

exit:                                             ; preds = %loop.latch
  ret i32 10
}

define i32 @load_with_pointer_phi_outside_loop(double* %A, double* %B, double* %C, i1 %c.0, i1 %c.1) {
; CHECK-LABEL: @load_with_pointer_phi_outside_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C_0:%.*]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[LOOP_PH:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    [[PTR_SELECT:%.*]] = select i1 [[C_1:%.*]], double* [[C:%.*]], double* [[B:%.*]]
; CHECK-NEXT:    br label [[LOOP_PH]]
; CHECK:       loop.ph:
; CHECK-NEXT:    [[PTR:%.*]] = phi double* [ [[A:%.*]], [[IF_THEN]] ], [ [[PTR_SELECT]], [[IF_ELSE]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[LOOP_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[A]], i64 [[IV]]
; CHECK-NEXT:    [[V8:%.*]] = load double, double* [[PTR]], align 8
; CHECK-NEXT:    [[MUL16:%.*]] = fmul double 3.000000e+00, [[V8]]
; CHECK-NEXT:    store double [[MUL16]], double* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 32000
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT:%.*]], label [[LOOP_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 10
;
entry:
  br i1 %c.0, label %if.then, label %if.else

if.then:
  br label %loop.ph

if.else:
  %ptr.select = select i1 %c.1, double* %C, double* %B
  br label %loop.ph

loop.ph:
  %ptr = phi double* [ %A, %if.then ], [ %ptr.select, %if.else ]
  br label %loop.header

loop.header:                                        ; preds = %loop.latch, %entry
  %iv = phi i64 [ 0, %loop.ph ], [ %iv.next, %loop.header ]
  %iv.next = add nuw nsw i64 %iv, 1
  %arrayidx = getelementptr inbounds double, double* %A, i64 %iv
  %v8 = load double, double* %ptr, align 8
  %mul16 = fmul double 3.0, %v8
  store double %mul16, double* %arrayidx, align 8
  %exitcond.not = icmp eq i64 %iv.next, 32000
  br i1 %exitcond.not, label %exit, label %loop.header

exit:                                             ; preds = %loop.latch
  ret i32 10
}

define i32 @store_with_pointer_phi_outside_loop(double* %A, double* %B, double* %C, i1 %c.0, i1 %c.1) {
; CHECK-LABEL: @store_with_pointer_phi_outside_loop(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[C_0:%.*]], label [[IF_THEN:%.*]], label [[IF_ELSE:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    br label [[LOOP_PH:%.*]]
; CHECK:       if.else:
; CHECK-NEXT:    [[PTR_SELECT:%.*]] = select i1 [[C_1:%.*]], double* [[C:%.*]], double* [[B:%.*]]
; CHECK-NEXT:    br label [[LOOP_PH]]
; CHECK:       loop.ph:
; CHECK-NEXT:    [[PTR:%.*]] = phi double* [ [[A:%.*]], [[IF_THEN]] ], [ [[PTR_SELECT]], [[IF_ELSE]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i64 [ 0, [[LOOP_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_HEADER]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i64 [[IV]], 1
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds double, double* [[A]], i64 [[IV]]
; CHECK-NEXT:    [[V8:%.*]] = load double, double* [[ARRAYIDX]], align 8
; CHECK-NEXT:    [[MUL16:%.*]] = fmul double 3.000000e+00, [[V8]]
; CHECK-NEXT:    store double [[MUL16]], double* [[PTR]], align 8
; CHECK-NEXT:    [[EXITCOND_NOT:%.*]] = icmp eq i64 [[IV_NEXT]], 32000
; CHECK-NEXT:    br i1 [[EXITCOND_NOT]], label [[EXIT:%.*]], label [[LOOP_HEADER]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 10
;
entry:
  br i1 %c.0, label %if.then, label %if.else

if.then:
  br label %loop.ph

if.else:
  %ptr.select = select i1 %c.1, double* %C, double* %B
  br label %loop.ph

loop.ph:
  %ptr = phi double* [ %A, %if.then ], [ %ptr.select, %if.else ]
  br label %loop.header

loop.header:                                        ; preds = %loop.latch, %entry
  %iv = phi i64 [ 0, %loop.ph ], [ %iv.next, %loop.header ]
  %iv.next = add nuw nsw i64 %iv, 1
  %arrayidx = getelementptr inbounds double, double* %A, i64 %iv
  %v8 = load double, double* %arrayidx, align 8
  %mul16 = fmul double 3.0, %v8
  store double %mul16, double* %ptr, align 8
  %exitcond.not = icmp eq i64 %iv.next, 32000
  br i1 %exitcond.not, label %exit, label %loop.header

exit:                                             ; preds = %loop.latch
  ret i32 10
}
