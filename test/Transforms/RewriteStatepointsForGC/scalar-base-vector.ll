; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -rewrite-statepoints-for-gc -S | FileCheck  %s
; RUN: opt < %s -passes=rewrite-statepoints-for-gc -S | FileCheck  %s

declare void @do_safepoint()
declare i8 addrspace(1)* @def_ptr()

define i32 addrspace(1)* @test1(i8 addrspace(1)* %base1, <2 x i64> %offsets) gc "statepoint-example" {
; CHECK-LABEL: @test1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 undef, label [[FIRST:%.*]], label [[SECOND:%.*]]
; CHECK:       first:
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, i8 addrspace(1)* ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_p1i8f(i64 2882400000, i32 0, i8 addrspace(1)* ()* @def_ptr, i32 0, i32 0, i32 0, i32 0) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
; CHECK-NEXT:    [[BASE21:%.*]] = call i8 addrspace(1)* @llvm.experimental.gc.result.p1i8(token [[STATEPOINT_TOKEN]])
; CHECK-NEXT:    br label [[SECOND]]
; CHECK:       second:
; CHECK-NEXT:    [[PHI_BASE:%.*]] = phi i8 addrspace(1)* [ [[BASE1:%.*]], [[ENTRY:%.*]] ], [ [[BASE21]], [[FIRST]] ], !is_base_value !0
; CHECK-NEXT:    [[PHI:%.*]] = phi i8 addrspace(1)* [ [[BASE1]], [[ENTRY]] ], [ [[BASE21]], [[FIRST]] ]
; CHECK-NEXT:    [[BASE_I32:%.*]] = bitcast i8 addrspace(1)* [[PHI]] to i32 addrspace(1)*
; CHECK-NEXT:    [[CAST:%.*]] = bitcast i8 addrspace(1)* [[PHI_BASE]] to i32 addrspace(1)*
; CHECK-NEXT:    [[DOTSPLATINSERT_BASE:%.*]] = insertelement <2 x i32 addrspace(1)*> zeroinitializer, i32 addrspace(1)* [[CAST]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <2 x i32 addrspace(1)*> undef, i32 addrspace(1)* [[BASE_I32]], i32 0
; CHECK-NEXT:    [[DOTSPLAT_BASE:%.*]] = shufflevector <2 x i32 addrspace(1)*> [[DOTSPLATINSERT_BASE]], <2 x i32 addrspace(1)*> zeroinitializer, <2 x i32> zeroinitializer, !is_base_value !0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <2 x i32 addrspace(1)*> [[DOTSPLATINSERT]], <2 x i32 addrspace(1)*> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC:%.*]] = getelementptr i32, <2 x i32 addrspace(1)*> [[DOTSPLAT]], <2 x i64> [[OFFSETS:%.*]]
; CHECK-NEXT:    [[PTR_BASE:%.*]] = extractelement <2 x i32 addrspace(1)*> [[DOTSPLAT_BASE]], i32 1, !is_base_value !0
; CHECK-NEXT:    [[PTR:%.*]] = extractelement <2 x i32 addrspace(1)*> [[VEC]], i32 1
; CHECK-NEXT:    [[STATEPOINT_TOKEN2:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0, i32 addrspace(1)* [[PTR]], i32 addrspace(1)* [[PTR_BASE]]) [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
; CHECK-NEXT:    [[PTR_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN2]], i32 8, i32 7)
; CHECK-NEXT:    [[PTR_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[PTR_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN2]], i32 8, i32 8)
; CHECK-NEXT:    [[PTR_BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[PTR_BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    ret i32 addrspace(1)* [[PTR_RELOCATED_CASTED]]
;
entry:
  br i1 undef, label %first, label %second

first:
  %base2 = call i8 addrspace(1)* @def_ptr() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  br label %second

second:
  %phi = phi i8 addrspace(1)* [ %base1, %entry ], [ %base2, %first ]
  %base.i32 = bitcast i8 addrspace(1)* %phi to i32 addrspace(1)*
  %vec = getelementptr i32, i32 addrspace(1)* %base.i32, <2 x i64> %offsets
  %ptr = extractelement <2 x i32 addrspace(1)*> %vec, i32 1
  call void @do_safepoint() [ "deopt"(i32 0, i32 -1, i32 0, i32 0, i32 0) ]
  ret i32 addrspace(1)* %ptr
}

define i32 addrspace(1)* @test2(i8 addrspace(1)* %base, <2 x i64> %offsets) gc "statepoint-example" {
; CHECK-LABEL: @test2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE_I32:%.*]] = bitcast i8 addrspace(1)* [[BASE:%.*]] to i32 addrspace(1)*
; CHECK-NEXT:    [[CAST:%.*]] = bitcast i8 addrspace(1)* [[BASE]] to i32 addrspace(1)*
; CHECK-NEXT:    [[DOTSPLATINSERT_BASE:%.*]] = insertelement <2 x i32 addrspace(1)*> zeroinitializer, i32 addrspace(1)* [[CAST]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <2 x i32 addrspace(1)*> undef, i32 addrspace(1)* [[BASE_I32]], i32 0
; CHECK-NEXT:    [[DOTSPLAT_BASE:%.*]] = shufflevector <2 x i32 addrspace(1)*> [[DOTSPLATINSERT_BASE]], <2 x i32 addrspace(1)*> zeroinitializer, <2 x i32> zeroinitializer, !is_base_value !0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <2 x i32 addrspace(1)*> [[DOTSPLATINSERT]], <2 x i32 addrspace(1)*> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC:%.*]] = getelementptr i32, <2 x i32 addrspace(1)*> [[DOTSPLAT]], <2 x i64> [[OFFSETS:%.*]]
; CHECK-NEXT:    [[PTR_BASE:%.*]] = extractelement <2 x i32 addrspace(1)*> [[DOTSPLAT_BASE]], i32 1, !is_base_value !0
; CHECK-NEXT:    [[PTR:%.*]] = extractelement <2 x i32 addrspace(1)*> [[VEC]], i32 1
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0, i32 addrspace(1)* [[PTR]], i32 addrspace(1)* [[PTR_BASE]])
; CHECK-NEXT:    [[PTR_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 8, i32 7)
; CHECK-NEXT:    [[PTR_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[PTR_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[PTR_BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 8, i32 8)
; CHECK-NEXT:    [[PTR_BASE_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[PTR_BASE_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    ret i32 addrspace(1)* [[PTR_RELOCATED_CASTED]]
;
entry:
  %base.i32 = bitcast i8 addrspace(1)* %base to i32 addrspace(1)*
  %vec = getelementptr i32, i32 addrspace(1)* %base.i32, <2 x i64> %offsets
  %ptr = extractelement <2 x i32 addrspace(1)*> %vec, i32 1
  call void @do_safepoint()
  ret i32 addrspace(1)* %ptr
}

define i32 addrspace(1)* @test3(<2 x i8 addrspace(1)*> %base, <2 x i64> %offsets) gc "statepoint-example" {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE_I32:%.*]] = bitcast <2 x i8 addrspace(1)*> [[BASE:%.*]] to <2 x i32 addrspace(1)*>
; CHECK-NEXT:    [[VEC:%.*]] = getelementptr i32, <2 x i32 addrspace(1)*> [[BASE_I32]], <2 x i64> [[OFFSETS:%.*]]
; CHECK-NEXT:    [[BASE_EE:%.*]] = extractelement <2 x i8 addrspace(1)*> [[BASE]], i32 1, !is_base_value !0
; CHECK-NEXT:    [[PTR:%.*]] = extractelement <2 x i32 addrspace(1)*> [[VEC]], i32 1
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0, i32 addrspace(1)* [[PTR]], i8 addrspace(1)* [[BASE_EE]])
; CHECK-NEXT:    [[PTR_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 8, i32 7)
; CHECK-NEXT:    [[PTR_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[PTR_RELOCATED]] to i32 addrspace(1)*
; CHECK-NEXT:    [[BASE_EE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 8, i32 8)
; CHECK-NEXT:    ret i32 addrspace(1)* [[PTR_RELOCATED_CASTED]]
;
entry:
  %base.i32 = bitcast <2 x i8 addrspace(1)*> %base to <2 x i32 addrspace(1)*>
  %vec = getelementptr i32, <2 x i32 addrspace(1)*> %base.i32, <2 x i64> %offsets
  %ptr = extractelement <2 x i32 addrspace(1)*> %vec, i32 1
  call void @do_safepoint()
  ret i32 addrspace(1)* %ptr
}

define i32 addrspace(1)* @test4(i8 addrspace(1)* %base, <2 x i64> %offsets) gc "statepoint-example" {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE_I32:%.*]] = bitcast i8 addrspace(1)* [[BASE:%.*]] to i32 addrspace(1)*
; CHECK-NEXT:    [[CAST:%.*]] = bitcast i8 addrspace(1)* [[BASE]] to i32 addrspace(1)*
; CHECK-NEXT:    [[DOTSPLATINSERT_BASE:%.*]] = insertelement <2 x i32 addrspace(1)*> zeroinitializer, i32 addrspace(1)* [[CAST]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[DOTSPLATINSERT:%.*]] = insertelement <2 x i32 addrspace(1)*> undef, i32 addrspace(1)* [[BASE_I32]], i32 0
; CHECK-NEXT:    [[DOTSPLAT_BASE:%.*]] = shufflevector <2 x i32 addrspace(1)*> [[DOTSPLATINSERT_BASE]], <2 x i32 addrspace(1)*> zeroinitializer, <2 x i32> zeroinitializer, !is_base_value !0
; CHECK-NEXT:    [[DOTSPLAT:%.*]] = shufflevector <2 x i32 addrspace(1)*> [[DOTSPLATINSERT]], <2 x i32 addrspace(1)*> undef, <2 x i32> zeroinitializer
; CHECK-NEXT:    [[VEC:%.*]] = getelementptr i32, <2 x i32 addrspace(1)*> [[DOTSPLAT]], <2 x i64> [[OFFSETS:%.*]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0, <2 x i32 addrspace(1)*> [[VEC]], <2 x i32 addrspace(1)*> [[DOTSPLAT_BASE]])
; CHECK-NEXT:    [[VEC_RELOCATED:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[STATEPOINT_TOKEN]], i32 8, i32 7)
; CHECK-NEXT:    [[VEC_RELOCATED_CASTED:%.*]] = bitcast <2 x i8 addrspace(1)*> [[VEC_RELOCATED]] to <2 x i32 addrspace(1)*>
; CHECK-NEXT:    [[DOTSPLAT_BASE_RELOCATED:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[STATEPOINT_TOKEN]], i32 8, i32 8)
; CHECK-NEXT:    [[DOTSPLAT_BASE_RELOCATED_CASTED:%.*]] = bitcast <2 x i8 addrspace(1)*> [[DOTSPLAT_BASE_RELOCATED]] to <2 x i32 addrspace(1)*>
; CHECK-NEXT:    [[PTR:%.*]] = extractelement <2 x i32 addrspace(1)*> [[VEC_RELOCATED_CASTED]], i32 1
; CHECK-NEXT:    ret i32 addrspace(1)* [[PTR]]
;
entry:
  %base.i32 = bitcast i8 addrspace(1)* %base to i32 addrspace(1)*
  %vec = getelementptr i32, i32 addrspace(1)* %base.i32, <2 x i64> %offsets
  call void @do_safepoint()
  %ptr = extractelement <2 x i32 addrspace(1)*> %vec, i32 1
  ret i32 addrspace(1)* %ptr
}

define i32 addrspace(1)* @test5(<2 x i8 addrspace(1)*> %base, <2 x i64> %offsets) gc "statepoint-example" {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[BASE_I32:%.*]] = bitcast <2 x i8 addrspace(1)*> [[BASE:%.*]] to <2 x i32 addrspace(1)*>
; CHECK-NEXT:    [[VEC:%.*]] = getelementptr i32, <2 x i32 addrspace(1)*> [[BASE_I32]], <2 x i64> [[OFFSETS:%.*]]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @do_safepoint, i32 0, i32 0, i32 0, i32 0, <2 x i8 addrspace(1)*> [[BASE]])
; CHECK-NEXT:    [[BASE_RELOCATED:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[STATEPOINT_TOKEN]], i32 7, i32 7)
; CHECK-NEXT:    [[BASE_I32_REMAT:%.*]] = bitcast <2 x i8 addrspace(1)*> [[BASE_RELOCATED]] to <2 x i32 addrspace(1)*>
; CHECK-NEXT:    [[VEC_REMAT:%.*]] = getelementptr i32, <2 x i32 addrspace(1)*> [[BASE_I32_REMAT]], <2 x i64> [[OFFSETS]]
; CHECK-NEXT:    [[PTR:%.*]] = extractelement <2 x i32 addrspace(1)*> [[VEC_REMAT]], i32 0
; CHECK-NEXT:    ret i32 addrspace(1)* [[PTR]]
;
entry:
  %base.i32 = bitcast <2 x i8 addrspace(1)*> %base to <2 x i32 addrspace(1)*>
  %vec = getelementptr i32, <2 x i32 addrspace(1)*> %base.i32, <2 x i64> %offsets
  call void @do_safepoint()
  %ptr = extractelement <2 x i32 addrspace(1)*> %vec, i32 0
  ret i32 addrspace(1)* %ptr
}

define void @test6() gc "statepoint-example" {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br label [[HEADER:%.*]]
; CHECK:       header:
; CHECK-NEXT:    [[TMP_BASE:%.*]] = phi i8 addrspace(1)* [ [[TMP6_BASE:%.*]], [[LATCH:%.*]] ], [ null, [[BB:%.*]] ], !is_base_value !0
; CHECK-NEXT:    [[TMP:%.*]] = phi i8 addrspace(1)* [ [[TMP6:%.*]], [[LATCH]] ], [ undef, [[BB]] ]
; CHECK-NEXT:    br label [[BB10:%.*]]
; CHECK:       bb10:
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* @spam, i32 0, i32 0, i32 0, i32 0, i8 addrspace(1)* [[TMP]], i8 addrspace(1)* [[TMP_BASE]]) [ "deopt"(i8 addrspace(1)* [[TMP]]) ]
; CHECK-NEXT:    [[TMP_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 8, i32 7)
; CHECK-NEXT:    [[TMP_BASE_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 8, i32 8)
; CHECK-NEXT:    br label [[BB25:%.*]]
; CHECK:       bb25:
; CHECK-NEXT:    [[STATEPOINT_TOKEN1:%.*]] = call token (i64, i32, <2 x i8 addrspace(1)*> ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_v2p1i8f(i64 2882400000, i32 0, <2 x i8 addrspace(1)*> ()* @baz, i32 0, i32 0, i32 0, i32 0)
; CHECK-NEXT:    [[TMP262:%.*]] = call <2 x i8 addrspace(1)*> @llvm.experimental.gc.result.v2p1i8(token [[STATEPOINT_TOKEN1]])
; CHECK-NEXT:    [[BASE_EE:%.*]] = extractelement <2 x i8 addrspace(1)*> [[TMP262]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[TMP27:%.*]] = extractelement <2 x i8 addrspace(1)*> [[TMP262]], i32 0
; CHECK-NEXT:    br i1 undef, label [[BB7:%.*]], label [[LATCH]]
; CHECK:       bb7:
; CHECK-NEXT:    br label [[LATCH]]
; CHECK:       latch:
; CHECK-NEXT:    [[TMP6_BASE]] = phi i8 addrspace(1)* [ [[BASE_EE]], [[BB25]] ], [ [[BASE_EE]], [[BB7]] ], !is_base_value !0
; CHECK-NEXT:    [[TMP6]] = phi i8 addrspace(1)* [ [[TMP27]], [[BB25]] ], [ [[TMP27]], [[BB7]] ]
; CHECK-NEXT:    br label [[HEADER]]
;
bb:
  br label %header

header:                                              ; preds = %latch, %bb
  %tmp = phi i8 addrspace(1)* [ %tmp6, %latch ], [ undef, %bb ]
  br label %bb10

bb10:                                             ; preds = %bb2
  call void @spam() [ "deopt"(i8 addrspace(1)* %tmp) ]
  br label %bb25

bb25:                                             ; preds = %bb24
  %tmp26 = call <2 x i8 addrspace(1)*> @baz()
  %tmp27 = extractelement <2 x i8 addrspace(1)*> %tmp26, i32 0
  br i1 undef, label %bb7, label %latch

bb7:                                              ; preds = %bb25
  br label %latch

latch:                                              ; preds = %bb25, %bb7
  %tmp6 = phi i8 addrspace(1)* [ %tmp27, %bb25 ], [ %tmp27, %bb7 ]
  br label %header
}

declare void @spam()
declare <2 x i8 addrspace(1)*> @baz()
