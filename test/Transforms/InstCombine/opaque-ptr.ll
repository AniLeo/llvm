; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -instcombine -opaque-pointers < %s | FileCheck %s

define ptr @bitcast_opaque_to_opaque(ptr %a) {
; CHECK-LABEL: @bitcast_opaque_to_opaque(
; CHECK-NEXT:    ret ptr [[A:%.*]]
;
  %b = bitcast ptr %a to ptr
  ret ptr %b
}

define ptr @bitcast_typed_to_opaque(i8* %a) {
; CHECK-LABEL: @bitcast_typed_to_opaque(
; CHECK-NEXT:    ret ptr [[A:%.*]]
;
  %b = bitcast i8* %a to ptr
  ret ptr %b
}

define i8* @bitcast_opaque_to_typed(ptr %a) {
; CHECK-LABEL: @bitcast_opaque_to_typed(
; CHECK-NEXT:    ret ptr [[A:%.*]]
;
  %b = bitcast ptr %a to i8*
  ret i8* %b
}

@g = global i8 0
define ptr @bitcast_typed_to_opaque_constexpr() {
; CHECK-LABEL: @bitcast_typed_to_opaque_constexpr(
; CHECK-NEXT:    ret ptr @g
;
  ret ptr bitcast (i8* @g to ptr)
}

define ptr @addrspacecast_opaque_to_opaque(ptr addrspace(1) %a) {
; CHECK-LABEL: @addrspacecast_opaque_to_opaque(
; CHECK-NEXT:    [[B:%.*]] = addrspacecast ptr addrspace(1) [[A:%.*]] to ptr
; CHECK-NEXT:    ret ptr [[B]]
;
  %b = addrspacecast ptr addrspace(1) %a to ptr
  ret ptr %b
}

define ptr @addrspacecast_typed_to_opaque(i8 addrspace(1)* %a) {
; CHECK-LABEL: @addrspacecast_typed_to_opaque(
; CHECK-NEXT:    [[B:%.*]] = addrspacecast ptr addrspace(1) [[A:%.*]] to ptr
; CHECK-NEXT:    ret ptr [[B]]
;
  %b = addrspacecast i8 addrspace(1)* %a to ptr
  ret ptr %b
}

define i8* @addrspacecast_opaque_to_typed(ptr addrspace(1) %a) {
; CHECK-LABEL: @addrspacecast_opaque_to_typed(
; CHECK-NEXT:    [[B:%.*]] = addrspacecast ptr addrspace(1) [[A:%.*]] to ptr
; CHECK-NEXT:    ret ptr [[B]]
;
  %b = addrspacecast ptr addrspace(1) %a to i8*
  ret i8* %b
}

define ptr addrspace(1) @bitcast_and_addrspacecast_eliminable(ptr %a) {
; CHECK-LABEL: @bitcast_and_addrspacecast_eliminable(
; CHECK-NEXT:    [[C:%.*]] = addrspacecast ptr [[A:%.*]] to ptr addrspace(1)
; CHECK-NEXT:    ret ptr addrspace(1) [[C]]
;
  %b = bitcast ptr %a to i8*
  %c = addrspacecast i8* %b to ptr addrspace(1)
  ret ptr addrspace(1) %c
}

define ptr addrspace(1) @addrspacecast_typed_to_opaque_constexpr() {
; CHECK-LABEL: @addrspacecast_typed_to_opaque_constexpr(
; CHECK-NEXT:    ret ptr addrspace(1) addrspacecast (ptr @g to ptr addrspace(1))
;
  ret ptr addrspace(1) addrspacecast (i8* @g to ptr addrspace(1))
}

define ptr @gep_constexpr_1(ptr %a) {
; CHECK-LABEL: @gep_constexpr_1(
; CHECK-NEXT:    ret ptr inttoptr (i64 6 to ptr)
;
  ret ptr getelementptr (i16, ptr null, i32 3)
}

define ptr @gep_constexpr_2(ptr %a) {
; CHECK-LABEL: @gep_constexpr_2(
; CHECK-NEXT:    ret ptr getelementptr (i8, ptr @g, i64 3)
;
  ret ptr getelementptr (i8, ptr bitcast (i8* @g to ptr), i32 3)
}

define ptr addrspace(1) @gep_constexpr_3(ptr %a) {
; CHECK-LABEL: @gep_constexpr_3(
; CHECK-NEXT:    ret ptr addrspace(1) getelementptr (i8, ptr addrspace(1) addrspacecast (ptr @g to ptr addrspace(1)), i64 3)
;
  ret ptr addrspace(1) getelementptr ([0 x i8], ptr addrspace(1) addrspacecast (i8* @g to ptr addrspace(1)), i64 0, i32 3)
}

define ptr @load_bitcast_1(ptr %a) {
; CHECK-LABEL: @load_bitcast_1(
; CHECK-NEXT:    [[B1:%.*]] = load ptr, ptr [[A:%.*]], align 8
; CHECK-NEXT:    ret ptr [[B1]]
;
  %b = load i8*, ptr %a
  %c = bitcast i8* %b to ptr
  ret ptr %c
}

define ptr @load_bitcast_2(ptr %a) {
; CHECK-LABEL: @load_bitcast_2(
; CHECK-NEXT:    [[C1:%.*]] = load ptr, ptr [[A:%.*]], align 8
; CHECK-NEXT:    ret ptr [[C1]]
;
  %b = bitcast ptr %a to i8**
  %c = load i8*, i8** %b
  %d = bitcast i8* %c to ptr
  ret ptr %d
}

define void @call(ptr %a) {
; CHECK-LABEL: @call(
; CHECK-NEXT:    call void [[A:%.*]]()
; CHECK-NEXT:    ret void
;
  call void %a()
  ret void
}

declare void @varargs(...)
define void @varargs_cast_typed_to_opaque_same_type(i32* %a) {
; CHECK-LABEL: @varargs_cast_typed_to_opaque_same_type(
; CHECK-NEXT:    call void (...) @varargs(ptr byval(i32) [[A:%.*]])
; CHECK-NEXT:    ret void
;
  %b = bitcast i32* %a to ptr
  call void (...) @varargs(ptr byval(i32) %b)
  ret void
}

define void @varargs_cast_typed_to_opaque_different_type(i32* %a) {
; CHECK-LABEL: @varargs_cast_typed_to_opaque_different_type(
; CHECK-NEXT:    call void (...) @varargs(ptr byval(float) [[A:%.*]])
; CHECK-NEXT:    ret void
;
  %b = bitcast i32* %a to ptr
  call void (...) @varargs(ptr byval(float) %b)
  ret void
}

define void @varargs_cast_typed_to_opaque_different_size(i32* %a) {
; CHECK-LABEL: @varargs_cast_typed_to_opaque_different_size(
; CHECK-NEXT:    call void (...) @varargs(ptr byval(i64) [[A:%.*]])
; CHECK-NEXT:    ret void
;
  %b = bitcast i32* %a to ptr
  call void (...) @varargs(ptr byval(i64) %b)
  ret void
}

define void @varargs_cast_opaque_to_typed(ptr %a) {
; CHECK-LABEL: @varargs_cast_opaque_to_typed(
; CHECK-NEXT:    call void (...) @varargs(ptr byval(i8) [[A:%.*]])
; CHECK-NEXT:    ret void
;
  %b = bitcast ptr %a to i8*
  call void (...) @varargs(i8* byval(i8) %b)
  ret void
}

define ptr @geps_combinable(ptr %a) {
; CHECK-LABEL: @geps_combinable(
; CHECK-NEXT:    [[A3:%.*]] = getelementptr { i32, { i32, i32 } }, ptr [[A:%.*]], i64 0, i32 1, i32 1
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr { i32, { i32, i32 } }, ptr %a, i32 0, i32 1
  %a3 = getelementptr { i32, i32 }, ptr %a2, i32 0, i32 1
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type1(ptr %a) {
; CHECK-LABEL: @geps_combinable_different_elem_type1(
; CHECK-NEXT:    [[A3:%.*]] = getelementptr { i32, i32 }, ptr [[A:%.*]], i64 1
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr { i32, i32 }, ptr %a, i32 0, i32 1
  %a3 = getelementptr { i32, i32 }, ptr %a2, i32 0, i32 1
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type2(ptr %a) {
; CHECK-LABEL: @geps_combinable_different_elem_type2(
; CHECK-NEXT:    [[A3:%.*]] = getelementptr { i32, i32 }, ptr [[A:%.*]], i64 1
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr { i32, i32 }, ptr %a, i32 0, i32 1
  %a3 = getelementptr i8, ptr %a2, i64 4
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type3(ptr %a) {
; CHECK-LABEL: @geps_combinable_different_elem_type3(
; CHECK-NEXT:    [[A3:%.*]] = getelementptr { i32, i32 }, ptr [[A:%.*]], i64 1, i32 1
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr { i32, i32 }, ptr %a, i32 0, i32 1
  %a3 = getelementptr i8, ptr %a2, i64 8
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type4(ptr %a) {
; CHECK-LABEL: @geps_combinable_different_elem_type4(
; CHECK-NEXT:    [[A2:%.*]] = getelementptr { i32, i32 }, ptr [[A:%.*]], i64 0, i32 1
; CHECK-NEXT:    [[A3:%.*]] = getelementptr i8, ptr [[A2]], i64 10
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr { i32, i32 }, ptr %a, i32 0, i32 1
  %a3 = getelementptr i8, ptr %a2, i64 10
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type5(ptr %a) {
; CHECK-LABEL: @geps_combinable_different_elem_type5(
; CHECK-NEXT:    ret ptr [[A:%.*]]
;
  %a2 = getelementptr { i32, i32 }, ptr %a, i32 0, i32 1
  %a3 = getelementptr i8, ptr %a2, i64 -4
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type6(ptr %a, i64 %idx) {
; CHECK-LABEL: @geps_combinable_different_elem_type6(
; CHECK-NEXT:    [[A3:%.*]] = getelementptr { i32, i32 }, ptr [[A:%.*]], i64 [[IDX:%.*]], i32 1
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr { i32, i32 }, ptr %a, i64 %idx
  %a3 = getelementptr i8, ptr %a2, i64 4
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type7(ptr %a, i64 %idx) {
; CHECK-LABEL: @geps_combinable_different_elem_type7(
; CHECK-NEXT:    [[A2:%.*]] = getelementptr { i32, i32 }, ptr [[A:%.*]], i64 [[IDX:%.*]], i32 1
; CHECK-NEXT:    [[A3:%.*]] = getelementptr i8, ptr [[A2]], i64 4
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr { i32, i32 }, ptr %a, i64 %idx, i32 1
  %a3 = getelementptr i8, ptr %a2, i64 4
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type8(ptr %a, i64 %idx) {
; CHECK-LABEL: @geps_combinable_different_elem_type8(
; CHECK-NEXT:    [[A2:%.*]] = getelementptr inbounds { { i32, i32 } }, ptr [[A:%.*]], i64 [[IDX:%.*]], i32 0, i32 1
; CHECK-NEXT:    [[A3:%.*]] = getelementptr inbounds i8, ptr [[A2]], i64 4
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr inbounds { { i32, i32 } }, ptr %a, i64 %idx, i32 0, i32 1
  %a3 = getelementptr inbounds i8, ptr %a2, i32 4
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type9(ptr %a, i64 %idx) {
; CHECK-LABEL: @geps_combinable_different_elem_type9(
; CHECK-NEXT:    [[A3:%.*]] = getelementptr inbounds { { i32, i32 } }, ptr [[A:%.*]], i64 [[IDX:%.*]]
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr inbounds { { i32, i32 } }, ptr %a, i64 %idx, i32 0, i32 1
  %a3 = getelementptr inbounds i8, ptr %a2, i32 -4
  ret ptr %a3
}

declare void @use(ptr)

define ptr @geps_combinable_different_elem_type_extra_use1(ptr %a) {
; CHECK-LABEL: @geps_combinable_different_elem_type_extra_use1(
; CHECK-NEXT:    [[A2:%.*]] = getelementptr { i32, i32 }, ptr [[A:%.*]], i64 0, i32 1
; CHECK-NEXT:    call void @use(ptr [[A2]])
; CHECK-NEXT:    [[A3:%.*]] = getelementptr { i32, i32 }, ptr [[A]], i64 1
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr { i32, i32 }, ptr %a, i32 0, i32 1
  call void @use(ptr %a2)
  %a3 = getelementptr i8, ptr %a2, i64 4
  ret ptr %a3
}

define ptr @geps_combinable_different_elem_type_extra_use2(ptr %a, i64 %idx) {
; CHECK-LABEL: @geps_combinable_different_elem_type_extra_use2(
; CHECK-NEXT:    [[A2:%.*]] = getelementptr { i32, i32 }, ptr [[A:%.*]], i64 [[IDX:%.*]]
; CHECK-NEXT:    call void @use(ptr [[A2]])
; CHECK-NEXT:    [[A3:%.*]] = getelementptr i8, ptr [[A2]], i64 4
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr { i32, i32 }, ptr %a, i64 %idx
  call void @use(ptr %a2)
  %a3 = getelementptr i8, ptr %a2, i64 4
  ret ptr %a3
}

define ptr @geps_combinable_scalable(ptr %a, i64 %idx) {
; CHECK-LABEL: @geps_combinable_scalable(
; CHECK-NEXT:    [[A2:%.*]] = getelementptr inbounds <vscale x 2 x i32>, ptr [[A:%.*]], i64 1
; CHECK-NEXT:    [[A3:%.*]] = getelementptr inbounds i8, ptr [[A2]], i64 4
; CHECK-NEXT:    ret ptr [[A3]]
;
  %a2 = getelementptr inbounds <vscale x 2 x i32>, ptr %a, i64 1
  %a3 = getelementptr inbounds i8, ptr %a2, i32 4
  ret ptr %a3
}

define i1 @compare_geps_same_indices(ptr %a, ptr %b, i64 %idx) {
; CHECK-LABEL: @compare_geps_same_indices(
; CHECK-NEXT:    [[C:%.*]] = icmp eq ptr [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %a2 = getelementptr i32, ptr %a, i64 %idx
  %b2 = getelementptr i32, ptr %b, i64 %idx
  %c = icmp eq ptr %a2, %b2
  ret i1 %c
}

define i1 @compare_geps_same_indices_different_types(ptr %a, ptr %b, i64 %idx) {
; CHECK-LABEL: @compare_geps_same_indices_different_types(
; CHECK-NEXT:    [[A2:%.*]] = getelementptr i32, ptr [[A:%.*]], i64 [[IDX:%.*]]
; CHECK-NEXT:    [[B2:%.*]] = getelementptr i64, ptr [[B:%.*]], i64 [[IDX]]
; CHECK-NEXT:    [[C:%.*]] = icmp eq ptr [[A2]], [[B2]]
; CHECK-NEXT:    ret i1 [[C]]
;
  %a2 = getelementptr i32, ptr %a, i64 %idx
  %b2 = getelementptr i64, ptr %b, i64 %idx
  %c = icmp eq ptr %a2, %b2
  ret i1 %c
}

define <4 x i1> @compare_geps_same_indices_scalar_vector_base_mismatch(ptr %ptr, <4 x ptr> %ptrs) {
; CHECK-LABEL: @compare_geps_same_indices_scalar_vector_base_mismatch(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i16, <4 x ptr> [[PTRS:%.*]], <4 x i64> <i64 1, i64 2, i64 3, i64 4>
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i16, ptr [[PTR:%.*]], <4 x i64> <i64 1, i64 2, i64 3, i64 4>
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq <4 x ptr> [[GEP1]], [[GEP2]]
; CHECK-NEXT:    ret <4 x i1> [[CMP]]
;
  %gep1 = getelementptr i16, <4 x ptr> %ptrs, <4 x i64> <i64 1, i64 2, i64 3, i64 4>
  %gep2 = getelementptr i16, ptr %ptr, <4 x i64> <i64 1, i64 2, i64 3, i64 4>
  %cmp = icmp eq <4 x ptr> %gep1, %gep2
  ret <4 x i1> %cmp
}

define ptr @indexed_compare(ptr %A, i64 %offset) {
; CHECK-LABEL: @indexed_compare(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[RHS_IDX:%.*]] = phi i64 [ [[RHS_ADD:%.*]], [[BB]] ], [ [[OFFSET:%.*]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[RHS_ADD]] = add nsw i64 [[RHS_IDX]], 1
; CHECK-NEXT:    [[COND:%.*]] = icmp sgt i64 [[RHS_IDX]], 100
; CHECK-NEXT:    br i1 [[COND]], label [[BB2:%.*]], label [[BB]]
; CHECK:       bb2:
; CHECK-NEXT:    [[RHS_PTR:%.*]] = getelementptr inbounds i32, ptr [[A:%.*]], i64 [[RHS_IDX]]
; CHECK-NEXT:    ret ptr [[RHS_PTR]]
;
entry:
  %tmp = getelementptr inbounds i32, ptr %A, i64 %offset
  br label %bb

bb:
  %RHS = phi ptr [ %RHS.next, %bb ], [ %tmp, %entry ]
  %LHS = getelementptr inbounds i32, ptr %A, i32 100
  %RHS.next = getelementptr inbounds i32, ptr %RHS, i64 1
  %cond = icmp ult ptr %LHS, %RHS
  br i1 %cond, label %bb2, label %bb

bb2:
  ret ptr %RHS
}

define ptr @indexed_compare_different_types(ptr %A, i64 %offset) {
; CHECK-LABEL: @indexed_compare_different_types(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP:%.*]] = getelementptr inbounds i32, ptr [[A:%.*]], i64 [[OFFSET:%.*]]
; CHECK-NEXT:    br label [[BB:%.*]]
; CHECK:       bb:
; CHECK-NEXT:    [[RHS:%.*]] = phi ptr [ [[RHS_NEXT:%.*]], [[BB]] ], [ [[TMP]], [[ENTRY:%.*]] ]
; CHECK-NEXT:    [[LHS:%.*]] = getelementptr inbounds i64, ptr [[A]], i64 100
; CHECK-NEXT:    [[RHS_NEXT]] = getelementptr inbounds i32, ptr [[RHS]], i64 1
; CHECK-NEXT:    [[COND:%.*]] = icmp ult ptr [[LHS]], [[RHS]]
; CHECK-NEXT:    br i1 [[COND]], label [[BB2:%.*]], label [[BB]]
; CHECK:       bb2:
; CHECK-NEXT:    ret ptr [[RHS]]
;
entry:
  %tmp = getelementptr inbounds i32, ptr %A, i64 %offset
  br label %bb

bb:
  %RHS = phi ptr [ %RHS.next, %bb ], [ %tmp, %entry ]
  %LHS = getelementptr inbounds i64, ptr %A, i32 100
  %RHS.next = getelementptr inbounds i32, ptr %RHS, i64 1
  %cond = icmp ult ptr %LHS, %RHS
  br i1 %cond, label %bb2, label %bb

bb2:
  ret ptr %RHS
}

define ptr addrspace(1) @gep_of_addrspace_cast(ptr %ptr) {
; CHECK-LABEL: @gep_of_addrspace_cast(
; CHECK-NEXT:    [[CAST1:%.*]] = addrspacecast ptr [[PTR:%.*]] to ptr addrspace(1)
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr inbounds i32, ptr addrspace(1) [[CAST1]], i64 1
; CHECK-NEXT:    ret ptr addrspace(1) [[GEP]]
;
  %cast1 = addrspacecast ptr %ptr to ptr addrspace(1)
  %gep = getelementptr inbounds i32, ptr addrspace(1) %cast1, i64 1
  ret ptr addrspace(1) %gep
}

define i1 @cmp_gep_same_base_same_type(ptr %ptr, i64 %idx1, i64 %idx2) {
; CHECK-LABEL: @cmp_gep_same_base_same_type(
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[IDX1:%.*]], [[IDX2:%.*]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr inbounds i32, ptr %ptr, i64 %idx1
  %gep2 = getelementptr inbounds i32, ptr %ptr, i64 %idx2
  %cmp = icmp ult ptr %gep1, %gep2
  ret i1 %cmp
}

define i1 @cmp_gep_same_base_different_type(ptr %ptr, i64 %idx1, i64 %idx2) {
; CHECK-LABEL: @cmp_gep_same_base_different_type(
; CHECK-NEXT:    [[GEP1_IDX:%.*]] = shl nsw i64 [[IDX1:%.*]], 2
; CHECK-NEXT:    [[GEP2_IDX:%.*]] = shl nsw i64 [[IDX2:%.*]], 3
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i64 [[GEP1_IDX]], [[GEP2_IDX]]
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep1 = getelementptr inbounds i32, ptr %ptr, i64 %idx1
  %gep2 = getelementptr inbounds i64, ptr %ptr, i64 %idx2
  %cmp = icmp ult ptr %gep1, %gep2
  ret i1 %cmp
}

@ary = constant [4 x i8] [i8 1, i8 2, i8 3, i8 4]

define i1 @cmp_load_gep_global(i64 %idx) {
; CHECK-LABEL: @cmp_load_gep_global(
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i64 [[IDX:%.*]], 2
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep = getelementptr [4 x i8], ptr @ary, i64 0, i64 %idx
  %load = load i8, ptr %gep
  %cmp = icmp eq i8 %load, 3
  ret i1 %cmp
}

define i1 @cmp_load_gep_global_different_load_type(i64 %idx) {
; CHECK-LABEL: @cmp_load_gep_global_different_load_type(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [4 x i8], ptr @ary, i64 0, i64 [[IDX:%.*]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, ptr [[GEP]], align 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[LOAD]], 3
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep = getelementptr [4 x i8], ptr @ary, i64 0, i64 %idx
  %load = load i16, ptr %gep
  %cmp = icmp eq i16 %load, 3
  ret i1 %cmp
}

define i1 @cmp_load_gep_global_different_gep_type(i64 %idx) {
; CHECK-LABEL: @cmp_load_gep_global_different_gep_type(
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr [4 x i16], ptr @ary, i64 0, i64 [[IDX:%.*]]
; CHECK-NEXT:    [[LOAD:%.*]] = load i16, ptr [[GEP]], align 2
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i16 [[LOAD]], 3
; CHECK-NEXT:    ret i1 [[CMP]]
;
  %gep = getelementptr [4 x i16], ptr @ary, i64 0, i64 %idx
  %load = load i16, ptr %gep
  %cmp = icmp eq i16 %load, 3
  ret i1 %cmp
}

define ptr @phi_of_gep(i1 %c, ptr %p) {
; CHECK-LABEL: @phi_of_gep(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[JOIN:%.*]]
; CHECK:       else:
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    [[PHI:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    ret ptr [[PHI]]
;
  br i1 %c, label %if, label %else

if:
  %gep1 = getelementptr i32, ptr %p, i64 1
  br label %join

else:
  %gep2 = getelementptr i32, ptr %p, i64 1
  br label %join

join:
  %phi = phi ptr [ %gep1, %if ], [ %gep2, %else ]
  ret ptr %phi
}

define ptr @phi_of_gep_different_type(i1 %c, ptr %p) {
; CHECK-LABEL: @phi_of_gep_different_type(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    br label [[JOIN:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i64, ptr [[P]], i64 1
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    [[PHI:%.*]] = phi ptr [ [[GEP1]], [[IF]] ], [ [[GEP2]], [[ELSE]] ]
; CHECK-NEXT:    ret ptr [[PHI]]
;
  br i1 %c, label %if, label %else

if:
  %gep1 = getelementptr i32, ptr %p, i64 1
  br label %join

else:
  %gep2 = getelementptr i64, ptr %p, i64 1
  br label %join

join:
  %phi = phi ptr [ %gep1, %if ], [ %gep2, %else ]
  ret ptr %phi
}

define ptr @gep_of_phi_of_gep(i1 %c, ptr %p) {
; CHECK-LABEL: @gep_of_phi_of_gep(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    br label [[JOIN:%.*]]
; CHECK:       else:
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    [[TMP1:%.*]] = phi i64 [ 1, [[IF]] ], [ 2, [[ELSE]] ]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 [[TMP1]]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, ptr [[TMP2]], i64 1
; CHECK-NEXT:    ret ptr [[GEP]]
;
  br i1 %c, label %if, label %else

if:
  %gep1 = getelementptr i32, ptr %p, i64 1
  br label %join

else:
  %gep2 = getelementptr i32, ptr %p, i64 2
  br label %join

join:
  %phi = phi ptr [ %gep1, %if ], [ %gep2, %else ]
  %gep = getelementptr i32, ptr %phi, i64 1
  ret ptr %gep
}

define ptr @gep_of_phi_of_gep_different_type(i1 %c, ptr %p) {
; CHECK-LABEL: @gep_of_phi_of_gep_different_type(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[IF:%.*]], label [[ELSE:%.*]]
; CHECK:       if:
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    br label [[JOIN:%.*]]
; CHECK:       else:
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i64, ptr [[P]], i64 2
; CHECK-NEXT:    br label [[JOIN]]
; CHECK:       join:
; CHECK-NEXT:    [[PHI:%.*]] = phi ptr [ [[GEP1]], [[IF]] ], [ [[GEP2]], [[ELSE]] ]
; CHECK-NEXT:    [[GEP:%.*]] = getelementptr i32, ptr [[PHI]], i64 1
; CHECK-NEXT:    ret ptr [[GEP]]
;
  br i1 %c, label %if, label %else

if:
  %gep1 = getelementptr i32, ptr %p, i64 1
  br label %join

else:
  %gep2 = getelementptr i64, ptr %p, i64 2
  br label %join

join:
  %phi = phi ptr [ %gep1, %if ], [ %gep2, %else ]
  %gep = getelementptr i32, ptr %phi, i64 1
  ret ptr %gep
}

define ptr @select_of_gep(i1 %c, ptr %p) {
; CHECK-LABEL: @select_of_gep(
; CHECK-NEXT:    [[S_V:%.*]] = select i1 [[C:%.*]], i64 1, i64 2
; CHECK-NEXT:    [[S:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 [[S_V]]
; CHECK-NEXT:    ret ptr [[S]]
;
  %gep1 = getelementptr i32, ptr %p, i64 1
  %gep2 = getelementptr i32, ptr %p, i64 2
  %s = select i1 %c, ptr %gep1, ptr %gep2
  ret ptr %s
}

define ptr @select_of_gep_different_type(i1 %c, ptr %p) {
; CHECK-LABEL: @select_of_gep_different_type(
; CHECK-NEXT:    [[GEP1:%.*]] = getelementptr i32, ptr [[P:%.*]], i64 1
; CHECK-NEXT:    [[GEP2:%.*]] = getelementptr i64, ptr [[P]], i64 2
; CHECK-NEXT:    [[S:%.*]] = select i1 [[C:%.*]], ptr [[GEP1]], ptr [[GEP2]]
; CHECK-NEXT:    ret ptr [[S]]
;
  %gep1 = getelementptr i32, ptr %p, i64 1
  %gep2 = getelementptr i64, ptr %p, i64 2
  %s = select i1 %c, ptr %gep1, ptr %gep2
  ret ptr %s
}

define void @dse(ptr %p) {
; CHECK-LABEL: @dse(
; CHECK-NEXT:    store i32 0, ptr [[P:%.*]], align 4
; CHECK-NEXT:    store i8 1, ptr [[P]], align 1
; CHECK-NEXT:    ret void
;
  store i32 0, ptr %p
  store i8 1, ptr %p
  ret void
}

declare void @call_i64(i64)
declare void @call_byval(i64, ptr byval(i64))

define void @call_cast_ptr_to_int(ptr %p) {
; CHECK-LABEL: @call_cast_ptr_to_int(
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    call void @call_i64(i64 [[TMP1]])
; CHECK-NEXT:    ret void
;
  call void @call_i64(ptr %p)
  ret void
}

define void @call_cast_byval(ptr %p, ptr %p2) {
; CHECK-LABEL: @call_cast_byval(
; CHECK-NEXT:    [[TMP1:%.*]] = ptrtoint ptr [[P:%.*]] to i64
; CHECK-NEXT:    call void @call_byval(i64 [[TMP1]], ptr byval(double) [[P2:%.*]])
; CHECK-NEXT:    ret void
;
  call void @call_byval(ptr %p, ptr byval(double) %p2)
  ret void
}

declare float @fmodf(float, float)

define i32 @const_fold_call_with_func_type_mismatch() {
; CHECK-LABEL: @const_fold_call_with_func_type_mismatch(
; CHECK-NEXT:    [[V:%.*]] = call float @fmodf(float 0x40091EB860000000, float 2.000000e+00)
; CHECK-NEXT:    ret i32 1066527622
;
  %v = call i32 @fmodf(float 0x40091EB860000000, float 2.000000e+00)
  ret i32 %v
}
