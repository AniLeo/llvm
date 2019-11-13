; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=instcombine,verify -S < %s | FileCheck %s --check-prefixes=ALL,INSTCOMBINE

; Make sure GVN won't undo the transformation:
; RUN: opt -passes=instcombine,gvn -S < %s | FileCheck %s --check-prefixes=ALL,INSTCOMBINEGVN

declare i8* @get_ptr.i8()
declare i32* @get_ptr.i32()
declare void @foo.i8(i8*)
declare void @foo.i32(i32*)

define i32 @test_gep_and_bitcast(i1 %cond, i1 %cond2) {
; ALL-LABEL: @test_gep_and_bitcast(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR2_TYPED:%.*]] = bitcast i8* [[PTR2]] to i32*
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI_IN:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = load i32, i32* [[RES_PHI_IN]], align 4
; ALL-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; ALL-NEXT:    ret i32 [[RES]]
;
entry:
  %obj = call i8* @get_ptr.i8()
  br i1 %cond, label %bb1, label %bb2

bb1:
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr1.typed = bitcast i8* %ptr1 to i32*
  %res1 = load i32, i32* %ptr1.typed
  br label %exit

bb2:
  %ptr2 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr2.typed = bitcast i8* %ptr2 to i32*
  %res2 = load i32, i32* %ptr2.typed
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %bb1 ], [ %ptr2.typed, %bb2 ]
  %res.phi = phi i32 [ %res1, %bb1 ], [ %res2, %bb2 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond2, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i32 @test_gep_and_bitcast_arg(i8* %obj, i1 %cond, i1 %cond2) {
; ALL-LABEL: @test_gep_and_bitcast_arg(
; ALL-NEXT:  entry:
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ:%.*]], i64 16
; ALL-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR2_TYPED:%.*]] = bitcast i8* [[PTR2]] to i32*
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI_IN:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = load i32, i32* [[RES_PHI_IN]], align 4
; ALL-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; ALL-NEXT:    ret i32 [[RES]]
;
entry:
  br i1 %cond, label %bb1, label %bb2

bb1:
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr1.typed = bitcast i8* %ptr1 to i32*
  %res1 = load i32, i32* %ptr1.typed
  br label %exit

bb2:
  %ptr2 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr2.typed = bitcast i8* %ptr2 to i32*
  %res2 = load i32, i32* %ptr2.typed
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %bb1 ], [ %ptr2.typed, %bb2 ]
  %res.phi = phi i32 [ %res1, %bb1 ], [ %res2, %bb2 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond2, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i32 @test_gep_and_bitcast_phi(i1 %cond, i1 %cond2, i1 %cond3) {
; ALL-LABEL: @test_gep_and_bitcast_phi(
; ALL-NEXT:  entry:
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[OBJ1:%.*]] = call i8* @get_ptr.i8()
; ALL-NEXT:    br label [[MERGE:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[OBJ2_TYPED:%.*]] = call i32* @get_ptr.i32()
; ALL-NEXT:    [[OBJ2:%.*]] = bitcast i32* [[OBJ2_TYPED]] to i8*
; ALL-NEXT:    br label [[MERGE]]
; ALL:       merge:
; ALL-NEXT:    [[OBJ:%.*]] = phi i8* [ [[OBJ1]], [[BB1]] ], [ [[OBJ2]], [[BB2]] ]
; ALL-NEXT:    [[ANOTHER_PHI:%.*]] = phi i8* [ [[OBJ1]], [[BB1]] ], [ null, [[BB2]] ]
; ALL-NEXT:    call void @foo.i8(i8* [[ANOTHER_PHI]])
; ALL-NEXT:    br i1 [[COND2:%.*]], label [[BB3:%.*]], label [[BB4:%.*]]
; ALL:       bb3:
; ALL-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb4:
; ALL-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR2_TYPED:%.*]] = bitcast i8* [[PTR2]] to i32*
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB3]] ], [ [[PTR2_TYPED]], [[BB4]] ]
; ALL-NEXT:    [[RES_PHI_IN:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB3]] ], [ [[PTR2_TYPED]], [[BB4]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = load i32, i32* [[RES_PHI_IN]], align 4
; ALL-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND3:%.*]], i32 [[RES_PHI]], i32 1
; ALL-NEXT:    ret i32 [[RES]]
;
entry:
  br i1 %cond, label %bb1, label %bb2

bb1:
  %obj1 = call i8* @get_ptr.i8()
  br label %merge

bb2:
  %obj2.typed = call i32* @get_ptr.i32()
  %obj2 = bitcast i32* %obj2.typed to i8*
  br label %merge

merge:
  %obj = phi i8* [ %obj1, %bb1 ], [ %obj2, %bb2 ]
  %another_phi = phi i8* [ %obj1, %bb1 ], [ null, %bb2 ]
  call void @foo.i8(i8* %another_phi)
  br i1 %cond2, label %bb3, label %bb4

bb3:
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr1.typed = bitcast i8* %ptr1 to i32*
  %res1 = load i32, i32* %ptr1.typed
  br label %exit

bb4:
  %ptr2 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr2.typed = bitcast i8* %ptr2 to i32*
  %res2 = load i32, i32* %ptr2.typed
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %bb3 ], [ %ptr2.typed, %bb4 ]
  %res.phi = phi i32 [ %res1, %bb3 ], [ %res2, %bb4 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond3, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i32 @test_gep_i32ptr(i1 %cond, i1 %cond2) {
; ALL-LABEL: @test_gep_i32ptr(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[OBJ:%.*]] = call i32* @get_ptr.i32()
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[PTR1_TYPED:%.*]] = getelementptr inbounds i32, i32* [[OBJ]], i64 16
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[PTR2_TYPED:%.*]] = getelementptr inbounds i32, i32* [[OBJ]], i64 16
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI_IN:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = load i32, i32* [[RES_PHI_IN]], align 4
; ALL-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; ALL-NEXT:    ret i32 [[RES]]
;
entry:
  %obj = call i32* @get_ptr.i32()
  br i1 %cond, label %bb1, label %bb2

bb1:
  %ptr1.typed = getelementptr inbounds i32, i32* %obj, i64 16
  %res1 = load i32, i32* %ptr1.typed
  br label %exit

bb2:
  %ptr2.typed = getelementptr inbounds i32, i32* %obj, i64 16
  %res2 = load i32, i32* %ptr2.typed
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %bb1 ], [ %ptr2.typed, %bb2 ]
  %res.phi = phi i32 [ %res1, %bb1 ], [ %res2, %bb2 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond2, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i32 @test_gep_and_bitcast_gep_base_ptr(i1 %cond, i1 %cond2) {
; ALL-LABEL: @test_gep_and_bitcast_gep_base_ptr(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[OBJ0:%.*]] = call i8* @get_ptr.i8()
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ0]], i64 32
; ALL-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i8, i8* [[OBJ0]], i64 32
; ALL-NEXT:    [[PTR2_TYPED:%.*]] = bitcast i8* [[PTR2]] to i32*
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI_IN:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = load i32, i32* [[RES_PHI_IN]], align 4
; ALL-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; ALL-NEXT:    ret i32 [[RES]]
;
entry:
  %obj0 = call i8* @get_ptr.i8()
  %obj = getelementptr inbounds i8, i8* %obj0, i64 16
  br i1 %cond, label %bb1, label %bb2

bb1:
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr1.typed = bitcast i8* %ptr1 to i32*
  %res1 = load i32, i32* %ptr1.typed
  br label %exit

bb2:
  %ptr2 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr2.typed = bitcast i8* %ptr2 to i32*
  %res2 = load i32, i32* %ptr2.typed
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %bb1 ], [ %ptr2.typed, %bb2 ]
  %res.phi = phi i32 [ %res1, %bb1 ], [ %res2, %bb2 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond2, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i32 @test_gep_and_bitcast_same_bb(i1 %cond, i1 %cond2) {
; INSTCOMBINE-LABEL: @test_gep_and_bitcast_same_bb(
; INSTCOMBINE-NEXT:  entry:
; INSTCOMBINE-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; INSTCOMBINE-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; INSTCOMBINE-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; INSTCOMBINE-NEXT:    br i1 [[COND:%.*]], label [[EXIT:%.*]], label [[BB2:%.*]]
; INSTCOMBINE:       bb2:
; INSTCOMBINE-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; INSTCOMBINE-NEXT:    [[PTR2_TYPED:%.*]] = bitcast i8* [[PTR2]] to i32*
; INSTCOMBINE-NEXT:    br label [[EXIT]]
; INSTCOMBINE:       exit:
; INSTCOMBINE-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[ENTRY:%.*]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; INSTCOMBINE-NEXT:    [[RES_PHI_IN:%.*]] = phi i32* [ [[PTR1_TYPED]], [[ENTRY]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; INSTCOMBINE-NEXT:    [[RES_PHI:%.*]] = load i32, i32* [[RES_PHI_IN]], align 4
; INSTCOMBINE-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; INSTCOMBINE-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; INSTCOMBINE-NEXT:    ret i32 [[RES]]
;
; INSTCOMBINEGVN-LABEL: @test_gep_and_bitcast_same_bb(
; INSTCOMBINEGVN-NEXT:  entry:
; INSTCOMBINEGVN-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; INSTCOMBINEGVN-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; INSTCOMBINEGVN-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; INSTCOMBINEGVN-NEXT:    br i1 [[COND:%.*]], label [[EXIT:%.*]], label [[BB2:%.*]]
; INSTCOMBINEGVN:       bb2:
; INSTCOMBINEGVN-NEXT:    br label [[EXIT]]
; INSTCOMBINEGVN:       exit:
; INSTCOMBINEGVN-NEXT:    [[RES_PHI:%.*]] = load i32, i32* [[PTR1_TYPED]], align 4
; INSTCOMBINEGVN-NEXT:    store i32 1, i32* [[PTR1_TYPED]], align 4
; INSTCOMBINEGVN-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; INSTCOMBINEGVN-NEXT:    ret i32 [[RES]]
;
entry:
  %obj = call i8* @get_ptr.i8()
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr1.typed = bitcast i8* %ptr1 to i32*
  %res1 = load i32, i32* %ptr1.typed
  br i1 %cond, label %exit, label %bb2

bb2:
  %ptr2 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr2.typed = bitcast i8* %ptr2 to i32*
  %res2 = load i32, i32* %ptr2.typed
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %entry ], [ %ptr2.typed, %bb2 ]
  %res.phi = phi i32 [ %res1, %entry ], [ %res2, %bb2 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond2, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i32 @test_gep_and_bitcast_same_bb_and_extra_use(i1 %cond, i1 %cond2) {
; INSTCOMBINE-LABEL: @test_gep_and_bitcast_same_bb_and_extra_use(
; INSTCOMBINE-NEXT:  entry:
; INSTCOMBINE-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; INSTCOMBINE-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; INSTCOMBINE-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; INSTCOMBINE-NEXT:    call void @foo.i32(i32* nonnull [[PTR1_TYPED]])
; INSTCOMBINE-NEXT:    br i1 [[COND:%.*]], label [[EXIT:%.*]], label [[BB2:%.*]]
; INSTCOMBINE:       bb2:
; INSTCOMBINE-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; INSTCOMBINE-NEXT:    [[PTR2_TYPED:%.*]] = bitcast i8* [[PTR2]] to i32*
; INSTCOMBINE-NEXT:    br label [[EXIT]]
; INSTCOMBINE:       exit:
; INSTCOMBINE-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[ENTRY:%.*]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; INSTCOMBINE-NEXT:    [[RES_PHI_IN:%.*]] = phi i32* [ [[PTR1_TYPED]], [[ENTRY]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; INSTCOMBINE-NEXT:    [[RES_PHI:%.*]] = load i32, i32* [[RES_PHI_IN]], align 4
; INSTCOMBINE-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; INSTCOMBINE-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; INSTCOMBINE-NEXT:    ret i32 [[RES]]
;
; INSTCOMBINEGVN-LABEL: @test_gep_and_bitcast_same_bb_and_extra_use(
; INSTCOMBINEGVN-NEXT:  entry:
; INSTCOMBINEGVN-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; INSTCOMBINEGVN-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; INSTCOMBINEGVN-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; INSTCOMBINEGVN-NEXT:    call void @foo.i32(i32* nonnull [[PTR1_TYPED]])
; INSTCOMBINEGVN-NEXT:    br i1 [[COND:%.*]], label [[EXIT:%.*]], label [[BB2:%.*]]
; INSTCOMBINEGVN:       bb2:
; INSTCOMBINEGVN-NEXT:    br label [[EXIT]]
; INSTCOMBINEGVN:       exit:
; INSTCOMBINEGVN-NEXT:    [[RES_PHI:%.*]] = load i32, i32* [[PTR1_TYPED]], align 4
; INSTCOMBINEGVN-NEXT:    store i32 1, i32* [[PTR1_TYPED]], align 4
; INSTCOMBINEGVN-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; INSTCOMBINEGVN-NEXT:    ret i32 [[RES]]
;
entry:
  %obj = call i8* @get_ptr.i8()
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr1.typed = bitcast i8* %ptr1 to i32*
  call void @foo.i32(i32* %ptr1.typed)
  %res1 = load i32, i32* %ptr1.typed
  br i1 %cond, label %exit, label %bb2

bb2:
  %ptr2 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr2.typed = bitcast i8* %ptr2 to i32*
  %res2 = load i32, i32* %ptr2.typed
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %entry ], [ %ptr2.typed, %bb2 ]
  %res.phi = phi i32 [ %res1, %entry ], [ %res2, %bb2 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond2, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i8 @test_gep(i1 %cond, i1 %cond2) {
; ALL-LABEL: @test_gep(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i8* [ [[PTR1]], [[BB1]] ], [ [[PTR2]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI_IN:%.*]] = phi i8* [ [[PTR1]], [[BB1]] ], [ [[PTR2]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = load i8, i8* [[RES_PHI_IN]], align 1
; ALL-NEXT:    store i8 1, i8* [[PTR_TYPED]], align 1
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i8 [[RES_PHI]], i8 1
; ALL-NEXT:    ret i8 [[RES]]
;
entry:
  %obj = call i8* @get_ptr.i8()
  br i1 %cond, label %bb1, label %bb2

bb1:
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %res1 = load i8, i8* %ptr1
  br label %exit

bb2:
  %ptr2 = getelementptr inbounds i8, i8* %obj, i64 16
  %res2 = load i8, i8* %ptr2
  br label %exit

exit:
  %ptr.typed = phi i8* [ %ptr1, %bb1 ], [ %ptr2, %bb2 ]
  %res.phi = phi i8 [ %res1, %bb1 ], [ %res2, %bb2 ]
  store i8 1, i8* %ptr.typed
  %res.load = load i8, i8* %ptr.typed
  %res = select i1 %cond2, i8 %res.phi, i8 %res.load
  ret i8 %res
}

define i32 @test_extra_uses(i1 %cond, i1 %cond2) {
; ALL-LABEL: @test_extra_uses(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; ALL-NEXT:    [[RES1:%.*]] = load i32, i32* [[PTR1_TYPED]], align 4
; ALL-NEXT:    call void @foo.i32(i32* nonnull [[PTR1_TYPED]])
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR2_TYPED:%.*]] = bitcast i8* [[PTR2]] to i32*
; ALL-NEXT:    [[RES2:%.*]] = load i32, i32* [[PTR2_TYPED]], align 4
; ALL-NEXT:    call void @foo.i32(i32* nonnull [[PTR2_TYPED]])
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = phi i32 [ [[RES1]], [[BB1]] ], [ [[RES2]], [[BB2]] ]
; ALL-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; ALL-NEXT:    ret i32 [[RES]]
;
entry:
  %obj = call i8* @get_ptr.i8()
  br i1 %cond, label %bb1, label %bb2

bb1:
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr1.typed = bitcast i8* %ptr1 to i32*
  %res1 = load i32, i32* %ptr1.typed
  call void @foo.i32(i32* %ptr1.typed)
  br label %exit

bb2:
  %ptr2 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr2.typed = bitcast i8* %ptr2 to i32*
  %res2 = load i32, i32* %ptr2.typed
  call void @foo.i32(i32* %ptr2.typed)
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %bb1 ], [ %ptr2.typed, %bb2 ]
  %res.phi = phi i32 [ %res1, %bb1 ], [ %res2, %bb2 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond2, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i32 @test_extra_uses_non_inbounds(i1 %cond, i1 %cond2) {
; ALL-LABEL: @test_extra_uses_non_inbounds(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[PTR1:%.*]] = getelementptr i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; ALL-NEXT:    [[RES1:%.*]] = load i32, i32* [[PTR1_TYPED]], align 4
; ALL-NEXT:    call void @foo.i32(i32* [[PTR1_TYPED]])
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[PTR2:%.*]] = getelementptr i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR2_TYPED:%.*]] = bitcast i8* [[PTR2]] to i32*
; ALL-NEXT:    [[RES2:%.*]] = load i32, i32* [[PTR2_TYPED]], align 4
; ALL-NEXT:    call void @foo.i32(i32* [[PTR2_TYPED]])
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = phi i32 [ [[RES1]], [[BB1]] ], [ [[RES2]], [[BB2]] ]
; ALL-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; ALL-NEXT:    ret i32 [[RES]]
;
entry:
  %obj = call i8* @get_ptr.i8()
  br i1 %cond, label %bb1, label %bb2

bb1:
  %ptr1 = getelementptr i8, i8* %obj, i64 16
  %ptr1.typed = bitcast i8* %ptr1 to i32*
  %res1 = load i32, i32* %ptr1.typed
  call void @foo.i32(i32* %ptr1.typed)
  br label %exit

bb2:
  %ptr2 = getelementptr i8, i8* %obj, i64 16
  %ptr2.typed = bitcast i8* %ptr2 to i32*
  %res2 = load i32, i32* %ptr2.typed
  call void @foo.i32(i32* %ptr2.typed)
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %bb1 ], [ %ptr2.typed, %bb2 ]
  %res.phi = phi i32 [ %res1, %bb1 ], [ %res2, %bb2 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond2, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i32 @test_extra_uses_multiple_geps(i1 %cond, i1 %cond2) {
; ALL-LABEL: @test_extra_uses_multiple_geps(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR1_TYPED:%.*]] = bitcast i8* [[PTR1]] to i32*
; ALL-NEXT:    [[RES1:%.*]] = load i32, i32* [[PTR1_TYPED]], align 4
; ALL-NEXT:    call void @foo.i32(i32* nonnull [[PTR1_TYPED]])
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[PTR2_1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[PTR2_TYPED:%.*]] = bitcast i8* [[PTR2_1]] to i32*
; ALL-NEXT:    [[RES2:%.*]] = load i32, i32* [[PTR2_TYPED]], align 4
; ALL-NEXT:    call void @foo.i32(i32* nonnull [[PTR2_TYPED]])
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i32* [ [[PTR1_TYPED]], [[BB1]] ], [ [[PTR2_TYPED]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = phi i32 [ [[RES1]], [[BB1]] ], [ [[RES2]], [[BB2]] ]
; ALL-NEXT:    store i32 1, i32* [[PTR_TYPED]], align 4
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i32 [[RES_PHI]], i32 1
; ALL-NEXT:    ret i32 [[RES]]
;
entry:
  %obj = call i8* @get_ptr.i8()
  br i1 %cond, label %bb1, label %bb2

bb1:
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %ptr1.typed = bitcast i8* %ptr1 to i32*
  %res1 = load i32, i32* %ptr1.typed
  call void @foo.i32(i32* %ptr1.typed)
  br label %exit

bb2:
  %ptr2.0 = getelementptr i8, i8* %obj, i64 8
  %ptr2.1 = getelementptr inbounds i8, i8* %ptr2.0, i64 8
  %ptr2.typed = bitcast i8* %ptr2.1 to i32*
  %res2 = load i32, i32* %ptr2.typed
  call void @foo.i32(i32* %ptr2.typed)
  br label %exit

exit:
  %ptr.typed = phi i32* [ %ptr1.typed, %bb1 ], [ %ptr2.typed, %bb2 ]
  %res.phi = phi i32 [ %res1, %bb1 ], [ %res2, %bb2 ]
  store i32 1, i32* %ptr.typed
  %res.load = load i32, i32* %ptr.typed
  %res = select i1 %cond2, i32 %res.phi, i32 %res.load
  ret i32 %res
}

define i8 @test_gep_extra_uses(i1 %cond, i1 %cond2) {
; ALL-LABEL: @test_gep_extra_uses(
; ALL-NEXT:  entry:
; ALL-NEXT:    [[OBJ:%.*]] = call i8* @get_ptr.i8()
; ALL-NEXT:    br i1 [[COND:%.*]], label [[BB1:%.*]], label [[BB2:%.*]]
; ALL:       bb1:
; ALL-NEXT:    [[PTR1:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[RES1:%.*]] = load i8, i8* [[PTR1]], align 1
; ALL-NEXT:    call void @foo.i8(i8* nonnull [[PTR1]])
; ALL-NEXT:    br label [[EXIT:%.*]]
; ALL:       bb2:
; ALL-NEXT:    [[PTR2:%.*]] = getelementptr inbounds i8, i8* [[OBJ]], i64 16
; ALL-NEXT:    [[RES2:%.*]] = load i8, i8* [[PTR2]], align 1
; ALL-NEXT:    call void @foo.i8(i8* nonnull [[PTR2]])
; ALL-NEXT:    br label [[EXIT]]
; ALL:       exit:
; ALL-NEXT:    [[PTR_TYPED:%.*]] = phi i8* [ [[PTR1]], [[BB1]] ], [ [[PTR2]], [[BB2]] ]
; ALL-NEXT:    [[RES_PHI:%.*]] = phi i8 [ [[RES1]], [[BB1]] ], [ [[RES2]], [[BB2]] ]
; ALL-NEXT:    store i8 1, i8* [[PTR_TYPED]], align 1
; ALL-NEXT:    [[RES:%.*]] = select i1 [[COND2:%.*]], i8 [[RES_PHI]], i8 1
; ALL-NEXT:    ret i8 [[RES]]
;
entry:
  %obj = call i8* @get_ptr.i8()
  br i1 %cond, label %bb1, label %bb2

bb1:
  %ptr1 = getelementptr inbounds i8, i8* %obj, i64 16
  %res1 = load i8, i8* %ptr1
  call void @foo.i8(i8* %ptr1)
  br label %exit

bb2:
  %ptr2 = getelementptr inbounds i8, i8* %obj, i64 16
  %res2 = load i8, i8* %ptr2
  call void @foo.i8(i8* %ptr2)
  br label %exit

exit:
  %ptr.typed = phi i8* [ %ptr1, %bb1 ], [ %ptr2, %bb2 ]
  %res.phi = phi i8 [ %res1, %bb1 ], [ %res2, %bb2 ]
  store i8 1, i8* %ptr.typed
  %res.load = load i8, i8* %ptr.typed
  %res = select i1 %cond2, i8 %res.phi, i8 %res.load
  ret i8 %res
}
