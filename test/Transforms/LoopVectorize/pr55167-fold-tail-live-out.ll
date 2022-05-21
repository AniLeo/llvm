; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -loop-vectorize -force-vector-width=2 -force-vector-interleave=1 -S %s | FileCheck %s

define i32 @test(i32 %a, i1 %c.1, i1 %c.2 ) #0 {
; CHECK-LABEL: @test(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <2 x i32> poison, i32 [[A:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <2 x i32> [[BROADCAST_SPLATINSERT]], <2 x i32> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT1:%.*]] = insertelement <2 x i1> poison, i1 [[C_1:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT2:%.*]] = shufflevector <2 x i1> [[BROADCAST_SPLATINSERT1]], <2 x i1> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT3:%.*]] = insertelement <2 x i1> poison, i1 [[C_2:%.*]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT4:%.*]] = shufflevector <2 x i1> [[BROADCAST_SPLATINSERT3]], <2 x i1> poison, <2 x i32> zeroinitializer
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i32 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_IND:%.*]] = phi <2 x i32> [ <i32 6, i32 7>, [[VECTOR_PH]] ], [ [[VEC_IND_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[VEC_PHI:%.*]] = phi <2 x i32> [ <i32 35902, i32 0>, [[VECTOR_PH]] ], [ [[PREDPHI7:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[TMP0:%.*]] = add <2 x i32> [[VEC_PHI]], <i32 10, i32 10>
; CHECK-NEXT:    [[TMP1:%.*]] = add <2 x i32> [[TMP0]], <i32 20, i32 20>
; CHECK-NEXT:    [[TMP2:%.*]] = xor <2 x i32> [[BROADCAST_SPLAT]], <i32 1, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = add <2 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[TMP4:%.*]] = xor <2 x i1> [[BROADCAST_SPLAT2]], <i1 true, i1 true>
; CHECK-NEXT:    [[TMP5:%.*]] = select <2 x i1> [[TMP4]], <2 x i1> [[BROADCAST_SPLAT4]], <2 x i1> zeroinitializer
; CHECK-NEXT:    [[TMP6:%.*]] = xor <2 x i1> [[BROADCAST_SPLAT4]], <i1 true, i1 true>
; CHECK-NEXT:    [[TMP7:%.*]] = select <2 x i1> [[TMP4]], <2 x i1> [[TMP6]], <2 x i1> zeroinitializer
; CHECK-NEXT:    [[PREDPHI:%.*]] = select <2 x i1> [[TMP5]], <2 x i32> <i32 9, i32 9>, <2 x i32> [[VEC_IND]]
; CHECK-NEXT:    [[PREDPHI5:%.*]] = select <2 x i1> [[TMP7]], <2 x i32> <i32 9, i32 9>, <2 x i32> [[PREDPHI]]
; CHECK-NEXT:    [[PREDPHI6:%.*]] = select <2 x i1> [[TMP5]], <2 x i32> [[TMP0]], <2 x i32> [[VEC_PHI]]
; CHECK-NEXT:    [[PREDPHI7]] = select <2 x i1> [[TMP7]], <2 x i32> [[TMP3]], <2 x i32> [[PREDPHI6]]
; CHECK-NEXT:    [[INDEX_NEXT]] = add nuw i32 [[INDEX]], 2
; CHECK-NEXT:    [[VEC_IND_NEXT]] = add <2 x i32> [[VEC_IND]], <i32 2, i32 2>
; CHECK-NEXT:    [[TMP8:%.*]] = icmp eq i32 [[INDEX_NEXT]], 176
; CHECK-NEXT:    br i1 [[TMP8]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop [[LOOP0:![0-9]+]]
; CHECK:       middle.block:
; CHECK-NEXT:    [[TMP9:%.*]] = extractelement <2 x i32> [[PREDPHI5]], i32 1
; CHECK-NEXT:    [[TMP10:%.*]] = call i32 @llvm.vector.reduce.add.v2i32(<2 x i32> [[PREDPHI7]])
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i32 176, 176
; CHECK-NEXT:    br i1 [[CMP_N]], label [[EXIT:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i32 [ 182, [[MIDDLE_BLOCK]] ], [ 6, [[BB:%.*]] ]
; CHECK-NEXT:    [[BC_MERGE_RDX:%.*]] = phi i32 [ 35902, [[BB]] ], [ [[TMP10]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    br label [[LOOP_HEADER:%.*]]
; CHECK:       loop.header:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[IV_NEXT:%.*]], [[LOOP_LATCH:%.*]] ]
; CHECK-NEXT:    [[V_2:%.*]] = phi i32 [ [[BC_MERGE_RDX]], [[SCALAR_PH]] ], [ [[P_2:%.*]], [[LOOP_LATCH]] ]
; CHECK-NEXT:    br i1 [[C_1]], label [[LOOP_LATCH]], label [[BODY_1:%.*]]
; CHECK:       body.1:
; CHECK-NEXT:    [[V_2_ADD:%.*]] = add i32 [[V_2]], 10
; CHECK-NEXT:    br i1 [[C_2]], label [[LOOP_LATCH]], label [[BODY_2:%.*]]
; CHECK:       body.2:
; CHECK-NEXT:    [[ADD_1:%.*]] = add i32 [[V_2_ADD]], 20
; CHECK-NEXT:    [[XOR:%.*]] = xor i32 [[A]], 1
; CHECK-NEXT:    [[ADD_2:%.*]] = add i32 [[ADD_1]], [[XOR]]
; CHECK-NEXT:    br label [[LOOP_LATCH]]
; CHECK:       loop.latch:
; CHECK-NEXT:    [[P_1:%.*]] = phi i32 [ [[IV]], [[LOOP_HEADER]] ], [ 9, [[BODY_1]] ], [ 9, [[BODY_2]] ]
; CHECK-NEXT:    [[P_2]] = phi i32 [ [[V_2]], [[LOOP_HEADER]] ], [ [[V_2_ADD]], [[BODY_1]] ], [ [[ADD_2]], [[BODY_2]] ]
; CHECK-NEXT:    [[IV_NEXT]] = add nuw nsw i32 [[IV]], 1
; CHECK-NEXT:    [[EC:%.*]] = icmp ult i32 [[IV]], 181
; CHECK-NEXT:    br i1 [[EC]], label [[LOOP_HEADER]], label [[EXIT]], !llvm.loop [[LOOP2:![0-9]+]]
; CHECK:       exit:
; CHECK-NEXT:    [[E_1:%.*]] = phi i32 [ [[P_1]], [[LOOP_LATCH]] ], [ [[TMP9]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[E_2:%.*]] = phi i32 [ [[P_2]], [[LOOP_LATCH]] ], [ [[TMP10]], [[MIDDLE_BLOCK]] ]
; CHECK-NEXT:    [[RES:%.*]] = add i32 [[E_1]], [[E_2]]
; CHECK-NEXT:    ret i32 [[RES]]
;
bb:
  br label %loop.header

loop.header:
  %iv = phi i32 [ 6, %bb ], [ %iv.next, %loop.latch ]
  %v.2 = phi i32 [ 35902, %bb ], [ %p.2, %loop.latch ]
  br i1 %c.1, label %loop.latch, label %body.1

body.1:
  %v.2.add = add i32 %v.2, 10
  br i1 %c.2, label %loop.latch, label %body.2

body.2:                                             ; preds = %bb11
  %add.1 = add i32 %v.2.add, 20
  %xor = xor i32 %a, 1
  %add.2 = add i32 %add.1, %xor
  br label %loop.latch

loop.latch:
  %p.1 = phi i32 [ %iv, %loop.header ], [ 9, %body.1 ], [ 9, %body.2]
  %p.2 = phi i32 [ %v.2, %loop.header ], [ %v.2.add, %body.1 ], [ %add.2, %body.2 ]
  %iv.next = add nuw nsw i32 %iv, 1
  %ec = icmp ult i32 %iv, 181
  br i1 %ec, label %loop.header, label %exit

exit:
  %e.1 = phi i32 [ %p.1, %loop.latch ]
  %e.2 = phi i32 [ %p.2, %loop.latch ]
  %res = add i32 %e.1, %e.2
  ret i32 %res
}
