; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -passes=constraint-elimination -S %s | FileCheck %s

define i1 @len_known_positive_via_idx_1(i8 %len, i8 %idx) {
; CHECK-LABEL: @len_known_positive_via_idx_1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX_POS:%.*]] = icmp sge i8 [[IDX:%.*]], 0
; CHECK-NEXT:    [[IDX_SLT_LEN:%.*]] = icmp slt i8 [[IDX]], [[LEN:%.*]]
; CHECK-NEXT:    [[AND_1:%.*]] = and i1 [[IDX_POS]], [[IDX_SLT_LEN]]
; CHECK-NEXT:    br i1 [[AND_1]], label [[THEN_1:%.*]], label [[ELSE:%.*]]
; CHECK:       then.1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 [[IDX]], [[LEN]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i8 [[LEN]], 0
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[LEN]], 2
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[LEN]], 2
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[T_1]], true
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_1]]
; CHECK-NEXT:    [[RES_3:%.*]] = xor i1 [[RES_2]], [[C_2]]
; CHECK-NEXT:    ret i1 [[RES_3]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %idx.pos = icmp sge i8 %idx, 0
  %idx.slt.len  = icmp slt i8 %idx, %len
  %and.1 = and i1 %idx.pos, %idx.slt.len
  br i1 %and.1, label %then.1, label %else

then.1:
  %t.1 = icmp ult i8 %idx, %len
  %t.2 = icmp sge i8 %len, 0
  %c.1 = icmp sge i8 %len, 2
  %c.2 = icmp sge i8 %len, 2
  %res.1 = xor i1 %t.1, %t.2
  %res.2 = xor i1 %res.1, %c.1
  %res.3 = xor i1 %res.2, %c.2
  ret i1 %res.3

else:
  ret i1 0
}

; FIXME: currently adding extra facts is dependent on the visitation order of facts.
define i1 @len_known_positive_via_idx_2(i8 %len, i8 %idx) {
; CHECK-LABEL: @len_known_positive_via_idx_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX_SLT_LEN:%.*]] = icmp slt i8 [[IDX:%.*]], [[LEN:%.*]]
; CHECK-NEXT:    [[IDX_POS:%.*]] = icmp sge i8 [[IDX]], 0
; CHECK-NEXT:    [[AND_1:%.*]] = and i1 [[IDX_SLT_LEN]], [[IDX_POS]]
; CHECK-NEXT:    br i1 [[AND_1]], label [[THEN_1:%.*]], label [[ELSE:%.*]]
; CHECK:       then.1:
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 [[IDX]], [[LEN]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp sge i8 [[LEN]], 0
; CHECK-NEXT:    [[C_1:%.*]] = icmp sge i8 [[LEN]], 2
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[LEN]], 2
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[T_1]], true
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_1]]
; CHECK-NEXT:    [[RES_3:%.*]] = xor i1 [[RES_2]], [[C_2]]
; CHECK-NEXT:    ret i1 [[RES_3]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %idx.slt.len  = icmp slt i8 %idx, %len
  %idx.pos = icmp sge i8 %idx, 0
  %and.1 = and i1 %idx.slt.len, %idx.pos
  br i1 %and.1, label %then.1, label %else

then.1:
  %t.1 = icmp ult i8 %idx, %len
  %t.2 = icmp sge i8 %len, 0
  %c.1 = icmp sge i8 %len, 2
  %c.2 = icmp sge i8 %len, 2
  %res.1 = xor i1 %t.1, %t.2
  %res.2 = xor i1 %res.1, %c.1
  %res.3 = xor i1 %res.2, %c.2
  ret i1 %res.3

else:
  ret i1 0
}

define i1 @len_not_known_positive1(i8 %len, i8 %idx) {
; CHECK-LABEL: @len_not_known_positive1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX_SLT_LEN:%.*]] = icmp slt i8 [[IDX:%.*]], [[LEN:%.*]]
; CHECK-NEXT:    br i1 [[IDX_SLT_LEN]], label [[THEN_1:%.*]], label [[ELSE:%.*]]
; CHECK:       then.1:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[IDX]], [[LEN]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[LEN]], 0
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i8 [[LEN]], 2
; CHECK-NEXT:    [[C_4:%.*]] = icmp sge i8 [[LEN]], 2
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], [[C_2]]
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_3]]
; CHECK-NEXT:    [[RES_3:%.*]] = xor i1 [[RES_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[RES_3]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %idx.slt.len  = icmp slt i8 %idx, %len
  br i1 %idx.slt.len, label %then.1, label %else

then.1:
  %c.1 = icmp ult i8 %idx, %len
  %c.2 = icmp sge i8 %len, 0
  %c.3 = icmp sge i8 %len, 2
  %c.4 = icmp sge i8 %len, 2
  %res.1 = xor i1 %c.1, %c.2
  %res.2 = xor i1 %res.1, %c.3
  %res.3 = xor i1 %res.2, %c.4
  ret i1 %res.3

else:
  ret i1 0
}

define i1 @len_not_known_positive2(i8 %len, i8 %idx) {
; CHECK-LABEL: @len_not_known_positive2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX_SLT_LEN:%.*]] = icmp slt i8 [[IDX:%.*]], [[LEN:%.*]]
; CHECK-NEXT:    [[IDX_POS:%.*]] = icmp uge i8 [[IDX]], 0
; CHECK-NEXT:    [[AND_1:%.*]] = and i1 [[IDX_SLT_LEN]], [[IDX_POS]]
; CHECK-NEXT:    br i1 [[AND_1]], label [[THEN_1:%.*]], label [[ELSE:%.*]]
; CHECK:       then.1:
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 [[IDX]], [[LEN]]
; CHECK-NEXT:    [[C_2:%.*]] = icmp sge i8 [[LEN]], 0
; CHECK-NEXT:    [[C_3:%.*]] = icmp sge i8 [[LEN]], 2
; CHECK-NEXT:    [[C_4:%.*]] = icmp sge i8 [[LEN]], 2
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[C_1]], [[C_2]]
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_3]]
; CHECK-NEXT:    [[RES_3:%.*]] = xor i1 [[RES_2]], [[C_4]]
; CHECK-NEXT:    ret i1 [[RES_3]]
; CHECK:       else:
; CHECK-NEXT:    ret i1 false
;
entry:
  %idx.slt.len  = icmp slt i8 %idx, %len
  %idx.pos = icmp uge i8 %idx, 0
  %and.1 = and i1 %idx.slt.len, %idx.pos
  br i1 %and.1, label %then.1, label %else

then.1:
  %c.1 = icmp ult i8 %idx, %len
  %c.2 = icmp sge i8 %len, 0
  %c.3 = icmp sge i8 %len, 2
  %c.4 = icmp sge i8 %len, 2
  %res.1 = xor i1 %c.1, %c.2
  %res.2 = xor i1 %res.1, %c.3
  %res.3 = xor i1 %res.2, %c.4
  ret i1 %res.3

else:
  ret i1 0
}

declare void @sink(ptr)
declare void @llvm.assume(i1)

define i1 @cnt_positive_sgt_against_base(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_positive_sgt_against_base(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[CNT:%.*]], -1
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i32 [[CNT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp uge ptr [[ADD_PTR]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sgt i32 %cnt, -1
  tail call void @llvm.assume(i1 %cmp)
  %add.ptr = getelementptr inbounds i32, ptr %p, i32 %cnt
  %cmp.1 = icmp uge ptr %add.ptr, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  ret i1 1
}

define i1 @cnt_not_known_positive_sgt_against_base(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_not_known_positive_sgt_against_base(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[CNT:%.*]], -2
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i32 [[CNT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp uge ptr [[ADD_PTR]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sgt i32 %cnt, -2
  tail call void @llvm.assume(i1 %cmp)
  %add.ptr = getelementptr inbounds i32, ptr %p, i32 %cnt
  %cmp.1 = icmp uge ptr %add.ptr, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  ret i1 1
}

define i1 @cnt_not_known_positive_uge_against_base(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_not_known_positive_uge_against_base(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp ugt i32 [[CNT:%.*]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i32 [[CNT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp uge ptr [[ADD_PTR]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp ugt i32 %cnt, 0
  tail call void @llvm.assume(i1 %cmp)
  %add.ptr = getelementptr inbounds i32, ptr %p, i32 %cnt
  %cmp.1 = icmp uge ptr %add.ptr, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  ret i1 1
}

define i1 @cnt_positive_sgt_against_base_with_zext(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_positive_sgt_against_base_with_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[CNT:%.*]], -1
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[CNT]] to i64
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 [[EXT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp uge ptr [[ADD_PTR]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sgt i32 %cnt, -1
  tail call void @llvm.assume(i1 %cmp)
  %ext = zext i32 %cnt to i64
  %add.ptr = getelementptr inbounds i32, ptr %p, i64 %ext
  %cmp.1 = icmp uge ptr %add.ptr, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  ret i1 1
}

define i1 @cnt_positive_sge_against_base_with_zext(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_positive_sge_against_base_with_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[CNT:%.*]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[CNT]] to i64
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 [[EXT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp uge ptr [[ADD_PTR]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sge i32 %cnt, 0
  tail call void @llvm.assume(i1 %cmp)
  %ext = zext i32 %cnt to i64
  %add.ptr = getelementptr inbounds i32, ptr %p, i64 %ext
  %cmp.1 = icmp uge ptr %add.ptr, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  ret i1 1
}

; TODO: Even though %cnt is not known signed positive %cmp can be simplified
; because %add.ptr uses it zero-extended.
define i1 @cnt_not_known_positive_sgt_against_base_with_zext(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_not_known_positive_sgt_against_base_with_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[CNT:%.*]], -2
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[CNT]] to i64
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 [[EXT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp uge ptr [[ADD_PTR]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sgt i32 %cnt, -2
  tail call void @llvm.assume(i1 %cmp)
  %ext = zext i32 %cnt to i64
  %add.ptr = getelementptr inbounds i32, ptr %p, i64 %ext
  %cmp.1 = icmp uge ptr %add.ptr, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  ret i1 1
}

; TODO: Even though %cnt is not known signed positive %cmp can be simplified
; because %add.ptr uses it zero-extended.
define i1 @cnt_not_known_positive_sge_against_base_with_zext(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_not_known_positive_sge_against_base_with_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[CNT:%.*]], -1
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[CNT]] to i64
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i64 [[EXT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp uge ptr [[ADD_PTR]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sge i32 %cnt, -1
  tail call void @llvm.assume(i1 %cmp)
  %ext = zext i32 %cnt to i64
  %add.ptr = getelementptr inbounds i32, ptr %p, i64 %ext
  %cmp.1 = icmp uge ptr %add.ptr, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  ret i1 1
}

; TODO: Even though %cnt is not known signed positive %cmp can be simplified
; because %add.ptr uses it zero-extended.
define i1 @cnt_not_signed_positive_uge_against_base_with_zext(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_not_signed_positive_uge_against_base_with_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp uge i32 [[CNT:%.*]], 0
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, ptr [[P:%.*]], i32 [[CNT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp uge ptr [[ADD_PTR]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp uge i32 %cnt, 0
  tail call void @llvm.assume(i1 %cmp)
  %add.ptr = getelementptr inbounds i32, ptr %p, i32 %cnt
  %cmp.1 = icmp uge ptr %add.ptr, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  ret i1 1
}

%t = type { i32, [10 x i32] }

define i1 @cnt_positive_from_assume_check_against_base_struct_ugt_with_zext(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_positive_from_assume_check_against_base_struct_ugt_with_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[CNT:%.*]], -1
; CHECK-NEXT:    tail call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[CNT]] to i64
; CHECK-NEXT:    [[GEP_EXT:%.*]] = getelementptr inbounds [[T:%.*]], ptr [[P:%.*]], i64 0, i32 1, i64 [[EXT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp ugt ptr [[GEP_EXT]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    tail call void @sink(ptr nonnull [[P]])
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sgt i32 %cnt, -1
  tail call void @llvm.assume(i1 %cmp)
  %ext = zext i32 %cnt to i64
  %gep.ext = getelementptr inbounds %t, ptr %p, i64 0, i32 1, i64 %ext
  %cmp.1 = icmp ugt ptr %gep.ext, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  tail call void @sink(ptr nonnull %p)
  ret i1 1
}

define i1 @cnt_positive_from_branch_check_against_base_struct_ugt_with_zext(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_positive_from_branch_check_against_base_struct_ugt_with_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[CNT:%.*]], -1
; CHECK-NEXT:    br i1 [[CMP]], label [[CHECK:%.*]], label [[ELSE:%.*]]
; CHECK:       check:
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[CNT]] to i64
; CHECK-NEXT:    [[GEP_EXT:%.*]] = getelementptr inbounds [[T:%.*]], ptr [[P:%.*]], i64 0, i32 1, i64 [[EXT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp ugt ptr [[GEP_EXT]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    tail call void @sink(ptr nonnull [[P]])
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sgt i32 %cnt, -1
  br i1 %cmp, label %check, label %else

check:
  %ext = zext i32 %cnt to i64
  %gep.ext = getelementptr inbounds %t, ptr %p, i64 0, i32 1, i64 %ext
  %cmp.1 = icmp ugt ptr %gep.ext, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  tail call void @sink(ptr nonnull %p)
  ret i1 1
}

; TODO: Even though %cnt is not known signed positive %cmp can be simplified
; because %add.ptr uses it zero-extended.
define i1 @cnt_not_known_positive_from_branch_check_against_base_struct_ugt_with_zext(ptr %p, i32 %cnt) {
; CHECK-LABEL: @cnt_not_known_positive_from_branch_check_against_base_struct_ugt_with_zext(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i32 [[CNT:%.*]], -2
; CHECK-NEXT:    br i1 [[CMP]], label [[CHECK:%.*]], label [[ELSE:%.*]]
; CHECK:       check:
; CHECK-NEXT:    [[EXT:%.*]] = zext i32 [[CNT]] to i64
; CHECK-NEXT:    [[GEP_EXT:%.*]] = getelementptr inbounds [[T:%.*]], ptr [[P:%.*]], i64 0, i32 1, i64 [[EXT]]
; CHECK-NEXT:    [[CMP_1:%.*]] = icmp ugt ptr [[GEP_EXT]], [[P]]
; CHECK-NEXT:    br i1 [[CMP_1]], label [[THEN:%.*]], label [[ELSE]]
; CHECK:       then:
; CHECK-NEXT:    ret i1 false
; CHECK:       else:
; CHECK-NEXT:    tail call void @sink(ptr nonnull [[P]])
; CHECK-NEXT:    ret i1 true
;
entry:
  %cmp = icmp sgt i32 %cnt, -2
  br i1 %cmp, label %check, label %else

check:
  %ext = zext i32 %cnt to i64
  %gep.ext = getelementptr inbounds %t, ptr %p, i64 0, i32 1, i64 %ext
  %cmp.1 = icmp ugt ptr %gep.ext, %p
  br i1 %cmp.1, label %then, label %else

then:
  ret i1 0

else:
  tail call void @sink(ptr nonnull %p)
  ret i1 1
}

define i1 @sge_2(i8 %idx) {
; CHECK-LABEL: @sge_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i8 [[IDX:%.*]], 2
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i8 [[IDX]], 2
; CHECK-NEXT:    [[T_2:%.*]] = icmp uge i8 [[IDX]], 1
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[T_1]], [[T_2]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp uge i8 [[IDX]], 3
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_1]]
; CHECK-NEXT:    [[F_1:%.*]] = icmp ult i8 [[IDX]], 2
; CHECK-NEXT:    [[RES_3:%.*]] = xor i1 [[RES_2]], [[F_1]]
; CHECK-NEXT:    ret i1 [[RES_3]]
;
entry:
  %cmp = icmp sge i8 %idx, 2
  call void @llvm.assume(i1 %cmp)
  %t.1 = icmp uge i8 %idx, 2
  %t.2 = icmp uge i8 %idx, 1
  %res.1 = xor i1 %t.1, %t.2
  %c.1 = icmp uge i8 %idx, 3
  %res.2 = xor i1 %res.1, %c.1
  %f.1 = icmp ult i8 %idx, 2
  %res.3 = xor i1 %res.2, %f.1
  ret i1 %res.3
}

define i32 @sge_2_gep(i32 %idx, ptr %src, i32 %idx.2) {
; CHECK-LABEL: @sge_2_gep(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[IDX_EXT:%.*]] = sext i32 [[IDX:%.*]] to i64
; CHECK-NEXT:    [[ADD_PTR:%.*]] = getelementptr inbounds i32, ptr [[SRC:%.*]], i64 [[IDX_EXT]]
; CHECK-NEXT:    [[CMP:%.*]] = icmp sge i32 [[IDX]], 2
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[ADD_PTR_2:%.*]] = getelementptr inbounds i32, ptr [[SRC]], i32 [[IDX_2:%.*]]
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult ptr [[SRC]], [[ADD_PTR]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult ptr [[SRC]], [[ADD_PTR_2]]
; CHECK-NEXT:    [[X_1:%.*]] = xor i1 [[T_1]], [[C_1]]
; CHECK-NEXT:    [[F_1:%.*]] = icmp uge ptr [[SRC]], [[ADD_PTR]]
; CHECK-NEXT:    [[X_2:%.*]] = xor i1 [[X_1]], [[F_1]]
; CHECK-NEXT:    br i1 [[X_2]], label [[THEN:%.*]], label [[ELSE:%.*]]
; CHECK:       then:
; CHECK-NEXT:    ret i32 0
; CHECK:       else:
; CHECK-NEXT:    ret i32 10
;
entry:
  %idx.ext = sext i32 %idx to i64
  %add.ptr = getelementptr inbounds i32, ptr %src, i64 %idx.ext
  %cmp = icmp sge i32 %idx, 2
  call void @llvm.assume(i1 %cmp)
  %add.ptr.2 = getelementptr inbounds i32, ptr %src, i32 %idx.2
  %t.1 = icmp ult ptr %src, %add.ptr
  %c.1 = icmp ult ptr %src, %add.ptr.2
  %x.1 = xor i1 %t.1, %c.1
  %f.1 = icmp uge ptr %src, %add.ptr
  %x.2 = xor i1 %x.1, %f.1
  br i1 %x.2, label %then, label %else

then:
  ret i32 0

else:
  ret i32 10
}

define i1 @sgt_known_neg(i8 %idx) {
; CHECK-LABEL: @sgt_known_neg(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[IDX:%.*]], -1
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[T_1:%.*]] = icmp uge i8 [[IDX]], 0
; CHECK-NEXT:    [[T_2:%.*]] = icmp uge i8 [[IDX]], 1
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[T_1]], [[T_2]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ugt i8 [[IDX]], -1
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_1]]
; CHECK-NEXT:    ret i1 [[RES_2]]
;
entry:
  %cmp = icmp sgt i8 %idx, -1
  call void @llvm.assume(i1 %cmp)
  %t.1 = icmp uge i8 %idx, 0
  %t.2 = icmp uge i8 %idx, 1
  %res.1 = xor i1 %t.1, %t.2
  %c.1 = icmp ugt i8 %idx, -1
  %res.2 = xor i1 %res.1, %c.1
  ret i1 %res.2
}

define i1 @sgt_known_pos(i8 %idx) {
; CHECK-LABEL: @sgt_known_pos(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp sgt i8 [[IDX:%.*]], 2
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[T_1:%.*]] = icmp ugt i8 [[IDX]], 2
; CHECK-NEXT:    [[T_2:%.*]] = icmp ugt i8 [[IDX]], 1
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[T_1]], [[T_2]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ugt i8 [[IDX]], 3
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_1]]
; CHECK-NEXT:    ret i1 [[RES_2]]
;
entry:
  %cmp = icmp sgt i8 %idx, 2
  call void @llvm.assume(i1 %cmp)
  %t.1 = icmp ugt i8 %idx, 2
  %t.2 = icmp ugt i8 %idx, 1
  %res.1 = xor i1 %t.1, %t.2
  %c.1 = icmp ugt i8 %idx, 3
  %res.2 = xor i1 %res.1, %c.1
  ret i1 %res.2
}

define i1 @slt_first_op_known_pos(i8 %idx) {
; CHECK-LABEL: @slt_first_op_known_pos(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 2, [[IDX:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 2, [[IDX]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp ult i8 1, [[IDX]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[T_1]], [[T_2]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 3, [[IDX]]
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_1]]
; CHECK-NEXT:    ret i1 [[RES_2]]
;
entry:
  %cmp = icmp slt i8 2, %idx
  call void @llvm.assume(i1 %cmp)
  %t.1 = icmp ult i8 2, %idx
  %t.2 = icmp ult i8 1, %idx
  %res.1 = xor i1 %t.1, %t.2
  %c.1 = icmp ult i8 3, %idx
  %res.2 = xor i1 %res.1, %c.1
  ret i1 %res.2
}

define i1 @slt_first_op_known_neg(i8 %idx) {
; CHECK-LABEL: @slt_first_op_known_neg(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i8 -2, [[IDX:%.*]]
; CHECK-NEXT:    call void @llvm.assume(i1 [[CMP]])
; CHECK-NEXT:    [[T_1:%.*]] = icmp ult i8 2, [[IDX]]
; CHECK-NEXT:    [[T_2:%.*]] = icmp ult i8 1, [[IDX]]
; CHECK-NEXT:    [[RES_1:%.*]] = xor i1 [[T_1]], [[T_2]]
; CHECK-NEXT:    [[C_1:%.*]] = icmp ult i8 3, [[IDX]]
; CHECK-NEXT:    [[RES_2:%.*]] = xor i1 [[RES_1]], [[C_1]]
; CHECK-NEXT:    ret i1 [[RES_2]]
;
entry:
  %cmp = icmp slt i8 -2, %idx
  call void @llvm.assume(i1 %cmp)
  %t.1 = icmp ult i8 2, %idx
  %t.2 = icmp ult i8 1, %idx
  %res.1 = xor i1 %t.1, %t.2
  %c.1 = icmp ult i8 3, %idx
  %res.2 = xor i1 %res.1, %c.1
  ret i1 %res.2
}
