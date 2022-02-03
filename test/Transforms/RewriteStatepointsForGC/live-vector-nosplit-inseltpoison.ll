; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; Test that we can correctly handle vectors of pointers in statepoint
; rewriting.
; RUN: opt < %s -rewrite-statepoints-for-gc -S | FileCheck  %s
; RUN: opt < %s -passes=rewrite-statepoints-for-gc -S | FileCheck  %s

; A non-vector relocation for comparison
define i64 addrspace(1)* @test(i64 addrspace(1)* %obj) gc "statepoint-example" {
; CHECK-LABEL: @test(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(i64 addrspace(1)* [[OBJ:%.*]]) ]
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc i8 addrspace(1)* @llvm.experimental.gc.relocate.p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[OBJ_RELOCATED_CASTED:%.*]] = bitcast i8 addrspace(1)* [[OBJ_RELOCATED]] to i64 addrspace(1)*
; CHECK-NEXT:    ret i64 addrspace(1)* [[OBJ_RELOCATED_CASTED]]
;
; A base vector from a argument
entry:
  call void @do_safepoint() [ "deopt"() ]
  ret i64 addrspace(1)* %obj
}

; A vector argument
define <2 x i64 addrspace(1)*> @test2(<2 x i64 addrspace(1)*> %obj) gc "statepoint-example" {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(<2 x i64 addrspace(1)*> [[OBJ:%.*]]) ]
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[OBJ_RELOCATED_CASTED:%.*]] = bitcast <2 x i8 addrspace(1)*> [[OBJ_RELOCATED]] to <2 x i64 addrspace(1)*>
; CHECK-NEXT:    ret <2 x i64 addrspace(1)*> [[OBJ_RELOCATED_CASTED]]
;
  call void @do_safepoint() [ "deopt"() ]
  ret <2 x i64 addrspace(1)*> %obj
}

; A load
define <2 x i64 addrspace(1)*> @test3(<2 x i64 addrspace(1)*>* %ptr) gc "statepoint-example" {
; CHECK-LABEL: @test3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OBJ:%.*]] = load <2 x i64 addrspace(1)*>, <2 x i64 addrspace(1)*>* [[PTR:%.*]], align 16
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(<2 x i64 addrspace(1)*> [[OBJ]]) ]
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[OBJ_RELOCATED_CASTED:%.*]] = bitcast <2 x i8 addrspace(1)*> [[OBJ_RELOCATED]] to <2 x i64 addrspace(1)*>
; CHECK-NEXT:    ret <2 x i64 addrspace(1)*> [[OBJ_RELOCATED_CASTED]]
;
entry:
  %obj = load <2 x i64 addrspace(1)*>, <2 x i64 addrspace(1)*>* %ptr
  call void @do_safepoint() [ "deopt"() ]
  ret <2 x i64 addrspace(1)*> %obj
}

declare i32 @fake_personality_function()

; When a statepoint is an invoke rather than a call
define <2 x i64 addrspace(1)*> @test4(<2 x i64 addrspace(1)*>* %ptr) gc "statepoint-example" personality i32 ()* @fake_personality_function {
; CHECK-LABEL: @test4(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[OBJ:%.*]] = load <2 x i64 addrspace(1)*>, <2 x i64 addrspace(1)*>* [[PTR:%.*]], align 16
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = invoke token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(<2 x i64 addrspace(1)*> [[OBJ]]) ]
; CHECK-NEXT:    to label [[NORMAL_RETURN:%.*]] unwind label [[EXCEPTIONAL_RETURN:%.*]]
; CHECK:       normal_return:
; CHECK-NEXT:    [[OBJ_RELOCATED1:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[OBJ_RELOCATED1_CASTED:%.*]] = bitcast <2 x i8 addrspace(1)*> [[OBJ_RELOCATED1]] to <2 x i64 addrspace(1)*>
; CHECK-NEXT:    ret <2 x i64 addrspace(1)*> [[OBJ_RELOCATED1_CASTED]]
; CHECK:       exceptional_return:
; CHECK-NEXT:    [[LANDING_PAD4:%.*]] = landingpad token
; CHECK-NEXT:    cleanup
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[LANDING_PAD4]], i32 0, i32 0)
; CHECK-NEXT:    [[OBJ_RELOCATED_CASTED:%.*]] = bitcast <2 x i8 addrspace(1)*> [[OBJ_RELOCATED]] to <2 x i64 addrspace(1)*>
; CHECK-NEXT:    ret <2 x i64 addrspace(1)*> [[OBJ_RELOCATED_CASTED]]
;
entry:
  %obj = load <2 x i64 addrspace(1)*>, <2 x i64 addrspace(1)*>* %ptr
  invoke void @do_safepoint() [ "deopt"() ]
  to label %normal_return unwind label %exceptional_return

normal_return:                                    ; preds = %entry
  ret <2 x i64 addrspace(1)*> %obj

exceptional_return:                               ; preds = %entry
  %landing_pad4 = landingpad token
  cleanup
  ret <2 x i64 addrspace(1)*> %obj
}

; A newly created vector
define <2 x i64 addrspace(1)*> @test5(i64 addrspace(1)* %p) gc "statepoint-example" {
; CHECK-LABEL: @test5(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VEC_BASE:%.*]] = insertelement <2 x i64 addrspace(1)*> zeroinitializer, i64 addrspace(1)* [[P:%.*]], i32 0, !is_base_value !0
; CHECK-NEXT:    [[VEC:%.*]] = insertelement <2 x i64 addrspace(1)*> poison, i64 addrspace(1)* [[P]], i32 0
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(<2 x i64 addrspace(1)*> [[VEC]], <2 x i64 addrspace(1)*> [[VEC_BASE]]) ]
; CHECK-NEXT:    [[VEC_RELOCATED:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 0)
; CHECK-NEXT:    [[VEC_RELOCATED_CASTED:%.*]] = bitcast <2 x i8 addrspace(1)*> [[VEC_RELOCATED]] to <2 x i64 addrspace(1)*>
; CHECK-NEXT:    [[VEC_BASE_RELOCATED:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[STATEPOINT_TOKEN]], i32 1, i32 1)
; CHECK-NEXT:    [[VEC_BASE_RELOCATED_CASTED:%.*]] = bitcast <2 x i8 addrspace(1)*> [[VEC_BASE_RELOCATED]] to <2 x i64 addrspace(1)*>
; CHECK-NEXT:    ret <2 x i64 addrspace(1)*> [[VEC_RELOCATED_CASTED]]
;
entry:
  %vec = insertelement <2 x i64 addrspace(1)*> poison, i64 addrspace(1)* %p, i32 0
  call void @do_safepoint() [ "deopt"() ]
  ret <2 x i64 addrspace(1)*> %vec
}

; A merge point
define <2 x i64 addrspace(1)*> @test6(i1 %cnd, <2 x i64 addrspace(1)*>* %ptr) gc "statepoint-example" {
; CHECK-LABEL: @test6(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[CND:%.*]], label [[TAKEN:%.*]], label [[UNTAKEN:%.*]]
; CHECK:       taken:
; CHECK-NEXT:    [[OBJA:%.*]] = load <2 x i64 addrspace(1)*>, <2 x i64 addrspace(1)*>* [[PTR:%.*]], align 16
; CHECK-NEXT:    br label [[MERGE:%.*]]
; CHECK:       untaken:
; CHECK-NEXT:    [[OBJB:%.*]] = load <2 x i64 addrspace(1)*>, <2 x i64 addrspace(1)*>* [[PTR]], align 16
; CHECK-NEXT:    br label [[MERGE]]
; CHECK:       merge:
; CHECK-NEXT:    [[OBJ:%.*]] = phi <2 x i64 addrspace(1)*> [ [[OBJA]], [[TAKEN]] ], [ [[OBJB]], [[UNTAKEN]] ]
; CHECK-NEXT:    [[STATEPOINT_TOKEN:%.*]] = call token (i64, i32, void ()*, i32, i32, ...) @llvm.experimental.gc.statepoint.p0f_isVoidf(i64 2882400000, i32 0, void ()* elementtype(void ()) @do_safepoint, i32 0, i32 0, i32 0, i32 0) [ "deopt"(), "gc-live"(<2 x i64 addrspace(1)*> [[OBJ]]) ]
; CHECK-NEXT:    [[OBJ_RELOCATED:%.*]] = call coldcc <2 x i8 addrspace(1)*> @llvm.experimental.gc.relocate.v2p1i8(token [[STATEPOINT_TOKEN]], i32 0, i32 0)
; CHECK-NEXT:    [[OBJ_RELOCATED_CASTED:%.*]] = bitcast <2 x i8 addrspace(1)*> [[OBJ_RELOCATED]] to <2 x i64 addrspace(1)*>
; CHECK-NEXT:    ret <2 x i64 addrspace(1)*> [[OBJ_RELOCATED_CASTED]]
;
entry:
  br i1 %cnd, label %taken, label %untaken

taken:                                            ; preds = %entry
  %obja = load <2 x i64 addrspace(1)*>, <2 x i64 addrspace(1)*>* %ptr
  br label %merge

untaken:                                          ; preds = %entry
  %objb = load <2 x i64 addrspace(1)*>, <2 x i64 addrspace(1)*>* %ptr
  br label %merge

merge:                                            ; preds = %untaken, %taken
  %obj = phi <2 x i64 addrspace(1)*> [ %obja, %taken ], [ %objb, %untaken ]
  call void @do_safepoint() [ "deopt"() ]
  ret <2 x i64 addrspace(1)*> %obj
}

declare void @do_safepoint()
